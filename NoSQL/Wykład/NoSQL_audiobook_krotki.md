# Bazy New/NoSQL — audiobook, najważniejsze rzeczy

To krótka, mówiona wersja wykładu „Bazy New/NoSQL”: tylko to, co najpewniej padnie na teście. Osiem działów w kolejności wykładu. Pierwszy mówi o Big Data i rodzajach baz NoSQL. Działy od drugiego do piątego omawiają MongoDB: modelowanie danych, operacje CRUD i operatory zapytań, walidację, agregacje i indeksy, a na końcu replikację, sharding i kolekcje szeregów czasowych. Szósty dział jest o Redisie, siódmy o bazach grafowych, a ósmy o Cassandrze i języku CQL. Każdy dział kończy się listą rzeczy do zapamiętania.


# 1. Big Data i bazy NoSQL — wprowadzenie

## Cztery V i duże systemy

Wykład opisuje Big Data wzorem: Volume plus Variety plus Velocity plus Veracity. Volume to objętość: ilość danych rośnie potęgowo, a nie liniowo, a Big Data może tworzyć także duża liczba małych zbiorów. Variety to różnorodność formatów, takich jak XML, JSON i multimedia. Velocity to szybkość: dane napływają bardzo szybko i z taką samą szybkością trzeba je przetwarzać, na przykład strumieniowo. Veracity, na slajdzie przetłumaczone jako niepewność, wynika z braków, niespójności i aproksymacji. Value nie należy do czterech V z wykładu.

Przy projektowaniu dużych systemów liczą się cztery aspekty: skalowalność, koszt, elastyczność i dostępność. NoSQL pomaga w każdym z nich: lepszą skalowalność daje architektura rozproszona, niższe koszty brak sztywnych schematów, większą elastyczność różnorodne modele danych, a wysoką dostępność replikacja i partycjonowanie. Wykład ostrzega jednak, by nie odchodzić bezrefleksyjnie od baz relacyjnych. Wybór zależy od danych, wymagań i zadania.

## Bazy relacyjne i zmiana charakteru danych

Bazy relacyjne przechowują dane w tabelach, w hierarchii: instancja, baza, tabela, wiersz. Rzeczywistym językiem zapytań jest SQL, a formalnym algebra relacyjna. Złączenie, czyli JOIN, łączy dane z wielu tabel. Systemy komercyjne klasy enterprise to Oracle, Microsoft SQL Server i IBM DB2, a otwarte to MySQL, PostgreSQL i MariaDB.

Dane dzielą się na trzy grupy. Strukturalne to tabele. Niestrukturalne to tekst, obrazy, wideo i audio. Półstrukturalne to XML i JSON. Przetwarzanie przechodzi od wsadowego do strumieniowego, w czasie rzeczywistym. Odczyty stają się ważniejsze i częstsze niż zapisy, aktualizacje są nieregularne, a ścisłą spójność coraz częściej zastępuje spójność ostateczna, czyli eventual consistency, w zamian za wydajność i skalowalność.

Tradycyjne bazy nie wystarczają z czterech powodów: problemy ze skalowaniem, słaba obsługa danych nieustrukturalizowanych, wysokie koszty i nieefektywność w czasie rzeczywistym. Rozwiązania dla Big Data to rozproszony system plików HDFS, MapReduce, chmura, bazy NoSQL, hurtownie danych, czyli Amazon Redshift, Google BigQuery i Snowflake, oraz uczenie maszynowe, czyli TensorFlow i Spark MLlib. Hadoop nie jest bazą danych, tylko platformą z HDFS i MapReduce. Bazą NoSQL z jego ekosystemu jest HBase.

Wykład podaje dwa główne powody zainteresowania NoSQL: produktywność tworzenia aplikacji oraz obsługę dużych wolumenów danych w klastrach wielu mniejszych, tańszych maszyn. Bazy relacyjne skalują się głównie pionowo, czyli przez mocniejszą maszynę, a NoSQL poziomo, czyli przez dokładanie maszyn. Google, Facebook, LinkedIn i Twitter przetwarzają w NoSQL terabajty danych dziennie.

## Chmura i sposoby przetwarzania

SaaS, Software as a Service, to gotowa aplikacja, na przykład Google Workspace i Salesforce. PaaS, Platform as a Service, to platforma do tworzenia i uruchamiania aplikacji, na przykład Heroku i Microsoft Azure. IaaS, Infrastructure as a Service, to serwery, sieci i przestrzeń dyskowa, na przykład AWS, Google Cloud i Azure.

OLTP, Online Transaction Processing, obsługuje bieżące transakcje z szybkimi zapisami i odczytami, na przykład w bankach i sklepach internetowych. OLAP, Online Analytical Processing, analizuje dane historyczne złożonymi zapytaniami i agregacjami. RTAP, Real-Time Analytical Processing, analizuje dane w czasie rzeczywistym, na przykład w monitoringu, rekomendacjach i Internecie rzeczy. T jak transakcja, A jak analiza.

Bazy relacyjne mają sztywny schemat, zapewniają spójność i kontrolę współbieżności i dobrze sprawdzają się w OLTP. Bazy NoSQL nie mają sztywnego schematu, dobrze działają w klastrach i powstały dla aplikacji webowych dwudziestego pierwszego wieku. Na schemacie SQL kontra NoSQL kostka OLAP stoi po stronie SQL. Przyporządkowania: MongoDB i CouchDB są dokumentowe, Cassandra i HBase kolumnowe, Redis klucz–wartość, a Neo4j grafowy.

## Termin NoSQL

NoSQL to nie „no to SQL”. Najczęściej rozwija się go jako Not only SQL. Termin nie ma precyzyjnej definicji, a NoSQL to raczej ruch niż konkretna technologia. W tysiąc dziewięćset dziewięćdziesiątym ósmym roku pokazano relacyjną bazę bez języka SQL, bazę Strozzi, która nie wpłynęła na późniejszy ruch. Współczesny NoSQL zaczyna się jedenastego czerwca dwa tysiące dziewiątego roku w San Francisco, na spotkaniu zorganizowanym przez Johana Oskarssona. Pokazano tam Voldemort, Cassandrę, Dynomite, HBase, Hypertable, CouchDB i MongoDB, bez Redisa i Neo4j. Nazwę wybrano jako dobry hashtag na Twitterze. Zaproponowano ją na kanale IRC hasz cassandra, a zatwierdził Eric Evans.

Impedancja obiektowo-relacyjna to różnica między strukturą obiektów w aplikacji a tabelami bazy relacyjnej. Podejście zmieniło się od integracji przez wspólną bazę do enkapsulacji bazy w aplikacji i integracji przez usługi sieciowe, czyli API. Bazy relacyjne nie są optymalne w klastrach.

Według hostingdata.co.uk bazy NoSQL są nierelacyjne, rozproszone, otwarte i horyzontalnie skalowalne. Ich cechy to schema-free, łatwa replikacja, proste API, spójność ewentualna i obsługa dużych zbiorów danych. Ewentualna znaczy tu ostateczna. Brak schematu jest zaletą i wadą naraz: daje elastyczność, ale grozi zabałaganieniem danych. Łatwiejsze programowanie NoSQL to ocena subiektywna. Spójność bywa poświęcana dla dostępności i szybkości, ale nie przy kontach bankowych, danych finansowych i ubezpieczeniowych.

## Rodziny baz NoSQL

Baza klucz–wartość to najprostszy model, odpowiednik tablicy asocjacyjnej, czyli słownika. Jest szybka i łatwo się skaluje, ale zwykle nie pozwala wyszukiwać po wartościach i nie ma złączeń. Służy do sesji, cache, koszyków, ustawień, liczników i tokenów. Ranking DB-Engines prowadzi Redis.

Redis to REmote DIctionary Server. Trzyma dane głównie w RAM, a trwałość zapewniają opcjonalnie RDB, czyli migawki, i AOF, czyli dziennik operacji. Składnia: SET uzytkownik dwukropek jeden, w cudzysłowie Jan, zapisuje wartość, a GET uzytkownik dwukropek jeden ją odczytuje. HSET zapisuje pola hasha, a HGETALL zwraca je wszystkie. LPUSH kolejka, a potem elementy, wstawia na początek listy. LRANGE kolejka zero minus jeden zwraca całą listę. SADD dodaje do zbioru, a SMEMBERS zwraca zbiór. Sorted Set służy do rankingów, a HyperLogLog do liczenia unikalnych gości.

Bazy dokumentowe przechowują dokumenty, najczęściej JSON, rzadziej XML, w kolekcjach. Dokumenty w jednej kolekcji mogą mieć różną strukturę i zagnieżdżenia, a szukać można po dowolnych polach. Zastosowania to logowanie zdarzeń, blogi i CMS. W MongoDB hierarchia to dokument, kolekcja, baza, a każdy dokument ma unikalne pole podkreślnik id, zwykle typu ObjectId. Dokumenty zapisuje się w JSON albo BSON. Składnia: db kropka klienci kropka insertOne, a w nawiasie dokument w klamrach. Wyszukiwanie: db kropka klienci kropka find z filtrem miasto dwukropek Warszawa. Aktualizacja: db kropka klienci kropka updateOne, a w nawiasie filtr po podkreślnik id i drugi argument dolar set, dwukropek, wiek dwadzieścia sześć. Dolar set zmienia tylko podane pole, a replaceOne zastępuje cały dokument. MongoDB skaluje się poziomo przez sharding, relacje wyraża zagnieżdżaniem, a transakcje ACID ma od wersji cztery zero, z ograniczeniami.

Bazy rodziny kolumn, czyli szerokich kolumn, mają tabele z podobnymi, ale niekoniecznie identycznymi wierszami, dostępnymi po kluczu wiersza. Nie są to po prostu bazy relacyjne ze zmiennym wierszem. Nie nadają się do transakcji ze ścisłą spójnością, agregacji, złączeń i częstych zmian schematu. Prowadzi Cassandra, za nią HBase. Cassandra ma hierarchię wiersz, tabela, keyspace, klaster. Wszystkie węzły są równorzędne, peer-to-peer, bez pojedynczego punktu awarii. Słynie z wydajności zapisu, a spójność ma konfigurowalną, eventual. Wymaga projektowania tabel pod zapytania i denormalizacji. Językiem jest CQL, podobny do SQL: CREATE TABLE klienci z kolumną id INT PRIMARY KEY, INSERT INTO klienci z listą kolumn i VALUES, a aktualizacja to UPDATE klienci SET wiek równa się dwadzieścia dziewięć WHERE id równa się tysiąc dwa.

W bazie grafowej węzły to encje, a krawędzie to relacje. Oba mogą mieć właściwości. Bazy grafowe OLTP obsługują dużą liczbę małych i średnich grafów, a OLAP małą liczbę bardzo dużych. Typowe zapytanie to najkrótsza ścieżka, a zastosowania to sieci społecznościowe, rekomendacje, grafy wiedzy i wykrywanie oszustw. Prowadzi Neo4j, przed Azure Cosmos DB. Neo4j używa języka Cypher: węzeł w nawiasach okrągłych, relacja w kwadratowych, kierunek strzałką. Przykład: CREATE, nawias a, myślnik, nawias kwadratowy dwukropek ZNA z właściwością od_kiedy dwa tysiące dwadzieścia, myślnik, strzałka, nawias b. MATCH wyszukuje wzorzec, RETURN zwraca, SET zmienia właściwość. Właściwość relacji odczytuje się przez zmienną relacji, na przykład r kropka od_kiedy.

Bazy XML przechowują dokumenty o strukturze drzewa. XPath nawiguje, XQuery odpytuje, XSLT przekształca. Przedstawiciele to Sedna, MarkLogic, Tamino, eXist-db i Virtuoso. Bazy RDF przechowują trójki: temat, czyli podmiot, predykat i obiekt. W grafie wierzchołki to podmioty i obiekty, a krawędzie to stwierdzenia. Językiem jest SPARQL, a przedstawicielami Apache Jena i rdf4j.

## DB-Engines, BASE, CAP i Map-Reduce

DB-Engines klasyfikuje bazy według popularności i aktualizuje ranking co miesiąc. W październiku dwa tysiące dwudziestego piątego roku prowadzą Oracle, MySQL, SQL Server i PostgreSQL. MongoDB jest piąta i jest najpopularniejszą bazą NoSQL, Redis siódmy, Cassandra jedenasta.

BASE to Basically Available, Soft state i Eventually consistent. Nie ma jednej uznanej definicji BASE. Miękki stan oznacza, że stan systemu może się zmieniać bez nowych zapisów. Ostateczna spójność oznacza, że węzły w końcu się zsynchronizują. W bazach relacyjnych zamiast BASE stosuje się ACID: Atomicity, Consistency, Isolation i Durability, czyli atomowość, spójność, izolację i trwałość.

Twierdzenie CAP mówi, że w rozproszonym systemie nie można jednocześnie zapewnić spójności, dostępności i tolerancji na podział sieci. Można mieć tylko dwie z trzech. C to Consistency, każdy odczyt zwraca najnowsze dane. A to Availability, każde żądanie dostaje odpowiedź. P to Partition tolerance, system działa mimo podziału sieci. CA to klasyczne bazy relacyjne, na przykład MySQL i PostgreSQL, skalowane pionowo. CP to MongoDB, HBase, BigTable i ZooKeeper. AP to Cassandra, DynamoDB, Riak i CouchDB.

Map-Reduce to model rozproszonego, równoległego przetwarzania. Kolejność etapów: podział danych, map, shuffle i sort, reduce. Map tworzy pary klucz, wartość, na przykład słowo i jedynka. Shuffle grupuje wartości po kluczu i przesyła je między węzłami. Reduce agreguje wartości dla klucza. Implementacją jest Apache Hadoop.

Czy to koniec baz relacyjnych? Zdecydowanie nie. Najsensowniej łączyć różne systemy zależnie od wymagań i zastosowania.

## Do zapamiętania

- Big Data to Volume, Variety, Velocity i Veracity, a XML i JSON to dane półstrukturalne.
- NoSQL to nie „no to SQL”, nie ma precyzyjnej definicji i jest ruchem, który narodził się jedenastego czerwca dwa tysiące dziewiątego roku w San Francisco z inicjatywy Johana Oskarssona.
- NoSQL skaluje się poziomo, a bazy relacyjne głównie pionowo.
- OLTP to bieżące transakcje, OLAP analiza historyczna, RTAP analiza w czasie rzeczywistym.
- Redis to klucz–wartość, MongoDB dokumentowa, Cassandra szerokich kolumn, Neo4j grafowa.
- Cassandra używa CQL, Neo4j Cyphera, RDF SPARQL-a, a XML XPath, XQuery i XSLT.
- BASE to Basically Available, Soft state, Eventually consistent, a ACID to Atomicity, Consistency, Isolation, Durability.
- W CAP MongoDB jest CP, Cassandra AP, a pojedyncza baza relacyjna CA.

# 2. MongoDB — instalacja, cechy i modelowanie danych

## Instalacja i narzędzia

MongoDB występuje w trzech odmianach. Community Server to darmowa edycja do samodzielnej instalacji na własnym komputerze. Enterprise Advanced to płatna wersja komercyjna. Atlas to baza w chmurze jako usługa. Serwer pobiera się ze strony mongodb.com, wybierając wersję, platformę i paczkę: msi, czyli instalator Windows, albo zip do rozpakowania. Instalator msi pozwala zainstalować mongod jako usługę Windows, która startuje z systemem i działa w tle.

Najważniejsze rozróżnienie: mongod to serwer bazy danych, mongosh to klient, czyli powłoka wiersza poleceń, a mongos to router zapytań w klastrze shardowanym. Nie myl mongos z mongosh. Stara powłoka nazywała się mongo i czytała plik startowy mongorc, nowa mongosh czyta plik mongoshrc. Mongosh jest open source na licencji Apache dwa zero i rozwija się osobno od serwera, dlatego ma własną numerację wersji. Oficjalne narzędzie graficzne to MongoDB Compass.

