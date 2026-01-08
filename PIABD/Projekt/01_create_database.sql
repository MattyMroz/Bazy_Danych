-- ============================================================================
-- Projekt: Baza Danych Company (CrunchBase)
-- Autor: Mateusz Mróz (251190)
-- Data: 08.01.2026
-- Przedmiot: Projektowanie i Administracja Baz Danych (PIABD)
-- Opis: Skrypt tworzący strukturę bazy danych Company
-- ============================================================================

-- Włączenie obsługi Contained Users (wymagane dla użytkowników lokalnych)
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'contained database authentication', 1;
RECONFIGURE;
GO

-- ============================================================================
-- KROK 1: Tworzenie bazy danych
-- ============================================================================

-- Usunięcie bazy jeśli istnieje (dla celów testowych)
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'CompanyDB')
BEGIN
    ALTER DATABASE CompanyDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE CompanyDB;
END
GO

-- Utworzenie bazy danych z obsługą Contained Users
CREATE DATABASE CompanyDB
    CONTAINMENT = PARTIAL;
GO

-- Przełączenie na utworzoną bazę
USE CompanyDB;
GO

-- ============================================================================
-- KROK 2: Tworzenie schematu
-- ============================================================================

-- Schemat dla obiektów biznesowych
CREATE SCHEMA crunchbase;
GO

-- Dodanie opisu schematu
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Schemat zawierający tabele związane z danymi firm z CrunchBase', 
    @level0type = N'SCHEMA', 
    @level0name = N'crunchbase';
GO

-- ============================================================================
-- KROK 3: Tworzenie tabel
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Tabela: Company (Firma) - główna tabela
-- Opis: Przechowuje podstawowe informacje o firmach
-- ----------------------------------------------------------------------------
CREATE TABLE crunchbase.Company (
    -- Klucz główny
    company_id INT IDENTITY(1,1) PRIMARY KEY,
    
    -- Identyfikator z MongoDB (oryginalny _id)
    mongo_id NVARCHAR(50) NOT NULL UNIQUE,
    
    -- Podstawowe dane firmy
    name NVARCHAR(255) NOT NULL,
    permalink NVARCHAR(255) NOT NULL UNIQUE,
    
    -- URLs
    crunchbase_url NVARCHAR(500) NULL,
    homepage_url NVARCHAR(500) NULL,
    blog_url NVARCHAR(500) NULL,
    blog_feed_url NVARCHAR(500) NULL,
    
    -- Social media
    twitter_username NVARCHAR(100) NULL,
    
    -- Kategoria i opis
    category_code NVARCHAR(100) NULL,
    description NVARCHAR(MAX) NULL,
    overview NVARCHAR(MAX) NULL,
    
    -- Dane liczbowe
    number_of_employees INT NULL CHECK (number_of_employees >= 0 OR number_of_employees IS NULL),
    
    -- Daty założenia (jako osobne pola - bo mogą być niepełne)
    founded_year INT NULL CHECK (founded_year >= 1800 AND founded_year <= 2100 OR founded_year IS NULL),
    founded_month INT NULL CHECK (founded_month >= 1 AND founded_month <= 12 OR founded_month IS NULL),
    founded_day INT NULL CHECK (founded_day >= 1 AND founded_day <= 31 OR founded_day IS NULL),
    
    -- Daty zamknięcia firmy (deadpool)
    deadpooled_year INT NULL,
    deadpooled_month INT NULL,
    deadpooled_day INT NULL,
    deadpooled_url NVARCHAR(500) NULL,
    
    -- Tagi i aliasy (zachowane jako string - celowa denormalizacja)
    tag_list NVARCHAR(MAX) NULL,
    alias_list NVARCHAR(MAX) NULL,
    
    -- Dane kontaktowe
    email_address NVARCHAR(255) NULL,
    phone_number NVARCHAR(50) NULL,
    
    -- Finansowanie
    total_money_raised NVARCHAR(50) NULL,
    
    -- Metadane
    created_at DATETIME2 NULL DEFAULT GETDATE(),
    updated_at DATETIME2 NULL DEFAULT GETDATE()
);
GO

-- Opis tabeli Company
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Główna tabela przechowująca dane firm z CrunchBase. Zawiera podstawowe informacje, daty założenia/zamknięcia, dane kontaktowe i finansowe.', 
    @level0type = N'SCHEMA', @level0name = N'crunchbase',
    @level1type = N'TABLE', @level1name = N'Company';
