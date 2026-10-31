# NOTATKA - Obiektowa Baza Danych: Szkoła Muzyczna v3.2

## Autorzy
- Igor Typiński (251237)
- Mateusz Mróz (251190)

---

## ⚠️ WYKRYTE I NAPRAWIONE BŁĘDY

### 🔴 BŁĄD KRYTYCZNY: Mutating Table Error (ORA-04091)

**Problem:** W pliku `04_triggery.sql` triggery ROW LEVEL próbują czytać z tabeli `t_lekcja` podczas INSERT/UPDATE na tej samej tabeli. Oracle blokuje to błędem ORA-04091.

**Dotknięte triggery:**
- `trg_lekcja_limit_nauczyciela`
- `trg_lekcja_limit_ucznia`
- `trg_lekcja_konflikt_sali`
- `trg_lekcja_konflikt_nauczyciela`
- `trg_lekcja_konflikt_ucznia`

**Rozwiązanie:** Użycie **COMPOUND TRIGGER** - zbieramy dane w fazie BEFORE EACH ROW, walidujemy w fazie AFTER STATEMENT (wtedy tabela już nie jest mutating).

**Plik z poprawką:** `04_triggery_POPRAWIONE.sql`

**POPRAWKA v3.2:** Naprawiono błąd logiczny w warunkach IF - dodano bieżącą wartość do sumy: `v_suma_minut + v_nowe_lekcje(i).czas_trwania > 360` oraz `v_liczba_lekcji + 1 > 2`.

---

### 🟡 BŁĄD: COMMIT w procedurach pakietów

**Problem:** Procedury `pkg_uczen.dodaj()`, `pkg_lekcja.zaplanuj()`, `pkg_ocena.dodaj()` itp. zawierały `COMMIT`. To uniemożliwia łączenie operacji w jedną transakcję i rollback przy błędzie.

**Rozwiązanie:** Usunięto `COMMIT` z procedur - o transakcji decyduje wywołujący.

**Plik z poprawką:** `03_pakiety_POPRAWIONE.sql`

---

### 🟡 BŁĄD: Dangling REF przy usuwaniu

**Problem:** Triggery blokady usuwania sprawdzały tylko lekcje `'zaplanowana'`. Po usunięciu ucznia/nauczyciela rekordy historyczne (odbyte lekcje) miałyby "wiszące" referencje (DEREF zwraca NULL).

**Rozwiązanie:** Blokada usuwania dla WSZYSTKICH powiązanych rekordów (nie tylko zaplanowanych).

---

### 🟡 BŁĄD: Brak walidacji kompetencji nauczyciela

**Problem:** System pozwalał zapisać nauczyciela do lekcji instrumentu, którego nie ma w swoim VARRAY `instrumenty`.

**Rozwiązanie:** Dodano walidację w `pkg_lekcja.zaplanuj()` - sprawdzenie przez `TABLE(n.instrumenty)` czy nauczyciel ma kompetencje.

**Plik z poprawką:** `03_pakiety_POPRAWIONE.sql` (v3.2)

---

## KOLEJNOŚĆ URUCHAMIANIA SKRYPTÓW

### Wersja ORYGINALNA (z błędami):
```
1. 01_typy.sql        -- Typy obiektowe i kolekcje
2. 02_tabele.sql      -- Tabele obiektowe i sekwencje
3. 03_pakiety.sql     -- Pakiety PL/SQL (⚠️ ma COMMIT w procedurach)
4. 04_triggery.sql    -- Wyzwalacze (⚠️ Mutating Table Error!)
5. 05_dane.sql        -- Dane testowe
6. 06_testy.sql       -- Testy jednostkowe
7. 07_uzytkownicy.sql -- Role i użytkownicy (WYMAGA DBA!)
```

### Wersja POPRAWIONA (zalecana):
```
1. 01_typy.sql                  -- Typy obiektowe i kolekcje
2. 02_tabele.sql                -- Tabele obiektowe i sekwencje
3. 03_pakiety_POPRAWIONE.sql    -- Pakiety PL/SQL (bez COMMIT)
4. 04_triggery_POPRAWIONE.sql   -- Wyzwalacze (COMPOUND TRIGGER)
5. 05_dane.sql                  -- Dane testowe
6. 06_testy.sql                 -- Testy jednostkowe
7. 07_uzytkownicy.sql           -- Role i użytkownicy (WYMAGA DBA!)
```

---

## CO SIĘ DZIEJE W KAŻDYM PLIKU

### 1️⃣ 01_typy.sql - TYPY OBIEKTOWE

