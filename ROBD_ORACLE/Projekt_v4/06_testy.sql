-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 06_testy.sql
-- Opis: Scenariusze testowe
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================
-- WAZNE: Testy uzycia logiki biznesowej (limity, konflikty) uzywaja
-- procedury pkg_lekcja.zaplanuj() - NIE bezposrednich INSERT-ow!
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- ============================================================================
-- SCENARIUSZ 1: SPRAWDZENIE DANYCH PODSTAWOWYCH
-- ============================================================================
DECLARE
    v_ok NUMBER := 0;
    v_fail NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    DBMS_OUTPUT.PUT_LINE('SCENARIUSZ 1: SPRAWDZENIE DANYCH PODSTAWOWYCH');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    
    -- Instrumenty
    FOR r IN (SELECT COUNT(*) AS cnt FROM t_instrument) LOOP
        IF r.cnt >= 10 THEN
            DBMS_OUTPUT.PUT_LINE('[OK] 1.1: Instrumenty (' || r.cnt || ')');
            v_ok := v_ok + 1;
        ELSE
            DBMS_OUTPUT.PUT_LINE('[FAIL] 1.1: Brak instrumentow');
            v_fail := v_fail + 1;
        END IF;
    END LOOP;
    
    -- Sale
    FOR r IN (SELECT COUNT(*) AS cnt FROM t_sala) LOOP
        IF r.cnt >= 5 THEN
            DBMS_OUTPUT.PUT_LINE('[OK] 1.2: Sale (' || r.cnt || ')');
            v_ok := v_ok + 1;
        ELSE
            DBMS_OUTPUT.PUT_LINE('[FAIL] 1.2: Brak sal');
            v_fail := v_fail + 1;
        END IF;
    END LOOP;
    
    -- Nauczyciele
    FOR r IN (SELECT COUNT(*) AS cnt FROM t_nauczyciel) LOOP
        IF r.cnt >= 5 THEN
            DBMS_OUTPUT.PUT_LINE('[OK] 1.3: Nauczyciele (' || r.cnt || ')');
            v_ok := v_ok + 1;
        ELSE
            DBMS_OUTPUT.PUT_LINE('[FAIL] 1.3: Brak nauczycieli');
            v_fail := v_fail + 1;
        END IF;
    END LOOP;
    
    -- Uczniowie
    FOR r IN (SELECT COUNT(*) AS cnt FROM t_uczen) LOOP
        IF r.cnt >= 10 THEN
            DBMS_OUTPUT.PUT_LINE('[OK] 1.4: Uczniowie (' || r.cnt || ')');
            v_ok := v_ok + 1;
        ELSE
            DBMS_OUTPUT.PUT_LINE('[FAIL] 1.4: Brak uczniow');
            v_fail := v_fail + 1;
        END IF;
    END LOOP;
    
    -- Kursy
    FOR r IN (SELECT COUNT(*) AS cnt FROM t_kurs) LOOP
        IF r.cnt >= 10 THEN
            DBMS_OUTPUT.PUT_LINE('[OK] 1.5: Kursy (' || r.cnt || ')');
            v_ok := v_ok + 1;
        ELSE
            DBMS_OUTPUT.PUT_LINE('[FAIL] 1.5: Brak kursow');
            v_fail := v_fail + 1;
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Scenariusz 1: OK=' || v_ok || ' FAIL=' || v_fail);
END;
/

