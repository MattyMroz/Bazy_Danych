--SELECT 3, SYSDATETIME(), GETDATE()

/*WITH SumaWyplat 
AS
(SELECT IdOsoby, SUM(Brutto) AS Razem
FROM Zarobki
GROUP BY IdOsoby)

SELECT Nazwisko, Razem
FROM Osoby JOIN SumaWyplat
ON Osoby.IdOsoby=SumaWyplat.IdOsoby*/


WITH SumaWyplat (IdOsoby, SumaBrutto)
AS
(SELECT IdOsoby, SUM(Brutto) AS Razem
FROM Zarobki
GROUP BY IdOsoby)

SELECT Nazwisko, SumaBrutto
FROM Osoby JOIN SumaWyplat
ON Osoby.IdOsoby=SumaWyplat.IdOsoby