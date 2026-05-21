# 📋 SUMMARY: HiDPPS — Rozproszona Baza Danych dla Hurtowni Spożywczej

> **Źródło:** `BRAINSTORM_HIDPPS_RBD.md`
> **Data:** 2026-05-21 | **Tryb:** big brainstorm
> **Autorzy projektu:** Mateusz Mróz (251190), Maciej Górka (251143)

## TL;DR

Wybrano architekturę **P5** (najwyższa ocena 10/10): podział funkcjonalny na **3 serwery** — MSSQL#1 jako *HQ-Master* (katalog produktów, dostawcy, cenniki), MSSQL#2 jako *Magazyn-Operacje* (partie, stany, FEFO, recall), Oracle jako *Dystrybucja-Klienci* (zamówienia, faktury, kierowcy, archiwum), uzupełnione o **Access** (offline orders przedstawiciela) i **Excel** (cenniki dostawców) jako zewnętrzne źródła. Architektura pokrywa **wszystkie 13 wymagań projektowych** z naturalnymi biznesowymi scenariuszami (FEFO, recall HACCP, rezerwacja DTC, replikacja katalogu, INSTEAD OF trigger na widoku rozproszonym Oracle).

## Rekomendacja

**Pomysł 5: HQ-Master / Magazyn-Operacje / Oracle-Dystrybucja** — uzasadnienie: mapuje realny łańcuch dostaw spożywki, daje 2 silne use cases MS DTC, używa 2 typów replikacji (transakcyjna + migawkowa), wszystkie 4 typy linked serverów (MSSQL/Oracle/Access/Excel), Oracle DB links prywatny + publiczny + symulacja "drugiej instancji" drugim schematem (archiwum). Plan B: P1 (uproszczona wersja bez archiwum Oracle i bez recall).

## Kluczowe Insights

1. **Heterogeniczność musi mieć biznesowe uzasadnienie** — Oracle dla CRM/Dystrybucji jest realnym choice
2. **Specyfika spożywki = bogactwo edge cases** — FEFO, partie, recall, łańcuch chłodniczy
3. **Symulacja drugiej instancji Oracle drugim schematem** — standard akademicki, wymaga jawnej dokumentacji
4. **MS DTC ma 2 silne use cases** — rezerwacja partii + wydanie z fakturą (nie wymyślamy na siłę)
5. **Wszystkie 13 punktów wymagań pokryte** — macierz mechanizmów potwierdzona

## 📊 Architektura w skrócie

| Element | Wartość |
|---------|---------|
| Liczba serwerów | 3 (2× MSSQL + 1× Oracle) + 2 źródła zewnętrzne (Access, Excel) |
| Łączna liczba tabel | ~41 (HQ: 14, Magazyn: 12, Oracle: 15) |
| Liczba procedur | 17+ (MSSQL#1: 6, MSSQL#2: 5, Oracle pakiet: 6+1 funkcja) |
| Liczba widoków | 9 (3 per baza) — w tym widoki rozproszone Oracle z INSTEAD OF |
| Linked Servers | 5 (SRV_HQ, SRV_MAGAZYN, SRV_ORACLE, SRV_ACCESS_REP, SRV_EXCEL_CENNIKI) |
| Replikacja | Transakcyjna (katalog produktów) + Migawkowa (cenniki nocne) |
| MS DTC scenariusze | 2 (rezerwacja FEFO, wydanie+faktura) |
| Oracle DB links | 2 publiczne + 1 prywatny |
| Role Oracle | 5 (KLIENCI, FINANSE, LOGISTYKA, OBSLUGA, RAPORTY_BI) |

## 📝 Lista Zadań (Actionable Steps)

### Priorytet: 🔴 KRYTYCZNY

- [ ] **Krok 1:** Subagent Opus #2 — review brainstormu HiDPPS pod kątem luk logicznych → **Rezultat:** lista 5-15 znalezionych luk z propozycjami fix
- [ ] **Krok 2:** Implementacja poprawek z reviewa → **Rezultat:** v2 brainstormu / decyzje zaktualizowane
- [ ] **Krok 3:** Subagent Opus #3 — final audit 100/100 → **Rezultat:** confirmation lub ostatnia lista poprawek
- [ ] **Krok 4:** Napisanie `HiDPPS.md` (raport finalny w Markdown) — sekcje 1-13 + diagramy Mermaid → **Rezultat:** kompletny raport gotowy do oddania

### Priorytet: 🟡 WYSOKI

- [ ] **Krok 5:** HITL po każdej fazie z Mateuszem (review architektury, review listy tabel, review procedur)
- [ ] **Krok 6:** Walidacja diagramów Mermaid (czy renderują się w GitHub/VS Code Markdown preview)
- [ ] **Krok 7:** Dodanie sekcji "Edge Cases" do HiDPPS.md z 20+ scenariuszami i odpowiedziami

### Priorytet: 🟢 NORMALNY

- [ ] **Krok 8:** Rozważyć dodanie 4-5 przykładowych zapytań SQL (DML, widoki, OPENROWSET, OPENQUERY, DTC) jako dowód działania
- [ ] **Krok 9:** Spis treści + nagłówki rozdziałów dokumentu zgodne ze strukturą wymaganą przez prowadzącego (rozdziały 1-13 + wnioski)

## Ryzyka do monitorowania

| Ryzyko | Trigger | Akcja |
|--------|---------|-------|
| Liczba tabel > 50 | Po pierwszym draft HiDPPS.md | Konsolidacja słowników, usunięcie nice-to-have |
| MS DTC complexity | Pytanie prowadzącego o testowanie | Wzmianka: scenariusze opisane teoretycznie; konfiguracja MS DTC opisana krok-po-kroku |
| Oracle DB links wymagają TNS | Implementacja | Dokumentacja TNS dla 2 schematów = symulacja 2 instancji |
| Replikacja Publisher wymaga SA | Implementacja | Plan B: snapshot zamiast transakcyjnej, lub dokumentacja "co byłoby zrobione" |

## Otwarte pytania (do HITL)

- ❓ Czy walutę uwzględniamy (rekomendacja: tylko PLN, ale tabelę walut zostawiamy)
- ❓ Czy modelujemy VAT 5/8/23% (rekomendacja: TAK, kolumna stawka_vat w produkcie)
- ❓ Czy modelujemy łańcuch chłodniczy z pomiarami temperatur (rekomendacja: NIE, tylko typ_chlodzenia pojazdu)
- ❓ Czy dodajemy replikację merge dla wzbogacenia (rekomendacja: NIE — komplikacja, transakcyjna+migawkowa wystarczy)
- ❓ Czy modelujemy pełny audit HACCP (rekomendacja: NIE, tylko certyfikaty dostawców + recall jako event)
