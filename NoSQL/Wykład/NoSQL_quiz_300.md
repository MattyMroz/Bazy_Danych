# Bazy New/NoSQL — quiz ABCD, najważniejsze pytania

Wybór 300 najważniejszych pytań z pełnego quizu `NoSQL_quiz.md`, w tych samych działach co wykład (1–8) i laboratoria 1–3 (dział 9). Rozwiń „Odpowiedź”, żeby zobaczyć literę, wyjaśnienie i numer slajdu albo zadania z labu.

## Spis działów

1. Big Data i bazy NoSQL — wprowadzenie (28 pytań)
2. MongoDB — instalacja, cechy i modelowanie danych (32 pytania)
3. MongoDB — CRUD, operatory zapytań, projekcja i modyfikatory kursora (36 pytań)
4. MongoDB — walidacja schematu, Aggregation Framework, import i indeksy (29 pytań)
5. MongoDB — replikacja, sharding i kolekcje Time Series (17 pytań)
6. Bazy klucz–wartość i Redis (32 pytania)
7. Bazy grafowe — Neo4j i SQL Server Graph (17 pytań)
8. Bazy rodziny kolumn — Apache Cassandra i CQL (49 pytań)
9. Laboratoria 1–3 (MongoDB w praktyce) (60 pytań)

Razem: 300 pytań.


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

### Projektowanie dużych systemów

**1.2. Dzięki czemu, według slajdu, bazy NoSQL zapewniają wysoką dostępność?**

- A) Dzięki brakowi sztywnych schematów
- B) Dzięki różnorodnym modelom danych
- C) Dzięki replikacji i partycjonowaniu
- D) Dzięki transakcjom ACID

<details><summary>Odpowiedź</summary>

**C** — Wysoką dostępność slajd wiąże z replikacją i partycjonowaniem. Brak schematów daje niższe koszty, a różnorodne modele większą elastyczność. (slajd 3)

</details>

### Bazy relacyjne

**1.3. Który język jest formalnym językiem zapytań modelu relacyjnego?**

- A) SQL
- B) Algebra relacyjna
- C) CQL
- D) XQuery

<details><summary>Odpowiedź</summary>

**B** — Slajd rozróżnia język rzeczywisty (SQL) i formalny (algebra relacyjna). (slajd 4)

</details>

### Zmiana charakteru danych

**1.4. Do jakiej kategorii danych slajd zalicza XML i JSON?**

- A) Strukturalnych
- B) Niestrukturalnych
- C) Półstrukturalnych
- D) Binarnych

<details><summary>Odpowiedź</summary>

**C** — XML i JSON to dane półstrukturalne. Strukturalne to tabele, a niestrukturalne to tekst, obrazy, wideo i audio. (slajd 5)

</details>

### Nowe podejście do Big Data

**1.5. Jakie dwa główne powody zainteresowania bazami NoSQL podaje wykład?**

- A) Transakcje ACID i język SQL
- B) Produktywność tworzenia aplikacji i obsługa dużych wolumenów danych
- C) Niższa cena licencji i lepsza dokumentacja
- D) Silna spójność i normalizacja danych

<details><summary>Odpowiedź</summary>

**B** — Slajdy wymieniają produktywność tworzenia aplikacji oraz duże wolumeny danych przetwarzane w klastrach. (slajdy 6–7)

</details>

### Chmura i sposoby przetwarzania danych

**1.6. Który model chmury oznacza gotowe aplikacje dostępne przez Internet, np. Google Workspace i Salesforce?**

- A) IaaS
- B) PaaS
- C) DBaaS
- D) SaaS

<details><summary>Odpowiedź</summary>

**D** — SaaS (Software as a Service) to gotowe aplikacje. PaaS to platforma, IaaS infrastruktura. (slajd 8)

</details>

**1.7. Który typ przetwarzania służy do obsługi bieżących transakcji, z szybkimi zapisami i odczytami, np. w bankach i sklepach internetowych?**

- A) OLAP
- B) RTAP
- C) OLTP
- D) ETL

<details><summary>Odpowiedź</summary>

**C** — OLTP to Online Transaction Processing. OLAP służy do analizy danych historycznych, RTAP do analizy w czasie rzeczywistym. (slajd 8)

</details>

### Termin NoSQL i jego historia

**1.8. Jak należy rozumieć termin NoSQL według wykładu?**

- A) „No to SQL”, czyli całkowite odrzucenie SQL
- B) Baza bez żadnego języka zapytań
- C) Nie „no to SQL”; termin nie ma precyzyjnej definicji, a często rozwija się go jako „Not only SQL”
- D) Formalny standard ISO dla baz nierelacyjnych

<details><summary>Odpowiedź</summary>

**C** — Slajd mówi wprost „NIE: no to SQL” i że NoSQL nie ma precyzyjnej definicji. Ramka podsuwa „Not only SQL”. (slajdy 11, 14)

</details>

**1.9. Kiedy i gdzie odbyło się spotkanie, od którego liczy się współczesny ruch NoSQL?**

- A) 11 czerwca 2009, San Francisco
- B) 11 czerwca 1998, Seattle
- C) 1 stycznia 2009, Londyn
- D) 11 września 2010, Nowy Jork

<details><summary>Odpowiedź</summary>

**A** — Spotkanie odbyło się 11 czerwca 2009 r. w San Francisco. (slajd 12)

</details>

### Najważniejsze kwestie i cechy NoSQL

**1.10. Czym jest impedancja obiektowo-relacyjna?**

- A) Opóźnieniem sieci między serwerem aplikacji a bazą
- B) Różnicą wydajności między odczytem a zapisem
- C) Konfliktem replik w bazach NoSQL
- D) Różnicą między strukturą obiektów w aplikacji a tabelami w bazie relacyjnej

<details><summary>Odpowiedź</summary>

**D** — To trudność dopasowania struktur danych w pamięci programu do tabel bazy relacyjnej. (slajd 14)

</details>

**1.11. Które cztery cechy definiują bazy NoSQL jako nową generację baz według slajdu (źródło hostingdata.co.uk)?**

- A) Relacyjne, scentralizowane, komercyjne, skalowalne pionowo
- B) Obiektowe, transakcyjne, zamknięte, replikowane
- C) Nierelacyjne, rozproszone, otwarte, horyzontalnie skalowalne
- D) Nierelacyjne, jednowęzłowe, otwarte, skalowalne pionowo

<details><summary>Odpowiedź</summary>

**C** — Non-relational, distributed, open-source, horizontally scalable. (slajd 16)

</details>

### Bazy klucz–wartość i Redis

**1.12. Do czego slajd porównuje model bazy klucz–wartość?**

- A) Do drzewa XML
- B) Do tablicy asocjacyjnej (słownika)
- C) Do kostki OLAP
- D) Do grafu skierowanego

<details><summary>Odpowiedź</summary>

**B** — Baza klucz–wartość to najprostszy model NoSQL, analogiczny do tablicy asocjacyjnej, czyli słownika. (slajd 19)

</details>

**1.13. Które polecenie Redisa zwróci wartość zapisaną wcześniej poleceniem `SET uzytkownik:1 "Jan"`?**

- A) `HGETALL uzytkownik:1`
- B) `GET uzytkownik:1`
- C) `SMEMBERS uzytkownik:1`
- D) `LRANGE uzytkownik:1 0 -1`

<details><summary>Odpowiedź</summary>

**B** — Wartość typu string odczytuje GET. HGETALL służy do hashy, SMEMBERS do zbiorów, LRANGE do list. (slajd 22)

</details>

**1.14. Którą strukturę danych Redisa slajd wskazuje do budowy rankingów?**

- A) HyperLogLog
- B) Bitmap
- C) Sorted Set
- D) Stream

<details><summary>Odpowiedź</summary>

**C** — Sorted Set służy do rankingów. HyperLogLog liczy unikalnych gości, Bitmap przechowuje flagi, Stream strumienie zdarzeń. (slajd 22)

</details>

### Bazy dokumentowe i MongoDB

**1.15. Które zdanie o bazach dokumentowych jest zgodne ze slajdem?**

- A) Wszystkie dokumenty w kolekcji muszą mieć identyczną strukturę
- B) Dokumenty to najczęściej JSON, są organizowane w kolekcje i mogą mieć różną strukturę
- C) Dokumenty można wyszukiwać wyłącznie po kluczu
- D) Bazy dokumentowe nie obsługują danych zagnieżdżonych

<details><summary>Odpowiedź</summary>

**B** — Dokumenty (zwykle JSON, rzadziej XML) tworzą kolekcje, mogą być zagnieżdżone i mieć różną strukturę, a wyszukiwać można wg dowolnych kryteriów. (slajd 23)

</details>

**1.16. Co robi poniższe polecenie?**

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

### Bazy rodziny kolumn i Cassandra

**1.17. Jaka jest architektura klastra Cassandry?**

- A) Master–slave z jednym węzłem głównym
- B) Peer-to-peer: wszystkie węzły są równorzędne, bez pojedynczego punktu awarii
- C) Jeden serwer z repliką zapasową
- D) Klient–serwer z centralnym koordynatorem transakcji

<details><summary>Odpowiedź</summary>

**B** — Wszystkie węzły Cassandry są równorzędne, co eliminuje pojedynczy punkt awarii. (slajd 28)

</details>

**1.18. Które polecenie CQL zmienia wiek klienta o `id = 1002` na 29?**

- A) `SET wiek = 29 FROM klienci WHERE id = 1002;`
- B) `db.klienci.updateOne({ id: 1002 }, { $set: { wiek: 29 } })`
- C) `UPDATE klienci SET wiek = 29 WHERE id = 1002;`
- D) `MATCH (k:klienci {id: 1002}) SET k.wiek = 29`

<details><summary>Odpowiedź</summary>

**C** — CQL ma składnię `UPDATE tabela SET kolumna = wartość WHERE klucz = ...`. B to MongoDB, D to Cypher. (slajd 28)

</details>

### Bazy grafowe i Neo4j

**1.19. Jak slajd charakteryzuje dwa typy baz grafowych?**

- A) OLTP – mała liczba bardzo dużych grafów; OLAP – duża liczba małych grafów
- B) OLTP i OLAP obsługują wyłącznie grafy nieskierowane
- C) OLTP – duża liczba małych lub średnich grafów; OLAP – mała liczba bardzo dużych grafów
- D) OLTP służy do analizy, OLAP do transakcji

<details><summary>Odpowiedź</summary>

**C** — Transakcyjne (OLTP) obsługują wiele małych i średnich grafów, analityczne (OLAP) mało bardzo dużych. (slajd 29)

</details>

**1.20. Które polecenie Cypher tworzy relację ZNA od węzła `a` do węzła `b` z właściwością `od_kiedy`?**

- A) `CREATE (a)<-[ZNA]-(b {od_kiedy: 2020})`
- B) `CREATE [a]-(:ZNA {od_kiedy: 2020})->[b]`
- C) `CREATE (a)-[:ZNA {od_kiedy: 2020}]->(b)`
- D) `INSERT RELATION ZNA (a, b, od_kiedy = 2020)`

<details><summary>Odpowiedź</summary>

**C** — W Cypherze węzły są w nawiasach okrągłych, relacja w kwadratowych z dwukropkiem przed typem, a kierunek wskazuje `->`. (slajd 31)

</details>

### Bazy XML i RDF

**1.21. Do czego służy XQuery w bazach XML?**

- A) Do odpytywania dokumentów XML
- B) Do nawigacji po drzewie XML
- C) Do transformacji dokumentu XML
- D) Do walidacji schematu XML

<details><summary>Odpowiedź</summary>

**A** — XPath nawiguje, XQuery odpytuje, XSLT przekształca. (slajd 32)

</details>

**1.22. Jakim językiem odpytuje się bazy RDF?**

- A) Cypher
- B) XQuery
- C) SPARQL
- D) CQL

<details><summary>Odpowiedź</summary>

**C** — SPARQL, czyli SPARQL Protocol and RDF Query Language. (slajd 33)

</details>

### Ranking DB-Engines

**1.23. Według jakiego kryterium DB-Engines klasyfikuje systemy baz danych?**

- A) Według wydajności w benchmarkach
- B) Według popularności, z aktualizacją co miesiąc
- C) Według liczby linii kodu
- D) Według ceny licencji

<details><summary>Odpowiedź</summary>

**B** — „The DB-Engines Ranking ranks database management systems according to their popularity. The ranking is updated monthly.” (slajd 34)

</details>

### BASE i ACID

**1.24. Co oznacza skrót BASE?**

- A) Balanced, Atomic, Secure, Exact
- B) Basic Availability, Strong consistency, Eventual durability
- C) Batch, Asynchronous, Sharded, Elastic
- D) Basically Available, Soft state, Eventually consistent

<details><summary>Odpowiedź</summary>

**D** — BASE to zasadnicza dostępność, miękki stan i ostateczna spójność. Slajd zaznacza, że nie ma jednej uznanej definicji BASE. (slajd 36)

</details>

### Twierdzenie CAP i trójkąt CAP

**1.25. Co mówi twierdzenie CAP?**

- A) W rozproszonym systemie danych nie można jednocześnie zapewnić spójności, dostępności i tolerancji na podział sieci
- B) Każda baza NoSQL zapewnia jednocześnie C, A i P
- C) Bazy relacyjne zawsze zapewniają tolerancję na podział sieci
- D) Spójność i dostępność wykluczają się w każdym systemie, także jednowęzłowym

<details><summary>Odpowiedź</summary>

**A** — W systemie rozproszonym można jednocześnie zapewnić tylko dwie z trzech właściwości. (slajd 37)

</details>

**1.26. Do której kategorii CAP slajdy zaliczają MongoDB?**

- A) AP
- B) CP
- C) CA
- D) Żadnej, bo nie jest rozproszona

<details><summary>Odpowiedź</summary>

**B** — MongoDB (w trybie CP) zachowuje integralność, ale przy awarii węzła część danych może być niedostępna. (slajdy 37–38)

</details>

**1.27. Która lista zawiera wyłącznie systemy AP według trójkąta CAP ze slajdu?**

- A) HBase, MongoDB, BigTable
- B) MySQL, PostgreSQL
- C) ZooKeeper, HBase, Cassandra
- D) DynamoDB, Cassandra, Riak, CouchDB

<details><summary>Odpowiedź</summary>

**D** — AP: DynamoDB, Cassandra, Riak, CouchDB. CP: HBase, MongoDB, BigTable, ZooKeeper. (slajd 38)

</details>

### Map-Reduce

**1.28. Jaka jest poprawna kolejność faz w modelu Map-Reduce?**

- A) Reduce → Shuffle/Sort → Map
- B) Map → Reduce → Shuffle/Sort
- C) Podział danych → Map → Shuffle/Sort → Reduce
- D) Shuffle/Sort → Map → Reduce

<details><summary>Odpowiedź</summary>

**C** — Dane dzieli się na części, map tworzy pary klucz–wartość, shuffle/sort grupuje je po kluczu, a reduce agreguje. (slajd 39)

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

**2.2. Jaki jest domyślny port serwera MongoDB?**

- A) 3306
- B) 5432
- C) 28015
- D) 27017

<details><summary>Odpowiedź</summary>

**D** — MongoDB domyślnie nasłuchuje na porcie 27017 (localhost:27017 w Compass, VS Code i Dockerze). 3306 to MySQL, 5432 PostgreSQL, a 28015 to przykładowy port z slajdu 083. (slajdy 047, 049, 051, 053)

</details>

**2.3. Który program jest serwerem bazy danych MongoDB, a który klientem?**

- A) Serwer: mongosh, klient: mongod
- B) Serwer: mongos, klient: mongosh
- C) Serwer: mongod, klient: mongosh
- D) Serwer: mongod, klient: mongos

<details><summary>Odpowiedź</summary>

**C** — slajd podaje wprost: Database Server – mongod, Database Client – mongosh. Mongos to router zapytań w klastrze shardowanym, a nie klient. (slajd 049)

</details>

**2.4. Co robi opcja `-d` w poleceniu `docker run --name mongodb -d -p 27017:27017 mongodb/mongodb-community-server:latest`?**

- A) Uruchamia kontener w tle (detached mode)
- B) Usuwa kontener po zatrzymaniu
- C) Włącza tryb debugowania serwera
- D) Wskazuje katalog danych

<details><summary>Odpowiedź</summary>

**A** — `-d` to detached, czyli praca w tle. Usuwanie po zatrzymaniu to `--rm`, a katalog danych montuje się opcją `-v`. (slajd 053)

</details>

**2.5. Które polecenie uruchamia interaktywną powłokę MongoDB wewnątrz działającego kontenera o nazwie `mongodb`?**

- A) `docker run -it mongodb mongosh`
- B) `docker start mongodb mongosh`
- C) `docker attach mongodb --shell`
- D) `docker exec -it mongodb mongosh`

<details><summary>Odpowiedź</summary>

**D** — `docker exec` wykonuje polecenie w działającym kontenerze, a `-it` daje tryb interaktywny z terminalem. `docker run` utworzyłby nowy kontener (a `mongodb` jest nazwą kontenera, nie obrazu). (slajd 053)

</details>

### Zalety, cechy i zastosowania MongoDB

**2.6. Co oznacza skrót BASE?**

- A) Basically Available, Soft state, Eventual consistency
- B) Basic Atomicity, Strong Eventual consistency
- C) Binary Available, Secure, Encrypted
- D) Balanced Availability, Sharding, Elasticity

<details><summary>Odpowiedź</summary>

**A** — BASE: zasadniczo dostępna, stan miękki, spójna ostatecznie. Daje słabsze gwarancje spójności niż ACID. (slajd 054)

</details>

**2.7. Jak slajd określa bazy dokumentów w odniesieniu do baz klucz-wartość?**

- A) Jako bazy klucz-wartość bez możliwości zapytań
- B) Jako rozszerzone bazy klucz-wartość, w których część wartości można przeszukiwać
- C) Jako bazy grafowe z kluczami
- D) Jako bazy kolumnowe przechowujące JSON

<details><summary>Odpowiedź</summary>

**B** — baza dokumentów rozumie strukturę wartości (dokumentu), więc można ją przeszukiwać i indeksować, a nie tylko pobierać po kluczu. (slajd 055)

</details>

**2.8. Od jakiego słowa pochodzi nazwa MongoDB?**

- A) „humongous” — ogromny
- B) „mongoose” — mangusta
- C) „Mongolia” — od kraju twórców
- D) „monotonic” — monotoniczny

<details><summary>Odpowiedź</summary>

**A** — nazwa pochodzi od „humongous”, co ma podkreślać obsługę bardzo dużych ilości danych. (slajd 056)

</details>

**2.9. Jak MongoDB zapewnia wysoką dostępność według listy kluczowych cech?**

- A) Przez zestawy replik z węzłami podstawowymi i pomocniczymi utrzymującymi kopie danych
- B) Przez indeksowanie dowolnego atrybutu
- C) Przez potok agregacji
- D) Przez zapytania ad hoc

<details><summary>Odpowiedź</summary>

**A** — cecha „Replikacja”: zestawy replik (primary i secondary) zapewniają wysoką dostępność. Indeksowanie służy wydajności zapytań. (slajd 057)

</details>

### Skalowanie i struktura danych

**2.10. Jaki mechanizm realizuje skalowanie poziome w MongoDB?**

- A) Dodanie RAM i CPU do jednego serwera
- B) Replikacja do węzłów secondary
- C) Sharding, czyli dzielenie danych na chunki rozproszone na wielu shardach
- D) GridFS

<details><summary>Odpowiedź</summary>

**C** — skalowanie poziome to sharding (chunki na shardach). Dodanie RAM i CPU to skalowanie pionowe. (slajd 059)

</details>

**2.11. Które zdanie o skalowaniu pionowym jest prawdziwe według slajdu?**

- A) Ma bardzo wysoki, praktycznie nieograniczony limit
- B) Rozkłada obciążenie zapisu i odczytu na wiele węzłów
- C) Wymaga konfiguracji shard key
- D) Jest tańsze na początku, ale koszt rośnie wykładniczo przy dużych wymaganiach

<details><summary>Odpowiedź</summary>

**D** — skalowanie pionowe: niski koszt początkowy, rosnący wykładniczo; limit ograniczony maksymalną specyfikacją sprzętu; poprawia wydajność tylko jednego węzła. (slajd 059)

</details>

### Podstawowe operacje, indeksy i agregacje

**2.12. Którą metodą pobierzesz tylko jeden dokument pasujący do filtra?**

- A) `db.collection.find().one()`
- B) `db.collection.getOne()`
- C) `db.collection.findFirst()`
- D) `db.collection.findOne()`

<details><summary>Odpowiedź</summary>

**D** — `findOne()` zwraca jeden dokument (albo null), a `find()` zwraca kursor. Pozostałe metody nie istnieją w mongosh. (slajd 061)

</details>

**2.13. Które wywołanie poprawnie wstawia wiele dokumentów naraz?**

- A) `db.users.insertMany({name: "A"}, {name: "B"})`
- B) `db.users.insertMany([{name: "A"}, {name: "B"}])`
- C) `db.users.insertOne([{name: "A"}, {name: "B"}])`
- D) `db.users.insertAll([{name: "A"}, {name: "B"}])`

<details><summary>Odpowiedź</summary>

**B** — `insertMany` przyjmuje tablicę dokumentów w nawiasach kwadratowych. W A drugi dokument trafiłby w miejsce opcji, `insertOne` przyjmuje pojedynczy dokument, a `insertAll` nie istnieje. (slajd 061)

</details>

**2.14. Którym poleceniem trwale usuniesz całą kolekcję `orders` (razem z indeksami)?**

