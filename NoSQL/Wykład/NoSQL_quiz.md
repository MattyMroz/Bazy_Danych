# Bazy New/NoSQL — quiz ABCD przed testem

Pytania pokrywają cały wykład (działy 1–8 w kolejności slajdów) oraz laboratoria 1–3 (dział 9). Każde pytanie ma jedną poprawną odpowiedź. Rozwiń „Odpowiedź”, żeby zobaczyć literę, wyjaśnienie i numer slajdu albo zadania z labu. Jeśli slajd zawiera błąd, odpowiedź trzyma się wersji z wykładu, a w wyjaśnieniu jest uwaga.

## Spis działów

1. Big Data i bazy NoSQL — wprowadzenie (113 pytań)
2. MongoDB — instalacja, cechy i modelowanie danych (97 pytań)
3. MongoDB — CRUD, operatory zapytań, projekcja i modyfikatory kursora (143 pytania)
4. MongoDB — walidacja schematu, Aggregation Framework, import i indeksy (120 pytań)
5. MongoDB — replikacja, sharding i kolekcje Time Series (80 pytań)
6. Bazy klucz–wartość i Redis (138 pytań)
7. Bazy grafowe — Neo4j i SQL Server Graph (76 pytań)
8. Bazy rodziny kolumn — Apache Cassandra i CQL (140 pytań)
9. Laboratoria 1–3, MongoDB w praktyce (244 pytania)

Razem: 1151 pytań.



## 1. Big Data i bazy NoSQL — wprowadzenie

### Big Data i cztery V

**1.1. Które cztery cechy opisują Big Data według wykładu?**

- A) Volume, Variety, Velocity, Value
- B) Volume, Variety, Velocity, Veracity
- C) Volume, Validity, Velocity, Visualization
- D) Volume, Variety, Visibility, Veracity

<details><summary>Odpowiedź</summary>

**B** — Wykład podaje wzór Big Data = Volume + Variety + Velocity + Veracity. Value pojawia się w niektórych źródłach jako piąte V, ale nie na tym slajdzie. (slajd 2)

</details>

**1.2. Które zdanie o cesze Volume jest zgodne ze slajdem?**

- A) Ilość danych rośnie liniowo, ale w dużych skokach
- B) Big Data to wyłącznie pojedyncze zbiory o rozmiarze petabajtów
- C) Ilość danych rośnie potęgowo, a duża liczba małych zbiorów też może być Big Data
- D) Volume oznacza szybkość napływu danych do systemu

<details><summary>Odpowiedź</summary>

**C** — Slajd mówi o wzroście potęgowym, nie liniowym, i dodaje, że wiele małych zbiorów też może być Big Data. Szybkość napływu to Velocity. (slajd 2)

</details>

**1.3. Która cecha Big Data dotyczy niepewności danych wynikającej z braków, niespójności i aproksymacji?**

- A) Veracity
- B) Variety
- C) Velocity
- D) Volume

<details><summary>Odpowiedź</summary>

**A** — Veracity (na slajdzie „niepewność”) wynika z braków, niespójności i przybliżeń. Variety to różnorodność formatów. (slajd 2)

</details>

**1.4. Która cecha Big Data mówi, że dane napływają bardzo szybko i z taką samą szybkością muszą być przetwarzane, np. strumieniowo?**

- A) Variety
- B) Veracity
- C) Volume
- D) Velocity

<details><summary>Odpowiedź</summary>

**D** — Velocity to szybkość napływu i przetwarzania danych. (slajd 2)

</details>

### Projektowanie dużych systemów

**1.5. Które cztery aspekty slajd wymienia jako najważniejsze przy projektowaniu dużych systemów baz danych?**

- A) Normalizacja, indeksy, transakcje, kopie zapasowe
- B) Skalowalność, koszt, elastyczność, dostępność
- C) Spójność, izolacja, trwałość, atomowość
- D) Szybkość, bezpieczeństwo, prywatność, audyt

<details><summary>Odpowiedź</summary>

**B** — Slajd wymienia skalowalność, koszt, elastyczność i dostępność. Odpowiedź C to cechy ACID. (slajd 3)

</details>

**1.6. Dzięki czemu, według slajdu, bazy NoSQL zapewniają wysoką dostępność?**

- A) Dzięki brakowi sztywnych schematów
- B) Dzięki różnorodnym modelom danych
- C) Dzięki replikacji i partycjonowaniu
- D) Dzięki transakcjom ACID

<details><summary>Odpowiedź</summary>

**C** — Wysoką dostępność slajd wiąże z replikacją i partycjonowaniem. Brak schematów daje niższe koszty, a różnorodne modele większą elastyczność. (slajd 3)

</details>

**1.7. Jakie stanowisko wobec baz relacyjnych zajmuje wykład?**

- A) Należy je całkowicie zastąpić bazami NoSQL w nowych projektach
- B) Są przestarzałe i stosuje się je tylko w administracji
- C) Nadają się wyłącznie do przetwarzania OLAP
- D) Nie należy bezrefleksyjnie od nich odchodzić, a wybór technologii zależy od danych, wymagań i zadania

<details><summary>Odpowiedź</summary>

**D** — Slajd wprost ostrzega przed bezrefleksyjnym porzucaniem baz relacyjnych i każe dobierać technologię do zadania. (slajd 3, slajd 40)

</details>

### Bazy relacyjne

**1.8. Jaka jest hierarchia organizacji danych w modelu relacyjnym według slajdu?**

- A) Instancja → baza → tabela → wiersz
- B) Baza → instancja → wiersz → tabela
- C) Klaster → keyspace → tabela → wiersz
- D) Baza → kolekcja → dokument → pole

<details><summary>Odpowiedź</summary>

**A** — Slajd podaje łańcuch instancja → baza → tabela → wiersz. Odpowiedź C opisuje Cassandrę, a D MongoDB. (slajd 4)

</details>

**1.9. Który język jest formalnym językiem zapytań modelu relacyjnego?**

- A) SQL
- B) Algebra relacyjna
- C) CQL
- D) XQuery

<details><summary>Odpowiedź</summary>

**B** — Slajd rozróżnia język rzeczywisty (SQL) i formalny (algebra relacyjna). (slajd 4)

</details>

**1.10. Tabela `klienci` zawiera: Jan Kowalski (Warszawa), Anna Nowak (Kraków), Piotr Wiśniewski (Warszawa), Ewa Wójcik (Gdańsk). Co zwróci zapytanie?**

```sql
SELECT imie, nazwisko FROM klienci WHERE miasto = 'Warszawa';
```

- A) Jeden wiersz: Jan Kowalski
- B) Dwa wiersze z kolumnami id, imie, nazwisko, miasto
- C) Dwa wiersze: Jan Kowalski i Piotr Wiśniewski, z kolumnami imie i nazwisko
- D) Trzy wiersze: wszystkich klientów poza Ewą Wójcik

<details><summary>Odpowiedź</summary>

**C** — W Warszawie mieszkają Jan i Piotr, a SELECT wybiera tylko kolumny imie i nazwisko. (slajd 4)

</details>

**1.11. Która grupa zawiera wyłącznie komercyjne systemy relacyjne klasy enterprise wymienione na slajdzie?**

- A) MySQL, PostgreSQL, MariaDB
- B) Oracle Database, MySQL, SQLite
- C) PostgreSQL, SQL Server, DB2
- D) Oracle Database, SQL Server, IBM DB2

<details><summary>Odpowiedź</summary>

**D** — Slajd dzieli systemy na komercyjne (Oracle, SQL Server, DB2) oraz otwarte (MySQL, PostgreSQL, MariaDB). (slajd 4)

</details>

**1.12. Która operacja w zapytaniach relacyjnych łączy dane z wielu tabel?**

- A) Złączenie (JOIN)
- B) Selekcja
- C) Agregacja
- D) Podzapytanie

<details><summary>Odpowiedź</summary>

**A** — Złączenia łączą dane z wielu tabel. Selekcja wybiera dane wg kryteriów, agregacja liczy SUM, COUNT, AVG. (slajd 4)

</details>

### Zmiana charakteru danych

**1.13. Do jakiej kategorii danych slajd zalicza XML i JSON?**

- A) Strukturalnych
- B) Niestrukturalnych
- C) Półstrukturalnych
- D) Binarnych

<details><summary>Odpowiedź</summary>

**C** — XML i JSON to dane półstrukturalne. Strukturalne to tabele, a niestrukturalne to tekst, obrazy, wideo i audio. (slajd 5)

</details>

**1.14. Jaką zmianę w sposobie przetwarzania danych opisuje slajd „Obecnie”?**

- A) Przejście od przetwarzania strumieniowego do wsadowego
- B) Przejście od przetwarzania wsadowego do strumieniowego (w czasie rzeczywistym)
- C) Przejście od przetwarzania rozproszonego do scentralizowanego
- D) Przejście od OLAP do OLTP

<details><summary>Odpowiedź</summary>

**B** — Slajd pokazuje kierunek: przetwarzanie wsadowe → strumieniowe. (slajd 5)

</details>

**1.15. Które zdanie o współczesnych danych jest zgodne ze slajdem?**

- A) Operacje zapisu są ważniejsze i częstsze niż operacje odczytu
- B) Aktualizacje są częste i przychodzą w przewidywalnych odstępach
- C) Ścisła spójność jest dziś ważniejsza niż kiedykolwiek
- D) Operacje odczytu stają się ważniejsze i częstsze niż operacje zapisu

<details><summary>Odpowiedź</summary>

**D** — Wielu użytkowników czyta dane równocześnie, więc odczyty dominują. Aktualizacje są nieregularne, a ścisła spójność ustępuje szybkości. (slajd 9)

</details>

**1.16. Co według slajdu coraz częściej zastępuje ścisłą spójność danych?**

- A) Spójność ostateczna (eventual consistency) w zamian za wydajność i skalowalność
- B) Pełna izolacja transakcji
- C) Normalizacja do trzeciej postaci normalnej
- D) Blokady dwufazowe

<details><summary>Odpowiedź</summary>

**A** — Slajd mówi, że akceptuje się eventual consistency w zamian za wydajność i skalowalność. (slajd 9)

</details>

### Nowe podejście do Big Data

**1.17. Który powód NIE jest wymieniony na slajdzie jako przyczyna, dla której tradycyjne bazy relacyjne nie wystarczają?**

- A) Problemy ze skalowaniem dla ogromnych zbiorów danych
- B) Ograniczona obsługa danych nieustrukturalizowanych
- C) Brak obsługi języka SQL
- D) Nieefektywność przy przetwarzaniu w czasie rzeczywistym

<details><summary>Odpowiedź</summary>

**C** — Slajd wymienia skalowanie, dane nieustrukturalizowane, wysokie koszty i czas rzeczywisty. Bazy relacyjne oczywiście obsługują SQL. (slajd 6)

</details>

**1.18. Który system jest na slajdzie przykładem rozproszonego systemu plików?**

- A) HDFS
- B) Snowflake
- C) Spark MLlib
- D) Redis

<details><summary>Odpowiedź</summary>

**A** — HDFS (Hadoop Distributed File System) to przykład rozproszonego systemu plików. Snowflake to hurtownia danych, Spark MLlib to uczenie maszynowe. (slajd 6)

</details>

**1.19. Które systemy slajd podaje jako przykłady hurtowni danych?**

- A) MongoDB, Cassandra, Redis
- B) TensorFlow, Spark MLlib
- C) Amazon Redshift, Google BigQuery, Snowflake
- D) AWS, Azure, Google Cloud

<details><summary>Odpowiedź</summary>

**C** — Hurtownie danych to Redshift, BigQuery i Snowflake. A to bazy NoSQL, B uczenie maszynowe, D chmura. (slajd 6)

</details>

**1.20. Jakie dwa główne powody zainteresowania bazami NoSQL podaje wykład?**

- A) Transakcje ACID i język SQL
- B) Produktywność tworzenia aplikacji i obsługa dużych wolumenów danych
- C) Niższa cena licencji i lepsza dokumentacja
- D) Silna spójność i normalizacja danych

<details><summary>Odpowiedź</summary>

**B** — Slajdy wymieniają produktywność tworzenia aplikacji oraz duże wolumeny danych przetwarzane w klastrach. (slajdy 6–7)

</details>

**1.21. Dlaczego, według slajdu, bazy NoSQL lepiej radzą sobie z dużymi wolumenami danych?**

- A) Bo są projektowane do pracy w klastrach wielu mniejszych, tańszych maszyn
- B) Bo wymagają jednego bardzo mocnego serwera
- C) Bo kompresują dane do formatu XML
- D) Bo nie przechowują danych na dysku

<details><summary>Odpowiedź</summary>

**A** — NoSQL projektuje się do pracy w klastrach i uruchamia na wielu mniejszych maszynach, co jest tańsze niż jedna duża maszyna. (slajdy 6–7)

</details>

**1.22. Na slajdzie Hadoop wymieniono jako przykład bazy NoSQL. Która uwaga jest poprawna?**

- A) Hadoop to baza grafowa
- B) Hadoop to baza dokumentowa konkurująca z MongoDB
- C) Hadoop to język zapytań dla HBase
- D) Hadoop to platforma rozproszonego składowania i przetwarzania (HDFS, MapReduce), a bazą NoSQL z jego ekosystemu jest HBase

<details><summary>Odpowiedź</summary>

**D** — Ściśle biorąc Hadoop nie jest bazą danych. Slajd 6 wymienia go wśród baz NoSQL, ale slajd 8 poprawnie opisuje HBase jako bazę kolumnową z ekosystemu Hadoop. (slajdy 6, 8)

</details>

**1.23. Które firmy slajd „Dlaczego NoSQL?” podaje jako używające NoSQL do terabajtów danych dziennie?**

- A) Oracle, IBM, Microsoft, SAP
- B) Google, Facebook, LinkedIn, Twitter
- C) Amazon, Netflix, Uber, Spotify
- D) Apple, Samsung, Intel, AMD

<details><summary>Odpowiedź</summary>

**B** — Slajd wymienia Google, Facebook, LinkedIn i Twitter. (slajd 10)

</details>

### Chmura i sposoby przetwarzania danych

**1.24. Który model chmury oznacza gotowe aplikacje dostępne przez Internet, np. Google Workspace i Salesforce?**

- A) IaaS
- B) PaaS
- C) DBaaS
- D) SaaS

<details><summary>Odpowiedź</summary>

**D** — SaaS (Software as a Service) to gotowe aplikacje. PaaS to platforma, IaaS infrastruktura. (slajd 8)

</details>

**1.25. Który model chmury dostarcza platformę do tworzenia i uruchamiania aplikacji, np. Heroku?**

- A) PaaS
- B) SaaS
- C) IaaS
- D) FaaS

<details><summary>Odpowiedź</summary>

**A** — PaaS (Platform as a Service), przykłady na slajdzie to Microsoft Azure i Heroku. (slajd 8)

</details>

**1.26. Co dostarcza model IaaS?**

- A) Gotowe aplikacje biurowe
- B) Infrastrukturę: serwery, sieci, storage (np. AWS, Google Cloud)
- C) Wyłącznie bazy danych NoSQL
- D) Środowisko uruchomieniowe bez dostępu do serwerów

<details><summary>Odpowiedź</summary>

**B** — IaaS (Infrastructure as a Service) to serwery, sieci i przestrzeń dyskowa. (slajd 8)

</details>

**1.27. Który typ przetwarzania służy do obsługi bieżących transakcji, z szybkimi zapisami i odczytami, np. w bankach i sklepach internetowych?**

- A) OLAP
- B) RTAP
- C) OLTP
- D) ETL

<details><summary>Odpowiedź</summary>

**C** — OLTP to Online Transaction Processing. OLAP służy do analizy danych historycznych, RTAP do analizy w czasie rzeczywistym. (slajd 8)

</details>

**1.28. Co oznacza skrót RTAP i do czego służy?**

- A) Real-Time Analytical Processing – analiza danych w czasie rzeczywistym, np. monitoring, rekomendacje, IoT
- B) Relational Transaction Access Protocol – protokół transakcji w RDBMS
- C) Remote Table Access Processing – zdalny dostęp do tabel
- D) Real-Time Archive Processing – archiwizacja danych historycznych

<details><summary>Odpowiedź</summary>

**A** — RTAP to Real-Time Analytical Processing z natychmiastowymi wynikami. (slajd 8)

</details>

**1.29. Który opis pasuje do OLAP?**

- A) Szybkie operacje zapisu pojedynczych transakcji
- B) Analiza danych historycznych, złożone zapytania i agregacje wspierające decyzje
- C) Przechowywanie sesji użytkowników w pamięci RAM
- D) Replikacja danych między węzłami klastra

<details><summary>Odpowiedź</summary>

**B** — OLAP (Online Analytical Processing) to analiza historyczna i agregacje. (slajd 8)

</details>

**1.30. Która cecha jest przypisana na slajdzie bazom relacyjnym (RDBMS), a nie bazom NoSQL?**

- A) Brak sztywnego schematu
- B) Stworzone głównie na potrzeby aplikacji webowych XXI w.
- C) Dobrze działają w klastrach
- D) Sztywny schemat i dobra sprawdzalność w transakcjach (OLTP)

<details><summary>Odpowiedź</summary>

**D** — RDBMS mają sztywny schemat, zapewniają spójność i kontrolę współbieżności i dobrze sprawdzają się w OLTP. Pozostałe cechy slajd przypisuje NoSQL. (slajd 8)

</details>

**1.31. Które przyporządkowanie bazy do typu jest poprawne według slajdu „Popularne bazy NoSQL”?**

- A) Cassandra – dokumentowa, CouchDB – kolumnowa
- B) Redis – grafowa, Neo4j – klucz–wartość
- C) CouchDB – dokumentowa, HBase – kolumnowa
- D) MongoDB – kolumnowa, HBase – dokumentowa

<details><summary>Odpowiedź</summary>

**C** — CouchDB i MongoDB są dokumentowe, Cassandra i HBase kolumnowe, Redis klucz–wartość, Neo4j grafowa. (slajd 8)

</details>

**1.32. Co na schemacie „SQL vs NoSQL” umieszczono po stronie SQL obok systemów RDBMS?**

- A) Kostkę OLAP (Online Analytical Processing Cube)
- B) Model Key-Value
- C) Model Column store
- D) Model Graph

<details><summary>Odpowiedź</summary>

**A** — Po stronie SQL są RDBMS i kostka OLAP. Key-Value, Graph, Document i Column store są po stronie NoSQL. (slajd 15)

</details>

### Termin NoSQL i jego historia

**1.33. Jak należy rozumieć termin NoSQL według wykładu?**

- A) „No to SQL”, czyli całkowite odrzucenie SQL
- B) Baza bez żadnego języka zapytań
- C) Nie „no to SQL”; termin nie ma precyzyjnej definicji, a często rozwija się go jako „Not only SQL”
- D) Formalny standard ISO dla baz nierelacyjnych

<details><summary>Odpowiedź</summary>

**C** — Slajd mówi wprost „NIE: no to SQL” i że NoSQL nie ma precyzyjnej definicji. Ramka podsuwa „Not only SQL”. (slajdy 11, 14)

</details>

**1.34. Co pokazano w 1998 roku według slajdów o historii terminu NoSQL?**

- A) Pierwszą wersję MongoDB
- B) Relacyjną bazę danych niewykorzystującą języka SQL (baza Strozzi)
- C) Pierwszą bazę grafową Neo4j
- D) Spotkanie w San Francisco z udziałem Cassandry i HBase

<details><summary>Odpowiedź</summary>

**B** — W 1998 r. pokazano relacyjną bazę bez SQL, czyli bazę Strozzi. Nie miała ona wpływu na późniejszy ruch NoSQL. (slajdy 11, 12)

</details>

**1.35. Kiedy i gdzie odbyło się spotkanie, od którego liczy się współczesny ruch NoSQL?**

- A) 11 czerwca 2009, San Francisco
- B) 11 czerwca 1998, Seattle
- C) 1 stycznia 2009, Londyn
- D) 11 września 2010, Nowy Jork

<details><summary>Odpowiedź</summary>

**A** — Spotkanie odbyło się 11 czerwca 2009 r. w San Francisco. (slajd 12)

</details>

**1.36. Z czyjej inicjatywy odbyło się spotkanie z 2009 roku, na którym użyto terminu NoSQL?**

- A) Erica Evansa
- B) Carla Strozziego
- C) Erica Brewera
- D) Johana Oskarssona

<details><summary>Odpowiedź</summary>

**D** — Inicjatorem był Johan Oskarsson. Eric Evans zatwierdził nazwę, Strozzi stworzył bazę z 1998 r., Brewer to autor twierdzenia CAP. (slajd 12)

</details>

**1.37. Dlaczego wybrano nazwę „NoSQL” dla spotkania z 2009 roku?**

- A) Bo była skrótem nazwy firmy organizatora
- B) Bo była dobrym hashtagiem na Twitterze; zaproponowano ją na IRC #cassandra, a zatwierdził Eric Evans
- C) Bo tak nazywała się pierwsza prezentowana baza
- D) Bo wymagał tego standard ANSI

<details><summary>Odpowiedź</summary>

**B** — Nazwa miała być dobrym hashtagiem; padła na kanale IRC #cassandra i zatwierdził ją Eric Evans. (slajd 12)

</details>

**1.38. Która baza NIE była na liście systemów prezentowanych na spotkaniu NoSQL w 2009 roku według slajdu?**

- A) Voldemort
- B) Hypertable
- C) Neo4j
- D) Dynomite

<details><summary>Odpowiedź</summary>

**C** — Slajd wymienia Voldemort, Cassandrę, Dynomite, HBase, Hypertable, CouchDB i MongoDB. Neo4j nie ma na tej liście. (slajd 12)

</details>

**1.39. Które zdanie o NoSQL jest zgodne ze slajdem „NoSQL – czym jest i dlaczego używać?”**

- A) NoSQL to raczej ruch niż konkretna technologia
- B) NoSQL to jeden produkt firmy Oracle
- C) NoSQL to specyfikacja języka zapytań
- D) NoSQL to wyłącznie komercyjne bazy danych

<details><summary>Odpowiedź</summary>

**A** — Slajd mówi, że NoSQL to raczej ruch niż konkretna technologia, obejmujący nowoczesne, najczęściej open source bazy. (slajd 13)

</details>

### Najważniejsze kwestie i cechy NoSQL

**1.40. Czym jest impedancja obiektowo-relacyjna?**

- A) Opóźnieniem sieci między serwerem aplikacji a bazą
- B) Różnicą wydajności między odczytem a zapisem
- C) Konfliktem replik w bazach NoSQL
- D) Różnicą między strukturą obiektów w aplikacji a tabelami w bazie relacyjnej

<details><summary>Odpowiedź</summary>

**D** — To trudność dopasowania struktur danych w pamięci programu do tabel bazy relacyjnej. (slajd 14)

</details>

**1.41. Jaką zmianę w podejściu do integracji systemów opisuje slajd?**

- A) Przejście od integracji przez API do integracji przez wspólną bazę
- B) Przejście od integracji przez bazy danych do enkapsulacji w aplikacjach i integracji przez usługi sieciowe (API)
- C) Rezygnację z integracji systemów
- D) Integrację wyłącznie przez pliki CSV

<details><summary>Odpowiedź</summary>

**B** — Slajd mówi o przejściu od integracji baz do enkapsulacji w aplikacjach i integracji przez usługi sieciowe, np. API. (slajd 14)

</details>

**1.42. Które cztery cechy definiują bazy NoSQL jako nową generację baz według slajdu (źródło hostingdata.co.uk)?**

- A) Relacyjne, scentralizowane, komercyjne, skalowalne pionowo
- B) Obiektowe, transakcyjne, zamknięte, replikowane
- C) Nierelacyjne, rozproszone, otwarte, horyzontalnie skalowalne
- D) Nierelacyjne, jednowęzłowe, otwarte, skalowalne pionowo

<details><summary>Odpowiedź</summary>

**C** — Non-relational, distributed, open-source, horizontally scalable. (slajd 16)

</details>

**1.43. Która cecha NIE należy do cech charakterystycznych NoSQL wymienionych na slajdzie?**

- A) Schema-free
- B) Proste API
- C) Spójność ewentualna (eventually consistent)
- D) Pełna obsługa złączeń JOIN

<details><summary>Odpowiedź</summary>

**D** — Slajd wymienia schema-free, łatwą replikację, proste API, eventual consistency i duże zbiory danych. Złączenia to domena baz relacyjnych. (slajd 16)

</details>

**1.44. Jak slajd ocenia możliwość przechowywania danych bez schematu w bazach NoSQL?**

- A) Wyłącznie jako zaletę
- B) Jako zaletę i wadę: większa elastyczność, ale ryzyko „zabałaganienia” danych
- C) Wyłącznie jako wadę
- D) Jako cechę bez wpływu na aplikacje

<details><summary>Odpowiedź</summary>

**B** — Brak schematu może być zarówno zaletą, jak i wadą, bo grozi bałaganem w danych, który wpływa też na aplikacje. (slajd 17)

</details>

**1.45. W którym przypadku slajd wskazuje, że NIE można zrezygnować ze spójności danych?**

- A) Liczniki polubień w serwisie społecznościowym
- B) Cache stron internetowych
- C) Konta bankowe, dane finansowe i ubezpieczeniowe
- D) Logi serwera

<details><summary>Odpowiedź</summary>

**C** — Slajd podaje konta bankowe, dane finansowe i ubezpieczeniowe jako przypadki, w których spójność jest konieczna. (slajd 17)

</details>

**1.46. Jak slajd ocenia twierdzenie, że bazy NoSQL są prostsze w programowaniu?**

- A) Jako ocenę subiektywną
- B) Jako udowodniony fakt
- C) Jako fałsz
- D) Jako prawdę tylko dla baz grafowych

<details><summary>Odpowiedź</summary>

**A** — Slajd mówi, że NoSQL są łatwiejsze w skalowaniu, a ich prostota programowania to ocena subiektywna. (slajd 17)

</details>

**1.47. Która kategoria NIE występuje na liście systemów NoSQL według hostingdata.co.uk?**

- A) Wide Column Store / Column Families
- B) Event Sourcing
- C) Multivalue Database Management Systems
- D) Relational Database Management Systems

<details><summary>Odpowiedź</summary>

**D** — Lista obejmuje m.in. Wide Column, Document, Key Value, Graph, Multimodel, Object, XML, Multidimensional, Multivalue, Event Sourcing i Time Series. Bazy relacyjne nie są kategorią NoSQL. (slajd 18)

</details>

### Bazy klucz–wartość i Redis

**1.48. Do czego slajd porównuje model bazy klucz–wartość?**

- A) Do drzewa XML
- B) Do tablicy asocjacyjnej (słownika)
- C) Do kostki OLAP
- D) Do grafu skierowanego

<details><summary>Odpowiedź</summary>

**B** — Baza klucz–wartość to najprostszy model NoSQL, analogiczny do tablicy asocjacyjnej, czyli słownika. (slajd 19)

</details>

**1.49. Jakie jest typowe ograniczenie baz klucz–wartość?**

- A) Wysoka latencja odczytu po kluczu
- B) Trudne skalowanie poziome
- C) Zazwyczaj brak zaawansowanych zapytań, np. wyszukiwania po wartościach
- D) Brak możliwości usuwania wartości

<details><summary>Odpowiedź</summary>

**C** — Bazy klucz–wartość są szybkie i łatwo się skalują, ale zwykle nie pozwalają szukać po wartościach i słabo radzą sobie ze złożoną strukturą. (slajd 19)

</details>

**1.50. Które zastosowanie slajd wskazuje jako dobre dla bazy klucz–wartość?**

- A) Dane sesyjne i cache aplikacyjny
- B) Zapytania wymagające złączeń JOIN
- C) Filtrowanie rekordów po wielu polach
- D) Złożone relacje między encjami

<details><summary>Odpowiedź</summary>

**A** — Dane sesyjne, cache, ustawienia, koszyki, liczniki i tokeny to przypadki użycia. Pozostałe odpowiedzi slajd wymienia w „Kiedy nie używać”. (slajd 20)

</details>

**1.51. Która baza prowadzi w rankingu DB-Engines baz klucz–wartość (październik 2025)?**

- A) Memcached
- B) Amazon DynamoDB
- C) Aerospike
- D) Redis

<details><summary>Odpowiedź</summary>

**D** — Redis jest na górze wykresu, pod nim DynamoDB, potem Azure Cosmos DB i Memcached. (slajd 21)

</details>

**1.52. Co oznacza nazwa Redis?**

- A) REmote DIctionary Server
- B) RElational DIstributed System
- C) REplicated Data Index Store
- D) Real-time Embedded Database In Storage

<details><summary>Odpowiedź</summary>

**A** — Redis to REmote DIctionary Server, czyli zdalny serwer słownika. (slajd 22)

</details>

**1.53. Jakie mechanizmy zapewniają w Redisie opcjonalny trwały zapis danych na dysk?**

- A) WAL i MVCC
- B) BSON i GridFS
- C) RDB i AOF
- D) HDFS i MapReduce

<details><summary>Odpowiedź</summary>

**C** — Redis trzyma dane w RAM, a na dysk zapisuje je opcjonalnie przez RDB (migawki) i AOF (dziennik operacji). (slajd 22)

</details>

**1.54. Które polecenie Redisa zwróci wartość zapisaną wcześniej poleceniem `SET uzytkownik:1 "Jan"`?**

- A) `HGETALL uzytkownik:1`
- B) `GET uzytkownik:1`
- C) `SMEMBERS uzytkownik:1`
- D) `LRANGE uzytkownik:1 0 -1`

<details><summary>Odpowiedź</summary>

**B** — Wartość typu string odczytuje GET. HGETALL służy do hashy, SMEMBERS do zbiorów, LRANGE do list. (slajd 22)

</details>

**1.55. Co zwróci polecenie `LRANGE kolejka 0 -1` w Redisie?**

- A) Pierwszy element listy
- B) Ostatni element listy
- C) Liczbę elementów listy
- D) Wszystkie elementy listy, od pierwszego do ostatniego

<details><summary>Odpowiedź</summary>

**D** — Indeks 0 to pierwszy element, a -1 to ostatni, więc zakres obejmuje całą listę. (slajd 22)

</details>

**1.56. Na slajdzie zapisano `LPUSH kolejka 0 "zadanie1" "zadanie2"`. Które polecenie poprawnie wstawia dwa zadania na początek listy?**

- A) `LPUSH kolejka "zadanie1" "zadanie2"`
- B) `SADD kolejka "zadanie1" "zadanie2"`
- C) `HSET kolejka "zadanie1" "zadanie2"`
- D) `LPUSH 0 kolejka "zadanie1" "zadanie2"`

<details><summary>Odpowiedź</summary>

**A** — LPUSH przyjmuje klucz i same elementy. Zero ze slajdu zostałoby wstawione jako zwykły element. SADD dodaje do zbioru, HSET do hasha. (slajd 22)

</details>

**1.57. Którą strukturę danych Redisa slajd wskazuje do budowy rankingów?**

- A) HyperLogLog
- B) Bitmap
- C) Sorted Set
- D) Stream

<details><summary>Odpowiedź</summary>

**C** — Sorted Set służy do rankingów. HyperLogLog liczy unikalnych gości, Bitmap przechowuje flagi, Stream strumienie zdarzeń. (slajd 22)

</details>

**1.58. Które polecenie Redisa zapisuje obiekt z wieloma polami pod jednym kluczem w strukturze hash?**

- A) `SADD osoba:1 imie "Anna" nazwisko "Nowak"`
- B) `HSET osoba:1 imie "Anna" nazwisko "Nowak" wiek 28`
- C) `SET osoba:1 imie "Anna"`
- D) `LPUSH osoba:1 imie "Anna"`

<details><summary>Odpowiedź</summary>

**B** — HSET zapisuje pary pole–wartość w hashu, a HGETALL je odczytuje. (slajd 22)

</details>

**1.59. Które zdanie jest ograniczeniem Redisa według slajdu?**

- A) Brak obsługi replikacji
- B) Dostęp do danych trwa sekundy
- C) Obsługuje tylko typ String
- D) Brak języka zapytań podobnego do SQL i większe koszty przy dużych zbiorach, bo dane są głównie w RAM

<details><summary>Odpowiedź</summary>

**D** — Slajd wymienia koszty RAM, ograniczone zapytania, ryzyko utraty danych przy złej konfiguracji i to, że Redis nie zastępuje bazy relacyjnej. Replikację Redis ma, a dostęp trwa mikrosekundy. (slajd 22)

</details>

### Bazy dokumentowe i MongoDB

**1.60. Które zdanie o bazach dokumentowych jest zgodne ze slajdem?**

- A) Wszystkie dokumenty w kolekcji muszą mieć identyczną strukturę
- B) Dokumenty to najczęściej JSON, są organizowane w kolekcje i mogą mieć różną strukturę
- C) Dokumenty można wyszukiwać wyłącznie po kluczu
- D) Bazy dokumentowe nie obsługują danych zagnieżdżonych

<details><summary>Odpowiedź</summary>

**B** — Dokumenty (zwykle JSON, rzadziej XML) tworzą kolekcje, mogą być zagnieżdżone i mieć różną strukturę, a wyszukiwać można wg dowolnych kryteriów. (slajd 23)

</details>

**1.61. Które zastosowania slajd podaje dla baz dokumentowych w punkcie „Kiedy używać?”**

- A) Logowanie zdarzeń, blogi, systemy CMS
- B) Najkrótsza ścieżka w sieci dróg
- C) Transakcje bankowe obejmujące wiele kont
- D) Przechowywanie tylko liczników polubień

<details><summary>Odpowiedź</summary>

**A** — Slajd wymienia logowanie zdarzeń, blogi i systemy CMS. (slajd 23)

</details>

**1.62. Która baza prowadzi w rankingu DB-Engines baz dokumentowych (październik 2025)?**

- A) Couchbase
- B) Amazon DynamoDB
- C) MongoDB
- D) CouchDB

<details><summary>Odpowiedź</summary>

**C** — MongoDB jest na samej górze, pod nią Databricks i Amazon DynamoDB. (slajd 24)

</details>

**1.63. Jak nazywa się pole, które w MongoDB jest unikalnym kluczem dokumentu?**

- A) `id`
- B) `_key`
- C) `$id`
- D) `_id`

<details><summary>Odpowiedź</summary>

**D** — Każdy dokument ma unikalne pole `_id`, domyślnie typu ObjectId. (slajd 25)

</details>

**1.64. Jaka jest hierarchia danych w MongoDB według slajdu?**

- A) Dokument → kolekcja → baza danych
- B) Wiersz → tabela → keyspace
- C) Węzeł → relacja → graf
- D) Kolekcja → dokument → baza danych

<details><summary>Odpowiedź</summary>

**A** — Dokument (JSON/BSON) należy do kolekcji, a kolekcje tworzą bazę danych. (slajd 25)

</details>

**1.65. Które polecenie wstawia jeden dokument do kolekcji `klienci` w MongoDB?**

- A) `db.klienci.insert({ imie: "Anna", wiek: 28 }).one()`
- B) `INSERT INTO klienci (imie, wiek) VALUES ('Anna', 28)`
- C) `db.klienci.insertOne({ imie: "Anna", nazwisko: "Nowak", wiek: 28 })`
- D) `db.insertOne("klienci", { imie: "Anna" })`

<details><summary>Odpowiedź</summary>

**C** — Metodę wywołuje się na kolekcji: `db.<kolekcja>.insertOne(dokument)`. Odpowiedź B to SQL/CQL. (slajd 25)

</details>

**1.66. Co robi poniższe polecenie?**

```js
db.klienci.updateOne(
  { _id: ObjectId("64f7c9a2e1b3c8a1d5e4f001") },
  { $set: { wiek: 26 } }
)
```

- A) Zastępuje cały dokument dokumentem `{ wiek: 26 }`
- B) Ustawia pole `wiek` na 26 w jednym dokumencie o podanym `_id`, pozostałe pola zostają bez zmian
- C) Ustawia `wiek` na 26 we wszystkich dokumentach kolekcji
- D) Wstawia nowy dokument z polem `wiek: 26`

<details><summary>Odpowiedź</summary>

**B** — `updateOne` z `$set` zmienia wybrane pole jednego pasującego dokumentu. Całe zastąpienie robi `replaceOne`, a wiele dokumentów zmienia `updateMany`. (slajd 25)

</details>

**1.67. Którym mechanizmem MongoDB skaluje się w poziomie?**

- A) Shardingiem
- B) Normalizacją
- C) Kluczami obcymi
- D) Widokami zmaterializowanymi

<details><summary>Odpowiedź</summary>

**A** — Slajd podaje: skalowalność, łatwe skalowanie w poziomie (sharding). (slajd 25)

</details>

**1.68. Jak według porównania na slajdzie MongoDB wyraża relacje między danymi?**

- A) Przez klucze obce, jak bazy relacyjne
- B) Przez krawędzie grafu
- C) Przez rodziny kolumn
- D) Przez dokumenty wbudowane, czyli zagnieżdżone

<details><summary>Odpowiedź</summary>

**D** — W MongoDB relacje są wbudowane lub zagnieżdżone, w bazach relacyjnych realizowane przez klucze obce. (slajd 25)

</details>

**1.69. Od której wersji MongoDB, według slajdu, obsługuje transakcje ACID (z ograniczeniami)?**

- A) 2.6
- B) 3.0
- C) 4.0
- D) 6.0

<details><summary>Odpowiedź</summary>

**C** — Slajd: brak transakcji ACID w starszych wersjach, wsparcie od wersji 4.0, ale z ograniczeniami. Od 4.2 transakcje działają także w klastrach shardowanych. (slajd 25)

</details>

### Bazy rodziny kolumn i Cassandra

**1.70. Które zdanie o modelu rodziny kolumn jest prawdziwe?**

- A) Tabela to kolekcja podobnych, ale niekoniecznie identycznych wierszy, a dostęp do wiersza daje jego identyfikator (row key)
- B) Każdy wiersz w tabeli musi mieć identyczny zestaw kolumn
- C) Kolumna może przechowywać tylko wartości skalarne
- D) To po prostu baza relacyjna ze zmienną specyfikacją wiersza

<details><summary>Odpowiedź</summary>

**A** — Wiersze nie muszą być identyczne, kolumny mogą mieć listy i mapy, a slajd zaznacza, że nie są to po prostu bazy relacyjne ze zmiennym wierszem. (slajd 26)

</details>

**1.71. Kiedy według slajdu NIE używać baz rodziny kolumn?**

- A) Przy blogach i systemach CMS
- B) Gdy wymagane są transakcje ze ścisłą spójnością, agregacje i złączenia albo częste zmiany schematu
- C) Gdy dane trzeba rozproszyć na wiele serwerów
- D) Gdy potrzebna jest wysoka wydajność zapisu

<details><summary>Odpowiedź</summary>

**B** — Slajd wymienia transakcje ze ścisłą spójnością, złożone zapytania (SUM, AVG, złączenia) i częste zmiany schematu. Blogi i CMS to przypadki użycia. (slajd 26)

</details>

**1.72. Która baza zajmuje drugie miejsce w rankingu DB-Engines baz szerokich kolumn (październik 2025), zaraz po Cassandrze?**

- A) ScyllaDB
- B) Google Cloud Bigtable
- C) Amazon Keyspaces
- D) Apache HBase

<details><summary>Odpowiedź</summary>

**D** — Ranking: Cassandra, Apache HBase, Microsoft Azure Cosmos DB; reszta poniżej 10 punktów. (slajd 27)

</details>

**1.73. Jaka jest hierarchia danych w Cassandrze według slajdu?**

- A) Dokument → kolekcja → baza
- B) Instancja → baza → tabela → wiersz
- C) Rekord (wiersz) → tabela (column family) → keyspace → klaster
- D) Węzeł → relacja → etykieta → graf

<details><summary>Odpowiedź</summary>

**C** — Rekord należy do tabeli, tabela do keyspace (przestrzeni nazw), a keyspace do klastra wielu węzłów. (slajd 28)

</details>

**1.74. Jaka jest architektura klastra Cassandry?**

- A) Master–slave z jednym węzłem głównym
- B) Peer-to-peer: wszystkie węzły są równorzędne, bez pojedynczego punktu awarii
- C) Jeden serwer z repliką zapasową
- D) Klient–serwer z centralnym koordynatorem transakcji

<details><summary>Odpowiedź</summary>

**B** — Wszystkie węzły Cassandry są równorzędne, co eliminuje pojedynczy punkt awarii. (slajd 28)

</details>

**1.75. W jakim języku zapisano na slajdzie polecenia `CREATE TABLE klienci (id INT PRIMARY KEY, ...)` i `INSERT INTO klienci ... VALUES (...)` dla Cassandry?**

- A) CQL
- B) Cypher
- C) SPARQL
- D) XQuery

<details><summary>Odpowiedź</summary>

**A** — Cassandra używa CQL (Cassandra Query Language), podobnego do SQL. Cypher to Neo4j, SPARQL RDF, XQuery XML. (slajd 28)

</details>

**1.76. Które polecenie CQL zmienia wiek klienta o `id = 1002` na 29?**

- A) `SET wiek = 29 FROM klienci WHERE id = 1002;`
- B) `db.klienci.updateOne({ id: 1002 }, { $set: { wiek: 29 } })`
- C) `UPDATE klienci SET wiek = 29 WHERE id = 1002;`
- D) `MATCH (k:klienci {id: 1002}) SET k.wiek = 29`

<details><summary>Odpowiedź</summary>

**C** — CQL ma składnię `UPDATE tabela SET kolumna = wartość WHERE klucz = ...`. B to MongoDB, D to Cypher. (slajd 28)

</details>

**1.77. Jak slajd opisuje spójność danych w Cassandrze w porównaniu z bazami relacyjnymi?**

- A) Konfigurowalna (tzw. eventual) kontra silna (ACID) w bazach relacyjnych
- B) Silna (ACID) kontra konfigurowalna w bazach relacyjnych
- C) Brak jakiejkolwiek spójności
- D) Identyczna jak w bazach relacyjnych

<details><summary>Odpowiedź</summary>

**A** — Cassandra ma spójność konfigurowalną, ostateczną (eventual), a bazy relacyjne silną, ACID. (slajd 28)

</details>

**1.78. Które zdanie opisuje wadę Cassandry według slajdu?**

- A) Słaba wydajność zapisu
- B) Pojedynczy punkt awarii w węźle głównym
- C) Brak replikacji danych
- D) Zapytania trzeba zaplanować przed utworzeniem tabel, co prowadzi do denormalizacji, a JOIN jest ograniczony

<details><summary>Odpowiedź</summary>

**D** — Slajd wymienia złożone modelowanie, ograniczony JOIN, słabość przy skomplikowanych transakcjach i projektowanie tabel pod zapytania. Wydajność zapisu jest jej zaletą. (slajd 28)

</details>

### Bazy grafowe i Neo4j

**1.79. Co w modelu grafowym reprezentują węzły, a co krawędzie?**

- A) Węzły to relacje, krawędzie to encje
- B) Węzły to encje, krawędzie to relacje między encjami
- C) Węzły to tabele, krawędzie to klucze obce
- D) Węzły to dokumenty, krawędzie to kolekcje

<details><summary>Odpowiedź</summary>

**B** — Węzły reprezentują encje, krawędzie relacje, a oba elementy mogą mieć właściwości. (slajd 29)

</details>

**1.80. Jak slajd charakteryzuje dwa typy baz grafowych?**

- A) OLTP – mała liczba bardzo dużych grafów; OLAP – duża liczba małych grafów
- B) OLTP i OLAP obsługują wyłącznie grafy nieskierowane
- C) OLTP – duża liczba małych lub średnich grafów; OLAP – mała liczba bardzo dużych grafów
- D) OLTP służy do analizy, OLAP do transakcji

<details><summary>Odpowiedź</summary>

**C** — Transakcyjne (OLTP) obsługują wiele małych i średnich grafów, analityczne (OLAP) mało bardzo dużych. (slajd 29)

</details>

**1.81. Które zapytanie jest typowe dla bazy grafowej według slajdu?**

- A) Wyszukiwanie najkrótszej ścieżki
- B) Pobranie wartości po kluczu sesji
- C) Agregacja SUM po kolumnie
- D) Transformacja dokumentu XSLT

<details><summary>Odpowiedź</summary>

**A** — Slajd wymienia najkrótszą ścieżkę, analizę relacji, zapytania do podgrafów i nadgrafów oraz wyszukiwanie podobnych obiektów. (slajd 29)

</details>

**1.82. Która baza zajmuje drugie miejsce w rankingu DB-Engines baz grafowych (październik 2025), zaraz po Neo4j?**

- A) ArangoDB
- B) Amazon Neptune
- C) JanusGraph
- D) Microsoft Azure Cosmos DB

<details><summary>Odpowiedź</summary>

**D** — Neo4j (52,51), potem Microsoft Azure Cosmos DB (22,71) i Aerospike (4,53). (slajdy 30, 35)

</details>

**1.83. W jakim języku pisze się zapytania do Neo4j?**

- A) SPARQL
- B) Cypher
- C) CQL
- D) Gremlin SQL

<details><summary>Odpowiedź</summary>

**B** — Neo4j używa języka Cypher. SPARQL służy do RDF, CQL do Cassandry. (slajd 31)

</details>

**1.84. Które polecenie Cypher tworzy relację ZNA od węzła `a` do węzła `b` z właściwością `od_kiedy`?**

- A) `CREATE (a)<-[ZNA]-(b {od_kiedy: 2020})`
- B) `CREATE [a]-(:ZNA {od_kiedy: 2020})->[b]`
- C) `CREATE (a)-[:ZNA {od_kiedy: 2020}]->(b)`
- D) `INSERT RELATION ZNA (a, b, od_kiedy = 2020)`

<details><summary>Odpowiedź</summary>

**C** — W Cypherze węzły są w nawiasach okrągłych, relacja w kwadratowych z dwukropkiem przed typem, a kierunek wskazuje `->`. (slajd 31)

</details>

**1.85. Na slajdzie zapytanie zwraca `b.od_kiedy`, choć `od_kiedy` jest właściwością relacji ZNA. Która wersja poprawnie zwraca tę właściwość?**

- A) `MATCH (a:Osoba {imie: 'Jan'})-[r:ZNA]->(b) RETURN b.imie, r.od_kiedy`
- B) `MATCH (a:Osoba {imie: 'Jan'})-[:ZNA]->(b) RETURN a.od_kiedy`
- C) `MATCH (a:Osoba {imie: 'Jan'})-[:ZNA]->(b) RETURN ZNA.od_kiedy`
- D) `SELECT od_kiedy FROM ZNA WHERE imie = 'Jan'`

<details><summary>Odpowiedź</summary>

**A** — Właściwość relacji odczytuje się przez zmienną relacji (tu `r`). `b.od_kiedy` na slajdzie zwróci null, bo węzeł b nie ma tej właściwości. (slajd 31)

</details>

**1.86. Które polecenie Cypher zmienia cenę produktu Laptop na 3200?**

- A) `UPDATE Produkt SET cena = 3200 WHERE nazwa = 'Laptop'`
- B) `MATCH (p:Produkt {nazwa: 'Laptop'}) SET p.cena = 3200 RETURN p`
- C) `CREATE (p:Produkt {nazwa: 'Laptop', cena: 3200})`
- D) `MATCH (p:Produkt) RETURN p.cena = 3200`

<details><summary>Odpowiedź</summary>

**B** — Najpierw MATCH znajduje węzeł, potem SET zmienia właściwość. CREATE utworzyłby nowy węzeł. (slajd 31)

</details>

**1.87. Która cecha jest ograniczeniem Neo4j według slajdu?**

- A) Wolne przechodzenie po relacjach
- B) Brak obsługi właściwości na relacjach
- C) Brak możliwości wykrywania oszustw
- D) Nie jest optymalna dla prostych danych tabelarycznych i wymaga nauki Cyphera

<details><summary>Odpowiedź</summary>

**D** — Slajd wymienia: nieoptymalna dla prostych danych tabelarycznych, wyższe wymagania sprzętowe przy dużych grafach, słabsza przy transakcjach masowych i konieczność nauki Cyphera. (slajd 31)

</details>

### Bazy XML i RDF

**1.88. Do czego służy XQuery w bazach XML?**

- A) Do odpytywania dokumentów XML
- B) Do nawigacji po drzewie XML
- C) Do transformacji dokumentu XML
- D) Do walidacji schematu XML

<details><summary>Odpowiedź</summary>

**A** — XPath nawiguje, XQuery odpytuje, XSLT przekształca. (slajd 32)

</details>

**1.89. Który język służy do transformacji dokumentów XML?**

- A) XPath
- B) XQuery
- C) XSLT
- D) SPARQL

<details><summary>Odpowiedź</summary>

**C** — XSLT (XSL Transformations) przekształca dokumenty XML, np. w HTML. (slajd 32)

</details>

**1.90. Który system jest przedstawicielem baz XML według slajdu?**

- A) Apache Jena
- B) eXist-db
- C) Riak KV
- D) ScyllaDB

<details><summary>Odpowiedź</summary>

**B** — Bazy XML na slajdzie to Sedna, MarkLogic, Tamino, eXist-db i Virtuoso. Apache Jena to RDF. (slajd 32)

</details>

**1.91. Z jakich elementów składa się trójka RDF według slajdu?**

- A) Klucz, wartość, znacznik czasu
- B) Węzeł, etykieta, właściwość
- C) Wiersz, rodzina kolumn, kolumna
- D) Temat (podmiot), predykat, obiekt

<details><summary>Odpowiedź</summary>

**D** — Trójka RDF to temat (podmiot, ang. subject), predykat i obiekt, i reprezentuje jedno stwierdzenie. (slajd 33)

</details>

**1.92. Jakim językiem odpytuje się bazy RDF?**

- A) Cypher
- B) XQuery
- C) SPARQL
- D) CQL

<details><summary>Odpowiedź</summary>

**C** — SPARQL, czyli SPARQL Protocol and RDF Query Language. (slajd 33)

</details>

**1.93. Jak trójki RDF odwzorowuje się na graf?**

- A) Wierzchołki to tematy lub obiekty, a krawędzie to poszczególne stwierdzenia
- B) Wierzchołki to predykaty, a krawędzie to obiekty
- C) Każda trójka to osobny graf bez krawędzi
- D) Trójek RDF nie da się przedstawić jako grafu

<details><summary>Odpowiedź</summary>

**A** — Slajd: wierzchołki to tematy lub obiekty, a krawędzie oznaczają stwierdzenia. (slajd 33)

</details>

### Ranking DB-Engines

**1.94. Według jakiego kryterium DB-Engines klasyfikuje systemy baz danych?**

- A) Według wydajności w benchmarkach
- B) Według popularności, z aktualizacją co miesiąc
- C) Według liczby linii kodu
- D) Według ceny licencji

<details><summary>Odpowiedź</summary>

**B** — „The DB-Engines Ranking ranks database management systems according to their popularity. The ranking is updated monthly.” (slajd 34)

</details>

**1.95. Które miejsce zajmuje MongoDB w ogólnym rankingu DB-Engines z października 2025 i jak wypada wśród baz NoSQL?**

- A) 1. miejsce, przed Oracle
- B) 3. miejsce, za MySQL
- C) 5. miejsce, najwyżej ze wszystkich baz NoSQL w tym rankingu
- D) 11. miejsce, za Cassandrą

<details><summary>Odpowiedź</summary>

**C** — Pierwsza czwórka to bazy relacyjne (Oracle, MySQL, SQL Server, PostgreSQL), a MongoDB jest piąta. Redis jest 7., Cassandra 11. (slajd 34)

</details>

**1.96. Która baza zajmuje 1. miejsce w ogólnym rankingu DB-Engines z października 2025?**

- A) Oracle
- B) MySQL
- C) PostgreSQL
- D) Microsoft SQL Server

<details><summary>Odpowiedź</summary>

**A** — Oracle (1212,77 pkt), potem MySQL, Microsoft SQL Server i PostgreSQL. (slajd 34)

</details>

### BASE i ACID

**1.97. Co oznacza skrót BASE?**

- A) Balanced, Atomic, Secure, Exact
- B) Basic Availability, Strong consistency, Eventual durability
- C) Batch, Asynchronous, Sharded, Elastic
- D) Basically Available, Soft state, Eventually consistent

<details><summary>Odpowiedź</summary>

**D** — BASE to zasadnicza dostępność, miękki stan i ostateczna spójność. Slajd zaznacza, że nie ma jednej uznanej definicji BASE. (slajd 36)

</details>

**1.98. Co oznacza „miękki stan” (soft state) w modelu BASE?**

- A) Stan systemu może się zmieniać w czasie, nawet bez wprowadzania zmian w danych
- B) Dane są przechowywane tylko w pamięci RAM
- C) System odrzuca zapisy przy awarii
- D) Transakcje można cofnąć w dowolnym momencie

<details><summary>Odpowiedź</summary>

**A** — Soft state: stan może się zmieniać bez nowych zapisów, np. podczas synchronizacji replik. (slajd 36)

</details>

**1.99. Jaki model stosuje się w klasycznych bazach relacyjnych zamiast BASE?**

- A) CAP
- B) ACID
- C) CRUD
- D) MapReduce

<details><summary>Odpowiedź</summary>

**B** — W bazach relacyjnych stosuje się ACID (Atomicity, Consistency, Isolation, Durability), który daje silniejsze gwarancje spójności i transakcyjności. (slajd 36)

</details>

**1.100. Co oznacza litera D w skrócie ACID?**

- A) Distribution – rozproszenie danych
- B) Denormalization – denormalizacja
- C) Durability – trwałość zatwierdzonych zmian
- D) Dependency – zależność transakcji

<details><summary>Odpowiedź</summary>

**C** — ACID to Atomicity, Consistency, Isolation, Durability; durability oznacza, że zatwierdzona transakcja przetrwa awarię. (slajd 36)

</details>

### Twierdzenie CAP i trójkąt CAP

**1.101. Co mówi twierdzenie CAP?**

- A) W rozproszonym systemie danych nie można jednocześnie zapewnić spójności, dostępności i tolerancji na podział sieci
- B) Każda baza NoSQL zapewnia jednocześnie C, A i P
- C) Bazy relacyjne zawsze zapewniają tolerancję na podział sieci
- D) Spójność i dostępność wykluczają się w każdym systemie, także jednowęzłowym

<details><summary>Odpowiedź</summary>

**A** — W systemie rozproszonym można jednocześnie zapewnić tylko dwie z trzech właściwości. (slajd 37)

</details>

**1.102. Co oznacza litera P w twierdzeniu CAP?**

- A) Performance – wydajność
- B) Persistence – trwałość danych
- C) Partitioning – shardowanie danych
- D) Partition tolerance – system działa mimo podziału sieci i braku łączności między węzłami

<details><summary>Odpowiedź</summary>

**D** — P to tolerancja na podział sieci. (slajd 37)

</details>

**1.103. Do której kategorii CAP slajdy zaliczają Apache Cassandrę?**

- A) CA
- B) CP
- C) AP
- D) ACID

<details><summary>Odpowiedź</summary>

**C** — Cassandra to przykład bazy AP: skalowanie poziome, odporność na awarie i wysoka dostępność, ale bez gwarancji odczytu najnowszych danych. (slajdy 37–38)

</details>

**1.104. Do której kategorii CAP slajdy zaliczają MongoDB?**

- A) AP
- B) CP
- C) CA
- D) Żadnej, bo nie jest rozproszona

<details><summary>Odpowiedź</summary>

**B** — MongoDB (w trybie CP) zachowuje integralność, ale przy awarii węzła część danych może być niedostępna. (slajdy 37–38)

</details>

**1.105. Która grupa systemów leży według trójkąta CAP na boku CA?**

- A) Klasyczne bazy relacyjne (np. MySQL, PostgreSQL) i systemy w jednej lokalizacji
- B) Cassandra, DynamoDB, Riak
- C) HBase, BigTable, ZooKeeper
- D) CouchDB i MongoDB

<details><summary>Odpowiedź</summary>

**A** — CA to klasyczne bazy relacyjne i systemy bez rozproszenia. B to AP, C to CP. (slajd 38)

</details>

**1.106. Która lista zawiera wyłącznie systemy AP według trójkąta CAP ze slajdu?**

- A) HBase, MongoDB, BigTable
- B) MySQL, PostgreSQL
- C) ZooKeeper, HBase, Cassandra
- D) DynamoDB, Cassandra, Riak, CouchDB

<details><summary>Odpowiedź</summary>

**D** — AP: DynamoDB, Cassandra, Riak, CouchDB. CP: HBase, MongoDB, BigTable, ZooKeeper. (slajd 38)

</details>

**1.107. Jak według slajdu skalują się tradycyjne relacyjne bazy danych z boku CA?**

- A) Przede wszystkim poziomo
- B) Przede wszystkim pionowo
- C) Wyłącznie przez sharding
- D) Nie da się ich skalować

<details><summary>Odpowiedź</summary>

**B** — Slajd: kładą nacisk na spójność i dostępność, ale skalują się przede wszystkim pionowo. (slajd 38)

</details>

### Map-Reduce

**1.108. Jaka jest poprawna kolejność faz w modelu Map-Reduce?**

- A) Reduce → Shuffle/Sort → Map
- B) Map → Reduce → Shuffle/Sort
- C) Podział danych → Map → Shuffle/Sort → Reduce
- D) Shuffle/Sort → Map → Reduce

<details><summary>Odpowiedź</summary>

**C** — Dane dzieli się na części, map tworzy pary klucz–wartość, shuffle/sort grupuje je po kluczu, a reduce agreguje. (slajd 39)

</details>

**1.109. Co robi funkcja map w przykładzie liczenia słów?**

- A) Dla każdego słowa tworzy parę (słowo, 1)
- B) Sumuje wystąpienia każdego słowa
- C) Sortuje pliki wejściowe alfabetycznie
- D) Usuwa powtarzające się słowa

<details><summary>Odpowiedź</summary>

**A** — Map generuje pary (klucz, wartość), tu (słowo, 1). Sumowanie to reduce. (slajd 39)

</details>

**1.110. Co dzieje się w fazie shuffle/sort?**

- A) Funkcja użytkownika sumuje wartości
- B) Dane wejściowe są dzielone na bloki
- C) Wynik jest zapisywany do tabeli relacyjnej
- D) System automatycznie grupuje wartości o tym samym kluczu, przesyła dane między węzłami i je sortuje

<details><summary>Odpowiedź</summary>

**D** — Shuffle/sort wykonuje framework: grupuje pary po kluczu i przesyła je między węzłami. (slajd 39)

</details>

**1.111. Pliki wejściowe zawierają: „kot pies kot”, „pies ptak kot”, „pies kot ptak”. Jaki jest poprawny wynik liczenia słów?**

- A) kot 3, pies 3, ptak 2
- B) kot 4, pies 3, ptak 2
- C) kot 4, pies 2, ptak 3
- D) kot 3, pies 3, ptak 3

<details><summary>Odpowiedź</summary>

**B** — „kot” występuje 2 + 1 + 1 = 4 razy. Slajd błędnie podaje kot 3 (z listą trzech jedynek); pies 3 i ptak 2 się zgadzają. (slajd 39)

</details>

**1.112. Co slajd podaje jako przykład implementacji Map-Reduce?**

- A) Redis Streams
- B) Neo4j Graph Data Science
- C) Apache Hadoop (MapReduce)
- D) SPARQL

<details><summary>Odpowiedź</summary>

**C** — Przykładem implementacji jest Apache Hadoop. (slajd 39)

</details>

### Podsumowanie

**1.113. Jak wykład odpowiada na pytanie „Czy to koniec baz relacyjnych?”**

- A) Tak, NoSQL je całkowicie zastępuje
- B) Tak, ale dopiero po 2030 roku
- C) Tylko w zastosowaniach analitycznych
- D) Zdecydowanie nie; najsensowniej łączyć różne systemy bazodanowe zależnie od wymogów i zastosowania

<details><summary>Odpowiedź</summary>

**D** — Bazy relacyjne nadal są bardzo dobrym wyborem, mają świetną dokumentację, wsparcie i społeczność, a najlepiej dobierać różne silniki do zastosowań. (slajd 40)

</details>


## 2. MongoDB — instalacja, cechy i modelowanie danych

### Instalacja i narzędzia

**2.1. Która edycja MongoDB jest darmową wersją serwera do samodzielnej instalacji na własnym komputerze?**

- A) MongoDB Atlas
- B) MongoDB Community Server
- C) MongoDB Enterprise Advanced
- D) MongoDB Relational Migrator

<details><summary>Odpowiedź</summary>

**B** — Community Server to darmowa edycja do samodzielnej instalacji. Atlas to usługa w chmurze, Enterprise Advanced to wersja komercyjna, a Relational Migrator to narzędzie do migracji z baz relacyjnych. (slajdy 042, 044)

</details>

**2.2. Jakie rodzaje paczek serwera MongoDB dla Windows x64 pokazano na slajdach z formularzem pobierania?**

- A) deb i rpm
- B) tgz i pkg
- C) msi i zip
- D) exe i iso

<details><summary>Odpowiedź</summary>

**C** — formularz pobierania pokazuje paczkę msi (instalator Windows, slajd 044) i zip (archiwum do rozpakowania, slajdy 043 i 048). (slajdy 044, 048)

</details>

**2.3. Co oznacza opcja „Install MongoD as a Service” w instalatorze msi?**

- A) Instaluje graficzny klient Compass jako usługę sieciową
- B) Rejestruje serwer mongod jako usługę Windows, która może działać w tle i startować z systemem
- C) Instaluje powłokę mongosh w katalogu systemowym
- D) Włącza kontrolę dostępu i wymusza logowanie użytkowników

<details><summary>Odpowiedź</summary>

**B** — opcja rejestruje proces serwera mongod jako usługę Windows (domyślna nazwa usługi: MongoDB). Na slajdzie prowadzącego jest odznaczona, więc serwer uruchamia się ręcznie. (slajd 045)

</details>

**2.4. Które zdanie o MongoDB Shell (mongosh) jest prawdziwe według slajdów?**

- A) Jest częścią serwera i ma zawsze ten sam numer wersji co mongod
- B) Jest produktem komercyjnym dostępnym tylko w Enterprise Advanced
- C) Jest graficznym narzędziem GUI do przeglądania kolekcji
- D) Jest open source (Apache 2.0) i rozwijany osobno od serwera MongoDB

<details><summary>Odpowiedź</summary>

**D** — strona pobierania podaje, że MongoDB Shell to open source na licencji Apache 2.0, samodzielny produkt rozwijany oddzielnie od serwera; stąd osobna numeracja (np. 2.5.8 przy serwerze 8.2.1). (slajd 046)

</details>

**2.5. Jak nazywa się oficjalne graficzne narzędzie (GUI) do pracy z MongoDB?**

- A) MongoDB Compass
- B) MongoDB Atlas CLI
- C) MongoDB Connector for BI
- D) mongos

<details><summary>Odpowiedź</summary>

**A** — Compass to oficjalny klient GUI. Atlas CLI to narzędzie wiersza poleceń dla Atlasa, Connector for BI łączy narzędzia analityczne, a mongos to router klastra shardowanego. (slajdy 046, 047)

</details>

**2.6. Jaki jest domyślny port serwera MongoDB?**

- A) 3306
- B) 5432
- C) 28015
- D) 27017

<details><summary>Odpowiedź</summary>

**D** — MongoDB domyślnie nasłuchuje na porcie 27017 (localhost:27017 w Compass, VS Code i Dockerze). 3306 to MySQL, 5432 PostgreSQL, a 28015 to przykładowy port z slajdu 083. (slajdy 047, 049, 051, 053)

</details>

**2.7. Które trzy bazy systemowe widać po połączeniu Compassem ze świeżą instalacją MongoDB?**

- A) master, model, tempdb
- B) admin, config, local
- C) system, public, test
- D) root, users, logs

<details><summary>Odpowiedź</summary>

**B** — każda instalacja MongoDB ma bazy admin, config i local. Zestaw master/model/tempdb pochodzi z SQL Server. (slajd 047)

</details>

**2.8. Który program jest serwerem bazy danych MongoDB, a który klientem?**

- A) Serwer: mongosh, klient: mongod
- B) Serwer: mongos, klient: mongosh
- C) Serwer: mongod, klient: mongosh
- D) Serwer: mongod, klient: mongos

<details><summary>Odpowiedź</summary>

**C** — slajd podaje wprost: Database Server – mongod, Database Client – mongosh. Mongos to router zapytań w klastrze shardowanym, a nie klient. (slajd 049)

</details>

**2.9. Jaki katalog danych serwer mongod na Windowsie używa domyślnie (wskazany na slajdzie strzałką)?**

- A) `C:\data\db`
- B) `C:\mongodb\data`
- C) `C:\Program Files\MongoDB\db`
- D) `C:\Users\<user>\.mongodb`

<details><summary>Odpowiedź</summary>

**A** — domyślny dbpath na Windowsie to `\data\db` na bieżącym dysku; przy instalacji z zip trzeba ten folder utworzyć ręcznie albo podać `--dbpath`. (slajd 049)

</details>

**2.10. Który komunikat w logach mongod oznacza, że serwer wystartował i czeka na klientów?**

- A) „Connection refused”
- B) „Access control is not enabled”
- C) „Waiting for connections”
- D) „Shutting down”

<details><summary>Odpowiedź</summary>

**C** — „Waiting for connections” (port 27017) oznacza nasłuchiwanie. „Access control is not enabled” to tylko ostrzeżenie o braku uwierzytelniania. (slajd 049)

</details>

**2.11. Które schematy connection stringa można wybrać w oknie New Connection rozszerzenia MongoDB for VS Code?**

- A) `http` i `https`
- B) `mongodb` i `mongodb+srv`
- C) `mongo` i `mongosh`
- D) `tcp` i `udp`

<details><summary>Odpowiedź</summary>

**B** — standardowy format `mongodb://` działa dla standalone, replica set i klastra shardowanego; `mongodb+srv://` odczytuje listę hostów z rekordu DNS SRV (typowo Atlas). (slajd 051)

</details>

**2.12. Co oznacza parametr `readPreference=primary` w connection stringu `mongodb://localhost:27017/?readPreference=primary&ssl=false`?**

- A) Odczyty są kierowane do węzła głównego (primary)
- B) Odczyty są kierowane do najbliższego węzła pomocniczego
- C) Połączenie jest szyfrowane SSL
- D) Klient łączy się tylko do bazy primary

<details><summary>Odpowiedź</summary>

**A** — readPreference określa, z którego węzła zestawu replik czytać; primary to węzeł główny. Szyfrowanie wyłącza tu `ssl=false`. (slajd 051)

</details>

**2.13. Co oznacza ostrzeżenie mongosh „Access control is not enabled for the database”?**

- A) Serwer nie przyjmuje połączeń zdalnych
- B) Baza jest w trybie tylko do odczytu
- C) Plik konfiguracyjny `.mongoshrc.js` nie został znaleziony
- D) Odczyt i zapis danych oraz konfiguracji są nieograniczone, bo nie włączono uwierzytelniania

<details><summary>Odpowiedź</summary>

**D** — domyślnie MongoDB nie wymaga logowania, więc dostęp jest nieograniczony. Brak połączeń zdalnych dotyczy drugiego ostrzeżenia (bound to localhost). (slajd 052)

</details>

**2.14. Jak uruchomić mongod tak, aby nasłuchiwał na wszystkich interfejsach sieciowych, zgodnie z podpowiedzią z ostrzeżenia startowego?**

- A) `mongod --port 0`
- B) `mongod --bind_ip_all`
- C) `mongod --directConnection`
- D) `mongod --auth`

<details><summary>Odpowiedź</summary>

**B** — ostrzeżenie mówi, że serwer jest przywiązany do localhost i podaje opcje `--bind_ip <address>` lub `--bind_ip_all`. `--auth` włącza uwierzytelnianie, a directConnection to parametr klienta. (slajd 052)

</details>

**2.15. Jaki plik startowy wczytuje nowa powłoka mongosh (ostrzeżenie mówi, że starego nie wczyta)?**

- A) `~/.mongorc.js`
- B) `~/.mongodb.conf`
- C) `~/.mongoshrc.js`
- D) `~/.bashrc`

<details><summary>Odpowiedź</summary>

**C** — mongosh wczytuje `~/.mongoshrc.js`; plik `~/.mongorc.js` należał do starej powłoki mongo i nie jest wczytywany. (slajd 052)

</details>

**2.16. Co robi opcja `-d` w poleceniu `docker run --name mongodb -d -p 27017:27017 mongodb/mongodb-community-server:latest`?**

- A) Uruchamia kontener w tle (detached mode)
- B) Usuwa kontener po zatrzymaniu
- C) Włącza tryb debugowania serwera
- D) Wskazuje katalog danych

<details><summary>Odpowiedź</summary>

**A** — `-d` to detached, czyli praca w tle. Usuwanie po zatrzymaniu to `--rm`, a katalog danych montuje się opcją `-v`. (slajd 053)

</details>

**2.17. Co oznacza zapis `-p 27017:27017` w poleceniu `docker run`?**

- A) Ogranicza kontener do 27017 procesów
- B) Mapuje port hosta 27017 na port 27017 w kontenerze
- C) Ustawia priorytet kontenera
- D) Podaje hasło do bazy

<details><summary>Odpowiedź</summary>

**B** — `-p` publikuje port w formacie `port_hosta:port_kontenera`, dzięki czemu baza w kontenerze jest dostępna na hoście pod localhost:27017. (slajd 053)

</details>

**2.18. Które polecenie uruchamia interaktywną powłokę MongoDB wewnątrz działającego kontenera o nazwie `mongodb`?**

- A) `docker run -it mongodb mongosh`
- B) `docker start mongodb mongosh`
- C) `docker attach mongodb --shell`
- D) `docker exec -it mongodb mongosh`

<details><summary>Odpowiedź</summary>

**D** — `docker exec` wykonuje polecenie w działającym kontenerze, a `-it` daje tryb interaktywny z terminalem. `docker run` utworzyłby nowy kontener (a `mongodb` jest nazwą kontenera, nie obrazu). (slajd 053)

</details>

### Zalety, cechy i zastosowania MongoDB

**2.19. Która z wymienionych cech NIE jest zaletą baz NoSQL według slajdu o MongoDB?**

- A) Elastyczny schemat
- B) Skalowalność pozioma przez partycjonowanie danych na wiele serwerów
- C) Silniejsza spójność niż w bazach zgodnych z ACID
- D) Obsługa dużych ilości danych i aplikacji czasu rzeczywistego

<details><summary>Odpowiedź</summary>

**C** — slajd wymienia słabszą spójność (BASE) jako ograniczenie NoSQL, a nie zaletę. Pozostałe trzy to zalety ze slajdu. (slajd 054)

</details>

**2.20. Co oznacza skrót BASE?**

- A) Basically Available, Soft state, Eventual consistency
- B) Basic Atomicity, Strong Eventual consistency
- C) Binary Available, Secure, Encrypted
- D) Balanced Availability, Sharding, Elasticity

<details><summary>Odpowiedź</summary>

**A** — BASE: zasadniczo dostępna, stan miękki, spójna ostatecznie. Daje słabsze gwarancje spójności niż ACID. (slajd 054)

</details>

**2.21. Jak slajd określa bazy dokumentów w odniesieniu do baz klucz-wartość?**

- A) Jako bazy klucz-wartość bez możliwości zapytań
- B) Jako rozszerzone bazy klucz-wartość, w których część wartości można przeszukiwać
- C) Jako bazy grafowe z kluczami
- D) Jako bazy kolumnowe przechowujące JSON

<details><summary>Odpowiedź</summary>

**B** — baza dokumentów rozumie strukturę wartości (dokumentu), więc można ją przeszukiwać i indeksować, a nie tylko pobierać po kluczu. (slajd 055)

</details>

**2.22. Które zdanie o dokumentach w bazie dokumentów jest prawdziwe według slajdu?**

- A) Dokument musi mieć płaską strukturę bez zagnieżdżeń
- B) Dokumenty nie mają identyfikatorów, tylko pozycję w kolekcji
- C) Dokumenty są organizowane w tabele z kolumnami
- D) Dokument jest samoopisowy, może reprezentować hierarchię i ma unikalny identyfikator

<details><summary>Odpowiedź</summary>

**D** — slajd: samoopisowy model, możliwość reprezentowania hierarchii (wartości skalarne, mapy, listy, zbiory, zagnieżdżone dokumenty), unikalny identyfikator; dokumenty są zorganizowane w kolekcje. (slajd 055)

</details>

**2.23. W którym roku miało miejsce pierwsze wydanie MongoDB?**

- A) 2005
- B) 2007
- C) 2009
- D) 2012

<details><summary>Odpowiedź</summary>

**C** — slajd podaje pierwsze wydanie w 2009 r. (slajd 056)

</details>

**2.24. Od jakiego słowa pochodzi nazwa MongoDB?**

- A) „humongous” — ogromny
- B) „mongoose” — mangusta
- C) „Mongolia” — od kraju twórców
- D) „monotonic” — monotoniczny

<details><summary>Odpowiedź</summary>

**A** — nazwa pochodzi od „humongous”, co ma podkreślać obsługę bardzo dużych ilości danych. (slajd 056)

</details>

**2.25. W jakich językach według slajdu zaimplementowano MongoDB?**

- A) Java i Scala
- B) C++, C i JavaScript
- C) Go i Rust
- D) Python i C#

<details><summary>Odpowiedź</summary>

**B** — slajd: zaimplementowany w C++, C i JavaScript. (slajd 056)

</details>

**2.26. Który model replikacji wymienia slajd 056 wśród właściwości MongoDB?**

- A) Multi-master bez węzła głównego
- B) Replikacja peer-to-peer typu Dynamo
- C) Brak replikacji
- D) Replikacja master-slave

<details><summary>Odpowiedź</summary>

**D** — tak podaje slajd. Uwaga: współczesne MongoDB używa zestawów replik (primary i secondary), a tryb master-slave jest przestarzały i usunięty; idea jednego węzła przyjmującego zapisy pozostaje. (slajd 056)

</details>

**2.27. W jakim formacie MongoDB przechowuje dokumenty?**

- A) XML
- B) CSV
- C) BSON
- D) YAML

<details><summary>Odpowiedź</summary>

**C** — MongoDB to baza oparta na dokumentach w formacie BSON (Binary JSON). (slajd 057)

</details>

**2.28. Jak MongoDB zapewnia wysoką dostępność według listy kluczowych cech?**

- A) Przez zestawy replik z węzłami podstawowymi i pomocniczymi utrzymującymi kopie danych
- B) Przez indeksowanie dowolnego atrybutu
- C) Przez potok agregacji
- D) Przez zapytania ad hoc

<details><summary>Odpowiedź</summary>

**A** — cecha „Replikacja”: zestawy replik (primary i secondary) zapewniają wysoką dostępność. Indeksowanie służy wydajności zapytań. (slajd 057)

</details>

**2.29. Które zdanie najlepiej opisuje „obsługę zapytań ad hoc” w MongoDB?**

- A) Zapytania muszą być wcześniej zdefiniowane jako widoki
- B) Można wyszukiwać według pól, zakresów i wyrażeń regularnych
- C) Dokumenty można pobierać wyłącznie po kluczu `_id`
- D) Zapytania wykonuje się tylko w trybie wsadowym MapReduce

<details><summary>Odpowiedź</summary>

**B** — slajd: MongoDB obsługuje wyszukiwanie według pól, zakresów i wyrażeń regularnych, bez wcześniejszego przygotowania. (slajd 057)

</details>

**2.30. Które narzędzie wymienia slajd jako wsparcie trybu offline-first dla aplikacji mobilnych?**

- A) MongoDB Compass
- B) GridFS
- C) MongoDB Connector for BI
- D) MongoDB Realm

<details><summary>Odpowiedź</summary>

**D** — slajd w punkcie „Aplikacje mobilne” podaje wsparcie offline-first np. przez MongoDB Realm. (slajd 058)

</details>

**2.31. Który scenariusz NIE jest wymieniony na slajdzie „Kiedy używać MongoDB”?**

- A) Systemy bankowe wymagające złożonych transakcji wielotabelowych jako główny argument
- B) Internet rzeczy (IoT)
- C) Zarządzanie treścią (CMS, e-commerce)
- D) Mikroserwisy i aplikacje chmurowe

<details><summary>Odpowiedź</summary>

**A** — slajd wymienia big data, analitykę w czasie rzeczywistym, zarządzanie treścią, IoT, aplikacje mobilne oraz aplikacje chmurowe i mikroserwisy; złożone transakcje wielotabelowe to klasyczny obszar baz relacyjnych. (slajd 058)

</details>

**2.32. Dlaczego MongoDB nadaje się do systemów CMS i e-commerce według slajdu?**

- A) Bo wymaga sztywnego schematu, co ułatwia walidację
- B) Bo dzięki dynamicznemu schematowi obsługuje różne typy treści bez migracji schematu
- C) Bo obsługuje wyłącznie dane binarne
- D) Bo nie pozwala na indeksy tekstowe

<details><summary>Odpowiedź</summary>

**B** — dynamiczny schemat pozwala przechowywać różne typy treści bez migracji. Slajd wspomina też indeksy tekstowe i geolokalizacyjne w kontekście analityki. (slajd 058)

</details>

### Skalowanie i struktura danych

**2.33. Jaki mechanizm realizuje skalowanie poziome w MongoDB?**

- A) Dodanie RAM i CPU do jednego serwera
- B) Replikacja do węzłów secondary
- C) Sharding, czyli dzielenie danych na chunki rozproszone na wielu shardach
- D) GridFS

<details><summary>Odpowiedź</summary>

**C** — skalowanie poziome to sharding (chunki na shardach). Dodanie RAM i CPU to skalowanie pionowe. (slajd 059)

</details>

**2.34. Które elementy według slajdu trzeba skonfigurować przy skalowaniu poziomym, co czyni je złożonym?**

- A) Shard key, config servers i routery mongos
- B) Tylko parametry maszyny wirtualnej
- C) Plik msi i usługę Windows
- D) Indeks tekstowy i GridFS

<details><summary>Odpowiedź</summary>

**A** — złożoność skalowania poziomego jest wysoka, bo wymaga klucza shardowania, serwerów konfiguracyjnych i routerów mongos. Pionowe wymaga tylko zmiany parametrów maszyny. (slajd 059)

</details>

**2.35. Które zdanie o skalowaniu pionowym jest prawdziwe według slajdu?**

- A) Ma bardzo wysoki, praktycznie nieograniczony limit
- B) Rozkłada obciążenie zapisu i odczytu na wiele węzłów
- C) Wymaga konfiguracji shard key
- D) Jest tańsze na początku, ale koszt rośnie wykładniczo przy dużych wymaganiach

<details><summary>Odpowiedź</summary>

**D** — skalowanie pionowe: niski koszt początkowy, rosnący wykładniczo; limit ograniczony maksymalną specyfikacją sprzętu; poprawia wydajność tylko jednego węzła. (slajd 059)

</details>

**2.36. Do jakiego typu aplikacji slajd przypisuje skalowanie pionowe jako przykład zastosowania?**

- A) Aplikacje z ogromną ilością danych i wysoką liczbą zapytań
- B) Małe i średnie aplikacje, którym wystarczy mocniejszy serwer
- C) Globalne systemy rozproszone na wiele kontynentów
- D) Systemy IoT z milionami czujników

<details><summary>Odpowiedź</summary>

**B** — przykład dla skalowania pionowego to małe/średnie aplikacje; aplikacje z ogromną ilością danych to przykład dla skalowania poziomego. (slajd 059)

</details>

**2.37. Czemu w MongoDB odpowiada pojęcie „pole” (field)?**

- A) Parze klucz-wartość w dokumencie
- B) Grupie powiązanych dokumentów
- C) Pojedynczemu rekordowi kolekcji
- D) Wszystkim kolekcjom w instancji

<details><summary>Odpowiedź</summary>

**A** — pole to para klucz-wartość w dokumencie. Grupa dokumentów to kolekcja, rekord to dokument, a zbiór kolekcji to baza danych. (slajd 060)

</details>

**2.38. Która z definicji ze slajdu 060 jest poprawna?**

- A) Kolekcja to pojedynczy rekord w formacie BSON
- B) `_id` musi zawsze zostać podane ręcznie przy wstawianiu
- C) Kolekcja to grupa powiązanych dokumentów, podobna do tabeli w bazie relacyjnej
- D) Dokument to zbiór kolekcji

<details><summary>Odpowiedź</summary>

**C** — kolekcja odpowiada tabeli. `_id` jest generowane automatycznie, jeśli go nie podasz. Uwaga: na slajdzie jest literówka „BJSON”, poprawnie BSON. (slajd 060)

</details>

### Podstawowe operacje, indeksy i agregacje

**2.39. Którą metodą pobierzesz tylko jeden dokument pasujący do filtra?**

- A) `db.collection.find().one()`
- B) `db.collection.getOne()`
- C) `db.collection.findFirst()`
- D) `db.collection.findOne()`

<details><summary>Odpowiedź</summary>

**D** — `findOne()` zwraca jeden dokument (albo null), a `find()` zwraca kursor. Pozostałe metody nie istnieją w mongosh. (slajd 061)

</details>

**2.40. Które wywołanie poprawnie wstawia wiele dokumentów naraz?**

- A) `db.users.insertMany({name: "A"}, {name: "B"})`
- B) `db.users.insertMany([{name: "A"}, {name: "B"}])`
- C) `db.users.insertOne([{name: "A"}, {name: "B"}])`
- D) `db.users.insertAll([{name: "A"}, {name: "B"}])`

<details><summary>Odpowiedź</summary>

**B** — `insertMany` przyjmuje tablicę dokumentów w nawiasach kwadratowych. W A drugi dokument trafiłby w miejsce opcji, `insertOne` przyjmuje pojedynczy dokument, a `insertAll` nie istnieje. (slajd 061)

</details>

**2.41. Który operator aktualizacji usuwa pole z dokumentu?**

- A) `$unset`
- B) `$set`
- C) `$pull`
- D) `$delete`

<details><summary>Odpowiedź</summary>

**A** — `$unset` usuwa pole, `$set` ustawia wartość, `$pull` usuwa elementy z tablicy, a `$delete` nie istnieje. (slajd 061)

</details>

**2.42. Którym poleceniem trwale usuniesz całą kolekcję `orders` (razem z indeksami)?**

- A) `db.orders.deleteMany({})`
- B) `db.orders.remove()`
- C) `db.dropDatabase("orders")`
- D) `db.orders.drop()`

<details><summary>Odpowiedź</summary>

**D** — `drop()` usuwa kolekcję wraz z indeksami. `deleteMany({})` usuwa wszystkie dokumenty, ale kolekcja i indeksy zostają; `db.dropDatabase()` usuwa całą bieżącą bazę. (slajd 061)

</details>

**2.43. Czym różni się `updateMany()` od `updateOne()`?**

- A) `updateMany()` zastępuje cały dokument, a `updateOne()` zmienia pola
- B) `updateMany()` działa tylko z `$unset`
- C) `updateMany()` zmienia wszystkie pasujące dokumenty, a `updateOne()` pierwszy pasujący
- D) Nie ma różnicy, to aliasy

<details><summary>Odpowiedź</summary>

**C** — obie przyjmują filtr i operatory aktualizacji; różni je liczba modyfikowanych dokumentów. Zastąpienie całego dokumentu to `replaceOne()`. (slajd 061)

</details>

**2.44. Którą metodą tworzy się indeks w MongoDB?**

- A) `db.collection.addIndex()`
- B) `db.collection.createIndex()`
- C) `db.collection.index()`
- D) `db.createIndex("collection")`

<details><summary>Odpowiedź</summary>

**B** — indeks tworzy `db.collection.createIndex()`, np. `createIndex({ user_id: 1 })`. (slajdy 062, 088)

</details>

**2.45. Który etap potoku agregacji odpowiada za filtrowanie dokumentów (odpowiednik WHERE)?**

- A) `$group`
- B) `$project`
- C) `$sort`
- D) `$match`

<details><summary>Odpowiedź</summary>

**D** — `$match` filtruje, `$group` grupuje, `$project` kształtuje pola, `$sort` sortuje. (slajd 062)

</details>

### Modelowanie: osadzanie, referencje, podejście hybrydowe

**2.46. Dla jakich relacji slajd zaleca dokumenty osadzone (embedded documents)?**

- A) Tylko dla N:N
- B) Dla N:N i dużych, współdzielonych zbiorów danych
- C) Dla 1:1 oraz 1:N o ograniczonej liczbie elementów
- D) Wyłącznie dla danych binarnych

<details><summary>Odpowiedź</summary>

**C** — osadzanie jest najlepsze dla 1:1 i 1:N z ograniczoną liczbą elementów i zapewnia szybki odczyt. Referencje są odpowiednie dla 1:N i N:N oraz dla dużych, współdzielonych danych. (slajd 063)

</details>

**2.47. Czym są referencje (references) w modelowaniu danych MongoDB?**

- A) Danymi w oddzielnych kolekcjach łączonymi za pomocą identyfikatorów
- B) Kopiami dokumentu osadzonymi w innym dokumencie
- C) Kluczami obcymi wymuszanymi przez bazę z kaskadowym usuwaniem
- D) Indeksami złożonymi na wielu kolekcjach

<details><summary>Odpowiedź</summary>

**A** — referencja to identyfikator innego dokumentu w oddzielnej kolekcji. MongoDB nie wymusza kluczy obcych ani nie usuwa kaskadowo. (slajdy 063, 077)

</details>

**2.48. Co według slajdu daje podejście hybrydowe w modelowaniu danych?**

- A) Całkowicie eliminuje redundancję
- B) Wymusza sztywny schemat kolekcji
- C) Zastępuje indeksy
- D) Łączy osadzanie i referencje, równoważąc wydajność, elastyczność i wykorzystanie pamięci

<details><summary>Odpowiedź</summary>

**D** — podejście hybrydowe łączy dokumenty osadzone i referencje, aby znaleźć równowagę między wydajnością, elastycznością i pamięcią. (slajd 063)

</details>

**2.49. Który warunek NIE przemawia za użyciem tablicy dokumentów osadzonych?**

- A) Relacja jeden-do-wielu
- B) Osadzone dane mogą rosnąć w sposób nieograniczony
- C) Osadzone dane są ściśle powiązane z dokumentem nadrzędnym
- D) Chcemy lepszej wydajności odczytu i zapisu

<details><summary>Odpowiedź</summary>

**B** — slajd wymaga, aby osadzone dane NIE rosły w sposób nieograniczony; nieograniczony wzrost grozi przekroczeniem limitu 16 MB. (slajd 064)

</details>

**2.50. Jaki jest maksymalny rozmiar pojedynczego dokumentu MongoDB?**

- A) 4 MB
- B) 8 MB
- C) 16 MB
- D) 64 MB

<details><summary>Odpowiedź</summary>

**C** — limit dokumentu BSON to 16 MB; większe pliki dzieli się przez GridFS, a rosnące dane przenosi do osobnych kolekcji. (slajdy 064, 072, 073)

</details>

### BSON, JSON i typy danych

**2.51. Które zdanie o BSON jest prawdziwe według slajdów?**

- A) BSON jest tekstowym formatem czytelnym dla człowieka
- B) BSON jest podzbiorem JSON i obsługuje mniej typów
- C) BSON służy głównie do plików konfiguracyjnych
- D) BSON to binarny nadzbiór JSON z dodatkowymi typami, np. Date, Binary, ObjectId, Decimal128

<details><summary>Odpowiedź</summary>

**D** — BSON (Binary JSON) to binarna serializacja, nadzbiór JSON z dodatkowymi typami. (slajdy 065, 068)

</details>

**2.52. Dlaczego BSON ułatwia szybkie przechodzenie (traversal) po dokumencie?**

- A) Bo w BSON zakodowany jest rozmiar każdego elementu, co pozwala go pominąć
- B) Bo BSON sortuje pola alfabetycznie
- C) Bo BSON kompresuje dokument algorytmem zlib
- D) Bo BSON nie obsługuje zagnieżdżeń

<details><summary>Odpowiedź</summary>

**A** — slajd: w BSON rozmiar każdego elementu jest zakodowany, co ułatwia pomijanie elementów. (slajd 065)

</details>

**2.53. Które typy danych według slajdu obsługuje JSON?**

- A) Date, Binary, ObjectId
- B) Ciągi, liczby, wartości logiczne i null (oraz tablice i obiekty)
- C) Decimal128 i Int32
- D) Regular Expression i Timestamp

<details><summary>Odpowiedź</summary>

**B** — JSON ma ograniczone typy: string, number, boolean, null, array, object; daty i dane binarne trzeba zapisywać jako ciągi lub obiekty niestandardowe. (slajdy 066, 068)

</details>

**2.54. Do czego według podsumowania slajdów MongoDB zwykle używa JSON?**

- A) Do wewnętrznego przechowywania danych na dysku
- B) Do zapisu indeksów
- C) Do wymiany danych między MongoDB a aplikacjami
- D) Do replikacji między węzłami

<details><summary>Odpowiedź</summary>

**C** — BSON służy do przechowywania i pobierania danych w MongoDB, a JSON do wymiany danych z aplikacjami przez interfejsy zapytań i sterowniki. (slajd 067)

</details>

**2.55. Jak tabela porównawcza na slajdzie ocenia rozmiar BSON względem JSON?**

- A) BSON jest mniejszy, bo zapis binarny jest bardziej kompaktowy
- B) BSON jest zawsze dwa razy większy
- C) Oba mają identyczny rozmiar
- D) Rozmiar BSON nie jest ograniczony

<details><summary>Odpowiedź</summary>

**A** — tak podaje slajd. Uwaga: w praktyce BSON bywa większy od JSON dla małych dokumentów (zapisuje długości i znaczniki typów); jego główne zalety to szybkie przechodzenie i bogatsze typy. (slajd 068)

</details>

**2.56. Ile bajtów ma ObjectId i ile znaków ma jego zapis szesnastkowy?**

- A) 16 bajtów, 32 znaki
- B) 8 bajtów, 16 znaków
- C) 24 bajty, 12 znaków
- D) 12 bajtów, 24 znaki

<details><summary>Odpowiedź</summary>

**D** — ObjectId ma 12 bajtów; jeden bajt to dwa znaki hex, więc zapis ma 24 znaki. 16 bajtów i 32 znaki to UUID. (slajd 069)

</details>

**2.57. Który typ danych jest na diagramie typów BSON przekreślony, bo jest przestarzały?**

- A) Null
- B) Undefined
- C) Regular Expression
- D) Binary data

<details><summary>Odpowiedź</summary>

**B** — typ Undefined jest przestarzały (przekreślony na diagramie); zamiast niego używa się null. (slajd 069)

</details>

**2.58. Który zapis w mongosh tworzy wartość typu Date pokazaną na slajdzie z typami danych?**

- A) `Date.parse("2019-02-18")`
- B) `BinData(0, "2019-02-18")`
- C) `ISODate("2019-02-18T19:29:22.381Z")`
- D) `ObjectId("2019-02-18")`

<details><summary>Odpowiedź</summary>

**C** — na slajdzie typ Date pokazano jako `"createdAt": ISODate("2019-02-18T19:29:22.381Z")`. `BinData` to dane binarne, `ObjectId` to identyfikator. (slajd 069)

</details>

### Przykład zapytań na kolekcji movies

Pytania 2.59–2.61 dotyczą kolekcji ze slajdu 070:

```js
db.movies.insertMany([
  { title: "Niezniszczalni", year: 2020 },
  { title: "Tomb Raider", year: 2021 },
  { title: "Hobbit", year: 2022 }
]);
```

**2.59. Co zwróci zapytanie `db.movies.find({year:{$gt:2020}}, {_id:0, title:1}).sort({title:-1})`?**

- A) `[{title:"Tomb Raider"}, {title:"Hobbit"}]`
- B) `[{title:"Hobbit"}, {title:"Tomb Raider"}]`
- C) `[{title:"Tomb Raider"}, {title:"Niezniszczalni"}, {title:"Hobbit"}]`
- D) `[{_id:..., title:"Tomb Raider"}, {_id:..., title:"Hobbit"}]`

<details><summary>Odpowiedź</summary>

**A** — `$gt:2020` odrzuca rok 2020, projekcja ukrywa `_id`, a `sort({title:-1})` sortuje malejąco po tytule, więc T przed H. (slajd 070)

</details>

**2.60. Ile dokumentów zwróci `db.movies.find({year:{$gte:2020}})`?**

- A) 1
- B) 2
- C) 3
- D) 0

<details><summary>Odpowiedź</summary>

**C** — `$gte` to „większe lub równe”, więc pasują lata 2020, 2021 i 2022. Przy `$gt` byłyby 2 dokumenty. (slajd 070)

</details>

**2.61. Co oznacza drugi argument `{_id:0, title:1}` w `find()`?**

- A) Sortowanie: `_id` malejąco, `title` rosnąco
- B) Filtr: dokumenty bez `_id` z tytułem równym 1
- C) Indeks na polu `title`
- D) Projekcję: ukryj `_id`, pokaż `title`

<details><summary>Odpowiedź</summary>

**D** — drugi argument `find()` to projekcja; 0 ukrywa pole, 1 je pokazuje. `_id` jest zwracane domyślnie, więc trzeba je jawnie wyłączyć. (slajd 070)

</details>

### Dokument, pola i klucze główne

**2.62. Która restrykcja dotycząca nazw pól jest podana na slajdzie?**

- A) Nazwy pól nie mogą zaczynać się od znaku `$`
- B) Nazwy pól muszą zaczynać się od wielkiej litery
- C) Nazwy pól mogą się powtarzać w jednym dokumencie
- D) Nazwy pól nie mogą zawierać cyfr

<details><summary>Odpowiedź</summary>

**A** — `$` jest zarezerwowany dla operatorów zapytań, a `.` służy do pól zagnieżdżonych; nazwy pól muszą być unikalne. Uwaga: od MongoDB 5.0 `$` i `.` są w nazwach pól częściowo dopuszczalne, ale odradzane. (slajd 072)

</details>

**2.63. Co dzieje się z kolejnością pól w dokumencie MongoDB według slajdu?**

- A) Pola są sortowane alfabetycznie
- B) Kolejność jest losowa
- C) Kolejność jest zachowana, z wyjątkiem pola `_id`, które jest przenoszone na początek
- D) Pole `_id` zawsze trafia na koniec

<details><summary>Odpowiedź</summary>

**C** — porządek pól jest zachowany, a `_id` przenoszone na początek. (Na slajdzie zniekształcony zapis „_póllId”, chodzi o `_id`.) (slajd 072)

</details>

**2.64. Do czego służy GridFS według slajdu o dokumencie MongoDB?**

- A) Do kompresji dokumentów BSON
- B) Do dzielenia plików większych niż limit dokumentu na części
- C) Do replikacji danych między shardami
- D) Do walidacji schematu

<details><summary>Odpowiedź</summary>

**B** — maksymalny rozmiar dokumentu to 16 MB, a GridFS dzieli większe pliki na części (chunki). (slajd 072)

</details>

**2.65. Z jakich kolekcji korzysta GridFS?**

- A) `fs.files` i `fs.chunks`
- B) `grid.data` i `grid.meta`
- C) `files.index` i `files.blob`
- D) `system.files` i `system.binary`

<details><summary>Odpowiedź</summary>

**A** — GridFS używa dwóch kolekcji: `fs.files` (metadane) i `fs.chunks` (kawałki danych). (slajd 073)

</details>

**2.66. Jaki wbudowany wzorzec indeksu ma GridFS?**

- A) `{ _id: 1 }`
- B) `{ filename: "text" }`
- C) `{ chunk: 1, size: -1 }`
- D) `{ files_id: 1, n: 1 }`

<details><summary>Odpowiedź</summary>

**D** — indeks `{ files_id: 1, n: 1 }` łączy chunk z plikiem i porządkuje chunki według numeru `n`. (slajd 073)

</details>

**2.67. Które zdanie poprawnie porównuje BinData i GridFS?**

- A) BinData obsługuje strumieniowanie, a GridFS nie
- B) GridFS jest ograniczony do 16 MB, a BinData nie
- C) BinData nadaje się do małych danych (miniatury, klucze, certyfikaty), a GridFS do dużych plików (wideo, PDF, backupy)
- D) Oba mają niską złożoność i identyczne API

<details><summary>Odpowiedź</summary>

**C** — BinData: pole w dokumencie, limit 16 MB, bez strumieniowania, niska złożoność. GridFS: praktycznie dowolny rozmiar, strumieniowanie i częściowe odczyty, średnia złożoność. (slajd 073)

</details>

**2.68. Która właściwość identyfikatora `_id` jest podana na slajdzie o kluczach głównych?**

- A) Może być tablicą
- B) Może być zmieniany przez `$set`
- C) Musi być typu ObjectId
- D) Jest niemutowalny i unikalny w ramach kolekcji

<details><summary>Odpowiedź</summary>

**D** — `_id` jest unikalny w kolekcji, niemutowalny i może być dowolnego typu poza tablicą; ObjectId jest tylko domyślny. (slajd 074)

</details>

**2.69. Który sposób zarządzania kluczami slajd oznacza jako „nie zalecany”?**

- A) Naturalny identyfikator
- B) Auto-inkrement
- C) UUID
- D) ObjectId

<details><summary>Odpowiedź</summary>

**B** — auto-inkrement nie jest zalecany (MongoDB go nie ma wbudowanego, a licznik w systemie rozproszonym to wąskie gardło). ObjectId jest domyślny. (slajd 074)

</details>

**2.70. Na czym według slajdu bazuje ObjectId?**

- A) Na kolejnym numerze wiersza w kolekcji
- B) Na skrócie (hash) treści dokumentu
- C) Na czasie oraz odcisku maszyny i procesu
- D) Na adresie IP klienta i nazwie kolekcji

<details><summary>Odpowiedź</summary>

**C** — ObjectId jest niewielki, unikalny, szybki do wygenerowania, bazujący na czasie, odcisku maszyny i procesu. Dokładniej: 4 bajty znacznika czasu, 5 bajtów wartości losowej per proces (dawniej identyfikator maszyny i procesu) i 3 bajty licznika. (slajd 074)

</details>

### Model zdenormalizowany i znormalizowany, relacje

**2.71. Jakie są zaleta i wada modelu zdenormalizowanego (zagnieżdżone dokumenty) według slajdu?**

- A) Zaleta: mniej zapytań; wada: możliwa duża redundancja
- B) Zaleta: brak redundancji; wada: więcej zapytań
- C) Zaleta: wymuszona spójność; wada: brak indeksów
- D) Zaleta: dowolny rozmiar dokumentu; wada: wolny zapis

<details><summary>Odpowiedź</summary>

**A** — zagnieżdżone dokumenty: mniej zapytań, ale możliwa redundancja; dobre dla 1:1 i 1:N. Wariant B opisuje model znormalizowany. (slajd 076)

</details>

**2.72. Jak według slajdu realizuje się referencje w modelu znormalizowanym MongoDB?**

- A) Specjalnym typem BSON `Reference` sprawdzanym przez bazę
- B) Kluczami obcymi z ograniczeniem FOREIGN KEY
- C) Wartościami stanowiącymi identyfikatory dokumentów, bez specjalnego typu
- D) Wyłącznie etapem `$lookup` zapisanym w dokumencie

<details><summary>Odpowiedź</summary>

**C** — slajd: powiązania realizowane przez wartości będące identyfikatorami dokumentów (brak specjalnego typu). Baza nie sprawdza istnienia wskazywanego dokumentu. (slajd 077)

</details>

**2.73. Do jakiego rodzaju związków slajd szczególnie poleca model znormalizowany (referencje)?**

- A) Jeden-do-jednego
- B) Wiele-do-wielu
- C) Wyłącznie do danych binarnych
- D) Do poddokumentów kontaktowych

<details><summary>Odpowiedź</summary>

**B** — referencje są dobre do reprezentowania związków wiele-do-wielu, kosztem większej liczby zapytań. (slajd 077)

</details>

**2.74. Jaki problem ilustruje slajd z dwiema książkami O'Reilly Media, w których osadzono pełny dokument `publisher`?**

- A) Przekroczenie limitu 16 MB
- B) Brak możliwości indeksowania pola `publisher`
- C) Utratę kolejności pól
- D) Powtarzanie (redundancję) danych wydawcy w każdej książce

<details><summary>Odpowiedź</summary>

**D** — osadzenie wydawcy w każdej książce powtarza jego dane, co przy zmianie wymaga aktualizacji wszystkich książek. (slajd 078)

</details>

**2.75. Wydawca może mieć nieograniczoną liczbę książek. Gdzie według slajdu przechowywać referencję?**

- A) W dokumencie książki, jako pole `publisher_id`
- B) W dokumencie wydawcy, jako rosnąca tablica `books`
- C) W osobnej kolekcji indeksów
- D) W obu miejscach jednocześnie, zawsze

<details><summary>Odpowiedź</summary>

**A** — przy nieograniczonej liczbie książek tablica `books` w wydawcy rosłaby bez końca, więc referencję do wydawcy trzyma się w każdej książce. Tablica `books` jest dopuszczalna tylko przy niewielkiej, ograniczonej liczbie książek. (slajd 079)

</details>

**2.76. Który dokument modeluje relację jeden-do-wielu z osadzonymi dokumentami?**

- A) `{ _id: "joe", name: "Joe", address: { street: "123 Fake Street", city: "Faketon" } }`
- B) `{ _id: "joe", name: "Joe", address_id: "a1" }`
- C) `{ _id: "joe", name: "Joe", addresses: [ { street: "123 Fake Street" }, { street: "1 Some Other Street" } ] }`
- D) `{ _id: "joe", name: "Joe", addresses: "123 Fake Street; 1 Some Other Street" }`

<details><summary>Odpowiedź</summary>

**C** — relacja 1:N z osadzaniem to tablica poddokumentów. A to relacja 1:1 (jeden poddokument), B to referencja, a D to zwykły napis. (slajd 080)

</details>

**2.77. Co ilustrują dwie książki („Cell Biology”, „Organic Chemistry”), w których osadzono tego samego autora John Palmer (`author_id: "author381"`)?**

- A) Relację jeden-do-jednego
- B) Relację wiele-do-wielu z osadzonymi dokumentami (z powtórzeniem danych autora)
- C) Użycie GridFS
- D) Antywzorzec nadmiaru kolekcji

<details><summary>Odpowiedź</summary>

**B** — książka ma wielu autorów, a autor wiele książek; dane autora są powtórzone w każdej książce. (slajd 081)

</details>

**2.78. Które stwierdzenie o schemacie w MongoDB jest zgodne ze slajdem „Pytania projektowe”?**

- A) MongoDB wymaga jawnego schematu deklarowanego przed wstawieniem danych
- B) Dokumenty w kolekcji muszą mieć identyczne pola
- C) Schemat w ogóle nie istnieje i nie ma znaczenia
- D) Brak jawnego schematu, ale niejawny schemat i tak jest wymagany

<details><summary>Odpowiedź</summary>

**D** — brak jawnego schematu, lecz dokumenty są zwykle podobne i niejawny schemat jest wymagany; wyzwaniem jest balans wydajności i złożoności struktury. (slajd 075)

</details>

### Antywzorce

**2.79. Jaki jest skutek antywzorca „nieograniczone tablice” według slajdu?**

- A) Tablica może przekroczyć limit rozmiaru dokumentu i obniżyć wydajność indeksu
- B) Zwiększa liczbę kolekcji w bazie
- C) Wymusza użycie `$lookup`
- D) Blokuje replikację

<details><summary>Odpowiedź</summary>

**A** — duża tablica może przekroczyć limit 16 MB i spowodować spadek wydajności indeksu. (slajd 082)

</details>

**2.80. Dlaczego niepotrzebne indeksy są antywzorcem?**

- A) Bo spowalniają odczyty po `_id`
- B) Bo uniemożliwiają sharding
- C) Bo zajmują miejsce na dysku i mogą pogorszyć wydajność zapisu
- D) Bo zwiększają limit rozmiaru dokumentu

<details><summary>Odpowiedź</summary>

**C** — każdy zapis musi aktualizować wszystkie indeksy, a zbędne indeksy zajmują dodatkową przestrzeń. (slajd 082)

</details>

**2.81. Który antywzorzec dotyczy wykonywania zbyt wielu złączeń między kolekcjami?**

- A) Ogranicz nadmiar dokumentów
- B) Zmniejszenie liczby zbiorów (kolekcji)
- C) Usuń niepotrzebne indeksy
- D) Ograniczenie operacji `$lookup`

<details><summary>Odpowiedź</summary>

**D** — zbyt wiele operacji `$lookup` zwiększa złożoność i obniża wydajność zapytań. (slajd 082)

</details>

**2.82. Jaki jest skutek tworzenia zbyt dużej liczby kolekcji według slajdu?**

- A) Przekroczenie limitu 16 MB
- B) Obniżenie wydajności silnika pamięci (storage engine)
- C) Utrata możliwości tworzenia `_id`
- D) Automatyczne włączenie shardingu

<details><summary>Odpowiedź</summary>

**B** — zbyt wiele kolekcji może obniżyć wydajność silnika pamięci (na slajdzie „Zmniejszenie liczby zbiorów”). (slajd 082)

</details>

### Interfejs aplikacyjny i język zapytań

**2.83. Jak w sterowniku Node.js pobierasz kursor dokumentów z kolekcji `inventory`, gdzie `item` równa się `canvas`?**

- A) `db.inventory.find({ item: 'canvas' })`
- B) `db.collection('inventory').find({ item: 'canvas' })`
- C) `db.getCollection.inventory.find('canvas')`
- D) `db.find('inventory', { item: 'canvas' })`

<details><summary>Odpowiedź</summary>

**B** — w Node.js kolekcję wybiera się metodą `collection('inventory')`; zapis z kropką `db.inventory.find(...)` działa w mongosh i w Pythonie (PyMongo), ale nie w sterowniku Node.js. (slajd 083)

</details>

**2.84. Jakim narzędziem według slajdu „Interfejs aplikacyjny” łączysz się interaktywnie z serwerem, podając `--username`, `--password`, `--host` i `--port`?**

- A) Sterownikiem Motor
- B) MongoDB Connector for BI
- C) Interaktywną powłoką MongoDB (na slajdzie `./bin/mongo`, dziś `mongosh`)
- D) GridFS

<details><summary>Odpowiedź</summary>

**C** — slajd pokazuje `./bin/mongo --username ... --password ... --host ... --port 28015`. Uwaga: `mongo` to stara powłoka (dziś `mongosh` z tymi samymi przełącznikami), a 28015 to port przykładowy, domyślny to 27017. (slajd 083)

</details>

**2.85. Które zdanie o języku zapytań MongoDB jest prawdziwe według slajdu?**

- A) Zapytania w mongosh bazują na SQL
- B) Jedna komenda może jednocześnie odpytywać dowolną liczbę kolekcji
- C) Zapytania odczytu zwracają kursor, a każda komenda dotyczy pojedynczej kolekcji
- D) Zapytania odczytu zawsze zwracają tablicę wszystkich wyników naraz

<details><summary>Odpowiedź</summary>

**C** — zapytania w mongosh bazują na JavaScript, odczyt zwraca kursor umożliwiający iterowanie, a każda komenda dotyczy jednej kolekcji. (slajd 084)

</details>

**2.86. Które polecenie zmienia cenę jednego produktu na 179, zgodnie ze slajdem o CRUD?**

- A) `db.produkty.updateOne({ _id: ObjectId("...") }, { $set: { cena: 179 } })`
- B) `db.produkty.updateOne({ _id: ObjectId("...") }, { cena: 179 })`
- C) `db.produkty.update({ $set: { cena: 179 } })`
- D) `db.produkty.insertOne({ _id: ObjectId("..."), cena: 179 })`

<details><summary>Odpowiedź</summary>

**A** — `updateOne` przyjmuje filtr i dokument z operatorem `$set`. Wariant B bez operatora zgłosi błąd (zwykły dokument przyjmuje `replaceOne`), C nie ma filtra, a D wstawia nowy dokument. (slajd 084)

</details>

**2.87. Co oblicza wyrażenie `liczba: { $sum: 1 }` w etapie `$group` ze slajdu?**

- A) Sumę wartości pola `liczba`
- B) Liczbę dokumentów w każdej grupie
- C) Pierwszy dokument w grupie
- D) Liczbę kategorii w kolekcji

<details><summary>Odpowiedź</summary>

**B** — `$sum: 1` dodaje 1 za każdy dokument w grupie, czyli liczy dokumenty (odpowiednik `COUNT(*)`). (slajd 084)

</details>

**2.88. Co oznacza `_id: "$kategoria"` w etapie `$group`?**

- A) Ustawia `_id` każdego dokumentu na napis „$kategoria”
- B) Tworzy indeks na polu `kategoria`
- C) Grupuje dokumenty według wartości pola `kategoria`
- D) Usuwa pole `kategoria` z wyniku

<details><summary>Odpowiedź</summary>

**C** — w `$group` pole `_id` określa klucz grupowania, a `"$kategoria"` z dolarem to odwołanie do wartości pola. (slajd 084)

</details>

**2.89. Jaki mechanizm wymienia infografika jako „zaawansowane przetwarzanie danych w MongoDB” obok potoku agregacji?**

- A) MapReduce
- B) GridFS
- C) Change Streams
- D) Sharding

<details><summary>Odpowiedź</summary>

**A** — slajd wymienia MapReduce. Uwaga: od MongoDB 5.0 MapReduce jest przestarzały, a zalecany jest potok agregacji. (slajd 084)

</details>

### SQL kontra MongoDB

**2.90. Czemu w MongoDB odpowiada złączenie tabel (table joins) w SQL według tabeli z dokumentacji?**

- A) `$group` i `$sort`
- B) Indeks złożony
- C) Kolekcja systemowa
- D) `$lookup` oraz dokumenty osadzone

<details><summary>Odpowiedź</summary>

**D** — tabela podaje dla table joins: `$lookup`, embedded documents. (slajd 085)

</details>

**2.91. Które przyporządkowanie pojęć SQL i MongoDB jest poprawne?**

- A) row → collection
- B) table → collection, row → document, column → field
- C) column → document
- D) table → database

<details><summary>Odpowiedź</summary>

**B** — tabela to kolekcja, wiersz to dokument (BSON document), kolumna to pole; database i index pozostają bez zmian, a klucz główny to automatycznie `_id`. (slajd 085)

</details>

**2.92. Kiedy w MongoDB powstaje kolekcja `people`, jeśli nie utworzono jej jawnie?**

- A) Niejawnie przy pierwszej operacji `insertOne()` lub `insertMany()`
- B) Dopiero po wykonaniu `CREATE COLLECTION people`
- C) Przy pierwszym `find()` na tej kolekcji
- D) Nigdy, trzeba zawsze użyć `db.createCollection()`

<details><summary>Odpowiedź</summary>

**A** — kolekcja jest tworzona niejawnie przy pierwszym wstawieniu; `db.createCollection("people")` to opcja jawna. Samo `find()` kolekcji nie tworzy. (slajd 087)

</details>

**2.93. Które polecenie MongoDB jest odpowiednikiem `ALTER TABLE people ADD join_date DATETIME`?**

- A) `db.people.createIndex({ join_date: 1 })`
- B) `db.people.updateMany({}, { $unset: { join_date: "" } })`
- C) `db.people.updateMany({}, { $set: { join_date: new Date() } })`
- D) `db.people.alter({ add: "join_date" })`

<details><summary>Odpowiedź</summary>

**C** — kolekcje nie wymuszają struktury, ale `updateMany` z pustym filtrem i `$set` dodaje pole do istniejących dokumentów. `$unset` usuwa pole, a `alter` nie istnieje. (slajd 087)

</details>

**2.94. Które polecenie MongoDB odpowiada `ALTER TABLE people DROP COLUMN join_date`?**

- A) `db.people.updateMany({}, { $set: { join_date: null } })`
- B) `db.people.drop("join_date")`
- C) `db.people.deleteMany({ join_date: { $exists: true } })`
- D) `db.people.updateMany({}, { $unset: { "join_date": "" } })`

<details><summary>Odpowiedź</summary>

**D** — `$unset` usuwa pole z dokumentów. A ustawia null (pole zostaje), B usunęłoby kolekcję, C usunęłoby całe dokumenty. (slajd 088)

</details>

**2.95. Które polecenie MongoDB odpowiada `CREATE INDEX idx_user_id_asc_age_desc ON people(user_id, age DESC)`?**

- A) `db.people.createIndex({ user_id: -1, age: 1 })`
- B) `db.people.createIndex({ user_id: 1, age: -1 })`
- C) `db.people.createIndex({ user_id: 1 }, { age: "desc" })`
- D) `db.people.createIndex([ "user_id", "age DESC" ])`

<details><summary>Odpowiedź</summary>

**B** — 1 oznacza rosnąco (ASC), -1 malejąco (DESC); oba pola podaje się w jednym dokumencie, w kolejności indeksu. (slajd 088)

</details>

**2.96. Które polecenie MongoDB odpowiada `DROP TABLE people`?**

- A) `db.people.deleteMany({})`
- B) `db.dropDatabase("people")`
- C) `db.people.drop()`
- D) `db.people.remove({})`

<details><summary>Odpowiedź</summary>

**C** — `db.people.drop()` usuwa kolekcję. `deleteMany({})` i `remove({})` usuwają tylko dokumenty, a `dropDatabase()` usuwa całą bazę. (slajd 088)

</details>

**2.97. Jaki jest w MongoDB odpowiednik klucza głównego z SQL?**

- A) Dowolne pole wskazane w `db.createCollection()`
- B) Pole `_id`, ustawiane automatycznie
- C) Pierwsze pole dokumentu po `_id`
- D) Indeks złożony na wszystkich polach

<details><summary>Odpowiedź</summary>

**B** — w MongoDB kluczem głównym jest zawsze pole `_id`; jeśli go nie podasz, zostanie dodane automatycznie. (slajdy 085, 087)

</details>



## 3. MongoDB — CRUD, operatory zapytań, projekcja i modyfikatory kursora

### Powłoka mongosh, bazy danych i kolekcje

**3.1. Które polecenie w mongosh wyświetla listę wszystkich dostępnych baz danych?**

- A) `show collections`
- B) `db`
- C) `show dbs`
- D) `use admin`

<details><summary>Odpowiedź</summary>

**C** — `show dbs` (albo równoważnie `show databases`) wypisuje bazy. `show collections` pokazuje kolekcje bieżącej bazy, a samo `db` nazwę bieżącej bazy. (slajd 089)

</details>

**3.2. Która z baz widocznych w wyniku `show dbs` na slajdzie NIE jest bazą systemową?**

- A) `admin`
- B) `local`
- C) `config`
- D) `customers`

<details><summary>Odpowiedź</summary>

**D** — bazy systemowe to admin, config i local; customers to baza użytkownika. (slajd 089)

</details>

**3.3. Co robi polecenie `db.dropDatabase()`?**

- A) Usuwa bazę, której nazwę trzeba podać w nawiasie
- B) Usuwa bazę, w której aktualnie się znajdujemy
- C) Usuwa wszystkie bazy poza systemowymi
- D) Usuwa wszystkie kolekcje, ale zostawia pustą bazę na liście

<details><summary>Odpowiedź</summary>

**B** — `dropDatabase()` nie przyjmuje nazwy, kasuje bieżącą bazę; dlatego najpierw przełączamy się przez `use`. Wynik to np. `{ ok: 1, dropped: 'northwind' }`. (slajd 090)

</details>

**3.4. Które polecenie wyświetla nazwę bazy danych, w której aktualnie jesteśmy?**

- A) `db`
- B) `show db`
- C) `use`
- D) `show dbs`

<details><summary>Odpowiedź</summary>

**A** — samo `db` wypisuje bieżącą bazę. `show dbs` wypisuje listę wszystkich baz. (slajd 090)

</details>

**3.5. Jak w MongoDB tworzy się nową bazę danych?**

- A) `CREATE DATABASE shop`
- B) `db.createDatabase("shop")`
- C) `use shop`, a baza fizycznie powstaje przy pierwszym zapisie danych
- D) `show dbs shop`

<details><summary>Odpowiedź</summary>

**C** — slajd opisuje `use nazwa_bazy` jako „tworzenie/użycie bazy”. Baza pojawia się w `show dbs` dopiero, gdy zapiszemy do niej dane. Metody `createDatabase` nie ma. (slajd 090)

</details>

**3.6. Które polecenie usuwa kolekcję `products` razem z nią samą (a nie tylko jej dokumenty)?**

- A) `db.products.remove({})`
- B) `db.products.deleteMany({})`
- C) `db.dropDatabase("products")`
- D) `db.products.drop()`

<details><summary>Odpowiedź</summary>

**D** — `db.nazwa_kolekcji.drop()` kasuje kolekcję. `deleteMany({})` usuwa wszystkie dokumenty, ale kolekcja zostaje. (slajd 091)

</details>

**3.7. Uzupełnij polecenie tworzące kolekcję: `db.______("products")`**

- A) `newCollection`
- B) `createCollection`
- C) `addCollection`
- D) `insertCollection`

<details><summary>Odpowiedź</summary>

**B** — kolekcję tworzy się jawnie przez `db.createCollection("nazwa", {opcje})`. (slajd 091)

</details>

**3.8. Co dzieje się w kolekcji capped, gdy nowy dokument spowodowałby przekroczenie wartości `size`?**

- A) Najstarsze dokumenty są usuwane, aby zwolnić miejsce
- B) Wstawienie kończy się błędem
- C) Nowy dokument jest odrzucany bez komunikatu
- D) Kolekcja automatycznie zwiększa swój rozmiar

<details><summary>Odpowiedź</summary>

**A** — kolekcja capped działa jak bufor cykliczny: usuwa najstarsze dokumenty. (slajd 091)

</details>

**3.9. Który parametr jest obowiązkowy przy tworzeniu kolekcji z opcją `capped: true`?**

- A) `max`
- B) `validator`
- C) `size`
- D) `autoIndexId`

<details><summary>Odpowiedź</summary>

**C** — slajd: capped „wymaga parametru size”. `max` (limit liczby dokumentów) jest opcjonalny. (slajd 091)

</details>

**3.10. W jakiej jednostce podaje się opcję `size` w `db.createCollection("logi", { capped: true, size: 10485760 })`?**

- A) W kilobajtach
- B) W liczbie dokumentów
- C) W megabajtach
- D) W bajtach

<details><summary>Odpowiedź</summary>

**D** — `size` to maksymalny rozmiar w bajtach; 10485760 B = 10 MiB. Liczbę dokumentów ogranicza osobna opcja `max`. (slajd 091)

</details>

**3.11. Które polecenie, według pomocy `help` w mongosh, kończy pracę powłoki?**

- A) `.close`
- B) `.exit`
- C) `stop()`
- D) `disconnect`

<details><summary>Odpowiedź</summary>

**B** — pomoc podaje: „Quit the MongoDB shell with exit/exit()/.exit”. (slajd 089)

</details>

**3.12. Które polecenie daje ten sam wynik co `show collections`?**

- A) `show tables`
- B) `show dbs`
- C) `db.collections`
- D) `show profile`

<details><summary>Odpowiedź</summary>

**A** — pomoc mongosh: „'show collections'/'show tables': Print a list of all collections for current database”. (slajd 089)

</details>

**3.13. Na jakim porcie domyślnie nasłuchuje MongoDB (widać to w adresie połączenia mongosh na slajdzie)?**

- A) 3306
- B) 5432
- C) 27017
- D) 6379

<details><summary>Odpowiedź</summary>

**C** — adres `mongodb://127.0.0.1:27017/`. 3306 to MySQL, 5432 PostgreSQL, 6379 Redis. (slajd 089)

</details>

**3.14. Co tworzy polecenie `db.createCollection("logi", { capped: true, size: 10485760, max: 10000 })`?**

- A) Kolekcję o rozmiarze 10 000 bajtów
- B) Zwykłą kolekcję z indeksem na 10 000 dokumentów
- C) Kolekcję, która odrzuci 10 001. dokument błędem
- D) Kolekcję o ograniczonym rozmiarze (ok. 10 MiB) i liczbie dokumentów (10 000), z której wypadają najstarsze dokumenty

<details><summary>Odpowiedź</summary>

**D** — `size` ogranicza bajty, `max` liczbę dokumentów; po osiągnięciu limitu usuwane są najstarsze dokumenty. (slajd 091)

</details>

### Wstawianie i liczenie dokumentów

**3.15. Które polecenie poprawnie wstawia dwa dokumenty jednym wywołaniem?**

- A) `db.c.insertOne({a: 1}, {a: 2})`
- B) `db.c.insertMany({a: 1}, {a: 2})`
- C) `db.c.insertOne([{a: 1}, {a: 2}])`
- D) `db.c.insertMany([{a: 1}, {a: 2}])`

<details><summary>Odpowiedź</summary>

**D** — `insertMany()` przyjmuje tablicę (listę) dokumentów w nawiasach kwadratowych. `insertOne()` przyjmuje jeden dokument. (slajd 092)

</details>

**3.16. Co się stanie po wywołaniu `db.nowa.insertOne({x: 1})`, gdy kolekcja `nowa` nie istnieje?**

- A) Błąd: kolekcja nie istnieje
- B) Kolekcja zostanie utworzona, a dokument wstawiony
- C) Trzeba najpierw wywołać `db.createCollection("nowa")`
- D) Dokument trafi do kolekcji `test`

<details><summary>Odpowiedź</summary>

**B** — `insertOne()` i `insertMany()` tworzą kolekcję, jeżeli ta nie istnieje. (slajd 092, 094)

</details>

**3.17. Które zdanie o `insertMany()` jest zgodne z wykładem?**

- A) Jest zawsze atomowe dla wszystkich wstawianych dokumentów
- B) Wymaga wcześniejszego utworzenia kolekcji
- C) Jest zwykle wydajniejsze niż wielokrotne wywoływanie `insertOne()`
- D) Przyjmuje dokumenty jako osobne argumenty, bez tablicy

<details><summary>Odpowiedź</summary>

**C** — slajd: insertMany jest zwykle bardziej wydajne przy większej liczbie dokumentów (mniej podróży do serwera). Atomowość dotyczy tylko pojedynczego dokumentu. (slajd 092)

</details>

**3.18. Która metoda podaje przybliżoną liczbę dokumentów na podstawie metadanych kolekcji, bez żadnego filtra?**

- A) `countDocuments()`
- B) `count({})`
- C) `distinct()`
- D) `estimatedDocumentCount()`

<details><summary>Odpowiedź</summary>

**D** — `estimatedDocumentCount()` korzysta z metadanych i jest szybsza; `countDocuments()` liczy dokładnie i przyjmuje filtr. (slajd 093)

</details>

**3.19. Jak policzyć dokładnie dokumenty kolekcji `inventory` ze statusem `"A"`?**

- A) `db.inventory.countDocuments({ status: "A" })`
- B) `db.inventory.estimatedDocumentCount({ status: "A" })`
- C) `db.inventory.count.status("A")`
- D) `db.inventory.find().size("A")`

<details><summary>Odpowiedź</summary>

**A** — `countDocuments()` liczy na podstawie filtra. `estimatedDocumentCount()` nie stosuje filtrów. (slajd 093)

</details>

**3.20. Dokończ zdanie z wykładu: „Wszystkie operacje zapisu w MongoDB są atomowe na poziomie…”**

- A) całej kolekcji
- B) pojedynczego dokumentu
- C) całej bazy danych
- D) pojedynczego pola

<details><summary>Odpowiedź</summary>

**B** — zapis jest atomowy na poziomie jednego dokumentu (z jego poddokumentami); operacja na wielu dokumentach jako całość atomowa nie jest. (slajd 094, 097, 107)

</details>

**3.21. Co się dzieje, gdy we wstawianym dokumencie pominięto pole `_id`?**

- A) Wstawienie kończy się błędem
- B) Dokument jest zapisywany bez identyfikatora
- C) Sterownik automatycznie generuje dla `_id` wartość typu ObjectId
- D) `_id` dostaje kolejną liczbę całkowitą, jak AUTO_INCREMENT

<details><summary>Odpowiedź</summary>

**C** — każdy dokument wymaga unikalnego `_id` (klucz podstawowy); gdy go brak, generowany jest ObjectId. (slajd 096)

</details>

**3.22. Które polecenie MongoDB odpowiada `INSERT INTO people(user_id, age, status) VALUES ("bcd001", 45, "A")`?**

- A) `db.people.insert("bcd001", 45, "A")`
- B) `db.people.insertMany({ user_id: "bcd001", age: 45, status: "A" })`
- C) `db.people.add({ user_id: "bcd001", age: 45, status: "A" })`
- D) `db.people.insertOne({ user_id: "bcd001", age: 45, status: "A" })`

<details><summary>Odpowiedź</summary>

**D** — jeden wiersz to jeden dokument wstawiany przez `insertOne()`; `insertMany()` wymaga tablicy. (slajd 095)

</details>

**3.23. Na diagramie z dokumentacji dla `db.users.insertOne({ name: "sue", age: 26, status: "pending" })` jak nazwano element `name: "sue"`?**

- A) field: value
- B) document
- C) collection
- D) query criteria

<details><summary>Odpowiedź</summary>

**A** — każda para to „field: value”, całość w klamrach to „document”, a `users` to „collection”. (slajd 094)

</details>

### Aktualizacja dokumentów

**3.24. Na diagramie `db.users.updateMany({ age: { $lt: 18 } }, { $set: { status: "reject" } })` jak nazywa się drugi argument?**

- A) update filter
- B) update action
- C) projection
- D) cursor modifier

<details><summary>Odpowiedź</summary>

**B** — pierwszy argument to „update filter”, drugi `{ $set: ... }` to „update action”. (slajd 097)

</details>

**3.25. Które polecenie odpowiada `UPDATE people SET status = "C" WHERE age > 25`?**

- A) `db.people.updateOne({ age: { $gt: 25 } }, { status: "C" })`
- B) `db.people.updateMany({ status: "C" }, { $set: { age: { $gt: 25 } } })`
- C) `db.people.updateMany({ age: { $gt: 25 } }, { $set: { status: "C" } })`
- D) `db.people.update({ $set: { status: "C" } }, { age: { $gt: 25 } })`

<details><summary>Odpowiedź</summary>

**C** — WHERE trafia do filtra (pierwszy argument), SET do `$set` (drugi argument); UPDATE bez ograniczeń zmienia wszystkie pasujące wiersze, więc `updateMany`. (slajd 098)

</details>

**3.26. Które polecenie odpowiada `UPDATE people SET age = age + 3 WHERE status = "A"`?**

- A) `db.people.updateMany({ status: "A" }, { $set: { age: 3 } })`
- B) `db.people.updateMany({ status: "A" }, { $mul: { age: 3 } })`
- C) `db.people.updateMany({ status: "A" }, { $add: { age: 3 } })`
- D) `db.people.updateMany({ status: "A" }, { $inc: { age: 3 } })`

<details><summary>Odpowiedź</summary>

**D** — `$inc` zwiększa wartość o podaną liczbę. `$set` ustawiłby 3, `$mul` pomnożyłby przez 3, a `$add` to wyrażenie agregacji, nie operator aktualizacji. (slajd 098)

</details>

**3.27. Czym różni się `updateOne()` od `updateMany()`?**

- A) `updateOne()` zmienia tylko pierwszy dokument pasujący do filtra, `updateMany()` wszystkie pasujące
- B) `updateOne()` zmienia jedno pole, `updateMany()` wiele pól
- C) `updateOne()` nie przyjmuje filtra
- D) `updateMany()` zastępuje dokumenty w całości

<details><summary>Odpowiedź</summary>

**A** — liczba w nazwie dotyczy dokumentów, nie pól; jednym `$set` można zmienić wiele pól w obu metodach. (slajd 097, 100)

</details>

**3.28. Która metoda zastępuje cały dokument nowym, zachowując jedynie `_id`?**

- A) `updateOne()`
- B) `replaceOne()`
- C) `updateMany()`
- D) `findOneAndUpdate()`

<details><summary>Odpowiedź</summary>

**B** — `replaceOne(filtr, nowyDokument)`; pola, których nie ma w nowym dokumencie, znikają. (slajd 097, 099)

</details>

**3.29. Dokument ma pole `size: { h: 28, w: 35.5, uom: "in" }`. Które polecenie zmieni TYLKO jednostkę na `"cm"`, zostawiając `h` i `w`?**

- A) `{ $set: { size: { uom: "cm" } } }`
- B) `{ $set: { size.uom: "cm" } }`
- C) `{ $set: { "size.uom": "cm" } }`
- D) `{ $replace: { "size.uom": "cm" } }`

<details><summary>Odpowiedź</summary>

**C** — notacja kropkowa w cudzysłowie zmienia jedno pole poddokumentu. Wariant A nadpisuje cały poddokument `size`, a B bez cudzysłowu to błąd składni JavaScript. (slajd 099)

</details>

**3.30. W jakiej kolejności przyjmuje parametry `db.collection.updateOne()`?**

- A) `<update>, <filter>, <options>`
- B) `<options>, <filter>, <update>`
- C) `<filter>, <options>, <update>`
- D) `<filter>, <update>, <options>`

<details><summary>Odpowiedź</summary>

**D** — najpierw filtr, potem modyfikacje, na końcu opcjonalne opcje (np. `upsert`). (slajd 100)

</details>

**3.31. Według slajdu o trybach „zmień / zamień”, kiedy zachodzi tryb ZAMIEŃ?**

- A) Gdy parametr update nie zawiera operatorów: cały dokument jest zamieniany, identyfikator zachowany
- B) Gdy parametr update zawiera wyłącznie operatory
- C) Gdy w update użyto `$set` z całym dokumentem
- D) Gdy podano opcję `replace: true`

<details><summary>Odpowiedź</summary>

**A** — brak operatorów oznacza zamianę, same operatory oznaczają zmianę. Uwaga: we współczesnym mongosh `updateOne()` bez operatorów zwraca błąd, a zamianę wykonuje się przez `replaceOne()`. (slajd 101)

</details>

**3.32. Które polecenie poprawnie ustawia dwa pola, `email` i `phone`, jednym wywołaniem?**

- A) `{ $set: { email: "a@b.pl" }, $set: { phone: "123" } }`
- B) `{ $set: { email: "a@b.pl", phone: "123" } }`
- C) `{ $set: [ { email: "a@b.pl" }, { phone: "123" } ] }`
- D) `{ email: "a@b.pl", $set: { phone: "123" } }`

<details><summary>Odpowiedź</summary>

**B** — każdy operator może wystąpić tylko raz, więc wszystkie pola wpisuje się w jeden `$set`. W A drugi klucz `$set` nadpisze pierwszy, a D miesza tryby. (slajd 101, 102)

</details>

**3.33. Co robi `db.users.updateOne({ _id: 1 }, { $unset: { phone: "" } })`?**

- A) Ustawia pole `phone` na pusty tekst
- B) Ustawia pole `phone` na `null`
- C) Usuwa pole `phone` z dokumentu
- D) Usuwa cały dokument, jeśli `phone` jest pusty

<details><summary>Odpowiedź</summary>

**C** — `$unset` usuwa zadane pole; wartość (tu `""`) nie ma znaczenia. (slajd 102)

</details>

**3.34. Jaki skutek ma `{ $rename: { username: "login" } }`?**

- A) Tworzy nowe pole `login` i zostawia `username`
- B) Zmienia wartość pola `username` na tekst `"login"`
- C) Zmienia nazwę pola `login` na `username`
- D) Zmienia nazwę pola `username` na `login`

<details><summary>Odpowiedź</summary>

**D** — po lewej stara nazwa, po prawej nowa. (slajd 102)

</details>

**3.35. Jak zmniejszyć pole `stock` o 5?**

- A) `{ $inc: { stock: -5 } }`
- B) `{ $dec: { stock: 5 } }`
- C) `{ $mul: { stock: -5 } }`
- D) `{ $set: { stock: -5 } }`

<details><summary>Odpowiedź</summary>

**A** — `$inc` przyjmuje też liczby ujemne; operatora `$dec` nie ma. `$mul` z -5 pomnożyłby, a `$set` ustawiłby -5. (slajd 103)

</details>

**3.36. Co zrobi `db.products.updateOne({ _id: 1 }, { $mul: { price: 1.2 } })`?**

- A) Ustawi cenę na 1.2
- B) Zwiększy cenę o 20%
- C) Zwiększy cenę o 1.2
- D) Zaokrągli cenę do 1 miejsca po przecinku

<details><summary>Odpowiedź</summary>

**B** — `$mul` mnoży wartość pola przez mnożnik; mnożenie przez 1.2 to wzrost o 20%. (slajd 103)

</details>

**3.37. Jaki typ wartości zapisze `{ $currentDate: { lastLogin: true } }`?**

- A) Timestamp
- B) Tekst z datą
- C) Date (data i godzina)
- D) Liczbę milisekund jako int

<details><summary>Odpowiedź</summary>

**C** — `true` ustawia typ Date; to samo co jawne `{ $type: "date" }`. (slajd 103)

</details>

**3.38. Które polecenie zapisze w polu `lastUpdated` wartość typu Timestamp?**

- A) `{ $currentDate: { lastUpdated: true } }`
- B) `{ $set: { lastUpdated: "timestamp" } }`
- C) `{ $currentDate: { lastUpdated: "timestamp" } }`
- D) `{ $currentDate: { lastUpdated: { $type: "timestamp" } } }`

<details><summary>Odpowiedź</summary>

**D** — typ wybiera się dokumentem `{ $type: "timestamp" }` albo `{ $type: "date" }`; samo `true` daje Date. (slajd 103)

</details>

**3.39. Który z wymienionych NIE jest operatorem aktualizacji pól omówionym na wykładzie?**

- A) `$set`
- B) `$inc`
- C) `$gte`
- D) `$rename`

<details><summary>Odpowiedź</summary>

**C** — `$gte` to operator zapytania (porównania). Operatory pól to `$set`, `$unset`, `$rename`, `$inc`, `$mul`, `$currentDate`. (slajd 102, 103)

</details>

### Operatory tablicowe w aktualizacji i tryb upsert

**3.40. Dokument ma `tags: ["mongodb", "database"]`. Jaka będzie tablica po `{ $push: { tags: "newTag" } }`?**

- A) `["newTag", "mongodb", "database"]`
- B) `["mongodb", "database", "newTag"]`
- C) `["newTag"]`
- D) `["mongodb", "database", ["newTag"]]`

<details><summary>Odpowiedź</summary>

**B** — `$push` dodaje element na koniec tablicy. (slajd 104)

</details>

**3.41. Dokument ma `tags: ["mongodb", "uniqueTag"]`. Co zrobi `{ $addToSet: { tags: "uniqueTag" } }`?**

- A) Doda drugi element `"uniqueTag"` na koniec
- B) Zwróci błąd duplikatu
- C) Usunie istniejący `"uniqueTag"`
- D) Nic nie zmieni, bo duplikaty są ignorowane

<details><summary>Odpowiedź</summary>

**D** — `$addToSet` działa jak `$push`, ale pomija wartości, które już są w tablicy. (slajd 104)

</details>

**3.42. Które polecenie doda do tablicy `tags` DWA osobne elementy, `"tag1"` i `"tag2"`?**

- A) `{ $push: { tags: { $each: ["tag1", "tag2"] } } }`
- B) `{ $push: { tags: ["tag1", "tag2"] } }`
- C) `{ $push: { tags: "tag1", tags: "tag2" } }`
- D) `{ $set: { tags: { $each: ["tag1", "tag2"] } } }`

<details><summary>Odpowiedź</summary>

**A** — wiele elementów dodaje się modyfikatorem `$each`. Wariant B doda jeden element będący tablicą, C ma zdublowany klucz, a `$each` nie działa z `$set`. (slajd 104)

</details>

**3.43. Co trafi do tablicy po `{ $push: { tags: ["tag1", "tag2"] } }` (bez `$each`)?**

- A) Dwa osobne elementy `"tag1"` i `"tag2"`
- B) Nic, polecenie zwróci błąd
- C) Jeden element, który jest tablicą `["tag1", "tag2"]`
- D) Tablica `tags` zostanie zastąpiona tablicą `["tag1", "tag2"]`

<details><summary>Odpowiedź</summary>

**C** — bez `$each` `$push` dopisuje podaną wartość w całości, czyli powstaje tablica zagnieżdżona. (slajd 104)

</details>

**3.44. Dokument ma `roles: ["user", "editor", "admin"]`. Co usunie `{ $pop: { roles: 1 } }`?**

- A) `"admin"`
- B) `"user"`
- C) `"editor"`
- D) Wszystkie elementy

<details><summary>Odpowiedź</summary>

**A** — `$pop` z `1` usuwa ostatni element, z `-1` pierwszy. (slajd 105)

</details>

**3.45. Jaką wartość przy `$pop` podajemy, aby usunąć PIERWSZY element tablicy?**

- A) `0`
- B) `-1`
- C) `1`
- D) `"first"`

<details><summary>Odpowiedź</summary>

**B** — `-1` usuwa pierwszy element, `1` ostatni. (slajd 105)

</details>

**3.46. Co robi `db.users.updateOne({ _id: 2 }, { $pull: { roles: /^m/ } })`?**

- A) Usuwa pierwszy element tablicy `roles`
- B) Usuwa tylko pierwszy element zaczynający się od „m”
- C) Usuwa pole `roles`, jeśli zaczyna się od „m”
- D) Usuwa z `roles` wszystkie elementy zaczynające się od litery „m”

<details><summary>Odpowiedź</summary>

**D** — `$pull` usuwa wszystkie elementy spełniające wzorzec; tu wzorcem jest wyrażenie regularne `/^m/`. (slajd 105)

</details>

**3.47. Które zdanie trafnie odróżnia `$pop` od `$pull`?**

- A) `$pop` usuwa po wartości, `$pull` po pozycji
- B) `$pop` usuwa pierwszy albo ostatni element, `$pull` wszystkie elementy pasujące do wartości lub warunku
- C) Oba usuwają tylko jeden element
- D) `$pull` działa tylko z wyrażeniami regularnymi

<details><summary>Odpowiedź</summary>

**B** — `$pop` patrzy na pozycję (1 lub -1), `$pull` na wartość, dokument albo warunek zapytania. (slajd 105)

</details>

**3.48. Co się stanie przy aktualizacji z opcją `{ upsert: true }`, gdy żaden dokument nie pasuje do filtra?**

- A) Operacja zwróci błąd
- B) Zaktualizowane zostaną wszystkie dokumenty kolekcji
- C) Zostanie wstawiony nowy dokument
- D) Nic się nie stanie

<details><summary>Odpowiedź</summary>

**C** — upsert = update + insert: gdy nic nie zostało zmodyfikowane, wstawiany jest nowy dokument. (slajd 106)

</details>

**3.49. Kolekcja `users` jest pusta. Jaki dokument powstanie po `db.users.updateOne({ name: "Alice" }, { $set: { age: 30 } }, { upsert: true })`?**

- A) `{ _id: ..., age: 30 }`
- B) `{ _id: ..., name: "Alice" }`
- C) Żaden, bo kolekcja jest pusta
- D) `{ _id: ..., name: "Alice", age: 30 }`

<details><summary>Odpowiedź</summary>

**D** — w trybie update nowy dokument zawiera pola z filtra (query) oraz efekt operatorów z update; `_id` jest tworzone. (slajd 106)

</details>

**3.50. Co zawiera dokument wstawiony przez upsert w trybie replace (np. `replaceOne(..., { upsert: true })`)?**

- A) Wszystkie pola z parametru update (dokumentu zastępczego), plus `_id`
- B) Tylko pola z filtra
- C) Pola z filtra i z dokumentu zastępczego, a `_id` zawsze nowe
- D) Pusty dokument z samym `_id`

<details><summary>Odpowiedź</summary>

**A** — slajd: w trybie replace dokument zawiera wszystkie pola z parametru update; `_id` jest zachowane (np. z filtra) lub tworzone. (slajd 106)

</details>

**3.51. Nie ma dokumentu z `_id: 10`. Co powstanie po `db.users.replaceOne({ _id: 10 }, { name: "Nowy", age: 25 }, { upsert: true })`?**

- A) Dokument z nowym ObjectId, `name: "Nowy"`, `age: 25`
- B) `{ _id: 10, name: "Nowy", age: 25 }`
- C) `{ _id: 10 }`
- D) Błąd, bo replaceOne nie obsługuje upsert

<details><summary>Odpowiedź</summary>

**B** — pole `_id` jest zachowane z filtra, a reszta pochodzi z dokumentu zastępczego. (slajd 106)

</details>

**3.52. W którym miejscu podaje się opcję upsert w `updateOne`?**

- A) W filtrze: `{ name: "Alice", upsert: true }`
- B) W dokumencie update: `{ $set: { age: 30 }, upsert: true }`
- C) Jako trzeci argument: `{ upsert: true }`
- D) Jako osobną metodę: `.upsert()`

<details><summary>Odpowiedź</summary>

**C** — upsert to opcja, czyli trzeci parametr `<options>`. (slajd 100, 106)

</details>

**3.53. Ile dokumentów wstawi `db.users.updateMany({ status: "active" }, { $set: { verified: true } }, { upsert: true })`, gdy żaden dokument nie ma statusu `"active"`?**

- A) Jeden
- B) Zero
- C) Tyle, ile dokumentów jest w kolekcji
- D) Dwa: jeden z filtra i jeden z update

<details><summary>Odpowiedź</summary>

**A** — upsert wstawia najwyżej jeden nowy dokument (tu `{ status: "active", verified: true }`), także przy `updateMany`. (slajd 106)

</details>

### Usuwanie dokumentów, findOneAndDelete, findAndModify i bulkWrite

**3.54. Które polecenie usuwa wszystkie dokumenty z kolekcji `inventory`, ale zostawia samą kolekcję?**

- A) `db.inventory.drop()`
- B) `db.inventory.deleteOne({})`
- C) `db.inventory.deleteMany()`
- D) `db.inventory.deleteMany({})`

<details><summary>Odpowiedź</summary>

**D** — `deleteMany({})` z pustym filtrem usuwa wszystkie dokumenty. `drop()` kasuje kolekcję, a `deleteOne({})` usuwa jeden dokument. (slajd 108)

</details>

**3.55. Które polecenie odpowiada `DELETE FROM people WHERE status = "D"`?**

- A) `db.people.deleteMany({ status: "D" })`
- B) `db.people.drop({ status: "D" })`
- C) `db.people.remove("status", "D")`
- D) `db.people.deleteOne({ status: "D" })`

<details><summary>Odpowiedź</summary>

**A** — DELETE z WHERE usuwa wszystkie pasujące wiersze, więc `deleteMany`. `deleteOne` usunąłby tylko jeden. (slajd 109)

</details>

**3.56. Do `{ status: "D" }` pasuje 5 dokumentów. Ile usunie `db.inventory.deleteOne({ status: "D" })`?**

- A) Wszystkie 5
- B) Jeden, pierwszy pasujący
- C) Zero, bo pasuje więcej niż jeden
- D) Polecenie zwróci błąd

<details><summary>Odpowiedź</summary>

**B** — slajd: „Usuń tylko jeden dokument spełniający warunek”. (slajd 108)

</details>

**3.57. Na diagramie `db.users.deleteMany({ status: "reject" })` jak nazwano `{ status: "reject" }`?**

- A) update filter
- B) projection
- C) delete filter
- D) cursor modifier

<details><summary>Odpowiedź</summary>

**C** — dla usuwania jest to „delete filter”; filtry używają tej samej składni co odczyt. (slajd 107)

</details>

**3.58. Czym `findOneAndDelete()` różni się od `deleteOne()`?**

- A) Usuwa wszystkie pasujące dokumenty
- B) Nie przyjmuje filtra
- C) Usuwa kolekcję, jeśli jest pusta
- D) Zwraca usunięty dokument i pozwala opcją `sort` wybrać, który zostanie usunięty

<details><summary>Odpowiedź</summary>

**D** — slajd: metoda usuwa jeden dokument, zwraca go i udostępnia opcję sortowania. (slajd 110)

</details>

**3.59. Który dokument usunie `db.collection.findOneAndDelete({ status: "inactive" }, { sort: { lastLogin: 1 } })`?**

- A) Nieaktywnego użytkownika z najdawniejszą datą `lastLogin`
- B) Nieaktywnego użytkownika z najnowszą datą `lastLogin`
- C) Wszystkich nieaktywnych
- D) Losowego nieaktywnego użytkownika

<details><summary>Odpowiedź</summary>

**A** — sortowanie rosnące (`1`) stawia na początku najstarszą datę, a usuwany jest pierwszy dokument po posortowaniu. (slajd 110)

</details>

**3.60. Jakie pole trzeba ustawić w `findAndModify()`, aby usunąć dokument?**

- A) `delete: 1`
- B) `drop: true`
- C) `remove: true`
- D) `new: false`

<details><summary>Odpowiedź</summary>

**C** — slajd: „Aby usunąć dokument, należy ustawić remove: true”. `new` decyduje, czy zwrócić dokument po zmianie. (slajd 110)

</details>

**3.61. Która składnia `findAndModify()` jest poprawna?**

- A) `db.c.findAndModify({ status: "inactive" }, { sort: { lastLogin: 1 } }, { remove: true })`
- B) `db.c.findAndModify({ query: { status: "inactive" }, sort: { lastLogin: 1 }, remove: true })`
- C) `db.c.findAndModify("remove", { status: "inactive" })`
- D) `db.c.find({ status: "inactive" }).modify({ remove: true })`

<details><summary>Odpowiedź</summary>

**B** — `findAndModify()` przyjmuje jeden dokument z polami `query`, `sort`, `remove` (albo `update`). (slajd 110)

</details>

**3.62. Jak zachowuje się `bulkWrite()` w trybie uporządkowanym (ordered), gdy jedna operacja zgłosi błąd?**

- A) Kontynuuje pozostałe operacje
- B) Cofa wszystkie wcześniejsze operacje
- C) Ponawia błędną operację do skutku
- D) Kończy i nie przetwarza pozostałych operacji z listy

<details><summary>Odpowiedź</summary>

**D** — przy liście uporządkowanej operacje idą szeregowo, a błąd przerywa resztę. Wcześniejsze operacje nie są cofane. (slajd 111)

</details>

**3.63. Co oznacza opcja `{ ordered: false }` w `bulkWrite()`?**

- A) Operacje mogą być wykonywane równolegle, a błąd jednej nie zatrzymuje pozostałych
- B) Operacje są wykonywane w kolejności alfabetycznej
- C) Wszystkie operacje wykonują się jako jedna transakcja
- D) Operacje wykonują się szeregowo i zatrzymują na pierwszym błędzie

<details><summary>Odpowiedź</summary>

**A** — w trybie nieuporządkowanym MongoDB może działać równolegle (bez gwarancji) i kontynuuje po błędzie. Domyślnie `ordered` jest `true`. (slajd 111)

</details>

**3.64. Która operacja NIE należy do sześciu operacji obsługiwanych przez `bulkWrite()`?**

- A) `replaceOne`
- B) `deleteMany`
- C) `updateMany`
- D) `insertMany`

<details><summary>Odpowiedź</summary>

**D** — bulkWrite obsługuje insertOne, updateOne, updateMany, replaceOne, deleteOne i deleteMany. Wiele wstawień to wiele `insertOne`. (slajd 111)

</details>

**3.65. Jak nazywa się pole z nowym dokumentem w operacji `replaceOne` wewnątrz `bulkWrite()`?**

- A) `document`
- B) `replacement`
- C) `update`
- D) `newDoc`

<details><summary>Odpowiedź</summary>

**B** — `{ replaceOne: { filter: {...}, replacement: {...} } }`. `document` jest w `insertOne`, `update` w `updateOne`. (slajd 112)

</details>

**3.66. Uzupełnij operację w `bulkWrite()`: `{ insertOne: { ______: { _id: 3, type: "beef" } } }`**

- A) `filter`
- B) `doc`
- C) `document`
- D) `replacement`

<details><summary>Odpowiedź</summary>

**C** — `insertOne` w bulkWrite ma pole `document`. (slajd 112)

</details>

**3.67. Którego zakresu dotyczy pojedyncze wywołanie `bulkWrite()`?**

- A) Pojedynczej kolekcji
- B) Wszystkich kolekcji w bazie
- C) Wielu baz naraz
- D) Tylko kolekcji capped

<details><summary>Odpowiedź</summary>

**A** — slajd: „Operacje zapisu zbiorczego dotyczą pojedynczej kolekcji”. (slajd 111)

</details>

### Wyszukiwanie: find, selekcja i notacja kropkowa

**3.68. Jakie dwa parametry przyjmuje `db.collection.find()` i w jakiej kolejności?**

- A) projection, query
- B) query, sort
- C) filter, options
- D) query, projection

<details><summary>Odpowiedź</summary>

**D** — `find(query, projection)`, oba opcjonalne; sortowanie to modyfikator kursora. (slajd 113)

</details>

**3.69. W jakiej postaci `find()` zwraca dopasowane dokumenty?**

- A) Jako tablicę JSON
- B) Jako kursor
- C) Jako jeden dokument
- D) Jako liczbę dokumentów

<details><summary>Odpowiedź</summary>

**B** — wyniki zwraca kursor, który pozwala na dalsze operacje, np. sortowanie. (slajd 113)

</details>

**3.70. Które zapytanie jest równoważne `db.movies.find()`?**

- A) `db.movies.find(null, {})`
- B) `db.movies.findAll()`
- C) `db.movies.find({ })`
- D) `db.movies.find({ _id: 0 })`

<details><summary>Odpowiedź</summary>

**C** — pusty filtr `{ }` oznacza brak warunków i zwraca wszystkie dokumenty. (slajd 114)

</details>

**3.71. Które zapytanie wybiera filmy nakręcone między 2005 a 2015 rokiem włącznie?**

- A) `db.movies.find({ year: { $gt: 2005, $lt: 2015 } })`
- B) `db.movies.find({ year: { $gte: 2005, $lte: 2015 } })`
- C) `db.movies.find({ year: [2005, 2015] })`
- D) `db.movies.find({ year: { $in: [2005, 2015] } })`

<details><summary>Odpowiedź</summary>

**B** — `$gte` i `$lte` przy jednym polu tworzą przedział domknięty. `$in` wybrałby tylko lata 2005 i 2015, a A wyklucza końce. (slajd 114)

</details>

**3.72. Jak łączone są warunki w `db.movies.find({ year: 2000, rating: { $gt: 1 } })`?**

- A) Logicznym AND
- B) Logicznym OR
- C) Logicznym NOR
- D) Brany jest tylko pierwszy warunek

<details><summary>Odpowiedź</summary>

**A** — warunki rozdzielone przecinkiem w jednym dokumencie filtra łączy niejawne „i”. (slajd 114)

</details>

**3.73. Na diagramie `db.users.find({ age: { $gt: 18 } }, { name: 1, address: 1 }).limit(5)` jak nazwano `.limit(5)`?**

- A) query criteria
- B) projection
- C) collection
- D) cursor modifier

<details><summary>Odpowiedź</summary>

**D** — części to: collection, query criteria, projection i cursor modifier. (slajd 115, 136)

</details>

**3.74. Według wykładu, kiedy spełniony jest warunek równości dla pola tablicowego, np. `{ tablica: [10, 2, 3] }`?**

- A) Gdy tablica zawiera te elementy w dowolnej kolejności
- B) Gdy tablica ma te same elementy, w tej samej liczbie i kolejności
- C) Gdy tablica zawiera co najmniej jeden z elementów
- D) Gdy tablica ma trzy elementy

<details><summary>Odpowiedź</summary>

**B** — dla tablic liczy się liczba i porządek elementów; `[3, 2, 10]` ani `[10, 2, 3, 4]` nie pasują. (slajd 117)

</details>

**3.75. W bazie jest dokument `{ director: { lastName: "Stallone", firstName: "Sylwester" } }`. Co zwróci `db.movies1.find({ director: { firstName: "Sylwester", lastName: "Stallone" } })`?**

- A) Ten dokument, bo wartości się zgadzają
- B) Błąd składni
- C) Nic, bo kolejność pól poddokumentu jest inna
- D) Wszystkie dokumenty z polem `director`

<details><summary>Odpowiedź</summary>

**C** — równość całego poddokumentu wymaga zgodności nazw, wartości, liczby i kolejności pól; konsola na slajdzie pokazuje pusty wynik. (slajd 117, 118)

</details>

**3.76. Jak w notacji kropkowej odwołać się do TRZECIEGO elementu tablicy `actors`?**

- A) `"actors[3]"`
- B) `"actors.3"`
- C) `"actors[2]"`
- D) `"actors.2"`

<details><summary>Odpowiedź</summary>

**D** — notacja to `pole.indeks`, a indeksowanie zaczyna się od zera, więc trzeci element to `actors.2`. (slajd 119)

</details>

**3.77. Które zapytanie zwróci dokumenty, w których poddokument `out1` ma pole `a` równe `"a1"`?**

- A) `db.movies1.find({ "out1.a": "a1" })`
- B) `db.movies1.find({ out1.a: "a1" })`
- C) `db.movies1.find({ out1: "a1" })`
- D) `db.movies1.find({ out1: { $a: "a1" } })`

<details><summary>Odpowiedź</summary>

**A** — wyrażenie z kropką musi być w cudzysłowie; bez niego (B) JavaScript zgłosi błąd składni. (slajd 119)

</details>

**3.78. Jaka jest przewaga zapytania `{ "director.firstName": "Sylwester", "director.lastName": "Stallone" }` nad porównaniem całego poddokumentu `director`?**

- A) Działa szybciej, bo nie korzysta z indeksów
- B) Nie zależy od kolejności pól ani od innych pól poddokumentu
- C) Ignoruje wielkość liter w nazwach pól
- D) Zwraca tylko pole `director`

<details><summary>Odpowiedź</summary>

**B** — notacja kropkowa sprawdza pojedyncze pola, więc kolejność i dodatkowe pola nie przeszkadzają. Nazwy pól nadal rozróżniają wielkość liter. (slajd 120)

</details>

**3.79. Według slajdu o selekcji, jaki może być najwyższy poziom wyrażenia boolowskiego w parametrze query?**

- A) Jeden operator logiczny najwyższego poziomu: `$and` albo `$or`
- B) Wyłącznie `$not`
- C) Wyłącznie `$expr`
- D) Dowolna liczba operatorów `$not` rozdzielonych przecinkami

<details><summary>Odpowiedź</summary>

**A** — slajd: „Wyrażenie boolowskie z jednym operatorem logicznym najwyższego poziomu: $and, $or”. (slajd 116)

</details>

### Przegląd operatorów zapytań i operatory porównania

**3.80. Co oznacza operator `$nor`?**

- A) Co najmniej jeden warunek musi być prawdziwy
- B) Wszystkie warunki muszą być prawdziwe
- C) Żaden z warunków nie może być prawdziwy
- D) Neguje jeden operator przy polu

<details><summary>Odpowiedź</summary>

**C** — `$nor`: „żaden z warunków nie może być prawdziwy”. A to `$or`, B to `$and`, D to `$not`. (slajd 121, 126)

</details>

**3.81. Do której grupy operatorów należą `$exists` i `$type`?**

- A) Operatory porównania
- B) Operatory logiczne
- C) Operatory tablicowe
- D) Operatory elementów (Element Operators)

<details><summary>Odpowiedź</summary>

**D** — operatory elementów szukają po istnieniu pola i typie BSON. Slajd 122 podkreśla, że `$exists` nie jest operatorem porównania. (slajd 121, 122)

</details>

**3.82. Który operator należy do grupy operatorów geograficznych (Geospatial)?**

- A) `$geoWithin`
- B) `$elemMatch`
- C) `$bitsAnySet`
- D) `$jsonSchema`

<details><summary>Odpowiedź</summary>

**A** — `$geoWithin` („w obszarze”). `$elemMatch` jest tablicowy, `$bitsAnySet` bitowy, `$jsonSchema` na planszy trafił do operatorów różnych. (slajd 121)

</details>

**3.83. Co sprawdza operator bitowy `$bitsAllSet`?**

- A) Czy co najmniej jeden wskazany bit jest ustawiony
- B) Czy wszystkie wskazane bity są ustawione
- C) Czy wszystkie wskazane bity są wyzerowane
- D) Czy liczba jest potęgą dwójki

<details><summary>Odpowiedź</summary>

**B** — A to `$bitsAnySet`, C to `$bitsAllClear`. (slajd 121)

</details>

**3.84. W której grupie umieszczono `$expr` na planszy z wykładu „Operatory zapytań w MongoDB”?**

- A) Operatory porównania
- B) Operatory tablicowe
- C) Operatory logiczne
- D) Operatory bitowe

<details><summary>Odpowiedź</summary>

**C** — plansza wymienia `$expr` wśród operatorów logicznych („umożliwia użycie wyrażeń agregujących w zapytaniach”). Uwaga: w dokumentacji MongoDB `$expr` należy do operatorów ewaluacji (evaluation). (slajd 121)

</details>

**3.85. Którego operatora jest skrótem zapis `{ pole: wartość }`?**

- A) `$in`
- B) `$all`
- C) `$exists`
- D) `$eq`

<details><summary>Odpowiedź</summary>

**D** — slajd: „Zapis { pole: wartość } jest skrótem dla { pole: { $eq: wartość } }”. (slajd 122)

</details>

**3.86. Które zapytanie wybierze użytkowników w wieku od 18 do 64 lat (wiek całkowity)?**

- A) `db.users.find({ age: { $gte: 18, $lt: 65 } })`
- B) `db.users.find({ age: { $gt: 18, $lte: 65 } })`
- C) `db.users.find({ age: { $in: [18, 64] } })`
- D) `db.users.find({ age: { $gte: 18 }, age: { $lt: 65 } })`

<details><summary>Odpowiedź</summary>

**A** — 18 włącznie, 65 wyłącznie. W D drugi klucz `age` nadpisze pierwszy, więc zostanie tylko `$lt: 65`. (slajd 122)

</details>

**3.87. Co zwróci `db.articles.find({ tags: { $in: ["NoSQL", "javascript"] } })`?**

- A) Artykuły, które mają oba tagi
- B) Artykuły, które mają co najmniej jeden z tych tagów
- C) Artykuły, których tablica `tags` to dokładnie `["NoSQL", "javascript"]`
- D) Artykuły, które nie mają żadnego z tych tagów

<details><summary>Odpowiedź</summary>

**B** — `$in` dopasowuje, gdy wartość równa się przynajmniej jednej z podanych. A to `$all`, D to `$nin`. (slajd 122)

</details>

**3.88. Które zdanie o `{ status: { $ne: "inactive" } }` jest prawdziwe?**

- A) Zwraca tylko dokumenty, które mają pole `status`
- B) Wymaga indeksu na polu `status`
- C) Zwraca też dokumenty, które w ogóle nie mają pola `status`
- D) Działa tylko na polach tekstowych

<details><summary>Odpowiedź</summary>

**C** — brak pola też jest „różny od inactive”, dlatego `$ne` (i `$nin`) zwraca również dokumenty bez tego pola. (slajd 122)

</details>

**3.89. W kolekcji jest dokument `{ qty: "5" }` (tekst). Co zwróci `db.c.find({ qty: 5 })`?**

- A) Ten dokument, bo MongoDB zamienia tekst na liczbę
- B) Błąd typu
- C) Wszystkie dokumenty z polem `qty`
- D) Nic, bo liczba 5 różni się od tekstu "5"

<details><summary>Odpowiedź</summary>

**D** — slajd: „typy danych mają znaczenie (np. liczba 5 różni się od "5")”. Automatyczna konwersja dotyczy tylko typów liczbowych między sobą. (slajd 122)

</details>

**3.90. Co przyjmują jako argument operatory `$in` i `$nin`?**

- A) Tablicę wartości
- B) Jedną wartość
- C) Wyrażenie regularne
- D) Dokument z operatorami

<details><summary>Odpowiedź</summary>

**A** — slajd „Uwaga”: operatory $in i $nin przyjmują tablicę wartości. (slajd 122)

</details>

**3.91. Które zapytanie zwraca książki, których gatunek NIE jest ani „Mystery”, ani „Sci-Fi”?**

- A) `db.books.find({ genre: { $ne: ["Mystery", "Sci-Fi"] } })`
- B) `db.books.find({ genre: { $nin: ["Mystery", "Sci-Fi"] } })`
- C) `db.books.find({ genre: { $not: ["Mystery", "Sci-Fi"] } })`
- D) `db.books.find({ $nor: ["Mystery", "Sci-Fi"] })`

<details><summary>Odpowiedź</summary>

**B** — `$nin` = „nie należy do zbioru”. `$ne` z tablicą porównałby z całą tablicą, a `$nor` przyjmuje tablicę wyrażeń, nie wartości. (slajd 122)

</details>

### Operatory $exists, $regex, $text i $expr

**3.92. Które zapytanie zwraca książki, w których pole `author` NIE istnieje?**

- A) `db.books.find({ author: null })`
- B) `db.books.find({ author: { $exists: 0 } })` — wyłącznie ta forma jest poprawna
- C) `db.books.find({ author: { $exists: false } })`
- D) `db.books.find({ author: { $ne: true } })`

<details><summary>Odpowiedź</summary>

**C** — forma ze slajdu to `$exists: false`. `author: null` zwróciłoby też dokumenty z `author` równym null, a B nie jest „jedyną poprawną formą”. (slajd 123)

</details>

**3.93. Które zapytanie zwraca użytkowników, których `name` zaczyna się od „Jan”, bez względu na wielkość liter?**

- A) `db.users.find({ name: { $regex: "Jan$", $options: "i" } })`
- B) `db.users.find({ name: { $text: "^Jan" } })`
- C) `db.users.find({ name: { $regex: "^Jan" } })`
- D) `db.users.find({ name: { $regex: "^Jan", $options: "i" } })`

<details><summary>Odpowiedź</summary>

**D** — `^` oznacza początek tekstu, a `$options: "i"` wyłącza rozróżnianie wielkości liter. C rozróżnia wielkość liter, A szuka końcówki. (slajd 123)

</details>

**3.94. Czego wymaga operator `$text`?**

- A) Indeksu tekstowego (text index) na odpowiednich polach
- B) Kolekcji capped
- C) Opcji `$options: "i"`
- D) Pola typu tablica

<details><summary>Odpowiedź</summary>

**A** — bez indeksu tekstowego zapytanie z `$text` zwraca błąd. (slajd 123)

</details>

**3.95. Która składnia wyszukiwania pełnotekstowego jest poprawna?**

- A) `db.articles.find({ content: { $text: "mongodb baza" } })`
- B) `db.articles.find({ $search: { $text: "mongodb baza" } })`
- C) `db.articles.find({ $text: { $search: "mongodb baza" } })`
- D) `db.articles.find({ $text: "mongodb baza" })`

<details><summary>Odpowiedź</summary>

**C** — `$text` stoi na najwyższym poziomie filtra, a szukany tekst jest w `$search`. Uwaga: komentarz na slajdzie mówi o dokumentach zawierających „mongodb” i „baza”, ale słowa rozdzielone spacją są w rzeczywistości łączone przez OR. (slajd 123)

</details>

**3.96. Które zapytanie zwraca produkty, w których cena (`price`) jest większa od kosztu (`koszt`)?**

- A) `db.products.find({ price: { $gt: "$koszt" } })`
- B) `db.products.find({ $expr: { $gt: ["$price", "$koszt"] } })`
- C) `db.products.find({ $expr: { price: { $gt: "koszt" } } })`
- D) `db.products.find({ $where: { $gt: ["price", "koszt"] } })`

<details><summary>Odpowiedź</summary>

**B** — `$expr` pozwala porównać dwa pola dokumentu; operator przyjmuje tablicę argumentów, a pola zapisuje się jako `"$nazwa"`. A porównuje cenę z tekstem "$koszt". (slajd 123)

</details>

**3.97. Do czego głównie służy `$expr` w zapytaniu `find()`?**

- A) Do wyszukiwania pełnotekstowego
- B) Do sprawdzania typu pola
- C) Do negowania warunku
- D) Do używania wyrażeń agregacji, np. porównania dwóch pól tego samego dokumentu

<details><summary>Odpowiedź</summary>

**D** — slajd: `$expr` umożliwia użycie wyrażeń i porównywanie pól tego samego dokumentu. (slajd 123)

</details>

**3.98. Jaką metodą, zgodnie z „dobrą praktyką” ze slajdu, testuje się wydajność zapytania?**

- A) `explain()`
- B) `analyze()`
- C) `profile()`
- D) `stats()`

<details><summary>Odpowiedź</summary>

**A** — „Stosuj indeksy (w tym text index) i testuj wydajność zapytań za pomocą explain()”. (slajd 123)

</details>

### Operatory tablicowe w zapytaniach: $size, $elemMatch, $all

**3.99. Które zapytanie zwraca produkty mające dokładnie 3 kolory w tablicy `colors`?**

- A) `db.products.find({ colors: { $all: 3 } })`
- B) `db.products.find({ colors: { $size: 3 } })`
- C) `db.products.find({ "colors.length": 3 })`
- D) `db.products.find({ colors: { $count: 3 } })`

<details><summary>Odpowiedź</summary>

**B** — `{ pole: { $size: <liczba> } }`. (slajd 124)

</details>

**3.100. Które zdanie o `$size` jest prawdziwe?**

- A) Przyjmuje zakres, np. `{ $size: { $gt: 2 } }`
- B) Działa także na tekstach (liczy znaki)
- C) Wymaga dokładnej liczby elementów
- D) Zwraca rozmiar tablicy w projekcji

<details><summary>Odpowiedź</summary>

**C** — slajd: „$size wymaga dokładnej liczby elementów”; zakresów nie przyjmuje. (slajd 124)

</details>

**3.101. Co gwarantuje `db.courses.find({ grades: { $elemMatch: { subject: "Math", score: { $gte: 80 } } } })`?**

- A) Że wszystkie oceny są z matematyki
- B) Że tablica `grades` ma co najmniej 80 elementów
- C) Że jakaś ocena jest z matematyki i jakaś (być może inna) ma co najmniej 80
- D) Że co najmniej jeden element tablicy jest jednocześnie z matematyki i ma wynik co najmniej 80

<details><summary>Odpowiedź</summary>

**D** — `$elemMatch` wymaga, by wszystkie warunki spełnił ten sam element tablicy. C opisuje zapytanie z notacją kropkową bez `$elemMatch`. (slajd 124)

</details>

**3.102. Kolekcja `movies`: Forrest Gump (Tom Hanks, Robin Wright, Gary Sinise), Cast Away (Tom Hanks), The Green Mile (Tom Hanks, Michael Clarke Duncan). Co zwróci `db.movies.find({ actors: { $all: ["Tom Hanks", "Robin Wright"] } })`?**

- A) Tylko Forrest Gump
- B) Wszystkie trzy filmy
- C) Nic, bo Forrest Gump ma też trzeciego aktora
- D) Cast Away i The Green Mile

<details><summary>Odpowiedź</summary>

**A** — `$all` wymaga obecności wszystkich wymienionych elementów; inne elementy mogą występować. (slajd 125)

</details>

**3.103. Dla tych samych danych co wyżej, co zwróci `db.movies.find({ actors: { $in: ["Tom Hanks", "Robin Wright"] } })`?**

- A) Tylko Forrest Gump
- B) Wszystkie trzy filmy
- C) Nic
- D) Tylko Cast Away

<details><summary>Odpowiedź</summary>

**B** — `$in` wystarcza jeden pasujący element, a Tom Hanks gra we wszystkich trzech filmach. (slajd 122, 125)

</details>

**3.104. Które zdanie o `$all` jest prawdziwe?**

- A) Wymaga, żeby elementy w tablicy były w tej samej kolejności co w zapytaniu
- B) Wymaga, żeby tablica zawierała tylko podane elementy
- C) Kolejność nie ma znaczenia, a tablica może zawierać też inne elementy
- D) Działa wyłącznie na tablicach liczb

<details><summary>Odpowiedź</summary>

**C** — kolejność nie ma znaczenia; `$all` sprawdza obecność, nie wyłączność. Działa z wartościami prostymi i dokumentami. (slajd 125)

</details>

**3.105. Jak znaleźć dokumenty, w których tablica `tags` zawiera „a” i „b” i ma dokładnie dwa elementy (w dowolnej kolejności)?**

- A) `{ tags: ["a", "b"] }`
- B) `{ tags: { $in: ["a", "b"] }, tags: { $size: 2 } }`
- C) `{ tags: { $elemMatch: ["a", "b"] } }`
- D) `{ tags: { $all: ["a", "b"], $size: 2 } }`

<details><summary>Odpowiedź</summary>

**D** — slajd zaleca dodanie `$size`, gdy potrzebna jest dokładna liczba elementów. A wymaga konkretnej kolejności, a w B drugi klucz `tags` nadpisze pierwszy. (slajd 125)

</details>

**3.106. Którego operatora użyć, gdy chcemy filtrować tablicę dokumentów po kilku warunkach dotyczących tego samego elementu?**

- A) `$elemMatch`
- B) `$all`
- C) `$size`
- D) `$in`

<details><summary>Odpowiedź</summary>

**A** — dobra praktyka ze slajdu: „Używaj $elemMatch do filtrowania tablic dokumentów”. (slajd 124)

</details>

### Operatory logiczne i $not

**3.107. Które zdanie o `$and` jest zgodne z wykładem?**

- A) Stoi przy polu, np. `{ price: { $and: [...] } }`
- B) Przyjmuje tablicę co najmniej 2 wyrażeń i jest dopuszczalny tylko na najwyższym poziomie zapytania
- C) Przyjmuje dokument z jednym operatorem
- D) Zwraca dokumenty, które nie spełniają żadnego warunku

<details><summary>Odpowiedź</summary>

**B** — tak opisuje go slajd. Uwaga: dokumentacja dopuszcza też tablicę z jednym wyrażeniem, a `$and` można zagnieżdżać w innych operatorach logicznych; nie wolno go jedynie stawiać przy polu. (slajd 126)

</details>

**3.108. Które zapytanie zwraca zamówienia z ceną poniżej 10 LUB ilością powyżej 100?**

- A) `db.orders.find({ price: { $lt: 10 }, quantity: { $gt: 100 } })`
- B) `db.orders.find({ $or: { price: { $lt: 10 }, quantity: { $gt: 100 } } })`
- C) `db.orders.find({ $or: [ { price: { $lt: 10 } }, { quantity: { $gt: 100 } } ] })`
- D) `db.orders.find({ $in: [ { price: { $lt: 10 } }, { quantity: { $gt: 100 } } ] })`

<details><summary>Odpowiedź</summary>

**C** — `$or` przyjmuje tablicę wyrażeń (dokumentów). A to AND, B ma dokument zamiast tablicy. (slajd 126)

</details>

**3.109. Kiedy jawny `$and` jest naprawdę potrzebny, a nie wystarczy przecinek?**

- A) Zawsze, gdy warunków jest więcej niż dwa
- B) Gdy warunki dotyczą różnych pól
- C) Gdy używamy operatorów porównania
- D) Gdy ten sam klucz musiałby wystąpić dwa razy, np. dwa warunki `$or` w jednym zapytaniu

<details><summary>Odpowiedź</summary>

**D** — w jednym dokumencie klucz może wystąpić raz; dwa `$or` trzeba objąć jednym `$and`. W pozostałych przypadkach przecinek oznacza „i”. (slajd 126)

</details>

**3.110. Które zdanie o `$not` jest zgodne z wykładem?**

- A) Stoi na najwyższym poziomie zapytania i przyjmuje tablicę wyrażeń
- B) Dotyczy jednego operatora zapytania przy polu i nie może być użyty na najwyższym poziomie
- C) Jest synonimem `$ne`
- D) Działa wyłącznie z wyrażeniami regularnymi

<details><summary>Odpowiedź</summary>

**B** — `{ pole: { $not: { <operator>: <wartość> } } }`; A opisuje `$and`/`$or`/`$nor`. (slajd 127)

</details>

**3.111. Co zwróci `db.products.find({ price: { $not: { $gt: 100 } } })`?**

- A) Produkty z ceną mniejszą lub równą 100 oraz produkty bez pola `price`
- B) Tylko produkty z ceną mniejszą lub równą 100
- C) Produkty z ceną większą niż 100
- D) Błąd, bo `$not` musi stać na najwyższym poziomie

<details><summary>Odpowiedź</summary>

**A** — slajd mówi „cena nie jest większa niż 100 (tj. ≤ 100)”, ale `$not` zwraca też dokumenty bez danego pola; dlatego nie jest to to samo co `{ price: { $lte: 100 } }`. (slajd 127)

</details>

**3.112. Które zapytanie zwraca produkty, których nazwa NIE pasuje do wzorca „apple” (bez względu na wielkość liter)?**

- A) `db.products.find({ $not: { name: /apple/i } })`
- B) `db.products.find({ name: { $ne: /apple/i } })`
- C) `db.products.find({ name: { $not: /apple/i } })`
- D) `db.products.find({ name: { $nin: "apple" } })`

<details><summary>Odpowiedź</summary>

**C** — `$not` stoi przy polu i może przyjąć bezpośrednio wyrażenie regularne. A używa `$not` na najwyższym poziomie, co jest niedozwolone. (slajd 127)

</details>

**3.113. Którego operatora NIE da się, według slajdu, łączyć z `$not`?**

- A) `$regex`
- B) `$in`
- C) `$gt`
- D) Takiego ograniczenia na liście nie ma; `$not` łączy się m.in. z `$gt`, `$regex`, `$in`, `$exists`, `$type`

<details><summary>Odpowiedź</summary>

**D** — slajd wymienia `$gt`, `$lt`, `$gte`, `$lte`, `$regex`, `$in`, `$nin`, `$exists`, `$type` jako operatory, z którymi można łączyć `$not`. (slajd 127)

</details>

**3.114. Jakie zapytanie poprawnie wybiera produkty, których cena NIE mieści się w przedziale 50–200 (opis z przykładu 2 na slajdzie o `$not`)?**

- A) `{ price: { $not: { {lt: 50, $gt: 200 } } } }`
- B) `{ price: { $not: { $gte: 50, $lte: 200 } } }`
- C) `{ $not: { price: { $gte: 50, $lte: 200 } } }`
- D) `{ price: { $not: [50, 200] } }`

<details><summary>Odpowiedź</summary>

**B** — zaprzeczamy przynależności do przedziału przy polu. Wariant A to kod ze slajdu, który zawiera błąd składni (podwójne klamry, `lt` bez `$`) i logicznie nie opisuje przedziału. (slajd 127)

</details>

### Zasady przeszukiwania tablic

**3.115. Które dokumenty dopasuje `db.movies.find({ actors: ObjectId("5") })`?**

- A) Tylko `{ actors: ObjectId("5") }`
- B) Tylko `{ actors: [ ObjectId("5"), ObjectId("7") ] }`
- C) Żaden, bo `actors` musi być tablicą
- D) Oba: `{ actors: ObjectId("5") }` oraz `{ actors: [ ObjectId("5"), ObjectId("7") ] }`

<details><summary>Odpowiedź</summary>

**D** — równość jest spełniona, gdy pole w całości jest równe wartości albo gdy co najmniej jeden element tablicy jest jej równy. (slajd 128)

</details>

**3.116. Czy `db.movies.find({ ratings: { $gte: 2, $lte: 3 } })` dopasuje dokument `{ ratings: [1, 4] }`?**

- A) Tak, bo każdy operator może zostać spełniony przez inny element tablicy (4 ≥ 2, 1 ≤ 3)
- B) Nie, bo żaden element nie leży w przedziale 2–3
- C) Nie, bo operatory porównania nie działają na tablicach
- D) Tak, ale tylko gdy tablica jest posortowana

<details><summary>Odpowiedź</summary>

**A** — slajd: każdy z operatorów musi trafić w co najmniej jeden element, ale nie musi to być ten sam element. (slajd 129)

</details>

**3.117. Jak zapisać warunek, by TEN SAM element tablicy `ratings` był jednocześnie ≥ 2 i ≤ 3?**

- A) `{ ratings: { $all: [2, 3] } }`
- B) `{ ratings: { $in: [2, 3] } }`
- C) `{ ratings: { $elemMatch: { $gte: 2, $lte: 3 } } }`
- D) `{ "ratings.0": { $gte: 2, $lte: 3 } }`

<details><summary>Odpowiedź</summary>

**C** — slajd: „Użyj $elemMatch gdy pojedynczy element tablicy powinien zostać dopasowany do wszystkich operatorów”. D sprawdza tylko pierwszy element. (slajd 129)

</details>

### Projekcja

**3.118. Która projekcja jest NIEPOPRAWNA?**

- A) `{ title: 1, actors: 1 }`
- B) `{ title: 1, _id: 0 }`
- C) `{ year: 0, rating: 0 }`
- D) `{ title: 1, year: 0 }`

<details><summary>Odpowiedź</summary>

**D** — nie wolno mieszać włączeń (1) i wyłączeń (0); jedynym wyjątkiem jest `_id`, dlatego B jest poprawne. (slajd 130)

</details>

**3.119. Które pole jest domyślnie dołączane do wyniku, nawet gdy nie wymienimy go w projekcji włączającej?**

- A) `_id`
- B) Pierwsze pole dokumentu
- C) Pole użyte w filtrze
- D) Żadne

<details><summary>Odpowiedź</summary>

**A** — `_id` jest domyślnie dodawane i można je wyłączyć przez `_id: 0`. (Na slajdzie widnieje literówka „_poleId”.) (slajd 130)

</details>

**3.120. Jakie pola zwróci `db.movies.find({ _id: ObjectId("2") }, { title: true, actors: true })`?**

- A) Tylko `title` i `actors`
- B) `_id`, `title` i `actors`
- C) Wszystkie pola dokumentu
- D) Wszystkie pola poza `title` i `actors`

<details><summary>Odpowiedź</summary>

**B** — `true`/1 włącza pola, a `_id` jest dodawane domyślnie; wynik na slajdzie zawiera `_id`, `title` i `actors`. (slajd 132)

</details>

**3.121. Co zwróci projekcja `{ title: 1, _id: 0, actors: { $slice: -2 } }`?**

- A) Tytuł i dwóch pierwszych aktorów
- B) Tytuł i wszystkich aktorów poza dwoma ostatnimi
- C) Tytuł i dwóch ostatnich aktorów, bez `_id`
- D) Błąd, bo nie można mieszać `1` i `0`

<details><summary>Odpowiedź</summary>

**C** — ujemne `$slice` wybiera ostatnie elementy; `_id: 0` to dozwolony wyjątek. (slajd 131, 132)

</details>

**3.122. Co wybierze `{ comments: { $slice: [2, 3] } }` w projekcji?**

- A) Elementy o indeksach 2 i 3
- B) Pierwsze 2 i ostatnie 3 elementy
- C) Elementy od 3. do 5. włącznie, czyli pominie 2 i weźmie 3 kolejne
- D) Pierwsze 3 elementy, jeśli tablica ma co najmniej 2

<details><summary>Odpowiedź</summary>

**C** — postać `[skip, count]`: pomija `skip` elementów i bierze `count` kolejnych. (slajd 131)

</details>

**3.123. Co robi operator projekcji `$elemMatch`?**

- A) Zwraca pierwszy element tablicy spełniający wszystkie warunki; gdy takiego brak, pole tablicowe nie jest zwracane
- B) Zwraca wszystkie elementy spełniające warunki
- C) Filtruje dokumenty, a nie elementy tablicy
- D) Zwraca liczbę pasujących elementów

<details><summary>Odpowiedź</summary>

**A** — w projekcji `$elemMatch` wybiera pierwszy pasujący element. Slajd pisze, że „żadne pole nie jest zwracane”; ściśle: pomijane jest to pole tablicowe, a np. `_id` pozostaje. (slajd 131)

</details>

### Modyfikatory kursora: sort, limit, skip

**3.124. Co oznaczają wartości w `sort({ pole: 1 })` i `sort({ pole: -1 })`?**

- A) 1 = malejąco, -1 = rosnąco
- B) 1 = rosnąco, -1 = malejąco
- C) 1 = włącz pole, -1 = wyklucz pole
- D) 1 = pierwszy dokument, -1 = ostatni dokument

<details><summary>Odpowiedź</summary>

**B** — 1 to porządek rosnący, -1 malejący. (slajd 134)

</details>

**3.125. Czym różnią się wyniki `db.myColl.find().sort({_id: 1}).limit(6).skip(3)` i `db.myColl.find().sort({_id: 1}).skip(3).limit(6)`?**

- A) Pierwsze zwróci 3 dokumenty, drugie 6
- B) Pierwsze zwróci dokumenty 1–6, drugie 4–9
- C) Pierwsze zwróci błąd
- D) Niczym; oba zwrócą dokumenty od 4. do 9.

<details><summary>Odpowiedź</summary>

**D** — modyfikatory można łączyć w dowolnej kolejności bez skutków ubocznych; serwer zawsze wykonuje sort, potem skip, potem limit. (slajd 133, 135)

</details>

**3.126. Jaka jest kolejność dokumentów zwracanych przez `find()` bez modyfikatora `sort`?**

- A) Zawsze według `_id` rosnąco
- B) Zawsze w kolejności wstawiania
- C) Niezdefiniowana
- D) Alfabetyczna według pierwszego pola

<details><summary>Odpowiedź</summary>

**C** — slajd: „Kolejność dokumentów jest domyślnie niezdefiniowana (chyba że użyto modyfikatora sortowania)”. (slajd 134)

</details>

**3.127. Co wynika z zasady „sortowanie następuje przed projekcją”?**

- A) Projekcja musi zawierać pola sortowania
- B) Sortowanie działa tylko na polu `_id`
- C) Nie można jednocześnie używać sort i projekcji
- D) Można sortować po polu, które nie zostało uwzględnione w wyniku

<details><summary>Odpowiedź</summary>

**D** — skoro sortowanie odbywa się wcześniej, pola pominięte w projekcji nadal mogą służyć do sortowania. (slajd 134)

</details>

**3.128. Jak zostaną posortowani użytkownicy w `db.users.find({ }).sort({ age: -1, posts: 1 })`?**

- A) Malejąco po wieku, a przy równym wieku rosnąco po liczbie postów
- B) Rosnąco po wieku, a przy równym wieku malejąco po postach
- C) Rosnąco po liczbie postów, potem malejąco po wieku
- D) Tylko po wieku; drugie pole jest ignorowane

<details><summary>Odpowiedź</summary>

**A** — pierwsze pole w dokumencie sortowania jest kluczem głównym, kolejne rozstrzyga remisy. (slajd 135)

</details>

**3.129. Kiedy, według wykładu, trzeba podać modyfikatory kursora?**

- A) Przed wywołaniem `find()`
- B) Zanim dokumenty zostaną zwrócone za pośrednictwem kursora
- C) Wyłącznie w kolejności sort, skip, limit
- D) W drugim argumencie `find()`

<details><summary>Odpowiedź</summary>

**B** — modyfikatory są opcjonalne i łańcuchowane w dowolnej kolejności, ale muszą być podane, zanim kursor zacznie zwracać dokumenty. (slajd 133)

</details>

**3.130. Który modyfikator pomija określoną liczbę dokumentów, licząc od początku?**

- A) `limit(n)`
- B) `offset(n)`
- C) `skip(n)`
- D) `next(n)`

<details><summary>Odpowiedź</summary>

**C** — `skip(offset)` pomija dokumenty, `limit(count)` zwraca co najwyżej `count` dokumentów; metody `offset()` w mongosh nie ma. (slajd 133)

</details>

### Porównanie zapytań SQL i MongoDB

**3.131. Które polecenie odpowiada `SELECT user_id, status FROM people`?**

- A) `db.people.find({ user_id: 1, status: 1 })`
- B) `db.people.find({ }, { user_id: 1, status: 1 })`
- C) `db.people.find({ }, { user_id: 1, status: 1, _id: 0 })`
- D) `db.people.find({ user_id: 1, status: 1, _id: 0 })`

<details><summary>Odpowiedź</summary>

**C** — kolumny trafiają do projekcji (drugi argument), a `_id` trzeba wyłączyć jawnie. B odpowiada `SELECT id, user_id, status`, a A i D traktują projekcję jak filtr. (slajd 137)

</details>

**3.132. Które polecenie odpowiada `SELECT * FROM people WHERE status = "A" OR age = 50`?**

- A) `db.people.find({ status: "A", age: 50 })`
- B) `db.people.find({ $or: [ { status: "A" }, { age: 50 } ] })`
- C) `db.people.find({ status: { $in: ["A", 50] } })`
- D) `db.people.find({ $and: [ { status: "A" }, { age: 50 } ] })`

<details><summary>Odpowiedź</summary>

**B** — OR wymaga `$or` z tablicą; A i D to AND, a C sprawdza tylko pole `status`. (slajd 138)

</details>

**3.133. Które polecenie odpowiada `SELECT * FROM people WHERE status = "A" AND age = 50`?**

- A) `db.people.find({ status: "A", age: 50 })`
- B) `db.people.find({ $or: [ { status: "A" }, { age: 50 } ] })`
- C) `db.people.find({ status: "A" }, { age: 50 })`
- D) `db.people.find({ status: "A" }).find({ age: 50 })`

<details><summary>Odpowiedź</summary>

**A** — AND to przecinek w jednym dokumencie filtra. C traktuje `age: 50` jak projekcję. (slajd 138)

</details>

**3.134. Które polecenie odpowiada `SELECT * FROM people WHERE status != "A"`?**

- A) `db.people.find({ status: { $not: "A" } })`
- B) `db.people.find({ status: { $nin: "A" } })`
- C) `db.people.find({ $nor: "A" })`
- D) `db.people.find({ status: { $ne: "A" } })`

<details><summary>Odpowiedź</summary>

**D** — `$ne` = „różne”. `$not` wymaga operatora albo regexu, `$nin` tablicy, `$nor` tablicy wyrażeń. (slajd 138)

</details>

**3.135. Które polecenie odpowiada `SELECT * FROM people WHERE age > 25 AND age <= 50`?**

- A) `db.people.find({ age: { $gt: 25 }, age: { $lte: 50 } })`
- B) `db.people.find({ age: { $gte: 25, $lt: 50 } })`
- C) `db.people.find({ age: { $gt: 25, $lte: 50 } })`
- D) `db.people.find({ age: { $in: [25, 50] } })`

<details><summary>Odpowiedź</summary>

**C** — oba operatory w jednym dokumencie przy polu `age`. W A drugi klucz nadpisze pierwszy, B ma złe granice. (slajd 139)

</details>

**3.136. Które polecenie odpowiada `SELECT * FROM people WHERE user_id LIKE "%bc%"`?**

- A) `db.people.find({ user_id: /bc/ })`
- B) `db.people.find({ user_id: /^bc/ })`
- C) `db.people.find({ user_id: "%bc%" })`
- D) `db.people.find({ $text: { $search: "bc" } })`

<details><summary>Odpowiedź</summary>

**A** — regex bez kotwic dopasowuje fragment w dowolnym miejscu (równoważnie `{ $regex: /bc/ }`). B to `LIKE "bc%"`, a C szuka dosłownego tekstu z procentami. (slajd 139)

</details>

**3.137. Które polecenie odpowiada `SELECT * FROM people WHERE user_id LIKE "bc%"`?**

- A) `db.people.find({ user_id: /bc$/ })`
- B) `db.people.find({ user_id: { $regex: /^bc/ } })`
- C) `db.people.find({ user_id: /bc/ })`
- D) `db.people.find({ user_id: { $regex: "bc", $options: "^" } })`

<details><summary>Odpowiedź</summary>

**B** — „zaczyna się od bc” to wzorzec `/^bc/` (zapis `{ user_id: /^bc/ }` jest równoważny). A to „kończy się na bc”. (slajd 139)

</details>

**3.138. Które polecenie odpowiada `SELECT * FROM people WHERE status = "A" ORDER BY user_id DESC`?**

- A) `db.people.find({ status: "A" }).sort({ user_id: 1 })`
- B) `db.people.find({ status: "A" }, { user_id: -1 })`
- C) `db.people.find({ status: "A" }).orderBy({ user_id: "desc" })`
- D) `db.people.find({ status: "A" }).sort({ user_id: -1 })`

<details><summary>Odpowiedź</summary>

**D** — DESC to `-1` w `sort()`. B przekazuje `-1` jako projekcję, a `orderBy` nie istnieje. (slajd 139)

</details>

**3.139. Które polecenie odpowiada `SELECT COUNT(user_id) FROM people` w tabeli z wykładu?**

- A) `db.people.count({ user_id: { $exists: true } })`
- B) `db.people.count("user_id")`
- C) `db.people.distinct("user_id").count()`
- D) `db.people.find({ user_id: 1 }).count()`

<details><summary>Odpowiedź</summary>

**A** — COUNT(kolumny) liczy wiersze z wartością, więc filtr `$exists: true` (alternatywnie `find({ user_id: { $exists: true } }).count()`). Metoda `count()` jest dziś przestarzała na rzecz `countDocuments()`. (slajd 140)

</details>

**3.140. Które polecenie odpowiada `SELECT DISTINCT(status) FROM people`?**

- A) `db.people.find({}, { status: 1 }).unique()`
- B) `db.people.group("status")`
- C) `db.people.distinct("status")`
- D) `db.people.find({ status: { $distinct: true } })`

<details><summary>Odpowiedź</summary>

**C** — `distinct("status")` (dla zbiorów wartości nieprzekraczających limitu rozmiaru BSON) albo agregacja `aggregate([ { $group: { _id: "$status" } } ])`. (slajd 140)

</details>

**3.141. Które polecenie odpowiada `SELECT * FROM people LIMIT 1`?**

- A) `db.people.first()`
- B) `db.people.find().top(1)`
- C) `db.people.find().skip(1)`
- D) `db.people.findOne()`

<details><summary>Odpowiedź</summary>

**D** — `findOne()` albo `find().limit(1)`. `skip(1)` pomija pierwszy dokument. (slajd 141)

</details>

**3.142. Które polecenie odpowiada zapytaniu z tabeli `SELECT * FROM people LIMIT 5 SKIP 10`?**

- A) `db.people.find().limit(5).skip(10)`
- B) `db.people.find().limit(10).skip(5)`
- C) `db.people.find().slice(10, 5)`
- D) `db.people.find({ $limit: 5, $skip: 10 })`

<details><summary>Odpowiedź</summary>

**A** — pomija 10 dokumentów i zwraca 5 następnych (kolejność łańcucha nie ma znaczenia). Uwaga: w standardowym SQL piszemy `LIMIT 5 OFFSET 10`; słowo SKIP pochodzi z tabeli w dokumentacji MongoDB. (slajd 141)

</details>

**3.143. Które polecenie odpowiada `EXPLAIN SELECT * FROM people WHERE status = "A"`?**

- A) `db.people.explain("status", "A")`
- B) `db.people.find({ status: "A" }).explain()`
- C) `db.people.find({ status: "A" }).plan()`
- D) `EXPLAIN db.people.find({ status: "A" })`

<details><summary>Odpowiedź</summary>

**B** — `explain()` wywołuje się na kursorze zapytania i pokazuje plan wykonania. (slajd 141)

</details>


## 4. MongoDB — walidacja schematu, Aggregation Framework, import i indeksy

### Walidacja schematu

**4.1. Jak wygląda domyślny schemat kolekcji w MongoDB?**

- A) Sztywny: przy createCollection trzeba podać listę pól
- B) Elastyczny: na start nie ma skonfigurowanej walidacji, ale można dodać reguły walidacji schematu
- C) Elastyczny i nie da się wymusić struktury dokumentów
- D) Relacyjny: każda kolekcja ma zdefiniowane kolumny

<details><summary>Odpowiedź</summary>

**B** — MongoDB domyślnie ma elastyczny schemat bez walidacji, ale reguły walidacji (validator) można dodać, aby dokumenty miały podobną strukturę. Odpowiedź C jest częstą pułapką. (slajd 142)

</details>

**4.2. Który operator umieszczony w opcji `validator` służy do walidacji strukturalnej w stylu JSON Schema?**

- A) `$schema`
- B) `$validate`
- C) `$jsonSchema`
- D) `$expr`

<details><summary>Odpowiedź</summary>

**C** — `$jsonSchema` opisuje typy pól, pola wymagane i dodatkowe właściwości. `$expr` też może stać w walidatorze, ale służy do warunków logicznych i porównań, nie do opisu struktury. (slajd 142)

</details>

**4.3. Którym słowem kluczowym w przykładach z wykładu określa się typ pola w `$jsonSchema`?**

- A) `bsonType`
- B) `dataType`
- C) `fieldType`
- D) `$type`

<details><summary>Odpowiedź</summary>

**A** — `bsonType: "string"`, `bsonType: "object"` itd. `$type` to operator zapytań, a nie słowo kluczowe schematu. (slajd 142)

</details>

**4.4. Kolekcja `posts` ma walidator: `required: ["title", "body"]`, wszystkie trzy pola `title`, `body`, `category` typu string, bez `additionalProperties`, `validationAction: "error"`. Który insert zostanie odrzucony?**

- A) `db.posts.insertOne({title:'T', body:'B'})`
- B) `db.posts.insertOne({title:'T', body:'B', category:'C'})`
- C) `db.posts.insertOne({title:'T', body:'B', tags:['x']})`
- D) `db.posts.insertOne({title:'T', newbody:'B', category:'C'})`

<details><summary>Odpowiedź</summary>

**D** — brakuje wymaganego pola `body` (jest `newbody`). Dodatkowe pole `tags` w C jest dozwolone, bo schemat nie ustawia `additionalProperties: false`. (slajd 142)

</details>

**4.5. Pole `category` jest opisane w `properties` jako `bsonType: "string"`, ale nie ma go w `required`. Co to oznacza?**

- A) Musi wystąpić w każdym dokumencie
- B) Walidator je ignoruje
- C) Nie musi wystąpić, ale jeśli wystąpi, musi być napisem
- D) Nie może wystąpić w dokumencie

<details><summary>Odpowiedź</summary>

**C** — `required` decyduje o obecności pola, a `properties` o jego wyglądzie, jeśli istnieje. Na slajdzie opis brzmi „Category of post - Optional”. (slajd 142)

</details>

**4.6. Które zdanie o `$jsonSchema` i `$expr` w walidacji jest prawdziwe?**

- A) `$expr` sprawdza tylko typy pól
- B) Tylko `$jsonSchema` pozwala porównać dwa pola tego samego dokumentu
- C) Nie można ich używać razem w jednym walidatorze
- D) `$jsonSchema` sprawdza strukturę, `$expr` pozwala na logikę, arytmetykę i porównania; można je łączyć, np. przez `$and`

<details><summary>Odpowiedź</summary>

**D** — slajd pokazuje kolekcję `sales` z `$and` łączącym `$expr` (`$lt` między cenami) i `$jsonSchema` (typ tablicy). (slajd 142)

</details>

**4.7. Co oznacza `additionalProperties: false` w `$jsonSchema`?**

- A) Dokument nie może zawierać żadnych pól poza jawnie wymienionymi w `properties`
- B) Wszystkie pola z `properties` stają się wymagane
- C) Walidacja obiektów zagnieżdżonych zostaje wyłączona
- D) Dodatkowe pola są dozwolone tylko przy `validationAction: "warn"`

<details><summary>Odpowiedź</summary>

**A** — zakazuje pól spoza `properties`. O obecności pól nadal decyduje `required`. (slajd 143)

</details>

**4.8. Dlaczego przy `additionalProperties: false` w `properties` wpisuje się `_id: {}`?**

- A) Żeby `_id` musiało być obiektem
- B) Bo `_id` jest dodawane automatycznie i bez tego wpisu zostałoby uznane za pole spoza schematu, więc każdy insert byłby odrzucony
- C) Żeby wyłączyć automatyczne generowanie `_id`
- D) Żeby `_id` stało się polem wymaganym

<details><summary>Odpowiedź</summary>

**B** — pusty obiekt `{}` dopuszcza pole `_id` bez narzucania typu. Na slajdzie komentarz: „zostawiamy systemowe pole”. (slajdy 143, 145)

</details>

**4.9. Jakie wartości może przyjąć `validationLevel`?**

- A) `error`, `warn`
- B) `strict`, `lenient`, `none`
- C) `strict`, `moderate`, `off`
- D) `on`, `off`, `warn`

<details><summary>Odpowiedź</summary>

**C** — `error` i `warn` to wartości `validationAction`, a nie `validationLevel`. (slajdy 143, 144)

</details>

**4.10. Co robi `validationAction: "warn"`?**

- A) Odrzuca operację niezgodną ze schematem
- B) Wyłącza walidację kolekcji
- C) Waliduje tylko nowe dokumenty
- D) Zapisuje dokument niezgodny ze schematem, ale generuje ostrzeżenie w logach

<details><summary>Odpowiedź</summary>

**D** — `warn` zapisuje i ostrzega, `error` odrzuca operację. (slajdy 143, 144)

</details>

**4.11. Który poziom walidacji według slajdu waliduje tylko nowe dokumenty i modyfikowane pola, a istniejące dokumenty mogą nie spełniać schematu?**

- A) `moderate`
- B) `strict`
- C) `off`
- D) `warn`

<details><summary>Odpowiedź</summary>

**A** — tak slajd opisuje `moderate`. Precyzyjnie według dokumentacji: `moderate` sprawdza wszystkie inserty i aktualizacje dokumentów, które już były zgodne ze schematem; aktualizacje dokumentów już niezgodnych nie są sprawdzane. `warn` to wartość `validationAction`. (slajdy 143, 144)

</details>

**4.12. Które polecenie usuwa walidator przypisany do kolekcji `posts`?**

- A) `db.posts.dropValidator()`
- B) `db.runCommand({ collMod: "posts", validator: {}, validationLevel: "off" })`
- C) `db.posts.updateOne({}, { $unset: { validator: 1 } })`
- D) `db.runCommand({ listCollections: 1, filter: { name: "posts" } })`

<details><summary>Odpowiedź</summary>

**B** — `collMod` z pustym obiektem `validator` usuwa reguły (dodatkowo można wyłączyć walidację). D tylko wyświetla informacje o kolekcji, a metoda z A nie istnieje. (slajd 144)

</details>

**4.13. Którą metodą powłoki sprawdzisz, jaki walidator jest przypisany do kolekcji `posts`?**

- A) `db.posts.getIndexes()`
- B) `db.posts.validate()`
- C) `db.posts.stats()`
- D) `db.getCollectionInfos({ name: "posts" })`

<details><summary>Odpowiedź</summary>

**D** — zwraca opcje kolekcji, w tym `validator`. Równoważnie `db.runCommand({ listCollections: 1, filter: { name: "posts" } })`. `validate()` sprawdza integralność danych i indeksów kolekcji, a nie reguły schematu. (slajd 144)

</details>

**4.14. Jak wyłączyć walidację kolekcji `posts`, nie kasując zapisanych reguł?**

- A) `db.posts.drop()`
- B) `db.runCommand({ collMod: "posts", validator: {} })`
- C) `db.runCommand({ collMod: "posts", validationLevel: "off" })`
- D) `db.runCommand({ collMod: "posts", validationAction: "off" })`

<details><summary>Odpowiedź</summary>

**C** — `validationLevel: "off"` wyłącza walidację, a reguły zostają. B kasuje reguły, a `validationAction` nie ma wartości `off`. (slajd 144)

</details>

**4.15. Czym jest `db.runCommand()` według wykładu?**

- A) Metodą do uruchamiania skryptów JavaScript z pliku
- B) Uniwersalną funkcją MongoDB do wykonywania poleceń administracyjnych i specjalnych komend
- C) Aliasem metody `aggregate()`
- D) Poleceniem uruchamiającym serwer `mongod`

<details><summary>Odpowiedź</summary>

**B** — przez `runCommand` wykonuje się m.in. `collMod` i `listCollections`. (slajd 144)

</details>

**4.16. Jak poprawnie wymusić, żeby zagnieżdżony obiekt `author` miał pola `name` i `email`?**

- A) Na poziomie głównym `required: ["author.name", "author.email"]`
- B) W `properties` wpisać `author: { bsonType: "string" }`
- C) Ustawić `additionalProperties: true` w `author`
- D) W `properties` wpisać `author: { bsonType: "object", required: ["name", "email"], properties: { ... } }`

<details><summary>Odpowiedź</summary>

**D** — schemat jest rekurencyjny: obiekt zagnieżdżony ma własne `bsonType: "object"`, `required`, `properties` i może mieć własne `additionalProperties: false`. (slajd 145)

</details>

**4.17. Do czego służy słowo kluczowe `pattern` przy polu `email` w schemacie z wykładu?**

- A) Sprawdza wartość napisu wyrażeniem regularnym (prosta walidacja formatu e-mail)
- B) Tworzy indeks unikalny na polu
- C) Określa wartość domyślną pola
- D) Szyfruje wartość pola

<details><summary>Odpowiedź</summary>

**A** — `pattern: "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$"` to wyrażenie regularne; opis na slajdzie: „Prosta walidacja formatu e-mail”. (slajd 145)

</details>

**4.18. Jakie ustawienia przyjmuje MongoDB, gdy podasz `validator`, ale pominiesz `validationLevel` i `validationAction`?**

- A) `moderate` i `warn`
- B) `off` i `error`
- C) `strict` i `error`
- D) `strict` i `warn`

<details><summary>Odpowiedź</summary>

**C** — wartości domyślne to `strict` i `error`; na slajdzie są też ustawione jawnie z komentarzem „na start”. (slajdy 142, 143)

</details>

### Aggregation Framework i potok agregacji

**4.19. Jaką główną korzyść potoku agregacji podkreśla wykład?**

- A) Pozwala pominąć indeksy
- B) Większość operacji wykonuje się po stronie serwera, co ogranicza transfer danych i poprawia wydajność aplikacji
- C) Przenosi obliczenia do przeglądarki użytkownika
- D) Zastępuje replikację danych

<details><summary>Odpowiedź</summary>

**B** — dane są przetwarzane w bazie, a do aplikacji trafia tylko wynik. (slajd 146)

</details>

**4.20. Które z poniższych NIE jest wymienione jako zastosowanie Aggregation Framework?**

- A) Zasilanie paneli analitycznych (dashboardów)
- B) Przygotowanie danych do uczenia maszynowego i integracja z MongoDB Spark Connector
- C) Łączenie danych z wielu kolekcji po stronie serwera (`$lookup`)
- D) Automatyczne przełączanie na serwer zapasowy przy awarii

<details><summary>Odpowiedź</summary>

**D** — failover to cecha replikacji (replica set), a nie agregacji. Pozostałe są na liście zastosowań. (slajd 146)

</details>

**4.21. Co robi etap `{ "$sort": { "dateofbirth": -1 } }` w potoku „trzech najmłodszych inżynierów”?**

- A) Ustawia najmłodsze osoby na początku, bo najpóźniejsza data urodzenia jest największa
- B) Ustawia najstarsze osoby na początku
- C) Usuwa osoby bez daty urodzenia
- D) Grupuje osoby według roku urodzenia

<details><summary>Odpowiedź</summary>

**A** — `-1` to sortowanie malejące; komentarz na slajdzie: „Sort by youngest person first”. (slajd 147)

</details>

**4.22. Co robi etap `{ "$unset": ["_id", "vocation", "address"] }`?**

- A) Ustawia te pola na `null`
- B) Filtruje dokumenty, które nie mają tych pól
- C) Usuwa wskazane pola z dokumentów wynikowych
- D) Usuwa dokumenty z kolekcji źródłowej

<details><summary>Odpowiedź</summary>

**C** — to wykluczenie pól, odpowiednik `$project` z zerami. Kolekcja źródłowa się nie zmienia. (slajd 147)

</details>

**4.23. Które zapytanie MQL daje ten sam wynik co potok `$match` vocation ENGINEER, `$sort` dateofbirth -1, `$limit` 3, `$unset` _id, vocation, address?**

- A) `db.persons.find({vocation:"ENGINEER"}).sort({dateofbirth:1}).limit(3)`
- B) `db.persons.find({vocation:"ENGINEER"},{_id:1,vocation:1,address:1}).sort({dateofbirth:-1}).limit(3)`
- C) `db.persons.find({vocation:"ENGINEER"},{_id:0,vocation:0,address:0}).limit(3).sort({dateofbirth:1})`
- D) `db.persons.find({vocation:"ENGINEER"},{_id:0,vocation:0,address:0}).sort({dateofbirth:-1}).limit(3)`

<details><summary>Odpowiedź</summary>

**D** — filtr, projekcja z zerami, sortowanie malejące i limit 3. A i C sortują rosnąco, B włącza zamiast wykluczać. (slajd 148)

</details>

**4.24. Czego według slajdu nie ma w zapytaniu MQL, a co potrafi potok agregacji?**

- A) Sortowania
- B) Grupowania
- C) Limitowania wyników
- D) Projekcji pól

<details><summary>Odpowiedź</summary>

**B** — slajd: odpowiednik MQL daje ten sam wynik, „nie ma tutaj jednak grupowania”. Find potrafi filtrować, sortować, limitować i rzutować. (slajd 148)

</details>

**4.25. Który mechanizm serwera MongoDB obsługuje potoki agregacji według diagramu architektury?**

- A) Aggregation Runtime
- B) Query Runtime
- C) MQL API
- D) MongoDB Driver

<details><summary>Odpowiedź</summary>

**A** — w MongoDB Database Runtime są Query Runtime (zapytania MQL) i Aggregation Runtime (potoki). MQL API i Agg API to interfejsy sterownika po stronie aplikacji. (slajd 148)

</details>

**4.26. Który tryb `explain()` jest domyślny, gdy nie podasz parametru?**

- A) `executionStats`
- B) `allPlansExecution`
- C) `queryPlanner`
- D) `verbose`

<details><summary>Odpowiedź</summary>

**C** — komentarz na slajdzie: „QueryPlanner verbosity (default if no verbosity parameter provided)”. (slajd 149)

</details>

**4.27. Jak poprawnie wyświetlić plan wykonania ze statystykami dla potoku agregacji?**

- A) `db.persons.aggregate(pipeline).explain("executionStats")`
- B) `db.persons.aggregate(pipeline, "executionStats")`
- C) `db.persons.explain(pipeline).aggregate("executionStats")`
- D) `db.persons.explain("executionStats").aggregate(pipeline)`

<details><summary>Odpowiedź</summary>

**D** — przy agregacji `explain(tryb)` stoi przed `aggregate(pipeline)`. Przy `find` jest odwrotnie: `find(query).explain(tryb)`. (slajd 149)

</details>

**4.28. Co zwraca tryb `allPlansExecution`?**

- A) Tylko wybrany indeks
- B) Pełne dane o wszystkich rozważanych planach i ich statystykach
- C) Wyłącznie czas wykonania zapytania
- D) Wynik zapytania bez planu

<details><summary>Odpowiedź</summary>

**B** — `queryPlanner` daje podstawowy plan, `executionStats` dodaje statystyki wykonania, a `allPlansExecution` pokazuje dane o wszystkich planach. (slajd 149)

</details>

**4.29. Który zapis jest poprawny dla planu wykonania zapytania `find`?**

- A) `db.coll.find(query).explain("executionStats")`
- B) `db.coll.explain(query).find("executionStats")`
- C) `db.coll.find(query, "executionStats")`
- D) `db.coll.explain().find(query).stats()`

<details><summary>Odpowiedź</summary>

**A** — slajd pokazuje `db.coll.find(query).explain("queryPlanner" | "executionStats" | "allPlansExecution")`. (slajd 149)

</details>

**4.30. Po co według wykładu sprawdzać plan wykonania zapytania?**

- A) Żeby zmienić walidator kolekcji
- B) Żeby wyeksportować dane do pliku JSON
- C) Żeby upewnić się, że używany jest odpowiedni indeks, ocenić wydajność i zdecydować o optymalizacji modelu lub zapytania
- D) Żeby wymusić zapis na serwerze primary

<details><summary>Odpowiedź</summary>

**C** — plan pokazuje, jak MongoDB przetwarza zapytanie, i pozwala porównać koszt, np. skan kolekcji kontra użycie indeksu. (slajd 149)

</details>

**4.31. Jakie rozszerzenie ma plik playground w rozszerzeniu MongoDB dla VS Code pokazanym na wykładzie?**

- A) `.mongo`
- B) `.mql`
- C) `.json`
- D) `.mongodb.js`

<details><summary>Odpowiedź</summary>

**D** — na zrzucie otwarty jest plik `playground-1.mongodb.js`, a wynik pojawia się w panelu Playground Result. (slajd 150)

</details>

**4.32. Na którym porcie działa połączenie oznaczone na zrzucie VS Code jako „connected”, będące domyślnym portem MongoDB?**

- A) 27017
- B) 5432
- C) 3306
- D) 8080

<details><summary>Odpowiedź</summary>

**A** — `localhost:27017` to domyślny port MongoDB. 5432 to PostgreSQL, 3306 to MySQL. (slajd 150)

</details>

### SQL a operatory agregacji, grupowanie i `$group`

**4.33. Któremu etapowi agregacji odpowiada klauzula SQL `HAVING`?**

- A) `$match` umieszczonemu po `$group`
- B) `$group`
- C) `$project`
- D) `$having`

<details><summary>Odpowiedź</summary>

**A** — w tabeli ze slajdu `HAVING` → `$match`. Operatora `$having` nie ma; o roli `$match` decyduje jego pozycja w potoku. (slajd 151)

</details>

**4.34. Któremu operatorowi odpowiada SQL `SELECT INTO NEW_TABLE`?**

- A) `$merge`
- B) `$out`
- C) `$lookup`
- D) `$project`

<details><summary>Odpowiedź</summary>

**B** — `$out` zapisuje wynik potoku do kolekcji. `$merge` odpowiada `MERGE INTO TABLE`. (slajd 151)

</details>

**4.35. Który operator odpowiada SQL `UNION ALL` i od której wersji MongoDB jest dostępny?**

- A) `$merge`, od 4.2
- B) `$union`, od 4.0
- C) `$unionWith`, od 4.4
- D) `$concatArrays`, od 3.6

<details><summary>Odpowiedź</summary>

**C** — według tabeli: `UNION ALL` → `$unionWith` (od 4.4), `MERGE INTO TABLE` → `$merge` (od 4.2). (slajd 151)

</details>

**4.36. Który operator odpowiada SQL `MERGE INTO TABLE`?**

- A) `$out`
- B) `$unionWith`
- C) `$set`
- D) `$merge`

<details><summary>Odpowiedź</summary>

**D** — `$merge` (od MongoDB 4.2) scala wynik z istniejącą kolekcją, a `$out` ją zastępuje. (slajd 151)

</details>

**4.37. Którym operatorom według tabeli ze slajdu odpowiada funkcja SQL `COUNT()`?**

- A) `$sum` oraz `$sortByCount`
- B) `$avg` oraz `$count`
- C) `$size` oraz `$max`
- D) `$push` oraz `$addToSet`

<details><summary>Odpowiedź</summary>

**A** — w tabeli `COUNT()` → `$sum, $sortByCount`. W praktyce liczenie w grupie to `{ $sum: 1 }`. (slajd 151)

</details>

**4.38. Którym etapom odpowiadają kolejno SQL `SELECT` i `ORDER BY`?**

- A) `$match` i `$group`
- B) `$project` i `$sort`
- C) `$addFields` i `$limit`
- D) `$lookup` i `$sort`

<details><summary>Odpowiedź</summary>

**B** — `SELECT` → `$project`, `ORDER BY` → `$sort`; dodatkowo `WHERE` → `$match`, `LIMIT` → `$limit`, `join` → `$lookup`. (slajd 151)

</details>

**4.39. Który zapis etapu `$group` jest składniowo poprawny?**

- A) `{ $group: { _id: "$cust_id" }, total: { $sum: "$amount" } }`
- B) `{ $group: { total: { $sum: "$amount" } } }`
- C) `{ $group: { _id: "$cust_id", total: { $sum: "$amount" } } }`
- D) `{ $group: "$cust_id", total: { $sum: "$amount" } }`

<details><summary>Odpowiedź</summary>

**C** — pola wynikowe muszą stać wewnątrz `$group` obok `_id`. Uwaga: ogólny zapis na slajdzie 152 zamyka `$group` zaraz po `_id` (jak w A), co jest błędem. B nie ma obowiązkowego `_id`. (slajdy 152, 155)

</details>

**4.40. Jak w `$group` policzyć liczbę dokumentów w każdej grupie?**

- A) `{ $count: 1 }`
- B) `{ $sum: "1" }`
- C) `{ $avg: 1 }`
- D) `{ $sum: 1 }`

<details><summary>Odpowiedź</summary>

**D** — slajd: „Jeżeli chcemy zliczyć ilość dokumentów w danej grupie, użyjemy { $sum : 1 }”. Za każdy dokument dodawana jest jedynka. (slajdy 152, 155)

</details>

**4.41. Czym różni się akumulator `$addToSet` od `$push`?**

- A) `$addToSet` zbiera do tablicy tylko unikalne wartości, a `$push` wszystkie, z duplikatami
- B) `$addToSet` sumuje wartości, a `$push` je liczy
- C) `$push` zbiera tylko unikalne wartości
- D) Nie ma różnicy, to aliasy

<details><summary>Odpowiedź</summary>

**A** — tabela akumulatorów: `$push` zbiera wartości do tablicy, `$addToSet` zbiera unikalne wartości do tablicy. (slajdy 152, 155)

</details>

**4.42. Co zwróci potok `[{ $match: { status: "A" } }, { $group: { _id: "$cust_id", total: { $sum: "$amount" } } }, { $sort: { total: -1 } }, { $limit: 2 }]`?**

- A) Dwa pierwsze zamówienia o statusie A
- B) Dwóch klientów z największą sumą kwot zamówień o statusie A
- C) Dwóch klientów z najmniejszą sumą kwot
- D) Liczbę zamówień o statusie A

<details><summary>Odpowiedź</summary>

**B** — filtr status A, suma kwot na klienta, sortowanie malejąco po sumie, dwa pierwsze wyniki. (slajd 152)

</details>

**4.43. Który akumulator oblicza odchylenie standardowe próby?**

- A) `$stdDevPop`
- B) `$avg`
- C) `$stdDevSamp`
- D) `$variance`

<details><summary>Odpowiedź</summary>

**C** — `$stdDevSamp` to próba, `$stdDevPop` to populacja. `$variance` nie jest akumulatorem MongoDB. (slajd 152)

</details>

**4.44. Który akumulator z tabeli na slajdzie zwraca element o najwyższym miejscu w sortowaniu?**

- A) `$max`
- B) `$first`
- C) `$bottom`
- D) `$top`

<details><summary>Odpowiedź</summary>

**D** — `$top` zwraca element o najwyższym sortowaniu, `$bottom` o najniższym. `$max` zwraca największą wartość, a nie element wg kryterium sortowania. (slajd 152)

</details>

**4.45. Które zdanie o etapach potoku jest prawdziwe?**

- A) Kolejność etapów jest istotna, bo każdy etap działa na wynikach poprzedniego
- B) Etapy wykonują się równolegle na kolekcji źródłowej
- C) Potok może mieć najwyżej trzy etapy
- D) Kolejność etapów nie ma znaczenia, bo optymalizator zawsze ją ustala

<details><summary>Odpowiedź</summary>

**A** — slajd: potoki mogą mieć jeden lub więcej etapów, kolejność jest istotna, każdy etap działa na wyniku poprzedniego. (slajd 153)

</details>

**4.46. Co zwróci `db.posts.aggregate([{ $match: { likes: { $gt: 1 } } }, { $group: { _id: "$category", totalLikes: { $sum: "$likes" } } }])`?**

- A) Liczbę postów w każdej kategorii
- B) Dla każdej kategorii sumę polubień postów, które mają więcej niż 1 polubienie
- C) Posty z więcej niż 1 polubieniem, posortowane po kategorii
- D) Jedną liczbę: sumę wszystkich polubień

<details><summary>Odpowiedź</summary>

**B** — wynik ze slajdu: `[ { _id: 'News', totalLikes: 3 }, { _id: 'Event', totalLikes: 8 } ]`. (slajd 153)

</details>

**4.47. Co zwraca `db.listingsAndReviews.aggregate([ { $group: { _id: "$property_type" } } ])`?**

- A) Liczbę ogłoszeń każdego typu
- B) Wszystkie ogłoszenia posortowane po typie
- C) Wszystkie różne wartości pola `property_type`, każdą w osobnym dokumencie jako `_id`
- D) Błąd, bo brakuje akumulatora

<details><summary>Odpowiedź</summary>

**C** — `$group` z samym `_id` działa jak `SELECT DISTINCT`; wynik to np. `{ _id: 'Apartment' }`, `{ _id: 'Hotel' }`. Akumulator nie jest obowiązkowy. (slajd 154)

</details>

**4.48. Co oznacza `_id: null` w etapie `$group`?**

- A) Grupowanie według pola o nazwie `null`
- B) Usunięcie pola `_id` z wyniku
- C) Błąd składni
- D) Wszystkie dokumenty trafiają do jednej grupy

<details><summary>Odpowiedź</summary>

**D** — slajd: w `_id` można podać pole, wyrażenie albo `null`, jeśli chcemy przetwarzać wszystkie dokumenty w jednej grupie. (slajd 155)

</details>

**4.49. Który etap oblicza średnią cenę produktów w każdej kategorii?**

- A) `{ $group: { _id: "$kategoria", sredniaCena: { $avg: "$cena" } } }`
- B) `{ $group: { _id: "kategoria", sredniaCena: { $avg: "cena" } } }`
- C) `{ $avg: { _id: "$kategoria", sredniaCena: "$cena" } }`
- D) `{ $group: { _id: "$kategoria", sredniaCena: { $sum: "$cena" } } }`

<details><summary>Odpowiedź</summary>

**A** — odwołania do pól wymagają znaku `$`. W B napisy bez `$` są stałymi, C nie jest etapem, a D liczy sumę. (slajd 155)

</details>

**4.50. Jaki wynik da `$group` z polem `unikalneZnaczniki: { $addToSet: "$znacznik" }` i `_id: "$kategoria"`?**

- A) Liczbę znaczników w każdej kategorii
- B) Dla każdej kategorii tablicę unikalnych znaczników, np. `{ "_id": "technologia", "unikalneZnaczniki": ["AI", "ML"] }`
- C) Jedną tablicę wszystkich znaczników z duplikatami
- D) Dokumenty z kategoriami bez duplikatów, bez znaczników

<details><summary>Odpowiedź</summary>

**B** — taki wynik pokazuje żółta ramka na slajdzie. (slajd 155)

</details>

### Etapy `$limit`, `$project`, `$sort`, `$match`

**4.51. Co zwróci `db.movies.aggregate([ { $limit: 1 } ])`?**

- A) Liczbę dokumentów w kolekcji
- B) Film z najwcześniejszą datą premiery
- C) Pierwszy znaleziony dokument z kolekcji
- D) Błąd, bo `$limit` wymaga wcześniejszego `$sort`

<details><summary>Odpowiedź</summary>

**C** — bez sortowania „pierwszy” oznacza pierwszy w naturalnej kolejności, a nie logicznie najwcześniejszy. `$sort` nie jest wymagany. (slajd 156)

</details>

**4.52. Który potok zwróci trzy najdroższe produkty?**

- A) `[{ $limit: 3 }, { $sort: { cena: -1 } }]`
- B) `[{ $sort: { cena: 1 } }, { $limit: 3 }]`
- C) `[{ $sort: { cena: -1 } }, { $count: 3 }]`
- D) `[{ $sort: { cena: -1 } }, { $limit: 3 }]`

<details><summary>Odpowiedź</summary>

**D** — najpierw sortowanie malejące, potem limit. A sortuje tylko trzy przypadkowe dokumenty, B daje najtańsze, a `$count` przyjmuje napis. Slajd: `$limit` stosuj po `$sort` lub `$match`. (slajd 157)

</details>

**4.53. Jaka jest składnia etapu `$limit`?**

- A) `{ $limit: <liczba_dokumentów_do_zwrotu> }`
- B) `{ $limit: { n: <liczba> } }`
- C) `{ $limit: "<nazwa_pola>" }`
- D) `{ $limit: [<od>, <do>] }`

<details><summary>Odpowiedź</summary>

**A** — np. `db.produkty.aggregate([ { $limit: 5 } ])`. Napis jako argument przyjmuje `$count`, nie `$limit`. (slajd 157)

</details>

**4.54. Jakie pola będą w wyniku `db.restaurants.aggregate([ { $project: { "name": 1, "cuisine": 1, "address": 1 } } ])`?**

- A) Tylko `name`, `cuisine`, `address`
- B) `_id`, `name`, `cuisine`, `address`
- C) Wszystkie pola poza `name`, `cuisine`, `address`
- D) Wszystkie pola dokumentu

<details><summary>Odpowiedź</summary>

**B** — `_id` jest dołączane domyślnie, chyba że jawnie wykluczysz je przez `_id: 0`. Przykładowy wynik na slajdzie zawiera `_id`. (slajd 158)

</details>

**4.55. Co oznaczają wartości `1` i `0` w `$project`?**

- A) `1` sortuje rosnąco, `0` malejąco
- B) `1` oznacza pole wymagane, `0` opcjonalne
- C) `1` uwzględnia pole w wyniku, `0` je wyklucza
- D) `1` tworzy indeks na polu, `0` go usuwa

<details><summary>Odpowiedź</summary>

**C** — dodatkowo zamiast liczby można podać wyrażenie tworzące nowe pole. (slajd 159)

</details>

**4.56. Które wyrażenie w `$project` utworzy pole z imieniem i nazwiskiem rozdzielonymi spacją?**

- A) `pelne_nazwisko: { $concat: ["$imie", " ", "$nazwisko"] }`
- B) `pelne_nazwisko: { $concat: ["imie", " ", "nazwisko"] }`
- C) `pelne_nazwisko: { $add: ["$imie", "$nazwisko"] }`
- D) `pelne_nazwisko: "$imie $nazwisko"`

<details><summary>Odpowiedź</summary>

**A** — `$concat` skleja napisy, a odwołania do pól mają znak `$`. W B skleiłyby się dosłowne napisy „imie” i „nazwisko”. (slajd 159)

</details>

**4.57. Które wyrażenie wyliczy wartość całkowitą jako cenę razy ilość?**

- A) `{ $sum: ["$cena", "$ilosc"] }`
- B) `{ $multiply: ["$cena", "$ilosc"] }`
- C) `{ $product: ["$cena", "$ilosc"] }`
- D) `{ $mul: ["$cena", "$ilosc"] }`

<details><summary>Odpowiedź</summary>

**B** — `$multiply` mnoży wartości. `$mul` to operator aktualizacji w `updateOne`, a nie wyrażenie agregacji. (slajdy 159, 165)

</details>

**4.58. Które wyrażenie wyciągnie rok z pola `data_urodzenia`?**

- A) `{ $dateToYear: "$data_urodzenia" }`
- B) `{ $getYear: "$data_urodzenia" }`
- C) `{ $year: "data_urodzenia" }`
- D) `{ $year: "$data_urodzenia" }`

<details><summary>Odpowiedź</summary>

**D** — `$year` z odwołaniem do pola przez `$`. C podaje napis zamiast pola. (slajdy 159, 165)

</details>

**4.59. Jak posortuje dokumenty etap `{ $sort: { wiek: 1, nazwisko: -1 } }`?**

- A) Rosnąco po wieku, a przy równym wieku malejąco po nazwisku
- B) Malejąco po nazwisku, a przy równym nazwisku rosnąco po wieku
- C) Rosnąco po obu polach
- D) Tylko po wieku, drugie pole jest ignorowane

<details><summary>Odpowiedź</summary>

**A** — pierwsze pole decyduje najpierw, drugie rozstrzyga remisy. (slajd 161)

</details>

**4.60. Jakimi wartościami określa się kierunek sortowania w `$sort`?**

- A) `"asc"` i `"desc"`
- B) `true` i `false`
- C) `1` (rosnąco) i `-1` (malejąco)
- D) `0` (rosnąco) i `1` (malejąco)

<details><summary>Odpowiedź</summary>

**C** — slajd: wartość 1 oznacza sortowanie rosnące, a -1 malejące. (slajd 161)

</details>

**4.61. Co zwróci potok `[{ $sort: { "accommodates": -1 } }, { $project: { "name": 1, "accommodates": 1 } }, { $limit: 5 }]` na kolekcji `listingsAndReviews`?**

- A) Pięć ogłoszeń mieszczących najmniej osób
- B) Pięć ogłoszeń mieszczących najwięcej osób, z polami `_id`, `name`, `accommodates`
- C) Liczbę ogłoszeń dla każdej wartości `accommodates`
- D) Pięć losowych ogłoszeń ze wszystkimi polami

<details><summary>Odpowiedź</summary>

**B** — sortowanie malejące po `accommodates`; na slajdzie wszystkie pięć wyników ma `accommodates: 16`. (slajd 160)

</details>

**4.62. Do czego według slajdu podobny jest etap `$match`?**

- A) Do `insertOne()`
- B) Do `distinct()`
- C) Do `updateMany()`
- D) Do `find()`: filtruje dokumenty pasujące do zapytania

<details><summary>Odpowiedź</summary>

**D** — slajd: „Ten etap agregacji zachowuje się jak find”. (slajdy 162, 163)

</details>

**4.63. Który etap wybierze zamówienia z września 2024 (włącznie z krańcami)?**

- A) `{ $match: { data_zamowienia: { $gt: new Date("2024-09-01"), $lt: new Date("2024-09-30") } } }`
- B) `{ $match: { data_zamowienia: { $in: [new Date("2024-09-01"), new Date("2024-09-30")] } } }`
- C) `{ $match: { data_zamowienia: { $gte: new Date("2024-09-01"), $lte: new Date("2024-09-30") } } }`
- D) `{ $match: { $gte: { data_zamowienia: new Date("2024-09-01") } } }`

<details><summary>Odpowiedź</summary>

**C** — `$gte` i `$lte` obejmują krańce. A pomija krańce, B dopasowuje tylko dwie konkretne daty, D ma złą składnię. (slajd 163)

</details>

**4.64. Co dopasuje `{ $match: { nazwa: { $regex: /^Sam/, $options: "i" } } }`?**

- A) Nazwy zaczynające się od „Sam” bez względu na wielkość liter
- B) Nazwy kończące się na „Sam”
- C) Nazwy zawierające „Sam” tylko wielkimi literami
- D) Nazwy dokładnie równe „Sam”

<details><summary>Odpowiedź</summary>

**A** — `^` oznacza początek napisu, opcja `i` wyłącza rozróżnianie wielkości liter. (slajd 163)

</details>

**4.65. Który etap wybierze produkty z kategorii „elektronika” LUB „meble”?**

- A) `{ $match: { kategoria: "elektronika", kategoria: "meble" } }`
- B) `{ $match: { $or: [ { kategoria: "elektronika" }, { kategoria: "meble" } ] } }`
- C) `{ $match: { $and: [ { kategoria: "elektronika" }, { kategoria: "meble" } ] } }`
- D) `{ $match: { kategoria: { $all: ["elektronika", "meble"] } } }`

<details><summary>Odpowiedź</summary>

**B** — `$or` z tablicą warunków. W A drugi klucz nadpisuje pierwszy, C i D wymagają obu wartości naraz. Równoważnie można użyć `$in`. (slajd 163)

</details>

**4.66. Dlaczego warto umieszczać `$match` na początku potoku?**

- A) Bo `$match` musi być zawsze pierwszym etapem
- B) Bo po `$match` nie można użyć `$group`
- C) Bo ogranicza liczbę dokumentów dla kolejnych etapów i na początku potoku może skorzystać z indeksu
- D) Bo `$match` sortuje dokumenty

<details><summary>Odpowiedź</summary>

**C** — slajd: filtrowanie na wczesnym etapie często zwiększa efektywność całej operacji. `$match` może stać w dowolnym miejscu, np. po `$group` jako HAVING. (slajd 163)

</details>

**4.67. Co oznaczają dwa warunki w jednym dokumencie: `{ $match: { kategoria: "elektronika", cena: { $lt: 500 } } }`?**

- A) Oba warunki muszą być spełnione naraz (niejawne AND)
- B) Wystarczy jeden z warunków (OR)
- C) Pierwszy warunek jest ignorowany
- D) Błąd składni, potrzebny jest `$and`

<details><summary>Odpowiedź</summary>

**A** — przecinek między warunkami w jednym dokumencie filtra działa jak AND: elektronika tańsza niż 500. (slajd 163)

</details>

### Etapy `$addFields` i `$count`

**4.68. Czym `$addFields` różni się od `$project`?**

- A) `$addFields` usuwa wszystkie pola poza nowymi
- B) `$addFields` działa tylko na tablicach
- C) Niczym, to aliasy
- D) `$addFields` zachowuje wszystkie istniejące pola i dodaje nowe (lub nadpisuje istniejące), a `$project` zostawia tylko wymienione pola i `_id`

<details><summary>Odpowiedź</summary>

**D** — slajd: `$addFields` dodaje nowe pola lub modyfikuje istniejące. Aliasem `$addFields` jest `$set`, nie `$project`. (slajd 165)

</details>

**4.69. Co oblicza `{ $addFields: { avgGrade: { $avg: "$grades.score" } } }` na kolekcji `restaurants`?**

- A) Średnią wszystkich ocen we wszystkich restauracjach
- B) Dla każdej restauracji średnią wartości `score` z jej tablicy `grades`
- C) Liczbę ocen każdej restauracji
- D) Najwyższą ocenę każdej restauracji

<details><summary>Odpowiedź</summary>

**B** — `$addFields` działa na każdym dokumencie osobno; wynik to np. Riviera Caterer z `avgGrade: 9`. Średnią po wszystkich restauracjach dałby `$group` z `_id: null`. (slajd 164)

</details>

**4.70. Który zapis poprawnie tworzy pole `kategoria` równe „dorosły” dla wieku co najmniej 18, a w przeciwnym razie „nieletni”?**

- A) `{ $cond: { if: { $gte: ["$wiek", 18] }, then: "dorosły", else: "nieletni" } }`
- B) `{ $if: { $gte: ["$wiek", 18] }, $then: "dorosły", $else: "nieletni" }`
- C) `{ $cond: { if: { wiek: { $gte: 18 } }, then: "dorosły" } }`
- D) `{ $switch: ["$wiek", 18, "dorosły", "nieletni"] }`

<details><summary>Odpowiedź</summary>

**A** — `$cond` z polami `if`, `then`, `else`; warunek to wyrażenie agregacji `$gte` z tablicą. (slajd 165)

</details>

**4.71. Co zwraca etap `{ $addFields: { status: "aktywny" } }`?**

- A) Tylko dokumenty, które mają `status` równy „aktywny”
- B) Dokumenty wyłącznie z polem `status`
- C) Wszystkie dokumenty z dotychczasowymi polami i nowym polem `status` o wartości „aktywny”
- D) Błąd, bo wartość musi być wyrażeniem z `$`

<details><summary>Odpowiedź</summary>

**C** — `$addFields` może dodać stałą wartość. Filtrowanie (A) to zadanie `$match`. (slajd 165)

</details>

**4.72. Jak poprawnie zapisać etap `$count`?**

- A) `{ $count: 1 }`
- B) `{ $count: { total: 1 } }`
- C) `{ $count: "$cuisine" }`
- D) `{ $count: "totalChinese" }`

<details><summary>Odpowiedź</summary>

**D** — argumentem jest napis z nazwą pola wynikowego. Nazwa nie może zaczynać się od `$`. (slajdy 166, 167)

</details>

**4.73. Co zwróci `db.restaurants.aggregate([ { $match: { "cuisine": "Chinese" } }, { $count: "totalChinese" } ])`?**

- A) Wszystkie chińskie restauracje z dodanym polem `totalChinese`
- B) Jeden dokument, np. `{ totalChinese: 2418 }`
- C) Liczbę restauracji każdej kuchni
- D) Tablicę nazw chińskich restauracji

<details><summary>Odpowiedź</summary>

**B** — `$count` zwraca jeden dokument z nazwanym polem i liczbą dokumentów, które do niego dotarły. (slajd 166)

</details>

**4.74. Co policzy potok `[{ $group: { _id: "$kategoria", liczba_produktow: { $sum: 1 } } }, { $match: { liczba_produktow: { $gte: 10 } } }, { $count: "kategorie_z_min_10_produktow" }]`?**

- A) Liczbę produktów w każdej kategorii
- B) Liczbę produktów droższych niż 10
- C) Liczbę kategorii, w których jest co najmniej 10 produktów
- D) Dziesięć największych kategorii

<details><summary>Odpowiedź</summary>

**C** — grupowanie z liczeniem, filtr po zgrupowaniu (odpowiednik HAVING) i zliczenie pozostałych grup. (slajd 167)

</details>

**4.75. Które zdanie o `$count` jest prawdziwe?**

- A) `$count` przyjmuje warunek filtrowania jako argument
- B) `$count` zwraca liczbę dla każdej grupy osobno
- C) `$count` musi być pierwszym etapem potoku
- D) `$count` zlicza dokumenty przekazane z poprzedniego etapu, a warunki nakłada się wcześniejszym `$match`

<details><summary>Odpowiedź</summary>

**D** — slajd: „zliczana jest całkowita liczba dokumentów przekazanych na poprzednim etapie”. Liczba na grupę to `{ $sum: 1 }` w `$group`. (slajdy 166, 167)

</details>

### Etapy `$lookup` i `$out`

**4.76. Jaki rodzaj złączenia wykonuje `$lookup`?**

- A) Złączenie lewostronne zewnętrzne (left outer join) z kolekcją w tej samej bazie danych
- B) Złączenie wewnętrzne (inner join) z kolekcją w dowolnej bazie
- C) Iloczyn kartezjański dwóch kolekcji
- D) Złączenie prawostronne zewnętrzne

<details><summary>Odpowiedź</summary>

**A** — dokumenty bez dopasowania zostają w wyniku z pustą tablicą. (slajd 168)

</details>

**4.77. Jakie cztery pola wymaga podstawowa postać `$lookup`?**

- A) `from`, `on`, `to`, `as`
- B) `from`, `localField`, `foreignField`, `as`
- C) `collection`, `localKey`, `foreignKey`, `into`
- D) `join`, `localField`, `foreignField`, `result`

<details><summary>Odpowiedź</summary>

**B** — `from` (kolekcja do dołączenia), `localField` (pole w kolekcji podstawowej), `foreignField` (pole w kolekcji `from`), `as` (nazwa nowego pola). (slajdy 168, 169)

</details>

**4.78. W potoku `db.comments.aggregate([{ $lookup: { from: "movies", localField: ?, foreignField: ?, as: "movie_details" } }])` co należy wpisać, żeby dołączyć film do komentarza?**

- A) `localField: "_id"`, `foreignField: "movie_id"`
- B) `localField: "movies"`, `foreignField: "comments"`
- C) `localField: "movie_id"`, `foreignField: "_id"`
- D) `localField: "movie_details"`, `foreignField: "_id"`

<details><summary>Odpowiedź</summary>

**C** — `localField` to pole w `comments` (`movie_id`), a `foreignField` to pole w `movies` (`_id`). A zamienia je miejscami. (slajd 168)

</details>

**4.79. Co zawiera pole wskazane w `as` po etapie `$lookup`?**

- A) Pojedynczy dołączony dokument albo `null`
- B) Liczbę dopasowanych dokumentów
- C) Tylko `_id` dopasowanych dokumentów
- D) Tablicę pasujących dokumentów z kolekcji `from` (pustą, gdy brak dopasowań)

<details><summary>Odpowiedź</summary>

**D** — w przykładzie `movie_details` to tablica z jednym dokumentem filmu. Pojedynczy obiekt uzyskuje się dopiero np. przez `$unwind`. (slajd 168)

</details>

**4.80. Które zdanie o `localField` i `foreignField` jest prawdziwe?**

- A) Oba pola muszą być unikalne w swoich kolekcjach
- B) `$lookup` dopasowuje dokumenty, w których wartość `localField` jest równa wartości `foreignField`; pola nie muszą być unikalne
- C) `foreignField` musi być zawsze polem `_id`
- D) `localField` wskazuje pole w kolekcji `from`

<details><summary>Odpowiedź</summary>

**B** — slajd 168 mówi o polach, które „mogą być używane jako unikatowy identyfikator”, ale unikalność nie jest wymagana; to dopasowanie po równości wartości. (slajdy 168, 169)

</details>

**4.81. Co stanie się, gdy `$out` wskaże kolekcję, która już istnieje?**

- A) Wynik zostanie dopisany do istniejących dokumentów
- B) Operacja zakończy się błędem
- C) Istniejąca kolekcja zostanie zastąpiona, a jej dotychczasowe dane usunięte
- D) Zostanie utworzona kolekcja z sufiksem `_1`

<details><summary>Odpowiedź</summary>

**C** — slajd: `$out` tworzy nową kolekcję, jeśli nie istnieje, lub zastępuje istniejącą. Dopisywanie i scalanie to rola `$merge`. (slajd 171)

</details>

**4.82. Gdzie w potoku musi stać etap `$out`?**

- A) Na początku
- B) Bezpośrednio po `$match`
- C) W dowolnym miejscu
- D) Na końcu, jako ostatni etap

<details><summary>Odpowiedź</summary>

**D** — slajd: „$out powinno być ostatnim etapem w potoku agregacji”. (slajd 171)

</details>

**4.83. Które zdanie o `$out` jest FAŁSZYWE?**

- A) `$out` można używać wewnątrz transakcji
- B) `$out` materializuje wynik potoku w kolekcji
- C) `$out` nie może występować razem z `$merge` w jednym potoku
- D) Składnia to `{ $out: "<nazwa_nowej_kolekcji>" }`

<details><summary>Odpowiedź</summary>

**A** — slajd: `$out` nie działa w ramach transakcji. Pozostałe zdania są prawdziwe. (slajd 171)

</details>

**4.84. Co zapisze potok `[{ $group: { _id: "$property_type", properties: { $push: { name: "$name", accommodates: "$accommodates", price: "$price" } } } }, { $out: "properties_by_type" }]`?**

- A) Kolekcję z jednym dokumentem na każdy typ nieruchomości, z tablicą `properties` zawierającą obiekty z nazwą, liczbą miejsc i ceną
- B) Kolekcję z jednym dokumentem zawierającym liczbę typów
- C) Kopię kolekcji `listingsAndReviews` posortowaną po typie
- D) Nic, bo `$push` nie może budować obiektów

<details><summary>Odpowiedź</summary>

**A** — na zrzucie kolekcja `properties_by_type` ma 36 dokumentów, np. `_id: "Boat"` z tablicą `properties`. `$push` może zbierać całe obiekty. (slajd 170)

</details>

**4.85. Do czego według wykładu służy zapis wyniku potoku przez `$out`?**

- A) Do tymczasowego wyświetlenia wyniku bez zapisu
- B) Do zmaterializowania wyników zapytania, czyli utworzenia trwałych danych z dynamicznie wyliczonego wyniku
- C) Do eksportu danych do pliku JSON
- D) Do utworzenia indeksu na wyniku

<details><summary>Odpowiedź</summary>

**B** — slajd: „przydatne, gdy chcemy zmaterializować wyniki zapytania”. Eksport do pliku robi narzędzie `mongoexport`. (slajd 171)

</details>

### Import danych (`mongoimport`) i Map-Reduce

**4.86. Które polecenie zaimportuje plik `Customer05.json` do kolekcji `clients` w bazie `customers`?**

- A) `db.clients.import("Customer05.json")`
- B) `mongoimport --database customers --table clients Customer05.json`
- C) `mongoimport --db=customers --collection=clients --file=Customer05.json`
- D) `mongorestore --db=customers --collection=clients --file=Customer05.json`

<details><summary>Odpowiedź</summary>

**C** — opcje `--db`, `--collection`, `--file`. `mongorestore` odtwarza kopie BSON z `mongodump`, a opcji `--table` nie ma. (slajd 172)

</details>

**4.87. Gdzie uruchamia się `mongoimport`?**

- A) W powłoce `mongosh`, jako metodę `db`
- B) W panelu Playground w VS Code
- C) W etapie `$out` potoku agregacji
- D) W konsoli systemu (np. cmd.exe), jako osobne narzędzie z pakietu MongoDB Database Tools

<details><summary>Odpowiedź</summary>

**D** — zrzut pokazuje `mongoimport.exe` uruchamiane w `cmd.exe` z katalogu `bin` narzędzi. (slajd 172)

</details>

**4.88. Które zdanie o MongoDB Database Tools jest zgodne z wykładem?**

- A) Są wydawane niezależnie od harmonogramu wydań serwera MongoDB, co daje częstsze aktualizacje
- B) Są częścią powłoki `mongosh`
- C) Działają tylko z MongoDB Atlas
- D) Są wydawane zawsze razem z nową wersją serwera

<details><summary>Odpowiedź</summary>

**A** — opis ze strony pobierania na slajdzie; widoczna wersja 100.8.0 dla Windows x86_64. (slajd 172)

</details>

**4.89. Ile dokumentów zaimportowano do kolekcji `listingsAndReviews` w przykładzie z wykładu?**

- A) 23539
- B) 5555
- C) 50304
- D) 36

<details><summary>Odpowiedź</summary>

**B** — 5555 dokumentów (95 MB). 23539 to `movies`, 50304 to `comments`, a 36 to liczba typów w `properties_by_type`. (slajdy 172, 170)

</details>

**4.90. Jaki jest status Map-Reduce w MongoDB według wykładu?**

- A) Zalecana metoda agregacji dużych danych
- B) Jedyny sposób zapisu wyniku do nowej kolekcji
- C) Mechanizm przestarzały; potok agregacji zapewnia lepszą wydajność i użyteczność
- D) Mechanizm dostępny tylko w Atlasie

<details><summary>Odpowiedź</summary>

**C** — tytuł slajdu: „Map-Reduce - przestarzały”; agregacja jest wydajniejsza. Wynik do kolekcji zapisuje też `$out`. (slajd 173)

</details>

**4.91. Jak wygląda funkcja map w przykładzie `db.orders.mapReduce(...)`?**

- A) `function() { emit(this.cust_id, this.amount); }`
- B) `function(key, values) { return Array.sum(values) }`
- C) `function() { return this.amount; }`
- D) `function(doc) { group(doc.cust_id, doc.amount); }`

<details><summary>Odpowiedź</summary>

**A** — map emituje parę klucz–wartość przez `emit`. B to funkcja reduce. (slajd 173)

</details>

**4.92. Kolekcja `orders` zawiera: A123/500/A, A123/250/A, B212/200/A, A123/300/D. Jaki wynik da `mapReduce` z `query: { status: "A" }` i sumowaniem kwot dla klienta A123?**

- A) `{ _id: "A123", value: 1050 }`
- B) `{ _id: "A123", value: 300 }`
- C) `{ _id: "A123", value: 500 }`
- D) `{ _id: "A123", value: 750 }`

<details><summary>Odpowiedź</summary>

**D** — zamówienie ze statusem D odpada w kroku query; 500 + 250 = 750. B212 dostaje 200. (slajd 173)

</details>

**4.93. Która opcja `mapReduce` wskazuje kolekcję wynikową?**

- A) `query`
- B) `out`
- C) `into`
- D) `finalize`

<details><summary>Odpowiedź</summary>

**B** — `out: "order_totals"`; `query` to filtr wstępny dokumentów. (slajd 173)

</details>

### Indeksy: cel, rodzaje, TTL

**4.94. Która z wymienionych rzeczy NIE jest celem indeksów według wykładu?**

- A) Przyspieszanie zapytań
- B) Optymalizacja sortowania
- C) Przyspieszanie operacji zapisu (insert, update)
- D) Zwiększenie efektywności agregacji z `$match`, `$sort`, `$group`

<details><summary>Odpowiedź</summary>

**C** — indeksy spowalniają zapisy, bo każde wstawienie i aktualizacja wymaga odświeżenia wszystkich indeksów. (slajdy 174, 177)

</details>

**4.95. Jaki indeks MongoDB tworzy automatycznie w każdej kolekcji?**

- A) Indeks tekstowy na wszystkich polach typu string
- B) Indeks TTL na polu daty utworzenia
- C) Indeks złożony na wszystkich polach
- D) Indeks na polu `_id`

<details><summary>Odpowiedź</summary>

**D** — indeks domyślny (Primary Index) na `_id` zapewnia unikalność dokumentów i szybkie wyszukiwanie po `_id`. (slajdy 175, 178)

</details>

**4.96. Które polecenie utworzy indeks gwarantujący unikalność adresów e-mail?**

- A) `db.uzytkownicy.createIndex({ email: 1 }, { unique: true })`
- B) `db.uzytkownicy.createIndex({ email: "unique" })`
- C) `db.uzytkownicy.createUniqueIndex({ email: 1 })`
- D) `db.uzytkownicy.createIndex({ email: 1, unique: 1 })`

<details><summary>Odpowiedź</summary>

**A** — `unique: true` to opcja w drugim argumencie. D tworzy indeks złożony na polach `email` i `unique`. (slajd 175)

</details>

**4.97. Które polecenie tworzy indeks tekstowy na polach `tytul` i `zawartosc`?**

- A) `db.artykuly.createIndex({ tytul: 1, zawartosc: 1 })`
- B) `db.artykuly.createIndex({ tytul: "text", zawartosc: "text" })`
- C) `db.artykuly.createTextIndex(["tytul", "zawartosc"])`
- D) `db.artykuly.createIndex({ $text: ["tytul", "zawartosc"] })`

<details><summary>Odpowiedź</summary>

**B** — zamiast kierunku podaje się napis `"text"`. A to zwykły indeks złożony. (slajd 175)

</details>

**4.98. Jaką wartość podaje się przy polu, by utworzyć indeks geoprzestrzenny dla zapytań na kuli ziemskiej?**

- A) `"geo"`
- B) `"location"`
- C) `"2dsphere"`
- D) `"hashed"`

<details><summary>Odpowiedź</summary>

**C** — `db.lokacje.createIndex({ lokalizacja: "2dsphere" })`. `"hashed"` to indeks haszowany, używany m.in. przy shardingu. (slajd 176)

</details>

**4.99. Która opcja tworzy indeks częściowy, obejmujący tylko aktywnych użytkowników?**

- A) `{ sparse: true }`
- B) `{ filter: { status: "aktywny" } }`
- C) `{ where: { status: "aktywny" } }`
- D) `{ partialFilterExpression: { status: "aktywny" } }`

<details><summary>Odpowiedź</summary>

**D** — `db.uzytkownicy.createIndex({ status: 1 }, { partialFilterExpression: { status: "aktywny" } })`. `sparse` to inna opcja (pomija dokumenty bez pola). (slajd 176)

</details>

**4.100. Co robi `db.sesje.createIndex({ utworzone: 1 }, { expireAfterSeconds: 3600 })`?**

- A) Tworzy indeks TTL, który automatycznie usuwa dokumenty po godzinie od czasu w polu `utworzone`
- B) Usuwa indeks po godzinie
- C) Blokuje zapisy do kolekcji przez godzinę
- D) Tworzy indeks, który odświeża się co godzinę

<details><summary>Odpowiedź</summary>

**A** — 3600 sekund to godzina; indeks TTL (Time-To-Live) usuwa dokumenty po upływie czasu. Usuwanie robi proces w tle, więc nie jest co do sekundy. (slajd 176)

</details>

**4.101. Które zdanie o ograniczeniach indeksów TTL jest zgodne z wykładem?**

- A) TTL działa najlepiej na kolekcjach typu capped
- B) TTL obejmuje tylko jedno pole typu data (tradycyjnie nie jest indeksem złożonym) i nie działa na kolekcjach capped
- C) TTL można założyć na dowolnej liczbie pól tekstowych
- D) TTL nie obciąża bazy, bo usuwanie odbywa się poza serwerem

<details><summary>Odpowiedź</summary>

**B** — ramka na slajdzie: tylko jedno pole daty, brak wsparcia dla capped, obciążenie bazy przy masowym usuwaniu w tle z bardzo dużych kolekcji. (slajd 176)

</details>

**4.102. Jaka jest główna wada indeksów według wykładu?**

- A) Spowalniają odczyty
- B) Uniemożliwiają sortowanie
- C) Obniżają wydajność zapisu, bo każde wstawienie i aktualizacja wymaga odświeżenia wszystkich indeksów
- D) Wymagają włączenia walidacji schematu

<details><summary>Odpowiedź</summary>

**C** — slajd „Koszt zapisu”: w kolekcjach z przewagą zapisów indeksy są kosztowne. (slajd 177)

</details>

### Indeksy jednopolowe, złożone i multikey

**4.103. Jaką nazwę MongoDB nada domyślnie indeksowi utworzonemu przez `db.collection.createIndex({ name: -1 })`, widoczną w `getIndexes()`?**

- A) `name_index`
- B) `idx_name`
- C) `name_desc`
- D) `name_-1`

<details><summary>Odpowiedź</summary>

**D** — wynik `getIndexes()` na slajdzie: `{ v: 2, key: { name: -1 }, name: 'name_-1' }` obok `{ key: { _id: 1 }, name: '_id_' }`. (slajd 178)

</details>

**4.104. Jak utworzyć indeks na polu `state` zagnieżdżonym w obiekcie `location`?**

- A) `db.students.createIndex({ "location.state": 1 })`
- B) `db.students.createIndex({ location: { state: 1 } })`
- C) `db.students.createIndex({ location_state: 1 })`
- D) `db.students.createIndex({ "location[state]": 1 })`

<details><summary>Odpowiedź</summary>

**A** — notacja kropkowa w cudzysłowie. B utworzyłoby indeks na całym polu `location` z wartością-obiektem, co jest niepoprawną specyfikacją klucza. (slajd 178)

</details>

**4.105. Co według wykładu określa się podczas tworzenia indeksu jednopolowego?**

- A) Pole i maksymalną liczbę dokumentów
- B) Pole i kolejność sortowania indeksowanych wartości (rosnącą lub malejącą)
- C) Tylko nazwę indeksu
- D) Pole i typ danych pola

<details><summary>Odpowiedź</summary>

**B** — slajd: pole oraz kolejność sortowania. Uwaga: slajd dodaje, że malejące jest mniej wydajne; według dokumentacji dla indeksu jednopolowego kierunek nie ma znaczenia, bo MongoDB przechodzi indeks w obu kierunkach. (slajd 178)

</details>

**4.106. Jak indeks złożony porządkuje dane?**

- A) Losowo, z podziałem na pola
- B) Każde pole w osobnym, niezależnym indeksie
- C) Najpierw według pierwszego pola indeksu, a potem według każdego kolejnego
- D) Według ostatniego pola, potem według wcześniejszych

<details><summary>Odpowiedź</summary>

**C** — slajd: dane są grupowane według pierwszego pola w indeksie, a następnie według każdego kolejnego. (slajd 179)

</details>

**4.107. W indeksie `{ userid: 1, score: -1 }` z diagramu użytkownik „ca2” ma wyniki 30, 55, 75. W jakiej kolejności występują w indeksie?**

- A) 30, 55, 75
- B) 55, 30, 75
- C) W kolejności wstawienia dokumentów
- D) 75, 55, 30

<details><summary>Odpowiedź</summary>

**D** — w obrębie tego samego `userid` pole `score` jest posortowane malejąco (`-1`). (slajd 179)

</details>

**4.108. Które zapytanie skorzysta wydajnie z indeksu złożonego `{ userid: 1, score: -1 }`?**

- A) Filtr tylko po `userid`
- B) Filtr tylko po `score`
- C) Filtr po polu `name`
- D) Żadne, indeks złożony działa tylko, gdy podasz wszystkie pola i w tej samej kolejności w filtrze

<details><summary>Odpowiedź</summary>

**A** — `userid` jest prefiksem indeksu (reguła prefiksu). Zapytanie wyłącznie po `score` nie wykorzysta go wydajnie. Kolejność pól w dokumencie filtra nie ma znaczenia. (slajd 179)

</details>

**4.109. Jak utworzyć indeks multikey na polu tablicowym `tagi`?**

- A) `db.produkty.createIndex({ tagi: 1 }, { multikey: true })`
- B) `db.produkty.createIndex({ tagi: "multikey" })`
- C) `db.produkty.createIndex({ tagi: 1 })` — MongoDB sam ustawi typ multikey, gdy pole zawiera tablicę
- D) `db.produkty.createMultikeyIndex({ tagi: 1 })`

<details><summary>Odpowiedź</summary>

**C** — slajd: „Nie musisz jawnie określać typu multikey”; indeks na polu z tablicą automatycznie staje się multikey. (slajdy 176, 180)

</details>

**4.110. Ile wpisów w indeksie `{ "addr.zip": 1 }` utworzy dokument, którego `addr` to tablica z dwoma obiektami o kodach „10036” i „94301”?**

- A) Jeden wpis dla całej tablicy
- B) Dwa wpisy, po jednym dla każdego elementu tablicy
- C) Zero, tablice nie są indeksowane
- D) Jeden wpis dla pierwszego elementu

<details><summary>Odpowiedź</summary>

**B** — indeks multikey ma osobny wpis dla każdego elementu tablicy, więc dokument znajdzie się zarówno pod „10036”, jak i „94301”. (slajd 180)

</details>

### Indeks wektorowy

**4.111. Do czego służy indeks wektorowy w MongoDB (Atlas)?**

- A) Do wyszukiwania podobieństwa semantycznego na podstawie embeddingów, a nie tylko słów kluczowych
- B) Do automatycznego usuwania starych dokumentów
- C) Do zapytań geograficznych
- D) Do wymuszania unikalności tablic

<details><summary>Odpowiedź</summary>

**A** — slajd: wyszukiwanie podobieństwa semantycznego między dokumentami na podstawie reprezentacji wektorowej. (slajd 181)

</details>

**4.112. Jakiego rodzaju algorytmy wykorzystuje indeks wektorowy według wykładu?**

- A) B-drzewa z pełnym skanem
- B) Haszowanie MD5
- C) Map-Reduce
- D) ANN (Approximate Nearest Neighbor), np. HNSW (Hierarchical Navigable Small World)

<details><summary>Odpowiedź</summary>

**D** — ANN daje wynik przybliżony, ale w ułamku sekundy. Bez indeksu potrzebny byłby pełny skan kolekcji i liczenie podobieństwa dla każdego dokumentu. (slajd 181)

</details>

**4.113. Które polecenie tworzy indeks wektorowy z wykładu?**

- A) `db.embedded_movies.createIndex({ plot_embedding_voyage_3_large: "vector" })`
- B) `db.embedded_movies.createSearchIndex("vector_index", "vectorSearch", { fields: [ { type: "vector", path: "plot_embedding_voyage_3_large", numDimensions: 2048, similarity: "cosine" } ] })`
- C) `db.embedded_movies.createVectorIndex("plot_embedding_voyage_3_large", 2048)`
- D) `db.embedded_movies.createSearchIndex({ vector: "plot_embedding_voyage_3_large" })`

<details><summary>Odpowiedź</summary>

**B** — indeksy wyszukiwania tworzy `createSearchIndex(nazwa, typ, definicja)`, wyświetla `getSearchIndexes()`, a usuwa `dropSearchIndex()`. (slajd 181)

</details>

**4.114. Jakie metryki podobieństwa (`similarity`) wymienia wykład dla indeksu wektorowego?**

- A) `jaccard`, `hamming`, `manhattan`
- B) `cosine`, `euclidean`, `dotProduct`
- C) `cosine`, `pearson`, `levenshtein`
- D) `ascending`, `descending`, `text`

<details><summary>Odpowiedź</summary>

**B** — komentarz w kodzie: `//cosine, euclidean, dotProduct`. (slajdy 181, 182)

</details>

**4.115. Co oznacza parametr `numDimensions: 2048` w definicji indeksu wektorowego?**

- A) Maksymalną liczbę dokumentów w indeksie
- B) Liczbę zwracanych wyników
- C) Rozmiar wektora (embeddingu), czyli liczbę jego wymiarów
- D) Liczbę kandydatów przeszukiwanych w zapytaniu

<details><summary>Odpowiedź</summary>

**C** — slajd: `numDimensions` – rozmiar wektora (np. 2048). Musi zgadzać się z modelem, który wygenerował embeddingi (tu Voyage AI). (slajd 182)

</details>

**4.116. Którego etapu agregacji używa się do wyszukiwania po indeksie wektorowym?**

- A) `$search`
- B) `$near`
- C) `$text`
- D) `$vectorSearch`

<details><summary>Odpowiedź</summary>

**D** — `$vectorSearch` z polami `index`, `path`, `queryVector`, `numCandidates`, `limit`; musi być pierwszym etapem potoku. (slajdy 182, 183)

</details>

**4.117. Jak w `$project` po `$vectorSearch` pobrać wynik podobieństwa dokumentu?**

- A) `score: { $meta: "vectorSearchScore" }`
- B) `score: "$vectorSearchScore"`
- C) `score: { $similarity: 1 }`
- D) `score: { $meta: "textScore" }`

<details><summary>Odpowiedź</summary>

**A** — `$meta: "vectorSearchScore"`; `textScore` dotyczy wyszukiwania tekstowego `$text`. (slajd 183)

</details>

**4.118. Czym różnią się `numCandidates: 150` i `limit: 10` w `$vectorSearch`?**

- A) `numCandidates` to liczba wymiarów wektora, `limit` to liczba indeksów
- B) To synonimy, wystarczy podać jeden
- C) `numCandidates` to liczba kandydatów rozważanych przez wyszukiwanie przybliżone, a `limit` to liczba zwracanych dokumentów
- D) `limit` musi być większy od `numCandidates`

<details><summary>Odpowiedź</summary>

**C** — kandydatów jest więcej niż wyników (`numCandidates` ≥ `limit`); więcej kandydatów to dokładniej, ale wolniej. (slajd 183)

</details>

**4.119. Czym jest pole `plot_embedding_voyage_3_large` w dokumentach `embedded_movies`?**

- A) Miniaturą plakatu filmu
- B) Zakodowanym wektorem liczb (embeddingiem) opisującym znaczenie fabuły; nie jest to obraz ani wideo
- C) Skrótem MD5 opisu fabuły
- D) Plikiem wideo z fragmentem filmu

<details><summary>Odpowiedź</summary>

**B** — slajd: zakodowany wektor liczb, dane numeryczne; w dokumencie zapisany jako `$binary` z `subType: "09"`. (slajd 183)

</details>

**4.120. Które z poniższych NIE jest zastosowaniem indeksu wektorowego wymienionym na wykładzie?**

- A) Wyszukiwanie semantyczne, np. filmów o podobnej fabule
- B) Rekomendacje podobnych produktów
- C) Wyszukiwanie kontekstu dla chatbotów i systemów QA
- D) Automatyczne usuwanie dokumentów po określonym czasie

<details><summary>Odpowiedź</summary>

**D** — automatyczne usuwanie to indeks TTL. Pozostałe trzy wymienia slajd „Do czego służy?”. (slajd 182)

</details>


## 5. MongoDB — replikacja, sharding i kolekcje Time Series

### Replikacja i zestaw replik

**5.1. Który węzeł zestawu replik przyjmuje operacje zapisu?**

- A) Każdy węzeł secondary, zapisy są rozkładane równomiernie
- B) Węzeł primary
- C) Arbiter
- D) Router mongos wchodzący w skład zestawu replik

<details><summary>Odpowiedź</summary>

**B** — Zapisy przyjmuje wyłącznie primary, secondary tylko replikują jego zmiany. Arbiter nie ma danych, a mongos to router klastra shardowanego, nie członek zestawu replik. (slajd 184, 186)

</details>

**5.2. Co oznacza automatyczne przełączanie awaryjne (failover) w zestawie replik?**

- A) Administrator ręcznie wskazuje nowy węzeł główny po awarii
- B) Balancer przenosi dane z niedziałającego sharda na inne
- C) Secondary kopiują wpisy z oplogu primary
- D) Po awarii primary jeden z secondary zostaje automatycznie wybrany na nowego primary

<details><summary>Odpowiedź</summary>

**D** — Failover to automatyczny wybór nowego primary spośród secondary, bez udziału administratora. C opisuje zwykłą replikację, B dotyczy shardingu. (slajd 184, 185)

</details>

**5.3. Z czym według slajdu wiąże się konfiguracja odczytów z węzłów secondary?**

- A) Z opóźnieniem (read lag), więc odczytane dane mogą być nieco nieaktualne
- B) Z zablokowaniem zapisów na primary na czas odczytu
- C) Z utratą danych na primary
- D) Z koniecznością dodania arbitra

<details><summary>Odpowiedź</summary>

**A** — Odczyty z secondary mogą zwiększyć wydajność, ale secondary replikują z poślizgiem, więc dane mogą być lekko nieaktualne. (slajd 184)

</details>

**5.4. Jaki jest domyślny tryb read preference w MongoDB?**

- A) `nearest`
- B) `secondaryPreferred`
- C) `primary`
- D) `secondary`

<details><summary>Odpowiedź</summary>

**C** — Domyślnie wszystkie odczyty idą do primary. Pozostałe tryby trzeba jawnie ustawić w kliencie. (slajd 184, wiedza o MongoDB)

</details>

**5.5. Zestaw replik (replica set) to grupa jakich procesów?**

- A) `mongos`
- B) `mongosh`
- C) `mongod`
- D) Wyłącznie serwerów konfiguracyjnych

<details><summary>Odpowiedź</summary>

**C** — Replica set to grupa procesów mongod przechowujących ten sam zestaw danych. Mongos to router shardingu, mongosh to powłoka kliencka. (slajd 185, 186)

</details>

**5.6. Ile węzłów pełni rolę primary spośród węzłów przechowujących dane w zestawie replik?**

- A) Dokładnie jeden
- B) Co najmniej dwa, żeby zapisy były bezpieczne
- C) Tyle, ile jest węzłów secondary
- D) Jeden na każdego arbitra

<details><summary>Odpowiedź</summary>

**A** — Spośród węzłów z danymi dokładnie jeden jest primary i przyjmuje zapisy, pozostałe są secondary. (slajd 186)

</details>

**5.7. Przez jaki mechanizm węzły secondary odtwarzają zmiany wykonane na primary?**

- A) Heartbeat
- B) Balancer
- C) Serwery konfiguracyjne
- D) Oplog, czyli dziennik operacji primary

<details><summary>Odpowiedź</summary>

**D** — Primary zapisuje zmiany w oplogu (`local.oplog.rs`), a secondary pobierają i odtwarzają te wpisy. Heartbeat służy tylko do wykrywania awarii. (slajd 186, wiedza o MongoDB)

</details>

**5.8. Które zdanie o replikacji w MongoDB jest FAŁSZYWE?**

- A) Replikacja zapewnia redundancję danych
- B) Replikacja zwiększa przepustowość zapisu, bo każdy secondary przyjmuje zapisy
- C) Replikacja pozwala działać dalej mimo awarii jednego serwera
- D) Odczyty można skonfigurować tak, by trafiały do secondary

<details><summary>Odpowiedź</summary>

**B** — Zapisy przyjmuje tylko primary, więc replikacja nie skaluje zapisów. Do tego służy sharding. (slajd 184, 186)

</details>

**5.9. Który write concern potwierdza zapis dopiero po zapisaniu go na większości węzłów głosujących?**

- A) `{ w: "majority" }`
- B) `{ w: 0 }`
- C) `{ w: 1 }`
- D) `{ j: false }`

<details><summary>Odpowiedź</summary>

**A** — `w: "majority"` czeka na potwierdzenie większości. Taki zapis nie zostanie wycofany (rollback) po failoverze. `w: 1` to potwierdzenie samego primary, `w: 0` brak potwierdzenia. (slajd 184, wiedza o MongoDB)

</details>

**5.10. Przed czym replikacja NIE chroni?**

- A) Przed awarią dysku na serwerze primary
- B) Przed awarią zasilania jednego serwera
- C) Przed przypadkowym usunięciem kolekcji przez użytkownika
- D) Przed niedostępnością jednego węzła w czasie aktualizacji

<details><summary>Odpowiedź</summary>

**C** — Usunięcie kolekcji jest zwykłą operacją, więc zreplikuje się na wszystkie węzły. Replikacja chroni przed awarią sprzętu, nie przed błędem człowieka. (slajd 184, wiedza o MongoDB)

</details>

### Arbiter, heartbeat i failover

**5.11. Które zdanie poprawnie opisuje arbitra zestawu replik?**

- A) Przechowuje pełną kopię danych i może zostać primary
- B) Uczestniczy w wyborach, nie posiada kopii danych i nie może zostać wybrany na primary
- C) Przechowuje kopię danych, ale nie głosuje
- D) Kieruje zapytania aplikacji do odpowiednich węzłów

<details><summary>Odpowiedź</summary>

**B** — Arbiter tylko głosuje (vote only), nie ma danych i nigdy nie zostaje primary. D opisuje router mongos. (slajd 187)

</details>

**5.12. W jakiej sytuacji slajd zaleca rozważenie dodania arbitra?**

- A) Gdy chcemy zwiększyć liczbę kopii danych
- B) Gdy chcemy przyspieszyć odczyty
- C) Gdy chcemy podzielić kolekcję na shardy
- D) Gdy mamy węzeł podstawowy i dodatkowy, a ograniczenia kosztowe nie pozwalają dodać kolejnego węzła z danymi

<details><summary>Odpowiedź</summary>

**D** — Arbiter jest tani, bo nie trzyma danych, a daje trzeci głos potrzebny do większości. Nie zwiększa liczby kopii ani wydajności odczytów. (slajd 187)

</details>

**5.13. Co przedstawiają dwukierunkowe strzałki „Heartbeat” na diagramach zestawu replik?**

- A) Przesyłanie danych z primary do secondary
- B) Przesyłanie zapytań klienta
- C) Migrację chunków między węzłami
- D) Wzajemne sygnały życia między członkami zestawu, służące do wykrywania awarii

<details><summary>Odpowiedź</summary>

**D** — Heartbeat to okresowe sygnały „żyję” między członkami zestawu (domyślnie co 2 s). Przesył danych oznaczają strzałki „Replication”. (slajd 187, 188)

</details>

**5.14. Na diagramie z węzłami Primary, Secondary i Arbiter (vote only) do którego węzła NIE płynie replikacja?**

- A) Do Secondary
- B) Do Arbitra
- C) Ani do Secondary, ani do Arbitra
- D) Replikacja płynie do wszystkich węzłów

<details><summary>Odpowiedź</summary>

**B** — Strzałka „Replication” biegnie tylko od Primary do Secondary. Arbiter jest połączony z pozostałymi wyłącznie przez heartbeat. (slajd 187)

</details>

**5.15. Ile według slajdu zwykle nie powinna przekraczać mediana czasu wyboru nowego primary przy domyślnych ustawieniach?**

- A) 2 sekundy
- B) 30 sekund
- C) 12 sekund
- D) 60 sekund

<details><summary>Odpowiedź</summary>

**C** — Mediana czasu wyboru nowego primary przy domyślnej konfiguracji nie powinna przekraczać 12 sekund. 2 sekundy to domyślny odstęp heartbeatu. (slajd 188)

</details>

**5.16. Zestaw replik ma tylko dwa węzły z danymi (primary i secondary) i żadnego arbitra. Co się stanie po awarii primary?**

- A) Pozostały secondary ma tylko 1 z 2 głosów, nie zbierze większości i nie zostanie primary
- B) Secondary automatycznie zostanie primary, bo jest jedynym kandydatem
- C) Secondary zamieni się w arbitra
- D) Dane z secondary zostaną usunięte

<details><summary>Odpowiedź</summary>

**A** — Do wyboru primary potrzebna jest większość głosujących. Właśnie dlatego przy dwóch węzłach z danymi dodaje się arbitra jako trzeci głos. (slajd 187, 188)

</details>

### Sharding i skalowanie

**5.17. Czym jest sharding (fragmentowanie) w MongoDB?**

- A) Tworzeniem wielu identycznych kopii danych
- B) Kompresją dokumentów w blokach
- C) Metodą dystrybucji danych na wielu komputerach
- D) Rodzajem indeksu złożonego

<details><summary>Odpowiedź</summary>

**C** — Sharding to dystrybucja danych na wiele maszyn dla bardzo dużych zbiorów danych i dużej przepustowości. A opisuje replikację. (slajd 189)

</details>

**5.18. Jakie problemy pojedynczego serwera, prowadzące do shardingu, podaje slajd?**

- A) Duża liczba zapytań wyczerpuje procesor, a zestaw roboczy większy niż RAM obciąża we/wy dysków
- B) Brak indeksów i zbyt mało kolekcji
- C) Brak możliwości tworzenia replik
- D) Zbyt mała liczba dokumentów w kolekcji

<details><summary>Odpowiedź</summary>

**A** — Slajd wymienia wyczerpanie CPU przez zapytania oraz working set większy niż RAM, który przenosi obciążenie na dysk. (slajd 189)

</details>

**5.19. Czym jest skalowanie pionowe?**

- A) Dodawaniem kolejnych serwerów do klastra
- B) Zwiększaniem mocy pojedynczego serwera (CPU, RAM, dysk), które ma praktyczne maksimum
- C) Podziałem kolekcji na shardy
- D) Dodawaniem węzłów secondary

<details><summary>Odpowiedź</summary>

**B** — Skalowanie pionowe (scale up) to mocniejsza jedna maszyna. A i C to skalowanie poziome. (slajd 190)

</details>

**5.20. Jaki kompromis skalowania poziomego wskazuje slajd?**

- A) Istnieje praktyczne maksimum rozbudowy
- B) Wymaga zawsze droższego sprzętu niż skalowanie pionowe
- C) Nie pozwala dodawać serwerów w trakcie działania
- D) Większa złożoność infrastruktury i jej utrzymania

<details><summary>Odpowiedź</summary>

**D** — Skalowanie poziome może być tańsze, ale kosztem większej złożoności infrastruktury i konserwacji. Praktyczne maksimum dotyczy skalowania pionowego. (slajd 190)

</details>

**5.21. Czym jest klucz shardujący (shard key)?**

- A) Polem lub zestawem pól, na podstawie których MongoDB dzieli dane między shardy
- B) Kluczem szyfrującym dane na shardach
- C) Zawsze polem `_id`, nie można wybrać innego
- D) Nazwą sharda w konfiguracji klastra

<details><summary>Odpowiedź</summary>

**A** — Shard key to atrybut lub zestaw atrybutów decydujący, na który shard trafi dokument. Jego wybór jest kluczowy dla wydajności i równomiernego rozkładu. (slajd 191)

</details>

**5.22. Która cecha jest pożądana dla klucza shardującego?**

- A) Mała kardynalność, np. pole z płcią
- B) Wartości monotonicznie rosnące, np. data utworzenia
- C) Wartość typu logicznego
- D) Duża kardynalność i równomierny rozkład wartości

<details><summary>Odpowiedź</summary>

**D** — Dobry klucz ma wiele różnych, równomiernie rozłożonych wartości. Mała kardynalność i klucze monotoniczne prowadzą do nierównego rozkładu i gorących punktów. (slajd 191, wiedza o MongoDB)

</details>

**5.23. Jaką rolę pełni mongos w klastrze shardowanym?**

- A) Przechowuje fragment danych
- B) Przechowuje metadane klastra
- C) Jest routerem: przyjmuje zapytania aplikacji i kieruje je do odpowiednich shardów
- D) Głosuje w wyborach primary

<details><summary>Odpowiedź</summary>

**C** — Mongos to router zapytań i interfejs między aplikacją a klastrem. Metadane trzymają serwery konfiguracyjne, dane trzymają shardy. (slajd 191, 192)

</details>

**5.24. Który mechanizm automatycznie przenosi dane między shardami, aby wyrównać ich rozkład?**

- A) Oplog
- B) Balancer
- C) Arbiter
- D) Heartbeat

<details><summary>Odpowiedź</summary>

**B** — Balancer monitoruje rozkład danych i przenosi zakresy (chunki) między shardami. Oplog, arbiter i heartbeat dotyczą replikacji. (slajd 191)

</details>

**5.25. Co zrobi mongos z zapytaniem, które nie zawiera klucza shardującego?**

- A) Zwróci błąd
- B) Roześle je do wszystkich shardów i połączy wyniki (scatter-gather)
- C) Wyśle je tylko do serwerów konfiguracyjnych
- D) Wyśle je do losowego sharda

<details><summary>Odpowiedź</summary>

**B** — Bez klucza shardującego router nie wie, gdzie są dane, więc pyta wszystkie shardy. Zapytanie z kluczem jest celowane (targeted) do jednego sharda. (slajd 191, wiedza o MongoDB)

</details>

**5.26. Które polecenie shardowuje kolekcję `zamowienia` w bazie `sklep` z kluczem haszowanym na polu `klientId`?**

- A) `db.zamowienia.shard({ klientId: "hashed" })`
- B) `rs.shardCollection("sklep.zamowienia", { klientId: "hashed" })`
- C) `sh.shardCollection("sklep.zamowienia", { klientId: "hashed" })`
- D) `sh.enableCollection("zamowienia", "klientId")`

<details><summary>Odpowiedź</summary>

**C** — Shardowanie kolekcji wykonuje `sh.shardCollection` z pełną nazwą „baza.kolekcja” i dokumentem klucza. Prefiks `rs.` dotyczy zestawów replik, a metody z A i D nie istnieją. (slajd 191, wiedza o MongoDB)

</details>

**5.27. Do czego przy shardingu zakresowym prowadzi monotonicznie rosnący klucz, np. data utworzenia dokumentu?**

- A) Wszystkie nowe dokumenty trafiają na ten sam shard, który staje się gorącym punktem (hot spot)
- B) Do idealnie równomiernego rozkładu zapisów
- C) Do braku możliwości założenia indeksu na kluczu
- D) Do automatycznej replikacji kolekcji na wszystkie shardy

<details><summary>Odpowiedź</summary>

**A** — Nowe wartości zawsze są największe, więc trafiają do ostatniego zakresu na jednym shardzie. Pomaga sharding haszowany. (slajd 191, wiedza o MongoDB)

</details>

**5.28. Które zdanie poprawnie porównuje replikację i sharding?**

- A) Sharding tworzy kopie danych, a replikacja dzieli dane na fragmenty
- B) Replikacja i sharding to dwie nazwy tego samego mechanizmu
- C) Sharding wymaga arbitra, a replikacja mongos
- D) Replikacja tworzy kopie dla dostępności, sharding dzieli dane dla skalowalności

<details><summary>Odpowiedź</summary>

**D** — W replikacji każdy węzeł ma wszystkie dane, w shardingu każdy shard ma tylko część. W produkcji łączy się oba: każdy shard jest zestawem replik. (slajd 184, 191, 192)

</details>

### Klaster shardowany i architektura

**5.29. Z jakich trzech komponentów składa się klaster shardowany MongoDB?**

- A) Primary, secondary, arbiter
- B) mongod, mongosh, Compass
- C) Shard, oplog, balancer
- D) Shardy, routery mongos, serwery konfiguracyjne

<details><summary>Odpowiedź</summary>

**D** — Sharded cluster to shardy (dane), mongos (router) i config servers (metadane). A to role w zestawie replik. (slajd 192)

</details>

**5.30. Co przechowują serwery konfiguracyjne (config servers)?**

- A) Metadane i ustawienia konfiguracyjne klastra
- B) Dokumenty kolekcji nieshardowanych
- C) Kopie zapasowe wszystkich shardów
- D) Logi zapytań aplikacji

<details><summary>Odpowiedź</summary>

**A** — Config servers trzymają metadane klastra, m.in. mapę, który zakres klucza leży na którym shardzie. (slajd 192)

</details>

**5.31. Jakie liczności podaje diagram klastra shardowanego na slajdzie?**

- A) 1 shard i 2 lub więcej routerów
- B) 1 lub więcej routerów i 2 lub więcej shardów
- C) Dokładnie 3 shardy i 3 routery
- D) Dokładnie 1 router i 1 shard

<details><summary>Odpowiedź</summary>

**B** — Diagram ma podpisy „1 or more Routers” oraz „2 or more Shards”. (slajd 192)

</details>

**5.32. Jak według diagramu wdraża się shardy i serwery konfiguracyjne?**

- A) Jako pojedyncze procesy mongod bez replik
- B) Jako arbitry
- C) Jako zestawy replik (replica set)
- D) Jako procesy mongos

<details><summary>Odpowiedź</summary>

**C** — Bloki na diagramie mają podpisy „Shard (replica set)” i „Config Servers (replica set)”. (slajd 192)

</details>

**5.33. Na slajdzie 193 Collection1 jest rozłożona na Shard A i Shard B, a Collection2 leży w całości na Shard A. Co z tego wynika?**

- A) W jednym klastrze mogą być kolekcje shardowane i nieshardowane; nieshardowana leży w całości na jednym shardzie
- B) Collection2 jest uszkodzona i balancer musi ją naprawić
- C) Collection2 jest replikowana na wszystkie shardy
- D) Wszystkie kolekcje w klastrze są zawsze shardowane

<details><summary>Odpowiedź</summary>

**A** — Podpis slajdu to „Sharded and Non-Sharded Collections”. Sharding włącza się dla konkretnej kolekcji. (slajd 193)

</details>

**5.34. Z czym łączy się aplikacja, aby odczytywać i zapisywać dane w klastrze shardowanym?**

- A) Bezpośrednio z primary wybranego sharda
- B) Z serwerem konfiguracyjnym
- C) Z routerem mongos
- D) Z arbitrem

<details><summary>Odpowiedź</summary>

**C** — Aplikacje i sterowniki wysyłają Reads/Writes do routera mongos, który kieruje je do shardów. Połączenie bezpośrednio z shardem pokazałoby tylko część danych. (slajd 193)

</details>

**5.35. Jak wygląda typowa architektura produkcyjna klastra shardowanego?**

- A) Jeden mongos i jeden shard jako pojedynczy węzeł
- B) Wiele shardów jako pojedyncze węzły, bez serwerów konfiguracyjnych
- C) Kilka shardów bez routerów, aplikacja łączy się z config serverem
- D) Kilka routerów mongos, shardy 1…N, każdy jako primary i dwa secondary, oraz config server jako primary i dwa secondary

<details><summary>Odpowiedź</summary>

**D** — Diagram produkcyjny dubluje każdy element, żeby nie było pojedynczego punktu awarii. (slajd 194)

</details>

**5.36. Czym architektura do celów programistycznych z slajdu 195 różni się od produkcyjnej?**

- A) Nie ma w niej routera mongos
- B) Ma jeden mongos i jeden shard (Shard 1) oraz serwer konfiguracyjny
- C) Ma dwa shardy, ale nie ma serwera konfiguracyjnego
- D) Jest zwykłym zestawem replik bez shardingu

<details><summary>Odpowiedź</summary>

**B** — Wersja deweloperska ma pojedynczy mongos i jeden shard; na diagramie shard i config server nadal są narysowane jako trzy węzły. (slajd 195)

</details>

### Time Series: cechy i tworzenie kolekcji

**5.37. Do czego służy kolekcja Time Series w MongoDB?**

- A) Do przechowywania dokumentów, które nie mają żadnego pola czasu
- B) Do przechowywania i analizy danych zapisywanych w odniesieniu do czasu, np. odczytów sensorów, logów, cen akcji
- C) Do przechowywania dużych plików binarnych
- D) Do przechowywania relacji grafowych

<details><summary>Odpowiedź</summary>

**B** — Time Series to specjalny typ kolekcji dla danych szeregów czasowych. Pliki binarne to GridFS. (slajd 196)

</details>

**5.38. Jak nazywają się jednostki, w które MongoDB grupuje dane szeregów czasowych według okresów czasu?**

- A) Chunks
- B) Shards
- C) Partitions
- D) Buckets („wiaderka”)

<details><summary>Odpowiedź</summary>

**D** — Dane Time Series trafiają do buckets, co daje kompresję. Chunks to zakresy klucza w shardingu. (slajd 196)

</details>

**5.39. Jaki indeks MongoDB tworzy automatycznie w kolekcji Time Series?**

- A) Indeks złożony na metaField i timeField
- B) Indeks tekstowy na wszystkich polach
- C) Indeks 2dsphere na timeField
- D) Indeks haszowany na `_id`

<details><summary>Odpowiedź</summary>

**A** — Slajd podaje automatyczny indeks złożony dla metaField i timeField (dotyczy kolekcji z metaField utworzonych w wersji 6.3 i nowszych). (slajd 196)

</details>

**5.40. Uzupełnij: `db.createCollection("sensor_data", { ____: { timeField: "timestamp", metaField: "metadata" } })`**

- A) `timeSeries`
- B) `time_series`
- C) `timeseries`
- D) `series`

<details><summary>Odpowiedź</summary>

**C** — Opcja nazywa się `timeseries`, małymi literami i razem. (slajd 197)

</details>

**5.41. Który parametr kolekcji Time Series jest obowiązkowy?**

- A) `metaField`
- B) `granularity`
- C) `timeField`
- D) `expireAfterSeconds`

<details><summary>Odpowiedź</summary>

**C** — `timeField` musi być podany, a wartość tego pola w dokumentach musi być typu Date. `metaField`, `granularity` i `expireAfterSeconds` są opcjonalne. (slajd 197, wiedza o MongoDB)

</details>

**5.42. Jakie wartości przyjmuje parametr `granularity`?**

- A) `"ms"`, `"s"`, `"min"`
- B) `"seconds"`, `"minutes"`, `"hours"`
- C) `"low"`, `"medium"`, `"high"`
- D) `"day"`, `"week"`, `"month"`

<details><summary>Odpowiedź</summary>

**B** — Granularity przyjmuje `seconds`, `minutes` albo `hours` i opisuje typowy odstęp między pomiarami z jednego źródła. (slajd 197, 204, wiedza o MongoDB)

</details>

**5.43. Jaka jest domyślna wartość `granularity`?**

- A) `"hours"`
- B) `"minutes"`
- C) `"days"`
- D) `"seconds"`

<details><summary>Odpowiedź</summary>

**D** — Domyślna ziarnistość to `seconds`. Później można ją tylko zwiększyć (np. na `minutes`), nie zmniejszyć. (slajd 197, wiedza o MongoDB)

</details>

**5.44. Gdzie w `db.createCollection("weather", {...})` umieszcza się `expireAfterSeconds`?**

- A) Obok obiektu `timeseries`, na poziomie dokumentu opcji
- B) Wewnątrz obiektu `timeseries`, obok `timeField`
- C) Wewnątrz pola `metaField`
- D) Nie da się go podać w `createCollection`, tylko przez `createIndex`

<details><summary>Odpowiedź</summary>

**A** — W przykładzie `expireAfterSeconds: 86400` stoi po zamknięciu klamry `timeseries`, w tym samym dokumencie opcji. (slajd 197, 200)

</details>

**5.45. Jaki okres oznacza `expireAfterSeconds: 86400`?**

- A) 1 godzinę
- B) 7 dni
- C) 30 dni
- D) 1 dobę

<details><summary>Odpowiedź</summary>

**D** — 24 × 3600 = 86 400 sekund, czyli doba. (slajd 197, 200)

</details>

**5.46. Co powinno się znaleźć w polu wskazanym jako `metaField`?**

- A) Zmierzone wartości, np. temperatura
- B) Znacznik czasu pomiaru
- C) Dane opisujące źródło pomiaru, rzadko się zmieniające, np. `sensorId` i typ sensora
- D) Identyfikator `_id` dokumentu

<details><summary>Odpowiedź</summary>

**C** — Komentarz na slajdzie mówi o dodatkowych metadanych, np. typie sensora. Po metaField MongoDB grupuje pomiary w buckets. (slajd 197, 200)

</details>

**5.47. Które etapy agregacji slajd wymienia jako przydatne do analizy trendów na szeregach czasowych?**

- A) `$lookup`, `$unwind`, `$out`
- B) `$group`, `$bucket`, `$sort`
- C) `$geoNear`, `$facet`, `$sample`
- D) `$text`, `$redact`, `$count`

<details><summary>Odpowiedź</summary>

**B** — Slajd wymienia `$group`, `$bucket` i `$sort`. Uwaga: etap `$bucket` to coś innego niż wewnętrzne buckets kolekcji. (slajd 197)

</details>

**5.48. Które zastosowanie NIE jest wymienione na slajdzie jako typowe dla MongoDB Time Series?**

- A) Przechowywanie grafu znajomych w sieci społecznościowej
- B) Monitorowanie środowiska (temperatura, wilgotność)
- C) Analiza danych finansowych (ceny akcji)
- D) Monitorowanie zużycia energii

<details><summary>Odpowiedź</summary>

**A** — Slajd wymienia monitorowanie środowiska, dane finansowe, logi systemowe i zużycie energii. Graf znajomych nie jest szeregiem czasowym. (slajd 197)

</details>

### Time Series: przypadki użycia i właściwości danych

**5.49. Jakie przykłady dla branży DevOps podaje tabela przypadków użycia?**

- A) Handel o wysokiej częstotliwości
- B) Zarządzanie zapasami
- C) Dane z urządzeń inteligentnego domu
- D) Rejestrowanie aplikacji oraz monitorowanie infrastruktury i sieci

<details><summary>Odpowiedź</summary>

**D** — A należy do usług finansowych, B do handlu detalicznego, C do IoT. (slajd 198)

</details>

**5.50. Które zdanie o właściwościach danych szeregów czasowych jest FAŁSZYWE?**

- A) Dokumenty przychodzą w kolejności, co wymaga częstych operacji wstawiania
- B) Istniejące dokumenty są często aktualizowane
- C) Operacje usuwania są rzadkie
- D) Dane są indeksowane według czasu i identyfikatora

<details><summary>Odpowiedź</summary>

**B** — Aktualizacje są rzadkie, bo każdy dokument to pojedynczy punkt w czasie. (slajd 199)

</details>

**5.51. Jakiego formatu przechowywania używa MongoDB dla kolekcji Time Series?**

- A) Wierszowego, jeden dokument na stronę dysku
- B) Grafowego
- C) Specjalistycznego formatu kolumnowego, grupującego dokumenty z każdej serii czasowej
- D) Klucz–wartość bez indeksów

<details><summary>Odpowiedź</summary>

**C** — Format kolumnowy trzyma wartości tego samego pola obok siebie, co dobrze się kompresuje. (slajd 199)

</details>

**5.52. Która z poniższych jest zaletą formatu kolumnowego kolekcji Time Series wymienioną na slajdzie?**

- A) Zmniejszone rozmiary pamięci masowej i indeksów
- B) Szybsze aktualizacje pojedynczych dokumentów
- C) Automatyczny sharding kolekcji
- D) Brak konieczności podawania pola czasu

<details><summary>Odpowiedź</summary>

**A** — Slajd wymienia: mniejsze rozmiary danych i indeksów, lepszą wydajność zapytań, mniejsze I/O, lepsze wykorzystanie cache i mniejszą złożoność pracy. (slajd 199)

</details>

### Tworzenie i odpytywanie kolekcji weather

**5.53. W przykładzie `db.weather.insertMany([{ metadata: { sensorId: 5578, type: "temperature" }, timestamp: ISODate("2021-05-18T00:00:00.000Z"), temp: 12 }, ...])` które pole jest metaField?**

- A) `metadata`
- B) `timestamp`
- C) `temp`
- D) `sensorId`

<details><summary>Odpowiedź</summary>

**A** — Kolekcję utworzono z `metaField: "metadata"`. `timestamp` to timeField, `temp` to zwykłe pole pomiaru, a `sensorId` jest wewnątrz metaField. (slajd 200)

</details>

**5.54. Które zdanie o odpytywaniu kolekcji Time Series jest prawdziwe?**

- A) Wymaga specjalnej metody `db.weather.tsFind()`
- B) Można ją odpytywać wyłącznie przez `aggregate`
- C) Używa się standardowych metod, np. `db.weather.findOne({ timestamp: ISODate("2021-05-18T00:00:00.000Z") })`
- D) Nie można filtrować po polu timeField

<details><summary>Odpowiedź</summary>

**C** — Slajd pokazuje zwykłe `findOne` z filtrem po timestamp. Buckets są ukryte, wynik wygląda jak zwykłe dokumenty. (slajd 200)

</details>

**5.55. Co zwraca operator `$dateToParts: { date: "$timestamp" }`?**

- A) Datę obciętą do początku dnia
- B) Dokument z częściami daty: `year`, `month`, `day`, `hour`, `minute`, `second`, `millisecond`
- C) Liczbę milisekund od epoki
- D) Napis z datą w formacie ISO

<details><summary>Odpowiedź</summary>

**B** — `$dateToParts` rozkłada datę na części. Obcięcie daty to `$dateTrunc`. (slajd 201)

</details>

**5.56. Po czym grupuje etap `{ $group: { _id: { date: { year: "$date.year", month: "$date.month", day: "$date.day" } }, avgTmp: { $avg: "$temp" } } }`?**

- A) Po godzinie pomiaru
- B) Tylko po miesiącu
- C) Tylko po roku
- D) Po dniu kalendarzowym (rok, miesiąc, dzień)

<details><summary>Odpowiedź</summary>

**D** — Klucz grupy to trójka rok, miesiąc, dzień, więc wynik to średnia dzienna temperatura, np. 2021-05-18 → 12,71 i 2021-05-19 → 13. (slajd 201)

</details>

**5.57. Jak poprawnie zapisać w `$group` pole ze średnią wartością pola `temp`?**

- A) `avgTmp: "$avg.temp"`
- B) `avgTmp: { $average: "$temp" }`
- C) `avgTmp: { $avg: "$temp" }`
- D) `avgTmp: { $avg: "temp" }`

<details><summary>Odpowiedź</summary>

**C** — Akumulator to `$avg`, a odwołanie do pola wymaga znaku dolara: `"$temp"`. Bez dolara (D) `"temp"` jest stałym napisem. `$average` nie istnieje. (slajd 201)

</details>

### Operatory dat i średnia miesięczna

**5.58. Co zwróci `{ $dateTrunc: { date: "$date", unit: "month" } }` dla daty `ISODate("2020-06-17T14:30:00Z")`?**

- A) `ISODate("2020-06-30T00:00:00Z")`
- B) Liczbę `6`
- C) `{ year: 2020, month: 6 }`
- D) `ISODate("2020-06-01T00:00:00Z")`

<details><summary>Odpowiedź</summary>

**D** — `$dateTrunc` obcina datę do początku jednostki, stąd nazwa pola `firstDayOfMonth`. C przypomina wynik `$dateToParts`. (slajd 202)

</details>

**5.59. Który operator zwraca różnicę czasu między dwiema datami?**

- A) `$dateDiff`
- B) `$dateAdd`
- C) `$dateTrunc`
- D) `$dateToParts`

<details><summary>Odpowiedź</summary>

**A** — `$dateDiff` zwraca różnicę dat w wybranej jednostce. `$dateAdd` dodaje czas, `$dateTrunc` obcina datę. (slajd 202)

</details>

**5.60. Do czego służy operator `$dateAdd`?**

- A) Do obcięcia daty do wskazanej jednostki
- B) Do dodania określonej ilości czasu do obiektu Date
- C) Do rozłożenia daty na części
- D) Do obliczeń na dokumentach w oknie

<details><summary>Odpowiedź</summary>

**B** — Taką definicję podaje slajd. D opisuje etap `$setWindowFields`. (slajd 202)

</details>

**5.61. Zapytanie na `dowJonesTickerData` ma `_id: { firstDayOfMonth: { $dateTrunc: { date: "$date", unit: "month" } }, symbol: "$symbol" }` i `avgMonthClose: { $avg: "$close" }`. Co liczy?**

- A) Średnią cenę zamknięcia wszystkich spółek łącznie dla każdego miesiąca
- B) Średnią miesięczną cenę zamknięcia osobno dla każdej pary miesiąc i spółka
- C) Średnią cenę zamknięcia każdej spółki z całego okresu
- D) Średnią dzienną cenę otwarcia

<details><summary>Odpowiedź</summary>

**B** — Klucz grupy łączy pierwszy dzień miesiąca i symbol, np. GOOG w czerwcu 2020 → ok. 1431,05. (slajd 202)

</details>

### Średnia ruchoma: $setWindowFields

**5.62. Co robi `partitionBy: { symbol: "$symbol" }` w etapie `$setWindowFields`?**

- A) Dzieli dokumenty na niezależne grupy według spółki, więc okno nie miesza notowań różnych spółek
- B) Sortuje dokumenty po symbolu
- C) Filtruje dokumenty z jednym symbolem
- D) Shardowuje kolekcję po polu symbol

<details><summary>Odpowiedź</summary>

**A** — partitionBy wyznacza partycje, a kolejność w każdej partycji ustala `sortBy: { date: 1 }`. (slajd 203)

</details>

**5.63. Czym `$setWindowFields` różni się od `$group`?**

- A) `$setWindowFields` zwija dokumenty do jednego na grupę
- B) Niczym, to synonimy
- C) `$setWindowFields` działa tylko razem z `$merge`
- D) `$setWindowFields` zachowuje każdy dokument i dopisuje mu pole wyliczone w oknie

<details><summary>Odpowiedź</summary>

**D** — Wynik na slajdzie to pełny dokument notowania z dopisanym `averageMonthClosingPrice`. `$group` zwraca jeden dokument na grupę. (slajd 203)

</details>

**5.64. Co oznacza `window: { range: [-1, "current"], unit: "month" }` przy `sortBy: { date: 1 }`?**

- A) Poprzedni dokument i bieżący dokument
- B) Cały bieżący miesiąc kalendarzowy
- C) Zakres od jednego miesiąca przed datą bieżącego dokumentu do bieżącego dokumentu
- D) Jeden miesiąc w przód od bieżącego dokumentu

<details><summary>Odpowiedź</summary>

**C** — `range` określa okno zakresem wartości pola sortowania (daty), a nie liczbą dokumentów (to robi `documents`). Slajd nazywa je „oknem 30-dniowym”; ściśle to jeden miesiąc wstecz. (slajd 203)

</details>

### Listowanie kolekcji Time Series

**5.65. Które polecenie wylistuje kolekcje Time Series w bieżącej bazie?**

- A) `db.getCollectionNames({ type: "timeseries" })`
- B) `db.runCommand({ listCollections: 1, filter: { type: "timeseries" } })`
- C) `show timeseries`
- D) `db.listTimeSeries()`

<details><summary>Odpowiedź</summary>

**B** — Slajd pokazuje polecenie `listCollections` z filtrem po `type`. `getCollectionNames` nie przyjmuje filtra, a C i D nie istnieją. (slajd 204)

</details>

**5.66. Jaką wartość ma pole `type` dla kolekcji szeregów czasowych w wyniku `listCollections`?**

- A) `"timeSeries"`
- B) `"time_series"`
- C) `"collection"`
- D) `"timeseries"`

<details><summary>Odpowiedź</summary>

**D** — W wyniku jest `type: 'timeseries'`. Zwykła kolekcja ma `"collection"`, widok `"view"`. (slajd 204)

</details>

**5.67. W wyniku `listCollections` kolekcja `weather` ma `granularity: 'hours'` i `bucketMaxSpanSeconds: 2592000`. Ile to czasu?**

- A) 30 dni
- B) 1 doba
- C) 1 godzina
- D) 7 dni

<details><summary>Odpowiedź</summary>

**A** — 2 592 000 s = 30 × 86 400 s. Przy granularity hours bucket obejmuje najwyżej 30 dni. (slajd 204)

</details>

**5.68. Który pomocnik powłoki zwraca opisy kolekcji Time Series?**

- A) `db.getCollection("timeseries")`
- B) `db.collections.find({ type: "timeseries" })`
- C) `db.getCollectionInfos({ type: "timeseries" })`
- D) `db.stats({ type: "timeseries" })`

<details><summary>Odpowiedź</summary>

**C** — `db.getCollectionInfos` z filtrem `type` to druga forma ze slajdu. A zwraca obiekt kolekcji o nazwie „timeseries”. (slajd 204)

</details>

### Widoki zmaterializowane

**5.69. Który etap na końcu potoku tworzy widok zmaterializowany `dailytemperatureaverages` na slajdzie 205?**

- A) `$project`
- B) `$lookup`
- C) `$merge`
- D) `$set`

<details><summary>Odpowiedź</summary>

**C** — `$merge: { into: "dailytemperatureaverages", whenMatched: "replace" }` zapisuje wynik agregacji do kolekcji. (slajd 205)

</details>

**5.70. Co oznacza `whenMatched: "replace"` w etapie `$merge`?**

- A) Dokument w kolekcji docelowej pasujący do wyniku (domyślnie po `_id`) zostaje zastąpiony nowym
- B) Istniejący dokument zostaje bez zmian
- C) Agregacja kończy się błędem
- D) Pola nowego i starego dokumentu zostają połączone

<details><summary>Odpowiedź</summary>

**A** — B to `keepExisting`, C to `fail`, D to `merge` (wartość domyślna). (slajd 205, wiedza o MongoDB)

</details>

**5.71. Gdzie w potoku agregacji musi stać etap `$merge`?**

- A) Na początku
- B) Bezpośrednio przed `$group`
- C) W dowolnym miejscu
- D) Na końcu, jako ostatni etap

<details><summary>Odpowiedź</summary>

**D** — `$merge` (podobnie jak `$out`) musi być ostatnim etapem potoku. (slajd 205, wiedza o MongoDB)

</details>

**5.72. Czym `$merge` różni się od `$out`?**

- A) `$merge` zawsze zastępuje całą kolekcję docelową
- B) `$out` zastępuje całą kolekcję docelową, a `$merge` scala wyniki z istniejącą kolekcją, co pozwala odświeżać ją przyrostowo
- C) `$out` może zapisywać tylko do innej bazy
- D) Nie ma różnicy

<details><summary>Odpowiedź</summary>

**B** — Dzięki scalaniu `$merge` nadaje się do widoków zmaterializowanych odświeżanych o nowe dni bez kasowania historii. (slajd 205, wiedza o MongoDB)

</details>

**5.73. Które zdanie o widoku zmaterializowanym w MongoDB jest prawdziwe?**

- A) To wynik agregacji zapisany w kolekcji, odświeżany na żądanie przez ponowne uruchomienie potoku
- B) Odświeża się automatycznie po każdym wstawieniu do kolekcji źródłowej
- C) Istnieje wyłącznie w pamięci RAM
- D) Tworzy się go tylko poleceniem `db.createView`

<details><summary>Odpowiedź</summary>

**A** — Widok zmaterializowany w MongoDB jest on-demand. `db.createView` tworzy zwykły widok, liczony przy każdym odczycie. (slajd 205, wiedza o MongoDB)

</details>

### Automatyczne usuwanie: expireAfterSeconds

**5.74. Które polecenie włącza automatyczne usuwanie danych starszych niż 604801 s w istniejącej kolekcji Time Series `weather24h`?**

- A) `db.weather24h.expire(604801)`
- B) `db.runCommand({ ttl: "weather24h", seconds: 604801 })`
- C) `db.runCommand({ collMod: "weather24h", expireAfterSeconds: 604801 })`
- D) `db.weather24h.updateMany({}, { $set: { expireAfterSeconds: 604801 } })`

<details><summary>Odpowiedź</summary>

**C** — Opcję zmienia polecenie `collMod`. Slajd pokazuje też formę skróconą `db.weather24h.collMod({ expireAfterSeconds: 604801 })`; dokumentacja MongoDB podaje formę z `runCommand`. D tylko dopisałoby pole do dokumentów. (slajd 206)

</details>

**5.75. Jak wyłączyć automatyczne usuwanie w kolekcji `weather24h`?**

- A) `db.runCommand({ collMod: "weather24h", expireAfterSeconds: 0 })`
- B) `db.runCommand({ collMod: "weather24h", expireAfterSeconds: "off" })`
- C) `db.runCommand({ collMod: "weather24h", expireAfterSeconds: false })`
- D) `db.runCommand({ collMod: "weather24h", expireAfterSeconds: null })`

<details><summary>Odpowiedź</summary>

**B** — Wyłączenie to napis `"off"`, nie zero, `false` ani `null`. (slajd 206)

</details>

**5.76. Jaki okres oznacza `expireAfterSeconds: 604801`?**

- A) 1 dobę
- B) 30 dni
- C) 1 godzinę
- D) 7 dni i 1 sekundę

<details><summary>Odpowiedź</summary>

**D** — 7 × 86 400 = 604 800 s, czyli tydzień; 604 801 to tydzień i sekunda. (slajd 206)

</details>

**5.77. Co faktycznie usuwa mechanizm `expireAfterSeconds` w kolekcji Time Series, mimo tytułu slajdu „automatyczne usuwanie kolekcji”?**

- A) Całą kolekcję po upływie czasu
- B) Indeksy kolekcji
- C) Tylko pole metaField z dokumentów
- D) Dokumenty, których wartość timeField jest starsza niż podana liczba sekund

<details><summary>Odpowiedź</summary>

**D** — Usuwane są stare dokumenty, a kolekcja zostaje. Fizycznie znika cały bucket, gdy wszystkie jego dokumenty wygasną. Tytuł slajdu jest nieprecyzyjny. (slajd 206, wiedza o MongoDB)

</details>

### Przykład IoT: zużycie energii

**5.78. Który operator w przykładzie IoT liczy energię zużytą przez klimatyzator, czyli pole pod wykresem mocy w czasie?**

- A) `$sum`
- B) `$integral`
- C) `$derivative`
- D) `$avg`

<details><summary>Odpowiedź</summary>

**B** — `consumedKilowattHours: { $integral: { input: "$powerKilowatts", unit: "hour" }, window: {...} }`. `$derivative` liczy tempo zmian, a nie pole pod wykresem. (slajd 207)

</details>

**5.79. Jaką metodą operator `$integral` przybliża pole pod wykresem, co ilustruje wykres na slajdzie?**

- A) Metodą Simpsona
- B) Metodą prostokątów
- C) Metodą trapezów
- D) Metodą Monte Carlo

<details><summary>Odpowiedź</summary>

**C** — Wykres pokazuje, że zużyta energia to pole dwóch trapezów pod krzywą mocy. (slajd 207)

</details>

**5.80. Jaką rolę pełni `unit: "hour"` wewnątrz `$integral` w przykładzie IoT?**

- A) Ustala jednostkę czasu w obliczeniu całki, dzięki czemu kilowaty razy godziny dają kilowatogodziny
- B) Ustala szerokość okna na jedną godzinę
- C) Ustawia granularity kolekcji na hours
- D) Zaokrągla wynik do pełnych godzin

<details><summary>Odpowiedź</summary>

**A** — Szerokość okna ustala osobny `unit: "hour"` w `window: { range: [-1, "current"], unit: "hour" }`. Dane są dzielone po `$deviceID` i sortowane po `timestamp`. (slajd 207)

</details>


## 6. Bazy klucz–wartość i Redis

### Model klucz–wartość

**6.1. Która analogia najlepiej opisuje model danych bazy klucz–wartość?**

- A) Tabela relacyjna z kluczem obcym
- B) Tablica asocjacyjna (słownik)
- C) Graf skierowany z etykietami
- D) Drzewo dokumentów XML

<details><summary>Odpowiedź</summary>

**B** — Slajd opisuje bazę klucz–wartość jako najprostszy model NoSQL, analogiczny do tablicy asocjacyjnej, czyli słownika. (slajd 209)

</details>

**6.2. Które zdanie o bazach klucz–wartość jest FAŁSZYWE?**

- A) Klucz jest unikalnym identyfikatorem, np. ciągiem znaków lub liczbą
- B) Wartość może być dowolnymi danymi: tekstem, obiektem, listą, liczbą
- C) Zazwyczaj oferują zaawansowane wyszukiwanie po fragmentach wartości
- D) Łatwo się skalują poziomo

<details><summary>Odpowiedź</summary>

**C** — Brak zaawansowanych zapytań, zwłaszcza wyszukiwania po wartościach, to ograniczenie tego modelu. Pozostałe zdania są prawdziwe według slajdu. (slajd 209)

</details>

**6.3. Jakie są podstawowe operacje w bazie klucz–wartość?**

- A) JOIN, GROUP BY i ORDER BY na wartościach
- B) Przechodzenie po krawędziach grafu i wyszukiwanie ścieżek
- C) Tylko odczyt, bo zapis wykonuje się wsadowo przez MapReduce
- D) Dodanie, zmiana, usunięcie i pobranie wartości dla podanego klucza

<details><summary>Odpowiedź</summary>

**D** — Operacje to dodaj / zmień / usuń wartość dla klucza oraz pobierz wartość dla klucza. (slajd 209)

</details>

**6.4. Do którego zastosowania baza klucz–wartość nadaje się NAJGORZEJ?**

- A) Filtrowanie rekordów po wielu polach wartości jednocześnie
- B) Przechowywanie danych sesyjnych
- C) Koszyk zakupowy użytkownika
- D) Liczniki polubień i wyświetleń

<details><summary>Odpowiedź</summary>

**A** — Przeszukiwanie wielu rekordów według różnych kryteriów jest na liście „kiedy nie używać”. Sesje, koszyki i liczniki są typowymi zastosowaniami. (slajd 210)

</details>

**6.5. Który produkt NIE jest bazą klucz–wartość wymienioną na slajdzie z przedstawicielami?**

- A) Valkey
- B) Aerospike
- C) Neo4j
- D) Dragonfly

<details><summary>Odpowiedź</summary>

**C** — Neo4j to baza grafowa. Slajd wymienia Redis, Valkey, Amazon DynamoDB, Aerospike, Riak KV, Hazelcast, Oracle NoSQL Database i Dragonfly. (slajd 210)

</details>

**6.6. Która baza zajmuje pierwsze miejsce w rankingu DB-Engines baz klucz–wartość (październik 2025), a która jest tuż za nią?**

- A) Memcached, potem Redis
- B) Redis, potem Amazon DynamoDB
- C) Amazon DynamoDB, potem Redis
- D) Redis, potem Microsoft Azure Cosmos DB

<details><summary>Odpowiedź</summary>

**B** — Na wykresie Redis jest na szczycie, tuż pod nim Amazon DynamoDB; Cosmos DB i Memcached są niżej. (slajd 211)

</details>

### Redis – ogólna charakterystyka

**6.7. Co oznacza nazwa Redis?**

- A) REliable DIstributed Storage
- B) REal-time DIctionary System
- C) REdundant DIsk Server
- D) REmote DIctionary Server

<details><summary>Odpowiedź</summary>

**D** — Redis to REmote DIctionary Server. Na rysunku ze slajdu 216 pojawia się wersja „Service”, ale oficjalnie jest „Server”. (slajd 212)

</details>

**6.8. Jakie dwa mechanizmy trwałości (zapisu na dysk) ma Redis?**

- A) WAL i checkpoint
- B) Journal i oplog
- C) RDB i AOF
- D) SSTable i memtable

<details><summary>Odpowiedź</summary>

**C** — Redis może opcjonalnie zapisywać dane na dysk przez RDB (migawki) i AOF (Append Only File, dziennik operacji). (slajd 212)

</details>

**6.9. Co zwróci ostatnie polecenie?**

```
LPUSH kolejka "zadanie1" "zadanie2"
LRANGE kolejka 0 -1
```

- A) `1) "zadanie2" 2) "zadanie1"`
- B) `1) "zadanie1" 2) "zadanie2"`
- C) `(integer) 2`
- D) Błąd, bo LRANGE wymaga dodatnich indeksów

<details><summary>Odpowiedź</summary>

**A** — LPUSH wstawia elementy kolejno na początek, więc ostatni podany (zadanie2) jest pierwszy. `0 -1` oznacza całą listę. (slajd 212)

</details>

**6.10. Która struktura danych Redis jest na slajdzie wskazana do zliczania unikalnych gości?**

- A) Bitmap
- B) HyperLogLog
- C) Sorted Set
- D) Stream

<details><summary>Odpowiedź</summary>

**B** — HyperLogLog (np. unikalni goście). Bitmap to flagi, Sorted Set rankingi, Stream strumienie zdarzeń. (slajd 212)

</details>

**6.11. Która struktura Redis jest na slajdzie przypisana do rankingów?**

- A) Hash
- B) List
- C) Set
- D) Sorted Set

<details><summary>Odpowiedź</summary>

**D** — Sorted Set (np. rankingi), bo każdy element ma liczbę (score), według której zbiór jest uporządkowany. (slajd 212)

</details>

**6.12. Które polecenie zapisuje obiekt z polami imie, nazwisko i wiek jako strukturę typu hash?**

- A) `SET osoba:1 imie "Anna" nazwisko "Nowak" wiek 28`
- B) `SADD osoba:1 imie "Anna" nazwisko "Nowak" wiek 28`
- C) `HSET osoba:1 imie "Anna" nazwisko "Nowak" wiek 28`
- D) `LPUSH osoba:1 imie "Anna" nazwisko "Nowak" wiek 28`

<details><summary>Odpowiedź</summary>

**C** — HSET ustawia pola hasha, a HGETALL osoba:1 zwraca wszystkie pola i wartości. (slajd 212)

</details>

**6.13. Które zdanie NIE jest ograniczeniem Redisa wymienionym na slajdzie?**

- A) Brak możliwości replikacji danych
- B) Większe koszty przy dużych zbiorach, bo dane są głównie w RAM
- C) Brak języka zapytań jak SQL
- D) Ryzyko utraty danych przy niewłaściwej konfiguracji

<details><summary>Odpowiedź</summary>

**A** — Redis obsługuje replikację i klastrowanie; to jego cecha, nie ograniczenie. Pozostałe punkty są na liście ograniczeń. (slajd 212)

</details>

**6.14. Według porównania na slajdzie, gdzie przechowują dane Redis, MongoDB i baza relacyjna?**

- A) Wszystkie trzy głównie w RAM
- B) Redis i MongoDB w RAM, relacyjna na dysku
- C) Redis na dysku, MongoDB w RAM, relacyjna na dysku
- D) Redis głównie w RAM, MongoDB i relacyjna na dysku

<details><summary>Odpowiedź</summary>

**D** — Redis: głównie RAM; MongoDB: dysk; baza relacyjna: dysk. (slajd 212)

</details>

**6.15. Które moduły podano na slajdzie jako przykłady rozszerzalności Redisa?**

- A) RediSearch, RedisJSON, RedisTimeSeries
- B) PostGIS, pgvector, TimescaleDB
- C) GridFS, Atlas Search, Change Streams
- D) Lucene, Kibana, Logstash

<details><summary>Odpowiedź</summary>

**A** — Rozszerzalność przez moduły: RediSearch, RedisJSON, RedisTimeSeries. Pozostałe dotyczą PostgreSQL, MongoDB i stosu Elastic. (slajd 212)

</details>

### Zarządzanie kluczami, zapytania i inne funkcje

**6.16. Jaki problem slajd przypisuje auto-inkrementowanym kluczom?**

- A) Nie da się ich użyć w Redisie
- B) Problemy z podziałem na klastry serwerów i ze znaczeniem
- C) Zajmują więcej niż 512 MB
- D) Nie mogą mieć prefiksów

<details><summary>Odpowiedź</summary>

**B** — Auto-inkrementacja ma problemy z podziałem na klastry serwerów (wspólny licznik) i ze znaczeniem (liczba nic nie mówi). (slajd 213)

</details>

**6.17. Jakie klucze slajd określa jako „często wykorzystywane w praktyce”?**

- A) Losowe UUID bez prefiksów
- B) Wyłącznie numery PESEL
- C) Klucze złożone, łączące byty rzeczywiste z datami, identyfikatorami, logami
- D) Klucze binarne generowane przez DUMP

<details><summary>Odpowiedź</summary>

**C** — Złożone klucze, czyli połączenia bytów rzeczywistych z datami, identyfikatorami i logami, są często wykorzystywane w praktyce; prefiksy również. (slajd 213)

</details>

**6.18. Dlaczego w bazach klucz–wartość istotna jest znajomość konwencji nazewniczej kluczy?**

- A) Bo operacje CRUD działają najczęściej dla określonych kluczy, a lista wszystkich kluczy bywa trudna do uzyskania
- B) Bo klucze muszą mieć postać adresu e-mail
- C) Bo baza sama nadaje nazwy kluczy według schematu
- D) Bo bez konwencji nie działa replikacja

<details><summary>Odpowiedź</summary>

**A** — CRUD działa dla określonych kluczy, a w niektórych systemach bardzo trudno uzyskać informację o wszystkich kluczach. (slajd 214)

</details>

**6.19. Jaki mechanizm slajd „Zapytania” podaje dla przetwarzania wsadowego lub sekwencyjnego?**

- A) Two-phase commit
- B) Gossip protocol
- C) Pub/Sub
- D) MapReduce

<details><summary>Odpowiedź</summary>

**D** — Przetwarzanie wsadowe lub sekwencyjne: MapReduce. (slajd 214)

</details>

**6.20. Do czego według slajdu przydaje się wygaśnięcie par klucz–wartość?**

- A) Do łączenia par odsyłaczami
- B) Do sesji użytkownika i koszyków zakupów
- C) Do sortowania rankingów
- D) Do szyfrowania wartości

<details><summary>Odpowiedź</summary>

**B** — Obiekty są automatycznie usuwane po pewnym interwale czasu, co przydaje się dla sesji i koszyków. (slajd 215)

</details>

**6.21. Jak slajd nazywa mechanizm wzajemnego łączenia wartości, które można odwiedzać podczas zapytań?**

- A) Odsyłacze (links)
- B) Klucze obce
- C) Krawędzie ważone
- D) Referencje DBRef

<details><summary>Odpowiedź</summary>

**A** — Wartości mogą być połączone przez odsyłacze (ang. links), które mogą być odwiedzane podczas zapytań. (slajd 215)

</details>

### Redis: historia, architektura, funkcje

**6.22. W którym roku powstał Redis według slajdu?**

- A) 2004
- B) 2007
- C) 2009
- D) 2012

<details><summary>Odpowiedź</summary>

**C** — Na rysunku jest rok 2009. Twórcą jest Włoch Salvatore Sanfilippo (stąd kontur Włoch). (slajd 216)

</details>

**6.23. Jak slajd definiuje Redis?**

- A) Relacyjna baza z silnikiem kolumnowym
- B) Open-source'owa, in-memory baza NoSQL działająca jako magazyn struktur danych
- C) Rozproszony system plików dla dużych danych
- D) Dokumentowa baza przechowująca BSON na dysku

<details><summary>Odpowiedź</summary>

**B** — Redis to open-source'owa, in-memory baza NoSQL, która działa jako magazyn struktur danych. (slajd 216)

</details>

**6.24. Jaką rolę pełni Redis Read Replica w architekturze ze slajdu?**

- A) Przyjmuje wszystkie zapisy aplikacji
- B) Jest trwałym magazynem zamiast MySQL
- C) Jest kopią tylko do odczytu, która zmniejsza obciążenie głównego serwera
- D) Przechowuje logi transakcji MySQL

<details><summary>Odpowiedź</summary>

**C** — Replika jest tylko do odczytu i odciąża Redis Master przy dużej liczbie zapytań. Zapisy obsługuje Master. (slajd 217)

</details>

**6.25. Jaką rolę pełni Redis wobec MySQL w architekturze ze slajdu?**

- A) Warstwa cache przed MySQL, przyspieszająca dostęp do danych
- B) Główny trwały magazyn, a MySQL jest cache
- C) Replika tylko do odczytu bazy MySQL
- D) Kolejka komunikatów między aplikacją a MySQL

<details><summary>Odpowiedź</summary>

**A** — MySQL to persistent storage, a Redis działa jako warstwa cache przed MySQL. (slajd 217)

</details>

**6.26. Które polecenia slajd wymienia przy obsłudze transakcji w Redisie?**

- A) BEGIN, COMMIT, ROLLBACK
- B) START, SAVE, UNDO
- C) LOCK, UNLOCK, FLUSH
- D) MULTI, EXEC, WATCH

<details><summary>Odpowiedź</summary>

**D** — transactions – obsługa transakcji (MULTI, EXEC, WATCH). BEGIN/COMMIT/ROLLBACK to SQL. (slajd 218)

</details>

**6.27. Czym jest redis-py?**

- A) Plikiem konfiguracyjnym serwera
- B) Biblioteką Pythona do obsługi Redisa
- C) Modułem wyszukiwania pełnotekstowego
- D) Wersją Redisa w chmurze AWS

<details><summary>Odpowiedź</summary>

**B** — redis-py module to biblioteka Python do obsługi Redis. Konfiguracja to redis.conf, wyszukiwanie to RediSearch, chmura AWS to ElastiCache. (slajd 218)

</details>

**6.28. Który plik slajd podaje jako miejsce ustawień serwera Redis?**

- A) redis.conf
- B) redis.ini
- C) my.cnf
- D) mongod.conf

<details><summary>Odpowiedź</summary>

**A** — configuration – ustawienia serwera Redis (np. redis.conf). (slajd 218)

</details>

**6.29. Co oznacza zastosowanie „Target Database” na slajdzie o zastosowaniach Redisa?**

- A) Redis jako docelowa baza replikacji MySQL
- B) Redis jako baza do testów jednostkowych
- C) Redis jako główna baza danych dla aplikacji wymagających niskich opóźnień
- D) Redis jako hurtownia danych OLAP

<details><summary>Odpowiedź</summary>

**C** — Target Database – może działać jako główna baza danych dla aplikacji wymagających niskich opóźnień. (slajd 219)

</details>

**6.30. Jaką wydajność Redisa podaje slajd „Funkcje Redis”?**

- A) Do 81 000 SET/s i 110 000 GET/s
- B) Do 1 000 000 SET/s i 1 000 000 GET/s
- C) Do 11 000 SET/s i 8 100 GET/s
- D) Do 110 000 SET/s i 81 000 GET/s

<details><summary>Odpowiedź</summary>

**D** — Ładuje do 110 000 SET na sekundę i 81 000 GET na sekundę. Wariant A zamienia liczby. (slajd 220)

</details>

**6.31. Jak według slajdu Redis zapisuje zmiany na dysku?**

- A) Synchronicznie przy każdym poleceniu, zanim odpowie klientowi
- B) Asynchronicznie, według ustalonych zasad
- C) Wcale, Redis nie ma trwałości
- D) Tylko przy zamykaniu serwera

<details><summary>Odpowiedź</summary>

**B** — Trwałość: zapis zmian na dysku asynchronicznie według ustalonych zasad. (slajd 220)

</details>

**6.32. Na jakich systemach według slajdu działa Redis (przenośność)?**

- A) Tylko na Windows Server
- B) Na większości systemów POSIX: Linux, BSD, macOS, Solaris
- C) Tylko na Linuksie z jądrem 5+
- D) Tylko w kontenerach Docker

<details><summary>Odpowiedź</summary>

**B** — Przenośność: działa na większości systemów POSIX (Linux, BSD, macOS, Solaris). (slajd 220)

</details>

**6.33. Jaki model replikacji wymienia slajd „Funkcje Redis”?**

- A) Multi-master z rozwiązywaniem konfliktów
- B) Replikacja łańcuchowa Raft
- C) Master/Slave
- D) Peer-to-peer bez lidera, jak w Cassandrze

<details><summary>Odpowiedź</summary>

**C** — Replikacja Master/Slave – prosta i szybka. Dziś Redis nazywa kopie „replica”. (slajd 220)

</details>

**6.34. Jakie dwa główne procesy występują w architekturze Redisa?**

- A) Klient Redis i serwer Redis
- B) Master i arbiter
- C) Mongos i mongod
- D) Producent i konsument

<details><summary>Odpowiedź</summary>

**A** — Dwa główne procesy to klient Redis i serwer Redis; mogą być na jednej lub na dwóch maszynach, a dane w pamięci przechowuje serwer. (slajd 221)

</details>

### Docker, VS Code i Redis Stack Browser

**6.35. Które polecenie uruchamia kontener Redis Stack w tle z portami jak na slajdzie?**

- A) `docker start -it redis-stack -p 6379:6379 -p 8001:8001`
- B) `docker exec -d --name redis-stack -p 6379:6379 redis/redis-stack:latest`
- C) `docker run -d --name redis-stack -p 6379:6379 -p 8001:8001 redis/redis-stack:latest`
- D) `docker pull -d redis-stack 6379 8001`

<details><summary>Odpowiedź</summary>

**C** — docker run tworzy i uruchamia kontener, -d to tryb detached, --name nadaje nazwę, -p mapuje porty host:kontener. (slajd 222)

</details>

**6.36. Do czego służy port 8001 w kontenerze redis/redis-stack?**

- A) Do replikacji między masterem a repliką
- B) Do interfejsu przeglądarkowego Redis Stack (localhost:8001)
- C) Do połączeń redis-cli
- D) Do eksportu metryk Prometheus

<details><summary>Odpowiedź</summary>

**B** — Pod localhost:8001 działa przeglądarkowy interfejs Redis Stack (Redis Insight). Port 6379 to sam serwer Redis, z którym łączy się redis-cli. (slajd 222, 225)

</details>

**6.37. Co oznacza opcja `-d` w poleceniu `docker run` ze slajdu?**

- A) Usunięcie kontenera po zatrzymaniu
- B) Tryb debugowania
- C) Wskazanie katalogu danych
- D) Tryb detached, czyli uruchomienie w tle

<details><summary>Odpowiedź</summary>

**D** — Slajd: polecenie uruchamia kontener w tle (detached mode). (slajd 222)

</details>

**6.38. Które polecenie otwiera interaktywną konsolę redis-cli w działającym kontenerze „redis-stack”?**

- A) `docker exec -it redis-stack redis-cli`
- B) `docker run -it redis-cli redis-stack`
- C) `docker attach redis-cli`
- D) `docker exec redis-cli -it redis-stack`

<details><summary>Odpowiedź</summary>

**A** — docker exec wykonuje polecenie w działającym kontenerze, -it daje sesję interaktywną z terminalem, potem nazwa kontenera i program. (slajd 222)

</details>

**6.39. Jaki znak zachęty pokazuje redis-cli połączone z lokalnym serwerem na domyślnym porcie?**

- A) `redis:8001>`
- B) `127.0.0.1:6379>`
- C) `localhost:27017>`
- D) `test>`

<details><summary>Odpowiedź</summary>

**B** — Domyślny port Redisa to 6379. 27017 to domyślny port MongoDB, a `test>` to znak zachęty mongosh. (slajd 222)

</details>

**6.40. Co oznacza typ „ReJSON-RL” widoczny przy kluczach bikes:0 … bikes:6 w VS Code?**

- A) Klucz przechowuje listę stringów
- B) Klucz ma ustawiony czas wygaśnięcia
- C) Klucz jest tylko do odczytu
- D) Klucz przechowuje dokument JSON (moduł RedisJSON)

<details><summary>Odpowiedź</summary>

**D** — ReJSON-RL to wewnętrzna nazwa typu danych modułu RedisJSON; tak TYPE raportuje klucze z dokumentem JSON. (slajd 223)

</details>

**6.41. Co oznacza „TTL: No limit” przy kluczu w Redis for VS Code albo w Redis Stack Browser?**

- A) Klucz nie ma ustawionego czasu wygaśnięcia
- B) Wartość może mieć dowolny rozmiar
- C) Klucz wygasł
- D) Klucz można odczytywać bez uwierzytelnienia

<details><summary>Odpowiedź</summary>

**A** — TTL (Time To Live) No limit znaczy, że klucz nie wygasa. (slajd 224, 225)

</details>

### Polecenia do zarządzania kluczami

**6.42. Które polecenie ustawia wygaśnięcie klucza po podanej liczbie MILISEKUND?**

- A) `EXPIRE`
- B) `EXPIREAT`
- C) `PEXPIRE`
- D) `PEXPIREAT`

<details><summary>Odpowiedź</summary>

**C** — PEXPIRE ustawia wygaśnięcie w milisekundach. EXPIRE działa w sekundach, a wersje z AT przyjmują znacznik czasu UNIX (moment, nie odstęp). (slajd 226)

</details>

**6.43. Które polecenie ustawia wygaśnięcie klucza w konkretnym momencie podanym jako znacznik czasu UNIX w sekundach?**

- A) `EXPIREAT`
- B) `EXPIRE`
- C) `PEXPIRE`
- D) `PERSIST`

<details><summary>Odpowiedź</summary>

**A** — EXPIREAT przyjmuje znacznik czasu UNIX w sekundach; PEXPIREAT to samo w milisekundach. (slajd 226)

</details>

**6.44. Które polecenie usuwa datę ważności z klucza, tak że przestaje on wygasać?**

- A) `DEL`
- B) `PERSIST`
- C) `TTL`
- D) `RENAMENX`

<details><summary>Odpowiedź</summary>

**B** — PERSIST usuwa wygaśnięcie z klucza. DEL usuwa cały klucz, TTL tylko odczytuje pozostały czas. (slajd 226)

</details>

**6.45. Co zwróci `TTL mykey`, jeśli klucz mykey istnieje, ale nie ma ustawionego wygaśnięcia?**

- A) `(integer) 0`
- B) `(nil)`
- C) `(integer) -2`
- D) `(integer) -1`

<details><summary>Odpowiedź</summary>

**D** — TTL zwraca -1 dla klucza bez wygaśnięcia i -2 dla klucza, który nie istnieje. (slajd 226, wiedza o Redisie)

</details>

**6.46. Czym różni się `PTTL` od `TTL`?**

- A) PTTL zwraca pozostały czas w milisekundach, TTL w sekundach
- B) PTTL ustawia czas życia, TTL go odczytuje
- C) PTTL działa tylko dla list
- D) PTTL usuwa klucz po odczycie

<details><summary>Odpowiedź</summary>

**A** — Oba odczytują pozostały czas ważności; PTTL w milisekundach, TTL w sekundach. (slajd 226)

</details>

**6.47. Które polecenie zmienia nazwę klucza TYLKO wtedy, gdy klucz o nowej nazwie nie istnieje?**

- A) `RENAME`
- B) `MOVE`
- C) `RENAMENX`
- D) `SETNX`

<details><summary>Odpowiedź</summary>

**C** — RENAMENX (NX = Not eXists). RENAME nadpisałby istniejący klucz, MOVE przenosi do innej bazy, SETNX ustawia wartość, a nie nazwę. (slajd 226)

</details>

**6.48. Które polecenie służy do znalezienia wszystkich kluczy pasujących do wzorca, np. `bikes:*`?**

- A) `SCAN`
- B) `KEYS`
- C) `RANDOMKEY`
- D) `TYPE`

<details><summary>Odpowiedź</summary>

**B** — Slajd: KEYS pattern znajduje wszystkie klucze pasujące do wzorca. SCAN też potrafi filtrować wzorcem, ale iteracyjnie i nie ma go w tabeli; RANDOMKEY zwraca losowy klucz. (slajd 226)

</details>

**6.49. Do czego służy polecenie `MOVE key db`?**

- A) Do zmiany nazwy klucza
- B) Do przeniesienia elementu z jednej listy do drugiej
- C) Do przeniesienia członka zbioru do innego zbioru
- D) Do przeniesienia klucza do innej bazy danych

<details><summary>Odpowiedź</summary>

**D** — MOVE przenosi klucz do innej bazy (logicznej). Elementy list przenosi LMOVE, członków zbiorów SMOVE. (slajd 226)

</details>

**6.50. Które polecenie zwraca serializowaną wersję wartości zapisanej pod kluczem?**

- A) `DUMP`
- B) `GET`
- C) `TYPE`
- D) `EXISTS`

<details><summary>Odpowiedź</summary>

**A** — DUMP zwraca serializowaną wersję wartości (do odtworzenia przez RESTORE). (slajd 226)

</details>

**6.51. Które polecenie zwraca typ danych wartości przechowywanej pod kluczem (np. string, list, hash)?**

- A) `EXISTS`
- B) `TYPE`
- C) `DUMP`
- D) `KEYS`

<details><summary>Odpowiedź</summary>

**B** — TYPE key pobiera typ danych wartości przechowywanej w kluczu. (slajd 226)

</details>

### Typy danych i limity

**6.52. Jaki jest maksymalny rozmiar pojedynczej wartości typu string w Redisie według slajdu?**

- A) 64 KB
- B) 16 MB
- C) 512 MB
- D) 4 GB

<details><summary>Odpowiedź</summary>

**C** — Wartość (string) do 512 MB; klucz również do 512 MB, choć zaleca się małe klucze. 16 MB to limit dokumentu BSON w MongoDB. (slajd 227)

</details>

**6.53. Ile maksymalnie elementów może mieć lista (List) w Redisie według slajdu?**

- A) 2^16 - 1
- B) 2^31
- C) 2^64 - 1
- D) 2^32 - 1 (ok. 4 miliardy)

<details><summary>Odpowiedź</summary>

**D** — Lista, zbiór, hash i sorted set mieszczą do 2^32 - 1 elementów (ok. 4 miliardy). (slajd 227)

</details>

**6.54. Jaki format klucza slajd podaje jako dobrą praktykę?**

- A) `typ_obiektu:id`, np. `auto:0001`
- B) `id-typ_obiektu`, np. `0001-auto`
- C) Sam numer, np. `0001`
- D) Ścieżka plikowa, np. `/auto/0001`

<details><summary>Odpowiedź</summary>

**A** — Dobre praktyki: format typ_obiektu:id (np. auto:0001). (slajd 227)

</details>

**6.55. Który typ danych Redis slajd opisuje jako „zbiór z rankingiem (np. top 10)”?**

- A) set
- B) sorted set
- C) list
- D) hash

<details><summary>Odpowiedź</summary>

**B** — sorted set – zbiór z rankingiem. set to zbiór unikalnych wartości bez kolejności. (slajd 227)

</details>

### Redis Strings

**6.56. Które zdanie o Redis Strings jest prawdziwe?**

- A) Mogą przechowywać wyłącznie tekst w UTF-8
- B) Są najbardziej złożonym typem Redisa
- C) Przechowują sekwencje bajtów i mogą zawierać tekst, zserializowane obiekty i tablice binarne
- D) Nie mogą służyć jako liczniki

<details><summary>Odpowiedź</summary>

**C** — Strings przechowują sekwencje bajtów, są najprostszym typem i służą m.in. do liczników, cache, operacji bitowych i fragmentów HTML. (slajd 228, 229)

</details>

**6.57. Co zwróci ostatnie polecenie, jeśli klucz `licznik` wcześniej nie istniał?**

```
INCR licznik
INCR licznik
GET licznik
```

- A) `"2"`
- B) `"1"`
- C) `(nil)`
- D) Błąd, bo klucz nie istniał

<details><summary>Odpowiedź</summary>

**A** — Dla nieistniejącego klucza INCR przyjmuje 0 jako wartość początkową, więc po dwóch INCR wartość to 2. (slajd 229)

</details>

**6.58. Które polecenie zwiększa wartość ZMIENNOPRZECINKOWĄ klucza o podaną liczbę?**

- A) `INCRBY`
- B) `INCR`
- C) `DECRBY`
- D) `INCRBYFLOAT`

<details><summary>Odpowiedź</summary>

**D** — INCRBYFLOAT zwiększa wartość zmiennoprzecinkową; INCRBY działa na liczbach całkowitych. (slajd 229, 230)

</details>

**6.59. Które polecenie ustawia nową wartość klucza i zwraca jego STARĄ wartość?**

- A) `GETDEL`
- B) `GETSET`
- C) `GETRANGE`
- D) `GETEX`

<details><summary>Odpowiedź</summary>

**B** — GETSET ustawia nową wartość i zwraca starą. GETDEL zwraca i usuwa, GETRANGE zwraca podciąg, GETEX zwraca i ustawia wygaśnięcie. (slajd 229, 230)

</details>

**6.60. Które polecenie ustawia wiele kluczy naraz, ale TYLKO wtedy, gdy żaden z nich jeszcze nie istnieje?**

- A) `MSETNX`
- B) `MSET`
- C) `SETNX`
- D) `MGET`

<details><summary>Odpowiedź</summary>

**A** — MSETNX działa na wielu kluczach na zasadzie wszystko albo nic: jeśli choć jeden istnieje, nic nie jest ustawiane. SETNX dotyczy jednego klucza. (slajd 229, 230)

</details>

**6.61. Które polecenie zwraca podciąg wartości przechowywanej pod kluczem?**

- A) `SETRANGE key offset value`
- B) `STRLEN key`
- C) `GETRANGE key start end`
- D) `APPEND key value`

<details><summary>Odpowiedź</summary>

**C** — GETRANGE zwraca podciąg (oba końce włącznie). SETRANGE nadpisuje fragment, STRLEN zwraca długość, APPEND dopisuje na końcu. (slajd 230)

</details>

**6.62. Jaka jest poprawna kolejność argumentów polecenia PSETEX?**

- A) `PSETEX key value milliseconds`
- B) `PSETEX milliseconds key value`
- C) `PSETEX key value PX milliseconds`
- D) `PSETEX key milliseconds value`

<details><summary>Odpowiedź</summary>

**D** — PSETEX key milliseconds value, analogicznie do SETEX key seconds value: czas przed wartością. (slajd 230)

</details>

**6.63. Które polecenie ustawia lub kasuje pojedynczy bit w wartości stringa?**

- A) `SETRANGE`
- B) `SETBIT`
- C) `GETBIT`
- D) `BITCOUNT`

<details><summary>Odpowiedź</summary>

**B** — SETBIT key offset value ustawia lub kasuje bit; GETBIT go odczytuje. (slajd 230)

</details>

**6.64. Co robi `APPEND key value`, gdy klucz nie istnieje?**

- A) Tworzy klucz z podaną wartością
- B) Zwraca błąd
- C) Zwraca nil i nic nie robi
- D) Tworzy listę z jednym elementem

<details><summary>Odpowiedź</summary>

**A** — APPEND dopisuje do wartości klucza i tworzy klucz, jeśli nie istnieje (opis z redis.io). (slajd 229)

</details>

### SET, GET, GETDEL, MGET, SETEX

**6.65. Co się dzieje z czasem życia (TTL) klucza po pomyślnym zwykłym `SET` bez dodatkowych opcji?**

- A) TTL zostaje zachowany
- B) TTL jest usuwany
- C) TTL jest resetowany do 60 s
- D) SET kończy się błędem, jeśli klucz ma TTL

<details><summary>Odpowiedź</summary>

**B** — Poprzedni TTL jest usuwany po pomyślnym SET. Żeby go zachować, dodaje się opcję KEEPTTL. (slajd 231)

</details>

**6.66. Które polecenie zapisze klucz `anotherkey`, który wygaśnie po minucie?**

- A) `SET anotherkey "will expire in a minute" PX 60`
- B) `SET anotherkey EX 60 "will expire in a minute"`
- C) `SET anotherkey "will expire in a minute" EX 60`
- D) `SETEX anotherkey "will expire in a minute" 60`

<details><summary>Odpowiedź</summary>

**C** — EX podaje sekundy po wartości. PX 60 to 60 ms; w B opcja stoi przed wartością; SETEX ma kolejność key seconds value. (slajd 231)

</details>

**6.67. Co oznacza opcja `NX` w poleceniu SET?**

- A) Ustaw tylko wtedy, gdy klucz już istnieje
- B) Zwróć starą wartość
- C) Zachowaj dotychczasowy TTL
- D) Ustaw tylko wtedy, gdy klucz nie istnieje

<details><summary>Odpowiedź</summary>

**D** — NX = tylko gdy klucz nie istnieje; XX = tylko gdy istnieje; GET zwraca starą wartość; KEEPTTL zachowuje TTL. (slajd 231)

</details>

**6.68. Co się stanie, gdy wykonamy SET na kluczu, pod którym przechowywana jest lista?**

- A) Wartość zostanie nadpisana stringiem niezależnie od typu
- B) Polecenie zwróci błąd WRONGTYPE
- C) String zostanie dopisany na koniec listy
- D) Polecenie zwróci nil i nic nie zmieni

<details><summary>Odpowiedź</summary>

**A** — SET nadpisuje wartość niezależnie od typu („ignoring its type”). (slajd 229, 231)

</details>

**6.69. Co zwróci `GET nonexisting`, gdy klucz nie istnieje?**

- A) `""` (pusty string)
- B) `(nil)`
- C) `(integer) 0`
- D) `(error) ERR no such key`

<details><summary>Odpowiedź</summary>

**B** — Dla nieistniejącego klucza GET zwraca specjalną wartość nil. (slajd 232)

</details>

**6.70. Co zwróci GET, jeśli pod kluczem zapisano hash?**

- A) Wszystkie pola hasha
- B) Pierwsze pole hasha
- C) Błąd, bo GET obsługuje tylko wartości typu string
- D) `(nil)`

<details><summary>Odpowiedź</summary>

**C** — GET zwraca błąd (WRONGTYPE), jeśli wartość nie jest stringiem. Hash odczytuje się np. przez HGETALL. (slajd 232)

</details>

**6.71. Co zwróci ostatnie polecenie?**

```
SET mykey "Hello"
GETDEL mykey
GET mykey
```

- A) `"Hello"`
- B) `(integer) 1`
- C) `"OK"`
- D) `(nil)`

<details><summary>Odpowiedź</summary>

**D** — GETDEL zwrócił "Hello" i usunął klucz, więc kolejne GET zwraca nil. (slajd 233)

</details>

**6.72. Co zwróci ostatnie polecenie?**

```
SET key1 "Hello"
SET key2 "World"
MGET key1 key2 nonexisting
```

- A) `1) "Hello" 2) "World" 3) (nil)`
- B) `1) "Hello" 2) "World"`
- C) Błąd, bo klucz nonexisting nie istnieje
- D) `(integer) 2`

<details><summary>Odpowiedź</summary>

**A** — MGET zwraca wartość dla każdego klucza w kolejności, a dla brakującego nil; nigdy nie kończy się błędem. (slajd 234)

</details>

**6.73. Co MGET zwraca dla klucza, który istnieje, ale przechowuje listę?**

- A) Błąd WRONGTYPE dla całego polecenia
- B) Zawartość listy
- C) `nil` na tej pozycji
- D) Długość listy

<details><summary>Odpowiedź</summary>

**C** — Dla klucza, który nie przechowuje stringa lub nie istnieje, MGET zwraca nil, więc operacja nigdy nie kończy się błędem. (slajd 234)

</details>

**6.74. Któremu poleceniu jest równoważne `SETEX mykey 10 "Hello"`?**

- A) `SET mykey 10 "Hello"`
- B) `SET mykey "Hello" EX 10`
- C) `SET mykey "Hello" PX 10`
- D) `SETNX mykey "Hello" EX 10`

<details><summary>Odpowiedź</summary>

**B** — SETEX key seconds value = SET key value EX seconds. PX oznaczałoby milisekundy. (slajd 235)

</details>

**6.75. Od której wersji Redisa SETEX jest uznawane za przestarzałe (deprecated)?**

- A) 2.6.12
- B) 3.0
- C) 5.0
- D) 7.2

<details><summary>Odpowiedź</summary>

**A** — Od Redis 2.6.12 SETEX jest deprecated i należy zastępować je SET z argumentem EX. (slajd 235)

</details>

**6.76. Co zwróci `TTL mykey` zaraz po `SETEX mykey 10 "Hello"`?**

- A) `(integer) -1`
- B) `(integer) 10000`
- C) `(nil)`
- D) `(integer) 10`

<details><summary>Odpowiedź</summary>

**D** — TTL zwraca pozostały czas w sekundach: 10. 10000 zwróciłoby PTTL (milisekundy). (slajd 235)

</details>

### Redis Lists

**6.77. Jak slajd definiuje listy w Redisie?**

- A) Tablice o stałym rozmiarze z dostępem po indeksie w czasie stałym
- B) Nieuporządkowane kolekcje unikalnych stringów
- C) Połączone listy wartości typu string
- D) Drzewa posortowane według score

<details><summary>Odpowiedź</summary>

**C** — Listy to połączone listy (linked lists) wartości string, używane do stosów i kolejek. B opisuje Set, D Sorted Set. (slajd 236)

</details>

**6.78. Którą parę poleceń użyjesz, aby lista działała jak kolejka FIFO?**

- A) `LPUSH` i `RPOP`
- B) `LPUSH` i `LPOP`
- C) `RPUSH` i `RPOP`
- D) `SADD` i `SPOP`

<details><summary>Odpowiedź</summary>

**A** — Kolejka wymaga wkładania i zdejmowania z przeciwnych stron. LPUSH+LPOP oraz RPUSH+RPOP to stos (LIFO), a SPOP zdejmuje losowo. (slajd 236)

</details>

**6.79. Co robi BLPOP, gdy lista jest pusta?**

- A) Zwraca natychmiast błąd
- B) Tworzy pusty element i go zwraca
- C) Usuwa klucz listy
- D) Blokuje się, dopóki element nie będzie dostępny lub nie minie limit czasu

<details><summary>Odpowiedź</summary>

**D** — Polecenia z prefiksem B (blocking) czekają na element lub na upływ timeoutu. (slajd 236)

</details>

**6.80. Które polecenie przycina listę do określonego zakresu elementów?**

- A) `LREM`
- B) `LRANGE`
- C) `LSET`
- D) `LTRIM`

<details><summary>Odpowiedź</summary>

**D** — LTRIM key start stop przycina listę. LRANGE tylko zwraca zakres bez zmiany listy, LREM usuwa elementy o danej wartości, LSET ustawia element po indeksie. (slajd 236, 239)

</details>

**6.81. Co zwróci ostatnie polecenie (lista mylist wcześniej nie istniała)?**

```
LPUSH mylist "first"
RPUSH mylist "last"
LRANGE mylist 0 -1
```

- A) `1) "last" 2) "first"`
- B) `1) "first" 2) "last"`
- C) `1) "first"`
- D) `(integer) 2`

<details><summary>Odpowiedź</summary>

**B** — first trafia na początek pustej listy, last na koniec; `0 -1` to cała lista. (slajd 237)

</details>

**6.82. Które polecenie wstawia element przed lub po innym elemencie (pivot) listy?**

- A) `LINSERT key BEFORE|AFTER pivot value`
- B) `LSET key index value`
- C) `LPUSHX key value`
- D) `LPOS key value`

<details><summary>Odpowiedź</summary>

**A** — LINSERT wstawia przed lub po pivocie. LSET nadpisuje element o indeksie, LPUSHX dodaje na początek istniejącej listy, LPOS zwraca indeks. (slajd 238, 239)

</details>

**6.83. Czym różni się `LPUSHX` od `LPUSH`?**

- A) LPUSHX dodaje element na koniec listy
- B) LPUSHX dodaje element tylko wtedy, gdy lista już istnieje
- C) LPUSHX blokuje się na pustej liście
- D) LPUSHX dodaje element z czasem wygaśnięcia

<details><summary>Odpowiedź</summary>

**B** — LPUSHX dodaje na początek tylko, gdy lista istnieje; LPUSH tworzy klucz, jeśli go nie ma. (slajd 238, 239)

</details>

**6.84. Co robi `RPOPLPUSH source destination`?**

- A) Zdejmuje pierwszy element ze źródła i dodaje go na koniec celu
- B) Kopiuje całą listę źródłową do docelowej
- C) Usuwa ostatni element ze źródła, dodaje go na początek celu i zwraca go
- D) Blokuje się do czasu pojawienia się elementu w celu

<details><summary>Odpowiedź</summary>

**C** — RPOP ze źródła (koniec), LPUSH do celu (początek), zwraca przeniesiony element. Wersja blokująca to BRPOPLPUSH. (slajd 238, 239)

</details>

**6.85. Które polecenie zwraca element listy według jego indeksu?**

- A) `LPOS`
- B) `LRANGE`
- C) `LSET`
- D) `LINDEX`

<details><summary>Odpowiedź</summary>

**D** — LINDEX key index zwraca element o indeksie. LPOS działa odwrotnie: zwraca indeks pasującego elementu. (slajd 238, 239)

</details>

**6.86. Co dzieje się z kluczem listy, gdy zdejmiemy z niej ostatni element (np. przez LPOP)?**

- A) Klucz zostaje jako pusta lista
- B) Lista jest usuwana
- C) Polecenie zwraca błąd
- D) Lista dostaje TTL 0

<details><summary>Odpowiedź</summary>

**B** — Według opisów redis.io: „Deletes the list if the last element was popped”. W Redisie nie ma pustych list. (slajd 238)

</details>

### Redis Sets

**6.87. Które zdanie najlepiej opisuje zbiór (Set) w Redisie?**

- A) Uporządkowana lista stringów z duplikatami
- B) Mapa pól na wartości
- C) Nieuporządkowana kolekcja unikalnych stringów (members)
- D) Zbiór elementów posortowanych według score

<details><summary>Odpowiedź</summary>

**C** — Set to nieuporządkowana kolekcja unikalnych wartości string. A to List, B Hash, D Sorted Set. (slajd 240)

</details>

**6.88. Które polecenie zwraca liczebność (rozmiar) zbioru?**

- A) `LLEN`
- B) `SMEMBERS`
- C) `STRLEN`
- D) `SCARD`

<details><summary>Odpowiedź</summary>

**D** — SCARD (od cardinality) zwraca liczbę członków zbioru. LLEN to długość listy, STRLEN długość stringa. (slajd 240, 243)

</details>

**6.89. Które polecenie sprawdza, czy dany string należy do zbioru?**

- A) `SISMEMBER`
- B) `EXISTS`
- C) `SINTER`
- D) `SSCAN`

<details><summary>Odpowiedź</summary>

**A** — SISMEMBER key member zwraca 1 lub 0. EXISTS sprawdza istnienie klucza, nie członka. (slajd 240)

</details>

**6.90. Które polecenie zwraca część wspólną dwóch lub więcej zbiorów?**

- A) `SUNION`
- B) `SDIFF`
- C) `SINTER`
- D) `SMOVE`

<details><summary>Odpowiedź</summary>

**C** — SINTER zwraca członków wspólnych (iloczyn). SUNION to suma, SDIFF różnica, SMOVE przenosi członka. (slajd 240, 243)

</details>

**6.91. Które polecenie wyświetli wszystkich członków zbioru `myset` po `SADD myset "apple" "banana" "cherry"`?**

- A) `LRANGE myset 0 -1`
- B) `SMEMBERS myset`
- C) `GET myset`
- D) `HGETALL myset`

<details><summary>Odpowiedź</summary>

**B** — SMEMBERS zwraca wszystkich członków zbioru (w dowolnej kolejności). LRANGE jest dla list, GET dla stringów, HGETALL dla hashy. (slajd 241)

</details>

**6.92. Czym różni się `SPOP` od `SRANDMEMBER`?**

- A) SPOP usuwa zwrócone losowe elementy, SRANDMEMBER tylko je zwraca
- B) SRANDMEMBER usuwa elementy, SPOP tylko je zwraca
- C) SPOP zwraca zawsze pierwszy dodany element
- D) Nie różnią się, to aliasy

<details><summary>Odpowiedź</summary>

**A** — SPOP usuwa i zwraca losowych członków; SRANDMEMBER zwraca losowych członków bez usuwania. (slajd 242, 243)

</details>

**6.93. Co robi `SINTERSTORE destination key1 key2`?**

- A) Zwraca część wspólną i niczego nie zapisuje
- B) Zapisuje sumę zbiorów w kluczu destination
- C) Przenosi członków z key1 do key2
- D) Zapisuje część wspólną zbiorów w kluczu destination

<details><summary>Odpowiedź</summary>

**D** — Wersje STORE (SINTERSTORE, SUNIONSTORE, SDIFFSTORE) zapisują wynik pod kluczem docelowym podanym jako pierwszy argument. (slajd 242, 243)

</details>

**6.94. Które polecenie zwraca tylko LICZBĘ elementów części wspólnej wielu zbiorów?**

- A) `SCARD`
- B) `SINTERCARD`
- C) `SINTERSTORE`
- D) `SMISMEMBER`

<details><summary>Odpowiedź</summary>

**B** — SINTERCARD zwraca liczbę członków części wspólnej. SCARD liczy członków jednego zbioru. (slajd 242)

</details>

**6.95. Które polecenie służy do przyrostowej iteracji po elementach zbioru?**

- A) `SMEMBERS key`
- B) `SRANDMEMBER key count`
- C) `SSCAN key cursor [MATCH pattern] [COUNT count]`
- D) `KEYS pattern`

<details><summary>Odpowiedź</summary>

**C** — SSCAN iteruje przyrostowo, kursorem. SMEMBERS zwraca wszystko naraz. (slajd 242, 243)

</details>

### JSON w Redis Stack

**6.96. Które polecenie JSON jest aliasem `JSON.DEL`?**

- A) `JSON.CLEAR`
- B) `JSON.ARRPOP`
- C) `JSON.FORGET`
- D) `JSON.TOGGLE`

<details><summary>Odpowiedź</summary>

**C** — JSON.FORGET również „Deletes a value”, jest aliasem JSON.DEL. JSON.CLEAR czyści tablice/obiekty i zeruje liczby. (slajd 244)

</details>

**6.97. Które polecenie zamienia wartość logiczną w dokumencie JSON na przeciwną?**

- A) `JSON.NUMINCRBY`
- B) `JSON.SET ... !`
- C) `JSON.CLEAR`
- D) `JSON.TOGGLE`

<details><summary>Odpowiedź</summary>

**D** — JSON.TOGGLE przełącza wartość boolean. (slajd 244)

</details>

**6.98. Co robi `JSON.CLEAR`?**

- A) Usuwa cały klucz
- B) Czyści wszystkie wartości z tablicy lub obiektu i ustawia wartości liczbowe na 0
- C) Usuwa ostatni element tablicy
- D) Usuwa indeks wyszukiwania

<details><summary>Odpowiedź</summary>

**B** — JSON.CLEAR: „Clears all values from an array or an object and sets numeric values to 0”. (slajd 244)

</details>

**6.99. Które polecenie zwraca długość tablicy pod ścieżką w dokumencie JSON?**

- A) `JSON.ARRLEN`
- B) `LLEN`
- C) `JSON.OBJLEN`
- D) `JSON.STRLEN`

<details><summary>Odpowiedź</summary>

**A** — JSON.ARRLEN zwraca długość tablicy. OBJLEN liczbę kluczy obiektu, STRLEN długość napisu, a LLEN dotyczy list Redisa. (slajd 244)

</details>

**6.100. Które polecenie mnoży wartość liczbową pod ścieżką JSON przez podaną liczbę?**

- A) `JSON.NUMINCRBY`
- B) `INCRBYFLOAT`
- C) `JSON.NUMMULTBY`
- D) `JSON.MERGE`

<details><summary>Odpowiedź</summary>

**C** — JSON.NUMMULTBY mnoży, JSON.NUMINCRBY dodaje. (slajd 244)

</details>

**6.101. Co oznacza `$` jako ścieżka w poleceniu `JSON.SET bikes:1 $ '{...}'`?**

- A) Korzeń dokumentu, czyli cały dokument
- B) Ostatni element tablicy
- C) Wszystkie klucze z prefiksem bikes:
- D) Zmienną środowiskową

<details><summary>Odpowiedź</summary>

**A** — `$` to korzeń (root) dokumentu JSON; JSON.SET z `$` ustawia cały dokument. (slajd 245)

</details>

**6.102. Które polecenie poprawnie zmieni pole model roweru bikes:1 na napis Hyperion1?**

- A) `JSON.SET bikes:1 $.model Hyperion1`
- B) `JSON.SET bikes:1 $.model '"Hyperion1"'`
- C) `SET bikes:1.model "Hyperion1"`
- D) `JSON.GET bikes:1 $.model "Hyperion1"`

<details><summary>Odpowiedź</summary>

**B** — Wartość musi być poprawnym JSON, więc napis ma cudzysłowy wewnątrz apostrofów. Bez cudzysłowów (A) to nie jest poprawny JSON. (slajd 245)

</details>

**6.103. Które polecenie odczyta zagnieżdżone pole material z obiektu specs?**

- A) `JSON.GET bikes:1 $.material`
- B) `JSON.GET bikes:1 specs:material`
- C) `HGET bikes:1 specs.material`
- D) `JSON.GET bikes:1 $.specs.material`

<details><summary>Odpowiedź</summary>

**D** — Pola zagnieżdżone łączy się kropkami od korzenia: `$.specs.material`. (slajd 245)

</details>

**6.104. Które polecenie zmienia bazę logiczną w redis-cli na bazę nr 1?**

- A) `USE 1`
- B) `MOVE 1`
- C) `SELECT 1`
- D) `DB 1`

<details><summary>Odpowiedź</summary>

**C** — Slajd: aby w CLI zmienić bazę logiczną, wykonujemy SELECT, np. SELECT 1. `use` to polecenie mongosh, MOVE przenosi klucz. (slajd 245)

</details>

**6.105. Które polecenie zwraca OSTATNI element tablicy status_log w dokumencie school_json:1?**

- A) `JSON.GET school_json:1 $.status_log[-1]`
- B) `JSON.GET school_json:1 $.status_log[0]`
- C) `JSON.GET school_json:1 $.status_log[last]`
- D) `JSON.ARRPOP school_json:1 $.status_log 0`

<details><summary>Odpowiedź</summary>

**A** — Indeks -1 to ostatni element, 0 pierwszy. ARRPOP z indeksem 0 usunąłby pierwszy element. (slajd 246)

</details>

**6.106. Co zrobi `JSON.DEL school_json:1 $.students`?**

- A) Usunie cały dokument school_json:1
- B) Ustawi pole students na 0
- C) Usunie tylko pole students z dokumentu
- D) Usunie indeks idx:schools_json

<details><summary>Odpowiedź</summary>

**C** — JSON.DEL ze ścieżką usuwa tylko wskazane pole; bez ścieżki (`JSON.DEL school_json:1`) usuwa cały dokument. (slajd 247)

</details>

**6.107. Które polecenie ustawi liczbę uczniów (students) na 343?**

- A) `JSON.SET school_json:1 $.students 343`
- B) `JSON.SET school_json:1 students '"343"'`
- C) `SET school_json:1 $.students 343`
- D) `JSON.NUMINCRBY school_json:1 $.students 343`

<details><summary>Odpowiedź</summary>

**A** — Liczbę podaje się bez cudzysłowów, ze ścieżką `$.students`. B zapisałoby napis, NUMINCRBY dodałoby 343 do obecnej wartości. (slajd 247)

</details>

### JSONPath

**6.108. Jaki jest odpowiednik XPath `//author` w JSONPath?**

- A) `$.author`
- B) `$..author`
- C) `$.*.author`
- D) `@.author`

<details><summary>Odpowiedź</summary>

**B** — Dwie kropki to zejście rekurencyjne (dowolna głębokość), odpowiednik `//` w XPath. (slajd 248)

</details>

**6.109. Jak w JSONPath wybrać TRZECIĄ książkę (XPath `//book[3]`)?**

- A) `$..book[3]`
- B) `$..book[-3]`
- C) `$..book[:3]`
- D) `$..book[2]`

<details><summary>Odpowiedź</summary>

**D** — JSONPath indeksuje od 0, XPath od 1, więc trzecia książka to `[2]`. (slajd 248)

</details>

**6.110. Które wyrażenie JSONPath zwraca wszystkie książki tańsze niż 10?**

- A) `$..book[?(@.price<10)]`
- B) `$..book[price<10]`
- C) `$..book[(@.price<10)]`
- D) `$.book.price<10`

<details><summary>Odpowiedź</summary>

**A** — Filtr ma postać `[?( ... )]`, a `@` to bieżący element. B to składnia XPath. (slajd 248)

</details>

**6.111. Co zwraca wyrażenie `$..book[:2]`?**

- A) Trzecią książkę
- B) Ostatnie dwie książki
- C) Pierwsze dwie książki
- D) Książki z co najmniej dwoma autorami

<details><summary>Odpowiedź</summary>

**C** — Wycinek `[:2]` to indeksy 0 i 1, czyli pierwsze dwie książki; równoważnie `$..book[0,1]`. (slajd 248)

</details>

**6.112. Które wyrażenie JSONPath zwraca ostatnią książkę?**

- A) `$..book[last()]`
- B) `$..book[0]`
- C) `$..book[*]`
- D) `$..book[-1:]`

<details><summary>Odpowiedź</summary>

**D** — Ostatnia książka to `$..book[-1:]` lub `$..book[(@.length-1)]`. `last()` to składnia XPath. (slajd 248)

</details>

**6.113. Co oznacza wyrażenie `$.store..price`?**

- A) Cena pierwszej rzeczy w sklepie
- B) Cena wszystkiego w sklepie
- C) Wyłącznie ceny książek
- D) Najniższa cena w sklepie

<details><summary>Odpowiedź</summary>

**B** — `..price` szuka pola price na dowolnej głębokości pod store, więc zwraca ceny książek i roweru (XPath `/store//price`). (slajd 248)

</details>

### Indeksowanie: FT.CREATE

**6.114. Dlaczego Redis Stack wprowadza indeksowanie danych?**

- A) Bo przestrzeń kluczy jest płaska i domyślnie dane są dostępne tylko po nazwie klucza
- B) Bo bez indeksu Redis nie może zapisywać JSON
- C) Bo indeks zastępuje trwałość RDB
- D) Bo indeksy są wymagane przez replikację

<details><summary>Odpowiedź</summary>

**A** — Przestrzeń kluczy jest nieustrukturyzowana i płaska; bez indeksu trudno znaleźć dokument po cesze drugorzędnej. (slajd 249)

</details>

**6.115. Kiedy według slajdu odbywa się indeksowanie nowych danych po zdefiniowaniu indeksu?**

- A) Raz na dobę w zadaniu wsadowym
- B) Tylko po ręcznym poleceniu FT.REINDEX
- C) Asynchronicznie, przy restarcie serwera
- D) Automatycznie i synchronicznie przy zapisie nowych danych

<details><summary>Odpowiedź</summary>

**D** — Po określeniu, co indeksować, indeksowanie odbywa się automatycznie (i synchronicznie) po zapisaniu nowych danych. (slajd 249)

</details>

**6.116. Co oznacza fragment `PREFIX 1 "bikes:"` w `FT.CREATE idx:bikes ON JSON PREFIX 1 "bikes:" SCHEMA ...`?**

- A) Indeks obejmie tylko pierwszy klucz bikes:
- B) Indeks obejmie klucze z jednym prefiksem: bikes:
- C) Indeks zostanie zapisany w bazie logicznej nr 1
- D) Pole bikes: ma wagę 1 w wyszukiwaniu

<details><summary>Odpowiedź</summary>

**B** — Liczba po PREFIX to liczba podanych prefiksów; indeksowane są klucze zaczynające się od bikes:. (slajd 249)

</details>

**6.117. Którego typu pola użyjesz do dokładnego dopasowania kategorii, np. type „eBikes”?**

- A) TEXT
- B) NUMERIC
- C) TAG
- D) GEO

<details><summary>Odpowiedź</summary>

**C** — TAG pozwala na dokładne dopasowanie (komentarz przy `$.class AS class TAG`). TEXT służy do wyszukiwania pełnotekstowego, NUMERIC do zakresów liczb, GEO do położenia. (slajd 249, 250)

</details>

**6.118. Co oznacza modyfikator `NOSTEM` przy polu `$.model AS model TEXT NOSTEM SORTABLE`?**

- A) Pole nie będzie indeksowane
- B) Pole nie będzie sortowalne
- C) Pole zostanie zapisane jako tag
- D) Wyłączenie sprowadzania słów do rdzenia (stemmingu)

<details><summary>Odpowiedź</summary>

**D** — NOSTEM wyłącza stemming, co ma sens dla nazw własnych, jak model czy marka. Sortowanie włącza SORTABLE. (slajd 249)

</details>

**6.119. Które polecenie zwraca listę wszystkich indeksów?**

- A) `FT._LIST`
- B) `FT.INFO`
- C) `KEYS idx:*`
- D) `FT.SEARCH *`

<details><summary>Odpowiedź</summary>

**A** — FT._LIST zwraca listę indeksów (np. 1) "idx:bikes"). FT.INFO pokazuje informacje o jednym indeksie. (slajd 249)

</details>

**6.120. Które polecenie usuwa indeks idx:bikes?**

- A) `DEL idx:bikes`
- B) `FT.DROPINDEX idx:bikes`
- C) `FT.DEL idx:bikes`
- D) `JSON.DEL idx:bikes`

<details><summary>Odpowiedź</summary>

**B** — FT.DROPINDEX idx:bikes zwraca OK. Domyślnie nie usuwa dokumentów; z opcją DD usuwa też dokumenty. (slajd 249)

</details>

**6.121. Co oznacza definicja `$.type[*] AS type TAG` w indeksie idx:schools_json?**

- A) Indeksowany jest tylko pierwszy element tablicy type
- B) Pole type jest indeksowane jako tekst pełny
- C) Każdy element tablicy type jest traktowany jako osobny tag
- D) Indeksowana jest liczba elementów tablicy type

<details><summary>Odpowiedź</summary>

**C** — Komentarz na slajdzie: pole type jest tablicą, a każdy jej element będzie traktowany jako osobny tag. (slajd 250)

</details>

**6.122. Jaki typ pola w FT.CREATE pozwala na zapytania o zakres geograficzny (np. `$.location`)?**

- A) TAG
- B) NUMERIC
- C) VECTOR
- D) GEO

<details><summary>Odpowiedź</summary>

**D** — `$.location AS location GEO` indeksuje dane geograficzne i pozwala na zapytania o zakres geograficzny. (slajd 250)

</details>

**6.123. Które pole w indeksie idx:schools_json pozwala na sortowanie i zapytania zakresowe po liczbie uczniów?**

- A) `$.students AS students NUMERIC SORTABLE`
- B) `$.students AS students TAG`
- C) `$.students AS students TEXT NOSORTABLE`
- D) `$.students AS students GEO`

<details><summary>Odpowiedź</summary>

**A** — NUMERIC daje zapytania zakresowe, a SORTABLE sortowanie. Uwaga: słowo NOSORTABLE ze slajdu nie występuje w dokumentacji FT.CREATE (pole bez SORTABLE i tak nie jest sortowalne). (slajd 250)

</details>

### Zapytania FT.SEARCH i agregacje FT.AGGREGATE

**6.124. Jak w FT.SEARCH wyszukać rowery, których pole TAG `type` ma wartość eBikes?**

- A) `FT.SEARCH idx:bikes "@type:[eBikes]"`
- B) `FT.SEARCH idx:bikes "@type:{eBikes}"`
- C) `FT.SEARCH idx:bikes "type = eBikes"`
- D) `FT.SEARCH idx:bikes "$.type:eBikes"`

<details><summary>Odpowiedź</summary>

**B** — Pola TAG odpytuje się w nawiasach klamrowych `@pole:{wartość}`. Nawiasy kwadratowe są dla zakresów NUMERIC. (slajd 251)

</details>

**6.125. Jak zapisać warunek „cena od 200 do 1200” dla pola NUMERIC price w FT.SEARCH?**

- A) `@price:{200 1200}`
- B) `@price:200-1200`
- C) `@price:[200 1200]`
- D) `@price BETWEEN 200 AND 1200`

<details><summary>Odpowiedź</summary>

**C** — Zakres liczbowy zapisuje się w nawiasach kwadratowych `[min max]`. (slajd 251)

</details>

**6.126. Dlaczego w zapytaniu poniżej po RETURN stoi liczba 9?**

```
FT.SEARCH idx:bikes "@type:{eBikes} @price:[200 1200]"
    RETURN 9 $.model AS model $.type AS type $.price AS price
```

- A) Bo zwracanych jest 9 dokumentów
- B) Bo 9 to maksymalna liczba wyników
- C) Bo zwracanych jest 9 pól
- D) Bo po RETURN następuje 9 argumentów (3 pola × ścieżka, AS, alias)

<details><summary>Odpowiedź</summary>

**D** — Liczba po RETURN to liczba argumentów, a nie pól: każde pole z aliasem to 3 tokeny. Dla czterech pól z aliasami jest RETURN 12. (slajd 251)

</details>

**6.127. Co oznacza słowo `mudguards` na początku zapytania `"mudguards @type:{Mountain bikes} @price:[1000 3000]"`?**

- A) Wyszukiwanie pełnotekstowe tego słowa w polach TEXT
- B) Nazwę indeksu
- C) Dokładne dopasowanie tagu
- D) Alias zwracanego pola

<details><summary>Odpowiedź</summary>

**A** — Słowo bez `@pole:` to wyszukiwanie pełnotekstowe we wszystkich polach TEXT (np. description). Spacje między warunkami oznaczają AND. (slajd 251)

</details>

**6.128. Co oblicza poniższe zapytanie?**

```
FT.AGGREGATE idx:bikes "@price:[1000 3000]"
    GROUPBY 1 @type
        REDUCE COUNT 0 AS count
    SORTBY 2 @count "DESC"
```

- A) Średnią cenę rowerów w każdej kategorii
- B) Łączną liczbę rowerów w cenie 1000–3000
- C) Liczbę rowerów w cenie 1000–3000 w każdej kategorii, malejąco
- D) Najdroższy rower w każdej kategorii

<details><summary>Odpowiedź</summary>

**C** — GROUPBY po type, REDUCE COUNT liczy dokumenty w grupie, SORTBY po count malejąco. (slajd 252)

</details>

**6.129. Dlaczego w `REDUCE COUNT 0 AS count` stoi zero, a w `REDUCE AVG 1 @weight AS average_bike_weight` jedynka?**

- A) To liczba argumentów funkcji redukującej: COUNT nie ma argumentów, AVG ma jeden (pole)
- B) To numer bazy logicznej
- C) 0 oznacza sortowanie rosnące, 1 malejące
- D) To liczba miejsc po przecinku wyniku

<details><summary>Odpowiedź</summary>

**A** — Liczby po GROUPBY, REDUCE i SORTBY oznaczają liczbę następujących argumentów. (slajd 252)

</details>

**6.130. Do czego służy klauzula `APPLY "floor(@weight)" AS weight` w FT.AGGREGATE?**

- A) Filtruje rowery lżejsze od 1 kg
- B) Oblicza dla każdego dokumentu nowe pole: wagę zaokrągloną w dół
- C) Sortuje wyniki po wadze
- D) Usuwa pole weight z wyników

<details><summary>Odpowiedź</summary>

**B** — APPLY liczy wyrażenie na każdym dokumencie; floor zaokrągla w dół, co pozwala potem grupować rowery w przedziały wagi. (slajd 252)

</details>

**6.131. Co oznacza zapytanie `"*"` w `FT.AGGREGATE idx:bikes "*"`?**

- A) Wszystkie indeksy w bazie
- B) Wszystkie pola dokumentu
- C) Brak wyników
- D) Wszystkie dokumenty indeksu, bez filtra

<details><summary>Odpowiedź</summary>

**D** — `"*"` dopasowuje wszystkie dokumenty w indeksie. (slajd 252)

</details>

### Transakcje

**6.132. Którym poleceniem rozpoczyna się transakcję w Redisie, a którym ją wykonuje?**

- A) BEGIN i COMMIT
- B) WATCH i EXEC
- C) MULTI i EXEC
- D) MULTI i DISCARD

<details><summary>Odpowiedź</summary>

**C** — MULTI oznacza początek bloku, EXEC wykonuje zakolejkowane polecenia. DISCARD je odrzuca. (slajd 253)

</details>

**6.133. Które polecenie odrzuca wszystkie polecenia wydane po MULTI?**

- A) `UNWATCH`
- B) `DISCARD`
- C) `ROLLBACK`
- D) `FLUSHDB`

<details><summary>Odpowiedź</summary>

**B** — DISCARD odrzuca polecenia po MULTI. Redis nie ma polecenia ROLLBACK, a UNWATCH tylko zdejmuje obserwację kluczy. (slajd 253)

</details>

**6.134. Do czego służy `WATCH key [key ...]`?**

- A) Do obserwowania kluczy, żeby warunkowo wykonać blok MULTI/EXEC (EXEC nie wykona się, jeśli klucz zmieniono)
- B) Do subskrypcji kanału Pub/Sub
- C) Do ustawienia czasu wygaśnięcia
- D) Do zablokowania klucza przed odczytem przez innych klientów

<details><summary>Odpowiedź</summary>

**A** — WATCH to optymistyczne blokowanie: jeśli obserwowany klucz zmieni się przed EXEC, transakcja jest przerywana (EXEC zwraca nil). Nie blokuje odczytu. (slajd 253)

</details>

**6.135. Które zdanie o transakcjach Redis jest zgodne ze slajdem?**

- A) Polecenia transakcji wykonują się równolegle na wielu wątkach
- B) Polecenia są wykonywane natychmiast po wpisaniu, a EXEC tylko je zatwierdza
- C) Transakcja nie jest izolowana
- D) Polecenia są wykonywane sekwencyjnie i izolowane, a transakcja jest atomowa

<details><summary>Odpowiedź</summary>

**D** — Slajd: sekwencyjnie, izolowane, atomowe (wszystkie albo żadne). Uwaga: w praktyce Redis nie wycofuje (rollback) poleceń, które zawiodły w trakcie EXEC; błąd składni przed EXEC odrzuca całą transakcję. (slajd 253)

</details>

### Nowe funkcje Redis Stack

**6.136. Jakie algorytmy obsługuje Vector Similarity Search w Redis Stack według slajdu?**

- A) B-drzewo i LSM
- B) MapReduce i PageRank
- C) HNSW i brute-force
- D) Raft i Paxos

<details><summary>Odpowiedź</summary>

**C** — Vector Similarity Search: obsługa hashy i JSON, algorytmy HNSW i brute-force. (slajd 254)

</details>

**6.137. Które zastosowanie slajd przypisuje Vector Similarity Search?**

- A) Wyszukiwanie semantyczne, rekomendacje, AI (RAG, NLP, CV)
- B) Monitoring IoT i metryki systemowe
- C) Transakcje finansowe ACID
- D) Kolejki zadań w tle

<details><summary>Odpowiedź</summary>

**A** — Wyszukiwanie semantyczne, rekomendacje, AI (RAG, NLP, CV). Monitoring IoT i metryki to Redis for Time Series. (slajd 254)

</details>

**6.138. Które cechy slajd przypisuje Redis for Time Series?**

- A) Algorytm HNSW i wyszukiwanie wektorów
- B) Agregacje, etykiety, kompaktowanie danych, integracja z Prometheus/Grafana
- C) Przechowywanie grafów i zapytania Cypher
- D) Transakcje MULTI/EXEC na szeregach czasowych

<details><summary>Odpowiedź</summary>

**B** — Redis for Time Series: natywna struktura szeregów czasowych z agregacją, etykietami, kompaktowaniem i integracją z Prometheus/Grafana; zastosowania: IoT, metryki, dane finansowe. (slajd 254)

</details>


## 7. Bazy grafowe — Neo4j i SQL Server Graph

### Model danych grafowych

**7.1. Jak wykład definiuje graf w modelu danych baz grafowych?**

- A) Jako zbiór tabel połączonych kluczami obcymi
- B) Jako skierowaną lub nieskierowaną kolekcję węzłów reprezentujących encje i krawędzi reprezentujących relacje między encjami
- C) Jako zbiór par klucz–wartość, w których wartością jest lista sąsiadów
- D) Jako hierarchiczne drzewo dokumentów zagnieżdżonych

<details><summary>Odpowiedź</summary>

**B** — graf to skierowana albo nieskierowana kolekcja węzłów (encje) i krawędzi (relacje). Tabele z kluczami obcymi to model relacyjny, a drzewo dokumentów to model dokumentowy. (slajd 256)

</details>

**7.2. Które elementy grafu mogą mieć właściwości (atrybuty) według wykładu?**

- A) Tylko węzły
- B) Tylko krawędzie
- C) Ani węzły, ani krawędzie; właściwości trzyma się w osobnej tabeli
- D) Zarówno węzły, jak i krawędzie

<details><summary>Odpowiedź</summary>

**D** — slajd mówi wprost, że zarówno węzły, jak i krawędzie mogą posiadać dowolne właściwości. Przykład: relacja ZNA z właściwością od_kiedy. (slajd 256)

</details>

**7.3. Czym charakteryzują się transakcyjne (OLTP) bazy grafowe według wykładu?**

- A) Dużą liczbą małych lub średnich grafów
- B) Małą liczbą bardzo dużych grafów
- C) Jednym globalnym grafem bez transakcji
- D) Wyłącznie grafami nieskierowanymi

<details><summary>Odpowiedź</summary>

**A** — OLTP to duża liczba małych lub średnich grafów. Mała liczba bardzo dużych grafów to OLAP. (slajd 256)

</details>

**7.4. Czym charakteryzują się analityczne (OLAP) bazy grafowe według wykładu?**

- A) Dużą liczbą małych grafów
- B) Brakiem właściwości na krawędziach
- C) Małą liczbą bardzo dużych grafów
- D) Przechowywaniem grafu w pamięci podręcznej przeglądarki

<details><summary>Odpowiedź</summary>

**C** — OLAP to mała liczba bardzo dużych grafów, na których wykonuje się ciężkie analizy. Odwrotnie jest w OLTP. (slajd 256)

</details>

**7.5. Które zastosowanie NIE zostało wymienione na slajdzie „Kiedy używać?” baz grafowych?**

- A) Silniki rekomendacyjne
- B) Wykrywanie oszustw
- C) Knowledge Graphs
- D) Masowe przetwarzanie prostych danych tabelarycznych

<details><summary>Odpowiedź</summary>

**D** — slajd wymienia sieci społecznościowe, silniki rekomendacyjne, Knowledge Graphs, wykrywanie oszustw, systemy nawigacyjne i analizę zależności. Proste dane tabelaryczne to przypadek, w którym baza grafowa się nie sprawdza. (slajd 256)

</details>

**7.6. Kiedy według wykładu NIE należy używać bazy grafowej?**

- A) Gdy trzeba wyszukać najkrótszą ścieżkę
- B) Gdy operacje dotyczą wielu węzłów bądź krawędzi naraz
- C) Gdy dane opisują sieć społecznościową
- D) Gdy trzeba wyszukać podobne obiekty

<details><summary>Odpowiedź</summary>

**B** — slajd „Kiedy nie używać?” wymienia operacje dotyczące wielu węzłów bądź krawędzi oraz bardzo duże, złożone grafy w dużej liczbie. Pozostałe odpowiedzi to typowe zastosowania. (slajd 256)

</details>

**7.7. Który rodzaj zapytania wykład wymienia jako typowy dla baz grafowych?**

- A) Wyszukiwanie najkrótszej ścieżki
- B) Pełnotekstowe wyszukiwanie w dokumentach JSON
- C) Agregację szeregów czasowych w oknach czasowych
- D) Pobranie wartości po kluczu bez żadnych relacji

<details><summary>Odpowiedź</summary>

**A** — wykład wymienia: dodaj/zmień/usuń węzeł lub krawędź, wyszukiwanie najkrótszej ścieżki, analizę relacji i zależności, zapytania do podgrafów i nadgrafów oraz wyszukiwanie podobnych obiektów. (slajd 256)

</details>

**7.8. Który zestaw zawiera wyłącznie przedstawicieli baz grafowych pokazanych na slajdzie?**

- A) Neo4j, Redis, Cassandra, MongoDB
- B) Neo4j, ArangoDB, OrientDB, JanusGraph
- C) HBase, ArangoDB, CouchDB, Neo4j
- D) JanusGraph, Riak, DynamoDB, OrientDB

<details><summary>Odpowiedź</summary>

**B** — na slajdzie są logotypy Neo4j, ArangoDB, OrientDB i JanusGraph. Redis, Cassandra, MongoDB, HBase, CouchDB, Riak i DynamoDB to inne rodziny NoSQL. (slajd 256)

</details>

**7.9. Który system zajmuje pierwsze miejsce w rankingu DB-Engines systemów grafowych pokazanym na wykładzie?**

- A) Microsoft Azure Cosmos DB
- B) Amazon Neptune
- C) Neo4j
- D) ArangoDB

<details><summary>Odpowiedź</summary>

**C** — linia Neo4j jest na samej górze wykresu przez cały okres 2014–2024; tuż pod nią jest Microsoft Azure Cosmos DB. (slajd 257)

</details>

**7.10. Jaką skalę ma oś Y wykresu DB-Engines Ranking of Graph DBMS na slajdzie?**

- A) Liniową w procentach
- B) Logarytmiczną
- C) Liniową w liczbie instalacji
- D) Kwadratową

<details><summary>Odpowiedź</summary>

**B** — oś Y to „Score (logarithmic scale)”, z wartościami od 0.001 do 10, więc różnice między systemami są w rzeczywistości większe, niż wyglądają. (slajd 257)

</details>

### Neo4j

**7.11. Jakim rodzajem bazy jest Neo4j?**

- A) Natywną bazą grafową
- B) Relacyjną bazą z rozszerzeniem grafowym
- C) Bazą dokumentową z indeksem grafowym
- D) Bazą rodziny kolumn

<details><summary>Odpowiedź</summary>

**A** — Neo4j to natywna baza grafowa, przechowująca dane jako węzły, relacje i etykiety. Rozszerzeniem grafowym bazy relacyjnej jest np. SQL Server Graph. (slajd 258)

</details>

**7.12. W jakiej postaci Neo4j przechowuje dane według infografiki?**

- A) Wierszy i kolumn
- B) Dokumentów BSON
- C) Rodzin kolumn
- D) Węzłów, relacji i etykiet

<details><summary>Odpowiedź</summary>

**D** — infografika mówi, że Neo4j przechowuje dane w postaci węzłów, relacji i etykiet; węzły i relacje mogą mieć właściwości. (slajd 258)

</details>

**7.13. Jak nazywa się język zapytań Neo4j?**

- A) Gremlin
- B) SPARQL
- C) Cypher
- D) CQL

<details><summary>Odpowiedź</summary>

**C** — Neo4j używa języka Cypher, podobnego do SQL, ale dostosowanego do grafów. Gremlin to język m.in. JanusGraph i Cosmos DB, SPARQL służy do RDF, a CQL to język Cassandry. (slajd 260)

</details>

**7.14. Które zdanie o języku Cypher jest zgodne z wykładem?**

- A) Jest podobny do SQL, ale dostosowany do pracy z grafami
- B) Jest dialektem JavaScriptu wykonywanym w przeglądarce
- C) Jest identyczny z T-SQL
- D) Nie pozwala filtrować danych klauzulą WHERE

<details><summary>Odpowiedź</summary>

**A** — slajd opisuje Cypher jako język podobny do SQL, ale dostosowany do grafów. Ma klauzulę WHERE, a z T-SQL nie jest identyczny. (slajd 260)

</details>

**7.15. Co oznacza zapis `(a:Osoba {imie: 'Jan'})` w Cypherze?**

- A) Relację typu Osoba o nazwie a
- B) Węzeł ze zmienną a, etykietą Osoba i właściwością imie równą 'Jan'
- C) Tabelę Osoba z kolumną a
- D) Indeks na właściwości imie

<details><summary>Odpowiedź</summary>

**B** — nawiasy okrągłe oznaczają węzeł, przed dwukropkiem stoi zmienna, po dwukropku etykieta, a w klamrach właściwości. Relacje zapisuje się w nawiasach kwadratowych. (slajd 258)

</details>

**7.16. Który zapis w Cypherze oznacza skierowaną relację typu ZNA od węzła a do węzła b?**

- A) `(a)<-[:ZNA]-(b)`
- B) `(a)-(:ZNA)->(b)`
- C) `(a)-[:ZNA]->(b)`
- D) `[a]-(:ZNA)->[b]`

<details><summary>Odpowiedź</summary>

**C** — relacja stoi w nawiasach kwadratowych między myślnikami, a grot `->` wskazuje kierunek do b. Wersja A ma odwrotny kierunek, a w B i D zamieniono nawiasy węzłów i relacji. (slajd 258)

</details>

**7.17. Na infografice jest zapytanie:**

```
MATCH (a:Osoba {imie: 'Jan'})-[:ZNA]->(b)
RETURN b.imie, b.nazwisko, b.od_kiedy;
```

**Co zwróci kolumna `b.od_kiedy`, jeśli relację utworzono jako `(a)-[:ZNA {od_kiedy: 2020}]->(b)`?**

- A) Wartość 2020
- B) Błąd składni
- C) Liczbę relacji ZNA
- D) null, bo od_kiedy jest właściwością relacji, a nie węzła b

<details><summary>Odpowiedź</summary>

**D** — od_kiedy zapisano na relacji ZNA, więc węzeł b go nie ma i Cypher zwróci null. Poprawnie: `-[r:ZNA]->` i `RETURN r.od_kiedy`. To błąd na slajdzie. (slajd 258)

</details>

**7.18. Które polecenie Cypher zmienia cenę produktu Laptop na 3200?**

- A) `MATCH (p:Produkt {nazwa: 'Laptop'}) SET p.cena = 3200 RETURN p;`
- B) `UPDATE Produkt SET cena = 3200 WHERE nazwa = 'Laptop';`
- C) `CREATE (p:Produkt {nazwa: 'Laptop', cena: 3200})`
- D) `MATCH (p:Produkt {nazwa: 'Laptop'}) DELETE p.cena = 3200`

<details><summary>Odpowiedź</summary>

**A** — w Cypherze najpierw MATCH znajduje węzeł, potem SET zmienia właściwość. UPDATE to składnia SQL, a CREATE utworzyłby nowy, drugi węzeł. (slajd 258)

</details>

**7.19. Co zwraca zapytanie z infografiki?**

```
MATCH (k:Klient)-[:KUPIŁ]->(p:Produkt)
WHERE k.imie = 'Anna'
RETURN p.nazwa, p.cena;
```

- A) Wszystkich klientów, którzy kupili produkt o nazwie Anna
- B) Nazwy i ceny produktów kupionych przez klienta o imieniu Anna
- C) Liczbę zakupów Anny
- D) Nowy węzeł Klient o imieniu Anna

<details><summary>Odpowiedź</summary>

**B** — wzorzec szuka relacji KUPIŁ od klienta do produktu, WHERE zawęża do Anny, a RETURN zwraca nazwę i cenę produktu. MATCH niczego nie tworzy. (slajd 258)

</details>

**7.20. Co zwraca wywołanie `date()` w poleceniu `CREATE (k)-[:KUPIŁ {data: date()}]->(p)`?**

- A) Datę utworzenia bazy
- B) Datę urodzenia klienta
- C) Bieżącą datę, zapisaną jako właściwość relacji KUPIŁ
- D) Bieżącą datę, zapisaną jako właściwość węzła p

<details><summary>Odpowiedź</summary>

**C** — `date()` bez argumentów zwraca dzisiejszą datę, a ponieważ stoi w klamrach relacji, staje się właściwością relacji KUPIŁ, nie węzła. (slajd 258)

</details>

**7.21. Która cecha NIE jest wymieniona na infografice jako najważniejsza cecha Neo4j?**

- A) Wysoka wydajność zapytań dzięki szybkiemu trawersowaniu relacji
- B) Zaawansowana analiza relacji
- C) Skalowalność
- D) Sztywny schemat tabel wymuszany kluczami obcymi

<details><summary>Odpowiedź</summary>

**D** — infografika wymienia model grafowy, wysoką wydajność zapytań, skalowalność, zaawansowaną analizę relacji i bogate możliwości zastosowań. Sztywny schemat z kluczami obcymi to cecha baz relacyjnych. (slajd 258)

</details>

**7.22. Jak infografika porównuje skalowanie Neo4j i baz relacyjnych?**

- A) Neo4j poziomo, bazy relacyjne głównie pionowo
- B) Neo4j pionowo, bazy relacyjne głównie poziomo
- C) Obie wyłącznie pionowo
- D) Obie wyłącznie poziomo

<details><summary>Odpowiedź</summary>

**A** — tabela na infografice podaje: Neo4j „Poziome”, bazy relacyjne „Głównie pionowe”. W praktyce Neo4j łatwo skaluje poziomo odczyty, a dzielenie samego grafu jest trudne. (slajd 258)

</details>

**7.23. Które zdanie z porównania Neo4j z bazami relacyjnymi jest zgodne z infografiką?**

- A) W Neo4j połączenia między danymi są złożone (JOIN), a w bazach relacyjnych naturalne
- B) Najlepszym zastosowaniem Neo4j są dane transakcyjne
- C) W Neo4j połączenia są naturalne i szybkie, a w bazach relacyjnych złożone (JOIN)
- D) Wydajność zapytań o relacje w Neo4j zależy od złożoności, a w bazach relacyjnych jest bardzo wysoka

<details><summary>Odpowiedź</summary>

**C** — według tabeli Neo4j ma naturalne i szybkie połączenia oraz bardzo wysoką wydajność zapytań o relacje, a bazy relacyjne potrzebują JOIN-ów. Dane transakcyjne to najlepsze zastosowanie baz relacyjnych. (slajd 258)

</details>

**7.24. Która z poniższych wad Neo4j pojawia się na infografice?**

- A) Brak obsługi właściwości na relacjach
- B) Mniejsza przydatność do transakcji masowych niż tradycyjne bazy relacyjne
- C) Brak możliwości tworzenia relacji skierowanych
- D) Brak własnego języka zapytań

<details><summary>Odpowiedź</summary>

**B** — wady to: słabość przy prostych danych tabelarycznych, wyższe wymagania sprzętowe przy bardzo dużych grafach, mniejsza przydatność do transakcji masowych i konieczność nauki Cyphera. Pozostałe odpowiedzi są fałszywe. (slajd 258)

</details>

**7.25. Do jakiego rodzaju danych Neo4j według infografiki NIE jest optymalny?**

- A) Do danych o złożonych powiązaniach
- B) Do sieci społecznościowych
- C) Do systemów rekomendacji
- D) Do prostych danych tabelarycznych

<details><summary>Odpowiedź</summary>

**D** — pierwsza wada z infografiki: Neo4j nie jest optymalny do prostych danych tabelarycznych. Pozostałe to jego mocne strony. (slajd 258)

</details>

**7.26. Jakie przykłady firm podaje wykład przy zastosowaniu baz grafowych w systemach rekomendacyjnych?**

- A) Netflix i Amazon
- B) Google i Microsoft
- C) Facebook i Twitter
- D) Uber i Airbnb

<details><summary>Odpowiedź</summary>

**A** — slajd o zastosowaniach podaje: „Rekomendacje: Systemy rekomendacyjne (np. Netflix, Amazon)”. (slajd 260)

</details>

**7.27. Jak wykład opisuje zastosowanie baz grafowych w analizie oszustw?**

- A) Szyfrowanie transakcji kluczem publicznym
- B) Wykrywanie oszustw finansowych poprzez analizę nieoczywistych połączeń
- C) Blokowanie kont po trzech nieudanych logowaniach
- D) Archiwizację logów transakcji w szeregach czasowych

<details><summary>Odpowiedź</summary>

**B** — slajd: „Analiza oszustw: Wykrywanie oszustw finansowych poprzez analizę nieoczywistych połączeń”. (slajd 260)

</details>

### Neo4j — podstawowe operacje w Cypherze

**7.28. Które polecenie tworzy w Neo4j węzeł z etykietą Person i właściwością name równą "John"?**

- A) `INSERT INTO Person (name) VALUES ("John")`
- B) `MATCH (n:Person {name: "John"})`
- C) `CREATE (n:Person {name: "John"})`
- D) `CREATE [n:Person {name: "John"}]`

<details><summary>Odpowiedź</summary>

**C** — węzeł tworzy CREATE z węzłem w nawiasach okrągłych. INSERT INTO to SQL, MATCH tylko wyszukuje, a nawiasy kwadratowe oznaczają relację. (slajd 261)

</details>

**7.29. Co tworzy polecenie `CREATE (a:Person)-[:FRIEND]->(b:Person)`?**

- A) Dwa nowe węzły Person i relację FRIEND od a do b
- B) Tylko relację FRIEND między istniejącymi węzłami a i b
- C) Tylko jeden węzeł Person z właściwością FRIEND
- D) Relację FRIEND w obu kierunkach

<details><summary>Odpowiedź</summary>

**A** — CREATE tworzy cały wzorzec: dwa nowe węzły i skierowaną relację. Żeby połączyć istniejące węzły, trzeba je najpierw znaleźć przez MATCH. (slajd 261)

</details>

**7.30. Które zapytanie wyszukuje węzły Person o imieniu John?**

- A) `SELECT * FROM Person WHERE name = "John"`
- B) `MATCH (n:Person) WHERE n.name = "John" RETURN n`
- C) `FIND (n:Person) WHERE n.name == "John"`
- D) `MATCH [n:Person] WHERE n.name = "John" RETURN n`

<details><summary>Odpowiedź</summary>

**B** — wyszukiwanie to MATCH, filtr WHERE, wynik RETURN. SELECT to SQL, FIND nie istnieje w Cypherze, a węzeł nie stoi w nawiasach kwadratowych. (slajd 261)

</details>

**7.31. Która klauzula Cypher służy do aktualizacji właściwości węzła, np. `n.age = 30`?**

- A) UPDATE
- B) MODIFY
- C) ALTER
- D) SET

<details><summary>Odpowiedź</summary>

**D** — aktualizacja w Cypherze to `SET n.age = 30`, poprzedzone MATCH. UPDATE, MODIFY i ALTER nie są klauzulami Cypher. (slajd 261)

</details>

**7.32. Co się stanie po wykonaniu `MATCH (n:Person) DELETE n`, jeśli węzły Person mają relacje z innymi węzłami?**

- A) Usunięte zostaną węzły i automatycznie ich relacje
- B) Usunięte zostaną tylko relacje, węzły zostaną
- C) Polecenie zakończy się błędem; do usunięcia węzłów z relacjami potrzebne jest `DETACH DELETE n`
- D) Usunięty zostanie tylko pierwszy znaleziony węzeł

<details><summary>Odpowiedź</summary>

**C** — Neo4j nie pozwala usunąć węzła, który ma relacje. DETACH DELETE najpierw usuwa relacje, a potem węzeł. Slajd pokazuje samo DELETE, bez tej uwagi. (slajd 261)

</details>

**7.33. Czym różni się MERGE od CREATE w Cypherze?**

- A) MERGE tworzy element tylko wtedy, gdy nie istnieje pasujący, a CREATE zawsze tworzy nowy
- B) MERGE usuwa duplikaty, a CREATE tworzy indeks
- C) MERGE działa tylko na relacjach, a CREATE tylko na węzłach
- D) Nie ma różnicy, to synonimy

<details><summary>Odpowiedź</summary>

**A** — MERGE najpierw szuka wzorca i tworzy go tylko w razie braku; CREATE tworzy zawsze, nawet duplikaty. MERGE nie ma na slajdzie, to wiedza o Cypherze. (slajd 261)

</details>

**7.34. Co zwróci poniższe zapytanie po utworzeniu danych ze slajdu (Anna, 30 lat, mieszka w Warszawie)?**

```
MATCH (p:Person)-[:LIVES_IN]->(c:City)
RETURN p.name, c.name
```

- A) Wiersz: 30, Warszawa
- B) Wiersz: Anna, Warszawa
- C) Wiersz: Warszawa, Anna
- D) Pusty wynik, bo relacja LIVES_IN jest skierowana od City do Person

<details><summary>Odpowiedź</summary>

**B** — relacja LIVES_IN biegnie od Anny do Warszawy, a RETURN zwraca najpierw imię osoby, potem nazwę miasta. (slajd 261)

</details>

**7.35. Które znaki w Cypherze otaczają relację, a które węzeł?**

- A) Relację nawiasy okrągłe, węzeł nawiasy kwadratowe
- B) Relację klamry, węzeł nawiasy okrągłe
- C) Relację nawiasy kwadratowe, węzeł klamry
- D) Relację nawiasy kwadratowe, węzeł nawiasy okrągłe

<details><summary>Odpowiedź</summary>

**D** — węzeł to `( )`, relacja to `[ ]` między myślnikami, a klamry `{ }` zawierają właściwości. (slajdy 258, 261)

</details>

### SQL Server Graph — architektura i tabele

**7.36. Co przedstawia diagram architektury SQL Graph z dokumentacji Microsoftu?**

- A) Baza danych zawiera graf, a graf jest kolekcją tabel węzłów lub krawędzi
- B) Graf zawiera wiele baz danych
- C) Tabela krawędzi zawiera tabele węzłów
- D) Graf jest osobnym plikiem poza bazą danych

<details><summary>Odpowiedź</summary>

**A** — diagram: Database –(Contains)→ Graph –(isCollectionOf)→ Node or Edge Table. (slajd 262)

</details>

**7.37. Które zdanie o właściwościach tabel w SQL Graph jest zgodne z diagramem architektury?**

- A) Tabela krawędzi musi mieć co najmniej jedną właściwość
- B) Tabela węzłów nie może mieć właściwości
- C) Tabela węzłów ma właściwości, a tabela krawędzi może je mieć albo nie
- D) Ani tabela węzłów, ani krawędzi nie mają właściwości

<details><summary>Odpowiedź</summary>

**C** — diagram mówi: „Node table has Properties” i „Edge table may or may not have Properties”. Przykład: `CREATE TABLE friendOf AS EDGE;` bez kolumn. (slajd 262)

</details>

**7.38. W której wersji SQL Server wprowadzono GraphTable (tabele węzłów i krawędzi)?**

- A) SQL Server 2012
- B) SQL Server 2016
- C) SQL Server 2017
- D) SQL Server 2022

<details><summary>Odpowiedź</summary>

**C** — slajd: „Wprowadzony w SQL Server 2017”. W wersji 2019 doszły m.in. SHORTEST_PATH i ograniczenia krawędzi. (slajd 263)

</details>

**7.39. Co według wykładu reprezentują wierzchołki (Nodes), a co krawędzie (Edges) w GraphTable?**

- A) Wierzchołki to relacje, krawędzie to obiekty
- B) Wierzchołki to obiekty, krawędzie to relacje pomiędzy obiektami
- C) Wierzchołki to indeksy, krawędzie to klucze obce
- D) Wierzchołki to bazy danych, krawędzie to tabele

<details><summary>Odpowiedź</summary>

**B** — slajd: wierzchołki reprezentują obiekty, krawędzie reprezentują relacje pomiędzy obiektami. (slajd 263)

</details>

**7.40. Która zaleta modelu grafowego jest wymieniona na slajdzie „Dlaczego GraphTable?”?**

- A) Wydajne zapytania do relacji o głębokości wielu poziomów
- B) Automatyczne szyfrowanie wszystkich kolumn
- C) Brak potrzeby definiowania jakichkolwiek tabel
- D) Wyższa wydajność operacji masowych na wszystkich wierszach

<details><summary>Odpowiedź</summary>

**A** — zalety to: naturalne odwzorowanie sieci społecznościowych, hierarchii i map połączeń, wydajne zapytania do relacji wielopoziomowych oraz elastyczność w reprezentacji danych powiązanych. (slajd 264)

</details>

**7.41. Które zdanie o kluczowych cechach GraphTable jest prawdziwe?**

- A) Każdy wierzchołek może mieć najwyżej 16 krawędzi
- B) GraphTable wymaga osobnego serwera Neo4j
- C) Istnieją trzy typy tabel: węzłów, krawędzi i ścieżek
- D) Nie ma ograniczeń na liczbę powiązań między wierzchołkami

<details><summary>Odpowiedź</summary>

**D** — slajd wymienia dwa typy tabel (wierzchołków i krawędzi), rozszerzenie T-SQL o MATCH oraz brak ograniczeń na liczbę powiązań między wierzchołkami. (slajd 265)

</details>

**7.42. Jakim rozszerzeniem języka T-SQL wykład ilustruje zapytania grafowe w SQL Server?**

- A) Klauzulą CONNECT BY
- B) Predykatem MATCH
- C) Klauzulą TRAVERSE
- D) Funkcją GRAPH_JOIN

<details><summary>Odpowiedź</summary>

**B** — T-SQL rozszerzono o specjalne zapytania grafowe, przede wszystkim MATCH. CONNECT BY to składnia hierarchiczna Oracle, a TRAVERSE i GRAPH_JOIN nie istnieją w T-SQL. (slajd 265)

</details>

**7.43. Na slajdzie jest przykład `SELECT * FROM People P, Friends F WHERE MATCH(P-(F)->P2);`. Co trzeba poprawić, żeby zapytanie było poprawne?**

- A) Zamienić `->` na `=>`
- B) Usunąć alias F z FROM
- C) Dodać `People P2` do klauzuli FROM
- D) Zamienić nawiasy okrągłe wokół F na kwadratowe

<details><summary>Odpowiedź</summary>

**C** — każdy alias użyty w MATCH musi być w FROM, a powtórzona tabela węzłów potrzebuje drugiego aliasu: `FROM People P, Friends F, People P2`. W SQL Server krawędź stoi w nawiasach okrągłych. (slajd 265)

</details>

**7.44. Które polecenie tworzy w SQL Server tabelę wierzchołków?**

- A) `CREATE TABLE Persons (ID INT PRIMARY KEY, Name NVARCHAR(100)) AS NODE;`
- B) `CREATE NODE TABLE Persons (ID INT PRIMARY KEY, Name NVARCHAR(100));`
- C) `CREATE TABLE Persons (ID INT PRIMARY KEY, Name NVARCHAR(100)) AS VERTEX;`
- D) `CREATE GRAPH Persons (ID INT, Name NVARCHAR(100)) NODE;`

<details><summary>Odpowiedź</summary>

**A** — tabelę węzłów tworzy zwykłe CREATE TABLE z klauzulą `AS NODE` na końcu. Słów CREATE NODE TABLE, AS VERTEX czy CREATE GRAPH T-SQL nie zna. (slajd 266)

</details>

**7.45. Które polecenie tworzy tabelę krawędzi Friendships z właściwością StartDate?**

- A) `CREATE TABLE Friendships (StartDate DATE, FromID INT, ToID INT) AS NODE;`
- B) `CREATE EDGE Friendships (StartDate DATE);`
- C) `CREATE TABLE Friendships (StartDate DATE) AS RELATION;`
- D) `CREATE TABLE Friendships (StartDate DATE) AS EDGE;`

<details><summary>Odpowiedź</summary>

**D** — tabela krawędzi to CREATE TABLE z `AS EDGE`. Kolumn wskazujących początek i koniec krawędzi nie deklaruje się, bo SQL Server dodaje `$from_id` i `$to_id` sam. (slajd 266)

</details>

**7.46. Jak w SQL Server zapisać wzajemną znajomość Alexa i Johna, pokazaną na rysunku dwiema strzałkami?**

- A) Jedną krawędzią z flagą BIDIRECTIONAL
- B) Dwiema krawędziami: od Alexa do Johna i od Johna do Alexa
- C) Jedną krawędzią bez kierunku, bo krawędzie w SQL Server są nieskierowane
- D) Jednym wierszem w tabeli węzłów z dwiema kolumnami

<details><summary>Odpowiedź</summary>

**B** — krawędzie w SQL Server są skierowane (`$from_id` → `$to_id`), więc relacja wzajemna to dwie krawędzie. Na rysunku pary Alex–John i John–Alice mają strzałki w obie strony. (slajd 266)

</details>

**7.47. Jaką pseudokolumnę ma tabela węzłów w SQL Server?**

- A) `$edge_id`
- B) `$from_id`
- C) `$node_id`
- D) `$to_id`

<details><summary>Odpowiedź</summary>

**C** — tabela węzłów ma `$node_id`. `$edge_id`, `$from_id` i `$to_id` to pseudokolumny tabeli krawędzi. (slajd 267)

</details>

**7.48. Jakie pseudokolumny ma tabela krawędzi w SQL Server?**

- A) `$node_id`, `$from_id`, `$to_id`
- B) `$edge_id`, `$source_id`, `$target_id`
- C) `$edge_id`, `$start_id`, `$end_id`
- D) `$edge_id`, `$from_id`, `$to_id`

<details><summary>Odpowiedź</summary>

**D** — tabela krawędzi ma `$edge_id` (identyfikator krawędzi) oraz `$from_id` i `$to_id` (węzły, które krawędź łączy). Nazw source/target i start/end SQL Server nie używa. (slajd 267)

</details>

**7.49. Co przechowują kolumny `$from_id` i `$to_id` w tabeli krawędzi?**

- A) Wartości `$node_id` węzła początkowego i końcowego krawędzi
- B) Wartości klucza głównego ID z tabeli węzłów
- C) Daty początku i końca relacji
- D) Numery wierszy w tabeli krawędzi

<details><summary>Odpowiedź</summary>

**A** — na slajdzie kolumny te mają podpis „Nodes that this edge connects” i zawierają identyfikatory węzłów, np. `{"type":"node","id":0}`. Daty, jak StartDate, to zwykłe właściwości krawędzi. (slajd 267)

</details>

**7.50. W jakim formacie wyświetlane są wartości pseudokolumn `$node_id` i `$edge_id`?**

- A) Jako liczby całkowite INT
- B) Jako tekst JSON, np. `{"type":"node","id":0}`
- C) Jako identyfikatory GUID
- D) Jako adres XML

<details><summary>Odpowiedź</summary>

**B** — slajd pokazuje wartości w postaci JSON, np. `{"type":"node","id":0}` i `{"type":"edge","id":0}`. Prawdziwy identyfikator zawiera też nazwę schematu i tabeli. (slajd 267)

</details>

**7.51. W tabeli krawędzi Friends ze slajdu są wiersze 0→1, 1→2 i 2→0, gdzie 0 to John, 1 to Mary, a 2 to Alice. Które zdanie jest prawdziwe?**

- A) Krawędzie tworzą cykl: John → Mary → Alice → John
- B) Mary nie ma żadnej krawędzi wychodzącej
- C) John ma dwie krawędzie wychodzące
- D) Wszystkie znajomości są wzajemne

<details><summary>Odpowiedź</summary>

**A** — krawędzie prowadzą od Johna do Mary, od Mary do Alice i od Alice do Johna, czyli tworzą cykl. Żadna para nie ma krawędzi powrotnej, więc znajomości nie są wzajemne. (slajd 267)

</details>

### GraphTable w praktyce — przykład z restauracjami

**7.52. Co zwraca zapytanie ze slajdu?**

```sql
SELECT Friend1.Name, Friend2.Name
FROM Persons Friend1, Friendships Rel, Persons Friend2
WHERE MATCH(Friend1-(Rel)->Friend2);
```

- A) Pary osób połączonych krawędzią Friendships od Friend1 do Friend2
- B) Wszystkie możliwe pary osób, niezależnie od krawędzi
- C) Osoby bez żadnych znajomych
- D) Błąd, bo tabela Persons występuje dwa razy

<details><summary>Odpowiedź</summary>

**A** — MATCH zwraca tylko pary, między którymi istnieje krawędź Friendships. Dwukrotne użycie Persons z różnymi aliasami jest wymagane, a nie błędne. (slajd 268)

</details>

**7.53. Która tabela krawędzi w przykładzie z restauracjami ma właściwość?**

- A) friendOf
- B) livesIn
- C) likes
- D) locatedIn

<details><summary>Odpowiedź</summary>

**C** — `CREATE TABLE likes (rating INTEGER) AS EDGE;` ma właściwość rating. friendOf, livesIn i locatedIn utworzono bez kolumn, np. `CREATE TABLE friendOf AS EDGE;`. (slajd 269)

</details>

**7.54. Które polecenie jest poprawną definicją tabeli krawędzi bez żadnych właściwości?**

- A) `CREATE TABLE friendOf () AS NODE;`
- B) `CREATE EDGE friendOf;`
- C) `CREATE TABLE friendOf AS EDGE;`
- D) `CREATE TABLE friendOf AS EDGE (NULL);`

<details><summary>Odpowiedź</summary>

**C** — tabela krawędzi może nie mieć kolumn użytkownika: `CREATE TABLE friendOf AS EDGE;` (tak jak livesIn i locatedIn). (slajd 269)

</details>

**7.55. Jak wstawia się dane do tabeli węzłów w SQL Server?**

- A) Tak jak do zwykłej tabeli, bez podawania `$node_id`
- B) Trzeba ręcznie podać `$node_id` w formacie JSON
- C) Tylko przez procedurę `sp_insert_node`
- D) Trzeba podać `$from_id` i `$to_id`

<details><summary>Odpowiedź</summary>

**A** — komentarz na slajdzie: „Inserting into a node table is same as inserting into a regular table”. `$node_id` generuje system. (slajd 270)

</details>

**7.56. Co trzeba podać przy wstawianiu wiersza do tabeli krawędzi?**

- A) Tylko wartości właściwości krawędzi
- B) Wartości `$node_id` węzłów dla kolumn `$from_id` i `$to_id`
- C) Wartość `$edge_id` w formacie JSON
- D) Zwykłe klucze ID węzłów, np. 1 i 2

<details><summary>Odpowiedź</summary>

**B** — komentarz na slajdzie: przy wstawianiu do tabeli krawędzi trzeba podać `$node_id` dla kolumn `$from_id` i `$to_id`. `$edge_id` generuje system, a zwykłe ID nie wystarczy. (slajd 271)

</details>

**7.57. Uzupełnij polecenie, które zapisuje, że osoba o ID 1 lubi restaurację o ID 1 z oceną 9:**

```sql
INSERT INTO likes
VALUES ((SELECT ____ FROM Person WHERE ID = 1),
        (SELECT ____ FROM Restaurant WHERE ID = 1), 9);
```

- A) `$from_id`
- B) `ID`
- C) `$edge_id`
- D) `$node_id`

<details><summary>Odpowiedź</summary>

**D** — podzapytania pobierają `$node_id` węzła osoby i restauracji, które trafiają do `$from_id` i `$to_id` krawędzi. (slajd 271)

</details>

**7.58. Co zwraca zapytanie ze slajdu?**

```sql
SELECT Restaurant.name
FROM Person, likes, Restaurant
WHERE MATCH (Person-(likes)->Restaurant)
      AND Person.name = 'John';
```

- A) Osoby, które lubią restaurację John
- B) Restauracje, które lubią przyjaciele Johna
- C) Restauracje, które lubi John
- D) Restauracje w mieście, w którym mieszka John

<details><summary>Odpowiedź</summary>

**C** — wzorzec Person → likes → Restaurant z warunkiem Person.name = 'John' zwraca restauracje lubiane przez Johna. (slajd 272)

</details>

**7.59. Które zapytanie zwraca restauracje lubiane przez przyjaciół Johna?**

- A) `... WHERE MATCH(person1-(friendOf)->person2-(likes)->Restaurant) AND person1.name='John'`
- B) `... WHERE MATCH(person1-(likes)->person2-(friendOf)->Restaurant) AND person1.name='John'`
- C) `... WHERE MATCH(person1-(friendOf)->Restaurant) AND person1.name='John'`
- D) `... WHERE MATCH(person1-(friendOf)->person2-(likes)->Restaurant) AND person2.name='John'`

<details><summary>Odpowiedź</summary>

**A** — od Johna (person1) przez friendOf do przyjaciela (person2), a od przyjaciela przez likes do restauracji. W D warunek dotyczy przyjaciela, a nie Johna, w B krawędzie są zamienione, a C pomija przyjaciela. (slajd 272)

</details>

**7.60. Jak w MATCH zapisano warunek „osoba lubi restaurację w tym samym mieście, w którym mieszka”?**

- A) Dwoma osobnymi klauzulami MATCH połączonymi OR
- B) Dwoma wzorcami w jednym MATCH, połączonymi AND i używającymi tych samych aliasów Person i City
- C) Podzapytaniem EXISTS z JOIN na kolumnie city
- D) Jednym wzorcem Person-(livesIn)->Restaurant

<details><summary>Odpowiedź</summary>

**B** — `MATCH (Person-(likes)->Restaurant-(locatedIn)->City AND Person-(livesIn)->City)`. Te same aliasy oznaczają tę samą osobę i to samo miasto. OR i NOT nie są w MATCH obsługiwane. (slajd 272)

</details>

**7.61. Ile razy tabela Person musi wystąpić w FROM w zapytaniu o restauracje lubiane przez przyjaciół Johna?**

- A) Raz, bo SQL Server sam rozróżni role
- B) Ani razu, wystarczy tabela friendOf
- C) Trzy razy
- D) Dwa razy, z różnymi aliasami (person1 i person2)

<details><summary>Odpowiedź</summary>

**D** — John i jego przyjaciel to dwa różne węzły tej samej tabeli, więc FROM ma `Person person1, Person person2`. (slajd 272)

</details>

**7.62. Które zdanie o tabeli krawędzi likes w przykładzie z restauracjami jest prawdziwe?**

- A) Może łączyć osobę z restauracją, a według diagramu także osobę z miastem
- B) Może łączyć tylko węzły z jednej tabeli
- C) Musi mieć kolumny FromPersonID i ToRestaurantID
- D) Nie może mieć właściwości

<details><summary>Odpowiedź</summary>

**A** — na diagramie Likes prowadzi z Person do Restaurant i z Person do City. Jedna tabela krawędzi może łączyć węzły z różnych tabel, bo `$from_id` i `$to_id` zawierają informację o tabeli węzła. likes ma właściwość rating. (slajd 269)

</details>

### Zastosowania i ograniczenia GraphTable

**7.63. Który obszar NIE został wymieniony na slajdzie „Zastosowania GraphTable”?**

- A) Analiza sieci społecznościowych
- B) Mapowanie tras i połączeń
- C) Przechowywanie plików binarnych BLOB
- D) Wykrywanie oszustw

<details><summary>Odpowiedź</summary>

**C** — slajd wymienia analizę sieci społecznościowych, mapowanie tras i połączeń, analizę powiązań biznesowych i wykrywanie oszustw. (slajd 274)

</details>

**7.64. Które z poniższych MOŻE być tabelą węzłów lub krawędzi w SQL Server?**

- A) Lokalna tabela tymczasowa `#Persons`
- B) Zmienna tabelowa `@Persons`
- C) Tabela zoptymalizowana pod kątem pamięci
- D) Zwykła tabela utworzona przez `CREATE TABLE ... AS NODE`

<details><summary>Odpowiedź</summary>

**D** — tabele tymczasowe lokalne i globalne, typy tabel, zmienne tabelowe i tabele zoptymalizowane pod kątem pamięci nie mogą być tabelami grafowymi. (slajd 275)

</details>

**7.65. Które zdanie o ograniczeniach tabel grafowych w SQL Server jest prawdziwe?**

- A) Tabele węzłów i krawędzi mogą być tabelami czasowymi z wersjonowaniem systemowym
- B) Tabel węzłów i krawędzi nie można tworzyć jako tabel czasowych z wersjonowaniem systemowym
- C) Tabele krawędzi muszą być zoptymalizowane pod kątem pamięci
- D) Globalne tabele tymczasowe mogą być tabelami krawędzi

<details><summary>Odpowiedź</summary>

**B** — slajd: tabel węzłów i krawędzi nie można tworzyć jako tabel czasowych z wersjonowaniem systemowym. Pozostałe zdania przeczą liście ograniczeń. (slajd 275)

</details>

**7.66. Jak zmienić węzeł docelowy istniejącej krawędzi, skoro slajd wymienia ograniczenie dotyczące `$to_id`?**

- A) `UPDATE likes SET $to_id = ...`
- B) `ALTER EDGE likes SET $to_id = ...`
- C) Usunąć krawędź przez DELETE i wstawić nową przez INSERT
- D) `UPDATE likes SET $edge_id = ...`

<details><summary>Odpowiedź</summary>

**C** — użytkownicy nie mogą aktualizować `$from_id` i `$to_id` instrukcją UPDATE, więc krawędź trzeba usunąć i wstawić ponownie. Zwykłe właściwości krawędzi, np. rating, można aktualizować. (slajd 275)

</details>

**7.67. Które zdanie o zapytaniach do obiektów grafowych w SQL Server jest zgodne ze slajdem o ograniczeniach?**

- A) Zapytania rozproszone dotyczące obiektów grafowych nie są obsługiwane
- B) Zapytania grafowe działają tylko przez połączony serwer (linked server)
- C) MATCH wymaga zapytania rozproszonego
- D) Pseudokolumny grafu można dowolnie aktualizować

<details><summary>Odpowiedź</summary>

**A** — slajd: zapytania rozproszone dotyczące obiektów grafowych nie są obsługiwane (w dokumentacji: cross-database queries). Na slajdzie jest słowo „graficznych”, chodzi o obiekty grafowe. (slajd 275)

</details>

**7.68. Do czego według slajdu NIE można użyć pseudokolumn grafu (`$node_id`, `$from_id`, `$to_id`, `$edge_id`)?**

- A) Do warunków złączenia w klauzuli WHERE
- B) W podzapytaniu przy INSERT do tabeli krawędzi
- C) W liście SELECT
- D) Jako kolumn sortowania dla uporządkowanego klastrowanego indeksu magazynu kolumn

<details><summary>Odpowiedź</summary>

**D** — ograniczenie dotyczy ordered clustered columnstore index. Pseudokolumn używa się w złączeniach (slajd 277), w podzapytaniach przy INSERT (slajd 271) i w SELECT. (slajd 275)

</details>

**7.69. Jaki typ krawędzi łączy Mary Jones i Andy'ego Smitha w grafie sieci zawodowej ze slajdu Microsoftu?**

- A) Employer
- B) Coworker
- C) Skill
- D) Former employer

<details><summary>Odpowiedź</summary>

**B** — krawędź Mary Jones → Andy Smith ma podpis „Coworker”. Employer łączy Adventure Works z obojgiem, Skill prowadzi do Statistics, a Former employer od Mary do Contoso. (slajd 276)

</details>

### MATCH kontra JOIN i rekomendacja utworów

**7.70. Jaką główną tezę ilustruje slajd „Match is more concise than joins”?**

- A) MATCH zawsze wykonuje się dziesięć razy szybciej niż JOIN
- B) MATCH działa tylko w Azure, a JOIN tylko w SQL Server
- C) MATCH zapisuje ten sam wzorzec zwięźlej niż seria warunków złączenia
- D) JOIN nie może używać pseudokolumn grafu

<details><summary>Odpowiedź</summary>

**C** — slajd pokazuje to samo zapytanie w dwóch wersjach; MATCH jest krótszy i czytelniejszy. O szybkości slajd nic nie mówi, a wersja z JOIN właśnie używa pseudokolumn. (slajd 277)

</details>

**7.71. Który warunek złączenia odpowiada w wersji z JOIN fragmentowi `person1-(manages)->person2`?**

- A) `person1.$node_id = manages.$from_id AND manages.$to_id = person2.$node_id`
- B) `person1.$node_id = manages.$to_id AND manages.$from_id = person2.$node_id`
- C) `person1.$edge_id = person2.$edge_id`
- D) `person1.ID = manages.ID AND manages.ID = person2.ID`

<details><summary>Odpowiedź</summary>

**A** — `$from_id` krawędzi wskazuje węzeł początkowy (person1), a `$to_id` węzeł końcowy (person2). Wersja B odwraca kierunek, a węzły nie mają `$edge_id`. (slajd 277)

</details>

**7.72. Ile warunków równości na pseudokolumnach zastępuje wzorzec `person1-(manages)->person2-(works_at)->location` w wersji z JOIN?**

- A) Dwa
- B) Trzy
- C) Pięć
- D) Cztery

<details><summary>Odpowiedź</summary>

**D** — każda krawędź daje dwa warunki (`$from_id` i `$to_id`), więc dwie krawędzie to cztery warunki; tyle ich jest na slajdzie, nie licząc filtrów na Johna i Seattle. (slajd 277)

</details>

**7.73. Który utwór system rekomendacji ze slajdu poleca użytkownikowi User1 i dlaczego?**

- A) Song5, bo User1 już go słuchał
- B) Song3, bo lubią go User3 i User4, którzy tak jak User1 lubią Song2
- C) Song4, bo lubi go User2
- D) Song1, bo lubi go User5

<details><summary>Odpowiedź</summary>

**B** — User1 lubi Song2; Song2 lubią też User3 i User4, a oni lubią Song3, więc Song3 trafia do rekomendacji (gruba fioletowa strzałka). To filtrowanie kolaboratywne. (slajd 278)

</details>

**7.74. Jak zbudowano model rekomendacji utworów w SQL Graph?**

- A) Jedna tabela węzłów UniqueUser i dwie tabele krawędzi UniqueSong i Likes
- B) Trzy tabele węzłów: UniqueUser, UniqueSong i Likes
- C) Tabele węzłów UniqueUser i UniqueSong oraz tabela krawędzi Likes
- D) Tabela krawędzi UniqueUser i tabele węzłów Likes i UniqueSong

<details><summary>Odpowiedź</summary>

**C** — UniqueUser i UniqueSong to tabele węzłów (AS NODE), a Likes to tabela krawędzi (AS EDGE) od użytkownika do utworu. (slajd 279)

</details>

**7.75. Jaką właściwość ma tabela krawędzi Likes w przykładzie rekomendacji utworów?**

- A) `ListenCount BIGINT`
- B) `Rating INTEGER`
- C) `SongTitle VARCHAR(500)`
- D) `UserId VARCHAR(80)`

<details><summary>Odpowiedź</summary>

**A** — `CREATE TABLE Likes (ListenCount BIGINT) AS EDGE`. SongTitle należy do UniqueSong, UserId do UniqueUser, a rating był w przykładzie z restauracjami. (slajd 279)

</details>

**7.76. Które polecenie tworzy tabelę utworów z przykładu rekomendacji?**

- A) `CREATE TABLE UniqueSong (SongId VARCHAR(50), SongTitle VARCHAR(500), ArtistName VARCHAR(500)) AS EDGE`
- B) `CREATE TABLE UniqueSong (SongId VARCHAR(50), SongTitle VARCHAR(500), ArtistName VARCHAR(500)) AS NODE`
- C) `CREATE NODE UniqueSong (SongId VARCHAR(50), SongTitle VARCHAR(500), ArtistName VARCHAR(500))`
- D) `CREATE TABLE UniqueSong (ListenCount BIGINT) AS NODE`

<details><summary>Odpowiedź</summary>

**B** — UniqueSong to tabela węzłów z kolumnami SongId, SongTitle i ArtistName, zakończona `AS NODE`. ListenCount to właściwość krawędzi Likes. (slajd 279)

</details>


## 8. Bazy rodziny kolumn — Apache Cassandra i CQL

### Bazy rodziny kolumn: model danych i zastosowania

**8.1. Jak wykład opisuje tabelę (rodzinę kolumn) w bazie rodziny kolumn?**

- A) Kolekcja podobnych wierszy, niekoniecznie identycznych
- B) Kolekcja wierszy o identycznym, sztywnym zestawie kolumn
- C) Kolekcja dokumentów BSON bez żadnego schematu
- D) Zbiór par klucz-wartość bez pojęcia wiersza

<details><summary>Odpowiedź</summary>

**A** — Rodzina kolumn to kolekcja podobnych, ale niekoniecznie identycznych wierszy; identyczne kolumny to cecha bazy relacyjnej. (slajd 281, 304)

</details>

**8.2. Co według wykładu powinien agregować pojedynczy wiersz w bazie rodziny kolumn?**

- A) Wszystkie dane jednej encji relacyjnej po normalizacji
- B) Dane jednej kolumny ze wszystkich partycji
- C) Porcję danych, która jest odczytywana (pozyskiwana) razem
- D) Wyłącznie wartości skalarne jednego typu

<details><summary>Odpowiedź</summary>

**C** — Wiersz to kolekcja kolumn, która powinna grupować dane odczytywane wspólnie. (slajd 281, 304)

</details>

**8.3. Z czego składa się kolumna w bazie rodziny kolumn?**

- A) Wyłącznie z wartości; nazwa jest przechowywana w schemacie
- B) Z nazwy kolumny i wartości (oraz potencjalnie innych metadanych)
- C) Z klucza partycji i tokenu
- D) Z identyfikatora wiersza i listy wartości

<details><summary>Odpowiedź</summary>

**B** — Kolumna to nazwa i wartość, a do tego mogą dochodzić metadane, np. TTL i timestamp. (slajd 304)

</details>

**8.4. Kiedy według wykładu NIE należy używać baz rodziny kolumn?**

- A) Przy blogach i systemach CMS
- B) Gdy trzeba przechowywać bardzo duże wolumeny danych
- C) Gdy wymagana jest skalowalność pozioma
- D) Gdy wymagane są transakcje ze ścisłą spójnością i złożone agregacje lub złączenia

<details><summary>Odpowiedź</summary>

**D** — Slajd wymienia: transakcje ze ścisłą spójnością, złożone zapytania (SUM, AVG, złączenia) oraz często zmieniany schemat. Blogi i CMS to przykład zastosowania. (slajd 281)

</details>

**8.5. Które zdanie o bazach rodziny kolumn jest zgodne z wykładem?**

- A) Nie są to po prostu bazy relacyjne ze zmienną specyfikacją wiersza
- B) To bazy relacyjne, w których wiersze mogą mieć różne kolumny
- C) Dobrze sprawdzają się, gdy schemat bazy często się zmienia
- D) Najlepiej nadają się do złożonych agregacji typu SUM i AVG

<details><summary>Odpowiedź</summary>

**A** — Slajd zawiera wprost uwagę, że to nie są bazy relacyjne ze zmienną specyfikacją wiersza. Częsta zmiana schematu jest na liście „kiedy nie używać”. (slajd 281)

</details>

**8.6. Która baza jest na pierwszym miejscu rankingu DB-Engines w kategorii Wide Column Stores pokazanego na wykładzie?**

- A) Apache HBase
- B) Microsoft Azure Cosmos DB
- C) Apache Cassandra
- D) ScyllaDB

<details><summary>Odpowiedź</summary>

**C** — Cassandra jest na szczycie z wynikiem ok. 100; HBase ma tendencję malejącą, Cosmos DB jest niżej. (slajd 282)

</details>

**8.7. Który z poniższych produktów NIE był wymieniony jako przedstawiciel baz rodziny kolumn?**

- A) ScyllaDB
- B) Redis
- C) Google Bigtable
- D) Apache HBase

<details><summary>Odpowiedź</summary>

**B** — Redis to baza klucz-wartość. Wśród przedstawicieli wymieniono Cassandrę, ScyllaDB, HBase, Bigtable i Cosmos DB z API Cassandry. (slajd 281)

</details>

### Apache Cassandra: cechy i architektura

**8.8. Jaka jest kolejność elementów w hierarchii Cassandry, od najmniejszego do największego?**

- A) Wiersz → keyspace → tabela → klaster
- B) Tabela → wiersz → keyspace → klaster
- C) Wiersz → tabela → klaster → keyspace
- D) Wiersz → tabela (column family) → keyspace → klaster

<details><summary>Odpowiedź</summary>

**D** — Rekord (wiersz) należy do tabeli, tabela do keyspace (przestrzeni nazw), a keyspace do klastra wielu węzłów. (slajd 284, 307)

</details>

**8.9. Jak zorganizowane są węzły w klastrze Cassandry?**

- A) Jeden węzeł master i wiele węzłów replik tylko do odczytu
- B) Węzły config server, router i shardy
- C) Równorzędne węzły peer-to-peer, bez pojedynczego punktu awarii
- D) Węzeł koordynujący na stałe przypisany do każdego centrum danych

<details><summary>Odpowiedź</summary>

**C** — Wszystkie węzły są równorzędne (peer-to-peer), co eliminuje pojedynczy punkt awarii. (slajd 284, 305)

</details>

**8.10. Która cecha NIE jest wymieniona na wykładzie jako cecha Cassandry?**

- A) Bardzo wysoka wydajność zapisu
- B) Silna spójność ACID dla wszystkich operacji
- C) Automatyczna replikacja danych między węzłami
- D) Skalowalność pozioma

<details><summary>Odpowiedź</summary>

**B** — Cassandra ma spójność konfigurowalną (tzw. eventual); silna spójność ACID to cecha baz relacyjnych w porównaniu ze slajdu. (slajd 284)

</details>

**8.11. Jak według porównania ze slajdu skalują się Cassandra i bazy relacyjne?**

- A) Cassandra poziomo, bazy relacyjne głównie pionowo
- B) Cassandra pionowo, bazy relacyjne poziomo
- C) Obie wyłącznie pionowo
- D) Obie wyłącznie poziomo

<details><summary>Odpowiedź</summary>

**A** — Cassandra dokłada serwery (skalowanie poziome), bazy relacyjne zwykle wzmacniają jeden serwer (pionowe). (slajd 284)

</details>

**8.12. Które z poniższych jest wymienione jako wada lub ograniczenie Cassandry?**

- A) Brak replikacji danych
- B) Niska wydajność zapisu
- C) Projekt zapytań trzeba planować przed tworzeniem tabel (denormalizacja)
- D) Pojedynczy punkt awarii w węźle master

<details><summary>Odpowiedź</summary>

**C** — Wady to: złożone modelowanie, ograniczony JOIN, słabość przy skomplikowanych transakcjach i konieczność projektowania zapytań przed tabelami. (slajd 284)

</details>

**8.13. Kto pierwotnie stworzył Apache Cassandrę?**

- A) Google
- B) Amazon
- C) LinkedIn
- D) Facebook

<details><summary>Odpowiedź</summary>

**D** — Cassandrę stworzył Facebook, a obecnie zarządza nią Apache Software Foundation. Google stworzył Bigtable, Amazon Dynamo. (slajd 305)

</details>

**8.14. W jakim języku jest zaimplementowana Cassandra i kiedy było jej pierwsze wydanie?**

- A) C++, 2010
- B) Java, 2008
- C) Erlang, 2009
- D) Java, 2012

<details><summary>Odpowiedź</summary>

**B** — Cassandra jest napisana w Javie, pierwsze wydanie w 2008 roku. (slajd 305)

</details>

**8.15. Który zestaw właściwości Cassandry podaje slajd?**

- A) Open-source, wysoka dostępność, skalowalność liniowa, sharding, replikacja peer-to-peer, regulowana spójność, wsparcie dla MapReduce
- B) Licencja komercyjna, architektura master-slave, silna spójność, brak replikacji
- C) Baza w pamięci, brak trwałości, pojedynczy węzeł, transakcje ACID
- D) Model dokumentowy, schemat dynamiczny, agregacje potokowe

<details><summary>Odpowiedź</summary>

**A** — To dokładna lista właściwości ze slajdu. (slajd 305)

</details>

**8.16. Które zdanie o modelu danych Cassandry jest prawdziwe według wykładu?**

- A) Cassandra w pełni wspiera relacyjne modelowanie danych
- B) Model danych jest oparty na zapytaniach i zoptymalizowany pod kątem zapytań
- C) Model danych jest najpierw normalizowany, a zapytania projektuje się później
- D) Cassandra nie używa tabel, tylko dokumentów

<details><summary>Odpowiedź</summary>

**B** — Model jest query-driven; Cassandra nie obsługuje relacyjnego modelowania danych. (slajd 306)

</details>

**8.17. Które zastosowanie NIE pojawia się na liście zastosowań Cassandry?**

- A) Internet rzeczy (IoT)
- B) Monitoring i telemetria
- C) Systemy księgowe wymagające złożonych transakcji wielotabelowych
- D) Gry online

<details><summary>Odpowiedź</summary>

**C** — Lista obejmuje aplikacje o dużym ruchu, mobilne, Big Data, social media, IoT, gry i telemetrię. Złożone transakcje to słaby punkt Cassandry. (slajd 284)

</details>

### Partycjonowanie: klucz partycji, token, Murmur3, pierścień

**8.18. Dlaczego Cassandra stosuje partycjonowanie danych?**

- A) Bo jeden serwer ma ograniczoną pamięć i dysk, łatwo go przeciążyć i daje niską dostępność
- B) Bo partycjonowanie umożliwia wykonywanie złączeń JOIN
- C) Bo zapewnia silną spójność ACID
- D) Bo eliminuje potrzebę replikacji

<details><summary>Odpowiedź</summary>

**A** — Slajd wymienia trzy problemy jednego serwera: ograniczona pamięć i dysk, przeciążenie, niska dostępność; rozwiązaniem jest podział danych na węzły. (slajd 286)

</details>

**8.19. Które z poniższych NIE jest celem partycjonowania danych w Cassandrze według wykładu?**

- A) Równomierne rozłożenie danych w klastrze
- B) Eliminacja wąskich gardeł
- C) Skalowanie poziome
- D) Umożliwienie zapytań ad-hoc po dowolnych kolumnach

<details><summary>Odpowiedź</summary>

**D** — Cele to równomierny rozkład, skalowanie poziome, eliminacja wąskich gardeł i wysoka dostępność. Zapytania ad-hoc Cassandra wręcz ogranicza. (slajd 287, 300)

</details>

**8.20. Jaka jest prawidłowa kolejność kroków przy umieszczaniu danych w klastrze Cassandry?**

- A) Węzeł → token → funkcja hash → klucz partycji
- B) Klucz partycji → węzeł → token → funkcja hash
- C) Klucz partycji → funkcja hash (np. Murmur3) → token → węzeł
- D) Token → klucz partycji → funkcja hash → węzeł

<details><summary>Odpowiedź</summary>

**C** — Cassandra nie przechowuje danych bezpośrednio według klucza: klucz jest haszowany do tokenu, a token wskazuje węzeł. (slajd 289)

</details>

**8.21. Które z poniższych NIE jest rolą klucza partycji według wykładu?**

- A) Identyfikuje partycję
- B) Określa kolejność wierszy wewnątrz partycji
- C) Określa położenie danych w klastrze
- D) Wpływa na wydajność całego systemu

<details><summary>Odpowiedź</summary>

**B** — Kolejność wierszy w partycji określa kolumna grupująca (clustering column), nie klucz partycji. (slajd 288, 292)

</details>

**8.22. Która kolumna jest kluczem partycji w tabeli poniżej?**

```sql
CREATE TABLE users (
  user_id UUID,
  login TEXT,
  email TEXT,
  PRIMARY KEY (user_id)
);
```

- A) `login`
- B) `email`
- C) `login` i `email` razem
- D) `user_id`

<details><summary>Odpowiedź</summary>

**D** — Klucz główny ma jedną kolumnę, więc jest ona kluczem partycji. (slajd 288)

</details>

**8.23. Jak nazywa się domyślny partycjoner Cassandry?**

- A) Murmur3Partitioner
- B) RandomPartitioner
- C) ByteOrderedPartitioner
- D) HashRangePartitioner

<details><summary>Odpowiedź</summary>

**A** — Domyślny jest Murmur3Partitioner. RandomPartitioner (MD5) i ByteOrderedPartitioner to starsze partycjonery; HashRangePartitioner nie istnieje. (slajd 290)

</details>

**8.24. Jakiej długości token generuje Murmur3Partitioner?**

- A) 32-bitowy
- B) 128-bitowy
- C) 64-bitowy
- D) 256-bitowy

<details><summary>Odpowiedź</summary>

**C** — Murmur3Partitioner generuje 64-bitowy token. (slajd 290)

</details>

**8.25. Jaki jest zakres tokenów przy Murmur3Partitioner?**

- A) od 0 do 2^64
- B) od −2^63 do +2^63 − 1
- C) od −2^31 do +2^31 − 1
- D) od 0 do 2^127

<details><summary>Odpowiedź</summary>

**B** — Zakres to −2^63 … +2^63 − 1, czyli zakres 64-bitowej liczby ze znakiem. (slajd 290)

</details>

**8.26. Które zdanie o funkcji Murmur3 jest prawdziwe?**

- A) To kryptograficzna funkcja skrótu używana do szyfrowania danych
- B) Zachowuje kolejność kluczy, dzięki czemu można robić zapytania zakresowe po kluczu partycji
- C) Generuje 128-bitowy identyfikator UUID
- D) To szybka, niekryptograficzna funkcja haszująca zapewniająca równomierny rozkład danych

<details><summary>Odpowiedź</summary>

**D** — Murmur3 jest szybka i niekryptograficzna; jej celem jest równomierny rozkład. Nie zachowuje kolejności kluczy. (slajd 290)

</details>

**8.27. Jakie ryzyko minimalizuje Murmur3Partitioner?**

- A) Data skew, czyli nierównomierny rozkład danych
- B) Utratę danych przy awarii dysku
- C) Konflikty zapisu między replikami
- D) Zbyt długie nazwy kolumn

<details><summary>Odpowiedź</summary>

**A** — Korzyść podana na slajdzie to minimalizacja ryzyka nierównomiernego rozkładu danych (data skew). (slajd 290)

</details>

**8.28. Które zdanie o pierścieniu tokenów (Token Ring) jest zgodne z wykładem?**

- A) Każdy token jest przypisany do wszystkich węzłów jednocześnie
- B) Pierścieniem zarządza centralny koordynator
- C) Każdy węzeł odpowiada za określony zakres tokenów, a pierścień nie ma centralnego koordynatora
- D) Dodanie nowego węzła wymaga zatrzymania klastra

<details><summary>Odpowiedź</summary>

**C** — Właściwości pierścienia: brak centralnego koordynatora, łatwe dodawanie węzłów, równomierne obciążenie. (slajd 291)

</details>

**8.29. Klaster ma węzły: Node A (tokeny 0–100), Node B (101–200), Node C (201–300). Rekord otrzymał token 145. Gdzie zostanie zapisany?**

- A) Na Node A
- B) Na Node B
- C) Na Node C
- D) Na wszystkich trzech węzłach jako partycja główna

<details><summary>Odpowiedź</summary>

**B** — 145 należy do zakresu 101–200, czyli Node B. (slajd 291)

</details>

**8.30. Co przedstawia partycja w schemacie z tabelą `user_id`, `event_time`, `activity`, gdzie `user_id` jest kluczem partycji?**

- A) Wszystkie wiersze o tej samej wartości `user_id`
- B) Wszystkie wiersze z tego samego dnia `event_time`
- C) Wszystkie wiersze o tej samej wartości `activity`
- D) Jeden pojedynczy wiersz tabeli

<details><summary>Odpowiedź</summary>

**A** — Partycja to wszystkie wiersze o tym samym kluczu partycji, tu `user_id`. (slajd 285, 292)

</details>

### Partycja, kolumny grupujące i złożony klucz partycji

**8.31. Za co odpowiada kolumna `timestamp` w kluczu `PRIMARY KEY (sensor_id, timestamp)`?**

- A) Określa węzeł, na którym leżą dane
- B) Jest drugą częścią klucza partycji
- C) Określa token partycji
- D) Jest kolumną grupującą i określa kolejność danych wewnątrz partycji

<details><summary>Odpowiedź</summary>

**D** — `sensor_id` to Partition Key (lokalizacja danych), a `timestamp` to Clustering Column (kolejność w partycji). (slajd 292)

</details>

**8.32. Co jest kluczem partycji w definicji poniżej?**

```sql
PRIMARY KEY ((customer_id, month), order_date)
```

- A) Tylko `customer_id`
- B) Para `customer_id` i `month`
- C) Wszystkie trzy kolumny
- D) Tylko `order_date`

<details><summary>Odpowiedź</summary>

**B** — Wewnętrzny nawias tworzy złożony klucz partycji (composite partition key); `order_date` jest kolumną grupującą. (slajd 293)

</details>

**8.33. Kiedy według wykładu stosuje się złożony klucz partycji (Composite Partition Key)?**

- A) Gdy jeden atrybut powoduje zbyt dużą partycję
- B) Gdy chcemy wykonać JOIN dwóch tabel
- C) Gdy tabela nie ma żadnych kolumn grupujących
- D) Gdy chcemy wyłączyć replikację

<details><summary>Odpowiedź</summary>

**A** — Composite Partition Key dzieli zbyt dużą partycję; korzyści to mniejsze partycje, lepszy rozkład i szybsze zapytania. (slajd 293)

</details>

**8.34. Dlaczego `PRIMARY KEY (sensor_type, timestamp)` z wartością `sensor_type = 'temperature'` jest na wykładzie przykładem złego projektu?**

- A) Bo `timestamp` nie może być kolumną grupującą
- B) Bo klucz partycji musi być typu UUID
- C) Bo miliony rekordów trafiają do jednej partycji
- D) Bo tabela nie ma klucza partycji

<details><summary>Odpowiedź</summary>

**C** — Klucz o niskiej kardynalności tworzy gigantyczną partycję (Bad Design). (slajd 293)

</details>

**8.35. Która z poniższych NIE jest konsekwencją zbyt dużej partycji według wykładu?**

- A) Przeciążony węzeł
- B) Długie odczyty
- C) Większe zużycie pamięci
- D) Utrata możliwości replikacji keyspace

<details><summary>Odpowiedź</summary>

**D** — Slajd podaje: przeciążony węzeł, długie odczyty, większe zużycie pamięci. Replikacja działa dalej. (slajd 293)

</details>

**8.36. Tabela ma klucz `PRIMARY KEY (sensor_id)` i rejestruje kolejne pomiary czujnika. Co się stanie przy zapisie drugiego pomiaru tego samego czujnika?**

- A) Zostanie dodany drugi wiersz w tej samej partycji
- B) Cassandra zgłosi błąd duplikatu klucza
- C) Pomiar trafi do nowej partycji z innym tokenem
- D) Nadpisze poprzedni pomiar, bo klucz główny jest ten sam

<details><summary>Odpowiedź</summary>

**D** — Wiersz identyfikuje cały klucz główny; bez kolumny grupującej (np. `timestamp`) czujnik ma tylko jeden wiersz, a INSERT działa jak upsert. Dlatego slajd stosuje `PRIMARY KEY (sensor_id, timestamp)`. (slajd 292, 344)

</details>

### Węzły wirtualne, rebalancing i dobre praktyki

**8.37. Czym są węzły wirtualne (vnodes)?**

- A) Węzłami, które przechowują tylko metadane klastra
- B) Mechanizmem, w którym fizyczny węzeł przechowuje wiele małych zakresów tokenów zamiast jednego dużego
- C) Kopiami zapasowymi węzłów w innym centrum danych
- D) Węzłami uruchomionymi w maszynach wirtualnych

<details><summary>Odpowiedź</summary>

**B** — Zamiast jednego dużego zakresu tokenów węzeł ma wiele małych (Token Range 1…N). (slajd 294)

</details>

**8.38. Od której wersji Cassandry według slajdu stosowane są vnodes?**

- A) Od Cassandry 2.x
- B) Od Cassandry 0.6
- C) Od Cassandry 4.x
- D) Od Cassandry 5.x

<details><summary>Odpowiedź</summary>

**A** — Tak podaje slajd. Uwaga: vnodes wprowadzono w wersji 1.2, a od 2.0 są domyślnie włączone. (slajd 294)

</details>

**8.39. Która z poniższych NIE jest korzyścią z vnodes według wykładu?**

- A) Prostsze skalowanie
- B) Szybsze rebalansowanie klastra
- C) Bardziej równomierne obciążenie
- D) Możliwość wykonywania złączeń między partycjami

<details><summary>Odpowiedź</summary>

**D** — Korzyści vnodes to prostsze skalowanie, szybsze rebalansowanie i równomierne obciążenie; JOIN w Cassandrze nie istnieje. (slajd 294)

</details>

**8.40. Jak nazywa się proces, w którym po dodaniu nowego węzła Cassandra automatycznie przenosi część tokenów i redystrybuuje dane?**

- A) Compaction
- B) Repair
- C) Rebalancing
- D) Sharding key reset

<details><summary>Odpowiedź</summary>

**C** — Slajd nazywa ten proces Rebalancing; przy tym system zachowuje dostępność. (slajd 294)

</details>

**8.41. Które z poniższych jest zaleceniem przy projektowaniu klucza partycji?**

- A) Wysoka kardynalność klucza i równomierny rozkład wartości
- B) Jak najmniejsza liczba różnych kluczy
- C) Projektowanie tabel jak w bazie relacyjnej
- D) Jak największe partycje, by ograniczyć liczbę odczytów

<details><summary>Odpowiedź</summary>

**A** — Zalecenia: wysoka kardynalność, równomierny rozkład, ograniczona wielkość partycji, modelowanie pod zapytania. Pozostałe odpowiedzi są na liście „unikać”. (slajd 295)

</details>

**8.42. Co według podsumowania wykładu jest najczęstszym problemem projektowym w Cassandrze?**

- A) Brak indeksów pomocniczych
- B) Hot Partition
- C) Zbyt wiele przestrzeni kluczy
- D) Za mały współczynnik replikacji

<details><summary>Odpowiedź</summary>

**B** — Podsumowanie: „Najczęstszy problem projektowy to Hot Partition”. (slajd 295)

</details>

**8.43. Od czego według wykładu przede wszystkim zależy wydajność systemu w Cassandrze?**

- A) Od mocy procesora węzłów
- B) Od liczby przestrzeni kluczy
- C) Od poprawnego zaprojektowania klucza partycji
- D) Od liczby indeksów pomocniczych

<details><summary>Odpowiedź</summary>

**C** — To hasło powtarza się na slajdach; wydajność zależy od modelu danych bardziej niż od sprzętu. (slajd 295, 303)

</details>

### Modelowanie danych: projektowanie od zapytań

**8.44. Co według wykładu projektuje się w Cassandrze najpierw?**

- A) Znormalizowany schemat tabel
- B) Indeksy pomocnicze
- C) Topologię klastra
- D) Zapytania, a dopiero później tabelę

<details><summary>Odpowiedź</summary>

**D** — „W Cassandrze najpierw projektuje się zapytania, a dopiero później tabelę.” (slajd 299)

</details>

**8.45. Które zestawienie SQL i Cassandry jest zgodne z wykładem?**

- A) SQL: denormalizacja; Cassandra: normalizacja
- B) SQL: zapytania → model danych; Cassandra: model danych → zapytania
- C) SQL: model danych → zapytania, normalizacja, JOIN; Cassandra: zapytania → model danych, denormalizacja, brak JOIN
- D) Obie bazy wspierają JOIN, ale Cassandra wolniej

<details><summary>Odpowiedź</summary>

**C** — Dokładnie tak wygląda tabela porównawcza na slajdzie. (slajd 299)

</details>

**8.46. Którego elementu NIE ma na liście rzeczy do określenia przed utworzeniem tabel (Query-Driven Design)?**

- A) Jakie dane będą odczytywane
- B) Jak często i po jakich polach będą wyszukiwane
- C) Jakie są wymagania wydajnościowe
- D) Jakie złączenia JOIN będą potrzebne

<details><summary>Odpowiedź</summary>

**D** — Lista: jakie dane, jak często, po jakich polach, jakie wymagania wydajnościowe. JOIN w Cassandrze nie ma. (slajd 299)

</details>

**8.47. Jaka jest kolejność procesu projektowania (Query-Driven Design) według wykładu?**

- A) Business Question → Query → Data Model → Table
- B) Table → Data Model → Query → Business Question
- C) Data Model → Table → Query → Business Question
- D) Query → Table → Business Question → Data Model

<details><summary>Odpowiedź</summary>

**A** — Pytanie biznesowe, zapytanie, model danych, tabela. (slajd 299)

</details>

**8.48. Czego Cassandra według wykładu NIE ogranicza?**

- A) JOIN
- B) GROUP BY na dużą skalę
- C) Szybkich zapisów dużych wolumenów danych
- D) Zapytań ad-hoc na wszystkich danych

<details><summary>Odpowiedź</summary>

**C** — Cassandra ogranicza JOIN, GROUP BY na dużą skalę, złożone relacje i zapytania ad-hoc; szybkie zapisy to jej mocna strona. (slajd 300)

</details>

**8.49. Wymaganie: „Pokaż wszystkie pomiary dla czujnika z ostatnich 24 godzin”. Które zapytanie odpowiada modelowi `PRIMARY KEY (sensor_id, timestamp)`?**

- A) `SELECT * FROM sensor_data WHERE timestamp >= ? AND timestamp <= ?;`
- B) `SELECT * FROM sensor_data WHERE sensor_id = ? AND timestamp >= ? AND timestamp <= ?;`
- C) `SELECT * FROM sensor_data WHERE value >= ?;`
- D) `SELECT * FROM sensor_data JOIN sensors ON sensor_id;`

<details><summary>Odpowiedź</summary>

**B** — Równość na kluczu partycji i zakres na kolumnie grupującej. A pomija klucz partycji, C filtruje po kolumnie spoza klucza, D używa JOIN. (slajd 300)

</details>

**8.50. Jak wykład definiuje denormalizację?**

- A) Celowe powielenie danych dla szybszych odczytów
- B) Usuwanie powtórzeń danych w celu oszczędności miejsca
- C) Rozbicie tabeli na mniejsze tabele połączone kluczami obcymi
- D) Zamianę kolekcji na typy natywne

<details><summary>Odpowiedź</summary>

**A** — „Denormalizacja to celowe powielenie danych dla szybszych odczytów.” Ta sama informacja może być w wielu tabelach. (slajd 301)

</details>

**8.51. Jaka zasada wynika z przykładu tabel `orders_by_customer`, `orders_by_status`, `orders_by_product`?**

- A) Jedna uniwersalna tabela powinna obsługiwać wszystkie zapytania
- B) Tabele należy łączyć przez JOIN po `order_id`
- C) Każda tabela obsługuje konkretny wzorzec odczytu; różne zapytania to różne tabele
- D) Nazwy tabel muszą zaczynać się od nazwy keyspace

<details><summary>Odpowiedź</summary>

**C** — „Różne zapytania = różne tabele. Nie ma jednej uniwersalnej tabeli.” (slajd 301)

</details>

**8.52. Pojawia się nowe ważne zapytanie `SELECT * FROM orders WHERE product_id = ?`, a `product_id` nie jest w kluczu tabeli. Co zwykle robi się w Cassandrze według wykładu?**

- A) Dodaje się do zapytania ALLOW FILTERING i problem jest rozwiązany
- B) Tworzy się nową tabelę `orders_by_product` zoptymalizowaną pod to zapytanie
- C) Zmienia się klucz główny istniejącej tabeli przez ALTER TABLE
- D) Łączy się tabele `orders` i `products` przez JOIN

<details><summary>Odpowiedź</summary>

**B** — „Nowe ważne zapytanie często oznacza nową tabelę.” ALLOW FILTERING to błąd modelowania, klucza głównego nie da się zmienić, a JOIN nie istnieje. (slajd 302)

</details>

**8.53. Który z poniższych NIE jest na liście najczęstszych błędów modelowania?**

- A) Używanie ALLOW FILTERING
- B) Niska kardynalność Partition Key
- C) Jedna tabela do wszystkiego
- D) Używanie kolumn grupujących do sortowania danych

<details><summary>Odpowiedź</summary>

**D** — Kolumny grupujące to dobra praktyka. Błędy to: projektowanie jak w Oracle, JOIN, ALLOW FILTERING, duże partycje, niska kardynalność, jedna tabela do wszystkiego. (slajd 302)

</details>

**8.54. Co ilustruje przykład partycji z kluczem `country = 'POLAND'`?**

- A) Hot Partition: przeciążenie, wolniejsze zapytania, hotspot
- B) Poprawny model e-commerce z małymi partycjami
- C) Użycie złożonego klucza partycji
- D) Działanie vnodes

<details><summary>Odpowiedź</summary>

**A** — To „zły model – Hot Partition”: cały ruch z jednego kraju trafia do jednej partycji. (slajd 298)

</details>

**8.55. Która zasada NIE należy do „5 zasad Data Modeling” z podsumowania wykładu?**

- A) Projektuj pod zapytania
- B) Normalizuj dane do trzeciej postaci normalnej
- C) Używaj Clustering Columns
- D) Unikaj dużych partycji

<details><summary>Odpowiedź</summary>

**B** — Pięć zasad: projektuj pod zapytania, dobierz właściwy Partition Key, używaj Clustering Columns, denormalizuj dane, unikaj dużych partycji. (slajd 298)

</details>

**8.56. Który krok w cyklu projektowania danych następuje bezpośrednio po wyborze klucza partycji?**

- A) Business Requirement
- B) Validation
- C) Określenie kolumn grupujących (Clustering Column)
- D) Query

<details><summary>Odpowiedź</summary>

**C** — Cykl: Business Requirement → Query → Partition Key → Clustering Column → Table → Validation. (slajd 303)

</details>

**8.57. Jakie trzy zalety ma dobry model `orders_by_customer` (customer_id, order_date, amount) według wykładu?**

- A) Silna spójność, transakcje, JOIN
- B) Małe zużycie dysku, brak duplikacji, normalizacja
- C) Dowolne zapytania ad-hoc, brak klucza, elastyczny schemat
- D) Szybki odczyt, dobra skalowalność, małe partycje

<details><summary>Odpowiedź</summary>

**D** — Tak opisuje go slajd „Dobry model – E-commerce”. (slajd 297)

</details>

### Model danych Cassandry: struktura, wartości, kolekcje, TTL i timestamp

**8.58. Które zdanie o schemacie tabeli w Cassandrze jest prawdziwe według wykładu?**

- A) Tabela nie ma schematu, jak kolekcja w MongoDB
- B) Schemat tabeli musi być podany, ale może być modyfikowany później
- C) Schemat tabeli jest ustalony na zawsze i nie da się dodać kolumny
- D) Każdy wiersz musi mieć wartość w każdej kolumnie

<details><summary>Odpowiedź</summary>

**B** — Schemat trzeba podać, ale można go zmieniać; wiersze nie muszą mieć tych samych kolumn. (slajd 307)

</details>

**8.59. Czemu odpowiada przestrzeń kluczy (keyspace) w Cassandrze?**

- A) Bazie danych
- B) Pojedynczej tabeli
- C) Partycji
- D) Indeksowi pomocniczemu

<details><summary>Odpowiedź</summary>

**A** — Slajd zawiera ramkę: „Przestrzeń kluczy = Baza danych”. Hierarchia: instancja → przestrzeń kluczy → tabele → wiersze → kolumny. (slajd 307, 316)

</details>

**8.60. Które wartości wykład zalicza do wartości atomowych kolumny?**

- A) Listy, zbiory i mapy
- B) Tylko liczby i teksty
- C) Natywne typy danych, krotki i typy definiowane przez użytkownika (UDT)
- D) Tylko null i boolean

<details><summary>Odpowiedź</summary>

**C** — Wartości atomowe: typy natywne, krotki, UDT. Listy, zbiory i mapy to osobna kategoria — kolekcje. (slajd 309)

</details>

**8.61. W jakim trybie mogą być zagnieżdżane krotki, UDT i kolekcje wewnątrz kolekcji?**

- A) static
- B) counter
- C) nested
- D) frozen

<details><summary>Odpowiedź</summary>

**D** — Zagnieżdżenia są dozwolone tylko w trybie frozen (wartość zapisywana i zmieniana w całości). (slajd 309)

</details>

**8.62. Które zdanie o kolekcjach w Cassandrze jest prawdziwe?**

- A) Zbiór jest nieuporządkowany, a lista posortowana alfabetycznie
- B) Lista jest uporządkowana pozycyjnie i dopuszcza duplikaty; zbiór ma unikalne wartości wewnętrznie uporządkowane
- C) Mapa dopuszcza powtarzające się klucze
- D) Lista wymaga unikalnych wartości

<details><summary>Odpowiedź</summary>

**B** — Lista: porządek pozycyjny, wartości nie muszą być unikalne. Zbiór: unikalne, wewnętrznie uporządkowane. Mapa: unikalne klucze, uporządkowana po kluczach. (slajd 310)

</details>

**8.63. Według czego są wewnętrznie uporządkowane pary w mapie?**

- A) Według kluczy
- B) Według wartości
- C) Według kolejności wstawiania
- D) Nie są uporządkowane

<details><summary>Odpowiedź</summary>

**A** — Pary mapy są wewnętrznie uporządkowane na podstawie kluczy, a klucze muszą być unikalne. (slajd 310)

</details>

**8.64. W tabeli `aktorzy` wartość kolumny `filmy` to `{ 'Rambo', 'Niezniszczalni' }`, a kolumny `dane` to `( 'S', 'Stallone' )`. Jakie to typy?**

- A) `filmy` to lista, `dane` to mapa
- B) `filmy` to mapa, `dane` to UDT
- C) `filmy` to zbiór, `dane` to krotka
- D) `filmy` to krotka, `dane` to zbiór

<details><summary>Odpowiedź</summary>

**C** — Klamry z samymi wartościami to zbiór (`SET<TEXT>`), nawiasy okrągłe to krotka (`TUPLE<TEXT, TEXT>`). (slajd 311, 319)

</details>

**8.65. Co oznacza literał `{ dlugosc: 100 }` w kolumnie `wlasciwosci` tabeli `filmy`?**

- A) Mapę z kluczem tekstowym `dlugosc`
- B) Zbiór z jednym elementem
- C) Krotkę z jedną wartością
- D) Wartość typu definiowanego przez użytkownika (UDT) z polem `dlugosc`

<details><summary>Odpowiedź</summary>

**D** — Nazwa pola bez apostrofów przed dwukropkiem to literał UDT (typ `szczegoly`). Klucz mapy byłby w apostrofach, np. `{ 'dlugosc': 100 }`. (slajd 312, 331)

</details>

**8.66. Co dzieje się z kolumną lub elementem kolekcji po upływie TTL (Time-to-live)?**

- A) Zostaje automatycznie zniszczony (usunięty)
- B) Zostaje przeniesiony do archiwum
- C) Zostaje oznaczony jako tylko do odczytu
- D) Jego timestamp jest zerowany

<details><summary>Odpowiedź</summary>

**A** — Po określonej liczbie sekund kolumna lub element jest automatycznie niszczony. (slajd 313)

</details>

**8.67. Które zdanie o metadanych (TTL i timestamp) jest zgodne z wykładem?**

- A) Timestamp może być nadawany wyłącznie automatycznie
- B) TTL wyrażany jest w milisekundach
- C) Metadane mogą być przedmiotem zapytań, ale nie dotyczy to kolekcji i ich elementów
- D) Metadane dotyczą tylko całych wierszy, nigdy pojedynczych kolumn

<details><summary>Odpowiedź</summary>

**C** — Metadane dotyczą kolumny albo pojedynczego elementu kolekcji; można o nie pytać, ale nie dla kolekcji. Timestamp może być nadany automatycznie lub ręcznie, a TTL jest w sekundach. (slajd 313)

</details>

**8.68. Co zwraca wyrażenie `toTimeStamp(now())` użyte w INSERT na slajdzie z tabelą `shopping_cart`?**

- A) Liczbę sekund od uruchomienia klastra
- B) Bieżący czas jako wartość typu timestamp
- C) Losowy UUID wersji 4
- D) Czas wygaśnięcia wiersza (TTL)

<details><summary>Odpowiedź</summary>

**B** — `now()` zwraca bieżący timeuuid, a `toTimeStamp` zamienia go na timestamp; wartość trafia do `last_update_timestamp`. (slajd 308)

</details>

### Narzędzia i język CQL

**8.69. Czym jest cqlsh?**

- A) Sterownikiem Javy do Cassandry
- B) Graficznym narzędziem do monitorowania klastra
- C) Partycjonerem danych
- D) Interaktywną konsolą do wydawania komend w języku CQL

<details><summary>Odpowiedź</summary>

**D** — CQLSH to interaktywna konsola (`bin/cqlsh`) wykorzystująca CQL. (slajd 314)

</details>

**8.70. Co oznacza skrót CQL i jaki to język?**

- A) Cassandra Query Language; deklaratywny język zapytań zainspirowany przez SQL
- B) Column Query Language; proceduralny język skryptowy
- C) Cluster Query Language; język konfiguracji węzłów
- D) Cassandra Query Language; język oparty na JavaScript, jak mongosh

<details><summary>Odpowiedź</summary>

**A** — CQL = Cassandra Query Language, deklaratywny, inspirowany SQL. (slajd 315)

</details>

**8.71. Które polecenia CQL wykład zalicza do wyrażeń DDL?**

- A) SELECT i INSERT
- B) UPDATE i DELETE
- C) CREATE KEYSPACE i CREATE TABLE
- D) INSERT i CREATE TABLE

<details><summary>Odpowiedź</summary>

**C** — DDL: CREATE KEYSPACE, CREATE TABLE. DML: SELECT, INSERT, UPDATE, DELETE. (slajd 315)

</details>

**8.72. Kto dostarcza sterowniki klienckie do Cassandry według wykładu?**

- A) Wyłącznie Apache Software Foundation, tylko dla Javy
- B) Społeczność, dla wielu języków (Java, Python, Ruby, PHP, C++, Scala, Erlang i inne)
- C) Wyłącznie Facebook
- D) Sterowniki nie istnieją, jedyną drogą jest cqlsh

<details><summary>Odpowiedź</summary>

**B** — Sterowniki są dostarczone przez społeczność i dostępne dla wielu języków. (slajd 314)

</details>

### DDL: przestrzeń kluczy i replikacja

**8.73. Która opcja jest obowiązkowa przy `CREATE KEYSPACE`?**

- A) `durable_writes`
- B) `replication`
- C) `clustering_order`
- D) `default_time_to_live`

<details><summary>Odpowiedź</summary>

**B** — Opcja replication jest obowiązkowa. (slajd 316)

</details>

**8.74. Które polecenie poprawnie tworzy przestrzeń kluczy z trzema replikami w jednym centrum danych?**

- A) `CREATE KEYSPACE filmydb WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 3}`
- B) `CREATE DATABASE filmydb WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 3}`
- C) `CREATE KEYSPACE filmydb replication ('SimpleStrategy', 3)`
- D) `CREATE KEYSPACE filmydb WITH replication = ['SimpleStrategy', 3]`

<details><summary>Odpowiedź</summary>

**A** — Składnia: CREATE KEYSPACE nazwa WITH replication = mapa w klamrach. CREATE DATABASE nie istnieje w CQL, a opcja replication jest mapą, nie listą. (slajd 316)

</details>

**8.75. Czym różni się NetworkTopologyStrategy od SimpleStrategy?**

- A) NetworkTopologyStrategy wyłącza replikację
- B) SimpleStrategy pozwala ustawić osobny współczynnik replikacji dla każdego centrum danych
- C) NetworkTopologyStrategy pozwala ustawić indywidualny poziom replikacji dla każdego centrum danych
- D) Nie różnią się, to synonimy

<details><summary>Odpowiedź</summary>

**C** — SimpleStrategy ma tylko jeden poziom replikacji; NetworkTopologyStrategy — osobny dla każdego centrum danych. (slajd 316)

</details>

**8.76. Do czego służy polecenie `USE filmydb`?**

- A) Tworzy przestrzeń kluczy `filmydb`
- B) Usuwa przestrzeń kluczy `filmydb`
- C) Zmienia opcje replikacji `filmydb`
- D) Zmienia aktualnie używaną przestrzeń kluczy na `filmydb`

<details><summary>Odpowiedź</summary>

**D** — USE zmienia aktualną przestrzeń kluczy. (slajd 317)

</details>

**8.77. Co robi `DROP KEYSPACE`?**

- A) Usuwa przestrzeń kluczy wraz ze wszystkimi jej tabelami i danymi
- B) Usuwa tylko dane, zachowując tabele
- C) Usuwa tylko puste tabele
- D) Wyłącza replikację przestrzeni kluczy

<details><summary>Odpowiedź</summary>

**A** — DROP KEYSPACE usuwa przestrzeń kluczy, wszystkie jej tabele i dane. (slajd 317)

</details>

**8.78. Które polecenie służy do modyfikacji opcji (np. replikacji) istniejącej przestrzeni kluczy?**

- A) `UPDATE KEYSPACE`
- B) `ALTER KEYSPACE`
- C) `MODIFY KEYSPACE`
- D) `SET KEYSPACE`

<details><summary>Odpowiedź</summary>

**B** — ALTER KEYSPACE modyfikuje opcje przestrzeni kluczy. (slajd 317)

</details>

### DDL: tabele i klucze główne

**8.79. Ile kluczy głównych musi mieć tabela w Cassandrze?**

- A) Co najmniej dwa
- B) Zero lub jeden
- C) Dokładnie jeden
- D) Dowolną liczbę

<details><summary>Odpowiedź</summary>

**C** — Każda tabela musi mieć dokładnie 1 klucz główny; poza nim żadna kolumna nie jest wymagana. (slajd 318)

</details>

**8.80. Z jakich części składa się klucz główny w Cassandrze?**

- A) Z obowiązkowego klucza partycjonującego i opcjonalnych kolumn grupujących
- B) Z opcjonalnego klucza partycjonującego i obowiązkowych kolumn grupujących
- C) Z klucza obcego i klucza kandydującego
- D) Z tokenu i timestampu

<details><summary>Odpowiedź</summary>

**A** — Klucz partycjonujący (min. 1 kolumna) jest obowiązkowy, kolumny grupujące są opcjonalne. (slajd 320)

</details>

**8.81. Co oznacza definicja klucza głównego na poziomie kolumny, np. `id TEXT PRIMARY KEY`?**

- A) `id` staje się kolumną grupującą, a kluczem partycji jest token
- B) `id` jest kluczem partycjonującym, a pozostałe kolumny automatycznie stają się kolumnami grupującymi
- C) Tabela ma złożony klucz partycji
- D) `id` staje się kluczem partycjonującym i nie ma kolumn grupujących

<details><summary>Odpowiedź</summary>

**D** — Definicja na poziomie kolumny: ta pojedyncza kolumna jest kluczem partycjonującym, bez kolumn grupujących. (slajd 320)

</details>

**8.82. Jakie role pełnią kolumny w `PRIMARY KEY (a, b, c)`?**

- A) `a`, `b`, `c` razem tworzą klucz partycji
- B) `a` jest kluczem partycji, `b` i `c` są kolumnami grupującymi
- C) `a` i `b` tworzą klucz partycji, `c` jest kolumną grupującą
- D) `c` jest kluczem partycji, `a` i `b` są kolumnami grupującymi

<details><summary>Odpowiedź</summary>

**B** — Bez wewnętrznego nawiasu kluczem partycji jest tylko pierwsza kolumna, reszta to kolumny grupujące. (slajd 321)

</details>

**8.83. W jakich nawiasach zapisuje się złożony klucz partycji w definicji klucza głównego?**

- A) W nawiasach klamrowych `{ }`
- B) W nawiasach kwadratowych `[ ]`
- C) W wewnętrznych nawiasach okrągłych `( )`
- D) W nawiasach ostrych `< >`

<details><summary>Odpowiedź</summary>

**C** — Np. `PRIMARY KEY ((a, b), c)`. Slajd 321 mówi „w nawiasach klamrowych”, ale to błąd — w składni (diagram i przykład na slajdach 293 i 320) są nawiasy okrągłe; klamry oznaczają zbiory, mapy i UDT. (slajd 321)

</details>

**8.84. Co robi klauzula w definicji tabeli poniżej?**

```sql
CREATE TABLE IF NOT EXISTS store.shopping_cart (
  userid TEXT, item_count INT, last_update_timestamp TIMESTAMP,
  PRIMARY KEY ((userid), last_update_timestamp)
) WITH CLUSTERING ORDER BY (last_update_timestamp DESC);
```

- A) Sortuje partycje na pierścieniu malejąco po tokenie
- B) Ustala malejący porządek przechowywania wierszy w partycji według `last_update_timestamp`
- C) Tworzy indeks pomocniczy na `last_update_timestamp`
- D) Ustawia TTL dla kolumny `last_update_timestamp`

<details><summary>Odpowiedź</summary>

**B** — WITH CLUSTERING ORDER BY ustala kierunek sortowania kolumny grupującej w partycji; tu najnowsze wpisy są pierwsze. (slajd 320)

</details>

**8.85. Czym różni się `TRUNCATE` od `DROP TABLE`?**

- A) TRUNCATE usuwa tabelę wraz z danymi, DROP TABLE tylko dane
- B) Oba usuwają tylko dane
- C) TRUNCATE usuwa przestrzeń kluczy
- D) TRUNCATE zachowuje tabelę, ale usuwa jej dane; DROP TABLE usuwa tabelę wraz z danymi

<details><summary>Odpowiedź</summary>

**D** — Po DROP TABLE tabeli nie ma, po TRUNCATE tabela zostaje pusta. (slajd 322)

</details>

**8.86. Które polecenie umożliwia zmianę, dodanie bądź usunięcie kolumn tabeli?**

- A) `ALTER TABLE`
- B) `UPDATE TABLE`
- C) `MODIFY TABLE`
- D) `CREATE OR REPLACE TABLE`

<details><summary>Odpowiedź</summary>

**A** — ALTER TABLE zmienia, dodaje lub usuwa kolumny (kolumn klucza głównego nie da się zmienić). (slajd 322)

</details>

**8.87. Które zdanie o kolumnach tabeli w Cassandrze jest prawdziwe?**

- A) Wszystkie kolumny są wymagane przy INSERT
- B) Żadna z kolumn nie jest wymagana, poza kluczem głównym
- C) Wymagane są kolumny klucza głównego i wszystkie kolekcje
- D) Kolumny typu TEXT są zawsze wymagane

<details><summary>Odpowiedź</summary>

**B** — Poza kluczem głównym żadna kolumna nie jest wymagana. (slajd 318)

</details>

### Typy danych

**8.88. Ile bajtów zajmują kolejno typy `tinyint`, `smallint`, `int`, `bigint`?**

- A) 1, 2, 4, 8
- B) 2, 4, 8, 16
- C) 1, 2, 3, 4
- D) 4, 4, 8, 8

<details><summary>Odpowiedź</summary>

**A** — To liczby całkowite ze znakiem na 1, 2, 4 i 8 bajtach. (slajd 324)

</details>

**8.89. Który typ jest liczbą rzeczywistą, a nie całkowitą?**

- A) `varint`
- B) `bigint`
- C) `decimal`
- D) `counter`

<details><summary>Odpowiedź</summary>

**C** — `decimal` to liczba rzeczywista; `varint`, `bigint` i `counter` to liczby całkowite. Slajd opisuje `varint` i `decimal` jako typy „o ustalonej precyzji”, a dokumentacja Cassandry — jako typy o dowolnej (zmiennej) precyzji. (slajd 324)

</details>

**8.90. Ile bajtów mają typy `float` i `double`?**

- A) 2 i 4
- B) 8 i 16
- C) 4 i 4
- D) 4 i 8

<details><summary>Odpowiedź</summary>

**D** — float to 4 B, double to 8 B. (slajd 324)

</details>

**8.91. Jak zapisuje się literał tekstowy w CQL?**

- A) W cudzysłowie podwójnym: `"Jan"`
- B) W pojedynczych apostrofach: `'Jan'`
- C) W backtickach: `` `Jan` ``
- D) Bez żadnych znaków ograniczających

<details><summary>Odpowiedź</summary>

**B** — Tekst wyraża się w pojedynczych apostrofach, nie w cudzysłowie (cudzysłów służy do identyfikatorów). (slajd 325)

</details>

**8.92. Jakie kodowanie wykorzystują typy `text` i `varchar`?**

- A) UTF-8
- B) ASCII
- C) UTF-16
- D) Latin-2

<details><summary>Odpowiedź</summary>

**A** — text i varchar to UTF-8; osobny typ ascii używa kodowania ASCII. (slajd 325)

</details>

**8.93. Które zdanie o typie `counter` jest prawdziwe?**

- A) Można mu ustawić dowolną wartość przez `SET licznik = 100`
- B) Może być częścią klucza głównego
- C) Wspiera tylko inkrementację i dekrementację
- D) Wspiera TTL

<details><summary>Odpowiedź</summary>

**C** — counter (8 B ze znakiem) wspiera tylko inkrementację i dekrementację; nie może być w kluczu głównym i nie wspiera TTL. (slajd 326)

</details>

**8.94. Która restrykcja dotyczy liczników (`counter`)?**

- A) Tabela może mieć najwyżej jeden licznik
- B) Albo wszystkie kolumny poza kluczem głównym są licznikami, albo żadna
- C) Licznik musi mieć ustawiony TTL
- D) Licznik musi być kolumną grupującą

<details><summary>Odpowiedź</summary>

**B** — Liczników nie miesza się ze zwykłymi kolumnami spoza klucza głównego. (slajd 326)

</details>

**8.95. Który typ przechowuje adres IP (IPv4 i IPv6)?**

- A) `blob`
- B) `uuid`
- C) `ascii`
- D) `inet`

<details><summary>Odpowiedź</summary>

**D** — inet to adres IP; blob to dowolne dane binarne, uuid to identyfikator. (slajd 326)

</details>

**8.96. Jak wygląda deklaracja typu krotki i jej literał?**

- A) Deklaracja `TUPLE<TEXT, TEXT>`, literał `( 'Numer', '123-456-789' )`
- B) Deklaracja `TUPLE(TEXT, TEXT)`, literał `[ 'Numer', '123-456-789' ]`
- C) Deklaracja `TUPLE{TEXT, TEXT}`, literał `{ 'Numer', '123-456-789' }`
- D) Deklaracja `ROW<TEXT, TEXT>`, literał `( 'Numer': '123-456-789' )`

<details><summary>Odpowiedź</summary>

**A** — TUPLE z typami w nawiasach ostrych, literał w nawiasach okrągłych. (Na slajdzie tytuł ma literówkę „Kropki”.) (slajd 327)

</details>

**8.97. Który literał jest poprawnym literałem listy?**

- A) `{ 'komedia', 'dramat' }`
- B) `( 'komedia', 'dramat' )`
- C) `[ 'komedia', 'dramat' ]`
- D) `< 'komedia', 'dramat' >`

<details><summary>Odpowiedź</summary>

**C** — Lista: nawiasy kwadratowe. Klamry to zbiór, okrągłe to krotka. (slajd 329)

</details>

**8.98. Jak zadeklarować kolumnę `aktorzy` jako mapę z tekstowymi kluczami i wartościami?**

- A) `aktorzy MAP{TEXT: TEXT}`
- B) `aktorzy SET<TEXT, TEXT>`
- C) `aktorzy LIST<TEXT, TEXT>`
- D) `aktorzy MAP<TEXT, TEXT>`

<details><summary>Odpowiedź</summary>

**D** — MAP z dwoma typami (klucz, wartość) w nawiasach ostrych. (slajd 319, 330)

</details>

**8.99. Jak rozpoznać, czy literał w klamrach to zbiór, czy mapa?**

- A) Mapa ma pary `klucz : wartość`, zbiór ma same wartości
- B) Zbiór ma pary `klucz : wartość`, mapa same wartości
- C) Mapa zawsze ma wartości liczbowe
- D) Nie da się rozpoznać, oba zapisy są identyczne

<details><summary>Odpowiedź</summary>

**A** — Np. `{ 'rezyser': 'Sylwester Stallone' }` to mapa, a `{ 'Niezniszczalni', 'Rambo' }` to zbiór. (slajd 328, 330)

</details>

**8.100. Które polecenie tworzy typ definiowany przez użytkownika?**

- A) `CREATE UDT szczegoly ( dlugosc SMALLINT, adnotacja TEXT )`
- B) `CREATE TYPE szczegoly ( dlugosc SMALLINT, adnotacja TEXT )`
- C) `CREATE TYPE szczegoly { dlugosc: SMALLINT, adnotacja: TEXT }`
- D) `CREATE TABLE TYPE szczegoly ( dlugosc SMALLINT, adnotacja TEXT )`

<details><summary>Odpowiedź</summary>

**B** — CREATE TYPE nazwa i w nawiasie okrągłym pola z typami. (slajd 331)

</details>

**8.101. Czym różni się krotka od typu definiowanego przez użytkownika (UDT)?**

- A) Krotka może być zmieniana pole po polu, UDT nigdy
- B) UDT nie może być frozen, krotka tak
- C) Krotka ma pozycje bez nazw, UDT ma nazwane pola
- D) Krotka służy tylko do kluczy głównych

<details><summary>Odpowiedź</summary>

**C** — Krotka to uporządkowany ciąg wartości określonych typów (literał w nawiasach okrągłych), UDT to zbiór nazwanych pól (literał `{ pole: wartość }`). (slajd 327, 331)

</details>

### SELECT: selekcja danych

**8.102. Z ilu tabel może wybierać wiersze pojedyncze wyrażenie SELECT w CQL?**

- A) Z dowolnej liczby tabel przez JOIN
- B) Z dwóch tabel tej samej przestrzeni kluczy
- C) Ze wszystkich tabel przestrzeni kluczy
- D) Z pojedynczej tabeli

<details><summary>Odpowiedź</summary>

**D** — SELECT wybiera wiersze z pojedynczej tabeli; złączenie wielu tabel nie jest możliwe. (slajd 332, 334)

</details>

**8.103. Która kolejność klauzul SELECT jest zgodna z diagramem składni CQL?**

- A) SELECT, FROM, WHERE, ORDER BY, GROUP BY, ALLOW FILTERING, LIMIT
- B) SELECT, FROM, WHERE, GROUP BY, ORDER BY, LIMIT, ALLOW FILTERING
- C) SELECT, FROM, ALLOW FILTERING, WHERE, GROUP BY, ORDER BY, LIMIT
- D) SELECT, WHERE, FROM, GROUP BY, LIMIT, ORDER BY

<details><summary>Odpowiedź</summary>

**B** — Diagram: SELECT → FROM → [WHERE] → [GROUP BY] → [ORDER BY] → [LIMIT] → [ALLOW FILTERING]. (slajd 332)

</details>

**8.104. Które zapytanie ma poprawną składnię CQL?**

- A) `SELECT * FROM filmy WHERE id = 'hobbit' ALLOW FILTERING LIMIT 1`
- B) `SELECT * FROM filmy LIMIT 1 WHERE id = 'hobbit'`
- C) `SELECT * FROM filmy WHERE id = 'hobbit' LIMIT 1`
- D) `SELECT * WHERE id = 'hobbit' FROM filmy`

<details><summary>Odpowiedź</summary>

**C** — WHERE przed LIMIT, a ALLOW FILTERING (jeśli jest) na samym końcu, po LIMIT. (slajd 332)

</details>

**8.105. Jakim słowem łączy się relacje w klauzuli WHERE według diagramu składni?**

- A) `AND`
- B) `OR`
- C) `AND` lub `OR`
- D) Przecinkiem

<details><summary>Odpowiedź</summary>

**A** — Diagram: WHERE → relation powtarzane przez AND. OR nie jest dostępny. (slajd 335)

</details>

**8.106. Które kolumny mogą być zasadniczo użyte w klauzuli WHERE?**

- A) Dowolne kolumny tabeli
- B) Tylko kolumny typu TEXT
- C) Tylko kolekcje
- D) Tylko kolumny klucza głównego, chyba że istnieją pomocnicze struktury indeksujące

<details><summary>Odpowiedź</summary>

**D** — Tylko kolumny klucza głównego, chyba że istnieją indeksy pomocnicze; niektóre relacje są dodatkowo problematyczne. (slajd 335)

</details>

**8.107. Do czego służy relacja `CONTAINS KEY`?**

- A) Sprawdza, czy mapa zawiera dany klucz; działa tylko dla map
- B) Sprawdza, czy lista zawiera dany element
- C) Sprawdza, czy wiersz ma dany klucz główny
- D) Sprawdza, czy zbiór zawiera daną wartość

<details><summary>Odpowiedź</summary>

**A** — CONTAINS KEY działa tylko dla map i sprawdza klucze. CONTAINS działa dla list, zbiorów i map (dla map sprawdza wartości). (slajd 337)

</details>

**8.108. Dla jakich typów kolumn można używać relacji `CONTAINS`?**

- A) Tylko dla map
- B) Tylko dla typów tekstowych
- C) Dla kolekcji: list, zbiorów i map
- D) Tylko dla krotek

<details><summary>Odpowiedź</summary>

**C** — CONTAINS może być używany w kolekcjach i zwraca true, gdy kolekcja zawiera dany element. (slajd 337)

</details>

**8.109. Co zwróci warunek `WHERE id IN ('hobbit', 'tombraider')`?**

- A) Błąd, bo IN działa tylko dla kolekcji
- B) Wiersze, których `id` zawiera się w wyliczonej liście
- C) Wiersze, których lista `id` zawiera oba elementy jednocześnie
- D) Wiersze o `id` innym niż podane

<details><summary>Odpowiedź</summary>

**B** — IN zwraca true, jeśli wartość zawiera się w wyliczonej strukturze. (slajd 337)

</details>

**8.110. Który operator porównania jest poprawny w CQL?**

- A) `=>`
- B) `=<`
- C) `<>`
- D) `>=`

<details><summary>Odpowiedź</summary>

**D** — Poprawny zapis to `>=`. Na slajdach 336–337 jest literówka `=>`. Slajd wymienia też `!=`, a nie `<>` (w praktyce `!=` w WHERE zapytania SELECT standardowo nie jest obsługiwany). (slajd 336, 337)

</details>

**8.111. Co oznacza `DISTINCT` w klauzuli SELECT?**

- A) Sortuje wyniki rosnąco
- B) Powielone wiersze są usuwane z wyniku
- C) Zwraca tylko pierwszy wiersz
- D) Zlicza unikalne wartości

<details><summary>Odpowiedź</summary>

**B** — DISTINCT usuwa powielone wiersze (w praktyce Cassandra pozwala na DISTINCT tylko dla kolumn klucza partycji). (slajd 338)

</details>

**8.112. Jak definiuje się alias kolumny w klauzuli SELECT?**

- A) Słowem `AS`, np. `SELECT tytul AS nazwa`
- B) Słowem `ALIAS`, np. `SELECT tytul ALIAS nazwa`
- C) Dwukropkiem, np. `SELECT nazwa: tytul`
- D) Znakiem `=`, np. `SELECT nazwa = tytul`

<details><summary>Odpowiedź</summary>

**A** — Aliasy definiowane są przez AS; gwiazdka oznacza wszystkie kolumny. (slajd 338)

</details>

**8.113. Co zwracają funkcje `WRITETIME(kolumna)` i `TTL(kolumna)`?**

- A) Liczbę zapisów kolumny i liczbę odczytów
- B) Czas utworzenia tabeli i czas jej wygaśnięcia
- C) Czas modyfikacji kolumny i pozostały czas życia kolumny
- D) Bieżący czas serwera i domyślny TTL tabeli

<details><summary>Odpowiedź</summary>

**C** — WRITETIME zwraca czas modyfikacji, TTL — pozostały czas życia danej kolumny. (slajd 339)

</details>

**8.114. Które zdanie o WRITETIME i TTL jest prawdziwe według wykładu?**

- A) Można ich używać w klauzuli WHERE
- B) Działają tylko na kolekcjach
- C) Działają tylko na kolumnach klucza głównego
- D) Nie mogą być użyte na kolekcji i jej elementach ani w innych klauzulach (np. WHERE)

<details><summary>Odpowiedź</summary>

**D** — Slajd podaje oba ograniczenia: nie na kolekcjach i nie w innych klauzulach. (slajd 339)

</details>

**8.115. Według jakich kolumn można porządkować wynik klauzulą ORDER BY?**

- A) Tylko według kolumn grupujących (clustering columns)
- B) Według dowolnej kolumny
- C) Tylko według klucza partycji
- D) Tylko według kolumn z indeksem pomocniczym

<details><summary>Odpowiedź</summary>

**A** — Tylko uporządkowania wyznaczane przez kolumny grupujące są dozwolone. (slajd 340)

</details>

**8.116. Tabela ma `PRIMARY KEY (sensor_id, timestamp)`. Które zapytanie jest poprawne?**

- A) `SELECT * FROM sensor_data WHERE sensor_id = 'sensor01' ORDER BY value DESC`
- B) `SELECT * FROM sensor_data ORDER BY sensor_id`
- C) `SELECT * FROM sensor_data WHERE sensor_id = 'sensor01' ORDER BY timestamp DESC LIMIT 10`
- D) `SELECT * FROM sensor_data WHERE sensor_id = 'sensor01' LIMIT 10 ORDER BY timestamp`

<details><summary>Odpowiedź</summary>

**C** — ORDER BY po kolumnie grupującej `timestamp`, w obrębie partycji, a LIMIT po ORDER BY. A sortuje po kolumnie spoza klucza, B po kluczu partycji, D ma złą kolejność klauzul. (slajd 340)

</details>

**8.117. Po jakich kolumnach dozwolone jest grupowanie w GROUP BY?**

- A) Po dowolnych kolumnach
- B) Tylko po kolekcjach
- C) Tylko po kolumnach z TTL
- D) Tylko po kolumnach klucza głównego

<details><summary>Odpowiedź</summary>

**D** — Tylko grupowania na kolumnach klucza głównego są dozwolone. (slajd 341)

</details>

**8.118. Co zwróci CQL, gdy w SELECT z GROUP BY wymienimy bezpośrednio kolumnę, która nie bierze udziału w grupowaniu i nie jest objęta agregacją?**

- A) Błąd składni, jak w standardowym SQL
- B) Zawsze tylko pierwszą wartość z grupy
- C) Listę wszystkich wartości z grupy
- D) Wartość null

<details><summary>Odpowiedź</summary>

**B** — W takim przypadku zawsze zostanie zwrócona tylko pierwsza wartość. (slajd 341)

</details>

**8.119. Czym różni się `COUNT(kolumna)` od `COUNT(*)`?**

- A) `COUNT(kolumna)` liczy wartości w kolumnie, ignorując null; `COUNT(*)` liczy wiersze
- B) `COUNT(kolumna)` liczy wiersze, `COUNT(*)` tylko wartości różne od null
- C) Oba zawsze dają ten sam wynik
- D) `COUNT(kolumna)` liczy unikalne wartości

<details><summary>Odpowiedź</summary>

**A** — COUNT(kolumna) zlicza wartości z pominięciem null, COUNT(*) liczbę wierszy w grupie. (slajd 339, 342)

</details>

**8.120. Która funkcja NIE jest natywną agregacją wymienioną na wykładzie?**

- A) `MIN`
- B) `AVG`
- C) `MEDIAN`
- D) `SUM`

<details><summary>Odpowiedź</summary>

**C** — Natywne agregacje: COUNT, MIN, MAX, SUM, AVG; dodatkowo funkcje agregacyjne definiowane przez użytkownika. (slajd 342)

</details>

**8.121. Jakie zapytania są domyślnie dozwolone bez modyfikatora ALLOW FILTERING?**

- A) Wszystkie zapytania z klauzulą WHERE
- B) Tylko zapytania z GROUP BY
- C) Tylko zapytania bez klauzuli WHERE
- D) Tylko zapytania niefiltrujące, w których liczba wierszy przeczytanych ≈ liczba wierszy zwróconych

<details><summary>Odpowiedź</summary>

**D** — Takie zapytania mają przewidywalną złożoność. Slajd mówi, że ich czas jest proporcjonalny „do rozmiaru danych” — chodzi o rozmiar danych zwracanych. (slajd 343)

</details>

**8.122. Co umożliwia modyfikator ALLOW FILTERING?**

- A) Tworzy indeks pomocniczy na filtrowanej kolumnie
- B) Częściowe filtrowanie, czyli czytanie większej liczby wierszy niż zwracana
- C) Używanie operatora OR w WHERE
- D) Złączenie dwóch tabel

<details><summary>Odpowiedź</summary>

**B** — ALLOW FILTERING umożliwia częściowe filtrowanie; na dużych tabelach to kosztowne i jest na liście błędów modelowania. (slajd 343, 302)

</details>

**8.123. Co jest potrzebne, żeby zapytanie `SELECT id, tytul, aktorzy FROM filmy WHERE rok = 2011 AND gatunki CONTAINS 'komedia'` faktycznie zadziałało w tabeli `filmy` z kluczem `PRIMARY KEY (id)`?**

- A) Nic, bo WHERE może zawierać dowolne kolumny
- B) Zamiana `AND` na `OR`
- C) Indeksy pomocnicze na `rok` i `gatunki` albo dopisanie `ALLOW FILTERING`
- D) Dodanie `GROUP BY rok`

<details><summary>Odpowiedź</summary>

**C** — `rok` i `gatunki` nie należą do klucza głównego, więc potrzebne są pomocnicze struktury indeksujące albo ALLOW FILTERING. Slajd 333 pokazuje to zapytanie jako przykład składni. (slajd 333, 335, 343)

</details>

### INSERT, UPDATE, DELETE i upsert

**8.124. Co się stanie, gdy INSERT wstawi wiersz o kluczu głównym, który już istnieje w tabeli?**

- A) Cassandra zgłosi błąd naruszenia klucza głównego
- B) Powstanie drugi wiersz z tym samym kluczem
- C) INSERT zostanie zignorowany
- D) Istniejący wiersz zostanie zaktualizowany (upsert)

<details><summary>Odpowiedź</summary>

**D** — Gdy wiersz o podanym kluczu już istnieje, jest aktualizowany. Wyjątkiem jest INSERT z IF NOT EXISTS. (slajd 344)

</details>

**8.125. Które zdanie o INSERT w CQL jest prawdziwe?**

- A) Nazwy kolumn muszą być zawsze podane jawnie, a wartości co najmniej dla kolumn klucza głównego
- B) Listę kolumn można pominąć, jak w SQL
- C) Trzeba podać wartości wszystkich kolumn tabeli
- D) Klucz główny jest generowany automatycznie, gdy go pominiemy

<details><summary>Odpowiedź</summary>

**A** — Nazwy kolumn zawsze jawnie, a przynajmniej kolumny klucza głównego muszą mieć wartości. (slajd 344)

</details>

**8.126. Co oznacza `USING TTL 86400` na końcu INSERT w przykładzie z filmem „Zielona Mila”?**

- A) Wiersz będzie widoczny dopiero po 86400 sekundach
- B) Wstawione wartości wygasną po 86400 sekundach, czyli po jednej dobie
- C) Wiersz wygaśnie po 86400 milisekundach
- D) Ustawia ręczny timestamp zapisu

<details><summary>Odpowiedź</summary>

**B** — TTL jest w sekundach; 86400 s = 24 h. (slajd 345, 350)

</details>

**8.127. Które polecenie INSERT ma poprawną składnię i literały?**

- A) `INSERT INTO filmy VALUES ('zielonamila', 'Zielona Mila', 1999)`
- B) `INSERT INTO filmy (id, rezyser, gatunki) VALUES ('zielonamila', {'frank', 'Darabont'}, ('komedia', 'dramat'))`
- C) `INSERT INTO filmy (id, rezyser, aktorzy, gatunki) VALUES ('zielonamila', ('frank', 'Darabont'), {'hanks': 'Tom'}, ['komedia', 'dramat'])`
- D) `INSERT filmy SET id = 'zielonamila', rok = 1999`

<details><summary>Odpowiedź</summary>

**C** — Krotka w nawiasach okrągłych, mapa w klamrach z dwukropkiem, lista w kwadratowych. A nie ma listy kolumn, B myli literały krotki i listy, D to nie jest składnia INSERT. (slajd 345)

</details>

**8.128. Co robi `INSERT ... IF NOT EXISTS`?**

- A) Wstawia wiersz tylko wtedy, gdy wiersz o tym kluczu jeszcze nie istnieje
- B) Tworzy tabelę, jeśli nie istnieje, i wstawia wiersz
- C) Wstawia wiersz bez TTL
- D) Aktualizuje wiersz tylko wtedy, gdy istnieje

<details><summary>Odpowiedź</summary>

**A** — IF NOT EXISTS wyłącza zachowanie upsert dla tego zapisu (transakcja lekka). (slajd 344)

</details>

**8.129. Co się stanie, gdy UPDATE wskaże w WHERE klucz wiersza, który nie istnieje?**

- A) Nic się nie stanie, jak w SQL
- B) Cassandra zgłosi błąd
- C) Zostaną zaktualizowane wszystkie wiersze tabeli
- D) Wiersz zostanie dodany

<details><summary>Odpowiedź</summary>

**D** — UPDATE też jest upsertem: nieistniejący wiersz zostanie dodany. (slajd 346)

</details>

**8.130. Co musi zawierać klauzula WHERE w poleceniu UPDATE?**

- A) Dowolną kolumnę z indeksem
- B) Co najmniej wszystkie kolumny klucza głównego
- C) Tylko klucz partycji, bez kolumn grupujących
- D) Klauzula WHERE w UPDATE jest opcjonalna

<details><summary>Odpowiedź</summary>

**B** — Co najmniej wszystkie kolumny wchodzące w skład klucza głównego muszą być podane w WHERE. (slajd 346)

</details>

**8.131. Gdzie w poleceniu UPDATE umieszcza się klauzulę `USING` (np. `USING TTL 300`)?**

- A) Po klauzuli WHERE
- B) Między SET a WHERE
- C) Po nazwie tabeli, przed SET
- D) Przed słowem UPDATE

<details><summary>Odpowiedź</summary>

**C** — Diagram: UPDATE → tabela → [USING …] → SET → … → WHERE. W INSERT USING stoi na końcu, po VALUES. (slajd 346, 344)

</details>

**8.132. Które przypisanie w UPDATE zmienia pole `dlugosc` w kolumnie typu UDT `wlasciwosci`?**

- A) `wlasciwosci['dlugosc'] = 99`
- B) `wlasciwosci.dlugosc = 99`
- C) `wlasciwosci = wlasciwosci + { dlugosc: 99 }`
- D) `wlasciwosci(dlugosc) = 99`

<details><summary>Odpowiedź</summary>

**B** — Pole UDT zmienia się przez kropkę; nawias kwadratowy służy do elementów mapy i listy. (slajd 347, 348)

</details>

**8.133. Co zmienia przypisanie `gatunki[1] = 'komedia'` w UPDATE?**

- A) Pierwszy element listy `gatunki`
- B) Element mapy o kluczu `1`
- C) Dodaje `'komedia'` na pozycji 1 i przesuwa pozostałe
- D) Drugi element listy `gatunki`, bo elementy listy są numerowane od 0

<details><summary>Odpowiedź</summary>

**D** — Indeksy listy zaczynają się od 0, więc `[1]` to drugi element (pozycja musi istnieć, inaczej błąd). (slajd 347, 348)

</details>

**8.134. Co robi przypisanie `aktorzy['norris'] = 'Chuck'` w UPDATE, gdy `aktorzy` to `MAP<TEXT, TEXT>`?**

- A) Zastępuje całą mapę jednym wpisem
- B) Ustawia wartość `'Chuck'` dla klucza `'norris'` w mapie, nie ruszając innych wpisów
- C) Usuwa klucz `'norris'`
- D) Zgłasza błąd, bo mapy nie można zmieniać elementami

<details><summary>Odpowiedź</summary>

**B** — Przypisanie z kluczem w nawiasie kwadratowym zmienia pojedynczy element mapy. (slajd 347, 348)

</details>

**8.135. Co robi przypisanie `gatunki = [ 'dramat' ] + gatunki`?**

- A) Dopisuje `'dramat'` na początku listy
- B) Dopisuje `'dramat'` na końcu listy
- C) Zastępuje listę jednym elementem `'dramat'`
- D) Usuwa `'dramat'` z listy

<details><summary>Odpowiedź</summary>

**A** — Nowa lista przed kolumną to dopisanie na początku (prepend); `gatunki + [ ... ]` dopisuje na końcu. (slajd 349)

</details>

**8.136. Jak usunąć z mapy `aktorzy` wpisy o kluczach `'vicander'` i `'west'` przez UPDATE?**

- A) `aktorzy = aktorzy - { 'vicander': null, 'west': null }`
- B) `aktorzy = { 'vicander', 'west' } - aktorzy`
- C) `aktorzy = aktorzy - [ 'vicander', 'west' ]`
- D) `aktorzy = aktorzy - { 'vicander', 'west' }`

<details><summary>Odpowiedź</summary>

**D** — Od mapy odejmuje się zbiór kluczy w klamrach, zawsze w kolejności kolumna minus wartości. (slajd 349)

</details>

**8.137. Co oznacza wartość TTL równa 0 (albo null, albo brak) w parametrach UPDATE/INSERT?**

- A) Wartość wygasa natychmiast
- B) Wartość jest trwała i nie wygasa
- C) Wartość wygasa po domyślnej dobie
- D) Wiersz zostaje usunięty

<details><summary>Odpowiedź</summary>

**B** — TTL 0, null lub pusty oznacza wartości trwałe. (slajd 350)

</details>

**8.138. Na jakie wartości wpływają parametry `USING TTL` i `USING TIMESTAMP`?**

- A) Na cały wiersz, łącznie z kolumnami niezmienianymi w poleceniu
- B) Na wszystkie wiersze tabeli
- C) Tylko na nowo dodawane lub aktualizowane wartości
- D) Tylko na kolumny klucza głównego

<details><summary>Odpowiedź</summary>

**C** — Ma to wpływ tylko na nowo dodane lub aktualizowane wartości. (slajd 350)

</details>

**8.139. Które zdanie o DELETE w CQL jest prawdziwe?**

- A) DELETE zawsze usuwa całe wiersze, jak w SQL
- B) DELETE może usunąć cały wiersz, wybrane kolumny albo elementy kolekcji i pola UDT
- C) DELETE działa tylko na kolekcjach
- D) DELETE nie przyjmuje klauzuli WHERE

<details><summary>Odpowiedź</summary>

**B** — DELETE usuwa pasujące wiersze, albo zachowuje wiersze i usuwa wybrane kolumny, albo zachowuje kolumny i usuwa elementy kolekcji lub pola UDT. (slajd 351)

</details>

**8.140. Które polecenie usuwa z wiersza `'niezniszczalni'` tylko wpis mapy `aktorzy` o kluczu `'jet'`?**

- A) `DELETE aktorzy['jet'] FROM filmy WHERE id = 'niezniszczalni'`
- B) `DELETE FROM filmy WHERE id = 'niezniszczalni' AND aktorzy CONTAINS KEY 'jet'`
- C) `DELETE aktorzy FROM filmy WHERE id = 'niezniszczalni'`
- D) `UPDATE filmy DELETE aktorzy['jet'] WHERE id = 'niezniszczalni'`

<details><summary>Odpowiedź</summary>

**A** — Element kolekcji wskazuje się w nawiasie kwadratowym po DELETE. B usuwałoby cały wiersz (i warunek jest niedozwolony), C usuwa całą kolumnę. (slajd 351)

</details>


## 9. Laboratoria 1–3 (MongoDB w praktyce)

### Lab 1 — Docker, instalacja lokalna, mongosh, Compass, VS Code

**9.1. Co robi polecenie `docker pull mongodb/mongodb-community-server`?**

- A) Tworzy i uruchamia kontener z serwerem MongoDB
- B) Pobiera obraz MongoDB Community Server z rejestru (Docker Hub) na lokalny komputer
- C) Instaluje MongoDB jako usługę systemu Windows
- D) Łączy się z działającym kontenerem i otwiera mongosh

<details><summary>Odpowiedź</summary>

**B** — `docker pull` tylko pobiera obraz. Kontener powstaje dopiero przy `docker run`. (Lab 1, zad. 1)

</details>

**9.2. Które polecenie uruchomi w tle kontener o nazwie `mongodb` z MongoDB dostępnym na hoście na standardowym porcie?**

- A) `docker start --name mongodb -p 27017 mongodb/mongodb-community-server`
- B) `docker exec --name mongodb -d -p 27017:27017 mongodb/mongodb-community-server:latest`
- C) `docker run --name mongodb -d -p 27017:27017 mongodb/mongodb-community-server:latest`
- D) `docker pull --name mongodb -d -p 27017:27017 mongodb/mongodb-community-server:latest`

<details><summary>Odpowiedź</summary>

**C** — nowy kontener z obrazu tworzy i uruchamia `docker run`. `-d` uruchamia go w tle, a `-p` mapuje port. (Lab 1, zad. 2)

</details>

**9.3. Co oznacza flaga `-d` w `docker run --name mongodb -d -p 27017:27017 ...`?**

- A) Tryb odłączony (detached): kontener działa w tle, a terminal jest od razu wolny
- B) Usunięcie kontenera po zatrzymaniu
- C) Tryb debugowania serwera MongoDB
- D) Wskazanie katalogu danych `/data/db`

<details><summary>Odpowiedź</summary>

**A** — `-d` (detached) uruchamia kontener w tle. Slajd z wykładu opisuje to jako „detached mode”. (Lab 1, zad. 2)

</details>

**9.4. Drugi kontener uruchomiono poleceniem `docker run --name mongodb1 -d -p 27018:27017 mongodb/mongodb-community-server:latest`. Co oznacza `-p 27018:27017`?**

- A) Serwer w kontenerze nasłuchuje na 27018, a na hoście jest dostępny na 27017
- B) Kontener używa naraz portów 27017 i 27018
- C) Port 27018 jest zarezerwowany dla repliki, a 27017 dla klientów
- D) Port 27018 hosta jest przekierowany na port 27017 wewnątrz kontenera

<details><summary>Odpowiedź</summary>

**D** — składnia to `-p <port_hosta>:<port_kontenera>`. mongod w kontenerze dalej słucha na 27017, a z hosta łączymy się na 27018. (Lab 1, zad. 11)

</details>

**9.5. Jaki jest domyślny port serwera MongoDB (mongod)?**

- A) 27018
- B) 5432
- C) 27017
- D) 3306

<details><summary>Odpowiedź</summary>

**C** — MongoDB domyślnie nasłuchuje na 27017. 5432 to PostgreSQL, 3306 to MySQL, a 27018 wybraliśmy sami dla drugiego kontenera. (Lab 1, zad. 2 i 11)

</details>

**9.6. Co robi polecenie `docker exec -it mongodb mongosh`?**

- A) Tworzy nowy kontener `mongodb` i uruchamia w nim mongosh
- B) Uruchamia interaktywną powłokę mongosh wewnątrz działającego kontenera `mongodb`
- C) Instaluje mongosh na hoście z obrazu `mongodb`
- D) Eksportuje bazę z kontenera do pliku `mongosh`

<details><summary>Odpowiedź</summary>

**B** — `docker exec` uruchamia polecenie w już działającym kontenerze, a `-it` daje interaktywny terminal. (Lab 1, zad. 3)

</details>

**9.7. Co oznaczają flagi `-it` w `docker exec -it mongodb mongosh`?**

- A) `-i` zostawia otwarte wejście standardowe, `-t` przydziela pseudoterminal; razem pozwalają pisać w powłoce
- B) `-i` instaluje, `-t` testuje połączenie
- C) `-i` ignoruje błędy, `-t` ustawia limit czasu
- D) `-i` to obraz (image), `-t` to tag obrazu

<details><summary>Odpowiedź</summary>

**A** — `-i` (interactive) i `-t` (tty) są potrzebne do pracy z interaktywnym programem, takim jak mongosh. (Lab 1, zad. 3)

</details>

**9.8. Uruchamiasz `docker exec -it mongodb1 mongosh` w kontenerze zmapowanym jako `-p 27018:27017`. Z którym portem łączy się mongosh?**

- A) 27018, bo tak zmapowano kontener
- B) Z losowym wolnym portem
- C) Z portem podanym w nazwie kontenera
- D) 27017, bo mongosh działa wewnątrz kontenera, gdzie mongod nasłuchuje na 27017

<details><summary>Odpowiedź</summary>

**D** — mapowanie `-p` dotyczy tylko ruchu z hosta. Wewnątrz kontenera mongosh łączy się domyślnie z `127.0.0.1:27017`. (Lab 1, zad. 11)

</details>

**9.9. Jak z hosta (Windows) połączyć się mongoshem z kontenerem `mongodb1` uruchomionym z `-p 27018:27017`?**

- A) `mongosh "mongodb://localhost:27017/mongodb1"`
- B) `mongosh "mongodb://localhost:27018"`
- C) `mongosh --container mongodb1`
- D) `docker run mongosh 27018`

<details><summary>Odpowiedź</summary>

**B** — z hosta serwer w tym kontenerze jest widoczny pod portem 27018. Ten sam adres podajemy w VS Code i w Compass. (Lab 1, zad. 11–12)

</details>

**9.10. Co wyświetla polecenie `show dbs` w mongosh?**

- A) Listę kolekcji w bieżącej bazie
- B) Nazwę bieżącej bazy
- C) Listę baz danych na serwerze wraz z zajmowanym miejscem
- D) Listę użytkowników bazy

<details><summary>Odpowiedź</summary>

**C** — `show dbs` (lub `show databases`) wypisuje bazy z rozmiarem. Kolekcje pokazuje `show collections`. (Lab 1, zad. 3)

</details>

**9.11. Wykonujesz kolejno `use test1`, a potem `show dbs`. Baza `test1` wcześniej nie istniała. Co zobaczysz?**

- A) `test1` na liście z rozmiarem 0 B
- B) `test1` nie ma jeszcze na liście, bo baza powstaje dopiero po zapisaniu w niej danych (kolekcji lub dokumentu)
- C) Błąd: baza `test1` nie istnieje
- D) Pytanie, czy utworzyć bazę `test1`

<details><summary>Odpowiedź</summary>

**B** — `use` tylko przełącza kontekst. Baza pojawia się w `show dbs`, gdy trafi do niej pierwsza kolekcja albo dokument. (Lab 1, zad. 3; Lab 2, zad. 25)

</details>

**9.12. Które polecenie mongosh daje ten sam wynik co `show dbs`?**

- A) `show collections`
- B) `db.getName()`
- C) `db.stats()`
- D) `show databases`

<details><summary>Odpowiedź</summary>

**D** — `show databases` to synonim `show dbs`. `db.getName()` zwraca nazwę bieżącej bazy, a `db.stats()` statystyki jednej bazy. (Lab 1, zad. 3)

</details>

**9.13. Co zwraca `db.getMongo().getDBNames()` w mongosh albo w Playground?**

- A) Tablicę nazw baz danych na serwerze
- B) Tablicę nazw kolekcji w bieżącej bazie
- C) Nazwę bieżącej bazy
- D) Adres URI połączenia

<details><summary>Odpowiedź</summary>

**A** — to odpowiednik `show dbs`, który działa także w Playground, gdzie polecenia `show …` nie są dostępne. Kolekcje zwraca `db.getCollectionNames()`. (Lab 2, zad. 25; Lab 3, zad. 5)

</details>

**9.14. Jak zatrzymać kontener `mongodb` (zad. 4)?**

- A) `docker rm mongodb`
- B) `docker exec mongodb stop`
- C) `docker stop mongodb`
- D) `docker pull --stop mongodb`

<details><summary>Odpowiedź</summary>

**C** — `docker stop` zatrzymuje kontener, ale go nie usuwa. `docker rm` usuwa kontener. (Lab 1, zad. 4)

</details>

**9.15. Czym różni się `docker stop mongodb` od `docker rm mongodb`?**

- A) Niczym, to synonimy
- B) `stop` usuwa obraz, `rm` usuwa kontener
- C) `stop` działa tylko w Docker Desktop, `rm` tylko w terminalu
- D) `stop` zatrzymuje kontener, który można potem uruchomić ponownie z danymi; `rm` usuwa kontener, a z nim dane zapisane wewnątrz (bez wolumenu)

<details><summary>Odpowiedź</summary>

**D** — po `stop` kontener istnieje i `docker start` go wznawia. Po `rm` kontenera nie ma, a dane spoza wolumenu przepadają. (Lab 1, zad. 4 i 10)

</details>

**9.16. Kontener `mongodb` jest zatrzymany. Jak go ponownie uruchomić z tymi samymi danymi?**

- A) `docker start mongodb`
- B) `docker run --name mongodb -d -p 27017:27017 mongodb/mongodb-community-server:latest`
- C) `docker pull mongodb`
- D) `docker exec -it mongodb start`

<details><summary>Odpowiedź</summary>

**A** — `docker start` wznawia istniejący kontener. Ponowne `docker run` z tą samą nazwą skończy się błędem. (Lab 1, zad. 10)

</details>

**9.17. Kontener `mongodb` istnieje (jest zatrzymany). Co się stanie po ponownym `docker run --name mongodb -d -p 27017:27017 mongodb/mongodb-community-server:latest`?**

- A) Docker nadpisze stary kontener nowym
- B) Docker uruchomi stary kontener
- C) Błąd: nazwa `mongodb` jest już zajęta przez istniejący kontener
- D) Powstanie kontener `mongodb_2`

<details><summary>Odpowiedź</summary>

**C** — nazwa kontenera musi być unikalna. Trzeba użyć `docker start mongodb` albo najpierw usunąć stary kontener. (Lab 1, zad. 2 i 10)

</details>

**9.18. Co wyświetla `docker ps`?**

- A) Wszystkie pobrane obrazy
- B) Działające kontenery (z `-a` także zatrzymane)
- C) Procesy mongod na hoście
- D) Bazy danych w kontenerze

<details><summary>Odpowiedź</summary>

**B** — `docker ps` pokazuje działające kontenery, m.in. nazwę, obraz i mapowanie portów. Obrazy wypisuje `docker images`. (Lab 1, zad. 11)

</details>

**9.19. Dlaczego przed uruchomieniem kontenera z `-p 27017:27017` trzeba zamknąć lokalny `mongod.exe`?**

- A) Bo kontener kasuje dane lokalnego serwera
- B) Bo Docker nie działa, gdy jakikolwiek mongod jest zainstalowany
- C) Bo dwa serwery MongoDB nie mogą mieć tej samej nazwy bazy
- D) Bo lokalny mongod zajmuje port 27017 na hoście i Docker nie może go opublikować dla kontenera

<details><summary>Odpowiedź</summary>

**D** — dany port na hoście może zajmować tylko jeden proces. Dlatego drugi serwer dostał port 27018. (Lab 1, zad. 10–11)

</details>

**9.20. Po co przy lokalnej instalacji na Windows tworzy się katalog `C:\data\db`?**

- A) Tam trafiają pliki instalacyjne Compass
- B) To domyślna ścieżka danych (dbPath) serwera mongod na Windows (`\data\db` na bieżącym dysku)
- C) Tam mongosh zapisuje historię poleceń
- D) To katalog z logami Dockera

<details><summary>Odpowiedź</summary>

**B** — mongod uruchomiony bez `--dbpath` szuka katalogu `\data\db`. Bez niego serwer się nie uruchomi. (Lab 1, zad. 6)

</details>

**9.21. Co się stanie, gdy uruchomisz `mongod.exe` bez opcji `--dbpath`, a katalog `C:\data\db` nie istnieje?**

- A) Serwer zakończy się błędem, bo nie znajdzie katalogu danych
- B) Serwer utworzy katalog sam i wystartuje
- C) Serwer zapisze dane w pamięci RAM
- D) Serwer połączy się z kontenerem Docker

<details><summary>Odpowiedź</summary>

**A** — mongod nie tworzy domyślnego katalogu danych. Trzeba go założyć ręcznie albo wskazać inny przez `--dbpath`. (Lab 1, zad. 6–7)

</details>

**9.22. Którą opcją wskazać mongod inny katalog danych niż domyślny?**

- A) `--datadir`
- B) `--port`
- C) `--dbpath`
- D) `--db`

<details><summary>Odpowiedź</summary>

**C** — np. `mongod.exe --dbpath D:\mongo\db`. `--port` zmienia port, a `--db` to opcja narzędzi takich jak mongoimport. (Lab 1, zad. 7)

</details>

**9.23. Jaka jest rola `mongod.exe`, a jaka `mongosh.exe`?**

- A) `mongod` to powłoka, `mongosh` to serwer
- B) Oba to serwery; `mongosh` działa w trybie bezpiecznym
- C) `mongod` to narzędzie do importu, `mongosh` do eksportu
- D) `mongod` to proces serwera bazy, `mongosh` to powłoka (klient), która łączy się z serwerem

<details><summary>Odpowiedź</summary>

**D** — najpierw uruchamiamy serwer `mongod`, potem klienta `mongosh`. (Lab 1, zad. 7)

</details>

**9.24. Do czego służy MongoDB Compass?**

- A) To graficzny klient (GUI) do przeglądania i edycji danych, indeksów i zapytań
- B) To sterownik MongoDB dla języka C#
- C) To narzędzie do kopii zapasowych w formacie BSON
- D) To serwer konfiguracyjny klastra

<details><summary>Odpowiedź</summary>

**A** — Compass to GUI. Kopie zapasowe robi `mongodump`. (Lab 1, zad. 8)

</details>

**9.25. Z jakim adresem łączy się `mongosh` uruchomiony bez argumentów?**

- A) `mongodb://localhost:27018`
- B) `mongodb://127.0.0.1:27017` (lokalny serwer na domyślnym porcie)
- C) Z pierwszym serwerem znalezionym w sieci
- D) Z MongoDB Atlas

<details><summary>Odpowiedź</summary>

**B** — domyślnie mongosh łączy się z `127.0.0.1:27017`, co widać w linii „Connecting to:”. (Lab 1, zad. 7)

</details>

**9.26. Jaka baza jest bieżąca zaraz po uruchomieniu mongosh bez wskazania bazy?**

- A) `admin`
- B) `local`
- C) `test`
- D) Żadna; trzeba najpierw wykonać `use`

<details><summary>Odpowiedź</summary>

**C** — znak zachęty to `test>`. `admin`, `config` i `local` to bazy systemowe. (Lab 1, zad. 3)

</details>

**9.27. Jakie rozszerzenie mają pliki Playground w rozszerzeniu MongoDB for VS Code?**

- A) `.mongodb.js`
- B) `.mongo.json`
- C) `.bson`
- D) `.playground.ts`

<details><summary>Odpowiedź</summary>

**A** — np. `lab02.mongodb.js`. Rozszerzenie wykonuje taki plik na wybranym połączeniu. (Lab 1, zad. 9 i 13)

</details>

**9.28. Którą bazę wybiera w Playground polecenie `use('mongodbVSCodePlaygroundDB');`?**

- A) Tworzy kolekcję `mongodbVSCodePlaygroundDB` w bazie `test`
- B) Nic nie robi; w Playground działa tylko `use mongodbVSCodePlaygroundDB` bez nawiasów
- C) Usuwa bazę o tej nazwie i tworzy ją od nowa
- D) Ustawia bazę `mongodbVSCodePlaygroundDB` jako bieżącą dla kolejnych poleceń w pliku

<details><summary>Odpowiedź</summary>

**D** — w Playground (pliku JS) używamy funkcji `use('nazwa')`. Składnię `use nazwa` bez nawiasów zna tylko interaktywny mongosh. (Lab 1, zad. 13)

</details>

**9.29. Które polecenie jest równoważne `db.sales.find()`?**

- A) `db.find('sales')`
- B) `db.getCollection('sales').find()`
- C) `db.collection.sales.find()`
- D) `use('sales').find()`

<details><summary>Odpowiedź</summary>

**B** — `db.getCollection('nazwa')` zwraca ten sam obiekt kolekcji co `db.nazwa`. (Lab 1, zad. 13)

</details>

**9.30. Kiedy trzeba użyć `db.getCollection('...')` zamiast zapisu z kropką `db.nazwa`?**

- A) Zawsze w mongosh 2.x
- B) Gdy kolekcja jest pusta
- C) Gdy nazwa kolekcji nie jest poprawnym identyfikatorem JS, np. `my-coll` (`db.my-coll` zostałoby odczytane jako odejmowanie)
- D) Gdy kolekcja ma indeks

<details><summary>Odpowiedź</summary>

**C** — zapis z kropką działa tylko dla nazw będących identyfikatorami JS. Dla innych nazw jest `getCollection`. (Lab 1, zad. 13)

</details>

**9.31. Co zwróci `db.sales.find()` w bazie, w której kolekcja `sales` nie istnieje?**

- A) Pusty wynik, bez błędu
- B) Błąd „collection not found”
- C) Utworzy kolekcję `sales` z jednym pustym dokumentem
- D) Dokumenty z kolekcji o najbliższej nazwie

<details><summary>Odpowiedź</summary>

**A** — odczyt z nieistniejącej kolekcji zwraca pusty kursor. Kolekcję tworzy dopiero zapis albo `createCollection`. (Lab 1, zad. 13)

</details>

**9.32. Playground zawiera kilka poleceń po kolei. Co pokazuje panel „Playground Result” po uruchomieniu całego pliku?**

- A) Wyniki wszystkich poleceń, każde w osobnej zakładce
- B) Tylko pierwsze polecenie
- C) Wynik ostatniego wykonanego wyrażenia
- D) Wyłącznie komunikaty o błędach

<details><summary>Odpowiedź</summary>

**C** — dlatego w rozwiązaniach przed każdym zadaniem stoi `use(...)`, a zadania uruchamia się zaznaczeniem fragmentu. (Lab 1, zad. 13)

</details>

**9.33. Dlaczego drugi kontener `mongodb1` dostał na hoście port 27018?**

- A) Bo MongoDB 7 nie działa na porcie 27017
- B) Bo port 27017 na hoście zajmuje już lokalny serwer (albo pierwszy kontener), a obie instancje mają działać naraz
- C) Bo obraz `mongodb-community-server` domyślnie używa 27018
- D) Bo Compass łączy się tylko z portem 27018

<details><summary>Odpowiedź</summary>

**B** — dwie instancje na jednym hoście potrzebują różnych portów hosta. (Lab 1, zad. 11)

</details>

**9.34. Znajdź błąd: student uruchomił `docker run --name mongodb1 -d -p 27018:27018 mongodb/mongodb-community-server:latest` i nie może się połączyć z `localhost:27018`. Dlaczego?**

- A) Port 27018 jest zarezerwowany przez Windows
- B) Brakuje flagi `-it`
- C) Kontener o tej nazwie nie może mieć portu wyższego niż 27017
- D) mongod w kontenerze nasłuchuje na 27017, a mapowanie kieruje ruch na port 27018 kontenera, gdzie nic nie słucha

<details><summary>Odpowiedź</summary>

**D** — poprawnie: `-p 27018:27017`. Prawa strona to port wewnątrz kontenera. (Lab 1, zad. 11)

</details>

**9.35. Co oznacza `:latest` w `mongodb/mongodb-community-server:latest`?**

- A) Tag obrazu; `latest` to domyślny tag, używany także wtedy, gdy tagu nie podano
- B) Polecenie aktualizacji kontenera do najnowszej wersji przy każdym starcie
- C) Nazwę kontenera
- D) Numer portu

<details><summary>Odpowiedź</summary>

**A** — tag wskazuje wersję obrazu. Bez tagu Docker przyjmuje `latest`. (Lab 1, zad. 1–2)

</details>

**9.36. Które polecenie wyświetli pobrane lokalnie obrazy Dockera?**

- A) `docker ps`
- B) `docker images`
- C) `docker exec -it images`
- D) `docker show images`

<details><summary>Odpowiedź</summary>

**B** — `docker images` (lub `docker image ls`) wypisuje obrazy, a `docker ps` kontenery. (Lab 1, zad. 1)

</details>

**9.37. Co podajemy jako pierwszy argument po opcjach w `docker exec -it ??? mongosh`?**

- A) Nazwę obrazu, np. `mongodb/mongodb-community-server`
- B) Port, np. `27017`
- C) Nazwę albo ID działającego kontenera, np. `mongodb`
- D) Nazwę bazy, np. `test1`

<details><summary>Odpowiedź</summary>

**C** — `exec` działa na kontenerze, nie na obrazie. (Lab 1, zad. 3)

</details>

**9.38. Jak zakończyć sesję mongosh?**

- A) `show exit`
- B) `db.close()`
- C) `docker stop mongosh`
- D) `exit` (albo `quit()`)

<details><summary>Odpowiedź</summary>

**D** — `exit` i `quit()` kończą powłokę. Przy `docker exec` wracamy wtedy do terminala hosta, a kontener działa dalej. (Lab 1, zad. 3–4)

</details>

**9.39. Kontener uruchomiono bez wolumenu (`-v`). Kiedy dane zapisane w bazie przepadną?**

- A) Po `docker stop`
- B) Po `docker rm` kontenera
- C) Po zamknięciu mongosh
- D) Po każdym restarcie Docker Desktop

<details><summary>Odpowiedź</summary>

**B** — dane leżą w warstwie zapisu kontenera i przetrwają zatrzymanie, ale znikają przy usunięciu kontenera. (Lab 1, zad. 4 i 10)

</details>

**9.40. `docker ps` zwraca błąd „failed to connect to the docker API … dockerDesktopLinuxEngine”. Co jest najbardziej prawdopodobną przyczyną?**

- A) Nie działa Docker Desktop (silnik Dockera)
- B) Kontener `mongodb` nie istnieje
- C) Port 27017 jest zajęty
- D) Brakuje katalogu `C:\data\db`

<details><summary>Odpowiedź</summary>

**A** — klient `docker` nie ma się z czym połączyć, bo silnik nie działa. Najpierw trzeba uruchomić Docker Desktop. (Lab 1, zad. 1)

</details>

**9.41. Czy polecenie `docker stop mongodb mongodb1` jest poprawne?**

- A) Nie, `docker stop` przyjmuje jedną nazwę
- B) Nie, trzeba podać ID, a nie nazwy
- C) Tak, zatrzymuje oba kontenery
- D) Tak, ale zatrzymuje tylko ostatni z podanych

<details><summary>Odpowiedź</summary>

**C** — `docker stop` przyjmuje wiele nazw lub ID. (Lab 1, zad. 4)

</details>

**9.42. Jakie trzy składniki pobierano ze strony mongodb.com do lokalnej instalacji (zad. 6)?**

- A) MongoDB Atlas, Docker Desktop i VS Code
- B) mongoimport, mongoexport i mongodump
- C) Robo 3T, Studio 3T i mongo (stary shell)
- D) MongoDB Community Server, MongoDB Shell (mongosh) i MongoDB Compass

<details><summary>Odpowiedź</summary>

**D** — serwer, powłoka i GUI rozpakowane do `C:\data`. Narzędzia z punktu B (Database Tools) pobierano osobno dopiero w Lab 3. (Lab 1, zad. 6; Lab 3, zad. 1)

</details>

**9.43. Jak w rozszerzeniu MongoDB for VS Code pracować naraz z serwerem lokalnym i z kontenerem `mongodb1`?**

- A) Nie da się; rozszerzenie obsługuje jedno połączenie
- B) Dodać dwa połączenia: `mongodb://localhost:27017` i `mongodb://localhost:27018`, i dla każdego utworzyć Playground
- C) Uruchomić dwa okna VS Code z tym samym połączeniem
- D) Zmienić port w pliku Playground poleceniem `use(27018)`

<details><summary>Odpowiedź</summary>

**B** — każde połączenie to osobny wpis w panelu CONNECTIONS, a Playground wykonuje się na aktywnym połączeniu. (Lab 1, zad. 12–13)

</details>

**9.44. Która baza jest systemowa i jest widoczna w `show dbs` na świeżym serwerze?**

- A) `admin`
- B) `northwind`
- C) `test1`
- D) `mongodbVSCodePlaygroundDB`

<details><summary>Odpowiedź</summary>

**A** — świeży serwer pokazuje bazy systemowe `admin`, `config` i `local`. Pozostałe powstają dopiero po zapisie danych. (Lab 1, zad. 3)

</details>

### Lab 2 — CRUD, zapytania, indeksy i kolekcje capped

#### Tworzenie bazy, kolekcji i wstawianie dokumentów

**9.45. Które polecenia w Playground tworzą bazę `northwind` i w niej pustą kolekcję `customers`?**

- A) `db.createDatabase('northwind'); db.createCollection('customers');`
- B) `use('northwind'); db.createCollection('customers');`
- C) `use('northwind'); db.customers.create();`
- D) `create database northwind; create collection customers;`

<details><summary>Odpowiedź</summary>

**B** — w MongoDB nie ma `createDatabase`. Bazę wybiera `use`, a fizycznie powstaje ona razem z pierwszą kolekcją. (Lab 2, zad. 1–2)

</details>

**9.46. Które wywołanie `insertMany` jest poprawne?**

- A) `db.departments.insertMany({ _id: "alpha", city: "Warszawa" }, { _id: "beta", city: "Warszawa" })`
- B) `db.departments.insertMany("[{ _id: 'alpha' }, { _id: 'beta' }]")`
- C) `db.departments.insertMany([{ _id: "alpha", city: "Warszawa" }, { _id: "beta", city: "Warszawa" }])`
- D) `db.departments.insertMany({ documents: [{ _id: "alpha" }, { _id: "beta" }] })`

<details><summary>Odpowiedź</summary>

**C** — pierwszym argumentem `insertMany` jest tablica dokumentów. (Lab 2, zad. 3)

</details>

**9.47. Dokument Customer07 (`{ firstName: "Patryk", lastName: "Bez", created_date: "2021-07-07" }`) nie ma pola `_id`. Co się stanie przy `insertOne`?**

- A) Wstawienie się nie uda, bo `_id` jest wymagane
- B) Dokument dostanie `_id: 7`, bo jest siódmy
- C) Dokument zostanie wstawiony bez `_id`
- D) MongoDB (sterownik lub shell) nada mu automatycznie `_id` typu ObjectId

<details><summary>Odpowiedź</summary>

**D** — każdy dokument musi mieć `_id`, a gdy go brakuje, dostaje unikalny ObjectId. (Lab 2, zad. 3)

</details>

**9.48. Kolekcja `orders` nie istnieje. Co zrobi `db.orders.insertOne({ _id: "o1", customer: 1 })`?**

- A) Utworzy kolekcję `orders` i wstawi dokument
- B) Zwróci błąd: kolekcja nie istnieje
- C) Wstawi dokument do kolekcji `test`
- D) Zapyta, czy utworzyć kolekcję

<details><summary>Odpowiedź</summary>

**A** — `insertOne()` i `insertMany()` tworzą kolekcję, jeśli jej nie ma. `createCollection` jest potrzebne przy opcjach, np. `capped`. (Lab 2, zad. 2–3; wykład)

</details>

**9.49. Co zwraca `db.customers.insertOne({...})` po udanym wstawieniu?**

- A) Wstawiony dokument w całości
- B) Obiekt z `acknowledged: true` i `insertedId`
- C) Liczbę dokumentów w kolekcji
- D) Kursor na nowy dokument

<details><summary>Odpowiedź</summary>

**B** — `insertOne` zwraca potwierdzenie i `_id` nowego dokumentu, a `insertMany` zwraca `insertedIds`. (Lab 2, zad. 3)

</details>

**9.50. Ponownie wstawiasz dokument z `_id: "o1"`, który już jest w `orders`. Co się stanie?**

- A) Stary dokument zostanie nadpisany
- B) Powstanie drugi dokument z tym samym `_id`
- C) Błąd duplikatu klucza (E11000) na indeksie `_id_`
- D) MongoDB zmieni `_id` na `"o1_1"`

<details><summary>Odpowiedź</summary>

**C** — `_id` jest unikalne dzięki indeksowi `_id_`. Nadpisanie zrobiłby `replaceOne`, a nie insert. (Lab 2, zad. 3 i 25.7)

</details>

**9.51. `insertMany` w trybie domyślnym (ordered) dostaje 5 dokumentów, a trzeci ma zduplikowane `_id`. Ile dokumentów zostanie wstawionych?**

- A) 0, bo cała operacja jest wycofywana
- B) 4, bo pomijany jest tylko błędny
- C) 5, bo duplikat dostaje nowe `_id`
- D) 2, bo wstawianie zatrzymuje się na pierwszym błędzie

<details><summary>Odpowiedź</summary>

**D** — domyślnie `ordered: true`, więc operacja kończy się na pierwszym błędzie, a wcześniejsze dokumenty zostają. Przy `{ ordered: false }` wstawiłyby się 4. (Lab 2, zad. 3–4)

</details>

**9.52. Które polecenie skopiuje wszystkie dokumenty z `customers` do `lab_test` (zad. 4)?**

- A) `db.lab_test.insertMany(db.customers.find().toArray())`
- B) `db.lab_test.insertMany(db.customers)`
- C) `db.customers.copyTo('lab_test')`
- D) `db.lab_test.insertOne(db.customers.find())`

<details><summary>Odpowiedź</summary>

**A** — `find()` zwraca kursor, a `toArray()` zamienia go na tablicę, której wymaga `insertMany`. (Lab 2, zad. 4)

</details>

**9.53. Co robi metoda kursora `toArray()`?**

- A) Sortuje wynik
- B) Pobiera wszystkie dokumenty z kursora i zwraca je jako tablicę JS
- C) Zamienia dokument na tablicę jego pól
- D) Zapisuje wynik do nowej kolekcji

<details><summary>Odpowiedź</summary>

**B** — `toArray()` wczytuje cały wynik do pamięci jako tablicę. (Lab 2, zad. 4)

</details>

**9.54. Kolekcje mają: customers 7 dokumentów, orders 18, departments 5. Ile dokumentów będzie w `lab_test` po trzech `insertMany(...toArray())`?**

- A) 18
- B) 25
- C) 30
- D) 3

<details><summary>Odpowiedź</summary>

**C** — 7 + 18 + 5 = 30. (Lab 2, zad. 4)

</details>

**9.55. Dlaczego przy kopiowaniu trzech kolekcji do jednej `lab_test` nie było konfliktu `_id`?**

- A) `insertMany` zawsze nadaje nowe `_id`
- B) `lab_test` nie ma indeksu `_id_`
- C) Konflikty `_id` są możliwe tylko w kolekcjach capped
- D) Wartości `_id` się nie powtarzają: klienci mają liczby 1–6 i ObjectId, zamówienia `"o1"`–`"o18"`, działy `"alpha"`, `"beta"`…

<details><summary>Odpowiedź</summary>

**D** — kopiowane są oryginalne `_id`. Gdyby dwie kolekcje miały to samo `_id`, wystąpiłby błąd E11000. (Lab 2, zad. 4)

</details>

**9.56. Zad. 4 uruchomiono dwa razy bez usunięcia `lab_test`. Co się stanie przy drugim `db.lab_test.insertMany(db.customers.find().toArray())`?**

- A) Błąd duplikatu klucza (E11000), bo dokumenty z tymi samymi `_id` już są w `lab_test`
- B) Dokumenty zostaną zdublowane
- C) Dokumenty zostaną zaktualizowane
- D) Nic, polecenie jest idempotentne

<details><summary>Odpowiedź</summary>

**A** — dlatego zadanie kończy się `db.lab_test.drop()`, a skrypty zaczynają od `db.dropDatabase()`. (Lab 2, zad. 4)

</details>

**9.57. Czym różni się `db.lab_test.drop()` od `db.lab_test.deleteMany({})`?**

- A) Niczym
- B) `drop()` usuwa całą kolekcję razem z indeksami; `deleteMany({})` usuwa dokumenty, a kolekcja i jej indeksy zostają
- C) `drop()` usuwa tylko indeksy
- D) `deleteMany({})` usuwa też bazę

<details><summary>Odpowiedź</summary>

**B** — zad. 4 każe usunąć kolekcję, więc właściwe jest `drop()`. (Lab 2, zad. 4)

</details>

**9.58. Co robi `db.dropDatabase()`?**

- A) Usuwa wszystkie bazy na serwerze
- B) Usuwa tylko pustą bazę
- C) Usuwa bieżącą bazę (wybraną przez `use`) z wszystkimi kolekcjami
- D) Usuwa bazę `test`

<details><summary>Odpowiedź</summary>

**C** — dotyczy bazy, na którą wskazuje `db`. W skryptach studenta czyści `northwind` przed ponownym uruchomieniem. (Lab 2, zad. 1; Lab 3, zad. 6)

</details>

**9.59. Które polecenie zwraca listę nazw kolekcji w bieżącej bazie?**

- A) `db.getMongo().getDBNames()`
- B) `show dbs`
- C) `db.getCollection()`
- D) `db.getCollectionNames()`

<details><summary>Odpowiedź</summary>

**D** — w mongosh to samo pokazuje `show collections`. Bazy zwraca `getDBNames()`. (Lab 2, zad. 3)

</details>

#### find(), projekcja, sortowanie

**9.60. Czym różni się `db.customers.find()` od `db.customers.findOne()`?**

- A) `find()` zwraca kursor po pasujących dokumentach, `findOne()` zwraca jeden dokument albo `null`
- B) `find()` zwraca pierwszy dokument, `findOne()` wszystkie
- C) `findOne()` wymaga filtra po `_id`
- D) Niczym, `findOne()` to alias

<details><summary>Odpowiedź</summary>

**A** — `findOne()` zwraca sam dokument, nie kursor, więc nie da się na nim wywołać `.sort()` ani `.limit()`. (Lab 2, zad. 5–6)

</details>

**9.61. Który dokument zwraca `db.customers.findOne()` bez filtra?**

- A) Losowy dokument
- B) Ostatnio wstawiony
- C) Ten z najmniejszym `_id` zawsze
- D) Pierwszy dokument w naturalnej kolejności przechowywania (zwykle pierwszy wstawiony)

<details><summary>Odpowiedź</summary>

**D** — bez filtra i sortowania jest to pierwszy dokument w kolejności naturalnej, a ta nie jest gwarantowana. Tutaj był to Adam Kowalski. (Lab 2, zad. 6)

</details>

**9.62. Które polecenie wyświetli dokładnie trzy dokumenty z `departments`?**

- A) `db.departments.find(3)`
- B) `db.departments.find().limit(3)`
- C) `db.departments.find().skip(3)`
- D) `db.departments.findOne(3)`

<details><summary>Odpowiedź</summary>

**B** — `limit(n)` ogranicza wynik do n dokumentów, a `skip(3)` pomija trzy pierwsze. (Lab 2, zad. 7)

</details>

**9.63. Które polecenie wyświetli z `orders` tylko klucze `_id`, `cost` i `totalCost`?**

- A) `db.orders.find({ _id: 1, cost: 1, totalCost: 1 })`
- B) `db.orders.find({}, ["_id", "cost", "totalCost"])`
- C) `db.orders.find({}, { cost: 1, totalCost: 1 })`
- D) `db.orders.find().project("cost", "totalCost")`

<details><summary>Odpowiedź</summary>

**C** — projekcja to drugi argument `find`, a `_id` jest dołączane domyślnie. Wersja A to filtr, który niczego nie znajdzie. (Lab 2, zad. 8)

</details>

**9.64. Co zwróci `db.orders.find({}, { _id: 0, cost: 1 })`?**

- A) Dokumenty z samym polem `cost`, bez `_id`
- B) Błąd: nie wolno mieszać 0 i 1 w projekcji
- C) Dokumenty bez pola `cost`
- D) Tylko dokumenty, które mają `cost` równe 1

<details><summary>Odpowiedź</summary>

**A** — `_id` to jedyny wyjątek, który wolno wyłączyć w projekcji włączającej. (Lab 2, zad. 8)

</details>

**9.65. Co się stanie po `db.customers.find({}, { firstName: 1, purchase: 0 })`?**

- A) Wyświetli `firstName` bez `purchase`
- B) Wyświetli wszystkie pola
- C) Błąd: projekcja nie może mieszać włączania i wyłączania pól (poza `_id`)
- D) Wyświetli tylko `_id`

<details><summary>Odpowiedź</summary>

**C** — w projekcji albo wybierasz pola (1), albo je wykluczasz (0). Wyjątkiem jest `_id`. (Lab 2, zad. 8–9)

</details>

**9.66. Które polecenie wyświetli z `customers` wszystkie klucze poza `product` (zad. 9)?**

- A) `db.customers.find({ product: 0 })`
- B) `db.customers.find({}, { product: 0 })`
- C) `db.customers.find({}, { product: -1 })`
- D) `db.customers.find({}, { $not: "product" })`

<details><summary>Odpowiedź</summary>

**B** — projekcja wykluczająca: 0 przy polu, które ma zniknąć. Wersja A to filtr `product == 0`. (Lab 2, zad. 9)

</details>

**9.67. Dokumenty w `customers` nie mają pola `product` (mają `purchase`). Co zwróci `db.customers.find({}, { product: 0 })`?**

- A) Pusty wynik
- B) Błąd: brak pola `product`
- C) Dokumenty bez pola `purchase`
- D) Wszystkie dokumenty ze wszystkimi polami, bo wykluczone pole nie istnieje

<details><summary>Odpowiedź</summary>

**D** — wykluczenie nieistniejącego pola niczego nie zmienia. Dane z zad. 3 rzeczywiście nie mają `product` w `customers`. (Lab 2, zad. 9)

</details>

**9.68. Które polecenie posortuje `orders` malejąco po `customer`, a przy równym `customer` rosnąco po `totalCost`?**

- A) `db.orders.find().sort({ customer: -1, totalCost: 1 })`
- B) `db.orders.find().sort({ customer: 1, totalCost: -1 })`
- C) `db.orders.find().sort("customer", -1).sort("totalCost", 1)`
- D) `db.orders.find().sort({ totalCost: 1, customer: -1 })`

<details><summary>Odpowiedź</summary>

**A** — 1 oznacza rosnąco, -1 malejąco, a kolejność kluczy w obiekcie to priorytet sortowania. Wersja D sortuje najpierw po `totalCost`. (Lab 2, zad. 10)

</details>

**9.69. Co oznacza wartość `-1` w `sort({ cost: -1 })`?**

- A) Pomiń pole `cost`
- B) Sortuj malejąco po `cost`
- C) Zwróć ostatni dokument
- D) Sortuj rosnąco, ale z wartościami `null` na początku

<details><summary>Odpowiedź</summary>

**B** — `1` to kolejność rosnąca, `-1` malejąca. (Lab 2, zad. 10 i 16)

</details>

#### Operatory zapytań

**9.70. Które zapytanie zwróci zamówienia, w których `totalCost` przekracza 10000?**

- A) `db.orders.find({ totalCost: { $gte: 10000 } })`
- B) `db.orders.find({ totalCost: > 10000 })`
- C) `db.orders.find({ totalCost: { $gt: 10000 } })`
- D) `db.orders.find({ $gt: { totalCost: 10000 } })`

<details><summary>Odpowiedź</summary>

**C** — „przekracza” to ściśle większe, czyli `$gt`. `$gte` objęłoby też 10000. (Lab 2, zad. 11)

</details>

**9.71. Ile dokumentów z danych z zad. 3 zwróci `db.orders.find({ totalCost: { $gt: 10000 } })`?**

- A) 2 (o15 i o16)
- B) 3 (o15, o16 i o17)
- C) 4 (wszystkie zamówienia klienta 5)
- D) 0

<details><summary>Odpowiedź</summary>

**A** — `totalCost` powyżej 10000 mają tylko o15 (40050.50) i o16 (14662.50). o17 ma 3300, a o18 nie ma `totalCost`. (Lab 2, zad. 11)

</details>

**9.72. Które zapytanie zwróci zamówienia z `totalCost` między 5000 a 10000 (włącznie)?**

- A) `db.orders.find({ totalCost: { $between: [5000, 10000] } })`
- B) `db.orders.find({ totalCost: { $gte: 5000 } }, { totalCost: { $lte: 10000 } })`
- C) `db.orders.find({ $in: { totalCost: [5000, 10000] } })`
- D) `db.orders.find({ totalCost: { $gte: 5000, $lte: 10000 } })`

<details><summary>Odpowiedź</summary>

**D** — dwa operatory w jednym obiekcie pola dają przedział. W MongoDB nie ma `$between`, a w B drugi obiekt jest projekcją, nie warunkiem. (Lab 2, zad. 12)

</details>

**9.73. Co zwróci zapytanie z zad. 12 (`totalCost` od 5000 do 10000) na danych z zad. 3?**

- A) o17
- B) Pusty wynik, bo żadne zamówienie nie ma `totalCost` w tym przedziale
- C) o16 i o17
- D) o18

<details><summary>Odpowiedź</summary>

**B** — wartości `totalCost` to m.in. 3300, 14662.50 i 40050.50. Żadna nie leży w [5000, 10000]. o17 ma 5000–10000 w `cost` (8250), nie w `totalCost`. (Lab 2, zad. 12)

</details>

**9.74. Znajdź błąd: `db.orders.find({ totalCost: { $gte: 5000 }, totalCost: { $lte: 10000 } })`.**

- A) `$gte` nie działa na liczbach zmiennoprzecinkowych
- B) Brakuje operatora `$and`, więc zapytanie zwraca błąd składni
- C) W literale obiektu JS drugi klucz `totalCost` nadpisuje pierwszy, więc zostaje tylko warunek `$lte: 10000`
- D) Zapytanie jest poprawne

<details><summary>Odpowiedź</summary>

**C** — obiekt JS nie może mieć dwóch takich samych kluczy, więc zostaje ostatni. Poprawnie: `{ totalCost: { $gte: 5000, $lte: 10000 } }` albo `$and`. (Lab 2, zad. 12 i 17)

</details>

**9.75. Które zapytanie zwróci klientów, których `lastName` zaczyna się na literę K?**

- A) `db.customers.find({ lastName: /^K/ })`
- B) `db.customers.find({ lastName: /K$/ })`
- C) `db.customers.find({ lastName: "K*" })`
- D) `db.customers.find({ lastName: { $like: "K%" } })`

<details><summary>Odpowiedź</summary>

**A** — `^` to początek napisu, a `$` koniec. W MongoDB nie ma `$like`. Równoważny zapis to `{ lastName: { $regex: /^K/ } }`. (Lab 2, zad. 13)

</details>

**9.76. Ile dokumentów zwróci `db.customers.find({ lastName: /^K/ })` na danych z zad. 3?**

- A) 1
- B) 3
- C) 0
- D) 2

<details><summary>Odpowiedź</summary>

**D** — na K zaczynają się Adam Kowalski i Jan Kowalski. (Lab 2, zad. 13)

</details>

**9.77. Które zapytanie zwróci nazwiska zaczynające się na „k” albo „K”?**

- A) `db.customers.find({ lastName: /^K/ })`
- B) `db.customers.find({ lastName: /^k/i })`
- C) `db.customers.find({ lastName: /^[K]/ })`
- D) `db.customers.find({ lastName: /^k/g })`

<details><summary>Odpowiedź</summary>

**B** — flaga `i` wyłącza rozróżnianie wielkości liter. Bez niej `/^K/` jest wrażliwe na wielkość. To samo w Lab 3: `{ $regex: "^c", $options: "i" }`. (Lab 2, zad. 13; Lab 3, zad. 28)

</details>

**9.78. Która forma jest równoważna `{ lastName: /^K/ }`?**

- A) `{ lastName: { $regex: "^K" } }`
- B) `{ lastName: { $match: "^K" } }`
- C) `{ $regex: { lastName: "^K" } }`
- D) `{ lastName: { $text: "^K" } }`

<details><summary>Odpowiedź</summary>

**A** — `$regex` przyjmuje wzorzec jako napis albo literał `/.../`, a opcje podaje się w `$options`. (Lab 2, zad. 13)

</details>

**9.79. Które zapytanie zwróci działy z miast: Poznań, Warszawa albo Łódź?**

- A) `db.departments.find({ city: ["Poznań", "Warszawa", "Łódź"] })`
- B) `db.departments.find({ city: { $or: ["Poznań", "Warszawa", "Łódź"] } })`
- C) `db.departments.find({ city: { $in: ["Poznań", "Warszawa", "Łódź"] } })`
- D) `db.departments.find({ $in: { city: ["Poznań", "Warszawa", "Łódź"] } })`

<details><summary>Odpowiedź</summary>

**C** — `$in` sprawdza, czy wartość pola jest w liście. Wersja A szuka pola równego dokładnie całej tablicy. (Lab 2, zad. 14)

</details>

**9.80. Ile działów zwróci zapytanie z zad. 14 (Poznań, Warszawa, Łódź)?**

- A) 2
- B) 5
- C) 4
- D) 3

<details><summary>Odpowiedź</summary>

**D** — alpha i beta (Warszawa) oraz delta (Poznań). Działu w Łodzi nie ma, a gamma i lambda są w Gdyni i Gdańsku. (Lab 2, zad. 14)

</details>

**9.81. Co znaczy `db.departments.find({ city: { $nin: ["Warszawa", "Poznań"] } })`?**

- A) Działy, których miasto nie jest Warszawą ani Poznaniem (także bez pola `city`)
- B) Działy z Warszawy lub Poznania
- C) Błąd, bo `$nin` działa tylko na liczbach
- D) Działy, które mają oba miasta w tablicy

<details><summary>Odpowiedź</summary>

**A** — `$nin` to zaprzeczenie `$in` i dopasowuje też dokumenty bez tego pola. (Lab 2, zad. 14)

</details>

**9.82. Które zapytanie zwróci klientów o imieniu Jan i nazwisku Nowak?**

- A) `db.customers.find({ firstName: "Jan" } && { lastName: "Nowak" })`
- B) `db.customers.find({ firstName: "Jan", lastName: "Nowak" })`
- C) `db.customers.find({ $or: [{ firstName: "Jan" }, { lastName: "Nowak" }] })`
- D) `db.customers.find({ firstName: "Jan" }, { lastName: "Nowak" })`

<details><summary>Odpowiedź</summary>

**B** — kilka pól w jednym filtrze łączy się niejawnym AND. W D drugi argument to projekcja. (Lab 2, zad. 15)

</details>

**9.83. Co zwróci `db.customers.find({ firstName: "Jan", lastName: "Nowak" })` na danych z zad. 3?**

- A) Jana Kowalskiego i Ewę Nowak
- B) Jana Kowalskiego
- C) Pusty wynik
- D) Ewę Nowak

<details><summary>Odpowiedź</summary>

**C** — warunki łączy AND, a w danych jest Jan Kowalski i Ewa Nowak, ale nie ma Jana Nowaka. (Lab 2, zad. 15)

</details>

**9.84. Które zapytanie realizuje zad. 16: `discount < 10` LUB `cost > 5000`, sortowanie malejąco po `cost`?**

- A) `db.orders.find({ discount: { $lt: 10 }, cost: { $gt: 5000 } }).sort({ cost: -1 })`
- B) `db.orders.find({ $or: { discount: { $lt: 10 }, cost: { $gt: 5000 } } }).sort({ cost: -1 })`
- C) `db.orders.find({ $or: [{ discount: { $lt: 10 } }, { cost: { $gt: 5000 } }] }).sort({ cost: 1 })`
- D) `db.orders.find({ $or: [{ discount: { $lt: 10 } }, { cost: { $gt: 5000 } }] }).sort({ cost: -1 })`

<details><summary>Odpowiedź</summary>

**D** — `$or` przyjmuje tablicę warunków. A to AND, B ma obiekt zamiast tablicy, a C sortuje rosnąco. (Lab 2, zad. 16)

</details>

**9.85. Co zwróci zapytanie z zad. 16 na danych z zad. 3?**

- A) o15, o16, o17, bo żadne zamówienie nie ma `discount` mniejszego niż 10, a dokumentów bez `discount` warunek `$lt` nie dopasowuje
- B) o15, o16, o17 i wszystkie zamówienia bez pola `discount`
- C) Wszystkie 18 zamówień
- D) Pusty wynik

<details><summary>Odpowiedź</summary>

**A** — najmniejszy `discount` w danych to 10, a brak pola nie spełnia `$lt`. Zostaje `cost > 5000`: o15 (44500), o16 (17250) i o17 (8250). (Lab 2, zad. 16)

</details>

**9.86. Które dwa zapytania są równoważne dla zad. 17 (`discount < 10` I `cost > 5000`)?**

- A) `{ $and: [{ discount: { $lt: 10 } }, { cost: { $gt: 5000 } }] }` oraz `{ $or: [{ discount: { $lt: 10 } }, { cost: { $gt: 5000 } }] }`
- B) `{ $and: [{ discount: { $lt: 10 } }, { cost: { $gt: 5000 } }] }` oraz `{ discount: { $lt: 10 }, cost: { $gt: 5000 } }`
- C) `{ $and: { discount: { $lt: 10 }, cost: { $gt: 5000 } } }` oraz `{ discount: { $lt: 10 }, cost: { $gt: 5000 } }`
- D) `{ discount: { $lt: 10 } }, { cost: { $gt: 5000 } }` oraz `{ discount: { $lt: 10 }, cost: { $gt: 5000 } }`

<details><summary>Odpowiedź</summary>

**B** — jawny `$and` z tablicą warunków i niejawny AND przez przecinek dają ten sam wynik. W C `$and` dostaje obiekt zamiast tablicy. (Lab 2, zad. 17)

</details>

**9.87. Co zwróci zapytanie z zad. 17 (`discount < 10` I `cost > 5000`) na danych z zad. 3?**

- A) o15, o16, o17
- B) o18
- C) Pusty wynik
- D) Wszystkie zamówienia bez rabatu

<details><summary>Odpowiedź</summary>

**C** — żaden dokument nie spełnia `discount < 10`, więc AND z drugim warunkiem nic nie zwraca. (Lab 2, zad. 17)

</details>

**9.88. Kiedy jawny `$and` jest naprawdę potrzebny?**

- A) Zawsze, gdy filtr ma więcej niż jedno pole
- B) Gdy trzeba połączyć dwa wyrażenia z tym samym kluczem, np. dwa osobne `$or`
- C) Tylko przy sortowaniu
- D) Nigdy, bo MongoDB go nie obsługuje

<details><summary>Odpowiedź</summary>

**B** — `{ $or: [...], $or: [...] }` nie zadziała, bo obiekt JS zachowa tylko drugi klucz. Trzeba wtedy napisać `{ $and: [{ $or: [...] }, { $or: [...] }] }`. W pozostałych przypadkach wystarczy przecinek. (Lab 2, zad. 17)

</details>

**9.89. Które zapytanie zwróci zamówienia bez pola `totalCost`?**

- A) `db.orders.find({ totalCost: null, $exists: true })`
- B) `db.orders.find({ totalCost: 0 })`
- C) `db.orders.find({ $missing: "totalCost" })`
- D) `db.orders.find({ totalCost: { $exists: false } })`

<details><summary>Odpowiedź</summary>

**D** — `$exists: false` dopasowuje dokumenty bez pola. W danych są to o6 i o18. (Lab 2, operatory zapytań)

</details>

**9.90. Które zapytanie zwróci działy, które w tablicy `sections` mają element `"Sales"`?**

- A) `db.departments.find({ sections: "Sales" })`
- B) `db.departments.find({ sections: ["Sales"] })`
- C) `db.departments.find({ "sections[]": "Sales" })`
- D) `db.departments.find({ sections: { $eq: ["Sales"] } })`

<details><summary>Odpowiedź</summary>

**A** — równość z wartością skalarną na polu tablicowym sprawdza, czy tablica zawiera ten element. Wynik to alpha i lambda. B i D szukają tablicy równej dokładnie `["Sales"]`. (Lab 2, struktura departments)

</details>

**9.91. Które zapytanie zwróci działy przy ulicy „Pierwsza” (pole zagnieżdżone `address.street`)?**

- A) `db.departments.find({ address.street: "Pierwsza" })`
- B) `db.departments.find({ address: { street: "Pierwsza" } })`
- C) `db.departments.find({ "address.street": "Pierwsza" })`
- D) `db.departments.find({ address: "Pierwsza" })`

<details><summary>Odpowiedź</summary>

**C** — notacja kropkowa wymaga cudzysłowu wokół klucza. A to błąd składni JS, a B szuka poddokumentu równego dokładnie `{ street: "Pierwsza" }`. Wynik to beta i gamma. (Lab 2, struktura departments; Lab 3, zad. 18)

</details>

#### Aktualizacja i usuwanie (northwind)

**9.92. Które polecenie doda klucz `isValid: true` do jednego klienta (zad. 18)?**

- A) `db.customers.updateOne({ _id: 1 }, { isValid: true })`
- B) `db.customers.updateOne({ _id: 1 }, { $set: { isValid: true } })`
- C) `db.customers.insertOne({ _id: 1, isValid: true })`
- D) `db.customers.update({ _id: 1 }, { $add: { isValid: true } })`

<details><summary>Odpowiedź</summary>

**B** — `$set` dodaje pole, gdy go nie ma, albo zmienia jego wartość. A bez operatora zwróci błąd, C to duplikat `_id`, a `$add` nie jest operatorem aktualizacji. (Lab 2, zad. 18)

</details>

**9.93. Co zwróci mongosh dla `db.customers.updateOne({ _id: 1 }, { isValid: true })`?**

- A) Zastąpi dokument dokumentem `{ _id: 1, isValid: true }`
- B) Doda pole `isValid` i zostawi resztę
- C) Nic nie zmieni i zwróci `modifiedCount: 0`
- D) Błąd: dokument aktualizacji musi zawierać operatory (np. `$set`)

<details><summary>Odpowiedź</summary>

**D** — `updateOne`/`updateMany` przyjmują operatory aktualizacji albo pipeline. Całą zawartość dokumentu zastępuje `replaceOne`. (Lab 2, zad. 18 i 25.2)

</details>

**9.94. Które polecenie realizuje zad. 19 (status „A” dla wszystkich działów w Warszawie, a jeśli ich nie ma, utwórz dokument)?**

- A) `db.departments.updateMany({ city: "Warszawa" }, { $set: { status: "A" } }, { upsert: true })`
- B) `db.departments.updateOne({ city: "Warszawa" }, { $set: { status: "A" } }, { upsert: true })`
- C) `db.departments.updateMany({ city: "Warszawa" }, { $set: { status: "A", upsert: true } })`
- D) `db.departments.updateMany({ city: "Warszawa", upsert: true }, { status: "A" })`

<details><summary>Odpowiedź</summary>

**A** — `upsert` podaje się w trzecim argumencie (opcjach). B zmieni tylko jeden dokument, a C doda pole o nazwie `upsert`. (Lab 2, zad. 19)

</details>

**9.95. Ile dokumentów dopasuje i zmieni polecenie z zad. 19 przy pierwszym uruchomieniu na danych z zad. 3?**

- A) `matchedCount: 1`, `modifiedCount: 1`
- B) `matchedCount: 0`, utworzono nowy dokument (upsert)
- C) `matchedCount: 2`, `modifiedCount: 2`, bez upsertu
- D) `matchedCount: 5`, `modifiedCount: 2`

<details><summary>Odpowiedź</summary>

**C** — w Warszawie są alpha i beta. Upsert działa tylko wtedy, gdy nic nie pasuje. (Lab 2, zad. 19)

</details>

**9.96. Gdyby w `departments` nie było żadnego działu w Warszawie, jak wyglądałby dokument utworzony przez upsert z zad. 19?**

- A) `{ _id: ObjectId(...), status: "A" }`
- B) `{ _id: ObjectId(...), city: "Warszawa", status: "A" }`
- C) `{ city: "Warszawa" }`
- D) Dokument nie powstałby, bo `updateMany` nie obsługuje upsertu

<details><summary>Odpowiedź</summary>

**B** — nowy dokument dostaje pola równości z filtra, pola z `$set` i nowe ObjectId. `updateMany` z upsertem tworzy jeden dokument. (Lab 2, zad. 19)

</details>

**9.97. Polecenie z zad. 19 uruchomiono drugi raz. Co zwróci?**

- A) `matchedCount: 2`, `modifiedCount: 0`, bo wartość `status` już wynosi `"A"`
- B) `matchedCount: 2`, `modifiedCount: 2`
- C) Błąd duplikatu klucza
- D) Utworzy dwa nowe dokumenty

<details><summary>Odpowiedź</summary>

**A** — `$set` z tą samą wartością nie zmienia dokumentu, więc `modifiedCount` wynosi 0. (Lab 2, zad. 19)

</details>

**9.98. Zad. 20: najpierw `db.orders.deleteOne({ customer: 5 })`, potem `db.orders.deleteMany({ customer: 5 })`. Jakie będą `deletedCount`?**

- A) 4, potem 0
- B) 1, potem 4
- C) 1, potem 3
- D) 0, potem 4

<details><summary>Odpowiedź</summary>

**C** — klient 5 ma 4 zamówienia (o15–o18). `deleteOne` usuwa jedno, a `deleteMany` pozostałe trzy. (Lab 2, zad. 20)

</details>

**9.99. Który dokument usunie `db.orders.deleteOne({ customer: 5 })`?**

- A) Ostatnio wstawiony z `customer: 5`
- B) Pierwszy pasujący w kolejności naturalnej (bez gwarancji, który to będzie)
- C) Ten z najwyższym `cost`
- D) Losowy dokument z całej kolekcji

<details><summary>Odpowiedź</summary>

**B** — `deleteOne` usuwa pierwszy znaleziony dokument. Żeby usunąć konkretny, filtruj po `_id`. (Lab 2, zad. 20)

</details>

**9.100. Co robi `db.orders.deleteMany({})`?**

- A) Usuwa kolekcję `orders`
- B) Nic, pusty filtr niczego nie dopasowuje
- C) Usuwa pierwszy dokument
- D) Usuwa wszystkie dokumenty z `orders`, ale kolekcja i indeksy zostają

<details><summary>Odpowiedź</summary>

**D** — pusty filtr pasuje do wszystkich dokumentów, a kolekcję usuwa `drop()`. (Lab 2, zad. 20 i 25.6)

</details>

#### Indeksy

**9.101. Które polecenie wyświetli indeksy kolekcji `orders`?**

- A) `db.orders.getIndexes()`
- B) `db.orders.showIndexes()`
- C) `show indexes orders`
- D) `db.getIndexes('orders')`

<details><summary>Odpowiedź</summary>

**A** — `getIndexes()` zwraca tablicę opisów indeksów (klucz, nazwa, wersja). (Lab 2, zad. 21)

</details>

**9.102. Jakie indeksy ma świeża kolekcja `customers` przed zad. 22?**

- A) Żadnych
- B) Indeksy na wszystkich polach
- C) Tylko indeks `_id_` na polu `_id`
- D) `_id_` i `firstName_1`

<details><summary>Odpowiedź</summary>

**C** — MongoDB tworzy automatycznie unikalny indeks na `_id` w każdej kolekcji. (Lab 2, zad. 21)

</details>

**9.103. Które polecenie tworzy indeks o nazwie `klienci` na `firstName` i `lastName` (rosnąco)?**

- A) `db.customers.createIndex({ name: "klienci", firstName: 1, lastName: 1 })`
- B) `db.customers.createIndex("klienci", { firstName: 1, lastName: 1 })`
- C) `db.customers.createIndex({ firstName: 1 }, { lastName: 1 }, { name: "klienci" })`
- D) `db.customers.createIndex({ firstName: 1, lastName: 1 }, { name: "klienci" })`

<details><summary>Odpowiedź</summary>

**D** — pierwszy argument to klucze indeksu, drugi to opcje, w tym `name`. W A `name` byłoby polem indeksu. (Lab 2, zad. 22)

</details>

**9.104. Jaką domyślną nazwę dostanie indeks z `db.customers.createIndex({ phone: -1 })`?**

- A) `phone`
- B) `phone_-1`
- C) `phone_desc`
- D) `idx_phone`

<details><summary>Odpowiedź</summary>

**B** — domyślna nazwa to `pole_kierunek` połączone podkreśleniami. Dlatego w Lab 3 indeks na `name` nazywa się `name_1`. (Lab 2, zad. 22)

</details>

**9.105. Które polecenie NIE usunie indeksu `{ phone: -1 }` z zad. 22?**

- A) `db.customers.dropIndex("phone_-1")`
- B) `db.customers.dropIndex({ phone: -1 })`
- C) `db.customers.dropIndex("phone")`
- D) `db.customers.dropIndexes("phone_-1")`

<details><summary>Odpowiedź</summary>

**C** — indeks wskazuje się nazwą (`"phone_-1"`) albo specyfikacją klucza. Indeksu o nazwie `"phone"` nie ma, więc będzie błąd. (Lab 2, zad. 23)

</details>

**9.106. Co się stanie po `db.customers.dropIndex("_id_")`?**

- A) Błąd: indeksu na `_id` nie można usunąć
- B) Indeks zostanie usunięty, a `_id` przestanie być unikalne
- C) Usunie wszystkie indeksy
- D) Usunie pole `_id` z dokumentów

<details><summary>Odpowiedź</summary>

**A** — indeks `_id_` jest obowiązkowy. `dropIndexes()` usuwa wszystkie indeksy poza nim. (Lab 2, zad. 23)

</details>

**9.107. Indeks złożony `klienci` to `{ firstName: 1, lastName: 1 }`. Które zapytanie może go użyć jako prefiksu?**

- A) `db.customers.find({ lastName: "Nowak" })`
- B) `db.customers.find({ phone: "111 760 760" })`
- C) `db.customers.find({ email: /pl$/ })`
- D) `db.customers.find({ firstName: "Jan" })`

<details><summary>Odpowiedź</summary>

**D** — indeks złożony obsługuje zapytania po swoim prefiksie (`firstName` albo `firstName` + `lastName`). Samo `lastName` nie jest prefiksem. (Lab 2, zad. 22)

</details>

#### sort(), skip(), limit() (zad. 24)

**9.108. Czy kolejność wywołań `sort()`, `skip()` i `limit()` na kursorze `find()` zmienia wynik?**

- A) Tak, metody wykonują się w kolejności zapisu
- B) Nie, serwer zawsze stosuje najpierw sort, potem skip, a na końcu limit
- C) Tak, ale tylko dla `limit()`
- D) Nie, ale tylko gdy kolekcja ma indeks

<details><summary>Odpowiedź</summary>

**B** — `find().limit(3).skip(2).sort({ cost: -1 })` daje ten sam wynik co `find().sort({ cost: -1 }).skip(2).limit(3)`. (Lab 2, zad. 24)

</details>

**9.109. Co zwróci `db.orders.find().sort({ cost: -1 }).skip(2).limit(3)` na pełnych danych z zad. 3 (przed usunięciem w zad. 20)?**

- A) o15, o16, o17
- B) o18, o7, o6
- C) o17, o18, o7
- D) o16, o17, o18

<details><summary>Odpowiedź</summary>

**C** — malejąco po `cost`: o15 (44500), o16 (17250), o17 (8250), o18 (4800), o7 (1950)… Pomijamy dwa pierwsze i bierzemy trzy kolejne. (Lab 2, zad. 24)

</details>

**9.110. A jak jest w potoku agregacji? Czym różni się `[{ $limit: 3 }, { $sort: { cost: -1 } }]` od `[{ $sort: { cost: -1 } }, { $limit: 3 }]`?**

- A) Pierwszy sortuje trzy dowolne dokumenty, drugi zwraca trzy najdroższe; w potoku kolejność etapów ma znaczenie
- B) Niczym, optymalizator zawsze przestawia etapy
- C) Pierwszy zwraca błąd, bo `$limit` nie może być pierwszy
- D) Drugi zwraca błąd, bo `$sort` musi być ostatni

<details><summary>Odpowiedź</summary>

**A** — etapy potoku działają po kolei na wyniku poprzedniego. Inaczej jest w kursorze `find()`. (Lab 2, zad. 24; Lab 3, zad. 14)

</details>

**9.111. Paginacja po 5 dokumentów: które polecenie zwróci trzecią stronę zamówień posortowanych po `_id`?**

- A) `db.orders.find().sort({ _id: 1 }).skip(15).limit(5)`
- B) `db.orders.find().sort({ _id: 1 }).skip(3).limit(5)`
- C) `db.orders.find().sort({ _id: 1 }).limit(10).skip(5)`
- D) `db.orders.find().sort({ _id: 1 }).skip(10).limit(5)`

<details><summary>Odpowiedź</summary>

**D** — strona 3 przy 5 na stronę zaczyna się po pominięciu (3 − 1) × 5 = 10 dokumentów. (Lab 2, zad. 24)

</details>

#### Baza Politechnika i kolekcja capped

**9.112. W mongosh wykonujesz `use Politechnika`, a potem `show dbs`. Czy `Politechnika` jest na liście?**

- A) Tak, z rozmiarem 0
- B) Nie; pojawi się, gdy powstanie w niej pierwsza kolekcja albo dokument
- C) Tak, ale oznaczona jako „empty”
- D) Nie, bo nazwy baz muszą być pisane małymi literami

<details><summary>Odpowiedź</summary>

**B** — `use` niczego nie zapisuje. Bazę widać dopiero po `createCollection('Students')` albo po pierwszym insercie. (Lab 2, zad. 25)

</details>

**9.113. Które polecenie tworzy kolekcję `Students` ograniczoną do 1 MB lub 100 dokumentów?**

- A) `db.createCollection('Students', { capped: true, size: 1048576, max: 100 })`
- B) `db.createCollection('Students', { capped: true, max: 100 })`
- C) `db.createCollection('Students', { size: "1MB", maxDocs: 100 })`
- D) `db.Students.capped({ size: 1048576, max: 100 })`

<details><summary>Odpowiedź</summary>

**A** — `capped: true` wymaga `size` w bajtach, a `max` jest opcjonalne. B nie ma wymaganego `size`. (Lab 2, zad. 25.1)

</details>

**9.114. W jakich jednostkach podaje się `size` kolekcji capped i ile to jest 1 MB?**

- A) W kilobajtach; 1024
- B) W megabajtach; 1
- C) W bajtach; 1048576
- D) W liczbie dokumentów; 100

<details><summary>Odpowiedź</summary>

**C** — `size` to maksymalny rozmiar w bajtach: 1 MB = 1024 × 1024 = 1048576. (Lab 2, zad. 25.1)

</details>

**9.115. Co się dzieje po wstawieniu 101. dokumentu do kolekcji capped z `max: 100`?**

- A) Insert kończy się błędem „collection full”
- B) Kolekcja automatycznie się powiększa
- C) Nowy dokument jest odrzucany bez błędu
- D) MongoDB usuwa najstarszy dokument i zapisuje nowy, bez błędu

<details><summary>Odpowiedź</summary>

**D** — kolekcja capped działa jak bufor cykliczny: najstarsze dokumenty ustępują nowym. Tak samo po osiągnięciu limitu `size`. (Lab 2, zad. 25.1)

</details>

**9.116. Do kolekcji capped z `max: 100` wstawiono w pętli dokumenty `{ nr: 1 }` … `{ nr: 105 }`. Co zwrócą `countDocuments()` i `find().limit(1)`?**

- A) 105 oraz `{ nr: 1 }`
- B) 100 oraz `{ nr: 6 }`
- C) 100 oraz `{ nr: 1 }`
- D) 100 oraz `{ nr: 105 }`

<details><summary>Odpowiedź</summary>

**B** — dokumenty 1–5 zostały wyparte, zostało 100, a kolejność naturalna zaczyna się od najstarszego, czyli nr 6. (Lab 2, zad. 25.1)

</details>

**9.117. Kolekcja capped ma `size: 1048576` i `max: 100`. Co się stanie, gdy 1 MB zapełni się wcześniej niż przy 100 dokumentach?**

- A) MongoDB zacznie usuwać najstarsze dokumenty już przy limicie rozmiaru
- B) MongoDB zwiększy `size`, żeby zmieścić 100 dokumentów
- C) Insert zwróci błąd do czasu osiągnięcia 100 dokumentów
- D) Limit `size` jest ignorowany, gdy podano `max`

<details><summary>Odpowiedź</summary>

**A** — limit rozmiaru ma pierwszeństwo przed `max`, więc decyduje ten, który zostanie osiągnięty pierwszy. (Lab 2, zad. 25.1)

</details>

**9.118. Które zdanie o kolekcjach capped jest prawdziwe według dokumentacji MongoDB?**

- A) Etap `$out` może zapisywać wynik do kolekcji capped
- B) Kolekcje capped da się shardować
- C) Kolekcja capped nie ma indeksu `_id`
- D) Etap `$out` nie może zapisywać do kolekcji capped, a do wygasania danych dokumentacja zaleca rozważyć indeks TTL

<details><summary>Odpowiedź</summary>

**D** — dokumentacja wymienia jako ograniczenia brak shardowania, brak zapisu w transakcjach i brak `$out` do kolekcji capped. Kolekcje capped mają domyślnie indeks `_id`. (Lab 2, zad. 25.1; Lab 3, zad. 21)

</details>

**9.119. Czym różni się `createdAt: new Date()` od `createdAt: Date()` w mongosh?**

- A) Niczym
- B) `new Date()` zapisuje typ Date (w mongosh `ISODate(...)`), a `Date()` bez `new` zwraca zwykły napis
- C) `Date()` zapisuje datę w UTC, `new Date()` w czasie lokalnym
- D) `new Date()` zapisuje tylko datę bez godziny

<details><summary>Odpowiedź</summary>

**B** — w JS `Date()` wywołane jako funkcja zwraca string, więc nie da się po nim porządnie sortować ani porównywać dat. (Lab 2, zad. 25.1)

</details>

**9.120. Student ma pole `emails: { university: "...", private: "..." }`. Które zapytanie znajdzie studenta po prywatnym adresie?**

- A) `db.Students.find({ emails: "tomek.ziel@onet.pl" })`
- B) `db.Students.find({ private: "tomek.ziel@onet.pl" })`
- C) `db.Students.find({ "emails.private": "tomek.ziel@onet.pl" })`
- D) `db.Students.find({ emails: { $private: "tomek.ziel@onet.pl" } })`

<details><summary>Odpowiedź</summary>

**C** — do pól poddokumentu odwołujemy się notacją kropkową w cudzysłowie. (Lab 2, zad. 25.1)

</details>

**9.121. Pole `interests` to tablica napisów. Które zapytanie znajdzie studentów zainteresowanych rowerem?**

- A) `db.Students.find({ interests: "rower" })`
- B) `db.Students.find({ interests: { $in: "rower" } })`
- C) `db.Students.find({ "interests.rower": true })`
- D) `db.Students.find({ interests: ["rower"] })`

<details><summary>Odpowiedź</summary>

**A** — wartość skalarna na polu tablicowym pasuje, gdy tablica zawiera ten element. B jest błędne, bo `$in` wymaga tablicy, a D pasuje tylko do tablicy `["rower"]`. (Lab 2, zad. 25.1)

</details>

#### updateMany, updateOne, replaceOne, $set, $unset, $rename, upsert

**9.122. Czym różni się `updateMany` od `updateOne`?**

- A) `updateMany` wymaga `upsert`
- B) `updateOne` zmienia pierwszy pasujący dokument, `updateMany` wszystkie pasujące
- C) `updateOne` zastępuje cały dokument, `updateMany` używa `$set`
- D) `updateMany` działa tylko z pustym filtrem

<details><summary>Odpowiedź</summary>

**B** — oba przyjmują filtr, operatory aktualizacji i opcje. Różni je liczba zmienianych dokumentów. (Lab 2, zad. 25.2)

</details>

**9.123. Czym `replaceOne` różni się od `updateOne`?**

- A) `replaceOne` zastępuje całą treść dokumentu nowym dokumentem (bez operatorów), zachowując `_id`; pola, których nie podano, znikają
- B) `replaceOne` zmienia wiele dokumentów
- C) `replaceOne` wymaga operatora `$set`
- D) `replaceOne` zmienia też `_id` na nowe ObjectId

<details><summary>Odpowiedź</summary>

**A** — dlatego w zad. 25.2 przy `replaceOne` trzeba podać wszystkie pola Zielińskiego. Inaczej by zniknęły. (Lab 2, zad. 25.2)

</details>

**9.124. Co się stanie po `db.Students.replaceOne({ lastName: "Zieliński" }, { $set: { major: "Cyberbezpieczeństwo" } })`?**

- A) Zmieni tylko pole `major`
- B) Zastąpi dokument dokumentem `{ $set: {...} }`
- C) Błąd: dokument zastępujący nie może zawierać operatorów aktualizacji
- D) Utworzy nowy dokument

<details><summary>Odpowiedź</summary>

**C** — `replaceOne` przyjmuje zwykły dokument. Do zmiany jednego pola służy `updateOne` z `$set`. (Lab 2, zad. 25.2)

</details>

**9.125. Dokument przed zmianą: `{ _id: 7, firstName: "Tomasz", lastName: "Zieliński", major: "Informatyka", birthYear: 2001 }`. Jak wygląda po `db.Students.replaceOne({ _id: 7 }, { lastName: "Zieliński", major: "Cyber" })`?**

- A) `{ _id: 7, firstName: "Tomasz", lastName: "Zieliński", major: "Cyber", birthYear: 2001 }`
- B) `{ lastName: "Zieliński", major: "Cyber" }` z nowym ObjectId
- C) `{ _id: 7, lastName: "Zieliński", major: "Cyber" }`
- D) Bez zmian, bo brakuje `$set`

<details><summary>Odpowiedź</summary>

**C** — `replaceOne` zachowuje `_id`, a resztę zastępuje nowym dokumentem. `firstName` i `birthYear` znikają. (Lab 2, zad. 25.2)

</details>

**9.126. Które polecenie doda wszystkim studentom pole `updatedAt` z bieżącą datą?**

- A) `db.Students.updateMany({}, { $set: { updatedAt: new Date() } })`
- B) `db.Students.updateOne({}, { $set: { updatedAt: new Date() } })`
- C) `db.Students.updateMany({ updatedAt: new Date() })`
- D) `db.Students.updateMany({}, { updatedAt: new Date() })`

<details><summary>Odpowiedź</summary>

**A** — pusty filtr `{}` pasuje do wszystkich dokumentów, a `$set` dodaje pole. B zmieni jeden dokument, a D nie ma operatora. (Lab 2, zad. 25.3)

</details>

**9.127. Które polecenie usunie pole `updatedAt` ze wszystkich dokumentów?**

- A) `db.Students.updateMany({}, { $set: { updatedAt: null } })`
- B) `db.Students.deleteMany({ updatedAt: { $exists: true } })`
- C) `db.Students.updateMany({}, { $delete: "updatedAt" })`
- D) `db.Students.updateMany({}, { $unset: { updatedAt: "" } })`

<details><summary>Odpowiedź</summary>

**D** — `$unset` usuwa pole. A zostawia pole z wartością `null`, a B kasuje całe dokumenty. (Lab 2, zad. 25.3)

</details>

**9.128. Czy wartość podana w `$unset` (np. `""`, `1` albo `true`) ma znaczenie?**

- A) Tak, `""` czyści pole, a `1` je usuwa
- B) Nie, pole jest usuwane niezależnie od podanej wartości
- C) Tak, wartość musi być równa obecnej wartości pola
- D) Tak, tylko `true` działa

<details><summary>Odpowiedź</summary>

**B** — dokumentacja mówi, że wartość w wyrażeniu `$unset` nie wpływa na operację. Zwyczajowo pisze się `""`. (Lab 2, zad. 25.3)

</details>

**9.129. Które polecenie zmieni nazwę pola `birthYear` na `yearOfBirth` we wszystkich dokumentach?**

- A) `db.Students.updateMany({}, { $rename: { yearOfBirth: "birthYear" } })`
- B) `db.Students.updateMany({}, { $rename: { birthYear: "yearOfBirth" } })`
- C) `db.Students.renameField("birthYear", "yearOfBirth")`
- D) `db.Students.updateMany({}, { $set: { birthYear: "yearOfBirth" } })`

<details><summary>Odpowiedź</summary>

**B** — składnia to `{ $rename: { <stara_nazwa>: "<nowa_nazwa>" } }`. A działa w odwrotną stronę, a D wpisuje napis jako wartość. (Lab 2, zad. 25.4)

</details>

**9.130. Co robi `$rename` w dokumentach, które nie mają pola `birthYear` (np. dodanych przez upsert)?**

- A) Tworzy w nich pole `yearOfBirth: null`
- B) Zwraca błąd i przerywa `updateMany`
- C) Nic; dokumenty bez tego pola zostają bez zmian
- D) Usuwa te dokumenty

<details><summary>Odpowiedź</summary>

**C** — `$rename` działa tylko tam, gdzie pole istnieje. (Lab 2, zad. 25.4)

</details>

**9.131. W kolekcji nie ma studenta o nazwisku Mazur. Co zrobi poniższe polecenie?**

```js
db.Students.updateOne(
  { lastName: "Mazur" },
  { $set: { firstName: "Paweł", faculty: "Wydział Mechaniczny" } },
  { upsert: true }
);
```

- A) Nic, bo nie ma pasującego dokumentu
- B) Błąd, bo `updateOne` nie obsługuje upsertu
- C) Utworzy dokument `{ firstName: "Paweł", faculty: "Wydział Mechaniczny" }` bez `lastName`
- D) Utworzy dokument z nowym `_id` oraz polami `lastName: "Mazur"`, `firstName: "Paweł"` i `faculty: "Wydział Mechaniczny"`

<details><summary>Odpowiedź</summary>

**D** — przy upsercie pola równości z filtra trafiają do nowego dokumentu razem z polami z `$set`. Wynik ma `upsertedCount: 1` i `upsertedId`. (Lab 2, zad. 25.5)

</details>

**9.132. Polecenie z poprzedniego pytania uruchomiono drugi raz (Mazur już istnieje). Co się stanie?**

- A) Powstanie drugi dokument Mazura
- B) Istniejący dokument zostanie dopasowany; nowy nie powstanie
- C) Błąd duplikatu klucza
- D) Dokument Mazura zostanie usunięty

<details><summary>Odpowiedź</summary>

**B** — upsert wstawia tylko wtedy, gdy nic nie pasuje do filtra. Przy tych samych wartościach `modifiedCount` wyniesie 0. (Lab 2, zad. 25.5)

</details>

**9.133. W którym polu wyniku `updateOne` z `{ upsert: true }` widać, że powstał nowy dokument?**

- A) `upsertedId` (i `upsertedCount: 1`)
- B) `insertedId`
- C) `modifiedCount: 1`
- D) `deletedCount: 0`

<details><summary>Odpowiedź</summary>

**A** — przy upsercie `matchedCount` i `modifiedCount` wynoszą 0, a `upsertedId` zawiera `_id` nowego dokumentu. (Lab 2, zad. 19 i 25.5)

</details>

**9.134. Które polecenie usunie wszystkich studentów Wydziału Zarządzania?**

- A) `db.Students.deleteOne({ faculty: "Wydział Zarządzania" })`
- B) `db.Students.drop({ faculty: "Wydział Zarządzania" })`
- C) `db.Students.deleteMany({ faculty: "Wydział Zarządzania" })`
- D) `db.Students.remove({ faculty: "Wydział Zarządzania" }, { justOne: true })`

<details><summary>Odpowiedź</summary>

**C** — `deleteMany` usuwa wszystkie pasujące dokumenty, a `deleteOne` tylko jeden. `drop` usuwa całą kolekcję. (Lab 2, zad. 25.6)

</details>

**9.135. Jak sprawdzić, że `deleteOne({ lastName: "Mazur" })` zadziałało?**

- A) `db.Students.find({ lastName: "Mazur" })` zwraca pusty wynik (albo `deletedCount: 1` w wyniku `deleteOne`)
- B) `db.Students.getIndexes()` nie pokazuje `Mazur`
- C) `show dbs` pokazuje mniejszy rozmiar
- D) Nie da się tego sprawdzić

<details><summary>Odpowiedź</summary>

**A** — po usunięciu zapytanie o ten dokument nic nie zwraca, a wynik operacji podaje `deletedCount`. (Lab 2, zad. 25.6)

</details>

**9.136. Które polecenie wstawi studenta z własnym identyfikatorem 1001?**

- A) `db.Students.insertOne({ id: 1001, firstName: "Anna" })`
- B) `db.Students.insertOne({ firstName: "Anna" }, { _id: 1001 })`
- C) `db.Students.insertOne({ _id: ObjectId(1001), firstName: "Anna" })`
- D) `db.Students.insertOne({ _id: 1001, firstName: "Anna" })`

<details><summary>Odpowiedź</summary>

**D** — własne `_id` wpisuje się jako pole dokumentu. Pole `id` bez podkreślenia to zwykłe pole, a `_id` i tak zostanie wygenerowane. (Lab 2, zad. 25.7)

</details>

**9.137. Jakiego typu NIE może mieć wartość pola `_id`?**

- A) Liczba całkowita, np. `1001`
- B) Napis, np. `"o1"`
- C) Tablica
- D) Poddokument

<details><summary>Odpowiedź</summary>

**C** — `_id` może być dowolnego typu BSON poza tablicą (oraz wyrażeniem regularnym i `undefined`). W northwind są `_id` liczbowe i napisowe. (Lab 2, zad. 3 i 25.7)

</details>

#### bulkWrite

**9.138. Która operacja `bulkWrite` poprawnie wstawia dokument?**

- A) `{ insertOne: { document: { _id: 1002, firstName: "Piotr" } } }`
- B) `{ insertOne: { _id: 1002, firstName: "Piotr" } }`
- C) `{ insert: { doc: { _id: 1002, firstName: "Piotr" } } }`
- D) `{ insertOne: [{ _id: 1002, firstName: "Piotr" }] }`

<details><summary>Odpowiedź</summary>

**A** — w `bulkWrite` dokument podaje się w kluczu `document`. (Lab 2, zad. 25.8)

</details>

**9.139. Która operacja `bulkWrite` poprawnie zmienia jeden dokument?**

- A) `{ updateOne: { filter: { _id: 1001 }, replacement: { major: "Chemia" } } }`
- B) `{ updateOne: { filter: { _id: 1001 }, update: { $set: { major: "Chemia" } } } }`
- C) `{ updateOne: [{ _id: 1001 }, { $set: { major: "Chemia" } }] }`
- D) `{ update: { _id: 1001, $set: { major: "Chemia" } } }`

<details><summary>Odpowiedź</summary>

**B** — `updateOne` w `bulkWrite` ma klucze `filter` i `update`. Klucz `replacement` należy do `replaceOne`. (Lab 2, zad. 25.8)

</details>

**9.140. Której operacji NIE obsługuje `db.collection.bulkWrite()`?**

- A) `replaceOne`
- B) `deleteMany`
- C) `updateMany`
- D) `find`

<details><summary>Odpowiedź</summary>

**D** — `bulkWrite` obsługuje tylko zapisy: `insertOne`, `updateOne`, `updateMany`, `replaceOne`, `deleteOne` i `deleteMany`. (Lab 2, zad. 25.8; wykład)

</details>

**9.141. `bulkWrite` w trybie domyślnym ma 4 operacje, a druga kończy się błędem duplikatu `_id`. Co się stanie z trzecią i czwartą?**

- A) Wykonają się, bo `bulkWrite` zawsze wykonuje wszystko
- B) Pierwsza zostanie wycofana
- C) Nie wykonają się, bo domyślnie `ordered: true` przerywa na pierwszym błędzie
- D) Wykonają się dwa razy

<details><summary>Odpowiedź</summary>

**C** — przy `ordered: true` operacje idą po kolei i zatrzymują się na błędzie. Przy `{ ordered: false }` pozostałe by się wykonały. Wcześniejsze operacje nie są wycofywane. (Lab 2, zad. 25.8)

</details>

**9.142. Czego dotyczy jedno wywołanie `bulkWrite`?**

- A) Jednej kolekcji, na której je wywołano
- B) Wszystkich kolekcji w bazie
- C) Wszystkich baz na serwerze
- D) Jednego dokumentu

<details><summary>Odpowiedź</summary>

**A** — wykład podkreśla, że zapis zbiorczy dotyczy pojedynczej kolekcji (`db.Students.bulkWrite([...])`). (Lab 2, zad. 25.8; wykład)

</details>

### Lab 3 — Database Tools, kopie zapasowe, explain i agregacja

#### mongoimport, mongoexport, mongodump, mongorestore, docker cp

**9.143. Czym są MongoDB Command Line Database Tools pobierane w zad. 1?**

- A) Częścią mongosh, uruchamianą poleceniami wewnątrz powłoki
- B) Wtyczką do Compass
- C) Osobnym pakietem programów (m.in. `mongoimport`, `mongoexport`, `mongodump` i `mongorestore`), pobieranym oddzielnie od serwera
- D) Sterownikiem do VS Code

<details><summary>Odpowiedź</summary>

**C** — od MongoDB 4.4 narzędzia te są wydawane osobno i trzeba je pobrać ze strony Database Tools. (Lab 3, zad. 1)

</details>

**9.144. Gdzie uruchamia się polecenie `mongoimport`?**

- A) W zakładce Aggregations w Compass
- B) W mongosh, po `use airbnb`
- C) W Playground VS Code
- D) W wierszu poleceń systemu (cmd lub PowerShell) albo w powłoce kontenera, a nie w mongosh

<details><summary>Odpowiedź</summary>

**D** — `mongoimport` to osobny program wykonywalny. Wpisany w mongosh zwróci błąd składni. (Lab 3, zad. 2)

</details>

**9.145. Które polecenie zaimportuje plik `listingsAndReviews.json` do bazy `airbnb` i kolekcji `listingsAndReviews`?**

- A) `mongoimport airbnb.listingsAndReviews < listingsAndReviews.json`
- B) `mongorestore --db airbnb --collection listingsAndReviews .\sample_airbnb\listingsAndReviews.json`
- C) `mongosh --import .\sample_airbnb\listingsAndReviews.json --db airbnb`
- D) `mongoimport --db airbnb --collection listingsAndReviews --file .\sample_airbnb\listingsAndReviews.json`

<details><summary>Odpowiedź</summary>

**D** — `--db` wskazuje bazę, `--collection` kolekcję, a `--file` plik JSON. `mongorestore` wczytuje zrzuty BSON, a nie pliki JSON. (Lab 3, zad. 2)

</details>

**9.146. Jaką nazwę kolekcji przyjmie `mongoimport --db weather --file data.json`, gdy pominiesz `--collection`?**

- A) `weather`
- B) `data`, czyli nazwę pliku bez rozszerzenia
- C) `test`
- D) `import`

<details><summary>Odpowiedź</summary>

**B** — bez `--collection` mongoimport bierze nazwę pliku bez rozszerzenia. Treść zadań mówi to samo: „nazwa kolekcji = nazwa pliku bez rozszerzenia”. (Lab 3, zad. 2–4)

</details>

**9.147. Kiedy przy `mongoimport` trzeba dodać opcję `--jsonArray`?**

- A) Gdy import idzie do kontenera
- B) Gdy dokumenty mają pola tablicowe, np. `amenities`
- C) Zawsze przy plikach `.json`
- D) Gdy plik zawiera jedną tablicę JSON z dokumentami (`[ {...}, {...} ]`)

<details><summary>Odpowiedź</summary>

**D** — domyślnie mongoimport czyta kolejne dokumenty JSON jeden po drugim. Plik z jedną tablicą wymaga `--jsonArray`. (Lab 3, zad. 2–4)

</details>

**9.148. Co robi opcja `--drop` w `mongoimport`?**

- A) Pomija dokumenty z błędami
- B) Usuwa plik po imporcie
- C) Usuwa kolekcję docelową przed importem, więc ponowny import nie dubluje danych
- D) Usuwa pole `_id` z importowanych dokumentów

<details><summary>Odpowiedź</summary>

**C** — bez `--drop` ponowny import dokumentów z tymi samymi `_id` daje błędy duplikatów. (Lab 3, zad. 2–4)

</details>

**9.149. Zad. 4 każe uruchomić `mongoimport` wewnątrz kontenera. Dlaczego trzeba najpierw wykonać `docker cp`?**

- A) Bo kontener nie ma dostępu do internetu
- B) Bo `mongoimport` w kontenerze widzi tylko system plików kontenera, więc pliki JSON muszą tam trafić (np. do `/data`)
- C) Bo `docker cp` uruchamia import
- D) Bo pliki muszą być w formacie BSON

<details><summary>Odpowiedź</summary>

**B** — proces w kontenerze nie widzi `C:\...` hosta, chyba że zamontowano wolumen. (Lab 3, zad. 4)

</details>

**9.150. Które polecenie skopiuje katalog `.\sample_analytics` z hosta do `/data/sample_analytics` w kontenerze `mongodb`?**

- A) `docker cp mongodb:/data/sample_analytics .\sample_analytics`
- B) `docker exec mongodb cp .\sample_analytics /data`
- C) `docker copy .\sample_analytics /data --container mongodb`
- D) `docker cp .\sample_analytics mongodb:/data/sample_analytics`

<details><summary>Odpowiedź</summary>

**D** — składnia to `docker cp <źródło> <cel>`, a ścieżkę w kontenerze poprzedza `nazwa_kontenera:`. A kopiuje w przeciwną stronę. (Lab 3, zad. 4 i 7)

</details>

**9.151. Które polecenie zaimportuje `accounts.json` do bazy `analytics` z poziomu kontenera `mongodb` (pliki już skopiowano do `/data/sample_analytics`)?**

- A) `docker exec mongodb mongoimport --db analytics --collection accounts --file /data/sample_analytics/accounts.json`
- B) `docker exec mongodb mongoimport --db analytics --collection accounts --file .\sample_analytics\accounts.json`
- C) `docker run mongodb mongoimport --db analytics --file accounts.json`
- D) `mongoimport --container mongodb --db analytics --file accounts.json`

<details><summary>Odpowiedź</summary>

**A** — `docker exec` uruchamia program w działającym kontenerze, a ścieżka musi wskazywać plik w kontenerze. B podaje ścieżkę hosta. (Lab 3, zad. 4)

</details>

**9.152. Jak z hosta zaimportować dane do drugiego kontenera, opublikowanego na porcie 27018?**

- A) Nie da się, mongoimport działa tylko na porcie 27017
- B) `mongoimport --db airbnb --collection listingsAndReviews --file listingsAndReviews.json --port 27018` (albo `--uri "mongodb://localhost:27018"`)
- C) `mongoimport --container mongodb1 ...`
- D) `mongoimport --db airbnb:27018 ...`

<details><summary>Odpowiedź</summary>

**B** — narzędzia przyjmują `--host`/`--port` albo `--uri`, a domyślnie łączą się z `localhost:27017`. (Lab 1, zad. 11; Lab 3, zad. 2)

</details>

#### Zliczanie dokumentów

**9.153. Czym różni się `countDocuments()` od `estimatedDocumentCount()`?**

- A) `countDocuments()` przyjmuje filtr i liczy dokładnie (przez agregację); `estimatedDocumentCount()` nie przyjmuje filtra i bierze liczbę z metadanych kolekcji, więc jest szybsza
- B) `estimatedDocumentCount()` przyjmuje filtr, a `countDocuments()` nie
- C) Obie czytają metadane; różnią się tylko nazwą
- D) `countDocuments()` jest przestarzała

<details><summary>Odpowiedź</summary>

**A** — wykład: `countDocuments()` daje dokładny wynik, który może wymagać odczytu wszystkich dokumentów, a `estimatedDocumentCount()` korzysta z metadanych i jest zwykle szybsza. (Lab 3, zad. 5; wykład)

</details>

**9.154. Które polecenie zliczania jest oznaczone jako przestarzałe (deprecated)?**

- A) `db.listingsAndReviews.countDocuments()`
- B) `db.listingsAndReviews.estimatedDocumentCount()`
- C) `db.listingsAndReviews.count()`
- D) `db.listingsAndReviews.aggregate([{ $count: "n" }])`

<details><summary>Odpowiedź</summary>

**C** — `count()` zastąpiły `countDocuments()` i `estimatedDocumentCount()`. Treść Lab 3 opisuje je jako „deprecated”. (Lab 3, zad. 5)

</details>

**9.155. Które polecenie policzy oferty z Portugalii?**

- A) `db.listingsAndReviews.estimatedDocumentCount({ "address.country": "Portugal" })`
- B) `db.listingsAndReviews.countDocuments({ "address.country": "Portugal" })`
- C) `db.listingsAndReviews.countDocuments().find({ "address.country": "Portugal" })`
- D) `db.listingsAndReviews.count("Portugal")`

<details><summary>Odpowiedź</summary>

**B** — filtr przyjmuje tylko `countDocuments`. `estimatedDocumentCount` nie filtruje. Wynik to 555. (Lab 3, zad. 5 i 18)

</details>

**9.156. Co liczy `db.listingsAndReviews.find({ beds: { $gt: 5 } }).count()`?**

- A) Wszystkie dokumenty kolekcji
- B) Liczbę łóżek
- C) Liczbę dokumentów zwróconych w pierwszej partii kursora
- D) Liczbę dokumentów pasujących do zapytania kursora

<details><summary>Odpowiedź</summary>

**D** — `cursor.count()` liczy dokumenty pasujące do filtra `find`. Treść laboratorium: „jeśli liczymy liczbę dokumentów zwracanych w zapytaniu”. (Lab 3, zad. 5)

</details>

**9.157. Kolekcja ma setki milionów dokumentów, a potrzebujesz szybko przybliżonej liczby wszystkich. Co wybierzesz?**

- A) `estimatedDocumentCount()`
- B) `countDocuments({})`
- C) `find().toArray().length`
- D) `aggregate([{ $group: { _id: null, n: { $sum: 1 } } }])`

<details><summary>Odpowiedź</summary>

**A** — metoda czyta metadane i nie skanuje dokumentów. Pozostałe przechodzą przez dane, a C dodatkowo ładuje całość do pamięci klienta. (Lab 3, zad. 5)

</details>

**9.158. Ile dokumentów przywróciło `mongorestore` w rozwiązaniu studenta (airbnb 5555, weather 10000, accounts 1746, customers 500, transactions 1746)?**

- A) 17801
- B) 19547
- C) 15555
- D) 9547

<details><summary>Odpowiedź</summary>

**B** — 5555 + 10000 + 1746 + 500 + 1746 = 19547. Tyle zapisano w rozwiązaniu, a suma się zgadza. (Lab 3, zad. 5–6)

</details>

#### Kopie zapasowe

**9.159. W jakim formacie `mongodump` zapisuje dane?**

- A) CSV, plik na kolekcję
- B) Jeden plik SQL
- C) Binarny BSON (plik `.bson` na kolekcję) plus plik `.metadata.json` z opcjami i definicjami indeksów
- D) JSON czytelny dla człowieka

<details><summary>Odpowiedź</summary>

**C** — BSON zachowuje typy danych (np. Decimal128 i daty), a metadane pozwalają `mongorestore` odtworzyć indeksy. (Lab 3, zad. 6)

</details>

**9.160. Gdzie `mongodump` bez opcji `--out` zapisuje kopię?**

- A) Wypisuje ją na ekran
- B) Do `C:\data\db`
- C) Do `/data/backup` w kontenerze
- D) Do katalogu `dump/` w bieżącym katalogu

<details><summary>Odpowiedź</summary>

**D** — domyślnym katalogiem wyjściowym jest `./dump`, a `--out` go zmienia. Student użył `--out c:\data\backup`. (Lab 3, zad. 6)

</details>

**9.161. Które polecenie zrobi kopię bazy `airbnb` do `c:\data\backup`?**

- A) `mongoexport --db airbnb --out c:\data\backup`
- B) `mongorestore --db airbnb --out c:\data\backup`
- C) `mongodump --db airbnb --out c:\data\backup`
- D) `mongodump airbnb > c:\data\backup`

<details><summary>Odpowiedź</summary>

**C** — kopię binarną robi `mongodump`. Powstanie `c:\data\backup\airbnb\` z plikami `.bson` i `.metadata.json`. (Lab 3, zad. 6)

</details>

**9.162. Co robi `mongorestore c:\data\backup`?**

- A) Usuwa katalog z kopią
- B) Tworzy nową kopię w tym katalogu
- C) Eksportuje bazy do JSON
- D) Przywraca wszystkie bazy zapisane w podkatalogach tego katalogu (`airbnb`, `weather`, `analytics`)

<details><summary>Odpowiedź</summary>

**D** — `mongorestore` wczytuje zrzut BSON z katalogu i odtwarza kolekcje razem z indeksami. (Lab 3, zad. 6)

</details>

**9.163. Baza `airbnb` istnieje i ma te same dokumenty co kopia. Co zrobi `mongorestore` bez `--drop`?**

- A) Wykonuje tylko inserty; dokumentów z istniejącym `_id` nie nadpisze (błędy duplikatów), reszta się wstawi
- B) Nadpisze wszystkie dokumenty wersją z kopii
- C) Usunie bazę i odtworzy ją od zera
- D) Odmówi działania, bo baza istnieje

<details><summary>Odpowiedź</summary>

**A** — dlatego zad. 6 i 7 każą najpierw usunąć bazy, a alternatywą jest `mongorestore --drop`. (Lab 3, zad. 6–7)

</details>

**9.164. Czym różni się `mongodump` od `mongoexport`?**

- A) Niczym, to dwie nazwy tego samego programu
- B) `mongodump` robi binarną kopię BSON (z typami i indeksami) do backupu; `mongoexport` zapisuje dane jako JSON lub CSV do wymiany danych i może tracić typy BSON
- C) `mongoexport` zapisuje BSON, a `mongodump` CSV
- D) `mongodump` działa tylko w Dockerze

<details><summary>Odpowiedź</summary>

**B** — do kopii zapasowych służą `mongodump`/`mongorestore`, a `mongoexport`/`mongoimport` do wymiany danych z innymi programami. (Lab 3, zad. 6 i 10)

</details>

**9.165. Które narzędzie przywraca dane zrzucone przez `mongodump`?**

- A) `mongoimport`
- B) `mongosh --load`
- C) `mongorestore`
- D) `mongod --restore`

<details><summary>Odpowiedź</summary>

**C** — pary narzędzi to `mongodump` ↔ `mongorestore` (BSON) oraz `mongoexport` ↔ `mongoimport` (JSON/CSV). (Lab 3, zad. 6)

</details>

**9.166. Co robi `docker exec -i mongodb mongorestore --archive=/data/sampledata.archive`?**

- A) Tworzy archiwum `sampledata.archive` z baz w kontenerze
- B) Kopiuje archiwum z hosta do kontenera
- C) Rozpakowuje archiwum ZIP na dysk hosta
- D) Uruchamia w kontenerze `mongorestore`, który odtwarza bazy z jednego pliku archiwum w kontenerze

<details><summary>Odpowiedź</summary>

**D** — archiwum trzeba najpierw skopiować przez `docker cp`, a potem odtworzyć bazy w kontenerze. (Lab 3, zad. 7)

</details>

**9.167. Dlaczego w `mongorestore --archive=/data/sampledata.archive` stoi znak `=`, a nie spacja?**

- A) `=` jest wymagane w każdej opcji narzędzi MongoDB
- B) `--archive` bez wartości oznacza czytanie ze standardowego wejścia, więc ścieżkę pliku podaje się po `=`
- C) Spacja działa tylko na Linuksie
- D) `=` włącza kompresję gzip

<details><summary>Odpowiedź</summary>

**B** — dokumentacja narzędzi każe podawać plik jako `--archive=<plik>`. Samo `--archive` to strumień stdin/stdout. (Lab 3, zad. 7)

</details>

**9.168. Czym różni się zrzut `--archive` od zwykłego zrzutu `mongodump`?**

- A) Archiwum to jeden plik z wieloma bazami i kolekcjami, a zwykły zrzut to katalog z plikami `.bson` i `.metadata.json`
- B) Archiwum zawiera tylko indeksy
- C) Archiwum jest w formacie CSV
- D) Archiwum da się otworzyć tylko w Compass

<details><summary>Odpowiedź</summary>

**A** — archiwum łatwo skopiować jednym poleceniem (np. `docker cp`). `sampledata.archive` zawiera wszystkie bazy `sample_*`. (Lab 3, zad. 7)

</details>

**9.169. Jakie bazy pojawiają się po odtworzeniu `sampledata.archive`?**

- A) `airbnb`, `weather`, `analytics`
- B) `northwind` i `Politechnika`
- C) Bazy przykładowe z prefiksem `sample_`, m.in. `sample_airbnb`, `sample_mflix`, `sample_analytics` i `sample_weatherdata`
- D) Tylko `admin` i `local`

<details><summary>Odpowiedź</summary>

**C** — dlatego dalsze zadania używają `use("sample_airbnb")`, a nie `airbnb`. (Lab 3, zad. 7 i 11)

</details>

#### mongoexport do CSV

**9.170. Czego wymaga `mongoexport --type=csv`?**

- A) Opcji `--jsonArray`
- B) Listy pól przez `--fields` (albo `--fieldFile`)
- C) Opcji `--headerline`
- D) Uprawnień administratora Windows

<details><summary>Odpowiedź</summary>

**B** — CSV ma stałe kolumny, więc trzeba podać, które pola eksportować. `--headerline` to opcja `mongoimport`. (Lab 3, zad. 10)

</details>

**9.171. Które polecenie wyeksportuje wybrane pola z `listingsAndReviews` do CSV?**

- A) `mongoexport --db sample_airbnb --collection listingsAndReviews --type=csv --fields _id,name,price,address.country --out c:\data\listings.csv`
- B) `mongodump --db sample_airbnb --collection listingsAndReviews --type=csv --out c:\data\listings.csv`
- C) `mongoexport --db sample_airbnb --collection listingsAndReviews --csv`
- D) `mongoimport --db sample_airbnb --collection listingsAndReviews --type=csv --out c:\data\listings.csv`

<details><summary>Odpowiedź</summary>

**A** — eksport tekstowy robi `mongoexport`, a do CSV potrzebne są `--type=csv` i `--fields`. Pole zagnieżdżone podaje się notacją kropkową. (Lab 3, zad. 10)

</details>

**9.172. Które polecenie zaimportuje plik CSV z nagłówkiem do nowej kolekcji `listings_csv`?**

- A) `mongoimport --db sample_airbnb --collection listings_csv --file c:\data\listings.csv`
- B) `mongorestore --db sample_airbnb --collection listings_csv c:\data\listings.csv`
- C) `mongoimport --db sample_airbnb --collection listings_csv --type=csv --headerline --file c:\data\listings.csv`
- D) `mongoimport --db sample_airbnb --type=csv --fields --file c:\data\listings.csv`

<details><summary>Odpowiedź</summary>

**C** — `--type=csv` ustawia format, a `--headerline` bierze nazwy pól z pierwszego wiersza. Bez `--type=csv` (A) mongoimport traktuje plik jako JSON. (Lab 3, zad. 10)

</details>

**9.173. Dlaczego CSV słabo nadaje się do eksportu całych dokumentów `listingsAndReviews`?**

- A) CSV nie obsługuje polskich znaków
- B) CSV nie pozwala zapisać więcej niż 1000 wierszy
- C) CSV zawsze pomija `_id`
- D) CSV to płaska tabela, więc nie odda wiernie tablic (np. `amenities`, `reviews`) ani zagnieżdżonych dokumentów, a typy BSON (np. Decimal128) zamieniają się w tekst

<details><summary>Odpowiedź</summary>

**D** — dlatego eksportuje się wybrane pola skalarne. Pełna kopia to zadanie dla `mongodump`. (Lab 3, zad. 10)

</details>

#### explain(), COLLSCAN i IXSCAN

**9.174. Co zwraca `db.listingsAndReviews.find().explain("executionStats")`?**

- A) Dokumenty wyniku z dodatkowym polem czasu
- B) Plan wykonania zapytania (zwycięski plan) wraz ze statystykami wykonania, np. `nReturned`, `totalDocsExamined` i `executionTimeMillis`
- C) Listę indeksów kolekcji
- D) Statystyki rozmiaru kolekcji

<details><summary>Odpowiedź</summary>

**B** — tryb `executionStats` wykonuje zapytanie i zwraca liczby z wykonania. Domyślny tryb `"queryPlanner"` pokazuje tylko wybrany plan. (Lab 3, zad. 8)

</details>

**9.175. Który tryb (verbosity) `explain()` jest domyślny?**

- A) `"queryPlanner"`
- B) `"executionStats"`
- C) `"allPlansExecution"`
- D) `"verbose"`

<details><summary>Odpowiedź</summary>

**A** — tryby to `queryPlanner` (domyślny), `executionStats` i `allPlansExecution`. W laboratorium podawaliśmy `"executionStats"` jawnie. (Lab 3, zad. 8)

</details>

**9.176. Co oznacza etap `COLLSCAN` w planie wykonania?**

- A) Skanowanie indeksu
- B) Skanowanie kolekcji capped
- C) Kompresję kolekcji
- D) Pełne skanowanie kolekcji: serwer czyta wszystkie dokumenty

<details><summary>Odpowiedź</summary>

**D** — przy `COLLSCAN` `totalDocsExamined` równa się liczbie dokumentów w kolekcji (np. 5555). (Lab 3, zad. 8)

</details>

**9.177. Co oznacza etap `IXSCAN`?**

- A) Import danych z pliku
- B) Błąd indeksu
- C) Pełne skanowanie kolekcji
- D) Skanowanie indeksu: serwer przegląda klucze indeksu zamiast wszystkich dokumentów

<details><summary>Odpowiedź</summary>

**D** — po `IXSCAN` zwykle następuje `FETCH`, który pobiera wskazane dokumenty. (Lab 3, zad. 8)

</details>

**9.178. Jaki etap zobaczysz w `db.listingsAndReviews.find().explain("executionStats")` (bez filtra i sortowania)?**

- A) `IXSCAN` po `_id_`
- B) `IXSCAN` po `name_1`
- C) `COLLSCAN`
- D) `SORT`

<details><summary>Odpowiedź</summary>

**C** — bez filtra i sortowania indeks nie ma czego przyspieszyć, więc serwer czyta całą kolekcję. (Lab 3, zad. 8)

</details>

**9.179. Które zapytanie skłoni MongoDB do użycia indeksu `name_1`?**

- A) `db.listingsAndReviews.find({ name: /^Resort/ })`
- B) `db.listingsAndReviews.find({ beds: 2 })`
- C) `db.listingsAndReviews.find({ "address.country": "Spain" })`
- D) `db.listingsAndReviews.find({}, { name: 1 })`

<details><summary>Odpowiedź</summary>

**A** — wyrażenie z prefiksem `^Resort` (wrażliwe na wielkość liter) pozwala przejść tylko zakres kluczy indeksu. W wyniku jest `IXSCAN` na `name_1`. Projekcja w D nie wpływa na wybór indeksu. (Lab 3, zad. 8)

</details>

**9.180. Które wyrażenie regularne najlepiej wykorzysta indeks na `name`?**

- A) `/Resort/`
- B) `/^resort/i`
- C) `/resort$/`
- D) `/^Resort/`

<details><summary>Odpowiedź</summary>

**D** — dokumentacja: najlepiej działa „prefix expression” zakotwiczone `^` i wrażliwe na wielkość liter. Wyrażenia bez rozróżniania wielkości liter (`i`) nie potrafią skutecznie użyć indeksu. (Lab 3, zad. 8 i 28)

</details>

**9.181. Które pole `executionStats` podaje czas wykonania zapytania w milisekundach?**

- A) `nReturned`
- B) `totalKeysExamined`
- C) `executionTimeMillis`
- D) `millis`

<details><summary>Odpowiedź</summary>

**C** — np. `.explain("executionStats").executionStats.executionTimeMillis`. `nReturned` to liczba zwróconych dokumentów. (Lab 3, zad. 9; duży plik, zad. 2)

</details>

**9.182. Co zwróci `db.listingsAndReviews.find().sort({ name: 1 }).explain("executionStats").executionStats.nReturned`?**

- A) Czas wykonania
- B) Liczbę zwróconych dokumentów (tu 5555)
- C) Nazwę użytego indeksu
- D) Pierwszy dokument

<details><summary>Odpowiedź</summary>

**B** — treść zad. 9 mówi wprost, że `nReturned` to ilość zwróconych dokumentów. (Lab 3, zad. 9)

</details>

**9.183. Jak wygląda idealny wynik `executionStats` dla zapytania punktowego z dobrym indeksem?**

- A) `totalDocsExamined` jest dużo większe niż `nReturned`
- B) `totalKeysExamined` równa się liczbie dokumentów kolekcji
- C) `nReturned` wynosi 0
- D) `totalKeysExamined` i `totalDocsExamined` są bliskie `nReturned`

<details><summary>Odpowiedź</summary>

**D** — serwer czyta tylko to, co zwraca. Przykład z laboratorium: `/^Resort/` dał 6 kluczy i 5 dokumentów przy 5 zwróconych. (Lab 3, zad. 8)

</details>

**9.184. Kolekcja ma indeks `name_1`. Jaki plan dostanie `find().sort({ name: 1 })`?**

- A) Błąd, bo sortowanie wymaga filtra
- B) `COLLSCAN` + `SORT` w pamięci
- C) `IXSCAN` po `_id_`
- D) `IXSCAN` po `name_1` + `FETCH`, bez etapu `SORT`, bo indeks oddaje klucze już posortowane

<details><summary>Odpowiedź</summary>

**D** — indeks zastępuje sortowanie w pamięci. (Lab 3, zad. 9)

</details>

**9.185. Co robi `.hint({ $natural: 1 })` w `find().sort({ name: 1 }).hint({ $natural: 1 })`?**

- A) Wymusza indeks `name_1`
- B) Wymusza pełne skanowanie kolekcji w kolejności naturalnej, więc sortowanie odbywa się w pamięci (`SORT`)
- C) Sortuje po `_id`
- D) Wyłącza sortowanie

<details><summary>Odpowiedź</summary>

**B** — student porównał w ten sposób sortowanie z indeksem i bez niego: około 5 ms i około 69 ms. (Lab 3, zad. 9)

</details>

**9.186. Dlaczego zwykłe `find()` bez sortowania (COLLSCAN, około 2 ms) było szybsze niż `find().sort({ name: 1 })` z indeksem (około 5 ms)?**

- A) Bo indeks był uszkodzony
- B) Bo COLLSCAN używa pamięci podręcznej, a IXSCAN nie
- C) Bo `find()` bez sortowania czyta dokumenty po kolei, bez kosztu porządku; sortowanie przez indeks to przejście po kluczach i pobieranie dokumentów w innej kolejności
- D) Bo `sort` zawsze wyłącza indeksy

<details><summary>Odpowiedź</summary>

**C** — gdy trzeba zwrócić całą kolekcję, indeks nie skraca pracy, tylko daje porządek. Uczciwe porównanie to sortowanie z indeksem kontra bez niego. (Lab 3, zad. 9)

</details>

**9.187. Gdzie w wyniku `explain()` szukać etapu (`COLLSCAN`/`IXSCAN`) wybranego planu?**

- A) W `executionStats.nReturned`
- B) W `serverInfo`
- C) W `command.filter`
- D) W `queryPlanner.winningPlan` (pole `stage` i ewentualnie `inputStage`)

<details><summary>Odpowiedź</summary>

**D** — `winningPlan` opisuje drzewo etapów, np. `FETCH` → `IXSCAN` z `indexName: "name_1"`. (Lab 3, zad. 8)

</details>

#### Agregacja na sample_airbnb

**9.188. Jaką postać ma wywołanie potoku agregacji?**

- A) `db.listingsAndReviews.aggregate({ $group: ... }, { $sort: ... })` bez tablicy, jako jedyna poprawna forma
- B) `db.listingsAndReviews.aggregate([ { <etap1> }, { <etap2> }, ... ])`
- C) `db.aggregate("listingsAndReviews", { ... })`
- D) `db.listingsAndReviews.find().aggregate([...])`

<details><summary>Odpowiedź</summary>

**B** — `aggregate` przyjmuje tablicę etapów wykonywanych kolejno, a każdy etap dostaje wynik poprzedniego. (Lab 3, zad. 11–30)

</details>

**9.189. Które polecenie zwróci unikalne wartości `property_type` (zad. 11)?**

- A) `db.listingsAndReviews.aggregate([{ $group: { _id: "$property_type" } }])`
- B) `db.listingsAndReviews.aggregate([{ $group: { property_type: "$_id" } }])`
- C) `db.listingsAndReviews.aggregate([{ $project: { _id: "$property_type" } }])`
- D) `db.listingsAndReviews.aggregate([{ $unique: "property_type" }])`

<details><summary>Odpowiedź</summary>

**A** — `$group` tworzy jeden dokument na każdą wartość `_id`, czyli wartości unikalne. C nie grupuje, więc powtarza wartości. (Lab 3, zad. 11)

</details>

**9.190. Znajdź błąd: `db.listingsAndReviews.aggregate([{ $group: { _id: "property_type" } }])`.**

- A) Brakuje `$sort`
- B) `$group` wymaga akumulatora
- C) Brak `$` przed nazwą pola: `"property_type"` to stały napis, więc wynik to jedna grupa `{ _id: "property_type" }`
- D) `_id` w `$group` musi być liczbą

<details><summary>Odpowiedź</summary>

**C** — do wartości pola w wyrażeniach agregacji odwołujemy się przez `"$pole"`. (Lab 3, zad. 11)

</details>

**9.191. Które polecenie zwróci 1 dokument z kolekcji etapem `$limit` (zad. 12)?**

- A) `db.listingsAndReviews.aggregate({ limit: 1 })`
- B) `db.listingsAndReviews.aggregate([{ $first: 1 }])`
- C) `db.listingsAndReviews.aggregate([{ $limit: "1" }])`
- D) `db.listingsAndReviews.aggregate([{ $limit: 1 }])`

<details><summary>Odpowiedź</summary>

**D** — `$limit` przyjmuje dodatnią liczbę całkowitą. `$first` to akumulator `$group`, a nie etap. (Lab 3, zad. 12)

</details>

**9.192. Jak będzie wyglądać pole kraju w wyniku `[{ $limit: 3 }, { $project: { _id: 0, name: 1, property_type: 1, bedrooms: 1, beds: 1, "address.country": 1 } }]`?**

- A) `country: 'Brazil'`
- B) `address: { country: 'Brazil' }`
- C) `"address.country": 'Brazil'`
- D) Cały poddokument `address` ze wszystkimi polami

<details><summary>Odpowiedź</summary>

**B** — włączenie pola zagnieżdżonego zachowuje strukturę poddokumentu i zostawia w nim tylko wybrane pole. Wynik w zad. 13 to potwierdza. (Lab 3, zad. 13)

</details>

**9.193. Które pole `$project` dołącza domyślnie, jeśli go nie wyłączysz?**

- A) Wszystkie pola tablicowe
- B) `name`
- C) Żadne
- D) `_id`

<details><summary>Odpowiedź</summary>

**D** — tak jak w projekcji `find`. Stąd `_id: 0` w rozwiązaniach zad. 13–17. (Lab 3, zad. 13)

</details>

**9.194. Które polecenie zwróci 3 oferty z największą liczbą łóżek, z polami `name` i `beds` (zad. 14)?**

- A) `aggregate([{ $limit: 3 }, { $sort: { beds: -1 } }, { $project: { _id: 0, name: 1, beds: 1 } }])`
- B) `aggregate([{ $sort: { beds: 1 } }, { $limit: 3 }, { $project: { _id: 0, name: 1, beds: 1 } }])`
- C) `aggregate([{ $sort: { beds: -1 } }, { $limit: 3 }, { $project: { _id: 0, name: 1, beds: 1 } }])`
- D) `aggregate([{ $project: { name: 1 } }, { $sort: { beds: -1 } }, { $limit: 3 }])`

<details><summary>Odpowiedź</summary>

**C** — najpierw sortowanie malejące, potem `$limit`. A sortuje trzy przypadkowe dokumenty, B bierze najmniejsze wartości, a D usuwa `beds` przed sortowaniem. (Lab 3, zad. 14)

</details>

**9.195. Które polecenie zwróci 3 oferty typu „House” (zad. 15)?**

- A) `aggregate([{ $match: { property_type: "House" } }, { $limit: 3 }])`
- B) `aggregate([{ $filter: { property_type: "House" } }, { $limit: 3 }])`
- C) `aggregate([{ $where: { property_type: "House" } }, { $limit: 3 }])`
- D) `aggregate([{ $limit: 3 }, { $match: { property_type: "House" } }])`

<details><summary>Odpowiedź</summary>

**A** — `$match` filtruje dokumenty jak filtr `find`. D najpierw bierze 3 dowolne dokumenty i dopiero wśród nich szuka „House”. (Lab 3, zad. 15)

</details>

**9.196. Dlaczego `$match` warto stawiać na początku potoku?**

- A) Bo `$match` musi być pierwszy, inaczej jest błąd
- B) Bo wcześnie zmniejsza liczbę dokumentów w dalszych etapach i na początku potoku może użyć indeksu
- C) Bo tylko wtedy działa `$group`
- D) Bo `$match` na końcu zwraca dokumenty w losowej kolejności

<details><summary>Odpowiedź</summary>

**B** — `$match` może stać w dowolnym miejscu, ale wczesne filtrowanie jest tańsze. (Lab 3, zad. 15–16 i 28)

</details>

**9.197. Które polecenie znajdzie 3 najtańsze apartamenty i pokaże ich kraj (zad. 16)?**

- A) `aggregate([{ $sort: { price: -1 } }, { $match: { property_type: "Apartment" } }, { $limit: 3 }])`
- B) `aggregate([{ $match: { property_type: "Apartment" } }, { $limit: 3 }, { $sort: { price: 1 } }])`
- C) `aggregate([{ $group: { _id: "$address.country", price: { $min: "$price" } } }, { $limit: 3 }])`
- D) `aggregate([{ $match: { property_type: "Apartment" } }, { $sort: { price: 1 } }, { $limit: 3 }, { $project: { _id: 0, name: 1, price: 1, "address.country": 1 } }])`

<details><summary>Odpowiedź</summary>

**D** — kolejność: filtr, sortowanie rosnąco, limit, projekcja. A sortuje malejąco, a B sortuje dopiero trzy przypadkowe apartamenty. (Lab 3, zad. 16)

</details>

**9.198. Które polecenie zwróci 5 dokumentów z nowym polem `country` z wartością `address.country` (zad. 17)?**

- A) `aggregate([{ $limit: 5 }, { $project: { _id: 0, name: 1, price: 1, country: "address.country" } }])`
- B) `aggregate([{ $limit: 5 }, { $project: { _id: 0, name: 1, price: 1, country: "$address.country" } }])`
- C) `aggregate([{ $limit: 5 }, { $rename: { "address.country": "country" } }])`
- D) `aggregate([{ $limit: 5 }, { $project: { country: 1 } }])`

<details><summary>Odpowiedź</summary>

**B** — wartość pola wstawia się wyrażeniem `"$address.country"`. W A trafiłby stały napis, a `$rename` jest operatorem aktualizacji, nie etapem potoku. (Lab 3, zad. 17)

</details>

**9.199. Czym różni się etap `$addFields` od `$project`?**

- A) `$addFields` dodaje lub nadpisuje pola i zostawia wszystkie pozostałe; `$project` zostawia tylko pola wskazane w projekcji (oraz `_id`)
- B) `$addFields` usuwa wszystkie inne pola
- C) Nie ma różnicy
- D) `$project` nie umie tworzyć nowych pól

<details><summary>Odpowiedź</summary>

**A** — `{ $addFields: { country: "$address.country" } }` doda `country` do pełnego dokumentu. Alias `$addFields` to `$set`. (Lab 3, zad. 17)

</details>

**9.200. Jaki etap potoku jest aliasem `$addFields`?**

- A) `$project`
- B) `$merge`
- C) `$set`
- D) `$unset`

<details><summary>Odpowiedź</summary>

**C** — etap `$set` działa tak samo jak `$addFields`. Etap `$unset` usuwa pola. (Lab 3, zad. 17)

</details>

**9.201. Które polecenie zwróci `[ { totalPortugal: 555 } ]` (zad. 18)?**

- A) `aggregate([{ $match: { "address.country": "Portugal" } }, { $count: "totalPortugal" }])`
- B) `aggregate([{ $count: "totalPortugal" }, { $match: { "address.country": "Portugal" } }])`
- C) `aggregate([{ $match: { country: "Portugal" } }, { $count: "totalPortugal" }])`
- D) `aggregate([{ $match: { "address.country": "Portugal" } }, { $sum: "totalPortugal" }])`

<details><summary>Odpowiedź</summary>

**A** — `$count: "<nazwa>"` zwraca dokument z tą nazwą pola i liczbą dokumentów. B liczy całą kolekcję, a potem filtruje wynik, C używa pola, którego nie ma na najwyższym poziomie, a `$sum` nie jest etapem. (Lab 3, zad. 18)

</details>

**9.202. Który potok jest równoważny `[{ $count: "n" }]`?**

- A) `[{ $group: { _id: "$n", n: { $sum: 1 } } }]`
- B) `[{ $group: { _id: null, n: { $sum: 1 } } }, { $project: { _id: 0 } }]`
- C) `[{ $project: { n: { $sum: 1 } } }]`
- D) `[{ $limit: 1 }]`

<details><summary>Odpowiedź</summary>

**B** — `_id: null` łączy wszystkie dokumenty w jedną grupę, a `$sum: 1` dodaje 1 za każdy z nich. (Lab 3, zad. 18 i 23)

</details>

**9.203. Które polecenie odpowie, ile ofert jest w każdym kraju (zad. 19)?**

- A) `aggregate([{ $group: { _id: "$address.country", totalLocal: { $sum: "$address.country" } } }])`
- B) `aggregate([{ $group: { _id: "$address.country", totalLocal: { $count: "country" } } }])`
- C) `aggregate([{ $count: "$address.country" }])`
- D) `aggregate([{ $group: { _id: "$address.country", totalLocal: { $sum: 1 } } }])`

<details><summary>Odpowiedź</summary>

**D** — grupowanie po kraju i `$sum: 1` liczy dokumenty w grupie. W A `$sum` dostaje napisy, które ignoruje, więc wyjdzie 0. (Lab 3, zad. 19)

</details>

**9.204. Które polecenie policzy, ile osób zmieszczą wszystkie oferty w każdym kraju (zad. 20)?**

- A) `aggregate([{ $group: { _id: "$address.country", totalPeople: { $sum: 1 } } }])`
- B) `aggregate([{ $group: { _id: "$address.country", totalPeople: { $sum: "$accommodates" } } }])`
- C) `aggregate([{ $group: { _id: "$accommodates", totalPeople: { $sum: "$address.country" } } }])`
- D) `aggregate([{ $group: { _id: "$address.country", totalPeople: { $avg: "$accommodates" } } }])`

<details><summary>Odpowiedź</summary>

**B** — `$sum: "$pole"` sumuje wartości pola, a `$sum: 1` liczy dokumenty. D daje średnią zamiast sumy. (Lab 3, zad. 20)

</details>

**9.205. Czym różni się `{ $sum: 1 }` od `{ $sum: "$beds" }` w `$group`?**

- A) `{ $sum: 1 }` liczy dokumenty w grupie, a `{ $sum: "$beds" }` sumuje wartości pola `beds`
- B) Niczym
- C) `{ $sum: 1 }` sumuje pierwsze pole dokumentu
- D) `{ $sum: "$beds" }` liczy dokumenty, które mają pole `beds`

<details><summary>Odpowiedź</summary>

**A** — to częste pytanie: liczba ofert (zad. 19) kontra suma miejsc (zad. 20) i łóżek (zad. 23). (Lab 3, zad. 19–23)

</details>

**9.206. Które polecenie zapisze wynik grupowania z zad. 20 do nowej kolekcji `country`, w której `_id` to nazwa kraju (zad. 21)?**

- A) `aggregate([{ $out: "country" }, { $group: { _id: "$address.country", totalPeople: { $sum: "$accommodates" } } }])`
- B) `aggregate([{ $group: { _id: "$address.country", totalPeople: { $sum: "$accommodates" } } }]).saveAs("country")`
- C) `aggregate([{ $group: { _id: "$address.country", totalPeople: { $sum: "$accommodates" } } }, { $out: "country" }])`
- D) `db.country.insertMany(aggregate([...]))`

<details><summary>Odpowiedź</summary>

**C** — `$out` musi być ostatnim etapem potoku. `_id` z `$group` staje się `_id` dokumentów w nowej kolekcji. (Lab 3, zad. 21)

</details>

**9.207. Co robi `$out`, gdy kolekcja `country` już istnieje?**

- A) Dopisuje dokumenty do istniejącej kolekcji
- B) Zwraca błąd
- C) Tworzy kolekcję `country_1`
- D) Zastępuje całą istniejącą kolekcję wynikiem potoku

<details><summary>Odpowiedź</summary>

**D** — `$out` podmienia kolekcję docelową w całości. Do łączenia wyniku z istniejącymi danymi służy `$merge`. (Lab 3, zad. 21)

</details>

**9.208. Czym `$merge` różni się od `$out`?**

- A) `$merge` może dopisywać, aktualizować lub zastępować pojedyncze dokumenty w istniejącej kolekcji, a `$out` zastępuje całą kolekcję
- B) `$merge` łączy dwie kolekcje jak `$lookup`
- C) `$merge` może stać w środku potoku
- D) `$merge` działa tylko na kolekcjach capped

<details><summary>Odpowiedź</summary>

**A** — oba etapy muszą być ostatnie w potoku. `$merge` dopasowuje dokumenty domyślnie po `_id`. (Lab 3, zad. 21)

</details>

**9.209. Które polecenie wstawi do zamówień dane klienta z kolekcji `customers` (zad. 22)?**

- A) `db.orders.aggregate([{ $limit: 3 }, { $lookup: { from: "customers", localField: "_id", foreignField: "customer", as: "customer1" } }])`
- B) `db.orders.aggregate([{ $limit: 3 }, { $lookup: { from: "customers", localField: "customer", foreignField: "_id", as: "customer1" } }])`
- C) `db.orders.aggregate([{ $limit: 3 }, { $join: { customers: "customer" } }])`
- D) `db.customers.aggregate([{ $lookup: { from: "orders", localField: "customer", foreignField: "_id" } }])`

<details><summary>Odpowiedź</summary>

**B** — `localField` to pole w `orders` (`customer`), `foreignField` to pole w `customers` (`_id`), a `as` to nazwa nowego pola. W A pola są zamienione miejscami. (Lab 3, zad. 22)

</details>

**9.210. Jakiego typu jest pole `customer1` dodane przez `$lookup`?**

- A) Zawsze pojedynczy dokument
- B) Liczba dopasowanych klientów
- C) Tablica dopasowanych dokumentów; pusta, gdy nic nie pasuje
- D) Napis z nazwiskiem klienta

<details><summary>Odpowiedź</summary>

**C** — dlatego w wyniku zad. 22 jest `customer1: [ { _id: 1, firstName: 'Adam', ... } ]`. Aby dostać pojedynczy dokument, można dodać `$unwind: "$customer1"`. (Lab 3, zad. 22)

</details>

**9.211. Do jakiej operacji SQL jest najbliższy `$lookup`?**

- A) GROUP BY
- B) LEFT OUTER JOIN
- C) UNION
- D) ORDER BY

<details><summary>Odpowiedź</summary>

**B** — `$lookup` dołącza dokumenty z innej kolekcji tej samej bazy, a dokumenty bez dopasowania zostają z pustą tablicą. (Lab 3, zad. 22)

</details>

**9.212. Które polecenie zwróci `[ { _id: null, totalBeds: 11480 } ]` (zad. 23)?**

- A) `aggregate([{ $group: { _id: "$beds", totalBeds: { $sum: 1 } } }])`
- B) `aggregate([{ $count: "totalBeds" }])`
- C) `aggregate([{ $project: { totalBeds: { $sum: "$beds" } } }])`
- D) `aggregate([{ $group: { _id: null, totalBeds: { $sum: "$beds" } } }])`

<details><summary>Odpowiedź</summary>

**D** — `_id: null` tworzy jedną grupę z całej kolekcji. C liczy sumę osobno dla każdego dokumentu. (Lab 3, zad. 23)

</details>

**9.213. Jak `$sum` traktuje dokumenty, w których pole `beds` nie istnieje albo nie jest liczbą?**

- A) Pomija je (nie zwiększają sumy)
- B) Zwraca błąd
- C) Liczy je jako 1
- D) Zwraca `null` dla całej grupy

<details><summary>Odpowiedź</summary>

**A** — `$sum` ignoruje wartości nienumeryczne i brakujące pola. Tak samo robi `$avg`. (Lab 3, zad. 23 i 27)

</details>

**9.214. Zad. 24 zwraca `minNights: '1', maxNights: '999'`, choć istnieją oferty z dłuższym maksymalnym pobytem (np. '1125'). Dlaczego?**

- A) `$max` działa tylko na pierwszych 1000 dokumentach
- B) Bo `$max` ignoruje wartości powyżej 999
- C) `minimum_nights` i `maximum_nights` są w tym zbiorze napisami, więc `$min`/`$max` porównują je leksykograficznie ('999' > '1125')
- D) Bo wynik jest posortowany malejąco

<details><summary>Odpowiedź</summary>

**C** — porównanie napisów idzie znak po znaku. Żeby porównać liczby, trzeba skonwertować typ, np. `{ $max: { $toInt: "$maximum_nights" } }`. (Lab 3, zad. 24)

</details>

**9.215. Które polecenie realizuje zad. 24 (minimalny i maksymalny czas pobytu)?**

- A) `aggregate([{ $group: { _id: null, minNights: { $min: "$minimum_nights" }, maxNights: { $max: "$maximum_nights" } } }])`
- B) `aggregate([{ $min: "$minimum_nights" }, { $max: "$maximum_nights" }])`
- C) `aggregate([{ $sort: { minimum_nights: 1 } }, { $limit: 1 }])`
- D) `aggregate([{ $group: { _id: "$minimum_nights", maxNights: { $max: 1 } } }])`

<details><summary>Odpowiedź</summary>

**A** — `$min` i `$max` to akumulatory używane w `$group`, a nie samodzielne etapy. (Lab 3, zad. 24)

</details>

**9.216. Zad. 25: liczba recenzji każdego obiektu. Które polecenie da poprawny wynik najprościej?**

- A) `aggregate([{ $group: { _id: null, totalReviews: { $sum: "$number_of_reviews" } } }])`
- B) `aggregate([{ $project: { totalReviews: "$number_of_reviews" } }])`
- C) `aggregate([{ $count: "number_of_reviews" }])`
- D) `aggregate([{ $unwind: "$number_of_reviews" }])`

<details><summary>Odpowiedź</summary>

**B** — każdy obiekt to jeden dokument, więc wystarczy projekcja `_id` i liczby recenzji. `$group` po `_id` (rozwiązanie studenta) daje ten sam wynik, ale niepotrzebnie grupuje. A zwraca jedną sumę dla całej kolekcji. (Lab 3, zad. 25)

</details>

**9.217. Co robi etap `{ $unwind: "$amenities" }`?**

- A) Usuwa duplikaty z tablicy `amenities`
- B) Sortuje tablicę `amenities`
- C) Liczy elementy tablicy
- D) Rozbija dokument na tyle dokumentów, ile elementów ma tablica `amenities`; każdy ma w `amenities` jeden element

<details><summary>Odpowiedź</summary>

**D** — po `$unwind` można grupować po pojedynczych elementach tablicy. Domyślnie dokumenty z pustą tablicą albo bez tego pola odpadają. (Lab 3, zad. 26)

</details>

**9.218. Które polecenie zwróci listę unikalnych udogodnień (zad. 26)?**

- A) `aggregate([{ $group: { _id: null, uniqueAmenities: { $addToSet: "$amenities" } } }])`
- B) `aggregate([{ $unwind: "$amenities" }, { $group: { _id: null, uniqueAmenities: { $addToSet: "$amenities" } } }])`
- C) `aggregate([{ $unwind: "$amenities" }, { $group: { _id: null, uniqueAmenities: { $push: "$amenities" } } }])`
- D) `aggregate([{ $addToSet: "$amenities" }, { $unwind: "$amenities" }])`

<details><summary>Odpowiedź</summary>

**B** — `$unwind` rozbija tablice, a `$addToSet` zbiera wartości bez powtórzeń. A zebrałoby unikalne całe tablice, a C (`$push`) zostawiłoby duplikaty. (Lab 3, zad. 26)

</details>

**9.219. Czym różni się `$addToSet` od `$push` w `$group`?**

- A) `$push` usuwa duplikaty, `$addToSet` nie
- B) `$addToSet` działa tylko na liczbach
- C) `$addToSet` dodaje wartość tylko wtedy, gdy jej jeszcze nie ma w tablicy wyniku; `$push` dodaje każdą wartość, także powtórzenia
- D) Nie ma różnicy

<details><summary>Odpowiedź</summary>

**C** — kolejność elementów w tablicy z `$addToSet` nie jest gwarantowana. (Lab 3, zad. 26)

</details>

**9.220. Dlaczego średnia cena z zad. 27 wychodzi jako `Decimal128("278.766…")`?**

- A) Bo `$avg` zawsze zwraca Decimal128
- B) Bo pole `price` w `sample_airbnb` jest typu Decimal128, więc `$avg` liczy w tym typie
- C) Bo `price` jest napisem
- D) Bo wynik został zaokrąglony przez `$round`

<details><summary>Odpowiedź</summary>

**B** — typ wyniku wynika z typu danych wejściowych. Zaokrąglenie robi dopiero `$round` w zad. 28. (Lab 3, zad. 27)

</details>

**9.221. Które polecenie policzy średnią cenę za noc dla całej kolekcji (zad. 27)?**

- A) `aggregate([{ $group: { _id: null, avgPricePerNight: { $avg: "$price" } } }])`
- B) `aggregate([{ $avg: "$price" }])`
- C) `aggregate([{ $group: { _id: "$price", avgPricePerNight: { $avg: 1 } } }])`
- D) `aggregate([{ $project: { avgPricePerNight: { $avg: "$price" } } }])`

<details><summary>Odpowiedź</summary>

**A** — akumulator `$avg` w `$group` z `_id: null` daje jedną średnią. D liczy „średnią” z jednej wartości dla każdego dokumentu osobno. (Lab 3, zad. 27)

</details>

**9.222. Które polecenie policzy średnie ceny dla typów obiektów zaczynających się na „C” lub „c” (zad. 28)?**

- A) `aggregate([{ $match: { property_type: /^C/ } }, { $group: { _id: "$property_type", averagePrice: { $avg: "$price" } } }])`
- B) `aggregate([{ $group: { _id: "$property_type", averagePrice: { $avg: "$price" } } }, { $match: { property_type: /^c/i } }])`
- C) `aggregate([{ $match: { property_type: /c/i } }, { $group: { _id: "$property_type", averagePrice: { $avg: "$price" } } }])`
- D) `aggregate([{ $match: { property_type: /^c/i } }, { $group: { _id: "$property_type", averagePrice: { $avg: "$price" } } }])`

<details><summary>Odpowiedź</summary>

**D** — `^` oznacza początek, a `i` wyłącza rozróżnianie wielkości liter. A rozróżnia wielkość, C dopasuje „c” w dowolnym miejscu, a w B po `$group` pola `property_type` już nie ma (jest `_id`). (Lab 3, zad. 28)

</details>

**9.223. Która forma `$match` jest równoważna `{ property_type: /^c/i }`?**

- A) `{ property_type: { $regex: "^c", $options: "i" } }`
- B) `{ property_type: { $regex: "^c/i" } }`
- C) `{ property_type: { $like: "c%", $case: false } }`
- D) `{ $regex: { property_type: "^c" }, $options: "i" }`

<details><summary>Odpowiedź</summary>

**A** — flagi wyrażenia podaje się w `$options`. (Lab 3, zad. 28)

</details>

**9.224. Co robi `{ $project: { averagePrice: { $round: ["$averagePrice", 2] } } }` po `$group`?**

- A) Usuwa `averagePrice`
- B) Zaokrągla `averagePrice` do 2 miejsc po przecinku (a `_id` zostaje, bo jest domyślnie dołączane)
- C) Zwraca 2 pierwsze dokumenty
- D) Mnoży średnią przez 2

<details><summary>Odpowiedź</summary>

**B** — `$round: [<wartość>, <miejsca>]`. Wynik np. `{ _id: 'Cottage', averagePrice: Decimal128("200.35") }`. (Lab 3, zad. 28)

</details>

**9.225. Rozwiązanie zad. 29 dodaje w `$group` pole `country: { $first: "$address.country" }`, bez wcześniejszego `$sort`. Na czym polega problem?**

- A) `$first` nie jest akumulatorem `$group`
- B) `$first` zwraca pierwszą literę nazwy kraju
- C) Zapytanie zwróci błąd
- D) Bez `$sort` „pierwszy” dokument grupy jest przypadkowy, a jeden typ obiektu może występować w wielu krajach, więc pokazany kraj jest arbitralny

<details><summary>Odpowiedź</summary>

**D** — kolejność dla `$first` jest określona tylko po sortowaniu. Rzetelniej jest grupować po parze: `_id: { type: "$property_type", country: "$address.country" }`. (Lab 3, zad. 29)

</details>

**9.226. Które polecenie zwróci 3 obiekty z największą liczbą opinii i ich kraj (zad. 30)?**

- A) `aggregate([{ $limit: 3 }, { $sort: { number_of_reviews: -1 } }, { $project: { name: 1, country: "$address.country" } }])`
- B) `aggregate([{ $group: { _id: "$address.country", max: { $max: "$number_of_reviews" } } }, { $limit: 3 }])`
- C) `aggregate([{ $sort: { number_of_reviews: -1 } }, { $limit: 3 }, { $project: { _id: 0, name: 1, number_of_reviews: 1, country: "$address.country" } }])`
- D) `aggregate([{ $sort: { number_of_reviews: 1 } }, { $limit: 3 }, { $project: { _id: 0, name: 1, number_of_reviews: 1, country: "$address.country" } }])`

<details><summary>Odpowiedź</summary>

**C** — malejące sortowanie, potem `$limit`. Wynik: „#Private Studio - Waikiki Dream” (533, United States) i dwa kolejne. (Lab 3, zad. 30)

</details>

**9.227. Po `{ $group: { _id: "$property_type", averagePrice: { $avg: "$price" } } }` chcesz posortować wynik alfabetycznie po typie. Który etap dodasz?**

- A) `{ $sort: { property_type: 1 } }`
- B) `{ $sort: { _id: 1 } }`
- C) `{ $sort: { "$property_type": 1 } }`
- D) `{ $sort: { averagePrice: "asc" } }`

<details><summary>Odpowiedź</summary>

**B** — po `$group` wartość grupująca jest w `_id`, a pola `property_type` już nie ma. (Lab 3, zad. 28; duży plik, zad. 3)

</details>

#### Duży zbiór IMDb (lab 3 big file)

**9.228. Jak zaimportować duży plik `movies.json` do bazy `imdb` przez kontener `mongodb`?**

- A) `docker exec mongodb mongoimport --db imdb --collection movies --file C:\movies.json`
- B) `mongorestore --db imdb movies.json`
- C) `docker cp .\movies.json mongodb:/data/movies.json`, a potem `docker exec mongodb mongoimport --db imdb --collection movies --file /data/movies.json`
- D) `docker run mongoimport movies.json imdb`

<details><summary>Odpowiedź</summary>

**C** — ten sam schemat co w zad. 4: najpierw kopia do kontenera, potem import ścieżką z kontenera. (Lab 3, duży plik, zad. 0)

</details>

**9.229. Co to jest „zapytanie punktowe” z dużego pliku, zad. 1?**

- A) Zapytanie o konkretny dokument (lub kilka) po dokładnej wartości, np. `db.movies.find({ title: "The Godfather" })`
- B) Zapytanie zwracające punkty geograficzne
- C) Zapytanie o zakres lat
- D) Zapytanie liczące średnią

<details><summary>Odpowiedź</summary>

**A** — zapytanie punktowe to dopasowanie równości. Zapytanie przedziałowe używa `$gte`/`$lte`. (Lab 3, duży plik, zad. 1 i 4)

</details>

**9.230. Jaki plan i jaki skutek da `db.movies.find({ title: "The Godfather" })` bez indeksu na `title`, a jaki po `db.movies.createIndex({ title: 1 })`?**

- A) Za każdym razem `IXSCAN`, bo `_id` jest indeksowane
- B) Przed: `IXSCAN`; po: `COLLSCAN`
- C) Przed i po: `COLLSCAN`, bo indeks działa tylko przy sortowaniu
- D) Przed: `COLLSCAN` po wszystkich dokumentach; po: `IXSCAN` na `title_1`, który przegląda tylko pasujące klucze, więc czas spada

<details><summary>Odpowiedź</summary>

**D** — u studenta było to 23539 przejrzanych dokumentów i około 10 ms, a po indeksie 1 dokument i 0 ms. (Lab 3, duży plik, zad. 1–2)

</details>

**9.231. Które wyrażenie zwraca sam czas wykonania zapytania?**

- A) `db.movies.find({ title: "The Godfather" }).explain("executionStats").executionStats.executionTimeMillis`
- B) `db.movies.find({ title: "The Godfather" }).executionTimeMillis()`
- C) `db.movies.explain().find({ title: "The Godfather" }).time`
- D) `db.movies.find({ title: "The Godfather" }).explain().nReturned`

<details><summary>Odpowiedź</summary>

**A** — taką składnię podaje treść zad. 2. Domyślny `explain()` (tryb `queryPlanner`) nie ma sekcji `executionStats`. (Lab 3, duży plik, zad. 2)

</details>

**9.232. Który mechanizm MongoDB jest funkcjonalnym odpowiednikiem GROUP BY z SQL?**

- A) `find().sort()`
- B) Etap `$group` w `aggregate()`
- C) `distinct` w projekcji
- D) `createIndex`

<details><summary>Odpowiedź</summary>

**B** — `$group` z akumulatorami (`$sum`, `$avg`, `$min`, `$max`) odpowiada GROUP BY z funkcjami agregującymi. (Lab 3, duży plik, zad. 3)

</details>

**9.233. Które polecenie policzy, ile filmów wyprodukowano w kolejnych latach, posortowane po roku?**

- A) `db.movies.aggregate([{ $sort: { year: 1 } }, { $count: "year" }])`
- B) `db.movies.find().sort({ year: 1 }).count()`
- C) `db.movies.aggregate([{ $group: { _id: "$year", ile: { $sum: 1 } } }, { $sort: { _id: 1 } }])`
- D) `db.movies.aggregate([{ $group: { year: "$_id", ile: { $sum: 1 } } }])`

<details><summary>Odpowiedź</summary>

**C** — grupowanie po roku liczy filmy w każdym roku, a sortowanie po `_id` porządkuje lata. A i B dają jedną liczbę. (Lab 3, duży plik, zad. 3)

</details>

**9.234. Pole `year` w kilku filmach jest napisem (np. `'2010è'`). Jak w `$match` zostawić tylko dokumenty, w których `year` jest liczbą?**

- A) `{ $match: { year: { $type: "number" } } }`
- B) `{ $match: { year: { $exists: true } } }`
- C) `{ $match: { year: { $ne: "" } } }`
- D) `{ $match: { year: { $isNumber: true } } }`

<details><summary>Odpowiedź</summary>

**A** — alias `"number"` w `$type` obejmuje typy int, long, double i decimal. `$exists` przepuściłoby też napisy. (Lab 3, duży plik, zad. 3 i 7)

</details>

**9.235. Które polecenie policzy filmy z lat 2000–2010 włącznie?**

- A) `db.movies.countDocuments({ year: [2000, 2010] })`
- B) `db.movies.countDocuments({ year: { $gte: 2000, $lte: 2010 } })`
- C) `db.movies.countDocuments({ year: { $in: [2000, 2010] } })`
- D) `db.movies.estimatedDocumentCount({ year: { $gte: 2000, $lte: 2010 } })`

<details><summary>Odpowiedź</summary>

**B** — przedział to `$gte` i `$lte` na jednym polu. `$in` dopasuje tylko lata 2000 i 2010, a `estimatedDocumentCount` nie filtruje. (Lab 3, duży plik, zad. 4)

</details>

**9.236. Jaki indeks przyspieszy zapytanie przedziałowe `{ year: { $gte: 2000, $lte: 2010 } }`?**

- A) `db.movies.createIndex({ title: 1 })`
- B) `db.movies.createIndex({ year: "text" })`
- C) Żaden, bo indeksy działają tylko dla równości
- D) `db.movies.createIndex({ year: 1 })`

<details><summary>Odpowiedź</summary>

**D** — indeks B-drzewa na `year` pozwala przejść tylko zakres kluczy. U studenta: `IXSCAN` po 8719 dokumentach zamiast `COLLSCAN` po 23539. (Lab 3, duży plik, zad. 4)

</details>

**9.237. Które zapytanie znajdzie filmy z Polski z 2010 roku z oceną większą niż 5 (pole `countries` to tablica)?**

- A) `db.movies.find({ countries: ["Poland"], year: 2010, "imdb.rating": { $gt: 5 } })`
- B) `db.movies.find({ countries: "Poland", year: 2010, imdb.rating: { $gt: 5 } })`
- C) `db.movies.find({ countries: "Poland", year: 2010, "imdb.rating": { $gt: 5 } })`
- D) `db.movies.find({ $or: [{ countries: "Poland" }, { year: 2010 }, { "imdb.rating": { $gt: 5 } }] })`

<details><summary>Odpowiedź</summary>

**C** — `countries: "Poland"` sprawdza, czy tablica zawiera ten element, a pole zagnieżdżone musi być w cudzysłowie. A wymaga tablicy równej dokładnie `["Poland"]`, B to błąd składni JS, a D to OR. Wersja z `$and: [...]` jest równoważna C. (Lab 3, duży plik, zad. 5)

</details>

**9.238. Czym różni się `"imdb.rating": { $not: { $lt: 7 } }` od `"imdb.rating": { $gte: 7 }`?**

- A) `$not: { $lt: 7 }` dopasowuje także dokumenty bez pola `imdb.rating` i takie, w których ocena jest napisem (np. `''`); `$gte: 7` tylko liczby ≥ 7
- B) Niczym
- C) `$gte: 7` dopasowuje także brakujące pola
- D) `$not` nie działa z `$lt`

<details><summary>Odpowiedź</summary>

**A** — `$not` zwraca wszystko, co nie spełnia warunku, łącznie z brakami i innymi typami. W zbiorze IMDb część ocen to `''`, więc do „ocena co najmniej 7” lepsze jest `$gte`. (Lab 3, duży plik, zad. 5)

</details>

**9.239. Które polecenie wyświetli polskie filmy posortowane alfabetycznie po tytule, z samym tytułem i rokiem?**

- A) `db.movies.find({ countries: "Poland" }).sort({ title: "asc" }).project({ title: 1 })`
- B) `db.movies.find({ countries: "Poland" }, { _id: 0, title: 1, year: 1 }).sort({ title: 1 })`
- C) `db.movies.find({ countries: "Poland" }, { title: 1, year: 1 }).sort({ title: -1 })`
- D) `db.movies.find({ countries: "Poland", title: 1 }).sort()`

<details><summary>Odpowiedź</summary>

**B** — projekcja jest drugim argumentem `find`, a `sort({ title: 1 })` sortuje rosnąco. C sortuje malejąco. (Lab 3, duży plik, zad. 6)

</details>

**9.240. Jak policzyć średnią ocenę filmów osobno dla USA, Polski i Niemiec, skoro `countries` jest tablicą?**

- A) `$group: { _id: "$countries", ... }` bez `$unwind`
- B) `find({ countries: { $in: ["USA", "Poland", "Germany"] } }).avg("imdb.rating")`
- C) `$match` po ocenie liczbowej, `$unwind: "$countries"`, `$match: { countries: { $in: ["USA", "Poland", "Germany"] } }`, a potem `$group: { _id: "$countries", sredniRating: { $avg: "$imdb.rating" } }`
- D) `$lookup` z kolekcją `countries`

<details><summary>Odpowiedź</summary>

**C** — `$unwind` daje jeden dokument na kraj, więc film koprodukcji wpada do każdego ze swoich krajów. A grupowałoby po całych tablicach. (Lab 3, duży plik, zad. 7)

</details>

**9.241. Bez filtra `$type` `$max` po `imdb.rating` zwrócił `''` zamiast liczby. Dlaczego?**

- A) Bo `$max` nie działa na liczbach zmiennoprzecinkowych
- B) Bo pusty napis jest równy 0
- C) Bo wartości puste są pomijane
- D) Bo w porządku porównań BSON napisy są „większe” od liczb, więc każdy napis wygrywa z dowolną liczbą

<details><summary>Odpowiedź</summary>

**D** — kolejność typów BSON to m.in. null < liczby < napisy < obiekty < tablice… Dlatego najpierw filtruje się `{ "imdb.rating": { $type: "number" } }`. (Lab 3, duży plik, zad. 7)

</details>

**9.242. Dlaczego `sort({ "imdb.rating": -1 })` bez filtra typu pokazuje na górze filmy z pustą oceną `''`?**

- A) Bo sortowanie malejące stawia na początku wartości największe, a napisy w porządku BSON są większe od liczb
- B) Bo sortowanie ignoruje typ
- C) Bo puste wartości zawsze są na początku
- D) Bo indeks na `imdb.rating` jest malejący

<details><summary>Odpowiedź</summary>

**A** — to ta sama reguła porządku typów BSON co w poprzednim pytaniu. Rozwiązanie: `{ "imdb.rating": { $type: "number" } }`. (Lab 3, duży plik, zad. 8)

</details>

**9.243. Które polecenie wyświetli 10 najwyżej ocenianych filmów, które mają co najmniej 10000 głosów?**

- A) `db.movies.find({ "imdb.votes": { $gte: 10000 } }).limit(10).sort({ "imdb.rating": 1 })`
- B) `db.movies.find({ "imdb.rating": { $type: "number" }, "imdb.votes": { $gte: 10000 } }).sort({ "imdb.rating": -1 }).limit(10)`
- C) `db.movies.find().sort({ "imdb.votes": -1 }).limit(10)`
- D) `db.movies.aggregate([{ $limit: 10 }, { $sort: { "imdb.rating": -1 } }])`

<details><summary>Odpowiedź</summary>

**B** — filtr, sortowanie malejące, limit. A sortuje rosnąco, C sortuje po liczbie głosów, a D sortuje tylko 10 przypadkowych filmów. (Lab 3, duży plik, zad. 8)

</details>

**9.244. Na kolekcji `movies` jest indeks `{ year: 1 }`. Czy pomoże przy `find().sort({ year: -1 }).limit(10)`?**

- A) Nie, bo indeks jest rosnący, a sortowanie malejące
- B) Nie, bo `limit` wyłącza indeksy
- C) Tak, bo indeks jednopolowy można przechodzić w obu kierunkach
- D) Tak, ale tylko po przebudowie indeksu jako `{ year: -1 }`

<details><summary>Odpowiedź</summary>

**C** — dla indeksu na jednym polu kierunek nie ma znaczenia przy sortowaniu. Kierunek liczy się dopiero przy sortowaniu po kilku polach w indeksie złożonym. (Lab 3, duży plik, zad. 4 i 8)

</details>
