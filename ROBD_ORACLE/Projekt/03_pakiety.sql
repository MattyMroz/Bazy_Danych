-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 03_pakiety.sql
-- Opis: Pakiety PL/SQL z procedurami, funkcjami i kursorami
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- ============================================================================
-- PAKIET 1: PKG_UCZEN
-- Opis: Zarzadzanie uczniami
-- ============================================================================

CREATE OR REPLACE PACKAGE pkg_uczen AS
    
    -- Stala - minimalny wiek ucznia
    c_min_wiek CONSTANT NUMBER := 5;
    
    -- Procedura: Dodaje nowego ucznia
    PROCEDURE dodaj_ucznia(
        p_imie          VARCHAR2,
        p_nazwisko      VARCHAR2,
        p_data_urodzenia DATE,
        p_email         VARCHAR2,
        p_telefon       VARCHAR2 DEFAULT NULL
    );
    
    -- Funkcja: Zwraca liczbe uczniow
    FUNCTION liczba_uczniow RETURN NUMBER;
    
    -- Funkcja: Zwraca uczniow w podanym przedziale wiekowym
    FUNCTION uczniowie_wiek(p_wiek_min NUMBER, p_wiek_max NUMBER) 
        RETURN SYS_REFCURSOR;
    
    -- Procedura: Wyswietla wszystkich uczniow (uzywa kursora)
    PROCEDURE lista_uczniow;
    
    -- Funkcja: Oblicza srednia ocen ucznia
    FUNCTION srednia_ocen(p_id_ucznia NUMBER) RETURN NUMBER;
    
    -- Wyjatek uzytkownika
    e_za_mlody EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_za_mlody, -20001);

END pkg_uczen;
/

