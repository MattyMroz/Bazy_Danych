select * from Northwind.dbo.Categories

-- parametry konfiguracyjne
sp_configure 
go
reconfigure
go
sp_configure 'show advanced options', 1
go
sp_configure
go
sp_linkedservers
go
-- openrowset docs


go
sp_configure 'Ad Hoc Distributed Queries', 1
go
reconfigure
go


-- lokalnej tabli produkty 
USE [master]
GO
EXEC master.dbo.sp_MSset_oledb_prop N'MSOLEDBSQL', N'DynamicParameters', 1
GO

-- https://learn.microsoft.com/pl-pl/sql/t-sql/functions/openrowset-transact-sql?view=sql-server-ver17


SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=WB-20;Trusted_Connection=yes;',
    'select * from Northwind.dbo.Categories'
) AS a;

SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'WB-20';'sa';'praktyka',
    'select * from Northwind.dbo.Categories'
) AS a;

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;

SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=WB-18;Database=Northwind;Trusted_Connection=yes;',
    'SELECT * FROM dbo.Categories'
) AS a;


EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;

SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=WB-07;UID=sa;PWD=praktyka;TrustServerCertificate=yes;',
    'SELECT * FROM Northwind.dbo.Categories'
) AS a;

-- C:\Windows\SysWOW64\SQLServerManager16.msc
-- Wy��czy� zapor� windows
-- odkry� po�a�znia na porcie



1433