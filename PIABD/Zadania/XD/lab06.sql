-- https://learn.microsoft.com/en-us/sql/relational-databases/database-mail/configure-database-mail?view=sql-server-ver16
-- Database Mail
-- Aby zarządzać wszystkimi elementami Database Mail, użytkownik musi należeć do roli sysadmin.
-- Sysadmin może konfigurować Database Mail, zarządzać profilami i kontami,
-- przeglądać wiadomości wysłane przez innych oraz czyścić kolejki.
-- Użytkownicy spoza roli sysadmin widzą tylko wiadomości, które sami próbowali wysłać.

-- Service Broker = system kolejek i komunikatów w SQL Server.
-- Aby Database Mail działał poprawnie, Service Broker musi być włączony w bazie msdb.
-- Jeśli Service Broker w msdb jest wyłączony, SQL Server Agent może blokować jego włączenie.
-- W takiej sytuacji należy najpierw zatrzymać usługę SQL Server Agent,
-- aby ALTER DATABASE msdb SET ENABLE_BROKER mógł uzyskać wyłączną blokadę bazy.

USE msdb;
SELECT is_broker_enabled FROM sys.databases WHERE name = DB_NAME();

-- Włączenie Service Broker w msdb natychmiastowo (może zwrócić błędy):
ALTER DATABASE msdb SET ENABLE_BROKER WITH NO_WAIT
-- Włączenie Service Broker w msdb z natychmiastowym rozłączeniem aktywnych sesji:
ALTER DATABASE msdb SET ENABLE_BROKER WITH ROLLBACK IMMEDIATE;

-- Ogólne kroki rozwiązywania problemów z Database Mail
-- https://learn.microsoft.com/en-us/sql/relational-databases/database-mail/database-mail-general-troubleshooting?view=sql-server-ver16
-- 1. Czy poczta bazy danych jest włączona?
EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
EXEC sp_configure 'Agent XPs', 1;
GO
RECONFIGURE
GO
EXEC sp_configure 'show advanced options', 0;
GO
RECONFIGURE;

-- 2. Czy użytkownicy są odpowiednio skonfigurowani do wysyłania poczty (oprócz sysadmin i dbowner bazy msdb)?
EXEC msdb.sys.sp_helprolemember 'DatabaseMailUserRole'; -- default brak rekordów
-- Aby dodać użytkowników do roli DatabaseMailUserRole, użyj następującej instrukcji:
   -- sp_addrolemember @rolename = 'DatabaseMailUserRole' ,@membername = '<database user>';
   -- EXEC sp_addrolemember @rolename = 'DatabaseMailUserRole' ,@membername = 'guest';
-- Dane konto bazy jest przypisane do profilu np. Profil_1
EXEC msdb.dbo.sysmail_help_principalprofile_sp;

-- 3. Czy poczta bazy danych została uruchomiona?
EXEC msdb.dbo.sysmail_help_status_sp; -- status 
GO
-- Uruchomienie kolejki (start i stop usługi wysyłania maili)
EXEC msdb.dbo.sysmail_start_sp;
EXEC msdb.dbo.sysmail_stop_sp;
GO

-- 4. Status kolejki Database Mail
-- Prawidłowy stan kolejki to RECEIVES_OCCURRING (kolejka aktywnie działa).
-- Jeśli kolejka jest INACTIVE, oznacza to, że obecnie nie przetwarza wiadomości
-- co jest normalne, gdy nie ma maili do wysłania.
-- Jeśli stan kolejki nie zmienia się na RECEIVES_OCCURRING po wysłaniu maila,
-- można ponownie uruchomić moduł Database Mail.
-- Kolumna 'length' w wyniku sysmail_help_queue_sp pokazuje liczbę wiadomości oczekujących.
EXEC msdb.dbo.sysmail_help_queue_sp @queue_type = 'mail';
GO
-- Które konto faktycznie wysyła wiadomości
-- sent_account_id wskazuje konto DB Mail, przez które wysłano daną wiadomość.
SELECT sent_account_id, sent_date 
FROM msdb.dbo.sysmail_sentitems;
-- Nazwy kont 
SELECT account_id, name, email_address, display_name
FROM msdb.dbo.sysmail_account;
-- Lista wysłanych wiadomości z pełną zawartością
SELECT * FROM msdb.dbo.sysmail_sentitems;
-- Logi błędów i zdarzeń Database Mail
SELECT * FROM msdb.dbo.sysmail_event_log;
-- kasowanie wysłanych maili i logów
DELETE FROM msdb.dbo.sysmail_sentitems;
DELETE FROM msdb.dbo .sysmail_event_log;

-- 5. Dodatkowo wysyłamy mail bezpośrednio za pomocą procedury xp_send_dbmail bezpośrednio z poziomu języka SQL
EXEC msdb.dbo.sp_send_dbmail 
 @profile_name = 'Profil_1', 
 @recipients = 'test@interia.pl', 
 @body = 'Test', 
 @subject = 'Test Mail SQL Server' ;
-- Wysyłamy mail i zapytanie w pliku: 'SELECT categoryid, categoryname FROM Northwind.dbo.Categories'
EXEC msdb.dbo.sp_send_dbmail 
 @profile_name = 'Profil_1', 
 @recipients = 'test@interia.pl', 
 @query = 'SELECT categoryid, categoryname 
FROM Northwind.dbo.Categories',
 @subject = 'Categories', 
 @attach_query_result_as_file = 1 ;
