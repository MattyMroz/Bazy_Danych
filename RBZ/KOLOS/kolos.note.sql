/* ============================================================================
   PROMPT - jak pisac kod na kolokwium (RBZ)
   ============================================================================
   - Pisz kod tak jak w pliku kolos.ral.sql / kolos.ral.uczelnia.sql:
     krotko, czysto, GO po kazdym wsadzie, bez nadmiaru BEGIN/END.
   - Procedury: CREATE OR ALTER PROCEDURE, bez SET NOCOUNT, bez DECLARE
     dopoki nie musisz. Jesli OPENROWSET nie pozwala na parametr,
     robisz CTE z SELECT * i filtrujesz @parametr w WHERE na zewnatrz.
   - Widoki: CREATE OR ALTER VIEW, WITH ENCRYPTION jesli zadanie tego wymaga.
   - Najpierw ZAWSZE zrob "wersje lokalna" (zwykly SELECT z lokalnej bazy)
     zeby sprawdzic ze sens zapytania jest poprawny. Potem podmieniasz
     na OPENROWSET / OPENQUERY / 4-czlonowa nazwe.
   - Dla OPENROWSET na Access: SELECT * w srodku, NIE wymieniaj kolumn
     (lookup pola wywalaja "invalid metadata"). JOIN/WHERE w SQL Server.
   - Dla OPENQUERY do SQL Server: piszesz string T-SQL ktory wykona sie zdalnie.
   - Dla Oracle: nazwy bez cudzyslowu sa case-insensitive, haslo CASE-SENSITIVE.
   - Dla DTC: SET XACT_ABORT ON; BEGIN DISTRIBUTED TRANSACTION; ... COMMIT.
   - Konfiguracja uczelniana: sa/praktyka, Oracle PD251190/12345,
     host 212.51.216.169:1521 SID=PD25, lokalny komputer WB-20,
     inne komputery WB-XX (linked server WBxx).
============================================================================ */


/* ============================================================================
   INFRASTRUKTURA - co skonfigurowac PRZED uruchomieniem czegokolwiek
   ============================================================================

   1) Uslugi Windows
      - Win + R -> services.msc
      - SQL Server (MSSQLSERVER): Wlasciwosci -> Logowanie -> Lokalne konto
        systemowe -> Zastosuj -> Restart uslugi
      - SQL Server Browser: Wlasciwosci -> Service -> Start Mode = Automatic,
        Start

   2) SQL Server Configuration Manager (uruchom jako Administrator)
      - SQL Server Network Configuration -> MSSQLSERVER:
          TCP/IP        -> Enable
          Named Pipes   -> Enable
      - SQL Server Services -> SQL Server (MSSQLSERVER) -> Restart

   3) Zapora sieciowa (Firewall)
      - Panel sterowania -> System i zabezpieczenia -> Zapora systemowa
        Windows -> Zaawansowane ustawienia
      - Reguly wejsciowe (potem wyjsciowe) -> Nowa regula -> Port:
          TCP 1433  (SQL Server)
          TCP 1521  (Oracle)
        -> Zezwol na polaczenie -> Nazwa: SQL Server / Oracle -> Zakoncz

   4) Oracle Net Manager (na potrzeby connect string'ow do Oracle z PL/SQL)
      - Directory -> Local -> Service Naming -> Create
          Name: PD25
          Protocol: TCP
          Host: 212.51.216.169
          Port: 1521
          SID: PD25

   5) Sterownik ACE dla Excela i Access
      - Microsoft.ACE.OLEDB.12.0  (32-bit lub 64-bit zgodny z SQL Server)
      - Alternatywa: Microsoft.ACE.OLEDB.16.0

   6) Pliki Excel/Access
      - C:\Northwind\Northwind.mdb
      - C:\Northwind\listy.xlsx
      Klik prawy na folder C:\Northwind -> Wlasciwosci -> Zabezpieczenia
        -> Edytuj -> Dodaj -> "Wszyscy" (Everyone) -> Odczyt + Wykonanie

============================================================================ */


/* ============================================================================
   KONFIGURACJA SQL SERVER - jednorazowa
   ============================================================================ */

EXEC sp_configure 'show advanced options', 1; RECONFIGURE;
EXEC sp_configure 'Ad Hoc Distributed Queries', 1; RECONFIGURE;
GO

USE master;
GO

