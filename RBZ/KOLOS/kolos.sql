/*
  1. Wykorzystanie zapytań AD HOC – funkcja OPENROWSET w dostępie do zdalnych źródeł danych
     z przetwarzaniem danych po stronie serwera zdalnego i serwera lokalnego:

     - dostęp SQLServer – SQLServer
     - dostęp SQLServer – ORACLE
     - dostęp SQLServer – Access
     - dostęp SQLServer – *.xls
     - wielodostęp w dowolnej konfiguracji SQLServer - ORACLE - Access, *.xls
       (sprzęganie jednocześnie różnych źródeł danych)

     Dostęp do zdalnych źródeł powinien odbywać się przez pisanie widoków i procedur rozproszonych:
     - rzutowanie różnych typów danych
     - posługiwanie się funkcjami agregującymi zdalnymi i lokalnymi
     - przetwarzanie zdalne i lokalne w widokach i procedurach
*/

/*
  2`. Ustanawianie serwerów połączonych (linkowanie zdalnych serwerów) w środowisku SQLServer
     oraz mapowanie praw loginu lokalnego na prawa loginu zdalnego:
     - funkcje sprawdzające źródła zdalne i ich konfigurację

     - linkowanie serwerów: SQLServer – SQLServer
     - linkowanie serwerów: SQLServer – ORACLE (tylko od strony SQL Server do Oracle)
     - linkowanie serwerów: SQLServer – Access
     - linkowanie serwerów: SQLServer – *.xls

     Dostęp do zdalnych źródeł powinien odbywać się przez pisanie widoków i procedur rozproszonych
     przy ustanowionych serwerach zdalnych (wielodostęp w środowiskach heterogenicznych)
*/

/*
  3. Pisanie zapytań przekazujących przy ustanowionym serwerze połączonym
     (przetwarzanie lokalne i zdalne danych)
     w tym z zastosowaniem funkcji: OPENQUERY
*/

/*
  4. Wstawianie i modyfikowanie danych na zdalnych źródłach danych
     z poziomu ustanowionego serwera połączonego
*/

/*
  5. Podstawy transakcji rozproszonych
     - Wykonywanie Transakcji rozproszonych (Begin Distributed Transaction)
     - Wyjaśnienie działania takich transakcji z wykorzystaniem
       MS Distributed Transaction Coordinator (MS DTC)
     - Konfiguracja MS DTC
*/

/*
  6. ORACLE - użytkownicy, prawa, role
*/

/*
1. Zagadnienia techniczne i programistyczne (SQL):
    - Instrukcje OPENROWSET i OPENQUERY: Wykorzystanie ich do przetwarzania danych (zarówno lokalnego, jak i zdalnego).
    - Linkowanie serwerów: Łączenie różnych środowisk bazodanowych. Głównym środowiskiem pracy będzie SQL Server, z którego studenci będą łączyć się do innych instancji SQL Server, baz Oracle, a także plików Access czy Excel.
    - Tworzenie obiektów w bazach: Pisanie zapytań przetwarzających, tworzenie widoków oraz procedur w środowiskach zlinkowanych.
    - Transakcje rozproszone: Obsługa modułu MS DTC, wstawianie danych jednocześnie na serwery lokalne i zdalne.

2. Administracja i konfiguracja:
    - Konfiguracja połączeń: Znajomość narzędzi takich jak Oracle Net Manager oraz podstawowa konfiguracja sieciowa (np. ustawienia zapór sieciowych / firewalli).
    - Zarządzanie użytkownikami: Zakładanie kont i logowanie się na nie.
    - Uprawnienia: Rozróżnianie i nadawanie uprawnień obiektowych oraz systemowych (np. uprawnienia do odczytu danych).
    - Podstawy Oracle: Umiejętność założenia lub skopiowania czegoś we własnym schemacie w bazie Oracle, jeśli zajdzie taka potrzeba.
*/

/*
Obowiązuje zakres materiału związany z definiowaniem:

0. zakładanie loginów i użytkowników oraz nadawanie niezbędnych minimalnych praw w środowisku SQL Server

a. ustanawiania serwerów połączonych w środowisku SQL Server oraz mapowania praw loginu lokalnego na prawa loginu zdalnego
    - dostęp SQL Server – SQL Server
    - dostęp SQL Server – ORACLE
    - dostęp SQL Server – Access
    - dostęp SQL Server – *.xls

b. pisanie (przy ustanowionym serwerze połączonym) zapytań przekazujących (przetwarzanie lokalne i zdalne danych) w tym z zastosowaniem funkcji: OPENQUERY

c. pisanie zapytań AD HOC – funkcja OPENROWSET – dostęp vide pkt. a.

d. pisanie widoków umożliwiających pracę na danych lokalnych i zdalnych (pamiętając o prawidłowym rzutowaniu typów (np. ze środowiska ORACLE))

e. pisanie procedur składowanych

f. MSDTC - transakcje

UWAGA !!! - zakres materiału związany z pracą z danymi rozproszonymi w środowisku ORACLE tzn. uchwytami database link nie obowiązuje na kolokwium.

*/


--- W SQL Server obiekty identyfikowane są są przez:
-- <NazwaSerwera>.<NazwaBazy>.<Schemat>.<nazwaObiektu>

use master;
select * from Northwind.dbo.Categories;

-- Jeśli login i użytkownik bazy ma ustawiony domyślny schemat jako dbo
select * from Northwind..Categories;

-- Odblokowanie opcji zaawansowanych:
-- https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-configure-transact-sql?view=sql-server-ver17
sp_configure 'show advanced options', 1
reconfigure
go

-- Włączenie zapytań rozproszonych (Ad Hoc)
sp_configure 'Ad Hoc Distributed Queries', 1
reconfigure
go

-- Sterowniki OLE DB w SQL Server
-- <Server Objects> --> <Linked Servers>  --> <Providers>
-- <Obiekty Serwera> --> <Połączone serwery>  --> <Dostawcy>

-- Konfiguracja sterownika SQLNCLI (lub starszej wersji SQLOLEDB)
-- PL: Parametr dynamiczy i Zezwalanie w toku

USE [master]
GO
EXEC master.dbo.sp_MSset_oledb_prop N'SQLOLEDB', N'AllowInProcess', 1
GO
EXEC master.dbo.sp_MSset_oledb_prop N'SQLOLEDB', N'DynamicParameters', 1
GO

-- To samo dla:
-- SQLOLEDB19
-- Microsoft.ACE.OLEDB.12.0
-- Microsoft.ACE.OLEDB.16.0
-- OraOLEDB.Oracle

-- Widocznowść sterowników OLE DB:
sp_enum_oledb_providers
go

-- Wyświetlenie listy serwerów połączonych/zlinkowanych
sp_linkedservers
go

-- OPENROWSET (Transact-SQL): https://learn.microsoft.com/pl-pl/sql/t-sql/functions/openrowset-transact-sql?view=sql-server-ver17

-- Wyświetlenie danych z serwera zdalnego (WB-20) z wykorzystaniem połączenia Trusted_Connection:
SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=WB-20;Trusted_Connection=yes;', --
    'select * from Northwind.dbo.Categories'
) AS a;

SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
    'SELECT * FROM dbo.Categories'
) AS a;

-- Serwer zdalny z podaniem loginu i hasła:
SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'WB-20';'sa';'praktyka',
    'select * from Northwind.dbo.Categories'
) AS a;

SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=WB-20;UID=sa;PWD=praktyka;Trusted_Connection=yes;',
    'SELECT * FROM Northwind.dbo.Categories'
) AS a;


-- Zapytanie: z jakiej kategorii (serwer lokalny) mamy jakie produkty (serwer zdalny)?

-- Sposób rozwiązania:
select c.CategoryName, p.ProductName
from Northwind.dbo.Categories as c
inner join Northwind.dbo.Products as p
on c.CategoryID = p.CategoryID

-- Rozwiązanie z wykorzystaniem OPENROWSET:
-- Symulujemy serwer zdalny przez lokalny serwer Mateusz.
SELECT p.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
    'SELECT pp.CategoryID, pp.ProductName FROM dbo.Products pp'
) AS p;

-- Rozwiązanie z wykorzystaniem OPENROWSET:
select c.CategoryName, p.ProductName
from Northwind.dbo.Categories as c
inner join OPENROWSET(
    'MSOLEDBSQL',
    'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
    'SELECT pp.CategoryID, pp.ProductName FROM dbo.Products pp'
) AS p
on c.CategoryID = p.CategoryID



-- Ponowne uruchomienie serwera SQL Server:
-- Win + R -> services.msc -> MSSQLSERVER -> Uruchom


-- SQL Server 2022 Configuration Manager w trybie Administratora
-- SQL Server Network Configuration -> MSSQLSERVER
-- TCP/IP -> Enable
-- Named Pipes -> Enable
-- SQL Server Services -> SQL Server Browser -> Properties ->  Service -> zmień Start Mode na Automatic | SQL Server Browser -> Start
-- SQL Server Services -> SQL Server (MSSQLSERVER) -> Restart

-- Zapora sieciowa (Firewall)
-- Panel sterowania -> System i zabezpieczenia -> Zapora systemowa Windows -> Zaawansowane ustawienia -> Reguły wejściowe (potem wyjściowe) -> Nowa reguła -> Port -> TCP -> 1433 -> Zaznacz "Zezwól na połączenie" -> Dalej -> Nazwa: SQL Server -> Zakończ


-- Oracle Net Manager
-- Directory -> Local -> Service Naming -> Create -> Name: PD25
-- Port: 1521
-- No obu




-- Excel i Access - sterownik Microsoft.ACE.OLEDB.12.0 lub Microsoft.ACE.OLEDB.16.0

-- Win + R ->MSSQLSERVER -> Właściwości -> Logowanie -> Lokalne konto systemowe -> Zastosuj -> OK

-- C:\Northwind -> Właściwości -> Zabezpieczenia -> Edytuj -> Dodaj użytkownika "Everyone" (Wszyscy) i daj mu uprawnienia do odczytu.
-- listy.xlsx
-- Northwind.mdb

-- Excel:
SELECT a.*
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'Excel 12.0;Database=C:\Northwind\listy.xlsx;HDR=YES;',
    'SELECT * FROM[oceny_do_www$]'
) AS a;


-- Access:
SELECT a.*
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'C:\Northwind\Northwind.mdb';'admin';'',
    'SELECT * FROM Kategorie'
) AS a;

-- Ddwołując się do skoroszytu pliku *. xlsx pobrać wszystkie przedmioty których oceny są zaliczające
SELECT a.*
FROM OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'Excel 12.0;Database=C:\Northwind\listy.xlsx;HDR=YES;',
    'SELECT * FROM[oceny_do_www$] WHERE Ocena >= 3'
) AS a;

-- Porównanie danych z serwera lokalnego i zdalnego (Accessa) - sprzęganie danych z różnych źródeł:
SELECT
    loc.CategoryID AS [ID Lokalny],
    loc.CategoryName AS [Nazwa SQL Server],
    acc.NazwaKategorii AS [Nazwa z Accessa]
FROM Northwind.dbo.Categories AS loc
INNER JOIN OPENROWSET(
    'Microsoft.ACE.OLEDB.12.0',
    'C:\Northwind\Northwind.mdb';'admin';'',
    'SELECT IDkategorii, NazwaKategorii FROM Kategorie'
) AS acc ON loc.CategoryID = acc.IDkategorii;

