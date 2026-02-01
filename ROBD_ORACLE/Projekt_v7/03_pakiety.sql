-- ============================================================================
-- Projekt: Szkola Muzyczna - Obiektowa Baza Danych (UPROSZCZONA)
-- Plik: 03_pakiety.sql
-- Opis: Pakiety PL/SQL z procedurami i funkcjami
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- Wersja: 7.0
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- ============================================================================
-- 1. USUNIECIE ISTNIEJACYCH PAKIETOW
-- ============================================================================

BEGIN EXECUTE IMMEDIATE 'DROP PACKAGE PKG_SLOWNIKI'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP PACKAGE PKG_OSOBY'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP PACKAGE PKG_LEKCJE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP PACKAGE PKG_OCENY'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP PACKAGE PKG_RAPORTY'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ============================================================================
-- 2. PAKIET PKG_SLOWNIKI - Zarzadzanie danymi slownikowymi
-- ============================================================================

CREATE OR REPLACE PACKAGE PKG_SLOWNIKI AS
    -- Dodawanie
    PROCEDURE dodaj_przedmiot(p_nazwa VARCHAR2, p_typ VARCHAR2, p_czas NUMBER DEFAULT 45);
    PROCEDURE dodaj_sale(p_numer VARCHAR2, p_typ VARCHAR2, p_pojemnosc NUMBER, p_wyposazenie T_WYPOSAZENIE);
    PROCEDURE dodaj_grupe(p_kod VARCHAR2, p_klasa NUMBER, p_rok VARCHAR2 DEFAULT '2025/2026');
    
    -- Pobieranie REF
    FUNCTION get_ref_przedmiot(p_nazwa VARCHAR2) RETURN REF T_PRZEDMIOT;
    FUNCTION get_ref_sala(p_numer VARCHAR2) RETURN REF T_SALA;
    FUNCTION get_ref_grupa(p_kod VARCHAR2) RETURN REF T_GRUPA;
    
    -- Pobieranie ID
    FUNCTION get_id_przedmiot(p_nazwa VARCHAR2) RETURN NUMBER;
    FUNCTION get_id_sala(p_numer VARCHAR2) RETURN NUMBER;
    FUNCTION get_id_grupa(p_kod VARCHAR2) RETURN NUMBER;
END PKG_SLOWNIKI;
/

CREATE OR REPLACE PACKAGE BODY PKG_SLOWNIKI AS

    PROCEDURE dodaj_przedmiot(p_nazwa VARCHAR2, p_typ VARCHAR2, p_czas NUMBER DEFAULT 45) IS
    BEGIN
        INSERT INTO PRZEDMIOTY VALUES (
            T_PRZEDMIOT(seq_przedmioty.NEXTVAL, p_nazwa, p_typ, p_czas)
        );
        DBMS_OUTPUT.PUT_LINE('Dodano przedmiot: ' || p_nazwa);
    END;

    PROCEDURE dodaj_sale(p_numer VARCHAR2, p_typ VARCHAR2, p_pojemnosc NUMBER, p_wyposazenie T_WYPOSAZENIE) IS
    BEGIN
        INSERT INTO SALE VALUES (
            T_SALA(seq_sale.NEXTVAL, p_numer, p_typ, p_pojemnosc, p_wyposazenie)
        );
        DBMS_OUTPUT.PUT_LINE('Dodano sale: ' || p_numer || ' (typ: ' || p_typ || ')');
    END;

    PROCEDURE dodaj_grupe(p_kod VARCHAR2, p_klasa NUMBER, p_rok VARCHAR2 DEFAULT '2025/2026') IS
    BEGIN
        INSERT INTO GRUPY VALUES (
            T_GRUPA(seq_grupy.NEXTVAL, p_kod, p_klasa, p_rok)
        );
        DBMS_OUTPUT.PUT_LINE('Dodano grupe: ' || p_kod || ' (klasa ' || p_klasa || ')');
    END;

    FUNCTION get_ref_przedmiot(p_nazwa VARCHAR2) RETURN REF T_PRZEDMIOT IS
        v_ref REF T_PRZEDMIOT;
    BEGIN
        SELECT REF(p) INTO v_ref FROM PRZEDMIOTY p WHERE UPPER(p.nazwa) = UPPER(p_nazwa);
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Przedmiot nie znaleziony: ' || p_nazwa);
    END;

    FUNCTION get_ref_sala(p_numer VARCHAR2) RETURN REF T_SALA IS
        v_ref REF T_SALA;
    BEGIN
        SELECT REF(s) INTO v_ref FROM SALE s WHERE s.numer = p_numer;
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'Sala nie znaleziona: ' || p_numer);
    END;

    FUNCTION get_ref_grupa(p_kod VARCHAR2) RETURN REF T_GRUPA IS
        v_ref REF T_GRUPA;
    BEGIN
        SELECT REF(g) INTO v_ref FROM GRUPY g WHERE UPPER(g.kod) = UPPER(p_kod);
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20003, 'Grupa nie znaleziona: ' || p_kod);
    END;

    FUNCTION get_id_przedmiot(p_nazwa VARCHAR2) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT id_przedmiotu INTO v_id FROM PRZEDMIOTY WHERE UPPER(nazwa) = UPPER(p_nazwa);
        RETURN v_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Przedmiot nie znaleziony: ' || p_nazwa);
    END;

    FUNCTION get_id_sala(p_numer VARCHAR2) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT id_sali INTO v_id FROM SALE WHERE numer = p_numer;
        RETURN v_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'Sala nie znaleziona: ' || p_numer);
    END;

    FUNCTION get_id_grupa(p_kod VARCHAR2) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT id_grupy INTO v_id FROM GRUPY WHERE UPPER(kod) = UPPER(p_kod);
        RETURN v_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20003, 'Grupa nie znaleziona: ' || p_kod);
    END;

END PKG_SLOWNIKI;
/

-- ============================================================================
-- 3. PAKIET PKG_OSOBY - Zarzadzanie nauczycielami i uczniami
-- ============================================================================

