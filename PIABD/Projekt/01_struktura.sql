-- ============================================================================
-- Projekt: Baza Danych Company (CrunchBase)
-- Autor: Mateusz Mróz (251190)
-- Przedmiot: PIABD
-- ============================================================================

-- Konfiguracja Contained Users
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'contained database authentication', 1;
RECONFIGURE;
GO

-- Usunięcie bazy jeśli istnieje
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'CompanyDB')
BEGIN
    ALTER DATABASE CompanyDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE CompanyDB;
END
GO

-- Utworzenie bazy z obsługą Contained Users
CREATE DATABASE CompanyDB CONTAINMENT = PARTIAL;
GO

USE CompanyDB;
GO

-- Schemat
CREATE SCHEMA crunchbase;
GO

-- ============================================================================
-- TABELE
-- ============================================================================

-- Company (Firma)
CREATE TABLE crunchbase.Company (
    company_id INT IDENTITY(1,1) PRIMARY KEY,
    mongo_id NVARCHAR(50) NOT NULL UNIQUE,
    name NVARCHAR(255) NOT NULL,
    permalink NVARCHAR(255) NOT NULL UNIQUE,
    crunchbase_url NVARCHAR(500) NULL,
    homepage_url NVARCHAR(500) NULL,
    blog_url NVARCHAR(500) NULL,
    blog_feed_url NVARCHAR(500) NULL,
    twitter_username NVARCHAR(100) NULL,
    category_code NVARCHAR(100) NULL,
    description NVARCHAR(MAX) NULL,
    overview NVARCHAR(MAX) NULL,
    number_of_employees INT NULL CHECK (number_of_employees >= 0),
    founded_year INT NULL,
    founded_month INT NULL CHECK (founded_month BETWEEN 1 AND 12),
    founded_day INT NULL CHECK (founded_day BETWEEN 1 AND 31),
    deadpooled_year INT NULL,
    deadpooled_month INT NULL,
    deadpooled_day INT NULL,
    deadpooled_url NVARCHAR(500) NULL,
    tag_list NVARCHAR(MAX) NULL,
    alias_list NVARCHAR(MAX) NULL,
    email_address NVARCHAR(255) NULL,
    phone_number NVARCHAR(50) NULL,
    total_money_raised NVARCHAR(50) NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO

-- Person (Osoba)
CREATE TABLE crunchbase.Person (
    person_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(100) NOT NULL,
    last_name NVARCHAR(100) NOT NULL,
    permalink NVARCHAR(255) NOT NULL UNIQUE
);
GO

-- FinancialOrg (Organizacja finansowa)
CREATE TABLE crunchbase.FinancialOrg (
    financial_org_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    permalink NVARCHAR(255) NOT NULL UNIQUE
);
GO

-- Product (Produkt)
CREATE TABLE crunchbase.Product (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    name NVARCHAR(255) NOT NULL,
    permalink NVARCHAR(255) NOT NULL,
    CONSTRAINT FK_Product_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE
);
GO

-- Office (Biuro)
CREATE TABLE crunchbase.Office (
    office_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    description NVARCHAR(500) NULL,
    address1 NVARCHAR(255) NULL,
    address2 NVARCHAR(255) NULL,
    zip_code NVARCHAR(20) NULL,
    city NVARCHAR(100) NULL,
    state_code NVARCHAR(10) NULL,
    country_code NVARCHAR(10) NULL,
    latitude DECIMAL(10, 7) NULL,
    longitude DECIMAL(10, 7) NULL,
    CONSTRAINT FK_Office_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE
);
GO

-- FundingRound (Runda finansowania)
CREATE TABLE crunchbase.FundingRound (
    funding_round_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    original_id INT NULL,
    round_code NVARCHAR(50) NULL,
    source_url NVARCHAR(500) NULL,
    source_description NVARCHAR(500) NULL,
    raised_amount DECIMAL(18, 2) NULL CHECK (raised_amount >= 0),
    raised_currency_code NVARCHAR(10) DEFAULT 'USD',
    funded_year INT NULL,
    funded_month INT NULL CHECK (funded_month BETWEEN 1 AND 12),
    funded_day INT NULL CHECK (funded_day BETWEEN 1 AND 31),
    CONSTRAINT FK_FundingRound_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE
);
GO

-- Investment (Inwestycja)
CREATE TABLE crunchbase.Investment (
    investment_id INT IDENTITY(1,1) PRIMARY KEY,
    funding_round_id INT NOT NULL,
    person_id INT NULL,
    financial_org_id INT NULL,
    investing_company_id INT NULL,
    CONSTRAINT FK_Investment_FundingRound FOREIGN KEY (funding_round_id) 
        REFERENCES crunchbase.FundingRound(funding_round_id) ON DELETE CASCADE,
    CONSTRAINT FK_Investment_Person FOREIGN KEY (person_id) 
        REFERENCES crunchbase.Person(person_id),
    CONSTRAINT FK_Investment_FinancialOrg FOREIGN KEY (financial_org_id) 
        REFERENCES crunchbase.FinancialOrg(financial_org_id),
    CONSTRAINT FK_Investment_Company FOREIGN KEY (investing_company_id) 
        REFERENCES crunchbase.Company(company_id)
);
GO

-- Acquisition (Przejęcie)
CREATE TABLE crunchbase.Acquisition (
    acquisition_id INT IDENTITY(1,1) PRIMARY KEY,
    acquiring_company_id INT NOT NULL,
    acquired_company_id INT NULL,
    acquired_company_name NVARCHAR(255) NULL,
    acquired_company_permalink NVARCHAR(255) NULL,
    price_amount DECIMAL(18, 2) NULL,
    price_currency_code NVARCHAR(10) DEFAULT 'USD',
    term_code NVARCHAR(50) NULL,
    source_url NVARCHAR(500) NULL,
    source_description NVARCHAR(500) NULL,
    acquired_year INT NULL,
    acquired_month INT NULL,
    acquired_day INT NULL,
    CONSTRAINT FK_Acquisition_AcquiringCompany FOREIGN KEY (acquiring_company_id) 
        REFERENCES crunchbase.Company(company_id),
    CONSTRAINT FK_Acquisition_AcquiredCompany FOREIGN KEY (acquired_company_id) 
        REFERENCES crunchbase.Company(company_id)
);
GO

-- Milestone (Kamień milowy)
CREATE TABLE crunchbase.Milestone (
    milestone_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    original_id INT NULL,
    description NVARCHAR(MAX) NULL,
    stoned_year INT NULL,
    stoned_month INT NULL,
    stoned_day INT NULL,
    source_url NVARCHAR(500) NULL,
    source_text NVARCHAR(MAX) NULL,
    source_description NVARCHAR(500) NULL,
    stoneable_type NVARCHAR(50) NULL,
    stoned_value NVARCHAR(100) NULL,
    stoned_value_type NVARCHAR(50) NULL,
    stoned_acquirer NVARCHAR(255) NULL,
    CONSTRAINT FK_Milestone_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE
);
GO

-- Competitor (Konkurent)
CREATE TABLE crunchbase.Competitor (
    competitor_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    competitor_company_id INT NULL,
    competitor_name NVARCHAR(255) NOT NULL,
    competitor_permalink NVARCHAR(255) NOT NULL,
    CONSTRAINT FK_Competitor_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE,
    CONSTRAINT FK_Competitor_CompetitorCompany FOREIGN KEY (competitor_company_id)
        REFERENCES crunchbase.Company(company_id),
    CONSTRAINT UQ_Competitor UNIQUE (company_id, competitor_permalink)
);
GO

-- CompanyRelationship (Relacja osoba-firma)
CREATE TABLE crunchbase.CompanyRelationship (
    relationship_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    person_id INT NOT NULL,
    title NVARCHAR(255) NULL,
    is_past BIT DEFAULT 0,
    CONSTRAINT FK_CompanyRelationship_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE,
    CONSTRAINT FK_CompanyRelationship_Person FOREIGN KEY (person_id) 
        REFERENCES crunchbase.Person(person_id) ON DELETE CASCADE
);
GO

-- ExternalLink (Link zewnętrzny)
CREATE TABLE crunchbase.ExternalLink (
    external_link_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    external_url NVARCHAR(1000) NOT NULL,
    title NVARCHAR(500) NULL,
    CONSTRAINT FK_ExternalLink_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE
);
GO

-- Screenshot (Zrzut ekranu)
CREATE TABLE crunchbase.Screenshot (
    screenshot_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    attribution NVARCHAR(500) NULL,
    CONSTRAINT FK_Screenshot_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE
);
GO

-- ScreenshotSize (Rozmiary zrzutów)
CREATE TABLE crunchbase.ScreenshotSize (
    screenshot_size_id INT IDENTITY(1,1) PRIMARY KEY,
    screenshot_id INT NOT NULL,
    width INT NULL,
    height INT NULL,
    image_path NVARCHAR(500) NOT NULL,
    CONSTRAINT FK_ScreenshotSize_Screenshot FOREIGN KEY (screenshot_id) 
        REFERENCES crunchbase.Screenshot(screenshot_id) ON DELETE CASCADE
);
GO

-- VideoEmbed (Osadzone wideo)
CREATE TABLE crunchbase.VideoEmbed (
    video_embed_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    embed_code NVARCHAR(MAX) NULL,
    description NVARCHAR(MAX) NULL,
    CONSTRAINT FK_VideoEmbed_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE
);
GO

-- Provider (Dostawca usług)
CREATE TABLE crunchbase.Provider (
    provider_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    provider_company_id INT NULL,
    provider_name NVARCHAR(255) NOT NULL,
    provider_permalink NVARCHAR(255) NOT NULL,
    title NVARCHAR(255) NULL,
    is_past BIT DEFAULT 0,
    CONSTRAINT FK_Provider_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE,
    CONSTRAINT FK_Provider_ProviderCompany FOREIGN KEY (provider_company_id) 
        REFERENCES crunchbase.Company(company_id)
);
GO

-- CompanyImage (Obrazy firmy)
CREATE TABLE crunchbase.CompanyImage (
    image_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    width INT NULL,
    height INT NULL,
    image_path NVARCHAR(500) NOT NULL,
    attribution NVARCHAR(500) NULL,
    CONSTRAINT FK_CompanyImage_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE
);
GO

-- CompanyIPO (IPO)
CREATE TABLE crunchbase.CompanyIPO (
    ipo_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL UNIQUE,
    valuation_amount DECIMAL(18, 2) NULL,
    valuation_currency_code NVARCHAR(10) DEFAULT 'USD',
    pub_year INT NULL,
    pub_month INT NULL,
    pub_day INT NULL,
    stock_symbol NVARCHAR(20) NULL,
    CONSTRAINT FK_CompanyIPO_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE
);
GO

-- ============================================================================
-- INDEKSY
-- ============================================================================

CREATE NONCLUSTERED INDEX IX_Company_Name ON crunchbase.Company(name);
CREATE NONCLUSTERED INDEX IX_Company_CategoryCode ON crunchbase.Company(category_code);
CREATE NONCLUSTERED INDEX IX_FundingRound_RoundCode ON crunchbase.FundingRound(round_code);
GO

PRINT 'Struktura bazy danych utworzona pomyslnie!';
GO
