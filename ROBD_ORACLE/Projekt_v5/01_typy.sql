-- ============================================================================
-- PLIK: 01_typy.sql
-- PROJEKT: Szkoła Muzyczna v5 - Obiektowa Baza Danych Oracle
-- AUTORZY: Igor Typiński (251237), Mateusz Mróz (251190)
-- DATA: Styczeń 2026
-- ============================================================================
-- 
-- CO TEN PLIK ROBI?
-- -----------------
-- Definiuje 12 TYPÓW OBIEKTOWYCH (Object Types), które są fundamentem
-- obiektowo-relacyjnej bazy danych Oracle.
--
-- DLACZEGO TYPY OBIEKTOWE?
-- ------------------------
-- 1. Enkapsulacja - dane + metody w jednym miejscu
-- 2. Reużywalność - typ można użyć w wielu tabelach
-- 3. Dziedziczenie - typy mogą dziedziczyć (NOT FINAL)
-- 4. Relacje REF - wskaźniki do obiektów (zamiast FK)
-- 5. Metody MEMBER - logika biznesowa w typie
--
-- KOLEJNOŚĆ TWORZENIA (WAŻNA!)
-- ----------------------------
-- Oracle wymaga, by typy referencjonowane istniały PRZED użyciem.
-- Dlatego kolejność to:
--   1. VARRAY (kolekcje) - nie zależą od niczego
--   2. Typy bazowe (semestr, instrument, sala, nauczyciel, grupa)
--   3. Typy zależne (uczen → instrument, grupa)
--   4. Typy złożone (lekcja → wszystko)
--
-- JAK URUCHOMIĆ?
-- --------------
-- Jako użytkownik SZKOLA_MUZYCZNA (nie SYS!):
--   @01_typy.sql
-- lub w SQL Developer: F5 (Run Script)
--
-- ============================================================================

-- Ustawienia sesji dla czytelnego outputu
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200
SET PAGESIZE 50

PROMPT ╔═══════════════════════════════════════════════════════════════╗
PROMPT ║  01_typy.sql - Tworzenie typów obiektowych                    ║
PROMPT ╚═══════════════════════════════════════════════════════════════╝
PROMPT

-- ============================================================================
-- SEKCJA 1: KOLEKCJE (VARRAY)
-- ============================================================================
-- 
-- CO TO VARRAY?
-- -------------
-- VARRAY (Variable-size Array) to uporządkowana kolekcja elementów tego
-- samego typu z MAKSYMALNYM rozmiarem. Idealna gdy:
--   - Znamy górną granicę elementów
--   - Kolejność ma znaczenie
--   - Elementy są "częścią" obiektu (nie osobnymi encjami)
--
-- ALTERNATYWY:
--   - NESTED TABLE - bez limitu, osobne storage
--   - ASSOCIATIVE ARRAY - tylko w PL/SQL
--
-- ============================================================================

PROMPT [1/12] Tworzenie t_lista_instrumentow (VARRAY)...

-- -----------------------------------------------------------------------------
-- VARRAY: t_lista_instrumentow
-- -----------------------------------------------------------------------------
-- CEL: Przechowuje listę instrumentów, których uczy nauczyciel (max 5)
-- 
-- DLACZEGO MAX 5?
--   - Realnie nauczyciel specjalizuje się w 1-3 instrumentach
--   - 5 to rozsądny limit (np. fortepian + organy + klawesyn + akordeon + syntezator)
--   - Większa liczba sugerowałaby brak specjalizacji
--
-- PRZYKŁAD UŻYCIA:
--   t_lista_instrumentow('Fortepian', 'Organy', 'Klawesyn')
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TYPE t_lista_instrumentow AS VARRAY(5) OF VARCHAR2(100);
/

PROMPT [2/12] Tworzenie t_lista_sprzetu (VARRAY)...

-- -----------------------------------------------------------------------------
-- VARRAY: t_lista_sprzetu
-- -----------------------------------------------------------------------------
-- CEL: Przechowuje listę wyposażenia sali (max 10 pozycji)
--
-- DLACZEGO VARRAY A NIE OSOBNA TABELA?
--   - Sprzęt jest "częścią" sali, nie osobną encją
--   - Nie potrzebujemy relacji wiele-do-wielu (sprzęt w wielu salach)
--   - Prostsze zapytania i INSERT-y
--
-- PRZYKŁAD UŻYCIA:
--   t_lista_sprzetu('Fortepian Steinway', 'Pulpit nutowy', 'Lustro', 'Klimatyzacja')
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TYPE t_lista_sprzetu AS VARRAY(10) OF VARCHAR2(100);
/

-- ============================================================================
-- SEKCJA 2: TYPY BAZOWE (bez zależności REF)
-- ============================================================================
--
-- Te typy NIE zawierają REF do innych typów, więc mogą być tworzone pierwsze.
-- Mają tylko atrybuty skalarne i VARRAY.
--
-- ============================================================================

PROMPT [3/12] Tworzenie t_semestr_obj...

