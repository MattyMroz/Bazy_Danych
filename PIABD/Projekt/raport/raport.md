### Rozdział 1. Podstawowe założenia projektu

#### 1.1. Cel tworzenia bazy
Celem projektu jest stworzenie relacyjnej bazy danych `CompanyDB` na serwerze MS SQL. Baza służy do przechowywania danych o firmach (startupach), ich pracownikach i inwestycjach. Dane wejściowe pochodzą z plików JSON (serwis CrunchBase). Moim zadaniem było zaprojektowanie struktury tabel i napisanie skryptu, który przeniesie te dane z formatu dokumentowego (JSON) do uporządkowanej bazy SQL.

#### 1.2. Główne założenia
Przyjąłem następujące zasady przy tworzeniu bazy:
*   **Silnik:** Baza działa na Microsoft SQL Server.
*   **Struktura:** Baza jest relacyjna i dąży do 3. Postaci Normalnej (3NF), żeby nie powielać niepotrzebnie danych.
*   **Bezpieczeństwo:** Użyłem opcji *Contained Database*. Dzięki temu użytkownicy są przypisani bezpośrednio do bazy danych, a nie do całego serwera SQL. To ułatwia przenoszenie bazy.
*   **Spójność:** Zastosowałem klucze obce (Foreign Keys). Jeśli usuniemy firmę, to automatycznie usuną się jej produkty czy biura (opcja `ON DELETE CASCADE`).
*   **Klucze:** Każda tabela ma swój własny, unikalny numer ID (np. `company_id`), który generuje się automatycznie. Nie używam nazw firm jako kluczy, bo mogą się powtarzać lub zmieniać.

#### 1.3. Zakres możliwości systemu
W bazie można:
*   Przechowywać informacje o firmach, ich produktach i adresach biur.
*   Sprawdzać historię finansowania – kto, ile i kiedy zainwestował w daną firmę.
*   Widzieć powiązania między ludźmi a firmami (kto gdzie pracuje lub pracował).
*   Analizować konkurencję i przejęcia firm.
*   Automatycznie importować dane z plików JSON za pomocą przygotowanego skryptu SQL.

#### 1.4. Wszelkie ograniczenia przyjęte podczas projektowania
W projekcie zastosowałem kilka uproszczeń:
*   **Tagi:** Pola takie jak `tag_list` (lista tagów po przecinku) zostawiłem jako zwykły tekst. Rozbijanie tego na osobne tabele skomplikowałoby import, a w tym projekcie nie jest to kluczowe. To świadome odstępstwo od 1. Postaci Normalnej.
*   **Waluty:** Zakładam, że kwoty są w dolarach (USD) lub są przeliczane, nie robiłem osobnego systemu kursów walut.
*   **Braki danych:** Pliki JSON są dziurawe (np. brak roku założenia), więc baza pozwala na wpisywanie wartości pustych (`NULL`) w wielu miejscach.

---

### Rozdział 2. Schemat bazy danych

#### 2.1. Czytelny, graficzny schemat bazy
*(Tutaj wkleisz obrazek diagramu z SQL Servera)*

#### 2.2. Opis struktury relacyjnej
Sercem bazy jest tabela `Company` (Firmy). Wszystkie inne tabele są z nią powiązane – np. `Product` (Produkty), `Office` (Biura).

Podczas projektowania musiałem rozwiązać dwa trudniejsze problemy:

**1. Relacja Wiele-do-Wielu (Ludzie i Firmy)**
Jedna osoba może pracować w wielu firmach, a w firmie pracuje wiele osób. Nie mogłem wpisać pracownika bezpośrednio do tabeli firmy.
*   **Rozwiązanie:** Stworzyłem tabelę łączącą `CompanyRelationship`. Łączy ona ID osoby z ID firmy i dodaje informację o stanowisku (np. "CEO").

**2. Kto jest inwestorem? (Różne typy inwestorów)**
W firmę może zainwestować: inna osoba, inna firma albo bank/fundusz.
*   **Rozwiązanie:** W tabeli `Investment` (Inwestycje) mam trzy kolumny na ID: `person_id`, `financial_org_id` i `investing_company_id`. Wypełniam tylko jedną z nich dla danej inwestycji, a reszta zostaje pusta. To proste i skuteczne rozwiązanie problemu polimorfizmu w SQL.

