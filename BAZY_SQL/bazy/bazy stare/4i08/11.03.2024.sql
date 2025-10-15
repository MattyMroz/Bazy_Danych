create database pon_12 
use pon_12

sp_helpdb pon_12

--bledy proces tworzenia tabeli (logiczny)
create table [dane moje]
(

)

create table dane 
(imie varchar,
nazwisko varchar,
wiek int
)

insert into dane
values('j','k',33)

select * from dane

insert into dane
values('jasio','kotek',33)

create table dane1 
(imie varchar(10) is not null,
nazwisko varchar(20),
wiek int
)

insert into dane1
values('jasio','kotek',33)

select * from dane1

--zwroc uwage na brak unikalnosci danych
-- bo sa tylko tekstowe
-- nie moge wybrac konkretnych danych

-- dodajemy do tabeli unkalna kolumne

alter table dane1 
add id int

insert into dane1
values('jasio','kotek',33,1)

select * from dane1

insert into dane1(id)
values(1)

create table dane2
(id int,
imie varchar(10) ,
nazwisko varchar(20),
wiek int
)


insert into dane2
values(1,'jasio','kotek',33)

select * from dane2

insert into dane2(id)
values(1)

-- usuwanie
-- drop,delete,truncate

alter table dane2
drop column id

truncate table dane2

--poprawanie dodane dane (logicznie)

create table dane3
(id int identity(1,1) primary key,
imie varchar(10) ,
nazwisko varchar(20),
wiek int
)

insert into dane3
values('jasio','kotek',33)

select * from dane3

select imie,nazwisko from dane3

select id,imie,nazwisko from dane3

select id,imie,nazwisko from dane3
where id=5

select id,imie,nazwisko from dane3
where id='5'




use baza 

alter table pracownicy
add dousuniecia2 int default 1

select * from pracownicy

insert into pracownicy(nazwisko,imie,wiek,dzialid) values('Kowalski','Jan',50,2);

insert into pracownicy(dousuniecia2) values(2);
insert into pracownicy(dousuniecia2) values(1);

alter table pracownicy
add wzrost int 

insert into pracownicy(wzrost) values(190);
insert into pracownicy(wzrost) values(1.90);

select * from pracownicy

alter table pracownicy
add wzrost1 decimal(3,2) 

insert into pracownicy(wzrost1) values(1.90);

update pracownicy set wzrost1=1.70 where pracid<5
update pracownicy set wzrost1=1.75 where pracid=5
update pracownicy set wzrost1=1.80 where pracid>5

alter table pracownicy
add aktualny2 varchar(10) 

update pracownicy set aktualny2='tak'

select * from pracownicy

update pracownicy set aktualny2='jasio'

--alter table pracownicy delete  pracid='5'