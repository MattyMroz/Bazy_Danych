# 🎼 SZKOŁA MUZYCZNA - ZAŁOŻENIA PROJEKTOWE (UPROSZCZONE)

## Wersja 7.0 | Luty 2026
## Autorzy: Igor Typiński (251237), Mateusz Mróz (251190)

---

# 1. CEL PROJEKTU

Obiektowa baza danych dla **małej szkoły muzycznej I stopnia** z naciskiem na:
- Typy obiektowe z metodami
- Referencje (REF) między obiektami
- **1 VARRAY** (wyposażenie sali)
- **Heurystyka** automatycznego planowania lekcji
- Pakiety PL/SQL z procedurami/funkcjami

---

# 2. UPROSZCZENIA (ŚWIADOME DECYZJE)

| Co pomijamy | Powód |
|-------------|-------|
| Różny czas lekcji wg klasy | Stały czas 45 min dla wszystkich |
| Chór i Orkiestra | Komplikuje planowanie |
| Rytmika i Audycje | Tylko kształcenie słuchu jako grupowe |
| Obszary ocen | Tylko wartość 1-6 |
| Limity godzin nauczyciela | Komplikuje |
| Walidacja wyposażenia sali | Upraszczamy |

**Zostaje rdzeń**: uczniowie, nauczyciele, sale, lekcje (indywidualne + grupowe), oceny.

---

# 3. STRUKTURA SZKOŁY

## 3.1 Uczniowie (~24 uczniów)

| Klasa | Grupa | Uczniów | Instrument |
|-------|-------|---------|------------|
| I | 1A | 5 | 2×fortepian, 1×skrzypce, 1×gitara, 1×flet |
| II | 2A | 5 | 2×fortepian, 1×skrzypce, 1×gitara, 1×flet |
| III | 3A | 4 | 1×fortepian, 1×skrzypce, 1×gitara, 1×flet |
| IV | 4A | 4 | 1×fortepian, 1×skrzypce, 1×gitara, 1×flet |
| V | 5A | 3 | 1×fortepian, 1×skrzypce, 1×gitara |
| VI | 6A | 3 | 1×fortepian, 1×skrzypce, 1×gitara |
| **RAZEM** | **6 grup** | **24** | F:8, S:6, G:6, Fl:4 |

## 3.2 Nauczyciele (6 osób)

| Nazwisko | Uczy instrumentu | Uczy też |
|----------|------------------|----------|
| Kowalska | Fortepian | Kształcenie słuchu |
| Nowak | Fortepian | - |
| Wiśniewski | Skrzypce | - |
| Lewandowski | Gitara | Kształcenie słuchu |
| Zielińska | Flet | - |
| Jankowska | - | Kształcenie słuchu |

## 3.3 Sale (4 sale)

| Nr | Typ | Pojemność | Wyposażenie (VARRAY) |
|----|-----|-----------|----------------------|
| 101 | indywidualna | 3 | fortepian |
| 102 | indywidualna | 3 | pianino, pulpit |
| 103 | indywidualna | 3 | gitara |
| 201 | grupowa | 15 | tablica, pianino |

## 3.4 Przedmioty (5 przedmiotów)

| Przedmiot | Typ | Czas |
|-----------|-----|------|
| Fortepian | indywidualny | 45 min |
| Skrzypce | indywidualny | 45 min |
| Gitara | indywidualny | 45 min |
| Flet | indywidualny | 45 min |
| Kształcenie słuchu | grupowy | 45 min |

---

# 4. REGUŁY BIZNESOWE

## 4.1 Lekcje

1. Każdy uczeń ma **2 lekcje instrumentu tygodniowo** (indywidualne, 45 min).
2. Każda grupa ma **1 lekcję kształcenia słuchu tygodniowo** (grupowe, 45 min).
3. Lekcja jest **ALBO indywidualna ALBO grupowa** (XOR).
4. Godziny pracy: **14:00 - 20:00**, dni: **pon-pt**.
5. Brak konfliktów: sala/nauczyciel/uczeń w tym samym czasie.

## 4.2 Oceny

1. Skala: **1-6**.
2. Ocena bieżąca lub semestralna (flaga T/N).
3. Powiązana z uczniem, nauczycielem, przedmiotem.

---

# 5. STRUKTURA BAZY DANYCH

## 5.1 Tabele (6 tabel)

| # | Tabela | Opis | Rekordów |
|---|--------|------|----------|
| 1 | PRZEDMIOTY | słownik zajęć | 5 |
| 2 | NAUCZYCIELE | kadra | 6 |
| 3 | GRUPY | klasy | 6 |
| 4 | SALE | pomieszczenia + **VARRAY wyposażenia** | 4 |
| 5 | UCZNIOWIE | uczniowie + REF do grupy | 24 |
| 6 | LEKCJE | harmonogram + REF | ~60/tydzień |
| 7 | OCENY | oceny + REF | ~50/semestr |

## 5.2 Typy obiektowe (7 typów)

