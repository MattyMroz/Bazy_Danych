create database baza


use baza


CREATE TABLE dzialy(
	dzialID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	nazwa varchar(50) 
)

go

CREATE TABLE pracownicy
(
	pracID  int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	nazwisko varchar(50),
	imie varchar(50),
	wiek int,
	dzialID int FOREIGN KEY REFERENCES dzialy (dzialID)
) 

go

CREATE TABLE zarobki(
	zarID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	od datetime,
	brutto money,
	pracID int FOREIGN KEY REFERENCES pracownicy (pracID)
)


--dzialy
insert into dzialy(nazwa) values('Marketing');
insert into dzialy(nazwa) values('Sprzeda?');
insert into dzialy(nazwa) values('Wdro?enia');
insert into dzialy(nazwa) values('Produkcja');
insert into dzialy(nazwa) values('Produkcja');
insert into dzialy(nazwa) values('Spedycja');

select * from dzialy

--pracownicy
insert into pracownicy(nazwisko,imie,wiek,dzialid) values('Kowalski','Jan',50,1);
insert into pracownicy(nazwisko,imie,wiek,dzialid) values('Pi?tasa','Janusz',27,1);
insert into pracownicy(nazwisko,imie,wiek,dzialid) values('Wolnicki','Andrzej',34,1);
insert into pracownicy(nazwisko,imie,wiek,dzialid) values('Pi?tkowski','Roman',30,1);
insert into pracownicy(nazwisko,imie,wiek,dzialid) values('Doma?ska','Katarzyna',32,1);
insert into pracownicy(nazwisko,imie,wiek,dzialid) values('Nowacki','Micha?',null,2);
insert into pracownicy(nazwisko,imie,wiek,dzialid) values('Krakowski','Mariusz',27,2);
insert into pracownicy(nazwisko,imie,wiek,dzialid) values('Ziomek','Tomasz',34,3);
insert into pracownicy(nazwisko,imie,wiek,dzialid) values('Andrzejczak','Jan',20,3);
insert into pracownicy(nazwisko,imie,wiek,dzialid) values('Jackowska','Maria',null,4);
insert into pracownicy(nazwisko,imie,wiek,dzialid) values('Nowak','Anna',25,4);
insert into pracownicy(nazwisko,imie,wiek,dzialid) values('Nowacki','Jan',29,null);
insert into pracownicy(nazwisko,imie,wiek,dzialid) values('Pawe?czyk','Janusz',31,null);


insert into pracownicy(nazwisko,imie,wiek,dzialid) values('Nowak','Anna',25,6);

select * from pracownicy

--zarobki
insert into zarobki(od,brutto,pracid) values('01/01/06',12500,1);
insert into zarobki(od,brutto,pracid) values('02/01/06',12550,1);
insert into zarobki(od,brutto,pracid) values('03/01/06',12600,1);
insert into zarobki(od,brutto,pracid) values('01/01/06',2500,2);
insert into zarobki(od,brutto,pracid) values('02/01/06',2550,2);
insert into zarobki(od,brutto,pracid) values('03/01/06',6600,2);
insert into zarobki(od,brutto,pracid) values('04/01/06',6600,2);
insert into zarobki(od,brutto,pracid) values('05/01/06',6250,2);
insert into zarobki(od,brutto,pracid) values('06/01/06',6300,2);
insert into zarobki(od,brutto,pracid) values('01/01/06',2500,3);
insert into zarobki(od,brutto,pracid) values('02/01/06',2550,4);
insert into zarobki(od,brutto,pracid) values('03/01/06',2600,5);
insert into zarobki(od,brutto,pracid) values('01/01/06',2500,6);
insert into zarobki(od,brutto,pracid) values('02/01/06',2550,6);
insert into zarobki(od,brutto,pracid) values('03/01/06',2600,6);
insert into zarobki(od,brutto,pracid) values('01/01/06',2500,7);
insert into zarobki(od,brutto,pracid) values('02/01/06',2550,7);
insert into zarobki(od,brutto,pracid) values('03/01/06',2600,8);
insert into zarobki(od,brutto,pracid) values('01/01/06',2500,9);
insert into zarobki(od,brutto,pracid) values('02/01/06',5550,10);
insert into zarobki(od,brutto,pracid) values('03/01/06',5600,11);