#### 2.3. Normalizacja
Starałem się trzymać zasad normalizacji:

*   **1NF (Atomowość):** W każdej kratce tabeli jest jedna wartość. Wyjątkiem są wspomniane wcześniej tagi, które zostawiłem jako listę po przecinku dla wygody.
*   **2NF:** Każda tabela ma swój klucz główny (`ID`), więc wszystkie dane w wierszu dotyczą konkretnego obiektu (np. konkretnej firmy). Nie ma sytuacji, że część danych zależy od czegoś innego.
*   **3NF:** Usunąłem zależności przechodnie.
    *   *Mały wyjątek:* W tabeli `Acquisition` (Przejęcia) trzymam nazwę przejętej firmy ORAZ jej ID. Robię to celowo – czasem przejmowana firma nie istnieje w naszej bazie (nie ma ID), a musimy wiedzieć, jak się nazywała. To bezpieczniejsza opcja.

### Rozdział 3. Obiekty bazy danych i ich opis


#### A) Tabele
Baza danych składa się z kilkunastu tabel powiązanych relacjami. Poniżej opisuję najważniejsze z nich.

**1. Tabela `crunchbase.Company` (Firmy)**
To główna tabela w systemie, przechowująca podstawowe dane o firmach.
*   **Opis:** Zawiera nazwę, kategorię, daty założenia oraz dane kontaktowe.
*   **Klucz główny (PK):** `company_id` (INT, IDENTITY) – sztuczny identyfikator.
*   **Klucze obce (FK):** Brak (to tabela nadrzędna).
*   **Ograniczenia (Constraints):**
    *   `CHECK (founded_month BETWEEN 1 AND 12)` – walidacja miesiąca.
    *   `CHECK (number_of_employees >= 0)` – liczba pracowników nie może być ujemna.
    *   `DEFAULT GETDATE()` – dla pól `created_at` i `updated_at`.
    *   `UNIQUE` – na polu `permalink` oraz `mongo_id`.
*   **Uwagi do normalizacji:** Pole `tag_list` zawiera listę tagów oddzielonych przecinkami (odstępstwo od 1NF dla uproszczenia importu).

**2. Tabela `crunchbase.FundingRound` (Rundy finansowania)**
Przechowuje informacje o tym, kiedy i ile pieniędzy firma pozyskała.
*   **Opis:** Każdy rekord to jedna runda (np. seria A, B).
*   **Klucz główny (PK):** `funding_round_id`.
*   **Klucz obcy (FK):** `company_id` – powiązanie z tabelą `Company` (`ON DELETE CASCADE` – usunięcie firmy usuwa jej historię finansowania).
*   **Ograniczenia:**
    *   `CHECK (raised_amount >= 0)` – kwota nie może być ujemna.
    *   `DEFAULT 'USD'` – domyślna waluta.

**3. Tabela `crunchbase.Investment` (Inwestycje)**
Łączy rundę finansowania z inwestorem.
*   **Opis:** Tabela realizuje wspomniany w Rozdziale 2 mechanizm polimorfizmu.
*   **Klucz główny (PK):** `investment_id`.
*   **Klucze obce (FK):**
    *   `funding_round_id` – w co zainwestowano.
    *   `person_id` – jeśli inwestorem jest osoba.
    *   `financial_org_id` – jeśli inwestorem jest organizacja finansowa.
    *   `investing_company_id` – jeśli inwestorem jest inna firma.
*   **Uwagi:** W danym rekordzie wypełniony jest zazwyczaj tylko jeden z trzech kluczy inwestorów.

**4. Tabela `crunchbase.CompanyRelationship` (Relacje Osoba-Firma)**
Tabela łącznikowa dla relacji wiele-do-wielu.
*   **Opis:** Przechowuje historię zatrudnienia.
*   **Klucz główny (PK):** `relationship_id`.
*   **Klucze obce (FK):** `company_id` oraz `person_id`.
*   **Dodatkowe pola:** `title` (stanowisko), `is_past` (czy to była praca w przeszłości).

