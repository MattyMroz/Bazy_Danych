-- ============================================================================
-- Projekt: Szkola Muzyczna - Obiektowa Baza Danych
-- Plik: 03_pakiety.sql
-- Opis: Pakiety PL/SQL do zarzadzania danymi (CRUD + logika biznesowa)
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
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

    -- Dodawanie instrumentu
    PROCEDURE dodaj_instrument(
        p_nazwa         VARCHAR2,
        p_czy_orkiestra CHAR DEFAULT 'N'
    );

    -- Dodawanie przedmiotu
    PROCEDURE dodaj_przedmiot(
        p_nazwa             VARCHAR2,
        p_typ_zajec         VARCHAR2,
        p_domyslny_czas     NUMBER,
        p_wyposazenie       T_WYPOSAZENIE DEFAULT NULL
    );

    -- Dodawanie sali
    PROCEDURE dodaj_sale(
        p_numer         VARCHAR2,
        p_typ           VARCHAR2,
        p_pojemnosc     NUMBER,
        p_wyposazenie   T_WYPOSAZENIE DEFAULT NULL
    );

    -- Dodawanie grupy
    PROCEDURE dodaj_grupe(
        p_kod           VARCHAR2,
        p_klasa         NUMBER,
        p_rok_szkolny   VARCHAR2 DEFAULT '2025/2026'
    );

    -- Pobieranie REF do instrumentu po nazwie
    FUNCTION get_ref_instrument(p_nazwa VARCHAR2) RETURN REF T_INSTRUMENT;

    -- Pobieranie REF do przedmiotu po nazwie
    FUNCTION get_ref_przedmiot(p_nazwa VARCHAR2) RETURN REF T_PRZEDMIOT;

    -- Pobieranie REF do sali po numerze
    FUNCTION get_ref_sala(p_numer VARCHAR2) RETURN REF T_SALA;

    -- Pobieranie REF do grupy po kodzie
    FUNCTION get_ref_grupa(p_kod VARCHAR2) RETURN REF T_GRUPA;

END PKG_SLOWNIKI;
/

CREATE OR REPLACE PACKAGE BODY PKG_SLOWNIKI AS

    PROCEDURE dodaj_instrument(
        p_nazwa         VARCHAR2,
        p_czy_orkiestra CHAR DEFAULT 'N'
    ) IS
    BEGIN
        INSERT INTO INSTRUMENTY VALUES (
            T_INSTRUMENT(
                seq_instrumenty.NEXTVAL,
                p_nazwa,
                p_czy_orkiestra
            )
        );
        COMMIT;
    END;

    PROCEDURE dodaj_przedmiot(
        p_nazwa             VARCHAR2,
        p_typ_zajec         VARCHAR2,
        p_domyslny_czas     NUMBER,
        p_wyposazenie       T_WYPOSAZENIE DEFAULT NULL
    ) IS
    BEGIN
        INSERT INTO PRZEDMIOTY VALUES (
            T_PRZEDMIOT(
                seq_przedmioty.NEXTVAL,
                p_nazwa,
                p_typ_zajec,
                p_domyslny_czas,
                p_wyposazenie
            )
        );
        COMMIT;
    END;

    PROCEDURE dodaj_sale(
        p_numer         VARCHAR2,
        p_typ           VARCHAR2,
        p_pojemnosc     NUMBER,
        p_wyposazenie   T_WYPOSAZENIE DEFAULT NULL
    ) IS
    BEGIN
        INSERT INTO SALE VALUES (
            T_SALA(
                seq_sale.NEXTVAL,
                p_numer,
                p_typ,
                p_pojemnosc,
                p_wyposazenie
            )
        );
        COMMIT;
    END;

    PROCEDURE dodaj_grupe(
        p_kod           VARCHAR2,
        p_klasa         NUMBER,
        p_rok_szkolny   VARCHAR2 DEFAULT '2025/2026'
    ) IS
    BEGIN
        INSERT INTO GRUPY VALUES (
            T_GRUPA(
                seq_grupy.NEXTVAL,
                p_kod,
                p_klasa,
                p_rok_szkolny
            )
        );
        COMMIT;
    END;

    FUNCTION get_ref_instrument(p_nazwa VARCHAR2) RETURN REF T_INSTRUMENT IS
        v_ref REF T_INSTRUMENT;
    BEGIN
        SELECT REF(i) INTO v_ref 
        FROM INSTRUMENTY i 
        WHERE UPPER(i.nazwa) = UPPER(p_nazwa);
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Instrument nie znaleziony: ' || p_nazwa);
    END;

    FUNCTION get_ref_przedmiot(p_nazwa VARCHAR2) RETURN REF T_PRZEDMIOT IS
        v_ref REF T_PRZEDMIOT;
    BEGIN
        SELECT REF(p) INTO v_ref 
        FROM PRZEDMIOTY p 
        WHERE UPPER(p.nazwa) = UPPER(p_nazwa);
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'Przedmiot nie znaleziony: ' || p_nazwa);
    END;

    FUNCTION get_ref_sala(p_numer VARCHAR2) RETURN REF T_SALA IS
        v_ref REF T_SALA;
    BEGIN
        SELECT REF(s) INTO v_ref 
        FROM SALE s 
        WHERE s.numer = p_numer;
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20003, 'Sala nie znaleziona: ' || p_numer);
    END;

    FUNCTION get_ref_grupa(p_kod VARCHAR2) RETURN REF T_GRUPA IS
        v_ref REF T_GRUPA;
    BEGIN
        SELECT REF(g) INTO v_ref 
        FROM GRUPY g 
        WHERE UPPER(g.kod) = UPPER(p_kod);
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20004, 'Grupa nie znaleziona: ' || p_kod);
    END;

END PKG_SLOWNIKI;
/

-- ============================================================================
-- 3. PAKIET PKG_OSOBY - Zarzadzanie nauczycielami i uczniami
-- ============================================================================

CREATE OR REPLACE PACKAGE PKG_OSOBY AS

    -- Dodawanie nauczyciela
    PROCEDURE dodaj_nauczyciela(
        p_imie          VARCHAR2,
        p_nazwisko      VARCHAR2,
        p_instrumenty   T_INSTRUMENTY_TAB DEFAULT NULL,
        p_email         VARCHAR2 DEFAULT NULL,
        p_telefon       VARCHAR2 DEFAULT NULL
    );

    -- Dodawanie ucznia (automatycznie przypisuje do grupy i instrumentu)
    PROCEDURE dodaj_ucznia(
        p_imie              VARCHAR2,
        p_nazwisko          VARCHAR2,
        p_data_urodzenia    DATE,
        p_kod_grupy         VARCHAR2,
        p_instrument        VARCHAR2,
        p_email_rodzica     VARCHAR2 DEFAULT NULL,
        p_telefon_rodzica   VARCHAR2 DEFAULT NULL
    );

    -- Pobieranie REF do nauczyciela po nazwisku
    FUNCTION get_ref_nauczyciel(p_nazwisko VARCHAR2) RETURN REF T_NAUCZYCIEL;

    -- Pobieranie REF do ucznia po nazwisku i imieniu
    FUNCTION get_ref_uczen(p_nazwisko VARCHAR2, p_imie VARCHAR2 DEFAULT NULL) RETURN REF T_UCZEN;

    -- Liczba uczniow nauczyciela
    FUNCTION liczba_uczniow_nauczyciela(p_id_nauczyciela NUMBER) RETURN NUMBER;

    -- Lista uczniow w grupie
    FUNCTION uczniowie_w_grupie(p_kod_grupy VARCHAR2) RETURN SYS_REFCURSOR;

    -- Lista uczniow danego nauczyciela (wg instrumentu)
    FUNCTION uczniowie_nauczyciela(p_nazwisko VARCHAR2) RETURN SYS_REFCURSOR;

END PKG_OSOBY;
/

