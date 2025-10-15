-- zadanie 1
-- Do tabeli pracownicy dodaj kolumnę tekstowa poczta o długości 200 znaków.
-- Podczas dodawania i modyfikacji osoby ustaw tą kolumnę ciągiem złożonym z:
-- pierwszych 5 liter nazwiska, myślnika,
-- pierwszych trzech liter imienia oraz ciągu '@wp.pl'
-- Pamiętaj, aby usunąć ewentualne zewnętrzne białe znaki oraz
-- aby zamienić wewnętrzne spacje na znak '_'.

create trigger zad_1
on pracownicy
for insert, update
as
begin
	update p
	set p.poczta = replace(left(ltrim(rtrim(i.Nazwisko)), 5), ' ', '_') + '-' +
					replace(left(ltrim(rtrim(i.Imię)), 3), ' ', '_') + '@wp.pl'
	from Pracownicy p
	join inserted i on p.IDpracownika = i.IDpracownika
end
go

insert into Pracownicy (IDpracownika ,Imię, Nazwisko) values (10, 'Mateusz', 'Mrozmroz')
select Imię, Nazwisko, poczta from Pracownicy where Nazwisko='Mrozmroz'
update Pracownicy set Nazwisko = 'Mróz' where Nazwisko = 'Mrozmroz'
select Imię, Nazwisko, poczta from Pracownicy where Nazwisko='Mróz'

insert into Pracownicy (IDpracownika ,Imię, Nazwisko) values (11, ' M ateus z ', ' M rozmro z ')
select Imię, Nazwisko, poczta from Pracownicy where Nazwisko=' M rozmro z '
update Pracownicy set Nazwisko = ' M r ó z ' where Nazwisko = ' M rozmro z '
select Imię, Nazwisko, poczta from Pracownicy where Nazwisko=' M r ó z '




-- zadanie 2
-- Stwórz procedurę, która wyświetli w formie tekstowej (w oknie messages) co drugiego pracownika
-- pracownika, którego nazwisko zaczyna się na literę podaną w parametrze. W przypadku nie podania
-- parametru uwzględniaj tylko osoby o nazwisku na literę 'Z'. W przypadku podania w parametrze wartości
-- null nie uwzględniaj kryterium.




create procedure zad_2
    @c nvarchar(1) = 'Z'
as
begin
    declare @imie nvarchar(10)
    declare @nazwisko nvarchar(20)
    declare @i int
    declare @ile int

    set @i = 2

    select @ile = count(*)
    from Pracownicy p
    where (@c is null) or (p.Nazwisko like @c + '%')

    while @i <= @ile
    begin
        select @imie = xxx.Imię, @nazwisko = xxx.Nazwisko
        from
        (

            select
                p.Imię,
                p.Nazwisko,
                row_number() over (order by p.IDpracownika) as j
            from Pracownicy p
            where (@c is null) or (p.Nazwisko like @c + '%')

        ) as xxx
        where xxx.j = @i

        print @imie + ' ' + @nazwisko

        set @i = @i + 2
    end
end
go

insert into Pracownicy (IDpracownika, Imię, Nazwisko) values (12, 'Karol', 'Kajak')
insert into Pracownicy (IDpracownika, Imię, Nazwisko) values (13, 'Karol', 'Kajaki')
insert into Pracownicy (IDpracownika, Imię, Nazwisko) values (14, 'Karol', 'Kajakowy')
insert into Pracownicy (IDpracownika, Imię, Nazwisko) values (15, 'Karol', 'Kajakopodobny')

insert into Pracownicy (IDpracownika, Imię, Nazwisko) values (16, 'Maciej', 'Mróz')
insert into Pracownicy (IDpracownika, Imię, Nazwisko) values (17, 'Maciej', 'Mrozy')
insert into Pracownicy (IDpracownika, Imię, Nazwisko) values (18, 'Maciej', 'Mrozowy')
insert into Pracownicy (IDpracownika, Imię, Nazwisko) values (19, 'Maciej', 'Mrozopodobny')

