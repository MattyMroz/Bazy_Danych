-- ============================================================================
-- PLIK: 08_widoki.sql
-- PROJEKT: Szkoła Muzyczna v5 - Obiektowa Baza Danych Oracle
-- AUTORZY: Igor Typiński (251237), Mateusz Mróz (251190)
-- DATA: Styczeń 2026
-- ============================================================================
--
-- CO TEN PLIK ROBI?
-- -----------------
-- Tworzy WIDOKI (VIEW) - wirtualne tabele upraszczające zapytania
-- i zapewniające bezpieczeństwo na poziomie wierszy.
--
-- RODZAJE WIDOKÓW:
-- ================
--
-- 1. WIDOKI BEZPIECZEŃSTWA (v_moje_*)
--    Filtrują dane do widocznych dla zalogowanego użytkownika.
--    Używają SYS_CONTEXT do identyfikacji użytkownika.
--
-- 2. WIDOKI RAPORTOWE (v_raport_*)
--    Łączą dane z wielu tabel w czytelną formę.
--    Rozwiązują REF-y do wartości.
--
-- 3. WIDOKI POMOCNICZE (v_*)
--    Upraszczają częste zapytania.
--
-- DEREF W WIDOKACH:
-- =================
-- 
-- Problem: REF przechowuje wskaźnik (OID), nie wartość.
-- Rozwiązanie: DEREF() w definicji widoku.
--
-- Przykład:
--   SELECT DEREF(ref_nauczyciel).nazwisko AS nauczyciel
--   FROM t_lekcja;
--
-- Wynik: "Kowalski" zamiast "000028020946A3CF..."
--
-- JAK URUCHOMIĆ?
-- --------------
-- WYMAGANIE: 01-05 skrypty muszą być wykonane
-- @08_widoki.sql
--
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200

PROMPT ╔═══════════════════════════════════════════════════════════════╗
PROMPT ║  08_widoki.sql - Tworzenie widoków                            ║
PROMPT ╚═══════════════════════════════════════════════════════════════╝
PROMPT

-- ============================================================================
-- WIDOK 1: v_lekcje_szczegoly
-- ============================================================================
--
-- CEL: Rozwiązanie wszystkich REF-ów w tabeli t_lekcja
--
-- PROBLEM:
--   SELECT * FROM t_lekcja;
--   → Wyświetla: ref_nauczyciel = 000028020946A3CF... (nieczytelne!)
--
-- ROZWIĄZANIE:
--   SELECT * FROM v_lekcje_szczegoly;
--   → Wyświetla: nauczyciel = "Jan Kowalski" (czytelne!)
--
-- UWAGA: DEREF może być kosztowne! Dla dużych tabel użyj indeksów.
--
-- ============================================================================

PROMPT [1/8] Tworzenie v_lekcje_szczegoly...

CREATE OR REPLACE VIEW v_lekcje_szczegoly AS
SELECT 
    -- Podstawowe dane lekcji
    l.id_lekcji,
    l.typ_lekcji,
    l.data_lekcji,
    -- Format dnia tygodnia (PN, WT, ŚR...)
    TO_CHAR(l.data_lekcji, 'DY', 'NLS_DATE_LANGUAGE=POLISH') AS dzien_tyg,
    l.godzina_start,
    l.czas_trwania,
    l.status AS status_lekcji,
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- DEREF - rozwiązanie REF-ów do wartości
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- Sala (DEREF → obiekt → atrybut)
    DEREF(l.ref_sala).id_sali       AS id_sali,
    DEREF(l.ref_sala).numer_sali    AS numer_sali,
    DEREF(l.ref_sala).typ_sali      AS typ_sali,
    
    -- Nauczyciel
    DEREF(l.ref_nauczyciel).id_nauczyciela AS id_nauczyciela,
    DEREF(l.ref_nauczyciel).imie || ' ' || 
    DEREF(l.ref_nauczyciel).nazwisko       AS nauczyciel,
    
    -- Przedmiot
    DEREF(l.ref_przedmiot).id_przedmiotu AS id_przedmiotu,
    DEREF(l.ref_przedmiot).nazwa         AS przedmiot,
    
    -- Semestr
    DEREF(l.ref_semestr).id_semestru       AS id_semestru,
    DEREF(l.ref_semestr).nazwa_semestru || ' ' ||
    DEREF(l.ref_semestr).rok_akademicki    AS semestr,
    
    -- Uczeń (może być NULL dla lekcji grupowych!)
    DEREF(l.ref_uczen).id_ucznia AS id_ucznia,
    CASE 
        WHEN l.ref_uczen IS NOT NULL THEN
            DEREF(l.ref_uczen).imie || ' ' || DEREF(l.ref_uczen).nazwisko
        ELSE NULL
    END AS uczen,
    
    -- Grupa (może być NULL dla lekcji indywidualnych!)
    DEREF(l.ref_grupa).id_grupy AS id_grupy,
    CASE
        WHEN l.ref_grupa IS NOT NULL THEN
            DEREF(l.ref_grupa).nazwa_grupy
        ELSE NULL
    END AS grupa