CREATE OR REPLACE PACKAGE BODY PKG_OSOBY AS

    PROCEDURE dodaj_nauczyciela(
        p_imie          VARCHAR2,
        p_nazwisko      VARCHAR2,
        p_instrumenty   T_INSTRUMENTY_TAB DEFAULT NULL,
        p_email         VARCHAR2 DEFAULT NULL,
        p_telefon       VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        INSERT INTO NAUCZYCIELE VALUES (
            T_NAUCZYCIEL(
                seq_nauczyciele.NEXTVAL,
                p_imie,
                p_nazwisko,
                p_instrumenty,
                p_email,
                p_telefon,
                6,   -- max_godzin_dziennie (domyslnie 6)
                30   -- max_godzin_tydzien (domyslnie 30)
            )
        );
        COMMIT;
    END;

    PROCEDURE dodaj_ucznia(
        p_imie              VARCHAR2,
        p_nazwisko          VARCHAR2,
        p_data_urodzenia    DATE,
        p_kod_grupy         VARCHAR2,
        p_instrument        VARCHAR2,
        p_email_rodzica     VARCHAR2 DEFAULT NULL,
        p_telefon_rodzica   VARCHAR2 DEFAULT NULL
    ) IS
        v_ref_grupa     REF T_GRUPA;
        v_ref_instrument REF T_INSTRUMENT;
    BEGIN
        -- Pobierz referencje do grupy i instrumentu
        v_ref_grupa := PKG_SLOWNIKI.get_ref_grupa(p_kod_grupy);
        v_ref_instrument := PKG_SLOWNIKI.get_ref_instrument(p_instrument);

        INSERT INTO UCZNIOWIE VALUES (
            T_UCZEN(
                seq_uczniowie.NEXTVAL,
                p_imie,
                p_nazwisko,
                p_data_urodzenia,
                v_ref_grupa,
                v_ref_instrument,
                p_email_rodzica,
                p_telefon_rodzica,
                SYSDATE  -- data_zapisu
            )
        );
        COMMIT;
    END;

    FUNCTION get_ref_nauczyciel(p_nazwisko VARCHAR2) RETURN REF T_NAUCZYCIEL IS
        v_ref REF T_NAUCZYCIEL;
    BEGIN
        SELECT REF(n) INTO v_ref 
        FROM NAUCZYCIELE n 
        WHERE UPPER(n.nazwisko) = UPPER(p_nazwisko)
        AND ROWNUM = 1;  -- na wypadek powtorzonych nazwisk
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20005, 'Nauczyciel nie znaleziony: ' || p_nazwisko);
    END;

    FUNCTION get_ref_uczen(p_nazwisko VARCHAR2, p_imie VARCHAR2 DEFAULT NULL) RETURN REF T_UCZEN IS
        v_ref REF T_UCZEN;
    BEGIN
        IF p_imie IS NOT NULL THEN
            SELECT REF(u) INTO v_ref 
            FROM UCZNIOWIE u 
            WHERE UPPER(u.nazwisko) = UPPER(p_nazwisko)
            AND UPPER(u.imie) = UPPER(p_imie);
        ELSE
            SELECT REF(u) INTO v_ref 
            FROM UCZNIOWIE u 
            WHERE UPPER(u.nazwisko) = UPPER(p_nazwisko)
            AND ROWNUM = 1;
        END IF;
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20006, 'Uczen nie znaleziony: ' || p_nazwisko);
    END;

    FUNCTION liczba_uczniow_nauczyciela(p_id_nauczyciela NUMBER) RETURN NUMBER IS
        v_count NUMBER;
        v_instrumenty T_INSTRUMENTY_TAB;
    BEGIN
        -- Pobierz instrumenty nauczyciela
        SELECT n.instrumenty INTO v_instrumenty
        FROM NAUCZYCIELE n
        WHERE n.id_nauczyciela = p_id_nauczyciela;

        -- Policz uczniow grajacych na tych instrumentach
        SELECT COUNT(*) INTO v_count
        FROM UCZNIOWIE u
        WHERE DEREF(u.ref_instrument).nazwa IN (
            SELECT COLUMN_VALUE FROM TABLE(v_instrumenty)
        );

        RETURN v_count;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END;

    FUNCTION uczniowie_w_grupie(p_kod_grupy VARCHAR2) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT u.id_ucznia,
                   u.imie,
                   u.nazwisko,
                   DEREF(u.ref_instrument).nazwa AS instrument
            FROM UCZNIOWIE u
            WHERE DEREF(u.ref_grupa).kod = p_kod_grupy
            ORDER BY u.nazwisko, u.imie;
        RETURN v_cursor;
    END;

    FUNCTION uczniowie_nauczyciela(p_nazwisko VARCHAR2) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
        v_instrumenty T_INSTRUMENTY_TAB;
    BEGIN
        -- Pobierz instrumenty nauczyciela
        SELECT n.instrumenty INTO v_instrumenty
        FROM NAUCZYCIELE n
        WHERE UPPER(n.nazwisko) = UPPER(p_nazwisko);

        -- Zwroc uczniow grajacych na tych instrumentach
        OPEN v_cursor FOR
            SELECT u.id_ucznia,
                   u.imie,
                   u.nazwisko,
                   DEREF(u.ref_instrument).nazwa AS instrument,
                   DEREF(u.ref_grupa).kod AS grupa,
                   DEREF(u.ref_grupa).klasa AS klasa
            FROM UCZNIOWIE u
            WHERE DEREF(u.ref_instrument).nazwa IN (
                SELECT COLUMN_VALUE FROM TABLE(v_instrumenty)
            )
            ORDER BY DEREF(u.ref_grupa).klasa, u.nazwisko;
        RETURN v_cursor;
    END;

END PKG_OSOBY;
/

-- ============================================================================
-- 4. PAKIET PKG_LEKCJE - Zarzadzanie lekcjami i planowaniem
-- ============================================================================

