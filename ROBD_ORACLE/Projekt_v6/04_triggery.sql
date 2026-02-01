-- ============================================================================
-- Projekt: Szkola Muzyczna - Obiektowa Baza Danych
-- Plik: 04_triggery.sql
-- Opis: Triggery walidacyjne
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- ============================================================================
-- 1. TRIGGER: komisja_rozni
-- ============================================================================
-- Egzamin musi miec komisje z 2 ROZNYCH nauczycieli.

CREATE OR REPLACE TRIGGER trg_komisja_rozni
BEFORE INSERT OR UPDATE ON LEKCJE
FOR EACH ROW
WHEN (NEW.typ_lekcji = 'egzamin')
DECLARE
BEGIN
    IF :NEW.komisja IS NULL THEN
        RAISE_APPLICATION_ERROR(-20101, 'Egzamin wymaga komisji skladajacej sie z 2 nauczycieli');
    END IF;

    IF :NEW.komisja.COUNT < 2 THEN
        RAISE_APPLICATION_ERROR(-20101, 'Komisja egzaminacyjna musi miec 2 czlonkow');
    END IF;

    IF :NEW.komisja(1) = :NEW.komisja(2) THEN
        RAISE_APPLICATION_ERROR(-20102, 'Komisja musi skladac sie z 2 ROZNYCH nauczycieli');
    END IF;
END;
/

-- ============================================================================
-- 2. TRIGGER: ocena_zakres
-- ============================================================================
-- Ocena musi byc w zakresie 1-6 (polska skala).

CREATE OR REPLACE TRIGGER trg_ocena_zakres
BEFORE INSERT OR UPDATE ON OCENY
FOR EACH ROW
DECLARE
BEGIN
    IF :NEW.wartosc < 1 OR :NEW.wartosc > 6 THEN
        RAISE_APPLICATION_ERROR(-20105,
            'Ocena musi byc w zakresie 1-6. Podano: ' || :NEW.wartosc);
    END IF;
END;
/

-- ============================================================================
-- 3. TRIGGER: godziny_pracy
-- ============================================================================
-- Lekcje tylko od 14:00 do 20:00 (szkola muzyczna = zajecia popoudniowe).

CREATE OR REPLACE TRIGGER trg_godziny_pracy
BEFORE INSERT OR UPDATE ON LEKCJE
FOR EACH ROW
DECLARE
    v_godzina NUMBER;
    v_godzina_koniec NUMBER;
BEGIN
    -- Parsuj godzine startu (format HH:MI)
    v_godzina := TO_NUMBER(SUBSTR(:NEW.godzina_start, 1, 2));
    v_godzina_koniec := v_godzina + CEIL(:NEW.czas_trwania_min / 60);

    IF v_godzina < 14 OR v_godzina >= 20 THEN
        RAISE_APPLICATION_ERROR(-20106,
            'Lekcje odbywaja sie w godzinach 14:00-20:00. Podano: ' || :NEW.godzina_start);
    END IF;

    IF v_godzina_koniec > 21 THEN
        RAISE_APPLICATION_ERROR(-20107,
            'Lekcja nie moze konczyc sie pozniej niz o 21:00. Zakonczenie: ' || v_godzina_koniec || ':00');
    END IF;
END;
/

-- ============================================================================
-- 4. TRIGGER: sala_wyposazenie
-- ============================================================================
-- Przedmioty wymagajace wyposazenia moga byc prowadzone tylko w salach
-- ktore to wyposazenie posiadaja.

CREATE OR REPLACE TRIGGER trg_sala_wyposazenie
BEFORE INSERT OR UPDATE ON LEKCJE
FOR EACH ROW
DECLARE
    v_przedmiot     T_PRZEDMIOT;
    v_sala          T_SALA;
    v_wymagane      T_WYPOSAZENIE;
    v_dostepne      T_WYPOSAZENIE;
    v_found         BOOLEAN;
