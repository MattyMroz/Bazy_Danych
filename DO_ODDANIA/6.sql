BAZY DANYCH - 4i05 - 2025
AUTOR: MATEUSZ MRÓZ 251190

ZADANIE 6
---------
CREATE PROCEDURE dbo.ZnajdzDzienTygodnia
    @DataWejsciowa DATE = NULL
AS
BEGIN
   DECLARE @WynikowaData DATE;
   DECLARE @DzienTygodnia NVARCHAR(20);

   -- Jeśli parametr nie został podany, użyj aktualnej daty
   IF @DataWejsciowa IS NULL
      SET @WynikowaData = GETDATE();
   ELSE
      SET @WynikowaData = @DataWejsciowa;

   -- Pobierz nazwę dnia tygodnia
   SET @DzienTygodnia = DATENAME(weekday, @WynikowaData);

   -- Zwróć wynik
   SELECT
      @WynikowaData AS Data,
      @DzienTygodnia AS DzienTygodnia;
END;

-- Z podaniem daty
EXEC dbo.ZnajdzDzienTygodnia '2020-11-11';
EXEC dbo.ZnajdzDzienTygodnia '2025-04-02';

-- Bez podania daty (użyje bieżącej daty)
EXEC dbo.ZnajdzDzienTygodnia;

2. Zwróć adres w postaci:
   Piotrkowska
   123/23
   m.30
   90-123 Łódź

(nie wiem o jaką postac chodziło)

-- teoretycznie powinno działać
SELECT
   'Piotrkowska' + CHAR(13)+CHAR(10) +
   '123/23' + CHAR(13)+CHAR(10) +
   'm.30' + CHAR(13)+CHAR(10) +
   '90-123 Łódź'
AS SformatowanyAdres;
GO

-- wyświtla wiadomość w konsoli
DECLARE @Adres NVARCHAR(100) =
  'Piotrkowska' + CHAR(13) + CHAR(10) +
  '123/23' + CHAR(13) + CHAR(10) +
  'm.30' + CHAR(13) + CHAR(10) +
  '90-123 Łódź';

PRINT @Adres;

-- robi wiele wierszy
SELECT 'Piotrkowska' AS Adres
UNION ALL
SELECT '123/23'
UNION ALL
SELECT 'm.30'
UNION ALL
SELECT '90-123 Łódź';

3. Stwórz trigger który przenosi dane dotyczące zarobków do tabeli historycznej będącej
   dokładną kopią tabeli zarobki bez kolumny aktualny. Uwzględnij w tej tabeli datę
   przenosin oraz użytkownika który kasował dane.

USE baza;
go;

-- Sprawdź, czy tabela historii już istnieje, jeśli nie, stwórz ją
IF OBJECT_ID('zarobki_historia', 'U') IS NULL
BEGIN
   CREATE TABLE zarobki_historia (
      zarID INT,
      od DATETIME,
      brutto MONEY,
      pracID INT,

      -- Dodatkowe kolumny
      DataPrzeniesienia DATETIME NOT NULL,
      UzytkownikKasujacy NVARCHAR(128) NOT NULL
   );
PRINT 'Tabela zarobki_historia została utworzona.';
END
ELSE
BEGIN
   PRINT 'Tabela zarobki_historia już istnieje.';
END
GO


-- Stworzenie triggera

-- Usuń trigger, jeśli już istnieje
IF OBJECT_ID('archiwizuj_zarobki', 'TR') IS NOT NULL
BEGIN
   DROP TRIGGER archiwizuj_zarobki;
   PRINT 'Istniejący trigger archiwizuj_zarobki został usunięty.';
END
GO

-- Trigger, który będzie się uruchamiał PO operacji DELETE na tabeli 'zarobki'
CREATE TRIGGER archiwizuj_zarobki
ON zarobki
AFTER DELETE
AS
BEGIN
   SET NOCOUNT ON;

   -- Wstaw dane do tabeli 'zarobki_historia'
   INSERT INTO zarobki_historia (
      zarID,
      od,
      brutto,
      pracID,
      DataPrzeniesienia,
      UzytkownikKasujacy
   )
   SELECT
      d.zarID,
      d.od,
      d.brutto,
      d.pracID,
      GETDATE(),
      SUSER_SNAME()
   FROM
      deleted d;
END;
GO

PRINT 'Trigger archiwizuj_zarobki został utworzony.';
GO

/*
SELECT * FROM zarobki WHERE pracID = 1;
SELECT * FROM zarobki_historia WHERE pracID = 1;
DELETE FROM zarobki WHERE pracID = 1;
SELECT * FROM zarobki WHERE pracID = 1;
SELECT * FROM zarobki_historia WHERE pracID = 1;
*/