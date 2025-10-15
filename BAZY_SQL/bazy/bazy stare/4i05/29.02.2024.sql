

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
(imie varchar(10),
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


create table dane2 
(id int identity(1,1) primary key, 
imie varchar(10),
nazwisko varchar(20),
wiek int
)

insert into dane2
values('jasio','kotek',34)


select * from dane2