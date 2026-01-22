-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 08_testy_uprawnien.sql
-- Opis: Testy uprawnien uzytkownikow
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

PROMPT ============================================================
PROMPT TESTY UPRAWNIEN UZYTKOWNIKOW
PROMPT ============================================================

-- ============================================================================
-- SCENARIUSZ 12: Uprawnienia - Administrator (rola_admin)
-- ============================================================================
-- Test uprawnien roli rola_admin:
-- * SELECT na wszystkich tabelach: dozwolone
-- * INSERT/UPDATE/DELETE na wszystkich tabelach: dozwolone
-- * Wykonywanie wszystkich pakietow: dozwolone
-- Uruchom jako: sqlplus usr_admin/Admin123!
-- ============================================================================
PROMPT
PROMPT === SCENARIUSZ 12: TESTY ADMINA (rola_admin) ===
PROMPT

-- SELECT na wszystkich tabelach
DECLARE v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM szkola_muzyczna.t_instrument;
    DBMS_OUTPUT.PUT_LINE('[OK] SELECT t_instrument: ' || v_cnt);
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[FAIL] SELECT t_instrument: ' || SQLERRM);
END;
/

DECLARE v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM szkola_muzyczna.t_uczen;
    DBMS_OUTPUT.PUT_LINE('[OK] SELECT t_uczen: ' || v_cnt);
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[FAIL] SELECT t_uczen: ' || SQLERRM);
END;
/

DECLARE v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM szkola_muzyczna.t_lekcja;
    DBMS_OUTPUT.PUT_LINE('[OK] SELECT t_lekcja: ' || v_cnt);
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[FAIL] SELECT t_lekcja: ' || SQLERRM);
END;
/

DECLARE v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM szkola_muzyczna.t_ocena;
    DBMS_OUTPUT.PUT_LINE('[OK] SELECT t_ocena: ' || v_cnt);
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[FAIL] SELECT t_ocena: ' || SQLERRM);
END;
/

-- INSERT/UPDATE/DELETE na wszystkich tabelach
DECLARE
    v_id NUMBER;
BEGIN
    SELECT szkola_muzyczna.seq_instrument.NEXTVAL INTO v_id FROM DUAL;
    INSERT INTO szkola_muzyczna.t_instrument VALUES (szkola_muzyczna.t_instrument_obj(v_id, 'TestAdmin', 'strunowe'));
    DBMS_OUTPUT.PUT_LINE('[OK] INSERT t_instrument');
    UPDATE szkola_muzyczna.t_instrument SET nazwa = 'TestAdminUpd' WHERE id_instrumentu = v_id;
    DBMS_OUTPUT.PUT_LINE('[OK] UPDATE t_instrument');
    DELETE FROM szkola_muzyczna.t_instrument WHERE id_instrumentu = v_id;
    DBMS_OUTPUT.PUT_LINE('[OK] DELETE t_instrument');
    COMMIT;
EXCEPTION WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('[FAIL] INSERT/UPDATE/DELETE: ' || SQLERRM);
    ROLLBACK;
END;
/

-- Wykonywanie wszystkich pakietow
BEGIN
    szkola_muzyczna.pkg_uczen.lista();
    DBMS_OUTPUT.PUT_LINE('[OK] pkg_uczen.lista()');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[FAIL] pkg_uczen: ' || SQLERRM);
END;
/

BEGIN
    szkola_muzyczna.pkg_lekcja.plan_dnia(SYSDATE);
    DBMS_OUTPUT.PUT_LINE('[OK] pkg_lekcja.plan_dnia()');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[FAIL] pkg_lekcja: ' || SQLERRM);
END;
/

BEGIN
    szkola_muzyczna.pkg_ocena.historia_ucznia(1);
    DBMS_OUTPUT.PUT_LINE('[OK] pkg_ocena.historia_ucznia()');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[FAIL] pkg_ocena: ' || SQLERRM);
END;
/

PROMPT === KONIEC SCENARIUSZA 12 ===

-- ============================================================================
-- SCENARIUSZ 13: Uprawnienia - Sekretariat (rola_sekretariat)
-- ============================================================================
-- Test uprawnien roli rola_sekretariat:
-- * SELECT na wszystkich tabelach: dozwolone
-- * INSERT/UPDATE na t_uczen, t_lekcja: dozwolone
-- * DELETE na t_uczen: zabronione (blad ORA-01031)
-- * INSERT na t_ocena: zabronione (blad ORA-01031)
-- Uruchom jako: sqlplus usr_sekretariat/Sekr123!
-- ============================================================================
PROMPT
PROMPT === SCENARIUSZ 13: TESTY SEKRETARIATU (rola_sekretariat) ===
PROMPT

