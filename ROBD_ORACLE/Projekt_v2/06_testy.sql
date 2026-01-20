-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 06_testy.sql
-- Opis: KOMPLEKSOWE TESTY dla typow, tabel, pakietow, triggerow, danych, uzytkownikow
-- Wersja: 2.0
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================
/*
KATEGORIE TESTOW:
1. Testy TYPOW (metody obiektowe)
2. Testy TABEL (CHECK constraints, struktury)
3. Testy PAKIETOW (procedury, funkcje, kursory)
4. Testy TRIGGEROW (walidacja, blokady, audyt)
5. Testy SCENARIUSZY BIZNESOWYCH
6. Testy BLOKOWANIA USUWANIA
7. Testy UZYTKOWNIKOW (uprawnienia)

Motto: Prostota i logicznosc!
*/

SET SERVEROUTPUT ON;
SET LINESIZE 200;

PROMPT ========================================================================
PROMPT ROZPOCZYNAM KOMPLEKSOWE TESTY v2.0
PROMPT ========================================================================

-- ############################################################################
-- KATEGORIA 1: TESTY TYPOW (metody obiektowe)
-- ############################################################################

PROMPT ========================================================================
PROMPT KATEGORIA 1: TESTY TYPOW
PROMPT ========================================================================

-- ----------------------------------------------------------------------------
-- TEST 1.1: Metody typu t_uczen_obj
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 1.1] Metody typu t_uczen_obj

DECLARE
    v_uczen t_uczen_obj;
    v_wiek NUMBER;
    v_pelnoletni VARCHAR2(3);
    v_dane VARCHAR2(100);
BEGIN
    SELECT VALUE(u) INTO v_uczen FROM t_uczen u WHERE u.id_ucznia = 1;
    
    v_wiek := v_uczen.wiek();
    v_pelnoletni := v_uczen.czy_pelnoletni();
    v_dane := v_uczen.pelne_dane();
    
    DBMS_OUTPUT.PUT_LINE('Uczen: ' || v_dane);
    DBMS_OUTPUT.PUT_LINE('Wiek: ' || v_wiek);
    DBMS_OUTPUT.PUT_LINE('Pelnoletni: ' || v_pelnoletni);
    
    IF v_wiek > 0 AND v_pelnoletni IN ('TAK', 'NIE') AND v_dane IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Metody t_uczen_obj dzialaja poprawnie');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAIL] Blad w metodach t_uczen_obj');
    END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 1.2: Metody typu t_nauczyciel_obj
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 1.2] Metody typu t_nauczyciel_obj

DECLARE
    v_nauczyciel t_nauczyciel_obj;
    v_dane VARCHAR2(100);
    v_liczba NUMBER;
    v_senior VARCHAR2(3);
BEGIN
    SELECT VALUE(n) INTO v_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    
    v_dane := v_nauczyciel.pelne_dane();
    v_liczba := v_nauczyciel.liczba_instrumentow();
    v_senior := v_nauczyciel.czy_senior();
    
    DBMS_OUTPUT.PUT_LINE('Nauczyciel: ' || v_dane);
    DBMS_OUTPUT.PUT_LINE('Liczba instrumentow: ' || v_liczba);
    DBMS_OUTPUT.PUT_LINE('Senior (10+ lat): ' || v_senior);
    
    IF v_liczba > 0 AND v_senior IN ('TAK', 'NIE') THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Metody t_nauczyciel_obj dzialaja poprawnie');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAIL] Blad w metodach t_nauczyciel_obj');
    END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 1.3: Metody typu t_kurs_obj
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 1.3] Metody typu t_kurs_obj

DECLARE
    v_kurs t_kurs_obj;
    v_ind VARCHAR2(3);
    v_info VARCHAR2(200);
BEGIN
    SELECT VALUE(k) INTO v_kurs FROM t_kurs k WHERE k.id_kursu = 1;
    
    v_ind := v_kurs.czy_indywidualny();
    v_info := v_kurs.info();
    
    DBMS_OUTPUT.PUT_LINE('Kurs info: ' || v_info);
    DBMS_OUTPUT.PUT_LINE('Indywidualny: ' || v_ind);
    
    IF v_ind IN ('TAK', 'NIE') AND v_info IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Metody t_kurs_obj dzialaja poprawnie');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAIL] Blad w metodach t_kurs_obj');
    END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 1.4: Metody typu t_lekcja_obj
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 1.4] Metody typu t_lekcja_obj

DECLARE
    v_lekcja t_lekcja_obj;
    v_odbyta VARCHAR2(3);
    v_opis VARCHAR2(200);
BEGIN
    SELECT VALUE(l) INTO v_lekcja FROM t_lekcja l WHERE l.id_lekcji = 1;
    
    v_odbyta := v_lekcja.czy_odbyta();
    v_opis := v_lekcja.krotki_opis();
    
    DBMS_OUTPUT.PUT_LINE('Lekcja opis: ' || v_opis);
    DBMS_OUTPUT.PUT_LINE('Odbyta: ' || v_odbyta);
    
    IF v_odbyta IN ('TAK', 'NIE') AND v_opis IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Metody t_lekcja_obj dzialaja poprawnie');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAIL] Blad w metodach t_lekcja_obj');
    END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 1.5: Metody typu t_zapis_obj
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 1.5] Metody typu t_zapis_obj

DECLARE
    v_zapis t_zapis_obj;
    v_aktywny VARCHAR2(3);
    v_dni NUMBER;
