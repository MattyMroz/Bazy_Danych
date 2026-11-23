# 🎼 SZKOŁA MUZYCZNA - ZAŁOŻENIA PROJEKTOWE v7

## Wersja 7.0 | Luty 2026
## Autorzy: Igor Typiński (251237), Mateusz Mróz (251190)

---

# 1. OPIS SYSTEMU

Obiektowa baza danych dla **małej szkoły muzycznej I stopnia** (6-letni cykl kształcenia).

**Główne funkcjonalności:**
- Zarządzanie uczniami, nauczycielami, grupami, salami
- Automatyczne planowanie lekcji (heurystyka)
- System oceniania
- Raporty i statystyki

---

# 2. STRUKTURA DANYCH

## 2.1 Typy obiektowe

| Typ | Atrybuty | Metody |
|-----|----------|--------|
| `T_WYPOSAZENIE` | VARRAY(10) OF VARCHAR2(50) | - |
| `T_PRZEDMIOT` | id, nazwa, typ_zajec, czas_trwania_min | `czy_grupowy()` → 'T'/'N' |
| `T_NAUCZYCIEL` | id, imie, nazwisko, instrument, email | `pelne_nazwisko()` → VARCHAR2 |
| `T_GRUPA` | id, kod, klasa, rok_szkolny | - |
| `T_SALA` | id, numer, typ, pojemnosc, wyposazenie | `czy_grupowa()` → 'T'/'N' |
| `T_UCZEN` | id, imie, nazwisko, data_urodzenia, instrument, ref_grupa, data_zapisu | `pelne_nazwisko()`, `wiek()` |
| `T_LEKCJA` | id, ref_przedmiot, ref_nauczyciel, ref_sala, ref_uczen, ref_grupa, data_lekcji, godzina_start, czas_trwania_min | `godzina_koniec()`, `czy_indywidualna()` |
| `T_OCENA` | id, ref_uczen, ref_nauczyciel, ref_przedmiot, wartosc, data_wystawienia, czy_semestralna | `opis_oceny()` → słowny opis |

## 2.2 Tabele

| Tabela | Rekordów | Kluczowe constrainty |
|--------|----------|----------------------|
| `PRZEDMIOTY` | 5 | typ_zajec IN ('indywidualny','grupowy'), czas IN (30,45,60,90) |
| `NAUCZYCIELE` | 6 | instrument NULL = przedmioty grupowe |
| `GRUPY` | 6 | klasa 1-6, kod unikalny |
| `SALE` | 4 | typ IN ('indywidualna','grupowa'), VARRAY wyposażenia |
| `UCZNIOWIE` | 24 | REF do GRUPY (SCOPE IS) |
| `LEKCJE` | ~60/tydz | XOR: ref_uczen OR ref_grupa (nigdy oba) |
| `OCENY` | ~50/sem | wartosc 1-6, czy_semestralna T/N |

## 2.3 Relacje (REF)

```
UCZNIOWIE ──REF──► GRUPY
LEKCJE ──REF──► PRZEDMIOTY, NAUCZYCIELE, SALE, UCZNIOWIE/GRUPY
OCENY ──REF──► UCZNIOWIE, NAUCZYCIELE, PRZEDMIOTY
```

---

# 3. DANE W SYSTEMIE

## 3.1 Przedmioty (5)

| Nazwa | Typ | Czas |
|-------|-----|------|
| Fortepian | indywidualny | 45 min |
| Skrzypce | indywidualny | 45 min |
| Gitara | indywidualny | 45 min |
| Flet | indywidualny | 45 min |
| Kształcenie słuchu | grupowy | 45 min |

## 3.2 Sale (4)

| Nr | Typ | Pojemność | Wyposażenie |
|----|-----|-----------|-------------|
| 101 | indywidualna | 3 | Pianino Yamaha, Pulpit, Krzesło |
| 102 | indywidualna | 3 | Fortepian Steinway, Metronom, Lustro |
| 103 | indywidualna | 3 | Pianino cyfrowe, Wzmacniacz, Stojak gitarowy |
| 201 | grupowa | 15 | Tablica, Nagłośnienie, Pianino, Krzesła x15, Projektor |

## 3.3 Grupy (6)

| Kod | Klasa | Rok |
|-----|-------|-----|
| 1A | 1 | 2025/2026 |
| 2A | 2 | 2025/2026 |
| 3A | 3 | 2025/2026 |
| 4A | 4 | 2025/2026 |
| 5A | 5 | 2025/2026 |
| 6A | 6 | 2025/2026 |

