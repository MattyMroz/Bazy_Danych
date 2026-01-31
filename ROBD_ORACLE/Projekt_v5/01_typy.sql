-- ============================================================================
-- PLIK: 01_typy.sql
-- PROJEKT: Szkola Muzyczna v5 - Obiektowa Baza Danych Oracle
-- AUTORZY: Igor Typinski (251237), Mateusz Mroz (251190)
-- DATA: Styczen 2026
-- ============================================================================
-- Definiuje 12 TYPOW OBIEKTOWYCH - fundament bazy danych
-- Kolejnosc: VARRAY -> typy bazowe -> typy z REF -> typy transakcyjne
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200
SET PAGESIZE 50

PROMPT ========================================================================
PROMPT   01_typy.sql - Tworzenie typow obiektowych
PROMPT ========================================================================
PROMPT

-- ============================================================================
-- 1. KOLEKCJE VARRAY
-- ============================================================================

PROMPT [1/12] Tworzenie t_lista_instrumentow (VARRAY)...

-- Lista instrumentow nauczyciela (max 5)
CREATE OR REPLACE TYPE t_lista_instrumentow AS VARRAY(5) OF VARCHAR2(100);
/

PROMPT [2/12] Tworzenie t_lista_sprzetu (VARRAY)...

-- Lista wyposazenia sali (max 10)
CREATE OR REPLACE TYPE t_lista_sprzetu AS VARRAY(10) OF VARCHAR2(100);
/

-- ============================================================================
-- 2. TYP: T_SEMESTR_OBJ
-- Reprezentuje semestr akademicki (okres rozliczeniowy)
-- ============================================================================

PROMPT [3/12] Tworzenie t_semestr_obj...

