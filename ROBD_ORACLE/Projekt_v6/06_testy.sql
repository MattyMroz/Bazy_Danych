-- ============================================================================
-- Projekt: Szkola Muzyczna - Obiektowa Baza Danych
-- Plik: 06_testy.sql
-- Opis: Scenariusze testowe - live documentation
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================
-- UWAGA: Uruchomic PO wykonaniu 05_dane.sql
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- ============================================================================
-- SCENARIUSZ 1: Nowy uczen dochodzi do szkoly w trakcie semestru
-- ============================================================================
-- Jasio Kotek (ur. 2019-06-15) zostaje przyjety do klasy 1A na Fortepian.
-- Rodzic: kotek.rodzic@email.pl, tel: 500999888
-- Po dodaniu ucznia generujemy plan na nowy tydzien (marzec 2026).
-- ============================================================================

-- Dodanie ucznia
BEGIN
    PKG_OSOBY.dodaj_ucznia('Jasio', 'Kotek', DATE '2019-06-15', '1A', 'Fortepian', 'kotek.rodzic@email.pl', '500999888');
END;
/

-- Generowanie planu na nowy tydzien dla wszystkich (w tym Jasia)
BEGIN
    PKG_LEKCJE.generuj_plan_tygodnia(DATE '2026-03-02');
END;
/

-- Weryfikacja: Plan lekcji Jasia Kotka
SELECT 
    TO_CHAR(l.data_lekcji, 'YYYY-MM-DD') AS data,
    l.godzina_rozp AS godzina,
    DEREF(l.ref_przedmiot).nazwa AS przedmiot,
    DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
    DEREF(l.ref_sala).numer AS sala
FROM LEKCJE l
WHERE DEREF(l.ref_uczen).nazwisko = 'Kotek'
ORDER BY l.data_lekcji, l.godzina_rozp;

COMMIT;

-- ============================================================================
-- SCENARIUSZ 2: Nowy nauczyciel dochodzi do szkoly
-- ============================================================================
-- Zbigniew Melodia - nowy nauczyciel Skrzypiec
-- Email: melodia@szkola.pl, tel: 600123456
-- ============================================================================

-- Dodanie nauczyciela
BEGIN
    PKG_OSOBY.dodaj_nauczyciela('Zbigniew', 'Melodia', T_INSTRUMENTY_TAB('Skrzypce'), 'melodia@szkola.pl', '600123456');
END;
/

-- Weryfikacja: Lista nauczycieli Skrzypiec
SELECT n.imie, n.nazwisko, n.email
FROM NAUCZYCIELE n, TABLE(n.instrumenty) i
WHERE i.COLUMN_VALUE = 'Skrzypce';

COMMIT;

-- ============================================================================
-- SCENARIUSZ 3: Wystawianie ocen
-- ============================================================================
-- Nauczyciel Kowalska wystawia oceny Janowi Kowalskiemu z Fortepianu:
-- - 5 z techniki (komentarz: Swietna gra gam)
-- - 4 z interpretacji (komentarz: Dobra ekspresja)
-- ============================================================================

-- Wystawienie ocen
BEGIN
    PKG_OCENY.wystaw_ocene('Kowalski', 'Jan', 'Kowalska', 'Fortepian', 5, 'technika', 'Swietna gra gam');
    PKG_OCENY.wystaw_ocene('Kowalski', 'Jan', 'Kowalska', 'Fortepian', 4, 'interpretacja', 'Dobra ekspresja');
END;
/

-- Weryfikacja: Oceny Jana Kowalskiego
SELECT 
    DEREF(o.ref_przedmiot).nazwa AS przedmiot,
    o.wartosc AS ocena,
    o.obszar,
    o.komentarz,
    DEREF(o.ref_nauczyciel).nazwisko AS wystawil
FROM OCENY o
WHERE DEREF(o.ref_uczen).nazwisko = 'Kowalski' AND DEREF(o.ref_uczen).imie = 'Jan';

COMMIT;

-- ============================================================================
-- SCENARIUSZ 4: Egzamin dla ucznia
-- ============================================================================
-- Jasio Kotek ma egzamin promocyjny:
-- - Data: 2026-03-06 (piatek), godzina 16:00
-- - Sala: 203
-- - Komisja: Kowalska, Nowak
-- - Czas: 30 minut
-- ============================================================================

-- Dodanie egzaminu
BEGIN
    PKG_LEKCJE.dodaj_egzamin('Kotek', 'Jasio', '203', DATE '2026-03-06', '16:00', 'Kowalska', 'Nowak', 30);
END;
/

-- Weryfikacja: Egzaminy
SELECT 
    DEREF(l.ref_uczen).imie || ' ' || DEREF(l.ref_uczen).nazwisko AS uczen,
    TO_CHAR(l.data_lekcji, 'YYYY-MM-DD') AS data,
    l.godzina_rozp AS godzina,
    DEREF(l.ref_sala).numer AS sala
FROM LEKCJE l
WHERE l.typ_lekcji = 'egzamin';

COMMIT;

-- ============================================================================
-- SCENARIUSZ 5: Wyswietlenie planu nauczyciela
-- ============================================================================
-- Anna Kowalska chce zobaczyc swoj plan na tydzien 2026-02-02.
-- ============================================================================

