# 🎼 SZKOŁA MUZYCZNA I STOPNIA
## Założenia projektowe bazy danych

**Projekt:** Grupa 5 - Szkoła muzyczna (z naciskiem na rozwój ucznia)  
**Autorzy:** Igor Typiński (251237), Mateusz Mróz (251190)  
**Data:** Luty 2026

---

## 1. OPIS PROJEKTU

Obiektowa baza danych Oracle dla małej prywatnej **szkoły muzycznej I stopnia** prowadzącej nauczanie gry na instrumentach oraz kształcenie słuchu. System obsługuje:
- Ewidencję uczniów i nauczycieli
- Zarządzanie salami lekcyjnymi (z VARRAY wyposażenia)
- Planowanie lekcji (indywidualnych i grupowych)
- Ocenianie postępów uczniów

**Zakres danych testowych:** 3 grupy (1A, 2A, 3A), 9 uczniów, 5 nauczycieli, 4 sale, 5 przedmiotów.

---

## 2. CHARAKTERYSTYKA SZKOŁY

### 2.1 Organizacja
1. **Cykl nauczania:** 6 lat (klasy I-VI)
2. **Czas pracy:** Poniedziałek-piątek, 14:00-20:00
3. **Jednostka lekcyjna:** 45 minut (stała dla wszystkich zajęć)
4. **Siatka godzin:** Lekcje rozpoczynają się o pełnych godzinach (14:00, 15:00, 16:00...)

### 2.2 Identyfikacja obiektów
**Każdy uczeń i nauczyciel identyfikowany jest przez unikatowy ID:**
- Uczniowie mogą mieć takie same imiona i nazwiska (np. Jan Kowalski)
- Nauczyciele mogą mieć takie same nazwiska (np. dwie Panie Kowalskie)
- Klucz główny: **ID** (NUMBER) generowane automatycznie przez sekwencję
- W procedurach pakietów wyszukiwanie odbywa się po nazwiskach, ale ostateczna identyfikacja po ID

### 2.3 Uczniowie
- Każdy uczeń uczy się **jednego** instrumentu głównego
- Przypisany do **jednej** klasy (determinującej poziom) przez **REF do grupy**
- **TYGODNIOWY WYMIAR LEKCJI:** 
  - Lekcje instrumentu (indywidualne)
  - Lekcje kształcenia słuchu (grupowe)
  - Lekcje rytmiki (grupowe)
- System **nie waliduje automatycznie** kompletności planu (dane testowe zawierają przykładowy tydzień)

### 2.4 Nauczyciele
- Każdy nauczyciel uczy **jednego przedmiotu** (uproszczenie - w rzeczywistości może uczyć kilku)
- REF do przedmiotu przechowywany w typie `T_NAUCZYCIEL`
- System **nie waliduje** czy nauczyciel ma dwie lekcje równocześnie (dane testowe poprawne)

### 2.5 Sale
**Dwa typy:**
- **Indywidualne** (maks. 3-5 osób) - do lekcji 1:1
- **Grupowe** (maks. 20-25 osób) - do kształcenia słuchu i rytmiki

**Sale w systemie (dane testowe):**
- Sala 101 - indywidualna (fortepian)
- Sala 102 - indywidualna (smyczki/gitara)
- Sala 103 - grupowa (kształcenie słuchu)
- Sala 104 - grupowa (rytmika)

**Wyposażenie (VARRAY):**
- Każda sala ma stałe wyposażenie zapisane jako `t_wyposazenie` (VARRAY)
- Metoda `lista_wyposazenia()` zwraca wyposażenie jako tekst
- System **nie sprawdza** zgodności wyposażenia z przedmiotem (uproszczenie)

---

## 3. REGUŁY BIZNESOWE

### 3.1 Planowanie lekcji
1. Lekcja jest **ALBO** indywidualna (1 uczeń) **ALBO** grupowa (klasa) - **XOR** ✅ walidowane przez trigger
2. Lekcje mają stały czas: **45 minut**
3. Lekcje rozpoczynają się o pełnych godzinach (14:00-19:00)

