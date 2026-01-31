-- ============================================================================
-- PLIK: 09_testy.sql
-- PROJEKT: Szkola Muzyczna v5
-- ============================================================================
-- TESTY: Proste wywolania pakietow - bez zbednych printow
-- Styl: wywolaj -> zobacz wynik -> gotowe
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200
SET PAGESIZE 100

PROMPT
PROMPT ========================================================================
PROMPT   09_testy.sql - TESTY PAKIETOW
PROMPT ========================================================================
PROMPT

-- ============================================================================
-- TESTY PKG_UCZEN
-- ============================================================================

PROMPT
PROMPT === TEST: pkg_uczen ===
PROMPT

-- Dodaj ucznia
BEGIN
    pkg_uczen.dodaj_ucznia(
        p_imie           => 'TestImie',
        p_nazwisko       => 'TestNazwisko',
        p_data_urodzenia => DATE '2012-05-15',
        p_email          => 'test.uczen@email.pl',
        p_klasa          => 1,
        p_typ            => 'tylko_muzyczna',
        p_id_instrumentu => 1
    );
END;
/

-- Sprawdz srednia
SELECT pkg_uczen.srednia_ocen(1) AS srednia_ucznia_1 FROM dual;

-- Sprawdz liczbe lekcji
SELECT pkg_uczen.liczba_lekcji(1) AS lekcje_ucznia_1 FROM dual;

-- Promuj ucznia
BEGIN
    pkg_uczen.promuj_ucznia(1);
END;
/

-- Zmien status
BEGIN
    pkg_uczen.zmien_status(1, 'zawieszony');
    pkg_uczen.zmien_status(1, 'aktywny');
END;
/

-- Przypisz do grupy
BEGIN
    pkg_uczen.przypisz_do_grupy(1, 1);
END;
/

PROMPT [OK] pkg_uczen - testy wykonane

-- ============================================================================
-- TESTY PKG_NAUCZYCIEL
-- ============================================================================

PROMPT
PROMPT === TEST: pkg_nauczyciel ===
PROMPT

-- Dodaj nauczyciela
BEGIN
    pkg_nauczyciel.dodaj_nauczyciela(
        p_imie         => 'TestNauczyciel',
        p_nazwisko     => 'Testowy',
        p_email        => 'test.nauczyciel@szkola.pl',
        p_instrumenty  => t_lista_instrumentow('Fortepian', 'Organy'),
        p_grupowe      => 'T',
        p_akompaniator => 'N'
    );
END;
/

-- Dodaj instrument do nauczyciela
BEGIN
    pkg_nauczyciel.dodaj_instrument(1, 'Klawesyn');
END;
/

-- Sprawdz liczbe lekcji
SELECT pkg_nauczyciel.liczba_lekcji(1) AS lekcje_nauczyciela_1 FROM dual;

-- Zmien status
BEGIN
    pkg_nauczyciel.zmien_status(1, 'urlop');
    pkg_nauczyciel.zmien_status(1, 'aktywny');
END;
/

PROMPT [OK] pkg_nauczyciel - testy wykonane

-- ============================================================================
-- TESTY PKG_LEKCJA
-- ============================================================================

PROMPT
PROMPT === TEST: pkg_lekcja ===
PROMPT

-- Sprawdz czy nauczyciel wolny
SELECT pkg_lekcja.czy_nauczyciel_wolny(1, DATE '2026-03-01', '14:00', '15:00') AS nauczyciel_wolny FROM dual;

-- Sprawdz czy sala wolna
SELECT pkg_lekcja.czy_sala_wolna(1, DATE '2026-03-01', '14:00', '15:00') AS sala_wolna FROM dual;

-- Sprawdz czy uczen wolny
SELECT pkg_lekcja.czy_uczen_wolny(1, DATE '2026-03-01', '14:00', '15:00') AS uczen_wolny FROM dual;

