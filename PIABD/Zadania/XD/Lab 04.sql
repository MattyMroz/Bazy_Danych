--------------------------------------------------------------
-- Kasowanie istniejących loginów, użytkowników i schematów --
--------------------------------------------------------------
USE MASTER
GO
IF EXISTS (SELECT name FROM sys.server_principals WHERE name = 'admin') DROP LOGIN admin;
IF EXISTS (SELECT name FROM sys.server_principals WHERE name = 'test') DROP LOGIN test;
IF EXISTS (SELECT name FROM sys.server_principals WHERE name = 'U11') DROP LOGIN U11;
IF EXISTS (SELECT name FROM sys.server_principals WHERE name = 'U21') DROP LOGIN U21;
IF EXISTS (SELECT name FROM sys.server_principals WHERE name = 'U31') DROP LOGIN U31;
GO
USE [TEST]
GO
DROP USER  IF EXISTS [test]
GO
USE [north]
GO
DROP SCHEMA IF EXISTS [u11];
GO
DROP USER IF EXISTS [u11];
GO
DROP SCHEMA IF EXISTS [u21];
GO
DROP USER  IF EXISTS [u21];
GO
DROP SCHEMA IF EXISTS [u31];
GO
DROP USER  IF EXISTS [u31]
GO

DROP DATABASE IF EXISTS TEST1;
GO
DROP DATABASE IF EXISTS TEST2;
GO
---------------------------------------------------
---------------------------------------------------

------------------------------------------------------------------------------------------------
-- Przykłady -----------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- Tworzymy trzy loginy U11, U21 i U31 z takimi samymi nazwami użytkowników w bazie Northiwnd --
------------------------------------------------------------------------------------------------
USE [master]
CREATE LOGIN [U11] WITH PASSWORD=N'u11', DEFAULT_DATABASE=[north], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
CREATE LOGIN [U21] WITH PASSWORD=N'u21', DEFAULT_DATABASE=[north], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
CREATE LOGIN [U31] WITH PASSWORD=N'u31', DEFAULT_DATABASE=[north], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
USE [north]
GO
CREATE USER [u11] FOR LOGIN [U11];
GO
CREATE SCHEMA [u11] AUTHORIZATION [u11];
GO
ALTER USER [u11] WITH DEFAULT_SCHEMA=[u11];
GO
CREATE USER [u21] FOR LOGIN [U21]
GO
CREATE SCHEMA [u21] AUTHORIZATION [u21];
GO
ALTER USER [u21] WITH DEFAULT_SCHEMA=[u21]
GO
CREATE USER [u31] FOR LOGIN [U31]
GO
CREATE SCHEMA [u31] AUTHORIZATION [u31];
GO
ALTER USER [u31] WITH DEFAULT_SCHEMA=[u31]
GO

--------------------------------------------------------------------------------
-- I. Prawo CREATE TABLE nadajemy użytkownikowi u31
GRANT CREATE TABLE TO u31; -- prawo do tworzenia tabeli na bazie north
EXEC sp_helprotect 'CREATE TABLE', 'u31', NULL, s   --dla konkretnej bazy danych
GO
-- II. Prawo CREATE PROCEDURE nadajemy użytkownikowi u21
GRANT create proc to u21;
EXEC sp_helprotect 'CREATE PROCEDURE', 'u21', null, s --dla konkretnej bazy danych
GO
-- III. Użytkownik bazy north u11 bez praw
  --uprawnienia systemowe dla wszystkich user'ów w danej bazie 
EXEC sp_helprotect NULL, NULL, null, s
GO
--------------------------------------------------------------------------------
-- IV. Jako u31 tworzy tabelę customer1 w schemacie u31
EXECUTE AS LOGIN='u31';
CREATE TABLE u31.customer1 (CustomerName varchar(20));
INSERT INTO u31.customer1 VALUES ('Cust1'),('Cust2'),('Cust3'); --dodać kilka rekordów
SELECT * FROM u31.customer1 --wyświetlić dane
--CREATE TABLE dbo.customer1 (CustomerName varchar(20)); --nie może w innym schemacie tworzyć tabel

EXEC sp_helprotect NULL, 'u31', NULL, s  --sprawdzenie uprawnień dla danego user'a
SELECT * FROM fn_my_permissions (NULL, 'DATABASE');--sprawdzenie upranień na poziomie bazy danych
revert; --pamiętajmy o tym poleceniu

---------------------------------------------------------------------------------
-- V. Użytkownik bazy danych u21 ma dostęp select tylko do tabeli, którą utworzy u31 (i to on ma nadać to uprawnienie)
EXECUTE AS LOGIN='u31';
GRANT select ON u31.customer1 TO u21
revert
  --Tworzymy procedurę
EXECUTE AS LOGIN='u21';
SELECT * FROM fn_my_permissions ('u31.customer1', 'OBJECT');
EXEC sp_helprotect customer1, null, null, 'o'
EXEC sp_helprotect NULL, null, null, 's'
GO
CREATE PROC u21.customer_proc WITH EXECUTE AS caller
AS 
	BEGIN 
	SELECT * FROM u31.customer1; 
	END;
