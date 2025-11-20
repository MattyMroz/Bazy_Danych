ZADANIE: pisz kod PL/SQL w orracle
polskie nazyw zmiennych bez v
nie pisz kometarzy
kod prosty i przejrzysty
kod pisz w znacznikach kodu ``` ```

BAZA SCOTT:

-- USER SQL
CREATE USER SCOTT IDENTIFIED BY 12345 
DEFAULT TABLESPACE "USERS"
TEMPORARY TABLESPACE "TEMP";

-- QUOTAS

-- ROLES
GRANT "CONNECT" TO SCOTT ;
GRANT "RESOURCE" TO SCOTT ;
ALTER USER SCOTT DEFAULT ROLE "CONNECT","RESOURCE";

-- SYSTEM PRIVILEGES
GRANT SELECT ANY DICTIONARY TO SCOTT ;
GRANT UNLIMITED TABLESPACE TO SCOTT ;
/


--------------------------------------------------------

  CREATE TABLE "SCOTT"."EMP" 
   (	"EMPNO" NUMBER(4,0), 
	"ENAME" VARCHAR2(10), 
	"JOB" VARCHAR2(9), 
	"MGR" NUMBER(4,0), 
	"HIREDATE" DATE, 
	"SAL" NUMBER(7,2), 
	"COMM" NUMBER(7,2), 
	"DEPTNO" NUMBER(2,0)
   ) ;
--------------------------------------------------------
--  DDL for Table DEPT
--------------------------------------------------------

  CREATE TABLE "SCOTT"."DEPT" 
   (	"DEPTNO" NUMBER(2,0), 
	"DNAME" VARCHAR2(14), 
	"LOC" VARCHAR2(13)
   ) ;
--------------------------------------------------------
--  DDL for Table BONUS
--------------------------------------------------------

  CREATE TABLE "SCOTT"."BONUS" 
   (	"ENAME" VARCHAR2(10), 
	"JOB" VARCHAR2(9), 
	"SAL" NUMBER, 
	"COMM" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table SALGRADE
--------------------------------------------------------

  CREATE TABLE "SCOTT"."SALGRADE" 
   (	"GRADE" NUMBER, 
	"LOSAL" NUMBER, 
	"HISAL" NUMBER
   ) ;
REM INSERTING into SCOTT.EMP
SET DEFINE OFF;
Insert into SCOTT.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) values ('7369','SMITH','CLERK','7902',to_date('80/12/17','RR/MM/DD'),'800',null,'20');
Insert into SCOTT.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) values ('7499','ALLEN','SALESMAN','7698',to_date('81/02/20','RR/MM/DD'),'1600','300','30');
Insert into SCOTT.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) values ('7521','WARD','SALESMAN','7698',to_date('81/02/22','RR/MM/DD'),'1250','500','30');
Insert into SCOTT.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) values ('7566','JONES','MANAGER','7839',to_date('81/04/02','RR/MM/DD'),'2975',null,'20');
Insert into SCOTT.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) values ('7654','MARTIN','SALESMAN','7698',to_date('81/09/28','RR/MM/DD'),'1250','1400','30');
Insert into SCOTT.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) values ('7698','BLAKE','MANAGER','7839',to_date('81/05/01','RR/MM/DD'),'2850',null,'30');
Insert into SCOTT.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) values ('7782','CLARK','MANAGER','7839',to_date('81/06/09','RR/MM/DD'),'2450',null,'10');
Insert into SCOTT.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) values ('7839','KING','PRESIDENT',null,to_date('81/11/17','RR/MM/DD'),'5000',null,'10');
Insert into SCOTT.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) values ('7844','TURNER','SALESMAN','7698',to_date('81/09/08','RR/MM/DD'),'1500','0','30');
Insert into SCOTT.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) values ('7900','JAMES','CLERK','7698',to_date('81/12/03','RR/MM/DD'),'950',null,'30');
Insert into SCOTT.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) values ('7902','FORD','ANALYST','7566',to_date('81/12/03','RR/MM/DD'),'3000',null,'20');
Insert into SCOTT.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) values ('7934','MILLER','CLERK','7782',to_date('82/01/23','RR/MM/DD'),'1300',null,'10');
REM INSERTING into SCOTT.DEPT
SET DEFINE OFF;
Insert into SCOTT.DEPT (DEPTNO,DNAME,LOC) values ('10','ACCOUNTING','NEW YORK');
Insert into SCOTT.DEPT (DEPTNO,DNAME,LOC) values ('20','RESEARCH','DALLAS');
Insert into SCOTT.DEPT (DEPTNO,DNAME,LOC) values ('30','SALES','CHICAGO');
Insert into SCOTT.DEPT (DEPTNO,DNAME,LOC) values ('40','OPERATIONS','BOSTON');
REM INSERTING into SCOTT.BONUS
SET DEFINE OFF;
REM INSERTING into SCOTT.SALGRADE
SET DEFINE OFF;
Insert into SCOTT.SALGRADE (GRADE,LOSAL,HISAL) values ('1','700','1200');
Insert into SCOTT.SALGRADE (GRADE,LOSAL,HISAL) values ('2','1201','1400');
Insert into SCOTT.SALGRADE (GRADE,LOSAL,HISAL) values ('3','1401','2000');
Insert into SCOTT.SALGRADE (GRADE,LOSAL,HISAL) values ('4','2001','3000');
Insert into SCOTT.SALGRADE (GRADE,LOSAL,HISAL) values ('5','3001','9999');
--------------------------------------------------------
--  Constraints for Table EMP
--------------------------------------------------------

  ALTER TABLE "SCOTT"."EMP" ADD CONSTRAINT "PK_EMP" PRIMARY KEY ("EMPNO")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table DEPT
--------------------------------------------------------

  ALTER TABLE "SCOTT"."DEPT" ADD CONSTRAINT "PK_DEPT" PRIMARY KEY ("DEPTNO")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table EMP
--------------------------------------------------------

  ALTER TABLE "SCOTT"."EMP" ADD CONSTRAINT "FK_DEPTNO" FOREIGN KEY ("DEPTNO")
	  REFERENCES "SCOTT"."DEPT" ("DEPTNO") ENABLE;







ZADANIA:

-- Skopiować tabele EMP i DEPT o nowych nazwach EMPZAL i DEPTZAL.
CREATE TABLE EMPZAL AS SELECT * FROM SCOTT.EMP;
CREATE TABLE DEPTZAL AS SELECT * FROM SCOTT.DEPT;

-- 1
-- polecenie:
-- Napisać blok PL/SQL w którym wykorzystana zostanie zmienna typu VARCHAR 
-- z przypisanym ciągiem znaków w postaci jednego zdania:
-- 'KoLoKwIum z przedmiotu Relacyjne Obiektowe BD '
-- w którym wykorzystane zostaną instrukcje sterujące zamieniające znaki małe 
-- na duże a duże na małe. Zaprezentować przykład działania tego bloku.

SET SERVEROUTPUT ON;

