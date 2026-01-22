-- ============================================================================
-- TESTY NAUCZYCIELA
-- Uruchom jako: sqlplus usr_nauczyciel/Naucz123!
-- ============================================================================
SET SERVEROUTPUT ON SIZE UNLIMITED;
PROMPT === TESTY NAUCZYCIELA ===

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

-- UPDATE t_lekcja (dozwolone)
BEGIN
    UPDATE szkola_muzyczna.t_lekcja SET status = status WHERE ROWNUM = 1;
    DBMS_OUTPUT.PUT_LINE('[OK] UPDATE t_lekcja');
    ROLLBACK;
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[FAIL] UPDATE t_lekcja: ' || SQLERRM);
END;
/

-- INSERT t_ocena (dozwolone)
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

-- INSERT t_uczen (ZABRONIONE)
BEGIN
    EXECUTE IMMEDIATE '
        INSERT INTO szkola_muzyczna.t_uczen VALUES (szkola_muzyczna.t_uczen_obj(
            999, ''Test'', ''Test'', SYSDATE, ''test@test.pl'', SYSDATE))';
    DBMS_OUTPUT.PUT_LINE('[FAIL] INSERT t_uczen - powinno byc zabronione!');
    ROLLBACK;
EXCEPTION 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('[OK] INSERT t_uczen zabronione');
END;
/

-- DELETE t_lekcja (ZABRONIONE)
BEGIN
    EXECUTE IMMEDIATE 'DELETE FROM szkola_muzyczna.t_lekcja WHERE id_lekcji = 999999';
    DBMS_OUTPUT.PUT_LINE('[FAIL] DELETE t_lekcja - powinno byc zabronione!');
    ROLLBACK;
EXCEPTION 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('[OK] DELETE t_lekcja zabronione');
END;
/

-- DELETE t_ocena (ZABRONIONE)
BEGIN
    EXECUTE IMMEDIATE 'DELETE FROM szkola_muzyczna.t_ocena WHERE id_oceny = 999999';
    DBMS_OUTPUT.PUT_LINE('[FAIL] DELETE t_ocena - powinno byc zabronione!');
    ROLLBACK;
EXCEPTION 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('[OK] DELETE t_ocena zabronione');
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
    szkola_muzyczna.pkg_ocena.historia_ucznia(1);
    DBMS_OUTPUT.PUT_LINE('[OK] pkg_ocena.historia_ucznia()');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('[FAIL] pkg_ocena: ' || SQLERRM);
END;
/

PROMPT === KONIEC TESTOW NAUCZYCIELA ===
