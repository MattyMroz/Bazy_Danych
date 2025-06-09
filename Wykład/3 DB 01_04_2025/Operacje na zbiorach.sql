/*SELECT Nazwisko, Imie, RokUrodz
FROM Osoby
UNION
SELECT Nazwisko, Imie, RokUrodz
FROM ttt*/

/*SELECT Nazwisko, Imie AS FirstName
FROM Osoby
UNION
SELECT Nazwisko, CAST(RokUrodz AS varchar(4)) Rok
FROM ttt*/

/*SELECT Nazwisko, Imie, RokUrodz
FROM Osoby
UNION ALL
SELECT Nazwisko, Imie, RokUrodz
FROM ttt*/

SELECT Nazwisko, Imie, RokUrodz
FROM Osoby
INTERSECT
SELECT Nazwisko, Imie, RokUrodz
FROM ttt

SELECT Nazwisko, Imie, RokUrodz
FROM Osoby
EXCEPT
SELECT Nazwisko, Imie, RokUrodz
FROM ttt

SELECT Nazwisko, Imie, RokUrodz
FROM ttt
EXCEPT
SELECT Nazwisko, Imie, RokUrodz
FROM Osoby