**Czyszczenie:**
- DROP wszystkich tabel i typów (w odpowiedniej kolejności zależności)
- Używa `EXCEPTION WHEN OTHERS THEN NULL` aby nie przerywać przy braku obiektu

**Typy (8 sztuk):**

| Typ | Opis | Metody |
|-----|------|--------|
| `t_instrument_obj` | Instrument muzyczny | `opis()` |
| `t_lista_instrumentow` | VARRAY(5) - max 5 instrumentów nauczyciela | - |
| `t_sala_obj` | Sala lekcyjna z wyposażeniem | `opis_pelny()` |
| `t_nauczyciel_obj` | Nauczyciel z listą instrumentów (VARRAY) | `pelne_dane()`, `lata_stazu()`, `liczba_instrumentow()` |
| `t_uczen_obj` | Uczeń szkoły | `wiek()`, `pelne_dane()`, `czy_pelnoletni()`, `czy_dziecko()` |
| `t_kurs_obj` | Kurs z REF do instrumentu | `info()` |
| `t_lekcja_obj` | Lekcja z 4x REF | `czas_txt()`, `czy_odbyta()` |
| `t_ocena_obj` | Ocena z 2x REF | `ocena_slownie()`, `czy_pozytywna()` |

**Kluczowe elementy:**
- **VARRAY** - `t_lista_instrumentow` (kolekcja max 5 nazw instrumentów)
- **REF** - Referencje obiektowe (np. lekcja -> uczeń, nauczyciel, kurs, sala)
- **Metody MEMBER FUNCTION** - obliczenia na poziomie obiektu

---

### 2️⃣ 02_tabele.sql - TABELE OBIEKTOWE

**Sekwencje (7):**
- `seq_instrument`, `seq_sala`, `seq_nauczyciel`, `seq_uczen`
- `seq_kurs`, `seq_lekcja`, `seq_ocena`

**Tabele obiektowe (7):**

| Tabela | Typ bazowy | Kluczowe ograniczenia |
|--------|-----------|----------------------|
| `t_instrument` | `t_instrument_obj` | kategoria IN ('dete', 'strunowe', 'perkusyjne', 'klawiszowe') |
| `t_sala` | `t_sala_obj` | pojemność 1-20, ma_fortepian/perkusje IN ('T','N') |
| `t_nauczyciel` | `t_nauczyciel_obj` | email UNIQUE, LIKE '%@%' |
| `t_uczen` | `t_uczen_obj` | min. wiek 5 lat (trigger) |
| `t_kurs` | `t_kurs_obj` | poziom, cena > 0, REF SCOPE IS |
| `t_lekcja` | `t_lekcja_obj` | 4x REF SCOPE IS, czas 30/45/60/90 min |
| `t_ocena_postepu` | `t_ocena_obj` | ocena 1-6, 2x REF SCOPE IS |

**SCOPE IS** - oznacza że REF musi wskazywać na wiersz z konkretnej tabeli

**Indeksy (5):**
- na nazwiskach (uczen, nauczyciel)
- na dacie lekcji i statusie
- na dacie oceny

---

### 3️⃣ 03_pakiety.sql - PAKIETY PL/SQL

**PKG_UCZEN (6 podprogramów):**
- `dodaj()` - nowy uczeń z walidacją wieku
- `lista()` - wszystkich uczniów  
- `lista_dzieci()` - tylko <15 lat
- `info()` - szczegóły ucznia
- `srednia_ocen()` - funkcja
- `liczba_lekcji()` - funkcja

**PKG_LEKCJA (6 podprogramów):**
- `zaplanuj()` - nowa lekcja (pobiera REF-y, waliduje przez triggery)
- `oznacz_odbyta()` - zmiana statusu
- `odwolaj()` - anulowanie
- `plan_dnia()` - wszystkie lekcje danego dnia
- `plan_nauczyciela()` - plan konkretnego nauczyciela  
- `raport_obciazenia()` - minuty pracy nauczycieli

**PKG_OCENA (3 podprogramy):**
- `dodaj()` - nowa ocena
- `historia_ucznia()` - wszystkie oceny ucznia
- `raport_postepu()` - średnie wg obszarów

**Kluczowe elementy:**
- Użycie `REF()` do pobierania referencji
- Użycie `DEREF()` do dereferencji w zapytaniach
- Użycie `VALUE()` do pobrania obiektu z tabeli
- Użycie `TREAT()` do wywołania metod na obiektach

---

### 4️⃣ 04_triggery.sql - WYZWALACZE

**10 triggerów podzielonych na kategorie:**