FROM t_lekcja l;

COMMENT ON VIEW v_lekcje_szczegoly IS 
'Widok lekcji z rozwiązanymi REF-ami - czytelna forma danych';

-- ============================================================================
-- WIDOK 2: v_oceny_szczegoly
-- ============================================================================

PROMPT [2/8] Tworzenie v_oceny_szczegoly...

CREATE OR REPLACE VIEW v_oceny_szczegoly AS
SELECT
    o.id_oceny,
    o.wartosc,
    o.data_oceny,
    o.opis,
    
    -- Uczeń
    DEREF(o.ref_uczen).id_ucznia AS id_ucznia,
    DEREF(o.ref_uczen).imie || ' ' ||
    DEREF(o.ref_uczen).nazwisko AS uczen,
    
    -- Przedmiot
    DEREF(o.ref_przedmiot).id_przedmiotu AS id_przedmiotu,
    DEREF(o.ref_przedmiot).nazwa AS przedmiot,
    
    -- Nauczyciel (wystawiający)
    DEREF(o.ref_nauczyciel).id_nauczyciela AS id_nauczyciela,
    DEREF(o.ref_nauczyciel).imie || ' ' ||
    DEREF(o.ref_nauczyciel).nazwisko AS nauczyciel,
    
    -- Semestr
    DEREF(o.ref_semestr).id_semestru AS id_semestru,
    DEREF(o.ref_semestr).nazwa_semestru || ' ' ||
    DEREF(o.ref_semestr).rok_akademicki AS semestr

FROM t_ocena o;

COMMENT ON VIEW v_oceny_szczegoly IS 
'Widok ocen z rozwiązanymi REF-ami';

-- ============================================================================
-- WIDOK 3: v_egzaminy_szczegoly
-- ============================================================================

PROMPT [3/8] Tworzenie v_egzaminy_szczegoly...

CREATE OR REPLACE VIEW v_egzaminy_szczegoly AS
SELECT
    e.id_egzaminu,
    e.data_egzaminu,
    TO_CHAR(e.data_egzaminu, 'DY DD.MM.YYYY', 'NLS_DATE_LANGUAGE=POLISH') AS data_pelna,
    e.rodzaj_egzaminu,
    e.ocena_koncowa,
    
    -- Uczeń
    DEREF(e.ref_uczen).id_ucznia AS id_ucznia,
    DEREF(e.ref_uczen).imie || ' ' ||
    DEREF(e.ref_uczen).nazwisko AS uczen,
    DEREF(e.ref_uczen).klasa AS klasa_ucznia,
    
    -- Przedmiot
    DEREF(e.ref_przedmiot).nazwa AS przedmiot,
    
    -- Komisja
    DEREF(e.ref_komisja1).imie || ' ' ||
    DEREF(e.ref_komisja1).nazwisko AS komisja1,
    DEREF(e.ref_komisja2).imie || ' ' ||
    DEREF(e.ref_komisja2).nazwisko AS komisja2,
    
    -- Sala
    DEREF(e.ref_sala).numer_sali AS sala