- A) `db.orders.deleteMany({})`
- B) `db.orders.remove()`
- C) `db.dropDatabase("orders")`
- D) `db.orders.drop()`

<details><summary>Odpowiedź</summary>

**D** — `drop()` usuwa kolekcję wraz z indeksami. `deleteMany({})` usuwa wszystkie dokumenty, ale kolekcja i indeksy zostają; `db.dropDatabase()` usuwa całą bieżącą bazę. (slajd 061)

</details>

### Modelowanie: osadzanie, referencje, podejście hybrydowe

**2.15. Dla jakich relacji slajd zaleca dokumenty osadzone (embedded documents)?**

- A) Tylko dla N:N
- B) Dla N:N i dużych, współdzielonych zbiorów danych
- C) Dla 1:1 oraz 1:N o ograniczonej liczbie elementów
- D) Wyłącznie dla danych binarnych

<details><summary>Odpowiedź</summary>

**C** — osadzanie jest najlepsze dla 1:1 i 1:N z ograniczoną liczbą elementów i zapewnia szybki odczyt. Referencje są odpowiednie dla 1:N i N:N oraz dla dużych, współdzielonych danych. (slajd 063)

</details>

**2.16. Jaki jest maksymalny rozmiar pojedynczego dokumentu MongoDB?**

- A) 4 MB
- B) 8 MB
- C) 16 MB
- D) 64 MB

<details><summary>Odpowiedź</summary>

**C** — limit dokumentu BSON to 16 MB; większe pliki dzieli się przez GridFS, a rosnące dane przenosi do osobnych kolekcji. (slajdy 064, 072, 073)

</details>

### BSON, JSON i typy danych

**2.17. Które zdanie o BSON jest prawdziwe według slajdów?**

- A) BSON jest tekstowym formatem czytelnym dla człowieka
- B) BSON jest podzbiorem JSON i obsługuje mniej typów
- C) BSON służy głównie do plików konfiguracyjnych
- D) BSON to binarny nadzbiór JSON z dodatkowymi typami, np. Date, Binary, ObjectId, Decimal128

<details><summary>Odpowiedź</summary>

**D** — BSON (Binary JSON) to binarna serializacja, nadzbiór JSON z dodatkowymi typami. (slajdy 065, 068)

</details>

**2.18. Dlaczego BSON ułatwia szybkie przechodzenie (traversal) po dokumencie?**

- A) Bo w BSON zakodowany jest rozmiar każdego elementu, co pozwala go pominąć
- B) Bo BSON sortuje pola alfabetycznie
- C) Bo BSON kompresuje dokument algorytmem zlib
- D) Bo BSON nie obsługuje zagnieżdżeń

<details><summary>Odpowiedź</summary>

**A** — slajd: w BSON rozmiar każdego elementu jest zakodowany, co ułatwia pomijanie elementów. (slajd 065)

</details>

**2.19. Ile bajtów ma ObjectId i ile znaków ma jego zapis szesnastkowy?**

- A) 16 bajtów, 32 znaki
- B) 8 bajtów, 16 znaków
- C) 24 bajty, 12 znaków
- D) 12 bajtów, 24 znaki

<details><summary>Odpowiedź</summary>

**D** — ObjectId ma 12 bajtów; jeden bajt to dwa znaki hex, więc zapis ma 24 znaki. 16 bajtów i 32 znaki to UUID. (slajd 069)

</details>

### Przykład zapytań na kolekcji movies

Pytanie 2.20 dotyczy kolekcji ze slajdu 070:
```js
db.movies.insertMany([
  { title: "Niezniszczalni", year: 2020 },
  { title: "Tomb Raider", year: 2021 },
  { title: "Hobbit", year: 2022 }
]);
```

**2.20. Co zwróci zapytanie `db.movies.find({year:{$gt:2020}}, {_id:0, title:1}).sort({title:-1})`?**

- A) `[{title:"Tomb Raider"}, {title:"Hobbit"}]`
- B) `[{title:"Hobbit"}, {title:"Tomb Raider"}]`
- C) `[{title:"Tomb Raider"}, {title:"Niezniszczalni"}, {title:"Hobbit"}]`
- D) `[{_id:..., title:"Tomb Raider"}, {_id:..., title:"Hobbit"}]`

<details><summary>Odpowiedź</summary>

**A** — `$gt:2020` odrzuca rok 2020, projekcja ukrywa `_id`, a `sort({title:-1})` sortuje malejąco po tytule, więc T przed H. (slajd 070)

</details>

### Dokument, pola i klucze główne

**2.21. Która restrykcja dotycząca nazw pól jest podana na slajdzie?**

- A) Nazwy pól nie mogą zaczynać się od znaku `$`
- B) Nazwy pól muszą zaczynać się od wielkiej litery
- C) Nazwy pól mogą się powtarzać w jednym dokumencie
- D) Nazwy pól nie mogą zawierać cyfr

<details><summary>Odpowiedź</summary>

**A** — `$` jest zarezerwowany dla operatorów zapytań, a `.` służy do pól zagnieżdżonych; nazwy pól muszą być unikalne. Uwaga: od MongoDB 5.0 `$` i `.` są w nazwach pól częściowo dopuszczalne, ale odradzane. (slajd 072)

</details>

**2.22. Które zdanie poprawnie porównuje BinData i GridFS?**

- A) BinData obsługuje strumieniowanie, a GridFS nie
- B) GridFS jest ograniczony do 16 MB, a BinData nie
- C) BinData nadaje się do małych danych (miniatury, klucze, certyfikaty), a GridFS do dużych plików (wideo, PDF, backupy)
- D) Oba mają niską złożoność i identyczne API

<details><summary>Odpowiedź</summary>

**C** — BinData: pole w dokumencie, limit 16 MB, bez strumieniowania, niska złożoność. GridFS: praktycznie dowolny rozmiar, strumieniowanie i częściowe odczyty, średnia złożoność. (slajd 073)

</details>

**2.23. Która właściwość identyfikatora `_id` jest podana na slajdzie o kluczach głównych?**

- A) Może być tablicą
- B) Może być zmieniany przez `$set`
- C) Musi być typu ObjectId
- D) Jest niemutowalny i unikalny w ramach kolekcji

<details><summary>Odpowiedź</summary>

**D** — `_id` jest unikalny w kolekcji, niemutowalny i może być dowolnego typu poza tablicą; ObjectId jest tylko domyślny. (slajd 074)

</details>

### Model zdenormalizowany i znormalizowany, relacje

**2.24. Jakie są zaleta i wada modelu zdenormalizowanego (zagnieżdżone dokumenty) według slajdu?**

- A) Zaleta: mniej zapytań; wada: możliwa duża redundancja
- B) Zaleta: brak redundancji; wada: więcej zapytań
- C) Zaleta: wymuszona spójność; wada: brak indeksów
- D) Zaleta: dowolny rozmiar dokumentu; wada: wolny zapis

<details><summary>Odpowiedź</summary>

**A** — zagnieżdżone dokumenty: mniej zapytań, ale możliwa redundancja; dobre dla 1:1 i 1:N. Wariant B opisuje model znormalizowany. (slajd 076)

</details>

**2.25. Wydawca może mieć nieograniczoną liczbę książek. Gdzie według slajdu przechowywać referencję?**

- A) W dokumencie książki, jako pole `publisher_id`
- B) W dokumencie wydawcy, jako rosnąca tablica `books`
- C) W osobnej kolekcji indeksów
- D) W obu miejscach jednocześnie, zawsze

<details><summary>Odpowiedź</summary>

**A** — przy nieograniczonej liczbie książek tablica `books` w wydawcy rosłaby bez końca, więc referencję do wydawcy trzyma się w każdej książce. Tablica `books` jest dopuszczalna tylko przy niewielkiej, ograniczonej liczbie książek. (slajd 079)

</details>

**2.26. Które stwierdzenie o schemacie w MongoDB jest zgodne ze slajdem „Pytania projektowe”?**

- A) MongoDB wymaga jawnego schematu deklarowanego przed wstawieniem danych
- B) Dokumenty w kolekcji muszą mieć identyczne pola
- C) Schemat w ogóle nie istnieje i nie ma znaczenia
- D) Brak jawnego schematu, ale niejawny schemat i tak jest wymagany

<details><summary>Odpowiedź</summary>

**D** — brak jawnego schematu, lecz dokumenty są zwykle podobne i niejawny schemat jest wymagany; wyzwaniem jest balans wydajności i złożoności struktury. (slajd 075)

</details>

### Antywzorce

**2.27. Jaki jest skutek antywzorca „nieograniczone tablice” według slajdu?**

- A) Tablica może przekroczyć limit rozmiaru dokumentu i obniżyć wydajność indeksu
- B) Zwiększa liczbę kolekcji w bazie
- C) Wymusza użycie `$lookup`
- D) Blokuje replikację

<details><summary>Odpowiedź</summary>

**A** — duża tablica może przekroczyć limit 16 MB i spowodować spadek wydajności indeksu. (slajd 082)

</details>

### Interfejs aplikacyjny i język zapytań

**2.28. Które zdanie o języku zapytań MongoDB jest prawdziwe według slajdu?**

- A) Zapytania w mongosh bazują na SQL
- B) Jedna komenda może jednocześnie odpytywać dowolną liczbę kolekcji
- C) Zapytania odczytu zwracają kursor, a każda komenda dotyczy pojedynczej kolekcji
- D) Zapytania odczytu zawsze zwracają tablicę wszystkich wyników naraz

<details><summary>Odpowiedź</summary>

**C** — zapytania w mongosh bazują na JavaScript, odczyt zwraca kursor umożliwiający iterowanie, a każda komenda dotyczy jednej kolekcji. (slajd 084)

</details>

**2.29. Co oblicza wyrażenie `liczba: { $sum: 1 }` w etapie `$group` ze slajdu?**

- A) Sumę wartości pola `liczba`
- B) Liczbę dokumentów w każdej grupie
- C) Pierwszy dokument w grupie
- D) Liczbę kategorii w kolekcji

<details><summary>Odpowiedź</summary>

**B** — `$sum: 1` dodaje 1 za każdy dokument w grupie, czyli liczy dokumenty (odpowiednik `COUNT(*)`). (slajd 084)

</details>

### SQL kontra MongoDB

**2.30. Które przyporządkowanie pojęć SQL i MongoDB jest poprawne?**

- A) row → collection
- B) table → collection, row → document, column → field
- C) column → document
- D) table → database

<details><summary>Odpowiedź</summary>

**B** — tabela to kolekcja, wiersz to dokument (BSON document), kolumna to pole; database i index pozostają bez zmian, a klucz główny to automatycznie `_id`. (slajd 085)

</details>

**2.31. Które polecenie MongoDB jest odpowiednikiem `ALTER TABLE people ADD join_date DATETIME`?**

- A) `db.people.createIndex({ join_date: 1 })`
- B) `db.people.updateMany({}, { $unset: { join_date: "" } })`
- C) `db.people.updateMany({}, { $set: { join_date: new Date() } })`
- D) `db.people.alter({ add: "join_date" })`

<details><summary>Odpowiedź</summary>

**C** — kolekcje nie wymuszają struktury, ale `updateMany` z pustym filtrem i `$set` dodaje pole do istniejących dokumentów. `$unset` usuwa pole, a `alter` nie istnieje. (slajd 087)

</details>

**2.32. Które polecenie MongoDB odpowiada `CREATE INDEX idx_user_id_asc_age_desc ON people(user_id, age DESC)`?**

- A) `db.people.createIndex({ user_id: -1, age: 1 })`
- B) `db.people.createIndex({ user_id: 1, age: -1 })`
- C) `db.people.createIndex({ user_id: 1 }, { age: "desc" })`
- D) `db.people.createIndex([ "user_id", "age DESC" ])`

<details><summary>Odpowiedź</summary>

**B** — 1 oznacza rosnąco (ASC), -1 malejąco (DESC); oba pola podaje się w jednym dokumencie, w kolejności indeksu. (slajd 088)

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

**3.2. Co robi polecenie `db.dropDatabase()`?**

- A) Usuwa bazę, której nazwę trzeba podać w nawiasie
- B) Usuwa bazę, w której aktualnie się znajdujemy
- C) Usuwa wszystkie bazy poza systemowymi
- D) Usuwa wszystkie kolekcje, ale zostawia pustą bazę na liście

<details><summary>Odpowiedź</summary>

**B** — `dropDatabase()` nie przyjmuje nazwy, kasuje bieżącą bazę; dlatego najpierw przełączamy się przez `use`. Wynik to np. `{ ok: 1, dropped: 'northwind' }`. (slajd 090)

</details>

**3.3. Który parametr jest obowiązkowy przy tworzeniu kolekcji z opcją `capped: true`?**

- A) `max`
- B) `validator`
- C) `size`
- D) `autoIndexId`

<details><summary>Odpowiedź</summary>

**C** — slajd: capped „wymaga parametru size”. `max` (limit liczby dokumentów) jest opcjonalny. (slajd 091)

</details>

### Wstawianie i liczenie dokumentów

**3.4. Które polecenie poprawnie wstawia dwa dokumenty jednym wywołaniem?**

- A) `db.c.insertOne({a: 1}, {a: 2})`
- B) `db.c.insertMany({a: 1}, {a: 2})`
- C) `db.c.insertOne([{a: 1}, {a: 2}])`
- D) `db.c.insertMany([{a: 1}, {a: 2}])`

<details><summary>Odpowiedź</summary>

**D** — `insertMany()` przyjmuje tablicę (listę) dokumentów w nawiasach kwadratowych. `insertOne()` przyjmuje jeden dokument. (slajd 092)

</details>

**3.5. Która metoda podaje przybliżoną liczbę dokumentów na podstawie metadanych kolekcji, bez żadnego filtra?**

- A) `countDocuments()`
- B) `count({})`
- C) `distinct()`
- D) `estimatedDocumentCount()`

<details><summary>Odpowiedź</summary>

**D** — `estimatedDocumentCount()` korzysta z metadanych i jest szybsza; `countDocuments()` liczy dokładnie i przyjmuje filtr. (slajd 093)

</details>

**3.6. Dokończ zdanie z wykładu: „Wszystkie operacje zapisu w MongoDB są atomowe na poziomie…”**

- A) całej kolekcji
- B) pojedynczego dokumentu
- C) całej bazy danych
- D) pojedynczego pola

<details><summary>Odpowiedź</summary>

**B** — zapis jest atomowy na poziomie jednego dokumentu (z jego poddokumentami); operacja na wielu dokumentach jako całość atomowa nie jest. (slajd 094, 097, 107)

</details>

### Aktualizacja dokumentów

**3.7. Które polecenie odpowiada `UPDATE people SET status = "C" WHERE age > 25`?**

- A) `db.people.updateOne({ age: { $gt: 25 } }, { status: "C" })`
- B) `db.people.updateMany({ status: "C" }, { $set: { age: { $gt: 25 } } })`
- C) `db.people.updateMany({ age: { $gt: 25 } }, { $set: { status: "C" } })`
- D) `db.people.update({ $set: { status: "C" } }, { age: { $gt: 25 } })`

<details><summary>Odpowiedź</summary>

**C** — WHERE trafia do filtra (pierwszy argument), SET do `$set` (drugi argument); UPDATE bez ograniczeń zmienia wszystkie pasujące wiersze, więc `updateMany`. (slajd 098)

</details>

**3.8. Która metoda zastępuje cały dokument nowym, zachowując jedynie `_id`?**

- A) `updateOne()`
- B) `replaceOne()`
- C) `updateMany()`
- D) `findOneAndUpdate()`

<details><summary>Odpowiedź</summary>

**B** — `replaceOne(filtr, nowyDokument)`; pola, których nie ma w nowym dokumencie, znikają. (slajd 097, 099)

</details>

**3.9. Dokument ma pole `size: { h: 28, w: 35.5, uom: "in" }`. Które polecenie zmieni TYLKO jednostkę na `"cm"`, zostawiając `h` i `w`?**

- A) `{ $set: { size: { uom: "cm" } } }`
- B) `{ $set: { size.uom: "cm" } }`
- C) `{ $set: { "size.uom": "cm" } }`
- D) `{ $replace: { "size.uom": "cm" } }`

<details><summary>Odpowiedź</summary>

**C** — notacja kropkowa w cudzysłowie zmienia jedno pole poddokumentu. Wariant A nadpisuje cały poddokument `size`, a B bez cudzysłowu to błąd składni JavaScript. (slajd 099)

</details>

### Operatory tablicowe w aktualizacji i tryb upsert

**3.10. Dokument ma `tags: ["mongodb", "uniqueTag"]`. Co zrobi `{ $addToSet: { tags: "uniqueTag" } }`?**

- A) Doda drugi element `"uniqueTag"` na koniec
- B) Zwróci błąd duplikatu
- C) Usunie istniejący `"uniqueTag"`
- D) Nic nie zmieni, bo duplikaty są ignorowane

<details><summary>Odpowiedź</summary>

**D** — `$addToSet` działa jak `$push`, ale pomija wartości, które już są w tablicy. (slajd 104)

</details>

**3.11. Które polecenie doda do tablicy `tags` DWA osobne elementy, `"tag1"` i `"tag2"`?**

- A) `{ $push: { tags: { $each: ["tag1", "tag2"] } } }`
- B) `{ $push: { tags: ["tag1", "tag2"] } }`
- C) `{ $push: { tags: "tag1", tags: "tag2" } }`
- D) `{ $set: { tags: { $each: ["tag1", "tag2"] } } }`

<details><summary>Odpowiedź</summary>

**A** — wiele elementów dodaje się modyfikatorem `$each`. Wariant B doda jeden element będący tablicą, C ma zdublowany klucz, a `$each` nie działa z `$set`. (slajd 104)

</details>

**3.12. Dokument ma `roles: ["user", "editor", "admin"]`. Co usunie `{ $pop: { roles: 1 } }`?**

- A) `"admin"`
- B) `"user"`
- C) `"editor"`
- D) Wszystkie elementy

<details><summary>Odpowiedź</summary>

**A** — `$pop` z `1` usuwa ostatni element, z `-1` pierwszy. (slajd 105)

</details>

**3.13. Kolekcja `users` jest pusta. Jaki dokument powstanie po `db.users.updateOne({ name: "Alice" }, { $set: { age: 30 } }, { upsert: true })`?**

- A) `{ _id: ..., age: 30 }`
- B) `{ _id: ..., name: "Alice" }`
- C) Żaden, bo kolekcja jest pusta
- D) `{ _id: ..., name: "Alice", age: 30 }`

<details><summary>Odpowiedź</summary>

**D** — w trybie update nowy dokument zawiera pola z filtra (query) oraz efekt operatorów z update; `_id` jest tworzone. (slajd 106)

</details>

### Usuwanie dokumentów, findOneAndDelete, findAndModify i bulkWrite

**3.14. Które polecenie usuwa wszystkie dokumenty z kolekcji `inventory`, ale zostawia samą kolekcję?**

- A) `db.inventory.drop()`
- B) `db.inventory.deleteOne({})`
- C) `db.inventory.deleteMany()`
- D) `db.inventory.deleteMany({})`

<details><summary>Odpowiedź</summary>

**D** — `deleteMany({})` z pustym filtrem usuwa wszystkie dokumenty. `drop()` kasuje kolekcję, a `deleteOne({})` usuwa jeden dokument. (slajd 108)

</details>

**3.15. Czym `findOneAndDelete()` różni się od `deleteOne()`?**

- A) Usuwa wszystkie pasujące dokumenty
- B) Nie przyjmuje filtra
- C) Usuwa kolekcję, jeśli jest pusta
- D) Zwraca usunięty dokument i pozwala opcją `sort` wybrać, który zostanie usunięty

<details><summary>Odpowiedź</summary>

**D** — slajd: metoda usuwa jeden dokument, zwraca go i udostępnia opcję sortowania. (slajd 110)

</details>

**3.16. Jak zachowuje się `bulkWrite()` w trybie uporządkowanym (ordered), gdy jedna operacja zgłosi błąd?**

- A) Kontynuuje pozostałe operacje
- B) Cofa wszystkie wcześniejsze operacje
- C) Ponawia błędną operację do skutku
- D) Kończy i nie przetwarza pozostałych operacji z listy

<details><summary>Odpowiedź</summary>

**D** — przy liście uporządkowanej operacje idą szeregowo, a błąd przerywa resztę. Wcześniejsze operacje nie są cofane. (slajd 111)

</details>

**3.17. Która operacja NIE należy do sześciu operacji obsługiwanych przez `bulkWrite()`?**

- A) `replaceOne`
- B) `deleteMany`
- C) `updateMany`
- D) `insertMany`

<details><summary>Odpowiedź</summary>

**D** — bulkWrite obsługuje insertOne, updateOne, updateMany, replaceOne, deleteOne i deleteMany. Wiele wstawień to wiele `insertOne`. (slajd 111)

</details>

### Wyszukiwanie: find, selekcja i notacja kropkowa

**3.18. Jakie dwa parametry przyjmuje `db.collection.find()` i w jakiej kolejności?**

- A) projection, query
- B) query, sort
- C) filter, options
- D) query, projection

<details><summary>Odpowiedź</summary>

**D** — `find(query, projection)`, oba opcjonalne; sortowanie to modyfikator kursora. (slajd 113)

</details>

**3.19. W bazie jest dokument `{ director: { lastName: "Stallone", firstName: "Sylwester" } }`. Co zwróci `db.movies1.find({ director: { firstName: "Sylwester", lastName: "Stallone" } })`?**

