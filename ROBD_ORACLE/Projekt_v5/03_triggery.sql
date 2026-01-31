-- ============================================================================
-- PLIK: 03_triggery.sql
-- PROJEKT: Szkoła Muzyczna v5 - Obiektowa Baza Danych Oracle
-- AUTORZY: Igor Typiński (251237), Mateusz Mróz (251190)
-- DATA: Styczeń 2026
-- ============================================================================
--
-- CO TEN PLIK ROBI?
-- -----------------
-- Tworzy TRIGGERY - automatyczne procedury uruchamiane przy operacjach DML
-- (INSERT, UPDATE, DELETE).
--
-- 🔴 KLUCZOWA DECYZJA PROJEKTOWA: UNIKANIE ORA-04091
-- --------------------------------------------------
-- 
-- ORA-04091: table X is mutating, trigger/function may not see it
--
-- Ten błąd występuje gdy trigger FOR EACH ROW próbuje wykonać SELECT
-- na tabeli, do której właśnie wstawiamy/aktualizujemy.
--
-- PRZYKŁAD PROBLEMU:
--   CREATE TRIGGER trg_check_conflict
--   BEFORE INSERT ON t_lekcja
--   FOR EACH ROW
--   BEGIN
--       SELECT COUNT(*) INTO v_cnt FROM t_lekcja  -- BŁĄD! Mutating table!
--       WHERE data_lekcji = :NEW.data_lekcji;
--   END;
--
-- ROZWIĄZANIE W TYM PROJEKCIE:
-- ============================
-- 
-- | Walidacja                    | Gdzie?    | Dlaczego?                    |
-- |------------------------------|-----------|------------------------------|
-- | Wiek ucznia >= 6             | TRIGGER   | Używa tylko :NEW, nie SELECT |
-- | Typ ucznia IN (...)          | TRIGGER   | j.w.                         |
-- | Email format                 | TRIGGER   | j.w.                         |
-- | Komisja1 != Komisja2         | TRIGGER   | j.w.                         |
-- | Konflikt sali                | PAKIET    | Wymaga SELECT z t_lekcja     |
-- | Konflikt nauczyciela         | PAKIET    | j.w.                         |
-- | Konflikt ucznia              | PAKIET    | j.w.                         |
-- | Limit godzin nauczyciela     | PAKIET    | j.w.                         |
-- | Godzina dla typu ucznia      | PAKIET    | Wymaga JOIN z t_uczen        |
--
-- TYPY TRIGGERÓW:
-- ---------------
-- 1. BEFORE ROW   - przed operacją, dla każdego wiersza (do walidacji/modyfikacji)
-- 2. AFTER ROW    - po operacji, dla każdego wiersza
-- 3. BEFORE STMT  - przed operacją, raz dla całego statement
-- 4. AFTER STMT   - po operacji, raz dla całego statement
-- 5. COMPOUND     - kombinacja powyższych (rozwiązanie na mutating table!)
-- 6. INSTEAD OF   - dla widoków (zamiast operacji)
--
-- W TYM PLIKU:
-- ------------
-- Tworzymy TYLKO bezpieczne triggery (bez SELECT na własnej tabeli):
--   1. trg_uczen_walidacja
--   2. trg_nauczyciel_walidacja
--   3. trg_sala_walidacja
--   4. trg_egzamin_walidacja
--   5. trg_lekcja_xor (uczeń XOR grupa)
--   6. trg_audit_dml (opcjonalny - logowanie zmian)
--
-- JAK URUCHOMIĆ?
-- --------------
-- WYMAGANIE: Najpierw 01_typy.sql i 02_tabele.sql !
-- @03_triggery.sql
--
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200

PROMPT ╔═══════════════════════════════════════════════════════════════╗
PROMPT ║  03_triggery.sql - Tworzenie triggerów walidacyjnych          ║
PROMPT ╚═══════════════════════════════════════════════════════════════╝
PROMPT

-- ============================================================================
-- TRIGGER 1: trg_uczen_walidacja
-- ============================================================================
--
-- CEL: Walidacja danych ucznia przy INSERT i UPDATE
--
-- WALIDACJE:
--   1. Wiek >= 6 lat (szkoła muzyczna I stopnia)
--   2. Wiek <= 25 lat (górny limit zapisu)
--   3. Typ ucznia IN ('uczacy_sie_w_innej_szkole', 'ukonczyl_edukacje', 'tylko_muzyczna')
--   4. Data zapisu nie może być w przyszłości
--   5. Automatyczne ustawienia (domyślne wartości)
--
-- DLACZEGO TO JEST BEZPIECZNE?
--   - Używamy TYLKO :NEW i :OLD (wartości wstawianego/aktualizowanego wiersza)
--   - NIE wykonujemy SELECT z t_uczen
--   - Brak ryzyka ORA-04091!
--
-- ============================================================================

