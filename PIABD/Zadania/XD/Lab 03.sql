-----------------------------------------------------------------------------------------------------------------------
-- Uprawnienia --------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

-- Podmiot zabezpieczeń (ang. security principal)
-- Przedmiot zabezpieczeń (ang. securable)
-- Wszystkie polecenia można utworzyć za pomocą narzędzia SSMS i za pommocą tego narzędzia sprawdzać przypisane upranienia (warto z tego narzędzia korzystać)
-- Uwaga: Login na poziomie instancji SQL Server zawiera hasło. Natomiast, każda baza danych ma swoich użytkowników na poziomie każdej z baz.
	-- Login jest mapowany w każdej bazie danych na konkretne konto bazy danych.
	-- (jeśli takiego konta nie ma to mapowany jest jako użytkownik Guest z odpowiednimi uprawnieniami chyba, że konto to jest wyłączone)

-----------------------------------------------------------------------------------------------------------------
-- Kasowanie istniejących loginów, użytkowników i schematów -----------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

-- Tworzymy bazę TEST i dwie tabele Categories i Products
USE MASTER
GO
DROP DATABASE IF EXISTS TEST;
GO
CREATE DATABASE TEST;
GO
USE TEST
GO
SELECT * INTO test.dbo.categories FROM Northwind.dbo.Categories
SELECT * INTO test.dbo.products FROM Northwind.dbo.Products

-- Tworzymy nowe konto na poziomie serwera o nazwie ADMIN (próbujemy się zalogować)
-- aby to się udało musimy zdefiniować domyślną bazę danych dla danego konta logowania (default MASTER)
-- jeśli damy bazę TEST jako default to niestety system nie pozwoli nam na zalogowanie, gdyż nie mamy uprawnień do bazy TEST
CREATE LOGIN [ADMIN] WITH PASSWORD='admin', DEFAULT_DATABASE=[master], 
	DEFAULT_LANGUAGE=[polski], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;
GO

-- Logujemy się jako [ADMIN] i sprawdzamy co widzimy w SSMS 
-- (w Object Explorer możemy wykonać dodatkowe połączenie za pomocą CONNECT podając powyższe konto)
-- Następnie kasujemy to konto.
-- Jeśli są kłopoty to w pasku SSMS jest ikonka Activity Monitor, 
-- gdzie możemy zamknąć dane połączenie dla użytkownika [ADMIN] (Kill Process)
DROP LOGIN [ADMIN]
GO

-- Jeszcze raz definiujemy dane konto generując kod za pomocą SSMS (Security | Logins | pod prawym przyciskiem myszy mamy New Logins ...)
CREATE LOGIN [ADMIN] WITH PASSWORD='admin', DEFAULT_DATABASE=[Test], 
	DEFAULT_LANGUAGE=[polski], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;

-- Logujemy się jako [ADMIN] i sprawdzamy co widzimy w SSMS 
-- Tutaj niestety nie jesteśmy wstanie zalogować się do bazy Test.

-- Sprawdzamy czy konto GUEST jest włączone (na poziomie bazy danych TEST)
-- standardowo uprawnienie connect jest wyłączone i jeśli włączymy to uprawnienie to możemy wejść do danej bazy danych 
-- z racji uprawnień użytkownika GUEST oraz uprawnień roli PUBLIC (konto użytkownika bazy GUEST jest typu "SQL user without login")
USE TEST
GO
REVOKE CONNECT TO [guest] 
-- polecenie do wyłączenia konta Guest w bazie TEST 
-- (ikonka w SSMS pokazuje ikonkę z przekreślonym czerwonym krzyżykiem)
-- Miejsce sprawdzenia (Databases | wybieramy bazę Test | Security | Users)
GO
GRANT CONNECT TO [guest]  -- ADMIN widzi strukturę bazy, ale bez obiektów (sprawdzamy)
GO
GRANT SELECT ON categories TO public -- ADMIN widzi, także obiekt Categories (sprawdzamy)
GO
REVOKE SELECT ON categories TO public -- wracamy do stanu poprzedniego (sprawdzamy)

