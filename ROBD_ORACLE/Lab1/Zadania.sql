Zadania do realizacji:

1. Wyświetlić nazwiska pracowników oraz ich zawód:

2. Wyświetlić pierwsze 3 rekordy z tabeli emp;

3.  Wyświetlić pierwsze uporządkowane po nazwisku 3 rekordy z tabeli emp;

4.  Wybierz z tabeli emp wszystkie wzajemnie różne kombinacje numeru departamentu i stanowiska pracy:

5.  Wybierz nazwiska i pensje wszystkich pracowników których nazwiska zaczynają się na literę S i s oraz trzecią literę i

6.  Wybierz nazwiska i wartości zarobków wszystkich pracowników łącznie z obliczeniem prowizji od początku roku (POLE COMM)

7. Podaj datę zegara systemowego

8. Do daty zegara systemowego dodaj 3 dni

9. Do daty zegara systemowego dodaj 3 godziny

10. Ile dni upłynęło od Twoich narodzin?

11. Ile dni pozostało do Twoich urodzin?


-- ============================================================================
-- SEKCJA 1: PODSTAWOWE ZAPYTANIA (Zadania 1-11)
-- ============================================================================

-- Zadanie 1: Wyświetlić nazwiska pracowników oraz ich zawód
SELECT ename, job
FROM emp;

-- Zadanie 2: Wyświetlić pierwsze 3 rekordy z tabeli emp
SELECT *
FROM emp
WHERE ROWNUM <= 3;

-- Zadanie 3: Wyświetlić pierwsze uporządkowane po nazwisku 3 rekordy
SELECT *
FROM (
  SELECT *
  FROM emp
  ORDER BY ename
)
WHERE ROWNUM <= 3;

-- Zadanie 4: Wszystkie wzajemnie różne kombinacje numeru departamentu i stanowiska
SELECT DISTINCT deptno, job
FROM emp
ORDER BY deptno, job;

-- Zadanie 5: Nazwiska zaczynające się na S/s i trzecia litera 'i'
-- Wzorzec: S_I% (drugie pole dowolne, trzecie 'I')
SELECT ename, sal
FROM emp
WHERE ename LIKE 'S_I%';

-- Zadanie 6: Zarobki z prowizją od początku roku
-- Roczne zarobki = (pensja * 12) + (prowizja * 12)
SELECT
  ename,
  sal,
  comm,
  (sal * 12) AS pensja_roczna,
  (sal * 12 + NVL(comm, 0) * 12) AS zarobek_roczny_z_prowizja
FROM emp;

NVL - > funkcja zamieniająca NULL na podaną wartość (tutaj 0, jeśli brak prowizji)

-- Zadanie 7: Data zegara systemowego
SELECT SYSDATE AS data_systemowa
FROM dual;

-- Zadanie 8: Do daty systemowej dodaj 3 dni
SELECT SYSDATE + 3 AS data_plus_3_dni
FROM dual;

-- Zadanie 9: Do daty systemowej dodaj 3 godziny
-- 1 dzień = 24 godziny, więc 3 godziny = 3/24 dnia
SELECT SYSDATE + (3/24) AS data_plus_3_godziny
FROM dual;

-- Zadanie 10: Ile dni upłynęło od Twoich narodzin?
-- UWAGA: Podstaw swoją datę urodzenia w formacie 'YYYY-MM-DD'
SELECT TRUNC(SYSDATE - TO_DATE('2003-07-02', 'YYYY-MM-DD')) AS dni_od_urodzin
FROM dual;

TO_DATE - > funkcja konwertująca tekst na datę
TRUNC - > funkcja obcinająca część dziesiętną (godziny, minuty, sekundy) z daty

-- Zadanie 11: Ile dni pozostało do Twoich urodzin?
-- Obsługa przypadku: urodziny już były w tym roku vs jeszcze będą
SELECT
  CASE
    WHEN TO_DATE(TO_CHAR(SYSDATE, 'YYYY') || '-07-02', 'YYYY-MM-DD') >= SYSDATE
    THEN TO_DATE(TO_CHAR(SYSDATE, 'YYYY') || '-07-02', 'YYYY-MM-DD') - SYSDATE
    ELSE TO_DATE(TO_CHAR(SYSDATE + 365, 'YYYY') || '-07-02', 'YYYY-MM-DD') - SYSDATE
  END AS dni_do_urodzin
FROM dual;

CASE - > funkcja warunkowa (if-then-else)
TO_CHAR - > funkcja konwertująca datę na tekst

CASE PRZYKŁAD:

SELECT ename,
  CASE
    WHEN sal < 1000 THEN 'Niska'
    WHEN sal BETWEEN 1000 AND 3000 THEN 'Średnia'
    ELSE 'Wysoka'
  END AS kategoria_zarobkow
FROM emp;