BEGIN
    -- Pobierz obiekty
    SELECT DEREF(:NEW.ref_przedmiot) INTO v_przedmiot FROM DUAL;
    SELECT DEREF(:NEW.ref_sala) INTO v_sala FROM DUAL;

    v_wymagane := v_przedmiot.wymagane_wyposazenie;
    v_dostepne := v_sala.wyposazenie;

    -- Jesli przedmiot nie wymaga wyposazenia, OK
    IF v_wymagane IS NULL OR v_wymagane.COUNT = 0 THEN
        RETURN;
    END IF;

    -- Jesli sala nie ma wyposazenia, a przedmiot wymaga
    IF v_dostepne IS NULL OR v_dostepne.COUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20108,
            'Sala ' || v_sala.numer || ' nie posiada wymaganego wyposazenia dla ' || v_przedmiot.nazwa);
    END IF;

    -- Sprawdz kazdy wymagany element
    FOR i IN 1..v_wymagane.COUNT LOOP
        v_found := FALSE;
        FOR j IN 1..v_dostepne.COUNT LOOP
            IF UPPER(v_wymagane(i)) = UPPER(v_dostepne(j)) THEN
                v_found := TRUE;
                EXIT;
            END IF;
        END LOOP;

        IF NOT v_found THEN
            RAISE_APPLICATION_ERROR(-20108,
                'Sala ' || v_sala.numer || ' nie posiada wymaganego wyposazenia: ' || v_wymagane(i));
        END IF;
    END LOOP;
END;
/

-- ============================================================================
-- 5. TRIGGER: dzien_tygodnia
-- ============================================================================
-- Lekcje tylko od poniedzialku do piatku.

CREATE OR REPLACE TRIGGER trg_dzien_tygodnia
BEFORE INSERT OR UPDATE ON LEKCJE
FOR EACH ROW
DECLARE
    v_dzien VARCHAR2(20);
BEGIN
    v_dzien := TO_CHAR(:NEW.data_lekcji, 'D', 'NLS_TERRITORY=POLAND');

    -- 6 = sobota, 7 = niedziela (w polskich ustawieniach)
    IF v_dzien IN ('6', '7') THEN
        RAISE_APPLICATION_ERROR(-20109,
            'Lekcje odbywaja sie od poniedzialku do piatku. Podano: ' ||
            TO_CHAR(:NEW.data_lekcji, 'DAY', 'NLS_DATE_LANGUAGE=POLISH'));
    END IF;
END;
/

-- ============================================================================
-- 6. TRIGGER: przedmiot_instrument_ucznia
-- ============================================================================
-- Lekcja indywidualna z przedmiotu instrumentalnego musi byc z instrumentu ucznia.

CREATE OR REPLACE TRIGGER trg_przedmiot_instrument_ucznia
BEFORE INSERT OR UPDATE ON LEKCJE
FOR EACH ROW
WHEN (NEW.ref_uczen IS NOT NULL)
DECLARE
    v_przedmiot      T_PRZEDMIOT;
    v_uczen          T_UCZEN;
    v_instrument_ucz VARCHAR2(50);
    v_przedmiot_nazwa VARCHAR2(50);
BEGIN
    SELECT DEREF(:NEW.ref_przedmiot) INTO v_przedmiot FROM DUAL;
    SELECT DEREF(:NEW.ref_uczen) INTO v_uczen FROM DUAL;

    -- Sprawdz tylko dla przedmiotow indywidualnych (instrumentalnych)
    IF v_przedmiot.typ_zajec != 'indywidualne' THEN
        RETURN;
    END IF;

    -- Pobierz nazwe instrumentu ucznia
    SELECT DEREF(v_uczen.ref_instrument).nazwa INTO v_instrument_ucz FROM DUAL;

    -- Jesli przedmiot to nazwa instrumentu, sprawdz zgodnosc
    v_przedmiot_nazwa := v_przedmiot.nazwa;

    IF UPPER(v_przedmiot_nazwa) != UPPER(v_instrument_ucz) THEN
        RAISE_APPLICATION_ERROR(-20110,
            'Uczen ' || v_uczen.imie || ' ' || v_uczen.nazwisko ||
            ' gra na instrumencie ' || v_instrument_ucz ||
            ', nie moze miec lekcji z ' || v_przedmiot_nazwa);
    END IF;
