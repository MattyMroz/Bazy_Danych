---------------------------------------------------------------------------------
-- Wszystkie polecenia szukamy w narzędziu SSMS - SQL Server Management Studio --
-- Jeśli jest możliwość generujemy kod bezpośrednio z SSMS. ---------------------
---------------------------------------------------------------------------------

-- Proszę zwrócić uwagę na polecenia, gdzie znajduje się ścieżka dostępu, 
-- każdy może mieć inną i mogą pojawić się błędy w tym miejscu
-- Można ścieżkę sprawdzić poleceniem i wstawić wynik w odpowiednie miejsce
-- lub zdefiniować skrypt, który zrobi to za nas:
SELECT SUBSTRING(filename, 1, CHARINDEX(N'master.mdf', LOWER(filename)) - 1)
FROM master.dbo.sysaltfiles WHERE dbid = 1 AND fileid = 1

---------------------------------------
-- Zarządzanie bazą danych i plikami --
---------------------------------------

-- Tworzymy bazę danych TEST.
-- Definiujemy nową grupę plików dane_hist, w której dołączamy dwa pliki hist01 oraz hist02, 
-- po 100MB każdy z rozrostem bazy danych o 50MB
-- Plik dziennika transakcji ustawiamy na wzrost wartości o 50MB 
-- (baza w trybie Recovery model jako FULL)  