**WALIDACJE PODSTAWOWE:**
1. `trg_uczen_wiek` - min. 5 lat (kod -20101)
2. `trg_lekcja_dni_robocze` - tylko Pn-Pt (kod -20102)
3. `trg_lekcja_godziny_dziecka` - dzieci 14:00-19:00 (kod -20103)

**LIMITY:**
4. `trg_lekcja_limit_nauczyciela` - max 6h/dzień (kod -20104)
5. `trg_lekcja_limit_ucznia` - max 2 lekcje/dzień (kod -20105)

**KONFLIKTY (wykrywanie nakładających się lekcji):**
6. `trg_lekcja_konflikt_sali` - sala zajęta (kod -20106)
7. `trg_lekcja_konflikt_nauczyciela` - nauczyciel zajęty (kod -20107)
8. `trg_lekcja_konflikt_ucznia` - uczeń zajęty (kod -20108)

**BLOKADY USUWANIA:**
9. `trg_blokada_usun_nauczyciela` - ochrona danych (kod -20109)
10. `trg_blokada_usun_ucznia` - ochrona danych (kod -20110)

**Techniki użyte w triggerach (WERSJA POPRAWIONA):**
- **COMPOUND TRIGGER** - rozwiązuje problem Mutating Table
  - `BEFORE EACH ROW` - zbiera dane do kolekcji
  - `AFTER STATEMENT` - wykonuje walidacje (tabela już nie mutuje)
- `DEREF(:NEW.ref_xxx)` do pobrania obiektu z REF
- Konwersja godziny HH:MM na minuty dla porównań

---

### 5️⃣ 05_dane.sql - DANE TESTOWE

**Zawartość:**
- 10 instrumentów (różne kategorie)
- 5 sal (z różnym wyposażeniem)
- 5 nauczycieli (z VARRAY instrumentów)
- 10 uczniów (4 dzieci, 2 młodzież, 4 dorośli)
- 10 kursów (różne poziomy i instrumenty)
- 3 przykładowe lekcje (na najbliższy poniedziałek)
- 6 przykładowych ocen

**Techniki:**
- Użycie sekwencji `seq_xxx.NEXTVAL`
- Pobieranie REF przez `SELECT REF(x) INTO v_ref FROM tabela x WHERE ...`
- Konstruktor obiektu np. `t_uczen_obj(...)`
- `NEXT_DAY(SYSDATE, 'MONDAY')` - obliczenie następnego poniedziałku

---

### 6️⃣ 06_testy.sql - TESTY JEDNOSTKOWE

**10 scenariuszy testowych:**

1. **Dodawanie danych podstawowych** - sprawdzenie czy dane się załadowały
2. **Walidacja wieku ucznia** - test triggera (3-latek, 4-latek, 5-latek, 10-latek)
3. **Walidacja dni roboczych** - test weekendu (sobota, niedziela, poniedziałek)
4. **Godziny lekcji dla dzieci** - test 14:00-19:00
5. **Limit godzin nauczyciela** - test 6h/dzień
6. **Limit lekcji ucznia** - test 2 lekcji/dzień
7. **Konflikty sal i nauczycieli** - test nakładających się lekcji
8. **Blokada usuwania** - test ochrony danych
9. **Pakiety - operacje CRUD** - test funkcji pakietów
10. **Metody obiektów** - test metod MEMBER FUNCTION

**Technika testowania:**
- Próba wykonania operacji w bloku BEGIN...EXCEPTION
- Sprawdzenie SQLCODE czy odpowiada oczekiwanemu błędowi
- Liczniki v_test_ok i v_test_fail
- ROLLBACK po każdym teście

---

### 7️⃣ 07_uzytkownicy.sql - ROLE I UŻYTKOWNICY

⚠️ **WYMAGA UPRAWNIEŃ DBA** - nie uruchamiaj na koncie studenta!

**3 Role:**

| Rola | Uprawnienia |
|------|-------------|
| `rola_admin` | SIUD na wszystkich tabelach, EXECUTE na pakietach |
| `rola_nauczyciel` | SELECT wszystko, UPDATE(status) lekcji, INSERT ocen |
| `rola_sekretariat` | SELECT wszystko, IU uczniów i lekcji |

**3 Użytkownicy:**
- `usr_admin` (Admin123!) - administrator
- `usr_nauczyciel` (Naucz123!) - prowadzenie lekcji
- `usr_sekretariat` (Sekr123!) - rejestracja

---

## SPEŁNIENIE WYMAGAŃ PROJEKTOWYCH

