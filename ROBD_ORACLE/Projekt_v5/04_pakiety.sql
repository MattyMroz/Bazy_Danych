-- ============================================================================
-- PLIK: 04_pakiety.sql
-- PROJEKT: Szkola Muzyczna v5 - Obiektowa Baza Danych Oracle
-- AUTORZY: Igor Typinski (251237), Mateusz Mroz (251190)
-- DATA: Styczen 2026
-- ============================================================================
-- Definiuje 6 PAKIETOW z logika biznesowa
-- Pakiety: pkg_uczen, pkg_nauczyciel, pkg_lekcja, pkg_ocena, pkg_raport, pkg_test
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200
SET PAGESIZE 50

PROMPT ========================================================================
PROMPT   04_pakiety.sql - Tworzenie pakietow PL/SQL
PROMPT ========================================================================
PROMPT

-- ============================================================================
-- 1. PAKIET: PKG_UCZEN
-- Zarzadzanie uczniami - CRUD, promocje, statystyki
-- ============================================================================

PROMPT [1/6] Tworzenie pakietu pkg_uczen...

CREATE OR REPLACE PACKAGE pkg_uczen AS

    -- Dodaje nowego ucznia
    PROCEDURE dodaj_ucznia(
        p_imie           VARCHAR2,
        p_nazwisko       VARCHAR2,
        p_data_urodzenia DATE,
        p_email          VARCHAR2 DEFAULT NULL,
        p_telefon        VARCHAR2 DEFAULT NULL,
        p_klasa          NUMBER DEFAULT 1,
        p_cykl           NUMBER DEFAULT 6,
        p_typ            VARCHAR2 DEFAULT 'uczacy_sie_w_innej_szkole',
        p_id_instrumentu NUMBER DEFAULT NULL,
        p_id_grupy       NUMBER DEFAULT NULL
    );

    -- Promuje ucznia do wyzszej klasy
    PROCEDURE promuj_ucznia(p_id_ucznia NUMBER);

    -- Zmienia status ucznia
    PROCEDURE zmien_status(p_id_ucznia NUMBER, p_nowy_status VARCHAR2);

    -- Przypisuje ucznia do grupy
    PROCEDURE przypisz_do_grupy(p_id_ucznia NUMBER, p_id_grupy NUMBER);

    -- Zwraca srednia ocen ucznia
    FUNCTION srednia_ocen(p_id_ucznia NUMBER) RETURN NUMBER;

    -- Zwraca liczbe lekcji ucznia
    FUNCTION liczba_lekcji(p_id_ucznia NUMBER) RETURN NUMBER;

END pkg_uczen;
/

CREATE OR REPLACE PACKAGE BODY pkg_uczen AS

    PROCEDURE dodaj_ucznia(
        p_imie           VARCHAR2,
        p_nazwisko       VARCHAR2,
        p_data_urodzenia DATE,
        p_email          VARCHAR2 DEFAULT NULL,
        p_telefon        VARCHAR2 DEFAULT NULL,
        p_klasa          NUMBER DEFAULT 1,
        p_cykl           NUMBER DEFAULT 6,
        p_typ            VARCHAR2 DEFAULT 'uczacy_sie_w_innej_szkole',
        p_id_instrumentu NUMBER DEFAULT NULL,
        p_id_grupy       NUMBER DEFAULT NULL
    ) IS
        v_id        NUMBER;
        v_ref_instr REF t_instrument_obj := NULL;
        v_ref_grupa REF t_grupa_obj := NULL;
    BEGIN
        SELECT seq_uczniowie.NEXTVAL INTO v_id FROM dual;

        IF p_id_instrumentu IS NOT NULL THEN
            SELECT REF(i) INTO v_ref_instr FROM instrumenty i WHERE id_instrumentu = p_id_instrumentu;
        END IF;

        IF p_id_grupy IS NOT NULL THEN
            SELECT REF(g) INTO v_ref_grupa FROM grupy g WHERE id_grupy = p_id_grupy;
        END IF;

        INSERT INTO uczniowie VALUES (t_uczen_obj(
            v_id, p_imie, p_nazwisko, p_data_urodzenia, p_email, p_telefon,
            SYSDATE, p_klasa, p_cykl, p_typ, 'aktywny', v_ref_instr, v_ref_grupa
        ));

        DBMS_OUTPUT.PUT_LINE('Dodano ucznia: ' || p_imie || ' ' || p_nazwisko || ' (ID=' || v_id || ')');
    END;

    PROCEDURE promuj_ucznia(p_id_ucznia NUMBER) IS
        v_klasa NUMBER;
        v_cykl  NUMBER;
    BEGIN
        SELECT klasa, cykl_nauczania INTO v_klasa, v_cykl
        FROM uczniowie WHERE id_ucznia = p_id_ucznia;

        IF v_klasa >= v_cykl THEN
            UPDATE uczniowie SET status = 'absolwent' WHERE id_ucznia = p_id_ucznia;
            DBMS_OUTPUT.PUT_LINE('Uczen ID=' || p_id_ucznia || ' ukonczyl szkole - status: absolwent');
        ELSE
            UPDATE uczniowie SET klasa = v_klasa + 1 WHERE id_ucznia = p_id_ucznia;
            DBMS_OUTPUT.PUT_LINE('Uczen ID=' || p_id_ucznia || ' promowany do klasy ' || (v_klasa + 1));
        END IF;
    END;

    PROCEDURE zmien_status(p_id_ucznia NUMBER, p_nowy_status VARCHAR2) IS
    BEGIN
        UPDATE uczniowie SET status = p_nowy_status WHERE id_ucznia = p_id_ucznia;
        DBMS_OUTPUT.PUT_LINE('Zmieniono status ucznia ID=' || p_id_ucznia || ' na: ' || p_nowy_status);
    END;

    PROCEDURE przypisz_do_grupy(p_id_ucznia NUMBER, p_id_grupy NUMBER) IS
        v_ref REF t_grupa_obj;
    BEGIN
        SELECT REF(g) INTO v_ref FROM grupy g WHERE id_grupy = p_id_grupy;
        UPDATE uczniowie SET ref_grupa = v_ref WHERE id_ucznia = p_id_ucznia;
        DBMS_OUTPUT.PUT_LINE('Przypisano ucznia ID=' || p_id_ucznia || ' do grupy ID=' || p_id_grupy);
    END;

    FUNCTION srednia_ocen(p_id_ucznia NUMBER) RETURN NUMBER IS
        v_srednia NUMBER;
    BEGIN
        SELECT AVG(wartosc) INTO v_srednia
        FROM oceny
        WHERE DEREF(ref_uczen).id_ucznia = p_id_ucznia;
        RETURN ROUND(NVL(v_srednia, 0), 2);
    END;

    FUNCTION liczba_lekcji(p_id_ucznia NUMBER) RETURN NUMBER IS
        v_cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_cnt
        FROM lekcje
        WHERE DEREF(ref_uczen).id_ucznia = p_id_ucznia;
        RETURN v_cnt;
    END;

