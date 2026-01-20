-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 07_uzytkownicy.sql
-- Opis: Role i uzytkownicy z uprawnieniami
-- Wersja: 2.0
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================
/*
STRUKTURA UPRAWNIEN v2.0:

1. ROLA_ADMIN_SZKOLY - pelny dostep
2. ROLA_NAUCZYCIEL - ograniczony dostep do nauczania
3. ROLA_SEKRETARIAT - zarzadzanie uczniami i zapisami

Nowe tabele: t_sala, t_semestr
Nowe pakiety: pkg_semestr, pkg_sala
*/

SET SERVEROUTPUT ON;

-- ============================================================================
-- USUWANIE ISTNIEJACYCH OBIEKTOW
-- ============================================================================

BEGIN
    FOR rec IN (SELECT username FROM dba_users 
                WHERE username IN ('ADMIN_SZKOLY', 'NAUCZYCIEL_JAN', 'SEKRETARIAT_ANNA')) LOOP
        EXECUTE IMMEDIATE 'DROP USER ' || rec.username || ' CASCADE';
        DBMS_OUTPUT.PUT_LINE('Usunieto uzytkownika: ' || rec.username);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    FOR rec IN (SELECT role FROM dba_roles 
                WHERE role IN ('ROLA_ADMIN_SZKOLY', 'ROLA_NAUCZYCIEL', 'ROLA_SEKRETARIAT')) LOOP
        EXECUTE IMMEDIATE 'DROP ROLE ' || rec.role;
        DBMS_OUTPUT.PUT_LINE('Usunieto role: ' || rec.role);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

-- ============================================================================
-- TWORZENIE ROL
-- ============================================================================

PROMPT
PROMPT Tworzenie rol...

-- ----------------------------------------------------------------------------
-- ROLA 1: ADMIN_SZKOLY - pelny dostep
-- ----------------------------------------------------------------------------
CREATE ROLE ROLA_ADMIN_SZKOLY;

-- Pelny dostep do wszystkich tabel
GRANT SELECT, INSERT, UPDATE, DELETE ON t_uczen TO ROLA_ADMIN_SZKOLY;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_nauczyciel TO ROLA_ADMIN_SZKOLY;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_kurs TO ROLA_ADMIN_SZKOLY;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_zapis TO ROLA_ADMIN_SZKOLY;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_lekcja TO ROLA_ADMIN_SZKOLY;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_ocena_postepu TO ROLA_ADMIN_SZKOLY;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_sala TO ROLA_ADMIN_SZKOLY;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_semestr TO ROLA_ADMIN_SZKOLY;

-- Dostep do wszystkich sekwencji
GRANT SELECT ON seq_uczen TO ROLA_ADMIN_SZKOLY;
GRANT SELECT ON seq_nauczyciel TO ROLA_ADMIN_SZKOLY;
GRANT SELECT ON seq_kurs TO ROLA_ADMIN_SZKOLY;
GRANT SELECT ON seq_zapis TO ROLA_ADMIN_SZKOLY;
GRANT SELECT ON seq_lekcja TO ROLA_ADMIN_SZKOLY;
GRANT SELECT ON seq_ocena TO ROLA_ADMIN_SZKOLY;
GRANT SELECT ON seq_sala TO ROLA_ADMIN_SZKOLY;
GRANT SELECT ON seq_semestr TO ROLA_ADMIN_SZKOLY;

-- Dostep do wszystkich pakietow
GRANT EXECUTE ON pkg_uczen TO ROLA_ADMIN_SZKOLY;
GRANT EXECUTE ON pkg_lekcja TO ROLA_ADMIN_SZKOLY;
GRANT EXECUTE ON pkg_ocena TO ROLA_ADMIN_SZKOLY;
GRANT EXECUTE ON pkg_semestr TO ROLA_ADMIN_SZKOLY;
GRANT EXECUTE ON pkg_sala TO ROLA_ADMIN_SZKOLY;

