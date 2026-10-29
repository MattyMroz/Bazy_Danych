# Big Data – test 1 (40 pytań ABCD)

Jedna poprawna odpowiedź w każdym pytaniu. Klucz z krótkim uzasadnieniem jest na końcu pliku, więc nie przewijaj za daleko.

Zakres: Wykład 1 (Big Data, Hadoop, HDFS, Hive), Wykład 2 (MLlib), Wykład 3 (rekomendacje), Wykład 4 (Kafka, Spark Streaming).

---

## Część I – Big Data, Hadoop, HDFS

**1.** Model 3V opublikowany przez META Group w 2001 r. obejmuje:
- A) Volume, Velocity, Variety
- B) Volume, Value, Validity
- C) Velocity, Visualization, Value
- D) Variety, Validity, Visualization

**2.** Jaka część światowych danych według wykładu nie ma jasno zdefiniowanej struktury?
- A) ok. 20%
- B) ok. 50%
- C) ok. 80%
- D) ok. 99%

**3.** Do którego zastosowania Hadoop się NIE nadaje?
- A) równoległego przetwarzania petabajtów danych
- B) przetwarzania transakcyjnego i dostępu do danych z małym opóźnieniem
- C) przechowywania danych nieustrukturyzowanych
- D) skalowania przez dokładanie kolejnych węzłów

**4.** Domyślny rozmiar bloku w HDFS to:
- A) 4 KB
- B) 64 MB
- C) 256 MB
- D) 128 MB

**5.** Co robi NameNode?
- A) przechowuje bloki danych i okresowo raportuje swój stan
- B) wykonuje zadania Map i Reduce
- C) zarządza metadanymi klastra, zna mapowanie bloków na DataNode'y i trzyma obraz przestrzeni nazw w RAM
- D) przydziela zasoby CPU aplikacjom Spark

**6.** Przy replikacji równej 3 HDFS rozmieszcza repliki bloku tak:
- A) wszystkie trzy w jednym racku, żeby skrócić transfer
- B) każda replika w innym racku
- C) pierwsza i druga na tym samym węźle, trzecia w innym racku
- D) pierwsza w jednym racku, druga na losowym węźle w innym racku, trzecia na innym węźle w tym samym racku co druga

**7.** Które polecenie kopiuje plik z lokalnego systemu plików do HDFS?
- A) `hdfs dfs -get plik.txt /dane`
- B) `hdfs dfs -put plik.txt /dane`
- C) `hdfs dfs -copyToLocal plik.txt /dane`
- D) `hdfs dfs -getmerge plik.txt /dane`

**8.** Co robi opcja `-w` w poleceniu `hadoop fs -setrep -w 3 /plik`?
- A) zmienia replikację rekurencyjnie dla całego drzewa katalogów
- B) wyświetla tylko obecny poziom replikacji
- C) blokuje polecenie do czasu osiągnięcia nowego poziomu replikacji
- D) zapisuje plik ponownie na nowych węzłach

**9.** Hadoop w porównaniu z relacyjnym RDBMS charakteryzuje się tym, że:
- A) schemat jest stosowany dopiero przy odczycie, a zapisy danych są szybkie
- B) schemat musi być zdefiniowany przed zapisem danych
- C) jest przeznaczony głównie do zadań transakcyjnych
- D) obsługuje wyłącznie dane o dobrze zdefiniowanej strukturze

---

## Część II – Hive i HiveQL

**10.** Moduł Hive został opracowany przez:
- A) Yahoo
- B) LinkedIn
- C) Facebook
- D) Google

**11.** Czym różni się HiveQL od Pig Latin?
- A) oba są językami przepływu danych
- B) HiveQL jest deklaratywny, a Pig Latin to język przepływu danych
- C) HiveQL to język przepływu danych, a Pig Latin jest deklaratywny
- D) oba są Turing-zupełne bez żadnych rozszerzeń

