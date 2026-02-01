# 🔧 UPROSZCZENIA PROJEKTU - WYKONANE ✅

## Wersja: Luty 2026 | Status: ZAKOŃCZONE

---

# ✅ WYKONANE ZMIANY

## Pliki zmodyfikowane:
1. **ZALOZENIA_v4.md** - zaktualizowano założenia
2. **01_typy.sql** - usunięto T_KOMISJA, uproszczono T_LEKCJA
3. **02_tabele.sql** - usunięto typ_lekcji, status, komisja z LEKCJE
4. **03_pakiety.sql** - usunięto dodaj_egzamin, zmien_status_lekcji, egzaminy_*
5. **04_triggery.sql** - usunięto trg_komisja_rozni, trg_auto_status_lekcji, trg_typ_lekcji, trg_status_lekcji
6. **05_dane.sql** - usunięto sekcję "EGZAMINY DLA KLASY 6A"

---

# 1. ELEMENTY USUNIĘTE (WYKONANE ✅)

## 1.1 ❌ EGZAMINY - CAŁY PODSYSTEM

**Co usuwamy:**
- `typ_lekcji` (zwykła/egzamin) → **USUNĄĆ KOLUMNĘ**
- `komisja` (VARRAY 2 nauczycieli) → **USUNĄĆ KOLUMNĘ**
- `T_KOMISJA` typ VARRAY → **USUNĄĆ TYP**
- Trigger `trg_komisja_rozni` → **USUNĄĆ**
- Procedura `PKG_LEKCJE.dodaj_egzamin()` → **USUNĄĆ**
- Funkcje `egzaminy_ucznia()`, `egzaminy_nauczyciela()` → **USUNĄĆ**
- Metoda `czy_egzamin()` w T_LEKCJA → **USUNĄĆ**

**Dlaczego:**
- Dodatkowa warstwa abstrakcji
- Więcej rzeczy do tłumaczenia na egzaminie
- Komisja to dodatkowa walidacja (2 różni nauczyciele)
- Egzamin to po prostu lekcja z oceną semestralną

**Zastąpienie:** Ocena semestralna (`czy_semestralna = 'T'`) wystarczy do oznaczenia "egzaminu"

---

## 1.2 ❌ STATUS LEKCJI

**Co usuwamy:**
- Kolumna `status` (zaplanowana/odbyta/odwołana) → **USUNĄĆ**
- Trigger `trg_auto_status_lekcji` → **USUNĄĆ**
- Trigger `trg_status_lekcji` → **USUNĄĆ**
- Procedura `zmien_status_lekcji()` → **USUNĄĆ**

**Dlaczego:**
- Komplikuje zapytania (WHERE status != 'odwolana')
- Wymaga dodatkowej logiki biznesowej
- Na egzaminie pytanie "a co jeśli lekcja odwołana?" = problemy

**Zastąpienie:** Lekcja istnieje = jest zaplanowana. Usunięcie = odwołanie.

---

## 1.3 ❌ TYP LEKCJI

**Co usuwamy:**
- Kolumna `typ_lekcji` (zwykła/egzamin) → **już usunięte z egzaminami**
- Trigger `trg_typ_lekcji` → **USUNĄĆ**

---

# 2. ELEMENTY DO ROZWAŻENIA (OPCJONALNE)

## 2.1 ⚠️ OBSZAR OCENY

**Obecny stan:**
```sql
obszar VARCHAR2(50) -- technika, interpretacja, postepy, teoria, sluch, ogolna
```

**Propozycja:** Usunąć lub zostawić tylko `ogolna`

**Argumenty ZA usunięciem:**
- Mniej walidacji
- Prostsze INSERT
- Na egzaminie mniej do tłumaczenia

**Argumenty PRZECIW:**
- To tylko 1 kolumna
- Pokazuje użycie CHECK constraint
- Daje sens pedagogiczny

**Decyzja:** ZOSTAWIĆ (mała komplikacja, duża wartość demonstracyjna)

---

## 2.2 ⚠️ VARRAY WYPOSAŻENIA SALI

**Obecny stan:**
```sql
wyposazenie T_WYPOSAZENIE -- VARRAY(10) OF VARCHAR2(50)
```

**Propozycja:** Uprościć do 1-2 kluczowych elementów lub usunąć walidację

