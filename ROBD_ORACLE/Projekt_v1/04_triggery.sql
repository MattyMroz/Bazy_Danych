-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 04_triggery.sql
-- Opis: Triggery walidujace i audytowe
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- ============================================================================
-- TABELA AUDYTOWA (dla triggerow audytowych)
-- ============================================================================
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE t_audit_log CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE t_audit_log (
    id_logu         NUMBER PRIMARY KEY,
    nazwa_tabeli    VARCHAR2(50),
    operacja        VARCHAR2(20),
    stara_wartosc   VARCHAR2(500),
    nowa_wartosc    VARCHAR2(500),
    uzytkownik      VARCHAR2(50),
    data_zmiany     TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- Sekwencja dla logow
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_audit_log'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE SEQUENCE seq_audit_log START WITH 1 INCREMENT BY 1;

-- ============================================================================
-- TRIGGER 1: TRG_LEKCJA_WALIDACJA
-- Opis: Waliduje dane przy wstawianiu/aktualizacji lekcji
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_lekcja_walidacja
BEFORE INSERT OR UPDATE ON t_lekcja
FOR EACH ROW
DECLARE
    v_data_min DATE := TRUNC(SYSDATE);
    v_konflikt NUMBER;
BEGIN
    -- Walidacja 1: Data lekcji nie moze byc w przeszlosci (tylko dla nowych)
    IF INSERTING AND :NEW.data_lekcji < v_data_min THEN
        RAISE_APPLICATION_ERROR(-20010, 
            'Data lekcji nie moze byc w przeszlosci. Podano: ' || 
            TO_CHAR(:NEW.data_lekcji, 'YYYY-MM-DD'));
    END IF;
    
    -- Walidacja 2: Godzina musi byc w zakresie 08:00 - 20:00
    IF :NEW.godzina_start < '08:00' OR :NEW.godzina_start > '20:00' THEN
        RAISE_APPLICATION_ERROR(-20011, 
            'Godzina lekcji musi byc miedzy 08:00 a 20:00. Podano: ' || :NEW.godzina_start);
    END IF;
    
    -- Walidacja 3: Nie mozna zmienic statusu z "odbyta" na "zaplanowana"
    IF UPDATING AND :OLD.status = 'odbyta' AND :NEW.status = 'zaplanowana' THEN
        RAISE_APPLICATION_ERROR(-20012, 
            'Nie mozna zmienic statusu lekcji z "odbyta" na "zaplanowana".');
    END IF;
    
    -- Walidacja 4: Sprawdzamy konflikt ucznia (ten sam uczen w tym samym czasie)
    IF INSERTING OR (UPDATING AND :NEW.data_lekcji != :OLD.data_lekcji) THEN
        SELECT COUNT(*) INTO v_konflikt
        FROM t_lekcja l
        WHERE l.id_lekcji != NVL(:NEW.id_lekcji, -1)
          AND l.ref_uczen = :NEW.ref_uczen
          AND l.data_lekcji = :NEW.data_lekcji
          AND l.godzina_start = :NEW.godzina_start
          AND l.status != 'odwolana';
        
        IF v_konflikt > 0 THEN
            RAISE_APPLICATION_ERROR(-20013, 
                'Uczen ma juz zaplanowana lekcje o tej godzinie!');
        END IF;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('[TRG] Lekcja zwalidowana pomyslnie.');
END;
/

-- ============================================================================
-- TRIGGER 2: TRG_OCENA_AUDIT
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
    -- Okreslamy typ operacji
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
    
    -- Wstawiamy log
    INSERT INTO t_audit_log (
        id_logu, 
        nazwa_tabeli, 
        operacja, 
        stara_wartosc, 
        nowa_wartosc, 
        uzytkownik
    ) VALUES (
        seq_audit_log.NEXTVAL,
        'T_OCENA_POSTEPU',
        v_operacja,
        v_stara_wartosc,
        v_nowa_wartosc,
        USER
    );
    
    DBMS_OUTPUT.PUT_LINE('[AUDIT] Zalogowano ' || v_operacja || ' na T_OCENA_POSTEPU');
END;
/

-- ============================================================================
-- TRIGGER 3: TRG_UCZEN_PRZED_USUNIECIEM
-- Opis: Zapobiega usunieciu ucznia z aktywnymi lekcjami
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_uczen_przed_usunieciem
BEFORE DELETE ON t_uczen
FOR EACH ROW
DECLARE
    v_aktywne_lekcje NUMBER;
BEGIN
    -- Sprawdzamy czy uczen ma aktywne lekcje
    SELECT COUNT(*) INTO v_aktywne_lekcje
    FROM t_lekcja l
    WHERE DEREF(l.ref_uczen).id_ucznia = :OLD.id_ucznia
      AND l.status = 'zaplanowana';
    
    IF v_aktywne_lekcje > 0 THEN
        RAISE_APPLICATION_ERROR(-20020, 
            'Nie mozna usunac ucznia (ID: ' || :OLD.id_ucznia || 
            ') - ma ' || v_aktywne_lekcje || ' zaplanowanych lekcji. ' ||
            'Najpierw odwolaj lub usun lekcje.');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('[TRG] Uczen ID:' || :OLD.id_ucznia || ' moze zostac usuniety.');
END;
/

-- ============================================================================
-- TRIGGER 4: TRG_NAUCZYCIEL_DATA_ZATRUDNIENIA
-- Opis: Ustawia date zatrudnienia jesli nie podano
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_nauczyciel_data_zatrudnienia
BEFORE INSERT ON t_nauczyciel
FOR EACH ROW
BEGIN
    -- Jesli nie podano daty zatrudnienia, ustawiamy dzisiejsza
    IF :NEW.data_zatrudnienia IS NULL THEN
        :NEW.data_zatrudnienia := SYSDATE;
        DBMS_OUTPUT.PUT_LINE('[TRG] Ustawiono date zatrudnienia na: ' || 
                             TO_CHAR(:NEW.data_zatrudnienia, 'YYYY-MM-DD'));
    END IF;
    
    -- Data zatrudnienia nie moze byc w przyszlosci
    IF :NEW.data_zatrudnienia > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20021, 
            'Data zatrudnienia nie moze byc w przyszlosci.');
    END IF;
