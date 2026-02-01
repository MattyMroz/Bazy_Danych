-- ============================================================================
-- Projekt: Szkola Muzyczna - Obiektowa Baza Danych
-- Plik: 06_testy.sql
-- Opis: Scenariusze testowe - testowanie systemu za pomoca procedur
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================
-- UWAGA: Uruchomic PO wykonaniu 05_dane.sql (dane musza byc zaimportowane!)
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- ============================================================================
-- SCENARIUSZ 1: Nowy uczen dochodzi do szkoly w trakcie semestru
-- ============================================================================
-- Jasio Kotek zostaje przyjety do klasy 1A na Fortepian.
-- System musi:
-- 1. Dodac ucznia do bazy
-- 2. Wygenerowac dla niego plan lekcji indywidualnych
-- 3. Wyswietlic jego plan
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT   SCENARIUSZ 1: Nowy uczen - Jasio Kotek
PROMPT ============================================================
PROMPT

DECLARE
    v_uczen_przed NUMBER;
    v_uczen_po NUMBER;
    v_lekcje_przed NUMBER;
    v_lekcje_po NUMBER;
BEGIN
    -- Stan PRZED
    SELECT COUNT(*) INTO v_uczen_przed FROM UCZNIOWIE;
    SELECT COUNT(*) INTO v_lekcje_przed FROM LEKCJE WHERE ref_uczen IS NOT NULL;
    
    DBMS_OUTPUT.PUT_LINE('=== STAN PRZED ===');
    DBMS_OUTPUT.PUT_LINE('Liczba uczniow: ' || v_uczen_przed);
    DBMS_OUTPUT.PUT_LINE('Liczba lekcji indywidualnych: ' || v_lekcje_przed);
    DBMS_OUTPUT.PUT_LINE('');
    
    -- KROK 1: Dodaj nowego ucznia
    DBMS_OUTPUT.PUT_LINE('=== KROK 1: Dodawanie ucznia Jasio Kotek ===');
    PKG_OSOBY.dodaj_ucznia(
        p_imie => 'Jasio',
        p_nazwisko => 'Kotek',
        p_data_urodzenia => DATE '2019-06-15',
        p_grupa_kod => '1A',
        p_instrument_nazwa => 'Fortepian',
        p_email_rodzica => 'kotek.rodzic@email.pl',
        p_telefon_rodzica => '500999888'
    );
    DBMS_OUTPUT.PUT_LINE('OK: Dodano ucznia Jasio Kotek do klasy 1A (Fortepian)');
    
    -- KROK 2: Wygeneruj plan dla nowego tygodnia (marzec 2026)
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== KROK 2: Generowanie planu na nowy tydzien ===');
    PKG_LEKCJE.generuj_plan_tygodnia(DATE '2026-03-02');
    
    -- Stan PO
    SELECT COUNT(*) INTO v_uczen_po FROM UCZNIOWIE;
    SELECT COUNT(*) INTO v_lekcje_po FROM LEKCJE WHERE ref_uczen IS NOT NULL;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== STAN PO ===');
    DBMS_OUTPUT.PUT_LINE('Liczba uczniow: ' || v_uczen_po || ' (bylo: ' || v_uczen_przed || ')');
    DBMS_OUTPUT.PUT_LINE('Liczba lekcji indywidualnych: ' || v_lekcje_po || ' (bylo: ' || v_lekcje_przed || ')');
    
    -- Weryfikacja
    IF v_uczen_po = v_uczen_przed + 1 THEN
        DBMS_OUTPUT.PUT_LINE('TEST PASSED: Uczen dodany poprawnie');
    ELSE
        DBMS_OUTPUT.PUT_LINE('TEST FAILED: Uczen nie zostal dodany!');
    END IF;
END;
/

