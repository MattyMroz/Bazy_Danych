-- ============================================================================
-- Projekt: Baza Danych Company (CrunchBase)
-- Autor: Mateusz Mróz (251190)
-- Opis: Testy i zapytania demonstracyjne do filmiku
-- ============================================================================

USE CompanyDB;
GO

-- ============================================================================
-- 1. PODSTAWOWE ZAPYTANIA SELECT
-- ============================================================================

-- 1.1 Lista wszystkich firm z podstawowymi danymi
SELECT
    company_id,
    name AS 'Nazwa firmy',
    category_code AS 'Kategoria',
    founded_year AS 'Rok założenia',
    number_of_employees AS 'Liczba pracowników',
    total_money_raised AS 'Pozyskane środki'
FROM crunchbase.Company
ORDER BY name;

-- 1.2 Firmy założone po 2000 roku
SELECT name, founded_year, category_code
FROM crunchbase.Company
WHERE founded_year > 2000
ORDER BY founded_year DESC;

-- 1.3 Firmy z kategorii 'social' lub 'web'
SELECT name, category_code, homepage_url
FROM crunchbase.Company
WHERE category_code IN ('social', 'web', 'network_hosting')
ORDER BY category_code;

-- ============================================================================
-- 2. ZAPYTANIA Z FUNKCJAMI AGREGUJĄCYMI
-- ============================================================================

-- 2.1 Liczba firm w każdej kategorii
SELECT
    category_code AS 'Kategoria',
    COUNT(*) AS 'Liczba firm'
FROM crunchbase.Company
GROUP BY category_code
ORDER BY COUNT(*) DESC;

-- 2.2 Suma finansowania według rund
SELECT
    round_code AS 'Typ rundy',
    COUNT(*) AS 'Liczba rund',
    SUM(raised_amount) AS 'Suma finansowania',
    AVG(raised_amount) AS 'Średnie finansowanie'
FROM crunchbase.FundingRound
WHERE raised_amount IS NOT NULL
GROUP BY round_code
ORDER BY SUM(raised_amount) DESC;

-- 2.3 Top 5 firm z największym finansowaniem (użycie funkcji)
SELECT TOP 5
    c.name AS 'Firma',
    crunchbase.GetTotalFunding(c.company_id) AS 'Całkowite finansowanie'
FROM crunchbase.Company c
ORDER BY crunchbase.GetTotalFunding(c.company_id) DESC;

-- ============================================================================
-- 3. ZAPYTANIA Z JOIN (ZŁĄCZENIA)
-- ============================================================================

-- 3.1 Firmy z ich produktami
SELECT
    c.name AS 'Firma',
    p.name AS 'Produkt',
    p.permalink
FROM crunchbase.Company c
INNER JOIN crunchbase.Product p ON c.company_id = p.company_id
ORDER BY c.name;

-- 3.2 Firmy z ich biurami (lokalizacje)
SELECT
    c.name AS 'Firma',
    o.city AS 'Miasto',
    o.country_code AS 'Kraj',
    o.address1 AS 'Adres'
FROM crunchbase.Company c
INNER JOIN crunchbase.Office o ON c.company_id = o.company_id
WHERE o.city IS NOT NULL
ORDER BY c.name, o.city;

-- 3.3 Osoby i ich role w firmach
SELECT
    c.name AS 'Firma',
    p.first_name + ' ' + p.last_name AS 'Osoba',
    cr.title AS 'Stanowisko',
    CASE WHEN cr.is_past = 1 THEN 'Tak' ELSE 'Nie' END AS 'Były pracownik'
FROM crunchbase.CompanyRelationship cr
INNER JOIN crunchbase.Company c ON cr.company_id = c.company_id
INNER JOIN crunchbase.Person p ON cr.person_id = p.person_id
ORDER BY c.name, p.last_name;

-- 3.4 Inwestycje - kto zainwestował w jakie rundy
SELECT
    c.name AS 'Firma',
    fr.round_code AS 'Runda',
    fr.raised_amount AS 'Kwota',
    COALESCE(p.first_name + ' ' + p.last_name, fo.name, ic.name) AS 'Inwestor'
FROM crunchbase.Investment i
INNER JOIN crunchbase.FundingRound fr ON i.funding_round_id = fr.funding_round_id
INNER JOIN crunchbase.Company c ON fr.company_id = c.company_id
LEFT JOIN crunchbase.Person p ON i.person_id = p.person_id
LEFT JOIN crunchbase.FinancialOrg fo ON i.financial_org_id = fo.financial_org_id
LEFT JOIN crunchbase.Company ic ON i.investing_company_id = ic.company_id
ORDER BY c.name, fr.funded_year;

-- ============================================================================
-- 4. WIDOK - DEMONSTRACJA
-- ============================================================================

-- 4.1 Użycie widoku vw_CompanyOverview
SELECT * FROM crunchbase.vw_CompanyOverview
ORDER BY total_funding DESC;

