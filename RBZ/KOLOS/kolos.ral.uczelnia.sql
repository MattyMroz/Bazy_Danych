-- Zadania przykładowe z pliku kolos.ral.uczelnia.sql na ich podstawie masz zrobić kolos.
-- Ustanowić serwer połączony SQLServer o nazwie Serwer1 z wykorzystaniem loginu sa
-- w systemie SQLServer, mapowanego na prawa konta: ZA23, hasło: 12345, tego samego lokalnego serwera.

-- Opracować widok: Widok1 zaszyfrowany w bazie NORTHWIND SQL Server,
-- przez który możliwa będzie operacja pobierania danych:
-- jaki pracownik EMPLOYEES Oracle obsłużył jakie zamówienia ORDERS Oracle,
-- na których są jakie produkty Serwer1 SQL Server.
-- W tym celu wykorzystać funkcję OPENROWSET().

-- Wykorzystując ustanowiony serwer Serwer1 i bezwzględną czteroczłonową identyfikację obiektu
-- napisać zapytanie:
-- który spedytor tabela Shippers serwera Serwer1 miał największy wzrost wartości przewozów
-- między 1997 a 1998 rokiem, różnica rok do roku bez upustów, tabele serwera zdalnego.

-- Napisać zapytanie przekazujące do serwera Serwer1, przetwarzanie zdalne OPENQUERY():
-- podać jaki klient nie zrealizował żadnych zamówień oraz dalej porównać,
-- czy na serwerze lokalnym ten sam klient zrealizował tę samą liczbę zamówień.

-- Napisać procedurę PROC4(@OrderID), która zwróci wszystkie kategorie z danego zamówienia
-- oraz łączną wartość sprzedaży per kategoria bez rabatów.
-- W tym celu wykorzystać funkcję OPENROWSET() odwołującą się do bazy Northwind Access.
-- Podać przykład wyzwolenia procedury z różnymi ustawionymi atrybutami parametru wejściowego.


-----------------------------------------------------------------------------


-- Ustanowić serwer połączony SQLServer o nazwie Serwer1 z wykorzystaniem loginu sa
-- w systemie SQLServer, mapowanego na prawa konta: ZA23, hasło: 12345, tego samego lokalnego serwera.

sp_configure 'show advanced options', 1
reconfigure
go

sp_configure 'Ad Hoc Distributed Queries', 1
reconfigure
go

USE [master]
GO
EXEC master.dbo.sp_MSset_oledb_prop N'MSOLEDBSQL', N'AllowInProcess', 1
GO
EXEC master.dbo.sp_MSset_oledb_prop N'MSOLEDBSQL', N'DynamicParameters', 1
GO

EXEC master.dbo.sp_MSset_oledb_prop N'OraOLEDB.Oracle', N'AllowInProcess', 1
GO
EXEC master.dbo.sp_MSset_oledb_prop N'OraOLEDB.Oracle', N'DynamicParameters', 1
GO

EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1
GO
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1
GO

CREATE LOGIN ZA23 WITH PASSWORD = '12345', CHECK_POLICY = OFF

USE Northwind
GO
CREATE USER ZA23 FOR LOGIN ZA23

GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO ZA23

USE master

EXEC sp_addlinkedserver
    @server     = 'Serwer1',
    @srvproduct = '',
    @provider   = 'MSOLEDBSQL',
    @datasrc    = 'WB-20',
    @catalog    = 'Northwind';
GO

EXEC sp_addlinkedsrvlogin
    @rmtsrvname = 'Serwer1',
    @useself    = 'false',
    @locallogin = 'sa',
    @rmtuser    = 'ZA23',
    @rmtpassword= '12345';
GO


sp_serveroption 'Serwer1', 'data access', 'true';
go
sp_serveroption 'Serwer1', 'rpc', 'true';
go
sp_serveroption 'Serwer1', 'rpc out', 'true';
go

