------------------------------------------------------------------------------------------
-- Monitorowanie, Polityki, Audyt, Wersjonowanie, Maskowanie danych i błędy użytkownika --
------------------------------------------------------------------------------------------

-- 1. Monitorowanie liczby aktywnych transakcji i skonfigurowanie alertu (SQL Server:Transactions - licznik Transactions)
--    https://learn.microsoft.com/en-us/sql/relational-databases/performance-monitor/sql-server-transactions-object?view=sql-server-ver17
--    - Performance Monitor umożliwia graficzne śledzenie liczby aktywnych transakcji.
--    - DMVs pozwalają na bardziej szczegółową analizę stanu transakcji (sys.dm_tran_active_transactions)
--    https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-tran-active-transactions-transact-sql?view=sql-server-ver17
--    - Utwórz Alert (np. High Active Transactions), który automatycznie ostrzega o przekroczeniu ustalonego progu ilości transakcji np. >10 
--      (select occurrence_count,* FROM msdb.dbo.sysalerts)
--    https://learn.microsoft.com/en-us/ssms/agent/alerts

-- 2. Tworzenia polityki np. o nazwie 'Polish Collation_Policy' do wykrywania baz, które nie mają collation 'Polish_%'.
--    Tworzymy Condition o nazwie 'Check for Polish Collation' i wybieramy na poziomie bazy danych zmienną @collation like 'Polish%'
--    Wykonujemy ewaluacje i podajemy nazwy baz danych, które nie spełniają tego warunku.
--    https://learn.microsoft.com/en-us/sql/relational-databases/policy-based-management/administer-servers-by-using-policy-based-management?view=sql-server-ver17
--    Tutorial 1: https://learn.microsoft.com/en-us/sql/relational-databases/policy-based-management/lesson-1-create-and-apply-an-off-by-default-policy?view=sql-server-ver17
--    Tutorial 2: https://learn.microsoft.com/en-us/sql/relational-databases/policy-based-management/lesson-2-create-and-apply-a-naming-standards-policy?view=sql-server-ver17

-- 3. Utwórz mechanizm audytowania operacji tworzenia, usuwania oraz modyfikacji obiektów w bazie danych Northwind (Schema_Object_Change_Group) 
--    za pomocą mechanizmu Database Audit Specification. Audyt powinien rejestrować wszystkie te operacje wykonane na bazie Northwind, 
--    a wyniki audytu mają być przechowywane w plikach dziennika zdefiniowany na poziomie serwera - SQL Server Audit (Security | Audits) o nazwie Audit-01
--    np. w katalogu C:\TEMP\   
--    https://learn.microsoft.com/en-us/sql/relational-databases/security/auditing/sql-server-audit-database-engine?view=sql-server-ver17
--    https://learn.microsoft.com/en-us/sql/relational-databases/security/auditing/create-a-server-audit-and-server-audit-specification?view=sql-server-ver17

-- 4. Utwórz mechanizm wersjonowania danych w tabeli za pomocą temporal table w SQL Server. 
--    https://learn.microsoft.com/en-us/sql/relational-databases/tables/temporal-tables?view=sql-server-ver16
--    W bazie danych Northwind stwórz tabelę o nazwie ProductsTemporal w bazie Northwind, która będzie przechowywać dane o produktach 
--    (może być utworzona na podstawie pustej tabeli Products).
--    Skonfiguruj tabelę jako temporal table, aby SQL Server automatycznie przechowywał historię zmian w danych.
--    Dodaj, zmodyfikuj i usuń kilka rekordów w tabeli, aby wygenerować dane historyczne (czekamy 2-3 sekundy między operacjami).
--    Napisz zapytanie, które zwróci:
--		Wszystkie wersje rekordu dla konkretnego produktu.
--		Dane z tabeli historycznej dla wybranego zakresu czasu.
--              Aktualne dane.  
    
-- 5. Dynamiczne maskowanie danych
--    https://learn.microsoft.com/en-us/sql/relational-databases/security/dynamic-data-masking?view=sql-server-ver16
--    Wykonać i przeanalizować przykład podany w dokumentacji. 
--    Wyłączyć maskowanie dla jednej z kolumn i sprawdzić działanie.
--    Następnie zdefiniować ponownie to maskowanie i sprawdzić działanie.

-- 6. Definiowanie własnych błędów (błędów użytkownika)
--    https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-addmessage-transact-sql?view=sql-server-ver16
--    https://learn.microsoft.com/en-us/sql/t-sql/language-elements/raiserror-transact-sql?view=sql-server-ver16
--    Przeglądanie wszystkich błędów: select * from sys.messages
--    https://learn.microsoft.com/en-us/sql/relational-databases/errors-events/database-engine-error-severities?view=sql-server-ver16

--    Definicja własnego błędu o poziomie 16:
--    exec sp_addmessage 50007, 17 ,'MESSAGE', @with_log = 'TRUE'
--    go
--    Uruchomienie danego błędu
--    Raiserror(50007,16,1) with log
--    Sprawdzamy, gdzie ten błąd jest logowany.


-- 7. Zapytania do katalogu systemowego SQL Server — często zadawane pytania (zadanie do wykonania podane jest na końcu)
--    https://learn.microsoft.com/en-us/sql/relational-databases/system-catalog-views/querying-the-sql-server-system-catalog-faq?view=sql-server-ver16#_FAQ7

--    Jak znaleźć wszystkie tabele, które nie mają indeksu w bazie master?
--    USE master;  
--    GO  
--    SELECT SCHEMA_NAME(schema_id) AS schema_name, name AS table_name FROM sys.tables   
--    WHERE OBJECTPROPERTY(object_id,'IsIndexed') = 0  ORDER BY schema_name, table_name;  
--    GO

--   Czy można zdefiniowac Policy, która sprawdzi to samo co powyższe zapytanie? Jeśli tak to zdefiniuj taką politykę.  
  