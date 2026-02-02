-- ============================================================================
-- SZKOŁA MUZYCZNA I STOPNIA - TYPY OBIEKTOWE
-- Autorzy: Igor Typiński (251237), Mateusz Mróz (251190)
-- ============================================================================

-- ============================================================================
-- CZYSZCZENIE
-- ============================================================================
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_ocena FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_lekcja FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_uczen FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_sala FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_nauczyciel FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_grupa FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_przedmiot FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_wyposazenie FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ============================================================================
-- 1. VARRAY - Wyposażenie sali (max 10 elementów)
-- ============================================================================
CREATE OR REPLACE TYPE t_wyposazenie AS VARRAY(10) OF VARCHAR2(50);
/

-- ============================================================================
-- 2. T_PRZEDMIOT - przedmiot nauczania
-- ============================================================================
CREATE OR REPLACE TYPE t_przedmiot AS OBJECT (
    id              NUMBER,
    nazwa           VARCHAR2(50),
    typ             VARCHAR2(20),       -- 'indywidualny' lub 'grupowy'
    czas_min        NUMBER,             -- czas trwania (45 min)

    MEMBER FUNCTION czy_grupowy RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_przedmiot AS
    MEMBER FUNCTION czy_grupowy RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE WHEN SELF.typ = 'grupowy' THEN 'T' ELSE 'N' END;
    END;
END;
/

-- ============================================================================
-- 3. T_GRUPA - klasa uczniów
-- ============================================================================
CREATE OR REPLACE TYPE t_grupa AS OBJECT (
    id              NUMBER,
    symbol          VARCHAR2(10),       -- np. '1A', '2A'
    poziom          NUMBER              -- 1-6 (klasa I-VI)
);
/

-- ============================================================================
-- 4. T_NAUCZYCIEL - nauczyciel (uczy JEDNEGO przedmiotu - REF!)
-- ============================================================================
CREATE OR REPLACE TYPE t_nauczyciel AS OBJECT (
    id              NUMBER,
    imie            VARCHAR2(50),
    nazwisko        VARCHAR2(50),
    data_zatr       DATE,
    ref_przedmiot   REF t_przedmiot,    -- REF do przedmiotu który uczy!

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
    numer           VARCHAR2(10),
    typ             VARCHAR2(20),       -- 'indywidualna' lub 'grupowa'
    pojemnosc       NUMBER,
    wyposazenie     t_wyposazenie,      -- VARRAY wyposażenia!

    MEMBER FUNCTION czy_grupowa RETURN VARCHAR2,
    MEMBER FUNCTION lista_wyposazenia RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_sala AS
    MEMBER FUNCTION czy_grupowa RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE WHEN SELF.typ = 'grupowa' THEN 'T' ELSE 'N' END;
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
    instrument      VARCHAR2(50),
    ref_grupa       REF t_grupa,        -- REF do grupy!

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
-- 7. T_LEKCJA - lekcja z REF (XOR: uczeń lub grupa)
-- ============================================================================
CREATE OR REPLACE TYPE t_lekcja AS OBJECT (
    id              NUMBER,
    ref_przedmiot   REF t_przedmiot,
    ref_nauczyciel  REF t_nauczyciel,
    ref_sala        REF t_sala,
    ref_uczen       REF t_uczen,        -- dla lekcji indywidualnej (XOR)
    ref_grupa       REF t_grupa,        -- dla lekcji grupowej (XOR)
    data_lekcji     DATE,
    godz_rozp       NUMBER,             -- 14, 15, 16... (pełne godziny)
    czas_min        NUMBER,             -- 45

    MEMBER FUNCTION godzina_koniec RETURN NUMBER,
    MEMBER FUNCTION czy_indywidualna RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_lekcja AS
    MEMBER FUNCTION godzina_koniec RETURN NUMBER IS
    BEGIN
        -- Lekcja 45 min = 0.75h, więc 14:00 + 0.75 = 14.75 (14:45)
        RETURN SELF.godz_rozp + (SELF.czas_min / 60.0);
    END;

    MEMBER FUNCTION czy_indywidualna RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE WHEN SELF.ref_uczen IS NOT NULL THEN 'T' ELSE 'N' END;
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
    wartosc         NUMBER,             -- 1-6
    data_oceny      DATE,
    semestralna     VARCHAR2(1),        -- 'T' lub 'N'

    MEMBER FUNCTION opis_oceny RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_ocena AS
    MEMBER FUNCTION opis_oceny RETURN VARCHAR2 IS
    BEGIN
        RETURN CASE SELF.wartosc
            WHEN 1 THEN 'niedostateczny'
            WHEN 2 THEN 'dopuszczający'
            WHEN 3 THEN 'dostateczny'
            WHEN 4 THEN 'dobry'
            WHEN 5 THEN 'bardzo dobry'
            WHEN 6 THEN 'celujący'
            ELSE 'nieznana'
        END;
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
