# 🧠 Burza Mózgów - Szkoła Muzyczna v3

## 📋 Analiza Feedbacku

### Problemy do rozwiązania:
1. **Nadmiar funkcjonalności** - za dużo kodu = za dużo pytań
2. **Trigger semestrów** - mutating table problem
3. **Porównywanie uczniów** - niepotrzebne
4. **Audytowanie** - za dużo
5. **Niespójność nauczyciel-instrument** - VARRAY vs REF
6. **Dzieci i weekendy** - logiczna dziura
7. **Redundancja t_zapis vs t_lekcja** - potencjalny problem

### Założenia upraszczające:
1. **1 semestr** - system monitoruje tylko bieżący semestr
2. **Pon-Pt tylko** - szkoła nie działa w weekendy
3. **Godziny 8:00-20:00** - normalne godziny pracy
4. **Dzieci <15 lat: 14:00-19:00** - po normalnej szkole
5. **Nauczyciel max 6h/dzień** - limit obciążenia
6. **Uczeń max 2 lekcje/dzień** - rozsądne ograniczenie

---

## 🔍 Problem 1: Struktura tabel

### Opcja A: Minimalna (bez t_zapis, bez t_semestr)
- **Opis:** Tylko podstawowe tabele: uczen, nauczyciel, kurs, lekcja, ocena, sala
- **Plusy:** Prostota, mniej kodu
- **Minusy:** Brak śledzenia zapisów na kursy
- **Ocena:** ⭐⭐⭐⭐⭐⭐ (6/10)

### Opcja B: Z zapisami (bez t_semestr)
- **Opis:** Tabele: uczen, nauczyciel, kurs, zapis, lekcja, ocena, sala
- **Plusy:** Logiczna struktura, śledzenie zapisów
- **Minusy:** Więcej tabel
- **Ocena:** ⭐⭐⭐⭐⭐⭐⭐⭐ (8/10)

### Opcja C: Pełna (z t_semestr)
- **Opis:** Wszystkie tabele z v2
- **Plusy:** Kompletność
- **Minusy:** Za dużo, trigger semestrów problematyczny
- **Ocena:** ⭐⭐⭐⭐⭐ (5/10)

### ✅ DECYZJA: Opcja B - z zapisami, bez semestru
Uzasadnienie: Zapis na kurs jest logiczny dla szkoły, ale semestr komplikuje i trigger mutating table.

---

## 🔍 Problem 2: Trigger godzin dla dzieci

### Opcja A: Sprawdzanie tylko godziny (obecne)
- **Opis:** Trigger sprawdza czy godzina 14:00-19:00
- **Plusy:** Proste
- **Minusy:** Nie uwzględnia weekendów
- **Ocena:** ⭐⭐⭐⭐⭐⭐ (6/10)

### Opcja B: Sprawdzanie godziny + dzień tygodnia
- **Opis:** Pon-Pt 14:00-19:00, weekend bez ograniczeń
- **Plusy:** Logiczne
- **Minusy:** Komplikacja
- **Ocena:** ⭐⭐⭐⭐⭐⭐⭐ (7/10)

### Opcja C: Szkoła tylko Pon-Pt (brak weekendów)
- **Opis:** Szkoła muzyczna działa tylko pon-pt, więc problem znika
- **Plusy:** Najprostsze, naturalne ograniczenie
- **Minusy:** Brak zajęć weekendowych
- **Ocena:** ⭐⭐⭐⭐⭐⭐⭐⭐⭐ (9/10)

### ✅ DECYZJA: Opcja C - szkoła tylko pon-pt
Uzasadnienie: Wiele szkół muzycznych działa tylko w dni robocze. Upraszcza logikę.

---

## 🔍 Problem 3: VARRAY instrumentów nauczyciela

### Opcja A: Zostawić VARRAY (obecne)
- **Opis:** Lista stringów w VARRAY
- **Plusy:** Demonstruje VARRAY, wymaganie projektu
- **Minusy:** Brak twardego powiązania z kursem
- **Ocena:** ⭐⭐⭐⭐⭐⭐⭐ (7/10)

### Opcja B: Tabela pośrednia nauczyciel-instrument
- **Opis:** Relacja M:N przez osobną tabelę
- **Plusy:** Normalizacja
- **Minusy:** Więcej tabel, tracimy VARRAY
- **Ocena:** ⭐⭐⭐⭐⭐ (5/10)

### Opcja C: VARRAY + założenie projektowe
- **Opis:** VARRAY zostaje, dyrektor ręcznie weryfikuje kompetencje
- **Plusy:** Prostota + wymaganie spełnione
- **Minusy:** Logiczna dziura
- **Ocena:** ⭐⭐⭐⭐⭐⭐⭐⭐ (8/10)

### ✅ DECYZJA: Opcja C - VARRAY + założenie
Uzasadnienie: Projekt wymaga VARRAY. "Dyrektor weryfikuje przy zatrudnianiu" - prosta obrona.

---

## 🔍 Problem 4: Audytowanie

### Opcja A: Pełne audytowanie (obecne)
- **Opis:** Logi dla ocen, cen, lekcji
- **Plusy:** Kompletność
- **Minusy:** Za dużo kodu, pytania
- **Ocena:** ⭐⭐⭐⭐ (4/10)

### Opcja B: Tylko audit ocen
- **Opis:** Jeden trigger audit dla ocen
- **Plusy:** Pokazuje koncept, minimum kodu
- **Minusy:** Niepełne
- **Ocena:** ⭐⭐⭐⭐⭐⭐⭐⭐ (8/10)

