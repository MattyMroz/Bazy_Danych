Tworzenie Loginów/Userów:
Create Login (Transact-SQL)
https://learn.microsoft.com/en-us/sql/t-sql/statements/create-login-transact-sql?view=sql-server-ver17

Create User (Transact-SQL)
https://learn.microsoft.com/en-us/sql/t-sql/statements/create-user-transact-sql?view=sql-server-ver17

Backup (Pełny, Różnicowy, Log):
BACKUP (Transact-SQL) - składnia
https://learn.microsoft.com/en-us/sql/t-sql/statements/backup-transact-sql?view=sql-server-ver17

Restore (Przywracanie - kluczowe MOVE i NORECOVERY):
RESTORE (Transact-SQL) - Arguments (ważne: RECOVERY/NORECOVERY)
https://learn.microsoft.com/en-us/sql/t-sql/statements/restore-statements-arguments-transact-sql?view=sql-server-ver17

Pliki i Grupy Plików (Filegroups):
ALTER DATABASE File and Filegroup Options
https://learn.microsoft.com/en-us/sql/t-sql/statements/alter-database-transact-sql-file-and-filegroup-options?view=sql-server-ver17

Partycjonowanie (Najtrudniejsze składniowo):
CREATE PARTITION FUNCTION
https://learn.microsoft.com/en-us/sql/t-sql/statements/create-partition-function-transact-sql?view=sql-server-ver17

CREATE PARTITION SCHEME
https://learn.microsoft.com/en-us/sql/t-sql/statements/create-partition-scheme-transact-sql?view=sql-server-ver17


USE B2026;
GO

CREATE TABLE TAB2026
(
	ID INT IDENTITY(1,1),
	DATA VARCHAR(100)
) ON dane_hist
GO

INSERT INTO TAB2026 (DATA) VALUES ('To są przykładowe dane');
GO 100


ZADANIE 1


USE [master]
GO
CREATE LOGIN [U2025a] WITH PASSWORD=N'12345', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE [master]
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'B2025a') DROP DATABASE [B2025a]
CREATE DATABASE [B2025a]
GO

ALTER DATABASE [B2025a] SET RECOVERY FULL;
GO

USE [B2025a]
GO
CREATE USER [U2025a] FOR LOGIN [U2025a]
GO

GRANT BACKUP DATABASE TO [U2025a];
GRANT BACKUP LOG TO [U2025a];
GO


ZADANIE 2

USE [master]
GO

EXEC master.dbo.sp_addumpdevice  @devtype = N'disk', @logicalname = N'251190', @physicalname = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\251190.bak'
GO

USE [B2025a]
GO

EXECUTE AS LOGIN = 'U2025a';
GO

BACKUP DATABASE [B2025a] TO [251190]
WITH NOFORMAT, INIT, NAME = N'Full1', SKIP, NOREWIND, NOUNLOAD, STATS = 10
GO

BACKUP DATABASE [B2025a] TO [251190]
WITH DIFFERENTIAL, NOFORMAT, NOINIT, NAME = N'Diff1', SKIP, NOREWIND, NOUNLOAD, STATS = 10
GO

BACKUP LOG [B2025a] TO [251190]
WITH NOFORMAT, NOINIT, NAME = N'Log1', SKIP, NOREWIND, NOUNLOAD, STATS = 10
GO

BACKUP DATABASE [B2025a] TO [251190]
WITH DIFFERENTIAL, NOFORMAT, NOINIT, NAME = N'Diff2', SKIP, NOREWIND, NOUNLOAD, STATS = 10
GO

BACKUP DATABASE [B2025a] TO [251190]
WITH DIFFERENTIAL, NOFORMAT, NOINIT, NAME = N'Diff3', SKIP, NOREWIND, NOUNLOAD, STATS = 10
GO

BACKUP LOG [B2025a] TO [251190]
WITH NOFORMAT, NOINIT, NAME = N'Log2', SKIP, NOREWIND, NOUNLOAD, STATS = 10
GO

BACKUP LOG [B2025a] TO [251190]
WITH NOFORMAT, NOINIT, NAME = N'Log3', SKIP, NOREWIND, NOUNLOAD, STATS = 10
GO

REVERT;
GO








ZADANIE 3





ZADANIE 6 - PARTYCJONOWANIE TABELI WEDŁUG ROKU
USE B2026a;
GO

CREATE PARTITION FUNCTION PF2026 (date)
AS RANGE LEFT FOR VALUES ('2023-01-01', '2026-01-01');
GO

CREATE PARTITION SCHEME PS2026
AS PARTITION PF2026
TO (GR1, GR2, GR3);
GO

CREATE TABLE TEST (ID INT IDENTITY(1,1), ROK DATE)
ON PS2026(ROK);
GO

ALTER PARTITION SCHEME PS2026 NEXT USED GR3;
GO

ALTER PARTITION FUNCTION PF2026() SPLIT RANGE ('2027-01-01');
GO

INSERT INTO TEST (ROK) VALUES ('2020-01-01');
GO 10
INSERT INTO TEST (ROK) VALUES ('2024-01-01');
GO 10
INSERT INTO TEST (ROK) VALUES ('2026-06-01');
GO 10
INSERT INTO TEST (ROK) VALUES ('2028-01-01');
GO 10





