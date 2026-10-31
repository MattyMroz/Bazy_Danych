-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 04_triggery.sql
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- Opis: Proste wyzwalacze walidacyjne (logika biznesowa w pakiecie pkg_lekcja)
-- ============================================================================

-- ============================================================================
-- TRIGGER 1: TRG_UCZEN_WIEK - Walidacja minimalnego wieku ucznia (5 lat)
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_uczen_wiek
BEFORE INSERT OR UPDATE OF data_urodzenia ON t_uczen
FOR EACH ROW
DECLARE
    v_wiek NUMBER;
BEGIN
    v_wiek := TRUNC(MONTHS_BETWEEN(SYSDATE, :NEW.data_urodzenia) / 12);
    IF v_wiek < 5 THEN
        RAISE_APPLICATION_ERROR(-20101, 'Uczen musi miec co najmniej 5 lat.');
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 2: TRG_LEKCJA_DNI_ROBOCZE - Lekcje tylko od poniedzialku do piatku
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_lekcja_dni_robocze
BEFORE INSERT OR UPDATE OF data_lekcji ON t_lekcja
FOR EACH ROW
DECLARE
    v_dzien VARCHAR2(10);
BEGIN
    v_dzien := TO_CHAR(:NEW.data_lekcji, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH');
    IF v_dzien IN ('SAT', 'SUN') THEN
        RAISE_APPLICATION_ERROR(-20102, 'Lekcje mozliwe tylko w dni robocze (Pn-Pt).');
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 3: TRG_LEKCJA_GODZINY_DZIECKA - Dzieci (<15 lat) 14:00-19:00
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_lekcja_godziny_dziecka
BEFORE INSERT OR UPDATE ON t_lekcja
FOR EACH ROW
DECLARE
    v_uczen t_uczen_obj;
    v_godz_start NUMBER;
    v_godz_end NUMBER;
BEGIN
    SELECT DEREF(:NEW.ref_uczen) INTO v_uczen FROM DUAL;
    IF v_uczen IS NOT NULL AND v_uczen.czy_dziecko() = 'T' THEN
        v_godz_start := TO_NUMBER(SUBSTR(:NEW.godzina_start, 1, 2)) * 60 +
                        TO_NUMBER(SUBSTR(:NEW.godzina_start, 4, 2));
        v_godz_end := v_godz_start + :NEW.czas_trwania;

        IF v_godz_start < 840 OR v_godz_end > 1140 THEN -- 14:00 - 19:00
            RAISE_APPLICATION_ERROR(-20103, 'Dzieci moga miec lekcje tylko 14:00-19:00.');
        END IF;
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 4: TRG_BLOKADA_USUN_NAUCZYCIELA
-- Blokuje usuniecie nauczyciela ktory ma lekcje w historii
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_blokada_usun_nauczyciela
BEFORE DELETE ON t_nauczyciel
FOR EACH ROW
DECLARE
    v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM t_lekcja l
    WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = :OLD.id_nauczyciela;
    IF v_cnt > 0 THEN
        RAISE_APPLICATION_ERROR(-20109, 'Nie mozna usunac nauczyciela z historia lekcji.');
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 5: TRG_BLOKADA_USUN_UCZNIA
-- Blokuje usuniecie ucznia ktory ma lekcje w historii
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_blokada_usun_ucznia
BEFORE DELETE ON t_uczen
FOR EACH ROW
DECLARE
    v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM t_lekcja l WHERE DEREF(l.ref_uczen).id_ucznia = :OLD.id_ucznia;
    IF v_cnt > 0 THEN
        RAISE_APPLICATION_ERROR(-20110, 'Nie mozna usunac ucznia z historia lekcji.');
    END IF;
END;
/

-- ============================================================================
-- UWAGA DLA PROWADZACEGO:
-- Walidacja konfliktow (sala, nauczyciel, uczen) oraz limitow (6h nauczyciel,
-- 2 lekcje uczen) zostala przeniesiona do pakietu pkg_lekcja.zaplanuj().
-- Dzieki temu unikamy bledu ORA-04091 (Mutating Table), ktory wystepuje
-- przy odczytywaniu tabeli w triggerze FOR EACH ROW.
-- ============================================================================
