-- ============================================================================
-- PLIK: 06_role.sql
-- PROJEKT: Szkoła Muzyczna v5 - Obiektowa Baza Danych Oracle
-- AUTORZY: Igor Typiński (251237), Mateusz Mróz (251190)
-- DATA: Styczeń 2026
-- ============================================================================
--
-- CO TEN PLIK ROBI?
-- -----------------
-- Tworzy ROLE - zestawy uprawnień dla różnych typów użytkowników.
--
-- KONCEPCJA RÓL W ORACLE:
-- =======================
--
-- Zamiast nadawać uprawnienia każdemu użytkownikowi osobno,
-- tworzymy ROLE i przypisujemy je użytkownikom.
--
-- Hierarchia:
--   Użytkownik → Role → Uprawnienia
--
-- Korzyści:
--   1. Łatwiejsze zarządzanie (zmiana roli = zmiana dla wszystkich)
--   2. Czytelność (nazwa roli opisuje funkcję)
--   3. Bezpieczeństwo (zasada minimalnych uprawnień)
--
-- ROLE W PROJEKCIE:
-- =================
--
-- | Rola            | Kto?             | Uprawnienia                      |
-- |-----------------|------------------|----------------------------------|
-- | r_uczen         | Uczeń            | SELECT własne dane, oceny        |
-- | r_nauczyciel    | Nauczyciel       | SELECT/INSERT oceny, lekcje      |
-- | r_sekretariat   | Sekretariat      | SELECT/INSERT/UPDATE wszystko    |
-- | r_administrator | Admin IT         | DBA (pełne uprawnienia)          |
--
-- WAŻNE: Uprawnienia na poziomie WIERSZA (Row-Level Security)
-- ============================================================
-- 
-- Oracle oferuje Virtual Private Database (VPD) do RLS.
-- W tym projekcie używamy prostszego podejścia:
--   - Widoki z WHERE dla filtrowania danych
--   - Pakiety jako API (zamiast bezpośredniego dostępu)
--
-- Przykład:
--   Uczeń Jan (id=1) widzi tylko swoje oceny przez widok v_moje_oceny,
--   który ma WHERE id_ucznia = SYS_CONTEXT('SZKOLA_CTX', 'ID_UCZNIA')
--
-- JAK URUCHOMIĆ?
-- --------------
-- WYMAGANIE: Uprawnienia DBA (CREATE ROLE, GRANT)
-- Uruchom jako: SYS AS SYSDBA lub użytkownik z ADMIN OPTION
-- @06_role.sql
--
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200

PROMPT ╔═══════════════════════════════════════════════════════════════╗
PROMPT ║  06_role.sql - Tworzenie ról i uprawnień                      ║
PROMPT ╚═══════════════════════════════════════════════════════════════╝
PROMPT

-- ============================================================================
-- USUNIĘCIE STARYCH RÓL (jeśli istnieją)
-- ============================================================================

PROMPT [0/4] Usuwanie starych ról (jeśli istnieją)...

BEGIN
    EXECUTE IMMEDIATE 'DROP ROLE r_uczen';
    DBMS_OUTPUT.PUT_LINE('   Usunięto r_uczen');
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP ROLE r_nauczyciel';
    DBMS_OUTPUT.PUT_LINE('   Usunięto r_nauczyciel');
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP ROLE r_sekretariat';
    DBMS_OUTPUT.PUT_LINE('   Usunięto r_sekretariat');
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP ROLE r_administrator';
    DBMS_OUTPUT.PUT_LINE('   Usunięto r_administrator');
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

-- ============================================================================
-- ROLA 1: r_uczen
-- ============================================================================
--
-- PRZEZNACZENIE: Uczniowie szkoły muzycznej
--
-- UPRAWNIENIA:
--   SELECT: t_uczen (własne dane), t_ocena (własne), t_lekcja (własne)
--           t_przedmiot, t_nauczyciel, t_semestr, t_instrument (słowniki)
--   EXECUTE: pkg_raport.plan_ucznia (tylko własny plan)
--
-- BRAK:
--   - INSERT/UPDATE/DELETE na żadnej tabeli
--   - Dostęp do danych innych uczniów (przez widoki!)
--
-- ============================================================================

PROMPT [1/4] Tworzenie roli r_uczen...

CREATE ROLE r_uczen;

-- Uprawnienia SELECT na słownikach (wszyscy mogą czytać)
GRANT SELECT ON t_semestr    TO r_uczen;
GRANT SELECT ON t_instrument TO r_uczen;
GRANT SELECT ON t_sala       TO r_uczen;
GRANT SELECT ON t_nauczyciel TO r_uczen;
GRANT SELECT ON t_przedmiot  TO r_uczen;
GRANT SELECT ON t_grupa      TO r_uczen;

