-- ============================================================================
-- PLIK: 07_uzytkownicy.sql
-- PROJEKT: Szkola Muzyczna v5 - Obiektowa Baza Danych Oracle
-- AUTORZY: Igor Typinski (251237), Mateusz Mroz (251190)
-- DATA: Styczen 2026
-- ============================================================================
-- Tworzy 5 UZYTKOWNIKOW TESTOWYCH i przypisuje role:
--   uczen_test - rola r_uczen
--   nauczyciel_test - rola r_nauczyciel
--   sekretariat_test - rola r_sekretariat
--   admin_test - rola r_administrator
--   igor, mateusz - r_administrator
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200
SET PAGESIZE 50

PROMPT ========================================================================
PROMPT   07_uzytkownicy.sql - Tworzenie uzytkownikow testowych
PROMPT ========================================================================
PROMPT

-- ============================================================================
-- 1. UZYTKOWNIK: UCZEN_TEST
-- ============================================================================

PROMPT [1/5] Tworzenie uczen_test...

CREATE USER uczen_test IDENTIFIED BY Test1234
    DEFAULT TABLESPACE users
    TEMPORARY TABLESPACE temp
    QUOTA 10M ON users;

GRANT CREATE SESSION TO uczen_test;
GRANT r_uczen TO uczen_test;

-- ============================================================================
-- 2. UZYTKOWNIK: NAUCZYCIEL_TEST
-- ============================================================================

PROMPT [2/5] Tworzenie nauczyciel_test...

CREATE USER nauczyciel_test IDENTIFIED BY Test1234
    DEFAULT TABLESPACE users
    TEMPORARY TABLESPACE temp
    QUOTA 50M ON users;

GRANT CREATE SESSION TO nauczyciel_test;
GRANT r_nauczyciel TO nauczyciel_test;

-- ============================================================================
-- 3. UZYTKOWNIK: SEKRETARIAT_TEST
-- ============================================================================

PROMPT [3/5] Tworzenie sekretariat_test...

CREATE USER sekretariat_test IDENTIFIED BY Test1234
    DEFAULT TABLESPACE users
    TEMPORARY TABLESPACE temp
    QUOTA 100M ON users;

GRANT CREATE SESSION TO sekretariat_test;
GRANT r_sekretariat TO sekretariat_test;

-- ============================================================================
-- 4. UZYTKOWNIK: ADMIN_TEST
-- ============================================================================

PROMPT [4/5] Tworzenie admin_test...

CREATE USER admin_test IDENTIFIED BY Test1234
    DEFAULT TABLESPACE users
    TEMPORARY TABLESPACE temp
    QUOTA UNLIMITED ON users;

GRANT CREATE SESSION TO admin_test;
GRANT r_administrator TO admin_test;

-- ============================================================================
-- 5. UZYTKOWNICY: IGOR i MATEUSZ (autorzy projektu)
-- ============================================================================

PROMPT [5/5] Tworzenie igor i mateusz...

CREATE USER igor IDENTIFIED BY Igor1234
    DEFAULT TABLESPACE users
    TEMPORARY TABLESPACE temp
    QUOTA UNLIMITED ON users;

GRANT CREATE SESSION TO igor;
GRANT r_administrator TO igor;

CREATE USER mateusz IDENTIFIED BY Mateusz1234
    DEFAULT TABLESPACE users
    TEMPORARY TABLESPACE temp
    QUOTA UNLIMITED ON users;

GRANT CREATE SESSION TO mateusz;
GRANT r_administrator TO mateusz;

-- ============================================================================
-- SYNONIMY PUBLICZNE
-- Ulatwienie dostepu do obiektow bez prefiksu schematu
-- ============================================================================

PROMPT Tworzenie synonimow publicznych...

-- Typy
CREATE OR REPLACE PUBLIC SYNONYM t_semestr_obj FOR t_semestr_obj;
CREATE OR REPLACE PUBLIC SYNONYM t_instrument_obj FOR t_instrument_obj;
CREATE OR REPLACE PUBLIC SYNONYM t_sala_obj FOR t_sala_obj;
CREATE OR REPLACE PUBLIC SYNONYM t_nauczyciel_obj FOR t_nauczyciel_obj;
CREATE OR REPLACE PUBLIC SYNONYM t_grupa_obj FOR t_grupa_obj;
CREATE OR REPLACE PUBLIC SYNONYM t_uczen_obj FOR t_uczen_obj;
CREATE OR REPLACE PUBLIC SYNONYM t_przedmiot_obj FOR t_przedmiot_obj;
CREATE OR REPLACE PUBLIC SYNONYM t_lekcja_obj FOR t_lekcja_obj;
CREATE OR REPLACE PUBLIC SYNONYM t_egzamin_obj FOR t_egzamin_obj;
CREATE OR REPLACE PUBLIC SYNONYM t_ocena_obj FOR t_ocena_obj;

-- Tabele
CREATE OR REPLACE PUBLIC SYNONYM semestry FOR semestry;
CREATE OR REPLACE PUBLIC SYNONYM instrumenty FOR instrumenty;
CREATE OR REPLACE PUBLIC SYNONYM sale FOR sale;
CREATE OR REPLACE PUBLIC SYNONYM nauczyciele FOR nauczyciele;
CREATE OR REPLACE PUBLIC SYNONYM grupy FOR grupy;
CREATE OR REPLACE PUBLIC SYNONYM uczniowie FOR uczniowie;
CREATE OR REPLACE PUBLIC SYNONYM przedmioty FOR przedmioty;
CREATE OR REPLACE PUBLIC SYNONYM lekcje FOR lekcje;
CREATE OR REPLACE PUBLIC SYNONYM egzaminy FOR egzaminy;
CREATE OR REPLACE PUBLIC SYNONYM oceny FOR oceny;

-- Pakiety
CREATE OR REPLACE PUBLIC SYNONYM pkg_uczen FOR pkg_uczen;
CREATE OR REPLACE PUBLIC SYNONYM pkg_nauczyciel FOR pkg_nauczyciel;
CREATE OR REPLACE PUBLIC SYNONYM pkg_lekcja FOR pkg_lekcja;
CREATE OR REPLACE PUBLIC SYNONYM pkg_ocena FOR pkg_ocena;
CREATE OR REPLACE PUBLIC SYNONYM pkg_raport FOR pkg_raport;

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================

PROMPT
PROMPT ========================================================================
PROMPT   UTWORZENI UZYTKOWNICY
PROMPT ========================================================================
PROMPT   uczen_test / Test1234 - r_uczen
PROMPT   nauczyciel_test / Test1234 - r_nauczyciel
PROMPT   sekretariat_test / Test1234 - r_sekretariat
PROMPT   admin_test / Test1234 - r_administrator
PROMPT   igor / Igor1234 - r_administrator
PROMPT   mateusz / Mateusz1234 - r_administrator
PROMPT ========================================================================
PROMPT   Nastepny krok: Uruchom 08_widoki.sql
PROMPT ========================================================================

SELECT username, account_status, created FROM dba_users
WHERE username IN ('UCZEN_TEST', 'NAUCZYCIEL_TEST', 'SEKRETARIAT_TEST', 'ADMIN_TEST', 'IGOR', 'MATEUSZ')
ORDER BY username;
