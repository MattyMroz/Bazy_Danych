--Mateusz Mróz
--251190

Zaliczenie (proszę o realizację wszystkich poniższych punktów):

0. W systemie SQLServer założyć login ZAL (hasło: 12345) oraz użytkownika w bazie danych NORTHWIND z prawami  tylko do czytania i wstawiania danych do tabeli EMPLOYEES, EMPLOYEES, ORDERS, "Order details", PRODUCTS, CATEGORIES oraz możliwością tworzenia widoków i  procedur składowanych w schemacie dbo. W systemie ORACLE  pracujemy  z wykorzystaniem własnego użytkownika PD<album> (hasło: 12345) oraz z dostępem do skopiowanych do własnego schematu tabel:   EMPLOYEES, CUSTOMERS, ORDERS, ORDERDETAILS, CATEGORIES do których należy nadać uprawnienia do czytania i wstawiania danych.

1. W systemie SQL Server ustanowić serwer połączony ORACLE z wykorzystaniem loginu: ZAL  (SQLServer) oraz   PD<album> hasło: 12345 (ORACLE).

2.  Napisz zapytanie z bezwzględną identyfikacją obiektów: jaki pracownik tab. EMPLOYEES(kolumny: LASTNAME, FIRSTNAME- ORALCE) obsłużył jaką ilość różnych produktów (SQLServer). 

3. Napisać procedurę bez parametrów wejściowych która zawiera zapytanie przekazujące (przetwarzanie zdalne dla wybranych tabel przez OPENQUERY) : Która kategoria produktów (tabela CATEGORIES na ORACLE) zanotowała największy procentowy spadek przychodów w 1998 roku w porównaniu do 1997 roku (tabela ORDERS,  "Order details" serwera lokalnego), biorąc pod uwagę tylko klientów (tabela CUSTOMERS  na ORACLE), którzy mieszkają w tym samym kraju (pole Country w tabeli CUSTOMERS), co biuro spedytora (tabela SHIPPERS serwera lokalnego)? Podać przykłady instrukcji wyzwalania procedury przechowywanej.

4. Opracować widok (zaszyfrowany) w bazie NORTHWIND (SQL Server), przez który możliwa będzie operacja wstawiania danych do tabeli CATEGORIES(UWAGA !!! - tabela na ORACLE założona we własnym schemacie na podstawie schematu NORTHWIND) - Wykonać operację wstawiania danych przez ten widok (wykorzystując serwer ORACLE - ustanowiony jako serwer zdalny). Podać przykłady instrukcji wstawiającej dane do systemu ORACLE.

5. Napisać zapytanie z wykorzystaniem funkcji OPENROWSET():  Jaki pracownik tab. EMPLOYEES (SQL Server) obsłużył jakie zamówienie tab. ORDERS (ORACLE), które zostało obsłużone przez jakiego pracownika (ACCESS).


EXEC sp_configure 'show advanced options', 1
reconfigure

EXEC sp_configure 'Ad Hoc Distributed Queries', 1
reconfigure

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


-- 0
USE master
CREATE LOGIN ZAL WITH PASSWORD = '12345', CHECK_POLICY = OFF

USE Northwind;


CREATE USER ZAL FOR LOGIN ZAL;


GRANT SELECT, INSERT ON dbo.Employees TO ZAL;
GRANT SELECT, INSERT ON dbo.Orders TO ZAL;
GRANT SELECT, INSERT ON dbo.[Order Details] TO ZAL;
GRANT SELECT, INSERT ON dbo.Products TO ZAL;
GRANT SELECT, INSERT ON dbo.Categories TO ZAL;
GRANT CREATE VIEW TO ZAL;
GRANT CREATE PROCEDURE TO ZAL;
GRANT ALTER ON SCHEMA::dbo TO ZAL;

--1
USE master

EXEC sp_addlinkedserver
@server= 'ORACLE',
@srvproduct = 'Oracle',
@provider = 'OraOLEDB.Oracle',
@datasrc = '(DESCRIPTION =
(ADDRESS_LIST =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 212.51.216.169)(PORT = 1521))
)
(CONNECT_DATA =
    (SID = PD25)
)
)'


EXEC sp_addlinkedsrvlogin
@rmtsrvname = 'ORACLE',
@useself = 'false',
@locallogin  = 'ZAL',
@rmtuser = 'PD251190',
@rmtpassword = '12345';

EXEC sp_addlinkedsrvlogin
@rmtsrvname  = 'ORACLE',
@useself     = 'false',
@locallogin  = NULL,
@rmtuser     = 'PD251190',
@rmtpassword = '12345'


EXEC sp_serveroption 'ORACLE', 'data access', 'true'
EXEC sp_serveroption 'ORACLE', 'rpc', 'true'
EXEC sp_serveroption 'ORACLE', 'rpc out', 'true'


-- test
EXEC sp_linkedservers
SELECT TOP 1 * FROM OPENQUERY(ORACLE, 'SELECT EmployeeID, LastName, FirstName FROM Employees')


