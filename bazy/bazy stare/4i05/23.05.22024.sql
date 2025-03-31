use baza

________________________________________________________________


------------		funkcje
--ograniczenia np nie mozna wykonywac modyfikacji danych
--zawsze musza byc nawiasy nawet jak nie ma parametr�w

create function zero() returns integer
as
begin
return 0
end

--wywo�anie
--przy wywolaniu trzeba podac nazwe w�a�ciciela dbo
--execute nie dziela przy funkcjach

select dbo.zero(),imie from pracownicy


-------	 z parametrem
alter function dodaj(@a integer,@b integer) returns integer
as
begin
return  @a+@b
end

select dbo.dodaj(5,32) from pracownicy

--Podnoszenie dowolnej liczby do kwadratu

create function potega (@liczba float)
returns float
as
begin
declare @wynik float
set @wynik=power(@liczba,2)
return @wynik
end

declare @a float,@wynik float
set @a=115
set @wynik=dbo.potega(@a)
print cast(@a as varchar) + ' do kwadratu to ' 
+ cast(@wynik as varchar)

select (avg(wiek)) from pracownicy;
select dbo.potega(avg(wiek)) from pracownicy;


create function fun2(@filtr varchar(3))
 returns table
as
return (select imie,nazwisko from pracownicy 
where nazwisko like @filtr) 


select * from dbo.fun2('n%')




create function fun3(@filtr varchar(3))
 returns 
 @tab_return table(imie varchar(50), nazwisko 
 varchar(50) )
as
begin
	insert into @tab_return
		select imie ,nazwisko from pracownicy
		where nazwisko like @filtr
	return 
end

select * from dbo.fun3('n%')

CREATE FUNCTION dbo.Vat(@Brutto money, @Netto money)
RETURNS MONEY
AS
BEGIN
	DECLARE @Vat money;

	SET @Vat = @Brutto - @Netto;

	RETURN @Vat;
END;

SELECT Tab.*, dbo.Vat(Tab.brutto, Tab.netto) AS 
vat FROM (SELECT *, dbo.Netto(brutto) AS netto FROM zarobki) AS Tab;

-- Stw�rz funkcj� kt�ra b�dzie przyjmowa� 2 
--argumenty bed�ce ci�gami znak�w 
-- (maksymalnie do 100 znak�w) i zwr�ci 
--ci�g znak�w powsta�y z wymieszania na
-- przemian znak�w 
-- z ci�gu pierwszego z ci�giem drugim . 
--Dodatkowo funkcja ta ma zamieni� kolejno�� znak�w
-- PRZYK�AD: funkcja('ABCDE','12345') zwr�ci: 
--5E4D3C2B1A  
-- W przypadku niezgodno�ci d�ugo�ci ci�g�w 
--wej�ciowych wy�wietl komuikat typu: 
--'B��d d�ugo�ci znak�w: X <> Y
-- gdzie X i Y to d�ugo�ci ci�g�w wej�ciowych

create function funkcja(@str1 varchar(100), @str2 
varchar(100)) 
returns varchar(200)
as
begin

if len(@str1) != len(@str2)
 return 'B��d d�ugo�ci znak�w: ' + cast(len(@str1) 
 as varchar)+' <> '+ cast(len(@str2) as varchar)

declare @licznik int;
declare @result varchar(200);

set @licznik = 0;
set @result = '';


while @licznik <= len(@str1)
begin 
		set @licznik = @licznik + 1
		set @result = @result + 
		substring(@str1,@licznik-1,1) 
		set @result = @result + 
		substring(@str2,@licznik-1,1)		
end

return  reverse(@result)
end


select dbo.funkcja('ABCDE','12345')

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