Domyślny port MongoDB to dwadzieścia siedem tysięcy siedemnaście. Każda instalacja ma trzy bazy systemowe: admin, config i local, a mongosh po starcie pracuje w bazie test. Domyślny katalog danych na Windowsie to backslash data, backslash db; przy instalacji z zip trzeba go utworzyć ręcznie albo podać inny przełącznikiem minus minus dbpath. Komunikat „Waiting for connections” w logach oznacza, że serwer działa i czeka na klientów.

Connection string ma schemat mongodb, dwukropek, dwa ukośniki, na przykład mongodb, dwukropek, ukośnik, ukośnik, localhost, dwukropek, dwadzieścia siedem zero siedemnaście. Schemat mongodb plus srv odczytuje listę serwerów z rekordu DNS i jest typowy dla Atlasa. Parametr readPreference równe primary kieruje odczyty do węzła głównego. Domyślnie serwer nie ma włączonej kontroli dostępu, więc odczyt i zapis są nieograniczone, i nasłuchuje tylko na localhost. Żeby nasłuchiwał na wszystkich interfejsach, uruchamia się go z opcją minus minus bind underscore ip underscore all.

W Dockerze MongoDB uruchamiasz poleceniem: docker run, minus minus name mongodb, minus d, minus p dwadzieścia siedem zero siedemnaście, dwukropek, dwadzieścia siedem zero siedemnaście, mongodb, ukośnik, mongodb minus community minus server, dwukropek, latest. Minus d to tryb detached, czyli praca w tle, a nie debug ani delete. Minus p mapuje porty w kolejności port hosta, dwukropek, port kontenera. Powłokę wewnątrz działającego kontenera otwiera docker exec, minus it, mongodb, mongosh, gdzie minus it to tryb interaktywny z terminalem.

## Cechy MongoDB

Zalety baz NoSQL według wykładu to elastyczny schemat, skalowalność pozioma przez partycjonowanie danych, czyli sharding, szybki odczyt i zapis, obsługa big data i aplikacji czasu rzeczywistego oraz obsługa różnych struktur danych. Ograniczenia to słabsze możliwości zapytań i słabsza spójność. Wiele baz NoSQL spełnia model BASE: Basically Available, czyli zasadniczo dostępna, Soft state, czyli stan miękki, i Eventual consistency, czyli spójność ostateczna. BASE daje słabsze gwarancje niż ACID z baz relacyjnych.

Baza dokumentów to rozszerzona baza klucz-wartość, w której wartość, czyli dokument, można przeszukiwać i indeksować. Dokument jest samoopisowy, może być hierarchiczny i ma unikalny identyfikator. Dokumenty grupuje się w kolekcje.

MongoDB to baza dokumentów, open source i wieloplatformowa. Pierwsze wydanie ukazało się w roku dwa tysiące dziewiątym. Jest napisana w C++, C i JavaScripcie, a stworzyła ją firma MongoDB, dawniej 10gen. Nazwa pochodzi od angielskiego słowa humongous, czyli ogromny. Slajd wymienia właściwości: wysoka dostępność, ostateczna spójność, automatyczny podział, replikacja master-slave, automatyczna naprawa i indeksy dodatkowe. Dziś zamiast master-slave mówi się o zestawach replik.

Sześć kluczowych cech MongoDB to: orientacja na dokumenty zapisane w formacie BSON; skalowalność pozioma przez sharding i pionowa przez mocniejszy sprzęt; indeksowanie dowolnego atrybutu, także zagnieżdżonego; replikacja przez zestawy replik, czyli replica sets, z węzłem primary i węzłami secondary, co daje wysoką dostępność; agregacja; oraz zapytania ad hoc według pól, zakresów i wyrażeń regularnych.

MongoDB pasuje do big data, analityki w czasie rzeczywistym, zarządzania treścią, czyli CMS i e-commerce, dzięki dynamicznemu schematowi bez migracji, do Internetu rzeczy, do aplikacji mobilnych z trybem offline-first przez MongoDB Realm oraz do mikroserwisów i aplikacji chmurowych.

## Skalowanie poziome i pionowe

Skalowanie poziome to dodawanie kolejnych serwerów, czyli shardów. Mechanizmem jest sharding: dane dzieli się na chunki rozproszone na shardach. Złożoność jest wysoka, bo trzeba skonfigurować klucz shardowania, czyli shard key, serwery konfiguracyjne, czyli config servers, i routery mongos. Limit jest bardzo wysoki, koszt początkowy wyższy, a obciążenie rozkłada się na wiele węzłów. Przykład: aplikacje z ogromną ilością danych.

Skalowanie pionowe to zwiększanie procesora, pamięci RAM i dysku jednego serwera. Jest proste i tanie na początku, ale ograniczone maksymalną specyfikacją sprzętu, a jego koszt rośnie wykładniczo. Poprawia wydajność tylko jednego węzła i pasuje do małych i średnich aplikacji.

## Struktura danych i podstawowe operacje

Hierarchia to instancja, baza danych, kolekcja, dokument, pole. Kolekcja odpowiada tabeli, dokument wierszowi, a pole, czyli para klucz-wartość, kolumnie. Pole _id to unikatowy identyfikator generowany automatycznie, jeśli go nie podasz.

Metody wywołuje się według wzoru db, kropka, nazwa kolekcji, kropka, metoda. Find zwraca kursor, a findOne jeden dokument albo null. InsertOne przyjmuje dokument, insertMany tablicę dokumentów w nawiasach kwadratowych. UpdateOne zmienia pierwszy pasujący dokument, updateMany wszystkie pasujące; obie przyjmują najpierw filtr, potem operatory, takie jak dolar set, który ustawia pole, i dolar unset, który pole usuwa. Cały dokument podmienia replaceOne. DeleteOne i deleteMany usuwają dokumenty, ale deleteMany z pustym filtrem zostawia kolekcję i indeksy. Kolekcję razem z indeksami usuwa db, kropka, kolekcja, kropka, drop, a bieżącą bazę db, kropka, dropDatabase.

Indeks tworzy createIndex z nazwą pola i kierunkiem: jeden rosnąco, minus jeden malejąco. Bez indeksu baza skanuje całą kolekcję. Agregację wykonuje aggregate z tablicą etapów: dolar match filtruje jak WHERE, dolar group grupuje jak GROUP BY, dolar project kształtuje pola, dolar sort sortuje.

Przykład z filmami: db, kropka, movies, kropka, find, z filtrem year, dolar g t dwa tysiące dwadzieścia, i projekcją _id zero, title jeden, a potem sort z title minus jeden. Dolar g t to ostro większe, dolar g t e większe lub równe. W projekcji jeden pokazuje pole, zero je ukrywa, a _id jest zwracane domyślnie. Sort z minus jeden sortuje malejąco. Wynik to Tomb Raider, potem Hobbit; Niezniszczalni z roku dwa tysiące dwadzieścia odpadają.

## BSON, JSON i typy danych

BSON to Binary JSON, binarny nadzbiór JSON, w którym MongoDB przechowuje dokumenty. Ma dodatkowe typy: Date, Binary, ObjectId i Decimal128. W BSON zakodowany jest rozmiar każdego elementu, więc parser może go pominąć, co przyspiesza przechodzenie po dokumencie. JSON to tekstowy, czytelny format z typami string, number, boolean, null, array i object, używany do wymiany danych z aplikacjami. Według slajdu BSON jest mniejszy i szybszy, a JSON czytelniejszy.

ObjectId ma dwanaście bajtów, czyli dwadzieścia cztery znaki szesnastkowe, i jest domyślną wartością pola _id. Typy BSON to między innymi Int32, Double, String, Array, Object, Binary data zapisywane jako BinData, Boolean, Date zapisywane jako ISODate, Null i Regular Expression. Typ Undefined jest przestarzały, zamiast niego używa się null.

## Dokument, klucze główne i GridFS

Maksymalny rozmiar dokumentu to szesnaście megabajtów. Pole _id najwyższego poziomu jest zarezerwowane dla klucza głównego. Nazwy pól nie mogą zaczynać się od dolara, bo dolar oznacza operatory, a kropka służy do pól zagnieżdżonych, na przykład address kropka city. Nazwy pól w dokumencie są unikalne, a kolejność pól jest zachowana, z wyjątkiem _id, które trafia na początek.

Pole _id jest unikalne w kolekcji, niemutowalne i może mieć dowolny typ poza tablicą. Sposoby wyboru klucza to naturalny identyfikator, auto-inkrement, który nie jest zalecany, UUID oraz domyślny ObjectId, oparty na czasie, odcisku maszyny i procesu oraz liczniku.

Dane binarne przechowuje się na dwa sposoby. BinData to pole binarne w dokumencie, ograniczone do szesnastu megabajtów, proste, bez strumieniowania, dobre do miniatur, kluczy i certyfikatów. GridFS dzieli duży plik na chunki o domyślnym rozmiarze dwustu pięćdziesięciu pięciu kilobajtów, zapisywane w dwóch kolekcjach: fs kropka files z metadanymi i fs kropka chunks z danymi, z indeksem files_id jeden, n jeden. Obsługuje strumieniowanie i częściowe odczyty i służy do wideo, PDF i kopii zapasowych.

## Modelowanie danych

Są trzy podejścia. Dokumenty osadzone trzymają powiązane dane w jednym dokumencie; pasują do relacji jeden do jednego i jeden do wielu z ograniczoną liczbą elementów i dają szybki odczyt. Referencje to dane w osobnych kolekcjach łączone identyfikatorami; pasują do jeden do wielu, wiele do wielu i do dużych, współdzielonych danych. Podejście hybrydowe łączy oba, równoważąc wydajność, elastyczność i pamięć.

Tablicę osadzonych dokumentów stosuj, gdy relacja jest jeden do wielu, dane nie rosną bez ograniczeń, są ściśle związane z rodzicem i zależy ci na wydajności odczytu i zapisu.

MongoDB nie ma jawnego schematu, ale niejawny schemat i tak jest wymagany, bo dokumenty w kolekcji są zwykle podobne. Wyzwaniem jest równowaga między wydajnością a złożonością struktury.

Model zdenormalizowany to zagnieżdżone poddokumenty: zaletą jest mniej zapytań, wadą możliwa duża redundancja; pasuje do jeden do jednego i jeden do wielu. Model znormalizowany to referencje, czyli zwykłe wartości identyfikatorów, bez specjalnego typu i bez kontroli spójności po stronie bazy; daje większą elastyczność kosztem większej liczby zapytań i pasuje do wiele do wielu.

Przykład redundancji: wydawca osadzony w każdej książce powtarza swoje dane. Jeśli książek na wydawcę jest mało i ich liczba jest ograniczona, tablicę identyfikatorów książek można trzymać w dokumencie wydawcy. Jeśli liczba jest nieograniczona, referencję publisher_id trzyma się w każdej książce, żeby uniknąć rosnących tablic. Relację jeden do jednego modeluje pojedynczy poddokument, na przykład address, a jeden do wielu tablica poddokumentów, na przykład addresses. Wiele do wielu można osadzić, powtarzając dane autora w kilku książkach.

Pięć antywzorców to: nieograniczone tablice, które mogą przekroczyć limit szesnastu megabajtów i spowolnić indeks; zbyt wiele kolekcji, co obniża wydajność silnika pamięci; niepotrzebne indeksy, które zajmują miejsce i spowalniają zapis; zbyt duże dokumenty, które spowalniają częste zapytania; oraz nadmiar operacji dolar lookup, czyli złączeń.

## Sterowniki, język zapytań i porównanie z SQL

Z MongoDB pracuje się przez powłokę mongosh albo przez sterowniki dla Javy, C sharp, Pythona, gdzie sterownik to PyMongo, Node.js, PHP, Rubiego i innych. W Node.js kolekcję wybiera się metodą collection z nazwą w nawiasie, na przykład db, kropka, collection, nawias, inventory, kropka, find. Zapytania w mongosh bazują na JavaScripcie, zapytania odczytu zwracają kursor, a każda komenda dotyczy pojedynczej kolekcji. W etapie dolar group pole _id z napisem dolar kategoria grupuje po wartości pola, dolar sum jeden liczy dokumenty, a dolar avg liczy średnią. MapReduce to starszy, dziś przestarzały mechanizm agregacji.

W porównaniu z SQL tabela to kolekcja, wiersz to dokument, kolumna to pole, złączenie to dolar lookup albo osadzanie, a klucz główny to zawsze pole _id. CREATE TABLE nie jest potrzebne, bo kolekcja powstaje niejawnie przy pierwszym insertOne albo insertMany, albo jawnie przez db, kropka, createCollection. ALTER TABLE ADD to updateMany z pustym filtrem i dolar set, na przykład join_date, dwukropek, new Date. ALTER TABLE DROP COLUMN to updateMany z pustym filtrem i dolar unset. CREATE INDEX z user_id rosnąco i age malejąco to createIndex z user_id jeden i age minus jeden. DROP TABLE to db, kropka, people, kropka, drop.

## Do zapamiętania

- Mongod to serwer, mongosh to klient, mongos to router, a domyślny port to dwadzieścia siedem tysięcy siedemnaście.
- W Dockerze minus d oznacza pracę w tle, minus p mapuje port hosta na port kontenera, a docker exec minus it mongodb mongosh otwiera powłokę w kontenerze.
- BASE to Basically Available, Soft state, Eventual consistency, czyli słabsza spójność niż ACID.
- Skalowanie poziome to sharding z shard key, config servers i mongos, a pionowe to mocniejszy jeden serwer.
- Dokument ma najwyżej szesnaście megabajtów, a większe pliki obsługuje GridFS w kolekcjach fs kropka files i fs kropka chunks.
- ObjectId ma dwanaście bajtów i dwadzieścia cztery znaki szesnastkowe, a pole _id jest unikalne, niemutowalne i nie może być tablicą.
- Osadzaj dane czytane razem w relacjach jeden do jednego i jeden do wielu z ograniczoną liczbą elementów, a dla wiele do wielu i danych rosnących bez końca używaj referencji.
- Tabela to kolekcja, wiersz to dokument, kolumna to pole, a DROP TABLE to drop, nie deleteMany.

# 3. MongoDB — CRUD, operatory zapytań, projekcja i modyfikatory kursora

## Powłoka mongosh, bazy i kolekcje

Powłoka MongoDB nazywa się mongosh. Domyślny port serwera to 27017, a domyślna baza, do której podłącza się mongosh, to test. Show dbs albo równoważnie show databases wypisuje listę baz. Show collections albo show tables wypisuje kolekcje bieżącej bazy. Powłokę kończy exit, exit z nawiasami albo kropka exit. Bazy systemowe to admin, config i local.

Samo słowo db wyświetla bazę, w której jesteś. Use, spacja, nazwa bazy przełącza na tę bazę i jest zarazem sposobem jej utworzenia, bo w MongoDB nie ma polecenia CREATE DATABASE. Baza powstaje fizycznie przy pierwszym zapisie danych i dopiero wtedy widać ją w show dbs. Db kropka dropDatabase, z pustymi nawiasami, kasuje bazę bieżącą; nie przyjmuje nazwy, więc najpierw trzeba się przełączyć przez use.
Kolekcja to odpowiednik tabeli, ale bez narzuconego schematu. Tworzy ją db kropka createCollection z nazwą w cudzysłowie, a kasuje db kropka nazwa kolekcji kropka drop, bez argumentu. Drugi argument createCollection to dokument opcji: capped, czyli true albo false, max, czyli maksymalna liczba dokumentów, i size, czyli maksymalny rozmiar w bajtach. Kolekcja capped, o ograniczonym rozmiarze, działa jak bufor cykliczny: gdy nowy dokument przekroczyłby limit, usuwane są najstarsze dokumenty. Capped wymaga parametru size, a max jest opcjonalny. Przykład: createCollection logi, capped true, size dziesięć milionów czterysta osiemdziesiąt pięć tysięcy siedemset sześćdziesiąt, czyli dziesięć mebibajtów.