CREATE OR REPLACE PACKAGE BODY pkg_uczen AS

    -- ========================================================================
    -- PROCEDURA: dodaj_ucznia
    -- ========================================================================
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
        -- Obliczamy wiek
        v_wiek := TRUNC(MONTHS_BETWEEN(SYSDATE, p_data_urodzenia) / 12);
        
        -- Walidacja wieku
        IF v_wiek < c_min_wiek THEN
            RAISE_APPLICATION_ERROR(-20001, 
                'Uczen musi miec minimum ' || c_min_wiek || ' lat. Podany wiek: ' || v_wiek);
        END IF;
        
        -- Pobieramy nastepny ID
        v_id := seq_uczen.NEXTVAL;
        
        -- Wstawiamy ucznia
        INSERT INTO t_uczen VALUES (
            t_uczen_obj(
                v_id,
                p_imie,
                p_nazwisko,
                p_data_urodzenia,
                p_email,
                p_telefon,
                SYSDATE
            )
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
    
    -- ========================================================================
    -- FUNKCJA: liczba_uczniow
    -- ========================================================================
    FUNCTION liczba_uczniow RETURN NUMBER IS
        v_liczba NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_liczba FROM t_uczen;
        RETURN v_liczba;
    END liczba_uczniow;
    
    -- ========================================================================
    -- FUNKCJA: uczniowie_wiek (REF CURSOR)
    -- ========================================================================
    FUNCTION uczniowie_wiek(p_wiek_min NUMBER, p_wiek_max NUMBER) 
        RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT u.id_ucznia, u.imie, u.nazwisko, u.wiek() AS wiek
            FROM t_uczen u
            WHERE u.wiek() BETWEEN p_wiek_min AND p_wiek_max
            ORDER BY u.wiek();
        RETURN v_cursor;
    END uczniowie_wiek;
    
    -- ========================================================================
    -- PROCEDURA: lista_uczniow (z kursorem jawnym)
    -- ========================================================================
    PROCEDURE lista_uczniow IS
        -- Kursor jawny
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
    
    -- ========================================================================
    -- FUNKCJA: srednia_ocen
    -- ========================================================================
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
-- PAKIET 2: PKG_LEKCJA
-- Opis: Zarzadzanie lekcjami
-- ============================================================================

CREATE OR REPLACE PACKAGE pkg_lekcja AS
    
    -- Procedura: Planuje nowa lekcje
    PROCEDURE zaplanuj_lekcje(
        p_id_ucznia     NUMBER,
        p_id_nauczyciela NUMBER,
        p_id_kursu      NUMBER,
        p_data          DATE,
        p_godzina       VARCHAR2,
        p_czas_trwania  NUMBER DEFAULT 45
    );
    
    -- Procedura: Oznacza lekcje jako odbyta
    PROCEDURE oznacz_odbyta(
        p_id_lekcji NUMBER,
        p_temat     VARCHAR2,
        p_uwagi     VARCHAR2 DEFAULT NULL
    );
    
    -- Procedura: Odwoluje lekcje
    PROCEDURE odwolaj_lekcje(p_id_lekcji NUMBER);
    
    -- Funkcja: Zwraca lekcje ucznia w danym miesiacu
    FUNCTION lekcje_ucznia(p_id_ucznia NUMBER, p_miesiac DATE) 
        RETURN SYS_REFCURSOR;
    
    -- Funkcja: Liczy lekcje nauczyciela w tygodniu
    FUNCTION lekcje_tygodniowo(p_id_nauczyciela NUMBER) RETURN NUMBER;
    
    -- Procedura: Raport lekcji na dzien
    PROCEDURE raport_dzienny(p_data DATE);

END pkg_lekcja;
/

CREATE OR REPLACE PACKAGE BODY pkg_lekcja AS

    -- ========================================================================
    -- PROCEDURA: zaplanuj_lekcje
    -- ========================================================================
    PROCEDURE zaplanuj_lekcje(
        p_id_ucznia     NUMBER,
        p_id_nauczyciela NUMBER,
        p_id_kursu      NUMBER,
        p_data          DATE,
        p_godzina       VARCHAR2,
        p_czas_trwania  NUMBER DEFAULT 45
    ) IS
        v_id            NUMBER;
        v_ref_uczen     REF t_uczen_obj;
        v_ref_nauczyciel REF t_nauczyciel_obj;
        v_ref_kurs      REF t_kurs_obj;
        v_konflikt      NUMBER;
    BEGIN
        -- Pobieramy referencje
        SELECT REF(u) INTO v_ref_uczen 
        FROM t_uczen u WHERE u.id_ucznia = p_id_ucznia;
        
        SELECT REF(n) INTO v_ref_nauczyciel 
        FROM t_nauczyciel n WHERE n.id_nauczyciela = p_id_nauczyciela;
        
        SELECT REF(k) INTO v_ref_kurs 
        FROM t_kurs k WHERE k.id_kursu = p_id_kursu;
        
        -- Sprawdzamy konflikt czasowy nauczyciela
        SELECT COUNT(*) INTO v_konflikt
        FROM t_lekcja l
        WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = p_id_nauczyciela
          AND l.data_lekcji = p_data
          AND l.godzina_start = p_godzina
          AND l.status != 'odwolana';
        
        IF v_konflikt > 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 
                'Nauczyciel ma juz lekcje o tej godzinie!');
        END IF;
        
        -- Wstawiamy lekcje
        v_id := seq_lekcja.NEXTVAL;
        
        INSERT INTO t_lekcja VALUES (
            t_lekcja_obj(
                v_id,
                p_data,
                p_godzina,
                p_czas_trwania,
                NULL,           -- temat
                NULL,           -- uwagi
                'zaplanowana',
                v_ref_uczen,
                v_ref_nauczyciel,
                v_ref_kurs
            )
        );
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Zaplanowano lekcje ID: ' || v_id || 
                             ' na dzien ' || TO_CHAR(p_data, 'YYYY-MM-DD') ||
                             ' godz. ' || p_godzina);
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('BLAD: Nie znaleziono ucznia/nauczyciela/kursu.');
            ROLLBACK;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('BLAD: ' || SQLERRM);
            ROLLBACK;
    END zaplanuj_lekcje;
    
    -- ========================================================================
    -- PROCEDURA: oznacz_odbyta
    -- ========================================================================
    PROCEDURE oznacz_odbyta(
        p_id_lekcji NUMBER,
        p_temat     VARCHAR2,
        p_uwagi     VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        UPDATE t_lekcja l
        SET l.status = 'odbyta',
            l.temat = p_temat,
            l.uwagi = p_uwagi
        WHERE l.id_lekcji = p_id_lekcji
          AND l.status = 'zaplanowana';
        
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('UWAGA: Lekcja nie istnieje lub nie jest zaplanowana.');
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Lekcja ID: ' || p_id_lekcji || ' oznaczona jako odbyta.');
        END IF;
    END oznacz_odbyta;
    
    -- ========================================================================
    -- PROCEDURA: odwolaj_lekcje
    -- ========================================================================
    PROCEDURE odwolaj_lekcje(p_id_lekcji NUMBER) IS
    BEGIN
        UPDATE t_lekcja l
        SET l.status = 'odwolana'
        WHERE l.id_lekcji = p_id_lekcji
          AND l.status = 'zaplanowana';
        
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('UWAGA: Lekcja nie istnieje lub nie mozna jej odwolac.');
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Lekcja ID: ' || p_id_lekcji || ' zostala odwolana.');
        END IF;
    END odwolaj_lekcje;
    
    -- ========================================================================
    -- FUNKCJA: lekcje_ucznia (REF CURSOR)
    -- ========================================================================
    FUNCTION lekcje_ucznia(p_id_ucznia NUMBER, p_miesiac DATE) 
        RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT l.id_lekcji, 
                   l.data_lekcji,
                   l.godzina_start,
                   DEREF(l.ref_nauczyciel).pelne_dane() AS nauczyciel,
                   DEREF(l.ref_kurs).nazwa AS kurs,
                   l.status
            FROM t_lekcja l
            WHERE DEREF(l.ref_uczen).id_ucznia = p_id_ucznia
              AND TRUNC(l.data_lekcji, 'MM') = TRUNC(p_miesiac, 'MM')
            ORDER BY l.data_lekcji, l.godzina_start;
        RETURN v_cursor;
    END lekcje_ucznia;
    
    -- ========================================================================
    -- FUNKCJA: lekcje_tygodniowo
    -- ========================================================================
    FUNCTION lekcje_tygodniowo(p_id_nauczyciela NUMBER) RETURN NUMBER IS
        v_liczba NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_liczba
        FROM t_lekcja l
        WHERE DEREF(l.ref_nauczyciel).id_nauczyciela = p_id_nauczyciela
          AND l.data_lekcji BETWEEN TRUNC(SYSDATE, 'IW') 
                                AND TRUNC(SYSDATE, 'IW') + 6
          AND l.status != 'odwolana';
        RETURN v_liczba;
    END lekcje_tygodniowo;
    
    -- ========================================================================
    -- PROCEDURA: raport_dzienny (z kursorem FOR)
    -- ========================================================================
    PROCEDURE raport_dzienny(p_data DATE) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== LEKCJE NA DZIEN ' || TO_CHAR(p_data, 'YYYY-MM-DD') || ' ===');
        DBMS_OUTPUT.PUT_LINE(RPAD('Godz', 6) || RPAD('Nauczyciel', 25) || 
                             RPAD('Uczen', 25) || RPAD('Kurs', 20) || 'Status');
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 90, '-'));
        
        -- Kursor FOR (niejawny)
        FOR rec IN (
            SELECT l.godzina_start,
                   DEREF(l.ref_nauczyciel).imie || ' ' || 
                   DEREF(l.ref_nauczyciel).nazwisko AS nauczyciel,
                   DEREF(l.ref_uczen).imie || ' ' || 
                   DEREF(l.ref_uczen).nazwisko AS uczen,
                   DEREF(l.ref_kurs).nazwa AS kurs,
                   l.status
            FROM t_lekcja l
            WHERE l.data_lekcji = p_data
            ORDER BY l.godzina_start
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(rec.godzina_start, 6) ||
                RPAD(rec.nauczyciel, 25) ||
                RPAD(rec.uczen, 25) ||
                RPAD(rec.kurs, 20) ||
                rec.status
            );
        END LOOP;
    END raport_dzienny;

