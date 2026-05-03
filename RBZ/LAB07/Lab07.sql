SELECT * FROM global_name;

SELECT * FROM emp;

SELECT * FROM emp@PD25.IMSI.PL.PL

CREATE ROLE RBD;


SELECT * from user_db_links;

SELECT * from all_db_links;
-- TWORZENIE DATABASE LINK
CREATE DATABASE LINK pdv1
CONNECT TO scott IDENTIFIED BY "12345"
USING '(DESCRIPTION=
  (ADDRESS_LIST=
    (ADDRESS=(PROTOCOL=TCP)(HOST=212.51.216.169)(PORT=1521))
  )
  (CONNECT_DATA=
    (SID=PD25)
  )
)';

-- TEST POŁĄCZENIA
SELECT * FROM emp@pdv1;

-- USUNIĘCIE DATABASE LINK
DROP DATABASE LINK pd;

CREATE PUBLIC DATABASE LINK rpd_sr12_251190
CONNECT TO scott IDENTIFIED BY "12345"
USING '(DESCRIPTION=
  (ADDRESS_LIST=
    (ADDRESS=(PROTOCOL=TCP)(HOST=212.51.216.169)(PORT=1521))
  )
  (CONNECT_DATA=
    (SID=PD25)
  )
)';

SELECT * FROM emp@RPD_SR12_251190;

SELECT * FROM user_db_links;




-- ORA-28000: Konto jest zablokowane
ALTER USER scott ACCOUNT UNLOCK;
ALTER USER test ACCOUNT UNLOCK;
ALTER USER test2 ACCOUNT UNLOCK;

-- ORA-02063: Błąd przy database linku PDV1
-- Sprawdzenie istniejących linków
SELECT * FROM user_db_links;
SELECT * FROM dba_db_links;

-- Usunięcie i ponowne utworzenie linku
DROP DATABASE LINK pdv1;

CREATE DATABASE LINK pdv1
CONNECT TO scott IDENTIFIED BY "12345"
USING '(DESCRIPTION=
  (ADDRESS_LIST=
    (ADDRESS=(PROTOCOL=TCP)(HOST=212.51.216.169)(PORT=1521))
  )
  (CONNECT_DATA=
    (SID=PD25)
  )
)';


CREATE DATABASE LINK kol
CONNECT TO scott IDENTIFIED BY "12345"
USING '(DESCRIPTION=
  (ADDRESS_LIST=
    (ADDRESS=(PROTOCOL=TCP)(HOST=212.51.216.169)(PORT=1521))
  )
  (CONNECT_DATA=
    (SID=PD25)
  )
)';

-- sprawdź swoje linki
SELECT db_link, username, host
FROM user_db_links;

-- usuń stary link, który może mieć złe hasło
DROP DATABASE LINK pdv1;
-- albo:
DROP DATABASE LINK pd;


CREATE DATABASE LINK pdv1
CONNECT TO TEST2 IDENTIFIED BY "12345"
USING '(DESCRIPTION=
  (ADDRESS_LIST=
    (ADDRESS=(PROTOCOL=TCP)(HOST=212.51.216.169)(PORT=1521))
  )
  (CONNECT_DATA=
    (SID=PD25)
  )
)';

SELECT * FROM dual@pdv1.PD25.IMSI.PL.PL;    
SELECT * FROM dept@pdv1;



CREATE viev department(nazwa, serwer) as
selesct dname 'ZDA' Server from dept@DP .IMSI.PL.PL
UNION ALL
SELECT dname 'LOC' from dept;

SELECT * FROM department;
create sequence seqwt12;

-- OPRACOWAĆ TRIGER który dla widoku niemodyfikowalnego o nazwei DEPARTMENT umożliwi wstawianie danych
-- w zależności od drugiej kolumy tego widoku.
-- Jeżeli podam druga kolumne jako LOC to wsawianie odbędzie się do lokalnej tabeli DEPT
-- Jeżeli podam druga kolumne jako ZDA to wstawianie odbędzie się przez database link do koleki na server zdalny


CREATE SEQUENCE seqwt12
START WITH 100
INCREMENT BY 1
NOCACHE
NOCYCLE;


CREATE OR REPLACE TRIGGER trg_department_ins
INSTEAD OF INSERT ON department
FOR EACH ROW
DECLARE
    v_deptno NUMBER;
BEGIN
    v_deptno := seqwt12.NEXTVAL;

    IF UPPER(:NEW.serwer) = 'LOC' THEN
        INSERT INTO dept (deptno, dname, loc)
        VALUES (v_deptno, :NEW.nazwa, 'LOCAL');

    ELSIF UPPER(:NEW.serwer) = 'ZDA' THEN
        INSERT INTO dept@pdv1 (deptno, dname, loc)
        VALUES (v_deptno, :NEW.nazwa, 'REMOTE');

    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Serwer musi mieć wartość LOC albo ZDA');
    END IF;
END;
/



SELECT * FROM department;

INSERT INTO department (nazwa, serwer)
VALUES ('NOWY_LOKALNY', 'LOC');

INSERT INTO department (nazwa, serwer)
VALUES ('NOWY_ZDALNY', 'ZDA');

SELECT * FROM department;
SELECT * FROM dept;
SELECT * FROM dept@pdv1;


