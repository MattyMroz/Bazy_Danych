-- ============================================================================
-- Projekt: Szkola Muzyczna - Obiektowa Baza Danych
-- Plik: 06_uzytkownicy.sql
-- Opis: Przydzial uprawnien do obiektow schematu sm_admin
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- UWAGA: Ten skrypt nalezy uruchomic jako SYS lub SYSTEM
-- UWAGA: Skrypt 00_schemat.sql musi byc wykonany PRZED tym skryptem
-- UWAGA: Skrypty 01-05 musza byc wykonane jako sm_admin PRZED tym skryptem

-- ============================================================================
-- 1. PRZYDZIAL UPRAWNIEN DO ROLI ADMIN (pelny dostep)
-- ============================================================================

-- Tabele - pelny dostep
GRANT SELECT, INSERT, UPDATE, DELETE ON sm_admin.INSTRUMENTY TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON sm_admin.PRZEDMIOTY TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON sm_admin.NAUCZYCIELE TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON sm_admin.GRUPY TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON sm_admin.SALE TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON sm_admin.UCZNIOWIE TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON sm_admin.LEKCJE TO rola_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON sm_admin.OCENY TO rola_admin;

-- Sekwencje
GRANT SELECT ON sm_admin.seq_instrumenty TO rola_admin;
GRANT SELECT ON sm_admin.seq_przedmioty TO rola_admin;
GRANT SELECT ON sm_admin.seq_nauczyciele TO rola_admin;
GRANT SELECT ON sm_admin.seq_grupy TO rola_admin;
GRANT SELECT ON sm_admin.seq_sale TO rola_admin;
GRANT SELECT ON sm_admin.seq_uczniowie TO rola_admin;
GRANT SELECT ON sm_admin.seq_lekcje TO rola_admin;
GRANT SELECT ON sm_admin.seq_oceny TO rola_admin;

-- Pakiety
GRANT EXECUTE ON sm_admin.PKG_SLOWNIKI TO rola_admin;
GRANT EXECUTE ON sm_admin.PKG_OSOBY TO rola_admin;
GRANT EXECUTE ON sm_admin.PKG_LEKCJE TO rola_admin;
GRANT EXECUTE ON sm_admin.PKG_OCENY TO rola_admin;
GRANT EXECUTE ON sm_admin.PKG_RAPORTY TO rola_admin;

-- ============================================================================
-- 2. PRZYDZIAL UPRAWNIEN DO ROLI SEKRETARIAT
-- ============================================================================

-- Tabele - odczyt slownikow
GRANT SELECT ON sm_admin.INSTRUMENTY TO rola_sekretariat;
GRANT SELECT ON sm_admin.PRZEDMIOTY TO rola_sekretariat;
GRANT SELECT ON sm_admin.NAUCZYCIELE TO rola_sekretariat;
GRANT SELECT ON sm_admin.GRUPY TO rola_sekretariat;
GRANT SELECT ON sm_admin.SALE TO rola_sekretariat;

-- Tabele - zarzadzanie uczniami i lekcjami
GRANT SELECT, INSERT, UPDATE ON sm_admin.UCZNIOWIE TO rola_sekretariat;
GRANT SELECT, INSERT, UPDATE ON sm_admin.LEKCJE TO rola_sekretariat;
GRANT SELECT ON sm_admin.OCENY TO rola_sekretariat;

-- Sekwencje potrzebne do INSERT
GRANT SELECT ON sm_admin.seq_uczniowie TO rola_sekretariat;
GRANT SELECT ON sm_admin.seq_lekcje TO rola_sekretariat;

-- Pakiety
GRANT EXECUTE ON sm_admin.PKG_SLOWNIKI TO rola_sekretariat;
GRANT EXECUTE ON sm_admin.PKG_OSOBY TO rola_sekretariat;
GRANT EXECUTE ON sm_admin.PKG_LEKCJE TO rola_sekretariat;
GRANT EXECUTE ON sm_admin.PKG_RAPORTY TO rola_sekretariat;

-- ============================================================================
-- 3. PRZYDZIAL UPRAWNIEN DO ROLI NAUCZYCIEL
-- ============================================================================

