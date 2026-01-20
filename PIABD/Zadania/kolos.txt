-- Nazwisko i imię : 
-- Numer indeksu   : 
--------------------------------------

--W skrypcie do każdego z podpunktów w celu zalogowania się jako użytkownik inny niż 'sa' jeśli jest taka potrzeba przetestowania, używamy polecenia 
--EXECUTE AS LOGIN='U2026a' oraz REVERT na zakończeniu .

--Utworzyć bazę danych poleceniem CREATE DATABASE B2026a (powinna być standardowo w trybie recovery: FULL - sprawdzić).
USE MASTER
GO
DROP DATABASE IF EXISTS B2026a
GO
CREATE DATABASE B2026a
GO
USE B2026a

--1. Utworzyć użytkownika SQL Serwera o nazwie U2026a z hasłem '12345' oraz użytkownika bazy danych B2026a o nazwie U2026a
--   i przypisać mu prawa potrzebne do wykonywania kopii zapasowej tylko w bazie B2026a (minimalne uprawnienia!).
--   Nie zapisujemy użytkownika do roli db_backupoperator tylko nadajemy użytkownikowi bazy danych wszystkie uprawnienia 
--   szczegółowe dokładnie takie jak ma rola db_backupoperator)

USE MASTER;
GO
CREATE LOGIN U2026a WITH PASSWORD = '12345', CHECK_POLICY = OFF;
GO
USE B2026a;
GO
CREATE USER U2026a FOR LOGIN U2026a;
GO
GRANT BACKUP DATABASE TO U2026a;
GO

--2. Przed wykonaniem kopii należy zdefiniować urządzanie do backupu o nazwie 'numer indeksu danego studenta' jako sa. 
--   Utworzyć kopię bezpieczeństwa bazy danych B2026a jako użytkownik U2026a: 
--   Full1 (Pełny) + Diff1 (różnicowy) + Log1 (dziennika transakcji) + Diff2 (różnicowy) + Diff3 (różnicowy) + Log2 (dziennika transakcji) + Log3 (dziennika transakcji) 
--   na wcześniej utworzonym urządzeniu do backupu. Przy tworzeniu tylko pełnej kopii zapasowej zawartość plików z backupem nadpisujemy.
USE master;
GO
EXEC sp_dropdevice '251184';
GO

USE B2026a;
GO
GRANT BACKUP LOG TO U2026a;
GO

USE master;
GO
EXEC sp_addumpdevice 'disk', '251184', 'C:\Backup\251184.bak';
GO

EXECUTE AS LOGIN = 'U2026a';
GO

BACKUP DATABASE B2026a 
TO [251184] 
WITH INIT, NAME = 'Full1';
GO
BACKUP DATABASE B2026a 
TO [251184] 
WITH DIFFERENTIAL, NAME = 'Diff1';
GO
BACKUP LOG B2026a 
TO [251184] 
WITH NAME = 'Log1';
GO
BACKUP DATABASE B2026a 
TO [251184] 
WITH DIFFERENTIAL, NAME = 'Diff2';
GO
BACKUP DATABASE B2026a 
TO [251184] 
WITH DIFFERENTIAL, NAME = 'Diff3';
GO
BACKUP LOG B2026a 
TO [251184] 
WITH NAME = 'Log2';
GO
BACKUP LOG B2026a 
TO [251184] 
WITH NAME = 'Log3';
GO
REVERT;
GO

--3. Jako 'sa' przywrócić bazę danych B2026a pod nową nazwą 'numer indeksu danego studenta' w momencie tworzenia dziennika transakcji Log3
--   zakładając, że utraciliśmy pierwsze dwa backupy różnicowe (Diff i Diff2) oraz utraciliśmy Log1 (nie możemy z nich skorzystać) 
--   (oczywiście jeśli się da wykonać takie przywracanie).

USE master;
GO

RESTORE DATABASE [251184]
FROM [251184]
WITH FILE = 1,
MOVE 'B2026a' TO 'C:\Backup\251184.mdf',
MOVE 'B2026a_log' TO 'C:\Backup\251184_log.ldf',
NORECOVERY;
GO

