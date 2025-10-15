CREATE OR ALTER PROCEDURE Licz
@mini real = 0,
@ile int OUTPUT
AS
--PRINT @ile
SELECT @ile = COUNT(IdOsoby)
FROM Osoby WHERE Wzrost > @mini
--PRINT @ile
GO
DECLARE @ile int
--SET @ile = 1
--PRINT @ile
--EXEC Licz 1.8, @ile OUT
EXEC Licz @ile=@ile  OUT
PRINT @ile
