/* ============================================================
   KOLOS RBD — SCIAGA / NOTATKA
   ============================================================
   Spis tresci:
   0.  Konfiguracja srodowiska (raz na sesje)
   1.  4-czlonowa identyfikacja obiektu
   2.  OPENROWSET — Ad Hoc (bez linked servera)
       2a. SQL Server  -> SQL Server
       2b. SQL Server  -> Oracle
       2c. SQL Server  -> Access (.mdb)
       2d. SQL Server  -> Excel  (.xlsx)
       2e. Multi-zrodlo (SQL + Oracle + Access)
   3.  LINKED SERVER — sp_addlinkedserver + sp_addlinkedsrvlogin
       3a. SQL  -> SQL
       3b. SQL  -> Oracle
       3c. SQL  -> Access
       3d. SQL  -> Excel
       3e. Mapowanie loginu lokalnego na zdalny
   4.  OPENQUERY — przekazywanie zapytan do linked servera
       (SELECT / INSERT / UPDATE / DELETE)
   5.  Widoki rozproszone (w tym WITH ENCRYPTION)
   6.  Procedury rozproszone (z parametrami i OPENROWSET)
   7.  Transakcja rozproszona (BEGIN DISTRIBUTED TRANSACTION + DTC)
   8.  Loginy / uzytkownicy / prawa (SQL Server)
   9.  Oracle — uzytkownik NORTHWIND, prawa, role
   10. Cheatsheet — funkcje pomocnicze
   11. Najczestsze pulapki na kolokwium
   ============================================================ */


/* ============================================================
   0. KONFIGURACJA SRODOWISKA — odpalic raz na sesje
   ============================================================ */

USE master;
GO

EXEC sp_configure 'show advanced options', 1; RECONFIGURE;
EXEC sp_configure 'Ad Hoc Distributed Queries', 1; RECONFIGURE;
GO

-- AllowInProcess + DynamicParameters dla kazdego sterownika OLE DB ktory uzywamy
EXEC master.dbo.sp_MSset_oledb_prop 'MSOLEDBSQL',              'AllowInProcess',    1;
EXEC master.dbo.sp_MSset_oledb_prop 'MSOLEDBSQL',              'DynamicParameters', 1;
EXEC master.dbo.sp_MSset_oledb_prop 'OraOLEDB.Oracle',         'AllowInProcess',    1;
EXEC master.dbo.sp_MSset_oledb_prop 'OraOLEDB.Oracle',         'DynamicParameters', 1;
EXEC master.dbo.sp_MSset_oledb_prop 'Microsoft.ACE.OLEDB.12.0','AllowInProcess',    1;
EXEC master.dbo.sp_MSset_oledb_prop 'Microsoft.ACE.OLEDB.12.0','DynamicParameters', 1;
GO

-- Co jest dostepne:
EXEC sp_enum_oledb_providers;
EXEC sp_linkedservers;
GO

-- Infrastruktura (poza SQL):
-- 1) SQL Server Configuration Manager -> TCP/IP enabled, port 1433, SQL Browser auto+start
-- 2) Firewall: regula przychodzaca TCP 1433 (i 1521 dla Oracle)
-- 3) Konto uslugi MSSQLSERVER musi miec dostep do plikow Access/Excel (Win+R services.msc)
-- 4) Folder z Access/Excel: prawa "Everyone" -> read
-- 5) Oracle Net Manager: Service Naming -> wpis (host, port 1521, SERVICE_NAME=PDB)


/* ============================================================
   1. 4-CZLONOWA IDENTYFIKACJA OBIEKTU
   ============================================================ */

-- <Serwer>.<Baza>.<Schemat>.<Obiekt>
SELECT * FROM Mateusz.Northwind.dbo.Categories;
SELECT * FROM Northwind.dbo.Categories;          -- serwer = lokalny
SELECT * FROM Northwind..Categories;             -- schemat = domyslny (dbo)


/* ============================================================
   2. OPENROWSET — AD HOC (bez stalego linked servera)
   ============================================================
   Skladnia ogolna:
   OPENROWSET( '<provider>', '<connection-string>'  ;'<user>';'<pwd>',
               '<query do zdalnego zrodla>')
   Kazde wystapienie tworzy osobne polaczenie -> drogo!
   ============================================================ */