## Wstawianie i liczenie dokumentów

InsertOne dodaje dokładnie jeden dokument w klamrach. InsertMany dodaje wiele dokumentów i przyjmuje tablicę, czyli dokumenty w nawiasie kwadratowym. Obie metody tworzą kolekcję, jeżeli nie istnieje. InsertMany jest zwykle wydajniejsze niż wiele wywołań insertOne, bo wysyła paczkę w jednym żądaniu.

CountDocuments liczy dokładnie i przyjmuje filtr, na przykład countDocuments, status A. EstimatedDocumentCount podaje liczbę przybliżoną, bez filtra, z metadanych kolekcji, więc jest szybsza. Dawne count jest przestarzałe.

CRUD to Create, Read, Update, Delete. Operacje zapisu dotyczą jednej kolekcji, a wszystkie operacje zapisu są atomowe na poziomie pojedynczego dokumentu. InsertMany czy updateMany jako całość atomowe nie są. Każdy dokument wymaga unikalnego pola podkreślnik id, które działa jak klucz podstawowy. Gdy go pominiesz, sterownik wygeneruje wartość typu ObjectId. INSERT INTO people z SQL odpowiada db kropka people kropka insertOne z dokumentem user_id, age i status.

## Aktualizacja i operatory pól

Metody aktualizacji to updateOne, updateMany i replaceOne. Składnia: filter, update i opcjonalne options, w tej kolejności. Filtr ma tę samą składnię co w find. Na diagramie pierwszy argument to update filter, a drugi, na przykład dolar set status reject, to update action. UpdateOne zmienia pierwszy pasujący dokument, updateMany wszystkie pasujące. ReplaceOne zastępuje cały dokument nowym i zachowuje tylko podkreślnik id.

UPDATE people SET status równa się C WHERE age większe niż dwadzieścia pięć to updateMany z filtrem age dolar g t dwadzieścia pięć i akcją dolar set status C. WHERE trafia do pierwszego argumentu, SET do drugiego, a updateMany, bo UPDATE zmienia wszystkie pasujące wiersze. SET age równa się age plus trzy to dolar inc age trzy.

Slajd opisuje dwa tryby. Tryb zamień: parametr update nie zawiera operatorów, więc cały dokument jest zamieniany z zachowaniem identyfikatora. Tryb zmień: update zawiera wyłącznie operatory, a każdy operator może wystąpić tylko raz. Kilka pól ustawiasz więc w jednym dolar set. Trybów nie wolno mieszać. We współczesnym mongosh updateOne bez operatorów zwraca błąd, a zamianę robi replaceOne.

Operatory pól. Dolar set ustawia wartość pola i tworzy je, gdy go nie ma. Dolar unset usuwa pole z dokumentu, na przykład dolar unset phone pusty tekst; podana wartość nie ma znaczenia. Dolar rename zmienia nazwę pola: po lewej stara nazwa, po prawej nowa, czyli dolar rename username dwukropek login daje pole login. Dolar inc zwiększa wartość o podaną liczbę i przyjmuje liczby ujemne, a operatora dolar dec nie ma. Dolar mul mnoży, więc dolar mul price jeden kropka dwa podnosi cenę o dwadzieścia procent. Dolar currentDate wpisuje bieżącą datę: true daje typ Date, a dolar type timestamp typ Timestamp.

Pole zagnieżdżone zmieniasz notacją kropkową w cudzysłowie: dolar set, w cudzysłowie size kropka uom, dwukropek cm. Pola h i w zostają. Dolar set size z klamrami uom cm nadpisałby cały poddokument, a size kropka uom bez cudzysłowu to błąd składni.

## Operatory tablicowe i upsert

Dolar push dodaje element na koniec tablicy, także duplikat. Dolar addToSet też dodaje na koniec, ale ignoruje duplikaty, więc gdy element już jest, nic się nie zmienia. Kilka osobnych elementów dodaje modyfikator dolar each: dolar push, tags, w klamrach dolar each z tablicą tag1 i tag2. Dolar push z samą tablicą tag1 i tag2, bez dolar each, doda jeden element, który sam jest tablicą. Dolar each działa też z dolar addToSet.

Dolar pop usuwa pierwszy albo ostatni element: jeden usuwa ostatni, minus jeden pierwszy. Dolar pull usuwa wszystkie elementy pasujące do wartości, warunku albo wyrażenia regularnego, na przykład dolar pull roles ukośnik daszek m ukośnik usuwa wszystkie role zaczynające się od m.
Upsert to update plus insert. Włączasz go trzecim argumentem, w klamrach upsert dwukropek true. Gdy żaden dokument nie pasuje do filtra, wstawiany jest nowy. W trybie modyfikacji nowy dokument zawiera pola równości z filtra i efekt operatorów: updateOne name Alice, dolar set age trzydzieści, upsert true daje dokument z podkreślnik id, name Alice i age trzydzieści. W trybie zamiany nowy dokument zawiera pola dokumentu zastępczego, a podkreślnik id jest zachowane z filtra albo tworzone: replaceOne podkreślnik id dziesięć, name Nowy, upsert true daje dokument z identyfikatorem dziesięć. UpdateMany z upsert wstawia najwyżej jeden dokument.

## Usuwanie, findOneAndDelete, findAndModify i bulkWrite

DeleteOne usuwa pierwszy pasujący dokument, deleteMany wszystkie pasujące. Na diagramie filtr usuwania to delete filter. DeleteMany z pustymi klamrami usuwa wszystkie dokumenty, ale zostawia kolekcję i indeksy, a drop kasuje kolekcję. DELETE FROM people WHERE status równa się D to deleteMany status D.

FindOneAndDelete usuwa jeden dokument, zwraca go i ma opcję sort, która wybiera, który dokument usunąć. Z sort lastLogin jeden usunięty zostanie użytkownik logowany najdawniej. DeleteOne zwraca tylko liczbę usuniętych. FindAndModify modyfikuje albo usuwa jeden dokument i przyjmuje jeden dokument z polami query, sort oraz remove true albo update; opcja new true zwraca dokument po zmianie.

BulkWrite wykonuje w jednym wywołaniu wiele zapisów na jednej kolekcji. Obsługuje sześć operacji: insertOne, updateOne, updateMany, replaceOne, deleteOne i deleteMany. Nie ma wśród nich insertMany. Domyślnie ordered ma wartość true: operacje idą szeregowo, a błąd kończy przetwarzanie reszty, bez cofania wcześniejszych. Z ordered false MongoDB może działać równolegle i po błędzie kontynuuje. Pola operacji: insertOne ma document, updateOne i updateMany filter i update, replaceOne filter i replacement, a usuwanie samo filter.

## Find, selekcja i notacja kropkowa

Db kropka kolekcja kropka find przyjmuje query, a potem projection. Oba są opcjonalne, ale gdy podajesz samą projekcję, na pierwszym miejscu stoją puste klamry. Wynik zwraca kursor. Find z pustymi nawiasami i find z pustymi klamrami zwracają wszystko. Warunki rozdzielone przecinkiem łączy niejawne „i”. Dwa operatory przy jednym polu, na przykład year dolar g t e dwa tysiące pięć, dolar l t e dwa tysiące piętnaście, tworzą przedział domknięty, odpowiednik BETWEEN.

Diagram find nazywa cztery części: collection, query criteria, projection i cursor modifier, na przykład kropka limit pięć. Według slajdu o selekcji query to wyrażenie z jednym operatorem logicznym najwyższego poziomu, dolar and albo dolar or, albo warunki na polach.

Równość z całym poddokumentem wymaga zgodności nazw, wartości, liczby i kolejności pól. Gdy w bazie director ma lastName Stallone, a potem firstName Sylwester, zapytanie z odwrotną kolejnością pól zwraca pusty wynik. Równość z całą tablicą, na przykład tablica dziesięć, dwa, trzy, wymaga tych samych elementów w tej samej liczbie i kolejności.

Notacja kropkowa sięga w głąb: director kropka firstName albo actors kropka dwa, czyli trzeci aktor, bo indeksy liczy się od zera. Wyrażenie z kropką musi być w cudzysłowie, na przykład find, w cudzysłowie out1 kropka a, dwukropek a1. Notacja kropkowa nie zależy od kolejności pól ani od dodatkowych pól poddokumentu. Nazwy pól rozróżniają wielkość liter.

## Operatory porównania i grupy operatorów

Osiem operatorów porównania: dolar e q równe, dolar n e różne, dolar g t większe, dolar g t e większe lub równe, dolar l t mniejsze, dolar l t e mniejsze lub równe, dolar in należy do tablicy i dolar n in nie należy. Zapis pole dwukropek wartość to skrót dolar e q. Dolar in i dolar n in przyjmują tablicę. Dolar in to „którykolwiek”, odpowiednik IN z SQL. Dolar n e i dolar n in zwracają też dokumenty bez danego pola. Typy mają znaczenie: liczba pięć to nie tekst pięć, a automatyczna konwersja dotyczy tylko typów liczbowych między sobą. Porównania idą według kolejności typów BSON.

Grupy operatorów z wykładu. Tablicowe: dolar all, dolar elemMatch, dolar size. Elementów: dolar exists i dolar type. Logiczne: dolar and, dolar or, dolar nor i dolar not; plansza dokłada tu dolar expr. Są też geograficzne, na przykład dolar geoWithin, i bitowe, na przykład dolar bitsAllSet.

## Dolar exists, dolar regex, dolar text i dolar expr

Dolar exists true zwraca dokumenty z polem, także gdy pole ma wartość null, a dolar exists false dokumenty bez pola.
Dolar regex dopasowuje wyrażenie regularne: name, dolar regex, w cudzysłowie daszek Jan, dolar options i. Daszek to początek tekstu, a opcja i wyłącza rozróżnianie wielkości liter. Skrót to literał w ukośnikach, ukośnik daszek Jan ukośnik i.

Dolar text to wyszukiwanie pełnotekstowe i wymaga indeksu tekstowego. Stoi na najwyższym poziomie filtra, a tekst podaje się w dolar search: find, w klamrach dolar text, w klamrach dolar search mongodb baza. Słowa rozdzielone spacją łączy „lub”.

Dolar expr pozwala użyć wyrażeń agregacji i porównać dwa pola tego samego dokumentu: dolar expr, dolar g t, w nawiasie kwadratowym dolar price i dolar koszt, każde w cudzysłowie. Operator przyjmuje tablicę argumentów. Wydajność zapytań sprawdza metoda explain.

## Tablice w zapytaniach

Dolar size sprawdza dokładną liczbę elementów, na przykład colors dolar size trzy, i nie przyjmuje zakresów. Dolar elemMatch wymaga, żeby wszystkie warunki spełnił ten sam element tablicy, na przykład grades, dolar elemMatch, subject Math i score dolar g t e osiemdziesiąt. Dolar all wymaga obecności wszystkich wymienionych elementów, w dowolnej kolejności, i dopuszcza inne. Gdy Tom Hanks gra w trzech filmach, a Robin Wright tylko w Forrest Gump, dolar all z obojgiem zwraca tylko Forrest Gump, a dolar in wszystkie trzy filmy. Dokładną liczbę elementów dodaje się przez dolar size obok dolar all.

Zasady przeszukiwania tablic. Równość z pojedynczą wartością pasuje, gdy całe pole jest jej równe albo gdy dowolny element tablicy jest jej równy. Przy pozostałych operatorach każdy operator może trafić w inny element. Dlatego ratings dolar g t e dwa, dolar l t e trzy dopasuje tablicę jeden, cztery. Żeby warunki dotyczyły jednego elementu, używasz dolar elemMatch.

## Operatory logiczne i dolar not

Dolar and i dolar or przyjmują tablicę wyrażeń, według wykładu co najmniej dwóch, i stoją na najwyższym poziomie zapytania, nigdy przy polu. Przykład: dolar or, w nawiasie kwadratowym price dolar l t dziesięć oraz quantity dolar g t sto. Dolar nor ma tę samą składnię i znaczy „żaden”. Jawny dolar and jest potrzebny, gdy ten sam klucz wystąpiłby dwa razy, na przykład przy dwóch warunkach dolar or.

Dolar not neguje jeden operator, stoi przy polu i nie może być na najwyższym poziomie: price, dolar not, dolar g t sto. Zwraca ceny mniejsze lub równe sto oraz dokumenty bez pola price, więc to nie to samo co dolar l t e sto. Dolar not może przyjąć wprost wyrażenie regularne: name, dolar not, ukośnik apple ukośnik i.

## Projekcja

Projekcja to drugi argument find. Jeden albo true włącza pole, zero albo false je wyłącza. Nie wolno mieszać włączeń i wyłączeń; wyjątkiem jest podkreślnik id, które jest dodawane domyślnie i można je wyłączyć zerem. Title jeden, podkreślnik id zero jest poprawne, a title jeden, year zero to błąd.

Dolar slice wybiera fragment tablicy: liczba dodatnia daje pierwsze elementy, ujemna ostatnie, a tablica skip i count pomija i bierze, więc dolar slice dwa, trzy pomija dwa i bierze trzy. Dolar elemMatch w projekcji zwraca pierwszy pasujący element tablicy, a gdy żaden nie pasuje, to pole jest pomijane.

## Modyfikatory kursora

Modyfikatory to sort, limit i skip. Sort przyjmuje dokument z polami: jeden rosnąco, minus jeden malejąco. Pierwsze pole jest kluczem głównym, drugie rozstrzyga remisy. Limit, z argumentem count, zwraca najwyżej tyle dokumentów, a skip, z argumentem offset, pomija dokumenty od początku. Modyfikatory łączy się w dowolnej kolejności bez skutków ubocznych, bo serwer zawsze wykonuje sort, potem skip, potem limit. Limit sześć, skip trzy i skip trzy, limit sześć zwracają te same dokumenty, od czwartego do dziewiątego. Modyfikatory podaje się, zanim kursor zacznie zwracać dokumenty. Bez sort kolejność jest niezdefiniowana. Sortowanie następuje przed projekcją, więc można sortować po polu, którego nie ma w wyniku.

## SQL a MongoDB

WHERE to pierwszy argument find, lista kolumn to projekcja. SELECT user_id, status FROM people to find, puste klamry, user_id jeden, status jeden, podkreślnik id zero, bo identyfikator trzeba wyłączyć jawnie. AND to przecinek, OR to dolar or z tablicą, różne to dolar n e, a przedział to dwa operatory przy jednym polu. LIKE procent bc procent to ukośnik bc ukośnik, a LIKE bc procent to ukośnik daszek bc ukośnik. ORDER BY DESC to sort z minus jedynką. COUNT to count, a COUNT kolumny to filtr dolar exists true. DISTINCT status to db kropka people kropka distinct status albo agregacja dolar group po dolar status. LIMIT jeden to findOne, LIMIT pięć SKIP dziesięć to limit pięć i skip dziesięć, a EXPLAIN to kropka explain na kursorze.

## Do zapamiętania

