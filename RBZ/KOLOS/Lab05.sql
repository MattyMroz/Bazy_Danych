--------------------------- Zadania:---------
-- Pracujemy w grupach 2 osobowych na dwóch instancjach znajdujących się na osobnych komputerach lub
--  w przypadku pracy samodzielnej symulujemy pracę środowiska rozproszonego na jednej instancji 
-- serwera SQLServer z wykorzystaniem dwóch baz danych
---------------------------------------

-- 1. Zdefiniować nową bazę danych RBD_g10 (przy pracy samodzielnej dodatkową bazę RBD_g10d)
-- 2. W założonej nowej bazie --> utworzyć na podstawie bazy NorthWind 3 tabele:  Customers, Orders, [order details], Products
-- 3. Utworzyć loginy (oraz użytkowników w nowej bazie):
	-- login (oraz użytkownik)  lokalny: RBDg10L  z hasłem 123456RBD 
	-- login (oraz użytkownik) do pracy zdalnej: zRBDg10R z hasłem 123456RBD 
-- 4. Zdefiniować serwer połączony: z-0X. Następnie dla tak utworzonego serwera zdalnego wykorzystując loginy 
-- z pkt. 3 delegować uprawnienia loginu/użytkownika  lokalnego RBDg10L  na uprawnienia loginu/użytkownika RBDg10R 
-- 5. Nadać niezbędne prawa obiektowe do czytania oraz zapisu danych na serwerze lokalnym i serwerze zdalnym 
-- określonym użytkownikom zdefiniowanym po stronie bazy danych.
-- 6. Zdefiniowany widok który zwróci informację: Jakie produkty (serwer zdalny) znalazły się na danych zamówieniach (serwer zdalny) 
-- zrealizowanych przez danych użytkowników (serwer lokalny)?. Następnie napisać zapytanie do tak powołanego widoku, które pobierze dane
-- 7. Opracować procedurę przechowywaną, która dla parametru wejściowego zwróci informację jaka jest sumaryczna 
-- wartość sprzedaży (serwer zdalny) w danym roku podawanym jako parametr wejściowy.
-- 8. Nadać odpowiednie uprawnienia do procedury, które pozwolą na zdalne jej wywoływanie.
-- 9. Przetestować możliwość wstawiania krotek na serwer zdalny do tabeli Products (ale bez użycia koordynatora MS DTC).
-- 10. Wstawione w punkcie 9 krotki usunąć z serwera zdalnego przez wykorzystanie bezwzględnego czteroczłonowego identyfikatora obiektu
-- wykorzystanego na serwerze lokalnym
-- 11. Punkt 9 i 10 zrealizować również przez wykorzystanie funkcji OPENQUERY z którą to funkcją należy zapoznać się w dokumentacji Microsoft.
-- 12. Pracując w grupach dwuosobowych należy następnie zdefiniować w systemie ORACLE tabelę EMPLOYEES (kopiując ją instrukcją ze schematu NORTHWIND)
-- oraz nadać określone uprawnienia obiektowe do tej tabeli do loginu ORACLE współpracującej osobie w grupie. 
-- 13. Dla zdefiniowanego użytkownika lokalnego (SQL Server) zdefiniować serwer ORACLE oraz dokonać delegacji uprawnień tego loginu do własnego 
-- loginu serwera ORACLE. Następnie przetestować możliwość wstawiania danych do tabeli znajdującej się w schemacie użytkownika współpracującej 
-- osoby w grupie. W razie potrzeby zredefiniować określone uprawnienia obiektowe.


-- ROZWIAZANIE POD MOJ SERWER

USE master;
GO

IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = N'RBD_g10')
	CREATE DATABASE RBD_g10;
GO

IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = N'RBD_g10d')
	CREATE DATABASE RBD_g10d;
GO

USE RBD_g10;
GO

IF OBJECT_ID('dbo.Customers', 'U') IS NULL
	SELECT * INTO dbo.Customers FROM Northwind.dbo.Customers;
GO

IF OBJECT_ID('dbo.Orders', 'U') IS NULL
	SELECT * INTO dbo.Orders FROM Northwind.dbo.Orders;
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = N'Order Details' AND schema_id = SCHEMA_ID(N'dbo'))
	SELECT * INTO dbo.[Order Details] FROM Northwind.dbo.[Order Details];
GO

IF OBJECT_ID('dbo.Products', 'U') IS NULL
	SELECT * INTO dbo.Products FROM Northwind.dbo.Products;
