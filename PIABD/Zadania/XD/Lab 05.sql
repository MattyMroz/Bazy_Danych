----------------------------------------------------
-- Kopie bezpieczeństwa i przywracanie baz danych --
----------------------------------------------------
use master
GO
-- Utworzenie nowej bazy test3 z jednym obiektem wypełnionym danymi
drop database if exists test3
GO
create database test3 -- baza ma zdefiniowany Recovery model - jako Full lub Bulk-logged
USE [master]
ALTER DATABASE [test3] SET RECOVERY FULL WITH NO_WAIT
GO
use test3
drop table if exists cat
select * into cat from north.dbo.categories
select * from cat
GO
USE MASTER
GO

-- Przygotowanie urządzenia do backupu o nazwie b3, b3_log i b3_log1 (nie musimy tworzyć osobnych plików, 
-- ale łatwiej będzie pokazać sposoby backupu i przywracania)
-- (uwaga na ścieżki podane w skrypcie bo mogą nie odpowiadać ścieżką w instalacji lokalnej)
USE [master]
EXEC master.dbo.sp_addumpdevice  @devtype = N'disk', @logicalname = N'b3', @physicalname = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\b3.bak'
EXEC master.dbo.sp_addumpdevice  @devtype = N'disk', @logicalname = N'b3_log', @physicalname = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\b3_log.bak'
EXEC master.dbo.sp_addumpdevice  @devtype = N'disk', @logicalname = N'b3_log1', @physicalname = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\b3_log1.bak'
GO

-- Operacje backupu i operacji pomiędzy nimi
-- Pełny backup baz danych - 1
BACKUP DATABASE [test3] TO  [b3] WITH NOFORMAT, INIT,  NAME = N'Full', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
INSERT INTO test3.dbo.cat (categoryname) values ('A1');
GO
-- Różnicowy backup baz danych - 2
BACKUP DATABASE [test3] TO  [b3] WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  NAME = N'DIFF1', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
INSERT INTO test3.dbo.cat (categoryname) values ('A2');
GO
-- Backup baz danych z opcją COPY_ONLY - 3
BACKUP DATABASE [test3] TO  [b3] WITH  COPY_ONLY, NOFORMAT, NOINIT,  NAME = N'Kopia', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
INSERT INTO test3.dbo.cat (categoryname) values ('A3');
GO
-- Różnicowy backup baz danych - 4
BACKUP DATABASE [test3] TO  [b3] WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  NAME = N'DIF2', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
-- ten element zostaje w dzienniku transakcji aktywnym
INSERT INTO test3.dbo.cat (categoryname) values ('A4');
go
select * from test3.dbo.cat

-----------------------------
-- Przywracanie baz danych --
-----------------------------
-- Scenariusz 1 -------------
-----------------------------
-- do urządzenia b3_log dokładamy kolejne wersje backup log i czyścimy dziennik bazy (bez opcji NO_TRUNCATE) 
-- dokładamy zamiast do b3 do nowego urządzenia b3_log (pierwsze polecenie Backup Log jest z opcją INIT aby wyczyścić poprzednią zawartość pliku bak jeśli istniał)
INSERT INTO test3.dbo.cat (categoryname) values ('Tran 1');
BACKUP LOG [test3] TO [b3_log] WITH NOFORMAT, INIT,  NAME = N'Tran 1', SKIP, NOREWIND, NOUNLOAD,   STATS = 5
--
INSERT INTO test3.dbo.cat (categoryname) values ('Tran 2');
BACKUP LOG [test3] TO [b3_log] WITH NOFORMAT, NOINIT,  NAME = N'Tran 2', SKIP, NOREWIND, NOUNLOAD,   STATS = 5
--
INSERT INTO test3.dbo.cat (categoryname) values ('Tran 3');
BACKUP LOG [test3] TO [b3_log] WITH NOFORMAT, NOINIT,  NAME = N'Tran 3', SKIP, NOREWIND, NOUNLOAD,  STATS = 5
	
-- Przywracamy całość (nikt nie może pracować na danej bazie lub przechodzimy z tryb pracy SINGLE_USER lub RESTRICTED_USER)
-- ALTER DATABASE [test3] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
-- ALTER DATABASE [test3] SET MULTI_USER

