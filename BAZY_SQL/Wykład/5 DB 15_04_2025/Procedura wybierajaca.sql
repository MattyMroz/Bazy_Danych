--DROP PROCEDURE sel
GO
CREATE OR ALTER PROCEDURE sel
@nazw varchar(22) = '%',
@im varchar(22) ='%'
AS
SELECT Nazwisko, Imie, RokUrodz
FROM Osoby
WHERE Nazwisko LIKE @nazw +'%'
AND Imie LIKE @im +'%'

GO
EXEC sel 'k', 'j'
EXEC sel 'k'
EXEC sel

EXEC sel @im ='j'
EXEC sel @im ='j', @nazw='n'

/*EXECUTE sel
EXEC sel
sel*/