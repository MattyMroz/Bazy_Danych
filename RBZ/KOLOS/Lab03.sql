---Cel ćwiczenia:
-----------------------------
--- Kontynuujemy pracę rozproszoną z wykorzystaniem funkcji openrowset()
-- instrukcja opisana jest w dokumentacji techniczej Microsoft:
--- https://docs.microsoft.com/en-us/sql/t-sql/functions/openrowset-transact-sql?view=sql-server-ver17


--- Rozwiązanie pracy domowej:
--------------------------------
-- Podać jaka jest wartość sprzedaży w poszczególnych 
-- miesiącach (serwer WA-06) dwóch lat
--o największej realizacji sprzedaży (serwer WA-08)


--- Realizujemy to etapami:

-- ETAP A:
-- piszemy dla osobne zapytania lokalne:
use Northwind
go

select TOP 2 YEAR(o.OrderDate) ROK, SUM(unitprice * quantity * (1 - Discount)) WARTOSC from [Order Details] od
join Orders o on o.OrderID = od.OrderID
GROUP BY YEAR(o.OrderDate)
ORDER BY WARTOSC desc
go

select YEAR(o.OrderDate) ROK,  MONTH(o.OrderDate) MIESIAC, SUM(unitprice * quantity * (1 - Discount)) WARTOSC from [Order Details] od
join Orders o on o.OrderID = od.OrderID
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate) 
go


-- Etap B:
-- piszemy zapytanie lokalne CTE:
-- W tym celu uruchomić przeglądarkę i wpisać: zapytanie CTE SQL Server
-- zapytanie CTE lokalne:

WITH mama as (
select TOP 2 YEAR(o.OrderDate) ROK, SUM(unitprice * quantity * (1 - Discount)) WARTOSC from [Order Details] od
join Orders o on o.OrderID = od.OrderID
GROUP BY YEAR(o.OrderDate)
ORDER BY WARTOSC desc
),
tata as (
select YEAR(o.OrderDate) ROK,  MONTH(o.OrderDate) MIESIAC, SUM(unitprice * quantity * (1 - Discount)) WARTOSC from [Order Details] od
join Orders o on o.OrderID = od.OrderID
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate) 
)
select t.ROK, t.MIESIAC, t.WARTOSC from mama m inner join tata t on m.ROK=t.ROK
order by 1,2


-- Etap C:
-- Dla pierwszego zapytania CTE
-- układamy instrukcję OPENROWSET.
-- W tym celu z dokumentacji Microsoft odszukać specyfikację OPENROWSET dla TRANSACT SQL


SELECT d.* FROM OPENROWSET(
    'MSOLEDBSQL',
    'WA-06';'sa';'praktyka',
    'select TOP 2 YEAR(o.OrderDate) ROK, SUM(unitprice * quantity * (1 - Discount)) WARTOSC from Northwind.dbo.[Order Details] od
	join Northwind.dbo.Orders o on o.OrderID = od.OrderID
	GROUP BY YEAR(o.OrderDate)
	ORDER BY WARTOSC desc'
) AS d

----------------------- 
-- Etap D:
-- kopiujemy do zapytania CTE lokalnego OPENROWSETY:

WITH mama_1 as (
SELECT d.* FROM OPENROWSET(
    'MSOLEDBSQL',
    'WA-06';'sa';'praktyka',
    'select TOP 2 YEAR(o.OrderDate) ROK, SUM(unitprice * quantity * (1 - Discount)) WARTOSC from Northwind.dbo.[Order Details] od
	join Northwind.dbo.Orders o on o.OrderID = od.OrderID
	GROUP BY YEAR(o.OrderDate)
	ORDER BY WARTOSC desc'
) AS d),
tata_1 as (
SELECT a.* FROM OPENROWSET(
    'MSOLEDBSQL',
    'WA-08';'sa';'praktyka',
	'select YEAR(o.OrderDate) ROK,  MONTH(o.OrderDate) MIESIAC, SUM(unitprice * quantity * (1 - Discount)) WARTOSC from Northwind.dbo.[Order Details] od
	join Northwind.dbo.Orders o on o.OrderID = od.OrderID
	GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)'
) AS a )
select t.ROK, t.MIESIAC, t.WARTOSC from mama_1 m inner join tata_1 t on m.ROK=t.ROK
order by 1,2
go