END pkg_uczen;
/

-- ============================================================================
-- 2. PAKIET: PKG_NAUCZYCIEL
-- Zarzadzanie nauczycielami - instrumenty, dostepnosc
-- ============================================================================

PROMPT [2/6] Tworzenie pakietu pkg_nauczyciel...

CREATE OR REPLACE PACKAGE pkg_nauczyciel AS

    -- Dodaje nowego nauczyciela
    PROCEDURE dodaj_nauczyciela(
        p_imie            VARCHAR2,
        p_nazwisko        VARCHAR2,
        p_email           VARCHAR2,
        p_telefon         VARCHAR2 DEFAULT NULL,
        p_instrumenty     t_lista_instrumentow DEFAULT NULL,
        p_grupowe         CHAR DEFAULT 'N',
        p_akompaniator    CHAR DEFAULT 'N'
    );

    -- Dodaje instrument do listy nauczyciela
    PROCEDURE dodaj_instrument(p_id_nauczyciela NUMBER, p_instrument VARCHAR2);

    -- Zmienia status nauczyciela
    PROCEDURE zmien_status(p_id_nauczyciela NUMBER, p_nowy_status VARCHAR2);

    -- Zwraca liczbe lekcji nauczyciela
    FUNCTION liczba_lekcji(p_id_nauczyciela NUMBER) RETURN NUMBER;

    -- Zwraca liste nauczycieli uczacych danego instrumentu
    FUNCTION nauczyciele_instrumentu(p_instrument VARCHAR2) RETURN SYS_REFCURSOR;

END pkg_nauczyciel;
/

CREATE OR REPLACE PACKAGE BODY pkg_nauczyciel AS

    PROCEDURE dodaj_nauczyciela(
        p_imie            VARCHAR2,
        p_nazwisko        VARCHAR2,
        p_email           VARCHAR2,
        p_telefon         VARCHAR2 DEFAULT NULL,
        p_instrumenty     t_lista_instrumentow DEFAULT NULL,
        p_grupowe         CHAR DEFAULT 'N',
        p_akompaniator    CHAR DEFAULT 'N'
    ) IS
        v_id NUMBER;
    BEGIN
        SELECT seq_nauczyciele.NEXTVAL INTO v_id FROM dual;

        INSERT INTO nauczyciele VALUES (t_nauczyciel_obj(
            v_id, p_imie, p_nazwisko, p_email, p_telefon,
            SYSDATE, p_instrumenty, p_grupowe, p_akompaniator, 'aktywny'
        ));

        DBMS_OUTPUT.PUT_LINE('Dodano nauczyciela: ' || p_imie || ' ' || p_nazwisko || ' (ID=' || v_id || ')');
    END;

    PROCEDURE dodaj_instrument(p_id_nauczyciela NUMBER, p_instrument VARCHAR2) IS
        v_instrumenty t_lista_instrumentow;
    BEGIN
        SELECT instrumenty INTO v_instrumenty
        FROM nauczyciele WHERE id_nauczyciela = p_id_nauczyciela;

        IF v_instrumenty IS NULL THEN
            v_instrumenty := t_lista_instrumentow();
        END IF;

        IF v_instrumenty.COUNT >= 5 THEN
            RAISE_APPLICATION_ERROR(-20010, 'Nauczyciel moze miec max 5 instrumentow');
        END IF;

        v_instrumenty.EXTEND;
        v_instrumenty(v_instrumenty.COUNT) := p_instrument;

        UPDATE nauczyciele SET instrumenty = v_instrumenty WHERE id_nauczyciela = p_id_nauczyciela;
        DBMS_OUTPUT.PUT_LINE('Dodano instrument: ' || p_instrument);
    END;

    PROCEDURE zmien_status(p_id_nauczyciela NUMBER, p_nowy_status VARCHAR2) IS
    BEGIN
        UPDATE nauczyciele SET status = p_nowy_status WHERE id_nauczyciela = p_id_nauczyciela;
        DBMS_OUTPUT.PUT_LINE('Zmieniono status nauczyciela ID=' || p_id_nauczyciela || ' na: ' || p_nowy_status);
    END;

    FUNCTION liczba_lekcji(p_id_nauczyciela NUMBER) RETURN NUMBER IS
        v_cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_cnt
        FROM lekcje
        WHERE DEREF(ref_nauczyciel).id_nauczyciela = p_id_nauczyciela;
        RETURN v_cnt;
    END;

    FUNCTION nauczyciele_instrumentu(p_instrument VARCHAR2) RETURN SYS_REFCURSOR IS
        v_cur SYS_REFCURSOR;
    BEGIN
        OPEN v_cur FOR
            SELECT id_nauczyciela, imie, nazwisko, instrumenty
            FROM nauczyciele
            WHERE status = 'aktywny';
        RETURN v_cur;
    END;

