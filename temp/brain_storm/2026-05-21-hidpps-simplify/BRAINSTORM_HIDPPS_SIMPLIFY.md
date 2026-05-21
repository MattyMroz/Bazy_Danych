# 🧠 Small Brainstorm — Uproszczenie HiDPPS

> **Data:** 2026-05-21 | **Tryb:** small (~500 linii) | **Autor:** Mateusz Mróz (251190), Maciej Górka (251143)
> **Cel:** Sprowadzić [HiDPPS.md](../../../RBZ/PROJEKT/HiDPPS.md) (1500 linii, ~42 tabele) do projektu RBD na poziomie semestralnym, pokrywającego wszystkie 13 wymagań z [Projekt.md](../../../RBZ/PROJEKT/Projekt.md), ale **bez overengineeringu**.

---

## FAZA 0: Kontekst

**Co już mam:**
- Pełen brainstorm 5 pomysłów ([BRAINSTORM_HIDPPS_RBD.md](../2026-05-21-hidpps-rbd/BRAINSTORM_HIDPPS_RBD.md)) → wybrany P5 (HiDPPS, 10/10)
- Po review Opusów + fixy → dokument [HiDPPS.md](../../../RBZ/PROJEKT/HiDPPS.md) (1500 linii, 22 sekcje)
- Feedback usera: **"za mocno do tego podszedłeś, to ma być średnio zaawansowany projekt, nie praca inżynierska"**
- Pamięć usera: `simplicity-preferences` → "avoid overengineering, prefer simplicity, fail-fast"

**Wymagania z [Projekt.md](../../../RBZ/PROJEKT/Projekt.md) (13 punktów):**
1. Struktura RBD + uzasadnienie
2. OPENROWSET — 4 typy + wielodostęp
3. Linked Servers — 4 typy + mapowanie loginów
4. OPENQUERY pass-through
5. INSERT/UPDATE zdalne
6. MS DTC + konfiguracja
7. Replikacja
8. Oracle użytkownicy/role
9. DB linki publiczne i prywatne
10. Symulacja zdalnych źródeł przez DB link
11. Widoki rozproszone Oracle + rzutowanie
12. INSTEAD OF triggery
13. Procedury PL/SQL

---

## FAZA 1: Tablica Prawdy (nowe constraints)

| # | Święta Zasada | Status |
|---|---|---|
| 1 | Pełne 13 wymagań pokryte | 🔒 ABSOLUTNA |
| 2 | Max ~18-20 tabel łącznie | 🔒 ABSOLUTNA |
| 3 | Wszystko musi się dać pokazać w 1 demo (max 30 min) | 🔒 ABSOLUTNA |
| 4 | Każda tabela ma jasny use case w demo | 🔒 ABSOLUTNA |
| 5 | Wzór Northwind: minimum kolumn, jasne klucze, biznes w procedurach | 🔒 ABSOLUTNA |
| 6 | Architektura: 2× MSSQL + 1× Oracle (zostaje z v1) | 🔒 ABSOLUTNA |
| 7 | Tezowe założenie projektowe: **prostota > kompletność biznesowa** | 🔒 ABSOLUTNA |

> Jeśli pomysł powiększa zakres > 20 tabel albo dodaje mechanikę poza 13 wymaganiami → ODRZUCONY.

---

## FAZA 2: Pomysły — Co wycinamy (8 decyzji cięcia)

### 💡 Cięcie 1: Temporal tables / audit history
**Opis:** Usunąć `audyt_zmian_produktow`, `audyt_zmian_cennikow`, history tables Oracle, triggery audit.
**Mocne strony:** -4 tabele, -2 triggery, -50 linii DDL
**Słabe strony:** Tracimy "kto co zmienił" — ale nie było wymagane
**Ryzyko:** Żadne, prowadzący nie pyta o audit
**Ocena:** ⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐ (10/10) — czysta strata, tnij
**Tablica prawdy:** ✅

### 💡 Cięcie 2: Faktury korygujące + zwroty
**Opis:** Usunąć `faktury` (cały typ_faktury=K), `zwroty`, `pozycje_zwrotow`, `id_faktury_korygowanej`, procedurę `sp_wystaw_korekte`.
**Mocne strony:** -3 tabele, -1 procedura
**Słabe strony:** Tracimy realistyczny VAT model — ale "1 faktura per zamówienie" wystarczy
**Ocena:** ⭐⭐⭐⭐⭐⭐⭐⭐⭐☆ (9/10)
**Tablica prawdy:** ✅

