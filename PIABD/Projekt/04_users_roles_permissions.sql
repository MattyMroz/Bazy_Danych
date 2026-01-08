-- ============================================================================
-- Projekt: Baza Danych Company (CrunchBase)
-- Autor: Mateusz Mróz (251190)
-- Data: 08.01.2026
-- Opis: Role, użytkownicy i uprawnienia (Contained Users)
-- ============================================================================

USE CompanyDB;
GO

-- ############################################################################
-- CZĘŚĆ 1: TWORZENIE RÓL
-- ############################################################################

PRINT '============================================';
PRINT 'Tworzenie ról...';
PRINT '============================================';

-- ============================================================================
-- Rola 1: Admin - Pełny dostęp do bazy danych
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'role_Admin' AND type = 'R')
BEGIN
    CREATE ROLE role_Admin;
    PRINT 'Utworzono rolę: role_Admin';
END
GO

-- Uprawnienia dla Admin - pełna kontrola
ALTER ROLE db_owner ADD MEMBER role_Admin;
GO

PRINT 'Rola role_Admin: db_owner (pełna kontrola)';
GO

-- ============================================================================
-- Rola 2: Employee (Emp) - Wykonywanie procedur
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'role_Employee' AND type = 'R')
BEGIN
    CREATE ROLE role_Employee;
    PRINT 'Utworzono rolę: role_Employee';
END
GO

-- Uprawnienia dla Employee - tylko wykonywanie procedur
GRANT EXECUTE ON SCHEMA::crunchbase TO role_Employee;
GO

-- Dostęp do odczytu dla tabel (potrzebny do procedur)
GRANT SELECT ON SCHEMA::crunchbase TO role_Employee;
GO

PRINT 'Rola role_Employee: EXECUTE + SELECT na schemacie crunchbase';
GO

-- ============================================================================
-- Rola 3: Guest - Tylko odczyt widoków
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'role_Guest' AND type = 'R')
BEGIN
    CREATE ROLE role_Guest;
    PRINT 'Utworzono rolę: role_Guest';
END
GO

-- Uprawnienia dla Guest - tylko odczyt widoków
-- Nadajemy uprawnienia SELECT tylko do konkretnych widoków
GRANT SELECT ON crunchbase.vw_CompanyOverview TO role_Guest;
GRANT SELECT ON crunchbase.vw_FundingByCategory TO role_Guest;
GRANT SELECT ON crunchbase.vw_TopInvestors TO role_Guest;
GRANT SELECT ON crunchbase.vw_PersonCompanyRelations TO role_Guest;
GRANT SELECT ON crunchbase.vw_AcquisitionHistory TO role_Guest;
GRANT SELECT ON crunchbase.vw_OfficeLocations TO role_Guest;
GO

PRINT 'Rola role_Guest: SELECT tylko na widokach';
GO

-- ############################################################################
-- CZĘŚĆ 2: TWORZENIE UŻYTKOWNIKÓW CONTAINED
-- ############################################################################

PRINT '';
PRINT '============================================';
PRINT 'Tworzenie użytkowników contained...';
PRINT '============================================';

-- ============================================================================
-- Użytkownik 1: Admin - Pełny dostęp
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'admin_user')
BEGIN
    CREATE USER admin_user WITH PASSWORD = 'Admin123!@#Strong';
    PRINT 'Utworzono użytkownika: admin_user';
END
GO

-- Przypisanie roli Admin
ALTER ROLE role_Admin ADD MEMBER admin_user;
GO

PRINT 'Użytkownik admin_user przypisany do roli role_Admin';
GO

-- ============================================================================
-- Użytkownik 2: Employee (Emp) - Wykonywanie procedur
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'emp_user')
BEGIN
    CREATE USER emp_user WITH PASSWORD = 'Emp456!@#Strong';
    PRINT 'Utworzono użytkownika: emp_user';
END
GO

-- Przypisanie roli Employee
ALTER ROLE role_Employee ADD MEMBER emp_user;
GO

PRINT 'Użytkownik emp_user przypisany do roli role_Employee';
GO

-- ============================================================================
-- Użytkownik 3: Guest - Tylko odczyt widoków
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'guest_user')
BEGIN
    CREATE USER guest_user WITH PASSWORD = 'Guest789!@#Strong';
    PRINT 'Utworzono użytkownika: guest_user';
END
GO

-- Przypisanie roli Guest
ALTER ROLE role_Guest ADD MEMBER guest_user;
GO

PRINT 'Użytkownik guest_user przypisany do roli role_Guest';
GO

-- ############################################################################
-- CZĘŚĆ 3: DODATKOWE ROLE SPECJALISTYCZNE
-- ############################################################################

PRINT '';
PRINT '============================================';
PRINT 'Tworzenie dodatkowych ról specjalistycznych...';
PRINT '============================================';

