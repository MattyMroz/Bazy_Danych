CREATE OR ALTER FUNCTION WysocyF
(@mini real = 0) RETURNS @Wysocy TABLE
(Kto int,
Nazwisko varchar(33),
Wzrost real,
prog real
)
AS
BEGIN
	INSERT INTO @Wysocy
	SELECT IdOsoby, Nazwisko, Wzrost, @mini
	FROM Osoby WHERE Wzrost > @mini
	RETURN 
END
GO
SELECT * FROM WysocyF(1.8)
SELECT * FROM WysocyF(default)