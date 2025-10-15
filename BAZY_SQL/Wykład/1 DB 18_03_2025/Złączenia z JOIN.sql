/*SELECT Nazwa, Nazwisko
FROM Dzialy JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu

SELECT Nazwa, Nazwisko, Brutto
FROM Dzialy JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu
JOIN Zarobki
ON Osoby.IdOsoby=Zarobki.IdOsoby*/

/*SELECT Nazwa, Nazwisko
FROM Dzialy LEFT JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu

SELECT Nazwa, Nazwisko
FROM Dzialy RIGHT JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu

SELECT Nazwa, Nazwisko
FROM Dzialy FULL JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu*/

SELECT Nazwa, Nazwisko, Brutto
FROM Dzialy FULL JOIN Osoby
ON Dzialy.IdDzialu=Osoby.IdDzialu
RIGHT JOIN Zarobki
ON Osoby.IdOsoby=Zarobki.IdOsoby

SELECT Nazwa, Nazwisko
FROM Dzialy CROSS JOIN Osoby