-- Uwaga! Zabranie prawa CONNECT TO użytkownikowi Guest powoduje brak dostępu do bazy dla loginu ADMIN
-- Wykonać taką operację.

-- Wykonujemy nadanie uprawnień (prawo CONNECT) za pomocą SSMS - Databases | wybieramy bazę Test (PKM) | Properties | Permissions
-- Przyznawanie i zabranie uprawnień za pomocą SSMS -  Databases | wybieramy bazę Test | Tables (PKM) | Properties | Permissions


---------------------------------------------------
-- Zapisujemy użytkownika ADMIN do roli sysadmin --
-- i sprawdzamy co widzi w bazie TEST, Northwind --
---------------------------------------------------
ALTER SERVER ROLE [sysadmin] ADD MEMBER [admin] -- (sprawdzamy)
-- wypisujemy login ADMIN z roli sysadmin
ALTER SERVER ROLE [sysadmin] DROP MEMBER [admin]

-- sprawdzamy jakie są role serwera i jakie mają uprawnienia
EXEC sp_srvrolepermission		        -- oglądanie wszystkich praw
EXEC sp_srvrolepermission 'dbcreator'	-- oglądanie szczegółowych praw

ALTER SERVER ROLE [dbcreator] ADD MEMBER [ADMIN] 
-- sprawdzić czy może on założyć i usunąć swoją bazę danych np. Test1
-- wracamy do poprzedniego stanu wcześniej kasujac bazę Test1
ALTER SERVER ROLE [dbcreator] DROP MEMBER [admin]


------------------------------------------------------------------------------------------------------------------------------
-- Zamiast, za każdym razem podłączać się do serwera w okienku Object Explorer, możemy wykorzystać polecenie execute as ... --
------------------------------------------------------------------------------------------------------------------------------
USE TEST --Pamiętajmy iż uprawnienia dla użytkowników dodajemy w konkretnej bazie danych (nie w bazie master) 
GRANT CONNECT TO [guest]
GO
USE TEST  -- po wykonaniu polecenia EXECUTE AS LOGIN ... a przed wykonaniem polecenia REVERT musimy znajdować się w tej samej bazie danych
PRINT Suser_Sname(); -- konto na poziomie instancji (sa)
PRINT user_name(); -- konto na poziomie bazy danych (dbo)

EXECUTE AS LOGIN='ADMIN'; -- tym poleceniem podszywamy się pod konto 'admin' (można użyć też polecenie EXECUTE AS USER ... dla użytkownika bazy danych a nie instancji)
PRINT Suser_Sname(); -- konto na poziomie instancji (ADMIN)
PRINT user_name();   -- konto na poziomie bazy danych (guest)
REVERT; -- tym poleceniem wracamy do użytkownika sa, który ma prawo IMPERSONATE aby podszyć się pod czyjeś konto bez logowania

EXECUTE AS USER='guest'; -- tym poleceniem podszywamy się pod konto 'guest' 
PRINT Suser_Sname(); -- konto na poziomie instancji (rola public)
PRINT user_name();   -- konto na poziomie bazy danych (user guest)
REVERT; 
GO

-- Wracamy do standardowych ustawień dla gościa (wyłączamy to konto)
USE TEST
REVOKE CONNECT TO [guest]  

---------------------------------------------
-- Prawa szczegółowe na poziomie instancji --
---------------------------------------------
USE MASTER
GRANT CREATE ANY DATABASE to [ADMIN]
-- i sprawdzamy uprawnienia graficznie Instancja|Properties|Permmisions
-- lub SECURITY|LOGINS|login ADMIN|Properties|Securables
USE MASTER
PRINT Suser_Sname();
EXECUTE AS LOGIN='ADMIN';
PRINT Suser_Sname();
CREATE DATABASE Test2; 
DROP DATABASE IF EXISTS Test2;
REVERT;
-- wracamy do poprzedniego stanu i zabieramy uprawnienia do instancji
REVOKE CREATE ANY DATABASE to [ADMIN];