-- SELECT na wszystkich tabelach (dozwolone)
DECLARE v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM szkola_muzyczna.t_uczen;
    DBMS_OUTPUT.PUT_LINE('[OK] SELECT t_uczen: ' || v_cnt);
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[FAIL] SELECT t_uczen: ' || SQLERRM);
END;
/

DECLARE v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM szkola_muzyczna.t_lekcja;
    DBMS_OUTPUT.PUT_LINE('[OK] SELECT t_lekcja: ' || v_cnt);
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[FAIL] SELECT t_lekcja: ' || SQLERRM);
END;
/

-- INSERT/UPDATE na t_uczen (dozwolone)
DECLARE v_id NUMBER;
BEGIN
    SELECT szkola_muzyczna.seq_uczen.NEXTVAL INTO v_id FROM DUAL;
    INSERT INTO szkola_muzyczna.t_uczen VALUES (szkola_muzyczna.t_uczen_obj(
        v_id, 'TestSekr', 'Testowy', ADD_MONTHS(SYSDATE,-120), 'test@test.pl', SYSDATE));
    DBMS_OUTPUT.PUT_LINE('[OK] INSERT t_uczen');
    UPDATE szkola_muzyczna.t_uczen SET email = 'upd@test.pl' WHERE id_ucznia = v_id;
    DBMS_OUTPUT.PUT_LINE('[OK] UPDATE t_uczen');
    ROLLBACK;
EXCEPTION WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('[FAIL] INSERT/UPDATE t_uczen: ' || SQLERRM);
    ROLLBACK;
END;
/

-- DELETE na t_uczen (ZABRONIONE - oczekiwany blad ORA-01031)
DECLARE
    v_result NUMBER;
BEGIN
    EXECUTE IMMEDIATE 'DELETE FROM szkola_muzyczna.t_uczen WHERE id_ucznia = 999999';
    DBMS_OUTPUT.PUT_LINE('[FAIL] DELETE t_uczen - powinno byc zabronione!');
    ROLLBACK;
EXCEPTION 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('[OK] DELETE t_uczen zabronione: ' || SQLERRM);
END;
/

-- INSERT na t_ocena (ZABRONIONE - oczekiwany blad ORA-01031)
BEGIN
    EXECUTE IMMEDIATE '
        INSERT INTO szkola_muzyczna.t_ocena 
        SELECT szkola_muzyczna.t_ocena_obj(999, SYSDATE, 5, ''technika'', ''Test'', REF(u), REF(n))
        FROM szkola_muzyczna.t_uczen u, szkola_muzyczna.t_nauczyciel n WHERE ROWNUM = 1';
    DBMS_OUTPUT.PUT_LINE('[FAIL] INSERT t_ocena - powinno byc zabronione!');
    ROLLBACK;
EXCEPTION 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('[OK] INSERT t_ocena zabronione: ' || SQLERRM);
END;
/

-- Wykonywanie pakietow
BEGIN
    szkola_muzyczna.pkg_uczen.lista();
    DBMS_OUTPUT.PUT_LINE('[OK] pkg_uczen.lista()');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[FAIL] pkg_uczen: ' || SQLERRM);
END;
/

BEGIN
    szkola_muzyczna.pkg_lekcja.plan_dnia(SYSDATE);
    DBMS_OUTPUT.PUT_LINE('[OK] pkg_lekcja.plan_dnia()');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[FAIL] pkg_lekcja: ' || SQLERRM);
END;
/

PROMPT === KONIEC SCENARIUSZA 13 ===

-- ============================================================================
-- SCENARIUSZ 14: Uprawnienia - Nauczyciel (rola_nauczyciel)
-- ============================================================================
-- Test uprawnien roli rola_nauczyciel:
-- * SELECT na wszystkich tabelach: dozwolone
-- * UPDATE na t_lekcja (zmiana statusu): dozwolone
-- * INSERT na t_ocena: dozwolone
-- * INSERT na t_uczen: zabronione (blad ORA-01031)
-- * DELETE na t_lekcja: zabronione (blad ORA-01031)
-- Uruchom jako: sqlplus usr_nauczyciel/Naucz123!
-- ============================================================================
PROMPT
PROMPT === SCENARIUSZ 14: TESTY NAUCZYCIELA (rola_nauczyciel) ===
PROMPT

-- SELECT na wszystkich tabelach (dozwolone)
DECLARE v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM szkola_muzyczna.t_uczen;
    DBMS_OUTPUT.PUT_LINE('[OK] SELECT t_uczen: ' || v_cnt);
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[FAIL] SELECT t_uczen: ' || SQLERRM);
END;
/

