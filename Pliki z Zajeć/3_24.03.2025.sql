use baza
/*
select nazwa,nazwisko,imie 
from dzialy join pracownicy
on dzialy.dzialID=pracownicy.dzialID
*/
-- alias

select dzialy.dzialID,pracownicy.dzialID,nazwa,nazwisko,imie 
from dzialy,pracownicy
where dzialy.dzialID=pracownicy.dzialID

select d.dzialID,p.dzialID,nazwa,nazwisko,imie 
from dzialy as d,pracownicy as p
where d.dzialID=p.dzialID

select jasio.dzialID,p.dzialID,nazwa,nazwisko,imie 
from dzialy as jasio,pracownicy as p
where jasio.dzialID=p.dzialID

insert into pracownicy(nazwisko,imie,wiek,dzialid) values('Nowak','Anna',25,7);
insert into pracownicy(nazwisko,imie,wiek,dzialid) values('jasio','kotek',25,7);

--relacja
select nazwa,nazwisko,imie 
from dzialy join pracownicy
on dzialy.dzialID=pracownicy.dzialID

select * from dzialy

insert into dzialy(nazwa) values('Spedycja');

select * from pracownicy

--dodaj zarobki

select nazwa,nazwisko,imie,brutto 
from dzialy join pracownicy
on dzialy.dzialID=pracownicy.dzialID
join zarobki
on pracownicy.pracID=zarobki.pracID

-- kolejnoosc wykonywania zapytania 

(5)     SELECT
(1)	    FROM
(2)	    WHERE
(3)	    GROUP BY
(4)     HAVING
(6)     ORDER BY

select imie,nazwisko from pracownicy
ORDER BY imie 

select imie,nazwisko from pracownicy
ORDER BY nazwisko

select imie,nazwisko from pracownicy
ORDER BY imie asc 

select imie,nazwisko from pracownicy
ORDER BY nazwisko desc

--operator konkatenacji 

select imie,nazwisko from pracownicy

select imie+' '+nazwisko  from pracownicy

select imie+' '+nazwisko as dane from pracownicy