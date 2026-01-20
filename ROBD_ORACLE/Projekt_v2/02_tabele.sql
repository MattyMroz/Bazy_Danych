-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 02_tabele.sql
-- Opis: Tworzenie tabel obiektowych i sekwencji
-- Wersja: 2.0
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- ============================================================================
-- SEKWENCJE (do generowania ID)
-- ============================================================================

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
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_sala'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_semestr'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_audit_log'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

CREATE SEQUENCE seq_instrument START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_nauczyciel START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_uczen START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_kurs START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_lekcja START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ocena START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_sala START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_semestr START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_audit_log START WITH 1 INCREMENT BY 1;

PROMPT Sekwencje utworzone.

-- ============================================================================
-- 1. TABELA: T_INSTRUMENT
-- Opis: Przechowuje informacje o instrumentach muzycznych
-- Ograniczenia: kategoria musi byc z listy dozwolonych
-- ============================================================================
CREATE TABLE t_instrument OF t_instrument_obj (
    id_instrumentu  PRIMARY KEY,
    nazwa           NOT NULL,
    kategoria       NOT NULL,
    
    CONSTRAINT chk_instrument_kategoria 
        CHECK (kategoria IN ('dety', 'strunowe', 'perkusyjne', 'klawiszowe'))
);

PROMPT Tabela T_INSTRUMENT utworzona.

-- ============================================================================
-- 2. TABELA: T_SALA (NOWA w v2.0)
-- Opis: Przechowuje informacje o salach lekcyjnych
-- Ograniczenia: pojemnosc 1-20, flagi T/N
-- Cel: Kontrola konfliktow sal przy planowaniu lekcji
-- ============================================================================
CREATE TABLE t_sala OF t_sala_obj (
    id_sali         PRIMARY KEY,
    nazwa           NOT NULL UNIQUE,
    pojemnosc       NOT NULL,
    ma_fortepian    NOT NULL,
    ma_perkusje     NOT NULL,
    
    CONSTRAINT chk_sala_pojemnosc 
        CHECK (pojemnosc BETWEEN 1 AND 20),
    CONSTRAINT chk_sala_fortepian 
        CHECK (ma_fortepian IN ('T', 'N')),
    CONSTRAINT chk_sala_perkusja 
        CHECK (ma_perkusje IN ('T', 'N'))
);

PROMPT Tabela T_SALA utworzona.

-- ============================================================================
-- 3. TABELA: T_SEMESTR (NOWA w v2.0)
-- Opis: Przechowuje informacje o semestrach
-- Ograniczenia: data_do > data_od, czy_aktywny T/N
-- Wazne: Tylko 1 semestr moze byc aktywny (sprawdzane przez trigger)
-- Cel: Ramy czasowe dla planowania lekcji
-- ============================================================================
CREATE TABLE t_semestr OF t_semestr_obj (
    id_semestru     PRIMARY KEY,
    nazwa           NOT NULL UNIQUE,
    data_od         NOT NULL,
    data_do         NOT NULL,
    czy_aktywny     NOT NULL,
    
    CONSTRAINT chk_semestr_daty 
        CHECK (data_do > data_od),
    CONSTRAINT chk_semestr_aktywny 
        CHECK (czy_aktywny IN ('T', 'N'))
);

PROMPT Tabela T_SEMESTR utworzona.

-- ============================================================================
-- 4. TABELA: T_NAUCZYCIEL
-- Opis: Przechowuje dane nauczycieli
-- Zawiera: VARRAY instrumentow (t_lista_instrumentow)
-- Ograniczenia: email unikalny i poprawny format
-- Limit biznesowy: Max 6h lekcji dziennie (trigger)
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

PROMPT Tabela T_NAUCZYCIEL utworzona.

-- ============================================================================
-- 5. TABELA: T_UCZEN
-- Opis: Przechowuje dane uczniow
-- Ograniczenia: email unikalny, data_zapisu >= data_urodzenia
-- Limity biznesowe (triggery):
--   - Minimalny wiek: 5 lat
--   - Dzieci <15 lat: lekcje tylko 14:00-19:00
--   - Max 2 lekcje dziennie
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

PROMPT Tabela T_UCZEN utworzona.

-- ============================================================================
-- 6. TABELA: T_KURS
-- Opis: Przechowuje informacje o kursach nauki gry
-- REF: ref_instrument -> t_instrument
-- Ograniczenia: poziom z listy, cena > 0
-- ============================================================================
CREATE TABLE t_kurs OF t_kurs_obj (
    id_kursu        PRIMARY KEY,
    nazwa           NOT NULL,
    poziom          NOT NULL,
    cena_za_lekcje  NOT NULL,
    
    CONSTRAINT chk_kurs_poziom 
        CHECK (poziom IN ('poczatkujacy', 'sredni', 'zaawansowany')),
    CONSTRAINT chk_kurs_cena 
        CHECK (cena_za_lekcje > 0),
    
    CONSTRAINT fk_kurs_instrument 
        ref_instrument SCOPE IS t_instrument
);

PROMPT Tabela T_KURS utworzona.

