-- ============================================================================
-- Projekt: Szkola Muzyczna - Obiektowa Baza Danych
-- Plik: 04_triggery.sql
-- Opis: Triggery walidujace reguly biznesowe
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- ============================================================================
-- 1. USUNIECIE ISTNIEJACYCH TRIGGEROW
-- ============================================================================

BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_komisja_rozni'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_lekcja_xor'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_ocena_zakres'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_godziny_pracy'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_sala_wyposazenie'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_dzien_tygodnia'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_przedmiot_instrument_ucznia'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_nauczyciel_uczy_instrumentu'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_limit_uczniow_w_grupie'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_chor_orkiestra_instrument'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ============================================================================
-- 2. TRIGGER: Komisja egzaminacyjna musi skladac sie z 2 ROZNYCH nauczycieli
-- (Zalozenie 47-48)
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_komisja_rozni
BEFORE INSERT OR UPDATE ON LEKCJE
FOR EACH ROW
WHEN (NEW.typ_lekcji = 'egzamin')
DECLARE
    v_id1 NUMBER;
    v_id2 NUMBER;
BEGIN
    -- Sprawdz czy komisja jest wypelniona dla egzaminu
    IF :NEW.komisja IS NULL OR :NEW.komisja.COUNT < 2 THEN
        RAISE_APPLICATION_ERROR(-20101, 
            'Egzamin wymaga komisji skladajacej sie z 2 nauczycieli');
    END IF;

    v_id1 := :NEW.komisja(1);
    v_id2 := :NEW.komisja(2);

    -- Sprawdz czy to rozni nauczyciele
    IF v_id1 = v_id2 THEN
        RAISE_APPLICATION_ERROR(-20102, 
            'Komisja egzaminacyjna musi skladac sie z 2 ROZNYCH nauczycieli');
    END IF;

    -- Sprawdz czy nauczyciele istnieja
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM NAUCZYCIELE 
        WHERE id_nauczyciela IN (v_id1, v_id2);

        IF v_count < 2 THEN
            RAISE_APPLICATION_ERROR(-20103, 
                'Jeden lub obaj nauczyciele z komisji nie istnieja');
        END IF;
    END;
END;
/

-- ============================================================================
-- 3. TRIGGER: Lekcja musi byc ALBO indywidualna ALBO grupowa (XOR)
-- (Zalozenie 36) - dodatkowa walidacja poza CHECK constraint
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_lekcja_xor
BEFORE INSERT OR UPDATE ON LEKCJE
FOR EACH ROW
BEGIN
    -- Sprawdz regule XOR: uczen XOR grupa
    IF :NEW.ref_uczen IS NOT NULL AND :NEW.ref_grupa IS NOT NULL THEN
        RAISE_APPLICATION_ERROR(-20104, 
            'Lekcja nie moze byc jednoczesnie indywidualna i grupowa');
    END IF;

    IF :NEW.ref_uczen IS NULL AND :NEW.ref_grupa IS NULL THEN
        RAISE_APPLICATION_ERROR(-20105, 
            'Lekcja musi miec przypisanego ucznia (indywidualna) lub grupe (grupowa)');
    END IF;
END;
/

-- ============================================================================
-- 4. TRIGGER: Ocena musi byc w zakresie 1-6
-- (Zalozenie 52) - dodatkowa walidacja poza CHECK constraint
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_ocena_zakres
BEFORE INSERT OR UPDATE ON OCENY
FOR EACH ROW
BEGIN
    IF :NEW.wartosc NOT BETWEEN 1 AND 6 THEN
        RAISE_APPLICATION_ERROR(-20106, 
            'Ocena musi byc w zakresie 1-6 (polska skala)');
    END IF;
END;
/

-- ============================================================================
-- 5. TRIGGER: Godziny pracy szkoly (14:00 - 20:00)
-- (Zalozenie 6) - POPRAWIONA LOGIKA
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_godziny_pracy
BEFORE INSERT OR UPDATE ON LEKCJE
FOR EACH ROW
DECLARE
    v_start_min NUMBER;
    v_koniec_min NUMBER;
