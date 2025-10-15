use baza

insert into pracownicy(nazwisko,imie,wiek,dzialid) values('Nowak','Anna',25,10);
insert into pracownicy(nazwisko,imie,wiek,dzialid) values('jasio','kotek',25,10);

insert into dzialy values('Kadry')

select * from dzialy
select * from pracownicy


select nazwa,nazwisko,imie 
from dzialy join pracownicy
on dzialy.dzialID=pracownicy.dzialID



CREATE TABLE pracownicy
(
	pracID  int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	nazwisko varchar(50),
	imie varchar(50),
	wiek int,
	dzialID int FOREIGN KEY REFERENCES dzialy (dzialID)
) 


-- dodaj zarobki

select nazwa,nazwisko,imie,brutto
from dzialy join pracownicy
on dzialy.dzialID=pracownicy.dzialID
join zarobki 
on zarobki.pracID=pracownicy.pracID

-- do zastanowienia 


select nazwa,nazwisko,imie,brutto
from dzialy join pracownicy
on dzialy.dzialID=pracownicy.dzialID
join zarobki 
on zarobki.zarID=pracownicy.pracID

-- wyswetl wszystkich pracowniakow majacych w nazwisku litere j

select * from pracownicy
where nazwisko like 'j%'

select * from pracownicy
where nazwisko like '%j'

select * from pracownicy
where nazwisko like '%j%'

select * from pracownicy
where lower(nazwisko) like '%j%'

--wyswetl pracowniakow o okrerslonym wieku w osobnej 
--kolumnie jesli wiek jest okreslny nastepujaco
--wiek<25  'mlody'
--wiek<45  'sredni'
--wiek>=45  'najstarszy'

select imie,nazwisko,wiek,
case
	when wiek<25 then 'mlody'
	when wiek<45 then 'sredni'
	when wiek>=45 then 'najstarszy'
else
	'wiek nieznany'
end 'jaki wiek?'

from pracownicy






--Constraints typu check

/*
Do tabeli pracownicy dodaj kolumn  filia, kt ra ma zawiera  
do 20 znak w i na   na ni  ograniczenie pozwalaj ce wpisywa  jedynie
nazwy miasta Krak w, Warszawa,   d  oraz Katowice. Nazwij to ograniczenie CK_MIASTO.
*/

alter table pracownicy add filia varchar(20)

alter table pracownicy add constraint CK_MIASTO check
(filia in ('Krakow','Warszawa','Lodz','Katowice'));


insert into pracownicy(filia) values('jasio') 
insert into pracownicy(filia) values('lodz') 

alter table pracownicy
drop constraint CK_MIASTO

select * from pracownicy

/*
Stw rz kolumn  zadanie_1 w tabeli pracownicy, kt ra ma zawiera  10 znak w
i na   na ni  ograniczenia pozwalaj ce wpisywa  jedynie
wyrazy kt re maj  od 2 do 6 lub od 8 do 10 znak w. 
Nazwij to ograniczenie CK_ZADANIE1.
*/



ALTER TABLE pracownicy
ADD zadanie_1 varchar(10) CONSTRAINT CK_ZADANIE1 CHECK 
( (len(zadanie_1) between 2 and 6) OR (len(zadanie_1) between 8 and 10) )

insert into pracownicy(zadanie_1) values('a') --1
insert into pracownicy(zadanie_1) values('ab') --2
insert into pracownicy(zadanie_1) values('abcdef')--6
insert into pracownicy(zadanie_1) values('abcdefg')--7
insert into pracownicy(zadanie_1) values('abcdefg8')--8
insert into pracownicy(zadanie_1) values('abcdefghhu')--10



/*
Do tabeli pracownicy dodaj kolumn  mix, kt ra ma zawiera  6 znak w
i na   na ni  ograniczeni pozwalaj ce wpisywa  jedynie
wyrazy kt re zawieraj  na przemian 3 litery i 3 cyfry. Nazwij to ograniczenie CK_MIX.
Przyk ad wartosci a4f5d9. */


alter table pracownicy 
add mix varchar(6)

select * from pracownicy

alter table pracownicy 
add constraint CK_MIX check(mix like '[a-z][0-9][a-z][0-9][a-z][0-9]')