| Wymaganie | ✅ Realizacja |
|-----------|--------------|
| Typy obiektowe z metodami | 8 typów, 14 metod |
| Tabele obiektowe | 7 tabel OF typ_obj |
| Referencje REF | 7 referencji (SCOPE IS) |
| Dereferencja DEREF | W pakietach i triggerach |
| VARRAY | t_lista_instrumentow (max 5) |
| Pakiety PL/SQL | 3 pakiety, 15 podprogramów |
| Kursory | Użyte w procedurach (FOR r IN SELECT...) |
| Obsługa błędów | EXCEPTION, RAISE_APPLICATION_ERROR |
| Triggery | 6 wyzwalaczy (COMPOUND + proste) |
| Role użytkowników | 3 role z podziałem funkcjonalności |

---

## POTENCJALNE PYTANIA NA OBRONIE

**P: Co to jest Mutating Table Error i jak go naprawiliście?**
> Błąd ORA-04091 występuje gdy trigger ROW LEVEL próbuje czytać z tabeli którą modyfikuje.
> Naprawiliśmy używając **COMPOUND TRIGGER**:
> - W fazie BEFORE EACH ROW zbieramy dane do kolekcji (nie robimy SELECT)
> - W fazie AFTER STATEMENT wykonujemy walidacje (tabela już nie "mutuje")

**P: Dlaczego usunęliście COMMIT z procedur?**
> COMMIT w procedurze uniemożliwia łączenie operacji w jedną transakcję.
> Jeśli wywołasz `pkg_uczen.dodaj()` a potem `pkg_lekcja.zaplanuj()` i drugie się nie uda,
> nie możesz wycofać pierwszego - COMMIT już zatwierdzony.
> Zasada: procedura wykonuje pracę, COMMIT/ROLLBACK robi wywołujący.

**P: Co to jest Dangling REF?**
> "Wisząca referencja" - REF wskazuje na usunięty rekord, DEREF() zwraca NULL.
> Zabezpieczamy się blokując usuwanie ucznia/nauczyciela jeśli ma JAKIEKOLWIEK
> powiązane rekordy (nie tylko zaplanowane lekcje).

**P: Dlaczego VARRAY a nie NESTED TABLE?**
> VARRAY ma stały limit (max 5 instrumentów) co jest logiczne dla nauczyciela. NESTED TABLE byłaby użyta gdybyśmy potrzebowali nieograniczonej kolekcji.

**P: Dlaczego REF SCOPE IS?**
> SCOPE IS wymusza integralność referencyjną - REF może wskazywać tylko na wiersze z określonej tabeli, co zapobiega "wiszącym" referencjom.

**P: Jak działają triggery konfliktów?**
> W COMPOUND TRIGGER:
> 1. BEFORE EACH ROW: Pobieramy dane nowej lekcji do kolekcji PL/SQL
> 2. AFTER STATEMENT: Dla każdej lekcji konwertujemy godzinę HH:MM na minuty,
>    obliczamy przedział [start, end] i sprawdzamy czy nakłada się z istniejącymi.

**P: Dlaczego nie można uruchomić 07_uzytkownicy.sql?**
> Wymaga uprawnień DBA do CREATE ROLE i CREATE USER. Na serwerze studenckim traktujemy to jako dokumentację wdrożeniową.

---

## ZNANE OGRANICZENIA

1. Brak GUI - tylko SQL*Plus / SQL Developer
2. Brak automatycznej synchronizacji VARRAY instrumentów z tabelą t_instrument
3. Godzina jako VARCHAR2('HH:MM') - wymaga parsowania w triggerach
4. DBMS_OUTPUT w pakietach - w produkcji należałoby zwracać kursory/kolekcje

---

## PLIKI PROJEKTU

| Plik | Status | Opis |
|------|--------|------|
| `01_typy.sql` | ✅ OK | Typy obiektowe |
| `02_tabele.sql` | ✅ OK | Tabele, sekwencje, indeksy |
| `03_pakiety.sql` | ⚠️ STARY | Ma COMMIT w procedurach |
| `03_pakiety_POPRAWIONE.sql` | ✅ NOWY | Bez COMMIT |
| `04_triggery.sql` | ❌ BŁĘDNY | Mutating Table Error |
| `04_triggery_POPRAWIONE.sql` | ✅ NOWY | COMPOUND TRIGGER |
| `05_dane.sql` | ✅ OK | Dane testowe |
| `06_testy.sql` | ✅ OK | Testy jednostkowe |
| `07_uzytkownicy.sql` | ✅ OK | Role (wymaga DBA) |

---

*Wersja: 3.1 (POPRAWIONA) | Styczeń 2026*
