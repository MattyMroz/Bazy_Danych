# 🧠 Burza Mózgów - Szkoła Muzyczna v2

> **Data:** 2026-01-20  
> **Cel:** Przemyślenie feedbacku prowadzącego i ulepszenie projektu

---

## 📋 Feedback od Prowadzącego - Kluczowe Punkty

1. **Szkoła muzyczna stricte dla muzyki** - nie zwykła szkoła ✅
2. **Brak systemu rejestracji** - nie możemy się zarejestrować jako uczeń online
3. **Plan zajęć na 1 semestr** - uproszczenie, nie manewrujemy między semestrami
4. **Automatyzacja tworzenia planu** - rezerwacja sal dla grup, potem indywidualne
5. **Balans obciążenia** - nauczyciel nie może mieć 8h dziennie codziennie
6. **Dzieci mają normalną szkołę** - lekcje muzyki po południu dla uczniów szkolnych
7. **Nie komplikować** - prostota i logiczność to motto

---

## 🎯 Problem 1: Ograniczenia Wiekowe i Godziny Lekcji

### Obecny stan:
- Minimalny wiek: 5 lat
- Godziny: 08:00-20:00 (zbyt szerokie dla dzieci)

### Pomysły rozwiązania:

#### Pomysł A: Kategorie wiekowe z automatycznymi ograniczeniami
- Dzieci (5-14 lat): tylko 14:00-19:00 (po szkole)
- Młodzież (15-18 lat): 12:00-20:00 
- Dorośli (18+): 08:00-20:00
- **Ocena: ⭐⭐⭐⭐⭐⭐⭐⭐ (8/10)** - logiczne, proste w implementacji

#### Pomysł B: Flaga "czy_uczy_sie_w_szkole" dla ucznia
- Jeśli TAK → lekcje tylko po 14:00
- Jeśli NIE → dowolne godziny
- **Ocena: ⭐⭐⭐⭐⭐⭐⭐ (7/10)** - wymaga ręcznego ustawiania flagi

#### Pomysł C: Indywidualne okno czasowe dla każdego ucznia
- Każdy uczeń ma godzina_od, godzina_do
- Elastyczne, ale wymaga więcej danych
- **Ocena: ⭐⭐⭐⭐⭐⭐ (6/10)** - za dużo komplikacji

#### Pomysł D: Bez ograniczeń - sekretariat wie co robi
- Ufamy że sekretariat nie zaplanuje lekcji w złych godzinach
- **Ocena: ⭐⭐⭐⭐ (4/10)** - brak automatyzacji, prowadzący się przyczepi

#### Pomysł E: Prosty podział na "dziecko" (do 15 lat) i "dorosły"
- Dziecko: 14:00-19:00
- Dorosły: 08:00-20:00
- **Ocena: ⭐⭐⭐⭐⭐⭐⭐⭐⭐ (9/10)** - najprostsze i logiczne!

### ✅ DECYZJA: Pomysł E
Prosty podział: uczniowie poniżej 15 lat (w szkole podstawowej/gimnazjum) mają lekcje tylko 14:00-19:00.

---

## 🎯 Problem 2: Balans Obciążenia Nauczycieli

### Obecny stan:
- Brak limitów - nauczyciel może mieć nieskończenie wiele lekcji

### Pomysły rozwiązania:

#### Pomysł A: Max godzin dziennie (np. 6h)
- Trigger sprawdza przy planowaniu lekcji
- Prosta implementacja
- **Ocena: ⭐⭐⭐⭐⭐⭐⭐⭐⭐ (9/10)** - proste i skuteczne

#### Pomysł B: Max godzin tygodniowo (np. 30h)
- Bardziej elastyczne (można mieć 8h jednego dnia, 2h innego)
- **Ocena: ⭐⭐⭐⭐⭐⭐⭐ (7/10)** - dobre, ale trudniejsze do sprawdzenia

