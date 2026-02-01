-- ============================================================================
-- Projekt: Szkola Muzyczna - Obiektowa Baza Danych
-- Plik: 05_dane.sql
-- Opis: Wstawienie danych poczatkowych (slowniki + przykladowe dane)
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================
-- WERSJA: MALA SZKOLA (48 uczniow, 9 nauczycieli, 6 sal, 6 grup)
-- ============================================================================
-- UWAGA: Ten plik wymaga uzycia 03_pakiety_v2.sql i 04_triggery_v2.sql!
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- ============================================================================
-- 1. CZYSZCZENIE DANYCH (w kolejnosci zaleznosci)
-- ============================================================================

DELETE FROM OCENY;
DELETE FROM LEKCJE;
DELETE FROM UCZNIOWIE;
DELETE FROM GRUPY;
DELETE FROM SALE;
DELETE FROM NAUCZYCIELE;
DELETE FROM PRZEDMIOTY;
DELETE FROM INSTRUMENTY;
COMMIT;

-- Reset sekwencji (Oracle 12c+ skladnia)
DECLARE
    PROCEDURE reset_seq(p_seq_name VARCHAR2) IS
        v_val NUMBER;
    BEGIN
        EXECUTE IMMEDIATE 'SELECT ' || p_seq_name || '.NEXTVAL FROM DUAL' INTO v_val;
        EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || p_seq_name || ' INCREMENT BY -' || v_val || ' MINVALUE 0';
        EXECUTE IMMEDIATE 'SELECT ' || p_seq_name || '.NEXTVAL FROM DUAL' INTO v_val;
        EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || p_seq_name || ' INCREMENT BY 1 MINVALUE 0';
    EXCEPTION
        WHEN OTHERS THEN NULL;
    END;
BEGIN
    reset_seq('seq_instrumenty');
    reset_seq('seq_przedmioty');
    reset_seq('seq_nauczyciele');
    reset_seq('seq_grupy');
    reset_seq('seq_sale');
    reset_seq('seq_uczniowie');
    reset_seq('seq_lekcje');
    reset_seq('seq_oceny');
END;
/

-- ============================================================================
-- 2. INSTRUMENTY (5 rekordow)
-- ============================================================================

BEGIN
    PKG_SLOWNIKI.dodaj_instrument('Fortepian', 'N');
    PKG_SLOWNIKI.dodaj_instrument('Skrzypce', 'T');
    PKG_SLOWNIKI.dodaj_instrument('Gitara', 'N');
    PKG_SLOWNIKI.dodaj_instrument('Flet', 'T');
    PKG_SLOWNIKI.dodaj_instrument('Perkusja', 'T');
    DBMS_OUTPUT.PUT_LINE('Dodano 5 instrumentow');
END;
/

-- ============================================================================
-- 3. PRZEDMIOTY (10 rekordow)
-- ============================================================================

BEGIN
    -- Indywidualne - instrumenty
    PKG_SLOWNIKI.dodaj_przedmiot('Fortepian', 'indywidualny', 45, T_WYPOSAZENIE('fortepian'));
    PKG_SLOWNIKI.dodaj_przedmiot('Skrzypce', 'indywidualny', 45, T_WYPOSAZENIE('pianino', 'pulpit'));
    PKG_SLOWNIKI.dodaj_przedmiot('Gitara', 'indywidualny', 45, NULL);
    PKG_SLOWNIKI.dodaj_przedmiot('Flet', 'indywidualny', 45, T_WYPOSAZENIE('pianino', 'pulpit'));
    PKG_SLOWNIKI.dodaj_przedmiot('Perkusja', 'indywidualny', 45, T_WYPOSAZENIE('perkusja'));

    -- Grupowe
    PKG_SLOWNIKI.dodaj_przedmiot('Ksztalcenie sluchu', 'grupowy', 45, T_WYPOSAZENIE('tablica', 'pianino'));
    PKG_SLOWNIKI.dodaj_przedmiot('Rytmika', 'grupowy', 45, T_WYPOSAZENIE('lustra'));
    PKG_SLOWNIKI.dodaj_przedmiot('Audycje muzyczne', 'grupowy', 45, T_WYPOSAZENIE('tablica'));
    PKG_SLOWNIKI.dodaj_przedmiot('Chor', 'grupowy', 90, T_WYPOSAZENIE('naglosnienie'));
    PKG_SLOWNIKI.dodaj_przedmiot('Orkiestra', 'grupowy', 90, T_WYPOSAZENIE('pulpity'));
    
    DBMS_OUTPUT.PUT_LINE('Dodano 10 przedmiotow');
