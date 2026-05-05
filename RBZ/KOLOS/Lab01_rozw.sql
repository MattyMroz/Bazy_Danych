----------------------------
-- Zadania od 9 do 15 do zrealizowania i wymagane odesłanie do oceny w osobnym pliku. W pliku w pierwszym wierszu proszę podać Nazwisko, imię, numer -- indeksu. Nazwa pliku powinna zwierać nazwisko i imię. 
--------------------------
--- W środowisku SQL Server obiekty identyfikowane są w sposób bezwzględny przez czteroczłonowy identyfikator na który składa się:

<NazwaSerwera>.<NazwaBazy>.<Schemat>.<nazwaObiektu>


-- dzięki takiej identyfikacji możliwe jest pisanie zapytań (pod warunkiem, że mamy odpowiednie uprawnienia) do dowolnych obiektów baz danych.
-- W zapytaniach można również pominąć wybrane człony stosując dorozumiane ustawienie (np. nazwę serwera) np.:

use master
select * from Northwind.dbo.Categories



--lub jeśli login i użytkownik bazy ma ustawiony domyślny schemat jako dbo to możnanp. napisać zapytanie bez podawania schematu:
select * from Northwind..Categories


--- Zad. 1
-- Poszukać w dokumentacji SQL Server frazy: sp_configure (Transact-SQL). Zapoznać się z zakresem konfiguracji serwera SQL:
-- https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-configure-transact-sql?view=sql-server-ver17



--- Zad. 2
--- Sprawdzić ustawienia konfiguracyjne środowiska SQL Server pod kątem możliwości pisania rozproszonych zapytań "Ad Hoc" - wykorzystując w tym celu systemową procedurę: sp_configure (Transact-SQL) 

--- 
sp_configure 'show advanced options', 1
reconfigure

go
sp_configure 'Ad Hoc Distributed Queries',1
reconfigure



--- Zad. 3
-- w środowisku SQL Server sprawdzić jakie są widoczne sterowniki OLE DB, które pozwalają na dostęp do zdalnych źródeł danych.
-- W tym celu rozwinąć po lewej stronie pasek obiektów serwera SQL: --> <Server Objects> --> <Linked Servers>  --> <Providers>


--- Zad. 4
-- Dla sterownika SQLNCLI (lub starszej wersji SQLOLEDB) dokonać rekonfiguracji ustawień:


USE [master]
GO
EXEC master.dbo.sp_MSset_oledb_prop N'SQLNCLI11', N'AllowInProcess', 1
GO
EXEC master.dbo.sp_MSset_oledb_prop N'SQLNCLI11', N'DynamicParameters', 1
GO

--- Zad. 5
-- Postąpić podobnie z pozostałymi sterownikami dla środowiska Microsoft Office (sterownik [Microsoft.ACE.OLEDB.12.0]) 
--- oraz środowiska Oracle ([OraOLEDB.Oracle])


--- Zad. 6
-- Poszukać w dokumentacji SQL Server frazę: OPENROWSET (Transact-SQL). 
-- Zapoznać się z informacją dotyczącą możliwości uzyskania dostępu do danych zdalnych ze źródła danych OLE DB.:
-- https://docs.microsoft.com/en-us/sql/t-sql/functions/openrowset-transact-sql?view=sql-server-ver15


--- Zad. 7
--- Polecenie: sp_linkedservers pozwala na zwrócenie informacji (w lokalnym środowisku) dostępnych źródłach danych.
-- Po wyzwoleniu instrukcji:

sp_linkedservers

-- na liście powinien pojawić się identyfikator lokalnego serwera SQL który można wykorzystać w symulacji pracy zdalnej w symulując działanie środowiska rozproszonego.

--- Napisać przykładowe zapytanie:

---  Pobrać z serwera zdalnego (o identyfikatorze który zwrócony został po wyzwoleniu instrukcji sp_linkedservers) wszystkie produkty i ich ceny:
 -- W zapytaniu wykorzystać kryterium połączenia Trusted_Connection:

SELECT d.*
FROM OPENROWSET('SQLOLEDB', 'Server=ANIA;Trusted_Connection=yes;',
   'select pp.ProductName, pp.UnitPrice from northwind.dbo.products pp') AS d;

-- to samo zapytanie napisać następnie z wykorzystaniem podania loginu i hasła w instrukcji OPENROWSET.


--- Zad .8
--- Napisać zapytanie: z jakiej kategorii (serwer lokalny) mamy jakie produkty (serwer zdalny)?

select c.CategoryName, p.ProductName, p.UnitPrice
from [ANIA].northwind.dbo.categories c inner join  OPENROWSET('SQLOLEDB', 'Server=ANIA;Trusted_Connection=yes;',
   'select pp.CategoryID, pp.ProductName, pp.UnitPrice from northwind.dbo.products pp') p
on c.CategoryID=p.CategoryID



--- Zad. 9
---Na dysku c:\ założyć nowy katalog (np. \NorthWind) w którym utworzyć plik *.xlsx o nazwie .
--- W pliku tym w dowolnym skoroszycie utworzyć listę przedmiotów oraz uzyskanych ocen z tych przedmiotów.
-- Plik powinien zawierać następujące kolumny:
-- L.p. 
-- Przedmiot
--- Ocena
-- 
-- Napisać w środowisku SQL Server zapytanie, które zwróci wszystkie oceny z danych przedmiotów

SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.16.0', 
'Excel 12.0;Database=C:\northwind\listy.xls',
'select * from [oceny_do_www$]')

-- Zad. 10
-- odwołując się doo skoroszytu pliku *. xlsx pobrać wszystkie przedmioty których oceny są zaliczające