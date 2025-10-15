-- 1. Zapytanie zwraca 2 kolumny: imię, nazwisko (pracownik). Jedynie osoby, które zrealizowały najwięcej zamówień w kraju swojego pochodzenia. (1)

SELECT
	E2.FirstName,
	E2.LastName
FROM Employees AS E2
JOIN Orders AS O2 ON E2.EmployeeID = O2.EmployeeID
WHERE E2.Country = O2.ShipCountry
GROUP BY E2.EmployeeID, E2.FirstName, E2.LastName
HAVING COUNT(*) = ( -- Zwraca najwięcej zamówień w kraju
	SELECT MAX(OrderCount) -- Zwraca najwięcej zamówień w kraju
	FROM (
        -- Zliczamy zamówienia w każdym kraju
		SELECT COUNT(*) AS OrderCount
		FROM Employees AS E
		JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
		WHERE E.Country = O.ShipCountry
		GROUP BY E.EmployeeID
	) AS SubQuery
)

SELECT TOP 1 WITH TIES
    E.FirstName,
    E.LastName
FROM Employees AS E
JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
WHERE E.Country = O.ShipCountry
GROUP BY E.EmployeeID, E.FirstName, E.LastName
ORDER BY COUNT(*) DESC


-- 2. Zapytanie zwracające 1 kolumnę: idzamówienia. Jedynie zamówienia, na których ilość produktów równa jest średniej ilości produktów na zamówieniu. (283)

SELECT
    OrderID
FROM [Order Details]
GROUP BY OrderID
HAVING COUNT(ProductID) = (
    -- Obliczamy średnią
    SELECT AVG(ProductCount)
    FROM (
        -- Zliczamy produkty w każdym zamówieniu
        SELECT COUNT(ProductID) AS ProductCount
        FROM [Order Details]
        GROUP BY OrderID
    ) AS SubQuery
)



-- 3. Zapytanie zwracające 2 kolumny: Kraj, Nazwaproduktu. Jedynie produkty najczęściej zamawiane w danym kraju. (46)


SELECT
    O.ShipCountry,
    P.ProductName
FROM Orders AS O
JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
JOIN Products AS P ON OD.ProductID = P.ProductID
GROUP BY O.ShipCountry, P.ProductName
HAVING COUNT(O.OrderID) = (
    SELECT TOP 1
        COUNT(O2.OrderID)
    FROM
    Orders AS O2
    JOIN [Order Details] AS OD2 ON O2.OrderID = OD2.OrderID
    WHERE O2.ShipCountry = O.ShipCountry
    GROUP BY OD2.ProductID
    ORDER BY COUNT(O2.OrderID) DESC
)

SELECT
    O.ShipCountry,
    P.ProductName
FROM Orders AS O
JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
JOIN Products AS P ON OD.ProductID = P.ProductID
GROUP BY O.ShipCountry, P.ProductName
HAVING COUNT(O.OrderID) = (
    SELECT MAX(ProductOrderCount)
    FROM (
        SELECT
            COUNT(O2.OrderID) AS ProductOrderCount
        FROM Orders AS O2
        JOIN [Order Details] AS OD2 ON O2.OrderID = OD2.OrderID
        WHERE O2.ShipCountry = O.ShipCountry
        GROUP BY OD2.ProductID
    ) AS SubQuery
)


-- 4. Zapytanie zwracające 3 kolumny: imię, nazwisko, ilość zrealizowanych zamówień w 1997. Jedynie pracownicy, którzy w roku 1997 wykonali więcej niż wynosiła średnia ilość zrealizowanych zamówień na pracownika. (4)


SELECT
    E.FirstName,
    E.LastName,
    COUNT(O.OrderID) AS IloscZamowien1997 -- Zliczamy zamówienia dla każdego pracownika
FROM Employees AS E
JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
WHERE YEAR(O.OrderDate) = 1997 -- Filtrujemy zamówienia tylko z roku 1997
GROUP BY E.FirstName, E.LastName
HAVING COUNT(O.OrderID) > (
    -- Podzapytanie obliczające średnią liczbę zamówień na pracownika w 1997
    SELECT AVG(IloscZamowien)
    FROM (
        -- Podzapytanie zliczające zamówienia dla każdego pracownika w 1997
        SELECT COUNT(OrderID) AS IloscZamowien
        FROM Orders
        WHERE YEAR(OrderDate) = 1997
        GROUP BY EmployeeID
    ) AS SubQuery
)


