
-- ============================================================================
-- SEKCJA 2: ZAAWANSOWANE ZAPYTANIA (Pytania 1-37)
-- Poprawione treści zadań zgodnie z PDF
-- ============================================================================

-- ---------------------------------------------------------------------------
-- Pytanie 1: CASE dla kategoryzacji pensji
-- Wykorzystaj składnię CASE to określenia jak wysoką mamy pensję:
-- sal < 1000 to mamy wyświetlany napis 'Niska pensja'
-- sal between 1000 and 2000 to mamy wyświetlany napis 'Średnia pensja'
-- sal > 2000 to mamy wyświetlany napis 'Wysoka pensja' w innym przypadku mamy wyświetlany napis 'brak wartości'
-- ---------------------------------------------------------------------------
SELECT ename, sal,
CASE
    WHEN sal < 1000 THEN 'Niska pensja'
    WHEN sal BETWEEN 1000 AND 2000 THEN 'Średnia pensja'
    WHEN sal > 2000 THEN 'Wysoka pensja'
    ELSE 'brak wartości'
END AS kategoria_pensji
FROM emp
ORDER BY sal;

-- ---------------------------------------------------------------------------
-- Pytanie 2: Funkcje do obsługi NULL (COMM)
-- Wykorzystaj funkcję NVL, NVL2, COALESCE, DECODE do zamiany wartości NULL na
-- wartość 0 w przypadku wyświetlenia kolumny COMM w tabeli EMP.
-- Przykład z wykorzystaniem składni CASE ma postać: select ename ,sal, case when comm is null then 0 else comm end as Dodatek from emp;
-- ---------------------------------------------------------------------------

-- Wariant 1: NVL -> zamiana NULL na 0
SELECT ename, sal, NVL(comm, 0) AS dodatek_nvl
FROM emp;

-- Wariant 2: NVL2 -> jeśli nie NULL to COMM, jeśli NULL to 0
SELECT ename, sal, NVL2(comm, comm, 0) AS dodatek_nvl2
FROM emp;

-- Wariant 3: COALESCE -> zwraca pierwszy nie-NULL argument
SELECT ename, sal, COALESCE(comm, 0) AS dodatek_coalesce
FROM emp;

-- Wariant 4: DECODE -> porównuje wartość, jeśli NULL to 0, w przeciwnym razie COMM
SELECT ename, sal, DECODE(comm, NULL, 0, comm) AS dodatek_decode
FROM emp;

-- Wariant 5: CASE
SELECT ename, sal,
  CASE WHEN comm IS NULL THEN 0 ELSE comm END AS dodatek_case
FROM emp;


-- ---------------------------------------------------------------------------
-- Pytanie 3: Sortowanie z NULL na początku/końcu
-- Wyświetl wynik zapytania, gdzie wartości NULL będą na końcu lub początku zestawu wyników.
-- ---------------------------------------------------------------------------

-- NULL na początku
SELECT ename, comm
FROM emp
ORDER BY comm NULLS FIRST;

-- NULL na końcu (domyślnie dla ASC)
SELECT ename, comm
FROM emp
ORDER BY comm NULLS LAST;


-- ---------------------------------------------------------------------------
-- Pytanie 4: Informacje o użytkowniku i data
-- Podaj nazwę zalogowanego użytkownika oraz jego id (funkcja USER, UID).
-- Wyświetl aktualna datę w formacie np.: 01-04-2018 13:35:29
-- ---------------------------------------------------------------------------

-- Nazwa użytkownika i jego ID
SELECT
    USER AS nazwa_uzytkownika,
    UID AS id_uzytkownika
FROM dual;

-- Aktualna data w formacie DD-MM-YYYY HH24:MI:SS
SELECT TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS') AS aktualna_data
FROM dual;


-- dual to specjalna tabela w Oracle, która zawiera dokładnie jeden wiersz i jedną kolumnę. Jest często używana do wykonywania zapytań, które nie wymagają dostępu do żadnej konkretnej tabeli w bazie danych.


-- ---------------------------------------------------------------------------
-- Pytanie 5: Konwersja string na datę
-- Zamień ciąg znaków na format daty np. '01-30-2017' (do wykorzystania podczas wstawia danych
-- do pola typu Date)
-- ---------------------------------------------------------------------------

