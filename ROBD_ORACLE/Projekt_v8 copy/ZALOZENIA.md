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

**Zakres:** 6 klas (I-VI), ~24 uczniów, 6 nauczycieli, **5 sal**, 5 przedmiotów.

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
- Przypisany do **jednej** klasy (determinującej poziom)
- **TYGODNIOWY WYMIAR LEKCJI: 5 (każda w innym dniu Pon-Pt):**
  - **2 lekcje instrumentu** (indywidualne, np. Pon + Śr)
  - **2 lekcje kształcenia słuchu** (grupowe, np. Wt + Czw)
  - **1 lekcja rytmiki** (grupowa, np. Pt)
- Uczeń nie może uczestniczyć w **dwóch lekcjach równocześnie**
- System waliduje kompletność planu (5 lekcji/tydzień)

### 2.4 Nauczyciele
- Może uczyć **jednego lub kilku** przedmiotów (np. fortepian + kształcenie słuchu)
- Nie może prowadzić **dwóch lekcji równocześnie**

### 2.5 Sale
**Dwa typy:**
- **Indywidualne** (maks. 3-5 osób) - do lekcji 1:1
- **Grupowe** (maks. 20-25 osób) - do kształcenia słuchu i rytmiki

**Sale w systemie:**
- Sala 101 - fortepianowa (indywidualna)
- Sala 102 - smyczkowa (indywidualna)
- Sala 103 - gitarowa (indywidualna)
- Sala 104 - teoretyczna (grupowa) - kształcenie słuchu
- Sala 105 - rytmiczna (grupowa) - rytmika

**Wyposażenie:**
- Każda sala ma stałe wyposażenie (VARRAY): instrumenty, meble
- Lekcja instrumentu wymaga sali z tym instrumentem (np. fortepian tylko w sali z fortepianem)
- Sala może być zajęta przez **jedną** lekcję w danym czasie

---

## 3. REGUŁY BIZNESOWE

### 3.1 Planowanie lekcji
1. Lekcja jest **ALBO** indywidualna (1 uczeń) **ALBO** grupowa (klasa) - **XOR**
2. **Wykluczanie konfliktów** - w tym samym terminie:
   - Sala nie może być zajęta przez inną lekcję
   - Nauczyciel nie może prowadzić innej lekcji
   - Uczeń nie może uczestniczyć w innej lekcji
3. Zgodność sali z przedmiotem (wyposażenie)

### 3.2 Oceny
1. Skala: **1-6** (liczby całkowite)
2. Typy: **cząstkowa** (bieżąca) lub **semestralna**
3. Każda ocena powiązana z: uczniem, nauczycielem, przedmiotem, datą

---

## 4. STRUKTURA BAZY DANYCH

### 4.1 Typy obiektowe

| Typ | Atrybuty | Metody |
|-----|----------|--------|
| `T_WYPOSAZENIE` | VARRAY(10) VARCHAR2(50) | - |
| `T_PRZEDMIOT` | nazwa, typ (indywidualny/grupowy), czas_min | `czy_grupowy()` |
| `T_NAUCZYCIEL` | id, imie, nazwisko, przedmioty | `pelne_nazwisko()` |
| `T_GRUPA` | symbol, poziom | - |
| `T_SALA` | numer, typ, pojemnosc, **wyposazenie (VARRAY)** | `czy_grupowa()` |
| `T_UCZEN` | id, imie, nazwisko, data_ur, **REF→grupa**, instrument | `pelne_nazwisko()`, `wiek()` |
| `T_LEKCJA` | id, **REF→przedmiot/nauczyciel/sala**, data, godz_pocz, czas_min, **REF→uczen** lub **REF→grupa** | `godzina_koniec()`, `czy_indywidualna()` |
| `T_OCENA` | id, **REF→uczen/nauczyciel/przedmiot**, wartosc, data, semestralna | `opis_oceny()` |

### 4.2 Tabele obiektowe

| Tabela | Typ | Rozmiar | Uwagi |
|--------|-----|---------|-------|
| `PRZEDMIOTY` | T_PRZEDMIOT | 5 | Słownik przedmiotów |
| `NAUCZYCIELE` | T_NAUCZYCIEL | 6 | Kadra nauczycielska |
| `GRUPY` | T_GRUPA | 6 | Klasy I-VI |
| `SALE` | T_SALA | 5 | Pomieszczenia + **VARRAY** |
| `UCZNIOWIE` | T_UCZEN | ~24 | Uczniowie + REF→GRUPY |
| `LEKCJE` | T_LEKCJA | ~60/tydz. | Plan zajęć + REF |
| `OCENY` | T_OCENA | ~50/sem. | Oceny + REF |

### 4.3 Relacje (REF)

```
PRZEDMIOTY ←──REF── LEKCJE ──REF──→ NAUCZYCIELE
                      │
                      ├──REF──→ SALE (VARRAY wyposażenia)
                      │
                      ├──REF──→ UCZNIOWIE (XOR: indywidualna)
                      │
                      └──REF──→ GRUPY (XOR: grupowa)

UCZNIOWIE ──REF──→ GRUPY

OCENY ──REF──→ UCZNIOWIE
      ──REF──→ NAUCZYCIELE
      ──REF──→ PRZEDMIOTY
```

