 SELECT Imi�, Nazwisko, p.IDpracownika, z.IDzam�wienia,
 SUM(CenaJednostkowa*ilo��) as
'wartosc' FROM Zam�wienia as z JOIN 
[opisy zam�wie�] as op
ON z.IDzam�wienia=op.IDzam�wienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataZam�wienia>='1997-04-01' 
AND DataZam�wienia <= '1997-06-30' 
GROUP BY p.IDpracownika, z.IDzam�wienia; 


use north


select Title,Country,LastName,FirstName,
cast(BirthDate as date) BirthDate,cast(HireDate as date) HireDate
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

select NazwaKategorii, NazwaProduktu, CenaJednostkowa from
(select NazwaKategorii, NazwaProduktu, k.idKategorii, 
CenaJednostkowa from Kategorie as k
JOIN Produkty as p
on k.IDKategorii=p.IDkategorii) as t1
JOIN
(select idkategorii,  max(CenaJednostkowa) 
as 'maks' from produkty
group by IDkategorii) as t2
on t1.IDkategorii=t2.IDkategorii
where maks=CenaJednostkowa

