-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 01_typy.sql
-- Opis: Definicje typow obiektowych i kolekcji
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- ============================================================================
-- CZYSZCZENIE - usuwanie istniejacych obiektow
-- ============================================================================
BEGIN EXECUTE IMMEDIATE 'DROP TABLE t_ocena CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE t_lekcja CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE t_kurs CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE t_uczen CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE t_nauczyciel CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE t_instrument CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE t_sala CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_ocena_obj FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_lekcja_obj FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_kurs_obj FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_uczen_obj FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_nauczyciel_obj FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_lista_instrumentow FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_instrument_obj FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_sala_obj FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ============================================================================
-- 1. TYP: T_INSTRUMENT_OBJ
-- Reprezentuje instrument muzyczny w slowniku
-- ============================================================================
CREATE OR REPLACE TYPE t_instrument_obj AS OBJECT (
    id_instrumentu  NUMBER,
    nazwa           VARCHAR2(100),
    kategoria       VARCHAR2(50),     -- dete, strunowe, perkusyjne, klawiszowe

    -- Metoda zwracajaca opis instrumentu
    MEMBER FUNCTION opis RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_instrument_obj AS
    MEMBER FUNCTION opis RETURN VARCHAR2 IS
    BEGIN
        RETURN nazwa || ' (' || kategoria || ')';
    END opis;
END;
/

-- ============================================================================
-- 2. TYP: T_LISTA_INSTRUMENTOW (VARRAY)
-- Kolekcja nazw instrumentow - nauczyciel moze uczyc max 5 instrumentow
-- Demonstracja VARRAY do modelowania relacji 1:N
-- ============================================================================
CREATE OR REPLACE TYPE t_lista_instrumentow AS VARRAY(5) OF VARCHAR2(100);
/

-- ============================================================================
-- 3. TYP: T_SALA_OBJ
-- Reprezentuje sale lekcyjna z wyposazeniem
-- ============================================================================
CREATE OR REPLACE TYPE t_sala_obj AS OBJECT (
    id_sali         NUMBER,
    nazwa           VARCHAR2(50),
    pojemnosc       NUMBER,           -- liczba miejsc
    ma_fortepian    CHAR(1),          -- T/N
    ma_perkusje     CHAR(1),          -- T/N

    -- Metoda zwracajaca pelny opis sali z wyposazeniem
    MEMBER FUNCTION opis_pelny RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_sala_obj AS
    MEMBER FUNCTION opis_pelny RETURN VARCHAR2 IS
        v_wyp VARCHAR2(50) := '';
    BEGIN
        IF ma_fortepian = 'T' THEN v_wyp := v_wyp || 'fortepian '; END IF;
        IF ma_perkusje = 'T' THEN v_wyp := v_wyp || 'perkusja '; END IF;
        IF v_wyp IS NULL THEN v_wyp := 'brak'; END IF;
        RETURN nazwa || ' (poj: ' || pojemnosc || ', wyp: ' || TRIM(v_wyp) || ')';
    END opis_pelny;
END;
/

-- ============================================================================
-- 4. TYP: T_NAUCZYCIEL_OBJ
-- Reprezentuje nauczyciela szkoly muzycznej
-- Zawiera VARRAY instrumentow ktore nauczyciel moze prowadzic
-- ============================================================================
CREATE OR REPLACE TYPE t_nauczyciel_obj AS OBJECT (
    id_nauczyciela      NUMBER,
    imie                VARCHAR2(50),
    nazwisko            VARCHAR2(50),
    email               VARCHAR2(100),
    telefon             VARCHAR2(20),
    data_zatrudnienia   DATE,
    instrumenty         t_lista_instrumentow,  -- VARRAY instrumentow

    -- Metoda zwracajaca pelne dane nauczyciela
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2,
    -- Metoda liczaca lata stazu
    MEMBER FUNCTION lata_stazu RETURN NUMBER,
    -- Metoda zwracajaca liczbe instrumentow
    MEMBER FUNCTION liczba_instrumentow RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY t_nauczyciel_obj AS
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2 IS
    BEGIN
        RETURN imie || ' ' || nazwisko;
    END pelne_dane;

    MEMBER FUNCTION lata_stazu RETURN NUMBER IS
    BEGIN
        RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, data_zatrudnienia) / 12);
    END lata_stazu;

    MEMBER FUNCTION liczba_instrumentow RETURN NUMBER IS
    BEGIN
        IF instrumenty IS NULL THEN RETURN 0; END IF;
        RETURN instrumenty.COUNT;
    END liczba_instrumentow;
END;
/

-- ============================================================================
-- 5. TYP: T_UCZEN_OBJ
-- Reprezentuje ucznia szkoly muzycznej
-- Reguly biznesowe:
--   - Minimalny wiek: 5 lat
--   - Dzieci (<15 lat) moga miec lekcje tylko 14:00-19:00
-- ============================================================================
CREATE OR REPLACE TYPE t_uczen_obj AS OBJECT (
    id_ucznia       NUMBER,
    imie            VARCHAR2(50),
    nazwisko        VARCHAR2(50),
    data_urodzenia  DATE,
    email           VARCHAR2(100),
    data_zapisu     DATE,

    -- Metoda obliczajaca wiek ucznia
    MEMBER FUNCTION wiek RETURN NUMBER,
    -- Metoda zwracajaca pelne dane
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2,
    -- Metoda sprawdzajaca pelnoletnosc
    MEMBER FUNCTION czy_pelnoletni RETURN VARCHAR2,
    -- Metoda sprawdzajaca czy uczen jest dzieckiem (<15 lat)
    MEMBER FUNCTION czy_dziecko RETURN CHAR
);
/

CREATE OR REPLACE TYPE BODY t_uczen_obj AS
    MEMBER FUNCTION wiek RETURN NUMBER IS
    BEGIN
        RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, data_urodzenia) / 12);
    END wiek;

    MEMBER FUNCTION pelne_dane RETURN VARCHAR2 IS
    BEGIN
        RETURN imie || ' ' || nazwisko || ' (wiek: ' || SELF.wiek() || ')';
    END pelne_dane;

    MEMBER FUNCTION czy_pelnoletni RETURN VARCHAR2 IS
    BEGIN
        IF SELF.wiek() >= 18 THEN RETURN 'TAK'; ELSE RETURN 'NIE'; END IF;
    END czy_pelnoletni;

    MEMBER FUNCTION czy_dziecko RETURN CHAR IS
    BEGIN
        IF SELF.wiek() < 15 THEN RETURN 'T'; ELSE RETURN 'N'; END IF;
    END czy_dziecko;