FROM t_egzamin e;

COMMENT ON VIEW v_egzaminy_szczegoly IS 
'Widok egzaminów z rozwiązanymi REF-ami';

-- ============================================================================
-- WIDOK 4: v_uczniowie_szczegoly
-- ============================================================================

PROMPT [4/8] Tworzenie v_uczniowie_szczegoly...

CREATE OR REPLACE VIEW v_uczniowie_szczegoly AS
SELECT
    u.id_ucznia,
    u.imie,
    u.nazwisko,
    u.imie || ' ' || u.nazwisko AS pelne_imie,
    u.data_urodzenia,
    -- Obliczenie wieku
    TRUNC(MONTHS_BETWEEN(SYSDATE, u.data_urodzenia) / 12) AS wiek,
    u.typ_ucznia,
    -- Czytelna forma typu ucznia
    CASE u.typ_ucznia
        WHEN 'uczacy_sie_w_innej_szkole' THEN 'Uczy się w innej szkole (lekcje od 15:00)'
        WHEN 'ukonczyl_edukacje' THEN 'Ukończył edukację (lekcje od 14:00)'
        WHEN 'tylko_muzyczna' THEN 'Tylko muzyczna (lekcje od 14:00)'
    END AS typ_ucznia_opis,
    u.data_zapisu,
    u.klasa,
    u.cykl_nauczania,
    u.status,
    
    -- Instrument główny
    DEREF(u.ref_instrument).id_instrumentu AS id_instrumentu,
    DEREF(u.ref_instrument).nazwa AS instrument,
    DEREF(u.ref_instrument).rodzaj AS rodzaj_instrumentu,
    
    -- Nauczyciel prowadzący
    DEREF(u.ref_nauczyciel).id_nauczyciela AS id_nauczyciela,
    DEREF(u.ref_nauczyciel).imie || ' ' ||
    DEREF(u.ref_nauczyciel).nazwisko AS nauczyciel

FROM t_uczen u;

COMMENT ON VIEW v_uczniowie_szczegoly IS 
'Widok uczniów z obliczonym wiekiem i rozwiązanymi REF-ami';

-- ============================================================================
-- WIDOK 5: v_nauczyciele_szczegoly
-- ============================================================================

PROMPT [5/8] Tworzenie v_nauczyciele_szczegoly...

CREATE OR REPLACE VIEW v_nauczyciele_szczegoly AS
SELECT
    n.id_nauczyciela,
    n.imie,
    n.nazwisko,
    n.imie || ' ' || n.nazwisko AS pelne_imie,
    n.email,
    n.data_zatrudnienia,
    -- Staż pracy w latach
    TRUNC(MONTHS_BETWEEN(SYSDATE, n.data_zatrudnienia) / 12) AS staz_lat,
    n.status,
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- VARRAY → STRING
    -- ═══════════════════════════════════════════════════════════════════════
    -- Problem: VARRAY nie da się łatwo wyświetlić
    -- Rozwiązanie: Własna funkcja lub LISTAGG z TABLE()
    -- ═══════════════════════════════════════════════════════════════════════
    (
        SELECT LISTAGG(COLUMN_VALUE, ', ') WITHIN GROUP (ORDER BY COLUMN_VALUE)
        FROM TABLE(n.instrumenty)
    ) AS instrumenty_lista,
    
    -- Liczba instrumentów
    n.instrumenty.COUNT AS liczba_instrumentow

FROM t_nauczyciel n;

COMMENT ON VIEW v_nauczyciele_szczegoly IS 
'Widok nauczycieli z listą instrumentów jako string';

-- ============================================================================
-- WIDOK 6: v_plan_tygodnia
-- ============================================================================
--
-- CEL: Widok planu lekcji w formacie tygodniowym
--
-- Używany przez pkg_raport.plan_ucznia() i plan_nauczyciela()
--
-- ============================================================================

