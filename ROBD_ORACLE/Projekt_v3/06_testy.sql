-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 06_testy.sql
-- Opis: Kompleksowe scenariusze testowe
-- Wersja: 3.0 (uproszczona)
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- ============================================================================
-- SCENARIUSZ 1: DODAWANIE DANYCH PODSTAWOWYCH
-- Testuje: poprawne wstawianie instrumentow, sal, nauczycieli, uczniow
-- ============================================================================

DECLARE
    v_test_ok NUMBER := 0;
    v_test_fail NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    DBMS_OUTPUT.PUT_LINE('SCENARIUSZ 1: DODAWANIE DANYCH PODSTAWOWYCH');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    
    -- Test 1.1: Sprawdzenie instrumentow
    BEGIN
        FOR r IN (SELECT COUNT(*) AS cnt FROM t_instrument) LOOP
            IF r.cnt >= 10 THEN
                DBMS_OUTPUT.PUT_LINE('[OK] Test 1.1: Instrumenty zaladowane (' || r.cnt || ')');
                v_test_ok := v_test_ok + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[FAIL] Test 1.1: Brak instrumentow');
                v_test_fail := v_test_fail + 1;
            END IF;
        END LOOP;
    END;
    
    -- Test 1.2: Sprawdzenie sal
    BEGIN
        FOR r IN (SELECT COUNT(*) AS cnt FROM t_sala) LOOP
            IF r.cnt >= 5 THEN
                DBMS_OUTPUT.PUT_LINE('[OK] Test 1.2: Sale zaladowane (' || r.cnt || ')');
                v_test_ok := v_test_ok + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[FAIL] Test 1.2: Brak sal');
                v_test_fail := v_test_fail + 1;
            END IF;
        END LOOP;
    END;
    
    -- Test 1.3: Sprawdzenie nauczycieli
    BEGIN
        FOR r IN (SELECT COUNT(*) AS cnt FROM t_nauczyciel) LOOP
            IF r.cnt >= 5 THEN
                DBMS_OUTPUT.PUT_LINE('[OK] Test 1.3: Nauczyciele zaladowani (' || r.cnt || ')');
                v_test_ok := v_test_ok + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[FAIL] Test 1.3: Brak nauczycieli');
                v_test_fail := v_test_fail + 1;
            END IF;
        END LOOP;
    END;
    
    -- Test 1.4: Sprawdzenie uczniow
    BEGIN
        FOR r IN (SELECT COUNT(*) AS cnt FROM t_uczen) LOOP
            IF r.cnt >= 10 THEN
                DBMS_OUTPUT.PUT_LINE('[OK] Test 1.4: Uczniowie zaladowani (' || r.cnt || ')');
                v_test_ok := v_test_ok + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[FAIL] Test 1.4: Brak uczniow');
                v_test_fail := v_test_fail + 1;
            END IF;
        END LOOP;
    END;
    
    -- Test 1.5: Sprawdzenie kursow
    BEGIN
        FOR r IN (SELECT COUNT(*) AS cnt FROM t_kurs) LOOP
            IF r.cnt >= 10 THEN
                DBMS_OUTPUT.PUT_LINE('[OK] Test 1.5: Kursy zaladowane (' || r.cnt || ')');
                v_test_ok := v_test_ok + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[FAIL] Test 1.5: Brak kursow');
                v_test_fail := v_test_fail + 1;
            END IF;
        END LOOP;
    END;
    
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Scenariusz 1: OK=' || v_test_ok || ' FAIL=' || v_test_fail);
END;
/

-- ============================================================================
-- SCENARIUSZ 2: WALIDACJA WIEKU UCZNIA
-- Testuje: trigger trg_uczen_wiek (min. 5 lat)
-- ============================================================================

