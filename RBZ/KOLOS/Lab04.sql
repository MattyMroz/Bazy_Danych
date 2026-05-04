-- w dalszym ciągu ćwiczymy OPENROWSET:
-- Zadanie 1:

-- jaki klient (ORACLE) zrealizował jakie zamówienia (SQLSERVER lokalny) na którym są jakie produkty ACCESS)
-- obsłużone przez jakiego pracownika (SQL Server: WA-03) 

-- Zadanie 2:
--  Zapoznać się z ustanawianiem serwera połączonego oraz wykonać następujące kroki:

--1. sterownik OLDB --> konfiguracja
--2. dodanie serwera połączonego
--3. mapowanie praw i nadawanie uprawnień
--4. ustawienie dostępu na infrastrukturze



-- Zadanie 3:
-- Ustanowić serwer połączony ORACLE z wykorzystaniem opcji konfiguracyjnych
-- wprowadzonych w aplikacji Oracle Net Manager (korzystamy z ustawień, które
-- wprowadzone zostały na poprzednich zajęciach)

-- Zadanie 4.
------------------------------
-- Napisać zapytanie rozproszone :
-- pobrać wszystkich pracowników z tabeli EMP schematu SCOTT:
------------

--- Zadanie:(własna realizacja)
----------------------------
-- Ustanowić serwer połączony Access (plik Access powinien znajdować się na dysku c:)
-- następnie napisać zapytanie jakie mamy produkty na serwerze Access:

-- Zadanie: (własna realizacja)
----------------------------
-- Napisać zapytanie 
-- jaki klient (serwer: ORACLE) zrealizował jakie zamówienia (serwer: WA-09) na 
-- których są jaki produkty (serwer: Access)
-- dostarczone przez jakiego dostawcę (serwer lokalny)



-- Zapytanie:
-- Podać z serwera ORACLE: jakie produkty miały wartość sumarycznej sprzedaży ( suma 
-- sprzedaży  z poszczególnych zamówień w względem nazwy produktu) w 
-- poszczególnych miesiącach roku 1998 i 1997.

---Następnie -------------------------------------
-- dla tak przygotowanego zapytania - tworzymy na jego podstawie tabelę: tab1, 
-- która zostanie wypełniona danymi 
--- UWAGA w tabeli tej ustawić typ DATETIME dla dat poszczególnych miesięcy tego zapytania



-- ROZWIAZANIE POD MOJ SERWER

USE Northwind;
GO

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
GO

EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
GO

EXEC master.dbo.sp_MSset_oledb_prop N'OraOLEDB.Oracle', N'AllowInProcess', 1;
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1;
EXEC master.dbo.sp_MSset_oledb_prop N'MSOLEDBSQL', N'AllowInProcess', 1;
GO


-- Zadanie 1:
-- Jaki klient (ORACLE) zrealizował jakie zamówienia (SQLSERVER lokalny) na którym są jakie produkty ACCESS)
-- obsłużone przez jakiego pracownika (SQL Server: WA-03) 

-- Zadanie 1 - najpierw zwykle zapytanie lokalne
SELECT
	c.CompanyName AS Klient,
	c.ContactName AS KontaktKlienta,
	o.OrderID AS NrZamowienia,
	p.ProductName AS Produkt,
	od.UnitPrice AS CenaJednostkowa,
	od.Quantity AS Ilosc,
	e.LastName + ' ' + e.FirstName AS Pracownik
FROM Northwind.dbo.Customers AS c
INNER JOIN Northwind.dbo.Orders AS o
	ON c.CustomerID = o.CustomerID
INNER JOIN Northwind.dbo.[Order Details] AS od
	ON o.OrderID = od.OrderID
INNER JOIN Northwind.dbo.Products AS p
	ON od.ProductID = p.ProductID
INNER JOIN Northwind.dbo.Employees AS e
	ON o.EmployeeID = e.EmployeeID;
GO

-- Zadanie 1 - klienci z Oracle osobno
SELECT c.*
FROM OPENROWSET(
	'OraOLEDB.Oracle',
	'(DESCRIPTION =
		(ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.64.133)(PORT = 1521))
		(CONNECT_DATA =
			(SERVICE_NAME = PDB)
		)
	)';'NORTHWIND';'12345',
	'SELECT CustomerID, CompanyName, ContactName FROM Customers'
) AS c;
GO

-- Zadanie 1 - zamowienia z SQL Server lokalnego osobno
SELECT o.*
FROM OPENROWSET(
	'MSOLEDBSQL',
	'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
	'SELECT o.OrderID, o.CustomerID, o.EmployeeID, od.ProductID, od.UnitPrice, od.Quantity
	 FROM dbo.Orders AS o
	 INNER JOIN dbo.[Order Details] AS od ON o.OrderID = od.OrderID'
) AS o;
GO