END;
/

-- ============================================================================
-- 4. SALE (15 rekordow - 12 indywidualnych + 3 grupowe)
-- ============================================================================

BEGIN
    -- Sale indywidualne (12) - maksimum zasobów
    PKG_SLOWNIKI.dodaj_sale('101', 'indywidualna', 3, T_WYPOSAZENIE('fortepian'));
    PKG_SLOWNIKI.dodaj_sale('102', 'indywidualna', 3, T_WYPOSAZENIE('fortepian'));
    PKG_SLOWNIKI.dodaj_sale('103', 'indywidualna', 3, T_WYPOSAZENIE('fortepian'));
    PKG_SLOWNIKI.dodaj_sale('104', 'indywidualna', 3, T_WYPOSAZENIE('fortepian'));
    PKG_SLOWNIKI.dodaj_sale('105', 'indywidualna', 3, T_WYPOSAZENIE('pianino', 'pulpit'));
    PKG_SLOWNIKI.dodaj_sale('106', 'indywidualna', 3, T_WYPOSAZENIE('pianino', 'pulpit'));
    PKG_SLOWNIKI.dodaj_sale('107', 'indywidualna', 3, T_WYPOSAZENIE('pianino', 'pulpit'));
    PKG_SLOWNIKI.dodaj_sale('108', 'indywidualna', 3, T_WYPOSAZENIE('pianino', 'pulpit'));
    PKG_SLOWNIKI.dodaj_sale('109', 'indywidualna', 3, T_WYPOSAZENIE('gitara'));
    PKG_SLOWNIKI.dodaj_sale('110', 'indywidualna', 3, T_WYPOSAZENIE('gitara'));
    PKG_SLOWNIKI.dodaj_sale('111', 'indywidualna', 3, T_WYPOSAZENIE('perkusja'));
    PKG_SLOWNIKI.dodaj_sale('112', 'indywidualna', 3, T_WYPOSAZENIE('perkusja'));

    -- Sale grupowe (3) - wyposażone we wszystko
    PKG_SLOWNIKI.dodaj_sale('201', 'grupowa', 20, T_WYPOSAZENIE('tablica', 'pianino', 'lustra', 'naglosnienie', 'pulpity'));
    PKG_SLOWNIKI.dodaj_sale('202', 'grupowa', 20, T_WYPOSAZENIE('tablica', 'pianino', 'lustra', 'naglosnienie', 'pulpity'));
    PKG_SLOWNIKI.dodaj_sale('203', 'grupowa', 20, T_WYPOSAZENIE('tablica', 'pianino', 'lustra', 'naglosnienie', 'pulpity'));
    
    DBMS_OUTPUT.PUT_LINE('Dodano 15 sal (12 indywidualnych + 3 grupowe)');
END;
/

-- ============================================================================
-- 5. GRUPY (6 rekordow - 1 grupa na rocznik)
-- ============================================================================

BEGIN
    -- Klasy I-III 
    PKG_SLOWNIKI.dodaj_grupe('1A', 1, '2025/2026');
    PKG_SLOWNIKI.dodaj_grupe('2A', 2, '2025/2026');
    PKG_SLOWNIKI.dodaj_grupe('3A', 3, '2025/2026');

    -- Klasy IV-VI
    PKG_SLOWNIKI.dodaj_grupe('4A', 4, '2025/2026');
    PKG_SLOWNIKI.dodaj_grupe('5A', 5, '2025/2026');
    PKG_SLOWNIKI.dodaj_grupe('6A', 6, '2025/2026');
    
    DBMS_OUTPUT.PUT_LINE('Dodano 6 grup');