-- ============================================================
-- ZADANIA
-- UWAGA: serwery zdalne (WA-02, WA-07, WA-11, WA-12, WA-18, WA-20)
--        symulujemy przez lokalny serwer Mateusz z bazą Northwind.
-- ============================================================

-- Zad. 1:
-- Z jakiej kategorii (serwer lokalny) mamy jakie produkty (serwer zdalny WA-02)
-- dostarczone przez jakiego dostawcę (serwer zdalny WA-07)?

-- Sposób rozwiązania:
select c.CategoryName, p.ProductName, s.CompanyName
from Northwind.dbo.Categories as c
inner join Northwind.dbo.Products as p
on c.CategoryID = p.CategoryID
inner join Northwind.dbo.Suppliers as s
on p.SupplierID = s.SupplierID

-- Rozwiązanie z wykorzystaniem OPENROWSET dla WA-02:
-- WA-02 udajemy przez lokalny serwer Mateusz.
SELECT p.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
    'SELECT pp.CategoryID, pp.ProductName, pp.SupplierID FROM dbo.Products pp'
) AS p;

-- Rozwiązanie z wykorzystaniem OPENROWSET dla WA-07:
-- WA-07 udajemy przez lokalny serwer Mateusz.
SELECT s.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
    'SELECT ss.SupplierID, ss.CompanyName FROM dbo.Suppliers ss'
) AS s;

-- Rozwiązanie z wykorzystaniem OPENROWSET:
select c.CategoryName, p.ProductName, s.CompanyName
from Northwind.dbo.Categories as c
inner join OPENROWSET(
    'MSOLEDBSQL',
    'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
    'SELECT pp.CategoryID, pp.ProductName, pp.SupplierID FROM dbo.Products pp'
) AS p
on c.CategoryID = p.CategoryID
inner join OPENROWSET(
    'MSOLEDBSQL',
    'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
    'SELECT ss.SupplierID, ss.CompanyName FROM dbo.Suppliers ss'
) AS s
on p.SupplierID = s.SupplierID


-- Zad. 2:
-- Jakie produkty serwera lokalnego, których nazwa zaczyna się na literę od C do P,
-- znajdują się również na serwerze zdalnym WA-11?
-- UWAGA: z serwera zdalnego mają być pobrane jedynie te krotki,
--        które spełniają kryterium klauzuli WHERE tego zapytania.

-- Sposób rozwiązania:
select p.ProductName, p.UnitPrice
from Northwind.dbo.Products as p
inner join Northwind.dbo.Products as pp
on p.ProductName = pp.ProductName
where pp.ProductName >= 'C'
    and pp.ProductName < 'Q'

-- Rozwiązanie z wykorzystaniem OPENROWSET dla WA-11:
-- WA-11 udajemy przez lokalny serwer Mateusz,
-- ale filtrowanie wykonujemy po stronie zdalnej.
SELECT p.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
    'SELECT pp.ProductName, pp.UnitPrice
     FROM dbo.Products pp
     WHERE pp.ProductName >= ''C''
       AND pp.ProductName < ''Q'''
) AS p;

-- Rozwiązanie z wykorzystaniem OPENROWSET:
select p.ProductName, p.UnitPrice
from Northwind.dbo.Products as p
inner join OPENROWSET(
    'MSOLEDBSQL',
    'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
    'SELECT pp.ProductName, pp.UnitPrice
     FROM dbo.Products pp
     WHERE pp.ProductName >= ''C''
       AND pp.ProductName < ''Q'''
) AS pp
on p.ProductName = pp.ProductName
where p.ProductName >= 'C'
    and p.ProductName < 'Q'


-- Zad. 3:
-- Jakie produkty serwera lokalnego znajdują się na serwerze zdalnym WA-12
-- w tej samej cenie jednostkowej?

-- Sposób rozwiązania:
select p.ProductName, p.UnitPrice
from Northwind.dbo.Products as p
inner join Northwind.dbo.Products as pp
on p.ProductName = pp.ProductName
and p.UnitPrice = pp.UnitPrice

-- Rozwiązanie z wykorzystaniem OPENROWSET dla WA-12:
-- WA-12 udajemy przez lokalny serwer Mateusz.
SELECT p.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
    'SELECT pp.ProductName, pp.UnitPrice FROM dbo.Products pp'
) AS p;

-- Rozwiązanie z wykorzystaniem OPENROWSET:
select p.ProductName, p.UnitPrice
from Northwind.dbo.Products as p
inner join OPENROWSET(
    'MSOLEDBSQL',
    'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
    'SELECT pp.ProductName, pp.UnitPrice FROM dbo.Products pp'
) AS pp
on p.ProductName = pp.ProductName
and p.UnitPrice = pp.UnitPrice


-- Zad. 4:
-- Podać jaka jest wartość sprzedaży w poszczególnych miesiącach (serwer WA-20)
-- dla dwóch lat o największej realizacji sprzedaży (serwer WA-18).

-- Sposób rozwiązania:
select YEAR(o.OrderDate) AS Rok,
       MONTH(o.OrderDate) AS Miesiac,
       ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS WartoscSprzedazy
from Northwind.dbo.Orders as o
inner join Northwind.dbo.[Order Details] as od
on o.OrderID = od.OrderID
where YEAR(o.OrderDate) in (
    select top 2 YEAR(oo.OrderDate)
    from Northwind.dbo.Orders as oo
    inner join Northwind.dbo.[Order Details] as odd
    on oo.OrderID = odd.OrderID
    group by YEAR(oo.OrderDate)
    order by SUM(odd.UnitPrice * odd.Quantity * (1 - odd.Discount)) DESC
)
group by YEAR(o.OrderDate), MONTH(o.OrderDate)
order by YEAR(o.OrderDate), MONTH(o.OrderDate)

-- Rozwiązanie z wykorzystaniem OPENROWSET dla WA-18:
-- WA-18 udajemy przez lokalny serwer Mateusz.
SELECT TOP 2
    YEAR(o.OrderDate) AS Rok,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS WartoscSprzedazy
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
    'SELECT oo.OrderID, oo.OrderDate FROM dbo.Orders oo'
) AS o
INNER JOIN OPENROWSET(
    'MSOLEDBSQL',
    'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
    'SELECT od.OrderID, od.UnitPrice, od.Quantity, od.Discount FROM dbo.[Order Details] od'
) AS od
ON o.OrderID = od.OrderID
GROUP BY YEAR(o.OrderDate)
ORDER BY SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) DESC;

-- Rozwiązanie z wykorzystaniem OPENROWSET dla WA-20:
-- WA-20 udajemy przez lokalny serwer Mateusz.
SELECT
    YEAR(o.OrderDate) AS Rok,
    MONTH(o.OrderDate) AS Miesiac,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS WartoscSprzedazy
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
    'SELECT oo.OrderID, oo.OrderDate FROM dbo.Orders oo'
) AS o
INNER JOIN OPENROWSET(
    'MSOLEDBSQL',
    'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
    'SELECT od.OrderID, od.UnitPrice, od.Quantity, od.Discount FROM dbo.[Order Details] od'
) AS od
ON o.OrderID = od.OrderID
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
ORDER BY YEAR(o.OrderDate), MONTH(o.OrderDate);

-- Rozwiązanie z wykorzystaniem OPENROWSET:
SELECT YEAR(o.OrderDate) AS Rok,
       MONTH(o.OrderDate) AS Miesiac,
       ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS WartoscSprzedazy
FROM OPENROWSET(
    'MSOLEDBSQL',
    'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
    'SELECT oo.OrderID, oo.OrderDate FROM dbo.Orders oo'
) AS o
INNER JOIN OPENROWSET(
    'MSOLEDBSQL',
    'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
    'SELECT od.OrderID, od.UnitPrice, od.Quantity, od.Discount FROM dbo.[Order Details] od'
) AS od
ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) IN (
    SELECT TOP 2 YEAR(oo.OrderDate)
    FROM OPENROWSET(
        'MSOLEDBSQL',
        'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
        'SELECT ooo.OrderID, ooo.OrderDate FROM dbo.Orders ooo'
    ) AS oo
    INNER JOIN OPENROWSET(
        'MSOLEDBSQL',
        'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
        'SELECT odd.OrderID, odd.UnitPrice, odd.Quantity, odd.Discount FROM dbo.[Order Details] odd'
    ) AS odd
    ON oo.OrderID = odd.OrderID
    GROUP BY YEAR(oo.OrderDate)
    ORDER BY SUM(odd.UnitPrice * odd.Quantity * (1 - odd.Discount)) DESC
)
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
ORDER BY YEAR(o.OrderDate), MONTH(o.OrderDate);



-- Oracle
C:\Users\mateu\Desktop\WINDOWS.X64_193000_db_home\NETWORK\ADMIN\

-- 1. Co trzeba zrobic na Oracle:
-- Ustawic znane haslo dla kont SYS i SYSTEM z poziomu CDB$ROOT.

-- 2. Spis komend:
-- SELECT SYS_CONTEXT('USERENV', 'CON_NAME') AS con_name FROM dual;
-- ALTER SESSION SET CONTAINER = CDB$ROOT;
-- ALTER USER sys IDENTIFIED BY 12345 ACCOUNT UNLOCK CONTAINER=ALL;
-- ALTER USER system IDENTIFIED BY 12345 ACCOUNT UNLOCK CONTAINER=ALL;
-- SELECT username, account_status FROM dba_users WHERE username IN ('SYS', 'SYSTEM');

-- 3. Co z tego wynika:
-- Do SQL Server logujemy sie jako system / 12345 / rola Default.
-- Oracle jest na VM, wiec w SQL Server uzywamy IP VM 192.168.64.133, a nie localhost.

-- To działa!!!
SELECT a.*
FROM OPENROWSET(
    'OraOLEDB.Oracle',
    '(DESCRIPTION =
        (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.64.133)(PORT = 1521))
        (CONNECT_DATA =
            (SERVICE_NAME = PDB)
        )
    )';'system';'12345',
    'SELECT to_char(SYSDATE, ''YYYY-MM-DD:HH24:MI'') AS OracleTime FROM dual'
) AS a;

SELECT a.*
FROM OPENROWSET(
    'OraOLEDB.Oracle',
    '(DESCRIPTION =
        (ADDRESS = (PROTOCOL = TCP)(HOST = Mateusz.localdomain)(PORT = 1521))
        (CONNECT_DATA =
        (SERVER = SHARED)
        (SERVICE_NAME = mattymroz)
        )
    )';'system';'12345',
    'SELECT to_char(SYSDATE, ''YYYY-MM-DD:HH24:MI'') AS OracleTime FROM dual'
) AS a;



-- NORTHWIND tworzymy jako zwyklego lokalnego usera w PDB.
-- Uwaga: northwind i NORTHWIND to to samo, jesli nazwa nie jest w cudzyslowie.
-- Haslo w Oracle jest case-sensitive.

SELECT SYS_CONTEXT('USERENV', 'CON_NAME') AS con_name FROM dual;
ALTER SESSION SET CONTAINER = PDB;
SELECT SYS_CONTEXT('USERENV', 'CON_NAME') AS con_name FROM dual;

CREATE USER NORTHWIND IDENTIFIED BY "12345"
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP;

