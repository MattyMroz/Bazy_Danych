-- ============================================================================
-- Projekt: Baza Danych Company (CrunchBase)
-- Autor: Mateusz Mróz (251190)
-- Opis: Import danych z pliku JSON
-- UWAGA: Zmień ścieżkę do pliku JSON!
-- ============================================================================

USE CompanyDB;
GO

DECLARE @JSON NVARCHAR(MAX);

-- Wczytanie pliku JSON (ZMIEŃ ŚCIEŻKĘ!)
SET @JSON = (
    SELECT BulkColumn
    FROM OPENROWSET(
        BULK 'C:\dane\companies documents 1-6.json',
        SINGLE_CLOB
    ) AS j
);

IF @JSON IS NULL
BEGIN
    RAISERROR('Nie udalo sie wczytac pliku JSON!', 16, 1);
    RETURN;
END

PRINT 'JSON wczytany. Importowanie danych...';

-- ============================================================================
-- IMPORT COMPANY
-- ============================================================================
INSERT INTO crunchbase.Company (
    mongo_id, name, permalink, crunchbase_url, homepage_url,
    blog_url, blog_feed_url, twitter_username, category_code,
    description, overview, number_of_employees,
    founded_year, founded_month, founded_day,
    deadpooled_year, deadpooled_month, deadpooled_day, deadpooled_url,
    tag_list, alias_list, email_address, phone_number, total_money_raised
)
SELECT
    JSON_VALUE(c.value, '$._id."$oid"'),
    JSON_VALUE(c.value, '$.name'),
    JSON_VALUE(c.value, '$.permalink'),
    JSON_VALUE(c.value, '$.crunchbase_url'),
    JSON_VALUE(c.value, '$.homepage_url'),
    JSON_VALUE(c.value, '$.blog_url'),
    JSON_VALUE(c.value, '$.blog_feed_url'),
    JSON_VALUE(c.value, '$.twitter_username'),
    JSON_VALUE(c.value, '$.category_code'),
    JSON_VALUE(c.value, '$.description'),
    JSON_VALUE(c.value, '$.overview'),
    TRY_CAST(JSON_VALUE(c.value, '$.number_of_employees') AS INT),
    TRY_CAST(JSON_VALUE(c.value, '$.founded_year') AS INT),
    TRY_CAST(JSON_VALUE(c.value, '$.founded_month') AS INT),
    TRY_CAST(JSON_VALUE(c.value, '$.founded_day') AS INT),
    TRY_CAST(JSON_VALUE(c.value, '$.deadpooled_year') AS INT),
    TRY_CAST(JSON_VALUE(c.value, '$.deadpooled_month') AS INT),
    TRY_CAST(JSON_VALUE(c.value, '$.deadpooled_day') AS INT),
    JSON_VALUE(c.value, '$.deadpooled_url'),
    JSON_VALUE(c.value, '$.tag_list'),
    JSON_VALUE(c.value, '$.alias_list'),
    JSON_VALUE(c.value, '$.email_address'),
    JSON_VALUE(c.value, '$.phone_number'),
    CASE
        -- Jeśli kończy się na 'B' (Miliardy), usuń '$' i 'B', pomnóż przez 1 mld
        WHEN JSON_VALUE(c.value, '$.total_money_raised') LIKE '%B' THEN
            TRY_CAST(REPLACE(REPLACE(JSON_VALUE(c.value, '$.total_money_raised'), '$', ''), 'B', '') AS DECIMAL(18, 2)) * 1000000000
        -- Jeśli kończy się na 'M' (Miliony), usuń '$' i 'M', pomnóż przez 1 mln
        WHEN JSON_VALUE(c.value, '$.total_money_raised') LIKE '%M' THEN
            TRY_CAST(REPLACE(REPLACE(JSON_VALUE(c.value, '$.total_money_raised'), '$', ''), 'M', '') AS DECIMAL(18, 2)) * 1000000
        -- Jeśli kończy się na 'k' (Tysiące), usuń '$' i 'k', pomnóż przez 1 tys
        WHEN JSON_VALUE(c.value, '$.total_money_raised') LIKE '%k' THEN
            TRY_CAST(REPLACE(REPLACE(JSON_VALUE(c.value, '$.total_money_raised'), '$', ''), 'k', '') AS DECIMAL(18, 2)) * 1000
        -- W pozostałych przypadkach tylko usuń '$' i spróbuj rzutować
        ELSE
            TRY_CAST(REPLACE(JSON_VALUE(c.value, '$.total_money_raised'), '$', '') AS DECIMAL(18, 2))
    END
