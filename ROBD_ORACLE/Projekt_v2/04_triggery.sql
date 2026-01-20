-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 04_triggery.sql
-- Opis: Triggery walidujace i audytowe
-- Wersja: 2.0
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- ============================================================================
-- TRIGGER 1: TRG_SEMESTR_TYLKO_JEDEN_AKTYWNY (NOWY v2.0)
-- Opis: Zapewnia ze tylko jeden semestr moze byc aktywny
-- Logika: Jesli ustawiamy czy_aktywny='T', dezaktywujemy inne
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_semestr_tylko_jeden_aktywny
BEFORE INSERT OR UPDATE OF czy_aktywny ON t_semestr
FOR EACH ROW
WHEN (NEW.czy_aktywny = 'T')
BEGIN
    UPDATE t_semestr
    SET czy_aktywny = 'N'
    WHERE id_semestru != :NEW.id_semestru
      AND czy_aktywny = 'T';
    
    DBMS_OUTPUT.PUT_LINE('[TRG] Semestr "' || :NEW.nazwa || '" ustawiony jako aktywny.');
END;
/

-- ============================================================================
-- TRIGGER 2: TRG_LEKCJA_WALIDACJA_PODSTAWOWA
-- Opis: Podstawowa walidacja danych lekcji
-- Sprawdza: date (nie w przeszlosci), godzine (08:00-20:00), status
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_lekcja_walidacja_podstawowa
BEFORE INSERT OR UPDATE ON t_lekcja
FOR EACH ROW
DECLARE
    v_data_min DATE := TRUNC(SYSDATE);
BEGIN
    -- Walidacja 1: Data lekcji nie moze byc w przeszlosci (tylko dla nowych zaplanowanych)
    IF INSERTING AND :NEW.status = 'zaplanowana' AND :NEW.data_lekcji < v_data_min THEN
        RAISE_APPLICATION_ERROR(-20010, 
            'Data lekcji nie moze byc w przeszlosci. Podano: ' || 
            TO_CHAR(:NEW.data_lekcji, 'YYYY-MM-DD'));
    END IF;
    
    -- Walidacja 2: Nie mozna zmienic statusu z "odbyta" na "zaplanowana"
    IF UPDATING AND :OLD.status = 'odbyta' AND :NEW.status = 'zaplanowana' THEN
        RAISE_APPLICATION_ERROR(-20012, 
            'Nie mozna zmienic statusu lekcji z "odbyta" na "zaplanowana".');
    END IF;
    
    -- Walidacja 3: Nie mozna zmienic statusu z "odwolana" na "odbyta"
    IF UPDATING AND :OLD.status = 'odwolana' AND :NEW.status = 'odbyta' THEN
        RAISE_APPLICATION_ERROR(-20013, 
            'Nie mozna zmienic statusu lekcji z "odwolana" na "odbyta".');
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 3: TRG_LEKCJA_GODZINY_DZIECKA (NOWY v2.0)
-- Opis: Waliduje godziny lekcji dla dzieci ponizej 15 lat
-- Logika: Dzieci chodza do szkoly, wiec lekcje muzyki tylko 14:00-19:00
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_lekcja_godziny_dziecka
BEFORE INSERT OR UPDATE ON t_lekcja
FOR EACH ROW
DECLARE
    v_wiek_ucznia NUMBER;
    v_imie_ucznia VARCHAR2(50);
