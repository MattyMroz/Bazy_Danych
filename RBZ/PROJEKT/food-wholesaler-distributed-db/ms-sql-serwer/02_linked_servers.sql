/*
    02_linked_servers.sql

    Linked servery, OPENROWSET i OPENQUERY.

    Przed uruchomieniem popraw:
    - host/port/service Oracle,
    - haslo SPRZEDAZ_USER,
    - sciezki do plikow Access i Excel, jezeli repo jest w innym miejscu.
*/

USE master;
GO

-- ============================================================
-- 1. Opcje SQL Server i providery
-- ============================================================

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
GO

EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
GO

EXEC master.dbo.sp_MSset_oledb_prop N'MSOLEDBSQL', N'AllowInProcess', 1;
EXEC master.dbo.sp_MSset_oledb_prop N'MSOLEDBSQL', N'DynamicParameters', 1;
EXEC master.dbo.sp_MSset_oledb_prop N'OraOLEDB.Oracle', N'AllowInProcess', 1;
EXEC master.dbo.sp_MSset_oledb_prop N'OraOLEDB.Oracle', N'DynamicParameters', 1;
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 0;
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1;
GO

EXEC sp_enum_oledb_providers;
GO

-- ============================================================
-- 2. SRV_MAGAZYN - SQL Server -> SQL Server
-- ============================================================

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'SRV_MAGAZYN')
    EXEC sp_dropserver N'SRV_MAGAZYN', 'droplogins';
GO

DECLARE @MagazynServer SYSNAME = @@SERVERNAME;

-- 1. Rejestracja serwera polaczonego
EXEC sp_addlinkedserver
    @server = N'SRV_MAGAZYN',
    @srvproduct = N'',
    @provider = N'MSOLEDBSQL',
    @datasrc = @MagazynServer,
    @catalog = N'HurtowniaMagazyn';

-- 2. Mapowanie loginu
EXEC sp_addlinkedsrvlogin
    @rmtsrvname = N'SRV_MAGAZYN',
    @useself = N'True',
    @locallogin = NULL;

-- 3. Opcje serwera (dostep do danych i wywolania RPC)
EXEC sp_serveroption N'SRV_MAGAZYN', N'data access', N'true';
EXEC sp_serveroption N'SRV_MAGAZYN', N'rpc', N'true';
EXEC sp_serveroption N'SRV_MAGAZYN', N'rpc out', N'true';
GO

-- ============================================================
-- 3. SRV_ORACLE - SQL Server -> Oracle
-- ============================================================

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'SRV_ORACLE')
    EXEC sp_dropserver N'SRV_ORACLE', 'droplogins';
GO

-- 1. Rejestracja serwera polaczonego
EXEC sp_addlinkedserver
    @server = N'SRV_ORACLE',
    @srvproduct = N'Oracle',
    @provider = N'OraOLEDB.Oracle',
    @datasrc = N'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=pdb)))'; -- HOST=localhost, SERVICE_NAME=pdb
GO

-- 2. Mapowanie loginu na ograniczone konto Oracle SPRZEDAZ_USER
EXEC sp_addlinkedsrvlogin
    @rmtsrvname = N'SRV_ORACLE',
    @useself = N'False',
    @locallogin = NULL,
    @rmtuser = N'SPRZEDAZ_USER',
    @rmtpassword = N'123';
GO

-- 3. Opcje serwera (dostep do danych i wywolania RPC)
EXEC sp_serveroption N'SRV_ORACLE', N'data access', N'true';
EXEC sp_serveroption N'SRV_ORACLE', N'rpc', N'true';
EXEC sp_serveroption N'SRV_ORACLE', N'rpc out', N'true';
GO

-- ============================================================
-- 4. SRV_ACCESS - SQL Server -> Access
-- ============================================================

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'SRV_ACCESS')
    EXEC sp_dropserver N'SRV_ACCESS', 'droplogins';
GO

-- 1. Rejestracja serwera polaczonego (plik .accdb przez sterownik ACE)
EXEC sp_addlinkedserver
    @server = N'SRV_ACCESS',
    @srvproduct = N'OLE DB Provider for ACE',
    @provider = N'Microsoft.ACE.OLEDB.12.0',
    @datasrc = N'C:\acces\przedstawiciele.accdb';
GO

-- 2. Mapowanie loginu (domyslne konto Admin pliku Access, bez hasla)
EXEC sp_addlinkedsrvlogin
    @rmtsrvname = N'SRV_ACCESS',
    @useself = N'False',
    @locallogin = NULL,
    @rmtuser = N'Admin',
    @rmtpassword = N'';
GO

-- 3. Opcje serwera (dostep do danych)
EXEC sp_serveroption N'SRV_ACCESS', N'data access', N'true';
GO

-- ============================================================
-- 5. SRV_EXCEL - SQL Server -> Excel
-- ============================================================

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'SRV_EXCEL')
    EXEC sp_dropserver N'SRV_EXCEL', 'droplogins';
GO

-- 1. Rejestracja serwera polaczonego (plik .xlsx przez sterownik ACE)
EXEC sp_addlinkedserver
    @server = N'SRV_EXCEL',
    @srvproduct = N'Excel',
    @provider = N'Microsoft.ACE.OLEDB.12.0',
    @datasrc = N'C:\excel\cenniki_dostawcow.xlsx',
    @provstr = N'Excel 12.0;HDR=YES';
GO

-- 2. Mapowanie loginu (domyslne konto Admin, bez hasla)
EXEC sp_addlinkedsrvlogin
    @rmtsrvname = N'SRV_EXCEL',
    @useself = N'False',
    @locallogin = NULL,
    @rmtuser = N'Admin',
    @rmtpassword = N'';