CREATE OR REPLACE PACKAGE PKG_OSOBY AS
    -- Dodawanie
    PROCEDURE dodaj_nauczyciela(p_imie VARCHAR2, p_nazwisko VARCHAR2, p_instrument VARCHAR2 DEFAULT NULL, p_email VARCHAR2 DEFAULT NULL);
    PROCEDURE dodaj_ucznia(p_imie VARCHAR2, p_nazwisko VARCHAR2, p_data_ur DATE, p_kod_grupy VARCHAR2, p_instrument VARCHAR2);
    
    -- Pobieranie REF
    FUNCTION get_ref_nauczyciel(p_nazwisko VARCHAR2) RETURN REF T_NAUCZYCIEL;
    FUNCTION get_ref_uczen(p_nazwisko VARCHAR2, p_imie VARCHAR2) RETURN REF T_UCZEN;
    
    -- Pobieranie danych
    FUNCTION get_id_nauczyciel(p_nazwisko VARCHAR2) RETURN NUMBER;
    FUNCTION get_id_uczen(p_nazwisko VARCHAR2, p_imie VARCHAR2) RETURN NUMBER;
    FUNCTION get_instrument_ucznia(p_id_ucznia NUMBER) RETURN VARCHAR2;
    FUNCTION get_grupa_ucznia(p_id_ucznia NUMBER) RETURN VARCHAR2;
    
    -- Wyswietlanie
    PROCEDURE lista_uczniow_w_grupie(p_kod_grupy VARCHAR2);
    PROCEDURE lista_uczniow_nauczyciela(p_nazwisko VARCHAR2);
END PKG_OSOBY;
/

CREATE OR REPLACE PACKAGE BODY PKG_OSOBY AS

    PROCEDURE dodaj_nauczyciela(p_imie VARCHAR2, p_nazwisko VARCHAR2, p_instrument VARCHAR2 DEFAULT NULL, p_email VARCHAR2 DEFAULT NULL) IS
    BEGIN
        INSERT INTO NAUCZYCIELE VALUES (
            T_NAUCZYCIEL(seq_nauczyciele.NEXTVAL, p_imie, p_nazwisko, p_instrument, p_email)
        );
        DBMS_OUTPUT.PUT_LINE('Dodano nauczyciela: ' || p_imie || ' ' || p_nazwisko || 
            CASE WHEN p_instrument IS NOT NULL THEN ' (instrument: ' || p_instrument || ')' ELSE ' (przedmioty grupowe)' END);
    END;

    PROCEDURE dodaj_ucznia(p_imie VARCHAR2, p_nazwisko VARCHAR2, p_data_ur DATE, p_kod_grupy VARCHAR2, p_instrument VARCHAR2) IS
        v_ref_grupa REF T_GRUPA;
    BEGIN
        v_ref_grupa := PKG_SLOWNIKI.get_ref_grupa(p_kod_grupy);
        
        INSERT INTO UCZNIOWIE VALUES (
            T_UCZEN(seq_uczniowie.NEXTVAL, p_imie, p_nazwisko, p_data_ur, p_instrument, v_ref_grupa, SYSDATE)
        );
        DBMS_OUTPUT.PUT_LINE('Dodano ucznia: ' || p_imie || ' ' || p_nazwisko || 
            ' (grupa ' || p_kod_grupy || ', instrument: ' || p_instrument || ')');
    END;

    FUNCTION get_ref_nauczyciel(p_nazwisko VARCHAR2) RETURN REF T_NAUCZYCIEL IS
        v_ref REF T_NAUCZYCIEL;
    BEGIN
        SELECT REF(n) INTO v_ref FROM NAUCZYCIELE n WHERE UPPER(n.nazwisko) = UPPER(p_nazwisko);
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20004, 'Nauczyciel nie znaleziony: ' || p_nazwisko);
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20005, 'Wielu nauczycieli o nazwisku: ' || p_nazwisko);
    END;

    FUNCTION get_ref_uczen(p_nazwisko VARCHAR2, p_imie VARCHAR2) RETURN REF T_UCZEN IS
        v_ref REF T_UCZEN;
    BEGIN
        SELECT REF(u) INTO v_ref FROM UCZNIOWIE u 
        WHERE UPPER(u.nazwisko) = UPPER(p_nazwisko) AND UPPER(u.imie) = UPPER(p_imie);
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20006, 'Uczen nie znaleziony: ' || p_imie || ' ' || p_nazwisko);
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20007, 'Wielu uczniow: ' || p_imie || ' ' || p_nazwisko);
    END;

    FUNCTION get_id_nauczyciel(p_nazwisko VARCHAR2) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT id_nauczyciela INTO v_id FROM NAUCZYCIELE WHERE UPPER(nazwisko) = UPPER(p_nazwisko);
        RETURN v_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20004, 'Nauczyciel nie znaleziony: ' || p_nazwisko);
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20005, 'Wielu nauczycieli o nazwisku: ' || p_nazwisko);
    END;

    FUNCTION get_id_uczen(p_nazwisko VARCHAR2, p_imie VARCHAR2) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT id_ucznia INTO v_id FROM UCZNIOWIE 
        WHERE UPPER(nazwisko) = UPPER(p_nazwisko) AND UPPER(imie) = UPPER(p_imie);
        RETURN v_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20006, 'Uczen nie znaleziony: ' || p_imie || ' ' || p_nazwisko);
    END;

    FUNCTION get_instrument_ucznia(p_id_ucznia NUMBER) RETURN VARCHAR2 IS
        v_instrument VARCHAR2(50);
    BEGIN
        SELECT instrument INTO v_instrument FROM UCZNIOWIE WHERE id_ucznia = p_id_ucznia;
        RETURN v_instrument;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN NULL;
    END;

    FUNCTION get_grupa_ucznia(p_id_ucznia NUMBER) RETURN VARCHAR2 IS
        v_kod VARCHAR2(10);
    BEGIN
        SELECT DEREF(u.ref_grupa).kod INTO v_kod FROM UCZNIOWIE u WHERE u.id_ucznia = p_id_ucznia;
        RETURN v_kod;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN NULL;
    END;

    PROCEDURE lista_uczniow_w_grupie(p_kod_grupy VARCHAR2) IS
        CURSOR c_uczniowie IS
            SELECT u.id_ucznia, u.imie, u.nazwisko, u.instrument
            FROM UCZNIOWIE u
            WHERE UPPER(DEREF(u.ref_grupa).kod) = UPPER(p_kod_grupy)
            ORDER BY u.nazwisko, u.imie;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== UCZNIOWIE GRUPY ' || UPPER(p_kod_grupy) || ' ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('ID', 5) || RPAD('Imie', 15) || RPAD('Nazwisko', 20) || 'Instrument');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 60, '-'));
        
        FOR rec IN c_uczniowie LOOP
            DBMS_OUTPUT.PUT_LINE(RPAD(rec.id_ucznia, 5) || RPAD(rec.imie, 15) || RPAD(rec.nazwisko, 20) || rec.instrument);
        END LOOP;
    END;

    PROCEDURE lista_uczniow_nauczyciela(p_nazwisko VARCHAR2) IS
        v_instrument VARCHAR2(50);
        CURSOR c_uczniowie(p_instr VARCHAR2) IS
            SELECT u.id_ucznia, u.imie, u.nazwisko, DEREF(u.ref_grupa).kod AS grupa
            FROM UCZNIOWIE u
            WHERE UPPER(u.instrument) = UPPER(p_instr)
            ORDER BY DEREF(u.ref_grupa).klasa, u.nazwisko;
    BEGIN
        SELECT instrument INTO v_instrument FROM NAUCZYCIELE WHERE UPPER(nazwisko) = UPPER(p_nazwisko);
        
        IF v_instrument IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Nauczyciel ' || p_nazwisko || ' uczy przedmiotow grupowych - nie ma przypisanych uczniow indywidualnych.');
            RETURN;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== UCZNIOWIE NAUCZYCIELA ' || UPPER(p_nazwisko) || ' (' || v_instrument || ') ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('ID', 5) || RPAD('Imie', 15) || RPAD('Nazwisko', 20) || 'Grupa');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 50, '-'));
        
        FOR rec IN c_uczniowie(v_instrument) LOOP
            DBMS_OUTPUT.PUT_LINE(RPAD(rec.id_ucznia, 5) || RPAD(rec.imie, 15) || RPAD(rec.nazwisko, 20) || rec.grupa);
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20004, 'Nauczyciel nie znaleziony: ' || p_nazwisko);
    END;

