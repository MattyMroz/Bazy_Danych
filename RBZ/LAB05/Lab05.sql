-- =============================================================================
-- LAB 05 â€” Rozproszone Bazy Danych (RBZ)
-- Praca GRUPOWA: 2 osoby, 2 komputery
-- =============================================================================
-- TWĂ“J komputer (serwer lokalny):   WB-20
-- Komputer KOLEGI (serwer zdalny):  WB-18
-- Grupa: g10
-- Serwer poĹ‚Ä…czony:                 z-01 (wskazuje na WB-18)
-- =============================================================================
-- WAĹ»NE: Obaj wykonujecie te same kroki, ale:
--   - Na TWOIM WB-20: linked server z-01 â†’ WB-18
--   - Na WB-18 kolegi: linked server â†’ WB-20 (lustrzane)
-- KaĹĽdy tworzy JEDNÄ„ bazÄ™ RBD_g10 na swoim komputerze.
-- =============================================================================


-- =============================================================================
-- ZADANIE 1: Utworzenie bazy danych RBD_g10
-- INSTRUKCJA: KaĹĽdy tworzy bazÄ™ na SWOIM serwerze. Nie tworzysz bazy na komputerze kolegi.
-- =============================================================================

USE master;
GO

IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'RBD_g10')
    CREATE DATABASE RBD_g10;
GO


-- =============================================================================
-- ZADANIE 2: Utworzenie tabel na podstawie NorthWind
-- INSTRUKCJA: Kopiujemy strukturÄ™ + dane z Northwind do bazy RBD_g10
-- Tabele: Customers, Orders, [Order Details], Products
-- Wykonaj to na SWOIM komputerze WB-20
-- =============================================================================

USE RBD_g10;
GO

-- Customers
SELECT * INTO Customers FROM Northwind.dbo.Customers;
GO

-- Products
SELECT * INTO Products FROM Northwind.dbo.Products;
GO

-- Orders
SELECT * INTO Orders FROM Northwind.dbo.Orders;
GO

-- Order Details
SELECT * INTO [Order Details] FROM Northwind.dbo.[Order Details];
GO


-- =============================================================================
-- ZADANIE 3: Utworzenie loginĂłw i uĹĽytkownikĂłw
-- INSTRUKCJA: 
--   Login LOKALNY:  RBDg10L   (hasĹ‚o: 123456RBD) â€” dla Ciebie, do pracy lokalnej
--   Login ZDALNY:   zRBDg10R  (hasĹ‚o: 123456RBD) â€” dla kolegi, ktĂłry Ĺ‚Ä…czy siÄ™ DO CIEBIE
--   
--   Na WB-20 (Ty):  tworzysz OBA loginy
--   Na WB-18 (kolega): tworzy OBA loginy u siebie (lustrzane)
-- =============================================================================

USE master;
GO

-- Login lokalny â€” Ty bÄ™dziesz go uĹĽywaÄ‡ do Ĺ‚Ä…czenia siÄ™ ze zdalnym serwerem
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'RBDg10L')
    CREATE LOGIN RBDg10L WITH PASSWORD = '123456RBD', CHECK_POLICY = OFF;
GO

-- Login zdalny â€” kolega bÄ™dzie na niego mapowany gdy Ĺ‚Ä…czy siÄ™ DO TWOJEGO serwera
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'zRBDg10R')
    CREATE LOGIN zRBDg10R WITH PASSWORD = '123456RBD', CHECK_POLICY = OFF;
GO

-- UĹĽytkownik lokalny w bazie RBD_g10
USE RBD_g10;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'RBDg10L')
    CREATE USER RBDg10L FOR LOGIN RBDg10L;
GO

-- UĹĽytkownik zdalny w bazie RBD_g10 (kolega pod tym userem bÄ™dzie widziaĹ‚ Twoje tabele)
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'zRBDg10R')
    CREATE USER zRBDg10R FOR LOGIN zRBDg10R;
GO


-- =============================================================================
-- ZADANIE 4: Definicja serwera poĹ‚Ä…czonego z-01 + delegacja uprawnieĹ„
-- INSTRUKCJA:
--   Na WB-20 definiujesz linked server z-01 â†’ wskazujÄ…cy na WB-18 (kolega)
--   Mapujesz: TwĂłj login RBDg10L â†’ login zRBDg10R na serwerze kolegi (WB-18)
--   
--   Kolega robi to samo w lustrzanym ukĹ‚adzie:
--   jego linked server â†’ WB-20, jego RBDg10L â†’ TwĂłj zRBDg10R
-- =============================================================================

