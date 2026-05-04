-- Ustanowić serwer połączony SQLServer o nazwie Serwer1 z wykorzystaniem loginu sa
-- w systemie SQLServer, mapowanego na prawa konta: ZA23, hasło: 12345, tego samego lokalnego serwera.

-- Opracować widok: Widok1 zaszyfrowany w bazie NORTHWIND SQL Server,
-- przez który możliwa będzie operacja pobierania danych:
-- jaki pracownik EMPLOYEES Oracle obsłużył jakie zamówienia ORDERS Oracle,
-- na których są jakie produkty Serwer1 SQL Server.
-- W tym celu wykorzystać funkcję OPENROWSET().

-- Wykorzystując ustanowiony serwer Serwer1 i bezwzględną czteroczłonową identyfikację obiektu
-- napisać zapytanie:
-- który spedytor tabela Shippers serwera Serwer1 miał największy wzrost wartości przewozów
-- między 1997 a 1998 rokiem, różnica rok do roku bez upustów, tabele serwera zdalnego.

-- Napisać zapytanie przekazujące do serwera Serwer1, przetwarzanie zdalne OPENQUERY():
-- podać jaki klient nie zrealizował żadnych zamówień oraz dalej porównać,
-- czy na serwerze lokalnym ten sam klient zrealizował tę samą liczbę zamówień.

-- Napisać procedurę PROC4(@OrderID), która zwróci wszystkie kategorie z danego zamówienia
-- oraz łączną wartość sprzedaży per kategoria bez rabatów.
-- W tym celu wykorzystać funkcję OPENROWSET() odwołującą się do bazy Northwind Access.
-- Podać przykład wyzwolenia procedury z różnymi ustawionymi atrybutami parametru wejściowego.