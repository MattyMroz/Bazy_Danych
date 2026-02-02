-- ============================================================================
-- SZKOŁA MUZYCZNA I STOPNIA - PAKIETY PL/SQL
-- Autorzy: Igor Typiński (251237), Mateusz Mróz (251190)
-- ============================================================================
-- WYMAGANY WYMIAR: 5 lekcji/tydzień na ucznia
--   - 2 lekcje instrumentu (indywidualne)
--   - 2 lekcje kształcenia słuchu (grupowe)
--   - 1 lekcja rytmiki (grupowa)
-- ============================================================================

-- ============================================================================
-- PKG_SLOWNIKI - zarządzanie słownikami (przedmioty, grupy, sale)
-- ============================================================================
CREATE OR REPLACE PACKAGE pkg_slowniki AS
    PROCEDURE dodaj_przedmiot(p_nazwa VARCHAR2, p_typ VARCHAR2);
    PROCEDURE dodaj_grupe(p_symbol VARCHAR2, p_poziom NUMBER);
    PROCEDURE dodaj_sale(p_numer VARCHAR2, p_typ VARCHAR2, p_pojemnosc NUMBER, p_wyposazenie t_wyposazenie);
    
    FUNCTION get_ref_przedmiot(p_id NUMBER) RETURN REF t_przedmiot;
    FUNCTION get_ref_przedmiot_nazwa(p_nazwa VARCHAR2) RETURN REF t_przedmiot;
    FUNCTION get_ref_grupa(p_id NUMBER) RETURN REF t_grupa;
    FUNCTION get_ref_grupa_symbol(p_symbol VARCHAR2) RETURN REF t_grupa;
    FUNCTION get_ref_sala(p_id NUMBER) RETURN REF t_sala;
    FUNCTION get_ref_sala_numer(p_numer VARCHAR2) RETURN REF t_sala;
    FUNCTION get_id_przedmiot(p_nazwa VARCHAR2) RETURN NUMBER;
    
    -- Funkcje INFO - wyświetlanie co kryje się pod ID
    PROCEDURE info_przedmiot(p_id NUMBER);
    PROCEDURE info_sala(p_id NUMBER);
    PROCEDURE info_grupa(p_id NUMBER);
    
    PROCEDURE lista_przedmiotow;
    PROCEDURE lista_sal;
    PROCEDURE lista_grup;
END pkg_slowniki;
/

CREATE OR REPLACE PACKAGE BODY pkg_slowniki AS

    PROCEDURE dodaj_przedmiot(p_nazwa VARCHAR2, p_typ VARCHAR2) IS
    BEGIN
        INSERT INTO przedmioty VALUES (
            t_przedmiot(seq_przedmioty.NEXTVAL, p_nazwa, p_typ, 45)
        );
        DBMS_OUTPUT.PUT_LINE('Dodano przedmiot: ' || p_nazwa);
    END;

    PROCEDURE dodaj_grupe(p_symbol VARCHAR2, p_poziom NUMBER) IS
    BEGIN
        INSERT INTO grupy VALUES (
            t_grupa(seq_grupy.NEXTVAL, p_symbol, p_poziom)
        );
        DBMS_OUTPUT.PUT_LINE('Dodano grupę: ' || p_symbol);
    END;

    PROCEDURE dodaj_sale(p_numer VARCHAR2, p_typ VARCHAR2, p_pojemnosc NUMBER, p_wyposazenie t_wyposazenie) IS
    BEGIN
        INSERT INTO sale VALUES (
            t_sala(seq_sale.NEXTVAL, p_numer, p_typ, p_pojemnosc, p_wyposazenie)
        );
        DBMS_OUTPUT.PUT_LINE('Dodano salę: ' || p_numer || ' z wyposażeniem');
    END;

    FUNCTION get_ref_przedmiot(p_id NUMBER) RETURN REF t_przedmiot IS
        v_ref REF t_przedmiot;
    BEGIN
        SELECT REF(p) INTO v_ref FROM przedmioty p WHERE p.id = p_id;
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20010, 'Nie znaleziono przedmiotu o ID: ' || p_id);
    END;

    FUNCTION get_ref_przedmiot_nazwa(p_nazwa VARCHAR2) RETURN REF t_przedmiot IS
        v_ref REF t_przedmiot;
    BEGIN
        SELECT REF(p) INTO v_ref FROM przedmioty p WHERE p.nazwa = p_nazwa;
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20010, 'Nie znaleziono przedmiotu: ' || p_nazwa);
    END;

    FUNCTION get_ref_grupa(p_id NUMBER) RETURN REF t_grupa IS
        v_ref REF t_grupa;
    BEGIN
        SELECT REF(g) INTO v_ref FROM grupy g WHERE g.id = p_id;
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20011, 'Nie znaleziono grupy o ID: ' || p_id);
    END;

    FUNCTION get_ref_grupa_symbol(p_symbol VARCHAR2) RETURN REF t_grupa IS
        v_ref REF t_grupa;
    BEGIN
        SELECT REF(g) INTO v_ref FROM grupy g WHERE g.symbol = p_symbol;
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20011, 'Nie znaleziono grupy: ' || p_symbol);
    END;

    FUNCTION get_ref_sala(p_id NUMBER) RETURN REF t_sala IS
        v_ref REF t_sala;
    BEGIN
        SELECT REF(s) INTO v_ref FROM sale s WHERE s.id = p_id;
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20012, 'Nie znaleziono sali o ID: ' || p_id);
    END;

    FUNCTION get_ref_sala_numer(p_numer VARCHAR2) RETURN REF t_sala IS
        v_ref REF t_sala;
    BEGIN
        SELECT REF(s) INTO v_ref FROM sale s WHERE s.numer = p_numer;
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20012, 'Nie znaleziono sali: ' || p_numer);
    END;
    
    FUNCTION get_id_przedmiot(p_nazwa VARCHAR2) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT p.id INTO v_id FROM przedmioty p WHERE p.nazwa = p_nazwa;
        RETURN v_id;
    END;
    
    -- ============================================================================
    -- FUNKCJE INFO - wyświetlanie danych po ID
    -- ============================================================================
    PROCEDURE info_przedmiot(p_id NUMBER) IS
    BEGIN
        FOR r IN (SELECT p.id, p.nazwa, p.typ FROM przedmioty p WHERE p.id = p_id) LOOP
            DBMS_OUTPUT.PUT_LINE('>>> Przedmiot[' || r.id || '] = ' || r.nazwa || ' (' || r.typ || ')');
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('>>> Przedmiot[' || p_id || '] = NIE ISTNIEJE!');
    END;
    
    PROCEDURE info_sala(p_id NUMBER) IS
    BEGIN
        FOR r IN (SELECT s.id, s.numer, s.typ, s.pojemnosc, s.lista_wyposazenia() AS wyp 
                  FROM sale s WHERE s.id = p_id) LOOP
            DBMS_OUTPUT.PUT_LINE('>>> Sala[' || r.id || '] = ' || r.numer || ' (' || r.typ || 
                                 ', max ' || r.pojemnosc || ' os.), wyp: ' || r.wyp);
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('>>> Sala[' || p_id || '] = NIE ISTNIEJE!');
    END;
    
    PROCEDURE info_grupa(p_id NUMBER) IS
        v_cnt NUMBER;
    BEGIN
        FOR r IN (SELECT g.id, g.symbol, g.poziom FROM grupy g WHERE g.id = p_id) LOOP
            SELECT COUNT(*) INTO v_cnt FROM uczniowie u WHERE DEREF(u.ref_grupa).id = p_id;
            DBMS_OUTPUT.PUT_LINE('>>> Grupa[' || r.id || '] = klasa ' || r.poziom || 
                                 ' (symbol ' || r.symbol || '), uczniów: ' || v_cnt);
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('>>> Grupa[' || p_id || '] = NIE ISTNIEJE!');
    END;

    PROCEDURE lista_przedmiotow IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== PRZEDMIOTY ===');
        FOR r IN (SELECT p.id, p.nazwa, p.typ FROM przedmioty p ORDER BY p.id) LOOP
            DBMS_OUTPUT.PUT_LINE(r.id || '. ' || r.nazwa || ' (' || r.typ || ')');
        END LOOP;
    END;

    PROCEDURE lista_sal IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== SALE ===');
        FOR r IN (SELECT s.id, s.numer, s.typ, s.pojemnosc, s.lista_wyposazenia() AS wyp FROM sale s ORDER BY s.id) LOOP
            DBMS_OUTPUT.PUT_LINE(r.id || '. ' || r.numer || ' - ' || r.typ || ', pojemność: ' || r.pojemnosc || ', wyposażenie: ' || r.wyp);
        END LOOP;
    END;

    PROCEDURE lista_grup IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== GRUPY ===');
        FOR r IN (SELECT g.id, g.symbol, g.poziom FROM grupy g ORDER BY g.poziom) LOOP
            DBMS_OUTPUT.PUT_LINE(r.id || '. Klasa ' || r.poziom || ' - grupa ' || r.symbol);
        END LOOP;
    END;