PROMPT [6/8] Tworzenie v_plan_tygodnia...

CREATE OR REPLACE VIEW v_plan_tygodnia AS
SELECT
    l.id_lekcji,
    l.data_lekcji,
    -- Numer dnia tygodnia (1=Poniedziałek, 7=Niedziela)
    TO_NUMBER(TO_CHAR(l.data_lekcji, 'D')) AS dzien_nr,
    TO_CHAR(l.data_lekcji, 'DY', 'NLS_DATE_LANGUAGE=POLISH') AS dzien_skrot,
    TO_CHAR(l.data_lekcji, 'DAY', 'NLS_DATE_LANGUAGE=POLISH') AS dzien_pelny,
    l.godzina_start,
    -- Obliczenie godziny końca
    TO_CHAR(
        TO_DATE(l.godzina_start, 'HH24:MI') + (l.czas_trwania / 24 / 60),
        'HH24:MI'
    ) AS godzina_koniec,
    l.czas_trwania,
    l.typ_lekcji,
    l.status AS status_lekcji,
    
    -- REF-y rozwiązane
    DEREF(l.ref_sala).numer_sali AS sala,
    DEREF(l.ref_nauczyciel).id_nauczyciela AS id_nauczyciela,
    DEREF(l.ref_nauczyciel).imie || ' ' ||
    DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
    DEREF(l.ref_przedmiot).nazwa AS przedmiot,
    
    -- Uczeń/Grupa
    DEREF(l.ref_uczen).id_ucznia AS id_ucznia,
    CASE 
        WHEN l.ref_uczen IS NOT NULL THEN
            DEREF(l.ref_uczen).imie || ' ' || DEREF(l.ref_uczen).nazwisko
        ELSE
            DEREF(l.ref_grupa).nazwa_grupy
    END AS odbiorca,
    
    -- Tydzień roku (do grupowania)
    TO_CHAR(l.data_lekcji, 'IW') AS tydzien_roku,
    -- Poniedziałek tego tygodnia
    TRUNC(l.data_lekcji, 'IW') AS poniedzialek_tygodnia

FROM t_lekcja l
WHERE l.status IN ('zaplanowana', 'odbyta');

COMMENT ON VIEW v_plan_tygodnia IS 
'Widok planu lekcji z obliczonymi dodatkowymi polami';

-- ============================================================================
-- WIDOK 7: v_statystyki_nauczycieli
-- ============================================================================
--
-- CEL: Statystyki obciążenia nauczycieli
--
-- ============================================================================

PROMPT [7/8] Tworzenie v_statystyki_nauczycieli...

CREATE OR REPLACE VIEW v_statystyki_nauczycieli AS
SELECT
    n.id_nauczyciela,
    n.imie || ' ' || n.nazwisko AS nauczyciel,
    n.status,
    
    -- Liczba lekcji w bieżącym semestrze
    (
        SELECT COUNT(*)
        FROM t_lekcja l
        WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = n.id_nauczyciela
          AND l.status IN ('zaplanowana', 'odbyta')
    ) AS liczba_lekcji,
    
    -- Suma godzin (minuty/60)
    (
        SELECT NVL(SUM(l.czas_trwania), 0) / 60
        FROM t_lekcja l
        WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = n.id_nauczyciela
          AND l.status IN ('zaplanowana', 'odbyta')
    ) AS suma_godzin,
    
    -- Liczba uczniów indywidualnych
    (
        SELECT COUNT(DISTINCT DEREF(l.ref_uczen).id_ucznia)
        FROM t_lekcja l
        WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = n.id_nauczyciela
          AND l.typ_lekcji = 'indywidualna'
    ) AS liczba_uczniow,
    
    -- Średnia ocen wystawionych
    (
        SELECT ROUND(AVG(o.wartosc), 2)
        FROM t_ocena o
        WHERE DEREF(o.ref_nauczyciel).id_nauczyciela = n.id_nauczyciela
    ) AS srednia_ocen

