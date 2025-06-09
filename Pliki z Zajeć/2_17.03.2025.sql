use pn_10

-- usuwanie

--drop
alter table dane 
add do_usuniecia varchar(20)

select * from dane

alter table dane 
drop column do_usuniecia 


drop table dane

--delete 

delete from dane3
where id=4 

select * from dane3

--truncate

truncate table dane2

select * from dane2

use baza


select * from pracownicy

alter table pracownicy
add wzrost int


alter table pracownicy
add wzrost1 numeric(3,2)

update pracownicy set wzrost=1.70 where pracid<5
update pracownicy set wzrost=1.75 where pracid=5
update pracownicy set wzrost=1.80 where pracid>5

select * from pracownicy

update pracownicy set wzrost1=1.70 where pracid<5
update pracownicy set wzrost1=1.75 where pracid=5
update pracownicy set wzrost1=1.80 where pracid>5

alter table pracownicy add dousuniecia2 int default 1

insert into pracownicy(nazwisko,imie) values('jasio','kotek');


alter table pracownicy add aktualny2 varchar(3)
update pracownicy set aktualny2='tak'

select * from pracownicy

select * from dzialy

-- chce wyswetlic pracownikow pracujacych w danym dziale 

select dzialID,nazwa from dzialy

select dzialy.dzialID,pracownicy.dzialID,nazwa,nazwisko,imie 
from dzialy,pracownicy


select * from pracownicy

select dzialy.dzialID,pracownicy.dzialID,nazwa,nazwisko,imie 
from dzialy,pracownicy
where dzialy.dzialID=pracownicy.dzialID

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