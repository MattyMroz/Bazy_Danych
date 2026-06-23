SET SERVEROUTPUT ON;

DECLARE
    v_order_id NUMBER;
    v_price NUMBER;
    v_cnt NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=====================================================================');
    DBMS_OUTPUT.PUT_LINE(' STARTING BUSINESS SEQUENCE SIMULATION (ORDER LIFECYCLE) ');
    DBMS_OUTPUT.PUT_LINE('=====================================================================');

    -- STEP 1: Client registration of a new order
    DBMS_OUTPUT.PUT_LINE('[EVENT 1] Client ID 1 (Sklep Spozywczy Maja) requests a new order header.');
    SPRZEDAZ.PKG_SPRZEDAZ.sp_zarejestruj_zamowienie(
        p_id_klienta => 1,
        p_id_zamowienia => v_order_id
    );
    DBMS_OUTPUT.PUT_LINE('  --> ORDER CREATED: Generated ID = ' || v_order_id);

    -- Check order state in table
    DECLARE
        v_status VARCHAR2(50);
        v_date DATE;
    BEGIN
        SELECT sz.NAZWA, z.DATA_ZLOZENIA INTO v_status, v_date
        FROM SPRZEDAZ.ZAMOWIENIE z
        JOIN SPRZEDAZ.STATUS_ZAMOWIENIA sz ON z.ID_STATUSU = sz.ID_STATUSU
        WHERE z.ID_ZAMOWIENIA = v_order_id;
        DBMS_OUTPUT.PUT_LINE('  --> DB STATE: Order status is "' || v_status || '", date: ' || TO_CHAR(v_date, 'YYYY-MM-DD HH24:MI:SS'));
    END;
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');

    -- STEP 2: Querying the active product prices
    DBMS_OUTPUT.PUT_LINE('[EVENT 2] Checking active catalog prices for items before adding them.');

    v_price := SPRZEDAZ.PKG_SPRZEDAZ.fn_pobierz_aktualna_cena(1);
    DBMS_OUTPUT.PUT_LINE('  --> Catalog Price for Product ID 1 (Fasola): ' || v_price || ' PLN');

    v_price := SPRZEDAZ.PKG_SPRZEDAZ.fn_pobierz_aktualna_cena(2);
    DBMS_OUTPUT.PUT_LINE('  --> Catalog Price for Product ID 2 (Makaron): ' || v_price || ' PLN');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');

    -- STEP 3: Adding items to the order
    DBMS_OUTPUT.PUT_LINE('[EVENT 3] Client adds items to the order header.');

    -- Add 15 units of Fasola konserwowa (Product 1)
    DBMS_OUTPUT.PUT_LINE('  --> Adding 15 units of Product ID 1...');
    SPRZEDAZ.PKG_SPRZEDAZ.sp_dodaj_pozycje(
        p_id_zamowienia => v_order_id,
        p_id_produktu => 1,
        p_ilosc => 15
    );

    -- Add 30 units of Makaron swiderki (Product 2)
    DBMS_OUTPUT.PUT_LINE('  --> Adding 30 units of Product ID 2...');
    SPRZEDAZ.PKG_SPRZEDAZ.sp_dodaj_pozycje(
        p_id_zamowienia => v_order_id,
        p_id_produktu => 2,
        p_ilosc => 30
    );

    -- View the order details
    DBMS_OUTPUT.PUT_LINE('  --> DB STATE: Order items for Order ID ' || v_order_id || ':');
    FOR r IN (
        SELECT pz.ID_POZYCJI, pc.NAZWA, pz.ILOSC, pz.CENA_NETTO_ZAMROZONA, pz.STAWKA_VAT_ZAMROZONA, pz.KWOTA_BRUTTO
        FROM SPRZEDAZ.POZYCJA_ZAMOWIENIA pz
        JOIN SPRZEDAZ.PRODUKT_CACHE pc ON pz.ID_PRODUKTU = pc.ID_PRODUKTU
        WHERE pz.ID_ZAMOWIENIA = v_order_id
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('      * Item ' || r.ID_POZYCJI || ': ' || r.NAZWA || ' - Qty: ' || r.ILOSC || ' - Net Price: ' || r.CENA_NETTO_ZAMROZONA || ' (VAT: ' || r.STAWKA_VAT_ZAMROZONA || '%) - Gross: ' || r.KWOTA_BRUTTO || ' PLN');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');

    -- STEP 4: Reporting top sales
    DBMS_OUTPUT.PUT_LINE('[EVENT 4] Sales manager executes the sales performance report.');
    SPRZEDAZ.PKG_SPRZEDAZ.sp_raport_top_klienci(p_limit => 3);
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');

    -- STEP 5: Cancelling the order
    DBMS_OUTPUT.PUT_LINE('[EVENT 5] Customer decides to cancel the transaction.');
    SPRZEDAZ.PKG_SPRZEDAZ.sp_anuluj_zamowienie(p_id_zamowienia => v_order_id);
    DBMS_OUTPUT.PUT_LINE('  --> ORDER CANCELLED');

    -- Verify status is updated to 'ANULOWANE'
    DECLARE
        v_status VARCHAR2(50);
    BEGIN
        SELECT sz.NAZWA INTO v_status
        FROM SPRZEDAZ.ZAMOWIENIE z
        JOIN SPRZEDAZ.STATUS_ZAMOWIENIA sz ON z.ID_STATUSU = sz.ID_STATUSU
        WHERE z.ID_ZAMOWIENIA = v_order_id;
        DBMS_OUTPUT.PUT_LINE('  --> DB STATE: Final order status is "' || v_status || '"');
    END;

    DBMS_OUTPUT.PUT_LINE('=====================================================================');
    DBMS_OUTPUT.PUT_LINE(' END OF SEQUENCE SIMULATION (ROLLBACK TO MAINTAIN CLEAN STATE) ');
    DBMS_OUTPUT.PUT_LINE('=====================================================================');

    -- Clean up changes using rollback
    ROLLBACK;
END;
/
