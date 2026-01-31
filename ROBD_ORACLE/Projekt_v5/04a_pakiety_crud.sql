-- ============================================================================
-- PLIK: 04a_pakiety_crud.sql
-- PROJEKT: Szkola Muzyczna v5 - Obiektowa Baza Danych Oracle
-- AUTORZY: Igor Typinski (251237), Mateusz Mroz (251190)
-- DATA: Styczen 2026
-- ============================================================================
-- KOMPLETNE CRUD + WYSWIETLANIE dla WSZYSTKICH tabel
-- Pakiety: pkg_semestr, pkg_instrument, pkg_sala, pkg_grupa, pkg_przedmiot,
--          pkg_egzamin + rozszerzenia pkg_uczen, pkg_nauczyciel, pkg_lekcja, pkg_ocena
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200
SET PAGESIZE 50

PROMPT ========================================================================
PROMPT   04a_pakiety_crud.sql - PELNE CRUD dla wszystkich tabel
PROMPT ========================================================================
PROMPT

-- ============================================================================
-- 1. PAKIET: PKG_SEMESTR
-- CRUD + walidacja dat + wyswietlanie
-- ============================================================================

PROMPT [1/10] Tworzenie pakietu pkg_semestr...

CREATE OR REPLACE PACKAGE pkg_semestr AS

    -- ========== CREATE ==========
    PROCEDURE dodaj(
        p_nazwa      VARCHAR2,
        p_data_start DATE,
        p_data_koniec DATE,
        p_rok_szkolny VARCHAR2
    );

    -- ========== READ ==========
    PROCEDURE wyswietl_wszystkie;
    PROCEDURE wyswietl_jeden(p_id NUMBER);
    FUNCTION pobierz_aktualny RETURN NUMBER;

    -- ========== UPDATE ==========
    PROCEDURE aktualizuj(
        p_id          NUMBER,
        p_nazwa       VARCHAR2 DEFAULT NULL,
        p_data_start  DATE DEFAULT NULL,
        p_data_koniec DATE DEFAULT NULL
    );

    -- ========== DELETE ==========
    PROCEDURE usun(p_id NUMBER);

    -- ========== WALIDACJA ==========
    FUNCTION czy_data_w_semestrze(p_data DATE, p_id_semestru NUMBER) RETURN CHAR;

END pkg_semestr;
/

CREATE OR REPLACE PACKAGE BODY pkg_semestr AS

    PROCEDURE dodaj(
        p_nazwa      VARCHAR2,
        p_data_start DATE,
        p_data_koniec DATE,
        p_rok_szkolny VARCHAR2
    ) IS
        v_id NUMBER;
    BEGIN
        -- Walidacja dat
        IF p_data_koniec <= p_data_start THEN
            RAISE_APPLICATION_ERROR(-20100, 'Data konca musi byc po dacie startu');
        END IF;
        
        -- Walidacja formatu roku
        IF NOT REGEXP_LIKE(p_rok_szkolny, '^\d{4}/\d{4}$') THEN
            RAISE_APPLICATION_ERROR(-20101, 'Format roku: RRRR/RRRR (np. 2025/2026)');
        END IF;
        
        SELECT seq_semestry.NEXTVAL INTO v_id FROM dual;
        
        INSERT INTO semestry VALUES (t_semestr_obj(
            v_id, p_nazwa, p_data_start, p_data_koniec, p_rok_szkolny
        ));
        
        DBMS_OUTPUT.PUT_LINE('[OK] Dodano semestr: ' || p_nazwa || ' (ID=' || v_id || ')');
        COMMIT;
    END;

    PROCEDURE wyswietl_wszystkie IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== WSZYSTKIE SEMESTRY ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('ID', 5) || RPAD('NAZWA', 25) || RPAD('OD', 12) || RPAD('DO', 12) || 'ROK');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 70, '-'));
        
        FOR r IN (
            SELECT * FROM semestry ORDER BY data_start DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.id_semestru, 5) ||
                RPAD(r.nazwa, 25) ||
                RPAD(TO_CHAR(r.data_start, 'YYYY-MM-DD'), 12) ||
                RPAD(TO_CHAR(r.data_koniec, 'YYYY-MM-DD'), 12) ||
                r.rok_szkolny
            );
        END LOOP;
    END;

    PROCEDURE wyswietl_jeden(p_id NUMBER) IS
        r semestry%ROWTYPE;
    BEGIN
        SELECT * INTO r FROM semestry WHERE id_semestru = p_id;
        
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== SEMESTR ID=' || p_id || ' ===');
        DBMS_OUTPUT.PUT_LINE('Nazwa:       ' || r.nazwa);
        DBMS_OUTPUT.PUT_LINE('Data start:  ' || TO_CHAR(r.data_start, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Data koniec: ' || TO_CHAR(r.data_koniec, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Rok szkolny: ' || r.rok_szkolny);
        DBMS_OUTPUT.PUT_LINE('Czas trwania: ' || VALUE(r).czas_trwania_dni() || ' dni');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('[BLAD] Semestr ID=' || p_id || ' nie istnieje');
    END;

    FUNCTION pobierz_aktualny RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT id_semestru INTO v_id
        FROM semestry
        WHERE SYSDATE BETWEEN data_start AND data_koniec
        FETCH FIRST 1 ROW ONLY;
        RETURN v_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END;

    PROCEDURE aktualizuj(
        p_id          NUMBER,
        p_nazwa       VARCHAR2 DEFAULT NULL,
        p_data_start  DATE DEFAULT NULL,
        p_data_koniec DATE DEFAULT NULL
    ) IS
    BEGIN
        UPDATE semestry SET
            nazwa = NVL(p_nazwa, nazwa),
            data_start = NVL(p_data_start, data_start),
            data_koniec = NVL(p_data_koniec, data_koniec)
        WHERE id_semestru = p_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20102, 'Semestr ID=' || p_id || ' nie istnieje');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[OK] Zaktualizowano semestr ID=' || p_id);
        COMMIT;
    END;

    PROCEDURE usun(p_id NUMBER) IS
    BEGIN
        DELETE FROM semestry WHERE id_semestru = p_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20103, 'Semestr ID=' || p_id || ' nie istnieje');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[OK] Usunieto semestr ID=' || p_id);
        COMMIT;
    END;

    FUNCTION czy_data_w_semestrze(p_data DATE, p_id_semestru NUMBER) RETURN CHAR IS
        v_cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_cnt
        FROM semestry
        WHERE id_semestru = p_id_semestru
          AND p_data BETWEEN data_start AND data_koniec;
        RETURN CASE WHEN v_cnt > 0 THEN 'T' ELSE 'N' END;
    END;

END pkg_semestr;
/

-- ============================================================================
-- 2. PAKIET: PKG_INSTRUMENT
-- CRUD + walidacja unikalnosci
-- ============================================================================

PROMPT [2/10] Tworzenie pakietu pkg_instrument...

CREATE OR REPLACE PACKAGE pkg_instrument AS

    PROCEDURE dodaj(
        p_nazwa     VARCHAR2,
        p_kategoria VARCHAR2,
        p_akomp     CHAR DEFAULT 'N'
    );

    PROCEDURE wyswietl_wszystkie;
    PROCEDURE wyswietl_jeden(p_id NUMBER);
    FUNCTION znajdz_po_nazwie(p_nazwa VARCHAR2) RETURN NUMBER;

    PROCEDURE aktualizuj(
        p_id        NUMBER,
        p_nazwa     VARCHAR2 DEFAULT NULL,
        p_kategoria VARCHAR2 DEFAULT NULL,
        p_akomp     CHAR DEFAULT NULL
    );

    PROCEDURE usun(p_id NUMBER);
    FUNCTION liczba_uczniow(p_id NUMBER) RETURN NUMBER;

END pkg_instrument;
/

