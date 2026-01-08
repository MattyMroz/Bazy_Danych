-----------------------------------------------------------------------------------------------------------------------
-- Uprawnienia --------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

-- Podmiot zabezpieczeñ (ang. security principal)
-- Przedmiot zabezpieczeñ (ang. securable)
-- Wszystkie polecenia mo¿na utworzyæ za pomoc¹ narzêdzia SSMS i za pommoc¹ tego narzêdzia sprawdzaæ przypisane upranienia (warto z tego narzêdzia korzystaæ)
-- Uwaga: Login na poziomie instancji SQL Server zawiera has³o. Natomiast, ka¿da baza danych ma swoich u¿ytkowników na poziomie ka¿dej z baz.
	-- Login jest mapowany w ka¿dej bazie danych na konkretne konto bazy danych.
	-- (jeœli takiego konta nie ma to mapowany jest jako u¿ytkownik Guest z odpowiednimi uprawnieniami chyba, ¿e konto to jest wy³¹czone)

-----------------------------------------------------------------------------------------------------------------
-- Kasowanie istniej¹cych loginów, u¿ytkowników i schematów -----------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
USE MASTER
GO
IF EXISTS (SELECT name FROM sys.server_principals WHERE name = 'admin') DROP LOGIN admin;
IF EXISTS (SELECT name FROM sys.server_principals WHERE name = 'test') DROP LOGIN test;
IF EXISTS (SELECT name FROM sys.server_principals WHERE name = 'U11') DROP LOGIN U11;
IF EXISTS (SELECT name FROM sys.server_principals WHERE name = 'U21') DROP LOGIN U21;
IF EXISTS (SELECT name FROM sys.server_principals WHERE name = 'U31') DROP LOGIN U31;
GO
USE [TEST]
GO
DROP USER  IF EXISTS [test]
GO
USE [Northwind]
GO
DROP SCHEMA IF EXISTS [u11];
GO
DROP USER IF EXISTS [u11];
GO
DROP SCHEMA IF EXISTS [u21];
GO
DROP USER  IF EXISTS [u21];
GO
DROP SCHEMA IF EXISTS [u31];
GO
DROP USER  IF EXISTS [u31]
GO

DROP DATABASE IF EXISTS TEST1;
GO
DROP DATABASE IF EXISTS TEST2;
GO
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

-- Tworzymy bazê TEST i dwie tabele Categories i Products
USE MASTER
GO
DROP DATABASE IF EXISTS TEST;
GO
CREATE DATABASE TEST;
GO
USE TEST
GO
SELECT * INTO test.dbo.categories FROM Northwind.dbo.Categories
SELECT * INTO test.dbo.products FROM Northwind.dbo.Products

-- Tworzymy nowe konto na poziomie serwera o nazwie ADMIN (próbujemy siê zalogowaæ)
-- aby to siê uda³o musimy zdefiniowaæ domyœln¹ bazê danych dla danego konta logowania (default MASTER)
-- jeœli damy bazê TEST jako default to niestety system nie pozwoli nam na zalogowanie, gdy¿ nie mamy uprawnieñ do bazy TEST
CREATE LOGIN [ADMIN] WITH PASSWORD='admin', DEFAULT_DATABASE=[master], 
	DEFAULT_LANGUAGE=[polski], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;
GO

-- Logujemy siê jako [ADMIN] i sprawdzamy co widzimy w SSMS 
-- (w Object Explorer mo¿emy wykonaæ dodatkowe po³¹czenie za pomoc¹ CONNECT podaj¹c powy¿sze konto)
-- Nastêpnie kasujemy to konto.
-- Jeœli s¹ k³opoty to w pasku SSMS jest ikonka Activity Monitor, 
-- gdzie mo¿emy zamkn¹æ dane po³¹czenie dla u¿ytkownika [ADMIN] (Kill Process)
DROP LOGIN [ADMIN]
GO

-- Jeszcze raz definiujemy dane konto generuj¹c kod za pomoc¹ SSMS (Security | Logins | pod prawym przyciskiem myszy mamy New Logins ...)
CREATE LOGIN [ADMIN] WITH PASSWORD='admin', DEFAULT_DATABASE=[Test], 
	DEFAULT_LANGUAGE=[polski], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;

-- Logujemy siê jako [ADMIN] i sprawdzamy co widzimy w SSMS 
-- Tutaj niestety nie jesteœmy wstanie zalogowaæ siê do bazy Test.

