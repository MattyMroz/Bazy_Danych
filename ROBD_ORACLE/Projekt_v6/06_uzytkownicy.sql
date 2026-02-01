-- ============================================================================
-- Projekt: Szkola Muzyczna - Obiektowa Baza Danych
-- Plik: 06_uzytkownicy.sql
-- Opis: Tworzenie uzytkownikow i przydzial uprawnien (role)
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- UWAGA: Ten skrypt nalezy uruchomic jako SYS lub SYSTEM (nie jako szkola_muzyczna!)
-- Uzytkownik szkola_muzyczna nie ma uprawnien do tworzenia innych uzytkownikow.

-- ============================================================================
-- 1. USUWANIE ISTNIEJACYCH UZYTKOWNIKOW I ROL
-- ============================================================================

-- Role
BEGIN EXECUTE IMMEDIATE 'DROP ROLE rola_dyrektor'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP ROLE rola_nauczyciel'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP ROLE rola_sekretariat'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP ROLE rola_raport'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- Uzytkownicy
BEGIN EXECUTE IMMEDIATE 'DROP USER dyrektor CASCADE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP USER nauczyciel1 CASCADE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP USER sekretariat CASCADE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ============================================================================
-- 2. TWORZENIE ROL
-- ============================================================================

-- Rola: DYREKTOR - pelny dostep
CREATE ROLE rola_dyrektor;

-- Rola: NAUCZYCIEL - odczyt i wystawianie ocen
CREATE ROLE rola_nauczyciel;

-- Rola: SEKRETARIAT - zarzadzanie uczniami i lekcjami
CREATE ROLE rola_sekretariat;

-- Rola: RAPORT - tylko odczyt raportow
CREATE ROLE rola_raport;

-- ============================================================================
-- 3. PRZYDZIAL UPRAWNIEN DO ROL
-- ============================================================================

-- ----- ROLA_DYREKTOR (wszystko) -----
GRANT SELECT, INSERT, UPDATE, DELETE ON szkola_muzyczna.INSTRUMENTY TO rola_dyrektor;
GRANT SELECT, INSERT, UPDATE, DELETE ON szkola_muzyczna.PRZEDMIOTY TO rola_dyrektor;
GRANT SELECT, INSERT, UPDATE, DELETE ON szkola_muzyczna.NAUCZYCIELE TO rola_dyrektor;
GRANT SELECT, INSERT, UPDATE, DELETE ON szkola_muzyczna.GRUPY TO rola_dyrektor;
GRANT SELECT, INSERT, UPDATE, DELETE ON szkola_muzyczna.SALE TO rola_dyrektor;
GRANT SELECT, INSERT, UPDATE, DELETE ON szkola_muzyczna.UCZNIOWIE TO rola_dyrektor;
GRANT SELECT, INSERT, UPDATE, DELETE ON szkola_muzyczna.LEKCJE TO rola_dyrektor;
GRANT SELECT, INSERT, UPDATE, DELETE ON szkola_muzyczna.OCENY TO rola_dyrektor;

-- Sekwencje (potrzebne do INSERT przez pakiety)
GRANT SELECT ON szkola_muzyczna.seq_instrumenty TO rola_dyrektor;
GRANT SELECT ON szkola_muzyczna.seq_przedmioty TO rola_dyrektor;
GRANT SELECT ON szkola_muzyczna.seq_nauczyciele TO rola_dyrektor;
GRANT SELECT ON szkola_muzyczna.seq_grupy TO rola_dyrektor;
GRANT SELECT ON szkola_muzyczna.seq_sale TO rola_dyrektor;
GRANT SELECT ON szkola_muzyczna.seq_uczniowie TO rola_dyrektor;
GRANT SELECT ON szkola_muzyczna.seq_lekcje TO rola_dyrektor;
GRANT SELECT ON szkola_muzyczna.seq_oceny TO rola_dyrektor;

-- Pakiety
GRANT EXECUTE ON szkola_muzyczna.PKG_SLOWNIKI TO rola_dyrektor;
GRANT EXECUTE ON szkola_muzyczna.PKG_OSOBY TO rola_dyrektor;
GRANT EXECUTE ON szkola_muzyczna.PKG_LEKCJE TO rola_dyrektor;
GRANT EXECUTE ON szkola_muzyczna.PKG_OCENY TO rola_dyrektor;
GRANT EXECUTE ON szkola_muzyczna.PKG_RAPORTY TO rola_dyrektor;

