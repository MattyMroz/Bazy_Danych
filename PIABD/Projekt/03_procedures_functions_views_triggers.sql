-- ============================================================================
-- Projekt: Baza Danych Company (CrunchBase)
-- Autor: Mateusz Mróz (251190)
-- Data: 08.01.2026
-- Opis: Procedury składowane, funkcje, widoki i triggery
-- ============================================================================

USE CompanyDB;
GO

-- ############################################################################
-- CZĘŚĆ 1: PROCEDURY SKŁADOWANE (STORED PROCEDURES)
-- ############################################################################

-- ============================================================================
-- Procedura 1: Dodawanie nowej firmy
-- ============================================================================
CREATE OR ALTER PROCEDURE crunchbase.AddCompany
    @name NVARCHAR(255),
    @permalink NVARCHAR(255),
    @category_code VARCHAR(100) = NULL,
    @description NVARCHAR(MAX) = NULL,
    @homepage_url NVARCHAR(500) = NULL,
    @number_of_employees INT = NULL,
    @founded_year INT = NULL,
    @founded_month INT = NULL,
    @founded_day INT = NULL,
    @email_address VARCHAR(255) = NULL,
    @phone_number VARCHAR(50) = NULL,
    @new_company_id INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Sprawdzenie czy firma o podanym permalink już istnieje
        IF EXISTS (SELECT 1 FROM crunchbase.Company WHERE permalink = @permalink)
        BEGIN
            RAISERROR('Firma o podanym permalink już istnieje!', 16, 1);
            RETURN;
        END
        
        -- Walidacja daty
        IF @founded_month IS NOT NULL AND (@founded_month < 1 OR @founded_month > 12)
        BEGIN
            RAISERROR('Nieprawidłowy miesiąc założenia (1-12)!', 16, 1);
            RETURN;
        END
        
        IF @founded_day IS NOT NULL AND (@founded_day < 1 OR @founded_day > 31)
        BEGIN
            RAISERROR('Nieprawidłowy dzień założenia (1-31)!', 16, 1);
            RETURN;
        END
        
        -- Wstawienie nowej firmy
        INSERT INTO crunchbase.Company (
            name, permalink, category_code, description, homepage_url,
            number_of_employees, founded_year, founded_month, founded_day,
            email_address, phone_number
        )
        VALUES (
            @name, @permalink, @category_code, @description, @homepage_url,
            @number_of_employees, @founded_year, @founded_month, @founded_day,
            @email_address, @phone_number
        );
        
        SET @new_company_id = SCOPE_IDENTITY();
        
        COMMIT TRANSACTION;
        PRINT 'Firma została dodana pomyślnie. ID: ' + CAST(@new_company_id AS VARCHAR(10));
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- ============================================================================
-- Procedura 2: Dodawanie rundy finansowania
-- ============================================================================
CREATE OR ALTER PROCEDURE crunchbase.AddFundingRound
    @company_id INT,
    @round_code VARCHAR(50),
    @raised_amount DECIMAL(18,2),
    @raised_currency_code VARCHAR(10) = 'USD',
    @funded_year INT = NULL,
    @funded_month INT = NULL,
    @funded_day INT = NULL,
    @source_url NVARCHAR(500) = NULL,
    @source_description NVARCHAR(500) = NULL,
    @new_funding_round_id INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Sprawdzenie czy firma istnieje
        IF NOT EXISTS (SELECT 1 FROM crunchbase.Company WHERE company_id = @company_id)
        BEGIN
            RAISERROR('Firma o podanym ID nie istnieje!', 16, 1);
            RETURN;
        END
        
        -- Walidacja kwoty
        IF @raised_amount < 0
        BEGIN
            RAISERROR('Kwota finansowania nie może być ujemna!', 16, 1);
            RETURN;
        END
        
        -- Wstawienie nowej rundy
        INSERT INTO crunchbase.FundingRound (
            company_id, round_code, raised_amount, raised_currency_code,
            funded_year, funded_month, funded_day, source_url, source_description
        )
        VALUES (
            @company_id, @round_code, @raised_amount, @raised_currency_code,
            @funded_year, @funded_month, @funded_day, @source_url, @source_description
        );
        
        SET @new_funding_round_id = SCOPE_IDENTITY();
        
        COMMIT TRANSACTION;
        PRINT 'Runda finansowania została dodana. ID: ' + CAST(@new_funding_round_id AS VARCHAR(10));
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- ============================================================================
-- Procedura 3: Aktualizacja danych firmy
-- ============================================================================
CREATE OR ALTER PROCEDURE crunchbase.UpdateCompany
    @company_id INT,
    @name NVARCHAR(255) = NULL,
    @description NVARCHAR(MAX) = NULL,
    @homepage_url NVARCHAR(500) = NULL,
    @number_of_employees INT = NULL,
    @email_address VARCHAR(255) = NULL,
    @phone_number VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Sprawdzenie czy firma istnieje
        IF NOT EXISTS (SELECT 1 FROM crunchbase.Company WHERE company_id = @company_id)
        BEGIN
            RAISERROR('Firma o podanym ID nie istnieje!', 16, 1);
            RETURN;
        END
        
        -- Aktualizacja tylko podanych pól (nie-NULL)
        UPDATE crunchbase.Company
        SET 
            name = ISNULL(@name, name),
            description = ISNULL(@description, description),
            homepage_url = ISNULL(@homepage_url, homepage_url),
            number_of_employees = ISNULL(@number_of_employees, number_of_employees),
            email_address = ISNULL(@email_address, email_address),
            phone_number = ISNULL(@phone_number, phone_number),
            updated_at = GETDATE()
        WHERE company_id = @company_id;
        
        PRINT 'Dane firmy zostały zaktualizowane.';
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