## 3.4 Nauczyciele (6)

| Imię | Nazwisko | Instrument |
|------|----------|------------|
| Anna | Kowalska | Fortepian |
| Piotr | Nowak | Skrzypce |
| Maria | Wiśniewska | Gitara |
| Jan | Lewandowski | Flet |
| Ewa | Kamińska | NULL (grupowe) |
| Tomasz | Zieliński | Fortepian |

## 3.5 Uczniowie (24 = 4 na grupę)

| Grupa | Uczniowie | Instrumenty |
|-------|-----------|-------------|
| 1A | Jan Kotek, Anna Myszka, Piotr Piesek, Ola Kwiatek | 2×Fortepian, Skrzypce, Gitara |
| 2A | Tomek Drzewko, Kasia Chmurka, Marek Słoneczko, Zosia Rybka | Flet, Fortepian, Skrzypce, Gitara |
| 3A | Adam Lasek, Ewa Gwiazda, Jakub Morski, Maja Polna | Fortepian, Flet, Skrzypce, Gitara |
| 4A | Bartek Górski, Natalia Rzeczna, Filip Polny, Wiktoria Zielona | 2×Fortepian, Skrzypce, Flet |
| 5A | Szymon Wysoki, Alicja Biała, Dawid Ciemny, Julia Jasna | Gitara, Fortepian, Skrzypce, Flet |
| 6A | Michał Mocny, Oliwia Szybka, Krzysztof Mądry, Patrycja Wysoka | Fortepian, Gitara, Skrzypce, Flet |

**Podsumowanie:** Fortepian: 8, Skrzypce: 4, Gitara: 4, Flet: 4

---

# 4. API PAKIETÓW

## 4.1 PKG_SLOWNIKI - Dane słownikowe

### Procedury dodające:
```sql
PKG_SLOWNIKI.dodaj_przedmiot(p_nazwa, p_typ, p_czas DEFAULT 45)
PKG_SLOWNIKI.dodaj_sale(p_numer, p_typ, p_pojemnosc, p_wyposazenie T_WYPOSAZENIE)
PKG_SLOWNIKI.dodaj_grupe(p_kod, p_klasa, p_rok DEFAULT '2025/2026')
```

### Funkcje pobierające REF:
```sql
PKG_SLOWNIKI.get_ref_przedmiot(p_nazwa) → REF T_PRZEDMIOT
PKG_SLOWNIKI.get_ref_sala(p_numer) → REF T_SALA
PKG_SLOWNIKI.get_ref_grupa(p_kod) → REF T_GRUPA
```

### Funkcje pobierające ID:
```sql
PKG_SLOWNIKI.get_id_przedmiot(p_nazwa) → NUMBER
PKG_SLOWNIKI.get_id_sala(p_numer) → NUMBER
PKG_SLOWNIKI.get_id_grupa(p_kod) → NUMBER
```

---

## 4.2 PKG_OSOBY - Nauczyciele i uczniowie

### Procedury dodające:
```sql
PKG_OSOBY.dodaj_nauczyciela(p_imie, p_nazwisko, p_instrument DEFAULT NULL, p_email DEFAULT NULL)
-- instrument NULL = nauczyciel przedmiotów grupowych

PKG_OSOBY.dodaj_ucznia(p_imie, p_nazwisko, p_data_ur DATE, p_kod_grupy, p_instrument)
-- automatycznie pobiera REF do grupy
```

### Funkcje pobierające:
```sql
PKG_OSOBY.get_ref_nauczyciel(p_nazwisko) → REF T_NAUCZYCIEL
PKG_OSOBY.get_ref_uczen(p_nazwisko, p_imie) → REF T_UCZEN
PKG_OSOBY.get_id_nauczyciel(p_nazwisko) → NUMBER
PKG_OSOBY.get_id_uczen(p_nazwisko, p_imie) → NUMBER
PKG_OSOBY.get_instrument_ucznia(p_id_ucznia) → VARCHAR2
PKG_OSOBY.get_grupa_ucznia(p_id_ucznia) → VARCHAR2 (kod grupy)
```

