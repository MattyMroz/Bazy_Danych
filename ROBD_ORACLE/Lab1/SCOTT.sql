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