GRANT CONNECT TO NORTHWIND;
GRANT RESOURCE TO NORTHWIND;
ALTER USER NORTHWIND DEFAULT ROLE CONNECT, RESOURCE;
GRANT CREATE VIEW TO NORTHWIND;
GRANT UNLIMITED TABLESPACE TO NORTHWIND;

-- Jesli user juz istnieje, zamiast CREATE USER odpal tylko to:
ALTER USER NORTHWIND IDENTIFIED BY "12345" ACCOUNT UNLOCK;
GRANT CONNECT TO NORTHWIND;
GRANT RESOURCE TO NORTHWIND;
ALTER USER NORTHWIND DEFAULT ROLE CONNECT, RESOURCE;
GRANT CREATE VIEW TO NORTHWIND;
GRANT UNLIMITED TABLESPACE TO NORTHWIND;

-- Potem zaloguj sie jako NORTHWIND i uruchom plik Northwind_Oracle.sql jako skrypt.
-- Po imporcie test z SQL Server powinien wygladac tak:
SELECT a.*
FROM OPENROWSET(
    'OraOLEDB.Oracle',
    '(DESCRIPTION =
        (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.64.133)(PORT = 1521))
        (CONNECT_DATA =
            (SERVICE_NAME = PDB)
        )
    )';'NORTHWIND';'12345',
    'SELECT * FROM PRODUCTS'
) AS a;


SELECT a.*
FROM OPENROWSET(
    'OraOLEDB.Oracle',
    '(DESCRIPTION =
        (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.64.133)(PORT = 1521))
        (CONNECT_DATA =
            (SERVICE_NAME = PDB)
        )
    )';'system';'12345',
    'SELECT * FROM Northwind.Categories'
) AS a;



/*
-- Uruchom w Oracle jako SYSTEM, gdy user NORTHWIND nie istnieje.

ALTER SESSION SET CONTAINER = PDB;

CREATE USER NORTHWIND IDENTIFIED BY "12345"
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP;

GRANT CONNECT TO NORTHWIND;
GRANT RESOURCE TO NORTHWIND;
ALTER USER NORTHWIND DEFAULT ROLE CONNECT, RESOURCE;
GRANT CREATE VIEW TO NORTHWIND;
GRANT UNLIMITED TABLESPACE TO NORTHWIND;

-- Jezeli user juz istnieje:
ALTER USER NORTHWIND IDENTIFIED BY "12345" ACCOUNT UNLOCK;
*/


-- Zadanie 5 - produkty z Oracle osobno
SELECT p.*
FROM OPENROWSET(
    'OraOLEDB.Oracle',
    '(DESCRIPTION =
        (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.64.133)(PORT = 1521))
        (CONNECT_DATA =
        (SERVICE_NAME = PDB)
        )
    )';'NORTHWIND';'12345',
    'SELECT ProductID, ProductName, UnitPrice FROM Products'
) AS p;
GO

-- Widok
CREATE OR ALTER VIEW dbo.V1_LAB03_ORACLE_PRODUCTS
WITH ENCRYPTION
AS
SELECT p.*
FROM OPENROWSET(
    'OraOLEDB.Oracle',
    '(DESCRIPTION =
        (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.64.133)(PORT = 1521))
        (CONNECT_DATA =
        (SERVICE_NAME = PDB)
        )
    )';'NORTHWIND';'12345',
    'SELECT ProductID, ProductName, UnitPrice FROM Products'
) AS p;
GO

SELECT *
FROM dbo.V1_LAB03_ORACLE_PRODUCTS;
GO

-- Zadanie 6 - najpierw produkty lokalne
SELECT ProductID, ProductName, UnitPrice
FROM Northwind.dbo.Products;
GO

-- Zadanie 6 - potem produkty Oracle
SELECT p.*
FROM OPENROWSET(
    'OraOLEDB.Oracle',
    '(DESCRIPTION =
        (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.64.133)(PORT = 1521))
        (CONNECT_DATA =
        (SERVICE_NAME = PDB)
        )
    )';'NORTHWIND';'12345',
    'SELECT ProductName, UnitPrice FROM Products'
) AS p;
GO

-- Zadanie 6 - finalne porownanie cen
SELECT
    p.ProductName AS ProduktSQLServer,
    p.UnitPrice AS CenaSQLServer,
    o.ProductName AS ProduktOracle,
    o.UnitPrice AS CenaOracle
FROM Northwind.dbo.Products AS p
INNER JOIN OPENROWSET(
    'OraOLEDB.Oracle',
    '(DESCRIPTION =
        (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.64.133)(PORT = 1521))
        (CONNECT_DATA =
        (SERVICE_NAME = PDB)
        )
    )';'NORTHWIND';'12345',
    'SELECT ProductName, UnitPrice FROM Products'
) AS o
    ON p.ProductName = o.ProductName
    AND p.UnitPrice = o.UnitPrice
ORDER BY p.ProductName;
GO





-- Zadania:
-- Jaki klient (ORACLE) zrealizował jakie zamówienia (SQLSERVER lokalny) na którym są jakie produkty ACCESS)
-- obsłużone przez jakiego pracownika (SQL Server: WA-03) 

-- Najpierw zwykle zapytanie lokalne
SELECT
	c.CompanyName AS Klient,
	c.ContactName AS KontaktKlienta,
	o.OrderID AS NrZamowienia,
	p.ProductName AS Produkt,
	od.UnitPrice AS CenaJednostkowa,
	od.Quantity AS Ilosc,
	e.LastName + ' ' + e.FirstName AS Pracownik
FROM Northwind.dbo.Customers AS c
INNER JOIN Northwind.dbo.Orders AS o
	ON c.CustomerID = o.CustomerID
INNER JOIN Northwind.dbo.[Order Details] AS od
	ON o.OrderID = od.OrderID
INNER JOIN Northwind.dbo.Products AS p
	ON od.ProductID = p.ProductID
INNER JOIN Northwind.dbo.Employees AS e
	ON o.EmployeeID = e.EmployeeID;
GO

-- Klienci z Oracle osobno
SELECT c.*
FROM OPENROWSET(
	'OraOLEDB.Oracle',
	'(DESCRIPTION =
		(ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.64.133)(PORT = 1521))
		(CONNECT_DATA =
			(SERVICE_NAME = PDB)
		)
	)';'NORTHWIND';'12345',
	'SELECT CustomerID, CompanyName, ContactName FROM Customers'
) AS c;
GO

-- Zamowienia z SQL Server lokalnego osobno
SELECT o.*
FROM OPENROWSET(
	'MSOLEDBSQL',
	'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
	'SELECT o.OrderID, o.CustomerID, o.EmployeeID, od.ProductID, od.UnitPrice, od.Quantity
	 FROM dbo.Orders AS o
	 INNER JOIN dbo.[Order Details] AS od ON o.OrderID = od.OrderID'
) AS o;
GO

-- Produkty z Access osobno
SELECT
	p.IDproduktu AS ProductID,
	p.NazwaProduktu AS ProductName
FROM OPENROWSET(
	'Microsoft.ACE.OLEDB.12.0',
	'C:\Northwind\Northwind.mdb';'admin';'',
	'SELECT IDproduktu, NazwaProduktu FROM Produkty'
) AS p;
GO

-- Pracownicy z SQL Server osobno
SELECT e.*
FROM OPENROWSET(
	'MSOLEDBSQL',
	'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
	'SELECT EmployeeID, LastName, FirstName FROM dbo.Employees'
) AS e;
GO

-- Finalne zapytanie rozproszone z with
;WITH klienci AS (
	SELECT c.*
	FROM OPENROWSET(
		'OraOLEDB.Oracle',
		'(DESCRIPTION =
			(ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.64.133)(PORT = 1521))
			(CONNECT_DATA =
				(SERVICE_NAME = PDB)
			)
		)';'NORTHWIND';'12345',
		'SELECT CustomerID, CompanyName, ContactName FROM Customers'
	) AS c
),
zamowienia AS (
	SELECT o.*
	FROM OPENROWSET(
		'MSOLEDBSQL',
		'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
		'SELECT o.OrderID, o.CustomerID, o.EmployeeID, od.ProductID, od.UnitPrice, od.Quantity
		 FROM dbo.Orders AS o
		 INNER JOIN dbo.[Order Details] AS od ON o.OrderID = od.OrderID'
	) AS o
),
produkty AS (
	SELECT
		p.IDproduktu AS ProductID,
		p.NazwaProduktu AS ProductName
	FROM OPENROWSET(
		'Microsoft.ACE.OLEDB.12.0',
		'C:\Northwind\Northwind.mdb';'admin';'',
		'SELECT IDproduktu, NazwaProduktu FROM Produkty'
	) AS p
),
pracownicy AS (
	SELECT e.*
	FROM OPENROWSET(
		'MSOLEDBSQL',
		'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
		'SELECT EmployeeID, LastName, FirstName FROM dbo.Employees'
	) AS e
)
SELECT
	k.CompanyName AS Klient,
	k.ContactName AS KontaktKlienta,
	z.OrderID AS NrZamowienia,
	p.ProductName AS Produkt,
	z.UnitPrice AS CenaJednostkowa,
	z.Quantity AS Ilosc,
	pr.LastName + ' ' + pr.FirstName AS Pracownik
FROM zamowienia AS z
INNER JOIN klienci AS k
	ON z.CustomerID = k.CustomerID
INNER JOIN produkty AS p
	ON z.ProductID = p.ProductID
INNER JOIN pracownicy AS pr
	ON z.EmployeeID = pr.EmployeeID;
GO


-- Linkowanie serwerów
/*
    sp_addlinkedserver - tworzy połączenie.
    sp_addlinkedsrvlogin - podaje login i hasło.
    sp_serveroption - włącza RPC.
    sp_dropserver - usuwa połączenie (pamiętaj o 'droplogins').
    sp_linkedservers - wyświetla listę aktualnie zlinkowanych serwerów (żeby sprawdzić, czy się udało)
*/


-- ============================================================
-- SCIAGA: LINKOWANIE SERWEROW (LINKED SERVERS)
-- Najpierw komendy do nauki, potem gotowe scenariusze lokalne.
-- Preferowane sprawdzenie: OPENQUERY.
-- OPENROWSET zostawiamy glownie do Ad Hoc, bez stalego linked servera.
-- W tej sekcji uzywam zwyklych stringow ''...'' - bez prefiksu N.
-- ============================================================

USE master;
GO

-- Przydatne komendy na kolokwium:
-- EXEC sp_linkedservers;
-- EXEC sp_helpserver;
-- EXEC sp_helpserver 'LS_SQL_MATEUSZ';
-- EXEC sp_catalogs 'LS_SQL_MATEUSZ';
-- EXEC sp_tables_ex 'LS_SQL_MATEUSZ';
-- EXEC sp_columns_ex 'LS_SQL_MATEUSZ', NULL, NULL, 'Products';
-- EXEC sp_tables_ex 'LS_ACCESS_NORTHWIND';
-- EXEC sp_columns_ex 'LS_ACCESS_NORTHWIND', NULL, NULL, 'Produkty';
-- EXEC sp_columns_ex 'LS_EXCEL_LISTY', NULL, NULL, 'oceny_do_www$';
-- EXEC sp_enum_oledb_providers;
GO

