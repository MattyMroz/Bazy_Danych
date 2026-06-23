# MS SQL Server - prosty plan

Tutaj ma byc czesc projektu napisana w MS SQL Server. Nie robimy duzej
struktury katalogow. Wystarcza kilka plikow `.sql`, a w nich sekcje tematyczne
oznaczone komentarzami.

## Pliki

```text
ms-sql-serwer/
  README.md
  01_databases_and_tables.sql
  02_linked_servers.sql
  03_views_and_procedures.sql
  04_dtc_replication.sql
  05_demo_scenariusz.sql
```

## Co ma byc w plikach

`01_databases_and_tables.sql`

- utworzenie baz `HurtowniaCentrala` i `HurtowniaMagazyn`;
- tabele centrali: kategorie, VAT, produkty, dostawcy, cenniki, import cennika;
- tabele magazynu: replika produktow, strefy, partie, stany partii, rezerwacje;
- podstawowe dane slownikowe;
- proste uprawnienia/login do testow.

`02_linked_servers.sql`

- wlaczenie `Ad Hoc Distributed Queries`;
- konfiguracja providerow OLE DB;
- linked server do magazynu `SRV_MAGAZYN`;
- linked server do Oracle `SRV_ORACLE`;
- linked server do Access `SRV_ACCESS`;
- linked server do Excel `SRV_EXCEL`;
- przyklady `OPENROWSET` i `OPENQUERY`.

`03_views_and_procedures.sql`

- widok porownania cen z Oracle i Excela;
- widok klientow z wartoscia zamowien i stanami magazynu;
- procedura importu cennika z Excela;
- procedura rezerwacji FEFO;
- procedura wyslania produktow do Oracle.

`04_dtc_replication.sql`

- krotka checklista MS DTC w komentarzach;
- procedura zatwierdzania zamowienia w transakcji rozproszonej;
- opis konfiguracji replikacji transakcyjnej (kreator SSMS).

`05_demo_scenariusz.sql`

- scenariusze testowe do demonstracji (DTC, replikacja, widoki, import, push).

## Minimalny zakres z kolos.sql

Projekt powinien pokazac:

- `OPENROWSET` dla SQL Server, Oracle, Access i Excel;
- stale linked servery i mapowanie loginow;
- `OPENQUERY`;
- widoki i procedury na danych lokalnych i zdalnych;
- zapis/zmiane danych na zdalnym zrodle;
- `BEGIN DISTRIBUTED TRANSACTION` z MS DTC.

Wszystkie hasla ustawione sa na `123`
(loginy MS SQL, uzytkownicy Oracle, mapowanie loginu do `SRV_ORACLE`).

## Jak uruchomic i pokazac, ze dziala (runbook)

Kolejnosc uruchomienia calego srodowiska (Oracle + MS SQL + pliki zrodlowe):

1. **Oracle (kolega)** - uruchomic skrypty z folderu `oracle/` po kolei:
   `1` -> `2` -> `3` -> `4` -> `5` -> `6` -> `7a` -> `7b` -> `8` -> `9`
   -> `10` -> `11` -> `12_seed_test_data.sql` (dane testowe).
2. **Oracle (kolega)** - zainstalowac OraMTS i sprawdzic, ze listener dziala
   (bez OraMTS transakcja DTC z MS SQL sie nie powiedzie).
3. **MS SQL (ja)** - uruchomic skrypty z `ms-sql-serwer/` po kolei:
   `01` -> `02` -> `03` -> `04`.
4. **MS SQL** - w `02_linked_servers.sql` sprawdzic dane polaczenia Oracle
   (host=localhost, port=1521, SERVICE_NAME=pdb, haslo `SPRZEDAZ_USER`=123).
5. **MS SQL** - wlaczyc MS DTC wg checklisty w `04` (`dcomcnfg`,
   Network DTC Access, Allow Inbound/Outbound, Enable XA Transactions).
6. **MS SQL** - `EXEC dbo.sp_push_produkty_to_oracle;` (synchronizacja katalogu
   do `PRODUKT_CACHE` w Oracle; seed `12` i tak juz wpisal te produkty recznie,
   wiec ten krok pokazuje sama synchronizacje).

Co wtedy mozna zademonstrowac:

- **Widoki rozproszone**: `SELECT * FROM dbo.v_porownanie_cen;`
  oraz `SELECT * FROM dbo.v_produkty_sprzedaz_stan;`
- **Import z Excela**: `EXEC dbo.sp_importuj_cennik_excel;`
- **Transakcja DTC (glowny pokaz)**:
  `EXEC dbo.sp_zatwierdz_zamowienie_dtc @id_zamowienia = 1;`
  (rezerwuje towar FEFO w magazynie i zmienia status zamowienia 1 w Oracle
  na ZATWIERDZONE - albo obie operacje razem, albo zadna).
- **Po stronie Oracle**: widok `SPRZEDAZ.V_ZAMOWIENIA_PELNE` (biezace + archiwum)
  i raport `PKG_SPRZEDAZ.sp_raport_top_klienci`.