BEGIN
    -- Sprawdz format godziny (HH:MI) - najpierw walidacja formatu
    IF NOT REGEXP_LIKE(:NEW.godzina_start, '^[0-2][0-9]:[0-5][0-9]$') THEN
        RAISE_APPLICATION_ERROR(-20109, 
            'Nieprawidlowy format godziny. Uzyj HH:MI (np. 14:30)');
    END IF;

    -- Oblicz minuty od polnocy dla startu i konca
    v_start_min := TO_NUMBER(SUBSTR(:NEW.godzina_start, 1, 2)) * 60 + 
                   TO_NUMBER(SUBSTR(:NEW.godzina_start, 4, 2));
    v_koniec_min := v_start_min + :NEW.czas_trwania_min;

    -- Sprawdz czy w godzinach pracy (14:00 - 20:00)
    -- 14:00 = 840 minut, 20:00 = 1200 minut
    IF v_start_min < 840 THEN  -- przed 14:00
        RAISE_APPLICATION_ERROR(-20107, 
            'Lekcje nie moga zaczynac sie przed 14:00');
    END IF;

    IF v_koniec_min > 1200 THEN  -- po 20:00
        RAISE_APPLICATION_ERROR(-20108, 
            'Lekcje nie moga konczyc sie po 20:00 (lekcja konczy sie o ' || 
            LPAD(TRUNC(v_koniec_min/60), 2, '0') || ':' || LPAD(MOD(v_koniec_min, 60), 2, '0') || ')');
    END IF;
END;
/

-- ============================================================================
-- 6. TRIGGER: Sprawdzenie wyposazenia sali dla przedmiotu
-- (Zalozenie 32)
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_sala_wyposazenie
BEFORE INSERT OR UPDATE ON LEKCJE
FOR EACH ROW
DECLARE
    v_wymagane     T_WYPOSAZENIE;
    v_wyposazenie  T_WYPOSAZENIE;
    v_sala_typ     VARCHAR2(20);
    v_przedmiot_typ VARCHAR2(20);
    v_znaleziono   BOOLEAN;
BEGIN
    -- Pobierz wymagane wyposazenie przedmiotu
    SELECT p.wymagane_wyposazenie, p.typ_zajec 
    INTO v_wymagane, v_przedmiot_typ
    FROM PRZEDMIOTY p
    WHERE REF(p) = :NEW.ref_przedmiot;

    -- Pobierz wyposazenie sali i typ
    SELECT s.wyposazenie, s.typ 
    INTO v_wyposazenie, v_sala_typ
    FROM SALE s
    WHERE REF(s) = :NEW.ref_sala;

    -- Sprawdz zgodnosc typu sali z typem zajec
    IF v_przedmiot_typ = 'grupowy' AND v_sala_typ = 'indywidualna' THEN
        RAISE_APPLICATION_ERROR(-20110, 
            'Zajecia grupowe wymagaja sali grupowej');
    END IF;

    -- Jesli przedmiot wymaga wyposazenia, sprawdz czy sala je ma
    IF v_wymagane IS NOT NULL AND v_wymagane.COUNT > 0 THEN
        IF v_wyposazenie IS NULL THEN
            RAISE_APPLICATION_ERROR(-20111, 
                'Sala nie ma wymaganego wyposazenia dla tego przedmiotu');
        END IF;

        -- Sprawdz kazdy wymagany element
        FOR i IN 1..v_wymagane.COUNT LOOP
            v_znaleziono := FALSE;
            FOR j IN 1..v_wyposazenie.COUNT LOOP
                IF UPPER(v_wyposazenie(j)) = UPPER(v_wymagane(i)) THEN
                    v_znaleziono := TRUE;
                    EXIT;
                END IF;
            END LOOP;

            IF NOT v_znaleziono THEN
                RAISE_APPLICATION_ERROR(-20112, 
                    'Sala nie posiada wymaganego wyposazenia: ' || v_wymagane(i));
            END IF;
        END LOOP;
    END IF;
END;
/

-- ============================================================================
-- 7. TRIGGER: Dzien tygodnia (pon-pt)
-- (Zalozenie 5)
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_dzien_tygodnia
BEFORE INSERT OR UPDATE ON LEKCJE
FOR EACH ROW
DECLARE
    v_dzien VARCHAR2(10);
BEGIN
    -- Pobierz dzien tygodnia (1=poniedzialek, 7=niedziela w formatce ISO)
    v_dzien := TO_CHAR(:NEW.data_lekcji, 'D');

    -- W ustawieniach polskich: 1=pon, 6=sob, 7=niedz
    -- Bezpieczniej uzyc nazwy dnia
    v_dzien := TRIM(TO_CHAR(:NEW.data_lekcji, 'DAY', 'NLS_DATE_LANGUAGE=ENGLISH'));

    IF v_dzien IN ('SATURDAY', 'SUNDAY') THEN
        RAISE_APPLICATION_ERROR(-20113, 
            'Lekcje odbywaja sie tylko w dni robocze (pon-pt)');
    END IF;