RESTORE DATABASE [251184]
FROM [251184]
WITH FILE = 4,
NORECOVERY;
GO
RESTORE LOG [251184]
FROM [251184]
WITH FILE = 6,
NORECOVERY;
GO
RESTORE LOG [251184]
FROM [251184]
WITH FILE = 7,
RECOVERY;
GO

--4. Dołożyć nową grupę plików o nazwie KOLO1 w bazie B2026a, która zawierać będzie 2 pliki o nazwie B01.ndf oraz B02.ndf.
--   Wielkość początkowa pliku B01.ndf i B02.ndf to 200 MB.  
--   Zdefiniuj tabelę TAB2026, która przechowuje dane w grupie plików o nazwie KOLO1. Następnie należy napisać dowolny skrypt 
--   w celu dodania 100 rekordów do tej tabeli w celu wypełnienia danymi przed przeniesieniem danych). 
--   Naszym zadaniem jest skasowanie pierwszego pliku (B01.ndf), co musimy poprzedzić przeniesieniem danych z pliku B01 do pliku B02.
--   Następnie naszym zadaniem jest zwiększenie rozmiaru pliku (B02.ndf) do wartości 400 MB odpowiednim poleceniem, 
--   a następnie należy zmniejszyć rozmiar tylko tego pliku do 24 MB (jeśli się da).

USE B2026a;
GO

ALTER DATABASE B2026a 
ADD FILEGROUP KOLO1;
GO
ALTER DATABASE B2026a 
ADD FILE (
    NAME = B01,
    FILENAME = 'C:\Backup\B01.ndf',
    SIZE = 200MB
) TO FILEGROUP KOLO1;
GO
ALTER DATABASE B2026a 
ADD FILE (
    NAME = B02,
    FILENAME = 'C:\Backup\B02.ndf',
    SIZE = 200MB
) TO FILEGROUP KOLO1;
GO

CREATE TABLE TAB2026 (
    ID INT IDENTITY(1,1),
    TXT VARCHAR(50)
) ON KOLO1;
GO

DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO TAB2026 VALUES (CONVERT(VARCHAR(50), NEWID()));
    SET @i = @i + 1;
END
GO

DBCC SHRINKFILE (B01, EMPTYFILE);
GO

ALTER DATABASE B2026a 
REMOVE FILE B01;
GO
ALTER DATABASE B2026a 
MODIFY FILE (
    NAME = B02,
    SIZE = 400MB
);
GO

DBCC SHRINKFILE (B02, 24);
GO


--5. Dla użytkownika logowania U2026a utworzyć użytkownika o nazwie U2026a w bazie danych NORTHWIND. 
--   Zdefiniuj w bazie Northwind nową rolę o nazwie ROLA3 i ROLA4. 
--   Roli ROLA3 nadaj uprawnienia wykonywania poleceń SELECT, INSERT, UPDATE na tabeli Categories oraz uprawnienia SELECT, UPDATE na tabeli Products. 
--   Roli ROLA4 zabroń wykonywania polecenia SELECT, INSERT na tabeli Products. 
--   Dodatkowo zabroń wstawiania danych do tabeli Categories. 
--   Do roli ROLA3 i ROLA4 zapisz użytkownika U2026a.
--   Napisz polecenie do sprwadzenia uprawnień efektywnych do tabeli Categories użytkownikowi U2026a.

USE Northwind;
GO

CREATE USER U2026a FOR LOGIN U2026a;
GO
CREATE ROLE ROLA3;
GO
CREATE ROLE ROLA4;
GO

GRANT SELECT, INSERT, UPDATE ON dbo.Categories TO ROLA3;
GRANT SELECT, UPDATE ON dbo.Products TO ROLA3;
GO
DENY SELECT, INSERT ON dbo.Products TO ROLA4;
DENY INSERT ON dbo.Categories TO ROLA4;
GO

EXEC sp_addrolemember 'ROLA3', 'U2026a';
EXEC sp_addrolemember 'ROLA4', 'U2026a';
GO
EXECUTE AS USER = 'U2026a';
GO
SELECT * FROM fn_my_permissions('dbo.Categories', 'OBJECT');
GO
REVERT;
GO