> ⚠️ **Uproszczenie:** Konflikty terminów (sala zajęta, nauczyciel zajęty, uczeń zajęty) **NIE SĄ** walidowane przez system. Dane testowe nie zawierają konfliktów.

### 3.2 Oceny
1. Skala: **1-6** (liczby całkowite) ✅ walidowane przez trigger
2. Typy: **cząstkowa** (`semestralna='N'`) lub **semestralna** (`semestralna='T'`)
3. Każda ocena powiązana przez REF z: uczniem, nauczycielem, przedmiotem

---

## 4. STRUKTURA BAZY DANYCH

### 4.1 Typy obiektowe

| Typ | Atrybuty | Metody |
|-----|----------|--------|
| `T_WYPOSAZENIE` | VARRAY(10) VARCHAR2(50) | - |
| `T_PRZEDMIOT` | nazwa, typ (indywidualny/grupowy), czas_min | `czy_grupowy()` |
| `T_NAUCZYCIEL` | id, imie, nazwisko, data_zatr, **REF→przedmiot** | `pelne_nazwisko()`, `staz_lat()` |
| `T_GRUPA` | symbol, poziom | - |
| `T_SALA` | numer, typ, pojemnosc, **wyposazenie (VARRAY)** | `czy_grupowa()`, `lista_wyposazenia()` |
| `T_UCZEN` | id, imie, nazwisko, data_ur, **REF→grupa**, instrument | `pelne_nazwisko()`, `wiek()` |
| `T_LEKCJA` | id, **REF→przedmiot/nauczyciel/sala**, data, godz_pocz, czas_min, **REF→uczen** lub **REF→grupa** | `godzina_koniec()`, `czy_indywidualna()` |
| `T_OCENA` | id, **REF→uczen/nauczyciel/przedmiot**, wartosc, data, semestralna | `opis_oceny()` |

### 4.2 Tabele obiektowe

| Tabela | Typ | Rozmiar | Uwagi |
|--------|-----|---------|-------|
| `PRZEDMIOTY` | T_PRZEDMIOT | 5 | Słownik przedmiotów |
| `GRUPY` | T_GRUPA | 3-6 | Klasy (uproszczone: 3 grupy) |
| `NAUCZYCIELE` | T_NAUCZYCIEL | 5 | Kadra + **REF→PRZEDMIOTY** |
| `SALE` | T_SALA | 4 | Pomieszczenia + **VARRAY** |
| `UCZNIOWIE` | T_UCZEN | ~9 | Uczniowie + **REF→GRUPY** |
| `LEKCJE` | T_LEKCJA | ~18/tydz. | Plan zajęć + **REF (XOR)** |
| `OCENY` | T_OCENA | ~8 | Oceny + **REF** |

### 4.3 Relacje (REF)

```
PRZEDMIOTY ←──REF── NAUCZYCIELE (każdy uczy jednego przedmiotu)
     │
     └──REF── LEKCJE ──REF──→ NAUCZYCIELE
                 │
                 ├──REF──→ SALE (VARRAY wyposażenia)
                 │
                 ├──REF──→ UCZNIOWIE (XOR: lekcja indywidualna)
                 │
                 └──REF──→ GRUPY (XOR: lekcja grupowa)

UCZNIOWIE ──REF──→ GRUPY

OCENY ──REF──→ UCZNIOWIE
      ──REF──→ NAUCZYCIELE
      ──REF──→ PRZEDMIOTY
```

---

## 5. LOGIKA BIZNESOWA (PAKIETY PL/SQL)

> ⚠️ **Uproszczenie:** Pakiety realizują **podstawowe operacje CRUD** oraz **wyświetlanie danych**. Zaawansowana walidacja (konflikty terminów) jest poza zakresem projektu.

