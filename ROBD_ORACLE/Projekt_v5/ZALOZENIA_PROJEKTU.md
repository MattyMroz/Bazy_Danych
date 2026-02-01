# 🎼 SZKOŁA MUZYCZNA v5 - ZAŁOŻENIA PROJEKTOWE
## Dokument referencyjny dla obrony

**Autorzy:** Igor Typiński (251237), Mateusz Mróz (251190)  
**Data:** Luty 2026

---

## 📦 CO MAMY W PROJEKCIE (PODSUMOWANIE)

### TYPY OBIEKTOWE (12)
| # | Typ | Opis | Metody | VARRAY/REF |
|---|-----|------|--------|------------|
| 1 | `t_lista_instrumentow` | VARRAY(5) | - | VARRAY |
| 2 | `t_lista_sprzetu` | VARRAY(10) | - | VARRAY |
| 3 | `t_semestr_obj` | Okres rozliczeniowy | 3 | - |
| 4 | `t_instrument_obj` | Słownik instrumentów | 2 | - |
| 5 | `t_sala_obj` | Sale lekcyjne | 3 | ma VARRAY |
| 6 | `t_nauczyciel_obj` | Kadra | 4 | ma VARRAY |
| 7 | `t_grupa_obj` | Grupy teoretyczne | 2 | - |
| 8 | `t_uczen_obj` | Uczniowie | 5 | 2x REF |
| 9 | `t_przedmiot_obj` | Przedmioty | 2 | 1x REF |
| 10 | `t_lekcja_obj` | Lekcje | 4 | **6x REF** |
| 11 | `t_egzamin_obj` | Egzaminy | 2 | 5x REF |
| 12 | `t_ocena_obj` | Oceny | 2 | 4x REF |

**RAZEM:** 12 typów, 29 metod, 18 REF, 2 VARRAY

---

### TABELE (10)
| # | Tabela | Typ | Opis |
|---|--------|-----|------|
| 1 | `semestry` | słownik | Okresy rozliczeniowe |
| 2 | `instrumenty` | słownik | Lista instrumentów |
| 3 | `sale` | zasób | Sale z wyposażeniem |
| 4 | `nauczyciele` | zasób | Kadra pedagogiczna |
| 5 | `grupy` | organizacja | Grupy do zajęć grupowych |
| 6 | `uczniowie` | zasób | Uczniowie szkoły |
| 7 | `przedmioty` | organizacja | Przedmioty nauczania |
| 8 | `lekcje` | transakcja | Pojedyncze lekcje |
| 9 | `egzaminy` | transakcja | Egzaminy |
| 10 | `oceny` | transakcja | Oceny bieżące |

---

### TRIGGERY (7)
| # | Trigger | Cel |
|---|---------|-----|
| 1 | `pkg_trigger_ctx` | Pakiet anty-ORA-04091 |
| 2 | `trg_egzamin_komisja` | Komisja = 2 RÓŻNYCH nauczycieli |
| 3 | `trg_lekcja_godzina_bs` | BEFORE STATEMENT - clear |
| 4 | `trg_lekcja_godzina_ar` | AFTER ROW - collect IDs |
| 5 | `trg_lekcja_godzina_as` | AFTER STATEMENT - validate |
| 6 | `trg_egzamin_godzina` | Godzina egzaminu wg typu ucznia |
| 7 | `trg_uczen_klasa_limit` | klasa <= cykl_nauczania |

---

### PAKIETY (6)
| # | Pakiet | Główne funkcje |
|---|--------|----------------|
| 1 | `pkg_trigger_ctx` | Kontekst dla triggerów |
| 2 | `pkg_uczen` | CRUD uczniów, promocje, statystyki |
| 3 | `pkg_nauczyciel` | CRUD nauczycieli, instrumenty |
| 4 | `pkg_lekcja` | **Planowanie + HEURYSTYKA** |
| 5 | `pkg_ocena` | Oceny bieżące |
| 6 | `pkg_raport` | Raporty i statystyki |

---

