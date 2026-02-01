-- ============================================================================
-- Projekt: Szkola Muzyczna - Obiektowa Baza Danych (UPROSZCZONA)
-- Plik: 05_dane.sql
-- Opis: Dane poczatkowe - przedmioty, sale, grupy, nauczyciele, uczniowie
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- Wersja: 7.0
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- ============================================================================
-- 0. CZYSZCZENIE DANYCH (przy ponownym uruchomieniu)
-- ============================================================================

DELETE FROM OCENY;
DELETE FROM LEKCJE;
DELETE FROM UCZNIOWIE;
DELETE FROM NAUCZYCIELE;
DELETE FROM GRUPY;
DELETE FROM SALE;
DELETE FROM PRZEDMIOTY;
COMMIT;

-- ============================================================================
-- 1. PRZEDMIOTY (5 przedmiotow)
-- ============================================================================

BEGIN PKG_SLOWNIKI.dodaj_przedmiot('Fortepian', 'indywidualny', 45); END;
/
BEGIN PKG_SLOWNIKI.dodaj_przedmiot('Skrzypce', 'indywidualny', 45); END;
/
BEGIN PKG_SLOWNIKI.dodaj_przedmiot('Gitara', 'indywidualny', 45); END;
/
BEGIN PKG_SLOWNIKI.dodaj_przedmiot('Flet', 'indywidualny', 45); END;
/
BEGIN PKG_SLOWNIKI.dodaj_przedmiot('Ksztalcenie sluchu', 'grupowy', 45); END;
/

-- ============================================================================
-- 2. SALE (4 sale) - UZYCIE VARRAY T_WYPOSAZENIE
-- ============================================================================

BEGIN 
    PKG_SLOWNIKI.dodaj_sale('101', 'indywidualna', 3, 
        T_WYPOSAZENIE('Pianino Yamaha', 'Pulpit na nuty', 'Krzeslo obrotowe'));
END;
/
BEGIN 
    PKG_SLOWNIKI.dodaj_sale('102', 'indywidualna', 3, 
        T_WYPOSAZENIE('Fortepian Steinway', 'Metronom', 'Lustro'));
END;
/
BEGIN 
    PKG_SLOWNIKI.dodaj_sale('103', 'indywidualna', 3, 
        T_WYPOSAZENIE('Pianino cyfrowe', 'Wzmacniacz', 'Stojak gitarowy'));
END;
/
BEGIN 
    PKG_SLOWNIKI.dodaj_sale('201', 'grupowa', 15, 
        T_WYPOSAZENIE('Tablica interaktywna', 'Naglosnienie', 'Pianino', 'Krzesla x15', 'Projektor'));
END;
/

-- ============================================================================
-- 3. GRUPY (6 grup - po jednej na klase)
-- ============================================================================

BEGIN PKG_SLOWNIKI.dodaj_grupe('1A', 1, '2025/2026'); END;
/
BEGIN PKG_SLOWNIKI.dodaj_grupe('2A', 2, '2025/2026'); END;
/
BEGIN PKG_SLOWNIKI.dodaj_grupe('3A', 3, '2025/2026'); END;
/
BEGIN PKG_SLOWNIKI.dodaj_grupe('4A', 4, '2025/2026'); END;
/
BEGIN PKG_SLOWNIKI.dodaj_grupe('5A', 5, '2025/2026'); END;
/
BEGIN PKG_SLOWNIKI.dodaj_grupe('6A', 6, '2025/2026'); END;
/

-- ============================================================================
-- 4. NAUCZYCIELE (6 nauczycieli)
-- ============================================================================

BEGIN PKG_OSOBY.dodaj_nauczyciela('Anna', 'Kowalska', 'Fortepian', 'anna.kowalska@szkola.pl'); END;
/
BEGIN PKG_OSOBY.dodaj_nauczyciela('Piotr', 'Nowak', 'Skrzypce', 'piotr.nowak@szkola.pl'); END;
/
BEGIN PKG_OSOBY.dodaj_nauczyciela('Maria', 'Wisniewska', 'Gitara', 'maria.wisniewska@szkola.pl'); END;
/
BEGIN PKG_OSOBY.dodaj_nauczyciela('Jan', 'Lewandowski', 'Flet', 'jan.lewandowski@szkola.pl'); END;
/
BEGIN PKG_OSOBY.dodaj_nauczyciela('Ewa', 'Kaminska', NULL, 'ewa.kaminska@szkola.pl'); END;
/
BEGIN PKG_OSOBY.dodaj_nauczyciela('Tomasz', 'Zielinski', 'Fortepian', 'tomasz.zielinski@szkola.pl'); END;
/

-- ============================================================================
-- 5. UCZNIOWIE (24 uczniow - 4 na grupe)
-- ============================================================================

-- KLASA 1A (wiek ~8-9 lat w 2026)
BEGIN PKG_OSOBY.dodaj_ucznia('Jan', 'Kotek', DATE '2017-03-15', '1A', 'Fortepian'); END;
/
BEGIN PKG_OSOBY.dodaj_ucznia('Anna', 'Myszka', DATE '2017-06-22', '1A', 'Skrzypce'); END;
/
BEGIN PKG_OSOBY.dodaj_ucznia('Piotr', 'Piesek', DATE '2017-09-10', '1A', 'Gitara'); END;
/
BEGIN PKG_OSOBY.dodaj_ucznia('Ola', 'Kwiatek', DATE '2017-12-05', '1A', 'Fortepian'); END;
/