-- Zadanie 1 - produkty z Access osobno
SELECT
	p.IDproduktu AS ProductID,
	p.NazwaProduktu AS ProductName
FROM OPENROWSET(
	'Microsoft.ACE.OLEDB.12.0',
	'C:\Northwind\Northwind.mdb';'admin';'',
	'SELECT IDproduktu, NazwaProduktu FROM Produkty'
) AS p;
GO

-- Zadanie 1 - pracownicy z SQL Server osobno
SELECT e.*
FROM OPENROWSET(
	'MSOLEDBSQL',
	'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
	'SELECT EmployeeID, LastName, FirstName FROM dbo.Employees'
) AS e;
GO

-- Zadanie 1 - finalne zapytanie rozproszone
;WITH klienci AS (
	SELECT c.*
	FROM OPENROWSET(
		'OraOLEDB.Oracle',
		'(DESCRIPTION =
			(ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.64.133)(PORT = 1521))
			(CONNECT_DATA =
				(SERVICE_NAME = PDB)
			)
		)';'NORTHWIND';'12345',
		'SELECT CustomerID, CompanyName, ContactName FROM Customers'
	) AS c
),
zamowienia AS (
	SELECT o.*
	FROM OPENROWSET(
		'MSOLEDBSQL',
		'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
		'SELECT o.OrderID, o.CustomerID, o.EmployeeID, od.ProductID, od.UnitPrice, od.Quantity
		 FROM dbo.Orders AS o
		 INNER JOIN dbo.[Order Details] AS od ON o.OrderID = od.OrderID'
	) AS o
),
produkty AS (
	SELECT
		p.IDproduktu AS ProductID,
		p.NazwaProduktu AS ProductName
	FROM OPENROWSET(
		'Microsoft.ACE.OLEDB.12.0',
		'C:\Northwind\Northwind.mdb';'admin';'',
		'SELECT IDproduktu, NazwaProduktu FROM Produkty'
	) AS p
),
pracownicy AS (
	SELECT e.*
	FROM OPENROWSET(
		'MSOLEDBSQL',
		'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
		'SELECT EmployeeID, LastName, FirstName FROM dbo.Employees'
	) AS e
)
SELECT
	k.CompanyName AS Klient,
	k.ContactName AS KontaktKlienta,
	z.OrderID AS NrZamowienia,
	p.ProductName AS Produkt,
	z.UnitPrice AS CenaJednostkowa,
	z.Quantity AS Ilosc,
	pr.LastName + ' ' + pr.FirstName AS Pracownik
FROM zamowienia AS z
INNER JOIN klienci AS k
	ON z.CustomerID = k.CustomerID
INNER JOIN produkty AS p
	ON z.ProductID = p.ProductID
INNER JOIN pracownicy AS pr
	ON z.EmployeeID = pr.EmployeeID;
GO



-- Zadanie 2:
--  Zapoznać się z ustanawianiem serwera połączonego oraz wykonać następujące kroki:

--1. sterownik OLDB --> konfiguracja
--2. dodanie serwera połączonego
--3. mapowanie praw i nadawanie uprawnień
--4. ustawienie dostępu na infrastrukturze

-- Zadanie 3:
-- Ustanowić serwer połączony ORACLE z wykorzystaniem opcji konfiguracyjnych
-- wprowadzonych w aplikacji Oracle Net Manager (korzystamy z ustawień, które
-- wprowadzone zostały na poprzednich zajęciach)


-- Zadanie 2 i 3 - serwer polaczony Oracle pod nasza VM
USE master;
GO

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'ORACLE_PDB')
	EXEC sp_dropserver N'ORACLE_PDB', 'droplogins';
GO

EXEC sp_addlinkedserver
	@server = N'ORACLE_PDB',
	@srvproduct = N'Oracle',
	@provider = N'OraOLEDB.Oracle',
	@datasrc = N'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.64.133)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=PDB)))';
GO

EXEC sp_addlinkedsrvlogin
	@rmtsrvname = N'ORACLE_PDB',
	@useself = N'False',
	@locallogin = NULL,
	@rmtuser = N'system',
	@rmtpassword = N'12345';
GO

EXEC sp_serveroption N'ORACLE_PDB', N'rpc', N'true';
EXEC sp_serveroption N'ORACLE_PDB', N'rpc out', N'true';
GO

SELECT *
FROM OPENQUERY(ORACLE_PDB, 'SELECT to_char(sysdate, ''YYYY-MM-DD HH24:MI'') AS OracleTime FROM dual');
GO

-- Zadanie 4
SELECT *
FROM OPENQUERY(ORACLE_PDB, 'SELECT * FROM scott.emp');
GO