**Argumenty ZA uproszczeniem:**
- Walidacja wyposażenia to dużo kodu
- `waliduj_wyposazenie_sali()` jest skomplikowana

**Argumenty PRZECIW:**
- VARRAY to wymaganie projektu obiektowego
- Pokazuje użycie kolekcji

**Decyzja:** ZOSTAWIĆ ALE uprościć walidację (soft check zamiast hard error)

---

## 2.3 ⚠️ VARRAY INSTRUMENTÓW NAUCZYCIELA

**Obecny stan:**
```sql
instrumenty T_INSTRUMENTY_TAB -- VARRAY(5) OF VARCHAR2(50)
```

**Propozycja:** Uprościć - nauczyciel uczy 1 instrumentu

**Argumenty ZA:**
- Prostsze zapytania
- Mniej iteracji w pętlach

**Argumenty PRZECIW:**
- VARRAY to kluczowy element obiektowy
- W rzeczywistości nauczyciel może uczyć kilku instrumentów

**Decyzja:** ZOSTAWIĆ (kluczowa funkcjonalność obiektowa)

---

## 2.4 ⚠️ GODZINY PRACY (14:00-20:00)

**Obecny stan:**
- Walidacja w `waliduj_godziny_pracy()`
- Sprawdzanie czy lekcja nie kończy się po 21:00

**Propozycja:** Usunąć walidację godzin

**Argumenty ZA:**
- Mniej błędów przy testowaniu
- Prostsze demo

**Argumenty PRZECIW:**
- Pokazuje regułę biznesową
- Prosty trigger/procedura

**Decyzja:** ZOSTAWIĆ ale złagodzić (np. 08:00-22:00)

---

## 2.5 ⚠️ DNI TYGODNIA (pon-pt)

**Obecny stan:**
- Walidacja `waliduj_dzien_tygodnia()`
- Blokuje sobotę/niedzielę

**Propozycja:** Usunąć walidację

**Decyzja:** ZOSTAWIĆ (prosta walidacja, realistyczna reguła)

---

# 3. CO ZOSTAWIĆ (KLUCZOWE)

## 3.1 ✅ STRUKTURA 8 TABEL
- INSTRUMENTY
- PRZEDMIOTY
- NAUCZYCIELE
- GRUPY
- UCZNIOWIE
- SALE
- LEKCJE (uproszczone)
- OCENY

## 3.2 ✅ TYPY OBIEKTOWE (8 typów)
- T_INSTRUMENT
- T_PRZEDMIOT
- T_NAUCZYCIEL
- T_GRUPA
- T_SALA
- T_UCZEN
- T_LEKCJA (uproszczony)
- T_OCENA

## 3.3 ✅ KOLEKCJE VARRAY (2 typy)
- T_INSTRUMENTY_TAB (instrumenty nauczyciela)
- T_WYPOSAZENIE (wyposażenie sali)

## 3.4 ✅ REFERENCJE REF
- UCZNIOWIE → GRUPY
- UCZNIOWIE → INSTRUMENTY
- LEKCJE → PRZEDMIOTY
- LEKCJE → NAUCZYCIELE
- LEKCJE → SALE
- LEKCJE → UCZNIOWIE (dla indywidualnych)
- LEKCJE → GRUPY (dla grupowych)
- OCENY → UCZNIOWIE
- OCENY → NAUCZYCIELE
- OCENY → PRZEDMIOTY

## 3.5 ✅ CONSTRAINT XOR
- Lekcja jest ALBO indywidualna (ref_uczen) ALBO grupowa (ref_grupa)
- Kluczowy element logiki biznesowej

## 3.6 ✅ WALIDACJE KONFLIKTÓW
- Sala wolna w danym terminie
- Nauczyciel wolny w danym terminie
- Uczeń wolny w danym terminie
- **TO JEST SERCE SYSTEMU PLANOWANIA**

## 3.7 ✅ HEURYSTYKA PLANOWANIA
- Automatyczne przydzielanie nauczyciela
- Automatyczne znajdowanie wolnej sali
- Generowanie planu tygodnia
- **TO JEST NAJCIEKAWSZA CZĘŚĆ PROJEKTU**

---

# 4. PODSUMOWANIE ZMIAN

## 4.1 TABELA LEKCJE - PRZED vs PO