DECLARE v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM szkola_muzyczna.t_lekcja;
    DBMS_OUTPUT.PUT_LINE('[OK] SELECT t_lekcja: ' || v_cnt);
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[FAIL] SELECT t_lekcja: ' || SQLERRM);
END;
/

-- UPDATE na t_lekcja (dozwolone)
BEGIN
    UPDATE szkola_muzyczna.t_lekcja SET status = status WHERE ROWNUM = 1;
    DBMS_OUTPUT.PUT_LINE('[OK] UPDATE t_lekcja');
    ROLLBACK;
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[FAIL] UPDATE t_lekcja: ' || SQLERRM);
END;
/

-- INSERT na t_ocena (dozwolone)
DECLARE v_id NUMBER;
BEGIN
    SELECT szkola_muzyczna.seq_ocena.NEXTVAL INTO v_id FROM DUAL;
    INSERT INTO szkola_muzyczna.t_ocena 
    SELECT szkola_muzyczna.t_ocena_obj(v_id, SYSDATE, 5, 'technika', 'Test', REF(u), REF(n))
    FROM szkola_muzyczna.t_uczen u, szkola_muzyczna.t_nauczyciel n WHERE ROWNUM = 1;
    DBMS_OUTPUT.PUT_LINE('[OK] INSERT t_ocena');
    ROLLBACK;
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[FAIL] INSERT t_ocena: ' || SQLERRM);
END;
/

-- INSERT na t_uczen (ZABRONIONE - oczekiwany blad ORA-01031)
BEGIN
    EXECUTE IMMEDIATE '
        INSERT INTO szkola_muzyczna.t_uczen VALUES (szkola_muzyczna.t_uczen_obj(
            999, ''Test'', ''Test'', SYSDATE, ''test@test.pl'', SYSDATE))';
    DBMS_OUTPUT.PUT_LINE('[FAIL] INSERT t_uczen - powinno byc zabronione!');
    ROLLBACK;
EXCEPTION 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('[OK] INSERT t_uczen zabronione: ' || SQLERRM);
END;
/

-- DELETE na t_lekcja (ZABRONIONE - oczekiwany blad ORA-01031)
BEGIN
    EXECUTE IMMEDIATE 'DELETE FROM szkola_muzyczna.t_lekcja WHERE id_lekcji = 999999';
    DBMS_OUTPUT.PUT_LINE('[FAIL] DELETE t_lekcja - powinno byc zabronione!');
    ROLLBACK;
EXCEPTION 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('[OK] DELETE t_lekcja zabronione: ' || SQLERRM);
END;
/

-- DELETE na t_ocena (ZABRONIONE)
BEGIN
    EXECUTE IMMEDIATE 'DELETE FROM szkola_muzyczna.t_ocena WHERE id_oceny = 999999';
    DBMS_OUTPUT.PUT_LINE('[FAIL] DELETE t_ocena - powinno byc zabronione!');
    ROLLBACK;
EXCEPTION 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('[OK] DELETE t_ocena zabronione: ' || SQLERRM);
END;
/

-- Wykonywanie pakietow
BEGIN
    szkola_muzyczna.pkg_uczen.lista();
    DBMS_OUTPUT.PUT_LINE('[OK] pkg_uczen.lista()');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[FAIL] pkg_uczen: ' || SQLERRM);
END;
/

BEGIN
    szkola_muzyczna.pkg_ocena.historia_ucznia(1);
    DBMS_OUTPUT.PUT_LINE('[OK] pkg_ocena.historia_ucznia()');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[FAIL] pkg_ocena: ' || SQLERRM);
END;
/

PROMPT === KONIEC SCENARIUSZA 14 ===

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================
PROMPT
PROMPT ============================================================
PROMPT PODSUMOWANIE - MACIERZ UPRAWNIEN
PROMPT ============================================================
PROMPT Tabela       | Admin | Sekretariat | Nauczyciel
PROMPT -------------|-------|-------------|------------

PROMPT t_instrument | SIUD  | S           | S
PROMPT t_sala       | SIUD  | S           | S
PROMPT t_nauczyciel | SIUD  | S           | S
PROMPT t_uczen      | SIUD  | SIU         | S
PROMPT t_kurs       | SIUD  | S           | S
PROMPT t_lekcja     | SIUD  | SIU         | SU
PROMPT t_ocena      | SIUD  | S           | SI
PROMPT ============================================================
PROMPT S=SELECT, I=INSERT, U=UPDATE, D=DELETE
PROMPT ============================================================