END pkg_slowniki;
/

-- ============================================================================
-- PKG_OSOBY - zarządzanie nauczycielami i uczniami
-- ============================================================================
CREATE OR REPLACE PACKAGE pkg_osoby AS
    PROCEDURE dodaj_nauczyciela(p_imie VARCHAR2, p_nazwisko VARCHAR2, p_przedmioty VARCHAR2);
    PROCEDURE dodaj_ucznia(p_imie VARCHAR2, p_nazwisko VARCHAR2, p_data_ur DATE, p_instrument VARCHAR2, p_grupa VARCHAR2);
    
    FUNCTION get_ref_nauczyciel(p_id NUMBER) RETURN REF t_nauczyciel;
    FUNCTION get_ref_uczen(p_id NUMBER) RETURN REF t_uczen;
    FUNCTION get_id_grupa_ucznia(p_id_ucznia NUMBER) RETURN NUMBER;
    
    -- Funkcje INFO - wyświetlanie co kryje się pod ID
    PROCEDURE info_uczen(p_id NUMBER);
    PROCEDURE info_nauczyciel(p_id NUMBER);
    
    PROCEDURE lista_nauczycieli;
    PROCEDURE lista_uczniow;
    PROCEDURE lista_uczniow_w_grupie(p_id_grupy NUMBER);
END pkg_osoby;
/

