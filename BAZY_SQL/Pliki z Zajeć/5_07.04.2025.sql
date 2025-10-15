-- wstep do group by

use north

select Title,Country,LastName,FirstName,
BirthDate,HireDate from Employees
order by Title,Country


-- funkcje agregujace 

use baza
select * from [dbo].[pracownicy]

select count( * )  from pracownicy 
select count(wiek)  from pracownicy 
select count(nazwisko)  from pracownicy

select sum(wiek)/count(wiek) from pracownicy
select sum(wiek)/count(*) from pracownicy
select sum(wiek)  from pracownicy

-- sredni, maksymalny i minimalny wiek w dziale 
select max(wiek) as max , min(wiek) as min , avg(wiek) as sredania from  
pracownicy

select max(wiek) as maximum , min(wiek) as minimum , avg(wiek) as sredania from  
pracownicy

select max(wiek) as max , min(wiek) as min , avg(wiek) as sredania from  
pracownicy
group by dzialID


select Title,Country,LastName,FirstName,
BirthDate,HireDate from Employees
order by Title,Country

select Title,Country,count(*) as EmpQty
from Employees
group by  Title,Country


select Country,count(*) as EmpQty
from Employees
group by  Title,Country

select Title,Country,count(*) as EmpQty
from Employees
group by  Country

select Title,Country
from Employees
group by  Title,Country


select Title,Country,count(*) as EmpQty
from Employees
-- group by  Title,Country


-- zapytania 

use north_pl

select * from Opisy zam wie 

select * from [Opisy zam wie ]

-- zapytanie zwracajace 2 kolumny: nazwe produktu oraz 
--cene jedynie produkty drozsze od 25

select * from Produkty

select NazwaProduktu,CenaJednostkowa as cena from Produkty
where CenaJednostkowa <25


select NazwaProduktu,CenaJednostkowa as cena from Produkty
where cena <25


-- zapytanie zwracajace 2 kolumny: nazwe produktu 
--oraz nazwe kategorii do ktorej produkt ten nalezy


select NazwaProduktu,NazwaKategorii from Produkty as p
join Kategorie as k
on
p.IDkategorii=k.IDkategorii


-- zapytania zwracaj ce 3 kolumny; imie, 
--nazwisko pracownika oraz wartosci zamowien
-- przez niego zrealizowanych pod uwage bierzemy 
--jedynie zamowienia z drugiego kwartalu 1997 roku(93)


SELECT Imi , Nazwisko, SUM(CenaJednostkowa*ilo  ) as
'wartosc' FROM Zam wienia as z JOIN 
[opisy zam wie ] as op
ON z.IDzam wienia=op.IDzam wienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataZam wienia>='1997-04-01' 
AND DataZam wienia <= '1997-06-30' 
GROUP BY Imi , Nazwisko,p.IDpracownika, z.IDzam wienia; 