**5. Tabela `crunchbase.Acquisition` (Przejęcia)**
Informacje o zakupie jednej firmy przez drugą.
*   **Klucze obce (FK):**
    *   `acquiring_company_id` – firma kupująca.
    *   `acquired_company_id` – firma kupowana (może być NULL).
*   **Uwagi do normalizacji:** Przechowuję nazwę przejmowanej firmy (`acquired_company_name`) jako tekst, nawet jeśli mam do niej ID. To zabezpieczenie na wypadek, gdyby przejmowana firma nie istniała w naszej bazie jako osobny rekord (świadoma redundancja).

Pozostałe tabele słownikowe i pomocnicze to m.in.: `Person`, `FinancialOrg`, `Product`, `Office`, `Competitor`.


UWAGA ZAPISZ WSZYKIE TABELE:Jasne, poprawiłem **Rozdział 3**. Teraz zawiera pełną listę wszystkich 18 tabel z Twojego skryptu, ponumerowaną i opisaną zgodnie z wymaganiami (PK, FK, Constraints).

---

### Rozdział 3. Obiekty bazy danych i ich opis

#### A) Tabele

Baza danych składa się z 18 tabel. Poniżej znajduje się szczegółowy opis każdej z nich.

**1. Tabela `crunchbase.Company`**
*   **Opis:** Główna tabela przechowująca podstawowe informacje o firmach (startupach), takie jak nazwa, kategoria, opis, daty założenia i zamknięcia.
*   **Klucz główny (PK):** `company_id` (INT, IDENTITY).
*   **Klucze obce (FK):** Brak.
*   **Ograniczenia:**
    *   `UNIQUE` na kolumnach `mongo_id` oraz `permalink`.
    *   `CHECK` dla miesięcy (1-12) i dni (1-31).
    *   `CHECK (number_of_employees >= 0)`.
    *   `DEFAULT GETDATE()` dla dat utworzenia rekordu.
*   **Uwagi:** Pole `tag_list` jest przechowywane jako tekst (odstępstwo od 1NF dla uproszczenia).

**2. Tabela `crunchbase.Person`**
*   **Opis:** Słownik osób (pracowników, założycieli, inwestorów).
*   **Klucz główny (PK):** `person_id` (INT, IDENTITY).
*   **Klucze obce (FK):** Brak.
*   **Ograniczenia:** `UNIQUE` na kolumnie `permalink`.

**3. Tabela `crunchbase.FinancialOrg`**
*   **Opis:** Słownik organizacji finansowych (fundusze VC, banki).
*   **Klucz główny (PK):** `financial_org_id` (INT, IDENTITY).
*   **Klucze obce (FK):** Brak.
*   **Ograniczenia:** `UNIQUE` na kolumnie `permalink`.

**4. Tabela `crunchbase.Product`**
*   **Opis:** Produkty tworzone przez firmy.
*   **Klucz główny (PK):** `product_id` (INT, IDENTITY).
*   **Klucze obce (FK):** `company_id` (powiązanie z tabelą `Company`, `ON DELETE CASCADE`).

**5. Tabela `crunchbase.Office`**
*   **Opis:** Fizyczne lokalizacje biur firm.
*   **Klucz główny (PK):** `office_id` (INT, IDENTITY).
*   **Klucze obce (FK):** `company_id` (powiązanie z tabelą `Company`, `ON DELETE CASCADE`).

**6. Tabela `crunchbase.FundingRound`**
*   **Opis:** Rundy finansowania (np. Seria A, Seed), w których firma pozyskała kapitał.
*   **Klucz główny (PK):** `funding_round_id` (INT, IDENTITY).
*   **Klucze obce (FK):** `company_id` (powiązanie z tabelą `Company`, `ON DELETE CASCADE`).
*   **Ograniczenia:**
    *   `CHECK (raised_amount >= 0)`.
    *   `DEFAULT 'USD'` dla waluty.

