-- ============================================================================
-- PLIK: 07_uzytkownicy.sql
-- PROJEKT: Szkoła Muzyczna v5 - Obiektowa Baza Danych Oracle
-- AUTORZY: Igor Typiński (251237), Mateusz Mróz (251190)
-- DATA: Styczeń 2026
-- ============================================================================
--
-- CO TEN PLIK ROBI?
-- -----------------
-- Tworzy testowych UŻYTKOWNIKÓW i przypisuje im ROLE.
--
-- UŻYTKOWNICY TESTOWI:
-- ====================
--
-- | Użytkownik     | Hasło      | Rola            | Reprezentuje            |
-- |----------------|------------|-----------------|-------------------------|
-- | uczen_ala      | Ala123!    | r_uczen         | Uczennica Ala           |
-- | uczen_bartek   | Bartek123! | r_uczen         | Uczeń Bartek            |
-- | nauczyciel_jan | Jan123!    | r_nauczyciel    | Nauczyciel Kowalski     |
-- | sekretariat    | Sekr123!   | r_sekretariat   | Pracownik sekretariatu  |
-- | admin_it       | Admin123!  | r_administrator | Administrator bazy      |
--
-- KONWENCJA NAZEWNICTWA:
-- ======================
-- [typ]_[imie/funkcja]
--   - uczen_*        → uczniowie
--   - nauczyciel_*   → nauczyciele
--   - sekretariat    → sekretariat (bez imienia - generyczny)
--   - admin_*        → administratorzy
--
-- HASŁA:
-- ======
-- W produkcji używamy:
--   - Silnych, losowych haseł
--   - Rotacji haseł (PASSWORD EXPIRE)
--   - Profili z polityką haseł
--
-- W tym projekcie (testowy) używamy prostych haseł do demonstracji.
--
-- JAK URUCHOMIĆ?
-- --------------
-- WYMAGANIE: Uprawnienia DBA (CREATE USER, GRANT)
-- Uruchom jako: SYS AS SYSDBA lub użytkownik z odpowiednimi prawami
-- @07_uzytkownicy.sql
--
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200

PROMPT ╔═══════════════════════════════════════════════════════════════╗
PROMPT ║  07_uzytkownicy.sql - Tworzenie użytkowników testowych        ║
PROMPT ╚═══════════════════════════════════════════════════════════════╝
PROMPT

-- ============================================================================
-- PARAMETRY KONFIGURACYJNE
-- ============================================================================
-- Zmień te wartości jeśli potrzebujesz innych ustawień
-- ============================================================================

-- Tablespace dla użytkowników (zmień na istniejący w Twoim środowisku)
-- Dla Oracle XE często to USERS
DEFINE tablespace_default = USERS
DEFINE tablespace_temp    = TEMP

-- Schemat właściciela obiektów (zmień na właściwy!)
-- To jest użytkownik, który uruchomił 01-05 skrypty
DEFINE owner_schema = SZKOLA

-- ============================================================================
-- USUNIĘCIE STARYCH UŻYTKOWNIKÓW (jeśli istnieją)
-- ============================================================================

PROMPT [0/5] Usuwanie starych użytkowników (jeśli istnieją)...

BEGIN
    FOR rec IN (
        SELECT username 
        FROM dba_users 
        WHERE username IN (
            'UCZEN_ALA', 'UCZEN_BARTEK', 
            'NAUCZYCIEL_JAN', 'SEKRETARIAT', 'ADMIN_IT'
        )
    ) LOOP
        EXECUTE IMMEDIATE 'DROP USER ' || rec.username || ' CASCADE';
        DBMS_OUTPUT.PUT_LINE('   Usunięto użytkownika: ' || rec.username);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('   Brak starych użytkowników do usunięcia.');
END;
/

-- ============================================================================
-- UŻYTKOWNIK 1: uczen_ala
-- ============================================================================
--
-- REPREZENTUJE: Uczennica Ala Malinowska (ID=1)
-- ROLA: r_uczen
-- MOŻE:
--   - Przeglądać swój plan lekcji
--   - Przeglądać swoje oceny
--   - Przeglądać słowniki (nauczyciele, przedmioty)
-- NIE MOŻE:
--   - Modyfikować żadnych danych
--   - Widzieć danych innych uczniów (przez widoki)
--
-- ============================================================================

PROMPT [1/5] Tworzenie użytkownika uczen_ala...

CREATE USER uczen_ala
    IDENTIFIED BY "Ala123!"
    DEFAULT TABLESPACE &tablespace_default
    TEMPORARY TABLESPACE &tablespace_temp
    QUOTA 10M ON &tablespace_default;

-- Podstawowe uprawnienia systemowe
GRANT CREATE SESSION TO uczen_ala;