**12.** W jakiej bazie Hive Metastore przechowuje domyślnie metadane?
- A) Apache Derby
- B) MySQL
- C) HBase
- D) PostgreSQL

**13.** Jaka jest konsekwencja podejścia Schema-on-Read w Hive?
- A) ładowanie jest wolne, a zapytania szybkie
- B) dane niezgodne ze schematem są odrzucane przy ładowaniu
- C) dla jednych danych można użyć tylko jednego schematu
- D) ładowanie danych jest szybkie, a zapytania wolniejsze

**14.** Co się stanie po wykonaniu `DROP TABLE` na tabeli zewnętrznej (EXTERNAL)?
- A) zostaną usunięte dane i metadane
- B) zostaną usunięte tylko metadane, a dane zostaną na miejscu
- C) zostaną usunięte tylko dane, a metadane zostaną
- D) Hive zgłosi błąd, bo tabel zewnętrznych nie można usuwać

**15.** Która instrukcja poprawnie tworzy tabelę z pliku tekstowego, w którym pola są rozdzielone przecinkami?
- A) `CREATE TABLE t (a INT, b STRING) FIELDS DELIMITED BY ',' AS TEXTFILE;`
- B) `CREATE TABLE t (a INT, b STRING) STORED AS ',' DELIMITED;`
- C) `CREATE TABLE t (a INT, b STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;`
- D) `CREATE TABLE t (a INT, b STRING) ROW DELIMITED ',' FORMAT TEXT;`

**16.** Skąd pochodzi plik wczytywany poleceniem `LOAD DATA LOCAL INPATH '/home/u/dane.csv' INTO TABLE t;`?
- A) z HDFS
- B) z Metastore
- C) z innej tabeli Hive
- D) z lokalnego systemu plików

**17.** Gdzie według wykładu mogą występować podzapytania w HiveQL?
- A) tylko w klauzuli FROM i muszą mieć nadaną nazwę (alias)
- B) tylko w klauzuli WHERE
- C) w dowolnym miejscu, bez ograniczeń
- D) HiveQL nie obsługuje podzapytań

**18.** Czym różni się `ORDER BY` od `SORT BY` w Hive?
- A) niczym, to synonimy
- B) `ORDER BY` sortuje lokalnie w każdym reducerze, `SORT BY` sortuje globalnie
- C) `ORDER BY` sortuje globalnie przez jeden reducer, `SORT BY` sortuje w obrębie każdego z wielu reducerów
- D) `SORT BY` działa tylko na tabelach ORC

**19.** Którym parametrem przełącza się silnik wykonawczy Hive między Tez a MapReduce?
- A) `SET mapreduce.engine=tez;`
- B) `SET hive.execution.engine=tez;`
- C) `USE ENGINE tez;`
- D) `SET hive.dag.enabled=true;`

**20.** Która funkcja zamienia liczbę sekund od epoki Unix na tekst w formacie `yyyy-MM-dd HH:mm:ss`?
- A) `from_unixtime()`
- B) `unix_timestamp()`
- C) `to_date()`
- D) `date_add()`

**21.** Do czego w przykładzie z gatunkami filmów (kobiety i mężczyźni) posłużyła konstrukcja `LATERAL VIEW explode(map(...)) tf AS key, value`?
- A) do połączenia tabel users i ratings
- B) do podziału tabeli na partycje
- C) do skompresowania wyników do formatu ORC
- D) do zamiany wielu kolumn na wiersze w postaci klucz–wartość

**22.** Dla kolumny `A` typu ARRAY z elementami `['a', 'b', 'c']` wyrażenie `A[1]` zwróci:
- A) `'a'`
- B) `'b'`
- C) `'c'`
- D) błąd, bo indeksy zaczynają się od 1 i trzeba użyć `A(1)`

---

## Część III – Spark MLlib (klasyfikacja)