END;
/

-- ============================================================================
-- 6. NAUCZYCIELE (15 rekordow - 12 instrumentalistow + 3 grupowych)
-- ============================================================================
-- Rozklad obciazenia (więcej nauczycieli = mniejsze obciążenie):
-- - Fortepian: 16 uczniow / 4 nauczycieli = 8 lekcji/tydzien/os
-- - Skrzypce: 12 uczniow / 3 nauczycieli = 8 lekcji/tydzien/os
-- - Gitara: 10 uczniow / 2 nauczycieli = 10 lekcji/tydzien/os
-- - Flet: 6 uczniow / 2 nauczycieli = 6 lekcji/tydzien/os
-- - Perkusja: 4 uczniow / 1 nauczyciel = 8 lekcji/tydzien
-- ============================================================================

BEGIN
    -- Nauczyciele instrumentow (12) - więcej nauczycieli na popularne instrumenty
    PKG_OSOBY.dodaj_nauczyciela('Anna', 'Kowalska', T_INSTRUMENTY_TAB('Fortepian'), 'kowalska@szkola.pl', '601111111');
    PKG_OSOBY.dodaj_nauczyciela('Jan', 'Nowak', T_INSTRUMENTY_TAB('Fortepian'), 'nowak@szkola.pl', '602222222');
    PKG_OSOBY.dodaj_nauczyciela('Piotr', 'Szymanski', T_INSTRUMENTY_TAB('Fortepian'), 'szymanski@szkola.pl', '603333333');
    PKG_OSOBY.dodaj_nauczyciela('Monika', 'Nowicka', T_INSTRUMENTY_TAB('Fortepian'), 'nowicka@szkola.pl', '601444444');
    PKG_OSOBY.dodaj_nauczyciela('Marek', 'Wisniewski', T_INSTRUMENTY_TAB('Skrzypce'), 'wisniewski@szkola.pl', '604444444');
    PKG_OSOBY.dodaj_nauczyciela('Tomasz', 'Kaminski', T_INSTRUMENTY_TAB('Skrzypce'), 'kaminski@szkola.pl', '605555555');
    PKG_OSOBY.dodaj_nauczyciela('Agnieszka', 'Kubiak', T_INSTRUMENTY_TAB('Skrzypce'), 'kubiak@szkola.pl', '605666666');
    PKG_OSOBY.dodaj_nauczyciela('Adam', 'Lewandowski', T_INSTRUMENTY_TAB('Gitara'), 'lewandowski@szkola.pl', '607777777');
    PKG_OSOBY.dodaj_nauczyciela('Pawel', 'Wojcik', T_INSTRUMENTY_TAB('Gitara'), 'wojcik@szkola.pl', '608888888');
    PKG_OSOBY.dodaj_nauczyciela('Ewa', 'Zielinska', T_INSTRUMENTY_TAB('Flet'), 'zielinska@szkola.pl', '606666666');
    PKG_OSOBY.dodaj_nauczyciela('Katarzyna', 'Olszewska', T_INSTRUMENTY_TAB('Flet'), 'olszewska@szkola.pl', '606777777');
    PKG_OSOBY.dodaj_nauczyciela('Krzysztof', 'Dabrowski', T_INSTRUMENTY_TAB('Perkusja'), 'dabrowski@szkola.pl', '609999999');

    -- Nauczyciele przedmiotow grupowych (3) - więcej dla lepszego rozkładu
    PKG_OSOBY.dodaj_nauczyciela('Maria', 'Jankowska', NULL, 'jankowska@szkola.pl', '610000000');
    PKG_OSOBY.dodaj_nauczyciela('Robert', 'Krawczyk', NULL, 'krawczyk@szkola.pl', '612222222');
    PKG_OSOBY.dodaj_nauczyciela('Barbara', 'Mazur', NULL, 'mazur@szkola.pl', '613333333');
    
    DBMS_OUTPUT.PUT_LINE('Dodano 15 nauczycieli (12 instrumentalistow + 3 grupowych)');
