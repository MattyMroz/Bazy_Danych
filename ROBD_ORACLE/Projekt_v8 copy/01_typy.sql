-- ============================================================================
-- SZKOŁA MUZYCZNA I STOPNIA - TYPY OBIEKTOWE
-- Autorzy: Igor Typiński (251237), Mateusz Mróz (251190)
-- ============================================================================

-- Czyszczenie (w odwrotnej kolejności zależności)
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE oceny FORCE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE lekcje FORCE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE uczniowie FORCE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE sale FORCE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE nauczyciele FORCE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE grupy FORCE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE przedmioty FORCE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE t_ocena FORCE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE t_lekcja FORCE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE t_uczen FORCE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE t_sala FORCE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE t_nauczyciel FORCE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE t_grupa FORCE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE t_przedmiot FORCE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE t_wyposazenie FORCE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- ============================================================================
-- 1. VARRAY - Wyposażenie sali (max 10 elementów)
-- ============================================================================
-- UWAGA ARCHITEKTONICZNA (świadome ograniczenie):
-- VARRAY ma sztywny limit 10 elementów. Jeśli sala będzie miała więcej niż 10
-- elementów wyposażenia, należy:
-- a) zwiększyć limit w definicji typu (wymaga rekompilacji), lub
-- b) zamienić na NESTED TABLE (brak limitu, ale bardziej skomplikowane)
-- W projekcie edukacyjnym VARRAY zostaje dla demonstracji tego typu kolekcji.
-- ============================================================================
CREATE OR REPLACE TYPE t_wyposazenie AS VARRAY(10) OF VARCHAR2(50);
/

-- ============================================================================
-- 2. T_PRZEDMIOT - przedmiot nauczania
-- ============================================================================
CREATE OR REPLACE TYPE t_przedmiot AS OBJECT (
    id              NUMBER,
    nazwa           VARCHAR2(50),
    typ             VARCHAR2(20),      -- 'indywidualny' lub 'grupowy'
    czas_min        NUMBER,            -- czas trwania w minutach

    MEMBER FUNCTION czy_grupowy RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_przedmiot AS
    MEMBER FUNCTION czy_grupowy RETURN VARCHAR2 IS
    BEGIN
        IF SELF.typ = 'grupowy' THEN
            RETURN 'T';
        ELSE
            RETURN 'N';
        END IF;
    END;
END;
/

-- ============================================================================
-- 3. T_GRUPA - klasa/grupa uczniów
-- ============================================================================
CREATE OR REPLACE TYPE t_grupa AS OBJECT (
    id              NUMBER,
    symbol          VARCHAR2(10),      -- np. '1A', '2A'
    poziom          NUMBER             -- 1-6 (klasa I-VI)
);
/

-- ============================================================================
-- 4. T_NAUCZYCIEL - nauczyciel
-- ============================================================================
CREATE OR REPLACE TYPE t_nauczyciel AS OBJECT (
    id              NUMBER,
    imie            VARCHAR2(50),
    nazwisko        VARCHAR2(50),
    data_zatr       DATE,

    MEMBER FUNCTION pelne_nazwisko RETURN VARCHAR2,
    MEMBER FUNCTION staz_lat RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY t_nauczyciel AS
    MEMBER FUNCTION pelne_nazwisko RETURN VARCHAR2 IS
    BEGIN
        RETURN SELF.imie || ' ' || SELF.nazwisko;
    END;

    MEMBER FUNCTION staz_lat RETURN NUMBER IS
    BEGIN
        RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, SELF.data_zatr) / 12);
    END;
END;
/

