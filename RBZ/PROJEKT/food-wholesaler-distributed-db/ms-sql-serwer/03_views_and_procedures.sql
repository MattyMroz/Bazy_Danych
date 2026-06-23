/*
    03_views_and_procedures.sql

    Widoki i procedury dla czesci rozproszonej.

*/

USE HurtowniaCentrala;
GO

-- ============================================================
-- 1. Widok v_porownanie_cen
-- ============================================================
-- Zestawia ceny tego samego produktu z trzech zrodel: lokalnego cennika
-- centrali, cache Oracle (OPENQUERY SRV_ORACLE) i pliku Excel (OPENQUERY
-- SRV_EXCEL). Kolumna status_porownania pokazuje, czy ceny sa ZGODNE,
-- czy jest ROZNICA albo BRAK w ktoryms ze zrodel.

CREATE OR ALTER VIEW dbo.v_porownanie_cen
AS
-- aktualny cennik centrali: dla kazdego produktu bierze najnowszy obowiazujacy wpis
WITH aktualny_cennik AS (
    SELECT
        cd.id_produktu,
        cd.cena_netto,
        -- numeruje ceny produktu: najnowsza dostaje 1, starsze 2, 3 itd...
        ROW_NUMBER() OVER (
            PARTITION BY cd.id_produktu
            ORDER BY cd.data_od DESC, cd.id_cennika DESC
        ) AS rn
    FROM dbo.CENNIK_DOSTAWCY AS cd
    -- zostawia tylko ceny obowiazujace dzis (nie z przyszlosci i nie wygasle)
    WHERE cd.data_od <= CAST(GETDATE() AS DATE)
      AND (cd.data_do IS NULL OR cd.data_do >= CAST(GETDATE() AS DATE))
)
SELECT
    p.id_produktu,
    p.nazwa,
    CAST(ac.cena_netto AS DECIMAL(10,2)) AS cena_centrala,
    CAST(o.cena_netto AS DECIMAL(10,2)) AS cena_oracle,
    CAST(x.cena_netto AS DECIMAL(10,2)) AS cena_excel,
    CAST(x.data_od AS DATE) AS data_od_excel,
    -- porownanie ceny Excel vs Oracle
    CASE
        WHEN x.cena_netto IS NULL THEN N'BRAK W EXCEL'
        WHEN o.cena_netto IS NULL THEN N'BRAK W ORACLE'
        WHEN CAST(x.cena_netto AS DECIMAL(10,2)) = CAST(o.cena_netto AS DECIMAL(10,2)) THEN N'ZGODNE'
        ELSE N'ROZNICA'
    END AS status_porownania
FROM dbo.PRODUKT AS p
-- cena lokalna z centrali
LEFT JOIN aktualny_cennik AS ac
    ON p.id_produktu = ac.id_produktu
   AND ac.rn = 1
