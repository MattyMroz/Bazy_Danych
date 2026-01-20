# 🏆 Ocena Pomysłów i Decyzje Finalne

> **Data:** 2026-01-20  
> **Wersja:** 2.0  
> **Status:** FINALNE DECYZJE

---

## 📋 Podsumowanie Zmian Względem Wersji 1

### ✅ Co zostaje bez zmian:
- Podstawowa struktura typów (instrument, nauczyciel, uczeń, kurs, lekcja, ocena)
- Pakiety (pkg_uczen, pkg_lekcja, pkg_ocena) - z rozszerzeniami
- VARRAY dla instrumentów nauczyciela
- System REF/DEREF
- Role użytkowników (admin, nauczyciel, sekretariat)

### ➕ Co dodajemy:
1. **T_SEMESTR** - ramy czasowe dla planowania
2. **T_SALA** - sale lekcyjne z kontrolą konfliktów
3. **Nowe triggery walidacyjne** - limity, godziny, konflikty
4. **Kompleksowe testy** - 7 kategorii scenariuszy

---

## 🎯 Finalne Decyzje Architektoniczne

### 1. System Semestralny

**Decyzja:** Tabela `T_SEMESTR` jako kontekst czasowy

```sql
t_semestr_obj:
  - id_semestru    NUMBER
  - nazwa          VARCHAR2(50)   -- np. "2025/2026 Zimowy"
  - data_od        DATE
  - data_do        DATE  
  - czy_aktywny    CHAR(1)        -- 'T'/'N' (tylko 1 aktywny!)
  
  METODY:
  - czy_w_trakcie() -> VARCHAR2    -- czy semestr trwa
  - dni_do_konca() -> NUMBER       -- ile dni zostało
```

**Ograniczenia:**
- Tylko jeden semestr może być aktywny w danym momencie
- Lekcje mogą być planowane tylko w ramach aktywnego semestru
- Data lekcji musi być między data_od a data_do semestru

---

### 2. System Sal Lekcyjnych

**Decyzja:** Tabela `T_SALA` z kontrolą wyposażenia

```sql
t_sala_obj:
  - id_sali        NUMBER
  - nazwa          VARCHAR2(50)   -- np. "Sala 101", "Sala fortepianowa"
  - pojemnosc      NUMBER         -- ile osób (1-10)
  - ma_fortepian   CHAR(1)        -- 'T'/'N'
  - ma_perkusje    CHAR(1)        -- 'T'/'N'
  - opis           VARCHAR2(200)
  
  METODY:
  - opis_pelny() -> VARCHAR2      -- nazwa + wyposażenie
```

**Ograniczenia:**
- Dwie lekcje nie mogą być w tej samej sali o tej samej godzinie
- (Opcjonalnie) Kurs fortepianu wymaga sali z fortepianem

---

### 3. Ograniczenia Godzinowe dla Dzieci

**Decyzja:** Automatyczna walidacja na podstawie wieku

```
REGUŁA:
  IF uczen.wiek() < 15 THEN
    lekcja.godzina_start >= '14:00'
    lekcja.godzina_start <= '19:00'
  ELSE
    lekcja.godzina_start >= '08:00'  
    lekcja.godzina_start <= '20:00'
  END IF
```

**Uzasadnienie:**
- Dzieci poniżej 15 lat chodzą do szkoły podstawowej/gimnazjum
- Zajęcia szkolne kończą się ok. 13:00-14:00
- Lekcje muzyki po południu to standard w szkołach muzycznych

---

### 4. Limity Obciążenia Nauczycieli

**Decyzja:** Max 6 godzin lekcyjnych dziennie

```
REGUŁA:
  SUM(lekcja.czas_trwania) dla nauczyciela w danym dniu <= 360 minut (6h)
```

**Uzasadnienie:**
- 6 godzin lekcyjnych = rozsądne obciążenie
- Zostawia czas na przygotowanie, przerwy, administrację
- Chroni przed wypaleniem zawodowym

---

### 5. Limity Obciążenia Uczniów

**Decyzja:** Max 2 lekcje dziennie per uczeń

```
REGUŁA:
  COUNT(lekcje) dla ucznia w danym dniu <= 2
```

