-- ============================================================================
-- Projekt: Baza Danych Company (CrunchBase)
-- Autor: Mateusz Mróz (251190)
-- Opis: Obiekty bazy danych (procedura, funkcja, widok)
-- ============================================================================

USE CompanyDB;
GO

-- ============================================================================
-- PROCEDURA SKŁADOWANA - Wstawianie/aktualizacja firmy
-- ============================================================================
CREATE OR ALTER PROCEDURE crunchbase.UpsertCompany
    @mongo_id NVARCHAR(50),
    @name NVARCHAR(255),
    @permalink NVARCHAR(255),
    @category_code NVARCHAR(100) = NULL,
    @description NVARCHAR(MAX) = NULL,
    @number_of_employees INT = NULL,
    @founded_year INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM crunchbase.Company WHERE mongo_id = @mongo_id)
    BEGIN
        UPDATE crunchbase.Company
        SET name = @name,
            category_code = @category_code,
            description = @description,
            number_of_employees = @number_of_employees,
            founded_year = @founded_year,
            updated_at = GETDATE()
        WHERE mongo_id = @mongo_id;

        PRINT 'Firma zaktualizowana: ' + @name;
    END
    ELSE
    BEGIN
        INSERT INTO crunchbase.Company (mongo_id, name, permalink, category_code, 
                                        description, number_of_employees, founded_year)
        VALUES (@mongo_id, @name, @permalink, @category_code, 
                @description, @number_of_employees, @founded_year);

        PRINT 'Firma dodana: ' + @name;
    END
END
GO

-- ============================================================================
-- FUNKCJA - Obliczanie sumy finansowania firmy
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
-- WIDOK - Przegląd firm z podstawowymi danymi
-- ============================================================================
CREATE OR ALTER VIEW crunchbase.vw_CompanyOverview
AS
SELECT
    c.company_id,
    c.name,
    c.category_code,
    c.founded_year,
    c.number_of_employees,
    c.homepage_url,
    crunchbase.GetTotalFunding(c.company_id) AS total_funding,
    (SELECT COUNT(*) FROM crunchbase.FundingRound fr WHERE fr.company_id = c.company_id) AS funding_rounds_count,
    (SELECT COUNT(*) FROM crunchbase.Product p WHERE p.company_id = c.company_id) AS products_count
FROM crunchbase.Company c;
GO

PRINT 'Obiekty bazy danych utworzone pomyslnie!';
GO