### WIDOKI (6)
| # | Widok | Opis |
|---|-------|------|
| 1 | `v_uczniowie` | Uczniowie z rozwiązanymi REF |
| 2 | `v_nauczyciele` | Nauczyciele ze stażem |
| 3 | `v_lekcje` | Lekcje z pełnymi danymi |
| 4 | `v_egzaminy` | Egzaminy z komisją |
| 5 | `v_oceny` | Oceny z kontekstem |
| 6 | `v_plan_lekcji` | Plan uproszczony |

---

### ROLE I UŻYTKOWNICY (4 role, 6 użytkowników)
| Rola | Użytkownik | Hasło | Uprawnienia |
|------|------------|-------|-------------|
| `r_uczen` | `uczen_test` | Test1234 | Tylko podgląd słowników |
| `r_nauczyciel` | `nauczyciel_test` | Test1234 | + lekcje/oceny swoje |
| `r_sekretariat` | `sekretariat_test` | Test1234 | + CRUD uczniowie/grupy |
| `r_administrator` | `admin_test` | Test1234 | Pełne uprawnienia |
| `r_administrator` | `igor` | Igor1234 | Autor projektu |
| `r_administrator` | `mateusz` | Mateusz1234 | Autor projektu |

---

## 📋 WSZYSTKIE ZAŁOŻENIA PROJEKTOWE

### ⚠️ KAŻDE ZAŁOŻENIE = OGRANICZENIE W KODZIE

Prowadzący może zapytać o KAŻDE z tych założeń. Jeśli nie ma go w kodzie - problem!

---

## 🏫 A. STRUKTURA SZKOŁY

| ID | Założenie | Wartość | Gdzie w kodzie? |
|----|-----------|---------|-----------------|
| A1 | Typ szkoły | Prywatna z uprawnieniami publicznej | Dokumentacja |
| A2 | Cykl nauczania | 6-letni (klasy I-VI) | `cykl_nauczania NUMBER(1) DEFAULT 6` |
| A3 | Zakres projektu | **1 SEMESTR** (nie cały rok!) | Tabela `semestry` |
| A4 | Dni nauki | Poniedziałek - Piątek | ❌ **BRAK WALIDACJI!** |
| A5 | Godziny pracy | 14:00 - 20:00 | `trg_lekcja_godzina` (częściowo) |

### ⚠️ UWAGA: Założenie A4 (dni robocze) NIE JEST wymuszane!

---

## 👨‍🎓 B. UCZNIOWIE

| ID | Założenie | Wartość | Gdzie w kodzie? |
|----|-----------|---------|-----------------|
| B1 | Wiek minimalny | ❌ **BRAK** | Było w planie, nie ma w kodzie! |
| B2 | Klasa | 1-6 | `CHECK (klasa BETWEEN 1 AND 6)` |
| B3 | Cykl nauczania | 4 lub 6 lat | `CHECK (cykl_nauczania IN (4, 6))` |
| B4 | **TYP UCZNIA** | 3 wartości | `CHECK (typ_ucznia IN (...))` |
| B5 | Status | aktywny/zawieszony/absolwent/skreślony | `CHECK (status IN (...))` |
| B6 | Instrument główny | Dokładnie 1 (REF NOT NULL) | `ref_instrument SCOPE IS instrumenty` |
| B7 | Grupa | Opcjonalna | `ref_grupa SCOPE IS grupy` (może NULL) |
| B8 | Email | Unikalny, format walidowany | `UNIQUE`, `REGEXP_LIKE` |
| B9 | Telefon rodzica | Opcjonalny, format walidowany | `REGEXP_LIKE` |
| B10 | Klasa ≤ cykl | Nie może być kl.5 w cyklu 4-letnim | `trg_uczen_klasa_limit` |

### 🔴 KLUCZOWE: TYP UCZNIA (B4)
```
'uczacy_sie_w_innej_szkole' → lekcje TYLKO od 15:00
'ukonczyl_edukacje'         → lekcje od 14:00
'tylko_muzyczna'            → lekcje od 14:00
```
**To ZASTĘPUJE stary koncept "czy_dziecko" oparty na wieku!**

---

## 👨‍🏫 C. NAUCZYCIELE

