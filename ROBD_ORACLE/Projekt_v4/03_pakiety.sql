-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 03_pakiety.sql
-- Opis: Pakiety PL/SQL z logika biznesowa
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- ============================================================================
-- PAKIET 1: PKG_UCZEN
-- Obsluga uczniow - dodawanie, listy, informacje, statystyki
-- ============================================================================
CREATE OR REPLACE PACKAGE pkg_uczen AS
    -- Dodaje nowego ucznia do bazy
    PROCEDURE dodaj(
        p_imie          VARCHAR2,
        p_nazwisko      VARCHAR2,
        p_data_urodzenia DATE,
        p_email         VARCHAR2 DEFAULT NULL
    );
    -- Wyswietla liste wszystkich uczniow
    PROCEDURE lista;
    -- Wyswietla liste dzieci (ponizej 15 lat)
    PROCEDURE lista_dzieci;
    -- Wyswietla szczegolowe informacje o uczniu
    PROCEDURE info(p_id_ucznia NUMBER);
    -- Oblicza srednia ocen ucznia
    FUNCTION srednia_ocen(p_id_ucznia NUMBER) RETURN NUMBER;
    -- Zwraca liczbe lekcji ucznia
    FUNCTION liczba_lekcji(p_id_ucznia NUMBER) RETURN NUMBER;
END pkg_uczen;
/

