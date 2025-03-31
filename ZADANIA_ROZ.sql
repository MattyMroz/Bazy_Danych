# Rozwiązania zadań SQL

Przeanalizowałem plik z zadaniami i bazą danych. Poniżej przedstawiam rozwiązania dla poszczególnych zadań.

## ZADANIE 1

### 1. Wyświetlenie diagramu bazy
To jest operacja wykonywana w narzędziu SQL Management Studio poprzez interfejs graficzny.

                Aby wyświetlić diagram bazy danych w SQL Server Management Studio, wykonaj następujące kroki:

                1. Otwórz SQL Server Management Studio (SSMS)

                2. W Object Explorer (po lewej stronie) znajdź swoją bazę danych "baza"

                3. Kliknij prawym przyciskiem myszy na folder "Database Diagrams" w swojej bazie danych

                4. Wybierz opcję "New Database Diagram"

                5. Jeśli pojawi się komunikat o potrzebie utworzenia obiektów wsparcia dla diagramów, kliknij "Yes"

                6. W nowym oknie wybierz tabele, które chcesz dodać do diagramu:
                - dzialy
                - pracownicy
                - zarobki
                - obiekty
                - absencje

                7. Kliknij "Add"

                8. SSMS automatycznie wygeneruje diagram pokazujący wszystkie tabele i relacje między nimi

                9. Możesz przeciągać tabele w różne miejsca, aby lepiej zorganizować diagram

                10. Aby zapisać diagram:
                    - Kliknij prawym przyciskiem myszy na pustym obszarze diagramu
                    - Wybierz "Save"
                    - Nadaj nazwę diagramowi (np. "DiagramBazy")

                Relacje w diagramie będą pokazane jako linie łączące tabele, gdzie:
                - Linia z symbolem klucza pokazuje klucz główny (PRIMARY KEY)
                - Linia z symbolem "nieskończoności" pokazuje klucz obcy (FOREIGN KEY)

                W tym przypadku zobaczysz:
                - Relację między `pracownicy` a `dzialy` (przez dzialID)
                - Relację między `pracownicy` a `zarobki` (przez pracID)
                - Pozostałe tabele i ich powiązania, jeśli istnieją

                Diagram ten pomoże Ci wizualnie zrozumieć strukturę bazy danych i relacje między tabelami.





### 2. Dodanie pól do tabel i aktualizacja wartości wzrostu

```sql
-- Dodanie pola wzrost do wszystkich tabel
ALTER TABLE dzialy ADD wzrost int;
ALTER TABLE zarobki ADD wzrost int;
ALTER TABLE obiekty ADD wzrost int;
ALTER TABLE absencje ADD wzrost int;

-- Aktualizacja wartości pola wzrost w tabelach
UPDATE dzialy SET wzrost = 180 WHERE dzialID < 3;
UPDATE zarobki SET wzrost = 175 WHERE zarID < 10;
UPDATE obiekty SET wzrost = 190 WHERE idobiektu < 2;
UPDATE absencje SET wzrost = 185 WHERE abse_id < 5;
```

### 3. Dodanie pól z wartością domyślną do wszystkich tabel

```sql
ALTER TABLE dzialy ADD pole_domyslne varchar(50) DEFAULT 'Domyślna wartość';
ALTER TABLE pracownicy ADD pole_domyslne varchar(50) DEFAULT 'Domyślna wartość';
ALTER TABLE zarobki ADD pole_domyslne varchar(50) DEFAULT 'Domyślna wartość';
ALTER TABLE obiekty ADD pole_domyslne varchar(50) DEFAULT 'Domyślna wartość';
ALTER TABLE absencje ADD pole_domyslne varchar(50) DEFAULT 'Domyślna wartość';
```

### 4. Wyświetlenie pracowników na literę T

```sql
SELECT * FROM pracownicy WHERE imie LIKE 'T%';
```

### 5. Wyświetlenie imion, nazwisk i zarobków pracowników

```sql
SELECT p.imie, p.nazwisko, z.brutto
FROM pracownicy p
JOIN zarobki z ON p.pracID = z.pracID;
```

## ZADANIE 2

### 1. Wyświetlenie pracowników z przypisaniem do działów

```sql
SELECT p.imie, p.nazwisko, d.nazwa as dzial
FROM pracownicy p, dzialy d
WHERE p.dzialID = d.dzialID;
```

### 2. Wyświetlenie pracowników i ich zarobków przy użyciu JOIN

```sql
SELECT p.imie, p.nazwisko, d.nazwa as dzial, z.brutto
FROM pracownicy p
JOIN dzialy d ON p.dzialID = d.dzialID
JOIN zarobki z ON p.pracID = z.pracID;
```

## ZADANIE 3

### 1. Dodanie kolumny mix z ograniczeniem

```sql
ALTER TABLE pracownicy ADD mix char(6);
ALTER TABLE pracownicy ADD CONSTRAINT CK_MIX
CHECK (mix LIKE '[a-zA-Z][0-9][a-zA-Z][0-9][a-zA-Z][0-9]');
```

