-- ============================================================================
-- Projekt: Szkola Muzyczna - Obiektowa Baza Danych
-- Plik: 00_schemat.sql
-- Opis: Tworzenie schematu glownego (sm_admin) oraz uzytkownikow dostepu
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- UWAGA: Ten skrypt nalezy uruchomic jako SYS lub SYSTEM

-- ============================================================================
-- 1. USUNIECIE STARYCH SCHEMATOW I UZYTKOWNIKOW (jesli istnieja)
-- ============================================================================

-- Schemat glowny (wlasciciel obiektow)
BEGIN EXECUTE IMMEDIATE 'DROP USER SM_ADMIN CASCADE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1918 THEN RAISE; END IF; END;
/

-- Uzytkownicy dostepu
BEGIN EXECUTE IMMEDIATE 'DROP USER ADMIN CASCADE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1918 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP USER SEKRETARIAT CASCADE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1918 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP USER NAUCZYCIEL CASCADE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1918 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP USER UCZEN CASCADE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1918 THEN RAISE; END IF; END;
/

-- Role
BEGIN EXECUTE IMMEDIATE 'DROP ROLE ROLA_ADMIN'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP ROLE ROLA_SEKRETARIAT'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP ROLE ROLA_NAUCZYCIEL'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP ROLE ROLA_UCZEN'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ============================================================================
-- 2. TWORZENIE SCHEMATU GLOWNEGO (SM_ADMIN)
-- ============================================================================
-- SM_ADMIN - wlasciciel wszystkich obiektow bazy

CREATE USER SM_ADMIN IDENTIFIED BY sm_admin123
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON USERS;

-- Uprawnienia do tworzenia obiektow
GRANT CONNECT, RESOURCE TO SM_ADMIN;
GRANT CREATE SESSION TO SM_ADMIN;
GRANT CREATE TABLE TO SM_ADMIN;
GRANT CREATE VIEW TO SM_ADMIN;
GRANT CREATE PROCEDURE TO SM_ADMIN;
GRANT CREATE TRIGGER TO SM_ADMIN;
GRANT CREATE TYPE TO SM_ADMIN;
GRANT CREATE SEQUENCE TO SM_ADMIN;
GRANT DEBUG CONNECT SESSION TO SM_ADMIN;

-- ============================================================================
-- 3. TWORZENIE ROL
-- ============================================================================

-- ROLA_ADMIN - pelny dostep (administrator systemu)
CREATE ROLE ROLA_ADMIN;

-- ROLA_SEKRETARIAT - zarzadzanie uczniami i lekcjami
CREATE ROLE ROLA_SEKRETARIAT;

-- ROLA_NAUCZYCIEL - odczyt danych + wystawianie ocen
CREATE ROLE ROLA_NAUCZYCIEL;

-- ROLA_UCZEN - tylko odczyt swoich danych
CREATE ROLE ROLA_UCZEN;

-- ============================================================================
-- 4. TWORZENIE UZYTKOWNIKOW DOSTEPU
-- ============================================================================

-- ADMIN - administrator systemu (pelny dostep)
CREATE USER ADMIN IDENTIFIED BY admin123
    DEFAULT TABLESPACE USERS
    QUOTA UNLIMITED ON USERS;

GRANT CREATE SESSION TO ADMIN;
GRANT ROLA_ADMIN TO ADMIN;

-- SEKRETARIAT - pracownik sekretariatu
CREATE USER SEKRETARIAT IDENTIFIED BY sekretariat123
    DEFAULT TABLESPACE USERS
    QUOTA 50M ON USERS;

GRANT CREATE SESSION TO SEKRETARIAT;
GRANT ROLA_SEKRETARIAT TO SEKRETARIAT;

-- NAUCZYCIEL - nauczyciel szkoly
CREATE USER NAUCZYCIEL IDENTIFIED BY nauczyciel123
    DEFAULT TABLESPACE USERS
    QUOTA 10M ON USERS;

GRANT CREATE SESSION TO NAUCZYCIEL;
GRANT ROLA_NAUCZYCIEL TO NAUCZYCIEL;

-- UCZEN - uczen/rodzic (tylko odczyt)
CREATE USER UCZEN IDENTIFIED BY uczen123
    DEFAULT TABLESPACE USERS
    QUOTA 5M ON USERS;

GRANT CREATE SESSION TO UCZEN;
GRANT ROLA_UCZEN TO UCZEN;

-- ============================================================================
-- 5. INFORMACJA O POLACZENIU
-- ============================================================================

-- LOGOWANIE DZIAŁA - POTWIERDZONE 01.02.2026
--
-- Po wykonaniu tego skryptu:
--
-- 1. Polacz sie jako SM_ADMIN: SM_ADMIN / sm_admin123
--    - Upewnij się, że Role jest ustawiona na DEFAULT (nie SYSDBA)
--    - Service name: PDB
--
-- 2. Nastepnie wykonaj skrypt 06_uzytkownicy.sql jako SYS/SYSTEM
--
-- 3. Uzytkownicy koncowi loguja sie jako:
--    - ADMIN / admin123              (administrator - pelny dostep)
--    - SEKRETARIAT / sekretariat123  (sekretariat - zarzadzanie)
--    - NAUCZYCIEL / nauczyciel123    (nauczyciel - oceny)
--    - UCZEN / uczen123              (uczen - tylko odczyt)

SELECT 'Schemat SM_ADMIN i uzytkownicy utworzeni pomyslnie!' AS status FROM DUAL;

-- Lista utworzonych uzytkownikow
SELECT username, account_status, default_tablespace
FROM dba_users
WHERE username IN ('SM_ADMIN', 'ADMIN', 'SEKRETARIAT', 'NAUCZYCIEL', 'UCZEN')
ORDER BY username;