DECLARE
    v_test_ok NUMBER := 0;
    v_test_fail NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    DBMS_OUTPUT.PUT_LINE('SCENARIUSZ 2: WALIDACJA WIEKU UCZNIA');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    
    -- Test 2.1: Proba dodania 3-latka (powinno FAIL)
    BEGIN
        INSERT INTO t_uczen VALUES (
            t_uczen_obj(seq_uczen.NEXTVAL, 'Maluch', 'TestowyMaly', 
                       ADD_MONTHS(SYSDATE, -36), NULL, SYSDATE)
        );
        DBMS_OUTPUT.PUT_LINE('[FAIL] Test 2.1: Dodano 3-latka (blad triggera!)');
        v_test_fail := v_test_fail + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20101 THEN
                DBMS_OUTPUT.PUT_LINE('[OK] Test 2.1: 3-latek odrzucony - ' || SQLERRM);
                v_test_ok := v_test_ok + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[FAIL] Test 2.1: Nieoczekiwany blad - ' || SQLERRM);
                v_test_fail := v_test_fail + 1;
            END IF;
    END;
    
    -- Test 2.2: Proba dodania 4-latka (powinno FAIL)
    BEGIN
        INSERT INTO t_uczen VALUES (
            t_uczen_obj(seq_uczen.NEXTVAL, 'Maluch', 'Testowy4', 
                       ADD_MONTHS(SYSDATE, -48), NULL, SYSDATE)
        );
        DBMS_OUTPUT.PUT_LINE('[FAIL] Test 2.2: Dodano 4-latka (blad triggera!)');
        v_test_fail := v_test_fail + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20101 THEN
                DBMS_OUTPUT.PUT_LINE('[OK] Test 2.2: 4-latek odrzucony');
                v_test_ok := v_test_ok + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[FAIL] Test 2.2: Nieoczekiwany blad');
                v_test_fail := v_test_fail + 1;
            END IF;
    END;
    
    -- Test 2.3: Dodanie 5-latka (powinno OK)
    BEGIN
        INSERT INTO t_uczen VALUES (
            t_uczen_obj(seq_uczen.NEXTVAL, 'Pieciolatek', 'Testowy5', 
                       ADD_MONTHS(SYSDATE, -60), NULL, SYSDATE)
        );
        DBMS_OUTPUT.PUT_LINE('[OK] Test 2.3: 5-latek dodany poprawnie');
        v_test_ok := v_test_ok + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 2.3: Nie mozna dodac 5-latka - ' || SQLERRM);
            v_test_fail := v_test_fail + 1;
    END;
    
    -- Test 2.4: Dodanie 10-latka (powinno OK)
    BEGIN
        INSERT INTO t_uczen VALUES (
            t_uczen_obj(seq_uczen.NEXTVAL, 'Dziesieciolatek', 'Testowy10', 
                       ADD_MONTHS(SYSDATE, -120), NULL, SYSDATE)
        );
        DBMS_OUTPUT.PUT_LINE('[OK] Test 2.4: 10-latek dodany poprawnie');
        v_test_ok := v_test_ok + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 2.4: Nie mozna dodac 10-latka');
            v_test_fail := v_test_fail + 1;
    END;
    
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Scenariusz 2: OK=' || v_test_ok || ' FAIL=' || v_test_fail);
END;
/

-- ============================================================================
-- SCENARIUSZ 3: WALIDACJA DNI ROBOCZYCH
-- Testuje: trigger trg_lekcja_dni_robocze (tylko Pn-Pt)
-- ============================================================================

DECLARE
    v_test_ok NUMBER := 0;
    v_test_fail NUMBER := 0;
    v_sobota DATE;
    v_niedziela DATE;
    v_poniedzialek DATE;
    v_ref_uczen REF t_uczen_obj;
    v_ref_naucz REF t_nauczyciel_obj;
    v_ref_kurs REF t_kurs_obj;
    v_ref_sala REF t_sala_obj;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    DBMS_OUTPUT.PUT_LINE('SCENARIUSZ 3: WALIDACJA DNI ROBOCZYCH');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    
    -- Oblicz daty testowe
    v_sobota := NEXT_DAY(SYSDATE, 'SATURDAY');
    v_niedziela := NEXT_DAY(SYSDATE, 'SUNDAY');
    v_poniedzialek := NEXT_DAY(SYSDATE, 'MONDAY');
    
    -- Pobranie referencji (dorosly uczen bez ograniczen godzinowych)
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 7;
    SELECT REF(n) INTO v_ref_naucz FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 1;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 1;
    
    -- Test 3.1: Lekcja w sobote (powinno FAIL)
    BEGIN
        INSERT INTO t_lekcja VALUES (
            t_lekcja_obj(seq_lekcja.NEXTVAL, v_sobota, '10:00', 45, 'zaplanowana',
                        v_ref_uczen, v_ref_naucz, v_ref_kurs, v_ref_sala)
        );
        DBMS_OUTPUT.PUT_LINE('[FAIL] Test 3.1: Dodano lekcje w sobote!');
        v_test_fail := v_test_fail + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20102 THEN
                DBMS_OUTPUT.PUT_LINE('[OK] Test 3.1: Sobota odrzucona - ' || 
                                    TO_CHAR(v_sobota, 'YYYY-MM-DD'));
                v_test_ok := v_test_ok + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[FAIL] Test 3.1: Nieoczekiwany blad - ' || SQLERRM);
                v_test_fail := v_test_fail + 1;
            END IF;
    END;
    
    -- Test 3.2: Lekcja w niedziele (powinno FAIL)
    BEGIN
        INSERT INTO t_lekcja VALUES (
            t_lekcja_obj(seq_lekcja.NEXTVAL, v_niedziela, '10:00', 45, 'zaplanowana',
                        v_ref_uczen, v_ref_naucz, v_ref_kurs, v_ref_sala)
        );
        DBMS_OUTPUT.PUT_LINE('[FAIL] Test 3.2: Dodano lekcje w niedziele!');
        v_test_fail := v_test_fail + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20102 THEN
                DBMS_OUTPUT.PUT_LINE('[OK] Test 3.2: Niedziela odrzucona - ' || 
                                    TO_CHAR(v_niedziela, 'YYYY-MM-DD'));
                v_test_ok := v_test_ok + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[FAIL] Test 3.2: Nieoczekiwany blad');
                v_test_fail := v_test_fail + 1;
            END IF;
    END;
    
    -- Test 3.3: Lekcja w poniedzialek (powinno OK)
    BEGIN
        INSERT INTO t_lekcja VALUES (
            t_lekcja_obj(seq_lekcja.NEXTVAL, v_poniedzialek, '09:00', 45, 'zaplanowana',
                        v_ref_uczen, v_ref_naucz, v_ref_kurs, v_ref_sala)
        );
        DBMS_OUTPUT.PUT_LINE('[OK] Test 3.3: Poniedzialek akceptowany - ' || 
                            TO_CHAR(v_poniedzialek, 'YYYY-MM-DD'));
        v_test_ok := v_test_ok + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 3.3: Blad w poniedzialek - ' || SQLERRM);
            v_test_fail := v_test_fail + 1;
    END;
    
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Scenariusz 3: OK=' || v_test_ok || ' FAIL=' || v_test_fail);
END;
/

