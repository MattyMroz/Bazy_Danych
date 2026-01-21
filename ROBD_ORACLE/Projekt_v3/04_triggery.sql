-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 04_triggery.sql
-- Opis: Wyzwalacze walidacyjne i biznesowe
-- Wersja: 3.0 (uproszczona)
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- ============================================================================
-- TRIGGER 1: TRG_UCZEN_WIEK
-- Walidacja minimalnego wieku ucznia (5 lat)
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_uczen_wiek
BEFORE INSERT OR UPDATE OF data_urodzenia ON t_uczen
FOR EACH ROW
DECLARE
    v_wiek NUMBER;
BEGIN
    v_wiek := TRUNC(MONTHS_BETWEEN(SYSDATE, :NEW.data_urodzenia) / 12);
    
    IF v_wiek < 5 THEN
        RAISE_APPLICATION_ERROR(-20101, 
            'Uczen musi miec co najmniej 5 lat. Wiek: ' || v_wiek);
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 2: TRG_LEKCJA_DNI_ROBOCZE
-- Lekcje tylko od poniedzialku do piatku
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_lekcja_dni_robocze
BEFORE INSERT OR UPDATE OF data_lekcji ON t_lekcja
FOR EACH ROW
DECLARE
    v_dzien VARCHAR2(10);
