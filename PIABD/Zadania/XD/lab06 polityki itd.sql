------------------------------------------------------------------------------------------
-- Monitorowanie, Polityki, Audyt, Wersjonowanie, Maskowanie danych i błędy użytkownika --
------------------------------------------------------------------------------------------

-- 1. Monitorowanie liczby aktywnych transakcji i skonfigurowanie alertu (SQL Server:Transactions - licznik Transactions)
--    https://learn.microsoft.com/en-us/sql/relational-databases/performance-monitor/sql-server-transactions-object?view=sql-server-ver17
SELECT * FROM sys.dm_os_performance_counters
WHERE object_name LIKE '%Transactions%';
--    - Performance Monitor umożliwia graficzne śledzenie liczby aktywnych transakcji.
--    - DMVs pozwalają na bardziej szczegółową analizę stanu transakcji (sys.dm_tran_active_transactions)
--    https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-tran-active-transactions-transact-sql?view=sql-server-ver17
SELECT * FROM sys.dm_tran_active_transactions;
GO
--    - Utwórz Alert (np. High Active Transactions), który automatycznie ostrzega o przekroczeniu ustalonego progu ilości transakcji np. >10 
--      (select occurrence_count,* FROM msdb.dbo.sysalerts)
--    https://learn.microsoft.com/en-us/ssms/agent/alerts
USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'High Active Transactions', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=0, 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Transactions|Transactions||>|10', 
		@job_id=N'00000000-0000-0000-0000-000000000000';
GO

SELECT occurrence_count, * FROM msdb.dbo.sysalerts WHERE name = 'High Active Transactions';
GO


-- 2. Tworzenia polityki np. o nazwie 'Polish Collation_Policy' do wykrywania baz, które nie mają collation 'Polish_%'.
--    Tworzymy Condition o nazwie 'Check for Polish Collation' i wybieramy na poziomie bazy danych zmienną @collation like 'Polish%'
--    Wykonujemy ewaluacje i podajemy nazwy baz danych, które nie spełniają tego warunku.
--    https://learn.microsoft.com/en-us/sql/relational-databases/policy-based-management/administer-servers-by-using-policy-based-management?view=sql-server-ver17
--    Tutorial 1: https://learn.microsoft.com/en-us/sql/relational-databases/policy-based-management/lesson-1-create-and-apply-an-off-by-default-policy?view=sql-server-ver17
--    Tutorial 2: https://learn.microsoft.com/en-us/sql/relational-databases/policy-based-management/lesson-2-create-and-apply-a-naming-standards-policy?view=sql-server-ver17

Declare @condition_id int
EXEC msdb.dbo.sp_syspolicy_add_condition @name=N'Check for Polish Collation', @description=N'', @facet=N'Database', @expression=N'<Operator>
  <TypeClass>Bool</TypeClass>
  <OpType>LIKE</OpType>
  <Count>2</Count>
  <Attribute>
    <TypeClass>String</TypeClass>
    <Name>Collation</Name>
  </Attribute>
  <Constant>
    <TypeClass>String</TypeClass>
    <ObjType>System.String</ObjType>
    <Value>Polish%</Value>
  </Constant>
</Operator>', @is_name_condition=0, @obj_name=N'', @condition_id=@condition_id OUTPUT
Select @condition_id

GO





USE [master]
GO
sp_configure 'show advanced options', 1;
RECONFIGURE;
GO




-- 3. Utwórz mechanizm audytowania operacji tworzenia, usuwania oraz modyfikacji obiektów w bazie danych Northwind (Schema_Object_Change_Group) 
--    za pomocą mechanizmu Database Audit Specification. Audyt powinien rejestrować wszystkie te operacje wykonane na bazie Northwind, 
--    a wyniki audytu mają być przechowywane w plikach dziennika zdefiniowany na poziomie serwera - SQL Server Audit (Security | Audits) o nazwie Audit-01
--    np. w katalogu C:\TEMP\   
--    https://learn.microsoft.com/en-us/sql/relational-databases/security/auditing/sql-server-audit-database-engine?view=sql-server-ver17
--    https://learn.microsoft.com/en-us/sql/relational-databases/security/auditing/create-a-server-audit-and-server-audit-specification?view=sql-server-ver17