-- Planuj lekcje indywidualna
BEGIN
    pkg_lekcja.planuj_lekcje(
        p_data      => DATE '2026-03-01',
        p_godzina   => '15:00',
        p_czas      => 45,
        p_id_przedm => 1,
        p_id_naucz  => 1,
        p_id_sali   => 1,
        p_id_ucznia => 1
    );
END;
/

-- Planuj lekcje grupowa
BEGIN
    pkg_lekcja.planuj_lekcje_grupowa(
        p_data      => DATE '2026-03-02',
        p_godzina   => '16:00',
        p_czas      => 45,
        p_id_przedm => 5,  -- Ksztalcenie sluchu
        p_id_naucz  => 3,
        p_id_sali   => 3,
        p_id_grupy  => 1
    );
END;
/

-- Oznacz odbyta
BEGIN
    pkg_lekcja.oznacz_odbyta(1);
END;
/

-- Odwolaj
BEGIN
    pkg_lekcja.odwolaj_lekcje(2);
END;
/

-- Znajdz slot
SELECT pkg_lekcja.znajdz_slot(1, 1, 1, DATE '2026-03-03', 45) AS wolny_slot FROM dual;

-- Generuj plan tygodnia (glowny test heurystyki)
BEGIN
    pkg_lekcja.generuj_plan_tygodnia(DATE '2026-02-02', 'N');
END;
/

PROMPT [OK] pkg_lekcja - testy wykonane

-- ============================================================================
-- TESTY PKG_OCENA
-- ============================================================================

PROMPT
PROMPT === TEST: pkg_ocena ===
PROMPT

-- Dodaj ocene
BEGIN
    pkg_ocena.dodaj_ocene(
        p_wartosc   => 5,
        p_obszar    => 'technika',
        p_komentarz => 'Bardzo dobrze',
        p_id_ucznia => 1,
        p_id_naucz  => 1,
        p_id_przedm => 1
    );
END;
/

-- Dodaj kolejna ocene
BEGIN
    pkg_ocena.dodaj_ocene(
        p_wartosc   => 4,
        p_obszar    => 'interpretacja',
        p_komentarz => 'Do poprawy dynamika',
        p_id_ucznia => 1,
        p_id_naucz  => 1,
        p_id_przedm => 1
    );
END;
/

-- Srednia ucznia z przedmiotu
SELECT pkg_ocena.srednia_ucznia_przedmiot(1, 1) AS srednia_uczen_przedm FROM dual;

-- Srednia przedmiotu
SELECT pkg_ocena.srednia_przedmiotu(1) AS srednia_przedmiotu FROM dual;

PROMPT [OK] pkg_ocena - testy wykonane

-- ============================================================================
-- TESTY PKG_RAPORT
-- ============================================================================

PROMPT
PROMPT === TEST: pkg_raport ===
PROMPT

-- Raport uczniow
BEGIN
    pkg_raport.raport_uczniow;
END;
/

-- Raport lekcji
BEGIN
    pkg_raport.raport_lekcji(DATE '2026-01-01', DATE '2026-12-31');
END;
/

-- Raport nauczycieli
BEGIN
    pkg_raport.raport_nauczycieli;
END;
/

-- Statystyki ogolne
BEGIN
    pkg_raport.statystyki_ogolne;
END;
/

PROMPT [OK] pkg_raport - testy wykonane

-- ============================================================================
-- TESTY WALIDACJI (TRIGGERY) - oczekiwane bledy
-- ============================================================================

PROMPT
PROMPT === TEST: walidacje (triggery) ===
PROMPT