PROMPT [1/6] Tworzenie trg_uczen_walidacja...

CREATE OR REPLACE TRIGGER trg_uczen_walidacja
-- ─────────────────────────────────────────────────────────────────────────────
-- BEFORE = przed wykonaniem operacji (możemy zmodyfikować :NEW lub odrzucić)
-- INSERT OR UPDATE = trigger odpala się przy obu operacjach
-- FOR EACH ROW = dla każdego wiersza osobno (mamy dostęp do :NEW i :OLD)
-- ─────────────────────────────────────────────────────────────────────────────
BEFORE INSERT OR UPDATE ON t_uczen
FOR EACH ROW
DECLARE
    -- Zmienne lokalne do obliczeń
    v_wiek NUMBER;
BEGIN
    -- ═══════════════════════════════════════════════════════════════════════
    -- WALIDACJA 1: Wiek >= 6 lat
    -- ═══════════════════════════════════════════════════════════════════════
    -- Szkoła muzyczna I stopnia przyjmuje dzieci od 6 roku życia.
    -- MONTHS_BETWEEN zwraca różnicę w miesiącach, / 12 = lata.
    -- TRUNC usuwa część ułamkową (np. 6.8 → 6).
    -- ═══════════════════════════════════════════════════════════════════════
    IF :NEW.data_urodzenia IS NOT NULL THEN
        v_wiek := TRUNC(MONTHS_BETWEEN(SYSDATE, :NEW.data_urodzenia) / 12);
        
        IF v_wiek < 6 THEN
            -- RAISE_APPLICATION_ERROR:
            --   - Pierwszy argument: kod błędu (-20000 do -20999 = dla użytkownika)
            --   - Drugi argument: komunikat
            --   - Przerywa operację i cofa transakcję
            RAISE_APPLICATION_ERROR(-20001, 
                'Uczeń musi mieć minimum 6 lat. ' ||
                'Data urodzenia: ' || TO_CHAR(:NEW.data_urodzenia, 'YYYY-MM-DD') ||
                ', wiek: ' || v_wiek || ' lat.');
        END IF;
        
        IF v_wiek > 25 THEN
            RAISE_APPLICATION_ERROR(-20002,
                'Uczeń może mieć maksymalnie 25 lat. ' ||
                'Data urodzenia: ' || TO_CHAR(:NEW.data_urodzenia, 'YYYY-MM-DD') ||
                ', wiek: ' || v_wiek || ' lat.');
        END IF;
    END IF;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- WALIDACJA 2: Typ ucznia (dodatkowa warstwa - oprócz CHECK)
    -- ═══════════════════════════════════════════════════════════════════════
    -- CHECK constraint też to waliduje, ale trigger daje lepszy komunikat.
    -- ═══════════════════════════════════════════════════════════════════════
    IF :NEW.typ_ucznia NOT IN (
        'uczacy_sie_w_innej_szkole',  -- dzieci chodzące do zwykłej szkoły
        'ukonczyl_edukacje',          -- absolwenci, studenci, dorośli
        'tylko_muzyczna'              -- homeschooling, zawodowcy
    ) THEN
        RAISE_APPLICATION_ERROR(-20003,
            'Nieprawidłowy typ ucznia: "' || :NEW.typ_ucznia || '". ' ||
            'Dozwolone: uczacy_sie_w_innej_szkole, ukonczyl_edukacje, tylko_muzyczna.');
    END IF;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- WALIDACJA 3: Data zapisu nie w przyszłości
    -- ═══════════════════════════════════════════════════════════════════════
    IF :NEW.data_zapisu > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20004,
            'Data zapisu nie może być w przyszłości. ' ||
            'Podano: ' || TO_CHAR(:NEW.data_zapisu, 'YYYY-MM-DD') ||
            ', dzisiaj: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD'));
    END IF;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- AUTO-USTAWIENIA (tylko przy INSERT)
    -- ═══════════════════════════════════════════════════════════════════════
    -- INSERTING, UPDATING, DELETING - predykaty określające typ operacji
    -- ═══════════════════════════════════════════════════════════════════════
    IF INSERTING THEN
        -- Domyślna data zapisu = dziś
        IF :NEW.data_zapisu IS NULL THEN
            :NEW.data_zapisu := TRUNC(SYSDATE);  -- TRUNC usuwa czas
        END IF;
        
        -- Domyślny status = aktywny
        IF :NEW.status IS NULL THEN
            :NEW.status := 'aktywny';
        END IF;
        
        -- Domyślna klasa = 1 (pierwsza klasa)
        IF :NEW.klasa IS NULL THEN
            :NEW.klasa := 1;
        END IF;
        
        -- Domyślny cykl = 6
        IF :NEW.cykl_nauczania IS NULL THEN
            :NEW.cykl_nauczania := 6;
        END IF;
    END IF;