-- 2a. SQL -> SQL (Trusted_Connection)
SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
    'SELECT CategoryID, CategoryName FROM dbo.Categories'
) AS a;

-- 2a. SQL -> SQL (login + haslo)
SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=Mateusz;UID=sa;PWD=praktyka;',
    'SELECT * FROM Northwind.dbo.Categories'
) AS a;

-- alternatywna skladnia z trzema apostrofowanymi czesciami
SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Mateusz';'sa';'praktyka',
    'SELECT * FROM Northwind.dbo.Categories'
) AS a;


-- 2b. SQL -> Oracle
SELECT a.*
FROM OPENROWSET(
    'OraOLEDB.Oracle',
    '(DESCRIPTION =
        (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.64.133)(PORT = 1521))
        (CONNECT_DATA = (SERVICE_NAME = PDB))
    )';'NORTHWIND';'12345',
    'SELECT ProductID, ProductName, UnitPrice FROM Products'
) AS a;
-- Uwaga: w Oracle nazwy bez cudzyslowu sa case-insensitive,
--        haslo natomiast JEST case-sensitive.


-- 2c. SQL -> Access (.mdb)
SELECT a.*
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'C:\Northwind\Northwind.mdb';'admin';'',
    'SELECT IDproduktu, NazwaProduktu FROM Produkty'
) AS a;


-- 2d. SQL -> Excel (.xlsx)
SELECT a.*
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'Excel 12.0;Database=C:\Northwind\listy.xlsx;HDR=YES;',
    'SELECT * FROM [oceny_do_www$] WHERE Ocena >= 3'
) AS a;


-- 2e. Multi-zrodlo (sprzezenie SQL + Oracle + Access) — uzywaj CTE
;WITH klienci AS (
    SELECT c.*
    FROM OPENROWSET(
        'OraOLEDB.Oracle',
        '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.64.133)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=PDB)))';'NORTHWIND';'12345',
        'SELECT CustomerID, CompanyName FROM Customers'
    ) AS c
),
zamowienia AS (
    SELECT o.*
    FROM OPENROWSET(
        'MSOLEDBSQL',
        'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
        'SELECT OrderID, CustomerID, EmployeeID FROM dbo.Orders'
    ) AS o
),
produkty AS (
    SELECT p.IDproduktu AS ProductID, p.NazwaProduktu AS ProductName
    FROM OPENROWSET(
        'Microsoft.ACE.OLEDB.12.0',
        'C:\Northwind\Northwind.mdb';'admin';'',
        'SELECT IDproduktu, NazwaProduktu FROM Produkty'
    ) AS p
)
SELECT k.CompanyName, z.OrderID, p.ProductName
FROM zamowienia z
JOIN klienci  k ON z.CustomerID = k.CustomerID
JOIN Northwind.dbo.[Order Details] od ON z.OrderID = od.OrderID
JOIN produkty p ON od.ProductID = p.ProductID;


/* ============================================================
   3. LINKED SERVER — staly link do zdalnego zrodla
   ============================================================
   sp_addlinkedserver       -- tworzy polaczenie
   sp_addlinkedsrvlogin     -- mapuje login lokalny -> zdalny
   sp_serveroption          -- wlacza RPC, data access itd.
   sp_dropserver ... 'droplogins'
   ============================================================ */

-- Wzorzec: zawsze sprzatamy stary, potem zakladamy nowy.
USE master;
GO

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = 'LS_NAZWA')
    EXEC sp_dropserver 'LS_NAZWA', 'droplogins';
GO


-- 3a. SQL -> SQL
EXEC sp_addlinkedserver
    @server     = 'LS_SQL',
    @srvproduct = '',
    @provider   = 'MSOLEDBSQL',
    @datasrc    = 'Mateusz',          -- nazwa zdalnej instancji SQL
    @catalog    = 'Northwind';

-- mapowanie: kazdy lokalny login -> uzyj swojego (Trusted)
EXEC sp_addlinkedsrvlogin 'LS_SQL', 'true', NULL;

-- mapowanie: konkretny lokalny login -> zdalny user/pwd
EXEC sp_addlinkedsrvlogin
    @rmtsrvname = 'LS_SQL',
    @useself    = 'false',
    @locallogin = 'RBDg10L',          -- NULL = wszyscy nie wymienieni
    @rmtuser    = 'zRBDg10R',
    @rmtpassword= '123456RBD';