-- Zamiana ciągu znaków na format daty
SELECT TO_DATE('01-30-2017', 'MM-DD-YYYY') AS data_z_tekstu
FROM dual;

-- Użycie podczas INSERT (przykład)
-- INSERT INTO emp (empno, ename, hiredate)
-- VALUES (9999, 'TEST', TO_DATE('01-30-2017', 'MM-DD-YYYY'));


-- ---------------------------------------------------------------------------
-- Pytanie 6: Miesiące między pierwszym a ostatnim zatrudnieniem
-- Ile pełnych miesięcy upłynęło w okresie od pierwszej zatrudnionej osoby do ostatniej zatrudnionej osoby (MONTHS_BETWEEN) – podaj w pełnych miesiącach?
-- ---------------------------------------------------------------------------

-- Pełne miesiące między najwcześniejszym a najpóźniejszym zatrudnieniem
SELECT
    MIN(hiredate) AS pierwsze_zatrudnienie,
    MAX(hiredate) AS ostatnie_zatrudnienie,
    TRUNC(MONTHS_BETWEEN(MAX(hiredate), MIN(hiredate))) AS pelne_miesiace
FROM emp;


-- ---------------------------------------------------------------------------
-- Pytanie 7: Ostatni dzień miesiąca
-- Jaki jest data ostatniego dnia danego miesiąca
-- ---------------------------------------------------------------------------

-- Ostatni dzień bieżącego miesiąca
SELECT
SYSDATE AS dzisiaj,
LAST_DAY(SYSDATE) AS ostatni_dzien_miesiaca
FROM dual;


-- ---------------------------------------------------------------------------
-- Pytanie 8: Ile dni ma luty w 2020 roku?
-- Ile dni ma luty w 2020 roku?
-- ---------------------------------------------------------------------------

-- Liczba dni w lutym 2020 (rok przestępny = 29 dni)
SELECT
    TO_CHAR(LAST_DAY(TO_DATE('2020-02-01', 'YYYY-MM-DD')), 'DD') AS dni_w_lutym_2020
FROM dual;


-- ---------------------------------------------------------------------------
-- Pytanie 9: Zaokrąglenie daty
-- Zaokrąglij datę, która przypada za 50 miesięcy do pierwszego stycznia danego roku
-- ---------------------------------------------------------------------------

-- Dodanie 50 miesięcy i zaokrąglenie do najbliższego roku (pierwszy dzień roku)
SELECT
    SYSDATE AS dzisiaj,
    ADD_MONTHS(SYSDATE, 50) AS data_plus_50_miesiecy,
    TRUNC(ADD_MONTHS(SYSDATE, 50), 'YYYY') AS zaokraglona_do_roku
FROM dual;


-- ---------------------------------------------------------------------------
-- Pytanie 10: Dzień tygodnia Sylwestra (po polsku)
-- W jakim dniu tygodnia jest Sylwester tego roku (dzień tygodnia ma być w języku polskim)
-- wykorzystaj polecenie - alter session set nls_language
-- ---------------------------------------------------------------------------

-- Ustawienie języka polskiego dla sesji
ALTER SESSION SET NLS_LANGUAGE = 'POLISH';

-- Dzień tygodnia Sylwestra w bieżącym roku
SELECT
  TO_CHAR(TO_DATE('31-12-' || TO_CHAR(SYSDATE, 'YYYY'), 'DD-MM-YYYY'), 'DAY') AS dzien_sylwestra
FROM dual;

-- Przywrócenie języka angielskiego
-- ALTER SESSION SET NLS_LANGUAGE = 'AMERICAN';


-- ---------------------------------------------------------------------------
-- Pytanie 11: Dodaj 3 miesiące do bieżącej daty
-- Dodaj 3 miesiące do bieżącej daty
-- ---------------------------------------------------------------------------

-- Dodanie 3 miesięcy
SELECT
    SYSDATE AS dzisiaj,
    ADD_MONTHS(SYSDATE, 3) AS data_plus_3_miesiace
FROM dual;


-- ---------------------------------------------------------------------------
-- Pytanie 12: Dodaj 3 dni i odejmij 1 godzinę
-- Do aktualnej daty dodaj 3 dni i odejmij 1 godzinę.
-- ---------------------------------------------------------------------------