USE MASTER
ALTER DATABASE [test3] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE [test3] FROM [b3] WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,   REPLACE,  STATS = 5
RESTORE DATABASE [test3] FROM  [b3] WITH  FILE = 4,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [test3] FROM  [b3_log] WITH  FILE = 1,  NOUNLOAD, NORECOVERY, STATS = 5
RESTORE LOG [test3] FROM  [b3_log] WITH  FILE = 2,  NOUNLOAD, NORECOVERY, STATS = 5
RESTORE LOG [test3] FROM  [b3_log] WITH  FILE = 3,  NOUNLOAD, NORECOVERY, STATS = 5
RESTORE DATABASE [test3] with RECOVERY
ALTER DATABASE [test3] SET MULTI_USER
--
select * from test3.dbo.cat --sprawdzamy co odzyskaliśmy

-----------------------------
-- Scenariusz 2 -------------
-----------------------------
-- do urządzenia b3_log1 dokładamy kolejne wersje backup log i nie czyścimy dziennika (opcja NO_TRUNCATE)
-- (pierwsze polecenie Backup Log jest z opcją INIT aby wyczyścić poprzednią zawartość pliku bak jeśli istniał)
INSERT INTO test3.dbo.cat (categoryname) values ('Tran 4');
BACKUP LOG [test3] TO [b3_log1] WITH NOFORMAT, INIT,  NAME = N'Tran 4', SKIP, NOREWIND, NOUNLOAD, NO_TRUNCATE,  STATS = 5
--
INSERT INTO test3.dbo.cat (categoryname) values ('Tran 5');
BACKUP LOG [test3] TO  [b3_log1] WITH NOFORMAT, NOINIT,  NAME = N'Tran 5', NOSKIP, NOREWIND, NOUNLOAD, NO_TRUNCATE,  STATS = 5
--
INSERT INTO test3.dbo.cat (categoryname) values ('Tran 6');
BACKUP LOG [test3] TO  [b3_log1] WITH NOFORMAT, NOINIT,  NAME = N'Tran 6', NOSKIP, NOREWIND, NOUNLOAD, NO_TRUNCATE, STATS = 5

-- Przywracamy całość
RESTORE DATABASE [test3] FROM  [b3] WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,   REPLACE,  STATS = 5;
RESTORE DATABASE [test3] FROM  [b3] WITH  FILE = 4,  NORECOVERY,  NOUNLOAD,  STATS = 5;
-- Dzienniki transakcji z b3_log są potrzebne wszytskie w odpowiedniej kolejności
RESTORE LOG [test3] FROM  [b3_log] WITH  FILE = 1,  NOUNLOAD, NORECOVERY, STATS = 5;
RESTORE LOG [test3] FROM  [b3_log] WITH  FILE = 2,  NOUNLOAD, NORECOVERY, STATS = 5;
RESTORE LOG [test3] FROM  [b3_log] WITH  FILE = 3,  NOUNLOAD, NORECOVERY, STATS = 5;
-- Dzienniki transakcji z b3_log1 (wystarczy tylko ostatni - opcja NO_TRUNCATE nie kasowała poprzednich transakcji przy backupie)
RESTORE LOG [test3] FROM  [b3_log1] WITH  FILE = 3,  NOUNLOAD, NORECOVERY, STATS = 5;
RESTORE DATABASE [test3] with RECOVERY
--
select * from test3.dbo.cat --sprawdzamy co odzyskaliśmy

-----------------------------
-- Scenariusz 3 -------------
-----------------------------
-- Scenariusz (naturalny) - Przywracamy całość aby nie stracić żadnej z zatwierdzonych transakcji
-- Tworzymy w danej chwili backup dziennika (tails) z opcją NORECOVERY i odtwarzamy dany strukturę i tail (tylko jeden)
INSERT INTO test3.dbo.cat (categoryname) values ('Tail log');
-- tail log - przy tworzeniu tego backupu od razu przechodzimy do tryby Recovery --
BACKUP LOG [test3] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\test3_Log_tail.bak' WITH NOFORMAT, INIT,  NAME = N'test3_Log_tail', NOSKIP, NOREWIND, NOUNLOAD,  NORECOVERY,  STATS = 5
	-- tak jak poprzednio
	RESTORE DATABASE [test3] FROM  [b3] WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,   REPLACE,  STATS = 5;
	RESTORE DATABASE [test3] FROM  [b3] WITH  FILE = 4,  NORECOVERY,  NOUNLOAD,  STATS = 5;
	-- Dzienniki transakcji z b3_log są potrzebne wszytskie w odpowiedniej kolejności
	RESTORE LOG [test3] FROM  [b3_log] WITH  FILE = 1,  NOUNLOAD, NORECOVERY, STATS = 5;
	RESTORE LOG [test3] FROM  [b3_log] WITH  FILE = 2,  NOUNLOAD, NORECOVERY, STATS = 5;
	RESTORE LOG [test3] FROM  [b3_log] WITH  FILE = 3,  NOUNLOAD, NORECOVERY, STATS = 5;
	-- Dzienniki transakcji z b3_log1 (wystarczy tylko ostatni - opcja NO_TRUNCATE nie kasowała poprzednich transakcji przy backupie)
	RESTORE LOG [test3] FROM  [b3_log1] WITH  FILE = 3,  NOUNLOAD, NORECOVERY, STATS = 5;