GO

USE RBD_g10d;
GO

IF OBJECT_ID('dbo.Customers', 'U') IS NULL
	SELECT * INTO dbo.Customers FROM Northwind.dbo.Customers;
GO

IF OBJECT_ID('dbo.Orders', 'U') IS NULL
	SELECT * INTO dbo.Orders FROM Northwind.dbo.Orders;
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = N'Order Details' AND schema_id = SCHEMA_ID(N'dbo'))
	SELECT * INTO dbo.[Order Details] FROM Northwind.dbo.[Order Details];
GO

IF OBJECT_ID('dbo.Products', 'U') IS NULL
	SELECT * INTO dbo.Products FROM Northwind.dbo.Products;
GO

USE master;
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'RBDg10L')
	CREATE LOGIN RBDg10L WITH PASSWORD = '123456RBD', CHECK_POLICY = OFF;
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'zRBDg10R')
	CREATE LOGIN zRBDg10R WITH PASSWORD = '123456RBD', CHECK_POLICY = OFF;
GO

USE RBD_g10;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'RBDg10L')
	CREATE USER RBDg10L FOR LOGIN RBDg10L;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'zRBDg10R')
	CREATE USER zRBDg10R FOR LOGIN zRBDg10R;
GO

USE RBD_g10d;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'RBDg10L')
	CREATE USER RBDg10L FOR LOGIN RBDg10L;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'zRBDg10R')
	CREATE USER zRBDg10R FOR LOGIN zRBDg10R;
GO

USE master;
GO

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'z-01')
	EXEC sp_dropserver N'z-01', 'droplogins';
GO

EXEC sp_addlinkedserver
	@server = N'z-01',
	@srvproduct = N'',
	@provider = N'MSOLEDBSQL',
	@datasrc = N'Mateusz';
GO

EXEC sp_addlinkedsrvlogin
	@rmtsrvname = N'z-01',
	@useself = N'False',
	@locallogin = N'RBDg10L',
	@rmtuser = N'zRBDg10R',
	@rmtpassword = N'123456RBD';
GO

EXEC sp_addlinkedsrvlogin
	@rmtsrvname = N'z-01',
	@useself = N'False',
	@locallogin = NULL,
	@rmtuser = N'zRBDg10R',
	@rmtpassword = N'123456RBD';
GO

EXEC sp_serveroption N'z-01', N'rpc', N'true';
EXEC sp_serveroption N'z-01', N'rpc out', N'true';
EXEC sp_serveroption N'z-01', N'remote proc transaction promotion', N'false';
GO

USE RBD_g10;
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Customers TO RBDg10L;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Orders TO RBDg10L;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.[Order Details] TO RBDg10L;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Products TO RBDg10L;
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Customers TO zRBDg10R;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Orders TO zRBDg10R;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.[Order Details] TO zRBDg10R;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Products TO zRBDg10R;
GO

USE RBD_g10d;
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Customers TO RBDg10L;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Orders TO RBDg10L;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.[Order Details] TO RBDg10L;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Products TO RBDg10L;
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Customers TO zRBDg10R;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Orders TO zRBDg10R;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.[Order Details] TO zRBDg10R;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Products TO zRBDg10R;
GO

SELECT TOP 5 *
FROM [z-01].RBD_g10d.dbo.Customers;
GO

USE RBD_g10;
GO

IF OBJECT_ID('dbo.vw_lab05_produkty_zamowienia_klienci', 'V') IS NOT NULL
	DROP VIEW dbo.vw_lab05_produkty_zamowienia_klienci;
GO

CREATE VIEW dbo.vw_lab05_produkty_zamowienia_klienci
AS
SELECT
	c.CustomerID,
	c.CompanyName AS Klient,
	o.OrderID AS NrZamowienia,
	o.OrderDate AS DataZamowienia,
	p.ProductID,
	p.ProductName AS Produkt,
	od.UnitPrice AS CenaJednostkowa,
	od.Quantity AS Ilosc,
	od.Discount AS Rabat,
	od.UnitPrice * od.Quantity * (1 - od.Discount) AS Wartosc
FROM dbo.Customers AS c
INNER JOIN [z-01].RBD_g10d.dbo.Orders AS o
	ON c.CustomerID = o.CustomerID
INNER JOIN [z-01].RBD_g10d.dbo.[Order Details] AS od
	ON o.OrderID = od.OrderID
