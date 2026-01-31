-- ============================================================================
-- PLIK: 02_tabele.sql
-- PROJEKT: Szkoła Muzyczna v5 - Obiektowa Baza Danych Oracle
-- AUTORZY: Igor Typiński (251237), Mateusz Mróz (251190)
-- DATA: Styczeń 2026
-- ============================================================================
-- 
-- CO TEN PLIK ROBI?
-- -----------------
-- Tworzy 10 TABEL OBIEKTOWYCH (Object Tables) na podstawie typów z 01_typy.sql
-- oraz SEKWENCJE do generowania kluczy głównych.
--
-- RÓŻNICA: TABELA OBIEKTOWA vs ZWYKŁA TABELA
-- ------------------------------------------
-- ZWYKŁA TABELA:
--   CREATE TABLE emp (id NUMBER, name VARCHAR2(100));
--   INSERT INTO emp VALUES (1, 'Jan');
--
-- TABELA OBIEKTOWA:
--   CREATE TABLE t_emp OF t_emp_obj (...);
--   INSERT INTO t_emp VALUES (t_emp_obj(1, 'Jan'));
--
-- ZALETY TABEL OBIEKTOWYCH:
--   1. Wiersze to OBIEKTY - mają metody!
--   2. Można używać REF (wskaźniki do obiektów)
--   3. Można używać DEREF do "podążania" za wskaźnikiem
--   4. Dziedziczenie typów (na przyszłość)
--
-- RELACJE REF vs FOREIGN KEY
-- --------------------------
-- FOREIGN KEY (klasyczny):
--   uczen_id NUMBER REFERENCES uczniowie(id)
--   → przechowuje WARTOŚĆ (liczbę)
--   → wymaga JOIN do pobrania danych
--
-- REF (obiektowy):
--   ref_uczen REF t_uczen_obj SCOPE IS t_uczen
--   → przechowuje WSKAŹNIK (adres obiektu)
--   → DEREF(ref_uczen) zwraca cały obiekt!
--
-- SCOPE IS - CO TO?
-- -----------------
-- REF może wskazywać na obiekt w DOWOLNEJ tabeli tego typu.
-- SCOPE IS ogranicza do KONKRETNEJ tabeli:
--   ref_uczen REF t_uczen_obj SCOPE IS t_uczen
-- Bez SCOPE IS Oracle nie wie, w której tabeli szukać!
--
-- KOLEJNOŚĆ TWORZENIA (KRYTYCZNA!)
-- --------------------------------
-- Tabele muszą być tworzone w kolejności zależności REF:
--   1. t_semestr      - brak REF
--   2. t_instrument   - brak REF
--   3. t_sala         - brak REF (ma VARRAY)
--   4. t_nauczyciel   - brak REF (ma VARRAY)
--   5. t_grupa        - brak REF
--   6. t_uczen        - REF → instrument, grupa
--   7. t_przedmiot    - REF → instrument
--   8. t_lekcja       - REF → przedmiot, nauczyciel, sala, uczen, grupa
--   9. t_egzamin      - REF → uczen, przedmiot, nauczyciel x2, sala
--  10. t_ocena        - REF → uczen, nauczyciel, przedmiot, lekcja
--
-- JAK URUCHOMIĆ?
-- --------------
-- WYMAGANIE: Najpierw uruchom 01_typy.sql !
-- Jako użytkownik SZKOLA_MUZYCZNA:
--   @02_tabele.sql
--
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200

PROMPT ╔═══════════════════════════════════════════════════════════════╗
PROMPT ║  02_tabele.sql - Tworzenie tabel i sekwencji                  ║
PROMPT ╚═══════════════════════════════════════════════════════════════╝
PROMPT

-- ============================================================================
-- SEKCJA 0: CZYSZCZENIE (opcjonalne)
-- ============================================================================
-- Usuń komentarz poniżej, jeśli chcesz usunąć istniejące tabele przed utworzeniem
-- UWAGA: Kolejność DROP jest ODWROTNA do kolejności CREATE (zależności!)
-- ============================================================================

/*
PROMPT [!] Usuwanie istniejących tabel (jeśli istnieją)...

DROP TABLE t_ocena CASCADE CONSTRAINTS;
DROP TABLE t_egzamin CASCADE CONSTRAINTS;
DROP TABLE t_lekcja CASCADE CONSTRAINTS;
DROP TABLE t_przedmiot CASCADE CONSTRAINTS;
DROP TABLE t_uczen CASCADE CONSTRAINTS;
DROP TABLE t_grupa CASCADE CONSTRAINTS;
DROP TABLE t_nauczyciel CASCADE CONSTRAINTS;
DROP TABLE t_sala CASCADE CONSTRAINTS;
DROP TABLE t_instrument CASCADE CONSTRAINTS;
DROP TABLE t_semestr CASCADE CONSTRAINTS;

DROP SEQUENCE seq_semestr;
DROP SEQUENCE seq_instrument;
DROP SEQUENCE seq_sala;
DROP SEQUENCE seq_nauczyciel;
DROP SEQUENCE seq_grupa;
DROP SEQUENCE seq_uczen;
DROP SEQUENCE seq_przedmiot;
DROP SEQUENCE seq_lekcja;
DROP SEQUENCE seq_egzamin;
DROP SEQUENCE seq_ocena;

PROMPT [!] Czyszczenie zakończone.
*/

