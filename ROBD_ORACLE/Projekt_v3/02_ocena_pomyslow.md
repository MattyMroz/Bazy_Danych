# 🏆 Ocena Pomysłów i Decyzje Projektowe - Szkoła Muzyczna v3

## 📌 Motto Projektu
> **"Prostota i logiczność"** - projekt studencki, nie system produkcyjny

---

## ✅ Podjęte Decyzje

### 1. Struktura Bazy Danych

#### Tabele (7 tabel obiektowych):

| Tabela | Typ bazowy | Opis | REF |
|--------|-----------|------|-----|
| `t_instrument` | t_instrument_obj | Słownik instrumentów | - |
| `t_sala` | t_sala_obj | Sale lekcyjne | - |
| `t_nauczyciel` | t_nauczyciel_obj | Nauczyciele | VARRAY instrumentów |
| `t_uczen` | t_uczen_obj | Uczniowie | - |
| `t_kurs` | t_kurs_obj | Kursy nauki gry | REF → instrument |
| `t_lekcja` | t_lekcja_obj | Pojedyncze lekcje | REF → uczeń, nauczyciel, kurs, sala |
| `t_ocena_postepu` | t_ocena_obj | Oceny postępów | REF → uczeń, nauczyciel |

**USUNIĘTE z v2:**
- ❌ `t_semestr` - trigger mutating table, zakładamy 1 semestr
- ❌ `t_zapis` - redundancja z t_lekcja, uproszczenie
- ❌ `t_audit_log` - minimalizacja audytu

---

### 2. Typy Obiektowe (7 typów + 1 VARRAY)

| Typ | Metody | Opis |
|-----|--------|------|
| `t_instrument_obj` | 1 | Instrument (nazwa, kategoria) |
| `t_sala_obj` | 1 | Sala (pojemność, wyposażenie) |
| `t_nauczyciel_obj` | 3 | Nauczyciel (dane, staż, instrumenty) |
| `t_uczen_obj` | 3 | Uczeń (dane, wiek, pełnoletność) |
| `t_kurs_obj` | 1 | Kurs (poziom, cena) |
| `t_lekcja_obj` | 2 | Lekcja (data, status) |
| `t_ocena_obj` | 2 | Ocena (1-6, słownie) |
| `t_lista_instrumentow` | - | VARRAY(5) nazw instrumentów |

**Łącznie:** 13 metod (uproszczone z 15)

---

### 3. Ograniczenia Biznesowe

#### Uczniowie:
- ✅ Minimalny wiek: **5 lat**
- ✅ Max lekcji dziennie: **2**
- ✅ Dzieci <15 lat: lekcje tylko **14:00-19:00** (po normalnej szkole)
- ✅ Email unikalny

#### Nauczyciele:
- ✅ Max pracy dziennie: **6 godzin (360 minut)**
- ✅ Max instrumentów: **5** (VARRAY)
- ✅ Email unikalny
- ✅ Nie może mieć 2 lekcji o tej samej godzinie

#### Lekcje:
- ✅ Godziny pracy szkoły: **08:00-20:00**
- ✅ Tylko dni robocze: **poniedziałek-piątek**
- ✅ Czas trwania: **30, 45, 60, 90 minut**
- ✅ Statusy: zaplanowana, odbyta, odwolana
- ✅ Brak konfliktów: uczeń, nauczyciel, sala

#### Oceny:
- ✅ Skala: **1-6** (polska)
- ✅ Obszary: technika, teoria, sluch, rytm, interpretacja, ogolna

#### Sale:
- ✅ Pojemność > 0
- ✅ Nazwa unikalna
- ✅ Wyposażenie: fortepian (T/N), perkusja (T/N)

---

### 4. Triggery (10 triggerów)

| Trigger | Typ | Tabela | Działanie |
|---------|-----|--------|-----------|
| `trg_uczen_minimalny_wiek` | BEFORE INSERT | t_uczen | Sprawdza min 5 lat |
| `trg_lekcja_godziny_dziecka` | BEFORE INSERT/UPDATE | t_lekcja | <15 lat: tylko 14-19 |
| `trg_lekcja_tylko_dni_robocze` | BEFORE INSERT/UPDATE | t_lekcja | Tylko pon-pt |
| `trg_lekcja_limit_nauczyciela` | BEFORE INSERT | t_lekcja | Max 6h/dzień |
| `trg_lekcja_limit_ucznia` | BEFORE INSERT | t_lekcja | Max 2 lekcje/dzień |
| `trg_lekcja_konflikt_sali` | BEFORE INSERT | t_lekcja | Sala nie zajęta |
| `trg_lekcja_konflikt_nauczyciela` | BEFORE INSERT | t_lekcja | Nauczyciel nie zajęty |
| `trg_lekcja_konflikt_ucznia` | BEFORE INSERT | t_lekcja | Uczeń nie zajęty |
| `trg_uczen_przed_usunieciem` | BEFORE DELETE | t_uczen | Blokuje z lekcjami |
| `trg_nauczyciel_przed_usunieciem` | BEFORE DELETE | t_nauczyciel | Blokuje z lekcjami |

**USUNIĘTE z v2:**
- ❌ `trg_semestr_tylko_jeden_aktywny` - mutating table
- ❌ `trg_lekcja_w_semestrze` - brak semestru
- ❌ `trg_kurs_cena_audit` - minimalizacja
- ❌ `trg_ocena_audit` - minimalizacja (można zostawić jako opcję)
- ❌ `trg_sala_przed_usunieciem` - uproszczenie
- ❌ `trg_lekcja_status_audit` - niepotrzebne