END;
/

-- ============================================================================
-- TRIGGER 5: TRG_KURS_CENA_AUDIT
-- Opis: Loguje zmiany cen kursow
-- ============================================================================
CREATE OR REPLACE TRIGGER trg_kurs_cena_audit
AFTER UPDATE OF cena_za_lekcje ON t_kurs
FOR EACH ROW
BEGIN
    INSERT INTO t_audit_log (
        id_logu, 
        nazwa_tabeli, 
        operacja, 
        stara_wartosc, 
        nowa_wartosc, 
        uzytkownik
    ) VALUES (
        seq_audit_log.NEXTVAL,
        'T_KURS',
        'UPDATE_CENA',
        'Kurs:' || :OLD.nazwa || ', Cena:' || :OLD.cena_za_lekcje || ' PLN',
        'Kurs:' || :NEW.nazwa || ', Cena:' || :NEW.cena_za_lekcje || ' PLN',
        USER
    );
    
    DBMS_OUTPUT.PUT_LINE('[AUDIT] Zmiana ceny kursu "' || :NEW.nazwa || 
                         '": ' || :OLD.cena_za_lekcje || ' -> ' || :NEW.cena_za_lekcje || ' PLN');
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
-- PODSUMOWANIE TRIGGEROW
-- ============================================================================
/*
Utworzono 5 triggerow:

1. TRG_LEKCJA_WALIDACJA (BEFORE INSERT/UPDATE)
   - Waliduje date lekcji (nie w przeszlosci)
   - Waliduje godzine (08:00-20:00)
   - Blokuje zmiane statusu odbyta->zaplanowana
   - Sprawdza konflikt czasowy ucznia

2. TRG_OCENA_AUDIT (AFTER INSERT/UPDATE/DELETE)
   - Loguje wszystkie operacje na ocenach
   - Zapisuje stare i nowe wartosci

3. TRG_UCZEN_PRZED_USUNIECIEM (BEFORE DELETE)
   - Blokuje usuniecie ucznia z aktywnymi lekcjami

4. TRG_NAUCZYCIEL_DATA_ZATRUDNIENIA (BEFORE INSERT)
   - Ustawia domyslna date zatrudnienia
   - Waliduje date (nie w przyszlosci)

5. TRG_KURS_CENA_AUDIT (AFTER UPDATE)
   - Loguje zmiany cen kursow

Dodatkowe:
- Tabela audytowa: t_audit_log
- Widok: v_audit_ostatnie (ostatnie 20 logow)
*/

PROMPT ========================================
PROMPT Triggery utworzone pomyslnie!
PROMPT ========================================