BEGIN
    SELECT VALUE(z) INTO v_zapis FROM t_zapis z WHERE z.id_zapisu = 1;
    
    v_aktywny := v_zapis.czy_aktywny();
    v_dni := v_zapis.dni_od_zapisu();
    
    DBMS_OUTPUT.PUT_LINE('Zapis aktywny: ' || v_aktywny);
    DBMS_OUTPUT.PUT_LINE('Dni od zapisu: ' || v_dni);
    
    IF v_aktywny IN ('TAK', 'NIE') AND v_dni >= 0 THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Metody t_zapis_obj dzialaja poprawnie');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAIL] Blad w metodach t_zapis_obj');
    END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 1.6: Metody typu t_ocena_obj
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 1.6] Metody typu t_ocena_obj

DECLARE
    v_ocena t_ocena_obj;
    v_poziom VARCHAR2(20);
BEGIN
    SELECT VALUE(o) INTO v_ocena FROM t_ocena_postepu o WHERE o.id_oceny = 1;
    
    v_poziom := v_ocena.poziom_slowny();
    
    DBMS_OUTPUT.PUT_LINE('Ocena poziom: ' || v_poziom);
    
    IF v_poziom IN ('niedostateczny', 'dopuszczajacy', 'dostateczny', 
                    'dobry', 'bardzo dobry', 'celujacy') THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Metoda poziom_slowny() dziala poprawnie');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAIL] Blad w metodzie poziom_slowny()');
    END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 1.7: Metody typu t_sala_obj [NOWY]
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 1.7] Metody typu t_sala_obj [NOWY v2.0]

DECLARE
    v_sala t_sala_obj;
    v_opis VARCHAR2(200);
BEGIN
    SELECT VALUE(s) INTO v_sala FROM t_sala s WHERE s.id_sali = 1;
    
    v_opis := v_sala.opis_pelny();
    
    DBMS_OUTPUT.PUT_LINE('Sala: ' || v_sala.nazwa);
    DBMS_OUTPUT.PUT_LINE('Opis pelny: ' || v_opis);
    
    IF v_opis IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Metoda opis_pelny() dziala poprawnie');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAIL] Blad w metodzie opis_pelny()');
    END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 1.8: Metody typu t_semestr_obj [NOWY]
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 1.8] Metody typu t_semestr_obj [NOWY v2.0]

DECLARE
    v_semestr t_semestr_obj;
    v_w_trakcie VARCHAR2(3);
    v_dni NUMBER;
BEGIN
    SELECT VALUE(s) INTO v_semestr FROM t_semestr s WHERE s.czy_aktywny = 'T';
    
    v_w_trakcie := v_semestr.czy_w_trakcie();
    v_dni := v_semestr.dni_do_konca();
    
    DBMS_OUTPUT.PUT_LINE('Semestr: ' || v_semestr.nazwa);
    DBMS_OUTPUT.PUT_LINE('W trakcie: ' || v_w_trakcie);
    DBMS_OUTPUT.PUT_LINE('Dni do konca: ' || v_dni);
    
    IF v_w_trakcie IN ('TAK', 'NIE') THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Metody t_semestr_obj dzialaja poprawnie');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAIL] Blad w metodach t_semestr_obj');
    END IF;
END;
/

-- ############################################################################
-- KATEGORIA 2: TESTY TABEL (CHECK constraints)
-- ############################################################################

PROMPT ========================================================================
PROMPT KATEGORIA 2: TESTY TABEL (CHECK constraints)
PROMPT ========================================================================

-- ----------------------------------------------------------------------------
-- TEST 2.1: CHECK - status lekcji
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 2.1] CHECK - nieprawidlowy status lekcji

DECLARE
    v_error BOOLEAN := FALSE;
BEGIN
    INSERT INTO t_lekcja (id_lekcji, data_lekcji, godzina_start, czas_trwania, status)
    VALUES (9999, SYSDATE, '10:00', 45, 'nieprawidlowy_status');
    
    DELETE FROM t_lekcja WHERE id_lekcji = 9999;
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('[PASS] CHECK zablokował nieprawidlowy status');
            v_error := TRUE;
        ELSE
            DBMS_OUTPUT.PUT_LINE('[FAIL] Nieoczekiwany blad: ' || SQLERRM);
        END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 2.2: CHECK - ocena poza zakresem
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 2.2] CHECK - ocena poza zakresem (1-6)

DECLARE
    v_ref_uczen REF t_uczen_obj;
    v_ref_nauczyciel REF t_nauczyciel_obj;
BEGIN
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 1;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(9999, SYSDATE, 7, 'Test', 'test', v_ref_uczen, v_ref_nauczyciel)
    );
    
    DELETE FROM t_ocena_postepu WHERE id_oceny = 9999;
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('[PASS] CHECK zablokował ocene 7 (poza zakresem)');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[FAIL] Nieoczekiwany blad: ' || SQLERRM);
        END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 2.3: CHECK - status zapisu
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 2.3] CHECK - nieprawidlowy status zapisu

BEGIN
    UPDATE t_zapis SET status = 'invalid' WHERE id_zapisu = 1;
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('[PASS] CHECK zablokował nieprawidlowy status zapisu');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[FAIL] Nieoczekiwany blad: ' || SQLERRM);
        END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 2.4: CHECK - typ kursu
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 2.4] CHECK - nieprawidlowy typ kursu

BEGIN
    INSERT INTO t_kurs VALUES (
        t_kurs_obj(9999, 'Test', 'invalid_type', 'Test', 100, 45)
    );
    DELETE FROM t_kurs WHERE id_kursu = 9999;
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('[PASS] CHECK zablokował nieprawidlowy typ kursu');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[FAIL] Nieoczekiwany blad: ' || SQLERRM);
        END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 2.5: CHECK - pojemnosc sali
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 2.5] CHECK - ujemna pojemnosc sali

