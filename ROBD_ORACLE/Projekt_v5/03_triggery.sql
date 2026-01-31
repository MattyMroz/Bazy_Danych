-- ============================================================================
-- PLIK: 03_triggery.sql
-- PROJEKT: Szkola Muzyczna v5 - Obiektowa Baza Danych Oracle
-- AUTORZY: Igor Typinski (251237), Mateusz Mroz (251190)
-- DATA: Styczen 2026
-- ============================================================================
-- Definiuje TRIGGERY walidacyjne dla tabel
-- Unikamy ORA-04091 (mutating table) przez pakiet pkg_trigger_ctx
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200
SET PAGESIZE 50

PROMPT ========================================================================
PROMPT   03_triggery.sql - Tworzenie triggerow walidacyjnych
PROMPT ========================================================================
PROMPT

-- ============================================================================
-- PAKIET: PKG_TRIGGER_CTX
-- Kontekst triggerow - unikanie ORA-04091 (mutating table)
-- Pattern: BEFORE STATEMENT -> AFTER ROW -> AFTER STATEMENT
-- ============================================================================

PROMPT [1/7] Tworzenie pakietu pkg_trigger_ctx...

CREATE OR REPLACE PACKAGE pkg_trigger_ctx AS
    TYPE t_id_tab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;

    g_lekcje_ids      t_id_tab;
    g_lekcje_count    PLS_INTEGER := 0;

    g_egzaminy_ids    t_id_tab;
    g_egzaminy_count  PLS_INTEGER := 0;

    PROCEDURE clear_lekcje;
    PROCEDURE add_lekcja(p_id NUMBER);
    PROCEDURE clear_egzaminy;
    PROCEDURE add_egzamin(p_id NUMBER);
END pkg_trigger_ctx;
/

CREATE OR REPLACE PACKAGE BODY pkg_trigger_ctx AS

    PROCEDURE clear_lekcje IS
    BEGIN
        g_lekcje_ids.DELETE;
        g_lekcje_count := 0;
    END;

    PROCEDURE add_lekcja(p_id NUMBER) IS
    BEGIN
        g_lekcje_count := g_lekcje_count + 1;
        g_lekcje_ids(g_lekcje_count) := p_id;
    END;

    PROCEDURE clear_egzaminy IS
    BEGIN
        g_egzaminy_ids.DELETE;
        g_egzaminy_count := 0;
    END;

    PROCEDURE add_egzamin(p_id NUMBER) IS
    BEGIN
        g_egzaminy_count := g_egzaminy_count + 1;
        g_egzaminy_ids(g_egzaminy_count) := p_id;
    END;

END pkg_trigger_ctx;
/

-- ============================================================================
-- TRIGGER: TRG_EGZAMIN_KOMISJA
-- Komisja egzaminacyjna musi skladac sie z 2 ROZNYCH nauczycieli
-- ============================================================================

PROMPT [2/7] Tworzenie trg_egzamin_komisja...

CREATE OR REPLACE TRIGGER trg_egzamin_komisja
BEFORE INSERT OR UPDATE ON egzaminy
FOR EACH ROW
DECLARE
    v_id1 NUMBER;
    v_id2 NUMBER;
BEGIN
    SELECT DEREF(:NEW.ref_komisja1).id_nauczyciela INTO v_id1 FROM dual;
    SELECT DEREF(:NEW.ref_komisja2).id_nauczyciela INTO v_id2 FROM dual;

    IF v_id1 = v_id2 THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Komisja egzaminacyjna musi skladac sie z 2 ROZNYCH nauczycieli. ' ||
            'Podano tego samego nauczyciela (ID=' || v_id1 || ').');
    END IF;
END;
/

-- ============================================================================
-- TRIGGER: TRG_LEKCJA_GODZINA
-- Weryfikuje minimalna godzine lekcji wg typu ucznia:
--   'uczacy_sie_w_innej_szkole' -> min 15:00
--   'ukonczyl_edukacje'/'tylko_muzyczna' -> min 14:00
-- ============================================================================

PROMPT [3/7] Tworzenie trg_lekcja_godzina (BEFORE STATEMENT)...

CREATE OR REPLACE TRIGGER trg_lekcja_godzina_bs
BEFORE INSERT OR UPDATE ON lekcje
BEGIN
    pkg_trigger_ctx.clear_lekcje;
END;
/

PROMPT [4/7] Tworzenie trg_lekcja_godzina (AFTER ROW)...

CREATE OR REPLACE TRIGGER trg_lekcja_godzina_ar
AFTER INSERT OR UPDATE ON lekcje
FOR EACH ROW
BEGIN
    IF :NEW.ref_uczen IS NOT NULL THEN
        pkg_trigger_ctx.add_lekcja(:NEW.id_lekcji);
    END IF;
END;
/

PROMPT [5/7] Tworzenie trg_lekcja_godzina (AFTER STATEMENT)...

CREATE OR REPLACE TRIGGER trg_lekcja_godzina_as
AFTER INSERT OR UPDATE ON lekcje
DECLARE
    v_id           NUMBER;
    v_typ          VARCHAR2(30);
    v_godzina      VARCHAR2(5);
    v_godz_num     NUMBER;
    v_min_godzina  NUMBER;
