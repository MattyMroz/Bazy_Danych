BAZY DANYCH - 4i05 - 2025
AUTOR: MATEUSZ MRÓZ 251190

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
   wpisanie następującej wartości 727 002 18 95 dla wartości znaków i liczb określonej dla
   dowolnego znaku i liczb z przedziału 0-9. Nazwij to ograniczenie NIP.

ALTER TABLE pracownicy
ADD NIP VARCHAR(13) NULL;

ALTER TABLE pracownicy
ADD CONSTRAINT CK_NIP CHECK (NIP LIKE '[0-9][0-9][0-9] [0-9][0-9][0-9] [0-9][0-9] [0-9][0-9]');

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


SELECT
    ShipCountry,
    COUNT(OrderID) AS numberOfOrders
FROM Orders
WHERE ShipCountry IS NOT NULL
GROUP BY ShipCountry
HAVING COUNT(OrderID) = (
    SELECT MAX(liczbaZamowien)
    FROM (
        SELECT COUNT(OrderID) AS liczbaZamowien
        FROM Orders
        GROUP BY ShipCountry
    ) AS Counts
);



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
