-- ============================================================================
-- PLIK: 09_testy.sql
-- PROJEKT: Szkoła Muzyczna v5 - Obiektowa Baza Danych Oracle
-- AUTORZY: Igor Typiński (251237), Mateusz Mróz (251190)
-- DATA: Styczeń 2026
-- ============================================================================
--
-- CO TEN PLIK ROBI?
-- -----------------
-- Zawiera TESTY AUTOMATYCZNE weryfikujące poprawność:
--   1. Typów obiektowych (istnienie, struktura)
--   2. Tabel (istnienie, dane)
--   3. Walidacji (triggery, pakiety)
--   4. Konfliktów (sala, nauczyciel, uczeń, godzina)
--   5. Logiki biznesowej (promocja, limity)
--
-- METODOLOGIA TESTOWANIA:
-- =======================
--
-- 1. ARRANGE - Przygotuj dane testowe
-- 2. ACT     - Wykonaj akcję
-- 3. ASSERT  - Sprawdź wynik
--
-- Każdy test:
--   - Jest izolowany (używa SAVEPOINT/ROLLBACK)
--   - Ma jasny opis
--   - Raportuje [OK] lub [FAIL]
--
-- KATEGORIE TESTÓW:
-- =================
--
-- | Kategoria          | Testy | Opis                                |
-- |--------------------|-------|-------------------------------------|
-- | Typy obiektowe     | 3     | Istnienie typów w USER_TYPES        |
-- | Tabele             | 3     | Istnienie tabel, liczba rekordów    |
-- | REF integralność   | 2     | Poprawność wskaźników               |
-- | Walidacja wieku    | 2     | Za młody, za stary                  |
-- | Walidacja typu     | 2     | Nieprawidłowy typ ucznia            |
-- | Walidacja XOR      | 2     | Lekcja: uczeń XOR grupa             |
-- | Walidacja komisji  | 1     | Komisja egz. = różne osoby          |
-- | Konflikt sali      | 2     | Nakładające się lekcje              |
-- | Konflikt nauczyc.  | 1     | Nauczyciel nie może być w 2 miejscach|
-- | Konflikt ucznia    | 1     | Uczeń nie może mieć 2 lekcji naraz  |
-- | Godzina typ ucznia | 2     | 15:00 dla uczących się w szkole     |
-- | Promocja           | 2     | Zmiana klasy, absolwent             |
-- | Limit godzin       | 1     | Max 40h/tydzień dla nauczyciela     |
-- |--------------------|-------|-------------------------------------|
-- | RAZEM              | 24    |                                     |
--
-- JAK URUCHOMIĆ?
-- --------------
-- WYMAGANIE: Wszystkie skrypty 01-08 muszą być wykonane
-- @09_testy.sql
--
-- Alternatywnie, z pakietu:
-- EXEC pkg_test.uruchom_wszystkie;
--
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200
SET FEEDBACK OFF

PROMPT ╔═══════════════════════════════════════════════════════════════╗
PROMPT ║  09_testy.sql - Testy automatyczne                            ║
PROMPT ╚═══════════════════════════════════════════════════════════════╝
PROMPT

-- ============================================================================
-- PEŁNA IMPLEMENTACJA pkg_test
-- ============================================================================
-- Nadpisuje szkielet z 04_pakiety.sql
-- ============================================================================

