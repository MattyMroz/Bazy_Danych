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