END;
/

-- ============================================================================
-- 8. TRIGGER: Przedmiot lekcji indywidualnej musi odpowiadac instrumentowi ucznia
-- (Zalozenie - logika biznesowa: uczen fortepianu nie moze miec lekcji skrzypiec)
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_przedmiot_instrument_ucznia
BEFORE INSERT OR UPDATE ON LEKCJE
FOR EACH ROW
WHEN (NEW.ref_uczen IS NOT NULL)  -- tylko dla lekcji indywidualnych
DECLARE
    v_instrument_ucznia VARCHAR2(50);
    v_przedmiot_nazwa   VARCHAR2(100);
    v_przedmiot_typ     VARCHAR2(20);
BEGIN
    -- Pobierz instrument ucznia
    SELECT DEREF(:NEW.ref_uczen).ref_instrument INTO v_instrument_ucznia FROM DUAL;
    SELECT DEREF(v_instrument_ucznia).nazwa INTO v_instrument_ucznia FROM DUAL;
    
    -- Pobierz nazwe i typ przedmiotu
    SELECT p.nazwa, p.typ_zajec INTO v_przedmiot_nazwa, v_przedmiot_typ
    FROM PRZEDMIOTY p
    WHERE REF(p) = :NEW.ref_przedmiot;
    
    -- Dla przedmiotow indywidualnych (instrumentow) sprawdz zgodnosc
    IF v_przedmiot_typ = 'indywidualny' THEN
        IF UPPER(v_przedmiot_nazwa) != UPPER(v_instrument_ucznia) THEN
            RAISE_APPLICATION_ERROR(-20114, 
                'Uczen gra na instrumencie: ' || v_instrument_ucznia || 
                ', nie moze miec lekcji: ' || v_przedmiot_nazwa);
        END IF;
    END IF;
END;
/

-- ============================================================================
-- 9. TRIGGER: Nauczyciel musi uczyc danego instrumentu
-- (Zalozenie 19-20 - nauczyciel ma liste instrumentow w VARRAY)
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_nauczyciel_uczy_instrumentu
BEFORE INSERT OR UPDATE ON LEKCJE
FOR EACH ROW
DECLARE
    v_przedmiot_nazwa   VARCHAR2(100);
    v_przedmiot_typ     VARCHAR2(20);
    v_instrumenty       T_INSTRUMENTY_TAB;
    v_uczy              BOOLEAN := FALSE;
BEGIN
    -- Pobierz nazwe i typ przedmiotu
    SELECT p.nazwa, p.typ_zajec INTO v_przedmiot_nazwa, v_przedmiot_typ
    FROM PRZEDMIOTY p
    WHERE REF(p) = :NEW.ref_przedmiot;
    
    -- Sprawdzamy tylko dla przedmiotow indywidualnych (instrumentow)
    IF v_przedmiot_typ = 'indywidualny' THEN
        -- Pobierz instrumenty nauczyciela
        SELECT n.instrumenty INTO v_instrumenty
        FROM NAUCZYCIELE n
        WHERE REF(n) = :NEW.ref_nauczyciel;
        
        -- Sprawdz czy nauczyciel uczy tego instrumentu
        IF v_instrumenty IS NOT NULL THEN
            FOR i IN 1..v_instrumenty.COUNT LOOP
                IF UPPER(v_instrumenty(i)) = UPPER(v_przedmiot_nazwa) THEN
                    v_uczy := TRUE;
                    EXIT;
                END IF;
            END LOOP;
        END IF;
        
        IF NOT v_uczy THEN
            RAISE_APPLICATION_ERROR(-20115, 
                'Nauczyciel nie uczy instrumentu: ' || v_przedmiot_nazwa || 
                '. Przypisz nauczyciela od tego instrumentu.');
        END IF;
    END IF;
    -- Dla przedmiotow grupowych nie sprawdzamy (nauczyciele przedmiotow grupowych 
    -- maja instrumenty = NULL, ale prowadza ksztalcenie sluchu, rytmike itd.)
END;
/

-- ============================================================================
-- 10. TRIGGER: Limit uczniow w grupie (6-15 uczniow)
-- (Zalozenie 15)
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_limit_uczniow_w_grupie
BEFORE INSERT ON UCZNIOWIE
FOR EACH ROW
DECLARE
    v_liczba_uczniow NUMBER;
    v_kod_grupy      VARCHAR2(10);
    v_max_uczniow    CONSTANT NUMBER := 15;