EXEC sp_serveroption 'LS_SQL', 'data access', 'true';
EXEC sp_serveroption 'LS_SQL', 'rpc',         'true';
EXEC sp_serveroption 'LS_SQL', 'rpc out',     'true';
GO


-- 3b. SQL -> Oracle
EXEC sp_addlinkedserver
    @server     = 'LS_ORA',
    @srvproduct = 'Oracle',
    @provider   = 'OraOLEDB.Oracle',
    @datasrc    = '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.64.133)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=PDB)))';

EXEC sp_addlinkedsrvlogin 'LS_ORA', 'false', NULL, 'NORTHWIND', '12345';
EXEC sp_serveroption 'LS_ORA', 'rpc',     'true';
EXEC sp_serveroption 'LS_ORA', 'rpc out', 'true';
GO


-- 3c. SQL -> Access
EXEC sp_addlinkedserver
    @server     = 'LS_ACC',
    @srvproduct = 'Access',
    @provider   = 'Microsoft.ACE.OLEDB.12.0',
    @datasrc    = 'C:\Northwind\Northwind.mdb';

EXEC sp_addlinkedsrvlogin 'LS_ACC', 'false', NULL, 'Admin', '';
EXEC sp_serveroption 'LS_ACC', 'data access', 'true';
GO


-- 3d. SQL -> Excel
EXEC sp_addlinkedserver
    @server     = 'LS_XLS',
    @srvproduct = 'Excel',
    @provider   = 'Microsoft.ACE.OLEDB.12.0',
    @datasrc    = 'C:\Northwind\listy.xlsx',
    @provstr    = 'Excel 12.0;HDR=YES';

EXEC sp_addlinkedsrvlogin 'LS_XLS', 'false', NULL, 'Admin', '';
EXEC sp_serveroption 'LS_XLS', 'data access', 'true';
GO


-- 3e. Sprawdzenie:
EXEC sp_linkedservers;
EXEC sp_helpserver  'LS_SQL';
EXEC sp_tables_ex   'LS_SQL';
EXEC sp_columns_ex  'LS_SQL', NULL, NULL, 'Products';


/* ============================================================
   4. OPENQUERY — przekazywanie zapytania do linked servera
   ============================================================
   Wszystko w '<query>' wykonuje sie po stronie ZDALNEJ.
   Apostrofy w srodku podwajamy: '' -> '
   Dziala SELECT / INSERT / UPDATE / DELETE.
   ============================================================ */

