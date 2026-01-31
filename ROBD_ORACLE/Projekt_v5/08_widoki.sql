-- ============================================================================
-- PLIK: 08_widoki.sql
-- PROJEKT: Szkola Muzyczna v5 - Obiektowa Baza Danych Oracle
-- AUTORZY: Igor Typinski (251237), Mateusz Mroz (251190)
-- DATA: Styczen 2026
-- ============================================================================
-- Definiuje WIDOKI z DEREF dla czytelnych danych
-- Rozwiazuje REF na wartosci tekstowe
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200
SET PAGESIZE 50

PROMPT ========================================================================
PROMPT   08_widoki.sql - Tworzenie widokow
PROMPT ========================================================================
PROMPT

-- ============================================================================
-- 1. WIDOK: V_UCZNIOWIE
-- Uczniowie z rozwiazanymi REF na instrument i grupe
-- ============================================================================

PROMPT [1/6] Tworzenie v_uczniowie...

CREATE OR REPLACE VIEW v_uczniowie AS
SELECT
    u.id_ucznia,
    u.imie,
    u.nazwisko,
    u.imie || ' ' || u.nazwisko AS pelne_nazwisko,
    u.data_urodzenia,
    VALUE(u).wiek() AS wiek,
    u.email,
    u.telefon_rodzica,
    u.data_zapisu,
    u.klasa,
    u.cykl_nauczania,
    u.typ_ucznia,
    VALUE(u).min_godzina_lekcji() AS min_godzina,
    u.status,
    DEREF(u.ref_instrument).nazwa AS instrument,
    DEREF(u.ref_instrument).kategoria AS kategoria_instr,
    DEREF(u.ref_grupa).nazwa AS grupa,
    DEREF(u.ref_grupa).klasa AS klasa_grupy
FROM uczniowie u;

-- ============================================================================
-- 2. WIDOK: V_NAUCZYCIELE
-- Nauczyciele z instrumentami jako tekst
-- ============================================================================

PROMPT [2/6] Tworzenie v_nauczyciele...

CREATE OR REPLACE VIEW v_nauczyciele AS
SELECT
    n.id_nauczyciela,
    n.imie,
    n.nazwisko,
    n.imie || ' ' || n.nazwisko AS pelne_nazwisko,
    n.email,
    n.telefon,
    n.data_zatrudnienia,
    VALUE(n).lata_stazu() AS lata_stazu,
    VALUE(n).liczba_instrumentow() AS liczba_instrumentow,
    n.czy_prowadzi_grupowe,
    n.czy_akompaniator,
    n.status
FROM nauczyciele n;

-- ============================================================================
-- 3. WIDOK: V_LEKCJE
-- Lekcje z rozwiazanymi wszystkimi REF
-- ============================================================================

PROMPT [3/6] Tworzenie v_lekcje...

CREATE OR REPLACE VIEW v_lekcje AS
SELECT
    l.id_lekcji,
    l.data_lekcji,
    VALUE(l).dzien_tygodnia() AS dzien,
    l.godzina_start,
    VALUE(l).godzina_koniec() AS godzina_koniec,
    l.czas_trwania,
    VALUE(l).czas_txt() AS czas_txt,
    l.typ_lekcji,
    l.status,
    DEREF(l.ref_przedmiot).nazwa AS przedmiot,
    DEREF(l.ref_nauczyciel).imie || ' ' || DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
    DEREF(l.ref_akompaniator).imie || ' ' || DEREF(l.ref_akompaniator).nazwisko AS akompaniator,
    DEREF(l.ref_sala).numer AS sala,
    DEREF(l.ref_uczen).imie || ' ' || DEREF(l.ref_uczen).nazwisko AS uczen,
    DEREF(l.ref_grupa).nazwa AS grupa
FROM lekcje l;

-- ============================================================================
-- 4. WIDOK: V_EGZAMINY
-- Egzaminy z komisja i wynikami
-- ============================================================================

PROMPT [4/6] Tworzenie v_egzaminy...

CREATE OR REPLACE VIEW v_egzaminy AS
SELECT
    e.id_egzaminu,
    e.data_egzaminu,
    e.godzina,
    e.typ_egzaminu,
    DEREF(e.ref_uczen).imie || ' ' || DEREF(e.ref_uczen).nazwisko AS uczen,
    DEREF(e.ref_uczen).klasa AS klasa_ucznia,
    DEREF(e.ref_przedmiot).nazwa AS przedmiot,
    DEREF(e.ref_komisja1).imie || ' ' || DEREF(e.ref_komisja1).nazwisko AS komisja1,
    DEREF(e.ref_komisja2).imie || ' ' || DEREF(e.ref_komisja2).nazwisko AS komisja2,
    DEREF(e.ref_sala).numer AS sala,
    e.ocena_koncowa,
    VALUE(e).ocena_slownie() AS ocena_slownie,
    VALUE(e).czy_zdany() AS czy_zdany,
    e.uwagi
