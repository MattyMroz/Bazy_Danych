-- Konfiguracja serwera baz danych na poziomie:
--   I. Instancji
--  II. Bazy danych
-- III. Sesji użytkownika
-- Wszystkie ustawienia szukamy w narzędziu SSMS - SQL Server Management Studio
-- Jeśli jest możliwość generujemy kod bezpośrednio z SSMS. 
--------------------------------------------------------------------
-- I. Konfiguracja na poziomie instancji (polecenie sp_configure) --
--------------------------------------------------------------------
sp_configure -- lub przeglądanie opcji za pomocą obiektu sys.configurations 
select
   *
from
   sys.configurations --Aby zobaczyć wszystkie ustawienia to należy włączenia opcję 'show advanced options'
   EXEC sys.sp_configure 'show advanced options',
   1
GO
   RECONFIGURE WITH OVERRIDE
GO
   --01. Sprawdzić możliwość wykonania polecenia xp_cmdshell 
   --włączyć tą opcję i wykonać polecenie:  dir c:\
   EXEC sp_configure 'xp_cmdshell',
   1
GO
   RECONFIGURE
GO
   EXEC xp_cmdshell 'dir c:\'
GO



--02. Ustawienie języka standardowego przy zalogowaniu się do bazy danych 
--za pomocą SSMS dla danej instancji SQL Server|Properties|Advanced (tylko do przećwiczenia)

-- Ustawiamy aktualny język na język Polski. 
-- Przy tworzeniu loginu SQL Server nie podając konkretnego języka ustwiony jest on na dany język 
-- określony jako default
SELECT * FROM sys.syslanguages

EXEC sys.sp_configure ' default language ', ' 14 '   
GO
RECONFIGURE WITH OVERRIDE
GO

--03. Włączenie wyzwalaczy zagnieżdzonych ' nested triggers ' jeden wyzwalacz potrafi wykonać 
   -- instrukcję, która wyzwoli inny wyzwalacz. 
   -- Na poziomie bazy danych mamy opcję Recursive Triggers Enabled, 
   -- która może być włączona lub wyłączona) 
   -- (sprawdzić definiując przykładową strukturę z tabelami i wyzwalaczami dla wszystkich 4 kombinacji i opisać wnioski w punktach)
   -- https://learn.microsoft.com/en-us/sql/relational-databases/triggers/create-nested-triggers?view=sql-server-ver16
EXEC sp_configure ' nested triggers ', 1
GO
RECONFIGURE
GO
ALTER DATABASE Northwind SET RECURSIVE_TRIGGERS ON
GO




--04. Powyższy kod należy zmodyfikować, aby wyzwalacze nie zawierały kursora i składni IF UPDATE.
   -- Ustawiamy nested triggers na ON oraz Recursive Triggers Enabled także na ON. 
   -- Czy trzeba wykorzystać CURSOR, czy można inaczej tą część kodu napisać - napisać bez kursora i sprawdzić popraność działania. 
   -- Czy potrzebna jest instrukcja ' IF
UPDATE
   (mgr) ' czy będzie się działo bez tej instrukcji. 





--05. Ustawienie default connections option (podajemy wartości jako wartości konkretnych bitów)
	--Pamiętajmy iż SSMS wykorzystuje swoje ustawienia dla połaczeń. 
	--Przykładowo chcemy ustawić:
		--implicit transactions (1 bit) 2
		--quoted identifier (8 bit) 256
		--no count (9 bit) 512
EXEC sys.sp_configure ' user options ', ' 770 '
GO
RECONFIGURE WITH OVERRIDE
GO

---------------------------------------------
-- II. Konfiguracja na poziomie bazy danych --
---------------------------------------------
-- Wyświetlanie informacji o ustawieniach bazy danych
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-databases-transact-sql?view=sql-server-ver15
SELECT * FROM sys.databases where name =' Northwind ';

-- Wyświetlanie informacji o ustawieniach bazy danych
-- do wersji SQL Server 2012 wykorzystujemy polecenie sp_dboption
-- https://docs.microsoft.com/en-us/sql/t-sql/functions/databasepropertyex-transact-sql?view=sql-server-ver15
SELECT DATABASEPROPERTYEX(' Northwind ', ' IsAutoShrink ');

--06. Ustawienie konkretnych opcji dla konkretnej bazy danych
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/alter-database-transact-sql?view=sql-server-ver15
ALTER DATABASE Northwind SET AUTO_SHRINK OFF; -- wyłączenie opcji
ALTER DATABASE Northwind SET AUTO_SHRINK ON; -- włączenie opcji
--ustawienie bazy tylko do odczytu (sprawdzamy w SSMS za każdym razem ikonkę przy nazwie danej bazy danych)
ALTER DATABASE [Northwind] SET  READ_ONLY WITH NO_WAIT
--ustawienie bazy do pracy typu RESTRICTED_USER lub SINGLE_USER
ALTER DATABASE [Northwind] SET  RESTRICTED_USER WITH NO_WAIT
ALTER DATABASE [Northwind] SET  SINGLE_USER WITH NO_WAIT
--i przywrócenie do normalnej pracy
ALTER DATABASE [Northwind] SET  READ_WRITE WITH NO_WAIT

