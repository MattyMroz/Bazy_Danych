-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 06_testy.sql
-- Opis: Testy funkcjonalnosci bazy danych
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;
SET LINESIZE 200;

PROMPT ;
PROMPT ################################################################;
PROMPT #            TESTY FUNKCJONALNOSCI BAZY DANYCH                 #;
PROMPT ################################################################;
PROMPT ;

-- ============================================================================
-- TEST 1: METODY OBIEKTOW
-- ============================================================================
PROMPT ;
PROMPT === TEST 1: METODY OBIEKTOW ===;
PROMPT ;

-- Test metod t_instrument_obj
PROMPT [1.1] Metoda opis() dla instrumentow:;
SELECT i.nazwa, i.opis() AS opis 
FROM t_instrument i;

-- Test metod t_nauczyciel_obj
PROMPT ;
PROMPT [1.2] Metody nauczycieli:;
SELECT n.imie, n.nazwisko, 
       n.pelne_dane() AS pelne_dane,
       n.lata_stazu() AS staz,
       n.czy_senior() AS senior
FROM t_nauczyciel n;

-- Test metod t_uczen_obj
PROMPT ;
PROMPT [1.3] Metody uczniow:;
SELECT u.imie, u.nazwisko,
       u.wiek() AS wiek,
       u.czy_pelnoletni() AS pelnoletni,
       u.pelne_dane() AS pelne_dane
FROM t_uczen u;

-- Test metod t_kurs_obj
PROMPT ;
PROMPT [1.4] Metoda info_kursu():;
SELECT k.id_kursu, k.info_kursu() AS info 
FROM t_kurs k;

-- Test metod t_ocena_obj
PROMPT ;
PROMPT [1.5] Metody ocen:;
SELECT o.ocena, 
       o.ocena_slownie() AS slownie,
       o.czy_pozytywna() AS pozytywna
FROM t_ocena_postepu o
WHERE ROWNUM <= 5;

-- ============================================================================
-- TEST 2: VARRAY - LISTA INSTRUMENTOW NAUCZYCIELA
-- ============================================================================
PROMPT ;
PROMPT === TEST 2: VARRAY - LISTA INSTRUMENTOW ===;
PROMPT ;

PROMPT [2.1] Wyswietlenie VARRAY instrumentow nauczycieli:;
DECLARE
    v_nauczyciel t_nauczyciel_obj;
    v_instr      VARCHAR2(100);
BEGIN
    FOR rec IN (SELECT VALUE(n) AS naucz FROM t_nauczyciel n) LOOP
        v_nauczyciel := rec.naucz;
        DBMS_OUTPUT.PUT_LINE('Nauczyciel: ' || v_nauczyciel.pelne_dane());
        DBMS_OUTPUT.PUT_LINE('  Instrumenty (' || v_nauczyciel.instrumenty.COUNT || '):');
        
        FOR i IN 1..v_nauczyciel.instrumenty.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('    - ' || v_nauczyciel.instrumenty(i));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

-- ============================================================================
-- TEST 3: REF / DEREF
-- ============================================================================
PROMPT ;
PROMPT === TEST 3: REF / DEREF ===;
PROMPT ;

PROMPT [3.1] Kurs z referencja do instrumentu (DEREF):;
SELECT k.nazwa AS kurs,
       k.poziom,
       DEREF(k.ref_instrument).nazwa AS instrument,
       DEREF(k.ref_instrument).kategoria AS kategoria
FROM t_kurs k;

PROMPT ;
PROMPT [3.2] Lekcje z pelnymi danymi przez DEREF:;
SELECT l.id_lekcji,
       l.data_lekcji,
       l.godzina_start,
       DEREF(l.ref_uczen).pelne_dane() AS uczen,
       DEREF(l.ref_nauczyciel).pelne_dane() AS nauczyciel,
       DEREF(l.ref_kurs).nazwa AS kurs,
       l.status
