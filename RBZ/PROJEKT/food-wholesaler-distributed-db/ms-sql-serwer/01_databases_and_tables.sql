/*
    01_databases_and_tables.sql

    Bazy i tabele dla czesci MS SQL Server:
    - HurtowniaCentrala
    - HurtowniaMagazyn

*/

USE master;
GO

-- ============================================================
-- 0. Zdjecie replikacji
-- ============================================================

IF DB_ID(N'HurtowniaCentrala') IS NOT NULL
BEGIN
    BEGIN TRY EXEC HurtowniaCentrala.sys.sp_dropsubscription @publication = N'PUB_PRODUKT', @article = N'all', @subscriber = N'all'; END TRY BEGIN CATCH END CATCH;
    BEGIN TRY EXEC HurtowniaCentrala.sys.sp_droppublication @publication = N'PUB_PRODUKT'; END TRY BEGIN CATCH END CATCH;
    BEGIN TRY EXEC sp_replicationdboption @dbname = N'HurtowniaCentrala', @optname = N'publish', @value = N'false'; END TRY BEGIN CATCH END CATCH;
END;
GO
BEGIN TRY EXEC sp_dropdistributor @no_checks = 1, @ignore_distributor = 1; END TRY BEGIN CATCH END CATCH;
GO

-- Tworzenie baz danych
IF DB_ID(N'HurtowniaCentrala') IS NULL
    CREATE DATABASE HurtowniaCentrala;
GO

IF DB_ID(N'HurtowniaMagazyn') IS NULL
    CREATE DATABASE HurtowniaMagazyn;
GO

-- Tworzenie loginow i uzytkownikow
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'CentralaApp')
    CREATE LOGIN CentralaApp WITH PASSWORD = '123', CHECK_POLICY = OFF;
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'MagazynApp')
    CREATE LOGIN MagazynApp WITH PASSWORD = '123', CHECK_POLICY = OFF;
GO

-- ============================================================
-- 1. HurtowniaCentrala
-- ============================================================

USE HurtowniaCentrala;
GO

-- 1. Uzytkownik aplikacji centrali
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'CentralaApp')
    CREATE USER CentralaApp FOR LOGIN CentralaApp;
GO

-- 2. Czyszczenie tabel (kolejnosc odwrotna do zaleznosci FK)
IF OBJECT_ID(N'dbo.CENNIK_DOSTAWCY', N'U') IS NOT NULL DROP TABLE dbo.CENNIK_DOSTAWCY;
IF OBJECT_ID(N'dbo.CENNIK_IMPORT', N'U') IS NOT NULL DROP TABLE dbo.CENNIK_IMPORT;
IF OBJECT_ID(N'dbo.PRODUKT', N'U') IS NOT NULL DROP TABLE dbo.PRODUKT;
IF OBJECT_ID(N'dbo.DOSTAWCA', N'U') IS NOT NULL DROP TABLE dbo.DOSTAWCA;
IF OBJECT_ID(N'dbo.KATEGORIA', N'U') IS NOT NULL DROP TABLE dbo.KATEGORIA;
IF OBJECT_ID(N'dbo.STAWKA_VAT', N'U') IS NOT NULL DROP TABLE dbo.STAWKA_VAT;
GO

-- 3. Tworzenie tabel

-- Tabela KATEGORIA z samoreferencją dla kategorii nadrzędnej
CREATE TABLE dbo.KATEGORIA (
    id_kategorii INT IDENTITY(1,1) CONSTRAINT PK_KATEGORIA PRIMARY KEY,
    nazwa NVARCHAR(100) NOT NULL,
    id_kategorii_nadrzednej INT NULL,
    CONSTRAINT FK_KATEGORIA_NADRZEDNA
        FOREIGN KEY (id_kategorii_nadrzednej)
        REFERENCES dbo.KATEGORIA(id_kategorii)
);
GO