FROM OPENJSON(@JSON) AS c
WHERE NOT EXISTS (
    SELECT 1 FROM crunchbase.Company co 
    WHERE co.mongo_id = JSON_VALUE(c.value, '$._id."$oid"')
);

PRINT CONCAT('Firmy: ', @@ROWCOUNT);

-- ============================================================================
-- IMPORT PERSON (z relationships)
-- ============================================================================
INSERT INTO crunchbase.Person (first_name, last_name, permalink)
SELECT DISTINCT
    JSON_VALUE(r.value, '$.person.first_name'),
    JSON_VALUE(r.value, '$.person.last_name'),
    JSON_VALUE(r.value, '$.person.permalink')
FROM OPENJSON(@JSON) AS c
CROSS APPLY OPENJSON(c.value, '$.relationships') AS r
WHERE JSON_VALUE(r.value, '$.person.permalink') IS NOT NULL
AND NOT EXISTS (
    SELECT 1 FROM crunchbase.Person p 
    WHERE p.permalink = JSON_VALUE(r.value, '$.person.permalink')
);

-- Osoby z investments
INSERT INTO crunchbase.Person (first_name, last_name, permalink)
SELECT DISTINCT
    JSON_VALUE(inv.value, '$.person.first_name'),
    JSON_VALUE(inv.value, '$.person.last_name'),
    JSON_VALUE(inv.value, '$.person.permalink')
FROM OPENJSON(@JSON) AS c
CROSS APPLY OPENJSON(c.value, '$.funding_rounds') AS fr
CROSS APPLY OPENJSON(fr.value, '$.investments') AS inv
WHERE JSON_VALUE(inv.value, '$.person.permalink') IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM crunchbase.Person p WHERE p.permalink = JSON_VALUE(inv.value, '$.person.permalink'));

DECLARE @PersonCount INT = (SELECT COUNT(*) FROM crunchbase.Person);
PRINT CONCAT('Osoby: ', @PersonCount);

-- ============================================================================
-- IMPORT FINANCIALORG
-- ============================================================================
INSERT INTO crunchbase.FinancialOrg (name, permalink)
SELECT DISTINCT
    JSON_VALUE(inv.value, '$.financial_org.name'),
    JSON_VALUE(inv.value, '$.financial_org.permalink')
FROM OPENJSON(@JSON) AS c
CROSS APPLY OPENJSON(c.value, '$.funding_rounds') AS fr
CROSS APPLY OPENJSON(fr.value, '$.investments') AS inv
WHERE JSON_VALUE(inv.value, '$.financial_org.permalink') IS NOT NULL
AND NOT EXISTS (
    SELECT 1 FROM crunchbase.FinancialOrg fo 
    WHERE fo.permalink = JSON_VALUE(inv.value, '$.financial_org.permalink')
);

PRINT CONCAT('Organizacje finansowe: ', @@ROWCOUNT);

-- ============================================================================
-- IMPORT PRODUCT
-- ============================================================================
INSERT INTO crunchbase.Product (company_id, name, permalink)
SELECT
    co.company_id,
    JSON_VALUE(p.value, '$.name'),
    JSON_VALUE(p.value, '$.permalink')
FROM OPENJSON(@JSON) AS c
CROSS APPLY OPENJSON(c.value, '$.products') AS p
INNER JOIN crunchbase.Company co ON co.mongo_id = JSON_VALUE(c.value, '$._id."$oid"');

PRINT CONCAT('Produkty: ', @@ROWCOUNT);

