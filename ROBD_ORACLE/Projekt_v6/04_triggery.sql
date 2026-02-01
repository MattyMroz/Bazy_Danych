-- ============================================================================
-- Projekt: Szkola Muzyczna - Obiektowa Baza Danych
-- Plik: 04_triggery_v2.sql
-- Opis: Triggery walidacyjne - WERSJA MINIMALNA (bez DEREF w triggerach)
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================
--
-- WAZNE: Wiekszosc walidacji przeniesiona do PAKIETOW (PKG_LEKCJE, PKG_OCENY)
-- aby uniknac bledow ORA-00600 zwiazanych z DEREF w triggerach BEFORE INSERT.
--
-- Triggery tutaj sa MINIMALNE - sprawdzaja tylko proste warunki na kolumnach
-- bez uzycia DEREF na REF.
-- ============================================================================

-- ============================================================================
-- 1. USUNIECIE ISTNIEJACYCH TRIGGEROW
-- ============================================================================

BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_ocena_zakres'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_godziny_pracy'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_sala_wyposazenie'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_dzien_tygodnia'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_przedmiot_instrument_ucznia'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_nauczyciel_uczy_instrumentu'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_chor_orkiestra_walidacja'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_limit_uczniow_w_grupie'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_max_godzin_nauczyciela'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ============================================================================
-- 2. TRIGGER: Walidacja zakresu oceny (1-6)
-- ============================================================================
-- Nie wymaga DEREF - sprawdza tylko wartosc liczbowa.

CREATE OR REPLACE TRIGGER trg_ocena_zakres
BEFORE INSERT OR UPDATE ON OCENY
FOR EACH ROW
DECLARE
BEGIN
    IF :NEW.wartosc < 1 OR :NEW.wartosc > 6 THEN
        RAISE_APPLICATION_ERROR(-20105,
            'Ocena musi byc w zakresie 1-6. Podano: ' || :NEW.wartosc);
    END IF;
END;
/

-- ============================================================================
-- 3. TRIGGER: XOR uczeń/grupa w lekcji
-- ============================================================================
-- Lekcja musi miec ALBO ucznia ALBO grupe (nie oba, nie zadnego).
-- Sprawdza tylko czy REF jest NULL/NOT NULL - bez DEREF.

CREATE OR REPLACE TRIGGER trg_lekcja_xor
BEFORE INSERT OR UPDATE ON LEKCJE
FOR EACH ROW
DECLARE
BEGIN
    -- XOR: dokladnie jeden musi byc NOT NULL
    IF :NEW.ref_uczen IS NOT NULL AND :NEW.ref_grupa IS NOT NULL THEN
        RAISE_APPLICATION_ERROR(-20103,
            'Lekcja nie moze byc jednoczesnie indywidualna i grupowa');
    END IF;

    IF :NEW.ref_uczen IS NULL AND :NEW.ref_grupa IS NULL THEN
        RAISE_APPLICATION_ERROR(-20104,
            'Lekcja musi miec przypisanego ucznia lub grupe');
    END IF;
END;
/

-- ============================================================================
-- 4. TRIGGER: Walidacja czasu trwania
-- ============================================================================
-- Czas trwania musi byc 30, 45, 60 lub 90 minut.

CREATE OR REPLACE TRIGGER trg_czas_trwania
BEFORE INSERT OR UPDATE ON LEKCJE
FOR EACH ROW
DECLARE
BEGIN
    IF :NEW.czas_trwania_min NOT IN (30, 45, 60, 90) THEN
        RAISE_APPLICATION_ERROR(-20121,
            'Czas trwania musi byc 30, 45, 60 lub 90 minut. Podano: ' || :NEW.czas_trwania_min);
    END IF;
END;
/

-- ============================================================================
-- 5. TRIGGER: Walidacja formatu godziny
-- ============================================================================
-- Godzina musi byc w formacie HH:MI (np. '14:00', '15:30').

CREATE OR REPLACE TRIGGER trg_format_godziny
BEFORE INSERT OR UPDATE ON LEKCJE
FOR EACH ROW
DECLARE
    v_godzina NUMBER;
    v_minuta NUMBER;
BEGIN
    -- Sprawdz dlugosc
    IF LENGTH(:NEW.godzina_start) != 5 THEN
        RAISE_APPLICATION_ERROR(-20122,
            'Godzina musi byc w formacie HH:MI (np. 14:00)');
    END IF;

    -- Sprawdz separator
    IF SUBSTR(:NEW.godzina_start, 3, 1) != ':' THEN
        RAISE_APPLICATION_ERROR(-20122,
            'Godzina musi byc w formacie HH:MI (np. 14:00)');
    END IF;

    -- Sprobuj sparsowac
    BEGIN
        v_godzina := TO_NUMBER(SUBSTR(:NEW.godzina_start, 1, 2));
        v_minuta := TO_NUMBER(SUBSTR(:NEW.godzina_start, 4, 2));
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20122,
                'Godzina musi byc w formacie HH:MI (np. 14:00)');
    END;

    -- Sprawdz zakres
    IF v_godzina < 0 OR v_godzina > 23 THEN
        RAISE_APPLICATION_ERROR(-20122,
            'Godzina musi byc w zakresie 00-23');
    END IF;

    IF v_minuta < 0 OR v_minuta > 59 THEN
        RAISE_APPLICATION_ERROR(-20122,
            'Minuty musza byc w zakresie 00-59');
    END IF;
END;
/

-- ============================================================================
-- 6. TRIGGER: Walidacja obszaru oceny
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_obszar_oceny
BEFORE INSERT OR UPDATE ON OCENY
FOR EACH ROW
DECLARE
BEGIN
    IF :NEW.obszar IS NOT NULL AND 
       :NEW.obszar NOT IN ('technika', 'interpretacja', 'postepy', 'teoria', 'sluch', 'ogolna') THEN
        RAISE_APPLICATION_ERROR(-20125,
            'Obszar oceny musi byc jednym z: technika, interpretacja, postepy, teoria, sluch, ogolna');
    END IF;
END;
/

-- ============================================================================
-- 7. TRIGGER: Walidacja flagi semestralnej oceny
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_czy_semestralna
BEFORE INSERT OR UPDATE ON OCENY
FOR EACH ROW
DECLARE
BEGIN
    IF :NEW.czy_semestralna IS NOT NULL AND 
       :NEW.czy_semestralna NOT IN ('T', 'N') THEN
        RAISE_APPLICATION_ERROR(-20126,
            'Flaga czy_semestralna musi byc "T" lub "N"');
    END IF;
END;
/

-- ============================================================================
-- 8. POTWIERDZENIE
-- ============================================================================

SELECT 'Triggery utworzone pomyslnie!' AS status FROM DUAL;

SELECT trigger_name, table_name, status 
FROM user_triggers 
ORDER BY table_name, trigger_name;