END PKG_OSOBY;
/

-- ============================================================================
-- 4. PAKIET PKG_LEKCJE - Zarzadzanie lekcjami i planowaniem
-- ============================================================================

CREATE OR REPLACE PACKAGE PKG_LEKCJE AS
    -- Sprawdzanie dostepnosci
    FUNCTION czy_sala_wolna(p_id_sali NUMBER, p_data DATE, p_godzina VARCHAR2, p_czas NUMBER) RETURN BOOLEAN;
    FUNCTION czy_nauczyciel_wolny(p_id_naucz NUMBER, p_data DATE, p_godzina VARCHAR2, p_czas NUMBER) RETURN BOOLEAN;
    FUNCTION czy_uczen_wolny(p_id_ucznia NUMBER, p_data DATE, p_godzina VARCHAR2, p_czas NUMBER) RETURN BOOLEAN;
    
    -- Dodawanie lekcji (reczne)
    PROCEDURE dodaj_lekcje_indywidualna(p_przedmiot VARCHAR2, p_nauczyciel VARCHAR2, p_sala VARCHAR2, 
                                         p_uczen_nazwisko VARCHAR2, p_uczen_imie VARCHAR2,
                                         p_data DATE, p_godzina VARCHAR2, p_czas NUMBER DEFAULT 45);
    PROCEDURE dodaj_lekcje_grupowa(p_przedmiot VARCHAR2, p_nauczyciel VARCHAR2, p_sala VARCHAR2,
                                    p_kod_grupy VARCHAR2, p_data DATE, p_godzina VARCHAR2, p_czas NUMBER DEFAULT 45);
    
    -- HEURYSTYKA
    FUNCTION znajdz_nauczyciela(p_instrument VARCHAR2, p_data DATE, p_godzina VARCHAR2, p_czas NUMBER) RETURN VARCHAR2;
    FUNCTION znajdz_sale(p_typ VARCHAR2, p_data DATE, p_godzina VARCHAR2, p_czas NUMBER) RETURN VARCHAR2;
    PROCEDURE przydziel_lekcje_uczniowi(p_nazwisko VARCHAR2, p_imie VARCHAR2, p_data_poczatek DATE);
    PROCEDURE generuj_plan_tygodnia(p_data_poniedzialek DATE);
    
    -- Wyswietlanie planow
    PROCEDURE plan_ucznia(p_nazwisko VARCHAR2, p_imie VARCHAR2);
    PROCEDURE plan_nauczyciela(p_nazwisko VARCHAR2);
    PROCEDURE plan_grupy(p_kod_grupy VARCHAR2);
    PROCEDURE plan_sali(p_numer VARCHAR2, p_data DATE);
END PKG_LEKCJE;
/