-- ============================================================================
-- IMPORT OFFICE
-- ============================================================================
INSERT INTO crunchbase.Office (company_id, description, address1, address2, zip_code, city, state_code, country_code, latitude, longitude)
SELECT
    co.company_id,
    JSON_VALUE(o.value, '$.description'),
    JSON_VALUE(o.value, '$.address1'),
    JSON_VALUE(o.value, '$.address2'),
    JSON_VALUE(o.value, '$.zip_code'),
    JSON_VALUE(o.value, '$.city'),
    JSON_VALUE(o.value, '$.state_code'),
    JSON_VALUE(o.value, '$.country_code'),
    TRY_CAST(JSON_VALUE(o.value, '$.latitude') AS DECIMAL(10,7)),
    TRY_CAST(JSON_VALUE(o.value, '$.longitude') AS DECIMAL(10,7))
FROM OPENJSON(@JSON) AS c
CROSS APPLY OPENJSON(c.value, '$.offices') AS o
INNER JOIN crunchbase.Company co ON co.mongo_id = JSON_VALUE(c.value, '$._id."$oid"');

PRINT CONCAT('Biura: ', @@ROWCOUNT);

-- ============================================================================
-- IMPORT FUNDINGROUND
-- ============================================================================
INSERT INTO crunchbase.FundingRound (company_id, original_id, round_code, source_url, source_description, raised_amount, raised_currency_code, funded_year, funded_month, funded_day)
SELECT
    co.company_id,
    TRY_CAST(JSON_VALUE(fr.value, '$.id') AS INT),
    JSON_VALUE(fr.value, '$.round_code'),
    JSON_VALUE(fr.value, '$.source_url'),
    JSON_VALUE(fr.value, '$.source_description'),
    TRY_CAST(JSON_VALUE(fr.value, '$.raised_amount') AS DECIMAL(18,2)),
    ISNULL(JSON_VALUE(fr.value, '$.raised_currency_code'), 'USD'),
    TRY_CAST(JSON_VALUE(fr.value, '$.funded_year') AS INT),
    TRY_CAST(JSON_VALUE(fr.value, '$.funded_month') AS INT),
    TRY_CAST(JSON_VALUE(fr.value, '$.funded_day') AS INT)
FROM OPENJSON(@JSON) AS c
CROSS APPLY OPENJSON(c.value, '$.funding_rounds') AS fr
INNER JOIN crunchbase.Company co ON co.mongo_id = JSON_VALUE(c.value, '$._id."$oid"');

PRINT CONCAT('Rundy finansowania: ', @@ROWCOUNT);

-- ============================================================================
-- IMPORT INVESTMENT
-- ============================================================================
INSERT INTO crunchbase.Investment (funding_round_id, person_id, financial_org_id, investing_company_id)
SELECT
    fround.funding_round_id,
    p.person_id,
    fo.financial_org_id,
    ic.company_id
FROM OPENJSON(@JSON) AS c
CROSS APPLY OPENJSON(c.value, '$.funding_rounds') AS fr
CROSS APPLY OPENJSON(fr.value, '$.investments') AS inv
INNER JOIN crunchbase.Company co ON co.mongo_id = JSON_VALUE(c.value, '$._id."$oid"')
INNER JOIN crunchbase.FundingRound fround ON fround.company_id = co.company_id AND fround.original_id = TRY_CAST(JSON_VALUE(fr.value, '$.id') AS INT)
LEFT JOIN crunchbase.Person p ON p.permalink = JSON_VALUE(inv.value, '$.person.permalink')
LEFT JOIN crunchbase.FinancialOrg fo ON fo.permalink = JSON_VALUE(inv.value, '$.financial_org.permalink')
LEFT JOIN crunchbase.Company ic ON ic.permalink = JSON_VALUE(inv.value, '$.company.permalink')
WHERE (p.person_id IS NOT NULL OR fo.financial_org_id IS NOT NULL OR ic.company_id IS NOT NULL);

PRINT CONCAT('Inwestycje: ', @@ROWCOUNT);

