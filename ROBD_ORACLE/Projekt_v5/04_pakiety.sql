-- ============================================================================
-- PLIK: 04_pakiety.sql
-- PROJEKT: Szkoła Muzyczna v5 - Obiektowa Baza Danych Oracle
-- AUTORZY: Igor Typiński (251237), Mateusz Mróz (251190)
-- DATA: Styczeń 2026
-- ============================================================================
--
-- CO TEN PLIK ROBI?
-- -----------------
-- Tworzy PAKIETY PL/SQL - moduły grupujące powiązane procedury i funkcje.
--
-- 🔴 DLACZEGO WALIDACJE KONFLIKTÓW SĄ W PAKIETACH, NIE W TRIGGERACH?
-- ------------------------------------------------------------------
--
-- Problem: ORA-04091 - Mutating Table
--   Trigger FOR EACH ROW nie może wykonać SELECT na tabeli,
--   do której właśnie wstawiamy (t_lekcja).
--
-- Rozwiązanie:
--   Walidacje wymagające SELECT na własnej tabeli → PAKIET
--   Użytkownik/aplikacja MUSI wywoływać procedury pakietu!
--
-- ARCHITEKTURA WYWOŁAŃ:
-- =====================
--
--   Aplikacja → pkg_lekcja.dodaj_lekcje(...) → INSERT INTO t_lekcja
--                     │
--                     ├── sprawdz_konflikt_sali()      SELECT z t_lekcja
--                     ├── sprawdz_konflikt_nauczyciela()  SELECT z t_lekcja
--                     ├── sprawdz_konflikt_ucznia()    SELECT z t_lekcja
--                     ├── sprawdz_godzine_dla_typu()   SELECT z t_uczen
--                     └── sprawdz_limit_godzin()       SELECT z t_lekcja
--
--   NIE: Aplikacja → INSERT INTO t_lekcja → Trigger → SELECT (💥 ORA-04091)
--
-- PAKIETY W TYM PLIKU:
-- ====================
--   1. pkg_uczen      - zarządzanie uczniami
--   2. pkg_nauczyciel - zarządzanie nauczycielami
--   3. pkg_lekcja     - zarządzanie lekcjami (🔴 WALIDACJE KONFLIKTÓW!)
--   4. pkg_ocena      - zarządzanie ocenami
--   5. pkg_raport     - generowanie raportów
--   6. pkg_test       - testy automatyczne (przyszły krok 09_testy.sql)
--
-- STRUKTURA PAKIETU:
-- ==================
-- Pakiet w Oracle składa się z dwóch części:
--   1. SPECIFICATION (spec) - interfejs publiczny (deklaracje)
--   2. BODY             - implementacja (kod)
--
-- Analogia do programowania obiektowego:
--   - SPEC = plik nagłówkowy (.h w C++, interfejs w Javie)
--   - BODY = implementacja (.cpp w C++, klasa w Javie)
--
-- JAK URUCHOMIĆ?
-- --------------
-- WYMAGANIE: Najpierw 01_typy.sql, 02_tabele.sql, 03_triggery.sql
-- @04_pakiety.sql
--
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200

PROMPT ╔═══════════════════════════════════════════════════════════════╗
PROMPT ║  04_pakiety.sql - Tworzenie pakietów PL/SQL                   ║
PROMPT ╚═══════════════════════════════════════════════════════════════╝
PROMPT

-- ============================================================================
-- PAKIET 1: pkg_uczen
-- ============================================================================
--
-- CEL: Zarządzanie uczniami
--
-- PROCEDURY:
--   - dodaj_ucznia()     - INSERT z walidacją
--   - aktualizuj_ucznia() - UPDATE
--   - usun_ucznia()      - DELETE (soft delete?)
--   - promuj_ucznia()    - zmiana klasy +1
--
-- FUNKCJE:
--   - pobierz_ucznia()   - zwraca dane ucznia
--   - lista_uczniow()    - zwraca kursor
--
-- ============================================================================

PROMPT [1/6] Tworzenie pkg_uczen (specification)...

CREATE OR REPLACE PACKAGE pkg_uczen AS
    -- ═══════════════════════════════════════════════════════════════════════
    -- STAŁE PUBLICZNE
    -- ═══════════════════════════════════════════════════════════════════════
    c_min_wiek CONSTANT NUMBER := 6;
    c_max_wiek CONSTANT NUMBER := 25;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- TYPY PUBLICZNE
    -- ═══════════════════════════════════════════════════════════════════════
    -- Kursor z danymi uczniów (do użycia w raportach)
    TYPE t_cursor_uczen IS REF CURSOR RETURN t_uczen%ROWTYPE;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- PROCEDURY
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- Dodaje nowego ucznia
    -- @param p_imie - imię ucznia
    -- @param p_nazwisko - nazwisko ucznia
    -- @param p_data_urodzenia - data urodzenia
    -- @param p_typ_ucznia - typ ucznia (uczacy_sie_w_innej_szkole, ukonczyl_edukacje, tylko_muzyczna)
    -- @param p_ref_instrument - REF do instrumentu głównego
    -- @param p_ref_nauczyciel - REF do nauczyciela prowadzącego
    -- @param p_klasa - klasa (1-6), domyślnie 1
    -- @param p_cykl_nauczania - cykl (4 lub 6 lat), domyślnie 6
    -- @return p_id_ucznia - ID nowo utworzonego ucznia
    PROCEDURE dodaj_ucznia(
        p_imie              IN VARCHAR2,
        p_nazwisko          IN VARCHAR2,
        p_data_urodzenia    IN DATE,
        p_typ_ucznia        IN VARCHAR2,
        p_ref_instrument    IN REF t_instrument_obj,
        p_ref_nauczyciel    IN REF t_nauczyciel_obj,
        p_klasa             IN NUMBER DEFAULT 1,
        p_cykl_nauczania    IN NUMBER DEFAULT 6,
        p_id_ucznia         OUT NUMBER
    );
    
    -- Promuje ucznia do następnej klasy
    -- @param p_id_ucznia - ID ucznia do promocji
    -- @param p_nowa_klasa - OUT: nowa klasa po promocji
    PROCEDURE promuj_ucznia(
        p_id_ucznia   IN NUMBER,
        p_nowa_klasa  OUT NUMBER
    );
    
    -- Zmienia status ucznia
    -- @param p_id_ucznia - ID ucznia
    -- @param p_nowy_status - nowy status (aktywny, nieaktywny, zawieszony, absolwent)
    PROCEDURE zmien_status(
        p_id_ucznia    IN NUMBER,
        p_nowy_status  IN VARCHAR2
    );
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- FUNKCJE
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- Zwraca listę uczniów (kursor)
    -- @param p_status - filtr statusu (NULL = wszystkie)
    -- @param p_klasa - filtr klasy (NULL = wszystkie)
    -- @return kursor z uczniami
    FUNCTION lista_uczniow(
        p_status IN VARCHAR2 DEFAULT NULL,
        p_klasa  IN NUMBER DEFAULT NULL
    ) RETURN t_cursor_uczen;
    
    -- Sprawdza czy uczeń może mieć lekcję o danej godzinie
    -- @param p_id_ucznia - ID ucznia
    -- @param p_godzina - godzina lekcji (HH24)
    -- @return TRUE jeśli godzina dozwolona, FALSE w przeciwnym razie
    FUNCTION czy_godzina_dozwolona(
        p_id_ucznia IN NUMBER,
        p_godzina   IN NUMBER
    ) RETURN BOOLEAN;

END pkg_uczen;
/

SHOW ERRORS PACKAGE pkg_uczen;

PROMPT [1/6] Tworzenie pkg_uczen (body)...

