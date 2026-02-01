-- ============================================================================
-- Projekt: Szkola Muzyczna - Obiektowa Baza Danych
-- Plik: 03_pakiety_v3.sql
-- Opis: Pakiety PL/SQL - WERSJA POPRAWIONA v3 (naprawione bledy kompilacji)
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================
-- NAPRAWIONE BLEDY:
-- 1. PLS-00231: funkcja PL/SQL nie moze byc uzyta w SQL - zamieniono na czyste SQL
-- 2. PLS-00221: dostep do VARRAY w SQL - zmieniono na kursor FOR LOOP
-- ============================================================================

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
    PROCEDURE dodaj_instrument(p_nazwa VARCHAR2, p_czy_orkiestra CHAR DEFAULT 'N');
    PROCEDURE dodaj_przedmiot(p_nazwa VARCHAR2, p_typ_zajec VARCHAR2, p_domyslny_czas NUMBER, p_wyposazenie T_WYPOSAZENIE DEFAULT NULL);
    PROCEDURE dodaj_sale(p_numer VARCHAR2, p_typ VARCHAR2, p_pojemnosc NUMBER, p_wyposazenie T_WYPOSAZENIE DEFAULT NULL);
    PROCEDURE dodaj_grupe(p_kod VARCHAR2, p_klasa NUMBER, p_rok_szkolny VARCHAR2 DEFAULT '2025/2026');
    FUNCTION get_ref_instrument(p_nazwa VARCHAR2) RETURN REF T_INSTRUMENT;
    FUNCTION get_ref_przedmiot(p_nazwa VARCHAR2) RETURN REF T_PRZEDMIOT;
    FUNCTION get_ref_sala(p_numer VARCHAR2) RETURN REF T_SALA;
    FUNCTION get_ref_grupa(p_kod VARCHAR2) RETURN REF T_GRUPA;
    FUNCTION get_id_instrument(p_nazwa VARCHAR2) RETURN NUMBER;
    FUNCTION get_id_przedmiot(p_nazwa VARCHAR2) RETURN NUMBER;
    FUNCTION get_id_sala(p_numer VARCHAR2) RETURN NUMBER;
    FUNCTION get_id_grupa(p_kod VARCHAR2) RETURN NUMBER;
    FUNCTION czy_instrument_istnieje(p_nazwa VARCHAR2) RETURN BOOLEAN;
    FUNCTION get_wyposazenie_sali(p_id_sali NUMBER) RETURN T_WYPOSAZENIE;
    FUNCTION get_wymagane_wyposazenie(p_id_przedmiotu NUMBER) RETURN T_WYPOSAZENIE;
    FUNCTION get_typ_przedmiotu(p_id_przedmiotu NUMBER) RETURN VARCHAR2;
    FUNCTION get_nazwa_przedmiotu(p_id_przedmiotu NUMBER) RETURN VARCHAR2;
END PKG_SLOWNIKI;
/

CREATE OR REPLACE PACKAGE BODY PKG_SLOWNIKI AS

    PROCEDURE dodaj_instrument(p_nazwa VARCHAR2, p_czy_orkiestra CHAR DEFAULT 'N') IS
    BEGIN
        INSERT INTO INSTRUMENTY VALUES (T_INSTRUMENT(seq_instrumenty.NEXTVAL, p_nazwa, p_czy_orkiestra));
        COMMIT;
    END;

    PROCEDURE dodaj_przedmiot(p_nazwa VARCHAR2, p_typ_zajec VARCHAR2, p_domyslny_czas NUMBER, p_wyposazenie T_WYPOSAZENIE DEFAULT NULL) IS
    BEGIN
        INSERT INTO PRZEDMIOTY VALUES (T_PRZEDMIOT(seq_przedmioty.NEXTVAL, p_nazwa, p_typ_zajec, p_domyslny_czas, p_wyposazenie));
        COMMIT;
    END;

    PROCEDURE dodaj_sale(p_numer VARCHAR2, p_typ VARCHAR2, p_pojemnosc NUMBER, p_wyposazenie T_WYPOSAZENIE DEFAULT NULL) IS
    BEGIN
        INSERT INTO SALE VALUES (T_SALA(seq_sale.NEXTVAL, p_numer, p_typ, p_pojemnosc, p_wyposazenie));
        COMMIT;
    END;

    PROCEDURE dodaj_grupe(p_kod VARCHAR2, p_klasa NUMBER, p_rok_szkolny VARCHAR2 DEFAULT '2025/2026') IS
    BEGIN
        INSERT INTO GRUPY VALUES (T_GRUPA(seq_grupy.NEXTVAL, p_kod, p_klasa, p_rok_szkolny));
        COMMIT;
    END;

    FUNCTION get_ref_instrument(p_nazwa VARCHAR2) RETURN REF T_INSTRUMENT IS
        v_ref REF T_INSTRUMENT;
    BEGIN
        SELECT REF(i) INTO v_ref FROM INSTRUMENTY i WHERE UPPER(i.nazwa) = UPPER(p_nazwa);
        RETURN v_ref;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Instrument nie znaleziony: ' || p_nazwa);
    END;

    FUNCTION get_ref_przedmiot(p_nazwa VARCHAR2) RETURN REF T_PRZEDMIOT IS
        v_ref REF T_PRZEDMIOT;
    BEGIN
        SELECT REF(p) INTO v_ref FROM PRZEDMIOTY p WHERE UPPER(p.nazwa) = UPPER(p_nazwa);
        RETURN v_ref;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Przedmiot nie znaleziony: ' || p_nazwa);
    END;

    FUNCTION get_ref_sala(p_numer VARCHAR2) RETURN REF T_SALA IS
        v_ref REF T_SALA;
    BEGIN
        SELECT REF(s) INTO v_ref FROM SALE s WHERE s.numer = p_numer;
        RETURN v_ref;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20003, 'Sala nie znaleziona: ' || p_numer);
    END;

    FUNCTION get_ref_grupa(p_kod VARCHAR2) RETURN REF T_GRUPA IS
        v_ref REF T_GRUPA;
    BEGIN
        SELECT REF(g) INTO v_ref FROM GRUPY g WHERE UPPER(g.kod) = UPPER(p_kod);
        RETURN v_ref;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20004, 'Grupa nie znaleziona: ' || p_kod);
    END;

    FUNCTION get_id_instrument(p_nazwa VARCHAR2) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT id_instrumentu INTO v_id FROM INSTRUMENTY WHERE UPPER(nazwa) = UPPER(p_nazwa);
        RETURN v_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Instrument nie znaleziony: ' || p_nazwa);
    END;

    FUNCTION get_id_przedmiot(p_nazwa VARCHAR2) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT id_przedmiotu INTO v_id FROM PRZEDMIOTY WHERE UPPER(nazwa) = UPPER(p_nazwa);
        RETURN v_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Przedmiot nie znaleziony: ' || p_nazwa);
    END;

    FUNCTION get_id_sala(p_numer VARCHAR2) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT id_sali INTO v_id FROM SALE WHERE numer = p_numer;
        RETURN v_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20003, 'Sala nie znaleziona: ' || p_numer);
    END;

    FUNCTION get_id_grupa(p_kod VARCHAR2) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT id_grupy INTO v_id FROM GRUPY WHERE UPPER(kod) = UPPER(p_kod);
        RETURN v_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20004, 'Grupa nie znaleziona: ' || p_kod);
    END;

    FUNCTION czy_instrument_istnieje(p_nazwa VARCHAR2) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM INSTRUMENTY WHERE UPPER(nazwa) = UPPER(p_nazwa);
        RETURN v_count > 0;
    END;

    FUNCTION get_wyposazenie_sali(p_id_sali NUMBER) RETURN T_WYPOSAZENIE IS
        v_wyp T_WYPOSAZENIE;
    BEGIN
        SELECT wyposazenie INTO v_wyp FROM SALE WHERE id_sali = p_id_sali;
        RETURN v_wyp;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
    END;

    FUNCTION get_wymagane_wyposazenie(p_id_przedmiotu NUMBER) RETURN T_WYPOSAZENIE IS
        v_wyp T_WYPOSAZENIE;
    BEGIN
        SELECT wymagane_wyposazenie INTO v_wyp FROM PRZEDMIOTY WHERE id_przedmiotu = p_id_przedmiotu;
        RETURN v_wyp;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
    END;

    FUNCTION get_typ_przedmiotu(p_id_przedmiotu NUMBER) RETURN VARCHAR2 IS
        v_typ VARCHAR2(20);
    BEGIN
        SELECT typ_zajec INTO v_typ FROM PRZEDMIOTY WHERE id_przedmiotu = p_id_przedmiotu;
        RETURN v_typ;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
    END;

    FUNCTION get_nazwa_przedmiotu(p_id_przedmiotu NUMBER) RETURN VARCHAR2 IS
        v_nazwa VARCHAR2(100);
    BEGIN
        SELECT nazwa INTO v_nazwa FROM PRZEDMIOTY WHERE id_przedmiotu = p_id_przedmiotu;
        RETURN v_nazwa;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
    END;

END PKG_SLOWNIKI;
/

-- ============================================================================
-- 3. PAKIET PKG_OSOBY - Zarzadzanie nauczycielami i uczniami
-- ============================================================================

