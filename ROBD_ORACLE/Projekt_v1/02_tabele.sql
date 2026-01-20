-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 02_tabele.sql
-- Opis: Tworzenie tabel obiektowych i sekwencji
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- ============================================================================
-- SEKWENCJE (do generowania ID)
-- ============================================================================

-- Usuwanie istniejacych sekwencji
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_instrument'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_nauczyciel'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_uczen'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_kurs'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_lekcja'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_ocena'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- Tworzenie sekwencji
CREATE SEQUENCE seq_instrument START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_nauczyciel START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_uczen START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_kurs START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_lekcja START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ocena START WITH 1 INCREMENT BY 1;

-- ============================================================================
-- 1. TABELA: T_INSTRUMENT
-- Opis: Przechowuje informacje o instrumentach muzycznych
-- ============================================================================
CREATE TABLE t_instrument OF t_instrument_obj (
    id_instrumentu  PRIMARY KEY,
    nazwa           NOT NULL,
    kategoria       NOT NULL,
    
    CONSTRAINT chk_instrument_kategoria 
        CHECK (kategoria IN ('dety', 'strunowe', 'perkusyjne', 'klawiszowe'))
);

-- ============================================================================
-- 2. TABELA: T_NAUCZYCIEL
-- Opis: Przechowuje dane nauczycieli
-- ============================================================================
CREATE TABLE t_nauczyciel OF t_nauczyciel_obj (
    id_nauczyciela      PRIMARY KEY,
    imie                NOT NULL,
    nazwisko            NOT NULL,
    email               UNIQUE,
    data_zatrudnienia   NOT NULL,
    
    CONSTRAINT chk_nauczyciel_email 
        CHECK (email LIKE '%@%')
);

-- ============================================================================
-- 3. TABELA: T_UCZEN
-- Opis: Przechowuje dane uczniow
-- ============================================================================
CREATE TABLE t_uczen OF t_uczen_obj (
    id_ucznia       PRIMARY KEY,
    imie            NOT NULL,
    nazwisko        NOT NULL,
    data_urodzenia  NOT NULL,
    email           UNIQUE,
    data_zapisu     NOT NULL,
    
    CONSTRAINT chk_uczen_email 
        CHECK (email LIKE '%@%'),
    CONSTRAINT chk_uczen_data 
        CHECK (data_zapisu >= data_urodzenia)
);

-- ============================================================================
-- 4. TABELA: T_KURS
-- Opis: Przechowuje informacje o kursach
-- ============================================================================
CREATE TABLE t_kurs OF t_kurs_obj (
    id_kursu        PRIMARY KEY,
    nazwa           NOT NULL,
    poziom          NOT NULL,
    cena_za_lekcje  NOT NULL,
    
    CONSTRAINT chk_kurs_poziom 
        CHECK (poziom IN ('poczatkujacy', 'sredni', 'zaawansowany')),
    CONSTRAINT chk_kurs_cena 
        CHECK (cena_za_lekcje > 0)
)
NESTED TABLE ref_instrument STORE AS nt_kurs_instrument;

-- Uwaga: REF nie wymaga NESTED TABLE, ale Oracle wymaga takiej skladni
-- dla tabel obiektowych z referencjami - mozemy uzyc SCOPE FOR

-- Ponowne tworzenie tabeli t_kurs z prawidlowa skladnia
BEGIN EXECUTE IMMEDIATE 'DROP TABLE t_kurs CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

CREATE TABLE t_kurs OF t_kurs_obj (
    id_kursu        PRIMARY KEY,
    nazwa           NOT NULL,
    poziom          NOT NULL,
    cena_za_lekcje  NOT NULL,
    
    CONSTRAINT chk_kurs_poziom 
        CHECK (poziom IN ('poczatkujacy', 'sredni', 'zaawansowany')),
    CONSTRAINT chk_kurs_cena 
        CHECK (cena_za_lekcje > 0),
    
    -- SCOPE FOR definiuje do jakiej tabeli wskazuje REF
    CONSTRAINT fk_kurs_instrument 
        ref_instrument SCOPE IS t_instrument
);