| Typ | Opis | Metody |
|-----|------|--------|
| T_WYPOSAZENIE | VARRAY(10) VARCHAR2(50) | - |
| T_PRZEDMIOT | przedmiot | czy_grupowy() |
| T_NAUCZYCIEL | nauczyciel | pelne_nazwisko() |
| T_GRUPA | grupa/klasa | - |
| T_SALA | sala + VARRAY | czy_grupowa() |
| T_UCZEN | uczeń + REF grupa | pelne_nazwisko(), wiek() |
| T_LEKCJA | lekcja + REF | godzina_koniec(), czy_indywidualna() |
| T_OCENA | ocena + REF | opis_oceny() |

## 5.3 Relacje (REF)

```
PRZEDMIOTY ←── REF ── LEKCJE ── REF ──→ NAUCZYCIELE
                         │
                         ├── REF ──→ SALE
                         │
                         ├── REF ──→ UCZNIOWIE (indywidualne)
                         │
                         └── REF ──→ GRUPY (grupowe)

UCZNIOWIE ── REF ──→ GRUPY

OCENY ── REF ──→ UCZNIOWIE
      ── REF ──→ NAUCZYCIELE  
      ── REF ──→ PRZEDMIOTY
```

---

# 6. PAKIETY PL/SQL

## 6.1 PKG_SLOWNIKI
- `dodaj_przedmiot()` - dodaje przedmiot
- `dodaj_sale()` - dodaje salę z wyposażeniem (VARRAY)
- `dodaj_grupe()` - dodaje grupę
- `get_ref_*()` - pobiera referencje

## 6.2 PKG_OSOBY
- `dodaj_nauczyciela()` - dodaje nauczyciela
- `dodaj_ucznia()` - dodaje ucznia do grupy
- `lista_uczniow_w_grupie()` - wyświetla uczniów grupy
- `lista_uczniow_nauczyciela()` - wyświetla uczniów nauczyciela

## 6.3 PKG_LEKCJE
- `dodaj_lekcje_indywidualna()` - ręczne dodanie lekcji
- `dodaj_lekcje_grupowa()` - ręczne dodanie lekcji grupowej
- `czy_sala_wolna()` - sprawdza dostępność sali
- `czy_nauczyciel_wolny()` - sprawdza dostępność nauczyciela
- `czy_uczen_wolny()` - sprawdza dostępność ucznia
- **`znajdz_nauczyciela()`** - **HEURYSTYKA** - znajduje wolnego nauczyciela
- **`przydziel_lekcje_uczniowi()`** - **HEURYSTYKA** - automatycznie przydziela 2 lekcje
- **`generuj_plan_tygodnia()`** - generuje cały plan
- `plan_ucznia()` - wyświetla plan ucznia
- `plan_nauczyciela()` - wyświetla plan nauczyciela
- `plan_grupy()` - wyświetla plan grupy
- `plan_sali()` - wyświetla obłożenie sali

## 6.4 PKG_OCENY
- `wystaw_ocene()` - wystawia ocenę bieżącą
- `wystaw_ocene_semestralna()` - wystawia ocenę semestralną
- `oceny_ucznia()` - wyświetla wszystkie oceny ucznia
- `srednia_ucznia()` - oblicza średnią ucznia z przedmiotu

## 6.5 PKG_RAPORTY
- `raport_grup()` - ile uczniów w każdej grupie
- `raport_nauczycieli()` - lista nauczycieli z przedmiotami
- `statystyki_lekcji()` - ile lekcji w systemie

---

# 7. TRIGGERY (MINIMALNE)

| Trigger | Tabela | Walidacja |
|---------|--------|-----------|
| trg_ocena_zakres | OCENY | Ocena 1-6 |
| trg_lekcja_xor | LEKCJE | XOR uczeń/grupa |
| trg_czas_trwania | LEKCJE | Czas 30/45/60/90 min |

**Pozostałe walidacje w pakietach** (nie w triggerach).

---

# 8. HEURYSTYKA PLANOWANIA

## Algorytm `przydziel_lekcje_uczniowi()`:

```
1. Pobierz instrument ucznia
2. Znajdź nauczyciela który uczy tego instrumentu
3. Dla każdego dnia tygodnia:
   a. Dla każdego slotu czasowego (14:00, 15:00, 16:00...):
      - Sprawdź czy nauczyciel wolny
      - Sprawdź czy jakaś sala indywidualna wolna
      - Sprawdź czy uczeń wolny
      - Jeśli wszystko OK → przydziel lekcję
4. Powtórz dla drugiej lekcji (inny dzień)
5. Jeśli nie da się przydzielić → błąd
```

## Algorytm `generuj_plan_tygodnia()`:

```
KROK 1: Lekcje grupowe (kształcenie słuchu)
- Dla każdej grupy przydziel 1 slot w sali grupowej
- Każda grupa w innym dniu/godzinie

KROK 2: Lekcje indywidualne
- Dla każdego ucznia wywołaj przydziel_lekcje_uczniowi()
- System automatycznie znajdzie wolne sloty
```

---

