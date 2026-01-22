-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 02_tabele.sql
-- Opis: Tworzenie tabel obiektowych i sekwencji
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- ============================================================================
-- SEKWENCJE - generowanie unikalnych identyfikatorow
-- ============================================================================
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_instrument'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_sala'; EXCEPTION WHEN OTHERS THEN NULL; END;
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

CREATE SEQUENCE seq_instrument START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_sala START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_nauczyciel START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_uczen START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_kurs START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_lekcja START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ocena START WITH 1 INCREMENT BY 1;

-- ============================================================================
-- 1. TABELA: T_INSTRUMENT
-- Slownik instrumentow muzycznych
-- ============================================================================
CREATE TABLE t_instrument OF t_instrument_obj (
    id_instrumentu  PRIMARY KEY,
    nazwa           NOT NULL,
    kategoria       NOT NULL,

    CONSTRAINT chk_instrument_kat 
        CHECK (kategoria IN ('dete', 'strunowe', 'perkusyjne', 'klawiszowe'))
);

-- ============================================================================
-- 2. TABELA: T_SALA
-- Sale lekcyjne z wyposazeniem
-- ============================================================================
CREATE TABLE t_sala OF t_sala_obj (
    id_sali         PRIMARY KEY,
    nazwa           NOT NULL UNIQUE,
    pojemnosc       NOT NULL,
    ma_fortepian    NOT NULL,
    ma_perkusje     NOT NULL,

    CONSTRAINT chk_sala_poj CHECK (pojemnosc BETWEEN 1 AND 20),
    CONSTRAINT chk_sala_fort CHECK (ma_fortepian IN ('T', 'N')),
    CONSTRAINT chk_sala_perk CHECK (ma_perkusje IN ('T', 'N'))
);

-- ============================================================================
-- 3. TABELA: T_NAUCZYCIEL
-- Nauczyciele z lista instrumentow (VARRAY)
-- ============================================================================
CREATE TABLE t_nauczyciel OF t_nauczyciel_obj (
    id_nauczyciela      PRIMARY KEY,
    imie                NOT NULL,
    nazwisko            NOT NULL,
    email               UNIQUE NOT NULL,
    data_zatrudnienia   NOT NULL,

    CONSTRAINT chk_naucz_email CHECK (email LIKE '%@%')
);

-- ============================================================================
-- 4. TABELA: T_UCZEN
-- Uczniowie szkoly muzycznej
-- Minimalny wiek 5 lat - kontrolowany przez trigger
-- ============================================================================
CREATE TABLE t_uczen OF t_uczen_obj (
    id_ucznia       PRIMARY KEY,
    imie            NOT NULL,
    nazwisko        NOT NULL,
    data_urodzenia  NOT NULL,
    email           UNIQUE,
    data_zapisu     NOT NULL,

    CONSTRAINT chk_uczen_email CHECK (email IS NULL OR email LIKE '%@%')
);

-- ============================================================================
-- 5. TABELA: T_KURS
-- Kursy nauki gry na instrumencie
-- Zawiera REF do instrumentu (SCOPE IS ogranicza do tabeli t_instrument)
-- ============================================================================
CREATE TABLE t_kurs OF t_kurs_obj (
    id_kursu        PRIMARY KEY,
    nazwa           NOT NULL,
    poziom          NOT NULL,
    cena_za_lekcje  NOT NULL,

    CONSTRAINT chk_kurs_poz CHECK (poziom IN ('poczatkujacy', 'sredni', 'zaawansowany')),
    CONSTRAINT chk_kurs_cena CHECK (cena_za_lekcje > 0),
    CONSTRAINT fk_kurs_instr ref_instrument SCOPE IS t_instrument
);

-- ============================================================================
-- 6. TABELA: T_LEKCJA
-- Pojedyncze lekcje muzyki
-- Reguly biznesowe (kontrolowane przez trigger i pakiet):
--   - Godziny 08:00-20:00
--   - Tylko dni robocze (Pn-Pt)
--   - Dzieci (<15 lat): 14:00-19:00
--   - Nauczyciel max 6h/dzien
--   - Uczen max 2 lekcje/dzien
--   - Brak konfliktow sal/nauczycieli/uczniow
-- ============================================================================
CREATE TABLE t_lekcja OF t_lekcja_obj (
    id_lekcji       PRIMARY KEY,
    data_lekcji     NOT NULL,
    godzina_start   NOT NULL,
    czas_trwania    NOT NULL,
    status          NOT NULL,

    CONSTRAINT chk_lek_czas CHECK (czas_trwania IN (30, 45, 60, 90)),
    CONSTRAINT chk_lek_status CHECK (status IN ('zaplanowana', 'odbyta', 'odwolana')),
    CONSTRAINT chk_lek_godz CHECK (REGEXP_LIKE(godzina_start, '^[0-2][0-9]:[0-5][0-9]$')),
    CONSTRAINT chk_lek_godz_zakres CHECK (godzina_start >= '08:00' AND godzina_start <= '20:00'),

    CONSTRAINT fk_lek_uczen ref_uczen SCOPE IS t_uczen,
    CONSTRAINT fk_lek_naucz ref_nauczyciel SCOPE IS t_nauczyciel,
    CONSTRAINT fk_lek_kurs ref_kurs SCOPE IS t_kurs,
    CONSTRAINT fk_lek_sala ref_sala SCOPE IS t_sala
);

-- ============================================================================
-- 7. TABELA: T_OCENA
-- Oceny postepow uczniow
-- ============================================================================
CREATE TABLE t_ocena OF t_ocena_obj (
    id_oceny        PRIMARY KEY,
    data_oceny      NOT NULL,
    ocena           NOT NULL,
    obszar          NOT NULL,

    CONSTRAINT chk_ocena_zak CHECK (ocena BETWEEN 1 AND 6),
    CONSTRAINT chk_ocena_obs CHECK (obszar IN ('technika', 'teoria', 'sluch', 'rytm', 'interpretacja', 'ogolna')),

    CONSTRAINT fk_ocena_uczen ref_uczen SCOPE IS t_uczen,
    CONSTRAINT fk_ocena_naucz ref_nauczyciel SCOPE IS t_nauczyciel
);

-- ============================================================================
-- INDEKSY - przyspieszenie wyszukiwania
-- ============================================================================
CREATE INDEX idx_uczen_nazwisko ON t_uczen(nazwisko);
CREATE INDEX idx_naucz_nazwisko ON t_nauczyciel(nazwisko);
CREATE INDEX idx_lekcja_data ON t_lekcja(data_lekcji);
CREATE INDEX idx_lekcja_status ON t_lekcja(status);
CREATE INDEX idx_ocena_data ON t_ocena(data_oceny);

-- ============================================================================
-- PODSUMOWANIE TABEL
-- ============================================================================
-- Utworzono 7 tabel obiektowych:
-- 1. t_instrument     - slownik instrumentow
-- 2. t_sala           - sale lekcyjne
-- 3. t_nauczyciel     - nauczyciele (z VARRAY)
-- 4. t_uczen          - uczniowie
-- 5. t_kurs           - kursy (REF -> instrument)
-- 6. t_lekcja         - lekcje (4x REF)
-- 7. t_ocena          - oceny (2x REF)
--
-- Sekwencje: 7
-- Indeksy: 5
-- Ograniczenia CHECK: 11
-- Referencje REF z SCOPE IS: 7
-- ============================================================================
