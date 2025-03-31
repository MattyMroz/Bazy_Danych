create database cz_12

use cz_12

-- tworze tabele (proces zawiera bledy)


create table dane
(imie varchar,
nazwisko varchar,
wiek int
)

insert into dane values
('jasio','kotek',34)

insert into dane values
('j','k',34)

select * from dane

create table dane1
(imie varchar(20),
nazwisko varchar(20),
wiek int
)

insert into dane1 values
('jasio','kotek',34)

select * from dane1

-- zwroc uwage co sie stanie kiedy wykonam ten insert kilkukrotnie
-- chia³by wyswietlic 4 wiersz danych

--mam dane nie uniklane 
-- musze dodac unikalnosc
--np przez dodanie kolumny numerycznej

alter table dane1
add id int

select * from dane1



insert into dane1 values
('jasio','kotek',34,1)

-- nie rozwiazalem problemu
-- a co kiedy dodal bym tylko jedna wartosc do kolunny id

insert into dane1 values
('34','kotek',34,1)

insert into dane1 values
(34,'kotek',34,1)

insert into dane1 values
('jasio','kotek')

-- wstawiam jedna wartosc


insert into dane1(id) values
(2)

select * from dane1

-- nie pomoglo zatem dodajmy kolumne w tabeli 

create table dane2
(id int,
imie varchar(20),
nazwisko varchar(20),
wiek int
)

insert into dane2 values
(1,'jasio','kotek',34)

select * from dane2

-- kolumna id jest numeryczna ale brakuje jej wlasnosci autoinkrementacji

create table dane3
(id int identity(1,1),
imie varchar(20),
nazwisko varchar(20),
wiek int
)

insert into dane3 values
('jasio','kotek',34)

select * from dane3

-- czy terz moge wyswetlic 4 wiersz danych

select id,imie,nazwisko,wiek from dane3
where id='4'

--usuwanie

--drop
alter table dane1
drop column id 

drop table dane1

--delete
delete from dane3
where id=4

--truncate
select * from dane2

truncate table dane2

select * from dane3


use baza

alter table pracownicy add wzrost int

select * from pracownicy 

alter table pracownicy add wzrost1 numeric(3,2)


alter table pracownicy add dousuniecia2 int default 1

insert into pracownicy(nazwisko,imie) values('jasio','kotek');

select * from pracownicy
update pracownicy set wzrost1=1.70 where pracid<5
update pracownicy set wzrost1=1.75 where pracid=5
update pracownicy set wzrost1=1.80 where pracid>5
select * from pracownicy



alter table pracownicy add aktualny2 varchar(3)
update pracownicy set aktualny2='tak'