-- ============================================================================
-- SEKCJA 1: SEKWENCJE
-- ============================================================================
--
-- CO TO SEKWENCJA?
-- ----------------
-- Generator unikalnych liczb. Każde wywołanie seq_xxx.NEXTVAL zwraca
-- kolejną liczbę (1, 2, 3, ...). Idealne do kluczy głównych.
--
-- DLACZEGO NIE IDENTITY?
-- ----------------------
-- Oracle 12c+ ma IDENTITY (jak MySQL AUTO_INCREMENT), ale:
--   - Sekwencje są bardziej elastyczne
--   - Można użyć NEXTVAL w triggerze
--   - Łatwiejsze debugowanie (widać wartość)
--
-- START WITH 1 - zaczynamy od 1
-- INCREMENT BY 1 - zwiększamy o 1
-- NOCACHE - bez buforowania (prostsze, wystarczy do demo)
--
-- ============================================================================

PROMPT [SEKWENCJE] Tworzenie sekwencji dla kluczy głównych...

-- Sekwencja dla t_semestr
CREATE SEQUENCE seq_semestr
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Sekwencja dla t_instrument
CREATE SEQUENCE seq_instrument
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Sekwencja dla t_sala
CREATE SEQUENCE seq_sala
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Sekwencja dla t_nauczyciel
CREATE SEQUENCE seq_nauczyciel
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Sekwencja dla t_grupa
CREATE SEQUENCE seq_grupa
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Sekwencja dla t_uczen
CREATE SEQUENCE seq_uczen
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Sekwencja dla t_przedmiot
CREATE SEQUENCE seq_przedmiot
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Sekwencja dla t_lekcja
CREATE SEQUENCE seq_lekcja
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Sekwencja dla t_egzamin
CREATE SEQUENCE seq_egzamin
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Sekwencja dla t_ocena
CREATE SEQUENCE seq_ocena
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

PROMPT [OK] Utworzono 10 sekwencji.
PROMPT

-- ============================================================================
-- SEKCJA 2: TABELE SŁOWNIKOWE (brak REF)
-- ============================================================================
--
-- "Słownikowe" = dane rzadko się zmieniają, są referencjonowane przez inne.
-- Analogia: t_semestr i t_instrument to jak "lookup tables".
--
-- ============================================================================

PROMPT [1/10] Tworzenie t_semestr...

-- -----------------------------------------------------------------------------
-- TABELA: t_semestr
-- -----------------------------------------------------------------------------
-- TYP BAZOWY: t_semestr_obj (z 01_typy.sql)
--
-- SKŁADNIA TWORZENIA TABELI OBIEKTOWEJ:
--   CREATE TABLE nazwa OF typ_obiektowy (
--       atrybut1 [constraint],
--       atrybut2 [constraint],
--       ...
--   );
--
-- PRIMARY KEY:
--   W tabeli obiektowej PK definiujemy w nawiasie, nie ALTER TABLE.
--   Oracle tworzy indeks automatycznie.
--
-- UNIQUE:
--   nazwa musi być unikalna (nie może być 2x "2025/2026 Semestr zimowy")
--
-- CHECK:
--   data_koniec > data_start - semestr nie może kończyć się przed startem!
-- -----------------------------------------------------------------------------
CREATE TABLE t_semestr OF t_semestr_obj (
    -- Klucz główny
    id_semestru     PRIMARY KEY,
    
    -- NOT NULL constraints
    nazwa           NOT NULL,
    data_start      NOT NULL,
    data_koniec     NOT NULL,
    rok_szkolny     NOT NULL,
    
    -- Unikalność nazwy semestru
    CONSTRAINT uk_semestr_nazwa UNIQUE (nazwa),
    
    -- Walidacja dat: koniec musi być PO starcie
    CONSTRAINT chk_semestr_daty CHECK (data_koniec > data_start),
    
    -- Format roku szkolnego: RRRR/RRRR (np. 2025/2026)
    CONSTRAINT chk_semestr_rok CHECK (REGEXP_LIKE(rok_szkolny, '^\d{4}/\d{4}$'))
);

-- Komentarze (metadata) - widoczne w słowniku danych
COMMENT ON TABLE t_semestr IS 'Słownik semestrów akademickich';
COMMENT ON COLUMN t_semestr.id_semestru IS 'Klucz główny - generowany przez seq_semestr';
COMMENT ON COLUMN t_semestr.nazwa IS 'Pełna nazwa semestru np. "2025/2026 Semestr zimowy"';
COMMENT ON COLUMN t_semestr.rok_szkolny IS 'Rok szkolny w formacie RRRR/RRRR';

PROMPT [2/10] Tworzenie t_instrument...