CREATE OR REPLACE PACKAGE BODY pkg_instrument AS

    PROCEDURE dodaj(
        p_nazwa     VARCHAR2,
        p_kategoria VARCHAR2,
        p_akomp     CHAR DEFAULT 'N'
    ) IS
        v_id NUMBER;
        v_cnt NUMBER;
    BEGIN
        -- Walidacja unikalnosci nazwy
        SELECT COUNT(*) INTO v_cnt FROM instrumenty WHERE UPPER(nazwa) = UPPER(p_nazwa);
        IF v_cnt > 0 THEN
            RAISE_APPLICATION_ERROR(-20110, 'Instrument o nazwie "' || p_nazwa || '" juz istnieje');
        END IF;
        
        -- Walidacja kategorii
        IF p_kategoria NOT IN ('klawiszowe', 'strunowe', 'dete', 'perkusyjne') THEN
            RAISE_APPLICATION_ERROR(-20111, 'Niepoprawna kategoria. Dozwolone: klawiszowe, strunowe, dete, perkusyjne');
        END IF;
        
        SELECT seq_instrumenty.NEXTVAL INTO v_id FROM dual;
        
        INSERT INTO instrumenty VALUES (t_instrument_obj(v_id, p_nazwa, p_kategoria, p_akomp));
        
        DBMS_OUTPUT.PUT_LINE('[OK] Dodano instrument: ' || p_nazwa || ' (ID=' || v_id || ')');
        COMMIT;
    END;

    PROCEDURE wyswietl_wszystkie IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== WSZYSTKIE INSTRUMENTY ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('ID', 5) || RPAD('NAZWA', 25) || RPAD('KATEGORIA', 15) || 'AKOMP');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 55, '-'));
        
        FOR r IN (
            SELECT * FROM instrumenty ORDER BY kategoria, nazwa
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.id_instrumentu, 5) ||
                RPAD(r.nazwa, 25) ||
                RPAD(r.kategoria, 15) ||
                r.czy_wymaga_akompaniatora
            );
        END LOOP;
    END;

    PROCEDURE wyswietl_jeden(p_id NUMBER) IS
        r instrumenty%ROWTYPE;
    BEGIN
        SELECT * INTO r FROM instrumenty WHERE id_instrumentu = p_id;
        
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== INSTRUMENT ID=' || p_id || ' ===');
        DBMS_OUTPUT.PUT_LINE('Nazwa:     ' || r.nazwa);
        DBMS_OUTPUT.PUT_LINE('Kategoria: ' || r.kategoria);
        DBMS_OUTPUT.PUT_LINE('Akompaniator: ' || CASE r.czy_wymaga_akompaniatora WHEN 'T' THEN 'TAK' ELSE 'NIE' END);
        DBMS_OUTPUT.PUT_LINE('Uczniow:   ' || liczba_uczniow(p_id));
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('[BLAD] Instrument ID=' || p_id || ' nie istnieje');
    END;

    FUNCTION znajdz_po_nazwie(p_nazwa VARCHAR2) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT id_instrumentu INTO v_id FROM instrumenty WHERE UPPER(nazwa) = UPPER(p_nazwa);
        RETURN v_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END;

    PROCEDURE aktualizuj(
        p_id        NUMBER,
        p_nazwa     VARCHAR2 DEFAULT NULL,
        p_kategoria VARCHAR2 DEFAULT NULL,
        p_akomp     CHAR DEFAULT NULL
    ) IS
    BEGIN
        UPDATE instrumenty SET
            nazwa = NVL(p_nazwa, nazwa),
            kategoria = NVL(p_kategoria, kategoria),
            czy_wymaga_akompaniatora = NVL(p_akomp, czy_wymaga_akompaniatora)
        WHERE id_instrumentu = p_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20112, 'Instrument ID=' || p_id || ' nie istnieje');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[OK] Zaktualizowano instrument ID=' || p_id);
        COMMIT;
    END;

    PROCEDURE usun(p_id NUMBER) IS
        v_cnt NUMBER;
    BEGIN
        -- Sprawdz czy sa uczniowie
        SELECT COUNT(*) INTO v_cnt FROM uczniowie WHERE DEREF(ref_instrument).id_instrumentu = p_id;
        IF v_cnt > 0 THEN
            RAISE_APPLICATION_ERROR(-20113, 'Nie mozna usunac - ' || v_cnt || ' uczniow gra na tym instrumencie');
        END IF;
        
        DELETE FROM instrumenty WHERE id_instrumentu = p_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20114, 'Instrument ID=' || p_id || ' nie istnieje');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[OK] Usunieto instrument ID=' || p_id);
        COMMIT;
    END;

    FUNCTION liczba_uczniow(p_id NUMBER) RETURN NUMBER IS
        v_cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_cnt FROM uczniowie WHERE DEREF(ref_instrument).id_instrumentu = p_id;
        RETURN v_cnt;
    END;

END pkg_instrument;
/

-- ============================================================================
-- 3. PAKIET: PKG_SALA
-- CRUD + sprawdzanie dostepnosci
-- ============================================================================

PROMPT [3/10] Tworzenie pakietu pkg_sala...

CREATE OR REPLACE PACKAGE pkg_sala AS

    PROCEDURE dodaj(
        p_numer       VARCHAR2,
        p_typ         VARCHAR2,
        p_pojemnosc   NUMBER,
        p_wyposazenie t_lista_sprzetu DEFAULT NULL
    );

    PROCEDURE wyswietl_wszystkie;
    PROCEDURE wyswietl_jedna(p_id NUMBER);

    PROCEDURE aktualizuj(
        p_id          NUMBER,
        p_numer       VARCHAR2 DEFAULT NULL,
        p_typ         VARCHAR2 DEFAULT NULL,
        p_pojemnosc   NUMBER DEFAULT NULL,
        p_status      VARCHAR2 DEFAULT NULL
    );

    PROCEDURE usun(p_id NUMBER);
    PROCEDURE zmien_status(p_id NUMBER, p_status VARCHAR2);
    FUNCTION czy_wolna(p_id NUMBER, p_data DATE, p_godz_od VARCHAR2, p_godz_do VARCHAR2) RETURN CHAR;

END pkg_sala;
/

CREATE OR REPLACE PACKAGE BODY pkg_sala AS

    PROCEDURE dodaj(
        p_numer       VARCHAR2,
        p_typ         VARCHAR2,
        p_pojemnosc   NUMBER,
        p_wyposazenie t_lista_sprzetu DEFAULT NULL
    ) IS
        v_id NUMBER;
        v_cnt NUMBER;
    BEGIN
        -- Walidacja unikalnosci numeru
        SELECT COUNT(*) INTO v_cnt FROM sale WHERE UPPER(numer) = UPPER(p_numer);
        IF v_cnt > 0 THEN
            RAISE_APPLICATION_ERROR(-20120, 'Sala o numerze "' || p_numer || '" juz istnieje');
        END IF;
        
        -- Walidacja typu
        IF p_typ NOT IN ('indywidualna', 'grupowa', 'wielofunkcyjna') THEN
            RAISE_APPLICATION_ERROR(-20121, 'Niepoprawny typ sali. Dozwolone: indywidualna, grupowa, wielofunkcyjna');
        END IF;
        
        SELECT seq_sale.NEXTVAL INTO v_id FROM dual;
        
        INSERT INTO sale VALUES (t_sala_obj(v_id, p_numer, p_typ, p_pojemnosc, p_wyposazenie, 'aktywna'));
        
        DBMS_OUTPUT.PUT_LINE('[OK] Dodano sale: ' || p_numer || ' (ID=' || v_id || ')');
        COMMIT;
    END;

    PROCEDURE wyswietl_wszystkie IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== WSZYSTKIE SALE ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('ID', 5) || RPAD('NUMER', 10) || RPAD('TYP', 18) || RPAD('POJ', 5) || 'STATUS');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 55, '-'));
        
        FOR r IN (
            SELECT * FROM sale ORDER BY numer
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.id_sali, 5) ||
                RPAD(r.numer, 10) ||
                RPAD(r.typ_sali, 18) ||
                RPAD(r.pojemnosc, 5) ||
                r.status
            );
        END LOOP;
    END;

    PROCEDURE wyswietl_jedna(p_id NUMBER) IS
        r sale%ROWTYPE;
        v_wyp VARCHAR2(500);
    BEGIN
        SELECT * INTO r FROM sale WHERE id_sali = p_id;
        
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== SALA ID=' || p_id || ' ===');
        DBMS_OUTPUT.PUT_LINE('Numer:     ' || r.numer);
        DBMS_OUTPUT.PUT_LINE('Typ:       ' || r.typ_sali);
        DBMS_OUTPUT.PUT_LINE('Pojemnosc: ' || r.pojemnosc);
        DBMS_OUTPUT.PUT_LINE('Status:    ' || r.status);
        
        IF r.wyposazenie IS NOT NULL AND r.wyposazenie.COUNT > 0 THEN
            v_wyp := '';
            FOR i IN 1..r.wyposazenie.COUNT LOOP
                v_wyp := v_wyp || r.wyposazenie(i);
                IF i < r.wyposazenie.COUNT THEN v_wyp := v_wyp || ', '; END IF;
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('Wyposazenie: ' || v_wyp);
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('[BLAD] Sala ID=' || p_id || ' nie istnieje');
    END;

    PROCEDURE aktualizuj(
        p_id          NUMBER,
        p_numer       VARCHAR2 DEFAULT NULL,
        p_typ         VARCHAR2 DEFAULT NULL,
        p_pojemnosc   NUMBER DEFAULT NULL,
        p_status      VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        UPDATE sale SET
            numer = NVL(p_numer, numer),
            typ_sali = NVL(p_typ, typ_sali),
            pojemnosc = NVL(p_pojemnosc, pojemnosc),
            status = NVL(p_status, status)
        WHERE id_sali = p_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20122, 'Sala ID=' || p_id || ' nie istnieje');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[OK] Zaktualizowano sale ID=' || p_id);
        COMMIT;
    END;

    PROCEDURE usun(p_id NUMBER) IS
        v_cnt NUMBER;
    BEGIN
        -- Sprawdz czy sa lekcje
        SELECT COUNT(*) INTO v_cnt FROM lekcje WHERE DEREF(ref_sala).id_sali = p_id;
        IF v_cnt > 0 THEN
            RAISE_APPLICATION_ERROR(-20123, 'Nie mozna usunac - ' || v_cnt || ' lekcji zaplanowanych w tej sali');
        END IF;
        
        DELETE FROM sale WHERE id_sali = p_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20124, 'Sala ID=' || p_id || ' nie istnieje');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[OK] Usunieto sale ID=' || p_id);
        COMMIT;
    END;

    PROCEDURE zmien_status(p_id NUMBER, p_status VARCHAR2) IS
    BEGIN
        IF p_status NOT IN ('aktywna', 'remont', 'nieczynna') THEN
            RAISE_APPLICATION_ERROR(-20125, 'Niepoprawny status. Dozwolone: aktywna, remont, nieczynna');
        END IF;
        
        UPDATE sale SET status = p_status WHERE id_sali = p_id;
        DBMS_OUTPUT.PUT_LINE('[OK] Zmieniono status sali ID=' || p_id || ' na: ' || p_status);
        COMMIT;
    END;

    FUNCTION czy_wolna(p_id NUMBER, p_data DATE, p_godz_od VARCHAR2, p_godz_do VARCHAR2) RETURN CHAR IS
        v_cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_cnt
        FROM lekcje l
        WHERE DEREF(l.ref_sala).id_sali = p_id
          AND l.data_lekcji = p_data
          AND l.status != 'odwolana'
          AND NOT (l.godzina_start >= p_godz_do OR VALUE(l).godzina_koniec() <= p_godz_od);
        RETURN CASE WHEN v_cnt = 0 THEN 'T' ELSE 'N' END;
    END;