GO
EXEC u21.customer_proc; --u2 potrafi wykonać tą procedurę
REVERT;

-----------------------------------------------------------------------------------
-- VI. Użytkownik u11 ma uprawnienia do wykonywania procedury utworzonej przez u21 (i to on ma nadać to uprawnienie)
EXECUTE AS LOGIN='u21';
GRANT execute on u21.customer_proc TO u11;
REVERT;
  --wykonyjemy procedurę
EXECUTE AS LOGIN='u11';
SELECT * FROM u31.Customer1 --brakuje uprawnień
EXEC u21.customer_proc; --brakuje uprawnień
revert
--Modyfikujemy jako u21 procedurę, aby była wywoływana z prawami właściciela
EXECUTE AS LOGIN='u21';
GO
ALTER PROC u21.customer_proc WITH EXECUTE AS owner  
AS 
	BEGIN 
	SELECT * FROM u31.customer1; 
	END;
GO
REVERT;
--Sprawdzamy jako u11 czy mamy prawo wykonywania danej procedury
EXECUTE AS LOGIN='u11';
GO
SELECT * FROM u31.Customer1 --brakuje uprawnień
GO
EXEC u21.customer_proc; --jest ok
GO
REVERT;
--lub musimy nadać uprawnienia do wszystkich obiektów (czyli do customer1 jako u31 dla u11)
execute as login='u31';
GRANT SELECT on u31.customer1 TO u11
revert
--wracamy z procedurą jako wykonywana z prawami wywołującego
EXECUTE AS LOGIN='u21';
GO
ALTER PROC u21.customer_proc WITH EXECUTE AS caller  
AS 
	BEGIN 
	SELECT * FROM u31.customer1; 
	END;
GO
REVERT;
--Sprawdzamy jako u11 czy mamy prawo wykonywania danej procedury
EXECUTE AS LOGIN='u11';
SELECT * FROM u31.Customer1; --jest ok
EXEC u21.customer_proc; --jest ok
REVERT;

--------------------------------------------------------------------------------
-- co z procedurą, gdy obiekty są w tym samym schemacie i mamy jako u11 prawo --
-- tylko wywołania procedury ---------------------------------------------------
--------------------------------------------------------------------------------
-- jako sa
GO
CREATE PROC dbo.customer_proc WITH EXECUTE AS caller --obojętnie
AS 
	BEGIN 
	SELECT * FROM dbo.Customers; 
	END;
GO
GRANT EXEC ON dbo.customer_proc TO u11;
GO
-------
EXECUTE AS LOGIN='u11';
SELECT * FROM dbo.Customers --brakuje uprawnień
EXEC dbo.customer_proc; --ok
REVERT;
-- co z widokiem
-- jako sa
GO
CREATE VIEW dbo.view_1 AS SELECT * FROM dbo.Customers;
GO
CREATE VIEW u31.view_1 AS SELECT * FROM dbo.Customers;
GO
GRANT SELECT ON dbo.view_1 TO u11 --jako sa daliśmy prawo do widoku dbo.view_1
GRANT SELECT ON u31.view_1 TO u11 --jako sa daliśmy prawo do widoku u31.view_1

--Sprawdzamy dla użytkownika u11
EXECUTE AS LOGIN='u11';
SELECT * FROM dbo.Customers --brakuje uprawnień
SELECT * FROM dbo.View_1    --Ok (obiekty w tym samym schematacie)
SELECT * FROM u31.View_1    --brakuje uprawnień (obiekty w różnych schematach)
REVERT;

-- Co zrobić aby u31.view_1 wykonał się poprawnie 
-- (dodać uprawnienie SELECT do tabeli dbo.customers dla u11) 
GO


----------------------------------------------------------------
-- Uwaga na niebezpieczny kod (np. polecenie delete products) --
----------------------------------------------------------------

create PROCEDURE a1 
	@p1 varchar(50)
AS
	BEGIN
	execute (@p1);
	END
GO
EXEC dbo.a1 'select * from customers';


--------------
-- SYNONIMY --
--------------
USE [north]
/****** Object:  Synonym [dbo].[emp] ******/
CREATE SYNONYM [dbo].[emp] FOR [north].[dbo].[Employees]
GO
GRANT SELECT ON [dbo].[emp] TO [u31]
GO

-- logujemy się jako u31
EXECUTE AS LOGIN='u31';
SELECT * FROM dbo.employees  --brak prawa
SELECT * FROM dbo.emp;  --OK
REVERT;
------------------------------------------------------------------------


----------------------
-- ROLE UŻYTKOWNIKA --
----------------------

-- 1. Utwórz dwie role R1 oraz R2
USE [north]
GO
CREATE ROLE [R1]
GO
CREATE ROLE [R2]
GO

-- 2. Roli R1 przypisać prawa SELECT, INSERT dla tabeli EMPLOYEES
use [north]
GO
GRANT INSERT ON [dbo].[Employees] TO [R1]
GO
use [north]
GO
GRANT SELECT ON [dbo].[Employees] TO [R1]
GO