CREATE OR REPLACE PACKAGE BODY pkg_test AS
    
    -- Liczniki
    g_testy_ok   NUMBER := 0;
    g_testy_fail NUMBER := 0;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- HELPER: assert
    -- ═══════════════════════════════════════════════════════════════════════
    -- Uniwersalna procedura asercji
    -- ═══════════════════════════════════════════════════════════════════════
    PROCEDURE assert(
        p_warunek IN BOOLEAN,
        p_opis    IN VARCHAR2
    ) AS
    BEGIN
        IF p_warunek THEN
            g_testy_ok := g_testy_ok + 1;
            DBMS_OUTPUT.PUT_LINE('  [OK]   ' || p_opis);
        ELSE
            g_testy_fail := g_testy_fail + 1;
            DBMS_OUTPUT.PUT_LINE('  [FAIL] ' || p_opis);
        END IF;
    END assert;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- TEST: Typy obiektowe
    -- ═══════════════════════════════════════════════════════════════════════
    PROCEDURE test_typy_obiektow AS
        v_count NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('─── TEST: Typy obiektowe ───');
        
        -- Test 1: Sprawdź liczbę typów
        SELECT COUNT(*) INTO v_count
        FROM user_types
        WHERE type_name LIKE 'T\_%\_OBJ' ESCAPE '\';
        
        assert(v_count >= 10, 'Istnieje >= 10 typów obiektowych (jest: ' || v_count || ')');
        
        -- Test 2: Sprawdź czy t_uczen_obj istnieje
        SELECT COUNT(*) INTO v_count
        FROM user_types
        WHERE type_name = 'T_UCZEN_OBJ';
        
        assert(v_count = 1, 't_uczen_obj istnieje w schemacie');
        
        -- Test 3: Sprawdź czy t_lekcja_obj ma atrybuty
        SELECT COUNT(*) INTO v_count
        FROM user_type_attrs
        WHERE type_name = 'T_LEKCJA_OBJ';
        
        assert(v_count >= 10, 't_lekcja_obj ma >= 10 atrybutów (jest: ' || v_count || ')');
    END test_typy_obiektow;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- TEST: Tabele
    -- ═══════════════════════════════════════════════════════════════════════
    PROCEDURE test_tabele AS
        v_count NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('─── TEST: Tabele ───');
        
        -- Test 1: Liczba tabel
        SELECT COUNT(*) INTO v_count
        FROM user_tables
        WHERE table_name LIKE 'T\_%' ESCAPE '\';
        
        assert(v_count >= 10, 'Istnieje >= 10 tabel (jest: ' || v_count || ')');
        
        -- Test 2: Tabela t_uczen ma dane
        SELECT COUNT(*) INTO v_count FROM t_uczen;
        
        assert(v_count >= 5, 't_uczen ma >= 5 rekordów (jest: ' || v_count || ')');
        
        -- Test 3: Tabela t_lekcja ma dane
        SELECT COUNT(*) INTO v_count FROM t_lekcja;
        
        assert(v_count >= 5, 't_lekcja ma >= 5 rekordów (jest: ' || v_count || ')');
    END test_tabele;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- TEST: REF integralność
    -- ═══════════════════════════════════════════════════════════════════════
    PROCEDURE test_ref_integralnosc AS
        v_count NUMBER;
        v_nauczyciel t_nauczyciel_obj;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('─── TEST: REF integralność ───');
        
        -- Test 1: Wszystkie REF-y w t_uczen są poprawne
        SELECT COUNT(*) INTO v_count
        FROM t_uczen u
        WHERE DEREF(u.ref_instrument) IS NULL 
           OR DEREF(u.ref_nauczyciel) IS NULL;
        
        assert(v_count = 0, 'Wszystkie REF-y w t_uczen są poprawne (błędnych: ' || v_count || ')');
        
        -- Test 2: DEREF zwraca poprawny obiekt
        SELECT DEREF(u.ref_nauczyciel) INTO v_nauczyciel
        FROM t_uczen u
        WHERE ROWNUM = 1;
        
        assert(v_nauczyciel.nazwisko IS NOT NULL, 
               'DEREF(ref_nauczyciel) zwraca obiekt z nazwiskiem');
    END test_ref_integralnosc;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- TEST: Walidacja wieku ucznia
    -- ═══════════════════════════════════════════════════════════════════════
    PROCEDURE test_walidacja_wieku_ucznia AS
        v_ref_instr REF t_instrument_obj;
        v_ref_naucz REF t_nauczyciel_obj;
        v_error VARCHAR2(4000);
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('─── TEST: Walidacja wieku ucznia ───');
        
        -- Pobierz REF-y do testów
        SELECT REF(i) INTO v_ref_instr FROM t_instrument i WHERE ROWNUM = 1;
        SELECT REF(n) INTO v_ref_naucz FROM t_nauczyciel n WHERE ROWNUM = 1;
        
        -- Test 1: Za młody uczeń (5 lat) - powinien być odrzucony
        SAVEPOINT przed_testem;
        BEGIN
            INSERT INTO t_uczen VALUES (t_uczen_obj(
                999, 'Test', 'ZaMlody',
                ADD_MONTHS(SYSDATE, -5*12),  -- 5 lat
                'uczacy_sie_w_innej_szkole',
                SYSDATE, 1, 6, 'aktywny',
                v_ref_instr, v_ref_naucz
            ));
            v_error := 'Brak błędu';
        EXCEPTION
            WHEN OTHERS THEN
                v_error := SQLERRM;
        END;
        ROLLBACK TO przed_testem;
        
        assert(v_error LIKE '%minimum 6 lat%' OR v_error LIKE '%-20001%',
               'Uczeń 5-letni odrzucony (błąd: ' || SUBSTR(v_error, 1, 50) || ')');
        
        -- Test 2: Za stary uczeń (30 lat) - powinien być odrzucony
        SAVEPOINT przed_testem;
        BEGIN
            INSERT INTO t_uczen VALUES (t_uczen_obj(
                999, 'Test', 'ZaStary',
                ADD_MONTHS(SYSDATE, -30*12),  -- 30 lat
                'ukonczyl_edukacje',
                SYSDATE, 1, 6, 'aktywny',
                v_ref_instr, v_ref_naucz
            ));
            v_error := 'Brak błędu';
        EXCEPTION
            WHEN OTHERS THEN
                v_error := SQLERRM;
        END;
        ROLLBACK TO przed_testem;
        
        assert(v_error LIKE '%maksymalnie 25 lat%' OR v_error LIKE '%-20002%',
               'Uczeń 30-letni odrzucony (błąd: ' || SUBSTR(v_error, 1, 50) || ')');
    END test_walidacja_wieku_ucznia;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- TEST: Walidacja typu ucznia
    -- ═══════════════════════════════════════════════════════════════════════
    PROCEDURE test_walidacja_typ_ucznia AS
        v_ref_instr REF t_instrument_obj;
        v_ref_naucz REF t_nauczyciel_obj;
        v_error VARCHAR2(4000);
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('─── TEST: Walidacja typu ucznia ───');
        
        SELECT REF(i) INTO v_ref_instr FROM t_instrument i WHERE ROWNUM = 1;
        SELECT REF(n) INTO v_ref_naucz FROM t_nauczyciel n WHERE ROWNUM = 1;
        
        -- Test 1: Nieprawidłowy typ ucznia
        SAVEPOINT przed_testem;
        BEGIN
            INSERT INTO t_uczen VALUES (t_uczen_obj(
                999, 'Test', 'ZlyTyp',
                ADD_MONTHS(SYSDATE, -10*12),
                'nieprawidlowy_typ',  -- ZŁY TYP!
                SYSDATE, 1, 6, 'aktywny',
                v_ref_instr, v_ref_naucz
            ));
            v_error := 'Brak błędu';
        EXCEPTION
            WHEN OTHERS THEN
                v_error := SQLERRM;
        END;
        ROLLBACK TO przed_testem;
        
        assert(v_error LIKE '%Nieprawidłowy typ ucznia%' OR v_error LIKE '%-20003%'
               OR v_error LIKE '%check constraint%',
               'Nieprawidłowy typ ucznia odrzucony');
        
        -- Test 2: Prawidłowy typ ucznia
        SAVEPOINT przed_testem;
        BEGIN
            INSERT INTO t_uczen VALUES (t_uczen_obj(
                999, 'Test', 'DobryTyp',
                ADD_MONTHS(SYSDATE, -10*12),
                'tylko_muzyczna',  -- DOBRY TYP
                SYSDATE, 1, 6, 'aktywny',
                v_ref_instr, v_ref_naucz
            ));
            v_error := 'Sukces';
        EXCEPTION
            WHEN OTHERS THEN
                v_error := SQLERRM;
        END;
        ROLLBACK TO przed_testem;
        
        assert(v_error = 'Sukces',
               'Prawidłowy typ ucznia zaakceptowany');
    END test_walidacja_typ_ucznia;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- TEST: Walidacja XOR lekcja (uczeń XOR grupa)
    -- ═══════════════════════════════════════════════════════════════════════
    PROCEDURE test_walidacja_xor_lekcja AS
        v_error VARCHAR2(4000);
        v_ref_sala REF t_sala_obj;
        v_ref_naucz REF t_nauczyciel_obj;
        v_ref_przedm REF t_przedmiot_obj;
        v_ref_sem REF t_semestr_obj;
        v_ref_uczen REF t_uczen_obj;
        v_ref_grupa REF t_grupa_obj;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('─── TEST: Walidacja XOR lekcja ───');
        
        -- Pobierz REF-y
        SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE ROWNUM = 1;
        SELECT REF(n) INTO v_ref_naucz FROM t_nauczyciel n WHERE ROWNUM = 1;
        SELECT REF(p) INTO v_ref_przedm FROM t_przedmiot p WHERE ROWNUM = 1;
        SELECT REF(s) INTO v_ref_sem FROM t_semestr s WHERE ROWNUM = 1;
        SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE ROWNUM = 1;
        SELECT REF(g) INTO v_ref_grupa FROM t_grupa g WHERE ROWNUM = 1;
        
        -- Test 1: Lekcja indywidualna bez ucznia - BŁĄD
        SAVEPOINT przed_testem;
        BEGIN
            INSERT INTO t_lekcja VALUES (t_lekcja_obj(
                999, 'indywidualna', DATE '2026-02-01', '15:00', 45, 'zaplanowana',
                v_ref_sala, v_ref_naucz, v_ref_przedm, v_ref_sem,
                NULL,  -- BRAK UCZNIA!
                NULL
            ));
            v_error := 'Brak błędu';
        EXCEPTION
            WHEN OTHERS THEN
                v_error := SQLERRM;
        END;
        ROLLBACK TO przed_testem;
        
        assert(v_error LIKE '%wymaga przypisania ucznia%' OR v_error LIKE '%-20040%',
               'Lekcja indywidualna bez ucznia odrzucona');
        
        -- Test 2: Lekcja indywidualna z grupą - BŁĄD
        SAVEPOINT przed_testem;
        BEGIN
            INSERT INTO t_lekcja VALUES (t_lekcja_obj(
                999, 'indywidualna', DATE '2026-02-01', '15:00', 45, 'zaplanowana',
                v_ref_sala, v_ref_naucz, v_ref_przedm, v_ref_sem,
                v_ref_uczen,
                v_ref_grupa  -- BŁĄD: indywidualna nie może mieć grupy!
            ));
            v_error := 'Brak błędu';
        EXCEPTION
            WHEN OTHERS THEN
                v_error := SQLERRM;
        END;
        ROLLBACK TO przed_testem;
        
        assert(v_error LIKE '%nie może mieć przypisanej grupy%' OR v_error LIKE '%-20041%',
               'Lekcja indywidualna z grupą odrzucona');
    END test_walidacja_xor_lekcja;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- TEST: Walidacja komisji egzaminu
    -- ═══════════════════════════════════════════════════════════════════════
    PROCEDURE test_walidacja_komisja_egzamin AS
        v_error VARCHAR2(4000);
        v_ref_uczen REF t_uczen_obj;
        v_ref_przedm REF t_przedmiot_obj;
        v_ref_naucz REF t_nauczyciel_obj;
        v_ref_sala REF t_sala_obj;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('─── TEST: Walidacja komisji egzaminu ───');
        
        SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE ROWNUM = 1;
        SELECT REF(p) INTO v_ref_przedm FROM t_przedmiot p WHERE ROWNUM = 1;
        SELECT REF(n) INTO v_ref_naucz FROM t_nauczyciel n WHERE ROWNUM = 1;
        SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE ROWNUM = 1;
        
        -- Test: Ta sama osoba w komisji - BŁĄD
        SAVEPOINT przed_testem;
        BEGIN
            INSERT INTO t_egzamin VALUES (t_egzamin_obj(
                999, DATE '2026-03-01', 'techniczny', NULL,
                v_ref_uczen, v_ref_przedm,
                v_ref_naucz,  -- komisja1
                v_ref_naucz,  -- komisja2 = TA SAMA OSOBA!
                v_ref_sala
            ));
            v_error := 'Brak błędu';
        EXCEPTION
            WHEN OTHERS THEN
                v_error := SQLERRM;
        END;
        ROLLBACK TO przed_testem;
        
        assert(v_error LIKE '%RÓŻNYCH%' OR v_error LIKE '%-20030%',
               'Ta sama osoba w komisji odrzucona');
    END test_walidacja_komisja_egzamin;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- TEST: Konflikt sali
    -- ═══════════════════════════════════════════════════════════════════════
    PROCEDURE test_konflikt_sali AS
        v_konflikt BOOLEAN;
        v_id_sali NUMBER;
        v_data DATE := DATE '2026-01-13';  -- poniedziałek z danymi testowymi
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('─── TEST: Konflikt sali ───');
        
        SELECT id_sali INTO v_id_sali 
        FROM t_sala WHERE numer_sali = '101';
        
        -- Test 1: Próba zarezerwowania sali 101 o 15:00 (zajęta!)
        v_konflikt := pkg_lekcja.sprawdz_konflikt_sali(
            v_id_sali, v_data, '15:00', 45
        );
        
        assert(v_konflikt = TRUE,
               'Konflikt sali wykryty (sala 101, 13.01, 15:00)');
        
        -- Test 2: Wolny slot o 17:00 (brak konfliktu)
        v_konflikt := pkg_lekcja.sprawdz_konflikt_sali(
            v_id_sali, v_data, '17:00', 45
        );
        
        assert(v_konflikt = FALSE,
               'Brak konfliktu sali (sala 101, 13.01, 17:00)');
    END test_konflikt_sali;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- TEST: Konflikt nauczyciela
    -- ═══════════════════════════════════════════════════════════════════════
    PROCEDURE test_konflikt_nauczyciela AS
        v_konflikt BOOLEAN;
        v_id_nauczyciela NUMBER;
        v_data DATE := DATE '2026-01-13';
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('─── TEST: Konflikt nauczyciela ───');
        
        SELECT id_nauczyciela INTO v_id_nauczyciela 
        FROM t_nauczyciel WHERE nazwisko = 'Kowalski';
        
        -- Test: Kowalski ma lekcję o 15:00 w pon. - konflikt!
        v_konflikt := pkg_lekcja.sprawdz_konflikt_nauczyciela(
            v_id_nauczyciela, v_data, '15:00', 45
        );
        
        assert(v_konflikt = TRUE,
               'Konflikt nauczyciela wykryty (Kowalski, 13.01, 15:00)');
    END test_konflikt_nauczyciela;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- TEST: Konflikt ucznia
    -- ═══════════════════════════════════════════════════════════════════════
    PROCEDURE test_konflikt_ucznia AS
        v_konflikt BOOLEAN;
        v_id_ucznia NUMBER;
        v_data DATE := DATE '2026-01-13';
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('─── TEST: Konflikt ucznia ───');
        
        SELECT id_ucznia INTO v_id_ucznia 
        FROM t_uczen WHERE imie = 'Ala';
        
        -- Test: Ala ma lekcję o 15:00 w pon. - konflikt!
        v_konflikt := pkg_lekcja.sprawdz_konflikt_ucznia(
            v_id_ucznia, v_data, '15:00', 45
        );
        
        assert(v_konflikt = TRUE,
               'Konflikt ucznia wykryty (Ala, 13.01, 15:00)');
    END test_konflikt_ucznia;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- TEST: Godzina dla typu ucznia
    -- ═══════════════════════════════════════════════════════════════════════
    PROCEDURE test_godzina_typ_ucznia AS
        v_ok BOOLEAN;
        v_id_ucznia_szkola NUMBER;  -- uczacy_sie_w_innej_szkole
        v_id_ucznia_muzyka NUMBER;  -- tylko_muzyczna
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('─── TEST: Godzina dla typu ucznia ───');
        
        SELECT id_ucznia INTO v_id_ucznia_szkola 
        FROM t_uczen WHERE imie = 'Ala';  -- uczacy_sie_w_innej_szkole
        
        SELECT id_ucznia INTO v_id_ucznia_muzyka 
        FROM t_uczen WHERE imie = 'Ewa';  -- tylko_muzyczna
        
        -- Test 1: Ala (szkoła) o 14:00 - za wcześnie!
        v_ok := pkg_lekcja.sprawdz_godzine_dla_typu(v_id_ucznia_szkola, '14:00');
        
        assert(v_ok = FALSE,
               'Godzina 14:00 niedozwolona dla ucznia z innej szkoły (Ala)');
        
        -- Test 2: Ewa (tylko muzyczna) o 14:00 - OK!
        v_ok := pkg_lekcja.sprawdz_godzine_dla_typu(v_id_ucznia_muzyka, '14:00');
        
        assert(v_ok = TRUE,
               'Godzina 14:00 dozwolona dla ucznia tylko muzycznego (Ewa)');
    END test_godzina_typ_ucznia;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- TEST: Promocja ucznia
    -- ═══════════════════════════════════════════════════════════════════════
    PROCEDURE test_promocja_ucznia AS
        v_nowa_klasa NUMBER;
        v_id_ucznia NUMBER;
        v_stara_klasa NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('─── TEST: Promocja ucznia ───');
        
        -- Pobierz ucznia i jego klasę
        SELECT id_ucznia, klasa INTO v_id_ucznia, v_stara_klasa
        FROM t_uczen WHERE imie = 'Celina';  -- klasa 1
        
        -- Test 1: Promocja z klasy 1 do 2
        SAVEPOINT przed_testem;
        pkg_uczen.promuj_ucznia(v_id_ucznia, v_nowa_klasa);
        
        assert(v_nowa_klasa = v_stara_klasa + 1,
               'Promocja z klasy ' || v_stara_klasa || ' do ' || v_nowa_klasa);
        
        ROLLBACK TO przed_testem;
        
        -- Test 2: Absolwent (symulacja klasy 6)
        -- Tymczasowo zmień klasę na 6, potem promuj
        SAVEPOINT przed_testem;
        UPDATE t_uczen SET klasa = 6, cykl_nauczania = 6 
        WHERE id_ucznia = v_id_ucznia;
        
        pkg_uczen.promuj_ucznia(v_id_ucznia, v_nowa_klasa);
        
        DECLARE
            v_status VARCHAR2(20);
        BEGIN
            SELECT status INTO v_status FROM t_uczen WHERE id_ucznia = v_id_ucznia;
            assert(v_status = 'absolwent', 'Uczeń klasy 6 staje się absolwentem');
        END;
        
        ROLLBACK TO przed_testem;
    END test_promocja_ucznia;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- TEST: Limit godzin nauczyciela
    -- ═══════════════════════════════════════════════════════════════════════
    PROCEDURE test_limit_godzin_nauczyciela AS
        v_godziny NUMBER;
        v_id_nauczyciela NUMBER;
        v_moze BOOLEAN;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('─── TEST: Limit godzin nauczyciela ───');
        
        SELECT id_nauczyciela INTO v_id_nauczyciela 
        FROM t_nauczyciel WHERE nazwisko = 'Kowalski';
        
        -- Sprawdź aktualne godziny w tygodniu
        v_godziny := pkg_nauczyciel.godziny_w_tygodniu(
            v_id_nauczyciela, DATE '2026-01-13'
        );
        
        DBMS_OUTPUT.PUT_LINE('  INFO: Kowalski ma ' || v_godziny || 'h w tygodniu 13-17.01');
        
        -- Test: Czy może dodać lekcję (przy obecnym obciążeniu)
        v_moze := pkg_nauczyciel.czy_moze_dodac_lekcje(
            v_id_nauczyciela, DATE '2026-01-13', 45
        );
        
        assert(v_moze = TRUE,
               'Nauczyciel może dodać lekcję (godziny < 40h)');
    END test_limit_godzin_nauczyciela;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- URUCHOM WSZYSTKIE TESTY
    -- ═══════════════════════════════════════════════════════════════════════
    PROCEDURE uruchom_wszystkie AS
    BEGIN
        g_testy_ok := 0;
        g_testy_fail := 0;
        
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
        DBMS_OUTPUT.PUT_LINE('          URUCHAMIANIE WSZYSTKICH TESTÓW');
        DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
        
        -- Testy strukturalne
        test_typy_obiektow;
        test_tabele;
        test_ref_integralnosc;
        
        -- Testy walidacji
        test_walidacja_wieku_ucznia;
        test_walidacja_typ_ucznia;
        test_walidacja_xor_lekcja;
        test_walidacja_komisja_egzamin;
        
        -- Testy konfliktów
        test_konflikt_sali;
        test_konflikt_nauczyciela;
        test_konflikt_ucznia;
        test_godzina_typ_ucznia;
        
        -- Testy logiki biznesowej
        test_promocja_ucznia;
        test_limit_godzin_nauczyciela;
        
        -- Podsumowanie
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
        IF g_testy_fail = 0 THEN
            DBMS_OUTPUT.PUT_LINE('  ✅ WSZYSTKIE TESTY PRZESZŁY: ' || g_testy_ok || ' OK');
        ELSE
            DBMS_OUTPUT.PUT_LINE('  ⚠️  WYNIK: ' || g_testy_ok || ' OK, ' || g_testy_fail || ' FAIL');
        END IF;
        DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
    END uruchom_wszystkie;