END pkg_sala;
/

-- ============================================================================
-- 4. PAKIET: PKG_GRUPA
-- CRUD + zarzadzanie uczniami w grupie
-- ============================================================================

PROMPT [4/10] Tworzenie pakietu pkg_grupa...

CREATE OR REPLACE PACKAGE pkg_grupa AS

    PROCEDURE dodaj(
        p_nazwa       VARCHAR2,
        p_klasa       NUMBER,
        p_rok_szkolny VARCHAR2,
        p_max_uczniow NUMBER DEFAULT 15
    );

    PROCEDURE wyswietl_wszystkie;
    PROCEDURE wyswietl_jedna(p_id NUMBER);
    PROCEDURE wyswietl_uczniow_grupy(p_id NUMBER);

    PROCEDURE aktualizuj(
        p_id          NUMBER,
        p_nazwa       VARCHAR2 DEFAULT NULL,
        p_max_uczniow NUMBER DEFAULT NULL,
        p_status      VARCHAR2 DEFAULT NULL
    );

    PROCEDURE usun(p_id NUMBER);
    FUNCTION liczba_uczniow(p_id NUMBER) RETURN NUMBER;

END pkg_grupa;
/

CREATE OR REPLACE PACKAGE BODY pkg_grupa AS

    PROCEDURE dodaj(
        p_nazwa       VARCHAR2,
        p_klasa       NUMBER,
        p_rok_szkolny VARCHAR2,
        p_max_uczniow NUMBER DEFAULT 15
    ) IS
        v_id NUMBER;
        v_cnt NUMBER;
    BEGIN
        -- Walidacja unikalnosci
        SELECT COUNT(*) INTO v_cnt FROM grupy 
        WHERE UPPER(nazwa) = UPPER(p_nazwa) AND rok_szkolny = p_rok_szkolny;
        IF v_cnt > 0 THEN
            RAISE_APPLICATION_ERROR(-20130, 'Grupa "' || p_nazwa || '" w roku ' || p_rok_szkolny || ' juz istnieje');
        END IF;
        
        SELECT seq_grupy.NEXTVAL INTO v_id FROM dual;
        
        INSERT INTO grupy VALUES (t_grupa_obj(v_id, p_nazwa, p_klasa, p_rok_szkolny, p_max_uczniow, 'aktywna'));
        
        DBMS_OUTPUT.PUT_LINE('[OK] Dodano grupe: ' || p_nazwa || ' (ID=' || v_id || ')');
        COMMIT;
    END;

    PROCEDURE wyswietl_wszystkie IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== WSZYSTKIE GRUPY ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('ID', 5) || RPAD('NAZWA', 10) || RPAD('KL', 4) || RPAD('ROK', 12) || RPAD('UCZ', 5) || 'STATUS');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 55, '-'));
        
        FOR r IN (
            SELECT g.*, liczba_uczniow(g.id_grupy) AS cnt FROM grupy g ORDER BY rok_szkolny DESC, klasa, nazwa
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.id_grupy, 5) ||
                RPAD(r.nazwa, 10) ||
                RPAD(r.klasa, 4) ||
                RPAD(r.rok_szkolny, 12) ||
                RPAD(r.cnt || '/' || r.max_uczniow, 5) ||
                r.status
            );
        END LOOP;
    END;

    PROCEDURE wyswietl_jedna(p_id NUMBER) IS
        r grupy%ROWTYPE;
    BEGIN
        SELECT * INTO r FROM grupy WHERE id_grupy = p_id;
        
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== GRUPA ID=' || p_id || ' ===');
        DBMS_OUTPUT.PUT_LINE('Nazwa:     ' || r.nazwa);
        DBMS_OUTPUT.PUT_LINE('Klasa:     ' || r.klasa);
        DBMS_OUTPUT.PUT_LINE('Rok:       ' || r.rok_szkolny);
        DBMS_OUTPUT.PUT_LINE('Uczniow:   ' || liczba_uczniow(p_id) || '/' || r.max_uczniow);
        DBMS_OUTPUT.PUT_LINE('Status:    ' || r.status);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('[BLAD] Grupa ID=' || p_id || ' nie istnieje');
    END;

    PROCEDURE wyswietl_uczniow_grupy(p_id NUMBER) IS
        v_nazwa VARCHAR2(50);
    BEGIN
        SELECT nazwa INTO v_nazwa FROM grupy WHERE id_grupy = p_id;
        
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== UCZNIOWIE GRUPY: ' || v_nazwa || ' ===');
        
        FOR r IN (
            SELECT u.id_ucznia, u.imie, u.nazwisko, u.klasa
            FROM uczniowie u
            WHERE DEREF(u.ref_grupa).id_grupy = p_id
            ORDER BY u.nazwisko
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('  ' || r.id_ucznia || '. ' || r.imie || ' ' || r.nazwisko || ' (kl. ' || r.klasa || ')');
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('[BLAD] Grupa ID=' || p_id || ' nie istnieje');
    END;

    PROCEDURE aktualizuj(
        p_id          NUMBER,
        p_nazwa       VARCHAR2 DEFAULT NULL,
        p_max_uczniow NUMBER DEFAULT NULL,
        p_status      VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        UPDATE grupy SET
            nazwa = NVL(p_nazwa, nazwa),
            max_uczniow = NVL(p_max_uczniow, max_uczniow),
            status = NVL(p_status, status)
        WHERE id_grupy = p_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20131, 'Grupa ID=' || p_id || ' nie istnieje');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[OK] Zaktualizowano grupe ID=' || p_id);
        COMMIT;
    END;

    PROCEDURE usun(p_id NUMBER) IS
        v_cnt NUMBER;
    BEGIN
        -- Sprawdz czy sa uczniowie
        v_cnt := liczba_uczniow(p_id);
        IF v_cnt > 0 THEN
            RAISE_APPLICATION_ERROR(-20132, 'Nie mozna usunac - ' || v_cnt || ' uczniow przypisanych do grupy');
        END IF;
        
        -- Sprawdz czy sa lekcje
        SELECT COUNT(*) INTO v_cnt FROM lekcje WHERE DEREF(ref_grupa).id_grupy = p_id;
        IF v_cnt > 0 THEN
            RAISE_APPLICATION_ERROR(-20133, 'Nie mozna usunac - ' || v_cnt || ' lekcji zaplanowanych dla grupy');
        END IF;
        
        DELETE FROM grupy WHERE id_grupy = p_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20134, 'Grupa ID=' || p_id || ' nie istnieje');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[OK] Usunieto grupe ID=' || p_id);
        COMMIT;
    END;

    FUNCTION liczba_uczniow(p_id NUMBER) RETURN NUMBER IS
        v_cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_cnt FROM uczniowie WHERE DEREF(ref_grupa).id_grupy = p_id;
        RETURN v_cnt;
    END;

END pkg_grupa;
/

-- ============================================================================
-- 5. PAKIET: PKG_PRZEDMIOT
-- CRUD + przypisanie do instrumentu
-- ============================================================================

PROMPT [5/10] Tworzenie pakietu pkg_przedmiot...

CREATE OR REPLACE PACKAGE pkg_przedmiot AS

    PROCEDURE dodaj(
        p_nazwa         VARCHAR2,
        p_typ_zajec     VARCHAR2,
        p_wymiar_minut  NUMBER,
        p_klasy_od      NUMBER,
        p_klasy_do      NUMBER,
        p_obowiazkowy   CHAR DEFAULT 'T',
        p_id_instrumentu NUMBER DEFAULT NULL
    );

    PROCEDURE wyswietl_wszystkie;
    PROCEDURE wyswietl_jeden(p_id NUMBER);

    PROCEDURE aktualizuj(
        p_id            NUMBER,
        p_nazwa         VARCHAR2 DEFAULT NULL,
        p_wymiar_minut  NUMBER DEFAULT NULL,
        p_obowiazkowy   CHAR DEFAULT NULL
    );

    PROCEDURE usun(p_id NUMBER);

END pkg_przedmiot;
/

