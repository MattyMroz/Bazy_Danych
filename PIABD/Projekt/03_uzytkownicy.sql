-- ============================================================================
-- Projekt: Baza Danych Company (CrunchBase)
-- Autor: Mateusz Mróz (251190)
-- Opis: Role i użytkownicy (contained users)
-- ============================================================================

USE CompanyDB;
GO

-- ============================================================================
-- ROLE
-- ============================================================================

-- Rola Admin - pełne uprawnienia
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'AdminRole')
    CREATE ROLE AdminRole;
GO

-- Rola Emp - wykonywanie procedur
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'EmpRole')
    CREATE ROLE EmpRole;
GO

-- Rola Guest - tylko odczyt widoków
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'GuestRole')
    CREATE ROLE GuestRole;
GO

-- ============================================================================
-- UPRAWNIENIA
-- ============================================================================

-- Admin - pełna kontrola
ALTER ROLE db_owner ADD MEMBER AdminRole;
GO

-- Emp - wykonywanie procedur, brak dostępu do tabel
GRANT EXECUTE ON SCHEMA::crunchbase TO EmpRole;
GO

-- Guest - tylko SELECT na widoku (bez DENY - domyslnie brak dostepu)
GRANT SELECT ON crunchbase.vw_CompanyOverview TO GuestRole;
GO

-- ============================================================================
-- UŻYTKOWNICY CONTAINED
-- ============================================================================

-- Admin
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Admin')
    CREATE USER Admin WITH PASSWORD = 'Admin';
ALTER ROLE AdminRole ADD MEMBER Admin;
GO

-- Emp
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Emp')
    CREATE USER Emp WITH PASSWORD = 'Emp';
ALTER ROLE EmpRole ADD MEMBER Emp;
GO

-- Guest
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Guest')
    CREATE USER Guest WITH PASSWORD = 'Guest';
ALTER ROLE GuestRole ADD MEMBER Guest;
GO

PRINT 'Uzytkownicy i role utworzone pomyslnie!';
PRINT '';
PRINT 'Logowanie jako contained user:';
PRINT '  Server: localhost';
PRINT '  Authentication: SQL Server Authentication';
PRINT '  Login: Admin / Emp / Guest';
PRINT '  Password: Admin / Emp / Guest';
PRINT '  Options -> Connect to database: CompanyDB';
GO