insert into Pracownicy (IDpracownika, Imię, Nazwisko) values (20, 'Zuzanna', 'Ziemniak')
insert into Pracownicy (IDpracownika, Imię, Nazwisko) values (21, 'Zuzanna', 'Ziemniaki')
insert into Pracownicy (IDpracownika, Imię, Nazwisko) values (22, 'Zuzanna', 'Ziemniakowa')
insert into Pracownicy (IDpracownika, Imię, Nazwisko) values (23, 'Zuzanna', 'Ziemniakkowopodobna')
go


exec zad_2 -- Z

exec zad_2 'K'

exec zad_2 null

exec zad_2 'M'

select Imię, Nazwisko from Pracownicy






-- zadanie 3
-- Utwórz funkcję, która będzie zwracać komunikat o różnicy w dniach
-- między datą bieżącą a datą podaną w parametrze.
-- W przypadku tego samego dnia zwróć komunikat o równości dat.
-- Przykład:
-- 'Między datą obecną a datą Dec 12 2012 12:00AM jest XXX dni różnicy.'
-- lub
-- 'Daty data podana w parametrze jest datą dzisiejszą.'


create function zad_3 (@data datetime) returns varchar(200)
as
begin
    if datediff(day, @data, getdate()) = 0
    begin
        return 'Data podana w parametrze jest datą dzisiejszą.'
    end

    return 'Między datą obecną a datą ' +
            convert(varchar, @data, 100) + ' jest ' +
            convert(varchar, abs(datediff(day, @data, getdate()))) + ' dni różnicy.'
end
go

print dbo.zad_3(getdate())

print dbo.zad_3('2025-06-10')

print dbo.zad_3('2025-06-20')




-- zadanie 4
-- Utwórz funkcje, która będzie zwracać powtórzony ciąg znaków podany w parametrze tyle razy
-- ile podane to będzie w następnym parametrze. Co drugie powielenie ciągu wejściowego ma mieć
-- odwróconą kolejność znaków poczynając od pierwszego. Pomiędzy powieleniami dodaj podkreślnik.
-- Przykładowe wywołanie dla ciągu 'XYZ' i powielenia 3 - 'ZYX_XYZ_ZYX'.


create function zad_4 (@tekst varchar(100), @ile int) returns varchar(max)
as
begin
    declare @wynik varchar(max) = ''
    declare @i int = 1

    while @i <= @ile
    begin
        if @i % 2 = 1
            set @wynik = @wynik + reverse(@tekst)
        else
            set @wynik = @wynik + @tekst

        if @i < @ile
            set @wynik = @wynik + '_'

        set @i = @i + 1
    end

    return @wynik
end
go

print dbo.zad_4('+', 0)
print dbo.zad_4('XYZ', 3)
print dbo.zad_4('Kajak', 5)







-- Zadanie 5
-- Dodaj kolumnę tekstową login1 do tabeli pracownicy.
-- Przy tworzeniu nowego pracownika lub modyfikacji istniejącego
-- w tabeli pracownicy ustawiaj wartość kolumny login1
-- na pierwszą i ostatnią literę z imienia i pierwszą i ostatnią literą nazwiska. W tak stworzonej
-- wartości zastosuj wielkie litery.
-- Przykład dla osoby: Tomasz Pawlak login1 będzie składał się z TZPK



alter table pracownicy add login1 varchar(10)

(((drop trigger zad_1)))

create trigger zad_5
on pracownicy
for insert, update
as
begin
    update p
    set p.login1 =
        upper
        (
            left(i.Imię, 1) + right(i.Imię, 1) +
            left(i.Nazwisko, 1) + right(i.Nazwisko, 1)
        )
    from Pracownicy p
    join inserted i on p.IDpracownika = i.IDpracownika
end
go