-- Plan nauczyciela Kowalskiej
SELECT 
    TO_CHAR(l.data_lekcji, 'YYYY-MM-DD') AS data,
    l.godzina_rozp AS godzina,
    DEREF(l.ref_przedmiot).nazwa AS przedmiot,
    CASE 
        WHEN l.ref_uczen IS NOT NULL THEN DEREF(l.ref_uczen).imie || ' ' || DEREF(l.ref_uczen).nazwisko
        ELSE 'Grupa: ' || DEREF(l.ref_grupa).kod
    END AS uczen_grupa,
    DEREF(l.ref_sala).numer AS sala
FROM LEKCJE l
WHERE DEREF(l.ref_nauczyciel).nazwisko = 'Kowalska'
  AND l.data_lekcji BETWEEN DATE '2026-02-02' AND DATE '2026-02-06'
ORDER BY l.data_lekcji, l.godzina_rozp;

-- ============================================================================
-- SCENARIUSZ 6: Plan lekcji grupowych dla klasy
-- ============================================================================
-- Rodzic pyta o plan lekcji grupowych klasy 1A na tydzien 2026-02-02.
-- ============================================================================

-- Plan grupowy klasy 1A
SELECT 
    TO_CHAR(l.data_lekcji, 'YYYY-MM-DD') AS data,
    l.godzina_rozp AS godzina,
    DEREF(l.ref_przedmiot).nazwa AS przedmiot,
    DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
    DEREF(l.ref_sala).numer AS sala
FROM LEKCJE l
WHERE DEREF(l.ref_grupa).kod = '1A'
  AND l.data_lekcji BETWEEN DATE '2026-02-02' AND DATE '2026-02-06'
ORDER BY l.data_lekcji, l.godzina_rozp;

-- ============================================================================
-- SCENARIUSZ 7: Statystyki - obciazenie nauczycieli
-- ============================================================================
-- Dyrektor chce zobaczyc ile lekcji prowadzi kazdy nauczyciel.
-- ============================================================================

-- Obciazenie nauczycieli (tydzien 2026-02-02)
SELECT 
    DEREF(l.ref_nauczyciel).imie || ' ' || DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
    COUNT(*) AS liczba_lekcji,
    SUM(l.czas_trwania) || ' min' AS laczny_czas
FROM LEKCJE l
WHERE l.data_lekcji BETWEEN DATE '2026-02-02' AND DATE '2026-02-06'
GROUP BY DEREF(l.ref_nauczyciel).imie, DEREF(l.ref_nauczyciel).nazwisko
ORDER BY COUNT(*) DESC;

-- ============================================================================
-- SCENARIUSZ 8: Statystyki - wykorzystanie sal
-- ============================================================================
-- Administrator sprawdza ktore sale sa najbardziej obciazone.
-- ============================================================================

-- Wykorzystanie sal (tydzien 2026-02-02)
SELECT 
    DEREF(l.ref_sala).numer AS sala,
    DEREF(l.ref_sala).typ AS typ,
    COUNT(*) AS liczba_lekcji
FROM LEKCJE l
WHERE l.data_lekcji BETWEEN DATE '2026-02-02' AND DATE '2026-02-06'
GROUP BY DEREF(l.ref_sala).numer, DEREF(l.ref_sala).typ
ORDER BY DEREF(l.ref_sala).numer;

-- ============================================================================
-- SCENARIUSZ 9: Test walidacji - nieistniejacy instrument
-- ============================================================================
-- Proba dodania ucznia z instrumentem "Trabka" ktory nie istnieje w bazie.
-- Oczekiwany rezultat: Blad ORA-20xxx
-- ============================================================================

BEGIN
    PKG_OSOBY.dodaj_ucznia('Test', 'Uczen', DATE '2019-01-01', '1A', 'Trabka', 'test@email.pl', '500000000');
END;
/

-- ============================================================================
-- SCENARIUSZ 10: Test walidacji - lekcja w weekend
-- ============================================================================
-- Proba dodania egzaminu w sobote (2026-02-28).
-- Oczekiwany rezultat: Blad ORA-20109 (lekcje od pon-pt)
-- ============================================================================

BEGIN
    PKG_LEKCJE.dodaj_egzamin('Kowalski', 'Jan', '203', DATE '2026-02-28', '14:00', 'Kowalska', 'Nowak', 30);
END;
/

-- ============================================================================
-- SCENARIUSZ 11: Test walidacji - lekcja przed 14:00
-- ============================================================================
-- Proba dodania egzaminu o godzinie 10:00.
-- Oczekiwany rezultat: Blad ORA-20106 (lekcje od 14:00)
-- ============================================================================

BEGIN
    PKG_LEKCJE.dodaj_egzamin('Kowalski', 'Jan', '203', DATE '2026-03-06', '10:00', 'Kowalska', 'Nowak', 30);
END;
/

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================

SELECT 'UCZNIOWIE' AS tabela, COUNT(*) AS liczba FROM UCZNIOWIE
UNION ALL SELECT 'NAUCZYCIELE', COUNT(*) FROM NAUCZYCIELE
UNION ALL SELECT 'LEKCJE', COUNT(*) FROM LEKCJE
UNION ALL SELECT 'OCENY', COUNT(*) FROM OCENY;
