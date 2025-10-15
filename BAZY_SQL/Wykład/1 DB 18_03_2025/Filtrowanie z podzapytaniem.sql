/*SELECT Nazwa, Nazwisko, Wzrost, SrD
FROM Dzialy JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu
JOIN
(SELECT IdDzialu, AVG(Wzrost) AS SrD
FROM  Osoby
GROUP BY IdDzialu) AS xxx
ON Dzialy.IdDzialu=xxx.IdDzialu
WHERE Wzrost >SrD
ORDER BY Nazwa*/

SELECT Nazwa, Nazwisko, AVG(Brutto) AS SrPrac, SrDzial,
(SELECT AVG(Brutto) FROM Zarobki) AS SrFirma
FROM Dzialy JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu
JOIN Zarobki
ON Osoby.IdOsoby=Zarobki.IdOsoby
JOIN
(
SELECT IdDzialu, AVG(Brutto) AS SrDzial
FROM Osoby JOIN Zarobki
ON Osoby.IdOsoby=Zarobki.IdOsoby
GROUP BY IdDzialu
) AS xxx
ON Dzialy.IdDzialu=xxx.IdDzialu
GROUP BY Nazwa, Nazwisko, SrDzial
HAVING AVG(Brutto) > SrDzial








