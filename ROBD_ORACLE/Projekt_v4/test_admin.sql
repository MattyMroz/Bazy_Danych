-- ============================================================================
-- TESTY ADMINA
-- Uruchom jako: sqlplus usr_admin/Admin123!
-- ============================================================================
SET SERVEROUTPUT ON SIZE UNLIMITED;
PROMPT === TESTY ADMINA ===

-- SELECT
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

-- INSERT/UPDATE/DELETE
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

BEGIN
    szkola_muzyczna.pkg_ocena.historia_ucznia(1);
    DBMS_OUTPUT.PUT_LINE('[OK] pkg_ocena.historia_ucznia()');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[FAIL] pkg_ocena: ' || SQLERRM);
END;
/

PROMPT === KONIEC TESTOW ADMINA ===