-- 4.2 Firmy z więcej niż jednym produktem (z widoku)
SELECT name, products_count, funding_rounds_count
FROM crunchbase.vw_CompanyOverview
WHERE products_count > 0
ORDER BY products_count DESC;

-- ============================================================================
-- 5. PROCEDURA SKŁADOWANA - DEMONSTRACJA
-- ============================================================================

-- 5.1 Dodanie nowej firmy przez procedurę
EXEC crunchbase.UpsertCompany 
    @mongo_id = 'test123456789',
    @name = 'TestCompany',
    @permalink = 'testcompany',
    @category_code = 'software',
    @description = 'Firma testowa do demonstracji',
    @number_of_employees = 50,
    @founded_year = 2020;

-- 5.2 Sprawdzenie czy firma została dodana
SELECT * FROM crunchbase.Company WHERE mongo_id = 'test123456789';

-- 5.3 Aktualizacja firmy przez procedurę (ten sam mongo_id)
EXEC crunchbase.UpsertCompany 
    @mongo_id = 'test123456789',
    @name = 'TestCompany Updated',
    @permalink = 'testcompany',
    @category_code = 'enterprise',
    @description = 'Firma testowa - zaktualizowana',
    @number_of_employees = 100,
    @founded_year = 2020;

-- 5.4 Sprawdzenie aktualizacji
SELECT name, category_code, number_of_employees, updated_at 
FROM crunchbase.Company 
WHERE mongo_id = 'test123456789';

-- 5.5 Usunięcie firmy testowej (czyszczenie)
DELETE FROM crunchbase.Company WHERE mongo_id = 'test123456789';

-- ============================================================================
-- 6. FUNKCJA - DEMONSTRACJA
-- ============================================================================

-- 6.1 Użycie funkcji GetTotalFunding dla każdej firmy
SELECT
    name,
    crunchbase.GetTotalFunding(company_id) AS 'Suma finansowania'
FROM crunchbase.Company
ORDER BY crunchbase.GetTotalFunding(company_id) DESC;

-- ============================================================================
-- 7. ZAPYTANIA ZAAWANSOWANE
-- ============================================================================

-- 7.1 Firmy z konkurentami
SELECT
    c.name AS 'Firma',
    comp.competitor_name AS 'Konkurent'
FROM crunchbase.Competitor comp
INNER JOIN crunchbase.Company c ON comp.company_id = c.company_id
ORDER BY c.name;

-- 7.2 Przejęcia dokonane przez firmy
SELECT
    c.name AS 'Firma przejmująca',
    a.acquired_company_name AS 'Firma przejęta',
    a.price_amount AS 'Cena',
    a.acquired_year AS 'Rok'
FROM crunchbase.Acquisition a
INNER JOIN crunchbase.Company c ON a.acquiring_company_id = c.company_id
WHERE a.acquired_company_name IS NOT NULL
ORDER BY a.acquired_year DESC;

-- 7.3 Kamienie milowe firm
SELECT
    c.name AS 'Firma',
    m.description AS 'Opis',
    CONCAT(m.stoned_year, '-', m.stoned_month, '-', m.stoned_day) AS 'Data'
FROM crunchbase.Milestone m
INNER JOIN crunchbase.Company c ON m.company_id = c.company_id
WHERE m.description IS NOT NULL
ORDER BY m.stoned_year DESC, m.stoned_month DESC;

-- 7.4 Statystyki mediów firmowych
SELECT
    c.name AS 'Firma',
    (SELECT COUNT(*) FROM crunchbase.CompanyImage ci WHERE ci.company_id = c.company_id) AS 'Obrazy',
    (SELECT COUNT(*) FROM crunchbase.Screenshot s WHERE s.company_id = c.company_id) AS 'Screenshoty',
    (SELECT COUNT(*) FROM crunchbase.VideoEmbed v WHERE v.company_id = c.company_id) AS 'Filmy',
    (SELECT COUNT(*) FROM crunchbase.ExternalLink el WHERE el.company_id = c.company_id) AS 'Linki'
FROM crunchbase.Company c
ORDER BY c.name;

-- ============================================================================
-- 8. PODSUMOWANIE BAZY DANYCH
-- ============================================================================

-- 8.1 Liczba rekordów w każdej tabeli
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
UNION ALL SELECT 'CompanyIPO', COUNT(*) FROM crunchbase.CompanyIPO
ORDER BY Tabela;

-- ============================================================================
-- 9. TESTY UPRAWNIEŃ (EXECUTE AS USER)
-- ============================================================================

-- 9.1 Test jako Guest (tylko widok)
PRINT '=== TEST JAKO GUEST (tylko widok) ===';
EXECUTE AS USER='Guest';

-- Powinno działać: SELECT z widoku
PRINT 'Test 1: SELECT z widoku (powinno działać)';
BEGIN TRY
    SELECT TOP 3 * FROM crunchbase.vw_CompanyOverview;
    PRINT 'SUKCES: Guest ma dostęp do widoku';
