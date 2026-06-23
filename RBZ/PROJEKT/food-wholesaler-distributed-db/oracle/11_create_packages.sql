CREATE OR REPLACE PACKAGE SPRZEDAZ.PKG_SPRZEDAZ AS
    PROCEDURE sp_zarejestruj_zamowienie(
        p_id_klienta IN NUMBER,
        p_id_zamowienia OUT NUMBER
    );

    PROCEDURE sp_dodaj_pozycje(
        p_id_zamowienia IN NUMBER,
        p_id_produktu IN NUMBER,
        p_ilosc IN NUMBER
    );

    PROCEDURE sp_anuluj_zamowienie(
        p_id_zamowienia IN NUMBER
    );

    FUNCTION fn_pobierz_aktualna_cena(
        p_id_produktu IN NUMBER
    ) RETURN NUMBER;

    PROCEDURE sp_raport_top_klienci(
        p_limit IN NUMBER DEFAULT 10
    );

END PKG_SPRZEDAZ;
/
CREATE OR REPLACE PACKAGE BODY SPRZEDAZ.PKG_SPRZEDAZ AS
    PROCEDURE sp_zarejestruj_zamowienie(
        p_id_klienta IN NUMBER,
        p_id_zamowienia OUT NUMBER
    ) AS
        v_status_id NUMBER(10);
        v_cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_cnt FROM SPRZEDAZ.KLIENT WHERE ID_KLIENTA = p_id_klienta;
        IF v_cnt = 0 THEN
            RAISE_APPLICATION_ERROR(-20101, 'Klient o podanym ID nie istnieje.');
        END IF;

        SELECT ID_STATUSU INTO v_status_id FROM SPRZEDAZ.STATUS_ZAMOWIENIA WHERE NAZWA = 'NOWE';

        SELECT SPRZEDAZ.SEQ_ZAMOWIENIE.NEXTVAL INTO p_id_zamowienia FROM DUAL;

        INSERT INTO SPRZEDAZ.ZAMOWIENIE (ID_ZAMOWIENIA, ID_KLIENTA, ID_STATUSU, DATA_ZLOZENIA)
        VALUES (p_id_zamowienia, p_id_klienta, v_status_id, SYSDATE);
    END sp_zarejestruj_zamowienie;

    PROCEDURE sp_dodaj_pozycje(
        p_id_zamowienia IN NUMBER,
        p_id_produktu IN NUMBER,
        p_ilosc IN NUMBER
    ) AS
        v_cena_netto NUMBER(10,2);
        v_stawka_vat NUMBER(5,2);
        v_kwota_brutto NUMBER(12,2);
        v_id_pozycji NUMBER(10);
        v_status_nazwa VARCHAR2(50);
    BEGIN
        -- Validate if SPRZEDAZ.ZAMOWIENIE's ID_STATUSU is 'NOWE'
        -- else throw error
        -- Adding POZYCJA_ZAMOWIENIA is valid only for 'NOWE' SPRZEDAZ.ZAMOWIENIE
        BEGIN
            SELECT sz.NAZWA INTO v_status_nazwa
            FROM SPRZEDAZ.ZAMOWIENIE z
            JOIN SPRZEDAZ.STATUS_ZAMOWIENIA sz ON z.ID_STATUSU = sz.ID_STATUSU
            WHERE z.ID_ZAMOWIENIA = p_id_zamowienia;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20102, 'Zamówienie o podanym ID nie istnieje.');
        END;

        IF v_status_nazwa <> 'NOWE' THEN
            RAISE_APPLICATION_ERROR(-20103, 'Nie można dodawać pozycji do zamówienia o statusie ' || v_status_nazwa || '.');
        END IF;

        -- Get CENA_NETTO, STAWKA_VAT of ID_PRODUKTU
        -- from SPRZEDAZ.PRODUKT_CACHE
        BEGIN
            SELECT CENA_NETTO, STAWKA_VAT INTO v_cena_netto, v_stawka_vat
            FROM SPRZEDAZ.PRODUKT_CACHE
            WHERE ID_PRODUKTU = p_id_produktu;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20104, 'Produkt o podanym ID nie istnieje w cache.');
        END;

        v_kwota_brutto := p_ilosc * v_cena_netto * (1 + v_stawka_vat / 100);

        SELECT SPRZEDAZ.SEQ_POZYCJA_ZAMOWIENIA.NEXTVAL INTO v_id_pozycji FROM DUAL;

        INSERT INTO SPRZEDAZ.POZYCJA_ZAMOWIENIA (
            ID_POZYCJI,
            ID_ZAMOWIENIA,
            ID_PRODUKTU,
            ILOSC,
            CENA_NETTO_ZAMROZONA,
            STAWKA_VAT_ZAMROZONA,
            KWOTA_BRUTTO
        ) VALUES (
            v_id_pozycji,
            p_id_zamowienia,
            p_id_produktu,
            p_ilosc,
            v_cena_netto,
            v_stawka_vat,
            v_kwota_brutto
        );
    END sp_dodaj_pozycje;

    PROCEDURE sp_anuluj_zamowienie(
        p_id_zamowienia IN NUMBER
    ) AS
        v_status_nazwa VARCHAR2(50);
        v_anulowane_id NUMBER(10);
    BEGIN
        -- Validate if given SPRZEDAZ.ZAMOWIENIE exists
        BEGIN
            SELECT sz.NAZWA INTO v_status_nazwa
            FROM SPRZEDAZ.ZAMOWIENIE z
            JOIN SPRZEDAZ.STATUS_ZAMOWIENIA sz ON z.ID_STATUSU = sz.ID_STATUSU
            WHERE z.ID_ZAMOWIENIA = p_id_zamowienia;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20105, 'Zamówienie o podanym ID nie istnieje.');
        END;

        -- Validate ID_STATUSU is 'NOWE' or 'ZATWIERDZONE'
        IF v_status_nazwa = 'ZREALIZOWANE' THEN
            RAISE_APPLICATION_ERROR(-20106, 'Nie można anulować zamówienia, które zostało już zrealizowane.');
        ELSIF v_status_nazwa = 'ANULOWANE' THEN
            RAISE_APPLICATION_ERROR(-20107, 'Zamówienie jest już anulowane.');
        END IF;

        SELECT ID_STATUSU INTO v_anulowane_id FROM SPRZEDAZ.STATUS_ZAMOWIENIA WHERE NAZWA = 'ANULOWANE';

        UPDATE SPRZEDAZ.ZAMOWIENIE
            SET ID_STATUSU = v_anulowane_id
            WHERE ID_ZAMOWIENIA = p_id_zamowienia;
    END sp_anuluj_zamowienie;

    FUNCTION fn_pobierz_aktualna_cena( -- NETTO!
        p_id_produktu IN NUMBER
    ) RETURN NUMBER AS
        v_cena_netto NUMBER(10,2);
    BEGIN
        SELECT CENA_NETTO INTO v_cena_netto
        FROM SPRZEDAZ.PRODUKT_CACHE
        WHERE ID_PRODUKTU = p_id_produktu;

        RETURN v_cena_netto;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END fn_pobierz_aktualna_cena;

    PROCEDURE sp_raport_top_klienci(
        p_limit IN NUMBER DEFAULT 10
    ) AS
        -- Cursor for SPRZEDAZ.KLIENCI
        -- sorted by total sum of their SPRZEDAZ.ZAMOWIENIE BRUTTO
        CURSOR c_top_klienci IS
            SELECT
                k.NAZWA AS KLIENT_NAZWA,
                SUM(pz.KWOTA_BRUTTO) AS RAZEM_BRUTTO
            FROM SPRZEDAZ.KLIENT k
            JOIN SPRZEDAZ.ZAMOWIENIE z ON k.ID_KLIENTA = z.ID_KLIENTA
            JOIN SPRZEDAZ.POZYCJA_ZAMOWIENIA pz ON z.ID_ZAMOWIENIA = pz.ID_ZAMOWIENIA
            GROUP BY k.NAZWA
            ORDER BY RAZEM_BRUTTO DESC;

        v_cnt NUMBER := 0;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- RAPORT TOP ' || p_limit || ' KLIENTÓW ---');

        FOR r IN c_top_klienci LOOP
            v_cnt := v_cnt + 1;
            EXIT WHEN v_cnt > p_limit;
            DBMS_OUTPUT.PUT_LINE(v_cnt || '. ' || r.KLIENT_NAZWA || ' - Wartość zamówień: ' || r.RAZEM_BRUTTO || ' PLN');
        END LOOP;

        IF v_cnt = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Brak danych o zamówieniach.');
        END IF;
    END sp_raport_top_klienci;

END PKG_SPRZEDAZ;
/
GRANT EXECUTE ON SPRZEDAZ.PKG_SPRZEDAZ TO rola_sprzedaz;
GRANT EXECUTE ON SPRZEDAZ.PKG_SPRZEDAZ TO SPRZEDAZ_USER;