PROMPT Utworzono ROLA_ADMIN_SZKOLY (pelny dostep)

-- ----------------------------------------------------------------------------
-- ROLA 2: NAUCZYCIEL - dostep do nauczania
-- ----------------------------------------------------------------------------
CREATE ROLE ROLA_NAUCZYCIEL;

-- Odczyt danych uczniow i kursow
GRANT SELECT ON t_uczen TO ROLA_NAUCZYCIEL;
GRANT SELECT ON t_kurs TO ROLA_NAUCZYCIEL;
GRANT SELECT ON t_zapis TO ROLA_NAUCZYCIEL;
GRANT SELECT ON t_sala TO ROLA_NAUCZYCIEL;
GRANT SELECT ON t_semestr TO ROLA_NAUCZYCIEL;
GRANT SELECT ON t_nauczyciel TO ROLA_NAUCZYCIEL;

-- Zarzadzanie lekcjami i ocenami
GRANT SELECT, INSERT, UPDATE ON t_lekcja TO ROLA_NAUCZYCIEL;
GRANT SELECT, INSERT, UPDATE ON t_ocena_postepu TO ROLA_NAUCZYCIEL;

-- Sekwencje potrzebne do dodawania
GRANT SELECT ON seq_lekcja TO ROLA_NAUCZYCIEL;
GRANT SELECT ON seq_ocena TO ROLA_NAUCZYCIEL;

-- Pakiety do pracy
GRANT EXECUTE ON pkg_lekcja TO ROLA_NAUCZYCIEL;
GRANT EXECUTE ON pkg_ocena TO ROLA_NAUCZYCIEL;
GRANT EXECUTE ON pkg_sala TO ROLA_NAUCZYCIEL;
GRANT EXECUTE ON pkg_semestr TO ROLA_NAUCZYCIEL;

PROMPT Utworzono ROLA_NAUCZYCIEL (lekcje + oceny)

-- ----------------------------------------------------------------------------
-- ROLA 3: SEKRETARIAT - administracja uczniami
-- ----------------------------------------------------------------------------
CREATE ROLE ROLA_SEKRETARIAT;

-- Pelny dostep do uczniow i zapisow
GRANT SELECT, INSERT, UPDATE, DELETE ON t_uczen TO ROLA_SEKRETARIAT;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_zapis TO ROLA_SEKRETARIAT;

-- Odczyt reszty
GRANT SELECT ON t_nauczyciel TO ROLA_SEKRETARIAT;
GRANT SELECT ON t_kurs TO ROLA_SEKRETARIAT;
GRANT SELECT ON t_lekcja TO ROLA_SEKRETARIAT;
GRANT SELECT ON t_ocena_postepu TO ROLA_SEKRETARIAT;
GRANT SELECT ON t_sala TO ROLA_SEKRETARIAT;
GRANT SELECT ON t_semestr TO ROLA_SEKRETARIAT;

-- Sekwencje
GRANT SELECT ON seq_uczen TO ROLA_SEKRETARIAT;
GRANT SELECT ON seq_zapis TO ROLA_SEKRETARIAT;

-- Pakiety
GRANT EXECUTE ON pkg_uczen TO ROLA_SEKRETARIAT;
GRANT EXECUTE ON pkg_semestr TO ROLA_SEKRETARIAT;
GRANT EXECUTE ON pkg_sala TO ROLA_SEKRETARIAT;

PROMPT Utworzono ROLA_SEKRETARIAT (uczniowie + zapisy)

-- ============================================================================
-- TWORZENIE UZYTKOWNIKOW
-- ============================================================================

PROMPT
PROMPT Tworzenie uzytkownikow...

-- ----------------------------------------------------------------------------
-- UZYTKOWNIK 1: ADMIN_SZKOLY
-- ----------------------------------------------------------------------------
CREATE USER admin_szkoly IDENTIFIED BY Admin123!
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON USERS;

