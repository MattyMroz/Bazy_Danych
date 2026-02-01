# 🎼 SZKOŁA MUZYCZNA - ZAŁOŻENIA PROJEKTOWE v7

## Wersja 7.0 | Luty 2026
## Autorzy: Igor Typiński (251237), Mateusz Mróz (251190)

---

# 1. ZAŁOŻENIA OGÓLNE

1. System obsługuje **małą szkołę muzyczną I stopnia** (6-letni cykl kształcenia).
2. Godziny pracy szkoły: **14:00 - 20:00**.
3. Dni pracy: **poniedziałek - piątek** (5 dni).
4. Lekcje nie mogą zaczynać się przed 14:00.
5. Lekcje nie mogą kończyć się po 20:00.
6. Rok szkolny: format 'RRRR/RRRR' (np. '2025/2026').

---

# 2. ZAŁOŻENIA - UCZNIOWIE

7. Każdy uczeń należy do **dokładnie jednej grupy** (REF NOT NULL).
8. Każdy uczeń gra na **jednym instrumencie głównym** (pole instrument NOT NULL).
9. Każdy uczeń ma **2 lekcje instrumentu tygodniowo** (indywidualne, 45 min).
10. Uczeń **nie może mieć dwóch zajęć w tym samym czasie** (sprawdzane są zarówno lekcje indywidualne jak i grupowe).
11. Data zapisu ucznia jest ustawiana automatycznie na dzień dodania (trigger).
12. Uczeń identyfikowany jest przez parę: imię + nazwisko.

---

# 3. ZAŁOŻENIA - GRUPY

13. Grupa ma **kod** (np. '1A', '2A') - unikalny.
14. Grupa ma **klasę** w zakresie **1-6** (constraint CHECK).
15. Każda grupa ma **1 lekcję kształcenia słuchu tygodniowo** (grupowe, 45 min).
16. Zajęcia grupowe odbywają się dla **całej grupy naraz**.
17. W systemie jest **6 grup** - po jednej na każdą klasę.

---

# 4. ZAŁOŻENIA - NAUCZYCIELE

18. Nauczyciel ma **jeden instrument** lub **NULL** (przedmioty grupowe).
19. Nauczyciel z instrumentem = NULL prowadzi **tylko zajęcia grupowe**.
20. Nauczyciel **nie może mieć dwóch lekcji w tym samym czasie**.
21. Nauczyciel identyfikowany jest przez **nazwisko** (zakładamy unikalne).
22. Nauczyciel wystawia **oceny bieżące i semestralne**.

---

# 5. ZAŁOŻENIA - SALE

23. Sala ma **typ**: 'indywidualna' lub 'grupowa' (constraint CHECK).
24. Sala ma **pojemność** większą od 0 (constraint CHECK).
25. Sala ma **wyposażenie** jako VARRAY(10) elementów VARCHAR2(50).
26. Sala **nie może mieć dwóch lekcji w tym samym czasie**.
27. Sala identyfikowana jest przez **numer** (unikalny).
28. Sale indywidualne: pojemność 3 osoby, na lekcje 1:1.
29. Sala grupowa: pojemność 15 osób, na kształcenie słuchu.

---

# 6. ZAŁOŻENIA - PRZEDMIOTY

30. Przedmiot ma **typ zajęć**: 'indywidualny' lub 'grupowy' (constraint CHECK).
31. Przedmiot ma **czas trwania**: 30, 45, 60 lub 90 minut (constraint CHECK).
32. Przedmiot identyfikowany jest przez **nazwę** (unikalna).
33. System obsługuje **5 przedmiotów**: Fortepian, Skrzypce, Gitara, Flet, Kształcenie słuchu.
34. Przedmioty instrumentalne są **indywidualne**, kształcenie słuchu jest **grupowe**.

---

# 7. ZAŁOŻENIA - LEKCJE