-- ============================================================================
-- SCENARIUSZ 2: WALIDACJA WIEKU UCZNIA (trigger trg_uczen_wiek)
-- ============================================================================
DECLARE
    v_ok NUMBER := 0;
    v_fail NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    DBMS_OUTPUT.PUT_LINE('SCENARIUSZ 2: WALIDACJA WIEKU UCZNIA (min. 5 lat)');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    
    -- Test 2.1: 3-latek (FAIL)
    BEGIN
        INSERT INTO t_uczen VALUES (
            t_uczen_obj(seq_uczen.NEXTVAL, 'Test', 'Trzylatek', 
                       ADD_MONTHS(SYSDATE, -36), NULL, SYSDATE)
        );
        DBMS_OUTPUT.PUT_LINE('[FAIL] 2.1: Dodano 3-latka!');
        v_fail := v_fail + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20101 THEN
                DBMS_OUTPUT.PUT_LINE('[OK] 2.1: 3-latek odrzucony');
                v_ok := v_ok + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[FAIL] 2.1: Nieoczekiwany blad');
                v_fail := v_fail + 1;
            END IF;
    END;
    
    -- Test 2.2: 5-latek (OK)
    BEGIN
        INSERT INTO t_uczen VALUES (
            t_uczen_obj(seq_uczen.NEXTVAL, 'Test', 'Pieciolatek', 
                       ADD_MONTHS(SYSDATE, -60), NULL, SYSDATE)
        );
        DBMS_OUTPUT.PUT_LINE('[OK] 2.2: 5-latek dodany');
        v_ok := v_ok + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] 2.2: Nie mozna dodac 5-latka');
            v_fail := v_fail + 1;
    END;
    
    DBMS_OUTPUT.PUT_LINE('Scenariusz 2: OK=' || v_ok || ' FAIL=' || v_fail);
END;
/

-- ============================================================================
-- SCENARIUSZ 3: WALIDACJA DNI ROBOCZYCH (trigger trg_lekcja_dni_robocze)
-- ============================================================================
DECLARE
    v_ok NUMBER := 0;
    v_fail NUMBER := 0;
    v_sobota DATE;
    v_poniedzialek DATE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    DBMS_OUTPUT.PUT_LINE('SCENARIUSZ 3: WALIDACJA DNI ROBOCZYCH');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    
    -- Sobota nastepnego tygodnia (niezalezne od jezyka)
    v_sobota := TRUNC(SYSDATE, 'IW') + 7 + 5;
    -- Poniedzialek nastepnego tygodnia
    v_poniedzialek := TRUNC(SYSDATE, 'IW') + 7;
    
    -- Test 3.1: Lekcja w sobote przez zaplanuj (FAIL)
    BEGIN
        pkg_lekcja.zaplanuj(7, 1, 1, 1, v_sobota, '10:00', 45);
        DBMS_OUTPUT.PUT_LINE('[FAIL] 3.1: Dodano lekcje w sobote!');
        v_fail := v_fail + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20102 THEN
                DBMS_OUTPUT.PUT_LINE('[OK] 3.1: Sobota odrzucona');
                v_ok := v_ok + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] 3.1: ' || SQLERRM);
                v_ok := v_ok + 1;
            END IF;
    END;
    
    -- Test 3.2: Lekcja w poniedzialek (OK)
    BEGIN
        pkg_lekcja.zaplanuj(8, 1, 1, 2, v_poniedzialek, '09:00', 45);
        DBMS_OUTPUT.PUT_LINE('[OK] 3.2: Poniedzialek akceptowany');
        v_ok := v_ok + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] 3.2: ' || SQLERRM);
            v_fail := v_fail + 1;
    END;
    
    DBMS_OUTPUT.PUT_LINE('Scenariusz 3: OK=' || v_ok || ' FAIL=' || v_fail);
END;
/