-- Operacje arytmetyczne na datach
SELECT
    SYSDATE AS dzisiaj,
    SYSDATE + 3 - (1/24) AS data_zmieniona
FROM dual;


-- ---------------------------------------------------------------------------
-- Pytanie 13: Średni zarobek z formatowaniem
-- Obliczyć średni zarobek w firmie (zaokrąglij ROUND oraz utnij TRUNC do dwóch miejsc po
-- przecinku). Wykorzystaj funkcję to_char do przedstawienia w postaci wartości znakowej, gdzie
-- mamy dwa miejsca po przecinku (czy działa zaokrąglanie)
-- ---------------------------------------------------------------------------

-- Średni zarobek: ROUND, TRUNC, TO_CHAR
SELECT
    ROUND(AVG(sal), 2) AS srednia_round,
    TRUNC(AVG(sal), 2) AS srednia_trunc,
    TO_CHAR(AVG(sal), '9999.99') AS srednia_formatted,
    TO_CHAR(ROUND(AVG(sal), 2), 'FM9999.00') AS srednia_fm_format_round
FROM emp;


-- ---------------------------------------------------------------------------
-- Pytanie 14: Minimalny zarobek MANAGER
-- Znaleźć minimalny zarobek na stanowisku 'MANAGER'.
-- ---------------------------------------------------------------------------

-- Minimalna pensja na stanowisku MANAGER
SELECT MIN(sal) AS min_sal_manager
FROM emp
WHERE job = 'MANAGER';


-- ---------------------------------------------------------------------------
-- Pytanie 15: Liczba pracowników w ACCOUNTING
-- Znaleźć, ilu pracowników pracuje w departamencie ACCOUNTING.
-- ---------------------------------------------------------------------------

-- Zliczanie pracowników w departamencie ACCOUNTING
SELECT COUNT(*) AS liczba_pracownikow
FROM emp e JOIN dept d ON e.deptno = d.deptno
WHERE d.dname = 'ACCOUNTING';


-- ---------------------------------------------------------------------------
-- Pytanie 16: Zatrudnienia wg roku i miesiąca (ROLLUP, CUBE, operatory zbiorów)
-- Znaleźć, ile pracowników zostało zatrudnionych, w każdym roku i miesiącu, w którym funkcjonowała firma
-- (wykorzystać operator ROLLUP i CUBE i za pomocą operatorów zbiorów UNION ALL, UNION,
-- INTERSECT, MINUS zobaczyć czym różnią się dane wyniki zapytań).
-- ---------------------------------------------------------------------------

-- Wariant A: ROLLUP - subtotale hierarchiczne
SELECT
    TO_CHAR(hiredate, 'YYYY') AS rok,
    TO_CHAR(hiredate, 'MM') AS miesiac,
    COUNT(*) AS liczba_zatrudnien
FROM emp
GROUP BY ROLLUP(TO_CHAR(hiredate, 'YYYY'), TO_CHAR(hiredate, 'MM'))
ORDER BY rok, miesiac;

-- Wariant B: CUBE - wszystkie możliwe kombinacje agregacji
SELECT
    TO_CHAR(hiredate, 'YYYY') AS rok,
    TO_CHAR(hiredate, 'MM') AS miesiac,
    COUNT(*) AS liczba_zatrudnien
FROM emp
GROUP BY CUBE(TO_CHAR(hiredate, 'YYYY'), TO_CHAR(hiredate, 'MM'))
ORDER BY rok, miesiac;

-- UNION vs UNION ALL vs INTERSECT vs MINUS (przykłady)
-- UNION - usuwa duplikaty
SELECT job FROM emp WHERE deptno = 10
UNION
SELECT job FROM emp WHERE deptno = 20;

-- UNION ALL - zachowuje duplikaty (szybsze)
SELECT job FROM emp WHERE deptno = 10
UNION ALL
SELECT job FROM emp WHERE deptno = 20;

-- INTERSECT - część wspólna
SELECT job FROM emp WHERE deptno = 10
INTERSECT
SELECT job FROM emp WHERE deptno = 20;