BEGIN
    v_dzien := TO_CHAR(:NEW.data_lekcji, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH');
    
    IF v_dzien IN ('SAT', 'SUN') THEN
        RAISE_APPLICATION_ERROR(-20102, 
            'Lekcje mozliwe tylko w dni robocze (Pn-Pt). ' ||
            'Data: ' || TO_CHAR(:NEW.data_lekcji, 'YYYY-MM-DD') || ' to ' || v_dzien);
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 3: TRG_LEKCJA_GODZINY_DZIECKA
-- Dzieci (<15 lat) tylko w godzinach 14:00-19:00
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_lekcja_godziny_dziecka
BEFORE INSERT OR UPDATE ON t_lekcja
FOR EACH ROW
DECLARE
    v_uczen     t_uczen_obj;
    v_czy_dziecko CHAR(1);
    v_godz_start NUMBER;
    v_godz_end   NUMBER;
BEGIN
    -- Pobierz dane ucznia
    SELECT DEREF(:NEW.ref_uczen) INTO v_uczen FROM DUAL;
    v_czy_dziecko := v_uczen.czy_dziecko();
    
    IF v_czy_dziecko = 'T' THEN
        -- Konwersja godziny na liczbe
        v_godz_start := TO_NUMBER(SUBSTR(:NEW.godzina_start, 1, 2)) * 60 + 
                        TO_NUMBER(SUBSTR(:NEW.godzina_start, 4, 2));
        v_godz_end := v_godz_start + :NEW.czas_trwania;
        
        -- Dozwolone: 14:00 (840 min) - 19:00 (1140 min)
        IF v_godz_start < 840 OR v_godz_end > 1140 THEN
            RAISE_APPLICATION_ERROR(-20103, 
                'Dziecko (ponizej 15 lat) moze miec lekcje tylko 14:00-19:00. ' ||
                'Uczen: ' || v_uczen.imie || ' ' || v_uczen.nazwisko || 
                ' (lat ' || v_uczen.wiek() || '), ' ||
                'Godzina: ' || :NEW.godzina_start);
        END IF;
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 4: TRG_LEKCJA_LIMIT_NAUCZYCIELA
-- Nauczyciel max 360 minut (6h) dziennie
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_lekcja_limit_nauczyciela
BEFORE INSERT OR UPDATE ON t_lekcja
FOR EACH ROW
DECLARE
    v_id_nauczyciela NUMBER;
    v_suma_minut NUMBER;
    v_naucz t_nauczyciel_obj;
BEGIN
    -- Tylko dla nowych zaplanowanych lekcji
    IF :NEW.status = 'zaplanowana' THEN
        SELECT DEREF(:NEW.ref_nauczyciel) INTO v_naucz FROM DUAL;
        v_id_nauczyciela := v_naucz.id_nauczyciela;
        
        -- Suma minut tego dnia (bez aktualnej lekcji przy UPDATE)
        SELECT NVL(SUM(l.czas_trwania), 0) INTO v_suma_minut
        FROM t_lekcja l
        WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = v_id_nauczyciela
          AND TRUNC(l.data_lekcji) = TRUNC(:NEW.data_lekcji)
          AND l.status IN ('zaplanowana', 'odbyta')
          AND l.id_lekcji != NVL(:NEW.id_lekcji, -1);
        
        IF v_suma_minut + :NEW.czas_trwania > 360 THEN
            RAISE_APPLICATION_ERROR(-20104, 
                'Nauczyciel ' || v_naucz.imie || ' ' || v_naucz.nazwisko || 
                ' przekroczylby limit 6h dziennie. ' ||
                'Aktualne obciazenie: ' || v_suma_minut || ' min, ' ||
                'nowa lekcja: ' || :NEW.czas_trwania || ' min');
        END IF;
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 5: TRG_LEKCJA_LIMIT_UCZNIA
-- Uczen max 2 lekcje dziennie
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_lekcja_limit_ucznia
BEFORE INSERT OR UPDATE ON t_lekcja
FOR EACH ROW
DECLARE
    v_uczen t_uczen_obj;
    v_liczba_lekcji NUMBER;
BEGIN
    IF :NEW.status = 'zaplanowana' THEN
        SELECT DEREF(:NEW.ref_uczen) INTO v_uczen FROM DUAL;
        
        SELECT COUNT(*) INTO v_liczba_lekcji
        FROM t_lekcja l
        WHERE DEREF(l.ref_uczen).id_ucznia = v_uczen.id_ucznia
          AND TRUNC(l.data_lekcji) = TRUNC(:NEW.data_lekcji)
          AND l.status IN ('zaplanowana', 'odbyta')
          AND l.id_lekcji != NVL(:NEW.id_lekcji, -1);
        
        IF v_liczba_lekcji >= 2 THEN
            RAISE_APPLICATION_ERROR(-20105, 
                'Uczen ' || v_uczen.imie || ' ' || v_uczen.nazwisko || 
                ' ma juz 2 lekcje tego dnia - limit osiagniety');
        END IF;
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 6: TRG_LEKCJA_KONFLIKT_SALI
-- Brak nakladania sie lekcji w tej samej sali
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_lekcja_konflikt_sali
BEFORE INSERT OR UPDATE ON t_lekcja
FOR EACH ROW
DECLARE
    v_sala t_sala_obj;
    v_konflikt NUMBER;
    v_godz_start_new NUMBER;
    v_godz_end_new NUMBER;
BEGIN
    IF :NEW.status = 'zaplanowana' THEN
        SELECT DEREF(:NEW.ref_sala) INTO v_sala FROM DUAL;
        
        v_godz_start_new := TO_NUMBER(SUBSTR(:NEW.godzina_start, 1, 2)) * 60 + 
                            TO_NUMBER(SUBSTR(:NEW.godzina_start, 4, 2));
        v_godz_end_new := v_godz_start_new + :NEW.czas_trwania;
        
        SELECT COUNT(*) INTO v_konflikt
        FROM t_lekcja l
        WHERE DEREF(l.ref_sala).id_sali = v_sala.id_sali
          AND TRUNC(l.data_lekcji) = TRUNC(:NEW.data_lekcji)
          AND l.status = 'zaplanowana'
          AND l.id_lekcji != NVL(:NEW.id_lekcji, -1)
          AND (
              -- Nowa lekcja zaczyna sie w trakcie istniejacej
              (v_godz_start_new >= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                   TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))
               AND v_godz_start_new < TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                       TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania)
              OR
              -- Nowa lekcja konczy sie w trakcie istniejacej
              (v_godz_end_new > TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))
               AND v_godz_end_new <= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                      TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania)
              OR
              -- Nowa lekcja zawiera istniejaca
              (v_godz_start_new <= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                    TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))
               AND v_godz_end_new >= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                      TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania)
          );
        
        IF v_konflikt > 0 THEN
            RAISE_APPLICATION_ERROR(-20106, 
                'Konflikt sali "' || v_sala.nazwa || '" - ' ||
                'w tym czasie jest juz zaplanowana inna lekcja');
        END IF;
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 7: TRG_LEKCJA_KONFLIKT_NAUCZYCIELA
-- Nauczyciel nie moze prowadzic dwoch lekcji naraz
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_lekcja_konflikt_nauczyciela
BEFORE INSERT OR UPDATE ON t_lekcja
FOR EACH ROW
DECLARE
    v_naucz t_nauczyciel_obj;
    v_konflikt NUMBER;
    v_godz_start_new NUMBER;
    v_godz_end_new NUMBER;
BEGIN
    IF :NEW.status = 'zaplanowana' THEN
        SELECT DEREF(:NEW.ref_nauczyciel) INTO v_naucz FROM DUAL;
        
        v_godz_start_new := TO_NUMBER(SUBSTR(:NEW.godzina_start, 1, 2)) * 60 + 
                            TO_NUMBER(SUBSTR(:NEW.godzina_start, 4, 2));
        v_godz_end_new := v_godz_start_new + :NEW.czas_trwania;
        
        SELECT COUNT(*) INTO v_konflikt
        FROM t_lekcja l
        WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = v_naucz.id_nauczyciela
          AND TRUNC(l.data_lekcji) = TRUNC(:NEW.data_lekcji)
          AND l.status = 'zaplanowana'
          AND l.id_lekcji != NVL(:NEW.id_lekcji, -1)
          AND (
              (v_godz_start_new >= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                   TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))
               AND v_godz_start_new < TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                       TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania)
              OR
              (v_godz_end_new > TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))
               AND v_godz_end_new <= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                      TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania)
              OR
              (v_godz_start_new <= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                    TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))
               AND v_godz_end_new >= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                      TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania)
          );
        
        IF v_konflikt > 0 THEN
            RAISE_APPLICATION_ERROR(-20107, 
                'Nauczyciel ' || v_naucz.imie || ' ' || v_naucz.nazwisko || 
                ' ma juz lekcje w tym czasie');
        END IF;
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 8: TRG_LEKCJA_KONFLIKT_UCZNIA
-- Uczen nie moze byc na dwoch lekcjach naraz
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_lekcja_konflikt_ucznia
BEFORE INSERT OR UPDATE ON t_lekcja
FOR EACH ROW
DECLARE
    v_uczen t_uczen_obj;
    v_konflikt NUMBER;
    v_godz_start_new NUMBER;
    v_godz_end_new NUMBER;
