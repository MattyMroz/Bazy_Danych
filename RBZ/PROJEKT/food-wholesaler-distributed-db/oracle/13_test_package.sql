SET SERVEROUTPUT ON;

DECLARE
    v_passed NUMBER := 0;
    v_failed NUMBER := 0;

    -- Helper variables
    v_id_zamowienia NUMBER;
    v_id_zamowienia_arch NUMBER;
    v_cena NUMBER;
    v_cnt NUMBER;

    -- Helper procedure to report test results
    PROCEDURE report_result(p_name IN VARCHAR2, p_ok IN BOOLEAN) IS
    BEGIN
        IF p_ok THEN
            v_passed := v_passed + 1;
            DBMS_OUTPUT.PUT_LINE('[PASSED] ' || p_name);
        ELSE
            v_failed := v_failed + 1;
            DBMS_OUTPUT.PUT_LINE('[FAILED] ' || p_name);
        END IF;
    END;
BEGIN
    DBMS_OUTPUT.PUT_LINE('==================================================');
    DBMS_OUTPUT.PUT_LINE('   TESTING PKG_SPRZEDAZ PACKAGE AND DISTRIBUTED VIEWS  ');
    DBMS_OUTPUT.PUT_LINE('==================================================');

    -- -------------------------------------------------------------------------
    -- TEST 1.1: Register order for an existing client
    -- -------------------------------------------------------------------------
    BEGIN
        SPRZEDAZ.PKG_SPRZEDAZ.sp_zarejestruj_zamowienie(p_id_klienta => 1, p_id_zamowienia => v_id_zamowienia);

        -- Check if order was created and has status 'NOWE'
        SELECT COUNT(*) INTO v_cnt 
        FROM SPRZEDAZ.ZAMOWIENIE z
        JOIN SPRZEDAZ.STATUS_ZAMOWIENIA sz ON z.ID_STATUSU = sz.ID_STATUSU
        WHERE z.ID_ZAMOWIENIA = v_id_zamowienia AND sz.NAZWA = 'NOWE';

        report_result('Register order for an existing client (Maja)', v_cnt = 1 AND v_id_zamowienia IS NOT NULL);
    EXCEPTION
        WHEN OTHERS THEN
            report_result('Register order for an existing client (Error: ' || SQLERRM || ')', FALSE);
    END;

    -- -------------------------------------------------------------------------
    -- TEST 1.2: Register order for a non-existent client (expected error -20101)
    -- -------------------------------------------------------------------------
    BEGIN
        SPRZEDAZ.PKG_SPRZEDAZ.sp_zarejestruj_zamowienie(p_id_klienta => 9999, p_id_zamowienia => v_id_zamowienia_arch);
        report_result('Register order for a non-existent client', FALSE);
    EXCEPTION
        WHEN OTHERS THEN
            report_result('Register order for a non-existent client', SQLCODE = -20101);
    END;

    -- -------------------------------------------------------------------------
    -- TEST 2.1: Add position to an order with status NOWE (freezing price/VAT)
    -- -------------------------------------------------------------------------
    BEGIN
        -- Add 'Makaron swiderki 500g' (ID 2, cache price: 3.10, VAT: 5) with quantity 10
        SPRZEDAZ.PKG_SPRZEDAZ.sp_dodaj_pozycje(p_id_zamowienia => v_id_zamowienia, p_id_produktu => 2, p_ilosc => 10);

        -- Gross amount calculation: 10 * 3.10 * 1.05 = 32.55 PLN
        SELECT COUNT(*) INTO v_cnt
        FROM SPRZEDAZ.POZYCJA_ZAMOWIENIA
        WHERE ID_ZAMOWIENIA = v_id_zamowienia
          AND ID_PRODUKTU = 2
          AND ILOSC = 10
          AND CENA_NETTO_ZAMROZONA = 3.10
          AND STAWKA_VAT_ZAMROZONA = 5
          AND KWOTA_BRUTTO = 32.55;

        report_result('Add position (correct gross calculation and frozen price)', v_cnt = 1);
    EXCEPTION
        WHEN OTHERS THEN
            report_result('Add position to order (Error: ' || SQLERRM || ')', FALSE);
    END;

    -- -------------------------------------------------------------------------
    -- TEST 2.2: Add position for a non-existent product (expected error -20104)
    -- -------------------------------------------------------------------------
    BEGIN
        SPRZEDAZ.PKG_SPRZEDAZ.sp_dodaj_pozycje(p_id_zamowienia => v_id_zamowienia, p_id_produktu => 9999, p_ilosc => 1);
        report_result('Add position - non-existent product', FALSE);
    EXCEPTION
        WHEN OTHERS THEN
            report_result('Add position - non-existent product', SQLCODE = -20104);
    END;

    -- -------------------------------------------------------------------------
    -- TEST 2.3: Add position to a non-existent order (expected error -20102)
    -- -------------------------------------------------------------------------
    BEGIN
        SPRZEDAZ.PKG_SPRZEDAZ.sp_dodaj_pozycje(p_id_zamowienia => 9999, p_id_produktu => 2, p_ilosc => 1);
        report_result('Add position - non-existent order', FALSE);
    EXCEPTION
        WHEN OTHERS THEN
            report_result('Add position - non-existent order', SQLCODE = -20102);
    END;

    -- -------------------------------------------------------------------------
    -- TEST 3.1: Cancel order with status NOWE
    -- -------------------------------------------------------------------------
    BEGIN
        SPRZEDAZ.PKG_SPRZEDAZ.sp_anuluj_zamowienie(p_id_zamowienia => v_id_zamowienia);

        -- Verify status changed to 'ANULOWANE'
        SELECT COUNT(*) INTO v_cnt
        FROM SPRZEDAZ.ZAMOWIENIE z
        JOIN SPRZEDAZ.STATUS_ZAMOWIENIA sz ON z.ID_STATUSU = sz.ID_STATUSU
        WHERE z.ID_ZAMOWIENIA = v_id_zamowienia AND sz.NAZWA = 'ANULOWANE';

        report_result('Cancel order with status NOWE', v_cnt = 1);
    EXCEPTION
        WHEN OTHERS THEN
            report_result('Cancel order (Error: ' || SQLERRM || ')', FALSE);
    END;

    -- -------------------------------------------------------------------------
    -- TEST 3.2: Add position to a cancelled order (expected error -20103)
    -- -------------------------------------------------------------------------
    BEGIN
        SPRZEDAZ.PKG_SPRZEDAZ.sp_dodaj_pozycje(p_id_zamowienia => v_id_zamowienia, p_id_produktu => 2, p_ilosc => 1);
        report_result('Add position to an order with status other than NOWE', FALSE);
    EXCEPTION
        WHEN OTHERS THEN
            report_result('Add position to an order with status other than NOWE', SQLCODE = -20103);
    END;

    -- -------------------------------------------------------------------------
    -- TEST 3.3: Try to cancel a cancelled order again (expected error -20107)
    -- -------------------------------------------------------------------------
    BEGIN
        SPRZEDAZ.PKG_SPRZEDAZ.sp_anuluj_zamowienie(p_id_zamowienia => v_id_zamowienia);
        report_result('Try to cancel order again', FALSE);
    EXCEPTION
        WHEN OTHERS THEN
            report_result('Try to cancel order again', SQLCODE = -20107);
    END;

    -- -------------------------------------------------------------------------
    -- TEST 4.1: Get price for an existing product
    -- -------------------------------------------------------------------------
    BEGIN
        v_cena := SPRZEDAZ.PKG_SPRZEDAZ.fn_pobierz_aktualna_cena(p_id_produktu => 2);
        report_result('Get price for an existing product (Makaron)', v_cena = 3.10);
    EXCEPTION
        WHEN OTHERS THEN
            report_result('Get price for an existing product (Error: ' || SQLERRM || ')', FALSE);
    END;

    -- -------------------------------------------------------------------------
    -- TEST 4.2: Get price for a non-existent product (returns NULL)
    -- -------------------------------------------------------------------------
    BEGIN
        v_cena := SPRZEDAZ.PKG_SPRZEDAZ.fn_pobierz_aktualna_cena(p_id_produktu => 9999);
        report_result('Get price for a non-existent product', v_cena IS NULL);
    EXCEPTION
        WHEN OTHERS THEN
            report_result('Get price for a non-existent product (Error: ' || SQLERRM || ')', FALSE);
    END;

    -- -------------------------------------------------------------------------
    -- TEST 5.1: Generate TOP customers report
    -- -------------------------------------------------------------------------
    BEGIN
        SPRZEDAZ.PKG_SPRZEDAZ.sp_raport_top_klienci(p_limit => 3);
        report_result('TOP customers report', TRUE);
    EXCEPTION
        WHEN OTHERS THEN
            report_result('TOP customers report (Error: ' || SQLERRM || ')', FALSE);
    END;

    -- -------------------------------------------------------------------------
    -- TEST 6.1: Insert new order (< 24 months) through distributed view
    -- -------------------------------------------------------------------------
    BEGIN
        SELECT SPRZEDAZ.SEQ_ZAMOWIENIE.NEXTVAL INTO v_id_zamowienia FROM DUAL;

        INSERT INTO SPRZEDAZ.V_ZAMOWIENIA_PELNE (ID_ZAMOWIENIA, ID_KLIENTA, DATA_ZLOZENIA)
        VALUES (v_id_zamowienia, 1, SYSDATE);

        -- Verify it was inserted in local ZAMOWIENIE table
        SELECT COUNT(*) INTO v_cnt FROM SPRZEDAZ.ZAMOWIENIE WHERE ID_ZAMOWIENIA = v_id_zamowienia;
        report_result('Insert current order through view (goes locally)', v_cnt = 1);
    EXCEPTION
        WHEN OTHERS THEN
            report_result('Insert current order through view (Error: ' || SQLERRM || ')', FALSE);
    END;

    -- -------------------------------------------------------------------------
    -- TEST 6.2: Insert historical order (> 24 months) through view
    -- -------------------------------------------------------------------------
    BEGIN
        SELECT SPRZEDAZ.SEQ_ZAMOWIENIE.NEXTVAL INTO v_id_zamowienia_arch FROM DUAL;

        -- Insert with date from 3 years ago (36 months)
        INSERT INTO SPRZEDAZ.V_ZAMOWIENIA_PELNE (ID_ZAMOWIENIA, ID_KLIENTA, DATA_ZLOZENIA)
        VALUES (v_id_zamowienia_arch, 2, ADD_MONTHS(SYSDATE, -36));

        -- Verify it was inserted in archive table via DB Link
        SELECT COUNT(*) INTO v_cnt 
        FROM ARCHIWUM.ZAMOWIENIE_ARCH@LNK_ARCHIWUM 
        WHERE ID_ZAMOWIENIA = v_id_zamowienia_arch;

        report_result('Insert archived order through view (goes to archive)', v_cnt = 1);
    EXCEPTION
        WHEN OTHERS THEN
            report_result('Insert archived order through view (Error: ' || SQLERRM || ')', FALSE);
    END;

    -- -------------------------------------------------------------------------
    -- TEST 6.3: Try to update an archived order through view (expected error -20001)
    -- -------------------------------------------------------------------------
    BEGIN
        UPDATE SPRZEDAZ.V_ZAMOWIENIA_PELNE
        SET STATUS = 'ANULOWANE'
        WHERE ID_ZAMOWIENIA = v_id_zamowienia_arch;

        report_result('Block update of archived orders through view', FALSE);
    EXCEPTION
        WHEN OTHERS THEN
            report_result('Block update of archived orders through view', SQLCODE = -20001);
    END;

    -- -------------------------------------------------------------------------
    -- TEST 6.4: Try to delete a record through view (expected error -20002)
    -- -------------------------------------------------------------------------
    BEGIN
        DELETE FROM SPRZEDAZ.V_ZAMOWIENIA_PELNE
        WHERE ID_ZAMOWIENIA = v_id_zamowienia;

        report_result('Block delete of orders through view', FALSE);
    EXCEPTION
        WHEN OTHERS THEN
            report_result('Block delete of orders through view', SQLCODE = -20002);
    END;

    -- -------------------------------------------------------------------------
    -- TEST RESULTS SUMMARY
    -- -------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('==================================================');
    DBMS_OUTPUT.PUT_LINE('TEST RESULTS SUMMARY:');
    DBMS_OUTPUT.PUT_LINE('Passed:        ' || v_passed);
    DBMS_OUTPUT.PUT_LINE('Failed:        ' || v_failed);
    DBMS_OUTPUT.PUT_LINE('==================================================');

    -- Clean up changes (rollback transaction)
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Transaction rolled back (ROLLBACK) - database remains clean.');

    IF v_failed > 0 THEN
        RAISE_APPLICATION_ERROR(-20999, 'Tests failed. Number of failures: ' || v_failed);
    END IF;
END;
/
