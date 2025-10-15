use baza

________________________________________________________________


------------		funkcje
--ograniczenia np nie mozna wykonywac modyfikacji danych
--zawsze musza byc nawiasy nawet jak nie ma parametrów

create function zero() returns integer
as
begin
return 0
end

--wywo³anie
--przy wywolaniu trzeba podac nazwe w³aœciciela dbo
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

-- Stwórz funkcjê która bêdzie przyjmowaæ 2 
--argumenty bed¹ce ci¹gami znaków 
-- (maksymalnie do 100 znaków) i zwróci 
--ci¹g znaków powsta³y z wymieszania na
-- przemian znaków 
-- z ci¹gu pierwszego z ci¹giem drugim . 
--Dodatkowo funkcja ta ma zamieniæ kolejnoœæ znaków
-- PRZYK£AD: funkcja('ABCDE','12345') zwróci: 
--5E4D3C2B1A  
-- W przypadku niezgodnoœci d³ugoœci ci¹gów 
--wejœciowych wyœwietl komuikat typu: 
--'B³¹d d³ugoœci znaków: X <> Y
-- gdzie X i Y to d³ugoœci ci¹gów wejœciowych

create function funkcja(@str1 varchar(100), @str2 
varchar(100)) 
returns varchar(200)
as
begin

if len(@str1) != len(@str2)
 return 'B³¹d d³ugoœci znaków: ' + cast(len(@str1) 
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