#### Pomysł C: Min/Max z przerwami między lekcjami
- Przerwa min 15 min między lekcjami
- Max 6h dziennie
- **Ocena: ⭐⭐⭐⭐⭐⭐⭐⭐ (8/10)** - realistyczne

#### Pomysł D: Etat jako atrybut nauczyciela
- Pełny etat: max 40h/tydzień
- Pół etatu: max 20h/tydzień
- **Ocena: ⭐⭐⭐⭐⭐⭐ (6/10)** - dodatkowa komplikacja

#### Pomysł E: Tylko max dzienny bez tygodniowego
- Max 6h dziennie to ~30h tygodniowo i tak
- **Ocena: ⭐⭐⭐⭐⭐⭐⭐⭐⭐ (9/10)** - KISS principle

### ✅ DECYZJA: Pomysł A + przerwy
- Max 6 godzin lekcyjnych dziennie per nauczyciel
- Min 15 minut przerwy między lekcjami (opcjonalnie)

---

## 🎯 Problem 3: Balans Obciążenia Uczniów

### Obecny stan:
- Brak limitów dla uczniów

### Pomysły rozwiązania:

#### Pomysł A: Max lekcji dziennie (np. 2)
- Dziecko nie powinno mieć więcej niż 2 lekcje muzyki dziennie
- **Ocena: ⭐⭐⭐⭐⭐⭐⭐⭐⭐ (9/10)** - logiczne

#### Pomysł B: Max lekcji tygodniowo per kurs
- Np. max 2 lekcje fortepianu tygodniowo
- **Ocena: ⭐⭐⭐⭐⭐⭐⭐ (7/10)** - sensowne

#### Pomysł C: Max łącznych lekcji tygodniowo (np. 5)
- Uczeń może mieć max 5 lekcji wszystkich kursów w tygodniu
- **Ocena: ⭐⭐⭐⭐⭐⭐⭐⭐ (8/10)** - rozsądne

#### Pomysł D: Przerwa min 30 min między lekcjami ucznia
- Żeby zdążył odpocząć
- **Ocena: ⭐⭐⭐⭐⭐⭐⭐ (7/10)** - miłe ale może komplikować

### ✅ DECYZJA: Pomysł A
- Max 2 lekcje dziennie per uczeń
- Prostsze i wystarczające

---

## 🎯 Problem 4: System Planowania na 1 Semestr

### Obecny stan:
- Brak koncepcji semestru
- Lekcje są pojedyncze

### Pomysły rozwiązania:

#### Pomysł A: Tabela T_SEMESTR + T_HARMONOGRAM
- Semestr: data_od, data_do, czy_aktywny
- Harmonogram: stały plan tygodniowy (np. Kowalski, Pon, 10:00, Fortepian)
- Generowanie lekcji z harmonogramu
- **Ocena: ⭐⭐⭐⭐⭐⭐⭐⭐ (8/10)** - dobre ale 2 nowe tabele

#### Pomysł B: Flagi semestru w istniejących tabelach
- Dodaj semestr do t_lekcja (np. "2025/2026_Z" - zimowy)
- Bez osobnej tabeli
- **Ocena: ⭐⭐⭐⭐⭐⭐⭐ (7/10)** - prostsze ale mniej eleganckie

#### Pomysł C: Tylko T_SEMESTR jako kontekst
- Tabela semestru definiuje ramy czasowe
- Lekcje muszą być w ramach aktywnego semestru
- **Ocena: ⭐⭐⭐⭐⭐⭐⭐⭐⭐ (9/10)** - wystarczające i proste!

#### Pomysł D: Bez zmian - semestr to logiczny okres
- Po prostu lekcje w danym okresie to semestr
- **Ocena: ⭐⭐⭐⭐⭐ (5/10)** - prowadzący się przyczepi

### ✅ DECYZJA: Pomysł C
- Nowa tabela T_SEMESTR: id, nazwa, data_od, data_do, czy_aktywny
- Trigger waliduje że lekcje są w ramach aktywnego semestru