-- wyswetyl wszystkich praciownkow pracujacych w danym dziale 

--select * from Order Details

--select * from [Order Details]

select dzialID,nazwa from dzialy

select dzialID,nazwa,imie,nazwisko from dzialy

select nazwa,imie,nazwisko from dzialy,pracownicy

select dzialy.dzialID,nazwa,imie,nazwisko from dzialy,pracownicy

select * from pracownicy


select  pracownicy.dzialID,dzialy.dzialID,nazwa,imie,nazwisko 
from dzialy,pracownicy


select  pracownicy.dzialID,dzialy.dzialID,nazwa,imie,nazwisko 
from dzialy,pracownicy
where
dzialy.dzialID=pracownicy.dzialID

select  pracownicy.dzialID,dzialy.dzialID,nazwa,imie,nazwisko 
from dzialy join pracownicy
on
dzialy.dzialID=pracownicy.dzialID

-- wyswetyl wszystkich praciownkow pracujacych w danym dziale wraz z zarobkami

select  pracownicy.dzialID,dzialy.dzialID,nazwa,imie,nazwisko,zarobki.brutto
from dzialy join pracownicy
on
dzialy.dzialID=pracownicy.dzialID
join zarobki
on
pracownicy.pracID=zarobki.pracID

select nazwa,imie,nazwisko,zarobki.brutto
from dzialy join pracownicy
on
dzialy.dzialID=pracownicy.dzialID
join zarobki
on
pracownicy.pracID=zarobki.pracID

select nazwa,imie,nazwisko,z.brutto
from dzialy as d join pracownicy as p
on
d.dzialID=p.dzialID
join zarobki as z
on
p.pracID=z.pracID

select nazwa,imie,nazwisko,jasio.brutto
from dzialy as d join pracownicy as p
on
d.dzialID=p.dzialID
join zarobki as jasio
on
p.pracID=jasio.pracID

select imie,nazwisko from pracownicy

select imie,nazwisko as 'dane' from pracownicy


(5)     SELECT
(1)		FROM
(2)		WHERE
(3)		GROUP BY
(4)     HAVING
(6)     ORDER BY

select imie+' '+nazwisko as dane from pracownicy

-- wyswetl wsztskich praciowniakow z litera j w nazwisku

select * from pracownicy
where nazwisko like '%j'

select * from pracownicy
where nazwisko like 'j%'

select * from pracownicy
where nazwisko like '%j%'

select * from pracownicy
where lower(nazwisko) like '%j'

select * from pracownicy
where lower(nazwisko) like '%j%'

-- wyswetl prackow w damn wieku wzdglem konkrtnwej wartosci kolumny

select imie,nazwisko,wiek,
 case
	when wiek<25 then 'mlody'
	when wiek<45 then 'sredni'
	when wiek>=45 then 'najstarszy'
else
	'wiek nieznany'
end 'jaki wiek?'

from pracownicy



select imie,nazwisko from pracownicy
order by nazwisko


select imie,nazwisko from pracownicy
order by imie

select imie,nazwisko from pracownicy
order by nazwisko asc


select imie,nazwisko from pracownicy
order by imie desc


select nazwisko, imie from pracownicy as p
where exists (select * from zarobki as z where 
z.pracid = p.pracid) 

nazwy dzialow do ktorych nie sa przypisani zadni pracownicy 

select * from dzialy as d
where  not exists (select * from pracownicy as p 
where p.dzialid=d.dzialid)


-- klazula in

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

