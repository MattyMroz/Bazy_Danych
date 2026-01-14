# 📊 Ocena Pomysłów - Szkoła Muzyczna (Oracle)

## 🏆 Podsumowanie ocen

| Aspekt | Ocena | Komentarz |
|--------|-------|-----------|
| **Wariant struktury** | Wariant A | ⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐ (10/10) |
| **VARRAY vs NESTED TABLE** | VARRAY | ⭐⭐⭐⭐⭐⭐⭐⭐⭐ (9/10) |
| **Liczba tabel** | 6 tabel | ⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐ (10/10) |
| **Pakiety PL/SQL** | 3 pakiety | ⭐⭐⭐⭐⭐⭐⭐⭐⭐ (9/10) |
| **Triggery** | 2 triggery | ⭐⭐⭐⭐⭐⭐⭐⭐ (8/10) |

---

## ✅ DECYZJA: Wariant A (Minimalistyczny - 6 tabel)

### Uzasadnienie:
- ⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐ **Prostota** - łatwy do zrozumienia i prezentacji
- ⭐⭐⭐⭐⭐⭐⭐⭐⭐ **Kompletność** - spełnia wszystkie wymagania
- ⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐ **Zgodność z tematem** - nacisk na rozwój ucznia (oceny, postępy)
- ⭐⭐⭐⭐⭐⭐⭐⭐ **Możliwość rozbudowy** - można łatwo dodać więcej

### Odrzucone warianty:
- **Wariant B** (8 tabel) - zbyt rozbudowany, sale/płatności nie dotyczą "rozwoju ucznia"
- **Wariant C** (NESTED TABLE ocen) - skomplikowane, trudniejsze do prezentacji

---

## 📋 Finalna lista tabel (6 sztuk)

| # | Nazwa tabeli | Opis | REF do | Metody |
|---|--------------|------|--------|--------|
| 1 | T_INSTRUMENT | Instrumenty muzyczne | - | opis() |
| 2 | T_NAUCZYCIEL | Kadra nauczycielska | - (VARRAY instrumentów) | pelne_dane(), czy_senior() |
| 3 | T_UCZEN | Uczniowie szkoły | - | wiek(), pelne_dane() |
| 4 | T_KURS | Kursy/poziomy nauki | T_INSTRUMENT | info_kursu() |
| 5 | T_LEKCJA | Pojedyncze lekcje | T_UCZEN, T_NAUCZYCIEL, T_KURS | czas_trwania_min() |
| 6 | T_OCENA_POSTEPU | Oceny i postępy | T_UCZEN, T_NAUCZYCIEL | czy_pozytywna() |

**Razem:** 6 tabel ✅ (mieści się w 5-10)

---

## 🔗 Spełnienie wymagań - szczegółowa analiza

### 1. Typy obiektowe z metodami ⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐
```
✅ T_INSTRUMENT_OBJ - metoda: opis()
✅ T_NAUCZYCIEL_OBJ - metody: pelne_dane(), czy_senior()
✅ T_UCZEN_OBJ - metody: wiek(), pelne_dane()
✅ T_KURS_OBJ - metoda: info_kursu()
✅ T_LEKCJA_OBJ - metoda: czas_trwania_min()
✅ T_OCENA_OBJ - metoda: czy_pozytywna()

Razem: 6 typów, 8 metod
Ocena: DOSKONALE - wystarczająco dużo do pokazania, nie za dużo
```

### 2. Tabele obiektowe ⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐
```
✅ 6 tabel obiektowych (OF typ_obj)
✅ Obiekty wierszowe - każdy rekord to obiekt
✅ Obiekty kolumnowe - kolumny z VARRAY

Ocena: DOSKONALE
```

