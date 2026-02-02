-- ============================================================================
-- SZKOŁA MUZYCZNA I STOPNIA - SCENARIUSZE DEMONSTRACYJNE
-- Autorzy: Igor Typiński (251237), Mateusz Mróz (251190)
-- ============================================================================
-- Jednolinijkowe wywołania (jak live coding na prezentacji)
-- UWAGA: Scenariusze 3-5 dodają dane - przed ponownym uruchomieniem
--        należy wykonać skrypty 01-05 od nowa lub usunąć dane ręcznie!
-- ============================================================================

SET SERVEROUTPUT ON;

-- ============================================================================
-- CZYSZCZENIE DANYCH SCENARIUSZY (opcjonalne - odkomentuj przy ponownym uruchomieniu)
-- ============================================================================
-- DELETE FROM lekcje WHERE data_lekcji = DATE '2025-06-09';
-- DELETE FROM oceny WHERE DEREF(ref_uczen).id IN (SELECT id FROM uczniowie WHERE imie = 'Nowy');
-- DELETE FROM uczniowie WHERE imie = 'Nowy' AND nazwisko = 'Uczeń';
-- DELETE FROM nauczyciele WHERE imie = 'Zofia' AND nazwisko = 'Flecista';
-- DELETE FROM przedmioty WHERE nazwa = 'Flet';
-- COMMIT;

-- ============================================================================
-- SCENARIUSZ 1: Listy (słowniki)
-- ============================================================================
EXEC pkg_slowniki.lista_przedmiotow;
EXEC pkg_slowniki.lista_sal;
EXEC pkg_slowniki.lista_grup;

-- ============================================================================
-- SCENARIUSZ 2: Listy osób
-- ============================================================================
EXEC pkg_osoby.lista_nauczycieli;
EXEC pkg_osoby.lista_uczniow;
EXEC pkg_osoby.lista_uczniow_w_grupie(1);  -- grupa o ID=1 (1A)

-- ============================================================================
-- SCENARIUSZ 3: Dodawanie nauczyciela (NOWY!)
-- Uruchom tylko RAZ lub odkomentuj czyszczenie powyżej
-- ============================================================================
-- Dodajemy nowego nauczyciela od fletu
EXEC pkg_slowniki.dodaj_przedmiot('Flet', 'indywidualny');
EXEC pkg_osoby.dodaj_nauczyciela('Zofia', 'Flecista', 'Flet');
EXEC pkg_osoby.lista_nauczycieli;

-- ============================================================================
-- SCENARIUSZ 4: Dodawanie ucznia
-- Uruchom tylko RAZ lub odkomentuj czyszczenie powyżej
-- ============================================================================
EXEC pkg_osoby.dodaj_ucznia('Nowy', 'Uczeń', DATE '2016-05-15', 'Flet', '2A');
EXEC pkg_osoby.lista_uczniow_w_grupie(2);  -- grupa o ID=2 (2A)

-- ============================================================================
-- SCENARIUSZ 5: Dodawanie lekcji (po ID!)
-- Uruchom tylko RAZ lub odkomentuj czyszczenie powyżej
-- ============================================================================
-- Lekcja indywidualna: przedmiot=1, nauczyciel=1, sala=1, uczeń=1, data, godz
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 1, DATE '2025-06-09', 14);

-- Lekcja grupowa: przedmiot=4, nauczyciel=4, sala=4, grupa=1, data, godz
EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 4, 1, DATE '2025-06-09', 16);

-- ============================================================================
-- SCENARIUSZ 6: Plany (po ID!)
-- ============================================================================
-- Plan ucznia o ID=1 (Adam Adamski)
EXEC pkg_lekcje.plan_ucznia(1);

-- Plan nauczyciela o ID=1 (Anna Kowalska)
EXEC pkg_lekcje.plan_nauczyciela(1);

-- Plan sali o ID=1 (sala 101)
EXEC pkg_lekcje.plan_sali(1);

