/*WITH xxxx
AS
(SELECT 2 AS A
UNION ALL
SELECT A+3 FROM xxxx
WHERE A<300)

SELECT A FROM xxxx
OPTION (MAXRECURSION 32767)*/

/*WITH Hierarchia
AS
(SELECT IdOsoby, Nazwisko, IdSzefa, IdOsoby AS a, Nazwisko AS b, IdSzefa AS SzefSzefa
FROM Osoby WHERE IdOsoby = 2 --IdSzefa IS NULL
UNION ALL
SELECT Osoby.IdOsoby, Osoby.Nazwisko, Osoby.IdSzefa,
Hierarchia.IdOsoby, Hierarchia.Nazwisko, Hierarchia.IdSzefa
FROM Osoby JOIN Hierarchia
ON Osoby.IdSzefa=Hierarchia.IdOsoby
)
SELECT * FROM Hierarchia*/

WITH Hierarchia
AS
(SELECT 1 AS Poziom, IdOsoby, Nazwisko, IdSzefa, CAST('' AS varchar(33)) AS Szef,
CAST('|' AS varchar(max)) AS Sciezka
FROM Osoby WHERE IdOsoby = 2 --IdSzefa IS NULL
UNION ALL
SELECT Poziom+1, Osoby.IdOsoby, Osoby.Nazwisko, Osoby.IdSzefa, 
CAST(Hierarchia.Nazwisko AS varchar(33)),
CAST(Sciezka + Hierarchia.Nazwisko+'\' AS varchar(max))
FROM Osoby JOIN Hierarchia
ON Osoby.IdSzefa=Hierarchia.IdOsoby
)
SELECT * FROM Hierarchia