- InsertMany przyjmuje tablicę, a obie metody wstawiania tworzą brakującą kolekcję i nadają ObjectId, gdy brak podkreślnik id.
- Zapis jest atomowy na poziomie pojedynczego dokumentu.
- UpdateOne zmienia pierwszy pasujący dokument, updateMany wszystkie, a replaceOne zastępuje cały dokument z zachowaniem podkreślnik id.
- Dolar push z dolar each dodaje kilka elementów, dolar addToSet pomija duplikaty, dolar pop jeden usuwa ostatni element, a upsert true wstawia jeden dokument, gdy nic nie pasuje.
- BulkWrite jest domyślnie ordered i zatrzymuje się na pierwszym błędzie, a insertMany nie należy do jego operacji.
- Dolar in to „którykolwiek”, dolar all to „wszystkie”, a dolar elemMatch to „wszystkie warunki w jednym elemencie”.
- Dolar and, dolar or i dolar nor stoją na najwyższym poziomie, dolar not przy polu, a dolar n e i dolar not zwracają też dokumenty bez pola.
- Projekcja nie miesza zer i jedynek poza podkreślnik id, a sort, skip i limit wykonują się zawsze w tej kolejności.

# 4. MongoDB — walidacja schematu, Aggregation Framework, import i indeksy

## Walidacja schematu

MongoDB domyślnie ma elastyczny schemat: nowa kolekcja nie ma żadnej walidacji, a do jednej kolekcji można wstawić dokumenty o różnych polach. Nie znaczy to jednak, że struktury nie da się wymusić. Zdanie „MongoDB nie pozwala wymusić struktury dokumentów” jest fałszywe. Do tego służą reguły walidacji schematu.

Reguły podajemy zwykle przy tworzeniu kolekcji. Piszemy db, kropka, createCollection, w nawiasie nazwa kolekcji posts, a potem obiekt opcji. Pierwsza opcja to validator, a w nim operator dolar jsonSchema. W schemacie stoi bsonType object, czyli cały dokument jest obiektem, dalej required, czyli tablica pól wymaganych, na przykład title i body, oraz properties, czyli opis poszczególnych pól. Typ pola podajemy słowem bsonType, na przykład bsonType string.
Zapamiętaj podział ról. Tablica required mówi, które pola muszą istnieć. Obiekt properties mówi, jak pola mają wyglądać, jeśli istnieją. Pole category opisane w properties, ale nieobecne w required, jest opcjonalne, a jeśli wystąpi, musi być napisem. Dlatego insert z polem newbody zamiast body zostanie odrzucony z błędem Document failed validation, bo brakuje wymaganego body. Samo dodatkowe pole nie przeszkadza, dopóki nie ustawimy additionalProperties false.

Ustawienie additionalProperties false zabrania pól spoza listy properties. Jest tu klasyczna pułapka: MongoDB sam dodaje do każdego dokumentu pole underscore id. Jeśli go nie wymienisz w properties, każdy insert zostanie odrzucony. Dlatego wpisujemy underscore id, dwukropek, puste klamry, czyli pole dozwolone bez narzuconego typu.

Walidator nie musi składać się tylko z dolar jsonSchema. Dolar jsonSchema sprawdza strukturę: typy pól i obecność pól wymaganych. Dolar expr pozwala na logikę, arytmetykę i porównania między polami tego samego dokumentu, na przykład dolar lt sprawdzające, czy cena po rabacie jest mniejsza od ceny zwykłej. Oba mechanizmy łączymy operatorem dolar and.

Dwa parametry stoją obok walidatora. ValidationLevel mówi, które operacje sprawdzamy, i ma trzy wartości: strict, czyli pełna walidacja wszystkich wstawień i aktualizacji; moderate, które według slajdu waliduje tylko nowe dokumenty i modyfikowane pola, a istniejące dokumenty mogą nie spełniać schematu; oraz off, czyli walidacja wyłączona. ValidationAction mówi, co robimy przy niezgodności, i ma dwie wartości: error odrzuca operację, a warn zapisuje dokument, ale generuje ostrzeżenie w logach. Wartości domyślne to strict i error. Dystraktor validationLevel warn albo validationAction off jest niepoprawny.

Walidator sprawdzamy metodą db, kropka, getCollectionInfos z filtrem name posts albo przez db, kropka, runCommand z listCollections jeden i filtrem. RunCommand to uniwersalna funkcja do poleceń administracyjnych. Walidator zmieniamy i usuwamy poleceniem collMod, czyli collection modify. Db, kropka, runCommand z collMod posts i validator równym pustym klamrom kasuje reguły. Db, kropka, runCommand z collMod posts i validationLevel off tylko wyłącza walidację, a reguły zostają zapisane.

Obiekt zagnieżdżony, na przykład author, opisujemy tymi samymi słowami co cały dokument: bsonType object, własne required z polami name i email, własne properties i własne additionalProperties. Schemat jest rekurencyjny.
## Aggregation Framework i potok

Aggregation Framework służy do przetwarzania, transformacji i analizy danych: analityki w czasie rzeczywistym, raportów z sumami i średnimi, dashboardów, łączenia kolekcji przez dolar lookup i przygotowania danych do uczenia maszynowego, także przez MongoDB Spark Connector. Główna korzyść: większość operacji wykonuje się po stronie serwera, co ogranicza transfer danych przez sieć i poprawia wydajność aplikacji.

Potok agregacji, po angielsku Aggregation Pipeline, to tablica etapów przekazywana do metody aggregate. Każdy etap pracuje na wyniku poprzedniego, więc kolejność etapów ma znaczenie. Przykład z wykładu, trzech najmłodszych inżynierów: dolar match z vocation ENGINEER, dolar sort z dateofbirth minus jeden, dolar limit trzy i dolar unset z tablicą underscore id, vocation i address. Dolar unset to krótszy zapis wykluczenia pól. Uruchamiamy to przez db, kropka, persons, kropka, aggregate, w nawiasie pipeline.

Ten sam wynik daje zapytanie MQL: find z filtrem i projekcją z zerami, potem kropka sort i kropka limit. Find potrafi filtrować, sortować, limitować i rzutować, ale nie potrafi grupować. Grupowanie, łączenie kolekcji i zapis wyniku wymagają potoku. Zapytania find obsługuje na serwerze Query Runtime, a potoki obsługuje Aggregation Runtime.

Plan wykonania pokazuje metoda explain. Ma trzy tryby: queryPlanner, który jest domyślny, executionStats ze statystykami wykonania oraz allPlansExecution z danymi o wszystkich rozważanych planach. W planie widać COLLSCAN, czyli skan kolekcji, albo IXSCAN, czyli skan indeksu. Uwaga na szyk. Przy agregacji explain stoi przed aggregate: db, kropka, persons, kropka, explain w nawiasie executionStats, kropka, aggregate w nawiasie pipeline. Przy find explain stoi na końcu: db, kropka, coll, kropka, find, kropka, explain.

W Visual Studio Code kod uruchamiamy w playgroundzie, czyli pliku z rozszerzeniem kropka mongodb kropka js. Domyślny port MongoDB to 27017.

## Tabela SQL a operatory agregacji

WHERE to dolar match. GROUP BY to dolar group. HAVING to też dolar match, tylko ustawiony po dolar group; osobnego operatora having nie ma. SELECT to dolar project. ORDER BY to dolar sort. LIMIT to dolar limit. SUM to dolar sum. COUNT to dolar sum oraz dolar sortByCount. JOIN to dolar lookup. SELECT INTO NEW_TABLE to dolar out. MERGE INTO TABLE to dolar merge, od wersji 4.2. UNION ALL to dolar unionWith, od wersji 4.4. Dolar out zastępuje całą kolekcję docelową, a dolar merge scala wynik z istniejącą kolekcją.

## Etapy potoku

Dolar group grupuje dokumenty według underscore id, które jest obowiązkowe. Poprawny zapis: klamry, dolar group, dwukropek, klamry, underscore id, dwukropek, w cudzysłowie dolar cust_id, przecinek, total, dwukropek, klamry z dolar sum i dolar amount. Pole wynikowe musi stać wewnątrz dolar group, obok underscore id. Nazwę pola poprzedzamy dolarem; bez dolara byłaby stałym napisem. Dolar group z samym underscore id działa jak SELECT DISTINCT. Underscore id null wrzuca wszystkie dokumenty do jednej grupy. Akumulatory to dolar sum, dolar avg, dolar min, dolar max, dolar first, dolar last, dolar push, dolar addToSet, dolar stdDevPop dla populacji, dolar stdDevSamp dla próby oraz dolar top i dolar bottom. Dolar push zbiera wszystkie wartości z duplikatami, a dolar addToSet tylko unikalne. Liczbę dokumentów w grupie liczy dolar sum jeden, z liczbą jeden bez cudzysłowu. Dolar sum z dolar pole sumuje wartości tego pola.

Dolar limit przyjmuje dodatnią liczbę całkowitą, na przykład dolar limit pięć. Stawiamy go po dolar sort albo dolar match. Trzy najdroższe produkty to dolar sort z cena minus jeden, a potem dolar limit trzy.
Dolar project wybiera pola: jeden włącza, zero wyklucza, a wyrażenie tworzy nowe pole. Underscore id jest dołączane domyślnie, chyba że napiszesz underscore id zero. W jednym dolar project nie miesza się jedynek z zerami, poza underscore id zero. Wyrażenia z wykładu to dolar concat, który skleja napisy, dolar year, który wyciąga rok z daty, i dolar multiply, który mnoży.

Dolar sort przyjmuje jeden dla porządku rosnącego i minus jeden dla malejącego, a nie asc i desc. Przy kilku polach pierwsze decyduje, a drugie rozstrzyga remisy.

Dolar match filtruje jak find, składnią zapytań. Przecinek między warunkami oznacza AND, alternatywę zapisujemy przez dolar or z tablicą warunków, zakres przez dolar gte i dolar lte, a wzorzec przez dolar regex z dolar options i, czyli bez rozróżniania wielkości liter. Dolar match warto dawać na początku potoku, bo zmniejsza liczbę dokumentów i może użyć indeksu.

Dolar addFields dodaje nowe pola albo nadpisuje istniejące i zachowuje wszystkie pozostałe. Tym różni się od dolar project, który zostawia tylko wymienione pola i underscore id. Aliasem dolar addFields jest dolar set. Warunek zapisujemy przez dolar cond z polami if, then i else, co odpowiada CASE WHEN.

Dolar count zlicza dokumenty, które do niego dotarły, i zwraca jeden dokument z nazwanym polem. Argumentem jest napis, na przykład dolar count, dwukropek, w cudzysłowie totalChinese. Nazwa nie może zaczynać się od dolara. Etap dolar count daje jedną liczbę dla całego strumienia, a dolar sum jeden w dolar group daje liczbę dla każdej grupy.

Dolar lookup wykonuje left outer join z inną kolekcją w tej samej bazie. Wymaga czterech pól: from, czyli kolekcja dołączana, localField, czyli pole w kolekcji, na której wołamy aggregate, foreignField, czyli pole w kolekcji z from, oraz as, czyli nazwa nowego pola. Dla komentarzy i filmów localField to movie_id, a foreignField to underscore id. Pole as jest zawsze tablicą, pustą, gdy brak dopasowań. Pojedynczy obiekt daje dopiero dolar unwind.

Dolar out zapisuje wynik potoku do kolekcji, na przykład dolar out, dwukropek, w cudzysłowie properties_by_type. Tworzy kolekcję, jeśli jej nie ma, albo zastępuje istniejącą i usuwa jej dane. Musi być ostatnim etapem, nie łączy się z dolar merge i nie działa w transakcjach. Służy do materializacji wyników.

## Import danych i Map-Reduce

Dane importujemy narzędziem mongoimport: mongoimport, minus minus db równa się customers, minus minus collection równa się clients, minus minus file równa się Customer05.json. Mongoimport uruchamiamy w konsoli systemu, na przykład w cmd.exe, a nie w mongosh. Należy do pakietu MongoDB Database Tools, wydawanego niezależnie od serwera, razem z mongoexport, mongodump i mongorestore. Plik z jedną tablicą JSON wymaga opcji minus minus jsonArray.

Map-Reduce jest przestarzały; potok agregacji daje lepszą wydajność i użyteczność. Polecenie db, kropka, orders, kropka, mapReduce przyjmuje funkcję map z emit, w nawiasie this kropka cust_id i this kropka amount, funkcję reduce z parametrami key i values, zwracającą Array kropka sum z values, oraz opcje query, czyli filtr wstępny, i out, czyli kolekcję wynikową. W przykładzie klient A123 ma sumę siedemset pięćdziesiąt, bo zamówienie ze statusem D odpada w kroku query.

## Indeksy

Indeksy przyspieszają wyszukiwanie, sortowanie i agregacje, szczególnie etapy na początku potoku. MongoDB przechowuje je w B-drzewie. Główna wada: spowalniają zapisy, bo każdy insert i update odświeża wszystkie indeksy, i zajmują miejsce. Tworzy je createIndex, a wyświetla getIndexes.

Indeks na underscore id powstaje automatycznie i zapewnia unikalność. Indeks unikalny: createIndex z email jeden i drugim argumentem unique true. Indeks złożony: createIndex z uzytkownik_id jeden i data minus jeden. Indeks tekstowy: zamiast jedynki napis text. Indeks geoprzestrzenny: wartość 2dsphere. Indeks częściowy: opcja partialFilterExpression, na przykład ze status aktywny. Indeks TTL: createIndex z utworzone jeden i opcją expireAfterSeconds trzy tysiące sześćset, czyli dokumenty znikają po godzinie. TTL działa na jednym polu z datą, nie działa na kolekcjach capped i obciąża bazę przy masowym usuwaniu.

Domyślna nazwa indeksu to pole, podkreślnik i kierunek, na przykład name_-1. Pole osadzone indeksujemy notacją kropkową w cudzysłowie, na przykład location kropka state. W indeksie złożonym dane są grupowane po pierwszym polu, potem po kolejnych. Działa reguła prefiksu: indeks userid jeden, score minus jeden obsłuży zapytanie po samym userid, ale nie po samym score. Indeks na polu z tablicą automatycznie staje się multikey, bez żadnej opcji, i ma osobny wpis dla każdego elementu tablicy.

Indeks wektorowy w Atlasie służy do wyszukiwania podobieństwa semantycznego na podstawie embeddingów. Używa algorytmów ANN, czyli przybliżonego najbliższego sąsiada, na przykład HNSW. Tworzy go createSearchIndex z nazwą vector_index, typem vectorSearch i definicją: type vector, path, numDimensions dwa tysiące czterdzieści osiem, czyli rozmiar wektora, oraz similarity: cosine, euclidean albo dotProduct. Wyświetla go getSearchIndexes, a usuwa dropSearchIndex. Wyszukujemy etapem dolar vectorSearch, który musi być pierwszy, z polami index, path, queryVector, numCandidates i limit; numCandidates musi być co najmniej równe limit. Wynik podobieństwa daje dolar meta vectorSearchScore.
## Do zapamiętania

Walidację dodaje opcja validator z dolar jsonSchema, typ pola podaje bsonType, a additionalProperties false wymaga wpisania underscore id.
ValidationLevel ma wartości strict, moderate i off, a validationAction ma error i warn.
CollMod z pustym validatorem kasuje reguły, a collMod z validationLevel off tylko wyłącza walidację.
Find nie grupuje; explain przy agregacji stoi przed aggregate, a tryb domyślny to queryPlanner.
HAVING to dolar match po dolar group, JOIN to dolar lookup, SELECT INTO to dolar out, a MERGE INTO to dolar merge.
Liczenie w grupie to dolar sum jeden, dolar addToSet zbiera unikalne wartości, a dolar count przyjmuje napis.
Dolar lookup ma from, localField, foreignField i as, a wynik w as jest tablicą; dolar out zastępuje kolekcję i musi być ostatni.
Unikalność daje unique true, TTL daje expireAfterSeconds, multikey powstaje sam, a indeks wektorowy tworzy createSearchIndex.

# 5. MongoDB — replikacja, sharding i kolekcje Time Series

## Replikacja a sharding

Replikacja kopiuje te same dane na kilka serwerów, żeby system przeżył awarię. To wysoka dostępność i redundancja. Sharding dzieli dane na części i rozkłada je na różne serwery. To skalowalność. W replikacji każdy węzeł ma wszystko, w shardingu każdy shard ma tylko kawałek. W produkcji łączy się oba: każdy shard jest zestawem replik.

