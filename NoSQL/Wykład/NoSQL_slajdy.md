## Slajd 001 — Bazy New/NoSQL

Bazy New/NoSQL

## Slajd 002 — Właściwości Big Data

Cztery kluczowe cechy, które wyróżniają dane w erze Big Data

### V Volume (Objętość)
- Ilość danych wzrasta potęgowo a nie liniowo.
- Duża ilość małych zbiorów danych też może być klasyfikowana jako Big Data.

> [Grafika] Wykres słupkowy rosnących niebieskich słupków ze strzałką w górę; podpis: „Wzrost ilości danych”.

### V Variety (Różnorodność)
- Dane posiadają różnorodną strukturę i format (XML, JSON, nieustrukturalizowane multimedia).

> [Grafika] Rząd ikon z podpisami: XML, JSON, Obrazy, Wideo, Tekst, Audio.

### V Velocity (Szybkość przetwarzania)
- Dane napływają bardzo szybko i z taką samą szybkością muszą być przetwarzane (np. strumieniowo).

> [Grafika] Przepływ ze strzałkami: „Strumień danych” (ciąg 010101 110010 001101) → „Szybkie przetwarzanie” (zębatka) → „Reakcja w czasie rzeczywistym” (stoper).

### V Veracity (Niepewność)
- Powstaje ze względu na braki, niespójność, czy wprowadzenie aproksymacji – zatem też należy znaleźć podejścia, które sobie z tym radzą.

> [Grafika] Cztery ikony baz danych/lupy z podpisami: Braki danych, Niespójność, Niepewność, Metody radzenia sobie.

> [Grafika] W środku slajdu okrągły granatowy element z ikoną bazy danych i napisem „Big Data”, łączący cztery sekcje V.

**Big Data = Volume + Variety + Velocity + Veracity**
Większe możliwości, lepsze decyzje, nowe wyzwania.

## Slajd 003 — Big Data

Najważniejsze aspekty przy projektowaniu i wykorzystaniu dużych systemów baz danych

### 1 Skalowalność
System powinien umożliwiać łatwe zwiększanie zasobów (więcej danych, użytkowników, węzłów).

> [Grafika] Rosnące stosy baz danych ze strzałką w górę. Podpis: „Rosnące potrzeby = możliwość skalowania”

### 2 Koszt
Wielkie systemy baz danych muszą być projektowane i utrzymywane w sposób efektywny kosztowo (np. wykorzystanie rozwiązań open source, chmury, architektury rozproszonej).

> [Grafika] Baza danych i moneta z symbolem dolara ze strzałką w dół. Podpis: „Większa efektywność = niższe koszty”

### 3 Elastyczność
System powinien szybko dostosowywać się do zmieniających się wymagań biznesowych, typów danych i obciążeń.

> [Grafika] Zębatka otoczona strzałkami cyklu. Podpis: „Szybka adaptacja do zmian”

### 4 Dostępność
Dane powinny być dostępne w sposób niezawodny, z wysoką dostępnością i odpornością na awarie (np. replikacja, klastry, rozproszone systemy plików).

> [Grafika] Serwer z zielonym znacznikiem potwierdzenia. Podpis: „Dane zawsze dostępne”

### Rola baz NoSQL
Bazy NoSQL mogą bardzo pomóc w racjonalizacji powyższych elementów, ponieważ oferują:
- lepszą skalowalność (architektury rozproszone),
- niższe koszty (brak sztywnych schematów),
- większą elastyczność (różnorodne modele danych),
- wysoką dostępność (replikacja i partycjonowanie).

### Nie tylko bazy relacyjne
> [Grafika] Przekreślona ikona bazy danych → strzałka → baza z napisem „NoSQL”.

Nie należy bezrefleksyjnie odchodzić od baz relacyjnych, zastępując je całkowicie bazami nierelacyjnymi.
Wybór technologii powinien być uzależniony od charakteru danych, wymagań aplikacji i konkretnego zadania.

### Wiedza i właściwy dobór
> [Grafika] Postać z laptopem i ikona listy kontrolnej.

Projektanci i programiści baz danych MUSZĄ znać zarówno bazy relacyjne, jak i NoSQL, aby umieć ocenić, który model jest bardziej odpowiedni do danego zadania.

**Big Data = odpowiednie technologie + świadome decyzje + dopasowanie do potrzeb**

## Slajd 004 — Bazy relacyjne

Model, język zapytań, możliwości i przykłady

> Bazy relacyjne to systemy zarządzania bazami danych, które przechowują dane w postaci tabel i wykorzystują model relacyjny oraz język SQL.

### 1 Model danych
Dane są zorganizowane w strukturze hierarchicznej:

`Instancja → baza → tabela → wiersz`

> [Grafika] Ikony z podpisami i strzałkami: Instancja (serwer) → Baza (cylinder) → Tabela → Wiersz.

### 2 Język zapytań
- Rzeczywisty: **SQL** (_Structured Query Language_)
- Formalny: **Algebra relacyjna**

```sql
SELECT imie, nazwisko
FROM klienci
WHERE miasto = 'Warszawa';
```

### 3 Możliwości zapytań
- **Selekcja** – wybór danych wg określonych kryteriów.
- **Złączenia** – łączenie danych z wielu tabel.
- **Agregacja** – obliczenia zbiorcze (np. SUM, COUNT, AVG).
- **Podzapytania** – zagnieżdżone zapytania.
- **Inne operacje** – sortowanie, grupowanie, filtrowanie, modyfikacja danych (INSERT, UPDATE, DELETE).

### 4 Przykłady systemów
**Komercyjne** (systemy klasy enterprise): Oracle Database, SQL Server, IBM DB2
**Otwarte i popularne**: MySQL, PostgreSQL, MariaDB

> [Grafika] Logotypy: ORACLE (Oracle Database), SQL Server, IBM (IBM DB2), MySQL, PostgreSQL (słoń), MariaDB (foka).

### 5 Przykład działania zapytania
Tabela: klienci

| id | imie | nazwisko | miasto |
|---|---|---|---|
| 1 | Jan | Kowalski | Warszawa |
| 2 | Anna | Nowak | Kraków |
| 3 | Piotr | Wiśniewski | Warszawa |
| 4 | Ewa | Wójcik | Gdańsk |

```sql
SELECT imie, nazwisko
FROM klienci
WHERE miasto = 'Warszawa';
```

Wynik zapytania

| imie | nazwisko |
|---|---|
| Jan | Kowalski |
| Piotr | Wiśniewski |

> [Grafika] Strzałka od tabeli „klienci” do tabeli wyniku.

### Zalety baz relacyjnych
- spójność i integralność danych
- dojrzałe i stabilne technologie
- bogate możliwości zapytań
- szerokie wsparcie i społeczność

Bazy relacyjne pozostają fundamentem wielu systemów informacyjnych, zarówno w biznesie, jak i w administracji.

## Slajd 005 — Obecnie

Duże dane charakteryzują się ogromną objętością, różnorodnością i wysoką szybkością powstawania, co stawia nowe wymagania przed systemami przechowywania i przetwarzania danych.

### Objętość (duże dane)
- Terabajty → zetabajty.
- Dynamiczny, ciągły wzrost ilości danych.
- Tradycyjne metody przechowywania stają się niewystarczające.

> [Grafika] Wykres słupkowy rosnący ze strzałką; oś: TB → PB → EB → ZB.

### Różnorodność danych
- Dane strukturalne (bazy danych, tabele).
- Dane niestrukturalne (teksty, obrazy, wideo, audio).
- Dane półstrukturalne (np. XML, JSON).
- Łączenie danych z wielu źródeł i formatów.

> [Grafika] Ikony z podpisami: Strukturalne, Tekst, Obrazy, Wideo, Audio, Półstrukturalne (XML, JSON).

### Szybkość powstawania i przetwarzania
- Przetwarzanie wsadowe → przetwarzanie strumieniowe (w czasie rzeczywistym).
- Dane generowane nieustannie (np. czujniki, media społecznościowe, transakcje, logi).
- Wymóg szybkiej analizy i podejmowania decyzji.

> [Grafika] Ikona prędkościomierza; podpis: „Dane w czasie rzeczywistym”.

> [Grafika] Ciemna grafika ze strumieniem cyfr 0 i 1 oraz rosnącą strzałką wykresu. Napisy: „Coraz więcej danych, coraz większe możliwości” oraz „„Dane to nowa ropa naftowa, ale ich wartość zależy od możliwości ich przetwarzania.””

### Wniosek
Obecnie duże dane wymagają nowoczesnych technologii i podejść (np. Big Data, systemy rozproszone), które pozwalają skutecznie przechowywać, przetwarzać i analizować dane o ogromnej objętości, różnorodności i w wysokim tempie.

## Slajd 006 — Nowe podejście do Big Data

Rosnące ilości, różnorodność i szybkość danych wymagają nowoczesnych technologii.

### Tradycyjne bazy relacyjne nie wystarczają
- Problemy ze skalowaniem dla ogromnych zbiorów danych
- Ograniczona obsługa danych nieustrukturalizowanych
- Wysokie koszty przy dużych wolumenach
- Nieefektywne dla przetwarzania w czasie rzeczywistym

**Współczesne wyzwania wymagają nowego podejścia!**

> [Grafika] Ikona bazy danych z czerwonym znakiem ostrzegawczym; czerwone ikony X przy punktach; duża strzałka z napisem „Rozwiązania dla Big Data” prowadząca do sześciu kafelków.

### Rozproszone systemy plików
- Przechowywanie ogromnych ilości danych na wielu węzłach
- Wysoka niezawodność i odporność na awarie
- Przykład: HDFS

### MapReduce
- Równoległe przetwarzanie danych w klastrach
- Dzielenie problemu na mniejsze zadania (map) i łączenie wyników (reduce)
- Skalowalność dla dużych zbiorów danych

### Przetwarzanie w chmurze
- Elastyczne zasoby (IaaS, PaaS, SaaS)
- Skalowalność i niższe koszty
- Dostęp do potężnej infrastruktury obliczeniowej
- Przykłady: AWS, Microsoft Azure, Google Cloud

### Bazy NoSQL
- Elastyczne modele danych (dokumentowe, klucz–wartość, kolumnowe, grafowe)
- Wysoka wydajność i skalowalność
- Dobre dopasowanie do danych nieustrukturalizowanych
- Przykłady: MongoDB, Cassandra, Hadoop, Redis

### Hurtownie danych
- Integracja i analiza dużych zbiorów danych
- Wsparcie dla analityki biznesowej (OLAP)
- Umożliwiają podejmowanie lepszych decyzji
- Przykłady: Amazon Redshift, Google BigQuery, Snowflake

### Uczenie maszynowe na dużą skalę
- Analiza danych strumieniowych i historycznych
- Wykrywanie wzorców i predykcje
- Zastosowania: rekomendacje, detekcja anomalii, analiza sentymentu
- Przykłady: TensorFlow, Spark MLlib

### Dlaczego bazy NoSQL są interesujące?
**1 Produktywność tworzenia aplikacji**
Bazy NoSQL oferują modele danych lepiej dopasowane do potrzeb aplikacji, co upraszcza interakcję z danymi i zmniejsza ilość potrzebnego kodu. Ułatwia to mapowanie danych między strukturami przechowywanymi w pamięci programu a bazą danych.

**2 Duże wolumeny danych**
Organizacje przechowują coraz więcej danych, które wymagają szybkiego przetwarzania. Tradycyjne bazy relacyjne są kosztowne i nieefektywne w takiej skali. Bazy NoSQL są projektowane do pracy w klastrach, umożliwiają uruchomienie na wielu mniejszych i tańszych maszynach, co czyni je lepszym rozwiązaniem dla dużych zbiorów danych.

### Wniosek
Nowoczesne rozwiązania (NoSQL, chmura, rozproszone systemy, analityka i uczenie maszynowe) stanowią odpowiedź na wyzwania Big Data i pozwalają skutecznie przetwarzać, analizować i wykorzystywać dane w praktyce.
„Dane to nie tylko liczby – to nowe możliwości.”

## Slajd 007 — Dlaczego bazy NoSQL są interesujące?

Dwa główne powody, dla których coraz więcej organizacji wybiera bazy NoSQL

### 1 Produktywność tworzenia aplikacji
Bazy NoSQL lepiej odpowiadają na potrzeby nowoczesnych aplikacji, co pozwala szybciej tworzyć, rozwijać i utrzymywać rozwiązania.

- **Elastyczny model danych** – Łatwiejsze mapowanie danych do struktury aplikacji.
- **Prostsza integracja** – Mniej złożonych schematów, szybsze zmiany.
- **Mniejsza ilość kodu** – Uproszczona interakcja z danymi.
- **Różne typy danych** – Obsługa danych strukturalnych, półstrukturalnych i nieustrukturalnych.

**Przykład**
> [Grafika] Diagram: „Aplikacja internetowa” (okno z ikoną </>) połączona przerywanymi liniami z trzema elementami: Dane użytkowników (dokument), Obrazy, Dane logów (plik JSON).

Ramka: NoSQL pozwala skupić się na logice biznesowej, a nie na złożonym modelowaniu danych.

### 2 Duże wolumeny danych
Organizacje przechowują coraz więcej danych, które wymagają szybkiego i skalowalnego przetwarzania.

- **Skalowalność** – Łatwe uruchamianie wielu mniejszych maszyn (klastry).
- **Lepsza wydajność** – Przetwarzanie dużych zbiorów danych w krótszym czasie.
- **Niższe koszty** – Rozproszone rozwiązania są bardziej ekonomiczne niż duże, pojedyncze maszyny.
- **Rozproszone architektury** – Projektowane do pracy w klastrach, co ułatwia obsługę ogromnych zbiorów danych.

**Wzrost ilości danych**
> [Grafika] Wykres: oś pionowa „Ilość danych”, oś pozioma „Czas”. Legenda: linia przerywana „Wzrost liniowy (tradycyjne systemy)”, linia ciągła „Wzrost wykładniczy (Big Data)”; krzywa wykładnicza gwałtownie rośnie, linia liniowa płaska.

Ramka: Bazy NoSQL są naturalnym wyborem w środowiskach Big Data, gdzie ilość danych rośnie w tempie wykładniczym.

### Podsumowanie
Bazy NoSQL są interesujące, ponieważ zwiększają produktywność tworzenia aplikacji oraz umożliwiają efektywną obsługę dużych wolumenów danych. Dzięki elastycznym modelom danych, rozproszonej architekturze i lepszej skalowalności stanowią kluczowy element nowoczesnych rozwiązań w erze Big Data.

## Slajd 008 — Obecnie – wszystko jest w chmurze

### Obecnie – wszystko jest w chmurze
- **SaaS** – Software as a Service. Gotowe aplikacje dostępne przez Internet np. Google Workspace, Salesforce
- **PaaS** – Platform as a Service. Platforma do tworzenia i uruchamiania aplikacji np. Microsoft Azure, Heroku
- **IaaS** – Infrastructure as a Service. Infrastruktura (serwery, sieci, storage) np. AWS, Google Cloud, Microsoft Azure

> [Grafika] Chmura z napisem „CLOUD”, połączona przerywanymi liniami z trzema elementami: Urządzenia użytkowników (laptop), Serwery i infrastruktura (serwer), Dane (baza danych).

### Przetwarzanie danych
- **OLTP – Online Transaction Processing**
  - Obsługa bieżących transakcji
  - Szybkie operacje zapisu i odczytu
  - Przykład: systemy bankowe, sklepy internetowe
- **OLAP – Online Analytical Processing**
  - Analiza danych historycznych
  - Złożone zapytania i agregacje
  - Wspiera podejmowanie decyzji
- **RTAP – Real-Time Analytical Processing**
  - Analiza danych w czasie rzeczywistym
  - Natychmiastowe wyniki
  - Przykład: monitoring, rekomendacje, IoT

### SQL – bazy relacyjne (RDBMS)
- Dominują od wielu lat
- Zapewniają spójność i kontrolę współbieżności
- Wykorzystują sztywny schemat danych
- Dobrze sprawdzają się w transakcjach (OLTP)
- Integracja często przez bazy danych

> [Grafika] Trzy powiązane tabele. Klienci: ID, Imię, Email — (1, Anna, a@..), (2, Piotr, p@..). Zamówienia: ID, KlientID, Data — (101, 1, 2024-01-10), (102, 2, 2024-01-12). Produkty: ID, Nazwa, Cena — (1, Laptop, 3500), (2, Telefon, 2000). Przerywane linie łączą Klienci z Zamówienia, a Zamówienia z Produkty.

### NoSQL – elastyczne przechowywanie danych
- Brak sztywnego schematu danych
- Dobrze działają w klastrach
- Stworzone głównie na potrzeby aplikacji webowych XXI w.
- Obsługują dane strukturalne i niestrukturalne
- Zapewniają dużą skalowalność
- Otwarty kod, szerokie zastosowanie

> [Grafika] Cztery modele: **Key-Value** (user:1 → {...}, user:2 → {...}, user:3 → {...}); **Document** (stos dokumentów: { "name": "Anna", "age": 25, "city": "Kraków" }); **Column store** (tabela: ID, Imię, Email, Miasto — 1, Anna, a@.., Kraków; 2, Piotr, p@.., Warszawa; ...); **Graph** (węzły połączone krawędziami).

### Popularne bazy NoSQL
- **MongoDB** – Baza dokumentowa (JSON, BSON)
- **Cassandra** – Baza kolumnowa (wysoka skalowalność)
- **Redis** – Baza klucz–wartość (cache, real-time)
- **CouchDB** – Baza dokumentowa (replikacja, offline)
- **HBase** – Baza kolumnowa (Hadoop ecosystem)
- **Neo4j** – Baza grafowa (relacje między danymi)

> [Grafika] Logotypy: MongoDB (liść), Cassandra (oko), Redis (czerwony stos), CouchDB (czerwona kanapa), Apache HBase, Neo4j (graf).

**Analiza i koordynacja danych = wiedza biznesowa i lepsze decyzje**

## Slajd 009 — Obecnie

Jak zmieniają się dane?

- **Format danych** może być nieznany lub pozbawiony sztywnej struktury — np. tekst, zdjęcia, wideo, dane z czujników
- Zamiast przyrostu liniowego → **przyrost potęgowy** — Liczba danych rośnie lawinowo (Big Data)
- **Operacje odczytu** stają się ważniejsze i częstsze niż **operacje zapisu** — Wielu użytkowników korzysta z danych równocześnie
- **Aktualizacje danych nie są tak częste** i w przewidywalnych przedziałach czasowych jak dawniej — Dane mogą być zmieniane nieregularnie i w sposób rozproszony
- Dane mogą zostać **szybko zastąpione** — Przykład: nowe wersje profili, aktualne położenie, strumienie danych z czujników
- Ścisła **spójność danych** coraz częściej ustępuje potrzebie dużej szybkości działania — Akceptuje się spójność ostateczną (eventual consistency) w zamian za wydajność i skalowalność

### Przykładowe źródła danych
> [Grafika] Pięć kafelków: Media społecznościowe (logotypy Facebook, Twitter, Instagram; posty, komentarze, reakcje); Urządzenia mobilne (lokalizacja, aplikacje); Czujniki IoT (temperatura, ruch, logi); Dane tekstowe (e-maile, dokumenty); Zdjęcia i wideo (multimedia).

> [Grafika] Strzałki ze źródeł danych do chmury z serwerem: „Dane (różnorodne, w dużej skali)”. Z chmury strzałka w prawo do monitora z wykresami: „Analiza i koordynacja danych — Wiedza biznesowa i lepsze decyzje”. Z chmury trzy strzałki w dół do kafelków:
- **Wydajność** — Szybkie przetwarzanie dużych wolumenów danych
- **Skalowalność** — Łatwe rozszerzanie infrastruktury w miarę wzrostu danych
- **Nowe możliwości** — Innowacyjne usługi, personalizacja, analiza w czasie rzeczywistym

**Dane zmieniają się szybciej niż kiedykolwiek.**
Nowe wyzwania wymagają nowych podejść – elastycznych, skalowalnych i dostosowanych do realnych potrzeb.

## Slajd 010 — Dlaczego NoSQL?

Nowe dane. Większe możliwości. Lepsze decyzje.

- Coraz łatwiejszy **dostęp i przechowywanie danych witryn internetowych** (Facebook, Twitter, inne).
- **Dostępne dane:** użytkownicy, lokalizacja, sieci społeczne, logi maszynowe, treści tworzone przez użytkowników.
- Tradycyjne SQL nie były projektowane do obsługi **takiej skali** („Big Data”).
- **NoSQL:** obsługa danych strukturalnych i niestrukturalnych, szybkie przetwarzanie.
- Firmy jak **Google, Facebook, LinkedIn, Twitter** używają NoSQL do terabajtów danych dziennie.
- Analiza i koordynacja danych = **wiedza biznesowa i decyzje strategiczne.**

### Źródła danych
> [Grafika] Ikony z podpisami: Facebook, Twitter (X), LinkedIn, Strony www, Aplikacje mobilne, Logi maszynowe.

> [Grafika] Centralna chmura z bazą danych i napisem „NoSQL — Skalowalne przechowywanie i szybkie przetwarzanie”. Strzałki w stronę chmury od: Dane tekstowe (posty, komentarze), Zdjęcia i multimedia, Lokalizacja (GPS), Dane użytkowników (profile, interakcje), Logi maszynowe i zdarzenia, Treści tworzone przez użytkowników.

### Efekty i zastosowania
- Analiza danych w czasie rzeczywistym
- Lepsze decyzje biznesowe
- Personalizacja usług
- Rozwój produktów i innowacje

**Dane napędzają biznes – NoSQL pozwala wykorzystać ich pełny potencjał.**

## Slajd 011 — Bazy NoSQL

Elastyczne podejście do przechowywania danych

### Co oznacza termin NoSQL?
- **1998** — Pokazano relacyjną bazę danych nie wykorzystującą języka SQL.
- **2009** — Pokazano na konferencji bazę NoSQL mającą wspierać bazy relacyjne.

### Termin NoSQL to:
- NIE: _no to SQL_
- NoSQL nie ma precyzyjnej definicji.
- Określenie obejmuje różne typy baz danych niż relacyjne, zaprojektowane z myślą o skalowalności, elastyczności i dużych wolumenach danych.

### Przykłady baz NoSQL:
> [Grafika] Logotypy z podpisami: MongoDB (baza dokumentowa), Redis (baza klucz-wartość), Cassandra (baza kolumnowa), Elasticsearch (baza wyszukiwawcza).

Ramka: **Not only SQL?** — NoSQL to nie tylko alternatywa, ale uzupełnienie klasycznych baz relacyjnych.

**Różne dane. Różne potrzeby. NoSQL.**

## Slajd 012 — Pojawienie się baz NoSQL

Historia, kontekst i najważniejsze fakty

Ramka: **NoSQL** — Nowe podejście do przechowywania i przetwarzania danych.

### Oś czasu
- **Lata 90.** — Termin „NoSQL” pojawił się przy bazie Strozzi (bez wpływu na późniejsze NoSQL).
- **1998** — Rozwój nierelacyjnych baz danych, rosnące zainteresowanie alternatywami dla SQL.
- **11 czerwca 2009** — W San Francisco odbyło się spotkanie, na którym po raz pierwszy użyto terminu NoSQL – z inicjatywy Johana Oskarssona.
- **Po 2009** — Termin stał się popularny, choć nie opisuje dokładnie wszystkich nierelacyjnych baz danych.

### Najważniejsze informacje
- Termin „NoSQL” pojawił się w latach 90. przy bazie **Strozzi** (bez wpływu na późniejsze NoSQL).
- Współczesne **NoSQL** zaczęło się **11 czerwca 2009 r.** w San Francisco, z inicjatywy **Johana Oskarssona**.
- Spotkanie miało na celu prezentację nowych nierelacyjnych baz danych (**Voldemort, Cassandra, Dynomite, HBase, Hypertable, CouchDB, MongoDB**).
- Nazwa „NoSQL” wybrana jako dobry **hashtag na Twitterze** (sugestia z IRC #cassandra, zatwierdzona przez **Erica Evansa**).
- Termin stał się popularny, choć nie opisuje dokładnie wszystkich nierelacyjnych baz danych.

Ramka: **Cel spotkania** — Prezentacja i dyskusja o nowych nierelacyjnych bazach danych, zaprojektowanych z myślą o skalowalności, elastyczności i dużych wolumenach danych.

### Przykłady baz NoSQL
> [Grafika] Logotypy z podpisami: MongoDB (baza dokumentowa), Cassandra (baza kolumnowa), Redis (baza klucz-wartość), HBase (baza kolumnowa), CouchDB (baza dokumentowa), DynamoDB (baza klucz-wartość), Hypertable (baza kolumnowa), Voldemort (baza klucz-wartość).

## Slajd 013 — Bazy NoSQL

Nowoczesne podejście do przechowywania danych

Ramka: **NoSQL** — Różne modele danych. Większe możliwości. Nowe zastosowania.

### NoSQL – czym jest i dlaczego używać?
- Tworzone głównie na potrzeby aplikacji **webowych XXI w.**
- Termin **„NoSQL”** nie odnosi się do negacji SQL, a do zbioru nowoczesnych, najczęściej **open source** baz danych.
- **NoSQL** to raczej **ruch niż konkretna technologia.**

### Główne zalety
1. Obsługa danych wymagających klastrów.
2. Większa produktywność i elastyczność w tworzeniu aplikacji dzięki prostszemu modelowi danych.

### Gdzie sprawdzają się bazy NoSQL?
> [Grafika] Trzy ikony z podpisami: Aplikacje webowe i mobilne; Duże wolumeny danych; Systemy rozproszone.

### Przykłady baz NoSQL
> [Grafika] Logotypy z podpisami: MongoDB (baza dokumentowa), Redis (baza klucz-wartość), Cassandra (baza kolumnowa), CouchDB (baza dokumentowa).

**NoSQL to większa elastyczność, skalowalność i swoboda w projektowaniu aplikacji.**
Idealne rozwiązanie dla wyzwań współczesnych systemów.

## Slajd 014 — Bazy NoSQL – najważniejsze kwestie

Elastyczne rozwiązania dla dużych danych i nowoczesnych aplikacji

### Bazy relacyjne
- Dominują od wielu lat.
- Zapewniają spójność i kontrolę współbieżności.
- Trudności przy dopasowaniu do struktur danych w pamięci – tzw. _impedancja obiektowo-relacyjna_ (różnica między strukturą obiektów w aplikacji a tabelami w bazie relacyjnej).
- Integracja często przez bazy danych.

Ramka: Świetnie sprawdzają się w systemach, gdzie kluczowa jest spójność danych i złożone relacje.

### Zmiany w podejściu
- Przejście od integracji baz do enkapsulacji w aplikacjach.
- Integracja przez usługi sieciowe (np. API).
- Konieczność obsługi dużych wolumenów danych w klastrach.
- Bazy relacyjne nie są optymalne w klastrach.

Ramka: Rosnące wymagania aplikacji (wydajność, skalowalność, elastyczność) przyczyniły się do popularyzacji baz NoSQL.

### Bazy NoSQL
- Brak modelu relacyjnego.
- Dobrze działają w klastrach.
- Otwarty kod, projektowane dla aplikacji webowych XXI w.
- Brak sztywnego schematu danych (_schema-less_).
- Umożliwiają dobór sposobu przechowywania danych według ich specyfiki.

Ramka: NoSQL to nie tylko alternatywa, ale odpowiedź na potrzeby nowoczesnych, skalowalnych aplikacji.

### Krótka historia terminu NoSQL
- **1998** — Pokazano relacyjną bazę danych nie wykorzystującą języka SQL.
- **2009** — Pokazano na konferencji bazę NoSQL mającą wspierać bazy relacyjne.

Ramka: Termin NoSQL to: NIE: no to SQL. NoSQL nie ma precyzyjnej definicji.

### Przykłady popularnych baz NoSQL
> [Grafika] Logotypy z podpisami: MongoDB (baza dokumentowa — Elastyczny model danych (JSON)); Redis (baza klucz-wartość — Wysoka wydajność i niski czas odpowiedzi); Cassandra (baza kolumnowa — Skalowalna, odporna na awarie); Elasticsearch (baza wyszukiwawcza — Potężne możliwości wyszukiwania i analizy danych).

**Różne dane. Różne potrzeby. NoSQL.**

## Slajd 015 — (bez tytułu) SQL vs NoSQL

> [Grafika] Schemat dwóch paneli. Lewy panel „SQL”: „Relational Database Management Systems (RDBMS)” — sześć powiązanych tabel (relacje między tabelami oznaczone liniami z końcówkami „kurzej stopki”) oraz „Online Analytical Processing (OLAP) Cube” — sześcian wielowymiarowy. Prawy panel „NoSQL” z czterema modelami: „Key-Value” (tabela klucz–wartość), „Graph” (węzły połączone krawędziami), „Document” (pliki-dokumenty powiązane z kluczami), „Column store” (tabele kolumnowe).

## Slajd 016 — Bazy NoSQL

Co zatem oznacza termin NoSQL?

- **Ruch NoSQL** – poszukiwanie alternatyw dla problemów, które **bazy relacyjne trudno rozwiązują**.
- **Bazy NoSQL** – nowa generacja baz danych, które są:
  - **nie-relacyjne** (non-relational)
  - **rozproszone** (distributed)
  - **otwarte** (open-source)
  - **horyzontalnie skalowalne** (horizontally scalable)
- **Cechy charakterystyczne:**
  - brak sztywnego schematu danych (schema-free)
  - łatwe replikowanie danych
  - proste API
  - spójność ewentualna (_eventually consistent_)
  - obsługa dużych zbiorów danych

Źródło: hostingdata.co.uk

## Slajd 017 — Bazy NoSQL

- **Pozwalają na przechowywanie danych bez schematu**
  - może to być zarówno zaleta, jak i wada
  - większa elastyczność, ale też ryzyko „zabałaganienia” danych, co wpływa również na aplikacje
- **Są łatwiejsze w skalowaniu**
  - wielu uważa, że są też prostsze w programowaniu, ale jest to subiektywna ocena
- **Brak wsparcia dla znanej z relacyjnych baz danych bardzo rygorystycznej spójności danych**
  - w bazach NoSQL spójność (ang. consistency) jest często poświęcana na rzecz wysokiej dostępności danych i szybkości działania systemu
  - utrzymanie spójności w systemach rozproszonych jest zazwyczaj trudne do osiągnięcia
  - czasami nie ma możliwości zrezygnowania ze spójności (np. konta bankowe, dane finansowe, dane ubezpieczeniowe)
  - w wielu systemach rozproszonych utrzymanie spójności danych nie jest konieczne, a na pewno nie jest priorytetem

## Slajd 018 — Lista systemów NoSQL

wg. https://hostingdata.co.uk/nosql-database/

- Wide Column Store / Column Families
- Document Store
- Key Value / Tuple Store
- Graph Database Management Systems
- Multimodel Database Management Systems
- Object Database Management Systems
- Grid & Cloud Database Management Solutions
- XML Database Management Systems
- Multidimensional Database Management Systems
- Multivalue Database Management Systems
- Event Sourcing
- Time Series / Streaming Database Management Systems
- Other NoSQL related database management systems
- Unresolved and Uncategorized

## Slajd 019 — Bazy klucz–wartość

- **Model danych**
  - Najprostszy model bazy NoSQL
    - analogia do tablicy asocjacyjnej (słownika)
  - Dane przechowywane jako **pary klucz–wartość**
    - **Klucz**: unikalny identyfikator (np. ciąg znaków, liczba)
    - **Wartość**: dowolne dane (np. tekst, obiekt, lista, liczba)
- **Podstawowe operacje**
  - Dodaj / zmień / usuń wartość dla podanego klucza
  - Pobierz wartość dla podanego klucza
- **Zalety**
  - Bardzo prosta architektura
  - Szybki dostęp do danych (niska latencja)
  - Łatwo się skaluje (np. poziomo)
- **Ograniczenia**
  - Nie sprawdza się dobrze dla danych o złożonej strukturze
  - Zazwyczaj brak zaawansowanych zapytań (np. wyszukiwania po wartościach)

## Slajd 020 — Bazy klucz–wartość

**Kiedy używać?**
- Dane sesyjne
- Cache aplikacyjny
- Ustawienia użytkownika
- Koszyki zakupowe
- Rankingi i liczniki (np. polubienia, wyświetlenia)
- Przechowywanie tokenów i danych uwierzytelniających (np. sesje, API keys)

**Kiedy nie używać?**
- Gdy występują złożone relacje między encjami
- Gdy potrzebne są złączenia (JOIN)
- Gdy zapytania dotyczą fragmentów wartości zamiast klucza
- Gdy wymagane jest przeszukiwanie wielu rekordów według różnych kryteriów (np. filtrowanie po wielu polach)

**Przedstawiciele:**
> [Grafika] Logotypy: redis, Valkey, amazon DynamoDB, AEROSPIKE, riak KV, hazelcast, ORACLE NoSQL Database, Dragonfly.

## Slajd 021 — Bazy klucz-wartość

> [Grafika] Zrzut wykresu liniowego „DB-Engines Ranking of Key-value Stores” (oś pionowa: Score (logarithmic scale), 0.001–100; oś pozioma: lata 2014–2024; „© October 2025, DB-Engines.com”). Legenda (strona 1/4): Redis, Amazon DynamoDB, Microsoft Azure Cosmos DB, Memcached, etcd, Hazelcast, Aerospike, Oracle NoSQL, Riak KV, Apache Ignite, Ehcache, ArangoDB, RocksDB, GemFire, Google Cloud Bigtable, OrientDB, InterSystems IRIS, LevelDB, LMDB, Infinispan, Valkey, Oracle Coherence, Amazon SimpleDB, Oracle Berkeley DB, Geode, GridGain. Na górze wykresu Redis (ok. 100+), pod nim Amazon DynamoDB, następnie Microsoft Azure Cosmos DB i Memcached; pozostałe systemy w przedziale ok. 1–10.

## Slajd 022 — Redis – baza klucz-wartość

Szybka, elastyczna, wszechstronna

> [Grafika] Logo „redis”; hasła: Szybkość, Prostota, Wszechstronność.

### 1 Czym jest Redis?
Redis (**RE**mote **DI**ctionary **S**erver) to szybka, otwartoźródłowa baza danych klucz-wartość, która przechowuje dane głównie w pamięci operacyjnej (RAM).
Ramka: Redis to nie tylko prosta baza klucz-wartość – obsługuje wiele struktur danych i zaawansowane mechanizmy, np. publikacja/subskrypcja.

### 2 Jak działa Redis?
> [Grafika] Diagram: Klient (aplikacja) → „Zapis (GET/SET)” → Redis (dane w RAM) → „Odpowiedź (wartość)” → Klient. Po prawej trzy kafelki: „RAM – Pamięć RAM (błyskawiczny dostęp)”; „Opcjonalnie zapis na dysk (RDB/AOF)”; „Replikacja i wysoka dostępność”.

### 3 Przykłady danych w Redis
```
# Podstawowe operacje
SET uzytkownik:1 "Jan"
GET uzytkownik:1
127.0.0.1:6379> "Jan"
# Struktura typu hash
HSET osoba:1 imie "Anna" nazwisko "Nowak" wiek 28
HGETALL osoba:1
# Lista
LPUSH kolejka 0 "zadanie1" "zadanie2"
LRANGE kolejka 0 -1
# Zbiór
SADD tagi "tech" "backend" "redis"
SMEMBERS tagi
```
> [Grafika] Zrzut terminala z przykładowymi komendami Redis CLI (etykieta „Przykłady komend Redis CLI”). Tekst kodu jest drobny, odczyt przybliżony.

### 4 Obsługiwane struktury danych
Redis wspiera różne typy wartości, nie tylko proste klucze i stringi.
- String (np. tekst)
- Hash (np. obiekty)
- List (np. kolejki)
- Set (np. unikalne dane)
- Sorted Set (np. rankingi)
- Bitmap (np. flagi)
- HyperLogLog (np. unikalni goście)
- Stream (np. strumienie zdarzeń)

### 5 Najważniejsze cechy Redis
- Bardzo wysoka wydajność (dane w pamięci RAM)
- Wszechstronne struktury danych
- Trwałość danych (RDB, AOF)
- Replikacja i klastrowanie
- Wysoka dostępność
- Prosty interfejs (CLI, biblioteki)
- Rozszerzalność przez moduły (np. RediSearch, RedisJSON, RedisTimeSeries)

### 6 Zastosowania Redis
- Cache (przyspieszanie aplikacji)
- Sesje użytkowników (np. w aplikacjach web)
- E-commerce (koszyki, stany produktów)
- Czat w czasie rzeczywistym
- Rankingi i liczniki
- Internet rzeczy (IoT, strumienie danych)

### 7 Zalety Redis
- Błyskawiczny dostęp do danych (mikrosekundy)
- Prosta obsługa i bogaty ekosystem
- Obsługa wielu typów struktur danych
- Skalowalność (klastry, replikacja)
- Szerokie zastosowania

### 8 Ograniczenia Redis
- Dane przechowywane głównie w pamięci RAM (większe koszty przy dużych zbiorach)
- Nie jest idealny do trwałego przechowywania dużych, złożonych danych biznesowych
- Ograniczone możliwości zapytań (brak języka query jak SQL)
- Ryzyko utraty danych przy niewłaściwej konfiguracji
- Nie zastępuje typowej bazy relacyjnej

### 9 Redis a inne bazy
| Cecha | Redis (klucz-wartość) | MongoDB (dokumentowa) | Baza relacyjna (np. PostgreSQL) |
|---|---|---|---|
| Model danych | Klucz-wartość | Dokumenty (JSON) | Tabele (wiersze i kolumny) |
| Szybkość | Bardzo wysoka | Wysoka | Średnia |
| Złożoność zapytań | Prosta | Średnia | Zaawansowana (SQL) |
| Przechowywanie danych | Głównie RAM | Dysk | Dysk |
| Ryzowe zastosowania | Cache, sesje, kolejki | Aplikacje web, CMS | Systemy biznesowe |

**Redis – szybkość, elastyczność i więcej niż tylko klucz-wartość.**
Idealne rozwiązanie do nowoczesnych aplikacji wymagających wysokiej wydajności i pracy w czasie rzeczywistym.

## Slajd 023 — Bazy dokumentów

- **Model danych**
  - Dokumenty (najczęściej w formacie **JSON**, rzadziej **XML**)
  - Umożliwiają reprezentację danych hierarchicznych i zagnieżdżonych
  - Dokumenty są organizowane w kolekcje
  - Poszczególne dokumenty mogą mieć różną strukturę
- **Podstawowe operacje**
  - Dodaj / zmień / usuń dokument
  - Wyszukaj dokument według dowolnych kryteriów
  - Filtrowanie, sortowanie i agregacja danych
- **Kiedy używać?**
  - Logowanie zdarzeń, blogi, systemy CMS itp.
- **Kiedy nie używać?**
  - Kiedy struktura dokumentów często się zmienia / są one [tekst ucięty na krawędzi slajdu] dzielone na wiele pomniejszych.
- **Przedstawiciele:**

> [Grafika] Logotypy: MongoDB, Couchbase, [częściowo ucięte logo z pomarańczowym sześcianem, prawdopodobnie Amazon – nieczytelne], CouchDB relax, RethinkDB.

## Slajd 024 — Bazy dokumentów

> [Grafika] Zrzut wykresu liniowego „DB-Engines Ranking of Document Stores” (oś pionowa: Score (logarithmic scale), 0.001–100; oś pozioma: lata 2014–2024; „© October 2025, DB-Engines.com”). Legenda (strona 1/3): MongoDB, Databricks, Amazon DynamoDB, Microsoft Azure Cosmos DB, Firebase Realtime Database, Couchbase, Google Cloud Firestore, Realm, CouchDB, Aerospike, MarkLogic, Google Cloud Datastore, Oracle NoSQL, ArangoDB, Virtuoso, IBM Cloudant, OrientDB, RavenDB, RethinkDB, InterSystems IRIS, Amazon DocumentDB, PouchDB, CloudKit, Apache Drill, Fauna, Tarantool. MongoDB na samej górze (ponad 100), pod nim Databricks i Amazon DynamoDB; pozostałe w przedziale ok. 1–30.

## Slajd 025 — Baza klucz-dokument - MongoDB

Elastyczna baza danych dokumentowych dla nowoczesnych aplikacji

> [Grafika] Logo „MongoDB” z hasłem „Build what's next.”

### 1 Czym jest baza klucz-dokument?
Baza klucz-dokument przechowuje dane w postaci dokumentów (najczęściej w formacie JSON/BSON), każdy dokument ma unikalny klucz (_id).
Ramka: Dokumenty mogą mieć różną strukturę, co daje dużą elastyczność.

### 2 Jak działa MongoDB?
> [Grafika] Diagram: Dokument (JSON/BSON) → Kolekcja (zbiór dokumentów) → Baza danych (zbiory kolekcji).

### 3 Przykład dokumentu w MongoDB
```json
{
  "_id": ObjectId("64f7c9a2e1b3c8a1d5e4f001"),
  "imie": "Jan",
  "nazwisko": "Kowalski",
  "wiek": 25,
  "miasto": "Warszawa",
  "zainteresowania": ["programowanie", "sport"]
}
```
> [Grafika] Fragment z etykietą „BSON/JSON”; kod drobny, odczyt przybliżony.

### 4 Najważniejsze cechy MongoDB
- **Elastyczny schemat** – Dokumenty mogą mieć różną strukturę.
- **Skalowalność** – Łatwe skalowanie w poziomie (sharding).
- **Wysoka wydajność** – Szybki dostęp do danych, indeksy.
- **Bogate możliwości zapytań** – Wyszukiwanie, filtrowanie, agregacje.
- **Popularność i duże wsparcie społeczności** – Szerokie zastosowanie i ekosystem narzędzi.

### 5 Przykładowe operacje
**Dodawanie dokumentu**
```js
db.klienci.insertOne({
  imie: "Anna", nazwisko: "Nowak", wiek: 28
})
```
**Wyszukiwanie dokumentów**
```js
db.klienci.find({ miasto: "Warszawa" })
```
**Aktualizacja dokumentu**
```js
db.klienci.updateOne(
  { _id: ObjectId("64f7c9a2e1b3c8a1d5e4f001") },
  { $set: { wiek: 26 } }
)
```

### 6 Zastosowania MongoDB
- Aplikacje webowe i mobilne
- E-commerce
- Systemy CMS i zarządzanie treścią
- Analityka i big data
- Gry online
- Internet rzeczy (IoT)

### 7 MongoDB a inne bazy
| Cecha | MongoDB (klucz-dokument) | Bazy relacyjne |
|---|---|---|
| Model danych | Dokumenty (JSON/BSON) | Tabele (wiersze i kolumny) |
| Schemat | Elastyczny | Sztywny |
| Skalowanie | Łatwe, w poziomie | Trudniejsze, zwykle w pionie |
| Relacje między danymi | Wbudowane / zagnieżdżone | Za pomocą kluczy obcych |
| Najlepsze zastosowania | Nowoczesne, szybko zmieniające się dane | Dane o stałej strukturze |

### 8 Wady i ograniczenia
- Brak transakcji ACID w starszych wersjach (wsparcie od wersji 4.0, ale z ograniczeniami).
- Nie jest idealna do złożonych relacji między danymi.
- Większe zużycie miejsca na dysku (przez elastyczny schemat).

### 9 Podsumowanie
- MongoDB to popularna baza klucz-dokument, która zapewnia elastyczność, skalowalność i wysoką wydajność.
- Świetnie sprawdza się w nowoczesnych aplikacjach i projektach o dynamicznie zmieniających się danych.
- To jedna z najczęściej wybieranych baz NoSQL na świecie.

**MongoDB – elastyczne dane. Większe możliwości.**
Przechowuj, skaluj, rozwijaj.

## Slajd 026 — Bazy rodziny kolumn

**Model danych:**
- Rodzina kolumn (tabela)
  - Tabela to kolekcja podobnych wierszy (niekoniecznie identycznych)
- Wiersz
  - Wiersz to kolekcja kolumn
    - Agreguje dane pozyskiwane wspólnie.
  - Dostęp zapewnia identyfikator wiersza (np. klucz partycji / row key).
- Kolumna
  - Kolumna składa się z nazwy i wartości.
  - Dozwolone są zarówno wartości skalarne, jak i listy czy mapy.

**Zapytania:**
- Dodaj/Zmień/Usuń wiersz zawierający rodzinę kolumn.
- Wybierz wiersz na podstawie identyfikatora lub prostego przeszukiwania kolumn.

**Uwaga:**
- Nie są to po prostu bazy relacyjne, ze zmienną specyfikacją wiersza.

**Kiedy używać?**
- Blogi, systemy CMS.

**Kiedy nie używać?**
- Gdy wymagane są transakcje (ze ścisłą spójnością).
- Występują złożone zapytania: agregacja (SUM, AVG, ...), złączenia itp.
- Schemat bazy może zostać często zmieniony.

**Przedstawiciele:**
> [Grafika] Logotypy: Apache Cassandra, ScyllaDB, Apache HBase, Google Bigtable, Azure Cosmos DB (API Cassandra).

## Slajd 027 — Bazy rodziny kolumn

> [Grafika] Zrzut wykresu liniowego „DB-Engines Ranking of Wide Column Stores” (oś pionowa: Score (logarithmic scale), 0.001–100; oś pozioma: lata 2014–2024; „© October 2025, DB-Engines.com”). Legenda: Apache Cassandra, Microsoft Azure Cosmos DB, Apache HBase, ScyllaDB, Datastax Enterprise, Microsoft Azure Table Storage, Google Cloud Bigtable, Apache Accumulo, Amazon Keyspaces, HPE Ezmeral Data Fabric, Elassandra, Alibaba Cloud Table Store, SWC-DB, Hypertable, Sqrrl. Cassandra na górze (ok. 100), pod nią Apache HBase, następnie Microsoft Azure Cosmos DB; pozostałe poniżej 10.

## Slajd 028 — Baza kolumnowa (Wide-Column) - Apache Cassandra

Rozproszona baza danych dla systemów o wysokiej dostępności

> [Grafika] Logo „Apache Cassandra”.

### 1 Czym jest baza kolumnowa?
Apache Cassandra przechowuje dane w modelu szerokich kolumn (Wide-Column Store). Dane organizowane są w tabelach, ale struktura jest bardziej elastyczna niż w tradycyjnych bazach relacyjnych.
Ramka: Zaprojektowana do pracy na wielu serwerach bez pojedynczego punktu awarii.

### 2 Jak działa Cassandra?
> [Grafika] Diagram: Rekord (wiersz) → Tabela (column family) → Keyspace (przestrzeń nazw) → Klaster Cassandra (wiele węzłów).

Ramka: Klaster składa się z wielu równorzędnych węzłów przechowujących część danych.

### 3 Przykład rekordu w Cassandra
```sql
-- Tworzenie tabeli
CREATE TABLE klienci (
  id INT PRIMARY KEY,
  imie TEXT,
  nazwisko TEXT,
  miasto TEXT,
  wiek INT
);
-- Przykładowe dane (rekord)
INSERT INTO klienci (id, imie, nazwisko, miasto, wiek)
VALUES (1001, 'Jan', 'Kowalski', 'Warszawa', 25);
```
> [Grafika] Fragment z etykietą „CQL”; kod drobny, odczyt przybliżony.

### 4 Najważniejsze cechy Cassandra
- **Wysoka dostępność** – Brak pojedynczego punktu awarii.
- **Skalowalność pozioma** – Łatwe dodawanie nowych serwerów do klastra.
- **Replikacja danych** – Automatyczne kopiowanie danych między węzłami.
- **Bardzo wysoka wydajność zapisu** – Przystosowana do ogromnych wolumenów danych.
- **Architektura rozproszona** – Wszystkie węzły są równorzędne (peer-to-peer).

### 5 Przykładowe operacje
**Dodawanie danych**
```sql
INSERT INTO klienci
(id, imie, nazwisko, miasto, wiek)
VALUES (1002, 'Anna', 'Nowak', 'Kraków', 28);
```
**Wyszukiwanie danych**
```sql
SELECT * FROM klienci
WHERE id = 1002;
```
**Aktualizacja danych**
```sql
UPDATE klienci
SET wiek = 29
WHERE id = 1002;
```

### 6 Zastosowania Cassandra
- Aplikacje internetowe o dużym ruchu
- Systemy mobilne
- Big Data i analityka
- Platformy społecznościowe
- Internet rzeczy (IoT)
- Gry online
- Monitoring i telemetria

### 7 Cassandra a inne bazy
| Cecha | Cassandra (Wide-Column) | Bazy relacyjne |
|---|---|---|
| Model danych | Szerokie kolumny | Tabele |
| Skalowanie | Poziome | Głównie pionowe |
| Dostępność | Bardzo wysoka | Zależna od konfiguracji |
| Spójność danych | Konfigurowalna (tzw. eventual) | Silna (ACID) |
| Najlepsze zastosowania | Duże rozproszone systemy | Dane transakcyjne |

### 8 Wady i ograniczenia
- Bardziej złożone modelowanie danych.
- Ograniczone możliwości operacji JOIN.
- Nie jest optymalna do skomplikowanych transakcji.
- Projekt zapytań należy planować przed tworzeniem tabel (denormalizacja danych).

### 9 Podsumowanie
- Cassandra zapewnia wysoką dostępność i odporność na awarie.
- Doskonale skaluje się na setki i tysiące serwerów.
- Jest jednym z najpopularniejszych rozwiązań NoSQL dla systemów Big Data.
- Sprawdza się tam, gdzie priorytetem są wydajność i niezawodność.

**Apache Cassandra – dane bez przestojów.**
Skaluj globalnie. Przechowuj niezawodnie.

## Slajd 029 — Bazy grafowe

**Model danych:**
- Graf
  - Skierowana / nieskierowana kolekcja:
    - węzłów reprezentujących encje
    - krawędzi reprezentujących relacje między encjami
  - Zarówno węzły, jak i krawędzie mogą posiadać dowolne właściwości (atrybuty).

**Typy:**
- **Transakcyjne (OLTP)** → duża liczba małych lub średnich grafów
- **Analityczne (OLAP)** → mała liczba bardzo dużych grafów

**Kiedy używać?**
- Sieci społecznościowe
- Silniki rekomendacyjne
- Knowledge Graphs
- Wykrywanie oszustw
- Systemy nawigacyjne
- Analiza zależności

**Zapytania:**
- Dodaj/Zmień/Usuń węzeł lub krawędź
- Wyszukiwanie najkrótszej ścieżki
- Analiza relacji i zależności
- Zapytania do podgrafów i nadgrafów
- Wyszukiwanie podobnych obiektów

**Kiedy nie używać?**
- Operacje dotyczą wielu węzłów bądź krawędzi.
- Bardzo dużych, złożonych grafów w dużej liczbie.

**Przedstawiciele:**
> [Grafika] Logotypy: neo4j, ArangoDB, OrientDB, JanusGraph.

## Slajd 030 — Bazy grafowe

> [Grafika] Zrzut wykresu liniowego „DB-Engines Ranking of Graph DBMS” (oś pionowa: Score (logarithmic scale), 0.001–10+; oś pozioma: lata 2014–2024; „© October 2025, DB-Engines.com”). Legenda (strona 1/2): Neo4j, Microsoft Azure Cosmos DB, Aerospike, ArangoDB, Virtuoso, OrientDB, NebulaGraph, GraphDB, Amazon Neptune, Memgraph, JanusGraph, TigerGraph, Stardog, Fauna, Dgraph, SurrealDB, Giraph, Blazegraph, AllegroGraph, TypeDB, Graph Engine, Fluree, RDFox, InfiniteGraph, FalkorDB, AnzoGraph DB. Neo4j na górze (ok. 50), pod nim Microsoft Azure Cosmos DB; pozostałe w przedziale ok. 1–10.

## Slajd 031 — Baza grafowa - Neo4j

Baza danych dla danych połączonych i złożonych relacji

> [Grafika] Logo „neo4j” z napisem „Graph Database for Tomorrow”.

### 1 Czym jest baza grafowa?
Neo4j to natywna baza grafowa, która przechowuje dane w postaci węzłów, relacji i etykiet. Została zaprojektowana do efektywnego zarządzania danymi o złożonych powiązaniach między obiektami.
Ramka: Idealna do analizowania relacji i znajdowania ukrytych zależności w danych.

### 2 Jak działa Neo4j?
> [Grafika] Diagram: Węzeł (np. Osoba) → relacja „ZNA” → Węzeł (np. Osoba); obok ikona „Etykiety i właściwości (np. :Osoba {name: "Jan"})”.

Ramka: Dane przechowywane są jako graf: węzły połączone relacjami, które mogą mieć kierunek i właściwości.

### 3 Przykład danych w Neo4j
```cypher
// Tworzenie węzłów i relacji
CREATE (a:Osoba {imie: 'Jan', nazwisko: 'Kowalski'})
CREATE (b:Osoba {imie: 'Anna', nazwisko: 'Nowak'})
CREATE (a)-[:ZNA {od_kiedy: 2020}]->(b)

// Wyszukiwanie znajomych Jana
MATCH (a:Osoba {imie: 'Jan'})-[:ZNA]->(b)
RETURN b.imie, b.nazwisko, b.od_kiedy;
```
> [Grafika] Fragment z etykietą „Cypher”; kod drobny, odczyt przybliżony.

### 4 Najważniejsze cechy Neo4j
- **Model grafowy** – Dane jako węzły, relacje i właściwości.
- **Wysoka wydajność zapytań** – Szybkie traversowanie relacji.
- **Skalowalność** – Obsługa dużych grafów i rosnących danych.
- **Zaawansowana analiza relacji** – Łatwe wykrywanie wzorców i zestawień.
- **Bogate możliwości zastosowań** – Od rekomendacji po wykrywanie oszustw.

### 5 Przykładowe operacje
**Dodawanie danych**
```cypher
CREATE (p:Produkt {nazwa: 'Laptop', cena: 3500})
CREATE (k:Klient {imie: 'Anna'})
CREATE (k)-[:KUPIL {data: date()}]->(p)
```
**Wyszukiwanie danych**
```cypher
MATCH (k:Klient)-[:KUPIL]->(p:Produkt)
WHERE k.imie = 'Anna'
RETURN p.nazwa, p.cena;
```
**Aktualizacja danych**
```cypher
MATCH (p:Produkt {nazwa: 'Laptop'})
SET p.cena = 3200
RETURN p;
```

### 6 Zastosowania Neo4j
- Systemy rekomendacji
- Analiza sieci społecznościowych
- Wykrywanie oszustw
- Zarządzanie danymi powiązanymi
- Wyszukiwanie i eksploracja relacji
- Zarządzanie wiedzą i dokumentacją
- Analityka i business intelligence
- Internet rzeczy (IoT)

### 7 Neo4j a inne bazy
| Cecha | Neo4j (Baza grafowa) | Bazy relacyjne |
|---|---|---|
| Model danych | Graf (węzły i relacje) | Tabele |
| Połączenia między danymi | Naturalne i szybkie | Złożone (JOIN) |
| Wydajność zapytań o relacje | Bardzo wysoka | Zależna od złożoności |
| Skalowanie | Poziome | Głównie pionowe |
| Najlepsze zastosowania | Złożone relacje, analityka | Dane transakcyjne |

### 8 Wady i ograniczenia
- Nie jest optymalna dla prostych danych tabelarycznych.
- Wyższe wymagania sprzętowe przy bardzo dużych grafach.
- Mniej odpowiednia do transakcji masowych niż tradycyjne bazy relacyjne.
- Konieczność nauki języka Cypher i innego podejścia do modelowania danych.

### 9 Podsumowanie
- Neo4j umożliwia efektywne zarządzanie danymi połączonymi i złożonymi relacjami.
- Zapewnia wysoką wydajność zapytań i łatwą analizę grafu.
- Świetnie sprawdza się w nowoczesnych aplikacjach wykorzystujących dane powiązane.
- To jedno z najpopularniejszych rozwiązań baz grafowych na świecie.

**Neo4j – odkryj siłę połączeń.**
Dane zyskują wartość, gdy widać ich relacje.
Connect. Discover. Build.

## Slajd 032 — Bazy XML

### Model danych
- **Dokumenty XML**
  - Struktura drzewa z zagnieżdżonymi elementami, atrybutami i wartościami tekstowymi
  - Dokumenty organizowane są w kolekcje (np. zestawy dokumentów XML)

### Języki zapytań i przetwarzania
- **XPath:** _XML Path Language_ (nawigacja)
- **XQuery:** _XML Query Language_ (odpytywanie)
- **XSLT:** _XSL Transformations_ (transformacja)

### Przykład dokumentu XML
```xml
<ksiazka id="1">
  <tytul>Wiedza o danych</tytul>
  <autor>Jan Kowalski</autor>
  <rok>2024</rok>
  <cena waluta="PLN">79.90</cena>
  <kategorie>
    <kategoria>Database</kategoria>
    <kategoria>NoSQL</kategoria>
  </kategorie>
</ksiazka>
```

### Struktura drzewa XML
> [Grafika] Diagram drzewa: korzeń „ksiazka id="1"” z gałęziami: „tytul” → „Wiedza o danych”; „autor” → „Jan Kowalski”; „rok” → „2024”; „cena waluta="PLN"” → „79.90”; „kategorie” → dwa węzły „kategoria” → „Database” i „NoSQL”.

### Przedstawiciele baz danych XML
> [Grafika] Logotypy z podpisami: Sedna (Native XML Database System); MarkLogic (Enterprise XML Database); Tamino (XML Server); eXist-db (Open Source XML Database); Virtuoso – OpenLink VIRTUOSO (Universal Server (z funkcjonalnością XML)).

## Slajd 033 — Bazy RDF

**Model danych:**
- Trójki RDF
  - Temat, predykat, obiekt
  - Każda trójka reprezentuje zdanie twierdzące(stwierdzenie) dotyczące bytu (świata rzeczywistego)
- Trójki można porównać do **grafów**
  - **Wierzchołki** to tematy lub obiekty
  - **Krawędzie** oznaczają poszczególne stwierdzenia

**Język zapytań:**
- **SPARQL**: _SPARQL Protocol and RDF Query Language_

Przedstawiciele:
> [Grafika] Logotypy: Apache Jena, rdf4j.

## Slajd 034 — DB-Engines Ranking

https://db-engines.com/en/ranking

> [Grafika] Zrzut strony db-engines.com. Tekst: „The DB-Engines Ranking ranks database management systems according to their popularity. The ranking is updated monthly. Read more about the method of calculating the scores.” Obok miniatura „trend chart”. „425 systems in ranking, October 2025”. Wiersze MongoDB, Redis i Apache Cassandra otoczone niebieskimi ramkami.

| Rank Oct 2025 | Rank Sep 2025 | Rank Oct 2024 | DBMS | Database Model | Score Oct 2025 | Score Sep 2025 | Score Oct 2024 |
|---|---|---|---|---|---|---|---|
| 1. | 1. | 1. | Oracle | Relational, Multi-model | 1212.77 | +42.15 | -96.67 |
| 2. | 2. | 2. | MySQL | Relational, Multi-model | 879.66 | -12.11 | -143.09 |
| 3. | 3. | 3. | Microsoft SQL Server | Relational, Multi-model | 715.05 | -2.27 | -87.04 |
| 4. | 4. | 4. | PostgreSQL | Relational, Multi-model | 643.20 | -13.97 | -8.96 |
| 5. | 5. | 5. | MongoDB | Document, Multi-model | 368.01 | -12.49 | -37.20 |
| 6. | 6. | ↑ 7. | Snowflake | Relational | 198.65 | +8.46 | +58.05 |
| 7. | 7. | ↓ 6. | Redis | Key-value, Multi-model | 142.33 | -2.84 | -7.30 |
| 8. | ↑ 9. | ↑ 14. | Databricks | Multi-model | 128.80 | +4.74 | +43.21 |
| 9. | ↓ 8. | 9. | IBM Db2 | Relational, Multi-model | 122.37 | -1.81 | -0.40 |
| 10. | 10. | ↓ 8. | Elasticsearch | Multi-model | 116.67 | -1.59 | -15.18 |
| 11. | ↑ 12. | 11. | Apache Cassandra | Wide column, Multi-model | 105.16 | -1.82 | +7.56 |
| 12. | ↓ 11. | ↓ 10. | SQLite | Relational | 104.56 | -3.32 | +2.64 |
| 13. | 13. | ↑ 15. | MariaDB | Relational, Multi-model | 87.77 | -3.69 | +2.88 |
| 14. | 14. | ↓ 12. | Microsoft Access | Relational | 80.79 | -2.82 | -11.36 |
| 15. | 15. | ↑ 17. | Amazon DynamoDB | Multi-model | 75.91 | -4.37 | +4.06 |
| 16. | 16. | 16. | Microsoft Azure SQL Database | Relational, Multi-model | 75.49 | -3.70 | +0.95 |

## Slajd 035 — DB-Engines Ranking of Graph DBMS

https://db-engines.com/en/ranking/graph+dbms

> [Grafika] Zrzut strony db-engines.com. Tekst: „The DB-Engines Ranking ranks database management systems according to their popularity. The ranking is updated monthly. This is a partial list of the complete ranking showing only graph DBMS. Read more about the method of calculating the scores.” Obok miniatura „trend chart”. Pole wyboru „include secondary database models”. „43 systems in ranking, October 2025”. Wiersz Neo4j otoczony niebieską ramką.

| Rank Oct 2025 | Rank Sep 2025 | Rank Oct 2024 | DBMS | Database Model | Score Oct 2025 | Score Sep 2025 | Score Oct 2024 |
|---|---|---|---|---|---|---|---|
| 1. | 1. | 1. | Neo4j | Graph | 52.51 | -1.27 | +10.01 |
| 2. | 2. | 2. | Microsoft Azure Cosmos DB | Multi-model | 22.71 | -1.23 | -1.78 |
| 3. | 3. | 3. | Aerospike | Multi-model | 4.53 | -0.58 | -1.05 |
| 4. | 4. | ↑ 5. | ArangoDB | Multi-model | 2.91 | -0.02 | -0.52 |
| 5. | ↑ 6. | ↓ 4. | Virtuoso | Multi-model | 2.74 | +0.21 | -1.18 |
| 6. | ↓ 5. | 6. | OrientDB | Multi-model | 2.62 | +0.03 | -0.41 |
| 7. | 7. | ↑ 11. | NebulaGraph | Graph | 2.45 | -0.08 | +0.58 |
| 8. | ↑ 10. | 8. | GraphDB | Multi-model | 2.30 | -0.05 | -0.47 |
| 9. | 9. | 9. | Amazon Neptune | Multi-model | 2.26 | -0.16 | +0.09 |
| 10. | ↓ 8. | ↓ 7. | Memgraph | Graph | 2.26 | -0.18 | -0.56 |

## Slajd 036 — BASE

- **UWAGA:** w dostępnych źródłach nie ma jakiejś jednej uznanej definicji. Wielu autorów dość swobodnie definiuje **BASE**
- Zasadnicza dostępność (ang. **Basically Available**)
  - system nie gwarantuje zawsze pełnej dostępności, ale zazwyczaj pozostaje dostępny i zdolny do obsługi żądań.
- Miękki stan (ang. **Soft state**)
  - wskazuje, że stan systemu może zmieniać się w czasie, nawet bez wprowadzania zmian w danych.
- Ostateczna spójność (ang. **Eventually consistent**)
  - wskazuje, że system po pewnym czasie stanie się spójny (np. że dwa węzły po pewnym czasie zostaną zsynchronizowane), nawet w sytuacji, gdy żadne dane nie są do systemu wprowadzane, zmieniane czy kasowane. Dane mogą stać się niespójne np. w przypadku czasowej niedostępności jednego z węzłów.

### Co zastępuje BASE w bazie relacyjnej?
- W bazach relacyjnych (klasyczne systemy SQL) zamiast BASE stosuje się model **ACID** (ang. Atomicity, Consistency, Isolation, Durability), który zapewnia silniejsze gwarancje spójności i transakcyjności.

## Slajd 037 — Twierdzenie CAP

W rozproszonym systemie danych nie można jednocześnie zapewnić wszystkich trzech właściwości: spójności, dostępności i tolerancji na podział sieci.

> [Grafika] Diagram Venna z trzema przecinającymi się kołami:
> - C – Spójność (Consistency): „Wszyscy klienci widzą te same, aktualne dane.” (koło niebieskie)
> - A – Dostępność (Availability): „Każde żądanie otrzymuje odpowiedź (niezależnie od awarii części węzłów).” (koło zielone)
> - P – Tolerancja na podział sieci (Partition tolerance): „System nadal działa pomimo podziału sieci (np. braku łączności między węzłami).” (koło czerwone)
> - Część wspólna C i A: „CA (brak P)”; część wspólna C i P: „CP (brak A)”; część wspólna A i P: „AP (brak C)”.

### Trzy właściwości CAP
- **C – Spójność (Consistency)** — Po zapisaniu danych każdy odczyt zwraca najnowsze, spójne dane.
- **A – Dostępność (Availability)** — Każde żądanie otrzymuje odpowiedź (w rozsądnym czasie).
- **P – Tolerancja na podział sieci (Partition tolerance)** — System nadal działa, nawet jeśli sieć jest podzielona i węzły nie mogą się ze sobą komunikować.

### Możliwe kombinacje
- **CA** – spójność i dostępność (brak tolerancji na podział sieci) – np. tradycyjna, pojedyncza baza relacyjna.
- **CP** – spójność i tolerancja na podział sieci (brak pełnej dostępności) – np. niektóre systemy rozproszone (np. HBase, MongoDB w trybie CP).
- **AP** – dostępność i tolerancja na podział sieci (brak pełnej spójności) – np. systemy typu Dynamo, Cassandra, niektóre konfiguracje NoSQL.

**Wniosek:** W rozproszonym systemie danych można jednocześnie zapewnić tylko dwie z trzech właściwości CAP. W praktyce należy wybrać kompromis odpowiedni do wymagań danego systemu.

## Slajd 038 — Trójkąt CAP

- Tradycyjne relacyjne bazy danych (MySQL, PostgreSQL itp.) lokują się na boku CA trójkąta.
  - kładą nacisk na spójność i dostępność danych, ale skalują się przede wszystkim pionowo
- Pozostałe boki obstawione są przede wszystkim przez bazy NoSQL.
  - Baza Cassandra jest przykładem bazy AP, która nastawiona jest na skalowanie poziome z równoczesną odpornością na awarie i wysoką dostępnością, przy czym nie mamy gwarancji, że odczytujemy najbardziej aktualne dane.
  - MongoDB, którą można zaklasyfikować jako CP, czyli pozwala na rozproszenie z zachowaniem integralności danych, lecz w przypadku awarii węzła, należy liczyć się z brakiem dostępu do części danych.

> [Grafika] Trójkąt CAP z wierzchołkami: A – Dostępność (Availability): „Każde żądanie otrzymuje odpowiedź (w rozsądnym czasie).”; C – Spójność (Consistency): „Wszyscy klienci widzą te same, aktualne dane.”; P – Tolerancja na podział sieci (Partition Tolerance): „System działa poprawnie mimo podziału sieci (awarii części węzłów).” W środku: „Możesz wybrać tylko 2 z 3”. Przy bokach ramki:
> - CA (bez tolerancji na podział sieci) — Przykłady: klasyczne bazy relacyjne (np. MySQL, PostgreSQL); systemy działające w jednej lokalizacji (bez rozproszenia)
> - AP (bez pełnej spójności) — Przykłady: DynamoDB, Cassandra, Riak, CouchDB
> - CP (bez pełnej dostępności) — Przykłady: HBase; MongoDB (w trybie CP); BigTable; ZooKeeper

## Slajd 039 — Map-Reduce

**Map-Reduce** to model programowania i przetwarzania dużych zbiorów danych w sposób rozproszony i równoległy, np. w systemach takich jak Hadoop.

> [Grafika] Diagram przepływu od lewej do prawej:
> - **Dane wejściowe:** plik 1 „kot pies kot”; plik 2 „pies ptak kot”; plik 3 „pies kot ptak”.
> - **Map (Przekształcenie):** trzy bloki Map dające pary: (kot, 1) (pies, 1) (kot, 1); (pies, 1) (ptak, 1) (kot, 1); (pies, 1) (kot, 1) (ptak, 1).
> - **Shuffle / Sort (Grupowanie):** „Grupowanie wszystkich par o tym samym kluczu”.
> - **Reduce (Agregacja):** (kot, [1,1,1]) → (kot, 3); (pies, [1,1,1]) → (pies, 3); (ptak, [1,1]) → (ptak, 2).
> - **Wynik:** tabela Słowo / Liczba wystąpień: kot 3, pies 3, ptak 2.

### 1 Podział danych
- Duży zbiór danych jest dzielony na mniejsze części (np. bloki plików).
- Każda część jest przetwarzana niezależnie na różnych węzłach klastra.

### 2 Map (przekształcenie)
- Funkcja map dla każdego rekordu wejściowego generuje pary (klucz, wartość).
- W przykładzie: z każdego słowa tworzymy parę (słowo, 1).

### 3 Shuffle / Sort (grupowanie)
- System automatycznie grupuje wszystkie wartości z tym samym kluczem (słowem).
- Dane są przesyłane między węzłami (shuffle) i sortowane.

### 4 Reduce (agregacja)
- Funkcja reduce dla każdego klucza agreguje listę wartości.
- W przykładzie: sumujemy liczbę wystąpień danego słowa.

**Zastosowania:** przetwarzanie logów, analiza danych, indeksowanie wyszukiwarek, przetwarzanie danych w systemach big data.
**Przykład implementacji:** Apache Hadoop (MapReduce)

## Slajd 040 — Podsumowanie

**Czy to koniec baz relacyjnych?**
- <u>Zdecydowanie nie</u>
  - W dalszym ciągu są bardzo dobrym wyborem do wielu projektów czy zastosowań.
  - Mają bardzo dobre dokumentacje, wsparcie, społeczność ekspertów i są ogólnie świetnie znane. Mają też dużo dodatkowych funkcji i mechanizmów np. dotyczących analizy danych.
- Należy jednak brać pod uwagę obecność innych systemów bazodanowych
  - **Najsensowniejsze podejście to wykorzystanie różnych systemów i silników bazodanowych w zależności od wymogów i zastosowania.**

## Slajd 041 — (pusty slajd)

(slajd pusty, bez treści)

## Slajd 042 — MongoDB – instalacja

> [Grafika] Zrzut ekranu wyników wyszukiwania Google dla frazy „mongodb community download” (zakładki: Wszystko, Grafika, Wideo, Krótkie filmy, Wiadomości, Sieć, Książki, Więcej, Narzędzia). Pierwszy wynik: MongoDB, https://www.mongodb.com › try — „MongoDB Community Server Download” — „Download MongoDB Community Server non-relational database to take your next big project to a higher level!”. Podwyniki: „MongoDB Community Edition” („MongoDB Community Server Download. The Community ...”) oraz „Search” („The following are direct download links for MongoDB Community ...”).

## Slajd 043 — MongoDB – instalacja

> [Grafika] Zrzut ekranu dokumentacji MongoDB (Docs Home). Menu górne: Products, Resources, Solutions, Company, Pricing, Eng; pole „Search MongoDB Docs”. Menu boczne: GET STARTED, DEVELOPMENT, MANAGEMENT (zaznaczone), CLIENT LIBRARIES, TOOLS, ATLAS ARCHITECTURE CENTER; DATABASE MANUAL, wersja 8.2 (Current), pozycje: Overview, Documents, Databases & Collections, Client Libraries, Connect to Clusters, Database Users, CRUD Operations, Indexes, Data Modeling, Aggregation Operations, Search, Vector Search, AI Integrations, Time Series. Okruszki: Docs Home / Database Manual / Self-Managed Deployments / Installation.

```text
Install MongoDB Community Edition
Select your operating system to view instructions to install MongoDB Community Edition.
OPERATING SYSTEM: Windows    INSTALLATION METHOD: Zip File

Install MongoDB Community on Windows using the Zip File
Overview
Use this tutorial to install MongoDB Community on Windows by downloading and extracting the zip file.
MongoDB Version
This tutorial installs MongoDB 8.2 Community Edition. To install a different version of MongoDB Community, use the version drop-down under Self-Managed Deployments on the left side of this page to select the documentation for that version.
```

## Slajd 044 — MongoDB – instalacja

> [Grafika] Zrzut ekranu strony pobierania MongoDB Community Server. Menu górne: Products, Resources, Solutions, Company, Pricing, Support, Sign In. Menu boczne: MongoDB Atlas, MongoDB Enterprise Advanced, MongoDB Community Edition, MongoDB Community Server (pogrubione), MongoDB Controllers for Kubernetes Operator, MongoDB Search in Community, Tools, SQL Interface. Formularz pobierania: Version: 8.2.1 (current); Platform: Windows x64; Package: msi; przyciski: Download, Copy link, More Options.

## Slajd 045 — MongoDB – instalacja (plik msi)

> [Grafika] Dwa zrzuty okien instalatora Windows (MSI). Tylne okno: „MongoDB 8.2.1 2008R2Plus SSL (64 bit) Setup”, z zieloną ikoną liścia MongoDB.

```
Welcome to the MongoDB 8.2.1 2008R2Plus SSL (64 bit) Setup Wizard

The Setup Wizard will install MongoDB 8.2.1 2008R2Plus SSL (64 bit) on your computer. Click Next to continue or Cancel to exit the Setup Wizard.
```

Przyciski: Back, Next.

> [Grafika] Przednie okno: „MongoDB 8.2.1 2008R2Plus SSL (64 bit) Service Custom...”.

```
Service Configuration
Specify optional settings to configure MongoDB as a service.

[ ] Install MongoD as a Service
( ) Run service as Network Service user
( ) Run service as a local or domain user:
    Account Domain: .
    Account Name: MongoDB
    Account Password: ••••••••
Service Name: MongoDB
Data Directory: C:\Program Files\MongoDB\Server\8.2\data\
Log Directory: C:\Program Files\MongoDB\Server\8.2\log\
```

Przyciski: < Back, Next >, Cancel. (Pole „Install MongoD as a Service” odznaczone, pozostałe opcje wyszarzone.)

## Slajd 046 — MongoDB Shell – instalacja

> [Grafika] Zrzut strony mongodb.com z pobieraniem MongoDB Shell. Górne menu: MongoDB, Products, Resources, Solutions, Company, Pricing, Support, Sign In, przycisk Get Started. Lewe menu: MongoDB Atlas, MongoDB Enterprise Advanced, MongoDB Community Edition, Tools, MongoDB Shell (pogrubione, aktywne), MongoDB Compass (GUI), Atlas CLI, Atlas Kubernetes Operator, MongoDB CLI for Cloud Manager and Ops Manager, MongoDB Cluster-to-Cluster Sync, MongoDB Relational Migrator, MongoDB Database Tools, MongoDB Connector for BI, App Services CLI, MongoDB for VS Code.

```
MongoDB Shell Download

MongoDB Shell is the quickest way to connect to (and work with) MongoDB. Easily query data, configure settings, and execute other actions with this modern, extensible command-line interface – replete with syntax highlighting, intelligent autocomplete, contextual help, and error messages.

Compatibility Note: Red Hat Enterprise Linux (RHEL) 7, Amazon Linux 2, SUSE Linux Enterprise Server (SLES) 12, and Ubuntu 18.04 support is deprecated and might be removed in a later mongosh release.

Note: MongoDB Shell is an open source (Apache 2.0), standalone product developed separately from the MongoDB Server.

Learn more

Version: 2.5.8
Platform: Windows x64 (10+)
Package: zip
```

Przyciski: Download, Copy link, More Options.

## Slajd 047 — MongoDB Compass

> [Grafika] Zrzut aplikacji MongoDB Compass („Welcome to MongoDB Compass”, „Connected to localhost:27017”, ilustracja wtyczki/wtyku). Menu: Connections, Edit, View, Help. Panel lewy: Compass, My Queries, CONNECTIONS (8), Search connections; rozwinięte localhost:27017 z bazami admin, config, local; poniżej 7 kolejnych wpisów localhost:27017. Zakładka: Welcome.

> [Grafika] W prawym górnym rogu zrzut Eksploratora plików: ...mputer > OS (C:) > data. Kolumna Nazwa: db, mongodb-database-tools-windows-x86_..., mongodb-win32-x86_64-windows-8.2.1, mongosh-2.5.8-win32-x64, vmongd, mongodb-compass-1.47.0-win32-x64.exe (zaznaczone czerwoną ramką), mongodb-database-tools-windows-x86_..., mongodb-windows-x86_64-8.2.1.zip, mongosh-2.5.8-win32-x64.zip.

## Slajd 048 — MongoDB – instalacja

> [Grafika] Zrzut strony mongodb.com (pobieranie MongoDB Community Server). Górne menu: MongoDB, Products, Resources, Solutions, Company, Pricing, Support, Sign In. Lewe menu: MongoDB Atlas, MongoDB Enterprise Advanced, MongoDB Community Edition, MongoDB Community Server (pogrubione), MongoDB Controllers for Kubernetes Operator, MongoDB Search in Community, Tools, SQL Interface.

```
Version: 8.2.1 (current)
Platform: Windows x64
Package: zip
```

Przyciski: Download, Copy link, More Options.

## Slajd 049 — MongoDB konfiguracja uruchamianie

> [Grafika] Kolaż zrzutów:
> - Tabela „MongoDB”: Database Server – mongod; Database Client – mongosh.
> - Eksplorator plików: ...mputer > OS (C:) > data; folder db (strzałka do ramki z napisem C:\data\db), mongodb-database-tools-windows-x86_..., mongodb-win32-x86_64-windows-8.2.1, mongosh-2.5.8-win32-x64, vmongd, mongodb-compass-1.47.0-win32-x64.exe, mongodb-database-tools-windows-x86_..., mongodb-windows-x86_64-8.2.1.zip, mongosh-2.5.8-win32-x64.zip.
> - Eksplorator: Ten komputer > OS (C:) > data > mongodb-windows-x86_64-6.0.7 > bin; pliki Install-Compass.ps1, mongod.exe (podpowiedź: Opis pliku: MongoDB Database Server, Firma: MongoDB, Inc, Wersja pliku: 6.0.7.0, Data utworzenia: 2023-07-02 21:27, Rozmiar: 53,9 MB), mongod.pdb, mongos.exe, mongos.pdb, vc_redist.x64...
> - Konsola C:\data\mongodb-windows-x86_64-6.0.7\bin\mongod.exe z logami JSON uruchamiania serwera (m.in. „Waiting for connections”, port 27017, ssl off).
> - Konsola mongosh (mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000, Using MongoDB: 6.0.7, Using Mongosh: 1.10.1) z ostrzeżeniami startowymi serwera i znakiem zachęty `test>`.
> - Eksplorator: Ten komputer > OS (C:) > data > mongosh-1.10.1-win32-x64 > bin; pliki mongosh.exe, mongosh_crypt_v1.dll.

Tekst z warstwy tekstowej: konfiguracja, uruchamianie

## Slajd 050 — MongoDB for VS Code

> [Grafika] Dwa zrzuty rozszerzeń w VS Code (ciemny motyw).
> - „Extension: MongoDB for VS Code” — MongoDB (mongodb.com), 2,607,422 pobrań, ocena 4,5 gwiazdki (40). Opis: „Connect to MongoDB and Atlas directly from your VS Code environment, navigate”. Przyciski: Disable, Uninstall, Auto Update. Zakładki: DETAILS, FEATURES. Logo: zielony liść MongoDB.
> - „Extension: json” — json, ZainChen, 3,592,610 pobrań, ocena 3,5 gwiazdki (22). Opis: „Json for Visual Studio Code”. Przyciski: Disable, Uninstall, Auto Update. Zakładki: DETAILS, FEATURES, CHANGELOG. Logo: fioletowe koło z napisem „Json”.

## Slajd 051 — MongoDB – konfiguracja VS Code

> [Grafika] Zrzut okna „New Connection” (Manage your connection settings) w VS Code.

```
URI: mongodb://localhost:27017/
Edit Connection String [włączony]
Advanced Connection Options: General | Authentication | TLS/SSL | Proxy/SSH | Advanced
Connection String Scheme: [mongodb] [mongodb+srv]
Standard Connection String Format. The standard format of the MongoDB connection URI is used to connect to a MongoDB deployment: standalone, replica set, or a sharded cluster.
Host: localhost:27017  [+]
[ ] Direct Connection
Specifies whether to force dispatch all operations to the specified host.
[Save & Connect]
```

```
mongodb://localhost:27017/?readPreference=primary&ssl=false
```

## Slajd 052 — MongoDB – konfiguracja VS Code

> [Grafika] Górny zrzut: panel MONGODB w VS Code — CONNECTIONS, localhost:27017 connected, bazy: admin, config, customers, local.

> [Grafika] Dolny zrzut: terminal VS Code (zakładki TERMINAL, PROBLEMS, OUTPUT, DEBUG CONSOLE):

```
PS C:\data\mongosh-1.10.1-win32-x64\bin> .\mongosh.exe
Current Mongosh Log ID: 64a874f7431eda51edfc1528
Connecting to:          mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+1.10.1
Using MongoDB:          6.0.7
Using Mongosh:          1.10.1

For mongosh info see: https://docs.mongodb.com/mongodb-shell/

------
   The server generated these startup warnings when booting
   2023-07-07T22:11:13.271+02:00: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted
   2023-07-07T22:11:13.272+02:00: This server is bound to localhost. Remote systems will be unable to connect to this server. Start the server with --bind_ip <address> to specify which IP addresses it should serve responses from, or with --bind_ip_all to bind to all interfaces. If this behavior is desired, start the server with --bind_ip 127.0.0.1 to disable this warning
------

Warning: Found ~/.mongorc.js, but not ~/.mongoshrc.js. ~/.mongorc.js will not be loaded.
  You may want to copy or rename ~/.mongorc.js to ~/.mongoshrc.js.
test>
```

## Slajd 053 — MongoDB – Docker

```bash
docker run --name mongodb
        -d -p 27017:27017
        mongodb/mongodb-community-server:latest
```

Polecenie to uruchamia kontener MongoDB w tle (detached mode) o nazwie "mongodb", który jest dostępny na hoście na porcie 27017 i używa obrazu "mongodb/mongodb-community-server:latest" jako podstawy.

> [Grafika] Wiersz z Docker Desktop: kontener „mongodb” (id 1520dc92d7ee), obraz mongodb/mongodb-community-server:latest, status Running, 0%, port 27017:27017.

```bash
docker exec -it mongodb mongosh
```

Polecenie to uruchamia interaktywną konsolę MongoDB (mongosh) wewnątrz kontenera o nazwie "mongodb", co pozwala na bezpośrednią interakcję z bazą danych MongoDB działającą w tym kontenerze.

> [Grafika] Zrzut konsoli:

```
C:\>docker exec -it mongodb mongosh
Current Mongosh Log ID: 651b38159fd18b5b8dccd95e
Connecting to:          mongodb://127.0.0.1:27017/?directConn...
...imeoutMS=2000&appName=mongosh+2.0.1
Using MongoDB:          7.0.1
Using Mongosh:          2.0.1

For mongosh info see: https://docs.mongodb.com/mongodb-shell/
```

## Slajd 054 — Zalety bazy danych NoSQL (w kontekście MongoDB):

> [Grafika] Logo mongoDB w prawym górnym rogu.

### Zalety bazy danych NoSQL (w kontekście MongoDB):

- Elastyczny schemat: Łatwo dostosowuje się do zmian bez zakłócania pracy aplikacji.
- Skalowalność pozioma: skalowanie w poziomie przez partycjonowanie danych na wielu serwerach (fragmentowanie).
- Szybki odczyt i zapis: Zaprojektowany z myślą o szybszym odczycie i zapisie, często przy użyciu prostszego języka zapytań niż SQL.
- Obsługa dużych ilości danych: Lepiej nadaje się do zarządzania danymi big data i aplikacjami czasu rzeczywistego.
- Obsługa różnych struktur danych – baza klucz dokument.

### Ograniczenia bazy danych NoSQL:

- Ograniczone możliwości zapytań: niektóre bazy danych NoSQL nie obsługują złożonych zapytań i agregacji lub używają określonych języków zapytań.
- Słabsza spójność: Wiele baz danych NoSQL jest zgodnych z właściwościami BASE (Basically Available, Soft state, Eventual consistency - Zasadniczo dostępna, stan miękki, spójna ostatecznie), które zapewniają słabsze gwarancje spójności niż bazy danych zgodne ze standardem ACID.

## Slajd 055 — Bazy dokumentów (w kontekście MongoDB)

> [Grafika] Logo mongoDB w prawym górnym rogu.

### Model danych

- **Dokumenty**
  - Samo-opisowy model
  - **Możliwość reprezentowania hierarchii** (JSON, XML itp.)
    – Wartości skalarne, mapy, listy, zbiory, zagnieżdżone dokument
  - Posiadające unikalny identyfikator (klucz)
- Dokumenty są **zorganizowane w kolekcje**

**Zapytania**

- Stwórz, zmień, usuń dokument
- **Pobierz dokumenty na podstawie złożonych kryteriów**

**Uwaga**

- Rozszerzone **bazy klucz-wartość** (gdzie część wartości można przeszukiwać).

## Slajd 056 — MongoDB

> [Grafika] Logo mongoDB w prawym górnym rogu.

### Baza dokumentów wykorzystująca JSON

- https://www.mongodb.com/
- Właściwości
  - Open source, wysoka dostępność, ostateczna spójność, automatyczny podział, replikacja master-slave, automatyczna naprawa, możliwość tworzenia dodatkowych indeksów
- Stworzone przez **MongoDB**
- Zaimplementowany w C++, C, i JavaScript
- Systemy operacyjne: m.in. Windows, Linux, Mac OS X
- Pierwsze wydanie w 2009 r.
- Nazwa MongoDB pochodzi od słowa „humongous”, które oznacza „ogromny. Twórcy chcieli podkreślić, że baza jest przeznaczona do obsługi bardzo dużych ilości danych w sposób skalowalny i elastyczny.

## Slajd 057 — MongoDB: / Kluczowe cechy MongoDB:

> [Grafika] Logo mongoDB w prawym górnym rogu.

### MongoDB:

- Baza NoSQL (open source, cross-platform), oparta na dokumentach (BSON).
- Zapewnia wysoką wydajność, dostępność i łatwą skalowalność.
- Elastyczny, pozbawiony schematu model – idealny dla danych nieustrukturyzowanych.

### Kluczowe cechy MongoDB:

**Zorientowany na dokumenty** - MongoDB przechowuje dane w dokumentach podobnych do JSON (format BSON), co oznacza, że model danych jest bardzo elastyczny i może łatwo dostosować się do rzeczywistych reprezentacji obiektów.

**Skalowalność** - MongoDB oferuje automatyczne skalowanie, ponieważ można go skalować w poziomie przez sharding (partycjonowanie danych na wielu serwerach) i w pionie przez dodawanie pojemności pamięci masowej, CPU i RAM.

**Indeksowanie** - Aby zwiększyć wydajność zapytań, baza danych MongoDB obsługuje indeksowanie dowolnego atrybutu w dokumencie.

**Replikacja** - MongoDB zapewnia wysoką dostępność za pośrednictwem zestawów replik, które są węzłami podstawowymi i pomocniczymi, które utrzymują kopie danych.

**Agregacja** - MongoDB oferuje zaawansowaną strukturę agregacji do wykonywania złożonych operacji na danych, takich jak transformacje, filtrowanie i sortowanie.

**Obsługa zapytań ad hoc** - MongoDB obsługuje wyszukiwanie według pól, zakresów i wyrażeń regularnych.

## Slajd 058 — Kiedy używać MongoDB:

> [Grafika] Logo mongoDB w prawym górnym rogu.

### Kiedy używać MongoDB:

MongoDB to odpowiedni wybór w wielu scenariuszach, szczególnie gdy potrzebna jest elastyczność i skalowalność:

- **Big Data**: Elastyczny model dokumentowy (JSON/BSON) oraz skalowalność pozioma przez sharding sprawiają, że MongoDB świetnie nadaje się do przechowywania i przetwarzania dużych ilości danych nieustrukturyzowanych lub częściowo ustrukturyzowanych.
- **Analityka w czasie rzeczywistym**: Silnik agregacji, indeksy (w tym geolokalizacyjne i tekstowe) oraz możliwość pracy w klastrach pozwalają na szybkie przetwarzanie i analizę danych w czasie rzeczywistym.
- **Zarządzanie treścią**: Dzięki dynamicznemu schematowi MongoDB obsługuje różne typy treści bez konieczności migracji schematów, co jest idealne dla aplikacji CMS i platform e-commerce.
- **Aplikacje Internetu rzeczy (IoT)**: MongoDB może gromadzić dane z milionów urządzeń i czujników, zapewniając skalowalność i możliwość szybkiego zapisu dużych wolumenów danych.
- **Aplikacje mobilne**: Elastyczny model danych i wsparcie dla offline-first (np. przez MongoDB Realm) sprawiają, że MongoDB dobrze pasuje do aplikacji mobilnych o zmiennych strukturach danych.
- **Aplikacje chmurowe i mikroserwisy**: MongoDB jest naturalnym wyborem dla architektur opartych na mikroserwisach, gdzie każdy serwis może mieć własny model danych.

## Slajd 059 — Skalowalność pozioma i pionowa - MongoDB:

> [Grafika] Logo mongoDB w prawym górnym rogu. Poniżej tabela (obraz).

| Cecha | Skalowalność pozioma (Horizontal) | Skalowalność pionowa (Vertical) |
|---|---|---|
| Definicja | Dodawanie kolejnych serwerów (shardów) do klastra | Zwiększanie zasobów jednego serwera |
| Mechanizm w MongoDB | **Sharding** – dane dzielone na fragmenty (chunki) rozproszone na wielu shardach | Zwiększenie CPU, RAM, przestrzeni dyskowej |
| Złożoność wdrożenia | Wysoka – wymaga konfiguracji shard key, config servers, mongos routerów | Niska – zmiana parametrów maszyny lub instancji |
| Limit skalowania | Bardzo wysoki – można dodawać kolejne serwery | Ograniczony – zależy od maksymalnej specyfikacji sprzętu |
| Koszt | Wyższy początkowo (więcej serwerów, sieć), ale lepsza skalowalność w długim okresie | Niższy początkowo, ale rośnie wykładniczo przy dużych wymaganiach |
| Wpływ na wydajność | Rozkłada obciążenie zapisu i odczytu na wiele węzłów | Poprawia wydajność tylko jednego węzła |
| Przykład zastosowania | Aplikacje z ogromną ilością danych i wysoką liczbą zapytań | Małe/średnie aplikacje, gdzie wystarczy mocniejszy serwer |

## Slajd 060 — MongoDB to popularny system baz danych NoSQL

> [Grafika] Logo mongoDB w prawym górnym rogu.

MongoDB to popularny system baz danych NoSQL, który przechowuje dane w elastycznych dokumentach JSON (BJSON), dzięki czemu nadaje się do pracy z danymi na dużą skalę i nieustrukturyzowanymi. Został on zaprojektowany z myślą o elastyczności, wydajności i skalowalności.

- **Baza danych**: przechowuje wszystkie kolekcje w wystąpieniu bazy danych MongoDB.
- **Kolekcja:** grupa powiązanych dokumentów, podobna do tabeli w relacyjnej bazie danych.
- **Dokument:** pojedynczy rekord w kolekcji, który jest przechowywany w formacie BSON (binarny kod JSON).
- **Pole:** para klucz-wartość w dokumencie.
- **_id:** unikatowy identyfikator generowany automatycznie dla każdego dokumentu w kolekcji.

## Slajd 061 — Podstawowe operacje:

> [Grafika] Logo mongoDB w prawym górnym rogu.

### Podstawowe operacje:

**Wyszukiwanie (find):**
Pobierz dokumenty z kolekcji i przefiltruj wyniki za pomocą kryteriów zapytania `db.collection.find()`.
Aby pobrać tylko jeden dokument, użyj `db.collection.findOne()`.

**Wstawianie (insert):**
Aby wstawić pojedynczy dokument, użyj polecenia `db.collection.insertOne()`.
Aby wstawić wiele dokumentów, użyj `db.collection.insertMany()`.

**Aktualizacja (update):**
Aktualizuj pola lub całe dokumenty przy użyciu operatorów aktualizacji `$set`, `$unset`, poleceń `db.collection.updateOne()`, `db.collection.updateMany()`

**Usuwanie (delete):**
Usuwanie dokumentów z kolekcji przy użyciu kryteriów zapytania `db.collection.deleteOne()` i `db.collection.deleteMany()`

**Usuwanie obiektów (drop):**
Trwale usuń kolekcję lub bazę danych za pomocą `db.collection.drop()` i `db.dropDatabase()`

## Slajd 062 — Indeksy i agregacje:

> [Grafika] Logo mongoDB w prawym górnym rogu.

### Indeksy i agregacje:

**Indeksy:**
Zwiększ wydajność wyszukiwania, tworząc indeksy dla pól w kolekcji `db.collection.createIndex()`

**Agregacje:**
Wykonuj złożone zadania przetwarzania danych, takie jak filtrowanie, grupowanie, przekształcanie i sortowanie, przy użyciu operacji agregacji, takich jak `$match`, `$group`, `$project` czy `$sort`.

## Slajd 063 — Modelowanie danych:

> [Grafika] Logo mongoDB w prawym górnym rogu.

### Modelowanie danych:

Elastyczny model dokumentowy MongoDB umożliwia różne sposoby organizacji danych:

- **Dokumenty osadzone (Embedded Documents)**
  - Powiązane dane przechowywane w jednym dokumencie.
  - Najlepsze dla relacji **1:1** oraz **1:N** o ograniczonej liczbie elementów.
  - Zapewniają szybki odczyt danych.
- **Referencje (References)**
  - Dane przechowywane w oddzielnych kolekcjach i łączone za pomocą identyfikatorów.
  - Odpowiednie dla relacji **1:N** oraz **N:N**.
  - Ułatwiają zarządzanie dużymi i współdzielonymi zbiorami danych.
- **Podejście hybrydowe**
  - Łączy dokumenty osadzone i referencje.
  - Pozwala znaleźć równowagę między wydajnością, elastycznością i wykorzystaniem pamięci.

**Podsumowanie -** MongoDB oferuje elastyczne modelowanie danych, dzięki czemu dobrze sprawdza się w aplikacjach przetwarzających duże wolumeny danych, dane półstrukturalne oraz szybko zmieniające się modele biznesowe.

## Slajd 064 — Modelowanie danych: Dokumenty osadzone

### Modelowanie danych:

**Dokumenty osadzone**

**Kiedy używać tablic dokumentów osadzonych**

Rozważ użycie tablic dokumentów osadzonych, gdy:
- Mamy relację jeden-do-wielu,
- Osadzone dane nie rosną w sposób nieograniczony,
- Osadzone dane są ściśle powiązane z dokumentem nadrzędnym,
- Możemy skorzystać z ulepszonej wydajności odczytu/zapisu.

Należy pamiętać, że MongoDB ma ograniczenie rozmiaru dokumentu do 16 MB (alternatywne podejścia w takich sytuacjach, to użycie oddzielnych kolekcji i odwoływanie się do nich).

**Zalety**

Tablice dokumentów osadzonych mają kilka kluczowych zalet:
- **Wydajność odczytu/zapisu**: Ponieważ powiązane dane są przechowywane razem w tym samym dokumencie, operacje odczytu i zapisu mogą być szybsze, ponieważ nie wymagają wielu zapytań ani aktualizacji.
- **Spójność danych**: Przechowując powiązane dane razem, można łatwo zachować spójność i zapewnić, że powiązane dane są zawsze zsynchronizowane bez konieczności polegania na sprzężeniach lub odsyłaczach.
- **Skalowalność**: Wbudowane tablice mogą być zagnieżdżane, co pozwala na reprezentowanie złożonych struktur danych przy jednoczesnym zachowaniu korzyści płynących z elastycznego schematu i wysokiej wydajności.

> [Grafika] W prawym górnym rogu zrzut dokumentu JSON (kolorowanie składni):

```json
{
  "_id": 1,
  "name": "John Doe",
  "addresses": [
    {
      "street": "123 Main St",
      "city": "New York",
      "zipcode": "10001"
    },
    {
      "street": "456 Broadway",
      "city": "Los Angeles",
      "zipcode": "90001"
    }
  ]
}
```

## Slajd 065 — BSON vs JSON:

> [Grafika] Logo mongoDB w prawym górnym rogu.

### BSON vs JSON:

W MongoDB dane są przechowywane w formacie binarnym o nazwie BSON (Binary JSON), który jest nadzbiorem JSON (JavaScript Object Notation). Chociaż zarówno BSON, jak i JSON są używane do reprezentowania danych w MongoDB, mają one kilka kluczowych różnic.

**BSON** to serializacja dokumentów podobnych do JSON zakodowana binarnie. Został zaprojektowany tak, aby był wydajny w przechowywaniu, przechodzeniu i kodowaniu/dekodowaniu.
Niektóre z jego kluczowych cech to:
- **Kodowanie binarne**: BSON koduje dane w formacie binarnym, który zapewnia lepszą wydajność i umożliwia przechowywanie typów danych nieobsługiwanych przez JSON.
- **Obsługa dodatkowych typów danych**: BSON obsługuje więcej typów danych w porównaniu z formatem JSON, takich jak Date, Binary, ObjectId czy Decimal128. Dzięki temu możliwe jest dokładniejsze reprezentowanie różnorodnych danych w dokumentach
- **Wydajne przeszukiwanie**: W BSON rozmiar, każdego elementu jest zakodowany, co ułatwia pomijanie elementów, przyspieszając w ten sposób przechodzenie.

## Slajd 066 — BSON vs JSON:

> [Grafika] Logo mongoDB w prawym górnym rogu.

### BSON vs JSON:

**JSON** to lekki i czytelny dla człowieka format reprezentacji danych, który może być łatwo analizowany i generowany przez wiele języków programowania. Jest szeroko stosowany jako medium do przesyłania danych przez sieć. Niektóre funkcje formatu JSON obejmują:
- **Czytelny dla człowieka**: JSON to tekst o prostej strukturze, co ułatwia ludziom odczytywanie i pisanie.
- **Interoperacyjność**: JSON może być łatwo analizowany i generowany przez wiele różnych języków programowania, co czyni go popularnym wyborem do wymiany danych między aplikacjami.
- **Ograniczone typy danych**: JSON obsługuje mniej typów danych w porównaniu z BSON, takich jak ciągi, liczby, wartości logiczne i null. Oznacza to, że niektóre dane, takie jak daty lub dane binarne, muszą być reprezentowane jako ciągi lub obiekty niestandardowe w formacie JSON.

## Slajd 067 — BSON vs JSON:

> [Grafika] Logo mongoDB w prawym górnym rogu.

### BSON vs JSON:

**Podsumowanie**

Chociaż BSON i JSON są powiązane, służą różnym celom w kontekście MongoDB:
- BSON to format binarny używany przez MongoDB do wydajnego przechowywania i pobierania danych z obsługą dodatkowych natywnych typów danych.
- JSON, będący formatem bardziej czytelnym dla człowieka i powszechnie używanym, jest zwykle używany do wymiany danych między MongoDB a aplikacjami.

Korzystając wewnętrznie z BSON, MongoDB może wykorzystać jego zalety w zakresie przechowywania, przechodzenia i bogatszej reprezentacji typu danych, zapewniając jednocześnie interoperacyjność i czytelność JSON za pośrednictwem interfejsów zapytań i sterowników.

## Slajd 068 — BSON vs JSON:

> [Grafika] Logo mongoDB w prawym górnym rogu.

### BSON vs JSON:

> [Grafika] Tabela (obraz):

| Cecha | JSON | BSON |
|---|---|---|
| Pełna nazwa | JavaScript Object Notation | Binary JSON |
| Format | Tekstowy (czytelny dla człowieka) | Binarny (optymalizowany dla maszyn) |
| Typy danych | Podstawowe: string, number, boolean, array, object | Rozszerzone: dodatkowo `Date`, `Binary`, `Decimal128`, `ObjectId` |
| Rozmiar | Większy (brak kompresji, tekstowy zapis) | Mniejszy (binarny zapis, bardziej kompaktowy) |
| Wydajność | Wolniejszy przy serializacji/deserializacji | Szybszy, zoptymalizowany pod kątem MongoDB |
| Obsługa hierarchii | Tak, ale tylko podstawowe typy | Tak, z dodatkowymi typami i metadanymi |
| Zastosowanie | Wymiana danych w API, konfiguracje | Przechowywanie danych w MongoDB |

## Slajd 069 — Typy danych:

> [Grafika] Logo mongoDB w prawym górnym rogu.

### Typy danych:

Zrozumienie typów danych jest niezbędne, ponieważ odgrywają one kluczową rolę w projektowaniu schematów i wydajności zapytań.

**Identyfikator obiektu** - ObjectId to 12-bajtowy identyfikator używany jako unikatowy identyfikator dokumentów w kolekcji. Jest to wartość domyślna generowana dla pola, zapewniająca unikatowość w obrębie kolekcji. W formacie hex ma 24 znaki (1 bajt – 2 znaki hex).

> [Grafika] Diagram: kolumna żółtych kafelków z nazwami typów BSON, przy każdym (lewy/prawy bok) mały ramkowany przykład JSON:
> - Int32 / Int — `{ "age": 28 }`
> - Double — `{ "price": 12.99 }`
> - String — `{ "name": "John Doe" }`
> - Array — `{ "tags": ["mongodb", "database", "noSQL"] }`
> - Object — `{ "address": { "street": "123 Main St", "city": "..." } }` (ucięte)
> - Binary data — `{ "data": BinData(0, "c3VyZS4=") }`
> - Undefined — kafelek przekreślony niebieską linią (bez przykładu)
> - ObjectId — `"_id": ObjectId("60c4237a89293ddc1ef23245")`
> - Boolean — `{ "isActive": true }`
> - Date — `"createdAt": ISODate("2019-02-18T19:29:22.381Z")`
> - Null — `{ "middleName": null }`
> - Regular Expression — `{ "pattern": /^mongodb/i }`

## Slajd 070 — Przykład zapytań

### Kolekcja filmów

```json
{
  "_id": { "$oid": "68ee7c5c946a76306740e1c0" },
  "title": "Niezniszczalni",
  "year": 2020
},
{
  "_id": { "$oid": "68ee7c5c946a76306740e1c1" },
  "title": "Tomb Raider",
  "year": 2021
},
{
  "_id": { "$oid": "68ee7c5c946a76306740e1c2" },
  "title": "Hobbit",
  "year": 2022
}
```

### Wstawienie danych do kolekcji

```js
use('DB1');

db.movies.insertMany([
  { title: "Niezniszczalni", year: 2020 },
  { title: "Tomb Raider", year: 2021 },
  { title: "Hobbit", year: 2022 }
]);
```

### Zapytanie

Tytuły filmów z 2021  roku i później posortowane malejąco

```js
db.movies.find(
    {year:{$gt:2020}},
    {_id:0, title:1}
).sort({title:-1});
```

### Rezultat

```json
[
  { "title": "Tomb Raider" },
  { "title": "Hobbit" }
]
```

## Slajd 071 — Model danych

### Struktura bazy danych

Instancja → **bazy danych** → **kolekcje** → **dokumenty**

- Baza danych
- Kolekcja
  - Zbiór dokumentów, z reguły o podobnej strukturze
- Dokument
  - **document = jeden obiekt JSON**
    - tj. złożony obiekt JSON z innymi zagnieżdżonymi obiektami, tablicami czy wartościami
    - Każdy dokument ma **unikalny identyfikator** (klucz główny)
    - Często realizowany jako **_poleId**

## Slajd 072 — Model danych

### Dokument MongoDB

- Wewnętrznie zapisany w formacie BSON (*Binary JSON*)
  - Maksymalny rozmiar to 16 MB
  - GridFS może być użyty by podzielić większe pliki na części

**Restrykcje co do pól**

- **Id najwyższego poziomu** zarezerwowane dla **klucza głównego**
- Nazwy pól **nie mogą się zaczynać od** $ (i nie mogą go zawierać).
  - $ jest zarezerwowany dla operacji zapytań
  - . jest używany do pobierania zagnieżdżonych pól
- Porządek pól jest zachowany
  - Za wyjątkiem _póllId przenoszonych na początek
- **Nazwy pól muszą być unikalne**

> [Grafika] Zrzut fragmentu dokumentu JSON (jasny tekst na turkusowym tle, ucięty po prawej):

```json
{
  "_id": "10021707",
  "listing_url": "https://www.airbnb.com/rooms/10021707",
  "name": "Private Room in Bushwick",
  "summary": "Here exists a very cozy room for rent in a s
```

## Slajd 073 — BinData vs GridFS

| Cecha | BinData | GridFS |
|---|---|---|
| Limit rozmiaru | Do **16 MB** (limit dokumentu) | Praktycznie dowolny (plik dzielony na chunki) |
| Strumieniowanie | ❌ | ✅ (upload/download, wznawianie) |
| Częściowe odczyty | Ograniczone (cały dokument) | ✅ (chunki, zakresy) |
| Struktura | Pole `BinData` w dokumencie | Dwie kolekcje: `fs.files` + `fs.chunks` |
| Indeksowanie | Jak dla dokumentu | Wbudowany wzorzec indeksu `{ files_id: 1, n: 1 }` |
| Złożoność | Niska | Średnia (więcej elementów, API GridFS) |
| Typowe użycie | Miniatury, certyfikaty, klucze, małe załączniki | Duże pliki: zdjęcia, PDF, wideo, archiwa, backupy |
| Transakcje | Jak dla dokumentu | Wspierane per operacje/chunki (zależnie od wersji/drivera) |
| Dostarczanie przez CDN | Tak, ale zwykle lepiej poza DB | Często łączone z warstwą serwującą/streamingiem |

> [Grafika] Tabela jako obraz; w kolumnie BinData przy „Strumieniowanie” czerwony krzyżyk, w kolumnie GridFS zielone znaczniki wyboru.

## Slajd 074 — Klucze główne

### Właściwości identyfikatorów:

- **Unikalne** w ramach kolekcji
- **Niemutowalne** (nie mogą być zmienione po przypisaniu)
- Mogą być **dowolnego typu (poza tablicą)**

### Zarządzanie kluczami:

- Naturalny identyfikator
- Auto-inkrement – nie zalecane
- UUID (ang. *Universally Unique Identifier*)
- **ObjectId** – **specjalny typ BSON** (domyślnie)
  Niewielki, unikalny, szybki do wygenerowania, bazujący na czasie, odciskowi maszyny i procesu

> [Grafika] Zrzut dokumentu JSON (niebieskie tło) w prawym dolnym rogu:

```json
{
  "_id": {
    "$oid": "628ea0b6a5b28a3c7e9e3027"
  },
  "firstName": "Patryk",
  "lastName": "Bez",
  "created_date": "2021-07-07"
}
```

## Slajd 075 — Pytania projektowe

**Modelowanie danych** (w ramach **kolekcji** i **dokumentów**)

- Brak jawnego schematu
  - Jednakże…
    – Dokumenty są do siebie najczęściej podobne
    – **Niejawny schemat** i tak jest wymagany
- Wyzwanie
  - Zbalansowanie wydajności i stopnia skomplikowania struktury

Najważniejsze koncepcje

- Referencje
- Zagnieżdżone dokumenty

## Slajd 076 — Zdenormalizowany model

### Zagnieżdżone dokumenty

- Powiązane ze sobą dane w ramach 1 dokumentu
  - Zagnieżdżone obiekty JSON, nazywane poddokumentami
- Zaleta: mniej zapytań jest potrzebnych
- Wada: możliwa duża redundancja
- Dobre do modelowania związków **jeden-do-jeden** czy **jeden-do-wielu**

```js
{
    _id: ObjectId("2"), title: "Tomb Raider", year: 2001,  actors: [
      { firstname: "Angelina", lastname: "Jolie" },
      { firstname: "Jon", lastname: "Voight" },
      { firstname: "Noah", lastname: "Taylor" }
    ]
}
```

> [Grafika] Dolny prawy ramkowany przykład z adnotacjami „Embedded sub-document” (zielone nawiasy klamrowe przy `contact` i `access`):

```js
{
  _id: <ObjectId1>,
  username: "123xyz",
  contact: {
              phone: "123-456-7890",
              email: "xyz@example.com"
           },
  access: {
             level: 5,
             group: "dev"
          }
}
```

## Slajd 077 — Znormalizowany model

### Referencje

- Powiązane dane znajdują się w różnych dokumentach
  - Powiązania realizowane przez odsyłacze (referencje)
  - Praktycznie realizowane wykorzystując **wartości stanowiące identyfikatory dokumentów** (brak specjalnego typu)
- Właściwości: większa elastyczność, ale więcej zapytań może być wymaganych
- Dobre do reprezentowania związków **wiele-do-wielu**

```js
{
    _id: ObjectId("2"),
    title: "Tomb Raider",
    year: 2001,
    actors: [ ObjectId("6"),
              ObjectId("4"),
              ObjectId("5") ]
}
```

> [Grafika] Strzałka z tego dokumentu (od `ObjectId("6")` w tablicy `actors`) do drugiego dokumentu; wielokropek „...” obok (kolejne dokumenty aktorów):

```js
{
    _id: ObjectId("6"),  firstname: "Ian", lastname: "Glen"
}
```

Podpis: Dane referencyjne w schemacie MongoDB

> [Grafika] W prawym dolnym rogu ramkowany diagram trzech dokumentów połączonych zielonymi strzałkami (podświetlone pola `user_id`):
> - user document: `{ _id: <ObjectId1>, username: "123xyz" }`
> - contact document: `{ _id: <ObjectId2>, user_id: <ObjectId1>, phone: "123-456-7890", email: "xyz@example.com" }`
> - access document: `{ _id: <ObjectId3>, user_id: <ObjectId1>, level: 5, group: "dev" }`
> Strzałki prowadzą od `user_id` w contact i access do `_id` w user document.

## Slajd 078 — Osadzenie dokumentu wydawcy wewnątrz dokumentu książki powtarza dane wydawcy

```js
{
   title: "MongoDB: The Definitive Guide",
   author: [ "Kristina Chodorow", "Mike Dirolf" ],
   published_date: ISODate("2010-09-24"),
   pages: 216,
   language: "English",
   publisher: {
              name: "O'Reilly Media",
              founded: 1980,
              location: "CA"
            }
}

{
   title: "50 Tips and Tricks for MongoDB Developer",
   author: "Kristina Chodorow",
   published_date: ISODate("2011-05-06"),
   pages: 68,
   language: "English",
   publisher: {
              name: "O'Reilly Media",
              founded: 1980,
              location: "CA"
            }
}
```

> [Grafika] Zielona ramka wokół obu dokumentów; w każdym z nich pole `publisher` (z zawartością) podświetlone jasnożółtym tłem.

## Slajd 079 — Rozwój relacji decyduje o tym, gdzie przechowywać referencję

Rozwój relacji decyduje o tym, gdzie przechowywać referencję. Jeśli liczba książek na wydawcę jest niewielka i wzrost ograniczony, przechowaj odniesienie książkowe w dokumencie wydawcy. Jeśli liczba książek na wydawcę jest nieograniczona, ten model danych tworzy zmienne, rosnące tablice. Aby uniknąć zmiennych, rosnących tablic, przechowuj odniesienie wydawcy w dokumencie książki

(Fragment „Jeśli liczba książek na wydawcę jest niewielka i wzrost ograniczony, przechowaj odniesienie książkowe w dokumencie wydawcy.” jest zielony, fragment „Aby uniknąć zmiennych, rosnących tablic, przechowuj odniesienie wydawcy w dokumencie książki” niebieski.)

> [Grafika] Lewy panel (zielona ramka) — referencje w dokumencie wydawcy; niebieskie strzałki od pola `books` do `_id` dwóch książek:

```js
{
   name: "O'Reilly Media",
   founded: 1980,
   location: "CA",
   books: [123456789, 234567890, ...]
}

{
   _id: 123456789,
   title: "MongoDB: The Definitive Guide",
   author: [ "Kristina Chodorow", "Mike Dirolf" ],
   published_date: ISODate("2010-09-24"),
   pages: 216,
   language: "English"
}

{
   _id: 234567890,
   title: "50 Tips and Tricks for MongoDB Developer",
   author: "Kristina Chodorow",
   published_date: ISODate("2011-05-06"),
   pages: 68,
   language: "English"
}
```

(Pole `books` podświetlone jasnożółtym tłem.)

> [Grafika] Prawy panel (niebieska ramka) — referencja w dokumencie książki; czerwone strzałki od `_id: "oreilly"` do pól `publisher_id` w obu książkach:

```js
{
   _id: "oreilly",
   name: "O'Reilly Media",
   founded: 1980,
   location: "CA"
}

{
   _id: 123456789,
   title: "MongoDB: The Definitive Guide",
   author: [ "Kristina Chodorow", "Mike Dirolf" ],
   published_date: ISODate("2010-09-24"),
   pages: 216,
   language: "English",
   publisher_id: "oreilly"
}

{
   _id: 234567890,
   title: "50 Tips and Tricks for MongoDB Developer",
   author: "Kristina Chodorow",
   published_date: ISODate("2011-05-06"),
   pages: 68,
   language: "English",
   publisher_id: "oreilly"
}
```

(Pola `publisher_id` podświetlone jasnożółtym tłem.)

## Slajd 080 — Modelowanie relacji jeden do jednego / jeden do wielu z osadzonymi dokumentami

### Modelowanie relacji jeden do jednego z osadzonymi dokumentami

```js
{
   _id: "joe",
   name: "Joe Bookreader",
   address: {
              street: "123 Fake Street",
              city: "Faketon",
              state: "MA",
              zip: "12345"
            }
}
```

(w zielonej ramce)

### Modelowanie relacji jeden do wielu z osadzonymi dokumentami

```js
{
   _id: "joe",
   name: "Joe Bookreader",
   addresses: [
      {
         street: "123 Fake Street",
         city: "Faketon",
         state: "MA",
         zip: "12345"
      },
      {
         street: "1 Some Other Street",
         city: "Boston",
         state: "MA",
         zip: "12345"
      }
   ]
}
```

(w niebieskiej ramce)

## Slajd 081 — Modelowanie relacji wiele do wielu z osadzonymi dokumentami

```js
{
   _id: "book001",
   title: "Cell Biology",
   authors: [
     {
        author_id: "author124",
        name: "Ellie Smith"
     },
     {
        author_id: "author381",
        name: "John Palmer"
     }
   ]
}
```

```js
{
   _id: "book002",
   title: "Organic Chemistry",
   authors: [
     {
        author_id: "author290",
        name: "Jane James"
     },
     {
        author_id: "author381",
        name: "John Palmer"
     }
   ]
}
```

> [Grafika] Dwa dokumenty obok siebie w niebieskich ramkach; w każdym element tablicy `authors` z `author_id: "author381"` i `name: "John Palmer"` zaznaczony czerwoną ramką (ten sam autor osadzony w obu książkach).

## Slajd 082 — Antywzorce projektowania schematów

| Antywzorzec projektowania schematu | Definicja |
|---|---|
| Unikaj tablic nieograniczonych | Dokument przechowuje nieograniczoną tablicę, która może urosnąć do zbyt dużej odległości. Duża tablica może przekroczyć limit rozmiaru dokumentu i spowodować spadek wydajności indeksu. |
| Zmniejszenie liczby zbiorów | Tworzysz dużą liczbę kolekcji w swojej bazie danych. Zbyt wiele kolekcji może obniżyć wydajność silnika pamięci. |
| Usuń niepotrzebne indeksy | Twoja kolekcja zawiera zbędne indeksy. Niepotrzebne indeksy zajmują dodatkową przestrzeń na dysku i mogą pogorszyć wydajność zapisu. |
| Ogranicz nadmiar dokumentów | Twoja kolekcja zawiera bardzo obszerne dokumenty. Duże dokumenty mogą pogorszyć wydajność najczęściej wykonywanych zapytań. |
| Ograniczenie $lookup eksploatacji | Wykonujesz zbyt wiele operacji $lookup na swoich danych. Zwiększa to złożoność zapytań i obniża wydajność zapytań. |

## Slajd 083 — Interfejs aplikacyjny

**mongoshell**

- **Interaktywna linia komend MongoDB**
- ./bin/mongo --username użytkownik --password hasło --host host --port 28015

(słowa „użytkownik”, „hasło”, „host” wyróżnione kolorem pomarańczowym)

**Sterowniki**

- Java, C, C++, C#, Perl, PHP, Python, Ruby, Scala, itp.

> [Grafika] Po prawej stronie rozwijana lista wyboru języka/narzędzia (z zielonym liściem MongoDB i napisem „MongoDB Shell” na przycisku), z zaznaczoną opcją pierwszą (ptaszek): MongoDB Shell, Compass, C#, Go, Java (Async), Java (Sync), Motor, Node.js, Perl, PHP, Python, Ruby, Scala.

> [Grafika] Trzy przykłady kodu z dokumentacji MongoDB (każdy z listą wyboru języka):

MongoDB Shell:
```js
db.inventory.find( {} )
```

Node.js:
```js
const cursor = db.collection('inventory').find({ item: 'canvas' });
```

Python:
```python
cursor = db.inventory.find({"item": "canvas"})
```

## Slajd 084 — Język zapytań

> [Grafika] Infografika „Język zapytań” z logo MongoDB (zielony liść). Podtytuł: „Zapytania w MongoDB (shell / mongosh) bazują na JavaScript”.

Zielona ramka w prawym górnym rogu:
- Pojedyncza komenda lub cały zestaw
- Zapytania odczytu zwracają cursor
  - Umożliwia iterowanie po wybranych dokumentach
- Każda komenda dotyczy pojedynczej kolekcji

Lewy panel (ciemnozielony) — struktura: MongoDB → Baza danych „sklep” → Kolekcja „produkty” z dokumentami:

```js
{
  _id: ObjectId("..."),
  nazwa: "Laptop",
  kategoria: "Elektronika",
  cena: 4999,
  ocena: 4.5
}
{
  _id: ObjectId("..."),
  nazwa: "Mysz",
  kategoria: "Elektronika",
  cena: 99,
  ocena: 4.8
}
...
```

Sekcja „Jak działa zapytanie?”: po lewej pole „Aplikacja / mongosh (JavaScript)” z kodem:

```js
db.produkty.find({
    kategoria: "Elektronika"
})
```

Zielona strzałka ciągła w prawo „Zapytanie (JavaScript)” do ikony bazy (cylinder z liściem, podpis „MongoDB”); przerywana zielona strzałka w lewo „Wynik (cursor)”. Z bazy linia do ramki „Cursor – wynik zapytania”:

```js
> const cursor = db.produkty.find({
    kategoria: "Elektronika"
  })
> cursor.forEach(doc => print(doc))
// Zwraca kolejne dokumenty
{
  _id: ObjectId("..."),
  nazwa: "Laptop",
  kategoria: "Elektronika",
  cena: 4999,
  ocena: 4.5
}
...
```

Sekcja „Podstawowe operacje CRUD (na pojedynczej kolekcji)” — cztery kafelki:

Create – dodawanie (zielony):
```js
db.produkty.insertOne({
  nazwa: "Klawiatura",
  kategoria: "Elektronika",
  cena: 199,
  ocena: 4.7
})
```

Read – odczyt (niebieski):
```js
db.produkty.find({
  cena: { $gt: 100 }
})
```

Update – aktualizacja (pomarańczowy):
```js
db.produkty.updateOne(
  { _id: ObjectId("...") },
  { $set: { cena: 179 } }
)
```

Delete – usuwanie (czerwony):
```js
db.produkty.deleteOne({
  _id: ObjectId("...")
})
```

Sekcja „Agregacje (MapReduce, grupowanie)”:

Pipeline agregacji (grupowanie):
```js
db.produkty.aggregate([
  { $group: {
      _id: "$kategoria",
      liczba: { $sum: 1 },
      sredniaCena: { $avg: "$cena" }
  }}
])
```

Strzałka w prawo do ramki „Wynik agregacji”:
```js
[
  { _id: "Elektronika", liczba: 12, sredniaCena: 1250 },
  { _id: "Akcesoria",   liczba: 8,  sredniaCena: 85 }
]
```

Po prawej fioletowy kafelek: „MapReduce – zaawansowane przetwarzanie danych w MongoDB”.

## Slajd 085 — SQL vs MongoDB - pojęcia

| SQL Terms/Concepts | MongoDB Terms/Concepts |
|---|---|
| database | database |
| table | collection |
| row | document or BSON document |
| column | field |
| index | index |
| table joins | `$lookup`, embedded documents |
| primary key | primary key |
| Specify any unique column or column combination as primary key | In MongoDB, the primary key is automatically set to the `_id` field |

## Slajd 086 — Przykłady

Różne polecenia SQL i odpowiadające im polecenia MongoDB przedstawione są na następnych slajdach.

Przykłady zakładają następujące warunki:

- Przykłady SQL zakładają tabelę o nazwie people.
- Przykłady MongoDB zakładają kolekcję o nazwie people zawierającej dokumenty następującego prototypu:

```js
{
  _id: ObjectId("509a8fb2f3f4948bd2f983a0"),
  user_id: "abc123",
  age: 55,
  status: 'A'
}
```

https://www.mongodb.com/docs/manual/reference/sql-comparison/

## Slajd 087 — Instrukcje schematu SQL / Oświadczenia schematu MongoDB

> [Grafika] Zrzut z dokumentacji MongoDB (porównanie SQL i MongoDB), dwie kolumny: „Instrukcje schematu SQL” (lewa) i „Oświadczenia schematu MongoDB” (prawa).

**Instrukcje schematu SQL**

```sql
CREATE TABLE people (
    id MEDIUMINT NOT NULL
        AUTO_INCREMENT,
    user_id Varchar(30),
    age Number,
    status char(1),
    PRIMARY KEY (id)
)
```

```sql
ALTER TABLE people
ADD join_date DATETIME
```

**Oświadczenia schematu MongoDB**

Niejawnie utworzony podczas pierwszej `insertOne()` lub `insertMany()` operacji. Klucz podstawowy `_id` jest dodawany automatycznie, jeśli `_id` pole nie jest określone.

```js
db.people.insertOne( {
    user_id: "abc123",
    age: 55,
    status: "A"
 } )
```

Możesz jednak także jawnie utworzyć kolekcję:

```js
db.createCollection("people")
```

Zbiory nie opisują ani nie wymuszają struktury swoich dokumentów; tj. nie ma zmian strukturalnych na poziomie kolekcji.

Jednak na poziomie dokumentu `updateMany()` operacje mogą dodawać pola do istniejących dokumentów za pomocą `$set` operatora.

```js
db.people.updateMany(
    { },
    { $set: { join_date: new Date() } }
)
```

> [Grafika] W lewym dolnym rogu zrzut dokumentu JSON na niebieskim tle (ucięty):

```json
{
  "_id": {
    "$oid": "6524596d69f926135a434904"
  },
  "test_id": 1,
  "age": 100
```

## Slajd 088 — (bez tytułu) SQL vs MongoDB: ALTER/DROP/INDEX

> [Grafika] Zrzut z dokumentacji MongoDB, lewa kolumna SQL, prawa MongoDB.

```sql
ALTER TABLE people
DROP COLUMN join_date
```

Zbiory nie opisują ani nie wymuszają struktury swoich dokumentów; tj. nie ma zmian strukturalnych na poziomie kolekcji.

Jednak na poziomie dokumentu `updateMany()` operacje mogą usuwać pola z dokumentów za pomocą `$unset` operatora.

```js
db.people.updateMany(
    { },
    { $unset: { "join_date": "" } }
)
```

```sql
CREATE INDEX idx_user_id_asc
ON people(user_id)
```

```js
db.people.createIndex( { user_id: 1 } )
```

```sql
CREATE INDEX
        idx_user_id_asc_age_desc
ON people(user_id, age DESC)
```

```js
db.people.createIndex( { user_id: 1, age: -1 } )
```

(blok kodu z poziomym paskiem przewijania; fragment ucięty po prawej)

```sql
DROP TABLE people
```

```js
db.people.drop()
```
## Slajd 089 — MongoDB – dodawanie i usuwanie bazy danych

> [Grafika] Zrzut ekranu konsoli (niebieskie tło) z wynikiem polecenia `help` w mongosh.

```
test> help

  Shell Help:

    use                                Set current database
    show                               'show databases'/'show dbs': Print a list of all available databases.
                                       'show collections'/'show tables': Print a list of all collections for current database.
                                       'show profile': Prints system.profile information.
                                       'show users': Print a list of all users for current database.
                                       'show roles': Print a list of all roles for current database.
                                       'show log <type>': log for current connection, if type is not set uses 'global'
                                       'show logs': Print all logs.

    exit                               Quit the MongoDB shell with exit/exit()/.exit
```

> [Grafika] Zrzut ekranu okna mongosh (mongosh mongodb://127.0.0.1:27017/?directConnection=true...) z wynikiem poleceń `show dbs` i `show databases`.

```
test> show dbs
admin       40.00 KiB
config     108.00 KiB
customers  120.00 KiB
local       72.00 KiB
test> show databases
admin       40.00 KiB
config     108.00 KiB
customers  120.00 KiB
local       72.00 KiB
test>
```

**Bazy systemowe:**
- admin
- config
- local

## Slajd 090 — MongoDB – dodawanie i usuwanie bazy danych

**Polecenie:**

| | |
|---|---|
| db | - aktualna baza danych |
| use customers | - przełączenie bazy na bazę customers |
| db.dropDatabase() | - kasowanie aktualnej bazy danych, w której jesteśmy. |

```
-- Bazy danych --
Tworzenie/Użycie bazy danych:
use nazwa_bazy_danych

Usuwanie bazy danych:
db.dropDatabase()

Wyświetlenie bazy danych, w której aktualnie się znajdujemy:
db

Wyświetlenie dostępnych baz danych:
show dbs / show databases
```

> [Grafika] Zrzut ekranu konsoli mongosh (niebieskie tło):

```
test> use northwind
switched to db northwind
northwind> db.dropDatabase()
{ ok: 1, dropped: 'northwind' }
northwind>
```

## Slajd 091 — MongoDB – dodawanie i usuwanie kolekcji

Kolekcja to segregator do przechowywania dokumentów

**Polecenie:**

`db.createCollection("products")`
- tworzenie kolekcji

`db.products.drop()`
- kasowanie kolekcji

```
-- Kolekcje --
Tworzenie kolekcji:
db.createCollection("nazwa_kolekcji", {opcje})

Dostępne opcje:
   •  capped : true/false - jeżeli nowy dokument przekroczy wartość size, usuń najstarsze
      dokumenty, aby zwolnić miejsce. Wymaga parametru size.
   •  max : n - maksymalna ilość dokumentów, jakie mogą być w kolekcji.
   •  size : n - ustaw maksymalny rozmiar kolekcji w bajtach


Usuwanie kolekcji:
db.nazwa_kolekcji.drop()
```

> [Grafika] Dwa niebieskie ramki z przykładami kodu (po prawej na dole):

```js
db.createCollection("logi", {
  capped: true,
  size: 10485760
})
```

```js
db.createCollection("logi", {
  capped: true,
  size: 10485760,
  max: 10000
})
```

## Slajd 092 — MongoDB – dodawanie i usuwanie dokumentów

```
-- Dodawanie dokumentów --
Metoda insertOne() - dodaje dokładnie jeden dokument
db.nazwa_kolekcji.insertOne(<{dokument}>)

Metoda insertMany() - pozwala dodać kilka dokumentów. Umieszczamy je w liście
db.nazwa_kolekcji.insertMany([{dokument01}, {dokument02}, ..])
```

| Metoda | Zastosowanie |
|---|---|
| insertOne() | Dodanie jednego dokumentu |
| insertMany() | Dodanie wielu dokumentów w jednej operacji |

**Należy pamiętać:**
- Metody insertOne() oraz insertMany() utworzą kolekcję, jeżeli takowa nie istnieje.

Wskazówka:
- insertMany() jest zwykle bardziej wydajne niż wielokrotne wywoływanie insertOne(), gdy dodajemy większą liczbę dokumentów.

## Slajd 093 — MongoDB – zliczanie ilości dokumentów

- Metoda countDocuments() - jest używana do zliczania liczby dokumentów w kolekcji na podstawie określonego filtra. Zapewnia ona dokładne zliczanie, które może obejmować odczytanie wszystkich dokumentów w kolekcji.

`db.inventory.countDocuments()`

- Metoda estimatedDocumentCount() zapewnia przybliżoną liczbę dokumentów w kolekcji, bez stosowania żadnych filtrów. Ta metoda używa metadanych kolekcji do określenia liczby i jest ogólnie szybsza niż countDocuments().

`db.inventory.estimatedDocumentCount()`

> [Grafika] Kody `db.inventory.countDocuments()` i `db.inventory.estimatedDocumentCount()` umieszczone w pomarańczowych ramkach.

## Slajd 094 — MongoDB CRUD Operations

### Create Operations

Operacje tworzenia lub wstawiania dodają nowe dokumenty do kolekcji. Jeśli kolekcja obecnie nie istnieje, operacje wstawiania utworzą kolekcję.

MongoDB udostępnia następujące metody wstawiania dokumentów do kolekcji:

- `db.collection.insertOne()`
- `db.collection.insertMany()`

W MongoDB operacje wstawiania są skierowane do pojedynczej kolekcji. Wszystkie operacje zapisu w MongoDB są atomowe na poziomie pojedynczego dokumentu.

```js
db.users.insertOne(
  {
    name: "sue",
    age: 26,
    status: "pending"
  }
)
```

> [Grafika] Diagram z dokumentacji MongoDB: zielone strzałki wskazują, że `db.users.insertOne(` to „collection”, każda z trzech linii `name: "sue"`, `age: 26`, `status: "pending"` to „field: value”, a klamra obejmująca te trzy linie oznacza „document”.

## Slajd 095 — MongoDB CRUD Operations

### Insert

Poniższa tabela przedstawia różne instrukcje SQL służące do wstawiania rekordów do tabel oraz odpowiadające im instrukcje MongoDB służące do dodawania dokumentów do kolekcji.

| SQL INSERT Statements | MongoDB insertOne() Statements |
|---|---|
| `INSERT INTO people(user_id, age, status) VALUES ("bcd001", 45, "A")` | `db.people.insertOne( { user_id: "bcd001", age: 45, status: "A" } )` |

```sql
INSERT INTO people(user_id,
                   age,
                   status)
VALUES ("bcd001",
        45,
        "A")
```

```js
db.people.insertOne(
   { user_id: "bcd001", age: 45, status: "A" }
)
```

## Slajd 096 — MongoDB CRUD Operations

> [Grafika] Dwa zrzuty bloków kodu „MongoDB Shell” z dokumentacji MongoDB (z ikoną kopiowania). Linie w drugim bloku są ucięte po prawej stronie na slajdzie.

```js
db.inventory.insertOne(
   { item: "canvas", qty: 100, tags: ["cotton"], size: { h: 28, w: 35.5, uom: "cm" }
)
```

```js
db.inventory.insertMany([
   { item: "journal", qty: 25, tags: ["blank", "red"], size: { h: 14, w: 21, uom: "
   { item: "mat", qty: 85, tags: ["gray"], size: { h: 27.9, w: 35.5, uom: "cm" } },
   { item: "mousepad", qty: 25, tags: ["gel", "blue"], size: { h: 19, w: 22.85, uom
])
```

### _id

W MongoDB każdy dokument przechowywany w kolekcji wymaga unikalnego pola _id, które działa jak klucz podstawowy. Jeśli we wstawionym dokumencie pominięto _idpole, sterownik MongoDB automatycznie generuje identyfikator obiektu dla tego _idpola.

## Slajd 097 — MongoDB CRUD Operations

### Operacje aktualizacji

Operacje aktualizacji modyfikują istniejące dokumenty w kolekcji. MongoDB udostępnia następujące metody aktualizacji dokumentów kolekcji:

- `db.collection.updateOne()`
- `db.collection.updateMany()`
- `db.collection.replaceOne()`

W MongoDB operacje aktualizacji są ukierunkowane na pojedynczą kolekcję. Wszystkie operacje zapisu w MongoDB są atomowe na poziomie pojedynczego dokumentu.

Możesz określić kryteria lub filtry, które identyfikują dokumenty do aktualizacji. Te filtry używają tej samej składni, co operacje odczytu.

```js
db.users.updateMany(
  { age: { $lt: 18 } },
  { $set: { status: "reject" } }
)
```

> [Grafika] Diagram z dokumentacji MongoDB w ramce: zielone strzałki wskazują, że `db.users.updateMany(` to „collection”, `{ age: { $lt: 18 } },` to „update filter”, a `{ $set: { status: "reject" } }` to „update action”.

## Slajd 098 — MongoDB CRUD Operations

### Update Records

Poniższa tabela przedstawia porównanie instrukcji SQL służących do aktualizacji istniejących rekordów oraz ich odpowiedników w MongoDB

| SQL Update Statements | MongoDB updateMany() Statements |
|---|---|
| `UPDATE people SET status = "C" WHERE age > 25` | `db.people.updateMany( { age: { $gt: 25 } }, { $set: { status: "C" } } )` |
| `UPDATE people SET age = age + 3 WHERE status = "A"` | `db.people.updateMany( { status: "A" } , { $inc: { age: 3 } } )` |

```sql
UPDATE people
SET status = "C"
WHERE age > 25
```

```js
db.people.updateMany(
   { age: { $gt: 25 } },
   { $set: { status: "C" } }
)
```

```sql
UPDATE people
SET age = age + 3
WHERE status = "A"
```

```js
db.people.updateMany(
   { status: "A" } ,
   { $inc: { age: 3 } }
)
```

## Slajd 099 — Update Documents

> [Grafika] Trzy bloki „MongoDB Shell” z dokumentacji MongoDB. Linia w trzecim bloku jest ucięta po prawej stronie na slajdzie.

```js
db.inventory.updateOne(
   { item: "paper" },
   {
     $set: { "size.uom": "cm", status: "P" },
     $currentDate: { lastModified: true }
   }
)
```

```js
db.inventory.updateMany(
   { "qty": { $lt: 50 } },
   {
     $set: { "size.uom": "in", status: "P" },
     $currentDate: { lastModified: true }
   }
)
```

```js
db.inventory.replaceOne(
   { item: "paper" },
   { item: "paper", instock: [ { warehouse: "A", qty: 60 }, { warehouse: "B", qty: 4
)
```

## Slajd 100 — Update Documents

W MongoDB metody aktualizacji służą do modyfikowania istniejących dokumentów kolekcji. Umożliwiają one wykonywanie aktualizacji określonych pól lub całego dokumentu, w zależności od podanych kryteriów zapytania.

`db.collection.updateOne(<filter>, <update>, <options>)`

<filter>: określa kryteria wyboru dokumentu do aktualizacji.
<update>:  określa modyfikacje, które mają zostać zastosowane do wybranego dokumentu.
<options>:  (opcjonalnie) dodatkowe opcje konfigurujące zachowanie operacji aktualizacji.

MongoDB udostępnia dodatkowe operatory aktualizacji, aby określić modyfikacje, takie jak $set, $unset, $inc, $push, $pull  i inne.

```js
db.collection.updateOne({ name: 'John Doe' }, { $set: { age: 30 } });
db.collection.updateMany({ status: 'new' }, { $inc: { views: 1 } });
db.collection.updateOne({ name: 'Jane Doe' }, { $push: { tags: 'mongodb' } });
```

## Slajd 101 — Update Documents

**Tryby zmień / zamień**

> [Grafika] Diagram składni (railroad): `document` albo `{` `update operator` `}` (z pętlą przecinka `,` pozwalającą na wiele operatorów).

- **Zamień**
  Gdy parametr update nie zawiera operatorów
  - **Cały dokument jest zmieniamy** (identyfikatory są zachowane)
- **Zmień**
  Gdy parametr update zawiera wyłącznie operatory
  - **Aktualny dokument jest zmieniany** na podstawie tych operatorów
    - $set, $unset, $inc, $mul itp.
    - Każdy operator może wystąpić tylko raz

```js
db.users.updateOne({ _id: 1 }, { email: "nowy@example.com" });
```

```js
db.users.updateOne({ _id: 1 }, { $set: { email: "nowy@example.com" } });
```

## Slajd 102 — Update: Operatory

**Operatory dotyczące pól**

- **$set**– ustawia wartość pola / pól

> [Grafika] Diagram składni: `$set` `:` `{` `field` `:` `value / array / document` `}` (pętla przecinka dla wielu pól).

```js
db.users.updateOne(
  { _id: 1 },
  { $set: { email: "nowy@example.com" } }
);
```

- **$unset**– usuwa zadane pole / pola

> [Grafika] Diagram składni: `$unset` `:` `{` `field` `:` `""` `}` (pętla przecinka dla wielu pól).

```js
db.users.updateOne(
  { _id: 1 },
  { $unset: { phone: "" } }
);
```

- **$rename**– zmienia nazwę pola / pól

> [Grafika] Diagram składni: `$rename` `:` `{` `field` `:` `new field name` `}` (pętla przecinka dla wielu pól).

```js
db.users.updateOne(
  { _id: 1 },
  { $rename: { username: "login" } }
);
```

## Slajd 103 — Update: Operatory

**Operatory dotyczące pól**

- **$inc**– zwiększa wartość zadanego pola / pól

> [Grafika] Diagram składni: `$inc` `:` `{` `field` `:` `increment` `}` (pętla przecinka).

```js
db.products.updateOne(
  { _id: 1 },
  { $inc: { stock: 5 } }
);
```

- **$mul**– mnoży wartość zadanego pola / pól

> [Grafika] Diagram składni: `$mul` `:` `{` `field` `:` `multiplier` `}` (pętla przecinka).

```js
db.products.updateOne(
  { _id: 1 },
  { $mul: { price: 1.2 } }
);
```

- **$currentDate**– przechowuje aktualną datę i czas / timestamp dla zadanego pola / pól

> [Grafika] Diagram składni: `$currentDate` `:` `{` `field` `:` jedna z opcji: `{ $type : "date" }` albo `{ $type : "timestamp" }` `}` (pętla przecinka).

```js
db.users.updateOne(
  { _id: 1 },
  { $currentDate: { lastLogin: true } } // ustawi typ Date
);
```

> [Grafika] Mała notatka obok kodu powyżej: „true → ustawia Date (z datą i godziną).” oraz „{ $type: "date" } → to samo, jawnie.”

```js
db.orders.updateOne(
  { _id: 1 },
  { $currentDate: { lastUpdated: { $type: "timestamp" } } }
);
```

> [Grafika] Mała zielona ramka na dole slajdu (bardzo drobny druk) z przykładem dokumentu:

```js
db.customers.insertOne(
  { _id: 1, status: "a", lastModified: ISODate("2013-10-02T01:11:18.965Z") }
)
```
[nieczytelne] (drobny druk w zielonej ramce; wartość daty i dokładna treść odczytane z dużą niepewnością)

## Slajd 104 — Update: Operatory

**Operatory związane z tablicami**

> [Grafika] Zielona ramka z dokumentem w prawym górnym rogu:

```json
{
  "_id": 1,
  "name": "Jan",
  "tags": ["mongodb", "database"],
  "skills": ["JavaScript"]
}
```

- **$push**– Dodaje 1 element / wszystkie elementy na koniec tablicy

> [Grafika] Diagram składni: `$push` `:` `{` `array field` `:` `value / array / document` albo `{` `$each` `:` `array` `}` `}` (pętla przecinka).

```js
db.users.updateOne(
  { _id: 1 },
  { $push: { tags: "newTag" } }
);
```

- **$addToSet**– dodaje 1 element / wszystkie elementy na koniec tablicy,  ale duplikaty są ignorowane

> [Grafika] Diagram składni: `$addToSet` `:` `{` `array field` `:` `value / array / document` albo `{` `$each` `:` `array` `}` `}` (pętla przecinka).

```js
db.users.updateOne(
  { _id: 1 },
  { $addToSet: { tags: "uniqueTag" } }
);
```

```js
db.users.updateOne(
  { _id: 1 },
  { $push: { tags: { $each: ["tag1", "tag2"] } } }
);
```

## Slajd 105 — Update: Operatory

**Operatory związane z tablicami**

> [Grafika] Zielona ramka z dokumentem w prawym górnym rogu:

```json
{
  "_id": 1,
  "name": "Jan",
  "roles": ["user", "editor", "admin"],
  "tags": ["mongodb", "database", "nosql"]
},
```

- **$pop**– usuwa pierwszy/ ostatni element tablicy

> [Grafika] Diagram składni: `$pop` `:` `{` `array field` `:` `1` albo `-1` `}` (pętla przecinka).

```js
db.users.updateOne(
  { _id: 1 },
  { $pop: { roles: 1 } } // 1 = usuń ostatni
);
```

- **$pull**– usuwa wszystkie elementy tablicy spełniające wzorzec

> [Grafika] Diagram składni: `$pull` `:` `{` `array field` `:` `value / array / document` albo `query` `}` (pętla przecinka).

```js
db.users.updateOne(
  { _id: 1 },
  { $pull: { tags: "mongodb" } }
);
```

```js
db.users.updateOne(
  { _id: 2 },
  { $pull: { roles: /^m/ } } // regex
);
```

## Slajd 106 — Tryb Upsert

**Zachowanie Upsert podczas modyfikacji:**
- Gdy podano opcję {upsert:true}, ale żaden dokument nie został zmodyfikowany to => **nowy dokument jest wstawiany**

**Co zawiera ten dokument?**
- W przypadku trybu **replace**:
  - Wszystkie pola (wartości) z parametru update
- W przypadku trybu **update**:
  - Wszystkie wartości pól z parametru query
  - rezultat zastosowania operatorów modyfikujących z parametru update
- Pole **_id** jest zachowane lub tworzone jest nowe jeśli potrzeba

```js
db.users.updateOne(
  { name: "Alice" },      // Kryteria wyszukiwania
  { $set: { age: 30 } },  // Operacja aktualizacji
  { upsert: true }        // Flaga upsert
);
```

```js
db.users.updateMany(
  { status: "active" },
  { $set: { verified: true } },
  { upsert: true }
);
```

```js
db.users.replaceOne(
  { _id: 10 },
  { name: "Nowy", age: 25 },
  { upsert: true }
);
```

```js
db.users.updateOne(
  { email: "jan@example.com" },
  { $set: { name: "Jan", age: 30 } },
  { upsert: true }
);
```

## Slajd 107 — MongoDB CRUD Operations

### Delete Operations

Operacje usuwania usuwają dokumenty z kolekcji. MongoDB udostępnia następujące metody usuwania dokumentów z kolekcji:

- `db.collection.deleteOne()`
- `db.collection.deleteMany()`

W MongoDB operacje usuwania są ukierunkowane na pojedynczą kolekcję. Wszystkie operacje zapisu w MongoDB są atomowe na poziomie pojedynczego dokumentu.

Możesz określić kryteria lub filtry, które identyfikują dokumenty do usunięcia. Filtry te używają tej samej składni, co operacje odczytu.

```js
db.users.deleteMany(
  { status: "reject" }
)
```

> [Grafika] Diagram z dokumentacji MongoDB: zielone strzałki wskazują, że `db.users.deleteMany(` to „collection”, a `{ status: "reject" }` to „delete filter”.

## Slajd 108 — Delete Documents

**Usuń wszystkie dokumenty**

```js
db.inventory.deleteMany({})
```

**Usuń wszystkie dokumenty spełniające warunek**

```js
db.inventory.deleteMany({ status : "A" })
```

**Usuń tylko jeden dokument spełniający warunek**

```js
db.inventory.deleteOne( { status: "D" } )
```

> [Grafika] Trzy bloki „MongoDB Shell” z dokumentacji MongoDB (z logiem liścia MongoDB i ikoną kopiowania).

## Slajd 109 — MongoDB CRUD Operations

### Delete Records

Poniższa tabela przedstawia odpowiedniki instrukcji SQL DELETE oraz metod MongoDB wykorzystywanych do usuwania dokumentów z kolekcji

| SQL Delete Statements | MongoDB deleteMany() Statements |
|---|---|
| `DELETE FROM people WHERE status = "D"` | `db.people.deleteMany( { status: "D" } )` |
| `DELETE FROM people` | `db.people.deleteMany({})` |

## Slajd 110 — Dodatkowe metody

Następujące metody mogą również usuwać dokumenty z kolekcji:
- db.collection.findOneAndDelete()

Metoda usuwa **jeden dokument** z kolekcji i zwraca go. Udostępnia opcję **sortowania**, dzięki czemu możesz określić, który dokument zostanie usunięty jako pierwszy.

```js
db.collection.findOneAndDelete(
  { status: "inactive" },
  { sort: { lastLogin: 1 } }
);
```

- db.collection.findAndModify()

Metoda jest bardziej ogólna – pozwala **modyfikować** lub **usuwać** pojedynczy dokument. Udostępnia opcję **sortowania**, aby wybrać dokument w określonej kolejności. Aby usunąć dokument, należy ustawić remove: true.

```js
db.collection.findAndModify({
  query: { status: "inactive" },
  sort: { lastLogin: 1 },
  remove: true
});
```

## Slajd 111 — Bulk Write Operations

MongoDB umożliwia klientom wykonywanie zbiorczej (masowej) operacji zapisu (Bulk Write Operations). Operacje zapisu zbiorczego dotyczą pojedynczej kolekcji. Metoda ta db.collection.bulkWrite() umożliwia wykonywanie masowych operacji wstawiania, aktualizacji i usuwania.

Operacje uporządkowane i nieuporządkowane (Ordered vs Unordered Operations)
- Przy uporządkowanej liście operacji MongoDB wykonuje operacje szeregowo. Jeśli wystąpi błąd podczas przetwarzania jednej z operacji zapisu, MongoDB zwróci bez przetwarzania pozostałych operacji zapisu na liście.
- W przypadku nieuporządkowanej listy operacji MongoDB może wykonywać operacje równolegle (nie jest gwarantowane). Jeśli wystąpi błąd podczas przetwarzania jednej z operacji zapisu, MongoDB będzie kontynuować przetwarzanie pozostałych operacji zapisu na liście.

```js
db.collection.bulkWrite(
   [
      { insertOne : <document> },
      { updateOne : <document> },
      { updateMany : <document> },
      { replaceOne : <document> },
      { deleteOne : <document> },
      { deleteMany : <document> }
   ],
   { ordered : false }
)
```

> [Grafika] Ramka z dokumentacji MongoDB (po prawej na dole, ucięta): „bulkWrite() Methods” — „bulkWrite() supports the following write operations:” z listą: insertOne, updateOne, updateMany, replaceOne, deleteOne, deleteMany.

## Slajd 112 — Bulk Write Operations

> [Grafika] Zrzut bloku kodu z dokumentacji MongoDB; wiersze z `insertOne` są ucięte po prawej stronie na slajdzie. Na dole po prawej ramka „bulkWrite() Methods — bulkWrite() supports the following write operations:” z listą insertOne, updateOne, updateMany, replaceOne, deleteOne, deleteMany.

```js
try {
   db.pizzas.bulkWrite( [
      { insertOne: { document: { _id: 3, type: "beef", size: "medium", price: 6
      { insertOne: { document: { _id: 4, type: "sausage", size: "large", price:
      { updateOne: {
         filter: { type: "cheese" },
         update: { $set: { price: 8 } }
      } },
      { deleteOne: { filter: { type: "pepperoni"} } },
      { replaceOne: {
         filter: { type: "vegan" },
         replacement: { type: "tofu", size: "small", price: 4 }
      } }
   ] )
} catch( error ) {
   print( error )
}
```

## Slajd 113 — Operacja wyszukiwania danych

**Wybiera** dokumenty z kolekcji

> [Grafika] Diagram składni: `db` `.` `collection` `.` `find` `(` `query` opcjonalnie `,` `projection` `)`.

- Parametry
  - **Query**: specyfikacja dokumentów jakie mają zostać wybrane
  - **Projection**: pola jakie mają zostać dodane/ wyłączone z rezultatu
- Dopasowane dokumenty są zwrócone za pomocą kursora
  - Umożliwia to dalsze operacje sortowania czy filtrowania

## Slajd 114 — Wyszukiwanie: Przykład

Wybierz wszystkie filmy z kolekcji

```js
db.movies.find()
```

```js
db.movies.find( { } )
```

Wybierz określony film z kolekcji na podstawie jego identyfikatora

```js
db.movies.find( { _id: ObjectId("2") } )
```

Wybierz filmy z *2000* roku z oceną większą niż *1*

```js
db.movies.find( { year: 2000, rating: { $gt: 1 } } )
```

Wybierz filmy nakręcone między *2005 i 2015*

```js
db.movies.find( { year: { $gte: 2005, $lte: 2015 } } )
```

## Slajd 115 — MongoDB CRUD Operations

### Operacje odczytu

Operacje odczytu pobierają dokumenty z kolekcji; tj. przeszukują kolekcję pod kątem dokumentów. MongoDB udostępnia następujące metody odczytu dokumentów z kolekcji:

- `db.collection.find()`

Można określić filtry zapytania lub kryteria identyfikujące dokumenty do zwrócenia.

```js
db.users.find(
   { age: { $gt: 18 } },
   { name: 1, address: 1 }
).limit(5)
```

> [Grafika] Diagram z dokumentacji MongoDB: zielone strzałki wskazują, że `db.users.find(` to „collection”, `{ age: { $gt: 18 } },` to „query criteria”, `{ name: 1, address: 1 }` to „projection”, a `).limit(5)` to „cursor modifier”.

## Slajd 116 — Selekcja

Parametr **Query** opisuje dokumenty jakimi jesteśmy zainteresowani

> [Grafika] Diagram składni: `{` `and / or logical operator` `}` albo `{` `field` `:` `value / array / document` albo (`{` `query operator` `}` z pętlą przecinka) `}`, całość z pętlą przecinka dla wielu pól.

**Wyrażenie boolowskie** z jednym operatorem logicznym najwyższego poziomu: $and, $or

**Warunki** na określonych polach:
- **Równość wartości**
  Aktualna wartość pola musi być identyczna z podaną
- **Pozostałe operatory**
  Aktualna wartość pola musi spełniać wszystkie warunki wyrażone przez zastosowane operatory

## Slajd 117 — Selekcja: Warunki dla pól

**Równość wartości**
- Aktualna wartość pola musi być identyczna do podanej
- Identyczna tzn.
  - Uwzględniając ilość, porządek i nazwy wartości dla wszystkich dopasowanych **pól obiektu**
  - Uwzględniając ilość i porządek dla wszystkich dopasowanych **pól tablicowych**

**Pozostałe operatory**
- Aktualna wartość musi spełniać wszystkie warunku narzucone przez operatory
  - Każdy operator może wystąpić tylko raz

> [Grafika] Zrzut ekranu konsoli (w ramce, prawy dolny róg):

```
> db.movies1.find({tablica:[10,2,3]})
[
  {
    _id: ObjectId("6524859569f926135a434905"),
    title: 'test',
    tablica: [ 10, 2, 3 ]
  },
  {
    _id: ObjectId("6524869869f926135a434906"),
    title: 'test',
    tablica: [ 10, 2, 3 ],
    out1: { a: 'a1', b: 'b1' }
  }
]
```

## Slajd 118 — Równość wartości: Przykład

```js
// Wybierz filmy określonego reżysera
```

```js
db.movies1.find(
  { director: { firstname: "Sylwester", lastname: "Stallone" } }
)
```

```js
db.movies1.find(
  { director: { lastname: "Sylwester", firstname: "Stallone" } }
)
```

> [Grafika] Mała ramka w prawym górnym rogu z dokumentem JSON:

```json
{
  "_id": {
    "$oid": "65248e7369f926135a434907"
  },
  "director": {
    "lastName": "Stallone",
    "firstName": "Sylwester"
  }
}
```

> [Grafika] Zrzut ekranu konsoli (w ramce, na dole):

```
> db.movies1.find({"director":{"firstName":"Sylwester","lastName":"Stallone"}})
> db.movies1.find({"director":{"lastName":"Stallone","firstName":"Sylwester"}})
[
  {
    _id: ObjectId("65248e7369f926135a434907"),
    director: { lastName: 'Stallone', firstName: 'Sylwester' }
  }
]
```

## Slajd 119 — Notacja

Notacja dotycząca pól

> [Grafika] Diagram składni: `field` opcjonalnie następnie `.` i `field` albo `position` (pętla dla kolejnych poziomów).

- Dostęp do **pól zagnieżdżonych dokumentów**
  "pole.subpole"
  - Np. "director.firstname"
- Accessing **items of arrays**
  - "pole.indeks"
    - Np. "actors.2"
    - Indeksowanie rozpoczynamy od zera

> [Grafika] Dwa zrzuty ekranu konsoli (w ramkach):

```
> db.movies1.find({"tablica.0":10})
[
  {
    _id: ObjectId("6524859569f926135a434905"),
    title: 'test',
    tablica: [ 10, 2, 3 ]
  },
```

```
> db.movies1.find({"out1.a":'a1'})
[
  {
    _id: ObjectId("6524869869f926135a434906"),
    title: 'test',
    tablica: [ 10, 2, 3 ],
    out1: { a: 'a1', b: 'b1' }
  }
]
```

## Slajd 120 — Równość wartości

Przykład (raz jeszcze)

```js
//Wybierz filmy określonego reżysera
```

```js
db.movies1.find(
  { director: { firstname: "Sylwester", lastname: "Stallone" } }
)
```

```js
db.movies1.find(
  { "director.firstname": "Sylwester", "director.lastname": "Stallone" }
)
```

> [Grafika] Mała ramka w prawym górnym rogu z dokumentem JSON:

```json
{
  "_id": {
    "$oid": "65248e7369f926135a434907"
  },
  "director": {
    "lastName": "Stallone",
    "firstName": "Sylwester"
  }
}
```

> [Grafika] Zrzut ekranu konsoli (w ramce, na dole):

```
> db.movies1.find({"director":{"lastName":"Stallone","firstName":"Sylwester"}})
[
  {
    _id: ObjectId("65248e7369f926135a434907"),
    director: { lastName: 'Stallone', firstName: 'Sylwester' }
  }
]
> db.movies1.find({"director.lastName":"Stallone","director.firstName":"Sylwester"})
[
  {
    _id: ObjectId("65248e7369f926135a434907"),
    director: { lastName: 'Stallone', firstName: 'Sylwester' }
  }
]
```

## Slajd 121 — Operatory zapytań w MongoDB

> [Grafika] Infografika (plansza) z logo MongoDB. Drobny druk na zdjęciu jest rozmyty; poniżej odczytana zawartość.

MONGODB
**Operatory zapytań w MongoDB**
Query Operators
Operatory zapytań służą do określania warunków wyszukiwania i dopasowywania dokumentów w kolekcjach.

(zielona ramka z ikoną „i”): Operatory można łączyć w jednym zapytaniu, aby tworzyć bardziej złożone warunki.

**Operatory porównania** (Comparison Operators)
Porównują wartości pól z określonymi wartościami.
| Operator | Opis |
|---|---|
| $eq | Równe |
| $ne | Różne |
| $gt | Większe niż |
| $gte | Większe lub równe |
| $lt | Mniejsze niż |
| $lte | Mniejsze lub równe |
| $in | Należy do tablicy |
| $nin | Nie należy do tablicy |

**Operatory tablicowe** (Array Operators)
Działają na tablicach i umożliwiają dopasowywanie elementów tablic.
| Operator | Opis |
|---|---|
| $all | Tablica zawiera wszystkie wskazane elementy |
| $elemMatch | Tablica zawiera element spełniający określone warunki |
| $size | Tablica ma określoną liczbę elementów |

**Operatory elementów** (Element Operators)
Umożliwiają wyszukiwanie na podstawie istnienia, typu lub wartości elementów.
| Operator | Opis |
|---|---|
| $exists | Pole istnieje lub nie istnieje |
| $type | Pole ma określony typ BSON |

**Operatory logiczne** (Logical Operators)
Łączą wyrażenia zapytań.
| Operator | Opis |
|---|---|
| $and | Wszystkie warunki muszą być prawdziwe |
| $or | Co najmniej jeden warunek musi być prawdziwy |
| $nor | Żaden z warunków nie może być prawdziwy |
| $not | Neguje wyrażenie |
| $expr | Umożliwia użycie wyrażeń agregujących w zapytaniach |

**Operatory geograficzne** (Geospatial Operators)
Wyszukują dokumenty na podstawie danych przestrzennych (lokalizacji).
| Operator | Opis |
|---|---|
| $box | W obszarze prostokąta |
| $center | W okręgu (starsza składnia) |
| $centerSphere | W okręgu na kuli |
| $geoIntersects | Przecinające się geometrie |
| $geometry | Dopasowanie geometrii GeoJSON |
| $geoWithin | W obszarze |
| $maxDistance | Maksymalna odległość |
| $minDistance | Minimalna odległość |
| $near | Najbliżej punktu (starsza składnia) |
| $nearSphere | Najbliżej punktu na kuli |
| $polygon | W obszarze wielokąta (starsza składnia) |

**Operatory bitowe** (Bitwise Operators)
Działają na wartościach liczbowych na poziomie bitów.
| Operator | Opis |
|---|---|
| $bitsAllClear | Wszystkie wskazane bity są wyzerowane |
| $bitsAllSet | Wszystkie wskazane bity są ustawione |
| $bitsAnyClear | Co najmniej jeden wskazany bit jest wyzerowany |
| $bitsAnySet | Co najmniej jeden wskazany bit jest ustawiony |

**Operatory różne** (Miscellaneous Operators)
Dodatkowe operatory zapytań.
| Operator | Opis |
|---|---|
| $jsonSchema | Walidacja względem schematu JSON |
| $mod | Reszta z dzielenia |
| $regex | Dopasowanie do wyrażenia regularnego |
| $text | Wyszukiwanie pełnotekstowe |
| $where | Dopasowanie dokumentów za pomocą kodu JavaScript |
| $comment | Dodanie komentarza do zapytania |

**Operatory oceniania** (Evaluation Operators)
Działają w kontekście ewaluacji wyrażeń.
| Operator | Opis |
|---|---|
| $cond | Warunek logiczny (operator trójargumentowy) |
| $ifNull | Zwraca pierwszą niepustą wartość |
| $switch | Wiele warunków |
| $isArray | Sprawdza, czy wartość jest tablicą |
| $isNumber | Sprawdza, czy wartość jest liczbą |
| $isObject | Sprawdza, czy wartość jest dokumentem |
| $type | Zwraca typ wartości |

(dolna zielona ramka z ikoną linku, drobny druk): Więcej informacji i przykładów znajdziesz w oficjalnej dokumentacji MongoDB. https://www.mongodb.com/docs/manual/reference/operator/query/
[nieczytelne] (dokładny tekst drobnego druku tej ramki oraz część opisów w tabelach jest rozmyta i odczytana z niepewnością)

Query Predicates - Database Manual - MongoDB Docs

## Slajd 122 — MongoDB – Operatory zapytań (porównania)

> [Grafika] Plansza z zieloną ikoną liścia MongoDB. Podtytuł: Operatory porównania służą do filtrowania dokumentów na podstawie wartości pól.

| Operator | Znaczenie | Opis | Przykład zapytania |
|---|---|---|---|
| $eq | Równe (=) | Dopasowuje dokumenty, w których wartość pola jest równa podanej wartości. | `db.products.find({ price: { $eq: 100 } })` |
| $ne | Różne (≠) | Dopasowuje dokumenty, w których wartość pola nie jest równa podanej wartości. | `db.products.find({ status: { $ne: "inactive" } })` |
| $gt | Większe niż (>) | Dopasowuje dokumenty, w których wartość pola jest większa niż podana wartość. | `db.students.find({ age: { $gt: 21 } })` |
| $gte | Większe lub równe (≥) | Dopasowuje dokumenty, w których wartość pola jest większa lub równa podanej wartości. | `db.students.find({ age: { $gte: 21 } })` |
| $lt | Mniejsze niż (<) | Dopasowuje dokumenty, w których wartość pola jest mniejsza niż podana wartość. | `db.products.find({ price: { $lt: 50 } })` |
| $lte | Mniejsze lub równe (≤) | Dopasowuje dokumenty, w których wartość pola jest mniejsza lub równa podanej wartości. | `db.products.find({ price: { $lte: 50 } })` |
| $in | Należy do zbioru (∈) | Dopasowuje dokumenty, w których wartość pola jest równa przynajmniej jednej z wartości w podanej tablicy. | `db.articles.find({ tags: { $in: ["NoSQL", "javascript"] } })` |
| $nin | Nie należy do zbioru (∉) | Dopasowuje dokumenty, w których wartość pola nie jest równa żadnej z wartości w podanej tablicy. | `db.books.find({ genre: { $nin: ["Mystery", "Sci-Fi"] } })` |

(w każdym wierszu przykłady oznaczone etykietą „javascript”)

**Warto wiedzieć**
- Porównania w MongoDB uwzględniają kolejność typów BSON.
- Zapis { pole: wartość } jest skrótem dla { pole: { $eq: wartość } }.
- Operatory można łączyć w jednym zapytaniu.
- MongoDB automatycznie wykonuje konwersję numeryczną, gdy jest to możliwe.

**Przykład z wieloma warunkami**
Wyszukaj użytkowników w wieku od 18 do 64 lat:

```js
db.users.find({
  age: {
    $gte: 18,
    $lt: 65
  }
})
```

**Uwaga**
- Operatory $in i $nin przyjmują tablicę wartości.
- Przy porównaniach typy danych mają znaczenie (np. liczba 5 różni się od "5").
- Aby sprawdzić istnienie pola, użyj $exists (to nie jest operator porównania).
- Więcej informacji znajdziesz w oficjalnej dokumentacji MongoDB: Comparison Query Predicate Operators.

> [Grafika] W lewym dolnym rogu mały diagram składni (railroad) dla operatorów porównania: `$eq`, `$ne`, `$gt`, `$gte`, `$lt`, `$lte` z `value / array / document` oraz `$in`, `$nin` z tablicą wartości.

Comparison Query Predicate Operators - Database Manual - MongoDB Docs

## Slajd 123 — MongoDB – Operatory zapytań

Wybrane operatory dotyczące istnienia pól, wyszukiwania tekstowego i ewaluacji wyrażeń

> [Grafika] Plansza z zieloną ikoną liścia MongoDB, podzielona na trzy sekcje z ikonami.

### Operatory dotyczące istnienia pól
**$exists** — Sprawdza, czy pole istnieje lub nie istnieje w dokumencie.

Przykłady:

```js
// dokumenty, w których pole istnieje
db.books.find({
   author: { $exists: true }
});
```

```js
// dokumenty, w których pole nie istnieje
db.books.find({
   author: { $exists: false }
});
```

### Operatory tekstowe
**$regex** — Dopasowuje wartość pola do wyrażenia regularnego (regex).

Przykład:

```js
// dokumenty, w których pole name zaczyna się od "Jan" (bez uwzględniania wielkości liter)
db.users.find({
   name: { $regex: "^Jan", $options: "i" }
});
```

**$text** — Wyszukuje dokumenty zawierające określone słowa (wyszukiwanie pełnotekstowe). Wymaga indeksu tekstowego (text index).

Przykład:

```js
// wyszukiwanie dokumentów zawierających słowa: "mongodb" i "baza"
db.articles.find({
   $text: { $search: "mongodb baza" }
});
```

### Operatory ewaluacji
**$expr** — Umożliwia użycie wyrażeń i porównywanie pól tego samego dokumentu lub wykonywanie bardziej złożonych warunków.

Przykład:

```js
// dokumenty, w których cena jest większa od kosztu
db.products.find({
   $expr: { $gt: ["$price", "$koszt"] }
});
```

**Warto wiedzieć**
- Operator $text wymaga utworzenia indeksu tekstowego (text index) na odpowiednich polach.
- Operator $regex może być wolniejszy – dla lepszej wydajności warto stosować indeksy i unikać niekotwiczonych wyrażeń (np. ^ na początku wzorca).
- Operator $expr pozwala porównywać pola dokumentu, używając funkcji agregacji i wyrażeń (np. $gt, $lt, $and).
- MongoDB porównuje wartości zgodnie z kolejnością typów BSON (BSON Type Comparison Order).

**Dobra praktyka**
Stosuj indeksy (w tym text index) i testuj wydajność zapytań za pomocą explain().

## Slajd 124 — Operatory tablicowe w MongoDB

> [Grafika] Plansza z logo MongoDB. Podtytuł: Array Operators. Opis: Operatory tablicowe umożliwiają wyszukiwanie i dopasowywanie elementów w tablicach. Zielona ramka z ikoną „i”: Tablica w MongoDB może zawierać wartości skalarne, dokumenty lub tablice zagnieżdżone.

### $size
Sprawdza, czy rozmiar tablicy jest równy podanej liczbie elementów.

Diagram: `$size` `:` `liczba` (number).

Składnia:

```js
{ pole: { $size: <liczba> } }
```

Przykład:

```js
db.products.find({
  colors: { $size: 3 }
});
```

### $elemMatch
Sprawdza, czy tablica zawiera co najmniej jeden element, który spełnia wszystkie podane warunki.

Diagram: `$elemMatch` `:` `zapytanie` (dokument).

Składnia:

```js
{ pole: { $elemMatch: { <warunek1>, <warunek2>, ... } } }
```

Przykład:

```js
db.courses.find({
  grades: {
    $elemMatch: { subject: "Math", score: { $gte: 80 } }
  }
});
```

**Warto wiedzieć**
- Operatory tablicowe działają na tablicach dowolnego typu elementów (wartości, dokumenty lub tablice).
- $size wymaga dokładnej liczby elementów.
- $elemMatch umożliwia łączenie wielu warunków.
- Jeśli chcesz sprawdzić, czy tablica zawiera określone elementy (bez warunków), użyj operatora $all lub $in.

**Dobra praktyka**
- Używaj $elemMatch do filtrowania tablic dokumentów.
- Stosuj odpowiednie indeksy, aby poprawić wydajność zapytań na tablicach.
- W przypadku prostych wartości rozważ użycie $in, $all lub $size.

**Powiązane operatory**
| Operator | Opis |
|---|---|
| $all | Sprawdza, czy tablica zawiera wszystkie wskazane elementy |
| $in | Sprawdza, czy tablica zawiera co najmniej jeden z podanych elementów |
| $nin | Sprawdza, czy tablica nie zawiera żadnego z podanych elementów |
| $exists | Sprawdza, czy pole istnieje (może być tablicą) |

## Slajd 125 — $all

MONGODB QUERY OPERATORS
**$all**
**Operator tablicowy (Array Operator)**
Sprawdza, czy tablica zawiera wszystkie podane elementy.

> [Grafika] Plansza z logo MongoDB („Build faster. Go further.”) i etykietą „Kategoria: Tablice (Arrays)”.

### Opis
Operator $all dopasowuje dokumenty, których tablica zawiera wszystkie wskazane elementy, niezależnie od kolejności ich występowania.

### Składnia

```js
{
  pole: { $all: [ wartość1, wartość2, ... ] }
}
```

### Przykład

```js
db.movies.find({
  actors: {
    $all: [ "Tom Hanks", "Robin Wright" ]
  }
})
```

Zwraca dokumenty, w których tablica actors zawiera zarówno „Tom Hanks”, jak i „Robin Wright”.

### Przykładowe dane
Kolekcja movies:

```json
{
  "_id": 1,
  "title": "Forrest Gump",
  "actors": [
    "Tom Hanks",
    "Robin Wright",
    "Gary Sinise"
  ]
}
```

```json
{
  "_id": 2,
  "title": "Cast Away",
  "actors": [
    "Tom Hanks"
  ]
}
```

```json
{
  "_id": 3,
  "title": "The Green Mile",
  "actors": [
    "Tom Hanks",
    "Michael Clarke Duncan"
  ]
}
```

### Wynik zapytania
Powyższe zapytanie zwraca tylko dokumenty, w których występują wszystkie podane elementy.

```json
{
  "_id": 1,
  "title": "Forrest Gump",
  "actors": [
    "Tom Hanks",
    "Robin Wright",
    "Gary Sinise"
  ]
}
```

### Ważne informacje
- Kolejność elementów w tablicy nie ma znaczenia.
- Operator sprawdza, czy tablica zawiera dokładnie określone elementy i tylko je, użyj dodatkowych warunków (np. $size), jeśli potrzebna jest dokładna liczba elementów.
- Operator $all może być używany z tablicami wartości prostych (np. stringów, liczb) oraz obiektów dokumentów.
- Często stosowany do wyszukiwania dokumentów z określonymi tagami, identyfikatorami lub kategoriami.

### Powiązane operatory
| Operator | Opis |
|---|---|
| $in | Dopasowuje, jeśli tablica zawiera przynajmniej jeden z elementów. |
| $elemMatch | Dopasowuje elementy tablicy na podstawie podanych warunków. |
| $size | Dopasowuje tablicę o określonej liczbie elementów. |
| $all | Dopasowuje, jeśli tablica zawiera wszystkie podane elementy. |

(stopka, drobny druk: MongoDB Documentation · Query Language Reference; MongoDB Query Operators)

## Slajd 126 — Operatory logiczne w MongoDB

> [Grafika] Plansza z logo MongoDB. Podtytuł: Logical Query Operators. Opis: Operatory logiczne łączą wyrażenia zapytań i umożliwiają tworzenie bardziej złożonych warunków. Zielona ramka z ikoną „i”: Operatory logiczne mogą być używane do łączenia innych operatorów zapytań.

### $and
Logiczny operator koniunkcji

Zwraca dokumenty, dla których **wszystkie** podane wyrażenia są prawdziwe (muszą być spełnione co najmniej 2 wyrażenia).

Diagram składni: `$and` `:` `[` `wyrażenie (dokument)` `,` `wyrażenie (dokument)` `]` — z adnotacją „co najmniej 2 wyrażenia” (pętla powtarzania).

Najważniejsze informacje:
- Łączy warunki za pomocą koniunkcji (AND).
- Musi zawierać co najmniej 2 wyrażenia.
- Dopuszczalne tylko na najwyższym poziomie zapytania.

Przykład:

```js
db.products.find({
  $and: [
    { category: 'Fruits' },
    { price: { $lt: 20 } },
    { stock: { $gt: 0 } }
  ]
});
```

### $or
Logiczny operator alternatywny

Zwraca dokumenty, dla których **co najmniej jedno** z podanych wyrażeń jest prawdziwe.

Diagram składni: `$or` `:` `[` `wyrażenie (dokument)` `,` `wyrażenie (dokument)` `]` — z adnotacją „co najmniej 2 wyrażenia”.

Najważniejsze informacje:
- Łączy warunki za pomocą alternatywy (OR).
- Musi zawierać co najmniej 2 wyrażenia.
- Dopuszczalne tylko na najwyższym poziomie zapytania.

Przykład:

```js
db.orders.find({
  $or: [
    { price: { $lt: 10 } },
    { quantity: { $gt: 100 } }
  ]
});
```

**Warto wiedzieć**
- Operatory $and i $or można łączyć z innymi operatorami zapytania (np. $eq, $gt, $in).
- Jeśli podasz tylko jedno wyrażenie, użyj samego wyrażenia bez $and lub $or.
- MongoDB wykonuje optymalizację zapytań z operatorami logicznymi.

**Dobra praktyka**
- Używaj $and, gdy wszystkie warunki muszą być spełnione.
- Używaj $or, gdy wystarcza, że spełniony jest przynajmniej jeden warunek.
- Dbaj o odpowiednie indeksy na polach używanych w warunkach logicznych.
- Testuj wydajność złożonych zapytań (explain()).

**Powiązane operatory**
| Operator | Opis |
|---|---|
| $not | Neguje wynik wyrażenia. |
| $nor | Zwraca dokumenty, które nie spełniają żadnego z podanych wyrażeń. |
| $in | Sprawdza, czy pole ma jedną z podanych wartości. |
| $exists | Sprawdza, czy pole istnieje. |

## Slajd 127 — MongoDB – operator $not

> [Grafika] Plansza z logo MongoDB. Podtytuł: Logiczny operator negacji warunku. Opis: Operator $not neguje wynik innego operatora zapytania i zwraca dokumenty, które nie spełniają określonego warunku. Zielona ramka z ikoną „i”: Operator $not dotyczy dokładnie jednego operatora zapytania. Nie można go używać na najwyższym poziomie zapytania.

### $not
Operator logiczny

Zwraca dokumenty, które **nie spełniają** warunku określonego przez podany operator (np. $gt, $lt, $regex, $in itp.).

**Składnia**

```js
{ pole: { $not: { <operator>: <wartość> } } }
```

**Diagram składni:** `$not` `:` `{` `query operator (np. $gt, $regex, $in, ...)` `}`

### Przykłady
Różne zastosowania operatora $not

**1. Negacja porównania**

```js
db.products.find({
  price: { $not: { $gt: 100 } }
});
```

Zwraca dokumenty, w których cena **nie jest większa niż 100** (tj. ≤ 100).

**2. Negacja wielu warunków z $and**

```js
db.products.find({
  $and: [
    { category: 'Electronics' },
    { price: { $not: { {lt: 50, $gt: 200 } } } }
  ]
});
```

Zwraca dokumenty z kategorii „Electronics”, w których cena **nie mieści się w zakresie 50–200**.

**3. Negacja dopasowania wzorca**

```js
db.products.find({
  name: { $not: /apple/i }
});
```

Zwraca dokumenty, w których nazwa **nie pasuje do wzorca** /apple/i.

**Warto wiedzieć**
- Operator $not dotyczy dokładnie jednego operatora zapytania.
- **Nie** można go używać na najwyższym poziomie zapytania.
- Można go łączyć z takimi operatorami jak: $gt, $lt, $gte, $lte, $regex, $in, $nin, $exists, $type itp.
- Operator $not zwraca dokumenty, które **nie spełniają** podanego warunku.
- W przypadku tablic operator może mieć nieoczywiste zachowanie – warto przetestować zapytanie na przykładach.

**Dobra praktyka**
- Używaj $not, gdy chcesz wykluczyć określone wartości lub wzorce.
- Stosuj indeksy na polach używanych w warunkach, aby poprawić wydajność zapytań.
- Testuj zapytania na przykładowych danych.
- W przypadku złożonych warunków rozważ użycie $and lub $or zamiast zagnieżdżania wielu negacji.

**Powiązane operatory**
| Operator | Opis |
|---|---|
| $and | Łączy wiele warunków (koniunkcja) |
| $or | Łączy alternatywne warunki (alternatywa) |
| $regex | Dopasowanie wzorca w ciągu znaków |
| $in | Sprawdza, czy wartość należy do zbioru |
| $nin | Sprawdza, czy wartość nie należy do zbioru |

## Slajd 128 — Przeszukiwanie tablic

Warunek bazujący na **równości wartości** jest spełniony gdy:
- dane pole w całości jest identyczne do podanej wartości lub
- przynajmniej 1 element tablicy jest identyczny do podanej wartości

```js
db.movies.find( { actors: ObjectId("5") } )
```

```js
{ actors: ObjectId("5") }
```

```js
{ actors: [ ObjectId("5"), ObjectId("7") ] }
```

## Slajd 129 — Przeszukiwanie tablic

Warunku bazujące na **pozostałych operatorach** są spełnione gdy:
- pole jako całość spełnia wszystkie narzucone operatory, lub
- każdy z wymienionych operatorów został dopasowany do co najmniej jednego elementu podanej tablicy
  - Jednakże ten element **może nie być tym samym** dla poszczególnych operatorów.

```js
db.movies.find( { ratings: { $gte: 2, $lte: 3 } } )
```

```js
{ ratings: 3 }
```

```js
{ ratings: [ 3, 7, 5 ] }
```

```js
{ ratings: [ 1, 4 ] }
```

Użyj $elemMatch gdy pojedynczy element tablicy powinien zostać dopasowany do wszystkich operatorów

## Slajd 130 — Projekcja

**Projekcja** umożliwia określenie pól zwracanych w rezultacie

> [Grafika] Diagram składni: `{` `field` `:` jedna z wartości `1` / `true` / `0` / `false`, albo `array field` `:` `{` `projection operator` `}` (pętla przecinka dla kolejnych pól) `}`.

- **true** lub 1 dla pól, które mają **zostać dołączone**
- **false** lub 0 dla pól, które **nie mają zostać uwzględnione**
- Wartości dodanie i ujemne nie mogą zostać użyte wspólnie!
  - Jedynym wyjątkiem jest _poleId które jest **domyślnie dodawane**
- **Operatory projekcji** – umożliwiają też wybór poszczególnych elementów tablicy

## Slajd 131 — Operatory projekcji

**Operatory tablicowe**
- **$elemMatch** – wybiera pierwszy pasujący element tablicy. Ten element musi spełniać wszystkie operatory zapytania. Gdy nie ma takiego elementu, żadne pole nie jest zwracane.

> [Grafika] Diagram składni: `$elemMatch` `:` `query`.

- **$slice** – wybiera pierwsze count elementów tablicy (gdy *count* jest dodatnie) / ostatnie count elementów (gdy ujemne) Pewna liczba elementów może zostać pominięta.

> [Grafika] Diagram składni: `$slice` `:` `count` albo `[` `skip` `,` `count` `]`.

## Slajd 132 — Projekcja: Przykłady

Znajdź dany film, wybierz jego identyfikator, tytuł i aktorów

```js
db.movies.find(
   { _id: ObjectId("2") },
   { title: true, actors: true }
)
```

```js
{
   _id: ObjectId("2"), title:
   "TombRaider", actors: [
   ObjectId("6"),
                ObjectId("4"),
                ObjectId("5") ]
}
```

Znajdź filmy z *2001*, wybierz ich tytuły i ostatnich dwóch aktorów

```js
db.movies.find(
   { year: 2001 },
   {
      title: 1, _id: 0, actors: {
      $slice: -2 }
   }
)
```

```js
{
   title: "Tomb Raider", actors: [
   ObjectId("4"),
                ObjectId("5") ]
}
```

## Slajd 133 — Modyfikatory

- **Modyfikatory** zmieniają kolejność/liczbę zwróconych dokumentów
  - **sort**– porządkuje dokumenty uwzględnione w rezultacie
  - **limit**– zwraca co najwyżej określoną liczbę dokumentów
    > [Grafika] Diagram składni (railroad): `limit` → `(` → `count` → `)`.
  - **skip**– pomija pewną liczbę dokumentów (licząc od początku)
    > [Grafika] Diagram składni (railroad): `skip` → `(` → `offset` → `)`.
- Wszystkie modyfikatory są opcjonalne, mogą być łańcuchowane **w dowolnej kolejności** (bez żadnych skutków ubocznych), ale **muszą być podane zanim dokumenty zostaną zwrócone** za pośrednictwem kursora.

## Slajd 134 — Modyfikatory

**Modyfikator sortowania** porządkuje dokumenty

> [Grafika] Diagram składni (railroad): `sort` → `(` → `{` → `field` → `:` → `1` lub `-1` → (opcjonalnie pętla z `,` powrotem do kolejnego `field`) → `}` → `)`.

- **1** dla porządku **rosnącego**, **-1** dla **malejącego** porządku
- Kolejność dokumentów jest domyślnie niezdefiniowana (chyba że użyto modyfikatora sortowania)
- Sortowanie dużych zbiorów danych powinno uwzględniać dodanie stosownych indeksów.
- **Sortowanie następuje przed projekcją**
  tj. nie uwzględnione (rezultacie) pola mogą być wykorzystane na potrzeby sortowania

## Slajd 135 — Modyfikatory - przykłady

```js
db.users.find({ }).sort( { age : -1, posts: 1 } )
```

```js
db.myColl.find().sort({_id: 1}).limit(6).skip(3);
```

```js
db.myColl.find().sort({_id: 1}).skip(3).limit(6);
```

## Slajd 136 — MongoDB CRUD Operations

### Operacje odczytu

Operacje odczytu pobierają dokumenty z kolekcji ; tj. przeszukują kolekcję pod kątem dokumentów.
MongoDB udostępnia następujące metody odczytu dokumentów z kolekcji:

- `db.collection.find()`

Można określić filtry zapytania lub kryteria identyfikujące dokumenty do zwrócenia.

```js
db.users.find(
   { age: { $gt: 18 } },
   { name: 1, address: 1 }
).limit(5)
```

> [Grafika] Strzałki po prawej wskazują na części polecenia: `db.users.find(` ← collection; `{ age: { $gt: 18 } },` ← query criteria; `{ name: 1, address: 1 }` ← projection; `).limit(5)` ← cursor modifier.

## Slajd 137 — MongoDB CRUD Operations

> [Grafika] Tabela porównawcza z dwiema kolumnami: „SQL SELECT Statements” (po lewej) i „MongoDB find() Statements” (po prawej). Wiersze:

| SQL SELECT Statements | MongoDB find() Statements |
|---|---|
| `SELECT *`<br>`FROM people` | `db.people.find()` |
| `SELECT id,`<br>`       user_id,`<br>`       status`<br>`FROM people` | `db.people.find(`<br>`    { },`<br>`    { user_id: 1, status: 1 }`<br>`)` |
| `SELECT user_id, status`<br>`FROM people` | `db.people.find(`<br>`    { },`<br>`    { user_id: 1, status: 1, _id: 0 }`<br>`)` |
| `SELECT *`<br>`FROM people`<br>`WHERE status = "A"` | `db.people.find(`<br>`    { status: "A" }`<br>`)` |
| `SELECT user_id, status`<br>`FROM people`<br>`WHERE status = "A"` | `db.people.find(`<br>`    { status: "A" },`<br>`    { user_id: 1, status: 1, _id: 0 }`<br>`)` |

## Slajd 138 — MongoDB CRUD Operations

> [Grafika] Tabela porównawcza SQL (lewa kolumna) i MongoDB find() (prawa kolumna), bez nagłówków kolumn:

| SQL | MongoDB |
|---|---|
| `SELECT *`<br>`FROM people`<br>`WHERE status != "A"` | `db.people.find(`<br>`    { status: { $ne: "A" } }`<br>`)` |
| `SELECT *`<br>`FROM people`<br>`WHERE status = "A"`<br>`AND age = 50` | `db.people.find(`<br>`    { status: "A",`<br>`      age: 50 }`<br>`)` |
| `SELECT *`<br>`FROM people`<br>`WHERE status = "A"`<br>`OR age = 50` | `db.people.find(`<br>`    { $or: [ { status: "A" } , { age: 50 } ] }`<br>`)` |
| `SELECT *`<br>`FROM people`<br>`WHERE age > 25` | `db.people.find(`<br>`    { age: { $gt: 25 } }`<br>`)` |
| `SELECT *`<br>`FROM people`<br>`WHERE age < 25` | `db.people.find(`<br>`   { age: { $lt: 25 } }`<br>`)` |

## Slajd 139 — MongoDB CRUD Operations

> [Grafika] Tabela porównawcza SQL (lewa kolumna) i MongoDB find() (prawa kolumna); część poleceń po prawej jest obcięta paskiem przewijania (widoczny fragment):

| SQL | MongoDB |
|---|---|
| `SELECT *`<br>`FROM people`<br>`WHERE age > 25`<br>`AND   age <= 50` | `db.people.find(`<br>`    { age: { $gt: 25, $lte: 50 } }`<br>`)` |
| `SELECT *`<br>`FROM people`<br>`WHERE user_id like "%bc%"` | `db.people.find( { user_id: /bc/ } )`<br>-or-<br>`db.people.find( { user_id: { $regex: /bc/ } } )` |
| `SELECT *`<br>`FROM people`<br>`WHERE user_id like "bc%"` | `db.people.find( { user_id: /^bc/ } )`<br>-or-<br>`db.people.find( { user_id: { $regex: /^bc/ } } )` |
| `SELECT *`<br>`FROM people`<br>`WHERE status = "A"`<br>`ORDER BY user_id ASC` | `….find( { status: "A" } ).sort( { user_id: 1 } )` (początek polecenia obcięty) |
| `SELECT *`<br>`FROM people`<br>`WHERE status = "A"`<br>`ORDER BY user_id DESC` | `find( { status: "A" } ).sort( { user_id: -1 } )` (początek polecenia obcięty) |

## Slajd 140 — MongoDB CRUD Operations

> [Grafika] Tabela porównawcza SQL (lewa kolumna) i MongoDB (prawa kolumna); część poleceń po prawej obcięta paskiem przewijania:

| SQL | MongoDB |
|---|---|
| `SELECT COUNT(*)`<br>`FROM people` | `db.people.count()`<br>or<br>`db.people.find().count()` |
| `SELECT COUNT(user_id)`<br>`FROM people` | `.people.count( { user_id: { $exists: true } } )` (początek obcięty)<br>or<br>`.find( { user_id: { $exists: true } } ).count()` (początek obcięty) |
| `SELECT COUNT(*)`<br>`FROM people`<br>`WHERE age > 30` | `db.people.count( { age: { $gt: 30 } } )`<br>or<br>`db.people.find( { age: { $gt: 30 } } ).count()` |
| `SELECT DISTINCT(status)`<br>`FROM people` | `…gregate( [ { $group : { _id : "$status" } } ] )` (początek obcięty)<br>or, for distinct value sets that do not exceed the BSON size limit<br>`db.people.distinct( "status" )` |

## Slajd 141 — MongoDB CRUD Operations

| SQL | MongoDB |
|---|---|
| `SELECT *`<br>`FROM people`<br>`LIMIT 1` | `db.people.findOne()`<br>or<br>`db.people.find().limit(1)` |
| `SELECT *`<br>`FROM people`<br>`LIMIT 5`<br>`SKIP 10` | `db.people.find().limit(5).skip(10)` |
| `EXPLAIN SELECT *`<br>`FROM people`<br>`WHERE status = "A"` | `db.people.find( { status: "A" } ).explain()` |

## Slajd 142 — MongoDB Schema Validation

Link w prawym górnym rogu: jsonSchema

Domyślnie MongoDB ma elastyczny schemat. Oznacza to, że początkowo nie ma ściśle skonfigurowanej walidacji schematu. Można utworzyć reguły walidacji schematu, aby mieć pewność, że wszystkie dokumenty w kolekcji mają podobną strukturę.

```js
db.createCollection("posts", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["title", "body"],
      properties: {
        title: {
          bsonType: "string",
          description: "Title of post - Required."
        },
        body: {
          bsonType: "string",
          description: "Body of post - Required."
        },
        category: {
          bsonType: "string",
          description: "Category of post - Optional."
        }
      }
    }
  },
  validationLevel: "strict",   // na start: pełna walidacja
  validationAction: "error"    // na start: odrzucaj błędne
})
```

```js
db.createCollection("sales", {
  validator: {
    "$and": [
      // Validation with query operators
      {
        "$expr": {
          "$lt": ["$lineItems.discountedPrice", "$lineItems.price"]
        }
      },
      // Validation with JSON Schema
      {
        "$jsonSchema": {
          "properties": {
            "items": { "bsonType": "array" }
          }
        }
      }
    ]
  }
)
```

**Podsumowanie:**
- $jsonSchema służy do walidacji strukturalnej, sprawdzając typy pól, wymagania co do obecności pól i inne aspekty typowe dla schematu JSON.
- $expr jest bardziej elastyczny, umożliwiając walidację z wykorzystaniem logiki, operacji arytmetycznych i porównawczych, co daje więcej możliwości w dynamicznych przypadkach.
Można używać ich razem, aby stworzyć zaawansowany system walidacji, który obejmuje zarówno statyczną strukturę, jak i dynamiczne warunki.

```js
db.posts.insertOne({title:'New title',body:'New body',category:'New category'})

db.posts.insertOne({title:'New title',newbody:'New body',category:'New category'})
```

## Slajd 143 — MongoDB Schema Validation

```js
db.createCollection("posts", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["title", "body"],
      properties: {
        title: {
          bsonType: "string",
          description: "Title of post - Required."
        },
        body: {
          bsonType: "string",
          description: "Body of post - Required."
        },
        category: {
          bsonType: "string",
          description: "Category of post - Optional."
        }
      }
    }
  },
  validationLevel: "strict",   // na start: pełna walidacja
  validationAction: "error"    // na start: odrzucaj błędne
})
```

Tabela po prawej (zrzut):

| Parametr | Opis | Przykład wartości |
|---|---|---|
| validator | Obiekt definiujący reguły walidacji (najczęściej z użyciem $jsonSchema). | `{ $jsonSchema: { ... } }` |
| $jsonSchema | Specyfikacja schematu w stylu JSON Schema, określa typy, wymagane pola, dodatkowe właściwości. | `bsonType: "object"` |
| required | Tablica nazw pól, które muszą wystąpić w dokumencie. | `["title", "body"]` |
| properties | Definicja poszczególnych pól (typ, opis, dodatkowe reguły). | `{ title: { bsonType: "string" } }` |
| additionalProperties | Określa, czy dozwolone są pola spoza schematu (true lub false). | `false` |
| validationLevel | Poziom walidacji:<br>- strict → pełna walidacja całego dokumentu po każdej operacji.<br>- moderate → walidacja tylko nowych dokumentów i modyfikowanych pól.<br>- off → wyłączenie walidacji. | strict / moderate / off |
| validationAction | Reakcja na niezgodność:<br>- error → odrzuca operację.<br>- warn → zapisuje dokument, ale generuje ostrzeżenie w logach. | error / warn |

> [Grafika] Mały zielony ramka na dole z fragmentem kodu (bardzo drobny, częściowo nieczytelny): `validator: { $jsonSchema: { bsonType: "object", required: ["title","body"], additionalProperties: false, properties: { _id: {}, // [nieczytelne] title: { bsonType: "string" }, body: { bsonType: "string" }, category: { bsonType: "string" } } } }`. Niebieska strzałka łączy go z linijką `additionalProperties: false` i z ramką z opisem:

dokument **nie może zawierać żadnych dodatkowych pól** poza tymi, które są jawnie wymienione w properties

## Slajd 144 — MongoDB Schema Validation

### Sprawdzenie walidatora przypisanego do kolekcji

```js
db.runCommand({
  listCollections: 1,
  filter: { name: "posts" }
})

db.getCollectionInfos({ name: "posts" })
```

### Usunięcie walidatora przypisanego do kolekcji

```js
db.runCommand({
  collMod: "posts", // Nazwa kolekcji
  validator: {},    // Ustaw pusty obiekt dla walidatora
  validationLevel: "off" // Możesz również wyłączyć walidację
})
```

### Wyłączenie walidacji przypisanej do kolekcji

```js
db.runCommand({
  collMod: "posts", // Nazwa kolekcji
  validationLevel: "off" // Wyłączenie walidacji dla tej kolekcji
})
```

**Walidacja na poziomie aktualizacji danych**
Możesz też kontrolować walidację w przypadku aktualizacji danych, stosując opcje takie jak:
validationLevel: **strict** – Wymusza pełną walidację zarówno na nowych dokumentach, jak i na aktualizacjach.
validationLevel: **moderate** – Walidacja tylko dla nowych dokumentów i aktualizowanych pól (istniejące dokumenty mogą nie spełniać schematu).
validationAction: **error** – Operacje niezgodne ze schematem będą odrzucane.
validationAction: **warn** – Operacje niezgodne ze schematem będą zapisywane, ale wyświetlone zostanie ostrzeżenie.

> [Grafika] Czerwona ramka w prawym dolnym rogu: **runCommand()** - uniwersalna funkcja MongoDB służąca do wykonywania **poleceń administracyjnych i specjalnych komend**

## Slajd 145 — MongoDB Schema Validation – obiekty zagnieżdżone

```js
db.createCollection("posts", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["title", "body", "author"],   // <-- author jest wymagany
      additionalProperties: false,             // blokujemy pola spoza schematu
      properties: {
        _id: {},                               // zostawiamy systemowe pole
        title: { bsonType: "string" },
        body:  { bsonType: "string" },

        // OPCJONALNE pole:
        category: { bsonType: "string" },

        // WYMAGANY zagnieżdżony obiekt:
        author: {
          bsonType: "object",
          required: ["name", "email"],         // pola wymagane w środku
          additionalProperties: false,         // nie pozwalaj na śmieci wewnątrz
          properties: {
            name:  { bsonType: "string" },
            email: {
              bsonType: "string",
              pattern: "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$",
              description: "Prosta walidacja formatu e-mail"
            },
```

> [Grafika] Zrzut kodu obcięty u dołu slajdu (dalszy ciąg niewidoczny).

## Slajd 146 — Aggregation Framework

Aggregation Framework jest wszechstronnym narzędziem MongoDB służącym do przetwarzania, transformacji i analizy danych.

Typowe zastosowania obejmują:
- analitykę danych w czasie rzeczywistym,
- generowanie raportów zawierających zestawienia, sumy, średnie i inne statystyki,
- zasilanie paneli analitycznych (dashboardów),
- łączenie danych z wielu kolekcji po stronie serwera ($lookup),
- przekształcanie i przygotowywanie danych do celów analitycznych i Data Science,
- analizę dużych wolumenów danych,
- realizację złożonych zapytań wymagających grupowania, filtrowania, sortowania i transformacji danych,
- przygotowywanie danych na potrzeby uczenia maszynowego oraz integrację z narzędziami takimi jak MongoDB Spark Connector,
- oraz wiele innych zadań związanych z przetwarzaniem danych.

Dzięki potokowi agregacji (Aggregation Pipeline) większość operacji może być wykonywana bezpośrednio po stronie serwera, co ogranicza transfer danych i poprawia wydajność aplikacji.

## Slajd 147 — Aggregation Pipeline

Definiujemy potok gotowy do wykonania agregacji:

```js
var pipeline = [
  // Match engineers only
  {"$match": {
    "vocation": "ENGINEER",
  }},

  // Sort by youngest person first
  {"$sort": {
    "dateofbirth": -1,
  }},

  // Only include the first 3 youngest people
  {"$limit": 3},

  // Exclude unrequired fields from each person record
  {"$unset": [
    "_id",
    "vocation",
    "address",
  ]},
];
```

> [Grafika] Czerwona ramka przy kodzie: "Pokaż 3 najmłodszych inżynierów, ale bez pól _id, vocation i address."

> [Grafika] Diagram po prawej: „Source Collection” (stos dokumentów) → etap „Match” (niebieski, lejek) w obrębie „Aggregation Pipeline #1” → „Intermediate Data-Set”; dalej „Intermediate Data-Set” → etap „Group” (pomarańczowy, lejek) w obrębie „Aggregation Pipeline #2” → „Final Result”. Strzałki w dół między kolejnymi elementami.

Wykonujemy agregację przy użyciu zdefiniowanego potoku:

```js
db.persons.aggregate(pipeline);
```

## Slajd 148 — Aggregation Pipeline, a MQL

```js
db.persons.aggregate(pipeline);
```

Dla porównania, odpowiednik MQL (MongoDB Query Language), pozwala osiągnąć ten sam wynik jak poprzedni Aggregation Pipeline (nie ma tutaj jednak grupowania)

```js
db.persons.find(
    {"vocation": "ENGINEER"},
    {"_id": 0, "vocation": 0, "address": 0},
  ).sort(
    {"dateofbirth": -1}
  ).limit(3);
```

Aggregation Pipeline jest obsługiwany przez specjalny mechanizm w MongoDB (Aggregation Runtime), który **jest zoptymalizowany do przetwarzania dużych ilości danych** i wykonywania operacji takich jak:
- $match (filtrowanie),
- $group (grupowanie),
- $sort (sortowanie),
- $project (transformacja pól),
- $lookup (łączenie kolekcji).

Dzięki temu możemy wykonywać złożone analizy danych bez opuszczania bazy

> [Grafika] Diagram architektury: u góry „Application” zawierająca „MongoDB Driver” z dwoma blokami „MQL API” i „Agg API”; gruba strzałka w dół od drivera do dolnego bloku „MongoDB Database Runtime”, w którym są „Query Runtime” oraz mniejszy blok „Aggregation Runtime”.

## Slajd 149 — Explain plan

```js
db.persons.explain("executionStats").aggregate(pipeline);
```

**W MongoDB, gdy tworzymy zapytania w MQL lub używamy Aggregation Pipeline, warto sprawdzić plan wykonania, aby:**
- upewnić się, że używany jest odpowiedni indeks,
- ocenić wydajność zapytania,
- zdecydować, czy trzeba zoptymalizować model danych lub zapytanie.

**Co daje plan?**
- pokazuje, jak MongoDB przetwarza zapytanie.
- umożliwia analizę kosztów operacji (np. skan całej kolekcji vs. użycie indeksu).

**Tryby szczegółowości explain():**
- queryPlanner – podstawowy plan (jakie indeksy, strategia)
- executionStats – dodatkowo statystyki wykonania (liczba dokumentów, czas)
- allPlansExecution – pełne dane o wszystkich rozważanych planach i ich statystykach.

```js
// QueryPlanner verbosity  (default if no verbosity parameter provided)
db.coll.explain("queryPlanner").aggregate(pipeline);

// ExecutionStats verbosity
db.coll.explain("executionStats").aggregate(pipeline);

// AllPlansExecution verbosity
db.coll.explain("allPlansExecution").aggregate(pipeline);
```

Dodatkowe ramki po prawej (odpowiedniki dla find):

```js
db.coll.find(query).explain("queryPlanner");
```

```js
db.coll.find(query).explain("executionStats");
```

```js
db.coll.find(query).explain("allPlansExecution");
```

## Slajd 150 — MongoDB dla VS Code

> [Grafika] Zrzut ekranu VS Code z rozszerzeniem MongoDB. Lewy panel „MONGODB”: sekcja CONNECTIONS (localhost:27017 connected, localhost:27018, localhost:27019, localhost:27020), sekcja PLAYGROUNDS („No MongoDB playground files found in the workspace.” i przycisk „Create New Playground”), sekcja HELP AND FEEDBACK (What's New, Extension Documentation, MongoDB Documentation, Suggest a Feature, Report a Bug, Create Free Atlas Cluster). Środkowy edytor (plik playground-1.mongodb.js, „Currently connected to localhost:27017. Click here to change cor…”) z kodem poniżej; prawy panel „Playground Result” z wynikiem.

```js
var pipeline = [
  // Match engineers only
  {"$match": {
    "vocation": "ENGINEER",
  }},

  // Sort by youngest person first
  {"$sort": {
    "dateofbirth": -1,
  }},

  // Only include the first 3 youngest peo
  {"$limit": 3},

  // Exclude unrequired fields from each p
  {"$unset": [
    "_id",
    "vocation",
    "address",
  ]},
];

db.persons.aggregate(pipeline);
```

Wynik (Playground Result):

```json
[
  {
    "person_id": "7363626383",
    "firstname": "Carl",
    "lastname": "Simmons",
    "dateofbirth": {
      "$date": "1998-12-26T13:13:55Z"
    }
  },
  {
    "person_id": "1723338115",
    "firstname": "Olive",
    "lastname": "Ranieri",
    "dateofbirth": {
      "$date": "1985-05-12T23:14:30Z"
    },
    "gender": "FEMALE"
  },
  {
    "person_id": "6392529400",
    "firstname": "Elise",
    "lastname": "Smith",
    "dateofbirth": {
      "$date": "1972-01-13T09:32:07Z"
    }
  }
]
```

Pasek statusu: Ln 24, Col 1, Spaces: 4, UTF-8, CRLF, JavaScript.

## Slajd 151 — Polecenie aggregate()

Prawy górny róg: `db.people.aggregate()`

| SQL Terms, Functions, and Concepts | MongoDB Aggregation Operators |
|---|---|
| WHERE | $match |
| GROUP BY | $group |
| HAVING | $match |
| SELECT | $project |
| ORDER BY | $sort |
| LIMIT | $limit |
| SUM() | $sum |
| COUNT() | $sum, $sortByCount |
| join | $lookup |
| SELECT INTO NEW_TABLE | $out |
| MERGE INTO TABLE | $merge (Available starting in MongoDB 4.2) |
| UNION ALL | $unionWith (Available starting in MongoDB 4.4) |

Na dole: https://www.practical-mongodb-aggregations.com/

## Slajd 152 — Grupowanie danych (aggregate)

```
-- Grupowanie danych --
Metoda aggregate() - pozwala na grupowanie danych na podstawie danego klucza.
db.nazwa_kolekcji.aggregate({ $group : { _id : "klucz" }, "wynik" : {$agregacja : wartosc} })


> Operatory agregujące ($agregacja)
```

| Operator | Opis |
|---|---|
| $sum | Suma |
| $avg | Średnia |
| $min | Minimalna wartość |
| $max | Maksymalna wartość |

```
> Rozbudowany format (podawany jako pierwszy argument). Przykład

[
  { $match: { status: "A" } },
  { $group: { _id: "$cust_id", total: { $sum: "$amount" } } },
  { $sort: { total: -1 } },
  { $limit: 2 }
]

Operatory:
    • $match - grupowane tylko dokumenty spełniające warunek
    • $sort - sortowanie wyników rosnąco/malejąco
    • $limit - ilość wyświetlanych wyników

Należy pamiętać:
    • Jeżeli chcemy zliczyć ilość dokumentów w danej grupie, użyjemy { $sum : 1 }
```

> [Grafika] Ramka nałożona na kod: „Etapy potoku (pipeline stages)” z listą: $match, $group, $sort, $project, $limit, $count.

> [Grafika] Tabela w ramce po prawej (zrzut, drobny druk): Operator / Opis: $sum – suma; $avg – średnia; $min – minimum; $max – maksimum; $count – liczba dokumentów; $first – pierwsza wartość w grupie; $last – ostatnia wartość w grupie; $push – zbiera wartości do tablicy; $addToSet – zbiera unikalne wartości do tablicy; $stdDevPop – odchylenie standardowe populacji; $stdDevSamp – odchylenie standardowe próby; $top – zwraca element o najwyższym sortowaniu; $bottom – zwraca element o najniższym sortowaniu.

## Slajd 153 — MongoDB Aggregation Pipelines

Operacje agregacji umożliwiają grupowanie, sortowanie, wykonywanie obliczeń, analizowanie danych i wiele więcej. Potoki agregacji mogą mieć jeden lub więcej „etapów”. Kolejność tych etapów jest istotna. Każdy etap działa na podstawie wyników poprzedniego etapu.

```js
db.posts.aggregate([
  // Stage 1: Only find documents that have more than 1 like
  {
    $match: { likes: { $gt: 1 } }
  },
  // Stage 2: Group documents by category and sum each categories likes
  {
    $group: { _id: "$category", totalLikes: { $sum: "$likes" } }
  }
])
```

```js
[ { _id: 'News', totalLikes: 3 }, { _id: 'Event', totalLikes: 8 } ]
```

Na dole: https://www.w3schools.com/mongodb/mongodb_aggregations_intro.php

## Slajd 154 — Aggregation $group

Na tym etapie agregacji dokumenty są grupowane według unikalnego `_id` podanego wyrażenia.

To polecenie zwróci wszystkie różne wartości zapisane w polu **property_type**.

```js
db.listingsAndReviews.aggregate(
    [ { $group : { _id : "$property_type" } } ]
)
```

> [Grafika] Zrzut przykładowego dokumentu (kolekcja listingsAndReviews, w ciemnym edytorze), z podświetloną linią `"property_type": "Apartment",`:

```json
{
  "_id": "10009999",
  "listing_url": "https://www.airbnb.com/rooms/10009999",
  "name": "Horto flat with small garden",
  "summary": "One bedroom + sofa-bed in quiet and bucolic n
  "space": "Lovely one bedroom + sofa-bed in the living roo
  "description": "One bedroom + sofa-bed in quiet and bucol
  "neighborhood_overview": "This charming ground floor flat
  "notes": "There's a table in the living room now, that do
  "transit": "Easy access to transport (bus, taxi, car) and
  "access": "",
  "interaction": "I'll be happy to help you with any doubts
  "house_rules": "I just hope the guests treat the space as
  "property_type": "Apartment",
  "room_type": "Entire home/apt",
  "bed_type": "Real Bed",
  "minimum_nights": "2",
  "maximum_nights": "1125",
```

**Output**

```js
[
  { _id: 'Earth house' },
  { _id: 'Train' },
  { _id: 'Guest suite' },
  { _id: 'Hotel' },
  { _id: 'Campsite' },
  { _id: 'Resort' },
  { _id: 'Houseboat' },
  { _id: 'Boat' },
  { _id: 'Pension (South Korea)' },
  { _id: 'Condominium' },
  { _id: 'Chalet' },
  { _id: 'Casa particular (Cuba)' },
  { _id: 'Castle' },
  { _id: 'Boutique hotel' },
  { _id: 'Nature lodge' },
  { _id: 'Villa' },
  { _id: 'Hut' },
  { _id: 'Apartment' },
  { _id: 'Camper/RV' },
  { _id: 'Hostel' }
]
```

## Slajd 155 — Aggregation $group

Operator $group w MongoDB służy do grupowania dokumentów na podstawie określonych kryteriów i wykonywania operacji agregacyjnych na każdej grupie. Wykorzystuje się go w ramach potoku agregacji, co umożliwia m.in. sumowanie wartości, wyliczanie średnich, wyciąganie minimalnych lub maksymalnych wartości oraz łączenie wyników. $group może być bardzo przydatny przy analizie danych, np. do liczenia ilości zamówień na użytkownika, sumowania wartości zakupów czy wyliczania statystyk dla wybranych kategorii.

**Podstawowa struktura** `$group`

```js
{
  $group: {
    _id: <pole lub wyrażenie określające kryterium grupowania>,
    <pole_agregacji>: { <operator_agregacyjny>: <pole> }
  }
}
```

```js
db.produkty.aggregate([
  {
    $group: {
      _id: "$kategoria",
      totalnaWartosc: { $sum: "$cena" }
    }
  }
])
```

- **_id**: służy jako klucz grupy. Można tu podać pojedyncze pole, wyrażenie, czy też null (jeśli chcemy przetwarzać wszystkie dokumenty w jednej grupie).
- Operator agregacyjny: obejmuje m.in. $sum, $avg, $min, $max, $push, $addToSet.

```js
db.zamowienia.aggregate([
  {
    $group: {
      _id: "$klientId",
      liczbaZamowien: { $sum: 1 }
    }
  }
])
```

```js
db.produkty.aggregate([
  {
    $group: {
      _id: "$kategoria",
      sredniaCena: { $avg: "$cena" }
    }
  }
])
```

```js
db.artykuly.aggregate([
  {
    $group: {
      _id: "$kategoria",
      unikalneZnaczniki: { $addToSet: "$znacznik" }
    }
  }
])
```

Żółta ramka z przykładowym wynikiem (drobny druk):

```js
[
  { "_id": "technologia", "unikalneZnaczniki": ["AI", "ML"] },
  { "_id": "nauka", "unikalneZnaczniki": ["fizyka", "chemia"] }
]
```

## Slajd 156 — Aggregation $limit

Ten etap agregacji ogranicza liczbę dokumentów przekazywanych do następnego etapu.

To polecenie zwróci pierwszy znaleziony dokument (film) z kolekcji.

```js
db.movies.aggregate([ { $limit: 1 } ])
```

> [Grafika] Zrzut wyniku w ciemnym edytorze (obcięty u dołu):

```json
{
  "_id": {
    "$oid": "573a1390f29313caabcd4323"
  },
  "plot": "A young boy, opressed by his mother, goes on an outing in the
  "genres": [
    "Short",
    "Drama",
    "Fantasy"
  ],
  "runtime": 14,
  "rated": "UNRATED",
  "cast": [
    "Martin Fuller",
    "Mrs. William Bechtel",
    "Walter Edwin",
    "Ethel Jewett"
  ],
  "num_mflix_comments": 2,
```

## Slajd 157 — Aggregation $limit

Operator $limit w MongoDB jest używany w potoku agregacji do ograniczenia liczby dokumentów, które zostaną zwrócone po przetworzeniu wcześniejszych etapów. Umożliwia to zwrócenie tylko określonej liczby wyników, co może być przydatne, na przykład, gdy chcemy pobrać tylko pierwsze n dokumentów z wynikowego zestawu danych.

**Podstawowa składnia** `$limit`

```js
{
  $limit: <liczba_dokumentów_do_zwrotu>
}
```

```js
db.produkty.aggregate([
  { $limit: 5 }
])
```

$limit powinien być używany po etapach agregacji takich jak $sort czy $match, aby najpierw przefiltrować lub posortować dokumenty, a następnie ograniczyć liczbę zwracanych wyników.

```js
db.produkty.aggregate([
  { $sort: { cena: -1 } },
  { $limit: 3 }
])
```

```js
db.zamowienia.aggregate([
  { $match: { klientId: "12345" } },
  { $limit: 10 }
])
```

```js
db.artykuly.aggregate([
  { $sort: { data_dodania: -1 } },
  { $limit: 5 }
])
```

## Slajd 158 — Aggregation $project

Na tym etapie agregacji do następnego etapu agregacji przekazywane są tylko określone pola.

Zwrócone zostaną dokumenty, ale tylko te zawierające określone pola.

```js
db.restaurants.aggregate([
  {
    $project: {
      "name": 1,
      "cuisine": 1,
      "address": 1
    }
  },
  {
    $limit: 5
  }
])
```

> [Grafika] Niebieska strzałka w prawo prowadzi do przykładowego wyniku:

```js
{
  _id: ObjectId(...),
  name: "Riviera Caterer",
  cuisine: "American",
  address: {
    building: "2780",
    street: "Stillwell Avenue",
    zipcode: "11224",
    coord: [...]
  }
}
```

## Slajd 159 — Aggregation $project

Operator $project w MongoDB służy do określania, które pola powinny być zawarte w wynikowym dokumencie na danym etapie potoku agregacji. Umożliwia nie tylko wybór i wykluczenie pól, ale także tworzenie nowych pól, wykonywanie operacji na istniejących danych oraz zmienianie ich struktury.

**Składnia** `$project`

```js
{
  $project: {
    <nazwa_pola>: <wartość>,
    ...
  }
}
```

```js
db.uzytkownicy.aggregate([
  {
    $project: {
      imie: 1,
      wiek: 1
    }
  }
])
```

- 1 oznacza, że pole zostanie uwzględnione w wyniku.
- 0 oznacza, że pole zostanie wykluczone z wyniku.
- Można także używać wyrażeń, aby tworzyć nowe pola na podstawie istniejących lub przekształcać wartości.

```js
db.uzytkownicy.aggregate([
  {
    $project: {
      pelne_nazwisko: { $concat: ["$imie", " ", "$nazwisko"] }
    }
  }
])
```

```js
db.uzytkownicy.aggregate([
  {
    $project: {
      rok_urodzenia: { $year: "$data_urodzenia" }
    }
  }
])
```

```js
db.produkty.aggregate([
  {
    $project: {
      nazwa: 1,
      cena: 1,
      ilosc: 1,
      wartosc_calkowita: { $multiply: ["$cena", "$ilosc"] }
    }
  }
])
```

## Slajd 160 — Aggregation $sort

W ramach tego etapu agregacji wszystkie dokumenty są sortowane w określonej kolejności.

Dokumenty zostaną zwrócone w kolejności malejącej na podstawie wartości pola accommodates.

```js
db.listingsAndReviews.aggregate([
  {
    $sort: { "accommodates": -1 }
  },
  {
    $project: {
      "name": 1,
      "accommodates": 1
    }
  },
  {
    $limit: 5
  }
])
```

```js
[
  {
    _id: '19990097',
    name: 'House close to station & direct to opera house....',
    accommodates: 16
  },
  { _id: '19587001', name: 'Kaena O Kekai', accommodates: 16 },
  {
    _id: '20958766',
    name: 'Great Complex of the Cellars',
    accommodates: 16
  },
  {
    _id: '12509339',
    name: 'Barra da Tijuca beach house',
    accommodates: 16
  },
  {
    _id: '20455499',
    name: 'DOWNTOWN VIP MONTREAL ,HIGH END DECOR,GOOD VALUE..',
    accommodates: 16
  }
]
```

## Slajd 161 — Aggregation $sort

Operator $sort w MongoDB służy do sortowania dokumentów w ramach potoku agregacji na podstawie określonych pól i kolejności (rosnąco lub malejąco). Jest używany głównie do uporządkowania wyników po przetworzeniu wcześniejszych etapów agregacji. Może być przydatny w połączeniu z operatorem $limit, jeśli chcemy pobrać np. tylko najnowsze lub najdroższe dokumenty.

**Składnia** `$sort`

```js
{
  $sort: {
    <pole1>: <kolejność>,
    <pole2>: <kolejność>
  }
}
```

```js
db.produkty.aggregate([
  {
    $sort: { cena: 1 }
  }
])
```

- <pole>: Pole, według którego chcemy posortować dokumenty.<kolejność>:
- Wartość 1 oznacza sortowanie rosnące, a -1 sortowanie malejące.

```js
db.uzytkownicy.aggregate([
  {
    $sort: { wiek: 1, nazwisko: -1 }
  }
])
```

```js
db.uzytkownicy.aggregate([
  { $sort: { wiek: -1 } },
  { $limit: 5 }
])
```

```js
db.artykuly.aggregate([
  {
    $sort: { data_dodania: -1 }
  }
])
```

## Slajd 162 — Aggregation $match

Ten etap agregacji zachowuje się jak find. Będzie filtrować dokumenty, które pasują do podanego zapytania.

Zapytanie zwróci tylko dokumenty, które mają właściwość (pole) property_type o wartości "House".

```js
db.listingsAndReviews.aggregate([
  { $match : { property_type : "House" } },
  { $limit: 2 },
  { $project: {
    "name": 1,
    "bedrooms": 1,
    "price": 1
  }}
])
```

```js
[
  {
    _id: '10006546',
    name: 'Ribeira Charming Duplex',
    bedrooms: 3,
    price: Decimal128("80.00")
  },
  {
    _id: '10047964',
    name: 'Charming Flat in Downtown Moda',
    bedrooms: 2,
    price: Decimal128("527.00")
  }
]
```

## Slajd 163 — Aggregation $match

Operator $match w MongoDB służy do filtrowania dokumentów w ramach potoku agregacji na podstawie określonych kryteriów. Działa podobnie jak zwykły filtr find(), ale jest częścią potoku agregacji, co pozwala na filtrowanie dokumentów na wczesnym etapie przetwarzania danych. Dzięki $match można ograniczyć zbiór dokumentów do tych spełniających określone warunki, co często zwiększa efektywność całej operacji.

**Składnia** `$match`

```js
{
  $match: {
    <kryterium_pola1>: <wartość lub wyrażenie>,
    <kryterium_pola2>: <wartość lub wyrażenie>,
    ...
  }
}
```

```js
db.zamowienia.aggregate([
  {
    $match: {
      data_zamowienia: {
        $gte: new Date("2024-09-01"),
        $lte: new Date("2024-09-30")
      }
    }
  }
])
```

```js
db.produkty.aggregate([
  {
    $match: { cena: { $gt: 100 } }
  }
])
```

```js
db.produkty.aggregate([
  {
    $match: {
      kategoria: "elektronika",
      cena: { $lt: 500 }
    }
  }
])
```

```js
db.produkty.aggregate([
  {
    $match: {
      $or: [
        { kategoria: "elektronika" },
        { kategoria: "meble" }
      ]
    }
  }
])
```

```js
db.produkty.aggregate([
  {
    $match: {
      nazwa: { $regex: /^Sam/, $options: "i" }
    }
  }
])
```

```js
db.produkty.aggregate([
  {
    $match: { kategoria: "elektronika" }
  }
])
```

## Slajd 164 — Aggregation $addFields

Na tym etapie agregacji do dokumentów dodawane są nowe pola.

Zapytanie zwróci dokumenty oraz doda nowe pole avgGrade, zawierające średnią ocen (grades.score) dla każdej restauracji.

```js
db.restaurants.aggregate([
  {
    $addFields: {
      avgGrade: { $avg: "$grades.score" }
    }
  },
  {
    $project: {
      "name": 1,
      "avgGrade": 1
    }
  },
  {
    $limit: 5
  }
])
```

> [Grafika] Niebieska strzałka w prawo prowadzi do wyniku (obcięty u dołu):

```js
[
  {
    _id: ObjectId("5eb3d668b31de5d588f4292a"),
    name: 'Riviera Caterer',
    avgGrade: 9
  },
  {
    _id: ObjectId("5eb3d668b31de5d588f4292b"),
    name: "Wilken'S Fine Food",
    avgGrade: 10
  },
  {
    _id: ObjectId("5eb3d668b31de5d588f4292c"),
    name: 'Kosher Island',
    avgGrade: 10.5
  },
```

## Slajd 165 — Aggregation $addFields

Operator $addFields w MongoDB służy do dodawania nowych pól lub modyfikowania istniejących pól w dokumentach na etapie potoku agregacji. $addFields jest używany, gdy chcemy wzbogacić dokument o dodatkowe dane, na przykład na podstawie wyliczeń, istniejących wartości, czy przekształceń. Nowe pola mogą być wyrażeniami wykorzystującymi inne pola dokumentu, umożliwiając bardziej złożone operacje przetwarzania.

**Składnia** `$addFields`

```js
{
  $addFields: {
    <nazwa_pola>: <wartość lub wyrażenie>,
    ...
  }
}
```

```js
db.uzytkownicy.aggregate([
  {
    $addFields: {
      status: "aktywny"
    }
  }
])
```

```js
db.uzytkownicy.aggregate([
  {
    $addFields: {
      rok_urodzenia: { $year: "$data_urodzenia" }
    }
  }
])
```

```js
db.produkty.aggregate([
  {
    $addFields: {
      wartosc_calkowita: { $multiply: ["$cena", "$ilosc"] }
    }
  }
])
```

```js
db.uzytkownicy.aggregate([
  {
    $addFields: {
      kategoria: {
        $cond: { if: { $gte: ["$wiek", 18] }, then: "dorosły", else: "nieletni" }
      }
    }
  }
])
```

```js
db.uzytkownicy.aggregate([
  {
    $addFields: {
      pelne_nazwisko: { $concat: ["$imie", " ", "$nazwisko"] }
    }
  }
])
```

## Slajd 166 — Aggregation $count

Na tym etapie agregacji zliczana jest całkowita liczba dokumentów przekazanych na poprzednim etapie.

Polecenie zwróci liczbę dokumentów obliczoną przez $count w postaci pola o nazwie 'totalChinese'.

```js
db.restaurants.aggregate([
  {
    $match: { "cuisine": "Chinese" }
  },
  {
    $count: "totalChinese"
  }
])
```

> [Grafika] Niebieska strzałka w prawo prowadzi do wyniku:

```js
[ { totalChinese: 2418 } ]
```

## Slajd 167 — Aggregation $count

Operator $count w MongoDB służy do zliczania liczby dokumentów w potoku agregacji, które spełniają określone warunki. Wynikiem operacji z użyciem $count jest jeden dokument, który zawiera nazwane pole i odpowiadającą mu wartość będącą liczbą dokumentów. $count jest przydatny do szybkiego uzyskiwania liczby elementów pasujących do kryteriów bez konieczności używania dodatkowego zapytania.

**Składnia** `$count`

```js
{
  $count: "<nazwa_pola>"
}
```

<nazwa_pola>: Nazwa pola, które zostanie utworzone w wyniku i będzie zawierać wynik zliczenia.

```js
db.produkty.aggregate([
  {
    $count: "liczba_produktow"
  }
])
```

```js
db.produkty.aggregate([
  {
    $match: { kategoria: "elektronika" }
  },
  {
    $count: "liczba_elektroniki"
  }
])
```

```js
db.zamowienia.aggregate([
  {
    $match: { kwota: { $gt: 500 } }
  },
  {
    $count: "zamowienia_powyzej_500"
  }
])
```

```js
db.produkty.aggregate([
  {
    $group: {
      _id: "$kategoria",
      liczba_produktow: { $sum: 1 }
    }
  },
  {
    $match: { liczba_produktow: { $gte: 10 } }
  },
  {
    $count: "kategorie_z_min_10_produktow"
  }
])
```

## Slajd 168 — Aggregation $lookup

Na tym etapie agregacji wykonywane jest złączenie lewostronne zewnętrzne do kolekcji w tej samej bazie danych.
**Wymagane są cztery pola:**
- **from:** Kolekcja, która ma zostać użyta do wyszukiwania (łączenia) w tej samej bazie danych
- **localField:** Pole w kolekcji podstawowej, które może być używane jako unikatowy identyfikator kolekcji - from-.
- **foreignField:** Pole w kolekcji -from-, które może być używane jako unikatowy identyfikator w kolekcji podstawowej.
- **as:** Nazwa nowego pola, które będzie zawierać pasujące dokumenty ze kolekcji -from-.

```js
db.comments.aggregate([
  {
    $lookup: {
      from: "movies",
      localField: "movie_id",
      foreignField: "_id",
      as: "movie_details",
    },
  },
  {
    $limit: 1
  }
])
```

> [Grafika] Niebieska strzałka w prawo prowadzi do wyniku (drobny druk, obcięty u dołu):

```js
{
  _id: ObjectId("5a9427648b0beebeb69579e7"),
  name: 'Mercedes Tyler',
  email: 'mercedes_tyler@fakegmail.com',
  movie_id: ObjectId("573a1390f29313caabcd4323"),
  text: 'Eius veritatis vero facilis quaerat fuga
  date: ISODate("2002-08-18T04:56:07.000Z"),
  movie_details: [
    {
      _id: ObjectId("573a1390f29313caabcd4323"),
      plot: 'A young boy, opressed by his mother,
      genres: [ 'Short', 'Drama', 'Fantasy' ],
      runtime: 14,
      rated: 'UNRATED',
      cast: [
        'Martin Fuller',
        'Mrs. William Bechtel',
        'Walter Edwin',
        'Ethel Jewett'
      ],
      num_mflix_comments: 1,
```

Zapytanie zwróci dane filmu dołączone do każdego komentarza.

## Slajd 169 — Aggregation $lookup

Operator $lookup w MongoDB służy do wykonywania operacji dołączania (join) między dwiema kolekcjami. Umożliwia on łączenie dokumentów z jednej kolekcji z dokumentami w innej kolekcji na podstawie wspólnego pola. $lookup jest szczególnie przydatny w sytuacjach, gdy chcemy uzyskać informacje z różnych kolekcji w jednym zapytaniu, co przypomina klasyczne operacje JOIN w relacyjnych bazach danych.

**Składnia** `$lookup`

```js
{
  $lookup: {
    from: "<nazwa_kolekcji_docelowej>",
    localField: "<pole_lokalne>",
    foreignField: "<pole_zdalne>",
    as: "<nazwa_wyniku>"
  }
}
```

```js
db.uzytkownicy.aggregate([
  {
    $lookup: {
      from: "zamowienia",
      localField: "_id",
      foreignField: "uzytkownik_id",
      as: "zamowienia"
    }
  }
])
```

```js
db.produkty.aggregate([
  {
    $lookup: {
      from: "kategorie",
      localField: "kategoria_id",
      foreignField: "_id",
      as: "kategoria_info"
    }
  }
])
```

- from: Nazwa kolekcji, z której mają być dołączane dokumenty.
- localField: Pole w lokalnej kolekcji, które będzie używane do dopasowania.
- foreignField: Pole w dołączanej kolekcji, które będzie używane do dopasowania.
- as: Nazwa pola, w którym zostaną zapisane dołączone dokumenty.

## Slajd 170 — Aggregation $out

Na tym etapie agregacji dokumenty zwrócone z procesu agregacji są zapisywane w kolekcji.

Pierwszy etap grupuje właściwości według `property_type` i obejmuje pola `name`, `accommodates`, i `price` dla każdej z nich. `$out` Etap ten utworzy nową kolekcję o nazwie `properties_by_type` w bieżącej bazie danych i zapisze powstałe dokumenty do tej kolekcji.

```js
db.listingsAndReviews.aggregate([
  {
    $group: {
      _id: "$property_type",
      properties: {
        $push: {
          name: "$name",
          accommodates: "$accommodates",
          price: "$price",
        },
      },
    },
  },
  { $out: "properties_by_type" },
])
```

> [Grafika] Zrzut z MongoDB (VS Code/Compass) – drzewo kolekcji: `properties_by_type` → `Documents 36` → "Boat", "Loft", "Castle", "Barn".

> [Grafika] Zrzut przykładowego dokumentu w ciemnym edytorze:

```json
{
  "_id": "Boat",
  "properties": [
    {
      "name": "Myboat & Yacht rentals",
      "accommodates": 2,
      "price": {
        "$numberDecimal": "200.00"
      }
    },
    {
      "name": "Private cabin",
      "accommodates": 2,
      "price": {
        "$numberDecimal": "35.00"
      }
    }
  ]
}
```

## Slajd 171 — Aggregation $out

Operator $out w MongoDB służy do zapisywania wyników potoku agregacji bezpośrednio do nowej kolekcji. Jest to przydatne, gdy chcemy zmaterializować wyniki zapytania, co oznacza, że możemy stworzyć trwałe dane na podstawie dynamicznie generowanych wyników z potoku agregacji. $out tworzy nową kolekcję, jeśli nie istnieje, lub zastępuje istniejącą kolekcję, co oznacza, że wszystkie dane w tej kolekcji zostaną usunięte.

**Składnia** `$out`

```js
{
  $out: "<nazwa_nowej_kolekcji>"
}
```

```js
db.produkty.aggregate([
  {
    $match: { dostepnosc: "tak" }  // Filtrowanie dostępnych produktów
  },
  {
    $out: "wszystkie_produkty"  // Zapisanie wyników do nowej kolekcji
  }
])
```

**Uwagi:**
- Zastępowanie kolekcji: $out zastępuje istniejącą kolekcję o tej samej nazwie, co oznacza, że wszystkie jej dane zostaną utracone.
- Ograniczenia: $out nie może być używane w połączeniu z niektórymi operatorami, takimi jak $merge, i nie działa w ramach transakcji.
- Użycie z potokiem agregacji: $out powinno być ostatnim etapem w potoku agregacji.

```js
db.produkty.aggregate([
  {
    $group: {
      _id: "$kategoria",
      liczba_produktow: { $sum: 1 }
    }
  },
  {
    $out: "liczba_produkty"  // Zapisanie wyników zgrupowania do nowej kolekcji
  }
])
```

```js
db.produkty.aggregate([
  {
    $lookup: {
      from: "kategorie",
      localField: "kategoria_id",
      foreignField: "_id",
      as: "kategoria_info"
    }
  },
  {
    $out: "produkty_z_kategoriami"
  }
])
```

## Slajd 172 — Import przykładowych danych z pliku json za pomocą narzędzia mongoimport

Import przykładowych danych z pliku json za pomocą narzędzia mongoimport

```bash
mongoimport --db=customers --collection=clients --file=Customer05.json
```

> [Grafika] Zrzut strony pobierania: ikona narzędzia, etykieta „TOOLS”, tytuł „MongoDB Command Line Database Tools Download”, opis: „The MongoDB Database Tools are a collection of command-line utilities for working with a MongoDB deployment. These tools release independently from the MongoDB Server schedule enabling you to receive more frequent updates and leverage new features as soon as they are available. See the MongoDB Database Tools documentation for more information.”; pola: Version 100.8.0, Platform Windows x86_64.

> [Grafika] Zrzut okna cmd.exe (C:\Windows\System32\cmd.exe):

```
Microsoft Windows [Version 10.0.19045.3448]
(c) Microsoft Corporation. Wszelkie prawa zastrzeżone.

C:\Users\Henryk\Desktop\MongoDB\mongodb-database-tools-windows-x86_64-100.8.0\bin>mongoimport.exe --db=henryk --collection=listingsAndReviews --file=listingsAndReviews.json
2023-10-09T22:44:19.593+0200    connected to: mongodb://localhost/
2023-10-09T22:44:22.596+0200    [###############.........] henryk.listingsAndReviews   62.7MB/95.0MB (66.0%)
2023-10-09T22:44:24.171+0200    [########################] henryk.listingsAndReviews   95.0MB/95.0MB (100.0%)
2023-10-09T22:44:24.173+0200    5555 document(s) imported successfully. 0 document(s) failed to import.

C:\Users\Henryk\Desktop\MongoDB\mongodb-database-tools-windows-x86_64-100.8.0\bin>mongoimport.exe --db=henryk --collection=movies --file=movies.json
2023-10-09T22:57:03.301+0200    connected to: mongodb://localhost/
2023-10-09T22:57:06.301+0200    [####################....] henryk.movies       35.8MB/41.4MB (86.4%)
2023-10-09T22:57:06.842+0200    [########################] henryk.movies       41.4MB/41.4MB (100.0%)
2023-10-09T22:57:06.842+0200    23539 document(s) imported successfully. 0 document(s) failed to import.

C:\Users\Henryk\Desktop\MongoDB\mongodb-database-tools-windows-x86_64-100.8.0\bin>mongoimport.exe --db=henryk --collection=comments --file=comments.json
2023-10-09T23:30:33.843+0200    connected to: mongodb://localhost/
2023-10-09T23:30:36.119+0200    50304 document(s) imported successfully. 0 document(s) failed to import.
```

## Slajd 173 — Map-Reduce - przestarzały

```js
db.orders.mapReduce(
    function() { emit( this.cust_id, this.amount ); },
    function(key, values) { return Array.sum( values ) },
    {
      query: { status: "A" },
      out: "order_totals"
    }
  )
```

> [Grafika] Strzałki z etykietami po lewej wskazują części polecenia: „Collection” → `db.orders`; „map” → `function() { emit( this.cust_id, this.amount ); }`; „reduce” → `function(key, values) { return Array.sum( values ) }`; „query” → `query: { status: "A" }`; „output” → `out: "order_totals"`.

> [Grafika] Diagram przepływu Map-Reduce. Kolekcja „orders” (4 dokumenty): `{ cust_id: "A123", amount: 500, status: "A" }`, `{ cust_id: "A123", amount: 250, status: "A" }`, `{ cust_id: "B212", amount: 200, status: "A" }`, `{ cust_id: "A123", amount: 300, status: "D" }`. Strzałka „query” → zostają 3 dokumenty ze status "A" (A123/500, A123/250, B212/200; czwarty ze status "D" odpada). Strzałka „map” → `{ "A123": [ 500, 250 ] }` oraz `{ "B212": 200 }`. Strzałka „reduce” → kolekcja „order_totals”: `{ _id: "A123", value: 750 }` oraz `{ _id: "B212", value: 200 }`.

Proces **agregacji** zapewnia lepszą wydajność i użyteczność niż operacja **map-reduce** .

## Slajd 174 — Indeksy

Indeksy w MongoDB są strukturami danych, które przyspieszają operacje wyszukiwania i sortowania w kolekcjach. Działają podobnie do indeksów bazach relacyjnych, umożliwiając szybkie odnajdywanie dokumentów na podstawie określonych pól. Indeksy są kluczowe dla optymalizacji wydajności baz danych, szczególnie gdy mamy do czynienia z dużymi zbiorami danych.

Do czego służą indeksy?
- Przyspieszanie zapytań: Indeksy znacząco zmniejszają czas potrzebny na wyszukiwanie dokumentów, umożliwiając MongoDB przeszukiwanie zindeksowanych pól zamiast skanowania całej kolekcji.
- Optymalizacja sortowania: Indeksy ułatwiają sortowanie dokumentów na podstawie zindeksowanych pól, co może znacznie poprawić wydajność operacji sortowania.
- Zwiększenie efektywności operacji agregacji: Indeksy mogą przyspieszyć operacje agregacji, szczególnie te, które korzystają z $match, $sort, czy $group.

## Slajd 175 — Indeksy

Rodzaje indeksów w MongoDB:

- Indeks domyślny (Primary Index):
  - Jest tworzony automatycznie na polu _id w każdej kolekcji.
  - Zapewnia unikalność każdego dokumentu i umożliwia szybkie odnajdywanie dokumentów na podstawie _id.
- Indeks unikalny (Unique Index):
  - Zapewnia, że wszystkie wartości w indeksowanym polu są unikalne.

```js
db.uzytkownicy.createIndex({ email: 1 }, { unique: true });
```

  zapewnia, że każdy adres e-mail w kolekcji uzytkownicy jest unikalny.
- Indeks złożony (Compound Index):
  - Indeksuje więcej niż jedno pole w dokumentach.

```js
db.zamowienia.createIndex({ uzytkownik_id: 1, data: -1 });
```

- Indeks tekstowy (Text Index):
  - Umożliwia pełnotekstowe wyszukiwanie w polach typu string.

```js
db.artykuly.createIndex({ tytul: "text", zawartosc: "text" });
```

  umożliwia wyszukiwanie w polach tytul i zawartosc.

## Slajd 176 — Indeksy

Rodzaje indeksów w MongoDB cd.
- Indeks geospatial (Geospatial Index):
  - Umożliwia wykonywanie zapytań związanych z lokalizacją geograficzną.

```js
db.lokacje.createIndex({ lokalizacja: "2dsphere" });
```

  indeksuje pole lokalizacja dla zapytań przestrzennych.
- Indeks wielowartościowy (Multikey Index):
  - Tworzony na polach, które mogą zawierać tablice wartości.
  - Przykład: db.produkty.createIndex({ tagi: 1 }) - pozwala na indeksowanie dokumentów, w których pole tagi może mieć wiele wartości.
- Indeks częściowy (Partial Index):
  - Indeksuje tylko dokumenty, które spełniają określony warunek.

```js
db.uzytkownicy.createIndex({ status: 1}, {partialFilterExpression:{ status:"aktywny" }})
```

  indeksuje tylko aktywnych użytkowników.
- Indeks TTL (Time-To-Live):
  - Automatycznie usuwa dokumenty po określonym czasie.

```js
db.sesje.createIndex({ utworzone: 1 }, { expireAfterSeconds: 3600 });
```

  usuwa dokumenty po godzinie od ich utworzenia.

> [Grafika] Ramka w prawym dolnym rogu: **Ograniczenia TTL i ważne uwagi:**
> - **Tylko jedno pole** typu data (tradycyjnie brak indeksów złożonych).
> - **Brak wsparcia** dla kolekcji typu *capped*.
> - **Obciążenie bazy danych** przy masowym usuwaniu dokumentów w tle z bardzo dużych kolekcji.
## Slajd 177 — Indeksy

**Wydajność zapytań:** Indeksy wspierają wydajną realizację zapytań w MongoDB. Bez nich baza musi skanować każdy dokument w kolekcji. Odpowiedni indeks ogranicza liczbę skanowanych dokumentów.

**Tworzenie indeksu:** Aby utworzyć indeks, użyj metody createIndex() w powłoce lub jej odpowiednika w sterowniku.

**Koszt zapisu:** Choć indeksy przyspieszają odczyt, obniżają wydajność operacji zapisu. W kolekcjach z przewagą zapisu są kosztowne, ponieważ każde wstawienie i aktualizacja wymaga odświeżenia wszystkich indeksów.

## Slajd 178 — Indeksy pojedynczego pola

> [Grafika] Zrzut z dokumentacji MongoDB: pole „Powłoka MongoDB" z poleceniem; diagram indeksu `{ score: 1 } Index` — niebieski pasek od „min" do „max" z podziałką 18, 30, 45, 75, obok ikona „collection" z dokumentem `score: 30, ...`; strzałka od `db.collection.getIndexes()` do wyniku.

```js
db.collection.createIndex( { name: -1 } )
```

```js
db.collection.getIndexes()
```

```js
[
  { v: 2, key: { _id: 1 }, name: '_id_' },
  { v: 2, key: { name: -1 }, name: 'name_-1' }
]
```

Indeksy pojedynczego pola przechowują informacje z pojedynczego pola w kolekcji.
Domyślnie wszystkie kolekcje mają indeks w polu _id .
Możemy dodać dodatkowe indeksy, aby przyspieszyć ważne zapytania i operacje.

Indeks jednopolowy można utworzyć w dowolnym polu dokumentu, w tym:
- Pola dokumentu najwyższego poziomu
- Pola w osadzonych dokumentach

```js
db.students.createIndex( { "location.state": 1 } )
```

Podczas tworzenia indeksu należy określić:
- Pole, na podstawie którego ma zostać utworzony indeks.
- Kolejność sortowania indeksowanych wartości (rosnąca lub malejąca).
  (sortownie malejące - mniej wydajne sortowanie)

## Slajd 179 — Indeksy złożone

```js
db.students.createIndex( {
   name: 1,
   gpa: -1
} )
```

Indeksy złożone zbierają i sortują dane z dwóch lub więcej pól w każdym dokumencie w kolekcji. Dane są grupowane według pierwszego pola w indeksie, a następnie według każdego kolejnego pola.

> [Grafika] Diagram indeksu `{ userid: 1, score: -1 } Index`: niebieski pasek od „min" do „max" z punktami: "aa1", 45; "ca2", 75; "ca2", 55; "ca2", 30; "nb1", 30; "xyz", 90. W prawym górnym rogu ikona „collection" z dokumentem `{ score: 30, userid: ..., ... }`.

## Slajd 180 — Multikey Indexes

```js
db.<collection>.createIndex( { <arrayField>: <sortOrder> } )
```

Indeksy multikey zbierają i sortują dane z pól zawierających wartości tablicowe. Indeksy multikey poprawiają wydajność zapytań na polach tablicowych.

Nie musisz jawnie określać typu multikey. Kiedy tworzysz indeks w polu zawierającym wartość tablicy, MongoDB automatycznie ustawia ten indeks jako indeks multikey.

> [Grafika] Diagram indeksu `{ "addr.zip": 1 } Index`: niebieski pasek od „min" do „max" z punktami "10036", "78610", "94301". Ikona „collection" z dokumentem:

```js
{
  userid: "xyz",
  addr:
    [
      { zip: "10036", ... },
      { zip: "94301", ... }
    ],
  ...
}
```

## Slajd 181 — Indeks wektorowy

MongoDB Vector Search Quick Start - Atlas - MongoDB Docs (hiperłącze)

Indeks wektorowy w MongoDB (Atlas Search) jest potrzebny, aby umożliwić **wyszukiwanie podobieństwa semantycznego** między dokumentami na podstawie ich reprezentacji wektorowej (embeddingów), a nie tylko dopasowania słów kluczowych.

**Dlaczego jest potrzebny?**
• MongoDB domyślnie nie potrafi szybko porównywać dużych wektorów (np. 2048 wymiarów) w milionach dokumentów.
• Indeks wektorowy wykorzystuje algorytmy **ANN (Approximate Nearest Neighbor)**, np. HNSW (Hierarchical Navigable Small World), aby znaleźć najbliższe wektory do zapytania w czasie ułamka sekundy.
• Bez indeksu musielibyśmy robić pełne skanowanie kolekcji i liczyć podobieństwo dla każdego dokumentu → ekstremalnie wolne.

> [Grafika] Dwa zrzuty kodu (mongosh / edytor) — po lewej tworzenie indeksu, po prawej wynik getSearchIndexes().

```js
use('sample_mflix');

db.embedded_movies.dropSearchIndex("vector_index");

db.embedded_movies.createSearchIndex(
  "vector_index",
  "vectorSearch",
  {
    "fields": [
      {
        "type": "vector",
        "path": "plot_embedding_voyage_3_large",
        "numDimensions": 2048,
        "similarity": "cosine", //cosine, euclidean, dotProduct
        "quantization": "scalar"
      }
    ]
  }
);

db.embedded_movies.getSearchIndexes();
```

```json
[
  {
    "id": "691ba7158937e111fd031b0a",
    "name": "vector_index",
    "type": "vectorSearch",
    "status": "READY",
    "queryable": true,
    "latestVersion": 0,
    "latestDefinition": {
      "fields": [
        {
          "type": "vector",
          "path": "plot_embedding_voyage_3_large",
          "numDimensions": 2048,
          "similarity": "cosine",
          "quantization": "scalar"
        }
      ]
    }
  }
]
```

## Slajd 182 — Indeks wektorowy

**Do czego służy?**
• **Semantic Search**: np. wyszukiwanie filmów o podobnej fabule, nawet jeśli nie używają tych samych słów.
• **Rekomendacje**: znajdź dokumenty podobne do danego (np. „podobne produkty").
• **Chatboty / QA**: wyszukiwanie kontekstu w bazie wiedzy na podstawie embeddingów.

**Jak działa?**
• Tworzymy indeks typu vectorSearch na polu, które zawiera embedding (np. `plot_embedding_voyage_3_large`). Voyage AI – taki model używamy (na podstawie semantycznej reprezentacji tekstu).
• Podajemy:
  • **numDimensions** – rozmiar wektora (np. 2048).
  • **similarity** – metrykę (cosine, euclidean, dotProduct).
• MongoDB buduje strukturę danych zoptymalizowaną do szybkiego wyszukiwania najbliższych sąsiadów.

**Efekt końcowy**
Po utworzeniu indeksu możesz używać operatora `$vectorSearch` w agregacji, aby w milisekundach znaleźć dokumenty najbardziej podobne do wektora zapytania.

> [Grafika] Mały zrzut listy rozwijanej „EMBEDDING MODEL" z wybraną opcją „Voyage AI" (zaznaczona), pozostałe opcje: „OpenAI", „Open-source".

## Slajd 183 — Indeks wektorowy

> [Grafika] Trzy zrzuty kodu: zapytanie agregacyjne (lewo), wynik (prawo), fragment dokumentu z polem embeddingu (dół).

```js
use('sample_mflix');

db.embedded_movies.aggregate([
  {
    "$vectorSearch": {
      "index": "vector_index",
      "path": "plot_embedding_voyage_3_large",
      "queryVector": Array(2048).fill(0.5),
      "numCandidates": 150,
      "limit": 10,
      "quantization": "scalar"
    }
  },
  {
    "$project": {
      "_id": 0,
      "plot": 1,
      "title": 1,
      "score": { $meta: "vectorSearchScore" }
    }
  }
])
```

```json
[
  {
    "plot": "The Nazis set up a secret base on the dark side [obcięte]",
    "title": "Iron Sky",
    "score": 0.5304009914398193
  },
  {
    "plot": "The big thing in 2005 is a violent sport which [obcięte]",
    "title": "Rollerball",
    "score": 0.5284097194671631
  },
  {
    "plot": "Performing the traditional New Year's call on th[obcięte]",
    "title": "Tarif Novogodniy",
    "score": 0.5281314849853516
  },
  {
    "plot": "After death, people have just one week to choose [obcięte]",
    "title": "After Life",
    "score": 0.5277090072631836
  },
```

```json
"plot_embedding_voyage_3_large": {
  "$binary": {
    "base64": "JwCix/W8nzv/PM+PgLzHTRa9sz3LPMrZDDyiq3c7womjPLuNt[obcięte]",
    "subType": "09"
  }
```

plot_embedding_voyage_3_large = **zakodowany wektor liczb (embedding)**, który opisuje znaczenie fabuły filmu w przestrzeni semantycznej.
**Nie jest to obraz ani wideo, tylko dane numeryczne.**

## Slajd 184 — Replikacja

Replikacja w MongoDB to mechanizm, który pozwala na duplikowanie danych między różnymi serwerami, co zapewnia odporność na awarie i umożliwia dostępność danych w sytuacjach kryzysowych.
Główne cechy replikacji w MongoDB obejmują:

1. **Replica Set**: MongoDB używa tzw. *replica set*, który jest grupą instancji MongoDB, gdzie jeden serwer działa jako *primary*, a pozostałe jako *secondary*. *Primary* jest odpowiedzialny za operacje zapisu, natomiast *secondary* wykonują replikację danych z *primary*.
2. **Automatyczne przełączanie (Failover)**: W przypadku awarii serwera *primary*, jeden z serwerów *secondary* automatycznie zostaje wybrany na nowego *primary*, co pozwala na zachowanie dostępności.
3. **Odczyty z secondary**: MongoDB pozwala na konfigurację, która umożliwia odczyty danych także z serwerów *secondary*, co może zwiększyć wydajność odczytów, ale wiąże się z pewnym opóźnieniem (*read lag*).
4. **Wysoka dostępność**: Dzięki replikacji dane są stale dostępne, nawet podczas aktualizacji lub awarii jednego z serwerów.
5. **Minimalizacja utraty danych**: Replikacja pozwala na zapis danych na wielu serwerach jednocześnie, co minimalizuje ryzyko ich utraty.
6. **Ochrona przed awariami**: W przypadku awarii jednego z serwerów, inne serwery w *replica set* nadal przechowują kopie danych i mogą działać jako kopie zapasowe.
7. **Konfiguracja i elastyczność**: MongoDB umożliwia konfigurację wielu opcji związanych z replikacją, takich jak liczba serwerów *secondary*, strategia synchronizacji, oraz polityki odczytu/zapisu.

Replikacja w MongoDB jest kluczowym elementem umożliwiającym budowanie skalowalnych i odpornych na awarie aplikacji.

## Slajd 185 — Replikacja

Zestaw replik w MongoDB (Replica Set) to grupa procesów **mongod**, które przechowują ten sam zestaw danych. Replikacja zapewnia redundancję danych oraz wysoką dostępność usług bazodanowych, umożliwiając ciągłość działania nawet w przypadku awarii jednego z serwerów.

**Redundancja i dostępność danych**

Replikacja tworzy wiele kopii danych przechowywanych na różnych serwerach. Dzięki temu system pozostaje dostępny mimo awarii pojedynczego węzła. W przypadku niedostępności serwera głównego (Primary) jeden z serwerów zapasowych (Secondary) może zostać automatycznie wybrany na nowy serwer główny, minimalizując przerwy w działaniu aplikacji.

## Slajd 186 — Replikacja w MongoDB

Zestaw replik (ang. *replica set*) to grupa instancji mongod, które przechowują ten sam zestaw danych. Zestaw replik składa się z kilku węzłów przechowujących dane oraz opcjonalnie jednego węzła arbitra (*arbiter*). Spośród węzłów przechowujących dane dokładnie jeden pełni rolę **węzła głównego (primary)**, który przyjmuje operacje zapisu. Pozostałe węzły pełnią rolę **węzłów wtórnych (secondary)** i utrzymują kopie danych poprzez replikację zmian z węzła głównego.

> [Grafika] Diagram: u góry „Client Application / Driver"; strzałka „Writes" (niebieska) i „Reads" (czarna) w dół do „Primary"; od Primary dwie strzałki „Replication" do dwóch węzłów „Secondary".

## Slajd 187 — Arbiter zestawu replik

> [Grafika] Dwa diagramy. Górny: „Primary" na górze, dwa „Secondary" po bokach; strzałki „Replication" od Primary do obu Secondary; dwukierunkowe strzałki „Heartbeat" między Primary i Secondary oraz między obydwoma Secondary. Dolny: „Primary", „Secondary" i „Arbiter (vote only)" (pomarańczowy); strzałka „Replication" od Primary do Secondary; dwukierunkowe strzałki „Heartbeat" między wszystkimi trzema.

Tytuł: Arbiter zestawu replik

W pewnych okolicznościach (np. gdy mamy replikę podstawową i dodatkową, ale ograniczenia kosztowe uniemożliwiają dodanie kolejnej) możesz zdecydować się na dodanie arbitra do swojego zestawu replik. Arbiter uczestniczy w wyborach , lecz **nie** posiada kopii zbioru danych i **nie może** zostać wybrany).

## Slajd 188 — Automatyczne przełączanie awaryjne

> [Grafika] Diagram: u góry „Primary" przekreślony czerwonym krzyżem; „Election for New Primary" — w czerwonej przerywanej ramce dwa „Secondary" połączone dwukierunkową strzałką „Heartbeat"; czarna strzałka w dół; „New Primary Elected" — w ramce „Primary" ze strzałką „Replication" do „Secondary" oraz dwukierunkowa strzałka „Heartbeat".

Mediana czasu, zanim klaster wybierze nową jednostkę podstawową, zwykle nie powinna przekraczać 12 sekund, przy założeniu wartości domyślnej replica configuration settings.

## Slajd 189 — Sharding - Fragmentowanie

**Sharding** to metoda dystrybucji danych na wielu komputerach. MongoDB wykorzystuje sharding do obsługi wdrożeń z bardzo dużymi zbiorami danych i operacjami o dużej przepustowości.

Systemy baz danych z dużymi zbiorami danych lub aplikacjami o dużej przepustowości mogą stanowić wyzwanie dla wydajności pojedynczego serwera. Na przykład duża liczba zapytań może wyczerpać pojemność procesora serwera. Rozmiary zestawów roboczych większe niż pamięć RAM systemu obciążają pojemność we/wy dysków.

## Slajd 190 — Sharding - Fragmentowanie

Istnieją dwie metody rozwiązania problemu rozbudowy systemu:

- ***Skalowanie pionowe*** polega na zwiększaniu pojemności pojedynczego serwera, na przykład przy użyciu mocniejszego procesora, dodaniu większej ilości pamięci RAM lub zwiększeniu ilości miejsca na dysku. W rezultacie istnieje praktyczne maksimum skalowania w pionie.
- ***Skalowanie poziome*** polega na podziale zbioru danych systemowych i obciążeniu na wiele serwerów oraz dodaniu dodatkowych serwerów w celu zwiększenia pojemności zgodnie z wymaganiami. Chociaż ogólna prędkość lub pojemność pojedynczej maszyny może nie być wysoka, każda maszyna obsługuje podzbiór całkowitego obciążenia, potencjalnie zapewniając lepszą wydajność niż pojedynczy szybki serwer o dużej pojemności. Zwiększanie wydajności wdrożenia wymaga jedynie dodania dodatkowych serwerów w razie potrzeby, co może stanowić niższy koszt całkowity w porównaniu z wysokiej klasy sprzętem dla pojedynczej maszyny. Kompromisem jest większa złożoność infrastruktury i konserwacji podczas wdrożenia.

## Slajd 191 — Sharding

Sharding w MongoDB to metoda skalowania horyzontalnego, która pozwala na podział danych na mniejsze fragmenty (tzw. *shardy*) przechowywane na różnych serwerach. Dzięki temu baza może obsługiwać większe zbiory danych i wyższe obciążenia operacyjne.
Kluczowe cechy sharding w MongoDB obejmują:

1. **Podział danych na fragmenty (shardy)**: Dane są dzielone na mniejsze fragmenty na podstawie klucza shardującego, co pozwala na równomierne rozłożenie obciążenia i danych na wiele serwerów.
2. **Klucz shardujący**: Jest to atrybut lub zestaw atrybutów, na podstawie którego MongoDB dzieli dane między shardami. Wybór odpowiedniego klucza shardującego jest kluczowy dla wydajności i równomiernego rozłożenia danych.
3. **Routery (mongos)**: MongoDB używa routerów, znanych jako *mongos*, które przyjmują zapytania od aplikacji, a następnie kierują je do odpowiednich shardów. Routery zarządzają routingiem i umożliwiają transparentne dostarczanie danych.
4. **Balansowanie obciążenia**: MongoDB automatycznie monitoruje rozkład danych i równoważy shardy, przenosząc dane, aby uniknąć nadmiernego obciążenia jednego serwera.
5. **Wysoka skalowalność**: Sharding pozwala na horyzontalne skalowanie MongoDB, co umożliwia dodawanie kolejnych serwerów i zwiększanie pojemności w miarę wzrostu danych i zapotrzebowania.
6. **Wsparcie dla operacji równoległych**: Dzięki podziałowi na shardy, MongoDB umożliwia równoległe przetwarzanie zapytań, co poprawia ogólną wydajność systemu.
7. **Ochrona przed dużymi obciążeniami**: Sharding pozwala na izolację operacji na różnych shardach, co pomaga w uniknięciu przeciążenia jednego serwera przez zbyt intensywne zapytania.
8. **Zarządzanie fragmentacją danych**: MongoDB automatycznie monitoruje wielkość fragmentów i przenosi je w razie potrzeby, co pomaga w utrzymaniu równomiernej dystrybucji danych.

Sharding jest idealnym rozwiązaniem w MongoDB dla aplikacji, które przechowują i przetwarzają bardzo duże ilości danych, a także potrzebują wysokiej wydajności operacji odczytu i zapisu.

## Slajd 192 — Sharded Cluster

**Sharded klaster** - klaster podzielony na fragmenty MongoDB składa się z następujących komponentów:
- Shard : każdy fragment zawiera podzbiór danych podzielonych na fragmenty. Każdy fragment można wdrożyć jako zestaw replik.
- mongos: mongos działa jako router zapytań, zapewniając interfejs między aplikacjami klienckimi a klastrem podzielonym na fragmenty.
- serwery konfiguracyjne: serwery konfiguracyjne przechowują metadane i ustawienia konfiguracyjne klastra.

> [Grafika] Diagram: dwa „App Server" (przerywane ramki), w każdym niebieski „Router (mongos)"; nawias „1 or more Routers"; dwukierunkowa czarna strzałka w dół do nawiasu „2 or more Shards" z dwoma zielonymi blokami „Shard (replica set)"; pomarańczowy blok „Config Servers (replica set)" połączony przerywanymi pomarańczowymi strzałkami z routerami i shardami.

## Slajd 193 — Connecting to a Sharded Cluster

> [Grafika] Diagram: po lewej „Applications/ Drivers" z dwiema strzałkami „Reads/Writes" (niebieska i czerwona) do „Router (mongos)" (przerywana pionowa linia oddziela aplikacje od routera); od routera dwukierunkowe strzałki do dwóch zielonych bloków: „Shard A" (zawiera Collection1 – niebieskie dwa dokumenty, oraz Collection2 – czerwony stos dokumentów) i „Shard B" (zawiera drugą część Collection1 – dwa niebieskie dokumenty). Niebieska przerywana ramka obejmuje Collection1 w obu shardach.

Podpis: Sharded and Non-Sharded Collections

## Slajd 194 — Diagram typowej architektury klastra dzielonego na fragmenty używany w środowisku produkcyjnym.

Diagram typowej architektury klastra dzielonego na fragmenty używany w środowisku produkcyjnym.

> [Grafika] Diagram: ramka „Application" nad „Driver"; poniżej dwa pola „Mongos" (po bokach „•••"); od Mongos linie do „Shard 1", „Shard 2", „•••", „Shard N" — każdy shard to „Primary", „Secondary", „Secondary"; po prawej „Config Server" („Primary", „Secondary", „Secondary") połączony linią z Mongos.

## Slajd 195 — Diagram architektury klastra podzielonego na fragmenty używanego wyłącznie do celów programistycznych

Diagram architektury klastra podzielonego na fragmenty używanego wyłącznie do celów programistycznych

> [Grafika] Diagram: ramka „Application" nad „Driver"; poniżej jedno pole „Mongos"; linia do „Shard 1" („Primary", „Secondary", „Secondary") oraz do „Config Server" („Primary", „Secondary", „Secondary").

## Slajd 196 — Time Series Collection

MongoDB - Time Series to specjalny typ kolekcji zaprojektowany do przechowywania i analizy danych szeregów czasowych, czyli danych, które są zapisywane w odniesieniu do czasu (np. dane ze sensorów, logi systemowe, ceny akcji, …)

Główne cechy MongoDB Time Series:
- Kompresja danych: MongoDB optymalizuje przechowywanie danych szeregów czasowych poprzez kompresję, grupując podobne dokumenty w jeden blok danych. Dzięki temu zużycie pamięci może być znacznie mniejsze w porównaniu do tradycyjnych metod.
- Automatyczne zarządzanie czasem i danymi: MongoDB wykorzystuje specjalne indeksy na danych czasowych, dzięki czemu łatwiej można przeprowadzać operacje na dużych zbiorach danych, takich jak agregacje czy przeszukiwanie danych w określonym przedziale czasowym.
- Szybkie zapisy i odczyty: Dzięki optymalizacjom zaprojektowanym dla szeregów czasowych, MongoDB zapewnia wydajność przy dużej liczbie zapisów (np. danych z czujników, które są zbierane w krótkich odstępach czasu).
- Automatyczne porządkowanie danych: MongoDB tworzy "wiaderka" (**buckets**), które grupują dane według określonych okresów czasu. Pozwala to na bardziej efektywne przetwarzanie danych i lepsze wykorzystanie pamięci.
- Tworzenie kolekcji typu Time Series: Podczas tworzenia kolekcji określa się specjalne parametry, takie jak pole z danymi czasowymi (timeField), czy pole metadanych, co pozwala na łatwiejsze filtrowanie i grupowanie danych.
- Indeksy: MongoDB automatycznie tworzy indeks złożony dla metaField i timeField.

## Slajd 197 — Time Series Collection

```js
db.createCollection("sensor_data", {
   timeseries: {
      timeField: "timestamp",      // Pole, które przechowuje czas
      metaField: "metadata",       // Pole na dodatkowe metadane, np. typ sensora
      granularity: "seconds"       // Ustawienie, jak często dane są zbierane
   }
})
```

> [Grafika] W prawym górnym rogu mały zrzut kodu (nieczytelnie drobny, odczytany częściowo):

```js
db.createCollection(
  "weather",
  {
    timeseries: {
      timeField: "timestamp",
      metaField: "metadata",
      granularity: "seconds"
    },
    expireAfterSeconds: 86400
  }
)
```

Agregacje na szeregach czasowych
MongoDB pozwala na użycie agregacji w celu analizowania danych. Dzięki funkcjom takim jak $group, $bucket, czy $sort, można np. z łatwością przeprowadzać analizę trendów lub tworzyć raporty.

Zastosowania MongoDB Time Series
MongoDB Time Series sprawdza się w aplikacjach takich jak:
- Monitorowanie środowiska (np. temperatura, wilgotność),
- Analiza danych finansowych (np. ceny akcji),
- Logi systemowe,
- Monitorowanie zużycia energii (monitorowanie efektywności energetycznej).

MongoDB Time Series to zatem wszechstronne narzędzie do pracy z danymi czasowymi, które umożliwia wydajniejsze zarządzanie dużymi ilościami danych i szybsze analizy.

## Slajd 198 — Time Series Collection

Kolekcje szeregów czasowych są optymalne do analizowania danych w czasie.

Przypadki użycia danych szeregów czasowych:

| Przemysł | Przykłady |
|---|---|
| Internet rzeczy (IoT) | Dane z czujników (na przykład z urządzeń inteligentnego domu lub logistyki flotowej); Uczenie maszynowe i scrapowanie za pomocą sztucznej inteligencji |
| Usługi finansowe | Handel o wysokiej częstotliwości; Analiza ilościowa finansowa; Dane bankowe (na przykład rozliczenia transakcji bankowych na przestrzeni czasu); Dane giełdowe |
| Handel detaliczny i handel elektroniczny | Analiza transakcji, sprzedaży i cen; Zarządzanie zapasami |
| DevOps | Rejestrowanie aplikacji; Monitorowanie infrastruktury i sieci |

## Slajd 199 — Time Series Collection

Dane szeregów czasowych mają kilka właściwości, które odróżniają je od innych formatów danych:
- Dokumenty są dostarczane w odpowiedniej kolejności; to wymaga częstych operacji wstawiania w celu ich dołączenia.
- Operacje aktualizacji są rzadkie; każdy dokument reprezentuje pojedynczy punkt w czasie.
- Operacje usuwania są rzadkie
- Dane są indeksowane według czasu i identyfikatora.
- Ilość danych jest duża; każda pojedyncza seria czasowa wymaga dużej, stale rosnącej liczby dokumentów.

MongoDB używa specjalistycznego formatu kolumnowego, który grupuje dokumenty z każdej serii czasowej. Ma to następujące zalety:
- Zmniejszone rozmiary pamięci masowej i indeksów
- Poprawiona wydajność zapytań
- Zmniejszone I/O dla operacji odczytu
- Zwiększone wykorzystanie pamięci podręcznej
- Zmniejszona złożoność pracy z danymi szeregów czasowych

## Slajd 200 — Create and Query a Time Series Collection

```js
db.createCollection(
   "weather",
   {
      timeseries: {
         timeField: "timestamp",
         metaField: "metadata",
         granularity: "seconds"
      },
      expireAfterSeconds: 86400
   }
)
```

```js
db.weather.insertMany( [
   {
      metadata: { sensorId: 5578, type: "temperature" },
      timestamp: ISODate("2021-05-18T00:00:00.000Z"),
      temp: 12
   },
   {
      metadata: { sensorId: 5578, type: "temperature" },
      timestamp: ISODate("2021-05-18T04:00:00.000Z"),
      temp: 11
   },
```

```js
db.weather.findOne( {
   timestamp: ISODate("2021-05-18T00:00:00.000Z")
} )
```

## Slajd 201 — Create and Query a Time Series Collection

```js
db.weather.aggregate( [
   {
      $project: {
         date: {
            $dateToParts: { date: "$timestamp" }
         },
         temp: 1
      }
   },
   {
      $group: {
         _id: {
            date: {
               year: "$date.year",
               month: "$date.month",
               day: "$date.day"
            }
         },
         avgTmp: { $avg: "$temp" }
      }
   }
] )
```

```js
db.weather.insertMany( [
   {
      metadata: { sensorId: 5578, type: "temperature" },
      timestamp: ISODate("2021-05-18T00:00:00.000Z"),
      temp: 12
   },
```

```json
{
  "_id" : {
    "date" : {
      "year" : 2021,
      "month" : 5,
      "day" : 18
    }
  },
  "avgTmp" : 12.714285714285714
}
{
  "_id" : {
    "date" : {
      "year" : 2021,
      "month" : 5,
      "day" : 19
    }
  },
  "avgTmp" : 13
}
```

> [Grafika] Zrzut kodu w VS Code / dokumentacji: zapytanie agregacyjne po lewej, fragment insertMany nałożony w dolnej części, wyniki po prawej.

## Slajd 202 — Create and Query a Time Series Collection

**Obliczamy średnią cenę miesięczną**
Rozważmy dowJonesTickerData kolekcję zawierającą dokumenty o następującej strukturze:

```js
{
   date: ISODate("2020-01-03T05:00:00.000Z"),
   symbol: 'AAPL',
   volume: 146322800,
   open: 74.287498,
   adjClose: 73.486023,
   high: 75.144997,
   low: 74.125,
   close: 74.357498
}
```
(etykieta: Structure documents)

Query:

```js
db.dowJonesTickerData.aggregate( [ {
   $group: {
      _id: {
         firstDayOfMonth: {
            $dateTrunc: {
               date: "$date",
               unit: "month"
            }
         },
         symbol: "$symbol"
      },
      avgMonthClose: {
         $avg: "$close"
      }
   }
} ] )
```

Results:

```js
{
   _id: {
      firstDayOfMonth: ISODate("2020-06-01T00:00:00.000Z"),
      symbol: 'GOOG'
   },
   avgMonthClose: 1431.0477184545455
},
{
   _id: {
      firstDayOfMonth: ISODate("2021-07-01T00:00:00.000Z"),
      symbol: 'MDB'
   },
   avgMonthClose: 352.7314293333333
},
```

Często używane operacje
Do analizy danych szeregów czasowych często stosuje się następujące operatory i etapy potoku agregacji:
- $dateAdd: Dodaje określoną ilość czasu do obiektu Date.
- $dateDiff:Zwraca różnicę czasu pomiędzy dwiema datami.
- $dateTrunc: Zwraca datę skróconą do określonej jednostki.
- $setWindowFields:Uruchamia obliczenia na dokumentach w danym oknie.

## Slajd 203 — Create and Query a Time Series Collection

**Obliczamy średnią cenę na przestrzeni 30 dni**
Rozważmy dowJonesTickerData kolekcję zawierającą dokumenty o następującej strukturze:

```js
{
   date: ISODate("2020-01-03T05:00:00.000Z"),
   symbol: 'AAPL',
   volume: 146322800,
   open: 74.287498,
   adjClose: 73.486023,
   high: 75.144997,
   low: 74.125,
   close: 74.357498
}
```
(etykieta: Structure documents)

Query:

```js
db.dowJonesTickerData.aggregate( [
   { $setWindowFields: {
      partitionBy: { symbol : "$symbol" } ,
      sortBy: { date: 1 },
      output: {
         averageMonthClosingPrice: {
            $avg : "$close",
            window : { range : [-1, "current"], unit : "month" }
         }
      }
   } }
] )
```

Results:

```js
{
   date: ISODate("2020-01-29T05:00:00.000Z"),
   symbol: 'AAPL',
   volume: 216229200,
   adjClose: 80.014801,
   low: 80.345001,
   high: 81.962502,
   open: 81.112503,
   close: 81.084999,
   averageMonthClosingPrice: 77.63137520000001
}
```

Ten proces agregacji wykonuje następujące operacje:
- Służy $setWindowFields do określenia okna 30-dniowego.
- Oblicza średnią ruchomą ceny zamknięcia w ciągu ostatnich 30 dni dla każdej akcji.

## Slajd 204 — List Time Series Collections in a Database

```js
db.runCommand( {
   listCollections: 1,
   filter: { type: "timeseries" }
} )
```

```js
db.getCollectionInfos({
    type: "timeseries"
})
```

```js
{
  cursor: {
    id: Long("0"),
    ns: 'test.$cmd.listCollections',
    firstBatch: [
      {
        name: 'weather',
        type: 'timeseries',
        options: {
          timeseries: {
            timeField: 'timestamp',
            metaField: 'metadata',
            granularity: 'hours',
            bucketMaxSpanSeconds: 2592000
          }
        },
        info: { readOnly: false }
      }
    ]
  },
  ok: 1
}
```

## Slajd 205 — Build Materialized Views on Top of Time Series Data

```js
db.weather.aggregate([
  {
     $project: {
        date: {
           $dateToParts: { date: "$timestamp" }
        },
        temp: 1
     }
  },
  {
     $group: {
        _id: {
           date: {
              year: "$date.year",
              month: "$date.month",
              day: "$date.day"
           }
        },
        avgTmp: { $avg: "$temp" }
     }
  }, {
     $merge: { into: "dailytemperatureaverages", whenMatched: "replace" }
  }
])
```

> [Grafika] Linia `$merge: { into: "dailytemperatureaverages", whenMatched: "replace" }` jest wyróżniona ciemną ramką.

## Slajd 206 — Włącz automatyczne usuwanie kolekcji

Włącz automatyczne usuwanie kolekcji

```js
db.runCommand({
   collMod: "weather24h",
   expireAfterSeconds: 604801
})
```

```js
db.weather24h.collMod({
   expireAfterSeconds: 604801
})
```

Wyłącz automatyczne usuwanie

```js
db.runCommand({
    collMod: "weather24h",
    expireAfterSeconds: "off"
})
```

```js
db.weather24h.collMod({
    expireAfterSeconds: "off"
})
```

## Slajd 207 — IoT Power Consumption

IoT Power Consumption

Wykonanie agregacji w celu obliczenia energii zużytej przez jednostkę klimatyzacyjną w ciągu godziny dla każdego otrzymanego odczytu

```js
var pipelineRawReadings = [
  // Calculate each unit's energy consumed over the last hour for each reading
  {"$setWindowFields": {
    "partitionBy": "$deviceID",
    "sortBy": {"timestamp": 1},
    "output": {
      "consumedKilowattHours": {
        "$integral": {
          "input": "$powerKilowatts",
          "unit": "hour",
        },
        "window": {
          "range": [-1, "current"],
          "unit": "hour",
        },
      }
    }
  }},
];
```

```js
db.device_readings.aggregate(pipelineRawReadings);
```

> [Grafika] Mały zrzut przykładowych dokumentów (drobny druk, tylko częściowo czytelny): dokumenty z polami `_id: ObjectId(...)`, `buildingID: 'Building-ABC'`, `deviceID: 'UltraAirCon-111'`, `timestamp: ISODate("2021-07-03T11:...")`, `powerKilowatts: 8`, `consumedKilowattHours: [nieczytelne]`.

> [Grafika] Wykres: oś Y „Energy Rate (Kilowatts)", oś X „Time (hours)" z przedziałami „1st Hour", „2nd Hour", „3rd Hour". Czerwona gładka krzywa przez czarne punkty pomiarowe; pod krzywą w 2. godzinie zaznaczone dwa pola: niebieskie i zielone (dwa trapezy). Opis: „Power consumed = Energy Rate x Time = Kilowatt-hours (kWh) = ← area of these 2 trapezoid shapes".

## Slajd 208 — (pusty slajd)

> [Grafika] Pusty slajd (tylko czarna ramka, brak treści).

## Slajd 209 — Bazy klucz–wartość

- **Model danych**
  - Najprostszy model bazy NoSQL
    - analogia do tablicy asocjacyjnej (słownika)
  - Dane przechowywane jako **pary klucz–wartość**
    - **Klucz**: unikalny identyfikator (np. ciąg znaków, liczba)
    - **Wartość**: dowolne dane (np. tekst, obiekt, lista, liczba)
- **Podstawowe operacje**
  - Dodaj / zmień / usuń wartość dla podanego klucza
  - Pobierz wartość dla podanego klucza
- **Zalety**
  - Bardzo prosta architektura
  - Szybki dostęp do danych (niska latencja)
  - Łatwo się skaluje (np. poziomo)
- **Ograniczenia**
  - Nie sprawdza się dobrze dla danych o złożonej strukturze
  - Zazwyczaj brak zaawansowanych zapytań (np. wyszukiwania po wartościach)

## Slajd 210 — Bazy klucz–wartość

**Kiedy używać?**
- Dane sesyjne
- Cache aplikacyjny
- Ustawienia użytkownika
- Koszyki zakupowe
- Rankingi i liczniki (np. polubienia, wyświetlenia)
- Przechowywanie tokenów i danych uwierzytelniających (np. sesje, API keys)

**Kiedy nie używać?**
- Gdy występują złożone relacje między encjami
- Gdy potrzebne są złączenia (JOIN)
- Gdy zapytania dotyczą fragmentów wartości zamiast klucza
- Gdy wymagane jest przeszukiwanie wielu rekordów według różnych kryteriów (np. filtrowanie po wielu polach)

**Przedstawiciele:**

> [Grafika] Siatka logotypów produktów (2 rzędy po 4): redis, Valkey, amazon DynamoDB, AEROSPIKE (górny rząd); riak KV, hazelcast, ORACLE NoSQL Database, Dragonfly (dolny rząd).

## Slajd 211 — Bazy klucz-wartość

> [Grafika] Wykres liniowy „DB-Engines Ranking of Key-value Stores" (skala logarytmiczna, oś Y „Score (logarithmic scale)" od 0.001 do 100, oś X lata 2014–2024; „© October 2025, DB-Engines.com"). Legenda (strona 1/4): Redis, Amazon DynamoDB, Microsoft Azure Cosmos DB, Memcached, etcd, Hazelcast, Aerospike, Oracle NoSQL, Riak KV, Apache Ignite, Ehcache, ArangoDB, RocksDB, GemFire, Google Cloud Bigtable, OrientDB, InterSystems IRIS, LevelDB, LMDB, Infinispan, Valkey, Oracle Coherence, Amazon SimpleDB, Oracle Berkeley DB, Geode, GridGain. Redis jest na szczycie (ok. 100+), tuż pod nim Amazon DynamoDB (ok. 80–90), potem Microsoft Azure Cosmos DB i Memcached (ok. 20–30), reszta w zakresie ok. 3–10.

## Slajd 212 — Redis – baza klucz-wartość

> [Grafika] Infografika „Redis – baza klucz-wartość. Szybka, elastyczna, wszechstronna" z logo redis i hasłami „Szybkość Prostota Wszechstronność"; dziewięć kafelków.

**1. Czym jest Redis?**
Redis (REmote DIctionary Server) to szybka, otwartoźródłowa baza danych klucz-wartość, która przechowuje dane głównie w pamięci operacyjnej (RAM).
Redis to nie tylko prosta baza klucz-wartość – obsługuje wiele struktur danych i zaawansowane mechanizmy, np. publikacja/subskrypcja.

**2. Jak działa Redis?**
> [Grafika] Klient (aplikacja) — strzałki „Zapis (GET/SET)" i „Odpowiedź (wartość)" — Redis (dane w RAM). Po prawej: „RAM – Pamięć RAM (błyskawiczny dostęp)", „Opcjonalnie zapis na dysk (RDB/AOF)", „Replikacja i wysoka dostępność".

**3. Przykłady danych w Redis**
```bash
# Podstawowe operacje
SET uzytkownik:1 "Jan"
GET uzytkownik:1
127.0.0.1:6379> "Jan"
# Struktura typu hash
HSET osoba:1 imie "Anna" nazwisko "Nowak" wiek 28
HGETALL osoba:1
# Lista
LPUSH kolejka "zadanie1" "zadanie2"
LRANGE kolejka 0 -1
# Zbiór
SADD tagi "tech" "backend" "redis"
SMEMBERS tagi
```
(etykieta: Przykłady komend Redis CLI)

**4. Obsługiwane struktury danych**
Redis wspiera różne typy wartości, nie tylko proste klucze i stringi.
- String (np. tekst)
- Hash (np. obiekty)
- List (np. kolejki)
- Set (np. unikalne dane)
- Sorted Set (np. rankingi)
- Bitmap (np. flagi)
- HyperLogLog (np. unikalni goście)
- Stream (np. strumienie zdarzeń)

**5. Najważniejsze cechy Redis**
- Bardzo wysoka wydajność (dane w pamięci RAM)
- Wszechstronne struktury danych
- Trwałość danych (RDB, AOF)
- Replikacja i klastrowanie
- Wysoka dostępność
- Prosty interfejs (CLI, biblioteki)
- Rozszerzalność przez moduły (np. RediSearch, RedisJSON, RedisTimeSeries)

**6. Zastosowania Redis**
- Cache (przyspieszenie aplikacji)
- Sesje użytkowników (np. w aplikacjach web)
- E-commerce (koszyki, stany produktów)
- Czat w czasie rzeczywistym
- Rankingi i liczniki
- Internet rzeczy (IoT, strumienie danych)

**7. Zalety Redis**
- Błyskawiczny dostęp do danych (mikrosekundy)
- Prosta obsługa i bogaty ekosystem
- Obsługa wielu typów struktur danych
- Skalowalność (klastry, replikacja)
- Szerokie zastosowania

**8. Ograniczenia Redis**
- Dane przechowywane głównie w pamięci RAM (większe koszty przy dużych zbiorach)
- Nie jest idealny do trwałego przechowywania dużych, złożonych danych biznesowych
- Ograniczone możliwości zapytań (brak języka query jak SQL)
- Ryzyko utraty danych przy niewłaściwej konfiguracji
- Nie zastępuje typowej bazy relacyjnej

**9. Redis a inne bazy**

| Cecha | Redis (klucz-wartość) | MongoDB (dokumentowa) | Baza relacyjna (np. PostgreSQL) |
|---|---|---|---|
| Model danych | Klucz-wartość | Dokumenty (JSON) | Tabele (wiersze i kolumny) |
| Szybkość | Bardzo wysoka | Wysoka | Średnia |
| Złożoność zapytań | Prosta | Średnia | Zaawansowana (SQL) |
| Przechowywanie danych | Głównie RAM | Dysk | Dysk |
| Typowe zastosowania | Cache, sesje, kolejki | Aplikacje web, CMS | Systemy biznesowe |

**Redis – szybkość, elastyczność i więcej niż tylko klucz-wartość.**
Idealne rozwiązanie do nowoczesnych aplikacji wymagających wysokiej wydajności i pracy w czasie rzeczywistym.

## Slajd 213 — Zarządzanie kluczami

Jak klucze powinny być zdefiniowane?
- **Rzeczywiste** identyfikatory
  - Np. adresy e-mail, PESEL, login
- **Automatycznie generowane** wartości
  - Auto-inkrementacja
    - Problemy z podziałem na klastry serwerów i znaczeniem
  - Złożone klucze
    - Połączenia bytów rzeczywistych z datami, identyfikatorami, logami
    - Często wykorzystywane w praktyce
- **Prefiksy** też są bardzo często wykorzystywane
  - N.p. film_terminator, film_22.10.2020 , itp.

## Slajd 214 — Zapytania

Podstawowe **operacje CRUD**
- Działają najczęściej dla określonych kluczy
- ⇒ znajomość konwencji nazewniczej kluczy jest istotna
  - W zależności od wykorzystywanego systemu NoSQL być może bardzo trudne będzie uzyskanie informacji o wszystkich dostępnych kluczach.

**Dostęp do części wartości w parze nie jest** najczęściej możliwy.
- Niektóre systemy dostarczają mechanizmów umożliwiających przetwarzanie i przeszukiwanie części związanej z wartością.
- Przetwarzanie wartości wykorzystuje jej częściowe indeksowanie.

Przetwarzanie wsadowe lub sekwencyjne
- **MapReduce**

## Slajd 215 — Inne funkcje

**Wygaśnięcie** par klucz-wartość
- Obiekty są **automatycznie usuwane** z bazy danych **po pewnym interwale czasu.**
- Przydatne w przypadku sesji użytkownika czy koszyków zakupów.

**Połączenia** między parami klucz-wartość
- Wartości mogą być wzajemnie połączone przez odsyłacze (ang. *links*)
- Odsyłacze mogą być odwiedzane podczas zapytań

**Kolekcje** wartości
- Przechowywane mogą być nie tylko proste wartości ale również ich kolekcje(np. **uporządkowane listy, nieuporządkowane zbiory**) bądź dane binarne czy hierarchiczne.

*Konkretna funkcjonalność zależy od stosowanej bazy danych!*

## Slajd 216 — Redis to open-source'owa, in-memory baza danych typu NoSQL

> [Grafika] Dwa rysunki w stylu odręcznym. Lewy (ramka): logo Redis, podpisy „Non-Relational - NoSQL", „Key-Value", „JSON". Prawy (większa ramka): napisy „REmote DIctionary Service", „REDIS", „2009", kontur Włoch (Sycylia i Sardynia), logo Redis, piła, zdjęcie mężczyzny (twórca), puchar, bolid Formuły 1 z modułem pamięci RAM i dyskiem twardym, monitor z serwerem, komputer z chmurą/serwerem; podpisy: „Key - Value database", „Company:Employee:12345", „World:Map:Europe", „No locks", „Different data types", „Fast access time", „Open Source"; logo „redis stack".

Redis to open-source'owa, in-memory baza danych typu NoSQL, która działa jako magazyn struktur danych.

**Kluczowe cechy:**
• Przechowywanie danych w pamięci (in-memory).
• Wysoka wydajność (szybkość odczytu i zapisu).
• Obsługuje różne struktury danych (listy, zbiory, hashe, itp.).
• Zastosowanie w systemach wymagających szybkiego dostępu.

## Slajd 217 — Redis: architektura

> [Grafika] Diagram z logo redis (źródło: https://www.javatpoint.com/redis-tutorial): „Clients" (komputer i telefon) połączeni dwukierunkowymi strzałkami z „App" (trzy pomarańczowe bloki); App ↔ „Redis Master" (CACHE) strzałki „App Reads" i „Cache Updates"; Redis Master → „Redis Read Replica" (CACHE) (strzałka replikacji; łuk „App Reads" z repliki do App); App ↔ „MySQL DB Instance" strzałki „Database Reads" i „Database Writes".

• **Clients -** użytkownicy (np. przeglądarka, aplikacja mobilna) wysyłają żądania do aplikacji.
• **App - a**plikacja obsługuje logikę biznesową i wykonuje:
  • **App Reads** – odczyty z Redis (cache).
  • **Cache Updates** – zapisuje dane do Redis.
  • **Database Reads/Writes** – komunikacja z bazą MySQL.
• **Redis Master**
  •Główny serwer Redis, przechowuje dane w pamięci.
  •Obsługuje odczyty i zapisy z aplikacji.
•**Redis Read Replica**
  • Kopia Redis tylko do odczytu.
  • Zmniejsza obciążenie głównego serwera Redis przy dużej liczbie zapytań.
• **MySQL DB Instance (dół, po prawej)**
  • Tradycyjna baza danych (persistent storage).
  • Redis działa jako warstwa cache przed MySQL, aby przyspieszyć dostęp do danych.

## Slajd 218 — Redis

> [Grafika] Rysunek odręczny: mężczyzna przy biurku z laptopem po lewej, chłopak z laptopem po prawej; wokół słowa: „installation", „command line", „configuration", „security", „extensions", „cloud", „redis-py module", „data types", „optimization", „transactions", „full text search", „publication & subscription".

**Funkcjonalności i programowanie**
- **redis-py module** – biblioteka Python do obsługi Redis.
- **data types** – typy danych w Redis (string, list, set, sorted set, hash, stream).
- **optimization** – techniki optymalizacji (np. pipeline, clustering, sharding).
- **transactions** – obsługa transakcji (MULTI, EXEC, WATCH ).
- **full text search** – wyszukiwanie pełnotekstowe z modułem RedisSearch.
- **publication & subscription** – mechanizm Pub/Sub do komunikacji w czasie rzeczywistym.

**Aspekty administracyjne i konfiguracja**
- **installation** – proces instalacji Redis na różnych platformach.
- **command line** – korzystanie z CLI (redis-cli) do zarządzania i wykonywania poleceń.
- **configuration** – ustawienia serwera Redis (np. redis.conf), parametry wydajności, bezpieczeństwa.
- **security** – mechanizmy zabezpieczeń (uwierzytelnianie, ACL, szyfrowanie).
- **extensions** – dodatkowe moduły i rozszerzenia (np. RedisGraph, RedisJSON).
- **cloud** – wdrożenia Redis w chmurze (Redis Enterprise Cloud, AWS ElastiCache).

## Slajd 219 — Zastosowanie Redis

> [Grafika] Rysunek odręczny: logo Redis na środku u góry, moduł RAM po lewej, dysk twardy po prawej, logo Pythona pod Redisem; podpisy: „cache", „machine learning", „streams", „target database", „publications & subscriptions", „statistics".

1. **Cache** – szybkie buforowanie danych w pamięci, przyspiesza odczyt często używanych informacji.
2. **Machine Learning** – przechowywanie modeli i danych do szybkiego dostępu w aplikacjach ML.
3. **Streams** – obsługa strumieni danych (Redis Streams) do analizy i przetwarzania w czasie rzeczywistym.
4. **Target Database** – może działać jako główna baza danych dla aplikacji wymagających niskich opóźnień.
5. **Pub/Sub** – mechanizm publikacji/subskrypcji do komunikacji w czasie rzeczywistym.
6. **Statistics** – przechowywanie i obliczanie statystyk, np. w systemach monitorowania i analityce.

## Slajd 220 — Funkcje Redis

1. **Szybkość** – dane w pamięci RAM, bardzo szybkie operacje (SET/GET) (Ładuje do 110 000 SET/sekundę, a 81 000 GET/sekundę)
2. **Trwałość** – zapis zmian na dysku asynchronicznie według ustalonych zasad.
3. **Struktury danych** – obsługa różnych typów (string, listy, zbiory, hashe, sorted sets).
4. **Operacje atomowe** – wszystkie operacje są niepodzielne i bezpieczne.
5. **Obsługa wielu języków** – dostępne klienty dla większości popularnych języków programowania.
6. **Replikacja Master/Slave** – prosta i szybka replikacja danych.
7. **Fragmentowanie (Sharding)** – łatwe rozdzielanie danych na wiele instancji.
8. **Przenośność** – działa na większości systemów POSIX (Linux, BSD, macOS, Solaris).
## Slajd 221 — Architektura Redis’a

W architekturze Redis istnieją dwa główne procesy:
- Klient Redis
- Serwer Redis

Klient i serwer mogą znajdować się na tym samym komputerze lub na dwóch różnych komputerach. Serwer Redis służy do przechowywania danych w pamięci. Kontroluje wszystkie rodzaje zarządzania i stanowi główną część architektury.

> [Grafika] Diagram: po lewej prostokąt „Redis Console Client”, po prawej duży prostokąt z napisem „Redis Server. Responsible for storing data and serving to the client.” zawierający walec „Data Store”. Między nimi dwukierunkowa strzałka z podpisem „Send And Receive Data”.

https://www.javatpoint.com/redis-tutorial

## Slajd 222 — REDIS – Docker

```bash
--docker pull redis/redis-stack
docker run -d --name redis-stack
        -p 6379:6379 -p 8001:8001 redis/redis-stack:latest
```

Polecenie to uruchamia kontener REDIS w tle (detached mode) o nazwie „redis-stack", który jest dostępny na hoście na porcie 6379 oraz 8001 i używa obrazu "redis/redis-stack:latest" jako podstawy.

> [Grafika] Docker Desktop: wiersz kontenera „redis-stack” (id d5369bbcad2b), obraz „redis/redis-stack:late…”, status „Running”, 0.17%, porty „6379:6379”, „8001:8001”, „Show less”.

> [Grafika] Mały zrzut ekranu interfejsu Redis Stack Database (ciemny motyw, lista kluczy po lewej, szczegóły po prawej) oraz fragment karty przeglądarki z tytułem „My Redis Stack Database - Brow…”, tekstem „My Redis Stack Database - Browser” i adresem „localhost:8001”.

```bash
docker exec -it redis-stack redis-cli
```

Polecenie to uruchamia interaktywną konsolę (-it) REDIS (redis-cli) wewnątrz kontenera o nazwie „redis-stack", co pozwala na bezpośrednią interakcję z bazą danych REDIS działającą w tym kontenerze.

```
C:\Users\Henryk>docker exec -it redis-stack redis-cli
127.0.0.1:6379>
```

> [Grafika] Okno terminala (cmd) z uruchomionym redis-cli.

## Slajd 223 — REDIS (VS Code) – Redis Database manager for …..

> [Grafika] Karta rozszerzenia VS Code „Redis v6.7.7”, autor Weijan Chen (database-client.com), 119,852 pobrań, ocena 4 gwiazdki (20). Opis: „Database manager for MySQL/MariaDB, PostgreSQL, SQLite, Redis and ElasticSearch.” Przyciski „Uninstall”, ikona ustawień. Komunikat: „This extension has been disabled because the current workspace is not trusted.”

> [Grafika] Panel „NOSQL” w VS Code: połączenie „127.0.0.1@6379 6.2.13 1.21M”, baza „0 (5)”, folder „bikes”, klucze „bikes:0 ReJSON-RL”, „bikes:1 ReJSON-RL”, „bikes:2 ReJSON-RL”, „bikes:3 ReJSON-RL”, „bikes:4 ReJSON-RL”, „bikes:5 ReJSON-RL”, „bikes:6 ReJSON-RL”. Podpowiedź „NoSQL” przy ikonie.

> [Grafika] Formularz „Connect to server”: pola Name („Connection Name”), Connection Scope („Global”, „Workspace” – „Premium Only”), Group, Connect Timeout (5000), Read Only, Save Password („Forever”); uwaga „Note: This extension needs to be pay to unlock all features(Limit 3 connections).”; Server Type: MySQL, MariaDB, PostgreSQL, SQLite, SQL Server, Oracle, ClickHouse, Redshift, SSH, Docker, Redis, ElasticSearch, MongoDB, S3, FTP, Kafka, Zookeeper, More; pola Host (127.0.0.1), Port (6379), Username, Password, Database (0), Cluster, SSH Tunnel, Socks Proxy, SSL; przyciski „Save”, „Connect”, „Close”.

## Slajd 224 — REDIS for VS Code – redis.io

> [Grafika] Karta rozszerzenia VS Code „Redis for VS Code”, wydawca Redis (redis.io), 144,524 pobrań, ocena 4 gwiazdki (10). Opis: „Visually interact with data and build queries in Redis”. Przyciski „Disable”, „Uninstall”, „Auto Update”.

> [Grafika] Panel „REDIS FOR VS CODE”: „Get free trial Redis Cloud database” – „Create”; połączenie „127.0.0.1:6379”, baza „0 (176 / 176)”; foldery „sample_bicycle”, „sample_jobQueue”, „sample_leaderboard”, „sample_restaurant”, „sample_session”.

> [Grafika] Ciemny zrzut z VS Code: „REDIS FOR VS CODE”, „Redis Cloud (189 / 189)”, foldery „bikes”, „sample_bicycle” z kluczami 1001, 1002, 1003, 1004 (JSON); zakładka „json:sample_bicycle:1002”, „JSON sample_bicycle:1002”, „Key Size: 922 B Length: 9 TTL: No limit”, fragment JSON: `{ "model": "Explorer", "brand": "Trailblazer"`.

## Slajd 225 — Redis Stack Database – localhost:8001

> [Grafika] Zrzut Redis Stack Browser (adres localhost:8001/redis-stack/browser): „My Redis Stack Database db0”, 0.18 %, 0, 1 MB. Filtr „All Key Types” rozwinięty: All Key Types, Hash, List, Set, Sorted Set, String, JSON, Stream, Graph, TS; pole „Filter by Key Name or Pattern”. „Total: 3”, trzy klucze typu STRING (No limit; 55 B, 56 B, 48 B). Po prawej szczegóły: STRING „imie”, 56 B, Length: 6, TTL: No limit, wartość „Henryk”.

> [Grafika] Drugi zrzut: „Total: 100”, klucze JSON: bikes:12 (822 B), bikes:76 (856 B), bikes:68 (888 B), bikes:4 (974 B), bikes:89 (921 B), wszystkie „No limit”. Po prawej JSON „bikes:1”, 915 B, Length: 6, TTL: No limit:

```json
{
  "model" : "Hyperion1"
  "brand" : "Velorim"
  "price" : 844
  "type" : "Enduro bikes"
```

## Slajd 226 — Redis Keys with Commands

https://www.javatpoint.com/redis-keys

| | Polecenie | Opis |
|---|---|---|
| 1 | DEL key | To polecenie służy do usunięcia klucza, jeśli istnieje. |
| 2 | DUMP key | To polecenie służy do zwracania serializowanej wersji wartości przechowywanej pod określonym kluczem. |
| 3 | EXISTS key | To polecenie służy do sprawdzania, czy klucz istnieje, czy nie. |
| 4 | EXPIRE key | Polecenie to służy do ustawienia wygaśnięcia klucza po upływie określonego czasu w sekundach. |
| 5 | EXPIREAT key | Polecenie to służy do ustawienia wygaśnięcia klucza po określonym czasie. Tutaj czas jest w formacie znacznika czasu UNIX. |
| 6 | PEXPIRE key | Polecenie to służy do ustawienia wygaśnięcia klucza w milisekundach. |
| 7 | PEXPIREAT key | To polecenie służy do ustawienia wygaśnięcia klucza w znaczniku czasu UNIX określonym w milisekundach. |
| 8 | KEYS pattern | To polecenie służy do znalezienia wszystkich kluczy pasujących do określonego wzorca. |
| 9 | MOVE key | Służy do przeniesienia klucza do innej bazy danych. |
| 10 | PERSIST key | Służy do usuwania daty ważności z klucza. |
| 11 | PTTL key | Służy do pobierania pozostałego czasu ważności kluczy w milisekundach. |
| 12 | TTL key | Służy do pobierania czasu pozostałego do wygaśnięcia kluczy. |
| 13 | randomkey | Służy do uzyskania losowego klucza z Redis. |
| 14 | RENAME key newkey | Służy do zmiany nazwy klucza. |
| 15 | RENAMENX key newkey | Służy do zmiany nazwy klucza, jeśli nowy klucz nie istnieje. |
| 16 | TYPE key | Służy do pobrania typu danych wartości przechowywanej w kluczu. |

## Slajd 227 — Redis data types

> [Grafika] Fragment strony redis.io: karta „Redis data types | Redis”, adres https://redis.io/docs/data-types/, menu „Data types”: Strings, JSON, Lists, Sets, Hashes, Sorted sets, Streams, Geospatial, Bitmaps, Bitfields, Probabilistic, Time series.

Dane w Redis są zapisywanie w strukturze klucz – wartość. Klucz jest zawsze wartością unikalną. Wartość może być różnego typu.

- **Klucz–wartość:** Klucz unikalny, wartość dowolnego typu.
- **Rozmiar klucza:** Maksymalnie 512 MB (choć praktycznie stosuje się dużo mniejsze).
- **Dobre praktyki:** Format np. typ_obiektu:id (np.auto:0001).
- **Typy danych w Redis:**
  - **string** – tekst lub liczby.
  - **list** – lista elementów.
  - **set** – zbiór unikalnych wartości.
  - **hash** – para klucz–wartość (jak słownik).
  - **sorted set** – zbiór z rankingiem (np. top 10).

| Element | Maksymalny rozmiar / wartość |
|---|---|
| Klucz | Do 512 MB, ale zalecane są małe klucze (kilka bajtów–KB). |
| Wartość (string) | Do 512 MB na pojedynczy string. |
| Lista (List) | Liczba elementów: do 2^32 - 1 (ok. 4 miliardy). |
| Zbiór (Set) | Liczba elementów: do 2^32 - 1. |
| Hash | Liczba pól: do 2^32 - 1, każdy element do 512 MB. |
| Sorted Set | Liczba elementów: do 2^32 - 1. |

## Slajd 228 — Redis Strings

**Charakterystyka**
- przechowują sekwencje bajtów,
- mogą zawierać tekst, zserializowane obiekty oraz tablice binarne,
- są najprostszym typem wartości powiązanym z kluczem w Redis.

**Zastosowania**
- buforowanie danych,
- implementacja liczników,
- wykonywanie operacji bitowych,
- przechowywanie fragmentów HTML lub całych stron.

**Działanie**
- klucze w Redis są łańcuchami znaków,
- użycie typu **String** oznacza mapowanie jednego łańcucha znaków na inny,
- jest to uniwersalny typ danych wykorzystywany w wielu scenariuszach

## Slajd 229 — Redis strings (redis.io – lista poleceń)

Redis strings are the most basic Redis data type, representing a sequence of bytes.

> [Grafika] Siatka kafelków poleceń ze strony redis.io (tekst angielski):

- APPEND – Appends a string to the value of a key. Creates the key if it doesn't exist.
- DECR – Decrements the integer value of a key by one. Uses 0 as initial value if the key doesn't exist.
- DECRBY – Decrements a number from the integer value of a key. Uses 0 as initial value if the key doesn't exist.
- GET – Returns the string value of a key.
- GETDEL – Returns the string value of a key after deleting the key.
- GETEX – Returns the string value of a key after setting its expiration time.
- GETRANGE – Returns a substring of the string stored at a key.
- GETSET – Returns the previous string value of a key after setting it to a new value.
- INCR – Increments the integer value of a key by one. Uses 0 as initial value if the key doesn't exist.
- INCRBY – Increments the integer value of a key by a number. Uses 0 as initial value if the key doesn't exist.
- INCRBYFLOAT – Increment the floating point value of a key by a number. Uses 0 as initial value if the key doesn't exist.
- LCS – Finds the longest common substring.
- MGET – Atomically returns the string values of one or more keys.
- MSET – Atomically creates or modifies the string values of one or more keys.
- MSETNX – Atomically modifies the string values of one or more keys only when all keys don't exist.
- PSETEX – Sets both string value and expiration time in milliseconds of a key. The key is created if it doesn't exist.
- SET – Sets the string value of a key, ignoring its type. The key is created if it doesn't exist.
- SETEX – Sets the string value and expiration time of a key. Creates the key if it doesn't exist.
- SETNX – Set the string value of a key only when the key doesn't exist.
- SETRANGE – Overwrites a part of a string value with another by an offset. Creates the key if it doesn't exist.
- STRLEN – Returns the length of a string value.
- SUBSTR – Returns a substring from a string value.

Logo Redis i adres: https://redis.io/commands/?group=string

## Slajd 230 — Redis Strings Commands

https://www.javatpoint.com/redis-strings

| Index | Command | Description |
|---|---|---|
| 1 | SET key value | To polecenie służy do ustawienia wartości dla określonego klucza. |
| 2 | GET key | To polecenie służy do pobrania wartości klucza. |
| 3 | GETRANGE key start end | To polecenie służy do pobrania podciągu ciągu przechowywanego pod kluczem. |
| 4 | GETSET key value | To polecenie służy do ustawienia wartości ciągu klucza i zwrócenia jego starej wartości. |
| 5 | GETBIT key offset | To polecenie służy do zwrócenia wartości bitu w przesunięciu wartości ciągu znaków przechowywanej pod kluczem. |
| 6 | MGET key1 [key2..] | Polecenie to służy do pobrania wartości wszystkich podanych kluczy |
| 7 | SETBIT key offset value | To polecenie służy do ustawiania lub kasowania bitu przesunięcia w wartości ciągu znaków przechowywanego pod kluczem |
| 8 | SETEX key seconds value | Polecenie to służy do ustawienia wartości po wygaśnięciu klucza |
| 9 | SETNX key value | To polecenie służy do ustawienia wartości klucza, tylko jeśli klucz nie istnieje |
| 10 | SETRANGE key offset value | To polecenie służy do nadpisania części łańcucha przy kluczu, zaczynając od określonego przesunięcia |
| 11 | STRLEN key | To polecenie służy do pobierania długości wartości przechowywanej w kluczu |
| 12 | MSET key value [key value ...] | To polecenie służy do ustawiania wielu kluczy na wiele wartości |
| 13 | MSETNX key value [key value ...] | To polecenie służy do ustawiania wielu kluczy na wiele wartości, tylko jeśli żaden z kluczy nie istnieje |
| 14 | PSETEX key milliseconds value | To polecenie służy do ustawiania wartości i ważności klucza w milisekundach |
| 15 | INCR key | To polecenie służy do zwiększania wartości całkowitej klucza o jeden |
| 16 | INCRBY key increment | To polecenie służy do zwiększania wartości całkowitej klucza o podaną wartość |
| 17 | INCRBYFLOAT key increment | To polecenie służy do zwiększania wartości zmiennoprzecinkowej klucza o podaną wartość |
| 18 | DECR key | To polecenie służy do zmniejszania wartości całkowitej klucza o jeden |
| 19 | DECRBY key decrement | Polecenie to służy do zmniejszania wartości całkowitej klucza o podaną liczbę |
| 20 | APPEND key value | To polecenie służy do dodawania wartości do klucza |

## Slajd 231 — SET

> [Grafika] Kafelek „SET – Sets the string value of a key, ignoring its type. The key is created if it doesn't exist.”

```
SET key value [NX | XX] [GET] [EX seconds | PX milliseconds |
  EXAT unix-time-seconds | PXAT unix-time-milliseconds | KEEPTTL]
```

Ustaw klucz, aby przechowywał wartość typu string.
Jeśli klucz już ma wartość, zostanie ona nadpisana, niezależnie od typu.
Poprzedni czas życia (TTL) powiązany z kluczem jest usuwany po pomyślnym wykonaniu operacji **SET**.

```
redis> SET mykey "Hello"
"OK"
redis> GET mykey
"Hello"
redis> SET anotherkey "will expire in a minute" EX 60
"OK"
redis>
```

## Slajd 232 — GET

> [Grafika] Kafelek „GET – Returns the string value of a key.”

```
GET key
```

Pobierz wartość klucza. Jeśli klucz nie istnieje, zwracana jest specjalna wartość nil.
Zwracany jest błąd, jeśli wartość zapisana pod kluczem nie jest typu string, ponieważ polecenie **GET** obsługuje tylko wartości typu string.

```
redis> GET nonexisting
(nil)
redis> SET mykey "Hello"
"OK"
redis> GET mykey
"Hello"
redis>
```

## Slajd 233 — GETDEL

> [Grafika] Kafelek „GETDEL – Returns the string value of a key after deleting the key.”

```
GETDEL key
```

Pobierz wartość klucza i usuń ten klucz. Polecenie jest podobne do **GET**, z tą różnicą, że po pomyślnym pobraniu usuwa klucz (tylko jeśli wartość klucza jest typu string).

```
redis> SET mykey "Hello"
"OK"
redis> GETDEL mykey
"Hello"
redis> GET mykey
(nil)
redis>
```

## Slajd 234 — MGET

> [Grafika] Kafelek „MGET – Atomically returns the string values of one or more keys.”

```
MGET key [key ...]
```

Zwraca wartości wszystkich podanych kluczy. Dla każdego klucza, który nie przechowuje wartości typu string lub nie istnieje, zwracana jest specjalna wartość nil (null). Dzięki temu operacja nigdy nie kończy się błędem.

```
redis> SET key1 "Hello"
"OK"
redis> SET key2 "World"
"OK"
redis> MGET key1 key2 nonexisting
1) "Hello"
2) "World"
3) (nil)
redis>
```

## Slajd 235 — SETEX (deprecated)

> [Grafika] Kafelek „SETEX – Sets the string value and expiration time of a key. Creates the key if it doesn't exist.”

SETEX (deprecated)

As of Redis version 2.6.12, this command is regarded as deprecated.

It can be replaced by SET with the EX argument when migrating or writing new code.

```
SETEX key seconds value
```

Set key to hold the string value and set key to timeout after a given number of seconds. This command is equivalent to:

```
SET key value EX seconds
```

```
redis> SETEX mykey 10 "Hello"
"OK"
redis> TTL mykey
(integer) 10
redis> GET mykey
"Hello"
redis>
```

## Slajd 236 — Redis Lists

Listy to połączone listy wartości typu string. Listy są często używane do:
- Implementacji stosów i kolejek.
- Zarządzania kolejkami dla systemów zadań w tle.

Polecenia podstawowe :
- **LPUSH** dodaje nowy element na początek listy; **RPUSH** dodaje na koniec.
- **LPOP** usuwa i zwraca element z początku listy; **RPOP** robi to samo, ale od końca listy.
- **LLEN** zwraca długość listy.
- **LMOVE** atomowo przenosi elementy z jednej listy na drugą.
- **LTRIM** przycina listę do określonego zakresu elementów.

Polecenia blokujące - listy obsługują kilka komend blokujących. Na przykład:
- **BLPOP** usuwa i zwraca element z początku listy. Jeśli lista jest pusta, polecenie blokuje się, dopóki element nie stanie się dostępny lub nie zostanie osiągnięty określony limit czasu.
- **BLMOVE** atomowo przenosi elementy ze źródłowej listy do docelowej. Jeśli lista źródłowa jest pusta, polecenie blokuje się, dopóki element nie stanie się dostępny.

## Slajd 237 — Redis Lists

Dodawanie do listy (LPUSH i RPUSH):

```
LPUSH mylist "first"
RPUSH mylist "last"
```

Pobieranie elementów z listy:

```
LRANGE mylist 0 -1
# Odpowiedź: ["first", "last"]
```

## Slajd 238 — Redis lists (redis.io – lista poleceń)

> [Grafika] Strona redis.io z polem „Search commands…” i filtrem „List”; siatka kafelków (tekst angielski):

- BLMOVE – Pops an element from a list, pushes it to another list and returns it. Blocks until an element is available otherwise. Deletes the list if the last element was moved.
- BLMPOP – Pops the first element from one of multiple lists. Blocks until an element is available otherwise. Deletes the list if the last element was popped.
- BLPOP – Removes and returns the first element in a list. Blocks until an element is available otherwise. Deletes the list if the last element was popped.
- BRPOP – Removes and returns the last element in a list. Blocks until an element is available otherwise. Deletes the list if the last element was popped.
- BRPOPLPUSH – Pops an element from a list, pushes it to another list and returns it. Block until an element is available otherwise. Deletes the list if the last element was popped.
- LINDEX – Returns an element from a list by its index.
- LINSERT – Inserts an element before or after another element in a list.
- LLEN – Returns the length of a list.
- LMOVE – Returns an element after popping it from one list and pushing it to another. Deletes the list if the last element was moved.
- LMPOP – Returns multiple elements from a list after removing them. Deletes the list if the last element was popped.
- LPOP – Returns the first elements in a list after removing it. Deletes the list if the last element was popped.
- LPOS – Returns the index of matching elements in a list.
- LPUSH – Prepends one or more elements to a list. Creates the key if it doesn't exist.
- LPUSHX – Prepends one or more elements to a list only when the list exists.
- LRANGE – Returns a range of elements from a list.
- LREM – Removes elements from a list. Deletes the list if the last element was removed.
- LSET – Sets the value of an element in a list by its index.
- LTRIM – Removes elements from both ends a list. Deletes the list if all elements were trimmed.
- RPOP – Returns and removes the last elements of a list. Deletes the list if the last element was popped.
- RPOPLPUSH – Returns the last element of a list after removing and pushing it to another list. Deletes the list if the last element was popped.
- RPUSH – Appends one or more elements to a list. Creates the key if it doesn't exist.
- RPUSHX – Appends an element to a list only when the list exists.

Logo Redis i adres: https://redis.io/commands/?group=list

## Slajd 239 — Redis Lists (tabela poleceń)

https://www.javatpoint.com/redis-lists

| Index | Command | Description |
|---|---|---|
| 1 | BLPOP key1 [key2 ] timeout | Służy do usuwania i pobierania pierwszego elementu z listy lub blokowania, dopóki jeden nie będzie dostępny. |
| 2 | BRPOP key1 [key2 ] timeout | Służy do usuwania i pobierania ostatniego elementu na liście lub blokowania, dopóki jeden nie będzie dostępny. |
| 3 | BRPOPLPUSH source destination timeout | Służy do pobrania wartości z listy, wypychania jej na inną listę i zwracania; lub blokuje, dopóki jeden nie będzie dostępny. |
| 4 | LINDEX key index | Służy do pobrania elementu z listy według jego indeksu. |
| 5 | LINSERT key before\|after pivot value | Służy do wstawiania elementu przed lub po innym elemencie na liście. |
| 6 | LLEN key | Służy do uzyskania długości listy. |
| 7 | LPOP key | Służy do usuwania i pobierania pierwszego elementu z listy. |
| 8 | LPUSH key value1 [value2] | Służy do dodawania jednej lub wielu wartości do listy. |
| 9 | LPUSHX key value | Służy do dodawania wartości do listy tylko wtedy, gdy lista istnieje. |
| 10 | LRANGE key start stop | Służy do pobierania zakresu elementów z listy. |
| 11 | LREM key count value | Służy do usuwania elementów z listy. |
| 12 | LSET key index value | Służy do ustawiania wartości elementu na liście według jego indeksu. |
| 13 | LTRIM key start stop | Służy do przycięcia listy do określonego zakresu. |
| 14 | RPOP key | Służy do usuwania i pobierania ostatniego elementu na liście. |
| 15 | RPOPLPUSH source destination | Służy do usunięcia ostatniego elementu z listy, dołączenia go do innej listy i zwrócenia. |
| 16 | RPUSH key value1 [value2] | Służy do dołączania jednej lub wielu wartości do listy. |
| 17 | RPUSHX key value | Służy do dołączania wartości do listy, tylko jeśli lista istnieje. |

## Slajd 240 — Redis Sets

Zbiór Redis to nieuporządkowana kolekcja unikalnych wartości typu string (members). Możesz używać zbiorów Redis do efektywnego:
- Śledzenia unikalnych elementów (np. śledzenia wszystkich unikalnych adresów IP uzyskujących dostęp do określonego wpisu na blogu).
- Reprezentowania relacji (np. zbiór wszystkich użytkowników z określoną rolą).
- Wykonywania typowych operacji na zbiorach, takich jak iloczyny, sumy i różnice.

Podstawowe polecenia:
- **SADD** dodaje nowego członka do zbioru.
- **SREM** usuwa określonego członka ze zbioru.
- **SISMEMBER** sprawdza, czy dany string należy do zbioru.
- **SINTER** zwraca zbiór członków wspólnych dla dwóch lub więcej zbiorów (czyli ich część wspólną).
- **SCARD** zwraca rozmiar (czyli liczebność) zbioru.

## Slajd 241 — Redis Sets

Dodawanie elementów do zbioru:

```
SADD myset "apple" "banana" "cherry"
```

Sprawdzenie zawartości zbioru:

```
SMEMBERS myset
# Odpowiedź: ["apple", "banana", "cherry"]
```

## Slajd 242 — Redis sets (redis.io – lista poleceń)

> [Grafika] Strona redis.io z polem „Search commands…” i filtrem „Set”; siatka kafelków (tekst angielski):

- SADD – Adds one or more members to a set. Creates the key if it doesn't exist.
- SCARD – Returns the number of members in a set.
- SDIFF – Returns the difference of multiple sets.
- SDIFFSTORE – Stores the difference of multiple sets in a key.
- SINTER – Returns the intersect of multiple sets.
- SINTERCARD – Returns the number of members of the intersect of multiple sets.
- SINTERSTORE – Stores the intersect of multiple sets in a key.
- SISMEMBER – Determines whether a member belongs to a set.
- SMEMBERS – Returns all members of a set.
- SMISMEMBER – Determines whether multiple members belong to a set.
- SMOVE – Moves a member from one set to another.
- SPOP – Returns one or more random members from a set after removing them. Deletes the set if the last member was popped.
- SRANDMEMBER – Get one or multiple random members from a set
- SREM – Removes one or more members from a set. Deletes the set if the last member was removed.
- SSCAN – Iterates over members of a set.
- SUNION – Returns the union of multiple sets.
- SUNIONSTORE – Stores the union of multiple sets in a key.

## Slajd 243 — Redis Sets (tabela poleceń)

https://www.javatpoint.com/redis-sets

| Index | Command | Description |
|---|---|---|
| 1 | SADD key member1 [member2] | Służy do dodawania jednego lub większej liczby elementów do zestawu. |
| 2 | SCARD key | Służy do uzyskania liczby elementów w zestawie. |
| 3 | SDIFF key1 [key2] | Służy do odejmowania wielu zestawów. |
| 4 | SDIFFstore destination key1 [key2] | Służy do odejmowania wielu zestawów i zapisywania wynikowego zestawu w kluczu. |
| 5 | SINTER key1 [key2] | Służy do przecinania wielu zbiorów. |
| 6 | SINTERSTORE destination key1 [key2] | Służy do przecinania wielu zestawów i zapisywania powstałego zestawu w kluczu. |
| 7 | SISMEMBER key member | Służy do określenia, czy dana wartość należy do zbioru. |
| 8 | SMOVE source destination member | Służy do przenoszenia elementu z jednego zestawu do drugiego. |
| 9 | SPOP key | Służy do usuwania i zwracania losowego elementu ze zbioru. |
| 10 | SRANDMEMBER key [count] | Służy do uzyskania jednego lub wielu losowych elementów z zestawu. |
| 11 | SREM key member1 [member2] | Służy do usuwania jednego lub większej liczby elementów ze zbioru. |
| 12 | SUNION key1 [key2] | Służy do dodawania wielu zestawów. |
| 13 | SUNIONSTORE destination key1 [key2] | Służy do dodawania wielu zestawów i zapisywania powstałego zestawu w kluczu. |
| 14 | SSCAN key cursor [match pattern] [count count] | Służy do przyrostowej iteracji ustawionych elementów. |

## Slajd 244 — JSON – polecenia  dla typu JSON

> [Grafika] Siatka kafelków poleceń JSON ze strony redis.io (tekst angielski):

- JSON.ARRAPPEND – Append one or more json values into the array at path after the last element in it.
- JSON.ARRINDEX – Returns the index of the first occurrence of a JSON scalar value in the array at path
- JSON.ARRINSERT – Inserts the JSON scalar(s) value at the specified index in the array at path
- JSON.ARRLEN – Returns the length of the array at path
- JSON.ARRPOP – Removes and returns the element at the specified index in the array at path
- JSON.ARRTRIM – Trims the array at path to contain only the specified inclusive range of indices from start to stop
- JSON.CLEAR – Clears all values from an array or an object and sets numeric values to `0`
- JSON.DEBUG – Debugging container command
- JSON.DEBUG MEMORY – Reports the size in bytes of a key
- JSON.DEL – Deletes a value
- JSON.FORGET – Deletes a value
- JSON.GET – Gets the value at one or more paths in JSON serialized form
- JSON.MERGE – Merges a given JSON value into matching paths. Consequently, JSON values at matching paths are updated, deleted, or expanded with new children
- JSON.MGET – Returns the values at a path from one or more keys
- JSON.MSET – Sets or updates the JSON value of one or more keys
- JSON.NUMINCRBY – Increments the numeric value at path by a value
- JSON.NUMMULTBY – Multiplies the numeric value at path by a value
- JSON.OBJKEYS – Returns the JSON keys of the object at path
- JSON.OBJLEN – Returns the number of keys of the object at path
- JSON.RESP – Returns the JSON value at path in Redis Serialization Protocol (RESP)
- JSON.SET – Sets or updates the JSON value at a path
- JSON.STRAPPEND – Appends a string to a JSON string value at path
- JSON.STRLEN – Returns the length of the JSON String at path in key
- JSON.TOGGLE – Toggles a boolean value
- JSON.TYPE – Returns the type of the JSON value at path

Logo „JSON – JSON support for Redis”.

## Slajd 245 — WORKING WITH JSON

> [Grafika] Zielone nagłówki: „WORKING WITH JSON”, „Storing and managing JSON”, „Create a bike”.

> [Grafika] Niebieski blok kodu (zrzut, słabo czytelny), polecenie JSON.SET z dokumentem JSON:

```
JSON.SET bikes:1 $ '{
    "model": "Hyperion",
    "brand": "Velorim",
    "price": 844,
    "type": "Enduro bikes",
    "specs": {
        "material": "full-carbon",
        "weight": 8.7
    },
    "description": "This is a mid-travel trail slayer that is a fantastic daily driver or one bike quiver. At this price point, you get a Shimano 105 hydraulic groupset with a RS510 crank set. The wheels have had a slight upgrade for 2022, so you\'re now getting DT Swiss R470 rims with the Formula hubs. Put it all together and you get a bike that helps redefine what can be done for this price."
}'
```

Get specific fields:

```
JSON.GET bikes:1 $.model
JSON.GET bikes:1 $.specs.material
```

Update specific fields:

```
JSON.SET bikes:1 $.model '"Hyperion1"'
```

```
DELETE a bike
JSON.DEL bikes:1
```

Aby w CLI zmienić bazę logiczną wykonujemy polecenie SELECT, np. SELECT 1

> [Grafika] Fragment drzewa w VS Code: „127.0.0.1@6379 6.2.13 1.21M”, baza „0 (101)” z folderem „bikes”, baza „1 (5)” z folderem „school_json”.

## Slajd 246 — (bez tytułu) Odczyt JSON

> [Grafika] Szare przyciski: „Read a full document”, „Read a single property”, „Read a nested property”, „Read an element from an array”.

```
JSON.GET school_json:1 $ // Read the whole document
JSON.GET school_json:1 $.description // Read only the field description
JSON.GET school_json:1 $.address.city // Read the nested field address -> city
JSON.GET school_json:1 $.status_log[0] // Get the first element of an array
JSON.GET school_json:1 $.status_log[-1] // Get the last element of an array
```

## Slajd 247 — (bez tytułu) Aktualizacja i usuwanie JSON

> [Grafika] Szary przycisk „Update”.

```
JSON.GET school_json:1 $.students // Read the students field before the update

JSON.SET school_json:1 $.students 343 // Update the students field

JSON.GET school_json:1 $.students // Read the students field after the update
```

> [Grafika] Szary przycisk „Delete an element”.

```
JSON.GET school_json:1 $.students // Read the students field before deletion

JSON.DEL school_json:1 $.students // Delete only the students field from the document

JSON.GET school_json:1  // Read the whole document to confirm the construction_value field has been deleted

JSON.DEL school_json:1  // Delete the entire document

JSON.GET school_json:1 // Confirm the entire document has been deleted
```

## Slajd 248 — JSONPath - XPath for JSON

| XPath | JSONPath | Wynik |
|---|---|---|
| /store/book/author | $.store.book[*].author | autorzy wszystkich książek w sklepie |
| //author | $..author | Wszyscy autorzy |
| /store/* | $.store.* | Wszystkie rzeczy w sklepie, czyli kilka książek i czerwony rower. |
| /store//price | $.store..price | Cena wszystkiego w sklepie. |
| //book[3] | $..book[2] | Trzecia książka |
| //book[last()] | $..book[(@.length-1)] <br> $..book[-1:] | Ostatnia książka w porządku. |
| //book[position()<3] | $..book[0,1] <br> $..book[:2] | Pierwsze dwie książki |
| //book[isbn] | $..book[?(@.isbn)] | Filtruj wszystkie książki z numerem ISBN |
| //book[price<10] | $..book[?(@.price<10)] | Filtruj wszystkie książki tańsze niż 10 |
| //* | $..* | wszystkie elementy w dokumencie XML. Wszyscy członkowie struktury JSON. |

## Slajd 249 — Indeksowanie danych (Indexing and querying)

```
FT.CREATE idx:bikes
ON JSON
    PREFIX 1 "bikes:"
SCHEMA
    $.model AS model TEXT NOSTEM SORTABLE
    $.brand AS brand TEXT NOSTEM SORTABLE
    $.price AS price NUMERIC SORTABLE
    $.type AS type TAG
    $.specs.material AS material TAG
    $.specs.weight AS weight NUMERIC SORTABLE
    $.description as description TEXT
```

> [Grafika] Szary nagłówek „Indexing and querying”.

```
> FT._LIST
1) "idx:bikes"
```

```
> FT.DROPINDEX idx:bikes
"OK"
```

```
FT._LIST // Return a list of all indices

FT.INFO "idx:schools_json" // Display information about a particular index
```

**Indeksowanie danych**

Przestrzeń kluczy Redis jest nieustrukturyzowana i płaska; domyślnie dostęp do danych można uzyskać jedynie za pomocą ich klucza podstawowego (nazwy klucza), co bardzo utrudnia znalezienie dokumentu w oparciu o cechę drugorzędną. Redis Stack wychodzi naprzeciw tej potrzebie, zapewniając możliwość indeksowania i wysyłania zapytań o dane.

Po określeniu, co chcemy indeksować, indeksowanie odbywa się automatycznie (i synchronicznie) po zapisaniu nowych danych. Gdy mamy już zindeksowane dane, bardzo łatwo jest przeprowadzić w nich **wyszukiwanie pełnotekstowe i filtrować** według numeru, znacznika, a nawet położenia geograficznego.

## Slajd 250 — Indexing and querying

```
// Tworzymy indeks na danych JSON z prefiksem "school_json:"
FT.CREATE idx:schools_json
ON JSON // Określa, że indeks ma być utworzony na danych JSON
PREFIX 1 "school_json:" // Prefiks, który będzie używany do filtrowania kluczy JSON
SCHEMA // Definicja schematu indeksu
  $.name AS name TEXT NOSORTABLE // Indeksuje pole "name" jako tekst, bez sortowania.
  $.description AS description TEXT // Indeksuje pole "description" jako tekst
  $.class AS class TAG
    // Indeksuje pole "class" jako tag. Pozwala to na dokładne dopasowanie.
  $.type[*] AS type TAG // Indeksuje pole "type", które jest tablicą.
    // Każdy element w tablicy będzie traktowany jako osobny tag.
  $.address.city AS city TAG // Indeksuje pole "city" z adresu jako tag
  $.address.street AS address TEXT NOSORTABLE
    // Indeksuje pole "street" w adresie jako tekst, bez sortowania.
    // Może być przydatne do wyszukiwania pełnotekstowego.
  $.students AS students NUMERIC SORTABLE
    // Indeksuje pole "students" jako liczbowe. Pozwala na sortowanie.
  $.location AS location GEO // Indeksuje pole "location" jako dane geograficzne.
    // Pozwala na zapytania o zakres geograficzny.
  $.status_log.[-1] AS status TAG
    // Indeksuje ostatni element z tablicy "status_log" jako tag.
```

## Slajd 251 — (bez tytułu) Zapytania FT.SEARCH

> [Grafika] Szare przyciski: „Query by type”, „Search by category and price”, „Even more search parameters”.

```
FT.SEARCH idx:bikes "@type:{eBikes}"
```

> [Grafika] Czerwona tabela wyników (słabo czytelna): kolumny „Doc” i „$”, trzy wiersze (klucze bikes:…) z dokumentami JSON, m.in. `{"model":"Mercury","brand":"BikeStreet","price":...,"type":"eBikes","specs":{"material":"carbon",...`.

```
FT.SEARCH idx:bikes "@type:{eBikes} @price:[200 1200]"
    RETURN 9 $.model AS model $.type AS type $.price AS price
```

> [Grafika] Czerwona tabela wyników: kolumny „Doc”, „model”, „type”, „price”; dwa wiersze (bikes:…) z modelami m.in. „Titan”, „Fidler”(?), typ „eBikes”, ceny [nieczytelne].

```
FT.SEARCH idx:bikes "mudguards @type:{Mountain bikes} @price:[1000 3000]"
    RETURN 12 $.model AS model $.type AS type $.price AS price $.description AS description
```

> [Grafika] Czerwona tabela wyników: kolumny „Doc”, „model”, „type”, „price”, „description”; trzy wiersze typu „Mountain bikes”, ceny w zakresie 1000–3000, opisy zaczynają się m.in. „This is a mid-travel trail slayer that is a fantastic daily driver o…” [pozostałe wartości nieczytelne].

## Slajd 252 — Aggregate search

> [Grafika] Szare przyciski: „Aggregate search”, „Bike count per category”, „Average bike weight per category”, „Bikes per weight range”.

```
FT.AGGREGATE idx:bikes "@price:[1000 3000]"
    GROUPBY 1 @type
        REDUCE COUNT 0 AS count
    SORTBY 2 @count "DESC"
```

```
FT.AGGREGATE idx:bikes "*"
    GROUPBY 1 @type
        REDUCE AVG 1 @weight AS average_bike_weight
    SORTBY 2 @average_bike_weight "DESC"
```

```
FT.AGGREGATE idx:bikes "*"
    APPLY "floor(@weight)" AS weight
    GROUPBY 1 @weight
      REDUCE count 0 AS count
    SORTBY 1 @weight
```

## Slajd 253 — Transakcje w Redis

- Transakcja pozwala wykonać grupę poleceń w jednym kroku.
- **Właściwości:**
  - Wszystkie polecenia są wykonywane sekwencyjnie i izolowane.
  - Transakcja jest **atomowa** – albo wszystkie polecenia zostaną wykonane, albo żadne.
- **Jak działa?**
  - Rozpoczęcie: MULTI
  - Dodanie poleceń do transakcji.
  - Wykonanie: EXEC

```
MULTI
SET user:1 "Jan"
SET user:2 "Anna"
EXEC
```

| Indeks | Komenda | Opis |
|---|---|---|
| 1 | **DISCARD** | Służy do odrzucania wszystkich poleceń wydanych po MULTI |
| 2 | **EXEC** | Służy do wykonywania wszystkich poleceń wydanych po MULTI |
| 3 | **MULTI** | Służy do oznaczenia początku bloku transakcji |
| 4 | **UNWATCH** | Służy do zapomnienia o wszystkich obserwowanych kluczy |
| 5 | **WATCH key [key ...]** | Służy do obserwowania podanych kluczy w celu określenia wykonania bloku MULTI/EXEC |

## Slajd 254 — Nowe funkcje Redis Stack

| Funkcja | Opis | Zastosowania |
|---|---|---|
| Vector Similarity Search | Wyszukiwanie podobieństwa wektorów w danych nieustrukturyzowanych (tekst, obrazy). Obsługa hashy i JSON, algorytmy HNSW i brute-force. | - Wyszukiwanie semantyczne<br>- Rekomendacje<br>- AI (RAG, NLP, CV) |
| Redis for Time Series | Natywna struktura danych dla szeregów czasowych. Obsługa agregacji, etykiet, kompaktowania danych, integracja z Prometheus/Grafana. | - Monitoring IoT<br>- Analiza metryk systemowych<br>- Dane finansowe w czasie rzeczywistym |

## Slajd 255 —

(slajd pusty, bez treści)

## Slajd 256 — Bazy grafowe

### Model danych:
- **Graf**
  - Skierowana / nieskierowana kolekcja:
    - węzłów reprezentujących encje
    - krawędzi reprezentujących relacje między encjami
  - Zarówno węzły, jak i krawędzie mogą posiadać dowolne właściwości (atrybuty).

### Typy:
- **Transakcyjne (OLTP)** → duża liczba małych lub średnich grafów
- **Analityczne (OLAP)** → mała liczba bardzo dużych grafów

### Kiedy używać?
- Sieci społecznościowe
- Silniki rekomendacyjne
- Knowledge Graphs
- Wykrywanie oszustw
- Systemy nawigacyjne
- Analiza zależności

### Zapytania:
- Dodaj/Zmień/Usuń węzeł lub krawędź
- Wyszukiwanie najkrótszej ścieżki
- Analiza relacji i zależności
- Zapytania do podgrafów i nadgrafów
- Wyszukiwanie podobnych obiektów

### Kiedy nie używać?
- Operacje dotyczą wielu węzłów bądź krawędzi.
- Bardzo dużych, złożonych grafów w dużej liczbie.

### Przedstawiciele:
> [Grafika] Logotypy: neo4j, ArangoDB, OrientDB, JanusGraph.

## Slajd 257 — Bazy grafowe

> [Grafika] Wykres liniowy „DB-Engines Ranking of Graph DBMS” (oś Y: „Score (logarithmic scale)”, wartości 0.001–10; oś X: lata 2014–2024; „© October 2025, DB-Engines.com”). Linia Neo4j (jasnoniebieska) na samej górze, poniżej Microsoft Azure Cosmos DB (czarna); pozostałe systemy znacznie niżej. Legenda (strona 1/2): Neo4j, Microsoft Azure Cosmos DB, Aerospike, ArangoDB, Virtuoso, OrientDB, NebulaGraph, GraphDB, Amazon Neptune, Memgraph, JanusGraph, TigerGraph, Stardog, Fauna, Dgraph, SurrealDB, Giraph, Blazegraph, AllegroGraph, TypeDB, Graph Engine, Fluree, RDFox, InfiniteGraph, FalkorDB, AnzoGraph DB.

## Slajd 258 — Baza grafowa - Neo4j

> [Grafika] Infografika (cała w języku polskim, drobny druk, część tekstu słabo czytelna). Nagłówek: „Baza grafowa - Neo4j”, podtytuł „Baza danych dla danych połączonych i złożonych relacji”, logo „neo4j – Graph Database for Tomorrow”. Dziewięć paneli:

**1 Czym jest baza grafowa?** Neo4j to natywna baza grafowa, która przechowuje dane w postaci węzłów, relacji i etykiet. Została zaprojektowana do efektywnego zarządzania danymi o złożonych powiązaniach między obiektami. Żarówka: „Idealna do analizowania relacji i znajdowania ukrytych zależności w danych.”

**2 Jak działa Neo4j?** Diagram: dwa węzły (np. Osoba) połączone strzałką „Relacja” podpisaną „ZNA”; ikona „Etykiety i właściwości (np. :Osoba (name: "Jan"))”. Podpis: „Dane przechowywane są jako graf: węzły połączone relacjami, które mogą mieć kierunek i właściwości.”

**3 Przykład danych w Neo4j** (Cypher)

```
// Tworzenie węzłów i relacji
CREATE (a:Osoba {imie: 'Jan', nazwisko: 'Kowalski'})
CREATE (b:Osoba {imie: 'Anna', nazwisko: 'Nowak'})
CREATE (a)-[:ZNA {od_kiedy: 2020}]->(b)

// Wyszukiwanie znajomych Jana
MATCH (a:Osoba {imie: 'Jan'})-[:ZNA]->(b)
RETURN b.imie, b.nazwisko, b.od_kiedy;
```

**4 Najważniejsze cechy Neo4j**
- Model grafowy – Dane jako węzły, relacje i właściwości.
- Wysoka wydajność zapytań – Szybkie trawersowanie relacji.
- Skalowalność – Obsługa dużych grafów i rosnących danych.
- Zaawansowana analiza relacji – Łatwe wykrywanie wzorców i zestawień.
- Bogate możliwości zastosowań – Od rekomendacji po wykrywanie oszustw.

**5 Przykładowe operacje**

Dodawanie danych

```
CREATE (p:Produkt {nazwa: 'Laptop', cena: 3500})
CREATE (k:Klient {imie: 'Anna'})
CREATE (k)-[:KUPIŁ {data: date()}]->(p)
```

Wyszukiwanie danych

```
MATCH (k:Klient)-[:KUPIŁ]->(p:Produkt)
WHERE k.imie = 'Anna'
RETURN p.nazwa, p.cena;
```

Aktualizacja danych

```
MATCH (p:Produkt {nazwa: 'Laptop'})
SET p.cena = 3200
RETURN p;
```

**6 Zastosowania Neo4j** (ikony z podpisami): Systemy rekomendacji; Analiza sieci społecznościowych; Wykrywanie oszustw; Zarządzanie danymi powiązanymi; Wyszukiwanie i eksploracja relacji; Zarządzanie wiedzą i dokumentacją; Analityka i business intelligence; Internet rzeczy (IoT).

**7 Neo4j a inne bazy**

| Cecha | Neo4j (Baza grafowa) | Bazy relacyjne |
|---|---|---|
| Model danych | Graf (węzły i relacje) | Tabele |
| Połączenia między danymi | Naturalne i szybkie | Złożone (JOIN) |
| Wydajność zapytań o relacje | Bardzo wysoka | Zależna od złożoności |
| Skalowanie | Poziome | Głównie pionowe |
| Najlepsze zastosowania | Złożone relacje, analityka | Dane transakcyjne |

**8 Wady i ograniczenia**
- Nie jest optymalna do prostych danych tabelarycznych.
- Wyższe wymagania sprzętowe przy bardzo dużych grafach.
- Mniej odpowiednia do transakcji masowych niż tradycyjne bazy relacyjne.
- Konieczność nauki języka Cypher i innego podejścia do modelowania danych.

**9 Podsumowanie**
- Neo4j umożliwia efektywne zarządzanie danymi połączonymi i złożonymi relacjami.
- Zapewnia wysoką wydajność zapytań i łatwą analizę grafu.
- Świetnie sprawdza się w nowoczesnych aplikacjach wykorzystujących dane powiązane.
- To jedno z najpopularniejszych rozwiązań baz grafowych na świecie.

Stopka: „Neo4j – odkryj siłę połączeń. Dane zyskują wartość, gdy widać ich relacje. Connect. Discover. Build.”

## Slajd 259 — Neo4j

> [Grafika] Logo neo4j w prawym dolnym rogu.

## Slajd 260 — Neo4j – baza grafowa

> [Grafika] Logo neo4j w prawym górnym rogu.

- **Neo4j** to jedna z najpopularniejszych baz grafowych, która umożliwia przechowywanie danych w formie grafów.
- Jest zoptymalizowana pod kątem przechowywania dużych zbiorów danych z wieloma relacjami.
- Używa języka zapytań **Cypher**, który jest podobny do SQL, ale dostosowany do pracy z grafami.

**Zastosowania baz grafowych**
- **Sieci społeczne:** Reprezentowanie użytkowników i ich połączeń.
- **Rekomendacje:** Systemy rekomendacyjne (np. Netflix, Amazon).
- **Analiza oszustw:** Wykrywanie oszustw finansowych poprzez analizę nieoczywistych połączeń.

## Slajd 261 — Neo4j - podstawowe operacje

- Tworzenie węzłów i relacji:
  - `CREATE (n:Person {name: "John"})`
  - `CREATE (a:Person)-[:FRIEND]->(b:Person)`
- Wyszukiwanie danych:
  - `MATCH (n:Person) WHERE n.name = "John" RETURN n`
- Aktualizacja danych:
  - `SET n.age = 30`
- Usuwanie danych:
  - `MATCH (n:Person) DELETE n`

```
// Tworzenie węzłów
CREATE (p:Person {name: "Anna", age: 30})
CREATE (c:City {name: "Warszawa"})

// Tworzenie relacji
CREATE (p)-[:LIVES_IN]->(c)

// Wyszukiwanie danych
MATCH (p:Person)-[:LIVES_IN]->(c:City)
RETURN p.name, c.name
```

## Slajd 262 — Graph Databases in SQL Server

> [Grafika] Diagram architektury SQL Graph: „Database” –(Contains)→ „Graph” (ikona grafu z węzłami) –(isCollectionOf)→ „Node or Edge Table” (dwie ikony tabel: żółta i zielona). Z tabeli trzy strzałki: „Node table has Properties” (w lewo), „Edges connect Nodes” (łuk między tabelami), „Edge table may or may not have Properties” (w prawo).

https://learn.microsoft.com/en-us/sql/relational-databases/graphs/sql-graph-architecture?view=sql-server-ver16

## Slajd 263 — GraphTable

GraphTable to model danych w SQL Server oparty na grafach, który ułatwia modelowanie relacji pomiędzy danymi.

- **Elementy składowe**:
  - **Wierzchołki (Nodes)** – reprezentujące obiekty.
  - **Krawędzie (Edges)** – reprezentujące relacje pomiędzy obiektami.

- Wprowadzony w SQL Server 2017.

## Slajd 264 — Dlaczego GraphTable?

- Tradycyjne relacyjne modele danych mogą być trudne w modelowaniu skomplikowanych relacji.

- **Zalety modelu grafowego**:
  - Naturalne odwzorowanie sieci społecznościowych, hierarchii, map połączeń.
  - Wydajne zapytania do relacji o głębokości wielu poziomów.
  - Elastyczność w reprezentacji danych powiązanych.
## Slajd 265 — Kluczowe cechy GraphTable

Dwa typy tabel:
- Tabele wierzchołków (Node tables)
- Tabele krawędzi (Edge tables)

Rozszerzenie T-SQL:
- Specjalne zapytania grafowe, np. MATCH.
- Przykład:

```sql
SELECT *
FROM People P, Friends F
WHERE MATCH(P-(F)->P2);
```

- Brak ograniczeń na liczbę powiązań między wierzchołkami.

## Slajd 266 — Tworzenie GraphTable

- **Tworzenie tabeli wierzchołków**:

```sql
CREATE TABLE Persons
(ID INT PRIMARY KEY, Name NVARCHAR(100))
AS NODE;
```

- **Tworzenie tabeli krawędzi**:

```sql
CREATE TABLE Friendships
(StartDate DATE)
AS EDGE;
```

> [Grafika] Diagram grafu skierowanego z wierzchołkami Alex, John, Alice, Jacob. Czerwone strzałki: Alex <-> John (dwie krzywe, w obu kierunkach), John <-> Alice (dwie krzywe, w obu kierunkach), Jacob -> John (czerwona), Jacob -> Alice (blada szara).

## Slajd 267 — Sposób w jaki tabele węzłów i krawędzi są przechowywane w bazie danych

> [Grafika] Dwie tabele na niebieskim tle. Nad kolumnami Name i Age podpis „Node Properties”; nad kolumnami $from_id i $to_id podpis „Nodes that this edge connects”; nad kolumną StartDate podpis „Edge Properties”.

**Person Node Table**

| $node_id | Name | Age |
|---|---|---|
| {"type":"node","id":0} | John | 30 |
| "type":"node","id":1} | Mary | 28 |
| "type":"node","id":2} | Alice | 25 |

**Friends Edge Table**

| $edge_id | $from_id | $to_id | StartDate |
|---|---|---|---|
| {"type":"edge","id":0} | {"type":"node","id":0} | {"type":"node","id":1} | 01/01/2013 |
| {"type":"edge","id":1} | {"type":"node","id":1} | {"type":"node","id":2} | 05/05/2010 |
| {"type":"edge","id":2} | {"type":"node","id":2} | {"type":"node","id":0} | 09/09/2016 |

## Slajd 268 — Przykład wykorzystania GraphTable

- **Przykład zastosowania**:

Analiza sieci znajomych w mediach społecznościowych.
- Węzły: Użytkownicy (Persons).
- Krawędzie: Relacje znajomości (Friendships).

```sql
SELECT Friend1.Name, Friend2.Name
FROM Persons Friend1, Friendships Rel, Persons Friend2
WHERE MATCH(Friend1-(Rel)->Friend2);
```

## Slajd 269 — Przykład wykorzystania GraphTable

https://learn.microsoft.com/en-us/sql/relational-databases/graphs/sql-graph-sample?view=sql-server-ver16

```sql
-- Create NODE tables
CREATE TABLE Person (
  ID INTEGER PRIMARY KEY,
  name VARCHAR(100)
) AS NODE;

CREATE TABLE Restaurant (
  ID INTEGER NOT NULL,
  name VARCHAR(100),
  city VARCHAR(100)
) AS NODE;

CREATE TABLE City (
  ID INTEGER PRIMARY KEY,
  name VARCHAR(100),
  stateName VARCHAR(100)
) AS NODE;

-- Create EDGE tables.
CREATE TABLE likes (rating INTEGER) AS EDGE;
CREATE TABLE friendOf AS EDGE;
CREATE TABLE livesIn AS EDGE;
CREATE TABLE locatedIn AS EDGE;
```

> [Grafika] Diagram: trzy węzły — Person (u góry), City (lewy dół), Restaurant (prawy dół). Strzałki: Person -> Person podpisana „Friends” (pętla); Person -> City „LivesIn(address,...,...)”; Person -> City „Likes (rating, review...)”; Person -> Restaurant „Likes (rating, review...)”; Restaurant -> City „LocatedIn(address,...,...)”.

## Slajd 270 — Przykład wykorzystania GraphTable

https://learn.microsoft.com/en-us/sql/relational-databases/graphs/sql-graph-sample?view=sql-server-ver16

```sql
-- Insert data into node tables.
-- Inserting into a node table is same as inserting into a regular table
INSERT INTO Person (ID, name)
    VALUES (1, 'John')
         , (2, 'Mary')
         , (3, 'Alice')
         , (4, 'Jacob')
         , (5, 'Julie');

INSERT INTO Restaurant (ID, name, city)
    VALUES (1, 'Taco Dell','Bellevue')
         , (2, 'Ginger and Spice','Seattle')
         , (3, 'Noodle Land', 'Redmond');

INSERT INTO City (ID, name, stateName)
    VALUES (1,'Bellevue','WA')
         , (2,'Seattle','WA')
         , (3,'Redmond','WA');
```

## Slajd 271 — Przykład wykorzystania GraphTable

https://learn.microsoft.com/en-us/sql/relational-databases/graphs/sql-graph-sample?view=sql-server-ver16

```sql
-- Insert into edge table. While inserting into an edge table,
-- you need to provide the $node_id from $from_id and $to_id columns.
/* Insert which restaurants each person likes */
INSERT INTO likes
    VALUES ((SELECT $node_id FROM Person WHERE ID = 1),
            (SELECT $node_id FROM Restaurant WHERE ID = 1), 9);

/* Associate in which city live each person*/
INSERT INTO livesIn
    VALUES ((SELECT $node_id FROM Person WHERE ID = 1),
            (SELECT $node_id FROM City WHERE ID = 1));

/* Insert data where the restaurants are located */
INSERT INTO locatedIn
    VALUES ((SELECT $node_id FROM Restaurant WHERE ID = 1),
            (SELECT $node_id FROM City WHERE ID =1));

/* Insert data into the friendOf edge */
INSERT INTO friendOf
    VALUES ((SELECT $NODE_ID FROM Person WHERE ID = 1),
            (SELECT $NODE_ID FROM Person WHERE ID = 2));
```

## Slajd 272 — Przykład wykorzystania GraphTable

https://learn.microsoft.com/en-us/sql/relational-databases/graphs/sql-graph-sample?view=sql-server-ver16

```sql
-- Find Restaurants that John likes
SELECT Restaurant.name
FROM Person, likes, Restaurant
WHERE MATCH (Person-(likes)->Restaurant)
      AND Person.name = 'John';

-- Find Restaurants that John's friends like
SELECT Restaurant.name
FROM Person person1, Person person2, likes, friendOf, Restaurant
WHERE MATCH(person1-(friendOf)->person2-(likes)->Restaurant)
      AND person1.name='John';

-- Find people who like a restaurant in the same city they live in
SELECT Person.name
FROM Person, likes, Restaurant, livesIn, City, locatedIn
WHERE MATCH (Person-(likes)->Restaurant-(locatedIn)->City
      AND Person-(livesIn)->City);
```

## Slajd 273 — Przykład wykorzystania GraphTable

https://learn.microsoft.com/en-us/sql/relational-databases/graphs/sql-graph-sample?view=sql-server-ver16

> [Grafika] Trzy zielono obramowane wizualizacje grafów (wyniki zapytań grafowych). (1) Lewy górny: gwiazda z centralnym węzłem „John” połączonym szarymi krawędziami z węzłami: Third Day, Jeremy Cam, Passion, Ron Sexsmi, Chris Toml, Adie, Phillips_, Delirious?, Angel Rome, Casting Cr. (2) Prawy: centralny węzeł „Wolski Za” z czerwonymi strzałkami wchodzącymi od węzłów: Confection, Produce, Meat/Poult, Dairy Prod, Seafood, Condiments, Beverages. (3) Dolny środkowy: węzeł „Wolski Za” z czerwonymi strzałkami od Confection, Dairy Prod, Produce, Condiments, Seafood, Meat/Poult, Beverages; dodatkowo szare krawędzie z węzła „Wilman Kal” do tych kategorii oraz strzałka z węzła Grains/Cer do Wilman Kal.

## Slajd 274 — Zastosowania GraphTable

**Główne obszary zastosowania**:

- Analiza sieci społecznościowych.
- Mapowanie tras i połączeń.
- Analiza powiązań biznesowych.
- Wykrywanie oszustw (np. w finansach).

## Slajd 275 — Ograniczenia

Istnieją pewne ograniczenia dotyczące tabel węzłów i krawędzi:

- Tabele tymczasowe lokalne i globalne nie mogą być tabelami węzłów ani krawędzi.
- Typy tabel i zmienne tabelowe nie mogą być deklarowane jako tabele węzłów lub krawędzi.
- Tabel węzłów i krawędzi nie można tworzyć jako tabel czasowych z wersjonowaniem systemowym.
- Tabele węzłów i krawędzi nie mogą być tabelami zoptymalizowanymi pod kątem pamięci.
- Użytkownicy nie mogą aktualizować kolumn $from_id i $to_idkrawędzi za pomocą instrukcji UPDATE.
- Zapytania rozproszone dotyczące obiektów graficznych nie są obsługiwane.
- Pseudokolumny grafu ( node_id, $from_id, $to_idi edge_id) nie mogą być używane jako kolumny sortowania dla uporządkowanego indeksu magazynu kolumn klastrowanych .

## Slajd 276 — Database engine enhancements: Support for graph data

Database engine enhancements
Support for graph data

Professional networking app

> [Grafika] Graf sieci zawodowej. Węzły: Mary Jones i Andy Smith (ciemnoniebieskie, osoby), Contoso i Adventure Works (pomarańczowe, firmy), Statistics (pomarańczowy, umiejętność), Bachelor of Science, Finance (jasnopomarańczowy, wykształcenie), Business analyst i Program manager (jasnoniebieskie, stanowiska). Krawędzie (z podpisami): Mary Jones -> Andy Smith „Coworker”; Mary Jones -> Statistics „Skill”; Andy Smith -> Statistics „Skill”; Andy Smith -> Bachelor of Science, Finance „Degree earned”; Andy Smith -> Business analyst „Position”; Mary Jones -> Contoso „Former employer”; Mary Jones -> Program manager „Position”; Adventure Works -> Mary Jones „Employer”; Adventure Works -> Andy Smith „Employer”; Adventure Works -> Business analyst „Role in company”; Adventure Works -> Program manager „Role in company”; Contoso -> Program manager „Role in company”.

## Slajd 277 — Match is more concise than joins

Lewa kolumna:

```sql
-- Find employees reporting to John who work at
Seattle location using MATCH
SELECT person2.name
FROM Employee person1,
     Manages manages,
     Employee person2,
     works_at,
     location
WHERE MATCH(person1-(manages)->person2-
(works_at)->location)
AND person1.name = 'John'
AND location.name = 'Seattle'
```

Prawa kolumna:

```sql
-- Find employees reporting to John who
work at Seattle location using JOINS
SELECT person2.name
FROM Employee person1,
     Manages manages,
     Employee person2,
     works_at,
     location
WHERE person1.$node_id = manages.$from_id
  AND manages.$to_id = person2.$node_id
  AND person2.$node_id = works_at.$from_id
  AND works_at.$to_id = location.$node_id
  AND location.name = 'Seattle'
  AND person1.name = 'John'
```

## Slajd 278 — Recommending Songs: Approach

> [Grafika] Dwie kolumny: po lewej niebieski prostokąt z użytkownikami User1–User5, po prawej zielony prostokąt z utworami Song1–Song5. Strzałki: User1 -> Song2 (czerwona ciągła); User3 -> Song2 (zielona ciągła); User4 -> Song2 (zielona ciągła); User3 -> Song3 (niebieska przerywana); User4 -> Song3 (niebieska przerywana); User1 -> Song3 (gruba fioletowa przerywana, rekomendacja); cienkie szare przerywane linie: User1 -> Song5, User2 -> Song4, User5 -> Song1.

## Slajd 279 — Implementation using SQL Graph

> [Grafika] Dwa koła: UniqueUser (node table) po lewej i UniqueSong (node table) po prawej, połączone strzałką „Likes (edge table)” od UniqueUser do UniqueSong.

```sql
CREATE TABLE UniqueUser
(UserId VARCHAR(80))
AS NODE
```

```sql
CREATE TABLE Likes
(ListenCount BIGINT)
AS EDGE
```

```sql
CREATE TABLE UniqueSong
(SongId VARCHAR(50)
,SongTitle VARCHAR(500)
,ArtistName VARCHAR(500))
AS NODE
```

## Slajd 280 — (brak tytułu)

> [Grafika] Pusty slajd (sama czarna ramka, bez treści).

## Slajd 281 — Bazy rodziny kolumn

### Model danych:
- Rodzina kolumn (tabela)
  - Tabela to kolekcja podobnych wierszy (niekoniecznie identycznych)
- Wiersz
  - Wiersz to kolekcja kolumn
    - Agreguje dane pozyskiwane wspólnie.
  - Dostęp zapewnia identyfikator wiersza (np. klucz partycji / row key).
- Kolumna
  - Kolumna składa się z nazwy i wartości.
  - Dozwolone są zarówno wartości skalarne, jak i listy czy mapy.

### Zapytania:
- Dodaj/Zmień/Usuń wiersz zawierający rodzinę kolumn.
- Wybierz wiersz na podstawie identyfikatora lub prostego przeszukiwania kolumn.

### Uwaga:
- Nie są to po prostu bazy relacyjne, ze zmienną specyfikacją wiersza.

### Kiedy używać?
- Blogi, systemy CMS.

### Kiedy nie używać?
- Gdy wymagane są transakcje (ze ścisłą spójnością).
- Występują złożone zapytania: agregacja (SUM, AVG, ...), złączenia itp.
- Schemat bazy może zostać często zmieniony.

### Przedstawiciele:

> [Grafika] Rząd logotypów: Apache Cassandra, ScyllaDB, Apache HBase, Google Bigtable, Azure Cosmos DB (API Cassandra).

## Slajd 282 — Bazy rodziny kolumn

> [Grafika] Wykres liniowy „DB-Engines Ranking of Wide Column Stores” (skala logarytmiczna „Score (logarithmic scale)”, oś Y od 0.001 do 100, oś X lata 2014–2024; stopka „© October 2025, DB-Engines.com”). Legenda: Apache Cassandra, Microsoft Azure Cosmos DB, Apache HBase, ScyllaDB, Datastax Enterprise, Microsoft Azure Table Storage, Google Cloud Bigtable, Apache Accumulo, Amazon Keyspaces, HPE Ezmeral Data Fabric, Elassandra, Alibaba Cloud Table Store, SWC-DB, Hypertable, Sqrrl. Cassandra jest na szczycie (ok. 100), HBase ok. 20–60 z tendencją malejącą, Cosmos DB rośnie do ok. 30–40 i spada do ok. 20; pozostałe między 0.01 a 10.

## Slajd 283 — (logo Cassandra)

> [Grafika] Logo Apache Cassandra: niebieskie oko z rzęsami i napis „cassandra”.

## Slajd 284 — Baza kolumnowa (Wide-Column) - Apache Cassandra

> [Grafika] Infografika z logo Apache Cassandra. Podtytuł: „Rozproszona baza danych dla systemów o wysokiej dostępności”.

**1. Czym jest baza kolumnowa?**
Apache Cassandra przechowuje dane w modelu szerokich kolumn (Wide-Column Store). Dane organizowane są w tabelach, ale struktura jest bardziej elastyczna niż w tradycyjnych bazach relacyjnych.
(Żarówka:) Zaprojektowana do pracy na wielu serwerach bez pojedynczego punktu awarii.

**2. Jak działa Cassandra?**
Schemat: Rekord (wiersz) -> Tabela (column family) -> Keyspace (przestrzeń nazw) -> Klaster Cassandra (wiele węzłów).
Klaster składa się z wielu równorzędnych węzłów przechowujących część danych.

**3. Przykład rekordu w Cassandra** (CQL)

```sql
-- Tworzenie tabeli
CREATE TABLE klienci (
  id INT PRIMARY KEY,
  imie TEXT,
  nazwisko TEXT,
  miasto TEXT,
  wiek INT
);
-- Przykładowe dane (rekord)
INSERT INTO klienci (id, imie, nazwisko, miasto, wiek)
VALUES (1001, 'Jan', 'Kowalski', 'Warszawa', 25);
```

**4. Najważniejsze cechy Cassandra**
- Wysoka dostępność: Brak pojedynczego punktu awarii
- Skalowalność pozioma: Łatwe dodawanie nowych serwerów do klastra
- Replikacja danych: Automatyczne kopiowanie danych między węzłami
- Bardzo wysoka wydajność zapisu: Przystosowana do ogromnych wolumenów danych
- Architektura rozproszona: Wszystkie węzły są równorzędne (peer-to-peer)

**5. Przykładowe operacje**
Dodawanie danych:

```sql
INSERT INTO klienci
(id, imie, nazwisko, miasto, wiek)
VALUES (1002, 'Anna', 'Nowak', 'Kraków', 28);
```

Wyszukiwanie danych:

```sql
SELECT * FROM klienci
WHERE id = 1002;
```

Aktualizacja danych:

```sql
UPDATE klienci
SET wiek = 29
WHERE id = 1002;
```

**6. Zastosowania Cassandra**
- Aplikacje internetowe o dużym ruchu
- Systemy mobilne
- Big Data i analityka
- Platformy społecznościowe
- Internet rzeczy (IoT)
- Gry online
- Monitoring i telemetria

**7. Cassandra a inne bazy**

| Cecha | Cassandra (Wide-Column) | Bazy relacyjne |
|---|---|---|
| Model danych | Szerokie kolumny | Tabele |
| Skalowanie | Poziome | Głównie pionowe |
| Dostępność | Bardzo wysoka | Zależna od konfiguracji |
| Spójność danych | Konfigurowalna (tzw. eventual) | Silna (ACID) |
| Najlepsze zastosowania | Duże rozproszone systemy | Dane transakcyjne |

**8. Wady i ograniczenia**
- Bardziej złożone modelowanie danych.
- Ograniczone możliwości operacji JOIN.
- Nie jest optymalna do skomplikowanych transakcji.
- Projekt zapytań należy planować przed tworzeniem tabel (denormalizacja danych).

**9. Podsumowanie**
- Cassandra zapewnia wysoką dostępność i odporność na awarie.
- Doskonale skaluje się na setki i tysiące serwerów.
- Jest jednym z najpopularniejszych rozwiązań NoSQL dla systemów Big Data.
- Sprawdza się tam, gdzie priorytetem są wydajność i niezawodność.

(Żarówka:) Apache Cassandra – dane bez przestojów. Skaluj globalnie. Przechowuj niezawodnie.

## Slajd 285 — Partycjonowanie danych w Cassandra

> [Grafika] Schemat przepływu od lewej do prawej: tabela „Dane” -> „Funkcja haszująca” -> „Token (hash partition key)” -> „Mapowanie tokena do partycji” -> „Partycja (wszystkie wiersze o tym samym partition key)” -> „Umieszczenie partycji na węźle w pierścieniu” -> „Pierścień Cassandra (węzły klastra)” z czterema węzłami (Węzeł 1 niebieski u góry, Węzeł 2 zielony po prawej, Węzeł 3 pomarańczowy u dołu, Węzeł 4 czerwony po lewej); w środku pierścienia: „Partycje danych rozłożone po węzłach na podstawie tokenów”.

Tabela „Dane”:

| user_id (partition key) | event_time | activity |
|---|---|---|
| 101 | 2024-01-10 | login |
| 101 | 2024-01-11 | view |
| 101 | 2024-01-12 | purchase |
| 202 | 2024-01-10 | login |
| 202 | 2024-01-11 | view |
| ... | ... | ... |

## Slajd 286 — Dlaczego Cassandra stosuje partycjonowanie?

W dużych systemach niemożliwe jest przechowywanie wszystkich danych na jednym serwerze.

### Problemy
- ograniczona pamięć i przestrzeń dyskowa,
- przeciążenie pojedynczego serwera,
- niska dostępność.

### Rozwiązanie
- Podział danych na wiele węzłów klastra.

> [Grafika] Po prawej porównanie: „Jeden serwer (brak partycjonowania)” — jedna ikona bazy danych z podpisem „Wszystkie dane na jednym serwerze” i listą problemów: „ograniczona pamięć i przestrzeń dyskowa”, „przeciążenie serwera”, „niska dostępność”; strzałka do „Klaster Cassandra (z partycjonowaniem)” — cztery ikony baz danych w pierścieniu z „...” w środku, podpis „Dane podzielone na wiele węzłów klastra”.

## Slajd 287 — Partycjonowanie danych w Apache Cassandra

Data Partitioning

### Cele:
- równomierne rozłożenie danych w klastrze,
- skalowanie poziome,
- eliminacja wąskich gardeł,
- wysoka dostępność danych.

### Kluczowe pojęcia:
- Partition Key
- Token
- Hashing
- Token Ring
- Virtual Nodes (vnodes)

> [Grafika] Pionowy schemat przepływu: „Partition Key np. user_id = 101” -> „Hashing np. Murmur3” -> „Token np. 45678” -> pierścień „Token Ring (węzły klastra)” z węzłami Node 1 (góra, niebieski), Node 2 (prawo, zielony), Node 3 (dół, pomarańczowy), Node 4 (lewo, czerwony) -> „Distributed Data: Dane umieszczone na wybranym węźle na podstawie tokena”.

## Slajd 288 — Klucz partycji (Partition Key)

Każdy rekord posiada klucz partycji.

### Przykład:

SQL

```sql
CREATE TABLE users (
  user_id UUID,
  login TEXT,
  email TEXT,
  PRIMARY KEY (user_id)
);
```

W tym przypadku:
`user_id` jest kluczem partycji.

> [Grafika] Schemat: tabela „Rekord danych” (user_id = 550e8400-..., login = johndoe, email = john@example.com, ...) -> „Partition Key (user_id)” -> „Klaster Cassandra (przykładowe węzły)” z węzłami Węzeł 1–4 w pierścieniu i podpisem „Dane umieszczane na węzłach na podstawie klucza partycji”.

### Rola klucza partycji
1. identyfikuje partycję,
2. określa położenie danych w klastrze,
3. wpływa na wydajność całego systemu.

## Slajd 289 — Od klucza do tokenu

Cassandra nie przechowuje danych bezpośrednio według klucza.

### Proces:
- Partition Key (klucz partycji)
- ↓
- Funkcja Hash (np. Murmur3)
- ↓
- Token (wynik haszowania)
- ↓
- Węzeł klastra (przechowuje dane)

### Przykład:
- user123 (partition key)
- ↓
- Hash(user123) (np. Murmur3)
- ↓
- Token = 845278199
- „Wybór węzła na podstawie tokenu” ->

> [Grafika] Pierścień Cassandra (węzły klastra) z węzłami: Węzeł 1 (góra), Węzeł 2 (prawo, zielony, „(wybrany)”), Węzeł 3 (dół), Węzeł 4 (lewo); w środku „Token Ring: Dane rozłożone na węzłach na podstawie tokenów”.

Na podstawie tokenu wybierany jest serwer przechowujący dane.

## Slajd 290 — Partycjoner Murmur3Partitioner

Domyślny partycjoner Cassandry:
Murmur3Partitioner

### Zadania:
1. oblicza hash klucza partycji,
2. generuje 64-bitowy token,
3. zapewnia równomierny rozkład danych.

### Zakres tokenów:
−2^63 ... +2^63 − 1
(czyli od -9 223 372 036 854 775 808 do 9 223 372 036 854 775 807)

> [Grafika] Schemat: „Klucz partycji (np. user123)” -> „Murmur3Partitioner (funkcja hash: Murmur3)” -> „64-bitowy token (np. 845278199)” -> „Mapowanie tokena do węzła w pierścieniu” -> pierścień z węzłami Węzeł 1 (góra), Węzeł 2 (prawo), Węzeł 3 (dół), Węzeł 4 (lewo); w środku: „Dane rozłożone na węzłach na podstawie tokenów (Murmur3)”; podpis nad pierścieniem „Pierścień Cassandra (zakres tokenów: −2^63 ... +2^63 − 1)”.

**Czym jest Murmur3?**
Murmur3 to szybka, niekryptograficzna funkcja haszująca, zaprojektowana do równomiernego rozkładu danych. Dla danego klucza partycji generuje 64-bitową wartość (token), która określa położenie danych w pierścieniu klastra Cassandry.

### Korzyść:
minimalizacja ryzyka nierównomiernego rozkładu danych (data skew).

## Slajd 291 — Token Ring / Jak Cassandra wybiera węzeł?

### Token Ring
Wszystkie tokeny są rozmieszczone na logicznym pierścieniu.

> [Grafika] Okrąg „Pierścień tokenów (Token Ring)”: punkt 0 na górze, −2^63 po lewej, +2^63 po prawej; węzły Node A (niebieski, lewa góra), Node B (zielony, prawa góra), Node C (pomarańczowy, dół); łuki w kolorach niebieskim, zielonym i pomarańczowym.

Każdy węzeł odpowiada za określony zakres tokenów.

### Właściwości
1. brak centralnego koordynatora,
2. łatwe dodawanie nowych węzłów,
3. równomierne obciążenie klastra.

### Jak Cassandra wybiera węzeł?

**Załóżmy klaster:**

| Węzeł | Zakres tokenów |
|---|---|
| Node A | 0 – 100 |
| Node B | 101 – 200 |
| Node C | 201 – 300 |

**Dla rekordu:**

SQL

```sql
user_id = 12345
```

↓

**otrzymano:**

Token

```
Token = 145
```

↓

**Wynik:**
145 należy do zakresu Node B.

↓

Dane zostają zapisane na Node B.

## Slajd 292 — Partycja danych / Partition Key i Clustering Column

### Partycja danych
W Cassandrze partycja jest zbiorem rekordów o tym samym Partition Key.

**Przykład:**

SQL

```sql
CREATE TABLE sensor_data (
  sensor_id TEXT,
  timestamp TIMESTAMP,
  value DOUBLE,
  PRIMARY KEY (sensor_id, timestamp)
);
```

**Klucz partycji:**

SQL

```sql
sensor_id
```

Wszystkie dane czujnika znajdują się razem.

**Przykładowa partycja:**

> [Grafika] Schemat: „sensor01 (Partition Key)” -> cztery wiersze: 10:00 (value: 23.1), 10:01 (value: 23.4), 10:02 (value: 23.0), 10:03 (value: 22.8).

### Partition Key i Clustering Column

**Przykład:**

SQL

```sql
PRIMARY KEY (
  sensor_id,
  timestamp
)
```

**Składa się z:**

- Partition Key: SQL `sensor_id` — Określa lokalizację danych.
- Clustering Column: SQL `timestamp` — Określa kolejność danych wewnątrz partycji.

Partycja (sensor_id = sensor01)

| sensor_id | timestamp | value |
|---|---|---|
| sensor01 | 10:00 | 23.1 |
| sensor01 | 10:01 | 23.4 |
| sensor01 | 10:02 | 23.0 |
| sensor01 | 10:03 | 22.8 |
| ... | ... | ... |

> [Grafika] Klamry przy tabeli: przy czterech wierszach sensor01 podpis „Ten sam Partition Key (wszystkie wiersze w tej samej partycji)”; przy kolumnie timestamp podpis „Dane posortowane według Clustering Column”.

## Slajd 293 — Composite Partition Key / Problem dużych partycji

### Composite Partition Key
Gdy jeden atrybut powoduje zbyt dużą partycję.

SQL

```sql
PRIMARY KEY (
  (customer_id, month),
  order_date
)
```

**Partition Key:**

SQL

```sql
(customer_id, month)
```

**Przykład:**
customer = 1001
month = 2025-01

> [Grafika] Schemat: „Partition Key (customer_id, month)” z polami customer_id = 1001 i month = 2025-01 -> „Rekordy w partycji”: order_date = 2025-01-05, order_date = 2025-01-12, order_date = 2025-01-20, order_date = 2025-01-28, ...

### Korzyści:
1. mniejsze partycje,
2. lepsze rozłożenie danych,
3. szybsze zapytania.

### Problem dużych partycji
**Bad Design**

SQL

```sql
PRIMARY KEY (
  sensor_type,
  timestamp
)
```

**Przykład:**
sensor_type = temperature

Milony rekordów trafiają do jednej partycji.

> [Grafika] Schemat: „Partition Key (sensor_type)” z polem sensor_type = temperature -> „Miliony rekordów w jednej partycji”: timestamp = 2025-01-01 00:00, timestamp = 2025-01-01 00:01, timestamp = 2025-01-01 00:02, ..., timestamp = 2025-06-30 23:59.

### Konsekwencje:
- przeciążony węzeł
- długie odczyty
- większe zużycie pamięci

## Slajd 294 — Virtual Nodes (vnodes) / Dodanie nowego węzła

### Virtual Nodes (vnodes)
Od Cassandra 2.x stosowane są:
Virtuail Nodes

**Zamiast jednego dużego zakresu tokenów:** / **węzeł przechowuje wiele małych zakresów:**

> [Grafika] Lewy pierścień: Node A z jednym dużym łukiem „Jeden duży zakres tokenów”; strzałka; prawy pierścień: Node A z wieloma małymi punktami, podpis „Wiele małych zakresów tokenów (vnodes)”, ramka z listą: Node A — Token Range 1, Token Range 2, Token Range 3, Token Range N.

### Korzyści:
- prostsze skalowanie
- szybsze rebalansowanie klastra
- bardziej równomierne obciążenie

### Dodanie nowego węzła

**Przed** / **Po dodaniu**

> [Grafika] Przed: pierścień „Klaster Cassandra (3 węzły)” z węzłami Node A, Node B, Node C; strzałka; Po dodaniu: pierścień „Klaster Cassandra (4 węzły)” z węzłami Node A, Node B, Node C, Node D (nowy, czerwony).

**Cassandra automatycznie:**
1. przenosi część tokenów,
2. redistribuuje dane,
3. zachowuje dostępność systemu.

**Proces ten nazywany jest:**
Rebalancing

## Slajd 295 — Dobre praktyki projektowania Partition Key / Podsumowanie

### Dobre praktyki projektowania Partition Key

**Zalecenia**
- wysoka kardynalność klucza
- równomierny rozkład wartości
- ograniczona wielkość partycji
- modelowanie pod konkretne zapytania

**Unikać**
- bardzo dużych partycji
- niewielkiej liczby kluczy
- częstych hotspotów
- projektowania jak w relacyjnych bazach danych

### Podsumowanie

**Najważniejsze fakty**
1. Cassandra rozkłada dane przy użyciu **Partition Key**.
2. Klucz jest przekształcany do **tokenu** przez **Murmur3Partitioner**.
3. Token wskazuje węzeł w **Token Ring**.
4. Dobrze dobrany klucz partycji jest kluczowy dla wydajności.
5. **Virtual Nodes** ułatwiają skalowanie i równoważenie obciążenia.
6. Najczęstszy problem projektowy to **Hot Partition**.

(Żarówka:) W Cassandrze wydajność systemu zależy przede wszystkim od poprawnego zaprojektowania klucza partycji.

## Slajd 296 — 1. Data Modeling w Cassandra / 2. SQL vs Cassandra / 3. Najpierw zapytania / 4. Partition Key

### 1. Data Modeling w Cassandra
> [Grafika] Przepływ: „Queries” -> „Data Model” -> ikona bazy z logo „cassandra”. Obok trzy hasła z ikonami: „Query-Driven Design”, „Denormalizacja”, „Wydajność odczytu”.

### 2. SQL vs Cassandra
> [Grafika] Po lewej „Relacyjna baza (SQL)”: tabela Customers połączona z tabelami Orders i Products. Po prawej „Cassandra”: trzy osobne tabele: orders_by_customer, orders_by_product, orders_by_day.

### 3. Najpierw zapytania
> [Grafika] Pole z lupą i zapytaniem:

```sql
SELECT *
FROM orders
WHERE customer_id = ?
```

strzałka -> „Data Model”.

### 4. Partition Key
> [Grafika] Klucz „customer_id” ze strzałkami do trzech serwerów w pierścieniu: Node 1, Node 2, Node 3.

## Slajd 297 — 5. Partycja danych / 6. Clustering Columns / 7. Denormalizacja / 8. Dobry model – E-commerce

### 5. Partycja danych
> [Grafika] Ikona osoby „customer_id = 1001” -> „Partition (customer_id = 1001)” zawierająca: Order 1, Order 2, Order 3, Order 4, ...

### 6. Clustering Columns
> [Grafika] „Partition Key customer_id” + „Clustering Column order_date”; oś czasu: 2025-01-01 Order 1; 2025-01-03 Order 2; 2025-01-05 Order 3; 2025-01-07 Order 4.

### 7. Denormalizacja
> [Grafika] Dokument „Order” ze strzałkami do dwóch tabel: „orders_by_customer” i „orders_by_product”.

### 8. Dobry model – E-commerce
> [Grafika] Tabela „orders_by_customer”:

| customer_id | order_date | amount |
|---|---|---|
| 1001 | 2025-01-01 | 250 |
| 1001 | 2025-01-03 | 320 |
| 1001 | 2025-01-05 | 180 |

Obok trzy zielone znaczniki: „Szybki odczyt”, „Dobra skalowalność”, „Małe partycje”.

## Slajd 298 — 9. Zły model – Hot Partition / 10. Podsumowanie – 5 zasad Data Modeling

### 9. Zły model – Hot Partition
> [Grafika] Ikona globu „country = POLAND” -> czerwona partycja „Partition (country = POLAND)” z wieloma wierszami i „...” -> serwer z czerwonym znakiem ostrzegawczym. Po prawej lista z czerwonymi krzyżykami: „Przeciążenie”, „Wolniejsze zapytania”, „Hotspot”.

### 10. Podsumowanie – 5 zasad Data Modeling
> [Grafika] Pięć elementów wokół logo „cassandra”: „Projektuj pod zapytania”, „Dobierz właściwy Partition Key”, „Używaj Clustering Columns”, „Denormalizuj dane”, „Unikaj dużych partycji”.

## Slajd 299 — Data Modeling w Apache Cassandra / Query-Driven Design

### Data Modeling w Apache Cassandra
Modelowanie danych w Cassandrze

„W Cassandrze najpierw projektuje się zapytania, a dopiero później tabelę.”

**Różnica względem baz relacyjnych:**

| SQL (relacyjne) | Cassandra |
|---|---|
| model danych → zapytania | zapytania → model danych |
| normalizacja | denormalizacja |
| JOIN | brak JOIN |
| elastyczne zapytania | elastyzanie zaprojektowane wcześniej |

(Żarówka:) Cassandra to baza zaprojektowana pod dużą skalę i przewidywalną wydajność – dlatego model danych musi wynikać z potrzeb zapytań.

### Query-Driven Design
Projektowanie pod zapytania

**Przed utworzeniem tabel należy określić:**
1. jakie dane będą odczytywane,
2. jak często,
3. po jakich polach będą wyszukiwane,
4. jakie są wymagania wydajnościowe.

**Proces projektowania:**
> [Grafika] Pionowy przepływ: Business Question -> Query -> Data Model -> Table.

## Slajd 300 — Dlaczego Cassandra różni się od SQL? / Projektowanie od zapytań

### Dlaczego Cassandra różni się od SQL?

**Cassandra została zaprojektowana dla:**
- dużej skali
- wysokiej dostępności
- rozproszenia geograficznego
- przewidywalnej wydajności

**Dlatego ogranicza:**
- JOIN
- GROUP BY na dużą skalę
- złożone relacje między tabelami
- ad-hoc zapytania na wszystkich danych

(Info:) Cassandra to rozproszona baza NoSQL zaprojektowana do obsługi bardzo dużych ilości danych w wielu centrach danych.

### Projektowanie od zapytań

**Przykład wymagania biznesowego:**
„Pokaż wszystkie pomiary dla czujnika z ostatnich 24 godzin.”

**Zapytanie:**

CQL

```sql
SELECT *
FROM sensor_data
WHERE sensor_id = ?
  AND timestamp >= ?
  AND timestamp <= ?;
```

**Model tabeli:**

CQL

```sql
CREATE TABLE sensor_data (
  sensor_id TEXT,
  timestamp TIMESTAMP,
  value DOUBLE,
  PRIMARY KEY (sensor_id, timestamp)
);
```

(Zielony znacznik:) Partition Key wynika bezpośrednio z potrzeb zapytania.

## Slajd 301 — Denormalizacja danych / Jedna tabela dla jednego wzorca odczytu

### Denormalizacja danych

**W bazach relacyjnych:**
> [Grafika] Trzy kafelki: Customers -> Orders -> Products, z podpisem „Relacje między tabelami (za pomocą JOIN)”.

**W Cassandrze:**
- customer_orders — Zamówienia klienta (denormalizowane dane)
- customer_products — Produkty klienta (duplikacja danych)
- customer_statistics — Statystyki klienta (oddzielny widok danych)

Ta sama informacja może występować w wielu tabelach. Denormalizacja to celowe powielenie danych dla szybszych odczytów.

### Jedna tabela dla jednego wzorca odczytu

Każda tabela powinna obsługiwać konkretne zapytanie.

- Orders by Customer →

```sql
SELECT *
FROM orders_by_customer
WHERE customer_id = ?
```

- Orders by Status →

```sql
SELECT *
FROM orders_by_status
WHERE status = ?
```

- Orders by Product →

```sql
SELECT *
FROM orders_by_product
WHERE product_id = ?
```

(Zielony znacznik:) Różne zapytania = różne tabele. Nie ma jednej uniwersalnej tabeli.

## Slajd 302 — Kiedy tworzyć nową tabelę? / Najczęstsze błędy modelowania

### Kiedy tworzyć nową tabelę?

**Jeżeli pojawia się nowe zapytanie:**

CQL

```sql
SELECT *
FROM orders
WHERE product_id = ?;
```

↓

**Często tworzy się nową tabelę:**
orders_by_product
Zoptymalizowana pod nowe zapytanie

Nowe ważne zapytanie często oznacza nową tabelę.

### Najczęstsze błędy modelowania
- projektowanie jak w Oracle
- próba używania JOIN
- używanie ALLOW FILTERING
- zbyt duże partycje
- niska kardynalność Partition Key
- jedna tabela do wszystkiego

(Ostrzeżenie:) Te błędy prowadzą do niskiej wydajności, nierównomiernego rozkładu danych i problemów ze skalowaniem.

## Slajd 303 — Cykl projektowania danych / Podsumowanie

### Cykl projektowania danych

> [Grafika] Pionowy przepływ kafelków:
> - Business Requieement — Wymaganie biznesowe
> - Query — Zapytanie do danych
> - Partition Key — Wybór klucza partycji
> - Clustering Column — Określenie kolejności danych
> - Table — Utworzenie tabeli
> - Validation — Weryfikacja i testy

### Podsumowanie

**Najważniejsze zasady**
1. Projektuj pod zapytania.
2. Partition Key jest najważniejszą decyzją.
3. Cassandra preferuje denormalizację.
4. Jedno zapytanie = często jedna tabela.
5. Unikaj myślenia relacyjnego.
6. Wydajność zależy od modelu danych bardziej niż od sprzętu.

(Zielony znacznik:) W Cassandrze wydajność systemu zależy przede wszystkim od poprawnego zaprojektowania klucza partycji.

## Slajd 304 — Bazy rodziny kolumn

Model danych
- Rodzina kolumn
  - Tabela to kolekcja **podobnych wierszy** (niekoniecznie identycznych)
- Wiersz
  - Wiersz to kolekcja kolumn
    - Powinien agregować porcję danych, która jest odczytywana razem
  - Posiada przyporządkowany unikalny **identyfikator (klucz) wiersza**
- Kolumna
  - Kolumna składa się z **nazwy kolumny** i **wartości w kolumnie** (oraz potencjalnie innych metadanych)
  - Agreguje wartości skalarne, ale również **płaskie zbiory, listy czy mapy** są dopuszczalne

## Slajd 305 — Apache Cassandra

> [Grafika] Logo Cassandra (oko i napis „cassandra”) w prawym górnym rogu.

**Baza rodziny kolumn**
- http://cassandra.apache.org/
- Właściwości
  - Open-source, wysoka dostępność, skalowalność liniowa, partycjonowanie poziome (ang. sharding), replikacja typu peer-to-peer, regulowana spójność, wsparcie dla MapReduce
- Zarządzany przez **Apache Software Foundation**
  - Pierwotnie stworzony przez Facebook
- Zaimplementowany w języku Java
- Systemy operacyjne: dostępne dla wielu platform
- Pierwsze wydanie w 2008 r.

## Slajd 306 — Apache Cassandra

Apache Cassandra przechowuje dane w tabelach, przy czym każda tabela składa się z wierszy i kolumn. Język CQL (Cassandra Query Language) jest używany do wykonywania zapytań do danych przechowywanych w tabelach.

Model danych Apache Cassandra jest oparty na zapytaniach i zoptymalizowany pod kątem zapytań. Cassandra nie obsługuje relacyjnego modelowania danych przeznaczonego dla relacyjnych baz danych.

## Slajd 307 — Model danych

Struktura bazy danych

Instancja → **przestrzeń kluczy** → **tabele** → **wiersze** → **kolumny**

- Przestrzeń kluczy
- Tabela (rodzina kolumn)
  - **Kolekcja (podobnych) wierszy**
    - Wiersze nie muszą mieć dokładnie tych samych kolumn
  - Schemat tabeli musi być podany, ale może być modyfikowany później
- Wiersz
  - **Kolekcja kolumn**
  - Każdy wiersz jest **jednoznacznie identyfikowalny** przez wymagany klucz główny
- Kolumna
  - **Para klucz-wartość** + inne metadane

## Slajd 308 — Przykład

```sql
CREATE KEYSPACE IF NOT EXISTS store WITH REPLICATION =
{ 'class' : 'SimpleStrategy',
'replication_factor' : '1'
};

CREATE TABLE IF NOT EXISTS store.shopping_cart (
    userid text PRIMARY KEY,
    item_count int,
    last_update_timestamp timestamp
);

INSERT INTO store.shopping_cart
    (userid, item_count, last_update_timestamp)
    VALUES ('9876', 2, toTimeStamp(now()));
INSERT INTO store.shopping_cart
    (userid, item_count, last_update_timestamp)
    VALUES ('1234', 5, toTimeStamp(now()));
```
## Slajd 309 — Model danych

**Wartości kolumn**

- Puste
  - null
- Wartości atomowe
  - **Natywne typy danych** ciągi znaków, liczby, daty itp.
  - **Krotki (ang. Tuples)**
    - Analogia do kolekcji deskryptorów
  - **Typy definiowane przez użytkownika** (UDT)
    - Zbiór pól dowolnego typu
- Kolekcje
  - **Listy**, **zbiory**, **mapy**
    - Zagnieżdżone krotki, typy definiowane przez użytkownika, czy kolekcje są dozwolone, jednakże tylko w trybie **frozen**.

## Slajd 310 — Model danych

Kolekcje:

- **Lista = uporządkowana kolekcja wartości.**
  - Porządek zależy od pozycji danej.
  - Wartości nie muszą być unikalne.
- **Zbiór = kolekcja unikalnych wartości**
  - Wartości są wewnętrznie <u>uporządkowane</u>
- **Mapa = kolekcja par klucz-wartość**
  - Klucze muszą być unikalne
  - Pary są wewnętrznie <u>uporządkowane</u> na podstawie kluczy

## Slajd 311 — Przykładowe dane

Tabela **aktorzy**

> [Grafika] Tabela z kolorowymi komórkami: nagłówek kolumn „id” (niebieski) i druga, pusta kolumna nagłówka. Każdy wiersz ma id oraz zagnieżdżone kolumny: „dane” (zielony), „rok” (szary), „filmy” (pomarańczowy).

| id | dane | rok | filmy |
|---|---|---|---|
| 'stallone' | ( 'S', 'Stallone' ) | 1964 | { 'Rambo', 'Niezniszczalni' } |
| 'schwarzenegger ' | ( 'A', 'Schwarzenegger' ) | 1966 | { 'Niezniszczalni', 'Pamięć absolutna', 'Conan' } |
| 'snipes' | ( 'W', 'Snipes' ) | 1973 | { 'Pasażer 57' } |
| 'norris' | ( 'C', 'Norris' ) | 1936 | { 'Strażnik Teksasu' } |

## Slajd 312 — (bez tytułu) Tabela filmy

Tabela **filmy**

> [Grafika] Tabela z kolorowymi komórkami: nagłówek „id” (niebieski) i druga, pusta kolumna nagłówka. Kolumny wewnętrzne: „tytul” (szary), „rok” (szary), „rezyser” (zielony), „wlasciwosci” (fioletowy), „aktorzy” (żółty), „gatunki” (czerwony/łososiowy). Wiersze mają różne zestawy kolumn.

| id | tytul | rezyser | rok | wlasciwosci | aktorzy | gatunki |
|---|---|---|---|---|---|---|
| 'nietykalni' | 'Nietykalni' | — | 2011 | — | null | [ 'komedia', 'dramat' ] |
| 'niezniszczalni' | 'Niezniszczalni' | ( 'Sylvester', 'Stallone' ) | 2010 | { dlugosc: 100 } | { 'stallone': 'Sylvester', 'jet': ,Li' } | — |
| 'tombraider' | 'Tomb Raider' | — | 2001 | — | — | — |
| 'hobbit' | 'Hobbit' | — | 2012 | — | {} | [ 'fantasy', 'przygoda' ] |

## Slajd 313 — Model danych

- **Dodatkowe dane** związane z…
  - Całą kolumną w przypadku atomowych danych, lub <u>poszczególnego,</u> indywidualnego elementu kolekcji
- **Czas życia** (ang. **Time-to-live** (TTL))
  - Po pewnym czasie (określonej liczbie sekund) dana kolumna lub element jest automatycznie niszczony
- **Czas modyfikacji** (ang. **Timestamp**)
  - Czas dokonania ostatniej modyfikacji
  - Przyporządkowywany automatycznie lub ręcznie
- Zarówno porcja „zwykłych danych” jak i dodatkowe mogą być przedmiotem zapytań.
  - Nie dotyczy to kolekcji i jej elementów

## Slajd 314 — Cassandra API

**CQLSH**

- **Interaktywna konsola do wydawania komend**
- bin/cqlsh
- Wykorzystuje **CQL** (*Cassandra Query Language*)

**Sterowniki klienckie:**

- Dostarczone przez społeczność
- Dostępne dla wielu różnych języków programowania np. Java, Python, Ruby, PHP, C++, Scala, Erlang, itp.

## Slajd 315 — Język zapytań

**CQL** = **Cassandra Query Language**

- Deklaratywny język zapytań
  - Zainspirowany przez SQL
- **Wyrażenia DDL**
  - CREATE KEYSPACE– stwórz nową przestrzeń kluczy
  - CREATE TABLE– stwórz nową tabelę
- **Wyrażenia DML**
  - SELECT– wybiera wiersze z pojedynczej tabeli
  - INSERT– dodaje wiersze do tabeli
  - UPDATE– aktualizuje kolumny w wierszach
  - DELETE– usuwa wiersze z tabeli

## Slajd 316 — Przestrzeń kluczy

**CREATE KEYSPACE**

> [Grafika] Diagram składni (railroad): CREATE → KEYSPACE → opcjonalnie (IF → NOT → EXISTS) → keyspace name → WITH → option name → = → option value (z możliwością powtarzania pętlą).

- **Tworzy nową przestrzeń kluczy**
- Opcja **Replication** jest obowiązkowa
  - *SimpleStrategy* (tylko jeden poziom replikacji)
  - *NetworkTopologyStrategy*

  (indywidualny poziom replikacji dla każdego centrum danych)

```sql
CREATE KEYSPACE filmydb
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 3}
```

> [Grafika] Ramka w prawym dolnym rogu z tekstem: „Przestrzeń kluczy = Baza danych”.

## Slajd 317 — Przestrzeń kluczy

**USE**

- Zmienia aktualnie używaną przestrzeń kluczy

> [Grafika] Diagram składni: USE → keyspace name.

**DROP KEYSPACE**

- Usuwa przestrzeń kluczy, wszystkie jej tabele i dane.

> [Grafika] Diagram składni: DROP → KEYSPACE → keyspace name → opcjonalnie (IF → EXISTS).

**ALTER KEYSPACE**

- Modyfikuje opcje związane z daną przestrzenią kluczy

## Slajd 318 — Tabele

**CREATE TABLE**

- **Tworzy nową tabelę** w aktualnej przestrzeni kluczy
- Każda tabela musi mieć dokładnie 1 **klucz główny** podany

> [Grafika] Diagram składni: CREATE → TABLE → opcjonalnie (IF → NOT → EXISTS) → table name → ( → column name → type → opcjonalnie (PRIMARY → KEY), powtarzane po przecinku → opcjonalnie (, → primary key) → ).

- Żadna z kolumn nie jest wymagana (poza kluczem głównym)

## Slajd 319 — Tabele

Przykłady tabel **aktorzy i filmy**

```sql
CREATE TABLE aktorzy (
   id TEXT PRIMARY KEY,
   dane TUPLE<TEXT, TEXT>,
   rok SMALLINT,
   filmy SET<TEXT>
)
```

```sql
CREATE TABLE filmy (
   id TEXT,
   tytul TEXT,
   rezyser TUPLE<TEXT, TEXT>,
   rok SMALLINT,
   aktorzy MAP<TEXT, TEXT>,
   gatunki LIST<TEXT>,
   kraje SET<TEXT>,
   wlasciwosci szczegoly,
   PRIMARY KEY (id)
)
```

## Slajd 320 — Klucze główne

> [Grafika] Ramka w prawym górnym rogu z kodem (tekst z warstwy PDF):

```sql
create table IF NOT EXISTS store.shopping_cart
( userid TEXT,
item_count INT,
last_update_timestamp TIMESTAMP,
PRIMARY KEY ((userid), last_update_timestamp)
) WITH CLUSTERING ORDER BY (last_update_timestamp DESC);
```

**Klucze główne** posiadają dwie części

- Obowiązkowy **klucz partycjonujący**
  - Przynajmniej 1 kolumna
  - Definiuje jak poszczególne wiersze są dystrybułowane na partycje
- Opcjonalne **kolumny grupujące**
  - Definiują kolejność w jakiej poszczególne wiersze są lokalnie przechowywane

**Definicja klucza głównego na poziomie kolumny**

- Dana kolumna (pojedyncza) staje się kluczem partycjonującym
- Nie ma opcjonalnych kolumn grupujących

## Slajd 321 — Klucze główne

**Definicja klucza głównego na poziomie tabeli**

- Pierwsza kolumna/wszystkie kolumny (w nawiasach klamrowych) stają się kluczem partycjonującym
- Wszystkie pozostałe kolumny (jeśli są) przyjmują rolę kolumn grupujących

> [Grafika] Diagram składni: PRIMARY → KEY → ( → (column name | ( column name, ... ) ) → opcjonalnie (, column name, powtarzane) → ).

## Slajd 322 — Tabele

**DROP TABLE**

- Usuwa tabelę wraz z danymi które zawiera

> [Grafika] Diagram składni: DROP → TABLE → table name → opcjonalnie (IF → EXISTS).

**TRUNCATE TABLE**

- Zachowuję tabelę, ale usuwa zawarte w niej dane

> [Grafika] Diagram składni: TRUNCATE → opcjonalnie TABLE → table name.

**ALTER TABLE**

- Umożliwia zmianę, dodanie bądź usunięcie kolumn tabeli

## Slajd 323 — Typy danych

**Typy** kolumn

- Natywne typy
- **Krotki**
- Kolekcje: **listy**, **zbiory**, **mapy**
- **Typy definiowane przez użytkownika**

> [Grafika] Diagram składni typu: native type | TUPLE < type (, type ...) > | LIST < type > | SET < type > | MAP < type , type > | user defined type.

## Slajd 324 — Natywne typy danych

**Natywne typy danych**

- tinyint, smallint, **int**, bigint
  - Liczby całkowite ze znakiem(1B, 2B, 4B, 8B)
- **varint**
  - Liczba całkowita o ustalonej precyzji
- **decimal**
  - Liczba rzeczywista o ustalonej precyzji
- float, **double**
  - Liczby rzeczywiste (4B, 8B)
- **boolean**
  - Wartości boolowskie: true i false

## Slajd 325 — Natywne typy danych

**Natywne typy danych**

- **text**, varchar
  - Ciąg znaków wykorzystujący kodowanie UTF8
  - Wyrażony w pojedynczych apostrofach (nie cudzysłow)
- ascii
  - Ciąg znaków wykorzystujący kodowanie ASCII
- **date**, **time**, **timestamp**
  - Data, czas i timestamp
  - Np. '2022-12-01', '2022-12-01 09:15:00', 1490923110

## Slajd 326 — Natywne typy danych

**Natywne typy danych**

- **counter**– 8B liczba całkowita (ze znakiem)
  - Wpiera tylko 2 operacje: inkrementacje i dekrementacje – tj. nie można ustawić konkretnej wartości licznika
  - Restrykcje:
    - Liczniki nie mogą być częścią klucza głównego
    - Albo wszystkie kolumny (poza kluczem głównym) są licznikami, albo żaden z nich
    - Czas życia (TTL) nie jest wspierany
- **blob**– dowolny zestaw danych (binarnych)
- **inet**– adres IP (zarówno IPv4 jak i IPv6)
- Inne: uuid

https://cassandra.apache.org/doc/latest/cassandra/developing/cql/types.html

## Slajd 327 — Krotki

**Kropki (ang. Tuples)**

- Deklaracja

> [Grafika] Diagram składni: TUPLE → < → type (powtarzane po przecinku) → >.

- Literały

> [Grafika] Diagram składni: ( → opcjonalnie term (powtarzane po przecinku) → ).

  - Np. ( 'Numer', '123-456-789' )

## Slajd 328 — Kolekcje

**Zbiory**

- Deklaracja

> [Grafika] Diagram składni: SET → < → type → >.

- Literały

> [Grafika] Diagram składni: { → opcjonalnie term (powtarzane po przecinku) → }.

  - Np. { 'Niezniszczalni', 'Rambo' }

## Slajd 329 — Kolekcje

**Listy**

- Deklaracja

> [Grafika] Diagram składni: LIST → < → type → >.

- Literały

> [Grafika] Diagram składni: [ → opcjonalnie term (powtarzane po przecinku) → ].

  - Np. [ 'komedia', 'dramat' ]

## Slajd 330 — Kolekcje

**Mapy**

- Deklaracja

> [Grafika] Diagram składni: MAP → < → type → , → type → >.

- Literały

> [Grafika] Diagram składni: { → opcjonalnie (term → : → term, powtarzane po przecinku) → }.

  - Np. { 'rezyser': 'Sylwester Stallone' }

## Slajd 331 — Typy definiowane przez użytkownika

**Typy definiowane przez użytkownika** (UDT)

- Definicja

> [Grafika] Diagram składni: CREATE → TYPE → type name → ( → field name → type (powtarzane po przecinku) → ).

  - Np. CREATE TYPE szczegoly ( dlugosc SMALLINT, adnotacja TEXT )
- Literały

> [Grafika] Diagram składni: { → opcjonalnie (field name → : → term, powtarzane po przecinku) → }.

  - Np. { dlugosc: 100 }

> [Grafika] Ramka w prawym dolnym rogu z tekstem: „Mogą być **frozen**”.

## Slajd 332 — Selekcja

Wyrażenie **SELECT**

- **Wybiera pasujące wiersze** z <u>pojedynczej</u> tabeli

> [Grafika] Diagram składni: SELECT clause → FROM clause → opcjonalnie WHERE clause → opcjonalnie GROUP BY clause → opcjonalnie ORDER BY clause → opcjonalnie LIMIT clause → opcjonalnie (ALLOW → FILTERING).

## Slajd 333 — Selekcja

**Klauzule** dozwolone w wyrażeniu SELECT:

- SELECT– kolumny lub wartości które powinny się pojawić w rezultacie
- FROM– określenie pojedynczej tabeli do której się odnosi zapytanie
- WHERE– warunki filtrowania nałożone na wiersze tabeli
- GROUP BY– kolumny użyte do grupowania wierszy
- ORDER BY– kryteria definiujące kolejność wierszy w rezultacie
- LIMIT– liczba wierszy jaka powinna być podana w rezultacie

Przykład

```sql
SELECT id, tytul, aktorzy
FROM filmy
WHERE rok = 2011 AND gatunki CONTAINS 'komedia'
```

## Slajd 334 — Selekcja

Klauzula **FROM** clause

- Definiuje **pojedynczą tabelę do której będą wysyłane zapytania**
  - Z aktualnej/wybranej przestrzeni kluczy
- Złączenie wielu tabel nie jest możliwe

> [Grafika] Diagram składni: FROM → opcjonalnie (keyspace name → .) → table name.

## Slajd 335 — Selekcja

Klauzula **WHERE**

- **Jedno lub więcej kryteriów jakie wiersz musi spełniać**

by zostać dołączony do rezultatu zapytania

> [Grafika] Diagram składni: WHERE → relation (powtarzane przez AND).

- Tylko proste warunki mogą zostać zapisane oraz **nie wszystkie relacje/kryteria** są dozwolone:
  - Tylko kolumny wchodzące w skład klucza głównego mogą zostać uwzględnione
  - Chyba, że istnieją pomocnicze struktury indeksujące
  - Problem w przypadku niektórych relacji

## Slajd 336 — Selekcja

Klauzula **WHERE** : **relacje**

> [Grafika] Diagram składni relacji: (column name | ( column name, ... )) → jedno z: (=, !=, <, <=, =>, >) term; IN ( term, ... ); CONTAINS term; CONTAINS KEY term.

## Slajd 337 — Selekcja

**Klauzula WHERE**: **relacje**

- **Porównanie**
  - =, !=, <, <=, =>, >
- **IN**
  - Zwraca true jeśli wartość zawiera się w enumerowanej strukturze
- **CONTAINS**
  - Może być używana w kolekcjach (listy, zbiory, mapy)
  - Zwraca true, gdy kolekcja zawiera danych element
- **CONTAINS KEY**
  - Może być używany tylko dla map
  - Zwraca true jeśli mapa zawiera dany klucz

## Slajd 338 — Selekcja

Klauzula **SELECT**

- Definiuje **kolumny lub wartości jakie mają być uwzględnione w rezultacie**
  - \* Oznacza wszystkie kolumny
  - Aliasy definiowane są przez AS

> [Grafika] Diagram składni: SELECT → opcjonalnie DISTINCT → (\* | selector → opcjonalnie (AS → identifier), powtarzane po przecinku).

- **DISTINCT** – powielone wiersze są usuwane

## Slajd 339 — Selekcja

▸ Klauzula **SELECT**:

> [Grafika] Diagram składni selektora: column name | term | COUNT ( \* ) | WRITETIME ( column name ) | TTL ( column name ).

- **COUNT(\*)**
  - Liczba wierszy w grupie (patrz GROUP BY)
- **WRITETIME i TTL**
  - Wybiera czas modyfikacji/ pozostały czas życia danej kolumny
  - Nie może zostać użyte na kolekcji i jej elementach
  - Nie może zostać użyte w innych klauzulach (np. WHERE)

## Slajd 340 — Selekcja

Klauzula **ORDER BY**

- Definiuje **kolejność wierszy zwróconych w rezultacie**
- <u>Tylko uporządkowania wyznaczane przez kolumny grupujące są dozwolone</u>!

> [Grafika] Diagram składni: ORDER BY → column name → opcjonalnie (ASC | DESC), powtarzane po przecinku.

Klauzula **LIMIT**

- **Ogranicza liczbę wierszy** w zwróconym rezultacie

> [Grafika] Diagram składni: LIMIT → integer.

## Slajd 341 — Selekcja

Klauzula **GROUP BY**

- **Grupuje wiersze w tabeli** na podstawie określonych kolumn
- <u>Tylko grupowania na kolumnach klucza głównego są dozwolone</u>!

> [Grafika] Diagram składni: GROUP BY → column name (powtarzane po przecinku).

- **Jeżeli w klauzule SELECT zostałaby wymieniona bezpośrednio kolumna, która nie bierze udziału w grupowaniu** (tzn. nie będąca objętą funkcją agregującą), zawsze tylko pierwsza wartość zostanie zwrócona.

## Slajd 342 — Selekcja

**Klauzula GROUP BY**: **agregacje**

- Natywne agregacje
  - **COUNT**(kolumna)
    - Liczba wszystkich wartości w danej kolumnie
    - Wartości *null* są ignorowane
  - **MIN**(kolumna), **MAX**(kolumna)
    - Minimalna / maksymalna wartość w kolumnie
  - **SUM**(kolumna)
    - Suma wszystkich wartości w danej kolumnie
  - **AVG**(kolumna)
    - Średnia arytmetyczna wszystkich wartości w danej kolumnie
- Funkcje agregacyjne definiowane przez użytkownika

## Slajd 343 — Selekcja

Modyfikator **ALLOW FILTERING**

- Domyślnie, **tylko nie-filtrujące zapytania** są dozwolone
  - Tzn. zapytania dla których **Liczba wierszy przeczytanych ~ liczba wierszy zwróconych**
  - Takie zapytania mają przewidywalną złożoność
    - Ich czas wykonania jest wprost proporcjonalny do rozmiaru danych
- ALLOW FILTERING **umożliwia częściowe filtrowanie**

## Slajd 344 — Wstawianie

Wyrażenie **INSERT**

- **Wstawia wiersz** do danej tabeli
  - Gdy wiersz o podanym kluczu głównym już istnieje, jest on aktualizowany
- Przynajmniej wartości dla kolumn klucza głównego muszą być określone
- Nazwy kolumn muszą być zawsze podane jawnie

> [Grafika] Diagram składni: INSERT → INTO → opcjonalnie (keyspace name → .) → table name → ( → column name (powtarzane po przecinku) → ) → VALUES → ( → term (powtarzane po przecinku) → ) → opcjonalnie (IF → NOT → EXISTS) → opcjonalnie (USING → update parameters).

## Slajd 345 — Wstawianie

Przykład

```sql
INSERT INTO filmy (id, tytul, rezyser, rok, aktorzy, gatunki)  VALUES (
    'zielonamila',
    'Zielona Mila',
    ('frank', 'Darabont'),
    1999,
    { 'hanks': 'Tom', 'morse': 'David' },
    [ 'komedia', 'dramat' ]
)
USING TTL 86400
```

## Slajd 346 — Aktualizacja

Wyrażenie **UPDATE**

- **Aktualizuje wiersze** w danej tabeli
  - Jeżeli wiersze o podanym kluczu jeszcze nie istnieje, zostanie on dodany
- Co najmniej wszystkie kolumny wchodzące w skład klucza głównego muszą być podane w klauzule WHERE

> [Grafika] Diagram składni: UPDATE → opcjonalnie (keyspace name → .) → table name → opcjonalnie (USING → update parameters) → SET → assignment (powtarzane po przecinku) → WHERE clause.

## Slajd 347 — Aktualizacja

Wyrażenie **UPDATE**: **przypisania**

- Określają modyfikacje jakie są dozwolone
- Dozwolone przypisania:
  - Wartość całej kolumny jest zmieniana
  - Wartość elementu mapy lub listy jest zmieniana
    - Elementy listy są numerowane od 0
  - Wartość kolumny zawierającej typ definiowany przez użytkownika jest zmieniana

> [Grafika] Diagram składni przypisania: (column name | column name [ term ] | column name . field name) → = → term.

## Slajd 348 — Aktualizacja

Przykład

```sql
UPDATE filmy
SET
   rok = 2010,
   rezyser = ('Sylwester', 'Stallone'),
   aktorzy = { 'stallone': 'Barney Ross', 'schwarzenegger': 'Trench' },
   gatunki = [ 'akcja' ],
   kraje = { 'USA' }
WHERE id = 'niezniszczalni'
```

```sql
UPDATE filmy
SET
   aktorzy['norris'] = 'Chuck',
   gatunki[1] = 'komedia',
   wlasciwosci.dlugosc = 99
WHERE id = 'niezniszczalni'
```

## Slajd 349 — Aktualizacja

Przykład: modyfikacja elementów kolekcji

```sql
UPDATE filmy
SET
   aktorzy = aktorzy + { 'itie': 'Giselle' },
   gatunki = [ 'dramat' ] + gatunki,
   kraje = kraje + { 'BR' }
WHERE id = 'niezniszczalni'
```

```sql
UPDATE filmy
SET
   aktorzy = aktorzy - { 'vicander', 'west' },
   gatunki = gatunki - [ 'dramat', 'sci-fi' ],
   kraje = kraje - { 'DE' }
WHERE id = 'tombraider'
```

## Slajd 350 — Wstawianie i aktualizacja

**Parametry UPDATE**

- **TTL**: czas życia
  - 0, null lub pusty dla trwałych wartości
- **TIMESTAMP**: czas zapisu

> [Grafika] Diagram składni: (TIMESTAMP integer | TTL) połączone przez AND, powtarzane.

- Ma to wpływ tylko na nowo - dodane / aktualizowane wartości

## Slajd 351 — Usuwanie

Wyrażenie **DELETE**

- **Usuwa pasujące wiersze** /

  Zachowuje wiersze, ale **usuwa wybrane kolumny** /

  Zachowuje kolumny, ale **usuwa elementy kolekcji**

  lub **pola z wartościami definiowanymi przez użytkownika**

> [Grafika] Diagram składni: DELETE → opcjonalnie (column name | column name [ term ] | column name . field name, powtarzane po przecinku) → FROM clause → WHERE clause.

## Slajd 352 — (pusty slajd)

> [Grafika] Pusty slajd, tylko czarna ramka, bez treści.