-- Przypisanie roli
GRANT r_uczen TO uczen_ala;

-- Domyślna rola (aktywna po zalogowaniu)
ALTER USER uczen_ala DEFAULT ROLE r_uczen;

PROMPT    uczen_ala: rola r_uczen, hasło Ala123!

-- ============================================================================
-- UŻYTKOWNIK 2: uczen_bartek
-- ============================================================================
--
-- REPREZENTUJE: Uczeń Bartek Nowakowski (ID=2)
-- ROLA: r_uczen
--
-- ============================================================================

PROMPT [2/5] Tworzenie użytkownika uczen_bartek...

CREATE USER uczen_bartek
    IDENTIFIED BY "Bartek123!"
    DEFAULT TABLESPACE &tablespace_default
    TEMPORARY TABLESPACE &tablespace_temp
    QUOTA 10M ON &tablespace_default;

GRANT CREATE SESSION TO uczen_bartek;
GRANT r_uczen TO uczen_bartek;
ALTER USER uczen_bartek DEFAULT ROLE r_uczen;

PROMPT    uczen_bartek: rola r_uczen, hasło Bartek123!

-- ============================================================================
-- UŻYTKOWNIK 3: nauczyciel_jan
-- ============================================================================
--
-- REPREZENTUJE: Nauczyciel Jan Kowalski (ID=1)
-- ROLA: r_nauczyciel
-- MOŻE:
--   - Wszystko co r_uczen
--   - Wystawiać oceny swoim uczniom
--   - Zmieniać status lekcji (zaplanowana → odbyta)
--   - Generować raporty
-- NIE MOŻE:
--   - Dodawać/usuwać uczniów
--   - Tworzyć lekcji (to robi sekretariat)
--
-- ============================================================================

PROMPT [3/5] Tworzenie użytkownika nauczyciel_jan...

CREATE USER nauczyciel_jan
    IDENTIFIED BY "Jan123!"
    DEFAULT TABLESPACE &tablespace_default
    TEMPORARY TABLESPACE &tablespace_temp
    QUOTA 50M ON &tablespace_default;

GRANT CREATE SESSION TO nauczyciel_jan;
GRANT r_nauczyciel TO nauczyciel_jan;
ALTER USER nauczyciel_jan DEFAULT ROLE r_nauczyciel;

PROMPT    nauczyciel_jan: rola r_nauczyciel, hasło Jan123!

-- ============================================================================
-- UŻYTKOWNIK 4: sekretariat
-- ============================================================================
--
-- REPREZENTUJE: Pracownik sekretariatu (generyczny)
-- ROLA: r_sekretariat
-- MOŻE:
--   - Wszystko co r_nauczyciel
--   - Dodawać/edytować uczniów
--   - Planować lekcje (przez pkg_lekcja)
--   - Zarządzać salami, grupami
--   - Odwoływać lekcje
-- NIE MOŻE:
--   - Zmieniać struktury bazy
--   - Zarządzać użytkownikami
--
-- ============================================================================

PROMPT [4/5] Tworzenie użytkownika sekretariat...

CREATE USER sekretariat
    IDENTIFIED BY "Sekr123!"
    DEFAULT TABLESPACE &tablespace_default
    TEMPORARY TABLESPACE &tablespace_temp
    QUOTA 100M ON &tablespace_default;

GRANT CREATE SESSION TO sekretariat;
GRANT r_sekretariat TO sekretariat;
ALTER USER sekretariat DEFAULT ROLE r_sekretariat;

PROMPT    sekretariat: rola r_sekretariat, hasło Sekr123!

-- ============================================================================
-- UŻYTKOWNIK 5: admin_it
-- ============================================================================
--
-- REPREZENTUJE: Administrator IT / DBA
-- ROLA: r_administrator
-- MOŻE:
--   - WSZYSTKO w schemacie szkoły
--   - Zarządzać użytkownikami i rolami
--   - Tworzyć/usuwać obiekty
--
-- UWAGA: To potężny użytkownik - używaj ostrożnie!
--
-- ============================================================================

PROMPT [5/5] Tworzenie użytkownika admin_it...

CREATE USER admin_it
    IDENTIFIED BY "Admin123!"
    DEFAULT TABLESPACE &tablespace_default
    TEMPORARY TABLESPACE &tablespace_temp
    QUOTA UNLIMITED ON &tablespace_default;

GRANT CREATE SESSION TO admin_it;
GRANT r_administrator TO admin_it;
ALTER USER admin_it DEFAULT ROLE r_administrator;

-- Dodatkowe uprawnienia administracyjne
GRANT CREATE USER TO admin_it;
GRANT DROP USER TO admin_it;
GRANT ALTER USER TO admin_it;

PROMPT    admin_it: rola r_administrator + CREATE/DROP/ALTER USER, hasło Admin123!

