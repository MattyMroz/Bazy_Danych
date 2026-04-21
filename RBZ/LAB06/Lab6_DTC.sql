
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


USE Northwind;
GO

CREATE TABLE koledzy (
    indeks   INT         NOT NULL PRIMARY KEY,
    nazwisko VARCHAR(50) NOT NULL,
    imie     VARCHAR(25) NOT NULL
);



-----------
-- Krok B:
----------------
-- Nadaj odpowiednie uprawnienia do tej tabeli np. grupie PUBLIC nadaj wszystkie prawa obiektowe (SELECT, INSERT,UPDATE, DELETE). W tym celu wykonaj instrukcję GRANT.

GRANT SELECT, INSERT, UPDATE, DELETE ON koledzy TO PUBLIC;

-----------
-- Krok C:
----------------
-- Sprawdzamy, czy tabela istnieje i możemy z innego użytkownika z niej skorzystać z poziomu użytkownika (serwer lokalny). W tym celu napisz odpowiednią instrukcję SELECT


SELECT * FROM koledzy;
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



USE Northwind;
GO

SET XACT_ABORT ON;
GO

BEGIN DISTRIBUTED TRANSACTION;

    -- Wstawianie LOKALNIE (Twój serwer WB-20)
    INSERT INTO Northwind.dbo.koledzy (indeks, nazwisko, imie)
    VALUES (1, 'Kowalski', 'Jan');

    -- Wstawianie ZDALNIE (kolega WB-18)
    INSERT INTO OPENROWSET(
        'MSOLEDBSQL',
        'WB-18';'sa';'praktyka',
        'SELECT * FROM Northwind.dbo.koledzy'
    )
    VALUES (1, 'Kowalski', 'Jan');

COMMIT TRANSACTION;
GO



-----------
-- Krok B:
----------------

---Sprawdź, czy wstawianie na lokalny i zdalny serwer się się powiodło. W tym celu napisz odpowiednie instrukcje SELECT.


SELECT * FROM Northwind.dbo.koledzy;

SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'WB-18';'sa';'praktyka',
    'SELECT * FROM Northwind.dbo.koledzy'
) AS a;


-- Zadanie 8:
-- Opracować procedurę składowaną, która wprowadzi rekordy na serwer ORACLE oraz taką samą procedurę, która wprowadzi 
-- rekordy do tabeli Northwind (SQL Server)
-- Następnie napisać transakcję rozproszoną z wykorzystaniem tej procedury

----------------------------
-- ja
USE Northwind;
GO

CREATE PROCEDURE dodaj_kolege_lokalny
    @indeks   INT,
    @nazwisko VARCHAR(50),
    @imie     VARCHAR(25)
AS
BEGIN
    INSERT INTO Northwind.dbo.koledzy (indeks, nazwisko, imie)
    VALUES (@indeks, @nazwisko, @imie);
END;
GO


-- kolega
USE Northwind;
GO

CREATE PROCEDURE dodaj_kolege_wb18
    @indeks   INT,
    @nazwisko VARCHAR(50),
    @imie     VARCHAR(25)
AS
BEGIN
    INSERT INTO Northwind.dbo.koledzy (indeks, nazwisko, imie)
    VALUES (@indeks, @nazwisko, @imie);
END;
GO


USE Northwind;
GO

SET XACT_ABORT ON;
GO

BEGIN DISTRIBUTED TRANSACTION;

    -- Wywołanie procedury lokalnie
    EXEC Northwind.dbo.dodaj_kolege_lokalny 2, 'Nowak', 'Anna';

    -- Wywołanie procedury na WB-18
    EXEC ('EXEC Northwind.dbo.dodaj_kolege_wb18 2, ''Nowak'', ''Anna''')
    AT [WB-18];

COMMIT TRANSACTION;
GO


-- Lokalnie
SELECT * FROM Northwind.dbo.koledzy;

-- Na WB-18
SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'WB-18';'sa';'praktyka',
    'SELECT * FROM Northwind.dbo.koledzy'
) AS a;


----------------------------
