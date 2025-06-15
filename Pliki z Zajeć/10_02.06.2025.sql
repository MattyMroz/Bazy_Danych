--Procedura zwraca wszystkich pracowników

alter proc procedura
as
begin
	select * from pracownicy
end

procedura
--Wywo anie na 3 sposoby
procedura
execute procedura;
exec procedura;


--procedura z parametrami
create proc procedura_z_parameterm
		@wiek int,
		@wzrost int
	as
begin
	select * from pracownicy where wiek > @wiek and wzrost > @wzrost
end


--wywolanie procedury z parametrem
procedura_z_parameterm 15,1.1
execute procedura_z_parameterm 15,1.2;
exec procedura_z_parameterm 15, 2.3;


--usuwanie procedury 
drop proc procedura_z_parameterm
-------------------------------------------------------------
--Procedura wybieraj ca nazwiska pracownik w kt rych  rednie zarobki s  najwy sze 
--lub r wne parametru wejsciowemu
--Albo (Procedura wybieraj ca pracownik w kt rych  rednie zarobki s  najwy sze 
--lub najni sze) (zak adamy unikatowo   nazwisk pracownikow)



	alter proc procedura
		@wej_srd money
	as
	begin
		select nazwisko, avg(brutto) sred from 

		pracownicy p join zarobki z on z.pracid = p.pracid
		group by p.nazwisko
		having avg(brutto)=
		(
			select max(wynik.sred) from (
				select nazwisko, avg(brutto) sred from pracownicy p
				join zarobki z on z.pracid= p.pracid
				group by p.nazwisko
			)wynik
		)
		union
		select nazwisko, avg(brutto) sred from pracownicy p
			join zarobki z on z.pracid= p.pracid
			group by p.nazwisko
			having avg(brutto)= @wej_srd;
	
	end;
	go
	exec procedura 5600.0000;

--------------------------------------------------------
--Procedura zwraca pracownik w kt rych nazwisko like @filtr_nazw i imie like @filtr_imie
--procedura z domyslnym parametrem

alter proc procedura 
	@filtr_nazw varchar(5),
	@filtr_imie varchar(5)='%'
as
begin
	select * from pracownicy
	where nazwisko like @filtr_nazw
	and imie like @filtr_imie;
end

exec procedura 'K%','J%'
exec procedura 'K%'



alter proc procedura 
	@filtr_imie varchar(5)='%',
	@filtr_nazw varchar(5)
as
begin
	select * from pracownicy
	where nazwisko like @filtr_nazw
	and imie like @filtr_imie;
end

exec procedura 'J%'


--uzycie parametru default -  nale y jawnie poda  parametr jesli default nie jest na koncu
exec procedura @filtr_nazw='J%'


---------------------------------------------------------
--cialo procedury z deklaracjami

alter proc procedura 	
as
begin 

	declare @nazw varchar(50) --ustawnienie na dana wartosc
	set @nazw='puste'
	print @nazw
	-- ostatni rekord podstawia
	select @nazw =  nazwisko from pracownicy order by nazwisko ;
	print @nazw
end
exec procedura

---------------------------------------------------------
-- sterowanie przep ywem


alter proc procedura 
	@ilosc integer
as
begin 

	declare @nazw varchar(50) --ustawnienie na dana wartosc
	set @nazw='puste'
	print @nazw
	-- ostatni rekord podstawia
	select @nazw =  nazwisko from pracownicy order by nazwisko ;
	print @nazw
	
	if len(@nazw)>10
	print 'Wieksza'
	else print 'Mniejsza'
	
	declare @i integer
	set @i = 0
	while @i < @ilosc
	begin 
	   print 'Przebieg nr '+@i --cast funkcja konwertujaca typ
	   set @i = @i+1 
	end
end
exec procedura 5;

--------------------------------------------
--Procedura nie zwraca warto ci ale mo emy napisa  procedur  z parametrem wyj ciowym

create procedure suma 
	@a integer,
	@b integer,
	@wiek integer OUTPUT
as 
begin
	set @wiek = @a+@b
end
--Anonimowa procedura
--konwersja typ w
declare @wynik integer
exec suma 1,5,@wynik output 
print 'Suma warot ci wynosi: ' + convert(varchar, @wynik)
-----------------------------------------------------------

--Utw rz procedur  kt ra bedzie oblicza a  redni  trzech podanych na wej ciu 
--cyfr oraz
--ograniczy mo liwosc wpisania blednie danych

alter procedure oblicz1
			@m1 int,
			@m2 int,
			@m3 int,
			@wynik float output
as
begin
	if @m1 is null or @m2 is null or @m3 is null
		print 'podaj poprawne wartosci'
	else 
	set @wynik =(@m1+@m2+@m3)/3
	print 'Wynik: '+convert(varchar, @wynik)  
end
go
-------------------------------------------
declare @wyn float
exec oblicz1 1,2,3,@wyn output
print 'Srednia z wprowadzonych warto ci wynosi : '+ convert(varchar, @wyn)  