------------------------------------------------------------------------------

--------------------------------------------------------------------
-- III. Konfiguracja na poziomie sesji użytkownika (polecenie SET) --
--------------------------------------------------------------------
--07. Poleceniem DBCC USEROPTIONS sprawdzić ustawienia połaczenia. Następnie ustawić poleceniem SET LANGUAGE POLISH język Polski 
   -- i sprawdzić ustawienia jak zmieniły się ustawienia DATEFIRST i DATEFORMAT. 
   -- Zmienić polecenim SET każdy z tych parametrów i napisać zapytanie, które wykorzystuje te ustawienia 
   -- np. SELECT DATEPART(WEEKDAY, ' 10 / 03 / 2024 '), gdzie data jest w formacie miesiąc/dzień/rok.
DBCC USEROPTIONS
SET LANGUAGE POLISH
DBCC USEROPTIONS
SET DATEFIRST 1
SET DATEFORMAT dmy
SELECT DATEPART(WEEKDAY, ' 10 / 03 / 2024 ')



--08. Sprawdzić działanie, każdego z ustawień
SET IMPLICIT_TRANSACTIONS ON | OFF  -- wyłącza transakcje zatwierdzone automatycznie 
SET QUOTED_IDENTIFIER ON | OFF      -- podwójne cudzysłowy
SET NOCOUNT ON | OFF                -- po wykonaniu zapytania nie ma informacji o liczbie zwracanych rekordów
SET IMPLICIT_TRANSACTIONS ON
SELECT @@TRANCOUNT
COMMIT
SET QUOTED_IDENTIFIER ON
SELECT "test" AS TestColumn
SET NOCOUNT ON
SELECT * FROM sys.databases



--09. Sprawdzić ustawienia SET oraz sposobu ich funkcjonowania dla dodatkowych wybranych 9 parametrów
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/set-statements-transact-sql?view=sql-server-ver15

--1----------------------------------------------------------------------------------
SET ANSI_NULLS ON
SELECT * FROM sys.databases WHERE name = NULL

--2----------------------------------------------------------------------------------
SET ANSI_WARNINGS ON
SELECT CAST(' ABC ' AS INT)

--3----------------------------------------------------------------------------------
SET ARITHABORT ON
SELECT 1/0

--4----------------------------------------------------------------------------------
SET CONCAT_NULL_YIELDS_NULL ON
SELECT ' Test ' + NULL

--5----------------------------------------------------------------------------------
SET NUMERIC_ROUNDABORT ON
SELECT CAST(123.456 AS DECIMAL(5,2))

--6----------------------------------------------------------------------------------
SET STATISTICS TIME ON
SELECT * FROM sys.databases
SET STATISTICS TIME OFF

--7----------------------------------------------------------------------------------
SET STATISTICS IO ON
SELECT * FROM sys.databases
SET STATISTICS IO OFF

--8----------------------------------------------------------------------------------
SET SHOWPLAN_TEXT ON
GO
SELECT * FROM sys.databases
GO
SET SHOWPLAN_TEXT OFF
GO

--9----------------------------------------------------------------------------------
SET LOCK_TIMEOUT 5000
SELECT @@LOCK_TIMEOUT





-----------------------------------------------------------------------------------
--10. Sprawdzenie bazy systemowej Model jak działa (działa dla nowo utworznych baz) --
-----------------------------------------------------------------------------------
USE model;
create table model.dbo.x (a1 int,a2 varchar(20));
insert into model.dbo.x values (1,' a1 '),(2,' a2 '),(3,' a3 ');
-- Sprawdzamy w SSMS czy w bazie model jest dana tabela z danymi
select * from model.dbo.x;
-- Tworzymy własną strukturę
create database test;
GO
USE test;
select * from test.dbo.x;
-- Czyścimy bazę Model z tabeli x
drop table model.dbo.x;
-- Kasujemy bazę Test
USE MASTER;
GO
DROP DATABASE Test;
GO

------------------------------------------------------------------------------------------------
-- 11. Jak działają transakcje jawnie rozpoczynane, działające na poleceniach DDL (ciekawostka) ----
-- Przy wycofaniu transakcji wycofujemy także operacje DDL (w innych systeamach jest inaczej) --
------------------------------------------------------------------------------------------------
begin tran
	create table x (a1 int,a2 varchar(20));
	insert into x values (1,' a1 '),(2,' a2 '),(3,' a3 ');
	select * from x;
rollback tran;
--------------------------------------------------------------------------------------