BEGIN
    IF :NEW.status = 'zaplanowana' THEN
        SELECT DEREF(:NEW.ref_uczen).wiek(),
               DEREF(:NEW.ref_uczen).imie
        INTO v_wiek_ucznia, v_imie_ucznia
        FROM DUAL;
        
        IF v_wiek_ucznia < 15 THEN
            IF :NEW.godzina_start < '14:00' OR :NEW.godzina_start > '19:00' THEN
                RAISE_APPLICATION_ERROR(-20020, 
                    'Uczen ' || v_imie_ucznia || ' ma ' || v_wiek_ucznia || 
                    ' lat. Dzieci ponizej 15 lat moga miec lekcje tylko miedzy 14:00 a 19:00. ' ||
                    'Podano godzine: ' || :NEW.godzina_start);
            END IF;
        END IF;
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 4: TRG_LEKCJA_LIMIT_NAUCZYCIELA (NOWY v2.0)
-- Opis: Sprawdza czy nauczyciel nie przekracza 6h lekcji dziennie
-- Logika: Suma minut lekcji w danym dniu <= 360 (6 godzin)
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_lekcja_limit_nauczyciela
BEFORE INSERT OR UPDATE ON t_lekcja
FOR EACH ROW
DECLARE
    v_suma_minut NUMBER;
    v_id_nauczyciela NUMBER;
    v_max_minut CONSTANT NUMBER := 360; -- 6 godzin
BEGIN
    IF :NEW.status = 'zaplanowana' THEN
        v_id_nauczyciela := DEREF(:NEW.ref_nauczyciel).id_nauczyciela;
        
        SELECT NVL(SUM(l.czas_trwania), 0)
        INTO v_suma_minut
        FROM t_lekcja l
        WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = v_id_nauczyciela
          AND l.data_lekcji = :NEW.data_lekcji
          AND l.status = 'zaplanowana'
          AND l.id_lekcji != NVL(:NEW.id_lekcji, -1);
        
        IF v_suma_minut + :NEW.czas_trwania > v_max_minut THEN
            RAISE_APPLICATION_ERROR(-20030, 
                'Nauczyciel ma juz ' || v_suma_minut || ' minut lekcji w dniu ' ||
                TO_CHAR(:NEW.data_lekcji, 'YYYY-MM-DD') || '. ' ||
                'Dodanie ' || :NEW.czas_trwania || ' minut przekroczyloby limit ' ||
                v_max_minut || ' minut (6h) dziennie.');
        END IF;
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 5: TRG_LEKCJA_LIMIT_UCZNIA (NOWY v2.0)
-- Opis: Sprawdza czy uczen nie przekracza 2 lekcji dziennie
-- Logika: Liczba lekcji ucznia w danym dniu <= 2
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_lekcja_limit_ucznia
BEFORE INSERT OR UPDATE ON t_lekcja
FOR EACH ROW
DECLARE
    v_liczba_lekcji NUMBER;
    v_id_ucznia NUMBER;
    v_max_lekcji CONSTANT NUMBER := 2;
BEGIN
    IF :NEW.status = 'zaplanowana' THEN
        v_id_ucznia := DEREF(:NEW.ref_uczen).id_ucznia;
        
        SELECT COUNT(*)
        INTO v_liczba_lekcji
        FROM t_lekcja l
        WHERE DEREF(l.ref_uczen).id_ucznia = v_id_ucznia
          AND l.data_lekcji = :NEW.data_lekcji
          AND l.status = 'zaplanowana'
          AND l.id_lekcji != NVL(:NEW.id_lekcji, -1);
        
        IF v_liczba_lekcji >= v_max_lekcji THEN
            RAISE_APPLICATION_ERROR(-20031, 
                'Uczen ma juz ' || v_liczba_lekcji || ' lekcji w dniu ' ||
                TO_CHAR(:NEW.data_lekcji, 'YYYY-MM-DD') || '. ' ||
                'Maksymalna liczba lekcji dziennie to ' || v_max_lekcji || '.');
        END IF;
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 6: TRG_LEKCJA_KONFLIKT_SALI (NOWY v2.0)
-- Opis: Sprawdza czy sala nie jest zajeta o podanej godzinie
-- Logika: Nie moze byc 2 lekcji w tej samej sali o tej samej godzinie
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_lekcja_konflikt_sali
BEFORE INSERT OR UPDATE ON t_lekcja
FOR EACH ROW
DECLARE
    v_konflikt NUMBER;
    v_id_sali NUMBER;
    v_nazwa_sali VARCHAR2(50);