-- Dodatkowa konfiguracja providerow OLE DB.
-- Przy Access/Excel/Oracle czesto pomaga, gdy linked server nie chce wystartowac.
EXEC master.dbo.sp_MSset_oledb_prop 'MSOLEDBSQL', 'AllowInProcess', 1;
EXEC master.dbo.sp_MSset_oledb_prop 'MSOLEDBSQL', 'DynamicParameters', 1;
EXEC master.dbo.sp_MSset_oledb_prop 'OraOLEDB.Oracle', 'AllowInProcess', 1;
EXEC master.dbo.sp_MSset_oledb_prop 'OraOLEDB.Oracle', 'DynamicParameters', 1;
EXEC master.dbo.sp_MSset_oledb_prop 'Microsoft.ACE.OLEDB.12.0', 'AllowInProcess', 1;
EXEC master.dbo.sp_MSset_oledb_prop 'Microsoft.ACE.OLEDB.12.0', 'DynamicParameters', 1;
GO


-- ============================================================
-- 1. SQL Server -> SQL Server
-- Zdalny SQL symulujemy lokalnym serwerem Mateusz.
-- ============================================================

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = 'LS_SQL_MATEUSZ')
    EXEC sp_dropserver 'LS_SQL_MATEUSZ', 'droplogins';
GO

EXEC sp_addlinkedserver
    @server = 'LS_SQL_MATEUSZ',
    @srvproduct = '',
    @provider = 'MSOLEDBSQL',
    @datasrc = 'Mateusz',
    @catalog = 'Northwind';
GO

EXEC sp_addlinkedsrvlogin
    @rmtsrvname = 'LS_SQL_MATEUSZ',
    @useself = 'true',
    @locallogin = NULL;
GO

EXEC sp_serveroption 'LS_SQL_MATEUSZ', 'data access', 'true';
EXEC sp_serveroption 'LS_SQL_MATEUSZ', 'rpc', 'true';
EXEC sp_serveroption 'LS_SQL_MATEUSZ', 'rpc out', 'true';
GO

-- Preferowany test przez OPENQUERY.
SELECT TOP 5 *
FROM OPENQUERY(
    LS_SQL_MATEUSZ,
    'SELECT ProductID, ProductName, UnitPrice FROM Northwind.dbo.Products ORDER BY ProductID'
);
GO

-- Dodatkowo: klasyczny czteroczlonowy zapis dla SQL Server.
SELECT TOP 5 ProductID, ProductName, UnitPrice
FROM LS_SQL_MATEUSZ.Northwind.dbo.Products
ORDER BY ProductID;
GO


-- ============================================================
-- 2. SQL Server -> Oracle (PDB na VM)
-- Zakladam usera NORTHWIND / 12345 w PDB.
-- ============================================================

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = 'LS_ORACLE_PDB')
    EXEC sp_dropserver 'LS_ORACLE_PDB', 'droplogins';
GO

EXEC sp_addlinkedserver
    @server = 'LS_ORACLE_PDB',
    @srvproduct = 'Oracle',
    @provider = 'OraOLEDB.Oracle',
    @datasrc = '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.64.133)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=PDB)))';
GO

EXEC sp_addlinkedsrvlogin
    @rmtsrvname = 'LS_ORACLE_PDB',
    @useself = 'false',
    @locallogin = NULL,
    @rmtuser = 'NORTHWIND',
    @rmtpassword = '12345';
GO

EXEC sp_serveroption 'LS_ORACLE_PDB', 'data access', 'true';
EXEC sp_serveroption 'LS_ORACLE_PDB', 'rpc', 'true';
EXEC sp_serveroption 'LS_ORACLE_PDB', 'rpc out', 'true';
GO

SELECT *
FROM OPENQUERY(
    LS_ORACLE_PDB,
    'SELECT TO_CHAR(SYSDATE, ''YYYY-MM-DD HH24:MI'') AS OracleTime FROM dual'
);
GO

SELECT *
FROM OPENQUERY(
    LS_ORACLE_PDB,
    'SELECT ProductID, TO_CHAR(ProductName) AS ProductName, UnitPrice FROM Products'
);
GO


-- ============================================================
-- 3. SQL Server -> Access
-- SQL Server service account musi miec prawo odczytu do pliku .mdb.
-- ============================================================

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = 'LS_ACCESS_NORTHWIND')
    EXEC sp_dropserver 'LS_ACCESS_NORTHWIND', 'droplogins';
GO

EXEC sp_addlinkedserver
    @server = 'LS_ACCESS_NORTHWIND',
    @srvproduct = 'Access',
    @provider = 'Microsoft.ACE.OLEDB.12.0',
    @datasrc = 'C:\Northwind\Northwind.mdb';
GO

EXEC sp_addlinkedsrvlogin
    @rmtsrvname = 'LS_ACCESS_NORTHWIND',
    @useself = 'false',
    @locallogin = NULL,
    @rmtuser = 'Admin',
    @rmtpassword = '';
GO

EXEC sp_serveroption 'LS_ACCESS_NORTHWIND', 'data access', 'true';
GO

SELECT *
FROM OPENQUERY(
    LS_ACCESS_NORTHWIND,
    'SELECT IDproduktu, NazwaProduktu, IDdostawcy FROM Produkty'
);
GO


-- ============================================================
-- 4. SQL Server -> Excel
-- SQL Server service account musi miec prawo odczytu do pliku .xlsx.
-- ============================================================

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = 'LS_EXCEL_LISTY')
    EXEC sp_dropserver 'LS_EXCEL_LISTY', 'droplogins';
GO

EXEC sp_addlinkedserver
    @server = 'LS_EXCEL_LISTY',
    @srvproduct = 'Excel',
    @provider = 'Microsoft.ACE.OLEDB.12.0',
    @datasrc = 'C:\Northwind\listy.xlsx',
    @provstr = 'Excel 12.0;HDR=YES';
GO

EXEC sp_addlinkedsrvlogin
    @rmtsrvname = 'LS_EXCEL_LISTY',
    @useself = 'false',
    @locallogin = NULL,
    @rmtuser = 'Admin',
    @rmtpassword = '';
GO

EXEC sp_serveroption 'LS_EXCEL_LISTY', 'data access', 'true';
GO

SELECT *
FROM OPENQUERY(
    LS_EXCEL_LISTY,
    'SELECT * FROM [oceny_do_www$]'
);
GO

SELECT *
FROM OPENQUERY(
    LS_EXCEL_LISTY,
    'SELECT * FROM [oceny_do_www$] WHERE Ocena >= 3'
);
GO


-- ============================================================
-- 5. Krotkie testy kontrolne po linkowaniu
-- ============================================================

EXEC sp_linkedservers;
GO

EXEC sp_helpserver 'LS_SQL_MATEUSZ';
EXEC sp_helpserver 'LS_ORACLE_PDB';
EXEC sp_helpserver 'LS_ACCESS_NORTHWIND';
EXEC sp_helpserver 'LS_EXCEL_LISTY';
GO


-- ============================================================
-- 6. Minimalne przyklady OPENQUERY do zapamietania
-- ============================================================

SELECT *
FROM OPENQUERY(
    LS_SQL_MATEUSZ,
    'SELECT CategoryID, CategoryName FROM Northwind.dbo.Categories'
);
GO

SELECT *
FROM OPENQUERY(
    LS_ORACLE_PDB,
    'SELECT TO_CHAR(CustomerID) AS CustomerID, TO_CHAR(CompanyName) AS CompanyName FROM Customers'
);
GO

SELECT *
FROM OPENQUERY(
    LS_ACCESS_NORTHWIND,
    'SELECT IDkategorii, NazwaKategorii FROM Kategorie'
);
GO

SELECT *
FROM OPENQUERY(
    LS_EXCEL_LISTY,
    'SELECT Egzamin, Ocena FROM [oceny_do_www$]'
);
GO


-- ============================================================
-- 7. Sprzatanie po cwiczeniu
-- Odpal tylko wtedy, gdy chcesz usunac linked servers.
-- ============================================================
/*
IF EXISTS (SELECT 1 FROM sys.servers WHERE name = 'LS_EXCEL_LISTY')
    EXEC sp_dropserver 'LS_EXCEL_LISTY', 'droplogins';
GO

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = 'LS_ACCESS_NORTHWIND')
    EXEC sp_dropserver 'LS_ACCESS_NORTHWIND', 'droplogins';
GO

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = 'LS_ORACLE_PDB')
    EXEC sp_dropserver 'LS_ORACLE_PDB', 'droplogins';
GO

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = 'LS_SQL_MATEUSZ')
    EXEC sp_dropserver 'LS_SQL_MATEUSZ', 'droplogins';
GO
*/



--  Zapoznać się z ustanawianiem serwera połączonego oraz wykonać następujące kroki:

--1. sterownik OLDB --> konfiguracja
--2. dodanie serwera połączonego
--3. mapowanie praw i nadawanie uprawnień
--4. ustawienie dostępu na infrastrukturze

-- Ustanowić serwer połączony ORACLE z wykorzystaniem opcji konfiguracyjnych
-- wprowadzonych w aplikacji Oracle Net Manager (korzystamy z ustawień, które
-- wprowadzone zostały na poprzednich zajęciach)


-- Napisać zapytanie rozproszone:
-- pobrać wszystkich pracowników z tabeli EMP schematu SCOTT:

-- Ustanowić serwer połączony Access (plik Access powinien znajdować się na dysku C:)
-- następnie napisać zapytanie jakie mamy produkty na serwerze Access:

-- Napisać zapytanie:
-- jaki klient (serwer: ORACLE) zrealizował jakie zamówienia (serwer: WA-09) na 
-- których są jakie produkty (serwer: Access)
-- dostarczone przez jakiego dostawcę (serwer lokalny)


-- Zapytanie:
-- Podać z serwera ORACLE: jakie produkty miały wartość sumarycznej sprzedaży (suma 
-- sprzedaży z poszczególnych zamówień względem nazwy produktu) w 
-- poszczególnych miesiącach roku 1998 i 1997.

-- Następnie:
-- dla tak przygotowanego zapytania tworzymy na jego podstawie tabelę: tab1, 
-- która zostanie wypełniona danymi.
-- UWAGA: w tabeli tej ustawić typ DATETIME dla dat poszczególnych miesięcy tego zapytania.

USE master;
GO

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'ORACLE_PDB')
	EXEC sp_dropserver N'ORACLE_PDB', 'droplogins';
GO

EXEC sp_addlinkedserver
	@server = N'ORACLE_PDB',
	@srvproduct = N'Oracle',
	@provider = N'OraOLEDB.Oracle',
	@datasrc = N'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.64.133)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=PDB)))';
GO

EXEC sp_addlinkedsrvlogin
	@rmtsrvname = N'ORACLE_PDB',
	@useself = N'False',
	@locallogin = NULL,
	@rmtuser = N'system',
	@rmtpassword = N'12345';
GO

EXEC sp_serveroption N'ORACLE_PDB', N'rpc', N'true';
EXEC sp_serveroption N'ORACLE_PDB', N'rpc out', N'true';
GO

SELECT *
FROM OPENQUERY(ORACLE_PDB, 'SELECT to_char(sysdate, ''YYYY-MM-DD HH24:MI'') AS OracleTime FROM dual');
GO

-- Zadanie 4
SELECT *
FROM OPENQUERY(ORACLE_PDB, 'SELECT * FROM scott.emp');
GO

-- Zadanie wlasne - serwer polaczony Access
USE master;
GO

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'ACCESS_NORTHWIND')
	EXEC sp_dropserver N'ACCESS_NORTHWIND', 'droplogins';
GO

