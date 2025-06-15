use [north]
select
    CompanyName,
    CustomerID,
    City,
    Country,
    ContactName
from
    Customers
where
    country = 'Brazil'
select
    City,
    count (CustomerID) as CustQty
from
    Customers
where
    country = 'Brazil'
group by
    City
select
    City,
    count (CustomerID) as CustQty
from
    Customers
where
    country = 'Brazil'
group by
    City
having
    count(CustomerID) > 1
select
    Country,
    City,
    COUNT(CustomerID) as CustQty
from
    dbo.Customers
GROUP BY
    Country,
    City
HAVING
    Country = 'Brazil'
    AND COUNT(CustomerID) > 1
    /*Zapytanie zwracające nazwę firmy, która złożyła najdroższe zamówienie (QUICK-Stop)*/
SELECT
    CompanyName
FROM
    "Order Details" as ord
    JOIN Orders as od ON ord.OrderID = od.OrderID
    JOIN Customers as c ON c.CustomerID = od.CustomerID
GROUP BY
    od.OrderID,
    CompanyName
HAVING
    SUM(quantity * unitprice) = (
        SELECT
            MAX(sums)
        FROM
            (
                SELECT
                    SUM(quantity * Unitprice) as sums
                FROM
                    "Order Details"
                GROUP BY
                    OrderID
            ) as temp
    )
    /*Zapytanie zwracające nazwę kategorii zawierającej najwięcej produktów (Confections)*/
SELECT
    CategoryName
FROM
    Products as p
    JOIN Categories as c ON p.CategoryID = c.CategoryID
GROUP BY
    c.CategoryID,
    CategoryName
HAVING
    COUNT(productID) = (
        SELECT
            MAX(ile)
        FROM
            (
                SELECT
                    COUNT(ProductID) as ile
                FROM
                    Products
                GROUP BY
                    CategoryID
            ) as temp
    ) use [north_pl]
    
    -- zapytanie zwracajace 2 kolumny ; kraj oraz ilosc 
    --zamowien z niego realizowanych, jedynie kraje o 
    --najwiekszej liczbie zamowien(1) 
SELECT
    Kraj,
    COUNT (Idzamówienia) as 'ile'
FROM
    zamówienia as z
    JOIN Klienci as k ON z.IDklienta = k.IDklienta
GROUP BY
    kraj
HAVING
    COUNT (Idzamówienia) = (
        SELECT
            MAX(ile) as 'maks'
        FROM
            (
                SELECT
                    Kraj,
                    COUNT(IDzamówienia) as 'ile'
                FROM
                    zamówienia as z
                    JOIN Klienci as k ON z.IDklienta = k.IDKlienta
                GROUP BY
                    Kraj
            ) as t1
    );

--Zapytanie zwracające 3 kolumny :
-- Imię, Nazwisko, ilość zamówień zrealizowanych po terminie.
-- Jedynie osoba z najwiekszą ilością zamówien po terminie.(1)