**Uzasadnienie:**
- Dziecko po szkole nie powinno mieć więcej niż 2 dodatkowe zajęcia
- Czas na naukę domową, odpoczynek
- Typowe dla szkół muzycznych

---

### 6. Kontrola Konfliktów

**Konflikty do sprawdzenia przy planowaniu lekcji:**

| Typ konfliktu | Opis | Priorytet |
|---------------|------|-----------|
| Nauczyciel zajęty | Nauczyciel ma inną lekcję w tym czasie | KRYTYCZNY |
| Uczeń zajęty | Uczeń ma inną lekcję w tym czasie | KRYTYCZNY |
| Sala zajęta | W sali jest inna lekcja | KRYTYCZNY |
| Poza semestrem | Data poza aktywnym semestrem | KRYTYCZNY |
| Złe godziny (dziecko) | Dziecko przed 14:00 | KRYTYCZNY |
| Limit nauczyciela | Nauczyciel ma już 6h | WYSOKI |
| Limit ucznia | Uczeń ma już 2 lekcje | WYSOKI |

---

## 📊 Finalna Struktura Bazy Danych

### Typy Obiektowe (9)

| # | Typ | Metody | Opis |
|---|-----|--------|------|
| 1 | t_instrument_obj | 1 | Instrument muzyczny |
| 2 | t_lista_instrumentow | - | VARRAY(5) |
| 3 | t_nauczyciel_obj | 3 | Nauczyciel |
| 4 | t_uczen_obj | 3 | Uczeń |
| 5 | t_kurs_obj | 1 | Kurs nauki |
| 6 | t_sala_obj | 1 | Sala lekcyjna ⭐NEW |
| 7 | t_semestr_obj | 2 | Semestr ⭐NEW |
| 8 | t_lekcja_obj | 2 | Lekcja |
| 9 | t_ocena_obj | 2 | Ocena postępu |

### Tabele Obiektowe (8)

| # | Tabela | Typ bazowy | REF do |
|---|--------|------------|--------|
| 1 | t_instrument | t_instrument_obj | - |
| 2 | t_nauczyciel | t_nauczyciel_obj | - (VARRAY) |
| 3 | t_uczen | t_uczen_obj | - |
| 4 | t_kurs | t_kurs_obj | t_instrument |
| 5 | t_sala | t_sala_obj | - ⭐NEW |
| 6 | t_semestr | t_semestr_obj | - ⭐NEW |
| 7 | t_lekcja | t_lekcja_obj | t_uczen, t_nauczyciel, t_kurs, t_sala⭐ |
| 8 | t_ocena_postepu | t_ocena_obj | t_uczen, t_nauczyciel |

### Triggery (10)

| # | Trigger | Tabela | Typ | Opis |
|---|---------|--------|-----|------|
| 1 | trg_lekcja_walidacja | t_lekcja | BEFORE | Podstawowa walidacja |
| 2 | trg_ocena_audit | t_ocena_postepu | AFTER | Audit ocen |
| 3 | trg_uczen_przed_usunieciem | t_uczen | BEFORE | Blokada usunięcia |
| 4 | trg_nauczyciel_data | t_nauczyciel | BEFORE | Domyślna data |
| 5 | trg_kurs_cena_audit | t_kurs | AFTER | Audit cen |
| 6 | trg_lekcja_godziny_dziecka | t_lekcja | BEFORE | Godziny dla dzieci ⭐NEW |
| 7 | trg_lekcja_limit_nauczyciela | t_lekcja | BEFORE | Max 6h dziennie ⭐NEW |
| 8 | trg_lekcja_limit_ucznia | t_lekcja | BEFORE | Max 2 lekcje ⭐NEW |
| 9 | trg_lekcja_konflikt_sali | t_lekcja | BEFORE | Sala zajęta ⭐NEW |
| 10 | trg_semestr_tylko_jeden_aktywny | t_semestr | BEFORE | 1 aktywny ⭐NEW |

### Pakiety (4)

| # | Pakiet | Procedury | Opis |
|---|--------|-----------|------|
| 1 | pkg_uczen | 5 | Zarządzanie uczniami |
| 2 | pkg_lekcja | 7 | Zarządzanie lekcjami (+sprawdz_dostepnosc) |
| 3 | pkg_ocena | 5 | Zarządzanie ocenami |
| 4 | pkg_semestr | 3 | Zarządzanie semestrem ⭐NEW |