-- -----------------------------------------------------------------------------
-- TABELA: t_instrument
-- -----------------------------------------------------------------------------
-- Słownik instrumentów muzycznych.
--
-- KATEGORIE (CHECK):
--   - klawiszowe: fortepian, organy, klawesyn, akordeon
--   - strunowe: gitara, skrzypce, wiolonczela, harfa, kontrabas
--   - dete: flet, klarnet, obój, fagot, saksofon, trąbka, puzon, róg
--   - perkusyjne: perkusja, wibrafon, ksylofon, kotły
--
-- CZY_WYMAGA_AKOMPANIATORA:
--   T = smyczki (skrzypce, altówka, wiolonczela, kontrabas), dęte
--   N = fortepian, gitara, perkusja
-- -----------------------------------------------------------------------------
CREATE TABLE t_instrument OF t_instrument_obj (
    id_instrumentu              PRIMARY KEY,
    nazwa                       NOT NULL,
    kategoria                   NOT NULL,
    czy_wymaga_akompaniatora    NOT NULL,
    
    -- Unikalna nazwa instrumentu
    CONSTRAINT uk_instrument_nazwa UNIQUE (nazwa),
    
    -- Dozwolone kategorie
    CONSTRAINT chk_instrument_kat CHECK (
        kategoria IN ('klawiszowe', 'strunowe', 'dete', 'perkusyjne')
    ),
    
    -- T lub N
    CONSTRAINT chk_instrument_akomp CHECK (
        czy_wymaga_akompaniatora IN ('T', 'N')
    )
);

COMMENT ON TABLE t_instrument IS 'Słownik instrumentów muzycznych';
COMMENT ON COLUMN t_instrument.kategoria IS 'Kategoria: klawiszowe/strunowe/dete/perkusyjne';
COMMENT ON COLUMN t_instrument.czy_wymaga_akompaniatora IS 'T=wymaga akompaniamentu, N=nie wymaga';

-- ============================================================================
-- SEKCJA 3: TABELE ZASOBÓW (bez REF wychodzących)
-- ============================================================================
--
-- Zasoby = sale, nauczyciele. Są "używane" przez lekcje/egzaminy.
--
-- ============================================================================

PROMPT [3/10] Tworzenie t_sala...

-- -----------------------------------------------------------------------------
-- TABELA: t_sala
-- -----------------------------------------------------------------------------
-- VARRAY W TABELI:
--   wyposazenie t_lista_sprzetu - Oracle przechowuje VARRAY inline (w tym samym
--   segmencie co tabela). Nie wymaga osobnego storage jak NESTED TABLE.
--
-- TYPY SAL:
--   - indywidualna: małe pokoje do lekcji 1:1 (pojemność 1-3)
--   - grupowa: duże sale do teorii, chóru (pojemność 10-30)
--   - wielofunkcyjna: średnie, uniwersalne (pojemność 5-15)
--
-- STATUS:
--   - dostepna: można planować lekcje
--   - niedostepna: tymczasowo wyłączona
--   - remont: dłuższe wyłączenie
-- -----------------------------------------------------------------------------
CREATE TABLE t_sala OF t_sala_obj (
    id_sali         PRIMARY KEY,
    numer           NOT NULL,
    typ_sali        NOT NULL,
    pojemnosc       NOT NULL,
    -- wyposazenie może być NULL (sala bez sprzętu) lub VARRAY
    status          NOT NULL,
    
    -- Unikalny numer sali
    CONSTRAINT uk_sala_numer UNIQUE (numer),
    
    -- Dozwolone typy sal
    CONSTRAINT chk_sala_typ CHECK (
        typ_sali IN ('indywidualna', 'grupowa', 'wielofunkcyjna')
    ),
    
    -- Pojemność 1-30 osób (realistyczny zakres)
    CONSTRAINT chk_sala_pojemnosc CHECK (
        pojemnosc BETWEEN 1 AND 30
    ),
    
    -- Dozwolone statusy
    CONSTRAINT chk_sala_status CHECK (
        status IN ('dostepna', 'niedostepna', 'remont')
    )
);

COMMENT ON TABLE t_sala IS 'Sale lekcyjne i wykładowe';
COMMENT ON COLUMN t_sala.wyposazenie IS 'VARRAY(10) - lista sprzętu np. (''Fortepian'', ''Tablica'')';

PROMPT [4/10] Tworzenie t_nauczyciel...

