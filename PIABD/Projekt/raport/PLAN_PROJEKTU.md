# Plan Projektu - Baza Danych Company (CrunchBase)

**Autor:** Mateusz Mróz (251190)  
**Data:** 08.01.2026  
**Przedmiot:** Projektowanie i Administracja Baz Danych (PIABD)

---

## 1. Słownik Pojęć

### 1.1 Postacie Normalne (Normalization Forms)

| Pojęcie | Opis |
|---------|------|
| **1NF (First Normal Form)** | Pierwsza postać normalna - tabela spełnia 1NF gdy: (1) każda kolumna zawiera wartości atomowe (niepodzielne), (2) każda kolumna ma unikalną nazwę, (3) kolejność wierszy i kolumn nie ma znaczenia, (4) brak powtarzających się grup |
| **2NF (Second Normal Form)** | Druga postać normalna - tabela spełnia 2NF gdy: (1) spełnia 1NF, (2) każdy atrybut niekluczowy jest w pełni funkcyjnie zależny od całego klucza głównego (eliminacja częściowych zależności) |
| **3NF (Third Normal Form)** | Trzecia postać normalna - tabela spełnia 3NF gdy: (1) spełnia 2NF, (2) żaden atrybut niekluczowy nie jest zależny przechodnio od klucza głównego (eliminacja zależności przechodnich) |

### 1.2 Ograniczenia (Constraints)

| Pojęcie | Opis |
|---------|------|
| **PRIMARY KEY (PK)** | Klucz główny - unikalna identyfikacja każdego wiersza w tabeli, nie może być NULL |
| **FOREIGN KEY (FK)** | Klucz obcy - odwołanie do klucza głównego w innej tabeli, zapewnia integralność referencyjną |
| **UNIQUE** | Wymusza unikalność wartości w kolumnie (lub zbiorze kolumn), może zawierać NULL |
| **CHECK** | Ograniczenie sprawdzające - waliduje dane przed wstawieniem (np. CHECK (price >= 0)) |
| **DEFAULT** | Wartość domyślna - automatycznie przypisywana gdy nie podano wartości |
| **NOT NULL** | Wymusza, że kolumna nie może zawierać wartości NULL |

### 1.3 Obiekty Bazodanowe

| Pojęcie | Opis |
|---------|------|
| **Indeks (Index)** | Struktura przyspieszająca wyszukiwanie danych w tabeli |
| **Widok (View)** | Wirtualna tabela oparta na zapytaniu SELECT |
| **Procedura składowana (Stored Procedure)** | Zestaw instrukcji SQL zapisany w bazie, wywoływany przez EXEC |
| **Funkcja użytkownika (User Function)** | Zwraca wartość (skalarną lub tabelę), może być użyta w zapytaniach |
| **Trigger (Wyzwalacz)** | Automatycznie wykonywany kod przy INSERT/UPDATE/DELETE |
| **Schemat (Schema)** | Logiczny kontener dla obiektów bazy danych |

### 1.4 Terminy specyficzne dla projektu

| Pojęcie | Opis |
|---------|------|
| **Contained User** | Użytkownik przechowywany lokalnie w bazie (nie na poziomie serwera) |
| **ERD (Entity-Relationship Diagram)** | Diagram przedstawiający encje i relacje między nimi |
| **JSON (JavaScript Object Notation)** | Format wymiany danych, używany w dokumentach źródłowych |

---

## 2. Analiza Struktury Dokumentów JSON

### 2.1 Główne encje zidentyfikowane w JSON

Na podstawie analizy plików `companies documents 1-6.json` zidentyfikowano następujące encje:

1. **Company** (Firma) - główna encja
2. **Person** (Osoba) - pracownicy, inwestorzy
3. **FinancialOrg** (Organizacja finansowa) - fundusze inwestycyjne
4. **Product** (Produkt) - produkty firmy
5. **Office** (Biuro) - lokalizacje firmy
6. **FundingRound** (Runda finansowania)
7. **Investment** (Inwestycja)
8. **Acquisition** (Przejęcie)
9. **Milestone** (Kamień milowy)
10. **Competitor** (Konkurent)
11. **Relationship** (Relacja osoba-firma)
12. **ExternalLink** (Link zewnętrzny)
13. **Screenshot** (Zrzut ekranu)
14. **VideoEmbed** (Video)
15. **Provider** (Dostawca usług)
16. **Image** (Obrazy/Logo)

### 2.2 Analiza pól JSON → Kolumny relacyjne

