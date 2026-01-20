-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 03_pakiety.sql
-- Opis: Pakiety PL/SQL z procedurami, funkcjami i kursorami
-- Wersja: 2.0
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- ============================================================================
-- PAKIET 1: PKG_SEMESTR (NOWY v2.0)
-- Opis: Zarzadzanie semestrami
-- ============================================================================

CREATE OR REPLACE PACKAGE pkg_semestr AS
    
    PROCEDURE utworz_semestr(
        p_nazwa     VARCHAR2,
        p_data_od   DATE,
        p_data_do   DATE,
        p_aktywny   CHAR DEFAULT 'N'
    );
    
    PROCEDURE aktywuj_semestr(p_id_semestru NUMBER);
    
    FUNCTION pobierz_aktywny_semestr RETURN t_semestr_obj;
    
    PROCEDURE info_semestr;

END pkg_semestr;
/

CREATE OR REPLACE PACKAGE BODY pkg_semestr AS

    PROCEDURE utworz_semestr(
        p_nazwa     VARCHAR2,
        p_data_od   DATE,
        p_data_do   DATE,
        p_aktywny   CHAR DEFAULT 'N'
    ) IS
        v_id NUMBER;
    BEGIN
        v_id := seq_semestr.NEXTVAL;
        
        INSERT INTO t_semestr VALUES (
            t_semestr_obj(v_id, p_nazwa, p_data_od, p_data_do, p_aktywny)
        );
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Utworzono semestr: ' || p_nazwa || ' (ID: ' || v_id || ')');
        
        IF p_aktywny = 'T' THEN
            DBMS_OUTPUT.PUT_LINE('Semestr ustawiony jako aktywny.');
        END IF;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('BLAD: Semestr o nazwie "' || p_nazwa || '" juz istnieje.');
            ROLLBACK;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('BLAD: ' || SQLERRM);
            ROLLBACK;
    END utworz_semestr;
    
    PROCEDURE aktywuj_semestr(p_id_semestru NUMBER) IS
    BEGIN
        UPDATE t_semestr SET czy_aktywny = 'T'
        WHERE id_semestru = p_id_semestru;
        
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('BLAD: Nie znaleziono semestru o ID: ' || p_id_semestru);
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Semestr ID: ' || p_id_semestru || ' jest teraz aktywny.');
        END IF;
    END aktywuj_semestr;
    
    FUNCTION pobierz_aktywny_semestr RETURN t_semestr_obj IS
        v_semestr t_semestr_obj;
    BEGIN
        SELECT VALUE(s) INTO v_semestr
        FROM t_semestr s
        WHERE s.czy_aktywny = 'T';
        
        RETURN v_semestr;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END pobierz_aktywny_semestr;
    
    PROCEDURE info_semestr IS
        v_semestr t_semestr_obj;
    BEGIN
        v_semestr := pobierz_aktywny_semestr();
        
        IF v_semestr IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Brak aktywnego semestru!');
        ELSE
            DBMS_OUTPUT.PUT_LINE('=== AKTYWNY SEMESTR ===');
            DBMS_OUTPUT.PUT_LINE('Nazwa: ' || v_semestr.nazwa);
            DBMS_OUTPUT.PUT_LINE('Okres: ' || TO_CHAR(v_semestr.data_od, 'YYYY-MM-DD') ||
                                 ' do ' || TO_CHAR(v_semestr.data_do, 'YYYY-MM-DD'));
            DBMS_OUTPUT.PUT_LINE('W trakcie: ' || v_semestr.czy_w_trakcie());
            DBMS_OUTPUT.PUT_LINE('Dni do konca: ' || v_semestr.dni_do_konca());
        END IF;
    END info_semestr;

END pkg_semestr;
/

-- ============================================================================
-- PAKIET 2: PKG_SALA (NOWY v2.0)
-- Opis: Zarzadzanie salami
-- ============================================================================

