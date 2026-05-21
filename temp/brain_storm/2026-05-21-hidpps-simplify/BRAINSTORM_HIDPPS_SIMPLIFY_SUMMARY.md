# 📋 SUMMARY: Uproszczenie HiDPPS

> **Źródło:** [BRAINSTORM_HIDPPS_SIMPLIFY.md](BRAINSTORM_HIDPPS_SIMPLIFY.md)
> **Data:** 2026-05-21 | **Tryb:** small

## TL;DR

HiDPPS v1 (1500 linii, 42 tabele, 11 procedur PL/SQL) jest przekombinowany jak na projekt RBD semestralny. Cięcie 14 obszarów (audit/korekty/saga/pojazdy/recall/wielomagazyn/słowniki VAT/sekwencje liczników) sprowadza do **~16 tabel, ~600 linii, 4 procedury PL/SQL** — przy zachowaniu **wszystkich 13 wymagań** z [Projekt.md](../../../RBZ/PROJEKT/Projekt.md).

## Rekomendacja

**Przepisz [HiDPPS.md](../../../RBZ/PROJEKT/HiDPPS.md) od zera** wg planu cięcia. Zachowaj v1 jako `HiDPPS_v1_full.md` (referencja).

## Kluczowe Insights

1. **13 wymagań ≠ 42 tabele** — każde wymaganie da się pokryć minimalną liczbą obiektów
2. **Brak audit / korekt / sagi** = -10 tabel, -5 procedur, zero strat ocenowych
3. **VAT i segmenty jako kolumny zamiast słowników** = -2 tabele, prostsze joiny
4. **1 scenariusz DTC wystarczy** — demo `BEGIN DISTRIBUTED TRANSACTION` cross-platform Oracle+MSSQL

## 📝 Lista Zadań

### Priorytet: 🔴 KRYTYCZNY
- [ ] **Krok 1:** Backup obecnego `RBZ/PROJEKT/HiDPPS.md` → `RBZ/PROJEKT/HiDPPS_v1_full.md` → **Rezultat:** zachowana wersja rozbudowana
- [ ] **Krok 2:** Napisz nowy `RBZ/PROJEKT/HiDPPS.md` (~600 linii, 17 sekcji wg planu §6) → **Rezultat:** uproszczony dokument projektowy

### Priorytet: 🟡 WYSOKI
- [ ] **Krok 3:** Weryfikuj macierzą 13 wymagań — każde ma realizację → **Rezultat:** checklista 13/13 ✅
- [ ] **Krok 4:** 3 diagramy Mermaid (architektura + ER per baza + sequence DTC) → **Rezultat:** czytelna wizualizacja

### Priorytet: 🟢 NORMALNY
- [ ] **Krok 5:** Sekcja "Ograniczenia MVP" — jasne uzasadnienia każdego pominięcia → **Rezultat:** obrona przed pytaniami prowadzącego

## Ryzyka

| Ryzyko | Trigger | Akcja |
|---|---|---|
| Prowadzący chce więcej tabel | Pytanie na obronie | Pokaż HiDPPS_v1_full.md jako "rozszerzenie" |
| Brak audit przeszkadza | Pytanie o historię zmian | Wzmianka w "Ograniczenia MVP" + szybki dodatek 1 history table |
| 1 scenariusz DTC za mało | Pytanie "ile transakcji rozproszonych" | Pokaż konfigurację + diagram sequence — sam mechanizm wystarczy |

## Otwarte pytania

- ❓ Czy zachowujemy mermaid w pełnej formie (3 diagramy), czy upraszczamy do 1?
- ❓ Czy seed data wchodzi w `HiDPPS.md`, czy osobny plik `seed.sql`?
