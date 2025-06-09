
create database pn_10

use pn_10

sp_helpdb pn_10

-- tworze tabele (proces zawerajacy bledy logiczne)

create table dane
(imie varchar,
nazwisko varchar,
wiek int
)

select * from dane

insert into dane values('jasio','kotek',34) -- zbyt mala ilosc miejsac (blad logiczny)

-- musze stworzyc table od nowa
create table dane1 --zwroc uwage na nazwe 
(imie varchar(20), -- definicja ilosci
nazwisko varchar(20),
wiek int
)

insert into dane1 values('jasio','kotek',34)

select * from dane1

-- zwroc co sie stanie kiedy dodam dane kilkukrotnie 

--co sie stanie kiedy chce zwrocic wiesz czwarty

select imie,nazwisko from dane1

-- nie moge tego uczynic gdyz dane tekstowe ktre posiadam w tabeli nie sa unikalne 
-- redunadancja danych nie jest bledem 

--rowaiazanie dodaj kolumne ktora bedzie unikalna 
-- zazwyczaj taka kolumna jest typu numerycznego

alter table dane1
add id int

select * from dane1
-- co sie stanie kiedy zmienie kolejnosc lub ilosc 
insert into dane values('kotek',34)
insert into dane values(34,'kotek',34)
insert into dane values('jasio','34',34)



insert into dane1 values('jasio','kotek',34,1)

select * from dane1

-- co kiedy dodam wartosc tylko do kolumny id

insert into dane1(id) values(2)

select * from dane1

create table dane2
(id int,
imie varchar(20), 
nazwisko varchar(20),
wiek int
)

insert into dane2 values(1,'jasio','kotek',34)

select * from dane2

select id,imie,nazwisko from dane2

-- kolumna sie stworzyla ale dalej watrosc kolumny jest nie uniklana
-- dodaj do kolumny id wlasciwosc autoinkrementacji

create table dane3
(id int identity(1,1),
imie varchar(20), 
nazwisko varchar(20),
wiek int
)


insert into dane3 values('jasio','kotek',34)

select * from dane3

-- czwarty wiersz dancyh

select id,imie,nazwisko from dane3
where id='4'