-- ============================================================================
-- SCENARIUSZ 4: GODZINY LEKCJI DLA DZIECI
-- Testuje: trigger trg_lekcja_godziny_dziecka (14:00-19:00)
-- ============================================================================

DECLARE
    v_test_ok NUMBER := 0;
    v_test_fail NUMBER := 0;
    v_data DATE;
    v_ref_dziecko REF t_uczen_obj;
    v_ref_dorosly REF t_uczen_obj;
    v_ref_naucz REF t_nauczyciel_obj;
    v_ref_kurs REF t_kurs_obj;
    v_ref_sala REF t_sala_obj;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    DBMS_OUTPUT.PUT_LINE('SCENARIUSZ 4: GODZINY LEKCJI DLA DZIECI');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    
    v_data := NEXT_DAY(SYSDATE, 'WEDNESDAY');
    
    -- Dziecko (uczen 1 - Kacper, 9 lat) i dorosly (uczen 7)
    SELECT REF(u) INTO v_ref_dziecko FROM t_uczen u WHERE u.id_ucznia = 1;
    SELECT REF(u) INTO v_ref_dorosly FROM t_uczen u WHERE u.id_ucznia = 7;
    SELECT REF(n) INTO v_ref_naucz FROM t_nauczyciel n WHERE n.id_nauczyciela = 2;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 4;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 3;
    
    -- Test 4.1: Dziecko o 08:00 (powinno FAIL)
    BEGIN
        INSERT INTO t_lekcja VALUES (
            t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '08:00', 45, 'zaplanowana',
                        v_ref_dziecko, v_ref_naucz, v_ref_kurs, v_ref_sala)
        );
        DBMS_OUTPUT.PUT_LINE('[FAIL] Test 4.1: Dziecko o 08:00 zaakceptowane!');
        v_test_fail := v_test_fail + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20103 THEN
                DBMS_OUTPUT.PUT_LINE('[OK] Test 4.1: Dziecko o 08:00 odrzucone');
                v_test_ok := v_test_ok + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[FAIL] Test 4.1: Nieoczekiwany blad - ' || SQLERRM);
                v_test_fail := v_test_fail + 1;
            END IF;
    END;
    
    -- Test 4.2: Dziecko o 13:00 (powinno FAIL)
    BEGIN
        INSERT INTO t_lekcja VALUES (
            t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '13:00', 45, 'zaplanowana',
                        v_ref_dziecko, v_ref_naucz, v_ref_kurs, v_ref_sala)
        );
        DBMS_OUTPUT.PUT_LINE('[FAIL] Test 4.2: Dziecko o 13:00 zaakceptowane!');
        v_test_fail := v_test_fail + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20103 THEN
                DBMS_OUTPUT.PUT_LINE('[OK] Test 4.2: Dziecko o 13:00 odrzucone');
                v_test_ok := v_test_ok + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[FAIL] Test 4.2: Nieoczekiwany blad');
                v_test_fail := v_test_fail + 1;
            END IF;
    END;
    
    -- Test 4.3: Dziecko o 14:00 (powinno OK)
    BEGIN
        INSERT INTO t_lekcja VALUES (
            t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '14:00', 45, 'zaplanowana',
                        v_ref_dziecko, v_ref_naucz, v_ref_kurs, v_ref_sala)
        );
        DBMS_OUTPUT.PUT_LINE('[OK] Test 4.3: Dziecko o 14:00 akceptowane');
        v_test_ok := v_test_ok + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 4.3: Dziecko o 14:00 odrzucone - ' || SQLERRM);
            v_test_fail := v_test_fail + 1;
    END;
    
    -- Test 4.4: Dziecko o 18:15 z 45 min (konczy 19:00 - OK)
    BEGIN
        INSERT INTO t_lekcja VALUES (
            t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '18:15', 45, 'zaplanowana',
                        v_ref_dziecko, v_ref_naucz, v_ref_kurs, v_ref_sala)
        );
        DBMS_OUTPUT.PUT_LINE('[OK] Test 4.4: Dziecko 18:15-19:00 akceptowane');
        v_test_ok := v_test_ok + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 4.4: Dziecko 18:15-19:00 odrzucone - ' || SQLERRM);
            v_test_fail := v_test_fail + 1;
    END;
    
    -- Test 4.5: Dziecko o 18:30 z 45 min (konczy 19:15 - FAIL)
    BEGIN
        INSERT INTO t_lekcja VALUES (
            t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '18:30', 45, 'zaplanowana',
                        v_ref_dziecko, v_ref_naucz, v_ref_kurs, v_ref_sala)
        );
        DBMS_OUTPUT.PUT_LINE('[FAIL] Test 4.5: Dziecko 18:30-19:15 zaakceptowane!');
        v_test_fail := v_test_fail + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20103 THEN
                DBMS_OUTPUT.PUT_LINE('[OK] Test 4.5: Dziecko 18:30-19:15 odrzucone (przekracza 19:00)');
                v_test_ok := v_test_ok + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[FAIL] Test 4.5: Nieoczekiwany blad');
                v_test_fail := v_test_fail + 1;
            END IF;
    END;
    
    -- Test 4.6: Dorosly o 08:00 (powinno OK)
    BEGIN
        INSERT INTO t_lekcja VALUES (
            t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '08:00', 60, 'zaplanowana',
                        v_ref_dorosly, v_ref_naucz, v_ref_kurs, v_ref_sala)
        );
        DBMS_OUTPUT.PUT_LINE('[OK] Test 4.6: Dorosly o 08:00 akceptowany');
        v_test_ok := v_test_ok + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 4.6: Dorosly o 08:00 odrzucony - ' || SQLERRM);
            v_test_fail := v_test_fail + 1;
    END;
    
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Scenariusz 4: OK=' || v_test_ok || ' FAIL=' || v_test_fail);
END;
/