CREATE OR REPLACE PACKAGE BODY PKG_LEKCJE AS

    -- Pomocnicza: konwersja godziny na minuty
    FUNCTION godz_na_min(p_godz VARCHAR2) RETURN NUMBER IS
    BEGIN
        RETURN TO_NUMBER(SUBSTR(p_godz, 1, 2)) * 60 + TO_NUMBER(SUBSTR(p_godz, 4, 2));
    END;

    -- ========== SPRAWDZANIE DOSTEPNOSCI ==========

    FUNCTION czy_sala_wolna(p_id_sali NUMBER, p_data DATE, p_godzina VARCHAR2, p_czas NUMBER) RETURN BOOLEAN IS
        v_start NUMBER := godz_na_min(p_godzina);
        v_koniec NUMBER := v_start + p_czas;
        v_lek_start NUMBER;
        v_lek_koniec NUMBER;
    BEGIN
        FOR lek IN (
            SELECT l.godzina_start, l.czas_trwania_min
            FROM LEKCJE l
            WHERE DEREF(l.ref_sala).id_sali = p_id_sali
              AND l.data_lekcji = p_data
        ) LOOP
            v_lek_start := godz_na_min(lek.godzina_start);
            v_lek_koniec := v_lek_start + lek.czas_trwania_min;
            
            IF v_lek_start < v_koniec AND v_start < v_lek_koniec THEN
                RETURN FALSE;
            END IF;
        END LOOP;
        
        RETURN TRUE;
    END;

    FUNCTION czy_nauczyciel_wolny(p_id_naucz NUMBER, p_data DATE, p_godzina VARCHAR2, p_czas NUMBER) RETURN BOOLEAN IS
        v_start NUMBER := godz_na_min(p_godzina);
        v_koniec NUMBER := v_start + p_czas;
        v_lek_start NUMBER;
        v_lek_koniec NUMBER;
    BEGIN
        FOR lek IN (
            SELECT l.godzina_start, l.czas_trwania_min
            FROM LEKCJE l
            WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = p_id_naucz
              AND l.data_lekcji = p_data
        ) LOOP
            v_lek_start := godz_na_min(lek.godzina_start);
            v_lek_koniec := v_lek_start + lek.czas_trwania_min;
            
            IF v_lek_start < v_koniec AND v_start < v_lek_koniec THEN
                RETURN FALSE;
            END IF;
        END LOOP;
        
        RETURN TRUE;
    END;

    FUNCTION czy_uczen_wolny(p_id_ucznia NUMBER, p_data DATE, p_godzina VARCHAR2, p_czas NUMBER) RETURN BOOLEAN IS
        v_start NUMBER := godz_na_min(p_godzina);
        v_koniec NUMBER := v_start + p_czas;
        v_kod_grupy VARCHAR2(10);
        v_lek_start NUMBER;
        v_lek_koniec NUMBER;
    BEGIN
        v_kod_grupy := PKG_OSOBY.get_grupa_ucznia(p_id_ucznia);
        
        -- Sprawdz lekcje indywidualne
        FOR lek IN (
            SELECT l.godzina_start, l.czas_trwania_min
            FROM LEKCJE l
            WHERE l.ref_uczen IS NOT NULL
              AND DEREF(l.ref_uczen).id_ucznia = p_id_ucznia
              AND l.data_lekcji = p_data
        ) LOOP
            v_lek_start := godz_na_min(lek.godzina_start);
            v_lek_koniec := v_lek_start + lek.czas_trwania_min;
            
            IF v_lek_start < v_koniec AND v_start < v_lek_koniec THEN
                RETURN FALSE;
            END IF;
        END LOOP;
        
        -- Sprawdz lekcje grupowe
        FOR lek IN (
            SELECT l.godzina_start, l.czas_trwania_min
            FROM LEKCJE l
            WHERE l.ref_grupa IS NOT NULL
              AND UPPER(DEREF(l.ref_grupa).kod) = UPPER(v_kod_grupy)
              AND l.data_lekcji = p_data
        ) LOOP
            v_lek_start := godz_na_min(lek.godzina_start);
            v_lek_koniec := v_lek_start + lek.czas_trwania_min;
            
            IF v_lek_start < v_koniec AND v_start < v_lek_koniec THEN
                RETURN FALSE;
            END IF;
        END LOOP;
        
        RETURN TRUE;
    END;

    -- ========== DODAWANIE LEKCJI ==========

    PROCEDURE dodaj_lekcje_indywidualna(p_przedmiot VARCHAR2, p_nauczyciel VARCHAR2, p_sala VARCHAR2,
                                         p_uczen_nazwisko VARCHAR2, p_uczen_imie VARCHAR2,
                                         p_data DATE, p_godzina VARCHAR2, p_czas NUMBER DEFAULT 45) IS
        v_id_sali NUMBER;
        v_id_naucz NUMBER;
        v_id_ucznia NUMBER;
    BEGIN
        -- Walidacja godzin pracy
        IF godz_na_min(p_godzina) < godz_na_min('14:00') THEN
            RAISE_APPLICATION_ERROR(-20101, 'Lekcje nie moga zaczynac sie przed 14:00');
        END IF;
        IF godz_na_min(p_godzina) + p_czas > godz_na_min('20:00') THEN
            RAISE_APPLICATION_ERROR(-20102, 'Lekcje nie moga konczyc sie po 20:00');
        END IF;
        
        v_id_sali := PKG_SLOWNIKI.get_id_sala(p_sala);
        v_id_naucz := PKG_OSOBY.get_id_nauczyciel(p_nauczyciel);
        v_id_ucznia := PKG_OSOBY.get_id_uczen(p_uczen_nazwisko, p_uczen_imie);
        
        IF NOT czy_sala_wolna(v_id_sali, p_data, p_godzina, p_czas) THEN
            RAISE_APPLICATION_ERROR(-20010, 'Sala ' || p_sala || ' zajeta w tym terminie');
        END IF;
        IF NOT czy_nauczyciel_wolny(v_id_naucz, p_data, p_godzina, p_czas) THEN
            RAISE_APPLICATION_ERROR(-20011, 'Nauczyciel ' || p_nauczyciel || ' zajety w tym terminie');
        END IF;
        IF NOT czy_uczen_wolny(v_id_ucznia, p_data, p_godzina, p_czas) THEN
            RAISE_APPLICATION_ERROR(-20012, 'Uczen ' || p_uczen_imie || ' ' || p_uczen_nazwisko || ' zajety w tym terminie');
        END IF;
        
        INSERT INTO LEKCJE VALUES (
            T_LEKCJA(
                seq_lekcje.NEXTVAL,
                PKG_SLOWNIKI.get_ref_przedmiot(p_przedmiot),
                PKG_OSOBY.get_ref_nauczyciel(p_nauczyciel),
                PKG_SLOWNIKI.get_ref_sala(p_sala),
                PKG_OSOBY.get_ref_uczen(p_uczen_nazwisko, p_uczen_imie),
                NULL,
                p_data, p_godzina, p_czas
            )
        );
        DBMS_OUTPUT.PUT_LINE('Dodano lekcje: ' || p_przedmiot || ' dla ' || p_uczen_imie || ' ' || p_uczen_nazwisko ||
            ' (' || TO_CHAR(p_data, 'YYYY-MM-DD') || ' ' || p_godzina || ')');
    END;

    PROCEDURE dodaj_lekcje_grupowa(p_przedmiot VARCHAR2, p_nauczyciel VARCHAR2, p_sala VARCHAR2,
                                    p_kod_grupy VARCHAR2, p_data DATE, p_godzina VARCHAR2, p_czas NUMBER DEFAULT 45) IS
        v_id_sali NUMBER;
        v_id_naucz NUMBER;
    BEGIN
        IF godz_na_min(p_godzina) < godz_na_min('14:00') THEN
            RAISE_APPLICATION_ERROR(-20101, 'Lekcje nie moga zaczynac sie przed 14:00');
        END IF;
        IF godz_na_min(p_godzina) + p_czas > godz_na_min('20:00') THEN
            RAISE_APPLICATION_ERROR(-20102, 'Lekcje nie moga konczyc sie po 20:00');
        END IF;
        
        v_id_sali := PKG_SLOWNIKI.get_id_sala(p_sala);
        v_id_naucz := PKG_OSOBY.get_id_nauczyciel(p_nauczyciel);
        
        IF NOT czy_sala_wolna(v_id_sali, p_data, p_godzina, p_czas) THEN
            RAISE_APPLICATION_ERROR(-20010, 'Sala ' || p_sala || ' zajeta w tym terminie');
        END IF;
        IF NOT czy_nauczyciel_wolny(v_id_naucz, p_data, p_godzina, p_czas) THEN
            RAISE_APPLICATION_ERROR(-20011, 'Nauczyciel ' || p_nauczyciel || ' zajety w tym terminie');
        END IF;
        
        INSERT INTO LEKCJE VALUES (
            T_LEKCJA(
                seq_lekcje.NEXTVAL,
                PKG_SLOWNIKI.get_ref_przedmiot(p_przedmiot),
                PKG_OSOBY.get_ref_nauczyciel(p_nauczyciel),
                PKG_SLOWNIKI.get_ref_sala(p_sala),
                NULL,
                PKG_SLOWNIKI.get_ref_grupa(p_kod_grupy),
                p_data, p_godzina, p_czas
            )
        );
        DBMS_OUTPUT.PUT_LINE('Dodano lekcje grupowa: ' || p_przedmiot || ' dla grupy ' || p_kod_grupy ||
            ' (' || TO_CHAR(p_data, 'YYYY-MM-DD') || ' ' || p_godzina || ')');
    END;

    -- ========== HEURYSTYKA ==========

    FUNCTION znajdz_nauczyciela(p_instrument VARCHAR2, p_data DATE, p_godzina VARCHAR2, p_czas NUMBER) RETURN VARCHAR2 IS
        v_nazwisko VARCHAR2(100);
    BEGIN
        FOR naucz IN (SELECT id_nauczyciela, nazwisko FROM NAUCZYCIELE WHERE UPPER(instrument) = UPPER(p_instrument)) LOOP
            IF czy_nauczyciel_wolny(naucz.id_nauczyciela, p_data, p_godzina, p_czas) THEN
                RETURN naucz.nazwisko;
            END IF;
        END LOOP;
        RETURN NULL;
    END;

    FUNCTION znajdz_sale(p_typ VARCHAR2, p_data DATE, p_godzina VARCHAR2, p_czas NUMBER) RETURN VARCHAR2 IS
        v_numer VARCHAR2(10);
    BEGIN
        FOR sala IN (SELECT id_sali, numer FROM SALE WHERE typ = p_typ) LOOP
            IF czy_sala_wolna(sala.id_sali, p_data, p_godzina, p_czas) THEN
                RETURN sala.numer;
            END IF;
        END LOOP;
        RETURN NULL;
    END;

    PROCEDURE przydziel_lekcje_uczniowi(p_nazwisko VARCHAR2, p_imie VARCHAR2, p_data_poczatek DATE) IS
        v_id_ucznia NUMBER;
        v_instrument VARCHAR2(50);
        v_nauczyciel VARCHAR2(100);
        v_sala VARCHAR2(10);
        v_przydzielono NUMBER := 0;
        v_dzien DATE;
        v_godzina VARCHAR2(5);
        
        TYPE t_godziny IS TABLE OF VARCHAR2(5);
        v_godziny t_godziny := t_godziny('14:00','14:45','15:30','16:15','17:00','17:45','18:30','19:15');
    BEGIN
        v_id_ucznia := PKG_OSOBY.get_id_uczen(p_nazwisko, p_imie);
        v_instrument := PKG_OSOBY.get_instrument_ucznia(v_id_ucznia);
        
        DBMS_OUTPUT.PUT_LINE('Przydzielanie lekcji dla: ' || p_imie || ' ' || p_nazwisko || ' (instrument: ' || v_instrument || ')');
        
        -- Szukamy 2 slotow w roznych dniach
        FOR dzien_offset IN 0..4 LOOP  -- pon-pt
            EXIT WHEN v_przydzielono >= 2;
            v_dzien := p_data_poczatek + dzien_offset;
            
            FOR i IN 1..v_godziny.COUNT LOOP
                EXIT WHEN v_przydzielono >= 2;
                v_godzina := v_godziny(i);
                
                -- Szukaj nauczyciela
                v_nauczyciel := znajdz_nauczyciela(v_instrument, v_dzien, v_godzina, 45);
                IF v_nauczyciel IS NULL THEN CONTINUE; END IF;
                
                -- Szukaj sali
                v_sala := znajdz_sale('indywidualna', v_dzien, v_godzina, 45);
                IF v_sala IS NULL THEN CONTINUE; END IF;
                
                -- Sprawdz ucznia
                IF NOT czy_uczen_wolny(v_id_ucznia, v_dzien, v_godzina, 45) THEN CONTINUE; END IF;
                
                -- Wszystko OK - dodaj lekcje
                BEGIN
                    dodaj_lekcje_indywidualna(v_instrument, v_nauczyciel, v_sala, p_nazwisko, p_imie, v_dzien, v_godzina, 45);
                    v_przydzielono := v_przydzielono + 1;
                    EXIT; -- Przejdz do nastepnego dnia
                EXCEPTION
                    WHEN OTHERS THEN NULL;
                END;
            END LOOP;
        END LOOP;
        
        IF v_przydzielono < 2 THEN
            DBMS_OUTPUT.PUT_LINE('UWAGA: Przydzielono tylko ' || v_przydzielono || ' lekcji (wymagane 2)');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Przydzielono ' || v_przydzielono || ' lekcji dla ucznia');
        END IF;
    END;

    PROCEDURE generuj_plan_tygodnia(p_data_poniedzialek DATE) IS
        v_nauczyciel_grupowy VARCHAR2(100);
        v_dzien DATE;
        v_nr_grupy NUMBER := 0;
        
        TYPE t_godziny IS TABLE OF VARCHAR2(5);
        v_godziny_grupowe t_godziny := t_godziny('14:00','15:00','16:00','17:00','18:00');
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('========================================');
        DBMS_OUTPUT.PUT_LINE('GENEROWANIE PLANU TYGODNIA');
        DBMS_OUTPUT.PUT_LINE('Od: ' || TO_CHAR(p_data_poniedzialek, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('========================================');
        
        -- KROK 1: Lekcje grupowe (ksztalcenie sluchu)
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('--- KROK 1: Lekcje grupowe ---');
        
        -- Znajdz nauczyciela przedmiotow grupowych
        BEGIN
            SELECT nazwisko INTO v_nauczyciel_grupowy FROM NAUCZYCIELE WHERE instrument IS NULL AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- Uzyj pierwszego nauczyciela ktory uczy ksztalcenia sluchu (Kowalska lub Lewandowski)
                SELECT nazwisko INTO v_nauczyciel_grupowy FROM NAUCZYCIELE WHERE ROWNUM = 1;
        END;
        
        FOR grupa IN (SELECT kod, klasa FROM GRUPY ORDER BY klasa) LOOP
            v_nr_grupy := v_nr_grupy + 1;
            v_dzien := p_data_poniedzialek + MOD(v_nr_grupy - 1, 5);
            
            BEGIN
                dodaj_lekcje_grupowa('Ksztalcenie sluchu', v_nauczyciel_grupowy, '201', 
                                      grupa.kod, v_dzien, v_godziny_grupowe(MOD(v_nr_grupy - 1, 5) + 1), 45);
            EXCEPTION
                WHEN OTHERS THEN 
                    DBMS_OUTPUT.PUT_LINE('Blad przy grupie ' || grupa.kod || ': ' || SQLERRM);
            END;
        END LOOP;
        
        -- KROK 2: Lekcje indywidualne
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('--- KROK 2: Lekcje indywidualne ---');
        
        FOR uczen IN (SELECT imie, nazwisko FROM UCZNIOWIE ORDER BY DEREF(ref_grupa).klasa, nazwisko) LOOP
            BEGIN
                przydziel_lekcje_uczniowi(uczen.nazwisko, uczen.imie, p_data_poniedzialek);
            EXCEPTION
                WHEN OTHERS THEN 
                    DBMS_OUTPUT.PUT_LINE('Blad przy uczniu ' || uczen.imie || ' ' || uczen.nazwisko || ': ' || SQLERRM);
            END;
        END LOOP;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('PLAN WYGENEROWANY');
        DBMS_OUTPUT.PUT_LINE('========================================');
    END;

    -- ========== WYSWIETLANIE PLANOW ==========

    PROCEDURE plan_ucznia(p_nazwisko VARCHAR2, p_imie VARCHAR2) IS
        v_id_ucznia NUMBER;
        v_kod_grupy VARCHAR2(10);
    BEGIN
        v_id_ucznia := PKG_OSOBY.get_id_uczen(p_nazwisko, p_imie);
        v_kod_grupy := PKG_OSOBY.get_grupa_ucznia(v_id_ucznia);
        
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== PLAN UCZNIA: ' || p_imie || ' ' || p_nazwisko || ' (grupa ' || v_kod_grupy || ') ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('Data', 12) || RPAD('Godzina', 10) || RPAD('Przedmiot', 25) || RPAD('Nauczyciel', 15) || 'Sala');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 75, '-'));
        
        FOR lek IN (
            SELECT l.data_lekcji, l.godzina_start, l.czas_trwania_min,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
                   DEREF(l.ref_sala).numer AS sala
            FROM LEKCJE l
            WHERE (l.ref_uczen IS NOT NULL AND DEREF(l.ref_uczen).id_ucznia = v_id_ucznia)
               OR (l.ref_grupa IS NOT NULL AND UPPER(DEREF(l.ref_grupa).kod) = UPPER(v_kod_grupy))
            ORDER BY l.data_lekcji, l.godzina_start
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(TO_CHAR(lek.data_lekcji, 'YYYY-MM-DD'), 12) ||
                RPAD(lek.godzina_start || '-' || 
                     LPAD(TRUNC((godz_na_min(lek.godzina_start) + lek.czas_trwania_min) / 60), 2, '0') || ':' ||
                     LPAD(MOD(godz_na_min(lek.godzina_start) + lek.czas_trwania_min, 60), 2, '0'), 10) ||
                RPAD(lek.przedmiot, 25) ||
                RPAD(lek.nauczyciel, 15) ||
                lek.sala
            );
        END LOOP;
    END;

    PROCEDURE plan_nauczyciela(p_nazwisko VARCHAR2) IS
        v_id_naucz NUMBER;
    BEGIN
        v_id_naucz := PKG_OSOBY.get_id_nauczyciel(p_nazwisko);
        
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== PLAN NAUCZYCIELA: ' || p_nazwisko || ' ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('Data', 12) || RPAD('Godzina', 10) || RPAD('Przedmiot', 25) || RPAD('Kto', 20) || 'Sala');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 80, '-'));
        
        FOR lek IN (
            SELECT l.data_lekcji, l.godzina_start, l.czas_trwania_min,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_sala).numer AS sala,
                   CASE 
                       WHEN l.ref_uczen IS NOT NULL THEN DEREF(l.ref_uczen).imie || ' ' || DEREF(l.ref_uczen).nazwisko
                       ELSE 'Grupa ' || DEREF(l.ref_grupa).kod
                   END AS kto
            FROM LEKCJE l
            WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = v_id_naucz
            ORDER BY l.data_lekcji, l.godzina_start
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(TO_CHAR(lek.data_lekcji, 'YYYY-MM-DD'), 12) ||
                RPAD(lek.godzina_start, 10) ||
                RPAD(lek.przedmiot, 25) ||
                RPAD(lek.kto, 20) ||
                lek.sala
            );
        END LOOP;
    END;

    PROCEDURE plan_grupy(p_kod_grupy VARCHAR2) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== PLAN GRUPY: ' || UPPER(p_kod_grupy) || ' ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('Data', 12) || RPAD('Godzina', 10) || RPAD('Przedmiot', 25) || RPAD('Nauczyciel', 15) || 'Sala');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 75, '-'));
        
        FOR lek IN (
            SELECT l.data_lekcji, l.godzina_start,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
                   DEREF(l.ref_sala).numer AS sala
            FROM LEKCJE l
            WHERE l.ref_grupa IS NOT NULL AND UPPER(DEREF(l.ref_grupa).kod) = UPPER(p_kod_grupy)
            ORDER BY l.data_lekcji, l.godzina_start
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(TO_CHAR(lek.data_lekcji, 'YYYY-MM-DD'), 12) ||
                RPAD(lek.godzina_start, 10) ||
                RPAD(lek.przedmiot, 25) ||
                RPAD(lek.nauczyciel, 15) ||
                lek.sala
            );
        END LOOP;
    END;

    PROCEDURE plan_sali(p_numer VARCHAR2, p_data DATE) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== OBCIAZENIE SALI ' || p_numer || ' (' || TO_CHAR(p_data, 'YYYY-MM-DD') || ') ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('Godzina', 15) || RPAD('Przedmiot', 25) || RPAD('Nauczyciel', 15) || 'Kto');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 70, '-'));
        
        FOR lek IN (
            SELECT l.godzina_start, l.czas_trwania_min,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
                   CASE 
                       WHEN l.ref_uczen IS NOT NULL THEN DEREF(l.ref_uczen).imie || ' ' || DEREF(l.ref_uczen).nazwisko
                       ELSE 'Grupa ' || DEREF(l.ref_grupa).kod
                   END AS kto
            FROM LEKCJE l
            WHERE DEREF(l.ref_sala).numer = p_numer AND l.data_lekcji = p_data
            ORDER BY l.godzina_start
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(lek.godzina_start || '-' || 
                     LPAD(TRUNC((godz_na_min(lek.godzina_start) + lek.czas_trwania_min) / 60), 2, '0') || ':' ||
                     LPAD(MOD(godz_na_min(lek.godzina_start) + lek.czas_trwania_min, 60), 2, '0'), 15) ||
                RPAD(lek.przedmiot, 25) ||
                RPAD(lek.nauczyciel, 15) ||
                lek.kto
            );
        END LOOP;
    END;

