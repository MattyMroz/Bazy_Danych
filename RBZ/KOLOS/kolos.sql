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






