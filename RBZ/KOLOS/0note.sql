sp_configure 'show advanced options', 1
reconfigure
go

sp_configure 'Ad Hoc Distributed Queries', 1
reconfigure
go

-- <Server Objects> --> <Linked Servers>  --> <Providers>
USE [master]
GO
EXEC master.dbo.sp_MSset_oledb_prop N'MSOLEDBSQL', N'AllowInProcess', 1
GO
EXEC master.dbo.sp_MSset_oledb_prop N'MSOLEDBSQL', N'DynamicParameters', 1
GO

USE [master]
GO
EXEC master.dbo.sp_MSset_oledb_prop N'OraOLEDB.Oracle', N'AllowInProcess', 1
GO
EXEC master.dbo.sp_MSset_oledb_prop N'OraOLEDB.Oracle', N'DynamicParameters', 1
GO

USE [master]
GO
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1
GO
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1
GO

CREATE LOGIN ZA23 WITH PASSWORD = '12345', CHECK_POLICY = OFF

CREATE USER ZA23 FOR LOGIN ZA23

GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO ZA23

USE master

EXEC sp_addlinkedserver
    @server     = 'Serwer1',
    @srvproduct = '',
    @provider   = 'MSOLEDBSQL',
    @datasrc    = 'Mateusz',
    @catalog    = 'Northwind';
GO

EXEC sp_addlinkedsrvlogin
    @rmtsrvname = 'Serwer1',
    @useself    = 'false',
    @locallogin = 'sa',
    @rmtuser    = 'ZA23',
    @rmtpassword= '12345';
GO


sp_serveroption 'Serwer1', 'data access', 'true';
go
sp_serveroption 'Serwer1', 'rpc', 'true';
go
sp_serveroption 'Serwer1', 'rpc out', 'true';
go

sp_linkedservers
SELECT ProductID, ProductName FROM Northwind.dbo.Products
SELECT TOP 5 * FROM OPENQUERY(Serwer1, 'SELECT ProductID, ProductName FROM Northwind.dbo.Products')

