/*SELECT Nazwisko, Wzrost,
(SELECT AVG(Wzrost) FROM Osoby) AS Sr
FROM Osoby
WHERE Wzrost>
(SELECT AVG(Wzrost) FROM Osoby)*/

/*SELECT Nazwisko, Wzrost,
(SELECT MAX(Wzrost) FROM Osoby) AS Maks
FROM Osoby
WHERE Wzrost=
(SELECT MAX(Wzrost) FROM Osoby)*/

/*SELECT Nazwisko, Brutto, (SELECT AVG(Brutto) FROM Zarobki) AS Sr
FROM Osoby RIGHT JOIN Zarobki
ON Osoby.IdOsoby= Zarobki.IdOsoby
WHERE Brutto>
(SELECT AVG(Brutto) FROM Zarobki)*/

SELECT Nazwisko, AVG(Brutto) AS SrPrac,
(SELECT AVG(Brutto) FROM Zarobki) AS SrFirma
FROM Osoby RIGHT JOIN Zarobki
ON Osoby.IdOsoby = Zarobki.IdOsoby
GROUP BY Nazwisko, Osoby.IdOsoby
HAVING AVG(Brutto)>
(SELECT AVG(Brutto) FROM Zarobki)