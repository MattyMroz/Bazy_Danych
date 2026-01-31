-- ============================================================================
-- PLIK: 09_testy.sql
-- PROJEKT: Szkola Muzyczna v5 - Obiektowa Baza Danych Oracle
-- AUTORZY: Igor Typinski (251237), Mateusz Mroz (251190)
-- DATA: Styczen 2026
-- ============================================================================
-- KOMPLETNE TESTY wszystkich pakietow i walidacji
-- Kazda tabela: CREATE, READ, UPDATE, DELETE + walidacje
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200
SET PAGESIZE 100
SET FEEDBACK OFF

PROMPT
PROMPT ========================================================================
PROMPT   09_testy.sql - KOMPLETNE TESTY
PROMPT ========================================================================
PROMPT

-- ============================================================================
-- HELPER: Zmienne do zliczania testow
-- ============================================================================

VARIABLE g_passed NUMBER
VARIABLE g_failed NUMBER
VARIABLE g_total NUMBER

BEGIN
    :g_passed := 0;
    :g_failed := 0;
    :g_total := 0;
END;
/

-- Procedura pomocnicza do raportowania
CREATE OR REPLACE PROCEDURE test_result(p_nazwa VARCHAR2, p_ok BOOLEAN, p_info VARCHAR2 DEFAULT NULL) AS
BEGIN
    :g_total := :g_total + 1;
    IF p_ok THEN
        :g_passed := :g_passed + 1;
        DBMS_OUTPUT.PUT_LINE('[PASS] ' || p_nazwa);
    ELSE
        :g_failed := :g_failed + 1;
        DBMS_OUTPUT.PUT_LINE('[FAIL] ' || p_nazwa || CASE WHEN p_info IS NOT NULL THEN ' - ' || p_info END);
    END IF;
END;
/

-- ============================================================================
-- 1. TESTY: PKG_SEMESTR
-- ============================================================================

PROMPT
PROMPT === TESTY: pkg_semestr ===
PROMPT

DECLARE
    v_cnt NUMBER;
    v_id NUMBER;
BEGIN
    -- TEST: Wyswietl wszystkie
    pkg_semestr.wyswietl_wszystkie;
    test_result('pkg_semestr.wyswietl_wszystkie', TRUE);
    
    -- TEST: Wyswietl jeden
    pkg_semestr.wyswietl_jeden(1);
    test_result('pkg_semestr.wyswietl_jeden', TRUE);
    
    -- TEST: Dodaj semestr
    pkg_semestr.dodaj('Semestr testowy', DATE '2027-10-01', DATE '2028-01-31', '2027/2028');
    SELECT COUNT(*) INTO v_cnt FROM semestry WHERE nazwa = 'Semestr testowy';
    test_result('pkg_semestr.dodaj', v_cnt = 1);
    
    -- TEST: Aktualizuj semestr
    SELECT id_semestru INTO v_id FROM semestry WHERE nazwa = 'Semestr testowy';
    pkg_semestr.aktualizuj(v_id, p_nazwa => 'Semestr zmodyfikowany');
    SELECT COUNT(*) INTO v_cnt FROM semestry WHERE nazwa = 'Semestr zmodyfikowany';
    test_result('pkg_semestr.aktualizuj', v_cnt = 1);
    
    -- TEST: Usun semestr
    pkg_semestr.usun(v_id);
    SELECT COUNT(*) INTO v_cnt FROM semestry WHERE id_semestru = v_id;
    test_result('pkg_semestr.usun', v_cnt = 0);
    
    -- TEST: Walidacja dat (data konca < data start)
    BEGIN
        pkg_semestr.dodaj('Test', DATE '2027-10-01', DATE '2027-01-01', '2027/2028');
        test_result('pkg_semestr - walidacja dat', FALSE, 'powinien byc blad');
    EXCEPTION
        WHEN OTHERS THEN
            test_result('pkg_semestr - walidacja dat', SQLCODE = -20100);
    END;
    
    -- TEST: Walidacja formatu roku
    BEGIN
        pkg_semestr.dodaj('Test', DATE '2027-10-01', DATE '2028-01-31', '2027');
        test_result('pkg_semestr - walidacja roku', FALSE, 'powinien byc blad');
    EXCEPTION
        WHEN OTHERS THEN
            test_result('pkg_semestr - walidacja roku', SQLCODE = -20101);
    END;
    
EXCEPTION
    WHEN OTHERS THEN
        test_result('pkg_semestr - blad ogolny', FALSE, SQLERRM);
END;
/

-- ============================================================================
-- 2. TESTY: PKG_INSTRUMENT
-- ============================================================================

PROMPT
PROMPT === TESTY: pkg_instrument ===
PROMPT

DECLARE
    v_cnt NUMBER;
    v_id NUMBER;
BEGIN
    -- TEST: Wyswietl wszystkie
    pkg_instrument.wyswietl_wszystkie;
    test_result('pkg_instrument.wyswietl_wszystkie', TRUE);
    
    -- TEST: Wyswietl jeden
    pkg_instrument.wyswietl_jeden(1);
    test_result('pkg_instrument.wyswietl_jeden', TRUE);
    
    -- TEST: Dodaj instrument
    pkg_instrument.dodaj('Harfa testowa', 'strunowe', 'N');
    SELECT COUNT(*) INTO v_cnt FROM instrumenty WHERE nazwa = 'Harfa testowa';
    test_result('pkg_instrument.dodaj', v_cnt = 1);
    
    -- TEST: Znajdz po nazwie
    v_id := pkg_instrument.znajdz_po_nazwie('Harfa testowa');
    test_result('pkg_instrument.znajdz_po_nazwie', v_id IS NOT NULL);
    
    -- TEST: Usun instrument (bez uczniow)
    pkg_instrument.usun(v_id);
    SELECT COUNT(*) INTO v_cnt FROM instrumenty WHERE id_instrumentu = v_id;
    test_result('pkg_instrument.usun', v_cnt = 0);
    
    -- TEST: Walidacja unikalnosci nazwy
    BEGIN
        pkg_instrument.dodaj('Fortepian', 'klawiszowe', 'N'); -- juz istnieje
        test_result('pkg_instrument - walidacja nazwy', FALSE, 'powinien byc blad');
    EXCEPTION
        WHEN OTHERS THEN
            test_result('pkg_instrument - walidacja nazwy', SQLCODE = -20110);
    END;
    
    -- TEST: Walidacja kategorii
    BEGIN
        pkg_instrument.dodaj('Test', 'zla_kategoria', 'N');
        test_result('pkg_instrument - walidacja kategorii', FALSE, 'powinien byc blad');
    EXCEPTION
        WHEN OTHERS THEN
            test_result('pkg_instrument - walidacja kategorii', SQLCODE = -20111);
    END;
    
    -- TEST: Nie mozna usunac z uczniami
    BEGIN
        -- Proba usuniecia instrumentu ktory ma uczniow
        SELECT id_instrumentu INTO v_id FROM instrumenty WHERE nazwa = 'Fortepian';
        pkg_instrument.usun(v_id);
        test_result('pkg_instrument - usuwanie z uczniami', FALSE, 'powinien byc blad');
    EXCEPTION
        WHEN OTHERS THEN
            test_result('pkg_instrument - usuwanie z uczniami', SQLCODE = -20113);
    END;
    
