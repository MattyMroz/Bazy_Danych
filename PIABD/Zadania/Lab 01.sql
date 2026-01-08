-- Konfiguracja serwera baz danych na poziomie:
--   I. Instancji
--  II. Bazy danych
-- III. Sesji u¿ytkownika


-- Wszystkie ustawienia szukamy w narzêdziu SSMS - SQL Server Management Studio
-- Jeœli jest mo¿liwoœæ generujemy kod bezpoœrednio z SSMS. 



--------------------------------------------------------------------
-- I. Konfiguracja na poziomie instancji (polecenie sp_configure) --
--------------------------------------------------------------------
sp_configure   
-- lub przegl¹danie opcji za pomoc¹ obiektu sys.configurations 
select * from sys.configurations

--Aby zobaczyæ wszystkie ustawienia to nale¿y w³¹czenia opcjê 'show advanced options'
EXEC sys.sp_configure 'show advanced options', 1  
GO
RECONFIGURE WITH OVERRIDE
GO

--01. Sprawdziæ mo¿liwoœæ wykonania polecenia xp_cmdshell 
--w³¹czyæ t¹ opcjê i wykonaæ polecenie:  dir c:\



--02. Ustawienie jêzyka standardowego przy zalogowaniu siê do bazy danych 
--za pomoc¹ SSMS dla danej instancji SQL Server|Properties|Advanced (tylko do przeæwiczenia)

-- Ustawiamy aktualny jêzyk na jêzyk Polski. 
-- Przy tworzeniu loginu SQL Server nie podaj¹c konkretnego jêzyka ustwiony jest on na dany jêzyk 
-- okreœlony jako default

EXEC sys.sp_configure 'default language', '14'   
GO
RECONFIGURE WITH OVERRIDE
GO

--03. W³¹czenie wyzwalaczy zagnie¿dzonych 'nested triggers' jeden wyzwalacz potrafi wykonaæ 
   -- instrukcjê, która wyzwoli inny wyzwalacz. 
   -- Na poziomie bazy danych mamy opcjê Recursive Triggers Enabled, 
   -- która mo¿e byæ w³¹czona lub wy³¹czona) 
   -- (sprawdziæ definiuj¹c przyk³adow¹ strukturê z tabelami i wyzwalaczami dla wszystkich 4 kombinacji i opisaæ wnioski w punktach)
   -- https://learn.microsoft.com/en-us/sql/relational-databases/triggers/create-nested-triggers?view=sql-server-ver16





--04. Powy¿szy kod nale¿y zmodyfikowaæ, aby wyzwalacze nie zawiera³y kursora i sk³adni IF UPDATE.
   -- Ustawiamy nested triggers na ON oraz Recursive Triggers Enabled tak¿e na ON. 
   -- Czy trzeba wykorzystaæ CURSOR, czy mo¿na inaczej t¹ czêœæ kodu napisaæ - napisaæ bez kursora i sprawdziæ popranoœæ dzia³ania. 
   -- Czy potrzebna jest instrukcja 'IF UPDATE (mgr)' czy bêdzie siê dzia³o bez tej instrukcji. 





--05. Ustawienie default connections option (podajemy wartoœci jako wartoœci konkretnych bitów)
	--Pamiêtajmy i¿ SSMS wykorzystuje swoje ustawienia dla po³aczeñ. 
	--Przyk³adowo chcemy ustawiæ:
		--implicit transactions (1 bit) 2
		--quoted identifier (8 bit) 256
		--no count (9 bit) 512
EXEC sys.sp_configure 'user options', '770'
GO
RECONFIGURE WITH OVERRIDE
GO

---------------------------------------------
-- II. Konfiguracja na poziomie bazy danych --
---------------------------------------------
-- Wyœwietlanie informacji o ustawieniach bazy danych
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-databases-transact-sql?view=sql-server-ver15
SELECT * FROM sys.databases where name ='Northwind';

-- Wyœwietlanie informacji o ustawieniach bazy danych
-- do wersji SQL Server 2012 wykorzystujemy polecenie sp_dboption
-- https://docs.microsoft.com/en-us/sql/t-sql/functions/databasepropertyex-transact-sql?view=sql-server-ver15
SELECT DATABASEPROPERTYEX('Northwind', 'IsAutoShrink');