CREATE OR REPLACE PACKAGE BODY pkg_uczen AS

    PROCEDURE dodaj(
        p_imie          VARCHAR2,
        p_nazwisko      VARCHAR2,
        p_data_urodzenia DATE,
        p_email         VARCHAR2 DEFAULT NULL
    ) IS
        v_wiek NUMBER;
    BEGIN
        -- Oblicz wiek do wyswietlenia
        v_wiek := TRUNC(MONTHS_BETWEEN(SYSDATE, p_data_urodzenia) / 12);

        -- Wstaw nowego ucznia (trigger sprawdzi wiek >= 5)
        INSERT INTO t_uczen VALUES (
            t_uczen_obj(
                seq_uczen.NEXTVAL,
                p_imie,
                p_nazwisko,
                p_data_urodzenia,
                p_email,
                SYSDATE
            )
        );

        DBMS_OUTPUT.PUT_LINE('Dodano ucznia: ' || p_imie || ' ' || p_nazwisko || 
                            ' (wiek: ' || v_wiek || ' lat)');
    END dodaj;

    PROCEDURE lista IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== LISTA UCZNIOW ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('ID', 5) || RPAD('Imie', 15) || 
                            RPAD('Nazwisko', 20) || RPAD('Wiek', 6) || 'Status');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 60, '-'));

        -- Uzycie VALUE(u) do pobrania obiektu i wywolania metod
        FOR r IN (
            SELECT u.id_ucznia, u.imie, u.nazwisko, 
                   VALUE(u).wiek() AS wiek,
                   CASE WHEN VALUE(u).czy_dziecko() = 'T' 
                        THEN 'dziecko' ELSE 'dorosly' END AS status
            FROM t_uczen u
            ORDER BY u.nazwisko, u.imie
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.id_ucznia, 5) || 
                RPAD(r.imie, 15) || 
                RPAD(r.nazwisko, 20) || 
                RPAD(r.wiek, 6) ||
                r.status
            );
        END LOOP;
    END lista;

    PROCEDURE lista_dzieci IS
        v_count NUMBER := 0;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== LISTA DZIECI (ponizej 15 lat) ===');
        DBMS_OUTPUT.PUT_LINE('Lekcje mozliwe tylko: Pn-Pt, godz. 14:00-19:00');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 50, '-'));

        FOR r IN (
            SELECT u.id_ucznia, u.imie, u.nazwisko, 
                   VALUE(u).wiek() AS wiek
            FROM t_uczen u
            WHERE VALUE(u).czy_dziecko() = 'T'
            ORDER BY VALUE(u).wiek(), u.nazwisko
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                r.id_ucznia || '. ' || r.imie || ' ' || r.nazwisko || 
                ' (lat ' || r.wiek || ')'
            );
            v_count := v_count + 1;
        END LOOP;

        DBMS_OUTPUT.PUT_LINE(RPAD('-', 50, '-'));
        DBMS_OUTPUT.PUT_LINE('Razem dzieci: ' || v_count);
    END lista_dzieci;

    PROCEDURE info(p_id_ucznia NUMBER) IS
        v_uczen t_uczen_obj;
        v_lekcje NUMBER;
        v_srednia NUMBER;
    BEGIN
        -- Pobierz obiekt ucznia
        SELECT VALUE(u) INTO v_uczen
        FROM t_uczen u
        WHERE u.id_ucznia = p_id_ucznia;

        -- Oblicz statystyki
        v_lekcje := liczba_lekcji(p_id_ucznia);
        v_srednia := srednia_ocen(p_id_ucznia);

        -- Wyswietl informacje
        DBMS_OUTPUT.PUT_LINE('=== INFORMACJE O UCZNIU ===');
        DBMS_OUTPUT.PUT_LINE('ID:           ' || v_uczen.id_ucznia);
        DBMS_OUTPUT.PUT_LINE('Imie:         ' || v_uczen.imie);
        DBMS_OUTPUT.PUT_LINE('Nazwisko:     ' || v_uczen.nazwisko);
        DBMS_OUTPUT.PUT_LINE('Data ur.:     ' || TO_CHAR(v_uczen.data_urodzenia, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Wiek:         ' || v_uczen.wiek() || ' lat');
        DBMS_OUTPUT.PUT_LINE('Status:       ' || CASE WHEN v_uczen.czy_dziecko() = 'T' 
                                                       THEN 'dziecko (14:00-19:00)' 
                                                       ELSE 'dorosly' END);
        DBMS_OUTPUT.PUT_LINE('Email:        ' || NVL(v_uczen.email, 'brak'));
        DBMS_OUTPUT.PUT_LINE('Data zapisu:  ' || TO_CHAR(v_uczen.data_zapisu, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Liczba lekcji: ' || v_lekcje);
        DBMS_OUTPUT.PUT_LINE('Srednia ocen: ' || NVL(TO_CHAR(v_srednia, '0.00'), 'brak ocen'));

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono ucznia o ID: ' || p_id_ucznia);
    END info;

    FUNCTION srednia_ocen(p_id_ucznia NUMBER) RETURN NUMBER IS
        v_srednia NUMBER;
    BEGIN
        -- Uzycie DEREF do pobrania danych z referencji
        SELECT AVG(o.ocena) INTO v_srednia
        FROM t_ocena o
        WHERE DEREF(o.ref_uczen).id_ucznia = p_id_ucznia;

        RETURN ROUND(v_srednia, 2);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END srednia_ocen;

    FUNCTION liczba_lekcji(p_id_ucznia NUMBER) RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM t_lekcja l
        WHERE DEREF(l.ref_uczen).id_ucznia = p_id_ucznia;

        RETURN v_count;
    END liczba_lekcji;

END pkg_uczen;
/

-- ============================================================================
-- PAKIET 2: PKG_LEKCJA
-- Zarzadzanie lekcjami - planowanie, statusy, raporty
-- Cala logika walidacji znajduje sie w procedurze zaplanuj()
-- ============================================================================
CREATE OR REPLACE PACKAGE pkg_lekcja AS
    -- Planuje nowa lekcje z pelna walidacja
    PROCEDURE zaplanuj(
        p_id_ucznia     NUMBER,
        p_id_nauczyciela NUMBER,
        p_id_kursu      NUMBER,
        p_id_sali       NUMBER,
        p_data          DATE,
        p_godzina       VARCHAR2,
        p_czas_trwania  NUMBER DEFAULT 45
    );
    -- Oznacza lekcje jako odbyta
    PROCEDURE oznacz_odbyta(p_id_lekcji NUMBER);
    -- Odwoluje lekcje
    PROCEDURE odwolaj(p_id_lekcji NUMBER);
    -- Wyswietla plan dnia
    PROCEDURE plan_dnia(p_data DATE DEFAULT SYSDATE);
    -- Wyswietla plan nauczyciela
    PROCEDURE plan_nauczyciela(p_id_nauczyciela NUMBER, p_data DATE DEFAULT SYSDATE);
    -- Raport obciazenia nauczycieli
    PROCEDURE raport_obciazenia(p_data DATE DEFAULT SYSDATE);
END pkg_lekcja;
/

CREATE OR REPLACE PACKAGE BODY pkg_lekcja AS

    -- ========================================================================
    -- ZAPLANUJ - glowna procedura z cala logika walidacji
    -- Walidacje: kompetencje nauczyciela, limity, konflikty
    -- ========================================================================
    PROCEDURE zaplanuj(
        p_id_ucznia     NUMBER,
        p_id_nauczyciela NUMBER,
        p_id_kursu      NUMBER,
        p_id_sali       NUMBER,
        p_data          DATE,
        p_godzina       VARCHAR2,
        p_czas_trwania  NUMBER DEFAULT 45
    ) IS
        v_ref_uczen     REF t_uczen_obj;
        v_ref_naucz     REF t_nauczyciel_obj;
        v_ref_kurs      REF t_kurs_obj;
        v_ref_sala      REF t_sala_obj;
        v_id            NUMBER;

        -- Zmienne do walidacji
        v_godz_start_new NUMBER;
        v_godz_end_new   NUMBER;
        v_cnt            NUMBER;
        v_suma_minut     NUMBER;
        v_instrument_kursu VARCHAR2(100);
    BEGIN
        -- Przelicz godzine startu na minuty od polnocy
        v_godz_start_new := TO_NUMBER(SUBSTR(p_godzina, 1, 2)) * 60 + 
                           TO_NUMBER(SUBSTR(p_godzina, 4, 2));
        v_godz_end_new := v_godz_start_new + p_czas_trwania;

        -- =================================================================
        -- WALIDACJA 1: Sprawdz kompetencje nauczyciela
        -- Nauczyciel musi miec instrument kursu w swoim VARRAY
        -- =================================================================
        SELECT i.nazwa INTO v_instrument_kursu
        FROM t_kurs k 
        JOIN t_instrument i ON DEREF(k.ref_instrument).id_instrumentu = i.id_instrumentu
        WHERE k.id_kursu = p_id_kursu;

        -- Porownanie z uzyciem UPPER dla bezpieczenstwa
        SELECT COUNT(*) INTO v_cnt
        FROM t_nauczyciel n, TABLE(n.instrumenty) t
        WHERE n.id_nauczyciela = p_id_nauczyciela 
          AND UPPER(t.COLUMN_VALUE) = UPPER(v_instrument_kursu);

        IF v_cnt = 0 THEN
            RAISE_APPLICATION_ERROR(-20030, 
                'Nauczyciel nie uczy gry na: ' || v_instrument_kursu);
        END IF;

        -- =================================================================
        -- WALIDACJA 2: Limit nauczyciela (max 6h = 360 min dziennie)
        -- =================================================================
        SELECT NVL(SUM(l.czas_trwania), 0) INTO v_suma_minut
        FROM t_lekcja l
        WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = p_id_nauczyciela
          AND TRUNC(l.data_lekcji) = TRUNC(p_data)
          AND l.status IN ('zaplanowana', 'odbyta');

        IF v_suma_minut + p_czas_trwania > 360 THEN
            RAISE_APPLICATION_ERROR(-20104, 
                'Nauczyciel przekroczy limit 6h dziennie (obecnie: ' || 
                v_suma_minut || ' min).');
        END IF;

        -- =================================================================
        -- WALIDACJA 3: Limit ucznia (max 2 lekcje dziennie)
        -- =================================================================
        SELECT COUNT(*) INTO v_cnt
        FROM t_lekcja l
        WHERE DEREF(l.ref_uczen).id_ucznia = p_id_ucznia
          AND TRUNC(l.data_lekcji) = TRUNC(p_data)
          AND l.status IN ('zaplanowana', 'odbyta');

        IF v_cnt >= 2 THEN
            RAISE_APPLICATION_ERROR(-20105, 
                'Uczen ma juz 2 lekcje tego dnia - limit wyczerpany.');
        END IF;

        -- =================================================================
        -- WALIDACJA 4: Konflikt sali (nakladajace sie terminy)
        -- =================================================================
        SELECT COUNT(*) INTO v_cnt
        FROM t_lekcja l
        WHERE DEREF(l.ref_sala).id_sali = p_id_sali
          AND TRUNC(l.data_lekcji) = TRUNC(p_data)
          AND l.status IN ('zaplanowana', 'odbyta')
          AND (
              -- Nowa lekcja zaczyna sie w trakcie istniejacej
              (v_godz_start_new >= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                   TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))
               AND v_godz_start_new < TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                       TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania)
              OR
              -- Nowa lekcja konczy sie w trakcie istniejacej
              (v_godz_end_new > TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))
               AND v_godz_end_new <= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                      TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania)
              OR
              -- Nowa lekcja obejmuje cala istniejaca
              (v_godz_start_new <= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                    TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))
               AND v_godz_end_new >= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                      TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania)
          );

        IF v_cnt > 0 THEN
            RAISE_APPLICATION_ERROR(-20106, 
                'Konflikt sali - termin jest juz zajety.');
        END IF;

        -- =================================================================
        -- WALIDACJA 5: Konflikt nauczyciela
        -- =================================================================
        SELECT COUNT(*) INTO v_cnt
        FROM t_lekcja l
        WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = p_id_nauczyciela
          AND TRUNC(l.data_lekcji) = TRUNC(p_data)
          AND l.status IN ('zaplanowana', 'odbyta')
          AND (
              (v_godz_start_new >= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                   TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))
               AND v_godz_start_new < TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                       TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania)
              OR
              (v_godz_end_new > TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))
               AND v_godz_end_new <= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                      TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania)
              OR
              (v_godz_start_new <= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                    TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))
               AND v_godz_end_new >= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                      TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania)
          );

        IF v_cnt > 0 THEN
            RAISE_APPLICATION_ERROR(-20107, 
                'Nauczyciel ma juz lekcje w tym czasie.');
        END IF;

        -- =================================================================
        -- WALIDACJA 6: Konflikt ucznia
        -- =================================================================
        SELECT COUNT(*) INTO v_cnt
        FROM t_lekcja l
        WHERE DEREF(l.ref_uczen).id_ucznia = p_id_ucznia
          AND TRUNC(l.data_lekcji) = TRUNC(p_data)
          AND l.status IN ('zaplanowana', 'odbyta')
          AND (
              (v_godz_start_new >= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                   TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))
               AND v_godz_start_new < TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                       TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania)
              OR
              (v_godz_end_new > TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))
               AND v_godz_end_new <= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                      TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania)
              OR
              (v_godz_start_new <= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                    TO_NUMBER(SUBSTR(l.godzina_start, 4, 2))
               AND v_godz_end_new >= TO_NUMBER(SUBSTR(l.godzina_start, 1, 2)) * 60 + 
                                      TO_NUMBER(SUBSTR(l.godzina_start, 4, 2)) + l.czas_trwania)
          );

        IF v_cnt > 0 THEN
            RAISE_APPLICATION_ERROR(-20108, 
                'Uczen ma juz lekcje w tym czasie.');
        END IF;

        -- =================================================================
        -- WALIDACJA OK - pobierz referencje i wstaw rekord
        -- =================================================================
        SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = p_id_ucznia;
        SELECT REF(n) INTO v_ref_naucz FROM t_nauczyciel n WHERE n.id_nauczyciela = p_id_nauczyciela;
        SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = p_id_kursu;
        SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = p_id_sali;

        v_id := seq_lekcja.NEXTVAL;

        INSERT INTO t_lekcja VALUES (
            t_lekcja_obj(
                v_id,
                p_data,
                p_godzina,
                p_czas_trwania,
                'zaplanowana',
                v_ref_uczen,
                v_ref_naucz,
                v_ref_kurs,
                v_ref_sala
            )
        );

        DBMS_OUTPUT.PUT_LINE('Zaplanowano lekcje ID=' || v_id || 
                            ' na ' || TO_CHAR(p_data, 'YYYY-MM-DD') || 
                            ' godz. ' || p_godzina);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20010, 
                'Nie znaleziono podanego ucznia, nauczyciela, kursu lub sali');
    END zaplanuj;

    PROCEDURE oznacz_odbyta(p_id_lekcji NUMBER) IS
    BEGIN
        UPDATE t_lekcja
        SET status = 'odbyta'
        WHERE id_lekcji = p_id_lekcji AND status = 'zaplanowana';

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20011, 
                'Nie mozna oznaczyc - lekcja nie istnieje lub nie jest zaplanowana');
        END IF;

        DBMS_OUTPUT.PUT_LINE('Lekcja ID=' || p_id_lekcji || ' oznaczona jako odbyta');
    END oznacz_odbyta;

    PROCEDURE odwolaj(p_id_lekcji NUMBER) IS
    BEGIN
        UPDATE t_lekcja
        SET status = 'odwolana'
        WHERE id_lekcji = p_id_lekcji AND status = 'zaplanowana';

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20012, 
                'Nie mozna odwolac - lekcja nie istnieje lub nie jest zaplanowana');
        END IF;

        DBMS_OUTPUT.PUT_LINE('Lekcja ID=' || p_id_lekcji || ' odwolana');
    END odwolaj;

    PROCEDURE plan_dnia(p_data DATE DEFAULT SYSDATE) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== PLAN DNIA: ' || TO_CHAR(p_data, 'YYYY-MM-DD (DY)') || ' ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('Godz', 8) || RPAD('Sala', 10) || 
                            RPAD('Uczen', 20) || RPAD('Nauczyciel', 20) || 'Status');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 75, '-'));

        -- Uzycie DEREF do pobrania danych z referencji
        FOR r IN (
            SELECT l.godzina_start,
                   DEREF(l.ref_sala).nazwa AS sala,
                   DEREF(l.ref_uczen).imie || ' ' || DEREF(l.ref_uczen).nazwisko AS uczen,
                   DEREF(l.ref_nauczyciel).imie || ' ' || DEREF(l.ref_nauczyciel).nazwisko AS naucz,
                   l.status
            FROM t_lekcja l
            WHERE TRUNC(l.data_lekcji) = TRUNC(p_data)
            ORDER BY l.godzina_start
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.godzina_start, 8) ||
                RPAD(r.sala, 10) ||
                RPAD(r.uczen, 20) ||
                RPAD(r.naucz, 20) ||
                r.status
            );
        END LOOP;
    END plan_dnia;

    PROCEDURE plan_nauczyciela(p_id_nauczyciela NUMBER, p_data DATE DEFAULT SYSDATE) IS
        v_naucz t_nauczyciel_obj;
    BEGIN
        SELECT VALUE(n) INTO v_naucz
        FROM t_nauczyciel n
        WHERE n.id_nauczyciela = p_id_nauczyciela;

        DBMS_OUTPUT.PUT_LINE('=== PLAN: ' || v_naucz.imie || ' ' || v_naucz.nazwisko || 
                            ' (' || TO_CHAR(p_data, 'YYYY-MM-DD') || ') ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('Godz', 8) || RPAD('Czas', 6) || 
                            RPAD('Sala', 10) || RPAD('Uczen', 25) || 'Kurs');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 70, '-'));

        FOR r IN (
            SELECT l.godzina_start, l.czas_trwania,
                   DEREF(l.ref_sala).nazwa AS sala,
                   DEREF(l.ref_uczen).imie || ' ' || DEREF(l.ref_uczen).nazwisko AS uczen,
                   DEREF(l.ref_kurs).nazwa AS kurs
            FROM t_lekcja l
            WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = p_id_nauczyciela
              AND TRUNC(l.data_lekcji) = TRUNC(p_data)
              AND l.status = 'zaplanowana'
            ORDER BY l.godzina_start
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.godzina_start, 8) ||
                RPAD(r.czas_trwania || 'm', 6) ||
                RPAD(r.sala, 10) ||
                RPAD(r.uczen, 25) ||
                r.kurs
            );
        END LOOP;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono nauczyciela o ID: ' || p_id_nauczyciela);
    END plan_nauczyciela;

    PROCEDURE raport_obciazenia(p_data DATE DEFAULT SYSDATE) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== OBCIAZENIE NAUCZYCIELI (' || TO_CHAR(p_data, 'YYYY-MM-DD') || ') ===');
        DBMS_OUTPUT.PUT_LINE('Limit: max 360 min (6h) dziennie');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 50, '-'));

        FOR r IN (
            SELECT 
                DEREF(l.ref_nauczyciel).imie || ' ' || DEREF(l.ref_nauczyciel).nazwisko AS naucz,
                COUNT(*) AS lekcji,
                SUM(l.czas_trwania) AS minuty
            FROM t_lekcja l
            WHERE TRUNC(l.data_lekcji) = TRUNC(p_data)
              AND l.status IN ('zaplanowana', 'odbyta')
            GROUP BY DEREF(l.ref_nauczyciel).imie, DEREF(l.ref_nauczyciel).nazwisko
            ORDER BY minuty DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.naucz, 30) || 
                r.lekcji || ' lekcji, ' || 
                r.minuty || ' min ' ||
                CASE WHEN r.minuty > 360 THEN '[!!! PRZEKROCZONO]' 
                     WHEN r.minuty >= 300 THEN '[blisko limitu]'
                     ELSE '' END
            );
        END LOOP;
    END raport_obciazenia;