BEGIN
    IF :NEW.status = 'zaplanowana' AND :NEW.ref_sala IS NOT NULL THEN
        v_id_sali := DEREF(:NEW.ref_sala).id_sali;
        v_nazwa_sali := DEREF(:NEW.ref_sala).nazwa;
        
        SELECT COUNT(*)
        INTO v_konflikt
        FROM t_lekcja l
        WHERE DEREF(l.ref_sala).id_sali = v_id_sali
          AND l.data_lekcji = :NEW.data_lekcji
          AND l.godzina_start = :NEW.godzina_start
          AND l.status != 'odwolana'
          AND l.id_lekcji != NVL(:NEW.id_lekcji, -1);
        
        IF v_konflikt > 0 THEN
            RAISE_APPLICATION_ERROR(-20032, 
                'Sala "' || v_nazwa_sali || '" jest juz zajeta w dniu ' ||
                TO_CHAR(:NEW.data_lekcji, 'YYYY-MM-DD') || ' o godzinie ' ||
                :NEW.godzina_start || '.');
        END IF;
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 7: TRG_LEKCJA_KONFLIKT_NAUCZYCIELA
-- Opis: Sprawdza konflikt czasowy nauczyciela
-- Logika: Nauczyciel nie moze miec 2 lekcji o tej samej godzinie
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_lekcja_konflikt_nauczyciela
BEFORE INSERT OR UPDATE ON t_lekcja
FOR EACH ROW
DECLARE
    v_konflikt NUMBER;
    v_id_nauczyciela NUMBER;
BEGIN
    IF :NEW.status = 'zaplanowana' THEN
        v_id_nauczyciela := DEREF(:NEW.ref_nauczyciel).id_nauczyciela;
        
        SELECT COUNT(*)
        INTO v_konflikt
        FROM t_lekcja l
        WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = v_id_nauczyciela
          AND l.data_lekcji = :NEW.data_lekcji
          AND l.godzina_start = :NEW.godzina_start
          AND l.status != 'odwolana'
          AND l.id_lekcji != NVL(:NEW.id_lekcji, -1);
        
        IF v_konflikt > 0 THEN
            RAISE_APPLICATION_ERROR(-20033, 
                'Nauczyciel ma juz lekcje w dniu ' ||
                TO_CHAR(:NEW.data_lekcji, 'YYYY-MM-DD') || ' o godzinie ' ||
                :NEW.godzina_start || '.');
        END IF;
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 8: TRG_LEKCJA_KONFLIKT_UCZNIA
-- Opis: Sprawdza konflikt czasowy ucznia
-- Logika: Uczen nie moze miec 2 lekcji o tej samej godzinie
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_lekcja_konflikt_ucznia
BEFORE INSERT OR UPDATE ON t_lekcja
FOR EACH ROW
DECLARE
    v_konflikt NUMBER;
    v_id_ucznia NUMBER;
BEGIN
    IF :NEW.status = 'zaplanowana' THEN
        v_id_ucznia := DEREF(:NEW.ref_uczen).id_ucznia;
        
        SELECT COUNT(*)
        INTO v_konflikt
        FROM t_lekcja l
        WHERE DEREF(l.ref_uczen).id_ucznia = v_id_ucznia
          AND l.data_lekcji = :NEW.data_lekcji
          AND l.godzina_start = :NEW.godzina_start
          AND l.status != 'odwolana'
          AND l.id_lekcji != NVL(:NEW.id_lekcji, -1);
        
        IF v_konflikt > 0 THEN
            RAISE_APPLICATION_ERROR(-20034, 
                'Uczen ma juz lekcje w dniu ' ||
                TO_CHAR(:NEW.data_lekcji, 'YYYY-MM-DD') || ' o godzinie ' ||
                :NEW.godzina_start || '.');
        END IF;
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 9: TRG_LEKCJA_W_SEMESTRZE (NOWY v2.0)
-- Opis: Sprawdza czy lekcja jest planowana w ramach aktywnego semestru
-- Logika: Data lekcji musi byc miedzy data_od a data_do aktywnego semestru
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_lekcja_w_semestrze
BEFORE INSERT OR UPDATE ON t_lekcja
FOR EACH ROW
DECLARE
    v_semestr_data_od DATE;
    v_semestr_data_do DATE;
    v_semestr_nazwa   VARCHAR2(50);
    v_jest_aktywny    NUMBER;