---------------------------------------
-- Tworzenie własnej roli serwerowej --
---------------------------------------
USE [master]
GO
CREATE SERVER ROLE [RolaSerwerowa1];
GO
GRANT CREATE ANY DATABASE TO [RolaSerwerowa1];
GO
ALTER SERVER ROLE [RolaSerwerowa1] ADD MEMBER [admin];
GO
-- i sprawdzamy czy admin potrafi utworzyć i skasować swoją bazę danych
EXECUTE AS LOGIN='admin';
PRINT Suser_Sname();
CREATE DATABASE Test2; 
DROP DATABASE Test2;
REVERT;

-- Sprawdzamy nazwę użytkowników serwera
SELECT * FROM sys.syslogins;
--lub
SELECT * FROM sys.server_principals
------------------------------------------------
-- Na poziomie serwera i kont logowania LOGIN --
------------------------------------------------
-- Wyłączamy konto logowania i jako ADMIN nie możemy się logować do instancji SQL Server 
-- W każdym kroku sprawdzamy możliwość logowania jako ADMIN za pomocą SSMS w sosbnym połączeniu.
-- Poniższe ustawienia znaleźć w SSMS.
ALTER LOGIN [ADMIN] DISABLE
GO
-- Włączamy konto logowania
ALTER LOGIN [ADMIN] ENABLE
GO

-- Brak uprawnień do logowania do serwera
DENY CONNECT SQL TO [ADMIN]
GO
-- Włączenie uprawnień do logowania do serwera
GRANT CONNECT SQL TO [ADMIN]
GO

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
-- Tworzymy użytownika bazy danych o nazwie test przypisanego do loginu TEST w bazie Test --
--------------------------------------------------------------------------------------------
-- Definiujemy login [TEST]
-- w bazie Test dodajemy użytkownika bazy, także o nazwie [test] (login 'sa' ma przypisany w bazach użytkownika 'dbo')
-- (nazwa nie musi być taka sama jak login) na podstawie loginu [TEST].
-- Tym samym dodajemy użytkownika do konkretnej bazy danych (z prawem CONNECT standardowo)
-- i wtedy nie ma już uprawnień związanych z użytkownikiem GUEST tylko z rolą PUBLIC
USE MASTER
CREATE LOGIN [TEST] WITH PASSWORD='test', DEFAULT_DATABASE=[Test], 
	DEFAULT_LANGUAGE=[polski], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;

USE [TEST]
GO
CREATE USER [test] FOR LOGIN [test]
GO
ALTER USER [test] WITH DEFAULT_SCHEMA=[dbo]
GO

-- Sprawdzamy możliwość zalogowania do serwera i bazy danych Test (OK). 

-- Następnie dodajemy konkretne uprawnienia
USE TEST
GRANT SELECT ON products to GUEST; -- to uprawnienie działa jeśli jest włączony GUEST i nie mamy przypisanego żadnego konta
GRANT SELECT ON categories to PUBLIC; -- to uprawnienie działa zawsze

-- Sprawdzamy dostęp do tabeli products i categories
EXECUTE AS LOGIN='TEST'; 
-- lub 
-- EXECUTE AS USER='test'
PRINT Suser_Sname();
SELECT * FROM products; -- nie działa
SELECT * FROM categories; -- działa
REVERT;

-- Wracamy do uprawnień poprzednich bez uprawnień dla GUEST i PUBLIC 
-- (blokujemy użytkownika GUEST jeśli nie był wcześniej zablokowany) i sprawdzamy j.w.
REVOKE SELECT ON products to GUEST; 
REVOKE SELECT ON categories to PUBLIC;

--------------------------------------------------------------------------
-- W takiej konfiguracji braku uprawnień do tabel realizujemy zadania: ---
-- Jeśli brakuje nam uprawnień w zadanich to dodajemy je przez login sa --
--------------------------------------------------------------------------

-- 1. Przypisujemy uprawnienia SELECT, INSERT na tabeli Categories dla użytkownika test