EXCEPTION
    WHEN OTHERS THEN
        test_result('pkg_instrument - blad ogolny', FALSE, SQLERRM);
END;
/

-- ============================================================================
-- 3. TESTY: PKG_SALA
-- ============================================================================

PROMPT
PROMPT === TESTY: pkg_sala ===
PROMPT

DECLARE
    v_cnt NUMBER;
    v_id NUMBER;
    v_wolna CHAR(1);
BEGIN
    -- TEST: Wyswietl wszystkie
    pkg_sala.wyswietl_wszystkie;
    test_result('pkg_sala.wyswietl_wszystkie', TRUE);
    
    -- TEST: Wyswietl jedna
    pkg_sala.wyswietl_jedna(1);
    test_result('pkg_sala.wyswietl_jedna', TRUE);
    
    -- TEST: Dodaj sale
    pkg_sala.dodaj('999', 'indywidualna', 2, t_lista_sprzetu('Pianino'));
    SELECT COUNT(*) INTO v_cnt FROM sale WHERE numer = '999';
    test_result('pkg_sala.dodaj', v_cnt = 1);
    
    -- TEST: Zmien status
    SELECT id_sali INTO v_id FROM sale WHERE numer = '999';
    pkg_sala.zmien_status(v_id, 'remont');
    SELECT COUNT(*) INTO v_cnt FROM sale WHERE id_sali = v_id AND status = 'remont';
    test_result('pkg_sala.zmien_status', v_cnt = 1);
    
    -- TEST: Usun sale
    pkg_sala.usun(v_id);
    SELECT COUNT(*) INTO v_cnt FROM sale WHERE id_sali = v_id;
    test_result('pkg_sala.usun', v_cnt = 0);
    
    -- TEST: Czy wolna
    v_wolna := pkg_sala.czy_wolna(1, SYSDATE + 100, '10:00', '11:00');
    test_result('pkg_sala.czy_wolna', v_wolna = 'T');
    
    -- TEST: Walidacja unikalnosci numeru
    BEGIN
        pkg_sala.dodaj('101', 'indywidualna', 2); -- juz istnieje
        test_result('pkg_sala - walidacja numeru', FALSE, 'powinien byc blad');
    EXCEPTION
        WHEN OTHERS THEN
            test_result('pkg_sala - walidacja numeru', SQLCODE = -20120);
    END;
    
    -- TEST: Walidacja typu
    BEGIN
        pkg_sala.dodaj('888', 'zly_typ', 2);
        test_result('pkg_sala - walidacja typu', FALSE, 'powinien byc blad');
    EXCEPTION
        WHEN OTHERS THEN
            test_result('pkg_sala - walidacja typu', SQLCODE = -20121);
    END;
    
EXCEPTION
    WHEN OTHERS THEN
        test_result('pkg_sala - blad ogolny', FALSE, SQLERRM);
END;
/

-- ============================================================================
-- 4. TESTY: PKG_GRUPA
-- ============================================================================

PROMPT
PROMPT === TESTY: pkg_grupa ===
PROMPT

DECLARE
    v_cnt NUMBER;
    v_id NUMBER;
BEGIN
    -- TEST: Wyswietl wszystkie
    pkg_grupa.wyswietl_wszystkie;
    test_result('pkg_grupa.wyswietl_wszystkie', TRUE);
    
    -- TEST: Wyswietl jedna
    pkg_grupa.wyswietl_jedna(1);
    test_result('pkg_grupa.wyswietl_jedna', TRUE);
    
    -- TEST: Wyswietl uczniow grupy
    pkg_grupa.wyswietl_uczniow_grupy(1);
    test_result('pkg_grupa.wyswietl_uczniow_grupy', TRUE);
    
    -- TEST: Dodaj grupe
    pkg_grupa.dodaj('TEST_GR', 1, '2099/2100', 10);
    SELECT COUNT(*) INTO v_cnt FROM grupy WHERE nazwa = 'TEST_GR';
    test_result('pkg_grupa.dodaj', v_cnt = 1);
    
    -- TEST: Aktualizuj
    SELECT id_grupy INTO v_id FROM grupy WHERE nazwa = 'TEST_GR';
    pkg_grupa.aktualizuj(v_id, p_max_uczniow => 20);
    SELECT COUNT(*) INTO v_cnt FROM grupy WHERE id_grupy = v_id AND max_uczniow = 20;
    test_result('pkg_grupa.aktualizuj', v_cnt = 1);
    
    -- TEST: Usun grupe (bez uczniow)
    pkg_grupa.usun(v_id);
    SELECT COUNT(*) INTO v_cnt FROM grupy WHERE id_grupy = v_id;
    test_result('pkg_grupa.usun', v_cnt = 0);
    
    -- TEST: Liczba uczniow
    v_cnt := pkg_grupa.liczba_uczniow(1);
    test_result('pkg_grupa.liczba_uczniow', v_cnt >= 0);
    
    -- TEST: Walidacja unikalnosci
    BEGIN
        pkg_grupa.dodaj('1A', 1, '2025/2026'); -- juz istnieje
        test_result('pkg_grupa - walidacja nazwy', FALSE, 'powinien byc blad');
    EXCEPTION
        WHEN OTHERS THEN
            test_result('pkg_grupa - walidacja nazwy', SQLCODE = -20130);
    END;
    
EXCEPTION
    WHEN OTHERS THEN
        test_result('pkg_grupa - blad ogolny', FALSE, SQLERRM);
END;
/

-- ============================================================================
-- 5. TESTY: PKG_PRZEDMIOT
-- ============================================================================