35. Lekcja jest **ALBO indywidualna ALBO grupowa** - nigdy oba (constraint XOR).
36. Lekcja indywidualna: ref_uczen NOT NULL, ref_grupa NULL.
37. Lekcja grupowa: ref_uczen NULL, ref_grupa NOT NULL.
38. Czas trwania lekcji: **30, 45, 60 lub 90 minut** (constraint CHECK + trigger).
39. Godzina startu w formacie **'HH24:MI'** (np. '14:00', '15:30').
40. **Nie może być konfliktów**: ta sama sala/nauczyciel/uczeń w tym samym czasie.
41. Każda lekcja ma: datę, godzinę rozpoczęcia, czas trwania.
42. Lekcja powiązana jest przez REF z: przedmiotem, nauczycielem, salą, uczniem/grupą.

---

# 8. ZAŁOŻENIA - OCENY

43. Skala ocen: **1, 2, 3, 4, 5, 6** (constraint CHECK + trigger).
44. Ocena jest **bieżąca** (czy_semestralna = 'N') lub **semestralna** ('T').
45. Ocena powiązana jest przez REF z: uczniem, nauczycielem, przedmiotem.
46. Średnia ucznia liczona jest tylko z **ocen bieżących** (nie semestralnych).
47. Ocena ma datę wystawienia.

---

# 9. ZAŁOŻENIA - WALIDACJA KONFLIKTÓW

48. Przy dodawaniu lekcji sprawdzana jest **dostępność sali** w danym terminie.
49. Przy dodawaniu lekcji sprawdzana jest **dostępność nauczyciela** w danym terminie.
50. Przy dodawaniu lekcji sprawdzana jest **dostępność ucznia** w danym terminie.
51. Algorytm wykrywania kolizji: `start1 < koniec2 AND start2 < koniec1`.
52. Dla ucznia sprawdzane są **zarówno lekcje indywidualne jak i grupowe** jego grupy.

---

# 10. ZAŁOŻENIA - HEURYSTYKA PLANOWANIA

53. Przy dodawaniu nowego ucznia system **automatycznie przydziela mu 2 lekcje instrumentu**.
54. System szuka wolnych slotów gdzie:
    - Nauczyciel od jego instrumentu jest wolny
    - Jakaś sala indywidualna jest wolna
    - Uczeń nie ma wtedy innych zajęć
55. Sloty czasowe dla lekcji indywidualnych: **14:00, 14:45, 15:30, 16:15, 17:00, 17:45, 18:30, 19:15**.
56. Sloty czasowe dla lekcji grupowych: **14:00, 15:00, 16:00, 17:00, 18:00**.
57. System przydziela lekcje w **różnych dniach tygodnia** (iteruje po dniach pon-pt).
58. Generowanie planu tygodnia składa się z 2 kroków:
    - KROK 1: Lekcje grupowe (kształcenie słuchu dla każdej grupy)
    - KROK 2: Lekcje indywidualne (dla każdego ucznia 2 lekcje instrumentu)

---

# 11. ZAŁOŻENIA - TRIGGERY

59. Trigger `trg_ocena_zakres`: waliduje że ocena jest w zakresie 1-6.
60. Trigger `trg_lekcja_xor`: waliduje że lekcja ma ucznia XOR grupę (nie oba, nie żaden).
61. Trigger `trg_czas_trwania`: waliduje że czas trwania lekcji to 30, 45, 60 lub 90 min.
62. Trigger `trg_uczen_data_zapisu`: automatycznie ustawia datę zapisu na SYSDATE.

---

# 12. ŚWIADOME UPROSZCZENIA (czego NIE MA w systemie)

63. **Brak różnego czasu lekcji wg klasy** - stały czas 45 min dla wszystkich.
64. **Brak chóru i orkiestry** - tylko kształcenie słuchu jako jedyne zajęcia grupowe.
65. **Brak rytmiki i audycji** - uproszczenie przedmiotów grupowych.
66. **Brak obszarów ocen** (technika, interpretacja) - tylko wartość liczbowa 1-6.
67. **Brak limitu godzin nauczyciela** - nie walidujemy max 30h/tydzień.
68. **Brak walidacji wyposażenia sali vs przedmiot** - nie sprawdzamy czy sala ma fortepian.
69. **Brak zastępstw nauczycieli**.
70. **Brak urlopów i nieobecności**.
71. **Brak koncertów i występów**.
72. **Brak wypożyczalni instrumentów**.