-- Przywracanie tail log (aby nie stracić żadnej transakcji - od razu jest opcja RECOVERY aby nie wykonywać polecenia RESTORE DATABASE [test3] with RECOVERY)
RESTORE LOG [test3] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\test3_Log_tail.bak' WITH  FILE = 1,  NOUNLOAD,  STATS = 5
--
select * from test3.dbo.cat --sprawdzamy co odzyskaliśmy

------------------------------------------------------------------------------------------------------------------------------
/* 
 Opis opcji:
 opcja NORECOVERY - baza w tym stanie po tym backupie przechodzi w stan Restoring (dodałem nadpisywanie pliku backupu - INIT,SKIP) - można świadomie przywrócić poleceniem --RESTORE DATABASE [test3] with RECOVERY
 opcja NO_TRUNCUTE powoduje nie wycięcie dziennika transakcji (możemy robić kilka kopii i będą one poprawne i z aktualnymi danymi) - bez tej opcji dziennik jest wycinany i ponowne BACKUP LOG i przywracanie z wykorzystaniem tego pliku jest w innym miejscu niż cały backup 
 BACKUP LOG [test3] TO  [b3_log] WITH NOFORMAT, INIT,  NAME = N'test3_Log_tail', NOSKIP, NOREWIND, NOUNLOAD,  NORECOVERY,  STATS = 5
 bez opcji NORECOVERY - baza w tym stanie po tym backupie może być normalnie używana (i może zmienić się stan bazy (chyba że damy opcję SINGLE_USER i sami nic nie zmienimy
 BACKUP LOG [test3] TO  [b3_log] WITH NOFORMAT, INIT,  NAME = N'test3_Log_tail', SKIP, NOREWIND, NOUNLOAD, STATS = 5

 NORECOVERY
 Tworzy kopię zapasową końca dziennika i pozostawia bazę danych w stanie PRZYWRACANIA. 
 NORECOVERY przydaje się w przypadku przełączania awaryjnego do dodatkowej bazy danych lub podczas zapisywania końca dziennika przed operacją PRZYWRACANIA.
 Aby wykonać najlepszą kopię zapasową dziennika, która pomija obcinanie dziennika, a następnie atomowo wprowadza bazę danych do stanu PRZYWRACANIE, użyj razem opcji NO_TRUNCATE i NORECOVERY.

 NO_TRUNCATE
 Określa, że ​​dziennik nie jest obcinany i powoduje, że aparat bazy danych spróbuje wykonać kopię zapasową bez względu na stan bazy danych. W związku z tym kopia zapasowa wykonana przy użyciu NO_TRUNCATE może mieć niepełne metadane. Ta opcja umożliwia tworzenie kopii zapasowej dziennika w sytuacjach, w których baza danych jest uszkodzona.
 Opcja NO_TRUNCATE w BACKUP LOG jest równoważna określeniu zarówno COPY_ONLY, jak i CONTINUE_AFTER_ERROR.
 Bez opcji NO_TRUNCATE baza danych musi znajdować się w trybie ONLINE. Jeśli baza danych jest w stanie SUSPENDED, możesz utworzyć kopię zapasową, określając NO_TRUNCATE. Ale jeśli baza danych znajduje się w trybie OFFLINE lub AWARYJNYM, BACKUP nie jest dozwolony nawet przy NO_TRUNCATE. Aby uzyskać informacje o stanach bazy danych, zobacz Stany baz danych.
 https://learn.microsoft.com/en-us/sql/t-sql/statements/backup-transact-sql?view=sql-server-ver16&redirectedfrom=MSDN
*/
------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------
-- Przywracanie bazy z ostatniej COPY_ONLY --
---------------------------------------------
RESTORE DATABASE [test3] FROM  [b3] WITH  FILE = 3,  NORECOVERY,  NOUNLOAD,   REPLACE,  STATS = 5
-- Uwaga
-- RESTORE DATABASE [test3] FROM  [b3] WITH  FILE = 4,  RECOVERY,  NOUNLOAD,   REPLACE,  STATS = 5 
-- tutaj kopia różnicowa do tego backupu nie może być wykorzystana
RESTORE DATABASE [test3] WITH RECOVERY

