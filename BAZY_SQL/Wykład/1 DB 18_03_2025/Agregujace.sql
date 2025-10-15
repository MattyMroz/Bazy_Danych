/*SELECT Nazwisko + '  ' + Imie AS Pracownik, CONCAT(Nazwisko, ' ', Imie) AS Prac,
RokUrodz*Wzrost AS cos, LOWER(Imie) AS xxxx 
FROM Osoby*/

/*SELECT SUM(Brutto) AS Razem, AVG(Brutto) AS Sr,
COUNT(IdZarobku) AS Ile, COUNT(*) AS Ile1, COUNT(IdOsoby) AS Ile2 
FROM Zarobki*/

SELECT IdOsoby, SUM(Brutto) AS Razem, AVG(Brutto) AS Sr, COUNT(IdZarobku) AS Ile
FROM Zarobki
GROUP BY IdOsoby