### PKG_SLOWNIKI
- `dodaj_przedmiot(nazwa, typ)` - dodaje przedmiot do słownika
- `dodaj_grupe(symbol, poziom)` - dodaje klasę
- `dodaj_sale(numer, typ, pojemnosc, wyposazenie)` - dodaje salę z **VARRAY**
- `get_ref_przedmiot(id)`, `get_ref_grupa(id)`, `get_ref_sala(id)` - pobieranie referencji
- `lista_przedmiotow()`, `lista_grup()`, `lista_sal()` - wyświetlanie danych

### PKG_OSOBY
- `dodaj_nauczyciela(imie, nazwisko, id_przedmiotu)` - dodaje nauczyciela z **REF** do przedmiotu
- `dodaj_ucznia(imie, nazwisko, data_ur, instrument, id_grupy)` - dodaje ucznia z **REF** do grupy
- `get_ref_nauczyciel(id)`, `get_ref_uczen(id)` - pobieranie referencji
- `lista_nauczycieli()`, `lista_uczniow()` - wyświetlanie danych
- `lista_uczniow_grupy(id_grupy)` - **kursor jawny** (OPEN/FETCH/CLOSE)

### PKG_LEKCJE
- `dodaj_lekcje_indywidualna(...)` - dodaje lekcję z **REF** do ucznia
- `dodaj_lekcje_grupowa(...)` - dodaje lekcję z **REF** do grupy
- `plan_ucznia(id)` - plan lekcji ucznia (indywidualne + grupowe przez UNION)
- `plan_nauczyciela(id)` - plan lekcji nauczyciela
- `plan_dnia(data)` - wszystkie lekcje w danym dniu

### PKG_OCENY
- `wystaw_ocene(id_ucznia, id_nauczyciela, id_przedmiotu, wartosc)` - ocena cząstkowa
- `wystaw_ocene_semestralna(...)` - ocena semestralna
- `oceny_ucznia(id)` - lista ocen ucznia
- `srednia_ucznia(id_ucznia, id_przedmiotu)` - średnia z przedmiotu (zwraca 0 gdy brak ocen)

### PKG_RAPORTY
- `raport_grup()` - liczba uczniów w każdej klasie
- `statystyki()` - podsumowanie: liczba uczniów, nauczycieli, lekcji, ocen

---

## 6. WYZWALACZE (TRIGGERY)

> ⚠️ **Uproszczenie:** Triggery walidują tylko **krytyczne reguły biznesowe**, które muszą być spełnione dla poprawności danych.

| Trigger | Tabela | Funkcja | Kod błędu |
|---------|--------|---------|-----------|
| `trg_lekcja_xor` | LEKCJE | Wymuszenie XOR: lekcja ma ALBO ucznia ALBO grupę | -20001 |
| `trg_ocena_zakres` | OCENY | Przyjazny komunikat przy ocenie poza 1-6 | -20002 |

> 💡 **Uwaga:** Triggery walidujące konflikty terminów (sala zajęta, nauczyciel zajęty) **celowo pominięte** - patrz sekcja 7.2.

---

## 7. PRZYJĘTE OGRANICZENIA I UPROSZCZENIA

> ⚠️ **UWAGA:** Jest to projekt **edukacyjny/studencki**, którego celem jest demonstracja mechanizmów obiektowych Oracle (typy, REF/DEREF, VARRAY, pakiety, triggery), **NIE** budowa produkcyjnego systemu zarządzania szkołą.

### 7.1 Uproszczenia modelu danych

1. **Stały czas lekcji:** 45 min dla wszystkich (brak zróżnicowania)
2. **Jeden instrument na ucznia:** Upraszcza przypisanie do nauczyciela
3. **Jeden przedmiot na nauczyciela:** Każdy nauczyciel uczy tylko jednego przedmiotu (REF do przedmiotu w typie)
4. **Siatka godzinowa:** Lekcje tylko o pełnych godzinach (14:00, 15:00, 16:00...)
5. **Brak chóru/orkiestry:** Tylko lekcje indywidualne + kształcenie słuchu + rytmika
6. **Wyposażenie sali:** Maksymalnie 10 elementów (VARRAY(10))
7. **Godziny pracy:** 14:00-20:00 (poniedziałek-piątek)
8. **Skala ocen:** 1-6 (polska skala szkolna)
9. **Klasy:** 6 poziomów (I-VI), po jednej grupie na poziom