CREATE OR REPLACE PACKAGE BODY pkg_uczen AS
    -- ═══════════════════════════════════════════════════════════════════════
    -- PROCEDURY - IMPLEMENTACJA
    -- ═══════════════════════════════════════════════════════════════════════
    
    PROCEDURE dodaj_ucznia(
        p_imie              IN VARCHAR2,
        p_nazwisko          IN VARCHAR2,
        p_data_urodzenia    IN DATE,
        p_typ_ucznia        IN VARCHAR2,
        p_ref_instrument    IN REF t_instrument_obj,
        p_ref_nauczyciel    IN REF t_nauczyciel_obj,
        p_klasa             IN NUMBER DEFAULT 1,
        p_cykl_nauczania    IN NUMBER DEFAULT 6,
        p_id_ucznia         OUT NUMBER
    ) AS
        v_wiek NUMBER;
    BEGIN
        -- Walidacja wieku
        v_wiek := TRUNC(MONTHS_BETWEEN(SYSDATE, p_data_urodzenia) / 12);
        
        IF v_wiek < c_min_wiek THEN
            RAISE_APPLICATION_ERROR(-20101, 
                'Uczeń musi mieć minimum ' || c_min_wiek || ' lat. ' ||
                'Podany wiek: ' || v_wiek);
        END IF;
        
        IF v_wiek > c_max_wiek THEN
            RAISE_APPLICATION_ERROR(-20102,
                'Uczeń może mieć maksymalnie ' || c_max_wiek || ' lat. ' ||
                'Podany wiek: ' || v_wiek);
        END IF;
        
        -- Pobierz ID z sekwencji
        p_id_ucznia := seq_uczen.NEXTVAL;
        
        -- Wstaw rekord
        INSERT INTO t_uczen VALUES (
            t_uczen_obj(
                p_id_ucznia,
                p_imie,
                p_nazwisko,
                p_data_urodzenia,
                p_typ_ucznia,
                TRUNC(SYSDATE),   -- data_zapisu
                p_klasa,
                p_cykl_nauczania,
                'aktywny',        -- status
                p_ref_instrument,
                p_ref_nauczyciel
            )
        );
        
        DBMS_OUTPUT.PUT_LINE('Dodano ucznia: ' || p_imie || ' ' || p_nazwisko || 
                             ' (ID: ' || p_id_ucznia || ')');
    END dodaj_ucznia;
    
    -- ───────────────────────────────────────────────────────────────────────
    
    PROCEDURE promuj_ucznia(
        p_id_ucznia   IN NUMBER,
        p_nowa_klasa  OUT NUMBER
    ) AS
        v_klasa NUMBER;
        v_cykl NUMBER;
    BEGIN
        -- Pobierz aktualną klasę i cykl
        SELECT u.klasa, u.cykl_nauczania
        INTO v_klasa, v_cykl
        FROM t_uczen u
        WHERE u.id_ucznia = p_id_ucznia;
        
        -- Sprawdź czy można promować
        IF v_klasa >= v_cykl THEN
            -- Absolwent!
            UPDATE t_uczen
            SET status = 'absolwent'
            WHERE id_ucznia = p_id_ucznia;
            
            p_nowa_klasa := v_klasa;  -- bez zmiany
            
            DBMS_OUTPUT.PUT_LINE('Uczeń ID=' || p_id_ucznia || 
                                 ' ukończył szkołę! Status: absolwent');
        ELSE
            -- Promocja do następnej klasy
            p_nowa_klasa := v_klasa + 1;
            
            UPDATE t_uczen
            SET klasa = p_nowa_klasa
            WHERE id_ucznia = p_id_ucznia;
            
            DBMS_OUTPUT.PUT_LINE('Uczeń ID=' || p_id_ucznia || 
                                 ' promowany z klasy ' || v_klasa ||
                                 ' do klasy ' || p_nowa_klasa);
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20103, 
                'Nie znaleziono ucznia o ID=' || p_id_ucznia);
    END promuj_ucznia;
    
    -- ───────────────────────────────────────────────────────────────────────
    
    PROCEDURE zmien_status(
        p_id_ucznia    IN NUMBER,
        p_nowy_status  IN VARCHAR2
    ) AS
    BEGIN
        UPDATE t_uczen
        SET status = p_nowy_status
        WHERE id_ucznia = p_id_ucznia;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20104,
                'Nie znaleziono ucznia o ID=' || p_id_ucznia);
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('Zmieniono status ucznia ID=' || p_id_ucznia ||
                             ' na: ' || p_nowy_status);
    END zmien_status;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- FUNKCJE - IMPLEMENTACJA
    -- ═══════════════════════════════════════════════════════════════════════
    
    FUNCTION lista_uczniow(
        p_status IN VARCHAR2 DEFAULT NULL,
        p_klasa  IN NUMBER DEFAULT NULL
    ) RETURN t_cursor_uczen AS
        v_cursor t_cursor_uczen;
    BEGIN
        OPEN v_cursor FOR
            SELECT *
            FROM t_uczen u
            WHERE (p_status IS NULL OR u.status = p_status)
              AND (p_klasa IS NULL OR u.klasa = p_klasa)
            ORDER BY u.nazwisko, u.imie;
        
        RETURN v_cursor;
    END lista_uczniow;
    
    -- ───────────────────────────────────────────────────────────────────────
    
    FUNCTION czy_godzina_dozwolona(
        p_id_ucznia IN NUMBER,
        p_godzina   IN NUMBER
    ) RETURN BOOLEAN AS
        v_typ_ucznia VARCHAR2(50);
        v_min_godzina NUMBER;
    BEGIN
        -- Pobierz typ ucznia
        SELECT typ_ucznia INTO v_typ_ucznia
        FROM t_uczen
        WHERE id_ucznia = p_id_ucznia;
        
        -- Określ minimalną godzinę na podstawie typu
        -- ═══════════════════════════════════════════════════════════════
        -- KLUCZOWA LOGIKA BIZNESOWA:
        --   'uczacy_sie_w_innej_szkole' → lekcje od 15:00 (koniec szkoły)
        --   'ukonczyl_edukacje'         → lekcje od 14:00
        --   'tylko_muzyczna'            → lekcje od 14:00
        -- ═══════════════════════════════════════════════════════════════
        IF v_typ_ucznia = 'uczacy_sie_w_innej_szkole' THEN
            v_min_godzina := 15;
        ELSE
            v_min_godzina := 14;
        END IF;
        
        RETURN (p_godzina >= v_min_godzina);
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN FALSE;
    END czy_godzina_dozwolona;

END pkg_uczen;
/

SHOW ERRORS PACKAGE BODY pkg_uczen;

-- ============================================================================
-- PAKIET 2: pkg_nauczyciel
-- ============================================================================
--
-- CEL: Zarządzanie nauczycielami
--
-- ============================================================================

PROMPT [2/6] Tworzenie pkg_nauczyciel (specification)...

CREATE OR REPLACE PACKAGE pkg_nauczyciel AS
    -- ═══════════════════════════════════════════════════════════════════════
    -- STAŁE
    -- ═══════════════════════════════════════════════════════════════════════
    c_max_godzin_tydzien CONSTANT NUMBER := 40;  -- maksymalne godziny/tydzień
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- TYPY
    -- ═══════════════════════════════════════════════════════════════════════
    TYPE t_cursor_nauczyciel IS REF CURSOR RETURN t_nauczyciel%ROWTYPE;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- PROCEDURY
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- Dodaje nowego nauczyciela
    PROCEDURE dodaj_nauczyciela(
        p_imie          IN VARCHAR2,
        p_nazwisko      IN VARCHAR2,
        p_email         IN VARCHAR2,
        p_instrumenty   IN t_lista_instrumentow,
        p_id_nauczyciela OUT NUMBER
    );
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- FUNKCJE
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- Sprawdza limit godzin nauczyciela w danym tygodniu
    -- @param p_id_nauczyciela - ID nauczyciela
    -- @param p_data - dowolny dzień z danego tygodnia
    -- @return liczba przepracowanych godzin w tym tygodniu
    FUNCTION godziny_w_tygodniu(
        p_id_nauczyciela IN NUMBER,
        p_data           IN DATE
    ) RETURN NUMBER;
    
    -- Sprawdza czy nauczyciel może prowadzić dodatkową lekcję
    -- @param p_id_nauczyciela - ID nauczyciela
    -- @param p_data - data planowanej lekcji
    -- @param p_czas_trwania - czas trwania lekcji (minuty)
    -- @return TRUE jeśli może, FALSE jeśli przekroczyłby limit
    FUNCTION czy_moze_dodac_lekcje(
        p_id_nauczyciela IN NUMBER,
        p_data           IN DATE,
        p_czas_trwania   IN NUMBER DEFAULT 45
    ) RETURN BOOLEAN;
    
    -- Lista nauczycieli uczących danego instrumentu
    FUNCTION lista_nauczycieli_instrumentu(
        p_nazwa_instrumentu IN VARCHAR2
    ) RETURN t_cursor_nauczyciel;