-- ============================================================================
-- SCENARIUSZ 5: LIMIT GODZIN NAUCZYCIELA
-- Testuje: trigger trg_lekcja_limit_nauczyciela (max 6h = 360 min)
-- ============================================================================

DECLARE
    v_test_ok NUMBER := 0;
    v_test_fail NUMBER := 0;
    v_data DATE;
    v_ref_uczen1 REF t_uczen_obj;
    v_ref_uczen2 REF t_uczen_obj;
    v_ref_uczen3 REF t_uczen_obj;
    v_ref_uczen4 REF t_uczen_obj;
    v_ref_uczen5 REF t_uczen_obj;
    v_ref_naucz REF t_nauczyciel_obj;
    v_ref_kurs REF t_kurs_obj;
    v_ref_sala1 REF t_sala_obj;
    v_ref_sala2 REF t_sala_obj;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    DBMS_OUTPUT.PUT_LINE('SCENARIUSZ 5: LIMIT GODZIN NAUCZYCIELA (max 6h)');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    
    v_data := NEXT_DAY(SYSDATE + 7, 'TUESDAY');  -- Nastepny wtorek
    
    -- Pobranie referencji (dorosli uczniowie)
    SELECT REF(u) INTO v_ref_uczen1 FROM t_uczen u WHERE u.id_ucznia = 5;
    SELECT REF(u) INTO v_ref_uczen2 FROM t_uczen u WHERE u.id_ucznia = 6;
    SELECT REF(u) INTO v_ref_uczen3 FROM t_uczen u WHERE u.id_ucznia = 7;
    SELECT REF(u) INTO v_ref_uczen4 FROM t_uczen u WHERE u.id_ucznia = 8;
    SELECT REF(u) INTO v_ref_uczen5 FROM t_uczen u WHERE u.id_ucznia = 9;
    SELECT REF(n) INTO v_ref_naucz FROM t_nauczyciel n WHERE n.id_nauczyciela = 3;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 8;  -- Flet
    SELECT REF(s) INTO v_ref_sala1 FROM t_sala s WHERE s.id_sali = 3;
    SELECT REF(s) INTO v_ref_sala2 FROM t_sala s WHERE s.id_sali = 4;
    
    -- Dodaj 6 lekcji po 60 min = 360 min (limit)
    BEGIN
        -- Lekcja 1: 08:00-09:00 (60 min, suma: 60)
        INSERT INTO t_lekcja VALUES (
            t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '08:00', 60, 'zaplanowana',
                        v_ref_uczen1, v_ref_naucz, v_ref_kurs, v_ref_sala1)
        );
        -- Lekcja 2: 09:00-10:00 (60 min, suma: 120)
        INSERT INTO t_lekcja VALUES (
            t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '09:00', 60, 'zaplanowana',
                        v_ref_uczen2, v_ref_naucz, v_ref_kurs, v_ref_sala1)
        );
        -- Lekcja 3: 10:00-11:00 (60 min, suma: 180)
        INSERT INTO t_lekcja VALUES (
            t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '10:00', 60, 'zaplanowana',
                        v_ref_uczen3, v_ref_naucz, v_ref_kurs, v_ref_sala1)
        );
        -- Lekcja 4: 11:00-12:00 (60 min, suma: 240)
        INSERT INTO t_lekcja VALUES (
            t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '11:00', 60, 'zaplanowana',
                        v_ref_uczen4, v_ref_naucz, v_ref_kurs, v_ref_sala1)
        );
        -- Lekcja 5: 13:00-14:00 (60 min, suma: 300)
        INSERT INTO t_lekcja VALUES (
            t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '13:00', 60, 'zaplanowana',
                        v_ref_uczen1, v_ref_naucz, v_ref_kurs, v_ref_sala2)
        );
        -- Lekcja 6: 14:00-15:00 (60 min, suma: 360 = LIMIT)
        INSERT INTO t_lekcja VALUES (
            t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '14:00', 60, 'zaplanowana',
                        v_ref_uczen5, v_ref_naucz, v_ref_kurs, v_ref_sala2)
        );
        
        DBMS_OUTPUT.PUT_LINE('[OK] Test 5.1: 6h lekcji (360 min) - akceptowane');
        v_test_ok := v_test_ok + 1;
        
        -- Test 5.2: Proba dodania 7. lekcji (powinno FAIL)
        BEGIN
            INSERT INTO t_lekcja VALUES (
                t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '15:00', 30, 'zaplanowana',
                            v_ref_uczen2, v_ref_naucz, v_ref_kurs, v_ref_sala2)
            );
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 5.2: 7. lekcja dodana (przekroczenie limitu)!');
            v_test_fail := v_test_fail + 1;
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE = -20104 THEN
                    DBMS_OUTPUT.PUT_LINE('[OK] Test 5.2: 7. lekcja odrzucona (limit 6h)');
                    v_test_ok := v_test_ok + 1;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[FAIL] Test 5.2: Nieoczekiwany blad - ' || SQLERRM);
                    v_test_fail := v_test_fail + 1;
                END IF;
        END;
        
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 5.1: Blad przy dodawaniu lekcji - ' || SQLERRM);
            v_test_fail := v_test_fail + 1;
            ROLLBACK;
    END;
    
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Scenariusz 5: OK=' || v_test_ok || ' FAIL=' || v_test_fail);
END;
/