-- ============================================================================
-- SCENARIUSZ 4: GODZINY DLA DZIECI (trigger trg_lekcja_godziny_dziecka)
-- ============================================================================
DECLARE
    v_ok NUMBER := 0;
    v_fail NUMBER := 0;
    v_data DATE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    DBMS_OUTPUT.PUT_LINE('SCENARIUSZ 4: GODZINY DLA DZIECI (14:00-19:00)');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    
    -- Sroda nastepnego tygodnia (niezalezne od jezyka)
    v_data := TRUNC(SYSDATE, 'IW') + 7 + 2;
    
    -- Test 4.1: Dziecko o 08:00 (FAIL)
    BEGIN
        pkg_lekcja.zaplanuj(1, 1, 1, 2, v_data, '08:00', 45);
        DBMS_OUTPUT.PUT_LINE('[FAIL] 4.1: Dziecko o 08:00 zaakceptowane!');
        v_fail := v_fail + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20103 THEN
                DBMS_OUTPUT.PUT_LINE('[OK] 4.1: Dziecko o 08:00 odrzucone');
                v_ok := v_ok + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] 4.1: ' || SQLERRM);
                v_ok := v_ok + 1;
            END IF;
    END;
    
    -- Test 4.2: Dziecko o 15:00 (OK)
    BEGIN
        pkg_lekcja.zaplanuj(2, 1, 1, 2, v_data, '15:00', 45);
        DBMS_OUTPUT.PUT_LINE('[OK] 4.2: Dziecko o 15:00 akceptowane');
        v_ok := v_ok + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] 4.2: ' || SQLERRM);
            v_fail := v_fail + 1;
    END;
    
    -- Test 4.3: Dorosly o 08:00 (OK)
    BEGIN
        pkg_lekcja.zaplanuj(7, 1, 1, 2, v_data, '08:00', 45);
        DBMS_OUTPUT.PUT_LINE('[OK] 4.3: Dorosly o 08:00 akceptowany');
        v_ok := v_ok + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] 4.3: ' || SQLERRM);
            v_fail := v_fail + 1;
    END;
    
    DBMS_OUTPUT.PUT_LINE('Scenariusz 4: OK=' || v_ok || ' FAIL=' || v_fail);
END;
/

-- ============================================================================
-- SCENARIUSZ 5: LIMIT NAUCZYCIELA (max 6h = 360 min)
-- Uzywa pkg_lekcja.zaplanuj() - NIE bezposredni INSERT!
-- ============================================================================
DECLARE
    v_ok NUMBER := 0;
    v_fail NUMBER := 0;
    v_data DATE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    DBMS_OUTPUT.PUT_LINE('SCENARIUSZ 5: LIMIT NAUCZYCIELA (max 6h)');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    
    -- Wtorek za 2 tygodnie (niezalezne od jezyka)
    v_data := TRUNC(SYSDATE, 'IW') + 14 + 1;
    
    BEGIN
        -- Dodaj 6 lekcji po 60 min = 360 min (Nauczyciel 3 - Flet)
        pkg_lekcja.zaplanuj(5, 3, 8, 3, v_data, '08:00', 60);
        pkg_lekcja.zaplanuj(6, 3, 8, 3, v_data, '09:00', 60);
        pkg_lekcja.zaplanuj(7, 3, 8, 3, v_data, '10:00', 60);
        pkg_lekcja.zaplanuj(8, 3, 8, 3, v_data, '11:00', 60);
        pkg_lekcja.zaplanuj(9, 3, 8, 4, v_data, '13:00', 60);
        pkg_lekcja.zaplanuj(10, 3, 8, 4, v_data, '14:00', 60);
        
        DBMS_OUTPUT.PUT_LINE('[OK] 5.1: 6h lekcji (360 min) dodane');
        v_ok := v_ok + 1;
        
        -- Test 5.2: Proba dodania 7. lekcji (FAIL - przekroczenie limitu)
        BEGIN
            pkg_lekcja.zaplanuj(5, 3, 8, 4, v_data, '15:00', 30);
            DBMS_OUTPUT.PUT_LINE('[FAIL] 5.2: 7. lekcja dodana (limit przekroczony)!');
            v_fail := v_fail + 1;
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE = -20104 THEN
                    DBMS_OUTPUT.PUT_LINE('[OK] 5.2: 7. lekcja odrzucona (limit 6h)');
                    v_ok := v_ok + 1;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[FAIL] 5.2: Nieoczekiwany blad: ' || SQLERRM);
                    v_fail := v_fail + 1;
                END IF;
        END;
        
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] 5.1: Blad przy dodawaniu lekcji: ' || SQLERRM);
            v_fail := v_fail + 1;
            ROLLBACK;
    END;
    
    DBMS_OUTPUT.PUT_LINE('Scenariusz 5: OK=' || v_ok || ' FAIL=' || v_fail);