CREATE OR REPLACE PACKAGE PKG_LEKCJE AS

    -- Dodawanie lekcji indywidualnej
    PROCEDURE dodaj_lekcje_indywidualna(
        p_przedmiot         VARCHAR2,
        p_nauczyciel_nazwisko VARCHAR2,
        p_sala_numer        VARCHAR2,
        p_uczen_nazwisko    VARCHAR2,
        p_uczen_imie        VARCHAR2,
        p_data              DATE,
        p_godzina           VARCHAR2,
        p_czas_min          NUMBER DEFAULT 45
    );

    -- Dodawanie lekcji grupowej
    PROCEDURE dodaj_lekcje_grupowa(
        p_przedmiot         VARCHAR2,
        p_nauczyciel_nazwisko VARCHAR2,
        p_sala_numer        VARCHAR2,
        p_grupa_kod         VARCHAR2,
        p_data              DATE,
        p_godzina           VARCHAR2,
        p_czas_min          NUMBER DEFAULT 45
    );

    -- Dodawanie egzaminu (z komisja)
    PROCEDURE dodaj_egzamin(
        p_uczen_nazwisko    VARCHAR2,
        p_uczen_imie        VARCHAR2,
        p_sala_numer        VARCHAR2,
        p_data              DATE,
        p_godzina           VARCHAR2,
        p_komisja_nazwisko1 VARCHAR2,
        p_komisja_nazwisko2 VARCHAR2,
        p_czas_min          NUMBER DEFAULT 45
    );

    -- Zmiana statusu lekcji
    PROCEDURE zmien_status_lekcji(
        p_id_lekcji NUMBER,
        p_nowy_status VARCHAR2
    );

    -- Sprawdzenie konfliktu sali
    FUNCTION czy_sala_wolna(
        p_numer_sali    VARCHAR2,
        p_data          DATE,
        p_godzina_start VARCHAR2,
        p_czas_min      NUMBER
    ) RETURN BOOLEAN;

    -- Sprawdzenie konfliktu nauczyciela
    FUNCTION czy_nauczyciel_wolny(
        p_nazwisko      VARCHAR2,
        p_data          DATE,
        p_godzina_start VARCHAR2,
        p_czas_min      NUMBER
    ) RETURN BOOLEAN;

    -- Sprawdzenie konfliktu ucznia
    FUNCTION czy_uczen_wolny(
        p_nazwisko      VARCHAR2,
        p_imie          VARCHAR2,
        p_data          DATE,
        p_godzina_start VARCHAR2,
        p_czas_min      NUMBER
    ) RETURN BOOLEAN;

    -- Plan tygodnia ucznia
    FUNCTION plan_ucznia(
        p_nazwisko VARCHAR2,
        p_imie     VARCHAR2,
        p_data_od  DATE,
        p_data_do  DATE
    ) RETURN SYS_REFCURSOR;

    -- Plan dnia sali
    FUNCTION plan_sali(
        p_numer_sali VARCHAR2,
        p_data       DATE
    ) RETURN SYS_REFCURSOR;

    -- Plan nauczyciela na okres
    FUNCTION plan_nauczyciela(
        p_nazwisko VARCHAR2,
        p_data_od  DATE,
        p_data_do  DATE
    ) RETURN SYS_REFCURSOR;

    -- Plan grupy na okres
    FUNCTION plan_grupy(
        p_kod_grupy VARCHAR2,
        p_data_od   DATE,
        p_data_do   DATE
    ) RETURN SYS_REFCURSOR;

    -- Egzaminy ucznia
    FUNCTION egzaminy_ucznia(
        p_nazwisko VARCHAR2,
        p_imie     VARCHAR2
    ) RETURN SYS_REFCURSOR;

    -- Egzaminy nauczyciela (w ktorych jest w komisji)
    FUNCTION egzaminy_nauczyciela(
        p_nazwisko VARCHAR2
    ) RETURN SYS_REFCURSOR;

    -- =======================================================================
    -- HEURYSTYKA PRZYDZIALU NAUCZYCIELA
    -- =======================================================================

    -- Znajdz nauczyciela od danego instrumentu z NAJMNIEJSZYM obciazeniem
    FUNCTION znajdz_nauczyciela_heurystyka(
        p_instrument    VARCHAR2,
        p_data          DATE,
        p_godzina       VARCHAR2,
        p_czas_min      NUMBER
    ) RETURN VARCHAR2;

    -- Automatyczne tworzenie lekcji z heurystyka doboru nauczyciela
    -- System sam wybiera nauczyciela z najmniejsza liczba lekcji w danym terminie
    -- Czas lekcji pobierany automatycznie z klasy ucznia (30 min dla I-III, 45 min dla IV-VI)
    PROCEDURE przydziel_lekcje_indywidualna(
        p_uczen_nazwisko    VARCHAR2,
        p_uczen_imie        VARCHAR2,
        p_data              DATE,
        p_godzina           VARCHAR2,
        p_czas_min          NUMBER DEFAULT NULL  -- NULL = automatycznie z klasy
    );

    -- =======================================================================
    -- GENEROWANIE PLANU SEMESTRALNEGO
    -- =======================================================================

    -- Generuje plan lekcji indywidualnych dla WSZYSTKICH uczniow na dany tydzien
    -- Kazdy uczen dostaje 2 lekcje instrumentu (poniedzialek + sroda LUB wtorek + czwartek)
    PROCEDURE generuj_lekcje_indywidualne_tydzien(
        p_data_poniedzialek DATE  -- poczatek tygodnia (poniedzialek)
    );

    -- Generuje plan lekcji grupowych dla WSZYSTKICH grup na dany tydzien
    -- Kazda grupa dostaje: Ksztalcenie sluchu, Rytmika, Audycje muzyczne
    -- Klasy IV-VI dodatkowo: Chor lub Orkiestra
    PROCEDURE generuj_lekcje_grupowe_tydzien(
        p_data_poniedzialek DATE  -- poczatek tygodnia (poniedzialek)
    );

    -- Generuje KOMPLETNY plan tygodnia (indywidualne + grupowe)
    PROCEDURE generuj_plan_tygodnia(
        p_data_poniedzialek DATE
    );

END PKG_LEKCJE;
/