--06. Ustawienie konkretnych opcji dla konkretnej bazy danych
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/alter-database-transact-sql?view=sql-server-ver15
ALTER DATABASE Northwind SET AUTO_SHRINK OFF; -- wy³¹czenie opcji
ALTER DATABASE Northwind SET AUTO_SHRINK ON; -- w³¹czenie opcji
--ustawienie bazy tylko do odczytu (sprawdzamy w SSMS za ka¿dym razem ikonkê przy nazwie danej bazy danych)
ALTER DATABASE [Northwind] SET  READ_ONLY WITH NO_WAIT
--ustawienie bazy do pracy typu RESTRICTED_USER lub SINGLE_USER
ALTER DATABASE [Northwind] SET  RESTRICTED_USER WITH NO_WAIT
ALTER DATABASE [Northwind] SET  SINGLE_USER WITH NO_WAIT
--i przywrócenie do normalnej pracy
ALTER DATABASE [Northwind] SET  READ_WRITE WITH NO_WAIT

------------------------------------------------------------------------------

--------------------------------------------------------------------
-- III. Konfiguracja na poziomie sesji u¿ytkownika (polecenie SET) --
--------------------------------------------------------------------
--07. Poleceniem DBCC USEROPTIONS sprawdziæ ustawienia po³aczenia. Nastêpnie ustawiæ poleceniem SET LANGUAGE POLISH jêzyk Polski 
   -- i sprawdziæ ustawienia jak zmieni³y siê ustawienia DATEFIRST i DATEFORMAT. 
   -- Zmieniæ polecenim SET ka¿dy z tych parametrów i napisaæ zapytanie, które wykorzystuje te ustawienia 
   -- np. SELECT DATEPART(WEEKDAY, '10/03/2024'), gdzie data jest w formacie miesi¹c/dzieñ/rok.



--08. Sprawdziæ dzia³anie, ka¿dego z ustawieñ
SET IMPLICIT_TRANSACTIONS ON | OFF  -- wy³¹cza transakcje zatwierdzone automatycznie 
SET QUOTED_IDENTIFIER ON | OFF      -- podwójne cudzys³owy
SET NOCOUNT ON | OFF                -- po wykonaniu zapytania nie ma informacji o liczbie zwracanych rekordów



--09. Sprawdziæ ustawienia SET oraz sposobu ich funkcjonowania dla dodatkowych wybranych 9 parametrów
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/set-statements-transact-sql?view=sql-server-ver15

--1----------------------------------------------------------------------------------

--2----------------------------------------------------------------------------------

--3----------------------------------------------------------------------------------

--4----------------------------------------------------------------------------------

--5----------------------------------------------------------------------------------

--6----------------------------------------------------------------------------------

--7----------------------------------------------------------------------------------

--8----------------------------------------------------------------------------------

--9----------------------------------------------------------------------------------





-----------------------------------------------------------------------------------
--10. Sprawdzenie bazy systemowej Model jak dzia³a (dzia³a dla nowo utworznych baz) --
-----------------------------------------------------------------------------------
USE model;
create table model.dbo.x (a1 int,a2 varchar(20));
insert into model.dbo.x values (1,'a1'),(2,'a2'),(3,'a3');
-- Sprawdzamy w SSMS czy w bazie model jest dana tabela z danymi
select * from model.dbo.x;
-- Tworzymy w³asn¹ strukturê
create database test;
GO
USE test;
select * from test.dbo.x;
-- Czyœcimy bazê Model z tabeli x
drop table model.dbo.x;
-- Kasujemy bazê Test
USE MASTER;
GO
DROP DATABASE Test;
GO

------------------------------------------------------------------------------------------------
-- 11. Jak dzia³aj¹ transakcje jawnie rozpoczynane, dzia³aj¹ce na poleceniach DDL (ciekawostka) ----
-- Przy wycofaniu transakcji wycofujemy tak¿e operacje DDL (w innych systeamach jest inaczej) --
------------------------------------------------------------------------------------------------
begin tran
	create table x (a1 int,a2 varchar(20));
	insert into x values (1,'a1'),(2,'a2'),(3,'a3');
	select * from x;
rollback tran;
--------------------------------------------------------------------------------------