EXEC master.dbo.sp_MSset_oledb_prop N'MSOLEDBSQL',              N'AllowInProcess',    1;
EXEC master.dbo.sp_MSset_oledb_prop N'MSOLEDBSQL',              N'DynamicParameters', 1;
EXEC master.dbo.sp_MSset_oledb_prop N'OraOLEDB.Oracle',         N'AllowInProcess',    1;
EXEC master.dbo.sp_MSset_oledb_prop N'OraOLEDB.Oracle',         N'DynamicParameters', 1;
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0',N'AllowInProcess',    1;
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0',N'DynamicParameters', 1;
GO


/* ============================================================================
   LOGINY / USERZY / GRANTY
   ============================================================================ */

CREATE LOGIN KONTO1 WITH PASSWORD = '12345', CHECK_POLICY = OFF;
GO

USE Northwind;
GO
CREATE USER KONTO1 FOR LOGIN KONTO1;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO KONTO1;
GO


/* ============================================================================
   LINKED SERVER - SQL Server -> SQL Server (Serwer1, mapping sa -> KONTO1)
   ============================================================================ */

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
    @rmtuser    = 'KONTO1',
    @rmtpassword= '12345';
GO

EXEC sp_serveroption 'Serwer1', 'data access', 'true';
EXEC sp_serveroption 'Serwer1', 'rpc',         'true';
EXEC sp_serveroption 'Serwer1', 'rpc out',     'true';
GO

EXEC sp_linkedservers;
SELECT TOP 5 * FROM OPENQUERY(Serwer1, 'SELECT ProductID, ProductName FROM Northwind.dbo.Products');
GO


/* ============================================================================
   LINKED SERVER - SQL Server -> Oracle
   ============================================================================ */

EXEC sp_addlinkedserver
    @server     = 'OraPD25',
    @srvproduct = 'Oracle',
    @provider   = 'OraOLEDB.Oracle',
    @datasrc    = '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=212.51.216.169)(PORT=1521))(CONNECT_DATA=(SID=PD25)))';
GO

EXEC sp_addlinkedsrvlogin
    @rmtsrvname = 'OraPD25',
    @useself    = 'false',
    @locallogin = 'sa',
    @rmtuser    = 'PD251190',
    @rmtpassword= '12345';
GO

EXEC sp_serveroption 'OraPD25', 'rpc out', 'true';
GO


/* ============================================================================
   LINKED SERVER - SQL Server -> Access
   ============================================================================ */

EXEC sp_addlinkedserver
    @server     = 'AccessNW',
    @srvproduct = 'OLE DB Provider for ACE',
    @provider   = 'Microsoft.ACE.OLEDB.12.0',
    @datasrc    = 'C:\Northwind\Northwind.mdb';
GO


/* ============================================================================
   LINKED SERVER - SQL Server -> Excel
   ============================================================================ */

EXEC sp_addlinkedserver
    @server     = 'ExcelLST',
    @srvproduct = 'OLE DB Provider for ACE',
    @provider   = 'Microsoft.ACE.OLEDB.12.0',
    @datasrc    = 'C:\Northwind\listy.xlsx',
    @provstr    = 'Excel 12.0;HDR=YES';
GO


/* ============================================================================
   OPENROWSET - SQL -> SQL
   ============================================================================ */

SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=WB-20;Database=Northwind;UID=sa;PWD=praktyka;',
    'SELECT ProductID, ProductName FROM dbo.Products'
) AS a;
GO


/* ============================================================================
   OPENROWSET - SQL -> Oracle
   ============================================================================ */

SELECT a.*
FROM OPENROWSET(
    'OraOLEDB.Oracle',
    '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=212.51.216.169)(PORT=1521))(CONNECT_DATA=(SID=PD25)))';'PD251190';'12345',
    'SELECT EmployeeID, LastName, FirstName FROM Employees'
) AS a;
GO


/* ============================================================================
   OPENROWSET - SQL -> Access (ZAWSZE SELECT *, JOIN/WHERE w SQL Server)
   ============================================================================ */

SELECT a.*
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'C:\Northwind\Northwind.mdb';'admin';'',
    'SELECT * FROM [Opisy zamówień]'
) AS a;
GO


/* ============================================================================
   OPENROWSET - SQL -> Excel
   ============================================================================ */

SELECT a.*
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'Excel 12.0;Database=C:\Northwind\listy.xlsx;HDR=YES;',
    'SELECT * FROM [oceny_do_www$]'
) AS a;
GO