CREATE OR REPLACE PACKAGE BODY PKG_LEKCJE AS

    -- Funkcja pomocnicza: konwersja godziny na minuty od polnocy
    FUNCTION godzina_na_minuty(p_godzina VARCHAR2) RETURN NUMBER IS
    BEGIN
        RETURN TO_NUMBER(SUBSTR(p_godzina, 1, 2)) * 60 +
               TO_NUMBER(SUBSTR(p_godzina, 4, 2));
    END;

    -- Funkcja pomocnicza: sprawdzenie nakladania sie czasow
    FUNCTION czy_naklada_sie(
        p_start1 NUMBER, p_koniec1 NUMBER,
        p_start2 NUMBER, p_koniec2 NUMBER
    ) RETURN BOOLEAN IS
    BEGIN
        -- Nakladanie: start1 < koniec2 AND start2 < koniec1
        RETURN p_start1 < p_koniec2 AND p_start2 < p_koniec1;
    END;

    PROCEDURE dodaj_lekcje_indywidualna(
        p_przedmiot         VARCHAR2,
        p_nauczyciel_nazwisko VARCHAR2,
        p_sala_numer        VARCHAR2,
        p_uczen_nazwisko    VARCHAR2,
        p_uczen_imie        VARCHAR2,
        p_data              DATE,
        p_godzina           VARCHAR2,
        p_czas_min          NUMBER DEFAULT 45
    ) IS
    BEGIN
        -- Walidacja konfliktow
        IF NOT czy_sala_wolna(p_sala_numer, p_data, p_godzina, p_czas_min) THEN
            RAISE_APPLICATION_ERROR(-20010, 'Sala zajeta w tym terminie');
        END IF;

        IF NOT czy_nauczyciel_wolny(p_nauczyciel_nazwisko, p_data, p_godzina, p_czas_min) THEN
            RAISE_APPLICATION_ERROR(-20011, 'Nauczyciel zajety w tym terminie');
        END IF;

        IF NOT czy_uczen_wolny(p_uczen_nazwisko, p_uczen_imie, p_data, p_godzina, p_czas_min) THEN
            RAISE_APPLICATION_ERROR(-20012, 'Uczen zajety w tym terminie');
        END IF;

        INSERT INTO LEKCJE VALUES (
            T_LEKCJA(
                seq_lekcje.NEXTVAL,
                PKG_SLOWNIKI.get_ref_przedmiot(p_przedmiot),
                PKG_OSOBY.get_ref_nauczyciel(p_nauczyciel_nazwisko),
                PKG_SLOWNIKI.get_ref_sala(p_sala_numer),
                PKG_OSOBY.get_ref_uczen(p_uczen_nazwisko, p_uczen_imie),
                NULL,  -- ref_grupa (NULL dla indywidualnej)
                p_data,
                p_godzina,
                p_czas_min,
                'zwykla',
                'zaplanowana',
                NULL   -- komisja (NULL dla zwyklej lekcji)
            )
        );
        COMMIT;
    END;

    PROCEDURE dodaj_lekcje_grupowa(
        p_przedmiot         VARCHAR2,
        p_nauczyciel_nazwisko VARCHAR2,
        p_sala_numer        VARCHAR2,
        p_grupa_kod         VARCHAR2,
        p_data              DATE,
        p_godzina           VARCHAR2,
        p_czas_min          NUMBER DEFAULT 45
    ) IS
    BEGIN
        -- Walidacja konfliktow
        IF NOT czy_sala_wolna(p_sala_numer, p_data, p_godzina, p_czas_min) THEN
            RAISE_APPLICATION_ERROR(-20010, 'Sala zajeta w tym terminie');
        END IF;

        IF NOT czy_nauczyciel_wolny(p_nauczyciel_nazwisko, p_data, p_godzina, p_czas_min) THEN
            RAISE_APPLICATION_ERROR(-20011, 'Nauczyciel zajety w tym terminie');
        END IF;

        INSERT INTO LEKCJE VALUES (
            T_LEKCJA(
                seq_lekcje.NEXTVAL,
                PKG_SLOWNIKI.get_ref_przedmiot(p_przedmiot),
                PKG_OSOBY.get_ref_nauczyciel(p_nauczyciel_nazwisko),
                PKG_SLOWNIKI.get_ref_sala(p_sala_numer),
                NULL,  -- ref_uczen (NULL dla grupowej)
                PKG_SLOWNIKI.get_ref_grupa(p_grupa_kod),
                p_data,
                p_godzina,
                p_czas_min,
                'zwykla',
                'zaplanowana',
                NULL   -- komisja
            )
        );
        COMMIT;
    END;

    PROCEDURE dodaj_egzamin(
        p_uczen_nazwisko    VARCHAR2,
        p_uczen_imie        VARCHAR2,
        p_sala_numer        VARCHAR2,
        p_data              DATE,
        p_godzina           VARCHAR2,
        p_komisja_nazwisko1 VARCHAR2,
        p_komisja_nazwisko2 VARCHAR2,
        p_czas_min          NUMBER DEFAULT 45
    ) IS
        v_id_naucz1 NUMBER;
        v_id_naucz2 NUMBER;
        v_ref_uczen REF T_UCZEN;
        v_instrument_nazwa VARCHAR2(50);
    BEGIN
        -- Pobierz ID nauczycieli do komisji
        SELECT id_nauczyciela INTO v_id_naucz1 
        FROM NAUCZYCIELE WHERE UPPER(nazwisko) = UPPER(p_komisja_nazwisko1);

        SELECT id_nauczyciela INTO v_id_naucz2 
        FROM NAUCZYCIELE WHERE UPPER(nazwisko) = UPPER(p_komisja_nazwisko2);

        -- Sprawdz czy to rozni nauczyciele (trigger tez to sprawdzi)
        IF v_id_naucz1 = v_id_naucz2 THEN
            RAISE_APPLICATION_ERROR(-20013, 'Komisja musi skladac sie z 2 ROZNYCH nauczycieli');
        END IF;

        -- Pobierz referencje do ucznia i jego instrument
        v_ref_uczen := PKG_OSOBY.get_ref_uczen(p_uczen_nazwisko, p_uczen_imie);

        SELECT DEREF(u.ref_instrument).nazwa INTO v_instrument_nazwa
        FROM UCZNIOWIE u
        WHERE u.imie = p_uczen_imie AND u.nazwisko = p_uczen_nazwisko;

        INSERT INTO LEKCJE VALUES (
            T_LEKCJA(
                seq_lekcje.NEXTVAL,
                PKG_SLOWNIKI.get_ref_przedmiot(v_instrument_nazwa),  -- przedmiot = instrument ucznia
                PKG_OSOBY.get_ref_nauczyciel(p_komisja_nazwisko1),   -- pierwszy z komisji jako prowadzacy
                PKG_SLOWNIKI.get_ref_sala(p_sala_numer),
                v_ref_uczen,
                NULL,  -- ref_grupa
                p_data,
                p_godzina,
                p_czas_min,
                'egzamin',
                'zaplanowana',
                T_KOMISJA(v_id_naucz1, v_id_naucz2)
            )
        );
        COMMIT;
    END;

    PROCEDURE zmien_status_lekcji(
        p_id_lekcji NUMBER,
        p_nowy_status VARCHAR2
    ) IS
    BEGIN
        UPDATE LEKCJE SET status = p_nowy_status
        WHERE id_lekcji = p_id_lekcji;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20014, 'Lekcja o podanym ID nie istnieje');
        END IF;
        COMMIT;
    END;

    FUNCTION czy_sala_wolna(
        p_numer_sali    VARCHAR2,
        p_data          DATE,
        p_godzina_start VARCHAR2,
        p_czas_min      NUMBER
    ) RETURN BOOLEAN IS
        v_count NUMBER;
        v_start_min NUMBER := godzina_na_minuty(p_godzina_start);
        v_koniec_min NUMBER := v_start_min + p_czas_min;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM LEKCJE l
        WHERE DEREF(l.ref_sala).numer = p_numer_sali
        AND l.data_lekcji = p_data
        AND l.status != 'odwolana'
        AND czy_naklada_sie(
            godzina_na_minuty(l.godzina_start),
            godzina_na_minuty(l.godzina_start) + l.czas_trwania_min,
            v_start_min, v_koniec_min
        );

        RETURN v_count = 0;
    END;

    FUNCTION czy_nauczyciel_wolny(
        p_nazwisko      VARCHAR2,
        p_data          DATE,
        p_godzina_start VARCHAR2,
        p_czas_min      NUMBER
    ) RETURN BOOLEAN IS
        v_count NUMBER;
        v_start_min NUMBER := godzina_na_minuty(p_godzina_start);
        v_koniec_min NUMBER := v_start_min + p_czas_min;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM LEKCJE l
        WHERE DEREF(l.ref_nauczyciel).nazwisko = p_nazwisko
        AND l.data_lekcji = p_data
        AND l.status != 'odwolana'
        AND czy_naklada_sie(
            godzina_na_minuty(l.godzina_start),
            godzina_na_minuty(l.godzina_start) + l.czas_trwania_min,
            v_start_min, v_koniec_min
        );

        RETURN v_count = 0;
    END;

    FUNCTION czy_uczen_wolny(
        p_nazwisko      VARCHAR2,
        p_imie          VARCHAR2,
        p_data          DATE,
        p_godzina_start VARCHAR2,
        p_czas_min      NUMBER
    ) RETURN BOOLEAN IS
        v_count NUMBER;
        v_start_min NUMBER := godzina_na_minuty(p_godzina_start);
        v_koniec_min NUMBER := v_start_min + p_czas_min;
        v_id_ucznia NUMBER;
        v_kod_grupy VARCHAR2(10);
    BEGIN
        -- Pobierz ID ucznia i jego grupe
        SELECT u.id_ucznia, DEREF(u.ref_grupa).kod 
        INTO v_id_ucznia, v_kod_grupy
        FROM UCZNIOWIE u
        WHERE UPPER(u.nazwisko) = UPPER(p_nazwisko)
        AND UPPER(u.imie) = UPPER(p_imie);

        -- Sprawdz lekcje indywidualne ucznia
        SELECT COUNT(*) INTO v_count
        FROM LEKCJE l
        WHERE DEREF(l.ref_uczen).id_ucznia = v_id_ucznia
        AND l.data_lekcji = p_data
        AND l.status != 'odwolana'
        AND czy_naklada_sie(
            godzina_na_minuty(l.godzina_start),
            godzina_na_minuty(l.godzina_start) + l.czas_trwania_min,
            v_start_min, v_koniec_min
        );

        IF v_count > 0 THEN RETURN FALSE; END IF;

        -- Sprawdz lekcje grupowe ucznia
        SELECT COUNT(*) INTO v_count
        FROM LEKCJE l
        WHERE DEREF(l.ref_grupa).kod = v_kod_grupy
        AND l.data_lekcji = p_data
        AND l.status != 'odwolana'
        AND czy_naklada_sie(
            godzina_na_minuty(l.godzina_start),
            godzina_na_minuty(l.godzina_start) + l.czas_trwania_min,
            v_start_min, v_koniec_min
        );

        RETURN v_count = 0;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN TRUE;  -- uczen nie istnieje = wolny (blad wychwyci insert)
    END;

    FUNCTION plan_ucznia(
        p_nazwisko VARCHAR2,
        p_imie     VARCHAR2,
        p_data_od  DATE,
        p_data_do  DATE
    ) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
        v_id_ucznia NUMBER;
        v_kod_grupy VARCHAR2(10);
    BEGIN
        -- Pobierz ID ucznia i grupe
        SELECT u.id_ucznia, DEREF(u.ref_grupa).kod 
        INTO v_id_ucznia, v_kod_grupy
        FROM UCZNIOWIE u
        WHERE UPPER(u.nazwisko) = UPPER(p_nazwisko)
        AND UPPER(u.imie) = UPPER(p_imie);

        OPEN v_cursor FOR
            SELECT l.data_lekcji,
                   l.godzina_start,
                   l.czas_trwania_min,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
                   DEREF(l.ref_sala).numer AS sala,
                   l.typ_lekcji,
                   l.status
            FROM LEKCJE l
            WHERE (DEREF(l.ref_uczen).id_ucznia = v_id_ucznia
                   OR DEREF(l.ref_grupa).kod = v_kod_grupy)
            AND l.data_lekcji BETWEEN p_data_od AND p_data_do
            ORDER BY l.data_lekcji, l.godzina_start;

        RETURN v_cursor;
    END;

    FUNCTION plan_sali(
        p_numer_sali VARCHAR2,
        p_data       DATE
    ) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT l.godzina_start,
                   l.czas_trwania_min,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
                   NVL(DEREF(l.ref_uczen).pelne_nazwisko(), DEREF(l.ref_grupa).kod) AS kto,
                   l.typ_lekcji,
                   l.status
            FROM LEKCJE l
            WHERE DEREF(l.ref_sala).numer = p_numer_sali
            AND l.data_lekcji = p_data
            ORDER BY l.godzina_start;

        RETURN v_cursor;
    END;

    FUNCTION plan_nauczyciela(
        p_nazwisko VARCHAR2,
        p_data_od  DATE,
        p_data_do  DATE
    ) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT l.data_lekcji,
                   l.godzina_start,
                   l.czas_trwania_min,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_sala).numer AS sala,
                   NVL(DEREF(l.ref_uczen).pelne_nazwisko(), DEREF(l.ref_grupa).kod) AS kto,
                   l.typ_lekcji,
                   l.status
            FROM LEKCJE l
            WHERE UPPER(DEREF(l.ref_nauczyciel).nazwisko) = UPPER(p_nazwisko)
            AND l.data_lekcji BETWEEN p_data_od AND p_data_do
            ORDER BY l.data_lekcji, l.godzina_start;
        RETURN v_cursor;
    END;

    FUNCTION plan_grupy(
        p_kod_grupy VARCHAR2,
        p_data_od   DATE,
        p_data_do   DATE
    ) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT l.data_lekcji,
                   l.godzina_start,
                   l.czas_trwania_min,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
                   DEREF(l.ref_sala).numer AS sala,
                   l.typ_lekcji,
                   l.status
            FROM LEKCJE l
            WHERE UPPER(DEREF(l.ref_grupa).kod) = UPPER(p_kod_grupy)
            AND l.data_lekcji BETWEEN p_data_od AND p_data_do
            ORDER BY l.data_lekcji, l.godzina_start;
        RETURN v_cursor;
    END;

    FUNCTION egzaminy_ucznia(
        p_nazwisko VARCHAR2,
        p_imie     VARCHAR2
    ) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT l.data_lekcji,
                   l.godzina_start,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_sala).numer AS sala,
                   l.komisja,
                   l.status
            FROM LEKCJE l
            WHERE l.typ_lekcji = 'egzamin'
            AND UPPER(DEREF(l.ref_uczen).nazwisko) = UPPER(p_nazwisko)
            AND UPPER(DEREF(l.ref_uczen).imie) = UPPER(p_imie)
            ORDER BY l.data_lekcji;
        RETURN v_cursor;
    END;

    FUNCTION egzaminy_nauczyciela(
        p_nazwisko VARCHAR2
    ) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
        v_id_nauczyciela NUMBER;
    BEGIN
        SELECT id_nauczyciela INTO v_id_nauczyciela
        FROM NAUCZYCIELE WHERE UPPER(nazwisko) = UPPER(p_nazwisko);

        OPEN v_cursor FOR
            SELECT l.data_lekcji,
                   l.godzina_start,
                   DEREF(l.ref_uczen).pelne_nazwisko() AS uczen,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_sala).numer AS sala,
                   l.status
            FROM LEKCJE l
            WHERE l.typ_lekcji = 'egzamin'
            AND (l.komisja(1) = v_id_nauczyciela OR l.komisja(2) = v_id_nauczyciela)
            ORDER BY l.data_lekcji;
        RETURN v_cursor;
    END;

    -- =======================================================================
    -- HEURYSTYKA PRZYDZIALU NAUCZYCIELA
    -- Wybiera nauczyciela od danego instrumentu z NAJMNIEJSZYM obciazeniem
    -- w danym terminie (data + godzina). Jesli wielu ma tyle samo - bierze pierwszego.
    -- =======================================================================

    FUNCTION znajdz_nauczyciela_heurystyka(
        p_instrument    VARCHAR2,
        p_data          DATE,
        p_godzina       VARCHAR2,
        p_czas_min      NUMBER
    ) RETURN VARCHAR2 IS
        v_nazwisko VARCHAR2(100);
    BEGIN
        -- Znajdz nauczyciela ktory:
        -- 1) Uczy danego instrumentu (ma go w VARRAY instrumenty)
        -- 2) Jest wolny w danym terminie
        -- 3) Ma NAJMNIEJ lekcji w tym dniu (rownomierne obciazenie)
        SELECT n.nazwisko INTO v_nazwisko
        FROM (
            SELECT n.nazwisko,
                   (SELECT COUNT(*) FROM LEKCJE l 
                    WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = n.id_nauczyciela
                    AND l.data_lekcji = p_data
                    AND l.status != 'odwolana') AS liczba_lekcji_dzis
            FROM NAUCZYCIELE n
            WHERE p_instrument IN (SELECT COLUMN_VALUE FROM TABLE(n.instrumenty))
            -- Sprawdz dostepnosc w konkretnej godzinie
            AND NOT EXISTS (
                SELECT 1 FROM LEKCJE l
                WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = n.id_nauczyciela
                AND l.data_lekcji = p_data
                AND l.status != 'odwolana'
                AND czy_naklada_sie(
                    godzina_na_minuty(l.godzina_start),
                    godzina_na_minuty(l.godzina_start) + l.czas_trwania_min,
                    godzina_na_minuty(p_godzina),
                    godzina_na_minuty(p_godzina) + p_czas_min
                )
            )
            ORDER BY liczba_lekcji_dzis ASC  -- najmniej obciazony na gorze
        ) n
        WHERE ROWNUM = 1;

        RETURN v_nazwisko;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20020, 
                'Brak dostepnego nauczyciela od instrumentu: ' || p_instrument || 
                ' w terminie ' || TO_CHAR(p_data, 'YYYY-MM-DD') || ' ' || p_godzina);
    END;

    -- =======================================================================
    -- AUTOMATYCZNE PRZYDZIELANIE LEKCJI (z heurystyka)
    -- System sam wybiera nauczyciela i sale (najlzej obciazonych)
    -- Czas lekcji pobierany automatycznie z klasy ucznia:
    --   - Klasy I-III: 30 minut (zalozenie 10)
    --   - Klasy IV-VI: 45 minut (zalozenie 10)
    -- =======================================================================

    PROCEDURE przydziel_lekcje_indywidualna(
        p_uczen_nazwisko    VARCHAR2,
        p_uczen_imie        VARCHAR2,
        p_data              DATE,
        p_godzina           VARCHAR2,
        p_czas_min          NUMBER DEFAULT NULL  -- NULL = automatycznie z klasy
    ) IS
        v_instrument VARCHAR2(50);
        v_nauczyciel VARCHAR2(100);
        v_sala       VARCHAR2(10);
        v_klasa      NUMBER;
        v_czas_lekcji NUMBER;
    BEGIN
        -- Pobierz instrument ucznia i jego klase
        SELECT DEREF(u.ref_instrument).nazwa, 
               DEREF(u.ref_grupa).klasa
        INTO v_instrument, v_klasa
        FROM UCZNIOWIE u
        WHERE UPPER(u.nazwisko) = UPPER(p_uczen_nazwisko)
        AND UPPER(u.imie) = UPPER(p_uczen_imie);

        -- Ustal czas lekcji: parametr lub automatycznie z klasy (zalozenie 10)
        IF p_czas_min IS NOT NULL THEN
            v_czas_lekcji := p_czas_min;
        ELSIF v_klasa <= 3 THEN
            v_czas_lekcji := 30;  -- klasy I-III: 30 minut
        ELSE
            v_czas_lekcji := 45;  -- klasy IV-VI: 45 minut
        END IF;

        -- HEURYSTYKA: Znajdz nauczyciela z najmniejszym obciazeniem
        v_nauczyciel := znajdz_nauczyciela_heurystyka(v_instrument, p_data, p_godzina, v_czas_lekcji);

        -- Znajdz wolna sale indywidualna
        BEGIN
            SELECT s.numer INTO v_sala
            FROM (
                SELECT s.numer,
                       (SELECT COUNT(*) FROM LEKCJE l 
                        WHERE DEREF(l.ref_sala).id_sali = s.id_sali
                        AND l.data_lekcji = p_data) AS liczba_lekcji
                FROM SALE s
                WHERE s.typ = 'indywidualna'
                AND NOT EXISTS (
                    SELECT 1 FROM LEKCJE l
                    WHERE DEREF(l.ref_sala).id_sali = s.id_sali
                    AND l.data_lekcji = p_data
                    AND l.status != 'odwolana'
                    AND czy_naklada_sie(
                        godzina_na_minuty(l.godzina_start),
                        godzina_na_minuty(l.godzina_start) + l.czas_trwania_min,
                        godzina_na_minuty(p_godzina),
                        godzina_na_minuty(p_godzina) + v_czas_lekcji
                    )
                )
                ORDER BY liczba_lekcji ASC
            ) s
            WHERE ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20021, 
                    'Brak wolnej sali indywidualnej w terminie ' || 
                    TO_CHAR(p_data, 'YYYY-MM-DD') || ' ' || p_godzina);
        END;

        -- Sprawdz czy uczen jest wolny
        IF NOT czy_uczen_wolny(p_uczen_nazwisko, p_uczen_imie, p_data, p_godzina, v_czas_lekcji) THEN
            RAISE_APPLICATION_ERROR(-20012, 'Uczen zajety w tym terminie');
        END IF;

        -- Dodaj lekcje (wszystkie walidacje przeszly)
        INSERT INTO LEKCJE VALUES (
            T_LEKCJA(
                seq_lekcje.NEXTVAL,
                PKG_SLOWNIKI.get_ref_przedmiot(v_instrument),
                PKG_OSOBY.get_ref_nauczyciel(v_nauczyciel),
                PKG_SLOWNIKI.get_ref_sala(v_sala),
                PKG_OSOBY.get_ref_uczen(p_uczen_nazwisko, p_uczen_imie),
                NULL,  -- ref_grupa
                p_data,
                p_godzina,
                v_czas_lekcji,
                'zwykla',
                'zaplanowana',
                NULL   -- komisja
            )
        );
        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Przydzielono lekcje: ' || p_uczen_nazwisko || ' ' || p_uczen_imie ||
                             ' (klasa ' || v_klasa || ', ' || v_czas_lekcji || ' min) -> ' || 
                             'nauczyciel: ' || v_nauczyciel || ', sala: ' || v_sala);
    END;

    -- =======================================================================
    -- GENEROWANIE PLANU SEMESTRALNEGO - IMPLEMENTACJA
    -- =======================================================================

    PROCEDURE generuj_lekcje_indywidualne_tydzien(
        p_data_poniedzialek DATE
    ) IS
        v_godziny_start CONSTANT VARCHAR2(100) := '14:00,14:30,15:00,15:30,16:00,16:30,17:00,17:30,18:00,18:30,19:00';
        v_slot_idx NUMBER := 0;
        v_dzien1 DATE;
        v_dzien2 DATE;
        v_godzina VARCHAR2(5);
        v_czas NUMBER;
        v_utworzono NUMBER := 0;
        v_bledy NUMBER := 0;

        TYPE t_godziny IS TABLE OF VARCHAR2(5);
        v_godziny t_godziny := t_godziny('14:00','14:30','15:00','15:30','16:00','16:30','17:00','17:30','18:00','18:30','19:00');
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== GENEROWANIE LEKCJI INDYWIDUALNYCH ===');
        DBMS_OUTPUT.PUT_LINE('Tydzien od: ' || TO_CHAR(p_data_poniedzialek, 'YYYY-MM-DD'));

        -- Dla kazdego ucznia
        FOR uczen IN (
            SELECT u.imie, u.nazwisko, 
                   DEREF(u.ref_instrument).nazwa AS instrument,
                   DEREF(u.ref_grupa).klasa AS klasa,
                   DEREF(u.ref_grupa).kod AS grupa
            FROM UCZNIOWIE u
            ORDER BY DEREF(u.ref_grupa).klasa, DEREF(u.ref_grupa).kod, u.nazwisko
        ) LOOP
            -- Przydziel dni: parzyste grupy (A) -> pon+sr, nieparzyste (B) -> wt+czw
            IF SUBSTR(uczen.grupa, -1) = 'A' THEN
                v_dzien1 := p_data_poniedzialek;      -- poniedzialek
                v_dzien2 := p_data_poniedzialek + 2; -- sroda
            ELSE
                v_dzien1 := p_data_poniedzialek + 1; -- wtorek
                v_dzien2 := p_data_poniedzialek + 3; -- czwartek
            END IF;

            -- Czas lekcji z klasy
            IF uczen.klasa <= 3 THEN
                v_czas := 30;
            ELSE
                v_czas := 45;
            END IF;

            -- Wybierz slot godzinowy (rotacja)
            v_slot_idx := MOD(v_slot_idx, v_godziny.COUNT) + 1;
            v_godzina := v_godziny(v_slot_idx);

            -- Lekcja 1
            BEGIN
                przydziel_lekcje_indywidualna(uczen.nazwisko, uczen.imie, v_dzien1, v_godzina, v_czas);
                v_utworzono := v_utworzono + 1;
            EXCEPTION
                WHEN OTHERS THEN
                    v_bledy := v_bledy + 1;
                    DBMS_OUTPUT.PUT_LINE('BLAD lekcja 1: ' || uczen.imie || ' ' || uczen.nazwisko || ' - ' || SQLERRM);
            END;

            -- Lekcja 2 (przesun godzine o 1 slot)
            v_slot_idx := MOD(v_slot_idx, v_godziny.COUNT) + 1;
            v_godzina := v_godziny(v_slot_idx);

            BEGIN
                przydziel_lekcje_indywidualna(uczen.nazwisko, uczen.imie, v_dzien2, v_godzina, v_czas);
                v_utworzono := v_utworzono + 1;
            EXCEPTION
                WHEN OTHERS THEN
                    v_bledy := v_bledy + 1;
                    DBMS_OUTPUT.PUT_LINE('BLAD lekcja 2: ' || uczen.imie || ' ' || uczen.nazwisko || ' - ' || SQLERRM);
            END;
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('Utworzono lekcji indywidualnych: ' || v_utworzono);
        DBMS_OUTPUT.PUT_LINE('Bledy: ' || v_bledy);
    END;

    PROCEDURE generuj_lekcje_grupowe_tydzien(
        p_data_poniedzialek DATE
    ) IS
        v_nauczyciel_grupowy VARCHAR2(100);
        v_utworzono NUMBER := 0;
        v_dzien DATE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== GENEROWANIE LEKCJI GRUPOWYCH ===');

        -- Dla kazdej grupy
        FOR grupa IN (
            SELECT g.kod, g.klasa FROM GRUPY g ORDER BY g.klasa, g.kod
        ) LOOP
            -- Wybierz dzien dla grupy (rozlozenie rownomierne)
            IF SUBSTR(grupa.kod, -1) = 'A' THEN
                v_dzien := p_data_poniedzialek + 4; -- piatek dla grup A
            ELSE
                v_dzien := p_data_poniedzialek + 4; -- piatek dla grup B tez (lub inny dzien)
            END IF;

            -- Ksztalcenie sluchu (wszystkie grupy) - sala 201
            BEGIN
                -- Wybierz nauczyciela grupowego
                SELECT nazwisko INTO v_nauczyciel_grupowy FROM NAUCZYCIELE 
                WHERE instrumenty IS NULL AND ROWNUM = 1;

                dodaj_lekcje_grupowa('Ksztalcenie sluchu', v_nauczyciel_grupowy, '201', 
                                     grupa.kod, v_dzien, '14:00', 45);
                v_utworzono := v_utworzono + 1;
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('BLAD Ksztalcenie sluchu ' || grupa.kod || ': ' || SQLERRM);
            END;

            -- Rytmika (wszystkie grupy) - sala 202
            BEGIN
                SELECT nazwisko INTO v_nauczyciel_grupowy FROM NAUCZYCIELE 
                WHERE instrumenty IS NULL AND ROWNUM = 1;

                dodaj_lekcje_grupowa('Rytmika', v_nauczyciel_grupowy, '202', 
                                     grupa.kod, v_dzien, '15:00', 45);
                v_utworzono := v_utworzono + 1;
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('BLAD Rytmika ' || grupa.kod || ': ' || SQLERRM);
            END;

            -- Audycje muzyczne (wszystkie grupy) - sala 201
            BEGIN
                SELECT nazwisko INTO v_nauczyciel_grupowy FROM NAUCZYCIELE 
                WHERE instrumenty IS NULL AND ROWNUM = 1;

                dodaj_lekcje_grupowa('Audycje muzyczne', v_nauczyciel_grupowy, '201', 
                                     grupa.kod, v_dzien, '16:00', 45);
                v_utworzono := v_utworzono + 1;
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('BLAD Audycje ' || grupa.kod || ': ' || SQLERRM);
            END;

            -- Chor/Orkiestra tylko dla klas IV-VI - sala 202
            IF grupa.klasa >= 4 THEN
                BEGIN
                    SELECT nazwisko INTO v_nauczyciel_grupowy FROM NAUCZYCIELE 
                    WHERE instrumenty IS NULL AND ROWNUM = 1;

                    -- Klasy parzyste -> Chor, nieparzyste -> Orkiestra
                    IF MOD(grupa.klasa, 2) = 0 THEN
                        dodaj_lekcje_grupowa('Chor', v_nauczyciel_grupowy, '202', 
                                             grupa.kod, v_dzien, '17:00', 90);
                    ELSE
                        dodaj_lekcje_grupowa('Orkiestra', v_nauczyciel_grupowy, '202', 
                                             grupa.kod, v_dzien, '17:00', 90);
                    END IF;
                    v_utworzono := v_utworzono + 1;
                EXCEPTION
                    WHEN OTHERS THEN
                        DBMS_OUTPUT.PUT_LINE('BLAD Chor/Orkiestra ' || grupa.kod || ': ' || SQLERRM);
                END;
            END IF;
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('Utworzono lekcji grupowych: ' || v_utworzono);
    END;

    PROCEDURE generuj_plan_tygodnia(
        p_data_poniedzialek DATE
    ) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('========================================');
        DBMS_OUTPUT.PUT_LINE('GENEROWANIE PLANU TYGODNIA');
        DBMS_OUTPUT.PUT_LINE('Poczatek tygodnia: ' || TO_CHAR(p_data_poniedzialek, 'YYYY-MM-DD (DAY)'));
        DBMS_OUTPUT.PUT_LINE('========================================');
        DBMS_OUTPUT.PUT_LINE('');

        -- Najpierw lekcje indywidualne
        generuj_lekcje_indywidualne_tydzien(p_data_poniedzialek);

        DBMS_OUTPUT.PUT_LINE('');

        -- Potem lekcje grupowe
        generuj_lekcje_grupowe_tydzien(p_data_poniedzialek);

        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('========================================');
        DBMS_OUTPUT.PUT_LINE('PLAN TYGODNIA WYGENEROWANY');
        DBMS_OUTPUT.PUT_LINE('========================================');
    END;

