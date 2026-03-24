-- ===================================================================
-- ZADANIE:
-- Jaki KLIENT (Oracle: PD25)
-- zrealizował jakie ZAMÓWIENIA (lokalny SQL Server)
-- na których są jakie PRODUKTY (Access: C:\Northwind\Northwind.accdb)
-- obsłużone przez jakiego PRACOWNIKA (SQL Server: WB-09)
-- ===================================================================


-- ===================================================================
-- 1. KONFIGURACJA (uruchom najpierw)
-- ===================================================================
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
GO

EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
GO

-- Zezwól na Oracle OLE DB w procesie
EXEC master.dbo.sp_MSset_oledb_prop N'OraOLEDB.Oracle', N'AllowInProcess', 1;
-- Zezwól na Access OLE DB (ACE) — spróbuj obie wersje
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1;
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'AllowInProcess', 1;
GO

-- DIAGNOSTYKA: sprawdź które wersje ACE są zainstalowane
EXEC xp_enum_oledb_providers;
GO


-- ===================================================================
-- 2. BUDOWANIE ZAPYTANIA — KROK PO KROKU (wersja lokalna / testowa)
-- ===================================================================

USE Northwind;

-- KROK 1: Klienci — normalnie lokalnie (docelowo z Oracle PD25)
SELECT CustomerID, CompanyName, ContactName
FROM Customers;

-- KROK 2: Zamówienia + Order Details — lokalny SQL Server
SELECT
    o.OrderID,
    o.CustomerID,
    o.EmployeeID,
    od.ProductID,
    od.UnitPrice,
    od.Quantity
FROM Orders AS o
INNER JOIN [Order Details] AS od ON o.OrderID = od.OrderID;

-- KROK 3: Produkty — normalnie lokalnie (docelowo z Access)
SELECT ProductID, ProductName
FROM Products;

-- KROK 4: Pracownicy — normalnie lokalnie (docelowo z WB-09)
SELECT EmployeeID, LastName, FirstName
FROM Employees;

-- KROK 5: Złączenie lokalne — weryfikacja logiki zapytania
SELECT
    k.CompanyName   AS Klient,
    k.ContactName   AS KontaktKlienta,
    o.OrderID       AS NrZamowienia,
    p.ProductName   AS Produkt,
    od.UnitPrice    AS CenaJednostkowa,
    od.Quantity     AS Ilosc,
    e.LastName + ' ' + e.FirstName AS Pracownik
FROM Customers AS k
INNER JOIN Orders AS o         ON k.CustomerID  = o.CustomerID
INNER JOIN [Order Details] AS od ON o.OrderID   = od.OrderID
INNER JOIN Products AS p       ON od.ProductID  = p.ProductID
INNER JOIN Employees AS e      ON o.EmployeeID  = e.EmployeeID;
GO


-- ===================================================================
-- 3. WERYFIKACJA OPENROWSET — każde źródło osobno
-- ===================================================================

-- 3A. Klienci z Oracle (PD25)
SELECT a.*
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
    'SELECT CustomerID, CompanyName, ContactName FROM northwind.customers'
) AS a;
GO

-- 3B. Produkty z Access (C:\Northwind\Northwind.mdb)
SELECT
    a.IDproduktu    AS ProductID,
    a.NazwaProduktu AS ProductName
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.16.0',
    'C:\Northwind\Northwind.mdb';'admin';'',
    'SELECT IDproduktu, NazwaProduktu FROM Produkty'
) AS a;
GO

-- 3C. Pracownicy z WB-09
SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=WB-09;UID=sa;PWD=praktyka;TrustServerCertificate=yes;',
    'SELECT EmployeeID, LastName, FirstName FROM Northwind.dbo.Employees'
) AS a;
GO


-- ===================================================================
-- 4. FINALNE ZAPYTANIE z OPENROWSET (CTE)
-- ===================================================================