FROM t_nauczyciel n
WHERE n.status = 'aktywny';

COMMENT ON VIEW v_statystyki_nauczycieli IS 
'Widok statystyk obciążenia nauczycieli';

-- ============================================================================
-- WIDOK 8: v_wolne_sloty
-- ============================================================================
--
-- CEL: Znajdowanie wolnych slotów czasowych dla planowania
--
-- UWAGA: To jest widok pomocniczy, ale pełna implementacja
-- wymagałaby bardziej złożonej logiki (generowanie wszystkich
-- możliwych slotów i wykluczanie zajętych).
--
-- ============================================================================

PROMPT [8/8] Tworzenie v_wolne_sloty...

CREATE OR REPLACE VIEW v_wolne_sloty AS
SELECT
    s.id_sali,
    s.numer_sali,
    s.typ_sali,
    s.pojemnosc,
    d.data_dzien,
    TO_CHAR(d.data_dzien, 'DY', 'NLS_DATE_LANGUAGE=POLISH') AS dzien_tyg,
    
    -- Zlicz zajęte godziny w tym dniu
    (
        SELECT NVL(SUM(l.czas_trwania), 0) / 60
        FROM t_lekcja l
        WHERE DEREF(l.ref_sala).id_sali = s.id_sali
          AND l.data_lekcji = d.data_dzien
          AND l.status IN ('zaplanowana', 'odbyta')
    ) AS zajete_godzin,
    
    -- Dostępne godziny (8h dziennie - zajęte)
    8 - (
        SELECT NVL(SUM(l.czas_trwania), 0) / 60
        FROM t_lekcja l
        WHERE DEREF(l.ref_sala).id_sali = s.id_sali
          AND l.data_lekcji = d.data_dzien
          AND l.status IN ('zaplanowana', 'odbyta')
    ) AS wolne_godzin

FROM t_sala s
CROSS JOIN (
    -- Generator dat: najbliższe 7 dni
    SELECT TRUNC(SYSDATE) + LEVEL - 1 AS data_dzien
    FROM DUAL
    CONNECT BY LEVEL <= 7
) d
WHERE s.status = 'dostepna'
ORDER BY s.numer_sali, d.data_dzien;

COMMENT ON VIEW v_wolne_sloty IS 
'Widok wolnych godzin w salach na najbliższe 7 dni';

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================

PROMPT
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT   PODSUMOWANIE - Utworzone widoki
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT
PROMPT   WIDOKI SZCZEGÓŁOWE (rozwiązują REF-y):
PROMPT     [✓] v_lekcje_szczegoly      - lekcje z czytelnym opisem
PROMPT     [✓] v_oceny_szczegoly       - oceny z danymi ucznia/nauczyciela
PROMPT     [✓] v_egzaminy_szczegoly    - egzaminy z komisją
PROMPT     [✓] v_uczniowie_szczegoly   - uczniowie z wiekiem i instrumentem
PROMPT     [✓] v_nauczyciele_szczegoly - nauczyciele z listą instrumentów
PROMPT
PROMPT   WIDOKI RAPORTOWE:
PROMPT     [✓] v_plan_tygodnia           - plan z obliczonymi godzinami
PROMPT     [✓] v_statystyki_nauczycieli  - obciążenie nauczycieli
PROMPT     [✓] v_wolne_sloty             - wolne godziny w salach
PROMPT
PROMPT   UŻYCIE:
PROMPT     -- Zamiast:
PROMPT     SELECT DEREF(ref_nauczyciel).nazwisko FROM t_lekcja;
PROMPT     -- Użyj:
PROMPT     SELECT nauczyciel FROM v_lekcje_szczegoly;
PROMPT
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT   Następny krok: Uruchom 09_testy.sql
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT

-- Lista widoków
SELECT view_name, text_length
FROM user_views
WHERE view_name LIKE 'V\_%' ESCAPE '\'
ORDER BY view_name;
