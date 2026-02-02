-- ============================================================================
-- SZKOŁA MUZYCZNA I STOPNIA - PAKIETY PL/SQL (UPROSZCZONE)
-- Autorzy: Igor Typiński (251237), Mateusz Mróz (251190)
-- ============================================================================

-- ============================================================================
-- PKG_SLOWNIKI - zarządzanie słownikami (przedmioty, grupy, sale)
-- ============================================================================
CREATE OR REPLACE PACKAGE pkg_slowniki AS
    -- Dodawanie
    PROCEDURE dodaj_przedmiot(p_nazwa VARCHAR2, p_typ VARCHAR2);
    PROCEDURE dodaj_grupe(p_symbol VARCHAR2, p_poziom NUMBER);
    PROCEDURE dodaj_sale(p_numer VARCHAR2, p_typ VARCHAR2, p_pojemnosc NUMBER, p_wyposazenie t_wyposazenie);

    -- Pobieranie referencji
    FUNCTION get_ref_przedmiot(p_id NUMBER) RETURN REF t_przedmiot;
    FUNCTION get_ref_grupa(p_id NUMBER) RETURN REF t_grupa;
    FUNCTION get_ref_sala(p_id NUMBER) RETURN REF t_sala;

    -- Listy
    PROCEDURE lista_przedmiotow;
    PROCEDURE lista_sal;
    PROCEDURE lista_grup;
END pkg_slowniki;
/

CREATE OR REPLACE PACKAGE BODY pkg_slowniki AS

    -- Dodaj przedmiot
    PROCEDURE dodaj_przedmiot(p_nazwa VARCHAR2, p_typ VARCHAR2) IS
    BEGIN
        INSERT INTO przedmioty VALUES (
            t_przedmiot(seq_przedmioty.NEXTVAL, p_nazwa, p_typ, 45)
        );
        DBMS_OUTPUT.PUT_LINE('Dodano przedmiot: ' || p_nazwa || ' (' || p_typ || ')');
    END;

    -- Dodaj grupę
    PROCEDURE dodaj_grupe(p_symbol VARCHAR2, p_poziom NUMBER) IS
    BEGIN
        INSERT INTO grupy VALUES (
            t_grupa(seq_grupy.NEXTVAL, p_symbol, p_poziom)
        );
        DBMS_OUTPUT.PUT_LINE('Dodano grupę: ' || p_symbol || ' (klasa ' || p_poziom || ')');
    END;

    -- Dodaj salę
    PROCEDURE dodaj_sale(p_numer VARCHAR2, p_typ VARCHAR2, p_pojemnosc NUMBER, p_wyposazenie t_wyposazenie) IS
    BEGIN
        INSERT INTO sale VALUES (
            t_sala(seq_sale.NEXTVAL, p_numer, p_typ, p_pojemnosc, p_wyposazenie)
        );
        DBMS_OUTPUT.PUT_LINE('Dodano salę: ' || p_numer || ' (' || p_typ || ')');
    END;

    -- Zwraca REF do przedmiotu o podanym ID
    FUNCTION get_ref_przedmiot(p_id NUMBER) RETURN REF t_przedmiot IS
        v_ref REF t_przedmiot;
    BEGIN
        SELECT REF(p) INTO v_ref FROM przedmioty p WHERE p.id = p_id;
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20010, 'Przedmiot ID=' || p_id || ' nie istnieje');
    END;

    -- Zwraca REF do grupy o podanym ID
    FUNCTION get_ref_grupa(p_id NUMBER) RETURN REF t_grupa IS
        v_ref REF t_grupa;
    BEGIN
        SELECT REF(g) INTO v_ref FROM grupy g WHERE g.id = p_id;
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20011, 'Grupa ID=' || p_id || ' nie istnieje');
    END;

    -- Zwraca REF do sali o podanym ID
    FUNCTION get_ref_sala(p_id NUMBER) RETURN REF t_sala IS
        v_ref REF t_sala;
    BEGIN
        SELECT REF(s) INTO v_ref FROM sale s WHERE s.id = p_id;
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20012, 'Sala ID=' || p_id || ' nie istnieje');
    END;

    -- Lista przedmiotów
    PROCEDURE lista_przedmiotow IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== PRZEDMIOTY ===');
        FOR r IN (SELECT p.id, p.nazwa, p.typ FROM przedmioty p ORDER BY p.id) LOOP
            DBMS_OUTPUT.PUT_LINE(r.id || '. ' || r.nazwa || ' (' || r.typ || ')');
        END LOOP;
    END;

    -- Lista sal
    PROCEDURE lista_sal IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== SALE ===');
        FOR r IN (SELECT s.id, s.numer, s.typ, s.pojemnosc, s.lista_wyposazenia() AS wyp FROM sale s ORDER BY s.id) LOOP
            DBMS_OUTPUT.PUT_LINE(r.id || '. Sala ' || r.numer || ' (' || r.typ || ', max ' || r.pojemnosc || ' os.)');
            DBMS_OUTPUT.PUT_LINE('   Wyposażenie: ' || NVL(r.wyp, 'brak'));
        END LOOP;
    END;

    -- Lista grup
    PROCEDURE lista_grup IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== GRUPY ===');
        FOR r IN (SELECT g.id, g.symbol, g.poziom FROM grupy g ORDER BY g.poziom) LOOP
            DBMS_OUTPUT.PUT_LINE(r.id || '. Klasa ' || r.poziom || ' (grupa ' || r.symbol || ')');
        END LOOP;
    END;