-- cena z Oracle (cache produktow)
LEFT JOIN OPENQUERY(SRV_ORACLE, '
    SELECT
        ID_PRODUKTU,
        NAZWA,
        CENA_NETTO
    FROM PRODUKT_CACHE
') AS o
    ON p.id_produktu = CAST(o.ID_PRODUKTU AS INT)
-- cena z pliku Excel (cennik dostawcy)
LEFT JOIN OPENQUERY(SRV_EXCEL, '
    SELECT
        id_produktu,
        cena_netto,
        data_od
    FROM [Cennik$]
') AS x
    ON p.id_produktu = CAST(x.id_produktu AS INT);
GO

SELECT TOP 20 *
FROM dbo.v_porownanie_cen
ORDER BY id_produktu;
GO

-- ============================================================
-- 2. Widok v_produkty_sprzedaz_stan
-- ============================================================
-- Zestawia per produkt laczna ilosc zamowiona (Oracle) z iloscia dostepna
-- w magazynie (SQL Server). Laczenie po id_produktu.

CREATE OR ALTER VIEW dbo.v_produkty_sprzedaz_stan
AS
SELECT
    p.id_produktu,
    p.nazwa,
    CAST(ISNULL(o.ILOSC_ZAMOWIONA, 0) AS DECIMAL(12,3)) AS ilosc_zamowiona,
    CAST(ISNULL(m.ilosc_dostepna, 0) AS DECIMAL(12,3)) AS ilosc_w_magazynie
FROM dbo.PRODUKT AS p
-- ilosc zamowiona per produkt liczona po stronie Oracle
LEFT JOIN OPENQUERY(SRV_ORACLE, '
    SELECT pz.ID_PRODUKTU, SUM(pz.ILOSC) AS ILOSC_ZAMOWIONA
    FROM POZYCJA_ZAMOWIENIA pz
    GROUP BY pz.ID_PRODUKTU
') AS o
    ON p.id_produktu = CAST(o.ID_PRODUKTU AS INT)
-- ilosc dostepna per produkt liczona po stronie magazynu (SQL Server)
LEFT JOIN (
    SELECT pa.id_produktu, SUM(sp.ilosc_dostepna) AS ilosc_dostepna
    FROM SRV_MAGAZYN.HurtowniaMagazyn.dbo.PARTIA AS pa
    JOIN SRV_MAGAZYN.HurtowniaMagazyn.dbo.STAN_PARTII AS sp
        ON pa.id_partii = sp.id_partii
    GROUP BY pa.id_produktu
) AS m
    ON p.id_produktu = m.id_produktu;
GO

SELECT TOP 20 *
FROM dbo.v_produkty_sprzedaz_stan
ORDER BY id_produktu;
GO

-- ============================================================
-- 3. Procedura sp_importuj_cennik_excel
-- ============================================================
-- Importuje cennik dostawcy z pliku Excel (OPENROWSET, sciezka jako parametr).
-- Dla produktow, ktorych cena sie zmienila, aktualizuje cennik CENNIK_DOSTAWCY
-- z zachowaniem historii: zamyka stary wpis (data_do = dzis) i dodaje nowy
-- (cena z Excela, data_do = NULL). Stare zamowienia maja zamrozone ceny i nie
-- sa naruszane. Na koniec pokazuje co sie zmienilo (cena stara -> nowa).

CREATE OR ALTER PROCEDURE dbo.sp_importuj_cennik_excel
    @sciezka_excel NVARCHAR(4000) = N'C:\excel\cenniki_dostawcow.xlsx',
    @id_dostawcy   INT = 1
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX);
    DECLARE @sciezka_escaped NVARCHAR(4000) = REPLACE(@sciezka_excel, '''', '''''');
    DECLARE @dzis DATE = CAST(GETDATE() AS DATE);

    -- 1. Wyczyszczenie bufora i wczytanie cennika z Excela
    DELETE FROM dbo.CENNIK_IMPORT WHERE zrodlo = N'Excel';

    SET @sql = N'
        INSERT INTO dbo.CENNIK_IMPORT (id_produktu, cena_netto, data_od, zrodlo)
        SELECT
            TRY_CONVERT(INT, x.id_produktu) AS id_produktu,
            TRY_CONVERT(DECIMAL(10,2), x.cena_netto) AS cena_netto,
            TRY_CONVERT(DATE, x.data_od) AS data_od,
            N''Excel''
        FROM OPENROWSET(
            ''Microsoft.ACE.OLEDB.12.0'',
            ''Excel 12.0;Database=' + @sciezka_escaped + N';HDR=YES;'',
            ''SELECT id_produktu, cena_netto, data_od FROM [Cennik$]''
        ) AS x
        WHERE TRY_CONVERT(INT, x.id_produktu) IS NOT NULL
          AND TRY_CONVERT(DECIMAL(10,2), x.cena_netto) IS NOT NULL;';

    EXEC sp_executesql @sql;

    -- 2. Aktualny cennik (najnowszy wpis per produkt dla danego dostawcy)
    --    Produkty, dla ktorych cena z Excela rozni sie od obecnej:
    SELECT
        i.id_produktu,
        i.cena_netto AS cena_nowa,
        ac.id_cennika,
        ac.cena_netto AS cena_obecna
    INTO #zmiany
    FROM dbo.CENNIK_IMPORT AS i
    OUTER APPLY ( -- dla każdego wiersza z lewej (cena z Excela) odpala osobne  zapytanie po prawej (znajdź obecną cenę tego produktu) i dokleja wynik obok i jak nic nie znajdzie, wiersz zostaje, a cena jest pusta (NULL).
        SELECT TOP 1 cd.id_cennika, cd.cena_netto
        FROM dbo.CENNIK_DOSTAWCY AS cd
        WHERE cd.id_dostawcy = @id_dostawcy -- tego dostawcy
          AND cd.id_produktu = i.id_produktu -- tego samego produktu co w Excelu
          AND cd.data_do IS NULL -- tylko AKTUALNA cena (nie wygasła)
        ORDER BY cd.data_od DESC, cd.id_cennika DESC
    ) AS ac
    WHERE i.zrodlo = N'Excel'
      AND (ac.cena_netto IS NULL OR ac.cena_netto <> i.cena_netto);

    -- 3. Starym cenom zmienionych produktów wpisuje datę końca = dzisiaj (zamyka je jako wygasłe)
    UPDATE cd
    SET cd.data_do = @dzis
    FROM dbo.CENNIK_DOSTAWCY AS cd
    JOIN #zmiany AS z ON cd.id_cennika = z.id_cennika;

    -- 4. Dodaje nowe ceny z Excela jako aktualne (data_do = NULL)
    INSERT INTO dbo.CENNIK_DOSTAWCY (id_dostawcy, id_produktu, cena_netto, data_od, data_do)
    SELECT @id_dostawcy, z.id_produktu, z.cena_nowa, @dzis, NULL
    FROM #zmiany AS z;

    -- 5. Raport: co sie zmienilo (cena stara -> nowa)
    SELECT
        z.id_produktu,
        p.nazwa,
        z.cena_obecna AS cena_stara,
        z.cena_nowa,
        CASE WHEN z.cena_obecna IS NULL THEN N'NOWA CENA' ELSE N'ZMIANA CENY' END AS status
    FROM #zmiany AS z
    LEFT JOIN dbo.PRODUKT AS p ON z.id_produktu = p.id_produktu
    ORDER BY z.id_produktu;
END;
GO

-- EXEC dbo.sp_importuj_cennik_excel;
-- GO

-- ============================================================
-- 4. Procedura sp_rezerwuj_fefo
-- ============================================================
-- Rezerwuje towar pod zamowienie wg zasady FEFO (najpierw partie z najkrotszym
-- terminem). Pozycje bierze z Oracle, stany i rezerwacje trzyma w magazynie.
-- Gdy brakuje towaru - zglasza blad i transakcja sie wycofuje.

CREATE OR ALTER PROCEDURE dbo.sp_rezerwuj_fefo
    @id_zamowienia INT
AS
BEGIN
    SET NOCOUNT ON; -- off komunikaty ;)

    -- 1. Pozycje zamowienia z Oracle do tabeli tymczasowej
    CREATE TABLE #pozycje (
        id_produktu INT NOT NULL,
        ilosc DECIMAL(10,3) NOT NULL
    );

    -- Z oracle co trzeba zrealkizować
    INSERT INTO #pozycje (id_produktu, ilosc)
    SELECT
        CAST(p.ID_PRODUKTU AS INT),
        CAST(p.ILOSC AS DECIMAL(10,3))
    FROM OPENQUERY(SRV_ORACLE, '
        SELECT ID_PRODUKTU, ILOSC, ID_ZAMOWIENIA
        FROM POZYCJA_ZAMOWIENIA
    ') AS p
    WHERE p.ID_ZAMOWIENIA = @id_zamowienia;

    IF NOT EXISTS (SELECT 1 FROM #pozycje)
        THROW 51000, 'Brak pozycji zamowienia do rezerwacji.', 1;

    DECLARE
        @id_produktu INT,
        @ilosc_potrzebna DECIMAL(10,3),
        @id_partii INT,
        @ilosc_dostepna DECIMAL(10,3),
        @ilosc_rezerwowana DECIMAL(10,3);

    -- 2. Dla kazdej pozycji schodzimy po partiach od najkrotszego terminu (FEFO)
    DECLARE pozycje_cursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT id_produktu, ilosc
        FROM #pozycje;

    OPEN pozycje_cursor;
    -- Pobranie pierwszej pozycji do zmiennych.
    FETCH NEXT FROM pozycje_cursor INTO @id_produktu, @ilosc_potrzebna;

    -- @@FETCH_STATUS = 0 oznacza, ze udalo sie pobrac wiersz (sa jeszcze pozycje)
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Dopoki dla tej pozycji brakuje towaru, bierzemy kolejna partie.
        WHILE @ilosc_potrzebna > 0
        BEGIN
            -- Partia z najkrotszym terminem przydatnosci (FEFO), ktora ma jeszcze stan
            SELECT TOP 1
                @id_partii = pa.id_partii,
                @ilosc_dostepna = sp.ilosc_dostepna
            FROM SRV_MAGAZYN.HurtowniaMagazyn.dbo.PARTIA AS pa
            JOIN SRV_MAGAZYN.HurtowniaMagazyn.dbo.STAN_PARTII AS sp
                ON pa.id_partii = sp.id_partii
            WHERE pa.id_produktu = @id_produktu
              AND sp.ilosc_dostepna > 0
            ORDER BY pa.data_przydatnosci, pa.id_partii;

            -- Brak partii ze stanem = nie da sie zarezerwowac calej ilosci
            IF @id_partii IS NULL
                THROW 51001, 'Brak wystarczajacego stanu magazynowego.', 1;

            -- Ile mozna zarezerwowac z tej partii: albo tyle ile potrzeba, albo tyle ile jest dostepne
            SET @ilosc_rezerwowana =
                CASE
                    WHEN @ilosc_dostepna >= @ilosc_potrzebna THEN @ilosc_potrzebna
                    ELSE @ilosc_dostepna
                END;

            -- Zdejmuje zarezerwowaną ilość ze stanu
            UPDATE SRV_MAGAZYN.HurtowniaMagazyn.dbo.STAN_PARTII
            SET ilosc_dostepna = ilosc_dostepna - @ilosc_rezerwowana
            WHERE id_partii = @id_partii;

            -- Zapisuje rezerwację
            INSERT INTO SRV_MAGAZYN.HurtowniaMagazyn.dbo.REZERWACJA
                (id_partii, id_zamowienia_zewn, ilosc)
            VALUES
                (@id_partii, @id_zamowienia, @ilosc_rezerwowana);

            -- Zostalo mniej do zarezerwowania; zerujemy zmienne partii przed kolejnym obrotem
            SET @ilosc_potrzebna = @ilosc_potrzebna - @ilosc_rezerwowana;
            SET @id_partii = NULL;
            SET @ilosc_dostepna = NULL;
        END;

        -- Nastepna pozycja zamowienia (gdy brak - @@FETCH_STATUS != 0 i petla sie konczy)
        FETCH NEXT FROM pozycje_cursor INTO @id_produktu, @ilosc_potrzebna;
    END;

    -- Zamkniecie i zwolnienie kursora
    CLOSE pozycje_cursor;
    DEALLOCATE pozycje_cursor;

    -- 3. Pokaz utworzone rezerwacje
    SELECT *
    FROM SRV_MAGAZYN.HurtowniaMagazyn.dbo.REZERWACJA
    WHERE id_zamowienia_zewn = @id_zamowienia;
END;
GO

-- ============================================================
-- 5. Procedura sp_push_produkty_to_oracle
-- ============================================================
-- Wysyla aktualne produkty z centrali do cache Oracle (PRODUKT_CACHE).
-- Najpierw laduje je do tabeli stagingowej, potem MERGE wgrywa do cache.

CREATE OR ALTER PROCEDURE dbo.sp_push_produkty_to_oracle
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Oprozniamy "poczekalnie" (staging) w Oracle, zeby nie bylo danych ze starego razu
    EXEC ('DELETE FROM PRODUKT_CACHE_STG') AT SRV_ORACLE;

    -- 2. Wstawienie produktow do stagingu - kazdy osobnym INSERT na Oracle
    DECLARE
        @id_produktu INT,
        @nazwa NVARCHAR(100),
        @jednostka NVARCHAR(20),
        @stawka DECIMAL(5,2),
        @cena DECIMAL(10,2),
        @sql NVARCHAR(1000);

    -- Kursor bierze aktywne produkty z jednostka, stawka VAT i aktualna cena
    DECLARE produkty_cursor CURSOR LOCAL FAST_FORWARD FOR
        WITH aktualny_cennik AS (
            SELECT
                cd.id_produktu,
                cd.cena_netto,
                -- numeruje ceny produktu: najnowsza dostaje 1, starsze 2, 3 itd...
                ROW_NUMBER() OVER (
                    PARTITION BY cd.id_produktu
                    ORDER BY cd.data_od DESC, cd.id_cennika DESC
                ) AS rn
            FROM dbo.CENNIK_DOSTAWCY AS cd
            -- zostawia tylko ceny obowiazujace dzis (nie z przyszlosci i nie wygasle)
            WHERE cd.data_od <= CAST(GETDATE() AS DATE)
              AND (cd.data_do IS NULL OR cd.data_do >= CAST(GETDATE() AS DATE))
        )
        -- aktywne produkty + ich aktualna cena (rn = 1) i stawka VAT
        SELECT p.id_produktu, p.nazwa, p.jednostka_miary, sv.stawka, ac.cena_netto
        FROM dbo.PRODUKT AS p
        JOIN dbo.STAWKA_VAT AS sv
            ON p.id_stawki_vat = sv.id_stawki
        JOIN aktualny_cennik AS ac
            ON p.id_produktu = ac.id_produktu
           AND ac.rn = 1
        WHERE p.aktywny = 1;

    -- otwarcie kursora i pobranie pierwszego produktu
    OPEN produkty_cursor;
    FETCH NEXT FROM produkty_cursor INTO @id_produktu, @nazwa, @jednostka, @stawka, @cena;

    -- petla: dla kazdego produktu buduje INSERT i wysyla go do Oracle
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @sql =
            N'INSERT INTO PRODUKT_CACHE_STG (ID_PRODUKTU, NAZWA, JEDNOSTKA_MIARY, STAWKA_VAT, CENA_NETTO) VALUES ('
            + CAST(@id_produktu AS NVARCHAR(10)) + N','''
            + REPLACE(@nazwa, '''', '''''') + N''','''
            + REPLACE(@jednostka, '''', '''''') + N''','
            + CAST(@stawka AS NVARCHAR(20)) + N','
            + CAST(@cena AS NVARCHAR(20)) + N')';

        EXEC (@sql) AT SRV_ORACLE;

        FETCH NEXT FROM produkty_cursor INTO @id_produktu, @nazwa, @jednostka, @stawka, @cena;
    END;

    -- zamkniecie i zwolnienie kursora
    CLOSE produkty_cursor;
    DEALLOCATE produkty_cursor;

    -- 3. Ile rekordow rozni sie miedzy stagingiem a cache (nowe lub zmienione)
    DECLARE @liczba_zmienionych INT;

    SELECT @liczba_zmienionych = COUNT(*)
    FROM OPENQUERY(SRV_ORACLE, '
        SELECT stg.ID_PRODUKTU
        FROM PRODUKT_CACHE_STG stg
        LEFT JOIN PRODUKT_CACHE pc ON pc.ID_PRODUKTU = stg.ID_PRODUKTU
        WHERE pc.ID_PRODUKTU IS NULL
           OR pc.NAZWA <> stg.NAZWA
           OR pc.JEDNOSTKA_MIARY <> stg.JEDNOSTKA_MIARY
           OR pc.STAWKA_VAT <> stg.STAWKA_VAT
           OR pc.CENA_NETTO <> stg.CENA_NETTO
    ') AS r;

    -- 4. MERGE na Oracle: zmienione aktualizuje (WHEN MATCHED AND ...), nowe dodaje
    EXEC ('
        MERGE INTO PRODUKT_CACHE pc
        USING PRODUKT_CACHE_STG stg
           ON (pc.ID_PRODUKTU = stg.ID_PRODUKTU)
        WHEN MATCHED THEN
            UPDATE SET
                pc.NAZWA = stg.NAZWA,
                pc.JEDNOSTKA_MIARY = stg.JEDNOSTKA_MIARY,
                pc.STAWKA_VAT = stg.STAWKA_VAT,
                pc.CENA_NETTO = stg.CENA_NETTO,
                pc.DATA_SYNCHRONIZACJI = SYSDATE
            WHERE pc.NAZWA <> stg.NAZWA
               OR pc.JEDNOSTKA_MIARY <> stg.JEDNOSTKA_MIARY
               OR pc.STAWKA_VAT <> stg.STAWKA_VAT
               OR pc.CENA_NETTO <> stg.CENA_NETTO
        WHEN NOT MATCHED THEN
            INSERT (
                ID_PRODUKTU,
                NAZWA,
                JEDNOSTKA_MIARY,
                STAWKA_VAT,
                CENA_NETTO,
                DATA_SYNCHRONIZACJI
            )
            VALUES (
                stg.ID_PRODUKTU,
                stg.NAZWA,
                stg.JEDNOSTKA_MIARY,
                stg.STAWKA_VAT,
                stg.CENA_NETTO,
                SYSDATE
            )
    ') AT SRV_ORACLE;

    -- 5. Raport: ile rekordow dodano lub zmieniono.
    SELECT @liczba_zmienionych AS liczba_produktow_zmienionych;
END;
GO

EXEC dbo.sp_push_produkty_to_oracle;
GO