## Zestaw replik

Replikację realizuje zestaw replik, po angielsku replica set. To grupa procesów mongod, które przechowują ten sam zestaw danych. Uwaga na nazwy: mongod to serwer bazy, mongos to router klastra shardowanego, a mongosh to powłoka kliencka.

Zestaw składa się z kilku węzłów z danymi i opcjonalnie jednego arbitra. Spośród węzłów z danymi dokładnie jeden jest primary i tylko on przyjmuje zapisy. Pozostałe to secondary. Primary zapisuje każdą zmianę w dzienniku operacji, czyli oplogu, a secondary pobierają te wpisy i odtwarzają je u siebie. Replikacja nie skaluje zapisów, bo wszystkie idą do jednego primary.

Domyślnie odczyty też idą do primary, bo domyślny read preference to primary. Można czytać z secondary, ale slajd ostrzega przed opóźnieniem, czyli read lag: dane mogą być lekko nieaktualne.

Write concern w jeden oznacza potwierdzenie samego primary. Write concern w majority czeka, aż zapis trafi na większość węzłów głosujących, i taki zapis nie zostanie wycofany po awarii.

Replikacja chroni przed awarią sprzętu, ale nie przed błędem człowieka: usunięcie kolekcji też się zreplikuje.

## Arbiter, heartbeat i failover

Arbiter uczestniczy w wyborach, ale nie posiada kopii danych i nigdy nie zostaje primary. Na diagramie ma dopisek vote only. Dodaje się go, gdy mamy primary i jeden secondary, a koszty nie pozwalają dodać kolejnego węzła z danymi. Daje trzeci głos potrzebny do większości. Przy dwóch węzłach bez arbitra po awarii primary secondary ma jeden głos z dwóch, więc nie zostanie primary. Do arbitra nie płynie replikacja, tylko heartbeat.

Heartbeat to wzajemne sygnały życia między członkami zestawu, wysyłane co dwie sekundy, służące do wykrywania awarii.

Failover, czyli automatyczne przełączanie awaryjne: gdy primary pada, pozostałe węzły przeprowadzają wybory i jeden z secondary, który zbierze większość głosów, zostaje nowym primary, bez udziału administratora. Mediana czasu wyboru nowego primary przy domyślnych ustawieniach nie powinna przekraczać dwunastu sekund.

## Sharding i skalowanie

Sharding, po polsku fragmentowanie, to metoda dystrybucji danych na wielu komputerach, dla bardzo dużych zbiorów danych i dużej przepustowości. Powody ze slajdu: duża liczba zapytań wyczerpuje procesor, a zestaw roboczy, czyli working set, większy niż RAM przenosi obciążenie na dysk.

Skalowanie pionowe, scale up, to mocniejszy jeden serwer: procesor, RAM, dysk. Ma praktyczne maksimum. Skalowanie poziome, scale out, to więcej serwerów. Może być tańsze, ale kosztem większej złożoności infrastruktury i utrzymania. Sharding to skalowanie poziome.

Klucz shardujący, shard key, to pole lub zestaw pól, według których MongoDB decyduje, na który shard trafi dokument. Dobry klucz ma dużą kardynalność i równomierny rozkład wartości. Klucz rosnący monotonicznie, na przykład data utworzenia, kieruje wszystkie nowe dokumenty na jeden shard, tworząc gorący punkt, hot spot. Pomaga sharding haszowany.

Kolekcję shardujemy poleceniem sh kropka shardCollection, podając w cudzysłowie nazwę bazy kropka nazwa kolekcji, a jako drugi argument dokument klucza, na przykład w klamrach userId, dwukropek, i napis hashed w cudzysłowie.

Balancer automatycznie przenosi zakresy danych, czyli chunki, między shardami, żeby wyrównać rozkład. Zapytanie z kluczem shardującym trafia do jednego sharda, bez klucza mongos rozsyła je do wszystkich i łączy wyniki.

## Klaster shardowany

Klaster shardowany ma trzy komponenty. Shardy przechowują podzbiory danych i są wdrażane jako zestawy replik. Router mongos przyjmuje zapytania aplikacji i kieruje je do shardów. Serwery konfiguracyjne, config servers, przechowują metadane i ustawienia klastra, też jako zestaw replik. Diagram podaje: jeden lub więcej routerów i dwa lub więcej shardów. Aplikacja zawsze łączy się z mongos.

W jednym klastrze mogą być kolekcje shardowane i nieshardowane. Nieshardowana leży w całości na jednym shardzie.

W produkcji jest kilka routerów i wiele shardów, każdy jako primary i dwa secondary, oraz config server jako primary i dwa secondary, żeby nie było pojedynczego punktu awarii. Wersja programistyczna ma jeden mongos i jeden shard.

## Kolekcje Time Series

Kolekcja Time Series to specjalny typ kolekcji dla danych zapisywanych w odniesieniu do czasu: odczytów sensorów, logów, cen akcji. MongoDB grupuje dane według okresów czasu w wiaderka, po angielsku buckets, i przechowuje je w specjalistycznym formacie kolumnowym. Daje to mniejsze rozmiary danych i indeksów, lepszą wydajność zapytań, mniej operacji wejścia i wyjścia i lepsze wykorzystanie cache. MongoDB automatycznie tworzy indeks złożony na metaField i timeField.

Dane szeregów czasowych przychodzą chronologicznie, więc wstawień jest dużo, a aktualizacje i usunięcia są rzadkie. Są indeksowane według czasu i identyfikatora źródła.

Składnia: db kropka createCollection, w nawiasie nazwa w cudzysłowie, na przykład sensor podkreślnik data, i dokument opcji z polem timeseries, małymi literami i razem. W nim timeField, dwukropek, timestamp; metaField, dwukropek, metadata; granularity, dwukropek, seconds. TimeField jest obowiązkowy, a jego wartość musi być typu Date. MetaField jest opcjonalny i opisuje źródło pomiaru, na przykład sensorId i typ sensora. Granularity przyjmuje seconds, minutes albo hours, domyślnie seconds.

Opcja expireAfterSeconds stoi obok timeseries, nie w środku. Osiemdziesiąt sześć tysięcy czterysta sekund to doba.

Kolekcję odpytujemy zwykłymi metodami find, findOne i aggregate.

## Operatory dat i okna

Dolar dateToParts rozkłada datę na rok, miesiąc, dzień, godzinę i dalsze części. Dolar dateTrunc obcina datę do jednostki, na przykład z unit month do pierwszego dnia miesiąca. Dolar dateAdd dodaje czas do daty, a dolar dateDiff zwraca różnicę dwóch dat. Średnią liczy dolar avg z odwołaniem do pola przez dolar, na przykład dolar temp.

Dolar setWindowFields to etap obliczeń w oknie. PartitionBy dzieli dane na niezależne grupy, sortBy ustala kolejność, output definiuje nowe pole. W odróżnieniu od dolar group zachowuje każdy dokument i dopisuje mu wyliczone pole. Window z range minus jeden, current i unit month oznacza miesiąc wstecz od bieżącego dokumentu.

W przykładzie IoT operator dolar integral liczy energię zużytą przez klimatyzator, czyli pole pod wykresem mocy, metodą trapezów. Parametr unit hour sprawia, że kilowaty razy godziny dają kilowatogodziny.

## Listowanie, widoki i usuwanie

Kolekcje szeregów czasowych wylistujesz poleceniem db kropka runCommand z listCollections, dwukropek, jeden, i filtrem type timeseries, albo pomocnikiem db kropka getCollectionInfos z tym samym filtrem.

Widok zmaterializowany tworzy etap dolar merge na końcu potoku, z into, czyli kolekcją docelową, i whenMatched replace, które zastępuje pasujący dokument. Dolar out zastępuje całą kolekcję, a dolar merge scala wyniki.

Automatyczne usuwanie starych dokumentów na istniejącej kolekcji włącza db kropka runCommand z collMod, nazwą kolekcji i expireAfterSeconds. Wyłącza się je napisem off w cudzysłowie.

## Do zapamiętania

Zapisy przyjmuje tylko primary, a secondary kopiują je przez oplog.
Arbiter tylko głosuje, nie ma danych i nigdy nie zostaje primary.
Klaster shardowany to shardy, routery mongos i serwery konfiguracyjne.
Dobry klucz shardujący ma dużą kardynalność i nie rośnie monotonicznie.
Kolekcję Time Series tworzy createCollection z opcją timeseries i obowiązkowym timeField.
Usuwanie wyłącza się napisem off, a widok zmaterializowany zapisuje dolar merge.

# 6. Bazy klucz–wartość i Redis

## Model klucz–wartość

Baza klucz–wartość to najprostszy model NoSQL. Analogią jest tablica asocjacyjna, czyli słownik. Klucz to unikalny identyfikator, na przykład napis albo liczba. Wartość to dowolne dane: tekst, obiekt, lista, liczba. Podstawowe operacje to dodanie, zmiana i usunięcie wartości dla podanego klucza oraz pobranie wartości dla podanego klucza. Każda operacja wymaga znajomości klucza.

Zalety: bardzo prosta architektura, szybki dostęp, czyli niska latencja, i łatwe skalowanie poziome. Ograniczenia: słabo nadaje się do danych o złożonej strukturze i zwykle nie ma zaawansowanych zapytań, zwłaszcza wyszukiwania po wartościach.

Kiedy używać: dane sesyjne, cache aplikacyjny, ustawienia użytkownika, koszyki zakupowe, rankingi i liczniki oraz tokeny i klucze API. Kiedy nie używać: przy złożonych relacjach między encjami, gdy potrzebne są złączenia JOIN, gdy zapytania dotyczą fragmentów wartości zamiast klucza i gdy trzeba filtrować wiele rekordów po wielu polach.

Przedstawiciele ze slajdu: Redis, Valkey, Amazon DynamoDB, Aerospike, Riak KV, Hazelcast, Oracle NoSQL Database i Dragonfly. W rankingu DB-Engines baz klucz–wartość pierwszy jest Redis, a tuż za nim Amazon DynamoDB.

## Klucze, zapytania i dodatkowe funkcje

Klucze mogą być rzeczywistymi identyfikatorami, na przykład e-mailem, PESEL-em albo loginem, albo wartościami generowanymi automatycznie. Auto-inkrementacja ma dwa problemy: z podziałem na klastry serwerów i ze znaczeniem, bo sama liczba nic nie mówi. W praktyce często używa się kluczy złożonych, łączących byty rzeczywiste z datami, identyfikatorami i logami, oraz prefiksów, na przykład film podkreślnik terminator. W Redisie separatorem prefiksu jest dwukropek, na przykład user dwukropek jeden.

Operacje CRUD działają najczęściej dla określonych kluczy, dlatego znajomość konwencji nazewniczej kluczy jest istotna, a uzyskanie listy wszystkich kluczy bywa trudne. Dostęp do części wartości zwykle nie jest możliwy; niektóre systemy dają częściowe indeksowanie wartości. Do przetwarzania wsadowego lub sekwencyjnego służy MapReduce.

Dodatkowe funkcje to wygasanie par, przydatne dla sesji i koszyków, połączenia przez odsyłacze, czyli links, oraz kolekcje wartości, na przykład listy i zbiory.

## Redis: czym jest

Redis to skrót od REmote DIctionary Server. Na jednym rysunku pojawia się słowo Service, ale poprawnie jest Server. Powstał w dwa tysiące dziewiątym roku, autorem jest Włoch Salvatore Sanfilippo. Slajd definiuje go tak: open-source'owa, in-memory baza NoSQL, która działa jako magazyn struktur danych. Dane trzyma głównie w RAM.

Trwałość jest opcjonalna i ma dwa mechanizmy: RDB, czyli okresowe migawki, oraz AOF, czyli Append Only File, dziennik dopisywanych operacji zapisu. Zapis na dysk jest asynchroniczny, według ustalonych zasad.

Struktury danych: String do tekstu, Hash do obiektów, List do kolejek, Set do unikalnych danych, Sorted Set do rankingów, Bitmap do flag, HyperLogLog do liczenia unikalnych gości i Stream do strumieni zdarzeń. Rozszerzalność dają moduły RediSearch, RedisJSON i RedisTimeSeries.

Ograniczenia: wyższe koszty przy dużych zbiorach, bo dane są w RAM, brak języka zapytań typu SQL, ryzyko utraty danych przy złej konfiguracji i to, że Redis nie zastępuje bazy relacyjnej. Replikacja i klastrowanie są zaletą, nie ograniczeniem. W porównaniu Redis trzyma dane głównie w RAM, ma najwyższą szybkość i najprostsze zapytania, a MongoDB i baza relacyjna trzymają dane na dysku.

Slajd „Funkcje Redis” podaje: do stu dziesięciu tysięcy operacji SET na sekundę i do osiemdziesięciu jeden tysięcy operacji GET na sekundę. Dalej: operacje atomowe, replikacja Master/Slave, sharding, czyli fragmentowanie na wiele instancji, i przenośność na systemy POSIX: Linux, BSD, macOS, Solaris.
Architektura ma dwa procesy: klienta, czyli redis-cli, i serwer, czyli redis-server. Mogą działać na jednej albo dwóch maszynach. Domyślny port Redisa to sześć tysięcy trzysta siedemdziesiąt dziewięć.

W typowym wdrożeniu Redis jest warstwą cache przed MySQL. Redis Master obsługuje odczyty i zapisy, Redis Read Replica to kopia tylko do odczytu, która odciąża mastera, a MySQL jest trwałym magazynem.

Redis-py to biblioteka Pythona, a redis.conf to plik konfiguracyjny. Zastosowanie Target Database oznacza Redis jako główną bazę dla aplikacji o niskich opóźnieniach.

## Docker i narzędzia

Obraz pobieramy poleceniem docker pull redis ukośnik redis-stack. Kontener uruchamiamy tak: docker run minus d minus minus name redis-stack minus p sześć tysięcy trzysta siedemdziesiąt dziewięć dwukropek sześć tysięcy trzysta siedemdziesiąt dziewięć minus p osiem tysięcy jeden dwukropek osiem tysięcy jeden redis ukośnik redis-stack dwukropek latest. Minus d to tryb detached, czyli praca w tle. Minus minus name nadaje nazwę. Minus p mapuje port hosta na port kontenera. Port 6379 to serwer Redis, a port 8001 to przeglądarkowy interfejs Redis Insight, dostępny pod adresem localhost dwukropek osiem tysięcy jeden.

Konsolę otwieramy poleceniem docker exec minus it redis-stack redis-cli. Docker run tworzy nowy kontener, docker exec wykonuje polecenie w działającym. Znak zachęty to sto dwadzieścia siedem kropka zero kropka zero kropka jeden dwukropek sześć tysięcy trzysta siedemdziesiąt dziewięć i znak większości.

Typ ReJSON-RL oznacza klucz z dokumentem JSON. Domyślna baza logiczna ma numer zero, a bazę zmienia polecenie SELECT, na przykład SELECT jeden.

## Polecenia do zarządzania kluczami

DEL usuwa klucz, EXISTS sprawdza istnienie, TYPE zwraca typ wartości, MOVE przenosi klucz do innej bazy logicznej. RENAME zmienia nazwę, a RENAMENX tylko wtedy, gdy nowa nazwa nie istnieje. Końcówka NX zawsze znaczy „tylko gdy nie istnieje”.

Wygasanie: EXPIRE ustawia wygaśnięcie po liczbie sekund, PEXPIRE po liczbie milisekund. EXPIREAT ustawia moment jako znacznik czasu UNIX w sekundach, PEXPIREAT w milisekundach. Litera P na początku to milisekundy, końcówka AT to konkretny moment. TTL zwraca pozostały czas w sekundach, PTTL w milisekundach. TTL zwraca minus jeden, gdy klucz nie ma wygaśnięcia, i minus dwa, gdy klucz nie istnieje. PERSIST usuwa wygaśnięcie.

