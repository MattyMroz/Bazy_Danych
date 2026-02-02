-- ============================================================================
-- SZKOŁA MUZYCZNA I STOPNIA - TABELE OBIEKTOWE
-- Autorzy: Igor Typiński (251237), Mateusz Mróz (251190)
-- ============================================================================

-- ============================================================================
-- CZYSZCZENIE - usunięcie istniejących obiektów
-- ============================================================================
BEGIN EXECUTE IMMEDIATE 'DROP TABLE nauczyciel_przedmiot CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE oceny CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE lekcje CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE uczniowie CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE sale CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE nauczyciele CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE grupy CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE przedmioty CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_przedmioty'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_grupy'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_nauczyciele'; EXCEPTION WHEN OTHERS THEN NULL; END;
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
-- 1. PRZEDMIOTY - słownik przedmiotów
-- ============================================================================
-- UWAGA: CHECK (czas_min = 45) wymusza stały czas trwania.
-- Aby obsłużyć różne czasy (30/45/60 min), zmień na CHECK (czas_min IN (30, 45, 60))
-- ============================================================================
CREATE TABLE przedmioty OF t_przedmiot (
    id PRIMARY KEY,
    nazwa NOT NULL,
    typ NOT NULL CHECK (typ IN ('indywidualny', 'grupowy')),
    czas_min NOT NULL CHECK (czas_min = 45)
);
/

-- ============================================================================
-- 2. GRUPY - klasy
-- ============================================================================
CREATE TABLE grupy OF t_grupa (
    id PRIMARY KEY,
    symbol NOT NULL UNIQUE,
    poziom NOT NULL CHECK (poziom BETWEEN 1 AND 6)
);
/

-- ============================================================================
-- 3. NAUCZYCIELE
-- ============================================================================
CREATE TABLE nauczyciele OF t_nauczyciel (
    id PRIMARY KEY,
    imie NOT NULL,
    nazwisko NOT NULL,
    data_zatr NOT NULL
);
/

-- ============================================================================
-- 4. SALE - z VARRAY wyposażenia
-- ============================================================================
CREATE TABLE sale OF t_sala (
    id PRIMARY KEY,
    numer NOT NULL UNIQUE,
    typ NOT NULL CHECK (typ IN ('indywidualna', 'grupowa')),
    pojemnosc NOT NULL CHECK (pojemnosc > 0)
);
/

-- ============================================================================
-- 5. UCZNIOWIE - z REF do grupy
-- ============================================================================
CREATE TABLE uczniowie OF t_uczen (
    id PRIMARY KEY,
    imie NOT NULL,
    nazwisko NOT NULL,
    data_ur NOT NULL,
    instrument NOT NULL
);
/

-- ============================================================================
-- 6. LEKCJE - z wieloma REF
-- ============================================================================
-- UWAGA: Hardcoded ograniczenia godzin i czasu trwania.
-- Aby zmienić godziny pracy, zmień:
-- 1. CHECK constraint poniżej
-- 2. pkg_lekcje.c_godz_min, c_godz_max (stałe konfiguracyjne)
-- 3. trg_lekcja_godziny (trigger walidacyjny)
-- ============================================================================
CREATE TABLE lekcje OF t_lekcja (
    id PRIMARY KEY,
    data_lekcji NOT NULL,
    godz_rozp NOT NULL CHECK (godz_rozp BETWEEN 14 AND 19),
    czas_min NOT NULL CHECK (czas_min = 45)
);
/

-- ============================================================================
-- 7. OCENY - z REF
-- ============================================================================
CREATE TABLE oceny OF t_ocena (
    id PRIMARY KEY,
    wartosc NOT NULL CHECK (wartosc BETWEEN 1 AND 6),
    data_oceny NOT NULL,
    semestralna NOT NULL CHECK (semestralna IN ('T', 'N'))
);
/

-- ============================================================================
-- SEKWENCJE dla generowania ID
-- ============================================================================
CREATE SEQUENCE seq_przedmioty START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_grupy START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_nauczyciele START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_sale START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_uczniowie START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_lekcje START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_oceny START WITH 1 INCREMENT BY 1;

-- ============================================================================
-- TABELA POWIĄZAŃ: Nauczyciel - Przedmiot (który nauczyciel uczy którego przedmiotu)
-- ============================================================================
CREATE TABLE nauczyciel_przedmiot (
    id_nauczyciela  NUMBER NOT NULL,
    id_przedmiotu   NUMBER NOT NULL,
    PRIMARY KEY (id_nauczyciela, id_przedmiotu)
);

-- ============================================================================
-- Weryfikacja
-- ============================================================================
SELECT table_name FROM user_tables ORDER BY table_name;
SELECT sequence_name FROM user_sequences ORDER BY sequence_name;