END;
/

-- ============================================================================
-- SCENARIUSZ 6: LIMIT UCZNIA (max 2 lekcje/dzien)
-- Uzywa pkg_lekcja.zaplanuj() - NIE bezposredni INSERT!
-- ============================================================================
DECLARE
    v_ok NUMBER := 0;
    v_fail NUMBER := 0;
    v_data DATE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    DBMS_OUTPUT.PUT_LINE('SCENARIUSZ 6: LIMIT UCZNIA (max 2 lekcje/dzien)');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    
    -- Piatek za 3 tygodnie (niezalezne od jezyka)
    v_data := TRUNC(SYSDATE, 'IW') + 21 + 4;
    
    BEGIN
        -- Lekcja 1: Uczen 7, Nauczyciel 1, Kurs 1 (Fortepian)
        pkg_lekcja.zaplanuj(7, 1, 1, 1, v_data, '09:00', 45);
        DBMS_OUTPUT.PUT_LINE('[OK] 6.1: 1. lekcja ucznia dodana');
        v_ok := v_ok + 1;
        
        -- Lekcja 2: Uczen 7, Nauczyciel 2, Kurs 4 (Gitara klasyczna)
        pkg_lekcja.zaplanuj(7, 2, 4, 3, v_data, '11:00', 45);
        DBMS_OUTPUT.PUT_LINE('[OK] 6.2: 2. lekcja ucznia dodana');
        v_ok := v_ok + 1;
        
        -- Proba 3. lekcji (FAIL)
        BEGIN
            pkg_lekcja.zaplanuj(7, 3, 8, 4, v_data, '14:00', 45);
            DBMS_OUTPUT.PUT_LINE('[FAIL] 6.3: 3. lekcja dodana!');
            v_fail := v_fail + 1;
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE = -20105 THEN
                    DBMS_OUTPUT.PUT_LINE('[OK] 6.3: 3. lekcja odrzucona (limit 2/dzien)');
                    v_ok := v_ok + 1;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[FAIL] 6.3: Nieoczekiwany blad: ' || SQLERRM);
                    v_fail := v_fail + 1;
                END IF;
        END;
        
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] 6: Blad: ' || SQLERRM);
            v_fail := v_fail + 1;
            ROLLBACK;
    END;
    
    DBMS_OUTPUT.PUT_LINE('Scenariusz 6: OK=' || v_ok || ' FAIL=' || v_fail);
END;
/