### 💡 Cięcie 3: Saga Pattern (Plan B DTC)
**Opis:** Usunąć `sp_zatwierdz_zamowienie_saga` + całą sekcję §12.6.
**Mocne strony:** -1 procedura, -30 linii dokumentu
**Słabe strony:** Tracimy "co jeśli OraMTS nie działa" — ale w demo zakładamy że działa
**Ocena:** ⭐⭐⭐⭐⭐⭐⭐⭐⭐☆ (9/10) — projekt RBD pokazuje DTC, nie disaster recovery
**Tablica prawdy:** ✅

### 💡 Cięcie 4: Pojazdy / trasy / przystanki / typ_chlodzenia
**Opis:** Usunąć `pojazdy`, `trasy_dostaw`, `przystanki_trasy`, procedurę `sp_zaplanuj_trase`, widok `vw_finanse_glowne_pomocnicze` zmienić na coś innego.
**Mocne strony:** -3 tabele, -1 procedura PL/SQL, -1 widok
**Słabe strony:** Tracimy domenę logistyki — ale to nie jest projekt logistyczny
**Ocena:** ⭐⭐⭐⭐⭐⭐⭐⭐⭐☆ (9/10)
**Tablica prawdy:** ✅ — alternatywa: widok zamiast pojazdów pokazuje `koszty_pojazdow` z prostszego widoku

### 💡 Cięcie 5: HACCP wycofania partii + recall
**Opis:** Usunąć `wycofania_partii`, procedurę `sp_wycofaj_partie_z_recall`, sekwencję recall.
**Mocne strony:** -1 tabela, -1 procedura, prostsze demo
**Słabe strony:** Tracimy "wow factor" — ale przekombinowane
**Ocena:** ⭐⭐⭐⭐⭐⭐⭐⭐☆☆ (8/10)
**Tablica prawdy:** ✅

### 💡 Cięcie 6: Wielomagazynowość + lokalizacje + paletowanie
**Opis:** Wytnij `magazyny`, `strefy_magazynowe`, `lokalizacje`. Zostawić tylko `partie` + `stany_magazynowe` z prostą kolumną `typ_strefy` na partii.
**Mocne strony:** -3 tabele, -1 trigger HACCP
**Słabe strony:** Tracimy realizm WMS
**Ocena:** ⭐⭐⭐⭐⭐⭐⭐☆☆☆ (7/10) — ale Cięcie 6b lepsze

### 💡 Cięcie 6b: 1 magazyn, 1 strefa default
**Opis:** Zostawić `strefy_magazynowe` (3 wpisy seed: Suchy/Chłodniczy/Mroźniczy) jako słownik, ale wytnij `magazyny`, `lokalizacje` (partia → strefa bezpośrednio).
**Mocne strony:** -2 tabele, ale zachowuje sens HACCP
**Słabe strony:** Brak partii w konkretnym miejscu (ale dla demo FEFO wystarczy)
**Ocena:** ⭐⭐⭐⭐⭐⭐⭐⭐⭐☆ (9/10) — kompromis
**Tablica prawdy:** ✅

### 💡 Cięcie 7: Stawki VAT jako słownik + segmenty klientów
**Opis:** Usunąć tabele `stawki_vat`, `segmenty_klientow`. VAT jako kolumna w `kategorie_produktow` (NUMBER), segment jako kolumna VARCHAR2 w `klienci`.
**Mocne strony:** -2 tabele, -2 FK, prostszy join
**Słabe strony:** Brak historii VAT — ale w 6-msc projekcie i tak nie ma zmiany
**Ocena:** ⭐⭐⭐⭐⭐⭐⭐⭐⭐☆ (9/10)
**Tablica prawdy:** ✅