-- -----------------------------------------------------------------------------
-- TABELA: t_nauczyciel
-- -----------------------------------------------------------------------------
-- VARRAY INSTRUMENTÓW:
--   instrumenty t_lista_instrumentow - max 5 instrumentów
--   Przechowywane inline w tabeli.
--
-- EMAIL:
--   Format sprawdzany przez CHECK (podstawowy: zawiera @)
--   W prawdziwym systemie użyłbym REGEXP dla pełnej walidacji.
--
-- CZY_PROWADZI_GRUPOWE:
--   Nie każdy nauczyciel może/chce prowadzić zajęcia grupowe (teoria, słuch).
--   Wymaga innych kompetencji niż nauka instrumentu.
--
-- CZY_AKOMPANIATOR:
--   Niektórzy pianiści specjalizują się w akompaniamencie.
--   Potrzebni na lekcjach smyczków i dętych.
-- -----------------------------------------------------------------------------
CREATE TABLE t_nauczyciel OF t_nauczyciel_obj (
    id_nauczyciela          PRIMARY KEY,
    imie                    NOT NULL,
    nazwisko                NOT NULL,
    email                   NOT NULL,
    -- telefon może być NULL
    data_zatrudnienia       NOT NULL,
    -- instrumenty (VARRAY) - walidacja w triggerze (NOT EMPTY)
    czy_prowadzi_grupowe    NOT NULL,
    czy_akompaniator        NOT NULL,
    status                  NOT NULL,
    
    -- Unikalny email
    CONSTRAINT uk_nauczyciel_email UNIQUE (email),
    
    -- Podstawowa walidacja email (zawiera @)
    CONSTRAINT chk_nauczyciel_email CHECK (email LIKE '%@%'),
    
    -- T/N dla flag
    CONSTRAINT chk_nauczyciel_grupowe CHECK (czy_prowadzi_grupowe IN ('T', 'N')),
    CONSTRAINT chk_nauczyciel_akomp CHECK (czy_akompaniator IN ('T', 'N')),
    
    -- Dozwolone statusy
    CONSTRAINT chk_nauczyciel_status CHECK (
        status IN ('aktywny', 'urlop', 'zwolniony')
    )
);

COMMENT ON TABLE t_nauczyciel IS 'Nauczyciele szkoły muzycznej';
COMMENT ON COLUMN t_nauczyciel.instrumenty IS 'VARRAY(5) - lista instrumentów które uczy';
COMMENT ON COLUMN t_nauczyciel.czy_prowadzi_grupowe IS 'T=może prowadzić teorię/słuch, N=tylko instrument';
COMMENT ON COLUMN t_nauczyciel.czy_akompaniator IS 'T=może akompaniować na lekcjach, N=nie';

PROMPT [5/10] Tworzenie t_grupa...

-- -----------------------------------------------------------------------------
-- TABELA: t_grupa
-- -----------------------------------------------------------------------------
-- Grupa = zbiór uczniów z tej samej klasy chodzących razem na zajęcia grupowe.
--
-- NAZWA:
--   Format "1A", "1B", "2A" itd.
--   Unikalna w ramach roku szkolnego (może być 2x "1A" w różnych latach).
--
-- KLASA:
--   1-6 (cykl 6-letni)
--   Wszyscy uczniowie w grupie muszą być z tej samej klasy!
--   (walidacja w triggerze/pakiecie)
--
-- MAX_UCZNIOW:
--   Typowo 10-15. Ogranicza ile osób można przypisać.
-- -----------------------------------------------------------------------------
CREATE TABLE t_grupa OF t_grupa_obj (
    id_grupy        PRIMARY KEY,
    nazwa           NOT NULL,
    klasa           NOT NULL,
    rok_szkolny     NOT NULL,
    max_uczniow     NOT NULL,
    status          NOT NULL,
    
    -- Unikalna kombinacja: nazwa + rok_szkolny
    -- (może być "1A" w 2024/2025 i w 2025/2026)
    CONSTRAINT uk_grupa_nazwa_rok UNIQUE (nazwa, rok_szkolny),
    
    -- Klasa 1-6
    CONSTRAINT chk_grupa_klasa CHECK (klasa BETWEEN 1 AND 6),
    
    -- Rozsądny limit uczniów
    CONSTRAINT chk_grupa_max CHECK (max_uczniow BETWEEN 1 AND 20),
    
    -- Format roku szkolnego
    CONSTRAINT chk_grupa_rok CHECK (REGEXP_LIKE(rok_szkolny, '^\d{4}/\d{4}$')),
    
    -- Statusy
    CONSTRAINT chk_grupa_status CHECK (status IN ('aktywna', 'zamknieta'))
);

COMMENT ON TABLE t_grupa IS 'Grupy uczniów do zajęć grupowych (teoria, słuch)';
COMMENT ON COLUMN t_grupa.nazwa IS 'Nazwa grupy np. "1A", "2B"';
COMMENT ON COLUMN t_grupa.klasa IS 'Klasa 1-6, musi być zgodna z klasą uczniów w grupie';

-- ============================================================================
-- SEKCJA 4: TABELE Z REFERENCJAMI (REF)
-- ============================================================================
--
-- Od tego miejsca tabele mają REF do innych tabel.
-- Składnia: ref_xxx REF typ_obj SCOPE IS tabela [NOT NULL]
--
-- UWAGA O SCOPE IS:
--   SCOPE IS t_instrument oznacza "ten REF wskazuje TYLKO na obiekty w t_instrument"
--   Bez SCOPE IS Oracle nie wie gdzie szukać obiektu po OID!
--
-- ============================================================================

PROMPT [6/10] Tworzenie t_uczen...