## Typy danych i limity

Pięć podstawowych typów ze slajdu to string, list, set, hash i sorted set, czyli zbiór z rankingiem, na przykład top dziesięć. Klucz i wartość typu string mają limit pięciuset dwunastu megabajtów. Listy, zbiory, hashe i zbiory posortowane mieszczą do dwóch do potęgi trzydziestej drugiej minus jeden elementów, czyli około czterech miliardów. Dobra praktyka nazewnicza to typ obiektu, dwukropek, identyfikator, na przykład auto dwukropek zero zero zero jeden.

## Stringi

String to najprostszy typ: sekwencja bajtów. Może zawierać tekst, zserializowane obiekty i tablice binarne. Zastosowania to cache, liczniki, operacje bitowe i fragmenty HTML.

MSET i MGET ustawiają i pobierają wiele kluczy atomowo. MSETNX ustawia wiele kluczy tylko wtedy, gdy żaden nie istnieje. SETNX ustawia klucz tylko, gdy nie istnieje. GETSET ustawia nową wartość i zwraca starą. GETDEL zwraca wartość i usuwa klucz. GETRANGE zwraca podciąg, STRLEN długość, APPEND dopisuje na końcu i tworzy klucz, gdy go nie ma. SETBIT ustawia bit. INCR zwiększa o jeden, INCRBY o liczbę całkowitą, INCRBYFLOAT o liczbę zmiennoprzecinkową, DECR i DECRBY zmniejszają. Dla nieistniejącego klucza startują od zera, więc dwa razy INCR licznik i GET licznik zwraca dwa.

## SET, GET, MGET i SETEX

Składnia SET: SET klucz wartość, potem opcjonalnie NX albo XX, opcjonalnie GET i opcjonalnie EX sekundy, PX milisekundy, EXAT, PXAT albo KEEPTTL. NX to tylko gdy klucz nie istnieje, XX tylko gdy istnieje, GET zwraca starą wartość, KEEPTTL zachowuje czas życia. SET nadpisuje wartość niezależnie od typu, także listę, i usuwa poprzedni TTL. Przykład: SET anotherkey, w cudzysłowie will expire in a minute, EX sześćdziesiąt. Klucz wygaśnie po minucie.

GET dla nieistniejącego klucza zwraca nil, a dla wartości innej niż string zwraca błąd WRONGTYPE. Po SET mykey Hello i GETDEL mykey kolejne GET mykey zwraca nil. MGET key1 key2 nonexisting zwraca Hello, World i nil. Dla brakującego klucza albo klucza innego typu MGET daje nil na tej pozycji i nigdy nie kończy się błędem.

SETEX klucz sekundy wartość jest równoważne SET klucz wartość EX sekundy. Uwaga na kolejność: w SETEX czas stoi przed wartością. SETEX jest przestarzałe od wersji dwa kropka sześć kropka dwanaście. Po SETEX mykey dziesięć Hello polecenie TTL mykey zwraca dziesięć. PSETEX ma składnię PSETEX klucz milisekundy wartość.

## Listy

Listy to połączone listy wartości typu string, używane do stosów i kolejek. LPUSH dodaje na początek, RPUSH na koniec, LPOP i RPOP zdejmują z początku i końca, LLEN zwraca długość, LTRIM przycina listę, LINDEX czyta po indeksie, LINSERT wstawia BEFORE albo AFTER pivota. LPUSHX dodaje tylko do istniejącej listy.

Ta sama strona to stos, przeciwne strony to kolejka: LPUSH i RPOP dają kolejkę FIFO, LPUSH i LPOP stos LIFO. LPUSH z kilkoma wartościami odwraca kolejność: po LPUSH kolejka zadanie1 zadanie2 polecenie LRANGE kolejka zero minus jeden zwraca zadanie2, zadanie1. Po LPUSH mylist first i RPUSH mylist last wynik to first, last. Zero minus jeden to cała lista. Polecenia z literą B, jak BLPOP i BLMOVE, blokują się na pustej liście do pojawienia się elementu albo upływu limitu czasu. Zdjęcie ostatniego elementu usuwa klucz listy.

## Zbiory

Set to nieuporządkowana kolekcja unikalnych stringów, zwanych members. Służy do unikalnych elementów, na przykład adresów IP, do relacji, na przykład użytkowników z rolą, i do operacji na zbiorach. SADD dodaje, SREM usuwa, SMEMBERS zwraca wszystkich członków, SISMEMBER sprawdza przynależność, SCARD zwraca liczebność. Nie myl SCARD z LLEN dla list. SINTER to część wspólna, SUNION suma, SDIFF różnica, a wersje STORE zapisują wynik pod kluczem docelowym podanym jako pierwszy. SINTERCARD zwraca tylko liczbę elementów części wspólnej. SPOP usuwa losowego członka, SRANDMEMBER tylko go zwraca.
## JSON i JSONPath

Polecenia typu JSON mają prefiks JSON kropka i przyjmują ścieżkę, w której dolar oznacza korzeń dokumentu. JSON.SET ustawia, JSON.GET pobiera, JSON.DEL usuwa, a JSON.FORGET to jego alias. JSON.ARRLEN zwraca długość tablicy, JSON.NUMINCRBY zwiększa liczbę, JSON.NUMMULTBY ją mnoży, JSON.TOGGLE przełącza wartość logiczną, JSON.CLEAR opróżnia tablice i obiekty i zeruje liczby.

Dokument tworzymy tak: JSON.SET bikes dwukropek jeden dolar, a potem w apostrofach cały JSON. Pole zagnieżdżone czytamy przez JSON.GET bikes dwukropek jeden dolar kropka specs kropka material. Napis podajemy w cudzysłowie wewnątrz apostrofów: JSON.SET bikes dwukropek jeden dolar kropka model, apostrof, cudzysłów, Hyperion1, cudzysłów, apostrof. Liczbę podajemy bez cudzysłowów: JSON.SET school_json dwukropek jeden dolar kropka students trzysta czterdzieści trzy. Dolar kropka status_log w nawiasie kwadratowym zero to pierwszy element tablicy, a minus jeden ostatni. JSON.DEL ze ścieżką usuwa jedno pole, bez ścieżki cały dokument.

W JSONPath dwie kropki to zejście rekurencyjne, odpowiednik podwójnego ukośnika w XPath, więc dolar dwie kropki author to wszyscy autorzy. JSONPath indeksuje od zera, XPath od jedynki, więc trzecia książka to dolar dwie kropki book w nawiasie dwa. Ostatnia książka to book w nawiasie minus jeden dwukropek, pierwsze dwie to book w nawiasie dwukropek dwa. Filtr to nawias kwadratowy, znak zapytania i nawias okrągły, a małpa to bieżący element: książki tańsze niż dziesięć to dolar dwie kropki book, nawias, znak zapytania, małpa kropka price mniejsze od dziesięciu.

## Indeksy i zapytania FT

Przestrzeń kluczy jest płaska, a dane są domyślnie dostępne tylko po nazwie klucza. Moduł wyszukiwania dodaje indeksy z prefiksem FT. Indeksowanie odbywa się automatycznie i synchronicznie przy zapisie.

Składnia: FT.CREATE idx dwukropek bikes ON JSON PREFIX jeden, w cudzysłowie bikes dwukropek, SCHEMA, a potem pola: dolar kropka model AS model TEXT NOSTEM SORTABLE, dolar kropka price AS price NUMERIC SORTABLE, dolar kropka type AS type TAG. Liczba po PREFIX to liczba prefiksów. TEXT służy do wyszukiwania pełnotekstowego, NUMERIC do zakresów liczbowych, TAG do dokładnego dopasowania, GEO do położenia. SORTABLE pozwala sortować, NOSTEM wyłącza stemowanie. Dolar kropka type w nawiasie gwiazdka AS type TAG robi z każdego elementu tablicy osobny tag. FT._LIST wypisuje indeksy, FT.INFO pokazuje szczegóły, FT.DROPINDEX usuwa indeks, a dokumenty zostają, chyba że dodamy DD.

FT.SEARCH idx dwukropek bikes, w cudzysłowie małpa type dwukropek, w nawiasach klamrowych eBikes: pole TAG odpytujemy w klamrach. Zakres liczbowy to małpa price dwukropek, w nawiasie kwadratowym dwieście spacja tysiąc dwieście. Spacja między warunkami to AND. Słowo bez nazwy pola, na przykład mudguards, przeszukuje wszystkie pola TEXT. RETURN podaje liczbę argumentów, nie pól: trzy pola z AS to RETURN dziewięć.

FT.AGGREGATE grupuje wyniki. GROUPBY jeden małpa type, REDUCE COUNT zero AS count, SORTBY dwa małpa count DESC liczy rowery w każdej kategorii malejąco. Liczby po GROUPBY, REDUCE i SORTBY to liczby argumentów: COUNT ma zero, AVG jeden. Gwiazdka jako zapytanie oznacza wszystkie dokumenty. APPLY floor od małpa weight AS weight liczy nowe pole, wagę zaokrągloną w dół.

## Transakcje i Redis Stack

MULTI rozpoczyna transakcję, kolejne polecenia dostają odpowiedź QUEUED, EXEC je wykonuje, DISCARD odrzuca. WATCH obserwuje klucze: jeśli ktoś je zmieni przed EXEC, transakcja się nie wykona. To optymistyczne blokowanie. UNWATCH zdejmuje obserwację. Według slajdu polecenia wykonują się sekwencyjnie i w izolacji, a transakcja jest atomowa, ale Redis nie ma rollbacku błędów powstałych w trakcie wykonania.

Vector Similarity Search wyszukuje podobne wektory w danych nieustrukturyzowanych, działa na hashach i JSON i używa algorytmów HNSW i brute-force. Zastosowania to wyszukiwanie semantyczne, rekomendacje i AI: RAG, NLP i CV. Redis for Time Series to natywna struktura szeregów czasowych z agregacją, etykietami, kompaktowaniem i integracją z Prometheusem i Grafaną.

## Do zapamiętania

- Baza klucz–wartość to tablica asocjacyjna; nie nadaje się do JOIN, złożonych relacji i filtrowania po wielu polach.
- Redis to REmote DIctionary Server z dwa tysiące dziewiątego roku, dane w RAM, trwałość przez RDB i AOF, domyślny port 6379, a port 8001 to interfejs przeglądarkowy.
- HyperLogLog liczy unikalnych gości, Sorted Set służy do rankingów, Bitmap do flag.
- TTL zwraca minus jeden bez wygaśnięcia i minus dwa dla braku klucza; litera P to milisekundy, końcówka AT to moment UNIX.
- SET usuwa poprzedni TTL, a SETEX klucz sekundy wartość równa się SET klucz wartość EX sekundy.
- LPUSH z RPOP to kolejka, LPUSH z LPOP to stos, a LRANGE klucz zero minus jeden zwraca całą listę.
- W JSON napis piszemy jako cudzysłów w apostrofach, a JSONPath indeksuje od zera.
- W FT.SEARCH tag piszemy w klamrach, zakres liczb w nawiasach kwadratowych, a RETURN podaje liczbę argumentów.

# 7. Bazy grafowe — Neo4j i SQL Server Graph

## Model danych grafowych

Wykład definiuje graf jako skierowaną albo nieskierowaną kolekcję węzłów, które reprezentują encje, oraz krawędzi, które reprezentują relacje między encjami. Właściwości, czyli atrybuty, mogą mieć zarówno węzły, jak i krawędzie.
Są dwa typy baz grafowych. Transakcyjne, OLTP, to duża liczba małych lub średnich grafów. Analityczne, OLAP, to mała liczba bardzo dużych grafów. Zapamiętaj: OLTP to dużo małych, OLAP to mało dużych.

Zastosowania ze slajdu to sieci społecznościowe, silniki rekomendacyjne, grafy wiedzy, czyli Knowledge Graphs, wykrywanie oszustw, systemy nawigacyjne i analiza zależności. Typowe zapytania to dodanie, zmiana i usunięcie węzła lub krawędzi, wyszukiwanie najkrótszej ścieżki, analiza relacji i zależności, zapytania do podgrafów i nadgrafów oraz wyszukiwanie podobnych obiektów.

Bazy grafowej nie używamy, gdy operacje dotyczą wielu węzłów bądź krawędzi naraz, oraz przy bardzo dużych, złożonych grafach w dużej liczbie, bo graf trudno podzielić między serwery.

Przedstawiciele ze slajdu to Neo4j, ArangoDB, OrientDB i JanusGraph. W rankingu DB-Engines, na wykresie o skali logarytmicznej, prowadzi Neo4j, a tuż pod nim jest Microsoft Azure Cosmos DB.

## Neo4j i język Cypher

Neo4j to natywna baza grafowa. Przechowuje dane w postaci węzłów, relacji i etykiet, a węzły i relacje mają właściwości w postaci par klucz–wartość. Etykieta mówi, do jakiej kategorii należy węzeł, na przykład Osoba albo Produkt. Relacja ma zawsze typ i kierunek.

Językiem zapytań Neo4j jest Cypher, podobny do SQL, ale dostosowany do pracy z grafami. Węzeł piszemy w nawiasach okrągłych, relację w nawiasach kwadratowych między myślnikami, kierunek pokazuje grot strzałki, po dwukropku stoi etykieta węzła albo typ relacji, a w klamrach właściwości. Przykład: nawias okrągły, a, dwukropek, Osoba, klamra, imie, dwukropek, Jan w cudzysłowie, zamknięcie klamry i nawiasu. To węzeł ze zmienną a, etykietą Osoba i właściwością imie. Relacja od a do b brzmi: nawias a, myślnik, nawias kwadratowy, dwukropek, ZNA, zamknięcie nawiasu kwadratowego, myślnik, znak większości, nawias b.

Na infografice jest błąd. Relację utworzono z właściwością od_kiedy równą dwa tysiące dwadzieścia, a zapytanie zwraca b kropka od_kiedy. Wynik to null, bo od_kiedy należy do relacji, a nie do węzła. Poprawnie trzeba nadać relacji zmienną r i zwrócić r kropka od_kiedy.

Infografika porównuje Neo4j z bazami relacyjnymi. W Neo4j połączenia są naturalne i szybkie, a w bazach relacyjnych złożone, bo wymagają JOIN-ów. Wydajność zapytań o relacje w Neo4j jest bardzo wysoka. Według slajdu Neo4j skaluje się poziomo, a bazy relacyjne głównie pionowo. Neo4j najlepiej nadaje się do złożonych relacji i analityki, bazy relacyjne do danych transakcyjnych. Wady Neo4j to słabość przy prostych danych tabelarycznych, wyższe wymagania sprzętowe przy bardzo dużych grafach, mniejsza przydatność do transakcji masowych i konieczność nauki Cyphera. Przykłady rekomendacji ze slajdu to Netflix i Amazon.

## Podstawowe operacje w Cypherze

CREATE tworzy. CREATE, nawias n, dwukropek, Person, klamra, name John, tworzy węzeł. CREATE, nawias a dwukropek Person, myślnik, kwadratowy nawias dwukropek FRIEND, myślnik, strzałka, nawias b dwukropek Person, tworzy dwa nowe węzły i relację FRIEND od a do b. CREATE zawsze tworzy nowe elementy, a MERGE tworzy tylko wtedy, gdy pasującego elementu jeszcze nie ma.

Wyszukiwanie: MATCH, nawias n dwukropek Person, WHERE n kropka name równa się John, RETURN n. Aktualizacja: najpierw MATCH, potem SET n kropka age równa się trzydzieści. Klauzul UPDATE, MODIFY ani ALTER w Cypherze nie ma.