USE master;
GO

-- UsuĹ„ serwer poĹ‚Ä…czony jeĹ›li istnieje (unika bĹ‚Ä™du duplikatu)
IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'z-01')
    EXEC sp_dropserver N'z-01', 'droplogins';
GO

-- Dodanie serwera poĹ‚Ä…czonego z-01 â†’ WB-18 (komputer kolegi)
EXEC sp_addlinkedserver
    @server     = N'z-01',
    @srvproduct = N'',
    @provider   = N'MSOLEDBSQL',
    @datasrc    = N'WB-18';
GO

-- Delegacja uprawnieĹ„:
-- Gdy Ty (zalogowany jako RBDg10L na WB-20) Ĺ‚Ä…czysz siÄ™ z WB-18 przez z-01,
-- bÄ™dziesz widziany jako uĹĽytkownik zRBDg10R na WB-18
EXEC sp_addlinkedsrvlogin
    @rmtsrvname  = N'z-01',
    @useself     = N'False',
    @locallogin  = N'RBDg10L',
    @rmtuser     = N'zRBDg10R',
    @rmtpassword = N'123456RBD';
GO

-- Weryfikacja serwera poĹ‚Ä…czonego
EXEC sp_linkedservers;
GO

-- Test poĹ‚Ä…czenia â€” odczyt danych z bazy kolegi na WB-18
SELECT TOP 5 * FROM [z-01].RBD_g10.dbo.Customers;
GO


-- =============================================================================
-- ZADANIE 5: Nadanie uprawnieĹ„ obiektowych (czytanie + zapis)
-- INSTRUKCJA:
--   Na TWOIM serwerze (WB-20):
--     - RBDg10L  â†’ SELECT/INSERT/UPDATE/DELETE (Ty pracujesz lokalnie)
--     - zRBDg10R â†’ SELECT/INSERT/UPDATE/DELETE (kolega Ĺ‚Ä…czy siÄ™ DO CIEBIE)
-- =============================================================================

USE RBD_g10;
GO

-- Uprawnienia dla loginu lokalnego
GRANT SELECT, INSERT, UPDATE, DELETE ON Customers       TO RBDg10L;
GRANT SELECT, INSERT, UPDATE, DELETE ON Products        TO RBDg10L;
GRANT SELECT, INSERT, UPDATE, DELETE ON Orders          TO RBDg10L;
GRANT SELECT, INSERT, UPDATE, DELETE ON [Order Details] TO RBDg10L;
GO

-- Uprawnienia dla loginu zdalnego (kolega Ĺ‚Ä…czÄ…cy siÄ™ do Ciebie)
GRANT SELECT, INSERT, UPDATE, DELETE ON Customers       TO zRBDg10R;
GRANT SELECT, INSERT, UPDATE, DELETE ON Products        TO zRBDg10R;
GRANT SELECT, INSERT, UPDATE, DELETE ON Orders          TO zRBDg10R;
GRANT SELECT, INSERT, UPDATE, DELETE ON [Order Details] TO zRBDg10R;
GO


-- =============================================================================
-- ZADANIE 6: Widok rozproszony + zapytanie
-- INSTRUKCJA:
--   Widok zwraca: jakie PRODUKTY (serwer zdalny = WB-18 przez z-01)
--   znalazĹ‚y siÄ™ na ZAMĂ“WIENIACH (serwer zdalny = WB-18 przez z-01)
--   zrealizowanych przez KLIENTĂ“W (serwer lokalny = WB-20, baza RBD_g10)
--   
--   Tworzymy widok w bazie lokalnej RBD_g10 na WB-20
-- =============================================================================

USE RBD_g10;
GO

IF OBJECT_ID('dbo.vw_ProduktyZamowieniaKlienci', 'V') IS NOT NULL
    DROP VIEW dbo.vw_ProduktyZamowieniaKlienci;
GO