### 💡 Cięcie 8: Procedury PL/SQL z 11 → 4
**Opis:** Zostaw tylko: `sp_zarejestruj_zamowienie`, `sp_dodaj_pozycje_zamowienia` (z freeze ceny + VAT), `sp_anuluj_zamowienie`, `sp_raport_top_klienci` (z kursorem). Wytnij `sp_wystaw_fakture`, `sp_wystaw_korekte`, `sp_wycofaj_partie_z_recall`, `sp_zaplanuj_trase`, `sp_inwentaryzacja_oracle`, `sp_log_event`, `sp_merge_produkty_cache` (zostawić jako standalone), `fn_pobierz_aktualna_cena`.
**Mocne strony:** -7 procedur, -200 linii
**Słabe strony:** Mniej demo material
**Ocena:** ⭐⭐⭐⭐⭐⭐⭐⭐⭐☆ (9/10) — 4 procedury wystarczą + 1 z kursorem + 1 z exception
**Tablica prawdy:** ✅

---

## FAZA 3: Matryca cięć

| Cięcie | Tabele - | Procedury - | Linie - | Ocena | Decyzja |
|---|---:|---:|---:|:---:|:---:|
| 1. Temporal/audit | -4 | -0 (triggery) | -80 | 10/10 | ✅ TNĘ |
| 2. Korekty/zwroty | -3 | -1 | -100 | 9/10 | ✅ TNĘ |
| 3. Saga DTC | 0 | -1 | -50 | 9/10 | ✅ TNĘ |
| 4. Pojazdy/trasy | -3 | -1 | -120 | 9/10 | ✅ TNĘ |
| 5. HACCP recall | -1 | -1 | -80 | 8/10 | ✅ TNĘ |
| 6b. Wielomag (1 magazyn) | -2 | -0 | -60 | 9/10 | ✅ TNĘ |
| 7. VAT/segmenty słowniki | -2 | -0 | -40 | 9/10 | ✅ TNĘ |
| 8. PL/SQL 11→4 | 0 | -7 | -200 | 9/10 | ✅ TNĘ |
| **RAZEM** | **-15** | **-11** | **-730** | | |

**Bilans:** 42 tabele - 15 = **~27 tabel**. To wciąż za dużo. Trzeba pójść głębiej.

---

## FAZA 3b: Dodatkowe cięcia (ostre)

### 💡 Cięcie 9: faktury → wytnij całkowicie
**Opis:** Status zamówienia `Zafakturowane` istnieje, ale brak osobnej tabeli `faktury`. Demo: pokaż "fakturę" jako widok agregujący `zamowienia + pozycje`.
**Mocne strony:** -1 tabela, -1 typ dokumentu
**Słabe strony:** Brak osobnego numerowania FV
**Ocena:** ⭐⭐⭐⭐⭐⭐⭐⭐☆☆ (8/10) — kompromis
**Tablica prawdy:** ✅

### 💡 Cięcie 10: archiwum 3 tabele → 1
**Opis:** Tylko `zamowienia_archiwum` (denormalizowana, zawiera już dane klienta i sumę). Bez `pozycje_zamowien_archiwum`, bez `faktury_archiwum`.
**Mocne strony:** -2 tabele
**Słabe strony:** Mniej szczegółu w archiwum — ale to ARCHIWUM, kto pyta o pozycje sprzed 2 lat
**Ocena:** ⭐⭐⭐⭐⭐⭐⭐⭐⭐☆ (9/10)
**Tablica prawdy:** ✅

### 💡 Cięcie 11: Finanse 2 → 1
**Opis:** Tylko `oplaty_serwisowe` (połącz `oplaty_serwisowe` + `koszty_pojazdow` w jedną tabelę z kolumną `typ_kosztu`).
**Mocne strony:** -1 tabela
**Ocena:** ⭐⭐⭐⭐⭐⭐⭐⭐⭐☆ (9/10)
**Tablica prawdy:** ✅ — link prywatny nadal sensowny: "Działy finanse mają osobny schemat z osobnym dostępem"

### 💡 Cięcie 12: liczniki_dokumentow → SEQUENCE Oracle / IDENTITY MSSQL
**Opis:** Wytnij tabelę `liczniki_dokumentow` i procedurę `sp_nastepny_numer_dokumentu`. Numer dokumentu = `'PO' || TO_CHAR(seq.nextval, 'FM0000000000')`. Akceptujemy luki w numeracji (nie księgowo bezpieczne, ale demo).
**Mocne strony:** -1 tabela, -1 procedura, -30 linii
**Słabe strony:** Brak "księgowo bezpiecznych" numerów
**Ocena:** ⭐⭐⭐⭐⭐⭐⭐⭐☆☆ (8/10)
**Tablica prawdy:** ✅ — zaznaczam w ograniczeniach MVP