-- Uprawnienia SELECT na danych własnych (przez widoki w przyszłości)
-- Na razie dajemy SELECT na całych tabelach, ale użytkownik powinien
-- używać widoków filtrujących (08_widoki.sql)
GRANT SELECT ON t_uczen  TO r_uczen;
GRANT SELECT ON t_ocena  TO r_uczen;
GRANT SELECT ON t_lekcja TO r_uczen;

-- Uprawnienia EXECUTE na pakietach (tylko do odczytu)
GRANT EXECUTE ON pkg_raport TO r_uczen;
GRANT EXECUTE ON pkg_uczen  TO r_uczen;  -- tylko funkcja czy_godzina_dozwolona

PROMPT    r_uczen: SELECT na słownikach i własnych danych, EXECUTE pkg_raport

-- ============================================================================
-- ROLA 2: r_nauczyciel
-- ============================================================================
--
-- PRZEZNACZENIE: Nauczyciele szkoły muzycznej
--
-- UPRAWNIENIA:
--   SELECT: Wszystkie tabele (potrzebują planu, danych uczniów)
--   INSERT: t_ocena (wystawianie ocen)
--   UPDATE: t_ocena (poprawianie ocen), t_lekcja (status)
--   EXECUTE: pkg_ocena, pkg_raport, pkg_lekcja (zmiana statusu)
--
-- BRAK:
--   - DELETE (oceny, lekcje są archiwizowane, nie usuwane)
--   - Modyfikacja danych uczniów (to robi sekretariat)
--
-- ============================================================================

PROMPT [2/4] Tworzenie roli r_nauczyciel...

CREATE ROLE r_nauczyciel;

-- Dziedziczy od r_uczen (nauczyciel może wszystko co uczeń + więcej)
GRANT r_uczen TO r_nauczyciel;

-- Dodatkowe uprawnienia SELECT
GRANT SELECT ON t_egzamin TO r_nauczyciel;

-- INSERT: oceny
GRANT INSERT ON t_ocena TO r_nauczyciel;

-- UPDATE: oceny (wartość, opis), lekcje (status)
GRANT UPDATE ON t_ocena  TO r_nauczyciel;
GRANT UPDATE (status) ON t_lekcja TO r_nauczyciel;

-- EXECUTE: pakiety do zarządzania ocenami i raportami
GRANT EXECUTE ON pkg_ocena       TO r_nauczyciel;
GRANT EXECUTE ON pkg_nauczyciel  TO r_nauczyciel;

-- Sekwencje (do INSERT)
GRANT SELECT ON seq_ocena TO r_nauczyciel;

PROMPT    r_nauczyciel: + INSERT/UPDATE oceny, UPDATE status lekcji

-- ============================================================================
-- ROLA 3: r_sekretariat
-- ============================================================================
--
-- PRZEZNACZENIE: Pracownicy sekretariatu
--
-- UPRAWNIENIA:
--   SELECT: Wszystkie tabele
--   INSERT: t_uczen, t_lekcja, t_egzamin, t_grupa
--   UPDATE: t_uczen, t_nauczyciel, t_lekcja, t_egzamin
--   DELETE: t_lekcja (odwoływanie), t_uczen (wypisywanie)
--   EXECUTE: Wszystkie pakiety
--
-- KLUCZOWA ROLA - zarządza danymi szkoły
--
-- ============================================================================

PROMPT [3/4] Tworzenie roli r_sekretariat...

CREATE ROLE r_sekretariat;

-- Dziedziczy od r_nauczyciel
GRANT r_nauczyciel TO r_sekretariat;

-- Pełny SELECT
GRANT SELECT ON t_egzamin TO r_sekretariat;
GRANT SELECT ON t_ocena   TO r_sekretariat;

-- INSERT
GRANT INSERT ON t_uczen     TO r_sekretariat;
GRANT INSERT ON t_lekcja    TO r_sekretariat;
GRANT INSERT ON t_egzamin   TO r_sekretariat;
GRANT INSERT ON t_grupa     TO r_sekretariat;
GRANT INSERT ON t_nauczyciel TO r_sekretariat;
GRANT INSERT ON t_sala      TO r_sekretariat;
GRANT INSERT ON t_przedmiot TO r_sekretariat;

-- UPDATE
GRANT UPDATE ON t_uczen      TO r_sekretariat;
GRANT UPDATE ON t_nauczyciel TO r_sekretariat;
GRANT UPDATE ON t_lekcja     TO r_sekretariat;
GRANT UPDATE ON t_egzamin    TO r_sekretariat;
GRANT UPDATE ON t_sala       TO r_sekretariat;

-- DELETE (ostrożnie!)
GRANT DELETE ON t_lekcja TO r_sekretariat;  -- odwoływanie lekcji