END TRY
BEGIN CATCH
    PRINT 'BŁĄD: ' + ERROR_MESSAGE();
END CATCH

-- Powinno NIE działać: SELECT z tabeli
PRINT 'Test 2: SELECT z tabeli Company (powinno zwrócić błąd)';
BEGIN TRY
    SELECT TOP 1 * FROM crunchbase.Company;
    PRINT 'BŁĄD: Guest nie powinien mieć dostępu do tabeli!';
END TRY
BEGIN CATCH
    PRINT 'OCZEKIWANY BŁĄD: ' + ERROR_MESSAGE();
END CATCH

-- Powinno NIE działać: EXEC procedury
PRINT 'Test 3: EXEC procedury (powinno zwrócić błąd)';
BEGIN TRY
    EXEC crunchbase.UpsertCompany @mongo_id='x', @name='x', @permalink='x';
    PRINT 'BŁĄD: Guest nie powinien móc wykonywać procedur!';
END TRY
BEGIN CATCH
    PRINT 'OCZEKIWANY BŁĄD: ' + ERROR_MESSAGE();
END CATCH

REVERT;
GO

-- 9.2 Test jako Emp (procedury i funkcje)
PRINT '=== TEST JAKO EMP (procedury i funkcje) ===';
EXECUTE AS USER='Emp';

-- Powinno działać: EXEC procedury
PRINT 'Test 1: EXEC procedury UpsertCompany (powinno działać)';
BEGIN TRY
    EXEC crunchbase.UpsertCompany 
        @mongo_id='test_emp_001', 
        @name='TestEmp', 
        @permalink='testemp',
        @category_code='software';
    PRINT 'SUKCES: Emp może wykonywać procedury';
END TRY
BEGIN CATCH
    PRINT 'BŁĄD: ' + ERROR_MESSAGE();
END CATCH

-- Powinno działać: SELECT funkcji
PRINT 'Test 2: SELECT funkcji GetTotalFunding (powinno działać)';
BEGIN TRY
    SELECT crunchbase.GetTotalFunding(1) AS 'Finansowanie';
    PRINT 'SUKCES: Emp może wykonywać funkcje';
END TRY
BEGIN CATCH
    PRINT 'BŁĄD: ' + ERROR_MESSAGE();
END CATCH

-- Powinno NIE działać: SELECT z tabeli
PRINT 'Test 3: SELECT z tabeli Company (powinno zwrócić błąd)';
BEGIN TRY
    SELECT TOP 1 * FROM crunchbase.Company;
    PRINT 'BŁĄD: Emp nie powinien mieć bezpośredniego dostępu do tabel!';
END TRY
BEGIN CATCH
    PRINT 'OCZEKIWANY BŁĄD: ' + ERROR_MESSAGE();
END CATCH

REVERT;
GO

-- 9.3 Test jako Admin (pełne uprawnienia)
PRINT '=== TEST JAKO ADMIN (pełne uprawnienia) ===';
EXECUTE AS USER='Admin';

-- Powinno działać: SELECT z tabeli
PRINT 'Test 1: SELECT z tabeli Company (powinno działać)';
BEGIN TRY
    SELECT TOP 3 name, category_code FROM crunchbase.Company;
    PRINT 'SUKCES: Admin ma dostęp do wszystkich tabel';
END TRY
BEGIN CATCH
    PRINT 'BŁĄD: ' + ERROR_MESSAGE();
END CATCH

-- Powinno działać: EXEC procedury
PRINT 'Test 2: EXEC procedury (powinno działać)';
BEGIN TRY
    EXEC crunchbase.UpsertCompany 
        @mongo_id='test_admin_001', 
        @name='TestAdmin', 
        @permalink='testadmin',
        @category_code='enterprise';
    PRINT 'SUKCES: Admin może wykonywać procedury';
END TRY
BEGIN CATCH
    PRINT 'BŁĄD: ' + ERROR_MESSAGE();
END CATCH

-- Powinno działać: SELECT funkcji
PRINT 'Test 3: SELECT funkcji (powinno działać)';
BEGIN TRY
    SELECT TOP 3 name, crunchbase.GetTotalFunding(company_id) AS total_funding 
    FROM crunchbase.Company 
    ORDER BY total_funding DESC;
    PRINT 'SUKCES: Admin może używać funkcji';
END TRY
BEGIN CATCH
    PRINT 'BŁĄD: ' + ERROR_MESSAGE();
END CATCH

-- Powinno działać: DELETE (pełne uprawnienia)
PRINT 'Test 4: DELETE (czyszczenie testowych danych)';
BEGIN TRY
    DELETE FROM crunchbase.Company WHERE mongo_id LIKE 'test_%';
    PRINT 'SUKCES: Admin może usuwać dane';
END TRY
BEGIN CATCH
    PRINT 'BŁĄD: ' + ERROR_MESSAGE();
END CATCH

REVERT;
GO

PRINT '=== TESTY UPRAWNIEŃ ZAKOŃCZONE ===';
GO