-- Plan dnia
EXEC pkg_lekcje.plan_dnia(DATE '2025-06-02');

-- ============================================================================
-- SCENARIUSZ 7: Oceny (po ID!)
-- ============================================================================
-- Wystawianie oceny: uczeń=1, nauczyciel=1, przedmiot=1, wartość
EXEC pkg_oceny.wystaw_ocene(1, 1, 1, 5);
EXEC pkg_oceny.wystaw_ocene(1, 1, 1, 4);
EXEC pkg_oceny.wystaw_ocene_semestralna(1, 1, 1, 5);

-- Podgląd ocen ucznia o ID=1
EXEC pkg_oceny.oceny_ucznia(1);

-- Średnia ucznia o ID=1 z przedmiotu o ID=1
SELECT pkg_oceny.srednia_ucznia(1, 1) AS srednia FROM DUAL;

-- Raport ocen grupy o ID=1
EXEC pkg_oceny.raport_ocen_grupy(1);

-- ============================================================================
-- SCENARIUSZ 7B: VERBOSE - wyświetl co kryje się pod ID przed zapisem!
-- ============================================================================
-- wystaw_ocene_verbose pokazuje: "Uczeń[5] = Ewa Ewa"... przed zapisem
EXEC pkg_oceny.wystaw_ocene_verbose(5, 3, 3, 4);
-- Wyświetli:
-- >>> Uczeń[5] = Ewa Ewa (lat 9, Gitara, grupa 2A)
-- >>> Nauczyciel[3] = Maria Wiśniewska (Gitara)
-- >>> Przedmiot[3] = Gitara (instrumentalny)
-- >>> Ocena: 4 (dobry)
-- ZAPISANO!

-- ============================================================================
-- SCENARIUSZ 8: Raporty
-- ============================================================================
EXEC pkg_raporty.statystyki_ogolne;
EXEC pkg_raporty.statystyki_lekcji;
EXEC pkg_raporty.raport_grup;
EXEC pkg_raporty.raport_nauczycieli;

-- ============================================================================
-- SCENARIUSZ 8B: INFO_* - co kryje się pod danym ID?
-- ============================================================================
-- Pokazują czytelne informacje o encji po samym ID
EXEC pkg_slowniki.info_przedmiot(1);     -- Fortepian (instrumentalny)
EXEC pkg_slowniki.info_przedmiot(4);     -- Kształcenie słuchu (teoretyczny)

EXEC pkg_slowniki.info_sala(1);          -- 101, fortepianowa, 3 os, [Fortepian Yamaha, Metronom, Lustro]
EXEC pkg_slowniki.info_sala(5);          -- 105, rytmiczna, 25 os

EXEC pkg_slowniki.info_grupa(1);         -- 1A, klasa 1

EXEC pkg_osoby.info_uczen(1);            -- Adam Adamski (lat 7, Fortepian, grupa 1A)
EXEC pkg_osoby.info_uczen(5);            -- Ewa Ewa (lat 9, Gitara, grupa 2A)

EXEC pkg_osoby.info_nauczyciel(1);       -- Anna Kowalska (Fortepian)
EXEC pkg_osoby.info_nauczyciel(4);       -- Piotr Lewandowski (Kształcenie słuchu)

-- ============================================================================
-- SCENARIUSZ 8C: KOMPLETNOŚĆ LEKCJI (5 tygodniowo!)
-- ============================================================================
-- Sprawdza ile lekcji ma dany uczeń w tygodniu
SELECT pkg_lekcje.ile_lekcji_ucznia(1, DATE '2025-06-02') AS lekcje_adama FROM DUAL;

-- Raport kompletności - kto ma <5 lekcji? (walidacja!)
EXEC pkg_lekcje.raport_kompletnosci(DATE '2025-06-02');

-- ============================================================================
-- SCENARIUSZ 9: Błędy (walidacja)
-- ============================================================================
-- Ocena poza zakresem (powinien być błąd -20005)
-- EXEC pkg_oceny.wystaw_ocene(1, 1, 1, 7);