END pkg_slowniki;
/

-- ============================================================================
-- PKG_OSOBY - zarządzanie nauczycielami i uczniami
-- ============================================================================
CREATE OR REPLACE PACKAGE pkg_osoby AS
    -- Dodawanie
    PROCEDURE dodaj_nauczyciela(p_imie VARCHAR2, p_nazwisko VARCHAR2, p_id_przedmiotu NUMBER);
    PROCEDURE dodaj_ucznia(p_imie VARCHAR2, p_nazwisko VARCHAR2, p_data_ur DATE, p_instrument VARCHAR2, p_id_grupy NUMBER);

    -- Pobieranie referencji
    FUNCTION get_ref_nauczyciel(p_id NUMBER) RETURN REF t_nauczyciel;
    FUNCTION get_ref_uczen(p_id NUMBER) RETURN REF t_uczen;

    -- Listy
    PROCEDURE lista_nauczycieli;
    PROCEDURE lista_uczniow;
    PROCEDURE lista_uczniow_grupy(p_id_grupy NUMBER);
END pkg_osoby;
/

CREATE OR REPLACE PACKAGE BODY pkg_osoby AS

    -- Dodaj nauczyciela
    PROCEDURE dodaj_nauczyciela(p_imie VARCHAR2, p_nazwisko VARCHAR2, p_id_przedmiotu NUMBER) IS
        v_ref_przedmiot REF t_przedmiot;
    BEGIN
        v_ref_przedmiot := pkg_slowniki.get_ref_przedmiot(p_id_przedmiotu);
        INSERT INTO nauczyciele VALUES (
            t_nauczyciel(seq_nauczyciele.NEXTVAL, p_imie, p_nazwisko, SYSDATE, v_ref_przedmiot)
        );
        DBMS_OUTPUT.PUT_LINE('Dodano nauczyciela: ' || p_imie || ' ' || p_nazwisko);
    END;

    -- Dodaj ucznia
    PROCEDURE dodaj_ucznia(p_imie VARCHAR2, p_nazwisko VARCHAR2, p_data_ur DATE, p_instrument VARCHAR2, p_id_grupy NUMBER) IS
        v_ref_grupa REF t_grupa;
    BEGIN
        v_ref_grupa := pkg_slowniki.get_ref_grupa(p_id_grupy);
        INSERT INTO uczniowie VALUES (
            t_uczen(seq_uczniowie.NEXTVAL, p_imie, p_nazwisko, p_data_ur, p_instrument, v_ref_grupa)
        );
        DBMS_OUTPUT.PUT_LINE('Dodano ucznia: ' || p_imie || ' ' || p_nazwisko || ' (' || p_instrument || ')');
    END;

    -- Pobierz referencję do nauczyciela
    FUNCTION get_ref_nauczyciel(p_id NUMBER) RETURN REF t_nauczyciel IS
        v_ref REF t_nauczyciel;
    BEGIN
        SELECT REF(n) INTO v_ref FROM nauczyciele n WHERE n.id = p_id;
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20013, 'Nauczyciel ID=' || p_id || ' nie istnieje');
    END;

    -- Pobierz referencję do ucznia
    FUNCTION get_ref_uczen(p_id NUMBER) RETURN REF t_uczen IS
        v_ref REF t_uczen;
    BEGIN
        SELECT REF(u) INTO v_ref FROM uczniowie u WHERE u.id = p_id;
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20014, 'Uczeń ID=' || p_id || ' nie istnieje');
    END;

    -- Lista nauczycieli
    PROCEDURE lista_nauczycieli IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== NAUCZYCIELE ===');
        FOR r IN (
            SELECT n.id, n.pelne_nazwisko() AS nazwa, 
                   DEREF(n.ref_przedmiot).nazwa AS przedmiot
            FROM nauczyciele n ORDER BY n.id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(r.id || '. ' || r.nazwa || ' - uczy: ' || r.przedmiot);
        END LOOP;
    END;

    -- Lista uczniów
    PROCEDURE lista_uczniow IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== UCZNIOWIE ===');
        FOR r IN (
            SELECT u.id, u.pelne_nazwisko() AS nazwa, u.wiek() AS wiek,
                   u.instrument, DEREF(u.ref_grupa).symbol AS grupa
            FROM uczniowie u ORDER BY grupa, u.nazwisko
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(r.id || '. ' || r.nazwa || ' (lat ' || r.wiek || ') - ' ||
                                 r.instrument || ', grupa ' || r.grupa);
        END LOOP;
    END;

    -- Kursor jawny dla listy uczniów w grupie
    PROCEDURE lista_uczniow_grupy(p_id_grupy NUMBER) IS
        CURSOR c_uczniowie IS
            SELECT u.id, u.pelne_nazwisko() AS nazwa, u.instrument
            FROM uczniowie u
            WHERE DEREF(u.ref_grupa).id = p_id_grupy
            ORDER BY u.nazwisko;
        v_rec c_uczniowie%ROWTYPE;
        v_symbol VARCHAR2(10);
    BEGIN
        SELECT g.symbol INTO v_symbol FROM grupy g WHERE g.id = p_id_grupy;
        DBMS_OUTPUT.PUT_LINE('=== UCZNIOWIE GRUPY ' || v_symbol || ' ===');

        OPEN c_uczniowie;
        LOOP
            FETCH c_uczniowie INTO v_rec;
            EXIT WHEN c_uczniowie%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(v_rec.id || '. ' || v_rec.nazwa || ' - ' || v_rec.instrument);
        END LOOP;
        CLOSE c_uczniowie;
    END;

END pkg_osoby;
/

-- ============================================================================
-- PKG_LEKCJE - zarządzanie lekcjami (z walidacją konfliktów)
-- ============================================================================
CREATE OR REPLACE PACKAGE pkg_lekcje AS
    -- Dodawanie lekcji
    PROCEDURE dodaj_lekcje_indywidualna(
        p_id_przedmiotu NUMBER, p_id_nauczyciela NUMBER, p_id_sali NUMBER,
        p_id_ucznia NUMBER, p_data DATE, p_godz NUMBER
    );
    PROCEDURE dodaj_lekcje_grupowa(
        p_id_przedmiotu NUMBER, p_id_nauczyciela NUMBER, p_id_sali NUMBER,
        p_id_grupy NUMBER, p_data DATE, p_godz NUMBER
    );

    -- Plany
    PROCEDURE plan_ucznia(p_id_ucznia NUMBER);
    PROCEDURE plan_nauczyciela(p_id_nauczyciela NUMBER);
    PROCEDURE plan_dnia(p_data DATE);
END pkg_lekcje;
/

CREATE OR REPLACE PACKAGE BODY pkg_lekcje AS

    -- ========================================================================
    -- FUNKCJA PRYWATNA - sprawdza dostępność terminów
    -- Zwraca tekst błędu lub NULL jeśli termin jest wolny
    -- ========================================================================
    FUNCTION sprawdz_kolizje(
        p_data DATE,
        p_godz NUMBER,
        p_ref_nauczyciel REF t_nauczyciel,
        p_ref_sala REF t_sala,
        p_ref_uczen REF t_uczen,    -- może być NULL
        p_ref_grupa REF t_grupa     -- może być NULL
    ) RETURN VARCHAR2 IS
        v_licznik NUMBER;
    BEGIN
        -- 1. Sprawdzenie SALI
        SELECT COUNT(*) INTO v_licznik FROM lekcje l
        WHERE l.data_lekcji = p_data AND l.godz_rozp = p_godz
          AND l.ref_sala = p_ref_sala;

        IF v_licznik > 0 THEN
            RETURN 'Sala jest już zajęta w tym terminie!';
        END IF;

        -- 2. Sprawdzenie NAUCZYCIELA
        SELECT COUNT(*) INTO v_licznik FROM lekcje l
        WHERE l.data_lekcji = p_data AND l.godz_rozp = p_godz
          AND l.ref_nauczyciel = p_ref_nauczyciel;

        IF v_licznik > 0 THEN
            RETURN 'Nauczyciel ma już lekcję w tym terminie!';
        END IF;

        -- 3. Sprawdzenie UCZNIA (jeśli dotyczy)
        IF p_ref_uczen IS NOT NULL THEN
            SELECT COUNT(*) INTO v_licznik FROM lekcje l
            WHERE l.data_lekcji = p_data AND l.godz_rozp = p_godz
              AND l.ref_uczen = p_ref_uczen;

            IF v_licznik > 0 THEN
                RETURN 'Uczeń ma już lekcję w tym terminie!';
            END IF;
        END IF;

        -- 4. Sprawdzenie GRUPY (jeśli dotyczy)
        IF p_ref_grupa IS NOT NULL THEN
            SELECT COUNT(*) INTO v_licznik FROM lekcje l
            WHERE l.data_lekcji = p_data AND l.godz_rozp = p_godz
              AND l.ref_grupa = p_ref_grupa;

            IF v_licznik > 0 THEN
                RETURN 'Grupa ma już zajęcia w tym terminie!';
            END IF;
        END IF;

        RETURN NULL; -- Brak konfliktów
    END;

    -- ========================================================================
    -- FUNKCJA PRYWATNA - sprawdza czy sala ma wyposażenie dla instrumentu
    -- Przeszukuje VARRAY wyposażenia sali
    -- ========================================================================
    FUNCTION sala_ma_instrument(
        p_id_sali NUMBER,
        p_instrument VARCHAR2
    ) RETURN BOOLEAN IS
        v_wyposazenie t_wyposazenie;
    BEGIN
        SELECT s.wyposazenie INTO v_wyposazenie
        FROM sale s WHERE s.id = p_id_sali;

        IF v_wyposazenie IS NULL THEN
            RETURN FALSE;
        END IF;

        -- Przeszukanie VARRAY
        FOR i IN 1..v_wyposazenie.COUNT LOOP
            -- Sprawdź czy element wyposażenia zawiera nazwę instrumentu
            IF UPPER(v_wyposazenie(i)) LIKE '%' || UPPER(p_instrument) || '%' THEN
                RETURN TRUE;
            END IF;
            -- Specjalne przypadki: Pianino = Fortepian
            IF UPPER(p_instrument) = 'FORTEPIAN' AND UPPER(v_wyposazenie(i)) LIKE '%PIANINO%' THEN
                RETURN TRUE;
            END IF;
        END LOOP;

        RETURN FALSE;
    END;

    -- ========================================================================
    -- FUNKCJA PRYWATNA - HEURYSTYKA: Szukaj następnego wolnego terminu
    -- Dla lekcji indywidualnych: szuka sal z odpowiednim instrumentem (VARRAY)
    -- Dla lekcji grupowych: szuka tylko sal typu 'grupowa' z odpowiednią pojemnością
    -- ========================================================================
    FUNCTION znajdz_alternatywe(
        p_start_data DATE,
        p_start_godz NUMBER,
        p_ref_nauczyciel REF t_nauczyciel,
        p_ref_uczen REF t_uczen,        -- NULL dla lekcji grupowej
        p_ref_grupa REF t_grupa,        -- NULL dla lekcji indywidualnej
        p_instrument VARCHAR2,          -- nazwa instrumentu (dla lekcji indywidualnej)
        p_liczba_uczniow NUMBER         -- liczba uczniów w grupie (dla lekcji grupowej, 0 dla indywidualnej)
    ) RETURN VARCHAR2 IS
        v_data DATE := p_start_data;
        v_godz NUMBER := p_start_godz + 1;  -- Start od następnej godziny
        v_test VARCHAR2(200);
        v_ref_sala REF t_sala;
        c_max_dni CONSTANT NUMBER := 7;     -- Szukamy max tydzień w przód
        v_jest_grupowa BOOLEAN := (p_ref_grupa IS NOT NULL);
    BEGIN
        -- Pętla po dniach (max 7 dni)
        FOR dzien IN 0..c_max_dni LOOP

            -- Pętla po godzinach (zakładamy godziny pracy szkoły 14-19, ostatnia lekcja 19:00-19:45)
            WHILE v_godz <= 19 LOOP

                -- Pętla po salach - szukamy odpowiedniej sali
                FOR sala IN (
                    SELECT s.id, s.numer, s.typ, s.pojemnosc
                    FROM sale s
                    ORDER BY s.id
                ) LOOP
                    -- Dla lekcji grupowej: tylko sale grupowe z odpowiednią pojemnością
                    IF v_jest_grupowa THEN
                        IF sala.typ = 'grupowa' AND sala.pojemnosc >= p_liczba_uczniow THEN
                            -- Pobierz REF do sali
                            SELECT REF(s) INTO v_ref_sala FROM sale s WHERE s.id = sala.id;

                            -- Sprawdź kolizje
                            v_test := sprawdz_kolizje(v_data, v_godz, p_ref_nauczyciel, v_ref_sala, NULL, p_ref_grupa);

                            IF v_test IS NULL THEN
                                RETURN TO_CHAR(v_data, 'YYYY-MM-DD') || ' o godzinie ' || v_godz || ':00 w sali ' || sala.numer;
                            END IF;
                        END IF;
                    -- Dla lekcji indywidualnej: szukamy sali z odpowiednim instrumentem
                    ELSE
                        IF sala_ma_instrument(sala.id, p_instrument) THEN
                            -- Pobierz REF do sali
                            SELECT REF(s) INTO v_ref_sala FROM sale s WHERE s.id = sala.id;

                            -- Sprawdź kolizje
                            v_test := sprawdz_kolizje(v_data, v_godz, p_ref_nauczyciel, v_ref_sala, p_ref_uczen, NULL);

                            IF v_test IS NULL THEN
                                RETURN TO_CHAR(v_data, 'YYYY-MM-DD') || ' o godzinie ' || v_godz || ':00 w sali ' || sala.numer;
                            END IF;
                        END IF;
                    END IF;
                END LOOP;

                v_godz := v_godz + 1; -- Następna godzina
            END LOOP;

            -- Reset na następny dzień
            v_data := v_data + 1;
            v_godz := 14; -- Start pracy szkoły
        END LOOP;

        -- Brak wolnych terminów - zwróć precyzyjny komunikat
        IF v_jest_grupowa THEN
            RETURN 'Brak sal grupowych (pojemnosc >= ' || p_liczba_uczniow ||
                   ') w najblizszym tygodniu.';
        ELSE
            RETURN 'Brak sal z instrumentem "' || p_instrument ||
                   '" w najblizszym tygodniu.';
        END IF;
    END;

    -- ========================================================================
    -- Procedury publiczne
    -- ========================================================================

    -- Dodaj lekcję indywidualną
    PROCEDURE dodaj_lekcje_indywidualna(
        p_id_przedmiotu NUMBER, p_id_nauczyciela NUMBER, p_id_sali NUMBER,
        p_id_ucznia NUMBER, p_data DATE, p_godz NUMBER
    ) IS
        v_ref_przedmiot REF t_przedmiot;
        v_ref_nauczyciel REF t_nauczyciel;
        v_ref_sala REF t_sala;
        v_ref_uczen REF t_uczen;
        v_blad VARCHAR2(200);
        v_id_przedmiotu_nauczyciela NUMBER;
        v_nazwa_przedmiotu VARCHAR2(50);
        v_typ_przedmiotu VARCHAR2(20);
        v_instrument_ucznia VARCHAR2(50);
    BEGIN
        -- Pobranie referencji
        v_ref_przedmiot := pkg_slowniki.get_ref_przedmiot(p_id_przedmiotu);
        v_ref_nauczyciel := pkg_osoby.get_ref_nauczyciel(p_id_nauczyciela);
        v_ref_sala := pkg_slowniki.get_ref_sala(p_id_sali);
        v_ref_uczen := pkg_osoby.get_ref_uczen(p_id_ucznia);

        -- WALIDACJA: Kompetencje nauczyciela (czy uczy tego przedmiotu)
        SELECT DEREF(n.ref_przedmiot).id INTO v_id_przedmiotu_nauczyciela
        FROM nauczyciele n WHERE n.id = p_id_nauczyciela;

        IF v_id_przedmiotu_nauczyciela != p_id_przedmiotu THEN
            RAISE_APPLICATION_ERROR(-20030, 'Ten nauczyciel nie uczy tego przedmiotu!');
        END IF;

        -- WALIDACJA: Instrument ucznia (tylko dla przedmiotów indywidualnych/instrumentalnych)
        SELECT p.nazwa, p.typ INTO v_nazwa_przedmiotu, v_typ_przedmiotu
        FROM przedmioty p WHERE p.id = p_id_przedmiotu;

        IF v_typ_przedmiotu = 'indywidualny' THEN
            SELECT u.instrument INTO v_instrument_ucznia
            FROM uczniowie u WHERE u.id = p_id_ucznia;

            IF UPPER(v_instrument_ucznia) != UPPER(v_nazwa_przedmiotu) THEN
                -- Wyjątek: Pianino = Fortepian (synonimiczny)
                IF NOT ((UPPER(v_instrument_ucznia) = 'PIANINO' AND UPPER(v_nazwa_przedmiotu) = 'FORTEPIAN')
                     OR (UPPER(v_instrument_ucznia) = 'FORTEPIAN' AND UPPER(v_nazwa_przedmiotu) = 'PIANINO')) THEN
                    RAISE_APPLICATION_ERROR(-20032,
                        'Uczeń gra na instrumencie ' || v_instrument_ucznia ||
                        ', a lekcja dotyczy przedmiotu ' || v_nazwa_przedmiotu || '!');
                END IF;
            END IF;
        END IF;

        -- WALIDACJA KONFLIKTÓW Z SUGESTIĄ ALTERNATYWNEGO TERMINU
        v_blad := sprawdz_kolizje(p_data, p_godz, v_ref_nauczyciel, v_ref_sala, v_ref_uczen, NULL);

        IF v_blad IS NOT NULL THEN
            -- Jeśli zajęte, uruchom heurystykę i znajdź alternatywę
            DECLARE
                v_sugestia VARCHAR2(200);
            BEGIN
                v_sugestia := znajdz_alternatywe(
                    p_data, p_godz, v_ref_nauczyciel, v_ref_uczen, NULL,
                    v_nazwa_przedmiotu,  -- instrument = nazwa przedmiotu
                    0                    -- brak grupy
                );

                RAISE_APPLICATION_ERROR(-20020,
                    'Blad planowania: ' || v_blad ||
                    CHR(10) || 'SUGEROWANY TERMIN: ' || v_sugestia);
            END;
        END IF;

        INSERT INTO lekcje VALUES (
            t_lekcja(
                seq_lekcje.NEXTVAL,
                v_ref_przedmiot, v_ref_nauczyciel, v_ref_sala, v_ref_uczen,
                NULL,  -- brak grupy (lekcja indywidualna)
                p_data, p_godz, 45
            )
        );
        DBMS_OUTPUT.PUT_LINE('Dodano lekcję indywidualną: ' || TO_CHAR(p_data, 'YYYY-MM-DD') || ' ' || p_godz || ':00');
    END;

    -- Dodaj lekcję grupową
    PROCEDURE dodaj_lekcje_grupowa(
        p_id_przedmiotu NUMBER, p_id_nauczyciela NUMBER, p_id_sali NUMBER,
        p_id_grupy NUMBER, p_data DATE, p_godz NUMBER
    ) IS
        v_ref_przedmiot REF t_przedmiot;
        v_ref_nauczyciel REF t_nauczyciel;
        v_ref_sala REF t_sala;
        v_ref_grupa REF t_grupa;
        v_blad VARCHAR2(200);
        v_id_przedmiotu_nauczyciela NUMBER;
        v_typ_sali VARCHAR2(20);
        v_liczba_uczniow NUMBER;
        v_pojemnosc_sali NUMBER;
    BEGIN
        -- Pobranie referencji
        v_ref_przedmiot := pkg_slowniki.get_ref_przedmiot(p_id_przedmiotu);
        v_ref_nauczyciel := pkg_osoby.get_ref_nauczyciel(p_id_nauczyciela);
        v_ref_sala := pkg_slowniki.get_ref_sala(p_id_sali);
        v_ref_grupa := pkg_slowniki.get_ref_grupa(p_id_grupy);

        -- WALIDACJA: Kompetencje nauczyciela (czy uczy tego przedmiotu)
        SELECT DEREF(n.ref_przedmiot).id INTO v_id_przedmiotu_nauczyciela
        FROM nauczyciele n WHERE n.id = p_id_nauczyciela;

        IF v_id_przedmiotu_nauczyciela != p_id_przedmiotu THEN
            RAISE_APPLICATION_ERROR(-20030, 'Ten nauczyciel nie uczy tego przedmiotu!');
        END IF;

        -- WALIDACJA: Typ sali (lekcja grupowa wymaga sali grupowej)
        SELECT s.typ, s.pojemnosc INTO v_typ_sali, v_pojemnosc_sali
        FROM sale s WHERE s.id = p_id_sali;

        IF v_typ_sali = 'indywidualna' THEN
            RAISE_APPLICATION_ERROR(-20031,
                'Nie można prowadzić lekcji grupowej w sali indywidualnej!');
        END IF;

        -- WALIDACJA: Przepełnienie sali (czy grupa zmieści się w sali)
        SELECT COUNT(*) INTO v_liczba_uczniow
        FROM uczniowie u
        WHERE DEREF(u.ref_grupa).id = p_id_grupy;

        IF v_liczba_uczniow > v_pojemnosc_sali THEN
            RAISE_APPLICATION_ERROR(-20035,
                'Sala jest za mała! Grupa liczy ' || v_liczba_uczniow ||
                ' osób, a sala mieści tylko ' || v_pojemnosc_sali || '.');
        END IF;

        -- WALIDACJA KONFLIKTÓW Z SUGESTIĄ ALTERNATYWNEGO TERMINU
        v_blad := sprawdz_kolizje(p_data, p_godz, v_ref_nauczyciel, v_ref_sala, NULL, v_ref_grupa);

        IF v_blad IS NOT NULL THEN
            -- Jeśli zajęte, uruchom heurystykę i znajdź alternatywę
            DECLARE
                v_sugestia VARCHAR2(200);
            BEGIN
                v_sugestia := znajdz_alternatywe(
                    p_data, p_godz, v_ref_nauczyciel, NULL, v_ref_grupa,
                    NULL,               -- brak instrumentu (lekcja grupowa)
                    v_liczba_uczniow    -- liczba uczniów w grupie
                );

                RAISE_APPLICATION_ERROR(-20021,
                    'Blad planowania: ' || v_blad ||
                    CHR(10) || 'SUGEROWANY TERMIN: ' || v_sugestia);
            END;
        END IF;

        INSERT INTO lekcje VALUES (
            t_lekcja(
                seq_lekcje.NEXTVAL,
                v_ref_przedmiot, v_ref_nauczyciel, v_ref_sala,
                NULL,  -- brak ucznia (lekcja grupowa)
                v_ref_grupa,
                p_data, p_godz, 45
            )
        );
        DBMS_OUTPUT.PUT_LINE('Dodano lekcję grupową: ' || TO_CHAR(p_data, 'YYYY-MM-DD') || ' ' || p_godz || ':00');
    END;

    -- Plan ucznia
    PROCEDURE plan_ucznia(p_id_ucznia NUMBER) IS
        v_uczen VARCHAR2(100);
        v_id_grupy NUMBER;
    BEGIN
        SELECT u.pelne_nazwisko(), DEREF(u.ref_grupa).id
        INTO v_uczen, v_id_grupy
        FROM uczniowie u WHERE u.id = p_id_ucznia;

        DBMS_OUTPUT.PUT_LINE('=== PLAN UCZNIA: ' || v_uczen || ' ===');

        -- Lekcje indywidualne + grupowe (UNION)
        FOR r IN (
            SELECT l.data_lekcji, l.godz_rozp,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_nauczyciel).pelne_nazwisko() AS nauczyciel,
                   DEREF(l.ref_sala).numer AS sala,
                   l.czy_indywidualna() AS typ
            FROM lekcje l
            WHERE DEREF(l.ref_uczen).id = p_id_ucznia
               OR DEREF(l.ref_grupa).id = v_id_grupy
            ORDER BY l.data_lekcji, l.godz_rozp
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(r.data_lekcji, 'DY DD.MM') || ' ' || r.godz_rozp || ':00 - ' ||
                                 r.przedmiot || ' (sala ' || r.sala || ')' ||
                                 CASE WHEN r.typ = 'N' THEN ' [GRUPOWA]' ELSE '' END);
        END LOOP;
    END;

    -- Plan nauczyciela
    PROCEDURE plan_nauczyciela(p_id_nauczyciela NUMBER) IS
        v_nauczyciel VARCHAR2(100);
    BEGIN
        SELECT n.pelne_nazwisko() INTO v_nauczyciel FROM nauczyciele n WHERE n.id = p_id_nauczyciela;

        DBMS_OUTPUT.PUT_LINE('=== PLAN NAUCZYCIELA: ' || v_nauczyciel || ' ===');
        FOR r IN (
            SELECT l.data_lekcji, l.godz_rozp,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_sala).numer AS sala,
                   CASE WHEN l.ref_uczen IS NOT NULL
                        THEN DEREF(l.ref_uczen).pelne_nazwisko()
                        ELSE 'grupa ' || DEREF(l.ref_grupa).symbol
                   END AS kto
            FROM lekcje l
            WHERE DEREF(l.ref_nauczyciel).id = p_id_nauczyciela
            ORDER BY l.data_lekcji, l.godz_rozp
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(r.data_lekcji, 'DY DD.MM') || ' ' || r.godz_rozp || ':00 - ' ||
                                 r.przedmiot || ' (sala ' || r.sala || ') - ' || r.kto);
        END LOOP;
    END;

    -- Plan dnia
    PROCEDURE plan_dnia(p_data DATE) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== PLAN DNIA: ' || TO_CHAR(p_data, 'YYYY-MM-DD (DY)') || ' ===');
        FOR r IN (
            SELECT l.godz_rozp,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_nauczyciel).pelne_nazwisko() AS nauczyciel,
                   DEREF(l.ref_sala).numer AS sala,
                   CASE WHEN l.ref_uczen IS NOT NULL
                        THEN DEREF(l.ref_uczen).pelne_nazwisko()
                        ELSE 'grupa ' || DEREF(l.ref_grupa).symbol
                   END AS kto
            FROM lekcje l
            WHERE l.data_lekcji = p_data
            ORDER BY l.godz_rozp
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(r.godz_rozp || ':00 | sala ' || r.sala || ' | ' ||
                                 r.przedmiot || ' | ' || r.nauczyciel || ' | ' || r.kto);
        END LOOP;
    END;