- A) Ten dokument, bo wartości się zgadzają
- B) Błąd składni
- C) Nic, bo kolejność pól poddokumentu jest inna
- D) Wszystkie dokumenty z polem `director`

<details><summary>Odpowiedź</summary>

**C** — równość całego poddokumentu wymaga zgodności nazw, wartości, liczby i kolejności pól; konsola na slajdzie pokazuje pusty wynik. (slajd 117, 118)

</details>

**3.20. Które zapytanie zwróci dokumenty, w których poddokument `out1` ma pole `a` równe `"a1"`?**

- A) `db.movies1.find({ "out1.a": "a1" })`
- B) `db.movies1.find({ out1.a: "a1" })`
- C) `db.movies1.find({ out1: "a1" })`
- D) `db.movies1.find({ out1: { $a: "a1" } })`

<details><summary>Odpowiedź</summary>

**A** — wyrażenie z kropką musi być w cudzysłowie; bez niego (B) JavaScript zgłosi błąd składni. (slajd 119)

</details>

### Przegląd operatorów zapytań i operatory porównania

**3.21. Co oznacza operator `$nor`?**

- A) Co najmniej jeden warunek musi być prawdziwy
- B) Wszystkie warunki muszą być prawdziwe
- C) Żaden z warunków nie może być prawdziwy
- D) Neguje jeden operator przy polu

<details><summary>Odpowiedź</summary>

**C** — `$nor`: „żaden z warunków nie może być prawdziwy”. A to `$or`, B to `$and`, D to `$not`. (slajd 121, 126)

</details>

**3.22. Które zdanie o `{ status: { $ne: "inactive" } }` jest prawdziwe?**

- A) Zwraca tylko dokumenty, które mają pole `status`
- B) Wymaga indeksu na polu `status`
- C) Zwraca też dokumenty, które w ogóle nie mają pola `status`
- D) Działa tylko na polach tekstowych

<details><summary>Odpowiedź</summary>

**C** — brak pola też jest „różny od inactive”, dlatego `$ne` (i `$nin`) zwraca również dokumenty bez tego pola. (slajd 122)

</details>

### Operatory $exists, $regex, $text i $expr

**3.23. Która składnia wyszukiwania pełnotekstowego jest poprawna?**

- A) `db.articles.find({ content: { $text: "mongodb baza" } })`
- B) `db.articles.find({ $search: { $text: "mongodb baza" } })`
- C) `db.articles.find({ $text: { $search: "mongodb baza" } })`
- D) `db.articles.find({ $text: "mongodb baza" })`

<details><summary>Odpowiedź</summary>

**C** — `$text` stoi na najwyższym poziomie filtra, a szukany tekst jest w `$search`. Uwaga: komentarz na slajdzie mówi o dokumentach zawierających „mongodb” i „baza”, ale słowa rozdzielone spacją są w rzeczywistości łączone przez OR. (slajd 123)

</details>

**3.24. Które zapytanie zwraca produkty, w których cena (`price`) jest większa od kosztu (`koszt`)?**

- A) `db.products.find({ price: { $gt: "$koszt" } })`
- B) `db.products.find({ $expr: { $gt: ["$price", "$koszt"] } })`
- C) `db.products.find({ $expr: { price: { $gt: "koszt" } } })`
- D) `db.products.find({ $where: { $gt: ["price", "koszt"] } })`

<details><summary>Odpowiedź</summary>

**B** — `$expr` pozwala porównać dwa pola dokumentu; operator przyjmuje tablicę argumentów, a pola zapisuje się jako `"$nazwa"`. A porównuje cenę z tekstem "$koszt". (slajd 123)

</details>

### Operatory tablicowe w zapytaniach: $size, $elemMatch, $all

**3.25. Co gwarantuje `db.courses.find({ grades: { $elemMatch: { subject: "Math", score: { $gte: 80 } } } })`?**

- A) Że wszystkie oceny są z matematyki
- B) Że tablica `grades` ma co najmniej 80 elementów
- C) Że jakaś ocena jest z matematyki i jakaś (być może inna) ma co najmniej 80
- D) Że co najmniej jeden element tablicy jest jednocześnie z matematyki i ma wynik co najmniej 80

<details><summary>Odpowiedź</summary>

**D** — `$elemMatch` wymaga, by wszystkie warunki spełnił ten sam element tablicy. C opisuje zapytanie z notacją kropkową bez `$elemMatch`. (slajd 124)

</details>

**3.26. Kolekcja `movies`: Forrest Gump (Tom Hanks, Robin Wright, Gary Sinise), Cast Away (Tom Hanks), The Green Mile (Tom Hanks, Michael Clarke Duncan). Co zwróci `db.movies.find({ actors: { $all: ["Tom Hanks", "Robin Wright"] } })`?**

- A) Tylko Forrest Gump
- B) Wszystkie trzy filmy
- C) Nic, bo Forrest Gump ma też trzeciego aktora
- D) Cast Away i The Green Mile

<details><summary>Odpowiedź</summary>

**A** — `$all` wymaga obecności wszystkich wymienionych elementów; inne elementy mogą występować. (slajd 125)

</details>

### Operatory logiczne i $not

**3.27. Które zapytanie zwraca zamówienia z ceną poniżej 10 LUB ilością powyżej 100?**

- A) `db.orders.find({ price: { $lt: 10 }, quantity: { $gt: 100 } })`
- B) `db.orders.find({ $or: { price: { $lt: 10 }, quantity: { $gt: 100 } } })`
- C) `db.orders.find({ $or: [ { price: { $lt: 10 } }, { quantity: { $gt: 100 } } ] })`
- D) `db.orders.find({ $in: [ { price: { $lt: 10 } }, { quantity: { $gt: 100 } } ] })`

<details><summary>Odpowiedź</summary>

**C** — `$or` przyjmuje tablicę wyrażeń (dokumentów). A to AND, B ma dokument zamiast tablicy. (slajd 126)

</details>

**3.28. Co zwróci `db.products.find({ price: { $not: { $gt: 100 } } })`?**

- A) Produkty z ceną mniejszą lub równą 100 oraz produkty bez pola `price`
- B) Tylko produkty z ceną mniejszą lub równą 100
- C) Produkty z ceną większą niż 100
- D) Błąd, bo `$not` musi stać na najwyższym poziomie

<details><summary>Odpowiedź</summary>

**A** — slajd mówi „cena nie jest większa niż 100 (tj. ≤ 100)”, ale `$not` zwraca też dokumenty bez danego pola; dlatego nie jest to to samo co `{ price: { $lte: 100 } }`. (slajd 127)

</details>

### Zasady przeszukiwania tablic

**3.29. Czy `db.movies.find({ ratings: { $gte: 2, $lte: 3 } })` dopasuje dokument `{ ratings: [1, 4] }`?**

- A) Tak, bo każdy operator może zostać spełniony przez inny element tablicy (4 ≥ 2, 1 ≤ 3)
- B) Nie, bo żaden element nie leży w przedziale 2–3
- C) Nie, bo operatory porównania nie działają na tablicach
- D) Tak, ale tylko gdy tablica jest posortowana

<details><summary>Odpowiedź</summary>

**A** — slajd: każdy z operatorów musi trafić w co najmniej jeden element, ale nie musi to być ten sam element. (slajd 129)

</details>

### Projekcja

**3.30. Która projekcja jest NIEPOPRAWNA?**

- A) `{ title: 1, actors: 1 }`
- B) `{ title: 1, _id: 0 }`
- C) `{ year: 0, rating: 0 }`
- D) `{ title: 1, year: 0 }`

<details><summary>Odpowiedź</summary>

**D** — nie wolno mieszać włączeń (1) i wyłączeń (0); jedynym wyjątkiem jest `_id`, dlatego B jest poprawne. (slajd 130)

</details>

**3.31. Co zwróci projekcja `{ title: 1, _id: 0, actors: { $slice: -2 } }`?**

- A) Tytuł i dwóch pierwszych aktorów
- B) Tytuł i wszystkich aktorów poza dwoma ostatnimi
- C) Tytuł i dwóch ostatnich aktorów, bez `_id`
- D) Błąd, bo nie można mieszać `1` i `0`

<details><summary>Odpowiedź</summary>

**C** — ujemne `$slice` wybiera ostatnie elementy; `_id: 0` to dozwolony wyjątek. (slajd 131, 132)

</details>

### Modyfikatory kursora: sort, limit, skip

**3.32. Czym różnią się wyniki `db.myColl.find().sort({_id: 1}).limit(6).skip(3)` i `db.myColl.find().sort({_id: 1}).skip(3).limit(6)`?**

- A) Pierwsze zwróci 3 dokumenty, drugie 6
- B) Pierwsze zwróci dokumenty 1–6, drugie 4–9
- C) Pierwsze zwróci błąd
- D) Niczym; oba zwrócą dokumenty od 4. do 9.

<details><summary>Odpowiedź</summary>

**D** — modyfikatory można łączyć w dowolnej kolejności bez skutków ubocznych; serwer zawsze wykonuje sort, potem skip, potem limit. (slajd 133, 135)

</details>

**3.33. Jaka jest kolejność dokumentów zwracanych przez `find()` bez modyfikatora `sort`?**

- A) Zawsze według `_id` rosnąco
- B) Zawsze w kolejności wstawiania
- C) Niezdefiniowana
- D) Alfabetyczna według pierwszego pola

<details><summary>Odpowiedź</summary>

**C** — slajd: „Kolejność dokumentów jest domyślnie niezdefiniowana (chyba że użyto modyfikatora sortowania)”. (slajd 134)

</details>

### Porównanie zapytań SQL i MongoDB

**3.34. Które polecenie odpowiada `SELECT user_id, status FROM people`?**

- A) `db.people.find({ user_id: 1, status: 1 })`
- B) `db.people.find({ }, { user_id: 1, status: 1 })`
- C) `db.people.find({ }, { user_id: 1, status: 1, _id: 0 })`
- D) `db.people.find({ user_id: 1, status: 1, _id: 0 })`

<details><summary>Odpowiedź</summary>

**C** — kolumny trafiają do projekcji (drugi argument), a `_id` trzeba wyłączyć jawnie. B odpowiada `SELECT id, user_id, status`, a A i D traktują projekcję jak filtr. (slajd 137)

</details>

**3.35. Które polecenie odpowiada `SELECT * FROM people WHERE user_id LIKE "%bc%"`?**

- A) `db.people.find({ user_id: /bc/ })`
- B) `db.people.find({ user_id: /^bc/ })`
- C) `db.people.find({ user_id: "%bc%" })`
- D) `db.people.find({ $text: { $search: "bc" } })`

<details><summary>Odpowiedź</summary>

**A** — regex bez kotwic dopasowuje fragment w dowolnym miejscu (równoważnie `{ $regex: /bc/ }`). B to `LIKE "bc%"`, a C szuka dosłownego tekstu z procentami. (slajd 139)

</details>

**3.36. Które polecenie odpowiada `SELECT DISTINCT(status) FROM people`?**

- A) `db.people.find({}, { status: 1 }).unique()`
- B) `db.people.group("status")`
- C) `db.people.distinct("status")`
- D) `db.people.find({ status: { $distinct: true } })`

<details><summary>Odpowiedź</summary>

**C** — `distinct("status")` (dla zbiorów wartości nieprzekraczających limitu rozmiaru BSON) albo agregacja `aggregate([ { $group: { _id: "$status" } } ])`. (slajd 140)

</details>

## 4. MongoDB — walidacja schematu, Aggregation Framework, import i indeksy

### Walidacja schematu

**4.1. Który operator umieszczony w opcji `validator` służy do walidacji strukturalnej w stylu JSON Schema?**

- A) `$schema`
- B) `$validate`
- C) `$jsonSchema`
- D) `$expr`

<details><summary>Odpowiedź</summary>

**C** — `$jsonSchema` opisuje typy pól, pola wymagane i dodatkowe właściwości. `$expr` też może stać w walidatorze, ale służy do warunków logicznych i porównań, nie do opisu struktury. (slajd 142)

</details>

**4.2. Dlaczego przy `additionalProperties: false` w `properties` wpisuje się `_id: {}`?**

- A) Żeby `_id` musiało być obiektem
- B) Bo `_id` jest dodawane automatycznie i bez tego wpisu zostałoby uznane za pole spoza schematu, więc każdy insert byłby odrzucony
- C) Żeby wyłączyć automatyczne generowanie `_id`
- D) Żeby `_id` stało się polem wymaganym

<details><summary>Odpowiedź</summary>

**B** — pusty obiekt `{}` dopuszcza pole `_id` bez narzucania typu. Na slajdzie komentarz: „zostawiamy systemowe pole”. (slajdy 143, 145)

</details>

**4.3. Jakie wartości może przyjąć `validationLevel`?**

- A) `error`, `warn`
- B) `strict`, `lenient`, `none`
- C) `strict`, `moderate`, `off`
- D) `on`, `off`, `warn`

<details><summary>Odpowiedź</summary>

**C** — `error` i `warn` to wartości `validationAction`, a nie `validationLevel`. (slajdy 143, 144)

</details>

**4.4. Jak wyłączyć walidację kolekcji `posts`, nie kasując zapisanych reguł?**

- A) `db.posts.drop()`
- B) `db.runCommand({ collMod: "posts", validator: {} })`
- C) `db.runCommand({ collMod: "posts", validationLevel: "off" })`
- D) `db.runCommand({ collMod: "posts", validationAction: "off" })`

<details><summary>Odpowiedź</summary>

**C** — `validationLevel: "off"` wyłącza walidację, a reguły zostają. B kasuje reguły, a `validationAction` nie ma wartości `off`. (slajd 144)

</details>

### Aggregation Framework i potok agregacji

**4.5. Jaką główną korzyść potoku agregacji podkreśla wykład?**

- A) Pozwala pominąć indeksy
- B) Większość operacji wykonuje się po stronie serwera, co ogranicza transfer danych i poprawia wydajność aplikacji
- C) Przenosi obliczenia do przeglądarki użytkownika
- D) Zastępuje replikację danych

<details><summary>Odpowiedź</summary>

**B** — dane są przetwarzane w bazie, a do aplikacji trafia tylko wynik. (slajd 146)

</details>

**4.6. Czego według slajdu nie ma w zapytaniu MQL, a co potrafi potok agregacji?**

- A) Sortowania
- B) Grupowania
- C) Limitowania wyników
- D) Projekcji pól

<details><summary>Odpowiedź</summary>

**B** — slajd: odpowiednik MQL daje ten sam wynik, „nie ma tutaj jednak grupowania”. Find potrafi filtrować, sortować, limitować i rzutować. (slajd 148)

</details>

**4.7. Jak poprawnie wyświetlić plan wykonania ze statystykami dla potoku agregacji?**

- A) `db.persons.aggregate(pipeline).explain("executionStats")`
- B) `db.persons.aggregate(pipeline, "executionStats")`
- C) `db.persons.explain(pipeline).aggregate("executionStats")`
- D) `db.persons.explain("executionStats").aggregate(pipeline)`

<details><summary>Odpowiedź</summary>

**D** — przy agregacji `explain(tryb)` stoi przed `aggregate(pipeline)`. Przy `find` jest odwrotnie: `find(query).explain(tryb)`. (slajd 149)

</details>

### SQL a operatory agregacji, grupowanie i `$group`

**4.8. Któremu etapowi agregacji odpowiada klauzula SQL `HAVING`?**

- A) `$match` umieszczonemu po `$group`
- B) `$group`
- C) `$project`
- D) `$having`

<details><summary>Odpowiedź</summary>

**A** — w tabeli ze slajdu `HAVING` → `$match`. Operatora `$having` nie ma; o roli `$match` decyduje jego pozycja w potoku. (slajd 151)

</details>

**4.9. Który operator odpowiada SQL `MERGE INTO TABLE`?**

- A) `$out`
- B) `$unionWith`
- C) `$set`
- D) `$merge`

<details><summary>Odpowiedź</summary>

**D** — `$merge` (od MongoDB 4.2) scala wynik z istniejącą kolekcją, a `$out` ją zastępuje. (slajd 151)

</details>

**4.10. Który zapis etapu `$group` jest składniowo poprawny?**

- A) `{ $group: { _id: "$cust_id" }, total: { $sum: "$amount" } }`
- B) `{ $group: { total: { $sum: "$amount" } } }`
- C) `{ $group: { _id: "$cust_id", total: { $sum: "$amount" } } }`
- D) `{ $group: "$cust_id", total: { $sum: "$amount" } }`

<details><summary>Odpowiedź</summary>

**C** — pola wynikowe muszą stać wewnątrz `$group` obok `_id`. Uwaga: ogólny zapis na slajdzie 152 zamyka `$group` zaraz po `_id` (jak w A), co jest błędem. B nie ma obowiązkowego `_id`. (slajdy 152, 155)

</details>

**4.11. Jak w `$group` policzyć liczbę dokumentów w każdej grupie?**

- A) `{ $count: 1 }`
- B) `{ $sum: "1" }`
- C) `{ $avg: 1 }`
- D) `{ $sum: 1 }`

<details><summary>Odpowiedź</summary>

**D** — slajd: „Jeżeli chcemy zliczyć ilość dokumentów w danej grupie, użyjemy { $sum : 1 }”. Za każdy dokument dodawana jest jedynka. (slajdy 152, 155)

</details>

**4.12. Czym różni się akumulator `$addToSet` od `$push`?**

- A) `$addToSet` zbiera do tablicy tylko unikalne wartości, a `$push` wszystkie, z duplikatami
- B) `$addToSet` sumuje wartości, a `$push` je liczy
- C) `$push` zbiera tylko unikalne wartości
- D) Nie ma różnicy, to aliasy

<details><summary>Odpowiedź</summary>

**A** — tabela akumulatorów: `$push` zbiera wartości do tablicy, `$addToSet` zbiera unikalne wartości do tablicy. (slajdy 152, 155)

</details>

### Etapy `$limit`, `$project`, `$sort`, `$match`

**4.13. Który potok zwróci trzy najdroższe produkty?**

- A) `[{ $limit: 3 }, { $sort: { cena: -1 } }]`
- B) `[{ $sort: { cena: 1 } }, { $limit: 3 }]`
- C) `[{ $sort: { cena: -1 } }, { $count: 3 }]`
- D) `[{ $sort: { cena: -1 } }, { $limit: 3 }]`

<details><summary>Odpowiedź</summary>

**D** — najpierw sortowanie malejące, potem limit. A sortuje tylko trzy przypadkowe dokumenty, B daje najtańsze, a `$count` przyjmuje napis. Slajd: `$limit` stosuj po `$sort` lub `$match`. (slajd 157)

</details>

**4.14. Jakie pola będą w wyniku `db.restaurants.aggregate([ { $project: { "name": 1, "cuisine": 1, "address": 1 } } ])`?**

- A) Tylko `name`, `cuisine`, `address`
- B) `_id`, `name`, `cuisine`, `address`
- C) Wszystkie pola poza `name`, `cuisine`, `address`
- D) Wszystkie pola dokumentu

<details><summary>Odpowiedź</summary>

**B** — `_id` jest dołączane domyślnie, chyba że jawnie wykluczysz je przez `_id: 0`. Przykładowy wynik na slajdzie zawiera `_id`. (slajd 158)

</details>

**4.15. Jakimi wartościami określa się kierunek sortowania w `$sort`?**

- A) `"asc"` i `"desc"`
- B) `true` i `false`
- C) `1` (rosnąco) i `-1` (malejąco)
- D) `0` (rosnąco) i `1` (malejąco)

<details><summary>Odpowiedź</summary>

**C** — slajd: wartość 1 oznacza sortowanie rosnące, a -1 malejące. (slajd 161)

</details>

**4.16. Który etap wybierze produkty z kategorii „elektronika” LUB „meble”?**

- A) `{ $match: { kategoria: "elektronika", kategoria: "meble" } }`
- B) `{ $match: { $or: [ { kategoria: "elektronika" }, { kategoria: "meble" } ] } }`
- C) `{ $match: { $and: [ { kategoria: "elektronika" }, { kategoria: "meble" } ] } }`
- D) `{ $match: { kategoria: { $all: ["elektronika", "meble"] } } }`

<details><summary>Odpowiedź</summary>

**B** — `$or` z tablicą warunków. W A drugi klucz nadpisuje pierwszy, C i D wymagają obu wartości naraz. Równoważnie można użyć `$in`. (slajd 163)

</details>

### Etapy `$addFields` i `$count`

**4.17. Czym `$addFields` różni się od `$project`?**

- A) `$addFields` usuwa wszystkie pola poza nowymi
- B) `$addFields` działa tylko na tablicach
- C) Niczym, to aliasy
- D) `$addFields` zachowuje wszystkie istniejące pola i dodaje nowe (lub nadpisuje istniejące), a `$project` zostawia tylko wymienione pola i `_id`

<details><summary>Odpowiedź</summary>

**D** — slajd: `$addFields` dodaje nowe pola lub modyfikuje istniejące. Aliasem `$addFields` jest `$set`, nie `$project`. (slajd 165)

</details>

**4.18. Jak poprawnie zapisać etap `$count`?**

- A) `{ $count: 1 }`
- B) `{ $count: { total: 1 } }`
- C) `{ $count: "$cuisine" }`
- D) `{ $count: "totalChinese" }`

<details><summary>Odpowiedź</summary>

**D** — argumentem jest napis z nazwą pola wynikowego. Nazwa nie może zaczynać się od `$`. (slajdy 166, 167)

</details>

### Etapy `$lookup` i `$out`

**4.19. Jakie cztery pola wymaga podstawowa postać `$lookup`?**