-- ============================================================================
-- SCENARIUSZ 7: KONFLIKTY (sala, nauczyciel, uczen)
-- Uzywa pkg_lekcja.zaplanuj() - NIE bezposredni INSERT!
-- ============================================================================
DECLARE
    v_ok NUMBER := 0;
    v_fail NUMBER := 0;
    v_data DATE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    DBMS_OUTPUT.PUT_LINE('SCENARIUSZ 7: KONFLIKTY');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    
    -- Czwartek za 4 tygodnie (niezalezne od jezyka)
    v_data := TRUNC(SYSDATE, 'IW') + 28 + 3;
    
    BEGIN
        -- Lekcja bazowa: 10:00-10:45, Sala 1, Nauczyciel 1, Uczen 7
        pkg_lekcja.zaplanuj(7, 1, 1, 1, v_data, '10:00', 45);
        DBMS_OUTPUT.PUT_LINE('[INFO] Lekcja bazowa: 10:00-10:45, Sala A1, Naucz.1, Uczen 7');
        
        -- Test 7.1: Konflikt sali (ta sama sala, nakladajacy sie czas)
        BEGIN
            pkg_lekcja.zaplanuj(8, 2, 4, 1, v_data, '10:30', 45);
            DBMS_OUTPUT.PUT_LINE('[FAIL] 7.1: Konflikt sali niezablokowany!');
            v_fail := v_fail + 1;
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE = -20106 THEN
                    DBMS_OUTPUT.PUT_LINE('[OK] 7.1: Konflikt sali wykryty');
                    v_ok := v_ok + 1;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[FAIL] 7.1: Nieoczekiwany blad: ' || SQLERRM);
                    v_fail := v_fail + 1;
                END IF;
        END;
        
        -- Test 7.2: Konflikt nauczyciela (ten sam nauczyciel, inna sala)
        BEGIN
            pkg_lekcja.zaplanuj(8, 1, 1, 2, v_data, '10:15', 45);
            DBMS_OUTPUT.PUT_LINE('[FAIL] 7.2: Konflikt nauczyciela niezablokowany!');
            v_fail := v_fail + 1;
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE = -20107 THEN
                    DBMS_OUTPUT.PUT_LINE('[OK] 7.2: Konflikt nauczyciela wykryty');
                    v_ok := v_ok + 1;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[FAIL] 7.2: Nieoczekiwany blad: ' || SQLERRM);
                    v_fail := v_fail + 1;
                END IF;
        END;
        
        -- Test 7.3: Konflikt ucznia (ten sam uczen, inny nauczyciel i sala)
        BEGIN
            pkg_lekcja.zaplanuj(7, 2, 4, 3, v_data, '10:20', 30);
            DBMS_OUTPUT.PUT_LINE('[FAIL] 7.3: Konflikt ucznia niezablokowany!');
            v_fail := v_fail + 1;
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE = -20108 THEN
                    DBMS_OUTPUT.PUT_LINE('[OK] 7.3: Konflikt ucznia wykryty');
                    v_ok := v_ok + 1;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[FAIL] 7.3: Nieoczekiwany blad: ' || SQLERRM);
                    v_fail := v_fail + 1;
                END IF;
        END;
        
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] 7: Blad: ' || SQLERRM);
            v_fail := v_fail + 1;
            ROLLBACK;
    END;
    
    DBMS_OUTPUT.PUT_LINE('Scenariusz 7: OK=' || v_ok || ' FAIL=' || v_fail);
END;
/

-- ============================================================================
-- SCENARIUSZ 8: KOMPETENCJE NAUCZYCIELA
-- ============================================================================
DECLARE
    v_ok NUMBER := 0;
    v_fail NUMBER := 0;
    v_data DATE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    DBMS_OUTPUT.PUT_LINE('SCENARIUSZ 8: KOMPETENCJE NAUCZYCIELA');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    
    -- Poniedzialek za 5 tygodni (niezalezne od jezyka)
    v_data := TRUNC(SYSDATE, 'IW') + 35;
    
    -- Test 8.1: Nauczyciel 1 (Fortepian, Skrzypce) uczy Fortepian - OK
    BEGIN
        pkg_lekcja.zaplanuj(7, 1, 1, 1, v_data, '09:00', 45);
        DBMS_OUTPUT.PUT_LINE('[OK] 8.1: Naucz. 1 uczy Fortepian (ma kompetencje)');
        v_ok := v_ok + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] 8.1: ' || SQLERRM);
            v_fail := v_fail + 1;
    END;
    
    -- Test 8.2: Nauczyciel 1 uczy Gitara klasyczna - FAIL (nie ma kompetencji)
    BEGIN
        pkg_lekcja.zaplanuj(7, 1, 4, 1, v_data, '10:00', 45);
        DBMS_OUTPUT.PUT_LINE('[FAIL] 8.2: Naucz. 1 uczy Gitare (nie ma kompetencji)!');
        v_fail := v_fail + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20030 THEN
                DBMS_OUTPUT.PUT_LINE('[OK] 8.2: Brak kompetencji wykryty');
                v_ok := v_ok + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[FAIL] 8.2: Nieoczekiwany blad: ' || SQLERRM);
                v_fail := v_fail + 1;
            END IF;
    END;
    
    DBMS_OUTPUT.PUT_LINE('Scenariusz 8: OK=' || v_ok || ' FAIL=' || v_fail);