-- -----------------------------------------------------------------------------
-- TYP: t_semestr_obj
-- -----------------------------------------------------------------------------
-- CEL: Reprezentuje semestr akademicki (okres rozliczeniowy)
--
-- ATRYBUTY:
--   id_semestru   - klucz główny (NUMBER)
--   nazwa         - np. "2025/2026 Semestr zimowy"
--   data_start    - pierwszy dzień semestru
--   data_koniec   - ostatni dzień semestru
--   rok_szkolny   - np. "2025/2026" (dla grupowania)
--
-- METODY:
--   liczba_tygodni() - ile tygodni trwa semestr (15 to standard)
--   czy_aktywny()    - T/N - czy dzisiejsza data jest w przedziale
--   opis()           - tekstowy opis do raportów
--
-- DLACZEGO OSOBNA TABELA/TYP?
--   - Umożliwia historię (poprzednie semestry)
--   - Pozwala na różne parametry per semestr
--   - Ułatwia archiwizację
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TYPE t_semestr_obj AS OBJECT (
    -- ===== ATRYBUTY =====
    id_semestru       NUMBER,           -- PK - generowany przez sekwencję
    nazwa             VARCHAR2(50),      -- "2025/2026 Semestr zimowy"
    data_start        DATE,              -- Pierwszy dzień zajęć
    data_koniec       DATE,              -- Ostatni dzień zajęć
    rok_szkolny       VARCHAR2(9),       -- "2025/2026" - format RRRR/RRRR
    
    -- ===== METODY =====
    
    -- Oblicza liczbę pełnych tygodni w semestrze
    -- Używane do: walidacji (powinno być ~15), raportów
    MEMBER FUNCTION liczba_tygodni RETURN NUMBER,
    
    -- Sprawdza czy semestr jest obecnie aktywny
    -- Używane do: filtrowania danych, blokowania edycji zamkniętych semestrów
    MEMBER FUNCTION czy_aktywny RETURN CHAR,
    
    -- Zwraca czytelny opis semestru
    -- Używane do: wyświetlania w raportach, logach
    MEMBER FUNCTION opis RETURN VARCHAR2
    
) NOT FINAL;  -- NOT FINAL = można dziedziczyć (na przyszłość)
/

-- -----------------------------------------------------------------------------
-- IMPLEMENTACJA METOD: t_semestr_obj
-- -----------------------------------------------------------------------------
-- 
-- UWAGA O MEMBER FUNCTION:
-- - Pierwszy parametr (SELF) jest niejawny
-- - Dostęp do atrybutów: SELF.nazwa lub po prostu nazwa
-- - Muszą zwracać wartość (RETURN)
-- - Nie mogą modyfikować stanu obiektu (do tego MEMBER PROCEDURE)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TYPE BODY t_semestr_obj AS
    
    -- Liczba tygodni = różnica dni / 7, zaokrąglona w dół
    MEMBER FUNCTION liczba_tygodni RETURN NUMBER IS
    BEGIN
        -- TRUNC usuwa część ułamkową (np. 15.7 → 15)
        RETURN TRUNC((data_koniec - data_start) / 7);
    END;
    
    -- Czy dzisiejsza data mieści się w przedziale [start, koniec]?
    MEMBER FUNCTION czy_aktywny RETURN CHAR IS
    BEGIN
        IF SYSDATE BETWEEN data_start AND data_koniec THEN
            RETURN 'T';
        ELSE
            RETURN 'N';
        END IF;
    END;
    
    -- Formatowany opis: "2025/2026 Semestr zimowy (01.10.2025 - 31.01.2026)"
    MEMBER FUNCTION opis RETURN VARCHAR2 IS
    BEGIN
        RETURN nazwa || ' (' || 
               TO_CHAR(data_start, 'DD.MM.YYYY') || ' - ' || 
               TO_CHAR(data_koniec, 'DD.MM.YYYY') || ')';
    END;
    
END;
/

PROMPT [4/12] Tworzenie t_instrument_obj...

