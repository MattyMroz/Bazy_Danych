-- zapytania zwracające 3 kolumny; imie, 
--nazwisko pracownika oraz wartosci zamowien
-- przez niego zrealizowanych pod uwage bierzemy 
--jedynie zamowienia z drugiego kwartalu 1997 roku(93)

use [north_pl]

SELECT Imię, Nazwisko, SUM(CenaJednostkowa*ilość) as
'wartosc zamowienia' FROM Zamówienia as z JOIN 
[opisy zamówień] as op
ON z.IDzamówienia=op.IDzamówienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
--WHERE DataZamówienia>='1997-04-01' 
--AND DataZamówienia <= '1997-06-30' 
GROUP BY Imię, Nazwisko,p.IDpracownika, z.IDzamówienia; 

SELECT Imię, Nazwisko, z.IDzamówienia,SUM(CenaJednostkowa*ilość) as
'wartosc zamowienia' FROM Zamówienia as z JOIN 
[opisy zamówień] as op
ON z.IDzamówienia=op.IDzamówienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
--WHERE DataZamówienia>='1997-04-01' 
--AND DataZamówienia <= '1997-06-30' 
GROUP BY Imię, Nazwisko,p.IDpracownika, z.IDzamówienia; 


 SELECT Imię, Nazwisko, SUM(CenaJednostkowa*ilość) as
'wartosc zamowienia' FROM Zamówienia as z JOIN 
[opisy zamówień] as op
ON z.IDzamówienia=op.IDzamówienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataWysyłki >='1997-04-01' 
AND DataZamówienia <= '1997-06-30' 
GROUP BY Imię, Nazwisko,p.IDpracownika, z.IDzamówienia; 

 SELECT Imię, Nazwisko, SUM(CenaJednostkowa*ilość) as
'wartosc zamowienia' FROM Zamówienia as z JOIN 
[opisy zamówień] as op
ON z.IDzamówienia=op.IDzamówienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataWymagana >='1997-04-01' 
AND DataZamówienia <= '1997-06-30' 
GROUP BY Imię, Nazwisko,p.IDpracownika, z.IDzamówienia; 

 SELECT Imię, Nazwisko, SUM(CenaJednostkowa*ilość) as
'wartosc zamowienia' FROM Zamówienia as z JOIN 
[opisy zamówień] as op
ON z.IDzamówienia=op.IDzamówienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataWymagana >='1997-04-01' 
AND DataWymagana <= '1997-06-30' 
GROUP BY Imię, Nazwisko,p.IDpracownika, z.IDzamówienia; 


 SELECT Imię, Nazwisko, SUM(CenaJednostkowa*ilość) as
'wartosc zamowienia' FROM Zamówienia as z JOIN 
[opisy zamówień] as op
ON z.IDzamówienia=op.IDzamówienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataWysyłki >='1997-04-01' 
AND DataWysyłki<= '1997-06-30' 
GROUP BY Imię, Nazwisko,p.IDpracownika, z.IDzamówienia;

SELECT Imię, Nazwisko, SUM(CenaJednostkowa*ilość) as
'wartosc zamowienia' FROM Zamówienia as z JOIN 
[opisy zamówień] as op
ON z.IDzamówienia=op.IDzamówienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataZamówienia <= '1997-04-01' 
AND DataZamówienia <= '1997-06-30' 
GROUP BY Imię, Nazwisko,p.IDpracownika, z.IDzamówienia; 

SELECT Imię, Nazwisko, SUM(CenaJednostkowa*ilość) as
'wartosc zamowienia' FROM Zamówienia as z JOIN 
[opisy zamówień] as op
ON z.IDzamówienia=op.IDzamówienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataZamówienia <= '1997-04-01' 
AND DataWymagana <= '1997-06-30' 
GROUP BY Imię, Nazwisko,p.IDpracownika, z.IDzamówienia; 

SELECT Imię, Nazwisko, p.IDpracownika, z.IDzamówienia,
SUM(CenaJednostkowa*ilość) as
'wartosc zamowienia' FROM Zamówienia as z JOIN 
[opisy zamówień] as op
ON z.IDzamówienia=op.IDzamówienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataZamówienia>='1997-04-01' 
AND DataZamówienia <= '1997-06-30' 
GROUP BY Imię, Nazwisko,p.IDpracownika, z.IDzamówienia

SELECT Imię, Nazwisko,
SUM(CenaJednostkowa*ilość) as
'wartosc zamowienia' FROM Zamówienia as z JOIN 
[opisy zamówień] as op
ON z.IDzamówienia=op.IDzamówienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataZamówienia>='1997-04-01' 
AND DataZamówienia <= '1997-06-30' 
GROUP BY Imię, Nazwisko

SELECT Imię, Nazwisko,z.IDzamówienia,
SUM(CenaJednostkowa*ilość) as
'wartosc zamowienia' FROM Zamówienia as z JOIN 
[opisy zamówień] as op
ON z.IDzamówienia=op.IDzamówienia  JOIN Pracownicy as p
ON p.IDpracownika=z.IDpracownika
WHERE DataZamówienia>='1997-04-01' 
AND DataZamówienia <= '1997-06-30' 
GROUP BY Imię, Nazwisko,z.IDzamówienia


-- zapytanie zwracajace 3 kolumny : nazwe kategorii oraz 
--nazwe produktu oraz cene
-- jedynie najdrozsze
-- produkty dla kazdej z kategorii(8)

select NazwaKategorii,NazwaProduktu,CenaJednostkowa from
(select NazwaKategorii,NazwaProduktu,k.IDkategorii,CenaJednostkowa from 
Produkty as p join Kategorie as k 
on 
p.IDkategorii=k.IDkategorii) as t1
join
(select IDkategorii,max(CenaJednostkowa) as 'maks'
from Produkty group by IDkategorii) as t2
on 
t1.IDkategorii=t2.IDkategorii
where CenaJednostkowa=maks 


--Zapytanie zwracające 2 kolumny 
--: nazwę kategorii oraz nazwę firmy. 
--Jedynie firmy, które dostarczaja 
--najwięcej produktów w danej kategorii(14).


SELECT NazwaFirmy,NazwaKategorii FROM
(SELECT k.idkategorii, NazwaFirmy,NazwaKategorii, COUNT(idproduktu) 
as 'ile' FROM Produkty as p JOIN Kategorie as k
ON k.IDkategorii=p.IDkategorii LEFT JOIN Dostawcy as d
ON d.IDdostawcy=p.IDdostawcy 
GROUP BY k.idkategorii, d.iddostawcy, NazwaFirmy,NazwaKategorii) as t2
 JOIN
(SELECT idkategorii, MAX(ile) as 'maks' FROM
(SELECT k.idkategorii, d.iddostawcy, COUNT(idproduktu) 
as 'ile' FROM Produkty as p  JOIN Kategorie as k
ON k.IDkategorii=p.IDkategorii JOIN Dostawcy as d
ON d.IDdostawcy=p.IDdostawcy 
GROUP BY k.idkategorii, d.iddostawcy) as t1
GROUP BY IDkategorii) as t3
ON t2.IDkategorii=t3.IDkategorii 
WHERE ile=maks;

