END PKG_LEKCJE;
/

-- ============================================================================
-- 5. PAKIET PKG_OCENY - Zarzadzanie ocenami
-- ============================================================================

CREATE OR REPLACE PACKAGE PKG_OCENY AS
    PROCEDURE wystaw_ocene(p_uczen_nazwisko VARCHAR2, p_uczen_imie VARCHAR2, 
                           p_nauczyciel VARCHAR2, p_przedmiot VARCHAR2, p_wartosc NUMBER);
    PROCEDURE wystaw_ocene_semestralna(p_uczen_nazwisko VARCHAR2, p_uczen_imie VARCHAR2,
                                        p_nauczyciel VARCHAR2, p_przedmiot VARCHAR2, p_wartosc NUMBER);
    PROCEDURE oceny_ucznia(p_nazwisko VARCHAR2, p_imie VARCHAR2);
    FUNCTION srednia_ucznia(p_nazwisko VARCHAR2, p_imie VARCHAR2, p_przedmiot VARCHAR2) RETURN NUMBER;
END PKG_OCENY;
/

CREATE OR REPLACE PACKAGE BODY PKG_OCENY AS

    PROCEDURE wystaw_ocene(p_uczen_nazwisko VARCHAR2, p_uczen_imie VARCHAR2,
                           p_nauczyciel VARCHAR2, p_przedmiot VARCHAR2, p_wartosc NUMBER) IS
    BEGIN
        IF p_wartosc < 1 OR p_wartosc > 6 THEN
            RAISE_APPLICATION_ERROR(-20103, 'Ocena musi byc w zakresie 1-6');
        END IF;
        
        INSERT INTO OCENY VALUES (
            T_OCENA(
                seq_oceny.NEXTVAL,
                PKG_OSOBY.get_ref_uczen(p_uczen_nazwisko, p_uczen_imie),
                PKG_OSOBY.get_ref_nauczyciel(p_nauczyciel),
                PKG_SLOWNIKI.get_ref_przedmiot(p_przedmiot),
                p_wartosc, SYSDATE, 'N'
            )
        );
        DBMS_OUTPUT.PUT_LINE('Wystawiono ocene ' || p_wartosc || ' z ' || p_przedmiot || 
            ' dla ' || p_uczen_imie || ' ' || p_uczen_nazwisko);
    END;

    PROCEDURE wystaw_ocene_semestralna(p_uczen_nazwisko VARCHAR2, p_uczen_imie VARCHAR2,
                                        p_nauczyciel VARCHAR2, p_przedmiot VARCHAR2, p_wartosc NUMBER) IS
    BEGIN
        IF p_wartosc < 1 OR p_wartosc > 6 THEN
            RAISE_APPLICATION_ERROR(-20103, 'Ocena musi byc w zakresie 1-6');
        END IF;
        
        INSERT INTO OCENY VALUES (
            T_OCENA(
                seq_oceny.NEXTVAL,
                PKG_OSOBY.get_ref_uczen(p_uczen_nazwisko, p_uczen_imie),
                PKG_OSOBY.get_ref_nauczyciel(p_nauczyciel),
                PKG_SLOWNIKI.get_ref_przedmiot(p_przedmiot),
                p_wartosc, SYSDATE, 'T'
            )
        );
        DBMS_OUTPUT.PUT_LINE('Wystawiono ocene semestralna ' || p_wartosc || ' z ' || p_przedmiot ||
            ' dla ' || p_uczen_imie || ' ' || p_uczen_nazwisko);
    END;

    PROCEDURE oceny_ucznia(p_nazwisko VARCHAR2, p_imie VARCHAR2) IS
        v_id_ucznia NUMBER;
    BEGIN
        v_id_ucznia := PKG_OSOBY.get_id_uczen(p_nazwisko, p_imie);
        
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== OCENY UCZNIA: ' || p_imie || ' ' || p_nazwisko || ' ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('Data', 12) || RPAD('Przedmiot', 25) || RPAD('Ocena', 8) || RPAD('Nauczyciel', 15) || 'Typ');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 70, '-'));
        
        FOR oc IN (
            SELECT o.data_wystawienia, o.wartosc, o.czy_semestralna,
                   DEREF(o.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(o.ref_nauczyciel).nazwisko AS nauczyciel
            FROM OCENY o
            WHERE DEREF(o.ref_uczen).id_ucznia = v_id_ucznia
            ORDER BY o.data_wystawienia DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(TO_CHAR(oc.data_wystawienia, 'YYYY-MM-DD'), 12) ||
                RPAD(oc.przedmiot, 25) ||
                RPAD(oc.wartosc, 8) ||
                RPAD(oc.nauczyciel, 15) ||
                CASE oc.czy_semestralna WHEN 'T' THEN 'SEMESTR' ELSE 'biezaca' END
            );
        END LOOP;
    END;

    FUNCTION srednia_ucznia(p_nazwisko VARCHAR2, p_imie VARCHAR2, p_przedmiot VARCHAR2) RETURN NUMBER IS
        v_id_ucznia NUMBER;
        v_srednia NUMBER;
    BEGIN
        v_id_ucznia := PKG_OSOBY.get_id_uczen(p_nazwisko, p_imie);
        
        SELECT ROUND(AVG(o.wartosc), 2) INTO v_srednia
        FROM OCENY o
        WHERE DEREF(o.ref_uczen).id_ucznia = v_id_ucznia
          AND UPPER(DEREF(o.ref_przedmiot).nazwa) = UPPER(p_przedmiot)
          AND o.czy_semestralna = 'N';
        
        RETURN NVL(v_srednia, 0);
    END;

END PKG_OCENY;
/

-- ============================================================================
-- 6. PAKIET PKG_RAPORTY - Raporty i statystyki
-- ============================================================================

CREATE OR REPLACE PACKAGE PKG_RAPORTY AS
    PROCEDURE raport_grup;
    PROCEDURE raport_nauczycieli;
    PROCEDURE statystyki_lekcji;
END PKG_RAPORTY;
/

CREATE OR REPLACE PACKAGE BODY PKG_RAPORTY AS

    PROCEDURE raport_grup IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== RAPORT GRUP ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('Grupa', 10) || RPAD('Klasa', 8) || 'Uczniow');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 30, '-'));
        
        FOR r IN (
            SELECT g.kod, g.klasa, 
                   (SELECT COUNT(*) FROM UCZNIOWIE u WHERE DEREF(u.ref_grupa).id_grupy = g.id_grupy) AS liczba
            FROM GRUPY g
            ORDER BY g.klasa
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(RPAD(r.kod, 10) || RPAD(r.klasa, 8) || r.liczba);
        END LOOP;
    END;

    PROCEDURE raport_nauczycieli IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== RAPORT NAUCZYCIELI ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('Nazwisko', 15) || RPAD('Imie', 12) || RPAD('Instrument', 15) || 'Lekcji');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 55, '-'));
        
        FOR r IN (
            SELECT n.nazwisko, n.imie, NVL(n.instrument, 'grupowe') AS instrument,
                   (SELECT COUNT(*) FROM LEKCJE l WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = n.id_nauczyciela) AS lekcji
            FROM NAUCZYCIELE n
            ORDER BY n.nazwisko
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(RPAD(r.nazwisko, 15) || RPAD(r.imie, 12) || RPAD(r.instrument, 15) || r.lekcji);
        END LOOP;
    END;

    PROCEDURE statystyki_lekcji IS
        v_total NUMBER;
        v_indyw NUMBER;
        v_grupowe NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_total FROM LEKCJE;
        SELECT COUNT(*) INTO v_indyw FROM LEKCJE WHERE ref_uczen IS NOT NULL;
        SELECT COUNT(*) INTO v_grupowe FROM LEKCJE WHERE ref_grupa IS NOT NULL;

        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== STATYSTYKI LEKCJI ===');
        DBMS_OUTPUT.PUT_LINE('Razem lekcji:      ' || v_total);
        DBMS_OUTPUT.PUT_LINE('Indywidualnych:    ' || v_indyw);
        DBMS_OUTPUT.PUT_LINE('Grupowych:         ' || v_grupowe);
    END;

END PKG_RAPORTY;
/

-- ============================================================================
-- 7. POTWIERDZENIE
-- ============================================================================

SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('PACKAGE', 'PACKAGE BODY')
ORDER BY object_name, object_type;