END PKG_LEKCJE;
/

-- ============================================================================
-- 5. PAKIET PKG_OCENY - Zarzadzanie ocenami
-- ============================================================================

CREATE OR REPLACE PACKAGE PKG_OCENY AS

    -- Wystawienie oceny biezacej
    PROCEDURE wystaw_ocene(
        p_uczen_nazwisko    VARCHAR2,
        p_uczen_imie        VARCHAR2,
        p_nauczyciel_nazwisko VARCHAR2,
        p_przedmiot         VARCHAR2,
        p_wartosc           NUMBER,
        p_obszar            VARCHAR2 DEFAULT 'ogolna',
        p_komentarz         VARCHAR2 DEFAULT NULL
    );

    -- Wystawienie oceny semestralnej
    PROCEDURE wystaw_ocene_semestralna(
        p_uczen_nazwisko    VARCHAR2,
        p_uczen_imie        VARCHAR2,
        p_nauczyciel_nazwisko VARCHAR2,
        p_przedmiot         VARCHAR2,
        p_wartosc           NUMBER,
        p_komentarz         VARCHAR2 DEFAULT NULL
    );

    -- Srednia ocen ucznia z przedmiotu
    FUNCTION srednia_ucznia(
        p_uczen_nazwisko VARCHAR2,
        p_uczen_imie     VARCHAR2,
        p_przedmiot      VARCHAR2
    ) RETURN NUMBER;

    -- Wszystkie oceny ucznia
    FUNCTION oceny_ucznia(
        p_uczen_nazwisko VARCHAR2,
        p_uczen_imie     VARCHAR2
    ) RETURN SYS_REFCURSOR;

    -- Statystyki ucznia (srednie z wszystkich przedmiotow)
    PROCEDURE statystyki_ucznia(
        p_uczen_nazwisko VARCHAR2,
        p_uczen_imie     VARCHAR2
    );