insert into Pracownicy (IDpracownika, Imię, Nazwisko) values (24, 'Tomasz', 'Pawlak')
select Imię, Nazwisko, login1 from Pracownicy where IDpracownika = 24

select Imię, Nazwisko, login1 from Pracownicy where IDpracownika = 1
update Pracownicy set Imię = 'Grarzyna', Nazwisko = 'Kisiel' where IDpracownika = 1
select Imię, Nazwisko, login1 from Pracownicy where IDpracownika = 1




-- Zadanie 6
-- Do tabeli działy dopisz kolumnę data_przyjęcia.
-- Przy tworzeniu nowego pracownika z ustawionym działem
-- ustawiaj wartość kolumny data_przyjęcia dla zadanego działu
-- wpisując w nią komunikat z obecną datą oraz imieniem i nazwiskiem pracownika.
-- Format komunikatu:
-- 'Ostatni zatrudniony pracownik Jan Kowalski: Dec 18 2006  9:01PM'


alter table dzialy add data_przyjęcia varchar(200)

use baza

create trigger zad_6
on pracownicy
for insert
as
begin
    update d
    set d.data_przyjęcia =
        'Ostatni zatrudniony pracownik ' +
        i.imie + ' ' + i.nazwisko + ': ' +
        convert(varchar, getdate())
    from dzialy d
    join inserted i on d.dzialID = i.dzialID
    where i.dzialID is not null
end

select dzialID, nazwa, data_przyjęcia from dzialy where dzialID = 1
insert into pracownicy(imie, nazwisko, dzialID) values ('Mateusz', 'Mróz', 1)
select dzialID, nazwa, data_przyjęcia from dzialy where dzialID = 1

insert into pracownicy(imie, nazwisko, dzialID) values ('Mateusz', 'Mróz2', null)
select dzialID, nazwa, data_przyjęcia from dzialy




-- Zadanie 7
-- Utwórz procedurę , która wyświetli w formie tekstowej (w oknie messages)
-- wszystkich pracowników i liczbę ich wypłat. Pod uwagę bierz tylko tych pracowników,
-- którzy posiadają więcej niż X (gdzie X to pierwszy parametr procedury)
-- wpisów w tabeli zarobki. Dodatkowo wybierz tylko te wpisy, które zostały stworzone po
-- dacie podanej w drugim parametrze. W przypadku nie podania w wywołaniu procedury
-- drugiego parametru nie uwzględniaj kryterium daty.
-- Przykładowy wynik wywołania:
-- 'Pracownik Jan Kowalski od dnia Jan  1 2001 12:00AM otrzymał 5 wypłat'
-- lub
-- 'Pracownik Jan Kowalski otrzymał 5 wypłat'

select * from into_tabela

select
	it.Imie,
	it.Nazwisko,
	count(*) as liczba_wyplat
from into_tabela it
where it.DataWyplaty is not null and it.DataWyplaty > '2006-01-01'
group by it.ID_Pracownika, it.Imie, it.Nazwisko
having count(*) > 1




use baza
go

create procedure zad_7
    @ile_wyplat int,
    @data datetime = null
as
begin
    declare @imie varchar(50)
    declare @nazwisko varchar(50)
    declare @liczba_wyplat int
    declare @i int = 1
    declare @ile int

    select @ile = count(*)
    from
    (
        select it.ID_Pracownika
        from into_tabela it
        where it.DataWyplaty is not null and ((@data is null) or (it.DataWyplaty > @data))
        group by it.ID_Pracownika
        having count(*) > @ile_wyplat
    ) as t1

    while @i <= @ile
    begin
        select
            @imie = t2.Imie,
            @nazwisko = t2.Nazwisko,
            @liczba_wyplat = t2.liczba_wyplat
        from
        (
            select
                it.Imie,
                it.Nazwisko,
                count(*) as liczba_wyplat,
                row_number() over (order by it.ID_Pracownika) as j
            from into_tabela it
            where it.DataWyplaty is not null and ((@data is null) or (it.DataWyplaty > @data))
            group by it.ID_Pracownika, it.Imie, it.Nazwisko
            having count(*) > @ile_wyplat
        ) as t2
        where t2.j = @i

        if @data is not null
        begin
            print 'Pracownik ' + @imie + ' ' + @nazwisko +
                  ' od dnia ' + convert(varchar, @data) +
                  ' otrzymał ' + convert(varchar, @liczba_wyplat) + ' wypłat'
        end
        else
        begin
            print 'Pracownik ' + @imie + ' ' + @nazwisko +
                  ' otrzymał ' + convert(varchar, @liczba_wyplat) + ' wypłat'
        end

        set @i = @i + 1
    end