END;
/

-- ============================================================================
-- 7. TRIGGER: nauczyciel_uczy_instrumentu
-- ============================================================================
-- Nauczyciel moze prowadzic lekcje tylko z instrumentow, ktore sa na jego liscie.
-- (Dotyczy tylko lekcji indywidualnych)

CREATE OR REPLACE TRIGGER trg_nauczyciel_uczy_instrumentu
BEFORE INSERT OR UPDATE ON LEKCJE
FOR EACH ROW
WHEN (NEW.ref_uczen IS NOT NULL)
DECLARE
    v_przedmiot      T_PRZEDMIOT;
    v_nauczyciel     T_NAUCZYCIEL;
    v_found          BOOLEAN := FALSE;
BEGIN
    SELECT DEREF(:NEW.ref_przedmiot) INTO v_przedmiot FROM DUAL;
    SELECT DEREF(:NEW.ref_nauczyciel) INTO v_nauczyciel FROM DUAL;

    -- Sprawdz tylko dla przedmiotow indywidualnych
    IF v_przedmiot.typ_zajec != 'indywidualne' THEN
        RETURN;
    END IF;

    -- Jesli nauczyciel nie ma listy instrumentow, blad
    IF v_nauczyciel.instrumenty IS NULL OR v_nauczyciel.instrumenty.COUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20111,
            'Nauczyciel ' || v_nauczyciel.nazwisko ||
            ' nie ma przypisanych instrumentow, nie moze prowadzic lekcji indywidualnych');
    END IF;

    -- Sprawdz czy przedmiot (instrument) jest na liscie nauczyciela
    FOR i IN 1..v_nauczyciel.instrumenty.COUNT LOOP
        IF UPPER(v_nauczyciel.instrumenty(i)) = UPPER(v_przedmiot.nazwa) THEN
            v_found := TRUE;
            EXIT;
        END IF;
    END LOOP;

    IF NOT v_found THEN
        RAISE_APPLICATION_ERROR(-20111,
            'Nauczyciel ' || v_nauczyciel.nazwisko ||
            ' nie uczy ' || v_przedmiot.nazwa ||
            '. Jego instrumenty: ' ||
            (SELECT LISTAGG(COLUMN_VALUE, ', ') WITHIN GROUP (ORDER BY COLUMN_VALUE)
             FROM TABLE(v_nauczyciel.instrumenty)));
    END IF;
END;
/

-- ============================================================================
-- 8. TRIGGER: chor_orkiestra_walidacja
-- ============================================================================
-- Grupa musi miec uczniow grajacych na odpowiednich instrumentach
-- dla przedmiotow "Chor" i "Orkiestra".
CREATE OR REPLACE TRIGGER trg_chor_orkiestra_walidacja
BEFORE INSERT OR UPDATE ON LEKCJE
FOR EACH ROW
WHEN (NEW.ref_grupa IS NOT NULL)
DECLARE
    v_przedmiot      T_PRZEDMIOT;
    v_kod_grupy      VARCHAR2(10);
    v_czy_chor       BOOLEAN := FALSE;
    v_czy_orkiestra  BOOLEAN := FALSE;
    v_count_pasujacych NUMBER := 0;
