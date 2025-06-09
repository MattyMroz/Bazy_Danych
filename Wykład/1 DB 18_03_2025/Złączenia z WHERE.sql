/*SELECT Nazwa, Nazwisko
FROM Dzialy, Osoby*/

/*SELECT Nazwa, Nazwisko
FROM Dzialy, Osoby
WHERE Dzialy.IdDzialu=Osoby.IdDzialu*/

SELECT Nazwa, Nazwisko, Brutto
FROM Dzialy, Osoby, Zarobki
WHERE Dzialy.IdDzialu=Osoby.IdDzialu
AND Osoby.IdOsoby=Zarobki.IdOsoby