CREATE OR REPLACE PACKAGE PKG_OSOBY AS
    PROCEDURE dodaj_nauczyciela(p_imie VARCHAR2, p_nazwisko VARCHAR2, p_instrumenty T_INSTRUMENTY_TAB DEFAULT NULL, p_email VARCHAR2 DEFAULT NULL, p_telefon VARCHAR2 DEFAULT NULL);
    PROCEDURE dodaj_ucznia(p_imie VARCHAR2, p_nazwisko VARCHAR2, p_data_urodzenia DATE, p_kod_grupy VARCHAR2, p_instrument VARCHAR2, p_email_rodzica VARCHAR2 DEFAULT NULL, p_telefon_rodzica VARCHAR2 DEFAULT NULL);
    FUNCTION get_ref_nauczyciel_by_id(p_id NUMBER) RETURN REF T_NAUCZYCIEL;
    FUNCTION get_ref_nauczyciel(p_nazwisko VARCHAR2) RETURN REF T_NAUCZYCIEL;
    FUNCTION get_ref_uczen_by_id(p_id NUMBER) RETURN REF T_UCZEN;
    FUNCTION get_ref_uczen(p_nazwisko VARCHAR2, p_imie VARCHAR2) RETURN REF T_UCZEN;
    FUNCTION get_id_nauczyciel(p_nazwisko VARCHAR2) RETURN NUMBER;
    FUNCTION get_id_uczen(p_nazwisko VARCHAR2, p_imie VARCHAR2) RETURN NUMBER;
    FUNCTION get_instrumenty_nauczyciela(p_id NUMBER) RETURN T_INSTRUMENTY_TAB;
    FUNCTION get_instrument_ucznia(p_id_ucznia NUMBER) RETURN VARCHAR2;
    FUNCTION get_grupa_ucznia(p_id_ucznia NUMBER) RETURN VARCHAR2;
    FUNCTION get_klasa_ucznia(p_id_ucznia NUMBER) RETURN NUMBER;
    FUNCTION liczba_uczniow_nauczyciela(p_id_nauczyciela NUMBER) RETURN NUMBER;
    FUNCTION uczniowie_w_grupie(p_kod_grupy VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION uczniowie_nauczyciela(p_nazwisko VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION liczba_uczniow_w_grupie(p_kod_grupy VARCHAR2) RETURN NUMBER;
END PKG_OSOBY;
/

CREATE OR REPLACE PACKAGE BODY PKG_OSOBY AS

    PROCEDURE dodaj_nauczyciela(p_imie VARCHAR2, p_nazwisko VARCHAR2, p_instrumenty T_INSTRUMENTY_TAB DEFAULT NULL, p_email VARCHAR2 DEFAULT NULL, p_telefon VARCHAR2 DEFAULT NULL) IS
    BEGIN
        IF p_instrumenty IS NOT NULL AND p_instrumenty.COUNT > 0 THEN
            FOR i IN 1..p_instrumenty.COUNT LOOP
                IF NOT PKG_SLOWNIKI.czy_instrument_istnieje(p_instrumenty(i)) THEN
                    RAISE_APPLICATION_ERROR(-20030, 'Instrument "' || p_instrumenty(i) || '" nie istnieje.');
                END IF;
            END LOOP;
        END IF;
        INSERT INTO NAUCZYCIELE VALUES (T_NAUCZYCIEL(seq_nauczyciele.NEXTVAL, p_imie, p_nazwisko, p_instrumenty, p_email, p_telefon, 6, 30));
        COMMIT;
    END;

    PROCEDURE dodaj_ucznia(p_imie VARCHAR2, p_nazwisko VARCHAR2, p_data_urodzenia DATE, p_kod_grupy VARCHAR2, p_instrument VARCHAR2, p_email_rodzica VARCHAR2 DEFAULT NULL, p_telefon_rodzica VARCHAR2 DEFAULT NULL) IS
        v_ref_grupa REF T_GRUPA;
        v_ref_instrument REF T_INSTRUMENT;
        v_liczba NUMBER;
    BEGIN
        v_ref_grupa := PKG_SLOWNIKI.get_ref_grupa(p_kod_grupy);
        v_ref_instrument := PKG_SLOWNIKI.get_ref_instrument(p_instrument);
        v_liczba := liczba_uczniow_w_grupie(p_kod_grupy);
        IF v_liczba >= 15 THEN
            RAISE_APPLICATION_ERROR(-20116, 'Grupa ' || p_kod_grupy || ' osiagnela limit 15 uczniow.');
        END IF;
        INSERT INTO UCZNIOWIE VALUES (T_UCZEN(seq_uczniowie.NEXTVAL, p_imie, p_nazwisko, p_data_urodzenia, v_ref_grupa, v_ref_instrument, p_email_rodzica, p_telefon_rodzica, SYSDATE));
        COMMIT;
    END;

    FUNCTION get_ref_nauczyciel_by_id(p_id NUMBER) RETURN REF T_NAUCZYCIEL IS
        v_ref REF T_NAUCZYCIEL;
    BEGIN
        SELECT REF(n) INTO v_ref FROM NAUCZYCIELE n WHERE n.id_nauczyciela = p_id;
        RETURN v_ref;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20005, 'Nauczyciel o ID ' || p_id || ' nie istnieje');
    END;

    FUNCTION get_ref_nauczyciel(p_nazwisko VARCHAR2) RETURN REF T_NAUCZYCIEL IS
        v_ref REF T_NAUCZYCIEL;
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM NAUCZYCIELE WHERE UPPER(nazwisko) = UPPER(p_nazwisko);
        IF v_count = 0 THEN RAISE_APPLICATION_ERROR(-20005, 'Nauczyciel nie znaleziony: ' || p_nazwisko);
        ELSIF v_count > 1 THEN RAISE_APPLICATION_ERROR(-20007, 'Wielu nauczycieli o nazwisku: ' || p_nazwisko);
        END IF;
        SELECT REF(n) INTO v_ref FROM NAUCZYCIELE n WHERE UPPER(n.nazwisko) = UPPER(p_nazwisko);
        RETURN v_ref;
    END;

    FUNCTION get_ref_uczen_by_id(p_id NUMBER) RETURN REF T_UCZEN IS
        v_ref REF T_UCZEN;
    BEGIN
        SELECT REF(u) INTO v_ref FROM UCZNIOWIE u WHERE u.id_ucznia = p_id;
        RETURN v_ref;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20006, 'Uczen o ID ' || p_id || ' nie istnieje');
    END;

    FUNCTION get_ref_uczen(p_nazwisko VARCHAR2, p_imie VARCHAR2) RETURN REF T_UCZEN IS
        v_ref REF T_UCZEN;
        v_count NUMBER;
    BEGIN
        IF p_imie IS NULL THEN RAISE_APPLICATION_ERROR(-20008, 'Imie ucznia jest wymagane.'); END IF;
        SELECT COUNT(*) INTO v_count FROM UCZNIOWIE WHERE UPPER(nazwisko) = UPPER(p_nazwisko) AND UPPER(imie) = UPPER(p_imie);
        IF v_count = 0 THEN RAISE_APPLICATION_ERROR(-20006, 'Uczen nie znaleziony: ' || p_imie || ' ' || p_nazwisko);
        ELSIF v_count > 1 THEN RAISE_APPLICATION_ERROR(-20009, 'Wielu uczniow: ' || p_imie || ' ' || p_nazwisko);
        END IF;
        SELECT REF(u) INTO v_ref FROM UCZNIOWIE u WHERE UPPER(u.nazwisko) = UPPER(p_nazwisko) AND UPPER(u.imie) = UPPER(p_imie);
        RETURN v_ref;
    END;

    FUNCTION get_id_nauczyciel(p_nazwisko VARCHAR2) RETURN NUMBER IS
        v_id NUMBER;
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM NAUCZYCIELE WHERE UPPER(nazwisko) = UPPER(p_nazwisko);
        IF v_count = 0 THEN RAISE_APPLICATION_ERROR(-20005, 'Nauczyciel nie znaleziony: ' || p_nazwisko);
        ELSIF v_count > 1 THEN RAISE_APPLICATION_ERROR(-20007, 'Wielu nauczycieli o nazwisku: ' || p_nazwisko);
        END IF;
        SELECT id_nauczyciela INTO v_id FROM NAUCZYCIELE WHERE UPPER(nazwisko) = UPPER(p_nazwisko);
        RETURN v_id;
    END;

    FUNCTION get_id_uczen(p_nazwisko VARCHAR2, p_imie VARCHAR2) RETURN NUMBER IS
        v_id NUMBER;
        v_count NUMBER;
    BEGIN
        IF p_imie IS NULL THEN RAISE_APPLICATION_ERROR(-20008, 'Imie ucznia jest wymagane.'); END IF;
        SELECT COUNT(*) INTO v_count FROM UCZNIOWIE WHERE UPPER(nazwisko) = UPPER(p_nazwisko) AND UPPER(imie) = UPPER(p_imie);
        IF v_count = 0 THEN RAISE_APPLICATION_ERROR(-20006, 'Uczen nie znaleziony: ' || p_imie || ' ' || p_nazwisko);
        ELSIF v_count > 1 THEN RAISE_APPLICATION_ERROR(-20009, 'Wielu uczniow');
        END IF;
        SELECT id_ucznia INTO v_id FROM UCZNIOWIE WHERE UPPER(nazwisko) = UPPER(p_nazwisko) AND UPPER(imie) = UPPER(p_imie);
        RETURN v_id;
    END;

    FUNCTION get_instrumenty_nauczyciela(p_id NUMBER) RETURN T_INSTRUMENTY_TAB IS
        v_instr T_INSTRUMENTY_TAB;
    BEGIN
        SELECT instrumenty INTO v_instr FROM NAUCZYCIELE WHERE id_nauczyciela = p_id;
        RETURN v_instr;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
    END;

    FUNCTION get_instrument_ucznia(p_id_ucznia NUMBER) RETURN VARCHAR2 IS
        v_nazwa VARCHAR2(50);
    BEGIN
        SELECT DEREF(u.ref_instrument).nazwa INTO v_nazwa FROM UCZNIOWIE u WHERE u.id_ucznia = p_id_ucznia;
        RETURN v_nazwa;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
    END;

    FUNCTION get_grupa_ucznia(p_id_ucznia NUMBER) RETURN VARCHAR2 IS
        v_kod VARCHAR2(10);
    BEGIN
        SELECT DEREF(u.ref_grupa).kod INTO v_kod FROM UCZNIOWIE u WHERE u.id_ucznia = p_id_ucznia;
        RETURN v_kod;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
    END;

    FUNCTION get_klasa_ucznia(p_id_ucznia NUMBER) RETURN NUMBER IS
        v_klasa NUMBER;
    BEGIN
        SELECT DEREF(u.ref_grupa).klasa INTO v_klasa FROM UCZNIOWIE u WHERE u.id_ucznia = p_id_ucznia;
        RETURN v_klasa;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
    END;

    FUNCTION liczba_uczniow_nauczyciela(p_id_nauczyciela NUMBER) RETURN NUMBER IS
        v_count NUMBER := 0;
        v_instrumenty T_INSTRUMENTY_TAB;
    BEGIN
        SELECT instrumenty INTO v_instrumenty FROM NAUCZYCIELE WHERE id_nauczyciela = p_id_nauczyciela;
        IF v_instrumenty IS NULL OR v_instrumenty.COUNT = 0 THEN RETURN 0; END IF;
        SELECT COUNT(*) INTO v_count FROM UCZNIOWIE u WHERE DEREF(u.ref_instrument).nazwa IN (SELECT COLUMN_VALUE FROM TABLE(v_instrumenty));
        RETURN v_count;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN 0;
    END;

    FUNCTION uczniowie_w_grupie(p_kod_grupy VARCHAR2) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT u.id_ucznia, u.imie, u.nazwisko, DEREF(u.ref_instrument).nazwa AS instrument
            FROM UCZNIOWIE u WHERE UPPER(DEREF(u.ref_grupa).kod) = UPPER(p_kod_grupy)
            ORDER BY u.nazwisko, u.imie;
        RETURN v_cursor;
    END;

    FUNCTION uczniowie_nauczyciela(p_nazwisko VARCHAR2) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
        v_instrumenty T_INSTRUMENTY_TAB;
    BEGIN
        SELECT instrumenty INTO v_instrumenty FROM NAUCZYCIELE WHERE UPPER(nazwisko) = UPPER(p_nazwisko);
        IF v_instrumenty IS NULL OR v_instrumenty.COUNT = 0 THEN
            OPEN v_cursor FOR SELECT NULL id_ucznia, NULL imie, NULL nazwisko FROM DUAL WHERE 1=0;
            RETURN v_cursor;
        END IF;
        OPEN v_cursor FOR
            SELECT u.id_ucznia, u.imie, u.nazwisko, DEREF(u.ref_instrument).nazwa AS instrument
            FROM UCZNIOWIE u WHERE DEREF(u.ref_instrument).nazwa IN (SELECT COLUMN_VALUE FROM TABLE(v_instrumenty))
            ORDER BY u.nazwisko;
        RETURN v_cursor;
    END;

    FUNCTION liczba_uczniow_w_grupie(p_kod_grupy VARCHAR2) RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM UCZNIOWIE u WHERE UPPER(DEREF(u.ref_grupa).kod) = UPPER(p_kod_grupy);
        RETURN v_count;
    END;