-- ============================================================================
-- 5. T_SALA - sala lekcyjna z VARRAY wyposażenia
-- ============================================================================
CREATE OR REPLACE TYPE t_sala AS OBJECT (
    id              NUMBER,
    numer           VARCHAR2(10),      -- np. '101', '201'
    typ             VARCHAR2(20),      -- 'indywidualna' lub 'grupowa'
    pojemnosc       NUMBER,
    wyposazenie     t_wyposazenie,     -- VARRAY!

    MEMBER FUNCTION czy_grupowa RETURN VARCHAR2,
    MEMBER FUNCTION lista_wyposazenia RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_sala AS
    MEMBER FUNCTION czy_grupowa RETURN VARCHAR2 IS
    BEGIN
        IF SELF.typ = 'grupowa' THEN
            RETURN 'T';
        ELSE
            RETURN 'N';
        END IF;
    END;

    MEMBER FUNCTION lista_wyposazenia RETURN VARCHAR2 IS
        v_lista VARCHAR2(500) := '';
    BEGIN
        IF SELF.wyposazenie IS NOT NULL THEN
            FOR i IN 1..SELF.wyposazenie.COUNT LOOP
                v_lista := v_lista || SELF.wyposazenie(i);
                IF i < SELF.wyposazenie.COUNT THEN
                    v_lista := v_lista || ', ';
                END IF;
            END LOOP;
        END IF;
        RETURN v_lista;
    END;
END;
/

-- ============================================================================
-- 6. T_UCZEN - uczeń z REF do grupy
-- ============================================================================
CREATE OR REPLACE TYPE t_uczen AS OBJECT (
    id              NUMBER,
    imie            VARCHAR2(50),
    nazwisko        VARCHAR2(50),
    data_ur         DATE,
    instrument      VARCHAR2(50),      -- główny instrument
    ref_grupa       REF t_grupa,       -- REF do grupy!

    MEMBER FUNCTION pelne_nazwisko RETURN VARCHAR2,
    MEMBER FUNCTION wiek RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY t_uczen AS
    MEMBER FUNCTION pelne_nazwisko RETURN VARCHAR2 IS
    BEGIN
        RETURN SELF.imie || ' ' || SELF.nazwisko;
    END;

    MEMBER FUNCTION wiek RETURN NUMBER IS
    BEGIN
        RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, SELF.data_ur) / 12);
    END;
END;
/

-- ============================================================================
-- 7. T_LEKCJA - lekcja z wieloma REF (XOR: uczeń lub grupa)
-- ============================================================================
-- UWAGA ARCHITEKTONICZNA (świadome ograniczenia):
-- 1. godz_rozp to NUMBER (pełne godziny: 14, 15, 16...). System NIE obsługuje
--    godzin typu 14:30. Jeśli potrzebne półgodzinne sloty, należy zmienić na DATE
--    lub NUMBER z ułamkami (14.5 = 14:30) i zaktualizować logikę kolizji.
-- 2. DEREF w zapytaniach może być wolniejsze niż JOIN przy dużej ilości danych.
--    W projekcie edukacyjnym akceptowalne (demonstracja obiektowości Oracle).
-- ============================================================================
CREATE OR REPLACE TYPE t_lekcja AS OBJECT (
    id              NUMBER,
    ref_przedmiot   REF t_przedmiot,
    ref_nauczyciel  REF t_nauczyciel,
    ref_sala        REF t_sala,
    ref_uczen       REF t_uczen,       -- dla lekcji indywidualnej (XOR)
    ref_grupa       REF t_grupa,       -- dla lekcji grupowej (XOR)
    data_lekcji     DATE,
    godz_rozp       NUMBER,            -- 14, 15, 16... (pełne godziny)
    czas_min        NUMBER,            -- 45

    MEMBER FUNCTION godzina_koniec RETURN NUMBER,
    MEMBER FUNCTION czy_indywidualna RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_lekcja AS
    MEMBER FUNCTION godzina_koniec RETURN NUMBER IS
    BEGIN
        RETURN SELF.godz_rozp + (SELF.czas_min / 60);
    END;

    MEMBER FUNCTION czy_indywidualna RETURN VARCHAR2 IS
    BEGIN
        IF SELF.ref_uczen IS NOT NULL THEN
            RETURN 'T';
        ELSE
            RETURN 'N';
        END IF;
    END;
END;
/

-- ============================================================================
-- 8. T_OCENA - ocena z REF
-- ============================================================================
CREATE OR REPLACE TYPE t_ocena AS OBJECT (
    id              NUMBER,
    ref_uczen       REF t_uczen,
    ref_nauczyciel  REF t_nauczyciel,
    ref_przedmiot   REF t_przedmiot,
    wartosc         NUMBER,            -- 1-6
    data_oceny      DATE,
    semestralna     VARCHAR2(1),       -- 'T' lub 'N'

    MEMBER FUNCTION opis_oceny RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_ocena AS
    MEMBER FUNCTION opis_oceny RETURN VARCHAR2 IS
        v_opis VARCHAR2(20);
    BEGIN
        CASE SELF.wartosc
            WHEN 1 THEN v_opis := 'niedostateczny';
            WHEN 2 THEN v_opis := 'dopuszczający';
            WHEN 3 THEN v_opis := 'dostateczny';
            WHEN 4 THEN v_opis := 'dobry';
            WHEN 5 THEN v_opis := 'bardzo dobry';
            WHEN 6 THEN v_opis := 'celujący';
            ELSE v_opis := 'nieznana';
        END CASE;
        RETURN v_opis;
    END;
END;
/

-- ============================================================================
-- Weryfikacja
-- ============================================================================
SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('TYPE', 'TYPE BODY')
ORDER BY object_type, object_name;
