-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 07_uzytkownicy.sql
-- Opis: Uzytkownicy, role i uprawnienia
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- ============================================================================
-- CZYSZCZENIE (opcjonalne)
-- ============================================================================
BEGIN
    FOR rec IN (SELECT username FROM dba_users 
                WHERE username IN ('USR_ADMIN','USR_SEKRETARIAT','USR_NAUCZYCIEL'))
    LOOP
        EXECUTE IMMEDIATE 'DROP USER ' || rec.username || ' CASCADE';
    END LOOP;
END;
/

BEGIN
    FOR rec IN (SELECT role FROM dba_roles 
                WHERE role IN ('ROLA_ADMIN','ROLA_SEKRETARIAT','ROLA_NAUCZYCIEL'))
    LOOP
        EXECUTE IMMEDIATE 'DROP ROLE ' || rec.role;
    END LOOP;
END;
/

-- ============================================================================
-- ROLE
-- ============================================================================
CREATE ROLE rola_admin;
CREATE ROLE rola_sekretariat;
CREATE ROLE rola_nauczyciel;

-- ============================================================================
-- UPRAWNIENIA DLA ROLI: ADMIN (pelne uprawnienia)
-- ============================================================================
GRANT SELECT, INSERT, UPDATE, DELETE ON t_instrument TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_sala TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_nauczyciel TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_uczen TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_kurs TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_lekcja TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON t_ocena TO rola_admin;

GRANT EXECUTE ON pkg_uczen TO rola_admin;
GRANT EXECUTE ON pkg_lekcja TO rola_admin;
GRANT EXECUTE ON pkg_ocena TO rola_admin;

GRANT SELECT ON seq_instrument TO rola_admin;
GRANT SELECT ON seq_sala TO rola_admin;
GRANT SELECT ON seq_nauczyciel TO rola_admin;
GRANT SELECT ON seq_uczen TO rola_admin;
GRANT SELECT ON seq_kurs TO rola_admin;
GRANT SELECT ON seq_lekcja TO rola_admin;
GRANT SELECT ON seq_ocena TO rola_admin;

-- ============================================================================
-- UPRAWNIENIA DLA ROLI: SEKRETARIAT
-- ============================================================================
GRANT SELECT ON t_instrument TO rola_sekretariat;
GRANT SELECT ON t_sala TO rola_sekretariat;
GRANT SELECT ON t_nauczyciel TO rola_sekretariat;
GRANT SELECT, INSERT, UPDATE ON t_uczen TO rola_sekretariat;
GRANT SELECT ON t_kurs TO rola_sekretariat;
GRANT SELECT, INSERT, UPDATE ON t_lekcja TO rola_sekretariat;
GRANT SELECT ON t_ocena TO rola_sekretariat;

GRANT EXECUTE ON pkg_uczen TO rola_sekretariat;
GRANT EXECUTE ON pkg_lekcja TO rola_sekretariat;

GRANT SELECT ON seq_uczen TO rola_sekretariat;
GRANT SELECT ON seq_lekcja TO rola_sekretariat;

-- ============================================================================
-- UPRAWNIENIA DLA ROLI: NAUCZYCIEL
-- ============================================================================
GRANT SELECT ON t_instrument TO rola_nauczyciel;
GRANT SELECT ON t_sala TO rola_nauczyciel;
GRANT SELECT ON t_nauczyciel TO rola_nauczyciel;
GRANT SELECT ON t_uczen TO rola_nauczyciel;
GRANT SELECT ON t_kurs TO rola_nauczyciel;
GRANT SELECT, UPDATE ON t_lekcja TO rola_nauczyciel;
GRANT SELECT, INSERT ON t_ocena TO rola_nauczyciel;

GRANT EXECUTE ON pkg_uczen TO rola_nauczyciel;
GRANT EXECUTE ON pkg_lekcja TO rola_nauczyciel;
GRANT EXECUTE ON pkg_ocena TO rola_nauczyciel;

GRANT SELECT ON seq_ocena TO rola_nauczyciel;

-- ============================================================================
-- UZYTKOWNICY
-- ============================================================================
CREATE USER usr_admin IDENTIFIED BY "Admin123!";
CREATE USER usr_sekretariat IDENTIFIED BY "Sekr123!";
CREATE USER usr_nauczyciel IDENTIFIED BY "Naucz123!";

-- Podstawowe uprawnienia
GRANT CREATE SESSION TO usr_admin;
GRANT CREATE SESSION TO usr_sekretariat;
GRANT CREATE SESSION TO usr_nauczyciel;

-- Przypisanie rol
GRANT rola_admin TO usr_admin;
GRANT rola_sekretariat TO usr_sekretariat;
GRANT rola_nauczyciel TO usr_nauczyciel;

-- ============================================================================
-- WERYFIKACJA
-- ============================================================================
PROMPT
PROMPT === ROLE ===
SELECT role FROM dba_roles 
WHERE role IN ('ROLA_ADMIN','ROLA_SEKRETARIAT','ROLA_NAUCZYCIEL');

PROMPT
PROMPT === UZYTKOWNICY ===
SELECT username, created FROM dba_users 
WHERE username IN ('USR_ADMIN','USR_SEKRETARIAT','USR_NAUCZYCIEL');

PROMPT
PROMPT === UPRAWNIENIA ADMIN ===
SELECT table_name, privilege FROM dba_tab_privs 
WHERE grantee = 'ROLA_ADMIN' ORDER BY table_name;

PROMPT
PROMPT Uzytkownicy i role zostaly utworzone.
PROMPT Logowanie:
PROMPT   sqlplus usr_admin/Admin123!
PROMPT   sqlplus usr_sekretariat/Sekr123!
PROMPT   sqlplus usr_nauczyciel/Naucz123!