-- Zadania do wykonania

-- I. Tworzymy dla bazy danych TEST4 następujące typy kopie bezpieczeństwa w kolejności na urządzeniu o nazwie b4 
-- W kolejnosci wykonujemy backup typu: 
-- backup pełny o nazwie w opisie FULL (przy tym backupie ustawiamy opcję INIT aby skasować wszystko co było wcześniej w danym urządzeniu)
-- backup różnicowy o nazwie w opisie DIF1 
-- backup różnicowy o nazwie w opisie DIF2 
-- backup dziennika transakcji o nazwie w opisie LOG1 
-- backup dziennika transakcji o nazwie w opisie LOG2 
-- backup różnicowy o nazwie w opisie DIF3 
-- backup dziennika transakcji o nazwie w opisie LOG3 
-- backup dziennika transakcji o nazwie w opisie LOG4
-----------------------------------------------------
CREATE DATABASE [TEST4]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TEST4', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\TEST4.mdf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'TEST4_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\TEST4_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 WITH LEDGER = OFF
GO
ALTER DATABASE [TEST4] SET COMPATIBILITY_LEVEL = 170
GO
ALTER DATABASE [TEST4] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TEST4] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TEST4] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TEST4] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TEST4] SET ARITHABORT OFF 
GO
ALTER DATABASE [TEST4] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TEST4] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TEST4] SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF)
GO
ALTER DATABASE [TEST4] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TEST4] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TEST4] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TEST4] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TEST4] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TEST4] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TEST4] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TEST4] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TEST4] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TEST4] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TEST4] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TEST4] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TEST4] SET  READ_WRITE 
GO
ALTER DATABASE [TEST4] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [TEST4] SET  MULTI_USER 
GO
ALTER DATABASE [TEST4] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TEST4] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [TEST4] SET DELAYED_DURABILITY = DISABLED 
GO
USE [TEST4]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'PRIMARY') ALTER DATABASE [TEST4] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO

BACKUP DATABASE [TEST4] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\TEST4.bak' WITH FORMAT, INIT,  NAME = N'TEST4-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

BACKUP DATABASE [TEST4] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\TEST4.bak' WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  NAME = N'DIF1', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

BACKUP DATABASE [TEST4] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\TEST4.bak' WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  NAME = N'DIF2', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

BACKUP LOG [TEST4] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\TEST4.bak' WITH NOFORMAT, NOINIT,  NAME = N'LOG1', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

BACKUP LOG [TEST4] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\TEST4.bak' WITH NOFORMAT, NOINIT,  NAME = N'LOG2', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

BACKUP DATABASE [TEST4] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\TEST4.bak' WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  NAME = N'DIF3', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

BACKUP LOG [TEST4] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\TEST4.bak' WITH NOFORMAT, NOINIT,  NAME = N'LOG3', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

BACKUP LOG [TEST4] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\TEST4.bak' WITH NOFORMAT, NOINIT,  NAME = N'LOG4', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

-- Przywracamy bazę danych do pracy w danym czasie
-- 1. FULL
USE [master]
BACKUP LOG [TEST4] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\TEST4_LogBackup_2026-01-22_21-37-28.bak' WITH NOFORMAT, NOINIT,  NAME = N'TEST4_LogBackup_2026-01-22_21-37-28', NOSKIP, NOREWIND, NOUNLOAD,  NORECOVERY ,  STATS = 5
RESTORE DATABASE [TEST4] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\TEST4.bak' WITH  FILE = 1,  NOUNLOAD,  STATS = 5

GO

