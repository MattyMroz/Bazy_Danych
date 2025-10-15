

create database cz_12 

sp_helpdb cz_12

use cz_12

create table dane 
(imie varchar,
nazwisko varchar,
wiek int
)

select * from dane

insert into dane
values('jasio','kotek',34)

insert into dane
values('j','k',34)

create table dane1 
(imie varchar(10) is not null,
nazwisko varchar(20),
wiek int
)

insert into dane1
values('jasio','kotek',34)

select * from dane1

alter table dane1
add id int

insert into dane1
values('jasio','kotek',34,1)

select * from dane1

insert into dane1(id)
values(1)

insert into dane1(id)
values(1)

select * from dane1

create table dane2 
(id int identity(1,1) primary key, 
imie varchar(10),
nazwisko varchar(20),
wiek int
)

insert into dane2
values('jasio','kotek',34)


select * from dane2

--delete,drop,truncate

alter table dane1
drop column id

select * from dane1



truncate table dane1

select * from dane1

select imie, nazwisko from dane2

select id,imie, nazwisko from dane2

select id,imie, nazwisko from dane2
where id=2

select id,imie, nazwisko from dane2
where id='2'

use baza

select * from pracownicy

alter table pracownicy
add dousuniecia2 int default 1

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

insert into pracownicy(wzrost2) values(1.92);

update pracownicy set wzrost2=1.70 where pracid<5
update pracownicy set wzrost2=1.75 where pracid=5
update pracownicy set wzrost2=1.80 where pracid>5

alter table pracownicy
add aktualny2 varchar(10)

update pracownicy set  aktualny2='tak'

select * from pracownicy

update pracownicy set  dousuniecia2=4

--constraints(check)