-- ============================================================================
-- IMPORT COMPANYRELATIONSHIP
-- ============================================================================
INSERT INTO crunchbase.CompanyRelationship (company_id, person_id, title, is_past)
SELECT
    co.company_id,
    p.person_id,
    JSON_VALUE(r.value, '$.title'),
    CASE WHEN JSON_VALUE(r.value, '$.is_past') = 'true' THEN 1 ELSE 0 END
FROM OPENJSON(@JSON) AS c
CROSS APPLY OPENJSON(c.value, '$.relationships') AS r
INNER JOIN crunchbase.Company co ON co.mongo_id = JSON_VALUE(c.value, '$._id."$oid"')
INNER JOIN crunchbase.Person p ON p.permalink = JSON_VALUE(r.value, '$.person.permalink');

PRINT CONCAT('Relacje osoba-firma: ', @@ROWCOUNT);

-- ============================================================================
-- IMPORT COMPETITOR
-- ============================================================================
INSERT INTO crunchbase.Competitor (company_id, competitor_company_id, competitor_name, competitor_permalink)
SELECT DISTINCT
    co.company_id,
    cc.company_id,
    JSON_VALUE(comp.value, '$.competitor.name'),
    JSON_VALUE(comp.value, '$.competitor.permalink')
FROM OPENJSON(@JSON) AS c
CROSS APPLY OPENJSON(c.value, '$.competitions') AS comp
INNER JOIN crunchbase.Company co ON co.mongo_id = JSON_VALUE(c.value, '$._id."$oid"')
LEFT JOIN crunchbase.Company cc ON cc.permalink = JSON_VALUE(comp.value, '$.competitor.permalink')
WHERE JSON_VALUE(comp.value, '$.competitor.name') IS NOT NULL;

PRINT CONCAT('Konkurenci: ', @@ROWCOUNT);

-- ============================================================================
-- IMPORT MILESTONE
-- ============================================================================
INSERT INTO crunchbase.Milestone (company_id, original_id, description, stoned_year, stoned_month, stoned_day, source_url, source_text, source_description, stoneable_type, stoned_value, stoned_value_type, stoned_acquirer)
SELECT
    co.company_id,
    TRY_CAST(JSON_VALUE(m.value, '$.id') AS INT),
    JSON_VALUE(m.value, '$.description'),
    TRY_CAST(JSON_VALUE(m.value, '$.stoned_year') AS INT),
    TRY_CAST(JSON_VALUE(m.value, '$.stoned_month') AS INT),
    TRY_CAST(JSON_VALUE(m.value, '$.stoned_day') AS INT),
    JSON_VALUE(m.value, '$.source_url'),
    JSON_VALUE(m.value, '$.source_text'),
    JSON_VALUE(m.value, '$.source_description'),
    JSON_VALUE(m.value, '$.stoneable_type'),
    JSON_VALUE(m.value, '$.stoned_value'),
    JSON_VALUE(m.value, '$.stoned_value_type'),
    JSON_VALUE(m.value, '$.stoned_acquirer')
FROM OPENJSON(@JSON) AS c
CROSS APPLY OPENJSON(c.value, '$.milestones') AS m
INNER JOIN crunchbase.Company co ON co.mongo_id = JSON_VALUE(c.value, '$._id."$oid"');

PRINT CONCAT('Kamienie milowe: ', @@ROWCOUNT);

-- ============================================================================
-- IMPORT ACQUISITION (firma przejmuje inne)
-- ============================================================================
INSERT INTO crunchbase.Acquisition (acquiring_company_id, acquired_company_id, acquired_company_name, acquired_company_permalink, price_amount, price_currency_code, term_code, source_url, source_description, acquired_year, acquired_month, acquired_day)
SELECT
    co.company_id,
    ac.company_id,
    JSON_VALUE(a.value, '$.company.name'),
    JSON_VALUE(a.value, '$.company.permalink'),
    TRY_CAST(JSON_VALUE(a.value, '$.price_amount') AS DECIMAL(18,2)),
    ISNULL(JSON_VALUE(a.value, '$.price_currency_code'), 'USD'),
    JSON_VALUE(a.value, '$.term_code'),
    JSON_VALUE(a.value, '$.source_url'),
    JSON_VALUE(a.value, '$.source_description'),
    TRY_CAST(JSON_VALUE(a.value, '$.acquired_year') AS INT),
    TRY_CAST(JSON_VALUE(a.value, '$.acquired_month') AS INT),
    TRY_CAST(JSON_VALUE(a.value, '$.acquired_day') AS INT)