-- ----- ROLA_NAUCZYCIEL (ograniczony) -----
GRANT SELECT ON szkola_muzyczna.INSTRUMENTY TO rola_nauczyciel;
GRANT SELECT ON szkola_muzyczna.PRZEDMIOTY TO rola_nauczyciel;
GRANT SELECT ON szkola_muzyczna.NAUCZYCIELE TO rola_nauczyciel;
GRANT SELECT ON szkola_muzyczna.GRUPY TO rola_nauczyciel;
GRANT SELECT ON szkola_muzyczna.SALE TO rola_nauczyciel;
GRANT SELECT ON szkola_muzyczna.UCZNIOWIE TO rola_nauczyciel;
GRANT SELECT ON szkola_muzyczna.LEKCJE TO rola_nauczyciel;
GRANT SELECT, INSERT ON szkola_muzyczna.OCENY TO rola_nauczyciel;
GRANT SELECT ON szkola_muzyczna.seq_oceny TO rola_nauczyciel;

-- Pakiety dla nauczyciela
GRANT EXECUTE ON szkola_muzyczna.PKG_OCENY TO rola_nauczyciel;
GRANT EXECUTE ON szkola_muzyczna.PKG_RAPORTY TO rola_nauczyciel;

-- ----- ROLA_SEKRETARIAT (administracja) -----
GRANT SELECT ON szkola_muzyczna.INSTRUMENTY TO rola_sekretariat;
GRANT SELECT ON szkola_muzyczna.PRZEDMIOTY TO rola_sekretariat;
GRANT SELECT ON szkola_muzyczna.NAUCZYCIELE TO rola_sekretariat;
GRANT SELECT ON szkola_muzyczna.GRUPY TO rola_sekretariat;
GRANT SELECT ON szkola_muzyczna.SALE TO rola_sekretariat;
GRANT SELECT, INSERT, UPDATE ON szkola_muzyczna.UCZNIOWIE TO rola_sekretariat;
GRANT SELECT, INSERT, UPDATE ON szkola_muzyczna.LEKCJE TO rola_sekretariat;
GRANT SELECT ON szkola_muzyczna.OCENY TO rola_sekretariat;
GRANT SELECT ON szkola_muzyczna.seq_uczniowie TO rola_sekretariat;
GRANT SELECT ON szkola_muzyczna.seq_lekcje TO rola_sekretariat;

-- Pakiety dla sekretariatu
GRANT EXECUTE ON szkola_muzyczna.PKG_OSOBY TO rola_sekretariat;
GRANT EXECUTE ON szkola_muzyczna.PKG_LEKCJE TO rola_sekretariat;
GRANT EXECUTE ON szkola_muzyczna.PKG_RAPORTY TO rola_sekretariat;

-- ----- ROLA_RAPORT (tylko odczyt) -----
GRANT SELECT ON szkola_muzyczna.INSTRUMENTY TO rola_raport;
GRANT SELECT ON szkola_muzyczna.PRZEDMIOTY TO rola_raport;
GRANT SELECT ON szkola_muzyczna.NAUCZYCIELE TO rola_raport;
GRANT SELECT ON szkola_muzyczna.GRUPY TO rola_raport;
GRANT SELECT ON szkola_muzyczna.SALE TO rola_raport;
GRANT SELECT ON szkola_muzyczna.UCZNIOWIE TO rola_raport;
GRANT SELECT ON szkola_muzyczna.LEKCJE TO rola_raport;
GRANT SELECT ON szkola_muzyczna.OCENY TO rola_raport;

GRANT EXECUTE ON szkola_muzyczna.PKG_RAPORTY TO rola_raport;

-- ============================================================================
-- 4. TWORZENIE UZYTKOWNIKOW
-- ============================================================================

-- Dyrektor
CREATE USER dyrektor IDENTIFIED BY dyrektor123
    DEFAULT TABLESPACE USERS
    QUOTA UNLIMITED ON USERS;

