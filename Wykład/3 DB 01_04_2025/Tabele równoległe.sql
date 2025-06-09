/*SELECT Nazwisko, SUM(Brutto) AS Razem
FROM Osoby JOIN Zarobki
ON Osoby.IdOsoby=Zarobki.IdOsoby
GROUP BY Nazwisko

SELECT Nazwisko, COUNT(IdNagrody) AS Ile
FROM Osoby JOIN Nagrody
ON Osoby.IdOsoby=Nagrody.IdOsoby
GROUP BY Nazwisko*/

/*--Z³e rozwi¹zanie
SELECT Nazwisko, SUM(Brutto) AS Razem, COUNT(IdNagrody) AS Ile
FROM Osoby JOIN Zarobki
ON Osoby.IdOsoby=Zarobki.IdOsoby
JOIN Nagrody
ON Osoby.IdOsoby=Nagrody.IdOsoby
GROUP BY Nazwisko*/

/*SELECT Nazwisko, SUM(Brutto) AS Razem, Ile
FROM Osoby JOIN Zarobki
ON Osoby.IdOsoby=Zarobki.IdOsoby
JOIN 
(SELECT IdOsoby, COUNT(IdNagrody) AS Ile
FROM Nagrody GROUP BY IdOsoby
) AS LIczbaNagrod
ON Osoby.IdOsoby=LIczbaNagrod.IdOsoby
GROUP BY Nazwisko, Ile*/

/*SELECT Nazwisko,  Razem, Ile
FROM Osoby JOIN
(SELECT IdOsoby, SUM(Brutto) AS Razem
FROM Zarobki GROUP BY IdOsoby
) AS SumaWyplat
ON Osoby.IdOsoby=SumaWyplat.IdOsoby
JOIN 
(SELECT IdOsoby, COUNT(IdNagrody) AS Ile
FROM Nagrody GROUP BY IdOsoby
) AS LIczbaNagrod
ON Osoby.IdOsoby=LIczbaNagrod.IdOsoby*/

WITH 
SumaWyplat AS
(SELECT IdOsoby, SUM(Brutto) AS Razem
FROM Zarobki GROUP BY IdOsoby
),
LIczbaNagrod AS
(SELECT IdOsoby, COUNT(IdNagrody) AS Ile
FROM Nagrody GROUP BY IdOsoby
)
SELECT Nazwisko,  Razem, Ile
FROM Osoby JOIN SumaWyplat
ON Osoby.IdOsoby=SumaWyplat.IdOsoby
JOIN LIczbaNagrod
ON Osoby.IdOsoby=LIczbaNagrod.IdOsoby