END;
/

-- ============================================================================
-- 7. UCZNIOWIE (48 uczniow rozlozonych w 6 grupach)
-- ============================================================================
-- Struktura:
-- - Klasa 1A: 10 uczniow (F:4, S:2, G:2, Fl:1, P:1)
-- - Klasa 2A: 10 uczniow (F:3, S:2, G:2, Fl:2, P:1)
-- - Klasa 3A: 8 uczniow  (F:3, S:2, G:2, Fl:1, P:0)
-- - Klasa 4A: 8 uczniow  (F:2, S:2, G:2, Fl:1, P:1)
-- - Klasa 5A: 6 uczniow  (F:2, S:2, G:1, Fl:1, P:0)
-- - Klasa 6A: 6 uczniow  (F:2, S:2, G:1, Fl:0, P:1)
-- RAZEM: 48 uczniow (F:16, S:12, G:10, Fl:6, P:4)
-- ============================================================================

BEGIN
    -- Klasa 1A (10 uczniow)
    PKG_OSOBY.dodaj_ucznia('Jan', 'Kowalski', DATE '2019-03-15', '1A', 'Fortepian', 'kowalski.rodzic@email.pl', '500100101');
    PKG_OSOBY.dodaj_ucznia('Anna', 'Nowak', DATE '2019-05-20', '1A', 'Fortepian', 'nowak.rodzic@email.pl', '500100102');
    PKG_OSOBY.dodaj_ucznia('Piotr', 'Wisniewski', DATE '2019-01-10', '1A', 'Skrzypce', 'wisniewski.rodzic@email.pl', '500100103');
    PKG_OSOBY.dodaj_ucznia('Maria', 'Wojcik', DATE '2019-07-25', '1A', 'Gitara', 'wojcik.rodzic@email.pl', '500100104');
    PKG_OSOBY.dodaj_ucznia('Tomasz', 'Kaminski', DATE '2019-02-28', '1A', 'Flet', 'kaminski.rodzic@email.pl', '500100105');
    PKG_OSOBY.dodaj_ucznia('Ewa', 'Lewandowska', DATE '2019-09-12', '1A', 'Fortepian', 'lewandowska.rodzic@email.pl', '500100106');
    PKG_OSOBY.dodaj_ucznia('Adam', 'Zielinski', DATE '2019-04-08', '1A', 'Skrzypce', 'zielinski.rodzic@email.pl', '500100107');
    PKG_OSOBY.dodaj_ucznia('Katarzyna', 'Szymanska', DATE '2019-11-30', '1A', 'Fortepian', 'szymanska.rodzic@email.pl', '500100108');
    PKG_OSOBY.dodaj_ucznia('Michal', 'Dabrowski', DATE '2019-06-18', '1A', 'Gitara', 'dabrowski.rodzic@email.pl', '500100109');
    PKG_OSOBY.dodaj_ucznia('Jakub', 'Jankowski', DATE '2019-10-05', '1A', 'Perkusja', 'jankowski.rodzic@email.pl', '500100110');
    
    DBMS_OUTPUT.PUT_LINE('Dodano 10 uczniow klasy 1A');
END;
/