CREATE OR REPLACE TYPE t_semestr_obj AS OBJECT (
    id_semestru       NUMBER,
    nazwa             VARCHAR2(50),
    data_start        DATE,
    data_koniec       DATE,
    rok_szkolny       VARCHAR2(9),

    MEMBER FUNCTION liczba_tygodni RETURN NUMBER,
    MEMBER FUNCTION czy_aktywny RETURN CHAR,
    MEMBER FUNCTION opis RETURN VARCHAR2
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY t_semestr_obj AS

    -- Liczba pelnych tygodni w semestrze
    MEMBER FUNCTION liczba_tygodni RETURN NUMBER IS
    BEGIN
        RETURN TRUNC((data_koniec - data_start) / 7);
    END;

    -- Czy semestr jest aktywny (T/N)
    MEMBER FUNCTION czy_aktywny RETURN CHAR IS
    BEGIN
        IF SYSDATE BETWEEN data_start AND data_koniec THEN
            RETURN 'T';
        ELSE
            RETURN 'N';
        END IF;
    END;

    -- Opis semestru do raportow
    MEMBER FUNCTION opis RETURN VARCHAR2 IS
    BEGIN
        RETURN nazwa || ' (' ||
               TO_CHAR(data_start, 'DD.MM.YYYY') || ' - ' ||
               TO_CHAR(data_koniec, 'DD.MM.YYYY') || ')';
    END;

END;
/

-- ============================================================================
-- 3. TYP: T_INSTRUMENT_OBJ
-- Reprezentuje instrument muzyczny (slownik)
-- Kategorie: klawiszowe/strunowe/dete/perkusyjne
-- ============================================================================

PROMPT [4/12] Tworzenie t_instrument_obj...

CREATE OR REPLACE TYPE t_instrument_obj AS OBJECT (
    id_instrumentu              NUMBER,
    nazwa                       VARCHAR2(100),
    kategoria                   VARCHAR2(50),
    czy_wymaga_akompaniatora    CHAR(1),

    MEMBER FUNCTION opis RETURN VARCHAR2,
    MEMBER FUNCTION czy_smyczkowy RETURN CHAR
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY t_instrument_obj AS

    -- Opis: "Fortepian (klawiszowe)"
    MEMBER FUNCTION opis RETURN VARCHAR2 IS
    BEGIN
        RETURN nazwa || ' (' || kategoria || ')';
    END;

    -- Czy instrument smyczkowy
    MEMBER FUNCTION czy_smyczkowy RETURN CHAR IS
    BEGIN
        IF UPPER(nazwa) IN ('SKRZYPCE', 'ALTÓWKA', 'WIOLONCZELA', 'KONTRABAS') THEN
            RETURN 'T';
        ELSE
            RETURN 'N';
        END IF;
    END;

END;
/

-- ============================================================================
-- 4. TYP: T_SALA_OBJ
-- Reprezentuje sale lekcyjna
-- Typy: indywidualna/grupowa/wielofunkcyjna
-- Zawiera VARRAY wyposazenia
-- ============================================================================

PROMPT [5/12] Tworzenie t_sala_obj...

CREATE OR REPLACE TYPE t_sala_obj AS OBJECT (
    id_sali           NUMBER,
    numer             VARCHAR2(20),
    typ_sali          VARCHAR2(20),
    pojemnosc         NUMBER,
    wyposazenie       t_lista_sprzetu,
    status            VARCHAR2(20),

    MEMBER FUNCTION opis_pelny RETURN VARCHAR2,
    MEMBER FUNCTION czy_ma_sprzet(p_nazwa VARCHAR2) RETURN CHAR,
    MEMBER FUNCTION czy_odpowiednia(p_typ VARCHAR2, p_osob NUMBER) RETURN CHAR
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY t_sala_obj AS

    -- Pelny opis sali z lista sprzetu
    MEMBER FUNCTION opis_pelny RETURN VARCHAR2 IS
        v_sprzet VARCHAR2(500) := '';
    BEGIN
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

    -- Czy sala ma dany sprzet (przeszukuje VARRAY)
    MEMBER FUNCTION czy_ma_sprzet(p_nazwa VARCHAR2) RETURN CHAR IS
    BEGIN
        IF wyposazenie IS NULL OR wyposazenie.COUNT = 0 THEN
            RETURN 'N';
        END IF;
        FOR i IN 1..wyposazenie.COUNT LOOP
            IF INSTR(UPPER(wyposazenie(i)), UPPER(p_nazwa)) > 0 THEN
                RETURN 'T';
            END IF;
        END LOOP;
        RETURN 'N';
    END;

    -- Czy sala pasuje do typu zajec i liczby osob
    MEMBER FUNCTION czy_odpowiednia(p_typ VARCHAR2, p_osob NUMBER) RETURN CHAR IS
    BEGIN
        IF p_osob > pojemnosc THEN
            RETURN 'N';
        END IF;
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

-- ============================================================================
-- 5. TYP: T_NAUCZYCIEL_OBJ
-- Reprezentuje nauczyciela szkoly muzycznej
-- Zawiera VARRAY instrumentow ktore nauczyciel moze prowadzic
-- ============================================================================

PROMPT [6/12] Tworzenie t_nauczyciel_obj...

CREATE OR REPLACE TYPE t_nauczyciel_obj AS OBJECT (
    id_nauczyciela        NUMBER,
    imie                  VARCHAR2(50),
    nazwisko              VARCHAR2(50),
    email                 VARCHAR2(100),
    telefon               VARCHAR2(20),
    data_zatrudnienia     DATE,
    instrumenty           t_lista_instrumentow,
    czy_prowadzi_grupowe  CHAR(1),
    czy_akompaniator      CHAR(1),
    status                VARCHAR2(20),

    MEMBER FUNCTION pelne_dane RETURN VARCHAR2,
    MEMBER FUNCTION lata_stazu RETURN NUMBER,
    MEMBER FUNCTION liczba_instrumentow RETURN NUMBER,
    MEMBER FUNCTION czy_uczy(p_instrument VARCHAR2) RETURN CHAR
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY t_nauczyciel_obj AS

    -- "Jan Kowalski (jan.kowalski@szkola.pl)"
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2 IS
    BEGIN
        RETURN imie || ' ' || nazwisko || ' (' || email || ')';
    END;

    -- Lata stazu pracy
    MEMBER FUNCTION lata_stazu RETURN NUMBER IS
    BEGIN
        IF data_zatrudnienia IS NULL THEN
            RETURN 0;
        END IF;
        RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, data_zatrudnienia) / 12);
    END;

    -- Ile instrumentow uczy
    MEMBER FUNCTION liczba_instrumentow RETURN NUMBER IS
    BEGIN
        IF instrumenty IS NULL THEN
            RETURN 0;
        END IF;
        RETURN instrumenty.COUNT;
    END;

    -- Czy uczy danego instrumentu (przeszukuje VARRAY)
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

-- ============================================================================
-- 6. TYP: T_GRUPA_OBJ
-- Reprezentuje grupe uczniow do zajec grupowych
-- ============================================================================

PROMPT [7/12] Tworzenie t_grupa_obj...

CREATE OR REPLACE TYPE t_grupa_obj AS OBJECT (
    id_grupy            NUMBER,
    nazwa               VARCHAR2(20),
    klasa               NUMBER(1),
    rok_szkolny         VARCHAR2(9),
    max_uczniow         NUMBER,
    status              VARCHAR2(20),

    MEMBER FUNCTION opis RETURN VARCHAR2,
    MEMBER FUNCTION liczba_uczniow RETURN NUMBER
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY t_grupa_obj AS

    -- "Grupa 1A (klasa I, 2025/2026)"
    MEMBER FUNCTION opis RETURN VARCHAR2 IS
        v_klasa_rzymska VARCHAR2(5);
    BEGIN
        v_klasa_rzymska := CASE klasa
            WHEN 1 THEN 'I' WHEN 2 THEN 'II' WHEN 3 THEN 'III'
            WHEN 4 THEN 'IV' WHEN 5 THEN 'V' WHEN 6 THEN 'VI'
            ELSE TO_CHAR(klasa)
        END;
        RETURN 'Grupa ' || nazwa || ' (klasa ' || v_klasa_rzymska || ', ' || rok_szkolny || ')';
    END;

    -- Placeholder - prawdziwa logika w pakiecie
    MEMBER FUNCTION liczba_uczniow RETURN NUMBER IS
    BEGIN
        RETURN 0;
    END;

END;
/

-- ============================================================================
-- 7. TYP: T_UCZEN_OBJ
-- Reprezentuje ucznia szkoly muzycznej
-- WAZNE: typ_ucznia wplywa na dozwolone godziny lekcji:
--   'uczacy_sie_w_innej_szkole' -> lekcje od 15:00
--   'ukonczyl_edukacje'/'tylko_muzyczna' -> lekcje od 14:00
-- ============================================================================

PROMPT [8/12] Tworzenie t_uczen_obj...

CREATE OR REPLACE TYPE t_uczen_obj AS OBJECT (
    id_ucznia           NUMBER,
    imie                VARCHAR2(50),
    nazwisko            VARCHAR2(50),
    data_urodzenia      DATE,
    email               VARCHAR2(100),
    telefon_rodzica     VARCHAR2(20),
    data_zapisu         DATE,
    klasa               NUMBER(1),
    cykl_nauczania      NUMBER(1),
    typ_ucznia          VARCHAR2(30),
    status              VARCHAR2(20),
    ref_instrument      REF t_instrument_obj,
    ref_grupa           REF t_grupa_obj,

    MEMBER FUNCTION wiek RETURN NUMBER,
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2,
    MEMBER FUNCTION czy_wymaga_popoludnia RETURN CHAR,
    MEMBER FUNCTION min_godzina_lekcji RETURN VARCHAR2,
    MEMBER FUNCTION rok_nauki RETURN NUMBER
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY t_uczen_obj AS

    -- Wiek w latach
    MEMBER FUNCTION wiek RETURN NUMBER IS
    BEGIN
        IF data_urodzenia IS NULL THEN
            RETURN NULL;
        END IF;
        RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, data_urodzenia) / 12);
    END;

    -- "Jan Kowalski (klasa II)"
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

    -- Uczniowie z innej szkoly maja lekcje od 15:00
    MEMBER FUNCTION czy_wymaga_popoludnia RETURN CHAR IS
    BEGIN
        IF typ_ucznia = 'uczacy_sie_w_innej_szkole' THEN
            RETURN 'T';
        ELSE
            RETURN 'N';
        END IF;
    END;

    -- Minimalna godzina lekcji ('14:00' lub '15:00')
    MEMBER FUNCTION min_godzina_lekcji RETURN VARCHAR2 IS
    BEGIN
        IF typ_ucznia = 'uczacy_sie_w_innej_szkole' THEN
            RETURN '15:00';
        ELSE
            RETURN '14:00';
        END IF;
    END;

    -- Rok nauki (od daty zapisu)
    MEMBER FUNCTION rok_nauki RETURN NUMBER IS
    BEGIN
        IF data_zapisu IS NULL THEN
            RETURN 1;
        END IF;
        RETURN GREATEST(1, TRUNC(MONTHS_BETWEEN(SYSDATE, data_zapisu) / 12) + 1);
    END;

END;
/

-- ============================================================================
-- 8. TYP: T_PRZEDMIOT_OBJ
-- Reprezentuje przedmiot nauczania
-- Typy: indywidualny (instrument) / grupowy (teoria, rytmika)
-- ============================================================================

PROMPT [9/12] Tworzenie t_przedmiot_obj...

CREATE OR REPLACE TYPE t_przedmiot_obj AS OBJECT (
    id_przedmiotu       NUMBER,
    nazwa               VARCHAR2(100),
    typ_zajec           VARCHAR2(20),
    wymiar_minut        NUMBER,
    klasy_od            NUMBER(1),
    klasy_do            NUMBER(1),
    czy_obowiazkowy     CHAR(1),
    wymagany_sprzet     VARCHAR2(100),
    ref_instrument      REF t_instrument_obj,

    MEMBER FUNCTION opis RETURN VARCHAR2,
    MEMBER FUNCTION czy_dla_klasy(p_klasa NUMBER) RETURN CHAR
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY t_przedmiot_obj AS

    -- "Ksztalcenie sluchu (grupowy, 45 min, kl. I-VI)"
    MEMBER FUNCTION opis RETURN VARCHAR2 IS
        v_klasy VARCHAR2(20);
    BEGIN
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

    -- Czy przedmiot jest dla danej klasy
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
-- 9. TYP: T_LEKCJA_OBJ
-- Reprezentuje pojedyncza lekcje - najwazniejsza encja transakcyjna
-- MA 6 REFERENCJI: przedmiot, nauczyciel, akompaniator, sala, uczen, grupa
-- Regula XOR: (ref_uczen NOT NULL) XOR (ref_grupa NOT NULL)
-- ============================================================================

PROMPT [10/12] Tworzenie t_lekcja_obj...

CREATE OR REPLACE TYPE t_lekcja_obj AS OBJECT (
    id_lekcji           NUMBER,
    data_lekcji         DATE,
    godzina_start       VARCHAR2(5),
    czas_trwania        NUMBER,
    typ_lekcji          VARCHAR2(20),
    status              VARCHAR2(20),
    ref_przedmiot       REF t_przedmiot_obj,
    ref_nauczyciel      REF t_nauczyciel_obj,
    ref_akompaniator    REF t_nauczyciel_obj,
    ref_sala            REF t_sala_obj,
    ref_uczen           REF t_uczen_obj,
    ref_grupa           REF t_grupa_obj,

    MEMBER FUNCTION godzina_koniec RETURN VARCHAR2,
    MEMBER FUNCTION czas_txt RETURN VARCHAR2,
    MEMBER FUNCTION czy_grupowa RETURN CHAR,
    MEMBER FUNCTION dzien_tygodnia RETURN VARCHAR2
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY t_lekcja_obj AS

    -- Oblicza godzine zakonczenia
    MEMBER FUNCTION godzina_koniec RETURN VARCHAR2 IS
        v_godz NUMBER;
        v_min  NUMBER;
        v_suma NUMBER;
    BEGIN
        v_godz := TO_NUMBER(SUBSTR(godzina_start, 1, 2));
        v_min := TO_NUMBER(SUBSTR(godzina_start, 4, 2));
        v_suma := v_godz * 60 + v_min + czas_trwania;
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

    -- Czy lekcja grupowa (T/N)
    MEMBER FUNCTION czy_grupowa RETURN CHAR IS
    BEGIN
        IF typ_lekcji = 'grupowa' THEN
            RETURN 'T';
        ELSE
            RETURN 'N';
        END IF;
    END;

    -- Nazwa dnia tygodnia
    MEMBER FUNCTION dzien_tygodnia RETURN VARCHAR2 IS
    BEGIN
        RETURN TRIM(TO_CHAR(data_lekcji, 'DAY', 'NLS_DATE_LANGUAGE=POLISH'));
    END;

END;
/

-- ============================================================================
-- 10. TYP: T_EGZAMIN_OBJ
-- Reprezentuje egzamin (wstepny, semestralny, poprawkowy)
-- Komisja: minimum 2 roznych nauczycieli
-- ============================================================================

PROMPT [11/12] Tworzenie t_egzamin_obj...

CREATE OR REPLACE TYPE t_egzamin_obj AS OBJECT (
    id_egzaminu         NUMBER,
    data_egzaminu       DATE,
    godzina             VARCHAR2(5),
    typ_egzaminu        VARCHAR2(30),
    ref_uczen           REF t_uczen_obj,
    ref_przedmiot       REF t_przedmiot_obj,
    ref_komisja1        REF t_nauczyciel_obj,
    ref_komisja2        REF t_nauczyciel_obj,
    ref_sala            REF t_sala_obj,
    ocena_koncowa       NUMBER(1),
    uwagi               VARCHAR2(500),

    MEMBER FUNCTION czy_zdany RETURN CHAR,
    MEMBER FUNCTION ocena_slownie RETURN VARCHAR2
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY t_egzamin_obj AS

    -- Czy zdany (ocena >= 2)
    MEMBER FUNCTION czy_zdany RETURN CHAR IS
    BEGIN
        IF ocena_koncowa IS NULL THEN
            RETURN NULL;
        ELSIF ocena_koncowa >= 2 THEN
            RETURN 'T';
        ELSE
            RETURN 'N';
        END IF;
    END;

    -- Ocena slownie (celujacy, bardzo dobry, ...)
    MEMBER FUNCTION ocena_slownie RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE ocena_koncowa
            WHEN 6 THEN 'celujacy'
            WHEN 5 THEN 'bardzo dobry'
            WHEN 4 THEN 'dobry'
            WHEN 3 THEN 'dostateczny'
            WHEN 2 THEN 'dopuszczajacy'
            WHEN 1 THEN 'niedostateczny'
            ELSE 'brak oceny'
        END;
    END;

END;
/

-- ============================================================================
-- 11. TYP: T_OCENA_OBJ
-- Reprezentuje ocene biezaca (czastkowa)
-- Obszary: technika/interpretacja/sluch/teoria/rytm/ogolna
-- ============================================================================

PROMPT [12/12] Tworzenie t_ocena_obj...

CREATE OR REPLACE TYPE t_ocena_obj AS OBJECT (
    id_oceny            NUMBER,
    data_oceny          DATE,
    wartosc             NUMBER(1),
    obszar              VARCHAR2(50),
    komentarz           VARCHAR2(500),
    ref_uczen           REF t_uczen_obj,
    ref_nauczyciel      REF t_nauczyciel_obj,
    ref_przedmiot       REF t_przedmiot_obj,
    ref_lekcja          REF t_lekcja_obj,

    MEMBER FUNCTION ocena_slownie RETURN VARCHAR2,
    MEMBER FUNCTION czy_pozytywna RETURN CHAR
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY t_ocena_obj AS

    -- Ocena slownie
    MEMBER FUNCTION ocena_slownie RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE wartosc
            WHEN 6 THEN 'celujacy'
            WHEN 5 THEN 'bardzo dobry'
            WHEN 4 THEN 'dobry'
            WHEN 3 THEN 'dostateczny'
            WHEN 2 THEN 'dopuszczajacy'
            WHEN 1 THEN 'niedostateczny'
            ELSE 'blad'
        END;
    END;

    -- Czy ocena pozytywna (>= 2)
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
PROMPT ========================================================================
PROMPT   UTWORZONE TYPY OBIEKTOWE
PROMPT ========================================================================
PROMPT   VARRAY: t_lista_instrumentow, t_lista_sprzetu
PROMPT   TYPY: t_semestr_obj, t_instrument_obj, t_sala_obj, t_nauczyciel_obj
PROMPT         t_grupa_obj, t_uczen_obj, t_przedmiot_obj, t_lekcja_obj
PROMPT         t_egzamin_obj, t_ocena_obj
PROMPT   RAZEM: 12 typow, 29 metod, 18 REF, 2 VARRAY
PROMPT ========================================================================
PROMPT   Nastepny krok: Uruchom 02_tabele.sql
PROMPT ========================================================================

SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('TYPE', 'TYPE BODY')
ORDER BY object_type, object_name;