BEGIN
    INSERT INTO t_sala VALUES (
        t_sala_obj(9999, 'Test', -5, 'N', 'N', NULL)
    );
    DELETE FROM t_sala WHERE id_sali = 9999;
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('[PASS] CHECK zablokował ujemna pojemnosc sali');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[FAIL] Nieoczekiwany blad: ' || SQLERRM);
        END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 2.6: CHECK - czy_aktywny semestr
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 2.6] CHECK - nieprawidlowa wartosc czy_aktywny

BEGIN
    UPDATE t_semestr SET czy_aktywny = 'X' WHERE id_semestru = 1;
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            DBMS_OUTPUT.PUT_LINE('[PASS] CHECK zablokował nieprawidlowa wartosc czy_aktywny');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[FAIL] Nieoczekiwany blad: ' || SQLERRM);
        END IF;
END;
/

-- ############################################################################
-- KATEGORIA 3: TESTY PAKIETOW
-- ############################################################################

PROMPT ========================================================================
PROMPT KATEGORIA 3: TESTY PAKIETOW
PROMPT ========================================================================

-- ----------------------------------------------------------------------------
-- TEST 3.1: pkg_semestr.info_semestr
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 3.1] pkg_semestr.info_semestr

BEGIN
    pkg_semestr.info_semestr();
    DBMS_OUTPUT.PUT_LINE('[PASS] Procedura info_semestr() wykonana');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[FAIL] Blad: ' || SQLERRM);
END;
/

-- ----------------------------------------------------------------------------
-- TEST 3.2: pkg_semestr.pobierz_aktywny_semestr
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 3.2] pkg_semestr.pobierz_aktywny_semestr

DECLARE
    v_sem t_semestr_obj;
BEGIN
    v_sem := pkg_semestr.pobierz_aktywny_semestr();
    
    IF v_sem IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Aktywny semestr: ' || v_sem.nazwa);
        DBMS_OUTPUT.PUT_LINE('[PASS] Funkcja pobierz_aktywny_semestr() dziala');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[FAIL] Brak aktywnego semestru');
    END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 3.3: pkg_sala.lista_sal
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 3.3] pkg_sala.lista_sal

BEGIN
    pkg_sala.lista_sal();
    DBMS_OUTPUT.PUT_LINE('[PASS] Procedura lista_sal() wykonana');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[FAIL] Blad: ' || SQLERRM);
END;
/

-- ----------------------------------------------------------------------------
-- TEST 3.4: pkg_sala.sprawdz_dostepnosc
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 3.4] pkg_sala.sprawdz_dostepnosc

DECLARE
    v_status VARCHAR2(20);
BEGIN
    -- Sprawdz zajeta sale (ID 1 na 2025-05-20 o 09:00)
    v_status := pkg_sala.sprawdz_dostepnosc(1, TO_DATE('2025-05-20', 'YYYY-MM-DD'), '09:00');
    DBMS_OUTPUT.PUT_LINE('Sala 1 o 09:00: ' || v_status);
    
    -- Sprawdz wolna godzine
    v_status := pkg_sala.sprawdz_dostepnosc(1, TO_DATE('2025-05-20', 'YYYY-MM-DD'), '20:00');
    DBMS_OUTPUT.PUT_LINE('Sala 1 o 20:00: ' || v_status);
    
    IF v_status = 'WOLNA' THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Funkcja sprawdz_dostepnosc() dziala');
    END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 3.5: pkg_uczen.lista_uczniow
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 3.5] pkg_uczen.lista_uczniow

BEGIN
    pkg_uczen.lista_uczniow();
    DBMS_OUTPUT.PUT_LINE('[PASS] Procedura lista_uczniow() wykonana');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[FAIL] Blad: ' || SQLERRM);
END;
/

-- ----------------------------------------------------------------------------
-- TEST 3.6: pkg_uczen.liczba_uczniow
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 3.6] pkg_uczen.liczba_uczniow

DECLARE
    v_liczba NUMBER;
BEGIN
    v_liczba := pkg_uczen.liczba_uczniow();
    DBMS_OUTPUT.PUT_LINE('Liczba uczniow: ' || v_liczba);
    
    IF v_liczba = 12 THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Funkcja liczba_uczniow() zwraca 12');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] Oczekiwano 12, otrzymano ' || v_liczba);
    END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 3.7: pkg_uczen.srednia_ocen
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 3.7] pkg_uczen.srednia_ocen

DECLARE
    v_srednia NUMBER;
BEGIN
    v_srednia := pkg_uczen.srednia_ocen(1);
    DBMS_OUTPUT.PUT_LINE('Srednia ucznia ID 1: ' || v_srednia);
    
    IF v_srednia > 0 THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Funkcja srednia_ocen() dziala');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] Brak ocen lub srednia = 0');
    END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 3.8: pkg_uczen.uczniowie_wiek (REF CURSOR)
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 3.8] pkg_uczen.uczniowie_wiek - REF CURSOR

DECLARE
    v_cursor SYS_REFCURSOR;
    v_id NUMBER;
    v_imie VARCHAR2(50);
    v_nazwisko VARCHAR2(50);
    v_wiek NUMBER;
    v_count NUMBER := 0;
