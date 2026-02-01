-- ============================================================================
-- Projekt: Szkola Muzyczna - Obiektowa Baza Danych (UPROSZCZONA)
-- Plik: 01_typy.sql
-- Opis: Definicje typow obiektowych i kolekcji
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- Wersja: 7.0
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
BEGIN EXECUTE IMMEDIATE 'DROP TYPE T_SALA FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE T_GRUPA FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE T_NAUCZYCIEL FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE T_PRZEDMIOT FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE T_WYPOSAZENIE FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ============================================================================
-- 2. VARRAY - WYPOSAZENIE SALI (wymagane w projekcie)
-- ============================================================================

CREATE OR REPLACE TYPE T_WYPOSAZENIE AS VARRAY(10) OF VARCHAR2(50);
/

-- ============================================================================
-- 3. TYP PRZEDMIOT (slownik zajec)
-- ============================================================================

CREATE OR REPLACE TYPE T_PRZEDMIOT AS OBJECT (
    id_przedmiotu       NUMBER,
    nazwa               VARCHAR2(100),        -- np. 'Fortepian', 'Ksztalcenie sluchu'
    typ_zajec           VARCHAR2(20),         -- 'indywidualny' lub 'grupowy'
    czas_trwania_min    NUMBER,               -- 45 min (uproszczone - staly czas)

    -- Metoda sprawdzajaca czy zajecia sa grupowe
    MEMBER FUNCTION czy_grupowy RETURN CHAR
);
/

CREATE OR REPLACE TYPE BODY T_PRZEDMIOT AS
    MEMBER FUNCTION czy_grupowy RETURN CHAR IS
    BEGIN
        IF typ_zajec = 'grupowy' THEN
            RETURN 'T';
        ELSE
            RETURN 'N';
        END IF;
    END;
END;
/

-- ============================================================================
-- 4. TYP NAUCZYCIEL
-- ============================================================================

CREATE OR REPLACE TYPE T_NAUCZYCIEL AS OBJECT (
    id_nauczyciela      NUMBER,
    imie                VARCHAR2(50),
    nazwisko            VARCHAR2(100),
    instrument          VARCHAR2(50),         -- instrument ktorego uczy (NULL = grupowe)
    email               VARCHAR2(100),

    -- Pelne imie i nazwisko
    MEMBER FUNCTION pelne_nazwisko RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY T_NAUCZYCIEL AS
    MEMBER FUNCTION pelne_nazwisko RETURN VARCHAR2 IS
    BEGIN
        RETURN imie || ' ' || nazwisko;
    END;
END;
/

-- ============================================================================
-- 5. TYP GRUPA (klasa)
-- ============================================================================

CREATE OR REPLACE TYPE T_GRUPA AS OBJECT (
    id_grupy            NUMBER,
    kod                 VARCHAR2(10),         -- np. '1A', '2A', '3A'
    klasa               NUMBER(1),            -- 1-6 (numer klasy)
    rok_szkolny         VARCHAR2(9)           -- np. '2025/2026'
);
/

-- ============================================================================
-- 6. TYP SALA (z VARRAY wyposazenia - wymagane w projekcie)
-- ============================================================================

CREATE OR REPLACE TYPE T_SALA AS OBJECT (
    id_sali             NUMBER,
    numer               VARCHAR2(10),         -- np. '101', '201'
    typ                 VARCHAR2(20),         -- 'indywidualna' lub 'grupowa'
    pojemnosc           NUMBER,               -- max liczba osob
    wyposazenie         T_WYPOSAZENIE,        -- VARRAY wyposazenia

    -- Sprawdza czy sala jest grupowa
    MEMBER FUNCTION czy_grupowa RETURN CHAR
);
/

CREATE OR REPLACE TYPE BODY T_SALA AS
    MEMBER FUNCTION czy_grupowa RETURN CHAR IS
    BEGIN
        IF typ = 'grupowa' THEN
            RETURN 'T';
        ELSE
            RETURN 'N';
        END IF;
    END;
END;
/

-- ============================================================================
-- 7. TYP UCZEN
-- ============================================================================

CREATE OR REPLACE TYPE T_UCZEN AS OBJECT (
    id_ucznia           NUMBER,
    imie                VARCHAR2(50),
    nazwisko            VARCHAR2(100),
    data_urodzenia      DATE,
    instrument          VARCHAR2(50),         -- instrument glowny ucznia
    ref_grupa           REF T_GRUPA,          -- REF do grupy ucznia
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
-- 8. TYP LEKCJA
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
    czas_trwania_min    NUMBER,               -- 45 (uproszczone)

    -- Oblicza godzine zakonczenia
    MEMBER FUNCTION godzina_koniec RETURN VARCHAR2,

    -- Sprawdza czy lekcja jest indywidualna
    MEMBER FUNCTION czy_indywidualna RETURN CHAR
);
/

CREATE OR REPLACE TYPE BODY T_LEKCJA AS
    MEMBER FUNCTION godzina_koniec RETURN VARCHAR2 IS
        v_godzina NUMBER;
        v_minuta NUMBER;
        v_koniec_min NUMBER;
    BEGIN
        v_godzina := TO_NUMBER(SUBSTR(godzina_start, 1, 2));
        v_minuta := TO_NUMBER(SUBSTR(godzina_start, 4, 2));
        v_koniec_min := v_godzina * 60 + v_minuta + czas_trwania_min;

        RETURN LPAD(TRUNC(v_koniec_min / 60), 2, '0') || ':' || LPAD(MOD(v_koniec_min, 60), 2, '0');
    END;

    MEMBER FUNCTION czy_indywidualna RETURN CHAR IS
    BEGIN
        IF ref_uczen IS NOT NULL THEN
            RETURN 'T';
        ELSE
            RETURN 'N';
        END IF;
    END;
END;
/

-- ============================================================================
-- 9. TYP OCENA
-- ============================================================================

CREATE OR REPLACE TYPE T_OCENA AS OBJECT (
    id_oceny            NUMBER,
    ref_uczen           REF T_UCZEN,          -- REF do ucznia
    ref_nauczyciel      REF T_NAUCZYCIEL,     -- REF do nauczyciela
    ref_przedmiot       REF T_PRZEDMIOT,      -- REF do przedmiotu
    wartosc             NUMBER(1),            -- 1-6 (skala polska)
    data_wystawienia    DATE,
    czy_semestralna     CHAR(1),              -- T = semestralna, N = biezaca

    -- Opis slowny oceny
    MEMBER FUNCTION opis_oceny RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY T_OCENA AS
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
-- 10. POTWIERDZENIE
-- ============================================================================

SELECT object_name, object_type, status 
FROM user_objects 
WHERE object_type IN ('TYPE', 'TYPE BODY')
ORDER BY object_name;