GO

-- ----------------------------------------------------------------------------
-- Tabela: Person (Osoba)
-- Opis: Pracownicy, założyciele, inwestorzy indywidualni
-- ----------------------------------------------------------------------------
CREATE TABLE crunchbase.Person (
    person_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(100) NOT NULL,
    last_name NVARCHAR(100) NOT NULL,
    permalink NVARCHAR(255) NOT NULL UNIQUE,
    
    -- Metadane
    created_at DATETIME2 DEFAULT GETDATE()
);
GO

EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Tabela przechowująca osoby (pracownicy, założyciele, inwestorzy indywidualni)', 
    @level0type = N'SCHEMA', @level0name = N'crunchbase',
    @level1type = N'TABLE', @level1name = N'Person';
GO

-- ----------------------------------------------------------------------------
-- Tabela: FinancialOrg (Organizacja finansowa)
-- Opis: Fundusze VC, banki inwestycyjne itp.
-- ----------------------------------------------------------------------------
CREATE TABLE crunchbase.FinancialOrg (
    financial_org_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    permalink NVARCHAR(255) NOT NULL UNIQUE,
    
    created_at DATETIME2 DEFAULT GETDATE()
);
GO

EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Tabela przechowująca organizacje finansowe (fundusze VC, banki inwestycyjne)', 
    @level0type = N'SCHEMA', @level0name = N'crunchbase',
    @level1type = N'TABLE', @level1name = N'FinancialOrg';
GO

-- ----------------------------------------------------------------------------
-- Tabela: Product (Produkt)
-- Opis: Produkty oferowane przez firmy
-- ----------------------------------------------------------------------------
CREATE TABLE crunchbase.Product (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    name NVARCHAR(255) NOT NULL,
    permalink NVARCHAR(255) NOT NULL,
    
    CONSTRAINT FK_Product_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE
);
GO

EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Tabela przechowująca produkty firm', 
    @level0type = N'SCHEMA', @level0name = N'crunchbase',
    @level1type = N'TABLE', @level1name = N'Product';
GO

-- ----------------------------------------------------------------------------
-- Tabela: Office (Biuro)
-- Opis: Lokalizacje biur firm
-- ----------------------------------------------------------------------------
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
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE,
    
    -- Sprawdzenie poprawności współrzędnych geograficznych
    CONSTRAINT CHK_Office_Latitude CHECK (latitude IS NULL OR (latitude >= -90 AND latitude <= 90)),
    CONSTRAINT CHK_Office_Longitude CHECK (longitude IS NULL OR (longitude >= -180 AND longitude <= 180))
);
GO

EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Tabela przechowująca lokalizacje biur firm', 
    @level0type = N'SCHEMA', @level0name = N'crunchbase',
    @level1type = N'TABLE', @level1name = N'Office';
GO

-- ----------------------------------------------------------------------------
-- Tabela: FundingRound (Runda finansowania)
-- Opis: Rundy pozyskiwania kapitału przez firmy
-- ----------------------------------------------------------------------------
CREATE TABLE crunchbase.FundingRound (
    funding_round_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    
    -- Oryginalny ID z JSON
    original_id INT NULL,
    
    -- Typ rundy (seed, a, b, c, angel, debt_round, etc.)
    round_code NVARCHAR(50) NULL,
    
    -- Źródło informacji
    source_url NVARCHAR(500) NULL,
    source_description NVARCHAR(500) NULL,
    
    -- Kwota pozyskana
    raised_amount DECIMAL(18, 2) NULL CHECK (raised_amount >= 0 OR raised_amount IS NULL),
    raised_currency_code NVARCHAR(10) NULL DEFAULT 'USD',
    
    -- Data finansowania
    funded_year INT NULL,
    funded_month INT NULL CHECK (funded_month >= 1 AND funded_month <= 12 OR funded_month IS NULL),
    funded_day INT NULL CHECK (funded_day >= 1 AND funded_day <= 31 OR funded_day IS NULL),
    
    CONSTRAINT FK_FundingRound_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE
);
GO

EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Tabela przechowująca rundy finansowania firm (seed, Series A, B, C, etc.)', 
    @level0type = N'SCHEMA', @level0name = N'crunchbase',
    @level1type = N'TABLE', @level1name = N'FundingRound';