**23.** Które zdanie poprawnie opisuje Estimator i Transformer w `pyspark.ml`?
- A) Transformer ma metodę `fit()`, która zwraca Estimator
- B) oba mają wyłącznie metodę `evaluate()`
- C) Estimator ma metodę `transform()`, która zwraca metryki
- D) Estimator ma metodę `fit()`, która zwraca Transformer, a Transformer ma metodę `transform()`, która zwraca nowy DataFrame

**24.** Który z tych elementów jest transformerem, czyli nie uczy się z danych i nie wymaga `fit()`?
- A) `VectorAssembler`
- B) `StringIndexer`
- C) `StandardScaler`
- D) `RandomForestClassifier`

**25.** Co oznacza liczba `42` w wywołaniu `df.randomSplit([0.7, 0.3], 42)`?
- A) liczbę partycji
- B) seed generatora losowego
- C) maksymalną liczbę iteracji
- D) procent danych testowych

**26.** Precision (precyzja) jest liczona jako:
- A) TP / (TP + FN)
- B) (TP + TN) / wszystkie przykłady
- C) TP / (TP + FP)
- D) 2·P·R / (P + R)

**27.** Jaką wartość `metricName` w `MulticlassClassificationEvaluator` użyto na wykładzie do obliczenia ważonego F1?
- A) `"weightedF1Score"`
- B) `"fMeasureWeighted"`
- C) `"harmonicMean"`
- D) `"weightedFMeasure"`

**28.** Ile konfiguracji sprawdzi Grid Search dla siatki `numTrees: [10, 50, 100]` i `maxDepth: [5, 10, 20]`?
- A) 3
- B) 6
- C) 9
- D) 27

**29.** Jak działa `CrossValidator` przy k = 3?
- A) tworzy 3 pary (trening, test), każda używa 2/3 danych do treningu i 1/3 do testu, a każdy fold jest testowy dokładnie raz
- B) trenuje 3 modele na tych samych danych i wybiera najszybszy
- C) dzieli dane raz w proporcji 3:1
- D) losuje 3 hiperparametry bez podziału danych

---

## Część IV – Systemy rekomendacyjne

**30.** Która cecha opisuje collaborative filtering?
- A) wymaga metadanych elementów, takich jak gatunek, reżyser czy obsada
- B) rekomenduje te same filmy wszystkim użytkownikom o podobnej demografii
- C) korzysta jednocześnie z podobieństw między użytkownikami i elementami i nie potrzebuje metadanych
- D) porównuje tylko opisy fabuły za pomocą TF-IDF

**31.** Jaka jest kolejność etapów w typowej architekturze systemu rekomendacyjnego?
- A) Scoring → Candidate Generation → Re-ranking
- B) Candidate Generation → Scoring → Re-ranking
- C) Re-ranking → Scoring → Candidate Generation
- D) Candidate Generation → Re-ranking → Scoring

**32.** Co oznacza symbol $C$ we wzorze na ważoną ocenę $WR = \frac{v}{v+m}R + \frac{m}{v+m}C$?
- A) liczbę głosów oddanych na film
- B) minimalną liczbę głosów wymaganą do zestawienia
- C) średnią ocenę danego filmu
- D) średnią ocenę w całym zestawieniu

**33.** Co robi parametr `coldStartStrategy="drop"` w `ALS`?
- A) usuwa z wyniku wiersze z wartościami NaN w predykcjach, żeby metryka była poprawna
- B) usuwa użytkowników, którzy ocenili mniej niż 20 filmów
- C) wyłącza regularyzację
- D) przerywa trening po pierwszej iteracji

**34.** Co zwraca wywołanie `model.recommendForAllUsers(3)`?
- A) 3 użytkowników, którym najbardziej spodoba się każdy film
- B) 3 najlepiej oceniane filmy w całym zbiorze
- C) 3 rekomendowane filmy dla każdego użytkownika
- D) RMSE policzone 3 razy

