-- Pytanie 1
SELECT ename, sal,
CASE
    WHEN sal < 1000 THEN 'Niska pensja'
    WHEN sal BETWEEN 1000 AND 2000 THEN 'Średnia pensja'
    WHEN sal > 2000 THEN 'Wysoka pensja'
    ELSE 'brak wartości'
END AS kategoria_pensji
FROM emp
ORDER BY sal;

-- Pytanie 2
SELECT ename, sal, NVL(comm, 0) AS dodatek_nvl
FROM emp;

SELECT ename, sal, NVL2(comm, comm, 0) AS dodatek_nvl2
FROM emp;

SELECT ename, sal, COALESCE(comm, 0) AS dodatek_coalesce
FROM emp;

SELECT ename, sal, DECODE(comm, NULL, 0, comm) AS dodatek_decode
FROM emp;

SELECT ename, sal,
  CASE WHEN comm IS NULL THEN 0 ELSE comm END AS dodatek_case
FROM emp;

-- Pytanie 3
SELECT ename, comm
FROM emp
ORDER BY comm NULLS FIRST;

SELECT ename, comm
FROM emp
ORDER BY comm NULLS LAST;

-- Pytanie 4
SELECT
    USER AS nazwa_uzytkownika,
    UID AS id_uzytkownika
FROM dual;

SELECT TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS') AS aktualna_data
FROM dual;

-- Pytanie 5
SELECT TO_DATE('01-30-2017', 'MM-DD-YYYY') AS data_z_tekstu
FROM dual;

-- Pytanie 6
SELECT
    MIN(hiredate) AS pierwsze_zatrudnienie,
    MAX(hiredate) AS ostatnie_zatrudnienie,
    TRUNC(MONTHS_BETWEEN(MAX(hiredate), MIN(hiredate))) AS pelne_miesiace
FROM emp;

-- Pytanie 7
SELECT
SYSDATE AS dzisiaj,
LAST_DAY(SYSDATE) AS ostatni_dzien_miesiaca
FROM dual;

-- Pytanie 8
SELECT
    TO_CHAR(LAST_DAY(TO_DATE('2020-02-01', 'YYYY-MM-DD')), 'DD') AS dni_w_lutym_2020
FROM dual;

-- Pytanie 9
SELECT
    SYSDATE AS dzisiaj,
    ADD_MONTHS(SYSDATE, 50) AS data_plus_50_miesiecy,
    TRUNC(ADD_MONTHS(SYSDATE, 50), 'YYYY') AS zaokraglona_do_roku
FROM dual;

-- Pytanie 10
ALTER SESSION SET NLS_LANGUAGE = 'POLISH';

SELECT
  TO_CHAR(TO_DATE('31-12-' || TO_CHAR(SYSDATE, 'YYYY'), 'DD-MM-YYYY'), 'DAY') AS dzien_sylwestra
FROM dual;

-- Pytanie 11
SELECT
    SYSDATE AS dzisiaj,
    ADD_MONTHS(SYSDATE, 3) AS data_plus_3_miesiace
FROM dual;

-- Pytanie 12
SELECT
    SYSDATE AS dzisiaj,
    SYSDATE + 3 - (1/24) AS data_zmieniona
FROM dual;

-- Pytanie 13
SELECT
    ROUND(AVG(sal), 2) AS srednia_round,
    TRUNC(AVG(sal), 2) AS srednia_trunc,
    TO_CHAR(AVG(sal), '9999.99') AS srednia_formatted,
    TO_CHAR(ROUND(AVG(sal), 2), 'FM9999.00') AS srednia_fm_format_round
FROM emp;

-- Pytanie 14
SELECT MIN(sal) AS min_sal_manager
FROM emp
WHERE job = 'MANAGER';

-- Pytanie 15
SELECT COUNT(*) AS liczba_pracownikow
FROM emp e JOIN dept d ON e.deptno = d.deptno
WHERE d.dname = 'ACCOUNTING';

-- Pytanie 16
SELECT
    TO_CHAR(hiredate, 'YYYY') AS rok,
    TO_CHAR(hiredate, 'MM') AS miesiac,
    COUNT(*) AS liczba_zatrudnien
