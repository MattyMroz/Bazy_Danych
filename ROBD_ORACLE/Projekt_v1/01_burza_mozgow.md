# 🎵 Burza Mózgów - Szkoła Muzyczna (Oracle Obiektowa BD)

## 📋 Informacje o projekcie
- **Temat:** Szkoła muzyczna (z naciskiem na rozwój ucznia)
- **Autorzy:** Igor Typiński (251237), Mateusz Mróz (251190)
- **Technologia:** Oracle Database (podejście obiektowe)
- **Wymagana liczba tabel:** 5-10 (celujemy w ~6 dla prostoty)

---

## 🎯 Wymagania projektowe (checklist)

| Wymaganie | Status | Opis realizacji |
|-----------|--------|-----------------|
| Typy obiektowe z metodami | ⬜ | Do zdefiniowania |
| Tabele obiektowe (wierszowe i kolumnowe) | ⬜ | Do zdefiniowania |
| Referencje (REF) i dereferencje (DEREF) | ⬜ | Do zdefiniowania |
| Wstawianie danych z referencją | ⬜ | Do zdefiniowania |
| VARRAY lub NESTED TABLE | ⬜ | Do zdefiniowania |
| Pakiety PL/SQL | ⬜ | Do zdefiniowania |
| Procedury/Funkcje | ⬜ | Do zdefiniowania |
| Kursory i REF kursory | ⬜ | Do zdefiniowania |
| Obsługa błędów | ⬜ | Do zdefiniowania |
| Wyzwalacze (triggers) | ⬜ | Do zdefiniowania |

---

## 🧠 Pomysły na strukturę bazy danych

### Wariant A: Minimalistyczny (6 tabel)

```
1. T_UCZEN (Student)
   - id_ucznia, imie, nazwisko, data_urodzenia, telefon, email
   - metoda: wiek(), pelne_dane()

2. T_NAUCZYCIEL (Teacher)  
   - id_nauczyciela, imie, nazwisko, specjalizacja, staz_lat
   - metoda: pelne_dane(), czy_senior()

3. T_INSTRUMENT
   - id_instrumentu, nazwa, kategoria (dęty/strunowy/perkusyjny/klawiszowy)
   - metoda: opis()

4. T_KURS (Course/Level)
   - id_kursu, nazwa, poziom (poczatkujacy/sredni/zaawansowany), cena
   - REF do T_INSTRUMENT
   - metoda: info_kursu()

5. T_LEKCJA (Lesson)
   - id_lekcji, data_lekcji, czas_trwania, temat, uwagi
   - REF do T_UCZEN
   - REF do T_NAUCZYCIEL
   - REF do T_KURS

6. T_OCENA_POSTEPU (Progress)
   - id_oceny, data_oceny, ocena (1-6), komentarz, obszar
   - REF do T_UCZEN
   - REF do T_NAUCZYCIEL
```

### Wariant B: Rozszerzony (8 tabel)

```
Jak wariant A plus:
7. T_SALA (Room)
   - numer_sali, pojemnosc, wyposazenie (VARRAY instrumentów)

8. T_PLATNOSC (Payment)
   - id_platnosci, kwota, data, status
   - REF do T_UCZEN
```

### Wariant C: Z większym naciskiem na kolekcje

```
Wariant A, ale:
- T_UCZEN ma NESTED TABLE z historią ocen
- T_NAUCZYCIEL ma VARRAY z listą instrumentów które uczy
```

---

## 🔗 Relacje logiczne (do raportu)

### Lista założeń logicznych:

1. **Uczeń może uczyć się wielu instrumentów**
   - Jeden uczeń → wiele kursów (różne instrumenty)
   - Realizacja: wiele rekordów T_LEKCJA z REF do tego samego ucznia

2. **Nauczyciel specjalizuje się w jednym lub wielu instrumentach**
   - Realizacja: VARRAY z listą instrumentów LUB pole tekstowe

3. **Każdy kurs jest powiązany z jednym instrumentem**
   - Realizacja: REF do T_INSTRUMENT

4. **Lekcja łączy ucznia, nauczyciela i kurs**
   - Trzy referencje w T_LEKCJA

5. **Postęp ucznia jest oceniany regularnie**
   - Wiele ocen dla jednego ucznia
   - Ocena ma skalę 1-6 (polska skala)

6. **Nauczyciel prowadzi lekcje tylko ze swoich specjalizacji**
   - Logika walidacji w triggerze lub procedurze

---

## 📦 Pomysły na VARRAY / NESTED TABLE

### Opcja 1: VARRAY dla instrumentów nauczyciela
```sql
CREATE TYPE t_lista_instrumentow AS VARRAY(5) OF VARCHAR2(50);
-- Nauczyciel może uczyć max 5 instrumentów
```

### Opcja 2: NESTED TABLE dla ocen ucznia
```sql
CREATE TYPE t_ocena_obj AS OBJECT (
    data_oceny DATE,
    wartosc NUMBER(1),
    komentarz VARCHAR2(200)
);
CREATE TYPE t_lista_ocen AS TABLE OF t_ocena_obj;
-- Historia wszystkich ocen ucznia w jednej kolumnie
```

### Opcja 3: VARRAY dla telefonów kontaktowych
```sql
CREATE TYPE t_telefony AS VARRAY(3) OF VARCHAR2(15);
-- Max 3 numery telefonu dla ucznia/rodzica
```

**Rekomendacja:** Opcja 1 (VARRAY instrumentów) - najprostsza do zrozumienia i prezentacji

---

## 🔧 Pomysły na pakiety PL/SQL

### Pakiet: PKG_UCZEN
```
- dodaj_ucznia(...)
- usun_ucznia(id)
- znajdz_ucznia(id) RETURN REF
- lista_uczniow() RETURN SYS_REFCURSOR
- statystyki_ucznia(id) - średnia ocen, liczba lekcji
```

### Pakiet: PKG_LEKCJA
```
- zaplanuj_lekcje(...)
- odwolaj_lekcje(id)
- lista_lekcji_ucznia(id_ucznia)
- lista_lekcji_nauczyciela(id_nauczyciela)
```

### Pakiet: PKG_OCENA
```
- dodaj_ocene(...)
- srednia_ucznia(id_ucznia)
- raport_postepu(id_ucznia)
```

---

## 🔔 Pomysły na wyzwalacze (triggers)

1. **TRG_PRZED_LEKCJA**
   - Sprawdza czy nauczyciel nie ma już lekcji w tym czasie
   - Walidacja dat (nie można planować w przeszłości)

2. **TRG_PO_OCENIE**
   - Automatycznie aktualizuje średnią ucznia
   - Logowanie zmian

3. **TRG_AUDIT**
   - Logowanie wszystkich operacji INSERT/UPDATE/DELETE

---

## 👥 Role użytkowników

| Rola | Uprawnienia | Opis |
|------|-------------|------|
| ADMIN | Pełne | Zarządzanie wszystkim |
| NAUCZYCIEL | SELECT + INSERT oceny/lekcje | Prowadzi lekcje, wystawia oceny |
| SEKRETARIAT | SELECT + INSERT/UPDATE uczniów | Zarządza danymi uczniów |
| UCZEN | SELECT własnych danych | Przeglądanie swoich ocen i lekcji |

---

## 📁 Struktura plików projektu

```
ROBD_ORACLE/Projekt/
├── 01_typy.sql          -- Definicje typów obiektowych
├── 02_tabele.sql        -- Tabele obiektowe
├── 03_pakiety.sql       -- Pakiety PL/SQL
├── 04_triggery.sql      -- Wyzwalacze
├── 05_dane.sql          -- Przykładowe dane
├── 06_testy.sql         -- Testy funkcjonalności
├── 07_uzytkownicy.sql   -- Role i użytkownicy
└── raport/
    └── Raport_MusicSchoolDB.tex
```

---

## ❓ Pytania do rozstrzygnięcia

1. Czy używamy VARRAY czy NESTED TABLE?
   - **Propozycja:** VARRAY (prostsze)

2. Ile metod w typach obiektowych?
   - **Propozycja:** 2-3 na typ (nie przesadzać)

3. Jak szczegółowe mają być triggery?
   - **Propozycja:** 2-3 proste triggery

4. Czy robimy osobną tabelę sal?
   - **Propozycja:** NIE (uproszczenie)

5. Czy robimy płatności?
   - **Propozycja:** NIE (nie dotyczy "rozwoju ucznia")

---

## 🎨 Diagram koncepcyjny (ASCII)

```
                    +---------------+
                    |  T_INSTRUMENT |
                    +-------+-------+
                            |
                            | REF
                            v
+-------------+      +------+------+      +---------------+
| T_NAUCZYCIEL|      |   T_KURS    |      |    T_UCZEN    |
| (VARRAY     |      +------+------+      +-------+-------+
|  instrumenty)|            |                     |
+------+------+             |                     |
       |                    |                     |
       |         +----------+----------+          |
       |         |                     |          |
       +-------->+      T_LEKCJA       +<---------+
                 | (REF nauczyciel)    |
                 | (REF uczen)         |
                 | (REF kurs)          |
                 +----------+----------+
                            |
                            |
                 +----------v----------+
                 |   T_OCENA_POSTEPU   |
                 | (REF uczen)         |
                 | (REF nauczyciel)    |
                 +---------------------+
```

---

## 📝 Notatki dodatkowe

- Kod pisany w stylu poprzedniego projektu (CompanyDB)
- Dużo komentarzy w kodzie SQL
- Każda funkcjonalność ma test
- Skupienie na prostocie i przejrzystości
- Raport z instrukcją prezentacji

---

*Ostatnia aktualizacja: 12 stycznia 2026*
