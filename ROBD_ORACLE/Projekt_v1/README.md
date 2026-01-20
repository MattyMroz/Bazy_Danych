# Szkoła Muzyczna - Obiektowa Baza Danych Oracle

## Autorzy
- **Igor Typiński** (251237)
- **Mateusz Mróz** (251190)

## Opis projektu
Obiektowa baza danych dla szkoły muzycznej z naciskiem na rozwój ucznia.
Projekt wykorzystuje funkcjonalności obiektowe Oracle Database: typy obiektowe,
metody, VARRAY, REF/DEREF, pakiety PL/SQL, triggery i kursory.

## Struktura plików

| Plik | Opis |
|------|------|
| `01_typy.sql` | Definicje 7 typów obiektowych z 12 metodami |
| `02_tabele.sql` | 6 tabel obiektowych, sekwencje, indeksy |
| `03_pakiety.sql` | 3 pakiety PL/SQL z 16 procedurami/funkcjami |
| `04_triggery.sql` | 5 triggerów walidujących i audytowych |
| `05_dane.sql` | Dane testowe (42 rekordy) |
| `06_testy.sql` | Kompleksowe testy wszystkich funkcjonalności |
| `07_uzytkownicy.sql` | 3 role i 3 użytkownicy |

## Kolejność uruchomienia

```sql
-- Logowanie jako właściciel schematu
@01_typy.sql
@02_tabele.sql
@03_pakiety.sql
@04_triggery.sql
@05_dane.sql
@06_testy.sql

-- Logowanie jako DBA/SYSDBA (dla użytkowników)
@07_uzytkownicy.sql
```

## Diagram struktury

```
T_INSTRUMENT ◄─────────────── T_KURS
      │                          │
      │                          │ REF
      │                          ▼
      │    T_NAUCZYCIEL ◄───── T_LEKCJA ─────► T_UCZEN
      │         │                                  │
      │         │ VARRAY                           │
      │    [instrumenty]                           │
      │         │                                  │
      │         ▼                                  │
      │    T_OCENA_POSTEPU ◄───────────────────────┘
      │         │
      │         │ REF (nauczyciel, uczeń)
      │         ▼
      └──── T_AUDIT_LOG (triggery)
```

## Użyte technologie obiektowe

### Typy obiektowe (7)
- `t_instrument_obj` - instrument z metodą `opis()`
- `t_nauczyciel_obj` - nauczyciel z 3 metodami + VARRAY
- `t_uczen_obj` - uczeń z 3 metodami (wiek, pełnoletność)
- `t_kurs_obj` - kurs z REF do instrumentu
- `t_lekcja_obj` - lekcja z 3x REF
- `t_ocena_obj` - ocena z 2x REF
- `t_lista_instrumentow` - VARRAY(5) dla nauczyciela

### Kolekcje
- **VARRAY(5)** - lista instrumentów nauczyciela

### Referencje (6x REF)
- `t_kurs.ref_instrument` → t_instrument
- `t_lekcja.ref_uczen` → t_uczen
- `t_lekcja.ref_nauczyciel` → t_nauczyciel
- `t_lekcja.ref_kurs` → t_kurs
- `t_ocena.ref_uczen` → t_uczen
- `t_ocena.ref_nauczyciel` → t_nauczyciel

### Pakiety PL/SQL (3)
1. **PKG_UCZEN** - zarządzanie uczniami (5 procedur)
2. **PKG_LEKCJA** - zarządzanie lekcjami (6 procedur)
3. **PKG_OCENA** - zarządzanie ocenami (5 procedur)

### Kursory
- Jawne (CURSOR + FETCH)
- Niejawne (FOR rec IN SELECT)
- REF CURSOR (SYS_REFCURSOR)

### Triggery (5)
1. `TRG_LEKCJA_WALIDACJA` - walidacja daty/godziny/konfliktów
2. `TRG_OCENA_AUDIT` - logowanie operacji na ocenach
3. `TRG_UCZEN_PRZED_USUNIECIEM` - ochrona przed usunięciem
4. `TRG_NAUCZYCIEL_DATA_ZATRUDNIENIA` - domyślna data
5. `TRG_KURS_CENA_AUDIT` - logowanie zmian cen

### Role użytkowników (3)
| Rola | Opis | Użytkownik |
|------|------|------------|
| `rola_admin` | Pełne uprawnienia | usr_admin |
| `rola_nauczyciel` | Prowadzenie lekcji, oceny | usr_nauczyciel |
| `rola_sekretariat` | Zarządzanie uczniami, harmonogramem | usr_sekretariat |

## Wymagania systemowe
- Oracle Database 12c lub nowsza
- SQL*Plus lub SQL Developer
- Uprawnienia CREATE TYPE, CREATE TABLE, CREATE PROCEDURE

## Przykładowe użycie

```sql
-- Włącz output
SET SERVEROUTPUT ON;

-- Dodaj ucznia przez pakiet
EXEC pkg_uczen.dodaj_ucznia('Jan', 'Kowalski', DATE '2010-05-15', 'jan@email.pl');

-- Lista uczniów
EXEC pkg_uczen.lista_uczniow;

-- Zaplanuj lekcję
EXEC pkg_lekcja.zaplanuj_lekcje(1, 1, 1, SYSDATE+7, '14:00', 45);

-- Dodaj ocenę
EXEC pkg_ocena.dodaj_ocene(1, 1, 5, 'technika', 'Bardzo dobra technika');

-- Raport postępu
EXEC pkg_ocena.raport_postepu(1);

-- Użycie DEREF
SELECT DEREF(l.ref_uczen).pelne_dane() AS uczen,
       DEREF(l.ref_nauczyciel).pelne_dane() AS nauczyciel
FROM t_lekcja l;
```

## Licencja
Projekt edukacyjny - Politechnika Łódzka, WEEIA
Przedmiot: Rozproszone i Obiektowe Bazy Danych