CREATE OR REPLACE PACKAGE BODY pkg_przedmiot AS

    PROCEDURE dodaj(
        p_nazwa         VARCHAR2,
        p_typ_zajec     VARCHAR2,
        p_wymiar_minut  NUMBER,
        p_klasy_od      NUMBER,
        p_klasy_do      NUMBER,
        p_obowiazkowy   CHAR DEFAULT 'T',
        p_id_instrumentu NUMBER DEFAULT NULL
    ) IS
        v_id NUMBER;
        v_ref REF t_instrument_obj := NULL;
    BEGIN
        IF p_typ_zajec NOT IN ('indywidualny', 'grupowy') THEN
            RAISE_APPLICATION_ERROR(-20140, 'Typ zajec: indywidualny lub grupowy');
        END IF;
        
        IF p_wymiar_minut NOT IN (30, 45, 60, 90) THEN
            RAISE_APPLICATION_ERROR(-20141, 'Wymiar minut: 30, 45, 60 lub 90');
        END IF;
        
        IF p_id_instrumentu IS NOT NULL THEN
            SELECT REF(i) INTO v_ref FROM instrumenty i WHERE id_instrumentu = p_id_instrumentu;
        END IF;
        
        SELECT seq_przedmioty.NEXTVAL INTO v_id FROM dual;
        
        INSERT INTO przedmioty VALUES (t_przedmiot_obj(
            v_id, p_nazwa, p_typ_zajec, p_wymiar_minut, p_klasy_od, p_klasy_do, p_obowiazkowy, v_ref
        ));
        
        DBMS_OUTPUT.PUT_LINE('[OK] Dodano przedmiot: ' || p_nazwa || ' (ID=' || v_id || ')');
        COMMIT;
    END;

    PROCEDURE wyswietl_wszystkie IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== WSZYSTKIE PRZEDMIOTY ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('ID', 5) || RPAD('NAZWA', 30) || RPAD('TYP', 14) || RPAD('MIN', 5) || RPAD('KLASY', 10) || 'OBOW');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 75, '-'));
        
        FOR r IN (
            SELECT * FROM przedmioty ORDER BY typ_zajec, nazwa
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.id_przedmiotu, 5) ||
                RPAD(r.nazwa, 30) ||
                RPAD(r.typ_zajec, 14) ||
                RPAD(r.wymiar_minut, 5) ||
                RPAD(r.klasy_od || '-' || r.klasy_do, 10) ||
                r.czy_obowiazkowy
            );
        END LOOP;
    END;

    PROCEDURE wyswietl_jeden(p_id NUMBER) IS
        r przedmioty%ROWTYPE;
    BEGIN
        SELECT * INTO r FROM przedmioty WHERE id_przedmiotu = p_id;
        
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== PRZEDMIOT ID=' || p_id || ' ===');
        DBMS_OUTPUT.PUT_LINE('Nazwa:      ' || r.nazwa);
        DBMS_OUTPUT.PUT_LINE('Typ zajec:  ' || r.typ_zajec);
        DBMS_OUTPUT.PUT_LINE('Wymiar:     ' || r.wymiar_minut || ' min');
        DBMS_OUTPUT.PUT_LINE('Klasy:      ' || r.klasy_od || ' - ' || r.klasy_do);
        DBMS_OUTPUT.PUT_LINE('Obowiazkowy: ' || CASE r.czy_obowiazkowy WHEN 'T' THEN 'TAK' ELSE 'NIE' END);
        
        IF r.ref_instrument IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('Instrument: ' || DEREF(r.ref_instrument).nazwa);
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('[BLAD] Przedmiot ID=' || p_id || ' nie istnieje');
    END;

    PROCEDURE aktualizuj(
        p_id            NUMBER,
        p_nazwa         VARCHAR2 DEFAULT NULL,
        p_wymiar_minut  NUMBER DEFAULT NULL,
        p_obowiazkowy   CHAR DEFAULT NULL
    ) IS
    BEGIN
        UPDATE przedmioty SET
            nazwa = NVL(p_nazwa, nazwa),
            wymiar_minut = NVL(p_wymiar_minut, wymiar_minut),
            czy_obowiazkowy = NVL(p_obowiazkowy, czy_obowiazkowy)
        WHERE id_przedmiotu = p_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20142, 'Przedmiot ID=' || p_id || ' nie istnieje');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[OK] Zaktualizowano przedmiot ID=' || p_id);
        COMMIT;
    END;

    PROCEDURE usun(p_id NUMBER) IS
        v_cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_cnt FROM lekcje WHERE DEREF(ref_przedmiot).id_przedmiotu = p_id;
        IF v_cnt > 0 THEN
            RAISE_APPLICATION_ERROR(-20143, 'Nie mozna usunac - ' || v_cnt || ' lekcji z tym przedmiotem');
        END IF;
        
        DELETE FROM przedmioty WHERE id_przedmiotu = p_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20144, 'Przedmiot ID=' || p_id || ' nie istnieje');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[OK] Usunieto przedmiot ID=' || p_id);
        COMMIT;
    END;

END pkg_przedmiot;
/

-- ============================================================================
-- 6. PAKIET: PKG_EGZAMIN
-- CRUD + komisja + wyniki
-- ============================================================================

PROMPT [6/10] Tworzenie pakietu pkg_egzamin...

CREATE OR REPLACE PACKAGE pkg_egzamin AS

    PROCEDURE dodaj(
        p_data         DATE,
        p_godzina      VARCHAR2,
        p_typ          VARCHAR2,
        p_id_ucznia    NUMBER,
        p_id_przedm    NUMBER,
        p_id_komisja1  NUMBER,
        p_id_komisja2  NUMBER,
        p_id_sali      NUMBER
    );

    PROCEDURE wyswietl_wszystkie;
    PROCEDURE wyswietl_jeden(p_id NUMBER);
    PROCEDURE wyswietl_egzaminy_ucznia(p_id_ucznia NUMBER);

    PROCEDURE ustaw_ocene(p_id NUMBER, p_ocena NUMBER, p_uwagi VARCHAR2 DEFAULT NULL);

    PROCEDURE usun(p_id NUMBER);

END pkg_egzamin;
/

CREATE OR REPLACE PACKAGE BODY pkg_egzamin AS

    PROCEDURE dodaj(
        p_data         DATE,
        p_godzina      VARCHAR2,
        p_typ          VARCHAR2,
        p_id_ucznia    NUMBER,
        p_id_przedm    NUMBER,
        p_id_komisja1  NUMBER,
        p_id_komisja2  NUMBER,
        p_id_sali      NUMBER
    ) IS
        v_id      NUMBER;
        v_ref_u   REF t_uczen_obj;
        v_ref_p   REF t_przedmiot_obj;
        v_ref_k1  REF t_nauczyciel_obj;
        v_ref_k2  REF t_nauczyciel_obj;
        v_ref_s   REF t_sala_obj;
    BEGIN
        -- Walidacja komisji
        IF p_id_komisja1 = p_id_komisja2 THEN
            RAISE_APPLICATION_ERROR(-20150, 'Komisja musi skladac sie z 2 ROZNYCH nauczycieli');
        END IF;
        
        SELECT seq_egzaminy.NEXTVAL INTO v_id FROM dual;
        SELECT REF(u) INTO v_ref_u FROM uczniowie u WHERE id_ucznia = p_id_ucznia;
        SELECT REF(p) INTO v_ref_p FROM przedmioty p WHERE id_przedmiotu = p_id_przedm;
        SELECT REF(n) INTO v_ref_k1 FROM nauczyciele n WHERE id_nauczyciela = p_id_komisja1;
        SELECT REF(n) INTO v_ref_k2 FROM nauczyciele n WHERE id_nauczyciela = p_id_komisja2;
        SELECT REF(s) INTO v_ref_s FROM sale s WHERE id_sali = p_id_sali;
        
        INSERT INTO egzaminy VALUES (t_egzamin_obj(
            v_id, p_data, p_godzina, p_typ, NULL, NULL,
            v_ref_u, v_ref_p, v_ref_k1, v_ref_k2, v_ref_s
        ));
        
        DBMS_OUTPUT.PUT_LINE('[OK] Dodano egzamin: ' || p_typ || ' (ID=' || v_id || ')');
        COMMIT;
    END;

    PROCEDURE wyswietl_wszystkie IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== WSZYSTKIE EGZAMINY ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('ID', 5) || RPAD('DATA', 12) || RPAD('GODZ', 7) || RPAD('TYP', 14) || RPAD('UCZEN', 25) || 'OCENA');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 75, '-'));
        
        FOR r IN (
            SELECT e.id_egzaminu, e.data_egzaminu, e.godzina, e.typ_egzaminu, e.ocena_koncowa,
                   DEREF(e.ref_uczen).imie || ' ' || DEREF(e.ref_uczen).nazwisko AS uczen
            FROM egzaminy e
            ORDER BY e.data_egzaminu DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.id_egzaminu, 5) ||
                RPAD(TO_CHAR(r.data_egzaminu, 'YYYY-MM-DD'), 12) ||
                RPAD(r.godzina, 7) ||
                RPAD(r.typ_egzaminu, 14) ||
                RPAD(r.uczen, 25) ||
                NVL(TO_CHAR(r.ocena_koncowa), '-')
            );
        END LOOP;
    END;

    PROCEDURE wyswietl_jeden(p_id NUMBER) IS
    BEGIN
        FOR r IN (
            SELECT e.*,
                   DEREF(e.ref_uczen).imie || ' ' || DEREF(e.ref_uczen).nazwisko AS uczen,
                   DEREF(e.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(e.ref_komisja1).nazwisko AS k1,
                   DEREF(e.ref_komisja2).nazwisko AS k2,
                   DEREF(e.ref_sala).numer AS sala
            FROM egzaminy e
            WHERE e.id_egzaminu = p_id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('=== EGZAMIN ID=' || p_id || ' ===');
            DBMS_OUTPUT.PUT_LINE('Data:      ' || TO_CHAR(r.data_egzaminu, 'YYYY-MM-DD') || ' ' || r.godzina);
            DBMS_OUTPUT.PUT_LINE('Typ:       ' || r.typ_egzaminu);
            DBMS_OUTPUT.PUT_LINE('Uczen:     ' || r.uczen);
            DBMS_OUTPUT.PUT_LINE('Przedmiot: ' || r.przedmiot);
            DBMS_OUTPUT.PUT_LINE('Komisja:   ' || r.k1 || ', ' || r.k2);
            DBMS_OUTPUT.PUT_LINE('Sala:      ' || r.sala);
            DBMS_OUTPUT.PUT_LINE('Ocena:     ' || NVL(TO_CHAR(r.ocena_koncowa), 'brak'));
            RETURN;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('[BLAD] Egzamin ID=' || p_id || ' nie istnieje');
    END;

    PROCEDURE wyswietl_egzaminy_ucznia(p_id_ucznia NUMBER) IS
        v_nazwa VARCHAR2(100);
    BEGIN
        SELECT imie || ' ' || nazwisko INTO v_nazwa FROM uczniowie WHERE id_ucznia = p_id_ucznia;
        
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== EGZAMINY UCZNIA: ' || v_nazwa || ' ===');
        
        FOR r IN (
            SELECT e.id_egzaminu, e.data_egzaminu, e.typ_egzaminu, e.ocena_koncowa,
                   DEREF(e.ref_przedmiot).nazwa AS przedmiot
            FROM egzaminy e
            WHERE DEREF(e.ref_uczen).id_ucznia = p_id_ucznia
            ORDER BY e.data_egzaminu DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                '  ' || TO_CHAR(r.data_egzaminu, 'YYYY-MM-DD') ||
                ' | ' || RPAD(r.typ_egzaminu, 14) ||
                ' | ' || RPAD(r.przedmiot, 20) ||
                ' | ' || NVL(TO_CHAR(r.ocena_koncowa), '-')
            );
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('[BLAD] Uczen ID=' || p_id_ucznia || ' nie istnieje');
    END;

    PROCEDURE ustaw_ocene(p_id NUMBER, p_ocena NUMBER, p_uwagi VARCHAR2 DEFAULT NULL) IS
    BEGIN
        IF p_ocena NOT BETWEEN 1 AND 6 THEN
            RAISE_APPLICATION_ERROR(-20151, 'Ocena musi byc z zakresu 1-6');
        END IF;
        
        UPDATE egzaminy SET ocena_koncowa = p_ocena, uwagi = p_uwagi WHERE id_egzaminu = p_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20152, 'Egzamin ID=' || p_id || ' nie istnieje');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[OK] Ustawiono ocene ' || p_ocena || ' dla egzaminu ID=' || p_id);
        COMMIT;
    END;

    PROCEDURE usun(p_id NUMBER) IS
    BEGIN
        DELETE FROM egzaminy WHERE id_egzaminu = p_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20153, 'Egzamin ID=' || p_id || ' nie istnieje');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[OK] Usunieto egzamin ID=' || p_id);
        COMMIT;
    END;

