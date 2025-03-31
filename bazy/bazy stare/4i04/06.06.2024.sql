

--Dodaj funkcj� fun_kol, kt�ra zwr�ci tekstow� nazw� 
--dnia tygodnia  powsta��
--z daty powsta�ej z dodania X dni 
--(gdzie X to drugi parametr) 
--do daty podanej w pierwszym parametrze.
--W przypadku ustawienia null w parametrze 
--X dodaj 10 dni. 
--Przyk�adowy wynik wywo�ania funkcji:
--'Otrzymany dzie� to: Sunday'


create function fun_kol (@date datetime,
 @interwal int) 
returns varchar(50)
as
begin
declare @wynik as datetime
if @interwal is null
begin
set @wynik = dateadd(day,10,@date)
return 'Otrzymany dzie� to: '+cast(DATENAME 
(weekday,@wynik)
as char)
end
else
begin
set @wynik = dateadd(day,@interwal,@date)
return 'Otrzymany dzie� to: '+cast(DATENAME 
(weekday,@wynik) 
as char)
end
return 'blad'
end


-- Procedury

--Procedura zwraca wszystkich pracownik�w









alter proc procedura
as
begin
	select * from pracownicy
end

procedura
--Wywo�anie na 3 sposoby
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
--Procedura wybieraj�ca nazwiska pracownik�w kt�rych �rednie zarobki s� najwy�sze 
--lub r�wne parametru wejsciowemu
--Albo (Procedura wybieraj�ca pracownik�w kt�rych �rednie zarobki s� najwy�sze 
--lub najni�sze) (zak�adamy unikatowo�� nazwisk pracownikow)



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
--Procedura zwraca pracownik�w kt�rych nazwisko like @filtr_nazw i imie like @filtr_imie
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


--uzycie parametru default -  nale�y jawnie poda� parametr jesli default nie jest na koncu
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
-- sterowanie przep�ywem


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
--Procedura nie zwraca warto�ci ale mo�emy napisa� procedur� z parametrem wyj�ciowym

create procedure suma 
	@a integer,
	@b integer,
	@wiek integer OUTPUT
as 
begin
	set @wiek = @a+@b
end
--Anonimowa procedura
--konwersja typ�w
declare @wynik integer
exec suma 1,5,@wynik output 
print 'Suma warot�ci wynosi: ' + convert(varchar, @wynik)
-----------------------------------------------------------

--Utw�rz procedur� kt�ra bedzie oblicza�a �redni� trzech podanych na wej�ciu 
--cyfr oraz
--ograniczy mo�liwosc wpisania blednie danych

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
print 'Srednia z wprowadzonych warto�ci wynosi : '+ convert(varchar, @wyn)  


--Napisz procedur� kt�ra okre�li jaki dzien tygodnia stanowi 
--data podana w parametrze wej�ciowym.
--W przypadku braku  parametru, zwr�ci dzien tygodnia aktualnej daty.

create procedure zadanie
			@data datetime =null
as
begin
	if @data is null
	begin
		set @data = getdate()
		print 'Dzsiaj mamy :'+ cast(@data as varchar)
	end

	select case datepart(dw,@data)
	when 1 then 'niedziela'
	when 2 then 'poniedzialek'
	when 3 then 'wtorek'
	when 4 then 'sroda'
	when 5 then 'czwartek'
	when 6 then 'piatek'
	when 7 then 'sobota'
	end
end

go

exec zadanie
--'miesiac/dzien/rok'
exec zadanie '10/23/2006'
exec zadanie 

SELECT DATENAME(month, GETDATE());
SELECT DATENAME(day, GETDATE());
SELECT DATENAME(dw, GETDATE());

---zwr�� adres w posatci
Piotrkowska 
123/23 
m.30 
90-123 
��d� 