- A) `from`, `on`, `to`, `as`
- B) `from`, `localField`, `foreignField`, `as`
- C) `collection`, `localKey`, `foreignKey`, `into`
- D) `join`, `localField`, `foreignField`, `result`

<details><summary>Odpowiedź</summary>

**B** — `from` (kolekcja do dołączenia), `localField` (pole w kolekcji podstawowej), `foreignField` (pole w kolekcji `from`), `as` (nazwa nowego pola). (slajdy 168, 169)

</details>

**4.20. Co zawiera pole wskazane w `as` po etapie `$lookup`?**

- A) Pojedynczy dołączony dokument albo `null`
- B) Liczbę dopasowanych dokumentów
- C) Tylko `_id` dopasowanych dokumentów
- D) Tablicę pasujących dokumentów z kolekcji `from` (pustą, gdy brak dopasowań)

<details><summary>Odpowiedź</summary>

**D** — w przykładzie `movie_details` to tablica z jednym dokumentem filmu. Pojedynczy obiekt uzyskuje się dopiero np. przez `$unwind`. (slajd 168)

</details>

**4.21. Co stanie się, gdy `$out` wskaże kolekcję, która już istnieje?**

- A) Wynik zostanie dopisany do istniejących dokumentów
- B) Operacja zakończy się błędem
- C) Istniejąca kolekcja zostanie zastąpiona, a jej dotychczasowe dane usunięte
- D) Zostanie utworzona kolekcja z sufiksem `_1`

<details><summary>Odpowiedź</summary>

**C** — slajd: `$out` tworzy nową kolekcję, jeśli nie istnieje, lub zastępuje istniejącą. Dopisywanie i scalanie to rola `$merge`. (slajd 171)

</details>

### Import danych (`mongoimport`) i Map-Reduce

**4.22. Które polecenie zaimportuje plik `Customer05.json` do kolekcji `clients` w bazie `customers`?**

- A) `db.clients.import("Customer05.json")`
- B) `mongoimport --database customers --table clients Customer05.json`
- C) `mongoimport --db=customers --collection=clients --file=Customer05.json`
- D) `mongorestore --db=customers --collection=clients --file=Customer05.json`

<details><summary>Odpowiedź</summary>

**C** — opcje `--db`, `--collection`, `--file`. `mongorestore` odtwarza kopie BSON z `mongodump`, a opcji `--table` nie ma. (slajd 172)

</details>

**4.23. Jaki jest status Map-Reduce w MongoDB według wykładu?**

- A) Zalecana metoda agregacji dużych danych
- B) Jedyny sposób zapisu wyniku do nowej kolekcji
- C) Mechanizm przestarzały; potok agregacji zapewnia lepszą wydajność i użyteczność
- D) Mechanizm dostępny tylko w Atlasie

<details><summary>Odpowiedź</summary>

**C** — tytuł slajdu: „Map-Reduce - przestarzały”; agregacja jest wydajniejsza. Wynik do kolekcji zapisuje też `$out`. (slajd 173)

</details>

### Indeksy: cel, rodzaje, TTL

**4.24. Które polecenie utworzy indeks gwarantujący unikalność adresów e-mail?**

- A) `db.uzytkownicy.createIndex({ email: 1 }, { unique: true })`
- B) `db.uzytkownicy.createIndex({ email: "unique" })`
- C) `db.uzytkownicy.createUniqueIndex({ email: 1 })`
- D) `db.uzytkownicy.createIndex({ email: 1, unique: 1 })`

<details><summary>Odpowiedź</summary>

**A** — `unique: true` to opcja w drugim argumencie. D tworzy indeks złożony na polach `email` i `unique`. (slajd 175)

</details>

**4.25. Co robi `db.sesje.createIndex({ utworzone: 1 }, { expireAfterSeconds: 3600 })`?**

- A) Tworzy indeks TTL, który automatycznie usuwa dokumenty po godzinie od czasu w polu `utworzone`
- B) Usuwa indeks po godzinie
- C) Blokuje zapisy do kolekcji przez godzinę
- D) Tworzy indeks, który odświeża się co godzinę

<details><summary>Odpowiedź</summary>

**A** — 3600 sekund to godzina; indeks TTL (Time-To-Live) usuwa dokumenty po upływie czasu. Usuwanie robi proces w tle, więc nie jest co do sekundy. (slajd 176)

</details>

### Indeksy jednopolowe, złożone i multikey

**4.26. Które zapytanie skorzysta wydajnie z indeksu złożonego `{ userid: 1, score: -1 }`?**

- A) Filtr tylko po `userid`
- B) Filtr tylko po `score`
- C) Filtr po polu `name`
- D) Żadne, indeks złożony działa tylko, gdy podasz wszystkie pola i w tej samej kolejności w filtrze

<details><summary>Odpowiedź</summary>

**A** — `userid` jest prefiksem indeksu (reguła prefiksu). Zapytanie wyłącznie po `score` nie wykorzysta go wydajnie. Kolejność pól w dokumencie filtra nie ma znaczenia. (slajd 179)

</details>

**4.27. Jak utworzyć indeks multikey na polu tablicowym `tagi`?**

- A) `db.produkty.createIndex({ tagi: 1 }, { multikey: true })`
- B) `db.produkty.createIndex({ tagi: "multikey" })`
- C) `db.produkty.createIndex({ tagi: 1 })` — MongoDB sam ustawi typ multikey, gdy pole zawiera tablicę
- D) `db.produkty.createMultikeyIndex({ tagi: 1 })`

<details><summary>Odpowiedź</summary>

**C** — slajd: „Nie musisz jawnie określać typu multikey”; indeks na polu z tablicą automatycznie staje się multikey. (slajdy 176, 180)

</details>

### Indeks wektorowy

**4.28. Które polecenie tworzy indeks wektorowy z wykładu?**

- A) `db.embedded_movies.createIndex({ plot_embedding_voyage_3_large: "vector" })`
- B) `db.embedded_movies.createSearchIndex("vector_index", "vectorSearch", { fields: [ { type: "vector", path: "plot_embedding_voyage_3_large", numDimensions: 2048, similarity: "cosine" } ] })`
- C) `db.embedded_movies.createVectorIndex("plot_embedding_voyage_3_large", 2048)`
- D) `db.embedded_movies.createSearchIndex({ vector: "plot_embedding_voyage_3_large" })`

<details><summary>Odpowiedź</summary>

**B** — indeksy wyszukiwania tworzy `createSearchIndex(nazwa, typ, definicja)`, wyświetla `getSearchIndexes()`, a usuwa `dropSearchIndex()`. (slajd 181)

</details>

**4.29. Którego etapu agregacji używa się do wyszukiwania po indeksie wektorowym?**

- A) `$search`
- B) `$near`
- C) `$text`
- D) `$vectorSearch`

<details><summary>Odpowiedź</summary>

**D** — `$vectorSearch` z polami `index`, `path`, `queryVector`, `numCandidates`, `limit`; musi być pierwszym etapem potoku. (slajdy 182, 183)

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

### Arbiter, heartbeat i failover

**5.3. Które zdanie poprawnie opisuje arbitra zestawu replik?**

- A) Przechowuje pełną kopię danych i może zostać primary
- B) Uczestniczy w wyborach, nie posiada kopii danych i nie może zostać wybrany na primary
- C) Przechowuje kopię danych, ale nie głosuje
- D) Kieruje zapytania aplikacji do odpowiednich węzłów

<details><summary>Odpowiedź</summary>

**B** — Arbiter tylko głosuje (vote only), nie ma danych i nigdy nie zostaje primary. D opisuje router mongos. (slajd 187)

</details>

### Sharding i skalowanie

**5.4. Czym jest sharding (fragmentowanie) w MongoDB?**

- A) Tworzeniem wielu identycznych kopii danych
- B) Kompresją dokumentów w blokach
- C) Metodą dystrybucji danych na wielu komputerach
- D) Rodzajem indeksu złożonego

<details><summary>Odpowiedź</summary>

**C** — Sharding to dystrybucja danych na wiele maszyn dla bardzo dużych zbiorów danych i dużej przepustowości. A opisuje replikację. (slajd 189)

</details>

**5.5. Czym jest skalowanie pionowe?**

- A) Dodawaniem kolejnych serwerów do klastra
- B) Zwiększaniem mocy pojedynczego serwera (CPU, RAM, dysk), które ma praktyczne maksimum
- C) Podziałem kolekcji na shardy
- D) Dodawaniem węzłów secondary

<details><summary>Odpowiedź</summary>

**B** — Skalowanie pionowe (scale up) to mocniejsza jedna maszyna. A i C to skalowanie poziome. (slajd 190)

</details>

**5.6. Która cecha jest pożądana dla klucza shardującego?**

- A) Mała kardynalność, np. pole z płcią
- B) Wartości monotonicznie rosnące, np. data utworzenia
- C) Wartość typu logicznego
- D) Duża kardynalność i równomierny rozkład wartości

<details><summary>Odpowiedź</summary>

**D** — Dobry klucz ma wiele różnych, równomiernie rozłożonych wartości. Mała kardynalność i klucze monotoniczne prowadzą do nierównego rozkładu i gorących punktów. (slajd 191, wiedza o MongoDB)

</details>

**5.7. Które polecenie shardowuje kolekcję `zamowienia` w bazie `sklep` z kluczem haszowanym na polu `klientId`?**

- A) `db.zamowienia.shard({ klientId: "hashed" })`
- B) `rs.shardCollection("sklep.zamowienia", { klientId: "hashed" })`
- C) `sh.shardCollection("sklep.zamowienia", { klientId: "hashed" })`
- D) `sh.enableCollection("zamowienia", "klientId")`

<details><summary>Odpowiedź</summary>

**C** — Shardowanie kolekcji wykonuje `sh.shardCollection` z pełną nazwą „baza.kolekcja” i dokumentem klucza. Prefiks `rs.` dotyczy zestawów replik, a metody z A i D nie istnieją. (slajd 191, wiedza o MongoDB)

</details>

### Klaster shardowany i architektura

**5.8. Z jakich trzech komponentów składa się klaster shardowany MongoDB?**

- A) Primary, secondary, arbiter
- B) mongod, mongosh, Compass
- C) Shard, oplog, balancer
- D) Shardy, routery mongos, serwery konfiguracyjne

<details><summary>Odpowiedź</summary>

**D** — Sharded cluster to shardy (dane), mongos (router) i config servers (metadane). A to role w zestawie replik. (slajd 192)

</details>

### Time Series: cechy i tworzenie kolekcji

**5.9. Jak nazywają się jednostki, w które MongoDB grupuje dane szeregów czasowych według okresów czasu?**

- A) Chunks
- B) Shards
- C) Partitions
- D) Buckets („wiaderka”)

<details><summary>Odpowiedź</summary>

**D** — Dane Time Series trafiają do buckets, co daje kompresję. Chunks to zakresy klucza w shardingu. (slajd 196)

</details>

**5.10. Uzupełnij: `db.createCollection("sensor_data", { ____: { timeField: "timestamp", metaField: "metadata" } })`**

- A) `timeSeries`
- B) `time_series`
- C) `timeseries`
- D) `series`

<details><summary>Odpowiedź</summary>

**C** — Opcja nazywa się `timeseries`, małymi literami i razem. (slajd 197)

</details>

**5.11. Jakie wartości przyjmuje parametr `granularity`?**

- A) `"ms"`, `"s"`, `"min"`
- B) `"seconds"`, `"minutes"`, `"hours"`
- C) `"low"`, `"medium"`, `"high"`
- D) `"day"`, `"week"`, `"month"`

<details><summary>Odpowiedź</summary>

**B** — Granularity przyjmuje `seconds`, `minutes` albo `hours` i opisuje typowy odstęp między pomiarami z jednego źródła. (slajd 197, 204, wiedza o MongoDB)

</details>

### Operatory dat i średnia miesięczna

**5.12. Co zwróci `{ $dateTrunc: { date: "$date", unit: "month" } }` dla daty `ISODate("2020-06-17T14:30:00Z")`?**

- A) `ISODate("2020-06-30T00:00:00Z")`
- B) Liczbę `6`
- C) `{ year: 2020, month: 6 }`
- D) `ISODate("2020-06-01T00:00:00Z")`

<details><summary>Odpowiedź</summary>

**D** — `$dateTrunc` obcina datę do początku jednostki, stąd nazwa pola `firstDayOfMonth`. C przypomina wynik `$dateToParts`. (slajd 202)

</details>

### Średnia ruchoma: $setWindowFields

**5.13. Czym `$setWindowFields` różni się od `$group`?**

- A) `$setWindowFields` zwija dokumenty do jednego na grupę
- B) Niczym, to synonimy
- C) `$setWindowFields` działa tylko razem z `$merge`
- D) `$setWindowFields` zachowuje każdy dokument i dopisuje mu pole wyliczone w oknie

<details><summary>Odpowiedź</summary>

**D** — Wynik na slajdzie to pełny dokument notowania z dopisanym `averageMonthClosingPrice`. `$group` zwraca jeden dokument na grupę. (slajd 203)

</details>

### Listowanie kolekcji Time Series

**5.14. Które polecenie wylistuje kolekcje Time Series w bieżącej bazie?**

- A) `db.getCollectionNames({ type: "timeseries" })`
- B) `db.runCommand({ listCollections: 1, filter: { type: "timeseries" } })`
- C) `show timeseries`
- D) `db.listTimeSeries()`

<details><summary>Odpowiedź</summary>

**B** — Slajd pokazuje polecenie `listCollections` z filtrem po `type`. `getCollectionNames` nie przyjmuje filtra, a C i D nie istnieją. (slajd 204)

</details>

### Widoki zmaterializowane

**5.15. Który etap na końcu potoku tworzy widok zmaterializowany `dailytemperatureaverages` na slajdzie 205?**

- A) `$project`
- B) `$lookup`
- C) `$merge`
- D) `$set`

<details><summary>Odpowiedź</summary>

**C** — `$merge: { into: "dailytemperatureaverages", whenMatched: "replace" }` zapisuje wynik agregacji do kolekcji. (slajd 205)

</details>

### Automatyczne usuwanie: expireAfterSeconds

**5.16. Jak wyłączyć automatyczne usuwanie w kolekcji `weather24h`?**

- A) `db.runCommand({ collMod: "weather24h", expireAfterSeconds: 0 })`
- B) `db.runCommand({ collMod: "weather24h", expireAfterSeconds: "off" })`
- C) `db.runCommand({ collMod: "weather24h", expireAfterSeconds: false })`
- D) `db.runCommand({ collMod: "weather24h", expireAfterSeconds: null })`

<details><summary>Odpowiedź</summary>

**B** — Wyłączenie to napis `"off"`, nie zero, `false` ani `null`. (slajd 206)

</details>

### Przykład IoT: zużycie energii

**5.17. Który operator w przykładzie IoT liczy energię zużytą przez klimatyzator, czyli pole pod wykresem mocy w czasie?**

- A) `$sum`
- B) `$integral`
- C) `$derivative`
- D) `$avg`

<details><summary>Odpowiedź</summary>

**B** — `consumedKilowattHours: { $integral: { input: "$powerKilowatts", unit: "hour" }, window: {...} }`. `$derivative` liczy tempo zmian, a nie pole pod wykresem. (slajd 207)

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

**6.2. Do którego zastosowania baza klucz–wartość nadaje się NAJGORZEJ?**

- A) Filtrowanie rekordów po wielu polach wartości jednocześnie
- B) Przechowywanie danych sesyjnych
- C) Koszyk zakupowy użytkownika
- D) Liczniki polubień i wyświetleń

<details><summary>Odpowiedź</summary>

**A** — Przeszukiwanie wielu rekordów według różnych kryteriów jest na liście „kiedy nie używać”. Sesje, koszyki i liczniki są typowymi zastosowaniami. (slajd 210)

</details>

### Redis – ogólna charakterystyka

**6.3. Co oznacza nazwa Redis?**

- A) REliable DIstributed Storage
- B) REal-time DIctionary System
- C) REdundant DIsk Server
- D) REmote DIctionary Server

<details><summary>Odpowiedź</summary>

**D** — Redis to REmote DIctionary Server. Na rysunku ze slajdu 216 pojawia się wersja „Service”, ale oficjalnie jest „Server”. (slajd 212)

</details>

**6.4. Jakie dwa mechanizmy trwałości (zapisu na dysk) ma Redis?**

- A) WAL i checkpoint
- B) Journal i oplog
- C) RDB i AOF
- D) SSTable i memtable

<details><summary>Odpowiedź</summary>

**C** — Redis może opcjonalnie zapisywać dane na dysk przez RDB (migawki) i AOF (Append Only File, dziennik operacji). (slajd 212)

</details>

**6.5. Która struktura danych Redis jest na slajdzie wskazana do zliczania unikalnych gości?**

- A) Bitmap
- B) HyperLogLog
- C) Sorted Set
- D) Stream

<details><summary>Odpowiedź</summary>

**B** — HyperLogLog (np. unikalni goście). Bitmap to flagi, Sorted Set rankingi, Stream strumienie zdarzeń. (slajd 212)

</details>

### Zarządzanie kluczami, zapytania i inne funkcje

**6.6. Jaki problem slajd przypisuje auto-inkrementowanym kluczom?**

- A) Nie da się ich użyć w Redisie
- B) Problemy z podziałem na klastry serwerów i ze znaczeniem
- C) Zajmują więcej niż 512 MB
- D) Nie mogą mieć prefiksów

<details><summary>Odpowiedź</summary>

**B** — Auto-inkrementacja ma problemy z podziałem na klastry serwerów (wspólny licznik) i ze znaczeniem (liczba nic nie mówi). (slajd 213)

</details>

### Redis: historia, architektura, funkcje

**6.7. W którym roku powstał Redis według slajdu?**

- A) 2004
- B) 2007
- C) 2009
- D) 2012

<details><summary>Odpowiedź</summary>

**C** — Na rysunku jest rok 2009. Twórcą jest Włoch Salvatore Sanfilippo (stąd kontur Włoch). (slajd 216)

</details>

**6.8. Jaką wydajność Redisa podaje slajd „Funkcje Redis”?**

- A) Do 81 000 SET/s i 110 000 GET/s
- B) Do 1 000 000 SET/s i 1 000 000 GET/s
- C) Do 11 000 SET/s i 8 100 GET/s
- D) Do 110 000 SET/s i 81 000 GET/s

<details><summary>Odpowiedź</summary>

**D** — Ładuje do 110 000 SET na sekundę i 81 000 GET na sekundę. Wariant A zamienia liczby. (slajd 220)

</details>

### Docker, VS Code i Redis Stack Browser

**6.9. Które polecenie uruchamia kontener Redis Stack w tle z portami jak na slajdzie?**

- A) `docker start -it redis-stack -p 6379:6379 -p 8001:8001`
- B) `docker exec -d --name redis-stack -p 6379:6379 redis/redis-stack:latest`
- C) `docker run -d --name redis-stack -p 6379:6379 -p 8001:8001 redis/redis-stack:latest`
- D) `docker pull -d redis-stack 6379 8001`

<details><summary>Odpowiedź</summary>

**C** — docker run tworzy i uruchamia kontener, -d to tryb detached, --name nadaje nazwę, -p mapuje porty host:kontener. (slajd 222)

</details>

**6.10. Jaki znak zachęty pokazuje redis-cli połączone z lokalnym serwerem na domyślnym porcie?**

- A) `redis:8001>`
- B) `127.0.0.1:6379>`
- C) `localhost:27017>`
- D) `test>`

<details><summary>Odpowiedź</summary>

**B** — Domyślny port Redisa to 6379. 27017 to domyślny port MongoDB, a `test>` to znak zachęty mongosh. (slajd 222)

</details>

### Polecenia do zarządzania kluczami

**6.11. Które polecenie ustawia wygaśnięcie klucza po podanej liczbie MILISEKUND?**

- A) `EXPIRE`
- B) `EXPIREAT`
- C) `PEXPIRE`
- D) `PEXPIREAT`

<details><summary>Odpowiedź</summary>

**C** — PEXPIRE ustawia wygaśnięcie w milisekundach. EXPIRE działa w sekundach, a wersje z AT przyjmują znacznik czasu UNIX (moment, nie odstęp). (slajd 226)

</details>

**6.12. Co zwróci `TTL mykey`, jeśli klucz mykey istnieje, ale nie ma ustawionego wygaśnięcia?**

- A) `(integer) 0`
- B) `(nil)`
- C) `(integer) -2`
- D) `(integer) -1`

<details><summary>Odpowiedź</summary>

**D** — TTL zwraca -1 dla klucza bez wygaśnięcia i -2 dla klucza, który nie istnieje. (slajd 226, wiedza o Redisie)

</details>

### Typy danych i limity

**6.13. Jaki jest maksymalny rozmiar pojedynczej wartości typu string w Redisie według slajdu?**

- A) 64 KB
- B) 16 MB
- C) 512 MB
- D) 4 GB

<details><summary>Odpowiedź</summary>

**C** — Wartość (string) do 512 MB; klucz również do 512 MB, choć zaleca się małe klucze. 16 MB to limit dokumentu BSON w MongoDB. (slajd 227)

</details>

### Redis Strings

**6.14. Co zwróci ostatnie polecenie, jeśli klucz `licznik` wcześniej nie istniał?**

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

**6.15. Które polecenie ustawia wiele kluczy naraz, ale TYLKO wtedy, gdy żaden z nich jeszcze nie istnieje?**

- A) `MSETNX`
- B) `MSET`
- C) `SETNX`
- D) `MGET`

<details><summary>Odpowiedź</summary>

