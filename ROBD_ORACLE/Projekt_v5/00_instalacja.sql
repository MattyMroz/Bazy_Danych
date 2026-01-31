-- ============================================================================
-- PLIK: 00_instalacja.sql
-- PROJEKT: Szkoła Muzyczna v5 - Obiektowa Baza Danych Oracle
-- AUTORZY: Igor Typiński (251237), Mateusz Mróz (251190)
-- DATA: Styczeń 2026
-- ============================================================================
--
-- CO TEN PLIK ROBI?
-- -----------------
-- Uruchamia WSZYSTKIE skrypty projektu w odpowiedniej kolejności.
-- Jest to główny punkt wejścia do instalacji bazy danych.
--
-- KOLEJNOŚĆ WYKONANIA:
-- ====================
--
--   01_typy.sql       → Typy obiektowe (12 typów, 2 VARRAY)
--   02_tabele.sql     → Tabele obiektowe (10 tabel, 10 sekwencji)
--   03_triggery.sql   → Triggery walidacyjne (6 triggerów)
--   04_pakiety.sql    → Pakiety PL/SQL (6 pakietów)
--   05_dane.sql       → Dane testowe (semestry, uczniowie, lekcje...)
--   06_role.sql       → Role (4 role: uczeń, nauczyciel, sekretariat, admin)
--   07_uzytkownicy.sql→ Użytkownicy testowi (5 użytkowników)
--   08_widoki.sql     → Widoki (8 widoków raportowych)
--   09_testy.sql      → Testy automatyczne (24 testy)
--
-- JAK URUCHOMIĆ?
-- ==============
--
-- OPCJA 1: SQL*Plus
--   $ sqlplus szkola/haslo@localhost:1521/XEPDB1
--   SQL> @00_instalacja.sql
--
-- OPCJA 2: SQL Developer
--   1. Otwórz 00_instalacja.sql
--   2. Kliknij "Run Script" (F5)
--
-- OPCJA 3: Pojedyncze skrypty
--   SQL> @01_typy.sql
--   SQL> @02_tabele.sql
--   ...
--
-- WYMAGANIA:
-- ==========
--   - Oracle Database 19c lub nowsza
--   - Schemat z uprawnieniami:
--       CREATE TYPE, CREATE TABLE, CREATE TRIGGER,
--       CREATE PROCEDURE, CREATE VIEW, CREATE SEQUENCE
--   - Dla ról/użytkowników: SYS AS SYSDBA lub DBA
--
-- UWAGA:
-- ======
-- Skrypty 06_role.sql i 07_uzytkownicy.sql wymagają uprawnień DBA.
-- Jeśli nie masz tych uprawnień, zakomentuj odpowiednie linie poniżej.
--
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200
SET ECHO OFF
SET FEEDBACK OFF
SET TIMING ON

PROMPT
PROMPT ╔═══════════════════════════════════════════════════════════════════════╗
PROMPT ║                                                                       ║
PROMPT ║   ██████╗ ███████╗██████╗                                             ║
PROMPT ║   ██╔══██╗██╔════╝██╔══██╗                                            ║
PROMPT ║   ██║  ██║█████╗  ██████╔╝                                            ║
PROMPT ║   ██║  ██║██╔══╝  ██╔══██╗                                            ║
PROMPT ║   ██████╔╝███████╗██████╔╝                                            ║
PROMPT ║   ╚═════╝ ╚══════╝╚═════╝                                             ║
PROMPT ║                                                                       ║
PROMPT ║   SZKOŁA MUZYCZNA v5 - Obiektowa Baza Danych Oracle                   ║
PROMPT ║   Autorzy: Igor Typiński (251237), Mateusz Mróz (251190)              ║
PROMPT ║   Data: Styczeń 2026                                                  ║
PROMPT ║                                                                       ║
PROMPT ╚═══════════════════════════════════════════════════════════════════════╝
PROMPT

-- ============================================================================
-- KROK 1: TYPY OBIEKTOWE
-- ============================================================================
PROMPT [1/9] Wykonywanie 01_typy.sql...
PROMPT      → 12 typów obiektowych, 2 VARRAY
@01_typy.sql

-- ============================================================================
-- KROK 2: TABELE
-- ============================================================================
PROMPT
PROMPT [2/9] Wykonywanie 02_tabele.sql...
PROMPT      → 10 tabel obiektowych, 10 sekwencji, indeksy
@02_tabele.sql

-- ============================================================================
-- KROK 3: TRIGGERY
-- ============================================================================
PROMPT
PROMPT [3/9] Wykonywanie 03_triggery.sql...
PROMPT      → 6 triggerów walidacyjnych
@03_triggery.sql

-- ============================================================================
-- KROK 4: PAKIETY
-- ============================================================================
PROMPT
PROMPT [4/9] Wykonywanie 04_pakiety.sql...
PROMPT      → 6 pakietów PL/SQL (walidacje konfliktów!)
@04_pakiety.sql

