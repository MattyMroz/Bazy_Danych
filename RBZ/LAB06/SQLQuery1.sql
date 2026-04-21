USE Northwind;
GO

CREATE TABLE koledzy (
    indeks   INT         NOT NULL PRIMARY KEY,
    nazwisko VARCHAR(50) NOT NULL,
    imie     VARCHAR(25) NOT NULL
);

GRANT SELECT, INSERT, UPDATE, DELETE ON koledzy TO PUBLIC;

SELECT * FROM koledzy;



USE Northwind;
GO

SET XACT_ABORT ON;
GO

BEGIN DISTRIBUTED TRANSACTION;

    -- Wstawianie na SERWER LOKALNY (Twój)
    INSERT INTO Northwind.dbo.koledzy (indeks, nazwisko, imie)
    VALUES (1, 'Kowalski', 'Jan');

    -- Wstawianie na SERWER ZDALNY (kolega WB-18)
    INSERT INTO OPENROWSET(
        'MSOLEDBSQL',
        'Server=WB-18;Database=master;Trusted_Connection=yes;',
        'SELECT * FROM dbo.koledzy'
    )
    VALUES (1, 'Kowalski', 'Jan');

COMMIT TRANSACTION;
GO

SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=WB-18;Database=Northwind;Trusted_Connection=yes;',
    'SELECT * FROM dbo.Categories'
) AS a;

SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'WB-18';'sa';'praktyka',
    'select * from Northwind.dbo.Categories'
) AS a;


USE Northwind;
GO

SET XACT_ABORT ON;
GO

BEGIN DISTRIBUTED TRANSACTION;

    -- Wstawianie LOKALNIE (Twój serwer WB-20)
    INSERT INTO Northwind.dbo.koledzy (indeks, nazwisko, imie)
    VALUES (1, 'Kowalski', 'Jan');

    -- Wstawianie ZDALNIE (kolega WB-18)
    INSERT INTO OPENROWSET(
        'MSOLEDBSQL',
        'WB-18';'sa';'praktyka',
        'SELECT * FROM Northwind.dbo.koledzy'
    )
    VALUES (1, 'Kowalski', 'Jan');

COMMIT TRANSACTION;
GO

SELECT * FROM Northwind.dbo.koledzy;

SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'WB-18';'sa';'praktyka',
    'SELECT * FROM Northwind.dbo.koledzy'
) AS a;

-- Na WB-18
SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'WB-18';'sa';'praktyka',
    'SELECT * FROM Northwind.dbo.koledzy'
) AS a;
