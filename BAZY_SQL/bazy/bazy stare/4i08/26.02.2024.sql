create database pon_12 
use pon_12

sp_helpdb pon_12

--bledy proces tworzenia tabeli
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
(imie varchar(10),
nazwisko varchar(20),
wiek int
)

insert into dane1
values('jasio','kotek',33)

select * from dane1