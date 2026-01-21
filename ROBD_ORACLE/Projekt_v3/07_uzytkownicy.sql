-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 07_uzytkownicy.sql
-- Opis: Role, uzytkownicy i uprawnienia
-- Wersja: 3.0 (uproszczona)
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- ============================================================================
-- UWAGA: Ten skrypt wymaga uprawnien DBA
-- Wykonaj jako uzytkownik SYSTEM lub z uprawnieniami GRANT OPTION
-- ============================================================================

-- ============================================================================
-- 1. USUNIECIE ISTNIEJACYCH OBIEKTOW (opcjonalne)
-- ============================================================================

-- Usuniecie uzytkownikow (jesli istnieja)
BEGIN EXECUTE IMMEDIATE 'DROP USER usr_admin CASCADE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP USER usr_nauczyciel CASCADE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP USER usr_sekretariat CASCADE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- Usuniecie rol (jesli istnieja)
BEGIN EXECUTE IMMEDIATE 'DROP ROLE rola_admin'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP ROLE rola_nauczyciel'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP ROLE rola_sekretariat'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ============================================================================
-- 2. DEFINICJA ROL
-- ============================================================================

-- -----------------------------------------------------------------------------
-- ROLA: ADMIN
-- Pelny dostep do wszystkich obiektow
-- -----------------------------------------------------------------------------
CREATE ROLE rola_admin;

-- Uprawnienia do tabel
GRANT SELECT, INSERT, UPDATE, DELETE ON t_instrument TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_sala TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_nauczyciel TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_uczen TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_kurs TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_lekcja TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_ocena_postepu TO rola_admin;

-- Uprawnienia do sekwencji
GRANT SELECT ON seq_instrument TO rola_admin;
GRANT SELECT ON seq_sala TO rola_admin;
GRANT SELECT ON seq_nauczyciel TO rola_admin;
GRANT SELECT ON seq_uczen TO rola_admin;
GRANT SELECT ON seq_kurs TO rola_admin;
GRANT SELECT ON seq_lekcja TO rola_admin;
GRANT SELECT ON seq_ocena TO rola_admin;

-- Uprawnienia do pakietow
GRANT EXECUTE ON pkg_uczen TO rola_admin;
GRANT EXECUTE ON pkg_lekcja TO rola_admin;
GRANT EXECUTE ON pkg_ocena TO rola_admin;

-- -----------------------------------------------------------------------------
-- ROLA: NAUCZYCIEL
-- Odczyt danych, zarzadzanie swoimi lekcjami i ocenami
-- -----------------------------------------------------------------------------
CREATE ROLE rola_nauczyciel;

-- Odczyt wszystkich tabel
GRANT SELECT ON t_instrument TO rola_nauczyciel;
GRANT SELECT ON t_sala TO rola_nauczyciel;
GRANT SELECT ON t_nauczyciel TO rola_nauczyciel;
GRANT SELECT ON t_uczen TO rola_nauczyciel;
GRANT SELECT ON t_kurs TO rola_nauczyciel;
GRANT SELECT ON t_lekcja TO rola_nauczyciel;
GRANT SELECT ON t_ocena_postepu TO rola_nauczyciel;

-- Modyfikacja lekcji (tylko UPDATE statusu)
GRANT UPDATE (status) ON t_lekcja TO rola_nauczyciel;

-- Dodawanie ocen
GRANT INSERT ON t_ocena_postepu TO rola_nauczyciel;
GRANT SELECT ON seq_ocena TO rola_nauczyciel;

-- Pakiety
GRANT EXECUTE ON pkg_uczen TO rola_nauczyciel;
GRANT EXECUTE ON pkg_lekcja TO rola_nauczyciel;
GRANT EXECUTE ON pkg_ocena TO rola_nauczyciel;

-- -----------------------------------------------------------------------------
-- ROLA: SEKRETARIAT
-- Zarzadzanie uczniami i lekcjami (bez ocen)
-- -----------------------------------------------------------------------------
CREATE ROLE rola_sekretariat;

-- Odczyt wszystkich tabel
GRANT SELECT ON t_instrument TO rola_sekretariat;
GRANT SELECT ON t_sala TO rola_sekretariat;
GRANT SELECT ON t_nauczyciel TO rola_sekretariat;
GRANT SELECT ON t_uczen TO rola_sekretariat;
GRANT SELECT ON t_kurs TO rola_sekretariat;
GRANT SELECT ON t_lekcja TO rola_sekretariat;
GRANT SELECT ON t_ocena_postepu TO rola_sekretariat;