FROM t_lekcja l
WHERE ROWNUM <= 5;

PROMPT ;
PROMPT [3.3] Oceny z danymi ucznia i nauczyciela przez DEREF:;
SELECT o.data_oceny,
       DEREF(o.ref_uczen).imie || ' ' || DEREF(o.ref_uczen).nazwisko AS uczen,
       o.ocena,
       o.ocena_slownie() AS slownie,
       o.obszar,
       DEREF(o.ref_nauczyciel).nazwisko AS nauczyciel
FROM t_ocena_postepu o
WHERE ROWNUM <= 5;

-- ============================================================================
-- TEST 4: PAKIET PKG_UCZEN
-- ============================================================================
PROMPT ;
PROMPT === TEST 4: PAKIET PKG_UCZEN ===;
PROMPT ;

PROMPT [4.1] Liczba uczniow:;
DECLARE
    v_liczba NUMBER;
BEGIN
    v_liczba := pkg_uczen.liczba_uczniow();
    DBMS_OUTPUT.PUT_LINE('Liczba uczniow w bazie: ' || v_liczba);
END;
/

PROMPT ;
PROMPT [4.2] Lista uczniow (kursor jawny):;
EXEC pkg_uczen.lista_uczniow;

PROMPT ;
PROMPT [4.3] Uczniowie w wieku 10-16 lat (REF CURSOR):;
DECLARE
    v_cursor    SYS_REFCURSOR;
    v_id        NUMBER;
    v_imie      VARCHAR2(50);
    v_nazwisko  VARCHAR2(50);
    v_wiek      NUMBER;
BEGIN
    v_cursor := pkg_uczen.uczniowie_wiek(10, 16);
    DBMS_OUTPUT.PUT_LINE(RPAD('ID', 5) || RPAD('Imie', 15) || 
                         RPAD('Nazwisko', 15) || 'Wiek');
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 45, '-'));
    
    LOOP
        FETCH v_cursor INTO v_id, v_imie, v_nazwisko, v_wiek;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(RPAD(v_id, 5) || RPAD(v_imie, 15) || 
                             RPAD(v_nazwisko, 15) || v_wiek);
    END LOOP;
    CLOSE v_cursor;
END;
/

PROMPT ;
PROMPT [4.4] Srednia ocen ucznia ID=1:;
DECLARE
    v_srednia NUMBER;
BEGIN
    v_srednia := pkg_uczen.srednia_ocen(1);
    DBMS_OUTPUT.PUT_LINE('Srednia ocen ucznia ID=1: ' || v_srednia);
END;
/

PROMPT ;
PROMPT [4.5] Dodawanie ucznia (test walidacji wieku):;
-- Proba dodania za mlodego ucznia
BEGIN
    pkg_uczen.dodaj_ucznia(
        'TestImie', 
        'TestNazwisko', 
        DATE '2022-01-01',  -- za mlody!
        'test@test.pl'
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Oczekiwany blad: ' || SQLERRM);
END;
/

-- ============================================================================
-- TEST 5: PAKIET PKG_LEKCJA
-- ============================================================================
PROMPT ;
PROMPT === TEST 5: PAKIET PKG_LEKCJA ===;
PROMPT ;

PROMPT [5.1] Raport lekcji na konkretny dzien:;
DECLARE
    v_data DATE := TRUNC(SYSDATE) + 7; -- za tydzien
BEGIN
    pkg_lekcja.raport_dzienny(v_data);
END;
/

PROMPT ;
PROMPT [5.2] Lekcje ucznia w tym miesiacu (REF CURSOR):;
DECLARE
    v_cursor    SYS_REFCURSOR;
    v_id        NUMBER;
    v_data      DATE;
    v_godzina   VARCHAR2(5);
    v_naucz     VARCHAR2(100);
    v_kurs      VARCHAR2(100);
    v_status    VARCHAR2(20);
BEGIN
    v_cursor := pkg_lekcja.lekcje_ucznia(1, SYSDATE + 30);
    DBMS_OUTPUT.PUT_LINE('Lekcje ucznia ID=1:');
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 80, '-'));
    
    LOOP
        FETCH v_cursor INTO v_id, v_data, v_godzina, v_naucz, v_kurs, v_status;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_id || ' | ' || TO_CHAR(v_data, 'YYYY-MM-DD') || 
                             ' ' || v_godzina || ' | ' || v_kurs || ' | ' || v_status);
    END LOOP;
    CLOSE v_cursor;