### 7.2 Uproszczenia walidacji (świadome decyzje projektowe)

| Co NIE jest walidowane | Uzasadnienie | W systemie produkcyjnym |
|------------------------|--------------|-------------------------|
| **Konflikt sali** - czy sala wolna w danym terminie | Uproszczenie projektu; dane testowe poprawne | Trigger lub procedura sprawdzająca |
| **Konflikt nauczyciela** - czy nauczyciel wolny | j.w. | j.w. |
| **Konflikt ucznia** - czy uczeń ma inną lekcję | j.w. | j.w. |
| **Kompletność planu** - 5 lekcji/tydzień | Brak automatycznego sprawdzania | Procedura walidacyjna |
| **Zgodność sali z przedmiotem** | System nie sprawdza wyposażenia | CHECK lub trigger |

> 💡 **Uzasadnienie:** Pełna walidacja konfliktów wymagałaby ~200 linii kodu SQL, co nie jest celem projektu demonstrującego mechanizmy obiektowe. Dane testowe są przygotowane tak, aby nie zawierały konfliktów.

### 7.3 Ograniczenia poza zakresem projektu

| Funkcjonalność | Status |
|----------------|--------|
| Moduł finansowy (czesne, wypłaty) | Poza zakresem |
| Historia zmian (audyt) | Poza zakresem |
| Wieloletni plan nauczania | Poza zakresem |
| Import/eksport danych | Poza zakresem |
| Interfejs graficzny | Poza zakresem |

---

## 8. OBSŁUGA BŁĘDÓW (PODSTAWOWA)

System wykorzystuje **podstawową** obsługę błędów Oracle:
- **RAISE_APPLICATION_ERROR** - własne kody błędów (-20001 do -20999)
- **EXCEPTION** - bloki obsługi wyjątków w pakietach (dla NO_DATA_FOUND)
- **Triggery** - walidacja kluczowych reguł na poziomie bazy danych

### 8.1 Walidowane reguły (wymagane do działania systemu)

| Reguła | Mechanizm | Komunikat błędu |
|--------|-----------|-----------------|
| **XOR lekcji** - albo uczeń ALBO grupa | Trigger `trg_lekcja_xor` | "Lekcja musi mieć ALBO ucznia ALBO grupę" |
| **Zakres ocen 1-6** | Trigger `trg_ocena_zakres` | "Ocena musi być w zakresie 1-6" |
| **Istnienie referencji** | EXCEPTION w `get_ref_*()` | "Przedmiot/Uczen/... ID=X nie istnieje" |

### 8.2 Kody błędów aplikacji

| Kod | Opis |
|-----|------|
| `-20001` | Naruszenie XOR (lekcja musi mieć ucznia LUB grupę) |
| `-20002` | Ocena poza zakresem 1-6 |
| `-20010` | Nie znaleziono przedmiotu o podanym ID |
| `-20011` | Nie znaleziono grupy o podanym ID |
| `-20012` | Nie znaleziono sali o podanym ID |
| `-20013` | Nie znaleziono nauczyciela o podanym ID |
| `-20014` | Nie znaleziono ucznia o podanym ID |

> 💡 **Uwaga:** W projekcie studenckim walidujemy tylko **krytyczne błędy** uniemożliwiające działanie systemu. Konflikty terminów (sala zajęta, nauczyciel zajęty) są opisane w założeniach jako **poza zakresem walidacji** - dane testowe nie zawierają takich konfliktów.

---