END pkg_egzamin;
/

-- ============================================================================
-- 7. ROZSZERZENIE: PKG_UCZEN - dodatkowe funkcje
-- ============================================================================

PROMPT [7/10] Rozszerzanie pakietu pkg_uczen...

CREATE OR REPLACE PACKAGE pkg_uczen AS

    -- ========== CREATE ==========
    PROCEDURE dodaj_ucznia(
        p_imie           VARCHAR2,
        p_nazwisko       VARCHAR2,
        p_data_urodzenia DATE,
        p_email          VARCHAR2 DEFAULT NULL,
        p_telefon        VARCHAR2 DEFAULT NULL,
        p_klasa          NUMBER DEFAULT 1,
        p_cykl           NUMBER DEFAULT 6,
        p_typ            VARCHAR2 DEFAULT 'uczacy_sie_w_innej_szkole',
        p_id_instrumentu NUMBER DEFAULT NULL,
        p_id_grupy       NUMBER DEFAULT NULL
    );

    -- ========== READ ==========
    PROCEDURE wyswietl_wszystkich;
    PROCEDURE wyswietl_jednego(p_id NUMBER);
    PROCEDURE wyswietl_plan_ucznia(p_id NUMBER);
    PROCEDURE wyswietl_oceny_ucznia(p_id NUMBER);

    -- ========== UPDATE ==========
    PROCEDURE promuj_ucznia(p_id_ucznia NUMBER);
    PROCEDURE zmien_status(p_id_ucznia NUMBER, p_nowy_status VARCHAR2);
    PROCEDURE przypisz_do_grupy(p_id_ucznia NUMBER, p_id_grupy NUMBER);
    PROCEDURE aktualizuj(
        p_id        NUMBER,
        p_email     VARCHAR2 DEFAULT NULL,
        p_telefon   VARCHAR2 DEFAULT NULL,
        p_typ       VARCHAR2 DEFAULT NULL
    );

    -- ========== DELETE ==========
    PROCEDURE usun(p_id NUMBER);

    -- ========== FUNKCJE ==========
    FUNCTION srednia_ocen(p_id_ucznia NUMBER) RETURN NUMBER;
    FUNCTION liczba_lekcji(p_id_ucznia NUMBER) RETURN NUMBER;

    -- ========== WALIDACJE ==========
    FUNCTION czy_email_unikalny(p_email VARCHAR2, p_id_pomijany NUMBER DEFAULT NULL) RETURN CHAR;
    FUNCTION czy_telefon_unikalny(p_telefon VARCHAR2, p_id_pomijany NUMBER DEFAULT NULL) RETURN CHAR;

END pkg_uczen;
/

