# 🎼 SZKOŁA MUZYCZNA - ZAŁOŻENIA (WERSJA FINALNA)

---

## PODSTAWOWE PYTANIE: CZY TO SIĘ MIEŚCI?

Zanim napiszę założenia, muszę policzyć czy to w ogóle działa.

### Dane wejściowe:
- Pracujemy **Pn-Pt** (5 dni)
- Pracujemy **14:00-20:00** (6 godzin dziennie)
- Mamy **8 sal**

### Obliczenia:

**Dostępny czas:**
- 1 sala = 6h × 5 dni = **30h tygodniowo**
- 8 sal = 8 × 30h = **240h tygodniowo łącznie**

**Ale sale są różne:**
- 4 sale indywidualne (małe, 2-3 osoby)
- 2 sale grupowe (15-20 osób)
- 2 sale wielofunkcyjne (egzaminy, zespoły)

**Czas na lekcje indywidualne:**
- 4 sale × 30h = **120h tygodniowo**
- Lekcja trwa średnio 45min = 0.75h
- 120h ÷ 0.75h = **~160 slotów** na lekcje indywidualne

**Wniosek:**
- Możemy obsłużyć **max 80-100 uczniów** (każdy 1 lekcja tygodniowo)
- Z zapasem na przerwy między lekcjami i niepełne wykorzystanie

**To się zgadza. Idziemy dalej.**

---

## ZAŁOŻENIA PROJEKTOWE

### SZKOŁA

1. Prywatna szkoła muzyczna z uprawnieniami państwowymi.

2. Cykl nauczania trwa 6 lat (klasy I do VI).

3. Szkoła pracuje od poniedziałku do piątku.

4. Lekcje odbywają się od 14:00 do 20:00 (popołudnia, bo uczniowie rano w szkołach).

5. Szkoła ma 8 sal:
   - 4 sale indywidualne (pojemność 3 osoby)
   - 2 sale grupowe (pojemność 15-20 osób)
   - 2 sale wielofunkcyjne (pojemność 25-30 osób)

6. Szkoła uczy 5 instrumentów: fortepian, skrzypce, gitara, flet, perkusja.

---

### UCZNIOWIE

7. Przyjmujemy dzieci od 6 roku życia.

8. Każdy uczeń uczy się dokładnie jednego instrumentu głównego.

9. Każdy uczeń należy do jednej grupy (np. 1A, 2B, 3A).

10. Każdy uczeń ma obowiązkowo:
    - 1 lekcję indywidualną instrumentu tygodniowo
    - 1 lekcję grupową teorii muzyki tygodniowo

11. Uczeń nie może mieć dwóch lekcji w tym samym czasie.

12. Szkoła przyjmuje maksymalnie 80-100 uczniów (ograniczenie wynikające z liczby sal).

---

### GRUPY

13. Grupa to uczniowie tej samej klasy, np. "1A" = pierwsza grupa klasy I.

14. W grupie może być maksymalnie 15 uczniów.

15. Lekcje grupowe (teoria, rytmika) odbywają się dla całej grupy naraz.

---

### NAUCZYCIELE

16. Szkoła zatrudnia około 10-12 nauczycieli.

17. Nauczyciel może uczyć maksymalnie 5 różnych instrumentów (ograniczenie VARRAY).

18. Nauczyciel może prowadzić zajęcia indywidualne, grupowe, lub oba typy.

19. Nauczyciel pracuje maksymalnie 6 godzin dziennie.

20. Nauczyciel nie może mieć dwóch lekcji w tym samym czasie.

---

### SALE

21. Każda sala ma określoną pojemność (ile osób może pomieścić).

22. Każda sala ma typ: indywidualna, grupowa, wielofunkcyjna.

23. Każda sala ma wyposażenie (np. fortepian, tablica, perkusja).

24. Lekcja indywidualna może być w sali indywidualnej lub wielofunkcyjnej.

25. Lekcja grupowa może być tylko w sali grupowej lub wielofunkcyjnej.

26. Sala nie może mieć dwóch lekcji w tym samym czasie.

---

### LEKCJE

27. Lekcja jest ALBO indywidualna (1 uczeń) ALBO grupowa (cała grupa). Nigdy oba naraz.

28. Lekcja trwa 30, 45 lub 60 minut.

29. Lekcja ma status: zaplanowana, odbyta, odwołana.

30. Każda lekcja wymaga: nauczyciela, sali, daty, godziny rozpoczęcia.