EXEC sp_addlinkedserver
	@server = N'ACCESS_NORTHWIND',
	@srvproduct = N'Access',
	@provider = N'Microsoft.ACE.OLEDB.12.0',
	@datasrc = N'C:\Northwind\Northwind.mdb';
GO

SELECT *
FROM OPENQUERY(ACCESS_NORTHWIND, 'SELECT IDproduktu, NazwaProduktu FROM Produkty');
GO

-- Zadanie wlasne - najpierw kazde zrodlo osobno
SELECT c.*
FROM OPENQUERY(ORACLE_PDB, 'SELECT CustomerID, CompanyName FROM northwind.customers') AS c;
GO

SELECT o.*
FROM OPENROWSET(
	'MSOLEDBSQL',
	'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
	'SELECT o.OrderID, o.CustomerID, od.ProductID
	 FROM dbo.Orders AS o
	 INNER JOIN dbo.[Order Details] AS od ON o.OrderID = od.OrderID'
) AS o;
GO

SELECT
	p.IDproduktu AS ProductID,
	p.NazwaProduktu AS ProductName,
	p.IDdostawcy AS SupplierID
FROM OPENQUERY(ACCESS_NORTHWIND, 'SELECT IDproduktu, NazwaProduktu, IDdostawcy FROM Produkty') AS p;
GO

SELECT SupplierID, CompanyName
FROM Northwind.dbo.Suppliers;
GO

-- Zadanie wlasne - finalne zapytanie
;WITH klienci AS (
	SELECT c.*
	FROM OPENQUERY(ORACLE_PDB, 'SELECT CustomerID, CompanyName FROM northwind.customers') AS c
),
zamowienia AS (
	SELECT o.*
	FROM OPENROWSET(
		'MSOLEDBSQL',
		'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
		'SELECT o.OrderID, o.CustomerID, od.ProductID
		 FROM dbo.Orders AS o
		 INNER JOIN dbo.[Order Details] AS od ON o.OrderID = od.OrderID'
	) AS o
),
produkty AS (
	SELECT
		p.IDproduktu AS ProductID,
		p.NazwaProduktu AS ProductName,
		p.IDdostawcy AS SupplierID
	FROM OPENQUERY(ACCESS_NORTHWIND, 'SELECT IDproduktu, NazwaProduktu, IDdostawcy FROM Produkty') AS p
)
SELECT
	k.CompanyName AS Klient,
	z.OrderID AS NrZamowienia,
	p.ProductName AS Produkt,
	s.CompanyName AS Dostawca
FROM zamowienia AS z
INNER JOIN klienci AS k
	ON z.CustomerID = k.CustomerID
INNER JOIN produkty AS p
	ON z.ProductID = p.ProductID
INNER JOIN Northwind.dbo.Suppliers AS s
	ON p.SupplierID = s.SupplierID;
GO

-- Zapytanie Oracle - sprzedaz produktow w miesiacach 1997 i 1998
SELECT *
FROM OPENQUERY(ORACLE_PDB, '
	SELECT
		p.ProductName,
		TRUNC(o.OrderDate, ''MM'') AS OrderMonth,
		SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS SalesValue
	FROM northwind.products p
	INNER JOIN northwind.orderdetails od ON p.ProductID = od.ProductID
	INNER JOIN northwind.orders o ON od.OrderID = o.OrderID
	WHERE EXTRACT(YEAR FROM o.OrderDate) IN (1997, 1998)
	GROUP BY p.ProductName, TRUNC(o.OrderDate, ''MM'')
	ORDER BY TRUNC(o.OrderDate, ''MM''), p.ProductName
');
GO

USE Northwind;
GO

IF OBJECT_ID('dbo.tab1', 'U') IS NOT NULL
	DROP TABLE dbo.tab1;
GO

SELECT
	q.ProductName,
	CAST(q.OrderMonth AS DATETIME) AS OrderMonth,
	q.SalesValue
INTO dbo.tab1
FROM OPENQUERY(ORACLE_PDB, '
	SELECT
		p.ProductName,
		TRUNC(o.OrderDate, ''MM'') AS OrderMonth,
		SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS SalesValue
	FROM northwind.products p
	INNER JOIN northwind.orderdetails od ON p.ProductID = od.ProductID
	INNER JOIN northwind.orders o ON od.OrderID = o.OrderID
	WHERE EXTRACT(YEAR FROM o.OrderDate) IN (1997, 1998)
	GROUP BY p.ProductName, TRUNC(o.OrderDate, ''MM'')
') AS q;
GO

SELECT *
FROM dbo.tab1
ORDER BY OrderMonth, ProductName;
GO


-- w dalszym ciągu ćwiczymy OPENROWSET:
-- Zadanie 1:

-- jaki klient (ORACLE) zrealizował jakie zamówienia (SQLSERVER lokalny) na którym są jakie produkty ACCESS)
-- obsłużone przez jakiego pracownika (SQL Server: WA-03) 

-- Zadanie 2:
--  Zapoznać się z ustanawianiem serwera połączonego oraz wykonać następujące kroki:

--1. sterownik OLDB --> konfiguracja
--2. dodanie serwera połączonego
--3. mapowanie praw i nadawanie uprawnień
--4. ustawienie dostępu na infrastrukturze



-- Zadanie 3:
-- Ustanowić serwer połączony ORACLE z wykorzystaniem opcji konfiguracyjnych
-- wprowadzonych w aplikacji Oracle Net Manager (korzystamy z ustawień, które
-- wprowadzone zostały na poprzednich zajęciach)

-- Zadanie 4.
------------------------------
-- Napisać zapytanie rozproszone :
-- pobrać wszystkich pracowników z tabeli EMP schematu SCOTT:
------------

--- Zadanie:(własna realizacja)
----------------------------
-- Ustanowić serwer połączony Access (plik Access powinien znajdować się na dysku c:)
-- następnie napisać zapytanie jakie mamy produkty na serwerze Access:

-- Zadanie: (własna realizacja)
----------------------------
-- Napisać zapytanie 
-- jaki klient (serwer: ORACLE) zrealizował jakie zamówienia (serwer: WA-09) na 
-- których są jaki produkty (serwer: Access)
-- dostarczone przez jakiego dostawcę (serwer lokalny)



-- Zapytanie:
-- Podać z serwera ORACLE: jakie produkty miały wartość sumarycznej sprzedaży ( suma 
-- sprzedaży  z poszczególnych zamówień w względem nazwy produktu) w 
-- poszczególnych miesiącach roku 1998 i 1997.

---Następnie -------------------------------------
-- dla tak przygotowanego zapytania - tworzymy na jego podstawie tabelę: tab1, 
-- która zostanie wypełniona danymi 
--- UWAGA w tabeli tej ustawić typ DATETIME dla dat poszczególnych miesięcy tego zapytania



-- ROZWIAZANIE POD MOJ SERWER

USE Northwind;
GO

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
GO

EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
GO

EXEC master.dbo.sp_MSset_oledb_prop N'OraOLEDB.Oracle', N'AllowInProcess', 1;
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1;
EXEC master.dbo.sp_MSset_oledb_prop N'MSOLEDBSQL', N'AllowInProcess', 1;
GO


-- Zadanie 1:
-- Jaki klient (ORACLE) zrealizował jakie zamówienia (SQLSERVER lokalny) na którym są jakie produkty ACCESS)
-- obsłużone przez jakiego pracownika (SQL Server: WA-03) 

-- Zadanie 1 - najpierw zwykle zapytanie lokalne
SELECT
	c.CompanyName AS Klient,
	c.ContactName AS KontaktKlienta,
	o.OrderID AS NrZamowienia,
	p.ProductName AS Produkt,
	od.UnitPrice AS CenaJednostkowa,
	od.Quantity AS Ilosc,
	e.LastName + ' ' + e.FirstName AS Pracownik
FROM Northwind.dbo.Customers AS c
INNER JOIN Northwind.dbo.Orders AS o
	ON c.CustomerID = o.CustomerID
INNER JOIN Northwind.dbo.[Order Details] AS od
	ON o.OrderID = od.OrderID
INNER JOIN Northwind.dbo.Products AS p
	ON od.ProductID = p.ProductID
INNER JOIN Northwind.dbo.Employees AS e
	ON o.EmployeeID = e.EmployeeID;
GO

-- Zadanie 1 - klienci z Oracle osobno
SELECT c.*
FROM OPENROWSET(
	'OraOLEDB.Oracle',
	'(DESCRIPTION =
		(ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.64.133)(PORT = 1521))
		(CONNECT_DATA =
			(SERVICE_NAME = PDB)
		)
	)';'NORTHWIND';'12345',
	'SELECT CustomerID, CompanyName, ContactName FROM Customers'
) AS c;
GO

-- Zadanie 1 - zamowienia z SQL Server lokalnego osobno
SELECT o.*
FROM OPENROWSET(
	'MSOLEDBSQL',
	'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
	'SELECT o.OrderID, o.CustomerID, o.EmployeeID, od.ProductID, od.UnitPrice, od.Quantity
	 FROM dbo.Orders AS o
	 INNER JOIN dbo.[Order Details] AS od ON o.OrderID = od.OrderID'
) AS o;
GO

-- Zadanie 1 - produkty z Access osobno
SELECT
	p.IDproduktu AS ProductID,
	p.NazwaProduktu AS ProductName
FROM OPENROWSET(
	'Microsoft.ACE.OLEDB.12.0',
	'C:\Northwind\Northwind.mdb';'admin';'',
	'SELECT IDproduktu, NazwaProduktu FROM Produkty'
) AS p;
GO

-- Zadanie 1 - pracownicy z SQL Server osobno
SELECT e.*
FROM OPENROWSET(
	'MSOLEDBSQL',
	'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
	'SELECT EmployeeID, LastName, FirstName FROM dbo.Employees'
) AS e;
GO

-- Zadanie 1 - finalne zapytanie rozproszone
;WITH klienci AS (
	SELECT c.*
	FROM OPENROWSET(
		'OraOLEDB.Oracle',
		'(DESCRIPTION =
			(ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.64.133)(PORT = 1521))
			(CONNECT_DATA =
				(SERVICE_NAME = PDB)
			)
		)';'NORTHWIND';'12345',
		'SELECT CustomerID, CompanyName, ContactName FROM Customers'
	) AS c
),
zamowienia AS (
	SELECT o.*
	FROM OPENROWSET(
		'MSOLEDBSQL',
		'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
		'SELECT o.OrderID, o.CustomerID, o.EmployeeID, od.ProductID, od.UnitPrice, od.Quantity
		 FROM dbo.Orders AS o
		 INNER JOIN dbo.[Order Details] AS od ON o.OrderID = od.OrderID'
	) AS o
),
produkty AS (
	SELECT
		p.IDproduktu AS ProductID,
		p.NazwaProduktu AS ProductName
	FROM OPENROWSET(
		'Microsoft.ACE.OLEDB.12.0',
		'C:\Northwind\Northwind.mdb';'admin';'',
		'SELECT IDproduktu, NazwaProduktu FROM Produkty'
	) AS p
),
pracownicy AS (
	SELECT e.*
	FROM OPENROWSET(
		'MSOLEDBSQL',
		'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
		'SELECT EmployeeID, LastName, FirstName FROM dbo.Employees'
	) AS e
)
SELECT
	k.CompanyName AS Klient,
	k.ContactName AS KontaktKlienta,
	z.OrderID AS NrZamowienia,
	p.ProductName AS Produkt,
	z.UnitPrice AS CenaJednostkowa,
	z.Quantity AS Ilosc,
	pr.LastName + ' ' + pr.FirstName AS Pracownik