BEGIN
    IF :NEW.status = 'zaplanowana' THEN
        SELECT DEREF(:NEW.ref_uczen) INTO v_uczen FROM DUAL;
        
        v_godz_start_new := TO_NUMBER(SUBSTR(:NEW.godzina_start, 1, 2)) * 60 + 
                            TO_NUMBER(SUBSTR(:NEW.godzina_start, 4, 2));
        v_godz_end_new := v_godz_start_new + :NEW.czas_trwania;
        
        SELECT COUNT(*) INTO v_konflikt
        FROM t_lekcja l
        WHERE DEREF(l.ref_uczen).id_ucznia = v_uczen.id_ucznia
          AND TRUNC(l.data_lekcji) = TRUNC(:NEW.data_lekcji)
          AND l.status = 'zaplanowana'
          AND l.id_lekcji != NVL(:NEW.id_lekcji, -1)
          AND (
              (v_godz_start_new >= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                   TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))
               AND v_godz_start_new < TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                       TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania)
              OR
              (v_godz_end_new > TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))
               AND v_godz_end_new <= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                      TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania)
              OR
              (v_godz_start_new <= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                    TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))
               AND v_godz_end_new >= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                      TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania)
          );
        
        IF v_konflikt > 0 THEN
            RAISE_APPLICATION_ERROR(-20108, 
                'Uczen ' || v_uczen.imie || ' ' || v_uczen.nazwisko || 
                ' ma juz lekcje w tym czasie');
        END IF;
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 9: TRG_BLOKADA_USUN_NAUCZYCIELA
-- Blokada usuwania nauczyciela z zaplanowanymi lekcjami
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_blokada_usun_nauczyciela
BEFORE DELETE ON t_nauczyciel
FOR EACH ROW
DECLARE
    v_lekcje NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_lekcje
    FROM t_lekcja l
    WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = :OLD.id_nauczyciela
      AND l.status = 'zaplanowana';
    
    IF v_lekcje > 0 THEN
        RAISE_APPLICATION_ERROR(-20109, 
            'Nie mozna usunac nauczyciela ' || :OLD.imie || ' ' || :OLD.nazwisko || 
            ' - ma ' || v_lekcje || ' zaplanowanych lekcji');
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 10: TRG_BLOKADA_USUN_UCZNIA
-- Blokada usuwania ucznia z zaplanowanymi lekcjami
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_blokada_usun_ucznia
BEFORE DELETE ON t_uczen
FOR EACH ROW
DECLARE
    v_lekcje NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_lekcje
    FROM t_lekcja l
    WHERE DEREF(l.ref_uczen).id_ucznia = :OLD.id_ucznia
      AND l.status = 'zaplanowana';
    
    IF v_lekcje > 0 THEN
        RAISE_APPLICATION_ERROR(-20110, 
            'Nie mozna usunac ucznia ' || :OLD.imie || ' ' || :OLD.nazwisko || 
            ' - ma ' || v_lekcje || ' zaplanowanych lekcji');
    END IF;
END;
/

-- ============================================================================
-- PODSUMOWANIE TRIGGEROW - WERSJA 3.0
-- ============================================================================
/*
Utworzono 10 triggerow:

WALIDACJE PODSTAWOWE:
1. trg_uczen_wiek              - min. 5 lat
2. trg_lekcja_dni_robocze      - tylko Pn-Pt
3. trg_lekcja_godziny_dziecka  - dzieci 14:00-19:00

LIMITY:
4. trg_lekcja_limit_nauczyciela - max 6h/dzien
5. trg_lekcja_limit_ucznia      - max 2 lekcje/dzien

KONFLIKTY:
6. trg_lekcja_konflikt_sali       - bez nakladania sal
7. trg_lekcja_konflikt_nauczyciela - nauczyciel w 1 miejscu
8. trg_lekcja_konflikt_ucznia      - uczen w 1 miejscu

BLOKADY USUWANIA:
9. trg_blokada_usun_nauczyciela - ochrona danych
10. trg_blokada_usun_ucznia      - ochrona danych

Kody bledow:
-20101: Wiek ucznia
-20102: Weekend
-20103: Godziny dziecka
-20104: Limit nauczyciela
-20105: Limit ucznia
-20106: Konflikt sali
-20107: Konflikt nauczyciela
-20108: Konflikt ucznia
-20109: Usuwanie nauczyciela
-20110: Usuwanie ucznia
*/