FROM emp
GROUP BY ROLLUP(TO_CHAR(hiredate, 'YYYY'), TO_CHAR(hiredate, 'MM'))
ORDER BY rok, miesiac;

SELECT
    TO_CHAR(hiredate, 'YYYY') AS rok,
    TO_CHAR(hiredate, 'MM') AS miesiac,
    COUNT(*) AS liczba_zatrudnien
FROM emp
GROUP BY CUBE(TO_CHAR(hiredate, 'YYYY'), TO_CHAR(hiredate, 'MM'))
ORDER BY rok, miesiac;

SELECT job FROM emp WHERE deptno = 10
UNION
SELECT job FROM emp WHERE deptno = 20;

SELECT job FROM emp WHERE deptno = 10
UNION ALL
SELECT job FROM emp WHERE deptno = 20;

SELECT job FROM emp WHERE deptno = 10
INTERSECT
SELECT job FROM emp WHERE deptno = 20;

SELECT job FROM emp WHERE deptno = 10
MINUS
SELECT job FROM emp WHERE deptno = 20;

-- Pytanie 17
SELECT
    TO_CHAR(hiredate, 'YYYY') AS rok,
    COUNT(DECODE(TO_CHAR(hiredate, 'MM'), '01', 1)) AS STY,
    COUNT(DECODE(TO_CHAR(hiredate, 'MM'), '02', 1)) AS LUT,
    COUNT(DECODE(TO_CHAR(hiredate, 'MM'), '03', 1)) AS MAR,
    COUNT(DECODE(TO_CHAR(hiredate, 'MM'), '04', 1)) AS KWI,
    COUNT(DECODE(TO_CHAR(hiredate, 'MM'), '05', 1)) AS MAJ,
    COUNT(DECODE(TO_CHAR(hiredate, 'MM'), '06', 1)) AS CZE,
    COUNT(DECODE(TO_CHAR(hiredate, 'MM'), '07', 1)) AS LIP,
    COUNT(DECODE(TO_CHAR(hiredate, 'MM'), '08', 1)) AS SIE,
    COUNT(DECODE(TO_CHAR(hiredate, 'MM'), '09', 1)) AS WRZ,
    COUNT(DECODE(TO_CHAR(hiredate, 'MM'), '10', 1)) AS PAZ,
    COUNT(DECODE(TO_CHAR(hiredate, 'MM'), '11', 1)) AS LIS,
    COUNT(DECODE(TO_CHAR(hiredate, 'MM'), '12', 1)) AS GRU
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY')
ORDER BY rok;

-- Pytanie 18
SELECT
    dname,
    ROUND(AVG(sal), 2) AS srednia_pensja
FROM emp
  NATURAL JOIN dept
GROUP BY dname;

-- Pytanie 19
SELECT
    job,
    MAX(sal) AS max_sal
FROM emp
WHERE job != 'CLERK'
GROUP BY job
ORDER BY max_sal DESC;

-- Pytanie 20
SELECT
    d.dname,
    e.job,
    MIN(e.sal) AS min_sal
FROM emp e
  JOIN dept d ON e.deptno = d.deptno
GROUP BY d.dname, e.job
ORDER BY d.dname, e.job;

-- Pytanie 21
SELECT
    d.dname,
    ROUND(AVG(e.sal), 2) AS srednia_pensja
FROM emp e JOIN dept d ON e.deptno = d.deptno
GROUP BY d.dname
ORDER BY srednia_pensja DESC;

-- Pytanie 22
SELECT
    job,
    ROUND(AVG(sal), 2) AS srednia,
    MAX(sal) AS maksymalna
FROM emp
GROUP BY job
HAVING MAX(sal) > 2000
ORDER BY srednia DESC;

-- Pytanie 23
SELECT
    d.dname,
    MIN(e.sal) AS min_pensja,
    MAX(e.sal) AS max_pensja,
    MAX(e.sal) - MIN(e.sal) AS roznica_pensji
FROM emp e
  JOIN dept d ON e.deptno = d.deptno