-- ============================================================================
-- Procedura 4: Wyszukiwanie firm według kryteriów
-- ============================================================================
CREATE OR ALTER PROCEDURE crunchbase.SearchCompanies
    @search_name NVARCHAR(255) = NULL,
    @category_code VARCHAR(100) = NULL,
    @min_employees INT = NULL,
    @max_employees INT = NULL,
    @founded_year_from INT = NULL,
    @founded_year_to INT = NULL,
    @has_funding BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        c.company_id,
        c.name,
        c.permalink,
        c.category_code,
        c.description,
        c.number_of_employees,
        c.founded_year,
        c.homepage_url,
        c.total_money_raised,
        (SELECT COUNT(*) FROM crunchbase.FundingRound fr WHERE fr.company_id = c.company_id) AS funding_rounds_count,
        (SELECT SUM(raised_amount) FROM crunchbase.FundingRound fr WHERE fr.company_id = c.company_id) AS total_funding
    FROM crunchbase.Company c
    WHERE 
        (@search_name IS NULL OR c.name LIKE '%' + @search_name + '%')
        AND (@category_code IS NULL OR c.category_code = @category_code)
        AND (@min_employees IS NULL OR c.number_of_employees >= @min_employees)
        AND (@max_employees IS NULL OR c.number_of_employees <= @max_employees)
        AND (@founded_year_from IS NULL OR c.founded_year >= @founded_year_from)
        AND (@founded_year_to IS NULL OR c.founded_year <= @founded_year_to)
        AND (@has_funding IS NULL OR 
            (@has_funding = 1 AND EXISTS (SELECT 1 FROM crunchbase.FundingRound fr WHERE fr.company_id = c.company_id))
            OR (@has_funding = 0 AND NOT EXISTS (SELECT 1 FROM crunchbase.FundingRound fr WHERE fr.company_id = c.company_id)))
    ORDER BY c.name;
END
GO

