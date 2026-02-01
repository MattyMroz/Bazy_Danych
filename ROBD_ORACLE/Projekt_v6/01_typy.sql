-- ============================================================================
-- Projekt: Szkola Muzyczna - Obiektowa Baza Danych
-- Plik: 01_typy.sql
-- Opis: Definicje typow obiektowych i kolekcji
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- ============================================================================
-- 1. USUNIECIE ISTNIEJACYCH TYPOW (w odwrotnej kolejnosci zaleznosci)
-- ============================================================================

BEGIN EXECUTE IMMEDIATE 'DROP TYPE T_OCENA FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE T_LEKCJA FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE T_UCZEN FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE T_GRUPA FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE T_SALA FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE T_NAUCZYCIEL FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE T_PRZEDMIOT FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE T_INSTRUMENT FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE T_WYPOSAZENIE FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE T_INSTRUMENTY_TAB FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ============================================================================
-- 2. KOLEKCJE VARRAY
-- ============================================================================

-- Lista instrumentow nauczyciela (max 5 - zgodnie z zalozeniem 19)
CREATE OR REPLACE TYPE T_INSTRUMENTY_TAB AS VARRAY(5) OF VARCHAR2(50);
/

-- Wyposazenie sali (max 10 elementow)
CREATE OR REPLACE TYPE T_WYPOSAZENIE AS VARRAY(10) OF VARCHAR2(50);
/

-- ============================================================================
-- 3. TYP INSTRUMENT (slownik)
-- ============================================================================

CREATE OR REPLACE TYPE T_INSTRUMENT AS OBJECT (
    id_instrumentu      NUMBER,
    nazwa               VARCHAR2(50),         -- fortepian, skrzypce, gitara, flet, perkusja
    czy_orkiestra       CHAR(1),              -- T = orkiestra, N = chor (dla klas IV-VI)

    -- Metoda sprawdzajaca czy instrument nalezy do orkiestry
    MEMBER FUNCTION jest_orkiestrowy RETURN BOOLEAN
);
/

CREATE OR REPLACE TYPE BODY T_INSTRUMENT AS
    MEMBER FUNCTION jest_orkiestrowy RETURN BOOLEAN IS
    BEGIN
        RETURN czy_orkiestra = 'T';
    END;
END;
/

-- ============================================================================
-- 4. TYP PRZEDMIOT (slownik zajec)
-- ============================================================================

CREATE OR REPLACE TYPE T_PRZEDMIOT AS OBJECT (
    id_przedmiotu       NUMBER,
    nazwa               VARCHAR2(100),        -- np. 'Fortepian', 'Ksztalcenie sluchu'
    typ_zajec           VARCHAR2(20),         -- 'indywidualny' lub 'grupowy'
    domyslny_czas_min   NUMBER,               -- 30, 45, 60 lub 90 minut
    wymagane_wyposazenie T_WYPOSAZENIE,       -- np. ['fortepian'] lub ['tablica', 'pianino']

    -- Metoda sprawdzajaca czy zajecia sa grupowe
    MEMBER FUNCTION czy_grupowy RETURN BOOLEAN
);
/

CREATE OR REPLACE TYPE BODY T_PRZEDMIOT AS
    MEMBER FUNCTION czy_grupowy RETURN BOOLEAN IS
    BEGIN
        RETURN typ_zajec = 'grupowy';
    END;
END;
/

-- ============================================================================
-- 5. TYP NAUCZYCIEL
-- ============================================================================

CREATE OR REPLACE TYPE T_NAUCZYCIEL AS OBJECT (
    id_nauczyciela      NUMBER,
    imie                VARCHAR2(50),
    nazwisko            VARCHAR2(100),
    instrumenty         T_INSTRUMENTY_TAB,    -- VARRAY instrumentow (max 5)
    email               VARCHAR2(100),
    telefon             VARCHAR2(20),
    max_godzin_dziennie NUMBER,               -- zgodnie z zalozeniem 21 (domyslnie 6)
    max_godzin_tydzien  NUMBER,               -- zgodnie z zalozeniem 22 (domyslnie 30)

    -- Pelne imie i nazwisko
    MEMBER FUNCTION pelne_nazwisko RETURN VARCHAR2,

    -- Sprawdza czy nauczyciel uczy danego instrumentu
    MEMBER FUNCTION uczy_instrumentu(p_instrument VARCHAR2) RETURN BOOLEAN
);
/