END pkg_nauczyciel;
/

SHOW ERRORS PACKAGE pkg_nauczyciel;

PROMPT [2/6] Tworzenie pkg_nauczyciel (body)...

CREATE OR REPLACE PACKAGE BODY pkg_nauczyciel AS
    
    PROCEDURE dodaj_nauczyciela(
        p_imie          IN VARCHAR2,
        p_nazwisko      IN VARCHAR2,
        p_email         IN VARCHAR2,
        p_instrumenty   IN t_lista_instrumentow,
        p_id_nauczyciela OUT NUMBER
    ) AS
    BEGIN
        -- Walidacja instrumentów
        IF p_instrumenty IS NULL OR p_instrumenty.COUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20201,
                'Nauczyciel musi mieć przypisany przynajmniej 1 instrument.');
        END IF;
        
        -- Walidacja email
        IF p_email IS NOT NULL AND INSTR(p_email, '@') = 0 THEN
            RAISE_APPLICATION_ERROR(-20202,
                'Nieprawidłowy format email: ' || p_email);
        END IF;
        
        -- Pobierz ID z sekwencji
        p_id_nauczyciela := seq_nauczyciel.NEXTVAL;
        
        -- Wstaw rekord
        INSERT INTO t_nauczyciel VALUES (
            t_nauczyciel_obj(
                p_id_nauczyciela,
                p_imie,
                p_nazwisko,
                p_email,
                TRUNC(SYSDATE),   -- data_zatrudnienia
                'aktywny',        -- status
                p_instrumenty
            )
        );
        
        DBMS_OUTPUT.PUT_LINE('Dodano nauczyciela: ' || p_imie || ' ' || p_nazwisko || 
                             ' (ID: ' || p_id_nauczyciela || ')');
    END dodaj_nauczyciela;
    
    -- ───────────────────────────────────────────────────────────────────────
    
    FUNCTION godziny_w_tygodniu(
        p_id_nauczyciela IN NUMBER,
        p_data           IN DATE
    ) RETURN NUMBER AS
        v_suma_minut NUMBER := 0;
        v_poniedzialek DATE;
        v_niedziela DATE;
    BEGIN
        -- Wyznacz poniedziałek i niedzielę danego tygodnia
        -- TRUNC z 'IW' (ISO Week) zwraca poniedziałek
        v_poniedzialek := TRUNC(p_data, 'IW');
        v_niedziela := v_poniedzialek + 6;
        
        -- Zlicz minuty wszystkich lekcji w tym tygodniu
        SELECT NVL(SUM(l.czas_trwania), 0)
        INTO v_suma_minut
        FROM t_lekcja l
        WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = p_id_nauczyciela
          AND l.data_lekcji BETWEEN v_poniedzialek AND v_niedziela
          AND l.status IN ('zaplanowana', 'odbyta');
        
        -- Zwróć godziny (minuty / 60)
        RETURN v_suma_minut / 60;
    END godziny_w_tygodniu;
    
    -- ───────────────────────────────────────────────────────────────────────
    
    FUNCTION czy_moze_dodac_lekcje(
        p_id_nauczyciela IN NUMBER,
        p_data           IN DATE,
        p_czas_trwania   IN NUMBER DEFAULT 45
    ) RETURN BOOLEAN AS
        v_obecne_godziny NUMBER;
        v_nowe_godziny NUMBER;
    BEGIN
        -- Pobierz obecne godziny w tygodniu
        v_obecne_godziny := godziny_w_tygodniu(p_id_nauczyciela, p_data);
        
        -- Oblicz nowe godziny po dodaniu lekcji
        v_nowe_godziny := v_obecne_godziny + (p_czas_trwania / 60);
        
        -- Sprawdź limit
        RETURN (v_nowe_godziny <= c_max_godzin_tydzien);
    END czy_moze_dodac_lekcje;
    
    -- ───────────────────────────────────────────────────────────────────────
    
    FUNCTION lista_nauczycieli_instrumentu(
        p_nazwa_instrumentu IN VARCHAR2
    ) RETURN t_cursor_nauczyciel AS
        v_cursor t_cursor_nauczyciel;
    BEGIN
        -- ═══════════════════════════════════════════════════════════════
        -- UWAGA: Zapytanie na VARRAY (kolekcja)
        -- ═══════════════════════════════════════════════════════════════
        -- VARRAY trzeba "rozpakować" używając TABLE():
        --   TABLE(n.instrumenty) - zamienia VARRAY na "tabelę wirtualną"
        --   COLUMN_VALUE - pseudo-kolumna dla elementów VARRAY
        -- ═══════════════════════════════════════════════════════════════
        OPEN v_cursor FOR
            SELECT n.*
            FROM t_nauczyciel n,
                 TABLE(n.instrumenty) instr
            WHERE UPPER(COLUMN_VALUE) = UPPER(p_nazwa_instrumentu)
              AND n.status = 'aktywny';
        
        RETURN v_cursor;
    END lista_nauczycieli_instrumentu;

END pkg_nauczyciel;
/

SHOW ERRORS PACKAGE BODY pkg_nauczyciel;

-- ============================================================================
-- PAKIET 3: pkg_lekcja
-- ============================================================================
--
-- 🔴🔴🔴 NAJWAŻNIEJSZY PAKIET - WALIDACJA KONFLIKTÓW! 🔴🔴🔴
--
-- CEL: Zarządzanie lekcjami z pełną walidacją konfliktów
--
-- DLACZEGO WALIDACJE SĄ TUTAJ (NIE W TRIGGERZE)?
-- -----------------------------------------------
-- 1. ORA-04091 - Mutating Table
--    Trigger BEFORE INSERT FOR EACH ROW nie może wykonać SELECT
--    na tabeli t_lekcja, bo właśnie do niej wstawiamy.
--
-- 2. Big Rocks First
--    Heurystyka planowania: najpierw planuj "wielkie kamienie" (lekcje
--    z wieloma ograniczeniami), potem wypełniaj luki.
--
-- WALIDACJE W TYM PAKIECIE:
-- -------------------------
--   A) sprawdz_konflikt_sali()       - sala nie może mieć 2 lekcji naraz
--   B) sprawdz_konflikt_nauczyciela() - nauczyciel nie może uczyć 2 grup naraz
--   C) sprawdz_konflikt_ucznia()     - uczeń nie może mieć 2 lekcji naraz
--   D) sprawdz_godzine_dla_typu()    - 'uczacy_sie_w_innej_szkole' od 15:00
--   E) sprawdz_limit_godzin()        - nauczyciel max 40h/tydzień
--
-- ============================================================================

PROMPT [3/6] Tworzenie pkg_lekcja (specification)...

