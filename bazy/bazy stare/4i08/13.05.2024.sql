-- (5) select
-- (1) from
-- (2) where
-- (3) group by
-- (4) having
-- (6) order by

use north_pl

-- zapytanie zwracaj¹ce 3 kolumny; imie, 
--nazwisko pracownika oraz wartosci zamowien
-- przez niego zrealizowanych pod uwage bierzemy 
--jedynie zamowienia z drugiego kwartalu 1997 roku
 
select * from Opisy zamówieñ

select * from [Opisy zamówieñ]

select * from "Opisy zamówieñ"

 select Imiê,Nazwisko, sum(CenaJednostkowa*Iloœæ)as 'wartosc' from Zamówienia as z
 join [Opisy zamówieñ] as op 
 on 
 z.IDzamówienia=op.IDzamówienia
 join Pracownicy as p 
 on
 p.IDpracownika=z.IDpracownika
 group by Imiê,Nazwisko

 
 select Imiê,Nazwisko, sum(CenaJednostkowa*Iloœæ)as 'wartosc' from Zamówienia as z
 join [Opisy zamówieñ] as op 
 on 
 z.IDzamówienia=op.IDzamówienia
 join Pracownicy as p 
 on
 p.IDpracownika=z.IDpracownika
 group by Imiê,Nazwisko, p.IDpracownika, z.IDzamówienia


 SELECT Imiê, Nazwisko, SUM(CenaJednostkowa*iloœæ) as
'wartosc' FROM Zamówienia as z JOIN 
[opisy zamówieñ] as op
ON z.IDzamówienia=op.IDzamówienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
--WHERE DataWymagana>='1997-04-01' 
--AND DataWymagana <= '1997-06-30' 
GROUP BY Imiê, Nazwisko,p.IDpracownika, z.IDzamówienia; 


 
SELECT Imiê, Nazwisko, SUM(CenaJednostkowa*iloœæ) as
'wartosc' FROM Zamówienia as z JOIN 
[opisy zamówieñ] as op
ON z.IDzamówienia=op.IDzamówienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataZamówienia>='1997-04-01' 
AND DataZamówienia <= '1997-06-30' 
GROUP BY Imiê, Nazwisko,p.IDpracownika, z.IDzamówienia; 


SELECT Imiê, Nazwisko, SUM(CenaJednostkowa*iloœæ) as
'wartosc' FROM Zamówienia as z JOIN 
[opisy zamówieñ] as op
ON z.IDzamówienia=op.IDzamówienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataZamówienia>='1997-04-01' 
AND DataZamówienia <= '1997-06-30' 
GROUP BY Imiê, Nazwisko


--Zapytanie zwracaj¹ce 3 kolumny :
-- Imiê, Nazwisko, iloœæ zamówieñ zrealizowanych po terminie.
-- Jedynie osoba z najwieksz¹ iloœci¹ zamówien po terminie.(1)




 select * from Zamówienia 