WITH klienci AS (
    -- Klienci z Oracle
    SELECT a.*
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
        'SELECT CustomerID, CompanyName, ContactName FROM northwind.customers'
    ) AS a
),
produkty AS (
    -- Produkty z Access (C:\Northwind\Northwind.mdb)
    SELECT
        a.IDproduktu    AS ProductID,
        a.NazwaProduktu AS ProductName
    FROM OPENROWSET(
        'Microsoft.ACE.OLEDB.16.0',
        'C:\Northwind\Northwind.mdb';'admin';'',
        'SELECT IDproduktu, NazwaProduktu FROM Produkty'
    ) AS a
),
pracownicy AS (
    -- Pracownicy z WB-09
    SELECT a.*
    FROM OPENROWSET(
        'MSOLEDBSQL',
        'Server=WB-09;UID=sa;PWD=praktyka;TrustServerCertificate=yes;',
        'SELECT EmployeeID, LastName, FirstName FROM Northwind.dbo.Employees'
    ) AS a
)

-- Zamówienia + Order Details — lokalny SQL Server, łączone ze zdalnymi źródłami
SELECT
    k.CompanyName                           AS Klient,
    k.ContactName                           AS KontaktKlienta,
    o.OrderID                               AS NrZamowienia,
    p.ProductName                           AS Produkt,
    od.UnitPrice                            AS CenaJednostkowa,
    od.Quantity                             AS Ilosc,
    pr.LastName + ' ' + pr.FirstName        AS Pracownik
FROM Northwind.dbo.Orders AS o
INNER JOIN Northwind.dbo.[Order Details] AS od  ON o.OrderID    = od.OrderID
INNER JOIN klienci AS k     ON o.CustomerID  = k.CustomerID
INNER JOIN produkty AS p    ON od.ProductID  = p.ProductID
INNER JOIN pracownicy AS pr ON o.EmployeeID  = pr.EmployeeID;
GO





-- Sterownik OLDB --> konfiguracja
-- dodanie serwera połączonego
-- mapowanie praw i nadanie uprawnień
-- ustawienie dostępu na infrastrukturze sieciowej

sp_linkedservers; -- sprawdzenie zdefiniowanych serwerów połączonych
GO

sp_addlinkedserver
    @server = 'OraclePD25',
    @provider = 'OraOLEDB.Oracle',
    @datasrc = '(DESCRIPTION =
      (ADDRESS_LIST =
        (ADDRESS = (PROTOCOL = TCP)(HOST = 212.51.216.169)(PORT = 1521))
      )
      (CONNECT_DATA =
        (SID = PD25)
      )
    )';
GO

sp_addlinkedserver
    @server = 'AccessNorthwind',
    @provider = 'Microsoft.ACE.OLEDB.16.0',
    @datasrc = 'C:\Northwind\Northwind.mdb';
GO

sp_addlinkedserver
    @server = 'WB09',
    @provider = 'MSOLEDBSQL',
    @datasrc = 'Server=WB-09;UID=sa;PWD=praktyka;TrustServerCertificate=yes;';
GO


-- Usuń istniejący serwer jeśli był już dodany (unika błędu duplikatu)
IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'WB12')
    EXEC sp_dropserver N'WB12', 'droplogins';
GO

EXECUTE sp_addlinkedserver
    @server    = N'WB12',
    @srvproduct = N'',
    @provider  = N'MSOLEDBSQL',
    @datasrc   = N'WB-12';
GO

-- dodanie logowania do serwera
sp_addlinkedsrvlogin
     @rmtsrvname = N'WB12',
     @useself = N'False',
     @locallogin = N'sa',
     @rmtuser = N'sa',
     @rmtpassword = N'praktyka';
GO

SELECT * FROM wb12.northwind.dbo.orders; -- test połączenia do WB-12
GO


-- Napisać zapytanie rozproszone:
-- pobrac wszystkich pracowników z tablie EMP schematu SCOTT

-- Zrealizać zapytanie
-- Jakie produkty (ORACLE) mają cenę ? od średniej ceny liczonej ze wszystkich produktów (serwer WB12)?