--2
SELECT
e.LastName,
e.FirstName,
COUNT(DISTINCT od.ProductID)  AS IleProd
FROM Northwind.dbo.Employees e
INNER JOIN Northwind.dbo.Orders o ON e.EmployeeID = o.EmployeeID
INNER JOIN Northwind.dbo.[Order Details]  od ON o.OrderID  = od.OrderID
GROUP BY e.LastName, e.FirstName
ORDER BY IleProd DESC


SELECT EmployeeID, LastName, FirstName FROM Employees
SELECT * FROM OPENQUERY(ORACLE, 'SELECT EmployeeID, LastName, FirstName FROM Employees')

SELECT OrderID, EmployeeID FROM Orders
SELECT * FROM OPENQUERY(ORACLE, 'SELECT OrderID, EmployeeID FROM Orders')

SELECT TOP 5 * FROM Northwind.dbo.[Order Details]

SELECT TOP 5 * FROM Northwind.dbo.Products


SELECT
e.LastName,
e.FirstName,
COUNT(DISTINCT p.ProductID)  AS IleProd
FROM OPENQUERY(ORACLE, 'SELECT EmployeeID, LastName, FirstName FROM Employees') e
INNER JOIN OPENQUERY(ORACLE, 'SELECT OrderID, EmployeeID FROM Orders') o ON e.EmployeeID = o.EmployeeID
INNER JOIN Northwind.dbo.[Order Details] od  ON o.OrderID = od.OrderID
INNER JOIN Northwind.dbo.Products p  ON od.ProductID = p.ProductID
GROUP BY e.LastName, e.FirstName
ORDER BY IleProd DESC


--3
USE Northwind

SELECT * FROM OPENQUERY(ORACLE, 'SELECT CustomerID, Country FROM Customers')
SELECT * FROM OPENQUERY(ORACLE, 'SELECT CategoryID, CategoryName FROM Categories')
SELECT * FROM Northwind.dbo.Shippers

SELECT TOP 5 OrderID, CustomerID, OrderDate, ShipVia
FROM Northwind.dbo.Orders
WHERE YEAR(OrderDate) IN (1997, 1998)

go

CREATE OR ALTER PROCEDURE dbo.PROC3
AS
WITH
OracleCustomers AS (
    SELECT * FROM OPENQUERY(ORACLE, 'SELECT CustomerID, Country FROM Customers')
),
OracleCategories AS (
    SELECT * FROM OPENQUERY(ORACLE, 'SELECT CategoryID, CategoryName FROM Categories')
),
ShippersCountry AS (
    SELECT ShipperID, Country FROM Northwind.dbo.Shippers
),
)

EXEC dbo.PROC3

--4

SELECT * FROM OPENQUERY(ORACLE, 'SELECT CategoryID, CategoryName FROM Categories')

USE Northwind

CREATE OR ALTER VIEW dbo.V_OracleCategories
WITH ENCRYPTION
AS
SELECT
CategoryID,
CategoryName
FROM ORACLE..PD251190.CATEGORIES;



INSERT INTO 
dbo.V_OracleCategories (CategoryID, CategoryName)
    VALUES (101, 'TestKat1')

INSERT INTO
dbo.V_OracleCategories (CategoryID, CategoryName)
    VALUES (102, 'TestKat2')

SELECT *
FROM OPENQUERY(
ORACLE,
'SELECT CategoryID, CategoryName  
FROM Categories 
ORDER BY CategoryID DESC');



--5
SELECT * FROM OPENROWSET(
'MSOLEDBSQL',
'Server=WB-20;Database=Northwind;UID=sa;PWD=praktyka;',
'SELECT EmployeeID, LastName, FirstName FROM dbo.Employees'
)

SELECT * FROM OPENROWSET(
'OraOLEDB.Oracle',
'(DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 212.51.216.169)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SID = PD25)
    )
  )';'PD251190';'12345',
'SELECT OrderID, EmployeeID, OrderDate FROM Orders'
)

SELECT * FROM OPENROWSET(
'Microsoft.ACE.OLEDB.12.0',
'C:\Northwind\Northwind.mdb';'admin';'',
'SELECT * FROM Pracownicy'
)

SELECT
o.OrderID,
o.OrderDate,
es.EmployeeID,
es.LastName,
es.FirstName,
ea.IDpracownika,
ea.Nazwisko,
ea.Imię
FROM OPENROWSET(
'OraOLEDB.Oracle',
'(DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 212.51.216.169)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SID = PD25)
    )
  )';'PD251190';'12345',
'SELECT OrderID, EmployeeID, OrderDate FROM Orders'
) AS o
INNER JOIN OPENROWSET(
'MSOLEDBSQL',
'Server=WB-20;Database=Northwind;UID=sa;PWD=praktyka;',
'SELECT EmployeeID, LastName, FirstName FROM dbo.Employees'
) AS es ON es.EmployeeID = o.EmployeeID
INNER JOIN OPENROWSET(
'Microsoft.ACE.OLEDB.12.0',
'C:\Northwind\Northwind.mdb';'admin';'',
'SELECT IDpracownika, Nazwisko, Imię FROM Pracownicy'
) AS ea ON ea.IDpracownika = o.EmployeeID
ORDER BY o.OrderID
GO