END;
/

-- ============================================================================
-- 6. TYP: T_KURS_OBJ
-- Reprezentuje kurs nauki gry na instrumencie
-- Zawiera REF do instrumentu (demonstracja referencji)
-- ============================================================================
CREATE OR REPLACE TYPE t_kurs_obj AS OBJECT (
    id_kursu        NUMBER,
    nazwa           VARCHAR2(100),
    poziom          VARCHAR2(20),     -- poczatkujacy, sredni, zaawansowany
    cena_za_lekcje  NUMBER(10,2),
    ref_instrument  REF t_instrument_obj,  -- REF do instrumentu

    -- Metoda zwracajaca informacje o kursie
    MEMBER FUNCTION info RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_kurs_obj AS
    MEMBER FUNCTION info RETURN VARCHAR2 IS
    BEGIN
        RETURN nazwa || ' [' || poziom || '] - ' || cena_za_lekcje || ' PLN';
    END info;
END;
/

-- ============================================================================
-- 7. TYP: T_LEKCJA_OBJ
-- Reprezentuje pojedyncza lekcje muzyki
-- Zawiera 4 referencje REF demonstrujace relacje obiektowe
-- ============================================================================
CREATE OR REPLACE TYPE t_lekcja_obj AS OBJECT (
    id_lekcji       NUMBER,
    data_lekcji     DATE,
    godzina_start   VARCHAR2(5),      -- format HH:MM
    czas_trwania    NUMBER,           -- 30, 45, 60 lub 90 minut
    status          VARCHAR2(20),     -- zaplanowana, odbyta, odwolana
    ref_uczen       REF t_uczen_obj,
    ref_nauczyciel  REF t_nauczyciel_obj,
    ref_kurs        REF t_kurs_obj,
    ref_sala        REF t_sala_obj,

    -- Metoda zwracajaca czas trwania jako tekst
    MEMBER FUNCTION czas_txt RETURN VARCHAR2,
    -- Metoda sprawdzajaca czy lekcja odbyta
    MEMBER FUNCTION czy_odbyta RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_lekcja_obj AS
    MEMBER FUNCTION czas_txt RETURN VARCHAR2 IS
    BEGIN
        RETURN czas_trwania || ' min';
    END czas_txt;

    MEMBER FUNCTION czy_odbyta RETURN VARCHAR2 IS
    BEGIN
        IF status = 'odbyta' THEN RETURN 'TAK'; ELSE RETURN 'NIE'; END IF;
    END czy_odbyta;
END;
/

-- ============================================================================
-- 8. TYP: T_OCENA_OBJ
-- Reprezentuje ocene postepu ucznia
-- Zawiera 2 referencje REF (uczen, nauczyciel)
-- ============================================================================
CREATE OR REPLACE TYPE t_ocena_obj AS OBJECT (
    id_oceny        NUMBER,
    data_oceny      DATE,
    ocena           NUMBER(1),        -- 1-6
    obszar          VARCHAR2(50),     -- technika, teoria, sluch, rytm, interpretacja, ogolna
    komentarz       VARCHAR2(500),
    ref_uczen       REF t_uczen_obj,
    ref_nauczyciel  REF t_nauczyciel_obj,

    -- Metoda zwracajaca ocene slownie
    MEMBER FUNCTION ocena_slownie RETURN VARCHAR2,
    -- Metoda sprawdzajaca czy ocena pozytywna
    MEMBER FUNCTION czy_pozytywna RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_ocena_obj AS
    MEMBER FUNCTION ocena_slownie RETURN VARCHAR2 IS
    BEGIN
        CASE ocena
            WHEN 6 THEN RETURN 'celujacy';
            WHEN 5 THEN RETURN 'bardzo dobry';
            WHEN 4 THEN RETURN 'dobry';
            WHEN 3 THEN RETURN 'dostateczny';
            WHEN 2 THEN RETURN 'dopuszczajacy';
            WHEN 1 THEN RETURN 'niedostateczny';
            ELSE RETURN 'nieznana';
        END CASE;
    END ocena_slownie;

    MEMBER FUNCTION czy_pozytywna RETURN VARCHAR2 IS
    BEGIN
        IF ocena >= 2 THEN RETURN 'TAK'; ELSE RETURN 'NIE'; END IF;
    END czy_pozytywna;
END;
/

-- ============================================================================
-- PODSUMOWANIE TYPOW
-- ============================================================================
-- Utworzono 8 typow obiektowych:
-- 1. t_instrument_obj     - instrument (1 metoda)
-- 2. t_lista_instrumentow - VARRAY(5) nazw instrumentow
-- 3. t_sala_obj           - sala lekcyjna (1 metoda)
-- 4. t_nauczyciel_obj     - nauczyciel z VARRAY (3 metody)
-- 5. t_uczen_obj          - uczen (4 metody)
-- 6. t_kurs_obj           - kurs z REF->instrument (1 metoda)
-- 7. t_lekcja_obj         - lekcja z 4x REF (2 metody)
-- 8. t_ocena_obj          - ocena z 2x REF (2 metody)
--
-- Lacznie: 14 metod, 1 VARRAY, 7 REF
-- ============================================================================