USE [master]
GO

CREATE SERVER AUDIT [Audit-01]
TO FILE 
(	FILEPATH = N'C:\TEMP\'
	,MAXSIZE = 0 MB
	,MAX_ROLLOVER_FILES = 2147483647
	,RESERVE_DISK_SPACE = OFF
)
WITH
(	QUEUE_DELAY = 1000
	,ON_FAILURE = CONTINUE
)
GO

ALTER SERVER AUDIT [Audit-01] WITH (STATE = ON);
GO

USE north
GO

CREATE DATABASE AUDIT SPECIFICATION [Northwind_Schema_Audit]
FOR SERVER AUDIT [Audit-01]
ADD (SCHEMA_OBJECT_CHANGE_GROUP)
WITH (STATE = ON);
GO

USE north
GO
CREATE TABLE dbo.TestAuditTable (ID int)
GO
ALTER TABLE dbo.TestAuditTable ADD Name varchar(20);
GO
DROP TABLE dbo.TestAuditTable;
GO

SELECT event_time, action_id, statement, database_name, object_name 
FROM sys.fn_get_audit_file('C:\TEMP\Audit-01*', NULL, NULL)
ORDER BY event_time DESC;
GO





-- 4. Utwórz mechanizm wersjonowania danych w tabeli za pomocą temporal table w SQL Server. 
--    https://learn.microsoft.com/en-us/sql/relational-databases/tables/temporal-tables?view=sql-server-ver16
--    W bazie danych Northwind stwórz tabelę o nazwie ProductsTemporal w bazie Northwind, która będzie przechowywać dane o produktach 
--    (może być utworzona na podstawie pustej tabeli Products).
--    Skonfiguruj tabelę jako temporal table, aby SQL Server automatycznie przechowywał historię zmian w danych.
--    Dodaj, zmodyfikuj i usuń kilka rekordów w tabeli, aby wygenerować dane historyczne (czekamy 2-3 sekundy między operacjami).
--    Napisz zapytanie, które zwróci:
--		Wszystkie wersje rekordu dla konkretnego produktu.
--		Dane z tabeli historycznej dla wybranego zakresu czasu.
--              Aktualne dane.  

USE north;
GO

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ProductsTemporal' AND temporal_type = 2)
BEGIN
    ALTER TABLE [dbo].[ProductsTemporal] SET (SYSTEM_VERSIONING = OFF);
END
GO

DROP TABLE IF EXISTS [dbo].[ProductsHistory];
DROP TABLE IF EXISTS [dbo].[ProductsTemporal];
GO

CREATE TABLE [dbo].[ProductsTemporal]
(
    [ProductID] INT NOT NULL PRIMARY KEY CLUSTERED,
    [ProductName] NVARCHAR(40) NOT NULL,
    [UnitPrice] MONEY NULL,
    [UnitsInStock] SMALLINT NULL,
    [ValidFrom] DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
    [ValidTo] DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
)
WITH
(
    SYSTEM_VERSIONING = ON (HISTORY_TABLE = [dbo].[ProductsHistory])
);
GO

INSERT INTO [dbo].[ProductsTemporal] (ProductID, ProductName, UnitPrice, UnitsInStock)
SELECT ProductID, ProductName, UnitPrice, UnitsInStock
FROM [dbo].[Products];
GO

WAITFOR DELAY '00:00:03';

UPDATE [dbo].[ProductsTemporal]
SET [UnitPrice] = [UnitPrice] * 1.5
WHERE [ProductID] = 1;
GO

WAITFOR DELAY '00:00:03';