-- SELECT
SELECT * FROM OPENQUERY(LS_SQL,
    'SELECT ProductID, ProductName, UnitPrice
     FROM Northwind.dbo.Products
     WHERE UnitPrice > 20');

-- 4-czlonowy zapis (alternatywa, robi wiecej po lokalnej stronie)
SELECT * FROM LS_SQL.Northwind.dbo.Products WHERE UnitPrice > 20;

-- INSERT przez OPENQUERY
INSERT INTO OPENQUERY(LS_SQL,
    'SELECT ProductID, ProductName, SupplierID, CategoryID,
            QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder,
            ReorderLevel, Discontinued
     FROM RBD_g10d.dbo.Products')
VALUES (999, 'TEST', 1, 1, '10 boxes', 11.00, 11, 0, 0, 0);

-- UPDATE przez OPENQUERY
UPDATE OPENQUERY(LS_SQL, 'SELECT ProductID, UnitPrice FROM RBD_g10d.dbo.Products WHERE ProductID = 999')
SET UnitPrice = 12.00;

-- DELETE przez OPENQUERY
DELETE FROM OPENQUERY(LS_SQL, 'SELECT ProductID FROM RBD_g10d.dbo.Products WHERE ProductID = 999');

-- EXEC procedury zdalnej (Oracle)
EXEC ('BEGIN DODAJ_KOLEGE_ORACLE(1,''Nowak'',''Anna''); END;') AT LS_ORA;


/* ============================================================
   5. WIDOKI ROZPROSZONE
   ============================================================
   - WITH ENCRYPTION         -> tresc widoku ukryta w sys.sql_modules
   - WITH SCHEMABINDING      -> wiazanie ze schematem (tylko obiekty bez serwera zdalnego)
   - Rzutuj typy z Oracle (NUMBER, DATE) na typy SQL Server (INT, DATETIME).
   - W widoku z OPENROWSET trzeba podac KAZDE OPENROWSET osobno (nie da sie dac samego linked servera w 4-czlonowym zapisie i miec OPENROWSET-a w jednym widoku — ale dwa OPENROWSET-y w jednym widoku jak najbardziej dziala).
   ============================================================ */

CREATE OR ALTER VIEW dbo.Widok1
WITH ENCRYPTION
AS
SELECT
    e.EmployeeID,
    e.LastName,
    o.OrderID,
    p.ProductID,
    p.ProductName
FROM OPENROWSET(
    'OraOLEDB.Oracle',
    '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.64.133)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=PDB)))';'NORTHWIND';'12345',
    'SELECT EmployeeID, LastName FROM Employees'
) AS e
INNER JOIN OPENROWSET(
    'OraOLEDB.Oracle',
    '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.64.133)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=PDB)))';'NORTHWIND';'12345',
    'SELECT OrderID, EmployeeID FROM Orders'
) AS o ON e.EmployeeID = o.EmployeeID
INNER JOIN Northwind.dbo.[Order Details] AS od ON o.OrderID = od.OrderID
INNER JOIN Northwind.dbo.Products AS p        ON od.ProductID = p.ProductID;
GO

-- Sprawdzenie szyfrowania:
SELECT definition FROM sys.sql_modules
WHERE object_id = OBJECT_ID('dbo.Widok1');   -- powinno zwrocic NULL


/* ============================================================
   6. PROCEDURY ROZPROSZONE
   ============================================================
   - Parametry @In typowane jak w SQL Server.
   - Wewnatrz mozna miec OPENROWSET / OPENQUERY / 4-czlonowy zapis.
   - SET NOCOUNT ON na poczatku, by nie zwracal "(N rows affected)".
   - Aby procedura przyjmowala parametr w OPENROWSET-cie -> trzeba
     skleic dynamic SQL (EXEC sp_executesql).
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.PROC4
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX) = N'
        SELECT
            c.CategoryName,
            SUM(od.UnitPrice * od.Quantity) AS WartoscBezRabatu
        FROM OPENROWSET(
            ''Microsoft.ACE.OLEDB.12.0'',
            ''C:\Northwind\Northwind.mdb'';''admin'';'''',
            ''SELECT IDzamowienia, IDproduktu, CenaJednostkowa, Ilosc
              FROM [Szczegoly zamowienia]
              WHERE IDzamowienia = ' + CAST(@OrderID AS NVARCHAR(10)) + '''
        ) AS od
        INNER JOIN Northwind.dbo.Products   AS p ON od.IDproduktu = p.ProductID
        INNER JOIN Northwind.dbo.Categories AS c ON p.CategoryID  = c.CategoryID
        GROUP BY c.CategoryName
        ORDER BY c.CategoryName;';

    EXEC sp_executesql @sql;
END;
GO

-- Wywolanie (rozne sposoby przekazania parametru):
EXEC dbo.PROC4 10248;                           -- pozycyjnie
EXEC dbo.PROC4 @OrderID = 10248;                -- nazwany
DECLARE @id INT = 10250; EXEC dbo.PROC4 @id;    -- ze zmiennej


/* ============================================================
   7. TRANSAKCJA ROZPROSZONA (MS DTC)
   ============================================================
   - Wymaga uruchomionego Distributed Transaction Coordinator
     (services.msc -> MSDTC).
   - W dcomcnfg: Component Services -> My Computer -> DTC ->
     Local DTC -> Properties -> Security:
       * Network DTC Access
       * Allow Inbound / Outbound
       * Enable XA Transactions
       * No Authentication Required
   - Firewall: msdtc.exe + port 135 (RPC).
   - SET XACT_ABORT ON -> kazdy blad rollback'uje cala transakcje.
   ============================================================ */

USE Northwind;
SET XACT_ABORT ON;
GO

BEGIN TRY
    BEGIN DISTRIBUTED TRANSACTION;

    -- lokalnie
    INSERT INTO dbo.koledzy(indeks, nazwisko, imie)
    VALUES (61001, 'Kowalski', 'Jan');

    -- zdalnie (Oracle przez linked server)
    EXEC ('BEGIN INSERT INTO KOLEDZY VALUES (61001,''Kowalski'',''Jan''); END;') AT LS_ORA;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO


/* ============================================================
   8. LOGINY / UZYTKOWNICY / PRAWA — SQL Server
   ============================================================ */

USE master;
CREATE LOGIN ZA23 WITH PASSWORD = '12345', CHECK_POLICY = OFF;
GO

USE Northwind;
CREATE USER ZA23 FOR LOGIN ZA23;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO ZA23;
GRANT EXECUTE ON dbo.PROC4 TO ZA23;
GO

-- Sprzatanie:
-- DROP USER ZA23;
-- DROP LOGIN ZA23;


/* ============================================================
   9. ORACLE — uzytkownik NORTHWIND (uruchamiac w SQL Developer / sqlplus)
   ============================================================
   ALTER SESSION SET CONTAINER = PDB;

   CREATE USER NORTHWIND IDENTIFIED BY "12345"
       DEFAULT TABLESPACE USERS
       TEMPORARY TABLESPACE TEMP;

   GRANT CONNECT, RESOURCE TO NORTHWIND;
   ALTER USER NORTHWIND DEFAULT ROLE CONNECT, RESOURCE;
   GRANT CREATE VIEW TO NORTHWIND;
   GRANT UNLIMITED TABLESPACE TO NORTHWIND;

   -- gdy juz istnieje:
   ALTER USER NORTHWIND IDENTIFIED BY "12345" ACCOUNT UNLOCK;

   -- prawa obiektowe na konkretna tabele:
   GRANT SELECT, INSERT, UPDATE, DELETE ON KOLEDZY TO PUBLIC;
   ============================================================ */


/* ============================================================
   10. CHEATSHEET — funkcje pomocnicze
   ============================================================
   sp_configure 'show advanced options', 1
   sp_configure 'Ad Hoc Distributed Queries', 1
   sp_MSset_oledb_prop '<provider>', 'AllowInProcess', 1
   sp_enum_oledb_providers
   sp_linkedservers
   sp_helpserver       '<LS>'
   sp_catalogs         '<LS>'
   sp_tables_ex        '<LS>'
   sp_columns_ex       '<LS>', NULL, NULL, '<tabela>'
   sp_addlinkedserver  @server, @srvproduct, @provider, @datasrc [, @catalog, @provstr]
   sp_addlinkedsrvlogin @rmtsrvname, @useself, @locallogin, @rmtuser, @rmtpassword
   sp_serveroption     '<LS>', 'rpc'/'rpc out'/'data access', 'true'
   sp_dropserver       '<LS>', 'droplogins'
   ============================================================ */


/* ============================================================
   11. NAJCZESTSZE PULAPKI
   ============================================================
   - Brak 'Ad Hoc Distributed Queries' = 1  ->  OPENROWSET nie dziala.
   - Brak AllowInProcess = 1 dla ACE/Oracle  ->  64-bit SQL Server failuje.
   - SQL Server uruchomiony jako "NT Service\..." nie ma dostepu do C:\Northwind.
     -> services.msc -> MSSQLSERVER -> Log On -> Local System
        + na folderze "Everyone" Read.
   - Apostrofy w OPENQUERY podwajamy: 'WHERE Name = ''ABC'''.
   - W Oracle nazwa bez cudzyslowu = duze litery; haslo case-sensitive.
   - Dla linked Oracle uzywaj OPENQUERY (po stronie zdalnej) albo
     czteroczlonowo z TO_CHAR/CAST (typy NUMBER/DATE).
   - Widok z OPENROWSET musi miec apostrofy w connection-stringu
     podwojone, jesli tworzysz go przez dynamiczny SQL.
   - WITH ENCRYPTION  ->  nie da sie pozniej podejrzec definicji,
     wiec trzymaj kopie skryptu.
   - DTC: bez wlaczonego Network DTC Access dostaniesz
     "Unable to begin a distributed transaction".
   - SET XACT_ABORT ON jest praktycznie obowiazkowe dla DTC.
   ============================================================ */