-- Test: ta sama osoba w komisji egzaminu (powinien byc blad -20001)
PROMPT Test: ta sama osoba w komisji...
BEGIN
    DECLARE
        v_ref_u REF t_uczen_obj;
        v_ref_p REF t_przedmiot_obj;
        v_ref_n REF t_nauczyciel_obj;
        v_ref_s REF t_sala_obj;
    BEGIN
        SELECT REF(u) INTO v_ref_u FROM uczniowie u WHERE ROWNUM = 1;
        SELECT REF(p) INTO v_ref_p FROM przedmioty p WHERE ROWNUM = 1;
        SELECT REF(n) INTO v_ref_n FROM nauczyciele n WHERE ROWNUM = 1;
        SELECT REF(s) INTO v_ref_s FROM sale s WHERE ROWNUM = 1;
        
        INSERT INTO egzaminy VALUES (t_egzamin_obj(
            seq_egzaminy.NEXTVAL, SYSDATE + 30, '10:00', 'semestralny',
            v_ref_u, v_ref_p, v_ref_n, v_ref_n, v_ref_s, NULL, NULL
        ));
        DBMS_OUTPUT.PUT_LINE('[FAIL] Powinien byc blad komisji');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20001 THEN
                DBMS_OUTPUT.PUT_LINE('[OK] Blad komisji zlapany');
            ELSE
                DBMS_OUTPUT.PUT_LINE('[FAIL] Nieoczekiwany blad: ' || SQLERRM);
            END IF;
    END;
    ROLLBACK;
END;
/

-- Test: lekcja przed 15:00 dla ucznia innej szkoly (powinien byc blad -20002)
PROMPT Test: lekcja przed 15:00 dla ucznia innej szkoly...
BEGIN
    DECLARE
        v_ref_u REF t_uczen_obj;
        v_ref_p REF t_przedmiot_obj;
        v_ref_n REF t_nauczyciel_obj;
        v_ref_s REF t_sala_obj;
    BEGIN
        SELECT REF(u) INTO v_ref_u FROM uczniowie u 
        WHERE typ_ucznia = 'uczacy_sie_w_innej_szkole' AND ROWNUM = 1;
        SELECT REF(p) INTO v_ref_p FROM przedmioty p WHERE typ_zajec = 'indywidualny' AND ROWNUM = 1;
        SELECT REF(n) INTO v_ref_n FROM nauczyciele n WHERE ROWNUM = 1;
        SELECT REF(s) INTO v_ref_s FROM sale s WHERE ROWNUM = 1;
        
        INSERT INTO lekcje VALUES (t_lekcja_obj(
            seq_lekcje.NEXTVAL, SYSDATE + 30, '14:00', 45, 'indywidualna', 'zaplanowana',
            v_ref_p, v_ref_n, NULL, v_ref_s, v_ref_u, NULL
        ));
        DBMS_OUTPUT.PUT_LINE('[FAIL] Powinien byc blad godziny');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20002 THEN
                DBMS_OUTPUT.PUT_LINE('[OK] Blad godziny zlapany');
            ELSE
                DBMS_OUTPUT.PUT_LINE('[FAIL] Nieoczekiwany blad: ' || SQLERRM);
            END IF;
    END;
    ROLLBACK;
END;
/

-- Test: ocena poza zakresem 1-6 (constraint)
PROMPT Test: ocena = 7 (poza zakresem)...
BEGIN
    DECLARE
        v_ref_u REF t_uczen_obj;
        v_ref_n REF t_nauczyciel_obj;
        v_ref_p REF t_przedmiot_obj;
    BEGIN
        SELECT REF(u) INTO v_ref_u FROM uczniowie u WHERE ROWNUM = 1;
        SELECT REF(n) INTO v_ref_n FROM nauczyciele n WHERE ROWNUM = 1;
        SELECT REF(p) INTO v_ref_p FROM przedmioty p WHERE ROWNUM = 1;
        
        INSERT INTO oceny VALUES (t_ocena_obj(
            seq_oceny.NEXTVAL, SYSDATE, 7, 'technika', 'Test',
            v_ref_u, v_ref_n, v_ref_p, NULL
        ));
        DBMS_OUTPUT.PUT_LINE('[FAIL] Powinien byc blad zakresu oceny');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[OK] Blad zakresu oceny zlapany');
    END;
    ROLLBACK;
END;
/

PROMPT [OK] walidacje - testy wykonane

-- ============================================================================
-- TESTY METOD OBIEKTOWYCH
-- ============================================================================