Usuwanie: MATCH, nawias n dwukropek Person, DELETE n. Jeśli węzeł ma relacje, zwykłe DELETE kończy się błędem. Węzeł razem z relacjami usuwa DETACH DELETE n.

## SQL Server Graph

Microsoft wprowadził tabele grafowe, czyli GraphTable, w SQL Server dwa tysiące siedemnaście. Wierzchołki, czyli Nodes, reprezentują obiekty, a krawędzie, czyli Edges, relacje między obiektami. Według diagramu architektury baza danych zawiera graf, a graf jest kolekcją tabel węzłów lub krawędzi. Tabela węzłów ma właściwości, a tabela krawędzi może je mieć albo nie. Kluczowe cechy to dwa typy tabel, rozszerzenie T-SQL o predykat MATCH i brak ograniczeń na liczbę powiązań między wierzchołkami.
Tabelę węzłów tworzy zwykłe CREATE TABLE z klauzulą AS NODE na końcu, na przykład CREATE TABLE Persons, w nawiasie ID INT PRIMARY KEY i Name NVARCHAR sto, AS NODE. Tabelę krawędzi tworzy CREATE TABLE z klauzulą AS EDGE, na przykład CREATE TABLE Friendships, w nawiasie StartDate DATE, AS EDGE. Tabela krawędzi może nie mieć żadnych kolumn: CREATE TABLE friendOf AS EDGE.

System dodaje pseudokolumny. Tabela węzłów ma dolar node_id. Tabela krawędzi ma dolar edge_id oraz dolar from_id i dolar to_id, które przechowują node_id węzła początkowego i końcowego. Wartości mają postać JSON. Krawędzie są skierowane, więc wzajemną znajomość zapisuje się dwiema krawędziami.

Do tabeli węzłów wstawia się dane jak do zwykłej tabeli, bez podawania dolar node_id. Przy wstawianiu do tabeli krawędzi trzeba podać dolar node_id węzłów dla kolumn dolar from_id i dolar to_id, zwykle podzapytaniem SELECT dolar node_id FROM Person WHERE ID równa się jeden.

Predykat MATCH stoi w klauzuli WHERE. Zapis to węzeł, myślnik, krawędź w nawiasie okrągłym, myślnik, znak większości, węzeł. Przykład: WHERE MATCH, nawias, Person, myślnik, nawias z likes, myślnik, strzałka, Restaurant, AND Person kropka name równa się John. Każdy alias z MATCH musi być w FROM, a tabela węzłów użyta dwa razy, jak person1 i person2, dostaje dwa aliasy. Kilka wzorców w jednym MATCH łączy się tylko przez AND, a te same aliasy oznaczają ten sam węzeł.

Zastosowania GraphTable to analiza sieci społecznościowych, mapowanie tras i połączeń, analiza powiązań biznesowych i wykrywanie oszustw. Ograniczenia: tabelą węzłów ani krawędzi nie może być tabela tymczasowa lokalna ani globalna, typ tabeli, zmienna tabelowa, tabela czasowa z wersjonowaniem systemowym ani tabela zoptymalizowana pod kątem pamięci. Kolumn dolar from_id i dolar to_id nie zmienia się przez UPDATE, więc krawędź usuwa się i wstawia nową. Zapytania rozproszone na obiektach grafowych nie są obsługiwane, a pseudokolumny nie mogą być kolumnami sortowania uporządkowanego klastrowanego indeksu columnstore.

## MATCH kontra JOIN i rekomendacja utworów

Slajd Match is more concise than joins pokazuje, że MATCH jest zwięźlejszy niż seria złączeń, ale nie mówi, że szybszy. Każda krawędź we wzorcu zastępuje dwa warunki: person1 kropka dolar node_id równa się manages kropka dolar from_id oraz manages kropka dolar to_id równa się person2 kropka dolar node_id. Dwie krawędzie to cztery warunki.

W przykładzie rekomendacji User1 lubi Song2, Song2 lubią też User3 i User4, a oni lubią Song3, więc system poleca Song3. To filtrowanie kolaboratywne. Model to tabele węzłów UniqueUser i UniqueSong oraz tabela krawędzi Likes z właściwością ListenCount typu BIGINT.

## Do zapamiętania

OLTP to dużo małych grafów, a OLAP to mało bardzo dużych.

Neo4j jest natywną bazą grafową z językiem Cypher, w którym węzły piszemy w nawiasach okrągłych, a relacje w kwadratowych.

Węzła z relacjami nie usuniesz zwykłym DELETE, potrzebne jest DETACH DELETE.

SQL Server ma grafy od wersji dwa tysiące siedemnaście, a tabele tworzy się klauzulami AS NODE i AS EDGE.

Tabela węzłów ma dolar node_id, a tabela krawędzi dolar edge_id, dolar from_id i dolar to_id, których nie zmienia się przez UPDATE.

MATCH jest zwięźlejszy niż złączenia, a każda krawędź zastępuje dwa warunki JOIN.

# 8. Bazy rodziny kolumn — Apache Cassandra i CQL

## Model danych i zastosowania

Bazy rodziny kolumn, po angielsku wide-column stores, mają model o trzech poziomach. Rodzina kolumn, czyli tabela, to kolekcja podobnych wierszy, ale niekoniecznie identycznych. W bazie relacyjnej każdy wiersz ma te same kolumny; tutaj wiersz może mieć tylko te kolumny, które mają wartość. Wiersz to kolekcja kolumn z unikalnym identyfikatorem, czyli kluczem wiersza, i powinien agregować porcję danych odczytywaną razem. Kolumna składa się z nazwy, wartości i potencjalnie metadanych, takich jak timestamp i TTL. Wartość może być skalarna albo być płaską listą, zbiorem lub mapą.

Typowe zapytania to dodanie, zmiana lub usunięcie wiersza oraz wybór wiersza po identyfikatorze albo przez proste przeszukiwanie kolumn. Wykład podkreśla, że to nie są po prostu bazy relacyjne ze zmienną specyfikacją wiersza.

Kiedy używać: blogi i systemy CMS, a z dalszej części wykładu także aplikacje o dużym ruchu, IoT i telemetria. Kiedy nie używać: gdy wymagane są transakcje ze ścisłą spójnością, gdy są złożone zapytania, czyli agregacje typu SUM i AVG oraz złączenia, i gdy schemat bazy może być często zmieniany, bo model jest ściśle dopasowany do zapytań.

Przedstawiciele: Apache Cassandra, ScyllaDB, Apache HBase, Google Bigtable i Azure Cosmos DB z API Cassandry. W rankingu DB-Engines w kategorii Wide Column Stores pierwsze miejsce zajmuje Cassandra, z wynikiem około stu punktów, a HBase ma tendencję malejącą.

## Apache Cassandra: cechy i architektura

Cassandra to rozproszona baza danych dla systemów o wysokiej dostępności, przechowująca dane w modelu szerokich kolumn. Zaprojektowano ją do pracy na wielu serwerach bez pojedynczego punktu awarii. Klaster składa się z równorzędnych węzłów, czyli architektury peer-to-peer: nie ma mastera ani węzłów podrzędnych.

Hierarchia od najmniejszego elementu: wiersz należy do tabeli, dawniej nazywanej column family, tabela do przestrzeni kluczy, czyli keyspace, a przestrzeń kluczy do klastra. Od góry: instancja, przestrzeń kluczy, tabele, wiersze, kolumny.

Cechy ze slajdu: wysoka dostępność, skalowalność pozioma, automatyczna replikacja danych między węzłami, bardzo wysoka wydajność zapisu i architektura peer-to-peer. Drugi slajd z właściwościami wymienia: open-source, wysoka dostępność, skalowalność liniowa, partycjonowanie poziome, czyli sharding, replikacja peer-to-peer, regulowana spójność, czyli tunable consistency, i wsparcie dla MapReduce.

Metryczka: Cassandrę stworzył Facebook, zarządza nią Apache Software Foundation, jest napisana w Javie, a pierwsze wydanie ukazało się w dwa tysiące ósmym roku. Strona projektu to cassandra kropka apache kropka org.

Porównanie z bazami relacyjnymi: Cassandra skaluje się poziomo, bazy relacyjne głównie pionowo. Dostępność w Cassandrze jest bardzo wysoka, w relacyjnych zależy od konfiguracji. Spójność w Cassandrze jest konfigurowalna, tak zwana eventual consistency, w relacyjnych silna, zgodna z ACID. Cassandra służy dużym rozproszonym systemom, bazy relacyjne danym transakcyjnym.

Zastosowania: aplikacje internetowe o dużym ruchu, systemy mobilne, Big Data i analityka, platformy społecznościowe, Internet rzeczy, gry online oraz monitoring i telemetria. Wady: bardziej złożone modelowanie, ograniczone możliwości JOIN, nieoptymalność przy skomplikowanych transakcjach oraz to, że zapytania trzeba zaplanować przed tworzeniem tabel, co prowadzi do denormalizacji. Model danych Cassandry jest oparty na zapytaniach i nie obsługuje relacyjnego modelowania danych.

## Partycjonowanie: klucz partycji, token, Murmur3 i pierścień

Cassandra partycjonuje dane, bo jeden serwer ma trzy problemy: ograniczoną pamięć i przestrzeń dyskową, ryzyko przeciążenia oraz niską dostępność. Cele partycjonowania to równomierne rozłożenie danych w klastrze, skalowanie poziome, eliminacja wąskich gardeł i wysoka dostępność. Kluczowe pojęcia to Partition Key, Token, Hashing, Token Ring i Virtual Nodes.

Każdy rekord ma klucz partycji. W tabeli CREATE TABLE users, z kolumnami user_id typu UUID, login i email typu TEXT, oraz PRIMARY KEY w nawiasie user_id, kluczem partycji jest user_id, bo pierwsza część klucza głównego zawsze jest kluczem partycji. Klucz partycji identyfikuje partycję, określa położenie danych w klastrze i wpływa na wydajność całego systemu. Nie określa natomiast kolejności wierszy wewnątrz partycji.

Cassandra nie przechowuje danych bezpośrednio według klucza. Kolejność jest taka: klucz partycji, funkcja hash, na przykład Murmur3, token, a na końcu węzeł. Na podstawie tokenu wybierany jest serwer przechowujący dane.

Domyślnym partycjonerem jest Murmur3Partitioner, pisane łącznie: Murmur, cyfra trzy, Partitioner. Oblicza hash klucza partycji, generuje sześćdziesięcioczterobitowy token i zapewnia równomierny rozkład danych. Zakres tokenów to od minus dwa do potęgi sześćdziesiątej trzeciej do plus dwa do potęgi sześćdziesiątej trzeciej minus jeden, czyli zakres liczby ze znakiem na sześćdziesięciu czterech bitach. Murmur3 to szybka, niekryptograficzna funkcja haszująca. Nie zachowuje kolejności kluczy, a jej korzyścią jest minimalizacja ryzyka nierównomiernego rozkładu danych, po angielsku data skew. Starsze partycjonery to RandomPartitioner oparty na MD5 i ByteOrderedPartitioner.

Tokeny tworzą logiczny pierścień, Token Ring, a każdy węzeł odpowiada za określony zakres tokenów. Właściwości pierścienia: brak centralnego koordynatora, łatwe dodawanie nowych węzłów i równomierne obciążenie. Przykład ze slajdu: Node A ma tokeny od zera do stu, Node B od stu jeden do dwustu, Node C od dwustu jeden do trzystu. Token sto czterdzieści pięć trafia na Node B.

## Partycja, kolumny grupujące i złożony klucz partycji

Partycja to zbiór wszystkich wierszy o tym samym kluczu partycji. Przykład: tabela sensor_data z kolumnami sensor_id TEXT, timestamp TIMESTAMP, value DOUBLE i PRIMARY KEY w nawiasie sensor_id, przecinek, timestamp. Tu sensor_id to Partition Key i określa lokalizację danych, a timestamp to Clustering Column, czyli kolumna grupująca, i określa kolejność danych wewnątrz partycji. Klucz partycji mówi gdzie, kolumna grupująca mówi w jakiej kolejności. Cały klucz główny identyfikuje wiersz, więc gdyby kluczem był sam sensor_id, każdy nowy pomiar nadpisywałby poprzedni.

Złożony klucz partycji, Composite Partition Key, stosuje się, gdy jeden atrybut powoduje zbyt dużą partycję. Zapis: PRIMARY KEY, nawias, nawias, customer_id, przecinek, month, zamknięcie nawiasu, przecinek, order_date, zamknięcie nawiasu. Wewnętrzny nawias oznacza, że kluczem partycji jest para customer_id i month, a order_date jest kolumną grupującą. Korzyści: mniejsze partycje, lepsze rozłożenie danych i szybsze zapytania.

Przykład złego projektu, Bad Design: PRIMARY KEY w nawiasie sensor_type, timestamp, gdzie sensor_type to na przykład temperature. Miliony rekordów trafiają wtedy do jednej partycji. Konsekwencje dużej partycji: przeciążony węzeł, długie odczyty i większe zużycie pamięci.

## Węzły wirtualne i dobre praktyki klucza partycji

Węzły wirtualne, Virtual Nodes, w skrócie vnodes, według slajdu stosowane od Cassandry dwa x, polegają na tym, że fizyczny węzeł przechowuje wiele małych zakresów tokenów zamiast jednego dużego. Korzyści: prostsze skalowanie, szybsze rebalansowanie klastra i bardziej równomierne obciążenie. Po dodaniu nowego węzła Cassandra automatycznie przenosi część tokenów, redystrybuuje dane i zachowuje dostępność. Ten proces nazywa się Rebalancing.

Dobre praktyki klucza partycji: wysoka kardynalność, czyli dużo różnych wartości, równomierny rozkład wartości, ograniczona wielkość partycji i modelowanie pod konkretne zapytania. Unikamy bardzo dużych partycji, niewielkiej liczby kluczy, częstych hotspotów i projektowania jak w relacyjnych bazach danych. Według podsumowania najczęstszy problem projektowy to Hot Partition, czyli gorąca partycja. Hasło wykładu: w Cassandrze wydajność systemu zależy przede wszystkim od poprawnego zaprojektowania klucza partycji.

## Modelowanie danych: najpierw zapytania

Najważniejsze zdanie tej części: w Cassandrze najpierw projektuje się zapytania, a dopiero później tabelę. Porównanie w czterech parach: w SQL od modelu danych do zapytań, w Cassandrze od zapytań do modelu danych; w SQL normalizacja, w Cassandrze denormalizacja; w SQL JOIN, w Cassandrze brak JOIN; w SQL zapytania elastyczne, w Cassandrze zaprojektowane wcześniej.

Query-Driven Design wymaga, by przed utworzeniem tabel określić: jakie dane będą odczytywane, jak często, po jakich polach będą wyszukiwane i jakie są wymagania wydajnościowe. Proces: Business Question, Query, Data Model, Table. Cassandra ogranicza JOIN, GROUP BY na dużą skalę, złożone relacje i zapytania ad-hoc na wszystkich danych.

Przykład: pokaż pomiary czujnika z ostatnich dwudziestu czterech godzin. Zapytanie: SELECT gwiazdka FROM sensor_data WHERE sensor_id równa się znak zapytania AND timestamp większe lub równe znak zapytania AND timestamp mniejsze lub równe znak zapytania. Wzorzec idealnego zapytania to równość na kluczu partycji i zakres na kolumnie grupującej.

Denormalizacja według wykładu to celowe powielenie danych dla szybszych odczytów. Ta sama informacja może być w wielu tabelach. Każda tabela obsługuje jeden wzorzec odczytu: orders_by_customer, orders_by_status, orders_by_product. Różne zapytania to różne tabele, nie ma jednej uniwersalnej tabeli. Gdy pojawia się nowe ważne zapytanie, na przykład po product_id, którego nie ma w kluczu, zwykle tworzy się nową tabelę, tu orders_by_product.