sp_linkedservers
SELECT ProductID, ProductName FROM Northwind.dbo.Products
SELECT TOP 5 * FROM OPENQUERY(Serwer1, 'SELECT ProductID, ProductName FROM Northwind.dbo.Products')


-- Zad
-- Opracować widok: Widok1 zaszyfrowany w bazie NORTHWIND SQL Server,
-- przez który możliwa będzie operacja pobierania danych:
-- jaki pracownik EMPLOYEES Oracle obsłużył jakie zamówienia ORDERS Oracle,
-- na których są jakie produkty Serwer1 SQL Server.
-- W tym celu wykorzystać funkcję OPENROWSET().

SELECT
    e.EmployeeID, e.LastName, e.FirstName,
    o.OrderID, o.OrderDate,
    od.ProductID, p.ProductName,
    od.UnitPrice, od.Quantity
FROM Northwind.dbo.Employees AS e
INNER JOIN Northwind.dbo.Orders AS o  ON e.EmployeeID = o.EmployeeID
INNER JOIN Northwind.dbo.[Order Details] AS od ON o.OrderID = od.OrderID
INNER JOIN Northwind.dbo.Products AS p  ON od.ProductID = p.ProductID;
GO


SELECT e.*
FROM OPENROWSET(
    'OraOLEDB.Oracle',
    '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=212.51.216.169)(PORT=1521))(CONNECT_DATA=(SID=PD25)))';'PD251190';'12345',
    'SELECT EmployeeID, LastName, FirstName FROM Employees'
) AS e;
GO

SELECT o.*
FROM OPENROWSET(
    'OraOLEDB.Oracle',
    '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=212.51.216.169)(PORT=1521))(CONNECT_DATA=(SID=PD25)))';'PD251190';'12345',
    'SELECT OrderID, EmployeeID, OrderDate FROM Orders'
) AS o;
GO

SELECT od.*
FROM OPENROWSET(
    'OraOLEDB.Oracle',
    '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=212.51.216.169)(PORT=1521))(CONNECT_DATA=(SID=PD25)))';'PD251190';'12345',
    'SELECT OrderID, ProductID, UnitPrice, Quantity FROM OrderDetails'
) AS od;
GO

SELECT p.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=WB-20;Database=Northwind;UID=sa;PWD=praktyka;',
    'SELECT ProductID, ProductName FROM dbo.Products'
) AS p;
GO

CREATE OR ALTER VIEW dbo.Widok1
WITH ENCRYPTION
AS
SELECT
    e.EmployeeID, e.LastName, e.FirstName,
    o.OrderID, o.OrderDate,
    od.ProductID, p.ProductName,
    od.UnitPrice, od.Quantity
FROM OPENROWSET(
    'OraOLEDB.Oracle',
    '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=212.51.216.169)(PORT=1521))(CONNECT_DATA=(SID=PD25)))';'PD251190';'12345',
    'SELECT EmployeeID, LastName, FirstName FROM Employees'
) AS e
INNER JOIN OPENROWSET(
    'OraOLEDB.Oracle',
    '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=212.51.216.169)(PORT=1521))(CONNECT_DATA=(SID=PD25)))';'PD251190';'12345',
    'SELECT OrderID, EmployeeID, OrderDate FROM Orders'
) AS o ON e.EmployeeID = o.EmployeeID
INNER JOIN OPENROWSET(
    'OraOLEDB.Oracle',
    '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=212.51.216.169)(PORT=1521))(CONNECT_DATA=(SID=PD25)))';'PD251190';'12345',
    'SELECT OrderID, ProductID, UnitPrice, Quantity FROM OrderDetails'
) AS od ON o.OrderID = od.OrderID
INNER JOIN OPENROWSET(
    'MSOLEDBSQL',
    'Server=WB-20;Database=Northwind;UID=sa;PWD=praktyka;',
    'SELECT ProductID, ProductName FROM dbo.Products'
) AS p ON od.ProductID = p.ProductID;
GO

