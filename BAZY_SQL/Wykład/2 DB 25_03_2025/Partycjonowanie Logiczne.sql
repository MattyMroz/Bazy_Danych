/*SELECT Nazwa, Nazwisko, Wzrost,
--ROW_NUMBER() OVER(ORDER BY Wzrost) AS nr1,
ROW_NUMBER() OVER(PARTITION BY Nazwa ORDER BY Wzrost DESC) AS nr2,
RANK() OVER(PARTITION BY Nazwa ORDER BY Wzrost DESC) AS nr3,
DENSE_RANK () OVER(PARTITION BY Nazwa ORDER BY Wzrost DESC) AS nr4,
--PERCENT_RANK () OVER(PARTITION BY Nazwa ORDER BY Wzrost DESC) AS nr5,
--CUME_DIST() OVER(PARTITION BY Nazwa ORDER BY Wzrost DESC) AS nr6
NTILE(2) OVER(PARTITION BY Nazwa ORDER BY Wzrost DESC) AS nr7

FROM Dzialy JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu*/

/*SELECT Nazwa, Nazwisko, Brutto,
SUM(Brutto) OVER () AS RazemFirma,
SUM(Brutto) OVER (PARTITION BY Nazwa) AS RazemDzial,
--SUM(Brutto) OVER (PARTITION BY Nazwa, Nazwisko) AS RazemPracownik
SUM(Brutto) OVER (PARTITION BY Osoby.IdOsoby) AS RazemPracownik
FROM Dzialy JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu
JOIN Zarobki
ON Osoby.IdOsoby=Zarobki.IdOsoby*/

/*SELECT Nazwa, Nazwisko, Brutto,
SUM(Brutto) OVER (ORDER BY IdZarobku) AS SumaBiezacaFirma,
SUM(Brutto) OVER (PARTITION BY Nazwa ORDER BY IdZarobku) AS SumaBiezacaDzial
FROM Dzialy JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu
JOIN Zarobki
ON Osoby.IdOsoby=Zarobki.IdOsoby*/

SELECT Nazwa, Nazwisko, Brutto,
SUM(Brutto) OVER (PARTITION BY Nazwa ORDER BY IdZarobku
ROWS BETWEEN  1 PRECEDING AND 1 FOLLOWING
--ROWS BETWEEN  CURRENT ROW  AND UNBOUNDED FOLLOWING
--ROWS BETWEEN  UNBOUNDED PRECEDING AND CURRENT ROW
) AS SumaBiezacaDzial
FROM Dzialy JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu
JOIN Zarobki
ON Osoby.IdOsoby=Zarobki.IdOsoby
--ORDER BY Nazwa, IdZarobku DESC