-- Wyswietl plan Jasia Kotka
PROMPT
PROMPT === PLAN LEKCJI: Jasio Kotek ===
SELECT 
    TO_CHAR(l.data_lekcji, 'YYYY-MM-DD') AS data,
    TO_CHAR(l.data_lekcji, 'Day', 'NLS_DATE_LANGUAGE=POLISH') AS dzien,
    l.godzina_rozp AS godzina,
    DEREF(l.ref_przedmiot).nazwa AS przedmiot,
    DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
    DEREF(l.ref_sala).numer AS sala,
    l.czas_trwania || ' min' AS czas
FROM LEKCJE l
WHERE DEREF(l.ref_uczen).nazwisko = 'Kotek'
  AND DEREF(l.ref_uczen).imie = 'Jasio'
ORDER BY l.data_lekcji, l.godzina_rozp;

COMMIT;

-- ============================================================================
-- SCENARIUSZ 2: Nowy nauczyciel dochodzi do szkoly
-- ============================================================================
-- Szkola zatrudnia nowego nauczyciela Skrzypiec.
-- System musi:
-- 1. Dodac nauczyciela
-- 2. Sprawdzic czy moze prowadzic lekcje
-- 3. Wyswietlic dostepnych nauczycieli Skrzypiec
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT   SCENARIUSZ 2: Nowy nauczyciel - Zbigniew Melodia
PROMPT ============================================================
PROMPT

DECLARE
    v_nauczyciele_przed NUMBER;
    v_nauczyciele_po NUMBER;
BEGIN
    -- Stan PRZED
    SELECT COUNT(*) INTO v_nauczyciele_przed FROM NAUCZYCIELE;
    
    DBMS_OUTPUT.PUT_LINE('=== STAN PRZED ===');
    DBMS_OUTPUT.PUT_LINE('Liczba nauczycieli: ' || v_nauczyciele_przed);
    
    -- Dodaj nowego nauczyciela
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== Dodawanie nauczyciela Zbigniew Melodia (Skrzypce) ===');
    PKG_OSOBY.dodaj_nauczyciela(
        p_imie => 'Zbigniew',
        p_nazwisko => 'Melodia',
        p_instrumenty => T_INSTRUMENTY_TAB('Skrzypce'),
        p_email => 'melodia@szkola.pl',
        p_telefon => '600123456'
    );
    
    -- Stan PO
    SELECT COUNT(*) INTO v_nauczyciele_po FROM NAUCZYCIELE;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== STAN PO ===');
    DBMS_OUTPUT.PUT_LINE('Liczba nauczycieli: ' || v_nauczyciele_po || ' (bylo: ' || v_nauczyciele_przed || ')');
    
    IF v_nauczyciele_po = v_nauczyciele_przed + 1 THEN
        DBMS_OUTPUT.PUT_LINE('TEST PASSED: Nauczyciel dodany poprawnie');
    ELSE
        DBMS_OUTPUT.PUT_LINE('TEST FAILED: Nauczyciel nie zostal dodany!');
    END IF;
END;
/

-- Lista nauczycieli Skrzypiec
PROMPT
PROMPT === Nauczyciele Skrzypiec (po dodaniu nowego) ===
SELECT 
    n.imie || ' ' || n.nazwisko AS nauczyciel,
    n.email,
    n.telefon
FROM NAUCZYCIELE n, TABLE(n.instrumenty) i
WHERE i.COLUMN_VALUE = 'Skrzypce'
ORDER BY n.nazwisko;

COMMIT;

-- ============================================================================
-- SCENARIUSZ 3: Wyswietlenie planu nauczyciela
-- ============================================================================
-- Nauczyciel Anna Kowalska chce zobaczyc swoj plan na tydzien.
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT   SCENARIUSZ 3: Plan nauczyciela - Anna Kowalska
PROMPT ============================================================
PROMPT

