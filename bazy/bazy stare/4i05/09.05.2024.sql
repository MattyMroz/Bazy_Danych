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


select nazwisko,imie as dane from pracownicy
order by imie desc

select nazwisko+' '+imie as dane from pracownicy
order by imie desc

-- zapytania zwracaj�ce 3 kolumny; imie, 
--nazwisko pracownika oraz wartosci zamowien
-- przez niego zrealizowanych pod uwage bierzemy 
--jedynie zamowienia z drugiego kwartalu 1997 roku

SELECT Imi�, Nazwisko, SUM(CenaJednostkowa*ilo��) as
'wartosc' FROM Zam�wienia as z JOIN 
[opisy zam�wie�] as op
ON z.IDzam�wienia=op.IDzam�wienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataZam�wienia >='1997-04-01' 
AND DataWysy�ki >= '1997-06-30' 
GROUP BY Imi�, Nazwisko,p.IDpracownika, z.IDzam�wienia
 
SELECT Imi�, Nazwisko, SUM(CenaJednostkowa*ilo��) as
'wartosc' FROM Zam�wienia as z JOIN 
[opisy zam�wie�] as op
ON z.IDzam�wienia=op.IDzam�wienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataWysy�ki >='1997-04-01' 
AND DataWysy�ki <= '1997-06-30' 
GROUP BY Imi�, Nazwisko,p.IDpracownika, z.IDzam�wienia
 
 SELECT Imi�, Nazwisko, SUM(CenaJednostkowa*ilo��) as
'wartosc' FROM Zam�wienia as z JOIN 
[opisy zam�wie�] as op
ON z.IDzam�wienia=op.IDzam�wienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataZam�wienia>='1997-04-01' 
AND DataZam�wienia <= '1997-06-30' 
GROUP BY Imi�, Nazwisko,p.IDpracownika, z.IDzam�wienia; 

 select * from Opisy zam�wie�
 select * from [Opisy zam�wie�]
 select * from "Opisy zam�wie�"


 select * from [dbo].[Zam�wienia]