-- Zadanie wlasne - serwer polaczony Access
USE master;
GO

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'ACCESS_NORTHWIND')
	EXEC sp_dropserver N'ACCESS_NORTHWIND', 'droplogins';
GO

EXEC sp_addlinkedserver
	@server = N'ACCESS_NORTHWIND',
	@srvproduct = N'Access',
	@provider = N'Microsoft.ACE.OLEDB.12.0',
	@datasrc = N'C:\Northwind\Northwind.mdb';
GO

SELECT *
FROM OPENQUERY(ACCESS_NORTHWIND, 'SELECT IDproduktu, NazwaProduktu FROM Produkty');
GO

-- Zadanie wlasne - najpierw kazde zrodlo osobno
SELECT c.*
FROM OPENQUERY(ORACLE_PDB, 'SELECT CustomerID, CompanyName FROM northwind.customers') AS c;
GO

SELECT o.*
FROM OPENROWSET(
	'MSOLEDBSQL',
	'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
	'SELECT o.OrderID, o.CustomerID, od.ProductID
	 FROM dbo.Orders AS o
	 INNER JOIN dbo.[Order Details] AS od ON o.OrderID = od.OrderID'
) AS o;
GO

SELECT
	p.IDproduktu AS ProductID,
	p.NazwaProduktu AS ProductName,
	p.IDdostawcy AS SupplierID
FROM OPENQUERY(ACCESS_NORTHWIND, 'SELECT IDproduktu, NazwaProduktu, IDdostawcy FROM Produkty') AS p;
GO

SELECT SupplierID, CompanyName
FROM Northwind.dbo.Suppliers;
GO

-- Zadanie wlasne - finalne zapytanie
;WITH klienci AS (
	SELECT c.*
	FROM OPENQUERY(ORACLE_PDB, 'SELECT CustomerID, CompanyName FROM northwind.customers') AS c
),
zamowienia AS (
	SELECT o.*
	FROM OPENROWSET(
		'MSOLEDBSQL',
		'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
		'SELECT o.OrderID, o.CustomerID, od.ProductID
		 FROM dbo.Orders AS o
		 INNER JOIN dbo.[Order Details] AS od ON o.OrderID = od.OrderID'
	) AS o
),
produkty AS (
	SELECT
		p.IDproduktu AS ProductID,
		p.NazwaProduktu AS ProductName,
		p.IDdostawcy AS SupplierID
	FROM OPENQUERY(ACCESS_NORTHWIND, 'SELECT IDproduktu, NazwaProduktu, IDdostawcy FROM Produkty') AS p
)
SELECT
	k.CompanyName AS Klient,
	z.OrderID AS NrZamowienia,
	p.ProductName AS Produkt,
	s.CompanyName AS Dostawca
FROM zamowienia AS z
INNER JOIN klienci AS k
	ON z.CustomerID = k.CustomerID
INNER JOIN produkty AS p
	ON z.ProductID = p.ProductID
INNER JOIN Northwind.dbo.Suppliers AS s
	ON p.SupplierID = s.SupplierID;
GO

-- Zapytanie Oracle - sprzedaz produktow w miesiacach 1997 i 1998
SELECT *
FROM OPENQUERY(ORACLE_PDB, '
	SELECT
		p.ProductName,
		TRUNC(o.OrderDate, ''MM'') AS OrderMonth,
		SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS SalesValue
	FROM northwind.products p
	INNER JOIN northwind.orderdetails od ON p.ProductID = od.ProductID
	INNER JOIN northwind.orders o ON od.OrderID = o.OrderID
	WHERE EXTRACT(YEAR FROM o.OrderDate) IN (1997, 1998)
	GROUP BY p.ProductName, TRUNC(o.OrderDate, ''MM'')
	ORDER BY TRUNC(o.OrderDate, ''MM''), p.ProductName
');
GO

USE Northwind;
GO

IF OBJECT_ID('dbo.tab1', 'U') IS NOT NULL
	DROP TABLE dbo.tab1;
GO

SELECT
	q.ProductName,
	CAST(q.OrderMonth AS DATETIME) AS OrderMonth,
	q.SalesValue
INTO dbo.tab1
FROM OPENQUERY(ORACLE_PDB, '
	SELECT
		p.ProductName,
		TRUNC(o.OrderDate, ''MM'') AS OrderMonth,
		SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS SalesValue
	FROM northwind.products p
	INNER JOIN northwind.orderdetails od ON p.ProductID = od.ProductID
	INNER JOIN northwind.orders o ON od.OrderID = o.OrderID
	WHERE EXTRACT(YEAR FROM o.OrderDate) IN (1997, 1998)
	GROUP BY p.ProductName, TRUNC(o.OrderDate, ''MM'')
') AS q;
GO

SELECT *
FROM dbo.tab1
ORDER BY OrderMonth, ProductName;
GO