/* ============================================================================
   OPENROWSET MULTI-ZRODLO (SQL + Oracle + Access) - CTE pattern
   ============================================================================ */

;WITH klienci AS (
    SELECT * FROM OPENROWSET(
        'OraOLEDB.Oracle',
        '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=212.51.216.169)(PORT=1521))(CONNECT_DATA=(SID=PD25)))';'PD251190';'12345',
        'SELECT CustomerID, CompanyName FROM Customers'
    )
),
zamowienia AS (
    SELECT * FROM OPENROWSET(
        'MSOLEDBSQL',
        'Server=WB-20;Database=Northwind;UID=sa;PWD=praktyka;',
        'SELECT OrderID, CustomerID, EmployeeID FROM dbo.Orders'
    )
),
produkty AS (
    SELECT * FROM OPENROWSET(
        'Microsoft.ACE.OLEDB.12.0',
        'C:\Northwind\Northwind.mdb';'admin';'',
        'SELECT * FROM Produkty'
    )
)
SELECT k.CompanyName, z.OrderID, p.NazwaProduktu
FROM zamowienia z
JOIN klienci  k ON z.CustomerID = k.CustomerID
JOIN Northwind.dbo.[Order Details] od ON z.OrderID = od.OrderID
JOIN produkty p ON od.ProductID = p.IDproduktu;
GO


/* ============================================================================
   OPENQUERY - przetwarzanie zdalne (SELECT, INSERT, UPDATE, DELETE)
   ============================================================================ */

SELECT * FROM OPENQUERY(Serwer1, 'SELECT ProductID, ProductName FROM Northwind.dbo.Products');
GO

INSERT INTO OPENQUERY(Serwer1, 'SELECT ProductName, UnitPrice FROM Northwind.dbo.Products')
VALUES ('Test', 1.0);
GO

UPDATE OPENQUERY(Serwer1, 'SELECT ProductName, UnitPrice FROM Northwind.dbo.Products WHERE ProductName = ''Test''')
SET UnitPrice = 9.99;
GO

DELETE FROM OPENQUERY(Serwer1, 'SELECT ProductID FROM Northwind.dbo.Products WHERE ProductName = ''Test''');
GO

EXEC ('SELECT TOP 5 * FROM Northwind.dbo.Products') AT Serwer1;
GO


/* ============================================================================
   4-CZLONOWA IDENTYFIKACJA OBIEKTU (przez linked server)
   ============================================================================ */

SELECT TOP 5 * FROM Serwer1.Northwind.dbo.Products;
SELECT TOP 5 * FROM Serwer1.Northwind.dbo.[Order Details];
GO


/* ============================================================================
   WIDOK Z OPENROWSET I SZYFROWANIEM
   ============================================================================ */

CREATE OR ALTER VIEW dbo.Widok1
WITH ENCRYPTION
AS
SELECT e.EmployeeID, e.LastName, o.OrderID, p.ProductName
FROM OPENROWSET(
    'OraOLEDB.Oracle',
    '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=212.51.216.169)(PORT=1521))(CONNECT_DATA=(SID=PD25)))';'PD251190';'12345',
    'SELECT EmployeeID, LastName FROM Employees'
) AS e
INNER JOIN OPENROWSET(
    'OraOLEDB.Oracle',
    '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=212.51.216.169)(PORT=1521))(CONNECT_DATA=(SID=PD25)))';'PD251190';'12345',
    'SELECT OrderID, EmployeeID FROM Orders'
) AS o ON e.EmployeeID = o.EmployeeID
INNER JOIN OPENROWSET(
    'MSOLEDBSQL',
    'Server=WB-20;Database=Northwind;UID=sa;PWD=praktyka;',
    'SELECT ProductID, ProductName FROM dbo.Products'
) AS p ON 1 = 1;
GO

-- sprawdzenie szyfrowania (powinno byc NULL)
SELECT definition FROM sys.sql_modules WHERE object_id = OBJECT_ID('dbo.Widok1');
GO


/* ============================================================================
   PROCEDURA Z PARAMETREM I OPENROWSET DO ACCESS (pattern z CTE)
   ============================================================================ */

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