END trg_uczen_walidacja;
/

-- Sprawdź czy trigger się skompilował
SHOW ERRORS TRIGGER trg_uczen_walidacja;

-- ============================================================================
-- TRIGGER 2: trg_nauczyciel_walidacja
-- ============================================================================
--
-- CEL: Walidacja danych nauczyciela
--
-- WALIDACJE:
--   1. Email musi zawierać @ (podstawowa walidacja)
--   2. Lista instrumentów nie może być pusta
--   3. Data zatrudnienia nie w przyszłości
--
-- ============================================================================

PROMPT [2/6] Tworzenie trg_nauczyciel_walidacja...

CREATE OR REPLACE TRIGGER trg_nauczyciel_walidacja
BEFORE INSERT OR UPDATE ON t_nauczyciel
FOR EACH ROW
BEGIN
    -- ═══════════════════════════════════════════════════════════════════════
    -- WALIDACJA 1: Email format
    -- ═══════════════════════════════════════════════════════════════════════
    -- Podstawowa walidacja - zawiera @
    -- W produkcji użyłbym REGEXP_LIKE dla pełnej walidacji RFC 5322
    -- ═══════════════════════════════════════════════════════════════════════
    IF :NEW.email IS NOT NULL AND INSTR(:NEW.email, '@') = 0 THEN
        RAISE_APPLICATION_ERROR(-20010,
            'Nieprawidłowy format email: "' || :NEW.email || '". ' ||
            'Email musi zawierać @.');
    END IF;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- WALIDACJA 2: Lista instrumentów nie może być pusta
    -- ═══════════════════════════════════════════════════════════════════════
    -- Nauczyciel MUSI uczyć przynajmniej 1 instrumentu.
    -- VARRAY.COUNT = liczba elementów
    -- ═══════════════════════════════════════════════════════════════════════
    IF :NEW.instrumenty IS NULL OR :NEW.instrumenty.COUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20011,
            'Nauczyciel musi mieć przypisany przynajmniej 1 instrument. ' ||
            'Lista instrumentów nie może być pusta.');
    END IF;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- WALIDACJA 3: Data zatrudnienia nie w przyszłości
    -- ═══════════════════════════════════════════════════════════════════════
    IF :NEW.data_zatrudnienia > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20012,
            'Data zatrudnienia nie może być w przyszłości. ' ||
            'Podano: ' || TO_CHAR(:NEW.data_zatrudnienia, 'YYYY-MM-DD'));
    END IF;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- AUTO-USTAWIENIA (INSERT)
    -- ═══════════════════════════════════════════════════════════════════════
    IF INSERTING THEN
        -- Domyślna data zatrudnienia = dziś
        IF :NEW.data_zatrudnienia IS NULL THEN
            :NEW.data_zatrudnienia := TRUNC(SYSDATE);
        END IF;
        
        -- Domyślny status = aktywny
        IF :NEW.status IS NULL THEN
            :NEW.status := 'aktywny';
        END IF;
    END IF;

END trg_nauczyciel_walidacja;
/

SHOW ERRORS TRIGGER trg_nauczyciel_walidacja;

-- ============================================================================
-- TRIGGER 3: trg_sala_walidacja
-- ============================================================================
--
-- CEL: Walidacja danych sali
--
-- WALIDACJE:
--   1. Pojemność zgodna z typem sali
--   2. Auto-ustawienia
--
-- ============================================================================

PROMPT [3/6] Tworzenie trg_sala_walidacja...