CREATE OR REPLACE PACKAGE pkg_sala AS
    
    PROCEDURE dodaj_sale(
        p_nazwa         VARCHAR2,
        p_pojemnosc     NUMBER,
        p_ma_fortepian  CHAR DEFAULT 'N',
        p_ma_perkusje   CHAR DEFAULT 'N',
        p_opis          VARCHAR2 DEFAULT NULL
    );
    
    FUNCTION sprawdz_dostepnosc(
        p_id_sali   NUMBER,
        p_data      DATE,
        p_godzina   VARCHAR2
    ) RETURN VARCHAR2;
    
    PROCEDURE lista_sal;
    
    FUNCTION sale_wolne(p_data DATE, p_godzina VARCHAR2) RETURN SYS_REFCURSOR;

END pkg_sala;
/

CREATE OR REPLACE PACKAGE BODY pkg_sala AS

    PROCEDURE dodaj_sale(
        p_nazwa         VARCHAR2,
        p_pojemnosc     NUMBER,
        p_ma_fortepian  CHAR DEFAULT 'N',
        p_ma_perkusje   CHAR DEFAULT 'N',
        p_opis          VARCHAR2 DEFAULT NULL
    ) IS
        v_id NUMBER;
    BEGIN
        v_id := seq_sala.NEXTVAL;
        
        INSERT INTO t_sala VALUES (
            t_sala_obj(v_id, p_nazwa, p_pojemnosc, p_ma_fortepian, p_ma_perkusje, p_opis)
        );
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Dodano sale: ' || p_nazwa || ' (ID: ' || v_id || ')');
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('BLAD: Sala o nazwie "' || p_nazwa || '" juz istnieje.');
            ROLLBACK;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('BLAD: ' || SQLERRM);
            ROLLBACK;
    END dodaj_sale;
    
    FUNCTION sprawdz_dostepnosc(
        p_id_sali   NUMBER,
        p_data      DATE,
        p_godzina   VARCHAR2
    ) RETURN VARCHAR2 IS
        v_zajeta NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_zajeta
        FROM t_lekcja l
        WHERE DEREF(l.ref_sala).id_sali = p_id_sali
          AND l.data_lekcji = p_data
          AND l.godzina_start = p_godzina
          AND l.status != 'odwolana';
        
        IF v_zajeta > 0 THEN
            RETURN 'ZAJETA';
        ELSE
            RETURN 'WOLNA';
        END IF;
    END sprawdz_dostepnosc;
    
    PROCEDURE lista_sal IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== LISTA SAL ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('ID', 5) || RPAD('Nazwa', 25) || RPAD('Poj.', 6) ||
                             RPAD('Fortepian', 10) || 'Perkusja');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 60, '-'));
        
        FOR rec IN (
            SELECT s.id_sali, s.nazwa, s.pojemnosc, s.ma_fortepian, s.ma_perkusje
            FROM t_sala s
            ORDER BY s.nazwa
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(rec.id_sali, 5) ||
                RPAD(rec.nazwa, 25) ||
                RPAD(rec.pojemnosc, 6) ||
                RPAD(CASE rec.ma_fortepian WHEN 'T' THEN 'TAK' ELSE 'NIE' END, 10) ||
                CASE rec.ma_perkusje WHEN 'T' THEN 'TAK' ELSE 'NIE' END
            );
        END LOOP;
    END lista_sal;
    
    FUNCTION sale_wolne(p_data DATE, p_godzina VARCHAR2) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT s.id_sali, s.nazwa, s.opis_pelny() AS opis
            FROM t_sala s
            WHERE NOT EXISTS (
                SELECT 1 FROM t_lekcja l
                WHERE DEREF(l.ref_sala).id_sali = s.id_sali
                  AND l.data_lekcji = p_data
                  AND l.godzina_start = p_godzina
                  AND l.status != 'odwolana'
            )
            ORDER BY s.nazwa;
        RETURN v_cursor;
    END sale_wolne;

END pkg_sala;
/