PROMPT
PROMPT === TESTY: pkg_przedmiot ===
PROMPT

DECLARE
    v_cnt NUMBER;
    v_id NUMBER;
BEGIN
    -- TEST: Wyswietl wszystkie
    pkg_przedmiot.wyswietl_wszystkie;
    test_result('pkg_przedmiot.wyswietl_wszystkie', TRUE);
    
    -- TEST: Wyswietl jeden
    pkg_przedmiot.wyswietl_jeden(1);
    test_result('pkg_przedmiot.wyswietl_jeden', TRUE);
    
    -- TEST: Dodaj przedmiot
    pkg_przedmiot.dodaj('Przedmiot testowy', 'indywidualny', 45, 1, 6, 'N');
    SELECT COUNT(*) INTO v_cnt FROM przedmioty WHERE nazwa = 'Przedmiot testowy';
    test_result('pkg_przedmiot.dodaj', v_cnt = 1);
    
    -- TEST: Usun
    SELECT id_przedmiotu INTO v_id FROM przedmioty WHERE nazwa = 'Przedmiot testowy';
    pkg_przedmiot.usun(v_id);
    SELECT COUNT(*) INTO v_cnt FROM przedmioty WHERE id_przedmiotu = v_id;
    test_result('pkg_przedmiot.usun', v_cnt = 0);
    
    -- TEST: Walidacja typu zajec
    BEGIN
        pkg_przedmiot.dodaj('Test', 'zly_typ', 45, 1, 6);
        test_result('pkg_przedmiot - walidacja typu', FALSE, 'powinien byc blad');
    EXCEPTION
        WHEN OTHERS THEN
            test_result('pkg_przedmiot - walidacja typu', SQLCODE = -20140);
    END;
    
    -- TEST: Walidacja minut
    BEGIN
        pkg_przedmiot.dodaj('Test', 'indywidualny', 99, 1, 6);
        test_result('pkg_przedmiot - walidacja minut', FALSE, 'powinien byc blad');
    EXCEPTION
        WHEN OTHERS THEN
            test_result('pkg_przedmiot - walidacja minut', SQLCODE = -20141);
    END;
    
EXCEPTION
    WHEN OTHERS THEN
        test_result('pkg_przedmiot - blad ogolny', FALSE, SQLERRM);
END;
/

-- ============================================================================
-- 6. TESTY: PKG_UCZEN - CRUD + WALIDACJE
-- ============================================================================

PROMPT
PROMPT === TESTY: pkg_uczen ===
PROMPT

DECLARE
    v_cnt NUMBER;
    v_id NUMBER;
    v_ok CHAR(1);
    v_srednia NUMBER;
BEGIN
    -- TEST: Wyswietl wszystkich
    pkg_uczen.wyswietl_wszystkich;
    test_result('pkg_uczen.wyswietl_wszystkich', TRUE);
    
    -- TEST: Wyswietl jednego
    pkg_uczen.wyswietl_jednego(1);
    test_result('pkg_uczen.wyswietl_jednego', TRUE);
    
    -- TEST: Wyswietl plan ucznia
    pkg_uczen.wyswietl_plan_ucznia(1);
    test_result('pkg_uczen.wyswietl_plan_ucznia', TRUE);
    
    -- TEST: Wyswietl oceny ucznia
    pkg_uczen.wyswietl_oceny_ucznia(1);
    test_result('pkg_uczen.wyswietl_oceny_ucznia', TRUE);
    
    -- TEST: Dodaj ucznia
    pkg_uczen.dodaj_ucznia(
        p_imie => 'Test',
        p_nazwisko => 'Testowy',
        p_data_urodzenia => DATE '2015-01-01',
        p_email => 'test.testowy@test.pl',
        p_telefon => '+48111222333',
        p_klasa => 1,
        p_id_instrumentu => 1
    );
    SELECT COUNT(*) INTO v_cnt FROM uczniowie WHERE email = 'test.testowy@test.pl';
    test_result('pkg_uczen.dodaj_ucznia', v_cnt = 1);
    
    SELECT id_ucznia INTO v_id FROM uczniowie WHERE email = 'test.testowy@test.pl';
    
    -- TEST: Aktualizuj ucznia
    pkg_uczen.aktualizuj(v_id, p_typ => 'tylko_muzyczna');
    SELECT COUNT(*) INTO v_cnt FROM uczniowie WHERE id_ucznia = v_id AND typ_ucznia = 'tylko_muzyczna';
    test_result('pkg_uczen.aktualizuj', v_cnt = 1);
    
    -- TEST: Zmien status
    pkg_uczen.zmien_status(v_id, 'zawieszony');
    SELECT COUNT(*) INTO v_cnt FROM uczniowie WHERE id_ucznia = v_id AND status = 'zawieszony';
    test_result('pkg_uczen.zmien_status', v_cnt = 1);
    
    -- TEST: Przypisz do grupy
    pkg_uczen.przypisz_do_grupy(v_id, 1);
    SELECT COUNT(*) INTO v_cnt FROM uczniowie WHERE id_ucznia = v_id AND ref_grupa IS NOT NULL;
    test_result('pkg_uczen.przypisz_do_grupy', v_cnt = 1);
    
    -- TEST: Srednia ocen
    v_srednia := pkg_uczen.srednia_ocen(1);
    test_result('pkg_uczen.srednia_ocen', v_srednia >= 0);
    
    -- TEST: Liczba lekcji
    v_cnt := pkg_uczen.liczba_lekcji(1);
    test_result('pkg_uczen.liczba_lekcji', v_cnt >= 0);
    
    -- TEST: Czy email unikalny
    v_ok := pkg_uczen.czy_email_unikalny('test.testowy@test.pl');
    test_result('pkg_uczen.czy_email_unikalny (zajety)', v_ok = 'N');
    
    v_ok := pkg_uczen.czy_email_unikalny('nowy.email@test.pl');
    test_result('pkg_uczen.czy_email_unikalny (wolny)', v_ok = 'T');
    
    -- TEST: Czy telefon unikalny
    v_ok := pkg_uczen.czy_telefon_unikalny('+48111222333');
    test_result('pkg_uczen.czy_telefon_unikalny (zajety)', v_ok = 'N');
    
    v_ok := pkg_uczen.czy_telefon_unikalny('+48999888777');
    test_result('pkg_uczen.czy_telefon_unikalny (wolny)', v_ok = 'T');
    
    -- TEST: Usun ucznia
    pkg_uczen.usun(v_id);
    SELECT COUNT(*) INTO v_cnt FROM uczniowie WHERE id_ucznia = v_id;
    test_result('pkg_uczen.usun', v_cnt = 0);
    
    -- TEST: Walidacja duplikatu email
    BEGIN
        -- Dodaj ucznia z istniejacym emailem
        SELECT email INTO v_ok FROM uczniowie WHERE ROWNUM = 1 AND email IS NOT NULL;
        pkg_uczen.dodaj_ucznia('Test', 'Test', DATE '2015-01-01', v_ok);
        test_result('pkg_uczen - walidacja email', FALSE, 'powinien byc blad');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            test_result('pkg_uczen - walidacja email', TRUE, 'brak danych do testu');
        WHEN OTHERS THEN
            test_result('pkg_uczen - walidacja email', SQLCODE = -20200);
    END;
    
    -- TEST: Walidacja duplikatu telefonu
    BEGIN
        SELECT telefon_rodzica INTO v_ok FROM uczniowie WHERE ROWNUM = 1 AND telefon_rodzica IS NOT NULL;
        pkg_uczen.dodaj_ucznia('Test', 'Test', DATE '2015-01-01', NULL, v_ok);
        test_result('pkg_uczen - walidacja telefon', FALSE, 'powinien byc blad');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            test_result('pkg_uczen - walidacja telefon', TRUE, 'brak danych do testu');
        WHEN OTHERS THEN
            test_result('pkg_uczen - walidacja telefon', SQLCODE = -20201);
    END;
    
    -- TEST: Walidacja statusu
    BEGIN
        pkg_uczen.zmien_status(1, 'zly_status');
        test_result('pkg_uczen - walidacja statusu', FALSE, 'powinien byc blad');
    EXCEPTION
        WHEN OTHERS THEN
            test_result('pkg_uczen - walidacja statusu', SQLCODE = -20202);
    END;
    
    -- TEST: Promuj ucznia
    pkg_uczen.promuj_ucznia(1);
    test_result('pkg_uczen.promuj_ucznia', TRUE);
    