-- Lekcja w weekend (powinien być błąd -20008)
-- EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 1, DATE '2025-06-07', 14);  -- sobota!

-- Lekcja poza godzinami (powinien być błąd -20007)
-- EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 1, DATE '2025-06-09', 21);

-- ============================================================================
-- SCENARIUSZ 9B: Test kolizji lekcji grupowej z indywidualną (NOWA FUNKCJONALNOŚĆ!)
-- ============================================================================
-- Ten scenariusz demonstruje naprawiony błąd - system teraz wykrywa kolizję
-- gdy uczeń ma lekcję indywidualną, a próbujemy dodać lekcję grupową w tym czasie.
-- 
-- KROKI DEMONSTRACJI:
-- 1. Najpierw dodajemy lekcję indywidualną dla ucznia (np. ID=1) o 15:00
-- 2. Potem próbujemy dodać lekcję grupową dla jego grupy (1A) o 15:00
-- 3. System POWINIEN zgłosić błąd -20009 (kolizja z lekcją indywidualną)
--
-- PRZED NAPRAWĄ: System pozwalał - uczeń miał 2 lekcje naraz (błąd!)
-- PO NAPRAWIE:   System blokuje i pokazuje który uczeń ma kolizję

-- Odkomentuj aby przetestować:
-- DELETE FROM lekcje WHERE data_lekcji = DATE '2025-06-10';
-- COMMIT;

-- Krok 1: Lekcja indywidualna dla ucznia ID=1 (Adam Adamski z grupy 1A)
-- EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 1, DATE '2025-06-10', 15);

-- Krok 2: Próba dodania lekcji grupowej dla grupy 1A w tym samym czasie
-- Spodziewany błąd: ORA-20009: Uczniowie z grupy 1A mają kolizję... Adam Adamski
-- EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 4, 1, DATE '2025-06-10', 15);

-- ============================================================================
-- SCENARIUSZ 9C: Test nakładających się przedziałów czasowych (NOWA FUNKCJONALNOŚĆ!)
-- ============================================================================
-- System teraz wykrywa nakładanie się lekcji nawet gdy nie zaczynają się o tej samej godzinie.
-- Lekcja trwa 45 min, więc 14:00-14:45 koliduje z próbą o 14:30 (gdyby godziny ułamkowe były możliwe)
-- 
-- W obecnej implementacji (tylko pełne godziny) demonstracja:
-- Lekcja 14:00-14:45 NIE koliduje z 15:00-15:45 (OK - przerwa 15 min)
-- Ale logika jest przygotowana na przyszłe rozszerzenie na połówki godzin.

-- ============================================================================
-- SCENARIUSZ 9D: Test błędu przy nieznanym przedmiocie (NOWA FUNKCJONALNOŚĆ!)
-- ============================================================================
-- Przy dodawaniu nauczyciela z nieznanym przedmiotem system teraz:
-- 1. Wyświetla czytelny komunikat błędu (nie techniczny ORA-01403)
-- 2. Wycofuje nauczyciela (atomowość transakcji)
--
-- Odkomentuj aby przetestować:
-- EXEC pkg_osoby.dodaj_nauczyciela('Test', 'Testowy', 'NieistniejącyPrzedmiot');
-- Spodziewany błąd: ORA-20015: Nieznany przedmiot: "NieistniejącyPrzedmiot"...

-- ============================================================================
-- SCENARIUSZ 10: Test dni tygodnia (sprawdzenie poprawki)
-- ============================================================================
-- Wyświetla dzień tygodnia dla różnych dat
SELECT 
    TO_CHAR(DATE '2025-06-02', 'YYYY-MM-DD DY') AS data,
    pkg_lekcje.dzien_tygodnia(DATE '2025-06-02') AS dzien_nr,
    CASE pkg_lekcje.dzien_tygodnia(DATE '2025-06-02')
        WHEN 1 THEN 'Poniedziałek'
        WHEN 2 THEN 'Wtorek'
        WHEN 3 THEN 'Środa'
        WHEN 4 THEN 'Czwartek'
        WHEN 5 THEN 'Piątek'
        WHEN 6 THEN 'Sobota'
        WHEN 7 THEN 'Niedziela'
    END AS dzien_nazwa
