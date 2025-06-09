/*CREATE OR ALTER TRIGGER selT
ON Osoby
FOR INSERT
AS
SELECT Nazwisko, Imie, RokUrodz FROM Osoby*/
GO
CREATE OR ALTER TRIGGER selT1
ON Osoby
AFTER INSERT, UPDATE
AS
SELECT Nazwisko, Imie FROM Osoby

GO
INSERT INTO Osoby( Nazwisko) VALUES ('Nowaczyk')

UPDATE Osoby SET Nazwisko=LOWER( Nazwisko)