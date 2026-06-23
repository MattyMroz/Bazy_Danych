/*
    04_dtc_replication.sql

    Transakcja rozproszona MS DTC i replikacja transakcyjna katalogu.
*/

-- 1. Usun subskrypcje
-- EXEC sp_dropsubscription @publication = N'PUB_PRODUKT', @article = N'all', @subscriber = N'all';
-- GO

-- -- 2. Usun publikacje
-- EXEC sp_droppublication @publication = N'PUB_PRODUKT';
-- GO

-- -- 3. Wylacz publikowanie bazy
-- EXEC sp_replicationdboption @dbname = N'HurtowniaCentrala', @optname = N'publish', @value = N'false';
-- GO

-- USE master;
-- GO
-- EXEC sp_dropdistributor @no_checks = 1, @ignore_distributor = 1;
-- GO

-- -- Sprawdz czy wszystko usuniete
-- USE HurtowniaCentrala;
-- SELECT name, is_published FROM sys.tables WHERE name = 'PRODUKT';


USE HurtowniaCentrala;
GO

-- ============================================================
-- 1. Transakcja rozproszona MS DTC
-- ============================================================
-- Checklista przed pierwszym uruchomieniem DTC:
--   1. dcomcnfg -> Component Services -> Computers -> My Computer
--      -> Distributed Transaction Coordinator -> Local DTC.
--   2. W Security wlaczyc: Network DTC Access, Allow Inbound, Allow Outbound,
--      No Authentication Required, Enable XA Transactions (dla Oracle).
--   3. Sprawdzic zapore Windows.
--   4. Przy Oracle sprawdzic OraMTS i provider OraOLEDB.Oracle.

-- Zatwierdza zamowienie w jednej transakcji rozproszonej: rezerwuje towar w
-- magazynie (sp_rezerwuj_fefo) i zmienia status zamowienia w Oracle na
-- ZATWIERDZONE. Obie operacje zatwierdzaja sie razem (2PC) albo wycofuja razem.
CREATE OR ALTER PROCEDURE dbo.sp_zatwierdz_zamowienie_dtc
    @id_zamowienia INT
AS
BEGIN
    SET NOCOUNT ON; -- bez komunikatow "(X wierszy)"
    SET XACT_ABORT ON; -- blad = cofnij cala transakcje

    DECLARE @oracle_sql NVARCHAR(MAX);

    BEGIN TRY
        BEGIN DISTRIBUTED TRANSACTION;

        -- 1. Magazyn (SQL Server): rezerwacja towaru FEFO
        EXEC dbo.sp_rezerwuj_fefo @id_zamowienia = @id_zamowienia;

        -- 2. Sprzedaz (Oracle): zmiana statusu zamowienia na ZATWIERDZONE
        SET @oracle_sql = N'
            UPDATE ZAMOWIENIE
            SET ID_STATUSU = 2
            WHERE ID_ZAMOWIENIA = ' + CAST(@id_zamowienia AS NVARCHAR(20)) + N'
              AND ID_STATUSU = 1';

        EXEC (@oracle_sql) AT SRV_ORACLE;

        -- 3. Zatwierdzenie obu operacji razem (protokol dwufazowy 2PC)
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Blad w ktorejkolwiek operacji = wycofanie calej transakcji
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO

-- ============================================================
-- 2. Zdalne modyfikacje danych (przyklady)
-- ============================================================

-- 2.1 Wstawienie produktu do Oracle przez notacje czteroczesciowa.
/*
INSERT INTO SRV_ORACLE..SPRZEDAZ.PRODUKT_CACHE
    (ID_PRODUKTU, NAZWA, JEDNOSTKA_MIARY, STAWKA_VAT, CENA_NETTO)
VALUES
    (999, N'TEST SQL SERVER', N'szt.', 23, 10.00);
GO
*/

-- 2.2 Aktualizacja stanu w magazynie przez czteroczlonowa nazwe.
/*
UPDATE SRV_MAGAZYN.HurtowniaMagazyn.dbo.STAN_PARTII
SET ilosc_dostepna = ilosc_dostepna - 1
WHERE id_partii = 1
  AND ilosc_dostepna >= 1;
GO
*/