**7. Tabela `crunchbase.Investment`**
*   **Opis:** Szczegóły inwestycji w ramach rundy. Łączy rundę z konkretnym inwestorem.
*   **Klucz główny (PK):** `investment_id` (INT, IDENTITY).
*   **Klucze obce (FK):**
    *   `funding_round_id` (do tabeli `FundingRound`).
    *   `person_id` (do tabeli `Person` – opcjonalny).
    *   `financial_org_id` (do tabeli `FinancialOrg` – opcjonalny).
    *   `investing_company_id` (do tabeli `Company` – opcjonalny).
*   **Uwagi:** Zastosowano tu strukturę polimorficzną – wypełniony jest tylko jeden z trzech kluczy inwestora.

**8. Tabela `crunchbase.Acquisition`**
*   **Opis:** Informacje o przejęciach (kto kogo kupił i za ile).
*   **Klucz główny (PK):** `acquisition_id` (INT, IDENTITY).
*   **Klucze obce (FK):**
    *   `acquiring_company_id` (Firma kupująca -> `Company`).
    *   `acquired_company_id` (Firma kupowana -> `Company`, opcjonalny).

**9. Tabela `crunchbase.Milestone`**
*   **Opis:** Ważne wydarzenia z życia firmy (kamienie milowe).
*   **Klucz główny (PK):** `milestone_id` (INT, IDENTITY).
*   **Klucze obce (FK):** `company_id` (powiązanie z tabelą `Company`, `ON DELETE CASCADE`).

**10. Tabela `crunchbase.Competitor`**
*   **Opis:** Relacja określająca konkurencję między firmami.
*   **Klucz główny (PK):** `competitor_id` (INT, IDENTITY).
*   **Klucze obce (FK):**
    *   `company_id` (Firma główna).
    *   `competitor_company_id` (Firma konkurencyjna).
*   **Ograniczenia:** `UNIQUE (company_id, competitor_permalink)` – zapobiega duplikatom par.

**11. Tabela `crunchbase.CompanyRelationship`**
*   **Opis:** Tabela łącznikowa dla relacji wiele-do-wielu między osobami a firmami (zatrudnienie).
*   **Klucz główny (PK):** `relationship_id` (INT, IDENTITY).
*   **Klucze obce (FK):**
    *   `company_id` (do `Company`).
    *   `person_id` (do `Person`).
*   **Uwagi:** Zawiera atrybuty relacji: `title` (stanowisko) i `is_past` (czy aktualne).

**12. Tabela `crunchbase.ExternalLink`**
*   **Opis:** Linki do artykułów i stron zewnętrznych o firmie.
*   **Klucz główny (PK):** `external_link_id` (INT, IDENTITY).
*   **Klucze obce (FK):** `company_id` (do `Company`, `ON DELETE CASCADE`).

**13. Tabela `crunchbase.Screenshot`**
*   **Opis:** Nagłówki dla zrzutów ekranu (metadane).
*   **Klucz główny (PK):** `screenshot_id` (INT, IDENTITY).
*   **Klucze obce (FK):** `company_id` (do `Company`, `ON DELETE CASCADE`).

**14. Tabela `crunchbase.ScreenshotSize`**
*   **Opis:** Konkretne pliki graficzne zrzutów ekranu w różnych rozmiarach.
*   **Klucz główny (PK):** `screenshot_size_id` (INT, IDENTITY).
*   **Klucze obce (FK):** `screenshot_id` (do tabeli `Screenshot`, `ON DELETE CASCADE`).

**15. Tabela `crunchbase.VideoEmbed`**
*   **Opis:** Kody do osadzania wideo (np. YouTube) promujących firmę.
*   **Klucz główny (PK):** `video_embed_id` (INT, IDENTITY).
*   **Klucze obce (FK):** `company_id` (do `Company`, `ON DELETE CASCADE`).

**16. Tabela `crunchbase.Provider`**
*   **Opis:** Dostawcy usług dla firmy (np. kancelarie prawne, PR).
*   **Klucz główny (PK):** `provider_id` (INT, IDENTITY).
*   **Klucze obce (FK):**
    *   `company_id` (Klient).
    *   `provider_company_id` (Dostawca – inna firma).