CREATE OR REPLACE PACKAGE BODY pkg_osoby AS

    PROCEDURE dodaj_nauczyciela(p_imie VARCHAR2, p_nazwisko VARCHAR2, p_przedmioty VARCHAR2) IS
        v_id NUMBER;
        v_przedmiot VARCHAR2(50);
        v_pos NUMBER;
        v_str VARCHAR2(200) := p_przedmioty;
        v_id_przedmiotu NUMBER;
    BEGIN
        v_id := seq_nauczyciele.NEXTVAL;
        INSERT INTO nauczyciele VALUES (
            t_nauczyciel(v_id, p_imie, p_nazwisko, SYSDATE)
        );
        
        LOOP
            v_pos := INSTR(v_str, ',');
            IF v_pos > 0 THEN
                v_przedmiot := TRIM(SUBSTR(v_str, 1, v_pos - 1));
                v_str := SUBSTR(v_str, v_pos + 1);
            ELSE
                v_przedmiot := TRIM(v_str);
            END IF;
            
            -- Lepsza obsługa błędów - przyjazny komunikat przy nieznanym przedmiocie
            BEGIN
                v_id_przedmiotu := pkg_slowniki.get_id_przedmiot(v_przedmiot);
                INSERT INTO nauczyciel_przedmiot VALUES (v_id, v_id_przedmiotu);
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    -- Wycofaj dodanego nauczyciela i zgłoś czytelny błąd
                    DELETE FROM nauczyciele WHERE id = v_id;
                    RAISE_APPLICATION_ERROR(-20015, 
                        'Nieznany przedmiot: "' || v_przedmiot || '". ' ||
                        'Dostępne przedmioty: użyj pkg_slowniki.lista_przedmiotow() aby wyświetlić listę.');
            END;
            
            EXIT WHEN v_pos = 0;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('Dodano nauczyciela ID=' || v_id || ': ' || p_imie || ' ' || p_nazwisko || ' (przedmioty: ' || p_przedmioty || ')');
    END;

    PROCEDURE dodaj_ucznia(p_imie VARCHAR2, p_nazwisko VARCHAR2, p_data_ur DATE, p_instrument VARCHAR2, p_grupa VARCHAR2) IS
        v_ref_grupa REF t_grupa;
        v_id NUMBER;
    BEGIN
        v_ref_grupa := pkg_slowniki.get_ref_grupa_symbol(p_grupa);
        v_id := seq_uczniowie.NEXTVAL;
        INSERT INTO uczniowie VALUES (
            t_uczen(v_id, p_imie, p_nazwisko, p_data_ur, p_instrument, v_ref_grupa)
        );
        DBMS_OUTPUT.PUT_LINE('Dodano ucznia ID=' || v_id || ': ' || p_imie || ' ' || p_nazwisko || ' (grupa ' || p_grupa || ', ' || p_instrument || ')');
    END;

    FUNCTION get_ref_nauczyciel(p_id NUMBER) RETURN REF t_nauczyciel IS
        v_ref REF t_nauczyciel;
    BEGIN
        SELECT REF(n) INTO v_ref FROM nauczyciele n WHERE n.id = p_id;
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20013, 'Nie znaleziono nauczyciela o ID: ' || p_id);
    END;

    FUNCTION get_ref_uczen(p_id NUMBER) RETURN REF t_uczen IS
        v_ref REF t_uczen;
    BEGIN
        SELECT REF(u) INTO v_ref FROM uczniowie u WHERE u.id = p_id;
        RETURN v_ref;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20014, 'Nie znaleziono ucznia o ID: ' || p_id);
    END;
    
    FUNCTION get_id_grupa_ucznia(p_id_ucznia NUMBER) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT DEREF(u.ref_grupa).id INTO v_id FROM uczniowie u WHERE u.id = p_id_ucznia;
        RETURN v_id;
    END;
    
    -- ============================================================================
    -- FUNKCJE INFO - wyświetlanie danych po ID
    -- ============================================================================
    PROCEDURE info_uczen(p_id NUMBER) IS
    BEGIN
        FOR r IN (
            SELECT u.id, u.pelne_nazwisko() AS nazwa, u.wiek() AS wiek, u.instrument,
                   DEREF(u.ref_grupa).symbol AS grupa
            FROM uczniowie u WHERE u.id = p_id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('>>> Uczeń[' || r.id || '] = ' || r.nazwa || 
                                 ' (lat ' || r.wiek || ', ' || r.instrument || ', grupa ' || r.grupa || ')');
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('>>> Uczeń[' || p_id || '] = NIE ISTNIEJE!');
    END;
    
    PROCEDURE info_nauczyciel(p_id NUMBER) IS
    BEGIN
        FOR r IN (
            SELECT n.id, n.pelne_nazwisko() AS nazwa,
                   (SELECT LISTAGG(p.nazwa, ', ') WITHIN GROUP (ORDER BY p.nazwa)
                    FROM nauczyciel_przedmiot np JOIN przedmioty p ON np.id_przedmiotu = p.id
                    WHERE np.id_nauczyciela = n.id) AS przedmioty
            FROM nauczyciele n WHERE n.id = p_id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('>>> Nauczyciel[' || r.id || '] = ' || r.nazwa || 
                                 ', uczy: ' || NVL(r.przedmioty, 'brak'));
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('>>> Nauczyciel[' || p_id || '] = NIE ISTNIEJE!');
    END;

    PROCEDURE lista_nauczycieli IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== NAUCZYCIELE ===');
        FOR r IN (
            SELECT n.id, n.pelne_nazwisko() AS nazwa,
                   (SELECT LISTAGG(p.nazwa, ', ') WITHIN GROUP (ORDER BY p.nazwa)
                    FROM nauczyciel_przedmiot np JOIN przedmioty p ON np.id_przedmiotu = p.id
                    WHERE np.id_nauczyciela = n.id) AS przedmioty
            FROM nauczyciele n ORDER BY n.id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(r.id || '. ' || r.nazwa || ' - uczy: ' || NVL(r.przedmioty, 'brak'));
        END LOOP;
    END;

    PROCEDURE lista_uczniow IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== UCZNIOWIE ===');
        FOR r IN (
            SELECT u.id, u.pelne_nazwisko() AS nazwa, u.wiek() AS wiek, u.instrument,
                   DEREF(u.ref_grupa).symbol AS grupa
            FROM uczniowie u ORDER BY grupa, u.nazwisko
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(r.id || '. ' || r.nazwa || ' (lat ' || r.wiek || ') - ' || r.instrument || ', grupa ' || r.grupa);
        END LOOP;
    END;

    PROCEDURE lista_uczniow_w_grupie(p_id_grupy NUMBER) IS
        CURSOR c_uczniowie IS
            SELECT u.id, u.pelne_nazwisko() AS nazwa, u.instrument
            FROM uczniowie u
            WHERE DEREF(u.ref_grupa).id = p_id_grupy
            ORDER BY u.nazwisko;
        v_idx NUMBER := 0;
        v_symbol VARCHAR2(10);
    BEGIN
        SELECT g.symbol INTO v_symbol FROM grupy g WHERE g.id = p_id_grupy;
        DBMS_OUTPUT.PUT_LINE('=== UCZNIOWIE W GRUPIE ' || v_symbol || ' (ID=' || p_id_grupy || ') ===');
        FOR r IN c_uczniowie LOOP
            v_idx := v_idx + 1;
            DBMS_OUTPUT.PUT_LINE('  ' || v_idx || '. ' || r.nazwa || ' - ' || r.instrument || ' [ID=' || r.id || ']');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('Razem: ' || v_idx || ' uczniów');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono grupy o ID: ' || p_id_grupy);
    END;

END pkg_osoby;
/

-- ============================================================================
-- PKG_LEKCJE - zarządzanie lekcjami (parametry po ID!)
-- WYMAGANY WYMIAR: 5 lekcji/tydzień na ucznia
-- ============================================================================
CREATE OR REPLACE PACKAGE pkg_lekcje AS
    -- ========================================================================
    -- STAŁE KONFIGURACYJNE - zmień tutaj zamiast w wielu miejscach
    -- ========================================================================
    c_wymagane_lekcje     CONSTANT NUMBER := 5;   -- wymagana liczba lekcji na tydzień
    c_domyslny_czas_min   CONSTANT NUMBER := 45;  -- domyślny czas trwania lekcji (min)
    c_godz_min            CONSTANT NUMBER := 14;  -- najwcześniejsza godzina lekcji
    c_godz_max            CONSTANT NUMBER := 19;  -- najpóźniejsza godzina rozpoczęcia
    
    -- Funkcja pomocnicza: dzień tygodnia 1=Pon, 2=Wt, ..., 7=Nd (niezależne od NLS!)
    FUNCTION dzien_tygodnia(p_data DATE) RETURN NUMBER;
    FUNCTION czy_dzien_roboczy(p_data DATE) RETURN BOOLEAN;
    
    FUNCTION czy_sala_wolna(p_id_sali NUMBER, p_data DATE, p_godz NUMBER) RETURN BOOLEAN;
    FUNCTION czy_nauczyciel_wolny(p_id_nauczyciela NUMBER, p_data DATE, p_godz NUMBER) RETURN BOOLEAN;
    FUNCTION czy_uczen_wolny(p_id_ucznia NUMBER, p_data DATE, p_godz NUMBER) RETURN BOOLEAN;
    FUNCTION czy_grupa_wolna(p_id_grupy NUMBER, p_data DATE, p_godz NUMBER) RETURN BOOLEAN;
    
    -- Liczenie lekcji ucznia w tygodniu
    FUNCTION ile_lekcji_ucznia(p_id_ucznia NUMBER, p_data_w_tygodniu DATE DEFAULT NULL) RETURN NUMBER;
    
    -- Dodawanie lekcji po ID
    PROCEDURE dodaj_lekcje_indywidualna(
        p_id_przedmiotu NUMBER, p_id_nauczyciela NUMBER, p_id_sali NUMBER,
        p_id_ucznia NUMBER, p_data DATE, p_godz NUMBER
    );
    
    PROCEDURE dodaj_lekcje_grupowa(
        p_id_przedmiotu NUMBER, p_id_nauczyciela NUMBER, p_id_sali NUMBER,
        p_id_grupy NUMBER, p_data DATE, p_godz NUMBER
    );
    
    -- Plany po ID
    PROCEDURE plan_ucznia(p_id_ucznia NUMBER);
    PROCEDURE plan_nauczyciela(p_id_nauczyciela NUMBER);
    PROCEDURE plan_sali(p_id_sali NUMBER);
    PROCEDURE plan_dnia(p_data DATE);
    
    -- Raport kompletności (kto ma <5 lekcji)
    PROCEDURE raport_kompletnosci(p_data_w_tygodniu DATE DEFAULT NULL);
END pkg_lekcje;
/

CREATE OR REPLACE PACKAGE BODY pkg_lekcje AS

    -- Dzień tygodnia: 1=Poniedziałek, 7=Niedziela (niezależne od ustawień NLS!)
    FUNCTION dzien_tygodnia(p_data DATE) RETURN NUMBER IS
    BEGIN
        RETURN TRUNC(p_data) - TRUNC(p_data, 'IW') + 1;
    END;
    
    FUNCTION czy_dzien_roboczy(p_data DATE) RETURN BOOLEAN IS
    BEGIN
        RETURN dzien_tygodnia(p_data) BETWEEN 1 AND 5;
    END;

    -- Sprawdza czy przedziały czasowe się nakładają
    -- Lekcja od p_godz trwa c_domyslny_czas_min minut
    FUNCTION czy_sala_wolna(p_id_sali NUMBER, p_data DATE, p_godz NUMBER) RETURN BOOLEAN IS
        v_cnt NUMBER;
        v_nowa_koniec NUMBER := p_godz + (c_domyslny_czas_min / 60);
    BEGIN
        -- Sprawdź czy nowa lekcja nakłada się z istniejącymi
        -- Nakładanie: nowa_start < istniejaca_koniec AND nowa_koniec > istniejaca_start
        SELECT COUNT(*) INTO v_cnt
        FROM lekcje l
        WHERE DEREF(l.ref_sala).id = p_id_sali
          AND l.data_lekcji = p_data
          AND p_godz < (l.godz_rozp + l.czas_min / 60)  -- nowa zaczyna przed końcem istniejącej
          AND v_nowa_koniec > l.godz_rozp;              -- nowa kończy po początku istniejącej
        RETURN v_cnt = 0;
    END;

    FUNCTION czy_nauczyciel_wolny(p_id_nauczyciela NUMBER, p_data DATE, p_godz NUMBER) RETURN BOOLEAN IS
        v_cnt NUMBER;
        v_nowa_koniec NUMBER := p_godz + (c_domyslny_czas_min / 60);
    BEGIN
        SELECT COUNT(*) INTO v_cnt
        FROM lekcje l
        WHERE DEREF(l.ref_nauczyciel).id = p_id_nauczyciela
          AND l.data_lekcji = p_data
          AND p_godz < (l.godz_rozp + l.czas_min / 60)
          AND v_nowa_koniec > l.godz_rozp;
        RETURN v_cnt = 0;
    END;

    FUNCTION czy_uczen_wolny(p_id_ucznia NUMBER, p_data DATE, p_godz NUMBER) RETURN BOOLEAN IS
        v_cnt NUMBER;
        v_id_grupy NUMBER;
        v_nowa_koniec NUMBER := p_godz + (c_domyslny_czas_min / 60);
    BEGIN
        -- Sprawdź lekcje indywidualne ucznia
        SELECT COUNT(*) INTO v_cnt
        FROM lekcje l
        WHERE DEREF(l.ref_uczen).id = p_id_ucznia
          AND l.data_lekcji = p_data
          AND p_godz < (l.godz_rozp + l.czas_min / 60)
          AND v_nowa_koniec > l.godz_rozp;
        
        IF v_cnt > 0 THEN RETURN FALSE; END IF;
        
        -- Sprawdź lekcje grupowe dla grupy ucznia
        v_id_grupy := pkg_osoby.get_id_grupa_ucznia(p_id_ucznia);
        
        SELECT COUNT(*) INTO v_cnt
        FROM lekcje l
        WHERE DEREF(l.ref_grupa).id = v_id_grupy
          AND l.data_lekcji = p_data
          AND p_godz < (l.godz_rozp + l.czas_min / 60)
          AND v_nowa_koniec > l.godz_rozp;
        
        RETURN v_cnt = 0;
    END;
    
    -- NOWA FUNKCJA: Sprawdza czy ŻADEN uczeń z grupy nie ma kolizji z lekcją indywidualną
    FUNCTION czy_grupa_wolna(p_id_grupy NUMBER, p_data DATE, p_godz NUMBER) RETURN BOOLEAN IS
        v_cnt NUMBER;
        v_nowa_koniec NUMBER := p_godz + (c_domyslny_czas_min / 60);
    BEGIN
        -- Sprawdź czy którykolwiek uczeń z tej grupy ma lekcję indywidualną w tym czasie
        SELECT COUNT(*) INTO v_cnt
        FROM lekcje l
        WHERE l.ref_uczen IS NOT NULL  -- tylko lekcje indywidualne
          AND l.data_lekcji = p_data
          AND p_godz < (l.godz_rozp + l.czas_min / 60)
          AND v_nowa_koniec > l.godz_rozp
          AND DEREF(l.ref_uczen).id IN (
              SELECT u.id FROM uczniowie u WHERE DEREF(u.ref_grupa).id = p_id_grupy
          );
        
        RETURN v_cnt = 0;
    END;
    
    -- ============================================================================
    -- LICZENIE LEKCJI UCZNIA W TYGODNIU
    -- ============================================================================
    FUNCTION ile_lekcji_ucznia(p_id_ucznia NUMBER, p_data_w_tygodniu DATE DEFAULT NULL) RETURN NUMBER IS
        v_poczatek_tyg DATE;
        v_koniec_tyg DATE;
        v_data DATE := NVL(p_data_w_tygodniu, SYSDATE);
        v_cnt_indyw NUMBER;
        v_cnt_grupowe NUMBER;
        v_id_grupy NUMBER;
    BEGIN
        -- Oblicz początek i koniec tygodnia ISO
        v_poczatek_tyg := TRUNC(v_data, 'IW');
        v_koniec_tyg := v_poczatek_tyg + 4; -- Pt
        
        v_id_grupy := pkg_osoby.get_id_grupa_ucznia(p_id_ucznia);
        
        -- Policz lekcje indywidualne
        SELECT COUNT(*) INTO v_cnt_indyw
        FROM lekcje l
        WHERE DEREF(l.ref_uczen).id = p_id_ucznia
          AND l.data_lekcji BETWEEN v_poczatek_tyg AND v_koniec_tyg;
        
        -- Policz lekcje grupowe
        SELECT COUNT(*) INTO v_cnt_grupowe
        FROM lekcje l
        WHERE DEREF(l.ref_grupa).id = v_id_grupy
          AND l.data_lekcji BETWEEN v_poczatek_tyg AND v_koniec_tyg;
        
        RETURN v_cnt_indyw + v_cnt_grupowe;
    END;

    PROCEDURE dodaj_lekcje_indywidualna(
        p_id_przedmiotu NUMBER, p_id_nauczyciela NUMBER, p_id_sali NUMBER,
        p_id_ucznia NUMBER, p_data DATE, p_godz NUMBER
    ) IS
        v_sala_numer VARCHAR2(10);
        v_nauczyciel VARCHAR2(100);
        v_uczen VARCHAR2(100);
        v_przedmiot VARCHAR2(50);
        v_ile_lekcji NUMBER;
    BEGIN
        IF NOT czy_dzien_roboczy(p_data) THEN
            RAISE_APPLICATION_ERROR(-20008, 'Lekcje tylko w dni robocze (Pon-Pt). Data: ' || TO_CHAR(p_data, 'YYYY-MM-DD DY'));
        END IF;
        
        SELECT s.numer INTO v_sala_numer FROM sale s WHERE s.id = p_id_sali;
        SELECT n.pelne_nazwisko() INTO v_nauczyciel FROM nauczyciele n WHERE n.id = p_id_nauczyciela;
        SELECT u.pelne_nazwisko() INTO v_uczen FROM uczniowie u WHERE u.id = p_id_ucznia;
        SELECT p.nazwa INTO v_przedmiot FROM przedmioty p WHERE p.id = p_id_przedmiotu;
        
        -- WALIDACJA LIMITU 5 LEKCJI NA TYDZIEŃ
        v_ile_lekcji := ile_lekcji_ucznia(p_id_ucznia, p_data);
        IF v_ile_lekcji >= c_wymagane_lekcje THEN
            RAISE_APPLICATION_ERROR(-20010, 
                'Uczeń ' || v_uczen || ' ma już ' || v_ile_lekcji || ' lekcji w tym tygodniu (max ' || c_wymagane_lekcje || ').');
        END IF;
        
        IF NOT czy_sala_wolna(p_id_sali, p_data, p_godz) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Sala ' || v_sala_numer || ' zajęta o ' || p_godz || ':00');
        END IF;
        
        IF NOT czy_nauczyciel_wolny(p_id_nauczyciela, p_data, p_godz) THEN
            RAISE_APPLICATION_ERROR(-20002, 'Nauczyciel ' || v_nauczyciel || ' zajęty o ' || p_godz || ':00');
        END IF;
        
        IF NOT czy_uczen_wolny(p_id_ucznia, p_data, p_godz) THEN
            RAISE_APPLICATION_ERROR(-20003, 'Uczeń ' || v_uczen || ' zajęty o ' || p_godz || ':00');
        END IF;
        
        INSERT INTO lekcje VALUES (
            t_lekcja(
                seq_lekcje.NEXTVAL,
                pkg_slowniki.get_ref_przedmiot(p_id_przedmiotu),
                pkg_osoby.get_ref_nauczyciel(p_id_nauczyciela),
                pkg_slowniki.get_ref_sala(p_id_sali),
                pkg_osoby.get_ref_uczen(p_id_ucznia),
                NULL,
                p_data,
                p_godz,
                c_domyslny_czas_min  -- użycie stałej zamiast hardcoded 45
            )
        );
        DBMS_OUTPUT.PUT_LINE('Lekcja indyw.: ' || v_uczen || ', ' || v_przedmiot || 
                             ' (' || TO_CHAR(p_data, 'DY DD.MM') || ' ' || p_godz || ':00, sala ' || v_sala_numer || ')');
    END;

    PROCEDURE dodaj_lekcje_grupowa(
        p_id_przedmiotu NUMBER, p_id_nauczyciela NUMBER, p_id_sali NUMBER,
        p_id_grupy NUMBER, p_data DATE, p_godz NUMBER
    ) IS
        v_sala_numer VARCHAR2(10);
        v_nauczyciel VARCHAR2(100);
        v_grupa VARCHAR2(10);
        v_przedmiot VARCHAR2(50);
        v_konflikt_uczniowie VARCHAR2(500);
        v_przekroczeni_uczniowie VARCHAR2(500);
    BEGIN
        IF NOT czy_dzien_roboczy(p_data) THEN
            RAISE_APPLICATION_ERROR(-20008, 'Lekcje tylko w dni robocze (Pon-Pt). Data: ' || TO_CHAR(p_data, 'YYYY-MM-DD DY'));
        END IF;
        
        SELECT s.numer INTO v_sala_numer FROM sale s WHERE s.id = p_id_sali;
        SELECT n.pelne_nazwisko() INTO v_nauczyciel FROM nauczyciele n WHERE n.id = p_id_nauczyciela;
        SELECT g.symbol INTO v_grupa FROM grupy g WHERE g.id = p_id_grupy;
        SELECT p.nazwa INTO v_przedmiot FROM przedmioty p WHERE p.id = p_id_przedmiotu;
        
        -- =====================================================================
        -- WALIDACJA LIMITU 5 LEKCJI - sprawdź czy każdy uczeń z grupy może mieć kolejną lekcję
        -- =====================================================================
        SELECT LISTAGG(u.pelne_nazwisko() || ' (' || ile_lekcji_ucznia(u.id, p_data) || ')', ', ') 
               WITHIN GROUP (ORDER BY u.nazwisko)
        INTO v_przekroczeni_uczniowie
        FROM uczniowie u
        WHERE DEREF(u.ref_grupa).id = p_id_grupy
          AND ile_lekcji_ucznia(u.id, p_data) >= c_wymagane_lekcje;
        
        IF v_przekroczeni_uczniowie IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20010, 
                'Uczniowie z grupy ' || v_grupa || ' przekroczyli limit ' || c_wymagane_lekcje || ' lekcji/tydzień: ' || v_przekroczeni_uczniowie);
        END IF;
        
        IF NOT czy_sala_wolna(p_id_sali, p_data, p_godz) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Sala ' || v_sala_numer || ' zajęta o ' || p_godz || ':00');
        END IF;
        
        IF NOT czy_nauczyciel_wolny(p_id_nauczyciela, p_data, p_godz) THEN
            RAISE_APPLICATION_ERROR(-20002, 'Nauczyciel ' || v_nauczyciel || ' zajęty o ' || p_godz || ':00');
        END IF;
        
        -- =====================================================================
        -- NOWE: Sprawdzenie czy uczniowie z grupy nie mają kolizji indywidualnych
        -- =====================================================================
        IF NOT czy_grupa_wolna(p_id_grupy, p_data, p_godz) THEN
            -- Znajdź którzy uczniowie mają konflikt (dla komunikatu błędu)
            SELECT LISTAGG(u.pelne_nazwisko(), ', ') WITHIN GROUP (ORDER BY u.nazwisko)
            INTO v_konflikt_uczniowie
            FROM uczniowie u
            WHERE DEREF(u.ref_grupa).id = p_id_grupy
              AND u.id IN (
                  SELECT DEREF(l.ref_uczen).id
                  FROM lekcje l
                  WHERE l.ref_uczen IS NOT NULL
                    AND l.data_lekcji = p_data
                    AND p_godz < (l.godz_rozp + l.czas_min / 60)
                    AND (p_godz + c_domyslny_czas_min / 60) > l.godz_rozp
              );
            RAISE_APPLICATION_ERROR(-20009, 
                'Uczniowie z grupy ' || v_grupa || ' mają kolizję z lekcją indywidualną o ' || p_godz || ':00: ' || v_konflikt_uczniowie);
        END IF;
        
        INSERT INTO lekcje VALUES (
            t_lekcja(
                seq_lekcje.NEXTVAL,
                pkg_slowniki.get_ref_przedmiot(p_id_przedmiotu),
                pkg_osoby.get_ref_nauczyciel(p_id_nauczyciela),
                pkg_slowniki.get_ref_sala(p_id_sali),
                NULL,
                pkg_slowniki.get_ref_grupa(p_id_grupy),
                p_data,
                p_godz,
                c_domyslny_czas_min  -- użycie stałej zamiast hardcoded 45
            )
        );
        DBMS_OUTPUT.PUT_LINE('Lekcja grupowa: klasa ' || v_grupa || ', ' || v_przedmiot || 
                             ' (' || TO_CHAR(p_data, 'DY DD.MM') || ' ' || p_godz || ':00, sala ' || v_sala_numer || ')');
    END;

    PROCEDURE plan_ucznia(p_id_ucznia NUMBER) IS
        v_uczen VARCHAR2(100);
        v_id_grupy NUMBER;
        v_ile_lekcji NUMBER;
        v_pierwsza_data DATE;
    BEGIN
        SELECT u.pelne_nazwisko() INTO v_uczen FROM uczniowie u WHERE u.id = p_id_ucznia;
        v_id_grupy := pkg_osoby.get_id_grupa_ucznia(p_id_ucznia);
        
        -- Znajdź datę pierwszej lekcji ucznia, aby obliczyć tydzień
        BEGIN
            SELECT MIN(l.data_lekcji) INTO v_pierwsza_data
            FROM lekcje l
            WHERE DEREF(l.ref_uczen).id = p_id_ucznia
               OR DEREF(l.ref_grupa).id = v_id_grupy;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN v_pierwsza_data := SYSDATE;
        END;
        
        v_ile_lekcji := ile_lekcji_ucznia(p_id_ucznia, v_pierwsza_data);
        
        DBMS_OUTPUT.PUT_LINE('=== PLAN UCZNIA: ' || v_uczen || ' (ID=' || p_id_ucznia || ') ===');
        DBMS_OUTPUT.PUT_LINE('Tydzień: ' || TO_CHAR(TRUNC(v_pierwsza_data, 'IW'), 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Liczba lekcji w tym tygodniu: ' || v_ile_lekcji || '/' || c_wymagane_lekcje ||
                             CASE WHEN v_ile_lekcji < c_wymagane_lekcje THEN ' [NIEKOMPLETNY!]' ELSE ' [OK]' END);
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 60, '-'));
        
        FOR r IN (
            SELECT l.data_lekcji, l.godz_rozp,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
                   DEREF(l.ref_sala).numer AS sala,
                   l.czy_indywidualna() AS indyw
            FROM lekcje l
            WHERE DEREF(l.ref_uczen).id = p_id_ucznia
               OR DEREF(l.ref_grupa).id = v_id_grupy
            ORDER BY l.data_lekcji, l.godz_rozp
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(r.data_lekcji, 'DY DD.MM') || ' ' || r.godz_rozp || ':00 - ' || 
                                 r.przedmiot || ' (sala ' || r.sala || ', ' || r.nauczyciel || ')' ||
                                 CASE WHEN r.indyw = 'N' THEN ' [GRUPOWA]' ELSE '' END);
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono ucznia o ID: ' || p_id_ucznia);
    END;

    PROCEDURE plan_nauczyciela(p_id_nauczyciela NUMBER) IS
        v_nauczyciel VARCHAR2(100);
    BEGIN
        SELECT n.pelne_nazwisko() INTO v_nauczyciel FROM nauczyciele n WHERE n.id = p_id_nauczyciela;
        
        DBMS_OUTPUT.PUT_LINE('=== PLAN NAUCZYCIELA: ' || v_nauczyciel || ' (ID=' || p_id_nauczyciela || ') ===');
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
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono nauczyciela o ID: ' || p_id_nauczyciela);
    END;

    PROCEDURE plan_sali(p_id_sali NUMBER) IS
        v_numer VARCHAR2(10);
    BEGIN
        SELECT s.numer INTO v_numer FROM sale s WHERE s.id = p_id_sali;
        
        DBMS_OUTPUT.PUT_LINE('=== OBŁOŻENIE SALI: ' || v_numer || ' (ID=' || p_id_sali || ') ===');
        FOR r IN (
            SELECT l.data_lekcji, l.godz_rozp,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel
            FROM lekcje l
            WHERE DEREF(l.ref_sala).id = p_id_sali
            ORDER BY l.data_lekcji, l.godz_rozp
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(r.data_lekcji, 'DY DD.MM') || ' ' || r.godz_rozp || ':00 - ' || 
                                 r.przedmiot || ' (' || r.nauczyciel || ')');
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono sali o ID: ' || p_id_sali);
    END;

    PROCEDURE plan_dnia(p_data DATE) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== PLAN DNIA: ' || TO_CHAR(p_data, 'YYYY-MM-DD (DY)') || ' ===');
        DBMS_OUTPUT.PUT_LINE('Dzień tygodnia: ' || dzien_tygodnia(p_data) || ' (1=Pon, 5=Pt, 6=Sob, 7=Nd)');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 70, '-'));
        
        FOR r IN (
            SELECT l.godz_rozp,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
                   DEREF(l.ref_sala).numer AS sala,
                   CASE WHEN l.ref_uczen IS NOT NULL 
                        THEN DEREF(l.ref_uczen).pelne_nazwisko()
                        ELSE 'grupa ' || DEREF(l.ref_grupa).symbol
                   END AS kto
            FROM lekcje l
            WHERE l.data_lekcji = p_data
            ORDER BY l.godz_rozp, sala
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(r.godz_rozp || ':00 | sala ' || r.sala || ' | ' || 
                                 RPAD(r.przedmiot, 20) || ' | ' || RPAD(r.nauczyciel, 15) || ' | ' || r.kto);
        END LOOP;
    END;
    
    -- ============================================================================
    -- RAPORT KOMPLETNOŚCI - kto ma mniej niż 5 lekcji
    -- ============================================================================
    PROCEDURE raport_kompletnosci(p_data_w_tygodniu DATE DEFAULT NULL) IS
        v_data DATE := NVL(p_data_w_tygodniu, SYSDATE);
        v_poczatek_tyg DATE := TRUNC(v_data, 'IW');
        v_cnt_ok NUMBER := 0;
        v_cnt_nok NUMBER := 0;
        v_ile NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== RAPORT KOMPLETNOŚCI PLANU ===');
        DBMS_OUTPUT.PUT_LINE('Tydzień od: ' || TO_CHAR(v_poczatek_tyg, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Wymagane lekcji: ' || c_wymagane_lekcje || '/tydzień');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 60, '-'));
        
        FOR r IN (
            SELECT u.id, u.pelne_nazwisko() AS nazwa, DEREF(u.ref_grupa).symbol AS grupa
            FROM uczniowie u
            ORDER BY grupa, u.nazwisko
        ) LOOP
            v_ile := ile_lekcji_ucznia(r.id, v_data);
            
            IF v_ile < c_wymagane_lekcje THEN
                DBMS_OUTPUT.PUT_LINE('[BRAK ' || (c_wymagane_lekcje - v_ile) || '] ' || 
                                     r.nazwa || ' (ID=' || r.id || ', ' || r.grupa || ') - ma: ' || v_ile);
                v_cnt_nok := v_cnt_nok + 1;
            ELSE
                v_cnt_ok := v_cnt_ok + 1;
            END IF;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 60, '-'));
        DBMS_OUTPUT.PUT_LINE('KOMPLETNI: ' || v_cnt_ok || ' uczniów');
        DBMS_OUTPUT.PUT_LINE('NIEKOMPLETNI: ' || v_cnt_nok || ' uczniów');
    END;

END pkg_lekcje;
/

-- ============================================================================
-- PKG_OCENY - zarządzanie ocenami (parametry po ID!)
-- ============================================================================
CREATE OR REPLACE PACKAGE pkg_oceny AS
    PROCEDURE wystaw_ocene(p_id_ucznia NUMBER, p_id_nauczyciela NUMBER, 
                           p_id_przedmiotu NUMBER, p_wartosc NUMBER);
    -- Wersja VERBOSE - wyświetla co kryje się pod każdym ID
    PROCEDURE wystaw_ocene_verbose(p_id_ucznia NUMBER, p_id_nauczyciela NUMBER, 
                                   p_id_przedmiotu NUMBER, p_wartosc NUMBER);
    PROCEDURE wystaw_ocene_semestralna(p_id_ucznia NUMBER, p_id_nauczyciela NUMBER,
                                       p_id_przedmiotu NUMBER, p_wartosc NUMBER);
    PROCEDURE oceny_ucznia(p_id_ucznia NUMBER);
    FUNCTION srednia_ucznia(p_id_ucznia NUMBER, p_id_przedmiotu NUMBER) RETURN NUMBER;
    PROCEDURE raport_ocen_grupy(p_id_grupy NUMBER);
END pkg_oceny;
/

CREATE OR REPLACE PACKAGE BODY pkg_oceny AS

    PROCEDURE wystaw_ocene(p_id_ucznia NUMBER, p_id_nauczyciela NUMBER,
                           p_id_przedmiotu NUMBER, p_wartosc NUMBER) IS
        v_uczen VARCHAR2(100);
        v_przedmiot VARCHAR2(50);
    BEGIN
        SELECT u.pelne_nazwisko() INTO v_uczen FROM uczniowie u WHERE u.id = p_id_ucznia;
        SELECT p.nazwa INTO v_przedmiot FROM przedmioty p WHERE p.id = p_id_przedmiotu;
        
        INSERT INTO oceny VALUES (
            t_ocena(
                seq_oceny.NEXTVAL,
                pkg_osoby.get_ref_uczen(p_id_ucznia),
                pkg_osoby.get_ref_nauczyciel(p_id_nauczyciela),
                pkg_slowniki.get_ref_przedmiot(p_id_przedmiotu),
                p_wartosc,
                SYSDATE,
                'N'
            )
        );
        DBMS_OUTPUT.PUT_LINE('Ocena ' || p_wartosc || ' dla ' || v_uczen || ' z ' || v_przedmiot);
    END;
    
    -- ============================================================================
    -- WERSJA VERBOSE - wyświetla szczegóły każdego ID przed zapisem
    -- ============================================================================
    PROCEDURE wystaw_ocene_verbose(p_id_ucznia NUMBER, p_id_nauczyciela NUMBER, 
                                   p_id_przedmiotu NUMBER, p_wartosc NUMBER) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== WYSTAWIAM OCENĘ ===');
        pkg_osoby.info_uczen(p_id_ucznia);
        pkg_osoby.info_nauczyciel(p_id_nauczyciela);
        pkg_slowniki.info_przedmiot(p_id_przedmiotu);
        DBMS_OUTPUT.PUT_LINE('>>> Wartość: ' || p_wartosc);
        DBMS_OUTPUT.PUT_LINE('-----------------------');
        
        wystaw_ocene(p_id_ucznia, p_id_nauczyciela, p_id_przedmiotu, p_wartosc);
    END;

    PROCEDURE wystaw_ocene_semestralna(p_id_ucznia NUMBER, p_id_nauczyciela NUMBER,
                                       p_id_przedmiotu NUMBER, p_wartosc NUMBER) IS
        v_uczen VARCHAR2(100);
        v_przedmiot VARCHAR2(50);
    BEGIN
        SELECT u.pelne_nazwisko() INTO v_uczen FROM uczniowie u WHERE u.id = p_id_ucznia;
        SELECT p.nazwa INTO v_przedmiot FROM przedmioty p WHERE p.id = p_id_przedmiotu;
        
        INSERT INTO oceny VALUES (
            t_ocena(
                seq_oceny.NEXTVAL,
                pkg_osoby.get_ref_uczen(p_id_ucznia),
                pkg_osoby.get_ref_nauczyciel(p_id_nauczyciela),
                pkg_slowniki.get_ref_przedmiot(p_id_przedmiotu),
                p_wartosc,
                SYSDATE,
                'T'
            )
        );
        DBMS_OUTPUT.PUT_LINE('Ocena SEMESTRALNA ' || p_wartosc || ' dla ' || v_uczen || ' z ' || v_przedmiot);
    END;

    PROCEDURE oceny_ucznia(p_id_ucznia NUMBER) IS
        v_uczen VARCHAR2(100);
    BEGIN
        SELECT u.pelne_nazwisko() INTO v_uczen FROM uczniowie u WHERE u.id = p_id_ucznia;
        
        DBMS_OUTPUT.PUT_LINE('=== OCENY UCZNIA: ' || v_uczen || ' (ID=' || p_id_ucznia || ') ===');
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
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono ucznia o ID: ' || p_id_ucznia);
    END;

    FUNCTION srednia_ucznia(p_id_ucznia NUMBER, p_id_przedmiotu NUMBER) RETURN NUMBER IS
        v_srednia NUMBER;
    BEGIN
        SELECT AVG(o.wartosc) INTO v_srednia
        FROM oceny o
        WHERE DEREF(o.ref_uczen).id = p_id_ucznia
          AND DEREF(o.ref_przedmiot).id = p_id_przedmiotu
          AND o.semestralna = 'N';
        RETURN ROUND(v_srednia, 2);
    END;

    PROCEDURE raport_ocen_grupy(p_id_grupy NUMBER) IS
        v_symbol VARCHAR2(10);
    BEGIN
        SELECT g.symbol INTO v_symbol FROM grupy g WHERE g.id = p_id_grupy;
        
        DBMS_OUTPUT.PUT_LINE('=== OCENY GRUPY ' || v_symbol || ' (ID=' || p_id_grupy || ') ===');
        FOR r IN (
            SELECT u.pelne_nazwisko() AS uczen,
                   (SELECT ROUND(AVG(o.wartosc), 2) FROM oceny o 
                    WHERE DEREF(o.ref_uczen).id = u.id AND o.semestralna = 'N') AS srednia
            FROM uczniowie u
            WHERE DEREF(u.ref_grupa).id = p_id_grupy
            ORDER BY u.nazwisko
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(r.uczen || ' - średnia: ' || NVL(TO_CHAR(r.srednia), 'brak ocen'));
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono grupy o ID: ' || p_id_grupy);
    END;

END pkg_oceny;
/

-- ============================================================================
-- PKG_RAPORTY - raporty i statystyki
-- ============================================================================
CREATE OR REPLACE PACKAGE pkg_raporty AS
    PROCEDURE raport_grup;
    PROCEDURE raport_nauczycieli;
    PROCEDURE statystyki_lekcji;
    PROCEDURE statystyki_ogolne;
END pkg_raporty;
/

CREATE OR REPLACE PACKAGE BODY pkg_raporty AS

    PROCEDURE raport_grup IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== RAPORT GRUP ===');
        FOR r IN (
            SELECT g.id, g.symbol, g.poziom,
                   (SELECT COUNT(*) FROM uczniowie u WHERE DEREF(u.ref_grupa).id = g.id) AS liczba_uczniow
            FROM grupy g ORDER BY g.poziom
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('ID=' || r.id || ' | Klasa ' || r.poziom || ' (grupa ' || r.symbol || '): ' || r.liczba_uczniow || ' uczniów');
        END LOOP;
    END;

    PROCEDURE raport_nauczycieli IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== RAPORT NAUCZYCIELI ===');
        FOR r IN (
            SELECT n.id, n.pelne_nazwisko() AS nazwa,
                   (SELECT COUNT(*) FROM lekcje l WHERE DEREF(l.ref_nauczyciel).id = n.id) AS liczba_lekcji,
                   (SELECT LISTAGG(p.nazwa, ', ') WITHIN GROUP (ORDER BY p.nazwa)
                    FROM nauczyciel_przedmiot np JOIN przedmioty p ON np.id_przedmiotu = p.id
                    WHERE np.id_nauczyciela = n.id) AS przedmioty
            FROM nauczyciele n ORDER BY n.id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('ID=' || r.id || ' | ' || r.nazwa || ' - ' || r.liczba_lekcji || ' lekcji, uczy: ' || NVL(r.przedmioty, '-'));
        END LOOP;
    END;

    PROCEDURE statystyki_lekcji IS
        v_indyw NUMBER;
        v_grupowe NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_indyw FROM lekcje l WHERE l.ref_uczen IS NOT NULL;
        SELECT COUNT(*) INTO v_grupowe FROM lekcje l WHERE l.ref_grupa IS NOT NULL;
        
        DBMS_OUTPUT.PUT_LINE('=== STATYSTYKI LEKCJI ===');
        DBMS_OUTPUT.PUT_LINE('Lekcje indywidualne: ' || v_indyw);
        DBMS_OUTPUT.PUT_LINE('Lekcje grupowe: ' || v_grupowe);
        DBMS_OUTPUT.PUT_LINE('RAZEM: ' || (v_indyw + v_grupowe));
    END;

    PROCEDURE statystyki_ogolne IS
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
            DBMS_OUTPUT.PUT_LINE('Lekcji w planie: ' || r.lekcje);
            DBMS_OUTPUT.PUT_LINE('Ocen wystawionych: ' || r.oceny);
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