-- 5. Zapytanie zwracające 3 kolumny: Nazwa firmy (dostawca), Nazwa kategorii, ilość produktów dostarczanych w danej kategorii przez wskazaną firmę. Jedynie dostawcy z USA. (5)

SELECT
    S.CompanyName,
    C.CategoryName,
    COUNT(P.ProductID) AS 'ProductCount'
FROM Suppliers AS S
JOIN Products AS P ON S.SupplierID = P.SupplierID
JOIN Categories AS C ON P.CategoryID = C.CategoryID
WHERE S.Country = 'USA'
GROUP BY S.CompanyName, C.CategoryName


-- 6. Zapytanie zwracające numer miesiąca, w którym firma odnotowuje (sumarycznie) największe obroty (4)
SELECT
    MONTH(O.OrderDate) AS NumerMiesiaca
FROM Orders AS O
JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
GROUP BY MONTH(O.OrderDate)
HAVING SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) = (
    -- Podzapytanie zwracające najwyższą sumaryczną wartość obrotów z dowolnego miesiąca
    SELECT MAX(SumaObrotow)
    FROM (
        -- Podzapytanie obliczające sumę obrotów dla każdego miesiąca
        SELECT
            SUM(OD2.UnitPrice * OD2.Quantity * (1 - OD2.Discount)) AS SumaObrotow
        FROM Orders AS O2
        JOIN [Order Details] AS OD2 ON O2.OrderID = OD2.OrderID
        GROUP BY MONTH(O2.OrderDate)
    ) AS SubQuery
)



-- 7. Zapytanie zwracające 2 kolumny: nazwę kategorii oraz nazwę produktu. Jedynie najdroższe produkty dla każdej z kategorii. (8)

SELECT
    C.CategoryName,
    P.ProductName
FROM Categories AS C
JOIN Products AS P ON C.CategoryID = P.CategoryID
WHERE P.UnitPrice = (
    -- Podzapytanie skorelowane: znajduje maksymalną cenę produktu
    -- dla kategorii z zapytania głównego
    SELECT MAX(P2.UnitPrice)
    FROM Products AS P2
    WHERE P2.CategoryID = C.CategoryID
)


-- 8. Zapytanie zwracające 2 kolumny: Kraj (klient), NazwaFirmy (spedytor). Jedynie najczęściej wykorzystywani spedytorzy na terenie danego kraju. (23)


SELECT
    O.ShipCountry,
    S.CompanyName
FROM Orders AS O
JOIN Shippers AS S ON O.ShipVia = S.ShipperID
GROUP BY O.ShipCountry, S.CompanyName
HAVING COUNT(O.OrderID) = (
    -- Podzapytanie skorelowane: znajduje maksymalną liczbę zamówień
    -- obsłużonych przez jednego spedytora w danym kraju (z zapytania głównego)
    SELECT MAX(LiczbaZamowien)
    FROM (
        -- Podzapytanie zliczające zamówienia dla każdego spedytora
        -- w kraju z zapytania głównego
        SELECT
            COUNT(O2.OrderID) AS LiczbaZamowien
        FROM Orders AS O2
        WHERE O2.ShipCountry = O.ShipCountry -- Korelacja z zapytaniem głównym
        GROUP BY O2.ShipVia
    ) AS SubQuery
)


-- 9. Dodaj kolumnę tekstową login1 do tabeli pracownicy.
--    Przy tworzeniu nowego pracownika lub modyfikacji istniejącego w tabeli pracownicy ustawiaj wartość kolumny login1 na pierwszą i ostatnią literę z imienia i pierwszą i ostatnią literą nazwiska. W tak stworzonej wartości zastosuj wielkie litery.
--    Przykład dla osoby: Tomasz Pawlak login1 będzie składał się z TZPK

ALTER TABLE Employees
ADD login1 VARCHAR(4) NULL;