CREATE OR REPLACE PACKAGE pkg_lekcja AS
    -- ═══════════════════════════════════════════════════════════════════════
    -- STAŁE
    -- ═══════════════════════════════════════════════════════════════════════
    c_max_godzin_nauczyciel CONSTANT NUMBER := 40;  -- max godzin/tydzień
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- PROCEDURY GŁÓWNE
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- 🔴 GŁÓWNA PROCEDURA - używaj TYLKO jej do dodawania lekcji!
    -- Wykonuje PEŁNĄ walidację wszystkich konfliktów
    --
    -- @param p_typ_lekcji      - 'indywidualna' lub 'grupowa'
    -- @param p_data_lekcji     - data lekcji
    -- @param p_godzina_start   - godzina rozpoczęcia
    -- @param p_czas_trwania    - czas trwania (minuty)
    -- @param p_ref_sala        - REF do sali
    -- @param p_ref_nauczyciel  - REF do nauczyciela
    -- @param p_ref_przedmiot   - REF do przedmiotu
    -- @param p_ref_semestr     - REF do semestru
    -- @param p_ref_uczen       - REF do ucznia (dla indywidualnej)
    -- @param p_ref_grupa       - REF do grupy (dla grupowej)
    -- @param p_id_lekcji       - OUT: ID nowej lekcji
    PROCEDURE dodaj_lekcje(
        p_typ_lekcji        IN VARCHAR2,
        p_data_lekcji       IN DATE,
        p_godzina_start     IN VARCHAR2,  -- format 'HH24:MI'
        p_czas_trwania      IN NUMBER DEFAULT 45,
        p_ref_sala          IN REF t_sala_obj,
        p_ref_nauczyciel    IN REF t_nauczyciel_obj,
        p_ref_przedmiot     IN REF t_przedmiot_obj,
        p_ref_semestr       IN REF t_semestr_obj,
        p_ref_uczen         IN REF t_uczen_obj DEFAULT NULL,
        p_ref_grupa         IN REF t_grupa_obj DEFAULT NULL,
        p_id_lekcji         OUT NUMBER
    );
    
    -- Zmienia status lekcji
    PROCEDURE zmien_status(
        p_id_lekcji    IN NUMBER,
        p_nowy_status  IN VARCHAR2  -- 'zaplanowana', 'odbyta', 'odwolana'
    );
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- FUNKCJE WALIDACYJNE (publiczne - dla testów/raportów)
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- Sprawdza konflikt sali
    -- @return TRUE jeśli jest konflikt, FALSE jeśli brak konfliktu
    FUNCTION sprawdz_konflikt_sali(
        p_id_sali       IN NUMBER,
        p_data_lekcji   IN DATE,
        p_godzina_start IN VARCHAR2,
        p_czas_trwania  IN NUMBER,
        p_id_lekcji_wyklucz IN NUMBER DEFAULT NULL  -- do UPDATE
    ) RETURN BOOLEAN;
    
    -- Sprawdza konflikt nauczyciela
    FUNCTION sprawdz_konflikt_nauczyciela(
        p_id_nauczyciela IN NUMBER,
        p_data_lekcji    IN DATE,
        p_godzina_start  IN VARCHAR2,
        p_czas_trwania   IN NUMBER,
        p_id_lekcji_wyklucz IN NUMBER DEFAULT NULL
    ) RETURN BOOLEAN;
    
    -- Sprawdza konflikt ucznia
    FUNCTION sprawdz_konflikt_ucznia(
        p_id_ucznia     IN NUMBER,
        p_data_lekcji   IN DATE,
        p_godzina_start IN VARCHAR2,
        p_czas_trwania  IN NUMBER,
        p_id_lekcji_wyklucz IN NUMBER DEFAULT NULL
    ) RETURN BOOLEAN;
    
    -- Sprawdza godzinę dla typu ucznia
    -- @return TRUE jeśli godzina OK, FALSE jeśli za wcześnie
    FUNCTION sprawdz_godzine_dla_typu(
        p_id_ucznia     IN NUMBER,
        p_godzina_start IN VARCHAR2
    ) RETURN BOOLEAN;

END pkg_lekcja;
/

SHOW ERRORS PACKAGE pkg_lekcja;

PROMPT [3/6] Tworzenie pkg_lekcja (body)...

