
-- zapytanie zwracaj�ce 3 kolumny; imie, 
--nazwisko pracownika oraz wartosci zamowien
-- przez niego zrealizowanych pod uwage bierzemy 
--jedynie zamowienia z drugiego kwartalu 1997 roku

use north_pl

select * from Pracownicy
select * from Zam�wienia
select * from [Opisy zam�wie�]
select * from "Opisy zam�wie�"
select * from Opisy zam�wie�

select Imi�,Nazwisko,  sum(CenaJednostkowa*Ilo��) as 'wartosc' 
from  [Opisy zam�wie�] as op join Zam�wienia as z 
on
z.IDzam�wienia=op.IDzam�wienia join Pracownicy as p
on
z.IDpracownika=p.IDpracownika
group by Imi�,Nazwisko

select Imi�,Nazwisko,z.IDzam�wienia,z.IDpracownika,  
sum(CenaJednostkowa*Ilo��) as 'wartosc' 
from  [Opisy zam�wie�] as op join Zam�wienia as z 
on
z.IDzam�wienia=op.IDzam�wienia join Pracownicy as p
on
z.IDpracownika=p.IDpracownika
group by Imi�,Nazwisko,z.IDzam�wienia,z.IDpracownika


 SELECT Imi�, Nazwisko, SUM(CenaJednostkowa*ilo��) as
'wartosc' FROM Zam�wienia as z JOIN 
[opisy zam�wie�] as op
ON z.IDzam�wienia=op.IDzam�wienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataWysy�ki <='1997-04-01' 
AND DataWymagana >= '1997-06-30' 
GROUP BY Imi�, Nazwisko,p.IDpracownika, z.IDzam�wienia; 


 SELECT Imi�, Nazwisko, SUM(CenaJednostkowa*ilo��) as
'wartosc' FROM Zam�wienia as z JOIN 
[opisy zam�wie�] as op
ON z.IDzam�wienia=op.IDzam�wienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataWysy�ki >='1997-04-01' 
AND DataWymagana <= '1997-06-30' 
GROUP BY Imi�, Nazwisko,p.IDpracownika, z.IDzam�wienia; 

 SELECT Imi�, Nazwisko, SUM(CenaJednostkowa*ilo��) as
'wartosc' FROM Zam�wienia as z JOIN 
[opisy zam�wie�] as op
ON z.IDzam�wienia=op.IDzam�wienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataWysy�ki >='1997-04-01' 
AND DataWysy�ki <= '1997-06-30' 
GROUP BY Imi�, Nazwisko,p.IDpracownika, z.IDzam�wienia; 


 SELECT Imi�, Nazwisko, SUM(CenaJednostkowa*ilo��) as
'wartosc' FROM Zam�wienia as z JOIN 
[opisy zam�wie�] as op
ON z.IDzam�wienia=op.IDzam�wienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataWysy�ki >='1997-04-01' 
AND DataWysy�ki <= '1997-06-30' 
GROUP BY Imi�, Nazwisko

 SELECT Imi�, Nazwisko, SUM(CenaJednostkowa*ilo��) as
'wartosc' FROM Zam�wienia as z JOIN 
[opisy zam�wie�] as op
ON z.IDzam�wienia=op.IDzam�wienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
--WHERE DataWysy�ki >='1997-04-01' 
--AND DataWysy�ki <= '1997-06-30' 
GROUP BY Imi�, Nazwisko


use north

select Title,Country,LastName,FirstName,
cast(BirthDate as date) BirthDate, cast(HireDate as date)HireDate  
from Employees
order by Country,Title

select Title,Country,count(*) as EmpQty
  
from Employees
group by Country,Title

use north_pl

-- zapytanie zwracajace 3 kolumny : nazwe kategorii oraz 
--nazwe produktu oraz cene
-- jedynie najdrozsze
-- produkty dla kazdej z kategorii