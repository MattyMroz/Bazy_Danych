/*SELECT Nazwa, Nazwisko, Wzrost,
(SELECT AVG(Wzrost) FROM Osoby) AS Sr
FROM Dzialy JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu
WHERE Wzrost >
(SELECT AVG(Wzrost) FROM Osoby)*/

/*SELECT Nazwa, Nazwisko, Wzrost,
(SELECT MAX(Wzrost) FROM Osoby) AS maksimum
FROM Dzialy JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu
WHERE Wzrost =
(SELECT MAX(Wzrost) FROM Osoby)*/

/*SELECT Nazwa, Nazwisko, Brutto, (SELECT AVG(Brutto) FROM Zarobki) AS Sr
FROM Dzialy JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu
JOIN Zarobki
ON Osoby.IdOsoby=Zarobki.IdOsoby
WHERE Brutto>
(SELECT AVG(Brutto) FROM Zarobki)*/

/*SELECT Nazwa, Nazwisko, AVG(Brutto), (SELECT AVG(Brutto) FROM Zarobki) AS Sr
FROM Dzialy JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu
JOIN Zarobki
ON Osoby.IdOsoby=Zarobki.IdOsoby
GROUP BY Nazwa, Nazwisko
HAVING AVG(Brutto) >
(SELECT AVG(Brutto) FROM Zarobki)*/


/*SELECT Nazwa, Nazwisko, Wzrost, Maksimum
FROM Dzialy JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu
JOIN
(SELECT IdDzialu, MAX(Wzrost) AS Maksimum
FROM Osoby
GROUP BY IdDzialu) AS xxx
ON Dzialy.IdDzialu=xxx.IdDzialu
WHERE Wzrost = Maksimum*/

/*SELECT Nazwa, Nazwisko, Wzrost, Srednia
FROM Dzialy JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu
JOIN
(SELECT IdDzialu, AVG(Wzrost) AS Srednia
FROM Osoby
GROUP BY IdDzialu) AS xxx
ON Dzialy.IdDzialu=xxx.IdDzialu
WHERE Wzrost > Srednia

ORDER BY Nazwa*/

/*SELECT Nazwa, Nazwisko, Wzrost, Maksimum
FROM Dzialy JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu
JOIN
(SELECT IdDzialu, MAX(Wzrost) AS Maksimum
FROM Osoby
GROUP BY IdDzialu) AS xxx
ON Dzialy.IdDzialu=xxx.IdDzialu
AND Wzrost = Maksimum*/

/*SELECT Nazwa, Nazwisko, Wzrost, Srednia
FROM Dzialy JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu
JOIN
(SELECT IdDzialu, AVG(Wzrost) AS Srednia
FROM Osoby
GROUP BY IdDzialu) AS xxx
ON Dzialy.IdDzialu=xxx.IdDzialu
AND Wzrost > Srednia

ORDER BY Nazwa*/

SELECT Nazwa, Nazwisko, AVG(Brutto) SrPrac, SrD,
(SELECT AVG(Brutto) FROM Zarobki) AS SrF
FROM Dzialy JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu
JOIN Zarobki
ON Osoby.IdOsoby=Zarobki.IdOsoby
JOIN
(SELECT IdDzialu, AVG(Brutto) AS SrD
FROM Osoby JOIN Zarobki
ON Osoby.IdOsoby=Zarobki.IdOsoby
GROUP BY IdDzialu) AS xxx
ON Dzialy.IdDzialu=xxx.IdDzialu
GROUP BY Nazwa, Nazwisko, SrD
HAVING AVG(Brutto) > SrD


