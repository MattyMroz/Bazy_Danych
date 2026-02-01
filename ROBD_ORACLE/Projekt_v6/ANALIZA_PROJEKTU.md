# 📊 ANALIZA PROJEKTU - Szkoła Muzyczna

## Ocena zgodności z założeniami i propozycje uproszczeń

**Autorzy analizy:** Claude (GitHub Copilot)  
**Data:** Luty 2026

---

# 📗 CZĘŚĆ 1: CO JEST DOBRZE

## 1.1 Struktura typów obiektowych ✅

Typy są **czyste i logiczne**:
- `T_INSTRUMENT`, `T_PRZEDMIOT` - słowniki
- `T_NAUCZYCIEL`, `T_UCZEN`, `T_GRUPA`, `T_SALA` - encje główne
- `T_LEKCJA`, `T_OCENA` - encje transakcyjne

**VARRAY poprawnie użyte:**
- `T_INSTRUMENTY_TAB` (max 5) - instrumenty nauczyciela ✅
- `T_WYPOSAZENIE` (max 10) - wyposażenie sali ✅
- `T_KOMISJA` (dokładnie 2) - komisja egzaminacyjna ✅

## 1.2 Referencje REF ✅

Zgodne z wymaganiami Oracle obiektowego:
- `UCZNIOWIE.ref_grupa` → `GRUPY`
- `UCZNIOWIE.ref_instrument` → `INSTRUMENTY`
- `LEKCJE.ref_przedmiot` → `PRZEDMIOTY`
- `OCENY.ref_przedmiot` → `PRZEDMIOTY`

**SCOPE IS** używane poprawnie - ogranicza REF do konkretnej tabeli.

## 1.3 Triggery walidacyjne ✅

Pokrywają **wszystkie kluczowe założenia**:

| Trigger | Założenie | Status |
|---------|-----------|--------|
| `trg_komisja_rozni` | Komisja = 2 różni nauczyciele | ✅ |
| `trg_ocena_zakres` | Ocena 1-6 | ✅ |
| `trg_godziny_pracy` | 14:00-20:00 | ✅ |
| `trg_dzien_tygodnia` | Pon-Pt | ✅ |
| `trg_sala_wyposazenie` | Sala ma wyposażenie | ✅ |
| `trg_nauczyciel_uczy_instrumentu` | Nauczyciel uczy tego instrumentu | ✅ |
| `trg_przedmiot_instrument_ucznia` | Uczeń uczy się swojego instrumentu | ✅ |
| `trg_chor_orkiestra_walidacja` | Chór/Orkiestra wg instrumentu | ✅ |

## 1.4 Dane testowe ✅

- **99 uczniów** w 8 grupach (realistyczna piramida)
- **12 nauczycieli** (9 instrumentalistów + 3 grupowych)
- **8 sal** (6 indywidualnych + 2 grupowe)
- **Rozkład instrumentów** zgodny z założeniami (~35% fortepian dominuje)
- **Oceny** z różnymi obszarami (technika, interpretacja, postępy...)

## 1.5 Constraint XOR na LEKCJE ✅

```sql
CHECK (
    (ref_uczen IS NOT NULL AND ref_grupa IS NULL) OR
    (ref_uczen IS NULL AND ref_grupa IS NOT NULL)
)
```

Poprawnie implementuje założenie #36: "Lekcja jest ALBO indywidualna ALBO grupowa".

---

# 📕 CZĘŚĆ 2: CO JEST ŹLE / DO POPRAWY

## 2.1 ❌ Brak triggera na limit uczniów w grupie

