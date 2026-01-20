-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 01_typy.sql
-- Opis: Definicje typow obiektowych i kolekcji
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- ============================================================================
-- CZYSZCZENIE (usuwanie istniejacych typow w odpowiedniej kolejnosci)
-- ============================================================================

-- Najpierw usuwamy tabele (jesli istnieja)
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE t_ocena_postepu CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE t_lekcja CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE t_kurs CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE t_uczen CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE t_nauczyciel CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE t_instrument CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Usuwamy typy (od najbardziej zaleznych)
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE t_ocena_obj FORCE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE t_lekcja_obj FORCE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE t_kurs_obj FORCE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE t_uczen_obj FORCE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE t_nauczyciel_obj FORCE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE t_lista_instrumentow FORCE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE t_instrument_obj FORCE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- ============================================================================
-- 1. TYP: T_INSTRUMENT_OBJ
-- Opis: Reprezentuje instrument muzyczny
-- ============================================================================
CREATE OR REPLACE TYPE t_instrument_obj AS OBJECT (
    id_instrumentu  NUMBER,
    nazwa           VARCHAR2(100),
    kategoria       VARCHAR2(50),    -- dety, strunowe, perkusyjne, klawiszowe
    
    -- Metoda: Zwraca pelny opis instrumentu
    MEMBER FUNCTION opis RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_instrument_obj AS
    MEMBER FUNCTION opis RETURN VARCHAR2 IS
    BEGIN
        RETURN nazwa || ' (kategoria: ' || kategoria || ')';
    END opis;
END;
/

-- ============================================================================
-- 2. TYP: T_LISTA_INSTRUMENTOW (VARRAY)
-- Opis: Kolekcja nazw instrumentow - nauczyciel moze uczyc max 5
-- ============================================================================
CREATE OR REPLACE TYPE t_lista_instrumentow AS VARRAY(5) OF VARCHAR2(100);
/

-- ============================================================================
-- 3. TYP: T_NAUCZYCIEL_OBJ
-- Opis: Reprezentuje nauczyciela w szkole muzycznej
-- ============================================================================
CREATE OR REPLACE TYPE t_nauczyciel_obj AS OBJECT (
    id_nauczyciela  NUMBER,
    imie            VARCHAR2(50),
    nazwisko        VARCHAR2(50),
    email           VARCHAR2(100),
    telefon         VARCHAR2(20),
    data_zatrudnienia DATE,
    instrumenty     t_lista_instrumentow,  -- VARRAY - lista instrumentow
    
    -- Metoda: Zwraca pelne dane nauczyciela
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2,
    
    -- Metoda: Sprawdza czy nauczyciel jest seniorem (>10 lat stazu)
    MEMBER FUNCTION czy_senior RETURN VARCHAR2,
    
    -- Metoda: Oblicza lata stazu
    MEMBER FUNCTION lata_stazu RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY t_nauczyciel_obj AS
    
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2 IS
    BEGIN
        RETURN imie || ' ' || nazwisko || ' (tel: ' || telefon || ')';
    END pelne_dane;
    
    MEMBER FUNCTION czy_senior RETURN VARCHAR2 IS
    BEGIN
        IF MONTHS_BETWEEN(SYSDATE, data_zatrudnienia) / 12 > 10 THEN
            RETURN 'TAK';
        ELSE
            RETURN 'NIE';
        END IF;
    END czy_senior;
    
    MEMBER FUNCTION lata_stazu RETURN NUMBER IS
    BEGIN
        RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, data_zatrudnienia) / 12);
    END lata_stazu;
    
END;
/

-- ============================================================================
-- 4. TYP: T_UCZEN_OBJ
-- Opis: Reprezentuje ucznia szkoly muzycznej
-- ============================================================================
CREATE OR REPLACE TYPE t_uczen_obj AS OBJECT (
    id_ucznia       NUMBER,
    imie            VARCHAR2(50),
    nazwisko        VARCHAR2(50),
    data_urodzenia  DATE,
    email           VARCHAR2(100),
    telefon         VARCHAR2(20),
    data_zapisu     DATE,
    
    -- Metoda: Oblicza wiek ucznia
    MEMBER FUNCTION wiek RETURN NUMBER,
    
    -- Metoda: Zwraca pelne dane ucznia
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2,
    
    -- Metoda: Sprawdza czy uczen jest pelnoletni
    MEMBER FUNCTION czy_pelnoletni RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_uczen_obj AS
    
    MEMBER FUNCTION wiek RETURN NUMBER IS
    BEGIN
        RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, data_urodzenia) / 12);
    END wiek;
    
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2 IS
    BEGIN
        RETURN imie || ' ' || nazwisko || ' (wiek: ' || SELF.wiek() || ' lat)';
    END pelne_dane;
    
    MEMBER FUNCTION czy_pelnoletni RETURN VARCHAR2 IS
    BEGIN
        IF SELF.wiek() >= 18 THEN
            RETURN 'TAK';
        ELSE
            RETURN 'NIE';
        END IF;
    END czy_pelnoletni;
    