-- ============================================================================
-- PAKIET 3: PKG_UCZEN
-- Opis: Zarzadzanie uczniami
-- ============================================================================

CREATE OR REPLACE PACKAGE pkg_uczen AS
    
    c_min_wiek CONSTANT NUMBER := 5;
    
    PROCEDURE dodaj_ucznia(
        p_imie          VARCHAR2,
        p_nazwisko      VARCHAR2,
        p_data_urodzenia DATE,
        p_email         VARCHAR2,
        p_telefon       VARCHAR2 DEFAULT NULL
    );
    
    FUNCTION liczba_uczniow RETURN NUMBER;
    
    FUNCTION uczniowie_wiek(p_wiek_min NUMBER, p_wiek_max NUMBER) RETURN SYS_REFCURSOR;
    
    PROCEDURE lista_uczniow;
    
    FUNCTION srednia_ocen(p_id_ucznia NUMBER) RETURN NUMBER;
    
    e_za_mlody EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_za_mlody, -20001);

END pkg_uczen;
/

CREATE OR REPLACE PACKAGE BODY pkg_uczen AS

    PROCEDURE dodaj_ucznia(
        p_imie          VARCHAR2,
        p_nazwisko      VARCHAR2,
        p_data_urodzenia DATE,
        p_email         VARCHAR2,
        p_telefon       VARCHAR2 DEFAULT NULL
    ) IS
        v_wiek NUMBER;
        v_id   NUMBER;
    BEGIN
        v_wiek := TRUNC(MONTHS_BETWEEN(SYSDATE, p_data_urodzenia) / 12);
        
        IF v_wiek < c_min_wiek THEN
            RAISE_APPLICATION_ERROR(-20001, 
                'Uczen musi miec minimum ' || c_min_wiek || ' lat. Podany wiek: ' || v_wiek);
        END IF;
        
        v_id := seq_uczen.NEXTVAL;
        
        INSERT INTO t_uczen VALUES (
            t_uczen_obj(v_id, p_imie, p_nazwisko, p_data_urodzenia, p_email, p_telefon, SYSDATE)
        );
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Dodano ucznia: ' || p_imie || ' ' || p_nazwisko || ' (ID: ' || v_id || ')');
        
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('BLAD: Email ' || p_email || ' juz istnieje w bazie.');
            ROLLBACK;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('BLAD: ' || SQLERRM);
            ROLLBACK;
    END dodaj_ucznia;
    
    FUNCTION liczba_uczniow RETURN NUMBER IS
        v_liczba NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_liczba FROM t_uczen;
        RETURN v_liczba;
    END liczba_uczniow;
    
    FUNCTION uczniowie_wiek(p_wiek_min NUMBER, p_wiek_max NUMBER) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT u.id_ucznia, u.imie, u.nazwisko, u.wiek() AS wiek
            FROM t_uczen u
            WHERE u.wiek() BETWEEN p_wiek_min AND p_wiek_max
            ORDER BY u.wiek();
        RETURN v_cursor;
    END uczniowie_wiek;
    
    PROCEDURE lista_uczniow IS
        CURSOR c_uczniowie IS
            SELECT u.id_ucznia, u.imie, u.nazwisko, 
                   u.wiek() AS wiek, u.czy_pelnoletni() AS pelnoletni
            FROM t_uczen u
            ORDER BY u.nazwisko, u.imie;
        v_rec c_uczniowie%ROWTYPE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== LISTA UCZNIOW ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('ID', 5) || RPAD('Imie', 15) || 
                             RPAD('Nazwisko', 20) || RPAD('Wiek', 6) || 'Pelnoletni');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 60, '-'));
        
        OPEN c_uczniowie;
        LOOP
            FETCH c_uczniowie INTO v_rec;
            EXIT WHEN c_uczniowie%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE(
                RPAD(v_rec.id_ucznia, 5) || 
                RPAD(v_rec.imie, 15) || 
                RPAD(v_rec.nazwisko, 20) || 
                RPAD(v_rec.wiek, 6) ||
                v_rec.pelnoletni
            );
        END LOOP;
        CLOSE c_uczniowie;
        
        DBMS_OUTPUT.PUT_LINE('Razem uczniow: ' || liczba_uczniow());
    END lista_uczniow;
    
    FUNCTION srednia_ocen(p_id_ucznia NUMBER) RETURN NUMBER IS
        v_srednia NUMBER;
    BEGIN
        SELECT AVG(o.ocena) INTO v_srednia
        FROM t_ocena_postepu o
        WHERE DEREF(o.ref_uczen).id_ucznia = p_id_ucznia;
        
        RETURN ROUND(NVL(v_srednia, 0), 2);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
    END srednia_ocen;