## 9. KURSORY
TO TAK NA MARGINESIE TE KURSORY:
(
System wykorzystuje trzy typy kursorów:

| Typ kursora | Zastosowanie | Przykład |
|-------------|--------------|----------|
| **Jawny** | Gdy potrzebna pełna kontrola (OPEN/FETCH/CLOSE) | Iteracja po uczniach w grupie |
| **Niejawny (FOR)** | Uproszczona składnia dla pętli | `FOR rec IN (SELECT...)` |
| **REF CURSOR** | Zwracanie wyników z funkcji | `plan_ucznia()` zwraca kursor |
)

---

## 10. ROLE UŻYTKOWNIKÓW

| Rola | Funkcjonalności |
|------|-----------------|
| **Administrator** | Dodawanie nauczycieli, uczniów, sal, przedmiotów; zarządzanie strukturą bazy |
| **Sekretariat** | Dodawanie lekcji, generowanie planów, raportowanie |
| **Nauczyciel** | Wystawianie ocen, przeglądanie planów i list uczniów |
| **Uczeń/Rodzic** | Przeglądanie planu, ocen, średnich (tylko odczyt) |

---

## 11. DIAGRAM RELACJI OBIEKTÓW

```
┌──────────────┐
│  PRZEDMIOTY  │◄────────────────────┐
└──────────────┘                     │
                                     │ REF
┌──────────────┐    ┌────────────┐  │
│ NAUCZYCIELE  │◄───│  LEKCJE    │──┤
└──────────────┘    │            │  │
      ▲             │  XOR:      │  │
      │ REF         │  • indyw.  │──REF──►UCZNIOWIE──REF──►GRUPY
      │             │  • grupowa │                │
┌─────┴──────┐      └─────┬──────┘                │
│   OCENY    │            │ REF                   │
└────────────┘            ▼                       │
      │ REF        ┌──────────────┐               │
      └───────────►│    SALE      │◄──────────────┘
                   │ (VARRAY      │
                   │ wyposażenia) │
                   └──────────────┘
```

---

## 12. SPEŁNIENIE WYMAGAŃ PROJEKTU

| Wymaganie | Realizacja |
|-----------|------------|
| Typy obiektowe z metodami | 8 typów, metody: `wiek()`, `staz_lat()`, `godzina_koniec()`, `czy_grupowy()`, `lista_wyposazenia()`, `opis_oceny()` |
| Tabele obiektowe | 7 tabel obiektowych |
| REF i DEREF | `NAUCZYCIEL→PRZEDMIOT`, `LEKCJE→SALA`, `UCZEN→GRUPA`, `OCENA→{UCZEN,NAUCZYCIEL,PRZEDMIOT}` |
| VARRAY | `T_WYPOSAZENIE` w tabeli `SALE` (max 10 elementów) |
| Pakiety PL/SQL | 5 pakietów (~20 procedur/funkcji) |
| Kursory | Jawny w `lista_uczniow_grupy()`, niejawny (FOR) w pozostałych |
| Obsługa błędów | `RAISE_APPLICATION_ERROR`, `EXCEPTION WHEN NO_DATA_FOUND` |
| Wyzwalacze | 2 triggery: XOR lekcji, zakres ocen |

---

## 13. CEL PROJEKTU (podsumowanie)

> 🎯 **Projekt ma na celu demonstrację mechanizmów obiektowych Oracle:**
> - Definiowanie typów obiektowych z metodami
> - Używanie REF/DEREF do relacji między obiektami
> - Wykorzystanie VARRAY do przechowywania kolekcji
> - Tworzenie pakietów PL/SQL z procedurami i funkcjami
> - Implementacja triggerów walidacyjnych
> - Obsługa błędów przez EXCEPTION i RAISE_APPLICATION_ERROR
>
> **NIE jest celem** budowa kompletnego systemu produkcyjnego z pełną walidacją wszystkich reguł biznesowych.

---

*Ostatnia aktualizacja: 2 lutego 2026*