DECLARE
    tekst   VARCHAR2(100) := 'KoLoKwIum z przedmiotu Relacyjne Obiektowe BD ';
    wynik   VARCHAR2(100) := '';
    dlugosc NUMBER;
    znak    CHAR(1);
BEGIN
    dlugosc := LENGTH(tekst);

    FOR i IN 1 .. dlugosc LOOP
        znak := SUBSTR(tekst, i, 1);

        IF znak = UPPER(znak) THEN
            wynik := wynik || LOWER(znak);
        ELSE
            wynik := wynik || UPPER(znak);
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Tekst pierwotny : ' || tekst);
    DBMS_OUTPUT.PUT_LINE('Tekst po zmianie: ' || wynik);
END;
/

-- przykład użycia:
-- po uruchomieniu bloku powyżej tekst zostanie wypisany w 2 wersjach.



-- 2
-- polecenie:
-- Opracować procedurę o nazwie MGR_EMP, która poprzez parametr typu OUT 
-- zwraca średnią pensję wszystkich pracowników podlegających szefowi 
-- podanemu jako parametr typu IN w postaci nazwiska (ENAME).
-- W agregacji uwzględnić kolumnę SAL oraz kolumnę COMM. 
-- W przypadku podania nieistniejącego nazwiska szefa zrealizować wyjątek, 
-- który będzie obsłużony w części EXCEPTION.
-- Napisać przykład wykorzystujący tę procedurę.

CREATE OR REPLACE PROCEDURE MGR_EMP (
    nazwisko IN EMPZAL.ENAME%TYPE,
    srednia OUT NUMBER
) IS
    numer_szefa EMPZAL.EMPNO%TYPE;
BEGIN
    SELECT EMPNO INTO numer_szefa
    FROM EMPZAL
    WHERE UPPER(ENAME) = UPPER(nazwisko);

    SELECT AVG(SAL + NVL(COMM, 0))
    INTO srednia
    FROM EMPZAL
    WHERE MGR = numer_szefa;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Wyjątek: Nie znaleziono szefa ' || nazwisko);
        srednia := NULL;
END;
/


SET SERVEROUTPUT ON;

DECLARE
  srednia NUMBER;
BEGIN
  MGR_EMP('KING', srednia);
  DBMS_OUTPUT.PUT_LINE('Średnia pensja podwładnych: ' ||
  NVL(TO_CHAR(srednia), 'brak danych'));
END;
/




-- 3
-- polecenie:
-- Napisać funkcję DZIEN_URODZIN(dataU IN DATE) zwracającą słownie dzień tygodnia 
-- dla podanej daty urodzin. W przypadku braku parametru wejściowego zrealizować 
-- wyjątek, który będzie obsłużony w części EXCEPTION. 
-- Napisać przykład wykorzystujący tę funkcję.



CREATE OR REPLACE FUNCTION DZIEN_URODZIN(
  dataU IN DATE
) RETURN VARCHAR2 IS
    dzien VARCHAR2(50);
    brak_daty EXCEPTION;
BEGIN
    IF dataU IS NULL THEN
        RAISE brak_daty;
    END IF;

    dzien := RTRIM(TO_CHAR(dataU, 'DAY', 'NLS_DATE_LANGUAGE=POLISH'));
    RETURN dzien;

EXCEPTION
    WHEN brak_daty THEN
        DBMS_OUTPUT.PUT_LINE('Wyjątek: Nie podano daty urodzin');
        RETURN NULL;
END;
/

-- przykład użycia:
DECLARE
    wynik VARCHAR2(50);