END pkg_uczen;
/

-- ============================================================================
-- PAKIET 4: PKG_LEKCJA (ROZSZERZONY v2.0)
-- Opis: Zarzadzanie lekcjami
-- ============================================================================

CREATE OR REPLACE PACKAGE pkg_lekcja AS
    
    PROCEDURE zaplanuj_lekcje(
        p_id_ucznia     NUMBER,
        p_id_nauczyciela NUMBER,
        p_id_kursu      NUMBER,
        p_id_sali       NUMBER,
        p_data          DATE,
        p_godzina       VARCHAR2,
        p_czas_trwania  NUMBER DEFAULT 45
    );
    
    PROCEDURE oznacz_odbyta(
        p_id_lekcji NUMBER,
        p_temat     VARCHAR2,
        p_uwagi     VARCHAR2 DEFAULT NULL
    );
    
    PROCEDURE odwolaj_lekcje(p_id_lekcji NUMBER);
    
    FUNCTION lekcje_ucznia(p_id_ucznia NUMBER, p_miesiac DATE) RETURN SYS_REFCURSOR;
    
    FUNCTION lekcje_tygodniowo(p_id_nauczyciela NUMBER) RETURN NUMBER;
    
    PROCEDURE raport_dzienny(p_data DATE);
    
    FUNCTION sprawdz_dostepnosc_kompleksowa(
        p_id_ucznia     NUMBER,
        p_id_nauczyciela NUMBER,
        p_id_sali       NUMBER,
        p_data          DATE,
        p_godzina       VARCHAR2
    ) RETURN VARCHAR2;
    
    PROCEDURE statystyki_nauczyciela(p_id_nauczyciela NUMBER, p_data DATE);

END pkg_lekcja;
/