BEGIN
    -- Klasa 2A (10 uczniow)
    PKG_OSOBY.dodaj_ucznia('Oskar', 'Walczak', DATE '2018-02-14', '2A', 'Fortepian', 'walczak.rodzic@email.pl', '500100201');
    PKG_OSOBY.dodaj_ucznia('Hanna', 'Gorska', DATE '2018-04-19', '2A', 'Skrzypce', 'gorska.rodzic@email.pl', '500100202');
    PKG_OSOBY.dodaj_ucznia('Antoni', 'Sikora', DATE '2018-06-25', '2A', 'Gitara', 'sikora.rodzic@email.pl', '500100203');
    PKG_OSOBY.dodaj_ucznia('Emilia', 'Baran', DATE '2018-08-11', '2A', 'Fortepian', 'baran.rodzic@email.pl', '500100204');
    PKG_OSOBY.dodaj_ucznia('Leon', 'Laskowski', DATE '2018-01-07', '2A', 'Flet', 'laskowski.rodzic@email.pl', '500100205');
    PKG_OSOBY.dodaj_ucznia('Amelia', 'Kucharska', DATE '2018-03-22', '2A', 'Fortepian', 'kucharska.rodzic@email.pl', '500100206');
    PKG_OSOBY.dodaj_ucznia('Franciszek', 'Kalinowski', DATE '2018-05-30', '2A', 'Skrzypce', 'kalinowski.rodzic@email.pl', '500100207');
    PKG_OSOBY.dodaj_ucznia('Antonina', 'Mazurkiewicz', DATE '2018-07-15', '2A', 'Gitara', 'mazurkiewicz.rodzic@email.pl', '500100208');
    PKG_OSOBY.dodaj_ucznia('Nadia', 'Kwiatkowska', DATE '2018-11-04', '2A', 'Perkusja', 'kwiatkowska.rodzic@email.pl', '500100209');
    PKG_OSOBY.dodaj_ucznia('Borys', 'Jablonski', DATE '2018-09-21', '2A', 'Flet', 'jablonski.rodzic@email.pl', '500100210');
    
    DBMS_OUTPUT.PUT_LINE('Dodano 10 uczniow klasy 2A');
END;
/

BEGIN
    -- Klasa 3A (8 uczniow)
    PKG_OSOBY.dodaj_ucznia('Tymoteusz', 'Bak', DATE '2017-01-11', '3A', 'Fortepian', 'bak.rodzic@email.pl', '500100301');
    PKG_OSOBY.dodaj_ucznia('Laura', 'Pietrzak', DATE '2017-03-18', '3A', 'Skrzypce', 'pietrzak.rodzic@email.pl', '500100302');
    PKG_OSOBY.dodaj_ucznia('Ksawery', 'Tomczak', DATE '2017-05-25', '3A', 'Gitara', 'tomczak.rodzic@email.pl', '500100303');
    PKG_OSOBY.dodaj_ucznia('Marcelina', 'Jaworski', DATE '2017-07-02', '3A', 'Fortepian', 'jaworski.rodzic@email.pl', '500100304');
    PKG_OSOBY.dodaj_ucznia('Kajetan', 'Malinowski', DATE '2017-09-14', '3A', 'Flet', 'malinowski.rodzic@email.pl', '500100305');
    PKG_OSOBY.dodaj_ucznia('Blanka', 'Pawlik', DATE '2017-11-21', '3A', 'Fortepian', 'pawlik.rodzic@email.pl', '500100306');
    PKG_OSOBY.dodaj_ucznia('Ryszard', 'Gorski', DATE '2017-02-07', '3A', 'Skrzypce', 'gorski.rodzic@email.pl', '500100307');
    PKG_OSOBY.dodaj_ucznia('Iga', 'Szewczyk', DATE '2017-04-13', '3A', 'Gitara', 'szewczyk.rodzic@email.pl', '500100308');
    
    DBMS_OUTPUT.PUT_LINE('Dodano 8 uczniow klasy 3A');
END;
/

BEGIN
    -- Klasa 4A (8 uczniow)
    PKG_OSOBY.dodaj_ucznia('Hubert', 'Lis', DATE '2016-02-08', '4A', 'Fortepian', 'lis.rodzic@email.pl', '500100401');
    PKG_OSOBY.dodaj_ucznia('Weronika', 'Mazurek', DATE '2016-04-15', '4A', 'Skrzypce', 'mazurek.rodzic@email.pl', '500100402');
    PKG_OSOBY.dodaj_ucznia('Radoslaw', 'Szymczak', DATE '2016-06-22', '4A', 'Gitara', 'szymczak.rodzic@email.pl', '500100403');
    PKG_OSOBY.dodaj_ucznia('Milena', 'Zawadzki', DATE '2016-08-29', '4A', 'Fortepian', 'zawadzki.rodzic@email.pl', '500100404');
    PKG_OSOBY.dodaj_ucznia('Arkadiusz', 'Sobczak', DATE '2016-10-06', '4A', 'Flet', 'sobczak.rodzic@email.pl', '500100405');
    PKG_OSOBY.dodaj_ucznia('Dawid', 'Borkowski', DATE '2016-01-20', '4A', 'Skrzypce', 'borkowski.rodzic@email.pl', '500100406');
    PKG_OSOBY.dodaj_ucznia('Malwina', 'Sadowski', DATE '2016-03-27', '4A', 'Gitara', 'sadowski.rodzic@email.pl', '500100407');
    PKG_OSOBY.dodaj_ucznia('Jowita', 'Wasilewski', DATE '2016-07-11', '4A', 'Perkusja', 'wasilewski.rodzic@email.pl', '500100408');
    
    DBMS_OUTPUT.PUT_LINE('Dodano 8 uczniow klasy 4A');