---

### 5. Pakiety (3 pakiety, ~15 procedur/funkcji)

#### pkg_uczen (5):
- `dodaj_ucznia()` - dodaje ucznia z walidacją wieku
- `liczba_uczniow()` - zwraca liczbę
- `lista_uczniow()` - wyświetla listę (kursor jawny)
- `uczniowie_wiek()` - filtruje po wieku (REF CURSOR)
- `srednia_ocen()` - średnia ocen ucznia

#### pkg_lekcja (6):
- `zaplanuj_lekcje()` - planuje lekcję
- `oznacz_odbyta()` - zmienia status
- `odwolaj_lekcje()` - odwołuje
- `lekcje_dnia()` - raport dzienny (kursor FOR)
- `sprawdz_dostepnosc()` - sprawdza konflikty
- `statystyki_dnia()` - podsumowanie dnia

#### pkg_ocena (4):
- `dodaj_ocene()` - dodaje ocenę
- `ostatnie_oceny()` - ostatnie N ocen (REF CURSOR)
- `raport_ucznia()` - raport postępu
- `srednia_obszar()` - średnia w obszarze

**USUNIĘTE z v2:**
- ❌ `pkg_semestr` - brak semestru
- ❌ `pkg_sala` - uproszczone do sprawdzania w pkg_lekcja
- ❌ `porownaj_uczniow()` - niepotrzebne bajery

---

### 6. Role i Użytkownicy (3 role, 3 użytkownicy)

| Rola | Uprawnienia |
|------|-------------|
| `ROLA_ADMIN` | CRUD na wszystkim |
| `ROLA_NAUCZYCIEL` | Lekcje (CRU), Oceny (CRU), Reszta (R) |
| `ROLA_SEKRETARIAT` | Uczniowie (CRUD), Lekcje (R), Oceny (R) |

---

### 7. Testy - Scenariusze (6 kategorii)

#### Kategoria 1: Typy i Metody
- Test metod wszystkich typów obiektowych

#### Kategoria 2: Ograniczenia CHECK
- Nieprawidłowe wartości (status, ocena, typ)

#### Kategoria 3: Pakiety
- Wszystkie procedury i funkcje

#### Kategoria 4: Triggery - Walidacja
- Wiek ucznia
- Godziny dziecka
- Dni robocze
- Limity nauczyciela i ucznia
- Konflikty

#### Kategoria 5: Scenariusze Biznesowe
- **Scenariusz 1:** Nowy uczeń → zapis → lekcja → ocena
- **Scenariusz 2:** Planowanie tygodnia nauczyciela
- **Scenariusz 3:** Konflikt sali
- **Scenariusz 4:** Dziecko próbuje lekcji rano
- **Scenariusz 5:** Nauczyciel przekracza 6h

#### Kategoria 6: Blokady Usuwania
- Próba usunięcia ucznia/nauczyciela z lekcjami

---

## 📁 Struktura Plików

```
Projekt_v3/
├── 01_typy.sql          (~150 linii)
├── 02_tabele.sql        (~120 linii)
├── 03_pakiety.sql       (~300 linii)
├── 04_triggery.sql      (~250 linii)
├── 05_dane.sql          (~200 linii)
├── 06_testy.sql         (~400 linii)
├── 07_uzytkownicy.sql   (~80 linii)
├── 01_burza_mozgow.md
├── 02_ocena_pomyslow.md
└── Raport_MusicSchoolDB.tex
```

**Łącznie:** ~1500 linii SQL (vs ~2500 w v2)

---

## 🛡️ Obrona Przed Pytaniami

### "Dlaczego brak tabeli semestrów?"
> "Uproszczenie projektowe. System monitoruje bieżący okres nauczania. W wersji produkcyjnej można dodać zarządzanie semestrami, ale trigger wymaga compound triggera, co komplikuje projekt."

### "Dlaczego nauczyciel może uczyć instrumentu spoza VARRAY?"
> "VARRAY służy do informacji poglądowej. Dyrektor weryfikuje kompetencje przy zatrudnianiu. To założenie projektowe."

### "Dlaczego szkoła nie działa w weekendy?"
> "Wzorowane na publicznych szkołach muzycznych w Polsce. Upraszcza logikę godzin dla dzieci."

### "Dlaczego brak tabeli t_zapis?"
> "Uproszczenie. Lekcja bezpośrednio łączy ucznia z kursem i nauczycielem. W wersji rozszerzonej można dodać t_zapis dla śledzenia zapisów na kursy."

### "Dlaczego tylko 10 triggerów?"
> "Fokus na kluczowe reguły biznesowe. Każdy trigger ma jasne uzasadnienie i demonstrację działania w testach."

---

## 📊 Porównanie v2 vs v3

| Element | v2 | v3 | Zmiana |
|---------|----|----|--------|
| Tabele | 8 | 7 | -1 (usunięto t_semestr) |
| Typy | 9 | 8 | -1 |
| Metody | 15 | 13 | -2 |
| Triggery | 16 | 10 | -6 |
| Pakiety | 5 | 3 | -2 |
| Procedury | 26 | ~15 | -11 |
| Linie kodu | ~2500 | ~1500 | -40% |

**Cel osiągnięty:** Prostszy, ale nadal kompletny projekt.