-- ============================================================================
-- SYNONIMY PUBLICZNE (opcjonalnie)
-- ============================================================================
--
-- Synonimy pozwalają użytkownikom odwoływać się do obiektów bez prefiksu schematu:
--   zamiast: SELECT * FROM szkola.t_uczen
--   można:   SELECT * FROM t_uczen
--
-- Odkomentuj jeśli chcesz używać synonimów.
--
-- ============================================================================

/*
PROMPT Tworzenie synonimów publicznych...

CREATE OR REPLACE PUBLIC SYNONYM t_semestr    FOR &owner_schema..t_semestr;
CREATE OR REPLACE PUBLIC SYNONYM t_instrument FOR &owner_schema..t_instrument;
CREATE OR REPLACE PUBLIC SYNONYM t_sala       FOR &owner_schema..t_sala;
CREATE OR REPLACE PUBLIC SYNONYM t_nauczyciel FOR &owner_schema..t_nauczyciel;
CREATE OR REPLACE PUBLIC SYNONYM t_grupa      FOR &owner_schema..t_grupa;
CREATE OR REPLACE PUBLIC SYNONYM t_uczen      FOR &owner_schema..t_uczen;
CREATE OR REPLACE PUBLIC SYNONYM t_przedmiot  FOR &owner_schema..t_przedmiot;
CREATE OR REPLACE PUBLIC SYNONYM t_lekcja     FOR &owner_schema..t_lekcja;
CREATE OR REPLACE PUBLIC SYNONYM t_egzamin    FOR &owner_schema..t_egzamin;
CREATE OR REPLACE PUBLIC SYNONYM t_ocena      FOR &owner_schema..t_ocena;

CREATE OR REPLACE PUBLIC SYNONYM pkg_uczen      FOR &owner_schema..pkg_uczen;
CREATE OR REPLACE PUBLIC SYNONYM pkg_nauczyciel FOR &owner_schema..pkg_nauczyciel;
CREATE OR REPLACE PUBLIC SYNONYM pkg_lekcja     FOR &owner_schema..pkg_lekcja;
CREATE OR REPLACE PUBLIC SYNONYM pkg_ocena      FOR &owner_schema..pkg_ocena;
CREATE OR REPLACE PUBLIC SYNONYM pkg_raport     FOR &owner_schema..pkg_raport;
CREATE OR REPLACE PUBLIC SYNONYM pkg_test       FOR &owner_schema..pkg_test;

PROMPT    Synonimy publiczne utworzone.
*/

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================

PROMPT
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT   PODSUMOWANIE - Utworzeni użytkownicy
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT
PROMPT   UŻYTKOWNICY TESTOWI:
PROMPT
PROMPT   ┌────────────────┬─────────────┬─────────────────┬─────────────────────┐
PROMPT   │ Użytkownik     │ Hasło       │ Rola            │ Reprezentuje        │
PROMPT   ├────────────────┼─────────────┼─────────────────┼─────────────────────┤
PROMPT   │ uczen_ala      │ Ala123!     │ r_uczen         │ Uczennica Ala       │
PROMPT   │ uczen_bartek   │ Bartek123!  │ r_uczen         │ Uczeń Bartek        │
PROMPT   │ nauczyciel_jan │ Jan123!     │ r_nauczyciel    │ Nauczyciel Kowalski │
PROMPT   │ sekretariat    │ Sekr123!    │ r_sekretariat   │ Pracownik sekret.   │
PROMPT   │ admin_it       │ Admin123!   │ r_administrator │ Administrator IT    │
PROMPT   └────────────────┴─────────────┴─────────────────┴─────────────────────┘
PROMPT
PROMPT   TESTOWANIE POŁĄCZENIA:
PROMPT     SQL> CONNECT uczen_ala/Ala123!
PROMPT     SQL> SELECT * FROM &owner_schema..t_uczen WHERE imie = 'Ala';
PROMPT
PROMPT   🔴 UWAGA: Hasła są proste (testowe). W produkcji używaj silnych haseł!
PROMPT
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT   Następny krok: Uruchom 08_widoki.sql
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT

-- Lista użytkowników
SELECT username, account_status, default_tablespace, created
FROM dba_users
WHERE username IN (
    'UCZEN_ALA', 'UCZEN_BARTEK', 
    'NAUCZYCIEL_JAN', 'SEKRETARIAT', 'ADMIN_IT'
)
ORDER BY created;

-- Role przypisane użytkownikom
SELECT grantee, granted_role
FROM dba_role_privs
WHERE grantee IN (
    'UCZEN_ALA', 'UCZEN_BARTEK', 
    'NAUCZYCIEL_JAN', 'SEKRETARIAT', 'ADMIN_IT'
)
ORDER BY grantee;