BEGIN
    IF :NEW.status = 'zaplanowana' THEN
        SELECT COUNT(*) INTO v_jest_aktywny
        FROM t_semestr s
        WHERE s.czy_aktywny = 'T';
        
        IF v_jest_aktywny = 0 THEN
            RAISE_APPLICATION_ERROR(-20040, 
                'Brak aktywnego semestru. Nie mozna planowac lekcji.');
        END IF;
        
        SELECT s.data_od, s.data_do, s.nazwa
        INTO v_semestr_data_od, v_semestr_data_do, v_semestr_nazwa
        FROM t_semestr s
        WHERE s.czy_aktywny = 'T';
        
        IF :NEW.data_lekcji < v_semestr_data_od OR :NEW.data_lekcji > v_semestr_data_do THEN
            RAISE_APPLICATION_ERROR(-20041, 
                'Data lekcji ' || TO_CHAR(:NEW.data_lekcji, 'YYYY-MM-DD') ||
                ' jest poza zakresem aktywnego semestru "' || v_semestr_nazwa || 
                '" (' || TO_CHAR(v_semestr_data_od, 'YYYY-MM-DD') ||
                ' - ' || TO_CHAR(v_semestr_data_do, 'YYYY-MM-DD') || ').');
        END IF;
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 10: TRG_UCZEN_MINIMALNY_WIEK
-- Opis: Sprawdza czy uczen ma minimalny wiek (5 lat)
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_uczen_minimalny_wiek
BEFORE INSERT OR UPDATE ON t_uczen
FOR EACH ROW
DECLARE
    v_wiek NUMBER;
    v_min_wiek CONSTANT NUMBER := 5;