CREATE TRIGGER trg_UstawLoginPracownika
ON Employees
AFTER INSERT, UPDATE
AS
BEGIN
    -- Wyłącza zwracanie liczby zmodyfikowanych wierszy, co jest dobrą praktyką w wyzwalaczach
    SET NOCOUNT ON;

    -- Sprawdzamy, czy kolumny imienia lub nazwiska zostały zmienione (opcjonalna optymalizacja)
    IF UPDATE(FirstName) OR UPDATE(LastName)
    BEGIN
        -- Aktualizujemy kolumnę login1 tylko dla tych wierszy,
        -- które zostały właśnie wstawione lub zmodyfikowane.
        -- Dostęp do nich mamy poprzez wirtualną tabelę 'inserted'.
        UPDATE E
        SET
            E.login1 = UPPER(
                LEFT(i.FirstName, 1) +   -- Pierwsza litera imienia
                RIGHT(i.FirstName, 1) +  -- Ostatnia litera imienia
                LEFT(i.LastName, 1) +    -- Pierwsza litera nazwiska
                RIGHT(i.LastName, 1)     -- Ostatnia litera nazwiska
            )
        FROM Employees AS E
        JOIN inserted AS i ON E.EmployeeID = i.EmployeeID;
    END
END;


UPDATE Employees
SET
    login1 = UPPER(
        LEFT(FirstName, 1) +
        RIGHT(FirstName, 1) +
        LEFT(LastName, 1) +
        RIGHT(LastName, 1)
    );

SELECT
    FirstName,
    LastName,
    login1
FROM Employees;


-- 10. Do tabeli działy dopisz kolumnę data_przyjęcia.
--     Przy tworzeniu nowego pracownika z ustawionym działem ustawiaj wartość kolumny data_przyjęcia dla zadanego działu wpisując w nią komunikat z obecną datą oraz imieniem i nazwiskiem pracownika.
--     Format komunikatu:
--     'Ostatni zatrudniony pracownik Jan Kowalski: Dec 18 2006  9:01PM'


CREATE TABLE Dzialy (
    DzialID INT PRIMARY KEY IDENTITY(1,1),
    NazwaDzialu NVARCHAR(50) NOT NULL,
    data_przyjęcia NVARCHAR(255) NULL
);

INSERT INTO Dzialy (NazwaDzialu) VALUES ('Sales'), ('IT'), ('Human Resources'), ('Management');

ALTER TABLE Employees
ADD DzialID INT NULL;

ALTER TABLE Employees
ADD CONSTRAINT FK_Employees_Dzialy
FOREIGN KEY (DzialID) REFERENCES Dzialy(DzialID);

UPDATE Employees SET DzialID = 1 WHERE Title LIKE '%Sales%'; -- Sales
UPDATE Employees SET DzialID = 4 WHERE Title LIKE '%Manager%'; -- Management

CREATE TRIGGER trg_AktualizujDatePrzyjeciaWDziale
ON Employees
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Zmienne do przechowania danych nowego pracownika
    DECLARE @DzialID INT;
    DECLARE @Imie NVARCHAR(50);
    DECLARE @Nazwisko NVARCHAR(50);

    -- Pobieramy dane z wirtualnej tabeli 'inserted',
    -- która zawiera dane nowo wstawionego wiersza.
    SELECT
        @DzialID = i.DzialID,
        @Imie = i.FirstName,
        @Nazwisko = i.LastName
    FROM inserted AS i;

    -- Sprawdzamy, czy pracownikowi przypisano dział.
    -- Jeśli tak, aktualizujemy tabelę Dzialy.
    IF @DzialID IS NOT NULL
    BEGIN
        UPDATE Dzialy
        SET
            data_przyjęcia = 'Ostatni zatrudniony pracownik ' + @Imie + ' ' + @Nazwisko + ': ' +
                             CONVERT(NVARCHAR(30), GETDATE(), 100)
        WHERE DzialID = @DzialID;
    END
END;

SELECT * FROM Dzialy WHERE DzialID = 2;

INSERT INTO Employees (LastName, FirstName, Title, HireDate, DzialID)
VALUES ('Kowalski', 'Jan', 'Developer', GETDATE(), 2);

SELECT * FROM Dzialy WHERE DzialID = 2;

