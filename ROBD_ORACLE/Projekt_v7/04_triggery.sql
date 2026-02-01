-- ============================================================================
-- Projekt: Szkola Muzyczna - Obiektowa Baza Danych (UPROSZCZONA)
-- Plik: 04_triggery.sql
-- Opis: Minimalne triggery (tylko niezbedne)
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- Wersja: 7.0
-- ============================================================================

SET SERVEROUTPUT ON;

-- ============================================================================
-- 1. TRIGGER: Walidacja zakresu oceny (1-6)
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_ocena_zakres
BEFORE INSERT OR UPDATE ON OCENY
FOR EACH ROW
BEGIN
    IF :NEW.wartosc < 1 OR :NEW.wartosc > 6 THEN
        RAISE_APPLICATION_ERROR(-20201, 'Ocena musi byc w zakresie 1-6, podano: ' || :NEW.wartosc);
    END IF;
END;
/

-- ============================================================================
-- 2. TRIGGER: XOR - lekcja indywidualna LUB grupowa
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_lekcja_xor
BEFORE INSERT OR UPDATE ON LEKCJE
FOR EACH ROW
BEGIN
    IF :NEW.ref_uczen IS NOT NULL AND :NEW.ref_grupa IS NOT NULL THEN
        RAISE_APPLICATION_ERROR(-20202, 'Lekcja nie moze miec jednoczesnie ucznia i grupy');
    END IF;
    IF :NEW.ref_uczen IS NULL AND :NEW.ref_grupa IS NULL THEN
        RAISE_APPLICATION_ERROR(-20203, 'Lekcja musi miec przypisanego ucznia lub grupe');
    END IF;
END;
/

-- ============================================================================
-- 3. TRIGGER: Walidacja czasu trwania lekcji
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_czas_trwania
BEFORE INSERT OR UPDATE ON LEKCJE
FOR EACH ROW
BEGIN
    IF :NEW.czas_trwania_min NOT IN (30, 45, 60, 90) THEN
        RAISE_APPLICATION_ERROR(-20204, 'Czas trwania lekcji musi wynosic 30, 45, 60 lub 90 minut');
    END IF;
END;
/

-- ============================================================================
-- 4. TRIGGER: Automatyczne ustawienie daty zapisu ucznia
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_uczen_data_zapisu
BEFORE INSERT ON UCZNIOWIE
FOR EACH ROW
BEGIN
    IF :NEW.data_zapisu IS NULL THEN
        :NEW.data_zapisu := SYSDATE;
    END IF;
END;
/

-- ============================================================================
-- 5. TRIGGER: Log zmian w lekcjach (opcjonalny, do debugowania)
-- ============================================================================

-- CREATE OR REPLACE TRIGGER trg_lekcje_log
-- AFTER INSERT ON LEKCJE
-- FOR EACH ROW
-- BEGIN
--     DBMS_OUTPUT.PUT_LINE('Dodano lekcje ID=' || :NEW.id_lekcji || 
--         ' na ' || TO_CHAR(:NEW.data_lekcji, 'YYYY-MM-DD') || 
--         ' o ' || :NEW.godzina_start);
-- END;
-- /

-- ============================================================================
-- 6. POTWIERDZENIE
-- ============================================================================

SELECT trigger_name, status FROM user_triggers ORDER BY trigger_name;