END pkg_lekcje;
/

-- ============================================================================
-- PKG_OCENY - zarządzanie ocenami
-- ============================================================================
CREATE OR REPLACE PACKAGE pkg_oceny AS
    PROCEDURE wystaw_ocene(p_id_ucznia NUMBER, p_id_nauczyciela NUMBER,
                           p_id_przedmiotu NUMBER, p_wartosc NUMBER);
    PROCEDURE wystaw_ocene_semestralna(p_id_ucznia NUMBER, p_id_nauczyciela NUMBER,
                                       p_id_przedmiotu NUMBER, p_wartosc NUMBER);
    PROCEDURE oceny_ucznia(p_id_ucznia NUMBER);
    FUNCTION srednia_ucznia(p_id_ucznia NUMBER, p_id_przedmiotu NUMBER) RETURN NUMBER;
END pkg_oceny;
/

CREATE OR REPLACE PACKAGE BODY pkg_oceny AS

    -- ========================================================================
    -- FUNKCJA PRYWATNA - sprawdza uprawnienia nauczyciela do oceniania
    -- ========================================================================
    PROCEDURE sprawdz_uprawnienia_oceniania(
        p_id_nauczyciela NUMBER,
        p_id_przedmiotu NUMBER
    ) IS
        v_id_przedmiotu_nauczyciela NUMBER;
    BEGIN
        SELECT DEREF(n.ref_przedmiot).id INTO v_id_przedmiotu_nauczyciela
        FROM nauczyciele n WHERE n.id = p_id_nauczyciela;

        IF v_id_przedmiotu_nauczyciela != p_id_przedmiotu THEN
            RAISE_APPLICATION_ERROR(-20033,
                'Ten nauczyciel nie może wystawiać ocen z tego przedmiotu!');
        END IF;
    END;

    -- Wystaw ocenę
    PROCEDURE wystaw_ocene(p_id_ucznia NUMBER, p_id_nauczyciela NUMBER,
                           p_id_przedmiotu NUMBER, p_wartosc NUMBER) IS
    BEGIN
        -- WALIDACJA: Uprawnienia do oceniania
        sprawdz_uprawnienia_oceniania(p_id_nauczyciela, p_id_przedmiotu);

        INSERT INTO oceny VALUES (
            t_ocena(
                seq_oceny.NEXTVAL,
                pkg_osoby.get_ref_uczen(p_id_ucznia),
                pkg_osoby.get_ref_nauczyciel(p_id_nauczyciela),
                pkg_slowniki.get_ref_przedmiot(p_id_przedmiotu),
                p_wartosc, SYSDATE, 'N'
            )
        );
        DBMS_OUTPUT.PUT_LINE('Wystawiono ocenę: ' || p_wartosc);
    END;

    -- Wystaw ocenę semestralną
    PROCEDURE wystaw_ocene_semestralna(p_id_ucznia NUMBER, p_id_nauczyciela NUMBER,
                                       p_id_przedmiotu NUMBER, p_wartosc NUMBER) IS
    BEGIN
        -- WALIDACJA: Uprawnienia do oceniania
        sprawdz_uprawnienia_oceniania(p_id_nauczyciela, p_id_przedmiotu);

        INSERT INTO oceny VALUES (
            t_ocena(
                seq_oceny.NEXTVAL,
                pkg_osoby.get_ref_uczen(p_id_ucznia),
                pkg_osoby.get_ref_nauczyciel(p_id_nauczyciela),
                pkg_slowniki.get_ref_przedmiot(p_id_przedmiotu),
                p_wartosc, SYSDATE, 'T'
            )
        );
        DBMS_OUTPUT.PUT_LINE('Wystawiono ocenę SEMESTRALNĄ: ' || p_wartosc);
    END;

    -- Wyświetl oceny ucznia
    PROCEDURE oceny_ucznia(p_id_ucznia NUMBER) IS
        v_uczen VARCHAR2(100);
    BEGIN
        SELECT u.pelne_nazwisko() INTO v_uczen FROM uczniowie u WHERE u.id = p_id_ucznia;

        DBMS_OUTPUT.PUT_LINE('=== OCENY UCZNIA: ' || v_uczen || ' ===');
        FOR r IN (
            SELECT DEREF(o.ref_przedmiot).nazwa AS przedmiot,
                   o.wartosc, o.opis_oceny() AS opis,
                   o.semestralna, TO_CHAR(o.data_oceny, 'YYYY-MM-DD') AS data
            FROM oceny o
            WHERE DEREF(o.ref_uczen).id = p_id_ucznia
            ORDER BY o.data_oceny
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(r.przedmiot || ': ' || r.wartosc || ' (' || r.opis || ')' ||
                                 CASE WHEN r.semestralna = 'T' THEN ' [SEM]' ELSE '' END ||
                                 ' - ' || r.data);
        END LOOP;
    END;

    -- Oblicz średnią ucznia z danego przedmiotu (bez ocen semestralnych)
    FUNCTION srednia_ucznia(p_id_ucznia NUMBER, p_id_przedmiotu NUMBER) RETURN NUMBER IS
        v_srednia NUMBER;
    BEGIN
        SELECT AVG(o.wartosc) INTO v_srednia
        FROM oceny o
        WHERE DEREF(o.ref_uczen).id = p_id_ucznia
          AND DEREF(o.ref_przedmiot).id = p_id_przedmiotu
          AND o.semestralna = 'N';
        -- Zwróć 0 gdy brak ocen (AVG zwraca NULL)
        RETURN NVL(ROUND(v_srednia, 2), 0);
    END;

END pkg_oceny;
/

-- ============================================================================
-- PKG_RAPORTY - raporty i statystyki
-- ============================================================================
CREATE OR REPLACE PACKAGE pkg_raporty AS
    PROCEDURE raport_grup;
    PROCEDURE statystyki;
END pkg_raporty;
/

CREATE OR REPLACE PACKAGE BODY pkg_raporty AS

    -- Raport grup
    PROCEDURE raport_grup IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== RAPORT GRUP ===');
        FOR r IN (
            SELECT g.symbol, g.poziom,
                   (SELECT COUNT(*) FROM uczniowie u WHERE DEREF(u.ref_grupa).id = g.id) AS liczba
            FROM grupy g ORDER BY g.poziom
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Klasa ' || r.poziom || ' (' || r.symbol || '): ' || r.liczba || ' uczniów');
        END LOOP;
    END;

    -- Statystyki szkoły
    PROCEDURE statystyki IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== STATYSTYKI SZKOŁY ===');
        FOR r IN (
            SELECT
                (SELECT COUNT(*) FROM uczniowie) AS uczniowie,
                (SELECT COUNT(*) FROM nauczyciele) AS nauczyciele,
                (SELECT COUNT(*) FROM grupy) AS grupy,
                (SELECT COUNT(*) FROM sale) AS sale,
                (SELECT COUNT(*) FROM lekcje) AS lekcje,
                (SELECT COUNT(*) FROM oceny) AS oceny
            FROM DUAL
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Uczniów: ' || r.uczniowie);
            DBMS_OUTPUT.PUT_LINE('Nauczycieli: ' || r.nauczyciele);
            DBMS_OUTPUT.PUT_LINE('Grup: ' || r.grupy);
            DBMS_OUTPUT.PUT_LINE('Sal: ' || r.sale);
            DBMS_OUTPUT.PUT_LINE('Lekcji: ' || r.lekcje);
            DBMS_OUTPUT.PUT_LINE('Ocen: ' || r.oceny);
        END LOOP;
    END;

END pkg_raporty;
/

-- ============================================================================
-- Weryfikacja
-- ============================================================================
SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('PACKAGE', 'PACKAGE BODY')
ORDER BY object_name, object_type;
