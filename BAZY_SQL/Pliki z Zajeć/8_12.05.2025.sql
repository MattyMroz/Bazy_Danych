--Zapytanie zwracające 3 kolumny :
-- Imię, Nazwisko, ilość zamówień zrealizowanych po terminie.
-- Jedynie osoba z najwiekszą ilością zamówien po terminie.(1)

select Imię, nazwisko, count(IDzamówienia) as ilosc from pracownicy as p
join zamówienia as z on p.IDpracownika = z.IDpracownika
--where DataWysyłki > DataWymagana
group by Imię, Nazwisko
having count(idzamówienia) = (select max(ilosc) from
(select Imię, nazwisko, count(IDzamówienia) as ilosc from pracownicy as p
join zamówienia as z on p.IDpracownika = z.IDpracownika
--where DataWysyłki > DataWymagana
group by Imię, Nazwisko)as t1)






-- zapytanie zwracajace nazwe firmy, ktora zlozyla najdrozsze zamowienie (1.) 
use [north]

 select CompanyName from "Order Details" as ord join orders as od
on ord.OrderID = od.OrderID join Customers as c 
on c.CustomerID=od.CustomerID group by od.OrderID, CompanyName
having sum(quantity*unitprice)=
(select max(sums) from
(select sum(quantity*unitprice) as sums from 
"Order Details" group by OrderID) as temp)

--Zapytanie zwracające 3 kolumny : imię, nazwisko oraz ilość zrealizowanych zamówień. 
--Jedynie pracownicy o największej ilość zamówień.


use [north_pl]

SELECT imię, nazwisko, COUNT(idzamówienia) as 'ile' FROM Zamówienia as z 
JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika 
GROUP BY imię, nazwisko,p.IDpracownika 
HAVING COUNT(idzamówienia) = 
(SELECT MAX(ile) as 'maks' FROM
(SELECT idpracownika, COUNT(idzamówienia) as 'ile' FROM Zamówienia 
GROUP BY idpracownika) as t1)

--Podaj nie powtarzające się pary produktów w 
--tej samej cenie jednostkowej


use [Northwind]
select p1.productname, p2.productname from products p1, 
products p2
where p1.productid<p2.productid and p1.unitprice=p2.unitprice;



-- szukam produktów o nazwie zaczynająca się na dowolną literę, a druga litera
-- zaczyna się od c do p i trzecia literia nie jest g oraz cena produktu zawiera sie 
-- w przedziale 10 -100 bez wartosci  90

SELECT RIGHT ('hello world' , 3) ;
SELECT LEFT ('hello world' , 3) ;
SELECT CHARINDEX (' ','hello world') ;  --- szuka znaku 
SELECT SUBSTRING ('hello world', 4,5) ;

SELECT LEFT ('hello world' ,  CHARINDEX (' ','hello world') -1 )

SELECT SUBSTRING(`nazwa_kolumny`, pozycja[,liczba_znaków])
FROM `nazwa_tabeli`
WHERE `nazwa_tabeli` operator 'wartość'

'__%'


 select Productname,unitprice from products 
 where 
 productname like '__%' and 
 (SUBSTRING(productname,2,1)>'c' and SUBSTRING(productname,2,1)<'p')
 and(SUBSTRING(productname,2,1)>'C' and SUBSTRING(productname,2,1)<'P')
 and SUBSTRING(productname,3,1)<>'g'
 and 
 UnitPrice between '10' and '100' and UnitPrice<> '90';

--Zapytanie zwracajace 3 kolumny : imię, nazwisko, id zamówienia. 
--Jedynie zamówienia z 3 kwartału 1996 zrealizowane po terminie. (5)

select p.Imię,p.Nazwisko, z.IDzamówienia from Pracownicy as p
join zamówienia as z
on p.IDpracownika = z.IDpracownika
where datepart(month, z.DataZamówienia)>6 
and datepart(month, z.DataZamówienia)<10 and datepart(year, z.DataZamówienia)=1996
and z.DataWymagana-z.DataWysyłki<0