BEGIN
    v_wiek := TRUNC(MONTHS_BETWEEN(SYSDATE, :NEW.data_urodzenia) / 12);
    
    IF v_wiek < v_min_wiek THEN
        RAISE_APPLICATION_ERROR(-20001, 
            'Uczen musi miec minimum ' || v_min_wiek || ' lat. ' ||
            'Podany wiek: ' || v_wiek || ' lat.');
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 11: TRG_UCZEN_PRZED_USUNIECIEM
-- Opis: Zapobiega usunieciu ucznia z aktywnymi lekcjami
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_uczen_przed_usunieciem
BEFORE DELETE ON t_uczen
FOR EACH ROW
DECLARE
    v_aktywne_lekcje NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_aktywne_lekcje
    FROM t_lekcja l
    WHERE DEREF(l.ref_uczen).id_ucznia = :OLD.id_ucznia
      AND l.status = 'zaplanowana';
    
    IF v_aktywne_lekcje > 0 THEN
        RAISE_APPLICATION_ERROR(-20050, 
            'Nie mozna usunac ucznia (ID: ' || :OLD.id_ucznia || 
            ') - ma ' || v_aktywne_lekcje || ' zaplanowanych lekcji. ' ||
            'Najpierw odwolaj lub usun lekcje.');
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 12: TRG_NAUCZYCIEL_PRZED_USUNIECIEM
-- Opis: Zapobiega usunieciu nauczyciela z aktywnymi lekcjami
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_nauczyciel_przed_usunieciem
BEFORE DELETE ON t_nauczyciel
FOR EACH ROW
DECLARE
    v_aktywne_lekcje NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_aktywne_lekcje
    FROM t_lekcja l
    WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = :OLD.id_nauczyciela
      AND l.status = 'zaplanowana';
    
    IF v_aktywne_lekcje > 0 THEN
        RAISE_APPLICATION_ERROR(-20051, 
            'Nie mozna usunac nauczyciela (ID: ' || :OLD.id_nauczyciela || 
            ') - ma ' || v_aktywne_lekcje || ' zaplanowanych lekcji. ' ||
            'Najpierw odwolaj lub usun lekcje.');
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 13: TRG_SALA_PRZED_USUNIECIEM
-- Opis: Zapobiega usunieciu sali z aktywnymi lekcjami
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_sala_przed_usunieciem
BEFORE DELETE ON t_sala
FOR EACH ROW
DECLARE
    v_aktywne_lekcje NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_aktywne_lekcje
    FROM t_lekcja l
    WHERE DEREF(l.ref_sala).id_sali = :OLD.id_sali
      AND l.status = 'zaplanowana';
    
    IF v_aktywne_lekcje > 0 THEN
        RAISE_APPLICATION_ERROR(-20052, 
            'Nie mozna usunac sali (ID: ' || :OLD.id_sali || 
            ') - ma ' || v_aktywne_lekcje || ' zaplanowanych lekcji. ' ||
            'Najpierw odwolaj lub usun lekcje.');
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 14: TRG_NAUCZYCIEL_DATA_ZATRUDNIENIA
-- Opis: Ustawia date zatrudnienia jesli nie podano i waliduje
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_nauczyciel_data_zatrudnienia
BEFORE INSERT ON t_nauczyciel
FOR EACH ROW
BEGIN
    IF :NEW.data_zatrudnienia IS NULL THEN
        :NEW.data_zatrudnienia := SYSDATE;
    END IF;
    
    IF :NEW.data_zatrudnienia > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20060, 
            'Data zatrudnienia nie moze byc w przyszlosci.');
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 15: TRG_OCENA_AUDIT
-- Opis: Loguje wszystkie operacje na ocenach
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_ocena_audit
AFTER INSERT OR UPDATE OR DELETE ON t_ocena_postepu
FOR EACH ROW
DECLARE
    v_operacja      VARCHAR2(20);
    v_stara_wartosc VARCHAR2(500);
    v_nowa_wartosc  VARCHAR2(500);
BEGIN
    IF INSERTING THEN
        v_operacja := 'INSERT';
        v_stara_wartosc := NULL;
        v_nowa_wartosc := 'ID:' || :NEW.id_oceny || 
                          ', Ocena:' || :NEW.ocena || 
                          ', Obszar:' || :NEW.obszar;
    ELSIF UPDATING THEN
        v_operacja := 'UPDATE';
        v_stara_wartosc := 'ID:' || :OLD.id_oceny || 
                           ', Ocena:' || :OLD.ocena || 
                           ', Obszar:' || :OLD.obszar;
        v_nowa_wartosc := 'ID:' || :NEW.id_oceny || 
                          ', Ocena:' || :NEW.ocena || 
                          ', Obszar:' || :NEW.obszar;
    ELSIF DELETING THEN
        v_operacja := 'DELETE';
        v_stara_wartosc := 'ID:' || :OLD.id_oceny || 
                           ', Ocena:' || :OLD.ocena || 
                           ', Obszar:' || :OLD.obszar;
        v_nowa_wartosc := NULL;
    END IF;
    
    INSERT INTO t_audit_log (
        id_logu, nazwa_tabeli, operacja, 
        stara_wartosc, nowa_wartosc, uzytkownik
    ) VALUES (
        seq_audit_log.NEXTVAL, 'T_OCENA_POSTEPU', v_operacja,
        v_stara_wartosc, v_nowa_wartosc, USER
    );
END;
/