-- Zadanie 2: --> (UWAGA !!! --> wykonujemy tylko gdy pracujemy w nowym środowisku ORACLE (np. w domu) i nie mamy założonego konta ORACLE
------------------
--- Po zainstalowaniu środowiska ORACLE wykonać założyć nowego
-- użytkownika o identyfikatorze loginu NorthWind (z dowolnym hasłem). 
-- W dalszej kolejności nadać użytkownikowi NORTHWIND odpowiednie Role i prawa systemowe.

-- Zakładanie użytkownika w systemie ORACLE można przeprowadzić logując się na użytkownika i rolę
-- z odpowiednimi prawami administracyjnymi: sys oraz system

------------------------- TWORZENIE----------------
-- USER SQL
CREATE USER NORTHWIND IDENTIFIED BY 12345
DEFAULT TABLESPACE "USERS"
TEMPORARY TABLESPACE "TEMP";

-- QUOTAS

-- ROLES
GRANT "CONNECT" TO NORTHWIND;
GRANT "RESOURCE" TO NORTHWIND;
ALTER USER NORTHWIND DEFAULT ROLE "CONNECT","RESOURCE";

-- SYSTEM PRIVILEGES
GRANT UNLIMITED TABLESPACE TO NORTHWIND;

-- Zadanie 3:
-- w dalszej kolejności wykonać przeniesienie bazy danych NorthWind ze środowiska SQL Server do nowo utworzonego schematu NORTHWIND w systemie ORACLE


Zadanie 4
----------------
-- W dokumentacji ORACLE zapoznać się procesem konfiguracji procesu nasłuchu: LISTENER oraz trybem jego współdziałania z instancjami serwera ORACLE.
-- LISTENER to proces nasłuchujący na wybranym porcie (domyślnie 1521) i adresie IP maszyny serwera. Umożliwia on zdalny dostęp się do bazy danych przez łącza sieciowe. Po stronie serwera ORACLE (maszyny na której zainstalowana jest instancja ORACLE) znajduje się plik konfiguracyjny listener.ora.

-- Konfiguracja oraz plik konfiguracyjny listener.ora opisany został w dokumentacji technicznej ORACLE:
https://docs.oracle.com/cd/B28359_01/network.111/b28317/listener.htm#NETRF008

-- Zadanie 4a.
-----------------
--sprawdzić (dokonać) konfiguracji procesu nasłuchu LISTENER
-- określić:
	-- na jakim adresie IP (lub nazwie hosta) działa proces nasłuchu LISTENER
	-- na jakim porcie działa proces nasłuchu LISTENER (domyślnie 1521)

-- Rozwiązanie:
-- Konfigurację można sprawdzić z wykorzystaniem narzędzi graficznych np.: oracle - Net Manager, którego skrót dostępu  przy domyślnej instalacji
-- znajduje się w narzędziach instalacyjnych systemu operacyjnego
-- (w systemie Windows - skrót do Net Manager można odnaleźć w zasobie:  C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Oracle)

Konfiguracja dostępna jest również przez plik: listener.ora (ścieżka konfiguracyjna do katalogu: $ORACLE_HOME/network/admin)  w którym znajduje się opis konfiguracyjny:

# Generated by Oracle configuration tools.

SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC =
      (SID_NAME = CLRExtProc)
      (ORACLE_HOME = c:\ORACLE_19c\INSTALACJA\Inst_Oracle_19)
      (PROGRAM = extproc)
      (ENVS = "EXTPROC_DLLS=ONLY:c:\ORACLE_19c\INSTALACJA\Inst_Oracle_19\bin\oraclr18.dll")
    )
  )

LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
    )
  )



-- UWAGA !!!
-----------------------
-- W przypadku pracy rozproszonej po stronie aplikacji klienckiej w trybie dostępowym do serwera ORACLE z poziomu środowiska SQL Server  
-- konieczne jest ustawienie tzw. parametrów TNS : Local Naming Parameters (tnsnames.ora) lub skorzystanie z takiej specyfikacji bezpośrednio w instrukcji dostępowej OPENROWSET.

--- Plik tnsnames.ora oraz konfiguracja opisana została w dokumentacji technicznej ORACLE na stronie:
https://docs.oracle.com/cd/B28359_01/network.111/b28317/tnsnames.htm#NETRF259

--- Opis:
--------------
--- Plik tnsnames.ora - jest plikiem konfiguracyjnym, który zawiera nazwy usług sieciowych zmapowane do deskryptorów połączeń dla lokalnej metody nazewnictwa lub nazwy usług sieciowych. Zawiera on również nazwy TNS zmapowane na adresy protokołów nasłuchujących.

-- Nazwa usługi sieciowej - to alias odwzorowany na adres sieciowy bazy danych zawarty w pliku połączeniowym deskryptora. Deskryptor połączenia zawiera lokalizację nasłuchiwania za pośrednictwem adresu protokołu i nazwy usługi bazy danych, z którą należy się połączyć. 
-- Klienci i serwery baz danych (które są klientami innych serwerów baz danych) używają nazwy usługi podczas nawiązywania połączenia z aplikacją.

--- Plik tnsnames.ora domyślnie znajduje się w katalogu (system Windows):
 $ORACLE_HOME/network/admin
-- W systemach operacyjnych UNIX w katalogu  
%ORACLE_HOME%\network\admin


-- Ogólna składnia pliku tnsnames.ora :
--------------------------------------
-- Podstawową składnię pliku  tnsnames.ora pokazano w przykładzie:

net_service_name = 
 (DESCRIPTION = 
   (ADRES = (informacja o adresie protokołu ))
   (CONNECT_DATA = 
     (SERVICE_NAME = nazwa_usługi))) 


-- gdzie:

-- DESCRIPTION 	- zawiera deskryptor połączenia, 
-- ADDRESS 	- adres protokołu 
-- CONNECT_DATA	- informacje identyfikujące usługę bazy danych.


-- Wiele list adresów w tnsnames.ora:
----------------------------------
-- W pliku konfiguracyjnym tnsnames.ora możliwa jest również konfiguracja wielu list adresowych dla instancji ORACLE
-- W celu wykonania takiej konfiguracji zapoznać się z dokumentacją techniczną ORACLE:
https://docs.oracle.com/cd/B28359_01/network.111/b28317/tnsnames.htm#NETRF262



-- UWAGA !!!
--------------
-- Przed przystąpieniem do realizacji następnych zadań zapoznać się z podaną dokumentacją techniczną.


-------------------------- ZADANIE 4 ---------
-- Napisać zapytanie z użyciem instrukcji OPENROWET, które z systemu ORACLE zwróci datę zegara systemowego

----------------------------- Zadanie 5 -------------

-- Pobrać z serwera ORACLE wszystkie produkty. Dodatkowo w następnym kroku napisać zaszyfrowany widok, który będzie robił to samo:


-------------------------- Zadanie 6
------------------
--jakie mamy produkty serwera lokalnego które są na serwerze zdalnym ORACLE
-- w tej samej cenie jednostkowej?