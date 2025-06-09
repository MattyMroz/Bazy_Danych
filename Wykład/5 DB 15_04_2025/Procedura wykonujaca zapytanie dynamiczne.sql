CREATE OR ALTER PROCEDURE UpP
@fun varchar(11) = 'UPPER',
@tabela varchar(33),
@pole Varchar(33)
AS
DECLARE @zap varchar(222)
SET @zap = 'UPDATE ' + @tabela + ' SET ' + @pole + ' = ' + @fun + '(' + @pole +')'
PRINT @zap
EXEC(@zap)
SET @zap = 'SELECT * FROM ' + @tabela
PRINT @zap
EXEC(@zap)
GO

EXEC UpP 'LOWER', 'Osoby', 'Imie'
EXEC UpP   @pole= 'Imie', @tabela= 'Osoby'