### 💡 Cięcie 13: Excel wytnij, zostaw Access
**Opis:** Wymagane są 4 typy OPENROWSET (SQLServer, Oracle, Access, Excel) i 4 typy linked server. Jeśli wytnę Excel — nie spełnię wymagania. **NIE TNĘ.**
**Decyzja:** ❌ ZOSTAWIAM (constraint p.2 i p.3)

### 💡 Cięcie 14: Wielodostęp tylko 2 źródła
**Opis:** Widok `vw_porownanie_cen_zakup_vs_sprzedaz` używał 3 źródeł (Excel + MSSQL local + Oracle). Uprość do 2 (Excel + Oracle, bez MSSQL local cennika).
**Mocne strony:** Prostszy widok
**Słabe strony:** Mniej "wow" — ale wymaganie p.2 mówi tylko "wielodostęp", nie "3 źródła"
**Ocena:** ⭐⭐⭐⭐⭐⭐⭐⭐☆☆ (8/10)
**Tablica prawdy:** ✅

---

## FAZA 4: Finalny bilans tabel

| Baza | Tabele | Lista |
|---|---:|---|
| MSSQL#1 HQ | **5** | kraje, kategorie_produktow (z `stawka_vat`), produkty, dostawcy, cenniki_zakupowe |
| MSSQL#2 Magazyn | **4** | produkty (replika RO), strefy_magazynowe, partie, stany_magazynowe |
| Oracle HIDPPS_SPRZEDAZ | **5** | klienci (z `segment` VARCHAR2), adresy_dostaw, produkty_cache, cenniki_sprzedazowe, zamowienia, pozycje_zamowien |
| Oracle HIDPPS_ARCHIWUM | **1** | zamowienia_archiwum |
| Oracle HIDPPS_FINANSE | **1** | oplaty_serwisowe |
| **RAZEM** | **~16 tabel** | (z replicą = 16) |

> ⚠️ Replika `produkty` w MSSQL#2 to ta sama tabela co w HQ — fizycznie 2 kopie, logicznie 1.

**Procedury Oracle:** 4 (rejestracja zam, dodaj pozycję, anuluj, raport top klientów).
**Procedury MSSQL:** 3 (FEFO rezerwacja, push do Oracle, zatwierdź zamówienie DTC).

---

## FAZA 5: Co zostaje z mechaniki RBD (mapowanie 13 wymagań)

| # | Wymaganie | Realizacja (uproszczona) | Status |
|---|---|---|:---:|
| 1 | Struktura RBD + uzasadnienie | Podział funkcjonalny HQ/Mag/Sprz (krótsze uzasadnienie 1 strona) | ✅ |
| 2 | OPENROWSET 4 typy + wielodostęp | 4 typy zapytań ad-hoc + 1 widok wielodostępny 2-źródłowy (Excel + Oracle przez OPENQUERY) | ✅ |
| 3 | Linked Servers 4 typy + mapowanie | 5 linked serverów + 1 mapowanie loginu na `SRV_ORACLE` | ✅ |
| 4 | OPENQUERY pass-through | `sp_raport_top_klienci_oracle` + użycie w widoku wielodostępnym | ✅ |
| 5 | INSERT/UPDATE zdalne | `sp_push_produkty_to_oracle` (INSERT staging + EXEC MERGE) | ✅ |
| 6 | MS DTC + konfiguracja | `sp_zatwierdz_zamowienie_dtc` (1 scenariusz cross-platform) + 1 strona konfiguracji MSDTC + OraMTS | ✅ |
| 7 | Replikacja | 1× transakcyjna (produkty HQ→Mag) + 1× migawkowa (cenniki HQ→Mag nocą) | ✅ |
| 8 | Oracle użytkownicy/role | 3 role (read, write, admin) + 3 użytkowników (uproszczone z 5+5) | ✅ |
| 9 | DB linki publiczne + prywatne | 1× public (`lnk_pub_archiwum`) + 1× private (`lnk_priv_finanse`) | ✅ |
| 10 | Symulacja zdalnych źródeł przez DB link | 2 dodatkowe schematy Oracle (ARCHIWUM, FINANSE) | ✅ |
| 11 | Widoki rozproszone + rzutowanie | `vw_wszystkie_zamowienia` (UNION sprzedaż + archiwum z CAST) | ✅ |
| 12 | INSTEAD OF triggery | 1 trigger `trg_vw_wszystkie_zamowienia_ins` (router po dacie) | ✅ |
| 13 | Procedury PL/SQL | Pakiet `PKG_HIDPPS_SPRZEDAZ` z 4 procedurami (jedna z kursorem, jedna z exception) | ✅ |