#### Company (główna tabela)
```
_id.$oid → company_id (PK)
name → name
permalink → permalink (UNIQUE)
crunchbase_url → crunchbase_url
homepage_url → homepage_url
blog_url → blog_url
blog_feed_url → blog_feed_url
twitter_username → twitter_username
category_code → category_code
number_of_employees → number_of_employees
founded_year, founded_month, founded_day → founded_date
deadpooled_year, deadpooled_month, deadpooled_day → deadpooled_date
tag_list → tag_list
alias_list → alias_list
email_address → email_address
phone_number → phone_number
description → description
created_at → created_at
updated_at → updated_at
overview → overview
total_money_raised → total_money_raised
```

---

## 3. Projekt Schematu Relacyjnego

### 3.1 Lista Tabel (16 tabel)

| Nr | Nazwa Tabeli | Opis |
|----|--------------|------|
| 1 | `Company` | Główna tabela firm |
| 2 | `Person` | Osoby (pracownicy, inwestorzy) |
| 3 | `FinancialOrg` | Organizacje finansowe |
| 4 | `Product` | Produkty firm |
| 5 | `Office` | Biura/Lokalizacje |
| 6 | `FundingRound` | Rundy finansowania |
| 7 | `Investment` | Inwestycje w rundach |
| 8 | `Acquisition` | Przejęcia firm |
| 9 | `Milestone` | Kamienie milowe |
| 10 | `Competitor` | Konkurenci (relacja M:N) |
| 11 | `CompanyRelationship` | Relacje osoba-firma |
| 12 | `ExternalLink` | Linki zewnętrzne |
| 13 | `Screenshot` | Zrzuty ekranu |
| 14 | `VideoEmbed` | Filmy |
| 15 | `Provider` | Dostawcy usług |
| 16 | `CompanyImage` | Obrazy/Logo |

### 3.2 Diagram ERD (opis słowny)

```
Company (1) ←→ (N) Product
Company (1) ←→ (N) Office
Company (1) ←→ (N) FundingRound
Company (1) ←→ (N) Milestone
Company (1) ←→ (N) ExternalLink
Company (1) ←→ (N) Screenshot
Company (1) ←→ (N) VideoEmbed
Company (1) ←→ (N) CompanyImage
Company (1) ←→ (N) Competitor [jako company_id]
Company (1) ←→ (N) Competitor [jako competitor_company_id]
Company (1) ←→ (N) CompanyRelationship
Company (1) ←→ (N) Provider
Company (1) ←→ (N) Acquisition [jako acquiring_company_id]
Company (1) ←→ (0..1) Acquisition [jako acquired_company_id]

FundingRound (1) ←→ (N) Investment
Investment (N) ←→ (0..1) Person
Investment (N) ←→ (0..1) FinancialOrg
Investment (N) ←→ (0..1) Company [jako investing_company]

CompanyRelationship (N) ←→ (1) Person
Provider (N) ←→ (1) Company [jako provider_company_id]
```

---

## 4. Harmonogram Prac

| Etap | Zadanie | Status |
|------|---------|--------|
| 1 | ✅ Analiza wymagań i dokumentów JSON | Ukończone |
| 2 | ✅ Rozpiska pojęć i plan projektu | Ukończone |
| 3 | 🔄 Projekt struktury tabel (ERD) | W trakcie |
| 4 | ⏳ Skrypt SQL - tworzenie struktury | Oczekuje |
| 5 | ⏳ Skrypt SQL - import danych JSON | Oczekuje |
| 6 | ⏳ Procedury, funkcje, widoki, triggery | Oczekuje |
| 7 | ⏳ Role, użytkownicy, uprawnienia | Oczekuje |
| 8 | ⏳ Raport LaTeX - dokumentacja | Oczekuje |

---

## 5. Uwagi do Normalizacji

### Problemy z danymi JSON → rozwiązania:

1. **tag_list jako string z przecinkami** → Zachowujemy jako VARCHAR (denormalizacja celowa dla prostoty, alternatywnie można stworzyć tabelę Tag i CompanyTag)

2. **image.available_sizes jako tablica** → Osobna tabela CompanyImage

3. **Zagnieżdżone obiekty (person w relationship)** → Rozbicie na osobne tabele z kluczami obcymi

4. **Daty jako osobne pola (year, month, day)** → Konwersja na typ DATE lub zachowanie jako INT (dla dat niepełnych)

5. **Niektóre pola mogą być NULL** → Dozwolone w projekcie, udokumentowane

---

## 6. Technologie

- **RDBMS:** Microsoft SQL Server
- **IDE:** SQL Server Management Studio (SSMS)
- **Format danych źródłowych:** JSON
- **Dokumentacja:** LaTeX
- **Diagram:** ERD generowany w SSMS lub draw.io
