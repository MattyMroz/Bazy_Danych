CREATE OR ALTER PROCEDURE IleWDzialeP
@dzial int = 1, @ile int OUT
AS

	DECLARE @ok int
	SELECT @ile = COUNT(IdOsoby) FROM Osoby WHERE IdDzialu=@dzial
	SELECT @ok=COUNT(*) FROM Dzialy WHERE IdDzialu=@dzial
	IF @ok=1
		SET @ok = 0
	ELSE
		SET @ok = -5
	RETURN @ok
GO
DECLARE @ile int, @ok int
EXEC @ok = IleWDzialeP 10, @ile OUT
PRINT @ile
PRINT @ok