-- Tabele - tylko odczyt
GRANT SELECT ON sm_admin.INSTRUMENTY TO rola_nauczyciel;
GRANT SELECT ON sm_admin.PRZEDMIOTY TO rola_nauczyciel;
GRANT SELECT ON sm_admin.NAUCZYCIELE TO rola_nauczyciel;
GRANT SELECT ON sm_admin.GRUPY TO rola_nauczyciel;
GRANT SELECT ON sm_admin.SALE TO rola_nauczyciel;
GRANT SELECT ON sm_admin.UCZNIOWIE TO rola_nauczyciel;
GRANT SELECT ON sm_admin.LEKCJE TO rola_nauczyciel;

-- Tabele - wystawianie ocen
GRANT SELECT, INSERT ON sm_admin.OCENY TO rola_nauczyciel;
GRANT SELECT ON sm_admin.seq_oceny TO rola_nauczyciel;

-- Pakiety
GRANT EXECUTE ON sm_admin.PKG_OCENY TO rola_nauczyciel;
GRANT EXECUTE ON sm_admin.PKG_RAPORTY TO rola_nauczyciel;

-- ============================================================================
-- 4. PRZYDZIAL UPRAWNIEN DO ROLI UCZEN (tylko odczyt)
-- ============================================================================

-- Tabele - tylko odczyt podstawowych danych
GRANT SELECT ON sm_admin.INSTRUMENTY TO rola_uczen;
GRANT SELECT ON sm_admin.PRZEDMIOTY TO rola_uczen;
GRANT SELECT ON sm_admin.GRUPY TO rola_uczen;
GRANT SELECT ON sm_admin.SALE TO rola_uczen;
GRANT SELECT ON sm_admin.LEKCJE TO rola_uczen;
GRANT SELECT ON sm_admin.OCENY TO rola_uczen;

-- Ograniczony dostep do danych osobowych (tylko swoje)
-- W produkcji mozna zastosowac VPD (Virtual Private Database) lub widoki

-- Pakiety - tylko raporty
GRANT EXECUTE ON sm_admin.PKG_RAPORTY TO rola_uczen;

-- ============================================================================
-- 5. SYNONIMY PUBLICZNE (aby uzytkownicy nie musieli pisac sm_admin.)
-- ============================================================================

-- Tabele
CREATE OR REPLACE PUBLIC SYNONYM INSTRUMENTY FOR sm_admin.INSTRUMENTY;
CREATE OR REPLACE PUBLIC SYNONYM PRZEDMIOTY FOR sm_admin.PRZEDMIOTY;
CREATE OR REPLACE PUBLIC SYNONYM NAUCZYCIELE FOR sm_admin.NAUCZYCIELE;
CREATE OR REPLACE PUBLIC SYNONYM GRUPY FOR sm_admin.GRUPY;
CREATE OR REPLACE PUBLIC SYNONYM SALE FOR sm_admin.SALE;
CREATE OR REPLACE PUBLIC SYNONYM UCZNIOWIE FOR sm_admin.UCZNIOWIE;
CREATE OR REPLACE PUBLIC SYNONYM LEKCJE FOR sm_admin.LEKCJE;
CREATE OR REPLACE PUBLIC SYNONYM OCENY FOR sm_admin.OCENY;

-- Sekwencje
CREATE OR REPLACE PUBLIC SYNONYM seq_instrumenty FOR sm_admin.seq_instrumenty;
CREATE OR REPLACE PUBLIC SYNONYM seq_przedmioty FOR sm_admin.seq_przedmioty;
CREATE OR REPLACE PUBLIC SYNONYM seq_nauczyciele FOR sm_admin.seq_nauczyciele;
CREATE OR REPLACE PUBLIC SYNONYM seq_grupy FOR sm_admin.seq_grupy;
CREATE OR REPLACE PUBLIC SYNONYM seq_sale FOR sm_admin.seq_sale;
CREATE OR REPLACE PUBLIC SYNONYM seq_uczniowie FOR sm_admin.seq_uczniowie;
CREATE OR REPLACE PUBLIC SYNONYM seq_lekcje FOR sm_admin.seq_lekcje;
CREATE OR REPLACE PUBLIC SYNONYM seq_oceny FOR sm_admin.seq_oceny;