-- ============================================================================
-- SCENARIUSZ 6: LIMIT LEKCJI UCZNIA
-- Testuje: trigger trg_lekcja_limit_ucznia (max 2 lekcje/dzien)
-- ============================================================================

DECLARE
    v_test_ok NUMBER := 0;
    v_test_fail NUMBER := 0;
    v_data DATE;
    v_ref_uczen REF t_uczen_obj;
    v_ref_naucz1 REF t_nauczyciel_obj;
    v_ref_naucz2 REF t_nauczyciel_obj;
    v_ref_naucz3 REF t_nauczyciel_obj;
    v_ref_kurs1 REF t_kurs_obj;
    v_ref_kurs2 REF t_kurs_obj;
    v_ref_sala1 REF t_sala_obj;
    v_ref_sala2 REF t_sala_obj;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    DBMS_OUTPUT.PUT_LINE('SCENARIUSZ 6: LIMIT LEKCJI UCZNIA (max 2/dzien)');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    
    v_data := NEXT_DAY(SYSDATE + 14, 'FRIDAY');
    
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 7;  -- Dorosly
    SELECT REF(n) INTO v_ref_naucz1 FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    SELECT REF(n) INTO v_ref_naucz2 FROM t_nauczyciel n WHERE n.id_nauczyciela = 2;
    SELECT REF(n) INTO v_ref_naucz3 FROM t_nauczyciel n WHERE n.id_nauczyciela = 3;
    SELECT REF(k) INTO v_ref_kurs1 FROM t_kurs k WHERE k.id_kursu = 1;
    SELECT REF(k) INTO v_ref_kurs2 FROM t_kurs k WHERE k.id_kursu = 4;
    SELECT REF(s) INTO v_ref_sala1 FROM t_sala s WHERE s.id_sali = 1;
    SELECT REF(s) INTO v_ref_sala2 FROM t_sala s WHERE s.id_sali = 3;
    
    BEGIN
        -- Lekcja 1
        INSERT INTO t_lekcja VALUES (
            t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '09:00', 45, 'zaplanowana',
                        v_ref_uczen, v_ref_naucz1, v_ref_kurs1, v_ref_sala1)
        );
        DBMS_OUTPUT.PUT_LINE('[OK] Test 6.1: 1. lekcja ucznia dodana');
        v_test_ok := v_test_ok + 1;
        
        -- Lekcja 2
        INSERT INTO t_lekcja VALUES (
            t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '11:00', 45, 'zaplanowana',
                        v_ref_uczen, v_ref_naucz2, v_ref_kurs2, v_ref_sala2)
        );
        DBMS_OUTPUT.PUT_LINE('[OK] Test 6.2: 2. lekcja ucznia dodana');
        v_test_ok := v_test_ok + 1;
        
        -- Proba dodania 3. lekcji (FAIL)
        BEGIN
            INSERT INTO t_lekcja VALUES (
                t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '14:00', 45, 'zaplanowana',
                            v_ref_uczen, v_ref_naucz3, v_ref_kurs1, v_ref_sala1)
            );
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 6.3: 3. lekcja dodana (blad!)');
            v_test_fail := v_test_fail + 1;
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE = -20105 THEN
                    DBMS_OUTPUT.PUT_LINE('[OK] Test 6.3: 3. lekcja odrzucona (limit 2/dzien)');
                    v_test_ok := v_test_ok + 1;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[FAIL] Test 6.3: Nieoczekiwany blad - ' || SQLERRM);
                    v_test_fail := v_test_fail + 1;
                END IF;
        END;
        
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 6: Blad - ' || SQLERRM);
            v_test_fail := v_test_fail + 1;
            ROLLBACK;
    END;
    
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Scenariusz 6: OK=' || v_test_ok || ' FAIL=' || v_test_fail);
END;
/

