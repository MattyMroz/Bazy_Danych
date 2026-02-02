# 🎼 SZKOŁA MUZYCZNA I STOPNIA
## Założenia projektowe bazy danych

**Projekt:** Szkoła muzyczna I stopnia  
**Autorzy:** Igor Typiński (251237), Mateusz Mróz (251190)  
**Data:** Luty 2026

---

## 1. OPIS PROJEKTU

Obiektowa baza danych Oracle dla **szkoły muzycznej I stopnia**. System obsługuje:
- Ewidencję uczniów i nauczycieli
- Zarządzanie salami lekcyjnymi
- Planowanie lekcji (indywidualnych i grupowych)
- Ocenianie uczniów

**Zakres:** 3 klasy, 9 uczniów, 5 nauczycieli, 4 sale, 5 przedmiotów.

---

## 2. MODEL DANYCH

### 2.1 Typy obiektowe

| Typ | Atrybuty | Metody |
|-----|----------|--------|
| `t_wyposazenie` | VARRAY(10) VARCHAR2 | - |
| `t_przedmiot` | id, nazwa, typ, czas_min | `czy_grupowy()` |
| `t_grupa` | id, symbol, poziom | - |
| `t_nauczyciel` | id, imie, nazwisko, data_zatr, **REF→przedmiot** | `pelne_nazwisko()`, `staz_lat()` |
| `t_sala` | id, numer, typ, pojemnosc, **wyposazenie (VARRAY)** | `czy_grupowa()`, `lista_wyposazenia()` |
| `t_uczen` | id, imie, nazwisko, data_ur, instrument, **REF→grupa** | `pelne_nazwisko()`, `wiek()` |
| `t_lekcja` | id, **REF→przedmiot/nauczyciel/sala/uczen/grupa**, data, godz, czas | `godzina_koniec()`, `czy_indywidualna()` |
| `t_ocena` | id, **REF→uczen/nauczyciel/przedmiot**, wartosc, data, semestralna | `opis_oceny()` |

### 2.2 Relacje (REF)

```
PRZEDMIOTY ←───REF─── NAUCZYCIELE
     │
     └───REF───────── LEKCJE ───REF──→ NAUCZYCIELE
                        │
                        ├───REF──→ SALE (VARRAY wyposażenia)
                        │
                        └───REF──→ UCZNIOWIE ───REF──→ GRUPY
                              (XOR)
                              └───REF──→ GRUPY

OCENY ───REF──→ UCZNIOWIE, NAUCZYCIELE, PRZEDMIOTY
```

---

## 3. KLUCZOWE ELEMENTY PROJEKTU

### 3.1 REF (referencje obiektowe)
- **Nauczyciel → Przedmiot** - każdy nauczyciel uczy jednego przedmiotu
- **Uczeń → Grupa** - każdy uczeń należy do jednej klasy
- **Lekcja → Przedmiot, Nauczyciel, Sala, (Uczeń XOR Grupa)** - wielokrotne REF
- **Ocena → Uczeń, Nauczyciel, Przedmiot** - powiązanie oceny z podmiotami

### 3.2 VARRAY (kolekcja)
- **Wyposażenie sali** - VARRAY(10) elementów (np. instrumenty, meble)

### 3.3 Metody obiektowe
- `pelne_nazwisko()` - łączy imię i nazwisko
- `wiek()` / `staz_lat()` - oblicza lata od daty
- `czy_grupowy()` / `czy_grupowa()` / `czy_indywidualna()` - zwraca 'T'/'N'
- `lista_wyposazenia()` - formatuje VARRAY jako string
- `opis_oceny()` - słowny opis oceny (1=niedostateczny, 6=celujący)

### 3.4 XOR w lekcjach
Lekcja jest **albo** indywidualna (ref_uczen) **albo** grupowa (ref_grupa) - trigger `trg_lekcja_xor` wymusza tę regułę.

---

## 4. PAKIETY PL/SQL

| Pakiet | Funkcjonalność |
|--------|---------------|
| `pkg_slowniki` | Dodawanie i listowanie: przedmiotów, grup, sal. Pobieranie REF. |
| `pkg_osoby` | Dodawanie nauczycieli i uczniów. Listy, kursor jawny. |
| `pkg_lekcje` | Dodawanie lekcji (indywidualnych/grupowych). Plany. |
| `pkg_oceny` | Wystawianie ocen, listy, średnia. |
| `pkg_raporty` | Statystyki, raport grup. |

---

## 5. TRIGGERY

| Trigger | Tabela | Funkcja |
|---------|--------|---------|
| `trg_lekcja_xor` | LEKCJE | XOR: albo uczeń albo grupa |
| `trg_ocena_zakres` | OCENY | Zakres 1-6 (przyjazny komunikat) |

---

## 6. OGRANICZENIA (CONSTRAINTS)

- Przedmiot: typ IN ('indywidualny', 'grupowy'), czas = 45
- Grupa: poziom 1-6, symbol UNIQUE
- Sala: typ IN ('indywidualna', 'grupowa'), pojemność > 0
- Lekcja: godzina 8-20, czas = 45
- Ocena: wartość 1-6, semestralna IN ('T', 'N')

---

## 7. URUCHOMIENIE

```sql
-- Wykonaj skrypty w kolejności:
@01_typy.sql       -- Typy obiektowe
@02_tabele.sql     -- Tabele i sekwencje
@03_pakiety.sql    -- Pakiety PL/SQL
@04_triggery.sql   -- Wyzwalacze
@05_dane.sql       -- Dane testowe
@06_testy.sql      -- Scenariusze testowe
```

---

## 8. SPEŁNIENIE WYMAGAŃ

| Wymaganie | Realizacja |
|-----------|------------|
| Typy obiektowe | 8 typów z metodami |
| REF/DEREF | Nauczyciel→Przedmiot, Uczeń→Grupa, Lekcja→wiele, Ocena→wiele |
| VARRAY | t_wyposazenie w sali |
| Pakiety PL/SQL | 5 pakietów |
| Kursory | Jawny (lista_uczniow_grupy), niejawne (FOR) |
| Triggery | 2 (XOR lekcji, zakres ocen) |

---

*Wersja uproszczona - projekt edukacyjny demonstrujący obiektowość Oracle.*