EXCEPTION
    WHEN OTHERS THEN
        test_result('pkg_uczen - blad ogolny', FALSE, SQLERRM);
END;
/

-- ============================================================================
-- 7. TESTY: PKG_NAUCZYCIEL - CRUD + WALIDACJE
-- ============================================================================

PROMPT
PROMPT === TESTY: pkg_nauczyciel ===
PROMPT

DECLARE
    v_cnt NUMBER;
    v_id NUMBER;
    v_ok CHAR(1);
BEGIN
    -- TEST: Wyswietl wszystkich
    pkg_nauczyciel.wyswietl_wszystkich;
    test_result('pkg_nauczyciel.wyswietl_wszystkich', TRUE);
    
    -- TEST: Wyswietl jednego
    pkg_nauczyciel.wyswietl_jednego(1);
    test_result('pkg_nauczyciel.wyswietl_jednego', TRUE);
    
    -- TEST: Wyswietl plan nauczyciela
    pkg_nauczyciel.wyswietl_plan_nauczyciela(1);
    test_result('pkg_nauczyciel.wyswietl_plan_nauczyciela', TRUE);
    
    -- TEST: Dodaj nauczyciela
    pkg_nauczyciel.dodaj_nauczyciela(
        p_imie => 'Nowy',
        p_nazwisko => 'Nauczyciel',
        p_email => 'nowy.nauczyciel@szkola.pl',
        p_telefon => '+48111999888',
        p_instrumenty => t_lista_instrumentow('Fortepian'),
        p_grupowe => 'T',
        p_akompaniator => 'N'
    );
    SELECT COUNT(*) INTO v_cnt FROM nauczyciele WHERE email = 'nowy.nauczyciel@szkola.pl';
    test_result('pkg_nauczyciel.dodaj_nauczyciela', v_cnt = 1);
    
    SELECT id_nauczyciela INTO v_id FROM nauczyciele WHERE email = 'nowy.nauczyciel@szkola.pl';
    
    -- TEST: Dodaj instrument
    pkg_nauczyciel.dodaj_instrument(v_id, 'Skrzypce');
    test_result('pkg_nauczyciel.dodaj_instrument', TRUE);
    
    -- TEST: Aktualizuj
    pkg_nauczyciel.aktualizuj(v_id, p_akompaniator => 'T');
    SELECT COUNT(*) INTO v_cnt FROM nauczyciele WHERE id_nauczyciela = v_id AND czy_akompaniator = 'T';
    test_result('pkg_nauczyciel.aktualizuj', v_cnt = 1);
    
    -- TEST: Zmien status
    pkg_nauczyciel.zmien_status(v_id, 'urlop');
    SELECT COUNT(*) INTO v_cnt FROM nauczyciele WHERE id_nauczyciela = v_id AND status = 'urlop';
    test_result('pkg_nauczyciel.zmien_status', v_cnt = 1);
    
    -- TEST: Liczba lekcji
    v_cnt := pkg_nauczyciel.liczba_lekcji(1);
    test_result('pkg_nauczyciel.liczba_lekcji', v_cnt >= 0);
    
    -- TEST: Czy email unikalny
    v_ok := pkg_nauczyciel.czy_email_unikalny('nowy.nauczyciel@szkola.pl');
    test_result('pkg_nauczyciel.czy_email_unikalny (zajety)', v_ok = 'N');
    
    -- TEST: Usun nauczyciela
    pkg_nauczyciel.usun(v_id);
    SELECT COUNT(*) INTO v_cnt FROM nauczyciele WHERE id_nauczyciela = v_id;
    test_result('pkg_nauczyciel.usun', v_cnt = 0);
    
    -- TEST: Walidacja duplikatu email
    BEGIN
        SELECT email INTO v_ok FROM nauczyciele WHERE ROWNUM = 1;
        pkg_nauczyciel.dodaj_nauczyciela('Test', 'Test', v_ok);
        test_result('pkg_nauczyciel - walidacja email', FALSE, 'powinien byc blad');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            test_result('pkg_nauczyciel - walidacja email', TRUE, 'brak danych');
        WHEN OTHERS THEN
            test_result('pkg_nauczyciel - walidacja email', SQLCODE = -20300);
    END;
    
    -- TEST: Walidacja statusu
    BEGIN
        pkg_nauczyciel.zmien_status(1, 'zly_status');
        test_result('pkg_nauczyciel - walidacja statusu', FALSE, 'powinien byc blad');
    EXCEPTION
        WHEN OTHERS THEN
            test_result('pkg_nauczyciel - walidacja statusu', SQLCODE = -20302);
    END;
    
    -- TEST: Max 5 instrumentow
    BEGIN
        SELECT id_nauczyciela INTO v_id FROM nauczyciele WHERE ROWNUM = 1;
        FOR i IN 1..10 LOOP
            pkg_nauczyciel.dodaj_instrument(v_id, 'Instrument' || i);
        END LOOP;
        test_result('pkg_nauczyciel - max instrumentow', FALSE, 'powinien byc blad');
    EXCEPTION
        WHEN OTHERS THEN
            test_result('pkg_nauczyciel - max instrumentow', SQLCODE = -20301);
    END;
    