**Wszystkie 13 wymagań spełnione.** Bez overengineeringu.

---

## FAZA 6: Rekomendacja

### 🏆 Plan implementacji

**Krok 1:** Backup `RBZ/PROJEKT/HiDPPS.md` → `HiDPPS_v1_full.md` (zachowanie wersji rozbudowanej, ~1500 linii — dla referencji jeśli prowadzący zapyta o "rozszerzenie").

**Krok 2:** Napisz `RBZ/PROJEKT/HiDPPS.md` od nowa, ~600 linii:
- Sekcja 1: Streszczenie (1 strona)
- Sekcja 2: Architektura (1 diagram + macierz 13 wymagań)
- Sekcja 3: DDL MSSQL#1 (5 tabel, ~80 linii)
- Sekcja 4: DDL MSSQL#2 (4 tabele, ~60 linii)
- Sekcja 5: DDL Oracle (7 tabel, ~120 linii)
- Sekcja 6: Access + Excel (krótkie opisy)
- Sekcja 7: Linked Servers (5 sztuk, ~60 linii)
- Sekcja 8: OPENROWSET (4 zapytania + 1 widok wielodostępny, ~80 linii)
- Sekcja 9: OPENQUERY (1 procedura, ~30 linii)
- Sekcja 10: INSERT/UPDATE zdalne (1 procedura push, ~40 linii)
- Sekcja 11: MS DTC (1 scenariusz + konfiguracja, ~80 linii)
- Sekcja 12: Replikacja (krótko, ~40 linii)
- Sekcja 13: Oracle role/user (3+3, ~30 linii)
- Sekcja 14: DB linki (2 sztuki, ~20 linii)
- Sekcja 15: Widok rozproszony + INSTEAD OF (~50 linii)
- Sekcja 16: Pakiet PL/SQL (4 procedury, ~120 linii)
- Sekcja 17: Wnioski + ograniczenia MVP (~30 linii)

**Krok 3:** Sprawdzić macierz 13 wymagań → wszystko ma realizację.

**Krok 4:** Wytnąć diagramy mermaid uproszczone (1 architektura + 1 ER per baza + 1 sequence DTC).

### Dlaczego ten plan?

- **Pełne 13 wymagań** — nic nie tracimy z punktu widzenia oceny
- **~600 linii** zamiast 1500 = łatwiej obronić ustnie
- **~16 tabel** zamiast 42 = realne dla projektu semestralnego
- **4 procedury PL/SQL** zamiast 11 = ale 1 z kursorem + 1 z exception (wystarczy)
- **1 scenariusz DTC** zamiast 4 = wystarczy demo `BEGIN DISTRIBUTED TRANSACTION`
- **Brak audit/recall/korekt** = mniej rzeczy do tłumaczenia prowadzącemu

---

## FAZA 7: Ograniczenia MVP (jawnie poza zakresem — sekcja w finale)

- Brak temporal tables / audit history
- Brak faktur korygujących (model: 1 zamówienie = 1 faktura jako widok)
- Brak Saga Pattern (DTC zakłada że OraMTS działa)
- Brak modelu logistyki (pojazdy, trasy)
- Brak HACCP recall procedury (zachowujemy CHECK na strefę)
- Brak wielomagazynowości (1 magazyn placeholder)
- Numery dokumentów z luki (SEQUENCE Oracle / IDENTITY MSSQL — nie księgowo bezpieczne)

Wszystkie pominięcia mają jasne uzasadnienie: **scope semestralny vs. korporacyjny**.

---

**Koniec brainstormu.**