FROM zamowienia AS z
INNER JOIN klienci AS k
	ON z.CustomerID = k.CustomerID
INNER JOIN produkty AS p
	ON z.ProductID = p.ProductID
INNER JOIN pracownicy AS pr
	ON z.EmployeeID = pr.EmployeeID;
GO



-- Zadanie 2:
--  Zapoznać się z ustanawianiem serwera połączonego oraz wykonać następujące kroki:

--1. sterownik OLDB --> konfiguracja
--2. dodanie serwera połączonego
--3. mapowanie praw i nadawanie uprawnień
--4. ustawienie dostępu na infrastrukturze

-- Zadanie 3:
-- Ustanowić serwer połączony ORACLE z wykorzystaniem opcji konfiguracyjnych
-- wprowadzonych w aplikacji Oracle Net Manager (korzystamy z ustawień, które
-- wprowadzone zostały na poprzednich zajęciach)


-- Zadanie 2 i 3 - serwer polaczony Oracle pod nasza VM
USE master;
GO

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'ORACLE_PDB')
	EXEC sp_dropserver N'ORACLE_PDB', 'droplogins';
GO

EXEC sp_addlinkedserver
	@server = N'ORACLE_PDB',
	@srvproduct = N'Oracle',
	@provider = N'OraOLEDB.Oracle',
	@datasrc = N'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.64.133)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=PDB)))';
GO

EXEC sp_addlinkedsrvlogin
	@rmtsrvname = N'ORACLE_PDB',
	@useself = N'False',
	@locallogin = NULL,
	@rmtuser = N'system',
	@rmtpassword = N'12345';
GO

EXEC sp_serveroption N'ORACLE_PDB', N'rpc', N'true';
EXEC sp_serveroption N'ORACLE_PDB', N'rpc out', N'true';
GO

SELECT *
FROM OPENQUERY(ORACLE_PDB, 'SELECT to_char(sysdate, ''YYYY-MM-DD HH24:MI'') AS OracleTime FROM dual');
GO

-- Zadanie 4
SELECT *
FROM OPENQUERY(ORACLE_PDB, 'SELECT * FROM scott.emp');
GO

-- Zadanie wlasne - serwer polaczony Access
USE master;
GO

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'ACCESS_NORTHWIND')
	EXEC sp_dropserver N'ACCESS_NORTHWIND', 'droplogins';
GO

EXEC sp_addlinkedserver
	@server = N'ACCESS_NORTHWIND',
	@srvproduct = N'Access',
	@provider = N'Microsoft.ACE.OLEDB.12.0',
	@datasrc = N'C:\Northwind\Northwind.mdb';
GO

SELECT *
FROM OPENQUERY(ACCESS_NORTHWIND, 'SELECT IDproduktu, NazwaProduktu FROM Produkty');
GO

-- Zadanie wlasne - najpierw kazde zrodlo osobno
SELECT c.*
FROM OPENQUERY(ORACLE_PDB, 'SELECT CustomerID, CompanyName FROM northwind.customers') AS c;
GO

SELECT o.*
FROM OPENROWSET(
	'MSOLEDBSQL',
	'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
	'SELECT o.OrderID, o.CustomerID, od.ProductID
	 FROM dbo.Orders AS o
	 INNER JOIN dbo.[Order Details] AS od ON o.OrderID = od.OrderID'
) AS o;
GO

SELECT
	p.IDproduktu AS ProductID,
	p.NazwaProduktu AS ProductName,
	p.IDdostawcy AS SupplierID
FROM OPENQUERY(ACCESS_NORTHWIND, 'SELECT IDproduktu, NazwaProduktu, IDdostawcy FROM Produkty') AS p;
GO

SELECT SupplierID, CompanyName
FROM Northwind.dbo.Suppliers;
GO

-- Zadanie wlasne - finalne zapytanie
;WITH klienci AS (
	SELECT c.*
	FROM OPENQUERY(ORACLE_PDB, 'SELECT CustomerID, CompanyName FROM northwind.customers') AS c
),
zamowienia AS (
	SELECT o.*
	FROM OPENROWSET(
		'MSOLEDBSQL',
		'Server=Mateusz;Database=Northwind;Trusted_Connection=yes;',
		'SELECT o.OrderID, o.CustomerID, od.ProductID
		 FROM dbo.Orders AS o
		 INNER JOIN dbo.[Order Details] AS od ON o.OrderID = od.OrderID'
	) AS o
),
produkty AS (
	SELECT
		p.IDproduktu AS ProductID,
		p.NazwaProduktu AS ProductName,
		p.IDdostawcy AS SupplierID
	FROM OPENQUERY(ACCESS_NORTHWIND, 'SELECT IDproduktu, NazwaProduktu, IDdostawcy FROM Produkty') AS p
)
SELECT
	k.CompanyName AS Klient,
	z.OrderID AS NrZamowienia,
	p.ProductName AS Produkt,
	s.CompanyName AS Dostawca
FROM zamowienia AS z
INNER JOIN klienci AS k
	ON z.CustomerID = k.CustomerID
INNER JOIN produkty AS p
	ON z.ProductID = p.ProductID
INNER JOIN Northwind.dbo.Suppliers AS s
	ON p.SupplierID = s.SupplierID;
GO

-- Zapytanie Oracle - sprzedaz produktow w miesiacach 1997 i 1998
SELECT *
FROM OPENQUERY(ORACLE_PDB, '
	SELECT
		p.ProductName,
		TRUNC(o.OrderDate, ''MM'') AS OrderMonth,
		SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS SalesValue
	FROM northwind.products p
	INNER JOIN northwind.orderdetails od ON p.ProductID = od.ProductID
	INNER JOIN northwind.orders o ON od.OrderID = o.OrderID
	WHERE EXTRACT(YEAR FROM o.OrderDate) IN (1997, 1998)
	GROUP BY p.ProductName, TRUNC(o.OrderDate, ''MM'')
	ORDER BY TRUNC(o.OrderDate, ''MM''), p.ProductName
');
GO

USE Northwind;
GO

IF OBJECT_ID('dbo.tab1', 'U') IS NOT NULL
	DROP TABLE dbo.tab1;
GO

SELECT
	q.ProductName,
	CAST(q.OrderMonth AS DATETIME) AS OrderMonth,
	q.SalesValue
INTO dbo.tab1
FROM OPENQUERY(ORACLE_PDB, '
	SELECT
		p.ProductName,
		TRUNC(o.OrderDate, ''MM'') AS OrderMonth,
		SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS SalesValue
	FROM northwind.products p
	INNER JOIN northwind.orderdetails od ON p.ProductID = od.ProductID
	INNER JOIN northwind.orders o ON od.OrderID = o.OrderID
	WHERE EXTRACT(YEAR FROM o.OrderDate) IN (1997, 1998)
	GROUP BY p.ProductName, TRUNC(o.OrderDate, ''MM'')
') AS q;
GO

SELECT *
FROM dbo.tab1
ORDER BY OrderMonth, ProductName;
GO



--------------------------- Zadania:---------
-- Pracujemy w grupach 2 osobowych na dwóch instancjach znajdujących się na osobnych komputerach lub
--  w przypadku pracy samodzielnej symulujemy pracę środowiska rozproszonego na jednej instancji 
-- serwera SQLServer z wykorzystaniem dwóch baz danych
---------------------------------------

-- 1. Zdefiniować nową bazę danych RBD_g10 (przy pracy samodzielnej dodatkową bazę RBD_g10d)
-- 2. W założonej nowej bazie --> utworzyć na podstawie bazy NorthWind 3 tabele:  Customers, Orders, [order details], Products
-- 3. Utworzyć loginy (oraz użytkowników w nowej bazie):
	-- login (oraz użytkownik)  lokalny: RBDg10L  z hasłem 123456RBD 
	-- login (oraz użytkownik) do pracy zdalnej: zRBDg10R z hasłem 123456RBD 
-- 4. Zdefiniować serwer połączony: z-0X. Następnie dla tak utworzonego serwera zdalnego wykorzystując loginy 
-- z pkt. 3 delegować uprawnienia loginu/użytkownika  lokalnego RBDg10L  na uprawnienia loginu/użytkownika RBDg10R 
-- 5. Nadać niezbędne prawa obiektowe do czytania oraz zapisu danych na serwerze lokalnym i serwerze zdalnym 
-- określonym użytkownikom zdefiniowanym po stronie bazy danych.
-- 6. Zdefiniowany widok który zwróci informację: Jakie produkty (serwer zdalny) znalazły się na danych zamówieniach (serwer zdalny) 
-- zrealizowanych przez danych użytkowników (serwer lokalny)?. Następnie napisać zapytanie do tak powołanego widoku, które pobierze dane
-- 7. Opracować procedurę przechowywaną, która dla parametru wejściowego zwróci informację jaka jest sumaryczna 
-- wartość sprzedaży (serwer zdalny) w danym roku podawanym jako parametr wejściowy.
-- 8. Nadać odpowiednie uprawnienia do procedury, które pozwolą na zdalne jej wywoływanie.
-- 9. Przetestować możliwość wstawiania krotek na serwer zdalny do tabeli Products (ale bez użycia koordynatora MS DTC).
-- 10. Wstawione w punkcie 9 krotki usunąć z serwera zdalnego przez wykorzystanie bezwzględnego czteroczłonowego identyfikatora obiektu
-- wykorzystanego na serwerze lokalnym
-- 11. Punkt 9 i 10 zrealizować również przez wykorzystanie funkcji OPENQUERY z którą to funkcją należy zapoznać się w dokumentacji Microsoft.
-- 12. Pracując w grupach dwuosobowych należy następnie zdefiniować w systemie ORACLE tabelę EMPLOYEES (kopiując ją instrukcją ze schematu NORTHWIND)
-- oraz nadać określone uprawnienia obiektowe do tej tabeli do loginu ORACLE współpracującej osobie w grupie. 
-- 13. Dla zdefiniowanego użytkownika lokalnego (SQL Server) zdefiniować serwer ORACLE oraz dokonać delegacji uprawnień tego loginu do własnego 
-- loginu serwera ORACLE. Następnie przetestować możliwość wstawiania danych do tabeli znajdującej się w schemacie użytkownika współpracującej 
-- osoby w grupie. W razie potrzeby zredefiniować określone uprawnienia obiektowe.


-- ROZWIAZANIE POD MOJ SERWER

USE master;
GO

IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = N'RBD_g10')
	CREATE DATABASE RBD_g10;
GO

IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = N'RBD_g10d')
	CREATE DATABASE RBD_g10d;
GO

USE RBD_g10;
GO

IF OBJECT_ID('dbo.Customers', 'U') IS NULL
	SELECT * INTO dbo.Customers FROM Northwind.dbo.Customers;
GO

IF OBJECT_ID('dbo.Orders', 'U') IS NULL
	SELECT * INTO dbo.Orders FROM Northwind.dbo.Orders;
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = N'Order Details' AND schema_id = SCHEMA_ID(N'dbo'))
	SELECT * INTO dbo.[Order Details] FROM Northwind.dbo.[Order Details];
GO