-- -----------------------------------------------------------------------------
-- TABELA: t_uczen
-- -----------------------------------------------------------------------------
-- 🔴 KLUCZOWA TABELA - zawiera typ_ucznia który wpływa na godziny lekcji!
--
-- REFERENCJE (2):
--   ref_instrument → t_instrument (NOT NULL - każdy uczeń ma główny instrument)
--   ref_grupa      → t_grupa (NULL dozwolone - nie wszyscy są w grupie)
--
-- TYP_UCZNIA (najważniejsze!):
--   - 'uczacy_sie_w_innej_szkole' → lekcje TYLKO od 15:00 (dzieci w szkole podstawowej/liceum)
--   - 'ukonczyl_edukacje'         → lekcje od 14:00 (absolwenci, studenci, dorośli)
--   - 'tylko_muzyczna'            → lekcje od 14:00 (homeschooling, zawodowi muzycy)
--
-- CYKL_NAUCZANIA:
--   Zawsze 6 w tym modelu (6-letnia szkoła muzyczna I stopnia).
--   Można by rozszerzyć na 4-letni cykl II stopnia.
--
-- STATUS:
--   - aktywny    → normalnie się uczy
--   - zawieszony → tymczasowa przerwa
--   - skreslony  → usunięty z listy uczniów (nie usuwamy z bazy - ma historię!)
-- -----------------------------------------------------------------------------
CREATE TABLE t_uczen OF t_uczen_obj (
    id_ucznia           PRIMARY KEY,
    imie                NOT NULL,
    nazwisko            NOT NULL,
    data_urodzenia      NOT NULL,
    -- email może być NULL (dla dzieci)
    -- telefon_rodzica może być NULL
    data_zapisu         NOT NULL,
    klasa               NOT NULL,
    cykl_nauczania      NOT NULL,
    typ_ucznia          NOT NULL,
    status              NOT NULL,
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- REFERENCJE - SERCE MODELU OBIEKTOWEGO!
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- Główny instrument ucznia (WYMAGANY)
    -- SCOPE IS t_instrument = REF może wskazywać tylko na t_instrument
    ref_instrument      SCOPE IS t_instrument NOT NULL,
    
    -- Grupa (opcjonalna - dla zajęć grupowych)
    ref_grupa           SCOPE IS t_grupa,
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- CONSTRAINTS
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- Klasa 1-6
    CONSTRAINT chk_uczen_klasa CHECK (klasa BETWEEN 1 AND 6),
    
    -- Cykl = 6 (w tym modelu)
    CONSTRAINT chk_uczen_cykl CHECK (cykl_nauczania = 6),
    
    -- 🔴 KLUCZOWY CHECK - typ ucznia
    CONSTRAINT chk_uczen_typ CHECK (
        typ_ucznia IN ('uczacy_sie_w_innej_szkole', 'ukonczyl_edukacje', 'tylko_muzyczna')
    ),
    
    -- Statusy
    CONSTRAINT chk_uczen_status CHECK (
        status IN ('aktywny', 'zawieszony', 'skreslony')
    )
);

COMMENT ON TABLE t_uczen IS 'Uczniowie szkoły muzycznej';
COMMENT ON COLUMN t_uczen.typ_ucznia IS '🔴 KLUCZOWE: uczacy_sie_w_innej_szkole=lekcje od 15:00, inne=od 14:00';
COMMENT ON COLUMN t_uczen.ref_instrument IS 'REF do głównego instrumentu ucznia';
COMMENT ON COLUMN t_uczen.ref_grupa IS 'REF do grupy (dla zajęć grupowych), może być NULL';

PROMPT [7/10] Tworzenie t_przedmiot...

-- -----------------------------------------------------------------------------
-- TABELA: t_przedmiot
-- -----------------------------------------------------------------------------
-- Przedmioty nauczania (słownik, ale z REF do instrumentu).
--
-- REFERENCJE (1):
--   ref_instrument → t_instrument (NULL dla teoretycznych, NOT NULL dla instrumentalnych)
--
-- TYPY PRZEDMIOTÓW:
--   1. Instrumentalne (indywidualny):
--      - "Instrument główny" - ref_instrument wskazuje na instrument ucznia
--      - "Fortepian dodatkowy" - ref_instrument = fortepian
--   
--   2. Teoretyczne (grupowy):
--      - "Kształcenie słuchu", "Rytmika", "Audycje" - ref_instrument = NULL
--
-- KLASY_OD / KLASY_DO:
--   Zakres klas, dla których przedmiot jest dostępny.
--   Np. Rytmika: 1-2, Fortepian dodatkowy: 3-6
-- -----------------------------------------------------------------------------
CREATE TABLE t_przedmiot OF t_przedmiot_obj (
    id_przedmiotu       PRIMARY KEY,
    nazwa               NOT NULL,
    typ_zajec           NOT NULL,
    wymiar_minut        NOT NULL,
    klasy_od            NOT NULL,
    klasy_do            NOT NULL,
    czy_obowiazkowy     NOT NULL,
    -- wymagany_sprzet może być NULL
    
    -- REF do instrumentu (NULL dla teoretycznych)
    ref_instrument      SCOPE IS t_instrument,
    
    -- Unikalna nazwa przedmiotu
    CONSTRAINT uk_przedmiot_nazwa UNIQUE (nazwa),
    
    -- Typ zajęć
    CONSTRAINT chk_przedmiot_typ CHECK (
        typ_zajec IN ('indywidualny', 'grupowy')
    ),
    
    -- Dozwolone czasy trwania
    CONSTRAINT chk_przedmiot_wymiar CHECK (
        wymiar_minut IN (30, 45, 60, 90)
    ),
    
    -- Klasy 1-6
    CONSTRAINT chk_przedmiot_klasy_od CHECK (klasy_od BETWEEN 1 AND 6),
    CONSTRAINT chk_przedmiot_klasy_do CHECK (klasy_do BETWEEN 1 AND 6),
    
    -- klasy_od <= klasy_do
    CONSTRAINT chk_przedmiot_klasy_zakres CHECK (klasy_od <= klasy_do),
    
    -- T/N
    CONSTRAINT chk_przedmiot_obow CHECK (czy_obowiazkowy IN ('T', 'N'))
);