end
go



exec zad_7 1, '2006-01-01'
exec zad_7 1, '2006-02-01'
exec zad_7 1
exec zad_7 3
exec zad_7 3, '2006-02-01'


-- Zadanie 8
-- Procedura wybierająca nazwiska pracowników których średnie zarobki są najwyższe
-- lub równe parametru wejściowemu
-- Albo (Procedura wybierająca pracowników których średnie zarobki są najwyższe
-- lub najniższe) (zakładamy unikatowość nazwisk pracowników)


TESTY:

select
    p.nazwisko,
    avg(z.brutto) as srednia_pensja
from pracownicy p
join zarobki z on p.pracID = z.pracID
group by p.nazwisko
having avg(z.brutto) =
(
    select max(srednia)
    from
    (
        select avg(brutto) as srednia from zarobki group by pracID
    ) as xxx
)

union

select
    p.nazwisko,
    avg(z.brutto) as srednia_pensja
from pracownicy p
join zarobki z on p.pracID = z.pracID
group by p.nazwisko
having avg(z.brutto) = 2500.00

union

select
    p.nazwisko,
    avg(z.brutto) as srednia_pensja
from pracownicy p
join zarobki z on p.pracID = z.pracID
group by p.nazwisko
having avg(z.brutto) =
(
    select min(srednia)
    from
    (
        select avg(brutto) as srednia from zarobki group by pracID
    ) as xxx
)




ZAD8


create procedure zad_8
    @srednia money
as
begin
    declare @nazwisko varchar(50)
    declare @srednia_pensja money
    declare @i int = 1
    declare @ile int

    select @ile = count(*)
    from (
        select p.nazwisko
        from pracownicy p join zarobki z on p.pracID = z.pracID
        group by p.nazwisko
        having avg(z.brutto) = (select max(srednia) from (select avg(brutto) as srednia from zarobki group by pracID) as xxx)
        union
        select p.nazwisko
        from pracownicy p join zarobki z on p.pracID = z.pracID
        group by p.nazwisko
        having avg(z.brutto) = @srednia
    ) as t_count

    while @i <= @ile
    begin
        select
            @nazwisko = t_final.nazwisko,
            @srednia_pensja = t_final.srednia_pensja
        from (
            select
                nazwisko,
                srednia_pensja,
                row_number() over (order by nazwisko) as j
            from (
                select p.nazwisko, avg(z.brutto) as srednia_pensja
                from pracownicy p join zarobki z on p.pracID = z.pracID
                group by p.nazwisko
                having avg(z.brutto) = (select max(srednia) from (select avg(brutto) as srednia from zarobki group by pracID) as xxx)
                union
                select p.nazwisko, avg(z.brutto) as srednia_pensja
                from pracownicy p join zarobki z on p.pracID = z.pracID
                group by p.nazwisko
                having avg(z.brutto) = @srednia
            ) as t_union
        ) as t_final
        where t_final.j = @i

        print 'Pracownik: ' + @nazwisko + ', srednie zarobki: ' + convert(varchar, @srednia_pensja)

        set @i = @i + 1
    end
end

exec zad_8 2500.00
exec zad_8 999.00
exec zad_8 99999.00