GRANT CREATE SESSION TO admin_szkoly;
GRANT ROLA_ADMIN_SZKOLY TO admin_szkoly;

PROMPT Utworzono uzytkownika: ADMIN_SZKOLY (haslo: Admin123!)

-- ----------------------------------------------------------------------------
-- UZYTKOWNIK 2: NAUCZYCIEL_JAN
-- ----------------------------------------------------------------------------
CREATE USER nauczyciel_jan IDENTIFIED BY Nauczyciel123!
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA 50M ON USERS;

GRANT CREATE SESSION TO nauczyciel_jan;
GRANT ROLA_NAUCZYCIEL TO nauczyciel_jan;

PROMPT Utworzono uzytkownika: NAUCZYCIEL_JAN (haslo: Nauczyciel123!)

-- ----------------------------------------------------------------------------
-- UZYTKOWNIK 3: SEKRETARIAT_ANNA
-- ----------------------------------------------------------------------------
CREATE USER sekretariat_anna IDENTIFIED BY Sekretariat123!
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA 50M ON USERS;

GRANT CREATE SESSION TO sekretariat_anna;
GRANT ROLA_SEKRETARIAT TO sekretariat_anna;

PROMPT Utworzono uzytkownika: SEKRETARIAT_ANNA (haslo: Sekretariat123!)

-- ============================================================================
-- SYNONIMY PUBLICZNE
-- ============================================================================

PROMPT
PROMPT Tworzenie synonimow publicznych...

-- Synonimy do tabel (dla latwiejszego dostepu)
BEGIN
    EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM uczniowie FOR t_uczen';
    EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM nauczyciele FOR t_nauczyciel';
    EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM kursy FOR t_kurs';
    EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM zapisy FOR t_zapis';
    EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM lekcje FOR t_lekcja';
    EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM oceny FOR t_ocena_postepu';
    EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM sale FOR t_sala';
    EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM semestry FOR t_semestr';
    DBMS_OUTPUT.PUT_LINE('Utworzono 8 synonimow publicznych');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Blad tworzenia synonimow: ' || SQLERRM);
END;
/

-- ============================================================================
-- PODSUMOWANIE UPRAWNIEN
-- ============================================================================

PROMPT
PROMPT ========================================
PROMPT PODSUMOWANIE UPRAWNIEN v2.0
PROMPT ========================================
PROMPT
PROMPT ROLE:
PROMPT   1. ROLA_ADMIN_SZKOLY - pelny dostep do wszystkiego
PROMPT   2. ROLA_NAUCZYCIEL   - lekcje, oceny, odczyt danych
PROMPT   3. ROLA_SEKRETARIAT  - uczniowie, zapisy, odczyt danych
PROMPT
PROMPT UZYTKOWNICY:
PROMPT   1. ADMIN_SZKOLY      -> ROLA_ADMIN_SZKOLY
PROMPT   2. NAUCZYCIEL_JAN    -> ROLA_NAUCZYCIEL
PROMPT   3. SEKRETARIAT_ANNA  -> ROLA_SEKRETARIAT
PROMPT
PROMPT NOWE OBIEKTY v2.0:
PROMPT   - Tabele: t_sala, t_semestr
PROMPT   - Pakiety: pkg_semestr, pkg_sala
PROMPT   - Sekwencje: seq_sala, seq_semestr
PROMPT
PROMPT ========================================

-- Weryfikacja uprawnien
SELECT grantee, table_name, privilege
FROM dba_tab_privs
WHERE grantee IN ('ROLA_ADMIN_SZKOLY', 'ROLA_NAUCZYCIEL', 'ROLA_SEKRETARIAT')
  AND table_name IN ('T_UCZEN', 'T_LEKCJA', 'T_SALA', 'T_SEMESTR')
ORDER BY grantee, table_name;

PROMPT ========================================
PROMPT Uzytkownicy i role utworzone!
PROMPT ========================================
