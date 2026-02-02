-- ============================================================================
-- SZKOŁA MUZYCZNA I STOPNIA - SKRYPT GŁÓWNY (URUCHOM TEN PLIK!)
-- Autorzy: Igor Typiński (251237), Mateusz Mróz (251190)
-- ============================================================================
-- Ten skrypt uruchamia wszystkie pliki w odpowiedniej kolejności
-- ============================================================================

SET SERVEROUTPUT ON;
SET ECHO ON;

PROMPT ============================================================
PROMPT SZKOŁA MUZYCZNA I STOPNIA - INSTALACJA BAZY DANYCH
PROMPT ============================================================

PROMPT
PROMPT [1/5] Tworzenie typów obiektowych...
@01_typy.sql

PROMPT
PROMPT [2/5] Tworzenie tabel obiektowych...
@02_tabele.sql

PROMPT
PROMPT [3/5] Tworzenie pakietów PL/SQL...
@03_pakiety.sql

PROMPT
PROMPT [4/5] Tworzenie triggerów...
@04_triggery.sql

PROMPT
PROMPT [5/5] Ładowanie danych testowych...
@05_dane.sql

PROMPT
PROMPT ============================================================
PROMPT INSTALACJA ZAKOŃCZONA POMYŚLNIE!
PROMPT ============================================================
PROMPT
PROMPT Aby uruchomić scenariusze demonstracyjne:
PROMPT @06_scenariusze.sql
PROMPT
PROMPT ============================================================

-- Podsumowanie
EXEC pkg_raporty.statystyki_ogolne;