FROM DUAL;

-- Test całego tygodnia
SELECT 
    TO_CHAR(d.data, 'YYYY-MM-DD DY') AS data,
    pkg_lekcje.dzien_tygodnia(d.data) AS dzien_nr,
    CASE WHEN pkg_lekcje.dzien_tygodnia(d.data) BETWEEN 1 AND 5 
         THEN 'ROBOCZY' ELSE 'WEEKEND' END AS typ_dnia
FROM (
    SELECT DATE '2025-06-02' + LEVEL - 1 AS data 
    FROM DUAL 
    CONNECT BY LEVEL <= 7
) d;

-- ============================================================================
-- SCENARIUSZ 11: VARRAY - wyposażenie sal
-- ============================================================================
SELECT s.numer, s.typ, s.pojemnosc, s.lista_wyposazenia() AS wyposazenie
FROM sale s;

-- Nowa sala 105 (rytmiczna) - ma specjalne wyposażenie
SELECT s.numer, s.typ, s.lista_wyposazenia() AS wyposazenie
FROM sale s WHERE s.numer = '105';

-- ============================================================================
-- SCENARIUSZ 11B: Struktura lekcji (5 tygodniowo)
-- ============================================================================
-- Sprawdzenie struktury: 2 instr + 2 KS + 1 rytm = 5 lekcji
SELECT 
    DEREF(l.ref_uczen).id AS uczen_id,
    DEREF(l.ref_uczen).pelne_nazwisko() AS uczen,
    TO_CHAR(l.data_lekcji, 'DY') AS dzien,
    DEREF(l.ref_przedmiot).nazwa AS przedmiot,
    l.czy_indywidualna() AS typ
FROM lekcje l
WHERE l.ref_uczen IS NOT NULL
  AND DEREF(l.ref_uczen).id = 1  -- Adam Adamski
ORDER BY l.data_lekcji;

-- ============================================================================
-- SCENARIUSZ 12: REF/DEREF - referencje
-- ============================================================================
-- Pokazanie działania DEREF
SELECT 
    l.id,
    DEREF(l.ref_przedmiot).nazwa AS przedmiot,
    DEREF(l.ref_nauczyciel).pelne_nazwisko() AS nauczyciel,
    DEREF(l.ref_sala).numer AS sala,
    CASE WHEN l.ref_uczen IS NOT NULL 
         THEN DEREF(l.ref_uczen).pelne_nazwisko()
         ELSE 'grupa ' || DEREF(l.ref_grupa).symbol
    END AS dla_kogo,
    l.czy_indywidualna() AS typ
FROM lekcje l
WHERE ROWNUM <= 5;

-- ============================================================================
-- SCENARIUSZ 13: Metody obiektów
-- ============================================================================
-- Metody ucznia
SELECT u.pelne_nazwisko() AS nazwisko, u.wiek() AS wiek, u.instrument
FROM uczniowie u WHERE ROWNUM <= 3;

-- Metody nauczyciela
SELECT n.pelne_nazwisko() AS nazwisko, n.staz_lat() AS staz
FROM nauczyciele n;

-- Metody przedmiotu
SELECT p.nazwa, p.czy_grupowy() AS grupowy
FROM przedmioty p;

-- Metody lekcji
SELECT l.id, l.czy_indywidualna() AS indyw, l.godzina_koniec() AS koniec
FROM lekcje l WHERE ROWNUM <= 5;

-- Metody oceny
SELECT o.wartosc, o.opis_oceny() AS opis
FROM oceny o WHERE ROWNUM <= 5;
