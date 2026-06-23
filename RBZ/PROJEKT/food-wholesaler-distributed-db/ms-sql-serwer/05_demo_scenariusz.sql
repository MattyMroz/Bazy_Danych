/*
    05_demo_scenariusz.sql

    Scenariusz demonstracyjny calej czesci MS SQL Server.
    Przechodzi krok po kroku przez wszystkie mechanizmy i pokazuje,
    ze dzialaja - razem z przypadkami brzegowymi (proby naruszenia regul,
    ktore baza MA odrzucic).

    Uruchamiac PO 01-04 (i po stronie Oracle 1-12), gdy linked servery dzialaja.
    Najlepiej odpalac SEKCJAMI (zaznacz fragment + F5), zeby omawiac kazdy krok.

    Legenda wynikow:
    - "[OK]"   = ma sie udac i sie udaje
    - "[BLAD]" = MA sie wywalic (dowod, ze walidacja/zabezpieczenie dziala)
*/

USE HurtowniaCentrala;
GO

-- ############################################################
-- SEKCJA 1. Dane wejsciowe - co mamy w bazach
-- ############################################################
PRINT '=== 1. Stan poczatkowy ===';

-- Katalog produktow w centrali
SELECT id_produktu, nazwa, strefa_temperaturowa, aktywny FROM dbo.PRODUKT ORDER BY id_produktu;

-- Aktualny cennik dostawcow
SELECT id_produktu, cena_netto, data_od FROM dbo.CENNIK_DOSTAWCY ORDER BY id_produktu;

-- Stany magazynowe (przez linked server do magazynu)
SELECT pr.nazwa, sp.ilosc_dostepna
FROM SRV_MAGAZYN.HurtowniaMagazyn.dbo.PRODUKT AS pr
JOIN SRV_MAGAZYN.HurtowniaMagazyn.dbo.PARTIA AS pa ON pr.id_produktu = pa.id_produktu
JOIN SRV_MAGAZYN.HurtowniaMagazyn.dbo.STAN_PARTII AS sp ON pa.id_partii = sp.id_partii
ORDER BY pr.nazwa;
GO

-- ############################################################
-- SEKCJA 2. Testy ograniczen integralnosci (CHECK / UNIQUE / FK)
--           Kazdy ponizszy INSERT MA SIE WYWALIC - to dowod, ze baza pilnuje regul.
-- ############################################################
PRINT '=== 2. Testy ograniczen (kazdy ma zwrocic BLAD) ===';

-- 2.1 [BLAD] Niedozwolona stawka VAT (slownik dopuszcza tylko 0/5/8/23)
BEGIN TRY
    INSERT INTO dbo.STAWKA_VAT (id_stawki, stawka, opis) VALUES (9, 17.00, N'zla stawka');
    PRINT '2.1 [!] Nie powinno przejsc!';
END TRY
BEGIN CATCH
    PRINT '2.1 [BLAD oczekiwany] zla stawka VAT odrzucona: ' + ERROR_MESSAGE();
END CATCH;
GO

-- 2.2 [BLAD] Niedozwolona strefa temperaturowa
BEGIN TRY
    INSERT INTO dbo.PRODUKT (nazwa, jednostka_miary, kod_kreskowy, id_stawki_vat, strefa_temperaturowa, id_kategorii)
    VALUES (N'Zly produkt', N'szt.', N'5900000000099', 4, N'KOSMOS', 1);
    PRINT '2.2 [!] Nie powinno przejsc!';
END TRY
BEGIN CATCH
    PRINT '2.2 [BLAD oczekiwany] zla strefa odrzucona: ' + ERROR_MESSAGE();
END CATCH;
GO

-- 2.3 [BLAD] Ujemna cena w cenniku (CK_CENNIK_CENA: cena > 0)
BEGIN TRY
    INSERT INTO dbo.CENNIK_DOSTAWCY (id_dostawcy, id_produktu, cena_netto, data_od)
    VALUES (1, 1, -5.00, '2026-01-01');
    PRINT '2.3 [!] Nie powinno przejsc!';
END TRY
BEGIN CATCH
    PRINT '2.3 [BLAD oczekiwany] ujemna cena odrzucona: ' + ERROR_MESSAGE();
END CATCH;
GO

