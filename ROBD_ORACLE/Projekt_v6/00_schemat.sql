-- ============================================================================
-- Projekt: Szkola Muzyczna - Obiektowa Baza Danych
-- Plik: 00_schemat.sql
-- Opis: Tworzenie schematu/uzytkownika szkola_muzyczna
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- UWAGA: Ten skrypt nalezy uruchomic jako SYS lub SYSTEM

-- ============================================================================
-- 1. USUNIECIE STAREGO SCHEMATU (jesli istnieje)
-- ============================================================================

BEGIN
    EXECUTE IMMEDIATE 'DROP USER szkola_muzyczna CASCADE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -1918 THEN -- ORA-01918: user does not exist
            RAISE;
        END IF;
END;
/

-- ============================================================================
-- 2. TWORZENIE UZYTKOWNIKA I SCHEMATU
-- ============================================================================

CREATE USER szkola_muzyczna IDENTIFIED BY szkola123
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON USERS;

-- ============================================================================
-- 3. NADANIE UPRAWNIEN
-- ============================================================================

-- Podstawowe uprawnienia do pracy z baza
GRANT CONNECT, RESOURCE TO szkola_muzyczna;

-- Uprawnienia do tworzenia obiektow
GRANT CREATE SESSION TO szkola_muzyczna;
GRANT CREATE TABLE TO szkola_muzyczna;
GRANT CREATE VIEW TO szkola_muzyczna;
GRANT CREATE PROCEDURE TO szkola_muzyczna;
GRANT CREATE TRIGGER TO szkola_muzyczna;
GRANT CREATE TYPE TO szkola_muzyczna;
GRANT CREATE SEQUENCE TO szkola_muzyczna;

-- Uprawnienie do debugowania (opcjonalne)
GRANT DEBUG CONNECT SESSION TO szkola_muzyczna;

-- Uprawnienia do tworzenia synonimow publicznych i zarzadzania uzytkownikami
-- (potrzebne dla 06_uzytkownicy.sql)
GRANT CREATE PUBLIC SYNONYM TO szkola_muzyczna;
GRANT DROP PUBLIC SYNONYM TO szkola_muzyczna;
GRANT CREATE ROLE TO szkola_muzyczna;
GRANT CREATE USER TO szkola_muzyczna;
GRANT GRANT ANY ROLE TO szkola_muzyczna;

-- ============================================================================
-- 4. INFORMACJA O POLACZENIU
-- ============================================================================

-- Po wykonaniu tego skryptu polacz sie jako:
-- sqlplus szkola_muzyczna/szkola123@localhost:1521/XEPDB1
-- lub w SQL Developer: szkola_muzyczna / szkola123

SELECT 'Schemat szkola_muzyczna utworzony pomyslnie!' AS status FROM DUAL;