# 9. SCENARIUSZE UŻYCIA (DO DEMONSTRACJI)

## Scenariusz 1: Nowy uczeń zapisuje się do szkoły
```sql
-- Jan Kowalski, 7 lat, fortepian, klasa 1A
EXEC PKG_OSOBY.dodaj_ucznia('Jan', 'Kowalski', DATE '2019-03-15', '1A', 'Fortepian');

-- System automatycznie przydziela mu lekcje
EXEC PKG_LEKCJE.przydziel_lekcje_uczniowi('Kowalski', 'Jan', DATE '2026-02-02');

-- Sprawdzamy jego plan
EXEC PKG_LEKCJE.plan_ucznia('Kowalski', 'Jan');
```

## Scenariusz 2: Nauczyciel wystawia oceny
```sql
-- Pani Kowalska wystawia ocenę Janowi z fortepianu
EXEC PKG_OCENY.wystaw_ocene('Kowalski', 'Jan', 'Kowalska', 'Fortepian', 4);
EXEC PKG_OCENY.wystaw_ocene('Kowalski', 'Jan', 'Kowalska', 'Fortepian', 5);

-- Sprawdzamy oceny i średnią
EXEC PKG_OCENY.oceny_ucznia('Kowalski', 'Jan');
SELECT PKG_OCENY.srednia_ucznia('Kowalski', 'Jan', 'Fortepian') FROM DUAL;
```

## Scenariusz 3: Nowy nauczyciel dołącza do szkoły
```sql
-- Nowy nauczyciel gitary
EXEC PKG_OSOBY.dodaj_nauczyciela('Adam', 'Nowy', 'Gitara');

-- Generujemy plan na nowy tydzień - system wykorzysta nowego nauczyciela
EXEC PKG_LEKCJE.generuj_plan_tygodnia(DATE '2026-02-09');

-- Sprawdzamy jego plan
EXEC PKG_LEKCJE.plan_nauczyciela('Nowy');
```

## Scenariusz 4: Konflikt - próba dodania lekcji gdy sala zajęta
```sql
-- Próba dodania lekcji gdy sala jest zajęta
-- System powinien zgłosić błąd
EXEC PKG_LEKCJE.dodaj_lekcje_indywidualna(
    'Fortepian', 'Kowalska', '101',
    'Kowalski', 'Jan',
    DATE '2026-02-02', '14:00', 45
);
-- ORA-20010: Sala 101 zajęta w tym terminie
```

## Scenariusz 5: Raport obłożenia szkoły
```sql
-- Ile uczniów w każdej grupie
EXEC PKG_RAPORTY.raport_grup();

-- Ile lekcji ma każdy nauczyciel
EXEC PKG_RAPORTY.raport_nauczycieli();

-- Statystyki lekcji
EXEC PKG_RAPORTY.statystyki_lekcji();
```

---

# 10. DIAGRAM RELACJI OBIEKTÓW

```
┌─────────────┐
│ PRZEDMIOTY  │◄────────────────────────────────┐
│ (słownik)   │                                 │
└─────────────┘                                 │
                                                │ REF
┌─────────────┐         ┌─────────────┐         │
│ NAUCZYCIELE │◄───REF──│   LEKCJE    │─────────┤
└─────────────┘         │             │         │
       ▲                │ (XOR)       │         │
       │                │ ┌─────────┐ │         │
       │ REF            │ │indywid. │ │─REF─►UCZNIOWIE
       │                │ └─────────┘ │              │
       │                │ ┌─────────┐ │              │
       │                │ │grupowa  │ │─REF─►GRUPY◄──┘
┌──────┴──────┐         │ └─────────┘ │              REF
│   OCENY     │         └──────┬──────┘
│             │                │
└─────────────┘                │ REF
       │                       ▼
       │ REF            ┌─────────────┐
       └───────────────►│    SALE     │
                        │ (VARRAY     │
                        │ wyposażenia)│
                        └─────────────┘
```

---

# 11. WYMAGANIA TECHNICZNE

## Spełnione wymagania projektu:

| Wymaganie | Realizacja |
|-----------|------------|
| Typy obiektowe z metodami | T_UCZEN.wiek(), T_LEKCJA.godzina_koniec() |
| Tabele obiektowe | Wszystkie 7 tabel |
| REF i DEREF | Lekcje → Sala, Uczeń → Grupa, Ocena → Uczeń |
| VARRAY | T_WYPOSAZENIE w tabeli SALE |
| Pakiety PL/SQL | 5 pakietów |
| Procedury/funkcje | ~25 procedur/funkcji |
| Kursory | W funkcjach plan_*, lista_* |
| REF CURSOR | Zwracanie wyników z procedur |
| Obsługa błędów | RAISE_APPLICATION_ERROR |
| Triggery | 3 podstawowe triggery |
| Heurystyka | znajdz_nauczyciela(), przydziel_lekcje_uczniowi() |

---

*Wersja: 7.0 (uproszczona) | Luty 2026*
*Autorzy: Igor Typiński (251237), Mateusz Mróz (251190)*