---

## 5. LOGIKA BIZNESOWA (PAKIETY PL/SQL)

### PKG_SLOWNIKI
- `dodaj_przedmiot()`, `dodaj_sale()` **(VARRAY)**, `dodaj_grupe()`
- `get_ref_*()` - pobieranie referencji po ID
- `info_przedmiot(id)`, `info_sala(id)`, `info_grupa(id)` - **wyświetlanie danych po ID**

### PKG_OSOBY
- `dodaj_nauczyciela()`, `dodaj_ucznia()` **(REF→grupa)**
- `info_uczen(id)`, `info_nauczyciel(id)` - **wyświetlanie danych po ID**
- `lista_uczniow_w_grupie()`, `lista_uczniow_nauczyciela()` **(kursory)**

### PKG_LEKCJE
- `dodaj_lekcje_indywidualna()`, `dodaj_lekcje_grupowa()` **(REF, XOR)**
- `czy_sala_wolna()`, `czy_nauczyciel_wolny()`, `czy_uczen_wolny()`
- `ile_lekcji_ucznia(id)` - **walidacja 5 lekcji/tydzień**
- `raport_kompletnosci()` - **raport brakujących lekcji**
- `plan_ucznia()`, `plan_nauczyciela()` **(REF CURSOR)**

### PKG_OCENY
- `wystaw_ocene(id_ucznia, id_nauczyciela, id_przedmiotu, wartosc)` **(REF)**
- `wystaw_ocene_verbose()` - **z wyświetlaniem kto/co**
- `oceny_ucznia()`, `srednia_ucznia()` **(kursory)**

### PKG_RAPORTY
- `raport_grup()`, `raport_nauczycieli()`, `statystyki_lekcji()`

---

## 6. WYZWALACZE

| Trigger | Tabela | Funkcja |
|---------|--------|---------|
| `trg_ocena_zakres` | OCENY | Wymuszenie zakresu 1-6 |
| `trg_lekcja_xor` | LEKCJE | Wymuszenie XOR (uczeń/grupa) |
| `trg_lekcja_czas` | LEKCJE | Walidacja czasu lekcji |

---

## 7. PRZYJĘTE OGRANICZENIA

1. **Stały czas lekcji:** 45 min dla wszystkich (brak zróżnicowania)
2. **Brak modułu finansowego:** Czesne i wypłaty poza zakresem
3. **Jeden instrument na ucznia:** Upraszcza przypisanie do nauczyciela
4. **Siatka godzinowa:** Tylko o pełnych godzinach (14:00, 15:00, 16:00...)
5. **Brak chóru/orkiestry:** Tylko lekcje indywidualne + kształcenie słuchu
6. **Wyposażenie sali:** Maksymalnie 10 elementów (VARRAY(10))
7. **Godziny pracy:** 14:00-20:00 (6 godzin dziennie, poniedziałek-piątek)
8. **Skala ocen:** 1-6 (polska skala szkolna)
9. **Brak walidacji wyposażenia:** System nie sprawdza fizycznie czy instrument istnieje w sali
10. **Klasy:** 6 poziomów (I-VI), jedna grupa na poziom

---

## 8. OBSŁUGA BŁĘDÓW

System wykorzystuje mechanizmy Oracle do obsługi błędów:
- **RAISE_APPLICATION_ERROR** - własne kody błędów (-20001 do -20999)
- **EXCEPTION** - bloki obsługi wyjątków w pakietach
- **Walidacja danych** - w procedurach przed INSERT/UPDATE
- **Triggery** - walidacja na poziomie bazy danych

### Przykładowe kody błędów:
- `-20001` - Konflikt terminu lekcji (sala zajęta)
- `-20002` - Konflikt terminu (nauczyciel zajęty)
- `-20003` - Konflikt terminu (uczeń zajęty)
- `-20004` - Ocena poza zakresem 1-6
- `-20005` - Naruszenie XOR (lekcja indywidualna/grupowa)
- `-20009` - Uczeń ma już 5 lekcji w tym tygodniu

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
| Typy obiektowe z metodami | 8 typów, metody: `wiek()`, `godzina_koniec()`, `czy_grupowy()` |
| Tabele obiektowe | 7 tabel obiektowych |
| REF i DEREF | `LEKCJE→SALA`, `UCZEN→GRUPA`, `OCENA→{UCZEN,NAUCZYCIEL,PRZEDMIOT}` |
| VARRAY | `T_WYPOSAZENIE` w tabeli `SALE` |
| Pakiety PL/SQL | 5 pakietów (~25 procedur/funkcji) |
| Kursory/REF CURSOR | W procedurach list i planów |
| Obsługa błędów | `RAISE_APPLICATION_ERROR` w pakietach |
| Wyzwalacze | 3 triggery walidacyjne |

---

*Ostatnia aktualizacja: 2 lutego 2026*