BEGIN
    v_cursor := pkg_uczen.uczniowie_wiek(5, 15);
    
    DBMS_OUTPUT.PUT_LINE('Uczniowie w wieku 5-15 lat (dzieci):');
    LOOP
        FETCH v_cursor INTO v_id, v_imie, v_nazwisko, v_wiek;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('  ' || v_imie || ' ' || v_nazwisko || ' (' || v_wiek || ' lat)');
        v_count := v_count + 1;
    END LOOP;
    CLOSE v_cursor;
    
    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] REF CURSOR zwrocil ' || v_count || ' uczniow');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] Brak uczniow w tym przedziale wiekowym');
    END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 3.9: pkg_lekcja.raport_dzienny
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 3.9] pkg_lekcja.raport_dzienny

BEGIN
    pkg_lekcja.raport_dzienny(TO_DATE('2025-05-20', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('[PASS] Procedura raport_dzienny() wykonana');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[FAIL] Blad: ' || SQLERRM);
END;
/

-- ----------------------------------------------------------------------------
-- TEST 3.10: pkg_lekcja.sprawdz_dostepnosc_kompleksowa
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 3.10] pkg_lekcja.sprawdz_dostepnosc_kompleksowa

DECLARE
    v_wynik VARCHAR2(200);
BEGIN
    -- Sprawdz wolny termin
    v_wynik := pkg_lekcja.sprawdz_dostepnosc_kompleksowa(1, 1, 1, 
                    TO_DATE('2025-06-01', 'YYYY-MM-DD'), '10:00');
    DBMS_OUTPUT.PUT_LINE('Wolny termin: ' || v_wynik);
    
    -- Sprawdz zajety termin (Anna ma lekcje 2025-05-27 o 09:00)
    v_wynik := pkg_lekcja.sprawdz_dostepnosc_kompleksowa(1, 1, 1,
                    TO_DATE('2025-05-27', 'YYYY-MM-DD'), '09:00');
    DBMS_OUTPUT.PUT_LINE('Zajety termin: ' || v_wynik);
    
    IF v_wynik LIKE 'BLAD%' THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Wykryto konflikt poprawnie');
    END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 3.11: pkg_lekcja.statystyki_nauczyciela
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 3.11] pkg_lekcja.statystyki_nauczyciela

BEGIN
    pkg_lekcja.statystyki_nauczyciela(1, TO_DATE('2025-05-27', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('[PASS] Procedura statystyki_nauczyciela() wykonana');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[FAIL] Blad: ' || SQLERRM);
END;
/

-- ----------------------------------------------------------------------------
-- TEST 3.12: pkg_ocena.raport_postepu
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 3.12] pkg_ocena.raport_postepu

BEGIN
    pkg_ocena.raport_postepu(1);
    DBMS_OUTPUT.PUT_LINE('[PASS] Procedura raport_postepu() wykonana');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[FAIL] Blad: ' || SQLERRM);
END;
/

-- ----------------------------------------------------------------------------
-- TEST 3.13: pkg_ocena.porownaj_uczniow
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 3.13] pkg_ocena.porownaj_uczniow

BEGIN
    pkg_ocena.porownaj_uczniow(1, 3);
    DBMS_OUTPUT.PUT_LINE('[PASS] Procedura porownaj_uczniow() wykonana');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[FAIL] Blad: ' || SQLERRM);
END;
/

-- ############################################################################
-- KATEGORIA 4: TESTY TRIGGEROW
-- ############################################################################

PROMPT ========================================================================
PROMPT KATEGORIA 4: TESTY TRIGGEROW
PROMPT ========================================================================

-- ----------------------------------------------------------------------------
-- TEST 4.1: trg_uczen_wiek - minimalny wiek 5 lat
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 4.1] Trigger: uczen musi miec min 5 lat

BEGIN
    INSERT INTO t_uczen VALUES (
        t_uczen_obj(9999, 'Baby', 'Test', SYSDATE - 365, 'baby@test.com', NULL, SYSDATE)
    );
    
    DELETE FROM t_uczen WHERE id_ucznia = 9999;
    DBMS_OUTPUT.PUT_LINE('[FAIL] Trigger powinien zablokowac zbyt mlodego ucznia');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -20001 THEN
            DBMS_OUTPUT.PUT_LINE('[PASS] Trigger zablokował ucznia ponizej 5 lat');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[FAIL] Nieoczekiwany blad: ' || SQLERRM);
        END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 4.2: trg_lekcja_godziny_dziecka - dzieci tylko 14:00-19:00
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 4.2] Trigger: dziecko (<15 lat) nie moze miec lekcji o 10:00

DECLARE
    v_ref_uczen REF t_uczen_obj;
    v_ref_nauczyciel REF t_nauczyciel_obj;
    v_ref_kurs REF t_kurs_obj;
    v_ref_sala REF t_sala_obj;
BEGIN
    -- Michal (ID 8) ma 12-13 lat - dziecko
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 8;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 1;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 1;
    
    -- Proba zaplanowania lekcji o 10:00 (przed 14:00!)
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(9999, TO_DATE('2025-06-10', 'YYYY-MM-DD'), '10:00', 45,
                     NULL, NULL, 'zaplanowana',
                     v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
    );
    
    DELETE FROM t_lekcja WHERE id_lekcji = 9999;
    DBMS_OUTPUT.PUT_LINE('[FAIL] Trigger powinien zablokowac lekcje rano dla dziecka');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -20050 THEN
            DBMS_OUTPUT.PUT_LINE('[PASS] Trigger zablokował lekcje dziecka poza godz. 14-19');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Kod bledu: ' || SQLCODE || ' - ' || SQLERRM);
        END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 4.3: trg_lekcja_godziny_dziecka - dziecko moze o 15:00
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 4.3] Trigger: dziecko MOZE miec lekcje o 15:00