-- Zarzadzanie uczniami
GRANT INSERT, UPDATE ON t_uczen TO rola_sekretariat;
GRANT SELECT ON seq_uczen TO rola_sekretariat;

-- Zarzadzanie lekcjami
GRANT INSERT, UPDATE ON t_lekcja TO rola_sekretariat;
GRANT SELECT ON seq_lekcja TO rola_sekretariat;

-- Pakiety (bez pkg_ocena)
GRANT EXECUTE ON pkg_uczen TO rola_sekretariat;
GRANT EXECUTE ON pkg_lekcja TO rola_sekretariat;

-- ============================================================================
-- 3. TWORZENIE UZYTKOWNIKOW
-- ============================================================================

-- -----------------------------------------------------------------------------
-- UZYTKOWNIK: usr_admin
-- Administrator systemu
-- -----------------------------------------------------------------------------
CREATE USER usr_admin IDENTIFIED BY Admin123!
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON USERS;

GRANT CREATE SESSION TO usr_admin;
GRANT rola_admin TO usr_admin;

-- -----------------------------------------------------------------------------
-- UZYTKOWNIK: usr_nauczyciel
-- Przykladowy nauczyciel
-- -----------------------------------------------------------------------------
CREATE USER usr_nauczyciel IDENTIFIED BY Naucz123!
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA 10M ON USERS;

GRANT CREATE SESSION TO usr_nauczyciel;
GRANT rola_nauczyciel TO usr_nauczyciel;

-- -----------------------------------------------------------------------------
-- UZYTKOWNIK: usr_sekretariat
-- Pracownik sekretariatu
-- -----------------------------------------------------------------------------
CREATE USER usr_sekretariat IDENTIFIED BY Sekr123!
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA 10M ON USERS;

GRANT CREATE SESSION TO usr_sekretariat;
GRANT rola_sekretariat TO usr_sekretariat;

-- ============================================================================
-- 4. SYNONIMY PUBLICZNE (opcjonalne - ulatwia dostep)
-- ============================================================================

-- Synonimy dla tabel (jesli nie istnieja)
BEGIN EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM instrument FOR t_instrument'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM sala FOR t_sala'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM nauczyciel FOR t_nauczyciel'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM uczen FOR t_uczen'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM kurs FOR t_kurs'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM lekcja FOR t_lekcja'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM ocena FOR t_ocena_postepu'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ============================================================================
-- 5. PODSUMOWANIE UPRAWNIEN
-- ============================================================================

/*
PODSUMOWANIE ROL I UPRAWNIEN:

+------------------+--------+---------+---------+
| Obiekt           | ADMIN  | NAUCZ.  | SEKR.   |
+------------------+--------+---------+---------+
| t_instrument     | SIUD   | S       | S       |
| t_sala           | SIUD   | S       | S       |
| t_nauczyciel     | SIUD   | S       | S       |
| t_uczen          | SIUD   | S       | SIU     |
| t_kurs           | SIUD   | S       | S       |
| t_lekcja         | SIUD   | SU(*)   | SIU     |
| t_ocena_postepu  | SIUD   | SI      | S       |
+------------------+--------+---------+---------+
| pkg_uczen        | EXEC   | EXEC    | EXEC    |
| pkg_lekcja       | EXEC   | EXEC    | EXEC    |
| pkg_ocena        | EXEC   | EXEC    | -       |
+------------------+--------+---------+---------+

Legenda:
S - SELECT
I - INSERT
U - UPDATE
D - DELETE
(*) - UPDATE tylko kolumny status

UZYTKOWNICY:
- usr_admin      -> rola_admin       -> pelny dostep
- usr_nauczyciel -> rola_nauczyciel  -> prowadzenie lekcji, wystawianie ocen
- usr_sekretariat -> rola_sekretariat -> rejestracja uczniow, planowanie lekcji

HASLA TESTOWE:
- usr_admin:      Admin123!
- usr_nauczyciel: Naucz123!
- usr_sekretariat: Sekr123!
*/

-- ============================================================================
-- 6. WERYFIKACJA (wykonaj jako wlasciciel schematu)
-- ============================================================================

SELECT 'Role utworzone:' AS info FROM dual;
SELECT role FROM dba_roles WHERE role LIKE 'ROLA_%';

SELECT 'Uzytkownicy utworzeni:' AS info FROM dual;
SELECT username, account_status FROM dba_users WHERE username LIKE 'USR_%';