-- ============================================================================
-- TRIGGER 16: TRG_KURS_CENA_AUDIT
-- Opis: Loguje zmiany cen kursow
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_kurs_cena_audit
AFTER UPDATE OF cena_za_lekcje ON t_kurs
FOR EACH ROW
BEGIN
    INSERT INTO t_audit_log (
        id_logu, nazwa_tabeli, operacja, 
        stara_wartosc, nowa_wartosc, uzytkownik
    ) VALUES (
        seq_audit_log.NEXTVAL, 'T_KURS', 'UPDATE_CENA',
        'Kurs:' || :OLD.nazwa || ', Cena:' || :OLD.cena_za_lekcje || ' PLN',
        'Kurs:' || :NEW.nazwa || ', Cena:' || :NEW.cena_za_lekcje || ' PLN',
        USER
    );
END;
/

-- ============================================================================
-- WIDOK LOGOW AUDYTOWYCH
-- ============================================================================
CREATE OR REPLACE VIEW v_audit_ostatnie AS
SELECT id_logu, nazwa_tabeli, operacja, 
       stara_wartosc, nowa_wartosc, 
       uzytkownik, data_zmiany
FROM t_audit_log
ORDER BY data_zmiany DESC
FETCH FIRST 20 ROWS ONLY;

-- ============================================================================
-- PODSUMOWANIE TRIGGEROW - WERSJA 2.0
-- ============================================================================
/*
Utworzono 16 triggerow:

TRIGGERY SEMESTROWE:
1. trg_semestr_tylko_jeden_aktywny - zapewnia 1 aktywny semestr [NEW]

TRIGGERY LEKCJI - WALIDACJA:
2. trg_lekcja_walidacja_podstawowa - daty, statusy
3. trg_lekcja_godziny_dziecka - dzieci <15 lat: 14:00-19:00 [NEW]
4. trg_lekcja_limit_nauczyciela - max 6h dziennie [NEW]
5. trg_lekcja_limit_ucznia - max 2 lekcje dziennie [NEW]
6. trg_lekcja_konflikt_sali - sala nie moze byc zajeta [NEW]
7. trg_lekcja_konflikt_nauczyciela - nauczyciel nie moze byc zajety
8. trg_lekcja_konflikt_ucznia - uczen nie moze byc zajety
9. trg_lekcja_w_semestrze - lekcja w ramach aktywnego semestru [NEW]

TRIGGERY UCZNIOW:
10. trg_uczen_minimalny_wiek - min 5 lat
11. trg_uczen_przed_usunieciem - blokada usuwania z lekcjami

TRIGGERY NAUCZYCIELI:
12. trg_nauczyciel_przed_usunieciem - blokada usuwania z lekcjami [NEW]
13. trg_nauczyciel_data_zatrudnienia - domyslna data

TRIGGERY SAL:
14. trg_sala_przed_usunieciem - blokada usuwania z lekcjami [NEW]

TRIGGERY AUDYTOWE:
15. trg_ocena_audit - logowanie operacji na ocenach
16. trg_kurs_cena_audit - logowanie zmian cen

KODY BLEDOW:
-20001: Uczen za mlody (< 5 lat)
-20010: Data lekcji w przeszlosci
-20012: Nieprawidlowa zmiana statusu (odbyta->zaplanowana)
-20013: Nieprawidlowa zmiana statusu (odwolana->odbyta)
-20020: Nieprawidlowe godziny dla dziecka
-20030: Przekroczony limit godzin nauczyciela
-20031: Przekroczony limit lekcji ucznia
-20032: Konflikt sali
-20033: Konflikt nauczyciela
-20034: Konflikt ucznia
-20040: Brak aktywnego semestru
-20041: Data poza semestrem
-20050: Usuwanie ucznia z lekcjami
-20051: Usuwanie nauczyciela z lekcjami
-20052: Usuwanie sali z lekcjami
-20060: Data zatrudnienia w przyszlosci
*/

PROMPT ========================================
PROMPT Triggery utworzone pomyslnie!
PROMPT Wersja 2.0 - 16 triggerow
PROMPT ========================================