**35.** Czym WALS różni się od SGD przy minimalizacji funkcji celu w faktoryzacji macierzy?
- A) WALS obsługuje dowolne funkcje straty, ale nie da się go zrównoleglić
- B) WALS zbiega szybciej i łatwiej obsługuje wpisy nieobserwowane, ale działa tylko ze stratą kwadratową
- C) WALS jest wolniejszy i wymaga negative sampling
- D) nie ma różnic, to dwie nazwy tego samego algorytmu

---

## Część V – Kafka i Spark Streaming

**36.** Za co odpowiada Zookeeper w Kafce?
- A) przechowuje wszystkie komunikaty z topiców
- B) serializuje wiadomości producenta do JSON
- C) wykonuje agregacje w oknach czasowych
- D) zarządza brokerami i przechowuje tylko metadane: topiki, brokery i konsumentów

**37.** Czym jest DStream w (starszym) Spark Streaming?
- A) sekwencją RDD, z których każde zawiera dane z jednego interwału czasowego
- B) pojedynczą tabelą SQL
- C) topikiem Kafki
- D) plikiem w formacie Parquet

**38.** Który tryb wyjścia (`outputMode`) Structured Streaming zapisuje za każdym razem całą tabelę wyników?
- A) `append`
- B) `update`
- C) `complete`
- D) `overwrite`

**39.** Czym jest okno typu tumbling?
- A) oknem, które zamyka się po okresie bez zdarzeń
- B) oknem, którego długość jest równa przesunięciu, więc okna się nie zazębiają (np. 30 s / 30 s)
- C) oknem o długości większej niż przesunięcie, więc okna się zazębiają (np. 30 s / 20 s)
- D) oknem obejmującym cały strumień od początku

**40.** Który fragment poprawnie podłącza Spark Structured Streaming do topicu `topicBD` w Kafce?
- A) `spark.read.kafka("topicBD").start()`
- B) `spark.readStream.format("kafka").option("topic", "topicBD").show()`
- C) `spark.writeStream.format("kafka").option("subscribe", "topicBD").load()`
- D) `spark.readStream.format("kafka").option("kafka.bootstrap.servers", server).option("subscribe", "topicBD").load()`

---
---

## Klucz odpowiedzi