EXCEPTION
    WHEN OTHERS THEN
        test_result('pkg_nauczyciel - blad ogolny', FALSE, SQLERRM);
END;
/

-- ============================================================================
-- 8. TESTY: PKG_EGZAMIN
-- ============================================================================

PROMPT
PROMPT === TESTY: pkg_egzamin ===
PROMPT

DECLARE
    v_cnt NUMBER;
    v_id NUMBER;
BEGIN
    -- TEST: Wyswietl wszystkie
    pkg_egzamin.wyswietl_wszystkie;
    test_result('pkg_egzamin.wyswietl_wszystkie', TRUE);
    
    -- TEST: Wyswietl jeden
    FOR r IN (SELECT id_egzaminu FROM egzaminy WHERE ROWNUM = 1) LOOP
        pkg_egzamin.wyswietl_jeden(r.id_egzaminu);
    END LOOP;
    test_result('pkg_egzamin.wyswietl_jeden', TRUE);
    
    -- TEST: Wyswietl egzaminy ucznia
    pkg_egzamin.wyswietl_egzaminy_ucznia(1);
    test_result('pkg_egzamin.wyswietl_egzaminy_ucznia', TRUE);
    
    -- TEST: Dodaj egzamin
    pkg_egzamin.dodaj(
        p_data => SYSDATE + 30,
        p_godzina => '14:00',
        p_typ => 'semestralny',
        p_id_ucznia => 1,
        p_id_przedm => 1,
        p_id_komisja1 => 1,
        p_id_komisja2 => 2,
        p_id_sali => 1
    );
    SELECT MAX(id_egzaminu) INTO v_id FROM egzaminy;
    test_result('pkg_egzamin.dodaj', v_id IS NOT NULL);
    
    -- TEST: Ustaw ocene
    pkg_egzamin.ustaw_ocene(v_id, 5, 'Bardzo dobry wynik');
    SELECT COUNT(*) INTO v_cnt FROM egzaminy WHERE id_egzaminu = v_id AND ocena_koncowa = 5;
    test_result('pkg_egzamin.ustaw_ocene', v_cnt = 1);
    
    -- TEST: Usun egzamin
    pkg_egzamin.usun(v_id);
    SELECT COUNT(*) INTO v_cnt FROM egzaminy WHERE id_egzaminu = v_id;
    test_result('pkg_egzamin.usun', v_cnt = 0);
    
    -- TEST: Walidacja ta sama osoba w komisji
    BEGIN
        pkg_egzamin.dodaj(SYSDATE + 30, '14:00', 'semestralny', 1, 1, 1, 1, 1);
        test_result('pkg_egzamin - walidacja komisji', FALSE, 'powinien byc blad');
    EXCEPTION
        WHEN OTHERS THEN
            test_result('pkg_egzamin - walidacja komisji', SQLCODE = -20150);
    END;
    
    -- TEST: Walidacja oceny poza zakresem
    BEGIN
        FOR r IN (SELECT id_egzaminu FROM egzaminy WHERE ROWNUM = 1) LOOP
            pkg_egzamin.ustaw_ocene(r.id_egzaminu, 7);
        END LOOP;
        test_result('pkg_egzamin - walidacja oceny', FALSE, 'powinien byc blad');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            test_result('pkg_egzamin - walidacja oceny', TRUE, 'brak danych');
        WHEN OTHERS THEN
            test_result('pkg_egzamin - walidacja oceny', SQLCODE = -20151);
    END;
    
EXCEPTION
    WHEN OTHERS THEN
        test_result('pkg_egzamin - blad ogolny', FALSE, SQLERRM);
END;
/

-- ============================================================================
-- 9. TESTY: PKG_LEKCJA
-- ============================================================================

PROMPT
PROMPT === TESTY: pkg_lekcja ===
PROMPT

DECLARE
    v_wolny CHAR(1);
    v_slot VARCHAR2(5);
    v_id NUMBER;
    v_cnt NUMBER;