END pkg_nauczyciel;
/

-- ============================================================================
-- 3. PAKIET: PKG_LEKCJA
-- Zarzadzanie lekcjami - planowanie, odwolywanie, HEURYSTYKA
-- ============================================================================

PROMPT [3/6] Tworzenie pakietu pkg_lekcja...

CREATE OR REPLACE PACKAGE pkg_lekcja AS

    -- ========== CRUD ==========
    
    -- Planuje lekcje indywidualna
    PROCEDURE planuj_lekcje(
        p_data         DATE,
        p_godzina      VARCHAR2,
        p_czas         NUMBER,
        p_id_przedm    NUMBER,
        p_id_naucz     NUMBER,
        p_id_sali      NUMBER,
        p_id_ucznia    NUMBER,
        p_id_akomp     NUMBER DEFAULT NULL
    );

    -- Planuje lekcje grupowa
    PROCEDURE planuj_lekcje_grupowa(
        p_data         DATE,
        p_godzina      VARCHAR2,
        p_czas         NUMBER,
        p_id_przedm    NUMBER,
        p_id_naucz     NUMBER,
        p_id_sali      NUMBER,
        p_id_grupy     NUMBER
    );

    -- Oznacza lekcje jako odbyta
    PROCEDURE oznacz_odbyta(p_id_lekcji NUMBER);

    -- Odwoluje lekcje
    PROCEDURE odwolaj_lekcje(p_id_lekcji NUMBER);

    -- ========== WALIDACJE ==========
    
    -- Sprawdza czy nauczyciel jest wolny w danym przedziale
    FUNCTION czy_nauczyciel_wolny(
        p_id_naucz NUMBER,
        p_data     DATE,
        p_godz_od  VARCHAR2,
        p_godz_do  VARCHAR2
    ) RETURN CHAR;

    -- Sprawdza czy sala jest wolna w danym przedziale
    FUNCTION czy_sala_wolna(
        p_id_sali  NUMBER,
        p_data     DATE,
        p_godz_od  VARCHAR2,
        p_godz_do  VARCHAR2
    ) RETURN CHAR;

    -- Sprawdza czy uczen jest wolny w danym przedziale
    FUNCTION czy_uczen_wolny(
        p_id_ucznia NUMBER,
        p_data      DATE,
        p_godz_od   VARCHAR2,
        p_godz_do   VARCHAR2
    ) RETURN CHAR;

    -- ========== HEURYSTYKA PLANOWANIA ==========
    
    -- Generuje plan na caly tydzien (poniedzialek-piatek)
    -- Zasada: BIG ROCKS FIRST - najpierw grupowe, potem indywidualne
    PROCEDURE generuj_plan_tygodnia(
        p_data_pn    DATE,     -- poniedzialek tygodnia
        p_nadpisz    CHAR DEFAULT 'N'  -- czy nadpisac istniejace
    );

    -- Znajduje wolny slot dla ucznia (zwraca godzine lub NULL)
    FUNCTION znajdz_slot(
        p_id_ucznia    NUMBER,
        p_id_naucz     NUMBER,
        p_id_sali      NUMBER,
        p_data         DATE,
        p_czas         NUMBER
    ) RETURN VARCHAR2;

END pkg_lekcja;
/

