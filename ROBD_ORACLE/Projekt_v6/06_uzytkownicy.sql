-- ============================================================================
-- Projekt: Szkola Muzyczna - Obiektowa Baza Danych
-- Plik: 06_uzytkownicy.sql
-- Opis: Tworzenie uzytkownikow i przydzial uprawnien (role)
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

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
GRANT SELECT, INSERT, UPDATE, DELETE ON INSTRUMENTY TO rola_dyrektor;
GRANT SELECT, INSERT, UPDATE, DELETE ON PRZEDMIOTY TO rola_dyrektor;
GRANT SELECT, INSERT, UPDATE, DELETE ON NAUCZYCIELE TO rola_dyrektor;
GRANT SELECT, INSERT, UPDATE, DELETE ON GRUPY TO rola_dyrektor;
GRANT SELECT, INSERT, UPDATE, DELETE ON SALE TO rola_dyrektor;
GRANT SELECT, INSERT, UPDATE, DELETE ON UCZNIOWIE TO rola_dyrektor;
GRANT SELECT, INSERT, UPDATE, DELETE ON LEKCJE TO rola_dyrektor;
GRANT SELECT, INSERT, UPDATE, DELETE ON OCENY TO rola_dyrektor;

-- Pakiety
GRANT EXECUTE ON PKG_SLOWNIKI TO rola_dyrektor;
GRANT EXECUTE ON PKG_OSOBY TO rola_dyrektor;
GRANT EXECUTE ON PKG_LEKCJE TO rola_dyrektor;
GRANT EXECUTE ON PKG_OCENY TO rola_dyrektor;
GRANT EXECUTE ON PKG_RAPORTY TO rola_dyrektor;

-- ----- ROLA_NAUCZYCIEL (ograniczony) -----
GRANT SELECT ON INSTRUMENTY TO rola_nauczyciel;
GRANT SELECT ON PRZEDMIOTY TO rola_nauczyciel;
GRANT SELECT ON NAUCZYCIELE TO rola_nauczyciel;
GRANT SELECT ON GRUPY TO rola_nauczyciel;
GRANT SELECT ON SALE TO rola_nauczyciel;
GRANT SELECT ON UCZNIOWIE TO rola_nauczyciel;
GRANT SELECT ON LEKCJE TO rola_nauczyciel;
GRANT SELECT, INSERT ON OCENY TO rola_nauczyciel;

-- Pakiety dla nauczyciela
GRANT EXECUTE ON PKG_OCENY TO rola_nauczyciel;
GRANT EXECUTE ON PKG_RAPORTY TO rola_nauczyciel;

-- ----- ROLA_SEKRETARIAT (administracja) -----
GRANT SELECT ON INSTRUMENTY TO rola_sekretariat;
GRANT SELECT ON PRZEDMIOTY TO rola_sekretariat;
GRANT SELECT ON NAUCZYCIELE TO rola_sekretariat;
GRANT SELECT ON GRUPY TO rola_sekretariat;
GRANT SELECT ON SALE TO rola_sekretariat;
GRANT SELECT, INSERT, UPDATE ON UCZNIOWIE TO rola_sekretariat;
GRANT SELECT, INSERT, UPDATE ON LEKCJE TO rola_sekretariat;
GRANT SELECT ON OCENY TO rola_sekretariat;

-- Pakiety dla sekretariatu
GRANT EXECUTE ON PKG_OSOBY TO rola_sekretariat;
GRANT EXECUTE ON PKG_LEKCJE TO rola_sekretariat;
GRANT EXECUTE ON PKG_RAPORTY TO rola_sekretariat;

-- ----- ROLA_RAPORT (tylko odczyt) -----
GRANT SELECT ON INSTRUMENTY TO rola_raport;
GRANT SELECT ON PRZEDMIOTY TO rola_raport;
GRANT SELECT ON NAUCZYCIELE TO rola_raport;
GRANT SELECT ON GRUPY TO rola_raport;
GRANT SELECT ON SALE TO rola_raport;
GRANT SELECT ON UCZNIOWIE TO rola_raport;
GRANT SELECT ON LEKCJE TO rola_raport;
GRANT SELECT ON OCENY TO rola_raport;

GRANT EXECUTE ON PKG_RAPORTY TO rola_raport;

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