CREATE OR REPLACE PACKAGE BODY pkg_lekcja AS

    PROCEDURE zaplanuj_lekcje(
        p_id_ucznia     NUMBER,
        p_id_nauczyciela NUMBER,
        p_id_kursu      NUMBER,
        p_id_sali       NUMBER,
        p_data          DATE,
        p_godzina       VARCHAR2,
        p_czas_trwania  NUMBER DEFAULT 45
    ) IS
        v_id            NUMBER;
        v_ref_uczen     REF t_uczen_obj;
        v_ref_nauczyciel REF t_nauczyciel_obj;
        v_ref_kurs      REF t_kurs_obj;
        v_ref_sala      REF t_sala_obj;
    BEGIN
        SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = p_id_ucznia;
        SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = p_id_nauczyciela;
        SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = p_id_kursu;
        SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = p_id_sali;
        
        v_id := seq_lekcja.NEXTVAL;
        
        INSERT INTO t_lekcja VALUES (
            t_lekcja_obj(
                v_id, p_data, p_godzina, p_czas_trwania,
                NULL, NULL, 'zaplanowana',
                v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala
            )
        );
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Zaplanowano lekcje ID: ' || v_id || 
                             ' na dzien ' || TO_CHAR(p_data, 'YYYY-MM-DD') ||
                             ' godz. ' || p_godzina);
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('BLAD: Nie znaleziono ucznia/nauczyciela/kursu/sali.');
            ROLLBACK;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('BLAD: ' || SQLERRM);
            ROLLBACK;
    END zaplanuj_lekcje;
    
    PROCEDURE oznacz_odbyta(
        p_id_lekcji NUMBER,
        p_temat     VARCHAR2,
        p_uwagi     VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        UPDATE t_lekcja l
        SET l.status = 'odbyta', l.temat = p_temat, l.uwagi = p_uwagi
        WHERE l.id_lekcji = p_id_lekcji AND l.status = 'zaplanowana';
        
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('UWAGA: Lekcja nie istnieje lub nie jest zaplanowana.');
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Lekcja ID: ' || p_id_lekcji || ' oznaczona jako odbyta.');
        END IF;
    END oznacz_odbyta;
    
    PROCEDURE odwolaj_lekcje(p_id_lekcji NUMBER) IS
    BEGIN
        UPDATE t_lekcja l
        SET l.status = 'odwolana'
        WHERE l.id_lekcji = p_id_lekcji AND l.status = 'zaplanowana';
        
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('UWAGA: Lekcja nie istnieje lub nie mozna jej odwolac.');
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Lekcja ID: ' || p_id_lekcji || ' zostala odwolana.');
        END IF;
    END odwolaj_lekcje;
    
    FUNCTION lekcje_ucznia(p_id_ucznia NUMBER, p_miesiac DATE) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT l.id_lekcji, l.data_lekcji, l.godzina_start,
                   DEREF(l.ref_nauczyciel).pelne_dane() AS nauczyciel,
                   DEREF(l.ref_kurs).nazwa AS kurs,
                   DEREF(l.ref_sala).nazwa AS sala,
                   l.status
            FROM t_lekcja l
            WHERE DEREF(l.ref_uczen).id_ucznia = p_id_ucznia
              AND TRUNC(l.data_lekcji, 'MM') = TRUNC(p_miesiac, 'MM')
            ORDER BY l.data_lekcji, l.godzina_start;
        RETURN v_cursor;
    END lekcje_ucznia;
    
    FUNCTION lekcje_tygodniowo(p_id_nauczyciela NUMBER) RETURN NUMBER IS
        v_liczba NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_liczba
        FROM t_lekcja l
        WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = p_id_nauczyciela
          AND l.data_lekcji BETWEEN TRUNC(SYSDATE, 'IW') AND TRUNC(SYSDATE, 'IW') + 6
          AND l.status != 'odwolana';
        RETURN v_liczba;
    END lekcje_tygodniowo;
    
    PROCEDURE raport_dzienny(p_data DATE) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== LEKCJE NA DZIEN ' || TO_CHAR(p_data, 'YYYY-MM-DD') || ' ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('Godz', 6) || RPAD('Sala', 15) || RPAD('Nauczyciel', 20) || 
                             RPAD('Uczen', 20) || RPAD('Kurs', 20) || 'Status');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 100, '-'));
        
        FOR rec IN (
            SELECT l.godzina_start,
                   DEREF(l.ref_sala).nazwa AS sala,
                   DEREF(l.ref_nauczyciel).imie || ' ' || DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
                   DEREF(l.ref_uczen).imie || ' ' || DEREF(l.ref_uczen).nazwisko AS uczen,
                   DEREF(l.ref_kurs).nazwa AS kurs,
                   l.status
            FROM t_lekcja l
            WHERE l.data_lekcji = p_data
            ORDER BY l.godzina_start
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(rec.godzina_start, 6) ||
                RPAD(NVL(rec.sala, '-'), 15) ||
                RPAD(rec.nauczyciel, 20) ||
                RPAD(rec.uczen, 20) ||
                RPAD(rec.kurs, 20) ||
                rec.status
            );
        END LOOP;
    END raport_dzienny;
    
    FUNCTION sprawdz_dostepnosc_kompleksowa(
        p_id_ucznia     NUMBER,
        p_id_nauczyciela NUMBER,
        p_id_sali       NUMBER,
        p_data          DATE,
        p_godzina       VARCHAR2
    ) RETURN VARCHAR2 IS
        v_konflikt NUMBER;
        v_wynik VARCHAR2(200) := 'OK';
    BEGIN
        SELECT COUNT(*) INTO v_konflikt FROM t_lekcja l
        WHERE DEREF(l.ref_uczen).id_ucznia = p_id_ucznia
          AND l.data_lekcji = p_data AND l.godzina_start = p_godzina AND l.status != 'odwolana';
        IF v_konflikt > 0 THEN RETURN 'BLAD: Uczen zajety'; END IF;
        
        SELECT COUNT(*) INTO v_konflikt FROM t_lekcja l
        WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = p_id_nauczyciela
          AND l.data_lekcji = p_data AND l.godzina_start = p_godzina AND l.status != 'odwolana';
        IF v_konflikt > 0 THEN RETURN 'BLAD: Nauczyciel zajety'; END IF;
        
        SELECT COUNT(*) INTO v_konflikt FROM t_lekcja l
        WHERE DEREF(l.ref_sala).id_sali = p_id_sali
          AND l.data_lekcji = p_data AND l.godzina_start = p_godzina AND l.status != 'odwolana';
        IF v_konflikt > 0 THEN RETURN 'BLAD: Sala zajeta'; END IF;
        
        RETURN v_wynik;
    END sprawdz_dostepnosc_kompleksowa;
    
    PROCEDURE statystyki_nauczyciela(p_id_nauczyciela NUMBER, p_data DATE) IS
        v_suma_minut NUMBER;
        v_liczba_lekcji NUMBER;
    BEGIN
        SELECT NVL(SUM(l.czas_trwania), 0), COUNT(*)
        INTO v_suma_minut, v_liczba_lekcji
        FROM t_lekcja l
        WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = p_id_nauczyciela
          AND l.data_lekcji = p_data AND l.status = 'zaplanowana';
        
        DBMS_OUTPUT.PUT_LINE('=== STATYSTYKI NAUCZYCIELA (dzien: ' || TO_CHAR(p_data, 'YYYY-MM-DD') || ') ===');
        DBMS_OUTPUT.PUT_LINE('Liczba lekcji: ' || v_liczba_lekcji);
        DBMS_OUTPUT.PUT_LINE('Suma minut: ' || v_suma_minut || ' / 360 (limit 6h)');
        DBMS_OUTPUT.PUT_LINE('Pozostalo: ' || (360 - v_suma_minut) || ' minut');
    END statystyki_nauczyciela;