**A** — MSETNX działa na wielu kluczach na zasadzie wszystko albo nic: jeśli choć jeden istnieje, nic nie jest ustawiane. SETNX dotyczy jednego klucza. (slajd 229, 230)

</details>

### SET, GET, GETDEL, MGET, SETEX

**6.16. Co się dzieje z czasem życia (TTL) klucza po pomyślnym zwykłym `SET` bez dodatkowych opcji?**

- A) TTL zostaje zachowany
- B) TTL jest usuwany
- C) TTL jest resetowany do 60 s
- D) SET kończy się błędem, jeśli klucz ma TTL

<details><summary>Odpowiedź</summary>

**B** — Poprzedni TTL jest usuwany po pomyślnym SET. Żeby go zachować, dodaje się opcję KEEPTTL. (slajd 231)

</details>

**6.17. Które polecenie zapisze klucz `anotherkey`, który wygaśnie po minucie?**

- A) `SET anotherkey "will expire in a minute" PX 60`
- B) `SET anotherkey EX 60 "will expire in a minute"`
- C) `SET anotherkey "will expire in a minute" EX 60`
- D) `SETEX anotherkey "will expire in a minute" 60`

<details><summary>Odpowiedź</summary>

**C** — EX podaje sekundy po wartości. PX 60 to 60 ms; w B opcja stoi przed wartością; SETEX ma kolejność key seconds value. (slajd 231)

</details>

**6.18. Co zwróci ostatnie polecenie?**

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

### Redis Lists

**6.19. Którą parę poleceń użyjesz, aby lista działała jak kolejka FIFO?**

- A) `LPUSH` i `RPOP`
- B) `LPUSH` i `LPOP`
- C) `RPUSH` i `RPOP`
- D) `SADD` i `SPOP`

<details><summary>Odpowiedź</summary>

**A** — Kolejka wymaga wkładania i zdejmowania z przeciwnych stron. LPUSH+LPOP oraz RPUSH+RPOP to stos (LIFO), a SPOP zdejmuje losowo. (slajd 236)

</details>

**6.20. Co zwróci ostatnie polecenie (lista mylist wcześniej nie istniała)?**

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

### Redis Sets

**6.21. Które polecenie zwraca liczebność (rozmiar) zbioru?**

- A) `LLEN`
- B) `SMEMBERS`
- C) `STRLEN`
- D) `SCARD`

<details><summary>Odpowiedź</summary>

**D** — SCARD (od cardinality) zwraca liczbę członków zbioru. LLEN to długość listy, STRLEN długość stringa. (slajd 240, 243)

</details>

**6.22. Czym różni się `SPOP` od `SRANDMEMBER`?**

- A) SPOP usuwa zwrócone losowe elementy, SRANDMEMBER tylko je zwraca
- B) SRANDMEMBER usuwa elementy, SPOP tylko je zwraca
- C) SPOP zwraca zawsze pierwszy dodany element
- D) Nie różnią się, to aliasy

<details><summary>Odpowiedź</summary>

**A** — SPOP usuwa i zwraca losowych członków; SRANDMEMBER zwraca losowych członków bez usuwania. (slajd 242, 243)

</details>

### JSON w Redis Stack

**6.23. Które polecenie JSON jest aliasem `JSON.DEL`?**

- A) `JSON.CLEAR`
- B) `JSON.ARRPOP`
- C) `JSON.FORGET`
- D) `JSON.TOGGLE`

<details><summary>Odpowiedź</summary>

**C** — JSON.FORGET również „Deletes a value”, jest aliasem JSON.DEL. JSON.CLEAR czyści tablice/obiekty i zeruje liczby. (slajd 244)

</details>

**6.24. Które polecenie poprawnie zmieni pole model roweru bikes:1 na napis Hyperion1?**

- A) `JSON.SET bikes:1 $.model Hyperion1`
- B) `JSON.SET bikes:1 $.model '"Hyperion1"'`
- C) `SET bikes:1.model "Hyperion1"`
- D) `JSON.GET bikes:1 $.model "Hyperion1"`

<details><summary>Odpowiedź</summary>

**B** — Wartość musi być poprawnym JSON, więc napis ma cudzysłowy wewnątrz apostrofów. Bez cudzysłowów (A) to nie jest poprawny JSON. (slajd 245)

</details>

**6.25. Które polecenie zwraca OSTATNI element tablicy status_log w dokumencie school_json:1?**

- A) `JSON.GET school_json:1 $.status_log[-1]`
- B) `JSON.GET school_json:1 $.status_log[0]`
- C) `JSON.GET school_json:1 $.status_log[last]`
- D) `JSON.ARRPOP school_json:1 $.status_log 0`

<details><summary>Odpowiedź</summary>

**A** — Indeks -1 to ostatni element, 0 pierwszy. ARRPOP z indeksem 0 usunąłby pierwszy element. (slajd 246)

</details>

### JSONPath

**6.26. Jak w JSONPath wybrać TRZECIĄ książkę (XPath `//book[3]`)?**

- A) `$..book[3]`
- B) `$..book[-3]`
- C) `$..book[:3]`
- D) `$..book[2]`

<details><summary>Odpowiedź</summary>

**D** — JSONPath indeksuje od 0, XPath od 1, więc trzecia książka to `[2]`. (slajd 248)

</details>

### Indeksowanie: FT.CREATE

**6.27. Co oznacza fragment `PREFIX 1 "bikes:"` w `FT.CREATE idx:bikes ON JSON PREFIX 1 "bikes:" SCHEMA ...`?**

- A) Indeks obejmie tylko pierwszy klucz bikes:
- B) Indeks obejmie klucze z jednym prefiksem: bikes:
- C) Indeks zostanie zapisany w bazie logicznej nr 1
- D) Pole bikes: ma wagę 1 w wyszukiwaniu

<details><summary>Odpowiedź</summary>

**B** — Liczba po PREFIX to liczba podanych prefiksów; indeksowane są klucze zaczynające się od bikes:. (slajd 249)

</details>

**6.28. Którego typu pola użyjesz do dokładnego dopasowania kategorii, np. type „eBikes”?**

- A) TEXT
- B) NUMERIC
- C) TAG
- D) GEO

<details><summary>Odpowiedź</summary>

**C** — TAG pozwala na dokładne dopasowanie (komentarz przy `$.class AS class TAG`). TEXT służy do wyszukiwania pełnotekstowego, NUMERIC do zakresów liczb, GEO do położenia. (slajd 249, 250)

</details>

### Zapytania FT.SEARCH i agregacje FT.AGGREGATE

**6.29. Jak w FT.SEARCH wyszukać rowery, których pole TAG `type` ma wartość eBikes?**

- A) `FT.SEARCH idx:bikes "@type:[eBikes]"`
- B) `FT.SEARCH idx:bikes "@type:{eBikes}"`
- C) `FT.SEARCH idx:bikes "type = eBikes"`
- D) `FT.SEARCH idx:bikes "$.type:eBikes"`

<details><summary>Odpowiedź</summary>

**B** — Pola TAG odpytuje się w nawiasach klamrowych `@pole:{wartość}`. Nawiasy kwadratowe są dla zakresów NUMERIC. (slajd 251)

</details>

**6.30. Dlaczego w zapytaniu poniżej po RETURN stoi liczba 9?**

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

### Transakcje

**6.31. Którym poleceniem rozpoczyna się transakcję w Redisie, a którym ją wykonuje?**

- A) BEGIN i COMMIT
- B) WATCH i EXEC
- C) MULTI i EXEC
- D) MULTI i DISCARD

<details><summary>Odpowiedź</summary>

**C** — MULTI oznacza początek bloku, EXEC wykonuje zakolejkowane polecenia. DISCARD je odrzuca. (slajd 253)

</details>

### Nowe funkcje Redis Stack

**6.32. Jakie algorytmy obsługuje Vector Similarity Search w Redis Stack według slajdu?**

- A) B-drzewo i LSM
- B) MapReduce i PageRank
- C) HNSW i brute-force
- D) Raft i Paxos

<details><summary>Odpowiedź</summary>

**C** — Vector Similarity Search: obsługa hashy i JSON, algorytmy HNSW i brute-force. (slajd 254)

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

**7.2. Czym charakteryzują się transakcyjne (OLTP) bazy grafowe według wykładu?**

- A) Dużą liczbą małych lub średnich grafów
- B) Małą liczbą bardzo dużych grafów
- C) Jednym globalnym grafem bez transakcji
- D) Wyłącznie grafami nieskierowanymi

<details><summary>Odpowiedź</summary>

**A** — OLTP to duża liczba małych lub średnich grafów. Mała liczba bardzo dużych grafów to OLAP. (slajd 256)

</details>

**7.3. Kiedy według wykładu NIE należy używać bazy grafowej?**

- A) Gdy trzeba wyszukać najkrótszą ścieżkę
- B) Gdy operacje dotyczą wielu węzłów bądź krawędzi naraz
- C) Gdy dane opisują sieć społecznościową
- D) Gdy trzeba wyszukać podobne obiekty

<details><summary>Odpowiedź</summary>

**B** — slajd „Kiedy nie używać?” wymienia operacje dotyczące wielu węzłów bądź krawędzi oraz bardzo duże, złożone grafy w dużej liczbie. Pozostałe odpowiedzi to typowe zastosowania. (slajd 256)

</details>

### Neo4j

**7.4. Jakim rodzajem bazy jest Neo4j?**

- A) Natywną bazą grafową
- B) Relacyjną bazą z rozszerzeniem grafowym
- C) Bazą dokumentową z indeksem grafowym
- D) Bazą rodziny kolumn

<details><summary>Odpowiedź</summary>

**A** — Neo4j to natywna baza grafowa, przechowująca dane jako węzły, relacje i etykiety. Rozszerzeniem grafowym bazy relacyjnej jest np. SQL Server Graph. (slajd 258)

</details>

**7.5. Jak nazywa się język zapytań Neo4j?**

- A) Gremlin
- B) SPARQL
- C) Cypher
- D) CQL

<details><summary>Odpowiedź</summary>

**C** — Neo4j używa języka Cypher, podobnego do SQL, ale dostosowanego do grafów. Gremlin to język m.in. JanusGraph i Cosmos DB, SPARQL służy do RDF, a CQL to język Cassandry. (slajd 260)

</details>

**7.6. Który zapis w Cypherze oznacza skierowaną relację typu ZNA od węzła a do węzła b?**

- A) `(a)<-[:ZNA]-(b)`
- B) `(a)-(:ZNA)->(b)`
- C) `(a)-[:ZNA]->(b)`
- D) `[a]-(:ZNA)->[b]`

<details><summary>Odpowiedź</summary>

**C** — relacja stoi w nawiasach kwadratowych między myślnikami, a grot `->` wskazuje kierunek do b. Wersja A ma odwrotny kierunek, a w B i D zamieniono nawiasy węzłów i relacji. (slajd 258)

</details>

### Neo4j — podstawowe operacje w Cypherze

**7.7. Które zapytanie wyszukuje węzły Person o imieniu John?**

- A) `SELECT * FROM Person WHERE name = "John"`
- B) `MATCH (n:Person) WHERE n.name = "John" RETURN n`
- C) `FIND (n:Person) WHERE n.name == "John"`
- D) `MATCH [n:Person] WHERE n.name = "John" RETURN n`

<details><summary>Odpowiedź</summary>

**B** — wyszukiwanie to MATCH, filtr WHERE, wynik RETURN. SELECT to SQL, FIND nie istnieje w Cypherze, a węzeł nie stoi w nawiasach kwadratowych. (slajd 261)

</details>

**7.8. Co się stanie po wykonaniu `MATCH (n:Person) DELETE n`, jeśli węzły Person mają relacje z innymi węzłami?**

- A) Usunięte zostaną węzły i automatycznie ich relacje
- B) Usunięte zostaną tylko relacje, węzły zostaną
- C) Polecenie zakończy się błędem; do usunięcia węzłów z relacjami potrzebne jest `DETACH DELETE n`
- D) Usunięty zostanie tylko pierwszy znaleziony węzeł

<details><summary>Odpowiedź</summary>

**C** — Neo4j nie pozwala usunąć węzła, który ma relacje. DETACH DELETE najpierw usuwa relacje, a potem węzeł. Slajd pokazuje samo DELETE, bez tej uwagi. (slajd 261)

</details>

### SQL Server Graph — architektura i tabele

**7.9. Które zdanie o właściwościach tabel w SQL Graph jest zgodne z diagramem architektury?**

- A) Tabela krawędzi musi mieć co najmniej jedną właściwość
- B) Tabela węzłów nie może mieć właściwości
- C) Tabela węzłów ma właściwości, a tabela krawędzi może je mieć albo nie
- D) Ani tabela węzłów, ani krawędzi nie mają właściwości

<details><summary>Odpowiedź</summary>

**C** — diagram mówi: „Node table has Properties” i „Edge table may or may not have Properties”. Przykład: `CREATE TABLE friendOf AS EDGE;` bez kolumn. (slajd 262)

</details>

**7.10. W której wersji SQL Server wprowadzono GraphTable (tabele węzłów i krawędzi)?**

- A) SQL Server 2012
- B) SQL Server 2016
- C) SQL Server 2017
- D) SQL Server 2022

<details><summary>Odpowiedź</summary>

**C** — slajd: „Wprowadzony w SQL Server 2017”. W wersji 2019 doszły m.in. SHORTEST_PATH i ograniczenia krawędzi. (slajd 263)

</details>

**7.11. Które polecenie tworzy w SQL Server tabelę wierzchołków?**

- A) `CREATE TABLE Persons (ID INT PRIMARY KEY, Name NVARCHAR(100)) AS NODE;`
- B) `CREATE NODE TABLE Persons (ID INT PRIMARY KEY, Name NVARCHAR(100));`
- C) `CREATE TABLE Persons (ID INT PRIMARY KEY, Name NVARCHAR(100)) AS VERTEX;`
- D) `CREATE GRAPH Persons (ID INT, Name NVARCHAR(100)) NODE;`

<details><summary>Odpowiedź</summary>

**A** — tabelę węzłów tworzy zwykłe CREATE TABLE z klauzulą `AS NODE` na końcu. Słów CREATE NODE TABLE, AS VERTEX czy CREATE GRAPH T-SQL nie zna. (slajd 266)

</details>

**7.12. Jakie pseudokolumny ma tabela krawędzi w SQL Server?**

- A) `$node_id`, `$from_id`, `$to_id`
- B) `$edge_id`, `$source_id`, `$target_id`
- C) `$edge_id`, `$start_id`, `$end_id`
- D) `$edge_id`, `$from_id`, `$to_id`

<details><summary>Odpowiedź</summary>

**D** — tabela krawędzi ma `$edge_id` (identyfikator krawędzi) oraz `$from_id` i `$to_id` (węzły, które krawędź łączy). Nazw source/target i start/end SQL Server nie używa. (slajd 267)

</details>

### GraphTable w praktyce — przykład z restauracjami

**7.13. Co trzeba podać przy wstawianiu wiersza do tabeli krawędzi?**

- A) Tylko wartości właściwości krawędzi
- B) Wartości `$node_id` węzłów dla kolumn `$from_id` i `$to_id`
- C) Wartość `$edge_id` w formacie JSON
- D) Zwykłe klucze ID węzłów, np. 1 i 2

<details><summary>Odpowiedź</summary>

**B** — komentarz na slajdzie: przy wstawianiu do tabeli krawędzi trzeba podać `$node_id` dla kolumn `$from_id` i `$to_id`. `$edge_id` generuje system, a zwykłe ID nie wystarczy. (slajd 271)

</details>

**7.14. Jak w MATCH zapisano warunek „osoba lubi restaurację w tym samym mieście, w którym mieszka”?**

- A) Dwoma osobnymi klauzulami MATCH połączonymi OR
- B) Dwoma wzorcami w jednym MATCH, połączonymi AND i używającymi tych samych aliasów Person i City
- C) Podzapytaniem EXISTS z JOIN na kolumnie city
- D) Jednym wzorcem Person-(livesIn)->Restaurant

<details><summary>Odpowiedź</summary>

**B** — `MATCH (Person-(likes)->Restaurant-(locatedIn)->City AND Person-(livesIn)->City)`. Te same aliasy oznaczają tę samą osobę i to samo miasto. OR i NOT nie są w MATCH obsługiwane. (slajd 272)

</details>

### Zastosowania i ograniczenia GraphTable

**7.15. Które z poniższych MOŻE być tabelą węzłów lub krawędzi w SQL Server?**

- A) Lokalna tabela tymczasowa `#Persons`
- B) Zmienna tabelowa `@Persons`
- C) Tabela zoptymalizowana pod kątem pamięci
- D) Zwykła tabela utworzona przez `CREATE TABLE ... AS NODE`

<details><summary>Odpowiedź</summary>

**D** — tabele tymczasowe lokalne i globalne, typy tabel, zmienne tabelowe i tabele zoptymalizowane pod kątem pamięci nie mogą być tabelami grafowymi. (slajd 275)

</details>

**7.16. Jak zmienić węzeł docelowy istniejącej krawędzi, skoro slajd wymienia ograniczenie dotyczące `$to_id`?**

- A) `UPDATE likes SET $to_id = ...`
- B) `ALTER EDGE likes SET $to_id = ...`
- C) Usunąć krawędź przez DELETE i wstawić nową przez INSERT
- D) `UPDATE likes SET $edge_id = ...`

<details><summary>Odpowiedź</summary>

**C** — użytkownicy nie mogą aktualizować `$from_id` i `$to_id` instrukcją UPDATE, więc krawędź trzeba usunąć i wstawić ponownie. Zwykłe właściwości krawędzi, np. rating, można aktualizować. (slajd 275)

</details>

### MATCH kontra JOIN i rekomendacja utworów

**7.17. Jaką główną tezę ilustruje slajd „Match is more concise than joins”?**

- A) MATCH zawsze wykonuje się dziesięć razy szybciej niż JOIN
- B) MATCH działa tylko w Azure, a JOIN tylko w SQL Server
- C) MATCH zapisuje ten sam wzorzec zwięźlej niż seria warunków złączenia
- D) JOIN nie może używać pseudokolumn grafu

<details><summary>Odpowiedź</summary>

**C** — slajd pokazuje to samo zapytanie w dwóch wersjach; MATCH jest krótszy i czytelniejszy. O szybkości slajd nic nie mówi, a wersja z JOIN właśnie używa pseudokolumn. (slajd 277)

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

**8.2. Kiedy według wykładu NIE należy używać baz rodziny kolumn?**

- A) Przy blogach i systemach CMS
- B) Gdy trzeba przechowywać bardzo duże wolumeny danych
- C) Gdy wymagana jest skalowalność pozioma
- D) Gdy wymagane są transakcje ze ścisłą spójnością i złożone agregacje lub złączenia

<details><summary>Odpowiedź</summary>

**D** — Slajd wymienia: transakcje ze ścisłą spójnością, złożone zapytania (SUM, AVG, złączenia) oraz często zmieniany schemat. Blogi i CMS to przykład zastosowania. (slajd 281)

</details>

**8.3. Która baza jest na pierwszym miejscu rankingu DB-Engines w kategorii Wide Column Stores pokazanego na wykładzie?**

- A) Apache HBase
- B) Microsoft Azure Cosmos DB
- C) Apache Cassandra
- D) ScyllaDB

<details><summary>Odpowiedź</summary>

**C** — Cassandra jest na szczycie z wynikiem ok. 100; HBase ma tendencję malejącą, Cosmos DB jest niżej. (slajd 282)

</details>

### Apache Cassandra: cechy i architektura

**8.4. Jak zorganizowane są węzły w klastrze Cassandry?**

- A) Jeden węzeł master i wiele węzłów replik tylko do odczytu
- B) Węzły config server, router i shardy
- C) Równorzędne węzły peer-to-peer, bez pojedynczego punktu awarii
- D) Węzeł koordynujący na stałe przypisany do każdego centrum danych

<details><summary>Odpowiedź</summary>

**C** — Wszystkie węzły są równorzędne (peer-to-peer), co eliminuje pojedynczy punkt awarii. (slajd 284, 305)

</details>

**8.5. Kto pierwotnie stworzył Apache Cassandrę?**

- A) Google
- B) Amazon
- C) LinkedIn
- D) Facebook

<details><summary>Odpowiedź</summary>

**D** — Cassandrę stworzył Facebook, a obecnie zarządza nią Apache Software Foundation. Google stworzył Bigtable, Amazon Dynamo. (slajd 305)

</details>

### Partycjonowanie: klucz partycji, token, Murmur3, pierścień

**8.6. Jaka jest prawidłowa kolejność kroków przy umieszczaniu danych w klastrze Cassandry?**

- A) Węzeł → token → funkcja hash → klucz partycji
- B) Klucz partycji → węzeł → token → funkcja hash
- C) Klucz partycji → funkcja hash (np. Murmur3) → token → węzeł
- D) Token → klucz partycji → funkcja hash → węzeł

<details><summary>Odpowiedź</summary>

**C** — Cassandra nie przechowuje danych bezpośrednio według klucza: klucz jest haszowany do tokenu, a token wskazuje węzeł. (slajd 289)

</details>

**8.7. Jak nazywa się domyślny partycjoner Cassandry?**

- A) Murmur3Partitioner
- B) RandomPartitioner
- C) ByteOrderedPartitioner
- D) HashRangePartitioner

<details><summary>Odpowiedź</summary>

**A** — Domyślny jest Murmur3Partitioner. RandomPartitioner (MD5) i ByteOrderedPartitioner to starsze partycjonery; HashRangePartitioner nie istnieje. (slajd 290)