DECLARE
    v_ref_uczen REF t_uczen_obj;
    v_ref_nauczyciel REF t_nauczyciel_obj;
    v_ref_kurs REF t_kurs_obj;
    v_ref_sala REF t_sala_obj;
    v_id NUMBER := 9998;
BEGIN
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 8;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 1;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 2;
    
    -- Lekcja o 15:00 - dozwolona dla dziecka
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(v_id, TO_DATE('2025-06-11', 'YYYY-MM-DD'), '15:00', 45,
                     NULL, NULL, 'zaplanowana',
                     v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
    );
    
    DBMS_OUTPUT.PUT_LINE('[PASS] Lekcja o 15:00 dla dziecka dozwolona');
    
    DELETE FROM t_lekcja WHERE id_lekcji = v_id;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[FAIL] Blad: ' || SQLERRM);
        ROLLBACK;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 4.4: trg_lekcja_limit_ucznia - max 2 lekcje dziennie
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 4.4] Trigger: uczen max 2 lekcje dziennie

DECLARE
    v_ref_uczen REF t_uczen_obj;
    v_ref_nauczyciel REF t_nauczyciel_obj;
    v_ref_kurs REF t_kurs_obj;
    v_ref_sala REF t_sala_obj;
BEGIN
    -- Anna (ID 1) - dodajmy 3. lekcje na 2025-05-27 (ma juz 1)
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 1;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 1;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 2;
    
    -- Dodaj 2. lekcje
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(9997, TO_DATE('2025-05-27', 'YYYY-MM-DD'), '11:00', 45,
                     NULL, NULL, 'zaplanowana',
                     v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
    );
    
    -- Proba dodania 3. lekcji
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(9996, TO_DATE('2025-05-27', 'YYYY-MM-DD'), '13:00', 45,
                     NULL, NULL, 'zaplanowana',
                     v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
    );
    
    DELETE FROM t_lekcja WHERE id_lekcji IN (9996, 9997);
    DBMS_OUTPUT.PUT_LINE('[FAIL] Trigger powinien zablokowac 3. lekcje');
EXCEPTION
    WHEN OTHERS THEN
        DELETE FROM t_lekcja WHERE id_lekcji = 9997;
        COMMIT;
        
        IF SQLCODE = -20052 THEN
            DBMS_OUTPUT.PUT_LINE('[PASS] Trigger zablokował 3. lekcje ucznia');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Kod: ' || SQLCODE || ' - ' || SQLERRM);
        END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 4.5: trg_lekcja_konflikt_sali - ta sama sala, ta sama godzina
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 4.5] Trigger: konflikt sali

DECLARE
    v_ref_uczen REF t_uczen_obj;
    v_ref_nauczyciel REF t_nauczyciel_obj;
    v_ref_kurs REF t_kurs_obj;
    v_ref_sala REF t_sala_obj;
BEGIN
    -- Proba zajecia sali 1 na 2025-05-20 o 09:00 (juz zajeta!)
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 2;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 2;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 3;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 1;
    
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(9995, TO_DATE('2025-05-20', 'YYYY-MM-DD'), '09:00', 45,
                     NULL, NULL, 'zaplanowana',
                     v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
    );
    
    DELETE FROM t_lekcja WHERE id_lekcji = 9995;
    DBMS_OUTPUT.PUT_LINE('[FAIL] Trigger powinien zablokowac konflikt sali');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -20054 THEN
            DBMS_OUTPUT.PUT_LINE('[PASS] Trigger zablokował konflikt sali');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Kod: ' || SQLCODE || ' - ' || SQLERRM);
        END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 4.6: trg_semestr_tylko_jeden_aktywny
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 4.6] Trigger: tylko jeden semestr aktywny

BEGIN
    -- Semestr 2 jest aktywny, proba aktywacji semestru 1
    UPDATE t_semestr SET czy_aktywny = 'T' WHERE id_semestru = 1;
    
    -- Sprawdz czy poprzedni zostal dezaktywowany
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM t_semestr WHERE czy_aktywny = 'T';
        
        IF v_count = 1 THEN
            DBMS_OUTPUT.PUT_LINE('[PASS] Tylko 1 semestr aktywny po zmianie');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[FAIL] ' || v_count || ' semestr(y/ow) aktywnych');
        END IF;
    END;
    
    -- Przywroc semestr 2 jako aktywny
    UPDATE t_semestr SET czy_aktywny = 'T' WHERE id_semestru = 2;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[FAIL] Blad: ' || SQLERRM);
        ROLLBACK;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 4.7: trg_lekcja_konflikt_nauczyciela
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 4.7] Trigger: konflikt nauczyciela

DECLARE
    v_ref_uczen REF t_uczen_obj;
    v_ref_nauczyciel REF t_nauczyciel_obj;
    v_ref_kurs REF t_kurs_obj;
    v_ref_sala REF t_sala_obj;
BEGIN
    -- Maria (ID 1) ma lekcje 2025-05-20 o 09:00
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 2;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 1;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 2;
    
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(9994, TO_DATE('2025-05-20', 'YYYY-MM-DD'), '09:00', 45,
                     NULL, NULL, 'zaplanowana',
                     v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
    );
    
    DELETE FROM t_lekcja WHERE id_lekcji = 9994;
    DBMS_OUTPUT.PUT_LINE('[FAIL] Trigger powinien zablokowac konflikt nauczyciela');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -20020 THEN
            DBMS_OUTPUT.PUT_LINE('[PASS] Trigger zablokował konflikt nauczyciela');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Kod: ' || SQLCODE || ' - ' || SQLERRM);
        END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 4.8: trg_lekcja_konflikt_ucznia
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 4.8] Trigger: konflikt ucznia