END;
/

BEGIN
    -- Klasa 5A (6 uczniow)
    PKG_OSOBY.dodaj_ucznia('Dominik', 'Zakrzewski', DATE '2015-01-16', '5A', 'Fortepian', 'zakrzewski.rodzic@email.pl', '500100501');
    PKG_OSOBY.dodaj_ucznia('Klaudia', 'Krajewski', DATE '2015-03-23', '5A', 'Skrzypce', 'krajewski.rodzic@email.pl', '500100502');
    PKG_OSOBY.dodaj_ucznia('Grzegorz', 'Nowicki', DATE '2015-05-30', '5A', 'Gitara', 'nowicki.rodzic@email.pl', '500100503');
    PKG_OSOBY.dodaj_ucznia('Karolina', 'Adamski', DATE '2015-07-07', '5A', 'Fortepian', 'adamski.rodzic@email.pl', '500100504');
    PKG_OSOBY.dodaj_ucznia('Artur', 'Sikorski', DATE '2015-09-14', '5A', 'Flet', 'sikorski.rodzic@email.pl', '500100505');
    PKG_OSOBY.dodaj_ucznia('Rafal', 'Mroz', DATE '2015-02-28', '5A', 'Skrzypce', 'mroz.rodzic@email.pl', '500100506');
    
    DBMS_OUTPUT.PUT_LINE('Dodano 6 uczniow klasy 5A');
END;
/

BEGIN
    -- Klasa 6A (6 uczniow - dyplomanci)
    PKG_OSOBY.dodaj_ucznia('Maciej', 'Bednarski', DATE '2014-02-17', '6A', 'Fortepian', 'bednarski.rodzic@email.pl', '500100601');
    PKG_OSOBY.dodaj_ucznia('Renata', 'Kacprzak', DATE '2014-04-24', '6A', 'Skrzypce', 'kacprzak.rodzic@email.pl', '500100602');
    PKG_OSOBY.dodaj_ucznia('Marcin', 'Duda', DATE '2014-06-01', '6A', 'Gitara', 'duda.rodzic@email.pl', '500100603');
    PKG_OSOBY.dodaj_ucznia('Izabela', 'Kurek', DATE '2014-08-08', '6A', 'Fortepian', 'kurek.rodzic@email.pl', '500100604');
    PKG_OSOBY.dodaj_ucznia('Andrzej', 'Sobieski', DATE '2014-01-29', '6A', 'Skrzypce', 'sobieski.rodzic@email.pl', '500100605');
    PKG_OSOBY.dodaj_ucznia('Anna', 'Borkowska', DATE '2014-07-22', '6A', 'Perkusja', 'borkowska.rodzic@email.pl', '500100606');
    
    DBMS_OUTPUT.PUT_LINE('Dodano 6 uczniow klasy 6A (dyplomanci)');
END;
/

COMMIT;

-- ============================================================================
-- 8. AUTOMATYCZNE GENEROWANIE PLANU LEKCJI (HEURYSTYKA)
-- ============================================================================
-- System automatycznie generuje plan dla WSZYSTKICH uczniow:
-- - 2 lekcje indywidualne instrumentu tygodniowo na ucznia
-- - Lekcje grupowe dla kazdej grupy
-- - Chor i Orkiestra dla klas IV-VI
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT   GENEROWANIE PELNEGO PLANU LEKCJI (AUTOMATYCZNIE)
PROMPT   Szkola: 48 uczniow, 15 nauczycieli, 15 sal, 6 grup
PROMPT ============================================================
PROMPT