UPDATE [dbo].[ProductsTemporal]
SET [UnitsInStock] = 0
WHERE [ProductID] = 1;
GO

WAITFOR DELAY '00:00:03';

DELETE FROM [dbo].[ProductsTemporal]
WHERE [ProductID] = 2;
GO

SELECT * 
FROM [dbo].[ProductsTemporal] 
FOR SYSTEM_TIME ALL 
WHERE [ProductID] = 1
ORDER BY [ValidFrom];
GO

DECLARE @StartTime DATETIME2 = DATEADD(SECOND, -15, SYSUTCDATETIME());
DECLARE @EndTime DATETIME2 = SYSUTCDATETIME();

SELECT * 
FROM [dbo].[ProductsTemporal] 
FOR SYSTEM_TIME BETWEEN @StartTime AND @EndTime;
GO

SELECT * 
FROM [dbo].[ProductsTemporal];
GO




-- 5. Dynamiczne maskowanie danych
--    https://learn.microsoft.com/en-us/sql/relational-databases/security/dynamic-data-masking?view=sql-server-ver16
--    Wykonać i przeanalizować przykład podany w dokumentacji. 
--    Wyłączyć maskowanie dla jednej z kolumn i sprawdzić działanie.
--    Następnie zdefiniować ponownie to maskowanie i sprawdzić działanie.


USE north;
GO

CREATE SCHEMA Data;
GO

CREATE TABLE Data.Membership (
    MemberID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY CLUSTERED,
    FirstName VARCHAR(100) MASKED WITH (FUNCTION = 'partial(1, "xxxxx", 1)') NULL,
    LastName VARCHAR(100) NOT NULL,
    Phone VARCHAR(12) MASKED WITH (FUNCTION = 'default()') NULL,
    Email VARCHAR(100) MASKED WITH (FUNCTION = 'email()') NOT NULL,
    DiscountCode SMALLINT MASKED WITH (FUNCTION = 'random(1, 100)') NULL
);
GO

INSERT INTO Data.Membership (FirstName, LastName, Phone, Email, DiscountCode)
VALUES
('Roberto', 'Tamburello', '555.123.4567', 'RTamburello@contoso.com', 10),
('Janice', 'Galvin', '555.123.4568', 'JGalvin@contoso.com.co', 5),
('Shakti', 'Menon', '555.123.4570', 'SMenon@contoso.net', 50),
('Zheng', 'Mu', '555.123.4569', 'ZMu@contoso.net', 40);
GO

CREATE USER MaskingTestUser WITHOUT LOGIN;
GRANT SELECT ON SCHEMA::Data TO MaskingTestUser;
GO

EXECUTE AS USER = 'MaskingTestUser';
SELECT * FROM Data.Membership;
REVERT;
GO

ALTER TABLE Data.Membership
ALTER COLUMN Phone DROP MASKED;
GO

EXECUTE AS USER = 'MaskingTestUser';
SELECT * FROM Data.Membership;
REVERT;
GO

ALTER TABLE Data.Membership
ALTER COLUMN Phone ADD MASKED WITH (FUNCTION = 'default()');
GO

EXECUTE AS USER = 'MaskingTestUser';
SELECT * FROM Data.Membership;
REVERT;
GO

DROP TABLE Data.Membership;
DROP SCHEMA Data;
GO



-- 6. Definiowanie własnych błędów (błędów użytkownika)
--    https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-addmessage-transact-sql?view=sql-server-ver16
--    https://learn.microsoft.com/en-us/sql/t-sql/language-elements/raiserror-transact-sql?view=sql-server-ver16
--    Przeglądanie wszystkich błędów: select * from sys.messages
--    https://learn.microsoft.com/en-us/sql/relational-databases/errors-events/database-engine-error-severities?view=sql-server-ver16