-- MINUS - różnica zbiorów (w 10 ale nie w 20)
SELECT job FROM emp WHERE deptno = 10
MINUS
SELECT job FROM emp WHERE deptno = 20;


-- ---------------------------------------------------------------------------
-- Pytanie 17: Pivot zatrudnień (lata vs miesiące) - DECODE
-- Znaleźć, ile pracowników zostało zatrudnionych, w każdym roku i miesiącu, w którym funkcjonowała
-- firma. Z tym że poziomo podajemy kolejne miesiące, a pionowo w pierwszej kolumnie lata (DECODE).
-- ---------------------------------------------------------------------------

-- Pivot danych: lata w wierszach, miesiące w kolumnach (DECODE)
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

-- ---------------------------------------------------------------------------
-- Pytanie 18: Średnie zarobki wg departamentu (NATURAL JOIN)
-- Obliczyć średnie zarobki w każdym departamencie (podajemy pełną nazwę departamentu)
-- wykorzystaj NATURAL JOIN.
-- ---------------------------------------------------------------------------

-- NATURAL JOIN
SELECT
    dname, -- kolumna deptno jest automatycznie użyta do łączenia
    ROUND(AVG(sal), 2) AS srednia_pensja
FROM emp
  NATURAL JOIN dept
GROUP BY dname;


-- ---------------------------------------------------------------------------
-- Pytanie 19: Maksymalne zarobki wg stanowiska (bez CLERK)
-- Wybierz stanowiska pracy i maksymalne zarobki na tych stanowiskach (bez stanowiska CLERK).
-- ---------------------------------------------------------------------------

-- Max zarobki na stanowiskach, wykluczając CLERK
SELECT
    job,
    MAX(sal) AS max_sal
FROM emp
WHERE job != 'CLERK'
GROUP BY job
ORDER BY max_sal DESC;


-- ---------------------------------------------------------------------------
-- Pytanie 20: Minimalne pensje wg departamentu i stanowiska
-- Obliczyć minimalne pensje w każdym departamencie w podziałem na stanowiska.
-- ---------------------------------------------------------------------------

-- Min pensje w podziale na departament i stanowisko
SELECT
    d.dname,
    e.job,
    MIN(e.sal) AS min_sal
FROM emp e
  JOIN dept d ON e.deptno = d.deptno
GROUP BY d.dname, e.job
ORDER BY d.dname, e.job;


-- ---------------------------------------------------------------------------
-- Pytanie 21: Średnie zarobki wg departamentu
-- Obliczyć średnie zarobki w każdym departamencie.
-- ---------------------------------------------------------------------------

-- Średnie zarobki w każdym departamencie
SELECT
    d.dname,
    ROUND(AVG(e.sal), 2) AS srednia_pensja
FROM emp e JOIN dept d ON e.deptno = d.deptno
GROUP BY d.dname
ORDER BY srednia_pensja DESC;


-- ---------------------------------------------------------------------------
-- Pytanie 22: Średnie zarobki dla grup zawodowych (max > 2000)
-- Wybrać średnie zarobki dla grup zawodowych, gdzie maksymalne zarobki są wyższe niż 2000.
-- ---------------------------------------------------------------------------

-- Grupy zawodowe z maksymalną pensją > 2000
SELECT
    job,
    ROUND(AVG(sal), 2) AS srednia,
    MAX(sal) AS maksymalna
FROM emp
GROUP BY job
HAVING MAX(sal) > 2000
ORDER BY srednia DESC;


-- ---------------------------------------------------------------------------
-- Pytanie 23: Różnica między najwyższą i najniższą pensją (wg dept)
-- Znajdź różnice między najwyższą i najniższą pensją, w każdym z departamentów.
-- ---------------------------------------------------------------------------

-- Rozpiętość pensji w każdym departamencie
SELECT
    d.dname,
    MIN(e.sal) AS min_pensja,
    MAX(e.sal) AS max_pensja,
    MAX(e.sal) - MIN(e.sal) AS roznica_pensji
FROM emp e
  JOIN dept d ON e.deptno = d.deptno
GROUP BY d.dname
ORDER BY roznica_pensji DESC;