-- 2.3 Wykonanie polecenia bezposrednio na Oracle.
/*
EXEC ('
    UPDATE PRODUKT_CACHE
    SET NAZWA = NAZWA
    WHERE ID_PRODUKTU = 1
') AT SRV_ORACLE;
GO
*/

-- ============================================================
-- 3. Replikacja transakcyjna katalogu produktow
-- ============================================================
/*
    Zmiany w katalogu produktow centrali (HurtowniaCentrala.dbo.PRODUKT)
    splywaja na biezaco do repliki w magazynie (HurtowniaMagazyn.dbo.PRODUKT).

    Role:
    - Publisher / Distributor: HurtowniaCentrala (ta sama instancja)
    - Article: dbo.PRODUKT (tylko 3 kolumny: id_produktu, nazwa, strefa_temperaturowa)
    - Subscriber: HurtowniaMagazyn, tabela docelowa dbo.PRODUKT

    Wymagania:
    - dziala SQL Server Agent (bez niego agenty replikacji nie wystartuja),
    - HurtowniaCentrala w trybie RECOVERY FULL (w SIMPLE log jest obcinany
      i Log Reader nie zdazy przeczytac zmian - replikacja nie dziala),
    - folder migawki na dysku C (np. C:\repldata) - trzeba go utworzyc recznie,
      bo konto uslugi czesto nie ma praw do domyslnego ...\MSSQL\ReplData.

    Konfiguracja przez kreator SSMS:

    A. Dystrybucja (raz na serwer)
       Replication (PPM) -> Configure Distribution
       -> serwer jako wlasny Distributor -> snapshot folder C:\repldata -> Finish.

    B. Publikacja (Publisher = centrala)
       Replication -> Local Publications (PPM) -> New Publication
       -> Publication Database: HurtowniaCentrala
       -> Publication Type: Transactional publication
       -> Articles: zaznaczyc PRODUKT, a w Article Properties ograniczyc kolumny
          do: id_produktu, nazwa, strefa_temperaturowa.
       -> Snapshot Agent: utworzyc snapshot od razu
       -> Agent Security: konto uslugi SQL Server Agent
       -> Publication name: PUB_PRODUKT -> Finish.

    C. Subskrypcja (Subscriber = magazyn)
       PUB_PRODUKT (PPM) -> New Subscriptions
       -> push subscription (agenci na Distributorze)
       -> Subscriber: ten serwer, Subscription Database: HurtowniaMagazyn
       -> Run continuously, Initialize Immediately -> Finish.

    WAZNE - tabela docelowa PRODUKT juz istnieje i ma FK z PARTIA:
    Tabela jest stworzona w 01 (3 kolumny) i jest celem FK_PARTIA_PRODUKT.
    Domyslnie replikacja chce DROP + CREATE tabeli docelowej - to sie nie uda,
    bo PARTIA na nia wskazuje. Dlatego w Article Properties ustawic:
      "Action if name is in use" = Keep existing object unchanged.
    Wtedy replikacja tylko wgrywa dane do istniejacej tabeli, a FK zostaje.

    Podglad: SSMS -> Replication -> Launch Replication Monitor.
*/

-- ============================================================
-- 4. Szybki test (pelne scenariusze sa w 05_demo_scenariusz.sql)
-- ============================================================

-- 4.1 DTC: zatwierdzenie zamowienia (rezerwacja FEFO + status w Oracle razem).
/*
EXEC dbo.sp_zatwierdz_zamowienie_dtc @id_zamowienia = 1;
GO
*/

-- 4.2 Replikacja: zmiana w centrali sama pojawia sie w magazynie.
/*
UPDATE dbo.PRODUKT SET nazwa = N'Pierogi mrozone 1kg (REPL TEST)' WHERE id_produktu = 5;
GO
-- po chwili:
SELECT id_produktu, nazwa FROM HurtowniaMagazyn.dbo.PRODUKT WHERE id_produktu = 5;
GO
UPDATE dbo.PRODUKT SET nazwa = N'Pierogi mrozone 1kg' WHERE id_produktu = 5;
GO
*/