CREATE OR REPLACE TRIGGER trg_sala_walidacja
BEFORE INSERT OR UPDATE ON t_sala
FOR EACH ROW
BEGIN
    -- ═══════════════════════════════════════════════════════════════════════
    -- WALIDACJA 1: Pojemność zgodna z typem sali
    -- ═══════════════════════════════════════════════════════════════════════
    -- - indywidualna: 1-3 osoby (lekcje 1:1 + opcjonalnie akompaniator)
    -- - grupowa: 10-30 osób (teoria, chór)
    -- - wielofunkcyjna: 3-15 osób (elastyczne wykorzystanie)
    -- ═══════════════════════════════════════════════════════════════════════
    IF :NEW.typ_sali = 'indywidualna' AND :NEW.pojemnosc > 5 THEN
        RAISE_APPLICATION_ERROR(-20020,
            'Sala indywidualna nie może mieć pojemności > 5. ' ||
            'Podano: ' || :NEW.pojemnosc || '. ' ||
            'Dla większych sal użyj typu "grupowa" lub "wielofunkcyjna".');
    END IF;
    
    IF :NEW.typ_sali = 'grupowa' AND :NEW.pojemnosc < 8 THEN
        RAISE_APPLICATION_ERROR(-20021,
            'Sala grupowa powinna mieć pojemność >= 8. ' ||
            'Podano: ' || :NEW.pojemnosc || '. ' ||
            'Dla mniejszych sal użyj typu "indywidualna" lub "wielofunkcyjna".');
    END IF;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- AUTO-USTAWIENIA (INSERT)
    -- ═══════════════════════════════════════════════════════════════════════
    IF INSERTING THEN
        -- Domyślny status = dostepna
        IF :NEW.status IS NULL THEN
            :NEW.status := 'dostepna';
        END IF;
    END IF;

END trg_sala_walidacja;
/

SHOW ERRORS TRIGGER trg_sala_walidacja;

-- ============================================================================
-- TRIGGER 4: trg_egzamin_walidacja
-- ============================================================================
--
-- CEL: Walidacja danych egzaminu
--
-- WALIDACJE:
--   1. Komisja: ref_komisja1 != ref_komisja2 (różne osoby)
--   2. Data egzaminu nie w przeszłości (przy INSERT)
--   3. Ocena końcowa: NULL lub 1-6
--
-- UWAGA O PORÓWNYWANIU REF:
-- -------------------------
-- REF to wskaźnik (OID). Można porównywać REF-y bezpośrednio (= lub !=).
-- To NIE wymaga SELECT, więc jest bezpieczne!
--
-- ============================================================================

PROMPT [4/6] Tworzenie trg_egzamin_walidacja...

CREATE OR REPLACE TRIGGER trg_egzamin_walidacja
BEFORE INSERT OR UPDATE ON t_egzamin
FOR EACH ROW
BEGIN
    -- ═══════════════════════════════════════════════════════════════════════
    -- WALIDACJA 1: Komisja składa się z RÓŻNYCH osób
    -- ═══════════════════════════════════════════════════════════════════════
    -- Porównanie REF-ów - działanie na wskaźnikach, bez SELECT!
    -- ═══════════════════════════════════════════════════════════════════════
    IF :NEW.ref_komisja1 = :NEW.ref_komisja2 THEN
        RAISE_APPLICATION_ERROR(-20030,
            'Komisja egzaminacyjna musi składać się z RÓŻNYCH nauczycieli. ' ||
            'ref_komisja1 i ref_komisja2 wskazują na tę samą osobę.');
    END IF;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- WALIDACJA 2: Data egzaminu (tylko przy INSERT)
    -- ═══════════════════════════════════════════════════════════════════════
    -- Przy INSERT: egzamin nie może być w przeszłości (planujemy na przyszłość)
    -- Przy UPDATE: dozwalamy modyfikację (np. wpisanie oceny po fakcie)
    -- ═══════════════════════════════════════════════════════════════════════
    IF INSERTING THEN
        IF :NEW.data_egzaminu < TRUNC(SYSDATE) THEN
            RAISE_APPLICATION_ERROR(-20031,
                'Nie można zaplanować egzaminu w przeszłości. ' ||
                'Podano: ' || TO_CHAR(:NEW.data_egzaminu, 'YYYY-MM-DD') ||
                ', dzisiaj: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD'));
        END IF;
        
        -- Domyślna ocena = NULL (jeszcze nie wystawiona)
        :NEW.ocena_koncowa := NULL;
    END IF;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- WALIDACJA 3: Ocena końcowa (przy UPDATE)
    -- ═══════════════════════════════════════════════════════════════════════
    -- Sprawdź czy zmienia się na niepustą wartość
    -- ═══════════════════════════════════════════════════════════════════════
    IF UPDATING AND :NEW.ocena_koncowa IS NOT NULL THEN
        -- Nie można wystawić oceny przed datą egzaminu
        IF :NEW.data_egzaminu > SYSDATE THEN
            RAISE_APPLICATION_ERROR(-20032,
                'Nie można wystawić oceny przed datą egzaminu. ' ||
                'Data egzaminu: ' || TO_CHAR(:NEW.data_egzaminu, 'YYYY-MM-DD'));
        END IF;
    END IF;

