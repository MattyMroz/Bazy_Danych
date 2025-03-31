create database cz_10

use cz_10

sp_helpdb cz_10

create table dane
(imie varchar,
nazwisko varchar,
wiek int
)

insert into dane
values('jasio','kotek',33)

insert into dane
values('j','k',33)

select * from dane
create table dane1
(imie varchar(10),
nazwisko varchar(20),
wiek int
)

insert into dane1
values('jasio','kotek',33)

select * from dane1

alter table dane1
add id int

insert into dane1
values('jasio','kotek',33,1)

select * from dane1

insert into dane1(id)
values(1)

create table dane2
(id int identity(1,1) primary key,
imie varchar(10),
nazwisko varchar(20),
wiek int
)

insert into dane2
values('jasio','kotek',33)

select * from dane2

select imie,nazwisko from dane2
where id=2

select id,imie,nazwisko from dane2
where id='2'

--drop,delete,truncate

alter table dane1
drop column id

select * from dane1

truncate table dane1

use baza 

alter table pracownicy 
add dousuniecia2 int default 1

select * from pracownicy 

insert into pracownicy(nazwisko,imie,wiek,dzialid) values('Kowalski','Jan',50,2);

insert into pracownicy(dousuniecia2) values(2);

insert into pracownicy(dousuniecia2) values(1);

alter table pracownicy 
add wzrost int

insert into pracownicy(wzrost) values(192);

select * from pracownicy

insert into pracownicy(wzrost) values(1.92);

alter table pracownicy 
add wzrost2 decimal(3,2)

update pracownicy set wzrost2=1.70 where pracid<5
update pracownicy set wzrost2=1.75 where pracid=5
update pracownicy set wzrost2=1.80 where pracid>5

select * from pracownicy

alter table pracownicy 
drop column aktualny2

alter table pracownicy 
add aktualny2 varchar(10)

update pracownicy set  aktualny2='tak'

select * from pracownicy