-- 2. FULL + DIF3
USE [master]
BACKUP LOG [TEST4] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\TEST4_LogBackup_2026-01-22_21-37-28.bak' WITH NOFORMAT, NOINIT,  NAME = N'TEST4_LogBackup_2026-01-22_21-37-28', NOSKIP, NOREWIND, NOUNLOAD,  NORECOVERY ,  STATS = 5
RESTORE DATABASE [TEST4] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\TEST4.bak' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE DATABASE [TEST4] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\TEST4.bak' WITH  FILE = 6,  NOUNLOAD,  STATS = 5

GO



-- 3. FULL + DIF2 + LOG1 + LOG2

-- 4. FULL + DIF3 + LOG3/LOG4 (wybrać dowolny czas między LOG3 a LOG4
USE [master]
BACKUP LOG [TEST4] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\TEST4_LogBackup_2026-01-22_21-37-28.bak' WITH NOFORMAT, NOINIT,  NAME = N'TEST4_LogBackup_2026-01-22_21-37-28', NOSKIP, NOREWIND, NOUNLOAD,  NORECOVERY ,  STATS = 5
RESTORE DATABASE [TEST4] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\TEST4.bak' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE DATABASE [TEST4] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\TEST4.bak' WITH  FILE = 6,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [TEST4] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\TEST4.bak' WITH  FILE = 7,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [TEST4] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\TEST4.bak' WITH  FILE = 8,  NOUNLOAD,  STATS = 5

GO



-- 5. Korzystając z Tail_log czyli w scenariuszu, gdzie odtwarzamy wszystkie możliwe dane 

-- 6. Przywracamy bazę z czasu wykonania backupu FULL pod nową nazwą TEST4_NEW
USE [master]
RESTORE DATABASE [TEST4_NEW] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\TEST4.bak' WITH  FILE = 1,  MOVE N'TEST4' TO N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\TEST4_NEW.mdf',  MOVE N'TEST4_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\TEST4_NEW_log.ldf',  NOUNLOAD,  STATS = 5
	
GO

---------------------------------------------------------------------------------------

-- 7. Utwórz bazę danych TEST5 z trzema grupami plików (g1,g2,g3). 
-- Następnie utwórz kopię bazy danych z wszystkich grup plików jako jeden backup (w tym samym czasie)

CREATE DATABASE [TEST5]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TEST5', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\TEST5.mdf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'TEST5_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\TEST5_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 WITH LEDGER = OFF
GO
ALTER DATABASE [TEST5] SET COMPATIBILITY_LEVEL = 170
GO
ALTER DATABASE [TEST5] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TEST5] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TEST5] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TEST5] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TEST5] SET ARITHABORT OFF 
GO
ALTER DATABASE [TEST5] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TEST5] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TEST5] SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF)
GO
ALTER DATABASE [TEST5] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TEST5] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TEST5] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TEST5] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TEST5] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TEST5] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TEST5] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TEST5] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TEST5] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TEST5] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TEST5] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TEST5] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TEST5] SET  READ_WRITE 
GO
ALTER DATABASE [TEST5] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [TEST5] SET  MULTI_USER 
GO
ALTER DATABASE [TEST5] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TEST5] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [TEST5] SET DELAYED_DURABILITY = DISABLED 
GO
USE [TEST5]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'PRIMARY') ALTER DATABASE [TEST5] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO
USE [master]
GO

GO
ALTER DATABASE [TEST5] ADD FILEGROUP [g1]
GO
ALTER DATABASE [TEST5] ADD FILEGROUP [g2]
GO
ALTER DATABASE [TEST5] ADD FILEGROUP [g3]
GO

BACKUP DATABASE [TEST5] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\TEST5.bak' WITH FORMAT, INIT,  NAME = N'TEST5-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO



-- Przywróć daną bazę danę pod nową nazwą TEST5_1.

USE [master]
RESTORE DATABASE [TEST5_1] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\TEST5.bak' WITH  FILE = 1,  MOVE N'TEST5' TO N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\TEST5_1.mdf',  MOVE N'TEST5_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\TEST5_1_log.ldf',  NOUNLOAD,  STATS = 5

GO

-- 8. Utwórz kopię bazy danych TEST5 w grup plików jako trzy osobne backupy w różnym czasie (backup filegroup (files))

BACKUP DATABASE [TEST5] FILEGROUP = N'g1' TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\TEST5.bak' WITH NOFORMAT, NOINIT,  NAME = N'G1', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
-- ...

