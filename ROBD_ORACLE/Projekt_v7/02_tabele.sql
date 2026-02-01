-- ============================================================================
-- Projekt: Szkola Muzyczna - Obiektowa Baza Danych (UPROSZCZONA)
-- Plik: 02_tabele.sql
-- Opis: Tworzenie tabel obiektowych z referencjami REF
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- Wersja: 7.0
-- ============================================================================

-- ============================================================================
-- 1. USUNIECIE ISTNIEJACYCH TABEL
-- ============================================================================

BEGIN EXECUTE IMMEDIATE 'DROP TABLE OCENY CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE LEKCJE CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE UCZNIOWIE CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE SALE CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE GRUPY CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE NAUCZYCIELE CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE PRZEDMIOTY CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- Usuniecie sekwencji
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_przedmioty'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_nauczyciele'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_grupy'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_sale'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_uczniowie'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_lekcje'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_oceny'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ============================================================================
-- 2. SEKWENCJE
-- ============================================================================

CREATE SEQUENCE seq_przedmioty START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_nauczyciele START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_grupy START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_sale START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_uczniowie START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_lekcje START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_oceny START WITH 1 INCREMENT BY 1;

-- ============================================================================
-- 3. TABELA PRZEDMIOTY (slownik - 5 rekordow)
-- ============================================================================

CREATE TABLE PRZEDMIOTY OF T_PRZEDMIOT (
    id_przedmiotu       PRIMARY KEY,
    nazwa               NOT NULL UNIQUE,
    typ_zajec           NOT NULL CHECK (typ_zajec IN ('indywidualny', 'grupowy')),
    czas_trwania_min    NOT NULL CHECK (czas_trwania_min IN (30, 45, 60, 90))
)
OBJECT IDENTIFIER IS PRIMARY KEY;

-- ============================================================================
-- 4. TABELA NAUCZYCIELE (6 rekordow)
-- ============================================================================

CREATE TABLE NAUCZYCIELE OF T_NAUCZYCIEL (
    id_nauczyciela      PRIMARY KEY,
    nazwisko            NOT NULL
)
OBJECT IDENTIFIER IS PRIMARY KEY;

-- ============================================================================
-- 5. TABELA GRUPY (6 rekordow)
-- ============================================================================

CREATE TABLE GRUPY OF T_GRUPA (
    id_grupy            PRIMARY KEY,
    kod                 NOT NULL UNIQUE,
    klasa               NOT NULL CHECK (klasa BETWEEN 1 AND 6)
)
OBJECT IDENTIFIER IS PRIMARY KEY;

-- ============================================================================
-- 6. TABELA SALE (4 rekordy) - z VARRAY wyposazenia
-- ============================================================================

CREATE TABLE SALE OF T_SALA (
    id_sali             PRIMARY KEY,
    numer               NOT NULL UNIQUE,
    typ                 NOT NULL CHECK (typ IN ('indywidualna', 'grupowa')),
    pojemnosc           NOT NULL CHECK (pojemnosc > 0)
)
OBJECT IDENTIFIER IS PRIMARY KEY;

-- ============================================================================
-- 7. TABELA UCZNIOWIE (24 rekordy)
-- ============================================================================

CREATE TABLE UCZNIOWIE OF T_UCZEN (
    id_ucznia           PRIMARY KEY,
    nazwisko            NOT NULL,
    data_urodzenia      NOT NULL,
    instrument          NOT NULL,
    ref_grupa           SCOPE IS GRUPY NOT NULL
)
OBJECT IDENTIFIER IS PRIMARY KEY;

-- ============================================================================
-- 8. TABELA LEKCJE (~60 rekordow/tydzien)
-- ============================================================================

CREATE TABLE LEKCJE OF T_LEKCJA (
    id_lekcji           PRIMARY KEY,
    ref_przedmiot       SCOPE IS PRZEDMIOTY NOT NULL,
    ref_nauczyciel      SCOPE IS NAUCZYCIELE NOT NULL,
    ref_sala            SCOPE IS SALE NOT NULL,
    ref_uczen           SCOPE IS UCZNIOWIE,          -- NULL dla grupowych
    ref_grupa           SCOPE IS GRUPY,              -- NULL dla indywidualnych
    data_lekcji         NOT NULL,
    godzina_start       NOT NULL,
    czas_trwania_min    NOT NULL CHECK (czas_trwania_min IN (30, 45, 60, 90))
)
OBJECT IDENTIFIER IS PRIMARY KEY;

-- Constraint XOR: lekcja ALBO indywidualna ALBO grupowa
ALTER TABLE LEKCJE ADD CONSTRAINT chk_lekcja_xor
    CHECK (
        (ref_uczen IS NOT NULL AND ref_grupa IS NULL) OR
        (ref_uczen IS NULL AND ref_grupa IS NOT NULL)
    );

-- ============================================================================
-- 9. TABELA OCENY (~50 rekordow/semestr)
-- ============================================================================

CREATE TABLE OCENY OF T_OCENA (
    id_oceny            PRIMARY KEY,
    ref_uczen           SCOPE IS UCZNIOWIE NOT NULL,
    ref_nauczyciel      SCOPE IS NAUCZYCIELE NOT NULL,
    ref_przedmiot       SCOPE IS PRZEDMIOTY NOT NULL,
    wartosc             NOT NULL CHECK (wartosc BETWEEN 1 AND 6),
    data_wystawienia    NOT NULL,
    czy_semestralna     DEFAULT 'N' CHECK (czy_semestralna IN ('T', 'N'))
)
OBJECT IDENTIFIER IS PRIMARY KEY;

-- ============================================================================
-- 10. INDEKSY
-- ============================================================================

CREATE INDEX idx_lekcje_data ON LEKCJE(data_lekcji);
CREATE INDEX idx_lekcje_godzina ON LEKCJE(godzina_start);
CREATE INDEX idx_oceny_data ON OCENY(data_wystawienia);
CREATE INDEX idx_uczniowie_nazwisko ON UCZNIOWIE(nazwisko);

-- ============================================================================
-- 11. POTWIERDZENIE
-- ============================================================================

SELECT table_name FROM user_tables 
WHERE table_name IN ('PRZEDMIOTY','NAUCZYCIELE','GRUPY','SALE','UCZNIOWIE','LEKCJE','OCENY')
ORDER BY table_name;

SELECT sequence_name FROM user_sequences WHERE sequence_name LIKE 'SEQ_%';