-- ============================================================================
-- Rola 4: DataAnalyst - Odczyt danych + wykonywanie funkcji
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'role_DataAnalyst' AND type = 'R')
BEGIN
    CREATE ROLE role_DataAnalyst;
    PRINT 'Utworzono rolę: role_DataAnalyst';
END
GO

-- Uprawnienia dla DataAnalyst
GRANT SELECT ON SCHEMA::crunchbase TO role_DataAnalyst;
GRANT EXECUTE ON SCHEMA::crunchbase TO role_DataAnalyst;
-- Brak uprawnień do INSERT, UPDATE, DELETE
GO

PRINT 'Rola role_DataAnalyst: SELECT + EXECUTE (bez modyfikacji danych)';
GO

-- ============================================================================
-- Rola 5: ReportViewer - Tylko widoki i raporty
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'role_ReportViewer' AND type = 'R')
BEGIN
    CREATE ROLE role_ReportViewer;
    PRINT 'Utworzono rolę: role_ReportViewer';
END
GO

-- Uprawnienia dla ReportViewer - widoki + procedura raportowa
GRANT SELECT ON crunchbase.vw_CompanyOverview TO role_ReportViewer;
GRANT SELECT ON crunchbase.vw_FundingByCategory TO role_ReportViewer;
GRANT SELECT ON crunchbase.vw_TopInvestors TO role_ReportViewer;
GRANT SELECT ON crunchbase.vw_PersonCompanyRelations TO role_ReportViewer;
GRANT SELECT ON crunchbase.vw_AcquisitionHistory TO role_ReportViewer;
GRANT SELECT ON crunchbase.vw_OfficeLocations TO role_ReportViewer;

-- Pozwolenie na wykonanie procedur raportowych
GRANT EXECUTE ON crunchbase.GetCompanyFundingReport TO role_ReportViewer;
GRANT EXECUTE ON crunchbase.SearchCompanies TO role_ReportViewer;
GO

PRINT 'Rola role_ReportViewer: SELECT na widokach + wybrane procedury raportowe';
GO

-- ============================================================================
-- Użytkownik: DataAnalyst
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'analyst_user')
BEGIN
    CREATE USER analyst_user WITH PASSWORD = 'Analyst123!@#Strong';
    PRINT 'Utworzono użytkownika: analyst_user';
END
GO

ALTER ROLE role_DataAnalyst ADD MEMBER analyst_user;
PRINT 'Użytkownik analyst_user przypisany do roli role_DataAnalyst';
GO

-- ============================================================================
-- Użytkownik: ReportViewer
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'report_user')
BEGIN
    CREATE USER report_user WITH PASSWORD = 'Report123!@#Strong';
    PRINT 'Utworzono użytkownika: report_user';
END
GO

ALTER ROLE role_ReportViewer ADD MEMBER report_user;
PRINT 'Użytkownik report_user przypisany do roli role_ReportViewer';
GO

-- ############################################################################
-- CZĘŚĆ 4: ODEBRANIE NIECHCIANYCH UPRAWNIEŃ
-- ############################################################################

PRINT '';
PRINT '============================================';
PRINT 'Konfiguracja zabezpieczeń...';
PRINT '============================================';

-- Odmowa bezpośredniego dostępu do tabel dla Guest
DENY SELECT ON crunchbase.Company TO role_Guest;
DENY SELECT ON crunchbase.Person TO role_Guest;
DENY SELECT ON crunchbase.FundingRound TO role_Guest;
DENY SELECT ON crunchbase.Investment TO role_Guest;
DENY INSERT, UPDATE, DELETE ON SCHEMA::crunchbase TO role_Guest;
GO

-- Odmowa modyfikacji dla ReportViewer
DENY INSERT, UPDATE, DELETE ON SCHEMA::crunchbase TO role_ReportViewer;
GO

-- Odmowa modyfikacji dla DataAnalyst
DENY INSERT, UPDATE, DELETE ON SCHEMA::crunchbase TO role_DataAnalyst;
GO

PRINT 'Zabezpieczenia skonfigurowane - ograniczenia dla ról tylko do odczytu';
GO

-- ############################################################################
-- CZĘŚĆ 5: PODSUMOWANIE
-- ############################################################################

PRINT '';
PRINT '============================================';
PRINT 'PODSUMOWANIE UŻYTKOWNIKÓW I RÓL';
PRINT '============================================';
PRINT '';

-- Wyświetlenie utworzonych ról
SELECT 
    name AS NazwaRoli,
    type_desc AS Typ,
    create_date AS DataUtworzenia
FROM sys.database_principals
WHERE type = 'R' AND name LIKE 'role_%'
ORDER BY name;

-- Wyświetlenie utworzonych użytkowników
SELECT 
    name AS NazwaUzytkownika,
    type_desc AS Typ,
    authentication_type_desc AS TypAutentykacji,
    create_date AS DataUtworzenia