SELECT * FROM dbo.Widok1 ORDER BY EmployeeID, OrderID;
GO



-- Zad
-- Wykorzystując ustanowiony serwer Serwer1 i bezwzględną czteroczłonową identyfikację obiektu
-- napisać zapytanie:
-- który spedytor tabela Shippers serwera Serwer1 miał największy wzrost wartości przewozów
-- między 1997 a 1998 rokiem, różnica rok do roku bez upustów, tabele serwera zdalnego.

SELECT s.ShipperID, s.CompanyName, SUM(od.UnitPrice * od.Quantity) AS Wartosc
FROM Northwind.dbo.Shippers AS s
JOIN Northwind.dbo.Orders AS o ON s.ShipperID = o.ShipVia
JOIN Northwind.dbo.[Order Details] AS od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997
GROUP BY s.ShipperID, s.CompanyName

;WITH r1997 AS (
    SELECT s.ShipperID, s.CompanyName, SUM(od.UnitPrice * od.Quantity) AS Wartosc
    FROM Serwer1.Northwind.dbo.Shippers AS s
    JOIN Serwer1.Northwind.dbo.Orders AS o ON s.ShipperID = o.ShipVia
    JOIN Serwer1.Northwind.dbo.[Order Details] AS od ON o.OrderID = od.OrderID
    WHERE YEAR(o.OrderDate) = 1997
    GROUP BY s.ShipperID, s.CompanyName
),
r1998 AS (
    SELECT s.ShipperID, s.CompanyName, SUM(od.UnitPrice * od.Quantity) AS Wartosc
    FROM Serwer1.Northwind.dbo.Shippers AS s
    JOIN Serwer1.Northwind.dbo.Orders AS o ON s.ShipperID = o.ShipVia
    JOIN Serwer1.Northwind.dbo.[Order Details] AS od ON o.OrderID = od.OrderID
    WHERE YEAR(o.OrderDate) = 1998
    GROUP BY s.ShipperID, s.CompanyName
)
SELECT TOP 1 a.ShipperID, a.CompanyName, a.Wartosc AS Wartosc1997, b.Wartosc AS Wartosc1998, b.Wartosc - a.Wartosc AS Wzrost
FROM r1997 AS a
INNER JOIN r1998 AS b ON a.ShipperID = b.ShipperID
ORDER BY Wzrost DESC;
GO

-- Napisać zapytanie przekazujące do serwera Serwer1, przetwarzanie zdalne OPENQUERY():
-- podać jaki klient nie zrealizował żadnych zamówień oraz dalej porównać,
-- czy na serwerze lokalnym ten sam klient zrealizował tę samą liczbę zamówień.
SELECT c.CustomerID, c.CompanyName, COUNT(o.OrderID) AS LiczbaZamowien
FROM Northwind.dbo.Customers c
LEFT JOIN Northwind.dbo.Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CompanyName
HAVING COUNT(o.OrderID) = 0;
GO