### Procedury wyświetlające:
```sql
PKG_OSOBY.lista_uczniow_w_grupie(p_kod_grupy)
-- Wyświetla: ID, Imię, Nazwisko, Instrument

PKG_OSOBY.lista_uczniow_nauczyciela(p_nazwisko)
-- Wyświetla uczniów grających na instrumencie tego nauczyciela
```

---

## 4.3 PKG_LEKCJE - Planowanie i zarządzanie lekcjami

### Funkcje sprawdzające dostępność:
```sql
PKG_LEKCJE.czy_sala_wolna(p_id_sali, p_data, p_godzina, p_czas) → BOOLEAN
PKG_LEKCJE.czy_nauczyciel_wolny(p_id_naucz, p_data, p_godzina, p_czas) → BOOLEAN
PKG_LEKCJE.czy_uczen_wolny(p_id_ucznia, p_data, p_godzina, p_czas) → BOOLEAN
-- Sprawdza zarówno lekcje indywidualne jak i grupowe ucznia
```

### Procedury dodające lekcje (ręczne):
```sql
PKG_LEKCJE.dodaj_lekcje_indywidualna(
    p_przedmiot, p_nauczyciel, p_sala,
    p_uczen_nazwisko, p_uczen_imie,
    p_data DATE, p_godzina VARCHAR2, p_czas DEFAULT 45
)
-- Waliduje: godziny 14:00-20:00, dostępność sali/nauczyciela/ucznia

PKG_LEKCJE.dodaj_lekcje_grupowa(
    p_przedmiot, p_nauczyciel, p_sala,
    p_kod_grupy,
    p_data DATE, p_godzina VARCHAR2, p_czas DEFAULT 45
)
```

### Heurystyka planowania:
```sql
PKG_LEKCJE.znajdz_nauczyciela(p_instrument, p_data, p_godzina, p_czas) → VARCHAR2
-- Zwraca nazwisko pierwszego wolnego nauczyciela lub NULL

PKG_LEKCJE.znajdz_sale(p_typ, p_data, p_godzina, p_czas) → VARCHAR2
-- Zwraca numer pierwszej wolnej sali lub NULL

PKG_LEKCJE.przydziel_lekcje_uczniowi(p_nazwisko, p_imie, p_data_poczatek DATE)
-- Automatycznie znajduje i przydziela 2 lekcje instrumentu w różnych dniach

PKG_LEKCJE.generuj_plan_tygodnia(p_data_poniedzialek DATE)
-- KROK 1: Lekcje grupowe dla wszystkich grup
-- KROK 2: Lekcje indywidualne dla wszystkich uczniów
```

### Procedury wyświetlające plany:
```sql
PKG_LEKCJE.plan_ucznia(p_nazwisko, p_imie)
-- Wyświetla: Data, Godzina, Przedmiot, Nauczyciel, Sala

PKG_LEKCJE.plan_nauczyciela(p_nazwisko)
-- Wyświetla: Data, Godzina, Przedmiot, Kto (uczeń lub "Grupa X"), Sala

PKG_LEKCJE.plan_grupy(p_kod_grupy)
-- Wyświetla: Data, Godzina, Przedmiot, Nauczyciel, Sala

PKG_LEKCJE.plan_sali(p_numer, p_data DATE)
-- Wyświetla obłożenie sali w danym dniu
```

---

## 4.4 PKG_OCENY - Ocenianie

### Procedury wystawiania ocen:
```sql
PKG_OCENY.wystaw_ocene(p_uczen_nazwisko, p_uczen_imie, p_nauczyciel, p_przedmiot, p_wartosc)
-- Ocena bieżąca (czy_semestralna = 'N')

PKG_OCENY.wystaw_ocene_semestralna(p_uczen_nazwisko, p_uczen_imie, p_nauczyciel, p_przedmiot, p_wartosc)
-- Ocena semestralna (czy_semestralna = 'T')
```

### Procedury wyświetlające:
```sql
PKG_OCENY.oceny_ucznia(p_nazwisko, p_imie)
-- Wyświetla: Data, Przedmiot, Ocena, Nauczyciel, Typ
```

### Funkcje obliczające:
```sql
PKG_OCENY.srednia_ucznia(p_nazwisko, p_imie, p_przedmiot) → NUMBER
-- Średnia ocen bieżących (nie semestralnych) zaokrąglona do 2 miejsc
```

---

## 4.5 PKG_RAPORTY - Raporty i statystyki

