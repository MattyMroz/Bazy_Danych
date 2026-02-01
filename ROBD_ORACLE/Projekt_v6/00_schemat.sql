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
BEGIN EXECUTE IMMEDIATE 'DROP USER sm_admin CASCADE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1918 THEN RAISE; END IF; END;
/

-- Uzytkownicy dostepu
BEGIN EXECUTE IMMEDIATE 'DROP USER admin CASCADE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1918 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP USER sekretariat CASCADE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1918 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP USER nauczyciel CASCADE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1918 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP USER uczen CASCADE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1918 THEN RAISE; END IF; END;
/

-- Role
BEGIN EXECUTE IMMEDIATE 'DROP ROLE rola_admin'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP ROLE rola_sekretariat'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP ROLE rola_nauczyciel'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP ROLE rola_uczen'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ============================================================================
-- 2. TWORZENIE SCHEMATU GLOWNEGO (SM_ADMIN)
-- ============================================================================
-- sm_admin = "School Music Admin" - wlasciciel wszystkich obiektow bazy
-- Ten uzytkownik nie jest przeznaczony do codziennej pracy - tylko do tworzenia obiektow

CREATE USER sm_admin IDENTIFIED BY sm_admin123
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON USERS;

-- Uprawnienia do tworzenia obiektow
GRANT CONNECT, RESOURCE TO sm_admin;
GRANT CREATE SESSION TO sm_admin;
GRANT CREATE TABLE TO sm_admin;
GRANT CREATE VIEW TO sm_admin;
GRANT CREATE PROCEDURE TO sm_admin;
GRANT CREATE TRIGGER TO sm_admin;
GRANT CREATE TYPE TO sm_admin;
GRANT CREATE SEQUENCE TO sm_admin;
GRANT DEBUG CONNECT SESSION TO sm_admin;

-- ============================================================================
-- 3. TWORZENIE ROL
-- ============================================================================

-- ROLA_ADMIN - pelny dostep (administrator systemu)
CREATE ROLE rola_admin;

-- ROLA_SEKRETARIAT - zarzadzanie uczniami i lekcjami
CREATE ROLE rola_sekretariat;

-- ROLA_NAUCZYCIEL - odczyt danych + wystawianie ocen
CREATE ROLE rola_nauczyciel;

-- ROLA_UCZEN - tylko odczyt swoich danych
CREATE ROLE rola_uczen;

-- ============================================================================
-- 4. TWORZENIE UZYTKOWNIKOW DOSTEPU
-- ============================================================================

-- ADMIN - administrator systemu (pelny dostep)
CREATE USER admin IDENTIFIED BY admin123
    DEFAULT TABLESPACE USERS
    QUOTA UNLIMITED ON USERS;

GRANT CREATE SESSION TO admin;
GRANT rola_admin TO admin;

-- SEKRETARIAT - pracownik sekretariatu
CREATE USER sekretariat IDENTIFIED BY sekretariat123
    DEFAULT TABLESPACE USERS
    QUOTA 50M ON USERS;

GRANT CREATE SESSION TO sekretariat;
GRANT rola_sekretariat TO sekretariat;

-- NAUCZYCIEL - nauczyciel szkoly
CREATE USER nauczyciel IDENTIFIED BY nauczyciel123
    DEFAULT TABLESPACE USERS
    QUOTA 10M ON USERS;

GRANT CREATE SESSION TO nauczyciel;
GRANT rola_nauczyciel TO nauczyciel;

-- UCZEN - uczen/rodzic (tylko odczyt)
CREATE USER uczen IDENTIFIED BY uczen123
    DEFAULT TABLESPACE USERS
    QUOTA 5M ON USERS;

GRANT CREATE SESSION TO uczen;
GRANT rola_uczen TO uczen;

-- ============================================================================
-- 5. INFORMACJA O POLACZENIU
-- ============================================================================

-- Po wykonaniu tego skryptu:
--
-- 1. Polacz sie jako sm_admin: sm_admin / sm_admin123
--
-- 2. Nastepnie wykonaj skrypt 06_uzytkownicy.sql jako SYS/SYSTEM
--
-- 3. Uzytkownicy koncowi loguja sie jako:
--    - admin / admin123         (administrator - pelny dostep)
--    - sekretariat / sekretariat123  (sekretariat - zarzadzanie)
--    - nauczyciel / nauczyciel123    (nauczyciel - oceny)
--    - uczen / uczen123              (uczen - tylko odczyt)

SELECT 'Schemat sm_admin i uzytkownicy utworzeni pomyslnie!' AS status FROM DUAL;

-- Lista utworzonych uzytkownikow
SELECT username, account_status, default_tablespace
FROM dba_users
WHERE username IN ('SM_ADMIN', 'ADMIN', 'SEKRETARIAT', 'NAUCZYCIEL', 'UCZEN')
ORDER BY username;