---

# 13. DANE TESTOWE W SYSTEMIE

73. **5 przedmiotów**: Fortepian, Skrzypce, Gitara, Flet, Kształcenie słuchu.
74. **4 sale**: 3 indywidualne (101, 102, 103) + 1 grupowa (201).
75. **6 grup**: 1A, 2A, 3A, 4A, 5A, 6A (klasy 1-6).
76. **6 nauczycieli**: Kowalska (fortepian), Nowak (skrzypce), Wiśniewska (gitara), Lewandowski (flet), Kamińska (grupowe), Zieliński (fortepian).
77. **24 uczniów**: 4 uczniów w każdej grupie.
78. Rozkład instrumentów: Fortepian: 8, Skrzypce: 4, Gitara: 4, Flet: 4.

---

# 14. KODY BŁĘDÓW

| Kod | Komunikat |
|-----|-----------|
| -20001 | Przedmiot nie znaleziony |
| -20002 | Sala nie znaleziona |
| -20003 | Grupa nie znaleziona |
| -20004 | Nauczyciel nie znaleziony |
| -20005 | Wielu nauczycieli o nazwisku |
| -20006 | Uczeń nie znaleziony |
| -20007 | Wielu uczniów |
| -20010 | Sala zajęta w tym terminie |
| -20011 | Nauczyciel zajęty w tym terminie |
| -20012 | Uczeń zajęty w tym terminie |
| -20101 | Lekcje nie mogą zaczynać się przed 14:00 |
| -20102 | Lekcje nie mogą kończyć się po 20:00 |
| -20103 | Ocena musi być w zakresie 1-6 |
| -20201 | Ocena musi być w zakresie 1-6 (trigger) |
| -20202 | Lekcja nie może mieć jednocześnie ucznia i grupy |
| -20203 | Lekcja musi mieć przypisanego ucznia lub grupę |
| -20204 | Czas trwania lekcji musi wynosić 30, 45, 60 lub 90 minut |

---

# 15. SCENARIUSZE UŻYCIA

## SCENARIUSZ 1: Nowy uczeń zapisuje się do szkoły

**Historia:** Przychodzi nowy uczeń - Karol Nowy, chce grać na fortepianie, zapisywany do klasy 2A.

```sql
-- 1. Dodaj ucznia
EXEC PKG_OSOBY.dodaj_ucznia('Karol', 'Nowy', DATE '2018-05-20', '2A', 'Fortepian');

-- 2. Wygeneruj plan (przydzieli mu 2 lekcje fortepianu + lekcję grupową z grupą 2A)
EXEC PKG_LEKCJE.generuj_plan_tygodnia(DATE '2026-02-02');

-- 3. Sprawdź plan ucznia
EXEC PKG_LEKCJE.plan_ucznia('Nowy', 'Karol');

-- 4. Sprawdź listę uczniów w grupie
EXEC PKG_OSOBY.lista_uczniow_w_grupie('2A');
```

---

## SCENARIUSZ 2: Nowy nauczyciel dołącza do szkoły

**Historia:** Szkoła zatrudnia nowego nauczyciela gitary - Adam Gitarowy.

```sql
-- 1. Dodaj nauczyciela
EXEC PKG_OSOBY.dodaj_nauczyciela('Adam', 'Gitarowy', 'Gitara', 'adam.gitarowy@szkola.pl');

-- 2. Usuń stare lekcje i wygeneruj plan od nowa
DELETE FROM LEKCJE;
EXEC PKG_LEKCJE.generuj_plan_tygodnia(DATE '2026-02-02');

-- 3. Sprawdź plan nowego nauczyciela
EXEC PKG_LEKCJE.plan_nauczyciela('Gitarowy');

-- 4. Sprawdź raport nauczycieli
EXEC PKG_RAPORTY.raport_nauczycieli();
```

---

## SCENARIUSZ 3: Nauczyciel wystawia oceny

**Historia:** Pani Kowalska wystawia oceny uczniowi Janowi Kotkowi z fortepianu.