GRANT CREATE SESSION TO dyrektor;
GRANT rola_dyrektor TO dyrektor;

-- Nauczyciel (przykladowy)
CREATE USER nauczyciel1 IDENTIFIED BY nauczyciel123
    DEFAULT TABLESPACE USERS
    QUOTA 10M ON USERS;

GRANT CREATE SESSION TO nauczyciel1;
GRANT rola_nauczyciel TO nauczyciel1;

-- Sekretariat
CREATE USER sekretariat IDENTIFIED BY sekretariat123
    DEFAULT TABLESPACE USERS
    QUOTA 10M ON USERS;

GRANT CREATE SESSION TO sekretariat;
GRANT rola_sekretariat TO sekretariat;

-- ============================================================================
-- 5. SYNONIMY PUBLICZNE (aby uzytkownicy nie musieli pisac szkola_muzyczna.)
-- ============================================================================

-- Tabele
CREATE OR REPLACE PUBLIC SYNONYM INSTRUMENTY FOR szkola_muzyczna.INSTRUMENTY;
CREATE OR REPLACE PUBLIC SYNONYM PRZEDMIOTY FOR szkola_muzyczna.PRZEDMIOTY;
CREATE OR REPLACE PUBLIC SYNONYM NAUCZYCIELE FOR szkola_muzyczna.NAUCZYCIELE;
CREATE OR REPLACE PUBLIC SYNONYM GRUPY FOR szkola_muzyczna.GRUPY;
CREATE OR REPLACE PUBLIC SYNONYM SALE FOR szkola_muzyczna.SALE;
CREATE OR REPLACE PUBLIC SYNONYM UCZNIOWIE FOR szkola_muzyczna.UCZNIOWIE;
CREATE OR REPLACE PUBLIC SYNONYM LEKCJE FOR szkola_muzyczna.LEKCJE;
CREATE OR REPLACE PUBLIC SYNONYM OCENY FOR szkola_muzyczna.OCENY;

-- Sekwencje
CREATE OR REPLACE PUBLIC SYNONYM seq_instrumenty FOR szkola_muzyczna.seq_instrumenty;
CREATE OR REPLACE PUBLIC SYNONYM seq_przedmioty FOR szkola_muzyczna.seq_przedmioty;
CREATE OR REPLACE PUBLIC SYNONYM seq_nauczyciele FOR szkola_muzyczna.seq_nauczyciele;
CREATE OR REPLACE PUBLIC SYNONYM seq_grupy FOR szkola_muzyczna.seq_grupy;
CREATE OR REPLACE PUBLIC SYNONYM seq_sale FOR szkola_muzyczna.seq_sale;
CREATE OR REPLACE PUBLIC SYNONYM seq_uczniowie FOR szkola_muzyczna.seq_uczniowie;
CREATE OR REPLACE PUBLIC SYNONYM seq_lekcje FOR szkola_muzyczna.seq_lekcje;
CREATE OR REPLACE PUBLIC SYNONYM seq_oceny FOR szkola_muzyczna.seq_oceny;

-- Pakiety
CREATE OR REPLACE PUBLIC SYNONYM PKG_SLOWNIKI FOR szkola_muzyczna.PKG_SLOWNIKI;
CREATE OR REPLACE PUBLIC SYNONYM PKG_OSOBY FOR szkola_muzyczna.PKG_OSOBY;
CREATE OR REPLACE PUBLIC SYNONYM PKG_LEKCJE FOR szkola_muzyczna.PKG_LEKCJE;
CREATE OR REPLACE PUBLIC SYNONYM PKG_OCENY FOR szkola_muzyczna.PKG_OCENY;
CREATE OR REPLACE PUBLIC SYNONYM PKG_RAPORTY FOR szkola_muzyczna.PKG_RAPORTY;

-- ============================================================================
-- 6. POTWIERDZENIE
-- ============================================================================

SELECT 'Uzytkownicy i role utworzeni pomyslnie!' AS status FROM DUAL;

-- Lista uzytkownikow
SELECT username, account_status, created
FROM dba_users
WHERE username IN ('DYREKTOR', 'NAUCZYCIEL1', 'SEKRETARIAT');

-- Lista rol
SELECT role FROM dba_roles
WHERE role LIKE 'ROLA_%';