-- 2.4 [BLAD] Zly email dostawcy (CK_DOSTAWCA_EMAIL)
BEGIN TRY
    INSERT INTO dbo.DOSTAWCA (nazwa, nip, email) VALUES (N'Zly mail', N'9999999999', N'to-nie-jest-email');
    PRINT '2.4 [!] Nie powinno przejsc!';
END TRY
BEGIN CATCH
    PRINT '2.4 [BLAD oczekiwany] zly email odrzucony: ' + ERROR_MESSAGE();
END CATCH;
GO

-- 2.5 [BLAD] Duplikat NIP dostawcy (UQ_DOSTAWCA_NIP)
BEGIN TRY
    INSERT INTO dbo.DOSTAWCA (nazwa, nip, email) VALUES (N'Duplikat NIP', N'7250000001', NULL);
    PRINT '2.5 [!] Nie powinno przejsc!';
END TRY
BEGIN CATCH
    PRINT '2.5 [BLAD oczekiwany] duplikat NIP odrzucony: ' + ERROR_MESSAGE();
END CATCH;
GO

-- 2.6 [BLAD] Data konca wczesniej niz data poczatku (CK_CENNIK_DATY)
BEGIN TRY
    INSERT INTO dbo.CENNIK_DOSTAWCY (id_dostawcy, id_produktu, cena_netto, data_od, data_do)
    VALUES (1, 1, 5.00, '2026-06-01', '2026-01-01');
    PRINT '2.6 [!] Nie powinno przejsc!';
END TRY
BEGIN CATCH
    PRINT '2.6 [BLAD oczekiwany] data_do < data_od odrzucone: ' + ERROR_MESSAGE();
END CATCH;
GO

-- ############################################################
-- SEKCJA 3. Zrodla zewnetrzne - OPENROWSET / OPENQUERY (ad hoc)
-- ############################################################
PRINT '=== 3. Zrodla zewnetrzne ===';

-- 3.1 [OK] Excel: cennik dostawcy (OPENQUERY przez SRV_EXCEL)
SELECT * FROM OPENQUERY(SRV_EXCEL, 'SELECT id_produktu, cena_netto, data_od FROM [Cennik$]');
GO

-- 3.2 [OK] Access: kartoteka przedstawicieli (OPENQUERY przez SRV_ACCESS)
SELECT * FROM OPENQUERY(SRV_ACCESS, 'SELECT id_przedstawiciela, imie, nazwisko, region FROM PRZEDSTAWICIELE');
GO