GO

-- ----------------------------------------------------------------------------
-- Tabela: Investment (Inwestycja)
-- Opis: Pojedyncze inwestycje w rundach finansowania
-- ----------------------------------------------------------------------------
CREATE TABLE crunchbase.Investment (
    investment_id INT IDENTITY(1,1) PRIMARY KEY,
    funding_round_id INT NOT NULL,
    
    -- Inwestor może być osobą, organizacją finansową lub firmą
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
        REFERENCES crunchbase.Company(company_id),
    
    -- Przynajmniej jeden typ inwestora musi być określony
    CONSTRAINT CHK_Investment_Investor CHECK (
        person_id IS NOT NULL OR 
        financial_org_id IS NOT NULL OR 
        investing_company_id IS NOT NULL
    )
);
GO

EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Tabela przechowująca pojedyncze inwestycje w rundach finansowania', 
    @level0type = N'SCHEMA', @level0name = N'crunchbase',
    @level1type = N'TABLE', @level1name = N'Investment';
GO

-- ----------------------------------------------------------------------------
-- Tabela: Acquisition (Przejęcie)
-- Opis: Przejęcia firm
-- ----------------------------------------------------------------------------
CREATE TABLE crunchbase.Acquisition (
    acquisition_id INT IDENTITY(1,1) PRIMARY KEY,
    
    -- Firma przejmująca
    acquiring_company_id INT NOT NULL,
    
    -- Firma przejmowana (może być w naszej bazie lub nie)
    acquired_company_id INT NULL,
    acquired_company_name NVARCHAR(255) NULL,
    acquired_company_permalink NVARCHAR(255) NULL,
    
    -- Szczegóły transakcji
    price_amount DECIMAL(18, 2) NULL CHECK (price_amount >= 0 OR price_amount IS NULL),
    price_currency_code NVARCHAR(10) NULL DEFAULT 'USD',
    term_code NVARCHAR(50) NULL, -- cash, stock, cash_and_stock
    
    -- Źródło informacji
    source_url NVARCHAR(500) NULL,
    source_description NVARCHAR(500) NULL,
    
    -- Data przejęcia
    acquired_year INT NULL,
    acquired_month INT NULL,
    acquired_day INT NULL,
    
    CONSTRAINT FK_Acquisition_AcquiringCompany FOREIGN KEY (acquiring_company_id) 
        REFERENCES crunchbase.Company(company_id),
    CONSTRAINT FK_Acquisition_AcquiredCompany FOREIGN KEY (acquired_company_id) 
        REFERENCES crunchbase.Company(company_id)
);
GO

EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Tabela przechowująca informacje o przejęciach firm', 
    @level0type = N'SCHEMA', @level0name = N'crunchbase',
    @level1type = N'TABLE', @level1name = N'Acquisition';
GO

-- ----------------------------------------------------------------------------
-- Tabela: Milestone (Kamień milowy)
-- Opis: Ważne wydarzenia w historii firmy
-- ----------------------------------------------------------------------------
CREATE TABLE crunchbase.Milestone (
    milestone_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    
    original_id INT NULL,
    description NVARCHAR(MAX) NULL,
    
    -- Data wydarzenia
    stoned_year INT NULL,
    stoned_month INT NULL,
    stoned_day INT NULL,
    
    -- Źródło informacji
    source_url NVARCHAR(500) NULL,
    source_text NVARCHAR(MAX) NULL,
    source_description NVARCHAR(500) NULL,
    
    -- Dodatkowe pola
    stoneable_type NVARCHAR(50) NULL,
    stoned_value NVARCHAR(100) NULL,
    stoned_value_type NVARCHAR(50) NULL,
    stoned_acquirer NVARCHAR(255) NULL,
    
    CONSTRAINT FK_Milestone_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE
);
GO

EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Tabela przechowująca kamienie milowe (ważne wydarzenia) firm', 
    @level0type = N'SCHEMA', @level0name = N'crunchbase',
    @level1type = N'TABLE', @level1name = N'Milestone';
GO