BEGIN
    -- Pobierz kod grupy
    SELECT g.kod INTO v_kod_grupy
    FROM GRUPY g
    WHERE REF(g) = :NEW.ref_grupa;
    
    -- Policz obecnych uczniow w grupie
    SELECT COUNT(*) INTO v_liczba_uczniow
    FROM UCZNIOWIE u
    WHERE DEREF(u.ref_grupa).kod = v_kod_grupy;
    
    -- Sprawdz limit
    IF v_liczba_uczniow >= v_max_uczniow THEN
        RAISE_APPLICATION_ERROR(-20116, 
            'Grupa ' || v_kod_grupy || ' osiagnela maksymalny limit ' || 
            v_max_uczniow || ' uczniow. Utworz nowa grupe (np. ' || 
            SUBSTR(v_kod_grupy, 1, 1) || 'B).');
    END IF;
END;
/

-- ============================================================================
-- 11. TRIGGER: Walidacja chor/orkiestra - instrument ucznia
-- (Zalozenie: Chor = fortepian+gitara, Orkiestra = skrzypce+flet+perkusja)
-- Dotyczy tylko lekcji grupowych Chor/Orkiestra
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_chor_orkiestra_instrument
BEFORE INSERT OR UPDATE ON LEKCJE
FOR EACH ROW
WHEN (NEW.ref_grupa IS NOT NULL)  -- tylko dla lekcji grupowych
DECLARE
    v_przedmiot_nazwa   VARCHAR2(100);
    v_klasa             NUMBER;
    v_czy_orkiestra     CHAR(1);
    v_instrument_nazwa  VARCHAR2(50);
    v_id_grupy          NUMBER;
    
    CURSOR c_uczniowie_grupy IS
        SELECT u.imie, u.nazwisko, DEREF(u.ref_instrument).nazwa AS instrument,
               DEREF(u.ref_instrument).czy_orkiestra AS czy_ork
        FROM UCZNIOWIE u
        WHERE DEREF(u.ref_grupa).id_grupy = v_id_grupy;
BEGIN
    -- Pobierz nazwe przedmiotu
    SELECT p.nazwa INTO v_przedmiot_nazwa
    FROM PRZEDMIOTY p
    WHERE REF(p) = :NEW.ref_przedmiot;
    
    -- Sprawdzamy tylko dla Choru i Orkiestry
    IF v_przedmiot_nazwa NOT IN ('Chor', 'Orkiestra') THEN
        RETURN;  -- inne przedmioty grupowe nie wymagaja walidacji instrumentu
    END IF;
    
    -- Pobierz klase grupy
    SELECT g.klasa, g.id_grupy INTO v_klasa, v_id_grupy
    FROM GRUPY g
    WHERE REF(g) = :NEW.ref_grupa;
    
    -- Chor i Orkiestra tylko dla klas IV-VI
    IF v_klasa < 4 THEN
        RAISE_APPLICATION_ERROR(-20117, 
            'Chor i Orkiestra sa dostepne tylko dla klas IV-VI (aktualna klasa: ' || v_klasa || ')');
    END IF;
    
    -- Sprawdz czy wszyscy uczniowie w grupie maja odpowiedni instrument
    -- Chor: czy_orkiestra = 'N' (fortepian, gitara)
    -- Orkiestra: czy_orkiestra = 'T' (skrzypce, flet, perkusja)
    FOR uczen IN c_uczniowie_grupy LOOP
        IF v_przedmiot_nazwa = 'Chor' AND uczen.czy_ork = 'T' THEN
            -- Uczen z instrumentem orkiestrowym nie moze byc na chorze
            -- ALE: to jest walidacja na poziomie GRUPY, nie pojedynczego ucznia
            -- W praktyce: grupa 4A moze miec mieszanych uczniow, wiec Chor 
            -- powinien byc dla WYBRANYCH uczniow, nie calej grupy
            -- To jest ograniczenie modelu - zostawiamy jako ostrzezenie
            NULL; -- W pelnym systemie: osobne grupy na chor/orkiestre
        END IF;
    END LOOP;
    
    -- INFO: W tym modelu zakladamy ze cala grupa idzie na Chor LUB Orkiestre
    -- W rzeczywistosci potrzebna bylaby tabela posrednia UCZNIOWIE_PRZEDMIOTY
END;
/

-- ============================================================================
-- 12. POTWIERDZENIE
-- ============================================================================

SELECT 'Triggery utworzone pomyslnie!' AS status FROM DUAL;

-- Lista triggerow
SELECT trigger_name, table_name, status 
FROM user_triggers 
ORDER BY table_name, trigger_name;