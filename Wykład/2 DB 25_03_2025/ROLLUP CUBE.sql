/*SELECT Nazwa, Nazwisko, SUM(Brutto) AS Razem
FROM Dzialy JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu
JOIN Zarobki
ON Osoby.IdOsoby=Zarobki.IdOsoby
GROUP BY Nazwa, Nazwisko WITH CUBE
--ROLLUP
ORDER BY Nazwa, Nazwisko*/

SELECT Nazwa, Nazwisko, SUM(Brutto) AS Razem
FROM Dzialy JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu
JOIN Zarobki
ON Osoby.IdOsoby=Zarobki.IdOsoby
GROUP BY GROUPING SETS
--CUBE
--ROLLUP 
(Nazwa, Nazwisko)
ORDER BY Nazwa, Nazwisko