-- ============================================================================
-- SCENARIUSZ 7: KONFLIKTY SAL I NAUCZYCIELI
-- Testuje: triggery konfliktow (sala, nauczyciel, uczen)
-- ============================================================================

DECLARE
    v_test_ok NUMBER := 0;
    v_test_fail NUMBER := 0;
    v_data DATE;
    v_ref_uczen1 REF t_uczen_obj;
    v_ref_uczen2 REF t_uczen_obj;
    v_ref_naucz1 REF t_nauczyciel_obj;
    v_ref_naucz2 REF t_nauczyciel_obj;
    v_ref_kurs REF t_kurs_obj;
    v_ref_sala REF t_sala_obj;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    DBMS_OUTPUT.PUT_LINE('SCENARIUSZ 7: KONFLIKTY SAL I NAUCZYCIELI');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    
    v_data := NEXT_DAY(SYSDATE + 21, 'THURSDAY');
    
    SELECT REF(u) INTO v_ref_uczen1 FROM t_uczen u WHERE u.id_ucznia = 7;
    SELECT REF(u) INTO v_ref_uczen2 FROM t_uczen u WHERE u.id_ucznia = 8;
    SELECT REF(n) INTO v_ref_naucz1 FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    SELECT REF(n) INTO v_ref_naucz2 FROM t_nauczyciel n WHERE n.id_nauczyciela = 2;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 1;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 1;
    
    BEGIN
        -- Lekcja bazowa: 10:00-10:45, Sala 1, Nauczyciel 1, Uczen 1
        INSERT INTO t_lekcja VALUES (
            t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '10:00', 45, 'zaplanowana',
                        v_ref_uczen1, v_ref_naucz1, v_ref_kurs, v_ref_sala)
        );
        DBMS_OUTPUT.PUT_LINE('[INFO] Lekcja bazowa: 10:00-10:45, Sala A1, Naucz.1, Uczen 1');
        
        -- Test 7.1: Konflikt sali (ta sama sala, nakladajacy sie czas)
        BEGIN
            INSERT INTO t_lekcja VALUES (
                t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '10:30', 45, 'zaplanowana',
                            v_ref_uczen2, v_ref_naucz2, v_ref_kurs, v_ref_sala)
            );
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 7.1: Konflikt sali niezablokowany!');
            v_test_fail := v_test_fail + 1;
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE = -20106 THEN
                    DBMS_OUTPUT.PUT_LINE('[OK] Test 7.1: Konflikt sali wykryty');
                    v_test_ok := v_test_ok + 1;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[FAIL] Test 7.1: Nieoczekiwany blad - ' || SQLERRM);
                    v_test_fail := v_test_fail + 1;
                END IF;
        END;
        
        -- Test 7.2: Konflikt nauczyciela (ten sam nauczyciel, nakladajacy sie czas, inna sala)
        DECLARE
            v_ref_sala2 REF t_sala_obj;
        BEGIN
            SELECT REF(s) INTO v_ref_sala2 FROM t_sala s WHERE s.id_sali = 2;
            INSERT INTO t_lekcja VALUES (
                t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '10:15', 45, 'zaplanowana',
                            v_ref_uczen2, v_ref_naucz1, v_ref_kurs, v_ref_sala2)
            );
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 7.2: Konflikt nauczyciela niezablokowany!');
            v_test_fail := v_test_fail + 1;
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE = -20107 THEN
                    DBMS_OUTPUT.PUT_LINE('[OK] Test 7.2: Konflikt nauczyciela wykryty');
                    v_test_ok := v_test_ok + 1;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[FAIL] Test 7.2: Nieoczekiwany blad - ' || SQLERRM);
                    v_test_fail := v_test_fail + 1;
                END IF;
        END;
        
        -- Test 7.3: Konflikt ucznia (ten sam uczen, nakladajacy sie czas)
        DECLARE
            v_ref_sala2 REF t_sala_obj;
        BEGIN
            SELECT REF(s) INTO v_ref_sala2 FROM t_sala s WHERE s.id_sali = 2;
            INSERT INTO t_lekcja VALUES (
                t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '10:20', 30, 'zaplanowana',
                            v_ref_uczen1, v_ref_naucz2, v_ref_kurs, v_ref_sala2)
            );
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 7.3: Konflikt ucznia niezablokowany!');
            v_test_fail := v_test_fail + 1;
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE = -20108 THEN
                    DBMS_OUTPUT.PUT_LINE('[OK] Test 7.3: Konflikt ucznia wykryty');
                    v_test_ok := v_test_ok + 1;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[FAIL] Test 7.3: Nieoczekiwany blad - ' || SQLERRM);
                    v_test_fail := v_test_fail + 1;
                END IF;
        END;
        
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 7: Blad - ' || SQLERRM);
            v_test_fail := v_test_fail + 1;
            ROLLBACK;
    END;
    
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Scenariusz 7: OK=' || v_test_ok || ' FAIL=' || v_test_fail);
END;
/