END pkg_lekcja;
/

-- ============================================================================
-- PAKIET 3: PKG_OCENA
-- Opis: Zarzadzanie ocenami i postepami
-- ============================================================================

CREATE OR REPLACE PACKAGE pkg_ocena AS
    
    -- Procedura: Dodaje ocene postepu
    PROCEDURE dodaj_ocene(
        p_id_ucznia     NUMBER,
        p_id_nauczyciela NUMBER,
        p_ocena         NUMBER,
        p_obszar        VARCHAR2,
        p_komentarz     VARCHAR2 DEFAULT NULL
    );
    
    -- Funkcja: Pobiera ostatnie oceny ucznia
    FUNCTION ostatnie_oceny(p_id_ucznia NUMBER, p_limit NUMBER DEFAULT 5) 
        RETURN SYS_REFCURSOR;
    
    -- Procedura: Raport postepu ucznia
    PROCEDURE raport_postepu(p_id_ucznia NUMBER);
    
    -- Funkcja: Srednia ocen w obszarze
    FUNCTION srednia_obszar(p_id_ucznia NUMBER, p_obszar VARCHAR2) RETURN NUMBER;
    
    -- Procedura: Porownanie uczniow
    PROCEDURE porownaj_uczniow(p_id_ucznia_1 NUMBER, p_id_ucznia_2 NUMBER);