31. Lekcja indywidualna wymaga dodatkowo: ucznia.

32. Lekcja grupowa wymaga dodatkowo: grupy.

---

### PLANOWANIE LEKCJI (HEURYSTYKA)

33. Plan układamy według zasady "najpierw trudne":
    - KROK 1: Układamy lekcje grupowe (blokują dużą salę + wielu uczniów)
    - KROK 2: Układamy lekcje indywidualne (prostsze do wpasowania)

34. Przy planowaniu sprawdzamy konflikty:
    - Czy sala jest wolna?
    - Czy nauczyciel jest wolny?
    - Czy uczeń/grupa jest wolna?

35. Jeśli jest konflikt, szukamy innego terminu.

---

### OCENY

36. Stosujemy polską skalę ocen: 1, 2, 3, 4, 5, 6.

37. Oceniamy w obszarach: technika, interpretacja, teoria, postępy.

38. Nauczyciel może wystawić ocenę po każdej lekcji.

39. Każda ocena jest przypisana do: ucznia, nauczyciela, daty.

---

### EGZAMINY (UPROSZCZONE)

40. Egzamin to specjalny typ lekcji z `typ = 'egzamin'`.

41. Egzamin wymaga komisji składającej się z 2 nauczycieli.

42. Obaj nauczyciele w komisji muszą być różnymi osobami.

43. Egzamin odbywa się w sali wielofunkcyjnej.

---

## CZEGO NIE ROBIMY (ŚWIADOME UPROSZCZENIA)

- ❌ Nie modelujemy urlopów nauczycieli
- ❌ Nie modelujemy remontów sal
- ❌ Nie modelujemy wypożyczeń instrumentów
- ❌ Nie modelujemy wielu semestrów (zakładamy 1 semestr)
- ❌ Nie rozróżniamy wieku uczniów przy godzinach (wszyscy od 14:00)

---

## WYMAGANIA TECHNICZNE (Z POLECENIA PROWADZĄCEGO)

### Musimy użyć:

44. **Typy obiektowe** z metodami (np. oblicz_wiek, czy_wolny).

45. **Tabele obiektowe** przechowujące obiekty wierszowe.

46. **REF i DEREF** do relacji między obiektami (np. lekcja → nauczyciel).

47. **VARRAY** do kolekcji (np. lista instrumentów nauczyciela, wyposażenie sali).

48. **Pakiety PL/SQL** z procedurami i funkcjami (CRUD, planowanie, raporty).

49. **Kursory** do przetwarzania danych.

50. **Wyzwalacze (triggery)** do walidacji (np. komisja = 2 różnych nauczycieli).

51. **Obsługa błędów** (EXCEPTION).

52. **Role użytkowników**: uczeń, nauczyciel, sekretariat, administrator.

---

## MINIMALNA STRUKTURA TABEL

Na podstawie założeń potrzebuję **6 tabel**:

1. **INSTRUMENTY** - słownik instrumentów (5-10 rekordów)
2. **NAUCZYCIELE** - kadra (10-12 rekordów)
3. **UCZNIOWIE** - uczniowie z przypisaną grupą (80-100 rekordów)
4. **SALE** - pomieszczenia (8 rekordów)
5. **LEKCJE** - harmonogram + egzaminy (150+ tygodniowo)
6. **OCENY** - oceny bieżące (kilkaset na semestr)

---

## DIAGRAM RELACJI

```
INSTRUMENTY ←──REF── NAUCZYCIELE (VARRAY instrumentów)
     ↑
     │REF
     │
UCZNIOWIE ──REF──→ (grupa jako pole VARCHAR2)
     ↑
     │REF
     │
LEKCJE ──REF──→ NAUCZYCIELE
   │   ──REF──→ SALE
   │   ──REF──→ UCZNIOWIE (dla indywidualnych)
   │
   ↓
OCENY ──REF──→ UCZNIOWIE
      ──REF──→ NAUCZYCIELE
```

---

## PODSUMOWANIE

**43 założenia biznesowe + 9 technicznych = 52 założenia łącznie**

Wszystko się bilansuje:
- 8 sal × 30h = 240h tygodniowo
- 80-100 uczniów × 1 lekcja = 60-75h indywidualnych
- 10-15 grup × 2 lekcje = 20-30h grupowych
- Razem: ~100h wykorzystane z 240h dostępnych ✓

Projekt jest wykonalny.

---

*Wersja: 1.0 | Data: Luty 2026*