BEGIN
    FOR i IN 1..pkg_trigger_ctx.g_lekcje_count LOOP
        v_id := pkg_trigger_ctx.g_lekcje_ids(i);

        SELECT DEREF(l.ref_uczen).typ_ucznia, l.godzina_start
        INTO v_typ, v_godzina
        FROM lekcje l
        WHERE l.id_lekcji = v_id;

        v_godz_num := TO_NUMBER(SUBSTR(v_godzina, 1, 2));

        IF v_typ = 'uczacy_sie_w_innej_szkole' THEN
            v_min_godzina := 15;
        ELSE
            v_min_godzina := 14;
        END IF;

        IF v_godz_num < v_min_godzina THEN
            RAISE_APPLICATION_ERROR(-20002,
                'Lekcja ID=' || v_id || ': uczen typu "' || v_typ ||
                '" moze miec lekcje najwczesniej o ' || v_min_godzina || ':00. ' ||
                'Podano: ' || v_godzina);
        END IF;
    END LOOP;
END;
/

-- ============================================================================
-- TRIGGER: TRG_EGZAMIN_GODZINA
-- Weryfikuje minimalna godzine egzaminu (analogicznie do lekcji)
-- ============================================================================

PROMPT [6/7] Tworzenie trg_egzamin_godzina (compound trigger)...

CREATE OR REPLACE TRIGGER trg_egzamin_godzina
FOR INSERT OR UPDATE ON egzaminy
COMPOUND TRIGGER

    TYPE t_rec IS RECORD (
        id_egzaminu NUMBER,
        id_ucznia   NUMBER,
        godzina     VARCHAR2(5)
    );
    TYPE t_tab IS TABLE OF t_rec INDEX BY PLS_INTEGER;
    g_data t_tab;
    g_cnt  PLS_INTEGER := 0;

BEFORE STATEMENT IS
BEGIN
    g_data.DELETE;
    g_cnt := 0;
END BEFORE STATEMENT;

AFTER EACH ROW IS
    v_id_ucznia NUMBER;
BEGIN
    SELECT DEREF(:NEW.ref_uczen).id_ucznia INTO v_id_ucznia FROM dual;
    g_cnt := g_cnt + 1;
    g_data(g_cnt).id_egzaminu := :NEW.id_egzaminu;
    g_data(g_cnt).id_ucznia := v_id_ucznia;
    g_data(g_cnt).godzina := :NEW.godzina;
END AFTER EACH ROW;

AFTER STATEMENT IS
    v_typ        VARCHAR2(30);
    v_godz_num   NUMBER;
    v_min_godz   NUMBER;
BEGIN
    FOR i IN 1..g_cnt LOOP
        SELECT typ_ucznia INTO v_typ
        FROM uczniowie
        WHERE id_ucznia = g_data(i).id_ucznia;

        v_godz_num := TO_NUMBER(SUBSTR(g_data(i).godzina, 1, 2));

        IF v_typ = 'uczacy_sie_w_innej_szkole' THEN
            v_min_godz := 15;
        ELSE
            v_min_godz := 14;
        END IF;

        IF v_godz_num < v_min_godz THEN
            RAISE_APPLICATION_ERROR(-20003,
                'Egzamin ID=' || g_data(i).id_egzaminu ||
                ': uczen typu "' || v_typ ||
                '" moze miec egzamin najwczesniej o ' || v_min_godz || ':00. ' ||
                'Podano: ' || g_data(i).godzina);
        END IF;
    END LOOP;
END AFTER STATEMENT;

END trg_egzamin_godzina;
/

-- ============================================================================
-- TRIGGER: TRG_UCZEN_KLASA_LIMIT
-- Sprawdza czy klasa ucznia nie przekracza cyklu nauczania (4 lub 6)
-- ============================================================================

PROMPT [7/7] Tworzenie trg_uczen_klasa_limit...

CREATE OR REPLACE TRIGGER trg_uczen_klasa_limit
BEFORE INSERT OR UPDATE ON uczniowie
FOR EACH ROW
BEGIN
    IF :NEW.klasa > :NEW.cykl_nauczania THEN
        RAISE_APPLICATION_ERROR(-20004,
            'Klasa (' || :NEW.klasa || ') nie moze przekraczac cyklu nauczania (' ||
            :NEW.cykl_nauczania || ' lat).');
    END IF;
END;
/

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================

PROMPT
PROMPT ========================================================================
PROMPT   UTWORZONE TRIGGERY
PROMPT ========================================================================
PROMPT   pkg_trigger_ctx - pakiet kontekstu (anty ORA-04091)
PROMPT   trg_egzamin_komisja - komisja to 2 roznych nauczycieli
PROMPT   trg_lekcja_godzina_* - min godzina wg typu ucznia (15:00/14:00)
PROMPT   trg_egzamin_godzina - min godzina egzaminu wg typu ucznia
PROMPT   trg_uczen_klasa_limit - klasa <= cykl_nauczania
PROMPT ========================================================================
PROMPT   Nastepny krok: Uruchom 04_pakiety.sql
PROMPT ========================================================================

SELECT trigger_name, triggering_event, status
FROM user_triggers
ORDER BY trigger_name;