### PRZED (skomplikowane):
```sql
CREATE TABLE LEKCJE OF T_LEKCJA (
    id_lekcji           PRIMARY KEY,
    ref_przedmiot       NOT NULL,
    ref_nauczyciel      NOT NULL,
    ref_sala            NOT NULL,
    ref_uczen           -- NULL dla grupowych
    ref_grupa           -- NULL dla indywidualnych
    data_lekcji         NOT NULL,
    godzina_start       NOT NULL,
    czas_trwania_min    NOT NULL,
    typ_lekcji          NOT NULL,      -- ❌ USUNĄĆ
    status              NOT NULL,      -- ❌ USUNĄĆ
    komisja             T_KOMISJA      -- ❌ USUNĄĆ
);
```

### PO (uproszczone):
```sql
CREATE TABLE LEKCJE OF T_LEKCJA (
    id_lekcji           PRIMARY KEY,
    ref_przedmiot       NOT NULL,
    ref_nauczyciel      NOT NULL,
    ref_sala            NOT NULL,
    ref_uczen           -- NULL dla grupowych
    ref_grupa           -- NULL dla indywidualnych
    data_lekcji         NOT NULL,
    godzina_start       NOT NULL,
    czas_trwania_min    NOT NULL
);
```

## 4.2 TYP T_LEKCJA - PRZED vs PO

### PRZED:
```sql
CREATE TYPE T_LEKCJA AS OBJECT (
    id_lekcji           NUMBER,
    ref_przedmiot       REF T_PRZEDMIOT,
    ref_nauczyciel      REF T_NAUCZYCIEL,
    ref_sala            REF T_SALA,
    ref_uczen           REF T_UCZEN,
    ref_grupa           REF T_GRUPA,
    data_lekcji         DATE,
    godzina_start       VARCHAR2(5),
    czas_trwania_min    NUMBER,
    typ_lekcji          VARCHAR2(20),   -- ❌ USUNĄĆ
    status              VARCHAR2(20),   -- ❌ USUNĄĆ
    komisja             T_KOMISJA,      -- ❌ USUNĄĆ

    MEMBER FUNCTION godzina_koniec RETURN VARCHAR2,
    MEMBER FUNCTION czy_indywidualna RETURN BOOLEAN,
    MEMBER FUNCTION czy_egzamin RETURN BOOLEAN  -- ❌ USUNĄĆ
);
```

### PO:
```sql
CREATE TYPE T_LEKCJA AS OBJECT (
    id_lekcji           NUMBER,
    ref_przedmiot       REF T_PRZEDMIOT,
    ref_nauczyciel      REF T_NAUCZYCIEL,
    ref_sala            REF T_SALA,
    ref_uczen           REF T_UCZEN,
    ref_grupa           REF T_GRUPA,
    data_lekcji         DATE,
    godzina_start       VARCHAR2(5),
    czas_trwania_min    NUMBER,

    MEMBER FUNCTION godzina_koniec RETURN VARCHAR2,
    MEMBER FUNCTION czy_indywidualna RETURN BOOLEAN
);
```

---

# 5. TRIGGERY - CO ZOSTAJE

## ✅ ZOSTAWIĆ:
1. `trg_lekcja_xor` - XOR uczeń/grupa (KLUCZOWY)
2. `trg_ocena_zakres` - ocena 1-6 (PROSTY)
3. `trg_format_godziny` - format HH:MI (PROSTY)
4. `trg_czas_trwania` - 30/45/60/90 min (PROSTY)
5. `trg_obszar_oceny` - walidacja obszaru (OPCJONALNY)
6. `trg_czy_semestralna` - flaga T/N (PROSTY)

## ❌ USUNĄĆ:
1. `trg_komisja_rozni` - nie ma egzaminów
2. `trg_auto_status_lekcji` - nie ma statusu
3. `trg_status_lekcji` - nie ma statusu
4. `trg_typ_lekcji` - nie ma typu

---

# 6. PAKIETY - CO ZOSTAJE

## PKG_SLOWNIKI ✅ BEZ ZMIAN

## PKG_OSOBY ✅ BEZ ZMIAN

## PKG_LEKCJE - UPROSZCZONY

### ❌ USUNĄĆ:
- `dodaj_egzamin()`
- `zmien_status_lekcji()`
- `egzaminy_ucznia()`
- `egzaminy_nauczyciela()`