| ID | Założenie | Wartość | Gdzie w kodzie? |
|----|-----------|---------|-----------------|
| C1 | Instrumenty | Max 5 (VARRAY) | `t_lista_instrumentow VARRAY(5)` |
| C2 | Min instrumentów | ❌ **BRAK WALIDACJI** (teoretycznie 1) | - |
| C3 | Prowadzi grupowe | Flaga T/N | `czy_prowadzi_grupowe CHAR(1)` |
| C4 | Jest akompaniatorem | Flaga T/N | `czy_akompaniator CHAR(1)` |
| C5 | Status | aktywny/nieaktywny/urlop | `CHECK (status IN (...))` |
| C6 | Email | Unikalny, wymagany | `NOT NULL`, `UNIQUE`, `REGEXP_LIKE` |
| C7 | Max godzin/dzień | ❌ **BRAK WALIDACJI** | Było w planie! |
| C8 | Max godzin/tydzień | ❌ **BRAK WALIDACJI** | Było w planie! |

---

## 🚪 D. SALE

| ID | Założenie | Wartość | Gdzie w kodzie? |
|----|-----------|---------|-----------------|
| D1 | Typ sali | indywidualna/grupowa/wielofunkcyjna | `CHECK (typ_sali IN (...))` |
| D2 | Pojemność | 1-50 osób | `CHECK (pojemnosc BETWEEN 1 AND 50)` |
| D3 | Wyposażenie | VARRAY(10) nazw | `wyposazenie t_lista_sprzetu` |
| D4 | Status | aktywna/remont/nieczynna | `CHECK (status IN (...))` |
| D5 | Numer | Unikalny | `UNIQUE (numer)` |

---

## 📚 E. PRZEDMIOTY

| ID | Założenie | Wartość | Gdzie w kodzie? |
|----|-----------|---------|-----------------|
| E1 | Typ zajęć | indywidualny/grupowy | `CHECK (typ_zajec IN (...))` |
| E2 | Czas trwania | 30/45/60/90 min | `CHECK (wymiar_minut IN (...))` |
| E3 | Zakres klas | od-do | `klasy_od`, `klasy_do`, CHECK |
| E4 | Obowiązkowy | T/N | `czy_obowiazkowy CHAR(1)` |
| E5 | Wymagany sprzęt | Opcjonalny tekst | `wymagany_sprzet VARCHAR2(100)` |
| E6 | Powiązanie z instrumentem | Opcjonalne REF | `ref_instrument` (może NULL) |

---

## 📅 F. LEKCJE (NAJWAŻNIEJSZE!)

| ID | Założenie | Wartość | Gdzie w kodzie? |
|----|-----------|---------|-----------------|
| F1 | Typ lekcji | indywidualna/grupowa | `CHECK (typ_lekcji IN (...))` |
| F2 | Czas trwania | 30/45/60/90 min | `CHECK (czas_trwania IN (...))` |
| F3 | Status | zaplanowana/odbyta/odwolana/przerwana | `CHECK (status IN (...))` |
| F4 | Godzina start | Format HH:MI | `REGEXP_LIKE` |
| F5 | **XOR: uczeń/grupa** | Dokładnie jedno z dwóch | `chk_lek_xor` |
| F6 | **Godzina wg typu ucznia** | 15:00 dla "uczacy_sie..." | `trg_lekcja_godzina_*` |
| F7 | Konflikt sali | ❌ **BRAK WALIDACJI** | Było w planie! |
| F8 | Konflikt nauczyciela | ❌ **BRAK WALIDACJI** | Było w planie! |
| F9 | Konflikt ucznia | ❌ **BRAK WALIDACJI** | Było w planie! |
| F10 | Dni robocze | ❌ **BRAK WALIDACJI** | Było w planie! |

### 🔴 CONSTRAINT XOR (F5)
```sql
CONSTRAINT chk_lek_xor CHECK (
    (ref_uczen IS NOT NULL AND ref_grupa IS NULL) OR
    (ref_uczen IS NULL AND ref_grupa IS NOT NULL)
)
```
**Lekcja MUSI mieć albo ucznia (indywidualna) albo grupę (grupowa), NIE OBA!**

---

## 📝 G. EGZAMINY