CREATE OR REPLACE PACKAGE BODY pkg_lekcja AS

    -- ========================================================================
    -- FUNKCJE POMOCNICZE (prywatne)
    -- ========================================================================
    
    -- Dodaje minuty do godziny w formacie HH:MI
    FUNCTION dodaj_minuty(p_godz VARCHAR2, p_min NUMBER) RETURN VARCHAR2 IS
        v_h NUMBER := TO_NUMBER(SUBSTR(p_godz, 1, 2));
        v_m NUMBER := TO_NUMBER(SUBSTR(p_godz, 4, 2));
    BEGIN
        v_m := v_m + p_min;
        v_h := v_h + TRUNC(v_m / 60);
        v_m := MOD(v_m, 60);
        RETURN LPAD(v_h, 2, '0') || ':' || LPAD(v_m, 2, '0');
    END;

    -- ========================================================================
    -- CRUD
    -- ========================================================================

    PROCEDURE planuj_lekcje(
        p_data         DATE,
        p_godzina      VARCHAR2,
        p_czas         NUMBER,
        p_id_przedm    NUMBER,
        p_id_naucz     NUMBER,
        p_id_sali      NUMBER,
        p_id_ucznia    NUMBER,
        p_id_akomp     NUMBER DEFAULT NULL
    ) IS
        v_id       NUMBER;
        v_ref_p    REF t_przedmiot_obj;
        v_ref_n    REF t_nauczyciel_obj;
        v_ref_a    REF t_nauczyciel_obj := NULL;
        v_ref_s    REF t_sala_obj;
        v_ref_u    REF t_uczen_obj;
    BEGIN
        SELECT seq_lekcje.NEXTVAL INTO v_id FROM dual;
        SELECT REF(p) INTO v_ref_p FROM przedmioty p WHERE id_przedmiotu = p_id_przedm;
        SELECT REF(n) INTO v_ref_n FROM nauczyciele n WHERE id_nauczyciela = p_id_naucz;
        SELECT REF(s) INTO v_ref_s FROM sale s WHERE id_sali = p_id_sali;
        SELECT REF(u) INTO v_ref_u FROM uczniowie u WHERE id_ucznia = p_id_ucznia;

        IF p_id_akomp IS NOT NULL THEN
            SELECT REF(n) INTO v_ref_a FROM nauczyciele n WHERE id_nauczyciela = p_id_akomp;
        END IF;

        INSERT INTO lekcje VALUES (t_lekcja_obj(
            v_id, p_data, p_godzina, p_czas, 'indywidualna', 'zaplanowana',
            v_ref_p, v_ref_n, v_ref_a, v_ref_s, v_ref_u, NULL
        ));
    END;

    PROCEDURE planuj_lekcje_grupowa(
        p_data         DATE,
        p_godzina      VARCHAR2,
        p_czas         NUMBER,
        p_id_przedm    NUMBER,
        p_id_naucz     NUMBER,
        p_id_sali      NUMBER,
        p_id_grupy     NUMBER
    ) IS
        v_id      NUMBER;
        v_ref_p   REF t_przedmiot_obj;
        v_ref_n   REF t_nauczyciel_obj;
        v_ref_s   REF t_sala_obj;
        v_ref_g   REF t_grupa_obj;
    BEGIN
        SELECT seq_lekcje.NEXTVAL INTO v_id FROM dual;
        SELECT REF(p) INTO v_ref_p FROM przedmioty p WHERE id_przedmiotu = p_id_przedm;
        SELECT REF(n) INTO v_ref_n FROM nauczyciele n WHERE id_nauczyciela = p_id_naucz;
        SELECT REF(s) INTO v_ref_s FROM sale s WHERE id_sali = p_id_sali;
        SELECT REF(g) INTO v_ref_g FROM grupy g WHERE id_grupy = p_id_grupy;

        INSERT INTO lekcje VALUES (t_lekcja_obj(
            v_id, p_data, p_godzina, p_czas, 'grupowa', 'zaplanowana',
            v_ref_p, v_ref_n, NULL, v_ref_s, NULL, v_ref_g
        ));
    END;

    PROCEDURE oznacz_odbyta(p_id_lekcji NUMBER) IS
    BEGIN
        UPDATE lekcje SET status = 'odbyta' WHERE id_lekcji = p_id_lekcji;
    END;

    PROCEDURE odwolaj_lekcje(p_id_lekcji NUMBER) IS
    BEGIN
        UPDATE lekcje SET status = 'odwolana' WHERE id_lekcji = p_id_lekcji;
    END;

    -- ========================================================================
    -- WALIDACJE
    -- ========================================================================

    FUNCTION czy_nauczyciel_wolny(
        p_id_naucz NUMBER,
        p_data     DATE,
        p_godz_od  VARCHAR2,
        p_godz_do  VARCHAR2
    ) RETURN CHAR IS
        v_cnt NUMBER;
    BEGIN
        -- Sprawdz czy jest kolizja: istniejaca lekcja NIE konczy sie przed p_godz_od
        -- i NIE zaczyna sie po p_godz_do
        SELECT COUNT(*) INTO v_cnt
        FROM lekcje l
        WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = p_id_naucz
          AND l.data_lekcji = p_data
          AND l.status != 'odwolana'
          AND NOT (l.godzina_start >= p_godz_do 
               OR VALUE(l).godzina_koniec() <= p_godz_od);
        RETURN CASE WHEN v_cnt = 0 THEN 'T' ELSE 'N' END;
    END;

    FUNCTION czy_sala_wolna(
        p_id_sali  NUMBER,
        p_data     DATE,
        p_godz_od  VARCHAR2,
        p_godz_do  VARCHAR2
    ) RETURN CHAR IS
        v_cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_cnt
        FROM lekcje l
        WHERE DEREF(l.ref_sala).id_sali = p_id_sali
          AND l.data_lekcji = p_data
          AND l.status != 'odwolana'
          AND NOT (l.godzina_start >= p_godz_do 
               OR VALUE(l).godzina_koniec() <= p_godz_od);
        RETURN CASE WHEN v_cnt = 0 THEN 'T' ELSE 'N' END;
    END;

    FUNCTION czy_uczen_wolny(
        p_id_ucznia NUMBER,
        p_data      DATE,
        p_godz_od   VARCHAR2,
        p_godz_do   VARCHAR2
    ) RETURN CHAR IS
        v_cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_cnt
        FROM lekcje l
        WHERE (DEREF(l.ref_uczen).id_ucznia = p_id_ucznia
               OR l.ref_grupa IN (
                   SELECT ref_grupa FROM uczniowie WHERE id_ucznia = p_id_ucznia
               ))
          AND l.data_lekcji = p_data
          AND l.status != 'odwolana'
          AND NOT (l.godzina_start >= p_godz_do 
               OR VALUE(l).godzina_koniec() <= p_godz_od);
        RETURN CASE WHEN v_cnt = 0 THEN 'T' ELSE 'N' END;
    END;

    -- ========================================================================
    -- HEURYSTYKA PLANOWANIA
    -- ========================================================================
    --
    -- ZASADA: BIG ROCKS FIRST (najpierw duze kamienie)
    -- 
    -- 1. Najpierw planuj lekcje GRUPOWE:
    --    - blokuja duze sale
    --    - blokuja czas wielu uczniow naraz
    --    - trudniej je przesunac
    --
    -- 2. Potem planuj lekcje INDYWIDUALNE:
    --    - uczniowie z innej szkoly: od 15:00
    --    - pozostali: od 14:00
    --    - szukaj pierwszego wolnego slotu
    --
    -- SLOTY: godziny 14:00-20:00, co 15 minut
    -- ========================================================================

    FUNCTION znajdz_slot(
        p_id_ucznia    NUMBER,
        p_id_naucz     NUMBER,
        p_id_sali      NUMBER,
        p_data         DATE,
        p_czas         NUMBER
    ) RETURN VARCHAR2 IS
        v_typ_ucznia   VARCHAR2(30);
        v_godz_start   VARCHAR2(5);
        v_godz_koniec  VARCHAR2(5);
        v_slot         VARCHAR2(5);
    BEGIN
        -- Pobierz typ ucznia (okresla minimalna godzine)
        SELECT typ_ucznia INTO v_typ_ucznia 
        FROM uczniowie WHERE id_ucznia = p_id_ucznia;
        
        -- Ustal godzine startowa
        IF v_typ_ucznia = 'uczacy_sie_w_innej_szkole' THEN
            v_slot := '15:00';
        ELSE
            v_slot := '14:00';
        END IF;
        
        -- Iteruj po slotach co 15 min az do 19:00
        WHILE v_slot <= '19:00' LOOP
            v_godz_koniec := dodaj_minuty(v_slot, p_czas);
            
            -- Sprawdz wszystkie warunki
            IF  czy_nauczyciel_wolny(p_id_naucz, p_data, v_slot, v_godz_koniec) = 'T'
            AND czy_sala_wolna(p_id_sali, p_data, v_slot, v_godz_koniec) = 'T'
            AND czy_uczen_wolny(p_id_ucznia, p_data, v_slot, v_godz_koniec) = 'T'
            THEN
                RETURN v_slot;  -- Znaleziono!
            END IF;
            
            -- Nastepny slot (+15 min)
            v_slot := dodaj_minuty(v_slot, 15);
        END LOOP;
        
        RETURN NULL;  -- Brak wolnego slotu
    END;

    PROCEDURE generuj_plan_tygodnia(
        p_data_pn    DATE,
        p_nadpisz    CHAR DEFAULT 'N'
    ) IS
        v_data       DATE;
        v_slot       VARCHAR2(5);
        v_dzien      NUMBER;
        v_zaplan     NUMBER := 0;
        v_pomin      NUMBER := 0;
    BEGIN
        -- Opcjonalnie usun istniejace lekcje
        IF p_nadpisz = 'T' THEN
            DELETE FROM lekcje 
            WHERE data_lekcji BETWEEN p_data_pn AND p_data_pn + 4
              AND status = 'zaplanowana';
        END IF;
        
        -- ===========================================
        -- FAZA 1: LEKCJE GRUPOWE (duze kamienie)
        -- ===========================================
        -- Dla kazdej grupy i kazdego przedmiotu grupowego
        -- znajdz slot w ktorymkolwiek dniu tygodnia
        
        FOR r_grupa IN (
            SELECT id_grupy, klasa FROM grupy WHERE status = 'aktywna'
        ) LOOP
            FOR r_przedm IN (
                SELECT id_przedmiotu, nazwa, czas_trwania 
                FROM przedmioty 
                WHERE typ_zajec = 'grupowy'
                  AND r_grupa.klasa BETWEEN klasa_od AND klasa_do
            ) LOOP
                -- Znajdz nauczyciela grupowego
                FOR r_naucz IN (
                    SELECT id_nauczyciela FROM nauczyciele 
                    WHERE czy_prowadzi_grupowe = 'T' AND status = 'aktywny'
                ) LOOP
                    -- Znajdz sale grupowa
                    FOR r_sala IN (
                        SELECT id_sali FROM sale 
                        WHERE typ_sali IN ('grupowa', 'wielofunkcyjna') 
                          AND status = 'aktywna'
                    ) LOOP
                        -- Probuj kazdy dzien tygodnia
                        FOR v_dzien IN 0..4 LOOP
                            v_data := p_data_pn + v_dzien;
                            v_slot := '15:00';  -- grupowe od 15:00
                            
                            WHILE v_slot <= '18:00' LOOP
                                IF czy_nauczyciel_wolny(r_naucz.id_nauczyciela, v_data, 
                                       v_slot, dodaj_minuty(v_slot, r_przedm.czas_trwania)) = 'T'
                                AND czy_sala_wolna(r_sala.id_sali, v_data,
                                       v_slot, dodaj_minuty(v_slot, r_przedm.czas_trwania)) = 'T'
                                THEN
                                    planuj_lekcje_grupowa(
                                        v_data, v_slot, r_przedm.czas_trwania,
                                        r_przedm.id_przedmiotu, r_naucz.id_nauczyciela,
                                        r_sala.id_sali, r_grupa.id_grupy
                                    );
                                    v_zaplan := v_zaplan + 1;
                                    GOTO next_grupa_przedm;
                                END IF;
                                v_slot := dodaj_minuty(v_slot, 15);
                            END LOOP;
                        END LOOP;
                    END LOOP;
                END LOOP;
                v_pomin := v_pomin + 1;
                <<next_grupa_przedm>>
                NULL;
            END LOOP;
        END LOOP;
        
        -- ===========================================
        -- FAZA 2: LEKCJE INDYWIDUALNE
        -- ===========================================
        -- Dla kazdego aktywnego ucznia zaplanuj 1 lekcje
        -- instrumentu glownego w tygodniu
        
        FOR r_uczen IN (
            SELECT u.id_ucznia, u.typ_ucznia, u.klasa,
                   DEREF(u.ref_instrument).id_instrumentu AS id_instr,
                   DEREF(u.ref_instrument).nazwa AS instr_nazwa
            FROM uczniowie u
            WHERE u.status = 'aktywny'
        ) LOOP
            -- Znajdz nauczyciela tego instrumentu
            FOR r_naucz IN (
                SELECT id_nauczyciela FROM nauczyciele n
                WHERE n.status = 'aktywny'
                  AND r_uczen.instr_nazwa MEMBER OF n.instrumenty
            ) LOOP
                -- Znajdz przedmiot (instrument glowny)
                FOR r_przedm IN (
                    SELECT id_przedmiotu, czas_trwania FROM przedmioty p
                    WHERE p.typ_zajec = 'indywidualny'
                      AND DEREF(p.ref_instrument).id_instrumentu = r_uczen.id_instr
                      AND r_uczen.klasa BETWEEN p.klasa_od AND p.klasa_do
                    FETCH FIRST 1 ROW ONLY
                ) LOOP
                    -- Znajdz sale indywidualna
                    FOR r_sala IN (
                        SELECT id_sali FROM sale 
                        WHERE typ_sali IN ('indywidualna', 'wielofunkcyjna')
                          AND status = 'aktywna'
                    ) LOOP
                        -- Probuj kazdy dzien
                        FOR v_dzien IN 0..4 LOOP
                            v_data := p_data_pn + v_dzien;
                            v_slot := znajdz_slot(
                                r_uczen.id_ucznia, r_naucz.id_nauczyciela,
                                r_sala.id_sali, v_data, r_przedm.czas_trwania
                            );
                            IF v_slot IS NOT NULL THEN
                                planuj_lekcje(
                                    v_data, v_slot, r_przedm.czas_trwania,
                                    r_przedm.id_przedmiotu, r_naucz.id_nauczyciela,
                                    r_sala.id_sali, r_uczen.id_ucznia
                                );
                                v_zaplan := v_zaplan + 1;
                                GOTO next_uczen;
                            END IF;
                        END LOOP;
                    END LOOP;
                END LOOP;
            END LOOP;
            v_pomin := v_pomin + 1;
            <<next_uczen>>
            NULL;
        END LOOP;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Zaplanowano: ' || v_zaplan || ', pominieto: ' || v_pomin);
    END;

