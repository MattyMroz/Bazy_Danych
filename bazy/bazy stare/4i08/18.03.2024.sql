use baza 

--wyswietl wszystkich pracownikow w danym dziale

select * from [Order Details]
select * from Order Details

select dzialID,nazwa from dzialy

select dzialID,nazwa,imie,nazwisko 
from dzialy,pracownicy

select * from pracownicy

select dzialy.dzialID,nazwa,imie,nazwisko 
from dzialy,pracownicy

select pracownicy.dzialID,dzialy.dzialID,
nazwa,imie,nazwisko from dzialy,pracownicy

select pracownicy.dzialID,dzialy.dzialID,
nazwa,imie,nazwisko from dzialy,pracownicy
where
pracownicy.dzialID=dzialy.dzialID

select pracownicy.dzialID,dzialy.dzialID,
nazwa,imie,nazwisko from dzialy join pracownicy
on
pracownicy.dzialID=dzialy.dzialID

select nazwa,imie,nazwisko 
from dzialy join pracownicy
on
pracownicy.dzialID=dzialy.dzialID

--wyswietl wszystkich pracownikow w danym dziale oraz ich zarobki

select nazwa,imie,nazwisko,zarobki.brutto 
from dzialy join pracownicy
on
pracownicy.dzialID=dzialy.dzialID
join zarobki
on
pracownicy.pracID=zarobki.pracID

(5)     SELECT
(1)		FROM
(2)		WHERE
(3)		GROUP BY
(4)     HAVING
(6)     ORDER BY


select imie,nazwisko 
from  pracownicy
ORDER BY nazwisko

select imie,nazwisko 
from  pracownicy
ORDER BY imie


select imie,nazwisko 
from  pracownicy
ORDER BY nazwisko asc

select imie,nazwisko 
from  pracownicy
ORDER BY imie desc


select nazwa,imie,nazwisko,z.brutto 
from dzialy as d join pracownicy as p
on
p.dzialID=d.dzialID
join zarobki as z
on
p.pracID=z.pracID


select nazwa,imie,nazwisko,z.brutto 
from dzialy as jasio join pracownicy as p
on
p.dzialID=jasio.dzialID
join zarobki as z
on
p.pracID=z.pracID


select imie,nazwisko 
from  pracownicy


select imie,nazwisko as dane
from  pracownicy

select imie+' '+nazwisko as dane
from  pracownicy

-- wyswetl wsztstkich pracownickow majacych litere j w nazwisku

select * from pracownicy
where nazwisko like 'j%'

select * from pracownicy
where nazwisko like '%j'

select * from pracownicy
where nazwisko like '%j%'

select * from pracownicy
where lower(nazwisko) like 'j%'

select * from pracownicy
where lower(nazwisko) like '%j%'

--wyswietl wiek dandj osoby w kolumnie

select imie,nazwisko,wiek,
case
	when wiek<25 then 'mlody'
	when wiek<45 then 'sredni'
	when wiek>=45 then 'najstarszy'
else
	'wiek nieznany'
end 'jaki wiek?'

from pracownicy


select imie,nazwisko ,wiek from pracownicy where 
wiek in(30,31,32,34,35)


select imie,nazwisko ,wiek from pracownicy where 
nazwisko in('nowak',' kowalski')


--osoby ktorych zarobki sa wieksze od 3000

select imie,nazwisko  from pracownicy 
where pracid in
(
select distinct pracid from zarobki
where brutto > 3000
)