FROM sys.database_principals
WHERE type = 'S' AND name IN ('admin_user', 'emp_user', 'guest_user', 'analyst_user', 'report_user')
ORDER BY name;

-- Wyświetlenie przypisań ról
SELECT 
    dp.name AS Uzytkownik,
    dp2.name AS Rola
FROM sys.database_role_members drm
INNER JOIN sys.database_principals dp ON dp.principal_id = drm.member_principal_id
INNER JOIN sys.database_principals dp2 ON dp2.principal_id = drm.role_principal_id
WHERE dp.name IN ('admin_user', 'emp_user', 'guest_user', 'analyst_user', 'report_user')
ORDER BY dp.name;
GO

PRINT '';
PRINT '============================================';
PRINT 'INSTRUKCJA LOGOWANIA';
PRINT '============================================';
PRINT '';
PRINT 'Aby zalogować się jako użytkownik contained:';
PRINT '';
PRINT '1. W SQL Server Management Studio:';
PRINT '   - Server: localhost (lub nazwa serwera)';
PRINT '   - Authentication: SQL Server Authentication';
PRINT '   - Login: admin_user / emp_user / guest_user';
PRINT '   - Password: (podane hasło)';
PRINT '   - Options -> Connection Properties -> Connect to database: CompanyDB';
PRINT '';
PRINT '2. W connection string:';
PRINT '   Server=localhost;Database=CompanyDB;User Id=admin_user;Password=Admin123!@#Strong;';
PRINT '';
PRINT '============================================';
PRINT 'UŻYTKOWNICY I HASŁA';
PRINT '============================================';
PRINT 'admin_user    : Admin123!@#Strong   (pełna kontrola)';
PRINT 'emp_user      : Emp456!@#Strong     (procedury + odczyt)';
PRINT 'guest_user    : Guest789!@#Strong   (tylko widoki)';
PRINT 'analyst_user  : Analyst123!@#Strong (analiza danych)';
PRINT 'report_user   : Report123!@#Strong  (raporty)';
PRINT '============================================';
GO

-- ############################################################################
-- CZĘŚĆ 6: TESTOWANIE UPRAWNIEŃ
-- ############################################################################

/*
-- ============================================================================
-- TESTY UPRAWNIEŃ (do wykonania po zalogowaniu jako dany użytkownik)
-- ============================================================================

-- TEST jako guest_user:
-- Powinno działać:
SELECT * FROM crunchbase.vw_CompanyOverview;
SELECT * FROM crunchbase.vw_FundingByCategory;

-- Powinno NIE działać (brak uprawnień):
SELECT * FROM crunchbase.Company;  -- DENIED
EXEC crunchbase.SearchCompanies;   -- DENIED
INSERT INTO crunchbase.Company (name, permalink) VALUES ('Test', 'test'); -- DENIED

-- ============================================================================
-- TEST jako emp_user:
-- Powinno działać:
SELECT * FROM crunchbase.Company;
EXEC crunchbase.SearchCompanies @search_name = 'Facebook';
EXEC crunchbase.GetCompanyFundingReport @company_id = 1;

-- ============================================================================
-- TEST jako admin_user:
-- Wszystko powinno działać:
SELECT * FROM crunchbase.Company;
INSERT INTO crunchbase.Company (name, permalink) VALUES ('TestCo', 'testco');
DELETE FROM crunchbase.Company WHERE name = 'TestCo';
EXEC crunchbase.AddCompany @name = 'NewCo', @permalink = 'newco', @new_company_id = NULL;
*/

-- ============================================================================
-- Procedura sprawdzająca uprawnienia użytkownika
-- ============================================================================
CREATE OR ALTER PROCEDURE crunchbase.CheckMyPermissions
AS
BEGIN
    SET NOCOUNT ON;
    
    PRINT 'Aktualny użytkownik: ' + USER_NAME();
    PRINT '';
    
    -- Uprawnienia do obiektów
    SELECT 
        OBJECT_NAME(major_id) AS ObiektNazwa,
        permission_name AS Uprawnienie,
        state_desc AS Stan
    FROM sys.database_permissions
    WHERE grantee_principal_id = DATABASE_PRINCIPAL_ID()
    AND major_id > 0
    ORDER BY OBJECT_NAME(major_id);
    
    -- Członkostwo w rolach
    SELECT 
        dp.name AS Rola
    FROM sys.database_role_members drm
    INNER JOIN sys.database_principals dp ON dp.principal_id = drm.role_principal_id
    WHERE drm.member_principal_id = DATABASE_PRINCIPAL_ID();
END
GO

-- Nadaj uprawnienia do wykonania procedury sprawdzającej
GRANT EXECUTE ON crunchbase.CheckMyPermissions TO PUBLIC;
GO

PRINT '';
PRINT 'Procedura crunchbase.CheckMyPermissions dostępna dla wszystkich użytkowników.';
PRINT 'Wywołanie: EXEC crunchbase.CheckMyPermissions;';
GO