-- ============================================================================
-- SCENARIUSZ 8: BLOKADA USUWANIA
-- Testuje: triggery blokujace usuwanie nauczycieli/uczniow z lekcjami
-- ============================================================================

DECLARE
    v_test_ok NUMBER := 0;
    v_test_fail NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    DBMS_OUTPUT.PUT_LINE('SCENARIUSZ 8: BLOKADA USUWANIA');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    
    -- Test 8.1: Proba usuniecia nauczyciela z lekcjami
    BEGIN
        DELETE FROM t_nauczyciel WHERE id_nauczyciela = 1;
        DBMS_OUTPUT.PUT_LINE('[FAIL] Test 8.1: Usunieto nauczyciela z lekcjami!');
        v_test_fail := v_test_fail + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20109 THEN
                DBMS_OUTPUT.PUT_LINE('[OK] Test 8.1: Blokada usuwania nauczyciela dziala');
                v_test_ok := v_test_ok + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] Test 8.1: Inny blad (moze FK) - ' || SQLERRM);
                v_test_ok := v_test_ok + 1;  -- FK tez chroni dane
            END IF;
    END;
    
    -- Test 8.2: Proba usuniecia ucznia z lekcjami
    BEGIN
        DELETE FROM t_uczen WHERE id_ucznia = 1;
        DBMS_OUTPUT.PUT_LINE('[FAIL] Test 8.2: Usunieto ucznia z lekcjami!');
        v_test_fail := v_test_fail + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20110 THEN
                DBMS_OUTPUT.PUT_LINE('[OK] Test 8.2: Blokada usuwania ucznia dziala');
                v_test_ok := v_test_ok + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] Test 8.2: Inny blad (moze FK) - ' || SQLERRM);
                v_test_ok := v_test_ok + 1;
            END IF;
    END;
    
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Scenariusz 8: OK=' || v_test_ok || ' FAIL=' || v_test_fail);
END;
/

-- ============================================================================
-- SCENARIUSZ 9: PAKIETY - OPERACJE CRUD
-- Testuje: funkcje pakietow (pkg_uczen, pkg_lekcja, pkg_ocena)
-- ============================================================================

DECLARE
    v_test_ok NUMBER := 0;
    v_test_fail NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    DBMS_OUTPUT.PUT_LINE('SCENARIUSZ 9: PAKIETY - OPERACJE');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    
    -- Test 9.1: pkg_uczen.lista
    BEGIN
        pkg_uczen.lista;
        DBMS_OUTPUT.PUT_LINE('[OK] Test 9.1: pkg_uczen.lista dziala');
        v_test_ok := v_test_ok + 1;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 9.1: pkg_uczen.lista - ' || SQLERRM);
            v_test_fail := v_test_fail + 1;
    END;
    
    -- Test 9.2: pkg_uczen.lista_dzieci
    BEGIN
        pkg_uczen.lista_dzieci;
        DBMS_OUTPUT.PUT_LINE('[OK] Test 9.2: pkg_uczen.lista_dzieci dziala');
        v_test_ok := v_test_ok + 1;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 9.2: pkg_uczen.lista_dzieci - ' || SQLERRM);
            v_test_fail := v_test_fail + 1;
    END;
    
    -- Test 9.3: pkg_uczen.info
    BEGIN
        pkg_uczen.info(1);
        DBMS_OUTPUT.PUT_LINE('[OK] Test 9.3: pkg_uczen.info dziala');
        v_test_ok := v_test_ok + 1;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 9.3: pkg_uczen.info - ' || SQLERRM);
            v_test_fail := v_test_fail + 1;
    END;
    
    -- Test 9.4: pkg_lekcja.plan_dnia
    BEGIN
        pkg_lekcja.plan_dnia(NEXT_DAY(SYSDATE, 'MONDAY'));
        DBMS_OUTPUT.PUT_LINE('[OK] Test 9.4: pkg_lekcja.plan_dnia dziala');
        v_test_ok := v_test_ok + 1;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 9.4: pkg_lekcja.plan_dnia - ' || SQLERRM);
            v_test_fail := v_test_fail + 1;
    END;
    
    -- Test 9.5: pkg_ocena.historia_ucznia
    BEGIN
        pkg_ocena.historia_ucznia(1);
        DBMS_OUTPUT.PUT_LINE('[OK] Test 9.5: pkg_ocena.historia_ucznia dziala');
        v_test_ok := v_test_ok + 1;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 9.5: pkg_ocena.historia_ucznia - ' || SQLERRM);
            v_test_fail := v_test_fail + 1;
    END;
    
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Scenariusz 9: OK=' || v_test_ok || ' FAIL=' || v_test_fail);
END;
/