-- ---------------------------------------------------------------------------
-- Pytanie 24: Pracownicy zarabiający mniej od kierownika
-- Wybrać pracowników, którzy zarabiają mniej od swoich kierowników.
-- ---------------------------------------------------------------------------

-- Self-join: porównanie pensji pracownik vs jego manager
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


-- ---------------------------------------------------------------------------
-- Pytanie 25: Podzapytania w FROM (inline view)
-- Podzapytania w klauzuli FROM select * from (select * from emp order by sal desc) where rownum <=3
-- ---------------------------------------------------------------------------

-- Top 3 najlepiej zarabiających pracowników
SELECT *
FROM (
    SELECT ename, sal, job
    FROM emp
    ORDER BY sal DESC
)
WHERE ROWNUM <= 3;


-- ---------------------------------------------------------------------------
-- Pytanie 26: Podzapytania w SELECT (scalar subquery)
-- Podzapytania w klauzuli SELECT select ename, sal, (select max(sal) from emp) as Salary_max from emp;
-- ---------------------------------------------------------------------------

-- Wyświetlenie pensji pracownika wraz z maksymalną pensją w firmie
SELECT
    ename,
    sal,
    (SELECT MAX(sal) FROM emp) AS Salary_max
FROM emp;


-- ---------------------------------------------------------------------------
-- Pytanie 27: Pracownicy zarabiający powyżej średniej
-- Znaleźć pracowników, których pensja jest wyższa niż obliczona pensja średnia.
-- ---------------------------------------------------------------------------

-- Podzapytanie nieskorelowane: średnia liczona raz dla całej tabeli
SELECT ename, job, sal
FROM emp
WHERE sal > (SELECT AVG(sal) FROM emp)
ORDER BY sal DESC;


-- ---------------------------------------------------------------------------
-- Pytanie 28: Wszyscy zatrudnieni na tym samym stanowisku co SMITH
-- Znaleźć wszystkich zatrudnionych na tym samym stanowisku co SMITH.
-- ---------------------------------------------------------------------------

-- Podzapytanie zwracające pojedynczą wartość (job SMITHA)
SELECT ename, job
FROM emp
WHERE job = (SELECT job FROM emp WHERE ename = 'SMITH')
    AND ename != 'SMITH' -- Wykluczenie samego SMITHA (choć nie jest to wprost w treści, jest to standardowa praktyka)
ORDER BY ename;


-- ---------------------------------------------------------------------------
-- Pytanie 29: Sortowanie względem języka polskiego
-- Jak sortować względem języka polskiego. - - ALTER SESSION SET NLS_SORT = Polish;
-- ---------------------------------------------------------------------------

-- Ustawienie sortowania dla języka polskiego (ąćęłńóśźż)
ALTER SESSION SET NLS_SORT = Polish;

-- Przykład sortowania
SELECT ename
FROM emp
ORDER BY ename;

-- Przywrócenie domyślnego sortowania
-- ALTER SESSION SET NLS_SORT = BINARY;


-- ---------------------------------------------------------------------------
-- Pytanie 30: Pracownicy z najwyższymi zarobkami w departamentach
-- Znaleźć pracowników, których pensja jest na liście najwyższych zarobków w
-- departamentach (wykonaj jako zapytanie z podzapytaniem nieskorelowane i
-- skorelowane). Wykonaj przed napisaniem zapytania polecenie:
-- INSERT INTO EMP (empno, ename, deptno, sal, hiredate) VALUES (101,'Łukasiński',10, 2850, to_date('01-30-2014','mm-dd-yy')); COMMIT;
-- ---------------------------------------------------------------------------

-- Przygotowanie danych (INSERT z polskimi znakami)
INSERT INTO emp (empno, ename, deptno, sal, hiredate)
VALUES (101, 'Łukasiński', 10, 2850, TO_DATE('01-30-2014', 'MM-DD-YY'));
COMMIT;

-- Wariant A: Podzapytanie nieskorelowane z IN
SELECT e.ename, e.sal, e.deptno
FROM emp e
WHERE e.sal IN (
    SELECT MAX(sal)
    FROM emp
    GROUP BY deptno
)
ORDER BY e.deptno;

-- Wariant B: Podzapytanie skorelowane
SELECT e.ename, e.sal, e.deptno
FROM emp e
WHERE e.sal = (
    SELECT MAX(sal)
    FROM emp e2
    WHERE e2.deptno = e.deptno
)
ORDER BY e.deptno;