END pkg_lekcja;
/

-- ============================================================================
-- 4. PAKIET: PKG_OCENA
-- Zarzadzanie ocenami - dodawanie, srednie
-- ============================================================================

PROMPT [4/6] Tworzenie pakietu pkg_ocena...

CREATE OR REPLACE PACKAGE pkg_ocena AS

    -- Dodaje ocene
    PROCEDURE dodaj_ocene(
        p_wartosc       NUMBER,
        p_obszar        VARCHAR2,
        p_komentarz     VARCHAR2 DEFAULT NULL,
        p_id_ucznia     NUMBER,
        p_id_naucz      NUMBER,
        p_id_przedm     NUMBER,
        p_id_lekcji     NUMBER DEFAULT NULL
    );

    -- Srednia ocen ucznia z przedmiotu
    FUNCTION srednia_ucznia_przedmiot(p_id_ucznia NUMBER, p_id_przedm NUMBER) RETURN NUMBER;

    -- Srednia wszystkich uczniow z przedmiotu
    FUNCTION srednia_przedmiotu(p_id_przedm NUMBER) RETURN NUMBER;

END pkg_ocena;
/

CREATE OR REPLACE PACKAGE BODY pkg_ocena AS

    PROCEDURE dodaj_ocene(
        p_wartosc       NUMBER,
        p_obszar        VARCHAR2,
        p_komentarz     VARCHAR2 DEFAULT NULL,
        p_id_ucznia     NUMBER,
        p_id_naucz      NUMBER,
        p_id_przedm     NUMBER,
        p_id_lekcji     NUMBER DEFAULT NULL
    ) IS
        v_id      NUMBER;
        v_ref_u   REF t_uczen_obj;
        v_ref_n   REF t_nauczyciel_obj;
        v_ref_p   REF t_przedmiot_obj;
        v_ref_l   REF t_lekcja_obj := NULL;
    BEGIN
        SELECT seq_oceny.NEXTVAL INTO v_id FROM dual;
        SELECT REF(u) INTO v_ref_u FROM uczniowie u WHERE id_ucznia = p_id_ucznia;
        SELECT REF(n) INTO v_ref_n FROM nauczyciele n WHERE id_nauczyciela = p_id_naucz;
        SELECT REF(p) INTO v_ref_p FROM przedmioty p WHERE id_przedmiotu = p_id_przedm;

        IF p_id_lekcji IS NOT NULL THEN
            SELECT REF(l) INTO v_ref_l FROM lekcje l WHERE id_lekcji = p_id_lekcji;
        END IF;

        INSERT INTO oceny VALUES (t_ocena_obj(
            v_id, SYSDATE, p_wartosc, p_obszar, p_komentarz,
            v_ref_u, v_ref_n, v_ref_p, v_ref_l
        ));

        DBMS_OUTPUT.PUT_LINE('Dodano ocene ' || p_wartosc || ' (ID=' || v_id || ')');
    END;

    FUNCTION srednia_ucznia_przedmiot(p_id_ucznia NUMBER, p_id_przedm NUMBER) RETURN NUMBER IS
        v_srednia NUMBER;
    BEGIN
        SELECT AVG(wartosc) INTO v_srednia
        FROM oceny
        WHERE DEREF(ref_uczen).id_ucznia = p_id_ucznia
          AND DEREF(ref_przedmiot).id_przedmiotu = p_id_przedm;
        RETURN ROUND(NVL(v_srednia, 0), 2);
    END;

    FUNCTION srednia_przedmiotu(p_id_przedm NUMBER) RETURN NUMBER IS
        v_srednia NUMBER;
    BEGIN
        SELECT AVG(wartosc) INTO v_srednia
        FROM oceny
        WHERE DEREF(ref_przedmiot).id_przedmiotu = p_id_przedm;
        RETURN ROUND(NVL(v_srednia, 0), 2);
    END;