BEGIN
    SELECT DEREF(:NEW.ref_przedmiot) INTO v_przedmiot FROM DUAL;
    SELECT DEREF(:NEW.ref_grupa).kod INTO v_kod_grupy FROM DUAL;

    v_czy_chor := UPPER(v_przedmiot.nazwa) = 'CHOR';
    v_czy_orkiestra := UPPER(v_przedmiot.nazwa) = 'ORKIESTRA';

    -- Sprawdz tylko dla choru lub orkiestry
    IF NOT v_czy_chor AND NOT v_czy_orkiestra THEN
        RETURN;
    END IF;

    -- Policz uczniow w grupie pasujacych do przedmiotu
    IF v_czy_chor THEN
        -- Chor: instrumenty nieorkiestrowe (fortepian, gitara)
        SELECT COUNT(*) INTO v_count_pasujacych
        FROM UCZNIOWIE u
        WHERE UPPER(DEREF(u.ref_grupa).kod) = UPPER(v_kod_grupy)
          AND NVL(DEREF(u.ref_instrument).czy_orkiestra, 'N') = 'N';

        IF v_count_pasujacych = 0 THEN
            RAISE_APPLICATION_ERROR(-20117,
                'Grupa ' || v_kod_grupy || ' nie ma uczniow grajacych na instrumentach ' ||
                'nieorkiestrowych (fortepian, gitara). Nie mozna utworzyc Choru.');
        END IF;
    END IF;

    IF v_czy_orkiestra THEN
        -- Orkiestra: instrumenty orkiestrowe (skrzypce, flet, perkusja)
        SELECT COUNT(*) INTO v_count_pasujacych
        FROM UCZNIOWIE u
        WHERE UPPER(DEREF(u.ref_grupa).kod) = UPPER(v_kod_grupy)
          AND DEREF(u.ref_instrument).czy_orkiestra = 'T';

        IF v_count_pasujacych = 0 THEN
            RAISE_APPLICATION_ERROR(-20118,
                'Grupa ' || v_kod_grupy || ' nie ma uczniow grajacych na instrumentach ' ||
                'orkiestrowych (skrzypce, flet, perkusja). Nie mozna utworzyc Orkiestry.');
        END IF;
    END IF;
END;
/

-- ============================================================================
-- 9. TRIGGER: auto_status_lekcji
-- ============================================================================
-- Automatyczna zmiana statusu lekcji na 'odbyta' po dacie.
-- (opcjonalny - do uruchomienia przez job scheduler)

CREATE OR REPLACE TRIGGER trg_auto_status_lekcji
BEFORE UPDATE ON LEKCJE
FOR EACH ROW
DECLARE
BEGIN
    -- Automatycznie zmien status na 'odbyta' jesli data minela i status byl 'zaplanowana'
    IF :NEW.data_lekcji < TRUNC(SYSDATE) AND :OLD.status = 'zaplanowana' THEN
        :NEW.status := 'odbyta';
    END IF;
END;
/

-- ============================================================================
-- 10. TRIGGER: limit_uczniow_w_grupie
-- ============================================================================
-- Max 15 uczniow w grupie (zgodnie z zalozeniem 15).

CREATE OR REPLACE TRIGGER trg_limit_uczniow_w_grupie
BEFORE INSERT OR UPDATE ON UCZNIOWIE
FOR EACH ROW
DECLARE
    v_liczba_uczniow NUMBER;
    v_kod_grupy VARCHAR2(10);
    v_max_uczniow CONSTANT NUMBER := 15;
BEGIN
    -- Pobierz kod grupy
    SELECT DEREF(:NEW.ref_grupa).kod INTO v_kod_grupy FROM DUAL;

    -- Policz uczniow w grupie (bez obecnego ucznia jesli UPDATE)
    SELECT COUNT(*) INTO v_liczba_uczniow
    FROM UCZNIOWIE u
    WHERE DEREF(u.ref_grupa).kod = v_kod_grupy
      AND (:NEW.id_ucznia IS NULL OR u.id_ucznia != :NEW.id_ucznia);

    -- Sprawdz limit
    IF v_liczba_uczniow >= v_max_uczniow THEN
        RAISE_APPLICATION_ERROR(-20116,
            'Grupa ' || v_kod_grupy || ' osiagnela maksymalny limit ' ||
            v_max_uczniow || ' uczniow. Utworz nowa grupe.');
    END IF;