---

## 🎯 Problem 5: Sale Lekcyjne

### Obecny stan:
- Brak koncepcji sal - gdzie odbywają się lekcje?

### Pomysły rozwiązania:

#### Pomysł A: Tabela T_SALA + przypisanie do lekcji
- Sala: id, nazwa, pojemnosc, wyposazenie (np. fortepian)
- Lekcja ma REF do sali
- **Ocena: ⭐⭐⭐⭐⭐⭐⭐⭐⭐ (9/10)** - logiczne i przydatne

#### Pomysł B: Sala jako atrybut lekcji (VARCHAR)
- Prosty string "Sala 101"
- **Ocena: ⭐⭐⭐⭐⭐⭐ (6/10)** - nie obiektowe

#### Pomysł C: Bez sal - lekcje online lub w domu nauczyciela
- **Ocena: ⭐⭐⭐ (3/10)** - nierealistyczne dla szkoły muzycznej

#### Pomysł D: Sala przypisana do nauczyciela (stała)
- Każdy nauczyciel ma swoją salę
- **Ocena: ⭐⭐⭐⭐⭐⭐⭐ (7/10)** - prostsze ale mniej elastyczne

### ✅ DECYZJA: Pomysł A
- Nowa tabela T_SALA z typem t_sala_obj
- REF w t_lekcja do sali
- Trigger sprawdza konflikt sal (2 lekcje w tej samej sali o tej samej godzinie)

---

## 🎯 Problem 6: Typy Lekcji (Indywidualne vs Grupowe)

### Obecny stan:
- Wszystkie lekcje są indywidualne (1 uczeń)

### Pomysły rozwiązania:

#### Pomysł A: Flaga typ_lekcji + NESTED TABLE uczniów
- typ_lekcji: 'indywidualna' | 'grupowa'
- Dla grupowej: lista uczniów (NESTED TABLE)
- **Ocena: ⭐⭐⭐⭐⭐⭐⭐ (7/10)** - komplikuje model

#### Pomysł B: Osobna tabela T_LEKCJA_GRUPOWA
- Lekcja grupowa ma innych uczestników
- **Ocena: ⭐⭐⭐⭐⭐⭐ (6/10)** - duplikacja logiki

#### Pomysł C: Flaga typ_lekcji, max_uczniow + tabela pośrednia T_UCZESTNIK_LEKCJI
- Lekcja może mieć wielu uczniów przez tabelę pośrednią
- **Ocena: ⭐⭐⭐⭐⭐⭐⭐⭐ (8/10)** - elastyczne

#### Pomysł D: Zostaw jak jest - wszystko indywidualne
- Szkoła muzyczna = głównie lekcje indywidualne
- **Ocena: ⭐⭐⭐⭐⭐⭐⭐⭐⭐ (9/10)** - KISS, mniej komplikacji

### ✅ DECYZJA: Pomysł D
- Zostajemy przy lekcjach indywidualnych
- To szkoła muzyczna - nauka gry jest głównie 1:1
- Prostota > kompletność

---

## 🎯 Problem 7: Kompleksowe Testy

### Obecny stan:
- Brak testów w projekcie

### Co musi być przetestowane:

1. **Testy typów** - metody działają poprawnie
2. **Testy tabel** - constraints działają (CHECK, UNIQUE, NOT NULL)
3. **Testy pakietów** - procedury/funkcje działają
4. **Testy triggerów** - walidacje blokują złe dane
5. **Testy scenariuszy** - pełne workflow od A do Z
6. **Testy błędnych danych** - system odrzuca nieprawidłowe dane
7. **Testy konfliktów** - podwójne rezerwacje, przekroczenia limitów
8. **Testy uprawnień** - role mają odpowiednie dostępy

### Scenariusze do przetestowania:

```
SCENARIUSZ 1: Pełny cykl życia ucznia
- Dodanie ucznia → Zapisanie na kurs → Zaplanowanie lekcji → 
- Przeprowadzenie lekcji → Wystawienie oceny → Raport postępu

SCENARIUSZ 2: Planowanie semestru
- Utworzenie semestru → Dodanie lekcji w ramach semestru →
- Próba dodania lekcji poza semestrem (BŁĄD)

SCENARIUSZ 3: Konflikty w planie
- Nauczyciel zajęty → Sala zajęta → Uczeń zajęty →
- Wszystkie powinny być zablokowane

SCENARIUSZ 4: Limity obciążenia
- Nauczyciel z 6h lekcji → Próba dodania 7. godziny (BŁĄD)
- Uczeń z 2 lekcjami → Próba dodania 3. lekcji (BŁĄD)

SCENARIUSZ 5: Ograniczenia wiekowe
- Dziecko 10 lat → Lekcja o 10:00 (BŁĄD - powinien być w szkole)
- Dorosły 25 lat → Lekcja o 10:00 (OK)

SCENARIUSZ 6: Blokady usunięć
- Usunięcie ucznia z lekcjami (BŁĄD)
- Usunięcie nauczyciela z lekcjami (BŁĄD)
- Usunięcie sali z lekcjami (BŁĄD)

SCENARIUSZ 7: Błędne dane
- Email bez @, ocena 7, godzina 25:00, ujemna cena
- Wszystkie powinny być odrzucone
```

---

## 📊 Podsumowanie Decyzji

| Problem | Decyzja | Nowe elementy |
|---------|---------|---------------|
| Godziny dla dzieci | Dziecko (<15): 14:00-19:00 | Trigger walidujący |
| Limit nauczyciela | Max 6h dziennie | Trigger walidujący |
| Limit ucznia | Max 2 lekcje dziennie | Trigger walidujący |
| Semestr | Nowa tabela T_SEMESTR | 1 typ + 1 tabela |
| Sale | Nowa tabela T_SALA | 1 typ + 1 tabela |
| Typy lekcji | Tylko indywidualne | Bez zmian |
| Testy | 7 kategorii scenariuszy | Plik 06_testy.sql |

### Nowe typy/tabele do dodania:
1. `t_semestr_obj` + `t_semestr`
2. `t_sala_obj` + `t_sala`

### Nowe triggery do dodania:
1. `trg_lekcja_godziny_dziecka` - walidacja godzin dla dzieci
2. `trg_lekcja_limit_nauczyciela` - max 6h dziennie
3. `trg_lekcja_limit_ucznia` - max 2 lekcje dziennie
4. `trg_lekcja_konflikt_sali` - sala nie może być zajęta
5. `trg_lekcja_semestr` - lekcja w ramach aktywnego semestru

### Całkowita liczba elementów (po zmianach):
- **Typy:** 9 (było 7, +2)
- **Tabele:** 8 (było 6, +2)
- **Triggery:** 10 (było 5, +5)
- **Pakiety:** 3 (bez zmian, może dodać pkg_semestr)

**Limit 10 tabel:** 8 tabel = OK ✅

---

## 🎯 Kolejne Kroki

1. ✅ Burza mózgów (ten plik)
2. ⬜ Ocena pomysłów i finalne decyzje (02_ocena_pomyslow.md)
3. ⬜ Aktualizacja 01_typy.sql (dodanie t_semestr_obj, t_sala_obj)
4. ⬜ Aktualizacja 02_tabele.sql (dodanie tabel)
5. ⬜ Aktualizacja 03_pakiety.sql (nowe procedury)
6. ⬜ Aktualizacja 04_triggery.sql (nowe walidacje)
7. ⬜ Aktualizacja 05_dane.sql (dane dla nowych tabel)
8. ⬜ Stworzenie 06_testy.sql (kompleksowe testy!)
9. ⬜ Aktualizacja 07_uzytkownicy.sql (uprawnienia do nowych obiektów)
10. ⬜ Aktualizacja Raport_MusicSchoolDB.tex (dokumentacja)