FROM egzaminy e;

-- ============================================================================
-- 5. WIDOK: V_OCENY
-- Oceny z kontekstem (uczen, nauczyciel, przedmiot)
-- ============================================================================

PROMPT [5/6] Tworzenie v_oceny...

CREATE OR REPLACE VIEW v_oceny AS
SELECT
    o.id_oceny,
    o.data_oceny,
    o.wartosc,
    VALUE(o).ocena_slownie() AS ocena_slownie,
    o.obszar,
    o.komentarz,
    DEREF(o.ref_uczen).imie || ' ' || DEREF(o.ref_uczen).nazwisko AS uczen,
    DEREF(o.ref_uczen).klasa AS klasa_ucznia,
    DEREF(o.ref_nauczyciel).imie || ' ' || DEREF(o.ref_nauczyciel).nazwisko AS nauczyciel,
    DEREF(o.ref_przedmiot).nazwa AS przedmiot,
    DEREF(o.ref_lekcja).id_lekcji AS id_lekcji
FROM oceny o;

-- ============================================================================
-- 6. WIDOK: V_PLAN_LEKCJI
-- Plan lekcji - uproszczony widok do wyswietlania
-- ============================================================================

PROMPT [6/6] Tworzenie v_plan_lekcji...

CREATE OR REPLACE VIEW v_plan_lekcji AS
SELECT
    l.data_lekcji,
    VALUE(l).dzien_tygodnia() AS dzien,
    l.godzina_start || '-' || VALUE(l).godzina_koniec() AS godziny,
    DEREF(l.ref_przedmiot).nazwa AS przedmiot,
    DEREF(l.ref_sala).numer AS sala,
    CASE l.typ_lekcji
        WHEN 'indywidualna' THEN DEREF(l.ref_uczen).imie || ' ' || DEREF(l.ref_uczen).nazwisko
        WHEN 'grupowa' THEN 'Grupa ' || DEREF(l.ref_grupa).nazwa
    END AS uczestnik,
    DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
    l.status
FROM lekcje l
WHERE l.status NOT IN ('odwolana')
ORDER BY l.data_lekcji, l.godzina_start;

-- ============================================================================
-- UPRAWNIENIA DO WIDOKOW
-- ============================================================================

PROMPT Nadawanie uprawnien do widokow...

GRANT SELECT ON v_uczniowie TO r_nauczyciel;
GRANT SELECT ON v_nauczyciele TO r_nauczyciel;
GRANT SELECT ON v_lekcje TO r_nauczyciel;
GRANT SELECT ON v_egzaminy TO r_nauczyciel;
GRANT SELECT ON v_oceny TO r_nauczyciel;
GRANT SELECT ON v_plan_lekcji TO r_uczen;

-- ============================================================================
-- SYNONIMY
-- ============================================================================

CREATE OR REPLACE PUBLIC SYNONYM v_uczniowie FOR v_uczniowie;
CREATE OR REPLACE PUBLIC SYNONYM v_nauczyciele FOR v_nauczyciele;
CREATE OR REPLACE PUBLIC SYNONYM v_lekcje FOR v_lekcje;
CREATE OR REPLACE PUBLIC SYNONYM v_egzaminy FOR v_egzaminy;
CREATE OR REPLACE PUBLIC SYNONYM v_oceny FOR v_oceny;
CREATE OR REPLACE PUBLIC SYNONYM v_plan_lekcji FOR v_plan_lekcji;

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================

PROMPT
PROMPT ========================================================================
PROMPT   UTWORZONE WIDOKI
PROMPT ========================================================================
PROMPT   v_uczniowie - uczniowie z instrumentem i grupa
PROMPT   v_nauczyciele - nauczyciele ze stazem
PROMPT   v_lekcje - lekcje z wszystkimi danymi
PROMPT   v_egzaminy - egzaminy z komisja
PROMPT   v_oceny - oceny z kontekstem
PROMPT   v_plan_lekcji - plan lekcji (uproszczony)
PROMPT ========================================================================
PROMPT   Nastepny krok: Uruchom 09_testy.sql
PROMPT ========================================================================

SELECT view_name FROM user_views ORDER BY view_name;