```sql
-- 1. Wystaw oceny bieżące
EXEC PKG_OCENY.wystaw_ocene('Kotek', 'Jan', 'Kowalska', 'Fortepian', 4);
EXEC PKG_OCENY.wystaw_ocene('Kotek', 'Jan', 'Kowalska', 'Fortepian', 5);
EXEC PKG_OCENY.wystaw_ocene('Kotek', 'Jan', 'Kowalska', 'Fortepian', 5);

-- 2. Sprawdź oceny ucznia
EXEC PKG_OCENY.oceny_ucznia('Kotek', 'Jan');

-- 3. Oblicz średnią
SELECT PKG_OCENY.srednia_ucznia('Kotek', 'Jan', 'Fortepian') AS srednia FROM DUAL;

-- 4. Wystaw ocenę semestralną
EXEC PKG_OCENY.wystaw_ocene_semestralna('Kotek', 'Jan', 'Kowalska', 'Fortepian', 5);
```

---

## SCENARIUSZ 4: Konflikt - próba dodania kolidującej lekcji

**Historia:** Próba dodania lekcji gdy sala jest już zajęta.

```sql
-- 1. Dodaj lekcję
EXEC PKG_LEKCJE.dodaj_lekcje_indywidualna('Fortepian', 'Kowalska', '101', 'Kotek', 'Jan', DATE '2026-02-09', '14:00', 45);

-- 2. Próba dodania drugiej lekcji w tym samym czasie i sali - BŁĄD -20010
EXEC PKG_LEKCJE.dodaj_lekcje_indywidualna('Fortepian', 'Zielinski', '101', 'Kwiatek', 'Ola', DATE '2026-02-09', '14:00', 45);
-- Oczekiwany błąd: ORA-20010: Sala 101 zajeta w tym terminie

-- 3. Próba lekcji przed 14:00 - BŁĄD -20101
EXEC PKG_LEKCJE.dodaj_lekcje_indywidualna('Fortepian', 'Kowalska', '101', 'Kotek', 'Jan', DATE '2026-02-10', '13:00', 45);
-- Oczekiwany błąd: ORA-20101: Lekcje nie moga zaczynac sie przed 14:00
```

---

## SCENARIUSZ 5: Generowanie planu i raporty

**Historia:** Początek semestru - generujemy plan i sprawdzamy statystyki.

```sql
-- 1. Wygeneruj plan
EXEC PKG_LEKCJE.generuj_plan_tygodnia(DATE '2026-02-02');

-- 2. Statystyki lekcji
EXEC PKG_RAPORTY.statystyki_lekcji();

-- 3. Plan grupy
EXEC PKG_LEKCJE.plan_grupy('1A');

-- 4. Plan nauczyciela
EXEC PKG_LEKCJE.plan_nauczyciela('Kowalska');

-- 5. Obłożenie sali
EXEC PKG_LEKCJE.plan_sali('101', DATE '2026-02-02');

-- 6. Raport grup
EXEC PKG_RAPORTY.raport_grup();
```

---

## SCENARIUSZ 6: Demonstracja metod obiektowych

```sql
-- Metoda wiek() i pelne_nazwisko() dla uczniów
SELECT u.pelne_nazwisko() AS uczen, u.wiek() AS wiek, u.instrument
FROM UCZNIOWIE u ORDER BY u.wiek() DESC;

-- Metoda czy_grupowy() dla przedmiotów
SELECT p.nazwa, p.czy_grupowy() AS grupowy FROM PRZEDMIOTY p;

-- Metoda godzina_koniec() dla lekcji
SELECT l.godzina_start, l.godzina_koniec() AS koniec, DEREF(l.ref_przedmiot).nazwa AS przedmiot
FROM LEKCJE l WHERE ROWNUM <= 5;

-- Metoda opis_oceny() dla ocen
SELECT DEREF(o.ref_uczen).pelne_nazwisko() AS uczen, o.wartosc, o.opis_oceny() AS slownie
FROM OCENY o;
```

---

*Wersja: 7.0 | Luty 2026*
*Autorzy: Igor Typiński (251237), Mateusz Mróz (251190)*