PROMPT
PROMPT === TEST: metody obiektowe ===
PROMPT

-- Test metod t_uczen_obj
DECLARE
    v_uczen t_uczen_obj;
BEGIN
    SELECT VALUE(u) INTO v_uczen FROM uczniowie u WHERE ROWNUM = 1;
    DBMS_OUTPUT.PUT_LINE('wiek(): ' || v_uczen.wiek());
    DBMS_OUTPUT.PUT_LINE('pelne_dane(): ' || v_uczen.pelne_dane());
    DBMS_OUTPUT.PUT_LINE('min_godzina_lekcji(): ' || v_uczen.min_godzina_lekcji());
END;
/

-- Test metod t_nauczyciel_obj
DECLARE
    v_naucz t_nauczyciel_obj;
BEGIN
    SELECT VALUE(n) INTO v_naucz FROM nauczyciele n WHERE ROWNUM = 1;
    DBMS_OUTPUT.PUT_LINE('lata_stazu(): ' || v_naucz.lata_stazu());
    DBMS_OUTPUT.PUT_LINE('pelne_dane(): ' || v_naucz.pelne_dane());
    DBMS_OUTPUT.PUT_LINE('czy_uczy(Fortepian): ' || v_naucz.czy_uczy('Fortepian'));
END;
/

-- Test metod t_lekcja_obj
DECLARE
    v_lekcja t_lekcja_obj;
BEGIN
    SELECT VALUE(l) INTO v_lekcja FROM lekcje l WHERE ROWNUM = 1;
    DBMS_OUTPUT.PUT_LINE('godzina_koniec(): ' || v_lekcja.godzina_koniec());
    DBMS_OUTPUT.PUT_LINE('czas_txt(): ' || v_lekcja.czas_txt());
END;
/

-- Test metod t_sala_obj
DECLARE
    v_sala t_sala_obj;
BEGIN
    SELECT VALUE(s) INTO v_sala FROM sale s WHERE ROWNUM = 1;
    DBMS_OUTPUT.PUT_LINE('opis_pelny(): ' || v_sala.opis_pelny());
    DBMS_OUTPUT.PUT_LINE('czy_ma_sprzet(Fortepian): ' || v_sala.czy_ma_sprzet('Fortepian'));
END;
/

PROMPT [OK] metody obiektowe - testy wykonane

-- ============================================================================
-- TESTY WIDOKOW
-- ============================================================================

PROMPT
PROMPT === TEST: widoki ===
PROMPT

SELECT COUNT(*) AS cnt_v_uczniowie FROM v_uczniowie;
SELECT COUNT(*) AS cnt_v_lekcje FROM v_lekcje;
SELECT COUNT(*) AS cnt_v_plan_lekcji FROM v_plan_lekcji;

PROMPT [OK] widoki - testy wykonane

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================

PROMPT
PROMPT ========================================================================
PROMPT   PODSUMOWANIE STANU BAZY
PROMPT ========================================================================

SELECT 'semestry' AS tabela, COUNT(*) AS ilosc FROM semestry UNION ALL
SELECT 'instrumenty', COUNT(*) FROM instrumenty UNION ALL
SELECT 'sale', COUNT(*) FROM sale UNION ALL
SELECT 'nauczyciele', COUNT(*) FROM nauczyciele UNION ALL
SELECT 'grupy', COUNT(*) FROM grupy UNION ALL
SELECT 'uczniowie', COUNT(*) FROM uczniowie UNION ALL
SELECT 'przedmioty', COUNT(*) FROM przedmioty UNION ALL
SELECT 'lekcje', COUNT(*) FROM lekcje UNION ALL
SELECT 'egzaminy', COUNT(*) FROM egzaminy UNION ALL
SELECT 'oceny', COUNT(*) FROM oceny
ORDER BY 1;

PROMPT
PROMPT ========================================================================
PROMPT   TESTY ZAKONCZONE
PROMPT ========================================================================