CREATE OR REPLACE PACKAGE BODY pkg_uczen AS

    FUNCTION czy_email_unikalny(p_email VARCHAR2, p_id_pomijany NUMBER DEFAULT NULL) RETURN CHAR IS
        v_cnt NUMBER;
    BEGIN
        IF p_email IS NULL THEN RETURN 'T'; END IF;
        
        SELECT COUNT(*) INTO v_cnt FROM uczniowie 
        WHERE UPPER(email) = UPPER(p_email) AND (p_id_pomijany IS NULL OR id_ucznia != p_id_pomijany);
        
        -- Sprawdz tez nauczycieli
        SELECT v_cnt + COUNT(*) INTO v_cnt FROM nauczyciele WHERE UPPER(email) = UPPER(p_email);
        
        RETURN CASE WHEN v_cnt = 0 THEN 'T' ELSE 'N' END;
    END;

    FUNCTION czy_telefon_unikalny(p_telefon VARCHAR2, p_id_pomijany NUMBER DEFAULT NULL) RETURN CHAR IS
        v_cnt NUMBER;
    BEGIN
        IF p_telefon IS NULL THEN RETURN 'T'; END IF;
        
        SELECT COUNT(*) INTO v_cnt FROM uczniowie 
        WHERE telefon_rodzica = p_telefon AND (p_id_pomijany IS NULL OR id_ucznia != p_id_pomijany);
        
        RETURN CASE WHEN v_cnt = 0 THEN 'T' ELSE 'N' END;
    END;

    PROCEDURE dodaj_ucznia(
        p_imie           VARCHAR2,
        p_nazwisko       VARCHAR2,
        p_data_urodzenia DATE,
        p_email          VARCHAR2 DEFAULT NULL,
        p_telefon        VARCHAR2 DEFAULT NULL,
        p_klasa          NUMBER DEFAULT 1,
        p_cykl           NUMBER DEFAULT 6,
        p_typ            VARCHAR2 DEFAULT 'uczacy_sie_w_innej_szkole',
        p_id_instrumentu NUMBER DEFAULT NULL,
        p_id_grupy       NUMBER DEFAULT NULL
    ) IS
        v_id        NUMBER;
        v_ref_instr REF t_instrument_obj := NULL;
        v_ref_grupa REF t_grupa_obj := NULL;
    BEGIN
        -- Walidacja email
        IF czy_email_unikalny(p_email) = 'N' THEN
            RAISE_APPLICATION_ERROR(-20200, 'Email "' || p_email || '" juz istnieje w systemie');
        END IF;
        
        -- Walidacja telefon
        IF czy_telefon_unikalny(p_telefon) = 'N' THEN
            RAISE_APPLICATION_ERROR(-20201, 'Telefon "' || p_telefon || '" juz istnieje w systemie');
        END IF;
        
        SELECT seq_uczniowie.NEXTVAL INTO v_id FROM dual;

        IF p_id_instrumentu IS NOT NULL THEN
            SELECT REF(i) INTO v_ref_instr FROM instrumenty i WHERE id_instrumentu = p_id_instrumentu;
        END IF;

        IF p_id_grupy IS NOT NULL THEN
            SELECT REF(g) INTO v_ref_grupa FROM grupy g WHERE id_grupy = p_id_grupy;
        END IF;

        INSERT INTO uczniowie VALUES (t_uczen_obj(
            v_id, p_imie, p_nazwisko, p_data_urodzenia, p_email, p_telefon,
            SYSDATE, p_klasa, p_cykl, p_typ, 'aktywny', v_ref_instr, v_ref_grupa
        ));

        DBMS_OUTPUT.PUT_LINE('[OK] Dodano ucznia: ' || p_imie || ' ' || p_nazwisko || ' (ID=' || v_id || ')');
        COMMIT;
    END;

    PROCEDURE wyswietl_wszystkich IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== WSZYSCY UCZNIOWIE ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('ID', 5) || RPAD('NAZWISKO', 20) || RPAD('IMIE', 15) || RPAD('KL', 4) || 
                            RPAD('TYP', 25) || RPAD('INSTR', 15) || 'STATUS');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 100, '-'));
        
        FOR r IN (
            SELECT u.id_ucznia, u.imie, u.nazwisko, u.klasa, u.typ_ucznia, u.status,
                   DEREF(u.ref_instrument).nazwa AS instrument
            FROM uczniowie u
            ORDER BY u.nazwisko, u.imie
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.id_ucznia, 5) ||
                RPAD(r.nazwisko, 20) ||
                RPAD(r.imie, 15) ||
                RPAD(r.klasa, 4) ||
                RPAD(r.typ_ucznia, 25) ||
                RPAD(NVL(r.instrument, '-'), 15) ||
                r.status
            );
        END LOOP;
    END;

    PROCEDURE wyswietl_jednego(p_id NUMBER) IS
    BEGIN
        FOR r IN (
            SELECT u.*,
                   DEREF(u.ref_instrument).nazwa AS instrument,
                   DEREF(u.ref_grupa).nazwa AS grupa,
                   VALUE(u).wiek() AS wiek,
                   VALUE(u).min_godzina_lekcji() AS min_godz
            FROM uczniowie u
            WHERE u.id_ucznia = p_id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('=== UCZEN ID=' || p_id || ' ===');
            DBMS_OUTPUT.PUT_LINE('Imie:        ' || r.imie);
            DBMS_OUTPUT.PUT_LINE('Nazwisko:    ' || r.nazwisko);
            DBMS_OUTPUT.PUT_LINE('Data ur.:    ' || TO_CHAR(r.data_urodzenia, 'YYYY-MM-DD') || ' (wiek: ' || r.wiek || ')');
            DBMS_OUTPUT.PUT_LINE('Email:       ' || NVL(r.email, '-'));
            DBMS_OUTPUT.PUT_LINE('Telefon:     ' || NVL(r.telefon_rodzica, '-'));
            DBMS_OUTPUT.PUT_LINE('Klasa:       ' || r.klasa || ' / cykl ' || r.cykl_nauczania);
            DBMS_OUTPUT.PUT_LINE('Typ:         ' || r.typ_ucznia || ' (lekcje od ' || r.min_godz || ')');
            DBMS_OUTPUT.PUT_LINE('Status:      ' || r.status);
            DBMS_OUTPUT.PUT_LINE('Instrument:  ' || NVL(r.instrument, '-'));
            DBMS_OUTPUT.PUT_LINE('Grupa:       ' || NVL(r.grupa, '-'));
            DBMS_OUTPUT.PUT_LINE('Srednia:     ' || srednia_ocen(p_id));
            DBMS_OUTPUT.PUT_LINE('Lekcji:      ' || liczba_lekcji(p_id));
            RETURN;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('[BLAD] Uczen ID=' || p_id || ' nie istnieje');
    END;

    PROCEDURE wyswietl_plan_ucznia(p_id NUMBER) IS
        v_nazwa VARCHAR2(100);
    BEGIN
        SELECT imie || ' ' || nazwisko INTO v_nazwa FROM uczniowie WHERE id_ucznia = p_id;
        
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== PLAN UCZNIA: ' || v_nazwa || ' ===');
        
        FOR r IN (
            SELECT l.data_lekcji, l.godzina_start, l.czas_trwania, l.typ_lekcji, l.status,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
                   DEREF(l.ref_sala).numer AS sala
            FROM lekcje l
            WHERE (DEREF(l.ref_uczen).id_ucznia = p_id
                   OR l.ref_grupa IN (SELECT ref_grupa FROM uczniowie WHERE id_ucznia = p_id))
              AND l.data_lekcji >= SYSDATE
              AND l.status != 'odwolana'
            ORDER BY l.data_lekcji, l.godzina_start
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                TO_CHAR(r.data_lekcji, 'DY DD.MM', 'NLS_DATE_LANGUAGE=POLISH') || ' ' ||
                r.godzina_start || ' | ' ||
                RPAD(r.przedmiot, 20) || ' | ' ||
                RPAD(r.nauczyciel, 15) || ' | sala ' || r.sala
            );
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('[BLAD] Uczen ID=' || p_id || ' nie istnieje');
    END;

    PROCEDURE wyswietl_oceny_ucznia(p_id NUMBER) IS
        v_nazwa VARCHAR2(100);
    BEGIN
        SELECT imie || ' ' || nazwisko INTO v_nazwa FROM uczniowie WHERE id_ucznia = p_id;
        
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== OCENY UCZNIA: ' || v_nazwa || ' ===');
        
        FOR r IN (
            SELECT o.data_oceny, o.wartosc, o.obszar, o.komentarz,
                   DEREF(o.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(o.ref_nauczyciel).nazwisko AS nauczyciel
            FROM oceny o
            WHERE DEREF(o.ref_uczen).id_ucznia = p_id
            ORDER BY o.data_oceny DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                TO_CHAR(r.data_oceny, 'YYYY-MM-DD') || ' | ' ||
                r.wartosc || ' | ' ||
                RPAD(r.obszar, 14) || ' | ' ||
                RPAD(r.przedmiot, 20) || ' | ' ||
                r.nauczyciel
            );
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('Srednia: ' || srednia_ocen(p_id));
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('[BLAD] Uczen ID=' || p_id || ' nie istnieje');
    END;

    PROCEDURE promuj_ucznia(p_id_ucznia NUMBER) IS
        v_klasa NUMBER;
        v_cykl  NUMBER;
    BEGIN
        SELECT klasa, cykl_nauczania INTO v_klasa, v_cykl
        FROM uczniowie WHERE id_ucznia = p_id_ucznia;

        IF v_klasa >= v_cykl THEN
            UPDATE uczniowie SET status = 'absolwent' WHERE id_ucznia = p_id_ucznia;
            DBMS_OUTPUT.PUT_LINE('[OK] Uczen ID=' || p_id_ucznia || ' ukonczyl szkole - status: absolwent');
        ELSE
            UPDATE uczniowie SET klasa = v_klasa + 1 WHERE id_ucznia = p_id_ucznia;
            DBMS_OUTPUT.PUT_LINE('[OK] Uczen ID=' || p_id_ucznia || ' promowany do klasy ' || (v_klasa + 1));
        END IF;
        COMMIT;
    END;

    PROCEDURE zmien_status(p_id_ucznia NUMBER, p_nowy_status VARCHAR2) IS
    BEGIN
        IF p_nowy_status NOT IN ('aktywny', 'zawieszony', 'absolwent', 'skreslony') THEN
            RAISE_APPLICATION_ERROR(-20202, 'Niepoprawny status. Dozwolone: aktywny, zawieszony, absolwent, skreslony');
        END IF;
        
        UPDATE uczniowie SET status = p_nowy_status WHERE id_ucznia = p_id_ucznia;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20203, 'Uczen ID=' || p_id_ucznia || ' nie istnieje');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[OK] Zmieniono status ucznia ID=' || p_id_ucznia || ' na: ' || p_nowy_status);
        COMMIT;
    END;

    PROCEDURE przypisz_do_grupy(p_id_ucznia NUMBER, p_id_grupy NUMBER) IS
        v_ref REF t_grupa_obj;
    BEGIN
        SELECT REF(g) INTO v_ref FROM grupy g WHERE id_grupy = p_id_grupy;
        UPDATE uczniowie SET ref_grupa = v_ref WHERE id_ucznia = p_id_ucznia;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20204, 'Uczen ID=' || p_id_ucznia || ' nie istnieje');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[OK] Przypisano ucznia ID=' || p_id_ucznia || ' do grupy ID=' || p_id_grupy);
        COMMIT;
    END;

    PROCEDURE aktualizuj(
        p_id        NUMBER,
        p_email     VARCHAR2 DEFAULT NULL,
        p_telefon   VARCHAR2 DEFAULT NULL,
        p_typ       VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        -- Walidacja email
        IF p_email IS NOT NULL AND czy_email_unikalny(p_email, p_id) = 'N' THEN
            RAISE_APPLICATION_ERROR(-20205, 'Email "' || p_email || '" juz istnieje w systemie');
        END IF;
        
        -- Walidacja telefon
        IF p_telefon IS NOT NULL AND czy_telefon_unikalny(p_telefon, p_id) = 'N' THEN
            RAISE_APPLICATION_ERROR(-20206, 'Telefon "' || p_telefon || '" juz istnieje w systemie');
        END IF;
        
        UPDATE uczniowie SET
            email = NVL(p_email, email),
            telefon_rodzica = NVL(p_telefon, telefon_rodzica),
            typ_ucznia = NVL(p_typ, typ_ucznia)
        WHERE id_ucznia = p_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20207, 'Uczen ID=' || p_id || ' nie istnieje');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[OK] Zaktualizowano ucznia ID=' || p_id);
        COMMIT;
    END;

    PROCEDURE usun(p_id NUMBER) IS
        v_cnt NUMBER;
    BEGIN
        -- Sprawdz lekcje
        SELECT COUNT(*) INTO v_cnt FROM lekcje WHERE DEREF(ref_uczen).id_ucznia = p_id;
        IF v_cnt > 0 THEN
            RAISE_APPLICATION_ERROR(-20208, 'Nie mozna usunac - ' || v_cnt || ' lekcji zaplanowanych');
        END IF;
        
        -- Sprawdz oceny
        SELECT COUNT(*) INTO v_cnt FROM oceny WHERE DEREF(ref_uczen).id_ucznia = p_id;
        IF v_cnt > 0 THEN
            RAISE_APPLICATION_ERROR(-20209, 'Nie mozna usunac - ' || v_cnt || ' ocen wystawionych');
        END IF;
        
        DELETE FROM uczniowie WHERE id_ucznia = p_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20210, 'Uczen ID=' || p_id || ' nie istnieje');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[OK] Usunieto ucznia ID=' || p_id);
        COMMIT;
    END;

    FUNCTION srednia_ocen(p_id_ucznia NUMBER) RETURN NUMBER IS
        v_srednia NUMBER;
    BEGIN
        SELECT AVG(wartosc) INTO v_srednia
        FROM oceny
        WHERE DEREF(ref_uczen).id_ucznia = p_id_ucznia;
        RETURN ROUND(NVL(v_srednia, 0), 2);
    END;

    FUNCTION liczba_lekcji(p_id_ucznia NUMBER) RETURN NUMBER IS
        v_cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_cnt
        FROM lekcje
        WHERE DEREF(ref_uczen).id_ucznia = p_id_ucznia;
        RETURN v_cnt;
    END;

END pkg_uczen;
/

-- ============================================================================
-- 8. ROZSZERZENIE: PKG_NAUCZYCIEL - dodatkowe funkcje
-- ============================================================================

PROMPT [8/10] Rozszerzanie pakietu pkg_nauczyciel...

