-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 07_uzytkownicy.sql
-- Opis: Role i uzytkownicy bazy danych
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- UWAGA: Ten skrypt wymaga uprawnien DBA/SYSDBA
-- Uruchom jako uzytkownik z uprawnieniami administratora

-- ============================================================================
-- CZYSZCZENIE (usuwanie istniejacych rol i uzytkownikow)
-- ============================================================================

-- Usuwanie uzytkownikow
BEGIN EXECUTE IMMEDIATE 'DROP USER usr_admin CASCADE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP USER usr_nauczyciel CASCADE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP USER usr_sekretariat CASCADE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- Usuwanie rol
BEGIN EXECUTE IMMEDIATE 'DROP ROLE rola_admin'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP ROLE rola_nauczyciel'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP ROLE rola_sekretariat'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ============================================================================
-- 1. ROLA: ROLA_ADMIN
-- Opis: Pelne uprawnienia do wszystkich obiektow
-- ============================================================================
CREATE ROLE rola_admin;

-- Uprawnienia do tabel (wszystkie operacje)
GRANT SELECT, INSERT, UPDATE, DELETE ON t_instrument TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_nauczyciel TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_uczen TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_kurs TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_lekcja TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_ocena_postepu TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_audit_log TO rola_admin;

-- Uprawnienia do sekwencji
GRANT SELECT ON seq_instrument TO rola_admin;
GRANT SELECT ON seq_nauczyciel TO rola_admin;
GRANT SELECT ON seq_uczen TO rola_admin;
GRANT SELECT ON seq_kurs TO rola_admin;
GRANT SELECT ON seq_lekcja TO rola_admin;
GRANT SELECT ON seq_ocena TO rola_admin;
GRANT SELECT ON seq_audit_log TO rola_admin;

-- Uprawnienia do pakietow
GRANT EXECUTE ON pkg_uczen TO rola_admin;
GRANT EXECUTE ON pkg_lekcja TO rola_admin;
GRANT EXECUTE ON pkg_ocena TO rola_admin;

-- Uprawnienia do widokow
GRANT SELECT ON v_audit_ostatnie TO rola_admin;

PROMPT Utworzono role: ROLA_ADMIN;

-- ============================================================================
-- 2. ROLA: ROLA_NAUCZYCIEL
-- Opis: Uprawnienia do prowadzenia lekcji i oceniania
-- ============================================================================
CREATE ROLE rola_nauczyciel;

-- Uprawnienia do odczytu (wszystkie tabele bazowe)
GRANT SELECT ON t_instrument TO rola_nauczyciel;
GRANT SELECT ON t_nauczyciel TO rola_nauczyciel;
GRANT SELECT ON t_uczen TO rola_nauczyciel;
GRANT SELECT ON t_kurs TO rola_nauczyciel;

-- Uprawnienia do lekcji (odczyt + aktualizacja statusu/tematu/uwag)
GRANT SELECT ON t_lekcja TO rola_nauczyciel;
GRANT UPDATE (status, temat, uwagi) ON t_lekcja TO rola_nauczyciel;

-- Uprawnienia do ocen (pelne)
GRANT SELECT, INSERT ON t_ocena_postepu TO rola_nauczyciel;
GRANT SELECT ON seq_ocena TO rola_nauczyciel;

-- Uprawnienia do pakietow (tylko wybrane)
GRANT EXECUTE ON pkg_ocena TO rola_nauczyciel;
-- Nauczyciel moze wywolac raport_dzienny i oznacz_odbyta
GRANT EXECUTE ON pkg_lekcja TO rola_nauczyciel;

PROMPT Utworzono role: ROLA_NAUCZYCIEL;

-- ============================================================================
-- 3. ROLA: ROLA_SEKRETARIAT
-- Opis: Uprawnienia do zarzadzania uczniami i harmonogramem
-- ============================================================================
CREATE ROLE rola_sekretariat;

-- Uprawnienia do odczytu
GRANT SELECT ON t_instrument TO rola_sekretariat;
GRANT SELECT ON t_nauczyciel TO rola_sekretariat;
GRANT SELECT ON t_kurs TO rola_sekretariat;
GRANT SELECT ON t_ocena_postepu TO rola_sekretariat;