</details>

**8.8. Jaki jest zakres tokenów przy Murmur3Partitioner?**

- A) od 0 do 2^64
- B) od −2^63 do +2^63 − 1
- C) od −2^31 do +2^31 − 1
- D) od 0 do 2^127

<details><summary>Odpowiedź</summary>

**B** — Zakres to −2^63 … +2^63 − 1, czyli zakres 64-bitowej liczby ze znakiem. (slajd 290)

</details>

**8.9. Które zdanie o funkcji Murmur3 jest prawdziwe?**

- A) To kryptograficzna funkcja skrótu używana do szyfrowania danych
- B) Zachowuje kolejność kluczy, dzięki czemu można robić zapytania zakresowe po kluczu partycji
- C) Generuje 128-bitowy identyfikator UUID
- D) To szybka, niekryptograficzna funkcja haszująca zapewniająca równomierny rozkład danych

<details><summary>Odpowiedź</summary>

**D** — Murmur3 jest szybka i niekryptograficzna; jej celem jest równomierny rozkład. Nie zachowuje kolejności kluczy. (slajd 290)

</details>

### Partycja, kolumny grupujące i złożony klucz partycji

**8.10. Za co odpowiada kolumna `timestamp` w kluczu `PRIMARY KEY (sensor_id, timestamp)`?**

- A) Określa węzeł, na którym leżą dane
- B) Jest drugą częścią klucza partycji
- C) Określa token partycji
- D) Jest kolumną grupującą i określa kolejność danych wewnątrz partycji

<details><summary>Odpowiedź</summary>

**D** — `sensor_id` to Partition Key (lokalizacja danych), a `timestamp` to Clustering Column (kolejność w partycji). (slajd 292)

</details>

**8.11. Co jest kluczem partycji w definicji poniżej?**

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

**8.12. Dlaczego `PRIMARY KEY (sensor_type, timestamp)` z wartością `sensor_type = 'temperature'` jest na wykładzie przykładem złego projektu?**

- A) Bo `timestamp` nie może być kolumną grupującą
- B) Bo klucz partycji musi być typu UUID
- C) Bo miliony rekordów trafiają do jednej partycji
- D) Bo tabela nie ma klucza partycji

<details><summary>Odpowiedź</summary>

**C** — Klucz o niskiej kardynalności tworzy gigantyczną partycję (Bad Design). (slajd 293)

</details>

### Węzły wirtualne, rebalancing i dobre praktyki

**8.13. Czym są węzły wirtualne (vnodes)?**

- A) Węzłami, które przechowują tylko metadane klastra
- B) Mechanizmem, w którym fizyczny węzeł przechowuje wiele małych zakresów tokenów zamiast jednego dużego
- C) Kopiami zapasowymi węzłów w innym centrum danych
- D) Węzłami uruchomionymi w maszynach wirtualnych

<details><summary>Odpowiedź</summary>

**B** — Zamiast jednego dużego zakresu tokenów węzeł ma wiele małych (Token Range 1…N). (slajd 294)

</details>

**8.14. Które z poniższych jest zaleceniem przy projektowaniu klucza partycji?**

- A) Wysoka kardynalność klucza i równomierny rozkład wartości
- B) Jak najmniejsza liczba różnych kluczy
- C) Projektowanie tabel jak w bazie relacyjnej
- D) Jak największe partycje, by ograniczyć liczbę odczytów

<details><summary>Odpowiedź</summary>

**A** — Zalecenia: wysoka kardynalność, równomierny rozkład, ograniczona wielkość partycji, modelowanie pod zapytania. Pozostałe odpowiedzi są na liście „unikać”. (slajd 295)

</details>

**8.15. Co według podsumowania wykładu jest najczęstszym problemem projektowym w Cassandrze?**

- A) Brak indeksów pomocniczych
- B) Hot Partition
- C) Zbyt wiele przestrzeni kluczy
- D) Za mały współczynnik replikacji

<details><summary>Odpowiedź</summary>

**B** — Podsumowanie: „Najczęstszy problem projektowy to Hot Partition”. (slajd 295)

</details>

### Modelowanie danych: projektowanie od zapytań

**8.16. Które zestawienie SQL i Cassandry jest zgodne z wykładem?**

- A) SQL: denormalizacja; Cassandra: normalizacja
- B) SQL: zapytania → model danych; Cassandra: model danych → zapytania
- C) SQL: model danych → zapytania, normalizacja, JOIN; Cassandra: zapytania → model danych, denormalizacja, brak JOIN
- D) Obie bazy wspierają JOIN, ale Cassandra wolniej

<details><summary>Odpowiedź</summary>

**C** — Dokładnie tak wygląda tabela porównawcza na slajdzie. (slajd 299)

</details>

**8.17. Wymaganie: „Pokaż wszystkie pomiary dla czujnika z ostatnich 24 godzin”. Które zapytanie odpowiada modelowi `PRIMARY KEY (sensor_id, timestamp)`?**

- A) `SELECT * FROM sensor_data WHERE timestamp >= ? AND timestamp <= ?;`
- B) `SELECT * FROM sensor_data WHERE sensor_id = ? AND timestamp >= ? AND timestamp <= ?;`
- C) `SELECT * FROM sensor_data WHERE value >= ?;`
- D) `SELECT * FROM sensor_data JOIN sensors ON sensor_id;`

<details><summary>Odpowiedź</summary>

**B** — Równość na kluczu partycji i zakres na kolumnie grupującej. A pomija klucz partycji, C filtruje po kolumnie spoza klucza, D używa JOIN. (slajd 300)

</details>

**8.18. Jak wykład definiuje denormalizację?**

- A) Celowe powielenie danych dla szybszych odczytów
- B) Usuwanie powtórzeń danych w celu oszczędności miejsca
- C) Rozbicie tabeli na mniejsze tabele połączone kluczami obcymi
- D) Zamianę kolekcji na typy natywne

<details><summary>Odpowiedź</summary>

**A** — „Denormalizacja to celowe powielenie danych dla szybszych odczytów.” Ta sama informacja może być w wielu tabelach. (slajd 301)

</details>

**8.19. Pojawia się nowe ważne zapytanie `SELECT * FROM orders WHERE product_id = ?`, a `product_id` nie jest w kluczu tabeli. Co zwykle robi się w Cassandrze według wykładu?**

- A) Dodaje się do zapytania ALLOW FILTERING i problem jest rozwiązany
- B) Tworzy się nową tabelę `orders_by_product` zoptymalizowaną pod to zapytanie
- C) Zmienia się klucz główny istniejącej tabeli przez ALTER TABLE
- D) Łączy się tabele `orders` i `products` przez JOIN

<details><summary>Odpowiedź</summary>

**B** — „Nowe ważne zapytanie często oznacza nową tabelę.” ALLOW FILTERING to błąd modelowania, klucza głównego nie da się zmienić, a JOIN nie istnieje. (slajd 302)

</details>

### Model danych Cassandry: struktura, wartości, kolekcje, TTL i timestamp

**8.20. W jakim trybie mogą być zagnieżdżane krotki, UDT i kolekcje wewnątrz kolekcji?**

- A) static
- B) counter
- C) nested
- D) frozen

<details><summary>Odpowiedź</summary>

**D** — Zagnieżdżenia są dozwolone tylko w trybie frozen (wartość zapisywana i zmieniana w całości). (slajd 309)

</details>

**8.21. Które zdanie o kolekcjach w Cassandrze jest prawdziwe?**

- A) Zbiór jest nieuporządkowany, a lista posortowana alfabetycznie
- B) Lista jest uporządkowana pozycyjnie i dopuszcza duplikaty; zbiór ma unikalne wartości wewnętrznie uporządkowane
- C) Mapa dopuszcza powtarzające się klucze
- D) Lista wymaga unikalnych wartości

<details><summary>Odpowiedź</summary>

**B** — Lista: porządek pozycyjny, wartości nie muszą być unikalne. Zbiór: unikalne, wewnętrznie uporządkowane. Mapa: unikalne klucze, uporządkowana po kluczach. (slajd 310)

</details>

**8.22. Co oznacza literał `{ dlugosc: 100 }` w kolumnie `wlasciwosci` tabeli `filmy`?**

- A) Mapę z kluczem tekstowym `dlugosc`
- B) Zbiór z jednym elementem
- C) Krotkę z jedną wartością
- D) Wartość typu definiowanego przez użytkownika (UDT) z polem `dlugosc`

<details><summary>Odpowiedź</summary>

**D** — Nazwa pola bez apostrofów przed dwukropkiem to literał UDT (typ `szczegoly`). Klucz mapy byłby w apostrofach, np. `{ 'dlugosc': 100 }`. (slajd 312, 331)

</details>

### Narzędzia i język CQL

**8.23. Które polecenia CQL wykład zalicza do wyrażeń DDL?**

- A) SELECT i INSERT
- B) UPDATE i DELETE
- C) CREATE KEYSPACE i CREATE TABLE
- D) INSERT i CREATE TABLE

<details><summary>Odpowiedź</summary>

**C** — DDL: CREATE KEYSPACE, CREATE TABLE. DML: SELECT, INSERT, UPDATE, DELETE. (slajd 315)

</details>

### DDL: przestrzeń kluczy i replikacja

**8.24. Która opcja jest obowiązkowa przy `CREATE KEYSPACE`?**

- A) `durable_writes`
- B) `replication`
- C) `clustering_order`
- D) `default_time_to_live`

<details><summary>Odpowiedź</summary>

**B** — Opcja replication jest obowiązkowa. (slajd 316)

</details>

**8.25. Które polecenie poprawnie tworzy przestrzeń kluczy z trzema replikami w jednym centrum danych?**

- A) `CREATE KEYSPACE filmydb WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 3}`
- B) `CREATE DATABASE filmydb WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 3}`
- C) `CREATE KEYSPACE filmydb replication ('SimpleStrategy', 3)`
- D) `CREATE KEYSPACE filmydb WITH replication = ['SimpleStrategy', 3]`

<details><summary>Odpowiedź</summary>

**A** — Składnia: CREATE KEYSPACE nazwa WITH replication = mapa w klamrach. CREATE DATABASE nie istnieje w CQL, a opcja replication jest mapą, nie listą. (slajd 316)

</details>

**8.26. Czym różni się NetworkTopologyStrategy od SimpleStrategy?**

- A) NetworkTopologyStrategy wyłącza replikację
- B) SimpleStrategy pozwala ustawić osobny współczynnik replikacji dla każdego centrum danych
- C) NetworkTopologyStrategy pozwala ustawić indywidualny poziom replikacji dla każdego centrum danych
- D) Nie różnią się, to synonimy

<details><summary>Odpowiedź</summary>

**C** — SimpleStrategy ma tylko jeden poziom replikacji; NetworkTopologyStrategy — osobny dla każdego centrum danych. (slajd 316)

</details>

### DDL: tabele i klucze główne

**8.27. Jakie role pełnią kolumny w `PRIMARY KEY (a, b, c)`?**

- A) `a`, `b`, `c` razem tworzą klucz partycji
- B) `a` jest kluczem partycji, `b` i `c` są kolumnami grupującymi
- C) `a` i `b` tworzą klucz partycji, `c` jest kolumną grupującą
- D) `c` jest kluczem partycji, `a` i `b` są kolumnami grupującymi

<details><summary>Odpowiedź</summary>

**B** — Bez wewnętrznego nawiasu kluczem partycji jest tylko pierwsza kolumna, reszta to kolumny grupujące. (slajd 321)

</details>

**8.28. W jakich nawiasach zapisuje się złożony klucz partycji w definicji klucza głównego?**

- A) W nawiasach klamrowych `{ }`
- B) W nawiasach kwadratowych `[ ]`
- C) W wewnętrznych nawiasach okrągłych `( )`
- D) W nawiasach ostrych `< >`

<details><summary>Odpowiedź</summary>

**C** — Np. `PRIMARY KEY ((a, b), c)`. Slajd 321 mówi „w nawiasach klamrowych”, ale to błąd — w składni (diagram i przykład na slajdach 293 i 320) są nawiasy okrągłe; klamry oznaczają zbiory, mapy i UDT. (slajd 321)

</details>

**8.29. Co robi klauzula w definicji tabeli poniżej?**

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

**8.30. Czym różni się `TRUNCATE` od `DROP TABLE`?**

- A) TRUNCATE usuwa tabelę wraz z danymi, DROP TABLE tylko dane
- B) Oba usuwają tylko dane
- C) TRUNCATE usuwa przestrzeń kluczy
- D) TRUNCATE zachowuje tabelę, ale usuwa jej dane; DROP TABLE usuwa tabelę wraz z danymi

<details><summary>Odpowiedź</summary>

**D** — Po DROP TABLE tabeli nie ma, po TRUNCATE tabela zostaje pusta. (slajd 322)

</details>

### Typy danych

**8.31. Ile bajtów zajmują kolejno typy `tinyint`, `smallint`, `int`, `bigint`?**

- A) 1, 2, 4, 8
- B) 2, 4, 8, 16
- C) 1, 2, 3, 4
- D) 4, 4, 8, 8

<details><summary>Odpowiedź</summary>

**A** — To liczby całkowite ze znakiem na 1, 2, 4 i 8 bajtach. (slajd 324)

</details>

**8.32. Które zdanie o typie `counter` jest prawdziwe?**

- A) Można mu ustawić dowolną wartość przez `SET licznik = 100`
- B) Może być częścią klucza głównego
- C) Wspiera tylko inkrementację i dekrementację
- D) Wspiera TTL

<details><summary>Odpowiedź</summary>

**C** — counter (8 B ze znakiem) wspiera tylko inkrementację i dekrementację; nie może być w kluczu głównym i nie wspiera TTL. (slajd 326)

</details>

**8.33. Jak wygląda deklaracja typu krotki i jej literał?**

- A) Deklaracja `TUPLE<TEXT, TEXT>`, literał `( 'Numer', '123-456-789' )`
- B) Deklaracja `TUPLE(TEXT, TEXT)`, literał `[ 'Numer', '123-456-789' ]`
- C) Deklaracja `TUPLE{TEXT, TEXT}`, literał `{ 'Numer', '123-456-789' }`
- D) Deklaracja `ROW<TEXT, TEXT>`, literał `( 'Numer': '123-456-789' )`

<details><summary>Odpowiedź</summary>

**A** — TUPLE z typami w nawiasach ostrych, literał w nawiasach okrągłych. (Na slajdzie tytuł ma literówkę „Kropki”.) (slajd 327)

</details>

**8.34. Które polecenie tworzy typ definiowany przez użytkownika?**

- A) `CREATE UDT szczegoly ( dlugosc SMALLINT, adnotacja TEXT )`
- B) `CREATE TYPE szczegoly ( dlugosc SMALLINT, adnotacja TEXT )`
- C) `CREATE TYPE szczegoly { dlugosc: SMALLINT, adnotacja: TEXT }`
- D) `CREATE TABLE TYPE szczegoly ( dlugosc SMALLINT, adnotacja TEXT )`

<details><summary>Odpowiedź</summary>

**B** — CREATE TYPE nazwa i w nawiasie okrągłym pola z typami. (slajd 331)

</details>

### SELECT: selekcja danych

**8.35. Która kolejność klauzul SELECT jest zgodna z diagramem składni CQL?**

- A) SELECT, FROM, WHERE, ORDER BY, GROUP BY, ALLOW FILTERING, LIMIT
- B) SELECT, FROM, WHERE, GROUP BY, ORDER BY, LIMIT, ALLOW FILTERING
- C) SELECT, FROM, ALLOW FILTERING, WHERE, GROUP BY, ORDER BY, LIMIT
- D) SELECT, WHERE, FROM, GROUP BY, LIMIT, ORDER BY

<details><summary>Odpowiedź</summary>

**B** — Diagram: SELECT → FROM → [WHERE] → [GROUP BY] → [ORDER BY] → [LIMIT] → [ALLOW FILTERING]. (slajd 332)

</details>

**8.36. Które kolumny mogą być zasadniczo użyte w klauzuli WHERE?**

- A) Dowolne kolumny tabeli
- B) Tylko kolumny typu TEXT
- C) Tylko kolekcje
- D) Tylko kolumny klucza głównego, chyba że istnieją pomocnicze struktury indeksujące

<details><summary>Odpowiedź</summary>

**D** — Tylko kolumny klucza głównego, chyba że istnieją indeksy pomocnicze; niektóre relacje są dodatkowo problematyczne. (slajd 335)

</details>

**8.37. Do czego służy relacja `CONTAINS KEY`?**

- A) Sprawdza, czy mapa zawiera dany klucz; działa tylko dla map
- B) Sprawdza, czy lista zawiera dany element
- C) Sprawdza, czy wiersz ma dany klucz główny
- D) Sprawdza, czy zbiór zawiera daną wartość

<details><summary>Odpowiedź</summary>

**A** — CONTAINS KEY działa tylko dla map i sprawdza klucze. CONTAINS działa dla list, zbiorów i map (dla map sprawdza wartości). (slajd 337)

</details>

**8.38. Które zdanie o WRITETIME i TTL jest prawdziwe według wykładu?**

- A) Można ich używać w klauzuli WHERE
- B) Działają tylko na kolekcjach
- C) Działają tylko na kolumnach klucza głównego
- D) Nie mogą być użyte na kolekcji i jej elementach ani w innych klauzulach (np. WHERE)

<details><summary>Odpowiedź</summary>

**D** — Slajd podaje oba ograniczenia: nie na kolekcjach i nie w innych klauzulach. (slajd 339)

</details>

**8.39. Według jakich kolumn można porządkować wynik klauzulą ORDER BY?**

- A) Tylko według kolumn grupujących (clustering columns)
- B) Według dowolnej kolumny
- C) Tylko według klucza partycji
- D) Tylko według kolumn z indeksem pomocniczym

<details><summary>Odpowiedź</summary>

**A** — Tylko uporządkowania wyznaczane przez kolumny grupujące są dozwolone. (slajd 340)

</details>

**8.40. Tabela ma `PRIMARY KEY (sensor_id, timestamp)`. Które zapytanie jest poprawne?**

- A) `SELECT * FROM sensor_data WHERE sensor_id = 'sensor01' ORDER BY value DESC`
- B) `SELECT * FROM sensor_data ORDER BY sensor_id`
- C) `SELECT * FROM sensor_data WHERE sensor_id = 'sensor01' ORDER BY timestamp DESC LIMIT 10`
- D) `SELECT * FROM sensor_data WHERE sensor_id = 'sensor01' LIMIT 10 ORDER BY timestamp`

<details><summary>Odpowiedź</summary>

**C** — ORDER BY po kolumnie grupującej `timestamp`, w obrębie partycji, a LIMIT po ORDER BY. A sortuje po kolumnie spoza klucza, B po kluczu partycji, D ma złą kolejność klauzul. (slajd 340)

</details>

**8.41. Czym różni się `COUNT(kolumna)` od `COUNT(*)`?**

- A) `COUNT(kolumna)` liczy wartości w kolumnie, ignorując null; `COUNT(*)` liczy wiersze
- B) `COUNT(kolumna)` liczy wiersze, `COUNT(*)` tylko wartości różne od null
- C) Oba zawsze dają ten sam wynik
- D) `COUNT(kolumna)` liczy unikalne wartości

<details><summary>Odpowiedź</summary>

**A** — COUNT(kolumna) zlicza wartości z pominięciem null, COUNT(*) liczbę wierszy w grupie. (slajd 339, 342)

</details>

**8.42. Jakie zapytania są domyślnie dozwolone bez modyfikatora ALLOW FILTERING?**

- A) Wszystkie zapytania z klauzulą WHERE
- B) Tylko zapytania z GROUP BY
- C) Tylko zapytania bez klauzuli WHERE
- D) Tylko zapytania niefiltrujące, w których liczba wierszy przeczytanych ≈ liczba wierszy zwróconych

<details><summary>Odpowiedź</summary>

**D** — Takie zapytania mają przewidywalną złożoność. Slajd mówi, że ich czas jest proporcjonalny „do rozmiaru danych” — chodzi o rozmiar danych zwracanych. (slajd 343)

</details>

### INSERT, UPDATE, DELETE i upsert

**8.43. Co się stanie, gdy INSERT wstawi wiersz o kluczu głównym, który już istnieje w tabeli?**

- A) Cassandra zgłosi błąd naruszenia klucza głównego
- B) Powstanie drugi wiersz z tym samym kluczem
- C) INSERT zostanie zignorowany
- D) Istniejący wiersz zostanie zaktualizowany (upsert)

<details><summary>Odpowiedź</summary>

**D** — Gdy wiersz o podanym kluczu już istnieje, jest aktualizowany. Wyjątkiem jest INSERT z IF NOT EXISTS. (slajd 344)

</details>

**8.44. Które polecenie INSERT ma poprawną składnię i literały?**

- A) `INSERT INTO filmy VALUES ('zielonamila', 'Zielona Mila', 1999)`
- B) `INSERT INTO filmy (id, rezyser, gatunki) VALUES ('zielonamila', {'frank', 'Darabont'}, ('komedia', 'dramat'))`
- C) `INSERT INTO filmy (id, rezyser, aktorzy, gatunki) VALUES ('zielonamila', ('frank', 'Darabont'), {'hanks': 'Tom'}, ['komedia', 'dramat'])`
- D) `INSERT filmy SET id = 'zielonamila', rok = 1999`

<details><summary>Odpowiedź</summary>

**C** — Krotka w nawiasach okrągłych, mapa w klamrach z dwukropkiem, lista w kwadratowych. A nie ma listy kolumn, B myli literały krotki i listy, D to nie jest składnia INSERT. (slajd 345)