### ✅ ZOSTAWIĆ:
- `dodaj_lekcje_indywidualna()`
- `dodaj_lekcje_grupowa()`
- `czy_sala_wolna()`
- `czy_nauczyciel_wolny()`
- `czy_uczen_wolny()`
- `waliduj_wyposazenie_sali()`
- `waliduj_nauczyciel_przedmiot()`
- `waliduj_uczen_przedmiot()`
- `waliduj_godziny_pracy()`
- `waliduj_dzien_tygodnia()`
- `plan_ucznia()`
- `plan_sali()`
- `plan_nauczyciela()`
- `plan_grupy()`
- `znajdz_nauczyciela_heurystyka()`
- `przydziel_lekcje_indywidualna()`
- `generuj_lekcje_indywidualne_tydzien()`
- `generuj_lekcje_grupowe_tydzien()`
- `generuj_plan_tygodnia()`

## PKG_OCENY ✅ BEZ ZMIAN

## PKG_RAPORTY ✅ BEZ ZMIAN

---

# 7. DANE TESTOWE - UPROSZCZENIE

## ❌ USUNĄĆ:
- Sekcję "EGZAMINY DLA KLASY 6A"

## ✅ ZOSTAWIĆ:
- Instrumenty (5)
- Przedmioty (10)
- Sale (15)
- Grupy (6)
- Nauczyciele (15)
- Uczniowie (48)
- Generowanie planu (4 tygodnie)
- Oceny przykładowe

---

# 8. CO MUSI DZIAŁAĆ NA DEMO (UPROSZCZONE)

1. **Dodaj nowego ucznia do klasy 2A**
   → System przypisuje go do grupy, znajduje 2 sloty na instrument

2. **Pokaż plan tygodnia ucznia Jana Kowalskiego**
   → Lista: 2× fortepian, 2× kształcenie słuchu, 1× rytmika

3. **Pokaż plan grupy 3A na środę**
   → Kształcenie słuchu 15:00-15:45, sala 201

4. **Pokaż obłożenie sali 101 w poniedziałek**
   → Lista lekcji fortepianu z godzinami i nazwiskami

5. **Wstaw ocenę dla ucznia**
   → Nauczyciel → uczeń → przedmiot → obszar → wartość 1-6

6. ~~Stwórz egzamin~~ → **USUNIĘTE**

7. **Spróbuj dodać konfliktującą lekcję**
   → System odmawia (sala/nauczyciel/uczeń zajęty)

8. **Uruchom heurystykę planowania**
   → System układa plan dla nowej grupy

---

# 9. KORZYŚCI Z UPROSZCZEŃ

| Aspekt | Przed | Po | Zysk |
|--------|-------|-----|------|
| Kolumny w LEKCJE | 12 | 9 | -3 kolumny |
| Typy VARRAY | 3 | 2 | -1 typ |
| Triggery | 11 | 6 | -5 triggerów |
| Procedury w PKG_LEKCJE | ~20 | ~16 | -4 procedury |
| Sekcje danych testowych | 10 | 9 | -1 sekcja |
| Rzeczy do tłumaczenia | Dużo | Mniej | Spokojniejszy egzamin |

---

# 10. UWAGI DO ZAŁOŻEŃ (ZALOZENIA_v4.md)

## Sekcje do USUNIĘCIA:
- 3.10 EGZAMINY (cała sekcja)
- W 3.9: "Typ lekcji: zwykła, egzamin" → USUNĄĆ
- W 3.9: "Status lekcji: zaplanowana, odbyta, odwołana" → USUNĄĆ
- W 3.9: "Lekcja typu 'egzamin' ma dodatkowe pole: komisja" → USUNĄĆ
- W 3.6: "Nauczyciel uczestniczy w komisjach egzaminacyjnych" → USUNĄĆ

## Sekcje do MODYFIKACJI:
- 6.4 WALIDACJE: usunąć W8 (komisja), usunąć W4/W5 jeśli rezygnujemy z walidacji godzin/dni
- 6.5 SCENARIUSZE BŁĘDÓW: usunąć błędy związane z egzaminami

## Dodać sekcję:
- "ŚWIADOME UPROSZCZENIA" - lista rzeczy które pominęliśmy dla prostoty

---

*Dokument: Propozycje uproszczeń*
*Autorzy: Igor Typiński, Mateusz Mróz*