-- ---------------------------------------------------------------------------
-- Pytanie 31: Operator ANY/SOME (pensja > niż przynajmniej jedna w dept 10)
-- Wyświetl tych pracowników, których pensja jest większa od pensji przynajmniej jednej osoby z
-- departamentu o numerze 10 (operator ANY/SOME)
-- ---------------------------------------------------------------------------

-- ANY: warunek spełniony jeśli TRUE dla przynajmniej jednego elementu
SELECT ename, sal, deptno
FROM emp
WHERE sal > ANY (SELECT sal FROM emp WHERE deptno = 10)
ORDER BY sal;

-- Równoważne zapytanie (z MIN)
SELECT ename, sal, deptno
FROM emp
WHERE sal > (SELECT MIN(sal) FROM emp WHERE deptno = 10)
ORDER BY sal;


-- ---------------------------------------------------------------------------
-- Pytanie 32: Operator ALL (pensja > niż wszystkie w dept 30)
-- Wybierzmy wszystkich pracowników, którzy zarabiają więcej niż ktokolwiek w departamencie
-- 30. (operator ALL)
-- ---------------------------------------------------------------------------

-- ALL: warunek musi być TRUE dla wszystkich elementów
SELECT ename, sal, deptno
FROM emp
WHERE sal > ALL (SELECT sal FROM emp WHERE deptno = 30)
ORDER BY sal;

-- Równoważne zapytanie (z MAX)
SELECT ename, sal, deptno
FROM emp
WHERE sal > (SELECT MAX(sal) FROM emp WHERE deptno = 30)
ORDER BY sal;


-- ---------------------------------------------------------------------------
-- Pytanie 33: Stanowiska gdzie średnia > średniej MANAGER
-- Wybrać zawody, w których średnia płaca jest wyższa niż średnia płaca w zawodzie 'MANAGER'
-- ---------------------------------------------------------------------------

-- Zawody z wyższą średnią pensją niż MANAGER
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


-- ---------------------------------------------------------------------------
-- Pytanie 34: Stanowisko z najniższą średnią pensją
-- Wybrać stanowisko, na którym są najniższe średnie zarobki.
-- ---------------------------------------------------------------------------

-- Stanowisko o najniższej średniej (podzapytanie w HAVING)
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


-- ---------------------------------------------------------------------------
-- Pytanie 35: Zarabiający mniej niż średnia w zawodzie (skorelowane)
-- Znaleźć osoby, które zarabiają mniej niż wynosi średnia w ich zawodach:
-- ---------------------------------------------------------------------------

-- Podzapytanie skorelowane: średnia liczona osobno dla każdego zawodu
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


-- ---------------------------------------------------------------------------
-- Pytanie 36: Operator EXISTS - pracownicy z podwładnymi (managerowie)
-- Za pomocą operatora EXIST znaleźć pracowników, którzy mają podwładnych:
-- ---------------------------------------------------------------------------

-- EXISTS: sprawdza czy podzapytanie zwraca jakiekolwiek wiersze
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


-- ---------------------------------------------------------------------------
-- Pytanie 37: Departament bez pracowników
-- Znaleźć departament, w którym nikt nie pracuje (wykorzystaj EXISTS, JOIN i klauzulę IN).
-- ---------------------------------------------------------------------------

-- Wariant A: NOT EXISTS (zalecane)
SELECT d.dname, d.deptno
FROM dept d
WHERE NOT EXISTS (
    SELECT 1
    FROM emp e
    WHERE e.deptno = d.deptno
);

-- Wariant B: LEFT JOIN z NULL check
SELECT d.dname, d.deptno
FROM dept d
    IN emp e ON d.deptno = e.deptno
WHERE e.empno IS NULL;

-- Wariant C: NOT IN (uwaga na NULL values!)
SELECT dname, deptno
FROM dept
WHERE deptno NOT IN (
    SELECT DISTINCT deptno
    FROM emp
    WHERE deptno IS NOT NULL -- Ważne, aby wykluczyć NULL z podzapytania
);


-- ============================================================================
-- KONIEC PLIKU
-- ============================================================================