END pkg_lekcja;
/

-- ============================================================================
-- PAKIET 3: PKG_OCENA
-- Zarzadzanie ocenami postepow uczniow
-- ============================================================================
CREATE OR REPLACE PACKAGE pkg_ocena AS
    -- Dodaje nowa ocene
    PROCEDURE dodaj(
        p_id_ucznia     NUMBER,
        p_id_nauczyciela NUMBER,
        p_ocena         NUMBER,
        p_obszar        VARCHAR2,
        p_komentarz     VARCHAR2 DEFAULT NULL
    );
    -- Wyswietla historie ocen ucznia
    PROCEDURE historia_ucznia(p_id_ucznia NUMBER);
    -- Wyswietla raport postepu ucznia
    PROCEDURE raport_postepu(p_id_ucznia NUMBER);
END pkg_ocena;
/

CREATE OR REPLACE PACKAGE BODY pkg_ocena AS

    PROCEDURE dodaj(
        p_id_ucznia     NUMBER,
        p_id_nauczyciela NUMBER,
        p_ocena         NUMBER,
        p_obszar        VARCHAR2,
        p_komentarz     VARCHAR2 DEFAULT NULL
    ) IS
        v_ref_uczen REF t_uczen_obj;
        v_ref_naucz REF t_nauczyciel_obj;
    BEGIN
        -- Pobierz referencje
        SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = p_id_ucznia;
        SELECT REF(n) INTO v_ref_naucz FROM t_nauczyciel n WHERE n.id_nauczyciela = p_id_nauczyciela;

        -- Wstaw ocene
        INSERT INTO t_ocena VALUES (
            t_ocena_obj(
                seq_ocena.NEXTVAL,
                SYSDATE,
                p_ocena,
                p_obszar,
                p_komentarz,
                v_ref_uczen,
                v_ref_naucz
            )
        );

        DBMS_OUTPUT.PUT_LINE('Dodano ocene ' || p_ocena || ' (' || p_obszar || ')');

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20020, 'Nie znaleziono ucznia lub nauczyciela');
    END dodaj;

    PROCEDURE historia_ucznia(p_id_ucznia NUMBER) IS
        v_uczen t_uczen_obj;
    BEGIN
        SELECT VALUE(u) INTO v_uczen FROM t_uczen u WHERE u.id_ucznia = p_id_ucznia;

        DBMS_OUTPUT.PUT_LINE('=== HISTORIA OCEN: ' || v_uczen.imie || ' ' || v_uczen.nazwisko || ' ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('Data', 12) || RPAD('Obszar', 15) || 
                            RPAD('Ocena', 7) || 'Komentarz');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 60, '-'));

        FOR r IN (
            SELECT TO_CHAR(o.data_oceny, 'YYYY-MM-DD') AS data,
                   o.obszar, o.ocena, o.komentarz
            FROM t_ocena o
            WHERE DEREF(o.ref_uczen).id_ucznia = p_id_ucznia
            ORDER BY o.data_oceny DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.data, 12) ||
                RPAD(r.obszar, 15) ||
                RPAD(r.ocena, 7) ||
                NVL(r.komentarz, '')
            );
        END LOOP;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono ucznia o ID: ' || p_id_ucznia);
    END historia_ucznia;

    PROCEDURE raport_postepu(p_id_ucznia NUMBER) IS
        v_uczen t_uczen_obj;
        v_sr_ogolna NUMBER;
    BEGIN
        SELECT VALUE(u) INTO v_uczen FROM t_uczen u WHERE u.id_ucznia = p_id_ucznia;

        DBMS_OUTPUT.PUT_LINE('=== RAPORT POSTEPU: ' || v_uczen.imie || ' ' || v_uczen.nazwisko || ' ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 40, '-'));

        -- Srednie ocen w poszczegolnych obszarach
        FOR r IN (
            SELECT o.obszar, 
                   ROUND(AVG(o.ocena), 2) AS srednia,
                   COUNT(*) AS liczba_ocen
            FROM t_ocena o
            WHERE DEREF(o.ref_uczen).id_ucznia = p_id_ucznia
            GROUP BY o.obszar
            ORDER BY srednia DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.obszar, 15) || ': ' ||
                RPAD(TO_CHAR(r.srednia, '0.00'), 6) ||
                ' (' || r.liczba_ocen || ' ocen)'
            );
        END LOOP;

        -- Srednia ogolna
        SELECT ROUND(AVG(o.ocena), 2) INTO v_sr_ogolna
        FROM t_ocena o
        WHERE DEREF(o.ref_uczen).id_ucznia = p_id_ucznia;

        DBMS_OUTPUT.PUT_LINE(RPAD('-', 40, '-'));
        DBMS_OUTPUT.PUT_LINE('SREDNIA OGOLNA: ' || NVL(TO_CHAR(v_sr_ogolna, '0.00'), 'brak ocen'));

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono ucznia o ID: ' || p_id_ucznia);
    END raport_postepu;

END pkg_ocena;
/

-- ============================================================================
-- PODSUMOWANIE PAKIETOW
-- ============================================================================
-- Utworzono 3 pakiety:
-- 1. pkg_uczen  - 4 procedury, 2 funkcje
-- 2. pkg_lekcja - 6 procedur (zaplanuj zawiera cala logike walidacji)
-- 3. pkg_ocena  - 3 procedury
--
-- Lacznie: 13 procedur/funkcji
-- Demonstracja: kursory FOR, REF/DEREF, obsługa bledow, DBMS_OUTPUT
-- ============================================================================