**17. Tabela `crunchbase.CompanyImage`**
*   **Opis:** Logotypy i obrazy reprezentujące firmę.
*   **Klucz główny (PK):** `image_id` (INT, IDENTITY).
*   **Klucze obce (FK):** `company_id` (do `Company`, `ON DELETE CASCADE`).

**18. Tabela `crunchbase.CompanyIPO`**
*   **Opis:** Informacje o wejściu firmy na giełdę.
*   **Klucz główny (PK):** `ipo_id` (INT, IDENTITY).
*   **Klucze obce (FK):** `company_id` (do `Company`, `ON DELETE CASCADE`).
*   **Ograniczenia:** `UNIQUE` na kolumnie `company_id` – relacja 1:1 (firma może mieć tylko jeden wpis o debiucie giełdowym w tym modelu).



#### B) Indeksy
Poza automatycznymi indeksami dla kluczy głównych (PK) i unikalnych (UNIQUE), utworzyłem dodatkowe indeksy w celu przyspieszenia najczęstszych zapytań:

1.  `IX_Company_Name` na kolumnie `name` w tabeli `Company`.
    *   **Uzasadnienie:** Użytkownicy najczęściej wyszukują firmy po nazwie.
2.  `IX_Company_CategoryCode` na kolumnie `category_code`.
    *   **Uzasadnienie:** Pozwala na szybkie filtrowanie firm po branży (np. 'web', 'mobile').
3.  `IX_FundingRound_RoundCode` na kolumnie `round_code`.
    *   **Uzasadnienie:** Przyspiesza raportowanie sum finansowania dla konkretnych typów rund (np. tylko 'angel' lub 'series-a').

#### C) Triggery
W projekcie nie zastosowałem wyzwalaczy (triggers). Logika biznesowa (np. sprawdzanie czy firma istnieje przed dodaniem) została zaimplementowana w procedurach składowanych oraz w warstwie aplikacji importującej. Unikanie triggerów zwiększa przejrzystość przepływu danych podczas masowego importu JSON.

#### D) Procedury składowane
Utworzyłem procedurę `crunchbase.UpsertCompany`.

*   **Opis działania:** Procedura realizuje logikę "Insert or Update". Przyjmuje dane firmy i sprawdza po `mongo_id`, czy taka firma już istnieje.
    *   Jeśli istnieje: Aktualizuje jej dane (nazwę, pracowników, rok założenia).
    *   Jeśli nie istnieje: Tworzy nowy rekord.
*   **Zastosowanie:** Jest kluczowa przy cyklicznym imporcie danych, aby nie tworzyć duplikatów i aktualizować informacje o istniejących firmach.

#### E) Funkcje użytkownika
Zaimplementowałem funkcję skalarną `crunchbase.GetTotalFunding(@company_id)`.

*   **Opis działania:** Funkcja przyjmuje ID firmy, przeszukuje tabelę `FundingRound`, sumuje wszystkie kwoty (`raised_amount`) dla tej firmy i zwraca wynik w postaci liczby.
*   **Zastosowanie:** Upraszcza zapytania analityczne. Zamiast pisać za każdym razem `JOIN` i `SUM`, wystarczy wywołać tę funkcję w liście `SELECT`.

#### F) Widoki
Stworzyłem widok `crunchbase.vw_CompanyOverview`.

*   **Opis działania:** Widok łączy dane z tabeli `Company` z wynikami funkcji agregujących. Pokazuje nazwę firmy, kategorię, liczbę pracowników oraz wyliczoną sumę finansowania i liczbę produktów.
*   **Zastosowanie:**
    1.  Upraszcza dostęp do danych dla użytkowników nietechnicznych.
    2.  Służy jako warstwa bezpieczeństwa dla użytkownika `Guest`, który ma dostęp tylko do tego widoku, a nie do surowych tabel.


### Rozdział 4. Role, uprawnienia i użytkownicy

#### 4.1. Konfiguracja bezpieczeństwa (Contained Database)
W projekcie zastosowałem model **Contained Database Users** (użytkowników zawartych w bazie).
Wymagało to włączenia odpowiedniej opcji na poziomie serwera (`contained database authentication`) oraz ustawienia parametru `CONTAINMENT = PARTIAL` dla bazy `CompanyDB`.