-- KLASA 2A
BEGIN PKG_OSOBY.dodaj_ucznia('Tomek', 'Drzewko', DATE '2016-02-18', '2A', 'Flet'); END;
/
BEGIN PKG_OSOBY.dodaj_ucznia('Kasia', 'Chmurka', DATE '2016-05-30', '2A', 'Fortepian'); END;
/
BEGIN PKG_OSOBY.dodaj_ucznia('Marek', 'Sloneczko', DATE '2016-08-14', '2A', 'Skrzypce'); END;
/
BEGIN PKG_OSOBY.dodaj_ucznia('Zosia', 'Rybka', DATE '2016-11-25', '2A', 'Gitara'); END;
/

-- KLASA 3A
BEGIN PKG_OSOBY.dodaj_ucznia('Adam', 'Lasek', DATE '2015-01-08', '3A', 'Fortepian'); END;
/
BEGIN PKG_OSOBY.dodaj_ucznia('Ewa', 'Gwiazda', DATE '2015-04-19', '3A', 'Flet'); END;
/
BEGIN PKG_OSOBY.dodaj_ucznia('Jakub', 'Morski', DATE '2015-07-27', '3A', 'Skrzypce'); END;
/
BEGIN PKG_OSOBY.dodaj_ucznia('Maja', 'Polna', DATE '2015-10-12', '3A', 'Gitara'); END;
/

-- KLASA 4A
BEGIN PKG_OSOBY.dodaj_ucznia('Bartek', 'Gorski', DATE '2014-03-03', '4A', 'Fortepian'); END;
/
BEGIN PKG_OSOBY.dodaj_ucznia('Natalia', 'Rzeczna', DATE '2014-06-15', '4A', 'Skrzypce'); END;
/
BEGIN PKG_OSOBY.dodaj_ucznia('Filip', 'Polny', DATE '2014-09-22', '4A', 'Flet'); END;
/
BEGIN PKG_OSOBY.dodaj_ucznia('Wiktoria', 'Zielona', DATE '2014-12-08', '4A', 'Fortepian'); END;
/

-- KLASA 5A
BEGIN PKG_OSOBY.dodaj_ucznia('Szymon', 'Wysoki', DATE '2013-02-28', '5A', 'Gitara'); END;
/
BEGIN PKG_OSOBY.dodaj_ucznia('Alicja', 'Biala', DATE '2013-05-17', '5A', 'Fortepian'); END;
/
BEGIN PKG_OSOBY.dodaj_ucznia('Dawid', 'Ciemny', DATE '2013-08-09', '5A', 'Skrzypce'); END;
/
BEGIN PKG_OSOBY.dodaj_ucznia('Julia', 'Jasna', DATE '2013-11-30', '5A', 'Flet'); END;
/

-- KLASA 6A
BEGIN PKG_OSOBY.dodaj_ucznia('Michal', 'Mocny', DATE '2012-01-14', '6A', 'Fortepian'); END;
/
BEGIN PKG_OSOBY.dodaj_ucznia('Oliwia', 'Szybka', DATE '2012-04-25', '6A', 'Gitara'); END;
/
BEGIN PKG_OSOBY.dodaj_ucznia('Krzysztof', 'Madry', DATE '2012-07-07', '6A', 'Skrzypce'); END;
/
BEGIN PKG_OSOBY.dodaj_ucznia('Patrycja', 'Wysoka', DATE '2012-10-19', '6A', 'Flet'); END;
/

-- ============================================================================
-- 6. PODSUMOWANIE
-- ============================================================================

COMMIT;

-- Wyswietlenie danych
SELECT id_przedmiotu AS ID, nazwa, typ_zajec AS "Typ", czas_trwania_min AS "Czas" FROM PRZEDMIOTY ORDER BY typ_zajec, nazwa;

SELECT id_sali AS ID, numer, typ, pojemnosc,
       (SELECT LISTAGG(COLUMN_VALUE, ', ') WITHIN GROUP (ORDER BY ROWNUM) 
        FROM TABLE(s.wyposazenie)) AS wyposazenie
FROM SALE s ORDER BY numer;

SELECT id_grupy AS ID, kod, klasa, rok_szkolny FROM GRUPY ORDER BY klasa;

SELECT id_nauczyciela AS ID, imie, nazwisko, NVL(instrument, '(grupowe)') AS specjalizacja 
FROM NAUCZYCIELE ORDER BY nazwisko;

SELECT DEREF(u.ref_grupa).kod AS Grupa, u.id_ucznia AS ID, u.imie, u.nazwisko, u.instrument
FROM UCZNIOWIE u
ORDER BY DEREF(u.ref_grupa).klasa, u.nazwisko;

SELECT 'Przedmioty' AS Kategoria, COUNT(*) AS Liczba FROM PRZEDMIOTY
UNION ALL SELECT 'Sale', COUNT(*) FROM SALE
UNION ALL SELECT 'Grupy', COUNT(*) FROM GRUPY
UNION ALL SELECT 'Nauczyciele', COUNT(*) FROM NAUCZYCIELE
UNION ALL SELECT 'Uczniowie', COUNT(*) FROM UCZNIOWIE;
