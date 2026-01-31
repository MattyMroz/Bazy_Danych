-- ============================================================================
-- PLIK: 06_role.sql
-- PROJEKT: Szkola Muzyczna v5 - Obiektowa Baza Danych Oracle
-- AUTORZY: Igor Typinski (251237), Mateusz Mroz (251190)
-- DATA: Styczen 2026
-- ============================================================================
-- Definiuje 4 ROLE z uprawnieniami:
--   r_uczen - tylko odczyt swoich danych
--   r_nauczyciel - odczyt + modyfikacja lekcji/ocen
--   r_sekretariat - pelny CRUD na uczniach/grupach
--   r_administrator - pelne uprawnienia
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200
SET PAGESIZE 50

PROMPT ========================================================================
PROMPT   06_role.sql - Tworzenie rol i uprawnien
PROMPT ========================================================================
PROMPT

-- ============================================================================
-- 1. ROLA: R_UCZEN
-- Uczen widzi tylko swoje dane (widoki filtruja po kontekscie)
-- ============================================================================

PROMPT [1/4] Tworzenie roli r_uczen...

CREATE ROLE r_uczen;

-- Odczyt podstawowych tabel (slowniki)
GRANT SELECT ON semestry TO r_uczen;
GRANT SELECT ON instrumenty TO r_uczen;
GRANT SELECT ON przedmioty TO r_uczen;
GRANT SELECT ON grupy TO r_uczen;

-- ============================================================================
-- 2. ROLA: R_NAUCZYCIEL
-- Nauczyciel widzi dane + moze modyfikowac lekcje/oceny
-- ============================================================================

PROMPT [2/4] Tworzenie roli r_nauczyciel...

CREATE ROLE r_nauczyciel;

-- Dziedziczenie z r_uczen
GRANT r_uczen TO r_nauczyciel;

-- Dodatkowe odczyty
GRANT SELECT ON uczniowie TO r_nauczyciel;
GRANT SELECT ON nauczyciele TO r_nauczyciel;
GRANT SELECT ON sale TO r_nauczyciel;

-- Modyfikacja lekcji (swoje)
GRANT SELECT, INSERT, UPDATE ON lekcje TO r_nauczyciel;
GRANT SELECT ON seq_lekcje TO r_nauczyciel;

-- Modyfikacja ocen (swoje)
GRANT SELECT, INSERT, UPDATE ON oceny TO r_nauczyciel;
GRANT SELECT ON seq_oceny TO r_nauczyciel;

-- Odczyt egzaminow
GRANT SELECT ON egzaminy TO r_nauczyciel;

-- Pakiety
GRANT EXECUTE ON pkg_lekcja TO r_nauczyciel;
GRANT EXECUTE ON pkg_ocena TO r_nauczyciel;
GRANT EXECUTE ON pkg_raport TO r_nauczyciel;

-- ============================================================================
-- 3. ROLA: R_SEKRETARIAT
-- Sekretariat zarzadza uczniami, grupami, planami
-- ============================================================================

PROMPT [3/4] Tworzenie roli r_sekretariat...

CREATE ROLE r_sekretariat;

-- Dziedziczenie z r_nauczyciel
GRANT r_nauczyciel TO r_sekretariat;

-- Pelny CRUD na uczniach
GRANT SELECT, INSERT, UPDATE, DELETE ON uczniowie TO r_sekretariat;
GRANT SELECT ON seq_uczniowie TO r_sekretariat;

-- Pelny CRUD na grupach
GRANT SELECT, INSERT, UPDATE, DELETE ON grupy TO r_sekretariat;
GRANT SELECT ON seq_grupy TO r_sekretariat;

-- Modyfikacja egzaminow
GRANT SELECT, INSERT, UPDATE, DELETE ON egzaminy TO r_sekretariat;
GRANT SELECT ON seq_egzaminy TO r_sekretariat;

-- Usuwanie lekcji
GRANT DELETE ON lekcje TO r_sekretariat;

-- Pakiety
GRANT EXECUTE ON pkg_uczen TO r_sekretariat;
GRANT EXECUTE ON pkg_nauczyciel TO r_sekretariat;

-- ============================================================================
-- 4. ROLA: R_ADMINISTRATOR
-- Administrator ma pelne uprawnienia
-- ============================================================================

PROMPT [4/4] Tworzenie roli r_administrator...

CREATE ROLE r_administrator;

-- Dziedziczenie z r_sekretariat
GRANT r_sekretariat TO r_administrator;

-- Pelny CRUD na wszystkich tabelach
GRANT ALL ON semestry TO r_administrator;
GRANT ALL ON instrumenty TO r_administrator;
GRANT ALL ON sale TO r_administrator;
GRANT ALL ON nauczyciele TO r_administrator;
GRANT ALL ON przedmioty TO r_administrator;

-- Sekwencje
GRANT SELECT ON seq_semestry TO r_administrator;
GRANT SELECT ON seq_instrumenty TO r_administrator;
GRANT SELECT ON seq_sale TO r_administrator;
GRANT SELECT ON seq_nauczyciele TO r_administrator;
GRANT SELECT ON seq_przedmioty TO r_administrator;

-- Wszystkie pakiety
GRANT EXECUTE ON pkg_test TO r_administrator;
GRANT EXECUTE ON pkg_trigger_ctx TO r_administrator;

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================

PROMPT
PROMPT ========================================================================
PROMPT   UTWORZONE ROLE
PROMPT ========================================================================
PROMPT   r_uczen - odczyt slownikow
PROMPT   r_nauczyciel - odczyt + modyfikacja lekcji/ocen
PROMPT   r_sekretariat - CRUD uczniowie/grupy/egzaminy
PROMPT   r_administrator - pelne uprawnienia
PROMPT ========================================================================
PROMPT   Nastepny krok: Uruchom 07_uzytkownicy.sql
PROMPT ========================================================================

SELECT role, role_id FROM dba_roles WHERE role LIKE 'R_%' ORDER BY role;