```sql
PKG_RAPORTY.raport_grup()
-- Wyświetla: Grupa, Klasa, Liczba uczniów

PKG_RAPORTY.raport_nauczycieli()
-- Wyświetla: Nazwisko, Imię, Instrument, Liczba lekcji

PKG_RAPORTY.statystyki_lekcji()
-- Wyświetla: Razem lekcji, Indywidualnych, Grupowych
```

---

# 5. ALGORYTM HEURYSTYKI PLANOWANIA

## 5.1 `przydziel_lekcje_uczniowi()`

```
WEJŚCIE: nazwisko, imię, data_początku_tygodnia
CEL: Przydzielić 2 lekcje instrumentu w różnych dniach

1. Pobierz instrument ucznia
2. Sloty czasowe: 14:00, 14:45, 15:30, 16:15, 17:00, 17:45, 18:30, 19:15
3. Przydzielono := 0

4. DLA każdego dnia (pon-pt, offset 0-4):
   a. DLA każdego slotu czasowego:
      - Szukaj nauczyciela: znajdz_nauczyciela(instrument, dzień, godzina, 45)
      - Jeśli NULL → następny slot
      - Szukaj sali: znajdz_sale('indywidualna', dzień, godzina, 45)
      - Jeśli NULL → następny slot
      - Sprawdź ucznia: czy_uczen_wolny(id_ucznia, dzień, godzina, 45)
      - Jeśli FALSE → następny slot
      - Wszystko OK → dodaj_lekcje_indywidualna(), przydzielono++
      - EXIT wewnętrznej pętli (przejdź do następnego dnia)
   b. Jeśli przydzielono >= 2 → EXIT

5. Komunikat jeśli przydzielono < 2
```

## 5.2 `generuj_plan_tygodnia()`

```
WEJŚCIE: data_poniedziałku
CEL: Wygenerować pełny plan na tydzień

KROK 1: LEKCJE GRUPOWE
- Znajdź nauczyciela grupowego (instrument IS NULL)
- DLA każdej grupy (ORDER BY klasa):
  * dzień = poniedzialek + (nr_grupy - 1) MOD 5
  * godzina = ('14:00','15:00','16:00','17:00','18:00')[(nr_grupy-1) MOD 5]
  * dodaj_lekcje_grupowa('Ksztalcenie sluchu', nauczyciel, '201', grupa, dzień, godzina)

KROK 2: LEKCJE INDYWIDUALNE
- DLA każdego ucznia (ORDER BY klasa, nazwisko):
  * przydziel_lekcje_uczniowi(nazwisko, imię, data_poniedziałku)

COMMIT
```

---

# 6. TRIGGERY I WALIDACJE

| Trigger | Tabela | Walidacja | Błąd |
|---------|--------|-----------|------|
| `trg_ocena_zakres` | OCENY | wartosc 1-6 | -20201 |
| `trg_lekcja_xor` | LEKCJE | uczeń XOR grupa | -20202/-20203 |
| `trg_czas_trwania` | LEKCJE | czas IN (30,45,60,90) | -20204 |
| `trg_uczen_data_zapisu` | UCZNIOWIE | auto data_zapisu | - |

---

# 7. KODY BŁĘDÓW

| Kod | Komunikat | Źródło |
|-----|-----------|--------|
| -20001 | Przedmiot nie znaleziony | PKG_SLOWNIKI |
| -20002 | Sala nie znaleziona | PKG_SLOWNIKI |
| -20003 | Grupa nie znaleziona | PKG_SLOWNIKI |
| -20004 | Nauczyciel nie znaleziony | PKG_OSOBY |
| -20005 | Wielu nauczycieli o nazwisku | PKG_OSOBY |
| -20006 | Uczeń nie znaleziony | PKG_OSOBY |
| -20007 | Wielu uczniów | PKG_OSOBY |
| -20010 | Sala zajęta | PKG_LEKCJE |
| -20011 | Nauczyciel zajęty | PKG_LEKCJE |
| -20012 | Uczeń zajęty | PKG_LEKCJE |
| -20101 | Lekcja przed 14:00 | PKG_LEKCJE |
| -20102 | Lekcja po 20:00 | PKG_LEKCJE |
| -20103 | Ocena poza zakresem 1-6 | PKG_OCENY |

---

# 8. OGRANICZENIA SYSTEMU (ŚWIADOME UPROSZCZENIA)