CREATE OR REPLACE PACKAGE BODY pkg_lekcja AS
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- PRYWATNE FUNKCJE POMOCNICZE
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- Konwertuje string 'HH24:MI' na minuty od północy
    -- np. '14:30' → 870 (14*60 + 30)
    FUNCTION godzina_na_minuty(p_godzina VARCHAR2) RETURN NUMBER IS
    BEGIN
        RETURN TO_NUMBER(SUBSTR(p_godzina, 1, 2)) * 60 + 
               TO_NUMBER(SUBSTR(p_godzina, 4, 2));
    END godzina_na_minuty;
    
    -- Sprawdza czy dwa przedziały czasowe nachodzą na siebie
    -- [start1, koniec1) ∩ [start2, koniec2) ≠ ∅
    FUNCTION przedzialy_nachodza(
        p_start1_min NUMBER, p_koniec1_min NUMBER,
        p_start2_min NUMBER, p_koniec2_min NUMBER
    ) RETURN BOOLEAN IS
    BEGIN
        -- Nie nachodzą jeśli: jeden kończy się przed/gdy drugi zaczyna
        -- Nachodzą w przeciwnym wypadku
        RETURN NOT (p_koniec1_min <= p_start2_min OR p_koniec2_min <= p_start1_min);
    END przedzialy_nachodza;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- FUNKCJE WALIDACYJNE - IMPLEMENTACJA
    -- ═══════════════════════════════════════════════════════════════════════
    
    FUNCTION sprawdz_konflikt_sali(
        p_id_sali       IN NUMBER,
        p_data_lekcji   IN DATE,
        p_godzina_start IN VARCHAR2,
        p_czas_trwania  IN NUMBER,
        p_id_lekcji_wyklucz IN NUMBER DEFAULT NULL
    ) RETURN BOOLEAN IS
        v_nowa_start_min NUMBER := godzina_na_minuty(p_godzina_start);
        v_nowa_koniec_min NUMBER := v_nowa_start_min + p_czas_trwania;
        v_konflikt NUMBER := 0;
    BEGIN
        -- ═══════════════════════════════════════════════════════════════
        -- KLUCZOWE ZAPYTANIE - szukamy nakładających się lekcji
        -- ═══════════════════════════════════════════════════════════════
        -- 
        -- Dwie lekcje nakładają się jeśli:
        --   NIE (lekcja1_koniec <= lekcja2_start OR lekcja2_koniec <= lekcja1_start)
        --
        -- Przykład konfliktu:
        --   Lekcja A: 14:00-14:45 (start=840, koniec=885)
        --   Lekcja B: 14:30-15:15 (start=870, koniec=915)
        --   Nachodzą bo: 885 > 870 AND 915 > 840
        --
        -- ═══════════════════════════════════════════════════════════════
        SELECT COUNT(*)
        INTO v_konflikt
        FROM t_lekcja l
        WHERE DEREF(l.ref_sala).id_sali = p_id_sali
          AND l.data_lekcji = p_data_lekcji
          AND l.status IN ('zaplanowana', 'odbyta')
          AND (p_id_lekcji_wyklucz IS NULL OR l.id_lekcji != p_id_lekcji_wyklucz)
          -- Warunek nakładania się przedziałów:
          -- NIE (nowa_koniec <= istniejaca_start OR istniejaca_koniec <= nowa_start)
          AND NOT (
              v_nowa_koniec_min <= (TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                    TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)))
              OR
              (TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
               TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania) <= v_nowa_start_min
          );
        
        RETURN (v_konflikt > 0);
    END sprawdz_konflikt_sali;
    
    -- ───────────────────────────────────────────────────────────────────────
    
    FUNCTION sprawdz_konflikt_nauczyciela(
        p_id_nauczyciela IN NUMBER,
        p_data_lekcji    IN DATE,
        p_godzina_start  IN VARCHAR2,
        p_czas_trwania   IN NUMBER,
        p_id_lekcji_wyklucz IN NUMBER DEFAULT NULL
    ) RETURN BOOLEAN IS
        v_nowa_start_min NUMBER := godzina_na_minuty(p_godzina_start);
        v_nowa_koniec_min NUMBER := v_nowa_start_min + p_czas_trwania;
        v_konflikt NUMBER := 0;
    BEGIN
        SELECT COUNT(*)
        INTO v_konflikt
        FROM t_lekcja l
        WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = p_id_nauczyciela
          AND l.data_lekcji = p_data_lekcji
          AND l.status IN ('zaplanowana', 'odbyta')
          AND (p_id_lekcji_wyklucz IS NULL OR l.id_lekcji != p_id_lekcji_wyklucz)
          AND NOT (
              v_nowa_koniec_min <= (TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                    TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)))
              OR
              (TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
               TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania) <= v_nowa_start_min
          );
        
        RETURN (v_konflikt > 0);
    END sprawdz_konflikt_nauczyciela;
    
    -- ───────────────────────────────────────────────────────────────────────
    
    FUNCTION sprawdz_konflikt_ucznia(
        p_id_ucznia     IN NUMBER,
        p_data_lekcji   IN DATE,
        p_godzina_start IN VARCHAR2,
        p_czas_trwania  IN NUMBER,
        p_id_lekcji_wyklucz IN NUMBER DEFAULT NULL
    ) RETURN BOOLEAN IS
        v_nowa_start_min NUMBER := godzina_na_minuty(p_godzina_start);
        v_nowa_koniec_min NUMBER := v_nowa_start_min + p_czas_trwania;
        v_konflikt NUMBER := 0;
    BEGIN
        -- Sprawdzamy lekcje indywidualne danego ucznia
        SELECT COUNT(*)
        INTO v_konflikt
        FROM t_lekcja l
        WHERE DEREF(l.ref_uczen).id_ucznia = p_id_ucznia
          AND l.data_lekcji = p_data_lekcji
          AND l.status IN ('zaplanowana', 'odbyta')
          AND (p_id_lekcji_wyklucz IS NULL OR l.id_lekcji != p_id_lekcji_wyklucz)
          AND NOT (
              v_nowa_koniec_min <= (TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                    TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)))
              OR
              (TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
               TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania) <= v_nowa_start_min
          );
        
        -- TODO: Sprawdzić też lekcje grupowe jeśli uczeń należy do jakiejś grupy
        
        RETURN (v_konflikt > 0);
    END sprawdz_konflikt_ucznia;
    
    -- ───────────────────────────────────────────────────────────────────────
    
    FUNCTION sprawdz_godzine_dla_typu(
        p_id_ucznia     IN NUMBER,
        p_godzina_start IN VARCHAR2
    ) RETURN BOOLEAN IS
        v_typ_ucznia VARCHAR2(50);
        v_godzina NUMBER := TO_NUMBER(SUBSTR(p_godzina_start, 1, 2));
    BEGIN
        -- Pobierz typ ucznia
        SELECT typ_ucznia INTO v_typ_ucznia
        FROM t_uczen
        WHERE id_ucznia = p_id_ucznia;
        
        -- ═══════════════════════════════════════════════════════════════
        -- 🔴 KLUCZOWA REGUŁA BIZNESOWA 🔴
        -- ═══════════════════════════════════════════════════════════════
        -- 'uczacy_sie_w_innej_szkole' → lekcje od 15:00
        --   (dzieci chodzą do zwykłej szkoły, wracają ok 14:30)
        --
        -- 'ukonczyl_edukacje' → lekcje od 14:00
        -- 'tylko_muzyczna'    → lekcje od 14:00
        -- ═══════════════════════════════════════════════════════════════
        IF v_typ_ucznia = 'uczacy_sie_w_innej_szkole' THEN
            RETURN (v_godzina >= 15);
        ELSE
            RETURN (v_godzina >= 14);
        END IF;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN FALSE;
    END sprawdz_godzine_dla_typu;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- PROCEDURY GŁÓWNE - IMPLEMENTACJA
    -- ═══════════════════════════════════════════════════════════════════════
    
    PROCEDURE dodaj_lekcje(
        p_typ_lekcji        IN VARCHAR2,
        p_data_lekcji       IN DATE,
        p_godzina_start     IN VARCHAR2,
        p_czas_trwania      IN NUMBER DEFAULT 45,
        p_ref_sala          IN REF t_sala_obj,
        p_ref_nauczyciel    IN REF t_nauczyciel_obj,
        p_ref_przedmiot     IN REF t_przedmiot_obj,
        p_ref_semestr       IN REF t_semestr_obj,
        p_ref_uczen         IN REF t_uczen_obj DEFAULT NULL,
        p_ref_grupa         IN REF t_grupa_obj DEFAULT NULL,
        p_id_lekcji         OUT NUMBER
    ) AS
        -- Zmienne do przechowywania ID z REF-ów (do walidacji)
        v_id_sali        NUMBER;
        v_id_nauczyciela NUMBER;
        v_id_ucznia      NUMBER;
        v_sala           t_sala_obj;
        v_nauczyciel     t_nauczyciel_obj;
        v_uczen          t_uczen_obj;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== DODAWANIE LEKCJI ===');
        DBMS_OUTPUT.PUT_LINE('Typ: ' || p_typ_lekcji);
        DBMS_OUTPUT.PUT_LINE('Data: ' || TO_CHAR(p_data_lekcji, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Godzina: ' || p_godzina_start);
        
        -- ═══════════════════════════════════════════════════════════════
        -- WALIDACJA 1: XOR (uczeń XOR grupa)
        -- ═══════════════════════════════════════════════════════════════
        IF p_typ_lekcji = 'indywidualna' THEN
            IF p_ref_uczen IS NULL THEN
                RAISE_APPLICATION_ERROR(-20301,
                    'Lekcja indywidualna wymaga przypisania ucznia (p_ref_uczen).');
            END IF;
            IF p_ref_grupa IS NOT NULL THEN
                RAISE_APPLICATION_ERROR(-20302,
                    'Lekcja indywidualna nie może mieć przypisanej grupy.');
            END IF;
        ELSIF p_typ_lekcji = 'grupowa' THEN
            IF p_ref_grupa IS NULL THEN
                RAISE_APPLICATION_ERROR(-20303,
                    'Lekcja grupowa wymaga przypisania grupy (p_ref_grupa).');
            END IF;
            IF p_ref_uczen IS NOT NULL THEN
                RAISE_APPLICATION_ERROR(-20304,
                    'Lekcja grupowa nie może mieć przypisanego pojedynczego ucznia.');
            END IF;
        ELSE
            RAISE_APPLICATION_ERROR(-20305,
                'Nieprawidłowy typ lekcji: "' || p_typ_lekcji || '". ' ||
                'Dozwolone: indywidualna, grupowa.');
        END IF;
        DBMS_OUTPUT.PUT_LINE('[✓] XOR (uczeń/grupa) - OK');
        
        -- ═══════════════════════════════════════════════════════════════
        -- POBRANIE ID Z REF-ów (do walidacji)
        -- ═══════════════════════════════════════════════════════════════
        -- DEREF() zamienia REF na obiekt
        SELECT DEREF(p_ref_sala) INTO v_sala FROM DUAL;
        v_id_sali := v_sala.id_sali;
        
        SELECT DEREF(p_ref_nauczyciel) INTO v_nauczyciel FROM DUAL;
        v_id_nauczyciela := v_nauczyciel.id_nauczyciela;
        
        IF p_ref_uczen IS NOT NULL THEN
            SELECT DEREF(p_ref_uczen) INTO v_uczen FROM DUAL;
            v_id_ucznia := v_uczen.id_ucznia;
        END IF;
        
        -- ═══════════════════════════════════════════════════════════════
        -- WALIDACJA 2: Konflikt sali
        -- ═══════════════════════════════════════════════════════════════
        IF sprawdz_konflikt_sali(v_id_sali, p_data_lekcji, p_godzina_start, p_czas_trwania) THEN
            RAISE_APPLICATION_ERROR(-20310,
                'KONFLIKT SALI! Sala ID=' || v_id_sali || 
                ' jest już zajęta w dniu ' || TO_CHAR(p_data_lekcji, 'YYYY-MM-DD') ||
                ' o godzinie ' || p_godzina_start || '.');
        END IF;
        DBMS_OUTPUT.PUT_LINE('[✓] Konflikt sali - brak');
        
        -- ═══════════════════════════════════════════════════════════════
        -- WALIDACJA 3: Konflikt nauczyciela
        -- ═══════════════════════════════════════════════════════════════
        IF sprawdz_konflikt_nauczyciela(v_id_nauczyciela, p_data_lekcji, p_godzina_start, p_czas_trwania) THEN
            RAISE_APPLICATION_ERROR(-20311,
                'KONFLIKT NAUCZYCIELA! Nauczyciel ID=' || v_id_nauczyciela ||
                ' ma już inną lekcję w dniu ' || TO_CHAR(p_data_lekcji, 'YYYY-MM-DD') ||
                ' o godzinie ' || p_godzina_start || '.');
        END IF;
        DBMS_OUTPUT.PUT_LINE('[✓] Konflikt nauczyciela - brak');
        
        -- ═══════════════════════════════════════════════════════════════
        -- WALIDACJA 4: Konflikt ucznia (tylko dla indywidualnej)
        -- ═══════════════════════════════════════════════════════════════
        IF p_typ_lekcji = 'indywidualna' THEN
            IF sprawdz_konflikt_ucznia(v_id_ucznia, p_data_lekcji, p_godzina_start, p_czas_trwania) THEN
                RAISE_APPLICATION_ERROR(-20312,
                    'KONFLIKT UCZNIA! Uczeń ID=' || v_id_ucznia ||
                    ' ma już inną lekcję w dniu ' || TO_CHAR(p_data_lekcji, 'YYYY-MM-DD') ||
                    ' o godzinie ' || p_godzina_start || '.');
            END IF;
            DBMS_OUTPUT.PUT_LINE('[✓] Konflikt ucznia - brak');
            
            -- ═══════════════════════════════════════════════════════════
            -- WALIDACJA 5: Godzina dla typu ucznia
            -- ═══════════════════════════════════════════════════════════
            IF NOT sprawdz_godzine_dla_typu(v_id_ucznia, p_godzina_start) THEN
                RAISE_APPLICATION_ERROR(-20313,
                    'GODZINA NIEDOZWOLONA! Uczeń ID=' || v_id_ucznia ||
                    ' (typ: ' || v_uczen.typ_ucznia || ') ' ||
                    'nie może mieć lekcji o ' || p_godzina_start || '. ' ||
                    CASE v_uczen.typ_ucznia 
                        WHEN 'uczacy_sie_w_innej_szkole' THEN 'Minimalna godzina: 15:00'
                        ELSE 'Minimalna godzina: 14:00'
                    END);
            END IF;
            DBMS_OUTPUT.PUT_LINE('[✓] Godzina dla typu ucznia - OK');
        END IF;
        
        -- ═══════════════════════════════════════════════════════════════
        -- WALIDACJA 6: Limit godzin nauczyciela (40h/tydzień)
        -- ═══════════════════════════════════════════════════════════════
        IF NOT pkg_nauczyciel.czy_moze_dodac_lekcje(v_id_nauczyciela, p_data_lekcji, p_czas_trwania) THEN
            RAISE_APPLICATION_ERROR(-20314,
                'LIMIT GODZIN! Nauczyciel ID=' || v_id_nauczyciela ||
                ' przekroczyłby limit ' || pkg_nauczyciel.c_max_godzin_tydzien ||
                'h/tydzień po dodaniu tej lekcji. ' ||
                'Obecne godziny w tym tygodniu: ' || 
                ROUND(pkg_nauczyciel.godziny_w_tygodniu(v_id_nauczyciela, p_data_lekcji), 1) || 'h');
        END IF;
        DBMS_OUTPUT.PUT_LINE('[✓] Limit godzin nauczyciela - OK');
        
        -- ═══════════════════════════════════════════════════════════════
        -- WSZYSTKIE WALIDACJE OK - WSTAW LEKCJĘ!
        -- ═══════════════════════════════════════════════════════════════
        p_id_lekcji := seq_lekcja.NEXTVAL;
        
        INSERT INTO t_lekcja VALUES (
            t_lekcja_obj(
                p_id_lekcji,
                p_typ_lekcji,
                p_data_lekcji,
                p_godzina_start,
                p_czas_trwania,
                'zaplanowana',    -- status
                p_ref_sala,
                p_ref_nauczyciel,
                p_ref_przedmiot,
                p_ref_semestr,
                p_ref_uczen,
                p_ref_grupa
            )
        );
        
        DBMS_OUTPUT.PUT_LINE('=== LEKCJA DODANA POMYŚLNIE ===');
        DBMS_OUTPUT.PUT_LINE('ID lekcji: ' || p_id_lekcji);
        
    END dodaj_lekcje;
    
    -- ───────────────────────────────────────────────────────────────────────
    
    PROCEDURE zmien_status(
        p_id_lekcji    IN NUMBER,
        p_nowy_status  IN VARCHAR2
    ) AS
    BEGIN
        UPDATE t_lekcja
        SET status = p_nowy_status
        WHERE id_lekcji = p_id_lekcji;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20320,
                'Nie znaleziono lekcji o ID=' || p_id_lekcji);
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('Zmieniono status lekcji ID=' || p_id_lekcji ||
                             ' na: ' || p_nowy_status);
    END zmien_status;

END pkg_lekcja;
/

SHOW ERRORS PACKAGE BODY pkg_lekcja;

-- ============================================================================
-- PAKIET 4: pkg_ocena
-- ============================================================================
--
-- CEL: Zarządzanie ocenami
--
-- ============================================================================

PROMPT [4/6] Tworzenie pkg_ocena (specification)...

CREATE OR REPLACE PACKAGE pkg_ocena AS
    
    -- Dodaje ocenę
    PROCEDURE dodaj_ocene(
        p_wartosc         IN NUMBER,
        p_opis            IN VARCHAR2,
        p_ref_uczen       IN REF t_uczen_obj,
        p_ref_przedmiot   IN REF t_przedmiot_obj,
        p_ref_nauczyciel  IN REF t_nauczyciel_obj,
        p_ref_semestr     IN REF t_semestr_obj,
        p_id_oceny        OUT NUMBER
    );
    
    -- Oblicza średnią ocen ucznia w semestrze
    FUNCTION srednia_ucznia_semestr(
        p_id_ucznia   IN NUMBER,
        p_id_semestru IN NUMBER
    ) RETURN NUMBER;
    
    -- Oblicza średnią ocen ucznia z przedmiotu
    FUNCTION srednia_ucznia_przedmiot(
        p_id_ucznia    IN NUMBER,
        p_id_przedmiotu IN NUMBER
    ) RETURN NUMBER;

END pkg_ocena;
/

SHOW ERRORS PACKAGE pkg_ocena;

PROMPT [4/6] Tworzenie pkg_ocena (body)...

CREATE OR REPLACE PACKAGE BODY pkg_ocena AS
    
    PROCEDURE dodaj_ocene(
        p_wartosc         IN NUMBER,
        p_opis            IN VARCHAR2,
        p_ref_uczen       IN REF t_uczen_obj,
        p_ref_przedmiot   IN REF t_przedmiot_obj,
        p_ref_nauczyciel  IN REF t_nauczyciel_obj,
        p_ref_semestr     IN REF t_semestr_obj,
        p_id_oceny        OUT NUMBER
    ) AS
    BEGIN
        -- Walidacja wartości oceny
        IF p_wartosc NOT IN (1, 2, 3, 4, 5, 6) THEN
            RAISE_APPLICATION_ERROR(-20401,
                'Nieprawidłowa wartość oceny: ' || p_wartosc || '. ' ||
                'Dozwolone: 1, 2, 3, 4, 5, 6');
        END IF;
        
        -- Pobierz ID z sekwencji
        p_id_oceny := seq_ocena.NEXTVAL;
        
        -- Wstaw ocenę
        INSERT INTO t_ocena VALUES (
            t_ocena_obj(
                p_id_oceny,
                p_wartosc,
                TRUNC(SYSDATE),  -- data_oceny
                p_opis,
                p_ref_uczen,
                p_ref_przedmiot,
                p_ref_nauczyciel,
                p_ref_semestr
            )
        );
        
        DBMS_OUTPUT.PUT_LINE('Dodano ocenę: ' || p_wartosc || ' (ID: ' || p_id_oceny || ')');
    END dodaj_ocene;
    
    -- ───────────────────────────────────────────────────────────────────────
    
    FUNCTION srednia_ucznia_semestr(
        p_id_ucznia   IN NUMBER,
        p_id_semestru IN NUMBER
    ) RETURN NUMBER AS
        v_srednia NUMBER;
    BEGIN
        SELECT AVG(o.wartosc)
        INTO v_srednia
        FROM t_ocena o
        WHERE DEREF(o.ref_uczen).id_ucznia = p_id_ucznia
          AND DEREF(o.ref_semestr).id_semestru = p_id_semestru;
        
        RETURN ROUND(v_srednia, 2);
    END srednia_ucznia_semestr;
    
    -- ───────────────────────────────────────────────────────────────────────
    
    FUNCTION srednia_ucznia_przedmiot(
        p_id_ucznia    IN NUMBER,
        p_id_przedmiotu IN NUMBER
    ) RETURN NUMBER AS
        v_srednia NUMBER;
    BEGIN
        SELECT AVG(o.wartosc)
        INTO v_srednia
        FROM t_ocena o
        WHERE DEREF(o.ref_uczen).id_ucznia = p_id_ucznia
          AND DEREF(o.ref_przedmiot).id_przedmiotu = p_id_przedmiotu;
        
        RETURN ROUND(v_srednia, 2);
    END srednia_ucznia_przedmiot;

END pkg_ocena;
/

SHOW ERRORS PACKAGE BODY pkg_ocena;

-- ============================================================================
-- PAKIET 5: pkg_raport
-- ============================================================================
--
-- CEL: Generowanie raportów
--
-- ============================================================================

PROMPT [5/6] Tworzenie pkg_raport (specification)...

CREATE OR REPLACE PACKAGE pkg_raport AS
    
    -- Raport: plan lekcji ucznia na dany tydzień
    PROCEDURE plan_ucznia(
        p_id_ucznia IN NUMBER,
        p_data      IN DATE DEFAULT SYSDATE
    );
    
    -- Raport: plan lekcji nauczyciela na dany tydzień
    PROCEDURE plan_nauczyciela(
        p_id_nauczyciela IN NUMBER,
        p_data           IN DATE DEFAULT SYSDATE
    );
    
    -- Raport: obłożenie sal w danym dniu
    PROCEDURE oblozenie_sal(
        p_data IN DATE DEFAULT SYSDATE
    );
    
    -- Raport: statystyki semestru
    PROCEDURE statystyki_semestru(
        p_id_semestru IN NUMBER
    );

END pkg_raport;
/

SHOW ERRORS PACKAGE pkg_raport;

PROMPT [5/6] Tworzenie pkg_raport (body)...

CREATE OR REPLACE PACKAGE BODY pkg_raport AS
    
    PROCEDURE plan_ucznia(
        p_id_ucznia IN NUMBER,
        p_data      IN DATE DEFAULT SYSDATE
    ) AS
        v_poniedzialek DATE := TRUNC(p_data, 'IW');
        v_niedziela DATE := v_poniedzialek + 6;
        v_imie VARCHAR2(50);
        v_nazwisko VARCHAR2(50);
    BEGIN
        -- Nagłówek
        SELECT imie, nazwisko INTO v_imie, v_nazwisko
        FROM t_uczen WHERE id_ucznia = p_id_ucznia;
        
        DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
        DBMS_OUTPUT.PUT_LINE('PLAN LEKCJI UCZNIA: ' || v_imie || ' ' || v_nazwisko);
        DBMS_OUTPUT.PUT_LINE('Tydzień: ' || TO_CHAR(v_poniedzialek, 'DD.MM') || 
                             ' - ' || TO_CHAR(v_niedziela, 'DD.MM.YYYY'));
        DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
        
        FOR rec IN (
            SELECT l.data_lekcji,
                   TO_CHAR(l.data_lekcji, 'DY', 'NLS_DATE_LANGUAGE=POLISH') AS dzien,
                   l.godzina_start,
                   l.czas_trwania,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_nauczyciel).imie || ' ' || 
                   DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
                   DEREF(l.ref_sala).numer_sali AS sala
            FROM t_lekcja l
            WHERE DEREF(l.ref_uczen).id_ucznia = p_id_ucznia
              AND l.data_lekcji BETWEEN v_poniedzialek AND v_niedziela
              AND l.status IN ('zaplanowana', 'odbyta')
            ORDER BY l.data_lekcji, l.godzina_start
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(rec.dzien, 4) || ' ' ||
                TO_CHAR(rec.data_lekcji, 'DD.MM') || ' | ' ||
                rec.godzina_start || ' | ' ||
                RPAD(NVL(rec.przedmiot, '-'), 20) || ' | ' ||
                RPAD(NVL(rec.nauczyciel, '-'), 25) || ' | sala ' ||
                rec.sala
            );
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono ucznia o ID=' || p_id_ucznia);
    END plan_ucznia;
    
    -- ───────────────────────────────────────────────────────────────────────
    
    PROCEDURE plan_nauczyciela(
        p_id_nauczyciela IN NUMBER,
        p_data           IN DATE DEFAULT SYSDATE
    ) AS
        v_poniedzialek DATE := TRUNC(p_data, 'IW');
        v_niedziela DATE := v_poniedzialek + 6;
        v_imie VARCHAR2(50);
        v_nazwisko VARCHAR2(50);
        v_suma_godzin NUMBER := 0;
    BEGIN
        -- Nagłówek
        SELECT imie, nazwisko INTO v_imie, v_nazwisko
        FROM t_nauczyciel WHERE id_nauczyciela = p_id_nauczyciela;
        
        DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
        DBMS_OUTPUT.PUT_LINE('PLAN NAUCZYCIELA: ' || v_imie || ' ' || v_nazwisko);
        DBMS_OUTPUT.PUT_LINE('Tydzień: ' || TO_CHAR(v_poniedzialek, 'DD.MM') || 
                             ' - ' || TO_CHAR(v_niedziela, 'DD.MM.YYYY'));
        DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
        
        FOR rec IN (
            SELECT l.data_lekcji,
                   TO_CHAR(l.data_lekcji, 'DY', 'NLS_DATE_LANGUAGE=POLISH') AS dzien,
                   l.godzina_start,
                   l.czas_trwania,
                   l.typ_lekcji,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   CASE l.typ_lekcji
                       WHEN 'indywidualna' THEN 
                           DEREF(l.ref_uczen).imie || ' ' || DEREF(l.ref_uczen).nazwisko
                       ELSE 
                           DEREF(l.ref_grupa).nazwa_grupy
                   END AS odbiorca,
                   DEREF(l.ref_sala).numer_sali AS sala
            FROM t_lekcja l
            WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = p_id_nauczyciela
              AND l.data_lekcji BETWEEN v_poniedzialek AND v_niedziela
              AND l.status IN ('zaplanowana', 'odbyta')
            ORDER BY l.data_lekcji, l.godzina_start
        ) LOOP
            v_suma_godzin := v_suma_godzin + rec.czas_trwania;
            
            DBMS_OUTPUT.PUT_LINE(
                RPAD(rec.dzien, 4) || ' ' ||
                TO_CHAR(rec.data_lekcji, 'DD.MM') || ' | ' ||
                rec.godzina_start || ' | ' ||
                RPAD(rec.typ_lekcji, 12) || ' | ' ||
                RPAD(NVL(rec.przedmiot, '-'), 15) || ' | ' ||
                RPAD(NVL(rec.odbiorca, '-'), 20) || ' | sala ' ||
                rec.sala
            );
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('───────────────────────────────────────────────────────────────');
        DBMS_OUTPUT.PUT_LINE('SUMA: ' || ROUND(v_suma_godzin / 60, 1) || ' godzin');
        DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono nauczyciela o ID=' || p_id_nauczyciela);
    END plan_nauczyciela;
    
    -- ───────────────────────────────────────────────────────────────────────
    
    PROCEDURE oblozenie_sal(
        p_data IN DATE DEFAULT SYSDATE
    ) AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
        DBMS_OUTPUT.PUT_LINE('OBŁOŻENIE SAL: ' || TO_CHAR(p_data, 'YYYY-MM-DD (DY)', 
                             'NLS_DATE_LANGUAGE=POLISH'));
        DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
        
        FOR rec IN (
            SELECT s.numer_sali,
                   s.typ_sali,
                   s.pojemnosc,
                   COUNT(l.id_lekcji) AS liczba_lekcji,
                   NVL(SUM(l.czas_trwania), 0) AS minuty_zajetosci
            FROM t_sala s
            LEFT JOIN t_lekcja l ON DEREF(l.ref_sala).id_sali = s.id_sali
                                AND l.data_lekcji = p_data
                                AND l.status IN ('zaplanowana', 'odbyta')
            WHERE s.status = 'dostepna'
            GROUP BY s.id_sali, s.numer_sali, s.typ_sali, s.pojemnosc
            ORDER BY s.numer_sali
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                'Sala ' || RPAD(rec.numer_sali, 8) || ' | ' ||
                RPAD(rec.typ_sali, 15) || ' | ' ||
                'poj: ' || LPAD(rec.pojemnosc, 2) || ' | ' ||
                'lekcji: ' || LPAD(rec.liczba_lekcji, 2) || ' | ' ||
                'zajętość: ' || LPAD(ROUND(rec.minuty_zajetosci / 60, 1), 4) || 'h'
            );
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
    END oblozenie_sal;
    
    -- ───────────────────────────────────────────────────────────────────────
    
    PROCEDURE statystyki_semestru(
        p_id_semestru IN NUMBER
    ) AS
        v_nazwa_sem VARCHAR2(50);
        v_rok_akademicki VARCHAR2(20);
        v_liczba_uczniow NUMBER;
        v_liczba_lekcji NUMBER;
        v_srednia_ocen NUMBER;
    BEGIN
        -- Pobierz dane semestru
        SELECT nazwa_semestru, rok_akademicki
        INTO v_nazwa_sem, v_rok_akademicki
        FROM t_semestr WHERE id_semestru = p_id_semestru;
        
        -- Statystyki
        SELECT COUNT(DISTINCT DEREF(l.ref_uczen).id_ucznia)
        INTO v_liczba_uczniow
        FROM t_lekcja l
        WHERE DEREF(l.ref_semestr).id_semestru = p_id_semestru;
        
        SELECT COUNT(*)
        INTO v_liczba_lekcji
        FROM t_lekcja
        WHERE DEREF(ref_semestr).id_semestru = p_id_semestru;
        
        SELECT AVG(wartosc)
        INTO v_srednia_ocen
        FROM t_ocena
        WHERE DEREF(ref_semestr).id_semestru = p_id_semestru;
        
        DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
        DBMS_OUTPUT.PUT_LINE('STATYSTYKI SEMESTRU: ' || v_nazwa_sem || ' ' || v_rok_akademicki);
        DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
        DBMS_OUTPUT.PUT_LINE('Liczba aktywnych uczniów: ' || v_liczba_uczniow);
        DBMS_OUTPUT.PUT_LINE('Liczba lekcji:           ' || v_liczba_lekcji);
        DBMS_OUTPUT.PUT_LINE('Średnia ocen:            ' || NVL(ROUND(v_srednia_ocen, 2), 'brak'));
        DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono semestru o ID=' || p_id_semestru);
    END statystyki_semestru;