END PKG_OCENY;
/

CREATE OR REPLACE PACKAGE BODY PKG_OCENY AS

    PROCEDURE wystaw_ocene(
        p_uczen_nazwisko    VARCHAR2,
        p_uczen_imie        VARCHAR2,
        p_nauczyciel_nazwisko VARCHAR2,
        p_przedmiot         VARCHAR2,
        p_wartosc           NUMBER,
        p_obszar            VARCHAR2 DEFAULT 'ogolna',
        p_komentarz         VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        INSERT INTO OCENY VALUES (
            T_OCENA(
                seq_oceny.NEXTVAL,
                PKG_OSOBY.get_ref_uczen(p_uczen_nazwisko, p_uczen_imie),
                PKG_OSOBY.get_ref_nauczyciel(p_nauczyciel_nazwisko),
                PKG_SLOWNIKI.get_ref_przedmiot(p_przedmiot),
                p_wartosc,
                p_obszar,
                SYSDATE,
                p_komentarz,
                'N'  -- nie semestralna
            )
        );
        COMMIT;
    END;

    PROCEDURE wystaw_ocene_semestralna(
        p_uczen_nazwisko    VARCHAR2,
        p_uczen_imie        VARCHAR2,
        p_nauczyciel_nazwisko VARCHAR2,
        p_przedmiot         VARCHAR2,
        p_wartosc           NUMBER,
        p_komentarz         VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        INSERT INTO OCENY VALUES (
            T_OCENA(
                seq_oceny.NEXTVAL,
                PKG_OSOBY.get_ref_uczen(p_uczen_nazwisko, p_uczen_imie),
                PKG_OSOBY.get_ref_nauczyciel(p_nauczyciel_nazwisko),
                PKG_SLOWNIKI.get_ref_przedmiot(p_przedmiot),
                p_wartosc,
                'ogolna',
                SYSDATE,
                p_komentarz,
                'T'  -- semestralna
            )
        );
        COMMIT;
    END;

    FUNCTION srednia_ucznia(
        p_uczen_nazwisko VARCHAR2,
        p_uczen_imie     VARCHAR2,
        p_przedmiot      VARCHAR2
    ) RETURN NUMBER IS
        v_srednia NUMBER;
    BEGIN
        SELECT ROUND(AVG(o.wartosc), 2) INTO v_srednia
        FROM OCENY o
        WHERE DEREF(o.ref_uczen).nazwisko = p_uczen_nazwisko
        AND DEREF(o.ref_uczen).imie = p_uczen_imie
        AND DEREF(o.ref_przedmiot).nazwa = p_przedmiot
        AND o.czy_semestralna = 'N';  -- tylko oceny biezace

        RETURN NVL(v_srednia, 0);
    END;

    FUNCTION oceny_ucznia(
        p_uczen_nazwisko VARCHAR2,
        p_uczen_imie     VARCHAR2
    ) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT DEREF(o.ref_przedmiot).nazwa AS przedmiot,
                   o.wartosc,
                   o.obszar,
                   o.data_wystawienia,
                   DEREF(o.ref_nauczyciel).nazwisko AS nauczyciel,
                   o.czy_semestralna,
                   o.komentarz
            FROM OCENY o
            WHERE DEREF(o.ref_uczen).nazwisko = p_uczen_nazwisko
            AND DEREF(o.ref_uczen).imie = p_uczen_imie
            ORDER BY o.data_wystawienia DESC;

        RETURN v_cursor;
    END;

    PROCEDURE statystyki_ucznia(
        p_uczen_nazwisko VARCHAR2,
        p_uczen_imie     VARCHAR2
    ) IS
        v_grupa VARCHAR2(10);
        v_klasa NUMBER;
        v_instrument VARCHAR2(50);
        v_liczba_ocen NUMBER;
        v_srednia_ogolna NUMBER;
    BEGIN
        -- Pobierz dane ucznia
        SELECT DEREF(u.ref_grupa).kod, DEREF(u.ref_grupa).klasa, DEREF(u.ref_instrument).nazwa
        INTO v_grupa, v_klasa, v_instrument
        FROM UCZNIOWIE u
        WHERE UPPER(u.nazwisko) = UPPER(p_uczen_nazwisko)
        AND UPPER(u.imie) = UPPER(p_uczen_imie);

        -- Ogolne statystyki
        SELECT COUNT(*), ROUND(AVG(o.wartosc), 2)
        INTO v_liczba_ocen, v_srednia_ogolna
        FROM OCENY o
        WHERE UPPER(DEREF(o.ref_uczen).nazwisko) = UPPER(p_uczen_nazwisko)
        AND UPPER(DEREF(o.ref_uczen).imie) = UPPER(p_uczen_imie)
        AND o.czy_semestralna = 'N';

        DBMS_OUTPUT.PUT_LINE('=== STATYSTYKI UCZNIA ===');
        DBMS_OUTPUT.PUT_LINE('Uczen:      ' || p_uczen_imie || ' ' || p_uczen_nazwisko);
        DBMS_OUTPUT.PUT_LINE('Grupa:      ' || v_grupa || ' (klasa ' || v_klasa || ')');
        DBMS_OUTPUT.PUT_LINE('Instrument: ' || v_instrument);
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('Liczba ocen:    ' || v_liczba_ocen);
        DBMS_OUTPUT.PUT_LINE('Srednia ogolna: ' || NVL(TO_CHAR(v_srednia_ogolna), 'brak'));
        DBMS_OUTPUT.PUT_LINE('');

        -- Srednie z poszczegolnych przedmiotow
        DBMS_OUTPUT.PUT_LINE('Srednie z przedmiotow:');
        FOR r IN (
            SELECT DEREF(o.ref_przedmiot).nazwa AS przedmiot,
                   COUNT(*) AS ile_ocen,
                   ROUND(AVG(o.wartosc), 2) AS srednia
            FROM OCENY o
            WHERE UPPER(DEREF(o.ref_uczen).nazwisko) = UPPER(p_uczen_nazwisko)
            AND UPPER(DEREF(o.ref_uczen).imie) = UPPER(p_uczen_imie)
            AND o.czy_semestralna = 'N'
            GROUP BY DEREF(o.ref_przedmiot).nazwa
            ORDER BY DEREF(o.ref_przedmiot).nazwa
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('  ' || RPAD(r.przedmiot, 20) || ' ocen: ' || r.ile_ocen || ', srednia: ' || r.srednia);
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Uczen nie znaleziony: ' || p_uczen_imie || ' ' || p_uczen_nazwisko);
    END;

END PKG_OCENY;
/

-- ============================================================================
-- 6. PAKIET PKG_RAPORTY - Raporty i statystyki
-- ============================================================================

CREATE OR REPLACE PACKAGE PKG_RAPORTY AS

    -- Liczba uczniow w kazdej grupie
    PROCEDURE raport_grup;

    -- Obciazenie sal w danym dniu
    PROCEDURE raport_obciazenia_sal(p_data DATE);

    -- Statystyki nauczycieli
    PROCEDURE raport_nauczycieli;

    -- Rozklad instrumentow
    PROCEDURE raport_instrumentow;

    -- Statystyki ocen z przedmiotu
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
            FROM GRUPY g
            LEFT JOIN UCZNIOWIE u ON DEREF(u.ref_grupa).id_grupy = g.id_grupy
            GROUP BY g.kod, g.klasa
            ORDER BY g.klasa, g.kod
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
            FROM SALE s
            LEFT JOIN LEKCJE l ON DEREF(l.ref_sala).id_sali = s.id_sali 
                              AND l.data_lekcji = p_data
                              AND l.status != 'odwolana'
            GROUP BY s.numer, s.typ
            ORDER BY s.numer
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(RPAD(r.numer, 8) || RPAD(r.typ, 15) || r.liczba);
        END LOOP;
    END;

    PROCEDURE raport_nauczycieli IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== RAPORT NAUCZYCIELI ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('Nazwisko', 15) || RPAD('Instrumenty', 30) || 'Uczniow');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 55, '-'));

        FOR r IN (
            SELECT n.nazwisko,
                   (SELECT LISTAGG(COLUMN_VALUE, ', ') WITHIN GROUP (ORDER BY COLUMN_VALUE)
                    FROM TABLE(n.instrumenty)) AS instr_lista
            FROM NAUCZYCIELE n
            WHERE n.instrumenty IS NOT NULL
            ORDER BY n.nazwisko
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(RPAD(r.nazwisko, 15) || RPAD(NVL(r.instr_lista, '-'), 30));
        END LOOP;
    END;

    PROCEDURE raport_instrumentow IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== ROZKLAD INSTRUMENTOW ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('Instrument', 15) || RPAD('Uczniow', 10) || 'Procent');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 35, '-'));

        FOR r IN (
            SELECT i.nazwa, 
                   COUNT(u.id_ucznia) AS liczba,
                   ROUND(COUNT(u.id_ucznia) * 100.0 / NULLIF((SELECT COUNT(*) FROM UCZNIOWIE), 0), 1) AS procent
            FROM INSTRUMENTY i
            LEFT JOIN UCZNIOWIE u ON DEREF(u.ref_instrument).id_instrumentu = i.id_instrumentu
            GROUP BY i.nazwa
            ORDER BY liczba DESC
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
        FROM OCENY o
        WHERE UPPER(DEREF(o.ref_przedmiot).nazwa) = UPPER(p_przedmiot)
        AND o.czy_semestralna = 'N';

        DBMS_OUTPUT.PUT_LINE('=== STATYSTYKI OCEN: ' || p_przedmiot || ' ===');
        DBMS_OUTPUT.PUT_LINE('Liczba ocen:  ' || v_count);
        DBMS_OUTPUT.PUT_LINE('Srednia:      ' || NVL(TO_CHAR(v_srednia), 'brak'));
        DBMS_OUTPUT.PUT_LINE('Min:          ' || NVL(TO_CHAR(v_min), 'brak'));
        DBMS_OUTPUT.PUT_LINE('Max:          ' || NVL(TO_CHAR(v_max), 'brak'));
        DBMS_OUTPUT.PUT_LINE('');

        -- Rozklad ocen
        DBMS_OUTPUT.PUT_LINE('Rozklad:');
        FOR r IN (
            SELECT o.wartosc, COUNT(*) AS ile
            FROM OCENY o
            WHERE UPPER(DEREF(o.ref_przedmiot).nazwa) = UPPER(p_przedmiot)
            AND o.czy_semestralna = 'N'
            GROUP BY o.wartosc
            ORDER BY o.wartosc
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('  Ocena ' || r.wartosc || ': ' || r.ile || ' szt.');
        END LOOP;
    END;

END PKG_RAPORTY;
/

-- ============================================================================
-- 7. POTWIERDZENIE
-- ============================================================================

SELECT 'Pakiety utworzone pomyslnie!' AS status FROM DUAL;

-- Lista pakietow
SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('PACKAGE', 'PACKAGE BODY')
ORDER BY object_name, object_type;
