

--Dodaj funkcjê fun_kol, która zwróci tekstow¹ nazwê 
--dnia tygodnia  powsta³¹
--z daty powsta³ej z dodania X dni 
--(gdzie X to drugi parametr) 
--do daty podanej w pierwszym parametrze.
--W przypadku ustawienia null w parametrze 
--X dodaj 10 dni. 
--Przyk³adowy wynik wywo³ania funkcji:
--'Otrzymany dzieñ to: Sunday'


create function fun_kol (@date datetime,
 @interwal int) 
returns varchar(50)
as
begin
declare @wynik as datetime
if @interwal is null
begin
set @wynik = dateadd(day,10,@date)
return 'Otrzymany dzieñ to: '+cast(DATENAME 
(weekday,@wynik)
as char)
end
else
begin
set @wynik = dateadd(day,@interwal,@date)
return 'Otrzymany dzieñ to: '+cast(DATENAME 
(weekday,@wynik) 
as char)
end
return 'blad'
end


-- Procedury

--Procedura zwraca wszystkich pracowników









alter proc procedura
as
begin
	select * from pracownicy
end

procedura
--Wywo³anie na 3 sposoby
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
--Procedura wybieraj¹ca nazwiska pracowników których œrednie zarobki s¹ najwy¿sze 
--lub równe parametru wejsciowemu
--Albo (Procedura wybieraj¹ca pracowników których œrednie zarobki s¹ najwy¿sze 
--lub najni¿sze) (zak³adamy unikatowoœæ nazwisk pracownikow)



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
--Procedura zwraca pracowników których nazwisko like @filtr_nazw i imie like @filtr_imie
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


--uzycie parametru default -  nale¿y jawnie podaæ parametr jesli default nie jest na koncu
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
-- sterowanie przep³ywem


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
--Procedura nie zwraca wartoœci ale mo¿emy napisaæ procedurê z parametrem wyjœciowym

create procedure suma 
	@a integer,
	@b integer,
	@wiek integer OUTPUT
as 
begin
	set @wiek = @a+@b
end
--Anonimowa procedura
--konwersja typów
declare @wynik integer
exec suma 1,5,@wynik output 
print 'Suma warotœci wynosi: ' + convert(varchar, @wynik)
-----------------------------------------------------------

--Utwórz procedurê która bedzie oblicza³a œredni¹ trzech podanych na wejœciu 
--cyfr oraz
--ograniczy mo¿liwosc wpisania blednie danych

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
print 'Srednia z wprowadzonych wartoœci wynosi : '+ convert(varchar, @wyn)  


--Napisz procedurê która okreœli jaki dzien tygodnia stanowi 
--data podana w parametrze wejœciowym.
--W przypadku braku  parametru, zwróci dzien tygodnia aktualnej daty.

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

---zwróæ adres w posatci
Piotrkowska 
123/23 
m.30 
90-123 
£ódŸ 