CREATE OR REPLACE PACKAGE pkg_nauczyciel AS

    -- ========== CREATE ==========
    PROCEDURE dodaj_nauczyciela(
        p_imie            VARCHAR2,
        p_nazwisko        VARCHAR2,
        p_email           VARCHAR2,
        p_telefon         VARCHAR2 DEFAULT NULL,
        p_instrumenty     t_lista_instrumentow DEFAULT NULL,
        p_grupowe         CHAR DEFAULT 'N',
        p_akompaniator    CHAR DEFAULT 'N'
    );

    -- ========== READ ==========
    PROCEDURE wyswietl_wszystkich;
    PROCEDURE wyswietl_jednego(p_id NUMBER);
    PROCEDURE wyswietl_plan_nauczyciela(p_id NUMBER);

    -- ========== UPDATE ==========
    PROCEDURE dodaj_instrument(p_id_nauczyciela NUMBER, p_instrument VARCHAR2);
    PROCEDURE zmien_status(p_id_nauczyciela NUMBER, p_nowy_status VARCHAR2);
    PROCEDURE aktualizuj(
        p_id          NUMBER,
        p_email       VARCHAR2 DEFAULT NULL,
        p_telefon     VARCHAR2 DEFAULT NULL,
        p_grupowe     CHAR DEFAULT NULL,
        p_akompaniator CHAR DEFAULT NULL
    );

    -- ========== DELETE ==========
    PROCEDURE usun(p_id NUMBER);

    -- ========== FUNKCJE ==========
    FUNCTION liczba_lekcji(p_id_nauczyciela NUMBER) RETURN NUMBER;
    FUNCTION nauczyciele_instrumentu(p_instrument VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION czy_email_unikalny(p_email VARCHAR2, p_id_pomijany NUMBER DEFAULT NULL) RETURN CHAR;

END pkg_nauczyciel;
/

CREATE OR REPLACE PACKAGE BODY pkg_nauczyciel AS

    FUNCTION czy_email_unikalny(p_email VARCHAR2, p_id_pomijany NUMBER DEFAULT NULL) RETURN CHAR IS
        v_cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_cnt FROM nauczyciele 
        WHERE UPPER(email) = UPPER(p_email) AND (p_id_pomijany IS NULL OR id_nauczyciela != p_id_pomijany);
        
        SELECT v_cnt + COUNT(*) INTO v_cnt FROM uczniowie WHERE UPPER(email) = UPPER(p_email);
        
        RETURN CASE WHEN v_cnt = 0 THEN 'T' ELSE 'N' END;
    END;

    PROCEDURE dodaj_nauczyciela(
        p_imie            VARCHAR2,
        p_nazwisko        VARCHAR2,
        p_email           VARCHAR2,
        p_telefon         VARCHAR2 DEFAULT NULL,
        p_instrumenty     t_lista_instrumentow DEFAULT NULL,
        p_grupowe         CHAR DEFAULT 'N',
        p_akompaniator    CHAR DEFAULT 'N'
    ) IS
        v_id NUMBER;
    BEGIN
        IF czy_email_unikalny(p_email) = 'N' THEN
            RAISE_APPLICATION_ERROR(-20300, 'Email "' || p_email || '" juz istnieje w systemie');
        END IF;
        
        SELECT seq_nauczyciele.NEXTVAL INTO v_id FROM dual;

        INSERT INTO nauczyciele VALUES (t_nauczyciel_obj(
            v_id, p_imie, p_nazwisko, p_email, p_telefon,
            SYSDATE, p_instrumenty, p_grupowe, p_akompaniator, 'aktywny'
        ));

        DBMS_OUTPUT.PUT_LINE('[OK] Dodano nauczyciela: ' || p_imie || ' ' || p_nazwisko || ' (ID=' || v_id || ')');
        COMMIT;
    END;

    PROCEDURE wyswietl_wszystkich IS
        v_instr VARCHAR2(200);
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== WSZYSCY NAUCZYCIELE ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('ID', 5) || RPAD('NAZWISKO', 20) || RPAD('IMIE', 15) || 
                            RPAD('GR', 4) || RPAD('AK', 4) || RPAD('STAZ', 6) || 'STATUS');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 70, '-'));
        
        FOR r IN (
            SELECT n.*, VALUE(n).lata_stazu() AS staz FROM nauczyciele n ORDER BY n.nazwisko
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.id_nauczyciela, 5) ||
                RPAD(r.nazwisko, 20) ||
                RPAD(r.imie, 15) ||
                RPAD(r.czy_prowadzi_grupowe, 4) ||
                RPAD(r.czy_akompaniator, 4) ||
                RPAD(r.staz || ' lat', 6) ||
                r.status
            );
        END LOOP;
    END;

    PROCEDURE wyswietl_jednego(p_id NUMBER) IS
        v_instr VARCHAR2(500);
    BEGIN
        FOR r IN (
            SELECT n.*, VALUE(n).lata_stazu() AS staz FROM nauczyciele n WHERE n.id_nauczyciela = p_id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('=== NAUCZYCIEL ID=' || p_id || ' ===');
            DBMS_OUTPUT.PUT_LINE('Imie:        ' || r.imie);
            DBMS_OUTPUT.PUT_LINE('Nazwisko:    ' || r.nazwisko);
            DBMS_OUTPUT.PUT_LINE('Email:       ' || r.email);
            DBMS_OUTPUT.PUT_LINE('Telefon:     ' || NVL(r.telefon, '-'));
            DBMS_OUTPUT.PUT_LINE('Zatrudniony: ' || TO_CHAR(r.data_zatrudnienia, 'YYYY-MM-DD') || ' (' || r.staz || ' lat)');
            DBMS_OUTPUT.PUT_LINE('Grupowe:     ' || CASE r.czy_prowadzi_grupowe WHEN 'T' THEN 'TAK' ELSE 'NIE' END);
            DBMS_OUTPUT.PUT_LINE('Akompaniator: ' || CASE r.czy_akompaniator WHEN 'T' THEN 'TAK' ELSE 'NIE' END);
            DBMS_OUTPUT.PUT_LINE('Status:      ' || r.status);
            
            IF r.instrumenty IS NOT NULL AND r.instrumenty.COUNT > 0 THEN
                v_instr := '';
                FOR i IN 1..r.instrumenty.COUNT LOOP
                    v_instr := v_instr || r.instrumenty(i);
                    IF i < r.instrumenty.COUNT THEN v_instr := v_instr || ', '; END IF;
                END LOOP;
                DBMS_OUTPUT.PUT_LINE('Instrumenty: ' || v_instr);
            END IF;
            
            DBMS_OUTPUT.PUT_LINE('Lekcji:      ' || liczba_lekcji(p_id));
            RETURN;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('[BLAD] Nauczyciel ID=' || p_id || ' nie istnieje');
    END;

    PROCEDURE wyswietl_plan_nauczyciela(p_id NUMBER) IS
        v_nazwa VARCHAR2(100);
    BEGIN
        SELECT imie || ' ' || nazwisko INTO v_nazwa FROM nauczyciele WHERE id_nauczyciela = p_id;
        
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== PLAN NAUCZYCIELA: ' || v_nazwa || ' ===');
        
        FOR r IN (
            SELECT l.data_lekcji, l.godzina_start, l.czas_trwania, l.typ_lekcji, l.status,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_sala).numer AS sala,
                   NVL(DEREF(l.ref_uczen).nazwisko, DEREF(l.ref_grupa).nazwa) AS dla_kogo
            FROM lekcje l
            WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = p_id
              AND l.data_lekcji >= SYSDATE
              AND l.status != 'odwolana'
            ORDER BY l.data_lekcji, l.godzina_start
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                TO_CHAR(r.data_lekcji, 'DY DD.MM', 'NLS_DATE_LANGUAGE=POLISH') || ' ' ||
                r.godzina_start || '-' || r.czas_trwania || 'min | ' ||
                RPAD(r.przedmiot, 20) || ' | ' ||
                RPAD(r.dla_kogo, 15) || ' | sala ' || r.sala
            );
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('[BLAD] Nauczyciel ID=' || p_id || ' nie istnieje');
    END;

    PROCEDURE dodaj_instrument(p_id_nauczyciela NUMBER, p_instrument VARCHAR2) IS
        v_instrumenty t_lista_instrumentow;
    BEGIN
        SELECT instrumenty INTO v_instrumenty
        FROM nauczyciele WHERE id_nauczyciela = p_id_nauczyciela;

        IF v_instrumenty IS NULL THEN
            v_instrumenty := t_lista_instrumentow();
        END IF;

        IF v_instrumenty.COUNT >= 5 THEN
            RAISE_APPLICATION_ERROR(-20301, 'Nauczyciel moze miec max 5 instrumentow');
        END IF;

        v_instrumenty.EXTEND;
        v_instrumenty(v_instrumenty.COUNT) := p_instrument;

        UPDATE nauczyciele SET instrumenty = v_instrumenty WHERE id_nauczyciela = p_id_nauczyciela;
        DBMS_OUTPUT.PUT_LINE('[OK] Dodano instrument: ' || p_instrument);
        COMMIT;
    END;

    PROCEDURE zmien_status(p_id_nauczyciela NUMBER, p_nowy_status VARCHAR2) IS
    BEGIN
        IF p_nowy_status NOT IN ('aktywny', 'nieaktywny', 'urlop') THEN
            RAISE_APPLICATION_ERROR(-20302, 'Niepoprawny status. Dozwolone: aktywny, nieaktywny, urlop');
        END IF;
        
        UPDATE nauczyciele SET status = p_nowy_status WHERE id_nauczyciela = p_id_nauczyciela;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20303, 'Nauczyciel ID=' || p_id_nauczyciela || ' nie istnieje');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[OK] Zmieniono status nauczyciela ID=' || p_id_nauczyciela || ' na: ' || p_nowy_status);
        COMMIT;
    END;

    PROCEDURE aktualizuj(
        p_id          NUMBER,
        p_email       VARCHAR2 DEFAULT NULL,
        p_telefon     VARCHAR2 DEFAULT NULL,
        p_grupowe     CHAR DEFAULT NULL,
        p_akompaniator CHAR DEFAULT NULL
    ) IS
    BEGIN
        IF p_email IS NOT NULL AND czy_email_unikalny(p_email, p_id) = 'N' THEN
            RAISE_APPLICATION_ERROR(-20304, 'Email "' || p_email || '" juz istnieje w systemie');
        END IF;
        
        UPDATE nauczyciele SET
            email = NVL(p_email, email),
            telefon = NVL(p_telefon, telefon),
            czy_prowadzi_grupowe = NVL(p_grupowe, czy_prowadzi_grupowe),
            czy_akompaniator = NVL(p_akompaniator, czy_akompaniator)
        WHERE id_nauczyciela = p_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20305, 'Nauczyciel ID=' || p_id || ' nie istnieje');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[OK] Zaktualizowano nauczyciela ID=' || p_id);
        COMMIT;
    END;

    PROCEDURE usun(p_id NUMBER) IS
        v_cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_cnt FROM lekcje WHERE DEREF(ref_nauczyciel).id_nauczyciela = p_id;
        IF v_cnt > 0 THEN
            RAISE_APPLICATION_ERROR(-20306, 'Nie mozna usunac - ' || v_cnt || ' lekcji zaplanowanych');
        END IF;
        
        DELETE FROM nauczyciele WHERE id_nauczyciela = p_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20307, 'Nauczyciel ID=' || p_id || ' nie istnieje');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[OK] Usunieto nauczyciela ID=' || p_id);
        COMMIT;
    END;

    FUNCTION liczba_lekcji(p_id_nauczyciela NUMBER) RETURN NUMBER IS
        v_cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_cnt
        FROM lekcje
        WHERE DEREF(ref_nauczyciel).id_nauczyciela = p_id_nauczyciela;
        RETURN v_cnt;
    END;

    FUNCTION nauczyciele_instrumentu(p_instrument VARCHAR2) RETURN SYS_REFCURSOR IS
        v_cur SYS_REFCURSOR;
    BEGIN
        OPEN v_cur FOR
            SELECT id_nauczyciela, imie, nazwisko, instrumenty
            FROM nauczyciele
            WHERE status = 'aktywny'
              AND p_instrument MEMBER OF instrumenty;
        RETURN v_cur;
    END;