END PKG_OSOBY;
/

-- ============================================================================
-- 4. PAKIET PKG_LEKCJE - Zarzadzanie lekcjami i planowaniem
-- ============================================================================

CREATE OR REPLACE PACKAGE PKG_LEKCJE AS
    PROCEDURE dodaj_lekcje_indywidualna(p_przedmiot VARCHAR2, p_nauczyciel_nazwisko VARCHAR2, p_sala_numer VARCHAR2, p_uczen_nazwisko VARCHAR2, p_uczen_imie VARCHAR2, p_data DATE, p_godzina VARCHAR2, p_czas_min NUMBER DEFAULT 45);
    PROCEDURE dodaj_lekcje_grupowa(p_przedmiot VARCHAR2, p_nauczyciel_nazwisko VARCHAR2, p_sala_numer VARCHAR2, p_grupa_kod VARCHAR2, p_data DATE, p_godzina VARCHAR2, p_czas_min NUMBER DEFAULT 45);
    PROCEDURE dodaj_egzamin(p_uczen_nazwisko VARCHAR2, p_uczen_imie VARCHAR2, p_sala_numer VARCHAR2, p_data DATE, p_godzina VARCHAR2, p_komisja_nazwisko1 VARCHAR2, p_komisja_nazwisko2 VARCHAR2, p_czas_min NUMBER DEFAULT 45);
    PROCEDURE zmien_status_lekcji(p_id_lekcji NUMBER, p_nowy_status VARCHAR2);
    FUNCTION czy_sala_wolna(p_id_sali NUMBER, p_data DATE, p_godzina_start VARCHAR2, p_czas_min NUMBER) RETURN BOOLEAN;
    FUNCTION czy_nauczyciel_wolny(p_id_nauczyciela NUMBER, p_data DATE, p_godzina_start VARCHAR2, p_czas_min NUMBER) RETURN BOOLEAN;
    FUNCTION czy_uczen_wolny(p_id_ucznia NUMBER, p_data DATE, p_godzina_start VARCHAR2, p_czas_min NUMBER) RETURN BOOLEAN;
    PROCEDURE waliduj_wyposazenie_sali(p_id_sali NUMBER, p_id_przedmiotu NUMBER);
    PROCEDURE waliduj_nauczyciel_przedmiot(p_id_nauczyciela NUMBER, p_przedmiot_nazwa VARCHAR2);
    PROCEDURE waliduj_uczen_przedmiot(p_id_ucznia NUMBER, p_przedmiot_nazwa VARCHAR2);
    PROCEDURE waliduj_godziny_pracy(p_godzina VARCHAR2, p_czas_min NUMBER);
    PROCEDURE waliduj_dzien_tygodnia(p_data DATE);
    FUNCTION plan_ucznia(p_nazwisko VARCHAR2, p_imie VARCHAR2, p_data_od DATE, p_data_do DATE) RETURN SYS_REFCURSOR;
    FUNCTION plan_sali(p_numer_sali VARCHAR2, p_data DATE) RETURN SYS_REFCURSOR;
    FUNCTION plan_nauczyciela(p_nazwisko VARCHAR2, p_data_od DATE, p_data_do DATE) RETURN SYS_REFCURSOR;
    FUNCTION plan_grupy(p_kod_grupy VARCHAR2, p_data_od DATE, p_data_do DATE) RETURN SYS_REFCURSOR;
    FUNCTION egzaminy_ucznia(p_nazwisko VARCHAR2, p_imie VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION egzaminy_nauczyciela(p_nazwisko VARCHAR2) RETURN SYS_REFCURSOR;

    -- =======================================================================
    -- HEURYSTYKA PRZYDZIALU NAUCZYCIELA
    -- =======================================================================
    FUNCTION znajdz_nauczyciela_heurystyka(p_instrument VARCHAR2, p_data DATE, p_godzina VARCHAR2, p_czas_min NUMBER) RETURN VARCHAR2;
    PROCEDURE przydziel_lekcje_indywidualna(p_uczen_nazwisko VARCHAR2, p_uczen_imie VARCHAR2, p_data DATE, p_godzina VARCHAR2, p_czas_min NUMBER DEFAULT NULL);

    -- =======================================================================
    -- GENEROWANIE PLANU SEMESTRALNEGO
    -- =======================================================================
    PROCEDURE generuj_lekcje_indywidualne_tydzien(p_data_poniedzialek DATE);
    PROCEDURE generuj_lekcje_grupowe_tydzien(p_data_poniedzialek DATE);
    PROCEDURE generuj_plan_tygodnia(p_data_poniedzialek DATE);
END PKG_LEKCJE;
/

CREATE OR REPLACE PACKAGE BODY PKG_LEKCJE AS

    -- =======================================================================
    -- FUNKCJE POMOCNICZE (lokalne)
    -- =======================================================================

    -- Konwersja godziny HH:MI na minuty (funkcja PL/SQL - NIE uzywac w SQL!)
    FUNCTION godzina_na_minuty(p_godzina VARCHAR2) RETURN NUMBER IS
    BEGIN
        RETURN TO_NUMBER(SUBSTR(p_godzina, 1, 2)) * 60 + TO_NUMBER(SUBSTR(p_godzina, 4, 2));
    END;

    -- =======================================================================
    -- WALIDACJE
    -- =======================================================================

    PROCEDURE waliduj_godziny_pracy(p_godzina VARCHAR2, p_czas_min NUMBER) IS
        v_godzina NUMBER;
        v_minuta NUMBER;
        v_start_min NUMBER;
        v_koniec_min NUMBER;
    BEGIN
        v_godzina := TO_NUMBER(SUBSTR(p_godzina, 1, 2));
        v_minuta := TO_NUMBER(SUBSTR(p_godzina, 4, 2));
        v_start_min := v_godzina * 60 + v_minuta;
        v_koniec_min := v_start_min + p_czas_min;

        IF v_godzina < 14 THEN
            RAISE_APPLICATION_ERROR(-20106, 'Lekcje nie moga zaczynac sie przed 14:00. Podano: ' || p_godzina);
        END IF;

        IF v_start_min >= 20 * 60 THEN
            RAISE_APPLICATION_ERROR(-20106, 'Lekcje nie moga zaczynac sie po 20:00. Podano: ' || p_godzina);
        END IF;

        IF v_koniec_min > 21 * 60 THEN
            RAISE_APPLICATION_ERROR(-20107, 'Lekcja nie moze konczyc sie pozniej niz o 21:00.');
        END IF;
    END;

    PROCEDURE waliduj_dzien_tygodnia(p_data DATE) IS
    BEGIN
        IF TO_CHAR(p_data, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') IN ('SAT', 'SUN') THEN
            RAISE_APPLICATION_ERROR(-20109, 'Lekcje odbywaja sie od poniedzialku do piatku.');
        END IF;
    END;

    -- Sprawdzenie czy sala jest wolna - uzywa czystego SQL zamiast funkcji PL/SQL
    FUNCTION czy_sala_wolna(p_id_sali NUMBER, p_data DATE, p_godzina_start VARCHAR2, p_czas_min NUMBER) RETURN BOOLEAN IS
        v_count NUMBER;
        v_start_min NUMBER := godzina_na_minuty(p_godzina_start);
        v_koniec_min NUMBER := v_start_min + p_czas_min;
    BEGIN
        -- Zamiast godzina_na_minuty() w SQL uzywamy czystego SQL
        SELECT COUNT(*) INTO v_count
        FROM LEKCJE l
        WHERE DEREF(l.ref_sala).id_sali = p_id_sali
          AND l.data_lekcji = p_data
          AND l.status != 'odwolana'
          AND (
              -- Konwersja godziny na minuty w SQL
              (TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))) < v_koniec_min
              AND
              v_start_min < (TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania_min)
          );
        RETURN v_count = 0;
    END;

    FUNCTION czy_nauczyciel_wolny(p_id_nauczyciela NUMBER, p_data DATE, p_godzina_start VARCHAR2, p_czas_min NUMBER) RETURN BOOLEAN IS
        v_count NUMBER;
        v_start_min NUMBER := godzina_na_minuty(p_godzina_start);
        v_koniec_min NUMBER := v_start_min + p_czas_min;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM LEKCJE l
        WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = p_id_nauczyciela
          AND l.data_lekcji = p_data
          AND l.status != 'odwolana'
          AND (
              (TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))) < v_koniec_min
              AND
              v_start_min < (TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania_min)
          );
        RETURN v_count = 0;
    END;

    FUNCTION czy_uczen_wolny(p_id_ucznia NUMBER, p_data DATE, p_godzina_start VARCHAR2, p_czas_min NUMBER) RETURN BOOLEAN IS
        v_count NUMBER;
        v_start_min NUMBER := godzina_na_minuty(p_godzina_start);
        v_koniec_min NUMBER := v_start_min + p_czas_min;
        v_kod_grupy VARCHAR2(10);
    BEGIN
        v_kod_grupy := PKG_OSOBY.get_grupa_ucznia(p_id_ucznia);

        -- Sprawdz lekcje indywidualne ucznia
        SELECT COUNT(*) INTO v_count
        FROM LEKCJE l
        WHERE l.ref_uczen IS NOT NULL
          AND DEREF(l.ref_uczen).id_ucznia = p_id_ucznia
          AND l.data_lekcji = p_data
          AND l.status != 'odwolana'
          AND (
              (TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))) < v_koniec_min
              AND
              v_start_min < (TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania_min)
          );

        IF v_count > 0 THEN RETURN FALSE; END IF;

        -- Sprawdz lekcje grupowe ucznia
        IF v_kod_grupy IS NOT NULL THEN
            SELECT COUNT(*) INTO v_count
            FROM LEKCJE l
            WHERE l.ref_grupa IS NOT NULL
              AND UPPER(DEREF(l.ref_grupa).kod) = UPPER(v_kod_grupy)
              AND l.data_lekcji = p_data
              AND l.status != 'odwolana'
              AND (
                  (TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))) < v_koniec_min
                  AND
                  v_start_min < (TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania_min)
              );
            IF v_count > 0 THEN RETURN FALSE; END IF;
        END IF;

        RETURN TRUE;
    END;

    PROCEDURE waliduj_wyposazenie_sali(p_id_sali NUMBER, p_id_przedmiotu NUMBER) IS
        v_wymagane T_WYPOSAZENIE;
        v_dostepne T_WYPOSAZENIE;
        v_found BOOLEAN;
        v_sala_numer VARCHAR2(10);
    BEGIN
        v_wymagane := PKG_SLOWNIKI.get_wymagane_wyposazenie(p_id_przedmiotu);
        IF v_wymagane IS NULL OR v_wymagane.COUNT = 0 THEN RETURN; END IF;
        
        v_dostepne := PKG_SLOWNIKI.get_wyposazenie_sali(p_id_sali);
        IF v_dostepne IS NULL OR v_dostepne.COUNT = 0 THEN
            SELECT numer INTO v_sala_numer FROM SALE WHERE id_sali = p_id_sali;
            RAISE_APPLICATION_ERROR(-20108, 'Sala ' || v_sala_numer || ' nie posiada wymaganego wyposazenia.');
        END IF;

        FOR i IN 1..v_wymagane.COUNT LOOP
            v_found := FALSE;
            FOR j IN 1..v_dostepne.COUNT LOOP
                IF UPPER(v_wymagane(i)) = UPPER(v_dostepne(j)) THEN v_found := TRUE; EXIT; END IF;
            END LOOP;
            IF NOT v_found THEN
                SELECT numer INTO v_sala_numer FROM SALE WHERE id_sali = p_id_sali;
                RAISE_APPLICATION_ERROR(-20108, 'Sala ' || v_sala_numer || ' nie ma: ' || v_wymagane(i));
            END IF;
        END LOOP;
    END;

    PROCEDURE waliduj_nauczyciel_przedmiot(p_id_nauczyciela NUMBER, p_przedmiot_nazwa VARCHAR2) IS
        v_instrumenty T_INSTRUMENTY_TAB;
        v_typ_przedmiotu VARCHAR2(20);
        v_found BOOLEAN := FALSE;
        v_nazwisko VARCHAR2(100);
    BEGIN
        v_typ_przedmiotu := PKG_SLOWNIKI.get_typ_przedmiotu(PKG_SLOWNIKI.get_id_przedmiot(p_przedmiot_nazwa));
        IF v_typ_przedmiotu = 'grupowy' THEN RETURN; END IF;

        v_instrumenty := PKG_OSOBY.get_instrumenty_nauczyciela(p_id_nauczyciela);
        IF v_instrumenty IS NULL OR v_instrumenty.COUNT = 0 THEN
            SELECT nazwisko INTO v_nazwisko FROM NAUCZYCIELE WHERE id_nauczyciela = p_id_nauczyciela;
            RAISE_APPLICATION_ERROR(-20111, 'Nauczyciel ' || v_nazwisko || ' nie ma przypisanych instrumentow');
        END IF;

        FOR i IN 1..v_instrumenty.COUNT LOOP
            IF UPPER(v_instrumenty(i)) = UPPER(p_przedmiot_nazwa) THEN v_found := TRUE; EXIT; END IF;
        END LOOP;

        IF NOT v_found THEN
            SELECT nazwisko INTO v_nazwisko FROM NAUCZYCIELE WHERE id_nauczyciela = p_id_nauczyciela;
            RAISE_APPLICATION_ERROR(-20111, 'Nauczyciel ' || v_nazwisko || ' nie uczy ' || p_przedmiot_nazwa);
        END IF;
    END;

    PROCEDURE waliduj_uczen_przedmiot(p_id_ucznia NUMBER, p_przedmiot_nazwa VARCHAR2) IS
        v_instrument_ucznia VARCHAR2(50);
        v_typ_przedmiotu VARCHAR2(20);
    BEGIN
        v_typ_przedmiotu := PKG_SLOWNIKI.get_typ_przedmiotu(PKG_SLOWNIKI.get_id_przedmiot(p_przedmiot_nazwa));
        IF v_typ_przedmiotu = 'grupowy' THEN RETURN; END IF;

        v_instrument_ucznia := PKG_OSOBY.get_instrument_ucznia(p_id_ucznia);
        IF UPPER(v_instrument_ucznia) != UPPER(p_przedmiot_nazwa) THEN
            RAISE_APPLICATION_ERROR(-20110, 'Uczen gra na ' || v_instrument_ucznia || ', nie moze miec lekcji z ' || p_przedmiot_nazwa);
        END IF;
    END;

    -- =======================================================================
    -- PROCEDURY DODAWANIA LEKCJI
    -- =======================================================================

    PROCEDURE dodaj_lekcje_indywidualna(p_przedmiot VARCHAR2, p_nauczyciel_nazwisko VARCHAR2, p_sala_numer VARCHAR2, p_uczen_nazwisko VARCHAR2, p_uczen_imie VARCHAR2, p_data DATE, p_godzina VARCHAR2, p_czas_min NUMBER DEFAULT 45) IS
        v_id_przedmiotu NUMBER;
        v_id_nauczyciela NUMBER;
        v_id_sali NUMBER;
        v_id_ucznia NUMBER;
        v_ref_przedmiot REF T_PRZEDMIOT;
        v_ref_nauczyciel REF T_NAUCZYCIEL;
        v_ref_sala REF T_SALA;
        v_ref_uczen REF T_UCZEN;
    BEGIN
        v_id_przedmiotu := PKG_SLOWNIKI.get_id_przedmiot(p_przedmiot);
        v_id_nauczyciela := PKG_OSOBY.get_id_nauczyciel(p_nauczyciel_nazwisko);
        v_id_sali := PKG_SLOWNIKI.get_id_sala(p_sala_numer);
        v_id_ucznia := PKG_OSOBY.get_id_uczen(p_uczen_nazwisko, p_uczen_imie);

        waliduj_godziny_pracy(p_godzina, p_czas_min);
        waliduj_dzien_tygodnia(p_data);
        waliduj_wyposazenie_sali(v_id_sali, v_id_przedmiotu);
        waliduj_nauczyciel_przedmiot(v_id_nauczyciela, p_przedmiot);
        waliduj_uczen_przedmiot(v_id_ucznia, p_przedmiot);

        IF NOT czy_sala_wolna(v_id_sali, p_data, p_godzina, p_czas_min) THEN
            RAISE_APPLICATION_ERROR(-20010, 'Sala ' || p_sala_numer || ' zajeta');
        END IF;
        IF NOT czy_nauczyciel_wolny(v_id_nauczyciela, p_data, p_godzina, p_czas_min) THEN
            RAISE_APPLICATION_ERROR(-20011, 'Nauczyciel ' || p_nauczyciel_nazwisko || ' zajety');
        END IF;
        IF NOT czy_uczen_wolny(v_id_ucznia, p_data, p_godzina, p_czas_min) THEN
            RAISE_APPLICATION_ERROR(-20012, 'Uczen ' || p_uczen_imie || ' ' || p_uczen_nazwisko || ' zajety');
        END IF;

        v_ref_przedmiot := PKG_SLOWNIKI.get_ref_przedmiot(p_przedmiot);
        v_ref_nauczyciel := PKG_OSOBY.get_ref_nauczyciel(p_nauczyciel_nazwisko);
        v_ref_sala := PKG_SLOWNIKI.get_ref_sala(p_sala_numer);
        v_ref_uczen := PKG_OSOBY.get_ref_uczen(p_uczen_nazwisko, p_uczen_imie);

        INSERT INTO LEKCJE (id_lekcji, ref_przedmiot, ref_nauczyciel, ref_sala, ref_uczen, ref_grupa, data_lekcji, godzina_start, czas_trwania_min, typ_lekcji, status, komisja)
        VALUES (seq_lekcje.NEXTVAL, v_ref_przedmiot, v_ref_nauczyciel, v_ref_sala, v_ref_uczen, NULL, p_data, p_godzina, p_czas_min, 'zwykla', 'zaplanowana', NULL);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Dodano lekcje: ' || p_przedmiot || ' dla ' || p_uczen_imie || ' ' || p_uczen_nazwisko);
    END;

    PROCEDURE dodaj_lekcje_grupowa(p_przedmiot VARCHAR2, p_nauczyciel_nazwisko VARCHAR2, p_sala_numer VARCHAR2, p_grupa_kod VARCHAR2, p_data DATE, p_godzina VARCHAR2, p_czas_min NUMBER DEFAULT 45) IS
        v_id_przedmiotu NUMBER;
        v_id_nauczyciela NUMBER;
        v_id_sali NUMBER;
        v_id_grupy NUMBER;
        v_ref_przedmiot REF T_PRZEDMIOT;
        v_ref_nauczyciel REF T_NAUCZYCIEL;
        v_ref_sala REF T_SALA;
        v_ref_grupa REF T_GRUPA;
    BEGIN
        v_id_przedmiotu := PKG_SLOWNIKI.get_id_przedmiot(p_przedmiot);
        v_id_nauczyciela := PKG_OSOBY.get_id_nauczyciel(p_nauczyciel_nazwisko);
        v_id_sali := PKG_SLOWNIKI.get_id_sala(p_sala_numer);
        v_id_grupy := PKG_SLOWNIKI.get_id_grupa(p_grupa_kod);

        waliduj_godziny_pracy(p_godzina, p_czas_min);
        waliduj_dzien_tygodnia(p_data);
        waliduj_wyposazenie_sali(v_id_sali, v_id_przedmiotu);

        IF NOT czy_sala_wolna(v_id_sali, p_data, p_godzina, p_czas_min) THEN
            RAISE_APPLICATION_ERROR(-20010, 'Sala ' || p_sala_numer || ' zajeta');
        END IF;
        IF NOT czy_nauczyciel_wolny(v_id_nauczyciela, p_data, p_godzina, p_czas_min) THEN
            RAISE_APPLICATION_ERROR(-20011, 'Nauczyciel ' || p_nauczyciel_nazwisko || ' zajety');
        END IF;

        v_ref_przedmiot := PKG_SLOWNIKI.get_ref_przedmiot(p_przedmiot);
        v_ref_nauczyciel := PKG_OSOBY.get_ref_nauczyciel(p_nauczyciel_nazwisko);
        v_ref_sala := PKG_SLOWNIKI.get_ref_sala(p_sala_numer);
        v_ref_grupa := PKG_SLOWNIKI.get_ref_grupa(p_grupa_kod);

        INSERT INTO LEKCJE (id_lekcji, ref_przedmiot, ref_nauczyciel, ref_sala, ref_uczen, ref_grupa, data_lekcji, godzina_start, czas_trwania_min, typ_lekcji, status, komisja)
        VALUES (seq_lekcje.NEXTVAL, v_ref_przedmiot, v_ref_nauczyciel, v_ref_sala, NULL, v_ref_grupa, p_data, p_godzina, p_czas_min, 'zwykla', 'zaplanowana', NULL);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Dodano lekcje grupowa: ' || p_przedmiot || ' dla ' || p_grupa_kod);
    END;

    PROCEDURE dodaj_egzamin(p_uczen_nazwisko VARCHAR2, p_uczen_imie VARCHAR2, p_sala_numer VARCHAR2, p_data DATE, p_godzina VARCHAR2, p_komisja_nazwisko1 VARCHAR2, p_komisja_nazwisko2 VARCHAR2, p_czas_min NUMBER DEFAULT 45) IS
        v_id_naucz1 NUMBER;
        v_id_naucz2 NUMBER;
        v_id_ucznia NUMBER;
        v_id_sali NUMBER;
        v_instrument_nazwa VARCHAR2(50);
        v_id_przedmiotu NUMBER;
        v_ref_uczen REF T_UCZEN;
        v_ref_przedmiot REF T_PRZEDMIOT;
        v_ref_nauczyciel REF T_NAUCZYCIEL;
        v_ref_sala REF T_SALA;
    BEGIN
        v_id_naucz1 := PKG_OSOBY.get_id_nauczyciel(p_komisja_nazwisko1);
        v_id_naucz2 := PKG_OSOBY.get_id_nauczyciel(p_komisja_nazwisko2);
        v_id_ucznia := PKG_OSOBY.get_id_uczen(p_uczen_nazwisko, p_uczen_imie);
        v_id_sali := PKG_SLOWNIKI.get_id_sala(p_sala_numer);

        IF v_id_naucz1 = v_id_naucz2 THEN
            RAISE_APPLICATION_ERROR(-20102, 'Komisja musi skladac sie z 2 ROZNYCH nauczycieli');
        END IF;

        v_instrument_nazwa := PKG_OSOBY.get_instrument_ucznia(v_id_ucznia);
        v_id_przedmiotu := PKG_SLOWNIKI.get_id_przedmiot(v_instrument_nazwa);

        waliduj_godziny_pracy(p_godzina, p_czas_min);
        waliduj_dzien_tygodnia(p_data);

        IF NOT czy_sala_wolna(v_id_sali, p_data, p_godzina, p_czas_min) THEN
            RAISE_APPLICATION_ERROR(-20010, 'Sala ' || p_sala_numer || ' zajeta');
        END IF;
        IF NOT czy_uczen_wolny(v_id_ucznia, p_data, p_godzina, p_czas_min) THEN
            RAISE_APPLICATION_ERROR(-20012, 'Uczen ma juz zajecia w tym terminie');
        END IF;
        IF NOT czy_nauczyciel_wolny(v_id_naucz1, p_data, p_godzina, p_czas_min) THEN
            RAISE_APPLICATION_ERROR(-20011, 'Nauczyciel ' || p_komisja_nazwisko1 || ' (komisja) zajety');
        END IF;
        IF NOT czy_nauczyciel_wolny(v_id_naucz2, p_data, p_godzina, p_czas_min) THEN
            RAISE_APPLICATION_ERROR(-20011, 'Nauczyciel ' || p_komisja_nazwisko2 || ' (komisja) zajety');
        END IF;

        v_ref_uczen := PKG_OSOBY.get_ref_uczen(p_uczen_nazwisko, p_uczen_imie);
        v_ref_przedmiot := PKG_SLOWNIKI.get_ref_przedmiot(v_instrument_nazwa);
        v_ref_nauczyciel := PKG_OSOBY.get_ref_nauczyciel_by_id(v_id_naucz1);
        v_ref_sala := PKG_SLOWNIKI.get_ref_sala(p_sala_numer);

        INSERT INTO LEKCJE (id_lekcji, ref_przedmiot, ref_nauczyciel, ref_sala, ref_uczen, ref_grupa, data_lekcji, godzina_start, czas_trwania_min, typ_lekcji, status, komisja)
        VALUES (seq_lekcje.NEXTVAL, v_ref_przedmiot, v_ref_nauczyciel, v_ref_sala, v_ref_uczen, NULL, p_data, p_godzina, p_czas_min, 'egzamin', 'zaplanowana', T_KOMISJA(v_id_naucz1, v_id_naucz2));
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Dodano egzamin dla: ' || p_uczen_imie || ' ' || p_uczen_nazwisko);
    END;

    PROCEDURE zmien_status_lekcji(p_id_lekcji NUMBER, p_nowy_status VARCHAR2) IS
    BEGIN
        UPDATE LEKCJE SET status = p_nowy_status WHERE id_lekcji = p_id_lekcji;
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20014, 'Lekcja o podanym ID nie istnieje');
        END IF;
        COMMIT;
    END;

    -- =======================================================================
    -- FUNKCJE PLANOW
    -- =======================================================================

    FUNCTION plan_ucznia(p_nazwisko VARCHAR2, p_imie VARCHAR2, p_data_od DATE, p_data_do DATE) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
        v_id_ucznia NUMBER;
        v_kod_grupy VARCHAR2(10);
    BEGIN
        v_id_ucznia := PKG_OSOBY.get_id_uczen(p_nazwisko, p_imie);
        v_kod_grupy := PKG_OSOBY.get_grupa_ucznia(v_id_ucznia);

        OPEN v_cursor FOR
            SELECT l.data_lekcji, l.godzina_start, l.czas_trwania_min,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
                   DEREF(l.ref_sala).numer AS sala,
                   l.typ_lekcji, l.status
            FROM LEKCJE l
            WHERE ((l.ref_uczen IS NOT NULL AND DEREF(l.ref_uczen).id_ucznia = v_id_ucznia)
                   OR (l.ref_grupa IS NOT NULL AND UPPER(DEREF(l.ref_grupa).kod) = UPPER(v_kod_grupy)))
              AND l.data_lekcji BETWEEN p_data_od AND p_data_do
            ORDER BY l.data_lekcji, l.godzina_start;
        RETURN v_cursor;
    END;

    FUNCTION plan_sali(p_numer_sali VARCHAR2, p_data DATE) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT l.godzina_start, l.czas_trwania_min,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
                   CASE WHEN l.ref_uczen IS NOT NULL THEN DEREF(l.ref_uczen).imie || ' ' || DEREF(l.ref_uczen).nazwisko
                        ELSE DEREF(l.ref_grupa).kod END AS kto,
                   l.typ_lekcji, l.status
            FROM LEKCJE l
            WHERE DEREF(l.ref_sala).numer = p_numer_sali AND l.data_lekcji = p_data
            ORDER BY l.godzina_start;
        RETURN v_cursor;
    END;

    FUNCTION plan_nauczyciela(p_nazwisko VARCHAR2, p_data_od DATE, p_data_do DATE) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT l.data_lekcji, l.godzina_start, l.czas_trwania_min,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_sala).numer AS sala,
                   CASE WHEN l.ref_uczen IS NOT NULL THEN DEREF(l.ref_uczen).imie || ' ' || DEREF(l.ref_uczen).nazwisko
                        ELSE DEREF(l.ref_grupa).kod END AS kto,
                   l.typ_lekcji, l.status
            FROM LEKCJE l
            WHERE UPPER(DEREF(l.ref_nauczyciel).nazwisko) = UPPER(p_nazwisko)
              AND l.data_lekcji BETWEEN p_data_od AND p_data_do
            ORDER BY l.data_lekcji, l.godzina_start;
        RETURN v_cursor;
    END;

    FUNCTION plan_grupy(p_kod_grupy VARCHAR2, p_data_od DATE, p_data_do DATE) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT l.data_lekcji, l.godzina_start, l.czas_trwania_min,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
                   DEREF(l.ref_sala).numer AS sala,
                   l.typ_lekcji, l.status
            FROM LEKCJE l
            WHERE l.ref_grupa IS NOT NULL
              AND UPPER(DEREF(l.ref_grupa).kod) = UPPER(p_kod_grupy)
              AND l.data_lekcji BETWEEN p_data_od AND p_data_do
            ORDER BY l.data_lekcji, l.godzina_start;
        RETURN v_cursor;
    END;

    FUNCTION egzaminy_ucznia(p_nazwisko VARCHAR2, p_imie VARCHAR2) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
        v_id_ucznia NUMBER;
    BEGIN
        v_id_ucznia := PKG_OSOBY.get_id_uczen(p_nazwisko, p_imie);
        OPEN v_cursor FOR
            SELECT l.data_lekcji, l.godzina_start,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_sala).numer AS sala,
                   l.komisja, l.status
            FROM LEKCJE l
            WHERE l.typ_lekcji = 'egzamin'
              AND l.ref_uczen IS NOT NULL
              AND DEREF(l.ref_uczen).id_ucznia = v_id_ucznia
            ORDER BY l.data_lekcji;
        RETURN v_cursor;
    END;

    -- Naprawione: zamiast l.komisja(1) uzywamy kursora FOR LOOP
    FUNCTION egzaminy_nauczyciela(p_nazwisko VARCHAR2) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
        v_id_nauczyciela NUMBER;
    BEGIN
        v_id_nauczyciela := PKG_OSOBY.get_id_nauczyciel(p_nazwisko);
        
        -- Najpierw zbieramy ID lekcji gdzie nauczyciel jest w komisji
        -- Uzywamy tabeli tymczasowej lub podzapytania z TABLE()
        OPEN v_cursor FOR
            SELECT l.data_lekcji, l.godzina_start,
                   DEREF(l.ref_uczen).imie || ' ' || DEREF(l.ref_uczen).nazwisko AS uczen,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_sala).numer AS sala,
                   l.status
            FROM LEKCJE l, TABLE(l.komisja) k
            WHERE l.typ_lekcji = 'egzamin'
              AND k.COLUMN_VALUE = v_id_nauczyciela
            ORDER BY l.data_lekcji;
        RETURN v_cursor;
    END;

    -- =======================================================================
    -- HEURYSTYKA PRZYDZIALU NAUCZYCIELA
    -- =======================================================================

    FUNCTION znajdz_nauczyciela_heurystyka(p_instrument VARCHAR2, p_data DATE, p_godzina VARCHAR2, p_czas_min NUMBER) RETURN VARCHAR2 IS
        v_nazwisko VARCHAR2(100);
        v_start_min NUMBER := godzina_na_minuty(p_godzina);
        v_koniec_min NUMBER := v_start_min + p_czas_min;
        v_lekcje_dzis NUMBER;
        v_godziny_dzis NUMBER;
        v_godziny_tydzien NUMBER;
        v_max_godzin_dzien NUMBER;
        v_max_godzin_tydzien NUMBER;
        v_jest_wolny BOOLEAN;
        v_min_lekcji NUMBER := 999999;
        v_poczatek_tyg DATE;
        v_koniec_tyg DATE;

        CURSOR c_nauczyciele IS
            SELECT n.id_nauczyciela, n.nazwisko, n.max_godzin_dziennie, n.max_godzin_tydzien
            FROM NAUCZYCIELE n
            WHERE p_instrument IN (SELECT COLUMN_VALUE FROM TABLE(n.instrumenty))
            ORDER BY n.nazwisko;
    BEGIN
        v_poczatek_tyg := TRUNC(p_data, 'IW');
        v_koniec_tyg := v_poczatek_tyg + 4;

        FOR naucz IN c_nauczyciele LOOP
            v_jest_wolny := czy_nauczyciel_wolny(naucz.id_nauczyciela, p_data, p_godzina, p_czas_min);

            IF v_jest_wolny THEN
                SELECT COUNT(*), NVL(SUM(l.czas_trwania_min), 0)
                INTO v_lekcje_dzis, v_godziny_dzis
                FROM LEKCJE l
                WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = naucz.id_nauczyciela
                  AND l.data_lekcji = p_data
                  AND l.status != 'odwolana';

                SELECT NVL(SUM(l.czas_trwania_min), 0)
                INTO v_godziny_tydzien
                FROM LEKCJE l
                WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = naucz.id_nauczyciela
                  AND l.data_lekcji BETWEEN v_poczatek_tyg AND v_koniec_tyg
                  AND l.status != 'odwolana';

                v_max_godzin_dzien := NVL(naucz.max_godzin_dziennie, 6) * 60;
                v_max_godzin_tydzien := NVL(naucz.max_godzin_tydzien, 30) * 60;

                IF (v_godziny_dzis + p_czas_min) <= v_max_godzin_dzien 
                   AND (v_godziny_tydzien + p_czas_min) <= v_max_godzin_tydzien THEN
                    IF v_lekcje_dzis < v_min_lekcji THEN
                        v_min_lekcji := v_lekcje_dzis;
                        v_nazwisko := naucz.nazwisko;
                    END IF;
                END IF;
            END IF;
        END LOOP;

        IF v_nazwisko IS NULL THEN
            RAISE_APPLICATION_ERROR(-20020, 'Brak dostepnego nauczyciela od instrumentu: ' || p_instrument || 
                ' w terminie ' || TO_CHAR(p_data, 'YYYY-MM-DD') || ' ' || p_godzina);
        END IF;

        RETURN v_nazwisko;
    END;

    PROCEDURE przydziel_lekcje_indywidualna(p_uczen_nazwisko VARCHAR2, p_uczen_imie VARCHAR2, p_data DATE, p_godzina VARCHAR2, p_czas_min NUMBER DEFAULT NULL) IS
        v_instrument VARCHAR2(50);
        v_nauczyciel VARCHAR2(100);
        v_sala VARCHAR2(10);
        v_klasa NUMBER;
        v_czas_lekcji NUMBER;
        v_start_min NUMBER := godzina_na_minuty(p_godzina);
        v_id_ucznia NUMBER;
        v_ref_przedmiot REF T_PRZEDMIOT;
        v_ref_nauczyciel REF T_NAUCZYCIEL;
        v_ref_sala REF T_SALA;
        v_ref_uczen REF T_UCZEN;
    BEGIN
        SELECT u.id_ucznia, DEREF(u.ref_instrument).nazwa, DEREF(u.ref_grupa).klasa
        INTO v_id_ucznia, v_instrument, v_klasa
        FROM UCZNIOWIE u
        WHERE UPPER(u.nazwisko) = UPPER(p_uczen_nazwisko) AND UPPER(u.imie) = UPPER(p_uczen_imie);

        IF p_czas_min IS NOT NULL THEN
            v_czas_lekcji := p_czas_min;
        ELSIF v_klasa <= 3 THEN
            v_czas_lekcji := 30;
        ELSE
            v_czas_lekcji := 45;
        END IF;

        v_nauczyciel := znajdz_nauczyciela_heurystyka(v_instrument, p_data, p_godzina, v_czas_lekcji);

        BEGIN
            SELECT s.numer INTO v_sala
            FROM (
                SELECT s.numer,
                       (SELECT COUNT(*) FROM LEKCJE l WHERE DEREF(l.ref_sala).id_sali = s.id_sali AND l.data_lekcji = p_data) AS liczba_lekcji
                FROM SALE s
                WHERE s.typ = 'indywidualna'
                  AND NOT EXISTS (
                    SELECT 1 FROM LEKCJE l
                    WHERE DEREF(l.ref_sala).id_sali = s.id_sali
                      AND l.data_lekcji = p_data
                      AND l.status != 'odwolana'
                      AND (TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))) < (v_start_min + v_czas_lekcji)
                      AND v_start_min < (TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania_min)
                )
                ORDER BY liczba_lekcji ASC
            ) s WHERE ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20021, 'Brak wolnej sali indywidualnej w terminie ' || TO_CHAR(p_data, 'YYYY-MM-DD') || ' ' || p_godzina);
        END;

        IF NOT czy_uczen_wolny(v_id_ucznia, p_data, p_godzina, v_czas_lekcji) THEN
            RAISE_APPLICATION_ERROR(-20012, 'Uczen zajety w tym terminie');
        END IF;

        v_ref_przedmiot := PKG_SLOWNIKI.get_ref_przedmiot(v_instrument);
        v_ref_nauczyciel := PKG_OSOBY.get_ref_nauczyciel(v_nauczyciel);
        v_ref_sala := PKG_SLOWNIKI.get_ref_sala(v_sala);
        v_ref_uczen := PKG_OSOBY.get_ref_uczen(p_uczen_nazwisko, p_uczen_imie);

        INSERT INTO LEKCJE (id_lekcji, ref_przedmiot, ref_nauczyciel, ref_sala, ref_uczen, ref_grupa, data_lekcji, godzina_start, czas_trwania_min, typ_lekcji, status, komisja)
        VALUES (seq_lekcje.NEXTVAL, v_ref_przedmiot, v_ref_nauczyciel, v_ref_sala, v_ref_uczen, NULL, p_data, p_godzina, v_czas_lekcji, 'zwykla', 'zaplanowana', NULL);

        DBMS_OUTPUT.PUT_LINE('Przydzielono: ' || p_uczen_imie || ' ' || p_uczen_nazwisko || ' (' || v_instrument || ', ' || v_czas_lekcji || ' min) -> ' || v_nauczyciel || ', sala ' || v_sala);
    END;

    -- =======================================================================
    -- GENEROWANIE PLANU SEMESTRALNEGO
    -- =======================================================================

    PROCEDURE generuj_lekcje_indywidualne_tydzien(p_data_poniedzialek DATE) IS
        v_dzien1 DATE;
        v_dzien2 DATE;
        v_godzina VARCHAR2(5);
        v_czas NUMBER;
        v_utworzono NUMBER := 0;
        v_bledy NUMBER := 0;
        v_sukces BOOLEAN;
        v_proba NUMBER;

        TYPE t_godziny IS TABLE OF VARCHAR2(5);
        v_godziny t_godziny := t_godziny('14:00','14:30','15:00','15:30','16:00','16:30','17:00','17:30','18:00','18:30','19:00');
        v_slot_idx NUMBER := 0;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== GENEROWANIE LEKCJI INDYWIDUALNYCH ===');
        DBMS_OUTPUT.PUT_LINE('Tydzien od: ' || TO_CHAR(p_data_poniedzialek, 'YYYY-MM-DD'));

        FOR uczen IN (
            SELECT u.id_ucznia, u.imie, u.nazwisko, 
                   DEREF(u.ref_instrument).nazwa AS instrument,
                   DEREF(u.ref_grupa).klasa AS klasa,
                   DEREF(u.ref_grupa).kod AS grupa
            FROM UCZNIOWIE u
            ORDER BY DEREF(u.ref_grupa).klasa, DEREF(u.ref_grupa).kod, u.nazwisko
        ) LOOP
            IF SUBSTR(uczen.grupa, -1) = 'A' THEN
                v_dzien1 := p_data_poniedzialek;
                v_dzien2 := p_data_poniedzialek + 2;
            ELSE
                v_dzien1 := p_data_poniedzialek + 1;
                v_dzien2 := p_data_poniedzialek + 3;
            END IF;

            IF uczen.klasa <= 3 THEN v_czas := 30; ELSE v_czas := 45; END IF;

            -- LEKCJA 1
            v_sukces := FALSE;
            v_proba := 0;
            WHILE NOT v_sukces AND v_proba < v_godziny.COUNT LOOP
                v_slot_idx := MOD(v_slot_idx + v_proba, v_godziny.COUNT) + 1;
                v_godzina := v_godziny(v_slot_idx);
                v_proba := v_proba + 1;
                BEGIN
                    przydziel_lekcje_indywidualna(uczen.nazwisko, uczen.imie, v_dzien1, v_godzina, v_czas);
                    v_utworzono := v_utworzono + 1;
                    v_sukces := TRUE;
                EXCEPTION WHEN OTHERS THEN NULL;
                END;
            END LOOP;
            IF NOT v_sukces THEN v_bledy := v_bledy + 1; DBMS_OUTPUT.PUT_LINE('BLAD: Lekcja 1 dla ' || uczen.imie || ' ' || uczen.nazwisko); END IF;

            -- LEKCJA 2
            v_sukces := FALSE;
            v_proba := 0;
            v_slot_idx := MOD(v_slot_idx + 1, v_godziny.COUNT);
            WHILE NOT v_sukces AND v_proba < v_godziny.COUNT LOOP
                v_slot_idx := MOD(v_slot_idx + v_proba, v_godziny.COUNT) + 1;
                v_godzina := v_godziny(v_slot_idx);
                v_proba := v_proba + 1;
                BEGIN
                    przydziel_lekcje_indywidualna(uczen.nazwisko, uczen.imie, v_dzien2, v_godzina, v_czas);
                    v_utworzono := v_utworzono + 1;
                    v_sukces := TRUE;
                EXCEPTION WHEN OTHERS THEN NULL;
                END;
            END LOOP;
            IF NOT v_sukces THEN v_bledy := v_bledy + 1; DBMS_OUTPUT.PUT_LINE('BLAD: Lekcja 2 dla ' || uczen.imie || ' ' || uczen.nazwisko); END IF;
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('Utworzono lekcji indywidualnych: ' || v_utworzono);
        IF v_bledy > 0 THEN DBMS_OUTPUT.PUT_LINE('Nieprzydzielonych: ' || v_bledy); END IF;
    END;

    PROCEDURE generuj_lekcje_grupowe_tydzien(p_data_poniedzialek DATE) IS
        v_utworzono NUMBER := 0;
        v_bledy NUMBER := 0;
        v_dzien DATE;
        TYPE t_nauczyciele IS TABLE OF VARCHAR2(100);
        v_nauczyciele_grupowi t_nauczyciele;
        v_idx_naucz NUMBER := 0;
        v_nauczyciel VARCHAR2(100);
        v_id_przedmiotu NUMBER;
        v_id_nauczyciela NUMBER;
        v_id_sali NUMBER;
        v_id_grupy NUMBER;
        v_ref_przedmiot REF T_PRZEDMIOT;
        v_ref_nauczyciel REF T_NAUCZYCIEL;
        v_ref_sala REF T_SALA;
        v_ref_grupa REF T_GRUPA;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== GENEROWANIE LEKCJI GRUPOWYCH ===');

        SELECT nazwisko BULK COLLECT INTO v_nauczyciele_grupowi FROM NAUCZYCIELE WHERE instrumenty IS NULL;

        IF v_nauczyciele_grupowi.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('BLAD: Brak nauczycieli przedmiotow grupowych!');
            RETURN;
        END IF;

        FOR grupa IN (SELECT g.kod, g.klasa, ROWNUM AS nr FROM GRUPY g ORDER BY g.klasa, g.kod) LOOP
            CASE MOD(grupa.nr - 1, 5)
                WHEN 0 THEN v_dzien := p_data_poniedzialek;
                WHEN 1 THEN v_dzien := p_data_poniedzialek + 1;
                WHEN 2 THEN v_dzien := p_data_poniedzialek + 2;
                WHEN 3 THEN v_dzien := p_data_poniedzialek + 3;
                WHEN 4 THEN v_dzien := p_data_poniedzialek + 4;
            END CASE;

            -- Ksztalcenie sluchu
            BEGIN
                v_idx_naucz := MOD(v_idx_naucz, v_nauczyciele_grupowi.COUNT) + 1;
                v_nauczyciel := v_nauczyciele_grupowi(v_idx_naucz);
                v_ref_przedmiot := PKG_SLOWNIKI.get_ref_przedmiot('Ksztalcenie sluchu');
                v_ref_nauczyciel := PKG_OSOBY.get_ref_nauczyciel(v_nauczyciel);
                v_ref_sala := PKG_SLOWNIKI.get_ref_sala('201');
                v_ref_grupa := PKG_SLOWNIKI.get_ref_grupa(grupa.kod);
                INSERT INTO LEKCJE (id_lekcji, ref_przedmiot, ref_nauczyciel, ref_sala, ref_uczen, ref_grupa, data_lekcji, godzina_start, czas_trwania_min, typ_lekcji, status, komisja)
                VALUES (seq_lekcje.NEXTVAL, v_ref_przedmiot, v_ref_nauczyciel, v_ref_sala, NULL, v_ref_grupa, v_dzien, '14:00', 45, 'zwykla', 'zaplanowana', NULL);
                v_utworzono := v_utworzono + 1;
            EXCEPTION WHEN OTHERS THEN v_bledy := v_bledy + 1; DBMS_OUTPUT.PUT_LINE('BLAD Ksztalcenie sluchu ' || grupa.kod); END;

            -- Rytmika - na inny dzien niz Ksztalcenie sluchu, sala 202
            BEGIN
                v_idx_naucz := MOD(v_idx_naucz, v_nauczyciele_grupowi.COUNT) + 1;
                v_nauczyciel := v_nauczyciele_grupowi(v_idx_naucz);
                v_ref_przedmiot := PKG_SLOWNIKI.get_ref_przedmiot('Rytmika');
                v_ref_nauczyciel := PKG_OSOBY.get_ref_nauczyciel(v_nauczyciel);
                v_ref_sala := PKG_SLOWNIKI.get_ref_sala('202');
                v_ref_grupa := PKG_SLOWNIKI.get_ref_grupa(grupa.kod);
                INSERT INTO LEKCJE (id_lekcji, ref_przedmiot, ref_nauczyciel, ref_sala, ref_uczen, ref_grupa, data_lekcji, godzina_start, czas_trwania_min, typ_lekcji, status, komisja)
                VALUES (seq_lekcje.NEXTVAL, v_ref_przedmiot, v_ref_nauczyciel, v_ref_sala, NULL, v_ref_grupa, v_dzien, '15:00', 45, 'zwykla', 'zaplanowana', NULL);
                v_utworzono := v_utworzono + 1;
            EXCEPTION WHEN OTHERS THEN v_bledy := v_bledy + 1; DBMS_OUTPUT.PUT_LINE('BLAD Rytmika ' || grupa.kod); END;

            -- Audycje muzyczne
            BEGIN
                v_idx_naucz := MOD(v_idx_naucz, v_nauczyciele_grupowi.COUNT) + 1;
                v_nauczyciel := v_nauczyciele_grupowi(v_idx_naucz);
                v_ref_przedmiot := PKG_SLOWNIKI.get_ref_przedmiot('Audycje muzyczne');
                v_ref_nauczyciel := PKG_OSOBY.get_ref_nauczyciel(v_nauczyciel);
                v_ref_sala := PKG_SLOWNIKI.get_ref_sala('201');
                v_ref_grupa := PKG_SLOWNIKI.get_ref_grupa(grupa.kod);
                INSERT INTO LEKCJE (id_lekcji, ref_przedmiot, ref_nauczyciel, ref_sala, ref_uczen, ref_grupa, data_lekcji, godzina_start, czas_trwania_min, typ_lekcji, status, komisja)
                VALUES (seq_lekcje.NEXTVAL, v_ref_przedmiot, v_ref_nauczyciel, v_ref_sala, NULL, v_ref_grupa, v_dzien, '16:00', 45, 'zwykla', 'zaplanowana', NULL);
                v_utworzono := v_utworzono + 1;
            EXCEPTION WHEN OTHERS THEN v_bledy := v_bledy + 1; DBMS_OUTPUT.PUT_LINE('BLAD Audycje ' || grupa.kod); END;

            -- Chor i Orkiestra dla klas IV-VI
            IF grupa.klasa >= 4 THEN
                BEGIN
                    v_idx_naucz := MOD(v_idx_naucz, v_nauczyciele_grupowi.COUNT) + 1;
                    v_nauczyciel := v_nauczyciele_grupowi(v_idx_naucz);
                    v_ref_przedmiot := PKG_SLOWNIKI.get_ref_przedmiot('Chor');
                    v_ref_nauczyciel := PKG_OSOBY.get_ref_nauczyciel(v_nauczyciel);
                    v_ref_sala := PKG_SLOWNIKI.get_ref_sala('202');
                    v_ref_grupa := PKG_SLOWNIKI.get_ref_grupa(grupa.kod);
                    INSERT INTO LEKCJE (id_lekcji, ref_przedmiot, ref_nauczyciel, ref_sala, ref_uczen, ref_grupa, data_lekcji, godzina_start, czas_trwania_min, typ_lekcji, status, komisja)
                    VALUES (seq_lekcje.NEXTVAL, v_ref_przedmiot, v_ref_nauczyciel, v_ref_sala, NULL, v_ref_grupa, p_data_poniedzialek + 1, '17:00', 90, 'zwykla', 'zaplanowana', NULL);
                    v_utworzono := v_utworzono + 1;
                EXCEPTION WHEN OTHERS THEN v_bledy := v_bledy + 1; DBMS_OUTPUT.PUT_LINE('BLAD Chor ' || grupa.kod); END;

                BEGIN
                    v_idx_naucz := MOD(v_idx_naucz, v_nauczyciele_grupowi.COUNT) + 1;
                    v_nauczyciel := v_nauczyciele_grupowi(v_idx_naucz);
                    v_ref_przedmiot := PKG_SLOWNIKI.get_ref_przedmiot('Orkiestra');
                    v_ref_nauczyciel := PKG_OSOBY.get_ref_nauczyciel(v_nauczyciel);
                    v_ref_sala := PKG_SLOWNIKI.get_ref_sala('202');
                    v_ref_grupa := PKG_SLOWNIKI.get_ref_grupa(grupa.kod);
                    INSERT INTO LEKCJE (id_lekcji, ref_przedmiot, ref_nauczyciel, ref_sala, ref_uczen, ref_grupa, data_lekcji, godzina_start, czas_trwania_min, typ_lekcji, status, komisja)
                    VALUES (seq_lekcje.NEXTVAL, v_ref_przedmiot, v_ref_nauczyciel, v_ref_sala, NULL, v_ref_grupa, p_data_poniedzialek + 3, '17:00', 90, 'zwykla', 'zaplanowana', NULL);
                    v_utworzono := v_utworzono + 1;
                EXCEPTION WHEN OTHERS THEN v_bledy := v_bledy + 1; DBMS_OUTPUT.PUT_LINE('BLAD Orkiestra ' || grupa.kod); END;
            END IF;
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('Utworzono lekcji grupowych: ' || v_utworzono);
        IF v_bledy > 0 THEN DBMS_OUTPUT.PUT_LINE('Bledy: ' || v_bledy); END IF;
    END;

    PROCEDURE generuj_plan_tygodnia(p_data_poniedzialek DATE) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('========================================');
        DBMS_OUTPUT.PUT_LINE('GENEROWANIE PLANU TYGODNIA');
        DBMS_OUTPUT.PUT_LINE('Poczatek: ' || TO_CHAR(p_data_poniedzialek, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('========================================');

        generuj_lekcje_grupowe_tydzien(p_data_poniedzialek);
        DBMS_OUTPUT.PUT_LINE('');
        generuj_lekcje_indywidualne_tydzien(p_data_poniedzialek);

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('PLAN WYGENEROWANY I ZATWIERDZONY');
        DBMS_OUTPUT.PUT_LINE('========================================');
    END;

END PKG_LEKCJE;
/

-- ============================================================================
-- 5. PAKIET PKG_OCENY - Zarzadzanie ocenami
-- ============================================================================

CREATE OR REPLACE PACKAGE PKG_OCENY AS
    PROCEDURE wystaw_ocene(p_uczen_nazwisko VARCHAR2, p_uczen_imie VARCHAR2, p_nauczyciel_nazwisko VARCHAR2, p_przedmiot VARCHAR2, p_wartosc NUMBER, p_obszar VARCHAR2 DEFAULT 'ogolna', p_komentarz VARCHAR2 DEFAULT NULL);
    PROCEDURE wystaw_ocene_semestralna(p_uczen_nazwisko VARCHAR2, p_uczen_imie VARCHAR2, p_nauczyciel_nazwisko VARCHAR2, p_przedmiot VARCHAR2, p_wartosc NUMBER, p_komentarz VARCHAR2 DEFAULT NULL);
    FUNCTION srednia_ucznia(p_uczen_nazwisko VARCHAR2, p_uczen_imie VARCHAR2, p_przedmiot VARCHAR2) RETURN NUMBER;
    FUNCTION oceny_ucznia(p_uczen_nazwisko VARCHAR2, p_uczen_imie VARCHAR2) RETURN SYS_REFCURSOR;
    PROCEDURE statystyki_ucznia(p_uczen_nazwisko VARCHAR2, p_uczen_imie VARCHAR2);
END PKG_OCENY;
/

CREATE OR REPLACE PACKAGE BODY PKG_OCENY AS

    PROCEDURE wystaw_ocene(p_uczen_nazwisko VARCHAR2, p_uczen_imie VARCHAR2, p_nauczyciel_nazwisko VARCHAR2, p_przedmiot VARCHAR2, p_wartosc NUMBER, p_obszar VARCHAR2 DEFAULT 'ogolna', p_komentarz VARCHAR2 DEFAULT NULL) IS
        v_ref_uczen REF T_UCZEN;
        v_ref_nauczyciel REF T_NAUCZYCIEL;
        v_ref_przedmiot REF T_PRZEDMIOT;
    BEGIN
        IF p_wartosc < 1 OR p_wartosc > 6 THEN
            RAISE_APPLICATION_ERROR(-20105, 'Ocena musi byc w zakresie 1-6. Podano: ' || p_wartosc);
        END IF;
        v_ref_uczen := PKG_OSOBY.get_ref_uczen(p_uczen_nazwisko, p_uczen_imie);
        v_ref_nauczyciel := PKG_OSOBY.get_ref_nauczyciel(p_nauczyciel_nazwisko);
        v_ref_przedmiot := PKG_SLOWNIKI.get_ref_przedmiot(p_przedmiot);
        INSERT INTO OCENY (id_oceny, ref_uczen, ref_nauczyciel, ref_przedmiot, wartosc, obszar, data_wystawienia, komentarz, czy_semestralna)
        VALUES (seq_oceny.NEXTVAL, v_ref_uczen, v_ref_nauczyciel, v_ref_przedmiot, p_wartosc, p_obszar, SYSDATE, p_komentarz, 'N');
        COMMIT;
    END;

    PROCEDURE wystaw_ocene_semestralna(p_uczen_nazwisko VARCHAR2, p_uczen_imie VARCHAR2, p_nauczyciel_nazwisko VARCHAR2, p_przedmiot VARCHAR2, p_wartosc NUMBER, p_komentarz VARCHAR2 DEFAULT NULL) IS
        v_ref_uczen REF T_UCZEN;
        v_ref_nauczyciel REF T_NAUCZYCIEL;
        v_ref_przedmiot REF T_PRZEDMIOT;
    BEGIN
        IF p_wartosc < 1 OR p_wartosc > 6 THEN
            RAISE_APPLICATION_ERROR(-20105, 'Ocena musi byc w zakresie 1-6. Podano: ' || p_wartosc);
        END IF;
        v_ref_uczen := PKG_OSOBY.get_ref_uczen(p_uczen_nazwisko, p_uczen_imie);
        v_ref_nauczyciel := PKG_OSOBY.get_ref_nauczyciel(p_nauczyciel_nazwisko);
        v_ref_przedmiot := PKG_SLOWNIKI.get_ref_przedmiot(p_przedmiot);
        INSERT INTO OCENY (id_oceny, ref_uczen, ref_nauczyciel, ref_przedmiot, wartosc, obszar, data_wystawienia, komentarz, czy_semestralna)
        VALUES (seq_oceny.NEXTVAL, v_ref_uczen, v_ref_nauczyciel, v_ref_przedmiot, p_wartosc, 'ogolna', SYSDATE, p_komentarz, 'T');
        COMMIT;
    END;

    FUNCTION srednia_ucznia(p_uczen_nazwisko VARCHAR2, p_uczen_imie VARCHAR2, p_przedmiot VARCHAR2) RETURN NUMBER IS
        v_srednia NUMBER;
        v_id_ucznia NUMBER;
    BEGIN
        v_id_ucznia := PKG_OSOBY.get_id_uczen(p_uczen_nazwisko, p_uczen_imie);
        SELECT ROUND(AVG(o.wartosc), 2) INTO v_srednia
        FROM OCENY o
        WHERE DEREF(o.ref_uczen).id_ucznia = v_id_ucznia
          AND UPPER(DEREF(o.ref_przedmiot).nazwa) = UPPER(p_przedmiot)
          AND o.czy_semestralna = 'N';
        RETURN NVL(v_srednia, 0);
    END;

    FUNCTION oceny_ucznia(p_uczen_nazwisko VARCHAR2, p_uczen_imie VARCHAR2) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
        v_id_ucznia NUMBER;
    BEGIN
        v_id_ucznia := PKG_OSOBY.get_id_uczen(p_uczen_nazwisko, p_uczen_imie);
        OPEN v_cursor FOR
            SELECT DEREF(o.ref_przedmiot).nazwa AS przedmiot, o.wartosc, o.obszar, o.data_wystawienia,
                   DEREF(o.ref_nauczyciel).nazwisko AS nauczyciel, o.czy_semestralna, o.komentarz
            FROM OCENY o WHERE DEREF(o.ref_uczen).id_ucznia = v_id_ucznia
            ORDER BY o.data_wystawienia DESC;
        RETURN v_cursor;
    END;

    PROCEDURE statystyki_ucznia(p_uczen_nazwisko VARCHAR2, p_uczen_imie VARCHAR2) IS
        v_grupa VARCHAR2(10);
        v_klasa NUMBER;
        v_instrument VARCHAR2(50);
        v_liczba_ocen NUMBER;
        v_srednia_ogolna NUMBER;
        v_id_ucznia NUMBER;
    BEGIN
        v_id_ucznia := PKG_OSOBY.get_id_uczen(p_uczen_nazwisko, p_uczen_imie);
        v_grupa := PKG_OSOBY.get_grupa_ucznia(v_id_ucznia);
        v_klasa := PKG_OSOBY.get_klasa_ucznia(v_id_ucznia);
        v_instrument := PKG_OSOBY.get_instrument_ucznia(v_id_ucznia);

        SELECT COUNT(*), ROUND(AVG(o.wartosc), 2) INTO v_liczba_ocen, v_srednia_ogolna
        FROM OCENY o WHERE DEREF(o.ref_uczen).id_ucznia = v_id_ucznia AND o.czy_semestralna = 'N';

        DBMS_OUTPUT.PUT_LINE('=== STATYSTYKI UCZNIA ===');
        DBMS_OUTPUT.PUT_LINE('Uczen: ' || p_uczen_imie || ' ' || p_uczen_nazwisko);
        DBMS_OUTPUT.PUT_LINE('Grupa: ' || v_grupa || ' (klasa ' || v_klasa || ')');
        DBMS_OUTPUT.PUT_LINE('Instrument: ' || v_instrument);
        DBMS_OUTPUT.PUT_LINE('Liczba ocen: ' || v_liczba_ocen);
        DBMS_OUTPUT.PUT_LINE('Srednia: ' || NVL(TO_CHAR(v_srednia_ogolna), 'brak'));
    END;

END PKG_OCENY;
/

-- ============================================================================
-- 6. PAKIET PKG_RAPORTY - Raporty i statystyki
-- ============================================================================

CREATE OR REPLACE PACKAGE PKG_RAPORTY AS
    PROCEDURE raport_grup;
    PROCEDURE raport_obciazenia_sal(p_data DATE);
    PROCEDURE raport_nauczycieli;
    PROCEDURE raport_instrumentow;
    PROCEDURE statystyki_ocen_przedmiotu(p_przedmiot VARCHAR2);
END PKG_RAPORTY;
/

CREATE OR REPLACE PACKAGE BODY PKG_RAPORTY AS

    PROCEDURE raport_grup IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== RAPORT GRUP ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('Grupa', 10) || RPAD('Klasa', 8) || 'Uczniow');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 30, '-'));
        FOR r IN (
            SELECT g.kod, g.klasa, COUNT(u.id_ucznia) AS liczba
            FROM GRUPY g LEFT JOIN UCZNIOWIE u ON DEREF(u.ref_grupa).id_grupy = g.id_grupy
            GROUP BY g.kod, g.klasa ORDER BY g.klasa, g.kod
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(RPAD(r.kod, 10) || RPAD(r.klasa, 8) || r.liczba);
        END LOOP;
    END;

    PROCEDURE raport_obciazenia_sal(p_data DATE) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== OBCIAZENIE SAL: ' || TO_CHAR(p_data, 'YYYY-MM-DD') || ' ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('Sala', 8) || RPAD('Typ', 15) || 'Lekcji');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 35, '-'));
        FOR r IN (
            SELECT s.numer, s.typ, COUNT(l.id_lekcji) AS liczba
            FROM SALE s LEFT JOIN LEKCJE l ON DEREF(l.ref_sala).id_sali = s.id_sali AND l.data_lekcji = p_data AND l.status != 'odwolana'
            GROUP BY s.numer, s.typ ORDER BY s.numer
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(RPAD(r.numer, 8) || RPAD(r.typ, 15) || r.liczba);
        END LOOP;
    END;

    PROCEDURE raport_nauczycieli IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== RAPORT NAUCZYCIELI ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('Nazwisko', 15) || 'Instrumenty');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 55, '-'));
        FOR r IN (
            SELECT n.nazwisko,
                   (SELECT LISTAGG(COLUMN_VALUE, ', ') WITHIN GROUP (ORDER BY COLUMN_VALUE) FROM TABLE(n.instrumenty)) AS instr_lista
            FROM NAUCZYCIELE n ORDER BY n.nazwisko
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(RPAD(r.nazwisko, 15) || NVL(r.instr_lista, '(przedmioty grupowe)'));
        END LOOP;
    END;

    PROCEDURE raport_instrumentow IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== ROZKLAD INSTRUMENTOW ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('Instrument', 15) || RPAD('Uczniow', 10) || 'Procent');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 35, '-'));
        FOR r IN (
            SELECT i.nazwa, COUNT(u.id_ucznia) AS liczba,
                   ROUND(COUNT(u.id_ucznia) * 100.0 / NULLIF((SELECT COUNT(*) FROM UCZNIOWIE), 0), 1) AS procent
            FROM INSTRUMENTY i LEFT JOIN UCZNIOWIE u ON DEREF(u.ref_instrument).id_instrumentu = i.id_instrumentu
            GROUP BY i.nazwa ORDER BY liczba DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(RPAD(r.nazwa, 15) || RPAD(r.liczba, 10) || r.procent || '%');
        END LOOP;
    END;

    PROCEDURE statystyki_ocen_przedmiotu(p_przedmiot VARCHAR2) IS
        v_count NUMBER;
        v_srednia NUMBER;
        v_min NUMBER;
        v_max NUMBER;
    BEGIN
        SELECT COUNT(*), ROUND(AVG(o.wartosc), 2), MIN(o.wartosc), MAX(o.wartosc)
        INTO v_count, v_srednia, v_min, v_max
        FROM OCENY o WHERE UPPER(DEREF(o.ref_przedmiot).nazwa) = UPPER(p_przedmiot) AND o.czy_semestralna = 'N';

        DBMS_OUTPUT.PUT_LINE('=== STATYSTYKI OCEN: ' || p_przedmiot || ' ===');
        DBMS_OUTPUT.PUT_LINE('Liczba ocen: ' || v_count);
        DBMS_OUTPUT.PUT_LINE('Srednia: ' || NVL(TO_CHAR(v_srednia), 'brak'));
        DBMS_OUTPUT.PUT_LINE('Min: ' || NVL(TO_CHAR(v_min), 'brak'));
        DBMS_OUTPUT.PUT_LINE('Max: ' || NVL(TO_CHAR(v_max), 'brak'));
    END;

END PKG_RAPORTY;
/

-- ============================================================================
-- 7. POTWIERDZENIE
-- ============================================================================

PROMPT
PROMPT === SPRAWDZENIE KOMPILACJI PAKIETOW ===
PROMPT

SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('PACKAGE', 'PACKAGE BODY')
ORDER BY object_name, object_type;

SELECT 'Pakiety v3 utworzone!' AS status FROM DUAL;