END pkg_ocena;
/

CREATE OR REPLACE PACKAGE BODY pkg_ocena AS

    -- ========================================================================
    -- PROCEDURA: dodaj_ocene
    -- ========================================================================
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
        -- Walidacja oceny
        IF p_ocena NOT BETWEEN 1 AND 6 THEN
            RAISE_APPLICATION_ERROR(-20003, 
                'Ocena musi byc w zakresie 1-6. Podano: ' || p_ocena);
        END IF;
        
        -- Pobieramy referencje
        SELECT REF(u) INTO v_ref_uczen 
        FROM t_uczen u WHERE u.id_ucznia = p_id_ucznia;
        
        SELECT REF(n) INTO v_ref_nauczyciel 
        FROM t_nauczyciel n WHERE n.id_nauczyciela = p_id_nauczyciela;
        
        -- Wstawiamy ocene
        v_id := seq_ocena.NEXTVAL;
        
        INSERT INTO t_ocena_postepu VALUES (
            t_ocena_obj(
                v_id,
                SYSDATE,
                p_ocena,
                p_komentarz,
                p_obszar,
                v_ref_uczen,
                v_ref_nauczyciel
            )
        );
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Dodano ocene ' || p_ocena || ' (' || p_obszar || 
                             ') dla ucznia ID: ' || p_id_ucznia);
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('BLAD: Nie znaleziono ucznia lub nauczyciela.');
            ROLLBACK;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('BLAD: ' || SQLERRM);
            ROLLBACK;
    END dodaj_ocene;
    
    -- ========================================================================
    -- FUNKCJA: ostatnie_oceny (REF CURSOR)
    -- ========================================================================
    FUNCTION ostatnie_oceny(p_id_ucznia NUMBER, p_limit NUMBER DEFAULT 5) 
        RETURN SYS_REFCURSOR IS
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
    
    -- ========================================================================
    -- PROCEDURA: raport_postepu
    -- ========================================================================
    PROCEDURE raport_postepu(p_id_ucznia NUMBER) IS
        v_uczen     t_uczen_obj;
        v_srednia   NUMBER;
    BEGIN
        -- Pobieramy dane ucznia
        SELECT VALUE(u) INTO v_uczen 
        FROM t_uczen u WHERE u.id_ucznia = p_id_ucznia;
        
        DBMS_OUTPUT.PUT_LINE('=== RAPORT POSTEPU ===');
        DBMS_OUTPUT.PUT_LINE('Uczen: ' || v_uczen.pelne_dane());
        DBMS_OUTPUT.PUT_LINE('Status: ' || CASE v_uczen.czy_pelnoletni() 
                                            WHEN 'TAK' THEN 'Pelnoletni'
                                            ELSE 'Niepelnoletni' END);
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('--- Srednie w obszarach ---');
        
        -- Srednie w poszczegolnych obszarach
        FOR rec IN (
            SELECT obszar, ROUND(AVG(ocena), 2) AS srednia, COUNT(*) AS ilosc
            FROM t_ocena_postepu o
            WHERE DEREF(o.ref_uczen).id_ucznia = p_id_ucznia
            GROUP BY obszar
            ORDER BY srednia DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(RPAD(rec.obszar, 15) || ': ' || 
                                 rec.srednia || ' (ocen: ' || rec.ilosc || ')');
        END LOOP;
        
        -- Srednia ogolna
        v_srednia := pkg_uczen.srednia_ocen(p_id_ucznia);
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('SREDNIA OGOLNA: ' || v_srednia);
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('BLAD: Nie znaleziono ucznia o ID: ' || p_id_ucznia);
    END raport_postepu;
    
    -- ========================================================================
    -- FUNKCJA: srednia_obszar
    -- ========================================================================
    FUNCTION srednia_obszar(p_id_ucznia NUMBER, p_obszar VARCHAR2) RETURN NUMBER IS
        v_srednia NUMBER;
    BEGIN
        SELECT AVG(o.ocena) INTO v_srednia
        FROM t_ocena_postepu o
        WHERE DEREF(o.ref_uczen).id_ucznia = p_id_ucznia
          AND o.obszar = p_obszar;
        
        RETURN ROUND(NVL(v_srednia, 0), 2);
    END srednia_obszar;
    
    -- ========================================================================
    -- PROCEDURA: porownaj_uczniow
    -- ========================================================================
    PROCEDURE porownaj_uczniow(p_id_ucznia_1 NUMBER, p_id_ucznia_2 NUMBER) IS
        v_uczen1    t_uczen_obj;
        v_uczen2    t_uczen_obj;
        v_sr1       NUMBER;
        v_sr2       NUMBER;
    BEGIN
        -- Pobieramy dane uczniow
        SELECT VALUE(u) INTO v_uczen1 FROM t_uczen u WHERE u.id_ucznia = p_id_ucznia_1;
        SELECT VALUE(u) INTO v_uczen2 FROM t_uczen u WHERE u.id_ucznia = p_id_ucznia_2;
        
        v_sr1 := pkg_uczen.srednia_ocen(p_id_ucznia_1);
        v_sr2 := pkg_uczen.srednia_ocen(p_id_ucznia_2);
        
        DBMS_OUTPUT.PUT_LINE('=== POROWNANIE UCZNIOW ===');
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE(RPAD('Kryterium', 20) || RPAD(v_uczen1.nazwisko, 15) || 
                             RPAD(v_uczen2.nazwisko, 15));
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 50, '-'));
        DBMS_OUTPUT.PUT_LINE(RPAD('Wiek', 20) || RPAD(v_uczen1.wiek(), 15) || 
                             RPAD(v_uczen2.wiek(), 15));
        DBMS_OUTPUT.PUT_LINE(RPAD('Srednia ocen', 20) || RPAD(v_sr1, 15) || 
                             RPAD(v_sr2, 15));
        
        -- Kto lepszy?
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
-- PODSUMOWANIE PAKIETOW
-- ============================================================================
/*
Utworzono 3 pakiety:

1. PKG_UCZEN (5 procedur/funkcji):
   - dodaj_ucznia()      - z walidacja wieku
   - liczba_uczniow()    - funkcja agregujaca
   - uczniowie_wiek()    - REF CURSOR
   - lista_uczniow()     - kursor jawny
   - srednia_ocen()      - DEREF w zapytaniu

2. PKG_LEKCJA (6 procedur/funkcji):
   - zaplanuj_lekcje()   - z walidacja konfliktow
   - oznacz_odbyta()     - aktualizacja statusu
   - odwolaj_lekcje()    - aktualizacja statusu
   - lekcje_ucznia()     - REF CURSOR
   - lekcje_tygodniowo() - funkcja agregujaca
   - raport_dzienny()    - kursor FOR

3. PKG_OCENA (5 procedur/funkcji):
   - dodaj_ocene()       - z walidacja zakresu
   - ostatnie_oceny()    - REF CURSOR z FETCH FIRST
   - raport_postepu()    - kompleksowy raport
   - srednia_obszar()    - funkcja agregujaca
   - porownaj_uczniow()  - porownanie dwoch uczniow

Razem: 16 procedur/funkcji, 3 REF CURSOR, 2 kursory jawne
*/

PROMPT ========================================
PROMPT Pakiety PL/SQL utworzone pomyslnie!
PROMPT ========================================
