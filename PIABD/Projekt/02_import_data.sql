-- ============================================================================
-- Projekt: Baza Danych Company (CrunchBase)
-- Autor: Mateusz Mróz (251190)
-- Data: 08.01.2026
-- Opis: Skrypt importujący dane z pliku JSON do bazy danych
-- ============================================================================

USE CompanyDB;
GO

-- ============================================================================
-- KROK 1: Wczytanie pliku JSON
-- ============================================================================

-- Deklaracja zmiennej do przechowywania JSON
DECLARE @JSON NVARCHAR(MAX);

-- Wczytanie pliku JSON z dysku
-- UWAGA: Zmień ścieżkę na właściwą dla swojego systemu!
SET @JSON = (
    SELECT BulkColumn 
    FROM OPENROWSET(
        BULK 'C:\Users\mateu\Desktop\PROJECTS\GitHub\Bazy_Danych\PIABD\Projekt\companies documents 1-6.json', 
        SINGLE_CLOB
    ) AS j
);

-- Sprawdzenie czy JSON został wczytany
IF @JSON IS NULL
BEGIN
    RAISERROR('Błąd: Nie udało się wczytać pliku JSON!', 16, 1);
    RETURN;
END

PRINT 'Plik JSON wczytany pomyślnie. Rozpoczynam import danych...';
GO

-- ============================================================================
-- KROK 2: Import danych - Procedura główna
-- ============================================================================