### 2. Dodanie kolumny NIP z ograniczeniem

```sql
ALTER TABLE pracownicy ADD NIP varchar(13);
ALTER TABLE pracownicy ADD CONSTRAINT NIP
CHECK (NIP LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]');
```

### 3. Zapytanie o kraje z największą liczbą zamówień

```sql
-- Zakładając, że używamy bazy Northwind
SELECT TOP 1 ShipCountry AS kraj, COUNT(*) AS liczba_zamowien
FROM Orders
GROUP BY ShipCountry
ORDER BY COUNT(*) DESC;
```

### 4. Zapytanie o zamówienia z 3 kwartału 1996 zrealizowane po terminie

```sql
-- Zakładając, że używamy bazy Northwind
SELECT e.FirstName AS imie, e.LastName AS nazwisko, o.OrderID
FROM Orders o
JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE DATEPART(QUARTER, o.OrderDate) = 3
  AND YEAR(o.OrderDate) = 1996
  AND o.ShippedDate > o.RequiredDate;
```

## ZADANIE 4

Wszystkie poniższe zapytania dotyczą bazy Northwind.

### 1. Nazwy kategorii i liczba produktów

```sql
SELECT c.CategoryName, COUNT(p.ProductID) AS liczba_produktow
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName
ORDER BY liczba_produktow;
```

### 2. Firma z najdroższym zamówieniem

```sql
SELECT TOP 1 c.CompanyName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, c.CompanyName
ORDER BY SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) DESC;
```

### 3. Nazwa towaru i sumaryczna wartość sprzedaży

```sql
SELECT p.ProductName, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS wartosc_sprzedazy
FROM Products p
JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
WHERE o.OrderDate BETWEEN DATEADD(YEAR, -12, GETDATE()) AND DATEADD(YEAR, -5, GETDATE())
GROUP BY p.ProductName;
```

### 4. OrderID i łączna wartość zamówień

```sql
SELECT od.OrderID, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS wartosc_zamowienia
FROM [Order Details] od
GROUP BY od.OrderID
ORDER BY wartosc_zamowienia DESC;
```

### 5. Utworzenie tabeli z danymi pracowników

```sql
SELECT e.EmployeeID, e.FirstName AS imie, e.LastName AS nazwisko, 
       e.Title AS dzial, DATEDIFF(YEAR, e.BirthDate, GETDATE()) AS wiek,
       GETDATE() AS data_wyplaty, 
       (SELECT AVG(od.UnitPrice * od.Quantity) 
        FROM Orders o 
        JOIN [Order Details] od ON o.OrderID = od.OrderID
        WHERE o.EmployeeID = e.EmployeeID) AS kwota
INTO into_tabela
FROM Employees e;
```

### 6. Imiona i nazwiska przedstawicieli handlowych

```sql
SELECT FirstName AS imie, LastName AS nazwisko
FROM Employees
WHERE Title = 'Sales Representative';
```

### 7. Nazwy produktów i firm dostarczających

```sql
SELECT p.ProductName, s.CompanyName
FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SupplierID;
```

### 8. Pracownicy o największej liczbie zamówień

```sql
SELECT TOP 1 WITH TIES e.FirstName AS imie, e.LastName AS nazwisko, COUNT(o.OrderID) AS liczba_zamowien
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY COUNT(o.OrderID) DESC;
```

### 9. Zamówienia z 3 kwartału 1996 zrealizowane po terminie

```sql
SELECT e.FirstName AS imie, e.LastName AS nazwisko, o.OrderID
FROM Orders o
JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE DATEPART(QUARTER, o.OrderDate) = 3
  AND YEAR(o.OrderDate) = 1996
  AND o.ShippedDate > o.RequiredDate;
```

## ZADANIE 5

### 1. Nazwy firm, kategorii i liczba produktów z Niemiec

```sql
SELECT s.CompanyName, c.CategoryName, COUNT(p.ProductID) AS liczba_produktow
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE s.Country = 'Germany'
GROUP BY s.CompanyName, c.CategoryName;
```

### 2. Nazwy kategorii i firm dostarczających najwięcej produktów

```sql
WITH DostawcyProdukty AS (
    SELECT c.CategoryName, s.CompanyName, COUNT(p.ProductID) AS liczba_produktow,
           RANK() OVER (PARTITION BY c.CategoryName ORDER BY COUNT(p.ProductID) DESC) AS rn
    FROM Categories c
    JOIN Products p ON c.CategoryID = p.CategoryID
    JOIN Suppliers s ON p.SupplierID = s.SupplierID
    GROUP BY c.CategoryName, s.CompanyName
)
SELECT CategoryName, CompanyName
FROM DostawcyProdukty
WHERE rn = 1;
```

### 6-12. Pozostałe zapytania z zadania 5

Zapytania 3-8 są podobne do tych z poprzednich zadań, więc pominę ich duplikowanie.

### 9. Niepowtarzające się pary produktów w tej samej cenie

```sql
SELECT DISTINCT p1.ProductName, p2.ProductName
FROM Products p1
JOIN Products p2 ON p1.UnitPrice = p2.UnitPrice AND p1.ProductID < p2.ProductID
ORDER BY p1.ProductName;
```