FROM OPENJSON(@JSON) AS c
CROSS APPLY OPENJSON(c.value, '$.acquisitions') AS a
INNER JOIN crunchbase.Company co ON co.mongo_id = JSON_VALUE(c.value, '$._id."$oid"')
LEFT JOIN crunchbase.Company ac ON ac.permalink = JSON_VALUE(a.value, '$.company.permalink')
WHERE JSON_VALUE(a.value, '$.company.name') IS NOT NULL;

PRINT CONCAT('Przejecia: ', @@ROWCOUNT);

-- ============================================================================
-- IMPORT EXTERNALLINK
-- ============================================================================
INSERT INTO crunchbase.ExternalLink (company_id, external_url, title)
SELECT
    co.company_id,
    JSON_VALUE(l.value, '$.external_url'),
    JSON_VALUE(l.value, '$.title')
FROM OPENJSON(@JSON) AS c
CROSS APPLY OPENJSON(c.value, '$.external_links') AS l
INNER JOIN crunchbase.Company co ON co.mongo_id = JSON_VALUE(c.value, '$._id."$oid"')
WHERE JSON_VALUE(l.value, '$.external_url') IS NOT NULL;

PRINT CONCAT('Linki zewnetrzne: ', @@ROWCOUNT);

-- ============================================================================
-- IMPORT VIDEOEMBED
-- ============================================================================
INSERT INTO crunchbase.VideoEmbed (company_id, embed_code, description)
SELECT
    co.company_id,
    JSON_VALUE(v.value, '$.embed_code'),
    JSON_VALUE(v.value, '$.description')
FROM OPENJSON(@JSON) AS c
CROSS APPLY OPENJSON(c.value, '$.video_embeds') AS v
INNER JOIN crunchbase.Company co ON co.mongo_id = JSON_VALUE(c.value, '$._id."$oid"')
WHERE JSON_VALUE(v.value, '$.embed_code') IS NOT NULL;

PRINT CONCAT('Filmy: ', @@ROWCOUNT);

-- ============================================================================
-- IMPORT PROVIDER
-- ============================================================================
INSERT INTO crunchbase.Provider (company_id, provider_company_id, provider_name, provider_permalink, title, is_past)
SELECT
    co.company_id,
    pc.company_id,
    JSON_VALUE(pr.value, '$.provider.name'),
    JSON_VALUE(pr.value, '$.provider.permalink'),
    JSON_VALUE(pr.value, '$.title'),
    CASE WHEN JSON_VALUE(pr.value, '$.is_past') = 'true' THEN 1 ELSE 0 END
FROM OPENJSON(@JSON) AS c
CROSS APPLY OPENJSON(c.value, '$.providerships') AS pr
INNER JOIN crunchbase.Company co ON co.mongo_id = JSON_VALUE(c.value, '$._id."$oid"')
LEFT JOIN crunchbase.Company pc ON pc.permalink = JSON_VALUE(pr.value, '$.provider.permalink')
WHERE JSON_VALUE(pr.value, '$.provider.name') IS NOT NULL;

PRINT CONCAT('Dostawcy: ', @@ROWCOUNT);

-- ============================================================================
-- IMPORT COMPANYIMAGE
-- ============================================================================
INSERT INTO crunchbase.CompanyImage (company_id, width, height, image_path, attribution)
SELECT
    co.company_id,
    TRY_CAST(JSON_VALUE(s.value, '$[0][0]') AS INT),
    TRY_CAST(JSON_VALUE(s.value, '$[0][1]') AS INT),
    JSON_VALUE(s.value, '$[1]'),
    JSON_VALUE(c.value, '$.image.attribution')
