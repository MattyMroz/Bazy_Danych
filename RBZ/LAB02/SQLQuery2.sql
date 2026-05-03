-- Z jakiej kategorii (serwer lokalny) mamy jakie produkty (serwer zdalny --> WE-18)
-- dostarczone przez jakiego dostawce WB-18

-- ===================================================================
-- 1. KONFIGURACJA (Uruchom to najpierw, aby odblokowa� funkcje)
-- ===================================================================
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE; -- To polecenie faktycznie zatwierdza zmiany
GO

EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE; -- To odblokowuje mo�liwo�� u�ywania OPENROWSET
GO

-- Sprawdzenie czy serwer WB-18 jest ju� na li�cie (opcjonalnie)
EXEC sp_linkedservers; 
GO


-- ===================================================================
-- 2. ZADANIE 1: Metoda OPENROWSET (Dora�na, bez sta�ego po��czenia)
-- ===================================================================
-- ��czymy lokalne kategorie ze zdalnymi produktami i dostawcami
-- openrowset

SELECT 
    kat_lokalna.CategoryName, 
    zdalne.ProductName, 
    zdalne.CompanyName AS SupplierName
FROM Northwind.dbo.Categories AS kat_lokalna
INNER JOIN OPENROWSET(
    'MSOLEDBSQL',
    'Server=WB-18;UID=sa;PWD=praktyka;TrustServerCertificate=yes;',
    'SELECT p.ProductName, p.CategoryID, s.CompanyName 
     FROM Northwind.dbo.Products p 
     JOIN Northwind.dbo.Suppliers s ON p.SupplierID = s.SupplierID'
) AS zdalne ON kat_lokalna.CategoryID = zdalne.CategoryID;
GO


-- Wykorzystuj�c instrukcjie openrowset zrealizowa� zapytanie:
-- Jakie produkty kt�rych nazwa zaczyna si� na liter� od c do p
-- Servera lokalnego znajdujacego si� r�wnie� na serwerze zdalnym 'Wb-11'
-- UWAGA z serwera zdalnego maj� by� pobrane jedynie te krotki,
-- K�tre spe�niaj� kryterium klauzuili WHERE tego zapytania


SELECT 
    produkty_lokalne.ProductName AS LokalnaNazwa, 
    zdalne.ProductName AS ZdalnaNazwa
FROM Northwind.dbo.Products AS produkty_lokalne
INNER JOIN OPENROWSET(
    'MSOLEDBSQL',
    'Server=WB-11;UID=sa;PWD=praktyka;TrustServerCertificate=yes;',
    'SELECT ProductName FROM Northwind.dbo.Products WHERE ProductName LIKE ''[c-p]%'''
) AS zdalne ON produkty_lokalne.ProductName = zdalne.ProductName
WHERE produkty_lokalne.ProductName LIKE '[c-p]%'; -- tak dodatkowo


-- JAK ROBIĆ TAKIE ZADANIA:
-- Podać jaka jest wartość sprzedarzy w poszczególnych miesiącach (serwer WB-20)
-- dwóch lat o największej realizacji sprzedaży (serwer WB-18)

-- SPOSÓB BUDOWANIA TEGO TYPU ZADAŃ:

USE Northwind;


SELECT TOP 2
    YEAR(OrderDate) AS ROK, SUM(od.UnitPrice * od.Quantity) AS WARTOSC
FROM [Order Details] AS od
INNER JOIN Orders AS o ON od.OrderID = o.OrderID
GROUP BY YEAR(OrderDate)
ORDER BY WARTOSC DESC
;


SELECT
    YEAR(OrderDate) AS ROK, MONTH(OrderDate) AS MIESIAC, SUM(od.UnitPrice * od.Quantity) AS WARTOSC
FROM [Order Details] AS od
INNER JOIN Orders AS o ON od.OrderID = o.OrderID
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
;