| ID | Założenie | Wartość | Gdzie w kodzie? |
|----|-----------|---------|-----------------|
| G1 | Typ | wstepny/promocyjny/semestralny/koncowy/poprawkowy/klasyfikacyjny | CHECK |
| G2 | Komisja | Minimum 2 nauczycieli | `ref_komisja1`, `ref_komisja2` NOT NULL |
| G3 | **Komisja różna** | Muszą być RÓŻNI | `trg_egzamin_komisja` |
| G4 | Ocena końcowa | 1-6 lub NULL | CHECK |
| G5 | Godzina wg typu ucznia | Analogicznie do lekcji | `trg_egzamin_godzina` |

---

## ⭐ H. OCENY

| ID | Założenie | Wartość | Gdzie w kodzie? |
|----|-----------|---------|-----------------|
| H1 | Wartość | 1-6 | `CHECK (wartosc BETWEEN 1 AND 6)` |
| H2 | Obszar | technika/interpretacja/sluch/teoria/rytm/ogolna | CHECK |
| H3 | Kompetencje nauczyciela | ❌ **BRAK WALIDACJI** | Było w planie! |

---

## 👥 I. GRUPY

| ID | Założenie | Wartość | Gdzie w kodzie? |
|----|-----------|---------|-----------------|
| I1 | Klasa | 1-6 | `CHECK (klasa BETWEEN 1 AND 6)` |
| I2 | Max uczniów | 5-30 | `CHECK (max_uczniow BETWEEN 5 AND 30)` |
| I3 | Nazwa unikalna w roku | Np. "1A" w "2025/2026" | `UNIQUE (nazwa, rok_szkolny)` |
| I4 | Status | aktywna/archiwalna | CHECK |

---

## 🎹 J. INSTRUMENTY

| ID | Założenie | Wartość | Gdzie w kodzie? |
|----|-----------|---------|-----------------|
| J1 | Kategoria | klawiszowe/strunowe/dete/perkusyjne | CHECK |
| J2 | Wymaga akompaniatora | T/N (smyczki = T) | `czy_wymaga_akompaniatora CHAR(1)` |
| J3 | Nazwa unikalna | | `UNIQUE (nazwa)` |

---

## 🗓️ K. SEMESTRY

| ID | Założenie | Wartość | Gdzie w kodzie? |
|----|-----------|---------|-----------------|
| K1 | Daty | data_koniec > data_start | CHECK |
| K2 | Rok szkolny | Format RRRR/RRRR | `REGEXP_LIKE(rok_szkolny, '^\d{4}/\d{4}$')` |

---

## ❌ BRAKUJĄCE WALIDACJE (potencjalne problemy!)

| Założenie z planu | Status |
|-------------------|--------|
| Minimalny wiek ucznia (6 lat) | ❌ BRAK |
| Dni robocze (Pn-Pt) | ❌ BRAK |
| Konflikt sali | ❌ BRAK (było w pkg_lekcja) |
| Konflikt nauczyciela | ❌ BRAK |
| Konflikt ucznia | ❌ BRAK |
| Max godzin nauczyciela/dzień | ❌ BRAK |
| Max godzin nauczyciela/tydzień | ❌ BRAK |
| Kompetencje nauczyciela przy ocenie | ❌ BRAK |
| Min 1 instrument dla nauczyciela | ❌ BRAK |

---

## 🎯 HEURYSTYKA PLANOWANIA (pkg_lekcja)

### Zasada: BIG ROCKS FIRST
```
1. Najpierw lekcje GRUPOWE (blokują duże sale i wielu uczniów)
2. Potem lekcje INDYWIDUALNE priorytetowe (uczniowie z innych szkół)
3. Na końcu pozostałe indywidualne
```

### Funkcje walidacyjne w pakiecie:
- `czy_nauczyciel_wolny()` - sprawdza konflikt
- `czy_sala_wolna()` - sprawdza konflikt  
- `czy_uczen_wolny()` - sprawdza konflikt
- `znajdz_slot()` - szuka wolnego terminu

### Główna procedura:
```sql
pkg_lekcja.generuj_plan_tygodnia(p_data_pn DATE, p_nadpisz CHAR)
```

---

## 📊 STAŁE W PROJEKCIE (KONSTANSY)

