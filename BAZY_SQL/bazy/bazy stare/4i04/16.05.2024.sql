
-- zapytanie zwracaj¹ce 3 kolumny; imie, 
--nazwisko pracownika oraz wartosci zamowien
-- przez niego zrealizowanych pod uwage bierzemy 
--jedynie zamowienia z drugiego kwartalu 1997 roku

use north_pl

select * from Pracownicy
select * from Zamówienia
select * from [Opisy zamówieñ]
select * from "Opisy zamówieñ"
select * from Opisy zamówieñ

select Imiê,Nazwisko,  sum(CenaJednostkowa*Iloœæ) as 'wartosc' 
from  [Opisy zamówieñ] as op join Zamówienia as z 
on
z.IDzamówienia=op.IDzamówienia join Pracownicy as p
on
z.IDpracownika=p.IDpracownika
group by Imiê,Nazwisko

select Imiê,Nazwisko,z.IDzamówienia,z.IDpracownika,  
sum(CenaJednostkowa*Iloœæ) as 'wartosc' 
from  [Opisy zamówieñ] as op join Zamówienia as z 
on
z.IDzamówienia=op.IDzamówienia join Pracownicy as p
on
z.IDpracownika=p.IDpracownika
group by Imiê,Nazwisko,z.IDzamówienia,z.IDpracownika


 SELECT Imiê, Nazwisko, SUM(CenaJednostkowa*iloœæ) as
'wartosc' FROM Zamówienia as z JOIN 
[opisy zamówieñ] as op
ON z.IDzamówienia=op.IDzamówienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataWysy³ki <='1997-04-01' 
AND DataWymagana >= '1997-06-30' 
GROUP BY Imiê, Nazwisko,p.IDpracownika, z.IDzamówienia; 


 SELECT Imiê, Nazwisko, SUM(CenaJednostkowa*iloœæ) as
'wartosc' FROM Zamówienia as z JOIN 
[opisy zamówieñ] as op
ON z.IDzamówienia=op.IDzamówienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataWysy³ki >='1997-04-01' 
AND DataWymagana <= '1997-06-30' 
GROUP BY Imiê, Nazwisko,p.IDpracownika, z.IDzamówienia; 

 SELECT Imiê, Nazwisko, SUM(CenaJednostkowa*iloœæ) as
'wartosc' FROM Zamówienia as z JOIN 
[opisy zamówieñ] as op
ON z.IDzamówienia=op.IDzamówienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataWysy³ki >='1997-04-01' 
AND DataWysy³ki <= '1997-06-30' 
GROUP BY Imiê, Nazwisko,p.IDpracownika, z.IDzamówienia; 


 SELECT Imiê, Nazwisko, SUM(CenaJednostkowa*iloœæ) as
'wartosc' FROM Zamówienia as z JOIN 
[opisy zamówieñ] as op
ON z.IDzamówienia=op.IDzamówienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataWysy³ki >='1997-04-01' 
AND DataWysy³ki <= '1997-06-30' 
GROUP BY Imiê, Nazwisko

 SELECT Imiê, Nazwisko, SUM(CenaJednostkowa*iloœæ) as
'wartosc' FROM Zamówienia as z JOIN 
[opisy zamówieñ] as op
ON z.IDzamówienia=op.IDzamówienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
--WHERE DataWysy³ki >='1997-04-01' 
--AND DataWysy³ki <= '1997-06-30' 
GROUP BY Imiê, Nazwisko


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