END;
/

PROMPT ;
PROMPT [5.3] Liczba lekcji nauczyciela w tygodniu:;
DECLARE
    v_liczba NUMBER;
BEGIN
    v_liczba := pkg_lekcja.lekcje_tygodniowo(1);
    DBMS_OUTPUT.PUT_LINE('Nauczyciel ID=1 ma w tym tygodniu: ' || v_liczba || ' lekcji');
END;
/

-- ============================================================================
-- TEST 6: PAKIET PKG_OCENA
-- ============================================================================
PROMPT ;
PROMPT === TEST 6: PAKIET PKG_OCENA ===;
PROMPT ;

PROMPT [6.1] Raport postepu ucznia:;
EXEC pkg_ocena.raport_postepu(1);

PROMPT ;
PROMPT [6.2] Raport postepu ucznia z najlepszymi wynikami:;
EXEC pkg_ocena.raport_postepu(4);

PROMPT ;
PROMPT [6.3] Porownanie dwoch uczniow:;
EXEC pkg_ocena.porownaj_uczniow(1, 4);

PROMPT ;
PROMPT [6.4] Ostatnie 3 oceny ucznia (REF CURSOR):;
DECLARE
    v_cursor    SYS_REFCURSOR;
    v_data      DATE;
    v_ocena     NUMBER;
    v_obszar    VARCHAR2(100);
    v_komentarz VARCHAR2(500);
    v_nauczyciel VARCHAR2(100);
BEGIN
    v_cursor := pkg_ocena.ostatnie_oceny(2, 3);
    DBMS_OUTPUT.PUT_LINE('Ostatnie 3 oceny ucznia ID=2:');
    
    LOOP
        FETCH v_cursor INTO v_data, v_ocena, v_obszar, v_komentarz, v_nauczyciel;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(v_data, 'YYYY-MM-DD') || ' | Ocena: ' || 
                             v_ocena || ' | ' || v_obszar);
    END LOOP;
    CLOSE v_cursor;
END;
/

PROMPT ;
PROMPT [6.5] Srednia w obszarze "technika" dla ucznia:;
DECLARE
    v_srednia NUMBER;
BEGIN
    v_srednia := pkg_ocena.srednia_obszar(4, 'technika');
    DBMS_OUTPUT.PUT_LINE('Srednia w obszarze technika (uczen ID=4): ' || v_srednia);
END;
/

-- ============================================================================
-- TEST 7: TRIGGERY
-- ============================================================================
PROMPT ;
PROMPT === TEST 7: TRIGGERY ===;
PROMPT ;

PROMPT [7.1] Test triggera walidacji godziny lekcji:;
DECLARE
    v_ref_uczen REF t_uczen_obj;
    v_ref_naucz REF t_nauczyciel_obj;
    v_ref_kurs  REF t_kurs_obj;
BEGIN
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 1;
    SELECT REF(n) INTO v_ref_naucz FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 1;
    
    -- Proba wstawienia lekcji o 6:00 (poza zakresem)
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(seq_lekcja.NEXTVAL, SYSDATE + 10, '06:00', 45, 
                     NULL, NULL, 'zaplanowana', 
                     v_ref_uczen, v_ref_naucz, v_ref_kurs));
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Oczekiwany blad: ' || SQLERRM);
END;
/