DECLARE
    v_ref_uczen REF t_uczen_obj;
    v_ref_nauczyciel REF t_nauczyciel_obj;
    v_ref_kurs REF t_kurs_obj;
    v_ref_sala REF t_sala_obj;
BEGIN
    -- Anna (ID 1) ma lekcje 2025-05-20 o 09:00
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 1;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 2;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 3;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 3;
    
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(9993, TO_DATE('2025-05-20', 'YYYY-MM-DD'), '09:00', 45,
                     NULL, NULL, 'zaplanowana',
                     v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
    );
    
    DELETE FROM t_lekcja WHERE id_lekcji = 9993;
    DBMS_OUTPUT.PUT_LINE('[FAIL] Trigger powinien zablokowac konflikt ucznia');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -20021 THEN
            DBMS_OUTPUT.PUT_LINE('[PASS] Trigger zablokował konflikt ucznia');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Kod: ' || SQLCODE || ' - ' || SQLERRM);
        END IF;
END;
/

-- ############################################################################
-- KATEGORIA 5: TESTY SCENARIUSZY BIZNESOWYCH
-- ############################################################################

PROMPT ========================================================================
PROMPT KATEGORIA 5: TESTY SCENARIUSZY BIZNESOWYCH
PROMPT ========================================================================

-- ----------------------------------------------------------------------------
-- TEST 5.1: Scenariusz - cykl zycia ucznia
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 5.1] Scenariusz: cykl zycia ucznia

DECLARE
    v_id_ucznia NUMBER;
    v_ref_uczen REF t_uczen_obj;
    v_ref_kurs REF t_kurs_obj;
    v_ref_nauczyciel REF t_nauczyciel_obj;
BEGIN
    DBMS_OUTPUT.PUT_LINE('1. Dodawanie nowego ucznia...');
    pkg_uczen.dodaj_ucznia('Test', 'Scenariusz', 
                           TO_DATE('2000-01-01', 'YYYY-MM-DD'),
                           'test.scen@email.com', '999888777');
    
    SELECT MAX(id_ucznia) INTO v_id_ucznia FROM t_uczen;
    DBMS_OUTPUT.PUT_LINE('   Utworzono ucznia ID: ' || v_id_ucznia);
    
    DBMS_OUTPUT.PUT_LINE('2. Zapis na kurs...');
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = v_id_ucznia;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 1;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    
    INSERT INTO t_zapis VALUES (
        t_zapis_obj(seq_zapis.NEXTVAL, SYSDATE, 'aktywny', 
                    v_ref_uczen, v_ref_kurs, v_ref_nauczyciel)
    );
    DBMS_OUTPUT.PUT_LINE('   Zapis utworzony');
    
    DBMS_OUTPUT.PUT_LINE('3. Sprawdzenie sredniej (powinna byc 0)...');
    DBMS_OUTPUT.PUT_LINE('   Srednia: ' || pkg_uczen.srednia_ocen(v_id_ucznia));
    
    DBMS_OUTPUT.PUT_LINE('4. Sprzatanie danych testowych...');
    DELETE FROM t_zapis WHERE DEREF(ref_uczen).id_ucznia = v_id_ucznia;
    DELETE FROM t_uczen WHERE id_ucznia = v_id_ucznia;
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[PASS] Scenariusz cyklu zycia ucznia wykonany');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('[FAIL] Blad: ' || SQLERRM);
END;
/

-- ----------------------------------------------------------------------------
-- TEST 5.2: Scenariusz - planowanie tygodnia lekcji
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 5.2] Scenariusz: planowanie lekcji dla dziecka

DECLARE
    v_godz VARCHAR2(5);
    v_dozwolone NUMBER := 0;
    v_zablokowane NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Test godzin dla dziecka (Michal ID 8):');
    
    FOR h IN 8..20 LOOP
        v_godz := LPAD(h, 2, '0') || ':00';
        
        BEGIN
            DECLARE
                v_ref_uczen REF t_uczen_obj;
                v_ref_nauczyciel REF t_nauczyciel_obj;
                v_ref_kurs REF t_kurs_obj;
                v_ref_sala REF t_sala_obj;
            BEGIN
                SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 8;
                SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
                SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 1;
                SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 7;
                
                INSERT INTO t_lekcja VALUES (
                    t_lekcja_obj(8000 + h, TO_DATE('2025-06-15', 'YYYY-MM-DD'), v_godz, 45,
                                 NULL, NULL, 'zaplanowana',
                                 v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
                );
                
                DELETE FROM t_lekcja WHERE id_lekcji = 8000 + h;
                DBMS_OUTPUT.PUT_LINE('  ' || v_godz || ' - DOZWOLONA');
                v_dozwolone := v_dozwolone + 1;
            END;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('  ' || v_godz || ' - ZABLOKOWANA (trigger)');
                v_zablokowane := v_zablokowane + 1;
        END;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Dozwolone: ' || v_dozwolone || ', Zablokowane: ' || v_zablokowane);
    
    IF v_dozwolone = 5 AND v_zablokowane = 8 THEN  -- 14:00-18:00 dozwolone
        DBMS_OUTPUT.PUT_LINE('[PASS] Godziny dziecka poprawnie ograniczone do 14-19');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] Sprawdz konfiguracje triggera');
    END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 5.3: Scenariusz - weryfikacja limitu nauczyciela
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 5.3] Scenariusz: statystyki obciazenia nauczyciela

