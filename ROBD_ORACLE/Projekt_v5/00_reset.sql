-- ============================================================================
-- PLIK: 00_reset.sql
-- PROJEKT: Szkola Muzyczna v5
-- ============================================================================
-- CZYSCI CALA BAZE - uruchom przed ponowna instalacja
-- ============================================================================

SET SERVEROUTPUT ON
SET FEEDBACK OFF

PROMPT
PROMPT ========================================================================
PROMPT   RESET BAZY - usuwanie wszystkich obiektow
PROMPT ========================================================================
PROMPT

-- ============================================================================
-- 1. USUN DANE (kolejnosc wazna - od zaleznych do niezaleznych)
-- ============================================================================

PROMPT [1/4] Usuwanie danych z tabel...

BEGIN
    EXECUTE IMMEDIATE 'DELETE FROM oceny';
    EXECUTE IMMEDIATE 'DELETE FROM egzaminy';
    EXECUTE IMMEDIATE 'DELETE FROM lekcje';
    EXECUTE IMMEDIATE 'DELETE FROM przedmioty';
    EXECUTE IMMEDIATE 'DELETE FROM uczniowie';
    EXECUTE IMMEDIATE 'DELETE FROM grupy';
    EXECUTE IMMEDIATE 'DELETE FROM nauczyciele';
    EXECUTE IMMEDIATE 'DELETE FROM sale';
    EXECUTE IMMEDIATE 'DELETE FROM instrumenty';
    EXECUTE IMMEDIATE 'DELETE FROM semestry';
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Usunieto dane z tabel');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Brak tabel do wyczyszczenia');
END;
/

-- ============================================================================
-- 2. USUN OBIEKTY (kolejnosc: widoki -> pakiety -> triggery -> tabele -> typy)
-- ============================================================================

PROMPT [2/4] Usuwanie obiektow...

-- Widoki
BEGIN
    FOR r IN (SELECT view_name FROM user_views) LOOP
        EXECUTE IMMEDIATE 'DROP VIEW ' || r.view_name || ' CASCADE CONSTRAINTS';
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Usunieto widoki');
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Pakiety
BEGIN
    FOR r IN (SELECT object_name FROM user_objects WHERE object_type = 'PACKAGE') LOOP
        EXECUTE IMMEDIATE 'DROP PACKAGE ' || r.object_name;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Usunieto pakiety');
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Triggery
BEGIN
    FOR r IN (SELECT trigger_name FROM user_triggers) LOOP
        EXECUTE IMMEDIATE 'DROP TRIGGER ' || r.trigger_name;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Usunieto triggery');
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Tabele (obiektowe)
DECLARE
    v_tabele SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST(
        'OCENY', 'EGZAMINY', 'LEKCJE', 'PRZEDMIOTY', 
        'UCZNIOWIE', 'GRUPY', 'NAUCZYCIELE', 'SALE', 
        'INSTRUMENTY', 'SEMESTRY'
    );
BEGIN
    FOR i IN 1..v_tabele.COUNT LOOP
        BEGIN
            EXECUTE IMMEDIATE 'DROP TABLE ' || v_tabele(i) || ' CASCADE CONSTRAINTS';
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Usunieto tabele');
END;
/

-- Sekwencje
DECLARE
    v_sekw SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST(
        'SEQ_SEMESTRY', 'SEQ_INSTRUMENTY', 'SEQ_SALE', 'SEQ_NAUCZYCIELE',
        'SEQ_GRUPY', 'SEQ_UCZNIOWIE', 'SEQ_PRZEDMIOTY', 'SEQ_LEKCJE',
        'SEQ_EGZAMINY', 'SEQ_OCENY'
    );
BEGIN
    FOR i IN 1..v_sekw.COUNT LOOP
        BEGIN
            EXECUTE IMMEDIATE 'DROP SEQUENCE ' || v_sekw(i);
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Usunieto sekwencje');
END;
/

-- Typy (kolejnosc wazna - od zaleznych)
DECLARE
    v_typy SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST(
        'T_OCENA_OBJ', 'T_EGZAMIN_OBJ', 'T_LEKCJA_OBJ', 'T_PRZEDMIOT_OBJ',
        'T_UCZEN_OBJ', 'T_GRUPA_OBJ', 'T_NAUCZYCIEL_OBJ', 'T_SALA_OBJ',
        'T_INSTRUMENT_OBJ', 'T_SEMESTR_OBJ',
        'T_LISTA_INSTRUMENTOW', 'T_LISTA_SPRZETU'
    );
BEGIN
    FOR i IN 1..v_typy.COUNT LOOP
        BEGIN
            EXECUTE IMMEDIATE 'DROP TYPE ' || v_typy(i) || ' FORCE';
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Usunieto typy');
END;
/

-- ============================================================================
-- 3. USUN UZYTKOWNIKOW I ROLE (wymaga DBA)
-- ============================================================================

PROMPT [3/4] Usuwanie uzytkownikow i rol (wymaga DBA)...

BEGIN
    -- Role
    FOR r IN (SELECT role FROM dba_roles WHERE role LIKE 'R_%SZKOLA%' OR role IN ('R_UCZEN', 'R_NAUCZYCIEL', 'R_SEKRETARIAT', 'R_ADMIN')) LOOP
        BEGIN
            EXECUTE IMMEDIATE 'DROP ROLE ' || r.role;
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
    END LOOP;
    
    -- Uzytkownicy
    FOR r IN (SELECT username FROM dba_users WHERE username LIKE 'USR_%') LOOP
        BEGIN
            EXECUTE IMMEDIATE 'DROP USER ' || r.username || ' CASCADE';
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Usunieto uzytkownikow i role');
EXCEPTION 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Pominieto (brak uprawnien DBA)');
END;
/

-- ============================================================================
-- 4. WERYFIKACJA
-- ============================================================================

PROMPT [4/4] Weryfikacja...

DECLARE
    v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt 
    FROM user_objects 
    WHERE object_type IN ('TABLE', 'TYPE', 'PACKAGE', 'TRIGGER', 'VIEW', 'SEQUENCE');
    
    IF v_cnt = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Baza wyczyszczona - 0 obiektow');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Pozostalo obiektow: ' || v_cnt);
    END IF;
END;
/

PROMPT
PROMPT ========================================================================
PROMPT   RESET ZAKONCZONY
PROMPT   Uruchom teraz: @00_instalacja.sql
PROMPT ========================================================================
