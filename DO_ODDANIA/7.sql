BAZY DANYCH - 4i05 - 2025
AUTOR: MATEUSZ MRÓZ 251190

ZADANIE 7
---------
Zadania do wykonania:

1. Stwórz funkcję która będzie przyjmować 2 argumenty będące ciągami znaków
   (maksymalnie do 100 znaków) i zwróci ciąg znaków powstały z wymieszania na przemian znaków
   z ciągu pierwszego z ciągiem drugim. Dodatkowo funkcja ta ma zamienić kolejność znaków.

   PRZYKŁAD: funkcja('ABCDE','12345') zwróci: 5E4D3C2B1A

   W przypadku niezgodności długości ciągów wejściowych wyświetl komunikat typu:
   'Błąd długości znaków: X <> Y' gdzie X i Y to długości ciągów wejściowych


CREATE FUNCTION dbo.MieszajCiagi(@ciag1 VARCHAR(100), @ciag2 VARCHAR(100))
RETURNS VARCHAR(200)
AS
BEGIN
   DECLARE @wynik VARCHAR(200) = ''
   DECLARE @dlugosc1 INT = LEN(@ciag1)
   DECLARE @dlugosc2 INT = LEN(@ciag2)
   DECLARE @i INT = 1

   IF @dlugosc1 <> @dlugosc2
      RETURN 'Błąd długości znaków: ' + CAST(@dlugosc1 AS VARCHAR) + ' <> ' + CAST(@dlugosc2 AS VARCHAR)

   WHILE @i <= @dlugosc1
   BEGIN
      SET @wynik = SUBSTRING(@ciag2, @i, 1) + SUBSTRING(@ciag1, @i, 1) + @wynik
      SET @i = @i + 1
   END

   RETURN @wynik
END

SELECT dbo.MieszajCiagi('ABCDE', '12345')
SELECT dbo.MieszajCiagi('ABCDE', 's')


2. Stwórz procedurę, która wyświetli w formie tekstowej (w oknie messages) co drugiego pracownika,
   którego nazwisko zaczyna się na literę podaną w parametrze. W przypadku nie podania
   parametru uwzględniaj tylko osoby o nazwisku na literę 'Z'. W przypadku podania w parametrze wartości
   null nie uwzględniaj kryterium.

   UWAGA: W zadaniu można użyć kursora.

   Przykład wyniku:
   'Pracownik nr #1 Jan Kowalski 25 lat'
   'Pracownik nr #3 Tomasz Kowalski 26 lat'
   'Pracownik nr #5 Piotr Kowalski 29 lat'

CREATE PROCEDURE dbo.WyswietlPracownikow
    @litera CHAR(1) = 'Z'
AS
BEGIN
   DECLARE @imie VARCHAR(50)
   DECLARE @nazwisko VARCHAR(50)
   DECLARE @wiek INT
   DECLARE @licznik INT = 0
   DECLARE @wyswietlony INT = 0

   DECLARE kursor_pracownikow CURSOR FOR
   SELECT imie, nazwisko, wiek
   FROM pracownicy
   WHERE @litera IS NULL OR LEFT(nazwisko, 1) = @litera
   ORDER BY pracID

   OPEN kursor_pracownikow

   FETCH NEXT FROM kursor_pracownikow INTO @imie, @nazwisko, @wiek

   WHILE @@FETCH_STATUS = 0
   BEGIN
      SET @licznik = @licznik + 1

      IF @licznik % 2 = 1
      BEGIN
         SET @wyswietlony = @wyswietlony + 1
         PRINT 'Pracownik nr #' + CAST(@wyswietlony AS VARCHAR) + ' ' + @imie + ' ' + @nazwisko +
               CASE WHEN @wiek IS NULL THEN ' wiek nieznany' ELSE ' ' + CAST(@wiek AS VARCHAR) + ' lat' END
      END

      FETCH NEXT FROM kursor_pracownikow INTO @imie, @nazwisko, @wiek
   END

   CLOSE kursor_pracownikow
   DEALLOCATE kursor_pracownikow
END

-- Przykład użycia procedury
EXEC dbo.WyswietlPracownikow 'K'
EXEC dbo.WyswietlPracownikow -- domyślnie 'Z'
EXEC dbo.WyswietlPracownikow NULL -- wszyscy pracownicy