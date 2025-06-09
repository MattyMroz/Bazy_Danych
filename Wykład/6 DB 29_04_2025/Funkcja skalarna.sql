CREATE OR ALTER FUNCTION LiczF
(@mini real = 0) RETURNS int
AS
BEGIN
	DECLARE @ile int 
	SELECT @ile = COUNT(IdOsoby)
	FROM Osoby WHERE Wzrost > @mini
	RETURN @ile
END
GO
DECLARE @ile int
--SET @ile=dbo.LiczF(1.8)
	SET @ile=dbo.LiczF(default)
PRINT @ile
GO
SELECT Nazwisko, Wzrost, dbo.LiczF(Wzrost) FROM Osoby