END trg_egzamin_walidacja;
/

SHOW ERRORS TRIGGER trg_egzamin_walidacja;

-- ============================================================================
-- TRIGGER 5: trg_lekcja_xor
-- ============================================================================
--
-- CEL: Walidacja reguły XOR dla lekcji
--
-- REGUŁA:
--   Lekcja indywidualna: ref_uczen NOT NULL, ref_grupa NULL
--   Lekcja grupowa: ref_uczen NULL, ref_grupa NOT NULL
--
-- Nie może być:
--   - oba NOT NULL (komu przypisać lekcję?)
--   - oba NULL (do kogo lekcja?)
--
-- DLACZEGO TRIGGER A NIE CHECK?
-- -----------------------------
-- Oracle nie obsługuje dobrze XOR w CHECK constraint.
-- CHECK ((ref_uczen IS NOT NULL) != (ref_grupa IS NOT NULL)) - nie działa!
--
-- ============================================================================

PROMPT [5/6] Tworzenie trg_lekcja_xor...

CREATE OR REPLACE TRIGGER trg_lekcja_xor
BEFORE INSERT OR UPDATE ON t_lekcja
FOR EACH ROW
BEGIN
    -- ═══════════════════════════════════════════════════════════════════════
    -- WALIDACJA: XOR - dokładnie jedno z (ref_uczen, ref_grupa) NOT NULL
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- Przypadek 1: Lekcja indywidualna - musi mieć ucznia, nie może mieć grupy
    IF :NEW.typ_lekcji = 'indywidualna' THEN
        IF :NEW.ref_uczen IS NULL THEN
            RAISE_APPLICATION_ERROR(-20040,
                'Lekcja indywidualna wymaga przypisania ucznia (ref_uczen). ' ||
                'ref_uczen nie może być NULL dla typ_lekcji = "indywidualna".');
        END IF;
        
        IF :NEW.ref_grupa IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20041,
                'Lekcja indywidualna nie może mieć przypisanej grupy. ' ||
                'ref_grupa musi być NULL dla typ_lekcji = "indywidualna".');
        END IF;
    END IF;
    
    -- Przypadek 2: Lekcja grupowa - musi mieć grupę, nie może mieć ucznia
    IF :NEW.typ_lekcji = 'grupowa' THEN
        IF :NEW.ref_grupa IS NULL THEN
            RAISE_APPLICATION_ERROR(-20042,
                'Lekcja grupowa wymaga przypisania grupy (ref_grupa). ' ||
                'ref_grupa nie może być NULL dla typ_lekcji = "grupowa".');
        END IF;
        
        IF :NEW.ref_uczen IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20043,
                'Lekcja grupowa nie może mieć przypisanego pojedynczego ucznia. ' ||
                'ref_uczen musi być NULL dla typ_lekcji = "grupowa".');
        END IF;
    END IF;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- AUTO-USTAWIENIA (INSERT)
    -- ═══════════════════════════════════════════════════════════════════════
    IF INSERTING THEN
        -- Domyślny status = zaplanowana
        IF :NEW.status IS NULL THEN
            :NEW.status := 'zaplanowana';
        END IF;
    END IF;

END trg_lekcja_xor;
/

SHOW ERRORS TRIGGER trg_lekcja_xor;

-- ============================================================================
-- TRIGGER 6: trg_ocena_walidacja
-- ============================================================================
--
-- CEL: Walidacja danych oceny
--
-- WALIDACJE:
--   1. Data oceny nie w przyszłości
--   2. Auto-ustawienia
--
-- ============================================================================

PROMPT [6/6] Tworzenie trg_ocena_walidacja...