</details>

**8.45. Gdzie w poleceniu UPDATE umieszcza się klauzulę `USING` (np. `USING TTL 300`)?**

- A) Po klauzuli WHERE
- B) Między SET a WHERE
- C) Po nazwie tabeli, przed SET
- D) Przed słowem UPDATE

<details><summary>Odpowiedź</summary>

**C** — Diagram: UPDATE → tabela → [USING …] → SET → … → WHERE. W INSERT USING stoi na końcu, po VALUES. (slajd 346, 344)

</details>

**8.46. Które przypisanie w UPDATE zmienia pole `dlugosc` w kolumnie typu UDT `wlasciwosci`?**

- A) `wlasciwosci['dlugosc'] = 99`
- B) `wlasciwosci.dlugosc = 99`
- C) `wlasciwosci = wlasciwosci + { dlugosc: 99 }`
- D) `wlasciwosci(dlugosc) = 99`

<details><summary>Odpowiedź</summary>

**B** — Pole UDT zmienia się przez kropkę; nawias kwadratowy służy do elementów mapy i listy. (slajd 347, 348)

</details>

**8.47. Co robi przypisanie `gatunki = [ 'dramat' ] + gatunki`?**

- A) Dopisuje `'dramat'` na początku listy
- B) Dopisuje `'dramat'` na końcu listy
- C) Zastępuje listę jednym elementem `'dramat'`
- D) Usuwa `'dramat'` z listy

<details><summary>Odpowiedź</summary>

**A** — Nowa lista przed kolumną to dopisanie na początku (prepend); `gatunki + [ ... ]` dopisuje na końcu. (slajd 349)

</details>

**8.48. Jak usunąć z mapy `aktorzy` wpisy o kluczach `'vicander'` i `'west'` przez UPDATE?**

- A) `aktorzy = aktorzy - { 'vicander': null, 'west': null }`
- B) `aktorzy = { 'vicander', 'west' } - aktorzy`
- C) `aktorzy = aktorzy - [ 'vicander', 'west' ]`
- D) `aktorzy = aktorzy - { 'vicander', 'west' }`

<details><summary>Odpowiedź</summary>

**D** — Od mapy odejmuje się zbiór kluczy w klamrach, zawsze w kolejności kolumna minus wartości. (slajd 349)

</details>

**8.49. Które zdanie o DELETE w CQL jest prawdziwe?**

- A) DELETE zawsze usuwa całe wiersze, jak w SQL
- B) DELETE może usunąć cały wiersz, wybrane kolumny albo elementy kolekcji i pola UDT
- C) DELETE działa tylko na kolekcjach
- D) DELETE nie przyjmuje klauzuli WHERE

<details><summary>Odpowiedź</summary>

**B** — DELETE usuwa pasujące wiersze, albo zachowuje wiersze i usuwa wybrane kolumny, albo zachowuje kolumny i usuwa elementy kolekcji lub pola UDT. (slajd 351)

</details>

## 9. Laboratoria 1–3 (MongoDB w praktyce)

### Lab 1 — Docker, instalacja lokalna, mongosh, Compass, VS Code

**9.1. Które polecenie uruchomi w tle kontener o nazwie `mongodb` z MongoDB dostępnym na hoście na standardowym porcie?**

- A) `docker start --name mongodb -p 27017 mongodb/mongodb-community-server`
- B) `docker exec --name mongodb -d -p 27017:27017 mongodb/mongodb-community-server:latest`
- C) `docker run --name mongodb -d -p 27017:27017 mongodb/mongodb-community-server:latest`
- D) `docker pull --name mongodb -d -p 27017:27017 mongodb/mongodb-community-server:latest`

<details><summary>Odpowiedź</summary>

**C** — nowy kontener z obrazu tworzy i uruchamia `docker run`. `-d` uruchamia go w tle, a `-p` mapuje port. (Lab 1, zad. 2)

</details>

**9.2. Drugi kontener uruchomiono poleceniem `docker run --name mongodb1 -d -p 27018:27017 mongodb/mongodb-community-server:latest`. Co oznacza `-p 27018:27017`?**

- A) Serwer w kontenerze nasłuchuje na 27018, a na hoście jest dostępny na 27017
- B) Kontener używa naraz portów 27017 i 27018
- C) Port 27018 jest zarezerwowany dla repliki, a 27017 dla klientów
- D) Port 27018 hosta jest przekierowany na port 27017 wewnątrz kontenera

<details><summary>Odpowiedź</summary>

**D** — składnia to `-p <port_hosta>:<port_kontenera>`. mongod w kontenerze dalej słucha na 27017, a z hosta łączymy się na 27018. (Lab 1, zad. 11)

</details>

**9.3. Jaki jest domyślny port serwera MongoDB (mongod)?**

- A) 27018
- B) 5432
- C) 27017
- D) 3306

<details><summary>Odpowiedź</summary>

**C** — MongoDB domyślnie nasłuchuje na 27017. 5432 to PostgreSQL, 3306 to MySQL, a 27018 wybraliśmy sami dla drugiego kontenera. (Lab 1, zad. 2 i 11)

</details>

**9.4. Co robi polecenie `docker exec -it mongodb mongosh`?**

- A) Tworzy nowy kontener `mongodb` i uruchamia w nim mongosh
- B) Uruchamia interaktywną powłokę mongosh wewnątrz działającego kontenera `mongodb`
- C) Instaluje mongosh na hoście z obrazu `mongodb`
- D) Eksportuje bazę z kontenera do pliku `mongosh`

<details><summary>Odpowiedź</summary>

**B** — `docker exec` uruchamia polecenie w już działającym kontenerze, a `-it` daje interaktywny terminal. (Lab 1, zad. 3)

</details>

**9.5. Co wyświetla polecenie `show dbs` w mongosh?**

- A) Listę kolekcji w bieżącej bazie
- B) Nazwę bieżącej bazy
- C) Listę baz danych na serwerze wraz z zajmowanym miejscem
- D) Listę użytkowników bazy

<details><summary>Odpowiedź</summary>

**C** — `show dbs` (lub `show databases`) wypisuje bazy z rozmiarem. Kolekcje pokazuje `show collections`. (Lab 1, zad. 3)

</details>

**9.6. Wykonujesz kolejno `use test1`, a potem `show dbs`. Baza `test1` wcześniej nie istniała. Co zobaczysz?**

- A) `test1` na liście z rozmiarem 0 B
- B) `test1` nie ma jeszcze na liście, bo baza powstaje dopiero po zapisaniu w niej danych (kolekcji lub dokumentu)
- C) Błąd: baza `test1` nie istnieje
- D) Pytanie, czy utworzyć bazę `test1`

<details><summary>Odpowiedź</summary>

**B** — `use` tylko przełącza kontekst. Baza pojawia się w `show dbs`, gdy trafi do niej pierwsza kolekcja albo dokument. (Lab 1, zad. 3; Lab 2, zad. 25)

</details>

**9.7. Czym różni się `docker stop mongodb` od `docker rm mongodb`?**

- A) Niczym, to synonimy
- B) `stop` usuwa obraz, `rm` usuwa kontener
- C) `stop` działa tylko w Docker Desktop, `rm` tylko w terminalu
- D) `stop` zatrzymuje kontener, który można potem uruchomić ponownie z danymi; `rm` usuwa kontener, a z nim dane zapisane wewnątrz (bez wolumenu)

<details><summary>Odpowiedź</summary>

**D** — po `stop` kontener istnieje i `docker start` go wznawia. Po `rm` kontenera nie ma, a dane spoza wolumenu przepadają. (Lab 1, zad. 4 i 10)

</details>

**9.8. Jaka jest rola `mongod.exe`, a jaka `mongosh.exe`?**

- A) `mongod` to powłoka, `mongosh` to serwer
- B) Oba to serwery; `mongosh` działa w trybie bezpiecznym
- C) `mongod` to narzędzie do importu, `mongosh` do eksportu
- D) `mongod` to proces serwera bazy, `mongosh` to powłoka (klient), która łączy się z serwerem

<details><summary>Odpowiedź</summary>

**D** — najpierw uruchamiamy serwer `mongod`, potem klienta `mongosh`. (Lab 1, zad. 7)

</details>

**9.9. Którą bazę wybiera w Playground polecenie `use('mongodbVSCodePlaygroundDB');`?**

- A) Tworzy kolekcję `mongodbVSCodePlaygroundDB` w bazie `test`
- B) Nic nie robi; w Playground działa tylko `use mongodbVSCodePlaygroundDB` bez nawiasów
- C) Usuwa bazę o tej nazwie i tworzy ją od nowa
- D) Ustawia bazę `mongodbVSCodePlaygroundDB` jako bieżącą dla kolejnych poleceń w pliku

<details><summary>Odpowiedź</summary>

**D** — w Playground (pliku JS) używamy funkcji `use('nazwa')`. Składnię `use nazwa` bez nawiasów zna tylko interaktywny mongosh. (Lab 1, zad. 13)

</details>

### Lab 2 — CRUD, zapytania, indeksy i kolekcje capped

#### Tworzenie bazy, kolekcji i wstawianie dokumentów

**9.10. Które polecenia w Playground tworzą bazę `northwind` i w niej pustą kolekcję `customers`?**

- A) `db.createDatabase('northwind'); db.createCollection('customers');`
- B) `use('northwind'); db.createCollection('customers');`
- C) `use('northwind'); db.customers.create();`
- D) `create database northwind; create collection customers;`

<details><summary>Odpowiedź</summary>

**B** — w MongoDB nie ma `createDatabase`. Bazę wybiera `use`, a fizycznie powstaje ona razem z pierwszą kolekcją. (Lab 2, zad. 1–2)

</details>

**9.11. Dokument Customer07 (`{ firstName: "Patryk", lastName: "Bez", created_date: "2021-07-07" }`) nie ma pola `_id`. Co się stanie przy `insertOne`?**

- A) Wstawienie się nie uda, bo `_id` jest wymagane
- B) Dokument dostanie `_id: 7`, bo jest siódmy
- C) Dokument zostanie wstawiony bez `_id`
- D) MongoDB (sterownik lub shell) nada mu automatycznie `_id` typu ObjectId

<details><summary>Odpowiedź</summary>

**D** — każdy dokument musi mieć `_id`, a gdy go brakuje, dostaje unikalny ObjectId. (Lab 2, zad. 3)

</details>

**9.12. Ponownie wstawiasz dokument z `_id: "o1"`, który już jest w `orders`. Co się stanie?**

- A) Stary dokument zostanie nadpisany
- B) Powstanie drugi dokument z tym samym `_id`
- C) Błąd duplikatu klucza (E11000) na indeksie `_id_`
- D) MongoDB zmieni `_id` na `"o1_1"`

<details><summary>Odpowiedź</summary>

**C** — `_id` jest unikalne dzięki indeksowi `_id_`. Nadpisanie zrobiłby `replaceOne`, a nie insert. (Lab 2, zad. 3 i 25.7)

</details>

**9.13. Czym różni się `db.lab_test.drop()` od `db.lab_test.deleteMany({})`?**

- A) Niczym
- B) `drop()` usuwa całą kolekcję razem z indeksami; `deleteMany({})` usuwa dokumenty, a kolekcja i jej indeksy zostają
- C) `drop()` usuwa tylko indeksy
- D) `deleteMany({})` usuwa też bazę

<details><summary>Odpowiedź</summary>

**B** — zad. 4 każe usunąć kolekcję, więc właściwe jest `drop()`. (Lab 2, zad. 4)

</details>

#### find(), projekcja, sortowanie

**9.14. Czym różni się `db.customers.find()` od `db.customers.findOne()`?**

- A) `find()` zwraca kursor po pasujących dokumentach, `findOne()` zwraca jeden dokument albo `null`
- B) `find()` zwraca pierwszy dokument, `findOne()` wszystkie
- C) `findOne()` wymaga filtra po `_id`
- D) Niczym, `findOne()` to alias

<details><summary>Odpowiedź</summary>

**A** — `findOne()` zwraca sam dokument, nie kursor, więc nie da się na nim wywołać `.sort()` ani `.limit()`. (Lab 2, zad. 5–6)

</details>

**9.15. Które polecenie wyświetli z `orders` tylko klucze `_id`, `cost` i `totalCost`?**

- A) `db.orders.find({ _id: 1, cost: 1, totalCost: 1 })`
- B) `db.orders.find({}, ["_id", "cost", "totalCost"])`
- C) `db.orders.find({}, { cost: 1, totalCost: 1 })`
- D) `db.orders.find().project("cost", "totalCost")`

<details><summary>Odpowiedź</summary>

**C** — projekcja to drugi argument `find`, a `_id` jest dołączane domyślnie. Wersja A to filtr, który niczego nie znajdzie. (Lab 2, zad. 8)

</details>

**9.16. Co się stanie po `db.customers.find({}, { firstName: 1, purchase: 0 })`?**

- A) Wyświetli `firstName` bez `purchase`
- B) Wyświetli wszystkie pola
- C) Błąd: projekcja nie może mieszać włączania i wyłączania pól (poza `_id`)
- D) Wyświetli tylko `_id`

<details><summary>Odpowiedź</summary>

**C** — w projekcji albo wybierasz pola (1), albo je wykluczasz (0). Wyjątkiem jest `_id`. (Lab 2, zad. 8–9)

</details>

**9.17. Które polecenie posortuje `orders` malejąco po `customer`, a przy równym `customer` rosnąco po `totalCost`?**

- A) `db.orders.find().sort({ customer: -1, totalCost: 1 })`
- B) `db.orders.find().sort({ customer: 1, totalCost: -1 })`
- C) `db.orders.find().sort("customer", -1).sort("totalCost", 1)`
- D) `db.orders.find().sort({ totalCost: 1, customer: -1 })`

<details><summary>Odpowiedź</summary>

**A** — 1 oznacza rosnąco, -1 malejąco, a kolejność kluczy w obiekcie to priorytet sortowania. Wersja D sortuje najpierw po `totalCost`. (Lab 2, zad. 10)

</details>

#### Operatory zapytań

**9.18. Które zapytanie zwróci zamówienia z `totalCost` między 5000 a 10000 (włącznie)?**

- A) `db.orders.find({ totalCost: { $between: [5000, 10000] } })`
- B) `db.orders.find({ totalCost: { $gte: 5000 } }, { totalCost: { $lte: 10000 } })`
- C) `db.orders.find({ $in: { totalCost: [5000, 10000] } })`
- D) `db.orders.find({ totalCost: { $gte: 5000, $lte: 10000 } })`

<details><summary>Odpowiedź</summary>

**D** — dwa operatory w jednym obiekcie pola dają przedział. W MongoDB nie ma `$between`, a w B drugi obiekt jest projekcją, nie warunkiem. (Lab 2, zad. 12)

</details>

**9.19. Które zapytanie zwróci klientów, których `lastName` zaczyna się na literę K?**

- A) `db.customers.find({ lastName: /^K/ })`
- B) `db.customers.find({ lastName: /K$/ })`
- C) `db.customers.find({ lastName: "K*" })`
- D) `db.customers.find({ lastName: { $like: "K%" } })`

<details><summary>Odpowiedź</summary>

**A** — `^` to początek napisu, a `$` koniec. W MongoDB nie ma `$like`. Równoważny zapis to `{ lastName: { $regex: /^K/ } }`. (Lab 2, zad. 13)

</details>

**9.20. Które zapytanie zwróci działy z miast: Poznań, Warszawa albo Łódź?**

- A) `db.departments.find({ city: ["Poznań", "Warszawa", "Łódź"] })`
- B) `db.departments.find({ city: { $or: ["Poznań", "Warszawa", "Łódź"] } })`
- C) `db.departments.find({ city: { $in: ["Poznań", "Warszawa", "Łódź"] } })`
- D) `db.departments.find({ $in: { city: ["Poznań", "Warszawa", "Łódź"] } })`

<details><summary>Odpowiedź</summary>

**C** — `$in` sprawdza, czy wartość pola jest w liście. Wersja A szuka pola równego dokładnie całej tablicy. (Lab 2, zad. 14)

</details>

**9.21. Które zapytanie realizuje zad. 16: `discount < 10` LUB `cost > 5000`, sortowanie malejąco po `cost`?**

- A) `db.orders.find({ discount: { $lt: 10 }, cost: { $gt: 5000 } }).sort({ cost: -1 })`
- B) `db.orders.find({ $or: { discount: { $lt: 10 }, cost: { $gt: 5000 } } }).sort({ cost: -1 })`
- C) `db.orders.find({ $or: [{ discount: { $lt: 10 } }, { cost: { $gt: 5000 } }] }).sort({ cost: 1 })`
- D) `db.orders.find({ $or: [{ discount: { $lt: 10 } }, { cost: { $gt: 5000 } }] }).sort({ cost: -1 })`

<details><summary>Odpowiedź</summary>

**D** — `$or` przyjmuje tablicę warunków. A to AND, B ma obiekt zamiast tablicy, a C sortuje rosnąco. (Lab 2, zad. 16)

</details>

**9.22. Które zapytanie zwróci zamówienia bez pola `totalCost`?**

- A) `db.orders.find({ totalCost: null, $exists: true })`
- B) `db.orders.find({ totalCost: 0 })`
- C) `db.orders.find({ $missing: "totalCost" })`
- D) `db.orders.find({ totalCost: { $exists: false } })`

<details><summary>Odpowiedź</summary>

**D** — `$exists: false` dopasowuje dokumenty bez pola. W danych są to o6 i o18. (Lab 2, operatory zapytań)

</details>

**9.23. Które zapytanie zwróci działy przy ulicy „Pierwsza” (pole zagnieżdżone `address.street`)?**

- A) `db.departments.find({ address.street: "Pierwsza" })`
- B) `db.departments.find({ address: { street: "Pierwsza" } })`
- C) `db.departments.find({ "address.street": "Pierwsza" })`
- D) `db.departments.find({ address: "Pierwsza" })`

<details><summary>Odpowiedź</summary>

**C** — notacja kropkowa wymaga cudzysłowu wokół klucza. A to błąd składni JS, a B szuka poddokumentu równego dokładnie `{ street: "Pierwsza" }`. Wynik to beta i gamma. (Lab 2, struktura departments; Lab 3, zad. 18)

</details>

#### Aktualizacja i usuwanie (northwind)

**9.24. Co zwróci mongosh dla `db.customers.updateOne({ _id: 1 }, { isValid: true })`?**

- A) Zastąpi dokument dokumentem `{ _id: 1, isValid: true }`
- B) Doda pole `isValid` i zostawi resztę
- C) Nic nie zmieni i zwróci `modifiedCount: 0`
- D) Błąd: dokument aktualizacji musi zawierać operatory (np. `$set`)

<details><summary>Odpowiedź</summary>

**D** — `updateOne`/`updateMany` przyjmują operatory aktualizacji albo pipeline. Całą zawartość dokumentu zastępuje `replaceOne`. (Lab 2, zad. 18 i 25.2)

</details>

**9.25. Które polecenie realizuje zad. 19 (status „A” dla wszystkich działów w Warszawie, a jeśli ich nie ma, utwórz dokument)?**

- A) `db.departments.updateMany({ city: "Warszawa" }, { $set: { status: "A" } }, { upsert: true })`
- B) `db.departments.updateOne({ city: "Warszawa" }, { $set: { status: "A" } }, { upsert: true })`
- C) `db.departments.updateMany({ city: "Warszawa" }, { $set: { status: "A", upsert: true } })`
- D) `db.departments.updateMany({ city: "Warszawa", upsert: true }, { status: "A" })`

<details><summary>Odpowiedź</summary>

**A** — `upsert` podaje się w trzecim argumencie (opcjach). B zmieni tylko jeden dokument, a C doda pole o nazwie `upsert`. (Lab 2, zad. 19)

</details>

#### Indeksy

**9.26. Które polecenie tworzy indeks o nazwie `klienci` na `firstName` i `lastName` (rosnąco)?**

- A) `db.customers.createIndex({ name: "klienci", firstName: 1, lastName: 1 })`
- B) `db.customers.createIndex("klienci", { firstName: 1, lastName: 1 })`
- C) `db.customers.createIndex({ firstName: 1 }, { lastName: 1 }, { name: "klienci" })`
- D) `db.customers.createIndex({ firstName: 1, lastName: 1 }, { name: "klienci" })`

<details><summary>Odpowiedź</summary>

**D** — pierwszy argument to klucze indeksu, drugi to opcje, w tym `name`. W A `name` byłoby polem indeksu. (Lab 2, zad. 22)

</details>

**9.27. Indeks złożony `klienci` to `{ firstName: 1, lastName: 1 }`. Które zapytanie może go użyć jako prefiksu?**

- A) `db.customers.find({ lastName: "Nowak" })`
- B) `db.customers.find({ phone: "111 760 760" })`
- C) `db.customers.find({ email: /pl$/ })`
- D) `db.customers.find({ firstName: "Jan" })`

<details><summary>Odpowiedź</summary>

**D** — indeks złożony obsługuje zapytania po swoim prefiksie (`firstName` albo `firstName` + `lastName`). Samo `lastName` nie jest prefiksem. (Lab 2, zad. 22)

</details>

#### sort(), skip(), limit() (zad. 24)

**9.28. Czy kolejność wywołań `sort()`, `skip()` i `limit()` na kursorze `find()` zmienia wynik?**

- A) Tak, metody wykonują się w kolejności zapisu
- B) Nie, serwer zawsze stosuje najpierw sort, potem skip, a na końcu limit
- C) Tak, ale tylko dla `limit()`
- D) Nie, ale tylko gdy kolekcja ma indeks