IF OBJECT_ID('dbo.Products', 'U') IS NULL
	SELECT * INTO dbo.Products FROM Northwind.dbo.Products;
GO

USE RBD_g10d;
GO

IF OBJECT_ID('dbo.Customers', 'U') IS NULL
	SELECT * INTO dbo.Customers FROM Northwind.dbo.Customers;
GO

IF OBJECT_ID('dbo.Orders', 'U') IS NULL
	SELECT * INTO dbo.Orders FROM Northwind.dbo.Orders;
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = N'Order Details' AND schema_id = SCHEMA_ID(N'dbo'))
	SELECT * INTO dbo.[Order Details] FROM Northwind.dbo.[Order Details];
GO

IF OBJECT_ID('dbo.Products', 'U') IS NULL
	SELECT * INTO dbo.Products FROM Northwind.dbo.Products;
GO

USE master;
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'RBDg10L')
	CREATE LOGIN RBDg10L WITH PASSWORD = '123456RBD', CHECK_POLICY = OFF;
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'zRBDg10R')
	CREATE LOGIN zRBDg10R WITH PASSWORD = '123456RBD', CHECK_POLICY = OFF;
GO

USE RBD_g10;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'RBDg10L')
	CREATE USER RBDg10L FOR LOGIN RBDg10L;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'zRBDg10R')
	CREATE USER zRBDg10R FOR LOGIN zRBDg10R;
GO

USE RBD_g10d;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'RBDg10L')
	CREATE USER RBDg10L FOR LOGIN RBDg10L;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'zRBDg10R')
	CREATE USER zRBDg10R FOR LOGIN zRBDg10R;
GO

USE master;
GO

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'z-01')
	EXEC sp_dropserver N'z-01', 'droplogins';
GO

EXEC sp_addlinkedserver
	@server = N'z-01',
	@srvproduct = N'',
	@provider = N'MSOLEDBSQL',
	@datasrc = N'Mateusz';
GO

EXEC sp_addlinkedsrvlogin
	@rmtsrvname = N'z-01',
	@useself = N'False',
	@locallogin = N'RBDg10L',
	@rmtuser = N'zRBDg10R',
	@rmtpassword = N'123456RBD';
GO

EXEC sp_addlinkedsrvlogin
	@rmtsrvname = N'z-01',
	@useself = N'False',
	@locallogin = NULL,
	@rmtuser = N'zRBDg10R',
	@rmtpassword = N'123456RBD';
GO

EXEC sp_serveroption N'z-01', N'rpc', N'true';
EXEC sp_serveroption N'z-01', N'rpc out', N'true';
EXEC sp_serveroption N'z-01', N'remote proc transaction promotion', N'false';
GO

USE RBD_g10;
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Customers TO RBDg10L;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Orders TO RBDg10L;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.[Order Details] TO RBDg10L;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Products TO RBDg10L;
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Customers TO zRBDg10R;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Orders TO zRBDg10R;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.[Order Details] TO zRBDg10R;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Products TO zRBDg10R;
GO

USE RBD_g10d;
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Customers TO RBDg10L;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Orders TO RBDg10L;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.[Order Details] TO RBDg10L;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Products TO RBDg10L;
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Customers TO zRBDg10R;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Orders TO zRBDg10R;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.[Order Details] TO zRBDg10R;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Products TO zRBDg10R;
GO

SELECT TOP 5 *
FROM [z-01].RBD_g10d.dbo.Customers;
GO

USE RBD_g10;
GO

IF OBJECT_ID('dbo.vw_lab05_produkty_zamowienia_klienci', 'V') IS NOT NULL
	DROP VIEW dbo.vw_lab05_produkty_zamowienia_klienci;
GO

CREATE VIEW dbo.vw_lab05_produkty_zamowienia_klienci
AS
SELECT
	c.CustomerID,
	c.CompanyName AS Klient,
	o.OrderID AS NrZamowienia,
	o.OrderDate AS DataZamowienia,
	p.ProductID,
	p.ProductName AS Produkt,
	od.UnitPrice AS CenaJednostkowa,
	od.Quantity AS Ilosc,
	od.Discount AS Rabat,
	od.UnitPrice * od.Quantity * (1 - od.Discount) AS Wartosc
FROM dbo.Customers AS c
INNER JOIN [z-01].RBD_g10d.dbo.Orders AS o
	ON c.CustomerID = o.CustomerID
INNER JOIN [z-01].RBD_g10d.dbo.[Order Details] AS od
	ON o.OrderID = od.OrderID
INNER JOIN [z-01].RBD_g10d.dbo.Products AS p
	ON od.ProductID = p.ProductID;
GO

SELECT *
FROM dbo.vw_lab05_produkty_zamowienia_klienci
ORDER BY Klient, NrZamowienia;
GO

IF OBJECT_ID('dbo.usp_lab05_wartosc_sprzedazy_rok', 'P') IS NOT NULL
	DROP PROCEDURE dbo.usp_lab05_wartosc_sprzedazy_rok;
GO

CREATE PROCEDURE dbo.usp_lab05_wartosc_sprzedazy_rok
	@Rok INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		YEAR(o.OrderDate) AS Rok,
		SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS WartoscSprzedazy
	FROM [z-01].RBD_g10d.dbo.Orders AS o
	INNER JOIN [z-01].RBD_g10d.dbo.[Order Details] AS od
		ON o.OrderID = od.OrderID
	WHERE YEAR(o.OrderDate) = @Rok
	GROUP BY YEAR(o.OrderDate);
END;
GO

GRANT EXECUTE ON dbo.usp_lab05_wartosc_sprzedazy_rok TO RBDg10L;
GRANT EXECUTE ON dbo.usp_lab05_wartosc_sprzedazy_rok TO zRBDg10R;
GO

EXEC dbo.usp_lab05_wartosc_sprzedazy_rok @Rok = 1997;
GO

SET XACT_ABORT OFF;
GO