-- Pakiety
CREATE OR REPLACE PUBLIC SYNONYM PKG_SLOWNIKI FOR sm_admin.PKG_SLOWNIKI;
CREATE OR REPLACE PUBLIC SYNONYM PKG_OSOBY FOR sm_admin.PKG_OSOBY;
CREATE OR REPLACE PUBLIC SYNONYM PKG_LEKCJE FOR sm_admin.PKG_LEKCJE;
CREATE OR REPLACE PUBLIC SYNONYM PKG_OCENY FOR sm_admin.PKG_OCENY;
CREATE OR REPLACE PUBLIC SYNONYM PKG_RAPORTY FOR sm_admin.PKG_RAPORTY;

-- Typy (potrzebne do uzywania kolekcji w pakietach)
CREATE OR REPLACE PUBLIC SYNONYM T_INSTRUMENTY_TAB FOR sm_admin.T_INSTRUMENTY_TAB;
CREATE OR REPLACE PUBLIC SYNONYM T_WYPOSAZENIE FOR sm_admin.T_WYPOSAZENIE;
CREATE OR REPLACE PUBLIC SYNONYM T_KOMISJA FOR sm_admin.T_KOMISJA;

-- ============================================================================
-- 6. POTWIERDZENIE
-- ============================================================================

SELECT 'Uprawnienia przydzielone pomyslnie!' AS status FROM DUAL;

-- Podsumowanie uzytkownikow i ich rol
SELECT u.username, r.granted_role, r.admin_option
FROM dba_users u
JOIN dba_role_privs r ON u.username = r.grantee
WHERE u.username IN ('ADMIN', 'SEKRETARIAT', 'NAUCZYCIEL', 'UCZEN')
ORDER BY u.username, r.granted_role;

-- Podsumowanie uprawnien tabelowych dla rol
SELECT grantee AS rola, table_name AS obiekt, privilege
FROM dba_tab_privs
WHERE grantee LIKE 'ROLA_%'
  AND owner = 'SM_ADMIN'
ORDER BY grantee, table_name, privilege;

-- ============================================================================
-- 7. INSTRUKCJA UZYCIA
-- ============================================================================

/*
UZYTKOWNICY I ICH ROLE:

1. ADMIN (admin / admin123)
   - Pelny dostep do wszystkich tabel i pakietow
   - Moze dodawac/usuwac dane, modyfikowac slowniki
   - Przeznaczony dla administratora systemu

2. SEKRETARIAT (sekretariat / sekretariat123)
   - Odczyt slownikow (instrumenty, przedmioty, sale, grupy)
   - Zarzadzanie uczniami (dodawanie, edycja)
   - Zarzadzanie lekcjami (planowanie, zmiany)
   - Odczyt ocen (bez mozliwosci edycji)
   - Dostep do raportow

3. NAUCZYCIEL (nauczyciel / nauczyciel123)
   - Odczyt wszystkich danych
   - Wystawianie ocen uczniom
   - Dostep do raportow

4. UCZEN (uczen / uczen123)
   - Tylko odczyt swoich danych
   - Przegladanie planu lekcji
   - Przegladanie swoich ocen
   - W produkcji: ograniczyc przez VPD do wlasnych rekordow

PRZYKLADY UZYCIA:

-- Jako admin:
EXEC PKG_SLOWNIKI.dodaj_instrument('Wiolonczela', 'T');

-- Jako sekretariat:
EXEC PKG_OSOBY.dodaj_ucznia('Nowy', 'Uczen', DATE '2018-01-01', '1A', 'Fortepian');

-- Jako nauczyciel:
EXEC PKG_OCENY.wystaw_ocene('Kowalski', 'Jan', 'Kowalska', 'Fortepian', 5, 'technika');

-- Jako uczen:
SELECT * FROM OCENY WHERE DEREF(ref_uczen).nazwisko = 'Kowalski';
*/