END pkg_raport;
/

SHOW ERRORS PACKAGE BODY pkg_raport;

-- ============================================================================
-- PAKIET 6: pkg_test (szkielet - szczegóły w 09_testy.sql)
-- ============================================================================
--
-- CEL: Testy automatyczne zgodne z audytową checklistą
--
-- ============================================================================

PROMPT [6/6] Tworzenie pkg_test (specification)...

CREATE OR REPLACE PACKAGE pkg_test AS
    
    -- Uruchamia wszystkie testy
    PROCEDURE uruchom_wszystkie;
    
    -- Testy podstawowe
    PROCEDURE test_typy_obiektow;
    PROCEDURE test_tabele;
    PROCEDURE test_ref_integralnosc;
    
    -- Testy walidacji
    PROCEDURE test_walidacja_wieku_ucznia;
    PROCEDURE test_walidacja_typ_ucznia;
    PROCEDURE test_walidacja_xor_lekcja;
    PROCEDURE test_walidacja_komisja_egzamin;
    
    -- Testy konfliktów
    PROCEDURE test_konflikt_sali;
    PROCEDURE test_konflikt_nauczyciela;
    PROCEDURE test_konflikt_ucznia;
    PROCEDURE test_godzina_typ_ucznia;
    
    -- Testy biznesowe
    PROCEDURE test_promocja_ucznia;
    PROCEDURE test_limit_godzin_nauczyciela;
    
    -- Helper: asercja
    PROCEDURE assert(
        p_warunek IN BOOLEAN,
        p_opis    IN VARCHAR2
    );