-- 4 sposoby wywolania
EXEC dbo.PROC4 10248;                          -- pozycyjny
EXEC dbo.PROC4 @OrderID = 10250;               -- nazwany
DECLARE @id INT = 10251; EXEC dbo.PROC4 @id;   -- ze zmiennej
DECLARE @id INT = 10252; EXEC dbo.PROC4 @OrderID = @id; -- nazwany ze zmiennej
GO


/* ============================================================================
   DTC - rozproszona transakcja
   ============================================================================ */

SET XACT_ABORT ON;
BEGIN DISTRIBUTED TRANSACTION;
    INSERT INTO Northwind.dbo.Categories (CategoryName, Description)
    VALUES ('LokalnaTest', 'lokalna');

    INSERT INTO OPENQUERY(Serwer1, 'SELECT CategoryName, Description FROM Northwind.dbo.Categories')
    VALUES ('ZdalnaTest', 'zdalna');
COMMIT TRANSACTION;
GO


/* ============================================================================
   ORACLE - szybkie konto NORTHWIND/PD251190
   ============================================================================
   -- po stronie Oracle (SYS):
   --   CREATE USER NORTHWIND IDENTIFIED BY "12345";
   --   GRANT CONNECT, RESOURCE, UNLIMITED TABLESPACE TO NORTHWIND;
   --   GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW TO NORTHWIND;
   ============================================================================ */


/* ============================================================================
   NAJCZESTSZE BLEDY I JAK JE NAPRAWIC
   ============================================================================

   1) "Ad hoc access to OLE DB provider has been denied"
      -> sp_configure 'Ad Hoc Distributed Queries', 1; RECONFIGURE;

   2) "Could not find server 'XXX' in sys.servers"
      -> linked server nie istnieje; sprawdz EXEC sp_linkedservers
         i ewentualnie EXEC sp_addlinkedserver ponownie

   3) "Cannot create an instance of OLE DB provider"
      -> sp_MSset_oledb_prop ... 'AllowInProcess', 1
      -> sterownik ACE/Oracle moze byc niezainstalowany
      -> bitness sterownika musi pasowac do SQL Server (32 vs 64 bit)

   4) "supplied invalid metadata for column" (ACE / Access)
      -> nie wymieniaj kolumn w OPENROWSET; uzyj SELECT *,
         JOIN i WHERE rob na zewnatrz w SQL Server (CTE)

   5) "OLE DB provider returned message: ORA-12541 / ORA-12154"
      -> sprawdz Oracle Net Manager (alias PD25), Firewall na 1521,
         oracle service na hoscie

   6) "Login failed for user"
      -> w Oracle haslo jest CASE-SENSITIVE; sprawdz UID/PWD
      -> w SQL Server sprawdz CREATE LOGIN i CREATE USER w bazie docelowej

   7) "MSDTC on server 'XXX' is unavailable" (DTC)
      -> uruchom usluge "Distributed Transaction Coordinator"
      -> Component Services -> DTC -> Security: Network DTC Access ON,
         Allow Inbound + Outbound, No Authentication Required
      -> firewall: dodaj reguly dla msdtc.exe

   8) "The OLE DB provider has not been registered"
      -> brak sterownika ACE/Oracle; doinstaluj

   9) MSysObjects "no permissions"
      -> standardowo zablokowane; lista tabel = otwarcie .mdb w Access

  10) Polskie znaki rozjezdzaja sie w wynikach
      -> upewnij sie ze plik .sql jest UTF-8 i ze SSMS
         "Use UTF-8 encoding" jest WLACZONE

  11) "Cannot use the OUTPUT option in a PRINT statement" / brak wynikow
      -> SET NOCOUNT OFF; albo upewnij sie ze procedura ma SELECT,
         a nie tylko EXEC sp_executesql

  12) Restart SQL Server po zmianach providerow
      -> Win+R -> services.msc -> SQL Server (MSSQLSERVER) -> Restart

============================================================================ */


/* ============================================================================
   PRZYDATNE sp_*
   ============================================================================ */

EXEC sp_linkedservers;                            -- lista linked servers
EXEC sp_helpserver;                               -- szczegoly
EXEC sp_tables_ex 'Serwer1';                         -- tabele zdalne
EXEC sp_columns_ex 'Serwer1', 'Products';            -- kolumny zdalne
EXEC sp_dropserver 'Serwer1', 'droplogins';          -- usuwanie linked serwera
EXEC sp_helprolemember 'db_owner';                -- czlonkowie roli
GO