SELECT *
FROM OPENQUERY(Serwer1, '
    SELECT c.CustomerID, c.CompanyName, COUNT(o.OrderID) AS LiczbaZamowienZdalnie
    FROM Northwind.dbo.Customers c
    LEFT JOIN Northwind.dbo.Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.CompanyName
    HAVING COUNT(o.OrderID) = 0
');
GO

SELECT z.CustomerID, z.CompanyName, COUNT(o.OrderID) AS LiczbaLokalnie
FROM OPENQUERY(Serwer1, '
    SELECT c.CustomerID, c.CompanyName
    FROM Northwind.dbo.Customers c
    WHERE NOT EXISTS (SELECT 1 FROM Northwind.dbo.Orders o WHERE o.CustomerID = c.CustomerID)
') AS z
LEFT JOIN Northwind.dbo.Orders o ON o.CustomerID = z.CustomerID
GROUP BY z.CustomerID, z.CompanyName;
GO



-- Napisać procedurę PROC4(@OrderID), która zwróci wszystkie kategorie z danego zamówienia
-- oraz łączną wartość sprzedaży per kategoria bez rabatów.
-- W tym celu wykorzystać funkcję OPENROWSET() odwołującą się do bazy Northwind Access.
-- Podać przykład wyzwolenia procedury z różnymi ustawionymi atrybutami parametru wejściowego.

SELECT
    c.CategoryName AS Kategoria,
    SUM(od.UnitPrice * od.Quantity) AS WartoscBezRabatu
FROM Northwind.dbo.[Order Details] od
INNER JOIN Northwind.dbo.Products   p ON od.ProductID = p.ProductID
INNER JOIN Northwind.dbo.Categories c ON p.CategoryID = c.CategoryID
WHERE od.OrderID = 10248
GROUP BY c.CategoryName;
GO

SELECT TOP 5 *
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'C:\Northwind\Northwind.mdb';'admin';'',
    'SELECT * FROM [Opisy zamówień]'
) AS o;
GO

SELECT TOP 5 *
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'C:\Northwind\Northwind.mdb';'admin';'',
    'SELECT * FROM Produkty'
) AS p;
GO

SELECT TOP 5 *
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'C:\Northwind\Northwind.mdb';'admin';'',
    'SELECT * FROM Kategorie'
) AS k;
GO


;WITH o AS (
    SELECT * FROM OPENROWSET(
        'Microsoft.ACE.OLEDB.12.0',
        'C:\Northwind\Northwind.mdb';'admin';'',
        'SELECT * FROM [Opisy zamówień]'
    )
),
p AS (
    SELECT * FROM OPENROWSET(
        'Microsoft.ACE.OLEDB.12.0',
        'C:\Northwind\Northwind.mdb';'admin';'',
        'SELECT * FROM Produkty'
    )
),
k AS (
    SELECT * FROM OPENROWSET(
        'Microsoft.ACE.OLEDB.12.0',
        'C:\Northwind\Northwind.mdb';'admin';'',
        'SELECT * FROM Kategorie'
    )
)
SELECT k.NazwaKategorii AS Kategoria,
       SUM(o.CenaJednostkowa * o.Ilość) AS WartoscBezRabatu
FROM o
JOIN p ON o.IDproduktu = p.IDproduktu
JOIN k ON p.IDkategorii = k.IDkategorii
WHERE o.IDzamówienia = 10248
GROUP BY k.NazwaKategorii;
GO

CREATE OR ALTER PROCEDURE dbo.PROC4 @OrderID INT
AS
WITH o AS (
    SELECT * FROM OPENROWSET(
        'Microsoft.ACE.OLEDB.12.0',
        'C:\Northwind\Northwind.mdb';'admin';'',
        'SELECT * FROM [Opisy zamówień]'
    )
),
p AS (
    SELECT * FROM OPENROWSET(
        'Microsoft.ACE.OLEDB.12.0',
        'C:\Northwind\Northwind.mdb';'admin';'',
        'SELECT * FROM Produkty'
    )
),
k AS (
    SELECT * FROM OPENROWSET(
        'Microsoft.ACE.OLEDB.12.0',
        'C:\Northwind\Northwind.mdb';'admin';'',
        'SELECT * FROM Kategorie'
    )
)
SELECT k.NazwaKategorii AS Kategoria,
       SUM(o.CenaJednostkowa * o.Ilość) AS WartoscBezRabatu
FROM o
JOIN p ON o.IDproduktu = p.IDproduktu
JOIN k ON p.IDkategorii = k.IDkategorii
WHERE o.IDzamówienia = @OrderID
GROUP BY k.NazwaKategorii;
GO

EXEC dbo.PROC4 10248;
GO

EXEC dbo.PROC4 @OrderID = 10250;
GO

DECLARE @id INT = 10251;
EXEC dbo.PROC4 @id;
GO

DECLARE @id INT = 10252;
EXEC dbo.PROC4 @OrderID = @id;
GO