USE master
GO
--if exists (select * from sysdatabases where name='TEST')
--		drop database TEST
--GO
DROP DATABASE IF EXISTS TEST
GO
create database TEST
GO
ALTER DATABASE [test] ADD FILEGROUP [dane_hist]
GO
ALTER DATABASE [test] ADD FILE ( NAME = N'hist01', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\hist01.ndf' , SIZE = 102400KB , FILEGROWTH = 51200KB ) TO FILEGROUP [dane_hist]
GO
ALTER DATABASE [test] ADD FILE ( NAME = N'hist02', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\hist02.ndf' , SIZE = 102400KB , FILEGROWTH = 51200KB ) TO FILEGROUP [dane_hist]
GO
ALTER DATABASE [test] MODIFY FILE ( NAME = N'test_log', MAXSIZE = UNLIMITED, FILEGROWTH = 51200KB )
GO

-- wypełniamy tabelę przykładowymi danymi (nie jest to generator) 
-- Może to potrwać kilka minut 
-- (baza orientacyjnie będzie miała 716 MB z czego 358 MB dane i 358 MB dziennik transakcji)
-- Po zakończeniu transakcji w SSMS stajemy na bazie TEST i pod prawym przycikiem myszy wybieramy
-- Reports | Standard Reports | Disk Usage w celu graficznej reprezentacji wykorzystania dysku

USE TEST
GO
--if exists (select * from sysobjects where id = object_id('dbo.x') and sysstat & 0xf = 3)
--	drop table x
--GO
DROP TABLE IF EXISTS dbo.x
GO
create table x (a1 char(100),a2 char(100), a3 char(100))
on dane_hist;
insert into x values ('dowolne dane','dowolne dane','dowolne dane');
GO
declare @a int = 0
begin
	while @a<20 --można zwiększyć do 23 ale będzie to trwało zdecydowanie dłużej
	begin
		set @a=@a+1
		print @a
		insert into x select * from x;
	end;
end;
GO

-- ostatnie polecenie można zapisać krócej (dwie linijki uruchamiamy na raz)
	--insert into x select * from x;
	--GO 19

-- Sprawdzenie liczby wstawionych rekordów
SELECT count(*) FROM dbo.x;   
GO
-- sprawdzamy zawartość plików
USE TEST
GO
SELECT name, size/128.0 FileSizeInMB, size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 AS EmptySpaceInMB
FROM sys.database_files;
-- pojawia się liczba 128 jako 1024kB/8kB - jako liczba bloków 8kB na 1 Mbajt danych

--aktualne grupy plików
select * from sys.data_spaces
--or
select * from sys.filegroups
GO
--https://msdn.microsoft.com/en-us/library/ms187997.aspx  --Mapping System Tables to System Views (Transact-SQL)

-------------------------------------
-- 1. Opróżnić hist02 i przenieść dane do hist01 w ramach tej samej grupy plików



-- 2. Wyeksportować całą bazę danych do pliku w celu późniejszego uruchomienia tak jak Nortwhind



-- 3. Jak zrobić attach i detach bazy danych.



-- 4. Ustawić bazę w trybie OFFline a następnie przywrócić do normalnej pracy


-- 5. Przeanalizować bazy AdventureWorks i  AdvantureWorksLT (AdventureWorksDW to hurtownia bazy danych)  
-- Należy pamiętać aby ustawić użytkownika sa jako właściciela całej bazy danych (nie musi to być ustawione)


---------------
-- Callation --
---------------
-- Sprawdzić czy widać znaki polskie i kiedy?
CREATE DATABASE TEST1 COLLATE ARABIC_CI_AS;	
GO
USE TEST1;
GO
CREATE TABLE table1(
	a1 nchar(10) NULL,
	a2 char(10) NULL);
insert into table1 values ('ą','ą');
insert into table1 values (N'ą',N'ą');
	--litera N przed tekstem mówi nam, że jest to element w systemie Unicode
	--i jeśli kolumna ma typ z literką n (np. nchar) to przechowywane dane mogą być w dowolnym języku.
	--W innym przypadku mamy słownik i znaki w tym przypadku języka arabskiego.

GO
--Przykłady do wykonania różnego COLLATION
USE TEST1;
GO
DROP TABLE IF EXISTS TestCharacter;
GO
CREATE TABLE dbo.TestCharacter
(
  id int NOT NULL IDENTITY(1,1),
  Data varchar(10) COLLATE Polish_CI_AS,
  DataPL nvarchar(10) COLLATE Polish_CI_AS,
  CIData varchar(10) COLLATE CYRILLIC_GENERAL_CI_AS,	-- case insensitive
  CSData varchar(10) COLLATE French_CS_AS	-- case sensitive
);
GO
INSERT INTO TestCharacter (Data,DataPL,CIData,CSData) 
	VALUES (N'Łódź',N'ŁÓDŹ',N'русский',N'passé');
INSERT INTO TestCharacter (Data,DataPL,CIData,CSData) 
	VALUES (N'русский',N'русский',N'русский',N'русский');
	--Mimo ustawienia dla bazy danych i dla konkretnych kolumn możemy 
	--w zapytaniu odnieść się do odpowiedniego sposobu porównywania i sortowania danych.
select * from TestCharacter order by CSData collate Polish_CS_AS;
	--Poleceniami poniżej można skopiować inne znaki jak polskie
	SET LANGUAGE RUSSIAN
	SET LANGUAGE French
	SET LANGUAGE POLISH 

--Przykłady do wykonania różnego COLLATION z rozróżnieniem małych i dużych znaków
GO
DROP TABLE IF EXISTS dbo.TestCharacter1;
GO
CREATE TABLE dbo.TestCharacter1
( id int NOT NULL IDENTITY(1,1),
  CIData varchar(10) COLLATE POLISH_CI_AS,	-- case insensitive
  CSData varchar(10) COLLATE POLISH_CS_AS	-- case sensitive
);
GO
INSERT INTO dbo.TestCharacter1 (CIData,CSData) VALUES ('Test Data','Test Data');			
INSERT INTO dbo.TestCharacter1 (CIData,CSData) VALUES (N'Łódź',N'Łódź');	
GO
SELECT * FROM TestCharacter1

-- Zapytanie do kolumny Case InSensitive
SELECT * FROM dbo.TestCharacter1 
	WHERE CIData = 'test data'; -- wszystkie małe litery w klauzuli WHERE

-- Zapytanie do kolumny Case Sensitive
SELECT * FROM dbo.TestCharacter1 
	WHERE CSData = 'test data'; -- brak zwracanych rekordów!

-- Zapytania z rozróżnianiem wielkości liter
SELECT * FROM dbo.TestCharacter1
	WHERE CSData = 'test data' COLLATE Polish_CI_AS;	

-- Wymuszenie porównywania bez względu na wielkość liter mimo porównywania kolumny z ustawieniem CS
-- Wykonać zapytanie, które porównuje dwie kolumny, które mają różne ustawienia COLLATE. 
-- Nie powiedzie się to, ponieważ konfliktu collation nie można rozwiązać.

SELECT * FROM dbo.TestCharacter1	
	WHERE CIData = CSData;
-- Msg 468, Level 16, State 9, Line 170
-- Cannot resolve the collation conflict between "Polish_CS_AS" and "Polish_CI_AS" in the equal to operation.

-- Można tego uniknąć wybierając konkretny sposób callation

SELECT * FROM dbo.TestCharacter1
WHERE CIData = CSData COLLATE Latin1_General_CI_AS;
	-- lub
SELECT * FROM dbo.TestCharacter1
WHERE CIData = CSData COLLATE Polish_CI_AS;

-- Dodajemy sortowanie w danym języku
SELECT * FROM dbo.TestCharacter1 
	where CSData = 'test Data' COLLATE Polish_CS_AS
	order by CIData collate Polish_CI_AS;

-- Sprawdzamy CS i CI - czy wielkość znaków ma znaczenie przy sortowaniu
INSERT INTO dbo.TestCharacter1 (CIData,CSData) VALUES ('test Data','test Data');
INSERT INTO dbo.TestCharacter1 (CIData,CSData) VALUES ('Test Data','Test Data');
INSERT INTO dbo.TestCharacter1 (CIData,CSData) VALUES ('test Data','test Data');
INSERT INTO dbo.TestCharacter1 (CIData,CSData) VALUES ('test Data','test Data');

SELECT * FROM dbo.TestCharacter1 order by CIData collate Polish_CI_AS;
SELECT * FROM dbo.TestCharacter1 order by CIData collate Polish_CS_AS;

-- 6. sprawdzamy akcent na literką é - N'passé' AS i AI

USE TEST1;
GO

DROP TABLE IF EXISTS dbo.TestAccent;
GO

CREATE TABLE dbo.TestAccent (
    id INT IDENTITY(1,1),
    Data NVARCHAR(10)
);
GO

INSERT INTO dbo.TestAccent (Data) VALUES (N'passé');
INSERT INTO dbo.TestAccent (Data) VALUES (N'passe');
GO

SELECT * FROM dbo.TestAccent;
GO

SELECT 'Accent Insensitive (AI)' AS TestType, *
FROM dbo.TestAccent
WHERE Data = N'passe' COLLATE Latin1_General_CI_AI;
GO

SELECT 'Accent Sensitive (AS)' AS TestType, *
FROM dbo.TestAccent
WHERE Data = N'passe' COLLATE Latin1_General_CI_AS;
GO

----------------------------------
-- Partycjonowanie i FileStream --
----------------------------------
-- 7. Włączyć FILESTREAM na serwerze i w danej bazie danych na poziomie dostepu z wykorzystaniem języka T-SQL
EXEC sys.sp_configure N'filestream access level', N'1'
GO
RECONFIGURE WITH OVERRIDE
GO

-----------------------------------
GO
--Zdefiniować funkcję partycji o 4 przedziałach
CREATE PARTITION FUNCTION myRangePF1 (int)
AS RANGE LEFT FOR VALUES (10, 100, 1000);
GO

--Zdefiniować schemat partycji na podstawie funkcji partycji
--Uwaga musimy najpierw zdefiniować 4 grupy plików i przynajmniej po jednym pliku w danej grupie

--8. Definicja 4 grup plików (test1fg, test2fg, test3fg, test4fg)

USE master
GO

ALTER DATABASE TEST ADD FILEGROUP test1fg;
GO
ALTER DATABASE TEST ADD FILEGROUP test2fg;
GO
ALTER DATABASE TEST ADD FILEGROUP test3fg;
GO
ALTER DATABASE TEST ADD FILEGROUP test4fg;
GO

USE TEST
GO
SELECT name, is_default, is_read_only FROM sys.filegroups;
GO

-- Następnie definiujemy schemat partycji dla istniejących grup plików
CREATE PARTITION SCHEME myRangePS1
AS PARTITION myRangePF1
TO (test1fg, test2fg, test3fg, test4fg);
GO

--Zdefiniować tabelę na podstawie schematu partycji
CREATE TABLE PartitionTable (col1 int identity(1,1), col2 int)
ON myRangePS1 (col2) ;
GO


-- Dodanie pliku do test1fg
ALTER DATABASE [TEST] 
ADD FILE ( 
    NAME = N'test1_data', 
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\test1_data.ndf' , 
    SIZE = 102400KB , 
    FILEGROWTH = 51200KB 
) TO FILEGROUP [test1fg]
GO

-- Dodanie pliku do test2fg
ALTER DATABASE [TEST] 
ADD FILE ( 
    NAME = N'test2_data', 
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\test2_data.ndf' , 
    SIZE = 102400KB , 
    FILEGROWTH = 51200KB 
) TO FILEGROUP [test2fg]
GO

-- Dodanie pliku do test3fg
ALTER DATABASE [TEST] 
ADD FILE ( 
    NAME = N'test3_data', 
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\test3_data.ndf' , 
    SIZE = 102400KB , 
    FILEGROWTH = 51200KB 
) TO FILEGROUP [test3fg]
GO

-- Dodanie pliku do test4fg
ALTER DATABASE [TEST] 
ADD FILE ( 
    NAME = N'test4_data', 
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\test4_data.ndf' , 
    SIZE = 102400KB , 
    FILEGROWTH = 51200KB 
) TO FILEGROUP [test4fg]
GO

-- Weryfikacja, czy pliki zostały dodane
USE TEST
GO
SELECT 
    name, 
    type_desc, 
    file_group_name = (SELECT name FROM sys.filegroups WHERE data_space_id = f.data_space_id)
FROM sys.database_files f
WHERE f.data_space_id IN (SELECT data_space_id FROM sys.filegroups WHERE name IN ('test1fg', 'test2fg', 'test3fg', 'test4fg'));
GO


--Wypełnić przykładowymi danymi
-- Poprawiona składnia do powtórzenia wstawiania 1000 razy
INSERT INTO PartitionTable(col2) values (0),(50),(150),(2000),(750);
GO 1000

-- 9. Zdefiniować jeszcze jedną grupę plików test5fg (łącznie z plikiem)
-- Ustawienie aktualnej partycji wykorzystanej przy rozdzieleniu funkcji partycji SPLIT
-- wprowadzając wartość 500

ALTER DATABASE TEST ADD FILEGROUP test5fg;
GO

ALTER DATABASE [TEST] 
ADD FILE ( 
    NAME = N'test5_data', 
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\test5_data.ndf' , 
    SIZE = 102400KB , 
    FILEGROWTH = 51200KB 
) TO FILEGROUP [test5fg]
GO

ALTER PARTITION SCHEME MyRangePS1
NEXT USED test5fg;

/* składnia polecenia funkcji partycjonującej
ALTER PARTITION FUNCTION partition_function_name()
{ 
    SPLIT RANGE ( boundary_value )
  | MERGE RANGE ( boundary_value ) 
} [ ; ]
*/

ALTER PARTITION FUNCTION myRangePF1()
SPLIT RANGE (500);
GO

-- 10.Połącz grupy partycji MERGE wyrzucając wartość 1 
ALTER PARTITION FUNCTION myRangePF1()
MERGE RANGE (1);


-- 11.Zdefiniowac tabelę z typem binarnym FILESTRAM i wstawić tam kilka plików ze zdjęciami
-- można wykorzystać przykłady z wykładu 
-- open row set

USE TEST
GO
DROP TABLE IF EXISTS dbo.FilestreamTable;
GO

-- Tworzenie tabeli z kolumną FILESTREAM
CREATE TABLE dbo.FilestreamTable (
    FileId UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL UNIQUE DEFAULT NEWSEQUENTIALID(),
    FileName NVARCHAR(255) NOT NULL,
    FileData VARBINARY(MAX) FILESTREAM NULL,
    DateAdded DATETIME DEFAULT GETDATE()
)

ON [PRIMARY] FILESTREAM_ON test1fg; -- Zmień [FS_Grupa] na nazwę Twojej grupy plików FILESTREAM
GO




INSERT INTO dbo.FilestreamTable (FileName, FileData)
SELECT 
    'zdjecie1.jpg',
FROM OPENROWSET(BULK N'C:\Temp\FilestreamTest\zdjecie1.jpg', SINGLE_BLOB) AS FileData;
GO




-- 12.Zdefiniować tabelę z polem z typem date lub datetime, gdzie funkcja partycjonująca będzie związana z pełnymi latami od początku stycznia do końca grudnia 
-- (granice w funkcji partycji to lata 2022,2023,2024)
-- Wstawić przykładowe dane i sprawdzić dla danej bazy wykorzystanie dysku przez partycje - Raports | Standard Reports | Disk Usage by Partition


