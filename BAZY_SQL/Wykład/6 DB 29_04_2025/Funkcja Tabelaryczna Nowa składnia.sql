CREATE OR ALTER FUNCTION WysocyF1
(@mini real = 0) RETURNS TABLE

AS
RETURN
	(SELECT IdOsoby, Nazwisko, Wzrost, @mini AS prog
	FROM Osoby WHERE Wzrost > @mini)

GO
SELECT * FROM WysocyF1(1.8)
SELECT * FROM WysocyF1(default)