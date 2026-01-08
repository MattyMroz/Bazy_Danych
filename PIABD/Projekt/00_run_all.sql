-- ============================================================================
-- Projekt: Baza Danych Company (CrunchBase)
-- Autor: Mateusz Mróz (251190)
-- Data: 08.01.2026
-- Opis: Skrypt główny - uruchomienie wszystkich skryptów w kolejności
-- ============================================================================

/*
INSTRUKCJA UŻYCIA:
==================

1. Upewnij się, że masz zainstalowany Microsoft SQL Server 2019+ 
   z włączoną opcją contained database authentication.

2. Uruchom skrypty w następującej kolejności:
   
   a) 01_create_database.sql  - Tworzy bazę danych i tabele
   b) 02_import_data.sql      - Importuje dane z pliku JSON
   c) 03_procedures_functions_views_triggers.sql - Tworzy obiekty bazodanowe
   d) 04_users_roles_permissions.sql - Tworzy użytkowników i uprawnienia

3. Przed uruchomieniem skryptu importu danych (02), zmień ścieżkę do pliku JSON
   na właściwą dla swojego systemu.

WYMAGANIA WSTĘPNE:
==================
- SQL Server 2019 lub nowszy
- Uprawnienia sysadmin do tworzenia bazy danych
- Włączona opcja: sp_configure 'contained database authentication', 1

STRUKTURA PROJEKTU:
==================
PIABD/Projekt/
├── 01_create_database.sql              - Struktura bazy danych
├── 02_import_data.sql                  - Import danych JSON
├── 03_procedures_functions_views_triggers.sql - Obiekty bazy
├── 04_users_roles_permissions.sql      - Bezpieczeństwo
├── 00_run_all.sql                      - Ten plik (instrukcja)
├── companies documents 1-6.json        - Dane źródłowe
└── raport/
    ├── PLAN_PROJEKTU.md               - Plan projektu
    └── raport_PIABD.tex               - Raport LaTeX

*/

-- ============================================================================
-- KROK 0: Sprawdzenie wymagań wstępnych
-- ============================================================================

-- Sprawdzenie wersji SQL Server
SELECT @@VERSION AS 'Wersja SQL Server';

-- Sprawdzenie czy contained database authentication jest włączone
EXEC sp_configure 'contained database authentication';

-- Jeśli value = 0, uruchom:
-- EXEC sp_configure 'contained database authentication', 1;
-- RECONFIGURE;

-- ============================================================================
-- KROK 1: Tworzenie bazy danych
-- ============================================================================

PRINT '========================================';
PRINT 'KROK 1: Tworzenie bazy danych...';
PRINT '========================================';
PRINT 'Uruchom: 01_create_database.sql';
PRINT '';

-- :r "C:\Users\mateu\Desktop\PROJECTS\GitHub\Bazy_Danych\PIABD\Projekt\01_create_database.sql"

-- ============================================================================
-- KROK 2: Import danych
-- ============================================================================

PRINT '========================================';
PRINT 'KROK 2: Import danych z JSON...';
PRINT '========================================';
PRINT 'Uruchom: 02_import_data.sql';
PRINT 'UWAGA: Zmień ścieżkę do pliku JSON!';
PRINT '';

-- :r "C:\Users\mateu\Desktop\PROJECTS\GitHub\Bazy_Danych\PIABD\Projekt\02_import_data.sql"

-- ============================================================================
-- KROK 3: Tworzenie obiektów bazy danych
-- ============================================================================

PRINT '========================================';
PRINT 'KROK 3: Tworzenie procedur, funkcji...';
PRINT '========================================';
PRINT 'Uruchom: 03_procedures_functions_views_triggers.sql';
PRINT '';

-- :r "C:\Users\mateu\Desktop\PROJECTS\GitHub\Bazy_Danych\PIABD\Projekt\03_procedures_functions_views_triggers.sql"

-- ============================================================================
-- KROK 4: Tworzenie użytkowników i uprawnień
-- ============================================================================

PRINT '========================================';
PRINT 'KROK 4: Tworzenie użytkowników...';
PRINT '========================================';
PRINT 'Uruchom: 04_users_roles_permissions.sql';
PRINT '';

-- :r "C:\Users\mateu\Desktop\PROJECTS\GitHub\Bazy_Danych\PIABD\Projekt\04_users_roles_permissions.sql"

-- ============================================================================
-- KROK 5: Weryfikacja instalacji
-- ============================================================================

USE CompanyDB;
GO

PRINT '';
PRINT '========================================';
PRINT 'WERYFIKACJA INSTALACJI';
PRINT '========================================';
PRINT '';

-- Sprawdzenie tabel
SELECT 
    'Tabele' AS Kategoria,
    COUNT(*) AS Liczba
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'crunchbase' AND TABLE_TYPE = 'BASE TABLE'

UNION ALL

-- Sprawdzenie widoków
SELECT 
    'Widoki',
    COUNT(*)
FROM INFORMATION_SCHEMA.VIEWS 
WHERE TABLE_SCHEMA = 'crunchbase'

UNION ALL

-- Sprawdzenie procedur
SELECT 
    'Procedury',
    COUNT(*)
FROM INFORMATION_SCHEMA.ROUTINES 
WHERE ROUTINE_SCHEMA = 'crunchbase' AND ROUTINE_TYPE = 'PROCEDURE'

UNION ALL

-- Sprawdzenie funkcji
SELECT 
    'Funkcje',
    COUNT(*)
FROM INFORMATION_SCHEMA.ROUTINES 
WHERE ROUTINE_SCHEMA = 'crunchbase' AND ROUTINE_TYPE = 'FUNCTION'

UNION ALL

-- Sprawdzenie użytkowników
SELECT 
    'Użytkownicy contained',
    COUNT(*)
FROM sys.database_principals 
WHERE type = 'S' AND authentication_type = 2;

GO

-- Statystyki danych
PRINT '';
PRINT 'STATYSTYKI DANYCH:';
PRINT '';

SELECT 'Company' AS Tabela, COUNT(*) AS Rekordy FROM crunchbase.Company
UNION ALL SELECT 'Person', COUNT(*) FROM crunchbase.Person
UNION ALL SELECT 'FinancialOrg', COUNT(*) FROM crunchbase.FinancialOrg
UNION ALL SELECT 'FundingRound', COUNT(*) FROM crunchbase.FundingRound
UNION ALL SELECT 'Investment', COUNT(*) FROM crunchbase.Investment
UNION ALL SELECT 'Product', COUNT(*) FROM crunchbase.Product
UNION ALL SELECT 'Office', COUNT(*) FROM crunchbase.Office;
GO

PRINT '';
PRINT '========================================';
PRINT 'INSTALACJA ZAKOŃCZONA!';
PRINT '========================================';
PRINT '';
PRINT 'Możesz teraz korzystać z bazy danych CompanyDB.';
PRINT '';
PRINT 'Przykładowe zapytania:';
PRINT '  SELECT * FROM crunchbase.vw_CompanyOverview;';
PRINT '  EXEC crunchbase.SearchCompanies @search_name = ''Facebook'';';
PRINT '  EXEC crunchbase.GetCompanyFundingReport @company_id = 2;';
GO