-- Sprawdzamy czy konto GUEST jest w³¹czone (na poziomie bazy danych TEST)
-- standardowo uprawnienie connect jest wy³¹czone i jeœli w³¹czymy to uprawnienie to mo¿emy wejœæ do danej bazy danych 
-- z racji uprawnieñ u¿ytkownika GUEST oraz uprawnieñ roli PUBLIC (konto u¿ytkownika bazy GUEST jest typu "SQL user without login")
USE TEST
GO
REVOKE CONNECT TO [guest] 
-- polecenie do wy³¹czenia konta Guest w bazie TEST 
-- (ikonka w SSMS pokazuje ikonkê z przekreœlonym czerwonym krzy¿ykiem)
-- Miejsce sprawdzenia (Databases | wybieramy bazê Test | Security | Users)
GO
GRANT CONNECT TO [guest]  -- ADMIN widzi strukturê bazy, ale bez obiektów (sprawdzamy)
GO
GRANT SELECT ON categories TO public -- ADMIN widzi, tak¿e obiekt Categories (sprawdzamy)
GO
REVOKE SELECT ON categories TO public -- wracamy do stanu poprzedniego (sprawdzamy)

-- Uwaga! Zabranie prawa CONNECT TO u¿ytkownikowi Guest powoduje brak dostêpu do bazy dla loginu ADMIN
-- Wykonaæ tak¹ operacjê.

-- Wykonujemy nadanie uprawnieñ (prawo CONNECT) za pomoc¹ SSMS - Databases | wybieramy bazê Test (PKM) | Properties | Permissions
-- Przyznawanie i zabranie uprawnieñ za pomoc¹ SSMS -  Databases | wybieramy bazê Test | Tables (PKM) | Properties | Permissions


---------------------------------------------------
-- Zapisujemy u¿ytkownika ADMIN do roli sysadmin --
-- i sprawdzamy co widzi w bazie TEST, Northwind --
---------------------------------------------------
ALTER SERVER ROLE [sysadmin] ADD MEMBER [admin] -- (sprawdzamy)
-- wypisujemy login ADMIN z roli sysadmin
ALTER SERVER ROLE [sysadmin] DROP MEMBER [admin]

-- sprawdzamy jakie s¹ role serwera i jakie maj¹ uprawnienia
EXEC sp_srvrolepermission		        -- ogl¹danie wszystkich praw
EXEC sp_srvrolepermission 'dbcreator'	-- ogl¹danie szczegó³owych praw

ALTER SERVER ROLE [dbcreator] ADD MEMBER [ADMIN] 
-- sprawdziæ czy mo¿e on za³o¿yæ i usun¹æ swoj¹ bazê danych np. Test1
-- wracamy do poprzedniego stanu wczeœniej kasujac bazê Test1
ALTER SERVER ROLE [dbcreator] DROP MEMBER [admin]


------------------------------------------------------------------------------------------------------------------------------
-- Zamiast, za ka¿dym razem pod³¹czaæ siê do serwera w okienku Object Explorer, mo¿emy wykorzystaæ polecenie execute as ... --
------------------------------------------------------------------------------------------------------------------------------
USE TEST --Pamiêtajmy i¿ uprawnienia dla u¿ytkowników dodajemy w konkretnej bazie danych (nie w bazie master) 
GRANT CONNECT TO [guest]
GO
USE TEST  -- po wykonaniu polecenia EXECUTE AS LOGIN ... a przed wykonaniem polecenia REVERT musimy znajdowaæ siê w tej samej bazie danych
PRINT Suser_Sname(); -- konto na poziomie instancji (sa)
PRINT user_name(); -- konto na poziomie bazy danych (dbo)

EXECUTE AS LOGIN='ADMIN'; -- tym poleceniem podszywamy siê pod konto 'admin' (mo¿na u¿yæ te¿ polecenie EXECUTE AS USER ... dla u¿ytkownika bazy danych a nie instancji)
PRINT Suser_Sname(); -- konto na poziomie instancji (ADMIN)
PRINT user_name();   -- konto na poziomie bazy danych (guest)
REVERT; -- tym poleceniem wracamy do u¿ytkownika sa, który ma prawo IMPERSONATE aby podszyæ siê pod czyjeœ konto bez logowania

EXECUTE AS USER='guest'; -- tym poleceniem podszywamy siê pod konto 'guest' 
PRINT Suser_Sname(); -- konto na poziomie instancji (rola public)
PRINT user_name();   -- konto na poziomie bazy danych (user guest)
REVERT; 
GO