-- ============================================================================
-- KROK 5: DANE TESTOWE
-- ============================================================================
PROMPT
PROMPT [5/9] Wykonywanie 05_dane.sql...
PROMPT      → Semestry, instrumenty, sale, nauczyciele, uczniowie, lekcje...
@05_dane.sql

-- ============================================================================
-- KROK 6: ROLE (wymaga DBA)
-- ============================================================================
PROMPT
PROMPT [6/9] Wykonywanie 06_role.sql...
PROMPT      → 4 role: r_uczen, r_nauczyciel, r_sekretariat, r_administrator
PROMPT      → UWAGA: Wymaga uprawnień DBA!
-- Zakomentuj poniższą linię jeśli nie masz uprawnień DBA:
@06_role.sql

-- ============================================================================
-- KROK 7: UŻYTKOWNICY (wymaga DBA)
-- ============================================================================
PROMPT
PROMPT [7/9] Wykonywanie 07_uzytkownicy.sql...
PROMPT      → 5 użytkowników testowych
PROMPT      → UWAGA: Wymaga uprawnień DBA!
-- Zakomentuj poniższą linię jeśli nie masz uprawnień DBA:
@07_uzytkownicy.sql

-- ============================================================================
-- KROK 8: WIDOKI
-- ============================================================================
PROMPT
PROMPT [8/9] Wykonywanie 08_widoki.sql...
PROMPT      → 8 widoków raportowych
@08_widoki.sql

-- ============================================================================
-- KROK 9: TESTY
-- ============================================================================
PROMPT
PROMPT [9/9] Wykonywanie 09_testy.sql...
PROMPT      → 24 testy automatyczne
@09_testy.sql

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================

PROMPT
PROMPT ╔═══════════════════════════════════════════════════════════════════════╗
PROMPT ║                    INSTALACJA ZAKOŃCZONA!                             ║
PROMPT ╚═══════════════════════════════════════════════════════════════════════╝
PROMPT
PROMPT   UTWORZONE OBIEKTY:
PROMPT   ══════════════════
PROMPT     ● Typy obiektowe:  12 (t_*_obj)
PROMPT     ● VARRAY:           2 (t_lista_instrumentow, t_lista_sprzetu)
PROMPT     ● Tabele:          10 (t_semestr, t_instrument, ...)
PROMPT     ● Sekwencje:       10 (seq_*)
PROMPT     ● Triggery:         6 (trg_*)
PROMPT     ● Pakiety:          6 (pkg_uczen, pkg_nauczyciel, pkg_lekcja, ...)
PROMPT     ● Widoki:           8 (v_*)
PROMPT     ● Role:             4 (r_uczen, r_nauczyciel, r_sekretariat, r_administrator)
PROMPT     ● Użytkownicy:      5 (uczen_ala, uczen_bartek, nauczyciel_jan, ...)
PROMPT
PROMPT   DANE TESTOWE:
PROMPT   ═════════════
PROMPT     ● 1 semestr (zimowy 2025/26)
PROMPT     ● 6 instrumentów
PROMPT     ● 5 sal
PROMPT     ● 4 nauczycieli
PROMPT     ● 6 uczniów
PROMPT     ● 10 lekcji
PROMPT     ● 2 egzaminy
PROMPT     ● 7 ocen
PROMPT
PROMPT   QUICK START:
PROMPT   ════════════
PROMPT     -- Plan lekcji ucznia
PROMPT     EXEC pkg_raport.plan_ucznia(1);
PROMPT
PROMPT     -- Dodaj lekcję (z walidacją konfliktów!)
PROMPT     DECLARE v_id NUMBER;
PROMPT     BEGIN
PROMPT       pkg_lekcja.dodaj_lekcje(
PROMPT         'indywidualna', DATE '2026-01-17', '15:00', 45,
PROMPT         (SELECT REF(s) FROM t_sala s WHERE numer_sali='101'),
PROMPT         (SELECT REF(n) FROM t_nauczyciel n WHERE nazwisko='Kowalski'),
PROMPT         (SELECT REF(p) FROM t_przedmiot p WHERE nazwa='Instrument główny'),
PROMPT         (SELECT REF(s) FROM t_semestr s WHERE rok_akademicki='2025/26'),
PROMPT         (SELECT REF(u) FROM t_uczen u WHERE imie='Ala'),
PROMPT         NULL, v_id
PROMPT       );
PROMPT     END;
PROMPT
PROMPT     -- Uruchom testy
PROMPT     EXEC pkg_test.uruchom_wszystkie;
PROMPT
PROMPT   DOKUMENTACJA:
PROMPT   ═════════════
PROMPT     Każdy plik .sql zawiera szczegółowe komentarze wyjaśniające:
PROMPT     - CO robi dany obiekt
PROMPT     - DLACZEGO został zaprojektowany w ten sposób
PROMPT     - JAK go używać
PROMPT
PROMPT ═══════════════════════════════════════════════════════════════════════
PROMPT

SET TIMING OFF
SET FEEDBACK ON