Dobry model e-commerce, orders_by_customer z kolumnami customer_id, order_date i amount, daje szybki odczyt, dobrą skalowalność i małe partycje. Zły model to klucz country równy POLAND: Hot Partition, czyli przeciążenie, wolniejsze zapytania i hotspot. Pięć zasad modelowania: projektuj pod zapytania, dobierz właściwy Partition Key, używaj Clustering Columns, denormalizuj dane i unikaj dużych partycji.

Najczęstsze błędy modelowania: projektowanie jak w Oracle, próba używania JOIN, używanie ALLOW FILTERING, zbyt duże partycje, niska kardynalność klucza partycji i jedna tabela do wszystkiego. Cykl projektowania: Business Requirement, Query, Partition Key, Clustering Column, Table i Validation.

## Model danych: przestrzeń kluczy, wartości i kolekcje

Przestrzeń kluczy odpowiada bazie danych. Schemat tabeli musi być podany, ale może być modyfikowany później, a wiersze nie muszą mieć tych samych kolumn. Każdy wiersz identyfikuje wymagany klucz główny.

Kolumna może być pusta, czyli null, może zawierać wartość atomową albo kolekcję. Do wartości atomowych wykład zalicza typy natywne, krotki i typy definiowane przez użytkownika, czyli UDT. Kolekcje to listy, zbiory i mapy. Zagnieżdżone krotki, UDT i kolekcje są dozwolone tylko w trybie frozen, czyli zamrożonym: wartość zapisuje się i zmienia w całości.

Lista jest uporządkowana pozycyjnie i dopuszcza duplikaty. Zbiór ma unikalne wartości, wewnętrznie uporządkowane. Mapa ma unikalne klucze, a pary są uporządkowane według kluczy. Literały: krotka w nawiasach okrągłych, lista w nawiasach kwadratowych, zbiór w klamrach z samymi wartościami, mapa w klamrach z parami klucz dwukropek wartość. Wartość UDT też jest w klamrach, ale nazwa pola stoi bez apostrofów, na przykład klamra, dlugosc dwukropek sto, zamknięcie klamry.

Metadane to TTL, czyli Time-to-live, w sekundach, po którym kolumna lub element kolekcji jest automatycznie niszczony, oraz timestamp ostatniej modyfikacji, nadawany automatycznie lub ręcznie. Metadane mogą być przedmiotem zapytań, ale nie dotyczy to kolekcji i ich elementów. Funkcja now zwraca bieżący timeuuid, a toTimeStamp, nawias, now, nawias, nawias zamienia go na timestamp.

## Narzędzia, CQL i przestrzeń kluczy

CQLSH to interaktywna konsola, uruchamiana jako bin, ukośnik, cqlsh. Sterowniki klienckie dostarcza społeczność dla wielu języków, między innymi Javy, Pythona, Ruby, PHP, C plus plus, Scali i Erlanga. CQL, Cassandra Query Language, to deklaratywny język zapytań zainspirowany przez SQL. Do DDL wykład zalicza CREATE KEYSPACE i CREATE TABLE, a do DML SELECT, INSERT, UPDATE i DELETE.

Składnia: CREATE KEYSPACE, opcjonalnie IF NOT EXISTS, nazwa, WITH, a potem opcje łączone słowem AND. Opcja replication jest obowiązkowa. Przykład: CREATE KEYSPACE filmydb WITH replication równa się, klamra, w apostrofach class, dwukropek, w apostrofach SimpleStrategy, przecinek, w apostrofach replication_factor, dwukropek, trzy, zamknięcie klamry. Replication jest mapą, nie listą. SimpleStrategy ma jeden poziom replikacji dla całego klastra. NetworkTopologyStrategy pozwala ustawić indywidualny poziom replikacji dla każdego centrum danych.

USE nazwa zmienia aktualnie używaną przestrzeń kluczy. DROP KEYSPACE usuwa przestrzeń kluczy wraz ze wszystkimi tabelami i danymi. ALTER KEYSPACE modyfikuje jej opcje, na przykład replikację.

## Tabele i klucze główne

Każda tabela musi mieć dokładnie jeden klucz główny, a poza nim żadna kolumna nie jest wymagana. Klucz główny składa się z obowiązkowego klucza partycjonującego, minimum jednej kolumny, oraz opcjonalnych kolumn grupujących, które definiują kolejność wierszy w partycji.

Definicja na poziomie kolumny, na przykład id TEXT PRIMARY KEY, oznacza, że ta kolumna jest kluczem partycjonującym i nie ma kolumn grupujących. Definicja na poziomie tabeli: pierwsza kolumna albo kolumny w wewnętrznym nawiasie okrągłym tworzą klucz partycjonujący, a reszta to kolumny grupujące. Trzy warianty: PRIMARY KEY w nawiasie a, kluczem partycji jest a. PRIMARY KEY w nawiasie a, b, c, kluczem partycji jest samo a, a b i c to kolumny grupujące. PRIMARY KEY, nawias, nawias a, b, zamknięcie, przecinek c, kluczem partycji jest para a i b, a c jest kolumną grupującą. Slajd mówi błędnie o nawiasach klamrowych, ale poprawne są wewnętrzne nawiasy okrągłe.

Klauzula WITH CLUSTERING ORDER BY, nawias, last_update_timestamp DESC, zamknięcie, stojąca po nawiasie definicji tabeli, ustala malejący porządek przechowywania wierszy w partycji, czyli najnowsze na początku.

DROP TABLE usuwa tabelę wraz z danymi. TRUNCATE zachowuje tabelę, ale usuwa jej dane. ALTER TABLE umożliwia zmianę, dodanie bądź usunięcie kolumn; kolumn klucza głównego zmienić się nie da.

## Typy danych

Liczby całkowite ze znakiem: tinyint na jednym bajcie, smallint na dwóch, int na czterech i bigint na ośmiu. Varint to liczba całkowita, decimal to liczba rzeczywista; slajd mówi o ustalonej precyzji, dokumentacja o zmiennej. Float ma cztery bajty, double osiem. Boolean przyjmuje true i false.

Text i varchar to synonimy w kodowaniu UTF-8, ascii to kodowanie ASCII. Literał tekstowy zapisuje się w pojedynczych apostrofach, a nie w cudzysłowie, bo cudzysłów służy do identyfikatorów. Są też date, time i timestamp.

Counter to ośmiobajtowa liczba całkowita ze znakiem, która wspiera tylko inkrementację i dekrementację, na przykład SET wyswietlenia równa się wyswietlenia plus jeden. Restrykcje: licznik nie może być częścią klucza głównego; albo wszystkie kolumny poza kluczem głównym są licznikami, albo żadna; TTL nie jest dla liczników wspierany.

Blob to dane binarne, inet to adres IP w wersji cztery lub sześć, uuid to unikalny identyfikator, a timeuuid to UUID ze znacznikiem czasu.

Deklaracje: krotka to TUPLE, ostry nawias, TEXT, przecinek, TEXT, zamknięcie, a literał w nawiasie okrągłym, na przykład w apostrofach Numer, przecinek, w apostrofach sto dwadzieścia trzy, myślnik, czterysta pięćdziesiąt sześć, myślnik, siedemset osiemdziesiąt dziewięć. Zbiór to SET, ostry nawias, typ, zamknięcie. Lista to LIST z jednym typem. Mapa to MAP, ostry nawias, typ klucza, przecinek, typ wartości, zamknięcie, na przykład aktorzy MAP, ostry nawias, TEXT, przecinek, TEXT. Typ użytkownika tworzy się poleceniem CREATE TYPE szczegoly, nawias okrągły, dlugosc SMALLINT, przecinek, adnotacja TEXT, zamknięcie. UDT może być frozen, zapisywany jako FROZEN, ostry nawias, szczegoly, zamknięcie. Różnica: krotka ma pozycje bez nazw, UDT ma nazwane pola.

## SELECT

SELECT wybiera wiersze z pojedynczej tabeli; złączenie wielu tabel nie jest możliwe. Kolejność klauzul: SELECT, FROM, opcjonalnie WHERE, GROUP BY, ORDER BY, LIMIT, a na samym końcu ALLOW FILTERING. Poprawne jest więc SELECT gwiazdka FROM filmy WHERE id równa się, w apostrofach, hobbit, LIMIT jeden, a ALLOW FILTERING stawia się dopiero po LIMIT.

FROM wskazuje jedną tabelę, opcjonalnie z prefiksem przestrzeni kluczy i kropką. W WHERE relacje łączy się wyłącznie przez AND; OR nie istnieje. Zasadniczo wolno używać tylko kolumn klucza głównego, chyba że istnieją pomocnicze struktury indeksujące. Na kluczu partycji dozwolona jest równość i IN, zakresy stosuje się na kolumnach grupujących.

Relacje: porównania równa się, różne od, mniejsze, mniejsze lub równe, większe lub równe i większe; poprawny zapis większe lub równe to znak większości i równa się, a nie odwrotnie, jak w literówce na slajdzie. IN z listą w nawiasie okrągłym, na przykład id IN, nawias, w apostrofach hobbit, przecinek, w apostrofach tombraider. CONTAINS działa dla list, zbiorów i map, a w mapie sprawdza wartości. CONTAINS KEY działa tylko dla map i sprawdza klucze.

W liście wyników gwiazdka oznacza wszystkie kolumny, AS definiuje alias, na przykład SELECT tytul AS nazwa, a DISTINCT usuwa powielone wiersze. Selektorami mogą być też COUNT gwiazdka, WRITETIME kolumny i TTL kolumny. WRITETIME zwraca czas modyfikacji, a TTL pozostały czas życia kolumny. Według slajdu nie mogą być użyte na kolekcji i jej elementach ani w innych klauzulach, na przykład w WHERE.

ORDER BY dopuszcza tylko uporządkowania wyznaczane przez kolumny grupujące. Dla tabeli sensor_data poprawne jest SELECT gwiazdka FROM sensor_data WHERE sensor_id równa się, w apostrofach, sensor01, ORDER BY timestamp DESC LIMIT dziesięć. Błędne byłoby ORDER BY value albo LIMIT przed ORDER BY.

GROUP BY dopuszcza tylko kolumny klucza głównego. Gdy w SELECT wymienimy kolumnę spoza grupowania i bez agregacji, zawsze zostanie zwrócona pierwsza wartość z grupy. Natywne agregacje to COUNT, MIN, MAX, SUM i AVG, a do tego agregaty definiowane przez użytkownika. COUNT kolumny liczy wartości z pominięciem null, a COUNT gwiazdka liczy wiersze.

Domyślnie dozwolone są tylko zapytania niefiltrujące, w których liczba wierszy przeczytanych jest w przybliżeniu równa liczbie zwróconych; mają przewidywalną złożoność. ALLOW FILTERING umożliwia częściowe filtrowanie, czyli czytanie większej liczby wierszy niż zwracana. Zapytanie WHERE rok równa się dwa tysiące jedenaście AND gatunki CONTAINS komedia na tabeli z kluczem id wymaga indeksów pomocniczych albo ALLOW FILTERING.

## INSERT, UPDATE i DELETE

INSERT, gdy wiersz o danym kluczu głównym już istnieje, aktualizuje go. To upsert, bez błędu duplikatu. Nazwy kolumn trzeba zawsze podać jawnie, a wartości co najmniej dla kolumn klucza głównego. Składnia: INSERT INTO tabela, nawias z listą kolumn, VALUES, nawias z wartościami, opcjonalnie IF NOT EXISTS i opcjonalnie USING. IF NOT EXISTS wstawia wiersz tylko wtedy, gdy jeszcze nie istnieje; to transakcja lekka.

Przykład z wszystkimi literałami: INSERT INTO filmy, nawias, id, rezyser, aktorzy, gatunki, zamknięcie, VALUES, nawias, w apostrofach zielonamila, krotka w okrągłym nawiasie z frank i Darabont, mapa w klamrach z hanks dwukropek Tom, lista w kwadratowym nawiasie z komedia i dramat, zamknięcie, i na końcu USING TTL osiemdziesiąt sześć tysięcy czterysta. To jedna doba w sekundach.

UPDATE też jest upsertem: jeśli wiersza nie ma, zostanie dodany. Klauzula WHERE musi zawierać co najmniej wszystkie kolumny klucza głównego. Składnia: UPDATE, tabela, opcjonalnie USING, SET, przypisania, WHERE. W UPDATE USING stoi po nazwie tabeli, przed SET, a w INSERT na końcu, po VALUES.

Przypisania: cała kolumna, czyli nazwa równa się wartość; element mapy lub listy w nawiasie kwadratowym, na przykład aktorzy, nawias kwadratowy, w apostrofach norris, równa się, w apostrofach Chuck, co zmienia tylko ten wpis mapy; pole UDT po kropce, na przykład wlasciwosci kropka dlugosc równa się dziewięćdziesiąt dziewięć. Indeksy listy liczy się od zera, więc gatunki, nawias kwadratowy, jeden, to drugi element, a pozycja musi istnieć.

Kolekcje zmienia się plusem i minusem. Gatunki równa się gatunki plus lista dopisuje na końcu, a gatunki równa się, kwadratowy nawias z dramat, plus gatunki dopisuje na początku. Z mapy odejmuje się zbiór kluczy: aktorzy równa się aktorzy minus klamra, w apostrofach vicander, przecinek, w apostrofach west, zamknięcie klamry. Zawsze kolumna minus wartości.

Parametry po USING to TTL w sekundach oraz TIMESTAMP, łączone przez AND. TTL równe zero, null albo brak oznacza wartość trwałą. Parametry wpływają tylko na nowo dodane lub aktualizowane wartości.

DELETE usuwa cały wiersz, wybrane kolumny albo elementy kolekcji i pola UDT. DELETE FROM filmy WHERE id równa się hobbit usuwa wiersz. DELETE gatunki FROM filmy i tak dalej usuwa kolumnę. DELETE aktorzy, nawias kwadratowy, w apostrofach jet, zamknięcie, FROM filmy WHERE id równa się niezniszczalni usuwa jeden wpis mapy.

## Do zapamiętania

1. Tabela w bazie rodziny kolumn to kolekcja podobnych, ale niekoniecznie identycznych wierszy, a liderem DB-Engines jest Cassandra.
2. Cassandra to równorzędne węzły peer-to-peer bez pojedynczego punktu awarii, stworzona przez Facebook, w Javie, w dwa tysiące ósmym.
3. Ścieżka danych to klucz partycji, Murmur3Partitioner, sześćdziesięcioczterobitowy token od minus dwa do sześćdziesiątej trzeciej do dwa do sześćdziesiątej trzeciej minus jeden, i węzeł na pierścieniu.
4. Klucz partycji decyduje o położeniu danych, kolumna grupująca o kolejności w partycji; złożony klucz partycji pisze się w wewnętrznym nawiasie okrągłym.
5. Projektujemy od zapytań, denormalizujemy, jedna tabela obsługuje jeden wzorzec odczytu, a najczęstszy problem to Hot Partition.
6. CREATE KEYSPACE wymaga opcji replication; SimpleStrategy ma jeden współczynnik, NetworkTopologyStrategy osobny dla każdego centrum danych.
7. Literały: krotka w okrągłych, lista w kwadratowych, zbiór w klamrach, mapa w klamrach z dwukropkami, UDT w klamrach z nazwami pól.
8. Counter tylko inkrementuje i dekrementuje, nie jest w kluczu głównym, nie miesza się ze zwykłymi kolumnami i nie ma TTL.
9. SELECT działa na jednej tabeli, WHERE łączy tylko AND, ORDER BY tylko po kolumnach grupujących, a ALLOW FILTERING stoi na końcu.
10. INSERT i UPDATE to upsert; USING stoi w INSERT na końcu, a w UPDATE przed SET.
