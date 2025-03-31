--Zapytanie zwracaj�ce 3 kolumny :
-- Imi�, Nazwisko, ilo�� zam�wie� zrealizowanych po terminie.
-- Jedynie osoba z najwieksz� ilo�ci� zam�wien po terminie.(1)

select * from Zam�wienia

select Imi�, nazwisko, count(IDzam�wienia) as ilosc 
from pracownicy as p join Zam�wienia as z
on
p.IDpracownika=z.IDpracownika
group by Imi�, nazwisko 


select Imi�, nazwisko, count(IDzam�wienia) as ilosc 
from pracownicy as p join Zam�wienia as z
on
p.IDpracownika=z.IDpracownika
where DataWymagana > DataWysy�ki
group by Imi�, nazwisko 

DataZam�wienia

select Imi�, nazwisko, count(IDzam�wienia) as ilosc 
from pracownicy as p join Zam�wienia as z
on
p.IDpracownika=z.IDpracownika
where DataWymagana > DataZam�wienia
group by Imi�, nazwisko


select Imi�, nazwisko, count(IDzam�wienia) as ilosc 
from pracownicy as p join Zam�wienia as z
on
p.IDpracownika=z.IDpracownika
where DataZam�wienia < DataWymagana  
group by Imi�, nazwisko



select Imi�, nazwisko, count(IDzam�wienia) as ilosc from pracownicy as p
join zam�wienia as z on p.IDpracownika = z.IDpracownika
where DataWysy�ki > DataWymagana
group by Imi�, Nazwisko
having count(IDzam�wienia) = (select max(ilosc) from
(select Imi�, nazwisko, count(IDzam�wienia) 
as ilosc from pracownicy as p
join zam�wienia as z on p.IDpracownika = z.IDpracownika
where DataWysy�ki > DataWymagana
group by Imi�, Nazwisko) as t1)




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


/*Zapytanie zwracaj�ce nazw� firmy, kt�ra z�o�y�a najdro�sze 
zam�wienie (QUICK-Stop)*/

SELECT CompanyName FROM 
[Order Details] as ord  JOIN Orders as od 
ON ord.OrderID = od.OrderID  JOIN Customers as c 
ON c.CustomerID = od.CustomerID GROUP BY od.OrderID, CompanyName
HAVING SUM(quantity*unitprice) = 
(SELECT MAX(sums) FROM
(SELECT SUM(quantity*Unitprice) as sums FROM
"Order Details" GROUP BY OrderID) as temp)