-- Przywróc daną bazę danę pod nową nazwą TEST5_2.
	

-- 9. Wykonaj pełną kopię zapasową bazy AdventureWorks2019(22) (lub AdventureWorksLT2019(22)).
-- Wykonaj kopię rożnicową 5 razy.  Sprawdzamy nagłówek backupu (RESTORE HEADERONLY): 
-- Kasujemy historię backupów EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = 'AdventureWorksLT2019'
-- Skasuj tą bazę i przywróc ponownie pod tą samą nazwą z pozycji 4 backupu (full + trzeci różnicowy).


-- 10. Zdefiniuj urządzenia lub zestaw plików backupów do tworzenia backupu równolegle na całym zestawie 
-- (zestaw trzech plików lub urządzeń). Następnie przetestuj integralność kopii zapasowych (RESTORE VERIFYONLY)
USE master;
GO
BACKUP DATABASE [north] 
TO  
    DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\NW_Striped_1.bak',
    DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\NW_Striped_2.bak',
    DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\NW_Striped_3.bak'
WITH FORMAT, INIT, NAME = N'Northwind-StripedBackup', STATS = 10;
GO

-- Test integralności (musi mieć dostęp do wszystkich 3 części na raz!)
RESTORE VERIFYONLY 
FROM 
    DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\NW_Striped_1.bak',
    DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\NW_Striped_2.bak',
    DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\NW_Striped_3.bak';
GO