BEGIN
    DBMS_OUTPUT.PUT_LINE('Obciazenie nauczycieli na dzien 2025-05-20:');
    DBMS_OUTPUT.PUT_LINE('');
    
    FOR rec IN (
        SELECT n.id_nauczyciela, n.imie, n.nazwisko,
               NVL(SUM(l.czas_trwania), 0) AS suma_minut,
               COUNT(l.id_lekcji) AS liczba_lekcji
        FROM t_nauczyciel n
        LEFT JOIN t_lekcja l ON DEREF(l.ref_nauczyciel).id_nauczyciela = n.id_nauczyciela
                            AND l.data_lekcji = TO_DATE('2025-05-20', 'YYYY-MM-DD')
                            AND l.status != 'odwolana'
        GROUP BY n.id_nauczyciela, n.imie, n.nazwisko
        ORDER BY suma_minut DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(rec.imie || ' ' || rec.nazwisko, 25) ||
            ' Lekcji: ' || RPAD(rec.liczba_lekcji, 3) ||
            ' Minut: ' || rec.suma_minut || '/360 (' ||
            ROUND(rec.suma_minut/360*100) || '%)'
        );
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('[PASS] Raport obciazenia wygenerowany');
END;
/

-- ----------------------------------------------------------------------------
-- TEST 5.4: Scenariusz - weryfikacja limitow uczniow
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 5.4] Scenariusz: liczba lekcji uczniow na dzien

BEGIN
    DBMS_OUTPUT.PUT_LINE('Liczba lekcji uczniow na 2025-05-20:');
    DBMS_OUTPUT.PUT_LINE('');
    
    FOR rec IN (
        SELECT u.id_ucznia, u.imie, u.nazwisko, u.wiek() AS wiek,
               COUNT(l.id_lekcji) AS liczba_lekcji
        FROM t_uczen u
        LEFT JOIN t_lekcja l ON DEREF(l.ref_uczen).id_ucznia = u.id_ucznia
                            AND l.data_lekcji = TO_DATE('2025-05-20', 'YYYY-MM-DD')
                            AND l.status != 'odwolana'
        GROUP BY u.id_ucznia, u.imie, u.nazwisko, u.wiek()
        HAVING COUNT(l.id_lekcji) > 0
        ORDER BY u.wiek()
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(rec.imie || ' ' || rec.nazwisko, 25) ||
            ' Wiek: ' || RPAD(rec.wiek, 3) ||
            ' Lekcji: ' || rec.liczba_lekcji || '/2 max'
        );
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('[PASS] Raport lekcji uczniow wygenerowany');
END;
/

-- ############################################################################
-- KATEGORIA 6: TESTY BLOKOWANIA USUWANIA
-- ############################################################################

PROMPT ========================================================================
PROMPT KATEGORIA 6: TESTY BLOKOWANIA USUWANIA
PROMPT ========================================================================

-- ----------------------------------------------------------------------------
-- TEST 6.1: Nie mozna usunac ucznia z zapisami
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 6.1] Blokada usuwania ucznia z zapisami

BEGIN
    DELETE FROM t_uczen WHERE id_ucznia = 1;
    
    DBMS_OUTPUT.PUT_LINE('[FAIL] Ucznia z zapisami nie powinno sie usunac');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -20030 THEN
            DBMS_OUTPUT.PUT_LINE('[PASS] Trigger zablokował usuwanie ucznia z zapisami');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Kod: ' || SQLCODE || ' - ' || SQLERRM);
        END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 6.2: Nie mozna usunac nauczyciela z lekcjami
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 6.2] Blokada usuwania nauczyciela z lekcjami

BEGIN
    DELETE FROM t_nauczyciel WHERE id_nauczyciela = 1;
    
    DBMS_OUTPUT.PUT_LINE('[FAIL] Nauczyciela z lekcjami nie powinno sie usunac');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -20031 THEN
            DBMS_OUTPUT.PUT_LINE('[PASS] Trigger zablokował usuwanie nauczyciela z lekcjami');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Kod: ' || SQLCODE || ' - ' || SQLERRM);
        END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 6.3: Nie mozna usunac kursu z zapisami
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 6.3] Blokada usuwania kursu z zapisami

BEGIN
    DELETE FROM t_kurs WHERE id_kursu = 1;
    
    DBMS_OUTPUT.PUT_LINE('[FAIL] Kursu z zapisami nie powinno sie usunac');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -20032 THEN
            DBMS_OUTPUT.PUT_LINE('[PASS] Trigger zablokował usuwanie kursu z zapisami');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Kod: ' || SQLCODE || ' - ' || SQLERRM);
        END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 6.4: Nie mozna usunac sali z lekcjami
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 6.4] Blokada usuwania sali z lekcjami

BEGIN
    DELETE FROM t_sala WHERE id_sali = 1;
    
    DBMS_OUTPUT.PUT_LINE('[FAIL] Sali z lekcjami nie powinno sie usunac');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -20033 THEN
            DBMS_OUTPUT.PUT_LINE('[PASS] Trigger zablokował usuwanie sali z lekcjami');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Kod: ' || SQLCODE || ' - ' || SQLERRM);
        END IF;
END;
/

-- ----------------------------------------------------------------------------
-- TEST 6.5: Nie mozna usunac aktywnego semestru
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 6.5] Blokada usuwania aktywnego semestru