PROMPT === PLAN LEKCJI: Anna Kowalska (tydzien 2026-02-02) ===
SELECT 
    TO_CHAR(l.data_lekcji, 'YYYY-MM-DD') AS data,
    TO_CHAR(l.data_lekcji, 'Dy', 'NLS_DATE_LANGUAGE=POLISH') AS dzien,
    l.godzina_rozp AS godzina,
    DEREF(l.ref_przedmiot).nazwa AS przedmiot,
    CASE 
        WHEN l.ref_uczen IS NOT NULL THEN DEREF(l.ref_uczen).imie || ' ' || DEREF(l.ref_uczen).nazwisko
        ELSE 'Grupa: ' || DEREF(l.ref_grupa).kod
    END AS uczen_grupa,
    DEREF(l.ref_sala).numer AS sala,
    l.czas_trwania || ' min' AS czas
FROM LEKCJE l
WHERE DEREF(l.ref_nauczyciel).nazwisko = 'Kowalska'
  AND DEREF(l.ref_nauczyciel).imie = 'Anna'
  AND l.data_lekcji BETWEEN DATE '2026-02-02' AND DATE '2026-02-06'
ORDER BY l.data_lekcji, l.godzina_rozp;

-- ============================================================================
-- SCENARIUSZ 4: Wystawianie ocen uczniowi
-- ============================================================================
-- Nauczyciel wystawia oceny uczniowi po lekcji.
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT   SCENARIUSZ 4: Wystawianie ocen - Jan Kowalski
PROMPT ============================================================
PROMPT

DECLARE
    v_oceny_przed NUMBER;
    v_oceny_po NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_oceny_przed 
    FROM OCENY o
    WHERE DEREF(o.ref_uczen).nazwisko = 'Kowalski' 
      AND DEREF(o.ref_uczen).imie = 'Jan';
    
    DBMS_OUTPUT.PUT_LINE('=== STAN PRZED ===');
    DBMS_OUTPUT.PUT_LINE('Liczba ocen Jana Kowalskiego: ' || v_oceny_przed);
    
    -- Wystaw nowe oceny
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== Wystawianie ocen ===');
    
    PKG_OCENY.wystaw_ocene(
        p_uczen_nazwisko => 'Kowalski',
        p_uczen_imie => 'Jan',
        p_nauczyciel_nazwisko => 'Kowalska',
        p_przedmiot => 'Fortepian',
        p_wartosc => 5,
        p_obszar => 'technika',
        p_komentarz => 'Swietna gra gam'
    );
    DBMS_OUTPUT.PUT_LINE('Dodano ocene 5 z techniki');
    
    PKG_OCENY.wystaw_ocene(
        p_uczen_nazwisko => 'Kowalski',
        p_uczen_imie => 'Jan',
        p_nauczyciel_nazwisko => 'Kowalska',
        p_przedmiot => 'Fortepian',
        p_wartosc => 4,
        p_obszar => 'interpretacja',
        p_komentarz => 'Dobra ekspresja muzyczna'
    );
    DBMS_OUTPUT.PUT_LINE('Dodano ocene 4 z interpretacji');
    
    SELECT COUNT(*) INTO v_oceny_po 
    FROM OCENY o
    WHERE DEREF(o.ref_uczen).nazwisko = 'Kowalski' 
      AND DEREF(o.ref_uczen).imie = 'Jan';
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== STAN PO ===');
    DBMS_OUTPUT.PUT_LINE('Liczba ocen Jana Kowalskiego: ' || v_oceny_po);
    
    IF v_oceny_po = v_oceny_przed + 2 THEN
        DBMS_OUTPUT.PUT_LINE('TEST PASSED: Oceny dodane poprawnie');
    ELSE
        DBMS_OUTPUT.PUT_LINE('TEST FAILED: Oceny nie zostaly dodane!');
    END IF;
END;
/

-- Wyswietl oceny ucznia
PROMPT
PROMPT === Oceny: Jan Kowalski ===
SELECT 
    DEREF(o.ref_przedmiot).nazwa AS przedmiot,
    o.wartosc AS ocena,
    o.obszar,
    o.komentarz,
    DEREF(o.ref_nauczyciel).nazwisko AS wystawil,
    TO_CHAR(o.data_wystawienia, 'YYYY-MM-DD') AS data