| Stała | Wartość | Uzasadnienie |
|-------|---------|--------------|
| Max instrumentów nauczyciela | 5 | VARRAY(5) |
| Max sprzętu w sali | 10 | VARRAY(10) |
| Cykle nauczania | 4 lub 6 lat | Zgodne z PSM |
| Klasy | I-VI | Cykl 6-letni |
| Pojemność sali | 1-50 | Realny zakres |
| Max uczniów w grupie | 5-30 | Realny zakres |
| Czas lekcji | 30/45/60/90 min | Standard |
| Skala ocen | 1-6 | Polska skala |
| Godziny pracy | 14:00-20:00 | Popołudnia (uczniowie w szkołach) |
| Dni nauki | Pn-Pt | Dni robocze |

---

## 🔧 CO MOŻNA UPROŚCIĆ?

### 1. Tabela SEMESTRY
- Obecnie: pełna tabela z sekwencją
- **Można:** Zamienić na jedną zmienną/parametr (zakres dat)
- **Ryzyko:** Prowadzący może pytać "po co tabela na 1 semestr?"

### 2. Tabela EGZAMINY
- Obecnie: pełna obsługa egzaminów
- **Można:** Usunąć jeśli "nie mamy czasu" na tę funkcjonalność
- **Ryzyko:** Zmniejsza wartość projektu

### 3. Heurystyka planowania
- Obecnie: pełny algorytm Big Rocks First
- **Można:** Uprościć do prostego "pierwszy wolny slot"
- **Ryzyko:** Słabsze planowanie

### 4. Walidacje konfliktów
- Obecnie: W pakiecie pkg_lekcja (ominięcie ORA-04091)
- **Problem:** Nie ma ich w triggerach - można wstawić konfliktujące dane bezpośrednio
- **Rozwiązanie:** Dodać triggery compound lub zostawić tylko przez pakiet

### 5. Role użytkowników
- Obecnie: 4 role, 6 użytkowników
- **Można:** Zmniejszyć do 2-3 ról
- **Ryzyko:** Mniej demonstracyjne

---

## 💡 REKOMENDACJE

### Co ZOSTAWIĆ (wartościowe):
1. ✅ 10 tabel - pokazuje obiektowość
2. ✅ 18 relacji REF - demonstracja Oracle Object
3. ✅ Trigger XOR na lekcjach - ciekawa logika
4. ✅ Trigger komisja egzaminu - prosta walidacja
5. ✅ Trigger godziny wg typu ucznia - biznesowa reguła
6. ✅ Heurystyka Big Rocks First - wyróżnik projektu
7. ✅ Widoki z DEREF - demonstracja rozwiązywania referencji

### Co ROZWAŻYĆ do usunięcia:
1. ❓ pkg_raport - może być zbędny
2. ❓ pkg_test - jeśli nie mamy testów, nie udawajmy
3. ❓ Zbyt szczegółowe założenia - lepiej mniej ale pewnych

### Co KONIECZNIE dodać:
1. ❗ Walidacja dni roboczych (Pn-Pt) - albo usunąć z założeń
2. ❗ Walidacja min wieku ucznia - albo usunąć z założeń
3. ❗ Dokumentacja co działa, a co nie

---

## 📝 PODSUMOWANIE DLA OBRONY

**Projekt to:** Obiektowa baza danych szkoły muzycznej na 1 semestr

**Główne cechy:**
- 10 tabel obiektowych
- 12 typów z 29 metodami
- 18 relacji REF (powiązania obiektowe)
- 2 VARRAY (instrumenty nauczyciela, sprzęt sali)
- Heurystyka układania planu lekcji
- 4 role użytkowników

**Kluczowe ograniczenia biznesowe:**
1. Uczniowie z innych szkół → lekcje od 15:00
2. Lekcja = uczeń XOR grupa (nie oba)
3. Komisja egzaminu = 2 różnych nauczycieli
4. Klasa ucznia ≤ cykl nauczania

**Czego NIE MA (świadomie):**
- Walidacji konfliktów czasowych w triggerach (przez ORA-04091)
- Walidacji dni roboczych
- Walidacji minimalnego wieku

---

*Dokument wygenerowany na podstawie analizy kodu v5*
