-- (5) select
-- (1) from
-- (2) where
-- (3) group by
-- (4) having
-- (6) order by

use north_pl

-- zapytanie zwracaj�ce 3 kolumny; imie, 
--nazwisko pracownika oraz wartosci zamowien
-- przez niego zrealizowanych pod uwage bierzemy 
--jedynie zamowienia z drugiego kwartalu 1997 roku
 
select * from Opisy zam�wie�

select * from [Opisy zam�wie�]

select * from "Opisy zam�wie�"

 select Imi�,Nazwisko, sum(CenaJednostkowa*Ilo��)as 'wartosc' from Zam�wienia as z
 join [Opisy zam�wie�] as op 
 on 
 z.IDzam�wienia=op.IDzam�wienia
 join Pracownicy as p 
 on
 p.IDpracownika=z.IDpracownika
 group by Imi�,Nazwisko

 
 select Imi�,Nazwisko, sum(CenaJednostkowa*Ilo��)as 'wartosc' from Zam�wienia as z
 join [Opisy zam�wie�] as op 
 on 
 z.IDzam�wienia=op.IDzam�wienia
 join Pracownicy as p 
 on
 p.IDpracownika=z.IDpracownika
 group by Imi�,Nazwisko, p.IDpracownika, z.IDzam�wienia


 SELECT Imi�, Nazwisko, SUM(CenaJednostkowa*ilo��) as
'wartosc' FROM Zam�wienia as z JOIN 
[opisy zam�wie�] as op
ON z.IDzam�wienia=op.IDzam�wienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
--WHERE DataWymagana>='1997-04-01' 
--AND DataWymagana <= '1997-06-30' 
GROUP BY Imi�, Nazwisko,p.IDpracownika, z.IDzam�wienia; 


 
SELECT Imi�, Nazwisko, SUM(CenaJednostkowa*ilo��) as
'wartosc' FROM Zam�wienia as z JOIN 
[opisy zam�wie�] as op
ON z.IDzam�wienia=op.IDzam�wienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataZam�wienia>='1997-04-01' 
AND DataZam�wienia <= '1997-06-30' 
GROUP BY Imi�, Nazwisko,p.IDpracownika, z.IDzam�wienia; 


SELECT Imi�, Nazwisko, SUM(CenaJednostkowa*ilo��) as
'wartosc' FROM Zam�wienia as z JOIN 
[opisy zam�wie�] as op
ON z.IDzam�wienia=op.IDzam�wienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataZam�wienia>='1997-04-01' 
AND DataZam�wienia <= '1997-06-30' 
GROUP BY Imi�, Nazwisko


--Zapytanie zwracaj�ce 3 kolumny :
-- Imi�, Nazwisko, ilo�� zam�wie� zrealizowanych po terminie.
-- Jedynie osoba z najwieksz� ilo�ci� zam�wien po terminie.(1)




 select * from Zam�wienia 