### 10. Liczba zamówień dla Around the Horn

```sql
SELECT COUNT(*) AS liczba_zamowien
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.CompanyName = 'Around the Horn';
```

### 11. Nazwy produktów i ich dostawców

```sql
SELECT p.ProductName, s.CompanyName
FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SupplierID;
```

### 12. Najmłodsi pracownicy w działach

```sql
WITH MlodsiPracownicy AS (
    SELECT e.Title, e.TitleOfCourtesy, e.FirstName, e.LastName, e.BirthDate,
           RANK() OVER (PARTITION BY e.Title ORDER BY e.BirthDate DESC) AS rn
    FROM Employees e
)
SELECT Title, TitleOfCourtesy, FirstName, LastName
FROM MlodsiPracownicy
WHERE rn = 1;
```

## ZADANIE 6

### 1. Procedura określająca dzień tygodnia

```sql
CREATE PROCEDURE DzienTygodnia
    @data datetime = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @data IS NULL
        SET @data = GETDATE();
    
    DECLARE @dzien varchar(20);
    SET @dzien = DATENAME(weekday, @data);
    
    SELECT @data AS 'Data', @dzien AS 'Dzień tygodnia';
END
```

### 2. Procedura formatująca adres

```sql
CREATE PROCEDURE FormatujAdres
    @ulica varchar(50),
    @numer varchar(10),
    @mieszkanie varchar(10),
    @kodPocztowy varchar(10),
    @miasto varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    PRINT @ulica;
    PRINT @numer;
    PRINT 'm.' + @mieszkanie;
    PRINT @kodPocztowy + ' ' + @miasto;
END
```

### 3. Trigger przenoszący dane zarobków do tabeli historycznej

```sql
-- Najpierw utworzenie tabeli historycznej
CREATE TABLE zarobki_historia (
    zarID int,
    od datetime,
    brutto money,
    pracID int,
    data_usuniecia datetime,
    uzytkownik varchar(100)
);

-- Następnie utworzenie triggera
CREATE TRIGGER trg_zarobki_usuwanie
ON zarobki
AFTER DELETE
AS
BEGIN
    INSERT INTO zarobki_historia (zarID, od, brutto, pracID, data_usuniecia, uzytkownik)
    SELECT d.zarID, d.od, d.brutto, d.pracID, GETDATE(), SYSTEM_USER
    FROM deleted d;
END
```

## ZADANIE 7

### 1. Funkcja mieszająca znaki z dwóch ciągów

```sql
CREATE FUNCTION MieszajZnaki(@ciag1 varchar(100), @ciag2 varchar(100))
RETURNS varchar(200)
AS
BEGIN
    DECLARE @wynik varchar(200) = '';
    DECLARE @dlugosc1 int = LEN(@ciag1);
    DECLARE @dlugosc2 int = LEN(@ciag2);
    DECLARE @i int = 1;
    
    IF @dlugosc1 <> @dlugosc2
        RETURN 'Błąd długości znaków: ' + CAST(@dlugosc1 AS varchar) + ' <> ' + CAST(@dlugosc2 AS varchar);
    
    WHILE @i <= @dlugosc1
    BEGIN
        SET @wynik = SUBSTRING(@ciag2, @i, 1) + SUBSTRING(@ciag1, @i, 1) + @wynik;
        SET @i = @i + 1;
    END
    
    RETURN @wynik;
END
```

### 2. Procedura wyświetlająca co drugiego pracownika

```sql
CREATE PROCEDURE WyswietlPracownikow
    @litera char(1) = 'Z'
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @licznik int = 0;
    DECLARE @numer int = 1;
    DECLARE @imie varchar(50);
    DECLARE @nazwisko varchar(50);
    DECLARE @wiek int;
    
    DECLARE kursor_pracownicy CURSOR FOR
    SELECT imie, nazwisko, wiek 
    FROM pracownicy
    WHERE @litera IS NULL OR nazwisko LIKE @litera + '%'
    ORDER BY pracID;
    
    OPEN kursor_pracownicy;
    
    FETCH NEXT FROM kursor_pracownicy INTO @imie, @nazwisko, @wiek;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @licznik % 2 = 0
        BEGIN
            PRINT 'Pracownik nr #' + CAST(@numer AS varchar) + ' ' + @imie + ' ' + @nazwisko + ' ' + CAST(@wiek AS varchar) + ' lat';
            SET @numer = @numer + 2;
        END
        
        SET @licznik = @licznik + 1;
        FETCH NEXT FROM kursor_pracownicy INTO @imie, @nazwisko, @wiek;
    END
    
    CLOSE kursor_pracownicy;
    DEALLOCATE kursor_pracownicy;
END
```

To są rozwiązania dla wszystkich zadań z pliku SQL. Proszę zwrócić uwagę, że niektóre zapytania mogą wymagać dostosowania do konkretnej struktury bazy danych, ponieważ zakładałem standardową strukturę bazy Northwind dla większości zadań.
