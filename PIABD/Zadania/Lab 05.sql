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
select * into cat from northwind.dbo.categories
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
-- Przywracamy bazę danych do pracy w danym czasie
-- 1. FULL

-- 2. FULL + DIF3

-- 3. FULL + DIF2 + LOG1 + LOG2

-- 4. FULL + DIF3 + LOG3/LOG4 (wybrać dowolny czas między LOG3 a LOG4

-- 5. Korzystając z Tail_log czyli w scenariuszu, gdzie odtwarzamy wszystkie możliwe dane 

-- 6. Przywracamy bazę z czasu wykonania backupu FULL pod nową nazwą TEST4_NEW

---------------------------------------------------------------------------------------

-- 7. Utwórz bazę danych TEST5 z trzema grupami plików (g1,g2,g3). 
-- Następnie utwórz kopię bazy danych z wszystkich grup plików jako jeden backup (w tym samym czasie)
-- Przywróć daną bazę danę pod nową nazwą TEST5_1.
-- 8. Utwórz kopię bazy danych TEST5 w grup plików jako trzy osobne backupy w różnym czasie (backup filegroup (files))
-- Przywróc daną bazę danę pod nową nazwą TEST5_2.
-- 9. Wykonaj pełną kopię zapasową bazy AdventureWorks2019(22) (lub AdventureWorksLT2019(22)).
-- Wykonaj kopię rożnicową 5 razy.  Sprawdzamy nagłówek backupu (RESTORE HEADERONLY): 
-- Kasujemy historię backupów EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = 'AdventureWorksLT2019'
-- Skasuj tą bazę i przywróc ponownie pod tą samą nazwą z pozycji 4 backupu (full + trzeci różnicowy).
-- 10. Zdefiniuj urządzenia lub zestaw plików backupów do tworzenia backupu równolegle na całym zestawie 
-- (zestaw trzech plików lub urządzeń). Następnie przetestuj integralność kopii zapasowych (RESTORE VERIFYONLY)
-- 11. Porównanie wydajności z i bez kompresji:
-- Przetestuj szybkość tworzenia i przywracania kopii zapasowej z włączoną i wyłączoną kompresją (AdventureWorksDW2019(22).
-- Podaj czas tworzenia backupu, odtwarzanie z backupu oraz wielkość backupu (z i bez kompresji)
-- 12. Przywracanie usuniętej tabeli z wcześniej wykonanego backupu, która zawierała tą tabele. 
-- Po usunięciu  wybranej tabeli z bazy danych, przywróć tą tabelę do danej struktury.
-- 13. Testowanie integralności kopii zapasowych:
-- Zweryfikuj wszystkie pliki kopii zapasowych dla wybranej bazy danych.
-- 14. Utworzenie kopii zapasowych wszystkich baz danych na serwerze za wyjątkiem systemowych w jednym urządzeniu (kod T-SQL)
-- 15. Zdefiniuj bazę danych TEST6 z dwoma grupami plików PRIMARY i gr_INDEKS oraz tabelę test, która dane przechowuje w grupie PRIMATY, 
-- a dowolny indeks NONCLUSTRED na tej tabeli jest przechowywany w grupie gr_INDEKS. 
-- Wykonaj backup bazy danych osobno grupy plików PRIMARY i za chwilę grupy plików gr_INDEKS.
-- Jaki jest tutaj problem? 
-- 16. Wykonaj backup bazy danych model na urządzeniu o nazwie MODEL i ustaw jej ważność na 30 dni oraz MEDIANAME = 'MODEL'
-- Spróbuj wykonać na tym urządzeniu backup bazy danych z opcją nadpisywania backupu (i opcją NOSKIP).
-- Spróbuj wykonać na tym urządzeniu backup bazy danych z opcją dodawania backupu i podaniem niepoprawnego Media set name (MEDIANAME = 'MODEL1').
-- Spróbuj wykonać na tym urządzeniu backup bazy danych z opcją dodawania backupu i podaniem poprawnego Media set name (MEDIANAME = 'MODEL').
-- 17. Wykonaj Export Data-Tier Application dowolnej bazy i następnie przywróć ją pod nazwą EDTA 
-- i sprawdź co zawiera (nie jest to narzędzie o nazwie backup)
-- (nie generujemy skryptu do tego zadania)