END pkg_lekcja;
/

-- ============================================================================
-- PAKIET 5: PKG_OCENA
-- Opis: Zarzadzanie ocenami i postepami
-- ============================================================================

CREATE OR REPLACE PACKAGE pkg_ocena AS
    
    PROCEDURE dodaj_ocene(
        p_id_ucznia     NUMBER,
        p_id_nauczyciela NUMBER,
        p_ocena         NUMBER,
        p_obszar        VARCHAR2,
        p_komentarz     VARCHAR2 DEFAULT NULL
    );
    
    FUNCTION ostatnie_oceny(p_id_ucznia NUMBER, p_limit NUMBER DEFAULT 5) RETURN SYS_REFCURSOR;
    
    PROCEDURE raport_postepu(p_id_ucznia NUMBER);
    
    FUNCTION srednia_obszar(p_id_ucznia NUMBER, p_obszar VARCHAR2) RETURN NUMBER;
    
    PROCEDURE porownaj_uczniow(p_id_ucznia_1 NUMBER, p_id_ucznia_2 NUMBER);

END pkg_ocena;
/

CREATE OR REPLACE PACKAGE BODY pkg_ocena AS

    PROCEDURE dodaj_ocene(
        p_id_ucznia     NUMBER,
        p_id_nauczyciela NUMBER,
        p_ocena         NUMBER,
        p_obszar        VARCHAR2,
        p_komentarz     VARCHAR2 DEFAULT NULL
    ) IS
        v_id            NUMBER;
        v_ref_uczen     REF t_uczen_obj;
        v_ref_nauczyciel REF t_nauczyciel_obj;
    BEGIN
        IF p_ocena NOT BETWEEN 1 AND 6 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Ocena musi byc w zakresie 1-6. Podano: ' || p_ocena);
        END IF;
        
        SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = p_id_ucznia;
        SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = p_id_nauczyciela;
        
        v_id := seq_ocena.NEXTVAL;
        
        INSERT INTO t_ocena_postepu VALUES (
            t_ocena_obj(v_id, SYSDATE, p_ocena, p_komentarz, p_obszar, v_ref_uczen, v_ref_nauczyciel)
        );
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Dodano ocene ' || p_ocena || ' (' || p_obszar || ') dla ucznia ID: ' || p_id_ucznia);
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('BLAD: Nie znaleziono ucznia lub nauczyciela.');
            ROLLBACK;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('BLAD: ' || SQLERRM);
            ROLLBACK;
    END dodaj_ocene;
    
    FUNCTION ostatnie_oceny(p_id_ucznia NUMBER, p_limit NUMBER DEFAULT 5) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT o.data_oceny, o.ocena, o.obszar, o.komentarz,
                   DEREF(o.ref_nauczyciel).pelne_dane() AS nauczyciel
            FROM t_ocena_postepu o
            WHERE DEREF(o.ref_uczen).id_ucznia = p_id_ucznia
            ORDER BY o.data_oceny DESC
            FETCH FIRST p_limit ROWS ONLY;
        RETURN v_cursor;
    END ostatnie_oceny;
    
    PROCEDURE raport_postepu(p_id_ucznia NUMBER) IS
        v_uczen t_uczen_obj;
        v_srednia NUMBER;
    BEGIN
        SELECT VALUE(u) INTO v_uczen FROM t_uczen u WHERE u.id_ucznia = p_id_ucznia;
        
        DBMS_OUTPUT.PUT_LINE('=== RAPORT POSTEPU ===');
        DBMS_OUTPUT.PUT_LINE('Uczen: ' || v_uczen.pelne_dane());
        DBMS_OUTPUT.PUT_LINE('Status: ' || CASE v_uczen.czy_pelnoletni() 
                                            WHEN 'TAK' THEN 'Pelnoletni' ELSE 'Niepelnoletni' END);
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('--- Srednie w obszarach ---');
        
        FOR rec IN (
            SELECT obszar, ROUND(AVG(ocena), 2) AS srednia, COUNT(*) AS ilosc
            FROM t_ocena_postepu o
            WHERE DEREF(o.ref_uczen).id_ucznia = p_id_ucznia
            GROUP BY obszar ORDER BY srednia DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(RPAD(rec.obszar, 15) || ': ' || rec.srednia || ' (ocen: ' || rec.ilosc || ')');
        END LOOP;
        
        v_srednia := pkg_uczen.srednia_ocen(p_id_ucznia);
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('SREDNIA OGOLNA: ' || v_srednia);
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('BLAD: Nie znaleziono ucznia o ID: ' || p_id_ucznia);
    END raport_postepu;
    
    FUNCTION srednia_obszar(p_id_ucznia NUMBER, p_obszar VARCHAR2) RETURN NUMBER IS
        v_srednia NUMBER;
    BEGIN
        SELECT AVG(o.ocena) INTO v_srednia
        FROM t_ocena_postepu o
        WHERE DEREF(o.ref_uczen).id_ucznia = p_id_ucznia AND o.obszar = p_obszar;
        RETURN ROUND(NVL(v_srednia, 0), 2);
    END srednia_obszar;
    
    PROCEDURE porownaj_uczniow(p_id_ucznia_1 NUMBER, p_id_ucznia_2 NUMBER) IS
        v_uczen1 t_uczen_obj;
        v_uczen2 t_uczen_obj;
        v_sr1 NUMBER;
        v_sr2 NUMBER;
    BEGIN
        SELECT VALUE(u) INTO v_uczen1 FROM t_uczen u WHERE u.id_ucznia = p_id_ucznia_1;
        SELECT VALUE(u) INTO v_uczen2 FROM t_uczen u WHERE u.id_ucznia = p_id_ucznia_2;
        
        v_sr1 := pkg_uczen.srednia_ocen(p_id_ucznia_1);
        v_sr2 := pkg_uczen.srednia_ocen(p_id_ucznia_2);
        
        DBMS_OUTPUT.PUT_LINE('=== POROWNANIE UCZNIOW ===');
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE(RPAD('Kryterium', 20) || RPAD(v_uczen1.nazwisko, 15) || RPAD(v_uczen2.nazwisko, 15));
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 50, '-'));
        DBMS_OUTPUT.PUT_LINE(RPAD('Wiek', 20) || RPAD(v_uczen1.wiek(), 15) || RPAD(v_uczen2.wiek(), 15));
        DBMS_OUTPUT.PUT_LINE(RPAD('Srednia ocen', 20) || RPAD(v_sr1, 15) || RPAD(v_sr2, 15));
        DBMS_OUTPUT.PUT_LINE('');
        
        IF v_sr1 > v_sr2 THEN
            DBMS_OUTPUT.PUT_LINE('Lepsze wyniki: ' || v_uczen1.pelne_dane());
        ELSIF v_sr2 > v_sr1 THEN
            DBMS_OUTPUT.PUT_LINE('Lepsze wyniki: ' || v_uczen2.pelne_dane());
        ELSE
            DBMS_OUTPUT.PUT_LINE('Wyniki sa rowne!');
        END IF;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('BLAD: Nie znaleziono jednego z uczniow.');
    END porownaj_uczniow;