USE [master]
GO
CREATE DATABASE [Northwind] ON 
( FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\north.mdf' ),
( FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\north_log.ldf' )
 FOR ATTACH
GO


USE [master]
GO

CREATE DATABASE [TEST]
GO

USE [TEST]
GO

SELECT * INTO [dbo].[categories] FROM [Northwind].[dbo].[Categories]
SELECT * INTO [dbo].[products] FROM [Northwind].[dbo].[Products]
GO

USE [master]
GO

IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'test')
BEGIN
    CREATE LOGIN [test] WITH PASSWORD=N'test', DEFAULT_DATABASE=[TEST], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
END
GO

USE [TEST]
GO

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'test')
BEGIN
    CREATE USER [test] FOR LOGIN [test]
END
GO

---

USE [TEST]
GO
GRANT INSERT ON [dbo].[categories] TO [test]
GO
GRANT SELECT ON [dbo].[categories] TO [test]
GO

-- 2. Sprawdzamy czy działają dane polecenia polecenie SELECT i INSERT na tabeli Categories dla użytkownika test 
-- Sprawdzić także czy działa polcenie DELETE i UPDATE na tej tabeli.

INSERT INTO [dbo].[categories]
           ([CategoryID]
           ,[CategoryName]
           ,[Description]
           ,[Picture])
     VALUES
           (100
           ,'Kategoria'
           ,'Opis'
           ,NULL)
GO

SELECT TOP (1000) [CategoryID]
      ,[CategoryName]
      ,[Description]
      ,[Picture]
  FROM [TEST].[dbo].[categories]
GO

-- 3. Modyfikujemy nazwę wcześniej dodanej kategorii.

UPDATE [dbo].[categories]
   SET [CategoryName] = 'Inna'
      ,[Description] = 'Zmieniony opis'
 WHERE [CategoryName] = 'Kategoria'
GO

-- 4. Kasujemy dodany rekord (ewentualnie dodajemy uprawnienia jeśli brakuje uprawnienia do kasowania) przez użytkownika test

DELETE FROM [dbo].[categories]
      WHERE [CategoryName] = 'Inna'
GO


-- 5. Wykonujemy zapytanie zwracające nazwę produktu, jego cenę i nazwę kategorii, do której produkt należy (dla użytkownika test)  

SELECT
    p.[ProductName],
    p.[UnitPrice],
    c.[CategoryName]
FROM [dbo].[products] AS p
INNER JOIN [dbo].[categories] AS c ON p.[CategoryID] = c.[CategoryID]
GO

-- 6. Cofamy uprawnienia INSERT na tabeli Categories dla użytkownika test.
-- Sprawdzić jak działa polecenie SELECT, INSERT, DELETE i UPDATE na tej tabeli.

USE [TEST]
GO
REVOKE INSERT ON [dbo].[categories] TO [test] AS [dbo]
GO

SELECT TOP (1000) [CategoryID]
      ,[CategoryName]
      ,[Description]
      ,[Picture]
  FROM [TEST].[dbo].[categories]
GO

INSERT INTO [dbo].[categories]
           ([CategoryID]
           ,[CategoryName]
           ,[Description]
           ,[Picture])
     VALUES
           (999
           ,'TestBezUprawnien'
           ,'Opis'
           ,NULL)
GO

UPDATE [dbo].[categories]
   SET [Description] = 'Test Update User Test'
 WHERE [CategoryID] = 1
GO

DELETE FROM [dbo].[categories]
      WHERE [CategoryID] = 100
GO


-- 7. Zabraniamy uprawnienia SELECT, UPDATE na tabeli Categories dla użytkownika test.
-- Sprawdzić jak działa polecenie SELECT, INSERT, DELETE i UPDATE na tej tabeli.

USE [TEST]
GO
DENY SELECT ON [dbo].[categories] TO [test] CASCADE
GO
DENY UPDATE ON [dbo].[categories] TO [test] CASCADE
GO


REVERT
GO


