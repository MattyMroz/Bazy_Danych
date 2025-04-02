BAZY DANYCH - 4i05 - 2025
AUTOR: MATEUSZ MRÓZ 251190

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