CREATE VIEW dbo.vw_ProduktyZamowieniaKlienci
AS
    SELECT
        k.CustomerID,
        k.CompanyName       AS NazwaKlienta,
        k.ContactName       AS KontaktKlienta,
        o_zdalny.OrderID    AS NrZamowienia,
        o_zdalny.OrderDate  AS DataZamowienia,
        p_zdalny.ProductID,
        p_zdalny.ProductName AS NazwaProduktu,
        od_zdalny.UnitPrice AS CenaJednostkowa,
        od_zdalny.Quantity  AS Ilosc,
        od_zdalny.UnitPrice * od_zdalny.Quantity AS Wartosc
    FROM 
        -- Klienci z serwera LOKALNEGO (WB-20)
        RBD_g10.dbo.Customers AS k
    INNER JOIN 
        -- ZamĂłwienia z serwera ZDALNEGO (WB-18 przez z-01)
        [z-01].RBD_g10.dbo.Orders AS o_zdalny
        ON k.CustomerID = o_zdalny.CustomerID
    INNER JOIN 
        -- SzczegĂłĹ‚y zamĂłwieĹ„ z serwera ZDALNEGO
        [z-01].RBD_g10.dbo.[Order Details] AS od_zdalny
        ON o_zdalny.OrderID = od_zdalny.OrderID
    INNER JOIN 
        -- Produkty z serwera ZDALNEGO
        [z-01].RBD_g10.dbo.Products AS p_zdalny
        ON od_zdalny.ProductID = p_zdalny.ProductID;
GO

-- Zapytanie do widoku â€” pobranie wszystkich danych
SELECT * FROM dbo.vw_ProduktyZamowieniaKlienci
ORDER BY NazwaKlienta, NrZamowienia;
GO

-- Zapytanie do widoku â€” przykĹ‚ad z filtrem
SELECT 
    NazwaKlienta, 
    NrZamowienia, 
    NazwaProduktu, 
    Ilosc, 
    Wartosc
FROM dbo.vw_ProduktyZamowieniaKlienci
WHERE NazwaKlienta LIKE 'A%'
ORDER BY NazwaKlienta, NrZamowienia;
GO


-- =============================================================================
-- ZADANIE 7: Procedura â€” sumaryczna wartoĹ›Ä‡ sprzedaĹĽy w danym roku
-- INSTRUKCJA:
--   Parametr wejĹ›ciowy: @Rok (INT)
--   Dane o sprzedaĹĽy pobierane z serwera ZDALNEGO (WB-18 przez z-01)
--   ProcedurÄ™ tworzymy na serwerze LOKALNYM (WB-20) w bazie RBD_g10
-- =============================================================================

USE RBD_g10;
GO