-- Tabela STAWKA_VAT z ograniczeniem CHECK dla dozwolonych stawek VAT
CREATE TABLE dbo.STAWKA_VAT (
    id_stawki TINYINT CONSTRAINT PK_STAWKA_VAT PRIMARY KEY,
    stawka DECIMAL(5,2) NOT NULL,
    opis NVARCHAR(100) NOT NULL,
    CONSTRAINT CK_STAWKA_VAT_STAWKA CHECK (stawka IN (0.00, 5.00, 8.00, 23.00))
);
GO

-- Tabela DOSTAWCA z unikalnym NIP oraz walidacja formatu email (musi zawierac @ i kropke)
CREATE TABLE dbo.DOSTAWCA (
    id_dostawcy INT IDENTITY(1,1) CONSTRAINT PK_DOSTAWCA PRIMARY KEY,
    nazwa NVARCHAR(150) NOT NULL,
    nip NVARCHAR(20) NOT NULL,
    email NVARCHAR(120) NULL,
    CONSTRAINT UQ_DOSTAWCA_NIP UNIQUE (nip),
    CONSTRAINT CK_DOSTAWCA_EMAIL CHECK (email IS NULL OR email LIKE '%_@_%._%')
);
GO

-- Tabela PRODUKT z kluczami obcymi do KATEGORIA i STAWKA_VAT, unikalnym indeksem na kod kreskowy oraz ograniczeniem CHECK dla strefy temperaturowej
CREATE TABLE dbo.PRODUKT (
    id_produktu INT IDENTITY(1,1) CONSTRAINT PK_PRODUKT PRIMARY KEY,
    nazwa NVARCHAR(200) NOT NULL,
    jednostka_miary NVARCHAR(20) NOT NULL,
    kod_kreskowy NVARCHAR(30) NULL,
    id_stawki_vat TINYINT NOT NULL,
    strefa_temperaturowa NVARCHAR(30) NOT NULL,
    id_kategorii INT NOT NULL,
    aktywny BIT NOT NULL CONSTRAINT DF_PRODUKT_AKTYWNY DEFAULT (1),
    CONSTRAINT FK_PRODUKT_STAWKA
        FOREIGN KEY (id_stawki_vat)
        REFERENCES dbo.STAWKA_VAT(id_stawki),
    CONSTRAINT FK_PRODUKT_KATEGORIA
        FOREIGN KEY (id_kategorii)
        REFERENCES dbo.KATEGORIA(id_kategorii),
    CONSTRAINT CK_PRODUKT_STREFA
        CHECK (strefa_temperaturowa IN (N'SUCHY', N'CHLODNIA', N'MROZNIA')),
    CONSTRAINT UQ_PRODUKT_KOD UNIQUE (kod_kreskowy)
);
GO

-- Tabela CENNIK_DOSTAWCY z kluczami obcymi do DOSTAWCA i PRODUKT, ograniczeniami CHECK dla ceny netto i dat
CREATE TABLE dbo.CENNIK_DOSTAWCY (
    id_cennika INT IDENTITY(1,1) CONSTRAINT PK_CENNIK_DOSTAWCY PRIMARY KEY,
    id_dostawcy INT NOT NULL,
    id_produktu INT NOT NULL,
    cena_netto DECIMAL(10,2) NOT NULL,
    data_od DATE NOT NULL,
    data_do DATE NULL,
    CONSTRAINT FK_CENNIK_DOSTAWCA
        FOREIGN KEY (id_dostawcy)
        REFERENCES dbo.DOSTAWCA(id_dostawcy),
    CONSTRAINT FK_CENNIK_PRODUKT
        FOREIGN KEY (id_produktu)
        REFERENCES dbo.PRODUKT(id_produktu),
    CONSTRAINT CK_CENNIK_CENA CHECK (cena_netto > 0),
    CONSTRAINT CK_CENNIK_DATY CHECK (data_do IS NULL OR data_do >= data_od)
);
GO

