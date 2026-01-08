--------------------------------------------------------------
-- Kasowanie istniej¹cych loginów, u¿ytkowników i schematów --
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
USE [Northwind]
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
-- Przyk³ady -----------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- Tworzymy trzy loginy U11, U21 i U31 z takimi samymi nazwami u¿ytkowników w bazie Northiwnd --
------------------------------------------------------------------------------------------------
USE [master]
CREATE LOGIN [U11] WITH PASSWORD=N'u11', DEFAULT_DATABASE=[Northwind], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
CREATE LOGIN [U21] WITH PASSWORD=N'u21', DEFAULT_DATABASE=[Northwind], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
CREATE LOGIN [U31] WITH PASSWORD=N'u31', DEFAULT_DATABASE=[Northwind], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
USE [Northwind]
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
-- I. Prawo CREATE TABLE nadajemy u¿ytkownikowi u31
GRANT CREATE TABLE TO u31; -- prawo do tworzenia tabeli na bazie Northwind
EXEC sp_helprotect 'CREATE TABLE', 'u31', NULL, s   --dla konkretnej bazy danych
GO
-- II. Prawo CREATE PROCEDURE nadajemy u¿ytkownikowi u21
GRANT create proc to u21;
EXEC sp_helprotect 'CREATE PROCEDURE', 'u21', null, s --dla konkretnej bazy danych
GO
-- III. U¿ytkownik bazy Northwind u11 bez praw
  --uprawnienia systemowe dla wszystkich user'ów w danej bazie 
EXEC sp_helprotect NULL, NULL, null, s
GO
--------------------------------------------------------------------------------
-- IV. Jako u31 tworzy tabelê customer1 w schemacie u31
EXECUTE AS LOGIN='u31';
CREATE TABLE u31.customer1 (CustomerName varchar(20));
INSERT INTO u31.customer1 VALUES ('Cust1'),('Cust2'),('Cust3'); --dodaæ kilka rekordów
SELECT * FROM u31.customer1 --wyœwietliæ dane
--CREATE TABLE dbo.customer1 (CustomerName varchar(20)); --nie mo¿e w innym schemacie tworzyæ tabel

EXEC sp_helprotect NULL, 'u31', NULL, s  --sprawdzenie uprawnieñ dla danego user'a
SELECT * FROM fn_my_permissions (NULL, 'DATABASE');--sprawdzenie upranieñ na poziomie bazy danych
revert; --pamiêtajmy o tym poleceniu

---------------------------------------------------------------------------------
-- V. U¿ytkownik bazy danych u21 ma dostêp select tylko do tabeli, któr¹ utworzy u31 (i to on ma nadaæ to uprawnienie)
EXECUTE AS LOGIN='u31';
GRANT select ON u31.customer1 TO u21
revert
  --Tworzymy procedurê
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
EXEC u21.customer_proc; --u2 potrafi wykonaæ t¹ procedurê
REVERT;

-----------------------------------------------------------------------------------
-- VI. U¿ytkownik u11 ma uprawnienia do wykonywania procedury utworzonej przez u21 (i to on ma nadaæ to uprawnienie)
EXECUTE AS LOGIN='u21';
GRANT execute on u21.customer_proc TO u11;
REVERT;
  --wykonyjemy procedurê
EXECUTE AS LOGIN='u11';
SELECT * FROM u31.Customer1 --brakuje uprawnieñ
EXEC u21.customer_proc; --brakuje uprawnieñ
revert
--Modyfikujemy jako u21 procedurê, aby by³a wywo³ywana z prawami w³aœciciela
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
SELECT * FROM u31.Customer1 --brakuje uprawnieñ
GO
EXEC u21.customer_proc; --jest ok
GO
REVERT;
--lub musimy nadaæ uprawnienia do wszystkich obiektów (czyli do customer1 jako u31 dla u11)
execute as login='u31';
GRANT SELECT on u31.customer1 TO u11
revert
--wracamy z procedur¹ jako wykonywana z prawami wywo³uj¹cego
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
-- co z procedur¹, gdy obiekty s¹ w tym samym schemacie i mamy jako u11 prawo --
-- tylko wywo³ania procedury ---------------------------------------------------
--------------------------------------------------------------------------------
-- jako sa
GO
CREATE PROC dbo.customer_proc WITH EXECUTE AS caller --obojêtnie
AS 
	BEGIN 
	SELECT * FROM dbo.Customers; 
	END;
GO
GRANT EXEC ON dbo.customer_proc TO u11;
GO
-------
EXECUTE AS LOGIN='u11';
SELECT * FROM dbo.Customers --brakuje uprawnieñ
EXEC dbo.customer_proc; --ok
REVERT;
-- co z widokiem
-- jako sa
GO
CREATE VIEW dbo.view_1 AS SELECT * FROM dbo.Customers;
GO
CREATE VIEW u31.view_1 AS SELECT * FROM dbo.Customers;
GO
GRANT SELECT ON dbo.view_1 TO u11 --jako sa daliœmy prawo do widoku dbo.view_1
GRANT SELECT ON u31.view_1 TO u11 --jako sa daliœmy prawo do widoku u31.view_1