---

## 🧪 Plan Testów

### Kategoria 1: Testy Typów
```sql
-- Test metod obiektowych
-- uczen.wiek(), uczen.czy_pelnoletni()
-- nauczyciel.lata_stazu(), nauczyciel.czy_senior()
-- kurs.info_kursu()
-- ocena.czy_pozytywna(), ocena.ocena_slownie()
```

### Kategoria 2: Testy Constraints
```sql
-- Test CHECK constraints
-- Błędna kategoria instrumentu
-- Ocena poza zakresem 1-6
-- Email bez @
-- Poziom kursu spoza listy
```

### Kategoria 3: Testy Pakietów
```sql
-- Test każdej procedury/funkcji
-- Poprawne wywołanie
-- Wywołanie z błędnymi parametrami
-- Wywołanie w edge cases
```

### Kategoria 4: Testy Triggerów
```sql
-- Test każdego triggera
-- Warunki aktywacji
-- Poprawne blokowanie
-- Poprawne przepuszczanie
```

### Kategoria 5: Testy Scenariuszy Biznesowych
```sql
-- SCENARIUSZ 1: Cykl życia ucznia
-- SCENARIUSZ 2: Planowanie semestru  
-- SCENARIUSZ 3: Konflikty w planie
-- SCENARIUSZ 4: Limity obciążenia
-- SCENARIUSZ 5: Ograniczenia wiekowe
```

### Kategoria 6: Testy Blokad
```sql
-- Usunięcie ucznia z lekcjami
-- Usunięcie nauczyciela z lekcjami
-- Usunięcie sali z lekcjami
-- Zmiana semestru podczas trwania
```

### Kategoria 7: Testy Uprawnień
```sql
-- Test każdej roli
-- Co może admin
-- Co może nauczyciel
-- Co może sekretariat
-- Co NIE może każda rola
```

---

## 📁 Lista Plików do Utworzenia/Aktualizacji

### Pliki SQL:

| Plik | Akcja | Opis zmian |
|------|-------|------------|
| 01_typy.sql | UPDATE | +t_sala_obj, +t_semestr_obj, update t_lekcja_obj |
| 02_tabele.sql | UPDATE | +t_sala, +t_semestr, update t_lekcja |
| 03_pakiety.sql | UPDATE | +pkg_semestr, rozszerzenie pkg_lekcja |
| 04_triggery.sql | UPDATE | +5 nowych triggerów |
| 05_dane.sql | UPDATE | +dane dla sal i semestru |
| 06_testy.sql | CREATE | Kompleksowe testy (NOWY PLIK) |
| 07_uzytkownicy.sql | UPDATE | Uprawnienia do nowych obiektów |

### Dokumentacja:

| Plik | Akcja | Opis zmian |
|------|-------|------------|
| Raport_MusicSchoolDB.tex | UPDATE | Pełna aktualizacja dokumentacji |

---

## ✅ Checklist Przed Oddaniem

- [ ] Wszystkie typy kompilują się bez błędów
- [ ] Wszystkie tabele tworzą się poprawnie
- [ ] Wszystkie pakiety kompilują się
- [ ] Wszystkie triggery są aktywne
- [ ] Dane testowe wstawiają się poprawnie
- [ ] WSZYSTKIE testy przechodzą
- [ ] Role mają odpowiednie uprawnienia
- [ ] Raport LaTeX kompiluje się
- [ ] Diagram w raporcie jest aktualny
- [ ] Brak hardcodowanych dat (używamy SYSDATE)

---

## 🚀 Kolejność Implementacji

1. **01_typy.sql** - nowe typy + modyfikacja t_lekcja_obj
2. **02_tabele.sql** - nowe tabele + modyfikacja t_lekcja
3. **04_triggery.sql** - nowe triggery (zależą od tabel)
4. **03_pakiety.sql** - nowy pakiet + modyfikacje (zależą od tabel)
5. **05_dane.sql** - dane testowe (zależą od wszystkiego)
6. **06_testy.sql** - testy (zależą od danych)
7. **07_uzytkownicy.sql** - uprawnienia (na końcu)
8. **Raport_MusicSchoolDB.tex** - dokumentacja (po wszystkim)