-- 11. Porównanie wydajności z i bez kompresji:
-- Przetestuj szybkość tworzenia i przywracania kopii zapasowej z włączoną i wyłączoną kompresją (AdventureWorksDW2019(22).
-- Podaj czas tworzenia backupu, odtwarzanie z backupu oraz wielkość backupu (z i bez kompresji)

USE master;
GO
DECLARE @startTime DATETIME = GETDATE();
BACKUP DATABASE [Northwind] 
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\NW_NoCompression.bak' 
WITH INIT, NO_COMPRESSION;
PRINT 'Czas bez kompresji: ' + CONVERT(varchar, GETDATE() - @startTime, 114);
GO

DECLARE @startTime DATETIME = GETDATE();
BACKUP DATABASE [Northwind] 
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\NW_Compression.bak' 
WITH INIT, COMPRESSION;
PRINT 'Czas z kompresją: ' + CONVERT(varchar, GETDATE() - @startTime, 114);
GO

SELECT 
    physical_device_name, 
    backup_size/1024/1024 AS [Size_MB], 
    compressed_backup_size/1024/1024 AS [Compressed_Size_MB]
FROM msdb.dbo.backupset b 
JOIN msdb.dbo.backupmediafamily m ON b.media_set_id = m.media_set_id
WHERE database_name = 'Northwind' 
ORDER BY backup_finish_date DESC;

-- 12. Przywracanie usuniętej tabeli z wcześniej wykonanego backupu, która zawierała tą tabele. 
-- Po usunięciu  wybranej tabeli z bazy danych, przywróć tą tabelę do danej struktury.

BACKUP DATABASE [Northwind] TO DISK = N'C:\Temp\NW_Full.bak' WITH INIT;
GO

USE [Northwind];
DROP TABLE [dbo].[Region];
GO

-- Krok 3: Przywracamy backup jako nową bazę "Northwind_Rescue"
USE [master];
RESTORE DATABASE [Northwind_Rescue] 
FROM DISK = N'C:\Temp\NW_Full.bak'
WITH MOVE 'Northwind' TO 'C:\Temp\nw_rescue.mdf',
     MOVE 'Northwind_log' TO 'C:\Temp\nw_rescue.ldf';
GO

USE [Northwind];
SELECT * INTO [dbo].[Region] FROM [Northwind_Rescue].[dbo].[Region];
GO

-- Krok 5: Sprzątamy (usuwamy bazę ratunkową)
USE [master];
DROP DATABASE [Northwind_Rescue];
GO



-- 13. Testowanie integralności kopii zapasowych:
-- Zweryfikuj wszystkie pliki kopii zapasowych dla wybranej bazy danych.
RESTORE VERIFYONLY 
FROM DISK = N'C:\Temp\NW_Full.bak';
GO


-- 14. Utworzenie kopii zapasowych wszystkich baz danych na serwerze za wyjątkiem systemowych w jednym urządzeniu (kod T-SQL)

DECLARE @name VARCHAR(50)
DECLARE @path VARCHAR(256)
DECLARE @fileName VARCHAR(256)
DECLARE @fileDate VARCHAR(20)

SET @path = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\' 

DECLARE db_cursor CURSOR FOR  
SELECT name 
FROM master.dbo.sysdatabases 
WHERE name NOT IN ('master','model','msdb','tempdb')

OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @name   

WHILE @@FETCH_STATUS = 0   
BEGIN   
       SET @fileName = @path + 'AllDBs_Backup.bak'  -- Zapisujemy wszystko do jednego pliku (append)
       
       BACKUP DATABASE @name TO DISK = @fileName WITH NOINIT, NAME = @name;

       FETCH NEXT FROM db_cursor INTO @name   
END   

CLOSE db_cursor   
DEALLOCATE db_cursor

-- 15. Zdefiniuj bazę danych TEST6 z dwoma grupami plików PRIMARY i gr_INDEKS oraz tabelę test, która dane przechowuje w grupie PRIMATY, 
-- a dowolny indeks NONCLUSTRED na tej tabeli jest przechowywany w grupie gr_INDEKS. 
-- Wykonaj backup bazy danych osobno grupy plików PRIMARY i za chwilę grupy plików gr_INDEKS.
-- Jaki jest tutaj problem? 

USE master;
GO
CREATE DATABASE [TEST6]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TEST6', FILENAME = N'C:\Temp\TEST6.mdf' ), 
 FILEGROUP [gr_INDEKS] 
( NAME = N'TEST6_Idx', FILENAME = N'C:\Temp\TEST6_Idx.ndf' )
 LOG ON 
( NAME = N'TEST6_log', FILENAME = N'C:\Temp\TEST6_log.ldf' );
GO

USE [TEST6];
GO
CREATE TABLE dbo.TestTable (ID int, Dane varchar(50)) ON [PRIMARY];
INSERT INTO dbo.TestTable VALUES (1, 'Test');

CREATE NONCLUSTERED INDEX [IX_TestTable_Dane] ON dbo.TestTable(Dane) ON [gr_INDEKS];
GO

BACKUP DATABASE [TEST6] FILEGROUP = 'PRIMARY' 
TO DISK = 'C:\Temp\TEST6_Pri.bak' WITH INIT;
GO
WAITFOR DELAY '00:00:05';
BACKUP DATABASE [TEST6] FILEGROUP = 'gr_INDEKS' 
TO DISK = 'C:\Temp\TEST6_Idx.bak' WITH INIT;
GO

-- 16. Wykonaj backup bazy danych model na urządzeniu o nazwie MODEL i ustaw jej ważność na 30 dni oraz MEDIANAME = 'MODEL'
-- Spróbuj wykonać na tym urządzeniu backup bazy danych z opcją nadpisywania backupu (i opcją NOSKIP).
-- Spróbuj wykonać na tym urządzeniu backup bazy danych z opcją dodawania backupu i podaniem niepoprawnego Media set name (MEDIANAME = 'MODEL1').
-- Spróbuj wykonać na tym urządzeniu backup bazy danych z opcją dodawania backupu i podaniem poprawnego Media set name (MEDIANAME = 'MODEL').



USE master;
GO
EXEC sp_addumpdevice 'disk', 'MODEL_DEV', 'C:\Temp\MODEL_DEV.bak';
GO

BACKUP DATABASE [model] 
TO MODEL_DEV 
WITH FORMAT, 
     MEDIANAME = 'MODEL', 
     NAME = 'Backup1', 
     RETAINDAYS = 30;
GO

BACKUP DATABASE [model] TO MODEL_DEV WITH INIT, MEDIANAME = 'MODEL';
GO
BACKUP DATABASE [model] TO MODEL_DEV WITH NOINIT, MEDIANAME = 'MODEL1';
GO
BACKUP DATABASE [model] TO MODEL_DEV WITH NOINIT, MEDIANAME = 'MODEL';
GO



-- 17. Wykonaj Export Data-Tier Application dowolnej bazy i następnie przywróć ją pod nazwą EDTA 
-- i sprawdź co zawiera (nie jest to narzędzie o nazwie backup)
-- (nie generujemy skryptu do tego zadania)

--OK