-- ============================================================================
-- 7. TABELA: T_LEKCJA (ZMODYFIKOWANA w v2.0)
-- Opis: Przechowuje informacje o lekcjach
-- REF: ref_uczen, ref_nauczyciel, ref_kurs, ref_sala (NOWE!)
-- Ograniczenia CHECK:
--   - czas_trwania: 30, 45, 60, 90 minut
--   - status: zaplanowana, odbyta, odwolana
--   - godzina_start: format HH:MM, zakres 08:00-20:00
-- Ograniczenia biznesowe (triggery):
--   - Godziny dla dzieci <15 lat: 14:00-19:00
--   - Max 6h lekcji dziennie per nauczyciel
--   - Max 2 lekcje dziennie per uczen
--   - Brak konfliktow sal
--   - Brak konfliktow czasowych ucznia/nauczyciela
--   - Lekcja w ramach aktywnego semestru
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
    CONSTRAINT chk_lekcja_godzina_zakres
        CHECK (godzina_start >= '08:00' AND godzina_start <= '20:00'),
    
    CONSTRAINT fk_lekcja_uczen 
        ref_uczen SCOPE IS t_uczen,
    CONSTRAINT fk_lekcja_nauczyciel 
        ref_nauczyciel SCOPE IS t_nauczyciel,
    CONSTRAINT fk_lekcja_kurs 
        ref_kurs SCOPE IS t_kurs,
    CONSTRAINT fk_lekcja_sala 
        ref_sala SCOPE IS t_sala
);

PROMPT Tabela T_LEKCJA utworzona.

-- ============================================================================
-- 8. TABELA: T_OCENA_POSTEPU
-- Opis: Przechowuje oceny postepow uczniow
-- REF: ref_uczen, ref_nauczyciel
-- Ograniczenia: ocena 1-6, obszar z listy
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
    
    CONSTRAINT fk_ocena_uczen 
        ref_uczen SCOPE IS t_uczen,
    CONSTRAINT fk_ocena_nauczyciel 
        ref_nauczyciel SCOPE IS t_nauczyciel
);

PROMPT Tabela T_OCENA_POSTEPU utworzona.

-- ============================================================================
-- TABELA AUDYTOWA (dla triggerow audytowych)
-- ============================================================================
CREATE TABLE t_audit_log (
    id_logu         NUMBER PRIMARY KEY,
    nazwa_tabeli    VARCHAR2(50),
    operacja        VARCHAR2(20),
    stara_wartosc   VARCHAR2(500),
    nowa_wartosc    VARCHAR2(500),
    uzytkownik      VARCHAR2(50),
    data_zmiany     TIMESTAMP DEFAULT SYSTIMESTAMP
);

PROMPT Tabela T_AUDIT_LOG utworzona.

-- ============================================================================
-- INDEKSY (dla wydajnosci)
-- ============================================================================

CREATE INDEX idx_nauczyciel_nazwisko ON t_nauczyciel(nazwisko);
CREATE INDEX idx_uczen_nazwisko ON t_uczen(nazwisko);
CREATE INDEX idx_lekcja_data ON t_lekcja(data_lekcji);
CREATE INDEX idx_lekcja_status ON t_lekcja(status);
CREATE INDEX idx_ocena_data ON t_ocena_postepu(data_oceny);
CREATE INDEX idx_kurs_poziom ON t_kurs(poziom);
CREATE INDEX idx_semestr_aktywny ON t_semestr(czy_aktywny);

PROMPT Indeksy utworzone.

-- ============================================================================
-- PODSUMOWANIE STRUKTURY TABEL - WERSJA 2.0
-- ============================================================================
/*
Utworzono 8 tabel obiektowych:

TABELE SLOWNIKOWE:
1. t_instrument     - instrumenty muzyczne
2. t_sala           - sale lekcyjne [NEW v2.0]
3. t_semestr        - semestry [NEW v2.0]

TABELE GLOWNE:
4. t_nauczyciel     - nauczyciele (z VARRAY instrumentow)
5. t_uczen          - uczniowie
6. t_kurs           - kursy (REF -> instrument)
7. t_lekcja         - lekcje (REF -> uczen, nauczyciel, kurs, sala) [MODIFIED]
8. t_ocena_postepu  - oceny (REF -> uczen, nauczyciel)

TABELA POMOCNICZA:
- t_audit_log       - logi audytowe

STATYSTYKI:
- Tabele obiektowe: 8 (bylo 6, +2 nowe)
- Sekwencje: 9 (bylo 6, +3 nowe)
- Indeksy: 7 (bylo 5, +2 nowe)
- Ograniczenia CHECK: 14 (bylo 10, +4 nowe)
- Referencje REF: 7 (bylo 6, +1 nowy)

DIAGRAM RELACJI:
t_instrument <-- t_kurs <-- t_lekcja --> t_sala
                              |    |
                              v    v
                         t_uczen  t_nauczyciel
                              ^         ^
                              |         |
                         t_ocena_postepu

t_semestr -- (walidacja przez trigger) --> t_lekcja
*/

PROMPT ========================================
PROMPT Tabele obiektowe utworzone pomyslnie!
PROMPT Wersja 2.0 - z salami i semestrami
PROMPT ========================================

-- ============================================================================
-- WERYFIKACJA STRUKTURY
-- ============================================================================
SELECT table_name, table_type 
FROM user_all_tables 
WHERE table_name IN ('T_INSTRUMENT', 'T_NAUCZYCIEL', 'T_UCZEN', 
                     'T_KURS', 'T_LEKCJA', 'T_OCENA_POSTEPU',
                     'T_SALA', 'T_SEMESTR', 'T_AUDIT_LOG')
ORDER BY table_name;