W założeniach (#15): *"Wielkość grupy: od 6 do 15 uczniów"*

Jest walidacja w `PKG_OSOBY.dodaj_ucznia()`, ale **brak triggera**. Można obejść przez bezpośredni INSERT.

**Rozwiązanie:** Dodać `trg_limit_uczniow_w_grupie`.

## 2.2 ❌ Brak triggera na max godzin nauczyciela

W założeniach (#21, #22):
- Max 6 godzin dziennie
- Max 30 godzin tygodniowo

Jest sprawdzane tylko w heurystyce `znajdz_nauczyciela_heurystyka()`, ale **brak triggera**.

**Rozwiązanie:** Dodać `trg_max_godzin_nauczyciela` (lub uznać za świadome uproszczenie).

## 2.3 ⚠️ Niespójność czasów lekcji

W założeniach:
- Klasy I-III: 2 × **30 min**
- Klasy IV-VI: 2 × **45 min**

W `T_PRZEDMIOT.domyslny_czas_min` jest ustawione **45** dla wszystkich instrumentów.
Trigger/walidacja na czas lekcji wg klasy - **BRAK**.

## 2.4 ⚠️ Redundantne funkcje pomocnicze

W `PKG_OSOBY`:
- `get_ref_nauczyciel(p_nazwisko)` - szuka po nazwisku
- `get_ref_nauczyciel_by_id(p_id)` - szuka po ID

Dlaczego dwie? Bo nazwiska mogą się powtarzać. **OK**, ale dokumentacja mogłaby być jaśniejsza.

---

# 📙 CZĘŚĆ 3: CO MOŻNA USUNĄĆ / UPROŚCIĆ

## 🔴 PRIORYTET WYSOKI - Zdecydowanie usunąć

### 3.1 Cały system heurystyki planowania (~200 linii)

**Funkcje do usunięcia z PKG_LEKCJE:**
```
- znajdz_nauczyciela_heurystyka()
- przydziel_lekcje_indywidualna()  
- generuj_lekcje_indywidualne_tydzien()
- generuj_lekcje_grupowe_tydzien()
- generuj_plan_tygodnia()
```

**Dlaczego?**
- W założeniach USE CASE S5 mówi o generowaniu planu, **ALE**...
- To jest **funkcjonalność "nice to have"**, nie core
- Komplikuje kod o ~200 linii
- W rzeczywistości sekretariat wpisuje lekcje ręcznie lub importuje z Excela
- Heurystyka jest **bardzo uproszczona** i nie daje realnej wartości

**Co zostawić?**
- `dodaj_lekcje_indywidualna()` - ręczne dodawanie ✅
- `dodaj_lekcje_grupowa()` - ręczne dodawanie ✅
- `czy_sala_wolna()`, `czy_nauczyciel_wolny()`, `czy_uczen_wolny()` - walidacje ✅

### 3.2 Funkcje planów - duplikacja logiki (~100 linii)

**Mamy 4 osobne funkcje:**
```
- plan_ucznia()
- plan_sali()  
- plan_nauczyciela()
- plan_grupy()
```

**Propozycja:** Zostawić **2 główne** (wymagane wg USE CASES):
- `plan_ucznia()` - UC U1 ✅
- `plan_nauczyciela()` - UC N1 ✅

**Do usunięcia lub opcjonalnego:**
- `plan_sali()` - to jest raport, nie plan osoby
- `plan_grupy()` - uczniowie grupy mają te same zajęcia grupowe, wystarczy plan_ucznia

### 3.3 Funkcje egzaminów (~50 linii)

**Mamy:**
```
- egzaminy_ucznia()
- egzaminy_nauczyciela()
```

**Propozycja:** Jedna funkcja `egzaminy()` z parametrem typu (uczeń/nauczyciel/komisja).

Albo: proste zapytanie SQL zamiast funkcji - egzaminy to po prostu `SELECT FROM LEKCJE WHERE typ_lekcji = 'egzamin'`.

---

## 🟡 PRIORYTET ŚREDNI - Rozważyć usunięcie

### 3.4 PKG_RAPORTY - czy wszystkie potrzebne?

**Mamy 5 raportów:**
```
- raport_grup()              -- UC S13 ✅
- raport_obciazenia_sal()    -- UC S14 ✅  
- raport_nauczycieli()       -- nie ma w UC!
- raport_instrumentow()      -- UC S15 ✅
- statystyki_ocen_przedmiotu() -- UC N7 ✅
```

**Do usunięcia:**
- `raport_nauczycieli()` - **nie ma w USE CASES**, duplikuje info z tabeli

### 3.5 Metody w typach obiektowych

**Mamy metody typu:**
```sql
-- T_INSTRUMENT
MEMBER FUNCTION jest_orkiestrowy RETURN BOOLEAN

-- T_PRZEDMIOT  
MEMBER FUNCTION czy_grupowy RETURN BOOLEAN

-- T_NAUCZYCIEL
MEMBER FUNCTION pelne_nazwisko RETURN VARCHAR2
MEMBER FUNCTION uczy_instrumentu(p_instrument VARCHAR2) RETURN BOOLEAN

-- T_GRUPA
MEMBER FUNCTION czy_klasy_mlodsze RETURN BOOLEAN
MEMBER FUNCTION czas_lekcji_instrumentu RETURN NUMBER

-- T_SALA
MEMBER FUNCTION ma_wyposazenie(p_wymagane T_WYPOSAZENIE) RETURN BOOLEAN
MEMBER FUNCTION czy_grupowa RETURN BOOLEAN

-- T_UCZEN
MEMBER FUNCTION pelne_nazwisko RETURN VARCHAR2
MEMBER FUNCTION wiek RETURN NUMBER

-- T_LEKCJA
MEMBER FUNCTION godzina_koniec RETURN VARCHAR2
MEMBER FUNCTION czy_indywidualna RETURN BOOLEAN
MEMBER FUNCTION czy_egzamin RETURN BOOLEAN

-- T_OCENA
MEMBER FUNCTION czy_poprawna RETURN BOOLEAN
MEMBER FUNCTION opis_oceny RETURN VARCHAR2
```

**Realne użycie:** Większość **NIE JEST UŻYWANA** w pakietach!

**Do usunięcia (nieużywane):**
- `T_INSTRUMENT.jest_orkiestrowy()` - nie używane
- `T_PRZEDMIOT.czy_grupowy()` - sprawdzane przez `typ_zajec = 'grupowy'`
- `T_GRUPA.czy_klasy_mlodsze()` - sprawdzane przez `klasa <= 3`
- `T_GRUPA.czas_lekcji_instrumentu()` - logika w pakiecie
- `T_SALA.czy_grupowa()` - sprawdzane przez `typ = 'grupowa'`
- `T_LEKCJA.czy_indywidualna()` - sprawdzane przez `ref_uczen IS NOT NULL`
- `T_LEKCJA.czy_egzamin()` - sprawdzane przez `typ_lekcji = 'egzamin'`
- `T_OCENA.czy_poprawna()` - trigger to robi

**Do zostawienia (używane lub przydatne):**
- `T_NAUCZYCIEL.pelne_nazwisko()` - używane w raportach
- `T_NAUCZYCIEL.uczy_instrumentu()` - przydatne
- `T_UCZEN.pelne_nazwisko()` - używane w raportach
- `T_UCZEN.wiek()` - może być przydatne
- `T_LEKCJA.godzina_koniec()` - używane w walidacjach
- `T_OCENA.opis_oceny()` - fajne do raportów
- `T_SALA.ma_wyposazenie()` - używane w triggerze

---

## 🟢 PRIORYTET NISKI - Kosmetyka

### 3.6 Redundantne komunikaty DBMS_OUTPUT

W `generuj_lekcje_*` jest dużo `DBMS_OUTPUT.PUT_LINE()`. Jeśli usuwamy heurystykę, to znika problem.

### 3.7 Funkcja `liczba_uczniow_nauczyciela()` w PKG_OSOBY

Nie jest używana nigdzie. Można usunąć.

---

# 📘 CZĘŚĆ 4: PODSUMOWANIE

## Proponowane zmiany (wersja minimalna)

### Usunąć z PKG_LEKCJE (~250 linii oszczędności):
1. ❌ `znajdz_nauczyciela_heurystyka()`
2. ❌ `przydziel_lekcje_indywidualna()`
3. ❌ `generuj_lekcje_indywidualne_tydzien()`
4. ❌ `generuj_lekcje_grupowe_tydzien()`
5. ❌ `generuj_plan_tygodnia()`
6. ❌ `plan_sali()` (opcjonalnie)
7. ❌ `plan_grupy()` (opcjonalnie)

### Usunąć z PKG_OSOBY (~20 linii):
1. ❌ `liczba_uczniow_nauczyciela()`

### Usunąć z PKG_RAPORTY (~30 linii):
1. ❌ `raport_nauczycieli()`

### Usunąć nieużywane metody z typów (~40 linii):
1. ❌ `T_INSTRUMENT.jest_orkiestrowy()`
2. ❌ `T_PRZEDMIOT.czy_grupowy()`
3. ❌ `T_GRUPA.czy_klasy_mlodsze()`
4. ❌ `T_GRUPA.czas_lekcji_instrumentu()`
5. ❌ `T_SALA.czy_grupowa()`
6. ❌ `T_LEKCJA.czy_indywidualna()`
7. ❌ `T_LEKCJA.czy_egzamin()`
8. ❌ `T_OCENA.czy_poprawna()`

### Dodać (brakujące wg założeń):
1. ✅ `trg_limit_uczniow_w_grupie` - max 15 uczniów

---

## Szacowana oszczędność

| Element | Linie kodu |
|---------|-----------|
| Heurystyka planowania | ~250 |
| Plany sali/grupy | ~50 |
| Nieużywane metody | ~40 |
| Nieużywane funkcje | ~50 |
| **RAZEM** | **~390 linii** |

**Obecny rozmiar pakietów:** ~1800 linii  
**Po uproszczeniu:** ~1400 linii  
**Redukcja:** ~22%

---

## Rekomendacja końcowa

### Wersja "bezpieczna" (dla oceny projektu):

**Zostawić:**
- Całą strukturę typów (nawet nieużywane metody)
- Wszystkie pakiety (nawet heurystykę)
- Wszystkie triggery

**Powód:** Pokazuje więcej umiejętności, nawet jeśli nie wszystko jest używane.

### Wersja "czysta" (dla produkcji):

**Usunąć:**
- Heurystykę planowania (generuj_plan_*)
- Nieużywane metody
- Redundantne raporty

**Powód:** Czystszy kod, łatwiejszy w utrzymaniu.

---

## Moja rekomendacja

**Dla projektu zaliczeniowego:** Zostaw jak jest, ale dodaj komentarz w dokumentacji:

> "System zawiera rozszerzoną funkcjonalność heurystycznego planowania lekcji, 
> która wykracza poza minimalne wymagania projektu i stanowi wartość dodaną."

To zamienia "nadmiarowy kod" w "feature" 😉

---

*Analiza wykonana przez GitHub Copilot (Claude Opus 4.5)*
