/* Z³a jakoœæ kodu
CREATE OR ALTER FUNCTION IleWDzialeF
(@dzial int = 1) RETURNS int
AS
BEGIN
	DECLARE @ile int, @ok int
	SELECT @ok=COUNT(*) FROM Dzialy WHERE IdDzialu=@dzial
	IF @ok=1
	BEGIN
		SELECT @ile = COUNT(IdOsoby) FROM Osoby WHERE IdDzialu=@dzial
		RETURN @ile
	END
	ELSE
		RETURN -5
	RETURN -7
END*/
GO
CREATE OR ALTER FUNCTION IleWDzialeF
(@dzial int = 1) RETURNS int
AS
BEGIN
	DECLARE @ile int, @ok int
	SELECT @ok=COUNT(*) FROM Dzialy WHERE IdDzialu=@dzial
	IF @ok=1
		SELECT @ile = COUNT(IdOsoby) FROM Osoby WHERE IdDzialu=@dzial
	ELSE
		SET @ile = -5
	RETURN @ile
END
GO
DECLARE @ile int
SET @ile=dbo.IleWDzialeF(10)
PRINT @ile
GO
SELECT Nazwa, dbo.IleWDzialeF(IdDzialu) FROM Dzialy