| Co pominięto | Powód |
|--------------|-------|
| Różny czas lekcji wg klasy (30/45 min) | Stały czas 45 min dla wszystkich |
| Chór i Orkiestra | Komplikuje planowanie |
| Rytmika i Audycje | Tylko kształcenie słuchu jako grupowe |
| Obszary ocen (technika, interpretacja) | Tylko wartość liczbowa 1-6 |
| Limity godzin nauczyciela | Brak walidacji max godzin |
| Walidacja wyposażenia sali vs przedmiot | Brak sprawdzania |
| Zastępstwa nauczycieli | Nie modelowane |
| Urlopy i nieobecności | Nie modelowane |
| Koncerty i występy | Nie modelowane |
| Wypożyczalnia instrumentów | Nie modelowane |

---

# 9. SCENARIUSZE UŻYCIA

## SCENARIUSZ 1: Nowy uczeń zapisuje się do szkoły

**Historia:** Przychodzi nowy uczeń - Karol Nowy, 8 lat, chce grać na fortepianie. Sekretariat zapisuje go do klasy 2A.

**Kroki:**
1. Dodaj ucznia do grupy 2A
2. Wygeneruj plan (heurystyka przydzieli mu 2 lekcje fortepianu)
3. Sprawdź jego plan
4. Sprawdź listę uczniów w grupie 2A

**Oczekiwany rezultat:**
- Uczeń ma 2 lekcje fortepianu w różnych dniach
- Uczeń ma lekcję grupową (kształcenie słuchu) razem z grupą 2A

---

## SCENARIUSZ 2: Nowy nauczyciel dołącza do szkoły

**Historia:** Szkoła zatrudnia nowego nauczyciela gitary - Adam Nowy. Trzeba przeorganizować plan.

**Kroki:**
1. Dodaj nauczyciela z instrumentem "Gitara"
2. Usuń stare lekcje (opcjonalnie) lub wygeneruj plan od nowa
3. Sprawdź plan nowego nauczyciela
4. Sprawdź raport nauczycieli

**Oczekiwany rezultat:**
- Nowy nauczyciel ma przydzielone lekcje gitary
- Obciążenie jest rozłożone między nauczycieli tego samego instrumentu

---

## SCENARIUSZ 3: Nauczyciel wystawia oceny

**Historia:** Pani Kowalska (fortepian) wystawia oceny po lekcjach, a na koniec semestru ocenę semestralną.

**Kroki:**
1. Wystaw kilka ocen bieżących dla ucznia
2. Sprawdź oceny ucznia
3. Oblicz średnią
4. Wystaw ocenę semestralną

**Oczekiwany rezultat:**
- Lista ocen pokazuje oceny bieżące i semestralne
- Średnia uwzględnia tylko oceny bieżące

---

## SCENARIUSZ 4: Konflikt - próba dodania kolidującej lekcji

**Historia:** Sekretariat próbuje dodać lekcję gdy sala/nauczyciel/uczeń jest zajęty.

**Kroki:**
1. Sprawdź istniejący plan sali 101
2. Spróbuj dodać lekcję w tym samym czasie
3. System powinien odrzucić z błędem -20010

**Oczekiwany rezultat:**
- Błąd "Sala 101 zajęta w tym terminie"
- Lekcja nie zostaje dodana

---

## SCENARIUSZ 5: Generowanie planu na nowy tydzień

**Historia:** Początek semestru. Sekretariat generuje plan na pierwszy tydzień.

**Kroki:**
1. Upewnij się że dane są załadowane (przedmioty, sale, grupy, nauczyciele, uczniowie)
2. Uruchom generowanie planu
3. Sprawdź statystyki lekcji
4. Sprawdź plany wybranych uczniów, nauczycieli, grup

**Oczekiwany rezultat:**
- Każda grupa ma 1 lekcję kształcenia słuchu
- Każdy uczeń ma 2 lekcje instrumentu
- Brak konfliktów

---

## SCENARIUSZ 6: Raporty szkolne

**Historia:** Dyrektor chce zobaczyć statystyki szkoły.

**Kroki:**
1. Raport grup - ile uczniów w każdej klasie
2. Raport nauczycieli - obciążenie pracą
3. Statystyki lekcji - ile indywidualnych vs grupowych

**Oczekiwany rezultat:**
- Przejrzyste zestawienia w formie tabel

---

*Wersja: 7.0 | Luty 2026*
*Autorzy: Igor Typiński (251237), Mateusz Mróz (251190)*