-- -----------------------------------------------------------------------------
-- TYP: t_instrument_obj
-- -----------------------------------------------------------------------------
-- CEL: Reprezentuje instrument muzyczny (słownik)
--
-- ATRYBUTY:
--   id_instrumentu            - klucz główny
--   nazwa                     - np. "Fortepian", "Skrzypce"
--   kategoria                 - klasyfikacja: klawiszowe/strunowe/dete/perkusyjne
--   czy_wymaga_akompaniatora  - T/N - czy lekcje wymagają akompaniatora
--
-- DLACZEGO czy_wymaga_akompaniatora?
--   - Skrzypce, wiolonczela, instrumenty dęte potrzebują akompaniamentu
--   - Fortepian, gitara - nie potrzebują
--   - Wpływa na planowanie (trzeba znaleźć wolnego akompaniatora)
--
-- KATEGORIE INSTRUMENTÓW (zgodne z muzykologią):
--   - klawiszowe: fortepian, organy, klawesyn, akordeon
--   - strunowe: gitara, skrzypce, wiolonczela, harfa
--   - dete: flet, klarnet, saksofon, trąbka, puzon
--   - perkusyjne: perkusja, ksylofon, wibrafon
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TYPE t_instrument_obj AS OBJECT (
    id_instrumentu              NUMBER,
    nazwa                       VARCHAR2(100),
    kategoria                   VARCHAR2(50),      -- klawiszowe/strunowe/dete/perkusyjne
    czy_wymaga_akompaniatora    CHAR(1),           -- T/N
    
    -- Zwraca opis: "Fortepian (klawiszowe)"
    MEMBER FUNCTION opis RETURN VARCHAR2,
    
    -- Sprawdza czy instrument jest smyczkowy (skrzypce, altówka, wiolonczela, kontrabas)
    -- Przydatne bo smyczkowe ZAWSZE wymagają akompaniatora
    MEMBER FUNCTION czy_smyczkowy RETURN CHAR
    
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY t_instrument_obj AS
    
    MEMBER FUNCTION opis RETURN VARCHAR2 IS
    BEGIN
        RETURN nazwa || ' (' || kategoria || ')';
    END;
    
    -- Smyczkowe to podzbiór strunowych (gitara jest strunowa, ale nie smyczkowa)
    MEMBER FUNCTION czy_smyczkowy RETURN CHAR IS
    BEGIN
        -- Lista instrumentów smyczkowych
        IF UPPER(nazwa) IN ('SKRZYPCE', 'ALTÓWKA', 'WIOLONCZELA', 'KONTRABAS') THEN
            RETURN 'T';
        ELSE
            RETURN 'N';
        END IF;
    END;
    
END;
/

PROMPT [5/12] Tworzenie t_sala_obj...

-- -----------------------------------------------------------------------------
-- TYP: t_sala_obj
-- -----------------------------------------------------------------------------
-- CEL: Reprezentuje salę lekcyjną
--
-- ATRYBUTY:
--   id_sali    - klucz główny
--   numer      - oznaczenie sali: "A1", "B2", "Sala koncertowa"
--   typ_sali   - indywidualna (1-3 osoby) / grupowa (10-30) / wielofunkcyjna (5-15)
--   pojemnosc  - maksymalna liczba osób
--   wyposazenie - VARRAY z listą sprzętu
--   status     - dostepna / niedostepna / remont
--
-- TYPY SAL (uzasadnienie):
--   - indywidualna: małe, z instrumentem, do lekcji 1:1
--   - grupowa: duże, z krzesłami, do teorii/chóru
--   - wielofunkcyjna: średnie, elastyczne wykorzystanie
--
-- WYPOSAŻENIE JAKO VARRAY:
--   - Elastyczne (różna liczba elementów)
--   - Przeszukiwalne (metoda czy_ma_sprzet)
--   - Nie wymaga osobnej tabeli
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TYPE t_sala_obj AS OBJECT (
    id_sali           NUMBER,
    numer             VARCHAR2(20),
    typ_sali          VARCHAR2(20),          -- indywidualna/grupowa/wielofunkcyjna
    pojemnosc         NUMBER,
    wyposazenie       t_lista_sprzetu,       -- VARRAY(10) - lista sprzętu
    status            VARCHAR2(20),          -- dostepna/niedostepna/remont
    
    -- Pełny opis sali do raportów
    MEMBER FUNCTION opis_pelny RETURN VARCHAR2,
    
    -- Sprawdza czy sala ma konkretny sprzęt (np. 'Fortepian')
    -- Używane przy szukaniu sali z wymaganym wyposażeniem
    MEMBER FUNCTION czy_ma_sprzet(p_nazwa VARCHAR2) RETURN CHAR,
    
    -- Sprawdza czy sala nadaje się do danego typu zajęć i liczby osób
    MEMBER FUNCTION czy_odpowiednia(p_typ VARCHAR2, p_osob NUMBER) RETURN CHAR
    
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY t_sala_obj AS
    
    -- Przykład wyniku: "Sala A1 (indywidualna, 2 os.) - Fortepian Yamaha, Pulpit"
    MEMBER FUNCTION opis_pelny RETURN VARCHAR2 IS
        v_sprzet VARCHAR2(500) := '';
    BEGIN
        -- Iteracja po VARRAY
        IF wyposazenie IS NOT NULL AND wyposazenie.COUNT > 0 THEN
            FOR i IN 1..wyposazenie.COUNT LOOP
                IF i > 1 THEN
                    v_sprzet := v_sprzet || ', ';
                END IF;
                v_sprzet := v_sprzet || wyposazenie(i);
            END LOOP;
        ELSE
            v_sprzet := 'brak';
        END IF;
        
        RETURN 'Sala ' || numer || ' (' || typ_sali || ', ' || 
               pojemnosc || ' os.) - ' || v_sprzet;
    END;
    
    -- Przeszukuje VARRAY w poszukiwaniu sprzętu (case-insensitive)
    MEMBER FUNCTION czy_ma_sprzet(p_nazwa VARCHAR2) RETURN CHAR IS
    BEGIN
        IF wyposazenie IS NULL OR wyposazenie.COUNT = 0 THEN
            RETURN 'N';
        END IF;
        
        FOR i IN 1..wyposazenie.COUNT LOOP
            -- UPPER dla porównania bez wielkości liter
            -- INSTR > 0 oznacza "zawiera" (nie musi być exact match)
            IF INSTR(UPPER(wyposazenie(i)), UPPER(p_nazwa)) > 0 THEN
                RETURN 'T';
            END IF;
        END LOOP;
        
        RETURN 'N';
    END;
    
    -- Czy sala pasuje do typu zajęć i liczby osób?
    MEMBER FUNCTION czy_odpowiednia(p_typ VARCHAR2, p_osob NUMBER) RETURN CHAR IS
    BEGIN
        -- Podstawowy warunek: pojemność
        IF p_osob > pojemnosc THEN
            RETURN 'N';
        END IF;
        
        -- Dopasowanie typu
        IF p_typ = 'indywidualna' AND typ_sali IN ('indywidualna', 'wielofunkcyjna') THEN
            RETURN 'T';
        ELSIF p_typ = 'grupowa' AND typ_sali IN ('grupowa', 'wielofunkcyjna') THEN
            RETURN 'T';
        ELSE
            RETURN 'N';
        END IF;
    END;
    
END;
/

PROMPT [6/12] Tworzenie t_nauczyciel_obj...

-- -----------------------------------------------------------------------------
-- TYP: t_nauczyciel_obj
-- -----------------------------------------------------------------------------
-- CEL: Reprezentuje nauczyciela szkoły muzycznej
--
-- ATRYBUTY OSOBOWE:
--   imie, nazwisko, email, telefon - dane kontaktowe
--   data_zatrudnienia - do obliczania stażu
--
-- ATRYBUTY KOMPETENCJI:
--   instrumenty          - VARRAY max 5 instrumentów
--   czy_prowadzi_grupowe - T/N (nie każdy może prowadzić grupy)
--   czy_akompaniator     - T/N (czy może akompaniować na lekcjach)
--
-- STATUS:
--   - aktywny   → prowadzi zajęcia
--   - urlop     → tymczasowo niedostępny
--   - zwolniony → historyczny (nie usuwamy, bo ma relacje)
--
-- DLACZEGO VARRAY INSTRUMENTÓW?
--   - Nauczyciel może uczyć kilku instrumentów
--   - Max 5 to realistyczny limit
--   - Łatwe sprawdzenie: czy_uczy('Fortepian')
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TYPE t_nauczyciel_obj AS OBJECT (
    id_nauczyciela        NUMBER,
    imie                  VARCHAR2(50),
    nazwisko              VARCHAR2(50),
    email                 VARCHAR2(100),
    telefon               VARCHAR2(20),
    data_zatrudnienia     DATE,
    instrumenty           t_lista_instrumentow,  -- VARRAY(5)
    czy_prowadzi_grupowe  CHAR(1),               -- T/N
    czy_akompaniator      CHAR(1),               -- T/N
    status                VARCHAR2(20),          -- aktywny/urlop/zwolniony
    
    -- "Jan Kowalski (jan.kowalski@szkola.pl)"
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2,
    
    -- Oblicza lata stażu (od data_zatrudnienia do dziś)
    MEMBER FUNCTION lata_stazu RETURN NUMBER,
    
    -- Ile instrumentów uczy (COUNT z VARRAY)
    MEMBER FUNCTION liczba_instrumentow RETURN NUMBER,
    
    -- Czy uczy konkretnego instrumentu? (przeszukuje VARRAY)
    MEMBER FUNCTION czy_uczy(p_instrument VARCHAR2) RETURN CHAR
    
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY t_nauczyciel_obj AS
    
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2 IS
    BEGIN
        RETURN imie || ' ' || nazwisko || ' (' || email || ')';
    END;
    
    -- MONTHS_BETWEEN / 12 = lata (z ułamkiem)
    -- TRUNC usuwa część dziesiętną
    MEMBER FUNCTION lata_stazu RETURN NUMBER IS
    BEGIN
        IF data_zatrudnienia IS NULL THEN
            RETURN 0;
        END IF;
        RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, data_zatrudnienia) / 12);
    END;
    
    -- Metoda bezpieczna na NULL (zwraca 0)
    MEMBER FUNCTION liczba_instrumentow RETURN NUMBER IS
    BEGIN
        IF instrumenty IS NULL THEN
            RETURN 0;
        END IF;
        RETURN instrumenty.COUNT;
    END;
    
    -- Przeszukuje VARRAY instrumentów (case-insensitive)
    MEMBER FUNCTION czy_uczy(p_instrument VARCHAR2) RETURN CHAR IS
    BEGIN
        IF instrumenty IS NULL OR instrumenty.COUNT = 0 THEN
            RETURN 'N';
        END IF;
        
        FOR i IN 1..instrumenty.COUNT LOOP
            IF UPPER(instrumenty(i)) = UPPER(p_instrument) THEN
                RETURN 'T';
            END IF;
        END LOOP;
        
        RETURN 'N';
    END;
    
END;
/

PROMPT [7/12] Tworzenie t_grupa_obj...

-- -----------------------------------------------------------------------------
-- TYP: t_grupa_obj
-- -----------------------------------------------------------------------------
-- CEL: Reprezentuje grupę uczniów (do zajęć grupowych)
--
-- CO TO GRUPA?
--   - Zbiór uczniów z tej samej klasy
--   - Chodzą razem na zajęcia grupowe (teoria, kształcenie słuchu)
--   - Nazwa: "1A", "1B", "2A" itd.
--
-- ATRYBUTY:
--   id_grupy    - klucz główny
--   nazwa       - "1A", "2B" itd.
--   klasa       - 1-6 (musi być zgodna z klasą uczniów!)
--   rok_szkolny - "2025/2026" (grupy są per rok)
--   max_uczniow - limit (zwykle 10-15)
--   status      - aktywna / zamknieta
--
-- UWAGA O RELACJI:
--   Uczeń ma REF do grupy (nie odwrotnie!)
--   To pozwala na: SELECT u.* FROM t_uczen u WHERE u.ref_grupa = REF(g)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TYPE t_grupa_obj AS OBJECT (
    id_grupy            NUMBER,
    nazwa               VARCHAR2(20),
    klasa               NUMBER(1),           -- 1-6
    rok_szkolny         VARCHAR2(9),         -- "2025/2026"
    max_uczniow         NUMBER,
    status              VARCHAR2(20),        -- aktywna/zamknieta
    
    -- "Grupa 1A (klasa I, 2025/2026)"
    MEMBER FUNCTION opis RETURN VARCHAR2,
    
    -- UWAGA: Ta metoda wymaga zapytania do tabeli!
    -- W typie NIE wykonujemy zapytań - to będzie w pakiecie
    -- Zostawiam jako placeholder
    MEMBER FUNCTION liczba_uczniow RETURN NUMBER
    
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY t_grupa_obj AS
    
    MEMBER FUNCTION opis RETURN VARCHAR2 IS
        v_klasa_rzymska VARCHAR2(5);
    BEGIN
        -- Konwersja na cyfry rzymskie (I-VI)
        v_klasa_rzymska := CASE klasa
            WHEN 1 THEN 'I'
            WHEN 2 THEN 'II'
            WHEN 3 THEN 'III'
            WHEN 4 THEN 'IV'
            WHEN 5 THEN 'V'
            WHEN 6 THEN 'VI'
            ELSE TO_CHAR(klasa)
        END;
        
        RETURN 'Grupa ' || nazwa || ' (klasa ' || v_klasa_rzymska || ', ' || rok_szkolny || ')';
    END;
    
    -- PLACEHOLDER - prawdziwa logika w pkg_uczen
    -- (nie możemy wykonać SELECT w ciele typu bez kontekstu tabeli)
    MEMBER FUNCTION liczba_uczniow RETURN NUMBER IS
    BEGIN
        -- To zawsze zwróci 0 - prawdziwa logika w pakiecie!
        RETURN 0;
    END;
    
END;
/

-- ============================================================================
-- SEKCJA 3: TYPY ZALEŻNE (z REF do innych typów)
-- ============================================================================
--
-- UWAGA O FORWARD DECLARATION:
-- Oracle wymaga, by typ referencjonowany ISTNIAŁ przed użyciem.
-- Ale t_uczen ma REF do t_grupa, a t_przedmiot ma REF do t_instrument.
-- To działa, bo t_grupa i t_instrument już istnieją (utworzone wyżej).
--
-- PROBLEM CYKLICZNYCH REFERENCJI:
-- Gdyby t_uczen miał REF do t_lekcja, a t_lekcja REF do t_uczen,
-- musielibyśmy użyć FORWARD DECLARATION:
--   CREATE TYPE t_lekcja_obj;  -- tylko nagłówek
--   CREATE TYPE t_uczen_obj AS OBJECT (..., ref_lekcja REF t_lekcja_obj);
--   CREATE TYPE BODY t_lekcja_obj...
--
-- W naszym przypadku NIE MA CYKLU - graf zależności jest acykliczny.
-- ============================================================================

PROMPT [8/12] Tworzenie t_uczen_obj...

-- -----------------------------------------------------------------------------
-- TYP: t_uczen_obj
-- -----------------------------------------------------------------------------
-- CEL: Reprezentuje ucznia szkoły muzycznej
--
-- ATRYBUTY OSOBOWE:
--   imie, nazwisko      - dane osobowe
--   data_urodzenia      - do obliczania wieku (walidacja: min 6 lat)
--   email               - może być NULL (dla dzieci)
--   telefon_rodzica     - kontakt do opiekuna
--
-- ATRYBUTY EDUKACYJNE:
--   data_zapisu         - kiedy rozpoczął naukę
--   klasa               - 1-6 (zgodna z cyklem)
--   cykl_nauczania      - zawsze 6 (w tym modelu)
--
-- 🔴 KLUCZOWY ATRYBUT: typ_ucznia
--   - 'uczacy_sie_w_innej_szkole' → lekcje TYLKO od 15:00
--   - 'ukonczyl_edukacje'         → lekcje od 14:00 (dorośli, studenci)
--   - 'tylko_muzyczna'            → lekcje od 14:00 (homeschooling)
--
-- REFERENCJE (REF):
--   ref_instrument - główny instrument ucznia (NOT NULL w tabeli)
--   ref_grupa      - grupa do zajęć grupowych (może być NULL)
--
-- DLACZEGO REF A NIE FK?
--   - REF to "wskaźnik" do obiektu - bardziej obiektowe
--   - Umożliwia DEREF() do pobrania obiektu
--   - Szybsze JOINy (nie wymaga indeksu)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TYPE t_uczen_obj AS OBJECT (
    id_ucznia           NUMBER,
    imie                VARCHAR2(50),
    nazwisko            VARCHAR2(50),
    data_urodzenia      DATE,
    email               VARCHAR2(100),         -- może być NULL (dzieci)
    telefon_rodzica     VARCHAR2(20),
    data_zapisu         DATE,
    klasa               NUMBER(1),             -- 1-6
    cykl_nauczania      NUMBER(1),             -- zawsze 6
    typ_ucznia          VARCHAR2(30),          -- 🔴 KLUCZOWE!
    status              VARCHAR2(20),          -- aktywny/zawieszony/skreslony
    
    -- REFERENCJE DO INNYCH TYPÓW
    ref_instrument      REF t_instrument_obj,  -- główny instrument
    ref_grupa           REF t_grupa_obj,       -- grupa (może być NULL)
    
    -- ===== METODY =====
    
    -- Oblicza wiek w latach
    MEMBER FUNCTION wiek RETURN NUMBER,
    
    -- "Jan Kowalski (klasa II)"
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2,
    
    -- Czy typ ucznia wymaga lekcji od 15:00?
    MEMBER FUNCTION czy_wymaga_popoludnia RETURN CHAR,
    
    -- Zwraca minimalną godzinę lekcji: '14:00' lub '15:00'
    MEMBER FUNCTION min_godzina_lekcji RETURN VARCHAR2,
    
    -- Który rok nauki? (data_zapisu do dziś)
    MEMBER FUNCTION rok_nauki RETURN NUMBER
    
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY t_uczen_obj AS
    
    -- Wiek = różnica miesięcy / 12, zaokrąglona w dół
    MEMBER FUNCTION wiek RETURN NUMBER IS
    BEGIN
        IF data_urodzenia IS NULL THEN
            RETURN NULL;
        END IF;
        RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, data_urodzenia) / 12);
    END;
    
    -- Format: "Jan Kowalski (klasa II)"
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2 IS
        v_klasa_rzymska VARCHAR2(5);
    BEGIN
        v_klasa_rzymska := CASE klasa
            WHEN 1 THEN 'I' WHEN 2 THEN 'II' WHEN 3 THEN 'III'
            WHEN 4 THEN 'IV' WHEN 5 THEN 'V' WHEN 6 THEN 'VI'
            ELSE TO_CHAR(klasa)
        END;
        RETURN imie || ' ' || nazwisko || ' (klasa ' || v_klasa_rzymska || ')';
    END;
    
    -- 🔴 KLUCZOWA LOGIKA BIZNESOWA
    -- Uczniowie uczący się w innej szkole mają ograniczenie godzinowe
    MEMBER FUNCTION czy_wymaga_popoludnia RETURN CHAR IS
    BEGIN
        IF typ_ucznia = 'uczacy_sie_w_innej_szkole' THEN
            RETURN 'T';
        ELSE
            RETURN 'N';
        END IF;
    END;
    
    -- Zwraca '15:00' dla uczniów z innej szkoły, '14:00' dla reszty
    MEMBER FUNCTION min_godzina_lekcji RETURN VARCHAR2 IS
    BEGIN
        IF typ_ucznia = 'uczacy_sie_w_innej_szkole' THEN
            RETURN '15:00';
        ELSE
            RETURN '14:00';
        END IF;
    END;
    
    -- Rok nauki = ile pełnych lat od zapisu
    MEMBER FUNCTION rok_nauki RETURN NUMBER IS
    BEGIN
        IF data_zapisu IS NULL THEN
            RETURN 1;
        END IF;
        RETURN GREATEST(1, TRUNC(MONTHS_BETWEEN(SYSDATE, data_zapisu) / 12) + 1);
    END;
    
END;
/

PROMPT [9/12] Tworzenie t_przedmiot_obj...

-- -----------------------------------------------------------------------------
-- TYP: t_przedmiot_obj
-- -----------------------------------------------------------------------------
-- CEL: Reprezentuje przedmiot nauczania
--
-- RODZAJE PRZEDMIOTÓW:
--   1. Instrumentalne (indywidualne):
--      - "Instrument główny" - obowiązkowy, 30-60 min
--      - "Fortepian dodatkowy" - dla nie-pianistów, kl. III-VI
--   
--   2. Teoretyczne (grupowe):
--      - "Kształcenie słuchu" - obowiązkowy, wszystkie klasy
--      - "Rytmika" - kl. I-II
--      - "Audycje muzyczne" - kl. III-VI
--      - "Zespół kameralny" - nieobowiązkowy
--
-- ATRYBUTY:
--   typ_zajec        - indywidualny / grupowy
--   wymiar_minut     - 30/45/60/90
--   klasy_od, klasy_do - zakres klas (np. 3-6 dla fortepianu dodatkowego)
--   czy_obowiazkowy  - T/N
--   wymagany_sprzet  - np. 'Fortepian' (do szukania sali)
--   ref_instrument   - dla przedmiotów instrumentalnych (NULL dla teorii)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TYPE t_przedmiot_obj AS OBJECT (
    id_przedmiotu       NUMBER,
    nazwa               VARCHAR2(100),
    typ_zajec           VARCHAR2(20),        -- indywidualny/grupowy
    wymiar_minut        NUMBER,              -- 30/45/60/90
    klasy_od            NUMBER(1),           -- od której klasy
    klasy_do            NUMBER(1),           -- do której klasy
    czy_obowiazkowy     CHAR(1),             -- T/N
    wymagany_sprzet     VARCHAR2(100),       -- np. 'Fortepian', NULL
    ref_instrument      REF t_instrument_obj, -- NULL dla teoretycznych
    
    -- "Kształcenie słuchu (grupowy, 45 min, kl. I-VI)"
    MEMBER FUNCTION opis RETURN VARCHAR2,
    
    -- Czy przedmiot jest dla danej klasy?
    MEMBER FUNCTION czy_dla_klasy(p_klasa NUMBER) RETURN CHAR
    
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY t_przedmiot_obj AS
    
    MEMBER FUNCTION opis RETURN VARCHAR2 IS
        v_klasy VARCHAR2(20);
    BEGIN
        -- Format klas: "I-VI" lub "III-VI"
        v_klasy := CASE klasy_od
            WHEN 1 THEN 'I' WHEN 2 THEN 'II' WHEN 3 THEN 'III'
            WHEN 4 THEN 'IV' WHEN 5 THEN 'V' WHEN 6 THEN 'VI'
        END || '-' || CASE klasy_do
            WHEN 1 THEN 'I' WHEN 2 THEN 'II' WHEN 3 THEN 'III'
            WHEN 4 THEN 'IV' WHEN 5 THEN 'V' WHEN 6 THEN 'VI'
        END;
        
        RETURN nazwa || ' (' || typ_zajec || ', ' || 
               wymiar_minut || ' min, kl. ' || v_klasy || ')';
    END;
    
    -- Sprawdza czy klasa mieści się w przedziale [klasy_od, klasy_do]
    MEMBER FUNCTION czy_dla_klasy(p_klasa NUMBER) RETURN CHAR IS
    BEGIN
        IF p_klasa BETWEEN klasy_od AND klasy_do THEN
            RETURN 'T';
        ELSE
            RETURN 'N';
        END IF;
    END;
    
END;
/

-- ============================================================================
-- SEKCJA 4: TYPY TRANSAKCYJNE (z wieloma REF)
-- ============================================================================
--
-- Te typy reprezentują "zdarzenia" w systemie: lekcje, egzaminy, oceny.
-- Mają WIELE referencji do innych typów.
--
-- ============================================================================

PROMPT [10/12] Tworzenie t_lekcja_obj...

-- -----------------------------------------------------------------------------
-- TYP: t_lekcja_obj
-- -----------------------------------------------------------------------------
-- CEL: Reprezentuje pojedynczą lekcję (najważniejsza encja transakcyjna!)
--
-- 🔴 TO JEST NAJBARDZIEJ ZŁOŻONY TYP - MA 6 REFERENCJI!
--
-- REFERENCJE:
--   ref_przedmiot    - co jest nauczane (NOT NULL)
--   ref_nauczyciel   - kto prowadzi (NOT NULL)
--   ref_akompaniator - kto akompaniuje (NULL jeśli nie potrzeba)
--   ref_sala         - gdzie (NOT NULL)
--   ref_uczen        - kto uczy się (NULL dla grupowych)
--   ref_grupa        - która grupa (NULL dla indywidualnych)
--
-- WAŻNE REGUŁY:
--   - ref_uczen XOR ref_grupa (dokładnie jedno NOT NULL)
--   - ref_akompaniator tylko jeśli instrument wymaga
--   - godzina_start format 'HH:MI' (np. '14:30')
--   - status: zaplanowana → odbyta / odwolana
--
-- GODZINY:
--   - Przechowywane jako VARCHAR2(5) w formacie 'HH:MI'
--   - Dlaczego nie DATE? Bo lekcja ma osobno datę i godzinę
--   - Łatwiejsze porównania stringowe: '14:30' < '15:00'
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TYPE t_lekcja_obj AS OBJECT (
    id_lekcji           NUMBER,
    data_lekcji         DATE,                -- tylko data (bez czasu)
    godzina_start       VARCHAR2(5),         -- 'HH:MI' np. '14:30'
    czas_trwania        NUMBER,              -- minuty: 30/45/60
    typ_lekcji          VARCHAR2(20),        -- indywidualna/grupowa
    status              VARCHAR2(20),        -- zaplanowana/odbyta/odwolana
    
    -- 6 REFERENCJI (rekord w projekcie!)
    ref_przedmiot       REF t_przedmiot_obj,
    ref_nauczyciel      REF t_nauczyciel_obj,
    ref_akompaniator    REF t_nauczyciel_obj,  -- może być NULL
    ref_sala            REF t_sala_obj,
    ref_uczen           REF t_uczen_obj,       -- NULL dla grupowych
    ref_grupa           REF t_grupa_obj,       -- NULL dla indywidualnych
    
    -- Oblicza godzinę zakończenia: '14:30' + 45 min = '15:15'
    MEMBER FUNCTION godzina_koniec RETURN VARCHAR2,
    
    -- "45 min" - formatowany czas
    MEMBER FUNCTION czas_txt RETURN VARCHAR2,
    
    -- T/N - czy lekcja grupowa
    MEMBER FUNCTION czy_grupowa RETURN CHAR,
    
    -- "Poniedziałek" / "Wtorek" / ... (nazwa dnia)
    MEMBER FUNCTION dzien_tygodnia RETURN VARCHAR2
    
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY t_lekcja_obj AS
    
    -- Oblicza godzinę zakończenia (arytmetyka na VARCHAR2)
    -- '14:30' + 45 min = '15:15'
    MEMBER FUNCTION godzina_koniec RETURN VARCHAR2 IS
        v_godz NUMBER;
        v_min  NUMBER;
        v_suma NUMBER;
    BEGIN
        -- Parsowanie 'HH:MI'
        v_godz := TO_NUMBER(SUBSTR(godzina_start, 1, 2));
        v_min := TO_NUMBER(SUBSTR(godzina_start, 4, 2));
        
        -- Dodaj czas trwania
        v_suma := v_godz * 60 + v_min + czas_trwania;
        
        -- Konwersja z powrotem na 'HH:MI'
        v_godz := TRUNC(v_suma / 60);
        v_min := MOD(v_suma, 60);
        
        RETURN TO_CHAR(v_godz, 'FM00') || ':' || TO_CHAR(v_min, 'FM00');
    END;
    
    -- "45 min" lub "1h 30min"
    MEMBER FUNCTION czas_txt RETURN VARCHAR2 IS
    BEGIN
        IF czas_trwania < 60 THEN
            RETURN czas_trwania || ' min';
        ELSIF MOD(czas_trwania, 60) = 0 THEN
            RETURN (czas_trwania / 60) || 'h';
        ELSE
            RETURN TRUNC(czas_trwania / 60) || 'h ' || MOD(czas_trwania, 60) || 'min';
        END IF;
    END;
    
    MEMBER FUNCTION czy_grupowa RETURN CHAR IS
    BEGIN
        IF typ_lekcji = 'grupowa' THEN
            RETURN 'T';
        ELSE
            RETURN 'N';
        END IF;
    END;
    
    -- Używa funkcji TO_CHAR z formatem 'DAY' (po polsku przez NLS)
    MEMBER FUNCTION dzien_tygodnia RETURN VARCHAR2 IS
    BEGIN
        -- TO_CHAR z 'DAY' zwraca nazwę dnia (zależy od NLS_DATE_LANGUAGE)
        -- TRIM usuwa trailing spaces (Oracle dodaje do 9 znaków)
        RETURN TRIM(TO_CHAR(data_lekcji, 'DAY', 'NLS_DATE_LANGUAGE=POLISH'));
    END;
    
END;
/

PROMPT [11/12] Tworzenie t_egzamin_obj...

-- -----------------------------------------------------------------------------
-- TYP: t_egzamin_obj
-- -----------------------------------------------------------------------------
-- CEL: Reprezentuje egzamin (wstępny, semestralny, poprawkowy)
--
-- TYPY EGZAMINÓW:
--   - wstepny     → przy zapisie do szkoły
--   - semestralny → na koniec semestru (obowiązkowy)
--   - poprawkowy  → dla tych, którzy nie zdali
--
-- KOMISJA:
--   - Minimum 2 nauczycieli (ref_komisja1, ref_komisja2)
--   - Muszą być RÓŻNE (walidacja w triggerze/pakiecie)
--   - Zwykle: nauczyciel instrumentu + dyrektor artystyczny
--
-- OCENA:
--   - NULL przed egzaminem
--   - 1-6 po egzaminie (wystawia procedura)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TYPE t_egzamin_obj AS OBJECT (
    id_egzaminu         NUMBER,
    data_egzaminu       DATE,
    godzina             VARCHAR2(5),         -- 'HH:MI'
    typ_egzaminu        VARCHAR2(30),        -- wstepny/semestralny/poprawkowy
    
    -- 5 REFERENCJI
    ref_uczen           REF t_uczen_obj,
    ref_przedmiot       REF t_przedmiot_obj,
    ref_komisja1        REF t_nauczyciel_obj,  -- pierwszy członek komisji
    ref_komisja2        REF t_nauczyciel_obj,  -- drugi członek komisji
    ref_sala            REF t_sala_obj,
    
    ocena_koncowa       NUMBER(1),           -- 1-6 lub NULL
    uwagi               VARCHAR2(500),       -- komentarz komisji
    
    -- Czy ocena >= 2 (zaliczył)?
    MEMBER FUNCTION czy_zdany RETURN CHAR,
    
    -- "celujący" / "bardzo dobry" / ... / "niedostateczny"
    MEMBER FUNCTION ocena_slownie RETURN VARCHAR2
    
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY t_egzamin_obj AS
    
    -- Zdany = ocena >= 2
    MEMBER FUNCTION czy_zdany RETURN CHAR IS
    BEGIN
        IF ocena_koncowa IS NULL THEN
            RETURN NULL;  -- jeszcze nie oceniony
        ELSIF ocena_koncowa >= 2 THEN
            RETURN 'T';
        ELSE
            RETURN 'N';
        END IF;
    END;
    
    -- Skala polska: 6=celujący, 5=bardzo dobry, ... 1=niedostateczny
    MEMBER FUNCTION ocena_slownie RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE ocena_koncowa
            WHEN 6 THEN 'celujący'
            WHEN 5 THEN 'bardzo dobry'
            WHEN 4 THEN 'dobry'
            WHEN 3 THEN 'dostateczny'
            WHEN 2 THEN 'dopuszczający'
            WHEN 1 THEN 'niedostateczny'
            ELSE 'brak oceny'
        END;
    END;
    
END;
/

PROMPT [12/12] Tworzenie t_ocena_obj...

-- -----------------------------------------------------------------------------
-- TYP: t_ocena_obj
-- -----------------------------------------------------------------------------
-- CEL: Reprezentuje ocenę bieżącą (cząstkową)
--
-- RÓŻNICA OCENA vs EGZAMIN:
--   - Ocena → bieżąca, z lekcji, wiele per uczeń/przedmiot
--   - Egzamin → końcowa, 1 per semestr/przedmiot
--
-- OBSZARY OCENIANIA:
--   - technika      → poprawność gry, palcowanie
--   - interpretacja → muzyczność, dynamika, frazowanie
--   - sluch         → rozpoznawanie interwałów, dyktando
--   - teoria        → znajomość zasad, analiza
--   - rytm          → poczucie metrum, precyzja
--   - ogolna        → ocena całościowa
--
-- ref_lekcja:
--   - Opcjonalne powiązanie z konkretną lekcją
--   - NULL jeśli ocena nie z lekcji (np. test pisemny)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TYPE t_ocena_obj AS OBJECT (
    id_oceny            NUMBER,
    data_oceny          DATE,
    wartosc             NUMBER(1),           -- 1-6
    obszar              VARCHAR2(50),        -- technika/interpretacja/sluch/teoria/rytm/ogolna
    komentarz           VARCHAR2(500),       -- opcjonalny opis
    
    -- 4 REFERENCJE
    ref_uczen           REF t_uczen_obj,
    ref_nauczyciel      REF t_nauczyciel_obj,
    ref_przedmiot       REF t_przedmiot_obj,
    ref_lekcja          REF t_lekcja_obj,    -- może być NULL
    
    -- "celujący" / "bardzo dobry" / ...
    MEMBER FUNCTION ocena_slownie RETURN VARCHAR2,
    
    -- Czy ocena >= 2?
    MEMBER FUNCTION czy_pozytywna RETURN CHAR
    
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY t_ocena_obj AS
    
    -- Identyczna logika jak w t_egzamin_obj
    MEMBER FUNCTION ocena_slownie RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE wartosc
            WHEN 6 THEN 'celujący'
            WHEN 5 THEN 'bardzo dobry'
            WHEN 4 THEN 'dobry'
            WHEN 3 THEN 'dostateczny'
            WHEN 2 THEN 'dopuszczający'
            WHEN 1 THEN 'niedostateczny'
            ELSE 'błąd'
        END;
    END;
    
    MEMBER FUNCTION czy_pozytywna RETURN CHAR IS
    BEGIN
        IF wartosc >= 2 THEN
            RETURN 'T';
        ELSE
            RETURN 'N';
        END IF;
    END;
    
END;
/

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================

PROMPT
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT   PODSUMOWANIE - Utworzone typy obiektowe
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT
PROMPT   KOLEKCJE (VARRAY):
PROMPT     [✓] t_lista_instrumentow  - VARRAY(5) dla nauczycieli
PROMPT     [✓] t_lista_sprzetu       - VARRAY(10) dla sal
PROMPT
PROMPT   TYPY BAZOWE (bez REF):
PROMPT     [✓] t_semestr_obj         - 3 metody
PROMPT     [✓] t_instrument_obj      - 2 metody
PROMPT     [✓] t_sala_obj            - 3 metody
PROMPT     [✓] t_nauczyciel_obj      - 4 metody
PROMPT     [✓] t_grupa_obj           - 2 metody
PROMPT
PROMPT   TYPY ZALEŻNE (z REF):
PROMPT     [✓] t_uczen_obj           - 5 metod, 2 REF
PROMPT     [✓] t_przedmiot_obj       - 2 metody, 1 REF
PROMPT
PROMPT   TYPY TRANSAKCYJNE (wiele REF):
PROMPT     [✓] t_lekcja_obj          - 4 metody, 6 REF (!)
PROMPT     [✓] t_egzamin_obj         - 2 metody, 5 REF
PROMPT     [✓] t_ocena_obj           - 2 metody, 4 REF
PROMPT
PROMPT   RAZEM: 12 typów, 29 metod, 18 REF, 2 VARRAY
PROMPT
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT   Następny krok: Uruchom 02_tabele.sql
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT

-- Sprawdzenie czy wszystkie typy zostały utworzone
SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('TYPE', 'TYPE BODY')
ORDER BY object_type, object_name;