-- ----------------------------------------------------------------------------
-- Tabela: Competitor (Konkurent) - relacja M:N między firmami
-- Opis: Powiązania konkurencyjne między firmami
-- ----------------------------------------------------------------------------
CREATE TABLE crunchbase.Competitor (
    competitor_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    
    -- Konkurent może być w bazie lub nie
    competitor_company_id INT NULL,
    competitor_name NVARCHAR(255) NOT NULL,
    competitor_permalink NVARCHAR(255) NOT NULL,
    
    CONSTRAINT FK_Competitor_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE,
    CONSTRAINT FK_Competitor_CompetitorCompany FOREIGN KEY (competitor_company_id) 
        REFERENCES crunchbase.Company(company_id),
    
    -- Unikalna para firma-konkurent
    CONSTRAINT UQ_Competitor UNIQUE (company_id, competitor_permalink)
);
GO

EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Tabela przechowująca relacje konkurencyjne między firmami', 
    @level0type = N'SCHEMA', @level0name = N'crunchbase',
    @level1type = N'TABLE', @level1name = N'Competitor';
GO

-- ----------------------------------------------------------------------------
-- Tabela: CompanyRelationship (Relacja osoba-firma)
-- Opis: Powiązania osób z firmami (pracownicy, członkowie zarządu)
-- ----------------------------------------------------------------------------
CREATE TABLE crunchbase.CompanyRelationship (
    relationship_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    person_id INT NOT NULL,
    
    -- Stanowisko/rola
    title NVARCHAR(255) NULL,
    
    -- Czy to przeszłe stanowisko
    is_past BIT NOT NULL DEFAULT 0,
    
    CONSTRAINT FK_CompanyRelationship_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE,
    CONSTRAINT FK_CompanyRelationship_Person FOREIGN KEY (person_id) 
        REFERENCES crunchbase.Person(person_id) ON DELETE CASCADE
);
GO

EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Tabela przechowująca relacje osób z firmami (pracownicy, członkowie zarządu)', 
    @level0type = N'SCHEMA', @level0name = N'crunchbase',
    @level1type = N'TABLE', @level1name = N'CompanyRelationship';
GO

-- ----------------------------------------------------------------------------
-- Tabela: ExternalLink (Link zewnętrzny)
-- Opis: Linki do artykułów i stron zewnętrznych
-- ----------------------------------------------------------------------------
CREATE TABLE crunchbase.ExternalLink (
    external_link_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    
    external_url NVARCHAR(1000) NOT NULL,
    title NVARCHAR(500) NULL,
    
    CONSTRAINT FK_ExternalLink_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE
);
GO

EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Tabela przechowująca linki zewnętrzne powiązane z firmami', 
    @level0type = N'SCHEMA', @level0name = N'crunchbase',
    @level1type = N'TABLE', @level1name = N'ExternalLink';
GO

-- ----------------------------------------------------------------------------
-- Tabela: Screenshot (Zrzut ekranu)
-- Opis: Zrzuty ekranu stron firmowych
-- ----------------------------------------------------------------------------
CREATE TABLE crunchbase.Screenshot (
    screenshot_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    
    attribution NVARCHAR(500) NULL,
    
    CONSTRAINT FK_Screenshot_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE
);
GO

-- ----------------------------------------------------------------------------
-- Tabela: ScreenshotSize (Rozmiary zrzutów ekranu)
-- Opis: Różne rozmiary jednego zrzutu ekranu
-- ----------------------------------------------------------------------------
CREATE TABLE crunchbase.ScreenshotSize (
    screenshot_size_id INT IDENTITY(1,1) PRIMARY KEY,
    screenshot_id INT NOT NULL,
    
    width INT NULL CHECK (width > 0),
    height INT NULL CHECK (height > 0),
    image_path NVARCHAR(500) NOT NULL,
    
    CONSTRAINT FK_ScreenshotSize_Screenshot FOREIGN KEY (screenshot_id) 
        REFERENCES crunchbase.Screenshot(screenshot_id) ON DELETE CASCADE
);
GO

-- ----------------------------------------------------------------------------
-- Tabela: VideoEmbed (Osadzone wideo)
-- Opis: Filmy powiązane z firmami
-- ----------------------------------------------------------------------------
CREATE TABLE crunchbase.VideoEmbed (
    video_embed_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    
    embed_code NVARCHAR(MAX) NULL,
    description NVARCHAR(MAX) NULL,
    
    CONSTRAINT FK_VideoEmbed_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE
);
GO

EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Tabela przechowująca osadzone filmy powiązane z firmami', 
    @level0type = N'SCHEMA', @level0name = N'crunchbase',
    @level1type = N'TABLE', @level1name = N'VideoEmbed';