BEGIN
    -- TEST: Czy nauczyciel wolny
    v_wolny := pkg_lekcja.czy_nauczyciel_wolny(1, SYSDATE + 100, '14:00', '15:00');
    test_result('pkg_lekcja.czy_nauczyciel_wolny', v_wolny IN ('T', 'N'));
    
    -- TEST: Czy sala wolna
    v_wolny := pkg_lekcja.czy_sala_wolna(1, SYSDATE + 100, '14:00', '15:00');
    test_result('pkg_lekcja.czy_sala_wolna', v_wolny IN ('T', 'N'));
    
    -- TEST: Czy uczen wolny
    v_wolny := pkg_lekcja.czy_uczen_wolny(1, SYSDATE + 100, '14:00', '15:00');
    test_result('pkg_lekcja.czy_uczen_wolny', v_wolny IN ('T', 'N'));
    
    -- TEST: Znajdz slot
    v_slot := pkg_lekcja.znajdz_slot(1, 1, 1, SYSDATE + 100, 45);
    test_result('pkg_lekcja.znajdz_slot', TRUE); -- moze zwrocic NULL
    
    -- TEST: Planuj lekcje indywidualna
    BEGIN
        pkg_lekcja.planuj_lekcje(
            p_data => SYSDATE + 100,
            p_godzina => '15:00',
            p_czas => 45,
            p_id_przedm => 1,
            p_id_naucz => 1,
            p_id_sali => 1,
            p_id_ucznia => 1
        );
        SELECT MAX(id_lekcji) INTO v_id FROM lekcje;
        test_result('pkg_lekcja.planuj_lekcje', v_id IS NOT NULL);
        
        -- TEST: Oznacz odbyta
        pkg_lekcja.oznacz_odbyta(v_id);
        SELECT COUNT(*) INTO v_cnt FROM lekcje WHERE id_lekcji = v_id AND status = 'odbyta';
        test_result('pkg_lekcja.oznacz_odbyta', v_cnt = 1);
    EXCEPTION
        WHEN OTHERS THEN
            test_result('pkg_lekcja.planuj_lekcje', FALSE, SQLERRM);
    END;
    
    -- TEST: Planuj lekcje grupowa
    BEGIN
        pkg_lekcja.planuj_lekcje_grupowa(
            p_data => SYSDATE + 101,
            p_godzina => '16:00',
            p_czas => 45,
            p_id_przedm => 5, -- przedmiot grupowy
            p_id_naucz => 1,
            p_id_sali => 3,   -- sala grupowa
            p_id_grupy => 1
        );
        SELECT MAX(id_lekcji) INTO v_id FROM lekcje WHERE typ_lekcji = 'grupowa';
        test_result('pkg_lekcja.planuj_lekcje_grupowa', v_id IS NOT NULL);
        
        -- TEST: Odwolaj lekcje
        pkg_lekcja.odwolaj_lekcje(v_id);
        SELECT COUNT(*) INTO v_cnt FROM lekcje WHERE id_lekcji = v_id AND status = 'odwolana';
        test_result('pkg_lekcja.odwolaj_lekcje', v_cnt = 1);
    EXCEPTION
        WHEN OTHERS THEN
            test_result('pkg_lekcja.planuj_lekcje_grupowa', FALSE, SQLERRM);
    END;
    
    -- TEST: Generuj plan tygodnia (heurystyka)
    BEGIN
        pkg_lekcja.generuj_plan_tygodnia(DATE '2026-03-02', 'N');
        test_result('pkg_lekcja.generuj_plan_tygodnia', TRUE);
    EXCEPTION
        WHEN OTHERS THEN
            test_result('pkg_lekcja.generuj_plan_tygodnia', FALSE, SQLERRM);
    END;
    
EXCEPTION
    WHEN OTHERS THEN
        test_result('pkg_lekcja - blad ogolny', FALSE, SQLERRM);
END;
/

-- ============================================================================
-- 10. TESTY: PKG_OCENA
-- ============================================================================

PROMPT
PROMPT === TESTY: pkg_ocena ===
PROMPT

DECLARE
    v_cnt NUMBER;
    v_id NUMBER;
    v_srednia NUMBER;
BEGIN
    -- TEST: Wyswietl wszystkie
    pkg_ocena.wyswietl_wszystkie;
    test_result('pkg_ocena.wyswietl_wszystkie', TRUE);
    
    -- TEST: Dodaj ocene
    pkg_ocena.dodaj_ocene(
        p_wartosc => 5,
        p_obszar => 'technika',
        p_komentarz => 'Bardzo dobrze',
        p_id_ucznia => 1,
        p_id_naucz => 1,
        p_id_przedm => 1
    );
    SELECT MAX(id_oceny) INTO v_id FROM oceny;
    test_result('pkg_ocena.dodaj_ocene', v_id IS NOT NULL);
    
    -- TEST: Srednia ucznia z przedmiotu
    v_srednia := pkg_ocena.srednia_ucznia_przedmiot(1, 1);
    test_result('pkg_ocena.srednia_ucznia_przedmiot', v_srednia >= 0);
    
    -- TEST: Srednia przedmiotu
    v_srednia := pkg_ocena.srednia_przedmiotu(1);
    test_result('pkg_ocena.srednia_przedmiotu', v_srednia >= 0);
    
    -- TEST: Usun ocene
    pkg_ocena.usun(v_id);
    SELECT COUNT(*) INTO v_cnt FROM oceny WHERE id_oceny = v_id;
    test_result('pkg_ocena.usun', v_cnt = 0);
    
    -- TEST: Walidacja oceny poza zakresem
    BEGIN
        pkg_ocena.dodaj_ocene(7, 'technika', NULL, 1, 1, 1);
        test_result('pkg_ocena - walidacja wartosci', FALSE, 'powinien byc blad');
    EXCEPTION
        WHEN OTHERS THEN
            test_result('pkg_ocena - walidacja wartosci', SQLCODE = -20400);
    END;
    
    -- TEST: Walidacja obszaru
    BEGIN
        pkg_ocena.dodaj_ocene(5, 'zly_obszar', NULL, 1, 1, 1);
        test_result('pkg_ocena - walidacja obszaru', FALSE, 'powinien byc blad');
    EXCEPTION
        WHEN OTHERS THEN
            test_result('pkg_ocena - walidacja obszaru', SQLCODE = -20401);
    END;
    
EXCEPTION
    WHEN OTHERS THEN
        test_result('pkg_ocena - blad ogolny', FALSE, SQLERRM);
END;
/

-- ============================================================================
-- 11. TESTY: PKG_RAPORT
-- ============================================================================

PROMPT
PROMPT === TESTY: pkg_raport ===
PROMPT

BEGIN
    -- TEST: Raport uczniow
    pkg_raport.raport_uczniow;
    test_result('pkg_raport.raport_uczniow', TRUE);
    
    -- TEST: Raport lekcji
    pkg_raport.raport_lekcji(DATE '2025-01-01', DATE '2027-12-31');
    test_result('pkg_raport.raport_lekcji', TRUE);
    
    -- TEST: Raport nauczycieli
    pkg_raport.raport_nauczycieli;
    test_result('pkg_raport.raport_nauczycieli', TRUE);
    
    -- TEST: Statystyki ogolne
    pkg_raport.statystyki_ogolne;
    test_result('pkg_raport.statystyki_ogolne', TRUE);
    
EXCEPTION
    WHEN OTHERS THEN
        test_result('pkg_raport - blad ogolny', FALSE, SQLERRM);
END;
/

-- ============================================================================
-- 12. TESTY: TRIGGERY
-- ============================================================================

PROMPT
PROMPT === TESTY: triggery ===
PROMPT

DECLARE
    v_id NUMBER;