| Nr | Odp. | Uzasadnienie |
|---|---|---|
| 1 | A | 3V = Volume, Velocity, Variety. Model 4V dodaje Value. |
| 2 | C | Ok. 80% danych świata nie ma jasno zdefiniowanej struktury. |
| 3 | B | Hadoop nie jest do transakcji, dostępu o małym opóźnieniem, wielu małych plików ani zadań, których nie da się zrównoleglić. |
| 4 | D | Domyślnie 128 MB. 64 MB to wartość ze starszych wersji, 256 MB jest zalecane. Dla porównania blok w UNIX ma 4 KB. |
| 5 | C | NameNode zarządza metadanymi i pilnuje liczby replik. Bloki przechowują DataNode'y. |
| 6 | D | Druga replika trafia do innego racka (odporność na awarie), trzecia do tego samego racka co druga. |
| 7 | B | `put` = `copyFromLocal` (lokalny → HDFS). `get` = `copyToLocal` (HDFS → lokalny). |
| 8 | C | `-w` czeka na osiągnięcie poziomu replikacji, `-R` działa rekurencyjnie. |
| 9 | A | Hadoop: schemat przy odczycie i szybkie zapisy. RDBMS: schemat przed zapisem, szybkie odczyty, transakcje. |
| 10 | C | Hive pochodzi z Facebooka (Meta), a Pig z Yahoo Research (2006). |
| 11 | B | HiveQL opisuje cel (deklaratywny), Pig Latin buduje przepływ danych. HiveQL nie jest Turing-zupełny, rozszerza się go funkcjami UDF. |
| 12 | A | Domyślnie Apache Derby, ale może to być dowolna relacyjna baza. |
| 13 | D | Schemat stosuje się przy odczycie, więc ładowanie jest szybkie, zapytania wolniejsze, a dla tych samych danych można mieć wiele schematów. |
| 14 | B | Tabela zewnętrzna to tylko metadane. Przy tabeli wewnętrznej (managed) `DROP` usuwa dane i metadane. |
| 15 | C | `ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE`. TEXTFILE jest formatem domyślnym. |
| 16 | D | `LOCAL INPATH` oznacza lokalny system plików. Samo `INPATH` oznacza HDFS. Bez `OVERWRITE` dane są dopisywane. |
| 17 | A | Przykład: `SELECT total FROM (SELECT c1 + c2 AS total FROM mytable) my_query;` |
| 18 | C | `ORDER BY` używa jednego reducera (globalnie), `SORT BY` wielu reducerów (każdy daje osobny posortowany plik). |
| 19 | B | `hive.execution.engine` przyjmuje `tez` albo `mr`. Tez jest ok. 10× szybszy, bo buduje DAG. |
| 20 | A | `unix_timestamp()` działa w drugą stronę (data → sekundy), a `to_date()` zwraca samą datę. |
| 21 | D | `explode(map(...))` rozbija mapę na wiersze (key, value). W przykładzie zarówno kobiety, jak i mężczyźni najczęściej oglądali Drama. |
| 22 | B | Indeksy tablic liczy się od 0. STRUCT: `c.a`, MAP: `M['klucz']`. |
| 23 | D | `fit()` zwraca model (Transformer), a `transform()` dodaje kolumny, np. `prediction`. |
| 24 | A | `VectorAssembler` tylko składa kolumny w wektor. StringIndexer, StandardScaler i RandomForest to estymatory. |
| 25 | B | 42 to seed, a `[0.7, 0.3]` to podział 70/30. |
| 26 | C | Odpowiedź A to Recall, B to Accuracy, D to F1 (średnia harmoniczna). |
| 27 | D | Inne wartości użyte na wykładzie: `"accuracy"`, `"weightedPrecision"`, `"weightedRecall"`. |
| 28 | C | 3 × 3 = 9 kombinacji. Random Search losuje tylko część z nich. |
| 29 | A | k-fold: k rozłącznych podzbiorów, każdy jest zbiorem testowym dokładnie raz. Alternatywa to `TrainValidationSplit`. |
| 30 | C | „Jeśli A jest podobny do B, a B lubi film 1, poleć film 1 użytkownikowi A”. Metadanych używa content-based. |
| 31 | B | Generowanie kandydatów (np. miliardy → setki), potem ocena (scoring), na końcu re-ranking (świeżość, różnorodność, fairness). |
| 32 | D | C to średnia ocena globalna (na slajdzie błędnie opisana jako „średnia liczba głosów”). v = głosy filmu, m = minimum głosów, R = średnia filmu. |
| 33 | A | Bez `drop` metryka RMSE wyszłaby NaN z powodu nowych użytkowników i filmów (cold start). |
| 34 | C | `recommendForAllItems(3)` zwraca 3 użytkowników dla każdego filmu. |
| 35 | B | SGD: elastyczny, ale wolniejszy i gorzej radzi sobie z nieobserwowanymi wpisami. Oba algorytmy da się zrównoleglić. |
| 36 | D | Zookeeper nie przechowuje danych, tylko metadane. Zwykle działa na 3 nodach. |
| 37 | A | `StreamingContext(sc, 1)` oznacza batch co 1 s. Nowsze Structured Streaming opiera się na Spark SQL i micro-batchach. |
| 38 | C | `append` zapisuje tylko nowe wiersze, `update` tylko zmienione. |
| 39 | B | Sliding: okno dłuższe niż przesunięcie (okna się zazębiają). Session: okno zamyka się po przerwie bez zdarzeń. |
| 40 | D | `readStream` + `format("kafka")` + `kafka.bootstrap.servers` + `subscribe` + `load()`. Wynik zapisuje się przez `writeStream.outputMode(...).format("console").start()`. |

Rozkład odpowiedzi: A – 9, B – 10, C – 11, D – 10.