-- ============================================================================
-- Procedura 5: Raport finansowania firmy
-- ============================================================================
CREATE OR ALTER PROCEDURE crunchbase.GetCompanyFundingReport
    @company_id INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Sprawdzenie czy firma istnieje
    IF NOT EXISTS (SELECT 1 FROM crunchbase.Company WHERE company_id = @company_id)
    BEGIN
        RAISERROR('Firma o podanym ID nie istnieje!', 16, 1);
        RETURN;
    END
    
    -- Informacje o firmie
    SELECT 
        'INFORMACJE O FIRMIE' AS Sekcja,
        c.name AS Nazwa,
        c.category_code AS Kategoria,
        c.founded_year AS RokZalozenia,
        c.number_of_employees AS LiczbaPracownikow,
        c.total_money_raised AS CalkowitaKwotaZebranych
    FROM crunchbase.Company c
    WHERE c.company_id = @company_id;
    
    -- Rundy finansowania
    SELECT 
        fr.funding_round_id AS ID,
        fr.round_code AS TypRundy,
        fr.raised_amount AS Kwota,
        fr.raised_currency_code AS Waluta,
        CONCAT(fr.funded_year, '-', 
               RIGHT('0' + CAST(ISNULL(fr.funded_month, 1) AS VARCHAR(2)), 2), '-',
               RIGHT('0' + CAST(ISNULL(fr.funded_day, 1) AS VARCHAR(2)), 2)) AS DataFinansowania,
        fr.source_description AS Opis
    FROM crunchbase.FundingRound fr
    WHERE fr.company_id = @company_id
    ORDER BY fr.funded_year DESC, fr.funded_month DESC;
    
    -- Inwestorzy
    SELECT DISTINCT
        CASE 
            WHEN p.person_id IS NOT NULL THEN 'Osoba'
            WHEN fo.financial_org_id IS NOT NULL THEN 'Organizacja finansowa'
            WHEN ic.company_id IS NOT NULL THEN 'Firma'
        END AS TypInwestora,
        COALESCE(
            CONCAT(p.first_name, ' ', p.last_name),
            fo.name,
            ic.name
        ) AS NazwaInwestora
    FROM crunchbase.FundingRound fr
    INNER JOIN crunchbase.Investment inv ON inv.funding_round_id = fr.funding_round_id
    LEFT JOIN crunchbase.Person p ON p.person_id = inv.person_id
    LEFT JOIN crunchbase.FinancialOrg fo ON fo.financial_org_id = inv.financial_org_id
    LEFT JOIN crunchbase.Company ic ON ic.company_id = inv.investing_company_id
    WHERE fr.company_id = @company_id;
    
    -- Podsumowanie
    SELECT 
        COUNT(*) AS LiczbaRund,
        SUM(raised_amount) AS SumaFinansowania,
        AVG(raised_amount) AS SredniaKwotaRundy,
        MIN(raised_amount) AS MinimalnaKwota,
        MAX(raised_amount) AS MaksymalnaKwota
    FROM crunchbase.FundingRound
    WHERE company_id = @company_id;
END
GO

-- ############################################################################
-- CZĘŚĆ 2: FUNKCJE (FUNCTIONS)
-- ############################################################################