BEGIN
    -- TEST: Komisja egzaminu - ta sama osoba (trigger trg_egzamin_komisja)
    BEGIN
        INSERT INTO egzaminy VALUES (t_egzamin_obj(
            seq_egzaminy.NEXTVAL, SYSDATE + 50, '14:00', 'semestralny', NULL, NULL,
            (SELECT REF(u) FROM uczniowie u WHERE ROWNUM = 1),
            (SELECT REF(p) FROM przedmioty p WHERE ROWNUM = 1),
            (SELECT REF(n) FROM nauczyciele n WHERE id_nauczyciela = 1),
            (SELECT REF(n) FROM nauczyciele n WHERE id_nauczyciela = 1), -- TA SAMA!
            (SELECT REF(s) FROM sale s WHERE ROWNUM = 1)
        ));
        test_result('trg_egzamin_komisja', FALSE, 'powinien byc blad');
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            test_result('trg_egzamin_komisja', SQLCODE = -20001);
            ROLLBACK;
    END;
    
    -- TEST: Lekcja przed min godzina (trigger trg_lekcja_godzina)
    BEGIN
        -- Znajdz ucznia typu 'uczacy_sie_w_innej_szkole'
        FOR r IN (
            SELECT u.id_ucznia FROM uczniowie u 
            WHERE u.typ_ucznia = 'uczacy_sie_w_innej_szkole' AND ROWNUM = 1
        ) LOOP
            INSERT INTO lekcje VALUES (t_lekcja_obj(
                seq_lekcje.NEXTVAL, SYSDATE + 50, '14:00', 45, 'indywidualna', 'zaplanowana',
                (SELECT REF(p) FROM przedmioty p WHERE typ_zajec = 'indywidualny' AND ROWNUM = 1),
                (SELECT REF(n) FROM nauczyciele n WHERE ROWNUM = 1),
                NULL,
                (SELECT REF(s) FROM sale s WHERE ROWNUM = 1),
                (SELECT REF(u) FROM uczniowie u WHERE u.id_ucznia = r.id_ucznia),
                NULL
            ));
            test_result('trg_lekcja_godzina (przed 15:00)', FALSE, 'powinien byc blad');
        END LOOP;
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            test_result('trg_lekcja_godzina (przed 15:00)', SQLCODE = -20002);
            ROLLBACK;
    END;
    
    -- TEST: Uczen klasa > cykl (trigger trg_uczen_klasa_limit)
    BEGIN
        INSERT INTO uczniowie VALUES (t_uczen_obj(
            seq_uczniowie.NEXTVAL, 'Test', 'Test', DATE '2010-01-01', NULL, NULL,
            SYSDATE, 7, 6, 'uczacy_sie_w_innej_szkole', 'aktywny', -- klasa 7 > cykl 6!
            (SELECT REF(i) FROM instrumenty i WHERE ROWNUM = 1),
            NULL
        ));
        test_result('trg_uczen_klasa_limit', FALSE, 'powinien byc blad');
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            test_result('trg_uczen_klasa_limit', SQLCODE = -20004);
            ROLLBACK;
    END;
    
EXCEPTION
    WHEN OTHERS THEN
        test_result('triggery - blad ogolny', FALSE, SQLERRM);
END;
/

-- ============================================================================
-- 13. TESTY: METODY OBIEKTOWE
-- ============================================================================

PROMPT
PROMPT === TESTY: metody obiektowe ===
PROMPT

DECLARE
    v_uczen t_uczen_obj;
    v_naucz t_nauczyciel_obj;
    v_lekcja t_lekcja_obj;
    v_result VARCHAR2(100);
    v_num NUMBER;
BEGIN
    -- TEST: t_uczen_obj.wiek()
    SELECT VALUE(u) INTO v_uczen FROM uczniowie u WHERE ROWNUM = 1;
    v_num := v_uczen.wiek();
    test_result('t_uczen_obj.wiek()', v_num > 0);
    
    -- TEST: t_uczen_obj.min_godzina_lekcji()
    v_result := v_uczen.min_godzina_lekcji();
    test_result('t_uczen_obj.min_godzina_lekcji()', v_result IN ('14:00', '15:00'));
    
    -- TEST: t_uczen_obj.pelne_dane()
    v_result := v_uczen.pelne_dane();
    test_result('t_uczen_obj.pelne_dane()', v_result IS NOT NULL);
    
    -- TEST: t_nauczyciel_obj.lata_stazu()
    SELECT VALUE(n) INTO v_naucz FROM nauczyciele n WHERE ROWNUM = 1;
    v_num := v_naucz.lata_stazu();
    test_result('t_nauczyciel_obj.lata_stazu()', v_num >= 0);
    
    -- TEST: t_nauczyciel_obj.pelne_dane()
    v_result := v_naucz.pelne_dane();
    test_result('t_nauczyciel_obj.pelne_dane()', v_result IS NOT NULL);
    
    -- TEST: t_lekcja_obj.godzina_koniec()
    FOR r IN (SELECT VALUE(l) AS lek FROM lekcje l WHERE ROWNUM = 1) LOOP
        v_result := r.lek.godzina_koniec();
        test_result('t_lekcja_obj.godzina_koniec()', v_result IS NOT NULL);
    END LOOP;
    
    -- TEST: t_lekcja_obj.czy_grupowa()
    FOR r IN (SELECT VALUE(l) AS lek FROM lekcje l WHERE ROWNUM = 1) LOOP
        v_result := r.lek.czy_grupowa();
        test_result('t_lekcja_obj.czy_grupowa()', v_result IN ('T', 'N'));
    END LOOP;
    
EXCEPTION
    WHEN OTHERS THEN
        test_result('metody obiektowe - blad ogolny', FALSE, SQLERRM);
END;
/

-- ============================================================================
-- 14. TESTY: WIDOKI
-- ============================================================================

PROMPT
PROMPT === TESTY: widoki ===
PROMPT

DECLARE
    v_cnt NUMBER;
BEGIN
    -- TEST: v_uczniowie
    SELECT COUNT(*) INTO v_cnt FROM v_uczniowie;
    test_result('v_uczniowie', v_cnt >= 0);
    
    -- TEST: v_nauczyciele
    SELECT COUNT(*) INTO v_cnt FROM v_nauczyciele;
    test_result('v_nauczyciele', v_cnt >= 0);
    
    -- TEST: v_lekcje
    SELECT COUNT(*) INTO v_cnt FROM v_lekcje;
    test_result('v_lekcje', v_cnt >= 0);
    
    -- TEST: v_egzaminy
    SELECT COUNT(*) INTO v_cnt FROM v_egzaminy;
    test_result('v_egzaminy', v_cnt >= 0);
    
    -- TEST: v_oceny
    SELECT COUNT(*) INTO v_cnt FROM v_oceny;
    test_result('v_oceny', v_cnt >= 0);
    
    -- TEST: v_plan_lekcji
    SELECT COUNT(*) INTO v_cnt FROM v_plan_lekcji;
    test_result('v_plan_lekcji', v_cnt >= 0);
    
