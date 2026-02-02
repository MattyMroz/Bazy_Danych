-- ============================================================================
-- SZKOŁA MUZYCZNA I STOPNIA - TRIGGERY
-- Autorzy: Igor Typiński (251237), Mateusz Mróz (251190)
-- ============================================================================

-- ============================================================================
-- TRIGGER: Walidacja ocen (zakres 1-6)
-- UWAGA: Tabela oceny ma już CHECK (wartosc BETWEEN 1 AND 6).
-- Ten trigger jest CELOWO redundantny - zapewnia przyjazny komunikat błędu
-- zamiast technicznego ORA-02290 (constraint violation).
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_ocena_zakres
BEFORE INSERT OR UPDATE ON oceny
FOR EACH ROW
BEGIN
    IF :NEW.wartosc < 1 OR :NEW.wartosc > 6 THEN
        RAISE_APPLICATION_ERROR(-20005, 
            'Ocena musi być w zakresie 1-6. Podano: ' || :NEW.wartosc);
    END IF;
END;
/

-- ============================================================================
-- TRIGGER: Walidacja XOR dla lekcji (albo uczeń ALBO grupa)
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_lekcja_xor
BEFORE INSERT OR UPDATE ON lekcje
FOR EACH ROW
BEGIN
    -- XOR: dokładnie jedno musi być wypełnione
    IF (:NEW.ref_uczen IS NULL AND :NEW.ref_grupa IS NULL) OR
       (:NEW.ref_uczen IS NOT NULL AND :NEW.ref_grupa IS NOT NULL) THEN
        RAISE_APPLICATION_ERROR(-20006, 
            'Lekcja musi mieć przypisanego ALBO ucznia (indywidualna) ALBO grupę (grupowa), nie oba lub żaden.');
    END IF;
END;
/

-- ============================================================================
-- TRIGGER: Walidacja godzin pracy - OSTATNIA LINIA OBRONY
-- ============================================================================
-- UWAGA ARCHITEKTONICZNA:
-- Walidacja dni roboczych jest CELOWO zdublowana z pkg_lekcje.czy_dzien_roboczy().
-- - Pakiet: pierwsza linia obrony, przyjazne komunikaty dla użytkownika API
-- - Trigger: ostatnia linia obrony przy bezpośrednich INSERT/UPDATE SQL
-- 
-- Jeśli zmienisz godziny/dni pracy, zmień:
-- 1. pkg_lekcje.c_godz_min, c_godz_max (stałe konfiguracyjne)
-- 2. Ten trigger (dla spójności)
-- 3. CHECK constraint w tabeli lekcje (opcjonalnie)
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_lekcja_godziny
BEFORE INSERT OR UPDATE ON lekcje
FOR EACH ROW
DECLARE
    v_dzien NUMBER;
    -- Stałe powinny być zsynchronizowane z pkg_lekcje
    c_godz_min CONSTANT NUMBER := 14;
    c_godz_max CONSTANT NUMBER := 19;
BEGIN
    -- Walidacja godzin (używa lokalnych stałych dla czytelności)
    IF :NEW.godz_rozp < c_godz_min OR :NEW.godz_rozp > c_godz_max THEN
        RAISE_APPLICATION_ERROR(-20007, 
            'Lekcje tylko w godzinach ' || c_godz_min || ':00-' || (c_godz_max+1) || ':00. Podano: ' || :NEW.godz_rozp || ':00');
    END IF;
    
    -- Oblicz dzień tygodnia: 1=Pon, 7=Nd (niezależne od NLS!)
    -- Trik: TRUNC z 'IW' daje poniedziałek danego tygodnia ISO
    v_dzien := TRUNC(:NEW.data_lekcji) - TRUNC(:NEW.data_lekcji, 'IW') + 1;
    
    -- Walidacja dnia roboczego (1-5 = Pon-Pt)
    IF v_dzien NOT BETWEEN 1 AND 5 THEN
        RAISE_APPLICATION_ERROR(-20008, 
            'Lekcje tylko w dni robocze (Pon-Pt). Data: ' || 
            TO_CHAR(:NEW.data_lekcji, 'YYYY-MM-DD') || 
            ', dzień tygodnia: ' || v_dzien || ' (1=Pon, 6=Sob, 7=Nd)');
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