-- ============================================================================
-- Funkcja skalarna 1: Obliczanie całkowitego finansowania firmy
-- ============================================================================
CREATE OR ALTER FUNCTION crunchbase.GetTotalFunding(@company_id INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @total DECIMAL(18,2);
    
    SELECT @total = ISNULL(SUM(raised_amount), 0)
    FROM crunchbase.FundingRound
    WHERE company_id = @company_id;
    
    RETURN @total;
END
GO

-- ============================================================================
-- Funkcja skalarna 2: Obliczanie wieku firmy
-- ============================================================================
CREATE OR ALTER FUNCTION crunchbase.GetCompanyAge(@company_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @age INT;
    DECLARE @founded_year INT;
    
    SELECT @founded_year = founded_year
    FROM crunchbase.Company
    WHERE company_id = @company_id;
    
    IF @founded_year IS NULL
        SET @age = NULL;
    ELSE
        SET @age = YEAR(GETDATE()) - @founded_year;
    
    RETURN @age;
END
GO

-- ============================================================================
-- Funkcja skalarna 3: Liczba pracowników firmy (jako tekst)
-- ============================================================================
CREATE OR ALTER FUNCTION crunchbase.GetEmployeeRange(@company_id INT)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @employees INT;
    DECLARE @range VARCHAR(50);
    
    SELECT @employees = number_of_employees
    FROM crunchbase.Company
    WHERE company_id = @company_id;
    
    IF @employees IS NULL
        SET @range = 'Nieznana';
    ELSE IF @employees <= 10
        SET @range = 'Mała (1-10)';
    ELSE IF @employees <= 50
        SET @range = 'Mała-Średnia (11-50)';
    ELSE IF @employees <= 200
        SET @range = 'Średnia (51-200)';
    ELSE IF @employees <= 1000
        SET @range = 'Duża (201-1000)';
    ELSE
        SET @range = 'Korporacja (1000+)';
    
    RETURN @range;
END
GO

-- ============================================================================
-- Funkcja tabelaryczna 1: Lista pracowników firmy (osób powiązanych)
-- ============================================================================
CREATE OR ALTER FUNCTION crunchbase.GetCompanyPeople(@company_id INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.person_id,
        p.first_name,
        p.last_name,
        p.permalink,
        cr.title AS Stanowisko,
        CASE WHEN cr.is_past = 1 THEN 'Tak' ELSE 'Nie' END AS CzyBylePracownik
    FROM crunchbase.CompanyRelationship cr
    INNER JOIN crunchbase.Person p ON p.person_id = cr.person_id
    WHERE cr.company_id = @company_id
);
GO

-- ============================================================================
-- Funkcja tabelaryczna 2: Rundy finansowania z inwestorami
-- ============================================================================
CREATE OR ALTER FUNCTION crunchbase.GetFundingRoundsWithInvestors(@company_id INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        fr.funding_round_id,
        fr.round_code,
        fr.raised_amount,
        fr.raised_currency_code,
        fr.funded_year,
        fr.funded_month,
        COALESCE(
            CONCAT(p.first_name, ' ', p.last_name),
            fo.name,
            ic.name
        ) AS InwestorNazwa,
        CASE 
            WHEN p.person_id IS NOT NULL THEN 'Osoba'
            WHEN fo.financial_org_id IS NOT NULL THEN 'Organizacja'
            WHEN ic.company_id IS NOT NULL THEN 'Firma'
        END AS InwestorTyp
    FROM crunchbase.FundingRound fr
    LEFT JOIN crunchbase.Investment inv ON inv.funding_round_id = fr.funding_round_id
    LEFT JOIN crunchbase.Person p ON p.person_id = inv.person_id
    LEFT JOIN crunchbase.FinancialOrg fo ON fo.financial_org_id = inv.financial_org_id
    LEFT JOIN crunchbase.Company ic ON ic.company_id = inv.investing_company_id
    WHERE fr.company_id = @company_id
);
GO

-- ============================================================================
-- Funkcja tabelaryczna 3: Wyszukiwanie firm według finansowania
-- ============================================================================
CREATE OR ALTER FUNCTION crunchbase.GetCompaniesByFundingRange(
    @min_funding DECIMAL(18,2),
    @max_funding DECIMAL(18,2)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        c.company_id,
        c.name,
        c.category_code,
        c.founded_year,
        crunchbase.GetTotalFunding(c.company_id) AS total_funding,
        crunchbase.GetEmployeeRange(c.company_id) AS employee_range
    FROM crunchbase.Company c
    WHERE crunchbase.GetTotalFunding(c.company_id) BETWEEN @min_funding AND @max_funding
);
GO

-- ############################################################################
-- CZĘŚĆ 3: WIDOKI (VIEWS)
-- ############################################################################

-- ============================================================================
-- Widok 1: Przegląd firm z podstawowymi statystykami
-- ============================================================================
CREATE OR ALTER VIEW crunchbase.vw_CompanyOverview
AS
SELECT 
    c.company_id,
    c.name AS Nazwa,
    c.permalink,
    c.category_code AS Kategoria,
    c.description AS Opis,
    c.homepage_url AS StronaWWW,
    c.number_of_employees AS LiczbaPracownikow,
    crunchbase.GetEmployeeRange(c.company_id) AS ZakresPracownikow,
    c.founded_year AS RokZalozenia,
    crunchbase.GetCompanyAge(c.company_id) AS WiekFirmy,
    c.total_money_raised AS ZebraneFinansowanie,
    crunchbase.GetTotalFunding(c.company_id) AS CalkowiteFinansowanieZRund,
    (SELECT COUNT(*) FROM crunchbase.FundingRound fr WHERE fr.company_id = c.company_id) AS LiczbaRundFinansowania,
    (SELECT COUNT(*) FROM crunchbase.Product p WHERE p.company_id = c.company_id) AS LiczbaProdukow,
    (SELECT COUNT(*) FROM crunchbase.Office o WHERE o.company_id = c.company_id) AS LiczbaBiur,
    (SELECT COUNT(*) FROM crunchbase.CompanyRelationship cr WHERE cr.company_id = c.company_id) AS LiczbaOsob,
    (SELECT COUNT(*) FROM crunchbase.Acquisition acq WHERE acq.acquiring_company_id = c.company_id) AS LiczbaPrzejec,
    c.created_at AS DataDodania,
    c.updated_at AS DataAktualizacji
FROM crunchbase.Company c;
GO

-- ============================================================================
-- Widok 2: Statystyki finansowania według kategorii
-- ============================================================================
CREATE OR ALTER VIEW crunchbase.vw_FundingByCategory
AS
SELECT 
    c.category_code AS Kategoria,
    COUNT(DISTINCT c.company_id) AS LiczbaFirm,
    COUNT(fr.funding_round_id) AS LiczbaRund,
    SUM(fr.raised_amount) AS SumaFinansowania,
    AVG(fr.raised_amount) AS SredniaKwotaRundy,
    MIN(fr.raised_amount) AS MinimalnaKwota,
    MAX(fr.raised_amount) AS MaksymalnaKwota
FROM crunchbase.Company c
LEFT JOIN crunchbase.FundingRound fr ON fr.company_id = c.company_id
WHERE c.category_code IS NOT NULL
GROUP BY c.category_code;
GO

-- ============================================================================
-- Widok 3: Najbardziej aktywni inwestorzy
-- ============================================================================
CREATE OR ALTER VIEW crunchbase.vw_TopInvestors
AS
SELECT 
    InvestorType,
    InvestorName,
    InvestorPermalink,
    InvestmentCount,
    TotalCompaniesInvested
FROM (
    -- Osoby
    SELECT 
        'Osoba' AS InvestorType,
        CONCAT(p.first_name, ' ', p.last_name) AS InvestorName,
        p.permalink AS InvestorPermalink,
        COUNT(*) AS InvestmentCount,
        COUNT(DISTINCT fr.company_id) AS TotalCompaniesInvested
    FROM crunchbase.Investment inv
    INNER JOIN crunchbase.Person p ON p.person_id = inv.person_id
    INNER JOIN crunchbase.FundingRound fr ON fr.funding_round_id = inv.funding_round_id
    GROUP BY p.person_id, p.first_name, p.last_name, p.permalink
    
    UNION ALL
    
    -- Organizacje finansowe
    SELECT 
        'Organizacja finansowa' AS InvestorType,
        fo.name AS InvestorName,
        fo.permalink AS InvestorPermalink,
        COUNT(*) AS InvestmentCount,
        COUNT(DISTINCT fr.company_id) AS TotalCompaniesInvested
    FROM crunchbase.Investment inv
    INNER JOIN crunchbase.FinancialOrg fo ON fo.financial_org_id = inv.financial_org_id
    INNER JOIN crunchbase.FundingRound fr ON fr.funding_round_id = inv.funding_round_id
    GROUP BY fo.financial_org_id, fo.name, fo.permalink
    
    UNION ALL
    
    -- Firmy inwestujące
    SELECT 
        'Firma' AS InvestorType,
        ic.name AS InvestorName,
        ic.permalink AS InvestorPermalink,
        COUNT(*) AS InvestmentCount,
        COUNT(DISTINCT fr.company_id) AS TotalCompaniesInvested
    FROM crunchbase.Investment inv
    INNER JOIN crunchbase.Company ic ON ic.company_id = inv.investing_company_id
    INNER JOIN crunchbase.FundingRound fr ON fr.funding_round_id = inv.funding_round_id
    GROUP BY ic.company_id, ic.name, ic.permalink
) AS AllInvestors;
GO

-- ============================================================================
-- Widok 4: Przegląd osób i ich powiązań z firmami
-- ============================================================================
CREATE OR ALTER VIEW crunchbase.vw_PersonCompanyRelations
AS
SELECT 
    p.person_id,
    p.first_name AS Imie,
    p.last_name AS Nazwisko,
    p.permalink,
    c.name AS NazwaFirmy,
    c.category_code AS KategoriaFirmy,
    cr.title AS Stanowisko,
    CASE WHEN cr.is_past = 1 THEN 'Były pracownik' ELSE 'Aktualny' END AS Status,
    (SELECT COUNT(*) FROM crunchbase.CompanyRelationship cr2 WHERE cr2.person_id = p.person_id) AS LiczbaFirmPowiazanych,
    (SELECT COUNT(*) FROM crunchbase.Investment inv WHERE inv.person_id = p.person_id) AS LiczbaInwestycji
FROM crunchbase.Person p
INNER JOIN crunchbase.CompanyRelationship cr ON cr.person_id = p.person_id
INNER JOIN crunchbase.Company c ON c.company_id = cr.company_id;
GO

-- ============================================================================
-- Widok 5: Historia przejęć
-- ============================================================================
CREATE OR ALTER VIEW crunchbase.vw_AcquisitionHistory
AS
SELECT 
    acq.acquisition_id,
    acquiring.name AS FirmaPrzejmujaca,
    acquiring.category_code AS KategoriaPrzejmujaca,
    COALESCE(acquired.name, acq.acquired_company_name) AS FirmaPrzejeta,
    acq.acquired_company_permalink,
    acq.price_amount AS Cena,
    acq.price_currency_code AS Waluta,
    acq.term_code AS WarunkiTransakcji,
    CONCAT(acq.acquired_year, '-', 
           RIGHT('0' + CAST(ISNULL(acq.acquired_month, 1) AS VARCHAR(2)), 2), '-',
           RIGHT('0' + CAST(ISNULL(acq.acquired_day, 1) AS VARCHAR(2)), 2)) AS DataPrzejecia,
    acq.source_description AS Opis
FROM crunchbase.Acquisition acq
LEFT JOIN crunchbase.Company acquiring ON acquiring.company_id = acq.acquiring_company_id
LEFT JOIN crunchbase.Company acquired ON acquired.company_id = acq.acquired_company_id;
GO

-- ============================================================================
-- Widok 6: Lokalizacje biur firm
-- ============================================================================
CREATE OR ALTER VIEW crunchbase.vw_OfficeLocations
AS
SELECT 
    c.company_id,
    c.name AS NazwaFirmy,
    c.category_code AS Kategoria,
    o.description AS OpisBiura,
    o.address1 AS Adres1,
    o.address2 AS Adres2,
    o.city AS Miasto,
    o.state_code AS KodStanu,
    o.country_code AS KodKraju,
    o.zip_code AS KodPocztowy,
    o.latitude AS Szerokosc,
    o.longitude AS Dlugosc
FROM crunchbase.Company c
INNER JOIN crunchbase.Office o ON o.company_id = c.company_id;
GO

-- ############################################################################
-- CZĘŚĆ 4: TRIGGERY
-- ############################################################################

-- ============================================================================
-- Trigger 1: Automatyczna aktualizacja updated_at przy modyfikacji Company
-- ============================================================================
CREATE OR ALTER TRIGGER crunchbase.trg_Company_UpdateTimestamp
ON crunchbase.Company
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Aktualizacja znacznika czasu tylko jeśli nie został jawnie ustawiony
    UPDATE crunchbase.Company
    SET updated_at = GETDATE()
    FROM crunchbase.Company c
    INNER JOIN inserted i ON c.company_id = i.company_id
    WHERE c.updated_at = i.updated_at; -- tylko jeśli nie zmieniono ręcznie
END
GO

-- ============================================================================
-- Trigger 2: Logowanie zmian w finansowaniu (audit trail)
-- ============================================================================

-- Tabela audytu dla rund finansowania
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'FundingRound_Audit' AND schema_id = SCHEMA_ID('crunchbase'))
BEGIN
    CREATE TABLE crunchbase.FundingRound_Audit (
        audit_id INT IDENTITY(1,1) PRIMARY KEY,
        funding_round_id INT NOT NULL,
        company_id INT NOT NULL,
        action_type VARCHAR(10) NOT NULL, -- INSERT, UPDATE, DELETE
        old_raised_amount DECIMAL(18,2) NULL,
        new_raised_amount DECIMAL(18,2) NULL,
        old_round_code VARCHAR(50) NULL,
        new_round_code VARCHAR(50) NULL,
        changed_by NVARCHAR(128) DEFAULT SYSTEM_USER,
        changed_at DATETIME DEFAULT GETDATE()
    );
END
GO

CREATE OR ALTER TRIGGER crunchbase.trg_FundingRound_Audit
ON crunchbase.FundingRound
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- INSERT
    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO crunchbase.FundingRound_Audit (
            funding_round_id, company_id, action_type, 
            new_raised_amount, new_round_code
        )
        SELECT 
            funding_round_id, company_id, 'INSERT',
            raised_amount, round_code
        FROM inserted;
    END
    
    -- UPDATE
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO crunchbase.FundingRound_Audit (
            funding_round_id, company_id, action_type,
            old_raised_amount, new_raised_amount,
            old_round_code, new_round_code
        )
        SELECT 
            i.funding_round_id, i.company_id, 'UPDATE',
            d.raised_amount, i.raised_amount,
            d.round_code, i.round_code
        FROM inserted i
        INNER JOIN deleted d ON i.funding_round_id = d.funding_round_id;
    END
    
    -- DELETE
    IF NOT EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO crunchbase.FundingRound_Audit (
            funding_round_id, company_id, action_type,
            old_raised_amount, old_round_code
        )
        SELECT 
            funding_round_id, company_id, 'DELETE',
            raised_amount, round_code
        FROM deleted;
    END
END
GO

-- ============================================================================
-- Trigger 3: Walidacja przy dodawaniu inwestycji
-- ============================================================================
CREATE OR ALTER TRIGGER crunchbase.trg_Investment_Validate
ON crunchbase.Investment
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Sprawdzenie czy przynajmniej jeden inwestor jest podany
    IF EXISTS (
        SELECT 1 FROM inserted 
        WHERE person_id IS NULL 
          AND financial_org_id IS NULL 
          AND investing_company_id IS NULL
    )
    BEGIN
        RAISERROR('Inwestycja musi mieć przypisanego co najmniej jednego inwestora (osobę, organizację lub firmę)!', 16, 1);
        RETURN;
    END
    
    -- Sprawdzenie czy runda finansowania istnieje
    IF EXISTS (
        SELECT 1 FROM inserted i
        WHERE NOT EXISTS (
            SELECT 1 FROM crunchbase.FundingRound fr 
            WHERE fr.funding_round_id = i.funding_round_id
        )
    )
    BEGIN
        RAISERROR('Podana runda finansowania nie istnieje!', 16, 1);
        RETURN;
    END
    
    -- Wstawienie zatwierdzonych rekordów
    INSERT INTO crunchbase.Investment (
        funding_round_id, person_id, financial_org_id, investing_company_id
    )
    SELECT 
        funding_round_id, person_id, financial_org_id, investing_company_id
    FROM inserted;
END
GO

-- ============================================================================
-- Trigger 4: Aktualizacja total_money_raised po zmianie w FundingRound
-- ============================================================================
CREATE OR ALTER TRIGGER crunchbase.trg_FundingRound_UpdateTotalMoney
ON crunchbase.FundingRound
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Zbieramy wszystkie dotknięte company_id
    DECLARE @affected_companies TABLE (company_id INT);
    
    INSERT INTO @affected_companies (company_id)
    SELECT DISTINCT company_id FROM inserted
    UNION
    SELECT DISTINCT company_id FROM deleted;
    
    -- Aktualizujemy total_money_raised dla każdej dotkniętej firmy
    UPDATE crunchbase.Company
    SET total_money_raised = (
        SELECT CONCAT('$', FORMAT(ISNULL(SUM(fr.raised_amount), 0), 'N0'))
        FROM crunchbase.FundingRound fr
        WHERE fr.company_id = c.company_id
    )
    FROM crunchbase.Company c
    INNER JOIN @affected_companies ac ON ac.company_id = c.company_id;
END
GO

-- ############################################################################
-- CZĘŚĆ 5: PRZYKŁADY UŻYCIA
-- ############################################################################

PRINT '============================================';
PRINT 'Obiekty bazy danych zostały utworzone!';
PRINT '============================================';
PRINT '';
PRINT 'PROCEDURY SKŁADOWANE:';
PRINT '  - crunchbase.AddCompany';
PRINT '  - crunchbase.AddFundingRound';
PRINT '  - crunchbase.UpdateCompany';
PRINT '  - crunchbase.SearchCompanies';
PRINT '  - crunchbase.GetCompanyFundingReport';
PRINT '';
PRINT 'FUNKCJE:';
PRINT '  - crunchbase.GetTotalFunding (skalarna)';
PRINT '  - crunchbase.GetCompanyAge (skalarna)';
PRINT '  - crunchbase.GetEmployeeRange (skalarna)';
PRINT '  - crunchbase.GetCompanyPeople (tabelaryczna)';
PRINT '  - crunchbase.GetFundingRoundsWithInvestors (tabelaryczna)';
PRINT '  - crunchbase.GetCompaniesByFundingRange (tabelaryczna)';
PRINT '';
PRINT 'WIDOKI:';
PRINT '  - crunchbase.vw_CompanyOverview';
PRINT '  - crunchbase.vw_FundingByCategory';
PRINT '  - crunchbase.vw_TopInvestors';
PRINT '  - crunchbase.vw_PersonCompanyRelations';
PRINT '  - crunchbase.vw_AcquisitionHistory';
PRINT '  - crunchbase.vw_OfficeLocations';
PRINT '';
PRINT 'TRIGGERY:';
PRINT '  - crunchbase.trg_Company_UpdateTimestamp';
PRINT '  - crunchbase.trg_FundingRound_Audit';
PRINT '  - crunchbase.trg_Investment_Validate';
PRINT '  - crunchbase.trg_FundingRound_UpdateTotalMoney';
PRINT '';
GO

-- ============================================================================
-- PRZYKŁADY WYWOŁAŃ (zakomentowane - do testowania)
-- ============================================================================

/*
-- Przykład: Wyszukiwanie firm
EXEC crunchbase.SearchCompanies @search_name = 'Facebook';
EXEC crunchbase.SearchCompanies @category_code = 'web', @has_funding = 1;

-- Przykład: Raport finansowania
EXEC crunchbase.GetCompanyFundingReport @company_id = 1;

-- Przykład: Użycie funkcji
SELECT crunchbase.GetTotalFunding(1) AS TotalFunding;
SELECT crunchbase.GetCompanyAge(1) AS CompanyAge;
SELECT * FROM crunchbase.GetCompanyPeople(1);

-- Przykład: Użycie widoków
SELECT * FROM crunchbase.vw_CompanyOverview;
SELECT * FROM crunchbase.vw_FundingByCategory;
SELECT * FROM crunchbase.vw_TopInvestors ORDER BY InvestmentCount DESC;

-- Przykład: Dodawanie nowej firmy
DECLARE @new_id INT;
EXEC crunchbase.AddCompany 
    @name = 'TestCompany',
    @permalink = 'testcompany',
    @category_code = 'web',
    @founded_year = 2024,
    @new_company_id = @new_id OUTPUT;
SELECT @new_id AS NewCompanyID;
*/