END pkg_nauczyciel;
/

-- ============================================================================
-- 9. ROZSZERZENIE: PKG_LEKCJA - wyswietlanie
-- ============================================================================

PROMPT [9/10] Rozszerzanie pakietu pkg_lekcja...

-- Dodajemy tylko procedure wyswietlania do istniejacego pakietu
-- (nie nadpisujemy calego pakietu)

-- ============================================================================
-- 10. ROZSZERZENIE: PKG_OCENA - wyswietlanie
-- ============================================================================

PROMPT [10/10] Rozszerzanie pakietu pkg_ocena...

CREATE OR REPLACE PACKAGE pkg_ocena AS

    PROCEDURE dodaj_ocene(
        p_wartosc       NUMBER,
        p_obszar        VARCHAR2,
        p_komentarz     VARCHAR2 DEFAULT NULL,
        p_id_ucznia     NUMBER,
        p_id_naucz      NUMBER,
        p_id_przedm     NUMBER,
        p_id_lekcji     NUMBER DEFAULT NULL
    );

    PROCEDURE wyswietl_wszystkie;
    PROCEDURE usun(p_id NUMBER);

    FUNCTION srednia_ucznia_przedmiot(p_id_ucznia NUMBER, p_id_przedm NUMBER) RETURN NUMBER;
    FUNCTION srednia_przedmiotu(p_id_przedm NUMBER) RETURN NUMBER;

END pkg_ocena;
/

CREATE OR REPLACE PACKAGE BODY pkg_ocena AS

    PROCEDURE dodaj_ocene(
        p_wartosc       NUMBER,
        p_obszar        VARCHAR2,
        p_komentarz     VARCHAR2 DEFAULT NULL,
        p_id_ucznia     NUMBER,
        p_id_naucz      NUMBER,
        p_id_przedm     NUMBER,
        p_id_lekcji     NUMBER DEFAULT NULL
    ) IS
        v_id      NUMBER;
        v_ref_u   REF t_uczen_obj;
        v_ref_n   REF t_nauczyciel_obj;
        v_ref_p   REF t_przedmiot_obj;
        v_ref_l   REF t_lekcja_obj := NULL;
    BEGIN
        IF p_wartosc NOT BETWEEN 1 AND 6 THEN
            RAISE_APPLICATION_ERROR(-20400, 'Ocena musi byc z zakresu 1-6');
        END IF;
        
        IF p_obszar NOT IN ('technika', 'interpretacja', 'sluch', 'teoria', 'rytm', 'ogolna') THEN
            RAISE_APPLICATION_ERROR(-20401, 'Niepoprawny obszar oceny');
        END IF;
        
        SELECT seq_oceny.NEXTVAL INTO v_id FROM dual;
        SELECT REF(u) INTO v_ref_u FROM uczniowie u WHERE id_ucznia = p_id_ucznia;
        SELECT REF(n) INTO v_ref_n FROM nauczyciele n WHERE id_nauczyciela = p_id_naucz;
        SELECT REF(p) INTO v_ref_p FROM przedmioty p WHERE id_przedmiotu = p_id_przedm;

        IF p_id_lekcji IS NOT NULL THEN
            SELECT REF(l) INTO v_ref_l FROM lekcje l WHERE id_lekcji = p_id_lekcji;
        END IF;

        INSERT INTO oceny VALUES (t_ocena_obj(
            v_id, SYSDATE, p_wartosc, p_obszar, p_komentarz,
            v_ref_u, v_ref_n, v_ref_p, v_ref_l
        ));

        DBMS_OUTPUT.PUT_LINE('[OK] Dodano ocene ' || p_wartosc || ' (ID=' || v_id || ')');
        COMMIT;
    END;

    PROCEDURE wyswietl_wszystkie IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== WSZYSTKIE OCENY ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('ID', 5) || RPAD('DATA', 12) || RPAD('OC', 4) || 
                            RPAD('OBSZAR', 14) || RPAD('UCZEN', 25) || 'PRZEDMIOT');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 85, '-'));
        
        FOR r IN (
            SELECT o.id_oceny, o.data_oceny, o.wartosc, o.obszar,
                   DEREF(o.ref_uczen).imie || ' ' || DEREF(o.ref_uczen).nazwisko AS uczen,
                   DEREF(o.ref_przedmiot).nazwa AS przedmiot
            FROM oceny o
            ORDER BY o.data_oceny DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.id_oceny, 5) ||
                RPAD(TO_CHAR(r.data_oceny, 'YYYY-MM-DD'), 12) ||
                RPAD(r.wartosc, 4) ||
                RPAD(r.obszar, 14) ||
                RPAD(r.uczen, 25) ||
                r.przedmiot
            );
        END LOOP;
    END;

    PROCEDURE usun(p_id NUMBER) IS
    BEGIN
        DELETE FROM oceny WHERE id_oceny = p_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20402, 'Ocena ID=' || p_id || ' nie istnieje');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[OK] Usunieto ocene ID=' || p_id);
        COMMIT;
    END;

    FUNCTION srednia_ucznia_przedmiot(p_id_ucznia NUMBER, p_id_przedm NUMBER) RETURN NUMBER IS
        v_srednia NUMBER;
    BEGIN
        SELECT AVG(wartosc) INTO v_srednia
        FROM oceny
        WHERE DEREF(ref_uczen).id_ucznia = p_id_ucznia
          AND DEREF(ref_przedmiot).id_przedmiotu = p_id_przedm;
        RETURN ROUND(NVL(v_srednia, 0), 2);
    END;

    FUNCTION srednia_przedmiotu(p_id_przedm NUMBER) RETURN NUMBER IS
        v_srednia NUMBER;
    BEGIN
        SELECT AVG(wartosc) INTO v_srednia
        FROM oceny
        WHERE DEREF(ref_przedmiot).id_przedmiotu = p_id_przedm;
        RETURN ROUND(NVL(v_srednia, 0), 2);
    END;

END pkg_ocena;
/

-- ============================================================================
-- SYNONIMY
-- ============================================================================

PROMPT Tworzenie synonimow...

CREATE OR REPLACE PUBLIC SYNONYM pkg_semestr FOR pkg_semestr;
CREATE OR REPLACE PUBLIC SYNONYM pkg_instrument FOR pkg_instrument;
CREATE OR REPLACE PUBLIC SYNONYM pkg_sala FOR pkg_sala;
CREATE OR REPLACE PUBLIC SYNONYM pkg_grupa FOR pkg_grupa;
CREATE OR REPLACE PUBLIC SYNONYM pkg_przedmiot FOR pkg_przedmiot;
CREATE OR REPLACE PUBLIC SYNONYM pkg_egzamin FOR pkg_egzamin;

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================

PROMPT
PROMPT ========================================================================
PROMPT   UTWORZONE PAKIETY CRUD
PROMPT ========================================================================
PROMPT   pkg_semestr - CRUD semestr + walidacja dat
PROMPT   pkg_instrument - CRUD instrument + unikalnosc nazwy
PROMPT   pkg_sala - CRUD sala + sprawdzanie dostepnosci
PROMPT   pkg_grupa - CRUD grupa + zarzadzanie uczniami
PROMPT   pkg_przedmiot - CRUD przedmiot
PROMPT   pkg_egzamin - CRUD egzamin + komisja + wyniki
PROMPT   pkg_uczen - rozszerzony o walidacje email/tel + wyswietlanie
PROMPT   pkg_nauczyciel - rozszerzony o walidacje + wyswietlanie
PROMPT   pkg_ocena - rozszerzony o wyswietlanie + usuwanie
PROMPT ========================================================================
PROMPT   Nastepny krok: Uruchom 09_testy.sql
PROMPT ========================================================================

SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('PACKAGE', 'PACKAGE BODY')
  AND object_name LIKE 'PKG_%'
ORDER BY object_name, object_type;