-- Tabela buforowa CENNIK_IMPORT (staging importu z Excela) - bez FK, bo przyjmuje surowe dane przed walidacja; domyslne wartosci dla daty importu i zrodla
CREATE TABLE dbo.CENNIK_IMPORT (
    id_importu INT IDENTITY(1,1) CONSTRAINT PK_CENNIK_IMPORT PRIMARY KEY,
    id_produktu INT NOT NULL,
    cena_netto DECIMAL(10,2) NOT NULL,
    data_od DATE NULL,
    data_importu DATETIME2(0) NOT NULL CONSTRAINT DF_CENNIK_IMPORT_DATA DEFAULT (SYSDATETIME()),
    zrodlo NVARCHAR(100) NOT NULL CONSTRAINT DF_CENNIK_IMPORT_ZRODLO DEFAULT (N'Excel')
);
GO

-- 4. Dane startowe centrali

-- Wstawianie stawek VAT z opisami
INSERT INTO dbo.STAWKA_VAT (id_stawki, stawka, opis)
VALUES
    (1, 0.00, N'zwolniona'),
    (2, 5.00, N'VAT 5%'),
    (3, 8.00, N'VAT 8%'),
    (4, 23.00, N'VAT 23%');
GO

-- Wstawianie kategorii (bez kategorii nadrzędnych dla uproszczenia)
INSERT INTO dbo.KATEGORIA (nazwa, id_kategorii_nadrzednej)
VALUES
    (N'Konserwy', NULL),
    (N'Makarony', NULL),
    (N'Oleje', NULL),
    (N'Przyprawy', NULL),
    (N'Mrozonki', NULL);
GO

-- Wstawianie dostawców z unikalnymi NIP-ami i adresami email
INSERT INTO dbo.DOSTAWCA (nazwa, nip, email)
VALUES
    (N'Polski Dostawca Food sp. z o.o.', N'7250000001', N'kontakt@dostawca-food.local'),
    (N'Mrozonki Centrum sp. z o.o.', N'7250000002', N'handel@mrozonki.local');
GO

-- Wstawianie produktów z unikalnymi kodami kreskowymi, różnymi stawkami VAT i strefami temperaturowymi
INSERT INTO dbo.PRODUKT
    (nazwa, jednostka_miary, kod_kreskowy, id_stawki_vat, strefa_temperaturowa, id_kategorii)
VALUES
    (N'Fasola konserwowa 400g', N'szt.', N'5900000000011', 3, N'SUCHY', 1),
    (N'Makaron swiderki 500g', N'szt.', N'5900000000028', 2, N'SUCHY', 2),
    (N'Olej rzepakowy 1l', N'szt.', N'5900000000035', 2, N'SUCHY', 3),
    (N'Pieprz czarny 100g', N'szt.', N'5900000000042', 3, N'SUCHY', 4),
    (N'Pierogi mrozone 1kg', N'szt.', N'5900000000059', 2, N'MROZNIA', 5);
GO

-- Wstawianie cenników dostawców z różnymi cenami netto i datami obowiązywania
INSERT INTO dbo.CENNIK_DOSTAWCY (id_dostawcy, id_produktu, cena_netto, data_od, data_do)
VALUES
    (1, 1, 4.20, '2026-01-01', NULL),
    (1, 2, 3.10, '2026-01-01', NULL),
    (1, 3, 8.90, '2026-01-01', NULL),
    (1, 4, 5.50, '2026-01-01', NULL),
    (1, 5, 11.00, '2026-01-01', NULL);
GO

-- 5. Uprawnienia aplikacji centrali
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO CentralaApp;
GO

-- ============================================================
-- 2. HurtowniaMagazyn
-- ============================================================

USE HurtowniaMagazyn;
GO

-- 1. Uzytkownik aplikacji magazynu
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'MagazynApp')
    CREATE USER MagazynApp FOR LOGIN MagazynApp;
GO