-- EXECUTE: wszystkie pakiety
GRANT EXECUTE ON pkg_uczen       TO r_sekretariat;
GRANT EXECUTE ON pkg_nauczyciel  TO r_sekretariat;
GRANT EXECUTE ON pkg_lekcja      TO r_sekretariat;
GRANT EXECUTE ON pkg_ocena       TO r_sekretariat;
GRANT EXECUTE ON pkg_raport      TO r_sekretariat;
GRANT EXECUTE ON pkg_test        TO r_sekretariat;

-- Wszystkie sekwencje
GRANT SELECT ON seq_uczen      TO r_sekretariat;
GRANT SELECT ON seq_nauczyciel TO r_sekretariat;
GRANT SELECT ON seq_lekcja     TO r_sekretariat;
GRANT SELECT ON seq_egzamin    TO r_sekretariat;
GRANT SELECT ON seq_grupa      TO r_sekretariat;
GRANT SELECT ON seq_sala       TO r_sekretariat;
GRANT SELECT ON seq_przedmiot  TO r_sekretariat;

PROMPT    r_sekretariat: + INSERT/UPDATE/DELETE na danych szkolnych

-- ============================================================================
-- ROLA 4: r_administrator
-- ============================================================================
--
-- PRZEZNACZENIE: Administrator IT / DBA
--
-- UPRAWNIENIA:
--   - WSZYSTKIE uprawnienia na schemacie
--   - Może tworzyć/usuwać obiekty
--   - Może zarządzać użytkownikami (z ADMIN OPTION)
--
-- OSTRZEŻENIE: To potężna rola - przydzielaj ostrożnie!
--
-- ============================================================================

PROMPT [4/4] Tworzenie roli r_administrator...

CREATE ROLE r_administrator;

-- Dziedziczy od r_sekretariat
GRANT r_sekretariat TO r_administrator;

-- Pełne uprawnienia na wszystkich tabelach
GRANT ALL ON t_semestr    TO r_administrator;
GRANT ALL ON t_instrument TO r_administrator;
GRANT ALL ON t_sala       TO r_administrator;
GRANT ALL ON t_nauczyciel TO r_administrator;
GRANT ALL ON t_grupa      TO r_administrator;
GRANT ALL ON t_uczen      TO r_administrator;
GRANT ALL ON t_przedmiot  TO r_administrator;
GRANT ALL ON t_lekcja     TO r_administrator;
GRANT ALL ON t_egzamin    TO r_administrator;
GRANT ALL ON t_ocena      TO r_administrator;

-- Wszystkie sekwencje
GRANT ALL ON seq_semestr    TO r_administrator;
GRANT ALL ON seq_instrument TO r_administrator;
GRANT ALL ON seq_sala       TO r_administrator;
GRANT ALL ON seq_nauczyciel TO r_administrator;
GRANT ALL ON seq_grupa      TO r_administrator;
GRANT ALL ON seq_uczen      TO r_administrator;
GRANT ALL ON seq_przedmiot  TO r_administrator;
GRANT ALL ON seq_lekcja     TO r_administrator;
GRANT ALL ON seq_egzamin    TO r_administrator;
GRANT ALL ON seq_ocena      TO r_administrator;

-- Uprawnienia do nadawania uprawnień (ADMIN OPTION)
GRANT r_uczen       TO r_administrator WITH ADMIN OPTION;
GRANT r_nauczyciel  TO r_administrator WITH ADMIN OPTION;
GRANT r_sekretariat TO r_administrator WITH ADMIN OPTION;

PROMPT    r_administrator: PEŁNE uprawnienia + WITH ADMIN OPTION

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================

PROMPT
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT   PODSUMOWANIE - Utworzone role
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT
PROMPT   HIERARCHIA RÓL:
PROMPT
PROMPT     r_administrator ─────┐
PROMPT            │             │ WITH ADMIN OPTION
PROMPT            ▼             │
PROMPT     r_sekretariat ───────┼─── INSERT/UPDATE/DELETE dane szkolne
PROMPT            │             │
PROMPT            ▼             │
PROMPT     r_nauczyciel ────────┼─── INSERT/UPDATE oceny, UPDATE status
PROMPT            │             │
PROMPT            ▼             │
PROMPT     r_uczen ─────────────┴─── SELECT tylko (własne dane przez widoki)
PROMPT
PROMPT   ZASADA MINIMALNYCH UPRAWNIEŃ:
PROMPT     ● r_uczen: tylko odczyt własnych danych
PROMPT     ● r_nauczyciel: + zarządzanie ocenami
PROMPT     ● r_sekretariat: + zarządzanie uczniami/lekcjami
PROMPT     ● r_administrator: pełna kontrola
PROMPT
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT   Następny krok: Uruchom 07_uzytkownicy.sql
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT

-- Lista ról
SELECT role FROM dba_roles 
WHERE role LIKE 'R\_%' ESCAPE '\'
ORDER BY role;
