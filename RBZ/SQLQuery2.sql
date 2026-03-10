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


-- Podać jaka jest wartość sprzedarzy w poszczególnych miesiącach (serwer WB-20)
-- dwóch lat o największej realizacji sprzedaży (serwer WB-18)


    YEAR(o.OrderDate) AS Rok,
    MONTH(o.OrderDate) AS Miesiac,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS WartoscSprzedazy
FROM Northwind.dbo.Orders AS o
JOIN Northwind.dbo.[Order Details] AS od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) IN (
    -- Podzapytanie wybierające 2 lata o największej łącznej sprzedaży
    SELECT TOP 2 YEAR(o2.OrderDate)
    FROM Northwind.dbo.Orders o2
    JOIN Northwind.dbo.[Order Details] od2 ON o2.OrderID = od2.OrderID
    GROUP BY YEAR(o2.OrderDate)
    ORDER BY SUM(od2.UnitPrice * od2.Quantity * (1 - od2.Discount)) DESC
)
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
ORDER BY Rok, Miesiac;










SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=WB-07;UID=sa;PWD=praktyka;TrustServerCertificate=yes;',
    'SELECT * FROM Northwind.dbo.'
) AS a;