BAZY DANYCH - 4i05 - 2025
AUTOR: MATEUSZ MRÓZ 251190

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


SELECT 
   E.Imię AS Imie,
   E.Nazwisko AS Nazwisko,
   COUNT(O.IDzamówienia) AS IloscZamowien
FROM Pracownicy E
JOIN Zamówienia O ON E.IDpracownika = O.IDpracownika
GROUP BY E.IDpracownika, E.Imię, E.Nazwisko
HAVING COUNT(O.IDzamówienia) = (
    SELECT MAX(IloscZamowien)
    FROM (
        SELECT COUNT(O2.IDzamówienia) AS IloscZamowien
        FROM Pracownicy E2
        JOIN Zamówienia O2 ON E2.IDpracownika = O2.IDpracownika
        GROUP BY E2.IDpracownika
    ) AS SubQuery
)
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