-- Generuj plan dla 4 tygodni semestru (luty 2026)
-- Tydzien 1: 2026-02-02 (poniedzialek)
-- Tydzien 2: 2026-02-09
-- Tydzien 3: 2026-02-16
-- Tydzien 4: 2026-02-23

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('GENEROWANIE PLANU - TYDZIEN 1');
    DBMS_OUTPUT.PUT_LINE('Data: 2026-02-02 (poniedzialek)');
    DBMS_OUTPUT.PUT_LINE('========================================');
    
    PKG_LEKCJE.generuj_plan_tygodnia(DATE '2026-02-02');
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('GENEROWANIE PLANU - TYDZIEN 2');
    DBMS_OUTPUT.PUT_LINE('Data: 2026-02-09 (poniedzialek)');
    DBMS_OUTPUT.PUT_LINE('========================================');
    
    PKG_LEKCJE.generuj_plan_tygodnia(DATE '2026-02-09');
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('GENEROWANIE PLANU - TYDZIEN 3');
    DBMS_OUTPUT.PUT_LINE('Data: 2026-02-16 (poniedzialek)');
    DBMS_OUTPUT.PUT_LINE('========================================');
    
    PKG_LEKCJE.generuj_plan_tygodnia(DATE '2026-02-16');
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('GENEROWANIE PLANU - TYDZIEN 4');
    DBMS_OUTPUT.PUT_LINE('Data: 2026-02-23 (poniedzialek)');
    DBMS_OUTPUT.PUT_LINE('========================================');
    
    PKG_LEKCJE.generuj_plan_tygodnia(DATE '2026-02-23');
END;
/

COMMIT;

-- ============================================================================
-- 9. EGZAMINY DLA KLASY 6A (DYPLOMANCI)
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT   EGZAMINY SEMESTRALNE - KLASA 6A
PROMPT ============================================================
PROMPT

DECLARE
    v_data_egz DATE := DATE '2026-02-27';  -- piatek
    v_godzina VARCHAR2(5) := '14:00';
    v_godzina_num NUMBER := 14;
    v_ile NUMBER := 0;
BEGIN
    FOR rec IN (
        SELECT u.imie, u.nazwisko
        FROM UCZNIOWIE u
        WHERE DEREF(u.ref_grupa).kod = '6A'
        ORDER BY u.nazwisko
    ) LOOP
        BEGIN
            PKG_LEKCJE.dodaj_egzamin(
                p_uczen_nazwisko => rec.nazwisko,
                p_uczen_imie => rec.imie,
                p_sala_numer => '203',
                p_data => v_data_egz,
                p_godzina => v_godzina,
                p_komisja_nazwisko1 => 'Kowalska',
                p_komisja_nazwisko2 => 'Nowak',
                p_czas_min => 30
            );
            DBMS_OUTPUT.PUT_LINE('Egzamin dla: ' || rec.imie || ' ' || rec.nazwisko || ' o ' || v_godzina);
            v_ile := v_ile + 1;
            
            v_godzina_num := v_godzina_num + 1;
            IF v_godzina_num >= 20 THEN
                v_godzina_num := 14;
                v_data_egz := v_data_egz + 7;
            END IF;
            v_godzina := TO_CHAR(v_godzina_num, 'FM00') || ':00';
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Blad egzaminu dla ' || rec.imie || ' ' || rec.nazwisko || ': ' || SQLERRM);
        END;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Dodano ' || v_ile || ' egzaminow dla klasy 6A');
END;
/

COMMIT;

-- ============================================================================
-- 10. PRZYKLADOWE OCENY
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT   OCENY - PRZYKLADOWE DANE
PROMPT ============================================================
PROMPT

