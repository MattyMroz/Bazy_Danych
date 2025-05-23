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

-- zapytania zwracające 3 kolumny; imie, 
--nazwisko pracownika oraz wartosci zamowien
-- przez niego zrealizowanych pod uwage bierzemy 
--jedynie zamowienia z drugiego kwartalu 1997 roku

SELECT Imię, Nazwisko, SUM(CenaJednostkowa*ilość) as
'wartosc' FROM Zamówienia as z JOIN 
[opisy zamówień] as op
ON z.IDzamówienia=op.IDzamówienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataZamówienia >='1997-04-01' 
AND DataWysyłki >= '1997-06-30' 
GROUP BY Imię, Nazwisko,p.IDpracownika, z.IDzamówienia
 
SELECT Imię, Nazwisko, SUM(CenaJednostkowa*ilość) as
'wartosc' FROM Zamówienia as z JOIN 
[opisy zamówień] as op
ON z.IDzamówienia=op.IDzamówienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataWysyłki >='1997-04-01' 
AND DataWysyłki <= '1997-06-30' 
GROUP BY Imię, Nazwisko,p.IDpracownika, z.IDzamówienia
 
 SELECT Imię, Nazwisko, SUM(CenaJednostkowa*ilość) as
'wartosc' FROM Zamówienia as z JOIN 
[opisy zamówień] as op
ON z.IDzamówienia=op.IDzamówienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataZamówienia>='1997-04-01' 
AND DataZamówienia <= '1997-06-30' 
GROUP BY Imię, Nazwisko,p.IDpracownika, z.IDzamówienia; 

 select * from Opisy zamówień
 select * from [Opisy zamówień]
 select * from "Opisy zamówień"


 select * from [dbo].[Zamówienia]