-- Wracamy do standardowych ustawieñ dla goœcia (wy³¹czamy to konto)
USE TEST
REVOKE CONNECT TO [guest]  

---------------------------------------------
-- Prawa szczegó³owe na poziomie instancji --
---------------------------------------------
USE MASTER
GRANT CREATE ANY DATABASE to [ADMIN]
-- i sprawdzamy uprawnienia graficznie Instancja|Properties|Permmisions
-- lub SECURITY|LOGINS|login ADMIN|Properties|Securables
USE MASTER
PRINT Suser_Sname();
EXECUTE AS LOGIN='ADMIN';
PRINT Suser_Sname();
CREATE DATABASE Test2; 
DROP DATABASE IF EXISTS Test2;
REVERT;
-- wracamy do poprzedniego stanu i zabieramy uprawnienia do instancji
REVOKE CREATE ANY DATABASE to [ADMIN];

---------------------------------------
-- Tworzenie w³asnej roli serwerowej --
---------------------------------------
USE [master]
GO
CREATE SERVER ROLE [RolaSerwerowa1];
GO
GRANT CREATE ANY DATABASE TO [RolaSerwerowa1];
GO
ALTER SERVER ROLE [RolaSerwerowa1] ADD MEMBER [admin];
GO
-- i sprawdzamy czy admin potrafi utworzyæ i skasowaæ swoj¹ bazê danych
EXECUTE AS LOGIN='admin';
PRINT Suser_Sname();
CREATE DATABASE Test2; 
DROP DATABASE Test2;
REVERT;

-- Sprawdzamy nazwê u¿ytkowników serwera
SELECT * FROM sys.syslogins;
--lub
SELECT * FROM sys.server_principals
------------------------------------------------
-- Na poziomie serwera i kont logowania LOGIN --
------------------------------------------------
-- Wy³¹czamy konto logowania i jako ADMIN nie mo¿emy siê logowaæ do instancji SQL Server 
-- W ka¿dym kroku sprawdzamy mo¿liwoœæ logowania jako ADMIN za pomoc¹ SSMS w sosbnym po³¹czeniu.
-- Poni¿sze ustawienia znaleŸæ w SSMS.
ALTER LOGIN [ADMIN] DISABLE
GO
-- W³¹czamy konto logowania
ALTER LOGIN [ADMIN] ENABLE
GO

-- Brak uprawnieñ do logowania do serwera
DENY CONNECT SQL TO [ADMIN]
GO
-- W³¹czenie uprawnieñ do logowania do serwera
GRANT CONNECT SQL TO [ADMIN]
GO

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
-- Tworzymy u¿ytownika bazy danych o nazwie test przypisanego do loginu TEST w bazie Test --
--------------------------------------------------------------------------------------------
-- Definiujemy login [TEST] 
-- w bazie Test dodajemy u¿ytkownika bazy, tak¿e o nazwie [test] (login 'sa' ma przypisany w bazach u¿ytkownika 'dbo') 
-- (nazwa nie musi byæ taka sama jak login) na podstawie loginu [TEST].
-- Tym samym dodajemy u¿ytkownika do konkretnej bazy danych (z prawem CONNECT standardowo)
-- i wtedy nie ma ju¿ uprawnieñ zwi¹zanych z u¿ytkownikiem GUEST tylko z rol¹ PUBLIC
USE MASTER
CREATE LOGIN [TEST] WITH PASSWORD='test', DEFAULT_DATABASE=[Test], 
	DEFAULT_LANGUAGE=[polski], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;

USE [TEST]
GO
CREATE USER [test] FOR LOGIN [test]
GO
ALTER USER [test] WITH DEFAULT_SCHEMA=[dbo]
GO

-- Sprawdzamy mo¿liwoœæ zalogowania do serwera i bazy danych Test (OK). 

-- Nastêpnie dodajemy konkretne uprawnienia
USE TEST
GRANT SELECT ON products to GUEST; -- to uprawnienie dzia³a jeœli jest w³¹czony GUEST i nie mamy przypisanego ¿adnego konta
GRANT SELECT ON categories to PUBLIC; -- to uprawnienie dzia³a zawsze

-- Sprawdzamy dostêp do tabeli products i categories
EXECUTE AS LOGIN='TEST'; 
-- lub 
-- EXECUTE AS USER='test'
PRINT Suser_Sname();
SELECT * FROM products; -- nie dzia³a
SELECT * FROM categories; -- dzia³a
REVERT;