INNER JOIN [z-01].RBD_g10d.dbo.Products AS p
	ON od.ProductID = p.ProductID;
GO

SELECT *
FROM dbo.vw_lab05_produkty_zamowienia_klienci
ORDER BY Klient, NrZamowienia;
GO

IF OBJECT_ID('dbo.usp_lab05_wartosc_sprzedazy_rok', 'P') IS NOT NULL
	DROP PROCEDURE dbo.usp_lab05_wartosc_sprzedazy_rok;
GO

CREATE PROCEDURE dbo.usp_lab05_wartosc_sprzedazy_rok
	@Rok INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		YEAR(o.OrderDate) AS Rok,
		SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS WartoscSprzedazy
	FROM [z-01].RBD_g10d.dbo.Orders AS o
	INNER JOIN [z-01].RBD_g10d.dbo.[Order Details] AS od
		ON o.OrderID = od.OrderID
	WHERE YEAR(o.OrderDate) = @Rok
	GROUP BY YEAR(o.OrderDate);
END;
GO

GRANT EXECUTE ON dbo.usp_lab05_wartosc_sprzedazy_rok TO RBDg10L;
GRANT EXECUTE ON dbo.usp_lab05_wartosc_sprzedazy_rok TO zRBDg10R;
GO

EXEC dbo.usp_lab05_wartosc_sprzedazy_rok @Rok = 1997;
GO

SET XACT_ABORT OFF;
GO

INSERT INTO[z-01].RBD_g10d.dbo.Products
	(ProductID, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
VALUES
	(999, 'LAB05_TEST_1', 1, 1, '10 boxes', 10.00, 10, 0, 0, 0);
GO

SELECT ProductID, ProductName, UnitPrice
FROM [z-01].RBD_g10d.dbo.Products
WHERE ProductName = 'LAB05_TEST_1';
GO

DELETE FROM [z-01].RBD_g10d.dbo.Products
WHERE ProductName = 'LAB05_TEST_1';
GO

INSERT INTO OPENQUERY([z-01], '
	SELECT ProductID, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued
	FROM RBD_g10d.dbo.Products
')
VALUES
	(999, 'LAB05_OPENQUERY_1', 1, 1, '10 boxes', 11.00, 11, 0, 0, 0);
GO


SELECT *
FROM OPENQUERY([z-01], '
	SELECT ProductID, ProductName, UnitPrice
	FROM RBD_g10d.dbo.Products
	WHERE ProductName = ''LAB05_OPENQUERY_1''
');
GO

DELETE FROM OPENQUERY([z-01], '
	SELECT ProductID, ProductName
	FROM RBD_g10d.dbo.Products
	WHERE ProductName = ''LAB05_OPENQUERY_1''
');
GO

/*
-- Ten fragment uruchom w Oracle jako osobny uzytkownik partnera.
-- U nas w schemacie NORTHWIND tabela EMPLOYEES juz istnieje po imporcie Northwind_Oracle.sql.

CREATE TABLE EMPLOYEES AS
SELECT * FROM NORTHWIND.EMPLOYEES;

GRANT SELECT, INSERT, UPDATE, DELETE ON EMPLOYEES TO NORTHWIND;

SELECT * FROM EMPLOYEES;
*/
GO

USE master;
GO

EXEC master.dbo.sp_MSset_oledb_prop N'OraOLEDB.Oracle', N'AllowInProcess', 1;
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
	@locallogin = N'RBDg10L',
	@rmtuser = N'NORTHWIND',
	@rmtpassword = N'12345';
GO

EXEC sp_addlinkedsrvlogin
	@rmtsrvname = N'ORACLE_PDB',
	@useself = N'False',
	@locallogin = NULL,
	@rmtuser = N'NORTHWIND',
	@rmtpassword = N'12345';
GO

SELECT *
FROM OPENQUERY(ORACLE_PDB, 'SELECT EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE FROM EMPLOYEES');
GO

INSERT INTO OPENQUERY(ORACLE_PDB, '
	SELECT EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE
	FROM EMPLOYEES
')
VALUES
	(999, 'Lab05', 'Test', 'Test insert');
GO

SELECT *
FROM OPENQUERY(ORACLE_PDB, 'SELECT EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE FROM EMPLOYEES WHERE EMPLOYEEID = 999');
GO

DELETE FROM OPENQUERY(ORACLE_PDB, '
	SELECT EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE
	FROM EMPLOYEES
	WHERE EMPLOYEEID = 999
');
GO