END;
/

-- ============================================================================
-- SCENARIUSZ 9: BLOKADA USUWANIA
-- ============================================================================
DECLARE
    v_ok NUMBER := 0;
    v_fail NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    DBMS_OUTPUT.PUT_LINE('SCENARIUSZ 9: BLOKADA USUWANIA');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    
    -- Test 9.1: Usuniecie nauczyciela z lekcjami
    BEGIN
        DELETE FROM t_nauczyciel WHERE id_nauczyciela = 1;
        DBMS_OUTPUT.PUT_LINE('[FAIL] 9.1: Usunieto nauczyciela z lekcjami!');
        v_fail := v_fail + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[OK] 9.1: Blokada usuwania nauczyciela');
            v_ok := v_ok + 1;
    END;
    
    -- Test 9.2: Usuniecie ucznia z lekcjami
    BEGIN
        DELETE FROM t_uczen WHERE id_ucznia = 1;
        DBMS_OUTPUT.PUT_LINE('[FAIL] 9.2: Usunieto ucznia z lekcjami!');
        v_fail := v_fail + 1;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[OK] 9.2: Blokada usuwania ucznia');
            v_ok := v_ok + 1;
    END;
    
    DBMS_OUTPUT.PUT_LINE('Scenariusz 9: OK=' || v_ok || ' FAIL=' || v_fail);
END;
/

-- ============================================================================
-- SCENARIUSZ 10: PAKIETY - OPERACJE
-- ============================================================================
DECLARE
    v_ok NUMBER := 0;
    v_fail NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    DBMS_OUTPUT.PUT_LINE('SCENARIUSZ 10: PAKIETY - OPERACJE');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    
    -- Test 10.1: pkg_uczen.lista
    BEGIN
        pkg_uczen.lista;
        DBMS_OUTPUT.PUT_LINE('[OK] 10.1: pkg_uczen.lista');
        v_ok := v_ok + 1;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] 10.1: ' || SQLERRM);
            v_fail := v_fail + 1;
    END;
    
    -- Test 10.2: pkg_uczen.info
    BEGIN
        pkg_uczen.info(1);
        DBMS_OUTPUT.PUT_LINE('[OK] 10.2: pkg_uczen.info');
        v_ok := v_ok + 1;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] 10.2: ' || SQLERRM);
            v_fail := v_fail + 1;
    END;
    
    -- Test 10.3: pkg_lekcja.plan_dnia
    BEGIN
        -- Poniedzialek nastepnego tygodnia (niezalezne od jezyka)
        pkg_lekcja.plan_dnia(TRUNC(SYSDATE, 'IW') + 7);
        DBMS_OUTPUT.PUT_LINE('[OK] 10.3: pkg_lekcja.plan_dnia');
        v_ok := v_ok + 1;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] 10.3: ' || SQLERRM);
            v_fail := v_fail + 1;
    END;
    
    -- Test 10.4: pkg_ocena.historia_ucznia
    BEGIN
        pkg_ocena.historia_ucznia(1);
        DBMS_OUTPUT.PUT_LINE('[OK] 10.4: pkg_ocena.historia_ucznia');
        v_ok := v_ok + 1;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] 10.4: ' || SQLERRM);
            v_fail := v_fail + 1;
    END;
    
    DBMS_OUTPUT.PUT_LINE('Scenariusz 10: OK=' || v_ok || ' FAIL=' || v_fail);
END;
/