-- Tworzymy procedurę do importu dla łatwiejszego zarządzania
CREATE OR ALTER PROCEDURE crunchbase.ImportFromJSON
    @JSONPath NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @JSON NVARCHAR(MAX);
    DECLARE @ErrorMessage NVARCHAR(4000);
    
    BEGIN TRY
        -- Wczytanie JSON z pliku
        DECLARE @SQL NVARCHAR(MAX) = N'
            SELECT @JSONOut = BulkColumn 
            FROM OPENROWSET(BULK ''' + @JSONPath + ''', SINGLE_CLOB) AS j';
        
        EXEC sp_executesql @SQL, N'@JSONOut NVARCHAR(MAX) OUTPUT', @JSONOut = @JSON OUTPUT;
        
        IF @JSON IS NULL
        BEGIN
            RAISERROR('Nie udało się wczytać pliku JSON!', 16, 1);
            RETURN;
        END
        
        PRINT 'JSON wczytany. Rozpoczynam import...';
        
        -- ====================================================================
        -- Import Company (Firmy)
        -- ====================================================================
        PRINT 'Importowanie firm...';
        
        INSERT INTO crunchbase.Company (
            mongo_id, name, permalink, crunchbase_url, homepage_url,
            blog_url, blog_feed_url, twitter_username, category_code,
            description, overview, number_of_employees,
            founded_year, founded_month, founded_day,
            deadpooled_year, deadpooled_month, deadpooled_day, deadpooled_url,
            tag_list, alias_list, email_address, phone_number,
            total_money_raised
        )
        SELECT 
            JSON_VALUE(company.value, '$._id."$oid"') AS mongo_id,
            JSON_VALUE(company.value, '$.name') AS name,
            JSON_VALUE(company.value, '$.permalink') AS permalink,
            JSON_VALUE(company.value, '$.crunchbase_url') AS crunchbase_url,
            JSON_VALUE(company.value, '$.homepage_url') AS homepage_url,
            JSON_VALUE(company.value, '$.blog_url') AS blog_url,
            JSON_VALUE(company.value, '$.blog_feed_url') AS blog_feed_url,
            JSON_VALUE(company.value, '$.twitter_username') AS twitter_username,
            JSON_VALUE(company.value, '$.category_code') AS category_code,
            JSON_VALUE(company.value, '$.description') AS description,
            JSON_VALUE(company.value, '$.overview') AS overview,
            TRY_CAST(JSON_VALUE(company.value, '$.number_of_employees') AS INT) AS number_of_employees,
            TRY_CAST(JSON_VALUE(company.value, '$.founded_year') AS INT) AS founded_year,
            TRY_CAST(JSON_VALUE(company.value, '$.founded_month') AS INT) AS founded_month,
            TRY_CAST(JSON_VALUE(company.value, '$.founded_day') AS INT) AS founded_day,
            TRY_CAST(JSON_VALUE(company.value, '$.deadpooled_year') AS INT) AS deadpooled_year,
            TRY_CAST(JSON_VALUE(company.value, '$.deadpooled_month') AS INT) AS deadpooled_month,
            TRY_CAST(JSON_VALUE(company.value, '$.deadpooled_day') AS INT) AS deadpooled_day,
            JSON_VALUE(company.value, '$.deadpooled_url') AS deadpooled_url,
            JSON_VALUE(company.value, '$.tag_list') AS tag_list,
            JSON_VALUE(company.value, '$.alias_list') AS alias_list,
            JSON_VALUE(company.value, '$.email_address') AS email_address,
            JSON_VALUE(company.value, '$.phone_number') AS phone_number,
            JSON_VALUE(company.value, '$.total_money_raised') AS total_money_raised
        FROM OPENJSON(@JSON) AS company
        WHERE NOT EXISTS (
            SELECT 1 FROM crunchbase.Company c 
            WHERE c.mongo_id = JSON_VALUE(company.value, '$._id."$oid"')
        );
        
        PRINT CONCAT('Zaimportowano firm: ', @@ROWCOUNT);
        
        -- ====================================================================
        -- Import Person (Osoby) - z relationships i investments
        -- ====================================================================
        PRINT 'Importowanie osób...';
        
        -- Osoby z relationships
        INSERT INTO crunchbase.Person (first_name, last_name, permalink)
        SELECT DISTINCT
            JSON_VALUE(rel.value, '$.person.first_name') AS first_name,
            JSON_VALUE(rel.value, '$.person.last_name') AS last_name,
            JSON_VALUE(rel.value, '$.person.permalink') AS permalink
        FROM OPENJSON(@JSON) AS company
        CROSS APPLY OPENJSON(company.value, '$.relationships') AS rel
        WHERE JSON_VALUE(rel.value, '$.person.permalink') IS NOT NULL
        AND NOT EXISTS (
            SELECT 1 FROM crunchbase.Person p 
            WHERE p.permalink = JSON_VALUE(rel.value, '$.person.permalink')
        );
        
        -- Osoby z funding_rounds.investments
        INSERT INTO crunchbase.Person (first_name, last_name, permalink)
        SELECT DISTINCT
            JSON_VALUE(inv.value, '$.person.first_name') AS first_name,
            JSON_VALUE(inv.value, '$.person.last_name') AS last_name,
            JSON_VALUE(inv.value, '$.person.permalink') AS permalink
        FROM OPENJSON(@JSON) AS company
        CROSS APPLY OPENJSON(company.value, '$.funding_rounds') AS fr
        CROSS APPLY OPENJSON(fr.value, '$.investments') AS inv
        WHERE JSON_VALUE(inv.value, '$.person.permalink') IS NOT NULL
        AND NOT EXISTS (
            SELECT 1 FROM crunchbase.Person p 
            WHERE p.permalink = JSON_VALUE(inv.value, '$.person.permalink')
        );
        
        PRINT CONCAT('Zaimportowano osób: ', (SELECT COUNT(*) FROM crunchbase.Person));
        
        -- ====================================================================
        -- Import FinancialOrg (Organizacje finansowe)
        -- ====================================================================
        PRINT 'Importowanie organizacji finansowych...';
        
        INSERT INTO crunchbase.FinancialOrg (name, permalink)
        SELECT DISTINCT
            JSON_VALUE(inv.value, '$.financial_org.name') AS name,
            JSON_VALUE(inv.value, '$.financial_org.permalink') AS permalink
        FROM OPENJSON(@JSON) AS company
        CROSS APPLY OPENJSON(company.value, '$.funding_rounds') AS fr
        CROSS APPLY OPENJSON(fr.value, '$.investments') AS inv
        WHERE JSON_VALUE(inv.value, '$.financial_org.permalink') IS NOT NULL
        AND NOT EXISTS (
            SELECT 1 FROM crunchbase.FinancialOrg fo 
            WHERE fo.permalink = JSON_VALUE(inv.value, '$.financial_org.permalink')
        );
        
        PRINT CONCAT('Zaimportowano organizacji finansowych: ', (SELECT COUNT(*) FROM crunchbase.FinancialOrg));
        
        -- ====================================================================
        -- Import Product (Produkty)
        -- ====================================================================
        PRINT 'Importowanie produktów...';
        
        INSERT INTO crunchbase.Product (company_id, name, permalink)
        SELECT 
            c.company_id,
            JSON_VALUE(prod.value, '$.name') AS name,
            JSON_VALUE(prod.value, '$.permalink') AS permalink
        FROM OPENJSON(@JSON) AS company
        CROSS APPLY OPENJSON(company.value, '$.products') AS prod
        INNER JOIN crunchbase.Company c 
            ON c.mongo_id = JSON_VALUE(company.value, '$._id."$oid"')
        WHERE JSON_VALUE(prod.value, '$.name') IS NOT NULL;
        
        PRINT CONCAT('Zaimportowano produktów: ', @@ROWCOUNT);
        
        -- ====================================================================
        -- Import Office (Biura)
        -- ====================================================================
        PRINT 'Importowanie biur...';
        
        INSERT INTO crunchbase.Office (
            company_id, description, address1, address2, zip_code,
            city, state_code, country_code, latitude, longitude
        )
        SELECT 
            c.company_id,
            JSON_VALUE(office.value, '$.description') AS description,
            JSON_VALUE(office.value, '$.address1') AS address1,
            JSON_VALUE(office.value, '$.address2') AS address2,
            JSON_VALUE(office.value, '$.zip_code') AS zip_code,
            JSON_VALUE(office.value, '$.city') AS city,
            JSON_VALUE(office.value, '$.state_code') AS state_code,
            JSON_VALUE(office.value, '$.country_code') AS country_code,
            TRY_CAST(JSON_VALUE(office.value, '$.latitude') AS DECIMAL(10,7)) AS latitude,
            TRY_CAST(JSON_VALUE(office.value, '$.longitude') AS DECIMAL(10,7)) AS longitude
        FROM OPENJSON(@JSON) AS company
        CROSS APPLY OPENJSON(company.value, '$.offices') AS office
        INNER JOIN crunchbase.Company c 
            ON c.mongo_id = JSON_VALUE(company.value, '$._id."$oid"');
        
        PRINT CONCAT('Zaimportowano biur: ', @@ROWCOUNT);
        
        -- ====================================================================
        -- Import FundingRound (Rundy finansowania)
        -- ====================================================================
        PRINT 'Importowanie rund finansowania...';
        
        INSERT INTO crunchbase.FundingRound (
            company_id, original_id, round_code, source_url, source_description,
            raised_amount, raised_currency_code, funded_year, funded_month, funded_day
        )
        SELECT 
            c.company_id,
            TRY_CAST(JSON_VALUE(fr.value, '$.id') AS INT) AS original_id,
            JSON_VALUE(fr.value, '$.round_code') AS round_code,
            JSON_VALUE(fr.value, '$.source_url') AS source_url,
            JSON_VALUE(fr.value, '$.source_description') AS source_description,
            TRY_CAST(JSON_VALUE(fr.value, '$.raised_amount') AS DECIMAL(18,2)) AS raised_amount,
            ISNULL(JSON_VALUE(fr.value, '$.raised_currency_code'), 'USD') AS raised_currency_code,
            TRY_CAST(JSON_VALUE(fr.value, '$.funded_year') AS INT) AS funded_year,
            TRY_CAST(JSON_VALUE(fr.value, '$.funded_month') AS INT) AS funded_month,
            TRY_CAST(JSON_VALUE(fr.value, '$.funded_day') AS INT) AS funded_day
        FROM OPENJSON(@JSON) AS company
        CROSS APPLY OPENJSON(company.value, '$.funding_rounds') AS fr
        INNER JOIN crunchbase.Company c 
            ON c.mongo_id = JSON_VALUE(company.value, '$._id."$oid"');
        
        PRINT CONCAT('Zaimportowano rund finansowania: ', @@ROWCOUNT);
        
        -- ====================================================================
        -- Import Investment (Inwestycje)
        -- ====================================================================
        PRINT 'Importowanie inwestycji...';
        
        INSERT INTO crunchbase.Investment (
            funding_round_id, person_id, financial_org_id, investing_company_id
        )
        SELECT 
            fround.funding_round_id,
            p.person_id,
            fo.financial_org_id,
            ic.company_id AS investing_company_id
        FROM OPENJSON(@JSON) AS company
        CROSS APPLY OPENJSON(company.value, '$.funding_rounds') AS fr
        CROSS APPLY OPENJSON(fr.value, '$.investments') AS inv
        INNER JOIN crunchbase.Company c 
            ON c.mongo_id = JSON_VALUE(company.value, '$._id."$oid"')
        INNER JOIN crunchbase.FundingRound fround 
            ON fround.company_id = c.company_id 
            AND fround.original_id = TRY_CAST(JSON_VALUE(fr.value, '$.id') AS INT)
        LEFT JOIN crunchbase.Person p 
            ON p.permalink = JSON_VALUE(inv.value, '$.person.permalink')
        LEFT JOIN crunchbase.FinancialOrg fo 
            ON fo.permalink = JSON_VALUE(inv.value, '$.financial_org.permalink')
        LEFT JOIN crunchbase.Company ic 
            ON ic.permalink = JSON_VALUE(inv.value, '$.company.permalink')
        WHERE (p.person_id IS NOT NULL OR fo.financial_org_id IS NOT NULL OR ic.company_id IS NOT NULL);
        
        PRINT CONCAT('Zaimportowano inwestycji: ', @@ROWCOUNT);
        
        -- ====================================================================
        -- Import CompanyRelationship (Relacje osoba-firma)
        -- ====================================================================
        PRINT 'Importowanie relacji osoba-firma...';
        
        INSERT INTO crunchbase.CompanyRelationship (company_id, person_id, title, is_past)
        SELECT 
            c.company_id,
            p.person_id,
            JSON_VALUE(rel.value, '$.title') AS title,
            CASE WHEN JSON_VALUE(rel.value, '$.is_past') = 'true' THEN 1 ELSE 0 END AS is_past
        FROM OPENJSON(@JSON) AS company
        CROSS APPLY OPENJSON(company.value, '$.relationships') AS rel
        INNER JOIN crunchbase.Company c 
            ON c.mongo_id = JSON_VALUE(company.value, '$._id."$oid"')
        INNER JOIN crunchbase.Person p 
            ON p.permalink = JSON_VALUE(rel.value, '$.person.permalink');
        
        PRINT CONCAT('Zaimportowano relacji osoba-firma: ', @@ROWCOUNT);
        
        -- ====================================================================
        -- Import Competitor (Konkurenci)
        -- ====================================================================
        PRINT 'Importowanie konkurentów...';
        
        INSERT INTO crunchbase.Competitor (company_id, competitor_company_id, competitor_name, competitor_permalink)
        SELECT 
            c.company_id,
            cc.company_id AS competitor_company_id,
            JSON_VALUE(comp.value, '$.competitor.name') AS competitor_name,
            JSON_VALUE(comp.value, '$.competitor.permalink') AS competitor_permalink
        FROM OPENJSON(@JSON) AS company
        CROSS APPLY OPENJSON(company.value, '$.competitions') AS comp
        INNER JOIN crunchbase.Company c 
            ON c.mongo_id = JSON_VALUE(company.value, '$._id."$oid"')
        LEFT JOIN crunchbase.Company cc 
            ON cc.permalink = JSON_VALUE(comp.value, '$.competitor.permalink')
        WHERE JSON_VALUE(comp.value, '$.competitor.name') IS NOT NULL;
        
        PRINT CONCAT('Zaimportowano konkurentów: ', @@ROWCOUNT);
        
        -- ====================================================================
        -- Import Milestone (Kamienie milowe)
        -- ====================================================================
        PRINT 'Importowanie kamieni milowych...';
        
        INSERT INTO crunchbase.Milestone (
            company_id, original_id, description,
            stoned_year, stoned_month, stoned_day,
            source_url, source_text, source_description,
            stoneable_type, stoned_value, stoned_value_type, stoned_acquirer
        )
        SELECT 
            c.company_id,
            TRY_CAST(JSON_VALUE(ms.value, '$.id') AS INT) AS original_id,
            JSON_VALUE(ms.value, '$.description') AS description,
            TRY_CAST(JSON_VALUE(ms.value, '$.stoned_year') AS INT) AS stoned_year,
            TRY_CAST(JSON_VALUE(ms.value, '$.stoned_month') AS INT) AS stoned_month,
            TRY_CAST(JSON_VALUE(ms.value, '$.stoned_day') AS INT) AS stoned_day,
            JSON_VALUE(ms.value, '$.source_url') AS source_url,
            JSON_VALUE(ms.value, '$.source_text') AS source_text,
            JSON_VALUE(ms.value, '$.source_description') AS source_description,
            JSON_VALUE(ms.value, '$.stoneable_type') AS stoneable_type,
            JSON_VALUE(ms.value, '$.stoned_value') AS stoned_value,
            JSON_VALUE(ms.value, '$.stoned_value_type') AS stoned_value_type,
            JSON_VALUE(ms.value, '$.stoned_acquirer') AS stoned_acquirer
        FROM OPENJSON(@JSON) AS company
        CROSS APPLY OPENJSON(company.value, '$.milestones') AS ms
        INNER JOIN crunchbase.Company c 
            ON c.mongo_id = JSON_VALUE(company.value, '$._id."$oid"');
        
        PRINT CONCAT('Zaimportowano kamieni milowych: ', @@ROWCOUNT);
        
        -- ====================================================================
        -- Import Acquisition (Przejęcia)
        -- ====================================================================
        PRINT 'Importowanie przejęć...';
        
        -- Przejęcia gdzie firma jest przejmująca (acquisitions array)
        INSERT INTO crunchbase.Acquisition (
            acquiring_company_id, acquired_company_id, acquired_company_name, acquired_company_permalink,
            price_amount, price_currency_code, term_code,
            source_url, source_description, acquired_year, acquired_month, acquired_day
        )
        SELECT 
            c.company_id AS acquiring_company_id,
            ac.company_id AS acquired_company_id,
            JSON_VALUE(acq.value, '$.company.name') AS acquired_company_name,
            JSON_VALUE(acq.value, '$.company.permalink') AS acquired_company_permalink,
            TRY_CAST(JSON_VALUE(acq.value, '$.price_amount') AS DECIMAL(18,2)) AS price_amount,
            ISNULL(JSON_VALUE(acq.value, '$.price_currency_code'), 'USD') AS price_currency_code,
            JSON_VALUE(acq.value, '$.term_code') AS term_code,
            JSON_VALUE(acq.value, '$.source_url') AS source_url,
            JSON_VALUE(acq.value, '$.source_description') AS source_description,
            TRY_CAST(JSON_VALUE(acq.value, '$.acquired_year') AS INT) AS acquired_year,
            TRY_CAST(JSON_VALUE(acq.value, '$.acquired_month') AS INT) AS acquired_month,
            TRY_CAST(JSON_VALUE(acq.value, '$.acquired_day') AS INT) AS acquired_day
        FROM OPENJSON(@JSON) AS company
        CROSS APPLY OPENJSON(company.value, '$.acquisitions') AS acq
        INNER JOIN crunchbase.Company c 
            ON c.mongo_id = JSON_VALUE(company.value, '$._id."$oid"')
        LEFT JOIN crunchbase.Company ac 
            ON ac.permalink = JSON_VALUE(acq.value, '$.company.permalink')
        WHERE JSON_VALUE(acq.value, '$.company.name') IS NOT NULL;
        
        -- Przejęcia gdzie firma została przejęta (acquisition object)
        INSERT INTO crunchbase.Acquisition (
            acquiring_company_id, acquired_company_id, acquired_company_name, acquired_company_permalink,
            price_amount, price_currency_code, term_code,
            source_url, source_description, acquired_year, acquired_month, acquired_day
        )
        SELECT 
            aq.company_id AS acquiring_company_id,
            c.company_id AS acquired_company_id,
            c.name AS acquired_company_name,
            c.permalink AS acquired_company_permalink,
            TRY_CAST(JSON_VALUE(company.value, '$.acquisition.price_amount') AS DECIMAL(18,2)) AS price_amount,
            ISNULL(JSON_VALUE(company.value, '$.acquisition.price_currency_code'), 'USD') AS price_currency_code,
            JSON_VALUE(company.value, '$.acquisition.term_code') AS term_code,
            JSON_VALUE(company.value, '$.acquisition.source_url') AS source_url,
            JSON_VALUE(company.value, '$.acquisition.source_description') AS source_description,
            TRY_CAST(JSON_VALUE(company.value, '$.acquisition.acquired_year') AS INT) AS acquired_year,
            TRY_CAST(JSON_VALUE(company.value, '$.acquisition.acquired_month') AS INT) AS acquired_month,
            TRY_CAST(JSON_VALUE(company.value, '$.acquisition.acquired_day') AS INT) AS acquired_day
        FROM OPENJSON(@JSON) AS company
        INNER JOIN crunchbase.Company c 
            ON c.mongo_id = JSON_VALUE(company.value, '$._id."$oid"')
        LEFT JOIN crunchbase.Company aq 
            ON aq.permalink = JSON_VALUE(company.value, '$.acquisition.acquiring_company.permalink')
        WHERE JSON_VALUE(company.value, '$.acquisition.acquiring_company.name') IS NOT NULL
        AND aq.company_id IS NOT NULL;
        
        PRINT CONCAT('Zaimportowano przejęć: ', (SELECT COUNT(*) FROM crunchbase.Acquisition));
        
        -- ====================================================================
        -- Import ExternalLink (Linki zewnętrzne)
        -- ====================================================================
        PRINT 'Importowanie linków zewnętrznych...';
        
        INSERT INTO crunchbase.ExternalLink (company_id, external_url, title)
        SELECT 
            c.company_id,
            JSON_VALUE(link.value, '$.external_url') AS external_url,
            JSON_VALUE(link.value, '$.title') AS title
        FROM OPENJSON(@JSON) AS company
        CROSS APPLY OPENJSON(company.value, '$.external_links') AS link
        INNER JOIN crunchbase.Company c 
            ON c.mongo_id = JSON_VALUE(company.value, '$._id."$oid"')
        WHERE JSON_VALUE(link.value, '$.external_url') IS NOT NULL;
        
        PRINT CONCAT('Zaimportowano linków zewnętrznych: ', @@ROWCOUNT);
        
        -- ====================================================================
        -- Import VideoEmbed (Filmy)
        -- ====================================================================
        PRINT 'Importowanie filmów...';
        
        INSERT INTO crunchbase.VideoEmbed (company_id, embed_code, description)
        SELECT 
            c.company_id,
            JSON_VALUE(vid.value, '$.embed_code') AS embed_code,
            JSON_VALUE(vid.value, '$.description') AS description
        FROM OPENJSON(@JSON) AS company
        CROSS APPLY OPENJSON(company.value, '$.video_embeds') AS vid
        INNER JOIN crunchbase.Company c 
            ON c.mongo_id = JSON_VALUE(company.value, '$._id."$oid"')
        WHERE JSON_VALUE(vid.value, '$.embed_code') IS NOT NULL;
        
        PRINT CONCAT('Zaimportowano filmów: ', @@ROWCOUNT);
        
        -- ====================================================================
        -- Import Provider (Dostawcy usług)
        -- ====================================================================
        PRINT 'Importowanie dostawców usług...';
        
        INSERT INTO crunchbase.Provider (
            company_id, provider_company_id, provider_name, provider_permalink, title, is_past
        )
        SELECT 
            c.company_id,
            pc.company_id AS provider_company_id,
            JSON_VALUE(prov.value, '$.provider.name') AS provider_name,
            JSON_VALUE(prov.value, '$.provider.permalink') AS provider_permalink,
            JSON_VALUE(prov.value, '$.title') AS title,
            CASE WHEN JSON_VALUE(prov.value, '$.is_past') = 'true' THEN 1 ELSE 0 END AS is_past
        FROM OPENJSON(@JSON) AS company
        CROSS APPLY OPENJSON(company.value, '$.providerships') AS prov
        INNER JOIN crunchbase.Company c 
            ON c.mongo_id = JSON_VALUE(company.value, '$._id."$oid"')
        LEFT JOIN crunchbase.Company pc 
            ON pc.permalink = JSON_VALUE(prov.value, '$.provider.permalink')
        WHERE JSON_VALUE(prov.value, '$.provider.name') IS NOT NULL;
        
        PRINT CONCAT('Zaimportowano dostawców usług: ', @@ROWCOUNT);
        
        -- ====================================================================
        -- Import CompanyImage (Obrazy firm)
        -- ====================================================================
        PRINT 'Importowanie obrazów firm...';
        
        INSERT INTO crunchbase.CompanyImage (company_id, width, height, image_path, attribution)
        SELECT 
            c.company_id,
            TRY_CAST(JSON_VALUE(size.value, '$[0][0]') AS INT) AS width,
            TRY_CAST(JSON_VALUE(size.value, '$[0][1]') AS INT) AS height,
            JSON_VALUE(size.value, '$[1]') AS image_path,
            JSON_VALUE(company.value, '$.image.attribution') AS attribution
        FROM OPENJSON(@JSON) AS company
        CROSS APPLY OPENJSON(company.value, '$.image.available_sizes') AS size
        INNER JOIN crunchbase.Company c 
            ON c.mongo_id = JSON_VALUE(company.value, '$._id."$oid"')
        WHERE JSON_VALUE(size.value, '$[1]') IS NOT NULL;
        
        PRINT CONCAT('Zaimportowano obrazów: ', @@ROWCOUNT);
        
        -- ====================================================================
        -- Import Screenshot (Zrzuty ekranu)
        -- ====================================================================
        PRINT 'Importowanie zrzutów ekranu...';
        
        -- Najpierw wstawiamy rekordy Screenshot
        INSERT INTO crunchbase.Screenshot (company_id, attribution)
        SELECT DISTINCT
            c.company_id,
            JSON_VALUE(ss.value, '$.attribution') AS attribution
        FROM OPENJSON(@JSON) AS company
        CROSS APPLY OPENJSON(company.value, '$.screenshots') AS ss
        INNER JOIN crunchbase.Company c 
            ON c.mongo_id = JSON_VALUE(company.value, '$._id."$oid"');
        
        PRINT CONCAT('Zaimportowano zrzutów ekranu: ', @@ROWCOUNT);
        
        -- ====================================================================
        PRINT '';
        PRINT '============================================';
        PRINT 'IMPORT ZAKOŃCZONY POMYŚLNIE!';
        PRINT '============================================';
        
        -- Podsumowanie
        SELECT 'Company' AS Tabela, COUNT(*) AS LiczbaRekordow FROM crunchbase.Company
        UNION ALL SELECT 'Person', COUNT(*) FROM crunchbase.Person
        UNION ALL SELECT 'FinancialOrg', COUNT(*) FROM crunchbase.FinancialOrg
        UNION ALL SELECT 'Product', COUNT(*) FROM crunchbase.Product
        UNION ALL SELECT 'Office', COUNT(*) FROM crunchbase.Office
        UNION ALL SELECT 'FundingRound', COUNT(*) FROM crunchbase.FundingRound
        UNION ALL SELECT 'Investment', COUNT(*) FROM crunchbase.Investment
        UNION ALL SELECT 'CompanyRelationship', COUNT(*) FROM crunchbase.CompanyRelationship
        UNION ALL SELECT 'Competitor', COUNT(*) FROM crunchbase.Competitor
        UNION ALL SELECT 'Milestone', COUNT(*) FROM crunchbase.Milestone
        UNION ALL SELECT 'Acquisition', COUNT(*) FROM crunchbase.Acquisition
        UNION ALL SELECT 'ExternalLink', COUNT(*) FROM crunchbase.ExternalLink
        UNION ALL SELECT 'VideoEmbed', COUNT(*) FROM crunchbase.VideoEmbed
        UNION ALL SELECT 'Provider', COUNT(*) FROM crunchbase.Provider
        UNION ALL SELECT 'CompanyImage', COUNT(*) FROM crunchbase.CompanyImage
        UNION ALL SELECT 'Screenshot', COUNT(*) FROM crunchbase.Screenshot;
        
    END TRY
    BEGIN CATCH
        SET @ErrorMessage = ERROR_MESSAGE();
        PRINT 'BŁĄD podczas importu: ' + @ErrorMessage;
        THROW;
    END CATCH
END
GO

-- ============================================================================
-- KROK 3: Uruchomienie importu
-- ============================================================================

-- Uruchomienie procedury importu
-- UWAGA: Zmień ścieżkę na właściwą dla swojego systemu!
EXEC crunchbase.ImportFromJSON 
    @JSONPath = 'C:\Users\mateu\Desktop\PROJECTS\GitHub\Bazy_Danych\PIABD\Projekt\companies documents 1-6.json';
GO

PRINT 'Skrypt importu zakończony.';
GO