-- Systemowe procedury składowane do przeglądania uprawnień
EXEC sp_helpsrvrole
EXEC sp_srvrolepermission securityadmin
EXEC sp_srvrolepermission diskadmin
EXEC sp_srvrolepermission sysadmin

EXEC sp_helprole
EXEC sp_dbfixedrolepermission db_securityadmin 
EXEC sp_dbfixedrolepermission db_datawriter
EXEC sp_dbfixedrolepermission db_datareader

-- Przypisanie uprawnień z opcją WITH GRANT OPTION (admin będzie mógł użytkownikowi bazy danych test przypisać dane uprawnienia) 
GRANT select, insert ON dbo.categories TO admin WITH GRANT OPTION

-- 8. Przypisz użytkownikowi test powyższe uprawnienia jako admin i sprawdź poprawność tych uprawnień (SELECT, INSERT) przez użytkownika test.

USE [TEST]
GO
GRANT INSERT ON [dbo].[categories] TO [admin] WITH GRANT OPTION
GO
GRANT SELECT ON [dbo].[categories] TO [admin] WITH GRANT OPTION
GO

EXECUTE AS LOGIN = 'admin'
GO
GRANT INSERT ON [dbo].[categories] TO [test]
GO
GRANT SELECT ON [dbo].[categories] TO [test]
GO
REVERT
GO

-- Następnie zabieramy prawa przypisane z opcją WITH GRANT OPTION
EXEC sp_helprotect 'dbo.categories', null, null -- można te prawa sprawdzić jako prawa efektywne w SSMS
REVOKE select, INSERT on dbo.categories FROM admin CASCADE

-- 9. Sprawdzamy, czy użytkownik test ma uprawnienia (SELECT, INSERT na tabeli categories) wykonując polecenia SELECT, INSERT, spradzając prawa efektywne w SSMS oraz za pomocą sp_helprotect

USE [TEST]
GO
REVOKE INSERT ON [dbo].[categories] TO [admin] CASCADE
GO
REVOKE SELECT ON [dbo].[categories] TO [admin] CASCADE
GO

-- Sprawdzanie różnych uprawnień procedurą sp_helprotect
EXEC sp_helprotect null, null, null, 's'
EXEC sp_helprotect null, 'admin', null, 'o'
EXEC sp_helprotect null
EXEC sp_helprotect 'CREATE TABLE', [dbo]


-- 10. Dodać odpowiednie uprawnienia użytkownikowi test, 
-- aby mógł dodać klucze PK i FK do tabeli Products i Categories (dodać klucze). 
-- (wykorzystać odpowiednie prawo szczegółowe (np. ALTER) na poziomie tabel bez zapisywania do roli db_owner)
-- Po wykonaniu operacji zabieramy uprawnienia do tworzenia kluczy i zostawiamy tylko do wykonania 
-- zapytania na obu tabelach z wykorzystaniem klauzuli join (zad 5.).

USE [TEST]
GO
GRANT ALTER ON [dbo].[categories] TO [test]
GO
GRANT ALTER ON [dbo].[products] TO [test]
GO

USE [TEST]
GO

ALTER TABLE [dbo].[categories] ADD CONSTRAINT [PK_categories] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

ALTER TABLE [dbo].[products] ADD CONSTRAINT [PK_products] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

ALTER TABLE [dbo].[products]  WITH CHECK ADD  CONSTRAINT [FK_products_categories] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[categories] ([CategoryID])
GO
ALTER TABLE [dbo].[products] CHECK CONSTRAINT [FK_products_categories]
GO

USE [TEST]
GO
REVOKE ALTER ON [dbo].[categories] TO [test]
GO
REVOKE ALTER ON [dbo].[products] TO [test]
GO

REVOKE DENY SELECT ON [dbo].[categories] TO [test]
GO
REVOKE DENY UPDATE ON [dbo].[categories] TO [test]
GO
GRANT SELECT ON [dbo].[categories] TO [test]
GO
GRANT SELECT ON [dbo].[products] TO [test]
GO