FROM OPENJSON(@JSON) AS c
CROSS APPLY OPENJSON(c.value, '$.image.available_sizes') AS s
INNER JOIN crunchbase.Company co ON co.mongo_id = JSON_VALUE(c.value, '$._id."$oid"')
WHERE JSON_VALUE(s.value, '$[1]') IS NOT NULL;

PRINT CONCAT('Obrazy: ', @@ROWCOUNT);

-- ============================================================================
-- IMPORT SCREENSHOT
-- ============================================================================
INSERT INTO crunchbase.Screenshot (company_id, attribution)
SELECT DISTINCT
    co.company_id,
    JSON_VALUE(ss.value, '$.attribution')
FROM OPENJSON(@JSON) AS c
CROSS APPLY OPENJSON(c.value, '$.screenshots') AS ss
INNER JOIN crunchbase.Company co ON co.mongo_id = JSON_VALUE(c.value, '$._id."$oid"');

PRINT CONCAT('Zrzuty ekranu: ', @@ROWCOUNT);

-- ============================================================================
-- IMPORT SCREENSHOTSIZE
-- ============================================================================
INSERT INTO crunchbase.ScreenshotSize (screenshot_id, width, height, image_path)
SELECT
    s.screenshot_id,
    TRY_CAST(JSON_VALUE(sz.value, '$[0][0]') AS INT),
    TRY_CAST(JSON_VALUE(sz.value, '$[0][1]') AS INT),
    JSON_VALUE(sz.value, '$[1]')
FROM OPENJSON(@JSON) AS c
CROSS APPLY OPENJSON(c.value, '$.screenshots') AS ss
CROSS APPLY OPENJSON(ss.value, '$.available_sizes') AS sz
INNER JOIN crunchbase.Company co ON co.mongo_id = JSON_VALUE(c.value, '$._id."$oid"')
INNER JOIN crunchbase.Screenshot s ON s.company_id = co.company_id
    AND (s.attribution = JSON_VALUE(ss.value, '$.attribution') OR (s.attribution IS NULL AND JSON_VALUE(ss.value, '$.attribution') IS NULL));

PRINT CONCAT('Rozmiary screenshotow: ', @@ROWCOUNT);

-- ============================================================================
-- IMPORT COMPANYIPO
-- ============================================================================
INSERT INTO crunchbase.CompanyIPO (company_id, valuation_amount, valuation_currency_code, pub_year, pub_month, pub_day, stock_symbol)
SELECT
    co.company_id,
    TRY_CAST(JSON_VALUE(c.value, '$.ipo.valuation_amount') AS DECIMAL(18,2)),
    ISNULL(JSON_VALUE(c.value, '$.ipo.valuation_currency_code'), 'USD'),
    TRY_CAST(JSON_VALUE(c.value, '$.ipo.pub_year') AS INT),
    TRY_CAST(JSON_VALUE(c.value, '$.ipo.pub_month') AS INT),
    TRY_CAST(JSON_VALUE(c.value, '$.ipo.pub_day') AS INT),
    JSON_VALUE(c.value, '$.ipo.stock_symbol')
FROM OPENJSON(@JSON) AS c
INNER JOIN crunchbase.Company co ON co.mongo_id = JSON_VALUE(c.value, '$._id."$oid"')
WHERE JSON_VALUE(c.value, '$.ipo.stock_symbol') IS NOT NULL 
   OR JSON_VALUE(c.value, '$.ipo.valuation_amount') IS NOT NULL;

PRINT CONCAT('IPO: ', @@ROWCOUNT);

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================
PRINT '';
PRINT '=== IMPORT ZAKONCZONY ===';
SELECT 'Company' AS Tabela, COUNT(*) AS Rekordy FROM crunchbase.Company
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
UNION ALL SELECT 'Screenshot', COUNT(*) FROM crunchbase.Screenshot
UNION ALL SELECT 'ScreenshotSize', COUNT(*) FROM crunchbase.ScreenshotSize
UNION ALL SELECT 'CompanyIPO', COUNT(*) FROM crunchbase.CompanyIPO;
GO
