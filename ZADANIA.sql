BAZY DANYCH - 4i05 - 2025
AUTOR: MATEUSZ MRÓZ 251190

NAZWA LOKALNEGO SERVERA SQL
---------------------------
MATEUSZ\SQLEXPRESS01
---------------------------
NAZWY ZMIENNCY W CamelCase



ZADANIE 1
---------
Po utworzeniu bazy danych z pliku baza.txt należy wykonać następujące polecenia:

1. Wyświetlić diagram bazy wraz z relacjami

Wyświetlenie diagramu bazy danych:
-> Database Diagrams
   -> New Database Diagram
      -> Patrz plik 1.1.png

2. Dodać pola do tabel (wszystkich) zgodnie z poniższym schematem:
   - ALTER TABLE nazwa_tabeli ADD nazwa_kolumny tak aby można było wykonać operacje UPDATE dla pola wzrost zgodnie z przykładem uwzględniającym warunek na polu prac_id:
     UPDATE nazwa_tabeli SET wzrost=wartość WHERE pracid < wartość (z pola prac_id w danej tabeli)
    (zadanie nie precyzuje, moja interpretacja poniżej)

ALTER TABLE dzialy ADD liczbaBiur INT NULL;
ALTER TABLE pracownicy ADD wzrost INT NULL;
ALTER TABLE zarobki ADD podwyzka INT NULL;

UPDATE dzialy
SET liczbaBiur = 5
WHERE dzialID < 3;

UPDATE pracownicy
SET wzrost = 175
WHERE pracID < 6;

UPDATE zarobki
SET podwyzka = 300
WHERE pracID < 9;

3. Dodać pola do tabel (wszystkich) przy użyciu wartości DEFAULT

ALTER TABLE dzialy ADD DataUtworzenia DATETIME DEFAULT GETDATE();
ALTER TABLE pracownicy ADD DataZatrudnienia DATETIME DEFAULT GETDATE();
ALTER TABLE zarobki ADD DataDodania DATETIME DEFAULT GETDATE();

4. Wyświetlić wszystkich pracowników na literę T

SELECT *
FROM pracownicy
WHERE imie LIKE 'T%';

5. Wyświetlić imiona, nazwiska i zarobki pracowników

SELECT p.imie, p.nazwisko, z.brutto AS Zarobki
FROM pracownicy p
JOIN zarobki z ON p.pracID = z.pracID;








ZADANIE 2
---------
1. Na bazie utworzonej z pliku baza.txt proszę o wykonanie zapytania zwracającego wszystkich pracowników pracujących w danych działach
(zadanie nie precyzuje)

SELECT p.imie, p.nazwisko, d.nazwa AS NazwaDzialu
FROM pracownicy p, dzialy d
WHERE p.dzialID = d.dzialID;

SELECT p.imie, p.nazwisko, d.nazwa AS NazwaDzialu
FROM pracownicy p
INNER JOIN dzialy d ON p.dzialID = d.dzialID;

2. Proszę o wykonanie zapytania zwracającego wszystkich pracowników pracujących w danych działach oraz wyświetlenie ich zarobków używając polecenia JOIN

SELECT
   p.imie,
   p.nazwisko,
   d.nazwa AS NazwaDzialu,
   z.brutto AS Zarobki,
   z.od AS DataZarobkow
FROM pracownicy p
INNER JOIN dzialy d ON p.dzialID = d.dzialID
INNER JOIN zarobki z ON p.pracID = z.pracID;








ZADANIE 3
---------
Constraints
(Teoria do zadania ograniczeń znajduje się w pliku o nazwie constraintsi_unique)
(nie mam takiego pliku ;-;)

1. Do tabeli pracownicy dodaj kolumnę mix, która ma zawierać 6 znaków i nałóż na nią
   ograniczenie pozwalające wpisywać jedynie wyrazy które zawierają na przemian 3 litery i 3 cyfry. 
   Nazwij to ograniczenie CK_MIX.
   Przykład wartości: a4f5d9
   (zadanie nie precyzuje, zakładam że litery mogą być zarówno małe jak i duże)

ALTER TABLE pracownicy
ADD mix VARCHAR(6) NULL;

ALTER TABLE pracownicy
ADD CONSTRAINT CK_MIX CHECK (mix LIKE '[A-Za-z][0-9][A-Za-z][0-9][A-Za-z][0-9]');