GROUP BY d.dname
ORDER BY roznica_pensji DESC;

-- Pytanie 24
SELECT
    e.ename AS pracownik,
    e.sal AS pensja_pracownika,
    m.ename AS kierownik,
    m.sal AS pensja_kierownika,
    m.sal - e.sal AS roznica
FROM emp e
  JOIN emp m ON e.mgr = m.empno
WHERE e.sal < m.sal
ORDER BY roznica DESC;

-- Pytanie 25
SELECT *
FROM (
    SELECT ename, sal, job
    FROM emp
    ORDER BY sal DESC
)
WHERE ROWNUM <= 3;

-- Pytanie 26
SELECT
    ename,
    sal,
    (SELECT MAX(sal) FROM emp) AS Salary_max
FROM emp;

-- Pytanie 27
SELECT ename, job, sal
FROM emp
WHERE sal > (SELECT AVG(sal) FROM emp)
ORDER BY sal DESC;

-- Pytanie 28
SELECT ename, job
FROM emp
WHERE job = (SELECT job FROM emp WHERE ename = 'SMITH')
    AND ename != 'SMITH'
ORDER BY ename;

-- Pytanie 29
ALTER SESSION SET NLS_SORT = Polish;

SELECT ename
FROM emp
ORDER BY ename;

-- Pytanie 30
INSERT INTO emp (empno, ename, deptno, sal, hiredate)
VALUES (101, 'Łukasiński', 10, 2850, TO_DATE('01-30-2014', 'MM-DD-YY'));
COMMIT;

SELECT e.ename, e.sal, e.deptno
FROM emp e
WHERE e.sal IN (
    SELECT MAX(sal)
    FROM emp
    GROUP BY deptno
)
ORDER BY e.deptno;

SELECT e.ename, e.sal, e.deptno
FROM emp e
WHERE e.sal = (
    SELECT MAX(sal)
    FROM emp e2
    WHERE e2.deptno = e.deptno
)
ORDER BY e.deptno;

-- Pytanie 31
SELECT ename, sal, deptno
FROM emp
WHERE sal > ANY (SELECT sal FROM emp WHERE deptno = 10)
ORDER BY sal;

-- Pytanie 32
SELECT ename, sal, deptno
FROM emp
WHERE sal > ALL (SELECT sal FROM emp WHERE deptno = 30)
ORDER BY sal;

-- Pytanie 33
SELECT
    job,
    ROUND(AVG(sal), 2) AS srednia
FROM emp
GROUP BY job
HAVING AVG(sal) > (
    SELECT AVG(sal)
    FROM emp
    WHERE job = 'MANAGER'
)
ORDER BY srednia DESC;

-- Pytanie 34
SELECT
    job,
    ROUND(AVG(sal), 2) AS srednia
FROM emp
GROUP BY job
HAVING AVG(sal) = (
    SELECT MIN(AVG(sal))
    FROM emp
    GROUP BY job
);

-- Pytanie 35
SELECT
    e.ename,
    e.job,
    e.sal,
    (SELECT ROUND(AVG(sal), 2) FROM emp e2 WHERE e2.job = e.job) AS srednia_w_zawodzie
FROM emp e
WHERE e.sal < (
    SELECT AVG(sal)
    FROM emp e2
    WHERE e2.job = e.job
    )
ORDER BY e.job, e.sal;

-- Pytanie 36
SELECT
    m.ename AS manager,
    m.job,
    m.empno
FROM emp m
WHERE EXISTS (
    SELECT 1
    FROM emp e
    WHERE e.mgr = m.empno
)
ORDER BY m.ename;

-- Pytanie 37
SELECT d.dname, d.deptno
FROM dept d
WHERE NOT EXISTS (
    SELECT 1
    FROM emp e
    WHERE e.deptno = d.deptno
);

SELECT d.dname, d.deptno
FROM dept d
    LEFT JOIN emp e ON d.deptno = e.deptno
WHERE e.empno IS NULL;

SELECT dname, deptno
FROM dept
WHERE deptno NOT IN (
    SELECT DISTINCT deptno
    FROM emp
    WHERE deptno IS NOT NULL
);