-- ============================================================================
-- 5. TABELA: T_LEKCJA
-- Opis: Przechowuje informacje o lekcjach
-- ============================================================================
CREATE TABLE t_lekcja OF t_lekcja_obj (
    id_lekcji       PRIMARY KEY,
    data_lekcji     NOT NULL,
    godzina_start   NOT NULL,
    czas_trwania    NOT NULL,
    status          NOT NULL,
    
    CONSTRAINT chk_lekcja_czas 
        CHECK (czas_trwania IN (30, 45, 60, 90)),
    CONSTRAINT chk_lekcja_status 
        CHECK (status IN ('zaplanowana', 'odbyta', 'odwolana')),
    CONSTRAINT chk_lekcja_godzina 
        CHECK (REGEXP_LIKE(godzina_start, '^[0-2][0-9]:[0-5][0-9]$')),
    
    -- SCOPE FOR dla referencji
    CONSTRAINT fk_lekcja_uczen 
        ref_uczen SCOPE IS t_uczen,
    CONSTRAINT fk_lekcja_nauczyciel 
        ref_nauczyciel SCOPE IS t_nauczyciel,
    CONSTRAINT fk_lekcja_kurs 
        ref_kurs SCOPE IS t_kurs
);

-- ============================================================================
-- 6. TABELA: T_OCENA_POSTEPU
-- Opis: Przechowuje oceny postepow uczniow
-- ============================================================================
CREATE TABLE t_ocena_postepu OF t_ocena_obj (
    id_oceny        PRIMARY KEY,
    data_oceny      NOT NULL,
    ocena           NOT NULL,
    obszar          NOT NULL,
    
    CONSTRAINT chk_ocena_zakres 
        CHECK (ocena BETWEEN 1 AND 6),
    CONSTRAINT chk_ocena_obszar 
        CHECK (obszar IN ('technika', 'teoria', 'sluch', 'rytm', 'interpretacja')),
    
    -- SCOPE FOR dla referencji
    CONSTRAINT fk_ocena_uczen 
        ref_uczen SCOPE IS t_uczen,
    CONSTRAINT fk_ocena_nauczyciel 
        ref_nauczyciel SCOPE IS t_nauczyciel
);

-- ============================================================================
-- INDEKSY (dla wydajnosci)
-- ============================================================================

-- Indeksy na czesto wyszukiwanych kolumnach
CREATE INDEX idx_nauczyciel_nazwisko ON t_nauczyciel(nazwisko);
CREATE INDEX idx_uczen_nazwisko ON t_uczen(nazwisko);
CREATE INDEX idx_lekcja_data ON t_lekcja(data_lekcji);
CREATE INDEX idx_ocena_data ON t_ocena_postepu(data_oceny);
CREATE INDEX idx_kurs_poziom ON t_kurs(poziom);

-- ============================================================================
-- PODSUMOWANIE STRUKTURY TABEL
-- ============================================================================
/*
Utworzono 6 tabel obiektowych:
1. t_instrument     - instrumenty muzyczne
2. t_nauczyciel     - nauczyciele (z VARRAY instrumentow)
3. t_uczen          - uczniowie
4. t_kurs           - kursy (REF -> instrument)
5. t_lekcja         - lekcje (REF -> uczen, nauczyciel, kurs)
6. t_ocena_postepu  - oceny (REF -> uczen, nauczyciel)

Sekwencje: 6 (seq_instrument, seq_nauczyciel, seq_uczen, seq_kurs, seq_lekcja, seq_ocena)
Indeksy: 5
Ograniczenia CHECK: 10
*/

PROMPT ========================================
PROMPT Tabele obiektowe utworzone pomyslnie!
PROMPT ========================================

-- ============================================================================
-- WERYFIKACJA STRUKTURY
-- ============================================================================
SELECT table_name, table_type 
FROM user_all_tables 
WHERE table_name IN ('T_INSTRUMENT', 'T_NAUCZYCIEL', 'T_UCZEN', 
                     'T_KURS', 'T_LEKCJA', 'T_OCENA_POSTEPU');