### Opcja C: Brak audytu
- **Opis:** Usunięcie wszystkich triggerów audytowych
- **Plusy:** Maksymalne uproszczenie
- **Minusy:** Brak demonstracji audytu
- **Ocena:** ⭐⭐⭐⭐⭐⭐ (6/10)

### ✅ DECYZJA: Opcja B - tylko audit ocen
Uzasadnienie: Pokazuje koncept triggera audytowego bez przesady.

---

## 🔍 Problem 5: Pakiety - zakres funkcjonalności

### Opcja A: Minimalne (tylko CRUD)
- **Opis:** Podstawowe operacje dodawania
- **Plusy:** Proste
- **Minusy:** Nie pokazuje możliwości
- **Ocena:** ⭐⭐⭐⭐⭐ (5/10)

### Opcja B: Umiarkowane (CRUD + raporty)
- **Opis:** Dodawanie + podstawowe raporty (lista uczniów, raport dzienny)
- **Plusy:** Pokazuje kursory, logika biznesowa
- **Minusy:** Średnio dużo kodu
- **Ocena:** ⭐⭐⭐⭐⭐⭐⭐⭐ (8/10)

### Opcja C: Pełne (z porównywaniem, statystykami)
- **Opis:** Jak w v2
- **Plusy:** Kompletność
- **Minusy:** Za dużo, zbędne
- **Ocena:** ⭐⭐⭐⭐⭐ (5/10)

### ✅ DECYZJA: Opcja B - umiarkowane
Uzasadnienie: Wystarczające do pokazania kursorów i logiki, bez przesady.

---

## 🔍 Problem 6: Testy - struktura

### Opcja A: Jednostkowe (po jednym teście na obiekt)
- **Opis:** Prosty test dla każdego typu/pakietu/triggera
- **Plusy:** Szybkie
- **Minusy:** Nie pokazuje scenariuszy
- **Ocena:** ⭐⭐⭐⭐⭐ (5/10)

### Opcja B: Scenariuszowe (cykl życia)
- **Opis:** Scenariusze: nowy uczeń, planowanie lekcji, konflikty, błędne dane
- **Plusy:** Pokazuje działanie systemu
- **Minusy:** Więcej kodu
- **Ocena:** ⭐⭐⭐⭐⭐⭐⭐⭐⭐ (9/10)

### Opcja C: Mieszane
- **Opis:** Jednostkowe + scenariusze
- **Plusy:** Kompletność
- **Minusy:** Dużo
- **Ocena:** ⭐⭐⭐⭐⭐⭐⭐ (7/10)

### ✅ DECYZJA: Opcja B - scenariuszowe
Uzasadnienie: Pokazuje działanie systemu od A do Z, co jest ważne na prezentacji.

---

## 📊 Podsumowanie Decyzji

| Problem | Decyzja | Uzasadnienie |
|---------|---------|--------------|
| Struktura tabel | Bez t_semestr, z t_zapis | Unikamy mutating table |
| Godziny dzieci | Szkoła pon-pt | Naturalne ograniczenie |
| VARRAY | Zostawiamy + założenie | Wymaganie projektu |
| Audyt | Tylko oceny | Minimum demonstracji |
| Pakiety | Umiarkowane | CRUD + raporty |
| Testy | Scenariuszowe | Pokazuje system |

---

## 🏗️ Finalna Struktura

### Tabele (7):
1. `t_instrument` - słownik instrumentów
2. `t_sala` - sale lekcyjne
3. `t_nauczyciel` - nauczyciele (z VARRAY)
4. `t_uczen` - uczniowie
5. `t_kurs` - kursy
6. `t_lekcja` - lekcje (REF do ucznia, nauczyciela, kursu, sali)
7. `t_ocena_postepu` - oceny (REF do ucznia, nauczyciela)

### Triggery (8-10):
1. `trg_uczen_minimalny_wiek` - min 5 lat
2. `trg_lekcja_godziny_dziecka` - <15 lat: 14-19
3. `trg_lekcja_tylko_dni_robocze` - pon-pt
4. `trg_lekcja_limit_nauczyciela` - max 6h/dzień
5. `trg_lekcja_limit_ucznia` - max 2 lekcje/dzień
6. `trg_lekcja_konflikt_sali` - sala zajęta
7. `trg_lekcja_konflikt_nauczyciela` - nauczyciel zajęty
8. `trg_lekcja_konflikt_ucznia` - uczeń zajęty
9. `trg_uczen_przed_usunieciem` - blokada usuwania
10. `trg_ocena_audit` - logowanie ocen

### Pakiety (3):
1. `pkg_uczen` - zarządzanie uczniami
2. `pkg_lekcja` - planowanie lekcji
3. `pkg_ocena` - ocenianie

### Role (3):
1. `ROLA_ADMIN` - pełny dostęp
2. `ROLA_NAUCZYCIEL` - lekcje + oceny
3. `ROLA_SEKRETARIAT` - uczniowie

---

## ⚠️ Potencjalne Pytania i Odpowiedzi

**P: Dlaczego VARRAY, a nie tabela pośrednia?**
O: Demonstracja kolekcji Oracle. Dyrektor weryfikuje kompetencje przy zatrudnianiu.

**P: Dlaczego brak semestru?**
O: Uproszczenie - system monitoruje bieżący okres. W wersji produkcyjnej można dodać.

**P: Dlaczego szkoła nie działa w weekendy?**
O: Typowe dla publicznych szkół muzycznych. Upraszcza logikę godzin dzieci.

**P: Czy nauczyciel może uczyć instrumentu, którego nie ma w VARRAY?**
O: Technicznie tak - to założenie projektowe, że administrator pilnuje spójności.