--Sprawdzamy dla u¿ytkownika u11
EXECUTE AS LOGIN='u11';
SELECT * FROM dbo.Customers --brakuje uprawnieñ
SELECT * FROM dbo.View_1    --Ok (obiekty w tym samym schematacie)
SELECT * FROM u31.View_1    --brakuje uprawnieñ (obiekty w ró¿nych schematach)
REVERT;

-- Co zrobiæ aby u31.view_1 wykona³ siê poprawnie 
-- (dodaæ uprawnienie SELECT do tabeli dbo.customers dla u11) 
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
USE [Northwind]
/****** Object:  Synonym [dbo].[emp] ******/
CREATE SYNONYM [dbo].[emp] FOR [Northwind].[dbo].[Employees]
GO
GRANT SELECT ON [dbo].[emp] TO [u31]
GO

-- logujemy siê jako u31
EXECUTE AS LOGIN='u31';
SELECT * FROM dbo.employees  --brak prawa
SELECT * FROM dbo.emp;  --OK
REVERT;
------------------------------------------------------------------------


----------------------
-- ROLE U¯YTKOWNIKA --
----------------------

-- 1. Utwórz dwie role R1 oraz R2

-- 2. Roli R1 przypisaæ prawa SELECT, INSERT dla tabeli EMPLOYEES

-- 3. Roli R2 przypisaæ prawa SELECT, INSERT, UPDATE, DELETE dla tabeli ORDERS z opcj¹ WITH GRANT OPTION oraz zabieramy prawo DENY do polecenia INSERT dla tabeli EMPLOYEES

-- 4. U¿ytkownika u31 zapisujemy do roli R1 i sprawdzamy czy ma mo¿liwoœæ wykonywania polecenia SELECT, INSERT oraz DELETE na tabeli EMPLOYEES.
	-- Nastêpnie sprawdzamy czy mo¿emy wykonaæ select na tabeli ORDERS.

-- 5. Zapisujemy uzytkownika u31 do roli R2 i sprawdzamy powy¿sze uprawnienia.

-- 6. Do roli DENYDATAREADER dodajemy rolê R2 i sprawdzamy uprawnienia (odwrotnie nie da rady)

-- 7. Wypisujemy rolê R2 z roli DENYDATAREADER i wracamy do poprzeniego stanu z pkt.4;

-- 8. Jako u31 dodajemy uprawnienie SELECT dla tabeli ORDERS dla uzytkownika u21, tak¿e z prawami WITH GRANT OPTION 
	-- nie dzia³a mimo, ¿e jesteœmy zapisani do roli R2, to musimy przypisaæ bezpoœrednio dane uprawnienia jako sa
GRANT SELECT ON northwind.dbo.Orders TO u31 WITH GRANT OPTION  --jako sa
EXECUTE AS LOGIN='u31';
GRANT SELECT ON northwind.dbo.Orders TO u21 WITH GRANT OPTION
SELECT * FROM Orders
REVERT;

-- 9. Sprawdzamy czy jako u21 mamy prawo wykonywania tego zapytania i dodatkowo dajemy uprawnienia SELECT dla u¿ytkownika u11
EXECUTE AS LOGIN='u21';
GRANT SELECT ON northwind.dbo.Orders TO u11
SELECT * FROM Orders
REVERT;
--Sprawdzamy u11
EXECUTE AS LOGIN='u11';
SELECT * FROM Orders
REVERT;
--Jeœli jako user31 chcielibyœmy wy³¹czyæ CASCADE OPTION to polecenie wygl¹da nastêpuj¹co
REVOKE SELECT ON northwind.dbo.Orders TO u21 CASCADE AS [u31]

-- 10. Jako 'sa' zabieramy prawo GRANT OPTION i sprawdzamy 
-- czy 'u21' i 'u11' maj¹ dalej uprawnienia przypisane przez uzytkownika 'u31'.
REVOKE GRANT OPTION FOR SELECT ON [dbo].[Orders] TO [u31] CASCADE AS [dbo] -- cofamy tylko opcjê GRANT OPTION (musi byæ cascade)
--tylko u31 wykona instrukcjê select * from orders
REVOKE SELECT ON northwind.dbo.Orders TO u31 CASCADE AS [dbo] -- cofamy uprawnienie SELECT
--tylko u31 wykona t¹ instrukcjê, gdy¿ nale¿y do grupy R2, pozostali u¿ytkownicy nie wykonaj¹ instrukcji: select * from orders
----------------------------------------------------------------------------------------------------------------------------------


-- Przyk³adowe polecenia do wykorzystania w powy¿szych przyk³adach 
GRANT SELECT ON northwind.dbo.Orders TO u31 WITH GRANT OPTION AS dbo

EXECUTE AS LOGIN='u31';
SELECT * FROM fn_my_permissions ('dbo.orders', 'OBJECT'); --uprawnienia
GRANT SELECT ON northwind.dbo.Orders TO u21 WITH GRANT OPTION
SELECT * FROM Orders
REVERT;

EXECUTE AS LOGIN='u21';
GRANT SELECT ON northwind.dbo.Orders TO user11
SELECT * FROM Orders
REVERT;

EXECUTE AS LOGIN='u11';
SELECT * FROM Orders
REVERT;

