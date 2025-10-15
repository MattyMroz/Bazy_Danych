--TRIGGERY


--SKLADNIA TWORZENIA TRIGGERA
/*
	create trigger nazwa
	on nazwa tabeli
	for after lub instead create update delete
	as begin 
		CIAŁO TRIGGERA
	end
*/

create trigger tr_dzialy on dzialy
for insert, update, delete
as
begin
	select * from dzialy
end

insert into dzialy(nazwa) values('Nowy')


--TABELE INSERTED I DELETED


alter trigger tr_dzialy
on dzialy
for insert, update, delete
as
begin
	select * from inserted
	select * from deleted
end

-- Tabela INSERTED przy dodawaniu

insert into dzialy(nazwa) values('Nowy Inserted')

-- Tabela DELETED przy usuwaniu

delete from dzialy where nazwa = 'Nowy Inserted'

--Tabele INSERTED I DELETED przy modyfikacji

insert into dzialy(nazwa) values('Nowy Updated')
update dzialy set aktualny  = 'nie' where nazwa = 'Nowy Updated'


--Wpływ wycofania transakcji na działanie triggera

--transakcja

alter trigger tr_dzialy
on dzialy
for insert, update, delete
as
begin
	--select * from dzialy
	rollback
end

delete from dzialy where dzialid > 4

-- 

alter trigger tr_dzialy
on dzialy
for insert, update, delete
as
begin
	if update(aktualny)
		print 'Zmiana aktualności'
	else 
		print'Aktualność nie zmieniana'
print columns_updated()
--funkcja sluzy do sprawdzenia ktora kolumna byla zmieniana
end

--update dzialy set nazwa = 'nowa nazwa',aktualny ='tak' where dzialid =8
update dzialy set aktualny  = 'nie' where dzialid > 5

--TRIGGERY INSTEAD OF - czyli zamiast akcji

alter table zarobki add aktualny varchar(3)

create trigger tr_zarobki 
on zarobki
instead of delete
as 
begin
	update zarobki set aktualny='nie' where zarid in (select zarid from deleted)
end

--sprawdzamy zarobiek o id = 4
select * from zarobki

--próbujemty usunac zarobiek o id = 4
delete from zarobki where zarid=4

--sprawdzamy zarobiek o id = 4
select * from zarobki

--TRIGGERY AUDYTOWE

--uzupełniamy tabele osoby o pola audytowe

alter table pracownicy add 
	data_wst datetime,
	operator_wst varchar(30),
	data_mod datetime,
	operator_mod varchar(30)


create trigger tr_prac on pracownicy
for update, insert
as 
begin

if exists (select *  from deleted)
	update pracownicy set  data_mod = getdate(), operator_mod=user
	where pracid in (select pracid from inserted)
else
	update pracownicy set  data_wst = getdate(), operator_wst=user
	where pracid in (select pracid from inserted)
end

--testujemy trigger


insert into pracownicy (nazwisko) values ('NAZ_TESTOWE')

select * from pracownicy where nazwisko = 'NAZ_TESTOWE'

update pracownicy set imie = 'IMIE_TEST' where nazwisko = 'NAZ_TESTOWE'

select * from pracownicy where nazwisko = 'NAZ_TESTOWE'



--stwórz triggera który przenosi dane dotyczące zarobków 
--do tabeli historycznej będącej dokładną kopią tabeli 
--zarobki bez kolumny aktualny. Uwzględnij w tej tabeli datę
--przenosin oraz użytkownika który kasował dane



--TABELE INSERTED I DELETED


alter trigger tr_dzialy
on dzialy
for insert, update, delete
as
begin
	select * from inserted
	select * from deleted
end

-- Tabela INSERTED przy dodawaniu

insert into dzialy(nazwa) values('Nowy Inserted')

-- Tabela DELETED przy usuwaniu

delete from dzialy where nazwa = 'Nowy Inserted'

--Tabele INSERTED I DELETED przy modyfikacji

insert into dzialy(nazwa) values('Nowy Updated')
update dzialy set aktualny  = 'nie' where nazwa = 'Nowy Updated'