FROM OCENY o
WHERE DEREF(o.ref_uczen).nazwisko = 'Kowalski'
  AND DEREF(o.ref_uczen).imie = 'Jan'
ORDER BY o.data_wystawienia DESC;

COMMIT;

-- ============================================================================
-- SCENARIUSZ 5: Sprawdzenie planu grupy (lekcje grupowe)
-- ============================================================================
-- Rodzic pyta o plan lekcji grupowych dla klasy 1A.
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT   SCENARIUSZ 5: Plan lekcji grupowych - klasa 1A
PROMPT ============================================================
PROMPT

PROMPT === LEKCJE GRUPOWE: Klasa 1A (tydzien 2026-02-02) ===
SELECT 
    TO_CHAR(l.data_lekcji, 'YYYY-MM-DD') AS data,
    TO_CHAR(l.data_lekcji, 'Dy', 'NLS_DATE_LANGUAGE=POLISH') AS dzien,
    l.godzina_rozp AS godzina,
    DEREF(l.ref_przedmiot).nazwa AS przedmiot,
    DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
    DEREF(l.ref_sala).numer AS sala,
    l.czas_trwania || ' min' AS czas
FROM LEKCJE l
WHERE DEREF(l.ref_grupa).kod = '1A'
  AND l.data_lekcji BETWEEN DATE '2026-02-02' AND DATE '2026-02-06'
ORDER BY l.data_lekcji, l.godzina_rozp;

-- ============================================================================
-- SCENARIUSZ 6: Dodanie egzaminu dla ucznia
-- ============================================================================
-- Uczen zdaje egzamin promocyjny.
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT   SCENARIUSZ 6: Egzamin dla Jasia Kotka
PROMPT ============================================================
PROMPT

DECLARE
    v_egzaminy_przed NUMBER;
    v_egzaminy_po NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_egzaminy_przed 
    FROM LEKCJE WHERE typ_lekcji = 'egzamin';
    
    DBMS_OUTPUT.PUT_LINE('=== STAN PRZED ===');
    DBMS_OUTPUT.PUT_LINE('Liczba egzaminow: ' || v_egzaminy_przed);
    
    -- Dodaj egzamin
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== Dodawanie egzaminu dla Jasia Kotka ===');
    
    PKG_LEKCJE.dodaj_egzamin(
        p_uczen_nazwisko => 'Kotek',
        p_uczen_imie => 'Jasio',
        p_sala_numer => '203',
        p_data => DATE '2026-03-06',  -- piatek
        p_godzina => '16:00',
        p_komisja_nazwisko1 => 'Kowalska',
        p_komisja_nazwisko2 => 'Nowak',
        p_czas_min => 30
    );
    DBMS_OUTPUT.PUT_LINE('Egzamin zaplanowany na 2026-03-06 o 16:00');
    
    SELECT COUNT(*) INTO v_egzaminy_po 
    FROM LEKCJE WHERE typ_lekcji = 'egzamin';
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== STAN PO ===');
    DBMS_OUTPUT.PUT_LINE('Liczba egzaminow: ' || v_egzaminy_po);
    
    IF v_egzaminy_po > v_egzaminy_przed THEN
        DBMS_OUTPUT.PUT_LINE('TEST PASSED: Egzamin dodany poprawnie');
    ELSE
        DBMS_OUTPUT.PUT_LINE('TEST FAILED: Egzamin nie zostal dodany!');
    END IF;
END;
/

-- Lista egzaminow
PROMPT
PROMPT === Wszystkie zaplanowane egzaminy ===
SELECT 
    DEREF(l.ref_uczen).imie || ' ' || DEREF(l.ref_uczen).nazwisko AS uczen,
    DEREF(l.ref_przedmiot).nazwa AS przedmiot,
    TO_CHAR(l.data_lekcji, 'YYYY-MM-DD') AS data,
    l.godzina_rozp AS godzina,
    DEREF(l.ref_sala).numer AS sala