2. Do tabeli pracownicy dodaj kolumnę NIP która będzie zawierała ograniczenie pozwalające na
   wpisanie następującej wartości 727-002-18-95 dla wartości znaków i liczb określonej dla
   dowolnego znaku i liczb z przedziału 0-9. Nazwij to ograniczenie NIP.

ALTER TABLE pracownicy
ADD NIP VARCHAR(13) NULL;

ALTER TABLE pracownicy
ADD CONSTRAINT CK_NIP CHECK (NIP LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]');

Group by i zapytania
-------------------
Zadania do wykonania:

1. Zapytanie zwracające 2 kolumny: kraj oraz ilość zamówień z niego realizowanych,
   jedynie kraje o największej liczbie zamówień

SELECT TOP 1 WITH TIES
   ShipCountry,
   COUNT(OrderID) AS numberOfOrders
FROM Orders
WHERE ShipCountry IS NOT NULL
GROUP BY ShipCountry
ORDER BY numberOfOrders DESC;

2. Zapytanie zwracające 3 kolumny: imię, nazwisko, id zamówienia.
   Jedynie zamówienia z 3 kwartału 1996 zrealizowane po terminie.

SELECT
   E.FirstName AS firstName,
   E.LastName AS lastName,
   O.OrderID AS orderId
FROM Employees E
INNER JOIN Orders O ON E.EmployeeID = O.EmployeeID
WHERE O.OrderDate >= '1996-07-01'
   AND O.OrderDate < '1996-10-01'
   AND O.ShippedDate > O.RequiredDate
   AND O.ShippedDate IS NOT NULL;







ZADANIE 4
---------
Zapytania do wykonania na bazie Northwind (angielski).
Wartość w nawiasach oznacza ilość rekordów do zwrócenia bądź konkretny rekord:

1. Zapytanie zwracające nazwy kategorii i ilość produktów do nich przypisanych; posortować rosnąco (9)

SELECT
   ISNULL(C.CategoryName, 'Brak kategorii') AS categoryName,
   COUNT(P.ProductID) AS numberOfProducts
FROM Categories C
RIGHT JOIN Products P ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryName
ORDER BY numberOfProducts ASC;

2. Zapytanie zwracające nazwę firmy, która złożyła najdroższe zamówienie (QUICK-Stop)

SELECT TOP 1 WITH TIES
   C.CompanyName AS companyName
FROM Customers C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.OrderID, C.CompanyName
ORDER BY SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) DESC;

3. Podać nazwę towaru i sumaryczną wartość sprzedaży towaru w przedziale czasowym 12 do 5 lat
   wstecz od aktualnej daty systemowej

SELECT
   P.ProductName AS productName,
   SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS totalSalesValue
FROM Products P
INNER JOIN [Order Details] OD ON P.ProductID = OD.ProductID
INNER JOIN Orders O ON OD.OrderID = O.OrderID
WHERE
   O.OrderDate >= DATEADD(YEAR, -12, GETDATE())
   AND O.OrderDate < DATEADD(YEAR, -5, GETDATE())
GROUP BY P.ProductName
ORDER BY P.ProductName;

4. Zapytanie zwracające OrderID oraz łączną wartość każdego z zamówień; posortować malejąco (830)

SELECT
   O.OrderID AS orderId,
   SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS totalOrderValue
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.OrderID
ORDER BY totalOrderValue DESC;

5. Wyświetlić ID pracownika, imię, nazwisko, nazwę działu, wiek, datę wypłaty oraz kwotę pracowników,
   a następnie stworzyć tabelę [into_tabela] oraz wstawić dane - bez użycia polecenia CREATE TABLE

USE baza;

-- Usunięcie tabeli jeśli istnieje
IF OBJECT_ID('into_tabela', 'U') IS NOT NULL
   DROP TABLE into_tabela;

-- Wypisanie danych
SELECT
   p.pracID AS ID_Pracownika,
   p.imie AS Imie,
   p.nazwisko AS Nazwisko,
   d.nazwa AS NazwaDzialu,
   p.wiek AS Wiek,
   z.od AS DataWyplaty,
   z.brutto AS Kwota
FROM pracownicy p
LEFT JOIN dzialy d ON p.dzialID = d.dzialID
LEFT JOIN zarobki z ON p.pracID = z.pracID;