--    Definicja własnego błędu o poziomie 16:
--    exec sp_addmessage 50007, 17 ,'MESSAGE', @with_log = 'TRUE'
--    go
--    Uruchomienie danego błędu
--    Raiserror(50007,16,1) with log
--    Sprawdzamy, gdzie ten błąd jest logowany.


USE [master]
GO

IF EXISTS (SELECT * FROM sys.messages WHERE message_id = 50007)
    EXEC sp_dropmessage 50007;
GO

EXEC sp_addmessage 
    @msgnum = 50007, 
    @severity = 16, 
    @msgtext = N'To jest mój testowy błąd krytyczny użytkownika! (ID: 50007)', 
    @with_log = 'TRUE',
    @replace = 'replace';
GO

RAISERROR(50007, 16, 1) WITH LOG;
GO


EXEC xp_readerrorlog 0, 1, N'50007'; 
GO

-- EXEC sp_dropmessage 50007;
-- GO

-- 7. Zapytania do katalogu systemowego SQL Server — często zadawane pytania (zadanie do wykonania podane jest na końcu)
--    https://learn.microsoft.com/en-us/sql/relational-databases/system-catalog-views/querying-the-sql-server-system-catalog-faq?view=sql-server-ver16#_FAQ7

--    Jak znaleźć wszystkie tabele, które nie mają indeksu w bazie master?
--    USE master;  
--    GO  
--    SELECT SCHEMA_NAME(schema_id) AS schema_name, name AS table_name FROM sys.tables   
--    WHERE OBJECTPROPERTY(object_id,'IsIndexed') = 0  ORDER BY schema_name, table_name;  
--    GO

--   Czy można zdefiniowac Policy, która sprawdzi to samo co powyższe zapytanie? Jeśli tak to zdefiniuj taką politykę.  
USE [master];  
GO  
SELECT SCHEMA_NAME(schema_id) AS schema_name, name AS table_name 
FROM sys.tables   
WHERE OBJECTPROPERTY(object_id,'IsIndexed') = 0  
ORDER BY schema_name, table_name;  
GO

Declare @condition_id int
EXEC msdb.dbo.sp_syspolicy_add_condition @name=N'Table Has Clustered Index', @description=N'', @facet=N'Table', @expression=N'<Operator>
  <TypeClass>Bool</TypeClass>
  <OpType>EQ</OpType>
  <Count>2</Count>
  <Attribute>
    <TypeClass>Bool</TypeClass>
    <Name>HasClusteredIndex</Name>
  </Attribute>
  <Function>
    <TypeClass>Bool</TypeClass>
    <FunctionType>True</FunctionType>
    <ReturnType>Bool</ReturnType>
    <Count>0</Count>
  </Function>
</Operator>', @is_name_condition=0, @obj_name=N'', @condition_id=@condition_id OUTPUT
Select @condition_id

GO

Declare @object_set_id int
EXEC msdb.dbo.sp_syspolicy_add_object_set @object_set_name=N'Check Table Indexes_ObjectSet', @facet=N'Database', @object_set_id=@object_set_id OUTPUT
Select @object_set_id

Declare @target_set_id int
EXEC msdb.dbo.sp_syspolicy_add_target_set @object_set_name=N'Check Table Indexes_ObjectSet', @type_skeleton=N'Server/Database', @type=N'DATABASE', @enabled=True, @target_set_id=@target_set_id OUTPUT
Select @target_set_id

EXEC msdb.dbo.sp_syspolicy_add_target_set_level @target_set_id=@target_set_id, @type_skeleton=N'Server/Database', @level_name=N'Database', @condition_name=N'', @target_set_level_id=0


GO

Declare @policy_id int
EXEC msdb.dbo.sp_syspolicy_add_policy @name=N'Check Table Indexes', @condition_name=N'Check for Polish Collation', @execution_mode=0, @policy_id=@policy_id OUTPUT, @object_set=N'Check Table Indexes_ObjectSet'
Select @policy_id


GO