COMMENT ON TABLE t_przedmiot IS 'Przedmioty nauczania (instrumentalne i teoretyczne)';
COMMENT ON COLUMN t_przedmiot.ref_instrument IS 'REF do instrumentu (NULL dla przedmiotów teoretycznych)';
COMMENT ON COLUMN t_przedmiot.klasy_od IS 'Od której klasy przedmiot jest dostępny';
COMMENT ON COLUMN t_przedmiot.klasy_do IS 'Do której klasy przedmiot jest dostępny';

-- ============================================================================
-- SEKCJA 5: TABELE TRANSAKCYJNE (wiele REF)
-- ============================================================================
--
-- Lekcje, egzaminy, oceny - to "zdarzenia" w systemie.
-- Mają WIELE referencji do innych tabel.
--
-- ============================================================================

PROMPT [8/10] Tworzenie t_lekcja...

-- -----------------------------------------------------------------------------
-- TABELA: t_lekcja
-- -----------------------------------------------------------------------------
-- 🔴 NAJBARDZIEJ ZŁOŻONA TABELA - MA 6 REFERENCJI!
--
-- REFERENCJE:
--   ref_przedmiot    → t_przedmiot    (NOT NULL)
--   ref_nauczyciel   → t_nauczyciel   (NOT NULL)
--   ref_akompaniator → t_nauczyciel   (NULL jeśli nie potrzeba)
--   ref_sala         → t_sala         (NOT NULL)
--   ref_uczen        → t_uczen        (NULL dla grupowych)
--   ref_grupa        → t_grupa        (NULL dla indywidualnych)
--
-- REGUŁA XOR:
--   (ref_uczen IS NOT NULL) XOR (ref_grupa IS NOT NULL)
--   Lekcja jest ALBO indywidualna (dla ucznia) ALBO grupowa (dla grupy).
--   Nie może być obu naraz, nie może być żadnego.
--
-- GODZINA_START:
--   Format 'HH:MI' (np. '14:30')
--   Walidacja przez CHECK i REGEXP.
--   Zakres: 14:00 - 19:30 (by skończyć do 20:00)
--
-- STATUS:
--   - zaplanowana → przyszła lekcja
--   - odbyta      → zakończona pomyślnie
--   - odwolana    → anulowana (choroba, itd.)
-- -----------------------------------------------------------------------------
CREATE TABLE t_lekcja OF t_lekcja_obj (
    id_lekcji           PRIMARY KEY,
    data_lekcji         NOT NULL,
    godzina_start       NOT NULL,
    czas_trwania        NOT NULL,
    typ_lekcji          NOT NULL,
    status              NOT NULL,
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- 6 REFERENCJI (!)
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- Przedmiot (WYMAGANY)
    ref_przedmiot       SCOPE IS t_przedmiot NOT NULL,
    
    -- Prowadzący nauczyciel (WYMAGANY)
    ref_nauczyciel      SCOPE IS t_nauczyciel NOT NULL,
    
    -- Akompaniator (opcjonalny - dla smyczków/dętych)
    ref_akompaniator    SCOPE IS t_nauczyciel,
    
    -- Sala (WYMAGANA)
    ref_sala            SCOPE IS t_sala NOT NULL,
    
    -- Uczeń (dla lekcji indywidualnych) - NULL dla grupowych
    ref_uczen           SCOPE IS t_uczen,
    
    -- Grupa (dla lekcji grupowych) - NULL dla indywidualnych
    ref_grupa           SCOPE IS t_grupa,
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- CONSTRAINTS
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- Typ lekcji
    CONSTRAINT chk_lekcja_typ CHECK (
        typ_lekcji IN ('indywidualna', 'grupowa')
    ),
    
    -- Czas trwania (minuty)
    CONSTRAINT chk_lekcja_czas CHECK (
        czas_trwania IN (30, 45, 60, 90)
    ),
    
    -- Status
    CONSTRAINT chk_lekcja_status CHECK (
        status IN ('zaplanowana', 'odbyta', 'odwolana')
    ),
    
    -- Format godziny HH:MI (00:00 - 23:59)
    CONSTRAINT chk_lekcja_godzina_format CHECK (
        REGEXP_LIKE(godzina_start, '^([01][0-9]|2[0-3]):[0-5][0-9]$')
    ),
    
    -- Godziny pracy szkoły: 14:00 - 19:30 (żeby skończyć do 20:00)
    -- Porównanie stringowe działa dla formatu HH:MI!
    CONSTRAINT chk_lekcja_godzina_zakres CHECK (
        godzina_start >= '14:00' AND godzina_start <= '19:30'
    )
    
    -- UWAGA: Reguła XOR (uczen XOR grupa) - w triggerze/pakiecie!
    -- Oracle nie obsługuje XOR w CHECK constraint elegancko.
);