END pkg_test;
/

SHOW ERRORS PACKAGE pkg_test;

PROMPT [6/6] Tworzenie pkg_test (body - szkielet)...

CREATE OR REPLACE PACKAGE BODY pkg_test AS
    
    g_testy_ok NUMBER := 0;
    g_testy_fail NUMBER := 0;
    
    PROCEDURE assert(
        p_warunek IN BOOLEAN,
        p_opis    IN VARCHAR2
    ) AS
    BEGIN
        IF p_warunek THEN
            g_testy_ok := g_testy_ok + 1;
            DBMS_OUTPUT.PUT_LINE('[OK]   ' || p_opis);
        ELSE
            g_testy_fail := g_testy_fail + 1;
            DBMS_OUTPUT.PUT_LINE('[FAIL] ' || p_opis);
        END IF;
    END assert;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- Pełne implementacje testów będą w 09_testy.sql
    -- Tutaj tylko szkielet
    -- ═══════════════════════════════════════════════════════════════════════
    
    PROCEDURE test_typy_obiektow AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- TEST: Typy obiektów ---');
        -- Sprawdź czy typy istnieją w USER_TYPES
        NULL;
    END;
    
    PROCEDURE test_tabele AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- TEST: Tabele ---');
        -- Sprawdź czy tabele istnieją w USER_TABLES
        NULL;
    END;
    
    PROCEDURE test_ref_integralnosc AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- TEST: REF integralność ---');
        NULL;
    END;
    
    PROCEDURE test_walidacja_wieku_ucznia AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- TEST: Walidacja wieku ucznia ---');
        NULL;
    END;
    
    PROCEDURE test_walidacja_typ_ucznia AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- TEST: Walidacja typu ucznia ---');
        NULL;
    END;
    
    PROCEDURE test_walidacja_xor_lekcja AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- TEST: Walidacja XOR lekcja ---');
        NULL;
    END;
    
    PROCEDURE test_walidacja_komisja_egzamin AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- TEST: Walidacja komisja egzamin ---');
        NULL;
    END;
    
    PROCEDURE test_konflikt_sali AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- TEST: Konflikt sali ---');
        NULL;
    END;
    
    PROCEDURE test_konflikt_nauczyciela AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- TEST: Konflikt nauczyciela ---');
        NULL;
    END;
    
    PROCEDURE test_konflikt_ucznia AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- TEST: Konflikt ucznia ---');
        NULL;
    END;
    
    PROCEDURE test_godzina_typ_ucznia AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- TEST: Godzina dla typu ucznia ---');
        NULL;
    END;
    
    PROCEDURE test_promocja_ucznia AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- TEST: Promocja ucznia ---');
        NULL;
    END;
    
    PROCEDURE test_limit_godzin_nauczyciela AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- TEST: Limit godzin nauczyciela ---');
        NULL;
    END;
    
    PROCEDURE uruchom_wszystkie AS
    BEGIN
        g_testy_ok := 0;
        g_testy_fail := 0;
        
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
        DBMS_OUTPUT.PUT_LINE('          URUCHAMIANIE WSZYSTKICH TESTÓW');
        DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
        DBMS_OUTPUT.PUT_LINE('');
        
        test_typy_obiektow;
        test_tabele;
        test_ref_integralnosc;
        test_walidacja_wieku_ucznia;
        test_walidacja_typ_ucznia;
        test_walidacja_xor_lekcja;
        test_walidacja_komisja_egzamin;
        test_konflikt_sali;
        test_konflikt_nauczyciela;
        test_konflikt_ucznia;
        test_godzina_typ_ucznia;
        test_promocja_ucznia;
        test_limit_godzin_nauczyciela;
        
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
        DBMS_OUTPUT.PUT_LINE('PODSUMOWANIE: ' || g_testy_ok || ' OK, ' || g_testy_fail || ' FAIL');
        DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
    END uruchom_wszystkie;