FROM LEKCJE l
WHERE l.typ_lekcji = 'egzamin'
ORDER BY l.data_lekcji, l.godzina_rozp;

COMMIT;

-- ============================================================================
-- SCENARIUSZ 7: Statystyki obciazenia nauczycieli
-- ============================================================================
-- Dyrektor chce zobaczyc ile lekcji ma kazdy nauczyciel.
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT   SCENARIUSZ 7: Statystyki obciazenia nauczycieli
PROMPT ============================================================
PROMPT

PROMPT === Liczba lekcji na nauczyciela (tydzien 2026-02-02) ===
SELECT 
    DEREF(l.ref_nauczyciel).imie || ' ' || DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
    COUNT(*) AS liczba_lekcji,
    SUM(l.czas_trwania) AS laczny_czas_min,
    ROUND(SUM(l.czas_trwania)/60, 1) AS godzin
FROM LEKCJE l
WHERE l.data_lekcji BETWEEN DATE '2026-02-02' AND DATE '2026-02-06'
GROUP BY DEREF(l.ref_nauczyciel).imie, DEREF(l.ref_nauczyciel).nazwisko
ORDER BY COUNT(*) DESC;

-- ============================================================================
-- SCENARIUSZ 8: Statystyki wykorzystania sal
-- ============================================================================
-- Administrator chce zobaczyc ktore sale sa najbardziej obciazone.
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT   SCENARIUSZ 8: Wykorzystanie sal
PROMPT ============================================================
PROMPT

PROMPT === Wykorzystanie sal (tydzien 2026-02-02) ===
SELECT 
    DEREF(l.ref_sala).numer AS sala,
    DEREF(l.ref_sala).typ AS typ_sali,
    COUNT(*) AS liczba_lekcji,
    SUM(l.czas_trwania) AS laczny_czas_min
FROM LEKCJE l
WHERE l.data_lekcji BETWEEN DATE '2026-02-02' AND DATE '2026-02-06'
GROUP BY DEREF(l.ref_sala).numer, DEREF(l.ref_sala).typ
ORDER BY DEREF(l.ref_sala).numer;

-- ============================================================================
-- SCENARIUSZ 9: Test walidacji - proba dodania ucznia z blednym instrumentem
-- ============================================================================
-- System powinien odrzucic probe dodania ucznia z nieistniejacym instrumentem.
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT   SCENARIUSZ 9: Test walidacji - bledny instrument
PROMPT ============================================================
PROMPT

DECLARE
    v_error_caught BOOLEAN := FALSE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Proba dodania ucznia z instrumentem "Trabka" (nie istnieje) ===');
    
    BEGIN
        PKG_OSOBY.dodaj_ucznia(
            p_imie => 'Testowy',
            p_nazwisko => 'Uczen',
            p_data_urodzenia => DATE '2019-01-01',
            p_grupa_kod => '1A',
            p_instrument_nazwa => 'Trabka',  -- nie istnieje!
            p_email_rodzica => 'test@email.pl',
            p_telefon_rodzica => '500000000'
        );
    EXCEPTION
        WHEN OTHERS THEN
            v_error_caught := TRUE;
            DBMS_OUTPUT.PUT_LINE('Wylapano blad: ' || SQLERRM);
    END;
    
    IF v_error_caught THEN
        DBMS_OUTPUT.PUT_LINE('TEST PASSED: System poprawnie odrzucil bledne dane');
    ELSE
        DBMS_OUTPUT.PUT_LINE('TEST FAILED: System powinien byl odrzucic bledne dane!');
    END IF;
END;
/

-- ============================================================================
-- SCENARIUSZ 10: Test walidacji - proba dodania lekcji w weekend
-- ============================================================================
-- System powinien odrzucic probe dodania lekcji w sobote.
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT   SCENARIUSZ 10: Test walidacji - lekcja w weekend
PROMPT ============================================================
PROMPT