WITH mama AS (
    SELECT TOP 2
        YEAR(OrderDate) AS ROK, SUM(od.UnitPrice * od.Quantity) AS WARTOSC
    FROM [Order Details] AS od
    INNER JOIN Orders AS o ON od.OrderID = o.OrderID
    GROUP BY YEAR(OrderDate)
    ORDER BY WARTOSC DESC
), tata AS(

    SELECT
        YEAR(OrderDate) AS ROK, MONTH(OrderDate) AS MIESIAC, SUM(od.UnitPrice * od.Quantity) AS WARTOSC
    FROM [Order Details] AS od
    INNER JOIN Orders AS o ON od.OrderID = o.OrderID
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)

)

SELECT 
t.ROK, t.MIESIAC, t.WARTOSC
FROM mama AS m
INNER JOIN tata AS t ON m.ROK = t.ROK;

-- PRZYKŁAD OPENROWSET

SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=WB-20;UID=sa;PWD=praktyka;TrustServerCertificate=yes;',
    '
    
SELECT TOP 2
YEAR(OrderDate) AS ROK, SUM(od.UnitPrice * od.Quantity) AS WARTOSC
FROM  Northwind.dbo.[Order Details] AS od
INNER JOIN  Northwind.dbo.Orders AS o ON od.OrderID = o.OrderID
GROUP BY YEAR(OrderDate)
ORDER BY WARTOSC DESC
    
    '
) AS a;


SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=WB-18;UID=sa;PWD=praktyka;TrustServerCertificate=yes;',
    '
    
    SELECT
        YEAR(OrderDate) AS ROK, MONTH(OrderDate) AS MIESIAC, SUM(od.UnitPrice * od.Quantity) AS WARTOSC
    FROM Northwind.dbo.[Order Details] AS od
    INNER JOIN Northwind.dbo.Orders AS o ON od.OrderID = o.OrderID
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
    
    '
) AS a;

GO


-- ZADANIE:
WITH mama AS (

SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=WB-20;UID=sa;PWD=praktyka;TrustServerCertificate=yes;',
    '

    SELECT TOP 2
    YEAR(OrderDate) AS ROK, SUM(od.UnitPrice * od.Quantity) AS WARTOSC
    FROM  Northwind.dbo.[Order Details] AS od
    INNER JOIN  Northwind.dbo.Orders AS o ON od.OrderID = o.OrderID
    GROUP BY YEAR(OrderDate)
    ORDER BY WARTOSC DESC

    '
) AS a

), tata AS(

    SELECT a.*
    FROM OPENROWSET(
        'MSOLEDBSQL',
        'Server=WB-18;UID=sa;PWD=praktyka;TrustServerCertificate=yes;',
        '
    
        SELECT
        YEAR(OrderDate) AS ROK, MONTH(OrderDate) AS MIESIAC, SUM(od.UnitPrice * od.Quantity) AS WARTOSC
        FROM Northwind.dbo.[Order Details] AS od
        INNER JOIN Northwind.dbo.Orders AS o ON od.OrderID = o.OrderID
        GROUP BY YEAR(OrderDate), MONTH(OrderDate)
    
        '
    ) AS a

)

SELECT 
t.ROK, t.MIESIAC, t.WARTOSC
FROM mama AS m
INNER JOIN tata AS t ON m.ROK = t.ROK;

ORACLE:
\\wenus\zadania\PD\2.ORACLE\0.1.INSTALACJA


PD251190
12345




-- ORACLE
-- SELECT to_char(SYSDATE, 'YYYY-MM-DD:HH24:Mi') FROM dual;

EXEC master.dbo.sp_MSset_oledb_prop N'OraOLEDB.Oracle', N'AllowInProcess', 1;



SELECT a.*
FROM OPENROWSET(
    'OraOLEDB.Oracle',
    'Server=PD25;UID=PD251190;PWD=12345;TrustServerCertificate=yes;',
    '
        SELECT to_char(SYSDATE, ''YYYY-MM-DD:HH24:Mi'') FROM dual
    '
) AS a;


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
    '
        SELECT to_char(SYSDATE, ''YYYY-MM-DD:HH24:Mi'') FROM dual
    '

) AS a;

CREATE OR ALTER VIEW V1
WITH ENCRYPTION AS
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
    'SELECT * FROM northwind.products'
) AS a;
GO

sp_helptext v1

SELECT * FROM V1;