DECLARE
    v_ocena NUMBER;
    v_obszar VARCHAR2(20);
    v_ile_ocen NUMBER := 0;
    v_nauczyciel VARCHAR2(100);
BEGIN
    FOR rec IN (
        SELECT u.imie, u.nazwisko, DEREF(u.ref_instrument).nazwa AS instrument
        FROM UCZNIOWIE u
        ORDER BY u.nazwisko
    ) LOOP
        -- Znajdz nauczyciela od tego instrumentu
        BEGIN
            SELECT n.nazwisko INTO v_nauczyciel
            FROM NAUCZYCIELE n, TABLE(n.instrumenty) i
            WHERE i.COLUMN_VALUE = rec.instrument
            AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN v_nauczyciel := NULL;
        END;
        
        IF v_nauczyciel IS NOT NULL THEN
            -- 2 oceny na ucznia
            FOR j IN 1..2 LOOP
                v_ocena := ROUND(DBMS_RANDOM.VALUE(3, 6));
                
                CASE MOD(j, 3)
                    WHEN 0 THEN v_obszar := 'technika';
                    WHEN 1 THEN v_obszar := 'interpretacja';
                    WHEN 2 THEN v_obszar := 'postepy';
                END CASE;
                
                BEGIN
                    PKG_OCENY.wystaw_ocene(
                        p_uczen_nazwisko => rec.nazwisko,
                        p_uczen_imie => rec.imie,
                        p_nauczyciel_nazwisko => v_nauczyciel,
                        p_przedmiot => rec.instrument,
                        p_wartosc => v_ocena,
                        p_obszar => v_obszar,
                        p_komentarz => 'Ocena ' || v_obszar
                    );
                    v_ile_ocen := v_ile_ocen + 1;
                EXCEPTION
                    WHEN OTHERS THEN NULL;
                END;
            END LOOP;
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Dodano ' || v_ile_ocen || ' ocen');
END;
/

COMMIT;

-- ============================================================================
-- 11. PODSUMOWANIE
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT   PODSUMOWANIE WSTAWIONYCH DANYCH
PROMPT ============================================================
PROMPT

SELECT 'INSTRUMENTY' AS tabela, COUNT(*) AS liczba FROM INSTRUMENTY
UNION ALL SELECT 'PRZEDMIOTY', COUNT(*) FROM PRZEDMIOTY
UNION ALL SELECT 'SALE', COUNT(*) FROM SALE
UNION ALL SELECT 'GRUPY', COUNT(*) FROM GRUPY
UNION ALL SELECT 'NAUCZYCIELE', COUNT(*) FROM NAUCZYCIELE
UNION ALL SELECT 'UCZNIOWIE', COUNT(*) FROM UCZNIOWIE
UNION ALL SELECT 'LEKCJE', COUNT(*) FROM LEKCJE
UNION ALL SELECT 'OCENY', COUNT(*) FROM OCENY;

-- Rozklad uczniow wg instrumentu
PROMPT
PROMPT Rozklad uczniow wg instrumentu:
SELECT i.nazwa AS instrument, COUNT(*) AS uczniow
FROM UCZNIOWIE u
JOIN INSTRUMENTY i ON u.ref_instrument.id_instrumentu = i.id_instrumentu
GROUP BY i.nazwa
ORDER BY COUNT(*) DESC;

-- Rozklad lekcji wg typu
PROMPT
PROMPT Rozklad lekcji wg typu:
SELECT 
    CASE WHEN ref_uczen IS NOT NULL THEN 'indywidualna' ELSE 'grupowa' END AS typ_lekcji,
    typ_lekcji AS rodzaj,
    COUNT(*) AS liczba
FROM LEKCJE
GROUP BY CASE WHEN ref_uczen IS NOT NULL THEN 'indywidualna' ELSE 'grupowa' END, typ_lekcji
ORDER BY 1, 2;

PROMPT
PROMPT ============================================================
PROMPT   ZAKONCZONO WSTAWIANIE DANYCH
PROMPT   Szkola: 48 uczniow, 15 nauczycieli, 15 sal, 6 grup
PROMPT ============================================================
PROMPT
