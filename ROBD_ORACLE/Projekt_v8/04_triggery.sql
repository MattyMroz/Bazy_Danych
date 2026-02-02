-- ============================================================================
-- SZKOŁA MUZYCZNA I STOPNIA - TRIGGERY (UPROSZCZONE)
-- Autorzy: Igor Typiński (251237), Mateusz Mróz (251190)
-- ============================================================================

-- ============================================================================
-- TRIGGER 1: Walidacja XOR dla lekcji (albo uczeń ALBO grupa)
-- Najważniejszy trigger - zapewnia poprawność danych!
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_lekcja_xor
BEFORE INSERT OR UPDATE ON lekcje
FOR EACH ROW
BEGIN
    -- XOR: dokładnie jedno musi być wypełnione
    IF (:NEW.ref_uczen IS NULL AND :NEW.ref_grupa IS NULL) OR
       (:NEW.ref_uczen IS NOT NULL AND :NEW.ref_grupa IS NOT NULL) THEN
        RAISE_APPLICATION_ERROR(-20001, 
            'Lekcja musi mieć ALBO ucznia (indywidualna) ALBO grupę (grupowa)');
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 2: Walidacja zakresu ocen (1-6)
-- Przyjazny komunikat zamiast technicznego błędu CHECK constraint
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_ocena_zakres
BEFORE INSERT OR UPDATE ON oceny
FOR EACH ROW
BEGIN
    IF :NEW.wartosc < 1 OR :NEW.wartosc > 6 THEN
        RAISE_APPLICATION_ERROR(-20002, 
            'Ocena musi być w zakresie 1-6. Podano: ' || :NEW.wartosc);
    END IF;
END;
/

-- ============================================================================
-- Weryfikacja triggerów
-- ============================================================================
SELECT trigger_name, table_name, status, trigger_type
FROM user_triggers
WHERE table_name IN ('LEKCJE', 'OCENY')
ORDER BY table_name, trigger_name;