--6. Do bazy danych BAZA2026a dołożyć trzy grupy plików o nazwie GR1, GR2, GR3 z dowolnie nazwanymi plikami z danymi. 
--   Zdefiniować funkcję partycjonującą o granicach związanych z datą, a konkretnie latami 2023 i 2026 (3 zakresy). 
--   Następnie zdefiniować schemat partycji z wykorzystaniem grup plików o nazwie GR1, GR2, GR3. 
--   Zdefiniować tabelę TEST z polami (ID int NOT NULL identity(1,1), ROK date (lub datetime)), gdzie kolumna ROK jest kolumną partycjonowaną.
--   Następnie rozszerzyć strukturę, aby funkcja partycjonująca miała dodatkowy element 2027 (pamiętajmy iż musimy mieć dodatkową grupę plików).
--   Dodaj do każdej z partycji po 10 rekordów. 
--   Sprawdź w danej bazie w Reports - Disk Usage of Partition czy faktycznie każda partycja ma po 10 rekordów

-- użuywam bazy B2026a zamiast BAZA2026a bo taką wcześniej stworzyłem
USE B2026a;
GO

ALTER DATABASE B2026a ADD FILEGROUP GR1;
ALTER DATABASE B2026a ADD FILEGROUP GR2;
ALTER DATABASE B2026a ADD FILEGROUP GR3;
GO
ALTER DATABASE B2026a 
ADD FILE (NAME = GR1F, FILENAME = 'C:\Backup\GR1F.ndf', SIZE = 50MB) TO FILEGROUP GR1;
ALTER DATABASE B2026a 
ADD FILE (NAME = GR2F, FILENAME = 'C:\Backup\GR2F.ndf', SIZE = 50MB) TO FILEGROUP GR2;
ALTER DATABASE B2026a 
ADD FILE (NAME = GR3F, FILENAME = 'C:\Backup\GR3F.ndf', SIZE = 50MB) TO FILEGROUP GR3;
GO

CREATE PARTITION FUNCTION PF2026 (date)
AS RANGE LEFT FOR VALUES ('2023-01-01', '2026-01-01');
GO
CREATE PARTITION SCHEME PS2026
AS PARTITION PF2026
TO (GR1, GR2, GR3);
GO
CREATE TABLE TEST (
    ID INT IDENTITY(1,1) NOT NULL,
    ROK DATE NOT NULL
) ON PS2026(ROK);
GO
ALTER DATABASE B2026a ADD FILEGROUP GR4;
GO
ALTER DATABASE B2026a 
ADD FILE (NAME = GR4F, FILENAME = 'C:\Backup\GR4F.ndf', SIZE = 50MB) TO FILEGROUP GR4;
GO
ALTER PARTITION SCHEME PS2026 NEXT USED GR4;
GO
ALTER PARTITION FUNCTION PF2026()
SPLIT RANGE ('2027-01-01');
GO

TRUNCATE TABLE TEST;

INSERT INTO TEST (ROK) VALUES 
('2020-01-10'), ('2020-02-10'), ('2020-03-10'), ('2020-04-10'), ('2020-05-10'), ('2020-06-10'), ('2020-07-10'), ('2020-08-10'), ('2020-09-10'), ('2020-10-10');
GO
INSERT INTO TEST (ROK) VALUES 
('2023-01-10'), ('2023-02-10'), ('2023-03-10'), ('2023-04-10'), ('2023-05-10'), ('2023-06-10'), ('2023-07-10'), ('2023-08-10'), ('2023-09-10'), ('2023-10-10');
GO
INSERT INTO TEST (ROK) VALUES 
('2026-01-10'), ('2026-02-10'), ('2026-03-10'), ('2026-04-10'), ('2026-05-10'), ('2026-06-10'), ('2026-07-10'), ('2026-08-10'), ('2026-09-10'), ('2026-10-10');
GO
INSERT INTO TEST (ROK) VALUES 
('2027-01-10'), ('2027-02-10'), ('2027-03-10'), ('2027-04-10'), ('2027-05-10'), ('2027-06-10'), ('2027-07-10'), ('2027-08-10'), ('2027-09-10'), ('2027-10-10');
GO