### 3. Referencje (REF) i dereferencje (DEREF) ⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐
```
✅ T_KURS.ref_instrument -> T_INSTRUMENT
✅ T_LEKCJA.ref_uczen -> T_UCZEN
✅ T_LEKCJA.ref_nauczyciel -> T_NAUCZYCIEL
✅ T_LEKCJA.ref_kurs -> T_KURS
✅ T_OCENA.ref_uczen -> T_UCZEN
✅ T_OCENA.ref_nauczyciel -> T_NAUCZYCIEL

Razem: 6 referencji (pokazuje różne wzorce)
Ocena: DOSKONALE
```

### 4. VARRAY / NESTED TABLE ⭐⭐⭐⭐⭐⭐⭐⭐⭐
```
✅ VARRAY t_lista_instrumentow (max 5) w T_NAUCZYCIEL
   - Nauczyciel może uczyć do 5 instrumentów
   - Proste do zrozumienia
   - Łatwe do prezentacji

Alternatywnie można dodać:
⬜ VARRAY t_telefony (max 3) w T_UCZEN - opcjonalne

Ocena: BARDZO DOBRZE (jeden VARRAY wystarczy)
```

### 5. Pakiety PL/SQL ⭐⭐⭐⭐⭐⭐⭐⭐⭐
```
✅ PKG_UCZEN
   - dodaj_ucznia()
   - usun_ucznia()
   - znajdz_ucznia()
   - lista_uczniow()

✅ PKG_LEKCJA
   - zaplanuj_lekcje()
   - odwolaj_lekcje()
   - lista_lekcji_ucznia()

✅ PKG_OCENA
   - dodaj_ocene()
   - srednia_ucznia()
   - raport_postepu()

Razem: 3 pakiety, ~10 procedur/funkcji
Ocena: BARDZO DOBRZE
```

### 6. Kursory i REF kursory ⭐⭐⭐⭐⭐⭐⭐⭐
```
✅ Zwykły kursor w procedurze raport_postepu()
✅ REF CURSOR (SYS_REFCURSOR) w lista_uczniow(), lista_lekcji_*()
✅ Cursor FOR LOOP w różnych procedurach

Ocena: BARDZO DOBRZE
```

### 7. Obsługa błędów ⭐⭐⭐⭐⭐⭐⭐⭐⭐
```
✅ EXCEPTION w każdej procedurze
✅ RAISE_APPLICATION_ERROR dla błędów biznesowych
✅ Własne wyjątki (e_uczen_nie_istnieje, e_konflikt_terminu)

Ocena: BARDZO DOBRZE
```

### 8. Wyzwalacze ⭐⭐⭐⭐⭐⭐⭐⭐
```
✅ TRG_LEKCJA_WALIDACJA (BEFORE INSERT)
   - Sprawdza konflikt terminów nauczyciela
   - Nie pozwala planować w przeszłości

✅ TRG_OCENA_AUDIT (AFTER INSERT)
   - Loguje dodanie oceny
   - Może wysyłać powiadomienie (symulacja)

Razem: 2 triggery (proste, zrozumiałe)
Ocena: DOBRZE (minimalne ale wystarczające)
```

---

## 👥 Role użytkowników - finalna wersja

| Rola | SELECT | INSERT | UPDATE | DELETE | EXECUTE |
|------|--------|--------|--------|--------|---------|
| ADMIN | Wszystko | Wszystko | Wszystko | Wszystko | Wszystko |
| NAUCZYCIEL | Tak | Oceny, Lekcje | Oceny | - | PKG_OCENA, PKG_LEKCJA |
| SEKRETARIAT | Tak | Uczniowie | Uczniowie | - | PKG_UCZEN |

**Ocena:** ⭐⭐⭐⭐⭐⭐⭐⭐⭐ (9/10) - 3 role wystarczą, jasny podział

---

## 📝 Założenia logiczne do raportu

### Lista zdań determinujących strukturę:

1. **"Szkoła oferuje kursy nauki gry na różnych instrumentach"**
   → Potrzebujemy T_INSTRUMENT i T_KURS

2. **"Każdy kurs dotyczy nauki jednego konkretnego instrumentu"**
   → T_KURS ma REF do T_INSTRUMENT (relacja N:1)