COMMENT ON TABLE t_lekcja IS '🔴 Lekcje - najważniejsza tabela transakcyjna (6 REF!)';
COMMENT ON COLUMN t_lekcja.ref_uczen IS 'Dla lekcji indywidualnych, NULL dla grupowych';
COMMENT ON COLUMN t_lekcja.ref_grupa IS 'Dla lekcji grupowych, NULL dla indywidualnych';
COMMENT ON COLUMN t_lekcja.ref_akompaniator IS 'Akompaniator (pianista) dla smyczków/dętych';
COMMENT ON COLUMN t_lekcja.godzina_start IS 'Format HH:MI, zakres 14:00-19:30';

PROMPT [9/10] Tworzenie t_egzamin...

-- -----------------------------------------------------------------------------
-- TABELA: t_egzamin
-- -----------------------------------------------------------------------------
-- Egzaminy: wstępne, semestralne, poprawkowe.
--
-- REFERENCJE (5):
--   ref_uczen     → t_uczen        (NOT NULL)
--   ref_przedmiot → t_przedmiot    (NOT NULL)
--   ref_komisja1  → t_nauczyciel   (NOT NULL)
--   ref_komisja2  → t_nauczyciel   (NOT NULL)
--   ref_sala      → t_sala         (NOT NULL)
--
-- KOMISJA:
--   Minimum 2 różne osoby (ref_komisja1 != ref_komisja2)
--   Walidacja w triggerze (CHECK na REF nie działa!)
--
-- OCENA_KONCOWA:
--   NULL przed egzaminem, 1-6 po wystawieniu.
-- -----------------------------------------------------------------------------
CREATE TABLE t_egzamin OF t_egzamin_obj (
    id_egzaminu         PRIMARY KEY,
    data_egzaminu       NOT NULL,
    godzina             NOT NULL,
    typ_egzaminu        NOT NULL,
    
    -- 5 REFERENCJI (wszystkie WYMAGANE)
    ref_uczen           SCOPE IS t_uczen NOT NULL,
    ref_przedmiot       SCOPE IS t_przedmiot NOT NULL,
    ref_komisja1        SCOPE IS t_nauczyciel NOT NULL,
    ref_komisja2        SCOPE IS t_nauczyciel NOT NULL,
    ref_sala            SCOPE IS t_sala NOT NULL,
    
    -- ocena_koncowa może być NULL (przed egzaminem)
    -- uwagi mogą być NULL
    
    -- Typ egzaminu
    CONSTRAINT chk_egzamin_typ CHECK (
        typ_egzaminu IN ('wstepny', 'semestralny', 'poprawkowy')
    ),
    
    -- Format godziny
    CONSTRAINT chk_egzamin_godzina CHECK (
        REGEXP_LIKE(godzina, '^([01][0-9]|2[0-3]):[0-5][0-9]$')
    ),
    
    -- Ocena 1-6 lub NULL
    CONSTRAINT chk_egzamin_ocena CHECK (
        ocena_koncowa IS NULL OR ocena_koncowa BETWEEN 1 AND 6
    )
    
    -- UWAGA: ref_komisja1 != ref_komisja2 - walidacja w triggerze!
);

COMMENT ON TABLE t_egzamin IS 'Egzaminy (wstępne, semestralne, poprawkowe)';
COMMENT ON COLUMN t_egzamin.ref_komisja1 IS 'Pierwszy członek komisji';
COMMENT ON COLUMN t_egzamin.ref_komisja2 IS 'Drugi członek komisji (MUSI być różny od komisja1!)';
COMMENT ON COLUMN t_egzamin.ocena_koncowa IS 'NULL przed egzaminem, 1-6 po wystawieniu';

PROMPT [10/10] Tworzenie t_ocena...