END;
/

-- ============================================================================
-- 11. TRIGGER: max_godzin_nauczyciela
-- ============================================================================
-- Nauczyciel nie moze przekroczyc limitu godzin dziennie (6h) i tygodniowo (30h).

CREATE OR REPLACE TRIGGER trg_max_godzin_nauczyciela
BEFORE INSERT OR UPDATE ON LEKCJE
FOR EACH ROW
DECLARE
    v_nauczyciel T_NAUCZYCIEL;
    v_godziny_dzis NUMBER;
    v_godziny_tydzien NUMBER;
    v_max_dzien NUMBER;
    v_max_tydzien NUMBER;
    v_poczatek_tyg DATE;
    v_koniec_tyg DATE;
BEGIN
    -- Pobierz dane nauczyciela
    SELECT DEREF(:NEW.ref_nauczyciel) INTO v_nauczyciel FROM DUAL;
    v_max_dzien := NVL(v_nauczyciel.max_godzin_dziennie, 6) * 60;    -- minuty
    v_max_tydzien := NVL(v_nauczyciel.max_godzin_tydzien, 30) * 60;  -- minuty

    -- Poczatek i koniec tygodnia (pon-pt)
    v_poczatek_tyg := TRUNC(:NEW.data_lekcji, 'IW');
    v_koniec_tyg := v_poczatek_tyg + 4;

    -- Policz godziny w danym dniu (pomijajac obecna lekcje jesli UPDATE)
    SELECT NVL(SUM(l.czas_trwania_min), 0) INTO v_godziny_dzis
    FROM LEKCJE l
    WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = v_nauczyciel.id_nauczyciela
      AND l.data_lekcji = :NEW.data_lekcji
      AND l.status != 'odwolana'
      AND (:NEW.id_lekcji IS NULL OR l.id_lekcji != :NEW.id_lekcji);

    -- Policz godziny w calym tygodniu (pomijajac obecna lekcje jesli UPDATE)
    SELECT NVL(SUM(l.czas_trwania_min), 0) INTO v_godziny_tydzien
    FROM LEKCJE l
    WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = v_nauczyciel.id_nauczyciela
      AND l.data_lekcji BETWEEN v_poczatek_tyg AND v_koniec_tyg
      AND l.status != 'odwolana'
      AND (:NEW.id_lekcji IS NULL OR l.id_lekcji != :NEW.id_lekcji);

    -- Sprawdz limit dzienny
    IF (v_godziny_dzis + :NEW.czas_trwania_min) > v_max_dzien THEN
        RAISE_APPLICATION_ERROR(-20119,
            'Nauczyciel ' || v_nauczyciel.nazwisko ||
            ' przekroczyl limit ' || (v_max_dzien / 60) || ' godzin dziennie. ' ||
            'Ma juz ' || ROUND(v_godziny_dzis / 60, 1) || 'h zaplanowanych.');
    END IF;

    -- Sprawdz limit tygodniowy
    IF (v_godziny_tydzien + :NEW.czas_trwania_min) > v_max_tydzien THEN
        RAISE_APPLICATION_ERROR(-20120,
            'Nauczyciel ' || v_nauczyciel.nazwisko ||
            ' przekroczyl limit ' || (v_max_tydzien / 60) || ' godzin tygodniowo. ' ||
            'Ma juz ' || ROUND(v_godziny_tydzien / 60, 1) || 'h zaplanowanych.');
    END IF;
END;
/

-- ============================================================================
-- 12. POTWIERDZENIE
-- ============================================================================

SELECT 'Triggery utworzone pomyslnie!' AS status FROM DUAL;

SELECT trigger_name, status FROM user_triggers ORDER BY trigger_name;