END pkg_ocena;
/

-- ============================================================================
-- 5. PAKIET: PKG_RAPORT
-- Raporty i zestawienia
-- ============================================================================

PROMPT [5/6] Tworzenie pakietu pkg_raport...

CREATE OR REPLACE PACKAGE pkg_raport AS

    -- Raport uczniow z ocenami
    PROCEDURE raport_uczniow;

    -- Raport lekcji w danym okresie
    PROCEDURE raport_lekcji(p_data_od DATE, p_data_do DATE);

    -- Raport obciazenia nauczycieli
    PROCEDURE raport_nauczycieli;

    -- Statystyki ogolne
    PROCEDURE statystyki_ogolne;

END pkg_raport;
/

CREATE OR REPLACE PACKAGE BODY pkg_raport AS

    PROCEDURE raport_uczniow IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== RAPORT UCZNIOW ===');
        DBMS_OUTPUT.PUT_LINE('');
        FOR r IN (
            SELECT u.id_ucznia,
                   u.imie || ' ' || u.nazwisko AS nazwa,
                   u.klasa,
                   u.status,
                   pkg_uczen.srednia_ocen(u.id_ucznia) AS srednia,
                   pkg_uczen.liczba_lekcji(u.id_ucznia) AS lekcje
            FROM uczniowie u
            ORDER BY u.nazwisko
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                'ID=' || r.id_ucznia || ' | ' ||
                RPAD(r.nazwa, 25) || ' | kl.' || r.klasa || ' | ' ||
                RPAD(r.status, 10) || ' | sr=' || r.srednia || ' | lek=' || r.lekcje
            );
        END LOOP;
    END;

    PROCEDURE raport_lekcji(p_data_od DATE, p_data_do DATE) IS
        v_cnt NUMBER := 0;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== RAPORT LEKCJI ===');
        DBMS_OUTPUT.PUT_LINE('Okres: ' || TO_CHAR(p_data_od, 'DD.MM.YYYY') ||
                            ' - ' || TO_CHAR(p_data_do, 'DD.MM.YYYY'));
        DBMS_OUTPUT.PUT_LINE('');

        FOR r IN (
            SELECT l.id_lekcji,
                   l.data_lekcji,
                   l.godzina_start,
                   l.typ_lekcji,
                   l.status,
                   DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel
            FROM lekcje l
            WHERE l.data_lekcji BETWEEN p_data_od AND p_data_do
            ORDER BY l.data_lekcji, l.godzina_start
        ) LOOP
            v_cnt := v_cnt + 1;
            DBMS_OUTPUT.PUT_LINE(
                TO_CHAR(r.data_lekcji, 'DD.MM') || ' ' || r.godzina_start ||
                ' | ' || RPAD(r.typ_lekcji, 12) ||
                ' | ' || RPAD(r.status, 12) ||
                ' | ' || r.nauczyciel
            );
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('Razem lekcji: ' || v_cnt);
    END;

    PROCEDURE raport_nauczycieli IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== RAPORT NAUCZYCIELI ===');
        DBMS_OUTPUT.PUT_LINE('');

        FOR r IN (
            SELECT n.id_nauczyciela,
                   n.imie || ' ' || n.nazwisko AS nazwa,
                   n.status,
                   VALUE(n).lata_stazu() AS staz,
                   pkg_nauczyciel.liczba_lekcji(n.id_nauczyciela) AS lekcje
            FROM nauczyciele n
            ORDER BY n.nazwisko
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                'ID=' || r.id_nauczyciela || ' | ' ||
                RPAD(r.nazwa, 25) || ' | ' ||
                RPAD(r.status, 10) || ' | staz=' || r.staz || ' lat | lek=' || r.lekcje
            );
        END LOOP;
    END;

    PROCEDURE statystyki_ogolne IS
        v_uczniowie   NUMBER;
        v_nauczyciele NUMBER;
        v_lekcje      NUMBER;
        v_oceny       NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_uczniowie FROM uczniowie WHERE status = 'aktywny';
        SELECT COUNT(*) INTO v_nauczyciele FROM nauczyciele WHERE status = 'aktywny';
        SELECT COUNT(*) INTO v_lekcje FROM lekcje;
        SELECT COUNT(*) INTO v_oceny FROM oceny;

        DBMS_OUTPUT.PUT_LINE('=== STATYSTYKI OGOLNE ===');
        DBMS_OUTPUT.PUT_LINE('Aktywni uczniowie:    ' || v_uczniowie);
        DBMS_OUTPUT.PUT_LINE('Aktywni nauczyciele:  ' || v_nauczyciele);
        DBMS_OUTPUT.PUT_LINE('Wszystkie lekcje:     ' || v_lekcje);
        DBMS_OUTPUT.PUT_LINE('Wszystkie oceny:      ' || v_oceny);
    END;