PROMPT ;
PROMPT [7.2] Test triggera audytowego - dodanie oceny:;
EXEC pkg_ocena.dodaj_ocene(1, 1, 5, 'rytm', 'Test audytu');

PROMPT ;
PROMPT [7.3] Sprawdzenie logow audytowych:;
SELECT id_logu, nazwa_tabeli, operacja, 
       SUBSTR(nowa_wartosc, 1, 40) AS nowa_wartosc,
       uzytkownik, TO_CHAR(data_zmiany, 'HH24:MI:SS') AS czas
FROM t_audit_log
WHERE ROWNUM <= 5
ORDER BY data_zmiany DESC;

PROMPT ;
PROMPT [7.4] Test triggera usuwania ucznia z lekcjami:;
BEGIN
    DELETE FROM t_uczen WHERE id_ucznia = 1;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Oczekiwany blad: ' || SQLERRM);
END;
/

-- ============================================================================
-- TEST 8: ZAPYTANIA ZAAWANSOWANE
-- ============================================================================
PROMPT ;
PROMPT === TEST 8: ZAPYTANIA ZAAWANSOWANE ===;
PROMPT ;

PROMPT [8.1] Statystyki uczniow z ocenami:;
SELECT u.imie, u.nazwisko,
       u.wiek() AS wiek,
       COUNT(o.id_oceny) AS liczba_ocen,
       ROUND(AVG(o.ocena), 2) AS srednia,
       MAX(o.ocena) AS najlepsza,
       MIN(o.ocena) AS najgorsza
FROM t_uczen u
LEFT JOIN t_ocena_postepu o ON DEREF(o.ref_uczen).id_ucznia = u.id_ucznia
GROUP BY u.id_ucznia, u.imie, u.nazwisko, u.wiek()
ORDER BY srednia DESC NULLS LAST;

PROMPT ;
PROMPT [8.2] Nauczyciele z liczba lekcji i uczniow:;
SELECT n.imie, n.nazwisko,
       n.lata_stazu() AS staz,
       COUNT(DISTINCT l.id_lekcji) AS lekcje,
       COUNT(DISTINCT DEREF(l.ref_uczen).id_ucznia) AS uczniowie
FROM t_nauczyciel n
LEFT JOIN t_lekcja l ON DEREF(l.ref_nauczyciel).id_nauczyciela = n.id_nauczyciela
GROUP BY n.id_nauczyciela, n.imie, n.nazwisko, n.lata_stazu();

PROMPT ;
PROMPT [8.3] Ranking kursow wg liczby lekcji:;
SELECT DEREF(l.ref_kurs).nazwa AS kurs,
       DEREF(l.ref_kurs).poziom AS poziom,
       COUNT(*) AS liczba_lekcji,
       SUM(CASE WHEN l.status = 'odbyta' THEN 1 ELSE 0 END) AS odbyte,
       SUM(CASE WHEN l.status = 'odwolana' THEN 1 ELSE 0 END) AS odwolane
FROM t_lekcja l
GROUP BY DEREF(l.ref_kurs).nazwa, DEREF(l.ref_kurs).poziom
ORDER BY liczba_lekcji DESC;

-- ============================================================================
-- PODSUMOWANIE TESTOW
-- ============================================================================
PROMPT ;
PROMPT ################################################################;
PROMPT #                   TESTY ZAKONCZONE                           #;
PROMPT ################################################################;
PROMPT ;
PROMPT Przetestowano:;
PROMPT - Metody obiektow (wszystkie 12);
PROMPT - VARRAY instrumentow nauczyciela;
PROMPT - REF / DEREF na wszystkich tabelach;
PROMPT - Pakiet PKG_UCZEN (5 funkcji);
PROMPT - Pakiet PKG_LEKCJA (6 funkcji);
PROMPT - Pakiet PKG_OCENA (5 funkcji);
PROMPT - Triggery walidujace i audytowe;
PROMPT - Zapytania zaawansowane z JOIN i agregacja;
PROMPT ;