3. **"Nauczyciel może uczyć gry na kilku instrumentach (max 5)"**
   → VARRAY w T_NAUCZYCIEL

4. **"Uczeń uczestniczy w lekcjach prowadzonych przez nauczycieli"**
   → T_LEKCJA łączy T_UCZEN, T_NAUCZYCIEL, T_KURS

5. **"Rozwój ucznia jest monitorowany poprzez regularne oceny"**
   → T_OCENA_POSTEPU z REF do T_UCZEN

6. **"Oceny wystawia nauczyciel prowadzący lekcje"**
   → T_OCENA ma REF do T_NAUCZYCIEL

7. **"Nauczyciel nie może mieć dwóch lekcji w tym samym czasie"**
   → Trigger walidujący przy INSERT do T_LEKCJA

8. **"Oceny są w skali 1-6 (polska skala szkolna)"**
   → CHECK constraint na kolumnie ocena

9. **"Każdy uczeń ma unikalny email"**
   → UNIQUE constraint na email

10. **"Lekcja trwa określoną liczbę minut (30, 45, 60, 90)"**
    → CHECK constraint lub metoda walidująca

---

## 📁 Finalna struktura plików

```
ROBD_ORACLE/Projekt/
├── 01_typy.sql           -- Typy obiektowe (6 typów + VARRAY)
├── 02_tabele.sql         -- Tabele obiektowe (6 tabel)
├── 03_pakiety.sql        -- 3 pakiety PL/SQL
├── 04_triggery.sql       -- 2 wyzwalacze
├── 05_dane.sql           -- Dane testowe
├── 06_testy.sql          -- Testy wszystkich funkcji
├── 07_uzytkownicy.sql    -- Role i uprawnienia
└── raport/
    └── Raport_MusicSchoolDB.tex

Kolejność wykonania: 01 → 02 → 03 → 04 → 05 → 07 → 06
```

---

## ✨ Podsumowanie

| Kryterium | Spełnione | Ocena |
|-----------|-----------|-------|
| 5-10 tabel | ✅ 6 tabel | ⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐ |
| Typy obiektowe | ✅ 6 typów | ⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐ |
| Metody | ✅ 8 metod | ⭐⭐⭐⭐⭐⭐⭐⭐⭐ |
| REF/DEREF | ✅ 6 referencji | ⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐ |
| VARRAY | ✅ 1 VARRAY | ⭐⭐⭐⭐⭐⭐⭐⭐⭐ |
| Pakiety | ✅ 3 pakiety | ⭐⭐⭐⭐⭐⭐⭐⭐⭐ |
| Triggery | ✅ 2 triggery | ⭐⭐⭐⭐⭐⭐⭐⭐ |
| Kursory | ✅ Tak | ⭐⭐⭐⭐⭐⭐⭐⭐⭐ |
| Obsługa błędów | ✅ Tak | ⭐⭐⭐⭐⭐⭐⭐⭐⭐ |
| Role | ✅ 3 role | ⭐⭐⭐⭐⭐⭐⭐⭐⭐ |
| Prostota | ✅ Tak | ⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐ |
| Zgodność z tematem | ✅ Tak | ⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐ |

**OCENA KOŃCOWA: ⭐⭐⭐⭐⭐⭐⭐⭐⭐ (9/10)**

Projekt jest gotowy do implementacji! ✅

---

## 🚀 Następne kroki

1. ✅ Burza mózgów (ten plik)
2. ✅ Ocena pomysłów (ten plik)
3. ⬜ Tworzenie 01_typy.sql
4. ⬜ Tworzenie 02_tabele.sql
5. ⬜ Tworzenie 03_pakiety.sql
6. ⬜ Tworzenie 04_triggery.sql
7. ⬜ Tworzenie 05_dane.sql
8. ⬜ Tworzenie 06_testy.sql
9. ⬜ Tworzenie 07_uzytkownicy.sql
10. ⬜ Raport LaTeX

---

*Ostatnia aktualizacja: 12 stycznia 2026*
