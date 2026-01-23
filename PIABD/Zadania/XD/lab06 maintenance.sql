----------------------------------
-- SQL Server Maintenance Plans --
----------------------------------


-- Na podstawie pozycji literaturowej Brad’s Sure Guide to SQL Server Maintenance Plans 
-- wykonujemy poniższe zadania (nie zapisujemy w tym pliku skryptów dla zadań (jobs) tylko wykonujemy i sprawdzamy w SSMS) 
-- Wypisujemy tylko przykładowe zapytania tworzące dane zadanie np. backup bazy danych, reorganizacja indeksów (wybrane 2-3 indeksy), wykonane zapytanie, itd.

-- 1. Przed utworzeniem planu konserwacji 
  -- a. ustawić Database Mail (środowisko testowe Parpercut_SMTP)
  -- b. utwórzyć jednego lub więcej operatorów agentów SQL Server, którzy będą otrzymywać powiadomienia e-mail (np. operator1)
EXEC msdb.dbo.sp_add_operator @name=N'operator1', 
		@enabled=1, 
		@email_address=N'operator1@example.com';
GO

-- 2. Check Database Integrity - definiujemy plan i sprawdzamy działanie
DBCC CHECKDB (N'Northwind') WITH NO_INFOMSGS;
GO

-- 3. Shrink Database - definiujemy plan i sprawdzamy działanie
USE [Northwind]
GO
DBCC SHRINKDATABASE (N'Northwind', 10);
GO

-- 4. Rebuild Index - definiujemy plan i sprawdzamy działanie
USE [Northwind]
GO
ALTER INDEX [PK_Orders] ON [dbo].[Orders] REBUILD;
GO

-- 5. Reorganize Index - definiujemy plan i sprawdzamy działanie
USE [Northwind]
GO
ALTER INDEX [CustomersOrders] ON [dbo].[Orders] REORGANIZE;
GO

-- 6. Update Statistics - definiujemy plan i sprawdzamy działanie
USE [Northwind]
GO
UPDATE STATISTICS [dbo].[Products] WITH FULLSCAN;
GO

-- 7. Execute SQL Server Agent Job - definiujemy plan i sprawdzamy działanie
EXEC msdb.dbo.sp_start_job N'NazwaInnegoZadania';
GO

-- 8. History Cleanup - definiujemy plan i sprawdzamy działanie
EXEC msdb.dbo.sp_purge_jobhistory @job_name = N'NazwaZadaniaDoWyczyszczenia';
GO

-- 9. Back Up Database (Full) - definiujemy plan i sprawdzamy działanie
BACKUP DATABASE [Northwind] 
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\Northwind.bak' 
WITH NOFORMAT, INIT, NAME = N'Northwind-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, STATS = 10;
GO

--10. Back Up Database (Diff) - definiujemy plan i sprawdzamy działanie
BACKUP DATABASE [Northwind] 
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\Northwind.bak' 
WITH DIFFERENTIAL, NOFORMAT, NOINIT, NAME = N'Northwind-Differential Database Backup', SKIP, NOREWIND, NOUNLOAD, STATS = 10;
GO

--11. Back Up Database (Log) - definiujemy plan i sprawdzamy działanie
BACKUP LOG [Northwind] 
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\Northwind.bak' 
WITH NOFORMAT, NOINIT, NAME = N'Northwind-Transaction Log Backup', SKIP, NOREWIND, NOUNLOAD, STATS = 10;
GO

--12. Maintenance Plan Designer - definiujemy wybrany plan lub plany za pomocą projektanta i sprawdzamy jego działanie.

--13. Zadanie uruchamiamy na życzenie i planujemy wykonywanie zadań cyklicznie - Task Scheduling