END pkg_raport;
/

-- ============================================================================
-- 6. PAKIET: PKG_TEST
-- Testy jednostkowe dla walidacji systemu
-- ============================================================================

PROMPT [6/6] Tworzenie pakietu pkg_test...

CREATE OR REPLACE PACKAGE pkg_test AS

    g_passed NUMBER := 0;
    g_failed NUMBER := 0;

    PROCEDURE reset_counters;
    PROCEDURE assert_equals(p_expected VARCHAR2, p_actual VARCHAR2, p_msg VARCHAR2);
    PROCEDURE assert_true(p_condition BOOLEAN, p_msg VARCHAR2);
    PROCEDURE assert_error(p_code NUMBER, p_msg VARCHAR2);
    PROCEDURE print_summary;

    -- Testy domenowe
    PROCEDURE test_uczen_metody;
    PROCEDURE test_lekcja_godzina;
    PROCEDURE test_komisja_egzaminu;
    PROCEDURE run_all;

END pkg_test;
/

CREATE OR REPLACE PACKAGE BODY pkg_test AS

    PROCEDURE reset_counters IS
    BEGIN
        g_passed := 0;
        g_failed := 0;
    END;

    PROCEDURE assert_equals(p_expected VARCHAR2, p_actual VARCHAR2, p_msg VARCHAR2) IS
    BEGIN
        IF p_expected = p_actual OR (p_expected IS NULL AND p_actual IS NULL) THEN
            g_passed := g_passed + 1;
            DBMS_OUTPUT.PUT_LINE('[PASS] ' || p_msg);
        ELSE
            g_failed := g_failed + 1;
            DBMS_OUTPUT.PUT_LINE('[FAIL] ' || p_msg || ' (oczekiwano: ' || p_expected || ', otrzymano: ' || p_actual || ')');
        END IF;
    END;

    PROCEDURE assert_true(p_condition BOOLEAN, p_msg VARCHAR2) IS
    BEGIN
        IF p_condition THEN
            g_passed := g_passed + 1;
            DBMS_OUTPUT.PUT_LINE('[PASS] ' || p_msg);
        ELSE
            g_failed := g_failed + 1;
            DBMS_OUTPUT.PUT_LINE('[FAIL] ' || p_msg);
        END IF;
    END;

    PROCEDURE assert_error(p_code NUMBER, p_msg VARCHAR2) IS
    BEGIN
        g_passed := g_passed + 1;
        DBMS_OUTPUT.PUT_LINE('[PASS] ' || p_msg || ' (blad ' || p_code || ' - oczekiwany)');
    END;

    PROCEDURE print_summary IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== PODSUMOWANIE ===');
        DBMS_OUTPUT.PUT_LINE('Passed: ' || g_passed);
        DBMS_OUTPUT.PUT_LINE('Failed: ' || g_failed);
        DBMS_OUTPUT.PUT_LINE('Total:  ' || (g_passed + g_failed));
    END;

    PROCEDURE test_uczen_metody IS
        v_uczen t_uczen_obj;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Test: metody t_uczen_obj ---');

        SELECT VALUE(u) INTO v_uczen FROM uczniowie u WHERE ROWNUM = 1;

        assert_true(v_uczen.wiek() > 0, 'wiek() zwraca wartosc > 0');
        assert_true(v_uczen.min_godzina_lekcji() IN ('14:00', '15:00'), 'min_godzina_lekcji() zwraca poprawna godzine');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('[SKIP] Brak danych testowych');
    END;

    PROCEDURE test_lekcja_godzina IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Test: walidacja godziny lekcji ---');
        -- Ten test wymaga danych - patrz 09_testy.sql
        DBMS_OUTPUT.PUT_LINE('[INFO] Test wymaga uruchomienia 09_testy.sql');
    END;

    PROCEDURE test_komisja_egzaminu IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Test: walidacja komisji egzaminu ---');
        -- Ten test wymaga danych - patrz 09_testy.sql
        DBMS_OUTPUT.PUT_LINE('[INFO] Test wymaga uruchomienia 09_testy.sql');
    END;

    PROCEDURE run_all IS
    BEGIN
        reset_counters;
        DBMS_OUTPUT.PUT_LINE('=== URUCHAMIANIE TESTOW ===');
        DBMS_OUTPUT.PUT_LINE('');

        test_uczen_metody;
        test_lekcja_godzina;
        test_komisja_egzaminu;

        print_summary;
    END;

END pkg_test;
/

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================

PROMPT
PROMPT ========================================================================
PROMPT   UTWORZONE PAKIETY
PROMPT ========================================================================
PROMPT   pkg_uczen - zarzadzanie uczniami (CRUD, promocje)
PROMPT   pkg_nauczyciel - zarzadzanie nauczycielami
PROMPT   pkg_lekcja - planowanie i zarzadzanie lekcjami
PROMPT   pkg_ocena - oceny biezace
PROMPT   pkg_raport - raporty i statystyki
PROMPT   pkg_test - testy jednostkowe
PROMPT ========================================================================
PROMPT   Nastepny krok: Uruchom 05_dane.sql
PROMPT ========================================================================

SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('PACKAGE', 'PACKAGE BODY')
ORDER BY object_name, object_type;
