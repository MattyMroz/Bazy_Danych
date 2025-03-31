--Zapytanie zwracaj¹ce 3 kolumny :
-- Imiê, Nazwisko, iloœæ zamówieñ zrealizowanych po terminie.
-- Jedynie osoba z najwieksz¹ iloœci¹ zamówien po terminie.(1)

select * from Zamówienia

select Imiê, nazwisko, count(IDzamówienia) as ilosc 
from pracownicy as p join Zamówienia as z
on
p.IDpracownika=z.IDpracownika
group by Imiê, nazwisko 


select Imiê, nazwisko, count(IDzamówienia) as ilosc 
from pracownicy as p join Zamówienia as z
on
p.IDpracownika=z.IDpracownika
where DataWymagana > DataWysy³ki
group by Imiê, nazwisko 

DataZamówienia

select Imiê, nazwisko, count(IDzamówienia) as ilosc 
from pracownicy as p join Zamówienia as z
on
p.IDpracownika=z.IDpracownika
where DataWymagana > DataZamówienia
group by Imiê, nazwisko


select Imiê, nazwisko, count(IDzamówienia) as ilosc 
from pracownicy as p join Zamówienia as z
on
p.IDpracownika=z.IDpracownika
where DataZamówienia < DataWymagana  
group by Imiê, nazwisko



select Imiê, nazwisko, count(IDzamówienia) as ilosc from pracownicy as p
join zamówienia as z on p.IDpracownika = z.IDpracownika
where DataWysy³ki > DataWymagana
group by Imiê, Nazwisko
having count(IDzamówienia) = (select max(ilosc) from
(select Imiê, nazwisko, count(IDzamówienia) 
as ilosc from pracownicy as p
join zamówienia as z on p.IDpracownika = z.IDpracownika
where DataWysy³ki > DataWymagana
group by Imiê, Nazwisko) as t1)




-- (5)select
-- (1)from
-- (2)where
-- (3)group by
-- (4)having
-- (6)order by

use baza

select nazwisko,imie from pracownicy
order by nazwisko

select nazwisko,imie from pracownicy
order by imie

select nazwisko,imie from pracownicy
order by nazwisko asc

select nazwisko,imie from pracownicy
order by imie desc


/*Zapytanie zwracaj¹ce nazwê firmy, która z³o¿y³a najdro¿sze 
zamówienie (QUICK-Stop)*/

SELECT CompanyName FROM 
[Order Details] as ord  JOIN Orders as od 
ON ord.OrderID = od.OrderID  JOIN Customers as c 
ON c.CustomerID = od.CustomerID GROUP BY od.OrderID, CompanyName
HAVING SUM(quantity*unitprice) = 
(SELECT MAX(sums) FROM
(SELECT SUM(quantity*Unitprice) as sums FROM
"Order Details" GROUP BY OrderID) as temp)