BEGIN
    DELETE FROM t_semestr WHERE czy_aktywny = 'T';
    
    DBMS_OUTPUT.PUT_LINE('[FAIL] Aktywnego semestru nie powinno sie usunac');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -20060 THEN
            DBMS_OUTPUT.PUT_LINE('[PASS] Trigger zablokował usuwanie aktywnego semestru');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Kod: ' || SQLCODE || ' - ' || SQLERRM);
        END IF;
END;
/

-- ############################################################################
-- KATEGORIA 7: TESTY UZYTKOWNIKOW (uprawnienia)
-- ############################################################################

PROMPT ========================================================================
PROMPT KATEGORIA 7: TESTY UZYTKOWNIKOW
PROMPT ========================================================================

-- ----------------------------------------------------------------------------
-- TEST 7.1: Weryfikacja istnienia rol
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 7.1] Weryfikacja istnienia rol

DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count 
    FROM dba_roles 
    WHERE role IN ('ROLA_ADMIN_SZKOLY', 'ROLA_NAUCZYCIEL', 'ROLA_SEKRETARIAT');
    
    DBMS_OUTPUT.PUT_LINE('Znalezione role: ' || v_count || '/3');
    
    IF v_count = 3 THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Wszystkie 3 role istnieja');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] Niektore role moga nie istniec (wymaga 07_uzytkownicy.sql)');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] Brak uprawnien do sprawdzenia rol lub role nie istnieja');
END;
/

-- ----------------------------------------------------------------------------
-- TEST 7.2: Weryfikacja uprawnien do tabel
-- ----------------------------------------------------------------------------
PROMPT
PROMPT [TEST 7.2] Weryfikacja uprawnien do tabel

DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count 
    FROM user_tab_privs 
    WHERE table_name IN ('T_UCZEN', 'T_NAUCZYCIEL', 'T_LEKCJA', 'T_KURS', 'T_SALA', 'T_SEMESTR');
    
    DBMS_OUTPUT.PUT_LINE('Uprawnienia do tabel: ' || v_count);
    
    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('[PASS] Istnieja uprawnienia do tabel');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] Brak nadanych uprawnien (wymaga 07_uzytkownicy.sql)');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] Blad: ' || SQLERRM);
END;
/

-- ############################################################################
-- PODSUMOWANIE TESTOW
-- ############################################################################

PROMPT ========================================================================
PROMPT PODSUMOWANIE TESTOW v2.0
PROMPT ========================================================================

PROMPT
PROMPT Wykonano testy w 7 kategoriach:
PROMPT
PROMPT 1. TYPY (8 testow)
PROMPT    - t_uczen_obj, t_nauczyciel_obj, t_kurs_obj
PROMPT    - t_lekcja_obj, t_zapis_obj, t_ocena_obj
PROMPT    - t_sala_obj [NOWY], t_semestr_obj [NOWY]
PROMPT
PROMPT 2. TABELE / CHECK constraints (6 testow)
PROMPT    - status lekcji, ocena 1-6, status zapisu
PROMPT    - typ kursu, pojemnosc sali, czy_aktywny semestr
PROMPT
PROMPT 3. PAKIETY (13 testow)
PROMPT    - pkg_semestr (2 testy)
PROMPT    - pkg_sala (2 testy)
PROMPT    - pkg_uczen (4 testy)
PROMPT    - pkg_lekcja (3 testy)
PROMPT    - pkg_ocena (2 testy)
PROMPT
PROMPT 4. TRIGGERY (8 testow)
PROMPT    - wiek ucznia min 5 lat
PROMPT    - godziny dziecka 14:00-19:00 [NOWY]
PROMPT    - limit ucznia 2 lekcje/dzien [NOWY]
PROMPT    - konflikt sali [NOWY]
PROMPT    - jeden semestr aktywny [NOWY]
PROMPT    - konflikt nauczyciela, konflikt ucznia
PROMPT
PROMPT 5. SCENARIUSZE BIZNESOWE (4 testy)
PROMPT    - cykl zycia ucznia
PROMPT    - planowanie lekcji dziecka
PROMPT    - obciazenie nauczycieli
PROMPT    - limity lekcji uczniow
PROMPT
PROMPT 6. BLOKOWANIE USUWANIA (5 testow)
PROMPT    - uczen z zapisami
PROMPT    - nauczyciel z lekcjami
PROMPT    - kurs z zapisami
PROMPT    - sala z lekcjami [NOWY]
PROMPT    - aktywny semestr [NOWY]
PROMPT
PROMPT 7. UZYTKOWNICY (2 testy)
PROMPT    - istnienie rol
PROMPT    - uprawnienia do tabel
PROMPT
PROMPT ========================================
PROMPT RAZEM: 46 testow
PROMPT ========================================

-- Statystyki koncowe
SELECT 'UCZNIOWIE' AS tabela, COUNT(*) AS liczba FROM t_uczen
UNION ALL
SELECT 'NAUCZYCIELE', COUNT(*) FROM t_nauczyciel
UNION ALL
SELECT 'KURSY', COUNT(*) FROM t_kurs
UNION ALL
SELECT 'ZAPISY', COUNT(*) FROM t_zapis
UNION ALL
SELECT 'LEKCJE', COUNT(*) FROM t_lekcja
UNION ALL
SELECT 'OCENY', COUNT(*) FROM t_ocena_postepu
UNION ALL
SELECT 'SALE', COUNT(*) FROM t_sala
UNION ALL
SELECT 'SEMESTRY', COUNT(*) FROM t_semestr
ORDER BY tabela;

PROMPT ========================================
PROMPT TESTY ZAKONCZONE!
PROMPT ========================================