BEGIN
    wynik := DZIEN_URODZIN(TO_DATE('2000-01-01', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Dzień urodzin: ' || wynik);
END;
/


-- 4
-- polecenie:
-- Dołożyć do tabeli EMP dodatkową kolumnę "email" z ograniczeniem UNIQUE, 
-- którego wartość będzie dodawana za pomocą wyzwalacza przy operacji INSERT. 
-- Email ma mieć postać: nazwa z ENAME zamieniona na małe litery, spacje zamienione 
-- na podkreślenia, plus '@test.pl'.
-- Napisać przykładowe instrukcje prezentujące działanie wyzwalacza.

ALTER TABLE EMPZAL ADD email VARCHAR2(50);
ALTER TABLE EMPZAL ADD CONSTRAINT uk_email UNIQUE (email);


CREATE OR REPLACE TRIGGER dodaj_email
BEFORE INSERT ON EMPZAL
FOR EACH ROW
BEGIN
    :NEW.email := REPLACE(LOWER(:NEW.ENAME), ' ', '_') || '@test.pl';
END;
/

-- przykład użycia:
INSERT INTO EMPZAL (EMPNO, ENAME, JOB, DEPTNO)
VALUES (9003, 'JAN KOWALSKI', 'TEST', 10);

SELECT ENAME, EMAIL FROM EMPZAL WHERE EMPNO = 9003;


-- 5
-- polecenie:
-- Zdefiniować tabele STUDENCI i PRZEDMIOTY (z własnymi kolumnami i typami),
-- założyć relację wiele-do-wielu poprzez tabelę OCENY z ocenami.
-- Klucze podstawowe mają być z auto-numeracją (sekwencja + wyzwalacz).
-- Wprowadzić po 3 rekordy do każdej tabeli i napisać zapytanie:
-- jaki student z jakiego przedmiotu otrzymał jakie oceny?

CREATE TABLE STUDENCI (
    ID_STUDENTA NUMBER PRIMARY KEY,
    IMIE        VARCHAR2(50),
    NAZWISKO    VARCHAR2(50)
);

CREATE SEQUENCE SEQ_STUDENCI START WITH 1 INCREMENT BY 1;

CREATE TABLE PRZEDMIOTY (
    ID_PRZEDMIOTU NUMBER PRIMARY KEY,
    NAZWA         VARCHAR2(100)
);

CREATE SEQUENCE SEQ_PRZEDMIOTY START WITH 1 INCREMENT BY 1;

CREATE TABLE OCENY (
    ID_OCENY      NUMBER PRIMARY KEY,
    ID_STUDENTA   NUMBER REFERENCES STUDENCI(ID_STUDENTA),
    ID_PRZEDMIOTU NUMBER REFERENCES PRZEDMIOTY(ID_PRZEDMIOTU),
    WARTOSC       NUMBER
);

CREATE SEQUENCE SEQ_OCENY START WITH 1 INCREMENT BY 1;



CREATE OR REPLACE TRIGGER TRG_STUDENCI
BEFORE INSERT ON STUDENCI
FOR EACH ROW
BEGIN
    IF :NEW.ID_STUDENTA IS NULL THEN
        :NEW.ID_STUDENTA := SEQ_STUDENCI.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_PRZEDMIOTY
BEFORE INSERT ON PRZEDMIOTY
FOR EACH ROW
BEGIN
    IF :NEW.ID_PRZEDMIOTU IS NULL THEN
        :NEW.ID_PRZEDMIOTU := SEQ_PRZEDMIOTY.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_OCENY
BEFORE INSERT ON OCENY
FOR EACH ROW
BEGIN
    IF :NEW.ID_OCENY IS NULL THEN
        :NEW.ID_OCENY := SEQ_OCENY.NEXTVAL;
    END IF;
END;
/

-- wstawienie przykładów:
INSERT INTO STUDENCI (IMIE, NAZWISKO) VALUES ('Jan', 'Kowalski');
INSERT INTO STUDENCI (IMIE, NAZWISKO) VALUES ('Anna', 'Nowak');
INSERT INTO STUDENCI (IMIE, NAZWISKO) VALUES ('Piotr', 'Zieliński');

INSERT INTO PRZEDMIOTY (NAZWA) VALUES ('Bazy Danych');
INSERT INTO PRZEDMIOTY (NAZWA) VALUES ('Matematyka');
INSERT INTO PRZEDMIOTY (NAZWA) VALUES ('Programowanie');

INSERT INTO OCENY (ID_STUDENTA, ID_PRZEDMIOTU, WARTOSC) VALUES (1, 1, 5);
INSERT INTO OCENY (ID_STUDENTA, ID_PRZEDMIOTU, WARTOSC) VALUES (2, 2, 4);
INSERT INTO OCENY (ID_STUDENTA, ID_PRZEDMIOTU, WARTOSC) VALUES (3, 3, 3);

-- przykład użycia – zapytanie:
SELECT
    S.IMIE,
    S.NAZWISKO,
    P.NAZWA AS PRZEDMIOT,
    O.WARTOSC AS OCENA
FROM
    STUDENCI S
    JOIN OCENY O ON S.ID_STUDENTA = O.ID_STUDENTA
    JOIN PRZEDMIOTY P ON O.ID_PRZEDMIOTU = P.ID_PRZEDMIOTU;


=======================================================================================



-- Skopiować tabele EMP i DEPT o nowych nazwach EMPZAL i DEPTZAL do swojego schematu.
-- Polecenia tworzące strukturę CREATE TABLE EMPZAL as SELECT * FROM SCOTT.EMP;
-- CREATE TABLE DEPTZAL as SELECT * FROM SCOTT.DEPT; (pracujemy w schemacie SCOTT).

DROP TABLE EMPZAL;
DROP TABLE DEPTZAL;

CREATE TABLE EMPZAL AS SELECT * FROM SCOTT.EMP;
CREATE TABLE DEPTZAL AS SELECT * FROM SCOTT.DEPT;



-- 1
-- polecenie:
-- Napisać blok PL/SQL który dla ustawionej zmiennej typu daty (typ DATE) zwraca
-- dzień tygodnia w języku polskim. W tym celu wykorzystać instrukcję warunkową
-- IF lub CASE. Podać przykład wyzwolenia takiego bloku.

SET SERVEROUTPUT ON;

DECLARE
  data_test   DATE := SYSDATE;
  nazwa_dnia  VARCHAR2(20);
BEGIN
  nazwa_dnia :=
    CASE TO_CHAR(data_test, 'DY', 'NLS_DATE_LANGUAGE=POLISH')
      WHEN 'PN' THEN 'poniedziałek'
      WHEN 'WT' THEN 'wtorek'
      WHEN 'ŚR' THEN 'środa'
      WHEN 'CZ' THEN 'czwartek'
      WHEN 'PT' THEN 'piątek'
      WHEN 'SO' THEN 'sobota'
      WHEN 'ND' THEN 'niedziela'
      ELSE 'nieznany dzień: ' || TO_CHAR(data_test, 'DY', 'NLS_DATE_LANGUAGE=POLISH')
    END;

  DBMS_OUTPUT.PUT_LINE('Data: ' || TO_CHAR(data_test, 'YYYY-MM-DD'));
  DBMS_OUTPUT.PUT_LINE('Dzień tygodnia: ' || nazwa_dnia);
END;
/

-- przykład użycia:
-- po uruchomieniu bloku powyżej zostanie wypisany dzień tygodnia dla ustawionej daty.



-- 2
-- polecenie:
-- Napisać funkcję MONTH_COUNT(DATE) z własną obsługą błędów, która dla podanej
-- jako parametr wejściowy daty (typ DATE) zwróci zaokrągloną liczbę miesięcy
-- jaka upłynęła między podaną w parametrze datą a datą zegara systemowego.
-- W przypadku podania daty późniejszej od daty zegara systemowego lub wartości
-- NULL, podnieść własną obsługę błędów. Podać przykłady wyzwolenia takiej funkcji.

CREATE OR REPLACE FUNCTION MONTH_COUNT(
    data IN DATE
) RETURN NUMBER IS
    ile NUMBER;
    blad EXCEPTION;
BEGIN
    IF data IS NULL OR data > SYSDATE THEN
        RAISE blad;
    END IF;

    ile := ROUND(MONTHS_BETWEEN(SYSDATE, data));
    RETURN ile;

EXCEPTION
    WHEN blad THEN
        DBMS_OUTPUT.PUT_LINE('Błąd daty');
        RETURN NULL;
END;
/

SET SERVEROUTPUT ON;

DECLARE
    wynik NUMBER;
BEGIN
    wynik := MONTH_COUNT(TO_DATE('2020-01-01', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Miesiące: ' || wynik);

    wynik := MONTH_COUNT(SYSDATE + 100);

    wynik := MONTH_COUNT(NULL);
END;
/




-- 3
-- polecenie:
-- Napisz procedurę AVG_SAL(VARCHAR, NUMBER) przechowywaną z obsługą błędów,
-- która poprzez parametr typu OUT zwraca średnią (zagregowaną) wartość wypłat
-- pensji na danym stanowisku (kolumna JOB tabeli EMPZAL) podanym jako parametr
-- typu IN. W agregacji uwzględnić kolumnę SAL oraz kolumnę COMM w której
-- znajduje się prowizja tabeli EMPZAL. W przypadku podania nieistniejącego
-- stanowiska zrealizuj wyjątek, który będzie obsłużony w części EXCEPTION.
-- Napisz przykład wykorzystujący tę procedurę.

CREATE OR REPLACE PROCEDURE AVG_SAL (
    stanowisko IN VARCHAR2,
    srednia OUT NUMBER
) IS
    ile NUMBER;
    brak EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO ile
    FROM EMPZAL
    WHERE UPPER(JOB) = UPPER(stanowisko);

    IF ile = 0 THEN
        RAISE brak;
    END IF;

    SELECT AVG(SAL + NVL(COMM, 0))
    INTO srednia
    FROM EMPZAL
    WHERE UPPER(JOB) = UPPER(stanowisko);

EXCEPTION
    WHEN brak THEN
        DBMS_OUTPUT.PUT_LINE('Błąd: brak stanowiska');
        srednia := NULL;
END;
/

SET SERVEROUTPUT ON;

DECLARE
    wynik NUMBER;
BEGIN
    AVG_SAL('CLERK', wynik);
    DBMS_OUTPUT.PUT_LINE('Średnia: ' || wynik);

    AVG_SAL('KIEROWCA', wynik);
END;
/



-- 4
-- polecenie:
-- Założyć tabelę EMP_HISTORY z kolumnami: DEPTNO_OLD, DEPTNO_NEW, CHDATE.
-- Opracować wyzwalacz wierszowy na tabeli DEPTZAL, który automatycznie
-- zaktualizuje numer działu w tabeli EMP jeżeli zmieni się on w tabeli DEPTZAL.
-- Dodatkowo wyzwalacz zarejestruje w tabeli EMP_HISTORY informację z jakiego
-- numeru na jaki numer zmieniono dział oraz kiedy to zostało zrobione.

CREATE TABLE EMP_HISTORY (
    DEPTNO_OLD NUMBER,
    DEPTNO_NEW NUMBER,
    CHDATE DATE
);

CREATE OR REPLACE TRIGGER zmiana_dzialu
AFTER UPDATE OF DEPTNO ON DEPTZAL
FOR EACH ROW
BEGIN
    UPDATE EMPZAL
    SET DEPTNO = :NEW.DEPTNO
    WHERE DEPTNO = :OLD.DEPTNO;

    INSERT INTO EMP_HISTORY (DEPTNO_OLD, DEPTNO_NEW, CHDATE)
    VALUES (:OLD.DEPTNO, :NEW.DEPTNO, SYSDATE);
END;
/

UPDATE DEPTZAL SET DEPTNO = 50 WHERE DEPTNO = 10;

SELECT * FROM EMP_HISTORY;
SELECT ENAME, DEPTNO FROM EMPZAL WHERE DEPTNO = 50;



-- 5
-- polecenie:
-- Zdefiniować relację wiele do wielu dla tabel AUTORZY i PUBLIKACJE (dodatkowa
-- tabela AUTORZY_PUBLIKACJE). Tabele AUTORZY i PUBLIKACJE mają mieć
-- zdefiniowane klucze podstawowe typu INTEGER z auto numeracją z
-- wykorzystaniem sekwencji i wyzwalacza. Należy także zdefiniować odpowiednie
-- dla nich klucze obce. Pamiętajmy iż nie możemy dodać dwa razy dla tego samego
-- autora z tą samą publikacją (zabezpieczyć się przed taką ewentualnością).

CREATE TABLE AUTORZY (
    ID INTEGER PRIMARY KEY,
    NAZWISKO VARCHAR2(50)
);

CREATE SEQUENCE SEQ_AUTORZY START WITH 1 INCREMENT BY 1;

CREATE TABLE PUBLIKACJE (
    ID INTEGER PRIMARY KEY,
    TYTUL VARCHAR2(100)
);

CREATE SEQUENCE SEQ_PUBLIKACJE START WITH 1 INCREMENT BY 1;

CREATE TABLE AUTORZY_PUBLIKACJE (
    AUTOR_ID INTEGER REFERENCES AUTORZY(ID),
    PUB_ID INTEGER REFERENCES PUBLIKACJE(ID),
    CONSTRAINT unikalne UNIQUE (AUTOR_ID, PUB_ID)
);

CREATE OR REPLACE TRIGGER trg_autorzy
BEFORE INSERT ON AUTORZY
FOR EACH ROW
BEGIN
    IF :NEW.ID IS NULL THEN
        :NEW.ID := SEQ_AUTORZY.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_publikacje
BEFORE INSERT ON PUBLIKACJE
FOR EACH ROW
BEGIN
    IF :NEW.ID IS NULL THEN
        :NEW.ID := SEQ_PUBLIKACJE.NEXTVAL;
    END IF;
END;
/

INSERT INTO AUTORZY (NAZWISKO) VALUES ('Mickiewicz');
INSERT INTO AUTORZY (NAZWISKO) VALUES ('Sienkiewicz');

INSERT INTO PUBLIKACJE (TYTUL) VALUES ('Pan Tadeusz');
INSERT INTO PUBLIKACJE (TYTUL) VALUES ('Potop');

INSERT INTO AUTORZY_PUBLIKACJE (AUTOR_ID, PUB_ID) VALUES (1, 1);
INSERT INTO AUTORZY_PUBLIKACJE (AUTOR_ID, PUB_ID) VALUES (2, 2);

SELECT A.NAZWISKO, P.TYTUL
FROM AUTORZY A
JOIN AUTORZY_PUBLIKACJE AP ON A.ID = AP.AUTOR_ID
JOIN PUBLIKACJE P ON AP.PUB_ID = P.ID;






===============================================================================================









-- Skopiować tabele EMP i DEPT o nowych nazwach: EMPZAL i DEPTZAL do swojego schematu.
-- Polecenia tworzące strukturę: CREATE TABLE EMPZAL as SELECT * FROM SCOTT.EMP;
-- CREATE TABLE DEPTZAL as SELECT * FROM SCOTT.DEPT; (pracujemy we własnym schemacie lub schemacie SCOTT).

DROP TABLE EMPZAL;
DROP TABLE DEPTZAL;

CREATE TABLE EMPZAL AS SELECT * FROM SCOTT.EMP;
CREATE TABLE DEPTZAL AS SELECT * FROM SCOTT.DEPT;


-- 1
-- polecenie:
-- 1. Napisać blok PL/SQL w którym wykorzystany zostanie kursor i który iteracyjnie poda
--    wszystkich pracowników dla działów, w których to działach średnia pensja jest wyższa
--    niż średnia pensja w całej firmie. Jako rezultat działania ma być podane dla takich
--    pracowników: nazwisko pracownika ENAME, pensja pracownika z prowizją,
--    średnia pensja w dziale tego pracownika (z prowizją) oraz średnia pensja firmy.

SET SERVEROUTPUT ON;

DECLARE
    ogolna NUMBER;

    CURSOR kursor (limit NUMBER) IS
        SELECT E.ENAME,
               (E.SAL + NVL(E.COMM, 0)) AS ZAROBEK, 
               S.SREDNIA
        FROM EMPZAL E
        JOIN (
            SELECT DEPTNO, AVG(SAL + NVL(COMM, 0)) AS SREDNIA
            FROM EMPZAL
            GROUP BY DEPTNO
        ) S ON E.DEPTNO = S.DEPTNO
        WHERE S.SREDNIA > limit;

    wiersz kursor%ROWTYPE;
BEGIN
    SELECT AVG(SAL + NVL(COMM, 0)) INTO ogolna FROM EMPZAL;

    OPEN kursor(ogolna);
    LOOP
        FETCH kursor INTO wiersz;
        EXIT WHEN kursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Pracownik: ' || wiersz.ENAME ||
                             ' Pensja: ' || wiersz.ZAROBEK ||
                             ' Śr. działu: ' || ROUND(wiersz.SREDNIA, 2) ||
                             ' Śr. firmy: ' || ROUND(ogolna, 2));
    END LOOP;
    CLOSE kursor;
END;
/

-- przykład użycia:
-- po uruchomieniu powyższego bloku zostaną wypisani pracownicy z działów,
-- w których średnia pensja (z prowizją) jest wyższa niż średnia pensja w całej firmie.



-- 2
-- polecenie:
-- 2. Zdefiniować procedurę przechowywaną GET_REV_STR (zm1, zm2), która dla podanego
--    pierwszego wejściowego parametru typu VARCHAR zwraca poprzez parametr wyjściowy zm2
--    ciąg znaków w odwrotnej kolejności (tzn. od końcowego znaku do pierwszego w ciągu).
--    W przypadku podania nieistniejącego parametru wejściowego zrealizuj wyjątek,
--    który będzie obsłużony w części EXCEPTION.
--    Napisz przykład wykorzystujący tę procedurę, przypisanym ciągiem znaków w postaci
--    jednego zdania: 'KoLoKwIum z przedmiotu Relacyjne Obiektowe BD '

CREATE OR REPLACE PROCEDURE GET_REV_STR (
    tekst IN VARCHAR2,
    wynik OUT VARCHAR2
) IS
    dlugosc NUMBER;
    pusty_tekst EXCEPTION;
BEGIN
    IF tekst IS NULL THEN
        RAISE pusty_tekst;
    END IF;

    wynik := '';
    dlugosc := LENGTH(tekst);

    FOR i IN REVERSE 1 .. dlugosc LOOP
        wynik := wynik || SUBSTR(tekst, i, 1);
    END LOOP;

EXCEPTION
    WHEN pusty_tekst THEN
        DBMS_OUTPUT.PUT_LINE('Blad: Parametr wejsciowy jest pusty');
        wynik := NULL;
END;
/

SET SERVEROUTPUT ON;

DECLARE
    zdanie VARCHAR2(100) := 'KoLoKwIum z przedmiotu Relacyjne Obiektowe BD ';
    odwrocone VARCHAR2(100);
BEGIN
    GET_REV_STR(zdanie, odwrocone);
    DBMS_OUTPUT.PUT_LINE('Oryginal: ' || zdanie);
    DBMS_OUTPUT.PUT_LINE('Odwrocony: ' || odwrocone);
END;
/


-- 3
-- polecenie:
-- 3. Zdefiniować własną funkcję FU_YEARS(dataU IN DATE), której parametrem wejściowym będzie
--    zmienna typu DATE. Funkcja ta zwraca wartość 1 jeżeli różnica lat między bieżącą datą
--    pobraną z zegara systemowego a datą przekazaną do funkcji jest większa niż 40 lat
--    lub wartość 0 w przeciwnym razie. W przypadku braku podania parametru wejściowego
--    zrealizuj wyjątek, który będzie obsłużony w części EXCEPTION w postaci odpowiedniego
--    komunikatu. UWAGA w bloku PL/SQL wykorzystać funkcję MONTHS_BETWEEN.
--    Napisz przykład wykorzystujący opracowaną funkcję w bloku PL/SQL.

CREATE OR REPLACE FUNCTION FU_YEARS(
    dataU IN DATE
) RETURN NUMBER IS
    brak_daty EXCEPTION;
    roznica NUMBER;
BEGIN
    IF dataU IS NULL THEN
        RAISE brak_daty;
    END IF;

    roznica := MONTHS_BETWEEN(SYSDATE, dataU);

    IF roznica / 12 > 40 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;

EXCEPTION
    WHEN brak_daty THEN
        DBMS_OUTPUT.PUT_LINE('Blad: Brak parametru wejsciowego');
        RETURN NULL;
END;
/

SET SERVEROUTPUT ON;

DECLARE
    wynik NUMBER;
BEGIN
    wynik := FU_YEARS(TO_DATE('1980-01-01', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Wynik dla daty 1980 ( > 40 lat): ' || wynik);

    wynik := FU_YEARS(TO_DATE('2010-01-01', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Wynik dla daty 2010 ( < 40 lat): ' || wynik);

    wynik := FU_YEARS(NULL);
END;
/



-- 4
-- polecenie:
-- 4. Założyć tabelę EMP_HISTORY (z kolumnami: DEPTNO_OLD, DEPTNO_NEW, CHDATE).
--    Opracować wyzwalacz wierszowy na tabeli DEPTZAL, który automatycznie zaktualizuje
--    numer działu w tabeli EMP jeżeli zmieni się on w tabeli DEPTZAL.
--    Dodatkowo wyzwalacz zarejestruje w tabeli EMP_HISTORY informację z jakiego numeru
--    na jaki numer zmieniono dział oraz kiedy to zostało zrobione.

CREATE TABLE EMP_HISTORY (
    DEPTNO_OLD NUMBER,
    DEPTNO_NEW NUMBER,
    CHDATE DATE
);

CREATE OR REPLACE TRIGGER AKTUALIZACJA_DZIALU
AFTER UPDATE OF DEPTNO ON DEPTZAL
FOR EACH ROW
BEGIN
    UPDATE EMPZAL
    SET DEPTNO = :NEW.DEPTNO
    WHERE DEPTNO = :OLD.DEPTNO;

    INSERT INTO EMP_HISTORY (DEPTNO_OLD, DEPTNO_NEW, CHDATE)
    VALUES (:OLD.DEPTNO, :NEW.DEPTNO, SYSDATE);
END;
/

UPDATE DEPTZAL SET DEPTNO = 55 WHERE DEPTNO = 10;

SELECT * FROM EMP_HISTORY;
SELECT ENAME, DEPTNO FROM EMPZAL WHERE DEPTNO = 55;


-- 5
-- polecenie:
-- 5. Zdefiniować strukturę dwóch tabel łącznie z ograniczeniami PK, FK i ewentualnie CHECK,
--    które dla danych drużyn pokażą datę i wyniki rozgrywek. Pamiętajmy iż drużyna nie może
--    zagrać sama ze sobą. Na podstawie danej struktury (wypełnić przykładowymi danymi)
--    definiujemy zapytanie które zwróci informację o wielu meczach postaci
--    (np. 'Drużyna_1 : Drużyna_2', 'Wynik 1:4', 'Data rozgrywki 27-11-2024')

CREATE TABLE DRUZYNY (
    ID_DRUZYNY NUMBER PRIMARY KEY,
    NAZWA VARCHAR2(50) NOT NULL
);

CREATE TABLE MECZE (
    ID_MECZU NUMBER PRIMARY KEY,
    ID_GOSPODARZ NUMBER REFERENCES DRUZYNY(ID_DRUZYNY),
    ID_GOSC NUMBER REFERENCES DRUZYNY(ID_DRUZYNY),
    GOLE_GOSPODARZ NUMBER,
    GOLE_GOSC NUMBER,
    DATA_MECZU DATE,
    CONSTRAINT CHK_ROZNE_DRUZYNY CHECK (ID_GOSPODARZ <> ID_GOSC)
);

INSERT INTO DRUZYNY (ID_DRUZYNY, NAZWA) VALUES (1, 'Legia Warszawa');
INSERT INTO DRUZYNY (ID_DRUZYNY, NAZWA) VALUES (2, 'Wisła Kraków');
INSERT INTO DRUZYNY (ID_DRUZYNY, NAZWA) VALUES (3, 'Lech Poznań');

INSERT INTO MECZE VALUES (1, 1, 2, 1, 4, TO_DATE('2024-11-27', 'YYYY-MM-DD'));
INSERT INTO MECZE VALUES (2, 2, 3, 2, 2, TO_DATE('2024-12-01', 'YYYY-MM-DD'));
INSERT INTO MECZE VALUES (3, 3, 1, 0, 1, TO_DATE('2024-12-05', 'YYYY-MM-DD'));

SELECT
    D1.NAZWA || ' : ' || D2.NAZWA AS ZESPOLY,
    'Wynik ' || M.GOLE_GOSPODARZ || ':' || M.GOLE_GOSC AS WYNIK,
    'Data rozgrywki ' || TO_CHAR(M.DATA_MECZU, 'DD-MM-YYYY') AS DATA
FROM MECZE M
JOIN DRUZYNY D1 ON M.ID_GOSPODARZ = D1.ID_DRUZYNY
JOIN DRUZYNY D2 ON M.ID_GOSC = D2.ID_DRUZYNY;





====================================================================





-- Skopiować tabele EMP i DEPT o nowych nazwach: EMPZAL i DEPTZAL do swojego schematu.
-- Polecenia tworzące strukturę: CREATE TABLE EMPZAL as SELECT * FROM SCOTT.EMP;
-- CREATE TABLE DEPTZAL as SELECT * FROM SCOTT.DEPT; (pracujemy w schemacie SCOTT).

DROP TABLE EMPZAL;
DROP TABLE DEPTZAL;

CREATE TABLE EMPZAL AS SELECT * FROM SCOTT.EMP;
CREATE TABLE DEPTZAL AS SELECT * FROM SCOTT.DEPT;

-- 1
-- polecenie:
-- 1. Napisać blok PL/SQL w którym wykorzystany zostanie kursor i który iteracyjnie poda nazwiska pracowników oraz obok
--    (w tej samej krotce) całkowitą sumę wynagrodzenia w dziale tego pracownika.

SET SERVEROUTPUT ON;

DECLARE
    CURSOR kursor IS
        SELECT E.ENAME, S.SUMA_PLAC
        FROM EMPZAL E
        JOIN (
            SELECT DEPTNO, SUM(SAL) AS SUMA_PLAC
            FROM EMPZAL
            GROUP BY DEPTNO
        ) S ON E.DEPTNO = S.DEPTNO;

    rekord kursor%ROWTYPE;
BEGIN
    OPEN kursor;
    LOOP
        FETCH kursor INTO rekord;
        EXIT WHEN kursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Pracownik: ' || rekord.ENAME || 
                             ' Suma plac w dziale: ' || rekord.SUMA_PLAC);
    END LOOP;
    CLOSE kursor;
END;
/

-- przykład użycia:
-- uruchomić powyższy blok — wypisze wszystkich pracowników i łączną pensję w ich dziale.



-- 2
-- polecenie:
-- 2. Napisać procedure: AVG_SAL(VARCHAR, NUMBER) przechowywaną z obsługą błędów, która poprzez parametr typu OUT zwraca
--    średnią (zagregowaną) wartość wypłat pensji na danym stanowisku (kolumna JOB tabeli EMPZAL) podanym jako parametr typu IN.
--    W agregacji uwzględnić kolumnę SAL oraz kolumnę COMM w której znajduje się prowizja tabeli EMPZAL.
--    W przypadku podania nieistniejącego stanowiska zrealizuj wyjątek, który będzie obsłużony w części EXCEPTION.
--    Napisz przykład wykorzystujący tę procedurę.

CREATE OR REPLACE PROCEDURE AVG_SAL (
    stanowisko IN VARCHAR2,
    srednia OUT NUMBER
) IS
    licznik NUMBER;
    brak_stanowiska EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO licznik
    FROM EMPZAL
    WHERE UPPER(JOB) = UPPER(stanowisko);

    IF licznik = 0 THEN
        RAISE brak_stanowiska;
    END IF;

    SELECT AVG(SAL + NVL(COMM, 0))
    INTO srednia
    FROM EMPZAL
    WHERE UPPER(JOB) = UPPER(stanowisko);

EXCEPTION
    WHEN brak_stanowiska THEN
        DBMS_OUTPUT.PUT_LINE('Wyjatek: Podane stanowisko nie istnieje');
        srednia := NULL;
END;
/

SET SERVEROUTPUT ON;

DECLARE
    wynik NUMBER;
BEGIN
    AVG_SAL('CLERK', wynik);
    DBMS_OUTPUT.PUT_LINE('Srednia pensja CLERK: ' || ROUND(wynik, 2));

    AVG_SAL('PROGRAMISTA', wynik);
END;
/



-- 3
-- polecenie:
-- 3. Napisać funkcję DAYS_NO(data1 IN DATE) która policzy ilość sobót i niedziel (tzn. dni weekendów ale bez dodatkowych dni
--    świątecznych) w danym miesiącu dla podanej jako parametr wejściowy daty. Napisz przykład wykorzystujący opracowaną funkcję
--    w bloku PL/SQL.

CREATE OR REPLACE FUNCTION DAYS_NO(
    data1 IN DATE
) RETURN NUMBER IS
    data_pocz DATE;
    data_kon  DATE;
    suma_dni  NUMBER := 0;
    temp_data DATE;
    dzien     VARCHAR2(5);
BEGIN
    data_pocz := TRUNC(data1, 'MM');
    data_kon  := LAST_DAY(data1);

    FOR i IN 0 .. (data_kon - data_pocz) LOOP
        temp_data := data_pocz + i;
        dzien := TO_CHAR(temp_data, 'DY', 'NLS_DATE_LANGUAGE=POLISH');

        IF dzien IN ('SO', 'ND') THEN
            suma_dni := suma_dni + 1;
        END IF;
    END LOOP;

    RETURN suma_dni;
END;
/

SET SERVEROUTPUT ON;

DECLARE
    wynik NUMBER;
    data_testowa DATE := TO_DATE('2024-11-20', 'YYYY-MM-DD');
BEGIN
    wynik := DAYS_NO(data_testowa);
    DBMS_OUTPUT.PUT_LINE('Dla daty ' || data_testowa || ' liczba sobot i niedziel w miesiacu to: ' || wynik);
END;
/




-- 4
-- polecenie:
-- 4. Napisać wyzwalacz, który sprawdza czy dla nowo dodawanego pracownika jego pensja (łącznie z prowizją) nie przekracza pensji jego
--    szefa. W przypadku pensji pracownika większej od pensji szefa podnieść obsługę błędów:
--
--    RAISE_APPLICATION_ERROR(-20001, 'The employee''s salary is greater than the boss''s salary!');
--
--    Podaj przykłady instrukcji prezentujące działanie wyzwalacza.

CREATE OR REPLACE TRIGGER SPRAWDZ_PENSJE
BEFORE INSERT ON EMPZAL
FOR EACH ROW
DECLARE
    pensja_szefa NUMBER;
    pensja_pracownika NUMBER;
BEGIN
    IF :NEW.MGR IS NOT NULL THEN
        SELECT SAL + NVL(COMM, 0)
        INTO pensja_szefa
        FROM EMPZAL
        WHERE EMPNO = :NEW.MGR;

        pensja_pracownika := :NEW.SAL + NVL(:NEW.COMM, 0);

        IF pensja_pracownika > pensja_szefa THEN
            RAISE_APPLICATION_ERROR(-20001, 'The employee''s salary is greater than the boss''s salary!');
        END IF;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        NULL;
END;
/

-- Przykład 1: Poprawne dodanie (pensja mniejsza od szefa - szef 7839 KING ma 5000)
INSERT INTO EMPZAL (EMPNO, ENAME, SAL, COMM, MGR, DEPTNO)
VALUES (9001, 'TEST_OK', 2000, NULL, 7839, 10);

-- Przykład 2: Błąd (pensja większa od szefa - szef 7902 FORD ma 3000)
-- To polecenie wywoła błąd ORA-20001
BEGIN
    INSERT INTO EMPZAL (EMPNO, ENAME, SAL, COMM, MGR, DEPTNO)
    VALUES (9002, 'TEST_BLAD', 4000, NULL, 7902, 20);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/




-- 5
-- polecenie:
-- 5. Zdefiniuj relacje wiele do wielu dla tabel CZYTELNICY i PUBLIKACJE (dodatkowa tabela CZYT_PUBL).
--    Tabele CZYTELNICY i PUBLIKACJE mają mieć zdefiniowane klucze podstawowe typu INTEGER z auto numeracją z wykorzystaniem sekwencji
--    i wyzwalacza. Należy także zdefiniować odpowiednie dla nich klucze obce. Pamiętajmy iż nie możemy dodać dwa razy dla tego samego
--    czytelnika z tą samą publikacją (zabezpieczyć się przed taką ewentualnością).

CREATE TABLE CZYTELNICY (
    ID_CZYTELNIKA INTEGER PRIMARY KEY,
    NAZWISKO VARCHAR2(50)
);

CREATE SEQUENCE SEQ_CZYTELNICY START WITH 1 INCREMENT BY 1;

CREATE TABLE PUBLIKACJE (
    ID_PUBLIKACJI INTEGER PRIMARY KEY,
    TYTUL VARCHAR2(100)
);

CREATE SEQUENCE SEQ_PUBLIKACJE START WITH 1 INCREMENT BY 1;

CREATE TABLE CZYT_PUBL (
    ID_CZYTELNIKA INTEGER REFERENCES CZYTELNICY(ID_CZYTELNIKA),
    ID_PUBLIKACJI INTEGER REFERENCES PUBLIKACJE(ID_PUBLIKACJI),
    CONSTRAINT UNIKALNE_WYPOZYCZENIE UNIQUE (ID_CZYTELNIKA, ID_PUBLIKACJI)
);

CREATE OR REPLACE TRIGGER TRG_CZYTELNICY
BEFORE INSERT ON CZYTELNICY
FOR EACH ROW
BEGIN
    IF :NEW.ID_CZYTELNIKA IS NULL THEN
        :NEW.ID_CZYTELNIKA := SEQ_CZYTELNICY.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_PUBLIKACJE
BEFORE INSERT ON PUBLIKACJE
FOR EACH ROW
BEGIN
    IF :NEW.ID_PUBLIKACJI IS NULL THEN
        :NEW.ID_PUBLIKACJI := SEQ_PUBLIKACJE.NEXTVAL;
    END IF;
END;
/

INSERT INTO CZYTELNICY (NAZWISKO) VALUES ('Kowalski');
INSERT INTO CZYTELNICY (NAZWISKO) VALUES ('Nowak');

INSERT INTO PUBLIKACJE (TYTUL) VALUES ('Sztuczna Inteligencja');
INSERT INTO PUBLIKACJE (TYTUL) VALUES ('Analiza Obrazów');

INSERT INTO CZYT_PUBL (ID_CZYTELNIKA, ID_PUBLIKACJI) VALUES (1, 1);
INSERT INTO CZYT_PUBL (ID_CZYTELNIKA, ID_PUBLIKACJI) VALUES (1, 2);
INSERT INTO CZYT_PUBL (ID_CZYTELNIKA, ID_PUBLIKACJI) VALUES (2, 1);

SELECT C.NAZWISKO, P.TYTUL
FROM CZYTELNICY C
JOIN CZYT_PUBL CP ON C.ID_CZYTELNIKA = CP.ID_CZYTELNIKA
JOIN PUBLIKACJE P ON CP.ID_PUBLIKACJI = P.ID_PUBLIKACJI;



========================================================



-- Skopiować tabele EMP i DEPT o nowych nazwach: EMPZAL i DEPTZAL do swojego schematu.  Polecenia tworzące strukturę:
-- CREATE TABLE EMPZAL as SELECT * FROM SCOTT.EMP; CREATE TABLE DEPTZAL as SELECT * FROM SCOTT.DEPT; (pracujemy we
-- własnym schemacie lub schemacie SCOTT).

DROP TABLE EMPZAL;
DROP TABLE DEPTZAL;

CREATE TABLE EMPZAL AS SELECT * FROM SCOTT.EMP;
CREATE TABLE DEPTZAL AS SELECT * FROM SCOTT.DEPT;



-- 1. Napisać blok PL/SQL w którym wykorzystany zostanie kursor i który iteracyjnie zwróci po 2 najmniej
-- zarabiających pracowników na danym stanowisku (JOB), ale z pominięciem tych, którzy pracują w departamencie
-- 20. Jako rezultat działania ma być podane dla takich pracowników: nazwisko pracownika ENAME, pensja pracownika
-- z prowizją, średnia pensja w dziale tego pracownika (z prowizją) oraz średnia pensja firmy.

SET SERVEROUTPUT ON;

DECLARE
    CURSOR kursor IS
        SELECT ENAME, PENSJA, SR_DZIAL, SR_FIRMA
        FROM (
            SELECT
                ENAME,
                SAL + NVL(COMM, 0) AS PENSJA,
                AVG(SAL + NVL(COMM, 0)) OVER (PARTITION BY DEPTNO) AS SR_DZIAL,
                AVG(SAL + NVL(COMM, 0)) OVER () AS SR_FIRMA,
                ROW_NUMBER() OVER (PARTITION BY JOB ORDER BY SAL + NVL(COMM, 0) ASC) AS POZYCJA
            FROM EMPZAL
            WHERE DEPTNO != 20
        )
        WHERE POZYCJA <= 2;

    wiersz kursor%ROWTYPE;
BEGIN
    OPEN kursor;
    LOOP
        FETCH kursor INTO wiersz;
        EXIT WHEN kursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Pracownik: ' || wiersz.ENAME ||
                             ' Pensja: ' || wiersz.PENSJA ||
                             ' Sr. dzialu: ' || ROUND(wiersz.SR_DZIAL, 2) ||
                             ' Sr. firmy: ' || ROUND(wiersz.SR_FIRMA, 2));
    END LOOP;
    CLOSE kursor;
END;
/

-- 2. Napisz procedurę PRO(JOBN IN VARCHAR, RDI OUT NUMBER) , która przez parametr wyjściowy RDI obliczy jaka
-- jest różnica między pensją minimalną a pensją maksymalną stanowiska podawanego jako parametr wejściowy. W przypadku
-- braku podania parametru wejściowego zrealizuj wyjątek, który będzie obsłużony w części EXCEPTION w postaci
-- odpowiedniego komunikatu. Podaj przykłady wyzwolenia procedury w blosku PL/SQL.

CREATE OR REPLACE PROCEDURE PRO (
    JOBN IN VARCHAR2,
    RDI OUT NUMBER
) IS
    brak_parametru EXCEPTION;
BEGIN
    IF JOBN IS NULL THEN
        RAISE brak_parametru;
    END IF;

    SELECT MAX(SAL) - MIN(SAL)
    INTO RDI
    FROM EMPZAL
    WHERE UPPER(JOB) = UPPER(JOBN);

EXCEPTION
    WHEN brak_parametru THEN
        DBMS_OUTPUT.PUT_LINE('Blad: Nie podano parametru wejsciowego');
        RDI := NULL;
END;
/

SET SERVEROUTPUT ON;

DECLARE
    roznica NUMBER;
BEGIN
    PRO('CLERK', roznica);
    DBMS_OUTPUT.PUT_LINE('Roznica dla CLERK: ' || roznica);

    PRO('SALESMAN', roznica);
    DBMS_OUTPUT.PUT_LINE('Roznica dla SALESMAN: ' || roznica);

    PRO(NULL, roznica);
END;
/


-- 3. Napisać funkcję WEEK_NO(data1 IN DATE) zwracającą liczbę tygodni (obciąć do pełnych tygodni), która
-- upłynęła między podaną datą w parametrze wejściowym a datą zegara systemowego. Podaj przykłady
-- wyzwolenia funkcji w bloku PL/SQL..

CREATE OR REPLACE FUNCTION WEEK_NO(
    data1 IN DATE
) RETURN NUMBER IS
    roznica NUMBER;
    tygodnie NUMBER;
BEGIN
    roznica := SYSDATE - data1;
    tygodnie := TRUNC(roznica / 7);
    RETURN tygodnie;
END;
/

SET SERVEROUTPUT ON;

DECLARE
    wynik NUMBER;
BEGIN
    wynik := WEEK_NO(TO_DATE('2024-01-01', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Liczba tygodni od 2024-01-01: ' || wynik);

    wynik := WEEK_NO(SYSDATE - 22);
    DBMS_OUTPUT.PUT_LINE('Liczba tygodni od 22 dni temu: ' || wynik);
END;
/

-- 4. Założyć tabelę EMP_HISTORY (z kolumnami: DEPTNO_OLD, DEPTNO_NEW, CHDATE). Opracować wyzwalacz wierszowy 
-- na tabeli DEPTZAL, który automatycznie zaktualizuje numer działu w tabeli EMP jeżeli  zmieni się on w tabeli
-- DEPTZAL. Dodatkowo wyzwalacz zarejestruje w tabeli EMP_HISTORY informację z jakiego numeru na jaki numer
-- zmieniono dział oraz kiedy to zostało zrobione.

CREATE TABLE EMP_HISTORY (
    DEPTNO_OLD NUMBER,
    DEPTNO_NEW NUMBER,
    CHDATE DATE
);

CREATE OR REPLACE TRIGGER ZMIANA_DZIALU_TRG
AFTER UPDATE OF DEPTNO ON DEPTZAL
FOR EACH ROW
BEGIN
    UPDATE EMPZAL
    SET DEPTNO = :NEW.DEPTNO
    WHERE DEPTNO = :OLD.DEPTNO;

    INSERT INTO EMP_HISTORY (DEPTNO_OLD, DEPTNO_NEW, CHDATE)
    VALUES (:OLD.DEPTNO, :NEW.DEPTNO, SYSDATE);
END;
/

UPDATE DEPTZAL SET DEPTNO = 60 WHERE DEPTNO = 10;

SELECT * FROM EMP_HISTORY;
SELECT ENAME, DEPTNO FROM EMPZAL WHERE DEPTNO = 60;

-- 5. Zdefiniować strukturę dwóch tabel łącznie z ograniczeniami PK, FK i ewentualnie CHECK, które dla danych
-- drużyn pokażą datę i wynik rozgrywki. Pamiętajmy iż drużyna nie może zagrać sama z sobą. Na podstawie
-- danej struktury (wypełnić przykładowymi danymi) definiujemy zapytanie które zwróci informację o wielu
-- meczach postaci (np. 'Drużyna_1 : Drużyna_2', 'Wynik 1:4', 'Data rozgrywki 27-11-2024')

CREATE TABLE DRUZYNY (
    ID_DRUZYNY NUMBER PRIMARY KEY,
    NAZWA VARCHAR2(50)
);

CREATE TABLE ROZGRYWKI (
    ID_MECZU NUMBER PRIMARY KEY,
    ID_GOSPODARZ NUMBER REFERENCES DRUZYNY(ID_DRUZYNY),
    ID_GOSC NUMBER REFERENCES DRUZYNY(ID_DRUZYNY),
    GOLE_GOSPODARZ NUMBER,
    GOLE_GOSC NUMBER,
    DATA_GRY DATE,
    CONSTRAINT CHK_ROZNE_DRUZYNY CHECK (ID_GOSPODARZ <> ID_GOSC)
);

INSERT INTO DRUZYNY (ID_DRUZYNY, NAZWA) VALUES (1, 'Legia Warszawa');
INSERT INTO DRUZYNY (ID_DRUZYNY, NAZWA) VALUES (2, 'Lech Poznań');
INSERT INTO DRUZYNY (ID_DRUZYNY, NAZWA) VALUES (3, 'Raków Częstochowa');

INSERT INTO ROZGRYWKI VALUES (1, 1, 2, 2, 1, TO_DATE('2024-11-27', 'YYYY-MM-DD'));
INSERT INTO ROZGRYWKI VALUES (2, 2, 3, 0, 0, TO_DATE('2024-12-01', 'YYYY-MM-DD'));
INSERT INTO ROZGRYWKI VALUES (3, 3, 1, 1, 3, TO_DATE('2024-12-05', 'YYYY-MM-DD'));

SELECT
    D1.NAZWA || ' : ' || D2.NAZWA AS ZESPOLY,
    'Wynik ' || R.GOLE_GOSPODARZ || ':' || R.GOLE_GOSC AS WYNIK,
    'Data rozgrywki ' || TO_CHAR(R.DATA_GRY, 'DD-MM-YYYY') AS DATA
FROM ROZGRYWKI R
JOIN DRUZYNY D1 ON R.ID_GOSPODARZ = D1.ID_DRUZYNY
JOIN DRUZYNY D2 ON R.ID_GOSC = D2.ID_DRUZYNY;
ORDER BY m.match_date;