-- -----------------------------------------------------------------------------
-- TABELA: t_ocena
-- -----------------------------------------------------------------------------
-- Oceny bieżące (cząstkowe) - wiele per uczeń/przedmiot.
--
-- REFERENCJE (4):
--   ref_uczen      → t_uczen        (NOT NULL)
--   ref_nauczyciel → t_nauczyciel   (NOT NULL)
--   ref_przedmiot  → t_przedmiot    (NOT NULL)
--   ref_lekcja     → t_lekcja       (NULL - ocena nie musi być z lekcji)
--
-- OBSZARY OCENIANIA:
--   - technika      → poprawność gry
--   - interpretacja → muzyczność
--   - sluch         → rozpoznawanie dźwięków
--   - teoria        → wiedza teoretyczna
--   - rytm          → poczucie metrum
--   - ogolna        → ocena całościowa
--
-- SKALA:
--   1-6 (polska skala szkolna)
--   1 = niedostateczny, 6 = celujący
-- -----------------------------------------------------------------------------
CREATE TABLE t_ocena OF t_ocena_obj (
    id_oceny            PRIMARY KEY,
    data_oceny          NOT NULL,
    wartosc             NOT NULL,
    obszar              NOT NULL,
    -- komentarz może być NULL
    
    -- 4 REFERENCJE
    ref_uczen           SCOPE IS t_uczen NOT NULL,
    ref_nauczyciel      SCOPE IS t_nauczyciel NOT NULL,
    ref_przedmiot       SCOPE IS t_przedmiot NOT NULL,
    ref_lekcja          SCOPE IS t_lekcja,  -- może być NULL
    
    -- Ocena 1-6
    CONSTRAINT chk_ocena_wartosc CHECK (wartosc BETWEEN 1 AND 6),
    
    -- Obszary oceniania
    CONSTRAINT chk_ocena_obszar CHECK (
        obszar IN ('technika', 'interpretacja', 'sluch', 'teoria', 'rytm', 'ogolna')
    )
);

COMMENT ON TABLE t_ocena IS 'Oceny bieżące (cząstkowe) uczniów';
COMMENT ON COLUMN t_ocena.obszar IS 'Obszar: technika/interpretacja/sluch/teoria/rytm/ogolna';
COMMENT ON COLUMN t_ocena.ref_lekcja IS 'Powiązana lekcja (opcjonalne)';

-- ============================================================================
-- SEKCJA 6: INDEKSY (opcjonalne, dla wydajności)
-- ============================================================================
--
-- Oracle automatycznie tworzy indeksy dla:
--   - PRIMARY KEY
--   - UNIQUE constraints
--
-- Dodatkowe indeksy dla często używanych kolumn w WHERE/JOIN:
-- ============================================================================

PROMPT [INDEKSY] Tworzenie dodatkowych indeksów...

-- Indeks na status ucznia (częste filtrowanie: WHERE status = 'aktywny')
CREATE INDEX idx_uczen_status ON t_uczen(status);

-- Indeks na status nauczyciela
CREATE INDEX idx_nauczyciel_status ON t_nauczyciel(status);

-- Indeks na datę lekcji (częste zapytania: lekcje danego dnia)
CREATE INDEX idx_lekcja_data ON t_lekcja(data_lekcji);

-- Indeks na status lekcji
CREATE INDEX idx_lekcja_status ON t_lekcja(status);

-- Indeks złożony: data + godzina (dla szukania konfliktów)
CREATE INDEX idx_lekcja_termin ON t_lekcja(data_lekcji, godzina_start);

-- Indeks na datę oceny (dla raportów)
CREATE INDEX idx_ocena_data ON t_ocena(data_oceny);

-- Indeks na datę egzaminu
CREATE INDEX idx_egzamin_data ON t_egzamin(data_egzaminu);

PROMPT [OK] Utworzono dodatkowe indeksy.

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================

PROMPT
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT   PODSUMOWANIE - Utworzone obiekty
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT
PROMPT   SEKWENCJE (10):
PROMPT     seq_semestr, seq_instrument, seq_sala, seq_nauczyciel, seq_grupa,
PROMPT     seq_uczen, seq_przedmiot, seq_lekcja, seq_egzamin, seq_ocena
PROMPT
PROMPT   TABELE SŁOWNIKOWE (2):
PROMPT     [✓] t_semestr      - semestry akademickie
PROMPT     [✓] t_instrument   - instrumenty muzyczne
PROMPT
PROMPT   TABELE ZASOBÓW (3):
PROMPT     [✓] t_sala         - sale lekcyjne (VARRAY wyposażenia)
PROMPT     [✓] t_nauczyciel   - nauczyciele (VARRAY instrumentów)
PROMPT     [✓] t_grupa        - grupy uczniów
PROMPT
PROMPT   TABELE Z REF (2):
PROMPT     [✓] t_uczen        - uczniowie (2 REF)
PROMPT     [✓] t_przedmiot    - przedmioty (1 REF)
PROMPT
PROMPT   TABELE TRANSAKCYJNE (3):
PROMPT     [✓] t_lekcja       - lekcje (6 REF!) 🔴
PROMPT     [✓] t_egzamin      - egzaminy (5 REF)
PROMPT     [✓] t_ocena        - oceny (4 REF)
PROMPT
PROMPT   RAZEM: 10 sekwencji, 10 tabel, 18 relacji REF, 7 indeksów
PROMPT
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT   Następny krok: Uruchom 03_triggery.sql
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT

-- Pokaż utworzone tabele
SELECT table_name, num_rows, status
FROM user_tables
WHERE table_name LIKE 'T\_%' ESCAPE '\'
ORDER BY table_name;

-- Pokaż sekwencje
SELECT sequence_name, last_number
FROM user_sequences
WHERE sequence_name LIKE 'SEQ\_%' ESCAPE '\'
ORDER BY sequence_name;