-- 2. Czyszczenie tabel (kolejnosc odwrotna do zaleznosci FK)
IF OBJECT_ID(N'dbo.REZERWACJA', N'U') IS NOT NULL DROP TABLE dbo.REZERWACJA;
IF OBJECT_ID(N'dbo.STAN_PARTII', N'U') IS NOT NULL DROP TABLE dbo.STAN_PARTII;
IF OBJECT_ID(N'dbo.PARTIA', N'U') IS NOT NULL DROP TABLE dbo.PARTIA;
IF OBJECT_ID(N'dbo.STREFA_MAGAZYNU', N'U') IS NOT NULL DROP TABLE dbo.STREFA_MAGAZYNU;
IF OBJECT_ID(N'dbo.PRODUKT', N'U') IS NOT NULL DROP TABLE dbo.PRODUKT;
GO

-- 3. Replika katalogu i tabele magazynowe

-- Tabela PRODUKT - replika katalogu z centrali (cel replikacji), tylko do odczytu.
CREATE TABLE dbo.PRODUKT (
    id_produktu INT CONSTRAINT PK_PRODUKT_MAGAZYN PRIMARY KEY,
    nazwa NVARCHAR(200) NOT NULL,
    strefa_temperaturowa NVARCHAR(30) NOT NULL,
    CONSTRAINT CK_PRODUKT_MAGAZYN_STREFA
        CHECK (strefa_temperaturowa IN (N'SUCHY', N'CHLODNIA', N'MROZNIA'))
);
GO

-- Tabela STREFA_MAGAZYNU z ograniczeniami CHECK dla typu temperaturowego i zakresu temperatur
CREATE TABLE dbo.STREFA_MAGAZYNU (
    id_strefy INT IDENTITY(1,1) CONSTRAINT PK_STREFA_MAGAZYNU PRIMARY KEY,
    nazwa NVARCHAR(100) NOT NULL,
    typ_temperaturowy NVARCHAR(30) NOT NULL,
    temp_min DECIMAL(5,2) NOT NULL,
    temp_max DECIMAL(5,2) NOT NULL,
    CONSTRAINT CK_STREFA_TYP CHECK (typ_temperaturowy IN (N'SUCHY', N'CHLODNIA', N'MROZNIA')),
    CONSTRAINT CK_STREFA_TEMP CHECK (temp_min <= temp_max)
);
GO

-- Tabela PARTIA z kluczami obcymi do PRODUKT i STREFA_MAGAZYNU, ograniczeniem CHECK dla dat przydatnosci i produkcji oraz unikalnym indeksem na numer partii dostawcy
CREATE TABLE dbo.PARTIA (
    id_partii INT IDENTITY(1,1) CONSTRAINT PK_PARTIA PRIMARY KEY,
    id_produktu INT NOT NULL,
    id_strefy INT NOT NULL,
    numer_partii_dostawcy NVARCHAR(80) NOT NULL,
    data_produkcji DATE NOT NULL,
    data_przydatnosci DATE NOT NULL,
    CONSTRAINT FK_PARTIA_PRODUKT
        FOREIGN KEY (id_produktu)
        REFERENCES dbo.PRODUKT(id_produktu),
    CONSTRAINT FK_PARTIA_STREFA
        FOREIGN KEY (id_strefy)
        REFERENCES dbo.STREFA_MAGAZYNU(id_strefy),
    CONSTRAINT CK_PARTIA_DATY CHECK (data_przydatnosci >= data_produkcji),
    CONSTRAINT UQ_PARTIA_NUMER UNIQUE (numer_partii_dostawcy)
);
GO

-- Tabela STAN_PARTII z kluczem obcym do PARTIA i ograniczeniem CHECK dla ilosci dostepnej
CREATE TABLE dbo.STAN_PARTII (
    id_partii INT CONSTRAINT PK_STAN_PARTII PRIMARY KEY,
    ilosc_dostepna DECIMAL(10,3) NOT NULL,
    CONSTRAINT FK_STAN_PARTII_PARTIA
        FOREIGN KEY (id_partii)
        REFERENCES dbo.PARTIA(id_partii),
    CONSTRAINT CK_STAN_PARTII_ILOSC CHECK (ilosc_dostepna >= 0)
);
GO

