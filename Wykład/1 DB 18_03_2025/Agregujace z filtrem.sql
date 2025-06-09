SELECT IdOsoby, SUM(Brutto) AS Razem, AVG(Brutto) AS Sr, COUNT(IdZarobku) AS Ile
FROM Zarobki
	WHERE IdOsoby IN (1, 7, 5, 2, 12, 22, 17, 14)
	--Brutto >2222
	GROUP BY IdOsoby
	HAVING SUM(Brutto)>11111
	ORDER BY IdOsoby
--Razem
--SUM(Brutto) DESC