GO

-- 3. Opcje serwera (dostep do danych)
EXEC sp_serveroption N'SRV_EXCEL', N'data access', N'true';
GO

-- ============================================================
-- 6. Przyklady OPENROWSET ad hoc
-- ============================================================

-- SQL Server -> SQL Server: stany magazynowe liczone po stronie magazynu.
/*
SELECT m.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=localhost;Database=HurtowniaMagazyn;Trusted_Connection=yes;TrustServerCertificate=yes;',
    'SELECT pr.strefa_temperaturowa,
            SUM(sp.ilosc_dostepna) AS ilosc_dostepna
     FROM dbo.PRODUKT AS pr
     JOIN dbo.PARTIA AS pa ON pr.id_produktu = pa.id_produktu
     JOIN dbo.STAN_PARTII AS sp ON pa.id_partii = sp.id_partii
     GROUP BY pr.strefa_temperaturowa'
) AS m;
GO
*/

-- SQL Server -> Oracle: statusy zamowien liczone po stronie Oracle.
/*
SELECT o.*
FROM OPENROWSET(
    'OraOLEDB.Oracle',
    'Data Source=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=pdb)));User Id=SPRZEDAZ_USER;Password=123;',
    'SELECT sz.NAZWA AS STATUS, COUNT(*) AS LICZBA
     FROM ZAMOWIENIE z
     JOIN STATUS_ZAMOWIENIA sz ON z.ID_STATUSU = sz.ID_STATUSU
     GROUP BY sz.NAZWA'
) AS o;
GO
*/

-- SQL Server -> Access: kartoteka przedstawicieli.
/*
SELECT a.*
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'C:\acces\przedstawiciele.accdb',
    'Admin',
    '',
    'SELECT id_przedstawiciela, imie, nazwisko, region, telefon, email
     FROM PRZEDSTAWICIELE'
) AS a;
GO
*/

-- SQL Server -> Excel: cennik dostawcy.
/*
SELECT x.*
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'Excel 12.0;Database=C:\excel\cenniki_dostawcow.xlsx;HDR=YES;',
    'SELECT id_produktu, cena_netto, data_od FROM [Cennik$]'
) AS x;
GO
*/

-- ============================================================
-- 7. Przyklady OPENQUERY
-- ============================================================

-- Magazyn przez linked server.
/*
SELECT *
FROM OPENQUERY(SRV_MAGAZYN, '
    SELECT TOP 10
        pr.id_produktu,
        pr.nazwa,
        SUM(sp.ilosc_dostepna) AS ilosc_dostepna
    FROM HurtowniaMagazyn.dbo.PRODUKT AS pr
    JOIN HurtowniaMagazyn.dbo.PARTIA AS pa ON pr.id_produktu = pa.id_produktu
    JOIN HurtowniaMagazyn.dbo.STAN_PARTII AS sp ON pa.id_partii = sp.id_partii
    GROUP BY pr.id_produktu, pr.nazwa
    ORDER BY pr.id_produktu
');
GO
*/

-- Oracle przez linked server: Top 10 klientow (agregacja po stronie Oracle).
/*
SELECT *
FROM OPENQUERY(SRV_ORACLE, '
    SELECT
        k.NAZWA AS KLIENT,
        SUM(pz.KWOTA_BRUTTO) AS WARTOSC_BRUTTO
    FROM KLIENT k
    JOIN ZAMOWIENIE z ON k.ID_KLIENTA = z.ID_KLIENTA
    JOIN POZYCJA_ZAMOWIENIA pz ON z.ID_ZAMOWIENIA = pz.ID_ZAMOWIENIA
    GROUP BY k.NAZWA
    ORDER BY SUM(pz.KWOTA_BRUTTO) DESC
    FETCH FIRST 10 ROWS ONLY
');
GO
*/

-- ============================================================
-- 8. Diagnostyka linked serverow
-- ============================================================

EXEC sp_linkedservers;
EXEC sp_helplinkedsrvlogin N'SRV_MAGAZYN';
EXEC sp_helplinkedsrvlogin N'SRV_ORACLE';
EXEC sp_helplinkedsrvlogin N'SRV_ACCESS';
EXEC sp_helplinkedsrvlogin N'SRV_EXCEL';
GO

SELECT name, product, provider, data_source, is_linked
FROM sys.servers
WHERE name IN (N'SRV_MAGAZYN', N'SRV_ORACLE', N'SRV_ACCESS', N'SRV_EXCEL');
GO

-- ============================================================
-- 9. Testy polaczen
-- ============================================================

EXEC sp_testlinkedserver N'SRV_MAGAZYN';
EXEC sp_testlinkedserver N'SRV_ORACLE';
EXEC sp_testlinkedserver N'SRV_ACCESS';
EXEC sp_testlinkedserver N'SRV_EXCEL';
GO

SELECT TOP 5 * FROM SRV_MAGAZYN.HurtowniaMagazyn.dbo.PRODUKT;
GO

SELECT * FROM OPENQUERY(SRV_ORACLE, 'SELECT TO_CHAR(SYSDATE, ''YYYY-MM-DD HH24:MI'') AS ORACLE_TIME FROM DUAL');
GO

SELECT * FROM OPENQUERY(SRV_ACCESS, 'SELECT id_przedstawiciela, imie, nazwisko, region, telefon, email FROM PRZEDSTAWICIELE');
GO

SELECT * FROM OPENQUERY(SRV_EXCEL, 'SELECT id_produktu, cena_netto, data_od FROM [Cennik$]');
GO