CREATE OR REPLACE TYPE BODY T_NAUCZYCIEL AS
    MEMBER FUNCTION pelne_nazwisko RETURN VARCHAR2 IS
    BEGIN
        RETURN imie || ' ' || nazwisko;
    END;

    MEMBER FUNCTION uczy_instrumentu(p_instrument VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        IF instrumenty IS NOT NULL THEN
            FOR i IN 1..instrumenty.COUNT LOOP
                IF UPPER(instrumenty(i)) = UPPER(p_instrument) THEN
                    RETURN TRUE;
                END IF;
            END LOOP;
        END IF;
        RETURN FALSE;
    END;
END;
/

-- ============================================================================
-- 6. TYP GRUPA (klasa)
-- ============================================================================

CREATE OR REPLACE TYPE T_GRUPA AS OBJECT (
    id_grupy            NUMBER,
    kod                 VARCHAR2(10),         -- np. '1A', '2B', '3A'
    klasa               NUMBER(1),            -- 1-6 (numer klasy)
    rok_szkolny         VARCHAR2(9),          -- np. '2025/2026'

    -- Sprawdza czy to klasy mlodsze (I-III) czy starsze (IV-VI)
    MEMBER FUNCTION czy_klasy_mlodsze RETURN BOOLEAN,

    -- Zwraca czas lekcji instrumentu dla tej klasy (30 lub 45 min)
    MEMBER FUNCTION czas_lekcji_instrumentu RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY T_GRUPA AS
    MEMBER FUNCTION czy_klasy_mlodsze RETURN BOOLEAN IS
    BEGIN
        RETURN klasa <= 3;  -- klasy I-III
    END;

    MEMBER FUNCTION czas_lekcji_instrumentu RETURN NUMBER IS
    BEGIN
        IF klasa <= 3 THEN
            RETURN 30;  -- klasy I-III: 30 min
        ELSE
            RETURN 45;  -- klasy IV-VI: 45 min
        END IF;
    END;
END;
/

-- ============================================================================
-- 7. TYP SALA
-- ============================================================================

CREATE OR REPLACE TYPE T_SALA AS OBJECT (
    id_sali             NUMBER,
    numer               VARCHAR2(10),         -- np. '101', '202'
    typ                 VARCHAR2(20),         -- 'indywidualna' lub 'grupowa'
    pojemnosc           NUMBER,               -- max liczba osob
    wyposazenie         T_WYPOSAZENIE,        -- VARRAY wyposazenia

    -- Sprawdza czy sala ma wymagane wyposazenie
    MEMBER FUNCTION ma_wyposazenie(p_wymagane T_WYPOSAZENIE) RETURN BOOLEAN,

    -- Sprawdza czy sala jest grupowa
    MEMBER FUNCTION czy_grupowa RETURN BOOLEAN
);
/

CREATE OR REPLACE TYPE BODY T_SALA AS
    MEMBER FUNCTION ma_wyposazenie(p_wymagane T_WYPOSAZENIE) RETURN BOOLEAN IS
        v_znaleziono BOOLEAN;
    BEGIN
        IF p_wymagane IS NULL OR p_wymagane.COUNT = 0 THEN
            RETURN TRUE;  -- brak wymagan = kazda sala pasuje
        END IF;

        IF wyposazenie IS NULL THEN
            RETURN FALSE;
        END IF;

        -- Kazdy wymagany element musi byc w wyposazeniu sali
        FOR i IN 1..p_wymagane.COUNT LOOP
            v_znaleziono := FALSE;
            FOR j IN 1..wyposazenie.COUNT LOOP
                IF UPPER(wyposazenie(j)) = UPPER(p_wymagane(i)) THEN
                    v_znaleziono := TRUE;
                    EXIT;
                END IF;
            END LOOP;
            IF NOT v_znaleziono THEN
                RETURN FALSE;
            END IF;
        END LOOP;

        RETURN TRUE;
    END;

    MEMBER FUNCTION czy_grupowa RETURN BOOLEAN IS
    BEGIN
        RETURN typ = 'grupowa';
    END;
END;
/

-- ============================================================================
-- 8. TYP UCZEN
-- ============================================================================

CREATE OR REPLACE TYPE T_UCZEN AS OBJECT (
    id_ucznia           NUMBER,
    imie                VARCHAR2(50),
    nazwisko            VARCHAR2(100),
    data_urodzenia      DATE,
    ref_grupa           REF T_GRUPA,          -- REF do grupy ucznia
    ref_instrument      REF T_INSTRUMENT,     -- REF do instrumentu glownego
    email_rodzica       VARCHAR2(100),
    telefon_rodzica     VARCHAR2(20),
    data_zapisu         DATE,

    -- Pelne imie i nazwisko
    MEMBER FUNCTION pelne_nazwisko RETURN VARCHAR2,

    -- Oblicza wiek ucznia
    MEMBER FUNCTION wiek RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY T_UCZEN AS
    MEMBER FUNCTION pelne_nazwisko RETURN VARCHAR2 IS
    BEGIN
        RETURN imie || ' ' || nazwisko;
    END;

    MEMBER FUNCTION wiek RETURN NUMBER IS
    BEGIN
        RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, data_urodzenia) / 12);
    END;
END;
/

-- ============================================================================
-- 9. TYP LEKCJA
-- ============================================================================

CREATE OR REPLACE TYPE T_LEKCJA AS OBJECT (
    id_lekcji           NUMBER,
    ref_przedmiot       REF T_PRZEDMIOT,      -- REF do przedmiotu
    ref_nauczyciel      REF T_NAUCZYCIEL,     -- REF do prowadzacego
    ref_sala            REF T_SALA,           -- REF do sali
    ref_uczen           REF T_UCZEN,          -- REF do ucznia (dla indywidualnych)
    ref_grupa           REF T_GRUPA,          -- REF do grupy (dla grupowych)
    data_lekcji         DATE,
    godzina_start       VARCHAR2(5),          -- format 'HH24:MI', np. '14:00'
    czas_trwania_min    NUMBER,               -- 30, 45, 60 lub 90

    -- Oblicza godzine zakonczenia
    MEMBER FUNCTION godzina_koniec RETURN VARCHAR2,

    -- Sprawdza czy lekcja jest indywidualna
    MEMBER FUNCTION czy_indywidualna RETURN BOOLEAN
);
/

CREATE OR REPLACE TYPE BODY T_LEKCJA AS
    MEMBER FUNCTION godzina_koniec RETURN VARCHAR2 IS
        v_start_min NUMBER;
        v_koniec_min NUMBER;
        v_godzina NUMBER;
        v_minuta NUMBER;
    BEGIN
        -- Parsowanie godziny startu
        v_godzina := TO_NUMBER(SUBSTR(godzina_start, 1, 2));
        v_minuta := TO_NUMBER(SUBSTR(godzina_start, 4, 2));
        v_start_min := v_godzina * 60 + v_minuta;

        -- Dodanie czasu trwania
        v_koniec_min := v_start_min + czas_trwania_min;

        -- Konwersja z powrotem na format HH24:MI
        v_godzina := TRUNC(v_koniec_min / 60);
        v_minuta := MOD(v_koniec_min, 60);

        RETURN LPAD(v_godzina, 2, '0') || ':' || LPAD(v_minuta, 2, '0');
    END;

    MEMBER FUNCTION czy_indywidualna RETURN BOOLEAN IS
    BEGIN
        RETURN ref_uczen IS NOT NULL AND ref_grupa IS NULL;
    END;
END;
/

-- ============================================================================
-- 10. TYP OCENA
-- ============================================================================

CREATE OR REPLACE TYPE T_OCENA AS OBJECT (
    id_oceny            NUMBER,
    ref_uczen           REF T_UCZEN,          -- REF do ucznia
    ref_nauczyciel      REF T_NAUCZYCIEL,     -- REF do nauczyciela wystawiajacego
    ref_przedmiot       REF T_PRZEDMIOT,      -- REF do przedmiotu
    wartosc             NUMBER(1),            -- 1-6 (skala polska)
    obszar              VARCHAR2(50),         -- technika, interpretacja, postepy, teoria, sluch
    data_wystawienia    DATE,
    komentarz           VARCHAR2(500),
    czy_semestralna     CHAR(1),              -- T = semestralna, N = biezaca

    -- Walidacja oceny (1-6)
    MEMBER FUNCTION czy_poprawna RETURN BOOLEAN,

    -- Opis slowny oceny
    MEMBER FUNCTION opis_oceny RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY T_OCENA AS
    MEMBER FUNCTION czy_poprawna RETURN BOOLEAN IS
    BEGIN
        RETURN wartosc BETWEEN 1 AND 6;
    END;

    MEMBER FUNCTION opis_oceny RETURN VARCHAR2 IS
    BEGIN
        CASE wartosc
            WHEN 1 THEN RETURN 'niedostateczny';
            WHEN 2 THEN RETURN 'dopuszczajacy';
            WHEN 3 THEN RETURN 'dostateczny';
            WHEN 4 THEN RETURN 'dobry';
            WHEN 5 THEN RETURN 'bardzo dobry';
            WHEN 6 THEN RETURN 'celujacy';
            ELSE RETURN 'nieznana';
        END CASE;
    END;
END;
/

-- ============================================================================
-- 11. POTWIERDZENIE
-- ============================================================================

SELECT 'Typy obiektowe utworzone pomyslnie!' AS status FROM DUAL;