CREATE OR REPLACE TRIGGER trg_ocena_walidacja
BEFORE INSERT OR UPDATE ON t_ocena
FOR EACH ROW
BEGIN
    -- ═══════════════════════════════════════════════════════════════════════
    -- AUTO-USTAWIENIA (INSERT)
    -- ═══════════════════════════════════════════════════════════════════════
    IF INSERTING THEN
        -- Domyślna data oceny = dziś
        IF :NEW.data_oceny IS NULL THEN
            :NEW.data_oceny := TRUNC(SYSDATE);
        END IF;
    END IF;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- WALIDACJA: Data oceny nie w przyszłości
    -- ═══════════════════════════════════════════════════════════════════════
    IF :NEW.data_oceny > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20050,
            'Data oceny nie może być w przyszłości. ' ||
            'Podano: ' || TO_CHAR(:NEW.data_oceny, 'YYYY-MM-DD'));
    END IF;

END trg_ocena_walidacja;
/

SHOW ERRORS TRIGGER trg_ocena_walidacja;

-- ============================================================================
-- TRIGGER OPCJONALNY: trg_audit_dml (logowanie zmian)
-- ============================================================================
--
-- CEL: Logowanie wszystkich operacji DML (INSERT/UPDATE/DELETE)
--
-- UWAGA: Wymaga dodatkowej tabeli t_audit_log!
-- Odkomentuj poniższy kod jeśli chcesz używać audytu.
--
-- ============================================================================

/*
-- Najpierw utwórz tabelę logów
CREATE TABLE t_audit_log (
    id_logu         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nazwa_tabeli    VARCHAR2(128),
    operacja        VARCHAR2(10),  -- INSERT/UPDATE/DELETE
    uzytkownik      VARCHAR2(128),
    data_operacji   TIMESTAMP DEFAULT SYSTIMESTAMP,
    stare_dane      CLOB,  -- JSON ze starymi wartościami
    nowe_dane       CLOB   -- JSON z nowymi wartościami
);

-- Przykładowy trigger audytowy dla t_uczen
CREATE OR REPLACE TRIGGER trg_audit_uczen
AFTER INSERT OR UPDATE OR DELETE ON t_uczen
FOR EACH ROW
DECLARE
    v_operacja VARCHAR2(10);
BEGIN
    IF INSERTING THEN v_operacja := 'INSERT';
    ELSIF UPDATING THEN v_operacja := 'UPDATE';
    ELSIF DELETING THEN v_operacja := 'DELETE';
    END IF;
    
    INSERT INTO t_audit_log (nazwa_tabeli, operacja, uzytkownik, stare_dane, nowe_dane)
    VALUES (
        'T_UCZEN',
        v_operacja,
        USER,
        CASE WHEN DELETING OR UPDATING THEN 
            '{"id":' || :OLD.id_ucznia || ',"imie":"' || :OLD.imie || '","nazwisko":"' || :OLD.nazwisko || '"}'
        END,
        CASE WHEN INSERTING OR UPDATING THEN
            '{"id":' || :NEW.id_ucznia || ',"imie":"' || :NEW.imie || '","nazwisko":"' || :NEW.nazwisko || '"}'
        END
    );
END;
/
*/

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================

PROMPT
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT   PODSUMOWANIE - Utworzone triggery
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT
PROMPT   TRIGGERY WALIDACYJNE (6):
PROMPT     [✓] trg_uczen_walidacja      - wiek, typ ucznia, auto-defaults
PROMPT     [✓] trg_nauczyciel_walidacja - email, instrumenty, auto-defaults
PROMPT     [✓] trg_sala_walidacja       - pojemność vs typ, auto-defaults
PROMPT     [✓] trg_egzamin_walidacja    - komisja różna, data, ocena
PROMPT     [✓] trg_lekcja_xor           - uczeń XOR grupa
PROMPT     [✓] trg_ocena_walidacja      - data, auto-defaults
PROMPT
PROMPT   🔴 WAŻNE: Walidacje KONFLIKTÓW (sala/nauczyciel/uczeń) są w PAKIETACH!
PROMPT      (Pakiet pkg_lekcja - unika błędu ORA-04091 Mutating Table)
PROMPT
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT   Następny krok: Uruchom 04_pakiety.sql
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT

-- Lista triggerów
SELECT trigger_name, trigger_type, triggering_event, table_name, status
FROM user_triggers
WHERE table_name LIKE 'T\_%' ESCAPE '\'
ORDER BY table_name, trigger_name;
