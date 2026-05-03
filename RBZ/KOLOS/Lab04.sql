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