<details><summary>Odpowiedź</summary>

**B** — `find().limit(3).skip(2).sort({ cost: -1 })` daje ten sam wynik co `find().sort({ cost: -1 }).skip(2).limit(3)`. (Lab 2, zad. 24)

</details>

#### Baza Politechnika i kolekcja capped

**9.29. Które polecenie tworzy kolekcję `Students` ograniczoną do 1 MB lub 100 dokumentów?**

- A) `db.createCollection('Students', { capped: true, size: 1048576, max: 100 })`
- B) `db.createCollection('Students', { capped: true, max: 100 })`
- C) `db.createCollection('Students', { size: "1MB", maxDocs: 100 })`
- D) `db.Students.capped({ size: 1048576, max: 100 })`

<details><summary>Odpowiedź</summary>

**A** — `capped: true` wymaga `size` w bajtach, a `max` jest opcjonalne. B nie ma wymaganego `size`. (Lab 2, zad. 25.1)

</details>

**9.30. Co się dzieje po wstawieniu 101. dokumentu do kolekcji capped z `max: 100`?**

- A) Insert kończy się błędem „collection full”
- B) Kolekcja automatycznie się powiększa
- C) Nowy dokument jest odrzucany bez błędu
- D) MongoDB usuwa najstarszy dokument i zapisuje nowy, bez błędu

<details><summary>Odpowiedź</summary>

**D** — kolekcja capped działa jak bufor cykliczny: najstarsze dokumenty ustępują nowym. Tak samo po osiągnięciu limitu `size`. (Lab 2, zad. 25.1)

</details>

#### updateMany, updateOne, replaceOne, $set, $unset, $rename, upsert

**9.31. Czym `replaceOne` różni się od `updateOne`?**

- A) `replaceOne` zastępuje całą treść dokumentu nowym dokumentem (bez operatorów), zachowując `_id`; pola, których nie podano, znikają
- B) `replaceOne` zmienia wiele dokumentów
- C) `replaceOne` wymaga operatora `$set`
- D) `replaceOne` zmienia też `_id` na nowe ObjectId

<details><summary>Odpowiedź</summary>

**A** — dlatego w zad. 25.2 przy `replaceOne` trzeba podać wszystkie pola Zielińskiego. Inaczej by zniknęły. (Lab 2, zad. 25.2)

</details>

**9.32. Które polecenie usunie pole `updatedAt` ze wszystkich dokumentów?**

- A) `db.Students.updateMany({}, { $set: { updatedAt: null } })`
- B) `db.Students.deleteMany({ updatedAt: { $exists: true } })`
- C) `db.Students.updateMany({}, { $delete: "updatedAt" })`
- D) `db.Students.updateMany({}, { $unset: { updatedAt: "" } })`

<details><summary>Odpowiedź</summary>

**D** — `$unset` usuwa pole. A zostawia pole z wartością `null`, a B kasuje całe dokumenty. (Lab 2, zad. 25.3)

</details>

**9.33. Które polecenie zmieni nazwę pola `birthYear` na `yearOfBirth` we wszystkich dokumentach?**

- A) `db.Students.updateMany({}, { $rename: { yearOfBirth: "birthYear" } })`
- B) `db.Students.updateMany({}, { $rename: { birthYear: "yearOfBirth" } })`
- C) `db.Students.renameField("birthYear", "yearOfBirth")`
- D) `db.Students.updateMany({}, { $set: { birthYear: "yearOfBirth" } })`

<details><summary>Odpowiedź</summary>

**B** — składnia to `{ $rename: { <stara_nazwa>: "<nowa_nazwa>" } }`. A działa w odwrotną stronę, a D wpisuje napis jako wartość. (Lab 2, zad. 25.4)

</details>

#### bulkWrite

**9.34. Której operacji NIE obsługuje `db.collection.bulkWrite()`?**

- A) `replaceOne`
- B) `deleteMany`
- C) `updateMany`
- D) `find`

<details><summary>Odpowiedź</summary>

**D** — `bulkWrite` obsługuje tylko zapisy: `insertOne`, `updateOne`, `updateMany`, `replaceOne`, `deleteOne` i `deleteMany`. (Lab 2, zad. 25.8; wykład)

</details>

### Lab 3 — Database Tools, kopie zapasowe, explain i agregacja

#### mongoimport, mongoexport, mongodump, mongorestore, docker cp

**9.35. Które polecenie zaimportuje plik `listingsAndReviews.json` do bazy `airbnb` i kolekcji `listingsAndReviews`?**

- A) `mongoimport airbnb.listingsAndReviews < listingsAndReviews.json`
- B) `mongorestore --db airbnb --collection listingsAndReviews .\sample_airbnb\listingsAndReviews.json`
- C) `mongosh --import .\sample_airbnb\listingsAndReviews.json --db airbnb`
- D) `mongoimport --db airbnb --collection listingsAndReviews --file .\sample_airbnb\listingsAndReviews.json`

<details><summary>Odpowiedź</summary>

**D** — `--db` wskazuje bazę, `--collection` kolekcję, a `--file` plik JSON. `mongorestore` wczytuje zrzuty BSON, a nie pliki JSON. (Lab 3, zad. 2)

</details>

**9.36. Kiedy przy `mongoimport` trzeba dodać opcję `--jsonArray`?**

- A) Gdy import idzie do kontenera
- B) Gdy dokumenty mają pola tablicowe, np. `amenities`
- C) Zawsze przy plikach `.json`
- D) Gdy plik zawiera jedną tablicę JSON z dokumentami (`[ {...}, {...} ]`)

<details><summary>Odpowiedź</summary>

**D** — domyślnie mongoimport czyta kolejne dokumenty JSON jeden po drugim. Plik z jedną tablicą wymaga `--jsonArray`. (Lab 3, zad. 2–4)

</details>

**9.37. Które polecenie skopiuje katalog `.\sample_analytics` z hosta do `/data/sample_analytics` w kontenerze `mongodb`?**

- A) `docker cp mongodb:/data/sample_analytics .\sample_analytics`
- B) `docker exec mongodb cp .\sample_analytics /data`
- C) `docker copy .\sample_analytics /data --container mongodb`
- D) `docker cp .\sample_analytics mongodb:/data/sample_analytics`

<details><summary>Odpowiedź</summary>

**D** — składnia to `docker cp <źródło> <cel>`, a ścieżkę w kontenerze poprzedza `nazwa_kontenera:`. A kopiuje w przeciwną stronę. (Lab 3, zad. 4 i 7)

</details>

#### Zliczanie dokumentów

**9.38. Czym różni się `countDocuments()` od `estimatedDocumentCount()`?**

- A) `countDocuments()` przyjmuje filtr i liczy dokładnie (przez agregację); `estimatedDocumentCount()` nie przyjmuje filtra i bierze liczbę z metadanych kolekcji, więc jest szybsza
- B) `estimatedDocumentCount()` przyjmuje filtr, a `countDocuments()` nie
- C) Obie czytają metadane; różnią się tylko nazwą
- D) `countDocuments()` jest przestarzała

<details><summary>Odpowiedź</summary>

**A** — wykład: `countDocuments()` daje dokładny wynik, który może wymagać odczytu wszystkich dokumentów, a `estimatedDocumentCount()` korzysta z metadanych i jest zwykle szybsza. (Lab 3, zad. 5; wykład)

</details>

#### Kopie zapasowe

**9.39. W jakim formacie `mongodump` zapisuje dane?**

- A) CSV, plik na kolekcję
- B) Jeden plik SQL
- C) Binarny BSON (plik `.bson` na kolekcję) plus plik `.metadata.json` z opcjami i definicjami indeksów
- D) JSON czytelny dla człowieka

<details><summary>Odpowiedź</summary>

**C** — BSON zachowuje typy danych (np. Decimal128 i daty), a metadane pozwalają `mongorestore` odtworzyć indeksy. (Lab 3, zad. 6)

</details>

**9.40. Czym różni się `mongodump` od `mongoexport`?**

- A) Niczym, to dwie nazwy tego samego programu
- B) `mongodump` robi binarną kopię BSON (z typami i indeksami) do backupu; `mongoexport` zapisuje dane jako JSON lub CSV do wymiany danych i może tracić typy BSON
- C) `mongoexport` zapisuje BSON, a `mongodump` CSV
- D) `mongodump` działa tylko w Dockerze

<details><summary>Odpowiedź</summary>

**B** — do kopii zapasowych służą `mongodump`/`mongorestore`, a `mongoexport`/`mongoimport` do wymiany danych z innymi programami. (Lab 3, zad. 6 i 10)

</details>

#### mongoexport do CSV

**9.41. Czego wymaga `mongoexport --type=csv`?**

- A) Opcji `--jsonArray`
- B) Listy pól przez `--fields` (albo `--fieldFile`)
- C) Opcji `--headerline`
- D) Uprawnień administratora Windows

<details><summary>Odpowiedź</summary>

**B** — CSV ma stałe kolumny, więc trzeba podać, które pola eksportować. `--headerline` to opcja `mongoimport`. (Lab 3, zad. 10)

</details>

#### explain(), COLLSCAN i IXSCAN

**9.42. Co zwraca `db.listingsAndReviews.find().explain("executionStats")`?**

- A) Dokumenty wyniku z dodatkowym polem czasu
- B) Plan wykonania zapytania (zwycięski plan) wraz ze statystykami wykonania, np. `nReturned`, `totalDocsExamined` i `executionTimeMillis`
- C) Listę indeksów kolekcji
- D) Statystyki rozmiaru kolekcji

<details><summary>Odpowiedź</summary>

**B** — tryb `executionStats` wykonuje zapytanie i zwraca liczby z wykonania. Domyślny tryb `"queryPlanner"` pokazuje tylko wybrany plan. (Lab 3, zad. 8)

</details>

**9.43. Co oznacza etap `COLLSCAN` w planie wykonania?**

- A) Skanowanie indeksu
- B) Skanowanie kolekcji capped
- C) Kompresję kolekcji
- D) Pełne skanowanie kolekcji: serwer czyta wszystkie dokumenty

<details><summary>Odpowiedź</summary>

**D** — przy `COLLSCAN` `totalDocsExamined` równa się liczbie dokumentów w kolekcji (np. 5555). (Lab 3, zad. 8)

</details>

**9.44. Co oznacza etap `IXSCAN`?**

- A) Import danych z pliku
- B) Błąd indeksu
- C) Pełne skanowanie kolekcji
- D) Skanowanie indeksu: serwer przegląda klucze indeksu zamiast wszystkich dokumentów

<details><summary>Odpowiedź</summary>

**D** — po `IXSCAN` zwykle następuje `FETCH`, który pobiera wskazane dokumenty. (Lab 3, zad. 8)

</details>

**9.45. Które wyrażenie regularne najlepiej wykorzysta indeks na `name`?**

- A) `/Resort/`
- B) `/^resort/i`
- C) `/resort$/`
- D) `/^Resort/`

<details><summary>Odpowiedź</summary>

**D** — dokumentacja: najlepiej działa „prefix expression” zakotwiczone `^` i wrażliwe na wielkość liter. Wyrażenia bez rozróżniania wielkości liter (`i`) nie potrafią skutecznie użyć indeksu. (Lab 3, zad. 8 i 28)

</details>

**9.46. Kolekcja ma indeks `name_1`. Jaki plan dostanie `find().sort({ name: 1 })`?**

- A) Błąd, bo sortowanie wymaga filtra
- B) `COLLSCAN` + `SORT` w pamięci
- C) `IXSCAN` po `_id_`
- D) `IXSCAN` po `name_1` + `FETCH`, bez etapu `SORT`, bo indeks oddaje klucze już posortowane

<details><summary>Odpowiedź</summary>

**D** — indeks zastępuje sortowanie w pamięci. (Lab 3, zad. 9)

</details>

#### Agregacja na sample_airbnb

**9.47. Które polecenie zwróci unikalne wartości `property_type` (zad. 11)?**

- A) `db.listingsAndReviews.aggregate([{ $group: { _id: "$property_type" } }])`
- B) `db.listingsAndReviews.aggregate([{ $group: { property_type: "$_id" } }])`
- C) `db.listingsAndReviews.aggregate([{ $project: { _id: "$property_type" } }])`
- D) `db.listingsAndReviews.aggregate([{ $unique: "property_type" }])`

<details><summary>Odpowiedź</summary>

**A** — `$group` tworzy jeden dokument na każdą wartość `_id`, czyli wartości unikalne. C nie grupuje, więc powtarza wartości. (Lab 3, zad. 11)

</details>

**9.48. Znajdź błąd: `db.listingsAndReviews.aggregate([{ $group: { _id: "property_type" } }])`.**

- A) Brakuje `$sort`
- B) `$group` wymaga akumulatora
- C) Brak `$` przed nazwą pola: `"property_type"` to stały napis, więc wynik to jedna grupa `{ _id: "property_type" }`
- D) `_id` w `$group` musi być liczbą

<details><summary>Odpowiedź</summary>

**C** — do wartości pola w wyrażeniach agregacji odwołujemy się przez `"$pole"`. (Lab 3, zad. 11)

</details>

**9.49. Które polecenie zwróci 3 oferty z największą liczbą łóżek, z polami `name` i `beds` (zad. 14)?**

- A) `aggregate([{ $limit: 3 }, { $sort: { beds: -1 } }, { $project: { _id: 0, name: 1, beds: 1 } }])`
- B) `aggregate([{ $sort: { beds: 1 } }, { $limit: 3 }, { $project: { _id: 0, name: 1, beds: 1 } }])`
- C) `aggregate([{ $sort: { beds: -1 } }, { $limit: 3 }, { $project: { _id: 0, name: 1, beds: 1 } }])`
- D) `aggregate([{ $project: { name: 1 } }, { $sort: { beds: -1 } }, { $limit: 3 }])`

<details><summary>Odpowiedź</summary>

**C** — najpierw sortowanie malejące, potem `$limit`. A sortuje trzy przypadkowe dokumenty, B bierze najmniejsze wartości, a D usuwa `beds` przed sortowaniem. (Lab 3, zad. 14)

</details>

**9.50. Które polecenie zwróci 3 oferty typu „House” (zad. 15)?**

- A) `aggregate([{ $match: { property_type: "House" } }, { $limit: 3 }])`
- B) `aggregate([{ $filter: { property_type: "House" } }, { $limit: 3 }])`
- C) `aggregate([{ $where: { property_type: "House" } }, { $limit: 3 }])`
- D) `aggregate([{ $limit: 3 }, { $match: { property_type: "House" } }])`

<details><summary>Odpowiedź</summary>

**A** — `$match` filtruje dokumenty jak filtr `find`. D najpierw bierze 3 dowolne dokumenty i dopiero wśród nich szuka „House”. (Lab 3, zad. 15)

</details>

**9.51. Czym różni się etap `$addFields` od `$project`?**

- A) `$addFields` dodaje lub nadpisuje pola i zostawia wszystkie pozostałe; `$project` zostawia tylko pola wskazane w projekcji (oraz `_id`)
- B) `$addFields` usuwa wszystkie inne pola
- C) Nie ma różnicy
- D) `$project` nie umie tworzyć nowych pól

<details><summary>Odpowiedź</summary>

**A** — `{ $addFields: { country: "$address.country" } }` doda `country` do pełnego dokumentu. Alias `$addFields` to `$set`. (Lab 3, zad. 17)

</details>

**9.52. Które polecenie zwróci `[ { totalPortugal: 555 } ]` (zad. 18)?**

- A) `aggregate([{ $match: { "address.country": "Portugal" } }, { $count: "totalPortugal" }])`
- B) `aggregate([{ $count: "totalPortugal" }, { $match: { "address.country": "Portugal" } }])`
- C) `aggregate([{ $match: { country: "Portugal" } }, { $count: "totalPortugal" }])`
- D) `aggregate([{ $match: { "address.country": "Portugal" } }, { $sum: "totalPortugal" }])`

<details><summary>Odpowiedź</summary>

**A** — `$count: "<nazwa>"` zwraca dokument z tą nazwą pola i liczbą dokumentów. B liczy całą kolekcję, a potem filtruje wynik, C używa pola, którego nie ma na najwyższym poziomie, a `$sum` nie jest etapem. (Lab 3, zad. 18)

</details>

**9.53. Czym różni się `{ $sum: 1 }` od `{ $sum: "$beds" }` w `$group`?**

- A) `{ $sum: 1 }` liczy dokumenty w grupie, a `{ $sum: "$beds" }` sumuje wartości pola `beds`
- B) Niczym
- C) `{ $sum: 1 }` sumuje pierwsze pole dokumentu
- D) `{ $sum: "$beds" }` liczy dokumenty, które mają pole `beds`

<details><summary>Odpowiedź</summary>

**A** — to częste pytanie: liczba ofert (zad. 19) kontra suma miejsc (zad. 20) i łóżek (zad. 23). (Lab 3, zad. 19–23)

</details>

**9.54. Które polecenie zapisze wynik grupowania z zad. 20 do nowej kolekcji `country`, w której `_id` to nazwa kraju (zad. 21)?**

- A) `aggregate([{ $out: "country" }, { $group: { _id: "$address.country", totalPeople: { $sum: "$accommodates" } } }])`
- B) `aggregate([{ $group: { _id: "$address.country", totalPeople: { $sum: "$accommodates" } } }]).saveAs("country")`
- C) `aggregate([{ $group: { _id: "$address.country", totalPeople: { $sum: "$accommodates" } } }, { $out: "country" }])`
- D) `db.country.insertMany(aggregate([...]))`

<details><summary>Odpowiedź</summary>

**C** — `$out` musi być ostatnim etapem potoku. `_id` z `$group` staje się `_id` dokumentów w nowej kolekcji. (Lab 3, zad. 21)

</details>

**9.55. Czym `$merge` różni się od `$out`?**

- A) `$merge` może dopisywać, aktualizować lub zastępować pojedyncze dokumenty w istniejącej kolekcji, a `$out` zastępuje całą kolekcję
- B) `$merge` łączy dwie kolekcje jak `$lookup`
- C) `$merge` może stać w środku potoku
- D) `$merge` działa tylko na kolekcjach capped

<details><summary>Odpowiedź</summary>

**A** — oba etapy muszą być ostatnie w potoku. `$merge` dopasowuje dokumenty domyślnie po `_id`. (Lab 3, zad. 21)

</details>

**9.56. Które polecenie wstawi do zamówień dane klienta z kolekcji `customers` (zad. 22)?**

- A) `db.orders.aggregate([{ $limit: 3 }, { $lookup: { from: "customers", localField: "_id", foreignField: "customer", as: "customer1" } }])`
- B) `db.orders.aggregate([{ $limit: 3 }, { $lookup: { from: "customers", localField: "customer", foreignField: "_id", as: "customer1" } }])`
- C) `db.orders.aggregate([{ $limit: 3 }, { $join: { customers: "customer" } }])`
- D) `db.customers.aggregate([{ $lookup: { from: "orders", localField: "customer", foreignField: "_id" } }])`

<details><summary>Odpowiedź</summary>

**B** — `localField` to pole w `orders` (`customer`), `foreignField` to pole w `customers` (`_id`), a `as` to nazwa nowego pola. W A pola są zamienione miejscami. (Lab 3, zad. 22)

</details>

**9.57. Co robi etap `{ $unwind: "$amenities" }`?**

- A) Usuwa duplikaty z tablicy `amenities`
- B) Sortuje tablicę `amenities`
- C) Liczy elementy tablicy
- D) Rozbija dokument na tyle dokumentów, ile elementów ma tablica `amenities`; każdy ma w `amenities` jeden element

<details><summary>Odpowiedź</summary>

**D** — po `$unwind` można grupować po pojedynczych elementach tablicy. Domyślnie dokumenty z pustą tablicą albo bez tego pola odpadają. (Lab 3, zad. 26)

</details>

**9.58. Czym różni się `$addToSet` od `$push` w `$group`?**

- A) `$push` usuwa duplikaty, `$addToSet` nie
- B) `$addToSet` działa tylko na liczbach
- C) `$addToSet` dodaje wartość tylko wtedy, gdy jej jeszcze nie ma w tablicy wyniku; `$push` dodaje każdą wartość, także powtórzenia
- D) Nie ma różnicy

<details><summary>Odpowiedź</summary>

**C** — kolejność elementów w tablicy z `$addToSet` nie jest gwarantowana. (Lab 3, zad. 26)

</details>

**9.59. Która forma `$match` jest równoważna `{ property_type: /^c/i }`?**

- A) `{ property_type: { $regex: "^c", $options: "i" } }`
- B) `{ property_type: { $regex: "^c/i" } }`
- C) `{ property_type: { $like: "c%", $case: false } }`
- D) `{ $regex: { property_type: "^c" }, $options: "i" }`

<details><summary>Odpowiedź</summary>

**A** — flagi wyrażenia podaje się w `$options`. (Lab 3, zad. 28)

</details>

#### Duży zbiór IMDb (lab 3 big file)

**9.60. Pole `year` w kilku filmach jest napisem (np. `'2010è'`). Jak w `$match` zostawić tylko dokumenty, w których `year` jest liczbą?**

- A) `{ $match: { year: { $type: "number" } } }`
- B) `{ $match: { year: { $exists: true } } }`
- C) `{ $match: { year: { $ne: "" } } }`
- D) `{ $match: { year: { $isNumber: true } } }`

<details><summary>Odpowiedź</summary>

**A** — alias `"number"` w `$type` obejmuje typy int, long, double i decimal. `$exists` przepuściłoby też napisy. (Lab 3, duży plik, zad. 3 i 7)

</details>
