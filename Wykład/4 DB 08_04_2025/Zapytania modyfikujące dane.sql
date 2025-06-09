/*DROP TABLE Nowa
SELECT Nazwisko, Imie, RokUrodz
INTO Nowa
FROM Osoby
WHERE 1=2
--IdOsoby IS NULL
--RokUrodz >1970000*/

/*INSERT INTO Nowa VALUES ('Kowalski', 'Jan', 2000)
INSERT INTO Nowa (Nazwisko, Imie) VALUES ('Nowak', 'Pawe³')
INSERT INTO Nowa (Nazwisko, Imie) VALUES ('Lis', 2001)*/

/*INSERT INTO Nowa 
SELECT Nazwisko, Imie, RokUrodz FROM Osoby
WHERE RokUrodz>2000*/

/*INSERT INTO Nowa (Nazwisko, Imie)
SELECT Nazwisko, RokUrodz FROM Osoby
WHERE RokUrodz<1960*/

/*UPDATE Nowa SET Nazwisko=LOWER(Nazwisko), Imie = UPPER(Imie)
WHERE RokUrodz IS NOT NULL*/

/*DELETE FROM Nowa WHERE RokUrodz IS NULL

TRUNCATE TABLE Nowa*/

INSERT INTO Nowa (Nazwisko, Imie) VALUES 
		('Nowak', 'Pawe³'),
		('Kowalik', 'Piotr'),
		('Janik', 'Karol')

INSERT INTO Nowa (Nazwisko, Imie) VALUES 
		('Nowak', 2000),
		('Kowalik', 2001),
		('Janik', 2002)

INSERT INTO Nowa (Nazwisko, Imie) VALUES 
		('Nowak', 2000),
		('Kowalik', 'Jan'),
		('Janik', 2002)

SELECT * FROM Nowa