**Dlaczego to rozwiązanie?**
Dzięki temu użytkownicy są definiowani bezpośrednio wewnątrz pliku bazy danych (`.mdf`), a nie na poziomie instancji serwera SQL (w `master`). To sprawia, że baza jest przenośna – mogę wysłać plik `.bak` lub wygenerowany skrypt na inny komputer i użytkownicy od razu tam będą, bez konieczności ponownego zakładania loginów na serwerze.

#### 4.2. Utworzone role i uprawnienia
Zdefiniowałem trzy role, które odzwierciedlają typowe poziomy dostępu w firmie:

1.  **Rola `AdminRole`**
    *   **Uprawnienia:** Pełne (`db_owner`).
    *   **Cel:** Zarządzanie strukturą bazy, tworzenie tabel, import danych.

2.  **Rola `EmpRole` (Pracownik)**
    *   **Uprawnienia:** `GRANT EXECUTE ON SCHEMA::crunchbase`.
    *   **Cel:** Pracownik może wykonywać procedury składowane (np. dodawać firmy przez `UpsertCompany`), ale nie ma bezpośredniego dostępu do tabel (`SELECT`, `DELETE`). To zwiększa bezpieczeństwo – pracownik może robić tylko to, na co pozwala procedura.

3.  **Rola `GuestRole` (Gość)**
    *   **Uprawnienia:** `GRANT SELECT ON crunchbase.vw_CompanyOverview`.
    *   **Cel:** Gość ma dostęp tylko do odczytu i tylko do jednego widoku. Nie widzi szczegółowych danych finansowych ani tabel źródłowych.

#### 4.3. Użytkownicy
Dla każdej roli utworzyłem dedykowanego użytkownika z hasłem (przechowywanym w bazie):

*   Użytkownik **Admin** (przypisany do `AdminRole`).
*   Użytkownik **Emp** (przypisany do `EmpRole`).
*   Użytkownik **Guest** (przypisany do `GuestRole`).

---

### Rozdział 5. Uwagi końcowe

#### 5.1. Napotkane problemy
Podczas realizacji projektu największym wyzwaniem była struktura danych wejściowych JSON:

1.  **Zagnieżdżenie danych:** Dane o inwestycjach były głęboko zagnieżdżone wewnątrz rund finansowania. Wymagało to użycia wielokrotnego `CROSS APPLY` w zapytaniu importującym, aby "spłaszczyć" strukturę do postaci relacyjnej.
2.  **Niejednorodność typów:** W plikach JSON zdarzało się, że to samo pole raz było liczbą, a raz tekstem (np. `zip_code`). Musiałem użyć funkcji `TRY_CAST`, aby uniknąć błędów podczas importu – jeśli konwersja się nie uda, wstawiany jest `NULL` zamiast przerywania całego procesu.
3.  **Polimorfizm inwestorów:** Problem opisany w Rozdziale 2 (różne typy inwestorów w jednej liście) wymagał dłuższego zastanowienia nad projektem tabeli `Investment`, aby zrobić to zgodnie ze sztuką, a nie "na skróty".

#### 5.2. Elementy do dalszego rozwoju
Projekt spełnia wszystkie wymagania zaliczeniowe, ale w przyszłości można by go rozwinąć o:

*   **Normalizację tagów:** Obecnie tagi są listą po przecinku. W wersji 2.0 można by stworzyć tabelę `Tags` i `CompanyTags`, co pozwoliłoby na wydajne wyszukiwanie firm po konkretnych tagach.
*   **Obsługę walut:** Obecnie system zakłada, że kwoty są w USD (lub ignoruje walutę). Warto byłoby dodać tabelę z kursami walut i przeliczać wszystkie inwestycje na jedną walutę bazową do celów statystycznych.
*   **Automatyzację importu:** Obecnie import uruchamia się ręcznie skryptem SQL. Można by to zautomatyzować za pomocą narzędzia SSIS (SQL Server Integration Services).
