CREATE OR REPLACE TRIGGER SPRZEDAZ.TRG_V_ZAMOWIENIA_IO
INSTEAD OF
       INSERT
    OR UPDATE
    OR DELETE
ON SPRZEDAZ.V_ZAMOWIENIA_PELNE
FOR EACH ROW
DECLARE
    v_status_id NUMBER(10);
BEGIN
    IF INSERTING THEN
        DECLARE
            v_data_zlozenia DATE := NVL(:NEW.DATA_ZLOZENIA, SYSDATE);
            v_id_zamowienia NUMBER(10) := :NEW.ID_ZAMOWIENIA;
        BEGIN
            -- Insert id if it's missing
            IF v_id_zamowienia IS NULL THEN
                SELECT SPRZEDAZ.SEQ_ZAMOWIENIE.NEXTVAL INTO v_id_zamowienia FROM DUAL;
            END IF;

            -- If v_data_zlozenia < 2 years then insert into SPRZEDAZ.ZAMOWIENIE
            -- else insert into ARCHIWUM.ZAMOWIENIE_ARCH
            IF v_data_zlozenia >= ADD_MONTHS(SYSDATE, -24) THEN
                SELECT ID_STATUSU INTO v_status_id FROM SPRZEDAZ.STATUS_ZAMOWIENIA WHERE NAZWA = 'NOWE';

                INSERT INTO SPRZEDAZ.ZAMOWIENIE (ID_ZAMOWIENIA, ID_KLIENTA, ID_STATUSU, DATA_ZLOZENIA)
                VALUES (v_id_zamowienia, :NEW.ID_KLIENTA, v_status_id, v_data_zlozenia);
            ELSE
                INSERT INTO ARCHIWUM.ZAMOWIENIE_ARCH@LNK_ARCHIWUM (
                    ID_ZAMOWIENIA, ID_KLIENTA, DATA_ZLOZENIA, DATA_ZARCHIWIZOWANIA, STATUS_KONCOWY
                ) VALUES (
                    v_id_zamowienia, :NEW.ID_KLIENTA, v_data_zlozenia, SYSDATE, 'ZARCHIWIZOWANE'
                );
            END IF;
        END;
    ELSIF UPDATING THEN
        IF :OLD.ZRODLO = 'ARCHIWUM' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Modyfikacja zamówień archiwalnych jest zabroniona.');
        ELSE
            -- Set v_status_id
            -- If status changed then set the v_status_id to the new id
            -- else set the v_status_id to the old id
            IF :NEW.STATUS IS NOT NULL AND :NEW.STATUS != :OLD.STATUS THEN
                SELECT ID_STATUSU INTO v_status_id FROM SPRZEDAZ.STATUS_ZAMOWIENIA WHERE NAZWA = :NEW.STATUS;
            ELSE
                SELECT z.ID_STATUSU INTO v_status_id
                FROM SPRZEDAZ.STATUS_ZAMOWIENIA sz
                JOIN SPRZEDAZ.ZAMOWIENIE z ON sz.ID_STATUSU = z.ID_STATUSU
                WHERE z.ID_ZAMOWIENIA = :OLD.ID_ZAMOWIENIA;
            END IF;

            UPDATE SPRZEDAZ.ZAMOWIENIE
            SET ID_KLIENTA = NVL(:NEW.ID_KLIENTA, :OLD.ID_KLIENTA),
                ID_STATUSU = v_status_id,
                DATA_ZLOZENIA = NVL(:NEW.DATA_ZLOZENIA, :OLD.DATA_ZLOZENIA)
            WHERE ID_ZAMOWIENIA = :OLD.ID_ZAMOWIENIA;
        END IF;
    ELSIF DELETING THEN
        RAISE_APPLICATION_ERROR(-20002, 'Usuwanie zamówień przez widok rozproszony jest całkowicie zabronione.');
    END IF;
END;
/