-- 11. Utwórz procedurę, która wyświetli w formie tekstowej (w oknie messages) wszystkich pracowników i liczbę ich wypłat. Pod uwagę bierz tylko tych pracowników, którzy posiadają więcej niż X (gdzie X to pierwszy parametr procedury) wpisów w tabeli zarobki. Dodatkowo wybierz tylko te wpisy, które zostały stworzone po dacie podanej w drugim parametrze. W przypadku nie podania w wywołaniu procedury drugiego parametru nie uwzględniaj kryterium daty.
--     Przykładowy wynik wywołania:
--     'Pracownik Jan Kowalski od dnia Jan  1 2001 12:00AM otrzymał 5 wypłat'
--     lub
--     'Pracownik Jan Kowalski otrzymał 5 wypłat'


-- 1. Tworzenie tabeli Zarobki
CREATE TABLE Zarobki (
    ZarobekID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL,
    Kwota MONEY NOT NULL,
    DataWyplaty DATE NOT NULL,
    CONSTRAINT FK_Zarobki_Employees FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
GO

-- 2. Wypełnienie tabeli przykładowymi danymi
-- Pracownik ID 1 (Nancy Davolio)
INSERT INTO Zarobki (EmployeeID, Kwota, DataWyplaty) VALUES
(1, 2500, '2022-01-15'), (1, 2500, '2022-02-15'), (1, 2600, '2022-03-15'),
(1, 2600, '2022-04-15'), (1, 2600, '2022-05-15');

-- Pracownik ID 2 (Andrew Fuller)
INSERT INTO Zarobki (EmployeeID, Kwota, DataWyplaty) VALUES
(2, 3000, '2021-12-15'), (2, 3000, '2022-01-15'), (2, 3100, '2022-02-15');

-- Pracownik ID 3 (Janet Leverling)
INSERT INTO Zarobki (EmployeeID, Kwota, DataWyplaty) VALUES
(3, 2800, '2022-01-15'), (3, 2800, '2022-02-15'), (3, 2900, '2022-03-15'),
(3, 2900, '2022-04-15'), (3, 2900, '2022-05-15'), (3, 2900, '2022-06-15');
GO


CREATE PROCEDURE sp_WyswietlWyplatyPracownikow
    -- Parametr 1: Minimalna liczba wypłat (wymagany)
    @minLiczbaWyplat INT,
    -- Parametr 2: Data, od której liczymy wypłaty (opcjonalny)
    @dataOd DATE = NULL
AS
BEGIN
    -- Wyłącza zwracanie liczby zmodyfikowanych wierszy
    SET NOCOUNT ON;

    -- Zmienne do przechowywania danych z kursora
    DECLARE @Imie NVARCHAR(50);
    DECLARE @Nazwisko NVARCHAR(50);
    DECLARE @LiczbaWyplat INT;
    DECLARE @Komunikat NVARCHAR(200);

    -- Deklaracja kursora, który pobierze pasujących pracowników i liczbę ich wypłat
    DECLARE kursor_pracownikow CURSOR FOR
        SELECT
            E.FirstName,
            E.LastName,
            COUNT(Z.ZarobekID) AS LiczbaWyplat
        FROM Employees AS E
        JOIN Zarobki AS Z ON E.EmployeeID = Z.EmployeeID
        WHERE
            -- Warunek daty: jest ignorowany, jeśli @dataOd jest NULL
            (@dataOd IS NULL OR Z.DataWyplaty >= @dataOd)
        GROUP BY E.EmployeeID, E.FirstName, E.LastName
        HAVING
            -- Warunek na minimalną liczbę wypłat
            COUNT(Z.ZarobekID) > @minLiczbaWyplat;

    -- Otwarcie kursora
    OPEN kursor_pracownikow;

    -- Pobranie pierwszego wiersza
    FETCH NEXT FROM kursor_pracownikow INTO @Imie, @Nazwisko, @LiczbaWyplat;

    -- Pętla przetwarzająca wszystkie wiersze z kursora
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Budowanie komunikatu w zależności od tego, czy podano datę
        IF @dataOd IS NOT NULL
        BEGIN
            -- Wersja z datą
            SET @Komunikat = 'Pracownik ' + @Imie + ' ' + @Nazwisko +
                             ' od dnia ' + CONVERT(NVARCHAR, @dataOd, 100) +
                             ' otrzymał ' + CAST(@LiczbaWyplat AS NVARCHAR) + ' wypłat';
        END
        ELSE
        BEGIN
            -- Wersja bez daty
            SET @Komunikat = 'Pracownik ' + @Imie + ' ' + @Nazwisko +
                             ' otrzymał ' + CAST(@LiczbaWyplat AS NVARCHAR) + ' wypłat';
        END

        -- Wyświetlenie komunikatu w oknie "Messages"
        PRINT @Komunikat;

        -- Pobranie kolejnego wiersza
        FETCH NEXT FROM kursor_pracownikow INTO @Imie, @Nazwisko, @LiczbaWyplat;
    END

    -- Zamknięcie i zwolnienie kursora
    CLOSE kursor_pracownikow;
    DEALLOCATE kursor_pracownikow;
END;
GO


EXEC sp_WyswietlWyplatyPracownikow @minLiczbaWyplat = 4;


EXEC sp_WyswietlWyplatyPracownikow @minLiczbaWyplat = 2, @dataOd = '2022-03-01';



-- 12. Procedura wybierająca nazwiska pracowników, których średnie zarobki są najwyższe lub równe parametru wejściowemu
--     Albo (Procedura wybierająca pracowników, których średnie zarobki są najwyższe lub najniższe) (zakładamy unikatowość nazwisk pracowników)

-- Upewnij się, że tabela istnieje
IF OBJECT_ID('Zarobki', 'U') IS NULL
BEGIN
    CREATE TABLE Zarobki (
        ZarobekID INT PRIMARY KEY IDENTITY(1,1),
        EmployeeID INT NOT NULL,
        Kwota MONEY NOT NULL,
        DataWyplaty DATE NOT NULL,
        CONSTRAINT FK_Zarobki_Employees FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
    );

    -- Wypełnienie tabeli przykładowymi danymi
    INSERT INTO Zarobki (EmployeeID, Kwota, DataWyplaty) VALUES
    (1, 2500, '2022-01-15'), (1, 2500, '2022-02-15'), (1, 2600, '2022-03-15'), (1, 2600, '2022-04-15'), (1, 2600, '2022-05-15'), -- Średnia: 2560
    (2, 3500, '2021-12-15'), (2, 3500, '2022-01-15'), (2, 3600, '2022-02-15'), -- Średnia: 3533.33
    (3, 2800, '2022-01-15'), (3, 2800, '2022-02-15'), (3, 2900, '2022-03-15'), -- Średnia: 2833.33
    (4, 2560, '2022-01-15'), (4, 2560, '2022-02-15'); -- Średnia: 2560 (taka sama jak najniższa)
END
GO


CREATE PROCEDURE sp_WybierzPracownikowEkstremalnychZarobkow
AS
BEGIN
    SET NOCOUNT ON;

    -- Wybieramy nazwiska pracowników, których średnie zarobki
    -- są równe najwyższej lub najniższej średniej ze wszystkich pracowników.
    SELECT
        E.LastName
    FROM Employees AS E
    JOIN Zarobki AS Z ON E.EmployeeID = Z.EmployeeID
    GROUP BY E.LastName
    HAVING AVG(Z.Kwota) IN (
        -- Podzapytanie 1: Znajduje NAJWYŻSZĄ średnią pensję
        (SELECT MAX(SrednieZarobki.Srednia)
         FROM (
             SELECT AVG(Kwota) AS Srednia
             FROM Zarobki
             GROUP BY EmployeeID
         ) AS SrednieZarobki),

        -- Podzapytanie 2: Znajduje NAJNIŻSZĄ średnią pensję
        (SELECT MIN(SrednieZarobki.Srednia)
         FROM (
             SELECT AVG(Kwota) AS Srednia
             FROM Zarobki
             GROUP BY EmployeeID
         ) AS SrednieZarobki)
    );
END;
GO

EXEC sp_WybierzPracownikowEkstremalnychZarobkow;


lub


CREATE PROCEDURE sp_WybierzPracownikowWgSrednichZarobkow
    @progZarobkow MONEY
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        E.LastName
    FROM Employees AS E
    JOIN Zarobki AS Z ON E.EmployeeID = Z.EmployeeID
    GROUP BY E.LastName
    HAVING AVG(Z.Kwota) >= @progZarobkow;
END;
GO

EXEC sp_WybierzPracownikowWgSrednichZarobkow @progZarobkow = 3000;