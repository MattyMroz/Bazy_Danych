-- ============================================================================
-- TESTY SEKRETARIATU
-- Uruchom jako: sqlplus usr_sekretariat/Sekr123!
-- ============================================================================
SET SERVEROUTPUT ON SIZE UNLIMITED;
PROMPT === TESTY SEKRETARIATU ===

-- SELECT (dozwolone)
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

-- INSERT/UPDATE t_uczen (dozwolone)
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

-- DELETE t_uczen (ZABRONIONE)
DECLARE
    v_result NUMBER;
BEGIN
    EXECUTE IMMEDIATE 'DELETE FROM szkola_muzyczna.t_uczen WHERE id_ucznia = 999999';
    DBMS_OUTPUT.PUT_LINE('[FAIL] DELETE t_uczen - powinno byc zabronione!');
    ROLLBACK;
EXCEPTION 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('[OK] DELETE t_uczen zabronione');
END;
/

-- INSERT t_ocena (ZABRONIONE)
BEGIN
    EXECUTE IMMEDIATE '
        INSERT INTO szkola_muzyczna.t_ocena 
        SELECT szkola_muzyczna.t_ocena_obj(999, SYSDATE, 5, ''technika'', ''Test'', REF(u), REF(n))
        FROM szkola_muzyczna.t_uczen u, szkola_muzyczna.t_nauczyciel n WHERE ROWNUM = 1';
    DBMS_OUTPUT.PUT_LINE('[FAIL] INSERT t_ocena - powinno byc zabronione!');
    ROLLBACK;
EXCEPTION 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('[OK] INSERT t_ocena zabronione');
END;
/

-- Pakiety
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

PROMPT === KONIEC TESTOW SEKRETARIATU ===