END;
/

-- ============================================================================
-- 5. TYP: T_KURS_OBJ
-- Opis: Reprezentuje kurs nauki gry na instrumencie
-- ============================================================================
CREATE OR REPLACE TYPE t_kurs_obj AS OBJECT (
    id_kursu        NUMBER,
    nazwa           VARCHAR2(100),
    poziom          VARCHAR2(20),    -- poczatkujacy, sredni, zaawansowany
    cena_za_lekcje  NUMBER(10,2),
    ref_instrument  REF t_instrument_obj,  -- REFERENCJA do instrumentu
    
    -- Metoda: Zwraca informacje o kursie
    MEMBER FUNCTION info_kursu RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_kurs_obj AS
    
    MEMBER FUNCTION info_kursu RETURN VARCHAR2 IS
    BEGIN
        RETURN nazwa || ' [' || poziom || '] - ' || cena_za_lekcje || ' PLN/lekcja';
    END info_kursu;
    
END;
/

-- ============================================================================
-- 6. TYP: T_LEKCJA_OBJ
-- Opis: Reprezentuje pojedyncza lekcje
-- ============================================================================
CREATE OR REPLACE TYPE t_lekcja_obj AS OBJECT (
    id_lekcji       NUMBER,
    data_lekcji     DATE,
    godzina_start   VARCHAR2(5),     -- format HH:MM
    czas_trwania    NUMBER,          -- w minutach (30, 45, 60, 90)
    temat           VARCHAR2(200),
    uwagi           VARCHAR2(500),
    status          VARCHAR2(20),    -- zaplanowana, odbyta, odwolana
    ref_uczen       REF t_uczen_obj,
    ref_nauczyciel  REF t_nauczyciel_obj,
    ref_kurs        REF t_kurs_obj,
    
    -- Metoda: Zwraca czas trwania w formacie tekstowym
    MEMBER FUNCTION czas_trwania_txt RETURN VARCHAR2,
    
    -- Metoda: Sprawdza czy lekcja juz sie odbyla
    MEMBER FUNCTION czy_odbyta RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_lekcja_obj AS
    
    MEMBER FUNCTION czas_trwania_txt RETURN VARCHAR2 IS
    BEGIN
        RETURN czas_trwania || ' minut';
    END czas_trwania_txt;
    
    MEMBER FUNCTION czy_odbyta RETURN VARCHAR2 IS
    BEGIN
        IF status = 'odbyta' THEN
            RETURN 'TAK';
        ELSE
            RETURN 'NIE';
        END IF;
    END czy_odbyta;
    
END;
/

-- ============================================================================
-- 7. TYP: T_OCENA_OBJ
-- Opis: Reprezentuje ocene postepu ucznia
-- ============================================================================
CREATE OR REPLACE TYPE t_ocena_obj AS OBJECT (
    id_oceny        NUMBER,
    data_oceny      DATE,
    ocena           NUMBER(1),       -- skala 1-6
    komentarz       VARCHAR2(500),
    obszar          VARCHAR2(100),   -- technika, teoria, sluch, rytm, interpretacja
    ref_uczen       REF t_uczen_obj,
    ref_nauczyciel  REF t_nauczyciel_obj,
    
    -- Metoda: Sprawdza czy ocena jest pozytywna (>=2)
    MEMBER FUNCTION czy_pozytywna RETURN VARCHAR2,
    
    -- Metoda: Zwraca ocene slownie
    MEMBER FUNCTION ocena_slownie RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_ocena_obj AS
    
    MEMBER FUNCTION czy_pozytywna RETURN VARCHAR2 IS
    BEGIN
        IF ocena >= 2 THEN
            RETURN 'TAK';
        ELSE
            RETURN 'NIE';
        END IF;
    END czy_pozytywna;
    
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
    
END;
/

-- ============================================================================
-- PODSUMOWANIE UTWORZONYCH TYPOW
-- ============================================================================
/*
Utworzono 7 typow:
1. t_instrument_obj     - instrument muzyczny (1 metoda)
2. t_lista_instrumentow - VARRAY(5) nazw instrumentow
3. t_nauczyciel_obj     - nauczyciel (3 metody) + VARRAY
4. t_uczen_obj          - uczen (3 metody)
5. t_kurs_obj           - kurs z REF do instrumentu (1 metoda)
6. t_lekcja_obj         - lekcja z 3x REF (2 metody)
7. t_ocena_obj          - ocena z 2x REF (2 metody)

Razem: 12 metod, 1 VARRAY, 6 REF
*/

PROMPT ========================================
PROMPT Typy obiektowe utworzone pomyslnie!
PROMPT ========================================