-- Tabela REZERWACJA z kluczami obcymi do PARTIA, ograniczeniem CHECK dla ilosci rezerwowanej oraz domyślną wartością dla daty utworzenia
CREATE TABLE dbo.REZERWACJA (
    id_rezerwacji INT IDENTITY(1,1) CONSTRAINT PK_REZERWACJA PRIMARY KEY,
    id_partii INT NOT NULL,
    id_zamowienia_zewn INT NOT NULL,
    ilosc DECIMAL(10,3) NOT NULL,
    utworzono DATETIME2(0) NOT NULL CONSTRAINT DF_REZERWACJA_UTWORZONO DEFAULT (SYSDATETIME()),
    CONSTRAINT FK_REZERWACJA_PARTIA
        FOREIGN KEY (id_partii)
        REFERENCES dbo.PARTIA(id_partii),
    CONSTRAINT CK_REZERWACJA_ILOSC CHECK (ilosc > 0)
);
GO

-- 4. Dane startowe magazynu (replika produktow kopiowana recznie na potrzeby testu)
INSERT INTO dbo.PRODUKT (id_produktu, nazwa, strefa_temperaturowa)
SELECT id_produktu, nazwa, strefa_temperaturowa
FROM HurtowniaCentrala.dbo.PRODUKT;
GO

-- Wstawianie stref magazynowych z różnymi typami temperaturowymi i zakresami temperatur
INSERT INTO dbo.STREFA_MAGAZYNU (nazwa, typ_temperaturowy, temp_min, temp_max)
VALUES
    (N'Magazyn suchy A', N'SUCHY', 15.00, 25.00),
    (N'Chlodnia A', N'CHLODNIA', 2.00, 8.00),
    (N'Mroznia A', N'MROZNIA', -24.00, -18.00);
GO

-- Partie produktow. Pierogi (produkt 5) maja dwie partie z roznymi datami przydatnosci (FEFO).
INSERT INTO dbo.PARTIA
    (id_produktu, id_strefy, numer_partii_dostawcy, data_produkcji, data_przydatnosci)
VALUES
    (1, 1, N'KONS-2026-01', '2026-01-10', '2027-01-10'),
    (2, 1, N'MAK-2026-01', '2026-01-12', '2027-01-12'),
    (3, 1, N'OLEJ-2026-01', '2026-01-05', '2027-01-05'),
    (4, 1, N'PRZ-2026-01', '2026-01-20', '2028-01-20'),
    (5, 3, N'MROZ-2026-08', '2026-01-15', '2026-08-15'),
    (5, 3, N'MROZ-2026-12', '2026-02-15', '2026-12-15');
GO

-- Stany partii: produkty 1-4 po 150 szt., kazda partia pierogow po 40 szt.
INSERT INTO dbo.STAN_PARTII (id_partii, ilosc_dostepna)
SELECT pa.id_partii,
       CASE WHEN pa.id_produktu = 5 THEN 40.000 ELSE 150.000 END
FROM dbo.PARTIA AS pa;
GO

-- 5. Uprawnienia magazynu (replika tylko do odczytu)
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO MagazynApp;
DENY INSERT, UPDATE, DELETE ON dbo.PRODUKT TO MagazynApp;
GO

-- ============================================================
-- 3. Kontrolne SELECT-y
-- ============================================================

SELECT TOP 10 * FROM HurtowniaCentrala.dbo.PRODUKT;
SELECT TOP 10 * FROM HurtowniaMagazyn.dbo.PRODUKT;
SELECT TOP 10 * FROM HurtowniaMagazyn.dbo.STAN_PARTII;
GO