IF OBJECT_ID('dbo.usp_WartoscSprzedazy', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_WartoscSprzedazy;
GO

CREATE PROCEDURE dbo.usp_WartoscSprzedazy
    @Rok INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        YEAR(o.OrderDate) AS Rok,
        SUM(od.UnitPrice * od.Quantity) AS SumarycznaWartosc
    FROM 
        [z-01].RBD_g10.dbo.Orders AS o
    INNER JOIN 
        [z-01].RBD_g10.dbo.[Order Details] AS od
        ON o.OrderID = od.OrderID
    WHERE 
        YEAR(o.OrderDate) = @Rok
    GROUP BY 
        YEAR(o.OrderDate);
END;
GO

-- Test procedury
EXEC dbo.usp_WartoscSprzedazy @Rok = 1997;
GO

EXEC dbo.usp_WartoscSprzedazy @Rok = 1998;
GO


-- =============================================================================
-- ZADANIE 8: Nadanie uprawnieĹ„ do procedury (zdalne wywoĹ‚anie)
-- INSTRUKCJA:
--   1. Nadaj EXECUTE na procedurze uĹĽytkownikowi zRBDg10R (kolega wywoĹ‚a jÄ… zdalnie)
--   2. WĹ‚Ä…cz RPC na linked serverze (potrzebne do zdalnego wywoĹ‚ania procedury)
-- =============================================================================

USE RBD_g10;
GO

-- Prawo EXECUTE â€” zarĂłwno dla loginu lokalnego jak i zdalnego
GRANT EXECUTE ON dbo.usp_WartoscSprzedazy TO RBDg10L;
GRANT EXECUTE ON dbo.usp_WartoscSprzedazy TO zRBDg10R;
GO

-- WĹ‚Ä…czenie RPC na serwerze poĹ‚Ä…czonym (potrzebne do zdalnego wywoĹ‚ania procedur)
USE master;
GO

EXEC sp_serveroption 'z-01', 'rpc',     'true';
EXEC sp_serveroption 'z-01', 'rpc out', 'true';
GO

-- Test: kolega moĹĽe wywoĹ‚aÄ‡ procedurÄ™ na TWOIM serwerze tak:
-- EXEC [nazwa_linked_do_WB20].RBD_g10.dbo.usp_WartoscSprzedazy @Rok = 1997;


-- =============================================================================
-- ZADANIE 9: Wstawianie krotek na serwer zdalny do tabeli Products (bez MS DTC)
-- INSTRUKCJA: 
--   Wstawiamy dane do tabeli Products na WB-18 (przez linked server z-01)
--   Aby INSERT dziaĹ‚aĹ‚ bez MS DTC, wyĹ‚Ä…czamy remote proc transaction promotion
--   UĹĽywamy czteroczĹ‚onowego identyfikatora: z-01.RBD_g10.dbo.Products
-- =============================================================================

USE master;
GO

-- WyĹ‚Ä…cz wymĂłg MS DTC dla linked servera z-01
EXEC sp_serveroption 'z-01', 'remote proc transaction promotion', 'false';
GO

-- Wstawienie testowych krotek do Products na serwerze kolegi (WB-18)
INSERT INTO [z-01].RBD_g10.dbo.Products 
    (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
VALUES 
    ('TestProdukt_LAB05_A', 1, 1, '10 boxes', 25.00, 100, 0, 10, 0);
GO

INSERT INTO [z-01].RBD_g10.dbo.Products 
    (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
VALUES 
    ('TestProdukt_LAB05_B', 2, 2, '20 bags', 15.50, 50, 0, 5, 0);
GO

-- Weryfikacja â€” sprawdzenie czy krotki pojawiĹ‚y siÄ™ u kolegi
SELECT ProductID, ProductName, UnitPrice 
FROM [z-01].RBD_g10.dbo.Products
WHERE ProductName LIKE 'TestProdukt_LAB05%';
GO


-- =============================================================================
-- ZADANIE 10: UsuniÄ™cie wstawionych krotek (czteroczĹ‚onowy identyfikator)
-- INSTRUKCJA:
--   Usuwamy krotki z pkt 9 z serwera kolegi (WB-18)
--   uĹĽywajÄ…c peĹ‚nej Ĺ›cieĹĽki: z-01.RBD_g10.dbo.Products
-- =============================================================================

DELETE FROM [z-01].RBD_g10.dbo.Products
WHERE ProductName LIKE 'TestProdukt_LAB05%';
GO

-- Weryfikacja â€” powinno zwrĂłciÄ‡ 0 wierszy
SELECT ProductID, ProductName 
FROM [z-01].RBD_g10.dbo.Products
WHERE ProductName LIKE 'TestProdukt_LAB05%';
GO


-- =============================================================================
-- ZADANIE 11: To samo co pkt 9 i 10, ale z OPENQUERY
-- INSTRUKCJA:
--   OPENQUERY(linked_server, 'zapytanie') â€” zapytanie wykonuje siÄ™ NA serwerze zdalnym
--   MoĹĽna uĹĽywaÄ‡ INSERT, DELETE, UPDATE, SELECT
--   Dokumentacja: https://learn.microsoft.com/pl-pl/sql/t-sql/functions/openquery-transact-sql
-- =============================================================================

-- 11a) INSERT przez OPENQUERY
INSERT INTO OPENQUERY([z-01], 
    'SELECT ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued 
     FROM RBD_g10.dbo.Products')
VALUES 
    ('TestProdukt_OQ_A', 1, 1, '10 boxes', 25.00, 100, 0, 10, 0);
GO

INSERT INTO OPENQUERY([z-01], 
    'SELECT ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued 
     FROM RBD_g10.dbo.Products')
VALUES 
    ('TestProdukt_OQ_B', 2, 2, '20 bags', 15.50, 50, 0, 5, 0);
GO

-- Weryfikacja INSERT przez OPENQUERY
SELECT * FROM OPENQUERY([z-01], 
    'SELECT ProductID, ProductName, UnitPrice 
     FROM RBD_g10.dbo.Products 
     WHERE ProductName LIKE ''TestProdukt_OQ%''');
GO

-- 11b) DELETE przez OPENQUERY
DELETE FROM OPENQUERY([z-01], 
    'SELECT ProductID, ProductName 
     FROM RBD_g10.dbo.Products 
     WHERE ProductName LIKE ''TestProdukt_OQ%''');
GO

-- Weryfikacja DELETE â€” powinno zwrĂłciÄ‡ 0 wierszy
SELECT * FROM OPENQUERY([z-01], 
    'SELECT ProductID, ProductName 
     FROM RBD_g10.dbo.Products 
     WHERE ProductName LIKE ''TestProdukt_OQ%''');
GO


-- =============================================================================
-- ZADANIE 12: Tabela EMPLOYEES w ORACLE + uprawnienia
-- INSTRUKCJA:
--   1. PoĹ‚Ä…cz siÄ™ z Oracle (np. przez SQL*Plus lub SQL Developer) jako PD251190
--   2. UtwĂłrz tabelÄ™ EMPLOYEES kopiujÄ…c ze schematu NORTHWIND
--   3. Nadaj uprawnienia obiektowe koledze z grupy
-- =============================================================================

-- >>> PONIĹ»SZE KOMENDY wykonujesz w ORACLE (SQL*Plus / SQL Developer): <<<

/*
-- PoĹ‚Ä…czenie jako PD251190 do PD25

-- Kopiowanie tabeli EMPLOYEES z schematu NORTHWIND
CREATE TABLE EMPLOYEES AS 
SELECT * FROM NORTHWIND.EMPLOYEES;

-- Nadanie uprawnieĹ„ koledze (zamieĹ„ PD25XXXX na faktyczny login partnera z grupy!)
GRANT SELECT, INSERT, UPDATE, DELETE ON EMPLOYEES TO PD25XXXX;

-- Weryfikacja
SELECT * FROM EMPLOYEES;
DESC EMPLOYEES;
*/


-- =============================================================================
-- ZADANIE 13: Linked server do ORACLE + delegacja + test INSERT
-- INSTRUKCJA:
--   1. Na WB-20 definiujesz linked server do Oracle (PD25)
--   2. Mapujesz login RBDg10L â†’ TwĂłj login Oracle PD251190
--   3. Testujesz INSERT do tabeli EMPLOYEES kolegi na Oracle
-- =============================================================================

USE master;
GO

-- WĹ‚Ä…czenie Oracle OLE DB w procesie
EXEC master.dbo.sp_MSset_oledb_prop N'OraOLEDB.Oracle', N'AllowInProcess', 1;
GO

-- UsuĹ„ istniejÄ…cy linked server do Oracle jeĹ›li istnieje
IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'OraclePD25')
    EXEC sp_dropserver N'OraclePD25', 'droplogins';
GO

-- Dodanie linked servera do Oracle
EXEC sp_addlinkedserver
    @server     = N'OraclePD25',
    @srvproduct = N'Oracle',
    @provider   = N'OraOLEDB.Oracle',
    @datasrc    = N'(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=212.51.216.169)(PORT=1521)))(CONNECT_DATA=(SID=PD25)))';
GO

-- Delegacja: login lokalny RBDg10L â†’ login Oracle PD251190
EXEC sp_addlinkedsrvlogin
    @rmtsrvname  = N'OraclePD25',
    @useself     = N'False',
    @locallogin  = N'RBDg10L',
    @rmtuser     = N'PD251190',
    @rmtpassword = N'12345';
GO

-- Test SELECT â€” odczyt SWOJEJ tabeli EMPLOYEES
SELECT * FROM OraclePD25..PD251190.EMPLOYEES;
GO

-- Test SELECT â€” odczyt tabeli PARTNERA (zamieĹ„ PD25XXXX na login kolegi!)
-- SELECT * FROM OraclePD25..PD25XXXX.EMPLOYEES;
-- GO

-- Test INSERT â€” wstawianie do tabeli kolegi (wymaga GRANTu z pkt 12)
/*
INSERT INTO OraclePD25..PD25XXXX.EMPLOYEES 
    (EmployeeID, LastName, FirstName, Title)
VALUES 
    (999, 'Testowy', 'Pracownik', 'Lab05 Test');
GO

-- Weryfikacja
SELECT * FROM OraclePD25..PD25XXXX.EMPLOYEES WHERE EmployeeID = 999;
GO

-- SprzÄ…tanie
DELETE FROM OraclePD25..PD25XXXX.EMPLOYEES WHERE EmployeeID = 999;
GO
*/


-- =============================================================================
-- PODSUMOWANIE â€” KOMENDY DO WERYFIKACJI
-- =============================================================================

-- Lista serwerĂłw poĹ‚Ä…czonych
EXEC sp_linkedservers;
GO

-- Lista loginĂłw
SELECT name, type_desc FROM sys.server_principals WHERE name IN ('RBDg10L', 'zRBDg10R');
GO

-- Lista uĹĽytkownikĂłw w bazie
USE RBD_g10;
SELECT name FROM sys.database_principals WHERE name IN ('RBDg10L', 'zRBDg10R');
GO