-- Uprawnienia do uczniow (pelne)
GRANT SELECT, INSERT, UPDATE, DELETE ON t_uczen TO rola_sekretariat;
GRANT SELECT ON seq_uczen TO rola_sekretariat;

-- Uprawnienia do lekcji (pelne - planowanie harmonogramu)
GRANT SELECT, INSERT, UPDATE, DELETE ON t_lekcja TO rola_sekretariat;
GRANT SELECT ON seq_lekcja TO rola_sekretariat;

-- Uprawnienia do pakietow
GRANT EXECUTE ON pkg_uczen TO rola_sekretariat;
GRANT EXECUTE ON pkg_lekcja TO rola_sekretariat;

PROMPT Utworzono role: ROLA_SEKRETARIAT;

-- ============================================================================
-- 4. UZYTKOWNICY PRZYKLADOWI
-- ============================================================================

-- Uzytkownik: Administrator
CREATE USER usr_admin IDENTIFIED BY Admin123#
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON USERS;

GRANT CREATE SESSION TO usr_admin;
GRANT rola_admin TO usr_admin;

PROMPT Utworzono uzytkownika: USR_ADMIN;

-- Uzytkownik: Nauczyciel
CREATE USER usr_nauczyciel IDENTIFIED BY Naucz123#
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA 10M ON USERS;

GRANT CREATE SESSION TO usr_nauczyciel;
GRANT rola_nauczyciel TO usr_nauczyciel;

PROMPT Utworzono uzytkownika: USR_NAUCZYCIEL;

-- Uzytkownik: Sekretariat
CREATE USER usr_sekretariat IDENTIFIED BY Sekr123#
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA 50M ON USERS;

GRANT CREATE SESSION TO usr_sekretariat;
GRANT rola_sekretariat TO usr_sekretariat;

PROMPT Utworzono uzytkownika: USR_SEKRETARIAT;

-- ============================================================================
-- 5. SYNONIMY (dla latwiejszego dostepu)
-- ============================================================================

-- Synonimy dla nauczyciela
CREATE OR REPLACE PUBLIC SYNONYM uczniowie FOR t_uczen;
CREATE OR REPLACE PUBLIC SYNONYM lekcje FOR t_lekcja;
CREATE OR REPLACE PUBLIC SYNONYM oceny FOR t_ocena_postepu;
CREATE OR REPLACE PUBLIC SYNONYM kursy FOR t_kurs;

PROMPT Utworzono synonimy publiczne;

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================
/*
Utworzono 3 role:

1. ROLA_ADMIN
   - Pelne uprawnienia do wszystkich tabel
   - Dostep do wszystkich sekwencji
   - Wykonywanie wszystkich pakietow
   - Dostep do logow audytowych

2. ROLA_NAUCZYCIEL
   - Odczyt tabel bazowych (instrument, nauczyciel, uczen, kurs)
   - Odczyt lekcji + aktualizacja statusu/tematu
   - Pelny dostep do ocen (SELECT, INSERT)
   - Pakiety: pkg_ocena, pkg_lekcja

3. ROLA_SEKRETARIAT
   - Pelne uprawnienia do uczniow i lekcji
   - Odczyt pozostalych tabel
   - Pakiety: pkg_uczen, pkg_lekcja

Uzytkownicy:
- usr_admin      (haslo: Admin123#)     -> rola_admin
- usr_nauczyciel (haslo: Naucz123#)     -> rola_nauczyciel
- usr_sekretariat (haslo: Sekr123#)     -> rola_sekretariat
*/

PROMPT ;
PROMPT ========================================;
PROMPT Role i uzytkownicy utworzeni pomyslnie!;
PROMPT ========================================;

-- ============================================================================
-- WERYFIKACJA UPRAWNIEN
-- ============================================================================
PROMPT ;
PROMPT Przypisane role:;
SELECT grantee, granted_role 
FROM dba_role_privs 
WHERE grantee IN ('USR_ADMIN', 'USR_NAUCZYCIEL', 'USR_SEKRETARIAT');