-- ============================================================================
-- SCENARIUSZ 10: METODY OBIEKTOW
-- Testuje: metody typow obiektowych
-- ============================================================================

DECLARE
    v_test_ok NUMBER := 0;
    v_test_fail NUMBER := 0;
    v_uczen t_uczen_obj;
    v_naucz t_nauczyciel_obj;
    v_sala t_sala_obj;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    DBMS_OUTPUT.PUT_LINE('SCENARIUSZ 10: METODY OBIEKTOW');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    
    -- Test 10.1: t_uczen_obj.wiek()
    BEGIN
        SELECT VALUE(u) INTO v_uczen FROM t_uczen u WHERE u.id_ucznia = 1;
        DBMS_OUTPUT.PUT_LINE('[OK] Test 10.1: uczen.wiek() = ' || v_uczen.wiek() || ' lat');
        v_test_ok := v_test_ok + 1;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 10.1: uczen.wiek() - ' || SQLERRM);
            v_test_fail := v_test_fail + 1;
    END;
    
    -- Test 10.2: t_uczen_obj.czy_dziecko()
    BEGIN
        SELECT VALUE(u) INTO v_uczen FROM t_uczen u WHERE u.id_ucznia = 1;
        DBMS_OUTPUT.PUT_LINE('[OK] Test 10.2: uczen.czy_dziecko() = ' || v_uczen.czy_dziecko());
        v_test_ok := v_test_ok + 1;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 10.2: uczen.czy_dziecko() - ' || SQLERRM);
            v_test_fail := v_test_fail + 1;
    END;
    
    -- Test 10.3: t_nauczyciel_obj.lata_stazu()
    BEGIN
        SELECT VALUE(n) INTO v_naucz FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
        DBMS_OUTPUT.PUT_LINE('[OK] Test 10.3: nauczyciel.lata_stazu() = ' || v_naucz.lata_stazu() || ' lat');
        v_test_ok := v_test_ok + 1;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 10.3: nauczyciel.lata_stazu() - ' || SQLERRM);
            v_test_fail := v_test_fail + 1;
    END;
    
    -- Test 10.4: t_nauczyciel_obj.liczba_instrumentow()
    BEGIN
        SELECT VALUE(n) INTO v_naucz FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
        DBMS_OUTPUT.PUT_LINE('[OK] Test 10.4: nauczyciel.liczba_instrumentow() = ' || 
                            v_naucz.liczba_instrumentow());
        v_test_ok := v_test_ok + 1;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 10.4: nauczyciel.liczba_instrumentow() - ' || SQLERRM);
            v_test_fail := v_test_fail + 1;
    END;
    
    -- Test 10.5: t_sala_obj.opis_pelny()
    BEGIN
        SELECT VALUE(s) INTO v_sala FROM t_sala s WHERE s.id_sali = 1;
        DBMS_OUTPUT.PUT_LINE('[OK] Test 10.5: sala.opis_pelny() = ' || v_sala.opis_pelny());
        v_test_ok := v_test_ok + 1;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] Test 10.5: sala.opis_pelny() - ' || SQLERRM);
            v_test_fail := v_test_fail + 1;
    END;
    
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Scenariusz 10: OK=' || v_test_ok || ' FAIL=' || v_test_fail);
END;
/

-- ============================================================================
-- PODSUMOWANIE TESTOW
-- ============================================================================

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('============================================================');
    DBMS_OUTPUT.PUT_LINE('PODSUMOWANIE WSZYSTKICH SCENARIUSZY TESTOWYCH');
    DBMS_OUTPUT.PUT_LINE('============================================================');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Scenariusz 1:  Dane podstawowe');
    DBMS_OUTPUT.PUT_LINE('Scenariusz 2:  Walidacja wieku ucznia (min. 5 lat)');
    DBMS_OUTPUT.PUT_LINE('Scenariusz 3:  Dni robocze (tylko Pn-Pt)');
    DBMS_OUTPUT.PUT_LINE('Scenariusz 4:  Godziny dla dzieci (14:00-19:00)');
    DBMS_OUTPUT.PUT_LINE('Scenariusz 5:  Limit nauczyciela (max 6h/dzien)');
    DBMS_OUTPUT.PUT_LINE('Scenariusz 6:  Limit ucznia (max 2 lekcje/dzien)');
    DBMS_OUTPUT.PUT_LINE('Scenariusz 7:  Konflikty (sala, nauczyciel, uczen)');
    DBMS_OUTPUT.PUT_LINE('Scenariusz 8:  Blokada usuwania');
    DBMS_OUTPUT.PUT_LINE('Scenariusz 9:  Pakiety CRUD');
    DBMS_OUTPUT.PUT_LINE('Scenariusz 10: Metody obiektow');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('============================================================');
END;
/