-- Wracamy do uprawnieñ poprzednich bez uprawnieñ dla GUEST i PUBLIC 
-- (blokujemy u¿ytkownika GUEST jeœli nie by³ wczeœniej zablokowany) i sprawdzamy j.w.
REVOKE SELECT ON products to GUEST; 
REVOKE SELECT ON categories to PUBLIC;

--------------------------------------------------------------------------
-- W takiej konfiguracji braku uprawnieñ do tabel realizujemy zadania: ---
-- Jeœli brakuje nam uprawnieñ w zadanich to dodajemy je przez login sa --
--------------------------------------------------------------------------

-- 1. Przypisujemy uprawnienia SELECT, INSERT na tabeli Categories dla u¿ytkownika test

-- 2. Sprawdzamy czy dzia³aj¹ dane polecenia polecenie SELECT i INSERT na tabeli Categories dla u¿ytkownika test 
-- Sprawdziæ tak¿e czy dzia³a polcenie DELETE i UPDATE na tej tabeli.

-- 3. Modyfikujemy nazwê wczeœniej dodanej kategorii.

-- 4. Kasujemy dodany rekord (ewentualnie dodajemy uprawnienia jeœli brakuje uprawnienia do kasowania) przez u¿ytkownika test

-- 5. Wykonujemy zapytanie zwracaj¹ce nazwê produktu, jego cenê i nazwê kategorii, do której produkt nale¿y (dla u¿ytkownika test)  

-- 6. Cofamy uprawnienia INSERT na tabeli Categories dla u¿ytkownika test.
-- Sprawdziæ jak dzia³a polecenie SELECT, INSERT, DELETE i UPDATE na tej tabeli.

-- 7. Zabraniamy uprawnienia SELECT, UPDATE na tabeli Categories dla u¿ytkownika test.
-- Sprawdziæ jak dzia³a polecenie SELECT, INSERT, DELETE i UPDATE na tej tabeli.


-- Systemowe procedury sk³adowane do przegl¹dania uprawnieñ
EXEC sp_helpsrvrole
EXEC sp_srvrolepermission securityadmin
EXEC sp_srvrolepermission diskadmin
EXEC sp_srvrolepermission sysadmin

EXEC sp_helprole
EXEC sp_dbfixedrolepermission db_securityadmin 
EXEC sp_dbfixedrolepermission db_datawriter
EXEC sp_dbfixedrolepermission db_datareader

-- Przypisanie uprawnieñ z opcj¹ WITH GRANT OPTION (admin bêdzie móg³ u¿ytkownikowi bazy danych test przypisaæ dane uprawnienia) 
GRANT select, insert ON dbo.categories TO admin WITH GRANT OPTION

-- 8. Przypisz u¿ytkownikowi test powy¿sze uprawnienia jako admin i sprawdŸ poprawnoœæ tych uprawnieñ (SELECT, INSERT) przez u¿ytkownika test.


-- Nastêpnie zabieramy prawa przypisane z opcj¹ WITH GRANT OPTION
EXEC sp_helprotect 'dbo.categories', null, null -- mo¿na te prawa sprawdziæ jako prawa efektywne w SSMS
REVOKE select, INSERT on dbo.categories FROM admin CASCADE

-- 9. Sprawdzamy, czy u¿ytkownik test ma uprawnienia (SELECT, INSERT na tabeli categories) wykonuj¹c polecenia SELECT, INSERT, spradzaj¹c prawa efektywne w SSMS oraz za pomoc¹ sp_helprotect


-- Sprawdzanie ró¿nych uprawnieñ procedur¹ sp_helprotect
EXEC sp_helprotect null, null, null, 's'
EXEC sp_helprotect null, 'admin', null, 'o'
EXEC sp_helprotect null
EXEC sp_helprotect 'CREATE TABLE', [dbo]


-- 10. Dodaæ odpowiednie uprawnienia u¿ytkownikowi test, 
-- aby móg³ dodaæ klucze PK i FK do tabeli Products i Categories (dodaæ klucze). 
-- (wykorzystaæ odpowiednie prawo szczegó³owe (np. ALTER) na poziomie tabel bez zapisywania do roli db_owner)
-- Po wykonaniu operacji zabieramy uprawnienia do tworzenia kluczy i zostawiamy tylko do wykonania 
-- zapytania na obu tabelach z wykorzystaniem klauzuli join (zad 5.).