-- 3.3 [OK] Oracle: liczba zamowien wg statusu (agregacja po stronie Oracle)
SELECT * FROM OPENQUERY(SRV_ORACLE, '
    SELECT sz.NAZWA AS STATUS, COUNT(*) AS LICZBA
    FROM ZAMOWIENIE z
    JOIN STATUS_ZAMOWIENIA sz ON z.ID_STATUSU = sz.ID_STATUSU
    GROUP BY sz.NAZWA');
GO

-- ############################################################
-- SEKCJA 4. Widoki rozproszone
-- ############################################################
PRINT '=== 4. Widoki rozproszone ===';

-- 4.1 [OK] Porownanie cen: centrala vs Oracle vs Excel (status ZGODNE/ROZNICA/BRAK)
SELECT * FROM dbo.v_porownanie_cen ORDER BY id_produktu;
GO

-- 4.2 [OK] Klienci (wartosc zamowien z Oracle) + stan magazynu (z SQL Server)
SELECT * FROM dbo.v_produkty_sprzedaz_stan ORDER BY id_produktu;
GO

-- ############################################################
-- SEKCJA 5. Import cennika z Excela (aktualizacja cennika z historia)
-- ############################################################
PRINT '=== 5. Import cennika z Excela ===';

-- 5.1 [OK] Import - nanosi zmienione ceny na cennik i pokazuje co sie zmienilo (stara -> nowa)
EXEC dbo.sp_importuj_cennik_excel;
GO

-- 5.2 [OK] Ponowny import tych samych cen - raport pusty (brak zmian = idempotentnosc)
EXEC dbo.sp_importuj_cennik_excel;
GO

-- 5.3 [OK] Historia cen w cenniku: data_do NULL = cena aktualna, reszta = historyczna
SELECT id_cennika, id_produktu, cena_netto, data_od, data_do,
       CASE WHEN data_do IS NULL THEN N'AKTUALNA' ELSE N'historyczna' END AS stan
FROM dbo.CENNIK_DOSTAWCY
ORDER BY id_produktu, data_od;
GO

-- ############################################################
-- SEKCJA 6. Synchronizacja katalogu do Oracle (push)
-- ############################################################
PRINT '=== 6. Push katalogu do Oracle ===';

-- 6.1 [OK] Wyslanie produktow do PRODUKT_CACHE w Oracle (staging + MERGE)
EXEC dbo.sp_push_produkty_to_oracle;
GO

-- 6.2 [OK] Weryfikacja po stronie Oracle
SELECT * FROM OPENQUERY(SRV_ORACLE, 'SELECT ID_PRODUKTU, NAZWA, CENA_NETTO FROM PRODUKT_CACHE ORDER BY ID_PRODUKTU');
GO

-- ############################################################
-- SEKCJA 7. Transakcja rozproszona DTC (rezerwacja FEFO + status w Oracle)
--           To jest najwazniejszy proces: dwie bazy, jedna transakcja.
--           Dodatkowo na produkcie z dwoma partiami widac zasade FEFO.
--           Uruchamiac w osobnym, czystym oknie (inaczej blad 3910 od DTC).
-- ############################################################
PRINT '=== 7. Transakcja rozproszona DTC + dowod FEFO ===';

-- Zatwierdzamy zamowienie 2 (klient 2): 5 x olej + 8 x pierogi.
-- Pierogi (produkt 5) maja DWIE partie o roznych datach przydatnosci,
-- wiec na nich widac dzialanie FEFO - rezerwacja schodzi z partii o
-- najkrotszym terminie, a partia z dluzszym terminem zostaje nietknieta.

-- 7.1 Stan PRZED: partie z data przydatnosci (posortowane FEFO) i status zamowienia 2 w Oracle.
--      Dla pierogow: partia sierpniowa (id 5) ma byc uzyta PRZED grudniowa (id 6).
SELECT pa.id_produktu, pa.id_partii, pa.numer_partii_dostawcy,
       pa.data_przydatnosci, sp.ilosc_dostepna
FROM SRV_MAGAZYN.HurtowniaMagazyn.dbo.PARTIA AS pa
JOIN SRV_MAGAZYN.HurtowniaMagazyn.dbo.STAN_PARTII AS sp ON pa.id_partii = sp.id_partii
ORDER BY pa.id_produktu, pa.data_przydatnosci;
SELECT * FROM OPENQUERY(SRV_ORACLE, 'SELECT ID_ZAMOWIENIA, ID_STATUSU FROM ZAMOWIENIE WHERE ID_ZAMOWIENIA = 2');
GO

-- 7.2 [OK] Zatwierdzenie zamowienia 2: FEFO w magazynie + status=2 w Oracle (atomowo)
EXEC dbo.sp_zatwierdz_zamowienie_dtc @id_zamowienia = 2;
GO

-- 7.3 Stan PO + DOWOD FEFO:
--      8 szt. pierogow zeszlo w calosci z partii sierpniowej (id 5: 40 -> 32),
--      a partia grudniowa (id 6) zostala nietknieta (nadal 40) - czyli rezerwacja
--      wybrala partie o krotszym terminie przydatnosci.
SELECT pa.id_produktu, pa.id_partii, pa.numer_partii_dostawcy,
       pa.data_przydatnosci, sp.ilosc_dostepna
FROM SRV_MAGAZYN.HurtowniaMagazyn.dbo.PARTIA AS pa
JOIN SRV_MAGAZYN.HurtowniaMagazyn.dbo.STAN_PARTII AS sp ON pa.id_partii = sp.id_partii
ORDER BY pa.id_produktu, pa.data_przydatnosci;
SELECT * FROM SRV_MAGAZYN.HurtowniaMagazyn.dbo.REZERWACJA WHERE id_zamowienia_zewn = 2;
SELECT * FROM OPENQUERY(SRV_ORACLE, 'SELECT ID_ZAMOWIENIA, ID_STATUSU FROM ZAMOWIENIE WHERE ID_ZAMOWIENIA = 2');
GO

-- 7.4 [BLAD] Edge case: ponowne zatwierdzenie tego samego zamowienia.
--      Status w Oracle juz nie jest 1, a stany moglyby zejsc ponizej zera -
--      transakcja sie wycofuje (atomowosc: albo wszystko, albo nic).
BEGIN TRY
    EXEC dbo.sp_zatwierdz_zamowienie_dtc @id_zamowienia = 2;
    PRINT '7.4 [i] Przeszlo (sprawdz czy byly jeszcze pozycje do rezerwacji)';
END TRY
BEGIN CATCH
    PRINT '7.4 [BLAD oczekiwany] ponowne zatwierdzenie/ brak stanu - rollback: ' + ERROR_MESSAGE();
END CATCH;
GO

-- ############################################################
-- SEKCJA 8. Replikacja katalogu (PRODUKT centrala -> PRODUKT magazyn)
-- ############################################################
PRINT '=== 8. Replikacja katalogu ===';

-- 8.1 [OK] Dodajemy nowy produkt w centrali
INSERT INTO dbo.PRODUKT (nazwa, jednostka_miary, kod_kreskowy, id_stawki_vat, strefa_temperaturowa, id_kategorii)
VALUES (N'Groszek konserwowy 400g', N'szt.', N'5900000000066', 3, N'SUCHY', 1);
GO

-- 8.2 Jezeli skonfigurowana jest replikacja transakcyjna - produkt pojawi sie
--     w magazynie sam (po kilku sekundach). Sprawdzenie:
WAITFOR DELAY '00:00:05';
SELECT * FROM SRV_MAGAZYN.HurtowniaMagazyn.dbo.PRODUKT WHERE nazwa = N'Groszek konserwowy 400g';
GO

-- ############################################################
-- SEKCJA 8B. Kontrola dostepu do danych (uprawnienia / mapowanie loginu)
-- ############################################################
PRINT '=== 8B. Kontrola dostepu ===';

-- 8B.1 [BLAD] Magazyn NIE moze modyfikowac repliki katalogu (DENY z 01).
--      Replika jest tylko do odczytu - katalog prowadzi centrala.
--      Test wykonujemy w bazie HurtowniaMagazyn, bo tam istnieje user MagazynApp.
USE HurtowniaMagazyn;
GO
BEGIN TRY
    EXECUTE AS USER = 'MagazynApp';
    INSERT INTO dbo.PRODUKT (id_produktu, nazwa, strefa_temperaturowa)
    VALUES (999, N'HACK', N'SUCHY');
    REVERT;
    PRINT '8B.1 [!] Nie powinno przejsc!';
END TRY
BEGIN CATCH
    IF USER_NAME() = 'MagazynApp' REVERT;
    PRINT '8B.1 [BLAD oczekiwany] magazyn nie moze pisac do repliki: ' + ERROR_MESSAGE();
END CATCH;
GO
USE HurtowniaCentrala;
GO

-- 8B.2 [OK] Konto centrali (CentralaApp) ma dostep do swoich danych (GRANT z 01).
EXECUTE AS USER = 'CentralaApp';
SELECT TOP 3 id_produktu, nazwa FROM dbo.PRODUKT ORDER BY id_produktu;
REVERT;
GO

-- 8B.3 [OK] Mapowanie loginu do Oracle: SQL Server laczy sie jako SPRZEDAZ_USER
--      (ograniczone konto). Dostep tylko do obiektow sprzedazy, np. PRODUKT_CACHE.
SELECT * FROM OPENQUERY(SRV_ORACLE, 'SELECT ID_PRODUKTU, NAZWA FROM PRODUKT_CACHE ORDER BY ID_PRODUKTU');
GO

-- ############################################################
-- SEKCJA 9. Sprzatanie po demo (przywrocenie stanu z 01)
-- ############################################################
-- Odkomentuj, aby cofnac dane testowe dodane w scenariuszu.
/*
USE HurtowniaCentrala;
-- usun produkt dodany w 8.1 (replikacja sama usunie go z magazynu)
DELETE FROM dbo.PRODUKT WHERE kod_kreskowy = N'5900000000066';
GO
*/

PRINT '=== KONIEC SCENARIUSZA ===';
GO