INSERT INTO[z-01].RBD_g10d.dbo.Products
	(ProductID, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
VALUES
	(999, 'LAB05_TEST_1', 1, 1, '10 boxes', 10.00, 10, 0, 0, 0);
GO

SELECT ProductID, ProductName, UnitPrice
FROM [z-01].RBD_g10d.dbo.Products
WHERE ProductName = 'LAB05_TEST_1';
GO

DELETE FROM [z-01].RBD_g10d.dbo.Products
WHERE ProductName = 'LAB05_TEST_1';
GO

INSERT INTO OPENQUERY([z-01], '
	SELECT ProductID, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued
	FROM RBD_g10d.dbo.Products
')
VALUES
	(999, 'LAB05_OPENQUERY_1', 1, 1, '10 boxes', 11.00, 11, 0, 0, 0);
GO


SELECT *
FROM OPENQUERY([z-01], '
	SELECT ProductID, ProductName, UnitPrice
	FROM RBD_g10d.dbo.Products
	WHERE ProductName = ''LAB05_OPENQUERY_1''
');
GO

DELETE FROM OPENQUERY([z-01], '
	SELECT ProductID, ProductName
	FROM RBD_g10d.dbo.Products
	WHERE ProductName = ''LAB05_OPENQUERY_1''
');
GO

/*
-- Ten fragment uruchom w Oracle jako osobny uzytkownik partnera.
-- U nas w schemacie NORTHWIND tabela EMPLOYEES juz istnieje po imporcie Northwind_Oracle.sql.

CREATE TABLE EMPLOYEES AS
SELECT * FROM NORTHWIND.EMPLOYEES;

GRANT SELECT, INSERT, UPDATE, DELETE ON EMPLOYEES TO NORTHWIND;

SELECT * FROM EMPLOYEES;
*/
GO

USE master;
GO

EXEC master.dbo.sp_MSset_oledb_prop N'OraOLEDB.Oracle', N'AllowInProcess', 1;
GO

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'ORACLE_PDB')
	EXEC sp_dropserver N'ORACLE_PDB', 'droplogins';
GO

EXEC sp_addlinkedserver
	@server = N'ORACLE_PDB',
	@srvproduct = N'Oracle',
	@provider = N'OraOLEDB.Oracle',
	@datasrc = N'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.64.133)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=PDB)))';
GO

EXEC sp_addlinkedsrvlogin
	@rmtsrvname = N'ORACLE_PDB',
	@useself = N'False',
	@locallogin = N'RBDg10L',
	@rmtuser = N'NORTHWIND',
	@rmtpassword = N'12345';
GO

EXEC sp_addlinkedsrvlogin
	@rmtsrvname = N'ORACLE_PDB',
	@useself = N'False',
	@locallogin = NULL,
	@rmtuser = N'NORTHWIND',
	@rmtpassword = N'12345';
GO

SELECT *
FROM OPENQUERY(ORACLE_PDB, 'SELECT EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE FROM EMPLOYEES');
GO

INSERT INTO OPENQUERY(ORACLE_PDB, '
	SELECT EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE
	FROM EMPLOYEES
')
VALUES
	(999, 'Lab05', 'Test', 'Test insert');
GO

SELECT *
FROM OPENQUERY(ORACLE_PDB, 'SELECT EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE FROM EMPLOYEES WHERE EMPLOYEEID = 999');
GO

DELETE FROM OPENQUERY(ORACLE_PDB, '
	SELECT EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE
	FROM EMPLOYEES
	WHERE EMPLOYEEID = 999
');
GO


-----------------------------------------------

-------------
Transakcja rozproszona:
---------------------

Zadanie 1.
---------------------
Zapoznaj się z dokumentacją środowiska SQLServer w temacie dotyczącym korzystania z koordynatora transakcji rozproszonych oraz przeprowadź jego instalację jeżeli nie jest on zainstalowany.

Cel:
-- Celem przeprowadzenia transakcji rozproszonej między systemem SQL Server a systemem ORACLE należy wykorzystać 
-- Koordynatora transakcji rozproszonych Microsoft (MS DTC)
-- W przypadku braku tego koordynatora należy go doinstalować. Szczegóły opisane są w dokumentacji technicznej Microsoft.
-- MS DTC - powinien być zainstalowany razem z instalacją produktu SQL Server tzn. na każdym komputerze uczestniczącym w koordynowaniu transakcji rozproszonych. 

--- Transakcja rozproszona:
-----------------------------------------------
-- Transakcja rozproszona obejmuje dwie lub więcej baz danych. 
-- Transakcję między SQL Server i innymi źródłami danych koordynuje menedżer transakcji: DTC. 
-- Każde wystąpienie silnika bazy danych (SQL Server) może działać jako menedżer zasobów. Po skonfigurowaniu 
-- Transakcja z dwiema lub więcej bazami danych w jednym wystąpieniu transakcją rozproszoną. 
-- To instancja i DTC zarządza wewnętrznie transakcją rozproszoną. Użytkownik widzi ją jak transakcja lokalną. 
-- SQL Server od 2017 (14.x) promuje wszystkie transakcje między bazami danych do DTC, tzn. gdy bazy danych są w grupie dostępności skonfigurowanej 
-- z DTC_SUPPORT = PER_DB- nawet w ramach pojedynczej instancji SQL Server.

-- Od strony aplikacji SQL Management Studio - transakcja rozproszona jest zarządzana podobnie jak transakcja lokalna. 
-- Pod koniec transakcji aplikacja żąda zatwierdzenia lub 
-- wycofania transakcji. Menedżer transakcji musi zarządzać rozproszonym zatwierdzeniem w taki sposób, aby zminimalizować ryzyko, że awaria sieci 
-- może spowodować, że niektóre usługi menedżerów zasobów z powodzeniem dokonają zatwierdzenia, a inni wycofają transakcję. 
-- Osiąga się to poprzez zarządzanie procesem zatwierdzania w dwóch fazach (faza przygotowania i faza zatwierdzenia), która jest znana 
-- jako zatwierdzanie dwufazowe (two-phase commit).:


-- Jak przebiega two-phase commit:
-------------------------------------------

-- Faza przygotowawcza:
-------------------------------
-- Gdy menedżer transakcji otrzyma żądanie zatwierdzenia, wysyła polecenie przygotowania do wszystkich menedżerów zasobów zaangażowanych w transakcję. -- Następnie każdy menedżer zasobów robi wszystko, aby transakcja była trwała, a wszystkie bufory zawierające obrazy dziennika dla transakcji są -- składowane na dysk. Gdy każdy menedżer zasobów zakończy fazę przygotowania, zwraca informację: (sukces lub porażkę) przygotowania do 
-- menedżera transakcji (MS DTC).


-- Faza zatwierdzania:
---------------------------
-- Jeśli menedżer transakcji otrzyma pomyślne przygotowania od wszystkich menedżerów zasobów, wysyła polecenia zatwierdzenia do każdego 
-- menedżera zasobów. Menedżerowie zasobów mogą następnie dokończyć zatwierdzenie. Jeśli wszyscy menedżerowie zasobów zgłoszą pomyślne zatwierdzenie,
-- menedżer transakcji następnie wysyła powiadomienie o powodzeniu do aplikacji. Jeśli dowolny menedżer zasobów zgłosił błąd w przygotowaniu, 
-- to menedżer transakcji wysyła polecenie wycofania do każdego menedżera zasobów i wskazuje niepowodzenie zatwierdzenia do aplikacji.


-- Krok A:
-- dokonać odpowiedniej konfiguracji MSDTC
 --------------------------
-- Korzystanie z transakcji XA jest domyślnie wyłączone, aby zapobiec potencjalnemu ryzyku bezpieczeństwa, które powstaje, gdy określona -- przez użytkownika biblioteka DLL, której DTC używa do komunikowania się z menedżerem transakcji partnera XA, jest ładowana bezpośrednio 
-- do procesu DTC. Ta sytuacja może narazić bazy danych menedżera zasobów na poważne uszkodzenie danych. 
-- Może również powodować ataki typu „odmowa usługi”. Aby umożliwić koordynację i przepływ transakcji XA, musisz włączyć transakcje XA.


----------
-- Zadanie 2:
---------------
-- Przeprowadź konfigurację MSDTC i włącz obsługę przeprowadzenia transakcji rozproszonych z wykorzystaniem MSDTC.
-- Aby włączyć transakcje XA - najpierw upewnij się, że żadne transakcje nie są w toku.
-- 
-----------------------------
    -- 1. Otwórz przystawkę Usługi składowe:

          --kliknij przycisk Start . 
          -----W polu wyszukiwania wpisz: dcomcnfg , a następnie naciśnij klawisz ENTER.

    -- 2. W drzewie: Katalog główny konsoli -  rozwiń: Usługi składowe -- dalej: komputery -- dalej Mój komputer
            dalej: Koordynator transakcji rozproszonych wybrać DTC (Lokalna usługa DTC), dla którego chcesz włączyć transakcje XA.

    -- Wybrać prawym przyciskiem myszy --> kliknij Właściwości .

    -- 3. Kliknij kartę: Zabezpieczenia

    -- 4. Zaznacz pole: wyboru Włącz transakcje XA oraz opcje wyżej dla transakcji rozproszonych w tym komunikację i ustawienia zabezpieczeń

-- Kliknij OK .


----------
-- Zadanie 3:
---------------
-- Oprócz włączania transakcji XA przeprowadź konfigurację dostępu DTC przez zaporę Firewall, (np. zapora systemu Windows). 
-- 
-----------------------------


-----------
-- Zadanie 4:
----------------
-- po przelogowaniu się do aplikacji SQL Developer - założyć tabelę w systemie Oracle:

create table koledzy(
indeks number(15) not null Primary key,
nazwisko varchar(50) not null,
imie varchar(25) not null);

-----------
-- Zadanie 5:
----------------
-- Nadaj odpowiednie uprawnienia do tej tabeli np. grupie PUBLIC nadaj wszystkie prawa obiektowe (SELECT, INSERT,UPDATE, DELETE). W tym celu wykonaj instrukcję GRANT.



-----------
-- Krok B:
----------------
-- Sprawdzamy, czy tabela istnieje i możemy z innego użytkownika z niej skorzystać z poziomu użytkownika (serwer zdalny). W tym celu napisz odpowiednią instrukcję SELECT



-----------
-- Zadanie 6:
----------------
--  w środowisku SQL Server - założyć tabelę taką samą tabelę:


create table koledzy(
indeks int not null Primary key,
nazwisko varchar(50) not null,
imie varchar(25) not null);


-----------
-- Krok B:
----------------
-- Nadaj odpowiednie uprawnienia do tej tabeli np. grupie PUBLIC nadaj wszystkie prawa obiektowe (SELECT, INSERT,UPDATE, DELETE). W tym celu wykonaj instrukcję GRANT.



-----------
-- Krok C:
----------------
-- Sprawdzamy, czy tabela istnieje i możemy z innego użytkownika z niej skorzystać z poziomu użytkownika (serwer lokalny). W tym celu napisz odpowiednią instrukcję SELECT



-----------
-- Zadanie 7:
----------------
--  Zapoznaj się z dokumentacja środowiska SQLServer oraz opcją sesji: XACT_ABORT. Odpowiedz na pytanie czym ta 
--  opcja jest i do czego jest ona wykorzystywana


--  wykonać transakcję rozproszoną:
USE northwind
GO
---opcja sesji XACT_ABORT - w przyp. niepowodzenia cała transakcja zostanie ---anulowana.
SET XACT_ABORT ON
---
GO

BEGIN DISTRIBUTED TRANSACTION

---instrukcje transakcji rozproszonej --> wstawianie do serwera lokalnego i serwera połączonego


COMMIT TRANSACTION


-----------
-- Krok B:
----------------

---Sprawdź, czy wstawianie na lokalny i zdalny serwer się się powiodło. W tym celu napisz odpowiednie instrukcje SELECT.





-- Zadanie 8:
-- Opracować procedurę składowaną, która wprowadzi rekordy na serwer ORACLE oraz taką samą procedurę, która wprowadzi 
-- rekordy do tabeli Northwind (SQL Server)
-- Następnie napisać transakcję rozproszoną z wykorzystaniem tej procedury

----------------------------




----------------------------


-- ROZWIAZANIE POD MOJ SERWER

/*
-- Ten fragment uruchom w Oracle SQL Developer jako NORTHWIND / 12345.

CREATE TABLE KOLEDZY (
    INDEKS NUMBER(15) NOT NULL PRIMARY KEY,
    NAZWISKO VARCHAR2(50) NOT NULL,
    IMIE VARCHAR2(25) NOT NULL
);

GRANT SELECT, INSERT, UPDATE, DELETE ON KOLEDZY TO PUBLIC;

CREATE OR REPLACE PROCEDURE DODAJ_KOLEGE_ORACLE (
    P_INDEKS IN NUMBER,
    P_NAZWISKO IN VARCHAR2,
    P_IMIE IN VARCHAR2
)
AS
BEGIN
    INSERT INTO KOLEDZY (INDEKS, NAZWISKO, IMIE)
    VALUES (P_INDEKS, P_NAZWISKO, P_IMIE);
END;
/

SELECT * FROM KOLEDZY;
*/
GO

USE master;
GO

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
GO

EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
GO

EXEC master.dbo.sp_MSset_oledb_prop N'OraOLEDB.Oracle', N'AllowInProcess', 1;
GO

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'ORACLE_PDB')
    EXEC sp_dropserver N'ORACLE_PDB', 'droplogins';
GO

EXEC sp_addlinkedserver
    @server = N'ORACLE_PDB',
    @srvproduct = N'Oracle',
    @provider = N'OraOLEDB.Oracle',
    @datasrc = N'(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.64.133)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=PDB)))';
GO

EXEC sp_addlinkedsrvlogin
    @rmtsrvname = N'ORACLE_PDB',
    @useself = N'False',
    @locallogin = NULL,
    @rmtuser = N'NORTHWIND',
    @rmtpassword = N'12345';
GO

EXEC sp_serveroption N'ORACLE_PDB', N'rpc', N'true';
EXEC sp_serveroption N'ORACLE_PDB', N'rpc out', N'true';
GO

SELECT *
FROM OPENQUERY(ORACLE_PDB, 'SELECT INDEKS, NAZWISKO, IMIE FROM KOLEDZY');
GO

USE Northwind;
GO

IF OBJECT_ID('dbo.koledzy', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.koledzy (
        indeks INT NOT NULL PRIMARY KEY,
        nazwisko VARCHAR(50) NOT NULL,
        imie VARCHAR(25) NOT NULL
    );
END;
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.koledzy TO PUBLIC;
GO

SELECT *
FROM dbo.koledzy;
GO

SET XACT_ABORT ON;
GO

BEGIN TRY
    BEGIN DISTRIBUTED TRANSACTION;

    INSERT INTO dbo.koledzy (indeks, nazwisko, imie)
    VALUES (61001, 'Kowalski', 'Jan');

    INSERT INTO OPENROWSET(
        'OraOLEDB.Oracle',
        '(DESCRIPTION =
            (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.64.133)(PORT = 1521))
            (CONNECT_DATA =
                (SERVICE_NAME = PDB)
            )
        )';'NORTHWIND';'12345',
        'SELECT INDEKS, NAZWISKO, IMIE FROM KOLEDZY'
    )
    VALUES (61001, 'Kowalski', 'Jan');

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO

SELECT *
FROM dbo.koledzy
WHERE indeks = 61001;
GO

SELECT *
FROM OPENQUERY(ORACLE_PDB, 'SELECT INDEKS, NAZWISKO, IMIE FROM KOLEDZY WHERE INDEKS = 61001');
GO

IF OBJECT_ID('dbo.dodaj_kolege_sql', 'P') IS NOT NULL
    DROP PROCEDURE dbo.dodaj_kolege_sql;
GO

CREATE PROCEDURE dbo.dodaj_kolege_sql
    @indeks INT,
    @nazwisko VARCHAR(50),
    @imie VARCHAR(25)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.koledzy (indeks, nazwisko, imie)
    VALUES (@indeks, @nazwisko, @imie);
END;
GO

SET XACT_ABORT ON;
GO

BEGIN TRY
    BEGIN DISTRIBUTED TRANSACTION;

    EXEC dbo.dodaj_kolege_sql
        @indeks = 62001,
        @nazwisko = 'Nowak',
        @imie = 'Anna';

    EXEC ('BEGIN DODAJ_KOLEGE_ORACLE(62001, ''Nowak'', ''Anna''); END;') AT ORACLE_PDB;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO

SELECT *
FROM dbo.koledzy
WHERE indeks IN (61001, 62001);
GO

SELECT *
FROM OPENQUERY(ORACLE_PDB, 'SELECT INDEKS, NAZWISKO, IMIE FROM KOLEDZY WHERE INDEKS IN (61001, 62001)');
GO