DECLARE
    v_error_caught BOOLEAN := FALSE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Proba dodania egzaminu w sobote (2026-02-28) ===');
    
    BEGIN
        PKG_LEKCJE.dodaj_egzamin(
            p_uczen_nazwisko => 'Kowalski',
            p_uczen_imie => 'Jan',
            p_sala_numer => '203',
            p_data => DATE '2026-02-28',  -- sobota!
            p_godzina => '14:00',
            p_komisja_nazwisko1 => 'Kowalska',
            p_komisja_nazwisko2 => 'Nowak',
            p_czas_min => 30
        );
    EXCEPTION
        WHEN OTHERS THEN
            v_error_caught := TRUE;
            DBMS_OUTPUT.PUT_LINE('Wylapano blad: ' || SQLERRM);
    END;
    
    IF v_error_caught THEN
        DBMS_OUTPUT.PUT_LINE('TEST PASSED: System poprawnie odrzucil lekcje w weekend');
    ELSE
        DBMS_OUTPUT.PUT_LINE('TEST FAILED: System powinien byl odrzucic lekcje w weekend!');
    END IF;
END;
/

-- ============================================================================
-- SCENARIUSZ 11: Test walidacji - proba dodania lekcji przed 14:00
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT   SCENARIUSZ 11: Test walidacji - lekcja przed 14:00
PROMPT ============================================================
PROMPT

DECLARE
    v_error_caught BOOLEAN := FALSE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Proba dodania egzaminu o 10:00 ===');
    
    BEGIN
        PKG_LEKCJE.dodaj_egzamin(
            p_uczen_nazwisko => 'Kowalski',
            p_uczen_imie => 'Jan',
            p_sala_numer => '203',
            p_data => DATE '2026-03-06',  -- piatek
            p_godzina => '10:00',         -- za wczesnie!
            p_komisja_nazwisko1 => 'Kowalska',
            p_komisja_nazwisko2 => 'Nowak',
            p_czas_min => 30
        );
    EXCEPTION
        WHEN OTHERS THEN
            v_error_caught := TRUE;
            DBMS_OUTPUT.PUT_LINE('Wylapano blad: ' || SQLERRM);
    END;
    
    IF v_error_caught THEN
        DBMS_OUTPUT.PUT_LINE('TEST PASSED: System poprawnie odrzucil lekcje przed 14:00');
    ELSE
        DBMS_OUTPUT.PUT_LINE('TEST FAILED: System powinien byl odrzucic lekcje przed 14:00!');
    END IF;
END;
/

-- ============================================================================
-- PODSUMOWANIE TESTOW
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT   PODSUMOWANIE PO TESTACH
PROMPT ============================================================
PROMPT

SELECT 'UCZNIOWIE' AS tabela, COUNT(*) AS liczba FROM UCZNIOWIE
UNION ALL SELECT 'NAUCZYCIELE', COUNT(*) FROM NAUCZYCIELE
UNION ALL SELECT 'LEKCJE', COUNT(*) FROM LEKCJE
UNION ALL SELECT 'OCENY', COUNT(*) FROM OCENY
UNION ALL SELECT 'EGZAMINY', COUNT(*) FROM LEKCJE WHERE typ_lekcji = 'egzamin';

PROMPT
PROMPT === Nowi uczniowie (dodani w testach) ===
SELECT imie, nazwisko, DEREF(ref_grupa).kod AS klasa, DEREF(ref_instrument).nazwa AS instrument
FROM UCZNIOWIE
WHERE nazwisko = 'Kotek';

PROMPT
PROMPT === Nowi nauczyciele (dodani w testach) ===
SELECT imie, nazwisko, email
FROM NAUCZYCIELE
WHERE nazwisko = 'Melodia';

PROMPT
PROMPT ============================================================
PROMPT   ZAKONCZONO TESTY SCENARIUSZOWE
PROMPT ============================================================
PROMPT