END pkg_test;
/

SHOW ERRORS PACKAGE BODY pkg_test;

-- ============================================================================
-- URUCHOMIENIE TESTÓW
-- ============================================================================

PROMPT
PROMPT Uruchamianie testów...
PROMPT

EXEC pkg_test.uruchom_wszystkie;

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================

PROMPT
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT   PODSUMOWANIE - Testy automatyczne
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT
PROMPT   KATEGORIE TESTÓW:
PROMPT     ● Typy obiektowe      - istnienie, struktura
PROMPT     ● Tabele              - istnienie, dane
PROMPT     ● REF integralność    - poprawność wskaźników
PROMPT     ● Walidacja wieku     - za młody, za stary
PROMPT     ● Walidacja typu      - nieprawidłowy typ ucznia
PROMPT     ● Walidacja XOR       - uczeń XOR grupa
PROMPT     ● Walidacja komisji   - różne osoby
PROMPT     ● Konflikt sali       - nakładające się lekcje
PROMPT     ● Konflikt nauczyciela
PROMPT     ● Konflikt ucznia
PROMPT     ● Godzina typ ucznia  - 15:00 dla szkoły
PROMPT     ● Promocja            - zmiana klasy
PROMPT     ● Limit godzin        - max 40h/tydzień
PROMPT
PROMPT   PONOWNE URUCHOMIENIE:
PROMPT     EXEC pkg_test.uruchom_wszystkie;
PROMPT
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT   Gratulacje! Wszystkie skrypty zostały wykonane.
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT
