# Szkoła Muzyczna - Obiektowa Baza Danych Oracle

## Problem ORA-00600 - ROZWIĄZANY ✅

Błąd `ORA-00600 [kxtociw3]` występował z powodu użycia `DEREF(:NEW.ref_*)` w triggerach `BEFORE INSERT`. Oracle ma problemy z dereferencją REF na pseudo-rekordzie `:NEW` w niektórych wersjach.

### Rozwiązanie

Walidacje zostały przeniesione z triggerów do pakietów. Nowe pliki:
- `03_pakiety_v2.sql` - pakiety z walidacjami PRZED insertem
- `04_triggery_v2.sql` - minimalne triggery bez DEREF na :NEW
- `05_dane_v2.sql` - dane testowe kompatybilne z nową wersją

---

## 🚀 Instrukcja uruchomienia

### Kolejność plików (WAŻNE!)

```sql
-- 1. Typy obiektowe
@01_typy.sql

-- 2. Tabele obiektowe
@02_tabele.sql

-- 3. Pakiety (NOWA WERSJA!)
@03_pakiety_v2.sql

-- 4. Triggery (NOWA WERSJA!)
@04_triggery_v2.sql

-- 5. Dane testowe
@05_dane_v2.sql

-- 6. Użytkownicy (opcjonalnie)
@06_uzytkownicy.sql
```

### Pełna reinstalacja (jeśli masz starą wersję)

```sql
-- Usuń stare obiekty (w odwrotnej kolejności)
DROP TABLE OCENY;
DROP TABLE LEKCJE;
DROP TABLE UCZNIOWIE;
DROP TABLE NAUCZYCIELE;
DROP TABLE GRUPY;
DROP TABLE SALE;
DROP TABLE PRZEDMIOTY;
DROP TABLE INSTRUMENTY;

DROP TYPE T_OCENA FORCE;
DROP TYPE T_LEKCJA FORCE;
DROP TYPE T_UCZEN FORCE;
DROP TYPE T_NAUCZYCIEL FORCE;
DROP TYPE T_GRUPA FORCE;
DROP TYPE T_SALA FORCE;
DROP TYPE T_PRZEDMIOT FORCE;
DROP TYPE T_INSTRUMENT FORCE;
DROP TYPE T_KOMISJA FORCE;
DROP TYPE T_WYPOSAZENIE FORCE;
DROP TYPE T_INSTRUMENTY_TAB FORCE;

DROP SEQUENCE seq_instrumenty;
DROP SEQUENCE seq_przedmioty;
DROP SEQUENCE seq_sale;
DROP SEQUENCE seq_grupy;
DROP SEQUENCE seq_nauczyciele;
DROP SEQUENCE seq_uczniowie;
DROP SEQUENCE seq_lekcje;
DROP SEQUENCE seq_oceny;

-- Teraz uruchom nowe pliki
@01_typy.sql
@02_tabele.sql
@03_pakiety_v2.sql
@04_triggery_v2.sql
@05_dane_v2.sql
```

---

## 📦 Pakiety

### PKG_SLOWNIKI
Zarządzanie danymi słownikowymi (instrumenty, przedmioty, sale, grupy).

```sql
-- Dodanie instrumentu
EXEC PKG_SLOWNIKI.dodaj_instrument('Fortepian', 'N');

-- Pobranie REF do instrumentu
SELECT PKG_SLOWNIKI.get_ref_instrument('Fortepian') FROM DUAL;
```

### PKG_OSOBY
Zarządzanie nauczycielami i uczniami.

```sql
-- Dodanie nauczyciela
EXEC PKG_OSOBY.dodaj_nauczyciela('Anna', 'Kowalska', T_INSTRUMENTY_TAB('Fortepian'));

-- Dodanie ucznia
EXEC PKG_OSOBY.dodaj_ucznia('Jan', 'Kowalski', DATE '2015-03-15', '1A', 'Fortepian');
```

### PKG_LEKCJE
Planowanie lekcji i egzaminów.

```sql
-- Lekcja indywidualna (TO WCZEŚNIEJ WYWOŁYWAŁO ORA-00600!)
EXEC PKG_LEKCJE.dodaj_lekcje_indywidualna(
    'Fortepian', 'Kowalska', '101', 
    'Kowalski', 'Jan', 
    DATE '2026-02-02', '14:00', 30
);

-- Lekcja grupowa
EXEC PKG_LEKCJE.dodaj_lekcje_grupowa(
    'Ksztalcenie sluchowe', 'Lewandowska', '201', 
    '1A', DATE '2026-02-02', '16:00', 45
);

-- Egzamin
EXEC PKG_LEKCJE.dodaj_egzamin(
    'Kowalski', 'Jan', 'AULA',
    DATE '2026-06-15', '14:00',
    'Kowalska', 'Nowak', 45
);
```

### PKG_OCENY
Wystawianie i zarządzanie ocenami.

```sql
-- Ocena zwykła
EXEC PKG_OCENY.wystaw_ocene('Kowalski', 'Jan', 'Kowalska', 'Fortepian', 5, 'technika');

-- Ocena semestralna
EXEC PKG_OCENY.wystaw_ocene_semestralna('Kowalski', 'Jan', 'Kowalska', 'Fortepian', 5);

-- Średnia ucznia
SELECT PKG_OCENY.srednia_ucznia('Kowalski', 'Jan', 'Fortepian') FROM DUAL;
```

### PKG_RAPORTY
Raporty i statystyki.

```sql
EXEC PKG_RAPORTY.raport_grup;
EXEC PKG_RAPORTY.raport_nauczycieli;
EXEC PKG_RAPORTY.raport_instrumentow;
EXEC PKG_RAPORTY.statystyki_ocen_przedmiotu('Fortepian');
```

---

## 📋 Walidacje biznesowe

Wszystkie walidacje są wykonywane w pakietach PRZED insertem:

| Walidacja | Kod błędu | Opis |
|-----------|-----------|------|
| Godziny pracy | -20106, -20107 | Lekcje 14:00-20:00, koniec max 21:00 |
| Dzień tygodnia | -20109 | Tylko pon-pt |
| Sala zajęta | -20010 | Konflikt czasowy sali |
| Nauczyciel zajęty | -20011 | Konflikt czasowy nauczyciela |
| Uczeń zajęty | -20012 | Konflikt czasowy ucznia |
| Wyposażenie sali | -20108 | Brak wymaganego wyposażenia |
| Nauczyciel-przedmiot | -20111 | Nauczyciel nie uczy przedmiotu |
| Uczeń-instrument | -20110 | Uczeń gra na innym instrumencie |
| Komisja egz. | -20101, -20102 | 2 różnych nauczycieli |
| Zakres oceny | -20105 | Ocena 1-6 |

---

## 🗃️ Struktura tabel

```
INSTRUMENTY (T_INSTRUMENT)
PRZEDMIOTY  (T_PRZEDMIOT)
SALE        (T_SALA)
GRUPY       (T_GRUPA)
NAUCZYCIELE (T_NAUCZYCIEL)  ← VARRAY instrumenty
UCZNIOWIE   (T_UCZEN)       ← REF grupa, REF instrument
LEKCJE      (T_LEKCJA)      ← REF przedmiot, nauczyciel, sala, uczeń/grupa
OCENY       (T_OCENA)       ← REF uczeń, nauczyciel, przedmiot
```

---

## 👥 Autorzy

- Igor Typiński (251237)
- Mateusz Mróz (251190)

---

## ❓ FAQ

**Q: Nadal dostaję ORA-00600?**
A: Upewnij się, że używasz plików `v2`:
- `03_pakiety_v2.sql` (nie `03_pakiety.sql`)
- `04_triggery_v2.sql` (nie `04_triggery.sql`)

**Q: Jak zresetować bazę?**
A: Użyj skryptu z sekcji "Pełna reinstalacja" powyżej.

**Q: Błąd "przedmiot nie znaleziony"?**
A: Upewnij się, że dane z `05_dane_v2.sql` zostały załadowane.