END pkg_ocena;
/

-- ============================================================================
-- PODSUMOWANIE PAKIETOW - WERSJA 2.0
-- ============================================================================
/*
Utworzono 5 pakietow:

1. PKG_SEMESTR (4 procedury/funkcje) [NEW v2.0]:
   - utworz_semestr()
   - aktywuj_semestr()
   - pobierz_aktywny_semestr()
   - info_semestr()

2. PKG_SALA (4 procedury/funkcje) [NEW v2.0]:
   - dodaj_sale()
   - sprawdz_dostepnosc()
   - lista_sal()
   - sale_wolne() - REF CURSOR

3. PKG_UCZEN (5 procedur/funkcji):
   - dodaj_ucznia()
   - liczba_uczniow()
   - uczniowie_wiek() - REF CURSOR
   - lista_uczniow() - kursor jawny
   - srednia_ocen()

4. PKG_LEKCJA (8 procedur/funkcji) [ROZSZERZONY]:
   - zaplanuj_lekcje() - z sala
   - oznacz_odbyta()
   - odwolaj_lekcje()
   - lekcje_ucznia() - REF CURSOR
   - lekcje_tygodniowo()
   - raport_dzienny() - kursor FOR
   - sprawdz_dostepnosc_kompleksowa() [NEW]
   - statystyki_nauczyciela() [NEW]

5. PKG_OCENA (5 procedur/funkcji):
   - dodaj_ocene()
   - ostatnie_oceny() - REF CURSOR z FETCH FIRST
   - raport_postepu()
   - srednia_obszar()
   - porownaj_uczniow()

STATYSTYKI:
- Pakiety: 5 (bylo 3, +2 nowe)
- Procedury/funkcje: 26 (bylo 16, +10 nowych)
- REF CURSOR: 5
- Kursory jawne: 1
*/

PROMPT ========================================
PROMPT Pakiety PL/SQL utworzone pomyslnie!
PROMPT Wersja 2.0 - 5 pakietow, 26 procedur
PROMPT ========================================