GO

-- ----------------------------------------------------------------------------
-- Tabela: Provider (Dostawca usług)
-- Opis: Firmy świadczące usługi dla innych firm
-- ----------------------------------------------------------------------------
CREATE TABLE crunchbase.Provider (
    provider_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    
    -- Dostawca może być w bazie lub nie
    provider_company_id INT NULL,
    provider_name NVARCHAR(255) NOT NULL,
    provider_permalink NVARCHAR(255) NOT NULL,
    
    title NVARCHAR(255) NULL,
    is_past BIT NOT NULL DEFAULT 0,
    
    CONSTRAINT FK_Provider_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE,
    CONSTRAINT FK_Provider_ProviderCompany FOREIGN KEY (provider_company_id) 
        REFERENCES crunchbase.Company(company_id)
);
GO

EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Tabela przechowująca informacje o dostawcach usług dla firm', 
    @level0type = N'SCHEMA', @level0name = N'crunchbase',
    @level1type = N'TABLE', @level1name = N'Provider';
GO

-- ----------------------------------------------------------------------------
-- Tabela: CompanyImage (Obrazy firmy)
-- Opis: Logo i inne obrazy firm w różnych rozmiarach
-- ----------------------------------------------------------------------------
CREATE TABLE crunchbase.CompanyImage (
    image_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    
    width INT NULL CHECK (width > 0),
    height INT NULL CHECK (height > 0),
    image_path NVARCHAR(500) NOT NULL,
    attribution NVARCHAR(500) NULL,
    
    CONSTRAINT FK_CompanyImage_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE
);
GO

EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Tabela przechowująca obrazy (logo) firm w różnych rozmiarach', 
    @level0type = N'SCHEMA', @level0name = N'crunchbase',
    @level1type = N'TABLE', @level1name = N'CompanyImage';
GO

-- ----------------------------------------------------------------------------
-- Tabela: CompanyIPO (IPO - oferta publiczna)
-- Opis: Informacje o wejściach firm na giełdę
-- ----------------------------------------------------------------------------
CREATE TABLE crunchbase.CompanyIPO (
    ipo_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL UNIQUE,
    
    valuation_amount DECIMAL(18, 2) NULL,
    valuation_currency_code NVARCHAR(10) NULL DEFAULT 'USD',
    
    pub_year INT NULL,
    pub_month INT NULL,
    pub_day INT NULL,
    
    stock_symbol NVARCHAR(20) NULL,
    
    CONSTRAINT FK_CompanyIPO_Company FOREIGN KEY (company_id) 
        REFERENCES crunchbase.Company(company_id) ON DELETE CASCADE
);
GO

EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Tabela przechowująca informacje o IPO (wejściu na giełdę) firm', 
    @level0type = N'SCHEMA', @level0name = N'crunchbase',
    @level1type = N'TABLE', @level1name = N'CompanyIPO';
GO

-- ============================================================================
-- KROK 4: Tworzenie indeksów
-- ============================================================================

-- Indeks na nazwie firmy (częste wyszukiwanie)
CREATE NONCLUSTERED INDEX IX_Company_Name 
ON crunchbase.Company(name);
GO

-- Indeks na kategorii (filtrowanie po kategorii)
CREATE NONCLUSTERED INDEX IX_Company_CategoryCode 
ON crunchbase.Company(category_code);
GO

-- Indeks na roku założenia (filtrowanie po dacie)
CREATE NONCLUSTERED INDEX IX_Company_FoundedYear 
ON crunchbase.Company(founded_year);
GO

-- Indeks na nazwisku osoby (wyszukiwanie)
CREATE NONCLUSTERED INDEX IX_Person_LastName 
ON crunchbase.Person(last_name);
GO

-- Indeks na typie rundy finansowania
CREATE NONCLUSTERED INDEX IX_FundingRound_RoundCode 
ON crunchbase.FundingRound(round_code);
GO

-- Indeks na kwocie finansowania
CREATE NONCLUSTERED INDEX IX_FundingRound_RaisedAmount 
ON crunchbase.FundingRound(raised_amount DESC);
GO

-- Indeks na mieście biura
CREATE NONCLUSTERED INDEX IX_Office_City 
ON crunchbase.Office(city);
GO

PRINT 'Struktura bazy danych została utworzona pomyślnie!';
GO