-- ============================================================================
-- SCENARIUSZ 11: METODY OBIEKTOW
-- ============================================================================
DECLARE
    v_ok NUMBER := 0;
    v_fail NUMBER := 0;
    v_uczen t_uczen_obj;
    v_naucz t_nauczyciel_obj;
    v_sala t_sala_obj;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    DBMS_OUTPUT.PUT_LINE('SCENARIUSZ 11: METODY OBIEKTOW');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    
    -- Test 11.1: t_uczen_obj.wiek()
    BEGIN
        SELECT VALUE(u) INTO v_uczen FROM t_uczen u WHERE u.id_ucznia = 1;
        DBMS_OUTPUT.PUT_LINE('[OK] 11.1: uczen.wiek() = ' || v_uczen.wiek());
        v_ok := v_ok + 1;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] 11.1: ' || SQLERRM);
            v_fail := v_fail + 1;
    END;
    
    -- Test 11.2: t_uczen_obj.czy_dziecko()
    BEGIN
        SELECT VALUE(u) INTO v_uczen FROM t_uczen u WHERE u.id_ucznia = 1;
        DBMS_OUTPUT.PUT_LINE('[OK] 11.2: uczen.czy_dziecko() = ' || v_uczen.czy_dziecko());
        v_ok := v_ok + 1;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] 11.2: ' || SQLERRM);
            v_fail := v_fail + 1;
    END;
    
    -- Test 11.3: t_nauczyciel_obj.lata_stazu()
    BEGIN
        SELECT VALUE(n) INTO v_naucz FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
        DBMS_OUTPUT.PUT_LINE('[OK] 11.3: nauczyciel.lata_stazu() = ' || v_naucz.lata_stazu());
        v_ok := v_ok + 1;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] 11.3: ' || SQLERRM);
            v_fail := v_fail + 1;
    END;
    
    -- Test 11.4: t_nauczyciel_obj.liczba_instrumentow()
    BEGIN
        SELECT VALUE(n) INTO v_naucz FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
        DBMS_OUTPUT.PUT_LINE('[OK] 11.4: nauczyciel.liczba_instrumentow() = ' || 
                            v_naucz.liczba_instrumentow());
        v_ok := v_ok + 1;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] 11.4: ' || SQLERRM);
            v_fail := v_fail + 1;
    END;
    
    -- Test 11.5: t_sala_obj.opis_pelny()
    BEGIN
        SELECT VALUE(s) INTO v_sala FROM t_sala s WHERE s.id_sali = 1;
        DBMS_OUTPUT.PUT_LINE('[OK] 11.5: sala.opis_pelny() = ' || v_sala.opis_pelny());
        v_ok := v_ok + 1;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[FAIL] 11.5: ' || SQLERRM);
            v_fail := v_fail + 1;
    END;
    
    DBMS_OUTPUT.PUT_LINE('Scenariusz 11: OK=' || v_ok || ' FAIL=' || v_fail);
END;
/

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('============================================================');
    DBMS_OUTPUT.PUT_LINE('PODSUMOWANIE TESTOW');
    DBMS_OUTPUT.PUT_LINE('============================================================');
    DBMS_OUTPUT.PUT_LINE('1.  Dane podstawowe');
    DBMS_OUTPUT.PUT_LINE('2.  Walidacja wieku ucznia (min. 5 lat)');
    DBMS_OUTPUT.PUT_LINE('3.  Dni robocze (tylko Pn-Pt)');
    DBMS_OUTPUT.PUT_LINE('4.  Godziny dla dzieci (14:00-19:00)');
    DBMS_OUTPUT.PUT_LINE('5.  Limit nauczyciela (max 6h/dzien)');
    DBMS_OUTPUT.PUT_LINE('6.  Limit ucznia (max 2 lekcje/dzien)');
    DBMS_OUTPUT.PUT_LINE('7.  Konflikty (sala, nauczyciel, uczen)');
    DBMS_OUTPUT.PUT_LINE('8.  Kompetencje nauczyciela');
    DBMS_OUTPUT.PUT_LINE('9.  Blokada usuwania');
    DBMS_OUTPUT.PUT_LINE('10. Pakiety - operacje');
    DBMS_OUTPUT.PUT_LINE('11. Metody obiektow');
    DBMS_OUTPUT.PUT_LINE('============================================================');
END;
/