-- Zapisanie
SELECT
   p.pracID AS ID_Pracownika,
   p.imie AS Imie,
   p.nazwisko AS Nazwisko,
   d.nazwa AS NazwaDzialu,
   p.wiek AS Wiek,
   z.od AS DataWyplaty,
   z.brutto AS Kwota
INTO into_tabela
FROM pracownicy p
LEFT JOIN dzialy d ON p.dzialID = d.dzialID
LEFT JOIN zarobki z ON p.pracID = z.pracID;

-- Wyświetlenie utworzonej tabeli
SELECT * FROM into_tabela

6. Zapytanie zwracające 2 kolumny: imię oraz nazwisko pracownika.
   Jedynie pracownicy na stanowisku przedstawiciel handlowy

USE north;

SELECT
   FirstName AS Imie,
   LastName AS Nazwisko
FROM Employees
WHERE Title = 'Sales Representative';

7. Zapytanie zwracające 2 kolumny: nazwę produktu oraz nazwę firmy dostarczającej dany produkt

SELECT
   P.ProductName AS NazwaProduktu,
   S.CompanyName AS NazwaFirmyDostawcy
FROM Products P
JOIN Suppliers S ON P.SupplierID = S.SupplierID;

8. Zapytanie zwracające 3 kolumny: imię, nazwisko oraz ilość zrealizowanych zamówień.
   Jedynie pracownicy o największej ilości zamówień

SELECT TOP 1 WITH TIES
   E.FirstName AS Imie,
   E.LastName AS Nazwisko,
   COUNT(O.OrderID) AS IloscZamowien
FROM Employees E
JOIN Orders O ON E.EmployeeID = O.EmployeeID
GROUP BY E.EmployeeID, E.FirstName, E.LastName
ORDER BY IloscZamowien DESC;

9. Zapytanie zwracające 3 kolumny: imię, nazwisko, id zamówienia.
   Jedynie zamówienia z 3 kwartału 1996 zrealizowane po terminie (5)

SELECT
   E.FirstName AS Imie,
   E.LastName AS Nazwisko,
   O.OrderID
FROM Employees E
JOIN Orders O ON E.EmployeeID = O.EmployeeID
WHERE O.OrderDate >= '1996-07-01'
   AND O.OrderDate < '1996-10-01'
   AND O.ShippedDate > O.RequiredDate
   AND O.ShippedDate IS NOT NULL;




ZADANIE 5
---------
1. Zapytanie zwracające 3 kolumny: nazwę firmy, nazwę kategorii oraz ilość produktów
   dostarczanych w danej kategorii przez dostawcę. Jedynie dostawcy z Niemiec (7)

SELECT
   S.CompanyName AS NazwaFirmyDostawcy,
   C.CategoryName AS NazwaKategorii,
   COUNT(P.ProductID) AS IloscProduktowWDanejKategorii
FROM Suppliers S
JOIN Products P ON S.SupplierID = P.SupplierID
JOIN Categories C ON P.CategoryID = C.CategoryID
WHERE S.Country = 'Germany'
GROUP BY S.CompanyName, C.CategoryName
ORDER BY S.CompanyName, C.CategoryName;

2. Zapytanie zwracające 2 kolumny: nazwę kategorii oraz nazwę firmy.
   Jedynie firmy, które dostarczają najwięcej produktów w danej kategorii

SELECT
   C.CategoryName AS NazwaKategorii,
   S.CompanyName AS NazwaFirmyZNajwiekszaIlosciaProduktow
   -- COUNT(P1.ProductID) AS LiczbaProduktow
FROM Products P1
JOIN Categories C ON P1.CategoryID = C.CategoryID
JOIN Suppliers S ON P1.SupplierID = S.SupplierID
GROUP BY C.CategoryName, S.CompanyName, C.CategoryID
HAVING
    -- Sprawdzamy, czy liczba produktów dla tej firmy w tej kategorii jest większa lub równa liczbie produktów WSZYSTKICH firm w TEJ SAMEJ kategorii
    COUNT(P1.ProductID) >= ALL (
        SELECT COUNT(P2.ProductID) -- Policz produkty dla innych firm w tej kategorii
        FROM Products P2
        WHERE P2.CategoryID = C.CategoryID -- Ogranicz do TEJ SAMEJ kategorii
        GROUP BY P2.SupplierID -- Grupuj wg dostawcy wewnątrz tej kategorii
    )
