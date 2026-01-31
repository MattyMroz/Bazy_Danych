# 🎼 PLAN IMPLEMENTACJI - Szkoła Muzyczna v5
## Blueprint Obiektowej Bazy Danych Oracle

**Autorzy:** Igor Typiński (251237), Mateusz Mróz (251190)  
**Model analizy:** Claude 4.5 Opus  
**Data:** Styczeń 2026  
**Status:** GOTOWY DO IMPLEMENTACJI

---

## 📋 SPIS TREŚCI

1. [Typ Szkoły i Kontekst](#1-typ-szkoły-i-kontekst)
2. [Założenia Biznesowe (KOMPLETNA LISTA)](#2-założenia-biznesowe)
3. [Typy Obiektowe (12 typów)](#3-typy-obiektowe)
4. [Tabele i Relacje REF (10 tabel, 18 relacji)](#4-tabele-i-relacje)
5. [Triggery i Walidacja (UNIKANIE ORA-04091)](#5-triggery-i-walidacja)
6. [Pakiety PL/SQL (6 pakietów)](#6-pakiety-plsql)
7. [Heurystyka Planowania (BIG ROCKS FIRST)](#7-heurystyka-planowania)
8. [System Testów (AUDYT FUNKCJONALNY)](#8-system-testów)
9. [Role i Użytkownicy (4 role)](#9-role-i-użytkownicy)
10. [Dane Startowe (z "dziurami" na demo)](#10-dane-startowe)
11. [Diagram Relacji](#11-diagram-relacji)
12. [Checklist Implementacji](#12-checklist)

---

## 1. TYP SZKOŁY I KONTEKST

### 1.1 Definicja

| Parametr | Wartość |
|----------|---------|
| **Typ** | Prywatna szkoła muzyczna z uprawnieniami szkoły publicznej |
| **Cykl** | 6-letni (klasy I-VI) |
| **Zakres projektu** | 1 semestr (15 tygodni) |
| **Tryb nauczania** | Indywidualny + Grupowy |

### 1.2 Dlaczego taki typ?

```
✅ Realizuje podstawę programową MKiDN → Ma strukturę (klasy, przedmioty)
✅ Jest prywatna → Można mieć elastyczność (np. godziny pracy)
✅ Wydaje świadectwa → Ma egzaminy, oceny, promocje
✅ Uczniowie to głównie dzieci → Ograniczenia czasowe (popołudnia)
```

---

## 2. ZAŁOŻENIA BIZNESOWE

### ⚠️ KRYTYCZNE - Ta lista to "Biblia Projektu"

Prowadzący będzie szukał luk logicznych. Każde założenie musi być:
- Jednoznaczne (nie "czasem", "może", "zwykle")
- Weryfikowalne (da się napisać test)
- Spójne z pozostałymi

---

### 2.1 STRUKTURA CZASOWA

| ID | Założenie | Wartość | Weryfikacja |
|----|-----------|---------|-------------|
| T1 | Dni nauki | Poniedziałek - Piątek | CHECK na data_lekcji |
| T2 | Godziny pracy szkoły | 14:00 - 20:00 | CHECK na godzina_start |
| T3 | Jednostka slotu | 15 minut | Lekcje = wielokrotność 15 |
| T4 | Długość semestru | 15 tygodni | Tabela t_semestr |
| T5 | Przerwa między lekcjami | 5 minut (soft) | Heurystyka planowania |

### 2.2 UCZNIOWIE

| ID | Założenie | Wartość | Weryfikacja |
|----|-----------|---------|-------------|
| U1 | Minimalny wiek zapisu | 6 lat | Trigger trg_uczen |
| U2 | Maksymalny wiek zapisu (kl. I) | 10 lat | Trigger trg_uczen |
| U3 | Instrument główny | Dokładnie 1 na ucznia | REF NOT NULL |
| U4 | Zmiana instrumentu | NIE w trakcie semestru | Brak procedury zmiany |
| U5 | Klasa | 1-6 (zgodna z cyklem) | CHECK (klasa BETWEEN 1 AND 6) |
| U6 | **Typ ucznia** | 3 wartości (patrz niżej) | CHECK + Trigger godzin |
| U7 | Status ucznia | aktywny / zawieszony / skreslony | CHECK |
| U8 | Przynależność do grupy | Opcjonalna (dla zajęć grupowych) | REF może być NULL |
| U9 | Max lekcji indywidualnych/dzień | 2 | Walidacja w pakiecie |
| U10 | Max lekcji grupowych/dzień | 1 | Walidacja w pakiecie |

#### 🔴 KLUCZOWE: Typ ucznia (zastępuje "czy_dziecko")

```sql
typ_ucznia VARCHAR2(30) CHECK (typ_ucznia IN (
    'uczacy_sie_w_innej_szkole',  -- Lekcje TYLKO od 15:00
    'ukonczyl_edukacje',          -- Lekcje od 14:00 (dorośli, studenci)
    'tylko_muzyczna'              -- Lekcje od 14:00 (homeschooling, zawodowcy)
))
```

**UZASADNIENIE dla prowadzącego:**
> "Ograniczenie godzinowe nie wynika z wieku, tylko ze statusu edukacyjnego. 
> 17-latek po maturze może mieć lekcje o 14:00, 
> a 19-latek studiujący dziennie - tylko po 15:00."

### 2.3 NAUCZYCIELE

| ID | Założenie | Wartość | Weryfikacja |
|----|-----------|---------|-------------|
| N1 | Specjalizacje (instrumenty) | Max 5 (VARRAY) | VARRAY(5) |
| N2 | Minimum specjalizacji | 1 instrument | Trigger NOT EMPTY |
| N3 | Max godzin/dzień | 6 godzin (360 min) | Walidacja w pakiecie |
| N4 | Max godzin/tydzień | 30 godzin (1800 min) | Walidacja w pakiecie |
| N5 | Prowadzenie zajęć grupowych | Flaga T/N | CHECK |
| N6 | Rola akompaniatora | Flaga T/N | CHECK |
| N7 | Status | aktywny / urlop / zwolniony | CHECK |

### 2.4 SALE

| ID | Założenie | Wartość | Weryfikacja |
|----|-----------|---------|-------------|
| S1 | Typ sali | indywidualna / grupowa / wielofunkcyjna | CHECK |
| S2 | Pojemność | 1-30 osób | CHECK BETWEEN |
| S3 | Wyposażenie | VARRAY(10) nazw sprzętu | np. 'Fortepian', 'Tablica' |
| S4 | Status | dostepna / niedostepna / remont | CHECK |

### 2.5 PRZEDMIOTY

| ID | Założenie | Wartość | Weryfikacja |
|----|-----------|---------|-------------|
| P1 | Typ zajęć | indywidualny / grupowy | CHECK |
| P2 | Czas trwania | 30 / 45 / 60 / 90 min | CHECK IN |
| P3 | Zakres klas | od-do (np. I-VI, III-VI) | CHECK |
| P4 | Obowiązkowość | T/N | CHECK |
| P5 | Wymagany sprzęt | NULL lub nazwa | Walidacja przy planowaniu |

**Przykładowe przedmioty:**

| Przedmiot | Typ | Czas | Klasy | Obowiązkowy |
|-----------|-----|------|-------|-------------|
| Instrument główny | indywidualny | 30-60 | I-VI | TAK |
| Fortepian dodatkowy | indywidualny | 30 | III-VI* | TAK* |
| Kształcenie słuchu | grupowy | 45 | I-VI | TAK |
| Rytmika | grupowy | 45 | I-II | TAK |
| Zespół kameralny | grupowy | 60 | IV-VI | NIE |

*dla nie-pianistów

### 2.6 LEKCJE

| ID | Założenie | Wartość | Weryfikacja |
|----|-----------|---------|-------------|
| L1 | Typ lekcji | indywidualna / grupowa | CHECK |
| L2 | Status | zaplanowana / odbyta / odwolana | CHECK |
| L3 | Godzina start (min) | 14:00 | CHECK >= '14:00' |
| L4 | Godzina start (max) | 19:00 (by kończyć do 20:00) | Zależne od czasu trwania |
| L5 | **Popołudnia dla U.6** | >= 15:00 jeśli typ='uczacy_sie...' | Trigger/Pakiet |
| L6 | Konflikt sali | ZABRONIONY | Walidacja w pakiecie |
| L7 | Konflikt nauczyciela | ZABRONIONY | Walidacja w pakiecie |
| L8 | Konflikt ucznia | ZABRONIONY | Walidacja w pakiecie |
| L9 | Akompaniator | Wymagany dla smyczków (soft) | Opcjonalny REF |

### 2.7 OCENY

| ID | Założenie | Wartość | Weryfikacja |
|----|-----------|---------|-------------|
| O1 | Skala | 1-6 | CHECK BETWEEN |
| O2 | Obszary | technika / interpretacja / sluch / teoria / rytm / ogolna | CHECK IN |
| O3 | Kompetencje | Nauczyciel musi uczyć instrumentu ucznia* | Walidacja w pakiecie |

*Lub przedmiot teoretyczny (teoria, słuch) - mogą wszyscy

### 2.8 EGZAMINY

| ID | Założenie | Wartość | Weryfikacja |
|----|-----------|---------|-------------|
| E1 | Typ | wstepny / semestralny / poprawkowy | CHECK |
| E2 | Komisja | Minimum 2 nauczycieli | NOT NULL x2 |
| E3 | Komisja | Różne osoby | CHECK różne REF |
| E4 | Ocena końcowa | 1-6 lub NULL (przed egzaminem) | CHECK |

### 2.9 GRUPY

| ID | Założenie | Wartość | Weryfikacja |
|----|-----------|---------|-------------|
| G1 | Max uczniów | 15 | CHECK |
| G2 | Nazwa | Unikalna w semestrze | UNIQUE (nazwa, rok_szkolny) |
| G3 | Przypisanie uczniów | Opcjonalne (dla teoretycznych) | REF może być NULL |

---

## 3. TYPY OBIEKTOWE

### 3.1 Lista typów (12)

```
KOLEKCJE (2):
├── t_lista_instrumentow    VARRAY(5) OF VARCHAR2(100)
└── t_lista_sprzetu         VARRAY(10) OF VARCHAR2(100)

TYPY GŁÓWNE (10):
├── t_semestr_obj           3 metody
├── t_instrument_obj        2 metody
├── t_sala_obj              3 metody (używa t_lista_sprzetu)
├── t_nauczyciel_obj        4 metody (używa t_lista_instrumentow)
├── t_uczen_obj             5 metod
├── t_grupa_obj             2 metody
├── t_przedmiot_obj         2 metody
├── t_lekcja_obj            4 metody (6 REF!)
├── t_egzamin_obj           2 metody (5 REF!)
└── t_ocena_obj             2 metody (4 REF!)

RAZEM: 29 metod, 15 REF w typach, 2 VARRAY
```

### 3.2 Szczegóły typów

#### t_semestr_obj
```sql
CREATE OR REPLACE TYPE t_semestr_obj AS OBJECT (
    id_semestru       NUMBER,
    nazwa             VARCHAR2(50),      -- "2025/2026 Semestr zimowy"
    data_start        DATE,
    data_koniec       DATE,
    rok_szkolny       VARCHAR2(9),       -- "2025/2026"
    
    MEMBER FUNCTION liczba_tygodni RETURN NUMBER,
    MEMBER FUNCTION czy_aktywny RETURN CHAR,
    MEMBER FUNCTION opis RETURN VARCHAR2
);
```

#### t_instrument_obj
```sql
CREATE OR REPLACE TYPE t_instrument_obj AS OBJECT (
    id_instrumentu    NUMBER,
    nazwa             VARCHAR2(100),
    kategoria         VARCHAR2(50),      -- klawiszowe/strunowe/dete/perkusyjne
    czy_wymaga_akompaniatora CHAR(1),    -- T/N (smyczki = T)
    
    MEMBER FUNCTION opis RETURN VARCHAR2,
    MEMBER FUNCTION czy_smyczkowy RETURN CHAR
);
```

#### t_lista_sprzetu (VARRAY)
```sql
CREATE OR REPLACE TYPE t_lista_sprzetu AS VARRAY(10) OF VARCHAR2(100);
-- Przykład: ('Fortepian Steinway', 'Tablica', 'Lustra', 'Nagłośnienie')
```

#### t_sala_obj
```sql
CREATE OR REPLACE TYPE t_sala_obj AS OBJECT (
    id_sali           NUMBER,
    numer             VARCHAR2(20),
    typ_sali          VARCHAR2(20),      -- indywidualna/grupowa/wielofunkcyjna
    pojemnosc         NUMBER,
    wyposazenie       t_lista_sprzetu,
    status            VARCHAR2(20),
    
    MEMBER FUNCTION opis_pelny RETURN VARCHAR2,
    MEMBER FUNCTION czy_ma_sprzet(p_nazwa VARCHAR2) RETURN CHAR,
    MEMBER FUNCTION czy_odpowiednia(p_typ VARCHAR2, p_osob NUMBER) RETURN CHAR
);
```

#### t_lista_instrumentow (VARRAY)
```sql
CREATE OR REPLACE TYPE t_lista_instrumentow AS VARRAY(5) OF VARCHAR2(100);
-- Przykład: ('Fortepian', 'Organy', 'Klawesyn')
```

#### t_nauczyciel_obj
```sql
CREATE OR REPLACE TYPE t_nauczyciel_obj AS OBJECT (
    id_nauczyciela      NUMBER,
    imie                VARCHAR2(50),
    nazwisko            VARCHAR2(50),
    email               VARCHAR2(100),
    telefon             VARCHAR2(20),
    data_zatrudnienia   DATE,
    instrumenty         t_lista_instrumentow,
    czy_prowadzi_grupowe CHAR(1),
    czy_akompaniator    CHAR(1),
    status              VARCHAR2(20),
    
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2,
    MEMBER FUNCTION lata_stazu RETURN NUMBER,
    MEMBER FUNCTION liczba_instrumentow RETURN NUMBER,
    MEMBER FUNCTION czy_uczy(p_instrument VARCHAR2) RETURN CHAR
);
```

#### t_uczen_obj
```sql
CREATE OR REPLACE TYPE t_uczen_obj AS OBJECT (
    id_ucznia           NUMBER,
    imie                VARCHAR2(50),
    nazwisko            VARCHAR2(50),
    data_urodzenia      DATE,
    email               VARCHAR2(100),
    telefon_rodzica     VARCHAR2(20),
    data_zapisu         DATE,
    klasa               NUMBER(1),
    cykl_nauczania      NUMBER(1),       -- 6
    typ_ucznia          VARCHAR2(30),    -- KLUCZOWE!
    status              VARCHAR2(20),
    ref_instrument      REF t_instrument_obj,
    ref_grupa           REF t_grupa_obj,
    
    MEMBER FUNCTION wiek RETURN NUMBER,
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2,
    MEMBER FUNCTION czy_wymaga_popoludnia RETURN CHAR,
    MEMBER FUNCTION min_godzina_lekcji RETURN VARCHAR2,
    MEMBER FUNCTION rok_nauki RETURN NUMBER
);
```

#### t_grupa_obj
```sql
CREATE OR REPLACE TYPE t_grupa_obj AS OBJECT (
    id_grupy            NUMBER,
    nazwa               VARCHAR2(20),     -- "1A", "2B"
    klasa               NUMBER(1),
    rok_szkolny         VARCHAR2(9),
    max_uczniow         NUMBER,
    status              VARCHAR2(20),
    
    MEMBER FUNCTION opis RETURN VARCHAR2,
    MEMBER FUNCTION liczba_uczniow RETURN NUMBER  -- wymaga zapytania
);
```

#### t_przedmiot_obj
```sql
CREATE OR REPLACE TYPE t_przedmiot_obj AS OBJECT (
    id_przedmiotu       NUMBER,
    nazwa               VARCHAR2(100),
    typ_zajec           VARCHAR2(20),
    wymiar_minut        NUMBER,
    klasy_od            NUMBER(1),
    klasy_do            NUMBER(1),
    czy_obowiazkowy     CHAR(1),
    wymagany_sprzet     VARCHAR2(100),
    ref_instrument      REF t_instrument_obj,  -- NULL dla teoretycznych
    
    MEMBER FUNCTION opis RETURN VARCHAR2,
    MEMBER FUNCTION czy_dla_klasy(p_klasa NUMBER) RETURN CHAR
);
```

#### t_lekcja_obj (NAJBARDZIEJ ZŁOŻONY - 6 REF!)
```sql
CREATE OR REPLACE TYPE t_lekcja_obj AS OBJECT (
    id_lekcji           NUMBER,
    data_lekcji         DATE,
    godzina_start       VARCHAR2(5),      -- 'HH:MI'
    czas_trwania        NUMBER,
    typ_lekcji          VARCHAR2(20),
    status              VARCHAR2(20),
    ref_przedmiot       REF t_przedmiot_obj,
    ref_nauczyciel      REF t_nauczyciel_obj,
    ref_akompaniator    REF t_nauczyciel_obj,  -- może być NULL
    ref_sala            REF t_sala_obj,
    ref_uczen           REF t_uczen_obj,       -- NULL dla grupowych
    ref_grupa           REF t_grupa_obj,       -- NULL dla indywidualnych
    
    MEMBER FUNCTION godzina_koniec RETURN VARCHAR2,
    MEMBER FUNCTION czas_txt RETURN VARCHAR2,
    MEMBER FUNCTION czy_grupowa RETURN CHAR,
    MEMBER FUNCTION dzien_tygodnia RETURN VARCHAR2
);
```

#### t_egzamin_obj
```sql
CREATE OR REPLACE TYPE t_egzamin_obj AS OBJECT (
    id_egzaminu         NUMBER,
    data_egzaminu       DATE,
    godzina             VARCHAR2(5),
    typ_egzaminu        VARCHAR2(30),
    ref_uczen           REF t_uczen_obj,
    ref_przedmiot       REF t_przedmiot_obj,
    ref_komisja1        REF t_nauczyciel_obj,
    ref_komisja2        REF t_nauczyciel_obj,
    ref_sala            REF t_sala_obj,
    ocena_koncowa       NUMBER(1),
    uwagi               VARCHAR2(500),
    
    MEMBER FUNCTION czy_zdany RETURN CHAR,
    MEMBER FUNCTION ocena_slownie RETURN VARCHAR2
);
```

#### t_ocena_obj
```sql
CREATE OR REPLACE TYPE t_ocena_obj AS OBJECT (
    id_oceny            NUMBER,
    data_oceny          DATE,
    wartosc             NUMBER(1),
    obszar              VARCHAR2(50),
    komentarz           VARCHAR2(500),
    ref_uczen           REF t_uczen_obj,
    ref_nauczyciel      REF t_nauczyciel_obj,
    ref_przedmiot       REF t_przedmiot_obj,
    ref_lekcja          REF t_lekcja_obj,     -- może być NULL
    
    MEMBER FUNCTION ocena_slownie RETURN VARCHAR2,
    MEMBER FUNCTION czy_pozytywna RETURN CHAR
);
```

---

## 4. TABELE I RELACJE

### 4.1 Lista tabel (10)

```
SŁOWNIKOWE (2):
├── t_semestr
└── t_instrument

ZASOBY (3):
├── t_sala
├── t_nauczyciel
└── t_uczen

ORGANIZACJA (2):
├── t_grupa
└── t_przedmiot

TRANSAKCYJNE (3):
├── t_lekcja
├── t_egzamin
└── t_ocena
```

### 4.2 Tworzenie tabel (kolejność ważna!)

```sql
-- KOLEJNOŚĆ TWORZENIA (zależności REF):
-- 1. t_semestr (brak REF)
-- 2. t_instrument (brak REF)
-- 3. t_sala (brak REF, ma VARRAY)
-- 4. t_nauczyciel (brak REF, ma VARRAY)
-- 5. t_grupa (brak REF - uczniowie wskazują na grupę)
-- 6. t_uczen (REF → instrument, grupa)
-- 7. t_przedmiot (REF → instrument)
-- 8. t_lekcja (REF → przedmiot, nauczyciel, sala, uczen, grupa)
-- 9. t_egzamin (REF → uczen, przedmiot, nauczyciel x2, sala)
-- 10. t_ocena (REF → uczen, nauczyciel, przedmiot, lekcja)
```

### 4.3 MACIERZ RELACJI REF (18 relacji)

| # | Z tabeli | Atrybut | Do tabeli | Opis |
|---|----------|---------|-----------|------|
| 1 | t_uczen | ref_instrument | t_instrument | Główny instrument ucznia |
| 2 | t_uczen | ref_grupa | t_grupa | Grupa teoretyczna |
| 3 | t_przedmiot | ref_instrument | t_instrument | Przedmiot dla instrumentu |
| 4 | t_lekcja | ref_przedmiot | t_przedmiot | Przedmiot lekcji |
| 5 | t_lekcja | ref_nauczyciel | t_nauczyciel | Prowadzący |
| 6 | t_lekcja | ref_akompaniator | t_nauczyciel | Akompaniator (opcja) |
| 7 | t_lekcja | ref_sala | t_sala | Sala |
| 8 | t_lekcja | ref_uczen | t_uczen | Uczeń (indywidualne) |
| 9 | t_lekcja | ref_grupa | t_grupa | Grupa (grupowe) |
| 10 | t_egzamin | ref_uczen | t_uczen | Zdający |
| 11 | t_egzamin | ref_przedmiot | t_przedmiot | Przedmiot |
| 12 | t_egzamin | ref_komisja1 | t_nauczyciel | Komisja 1 |
| 13 | t_egzamin | ref_komisja2 | t_nauczyciel | Komisja 2 |
| 14 | t_egzamin | ref_sala | t_sala | Sala |
| 15 | t_ocena | ref_uczen | t_uczen | Oceniany |
| 16 | t_ocena | ref_nauczyciel | t_nauczyciel | Wystawiający |
| 17 | t_ocena | ref_przedmiot | t_przedmiot | Przedmiot |
| 18 | t_ocena | ref_lekcja | t_lekcja | Powiązana lekcja |

---

## 5. TRIGGERY I WALIDACJA

### ⚠️ KLUCZOWE: Unikanie błędu ORA-04091 (Mutating Table)

**Problem:**
```sql
-- TO NIE ZADZIAŁA:
CREATE TRIGGER trg_lekcja_konflikt
BEFORE INSERT ON t_lekcja
FOR EACH ROW
DECLARE
    v_cnt NUMBER;
BEGIN
    -- ORA-04091! Nie można czytać t_lekcja podczas INSERT do t_lekcja!
    SELECT COUNT(*) INTO v_cnt 
    FROM t_lekcja 
    WHERE ref_sala = :NEW.ref_sala AND data_lekcji = :NEW.data_lekcji;
END;
```

**Rozwiązanie v5:**

| Walidacja | Gdzie? | Dlaczego? |
|-----------|--------|-----------|
| Wiek ucznia | Trigger | Nie wymaga SELECT z tej samej tabeli |
| Klasa ucznia | Trigger | j.w. |
| Typ ucznia | Trigger | j.w. |
| Email format | Trigger | j.w. |
| **Konflikt sali** | **PAKIET** | Wymaga SELECT z t_lekcja |
| **Konflikt nauczyciela** | **PAKIET** | j.w. |
| **Konflikt ucznia** | **PAKIET** | j.w. |
| **Limit godzin** | **PAKIET** | j.w. |
| **Popołudnia dla dzieci** | **PAKIET** | Wymaga JOIN z t_uczen |

### 5.1 Lista triggerów (6 bezpiecznych)

```sql
-- TRIGGERY BEZ RYZYKA ORA-04091:

1. trg_uczen_walidacja
   - Wiek >= 6 lat
   - Klasa 1-6
   - Status IN (...)
   - Typ ucznia IN (...)
   - Email format

2. trg_nauczyciel_walidacja
   - Email NOT NULL
   - Email format
   - Instrumenty NOT EMPTY
   - Status IN (...)

3. trg_sala_walidacja
   - Pojemność > 0
   - Numer NOT NULL
   - Status IN (...)

4. trg_ocena_walidacja
   - Wartość 1-6
   - Obszar IN (...)

5. trg_egzamin_walidacja
   - Typ IN (...)
   - Komisja 1 != Komisja 2
   - Ocena 1-6 lub NULL

6. trg_audit_dml (opcjonalny)
   - Logowanie zmian
```

### 5.2 Wzorzec triggera (bezpieczny)

```sql
CREATE OR REPLACE TRIGGER trg_uczen_walidacja
BEFORE INSERT OR UPDATE ON t_uczen
FOR EACH ROW
DECLARE
    v_wiek NUMBER;
BEGIN
    -- WALIDACJA 1: Wiek >= 6
    IF :NEW.data_urodzenia IS NOT NULL THEN
        v_wiek := TRUNC(MONTHS_BETWEEN(SYSDATE, :NEW.data_urodzenia) / 12);
        IF v_wiek < 6 THEN
            RAISE_APPLICATION_ERROR(-20001, 
                'Uczeń musi mieć minimum 6 lat. Wiek: ' || v_wiek);
        END IF;
    END IF;
    
    -- WALIDACJA 2: Typ ucznia
    IF :NEW.typ_ucznia NOT IN (
        'uczacy_sie_w_innej_szkole',
        'ukonczyl_edukacje',
        'tylko_muzyczna'
    ) THEN
        RAISE_APPLICATION_ERROR(-20002, 
            'Nieprawidłowy typ ucznia: ' || :NEW.typ_ucznia);
    END IF;
    
    -- ... pozostałe walidacje ...
END;
/
```

---

## 6. PAKIETY PL/SQL

### 6.1 Lista pakietów (6)

```
DOMENOWE (5):
├── pkg_uczen           -- CRUD + informacje + statystyki
├── pkg_nauczyciel      -- CRUD + plan + statystyki
├── pkg_lekcja          -- CRUD + HEURYSTYKA + walidacje konfliktów
├── pkg_ocena           -- CRUD + egzaminy + historia
└── pkg_raport          -- Raporty zbiorcze

NARZĘDZIOWY (1):
└── pkg_test            -- AUDYT FUNKCJONALNY (krok po kroku)
```

### 6.2 Specyfikacja pkg_lekcja (KLUCZOWY)

```sql
CREATE OR REPLACE PACKAGE pkg_lekcja AS
    
    -- ============================================
    -- WALIDACJE (zamiast triggerów - unikamy ORA-04091)
    -- ============================================
    
    FUNCTION czy_sala_wolna(
        p_id_sali       NUMBER,
        p_data          DATE,
        p_godzina       VARCHAR2,
        p_czas_trwania  NUMBER
    ) RETURN CHAR;  -- T/N
    
    FUNCTION czy_nauczyciel_wolny(
        p_id_nauczyciela NUMBER,
        p_data          DATE,
        p_godzina       VARCHAR2,
        p_czas_trwania  NUMBER
    ) RETURN CHAR;
    
    FUNCTION czy_uczen_wolny(
        p_id_ucznia     NUMBER,
        p_data          DATE,
        p_godzina       VARCHAR2,
        p_czas_trwania  NUMBER
    ) RETURN CHAR;
    
    FUNCTION czy_godzina_dozwolona(
        p_id_ucznia     NUMBER,
        p_godzina       VARCHAR2
    ) RETURN CHAR;  -- sprawdza typ_ucznia
    
    FUNCTION ile_godzin_nauczyciel_dzien(
        p_id_nauczyciela NUMBER,
        p_data          DATE
    ) RETURN NUMBER;
    
    FUNCTION ile_lekcji_uczen_dzien(
        p_id_ucznia     NUMBER,
        p_data          DATE
    ) RETURN NUMBER;
    
    -- ============================================
    -- PLANOWANIE
    -- ============================================
    
    PROCEDURE zaplanuj_indywidualna(
        p_id_ucznia     NUMBER,
        p_id_nauczyciela NUMBER,
        p_id_przedmiotu NUMBER,
        p_id_sali       NUMBER,
        p_data          DATE,
        p_godzina       VARCHAR2,
        p_czas_trwania  NUMBER DEFAULT 45,
        p_id_akompaniatora NUMBER DEFAULT NULL
    );
    
    PROCEDURE zaplanuj_grupowa(
        p_id_grupy      NUMBER,
        p_id_nauczyciela NUMBER,
        p_id_przedmiotu NUMBER,
        p_id_sali       NUMBER,
        p_data          DATE,
        p_godzina       VARCHAR2,
        p_czas_trwania  NUMBER DEFAULT 45
    );
    
    -- ============================================
    -- HEURYSTYKA (Big Rocks First!)
    -- ============================================
    
    PROCEDURE generuj_plan_tygodniowy(
        p_data_poczatku DATE,
        p_nadpisz       CHAR DEFAULT 'N'
    );
    
    -- ============================================
    -- ZARZĄDZANIE
    -- ============================================
    
    PROCEDURE zmien_status(p_id_lekcji NUMBER, p_status VARCHAR2);
    PROCEDURE odwolaj(p_id_lekcji NUMBER);
    PROCEDURE przeloz(p_id_lekcji NUMBER, p_nowa_data DATE, p_nowa_godzina VARCHAR2);
    
    -- ============================================
    -- POMOCNICZE
    -- ============================================
    
    FUNCTION znajdz_wolna_sale(
        p_data          DATE,
        p_godzina       VARCHAR2,
        p_czas_trwania  NUMBER,
        p_wymagany_sprzet VARCHAR2 DEFAULT NULL,
        p_min_pojemnosc NUMBER DEFAULT 1
    ) RETURN NUMBER;
    
    PROCEDURE plan_dnia(p_data DATE DEFAULT SYSDATE);
    
END pkg_lekcja;
/
```

### 6.3 Wzorzec walidacji w pakiecie

```sql
PROCEDURE zaplanuj_indywidualna(...) IS
BEGIN
    -- ======== WALIDACJE (zamiast triggerów!) ========
    
    -- 1. Czy godzina dozwolona dla typu ucznia?
    IF czy_godzina_dozwolona(p_id_ucznia, p_godzina) = 'N' THEN
        RAISE_APPLICATION_ERROR(-20020, 
            'Uczeń uczący się w innej szkole może mieć lekcje dopiero od 15:00');
    END IF;
    
    -- 2. Czy sala wolna?
    IF czy_sala_wolna(p_id_sali, p_data, p_godzina, p_czas_trwania) = 'N' THEN
        RAISE_APPLICATION_ERROR(-20021, 'Sala zajęta w tym terminie');
    END IF;
    
    -- 3. Czy nauczyciel wolny?
    IF czy_nauczyciel_wolny(p_id_nauczyciela, p_data, p_godzina, p_czas_trwania) = 'N' THEN
        RAISE_APPLICATION_ERROR(-20022, 'Nauczyciel ma inną lekcję w tym czasie');
    END IF;
    
    -- 4. Czy uczeń wolny?
    IF czy_uczen_wolny(p_id_ucznia, p_data, p_godzina, p_czas_trwania) = 'N' THEN
        RAISE_APPLICATION_ERROR(-20023, 'Uczeń ma inną lekcję w tym czasie');
    END IF;
    
    -- 5. Czy limit godzin nauczyciela OK?
    IF ile_godzin_nauczyciel_dzien(p_id_nauczyciela, p_data) + p_czas_trwania/60 > 6 THEN
        RAISE_APPLICATION_ERROR(-20024, 'Nauczyciel przekroczy limit 6h dziennie');
    END IF;
    
    -- 6. Czy limit lekcji ucznia OK?
    IF ile_lekcji_uczen_dzien(p_id_ucznia, p_data) >= 2 THEN
        RAISE_APPLICATION_ERROR(-20025, 'Uczeń ma już 2 lekcje tego dnia');
    END IF;
    
    -- ======== INSERT (po walidacji!) ========
    INSERT INTO t_lekcja VALUES (t_lekcja_obj(...));
    
    DBMS_OUTPUT.PUT_LINE('Zaplanowano lekcję na ' || p_data || ' ' || p_godzina);
END;
```

---

## 7. HEURYSTYKA PLANOWANIA

### ⚠️ ZASADA: BIG ROCKS FIRST (Najpierw duże kamienie)

```
KOLEJNOŚĆ PLANOWANIA:

KROK 1: LEKCJE GRUPOWE ("Duże kamienie")
   │
   │  Dlaczego najpierw?
   │  • Wymagają DUŻYCH sal (których jest mało)
   │  • Angażują WIELU uczniów naraz
   │  • Mają SZTYWNE terminy (np. Teoria zawsze we Wtorki)
   │
   ▼
KROK 2: LEKCJE INDYWIDUALNE - PRIORYTETOWE ("Żwir")
   │
   │  Kogo planujemy?
   │  • Uczniowie z innych szkół (tylko od 15:00!)
   │  • Rzadkie instrumenty (organy, harfa - mało nauczycieli)
   │  • Specjalne wymagania salowe
   │
   ▼
KROK 3: LEKCJE INDYWIDUALNE - RESZTA ("Piasek")
   │
   │  Kogo planujemy?
   │  • Dorośli (elastyczne godziny)
   │  • Popularne instrumenty (fortepian, gitara)
   │
   ▼
KROK 4: RÓWNOWAŻENIE
   │
   │  • Sprawdź nierównomierności obciążenia
   │  • Ostrzeż jeśli różnice > 30%
   │
   ▼
   DONE
```

### 7.1 Algorytm szczegółowy

```sql
PROCEDURE generuj_plan_tygodniowy(p_data_poczatku DATE, p_nadpisz CHAR DEFAULT 'N') IS
    v_data_pn DATE := TRUNC(p_data_poczatku, 'IW');  -- poniedziałek
BEGIN
    -- ============ FAZA 1: GRUPOWE ============
    DBMS_OUTPUT.PUT_LINE('[FAZA 1] Planowanie zajęć grupowych...');
    
    FOR r_grupa IN (
        SELECT g.id_grupy, g.nazwa, 
               (SELECT COUNT(*) FROM t_uczen u WHERE u.ref_grupa = REF(g)) AS cnt
        FROM t_grupa g WHERE g.status = 'aktywna'
        ORDER BY cnt DESC  -- większe grupy najpierw
    ) LOOP
        -- Kształcenie słuchu - dla każdej grupy
        planuj_zajecia_grupowe(r_grupa.id_grupy, 'Kształcenie słuchu', v_data_pn);
        
        -- Rytmika - tylko klasy I-II
        IF r_grupa.klasa <= 2 THEN
            planuj_zajecia_grupowe(r_grupa.id_grupy, 'Rytmika', v_data_pn);
        END IF;
    END LOOP;
    
    -- ============ FAZA 2: INDYWIDUALNE PRIORYTETOWE ============
    DBMS_OUTPUT.PUT_LINE('[FAZA 2] Planowanie lekcji priorytetowych...');
    
    FOR r_uczen IN (
        SELECT u.id_ucznia, u.imie, u.nazwisko, u.typ_ucznia,
               DEREF(u.ref_instrument).nazwa AS instrument,
               -- Priorytet: 1 = najtrudniejszy do upchnięcia
               CASE 
                   WHEN u.typ_ucznia = 'uczacy_sie_w_innej_szkole' THEN 1
                   ELSE 2 
               END AS priorytet
        FROM t_uczen u
        WHERE u.status = 'aktywny'
        ORDER BY priorytet ASC
    ) LOOP
        znajdz_i_zaplanuj_indywidualna(r_uczen.id_ucznia, v_data_pn);
    END LOOP;
    
    -- ============ FAZA 3: RÓWNOWAŻENIE ============
    DBMS_OUTPUT.PUT_LINE('[FAZA 3] Sprawdzanie równomierności...');
    sprawdz_rownomiernosc(v_data_pn);
    
    COMMIT;
END;
```

### 7.2 Znajdowanie wolnego terminu

```sql
FUNCTION znajdz_wolny_slot(
    p_id_ucznia      NUMBER,
    p_id_nauczyciela NUMBER,
    p_data_od        DATE,
    p_czas_trwania   NUMBER
) RETURN VARCHAR2 IS  -- 'YYYY-MM-DD HH:MI' lub NULL
    v_min_godz VARCHAR2(5);
    v_typ_ucznia VARCHAR2(30);
BEGIN
    -- Pobierz typ ucznia
    SELECT typ_ucznia INTO v_typ_ucznia FROM t_uczen WHERE id_ucznia = p_id_ucznia;
    
    -- Ustal minimalną godzinę
    v_min_godz := CASE WHEN v_typ_ucznia = 'uczacy_sie_w_innej_szkole' 
                       THEN '15:00' ELSE '14:00' END;
    
    -- Szukaj w kolejnych dniach
    FOR v_dzien IN 0..4 LOOP  -- Pn-Pt
        FOR v_godzina IN 14..19 LOOP  -- 14:00 - 19:00
            FOR v_minuta IN 0..1 LOOP  -- :00 i :30
                DECLARE
                    v_slot VARCHAR2(5) := TO_CHAR(v_godzina, 'FM00') || ':' || 
                                          CASE v_minuta WHEN 0 THEN '00' ELSE '30' END;
                    v_data DATE := p_data_od + v_dzien;
                BEGIN
                    -- Sprawdź czy slot >= minimum
                    IF v_slot >= v_min_godz THEN
                        -- Sprawdź wszystkie warunki
                        IF czy_nauczyciel_wolny(p_id_nauczyciela, v_data, v_slot, p_czas_trwania) = 'T'
                           AND czy_uczen_wolny(p_id_ucznia, v_data, v_slot, p_czas_trwania) = 'T'
                        THEN
                            -- Znajdź salę
                            DECLARE
                                v_sala NUMBER := znajdz_wolna_sale(v_data, v_slot, p_czas_trwania);
                            BEGIN
                                IF v_sala IS NOT NULL THEN
                                    RETURN TO_CHAR(v_data, 'YYYY-MM-DD') || ' ' || v_slot;
                                END IF;
                            END;
                        END IF;
                    END IF;
                END;
            END LOOP;
        END LOOP;
    END LOOP;
    
    RETURN NULL;  -- nie znaleziono
END;
```

---

## 8. SYSTEM TESTÓW

### ⚠️ NOWA KONCEPCJA: AUDYT FUNKCJONALNY

Zamiast "magicznych" scenariuszy Demo, robimy **testy krok po kroku** - każda procedura wykonuje JEDNĄ operację i pokazuje wynik.

### 8.1 Struktura testów

```
pkg_test
├── SETUP
│   ├── reset_bazy()           -- przywraca stan początkowy
│   ├── stan_bazy()            -- pokazuje liczebność tabel
│   └── generuj_dane_demo()    -- tworzy dane z "dziurami"
│
├── AUDYT: UCZEŃ
│   ├── krok_uczen_01_dodaj()
│   ├── krok_uczen_02_info()
│   ├── krok_uczen_03_zmien_status()
│   ├── krok_uczen_04_przenies_grupe()
│   └── krok_uczen_05_usun_blokada()  -- test blokady REF
│
├── AUDYT: LEKCJA
│   ├── krok_lekcja_01_dodaj_ok()
│   ├── krok_lekcja_02_konflikt_sali()
│   ├── krok_lekcja_03_konflikt_nauczyciela()
│   ├── krok_lekcja_04_konflikt_ucznia()
│   ├── krok_lekcja_05_limit_godzin()
│   ├── krok_lekcja_06_popoludnie_blokada()
│   ├── krok_lekcja_07_popoludnie_ok()
│   └── krok_lekcja_08_generuj_plan()
│
├── AUDYT: OCENA
│   ├── krok_ocena_01_wystaw()
│   ├── krok_ocena_02_historia()
│   └── krok_ocena_03_srednia()
│
├── AUDYT: EGZAMIN
│   ├── krok_egzamin_01_zaplanuj()
│   ├── krok_egzamin_02_rozna_komisja()
│   └── krok_egzamin_03_wystaw_ocene()
│
└── RAPORTY
    ├── raport_plan_dnia()
    ├── raport_obciazenie_nauczycieli()
    └── raport_uczniowie_zagrozeni()
```

### 8.2 Wzorzec procedury testowej

```sql
PROCEDURE krok_lekcja_06_popoludnie_blokada IS
    v_id_ucznia NUMBER;
BEGIN
    banner('TEST: Blokada lekcji przed 15:00 dla ucznia z innej szkoły');
    
    -- Znajdź ucznia z innej szkoły
    SELECT id_ucznia INTO v_id_ucznia
    FROM t_uczen 
    WHERE typ_ucznia = 'uczacy_sie_w_innej_szkole' AND ROWNUM = 1;
    
    info('Uczeń ID: ' || v_id_ucznia);
    info('Typ: uczacy_sie_w_innej_szkole');
    info('Próba zaplanowania lekcji na 14:00...');
    
    BEGIN
        pkg_lekcja.zaplanuj_indywidualna(
            p_id_ucznia      => v_id_ucznia,
            p_id_nauczyciela => 1,
            p_id_przedmiotu  => 1,
            p_id_sali        => 1,
            p_data           => NEXT_DAY(SYSDATE, 'WTOREK'),
            p_godzina        => '14:00',
            p_czas_trwania   => 45
        );
        
        blad('NIEPOWODZENIE! Lekcja została dodana, a nie powinna!');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20020 THEN
                sukces('ZABLOKOWANO POPRAWNIE: ' || SQLERRM);
            ELSE
                blad('Nieoczekiwany błąd: ' || SQLERRM);
            END IF;
    END;
    
    ROLLBACK;
END;
```

### 8.3 Procedury pomocnicze (formatowanie)

```sql
-- Nagłówek sekcji
PROCEDURE banner(p_tekst VARCHAR2) IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('╔' || RPAD('═', 60, '═') || '╗');
    DBMS_OUTPUT.PUT_LINE('║ ' || RPAD(p_tekst, 59) || '║');
    DBMS_OUTPUT.PUT_LINE('╚' || RPAD('═', 60, '═') || '╝');
END;

-- Informacja
PROCEDURE info(p_tekst VARCHAR2) IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('ℹ️  ' || p_tekst);
END;

-- Sukces
PROCEDURE sukces(p_tekst VARCHAR2) IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('✅ ' || p_tekst);
END;

-- Błąd
PROCEDURE blad(p_tekst VARCHAR2) IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('❌ ' || p_tekst);
END;

-- Pauza (opcjonalna - dla prezentacji)
PROCEDURE pauza IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('--- Naciśnij ENTER aby kontynuować ---');
    -- W SQL*Plus: ACCEPT dummy PROMPT ''
END;
```

### 8.4 Sekwencja uruchamiania (dla obrony)

```sql
-- PRZED PREZENTACJĄ:
EXEC pkg_test.reset_bazy;
EXEC pkg_test.generuj_dane_demo;
EXEC pkg_test.stan_bazy;

-- PREZENTACJA - AUDYT UCZNIA:
EXEC pkg_test.krok_uczen_01_dodaj;
EXEC pkg_test.krok_uczen_02_info;
-- ...

-- PREZENTACJA - AUDYT LEKCJI:
EXEC pkg_test.krok_lekcja_01_dodaj_ok;
EXEC pkg_test.krok_lekcja_02_konflikt_sali;
EXEC pkg_test.krok_lekcja_06_popoludnie_blokada;
EXEC pkg_test.krok_lekcja_07_popoludnie_ok;
EXEC pkg_test.krok_lekcja_08_generuj_plan;

-- RAPORTY:
EXEC pkg_test.raport_plan_dnia;
```

---

## 9. ROLE I UŻYTKOWNICY

### 9.1 Role (4)

| Rola | Opis | Główne uprawnienia |
|------|------|-------------------|
| r_admin | Administrator | Pełny dostęp SIUD na wszystko |
| r_sekretariat | Sekretariat | Zarządzanie uczniami, grupami, planem |
| r_nauczyciel | Nauczyciel | Swoje lekcje, oceny, plan |
| r_uczen | **NOWY!** | Podgląd swojego planu i ocen |

### 9.2 Macierz uprawnień

| Tabela | Admin | Sekretariat | Nauczyciel | Uczeń |
|--------|-------|-------------|------------|-------|
| t_semestr | SIUD | S | S | S |
| t_instrument | SIUD | S | S | S |
| t_sala | SIUD | SIU | S | S |
| t_nauczyciel | SIUD | SIU | S* | - |
| t_uczen | SIUD | SIU | S | S* |
| t_grupa | SIUD | SIUD | S | S* |
| t_przedmiot | SIUD | S | S | S |
| t_lekcja | SIUD | SIU | SU* | S* |
| t_egzamin | SIUD | SIU | SU* | S* |
| t_ocena | SIUD | S | SI* | S* |

`*` = tylko swoje dane (przez widoki)

### 9.3 Widoki bezpieczeństwa

```sql
-- Uczeń widzi tylko swoje lekcje
CREATE OR REPLACE VIEW v_moje_lekcje AS
SELECT l.* FROM t_lekcja l
WHERE DEREF(l.ref_uczen).id_ucznia = get_current_user_id()
   OR l.ref_grupa IN (
       SELECT u.ref_grupa FROM t_uczen u 
       WHERE u.id_ucznia = get_current_user_id()
   );

-- Uczeń widzi tylko swoje oceny
CREATE OR REPLACE VIEW v_moje_oceny AS
SELECT o.* FROM t_ocena o
WHERE DEREF(o.ref_uczen).id_ucznia = get_current_user_id();
```

### 9.4 Użytkownicy testowi

```sql
CREATE USER usr_admin IDENTIFIED BY "Admin123!";
GRANT r_admin TO usr_admin;

CREATE USER usr_sekretariat IDENTIFIED BY "Sekr123!";
GRANT r_sekretariat TO usr_sekretariat;

CREATE USER usr_nauczyciel IDENTIFIED BY "Naucz123!";
GRANT r_nauczyciel TO usr_nauczyciel;

CREATE USER usr_uczen IDENTIFIED BY "Uczen123!";
GRANT r_uczen TO usr_uczen;
```

---

## 10. DANE STARTOWE

### ⚠️ KLUCZOWE: Dane z "dziurami" na demo

Aby prezentacja ZAWSZE się udała, dane startowe muszą:
1. Zająć ~60% slotów (żeby pokazać, że algorytm działa)
2. Zostawić CELOWE "dziury" na lekcje pokazowe

### 10.1 Struktura danych

```
SŁOWNIKI:
├── Instrumenty: 10 (fortepian, gitara, skrzypce, flet, klarnet, 
│                    saksofon, perkusja, trąbka, wiolonczela, organy)
├── Przedmioty: 6 (Instrument główny, Fortepian dodatkowy, 
│                  Kształcenie słuchu, Rytmika, Zespół kameralny, 
│                  Audycje muzyczne)
└── Sale: 5 (2 indywidualne z fortepianem, 1 grupowa, 
             1 wielofunkcyjna, 1 z organami)

ZASOBY:
├── Nauczyciele: 5
│   ├── Jan Kowalski (Fortepian, Organy) - grupowe: T, akomp: N
│   ├── Anna Nowak (Gitara, Skrzypce) - grupowe: N, akomp: N
│   ├── Piotr Wiśniewski (Flet, Klarnet, Saksofon) - grupowe: T, akomp: N
│   ├── Maria Dąbrowska (Teoria, Kształcenie słuchu) - grupowe: T, akomp: N
│   └── Tomasz Lewandowski (Wiolonczela, Fortepian) - grupowe: N, akomp: T
│
├── Grupy: 4
│   ├── 1A (klasa 1, max 12)
│   ├── 1B (klasa 1, max 12)
│   ├── 2A (klasa 2, max 12)
│   └── 3A (klasa 3, max 10)
│
└── Uczniowie: 15
    ├── 5x typ 'uczacy_sie_w_innej_szkole' (tylko od 15:00)
    ├── 5x typ 'ukonczyl_edukacje' (dorośli)
    └── 5x typ 'tylko_muzyczna' (elastyczni)
```

### 10.2 Procedura generowania

```sql
PROCEDURE generuj_dane_demo IS
BEGIN
    -- Instrumenty
    INSERT INTO t_instrument VALUES (t_instrument_obj(1, 'Fortepian', 'klawiszowe', 'N'));
    INSERT INTO t_instrument VALUES (t_instrument_obj(2, 'Gitara', 'strunowe', 'N'));
    INSERT INTO t_instrument VALUES (t_instrument_obj(3, 'Skrzypce', 'strunowe', 'T')); -- wymaga akomp!
    -- ... 7 więcej ...
    
    -- Sale
    INSERT INTO t_sala VALUES (t_sala_obj(1, 'A1', 'indywidualna', 2, 
        t_lista_sprzetu('Fortepian Yamaha', 'Pulpit'), 'dostepna'));
    INSERT INTO t_sala VALUES (t_sala_obj(2, 'A2', 'indywidualna', 2, 
        t_lista_sprzetu('Fortepian Steinway', 'Pulpit'), 'dostepna'));
    INSERT INTO t_sala VALUES (t_sala_obj(3, 'B1', 'grupowa', 15, 
        t_lista_sprzetu('Pianino', 'Tablica', 'Krzesła x15'), 'dostepna'));
    -- ... 2 więcej ...
    
    -- Nauczyciele
    INSERT INTO t_nauczyciel VALUES (t_nauczyciel_obj(1, 'Jan', 'Kowalski', ...));
    -- ... 4 więcej ...
    
    -- Grupy
    INSERT INTO t_grupa VALUES (t_grupa_obj(1, '1A', 1, '2025/2026', 12, 'aktywna'));
    -- ... 3 więcej ...
    
    -- Uczniowie (z różnymi typami!)
    INSERT INTO t_uczen VALUES (t_uczen_obj(1, 'Kacper', 'Malinowski', 
        DATE '2015-05-12', NULL, NULL, SYSDATE, 1, 6, 
        'uczacy_sie_w_innej_szkole', 'aktywny', ...));
    -- ... 14 więcej ...
    
    -- Lekcje tła (~60% slotów)
    -- CELOWO ZOSTAWIAMY:
    -- - Wtorek 16:00 Sala A1 - wolne (dla demo konfliktu)
    -- - Środa 15:00 Nauczyciel 1 - wolne (dla demo popołudnia)
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Wygenerowano dane demo z dziurami na prezentację');
END;
```

---

## 11. DIAGRAM RELACJI

### 11.1 ASCII (do README)

```
                              ┌──────────────┐
                              │  t_semestr   │
                              └──────────────┘
                                     
┌──────────────┐              ┌──────────────┐
│ t_instrument │◄─────────────│ t_przedmiot  │
└──────────────┘              └──────────────┘
       ▲                             ▲
       │                             │
       │  ┌──────────────┐           │
       └──│   t_uczen    │           │
          └──────────────┘           │
                 │ ▲                 │
                 │ │                 │
                 ▼ │                 │
          ┌──────────────┐           │
          │   t_grupa    │           │
          └──────────────┘           │
                 ▲                   │
                 │                   │
                 │                   │
    ┌────────────┴───────────────────┼────────────┐
    │                                │            │
    ▼                                ▼            ▼
┌──────────────┐              ┌──────────────┐  ┌──────────────┐
│   t_lekcja   │──────────────│   t_ocena    │  │  t_egzamin   │
└──────────────┘              └──────────────┘  └──────────────┘
    │   │   │                       │   │            │   │
    │   │   │                       │   │            │   │
    │   │   ▼                       │   ▼            │   ▼
    │   │  ┌──────────────┐         │  ┌──────────────┐
    │   └─►│ t_nauczyciel │◄────────┴──│    t_sala    │
    │      └──────────────┘            └──────────────┘
    │             ▲
    └─────────────┘ (akompaniator)


LEGENDA:
  ──────►  REF (N:1)
  ══════   VARRAY (embedded collection)
```

### 11.2 Tabela relacji

| # | Z | Do | REF | NULL? |
|---|---|---|-----|-------|
| 1 | t_uczen | t_instrument | ref_instrument | NIE |
| 2 | t_uczen | t_grupa | ref_grupa | TAK |
| 3 | t_przedmiot | t_instrument | ref_instrument | TAK |
| 4 | t_lekcja | t_przedmiot | ref_przedmiot | NIE |
| 5 | t_lekcja | t_nauczyciel | ref_nauczyciel | NIE |
| 6 | t_lekcja | t_nauczyciel | ref_akompaniator | TAK |
| 7 | t_lekcja | t_sala | ref_sala | NIE |
| 8 | t_lekcja | t_uczen | ref_uczen | TAK* |
| 9 | t_lekcja | t_grupa | ref_grupa | TAK* |
| 10 | t_egzamin | t_uczen | ref_uczen | NIE |
| 11 | t_egzamin | t_przedmiot | ref_przedmiot | NIE |
| 12 | t_egzamin | t_nauczyciel | ref_komisja1 | NIE |
| 13 | t_egzamin | t_nauczyciel | ref_komisja2 | NIE |
| 14 | t_egzamin | t_sala | ref_sala | NIE |
| 15 | t_ocena | t_uczen | ref_uczen | NIE |
| 16 | t_ocena | t_nauczyciel | ref_nauczyciel | NIE |
| 17 | t_ocena | t_przedmiot | ref_przedmiot | NIE |
| 18 | t_ocena | t_lekcja | ref_lekcja | TAK |

`*` = Dokładnie jedno z dwóch musi być NOT NULL (indywidualna vs grupowa)

---

## 12. CHECKLIST IMPLEMENTACJI

### ETAP 1: Typy i tabele
- [ ] 01_typy.sql - 12 typów z metodami
- [ ] 02_tabele.sql - 10 tabel z REF

### ETAP 2: Walidacja
- [ ] 03_triggery.sql - 6 triggerów (BEZ walidacji konfliktów!)

### ETAP 3: Logika
- [ ] 04_pakiety.sql - 6 pakietów (walidacje konfliktów W PAKIETACH)

### ETAP 4: Dane
- [ ] 05_dane.sql - dane startowe z "dziurami"

### ETAP 5: Bezpieczeństwo
- [ ] 06_role.sql - 4 role
- [ ] 07_uzytkownicy.sql - użytkownicy testowi
- [ ] 08_widoki.sql - widoki bezpieczeństwa

### ETAP 6: Testy
- [ ] 09_testy.sql - pkg_test z krokami audytu

### ETAP 7: Dokumentacja
- [ ] README.md z diagramem
- [ ] Raport_v5.tex

---

## 📋 ARGUMENTY NA OBRONĘ

### Pytanie: "Dlaczego walidacja konfliktów w pakiecie, nie w triggerze?"
> "Trigger FOR EACH ROW nie może czytać tabeli, do której właśnie wstawia (ORA-04091).
> Umieszczenie walidacji w pakiecie jest standardową praktyką Oracle i zapewnia pełną kontrolę transakcji."

### Pytanie: "Dlaczego najpierw grupowe, potem indywidualne?"
> "Stosujemy zasadę Big Rocks First. Lekcje grupowe wymagają dużych sal i blokują czas wielu uczniom.
> Gdybyśmy najpierw zaplanowali indywidualne, moglibyśmy nie znaleźć miejsca na zajęcia z kształcenia słuchu dla całej klasy."

### Pytanie: "Dlaczego typ_ucznia zamiast wieku?"
> "Ograniczenie godzinowe wynika ze statusu edukacyjnego, nie z wieku.
> 17-letni maturzysta może mieć lekcje o 14:00, ale 19-letni student dziennie - dopiero od 15:00.
> To bardziej realistyczny model."

### Pytanie: "Dlaczego 4 role, a nie 3?"
> "Uczeń jest użytkownikiem systemu. Powinien móc sprawdzić swój plan i oceny.
> Bez roli ucznia system byłby niekompletny z perspektywy użytkownika końcowego."

---

```
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║   PLAN v5 GOTOWY DO IMPLEMENTACJI                             ║
║                                                               ║
║   Autor: Claude 4.5 Opus                                      ║
║   Wersja: 1.0                                                 ║
║   Założenia: 30+                                              ║
║   Typy: 12                                                    ║
║   Tabele: 10                                                  ║
║   Relacje REF: 18                                             ║
║   Pakiety: 6                                                  ║
║   Role: 4                                                     ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
```