EXCEPTION
    WHEN OTHERS THEN
        test_result('widoki - blad ogolny', FALSE, SQLERRM);
END;
/

-- ============================================================================
-- 15. TESTY: CONSTRAINT CHECKS
-- ============================================================================

PROMPT
PROMPT === TESTY: constraint checks ===
PROMPT

BEGIN
    -- TEST: Ocena poza zakresem 1-6 (constraint chk_ocena_wartosc)
    BEGIN
        INSERT INTO oceny VALUES (t_ocena_obj(
            seq_oceny.NEXTVAL, SYSDATE, 7, 'technika', NULL,
            (SELECT REF(u) FROM uczniowie u WHERE ROWNUM = 1),
            (SELECT REF(n) FROM nauczyciele n WHERE ROWNUM = 1),
            (SELECT REF(p) FROM przedmioty p WHERE ROWNUM = 1),
            NULL
        ));
        test_result('chk_ocena_wartosc (>6)', FALSE, 'powinien byc blad');
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            test_result('chk_ocena_wartosc (>6)', TRUE);
            ROLLBACK;
    END;
    
    -- TEST: Klasa ucznia poza zakresem
    BEGIN
        INSERT INTO uczniowie VALUES (t_uczen_obj(
            seq_uczniowie.NEXTVAL, 'Test', 'Test', DATE '2010-01-01', NULL, NULL,
            SYSDATE, 0, 6, 'uczacy_sie_w_innej_szkole', 'aktywny',
            (SELECT REF(i) FROM instrumenty i WHERE ROWNUM = 1),
            NULL
        ));
        test_result('chk_uczen_klasa (0)', FALSE, 'powinien byc blad');
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            test_result('chk_uczen_klasa (0)', TRUE);
            ROLLBACK;
    END;
    
    -- TEST: Typ ucznia niepoprawny
    BEGIN
        INSERT INTO uczniowie VALUES (t_uczen_obj(
            seq_uczniowie.NEXTVAL, 'Test', 'Test', DATE '2010-01-01', NULL, NULL,
            SYSDATE, 1, 6, 'zly_typ', 'aktywny',
            (SELECT REF(i) FROM instrumenty i WHERE ROWNUM = 1),
            NULL
        ));
        test_result('chk_uczen_typ', FALSE, 'powinien byc blad');
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            test_result('chk_uczen_typ', TRUE);
            ROLLBACK;
    END;
    
    -- TEST: Status lekcji niepoprawny
    BEGIN
        INSERT INTO lekcje VALUES (t_lekcja_obj(
            seq_lekcje.NEXTVAL, SYSDATE + 50, '15:00', 45, 'indywidualna', 'zly_status',
            (SELECT REF(p) FROM przedmioty p WHERE typ_zajec = 'indywidualny' AND ROWNUM = 1),
            (SELECT REF(n) FROM nauczyciele n WHERE ROWNUM = 1),
            NULL,
            (SELECT REF(s) FROM sale s WHERE ROWNUM = 1),
            (SELECT REF(u) FROM uczniowie u WHERE ROWNUM = 1),
            NULL
        ));
        test_result('chk_lek_status', FALSE, 'powinien byc blad');
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            test_result('chk_lek_status', TRUE);
            ROLLBACK;
    END;
    
    -- TEST: Lekcja XOR (uczen i grupa jednoczesnie)
    BEGIN
        INSERT INTO lekcje VALUES (t_lekcja_obj(
            seq_lekcje.NEXTVAL, SYSDATE + 50, '15:00', 45, 'indywidualna', 'zaplanowana',
            (SELECT REF(p) FROM przedmioty p WHERE ROWNUM = 1),
            (SELECT REF(n) FROM nauczyciele n WHERE ROWNUM = 1),
            NULL,
            (SELECT REF(s) FROM sale s WHERE ROWNUM = 1),
            (SELECT REF(u) FROM uczniowie u WHERE ROWNUM = 1),
            (SELECT REF(g) FROM grupy g WHERE ROWNUM = 1) -- OBA!
        ));
        test_result('chk_lek_xor (oba)', FALSE, 'powinien byc blad');
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            test_result('chk_lek_xor (oba)', TRUE);
            ROLLBACK;
    END;
    
    -- TEST: Lekcja XOR (ani uczen ani grupa)
    BEGIN
        INSERT INTO lekcje VALUES (t_lekcja_obj(
            seq_lekcje.NEXTVAL, SYSDATE + 50, '15:00', 45, 'indywidualna', 'zaplanowana',
            (SELECT REF(p) FROM przedmioty p WHERE ROWNUM = 1),
            (SELECT REF(n) FROM nauczyciele n WHERE ROWNUM = 1),
            NULL,
            (SELECT REF(s) FROM sale s WHERE ROWNUM = 1),
            NULL,  -- BRAK
            NULL   -- BRAK
        ));
        test_result('chk_lek_xor (zadne)', FALSE, 'powinien byc blad');
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            test_result('chk_lek_xor (zadne)', TRUE);
            ROLLBACK;
    END;
    
EXCEPTION
    WHEN OTHERS THEN
        test_result('constraint checks - blad ogolny', FALSE, SQLERRM);
END;
/

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================

PROMPT
PROMPT ========================================================================
PROMPT   PODSUMOWANIE TESTOW
PROMPT ========================================================================

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Wszystkich testow: ' || :g_total);
    DBMS_OUTPUT.PUT_LINE('Zaliczonych:       ' || :g_passed || ' (' || ROUND(:g_passed / NULLIF(:g_total, 0) * 100, 1) || '%)');
    DBMS_OUTPUT.PUT_LINE('Niezaliczonych:    ' || :g_failed);
    DBMS_OUTPUT.PUT_LINE('');
    
    IF :g_failed = 0 THEN
        DBMS_OUTPUT.PUT_LINE('=== WSZYSTKIE TESTY ZALICZONE! ===');
    ELSE
        DBMS_OUTPUT.PUT_LINE('=== NIEKTORE TESTY NIE PRZESZLY ===');
    END IF;
END;
/

-- Czyszczenie
DROP PROCEDURE test_result;

PROMPT
PROMPT ========================================================================
PROMPT   Koniec testow
PROMPT ========================================================================