ORDER BY NazwaKategorii, NazwaFirmyZNajwiekszaIlosciaProduktow;

3. Zapytanie zwracające 2 kolumny: imię oraz nazwisko pracownika.
   Jedynie pracownicy na stanowisku przedstawiciel handlowy

SELECT
   FirstName AS Imie,
   LastName AS Nazwisko
FROM Employees
WHERE Title = 'Sales Representative';

4. Zapytanie zwracające 2 kolumny: nazwę produktu oraz nazwę firmy dostarczającej dany produkt

SELECT
   P.ProductName AS NazwaProduktu,
   S.CompanyName AS NazwaFirmyDostawcy
FROM Products P
JOIN Suppliers S ON P.SupplierID = S.SupplierID;

5. Zapytanie zwracające 3 kolumny: imię, nazwisko oraz ilość zrealizowanych zamówień.
   Jedynie pracownicy o największej ilości zamówień

SELECT TOP 1 WITH TIES
   E.FirstName AS Imie,
   E.LastName AS Nazwisko,
   COUNT(O.OrderID) AS IloscZamowien
FROM Employees E
JOIN Orders O ON E.EmployeeID = O.EmployeeID
GROUP BY E.EmployeeID, E.FirstName, E.LastName
ORDER BY IloscZamowien DESC;

6. Zapytanie zwracające 3 kolumny: imię, nazwisko, id zamówienia.
   Jedynie zamówienia z 3 kwartału 1996 zrealizowane po terminie (5)

SELECT
   E.FirstName AS Imie,
   E.LastName AS Nazwisko,
   O.OrderID
FROM Employees E
JOIN Orders O ON E.EmployeeID = O.EmployeeID
WHERE O.OrderDate >= '1996-07-01'
   AND O.OrderDate < '1996-10-01'
   AND O.ShippedDate > O.RequiredDate
   AND O.ShippedDate IS NOT NULL;

7. Zapytanie zwracające nazwy kategorii i ilość produktów do nich przypisanych;
   posortować rosnąco (9)

SELECT
   ISNULL(C.CategoryName, 'Brak kategorii') AS categoryName,
   COUNT(P.ProductID) AS numberOfProducts
FROM Categories C
RIGHT JOIN Products P ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryName
ORDER BY numberOfProducts ASC;

8. Znaleźć liczbę zamówień z 1 dnia wystawienia zamówień i przez kolejne dni do końca
   następnego miesiąca

SELECT COUNT(OrderID) AS LiczbaZamowien
FROM Orders
WHERE OrderDate BETWEEN
   (SELECT MIN(OrderDate) FROM Orders)
   AND
   (SELECT EOMONTH(DATEADD(month, 1, MIN(OrderDate))) FROM Orders);

9. Podać nie powtarzające się pary produktów w tej samej cenie jednostkowej

SELECT DISTINCT
   p1.ProductName AS Produkt1,
   p2.ProductName AS Produkt2,
   p1.UnitPrice AS CenaJednostkowa
FROM Products p1
INNER JOIN Products p2 ON p1.UnitPrice = p2.UnitPrice
WHERE p1.ProductID < p2.ProductID
ORDER BY p1.UnitPrice, p1.ProductName, p2.ProductName;

10. Zapytanie zwracające ilość zamówień złożonych przez firmę Around the Horn (13)

SELECT
   COUNT(O.OrderID) AS IloscZamowienAroundTheHorn
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
WHERE C.CompanyName = 'Around the Horn';

11. Zapytanie zwracające nazwy produktów oraz nazwy ich dostawców (78)

SELECT
   P.ProductName AS NazwaProduktu,
   S.CompanyName AS NazwaDostawcy
FROM Products P
LEFT JOIN Suppliers S ON P.SupplierID = S.SupplierID
ORDER BY P.ProductName;

12. Zapytanie zwracające tytuł, imię i nazwisko najmłodszej osoby w każdym z działów,
    przez dział rozumiemy tytuł pracownika (4)

SELECT
   Title AS TytulDzialu,
   FirstName AS Imie,
   LastName AS Nazwisko
FROM Employees E1
WHERE BirthDate = (
   SELECT MAX(BirthDate)
   FROM Employees E2
   WHERE E2.Title = E1.Title
)
ORDER BY Title;



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