-- 3. Roli R2 przypisać prawa SELECT, INSERT, UPDATE, DELETE dla tabeli ORDERS z opcją WITH GRANT OPTION oraz zabieramy prawo DENY do polecenia INSERT dla tabeli EMPLOYEES
use [north]
GO
GRANT DELETE ON [dbo].[Orders] TO [R2] WITH GRANT OPTION
GO
use [north]
GO
GRANT INSERT ON [dbo].[Orders] TO [R2] WITH GRANT OPTION
GO
use [north]
GO
GRANT SELECT ON [dbo].[Orders] TO [R2] WITH GRANT OPTION
GO
use [north]
GO
GRANT UPDATE ON [dbo].[Orders] TO [R2] WITH GRANT OPTION
GO

use [north]
GO
DENY INSERT ON [dbo].[Employees] TO [R2]
GO




-- 4. Użytkownika u31 zapisujemy do roli R1 i sprawdzamy czy ma możliwość wykonywania polecenia SELECT, INSERT oraz DELETE na tabeli EMPLOYEES.
	-- Następnie sprawdzamy czy możemy wykonać select na tabeli ORDERS.
ALTER ROLE [R1] ADD MEMBER [u31]
GO

EXECUTE AS LOGIN = 'u31'
GO
SELECT * FROM dbo.Employees
GO
INSERT INTO dbo.Employees (LastName, FirstName) VALUES ('Test', 'User')
GO
DELETE FROM dbo.Employees WHERE LastName = 'Test'
GO
SELECT * FROM dbo.Orders
GO
REVERT
GO

-- 6. Do roli DENYDATAREADER dodajemy rolę R2 i sprawdzamy uprawnienia (odwrotnie nie da rady)
ALTER ROLE [R2] ADD MEMBER [u31]
GO
ALTER ROLE [db_denydatareader] ADD MEMBER [R2]
GO
EXECUTE AS LOGIN = 'u31'
GO
SELECT * FROM dbo.Employees
GO
SELECT * FROM dbo.Orders
GO
REVERT
GO


-- 7. Wypisujemy rolę R2 z roli DENYDATAREADER i wracamy do poprzeniego stanu z pkt.4;
ALTER ROLE [db_denydatareader] DROP MEMBER [R2]
GO
EXECUTE AS LOGIN = 'u31'
GO
SELECT * FROM dbo.Employees
GO
SELECT * FROM dbo.Orders
GO
REVERT
GO

-- 8. Jako u31 dodajemy uprawnienie SELECT dla tabeli ORDERS dla uzytkownika u21, także z prawami WITH GRANT OPTION 
	-- nie działa mimo, że jesteśmy zapisani do roli R2, to musimy przypisać bezpośrednio dane uprawnienia jako sa
GRANT SELECT ON north.dbo.Orders TO u31 WITH GRANT OPTION  --jako sa
EXECUTE AS LOGIN='u31';
GRANT SELECT ON north.dbo.Orders TO u21 WITH GRANT OPTION
SELECT * FROM Orders
REVERT;

-- 9. Sprawdzamy czy jako u21 mamy prawo wykonywania tego zapytania i dodatkowo dajemy uprawnienia SELECT dla użytkownika u11
EXECUTE AS LOGIN='u21';
GRANT SELECT ON north.dbo.Orders TO u11
SELECT * FROM Orders
REVERT;
--Sprawdzamy u11
EXECUTE AS LOGIN='u11';
SELECT * FROM Orders
REVERT;
--Jeśli jako user31 chcielibyśmy wyłączyć CASCADE OPTION to polecenie wygląda następująco
REVOKE SELECT ON north.dbo.Orders TO u21 CASCADE AS [u31]

-- 10. Jako 'sa' zabieramy prawo GRANT OPTION i sprawdzamy 
-- czy 'u21' i 'u11' mają dalej uprawnienia przypisane przez uzytkownika 'u31'.
REVOKE GRANT OPTION FOR SELECT ON [dbo].[Orders] TO [u31] CASCADE AS [dbo] -- cofamy tylko opcję GRANT OPTION (musi być cascade)
--tylko u31 wykona instrukcję select * from orders
REVOKE SELECT ON north.dbo.Orders TO u31 CASCADE AS [dbo] -- cofamy uprawnienie SELECT
--tylko u31 wykona tą instrukcję, gdyż należy do grupy R2, pozostali użytkownicy nie wykonają instrukcji: select * from orders
----------------------------------------------------------------------------------------------------------------------------------


-- Przykładowe polecenia do wykorzystania w powyższych przykładach 
GRANT SELECT ON north.dbo.Orders TO u31 WITH GRANT OPTION AS dbo

EXECUTE AS LOGIN='u31';
SELECT * FROM fn_my_permissions ('dbo.orders', 'OBJECT'); --uprawnienia
GRANT SELECT ON north.dbo.Orders TO u21 WITH GRANT OPTION
SELECT * FROM Orders
REVERT;

EXECUTE AS LOGIN='u21';
GRANT SELECT ON north.dbo.Orders TO user11
SELECT * FROM Orders
REVERT;

EXECUTE AS LOGIN='u11';
SELECT * FROM Orders
REVERT;

