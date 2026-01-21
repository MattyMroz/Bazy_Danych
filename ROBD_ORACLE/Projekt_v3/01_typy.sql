-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 01_typy.sql
-- Opis: Definicje typow obiektowych i kolekcji
-- Wersja: 3.0 (uproszczona)
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- ============================================================================
-- CZYSZCZENIE (usuwanie istniejacych typow w odpowiedniej kolejnosci)
-- ============================================================================

BEGIN EXECUTE IMMEDIATE 'DROP TABLE t_ocena_postepu CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
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
-- Reprezentuje instrument muzyczny
-- ============================================================================
CREATE OR REPLACE TYPE t_instrument_obj AS OBJECT (
    id_instrumentu  NUMBER,
    nazwa           VARCHAR2(100),
    kategoria       VARCHAR2(50),
    
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
-- ============================================================================
CREATE OR REPLACE TYPE t_lista_instrumentow AS VARRAY(5) OF VARCHAR2(100);
/

-- ============================================================================
-- 3. TYP: T_SALA_OBJ
-- Reprezentuje sale lekcyjna
-- ============================================================================
CREATE OR REPLACE TYPE t_sala_obj AS OBJECT (
    id_sali         NUMBER,
    nazwa           VARCHAR2(50),
    pojemnosc       NUMBER,
    ma_fortepian    CHAR(1),
    ma_perkusje     CHAR(1),
    
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
-- Reprezentuje nauczyciela szkoły muzycznej
-- Zawiera VARRAY instrumentow
-- ============================================================================
CREATE OR REPLACE TYPE t_nauczyciel_obj AS OBJECT (
    id_nauczyciela      NUMBER,
    imie                VARCHAR2(50),
    nazwisko            VARCHAR2(50),
    email               VARCHAR2(100),
    telefon             VARCHAR2(20),
    data_zatrudnienia   DATE,
    instrumenty         t_lista_instrumentow,
    
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2,
    MEMBER FUNCTION lata_stazu RETURN NUMBER,
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
-- Reprezentuje ucznia szkoły muzycznej
-- Ograniczenia: min 5 lat, dzieci <15 lat lekcje 14:00-19:00
-- ============================================================================
CREATE OR REPLACE TYPE t_uczen_obj AS OBJECT (
    id_ucznia       NUMBER,
    imie            VARCHAR2(50),
    nazwisko        VARCHAR2(50),
    data_urodzenia  DATE,
    email           VARCHAR2(100),
    telefon         VARCHAR2(20),
    data_zapisu     DATE,
    
    MEMBER FUNCTION wiek RETURN NUMBER,
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2,
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
        RETURN imie || ' ' || nazwisko || ' (wiek: ' || SELF.wiek() || ')';
    END pelne_dane;
    
    MEMBER FUNCTION czy_pelnoletni RETURN VARCHAR2 IS
    BEGIN
        IF SELF.wiek() >= 18 THEN RETURN 'TAK'; ELSE RETURN 'NIE'; END IF;
    END czy_pelnoletni;
END;
/

-- ============================================================================
-- 6. TYP: T_KURS_OBJ
-- Reprezentuje kurs nauki gry na instrumencie
-- ============================================================================
CREATE OR REPLACE TYPE t_kurs_obj AS OBJECT (
    id_kursu        NUMBER,
    nazwa           VARCHAR2(100),
    poziom          VARCHAR2(20),
    cena_za_lekcje  NUMBER(10,2),
    ref_instrument  REF t_instrument_obj,
    
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
-- Reprezentuje pojedyncza lekcje
-- REF: uczen, nauczyciel, kurs, sala
-- ============================================================================
CREATE OR REPLACE TYPE t_lekcja_obj AS OBJECT (
    id_lekcji       NUMBER,
    data_lekcji     DATE,
    godzina_start   VARCHAR2(5),
    czas_trwania    NUMBER,
    temat           VARCHAR2(200),
    uwagi           VARCHAR2(500),
    status          VARCHAR2(20),
    ref_uczen       REF t_uczen_obj,
    ref_nauczyciel  REF t_nauczyciel_obj,
    ref_kurs        REF t_kurs_obj,
    ref_sala        REF t_sala_obj,
    
    MEMBER FUNCTION czas_txt RETURN VARCHAR2,
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
-- REF: uczen, nauczyciel
-- ============================================================================
CREATE OR REPLACE TYPE t_ocena_obj AS OBJECT (
    id_oceny        NUMBER,
    data_oceny      DATE,
    ocena           NUMBER(1),
    komentarz       VARCHAR2(500),
    obszar          VARCHAR2(50),
    ref_uczen       REF t_uczen_obj,
    ref_nauczyciel  REF t_nauczyciel_obj,
    
    MEMBER FUNCTION ocena_slownie RETURN VARCHAR2,
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
-- PODSUMOWANIE TYPOW - WERSJA 3.0
-- ============================================================================
/*
Utworzono 8 typow:

1. t_instrument_obj     - instrument (1 metoda)
2. t_lista_instrumentow - VARRAY(5) nazw instrumentow
3. t_sala_obj           - sala lekcyjna (1 metoda)
4. t_nauczyciel_obj     - nauczyciel z VARRAY (3 metody)
5. t_uczen_obj          - uczen (3 metody)
6. t_kurs_obj           - kurs z REF->instrument (1 metoda)
7. t_lekcja_obj         - lekcja z 4x REF (2 metody)
8. t_ocena_obj          - ocena z 2x REF (2 metody)

Lacznie: 13 metod, 1 VARRAY, 7 REF
*/