END pkg_test;
/

SHOW ERRORS PACKAGE BODY pkg_test;

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================

PROMPT
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT   PODSUMOWANIE - Utworzone pakiety
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT
PROMPT   PAKIETY (6):
PROMPT     [✓] pkg_uczen      - dodaj, promuj, zmień status, lista
PROMPT     [✓] pkg_nauczyciel - dodaj, limit godzin, lista wg instrumentu
PROMPT     [✓] pkg_lekcja     - 🔴 WALIDACJE KONFLIKTÓW (sala/nauczyciel/uczeń)
PROMPT     [✓] pkg_ocena      - dodaj, średnie
PROMPT     [✓] pkg_raport     - plan ucznia/nauczyciela, obłożenie sal
PROMPT     [✓] pkg_test       - szkielet testów (szczegóły w 09_testy.sql)
PROMPT
PROMPT   🔴 WAŻNE: Aby dodać lekcję, używaj ZAWSZE pkg_lekcja.dodaj_lekcje()!
PROMPT            Bezpośredni INSERT INTO t_lekcja OMIJA walidacje konfliktów!
PROMPT
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT   Następny krok: Uruchom 05_dane.sql
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT

-- Lista pakietów
SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('PACKAGE', 'PACKAGE BODY')
ORDER BY object_name, object_type;
