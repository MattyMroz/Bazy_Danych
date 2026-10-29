# Big Data – notatki z wykładów (po polsku)

Przedmiot: Big Data, dr inż. Paweł Drzymała, Politechnika Łódzka. Notatki przepisane i przetłumaczone ze slajdów `Wykład_1.pdf`–`Wykład_4.pdf`. Kod, komendy i nazwy techniczne są w oryginale. Fragmenty oznaczone „> Wyjaśnienie” to dopowiedzenia spoza slajdów, a „(na slajdzie: …)” oznacza błąd lub niespójność na slajdzie.

## Spis treści

1. [Wykład 1A – Big Data, Hadoop, HDFS (s. 1–100)](#wykład-1a)
2. [Wykład 1B – HDInsight, Hive, HiveQL, Tez (s. 101–198)](#wykład-1b)
3. [Wykład 2 – Spark MLlib: klasyfikacja](#wykład-2)
4. [Wykład 3 – Systemy rekomendacyjne, ALS](#wykład-3)
5. [Wykład 4 – Spark Streaming i Apache Kafka](#wykład-4)

---

<a id="wykład-1a"></a>

# Wykład 1A – Big Data, Hadoop, HDFS (s. 1–100)


Prowadzący: dr inż. Paweł Drzymała (pawel.drzymala@p.lodz.pl), Instytut Mechatroniki i Systemów Informatycznych, Politechnika Łódzka, ul. Stefanowskiego 18/22, 90-924 Łódź (s. 1).

### Sprawy organizacyjne (s. 2–13)

#### Efekty uczenia się i treści przedmiotu (s. 2)

Student po kursie:
1. zna zaawansowane techniki przetwarzania dużych, zmiennych i różnorodnych zbiorów danych,
2. zna silniki do analizy danych na dużą skalę (Big Data),
3. umie użyć języków do złożonej analizy dużych zbiorów danych,
4. umie stosować różne techniki dostępu do danych, ich ekstrakcji, transformacji i analizy.

Laboratorium to kilka projektów pokazujących użycie poszczególnych elementów Big Data, zakończonych analizą i przetwarzaniem danych. Zakres:
1. Wprowadzenie do Big Data (klastrowe systemy przetwarzania oparte na środowisku Hadoop).
2. Wprowadzenie i praca w środowisku Hadoop i Hadoop Distributed File System (HDFS).
3. Platformy przetwarzania big data: Apache Spark, Apache Pig, Apache Hive (zastosowanie w przetwarzaniu danych – ETL).
4. Praca z silnikiem Apache Spark i jego komponentami: Spark Core, SparkSQL, Spark Streaming, biblioteka uczenia maszynowego MLlib.
5. Przetwarzanie strumieni danych – ćwiczenia.
6. Budowa modeli predykcyjnych.
7. Budowa modeli rekomendacyjnych.

Źródło programu: https://programy.p.lodz.pl/

#### Zasady zaliczenia (s. 2–3)

- Ocena końcowa składa się z dwóch ocen cząstkowych:
  1. kolokwium praktyczne (na 7. lub 8. laboratorium) – 50%,
  2. projekt grupowy (grupy 2–3-osobowe) – 50%.
- Ocena końcowa = średnia arytmetyczna wszystkich ocen.
- Pierwsze zaliczenie odbywa się na laboratorium w 8. tygodniu zajęć (w listopadzie).
- Liczba ćwiczeń do wykonania: 6–10.
- Projekt można omawiać (oddawać) na ostatnich dwóch laboratoriach.

#### Wymagania dotyczące projektu (s. 4–7)

- Projekt ma zawierać implementację jednego z modeli w Apache Spark:
  1. model do zadań predykcji **albo**
  2. model do zadań klasyfikacji **albo**
  3. model do zadań rekomendacji (na slajdzie ta pozycja jest przekreślona).
- PAMIĘTAJ: projekt musi powstać z użyciem silnika i platformy Apache Spark, z wykorzystaniem co najmniej jednej z bibliotek: Spark Streaming i/lub MLlib.

Wymagane elementy opisu projektu:
1. **Opis „celu projektu”** – projekt powinien:
   - a) przyjąć i sformułować tezy dla procesu przetwarzania danych, aby na ich podstawie uzyskać informacje i wnioski,
   - b) zależnie od postawionych problemów założyć konkretne użycie metod statystycznych i innych oraz sposobów użycia narzędzi.
2. **Dobór danych do zamierzonego celu**:
   - a) opis doboru danych do przyjętego tematu, ich natywnej struktury i formatów,
   - b) opis: ilościowego charakteru surowych danych; sposobu powstania (dane pierwotne, dane wtórne); dynamiki zmian (ciągła rejestracja lub rejestracja w odstępach czasu); źródeł pochodzenia,
   - c) opis procesu pozyskiwania danych w postaci strumieni (zdarzenia w czasie rzeczywistym) udostępnianych przez brokery Apache Kafka.
3. **Ekstrakcja i analiza danych**:
   - a) omówienie procesów organizowania, transformacji i modelowania danych w celu uzyskania użytecznych informacji i wniosków oraz technik i narzędzi do wykrywania ukrytych dla człowieka prawidłowości w danych,
   - b) opracowanie skryptów do ekstrakcji, transformacji i ładowania (ETL) danych do formatów o zdefiniowanej strukturze w Apache Spark,
   - c) omówienie procesu uczenia maszynowego w Apache Spark – budowy modelu predykcji … lub systemu rekomendacji.
4. **Komentarze i wnioski końcowe** po analizie – jak mogą wspierać proces podejmowania decyzji.

Uwagi (powtórzone na s. 7 „Once again”): wszystko opisujemy w raporcie i dodajemy źródła. Na ocenę bardzo dobrą projekt trzeba oddać przed rozpoczęciem sesji.

#### Źródła informacji (s. 8–9)

Darmowe źródła elektroniczne (także PDF):
- https://www.tutorialspoint.com/big_data_tutorials.htm
- https://hadoop.apache.org/
- https://spark.apache.org/
- https://developer.ibm.com/hadoop/
- https://hadoop.apache.org/docs/r1.2.1/hdfs_design.html (HDFS Architecture Guide)
- i inne.

Książki (elektroniczne i papierowe, s. 9): „Mastering Hadoop 3”, „Apache Spark 3 for Data Engineering and Analytics with Python” (wideo), „PySpark Cookbook”, „Learning PySpark”, „Frank Kane's Taming Big Data with Apache Spark and Python” (wszystkie Packt), a na okładkach także: „Harness the Power of Big Data” (IBM), „Big Data” (Marz, Warren), „Hadoop. Kompletny przewodnik” (Tom White), „Apache Hadoop YARN”, „Fast Data Processing with Spark”.

#### Gdzie szukać zbiorów danych (s. 10–13)

- https://archive.ics.uci.edu/ml/index.php – UCI Machine Learning Repository (Center for Machine Learning and Intelligent Systems); na zrzucie: 468 zbiorów danych, filtry wg zadania (klasyfikacja, regresja, klasteryzacja), typu atrybutów, typu danych, dziedziny, np. Abalone, Adult, Arrhythmia.
- https://www.kaggle.com – „miejsce do realizacji projektów data science”; na zrzucie ok. 15 tys. zbiorów (np. Heart Disease UCI, FIFA 19 complete player dataset, Suicide Rates Overview 1985–2016, Google Play Store Apps, Graduate Admissions, Mall Customer Segmentation Data, Ethereum Classic Blockchain).
- http://stat-computing.org/

### Wprowadzenie do Big Data (s. 14–37)

#### Cele wprowadzenia (s. 14–15)

Temat 1: wprowadzenie do obliczeń rozproszonych i wydajnej analizy danych (big data). Po nim powinniśmy umieć:
- wyjaśnić, po co stosuje się rozwiązania Big Data,
- opisać, czym jest Big Data,
- wymienić i stosować aplikacje „open source” należące do rozwiązań Big Data i znać ich przeznaczenie.

#### Skalowalność przetwarzania – przykład mainframe (s. 16)

- Ok. 87% wszystkich transakcji kartami kredytowymi i płatności (prawie 8 bln USD rocznie) przechodzi przez systemy mainframe.
- Platforma obsługuje rocznie 29 mld transakcji bankomatowych o średniej dziennej wartości 5 mld USD.
- Systemy mainframe obsługują loty 4 mld pasażerów rocznie.
- Diagram: drabina edycji Db2 od najmniejszej do największej: Everyplace Edition (przekreślona), Personal Edition, Db2 Community Edition, Workgroup Server Edition, Enterprise Server Edition, Enterprise Server Edition (Data Partitioning Feature), mainframe. Strzałka „Small and medium companies” obejmuje środkowe edycje.
- Wniosek: w wybranych procesach biznesowych taka lub podobna platforma nie wystarcza, a koszt skalowania jest zbyt wysoki.

#### Jednostki danych (s. 17–19)

Kilobajty, megabajty i gigabajty są powszechnie znane, terabajt wszedł do rozmów w ostatnich latach. Petabajt, eksabajt, zettabajt i jottabajt brzmią dla większości obco, ale są niezbędne przy pracy z dużymi zbiorami danych.

| Nazwa | Symbol | SI (dziesiętnie) | Użycie binarne (przestarzałe) |
|---|---|---|---|
| kilobyte | KB | 10³ | 2¹⁰ |
| megabyte | MB | 10⁶ | 2²⁰ |
| gigabyte | GB | 10⁹ | 2³⁰ |
| terabyte | TB | 10¹² | 2⁴⁰ |
| petabyte | PB | 10¹⁵ | 2⁵⁰ |
| exabyte | EB | 10¹⁸ | 2⁶⁰ |
| zettabyte | ZB | 10²¹ | 2⁷⁰ |
| yottabyte | YB | 10²⁴ | 2⁸⁰ |

Liczebniki potęg tysiąca (dygresja, s. 19). Uwaga: w różnych językach tworzy się je według różnych reguł.

| Liczebnik | Skala długa (np. Polska) | Skala krótka (np. USA) | Etymologia |
|---|---|---|---|
| tysiąc | 10³ | 10³ | słowo starosłowiańskie, prawdopodobnie od *tū-t-ḱm̥t-i- „potężna setka” |
| milion | 10⁶ | 10⁶ | starofrancuskie *milioun*, od starowłoskiego *milione* – wzmocnionej wersji *mille* (tysiąc) |
| miliard | 10⁹ | nie ma | ze średniowiecznego francuskiego *miliart* (przekształcona nazwa miliona), we francuskim od XVI w. |
| bilion | 10¹² = 10^(6·2) | 10⁹ = 10^(3·2+3) | łac. *bi-* „dwu-” + końcówka z „milion” |
| biliard | 10¹⁵ = 10^(6·2+3) | nie ma | łac. *bi-* + końcówka z „miliard” |
| trylion | 10¹⁸ = 10^(6·3) | 10¹² = 10^(3·3+3) | łac. *tri-* „trój-” + końcówka z „milion” |

#### Pieniądze a dane – dygresja (s. 20–22)

- Pytanie: czy miliard dawnych marek niemieckich lub miliard dolarów to dużo? Odpowiedź: „to zależy” – od WIARY (łac. *fides*).
- Pieniądz fiducjarny (fiat money) – waluta niepokryta towarem (złotem, srebrem), zwykle ustanowiona przez rząd jako prawny środek płatniczy (źródło: nbportal.pl). Ilustracje: banknot 100 bilionów dolarów Zimbabwe, banknot 100 bilionów marek (15 stycznia 1924).
- Ile bilionów dolarów (ang. trillion) „wypuszczono” od 2007 r. w programach QE1, QE2 i QE3 dla ratowania gospodarki USA? Odpowiedź: 3,5 biliona. Dla porównania: bilion banknotów studolarowych ułożonych w stos sięgnąłby z Ziemi na Księżyc.
- **Wniosek:** w przypadku danych, tak jak pieniędzy, liczy się nie tylko ilość, lecz także wartość, miejsce, czas dostępu itd.

#### Czym jest Big Data (s. 23–24)

- Big data to termin oznaczający strategię/technologię przetwarzania dużych zbiorów danych.
- Jakie zbiory są duże, a jakie małe? Nie ma jednoznacznej odpowiedzi – zależy, czym są dane i jak je przetwarzamy.
- Dlatego termin „Big Data” jest nieco mylący i wielu ludzi go nie lubi: sugeruje, że pojedyncza dana jest mała (może być) albo że dany typ danych jest duży (może, ale nie musi).
- „Big Data” to coś więcej niż duża baza danych.

Jak duże są zbiory danych (s. 24):
- ponad 90% danych powstało w ciągu ostatnich 2 lat,
- co 2 dni produkujemy tyle danych, ile ludzkość wytworzyła od początku cywilizacji do początku XXI wieku,
- do końca 2023 r. ilość przechowywanych danych cyfrowych wzrosła do 90,4 ZB,
- 52 PB (petabajt = 10¹⁵ B) to hurtownia danych 30% klientów eBay albo cała literatura zebrana na świecie w historii ludzkości, albo film HD trwający 13 lat,
- w 2017 r. aż 2/3 danych świata przechowywano na obrotowych dyskach twardych (wykres nośników: optyczne, taśmy, HDD, flash; źródło backupacademy.pl).

#### Dlaczego gromadzimy tak duże zbiory (s. 25–27)

- Odpowiedź: przechowywanie tanieje – koszt 1 GB w 1980 r. to 3 mln USD, w 2010 r. 0,08 USD. Dlatego pliki trzymamy dziś nawet na prywatnych dyskach sieciowych (NAS).
- Ciekawostki (wg IBM): 2,5 PB to pojemność ludzkiego mózgu; 13 PB to ilość, którą można by pobrać z internetu w dwie minuty, gdyby każdy Amerykanin jednocześnie ściągnął 300 MB.
- Grafiki: od początku cywilizacji do 2003 r. wyprodukowaliśmy 5 eksabajtów danych, teraz tyle produkujemy co 2 dni; dane na świecie co najmniej podwajają się co 2 lata.

#### Skąd pochodzą dane (s. 28–29)

W ciągu jednej minuty:
- powstaje 277 000 tweetów,
- 2 mln zapytań w Google,
- 72 godziny nowych filmów na YouTube,
- Walmart przetwarza prawie 17 tys. transakcji (2,5 PB dziennie),
- piszemy ponad 100 mln e-maili,
- pobieramy 32 tys. aplikacji mobilnych.

W 2005 r. używano 1,3 mld czytników RFID, obecnie 200 mld. Dane mają różną naturę. To nie wszystko: dane generuje też przemysł, nauka, astronomia itd.

#### Definicja i model V (s. 30)

Big data to termin dotyczący zbiorów danych **dużych, zmiennych i różnorodnych**, których przetwarzanie i analiza są trudne, ale wartościowe, bo mogą prowadzić do nowej wiedzy (wg Wikipedii). Big data ma zastosowanie wszędzie tam, gdzie gromadzi się dużo danych cyfrowych, a jest potrzeba zdobycia nowych informacji lub wiedzy.

W 2001 r. META Group opublikowała raport opisujący big data modelem **3V**:

| Cecha | Pytanie |
|---|---|
| Volume (ilość) | ile jest danych? |
| Velocity (szybkość) | jak szybko dane powstają, są przesyłane lub udostępniane? |
| Variety (różnorodność) | ile jest różnych typów źródeł? |

Model rozszerzono do **4V** o:

| Cecha | Pytanie |
|---|---|
| Value (wartość) | czy możemy ufać danym? czy dane mogą dać sensowny zwrot z inwestycji? |

Na slajdzie wymieniono jeszcze:

| Cecha | Pytanie |
|---|---|
| Validity (poprawność) | czy dane są dokładne i poprawne? |
| Visualization (wizualizacja) | (na slajdzie powielono opis Velocity: „jak szybko dane powstają, są przesyłane lub udostępniane?”) |

#### Statystyki biznesowe (s. 31)

- W nadchodzącej dekadzie 44 razy więcej danych i treści: 2009 – 800 000 PB, 2020 – 35 ZB.
- 80% danych świata jest nieustrukturyzowanych.
- 1 na 3 liderów biznesu podejmuje decyzje na podstawie informacji, którym często nie ufa lub których nie ma.
- 1 na 2 menedżerów twierdzi, że nie ma dostępu do informacji potrzebnych w pracy.
- 83% menedżerów traktuje Business Intelligence jako plan zwiększenia konkurencyjności swojej organizacji.
- 60% prezesów (CEO) twierdzi, że musi szybciej rozumieć informacje, by szybko podejmować decyzje.

#### Dane w ruchu i dane w spoczynku (s. 32)

| Data in motion – strumienie informacji („kran”) | Data at rest – oceany informacji |
|---|---|
| Twitter / Facebook | dane już zgromadzone, np. logi WWW, e-maile, media społecznościowe |
| dane giełdowe | dokumenty nieustrukturyzowane, np. formularze |
| czujniki, np. do prognozowania pogody lub pomiaru funkcji życiowych noworodków | dane ustrukturyzowane z różnych systemów |

#### Typy danych (s. 33)

Trzy typy danych:
1. dane relacyjne – o zdefiniowanej strukturze,
2. dane XML i JSON – półustrukturyzowane,
3. dane nieustrukturyzowane – Word, PDF, tekst, logi multimedialne.

Ok. 80% danych świata nie ma jasno zdefiniowanej struktury (wykres kołowy: 80% nieustrukturyzowane, 20% ustrukturyzowane). Mogą to być dane zebrane wcześniej, których nie da się przetworzyć standardowo. Na wyzwania Big Data odpowiedziano nowym typem technologii; wiele z nich zgrupowano pod nazwą **NoSQL**.

#### Wyzwania Big Data (s. 34)

Pozyskiwanie (data capture), czas trwania (duration), przeszukiwanie, dzielenie, transfer, analiza, prezentacja.

#### Przykład: różnice w postrzeganiu mediów społecznościowych (s. 35)

- Badanie IBM CEO pokazało, że dla wielu firm media społecznościowe są podstawą strategii zbliżania się do oczekiwań klientów.
- Osobne badanie („What Customers Want”, IBM, 2011) wykazało, że firmy często nie rozumieją, czego konsumenci naprawdę od nich chcą. Wykres „perception gap”:
  - ranking konsumentów (po co kontaktują się z firmami w mediach społecznościowych): rabat (61%), zakup (55%), recenzje i rankingi produktów (53%), informacje ogólne (53%), informacje ekskluzywne (52%), poznanie nowych produktów (51%), opinia o produktach/usługach, obsługa klienta (37%), udział w wydarzeniach (34%), poczucie więzi (33%), zgłaszanie pomysłów (30%), bycie częścią społeczności (22%);
  - ranking firm (dlaczego ich zdaniem konsumenci je obserwują): poznanie nowych produktów (73%), informacje ogólne (71%), opinia o produktach, informacje ekskluzywne (68%), recenzje (67%), poczucie więzi (64%), obsługa klienta (63%), zgłaszanie pomysłów, bycie częścią społeczności (61%), udział w wydarzeniach (61%), zakup (60%), rabat (60%).
- Dwa najczęstsze wybory konsumentów (rabat i zakup) nie znalazły się w pierwszej dziesiątce prognoz firm.
- Analiza Big Data pozwala odkrywać wiedzę, której nie da się łatwo uzyskać z klasycznych baz danych. Przykładowe pytania: czy rodzaj produktów kupowanych w internecie wiąże się z porą roku i pogodą? Czy z rachunków można przewidzieć, która klientka banku spodziewa się dziecka? Czy smartwatch zauważy coś niepokojącego w naszym zdrowiu?

#### Czy Big Data się opłaca (s. 36–37)

- Według Gartnera tylko 10–15% przedsiębiorstw w pełni wykorzystuje korzyści z big data.
- Firmy, którym się uda, zyskają 20% przewagi nad nieprzygotowaną konkurencją w kluczowych wskaźnikach biznesowych (wg Intel Corp.).
- Big data jest jak góra, z której próbuje się wydobyć zmieniające się reguły gry, by zmiażdżyć konkurencję; złotem jest wgląd i wiedza zwiększające skuteczność biznesu.
- „Dziś DANE są tym, czym ropa naftowa w XIX wieku” – stwierdzenie przyjęte przez Światowe Forum Ekonomiczne w 2011 r.

### Hadoop – wprowadzenie (s. 38–44)

#### Źródła (s. 38)

http://hadoop.apache.org/, https://github.com/big-data-europe/docker-hadoop, https://www.tutorialspoint.com/big_data_tutorials.htm, https://www.cloudera.com/tutorials.html, https://docs.microsoft.com/pl-pl/azure/hdinsight/hadoop/apache-hadoop-introduction (2022).

#### Czym jest Hadoop (s. 39–42)

- Hadoop to platforma do przechowywania i przetwarzania (analizy) danych. Pozwala przechowywać i analizować dane wszystkich typów, aby na ich podstawie podejmować trafne decyzje biznesowe.
- Diagram (s. 39): dane ustrukturyzowane, nieustrukturyzowane i półustrukturyzowane trafiają do Hadoopa (analiza z użyciem Pig, Hive, Spark, HBase), a wynik prowadzi do decyzji biznesowych.
  - Dane ustrukturyzowane – dane, które można przechowywać i przetwarzać w stałym formacie, czyli według schematu.
  - Dane półustrukturyzowane – dane bez formalnej struktury modelu danych (XML, JSON).
- Cechy (s. 40):
  - platforma open source, twórca: **Doug Cutting**, pod opieką Apache Software Foundation,
  - napisana głównie w **Javie**,
  - zoptymalizowana pod obsługę ogromnych ilości danych dzięki przetwarzaniu równoległemu,
  - masowe przetwarzanie równoległe działa bardzo wydajnie,
  - umożliwia replikację danych w klastrze,
  - **Hadoop nie służy do przetwarzania transakcyjnego!**
- Cechy w skrócie (s. 41): open source; rozproszona replikacja danych; sprzęt powszechnego użytku (commodity hardware); współlokalizacja danych i analizy (data and analysis co-location); skalowalność; niezawodna obsługa błędów. Diagram: dane wejściowe (Input Data) rozdzielane na wiele węzłów (Nodes).
- Hadoop (s. 42) pozwala tysiącom węzłów współpracować i przetwarzać petabajty danych w sposób wysoce równoległy i tani:
  - węzeł Hadoop = CPU + dyski HDD,
  - węzły łączy się w klastry,
  - w razie potrzeby można dodawać nowe węzły bez zmiany formatu danych, danych załadowanych do klastra ani napisanych zadań.
- Hadoop **nie nadaje się** do każdej pracy:
  - nie do przetwarzania opartego na regułach transakcyjnych,
  - nie gdy pracy nie da się zrównoleglić,
  - nie do dostępu do danych z małym opóźnieniem (low latency),
  - nie do przetwarzania wielu małych plików,
  - nie do intensywnego przetwarzania małych ilości danych.

#### Przykłady zastosowań Hadoopa (s. 43–44)

- Telekomunikacja; bezpieczeństwo i zagrożenia terrorystyczne; ochrona zdrowia – wykrywanie ognisk chorób; itd.
- Case study (s. 44): azjatycki operator telekomunikacyjny obniżył koszty billingu i poprawił zadowolenie klientów. Wykorzystane możliwości: Stream Computing, Analytic Accelerators. Mediacja i analiza w czasie rzeczywistym 5 mld rekordów CDR (Call Detail Records) dziennie; czas przetwarzania skrócony z 12 godzin do 1 minuty; koszt sprzętu zmniejszony do 1/8; proaktywne rozwiązywanie problemów (np. zerwanych połączeń) wpływających na zadowolenie klientów.

### Architektura Hadoopa i ekosystem (s. 45–56)

#### Rdzeń architektury (s. 45–47)

- Architektura Hadoopa: **HDFS** oraz **YARN** – narzędzia współpracujące ze sobą.
- Rdzeń Hadoopa ma dwa główne komponenty:
  - A – Hadoop Distributed File System (HDFS),
  - B – MapReduce Engine (na slajdzie przekreślony), zastąpiony przez **YARN (Hadoop v2)** – Yet Another Resource Negotiator. YARN pozwala używać zestawu współpracujących ze sobą narzędzi.
- Agenda części o HDFS: przegląd terminologii, HDFS, MapReduce, typy węzłów, świadomość topologii (topology awareness).

#### Enterprise Hadoop Architecture (YARN) – ekosystem (s. 46)

Ekosystem: w klastrze różne frameworki mogą współpracować przez YARN. Diagram warstwowy:
- warstwa górna – frameworki: In-Memory → **Spark**; Scripts → **Pig**; SQL → **Hive**; operacje Batch → **MapReduce**; …; Stream → **Storm**; full-text search → **Solr**; NoSQL → **HBase**,
- warstwa środkowa – **YARN** (Yet Another Resource Negotiator), „system operowania na danych”,
- warstwa dolna – **HDFS** (Hadoop Distributed File System), system zarządzania przechowywaniem danych; bloki ponumerowane 1–5 rozłożone w kilku kopiach na różnych węzłach.

#### Komponenty ekosystemu (s. 48–54)

Diagram powtarzany na slajdach: na dole HADOOP CORE (z WebHDFS), nad nim DATA SERVICES (Flume, Sqoop, Pig, Hive, HCatalog, HBase) oraz OPERATIONAL SERVICES (Ambari, Oozie). Na każdym slajdzie wyróżniony jest omawiany komponent.

| Komponent | Rola | Opis ze slajdu |
|---|---|---|
| **Apache Flume** (s. 48) | przechowywanie plików logów i zdarzeń | rozproszona usługa do wydajnego zbierania, agregowania i przenoszenia strumieni danych logów do HDFS; możliwość strumieniowania z mechanizmami failover i odtwarzania po awarii |
| **Apache Pig** (s. 49) | język skryptowy dla Hadoopa | pozwala pisać złożone transformacje danych prostym językiem skryptowym; Pig Latin (język) definiuje transformacje zbioru danych, m.in. agregację, złączenia (join), sortowanie; rozszerzalny przez UDF (User Defined Functions) pisane w Javie i wywoływane z Piga; dla programistów znających języki skryptowe i SQL |
| **Apache Hive** (s. 50) | interfejs SQL dla Hadoopa | de facto standardowy, SQL-podobny interfejs do podsumowań danych, zapytań ad hoc i analizy dużych zbiorów; łączy się z Excelem, MicroStrategy, PowerPivot, Tableau i innymi narzędziami BI przez sterownik Hortonworks Hive ODBC; HiveQL (HQL) to język dla analityków znających SQL |
| **Apache HBase** (s. 51) | baza NoSQL dla aplikacji interaktywnych | nierelacyjna, kolumnowa baza danych pozwalająca tworzyć, czytać, aktualizować i usuwać dane w Hadoopie wydajnie dla aplikacji interaktywnych; używana w „inteligentnych aplikacjach”, które przewidują zachowania użytkowników, wykrywają zmiany wzorców użycia lub rekomendują sposoby zaangażowania |
| **Apache HCatalog** (s. 52) | metadane i zarządzanie tabelami | usługa metadanych pozwalająca widzieć dane Hadoopa jako zbiór tabel bez martwienia się, gdzie i jak są przechowywane; spójne współdzielenie danych między narzędziami (Pig, MapReduce, Hive); głęboka interoperacyjność z systemami takimi jak Teradata, SQL Server |
| **Apache Ambari** (s. 53) | zarządzanie i monitorowanie | ułatwia obsługę klastrów Hadoop; uproszczone udostępnianie klastra kreatorem instalacji krok po kroku; wstępnie skonfigurowane metryki zdrowia usług; wizualizacja wykonania zadań (job/task) do diagnozowania wydajności; pełne API RESTful do integracji z narzędziami operacyjnymi; intuicyjny interfejs |
| **Apache Oozie** (s. 54) | przepływy pracy i harmonogramowanie | system workflow koordynujący zadania pisane w różnych językach (MapReduce, Pig, Hive); pozwala określić kolejność i zależności między zadaniami, aby przetwarzanie przebiegało w uporządkowany sposób |

#### Hadoop w infrastrukturze przedsiębiorstwa (s. 55)

Diagram: centralny blok Hadoop z warstwami: Templeton, WebHDFS, Sqoop, Flume; HCatalog; Pig, Hive; HBase; **MapReduce i HDFS** (wyróżnione); Ambari, Oozie, HA; ZooKeeper.
- Nad nim: istniejąca infrastruktura biznesowa (IDE i narzędzia deweloperskie, ODS i hurtownie tematyczne, aplikacje i arkusze, wizualizacja i BI), połączona przez Discovery Tools i EDW; Web (aplikacje WWW) przez bazy Low Latency/NoSQL; New Tech (np. Datameer, Tableau, Karmasphere, Splunk).
- Z boku: Operations (narzędzia własne i istniejące).
- Pod nim: źródła Big Data (transakcje, obserwacje, interakcje) – CRM, ERP, dane finansowe, media społecznościowe, dane „exhaust”, logi, pliki.

#### Sekwencja operacji w Hadoopie (s. 56)

Cykl trzech etapów:
1. **Archiwizacja i przechowywanie (Archival and Storage)** – przechowywanie danych przez lata, zachowywanie formatów pośrednich.
2. **Transformacja** – mapowanie wejść i wyjść tam, gdzie potrzeba; zamiana danych nieustrukturyzowanych w ustrukturyzowane w czasie wykonania (run-time).
3. **Analiza** – eksploracja danych w miejscu, bez konieczności wcześniejszej transformacji; wykonywanie dowolnego kodu.

### Hadoop a hurtownia danych i RDBMS (s. 57–60)

- Czy Hadoop można porównać do hurtowni danych? **Nie** – to rozproszony system przetwarzania (plików) (s. 57–58).

Różnice RDBMS a Hadoop (s. 59):

| Kryterium | RDBMS (przetwarzanie relacyjne) | Hadoop |
|---|---|---|
| Schemat | wymagany przed zapisem danych | nieobowiązujący, dopóki dane nie zostaną użyte do odczytu |
| Szybkość | szybkie odczyty danych | szybkie zapisy rekordów |
| Zarządzanie | są standardy i struktura | dowolne standardy i struktura |
| Przetwarzanie | tylko dla przechowywanych danych | przetwarzanie powiązane z formą danych |
| Typ danych | dobrze zdefiniowana struktura | wiele form i typów danych |
| Najlepsze dopasowanie | zadania transakcyjne | masowe operacje przetwarzania |

> Wyjaśnienie: wiersz „schemat” to w praktyce różnica *schema-on-write* (RDBMS) i *schema-on-read* (Hadoop).

Skalowanie architektury Hadoop (s. 60):
- do **6 tys. węzłów** na klaster,
- przetwarzanie ok. **500 PB** danych na klaster,
- obsługa prawie **miliarda plików i bloków**.

### Klastry Hadoop – węzły, racki, centra danych (s. 61–71)

- Klastry Hadoop skalują się od jednego węzła (wszystkie komponenty Hadoopa działają na tym samym węźle) do tysięcy węzłów, między którymi rozdziela się funkcje, aby zwiększyć zrównoleglenie przetwarzania.
- Kolejne kroki diagramu (s. 61–67):
  1. jeden węzeł (Node 1),
  2. w razie potrzeby dodaje się kolejne węzły (Node 2, …, Node n),
  3. węzły umieszcza się w **racku** (szafie) – w racku mieści się **do 40 węzłów**,
  4. wiele racków (Rack 1, Rack 2, …, Rack n) – „Jak Hadoop wykorzystuje przetwarzanie równoległe?”,
  5. **klaster Hadoop to zbiór racków**.
- Wnętrze centrum danych (s. 68–71): zdjęcia serwerowni, rury chłodzenia serwerowni, wnętrze centrum danych Google (szafy, serwery, wymiana dysków).

### HDFS – Hadoop Distributed File System (s. 72–94)

#### Budowa klastra HDFS (s. 72)

- **NameNode** – zarządza metadanymi klastra, aktywnie monitoruje liczbę replik bloków. Zna mapowanie bloków HDFS na DataNode'y i trzyma cały obraz przestrzeni nazw (namespace) w pamięci RAM.
- **DataNode** – wiele na klaster; przechowują i przetwarzają dane; okresowo raportują swój stan do NameNode (na slajdzie literówka „priodically”).
- Diagram architektury HDFS: klient wykonuje operacje na metadanych (Metadata ops) przez NameNode, który przechowuje metadane (nazwa, liczba replik, np. `/home/foo/data, 3, …`). NameNode wykonuje operacje na blokach (Block ops) w DataNode'ach. Klient czyta (Read) dane bezpośrednio z DataNode'ów i zapisuje (Write) bezpośrednio do nich; bloki są replikowane (Replication) między DataNode'ami w Rack 1 i Rack 2.

#### Bloki HDFS (s. 73)

- HDFS zaprojektowano do obsługi bardzo dużych plików.
- Każdy plik dzieli się na bloki – domyślnie w Hadoopie **128 MB**.
- Bloki leżą na różnych fizycznych DataNode'ach.
- Hadoop działa najlepiej z bardzo dużymi plikami: im większy plik, tym mniej czasu Hadoop traci na szukanie kolejnego miejsca danych na dysku, a tym więcej pracuje na granicy przepustowości dysku.
- Rozmiary bloku: **64 MB, 128 MB (domyślnie), 256 MB (zalecane)** – dla porównania 4 KB w UNIX.
- Jeden blok HDFS (128 MB) składa się z wielu bloków systemu operacyjnego (OS blocks).
- Diagram: dane wejściowe dzielone na Blok 1, Blok 2, Blok 3.

#### Replikacja bloków (s. 74)

- Bloki danych są replikowane na wiele węzłów.
- Pozwala to przetrwać awarię węzła bez utraty danych.
- Diagram: Node 1 ma Block #1 i #2, Node 2 – Block #1 i #3, Node 3 – Block #2 i #3 (każdy blok w dwóch kopiach na różnych węzłach).

#### Zapis pliku do HDFS krok po kroku (s. 75–85)

Scenariusz: klient HDFS ma plik File 1 złożony z bloków B1, B2, B3. Klaster ma 3 racki (rack 1–3) po 4 węzły (n1–n4); NameNode jest na rack 1 n1. Zakładamy **współczynnik replikacji = 3**.

1. Klient wysyła do NameNode żądanie „Create”. NameNode będzie śledził, gdzie są przechowywane wszystkie bloki pliku (s. 76).
2. NameNode sprawdza, czy plik już istnieje w HDFS i czy klient ma uprawnienia do zapisu. Jeśli tak, wskazuje DataNode, który ma zapisać pierwszy blok (s. 76).
3. Pierwsza replika B1 zostaje zapisana np. na **rack 1, n2** (s. 77).
4. Druga replika B1 trafia na losowo wybrany DataNode **w innym racku** niż pierwsza – tu rack 2, n1. Zwiększa to redundancję i odporność na awarie (s. 78).
5. Trzecia (ostatnia) replika B1 trafia na losowy węzeł **w tym samym racku co druga** – tu rack 2, n2. Wszystkie repliki B1 są zapisane (s. 79).
6. Potwierdzenie (ack) zapisu B1 idzie z trzeciego węzła do drugiego (rack 2 n2 → rack 2 n1) (s. 80).
7. I dalej: z drugiego do pierwszego (rack 2 n1 → rack 1 n2) (s. 81).
8. I na końcu do NameNode / klienta (s. 82).
9. Ten sam proces powtarza się dla B2: rack 2 n3, rack 3 n1, rack 3 n2 (s. 83).
10. I dla B3: rack 1 n3, rack 1 n4, rack 3 n3 (s. 84).
11. NameNode dodatkowo sprawdza, czy bloki są poprawnie zreplikowane, zanim odpowie klientowi – zapis potwierdzony (s. 85).

Końcowe rozmieszczenie:

| Rack | n1 | n2 | n3 | n4 |
|---|---|---|---|---|
| rack 1 | NameNode | B1 | B3 | B3 |
| rack 2 | B1 | B1 | B2 | – |
| rack 3 | B2 | B2 | B3 | – |

> Wyjaśnienie: reguła z wykładu przy replikacji 3 – jedna replika w jednym racku, dwie pozostałe w innym racku (na dwóch różnych węzłach). Dzięki temu dane przetrwają awarię całego racka. Potwierdzenia wracają łańcuchem w odwrotnej kolejności zapisu.

#### Odczyt pliku z HDFS (s. 86)

- NameNode przechowuje metadane (np. nazwy, repliki itd.).
- Klient najpierw odczytuje metadane z NameNode (gdzie leżą bloki B1, B2, B3), a potem czyta bloki bezpośrednio z DataNode'ów w różnych rackach (np. B1 z rack 2, B2 z rack 2/3, B3 z rack 1/3) i składa plik B1 B2 B3.

#### Obsługa HDFS i wiersz poleceń (s. 87–89)

- HDFS można obsługiwać przez **Java API** albo przez **interfejs wiersza poleceń** (HDFS Command Line Interface). Komendy zaczynają się od `hadoop` (lub `hdfs`), spacji, `dfs` (określa zasoby plikowe klastra) albo `fs`.
- Polecenia powłoki systemu plików HDFS zaczynają się od kreski (myślnika).
- Wywołanie:
  - `hadoop fs <args>`
  - `hdfs dfs <args>`
- Przykład: `ls` (wyświetlenie katalogu) to wspólne polecenie UNIX, tu poprzedzone myślnikiem. Jak w UNIX można podać ścieżkę jako argument, np. bieżący katalog jako pojedynczą kropkę.
- Zawartość katalogu głównego HDFS: `hadoop fs -ls` lub `hdfs dfs -ls /`.

Ścieżki jako URI (s. 88):
- Polecenia powłoki przyjmują ścieżki w postaci URI (Uniform Resource Identifier).
- Format URI: `scheme://authority/path` (schemat, authority, ścieżka).
- Lokalny system plików ma schemat `file`, HDFS ma schemat `hdfs`.
- Przykład:
  ```
  hadoop fs -copyFromLocal file:///myfile.txt hdfs://localhost/user/keith/myfile.txt
  ```
- Schemat i authority są opcjonalne – wartości domyślne pochodzą z pliku konfiguracyjnego `core-site.xml`.

Polecenia POSIX-owe i specyficzne dla HDFS (s. 89):
- HDFS obsługuje wiele poleceń typu POSIX: `cat`, `chgrp`, `chmod`, `chown`, `cp`, `du`, `ls`, `mkdir`, `mv`, `rm`, `stat`, `tail`.
- HDFS nie jest w pełni zgodny z POSIX, ale obsługuje wiele jego poleceń.
- Polecenia specyficzne dla HDFS: `copyFromLocal`, `copyToLocal`, `get`, `getmerge`, `put`, `setrep`.
- POSIX (Portable Operating System Interface for Unix) – przenośny interfejs systemu operacyjnego Unix; odpowiedź na próby standaryzacji różnych odmian Uniksa.

#### Szczegółowe polecenia HDFS (s. 90–94)

| Polecenie | Działanie | Składnia |
|---|---|---|
| `copyFromLocal` / `put` | kopiuje pliki z lokalnego systemu plików do HDFS (oba robią to samo) | `hadoop fs -copyFromLocal <localsrc> .. <dst>`<br>`hadoop fs -put <localsrc> .. <dst>` |
| `copyToLocal` / `get` | kopiuje pliki z HDFS do lokalnego systemu plików (przeciwieństwo `put`; slajd tłumaczy „get” jako „weź”) | `hadoop fs -copyToLocal [-ignorecrc] [-crc] <src> <localdst>`<br>`hadoop fs -get [-ignorecrc] [-crc] <src> <localdst>` |
| `getmerge` | „ulepszone pobieranie”: bierze wszystkie pliki z katalogów pasujących do wzorca źródła, scala i sortuje je w jeden plik w lokalnym fs; `<src>` zostaje zachowane | `hadoop fs -getmerge <src> <localdst>` |
| `setrep` | zmienia poziom replikacji pliku z domyślnego na wskazany przez użytkownika | `hadoop fs -setrep [-R] [-w] <rep> <path/file>` |

Szczegóły `setrep` (s. 93):
- można zmienić replikację jednego pliku albo, z opcją `-R`, rekurencyjnie całego drzewa katalogów,
- polecenie od razu zwraca nowy poziom replikacji,
- z opcją `-w` polecenie czeka (blokuje), aż nowy poziom replikacji zostanie osiągnięty.

Więcej przykładów komend: http://hadoop.apache.org/docs/stable/ (na zrzucie dokumentacja Apache Hadoop 3.2.1) (s. 94).

### Tworzenie klastra Hadoop w Azure HDInsight (s. 95–100)

- Opis: „What is Apache Hadoop in Azure HDInsight?” – https://docs.microsoft.com/pl-pl/azure/hdinsight/hadoop/apache-hadoop-introduction
- Instrukcja tworzenia klastra przez Azure Portal: https://docs.microsoft.com/pl-pl/azure/hdinsight/hadoop/apache-hadoop-linux-create-cluster-get-started-portal

Procedura:
1. Zaloguj się do Azure Portal (https://portal.azure.com/#home).
2. W górnym menu wybierz **Create a resource** (Utwórz zasób).
3. Wpisz „Azure HDInsight” (nie ma go na liście) i wybierz z listy **Azure HDInsight**, następnie „Utwórz”.
4. Bez subskrypcji – utworzenie bezpłatnego konta (s. 97–99): środki 200 USD na 30 dni, popularne usługi bezpłatnie przez 12 miesięcy, ponad 25 usług zawsze bezpłatnych. Formularz profilu: kraj/region (nie da się go później zmienić), imię, nazwisko, e-mail, telefon.
5. Formularz **Create HDInsight cluster** (s. 100), zakładki: Basics, Storage, Security + networking, Configuration + pricing, (Tags), Review + create.
   - **Basics**: zarządzany klaster HDInsight – do wyboru Spark, Kafka, Hadoop, Storm i inne; Project details: Subscription, Resource group (wybór lub „Create new”); Cluster details: Cluster name, Location (np. East US), Cluster type i Version; Cluster credentials: Cluster login username (np. `admin`), hasło i jego potwierdzenie, Secure Shell (SSH) username (np. `sshuser`), opcja „Use cluster login password for SSH”.
   - **Storage**: Primary storage type (Azure Storage), Selection method (Select from list / Use access key), Primary storage account, Container; Data Lake Storage Gen1; Additional Azure Storage; **Metastore settings** – aby zachować metadane Hive i/lub Oozie poza klastrem, wybiera się bazę SQL: SQL database for Hive, for Oozie, for Ambari.

#### Najważniejsze do zapamiętania

1. Model 3V (META Group, 2001): Volume, Velocity, Variety; 4V dodaje Value. Slajd wymienia też Validity i Visualization.
2. Ok. 80% danych świata jest nieustrukturyzowanych. Trzy typy danych: relacyjne (ustrukturyzowane), XML/JSON (półustrukturyzowane), nieustrukturyzowane (Word, PDF, tekst, logi).
3. Data in motion = strumienie (Twitter, giełda, czujniki); data at rest = dane zgromadzone (logi, e-maile, formularze, dane z systemów).
4. Koszt 1 GB: 3 mln USD w 1980 r., 0,08 USD w 2010 r. Do końca 2023 r. – 90,4 ZB danych.
5. „Dane to ropa XXI wieku” – Światowe Forum Ekonomiczne, 2011. Według Gartnera tylko 10–15% firm w pełni wykorzystuje big data; zyskują 20% przewagi.
6. Hadoop: open source, twórca Doug Cutting, Apache Software Foundation, napisany w Javie; **nie służy do przetwarzania transakcyjnego**, małych plików ani dostępu z małym opóźnieniem.
7. Hadoop to nie hurtownia danych, tylko rozproszony system przetwarzania (plików). RDBMS: schemat przed zapisem, szybkie odczyty, transakcje. Hadoop: schemat przy odczycie, szybkie zapisy, przetwarzanie masowe.
8. Rdzeń Hadoopa: HDFS + MapReduce; w Hadoop v2 do rdzenia dochodzi YARN (Yet Another Resource Negotiator), przez który współpracują frameworki.
9. Ekosystem: Spark (in-memory), Pig (skrypty, Pig Latin, UDF w Javie), Hive (SQL, HiveQL), MapReduce (batch), Storm (stream), Solr (wyszukiwanie pełnotekstowe), HBase (NoSQL, kolumnowa), Flume (logi do HDFS), HCatalog (metadane i tabele), Ambari (zarządzanie i monitorowanie, REST API), Oozie (workflow i harmonogramowanie), Sqoop.
10. Skala: do 6 tys. węzłów i ok. 500 PB na klaster, prawie miliard plików i bloków; do 40 węzłów w racku; klaster to zbiór racków.
11. Węzeł Hadoop = CPU + HDD; węzły można dodawać bez zmiany formatu danych, danych w klastrze ani zadań.
12. NameNode: metadane, mapowanie bloków na DataNode'y, cały obraz przestrzeni nazw w RAM, monitoruje liczbę replik. DataNode: przechowuje i przetwarza dane, okresowo raportuje do NameNode.
13. Blok HDFS: domyślnie 128 MB (także 64 MB; 256 MB zalecane) wobec 4 KB w UNIX; jeden blok HDFS to wiele bloków OS.
14. Replikacja 3: pierwsza replika na węźle w jednym racku, druga na losowym węźle w **innym** racku, trzecia na innym węźle w **tym samym racku co druga**. Potwierdzenia (ack) wracają łańcuchem 3 → 2 → 1 → NameNode. NameNode sprawdza replikację przed odpowiedzią klientowi.
15. Zapis: klient wysyła „Create” do NameNode, który sprawdza istnienie pliku i uprawnienia, a potem wskazuje DataNode. Odczyt: metadane z NameNode, dane bezpośrednio z DataNode'ów.
16. Komendy: `hadoop fs <args>` lub `hdfs dfs <args>`, np. `hdfs dfs -ls /`. URI: `scheme://authority/path` (`file`, `hdfs`); domyślne wartości w `core-site.xml`.
17. `put` = `copyFromLocal` (lokalny → HDFS); `get` = `copyToLocal` (HDFS → lokalny); `getmerge` scala wiele plików w jeden lokalny; `setrep` zmienia replikację (`-R` rekurencyjnie, `-w` czeka na osiągnięcie).
18. HDFS nie jest w pełni zgodny z POSIX, ale obsługuje wiele poleceń POSIX (cat, chmod, chown, ls, mkdir, mv, rm, tail…).
19. Zaliczenie: kolokwium praktyczne (7./8. lab) 50% + projekt grupowy 2–3 osoby 50%; projekt w Apache Spark ze Spark Streaming i/lub MLlib; dane strumieniowe przez Apache Kafka; na ocenę bardzo dobrą oddać przed sesją.

---

<a id="wykład-1b"></a>

# Wykład 1B – HDInsight, Hive, HiveQL, Tez (s. 101–198)


### 1. Klaster Apache Hadoop w Azure HDInsight – dokończenie (s. 101–105)

#### Podsumowanie konfiguracji i koszty (s. 101–102)
- Ostatni krok kreatora „Create HDInsight cluster” to zakładka **Review + create** (wcześniej: Basics, Storage, Security + networking, Configuration + pricing). Komunikat „Validation succeeded”.
- Przykładowa konfiguracja: Hadoop 2.7.3 (HDI 3.6), Resource group `myResourceGroup`, region East US, cluster name `myHadoop`, login klastra `admin`, użytkownik SSH `sshuser`, Primary storage type: Azure Storage.
- **Cluster configuration**: Head – 2 węzły D12 v2 (4 rdzenie, 28 GB RAM); Worker – 4 węzły D4 v2 (8 rdzeni, 28 GB RAM).
- Kreator pokazuje szacowany koszt w USD za godzinę (bez rabatów subskrypcji i kosztów storage/transferu).
- **Opłaty za węzły naliczane są tak długo, jak długo klaster istnieje.**
- **Naliczanie zaczyna się w chwili utworzenia klastra i kończy w chwili jego usunięcia. Klastra nie da się wstrzymać (*Clusters cannot be paused*).**
- Cennik: https://azure.microsoft.com/en-us/pricing/details/hdinsight/ – tabela „Memory Optimized nodes for HDInsight” (region Germany North, USD, za godzinę):

| Instancja | vCPU | RAM | OS | Cena HDInsight | Razem |
|---|---|---|---|---|---|
| E2 v3 | 2 | 16 GB | $0.198/h | $0.049/h | $0.247/h |
| E4 v3 | 4 | 32 GB | $0.395/h | $0.099/h | $0.494/h |
| E8 v3 | 8 | 64 GB | $0.79/h | $0.198/h | $0.988/h |
| E16 v3 | 16 | 128 GB | $1.581/h | $0.395/h | $1.976/h |
| E20 v3 | 20 | 160 GB | $1.976/h | $0.494/h | $2.47/h |
| E32 v3 | 32 | 256 GB | $3.162/h | $0.789/h | $3.951/h |
| E64i v3 | 64 | 432 GB | $5.691/h | $1.579/h | $7.27/h |
| E64 v3 | 64 | 432 GB | $5.691/h | $1.579/h | $7.27/h |

#### Dostęp do Ambari i Hive View (s. 103–105)
- W portalu: strona klastra (`myCluster`, typ Hadoop 2.7, HDI 3.6, URL `https://myCluster.azurehdinsight.net`) → kafelek **Cluster dashboards** → **Ambari views**.
- Adres widoków Ambari: `https://myCluster.azurehdinsight.net/#/main/views`. Dostępne widoki: **YARN Queue Manager** (zarządzanie kolejkami YARN Capacity Scheduler), **Hive View 2.0** (tworzony automatycznie po dodaniu usługi Hive do klastra), **Tez View** (monitorowanie i debugowanie zadań Tez z zapytań Hive i skryptów Pig).
- W Hive View (zakładki QUERY, JOBS, TABLES, SAVED QUERIES, UDFs, SETTINGS) wpisuje się zapytanie w Worksheet, wybiera bazę (`default`) i klika **Execute**. Wyniki (np. z tabeli `hivesampletable`) można zapisać do HDFS (**SAVE TO HDFS**) lub pobrać jako CSV (**DOWNLOAD AS CSV**). Zakładki wyników: RESULTS, LOG, VISUAL EXPLAIN, TEZ UI.

```sql
SHOW TABLES;
```
Wyświetla listę tabel w bieżącej bazie danych.

- **Uwaga!** Widok Apache Hive nie jest dostępny w usłudze HDInsight 4.0. Podobnie na maszynie Cloudera Hortonworks 3.0 (wymaga 48 GB RAM): nowy interfejs Ambari dla Hive opiera się na terminalowym kliencie **Beeline**.

### 2. Apache Hive i HiveQL w Azure HDInsight (s. 106–109)

#### Czym jest Hive (s. 106)
- **Apache Hive** to system magazynu danych (*data storage/warehouse system*) dla Apache Hadoop.
- Hive pozwala **odpytywać** i **analizować** dane.
- Zapytania Hive pisze się w **HiveQL** – języku zapytań podobnym do SQL.

#### Sposoby korzystania z Hive w HDInsight (s. 106)

| Metoda | Zapytania interakcyjne | Przetwarzanie wsadowe | System operacyjny klienta |
|---|---|---|---|
| Narzędzia HDInsight dla Visual Studio Code | ✓ | ✓ | Linux, Unix, Mac OS X lub Windows |
| Narzędzia HDInsight dla Visual Studio | ✓ | ✓ | Windows |
| Widok programu Hive (Hive View) | ✓ | ✓ | Dowolny (przeglądarka) |
| **Klient usługi Beeline** (wyróżniony) | ✓ | ✓ | Linux, Unix, Mac OS X lub Windows |
| Interfejs API REST | – | ✓ | Linux, Unix, Mac OS X lub Windows |
| Windows PowerShell | – | ✓ | Windows |

#### Dokumentacja HiveQL (s. 107, 113)
- Hive Language Manual: https://cwiki.apache.org/confluence/display/Hive/LanguageManual
- Spis treści: Commands and CLIs (Commands, Hive CLI (old), Beeline CLI (new), Variable Substitution, HCatalog CLI); File Formats (Avro Files, ORC Files, Parquet, Compressed Data Storage, LZO Compression); Data Types; Data Definition Statements (DDL Statements, Bucketed Tables, Statistics (Analyze and Describe), Indexes, Archiving); Data Manipulation Statements (DML: Load, Insert, Update, Delete; Import/Export); Data Retrieval: Queries (Select, Group By, Sort/Distribute/Cluster/Order By, Transform and Map-Reduce Scripts, Operators and UDFs, XPath-specific Functions, Joins, Join Optimization, Union, Lateral View, Sub Queries, Sampling, Virtual Columns, Windowing and Analytics Functions, Enhanced Aggregation, Cube, Grouping and Rollup).

#### Apache Spark w HDInsight – notes Jupyter (s. 108–109)
- Slajd tytułowy „Apache Spark for cluster in Azure HDInsight”.
- Tworzenie notesu Jupyter: w portalu klastra Spark (Spark 2.3, HDI 3.6) → **Pulpity nawigacyjne klastra** → **Jupyter notebook** → w Jupyterze **New** → **PySpark** (dostępne także PySpark3, Spark; foldery PySpark i Scala).

### 3. Hive i Pig w ekosystemie Hadoop (s. 110–116)

#### Hive (s. 110, 112, 114)
- **Hive** – moduł stworzony przez **Facebooka** (Meta Platforms), który uruchamia Hadoop jako hurtownię danych z dialektem SQL o nazwie **HiveQL**.
- Przetwarzanie danych odbywa się przez dialekt SQL – HiveQL – który jest **językiem deklaratywnym**: opisuje się pożądany wynik (cel), a Hive sam wylicza, jak zbudować przepływ danych, by go osiągnąć (**inaczej niż w Pig, gdzie przepływ danych trzeba zbudować samemu**).
- W odróżnieniu od Pig (gdzie schemat jest wymagany) Hive **nie jest ograniczony do jednego schematu**.
- Podobnie jak SQL, HiveQL jest samodzielnym językiem relacyjnym, ale **nie jest Turing-zupełny**. Można go rozszerzyć funkcjami **UDF**, które spełniają założenia Turinga.
- Hadoop obsługuje dane nieustrukturyzowane, półustrukturyzowane i silnie ustrukturyzowane. **Hive skupia się na danych ustrukturyzowanych** i wykorzystuje Hadoop do obsługi dużych wolumenów danych.
- Hive to technologia, która **zamienia Hadoop w hurtownię danych** odpytywaną dialektem SQL (HiveQL). (Agenda: Overview, Pig, **Hive**, Jaql.)
- Czym jest Hive (s. 114):
  - warstwa przypominająca hurtownię danych (*data warehouse-like layer*) zbudowana na Hadoop,
  - pozwala zdefiniować strukturę dla nieustrukturyzowanych danych Big Data,
  - upraszcza analizę i odpytywanie dzięki skryptowemu językowi SQL – HiveQL.
- Diagram: **HADOOP CORE** (z WEBHDFS) jest podstawą, nad nią **DATA SERVICES**: FLUME, SQOOP, PIG, **HIVE**, HCATALOG, HBASE.

#### Pig (s. 111)
- Opracowany w **Yahoo Research w 2006 r.**, przekazany Apache Software Foundation w 2007 r.
- Język Pig nazywa się **Pig Latin** – jest to **język przepływu danych** (*data flow*):
  - elementy (węzły) łączy się ze sobą w program,
  - każdy węzeł przekształca dane, z których korzystają kolejne elementy i instrukcje.
- Pig może działać na złożonych strukturach danych, nawet wielokrotnie zagnieżdżonych.
- Motto: **„Pigs eat everything”** – Pig przyjmuje dowolny format wejściowy.

#### Czym Hive NIE jest (s. 115)
- **Nie jest relacyjną bazą danych** – Hive używa bazy do przechowywania metadanych, ale przetwarzane dane leżą w HDFS.
- **Nie jest przeznaczony do przetwarzania transakcyjnego online (OLTP)** – działa na Hadoop (system wsadowy, zadania mają duże opóźnienie i spory narzut), więc opóźnienie zapytań Hive jest zwykle wysokie, nawet dla małych zadań.
- **Nie nadaje się do zapytań czasu rzeczywistego ani aktualizacji na poziomie wierszy** – najlepiej sprawdza się w zadaniach wsadowych na dużych zbiorach niezmiennych danych (np. logi WWW).

#### Typowy scenariusz użycia (s. 116)
- Diagram: nieustrukturyzowane dane wejściowe w **HDFS** (przeznaczone do transformacji) → **wiele iteracji DAG** (transformacji danych) → ustrukturyzowane dane wyjściowe. Nad procesem stoi **Hive + Metastore** (baza danych przechowująca informacje o schemacie).
- Zastosowania: zapytania ad hoc, agregacje, analiza danych.
- HiveQL można rozszerzać o własne funkcje: skalarne (**UDF**), agregujące (**UDAF**) i tabelaryczne (**UDTF**).

### 4. Architektura Hive, uruchamianie i Metastore (s. 117–120)

#### Architektura (s. 117)
- Diagram „Hive Architecture Basics – System for querying and managing structured data”: **Web UI** (Management), **Hive CLI** (uruchamianie zapytań, przeglądanie tabel, polecenia „show”), **HDInsight** (Microsoft Windows Server) → **HiveQL** (przetwarzanie, kompilacja i optymalizacja zapytań) → Execution: **MapReduce** → **HDFS (lub HBase)** – składowanie danych. Z boku **Metastore** – przechowuje informacje o schemacie i zapewnia strukturę dla danych.
- Praca z Hive jest możliwa przez:
  - interfejs **JDBC/ODBC**,
  - interfejs **Web UI**,
  - **command line interface (CLI)** – stary,
  - **Beeline** – powłoka wiersza poleceń (CLI).
- Interfejsy dostępu służą do wydawania zapytań SQL lub DDL. Hive służy do wyszukiwania danych strukturalnych i korzysta z wielu pojęć relacyjnych baz danych (tabele, wiersze, kolumny, schematy). Informacje o schemacie Hive przechowuje w tzw. **metastore**.
- **Metastore** – komponent Hive, zwykle przechowywany w relacyjnej bazie danych, **domyślnie Apache Derby** (może to być dowolna relacyjna baza). Przechowuje informacje o schemacie danych i zapewnia strukturę składowania.
- Na końcu wszystko jest konwertowane na zadania **DAG** lub **MapReduce**, które przetwarza klaster Hadoop.

#### Uruchamianie Hive z CLI (s. 118)
Trzy sposoby uruchomienia powłoki Hive:

```bash
hive                              # tryb interaktywny – powłoka hive bez polecenia
hive -f myscript                  # uruchomienie skryptu Hive (opcja -f + ścieżka do pliku)
hive -e 'SELECT * FROM mytable'   # pojedyncze polecenie inline (opcja -e + program w cudzysłowie)
```
Pierwsze polecenie otwiera interaktywną powłokę, drugie wykonuje skrypt z pliku, trzecie wykonuje jedno zapytanie podane w cudzysłowie.

#### Usługi Hive (s. 119)
```bash
hive --service servicename
```
Uruchamia wskazaną usługę Hive. `servicename` może być:
- **hiveserver** – serwer dla klientów Thrift, JDBC, ODBC (usługa przez sterownik ODBC lub JDBC),
- **hwi** – interfejs WWW (do tworzenia zapytań),
- **jar** – `hadoop jar` z bibliotekami Hive w classpath (uruchomienie polecenia hadoop z opcją jar),
- **metastore** – metastore poza procesem.
- **Hive Metastore** przechowuje metadane o strukturze danych.

#### Konfiguracje Metastore (s. 120)

| Konfiguracja | Metastore | Baza danych | Opis |
|---|---|---|---|
| **Embedded** (wbudowana) | w procesie | w procesie | kod Metastore działa w tym samym procesie co Hive |
| **Local** (lokalna) | w procesie | poza procesem | kod Metastore zostaje w procesie, a baza danych jest przeniesiona do osobnego procesu, z którym Metastore się komunikuje |
| **Remote** (zdalna) | poza procesem | poza procesem | sam Metastore jest wyniesiony poza proces; przydatne, gdy Metastore ma być współdzielony z innymi użytkownikami |

### 5. Schema-on-Read (s. 121)
- Hive pozwala zdefiniować schemat dla zbiorów danych i stosuje **schemat przy odczycie (Schema-On-Read)**.
- W większości baz danych schemat stosuje się **przy ładowaniu danych** (*schema-on-write*): rekordy wymagają definicji schematu, a ładowane dane muszą być z nim zgodne.
- Hive **odkłada zastosowanie schematu do chwili odczytu danych**.
- Zalety: **szybsze ładowanie danych** i możliwość użycia **wielu schematów dla tych samych danych**.
- Wada: **wolniejsze zapytania**.

### 6. HiveQL – możliwości (s. 122–125)

#### Funkcjonalności (s. 123)
- HiveQL (Hive Query Language) to **dialekt SQL**:
  - używa znanych pojęć baz danych (tabele, wiersze, kolumny, schematy),
  - **nie wspiera w pełni specyfikacji SQL-92**, jest podobny do dialektu **MySQL**,
  - można wykonać **INSERT OVERWRITE TABLE**, ale **nie można wykonywać UPDATE ani DELETE**,
  - **brak transakcji i indeksów**,
  - **brak** skorelowanych podzapytań, widoków zmaterializowanych i procedur składowanych.
- Obsługuje **wstawianie do wielu tabel naraz** (*multi-table inserts*) – daje dostęp do Big Data przez tabele.
- **Konwertuje zapytania SQL na zadania DAG (Tez) lub MapReduce** – użytkownik nie musi nic wiedzieć o DAG ani MapReduce.
- Obsługuje wtyczki ze skryptami użytkownika do wykonywania skryptów DAG i MapReduce.
- Podobnie jak Pig, Hive ma typy proste (np. **INT**, **STRING**) i złożone (**ARRAY**, **MAP**, **STRUCT**).

> Wyjaśnienie: slajd 123 opisuje starsze wersje Hive. Slajd 191 podaje już, że format ORC obsługuje transakcje ACID.

#### Funkcje wbudowane (s. 124–125)
```sql
SHOW FUNCTIONS;
```
Wyświetla listę wszystkich funkcji wbudowanych (np. ceil, coalesce, collect_list, collect_set, concat, concat_ws, count, current_date, current_timestamp, current_user, date_add, date_format, date_sub, datediff, day, dayofmonth, dense_rank, to_date, to_unix_timestamp, to_utc_timestamp, trim, unix_timestamp, upper, variance, weekofyear, xpath_…, year).

```sql
DESCRIBE FUNCTION ABS;
```
Wyświetla opis wskazanej funkcji; wynik: `ABS(x) - returns the absolute value of x`.

### 7. Tabele Hive (s. 126–133, 135)

#### Czym są tabele Hive (s. 127)
- Tabela Hive składa się z:
  - **danych** – zwykle pliku lub grupy plików w HDFS,
  - **schematu** – metadanych przechowywanych w relacyjnej bazie danych.
- **Schemat i dane są rozdzielone**:
  - schemat można zdefiniować dla już istniejących danych,
  - dane można dodawać i usuwać niezależnie od schematu,
  - Hive można „skierować” na istniejące dane.
- Jeśli w HDFS są już dane, których chcemy używać w Hive, trzeba zdefiniować dla nich schemat.

#### Tabele wewnętrzne i zewnętrzne (s. 128)
Jak inne bazy SQL, Hive używa tabel. Można tworzyć dwa rodzaje:

| Typ | Ładowanie | Skutek `DROP` |
|---|---|---|
| **Wewnętrzna** (*internal / managed*) | Hive **przenosi plik** do swoich katalogów danych | usuwane są **dane i metadane** |
| **Zewnętrzna** (*external*) | to tylko metadane opisujące dane | usuwane są **tylko metadane**, dane zostają na miejscu |

#### Format ORC (s. 129–131)
- **Apache ORC** (*Optimized Row Columnar*) – szybki **kolumnowy** format przechowywania danych dla obciążeń w Hadoop; bardzo wydajny sposób przechowywania danych Hive, zaprojektowany, by usunąć ograniczenia innych formatów plików Hive. Opis: https://orc.apache.org/, https://cwiki.apache.org/confluence/display/Hive/LanguageManual+ORC

```sql
CREATE TABLE <tablename> ... STORED AS ORC ...
```
Tworzy tabelę zapisaną w formacie pliku ORC.

**Zalety przechowywania w ORC:**
- jeden plik danych na każde zadanie, co odciąża **NameNode**,
- obsługa nowych typów danych: datetime, decimal i typów złożonych (struct, list, map, union),
- lekkie indeksy zapisane w pliku,
- pomijanie grup wierszy, które nie przechodzą filtrowania predykatem,
- operacje wyszukiwania w danym wierszu,
- kompresja blokowa zależna od typu danych,
- kodowanie słownikowe dla kolumn tekstowych,
- równoległy odczyt tego samego pliku przez osobne RecordReadery,
- dzielenie plików bez skanowania znaczników,
- metadane zapisane przez **Protocol Buffers**, co pozwala dodawać i usuwać pola.

**Struktura pliku ORC (s. 131):**
- Plik ORC składa się z grup danych wierszy, tzw. **pasków (*stripes*)**, oraz informacji pomocniczych w **stopce pliku** (*File Footer*). Na końcu pliku **postscript** zawiera parametry kompresji i rozmiar skompresowanej stopki.
- **Domyślny rozmiar paska: 250 MB.** Duże paski umożliwiają duże, wydajne odczyty z HDFS.
- Stopka pliku zawiera listę pasków, liczbę wierszy w każdym pasku i typ danych każdej kolumny, a także agregaty na poziomie kolumn: liczbę, min, max i sumę.
- Diagram: każdy pasek 250 MB składa się z **Index Data**, **Row Data** (dane ułożone kolumnami: Column 1…8) i **Stripe Footer**; na końcu pliku File Footer i Postscript.

#### Definiowanie tabeli (s. 132)
```sql
hive> CREATE TABLE mytable (name string, age int)
   ROW FORMAT DELIMITED
   FIELDS TERMINATED BY ';'
   STORED AS TEXTFILE;
```
Tworzy tabelę tekstową, w której każdy wiersz to tekst z polami rozdzielonymi separatorem.
- Opisy na slajdzie: `ROW FORMAT DELIMITED` – każdy wiersz to tekst rozdzielany przecinkami; „instrukcje HiveQL kończą się średnikiem”.
- (na slajdzie: w `FIELDS TERMINATED BY` widać `';'`, a podpis mówi o tekście rozdzielanym przecinkami. Strzałka „kończą się średnikiem” wskazuje na separator, choć dotyczy średnika na końcu instrukcji. W klasycznej wersji tego przykładu jest `FIELDS TERMINATED BY ','`.)

#### Tabele tymczasowe i import przez Hive View (s. 133, 189)
- Diagram „Temporary Tables – Created, Loaded, Deleted”: `geolocation.csv` → **LOAD** → Temporary table B (CSV) → **SQL** → tabela **Geolocation (ORC)**; `trucks.csv` → **LOAD** → Temporary table T (CSV) → **SQL** → tabela **Trucks (ORC)**. Tabele tymczasowe są tworzone, ładowane i usuwane; docelowe tabele są w ORC.
- W Hive View: zakładka **TABLES** (1) → przycisk „+” (2) → wybór tabeli, np. `trucks` (3); widać kolumny (driverid string, truckid string, model string, jun13_miles int, jun13_gas int …) oraz zakładki DDL, STORAGE INFORMATION, DETAILED INFORMATION, STATISTICS, AUTHORIZATION.

#### Zarządzanie tabelami (s. 135)

| Operacja | Składnia |
|---|---|
| Pokaż bieżące tabele | `hive> SHOW TABLES` |
| Sprawdź schemat | `hive> DESCRIBE mytable;` |
| Zmień nazwę tabeli | `hive> ALTER TABLE mytable RENAME to mt;` |
| Dodaj kolumnę | `hive> ALTER TABLE mytable ADD COLUMNS (mycol STRING);` |
| Usuń partycję | `hive> ALTER TABLE mytable DROP PARTITION (age=17)` |

```sql
SHOW TABLES;
DESCRIBE mytable;
ALTER TABLE mytable RENAME to mt;
ALTER TABLE mytable ADD COLUMNS (mycol STRING);
ALTER TABLE mytable DROP PARTITION (age=17);
```
Kolejno: lista tabel, schemat tabeli, zmiana nazwy, dodanie kolumny, usunięcie partycji `age=17`.

### 8. Partycjonowanie (s. 134)
- Partycjonowanie **może przyspieszyć niektóre zapytania**.
- **Dzieli dane według kolumny partycji**, czyli według wartości tej kolumny.
- Przy **tworzeniu tabeli** używa się klauzuli **PARTITION BY**, by wskazać kolumnę podziału danych.
- Przy **ładowaniu danych** klauzulą **PARTITION** wskazuje się, która partycja jest ładowana.

> Wyjaśnienie: w składni HiveQL klauzula przy tworzeniu tabeli to `PARTITIONED BY (kolumna typ)`, a przy ładowaniu `PARTITION (kolumna=wartość)`, np. `ALTER TABLE mytable DROP PARTITION (age=17)` ze s. 135. Slajd pisze skrótowo „PARTITION BY”.

### 9. Inne kluczowe operacje HiveQL (s. 136–143)

#### Ładowanie danych – LOAD DATA (s. 137–138)
```sql
hive> LOAD DATA LOCAL INPATH 'input/mydata/data.txt'
INTO TABLE myTable;
```
Importuje plik z lokalnego systemu plików do tabeli Hive (ścieżka wskazuje dane).
- Hive **nie modyfikuje plików** – ładuje je w obecnej postaci.
- Słowo **OVERWRITE** nadpisuje plik o tej samej nazwie.
- Domyślna lokalizacja hurtowni Hive: **`/hive/warehouse`**.
- Hive potrafi odczytać wszystkie pliki z danego katalogu.
- **Schemat jest sprawdzany przy odpytywaniu danych** – jeśli wiersz nie pasuje do schematu, zostanie odczytany jako **NULL**.

```sql
LOAD DATA LOCAL INPATH '/tmp/customers.csv' OVERWRITE INTO TABLE customers;
```
Ładuje plik z **lokalnego systemu plików** (słowo `LOCAL`) i nadpisuje dane tabeli `customers`.

```sql
LOAD DATA INPATH '/user/train/customers.csv' OVERWRITE INTO TABLE customers;
```
Ładuje plik z **HDFS** (bez `LOCAL`) i nadpisuje dane tabeli `customers`. (Na slajdzie: „wskazywany jest lokalny system HDFS”.)

```sql
INSERT INTO birthdays SELECT firstName, lastName, birthday FROM customers WHERE birthday IS NOT NULL;
```
Dopisuje do tabeli `birthdays` imiona, nazwiska i daty urodzenia klientów, którzy mają datę urodzenia.

#### INSERT (s. 139)
- `INSERT` służy do **zapełniania danymi** (*populate*) tabeli na podstawie innej tabeli Hive.
- Wyniki zapytań są zwykle duże, więc najlepiej użyć klauzuli INSERT, by wskazać Hive, gdzie zapisać wynik.
- Przykład: utworzenie tabeli i wstawienie do niej danych:

```sql
hive> CREATE TABLE age_count (name string, age int);
hive> INSERT OVERWRITE TABLE age_count
        SELECT age, COUNT(age)
        FROM mytable;
```
Tworzy tabelę `age_count` i nadpisuje ją wynikiem zliczenia wieku z `mytable`.
- (na slajdzie: kolumny `age_count` to `name string, age int`, a SELECT zwraca `age, COUNT(age)` bez `GROUP BY age` – zapytanie w tej postaci jest niespójne. Poprawnie byłoby np. `SELECT age, COUNT(age) FROM mytable GROUP BY age`.)

#### INSERT OVERWRITE (s. 140)
- **OVERWRITE zastępuje dane w tabeli**, w przeciwnym razie dane są **dopisywane**. Dopisanie polega na dodaniu plików do katalogu z danymi tabeli.

```sql
INSERT OVERWRITE newtable SELECT * FROM mytable;
```
Zastępuje zawartość `newtable` wszystkimi wierszami z `mytable`. (Na slajdzie brak słowa `TABLE`; pełna składnia to `INSERT OVERWRITE TABLE newtable …`.)

```sql
INSERT OVERWRITE DIRECTORY '/hdfs/myresult' SELECT * FROM mytable;
```
Zapisuje wynik zapytania **bezpośrednio do katalogu w HDFS**.

```sql
INSERT OVERWRITE LOCAL DIRECTORY ...
```
Zapisuje wynik zapytania do **katalogu w lokalnym systemie plików**.

#### Wykonywanie zapytań – SELECT (s. 141)
```sql
SELECT * FROM mytable;
```
Proste zapytanie zwracające wszystkie wiersze tabeli.
- Obsługiwane elementy:
  - klauzula **WHERE** (warunkowa, realizowana jako **operacja map**),
  - **UNION ALL** i **DISTINCT**,
  - **GROUP BY** i **HAVING**,
  - klauzula **LIMIT** – **zwracane wiersze są wybierane losowo**,
  - specyfikacja kolumn wyrażeniem regularnym (**REGEX Column Specification**):

```sql
SELECT '(ds|hr)?+.+' FROM sales;
```
Wybiera z tabeli `sales` wszystkie kolumny poza `ds` i `hr` (kolumny dobrane wyrażeniem regularnym).

#### Przykłady zapytań (s. 142)
```sql
SELECT * FROM customers;
```
Zwraca wszystkie wiersze tabeli `customers`.

```sql
SELECT COUNT(1) FROM customers;
```
Zlicza wiersze tabeli `customers`.

```sql
SELECT firstName, lastName, address, zip FROM customers WHERE orderID > 0 GROUP BY zip;
```
Wybiera dane klientów z `orderID > 0`, grupując po kodzie pocztowym (zaznaczone na slajdzie: **WHERE**, **GROUP BY**).

```sql
SELECT customers.*, orders.* FROM customers JOIN orders ON (customers.customerID = orders.customerID);
```
Łączy klientów z ich zamówieniami złączeniem wewnętrznym (**JOIN**).

```sql
SELECT customers.*, orders.* FROM customers LEFT OUTER JOIN orders ON (customers.customerID = orders.customerID);
```
Zwraca wszystkich klientów wraz z zamówieniami, także klientów bez zamówień (**LEFT OUTER JOIN**).

#### Podzapytania (s. 143)
- **Hive obsługuje podzapytania tylko w klauzuli FROM.** (Uwaga! Podzapytania są dostępne po słowie FROM.)

```sql
SELECT total FROM
   (SELECT c1 + c2 AS total FROM mytable) my_query;
```
Liczy sumę `c1 + c2` w podzapytaniu i zwraca ją w zapytaniu zewnętrznym; **podzapytanie musi mieć nazwę** (tu `my_query`).
- Kolumny z listy SELECT podzapytania są dostępne w zapytaniu zewnętrznym.

### 10. Złączenia i sortowanie (s. 144–146)

#### INNER JOIN (s. 144)
- **INNER JOIN** zwraca część wspólną dwóch tabel, czyli wiersze, które mają odpowiednik w drugiej tabeli.

```sql
SELECT * FROM students;
--   Steve  2.8
--   Raman  3.2
--   Mary   3.9
SELECT * FROM grades;
--   2.8  B
--   3.2  B+
--   3.9  A
SELECT students.*, grades.*
  FROM students JOIN grades ON
(students.grade = grades.grade);
--   Steve  2.8  2.8  B
--   Raman  3.2  3.2  B+
--   Mary   3.9  3.9  A
```
Łączy studentów z ocenami literowymi po wspólnej wartości `grade`.

#### Złączenia zewnętrzne (s. 145)
- Pozwalają znaleźć wiersze **bez dopasowania** w łączonych tabelach.
- Trzy rodzaje:

| Złączenie | Zwraca |
|---|---|
| **LEFT OUTER JOIN** | wiersz dla każdego wiersza **pierwszej** (lewej) tabeli |
| **RIGHT OUTER JOIN** | wiersz dla każdego wiersza **drugiej** (prawej) tabeli |
| **FULL OUTER JOIN** | wiersz dla każdego wiersza **z obu tabel** |

#### Sortowanie (s. 146)

| Klauzula | Działanie |
|---|---|
| **ORDER BY** | sortuje globalnie, ale **ustawia liczbę reducerów na 1** |
| **SORT BY** | **wiele reducerów**, każdy daje osobny posortowany plik |

### 11. Przykładowy tutorial Hive – dane baseballowe (s. 147–149)

#### Sekwencja zdarzeń (s. 147)
1. **Załaduj pliki do HDP** – `batting.csv` i `master.csv` do sandboxa.
2. **Utwórz tabelę** `temp_batting` (na razie pustą).
3. **Załaduj dane do Hive/HDFS** – plik `Batting.csv` do tabeli `temp_batting`.
4. **Odpytaj dane** – znajdź gracza z największą liczbą runów w każdym roku (1871–2011); rozszerz skrypt, by zamienić identyfikator gracza na imię i nazwisko.

#### Kroki (s. 148)
```sql
create table temp_batting (col_value STRING);
```
Tworzy tabelę tymczasową z jedną kolumną tekstową na całe wiersze pliku.

```sql
LOAD DATA INPATH '/user/sandbox/Batting.csv' OVERWRITE INTO TABLE temp_batting;
```
Ładuje plik `Batting.csv` z HDFS do tabeli `temp_batting`.

```sql
create table batting (player_id STRING, year INT, runs INT);
```
Tworzy tabelę z trzema kolumnami: identyfikator gracza, rok i liczba runów.

```sql
insert overwrite table batting
SELECT
  regexp_extract(col_value, '^(?:([^,]*)\,?){1}', 1) player_id,
  regexp_extract(col_value, '^(?:([^,]*)\,?){2}', 1) year,
  regexp_extract(col_value, '^(?:([^,]*)\,?){9}', 1) run
from temp_batting;
```
Wyciąga wyrażeniami regularnymi pola 1, 2 i 9 (player_id, year, runs) z wierszy `temp_batting` i kopiuje je do `batting`.
- Opis kroków: utwórz `temp_batting` na dane → załaduj `batting.csv` do `temp_batting` → wyodrębnij dane, by dało się z nimi pracować (nowa tabela z trzema kolumnami: player_id, year, liczba runów) → wyodrębnij potrzebne dane z `temp_batting` i skopiuj je do `batting` (trzy wywołania `regexp_extract` wyciągają pola player_id, year i run).
- (na slajdzie: po `temp_batting` stoją podwójne średniki `;;`.)

#### Kroki – ciąg dalszy (s. 149)
```sql
SELECT year, max(runs) FROM batting GROUP BY year
```
**Grupuje dane po roku** i zwraca maksymalną liczbę runów w każdym roku (np. 1871 → 66, 1872 → 94, 1873 → 125; pierwszy wiersz to NULL/NULL z nagłówka pliku).

```sql
SELECT a.year, a.player_id, a.runs from batting a
JOIN (SELECT year, max(runs) runs FROM batting GROUP BY year ) b
ON (a.year = b.year AND a.runs = b.runs) ;
```
**Pobiera identyfikator gracza** z najlepszym wynikiem w każdym roku – łączy tabelę z podzapytaniem z maksimami (np. 1871 barnero01 66, 1872 eggleda01 94).

### 12. Ambari Hive View 2.0 na sandboxie (s. 150, 185–188)
- Zapewnia interaktywny interfejs do Hive 2. Pozwala tworzyć, edytować, zapisywać i uruchamiać zapytania, a Hive wykonuje je jako zadania **MapReduce** lub **Tez**.
- Otwiera się go z menu widoków Ambari (ikona siatki → **Hive View 2.0**; w menu są też YARN Queue Manager, Files View, Hive View, Pig View, Storm View, Tez View, Workflow Manager).
- **Hive View 2.0 ma 6 kart:**
  1. **QUERY** – podstawowy interfejs do pisania, edycji i wykonywania nowych instrukcji SQL.
  2. **JOBS** – podgląd przeszłych i aktualnie wykonywanych zapytań.
  3. **TABLES** – jedno centralne miejsce do przeglądania, tworzenia, usuwania i zarządzania tabelami.
  4. **SAVED QUERIES** – zapytania zapisane przez bieżącego użytkownika.
  5. **UDFs** – funkcje zdefiniowane przez użytkownika: dodaje się je, wskazując plik JAR w HDFS i ścieżkę klasy Java z definicją UDF. Potem w Query Editorze pojawia się przycisk **Insert UDF**.
  6. **SETTINGS** – zmiana ustawień wpływających na zapytania wykonywane w widoku Hive.
- **Tworzenie tabeli kreatorem (s. 186–188):** TABLES → **NEW TABLE** → **UPLOAD TABLE** → Select File Format (File type CSV, Field Delimiter `,`, Escape Character `\`, Quote Character `"`, zaznaczone „Is first row header?”) → Select File Source (**Upload from HDFS**, ścieżka `/user/maria_dev/data/trucks.csv`) → **Preview** → podgląd tabeli (nazwy kolumn i dane) → nadanie nazwy `trucks` i typów kolumn (driverid STRING, truckid STRING, …, jan09_miles INT, jan09_gas INT) → **Create**.
- Slajd 189 powtarza diagram tabel tymczasowych (CSV → LOAD → tabela tymczasowa → SQL → ORC) ze s. 133.

### 13. Przykład: analiza danych MovieLens w Hive (s. 151–179)

#### Utworzenie bazy (s. 152)
```sql
create database movielens;
```
Tworzy bazę danych `movielens`.
- Kroki w Ambari Hive View: (1) wpisz polecenie w Query Editor, (2) **Execute**, (3) odśwież Database Explorer – pojawia się baza `movielens` (obok `default`, `foodmart`, `xademo`).

#### Import ocen – plik u.data (s. 153–155), skrót kroków
1. Z menu widoków wybierz **Hive View** → zakładka **Upload Table**.
2. Upload from Local, File type **CSV** → ikona ustawień (4).
3. **Field Delimiter: 9 TAB (horizontal tab)** (5).
4. **Select from local** → wybierz plik `u.data` (6).
5. Stored as: **ORC**, Database `default`, **Table name: `ratings`** (7).
6. **Nazwy kolumn** (8): `user_id`, `movie_id`, `rating`, `rating_time` – wszystkie **INT** (przykładowe wiersze: 196 242 3 881250949; 186 302 3 891717742).
7. Zatwierdź przyciskiem **Upload**.

#### Import tytułów filmów – plik u.item (s. 156)
- Analogicznie: **Field Delimiter: 124 `|`**, plik `u.item`, Stored as ORC, **Table name: `movie_names`** (9).
- Kolumny (10): `movie_id` INT, `name` STRING, `produce_date` STRING, dalej `column4`, `column5` (STRING; m.in. link IMDb). Przykład: 1 | Toy Story (1995) | 01-Jan-1995.
- Zatwierdź **Upload**.
- (na slajdzie: tabela nazywa się tu `movie_names`, a w późniejszych zapytaniach używana jest tabela `movies` z kolumną `name` lub `title`.)

#### Ustawienie silnika wykonawczego (s. 157–158)
- **Uwaga!** Silnik **Tez działa ok. 10× szybciej niż klasyczne zadania MR (bo buduje DAG)**, ale w istniejącym środowisku wirtualnym BLADE z kontrolerem macierzy dyskowej może nie działać lepiej.
- Kroki: (11) w Query Editorze kliknij ikonę ustawień (koło zębate) → (12) wybierz parametr **`hive.execution.engine`** → (13) wybierz wartość **`mr`** (dostępne: `tez`, `mr`) → (14) **Save Default Settings** – **obowiązkowo**.

> Wyjaśnienie: odpowiednik polecenia w HiveQL to `SET hive.execution.engine=mr;` – na slajdzie zmiana jest pokazana tylko w interfejsie.

#### Zapytanie: liczba ocen dla każdego filmu (s. 157, 160–162)
Pytanie (s. 160): Który film był najpopularniejszy, czyli miał najwięcej ocen? Inaczej: policz oceny każdego filmu; na jaki film ludzie najczęściej chodzą do kina?

```sql
SELECT movie_id, COUNT(movie_id) as RatingCount
from ratings
GROUP BY movie_id
order by RatingCount
DESC;
```
Zlicza oceny każdego filmu i sortuje filmy malejąco według liczby ocen.

- **Wizualizacja (s. 161):** (14) ikona wykresu po prawej stronie edytora → (15) zakładka Data Visualization: przeciągnij `movie_id` na oś **x**, `ratingcount` na oś **y** → wykres punktowy liczby ocen względem movie_id (do ok. 580 ocen).
- **Wyniki z tytułami (s. 162):** kolumny `m.title`, `ratingcount`: Star Wars (1977) – najwięcej ocen, Contact (1997) 509, Fargo (1996) 508, Return of the Jedi (1983) 507, Liar Liar (1997) 485, English Patient, The (1996) 481, Scream (1996) 478. Pytanie na slajdzie: „Film o ID=50 to…?” – odpowiedź: Star Wars (1977). Można wybrać typ wykresu (np. słupkowy).
- Slajd pokazuje tylko wynik; zapytania z łączeniem do tabeli filmów nie ma na slajdzie.

#### Pozostałe pytania ćwiczeniowe (s. 159, 163)
- (s. 159) Policz, ile głosów oddano na każdą ocenę (skala 1–5). Inaczej: czy ludzie chętniej dają filmom oceny pozytywne czy negatywne?
- (s. 163) Który film miał najmniej ocen?
- Na tych slajdach są tylko pytania, bez zapytań.

#### Najwyższa średnia ocena (s. 164–166, 181)
- **Zadanie (s. 164):** jakie tytuły mają najwyższą średnią ocen? Dodatkowo sprawdź, czy te dane są wiarygodne przy danej liczbie ocen filmu.
- **Wynik (s. 165):** kolumny `m.name`, `ratingavg`, `ratingcount`: Aiqing wansui (1994) 5.0 / 1, Star Kid (1997) 5.0 / 3, Someone Else's America (1995) 5.0 / 1, Saint of Fort Washington, The (1993) 5.0 / 2, Great Day in Harlem, A (1994) 5.0 / 1, Santa with Muscles (1996) 5.0 / 2, Prefontaine (1997) 5.0 / 3, They Made Me a Criminal (1939) 5.0 / 1, Marlene Dietrich: Shadow and Light (1996) 5.0 / 1, Entertaining Angels: The Dorothy Day Story (1996) 5.0 / 1, Pather Panchali (1955) 4.625 / 8.
- Czy dane są wiarygodne? **NIE – za mało ocen.**
- **Poprawione pytanie (s. 166):** jakie tytuły mają najwyższą średnią ocen **wśród filmów z liczbą ocen > 10**?

Zapytanie widoczne w edytorze na s. 181 (silnik Tez):

```sql
FROM (
SELECT m.NAME, AVG(r. rating) as RatingAVG,  COUNT(r.movie_id) as RatingCount
from ratings r inner join movies m on r.movie_id=m.movie_id
GROUP BY m.NAME
) a
select a.name, a.RatingAVG, a.RatingCount
WHERE a.RatingCount>10
order by a.RatingAVG
DESC;
```
Liczy średnią i liczbę ocen każdego filmu w podzapytaniu `a`, zostawia filmy z ponad 10 ocenami i sortuje je malejąco według średniej.

> Wyjaśnienie: zapytanie używa składni HiveQL „FROM-first” – `FROM (podzapytanie) alias SELECT …`. Podzapytanie stoi po FROM i ma nazwę (`a`), zgodnie z zasadą ze s. 143.

#### Praca domowa: najstarszy film ze średnią powyżej 4 (s. 167–174)
- **Treść (s. 167):** jaki jest **najstarszy** film z najwyższą średnią oceną (powyżej 4 gwiazdek)? Podaj tytuł(y). **Uwaga:** w Hive trzeba przekonwertować datę, by analiza była możliwa.
- **Analiza (s. 168):** trzeba sortować po dacie (najstarszy film). Należy przeanalizować opis danych (**README.txt**) i same dane:

```sql
SELECT * FROM ratings LIMIT 100;
```
Wyświetla pierwsze 100 wierszy tabeli `ratings` (kolumny `user_id`, `movie_id`, `rating`, `rating_time`; czas zapisany jako liczba, np. 881250949).

- **Wniosek:** datę trzeba przekonwertować do postaci, którą da się sortować.
- Opisy funkcji dat: https://www.educba.com/date-functions-in-hive/, https://cwiki.apache.org/confluence/display/hive/languagemanual+udf#LanguageManualUDF-DateFunctions, https://sqlandhadoop.com/hive-date-functions-all-possible-date-operations/
- **Wynik (s. 173):** kolumny `ratingavg`, `mov_id`, `name`, `mdate`: 4.15 / 493 / Thin Man, The (1934) / 1934-01-01; 4.0123… / 604 / It Happened One Night (1934) / 1934-01-01; 4.0508… / 615 / 39 Steps, The (1935); 4.0476… / 1203 / Top Hat (1935); 613 / My Man Godfrey (1936); 633 / Christmas Carol, A (1938); 4.0772… / 132 / Wizard of Oz, The (1939). Najstarsze filmy: **Thin Man, The (1934)** i **It Happened One Night (1934)**.
- W zapytaniu (którego tekstu nie ma na slajdzie; strzałki wskazują puste miejsce) używa się trzech funkcji: **`unix_timestamp`** (zamiana daty-tekstu na liczbę sekund od epoki Unix), **`from_unixtime`** (zamiana liczby sekund na datę `yyyy-MM-dd HH:mm:ss`) i **`to_date`** (wyciągnięcie samej daty `yyyy-MM-dd`).
- Pytanie: dlaczego agregujemy po dacie premiery filmu? Odpowiedź: **bo ten sam film ma wiele ocen.**
- Czy dane są wiarygodne przy tej liczbie ocen? **„Powiedzmy, że tak.”**
- **Praca domowa (s. 174):** następnie sprawdź w Hive, czy to rzeczywiście najstarszy film.

#### Funkcje dat w Hive (s. 169–172)

Tabela z dokumentacji (s. 169):

| Typ zwracany | Funkcja | Opis |
|---|---|---|
| timestamp | `from_utc_timestamp({dowolny typ prosty} ts, string timezone)` | zamienia znacznik czasu z UTC na podaną strefę (od Hive 0.8.0); wartości ułamkowe traktowane jako sekundy, całkowite jako milisekundy; np. `from_utc_timestamp(2592000.0,'PST')`, `from_utc_timestamp(2592000000,'PST')` i `from_utc_timestamp(timestamp '1970-01-30 16:00:00','PST')` zwracają 1970-01-30 08:00:00 |
| timestamp | `to_utc_timestamp({dowolny typ prosty} ts, string timezone)` | zamienia znacznik czasu z podanej strefy na UTC (od Hive 0.8.0); analogiczne przykłady zwracają 1970-01-31 00:00:00 |
| timestamp | `current_timestamp` | bieżący znacznik czasu z początku wykonywania zapytania (od Hive 1.2.0); wszystkie wywołania w jednym zapytaniu zwracają tę samą wartość |
| string | `from_unixtime(bigint unixtime[, string pattern])` | zamienia liczbę sekund od epoki (1970-01-01 00:00:00 UTC) na tekst ze znacznikiem czasu w bieżącej strefie (`hive.local.time.zone`) według wzorca; domyślnie `uuuu-MM-dd HH:mm:ss` lub `yyyy-MM-dd HH:mm:ss`; np. `from_unixtime(0)=1970-01-01 00:00:00`. Od Hive 4.0.0 właściwość `hive.datetime.formatter` steruje implementacją formatera; wcześniejsze wersje używały `SimpleDateFormat` |
| string | `add_months(string start_date, int num_months, output_date_format)` | data o `num_months` miesięcy po `start_date` (od Hive 1.1.0); jeśli `start_date` to ostatni dzień miesiąca albo docelowy miesiąc ma mniej dni, wynikiem jest ostatni dzień miesiąca; domyślny format `yyyy-MM-dd`; przed Hive 4.0.0 część czasu jest ignorowana, od 4.0.0 można podać format wyjściowy; np. `add_months('2009-08-31', 1)` → `'2009-09-30'`, `add_months('2017-12-31 14:15:16', 2, 'YYYY-MM-dd HH:mm:ss')` → `'2018-02-28 14:15:16'` |
| string | `last_day(string date)` | ostatni dzień miesiąca, do którego należy data (od Hive 1.1.0); format `yyyy-MM-dd HH:mm:ss` lub `yyyy-MM-dd`, część czasu ignorowana |

Przykłady ze slajdów 170–172 (z wynikami):

```sql
select current_date();
```
Zwraca bieżącą datę systemową bez części czasu (wynik: `2023-11-20`).

```sql
select current_timestamp() DateTime;
```
Zwraca pełną bieżącą datę i godzinę (wynik: `2023-11-20 22:16:18.832`).

```sql
select unix_timestamp();
```
Zwraca bieżący czas jako liczbę sekund od epoki Unix, w domyślnej strefie czasowej (wynik: `1700519026`).

```sql
select unix_timestamp('2023-01-01 00:00:00');
```
Zamienia datę w formacie `yyyy-MM-dd HH:mm:ss` na liczbę sekund od epoki Unix; przy błędzie zwraca 0 (wynik: `1672531200`).

```sql
select unix_timestamp('2023-01-01 00:00:00', 'yyyy-MM-dd');
```
Zamienia datę zapisaną według podanego wzorca na liczbę sekund od epoki Unix; przy błędzie zwraca 0 (wynik: `1672531200`).

```sql
select from_unixtime(unix_timestamp());
```
Zamienia liczbę sekund od epoki Unix na datę w formacie `yyyy-MM-dd HH:mm:ss` (wynik: `2023-11-20 22:25:39`).

```sql
select from_utc_timestamp('1990-01-01 09:00:00', 'JST');
```
Przelicza czas z UTC na strefę podaną w drugim argumencie (wynik: `1990-01-01 18:00:00.0`).

```sql
select to_utc_timestamp ('1990-02-13 00:00:00','America/Denver');
```
Przelicza czas z podanej strefy na UTC (wynik: `1990-02-13 07:00:00.0`).

```sql
select to_date ('1990-01-01 01:57:30');
```
Zwraca samą datę ze znacznika czasu w formacie `yyyy-MM-dd` (wynik: `1990-01-01`).

```sql
select date_add ('2020-01-01', 5);
```
Dodaje podaną liczbę dni do daty (wynik: `2020-01-06`).

```sql
select date_sub ('2020-01-01', 5);
```
Odejmuje podaną liczbę dni od daty (wynik: `2019-12-27`).

```sql
select date_diff('2020-01-01','2019-01-01');
```
Zwraca różnicę między dwiema datami w dniach (slajd nie podaje wyniku).
- (na slajdzie: `date_diff`; na liście `SHOW FUNCTIONS` ze s. 124 funkcja nazywa się `datediff`.)

#### Praca domowa: ulubione gatunki kobiet i mężczyzn (s. 175–179)
- **Treść (s. 175):** jakie gatunki filmów najczęściej oglądały kobiety, a jakie mężczyźni?

**Krok 1 (s. 176) – tabela użytkowników:**
```sql
CREATE TABLE users (user_id INT, age INT, gender STRING, occupation STRING,
zip_code INT) ROW FORMAT DELIMITED STORED AS TEXTFILE;
```
Tworzy tekstową tabelę `users` z danymi demograficznymi użytkowników; następnie importuje się do niej plik `user.csv`.

**Krok 2 (s. 179) / krok 3 (s. 177) – widok z sumami gatunków i LATERAL VIEW** (oba slajdy mają identyczny kod; na s. 179 opisany jako „Step: 2”, na s. 177 jako „Step: 3” – „dodajemy kolumny Lateral View”):

```sql
CREATE VIEW IF NOT EXISTS TopCategory
as
SELECT us.gender,
       SUM(m.unknown) Unknown,'Unknown' Unk1, SUM(m.action) Action, 'Action' Act1, SUM(m.adventure) Adventure, 'Adventure' Adv1,
SUM(m.animation) Animation, 'Animation' Ani1,
       SUM(m.childrens) Childrens, 'Childrens' Chi1,
       SUM(m.comedy) Comedy, 'Comedy' Com1, SUM(m.crime) Crime, 'Crime' Cri1, SUM(m.documentary) Documentary,'Documentary'
Doc1, SUM(m.drama) Drama,'Drama' Dra1, SUM(m.fantasy) Fantasy, 'Fantasy' Fan1,
       SUM(m.filmnoir) Film_noir,'Film_noir' Fil1,
       SUM(m.horror) Horror, 'Horror' Hor1, SUM(m.musical) Musical, 'Musical' Mus1, SUM(m.mystery) Mystery, 'Mystery' Mys1,
SUM(m.romance) Romance, 'Romance' Rom1, SUM(m.scifi) Sci_fi, 'Sci_fi' Sci1,
       SUM(m.thriller) Thriller, 'Thriller' Thr1,
       SUM(m.war) War, 'War' War1, SUM(m.western) Western, 'Western' Wes1
    FROM users us
    INNER JOIN ratings r
    ON us.user_id = r.user_id
    INNER JOIN movies m
    ON r.movie_id = m.movie_id
    GROUP BY us.gender;
```
Tworzy (jeśli nie istnieje) widok `TopCategory`: dla każdej płci sumuje flagi gatunków (0/1) ocenionych filmów i dokłada do każdej sumy stałą z nazwą gatunku (np. `'Drama' Dra1`).

```sql
SELECT tc.gender, tf.key, tf.value  FROM TopCategory tc
lateral VIEW explode(map(Unk1,Unknown, Act1,Action, Adv1,Adventure, Ani1,Animation, Chi1,Childrens, Com1,Comedy, Cri1,Crime, Doc1,Documentary,
Dra1,Drama, Fan1,Fantasy,
Fil1,Film_noir, Hor1,Horror, Mus1,Musical, Mys1,Mystery, Rom1,Romance, Sci1,Sci_fi, Thr1,Thriller, War1,War, Wes1,Western))
tf AS key,value;
```
Zamienia kolumny gatunków na wiersze: `map(nazwa, suma, …)` buduje mapę gatunek → liczba, a `LATERAL VIEW explode(...) tf AS key,value` rozwija ją na pary (płeć, gatunek, liczba).

**Krok 4 (s. 178) – UNION ALL dla obu płci:**
```sql
SELECT u1.*
FROM (
SELECT tc.gender, tf.key, tf.value  FROM TopCategory tc
lateral VIEW explode(map(Unk1,Unknown, Act1,Action, Adv1,Adventure, Ani1,Animation, Chi1,Childrens, Com1,Comedy, Cri1,Crime, Doc1,Documentary, Dra1,Drama, Fan1,Fantasy,
Fil1,Film_noir, Hor1,Horror, Mus1,Musical, Mys1,Mystery, Rom1,Romance, Sci1,Sci_fi, Thr1,Thriller, War1,War, Wes1,Western))
tf AS key,value
where tc.gender = 'F'
order by tf.value desc limit 1) u1
union all
SELECT u2.*
FROM (SELECT tc.gender, tf.key, tf.value  FROM TopCategory tc
lateral VIEW explode(map(Unk1,Unknown, Act1,Action, Adv1,Adventure, Ani1,Animation, Chi1,Childrens, Com1,Comedy, Cri1,Crime, Doc1,Documentary, Dra1,Drama, Fan1,Fantasy,
Fil1,Film_noir, Hor1,Horror, Mus1,Musical, Mys1,Mystery, Rom1,Romance, Sci1,Sci_fi, Thr1,Thriller, War1,War, Wes1,Western))
tf AS key,value
where tc.gender = 'M'
order by tf.value desc limit 1) u2;
```
Dla kobiet (`'F'`) i mężczyzn (`'M'`) osobno wybiera gatunek z największą liczbą ocen (`order by … desc limit 1` w nazwanych podzapytaniach `u1`, `u2`) i skleja oba wyniki przez **UNION ALL**. (Slajd 178 powtarza też całe `CREATE VIEW` z kroku 2/3.)

- **Wynik:**

| _u1.gender | _u1.key | _u1.value |
|---|---|---|
| F | Drama | 11008 |
| M | Drama | 28887 |

Zarówno kobiety, jak i mężczyźni najczęściej oglądali **dramaty**.

### 14. Silnik Tez (s. 180–184)
- https://tez.apache.org/
- **Apache Tez** pozwala zbudować szkielet, który składa **ukierunkowany graf acykliczny (DAG – *directed acyclic graph*)** zadań przetwarzania danych.
- Dzięki temu projekty takie jak **Apache Hive i Apache Pig** mogą uruchamiać złożone zadania DAG.
- **Dwa główne motywy projektowe Tez:**
  1. zwiększenie możliwości użytkowników końcowych,
  2. wydajność wykonania:
     - wzrost wydajności w porównaniu z MR,
     - optymalne zarządzanie zasobami,
     - dynamiczne decyzje dotyczące fizycznego przepływu danych.
- **Diagram „Pig/Hive – MR” vs „Pig/Hive – Tez”:** w MR zadanie składa się z kilku osobnych zadań MapReduce (węzły mapujące → węzły redukcyjne), a wyniki pośrednie każdego etapu trafiają do HDFS (chmurki między etapami). W Tez to samo przetwarzanie jest jednym DAG-iem: węzły redukcyjne przekazują dane bezpośrednio kolejnym węzłom, bez zapisu pośredniego do HDFS.
- **Tez View w Ambari (s. 181):** menu widoków → **Tez View** → lista Hive Queries (Query ID, User, Status, Query, **DAG ID**, Tables Read, Tables Written, App ID, Queue, Execution Mode…). Zapytanie ze średnią ocen (> 10 ocen) ma np. DAG `dag_1604660499624_0045_1` i status SUCCEEDED.
- **Szczegóły DAG (s. 182):** zakładki DAG Details, DAG Counters, Graphical View, All Vertices, All Tasks, All Task Attempts, Vertex Swimlane. Przykład: status SUCCEEDED, czas trwania 5 s 143 ms, 4 wierzchołki (Map 4, Map 1, Reducer 3, Reducer 2), 4 zadania, 0 nieudanych i 0 zabitych.
- **Graphical View (s. 183):** tabele wejściowe `m` (movies) → Map 4 i `r` (ratings) → Map 1 → Reducer 2 → Reducer 3 → `out_Reducer` (wyjście).
- **Vertex Swimlane (s. 184):** oś czasu (ms, ok. 0–4800) pokazująca, kiedy działały kolejne wierzchołki: Map 4, Map 1, Reducer 2, Reducer 3, oraz pasek zbiorczy (Consolidated).

### 15. Odwoływanie się do tabel Hive poleceniami SQL (s. 190)
- Część 3: „Referencing Hive tables with SQL commands” – **bez kreatora Ambari**, samymi poleceniami DDL.
- Dokumentacja: https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL (Hive Data Definition Language: Overview; Keywords, Non-reserved Keywords and Reserved Keywords; Create/Drop/Alter/Use Database; Create/Drop/Truncate Table; Alter Table/Partition/Column; Create/Drop/Alter View…).

### 16. Formaty przechowywania (s. 191)
Hive obsługuje wbudowane i własne formaty plików (szczegóły kompresji: CompressedStorage).

| Format | Opis |
|---|---|
| `STORED BY` | tabela w formacie nienatywnym, np. tworzenie lub podpięcie tabeli opartej na **HBase**, **Druid** lub **Accumulo** (zob. StorageHandlers) |
| **`STORED AS TEXTFILE`** | zwykłe pliki tekstowe. **TEXTFILE to domyślny format**, chyba że parametr `hive.default.fileformat` ustawiono inaczej. Pliki z separatorami czyta się klauzulą `DELIMITED`. Separator można poprzedzić znakiem ucieczki klauzulą `ESCAPED BY` (np. `ESCAPED BY '\'`) – potrzebne, gdy dane mogą zawierać znaki separatora. Własny zapis NULL ustawia się klauzulą `NULL DEFINED AS` (domyślnie `'\N'`) |
| `STORED AS SEQUENCEFILE` | skompresowany plik Sequence File |
| `STORED AS RCFILE` | format Record Columnar File |
| `STORED AS PARQUET` | kolumnowy format Parquet od Hive 0.13.0; w Hive 0.10, 0.11, 0.12 składnia `ROW FORMAT SERDE ... STORED AS INPUTFORMAT ... OUTPUTFORMAT ...` |
| **`STORED AS ORC`** | format ORC. **Obsługuje transakcje ACID i optymalizator kosztowy (CBO). Przechowuje metadane na poziomie kolumn** |
| **`STORED AS JSONFILE`** | format JSON od Hive 4.0.0 |
| `STORED AS AVRO` | format Avro od Hive 0.14.0 (zob. Avro SerDe) |

### 17. Typy danych Hive (s. 192–194)

#### Typy proste (s. 192)
Typy są przypisane do kolumn tabel.

| Grupa | Typ | Opis |
|---|---|---|
| Liczby całkowite | `TINYINT` | 1-bajtowa liczba całkowita |
| | `SMALLINT` | 2-bajtowa liczba całkowita |
| | `INT` | 4-bajtowa liczba całkowita |
| | `BIGINT` | 8-bajtowa liczba całkowita |
| Typ logiczny | `BOOLEAN` | TRUE / FALSE |
| Liczby zmiennoprzecinkowe | `FLOAT` | pojedyncza precyzja |
| | `DOUBLE` | podwójna precyzja |
| Liczby stałoprzecinkowe (na slajdzie: „o ustalonej liczbie znaków”) | `DECIMAL` | wartość stałoprzecinkowa o skali i precyzji określonej przez użytkownika |
| Typy tekstowe | `STRING` | ciąg znaków w określonym zestawie znaków |
| | `VARCHAR` | ciąg znaków o **maksymalnej** długości |
| | `CHAR` | ciąg znaków o **stałej** długości |
| Data i czas | `TIMESTAMP` | data i godzina **bez strefy czasowej** (semantyka „LocalDateTime”) |
| | `TIMESTAMP WITH LOCAL TIME ZONE` (na slajdzie: „TIMESTAMP Z LOKALNĄ STREFĄ CZASOWĄ”) | moment w czasie z dokładnością do nanosekund (semantyka „Instant”) |
| | `DATE` (na slajdzie: „DATA”) | data |
| Typy binarne | `BINARY` | ciąg bajtów |

#### Hierarchia typów i niejawna konwersja (s. 193)
- Hierarchia (rodzic jest nadtypem wszystkich dzieci):
  - Type
    - Primitive Type
      - Number
        - DOUBLE
          - FLOAT
            - BIGINT
              - INT
                - SMALLINT
                  - TINYINT
          - STRING
      - BOOLEAN
- Hierarchia określa, jak typy są niejawnie konwertowane w języku zapytań.
- **Niejawna konwersja jest dozwolona od potomka do przodka.** Gdy wyrażenie oczekuje typu 1, a dane są typu 2, typ 2 zostanie niejawnie przekonwertowany na typ 1, jeśli typ 1 jest przodkiem typu 2.
- Hierarchia pozwala na **niejawną konwersję STRING → DOUBLE**.

#### Typy złożone (s. 194)
Typy złożone buduje się z typów prostych i innych typów złożonych:

| Typ | Dostęp do elementu | Przykład |
|---|---|---|
| **Struktura** (`STRUCT`) | notacja kropkowa `.` | kolumna `c` typu `STRUCT {a INT; b INT}` → pole: `c.a` |
| **Mapa** (`MAP`, krotki klucz–wartość) | `['nazwa elementu']` | w mapie `M` z odwzorowaniem `'grupa'` → gid wartość gid to `M['grupa']` |
| **Tablica** (`ARRAY`, lista indeksowana) | `[n]`, indeks od **zera**; elementy muszą być **tego samego typu** | dla `A = ['a', 'b', 'c']` wyrażenie `A[1]` zwraca `'b'` |

- Typy złożone można dowolnie zagnieżdżać. Przykład: typ Użytkownik może mieć pola `płeć` (STRING) i `active` (BOOLEAN).

### 18. Timestamp – semantyka (s. 195–196)
- Znaczniki czasu były źródłem wielu nieporozumień.
- **`TIMESTAMP` (semantyka „LocalDateTime”)** – znaczniki Java „LocalDateTime” zapisują datę i godzinę jako rok, miesiąc, dzień, godzinę, minutę i sekundę **bez strefy czasowej**. Mają zawsze tę samą wartość, niezależnie od lokalnej strefy. Np. „2014-12-12 12:34:56” rozkłada się na pola daty i czasu bez informacji o strefie – nie odpowiada żadnej konkretnej chwili.
- Jeśli aplikacja nie używa konsekwentnie UTC, **znacznik czasu z lokalną strefą czasową jest dla większości aplikacji zdecydowanie lepszy**: gdy użytkownik mówi, że zdarzenie jest o 10:00, ma na myśli konkretną strefę i punkt w czasie, a nie 10:00 w dowolnej strefie.
- **`TIMESTAMP WITH LOCAL TIME ZONE` (semantyka „Instant”)** – znaczniki Java „Instant” wyznaczają moment w czasie, który pozostaje stały niezależnie od miejsca odczytu. Wartość jest dostosowywana do lokalnej strefy czasowej, aby odpowiadała pierwotnemu punktowi w czasie.

| Typ | Wartość w America/Los_Angeles | Wartość w America/New_York |
|---|---|---|
| timestamp with local time zone (na slajdzie: „sygnatura czasowa z lokalną strefą czasową”) | 2014-12-12 12:34:56 | **2014-12-12 15:34:56** |
| timestamp (na slajdzie: „znak czasu”) | 2014-12-12 12:34:56 | 2014-12-12 12:34:56 |

#### Porównanie z innymi narzędziami (s. 196)

| Typ | SQL 2003 | Oracle | Sybase | Postgres | MySQL | Microsoft SQL | IBM DB2 | Presto | Snowflake | Hive ≥ 3.1 | Iceberg | Spark |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| timestamp | Local | Local | Local | Local | Instant | Other | Local | Local | Local | **Local** | Local | Instant |
| timestamp with local time zone | | Instant | | | | | | | Instant | **Instant** | | |
| timestamp with time zone | Offset | Offset | Offset | Instant | | | Offset | Offset | Offset | | Instant | |
| timestamp without time zone | Local | Local | | Local | | | Local | | | | | |

### 19. Wielkość liter i funkcje wbudowane (s. 197–198)
- **Wszystkie słowa kluczowe Hive są niewrażliwe na wielkość liter (*case-insensitive*), łącznie z nazwami operatorów i funkcji Hive.**
- Funkcje wbudowane (*Built In Functions*), zob.: https://cwiki.apache.org/confluence/display/Hive/Tutorial#Tutorial-Custommap%2Freducescripts

---

#### Najważniejsze do zapamiętania
1. Klastra HDInsight **nie da się wstrzymać** – opłaty biegną od utworzenia do usunięcia klastra.
2. **Hive** stworzył **Facebook**, **Pig** – **Yahoo** (2006). HiveQL jest **deklaratywny**, Pig Latin to **język przepływu danych**. Motto Pig: „Pigs eat everything”.
3. HiveQL **nie jest Turing-zupełny** – rozszerza się go funkcjami **UDF** (skalarne), **UDAF** (agregujące) i **UDTF** (tabelaryczne).
4. Hive **nie jest** relacyjną bazą, systemem OLTP ani narzędziem do zapytań czasu rzeczywistego i aktualizacji wierszy – służy do zadań **wsadowych** na dużych, niezmiennych danych (np. logi WWW).
5. **Metastore** przechowuje metadane (schemat). Domyślna baza to **Apache Derby**. Konfiguracje: **Embedded** (metastore i baza w procesie), **Local** (metastore w procesie, baza poza nim), **Remote** (oba poza procesem – do współdzielenia).
6. Dostęp do Hive: JDBC/ODBC, Web UI, Hive CLI (stary), **Beeline** (nowy). Uruchamianie: `hive` (interaktywnie), `hive -f skrypt`, `hive -e 'zapytanie'`, `hive --service hiveserver|hwi|jar|metastore`.
7. **Schema-on-Read**: schemat stosowany przy odczycie → **szybkie ładowanie** i wiele schematów dla tych samych danych, ale **wolniejsze zapytania**. Wiersz niezgodny ze schematem jest czytany jako **NULL**.
8. HiveQL jest podobny do **MySQL**, nie wspiera w pełni SQL-92. Według slajdu: **brak UPDATE/DELETE, transakcji, indeksów**, skorelowanych podzapytań, widoków zmaterializowanych i procedur składowanych. Jest **INSERT OVERWRITE TABLE** i **multi-table insert**.
9. Zapytania są tłumaczone na zadania **DAG (Tez)** lub **MapReduce**.
10. Tabela **wewnętrzna (managed)**: `DROP` usuwa **dane i metadane**. Tabela **zewnętrzna**: `DROP` usuwa **tylko metadane**.
11. **ORC** (Optimized Row Columnar) to format **kolumnowy**: `CREATE TABLE t ... STORED AS ORC`. Ma paski (*stripes*) o domyślnym rozmiarze **250 MB**, każdy z Index Data, Row Data i Stripe Footer, a na końcu pliku File Footer i Postscript. Jeden plik na zadanie odciąża **NameNode**. Obsługuje **ACID** i **CBO**.
12. **TEXTFILE** to domyślny format (`hive.default.fileformat`). Inne: SEQUENCEFILE, RCFILE, PARQUET, ORC, JSONFILE (od Hive 4.0.0), AVRO. `STORED BY` – tabele nienatywne (HBase, Druid, Accumulo). Domyślny zapis NULL: `'\N'`.
13. Składnia definicji tabeli: `CREATE TABLE mytable (name string, age int) ROW FORMAT DELIMITED FIELDS TERMINATED BY ';' STORED AS TEXTFILE;` – instrukcje HiveQL kończą się średnikiem.
14. `LOAD DATA LOCAL INPATH '...'` – plik z **lokalnego** systemu plików; `LOAD DATA INPATH '...'` – plik z **HDFS**. `OVERWRITE INTO TABLE` nadpisuje dane, bez OVERWRITE dane są **dopisywane**. Hive **nie modyfikuje** ładowanych plików. Domyślna hurtownia: `/hive/warehouse`.
15. `INSERT OVERWRITE TABLE t SELECT …` zastępuje dane. `INSERT OVERWRITE DIRECTORY '/hdfs/…'` zapisuje do **HDFS**, `INSERT OVERWRITE LOCAL DIRECTORY …` – do **lokalnego** systemu plików.
16. **Partycjonowanie**: przy tworzeniu tabeli klauzula PARTITION(ED) BY, przy ładowaniu `PARTITION`. Usunięcie partycji: `ALTER TABLE mytable DROP PARTITION (age=17)`.
17. Zarządzanie tabelami: `SHOW TABLES`, `DESCRIBE mytable;`, `ALTER TABLE mytable RENAME to mt;`, `ALTER TABLE mytable ADD COLUMNS (mycol STRING);`. Funkcje: `SHOW FUNCTIONS;`, `DESCRIBE FUNCTION ABS;`.
18. **Podzapytania tylko w klauzuli FROM** i **muszą mieć nazwę**: `SELECT total FROM (SELECT c1 + c2 AS total FROM mytable) my_query;`.
19. **WHERE** realizowane jest jako **operacja map**. **LIMIT** zwraca **losowe** wiersze. Można wybierać kolumny wyrażeniem regularnym: `SELECT '(ds|hr)?+.+' FROM sales;`.
20. **ORDER BY** – jeden reducer (sortowanie globalne). **SORT BY** – wiele reducerów, każdy daje osobny posortowany plik.
21. Złączenia: INNER JOIN (część wspólna), LEFT OUTER (wszystkie wiersze z **pierwszej** tabeli), RIGHT OUTER (wszystkie z **drugiej**), FULL OUTER (wszystkie z obu).
22. Silnik ustawia się parametrem **`hive.execution.engine`** (`tez` / `mr`). **Tez** jest ok. **10× szybszy** od MR, bo buduje **DAG** bez zapisu wyników pośrednich do HDFS.
23. Funkcje dat: `unix_timestamp()` (data → sekundy od epoki, przy błędzie 0), `from_unixtime()` (sekundy → `yyyy-MM-dd HH:mm:ss`), `to_date()` (sama data), `date_add`/`date_sub` (± dni), `datediff` (różnica w dniach), `from_utc_timestamp`/`to_utc_timestamp` (konwersja stref), `current_date`, `current_timestamp`.
24. **LATERAL VIEW explode(map(...)) tf AS key,value** zamienia kolumny na wiersze (klucz–wartość). W MovieLens zarówno kobiety (11008), jak i mężczyźni (28887) najczęściej oglądali **Drama**.
25. Typy: TINYINT (1 B), SMALLINT (2 B), INT (4 B), BIGINT (8 B). Złożone: STRUCT (`c.a`), MAP (`M['klucz']`), ARRAY (`A[n]`, indeks od 0, elementy jednego typu). Niejawna konwersja **od potomka do przodka**, także **STRING → DOUBLE**. `TIMESTAMP` = „LocalDateTime” (bez strefy), `TIMESTAMP WITH LOCAL TIME ZONE` = „Instant”. Słowa kluczowe, operatory i nazwy funkcji Hive są **case-insensitive**.

---

<a id=" klasyfikacja:wykład-2"></a>

# Wykład 2 – Spark MLlib


### 1. MLlib – biblioteka uczenia maszynowego Sparka (s. 1–4, 13, 30–31)

**Uczenie maszynowe na klastrze → biblioteka SparkML** (s. 1).

#### Czym jest MLlib (s. 2)

- Nagłówek slajdu: *Machine learning library (MLlib) → Spark 3.5*, pakiet `org.apache.spark.ml` (na slajdzie Spark 3.5, na dalszych slajdach – od s. 13 – Spark 4.x).
- MLlib pozwala wykonywać praktyczne operacje uczenia maszynowego w skalowalnym środowisku obliczeniowym. Dokumentacja: https://spark.apache.org/docs/latest/ml-classification-regression.html

MLlib oferuje m.in.:

| Obszar | Co zawiera |
|---|---|
| **ML algorithms** (algorytmy ML) | klasyfikacja, **regresja**, klasteryzacja (clustering), filtrowanie |
| **Functions** (funkcje) | ekstrakcja cech (feature extraction), transformacja, redukcja wymiarowości, selekcja cech |
| **Pipelines** | narzędzia do budowania, ewaluacji i strojenia potoków ML (ML Pipelines) |
| **Persistence** (trwałość) | zapisywanie i wczytywanie algorytmów, modeli i Pipeline'ów |
| **Utilities** (narzędzia) | algebra liniowa, statystyka, obsługa danych itd. |

- **Regresja** (dopisek przy „regression”) – pozwala opisać **kowariancję** kilku zmiennych przez dopasowanie do nich funkcji; umożliwia **przewidywanie** nieznanych wartości jednych wielkości na podstawie znanych wartości innych.
- Podstawowe API (na slajdzie: „od Spark 3.2”) opiera się na **DataFrame** (zbudowanym na **SparkSQL**). Ze względów utrzymaniowych zaleca się używać **DF zamiast RDD**.
  - API MLlib oparte na DataFrame zapewnia **jednolite API** dla algorytmów ML i wielu języków.
  - DataFrame'y ułatwiają praktyczne tworzenie potoków ML (pipelines), zwłaszcza transformacji cech.

> Wyjaśnienie: według dokumentacji Sparka API oparte na DataFrame (`spark.ml`) jest podstawowym API MLlib od wersji 2.0, a nie od 3.2.

#### Pytanie: dlaczego MLlib przechodzi na API oparte na DataFrame? (s. 3–4, powtórzone na s. 30–31)

**Odpowiedź:**
- DataFrame'y dają **wygodniejsze (bardziej przyjazne użytkownikowi) API** niż RDD. Korzyści DataFrame'ów: **Spark Datasources**, **zapytania SQL/DataFrame**, optymalizacje **Catalyst** oraz **jednolite API w różnych językach**.
- DataFrame'y ułatwiają praktyczne budowanie **pipeline'ów** ML, zwłaszcza transformacji cech.

**Czy MLlib oparte na RDD jest przestarzałe (deprecated)?**
- MLlib zawiera zarówno **API oparte na RDD**, jak i **API oparte na DataFrame**. API RDD jest obecnie w **trybie utrzymania (maintenance mode)**. Ale **ani to API, ani MLlib jako całość nie są oznaczone jako przestarzałe**.

#### MLlib a inne biblioteki (s. 13)

- MLlib (Spark 4.x) **nie jest tak rozbudowana** jak inne znane biblioteki: **PyTorch, TensorFlow, Scikit-learn, Theano, Keras**.
- **Jej zaleta:** możliwość pracy **na klastrze z zainstalowanym Sparkiem**, na **dużych wolumenach danych**.
- API MLlib oparte na DataFrame zapewnia jednolite API dla algorytmów ML i wielu języków.

### 2. Etapy budowy modelu klasyfikacji (s. 5–9)

#### Etap 2: analiza eksploracyjna – przykład interpretacji statystyk (s. 5)

Załóżmy, że analizujemy cechę `feature1` ze zbioru:

| Statystyka | Wartość |
|---|---|
| Średnia | 50.5 |
| Odchylenie standardowe | 10.2 |
| Minimalna | 12 |
| Maksymalna | 85 |

Interpretacja:
- **Średnia (50.5)** → większość wartości atrybutu oscyluje wokół 50.
- **Odchylenie standardowe (10.2)** → większość wartości mieści się w przedziale ±10 od średniej (tj. 40–60).
- **Min (12) i max (85)** → dane obejmują szeroki zakres, więc mogą wymagać **normalizacji**.

#### Etapy 3–4 (s. 6)

| Etap | Treść |
|---|---|
| **3. Budowa (rozwój) modelu** | A. wybór właściwego algorytmu klasyfikacji → **Random Forest**, **Logistic Regression**, inne… |
| **4. Ewaluacja modelu** (testowanie modelu i ocena jego jakości) | A. podział danych na podzbiory → podzbiór **treningowy** i podzbiór **testowy**; B. wybór miar oceny → **Accuracy** (na slajdzie: „Accuracy (precision)”), **F1-score**, **Confusion matrix** (macierz pomyłek) |
| **4. (na slajdzie powtórzony numer; logicznie 5.) Wdrożenie i monitorowanie modelu** | – |

> Wyjaśnienie: accuracy (trafność) i precision (precyzja) to dwie różne metryki – zob. sekcja 13.

#### Przykład: Letter Recognition (s. 7)

Etapy budowy modelu klasyfikacji pokazano na przykładzie rozpoznawania liter: http://archive.ics.uci.edu/ml/datasets/Letter+Recognition

#### Pytanie: co jest potrzebne na samym początku budowy modelu ML? (s. 8–9)

**Odpowiedź:** aby zbudować model, trzeba **znać wszystkie cechy (atrybuty) zbioru** oraz **mieć same dane**.

### 3. Zbiór Letter Recognition (UCI) (s. 10–12)

#### Informacje o zbiorze (s. 10)

- Repozytorium **UCI Machine Learning Repository**.
- Cel: rozpoznać każdy z wielu czarno-białych prostokątnych obrazów pikselowych jako jedną z **26 wielkich liter alfabetu angielskiego**.
- Obrazy znaków oparto na **20 różnych krojach pisma (fontach)**; każdą literę w tych fontach losowo zniekształcono, uzyskując plik **20 000 unikalnych bodźców (stimuli)**.
- Każdy bodziec zamieniono na **16 prostych atrybutów liczbowych** (momenty statystyczne i liczby krawędzi), przeskalowanych do **liczb całkowitych od 0 do 15**.
- **Model trenuje się na pierwszych 16 000 elementach**, a uzyskanym modelem przewiduje się kategorie liter dla **pozostałych 4 000**.

| Cecha zbioru | Wartość | Objaśnienie ze slajdu |
|---|---|---|
| Data Set Characteristics | Multivariate | zbiór wielowymiarowy |
| Attribute Characteristics | Integer | atrybuty reprezentowane liczbami całkowitymi (int) |
| Associated Tasks | Classification | do zadań klasyfikacji |
| Number of Instances | 20000 | liczba wystąpień liter (rekordów) |
| Number of Attributes | 16 | liczba atrybutów w zbiorze liter |
| Missing Values? | No | czy są braki wymagające filtrowania albo uzupełnienia – **nie** |
| Area | Computer | – |
| Date Donated | 1991-01-01 | – |
| Number of Web Hits | 444476 | – |

#### Atrybuty (s. 11)

| Nr | Atrybut | Opis |
|---|---|---|
| 1 | `lettr` | wielka litera (26 wartości od A do Z) – **etykieta (klasa)** |
| 2 | `x-box` | pozioma pozycja ramki (integer) |
| 3 | `y-box` | pionowa pozycja ramki (integer) |
| 4 | `width` | szerokość ramki (integer) |
| 5 | `high` | wysokość ramki (integer) |
| 6 | `onpix` | łączna liczba zapalonych pikseli (integer) |
| 7 | `x-bar` | średnie x zapalonych pikseli w ramce (integer) |
| 8 | `y-bar` | średnie y zapalonych pikseli w ramce (integer) |
| 9 | `x2bar` | średnia wariancja x (integer) |
| 10 | `y2bar` | średnia wariancja y (integer) |
| 11 | `xybar` | średnia korelacja x i y (integer) |
| 12 | `x2ybr` | średnia z x · x · y (integer) |
| 13 | `xy2br` | średnia z x · y · y (integer) |
| 14 | `x-ege` | średnia liczba krawędzi od lewej do prawej (integer) |
| 15 | `xegvy` | korelacja x-ege z y (integer) |
| 16 | `y-ege` | średnia liczba krawędzi od dołu do góry (integer) |
| 17 | `yegvx` | korelacja y-ege z x (integer) |

Pytanie (s. 12): **jak wyglądają dane w tym zbiorze?** → kolejne slajdy.

### 4. Wczytanie danych i podgląd – ml_1.py (s. 13–17)

#### Sesja Sparka i odczyt CSV (s. 13–14)

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("ml").getOrCreate()
df = spark.read.csv("letter-recognition.data", header=False, inferSchema=True)
df.show(10)
df.schema            # na s. 14: print(df.schema)
```

Co robi:
- Start jak zwykle od sesji Sparka – `SparkSession` (na slajdzie: „Spark Context – punkt wejścia do przetwarzania DF”).
- `header=False` – **plik nie ma nagłówka**.
- `inferSchema=True` – **schemat ma zaproponować Spark** (sam rozpoznaje typy).
- `df.show(10)` – pokazuje 10 wierszy; kolumny dostają automatyczne nazwy `_c0 … _c16`; `_c0` to **litery**, `_c1…_c16` to **cechy liter użyte do rozpoznawania**.
- `print(df.schema)` – opisuje schemat danych z pliku CSV. Wynik:
  `StructType(List(StructField(_c0,StringType,true),StructField(_c1,IntegerType,true), … ,StructField(_c16,IntegerType,true)))` – `_c0` jest `StringType`, pozostałe `IntegerType`.
- Na tej podstawie można **zdefiniować własny schemat**, który po imporcie będzie dokładnie dopasowany.
- Zbiór zawiera metryki opisujące, jak litery wyglądają na obrazie (ich cechy).
- Uruchomienie: `python.exe .\ml_1.py`

Fragment wyniku `df.show(10)`:

| _c0 | _c1 | _c2 | _c3 | _c4 | _c5 | _c6 | _c7 | _c8 | _c9 | _c10 | _c11 | _c12 | _c13 | _c14 | _c15 | _c16 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T | 2 | 8 | 3 | 5 | 1 | 8 | 13 | 0 | 6 | 6 | 10 | 8 | 0 | 8 | 0 | 8 |
| I | 5 | 12 | 3 | 7 | 2 | 10 | 5 | 5 | 4 | 13 | 3 | 9 | 2 | 8 | 4 | 10 |
| D | 4 | 11 | 6 | 8 | 6 | 10 | 6 | 2 | 6 | 10 | 3 | 7 | 3 | 7 | 3 | 9 |

#### Podstawowe statystyki cech (s. 15–16)

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("ml").getOrCreate()
df = spark.read.csv("letter-recognition.data", header=False, inferSchema=True)
df.show(10)
print(df.schema)
# Allows you to display basic feature statistics
df.describe().show()
```

- `df.describe().show()` – wyświetla **podstawowe statystyki cech**: wiersze `summary` = `count`, `mean`, `stddev`, `min`, `max`.
- Wynik: `count` = 20000 dla każdej kolumny; dla `_c0` (litery) `mean` i `stddev` = NULL, `min` = A, `max` = Z; dla cech `min` = 0, `max` = 15; przykładowe średnie: `_c1` 4.02355, `_c2` 7.0355, `_c3` 5.12185, `_c4` 5.37245, `_c5` 3.50585.

#### Pytanie: jak zdefiniować konkretną strukturę schematu danych? (s. 17)

**Odpowiedź:** podpowiedź daje polecenie **`df.schema`** (zob. poprzedni slajd) – na jego podstawie budujemy własny schemat.

### 5. Własny schemat danych i uruchamianie – ml_2.py (s. 18–20)

#### Definicja schematu (s. 18, ten sam kod uporządkowany na s. 20)

```python
from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, IntegerType

spark = SparkSession.builder.appName("ml").getOrCreate()
schema = StructType([
    StructField("lettr", StringType(),  True),
    StructField("x_box", IntegerType(), True),
    StructField("y_box", IntegerType(), True),
    StructField("width", IntegerType(), True),
    StructField("high",  IntegerType(), True),
    StructField("onpix", IntegerType(), True),
    StructField("x_bar", IntegerType(), True),
    StructField("y_bar", IntegerType(), True),
    StructField("x2bar", IntegerType(), True),
    StructField("y2bar", IntegerType(), True),
    StructField("xybar", IntegerType(), True),
    StructField("x2ybr", IntegerType(), True),
    StructField("xy2br", IntegerType(), True),
    StructField("x_ege", IntegerType(), True),
    StructField("xegvy", IntegerType(), True),
    StructField("y_ege", IntegerType(), True),
    StructField("yegvx", IntegerType(), True),
])
df = spark.read.csv("./letter/letter-recognition.data", header=False, schema=schema)
df.show(10)
df.schema
```

Co robi:
- `from pyspark.sql.types import StructType, StructField, StringType, IntegerType` – importy potrzebne do stworzenia własnego schematu.
- `StructField(nazwa, typ, nullable)`:
  - 1. argument – **nazwa kolumny**,
  - 2. argument – **typ danych** (`StringType()`, `IntegerType()`),
  - 3. argument – czy **dopuszczalne są braki (NULL)**: `True` – mogą być, `False` – nie mogą.
- `schema=schema` w `spark.read.csv` – **ustawienie schematu dla danych** (zamiast `inferSchema`).
- Efekt: powstają czytelne nazwy kolumn do przetwarzania: `lettr | x_box | y_box | width | high | onpix | x_bar | y_bar | x2bar | y2bar | xybar | x2ybr | xy2br | x_ege | xegvy | y_ege | yegvx`.

#### Uwaga: jak uruchomić (s. 18–19)

- **Od Pythona 3.12** trzeba doinstalować pakiet: `pip install setuptools` (na s. 18 także `pip install mumpy` – na slajdzie literówka, chodzi o `numpy`).
- Powód: `ModuleNotFoundError: No module named 'distutils'` – **PEP 632: moduł `distutils` jest przestarzały (deprecated)** (https://peps.python.org/pep-0632/). Nie trzeba reinstalować pysparka ani Pythona – wystarczy zainstalować **setuptools**.
- Albo w środowisku **PyCharm**: 1. zakładka Python Packages → 2. wyszukaj `setuptools` → 3. **Install package**.
- Uruchomienie zadania: `python.exe .\ml_2.py`
- Uruchomienie skryptu konkretnym interpreterem (na slajdzie podpisane „Python 3.11”, choć ścieżka wskazuje na `Python310`):
  `C:\"Program Files"\Python310\python.exe C:\BigData\PycharmProjects\BigData\ml_2.py` (na s. 18 w tym miejscu `ml_71.py`).
  Uwaga na spację – nazwę katalogu `Program Files` podaje się w cudzysłowie.

### 6. Analiza eksploracyjna danych (s. 20–29)

#### Liczba rekordów i rozkład etykiet (s. 20–22)

**2. Analiza rozkładu etykiet** – aby zobaczyć, jak często występują poszczególne etykiety (litery), używa się funkcji **`groupBy()`** i **`count()`** (s. 21).

```python
...
df = spark.read.csv("./letter/letter-recognition.data", header=False, schema=schema)
df.show(10)
a = df.count()
print(f"łączna liczba krotek wynosi: {a}")
df.createOrReplaceTempView("df")
spark.sql("SELECT lettr, COUNT(*) count FROM df GROUP BY lettr ORDER BY lettr").show(10)
```

Co robi:
- `df.count()` – **akcja** (w odróżnieniu od **transformacji**), więc zwraca obiekt, który nie jest DataFrame'em – tu **`int`** z liczbą wierszy. `int` nie ma metody `show()`, dlatego wartość przypisujemy do zmiennej i wypisujemy `print`. Wynik: **20 000 krotek**.
- `df.createOrReplaceTempView("df")` – rejestruje `df` jako **widok tymczasowy**, by dalej przekształcać dane za pomocą **Spark SQL**.
- `spark.sql("SELECT lettr, COUNT(*) count FROM df GROUP BY lettr ORDER BY lettr")` – agregacja liczności według liter.

Wynik (pierwsze 10 wierszy):

| lettr | count |
|---|---|
| A | 789 |
| B | 766 |
| C | 736 |
| D | 805 |
| E | 768 |
| F | 775 |
| G | 773 |
| H | 734 |
| I | 755 |
| J | 747 |

#### Rozkład cech (s. 23)

**3. Analiza rozkładu cech** – rozkład każdej cechy liczbowej (np. feature1, feature2) można badać funkcjami **`select()`** i **`rdd.flatMap()`**. (Praca własna.)

#### Korelacja między cechami (s. 24–28)

**4. Korelacja między cechami** – do zrozumienia korelacji służy **macierz korelacji** (s. 24). Apache Spark i biblioteka **MLlib** pozwalają liczyć korelacje między kolumnami danych (s. 25).

```python
from pyspark.ml.feature import VectorAssembler
from pyspark.ml.stat import Correlation
from pyspark.sql.types import StructType, StructField, IntegerType, StringType

assembler = VectorAssembler(
    inputCols=[
        "x_box", "y_box", "width", "high", "onpix",
        "x_bar", "y_bar", "x2bar", "y2bar", "xybar",
        "x2ybr", "xy2br", "x_ege", "xegvy", "y_ege", "yegvx"
    ],
    outputCol="features"
)
vector_data = assembler.transform(df)
```

- `VectorAssembler` łączy 16 kolumn cech w jedną kolumnę wektorową `features`.

Obliczenie macierzy korelacji:

```python
correlation_matrix = Correlation.corr(vector_data, "features").head()[0]
```

Konwersja macierzy do tablicy NumPy:

```python
import numpy as np
corr_matrix_np = np.array(correlation_matrix.toArray())
```

Wyświetlenie macierzy korelacji (s. 26):

```python
print("correlation matrix:")
print(corr_matrix_np)
```

Wizualizacja macierzy korelacji – mapa ciepła (s. 27, praca własna):

```python
import seaborn as sns
import matplotlib.pyplot as plt

# Correlation Matrix Visualization:
plt.figure(figsize=(12, 10))
sns.heatmap(corr_matrix_np, annot=True, fmt=".2f", cmap="coolwarm",
            xticklabels=[
                "x_box", "y_box", "width", "high", "onpix",
                "x_bar", "y_bar", "x2bar", "y2bar", "xybar",
                "x2ybr", "xy2br", "x_ege", "xegvy", "y_ege", "yegvx"
            ],
            yticklabels=[
                "x_box", "y_box", "width", "high", "onpix",
                "x_bar", "y_bar", "x2bar", "y2bar", "xybar",
                "x2ybr", "xy2br", "x_ege", "xegvy", "y_ege", "yegvx"
            ])
plt.title("Correlation Matrix Visualization")
plt.show()
```

Wynik (s. 28, wykres „Macierz korelacji cech”) – wybrane wartości odczytane z wykresu:

| Para cech | Korelacja |
|---|---|
| x_box – width | 0.85 |
| y_box – high | 0.82 |
| width – onpix | 0.77 |
| x_box – y_box | 0.76 |
| x_box – high / width – high | 0.67 / 0.66 |
| onpix – x_ege | 0.63 |
| y_bar – x2ybr | 0.60 |
| y_bar – xegvy | 0.56 |
| x2ybr – xegvy | 0.53 |
| y2bar – x_ege | −0.38 |
| x_bar – y_bar | −0.36 |

Zadanie ze slajdu (praca własna): **wyjaśnij uzyskany wykres macierzy korelacji cech. Do czego może być potrzebny?**

> Wyjaśnienie: silnie skorelowane są cechy „rozmiarowe” ramki (`x_box`, `y_box`, `width`, `high`, `onpix`); pozostałe cechy (momenty, krawędzie) są w większości słabo skorelowane. Macierz korelacji pomaga wykryć cechy redundantne – zob. wnioski poniżej.

#### Wnioski ze wstępnej analizy danych (s. 29, praca własna)

| Obszar | Pytanie | Co z tym zrobić |
|---|---|---|
| **Rozkład etykiet (liter)** | Czy występuje **niezbalansowanie klas**? | Uwzględnić w kolejnych krokach, np. przez **ważenie klas** w modelu. |
| **Rozkład cech** | Czy dane zawierają **wartości odstające (outliers)**? | Warto je przeanalizować i ewentualnie usunąć. |
| **Korelacje** | Czy są **silnie skorelowane cechy**? | Można to wykorzystać do **redukcji wymiarowości** danych. |

### 7. Klasyfikacja i regresja logistyczna (s. 32)

Dokumentacja: https://spark.apache.org/docs/latest/ml-classification-regression.html

- **Regresja logistyczna** – popularna metoda przewidywania **odpowiedzi kategorycznej**. To szczególny przypadek **uogólnionych modeli liniowych (Generalized Linear Models)**, który przewiduje **prawdopodobieństwo wyników** (np. na podstawie opisu cech danego obiektu).
- Spark zawiera:

| Wariant | Zastosowanie | Przykłady |
|---|---|---|
| **Binomial logistic regression** (dwumianowa) | przewidywanie wyniku **binarnego** | czy klient przy danych założeniach spłaci kredyt, czy nie; czy klient kupi produkt, czy nie |
| **Multinomial logistic regression** (wielomianowa) | przewidywanie wyniku **wieloklasowego** | – |

- **Regresja** – metoda polega na podziale zbioru i wykorzystaniu **danych z etykietami** do budowy modelu (**w danych muszą być wyniki**, tzn. musimy wiedzieć np., czy klient spłacił kredyt przy danych cechach).
- Pozwala to trenować model na danych i wynikach, które już wystąpiły → by odpowiedzieć, czy nową osobę można zaliczyć do grupy klientów z dobrymi perspektywami spłaty takiego kredytu.

### 8. Budowa modelu: Estimator, Transformer, Evaluator, Pipeline (s. 33–36)

#### Budowa modelu – wybór modelu, czyli strojenie hiperparametrów (s. 33)

- Ważne zadanie w ML to **wybór modelu (model selection)**: użycie danych do znalezienia najlepszego modelu lub parametrów dla danego zadania. Nazywa się to też **strojeniem (tuning)**.
- Struktura modelu pozwala nauczyć się zależności między cechami przypisanymi do klas obiektów.
- Strojenie można wykonać dla **pojedynczych estymatorów (Estimators)**, np. `LogisticRegression`, albo dla **całych Pipeline'ów** zawierających wiele algorytmów, funkcji itp. Dzięki temu strojony jest cały Pipeline, a nie każdy jego element osobno.

| Pojęcie | Definicja ze slajdów |
|---|---|
| **Estimator** | **dopasowuje (fit) model do danych**; algorytm, który na podstawie DF tworzy **transformer** (`fit`) |
| **Evaluator** | **oblicza metryki na podstawie predykcji** w procesie oceny (scoring) |
| **CrossValidator** | **rozszerza Estimator** (`CrossValidator extends Estimator`); realizuje k-krotną walidację krzyżową |
| **ML Pipelines** | jednolity zestaw wysokopoziomowych API zbudowanych **na DataFrame'ach**, pomagający tworzyć i dostrajać praktyczne potoki ML |

**K-krotna walidacja krzyżowa (k-fold cross-validation):** wybiera model, dzieląc zbiór danych na **losowo podzielone, rozłączne (niepokrywające się) części**, używane jako osobne zbiory treningowe i testowe. Np. przy **k = 3** powstają **3 pary zbiorów (treningowy, testowy)**, każda używa **2/3 danych do treningu i 1/3 do testu**. **Każda część jest zbiorem testowym dokładnie raz.**

MLlib wspiera wybór modelu za pomocą obiektów: **`CrossValidator`** i **`TrainValidationSplit`**.

#### Trening modelu (s. 34)

- **Estimator** – dopasowuje model do danych; algorytm tworzący transformer (`fit`) na podstawie DF.
  - Odpowiada za wstępną inicjalizację **niewytrenowanego** modelu → trening w Sparku polega na wywołaniu metody **`fit`**, której przekazujemy **DataFrame** (dane).
  - W wyniku wywołania `fit` po treningu dostajemy **nowy model, który jest Transformerem**.
- **Transformer** – algorytm, który **przekształca wejściowy DF w inny DF**, np. wytrenowany model ML tworzący nowy DF z predykcjami.
  - Aby Transformer wygenerował predykcję, potrzebna jest metoda **`transform`**.
- **Szeregowe połączenie transformerów i estymatorów tworzące przepływ pracy (workflow)** – na slajdzie podpisane jako „Transformer”; chodzi o **Pipeline** (na slajdzie: błędny podpis).

#### Predykcja modelu (s. 35)

- **Prognozowanie (predykcja)** – metoda przewidywania, jak procesy lub zdarzenia rozwiną się w przyszłości. W procesie prognozowania formułuje się sąd o przyszłych stanach zjawisk i zdarzeń, zwany **prognozą**.
- Prognozowanie bada zależności między czynnikami a badanym zjawiskiem oraz to, jak zjawiska te rozwijały się w przeszłości, aby wyciągnąć wnioski na przyszłość.

#### Zadanie (s. 36)

Używając pySparka, zastanów się, jak rozwinąć kolejne kroki budowy modelu klasyfikacji. **Uwzględnij podział zbioru na część treningową (uczącą) i testową.**

### 9. Przygotowanie danych: randomSplit, StringIndexer, VectorAssembler, StandardScaler (s. 37–40)

#### Podział danych i indeksowanie etykiet – ml_5.py (s. 37)

Proces zaczyna się od **podziału zbioru na dwie części**: do treningu i do predykcji.

```python
df = spark.read.csv("./letter/letter-recognition.data" header=False, schema=schema)
df.createOrReplaceTempView("df")
df_train, df_eval = df.randomSplit([0.7, 0.3], 42)
from pyspark.ml import feature
idx = feature.StringIndexer(inputCol="lettr", outputCol="label")
idx_t = idx.fit(df_train)
df_train_ = idx_t.transform(df_train)
df_train_.show(10)
```

(na slajdzie w `spark.read.csv` brakuje przecinka po ścieżce pliku; poprawnie: `spark.read.csv("./letter/letter-recognition.data", header=False, schema=schema)`). Na slajdzie również dopisek: `pip install numpy==numpy-1.21.4`.

Co robi:
- `df.randomSplit([0.7, 0.3], 42)` – dzieli `df` w proporcji **70% / 30%**; **42 to ziarno losowania (seed)**, dające deterministyczny podział.
  - `df_train` – część **do treningu**,
  - `df_eval` – część **do sprawdzania wyników na nowych, nieużywanych danych**.
- `from pyspark.ml import feature` – moduł z narzędziami do **przygotowania danych, skalowania i normalizacji** przed treningiem (https://spark.apache.org/docs/latest/api/python/reference/pyspark.ml.html#feature).
- `feature.StringIndexer(inputCol="lettr", outputCol="label")` – tworzy kolumnę **liczbową** z kolumny tekstowej (String); podajemy kolumnę wejściową i wyjściową; każdy napis dostaje **unikalną wartość liczbową**.
- `idx` – uchwyt do obiektu **estymatora**.
- `idx.fit(df_train)` – metoda `fit`, której przekazujemy `df`, tworzy **obiekt transformera** (`idx_t`), który przekształca dane.
- Wynik: nowa kolumna `label` z unikalnym numerem dla każdej klasy, np. **A → 0.0**.

**Pytanie:** po co zamieniać wartości typu String na unikalne wartości liczbowe?
**Odpowiedź:** wszystkie operacje budowy modelu to **operacje macierzowe**, a przekształcenia macierzowe najlepiej wykonuje się na **wartościach liczbowych**.

#### Złożenie cech w wektor – ml_6.py (s. 38–39)

- Celem wartości liczbowych jest umożliwienie operacji macierzowych → **wszystkie cechy wejściowe i klasy (tu litery) powinny być liczbami**.
- W kolejnym kroku zmienne cech wejściowych trzeba zamienić na **wektory**.

```python
vect = feature.VectorAssembler(inputCols=df.columns[1:], outputCol="feat")
df_train_ = vect.transform(df_train_)
```

- `VectorAssembler` to **transformer** łączący cechy/kolumny w jeden wektor. **Nie musi niczego uczyć się z danych** (więc nie ma `fit`). Kolumna wyjściowa nazywa się **`feat`**.
- `df.columns[1:]` – wszystkie kolumny poza pierwszą (`lettr`).

```python
df_train_ = df_train_.select("label", "feat")
```

- Wybieramy z `df` tylko **dwie kolumny**: `label` i `feat` – wynikiem instrukcji jest **transformacja**.
- Przykładowy wiersz: `0.0 | [1.0,0.0,2.0,0.0,0.0,7.0,3.0,2.0,0.0,7.0,2.0,8.0,2.0,6.0,1.0,8.0]`.
- W następnym kroku dane trzeba **znormalizować (przeskalować)**, aby zakresy wartości były do siebie dopasowane.

#### Skalowanie – ml_7.py (s. 40)

```python
scaler = feature.StandardScaler(inputCol="feat", outputCol="features")
scaler_t = scaler.fit(df_train_)
df_train_ = scaler_t.transform(df_train_)
```

- **`StandardScaler`** normalizuje (skaluje) dane tak, by zakresy wartości do siebie pasowały.
- Używa **średniej i odchylenia standardowego** każdej kolumny; dzięki temu kolumny mają podobne wartości.
- **To estymator** (bo musi „nauczyć się” danych – policzyć statystyki), dlatego najpierw `fit`, potem `transform`. Przyjmuje kolumnę wejściową i wyjściową.
- Wynik: kolumny `label | feat | features`, np. `features` zaczyna się od `0.52088456476688…`.
- Wyświetlenie bez obcinania tekstu:

```python
df_train_.show(10, truncate=False)
```

### 10. Modele klasyfikacji i RandomForestClassifier (s. 41–44)

#### Klasyfikacja (s. 41)

**Jak zrealizować klasyfikację przy budowie modelu?**
Klasyfikacja:
- to proces związany z **kategoryzacją**…
- …proces, w którym idee i obiekty są **rozpoznawane (rozróżniane)**,
- to **grupowanie powiązanych faktów w klasy**.

#### Modele klasyfikacji w pyspark.ml (s. 42)

| Klasa | Opis |
|---|---|
| `LinearSVC(*[, featuresCol, labelCol, …])` | klasyfikator **binarny** optymalizujący **Hinge Loss** optymalizatorem **OWLQN** |
| `LinearSVCModel([java_model])` | model dopasowany przez LinearSVC |
| `LinearSVCSummary([java_obj])` | wyniki LinearSVC dla danego modelu |
| `LinearSVCTrainingSummary([java_obj])` | wyniki treningu LinearSVC |
| `LogisticRegression(*[, featuresCol, …])` | regresja logistyczna |
| `LogisticRegressionModel([java_model])` | model dopasowany przez LogisticRegression |
| `LogisticRegressionSummary([java_obj])` | wyniki regresji logistycznej dla danego modelu |
| `LogisticRegressionTrainingSummary([java_obj])` | wyniki treningu wielomianowej regresji logistycznej |
| `BinaryLogisticRegressionSummary([java_obj])` | wyniki binarnej regresji logistycznej dla modelu |
| `BinaryLogisticRegressionTrainingSummary([…])` | wyniki treningu binarnej regresji logistycznej |
| `DecisionTreeClassifier(*[, featuresCol, …])` | **drzewo decyzyjne**; etykiety binarne i wieloklasowe, cechy ciągłe i kategoryczne |
| `DecisionTreeClassificationModel([java_model])` | model dopasowany przez DecisionTreeClassifier |
| `GBTClassifier(*[, featuresCol, labelCol, …])` | **Gradient-Boosted Trees (GBTs)**; **tylko etykiety binarne**, cechy ciągłe i kategoryczne |
| `GBTClassificationModel([java_model])` | model dopasowany przez GBTClassifier |
| `RandomForestClassifier(*[, featuresCol, …])` | **las losowy**; etykiety binarne i wieloklasowe, cechy ciągłe i kategoryczne |
| `RandomForestClassificationModel([java_model])` | model dopasowany przez RandomForestClassifier |
| `RandomForestClassificationSummary([java_obj])` | wyniki RandomForestClassification dla modelu |
| `RandomForestClassificationTrainingSummary([…])` | wyniki treningu RandomForestClassification |
| `BinaryRandomForestClassificationSummary([…])` | wyniki binarnej klasyfikacji lasem losowym |

…i inne: https://spark.apache.org/docs/latest/api/python/reference/pyspark.ml.html#classification

#### RandomForestClassifier (s. 43)

- **Random Forest** – algorytm uczenia do klasyfikacji. Obsługuje etykiety **binarne i wieloklasowe** oraz cechy **ciągłe i kategoryczne**.
- Sygnatura (z dokumentacji, na slajdzie):

```python
class pyspark.ml.classification.RandomForestClassifier(*, featuresCol: str = 'features',
    labelCol: str = 'label', predictionCol: str = 'prediction', probabilityCol: str = 'probability',
    rawPredictionCol: str = 'rawPrediction', maxDepth: int = 5, maxBins: int = 32,
    minInstancesPerNode: int = 1, minInfoGain: float = 0.0, maxMemoryInMB: int = 256,
    cacheNodeIds: bool = False, checkpointInterval: int = 10, impurity: str = 'gini', numTrees: int = 20,
    featureSubsetStrategy: str = 'auto', seed: Optional[int] = None, subsamplingRate: float = 1.0,
    leafCol: str = '', minWeightFractionPerNode: float = 0.0, weightCol: Optional[str] = None,
    bootstrap: Optional[bool] = True)
```

Wybrane atrybuty:

| Atrybut | Domyślnie | Znaczenie |
|---|---|---|
| `cacheNodeIds` | False | algorytm przekazuje drzewa do executorów, by dopasować instancje do węzłów; przy `True` **cache'uje ID węzłów dla każdej instancji**; cache może **przyspieszyć trening głębszych drzew**; częstotliwość checkpointowania cache (lub jego wyłączenie) ustawia się przez `checkpointInterval` |
| `maxBins` | 32 | liczba kategorii (koszyków) dla dowolnej cechy kategorycznej |
| `maxDepth` | 5 | maksymalna głębokość drzewa, np. głębokość 0 = 1 liść; głębokość 1 = 1 węzeł wewnętrzny + 2 liście; **zakres [0, 30]** |
| `maxMemoryInMB` | 256 | maksymalna pamięć (MB) na agregację histogramów; gdy za mała – w każdej iteracji dzielony jest 1 węzeł, a jego agregaty mogą przekroczyć ten rozmiar |
| `numTrees` | 20 | **liczba drzew do wytrenowania (≥ 1)** |

Metody – zob. dokumentacja (link jak wyżej).

#### Trening lasu losowego i predykcja – ml_8.py (s. 44)

```python
from pyspark.ml import classification
forest = classification.RandomForestClassifier(maxDepth=8, minInstancesPerNode=5, seed=42)
forest_t = forest.fit(df_train_)
pred_train = forest_t.transform(df_train_)
pred_train.show(10)
```

Co robi:
- Używamy modelu **`RandomForestClassifier`** – modelu złożonego z prostszych modeli **drzew decyzyjnych**.
- Dobiera się parametry modelu albo techniki poprawiające uczenie – tu podajemy **głębokość modelu** (`maxDepth=8`), `minInstancesPerNode=5` i **ziarno losowania** (`seed=42`).
- Tak powstaje **estymator** z metodą **`fit`**; wynikiem jest **transformer w postaci gotowego modelu** (`forest_t`).
- **Predykcja odbywa się operacją `transform`.**
- Wynik `pred_train` ma kolumny: `label | feat | features | rawPrediction | probability | prediction` – nowe kolumny dodane przez model to **`rawPrediction`, `probability`, `prediction`**; kolumna **`prediction` to przewidywana klasa**.

### 11. Ewaluacja modelu – ml_9.py (s. 45–48)

- **Ewaluacja** pozwala **ocenić jakość** gotowego modelu (s. 45).

```python
from pyspark.ml import evaluation
evaluator = evaluation.MulticlassClassificationEvaluator(metricName="accuracy")
a = evaluator.evaluate(pred_train)
print(f"Probability of correctly matching the letter: {a}")
df_eval_ = idx_t.transform(df_eval)
df_eval_ = vect.transform(df_eval_)
df_eval_ = df_eval_.select("label", "feat")
df_eval_ = scaler_t.transform(df_eval_)
pred_eval = forest_t.transform(df_eval_)
```

Co robi (s. 47):
- Moduł `evaluation` oferuje różne **ewaluatory**.
- **`MulticlassClassificationEvaluator`** pozwala użyć metryki **accuracy**, która mówi, z jakim prawdopodobieństwem predykcje były zgodne.
- Ewaluator udostępnia metodę **`evaluate`**: przekazujemy dane z predykcjami, by porównać je z danymi rzeczywistymi. Wynik to współczynnik – **im bliżej 1, tym lepszy model**.
- Wynik na **danych treningowych**: `0.7926205033413906` (≈ 79%) – UWAGA: to predykcja na danych, na których model był trenowany.
- Pozostałe linie to **predykcja na nowych danych** (`df_eval`): te same, **już wytrenowane** transformery (`idx_t`, `vect`, `scaler_t`, `forest_t`) stosujemy przez `transform` (tylko `transform`, bez ponownego `fit`). Ten ciąg kroków można zastąpić **Pipeline'em** (dalej).
- `pred_eval.show(10)` – kolumny: `label | feat | features | rawPrediction | probability | prediction`.

Dokładność na zbiorze **niewytrenowanym** (testowym) (s. 48):

```python
b = evaluator.evaluate(pred_eval)
print(f" Probability of correctly matching the letter: {b}")
```

- Wynik: `0.7595214020896528` (≈ 76%) → **o kilka procent mniej niż dla zbioru treningowego**.

### 12. Ewaluacja przez Pipeline i zapis modelu – ml_10.py, ml_11.py (s. 49–51)

#### Pipeline – ml_10.py (s. 50)

Moduł **pipeline** zapewnia uniwersalny przepływ danych – pozwala połączyć kroki w strumień.

```python
from pyspark.ml import Pipeline

idx = feature.StringIndexer(inputCol="lettr", outputCol="label")
vect = feature.VectorAssembler(inputCols=df.columns[1:], outputCol="feat")
scaler = feature.StandardScaler(inputCol="feat", outputCol="features")
forest = classification.RandomForestClassifier(maxDepth=8, minInstancesPerNode=5, seed=42)

pipe = Pipeline(stages=[idx, vect, scaler, forest])
pipe_t = pipe.fit(df_train)
pipe_t.transform(df_eval).drop(*df.columns[1:]).show(10)
```

Co robi:
- Inicjalizujemy estymatory/transformery i wstawiamy je do strumienia **`pipe`** – nie wykonujemy jeszcze kroków, tylko wskazujemy etapy (stany), które zostaną wykonane.
- **Kolejność kroków (`stages`) jest bardzo ważna** – to kolejność ich wykonania.
- **`Pipe` jest estymatorem**, więc w następnym kroku używamy metody **`fit`** (na surowym `df_train`); wynikiem jest wytrenowany model potoku `pipe_t` (transformer).
- `pipe_t.transform(df_eval)` – predykcja na danych testowych; `.drop(*df.columns[1:])` usuwa z wyniku 16 kolumn cech źródłowych.
- Wynik: `label | feat | features | rawPrediction | probability | prediction` (takie same wartości jak w ml_9).

#### Zapis modelu z Pipeline'u – ml_11.py (s. 51)

```python
pipe_t.save("model")
```

- Tworzy katalog `model` z podkatalogami **`metadata`** i **`stages`**.
- W `stages` każdy etap ma osobny katalog z numerem kolejności:
  - `0_StringIndexer_f7795696010a`
  - `1_VectorAssembler_f65b628247ba`
  - `2_StandardScaler_8ee327814364`
  - `3_RandomForestClassifier_0921259b81dc`

### 13. Metryki oceny modelu w Apache Spark (s. 52–55)

#### Kluczowe metryki (s. 53)

| Metryka | Definicja | Wzór |
|---|---|---|
| **Accuracy** (trafność) | odsetek poprawnych predykcji wśród wszystkich przykładów | Accuracy = Correct Predictions / Total Examples |
| **Precision** (precyzja) | odsetek prawdziwie pozytywnych wśród wszystkich **przewidzianych** jako pozytywne dla danej klasy | Precision_i = TP_i / (TP_i + FP_i) |
| **Recall (Sensitivity)** (czułość) | odsetek prawdziwie pozytywnych wśród wszystkich **rzeczywiście** pozytywnych dla danej klasy | Recall_i = TP_i / (TP_i + FN_i) |
| **F1-Score** | **średnia harmoniczna** Precision i Recall | F1_i = 2 · (Precision_i · Recall_i) / (Precision_i + Recall_i) |
| **Confusion Matrix** (macierz pomyłek) | tabela zestawiająca **etykiety prawdziwe z przewidzianymi** dla każdej klasy | – |

Przykładowa macierz pomyłek dla dwóch klas:

| | Predicted: A | Predicted: B |
|---|---|---|
| **Actual: A** | True Positive (TP) | False Negative (FN) |
| **Actual: B** | False Positive (FP) | True Negative (TN) |

#### Metryki w kodzie (s. 54)

```python
from pyspark.ml import evaluation
from pyspark.sql import SparkSession # Import SparkSession

# Ensure SparkSession is active. This will get the existing session or create a new one.
spark = SparkSession.builder.appName("ml").getOrCreate()

# Accuracy (already calculated, but can be explicitly shown again)
evaluator_accuracy = evaluation.MulticlassClassificationEvaluator(metricName="accuracy")
accuracy = evaluator_accuracy.evaluate(pred_eval)
print(f"Accuracy: {accuracy:.4f}")

# Precision (weighted)
evaluator_precision = evaluation.MulticlassClassificationEvaluator(metricName="weightedPrecision")
precision = evaluator_precision.evaluate(pred_eval)
print(f"Weighted Precision: {precision:.4f}")

# Recall (weighted)
evaluator_recall = evaluation.MulticlassClassificationEvaluator(metricName="weightedRecall")
recall = evaluator_recall.evaluate(pred_eval)
print(f"Weighted Recall: {recall:.4f}")

# F1-Score (weighted)
evaluator_f1 = evaluation.MulticlassClassificationEvaluator(metricName="weightedFMeasure")
f1_score = evaluator_f1.evaluate(pred_eval)
print(f"Weighted F1-Score: {f1_score:.4f}")
```

- Ten sam `MulticlassClassificationEvaluator`, różne wartości `metricName`: `"accuracy"`, `"weightedPrecision"`, `"weightedRecall"`, `"weightedFMeasure"`.
- Wynik na zbiorze testowym:

| Metryka | Wartość |
|---|---|
| Accuracy | 0.7595 |
| Weighted Precision | 0.7886 |
| Weighted Recall | 0.7595 |
| Weighted F1-Score | 0.7614 |

> Wyjaśnienie: „weighted” oznacza średnią metryk liczonych dla każdej klasy, ważoną liczbą przykładów w klasie. Ważony recall jest matematycznie równy accuracy – stąd ta sama wartość 0.7595.

#### Macierz pomyłek – interpretacja (s. 55)

- **Macierz pomyłek** to podstawowe narzędzie oceny modelu klasyfikacji. Pokazuje, jak często model trafia i myli się – w rozbiciu na konkretne kategorie.
- **Przykład:** model klasyfikuje, czy e-mail to spam. Po teście na **100 wiadomościach**:

| | Actual Spam | Actual Not Spam |
|---|---|---|
| **Predicted Spam** | 40 | 5 |
| **Predicted Not Spam** | 10 | 45 |

Oznacza to:
- **TP = 40** – poprawnie wykryty spam,
- **TN = 45** – poprawnie rozpoznane wiadomości niebędące spamem,
- **FP = 5** – zwykłe e-maile błędnie oznaczone jako spam,
- **FN = 10** – spam, którego model nie wykrył.

(Uwaga: w tym przykładzie wiersze to predykcje, a kolumny – stan rzeczywisty, odwrotnie niż w tabeli z s. 53.)

> Wyjaśnienie (obliczenia na tych danych): accuracy = (40+45)/100 = 0.85; precision = 40/(40+5) ≈ 0.889; recall = 40/(40+10) = 0.80; F1 ≈ 0.842.

**Dlaczego macierz pomyłek jest ważna?** Bo **sama accuracy może wprowadzać w błąd**. Np. jeśli 95% e-maili to nie-spam, model zawsze odpowiadający „nie spam” ma **95% accuracy**, a zupełnie nie wykrywa spamu. **Tylko macierz pomyłek ujawnia takie wzorce błędów.**

### 14. Macierz pomyłek dla liter – kod, wyniki, wnioski (s. 56–59)

#### Kod (s. 56)

```python
from pyspark.sql.functions import col
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Select actual labels and predicted labels
predictions_and_labels = pred_eval.select(col("prediction").cast("integer"), col("label").cast("integer"))

# Calculate the confusion matrix using crosstab
confusion_matrix_df = predictions_and_labels.crosstab("label", "prediction")

# Convert to Pandas DataFrame for easier visualization
confusion_matrix_pd = confusion_matrix_df.toPandas()

# Reorder columns to match the index (labels) for a proper confusion matrix view
# The column names from crosstab are strings, so we need to convert them to int to sort properly
# Exclude the 'label_prediction' column which contains the true labels
column_order = sorted([int(c) for c in confusion_matrix_pd.columns if c != 'label_prediction'])
column_order_str = [str(c) for c in column_order]

# Ensure 'label_prediction' column is first, then ordered prediction columns
confusion_matrix_pd = confusion_matrix_pd[['label_prediction'] + column_order_str]

# Set 'label_prediction' column as index
confusion_matrix_pd = confusion_matrix_pd.set_index('label_prediction')

# Sort the index to match the column order for consistent display
confusion_matrix_pd = confusion_matrix_pd.sort_index()

print("Confusion Matrix:")
display(confusion_matrix_pd)
# Visualize the confusion matrix
plt.figure(figsize=(12, 10))
sns.heatmap(confusion_matrix_pd, annot=True, fmt="d", cmap="Blues", cbar=False)
plt.title("Confusion Matrix")
plt.xlabel("Predicted Label")
plt.ylabel("True Label")
plt.show()
```

Co robi:
- `select(col(...).cast("integer"))` – wybiera kolumny prawdziwej i przewidzianej etykiety, rzutując je na liczby całkowite.
- **`crosstab("label", "prediction")`** – tabela krzyżowa (liczności par etykieta prawdziwa/przewidziana) = macierz pomyłek; pierwsza kolumna wyniku nazywa się **`label_prediction`** i zawiera etykiety prawdziwe.
- `toPandas()` – konwersja do Pandas dla wygodnej wizualizacji.
- Nazwy kolumn z `crosstab` są napisami, więc dla poprawnego sortowania zamienia się je na `int`; potem `label_prediction` ustawia się jako indeks i sortuje.
- `sns.heatmap(..., fmt="d", cmap="Blues")` – mapa ciepła; oś X = Predicted Label, oś Y = True Label.

#### Wynik numeryczny (s. 57)

- Macierz 26 × 26 z etykietami liczbowymi 0–25. Wartości na przekątnej to poprawne klasyfikacje, np. etykieta 0: 175, etykieta 1: 211, etykieta 25: 246.
- Na wykresie wiersze (True Label) są ułożone jako 0, 1, 10, 11, …, 19, 2, 20, …, 25, 3, …, 9 – czyli posortowane **jak napisy**, mimo komentarzy w kodzie.

#### Mapowanie etykiet na litery (s. 58)

- „Retrieve Label-to-Letter Mapping” – macierz pomyłek z literami A–Z na osiach („Confusion Matrix (True vs. Predicted Labels)”).
- Wartości na przekątnej (poprawne trafienia): A 175, B 172, C 184, D 186, E 122, F 169, G 162, H 69, I 157, J 157, K 194, L 188, M 211, N 190, O 183, P 208, Q 170, R 133, S 137, T 174, U 188, V 200, W 246, X 177, Y 186, Z 169.
- Analiza dla litery **W**: etykieta liczbowa 25.0; **False Positives = 36**, **False Negatives = 15**, **True Positives = 246**; na slajdzie pokazano po 5 przykładowych wierszy FP, FN i TP dla W.

#### Wnioski (s. 59)

**Wysoka trafność dla wielu liter:** wiele liter ma wysokie wartości na przekątnej, więc model ogólnie dobrze je rozpoznaje, np. **A – 175, C – 184, M – 211, T – 174, U – 188, W – 246** poprawnych rozpoznań. To jedne z najlepiej klasyfikowanych liter.

Pary często mylone (zgodnie z opisem na slajdzie):

| Para | Opis na slajdzie |
|---|---|
| **D i B** | prawdziwe D bywa przewidywane jako B (20 razy), prawdziwe B jako D (12 razy) – podobne cechy wizualne lub strukturalne po przetworzeniu |
| **E i G** | E mylone z G 23 razy, G z E 23 razy – istotne nakładanie się reprezentacji cech |
| **X i H** | X przewidywane jako H 44 razy, H jako X 14 razy – wyraźna jednostronna pomyłka |
| **Y i V** | Y często mylone z V (22 razy) – podobieństwo wizualne, zwłaszcza w niektórych stylach pisma lub ekstrakcji cech; V mylone z Y (13 razy) |
| **S i Z** | S przewidywane jako Z 20 razy, Z jako S 8 razy |
| **R i K** | R często brane za K (23 razy), K za R (10 razy) |

(na slajdzie część kierunków jest odwrócona względem macierzy z s. 58: z macierzy wynika m.in. **H → X = 44**, **H → K = 20**, **K → R = 23**, **R → K = 10**, a w wierszu G kolumna E ma 0, nie 23.)

**Litery o niższej skuteczności:** niektóre litery mają więcej błędnych klasyfikacji w porównaniu z poprawnymi, co wskazuje na niższy recall lub precision dla tych klas. Np. **H** poprawnie sklasyfikowano **69 razy**, ale błędnie jako **X 44 razy, R 13 razy i D 14 razy** – to trudna litera dla modelu.

### 15. Ważność cech w lesie losowym (s. 60–63)

**Zadanie (s. 60):** na podstawie modelu lasu losowego wyjaśnij, które cechy wejściowe są **dominujące**, i przedstaw ich wykres.

#### Kod (s. 61)

```python
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

# Get feature importances from the trained Random Forest model
# forest_t is the trained model from the earlier Random Forest classification cell
feature_importances = forest_t.featureImportances

# Get the original input column names that were used to create the 'features' vector
# These are stored in the 'inputCols' of the VectorAssembler 'assembler'
feature_names = assembler.getInputCols()

# Create a list of (feature_name, importance_score) tuples
feature_importance_list = []
for i, score in enumerate(feature_importances):
    feature_importance_list.append((feature_names[i], score))

# Sort the features by importance score in descending order
feature_importance_list.sort(key=lambda x: x[1], reverse=True)

# Convert to a Pandas DataFrame for easier plotting
feature_importance_df = pd.DataFrame(feature_importance_list, columns=['Feature', 'Importance'])

print("Dominant Features based on Random Forest:")
display(feature_importance_df)

# Visualize the feature importances
plt.figure(figsize=(12, 8))
sns.barplot(x='Importance', y='Feature', data=feature_importance_df, hue='Feature', legend=False,
palette='viridis')
plt.title('Random Forest Feature Importances')
plt.xlabel('Importance Score')
plt.ylabel('Feature')
plt.grid(axis='x', linestyle='--', alpha=0.7)
plt.tight_layout()
plt.show()
```

Co robi:
- **`forest_t.featureImportances`** – wektor ważności cech z wytrenowanego modelu lasu losowego.
- **`assembler.getInputCols()`** – nazwy kolumn wejściowych użytych przez `VectorAssembler` do zbudowania wektora `features`.
- Tworzy listę krotek (nazwa cechy, ważność), sortuje malejąco, zamienia na Pandas DataFrame i rysuje wykres słupkowy (`sns.barplot`).

#### Ranking ważności cech (s. 61–62)

| Miejsce | Cecha | Importance |
|---|---|---|
| 0 | `x_ege` | 0.14489172734001957 |
| 1 | `x2ybr` | 0.12104447831754121 |
| 2 | `y_ege` | 0.11057053377584848 |
| 3 | `xy2br` | 0.09716291849462359 |
| 4 | `y2bar` | 0.09222324242126517 |
| 5 | `xegvy` | 0.0905742834228653 |
| 6 | `y_bar` | 0.08587033686728883 |
| 7 | `x2bar` | 0.07528190162394406 |
| 8 | `x_bar` | 0.05167393793288494 |
| 9 | `xybar` | 0.051229233543014195 |
| 10 | `yegvx` | 0.04254984785716752 |
| 11 | `width` | 0.009346490853400778 |
| 12 | `onpix` | 0.008905975641510213 |
| 13 | `x_box` | 0.00814850061328961 |
| 14 | `y_box` | 0.005641546555211108 |
| 15 | `high` | 0.004885044740 |

- **Dominujące cechy:** `x_ege`, `x2ybr`, `y_ege` (cechy krawędzi i momentów). Najmniej ważne: cechy rozmiaru i położenia ramki (`width`, `onpix`, `x_box`, `y_box`, `high`).

> Wyjaśnienie: to spójne z macierzą korelacji – cechy ramki są ze sobą silnie skorelowane (redundantne), więc las losowy niewiele z nich korzysta.

#### Znaczenie cech x_ege i x2ybr (s. 62–63)

**`x_ege`** – piksel oznacza przejście z tła na pierwszy plan (lub odwrotnie); cecha w praktyce liczy, ile razy **poziome linie skanowania przecinają kreskę litery** w danym obszarze.
- Dlaczego ważna: informacja o krawędziach poziomych jest bardzo silna przy rozpoznawaniu liter.
  - **Litery z wyraźnymi kreskami poziomymi:** T, E, F, H, A (poprzeczka) – zwykle wyższe `x_ege` w pewnych obszarach.
  - **Litery z małą liczbą kresek poziomych lub bez nich:** I, L, V, J – zwykle niższe `x_ege`.
- Dokładna liczba i rozkład krawędzi poziomych pomaga odróżnić znaki, które poza tym wyglądają podobnie pod względem szerokości czy wysokości; np. **E i F różnią się głównie liczbą poziomych segmentów**.

**`x2ybr`** – prawdopodobnie znormalizowana miara obejmująca **kwadrat współrzędnej x i współrzędną y zapalonych pikseli** (średnia z x²·y albo podobny moment mieszany).
- Dlaczego ważna: momenty mieszane niosą bogatą informację o **kształcie, krzywiźnie i rozkładzie gęstości** pikseli litery – opisują jednoczesne rozłożenie pikseli w poziomie i pionie. Np.:
  - litera z większą liczbą pikseli w prawym górnym niż w lewym dolnym rogu ma inną wartość `x2ybr`;
  - litery zaokrąglone (S, C, G) i z prostych kresek (I, L, T) mają różne rozkłady kwadratów współrzędnych x i y, co `x2ybr` pozwala ująć ilościowo;
  - pomaga uchwycić subtelności orientacji kresek i to, jak „masa” litery rozkłada się na jej powierzchni.
- Wysoka ważność sugeruje, że model skutecznie wykorzystuje tę szczegółową informację o rozkładzie pikseli, by odróżniać nawet złożone lub podobne wizualnie znaki.

### 16. Jak poprawić model (s. 64–65)

- **Zadanie (s. 64):** na podstawie macierzy pomyłek z etykietami literowymi wyjaśnij strategie poprawy modelu rozpoznawania liter.
- **Strategia ze slajdu (s. 65):** **wypróbuj inny algorytm klasyfikacji.**
- Kolejna strategia (s. 66 i dalej): **strojenie hiperparametrów**.

### 17. Strojenie hiperparametrów w Apache Spark (s. 66–72)

#### Definicja i dwie metody (s. 67)

- **Strojenie hiperparametrów (hyperparameter tuning)** – w kontekście modeli ML w Apache Spark to proces **optymalizacji wartości hiperparametrów** modelu w celu poprawy jego wydajności.
- **Hiperparametry** to ustawienia modelu **definiowane przed rozpoczęciem treningu**, np. **liczba drzew** w lesie losowym, **współczynnik uczenia (learning rate)** w algorytmach spadku gradientu, **liczba iteracji**.
- Apache Spark ma w module MLlib wbudowane mechanizmy strojenia. Stosuje się głównie dwie metody:

| Metoda | Opis | Przykład / cecha |
|---|---|---|
| **1. Grid Search** (wyszukiwanie siatką) | definiujemy zbiór wartości hiperparametrów do przetestowania; Spark przechodzi przez **wszystkie możliwe kombinacje**, ocenia każdą i wybiera najlepszą | liczba drzew: [10, 50, 100], maks. głębokość: [5, 10, 20] → **3 × 3 = 9 konfiguracji** |
| **2. Random Search** (losowe wyszukiwanie) | zamiast testować wszystkie kombinacje, Spark **losowo próbkuje** wybrane zestawy hiperparametrów | **oszczędza czas** przy dużych przestrzeniach poszukiwań |

> Wyjaśnienie: w `pyspark.ml.tuning` gotowa siatka powstaje przez `ParamGridBuilder` (grid search); osobnej klasy do random search w tym module nie ma – losowy wybór trzeba przygotować samodzielnie (np. wylosować zestawy parametrów do listy `ParamMap`).

#### Plan strojenia lasu losowego (s. 68)

Strojenie hiperparametrów jest kluczowe dla optymalizacji modelu. Dla Random Forest można użyć **`CrossValidator`** z **`ParamGridBuilder`**, by systematycznie szukać najlepszych hiperparametrów. Plan:

1. **Zdefiniuj przestrzeń poszukiwań** – siatkę hiperparametrów `RandomForestClassifier`, np. `maxDepth`, `numTrees`, `minInstancesPerNode`. Użyj `ParamGridBuilder`, by utworzyć wszystkie kombinacje.
2. **Skonfiguruj walidację krzyżową** – `CrossValidator` z estymatorem `RandomForestClassifier`, zdefiniowaną siatką i `MulticlassClassificationEvaluator` (np. metryka `'accuracy'`). Określ **liczbę foldów**.
3. **Uruchom strojenie** – dopasuj (`fit`) `CrossValidator` do danych treningowych (`df_train_`). Spowoduje to wytrenowanie i ocenę wielu modeli dla różnych kombinacji hiperparametrów, aby znaleźć najlepszy.
4. **Pobierz najlepszy model i oceń go** – wyciągnij najlepszy model znaleziony przez `CrossValidator`, zrób predykcje na zbiorze ewaluacyjnym (`df_eval_`) i policz metryki (Accuracy, Precision, Recall, F1-Score), by porównać z modelem początkowym.
5. **Zadanie końcowe** – podsumuj wyniki strojenia: najlepsze hiperparametry i ewentualną poprawę względem domyślnego modelu Random Forest.

#### Jak działa strojenie w Apache Spark? (s. 69–70)

1. **Utwórz model z hiperparametrami do strojenia** – model (np. Random Forest) musi być skonfigurowany tak, by przyjmował różne wartości hiperparametrów.
2. **Zdefiniuj siatkę / przestrzeń hiperparametrów** – obiekt **`ParamGridBuilder`** definiuje zbiór wartości do przetestowania.
3. **Oceń wydajność modelu** – metryka, np. **accuracy, F1-score lub RMSE**, zależnie od problemu. Spark używa obiektu **Evaluator**, np. **`BinaryClassificationEvaluator`** dla klasyfikacji binarnej.
4. **Użyj walidacji krzyżowej lub podziału Train-Validation** – Spark automatycznie dzieli dane na zbiór treningowy i walidacyjny za pomocą obiektu **`CrossValidator`** lub **`TrainValidationSplit`**.

#### Przykład kodu PySpark (s. 71)

```python
from pyspark.ml.tuning import ParamGridBuilder, CrossValidator
from pyspark.ml.evaluation import MulticlassClassificationEvaluator
from pyspark.ml.classification import RandomForestClassifier

# Model:
rf = RandomForestClassifier(labelCol="label", featuresCol="features")

# Siatka hiperparametrów
paramGrid = (ParamGridBuilder()
        .addGrid(rf.numTrees, [10, 50, 100])
        .addGrid(rf.maxDepth, [5, 10, 20])
        .build())

# Ewaluator:
evaluator = MulticlassClassificationEvaluator(metricName="accuracy")

# Cross-validation
cv = CrossValidator(estimator=rf,
            estimatorParamMaps=paramGrid,
            evaluator=evaluator,
            numFolds=5)  # 5-fold cross-validation

# Dopasowanie modelu:
cvModel = cv.fit(trainingData)

# Najlepsze hiperparametry
bestModel = cvModel.bestModel
print("Liczba drzew:", bestModel.getNumTrees)
print("Maksymalna głębokość:", bestModel.getMaxDepth())
```

Co robi:
- Importy: `ParamGridBuilder`, `CrossValidator` z **`pyspark.ml.tuning`**; `MulticlassClassificationEvaluator` z `pyspark.ml.evaluation`; `RandomForestClassifier` z `pyspark.ml.classification`.
- `ParamGridBuilder().addGrid(param, [wartości])...build()` – buduje siatkę: 3 wartości `numTrees` × 3 wartości `maxDepth` = **9 kombinacji**.
- `CrossValidator(estimator=..., estimatorParamMaps=..., evaluator=..., numFolds=5)` – **5-krotna walidacja krzyżowa**; łącznie 9 × 5 = 45 treningów, a potem trening najlepszej konfiguracji na całych danych.
- `cv.fit(trainingData)` – uruchamia strojenie; zwraca `CrossValidatorModel`.
- `cvModel.bestModel` – najlepszy znaleziony model; `bestModel.getNumTrees` (na slajdzie bez nawiasów – w modelu RF to właściwość), `bestModel.getMaxDepth()`.

> Wyjaśnienie: `TrainValidationSplit` działa podobnie, ale zamiast k foldów ocenia każdą kombinację tylko raz, na jednym podziale trening/walidacja (parametr `trainRatio`) – jest szybszy, ale mniej wiarygodny.

Slajd 72 zawiera tylko nagłówek „Tuning Hyperparameters in Apache Spark” (bez dodatkowej treści).

### Kolejność plików ze slajdów (ściąga)

| Plik | Slajdy | Zawartość |
|---|---|---|
| `ml_1.py` | 13–16 | `SparkSession`, `read.csv(..., header=False, inferSchema=True)`, `show`, `schema`, `describe()` |
| `ml_2.py` | 18–22 | własny schemat `StructType`/`StructField`, `count()`, `createOrReplaceTempView`, `spark.sql(... GROUP BY ...)` |
| `ml_5.py` | 37 | `randomSplit([0.7, 0.3], 42)`, `StringIndexer` + `fit`/`transform` |
| `ml_6.py` | 38–39 | `VectorAssembler(inputCols=df.columns[1:], outputCol="feat")`, `select("label", "feat")` |
| `ml_7.py` | 40 | `StandardScaler(inputCol="feat", outputCol="features")` + `fit`/`transform` |
| `ml_8.py` | 44 | `RandomForestClassifier(maxDepth=8, minInstancesPerNode=5, seed=42)` + `fit`/`transform` |
| `ml_9.py` | 47–48 | `MulticlassClassificationEvaluator(metricName="accuracy")`, `evaluate`, transformacja `df_eval` |
| `ml_10.py` | 50 | `Pipeline(stages=[idx, vect, scaler, forest])`, `pipe.fit(df_train)` |
| `ml_11.py` | 51 | `pipe_t.save("model")` |

#### Najważniejsze do zapamiętania

1. MLlib (`pyspark.ml`, pakiet `org.apache.spark.ml`) – zaleta: praca **na klastrze** z dużymi danymi; jest mniej rozbudowana niż PyTorch, TensorFlow, Scikit-learn, Theano czy Keras.
2. Zalecane jest API **DataFrame**, nie RDD: wygodniejsze, daje Spark Datasources, zapytania SQL/DataFrame, optymalizacje **Catalyst**, jednolite API w różnych językach i łatwiejsze pipeline'y.
3. API RDD jest w **trybie utrzymania (maintenance mode)**, ale **nie jest przestarzałe (deprecated)**; MLlib jako całość też nie.
4. Zbiór **Letter Recognition (UCI)**: **20 000** rekordów, **26** liter (A–Z), **16** cech całkowitych w zakresie **0–15**, **20 fontów**, **brak braków danych**; trening na pierwszych 16 000, predykcja na 4 000.
5. Odczyt CSV: `spark.read.csv("letter-recognition.data", header=False, inferSchema=True)`; z własnym schematem: `schema=schema`, gdzie `StructField("lettr", StringType(), True)` – nazwa, typ, czy NULL dozwolony.
6. `df.describe().show()` – statystyki count/mean/stddev/min/max; `df.count()` to **akcja** zwracająca `int` (nie ma `show()`).
7. `df.createOrReplaceTempView("df")` + `spark.sql("SELECT lettr, COUNT(*) count FROM df GROUP BY lettr ORDER BY lettr")` – rozkład etykiet.
8. **Estimator** ma `fit(DF)` i zwraca **Transformer**; **Transformer** ma `transform(DF)` i zwraca nowy DF (np. z predykcjami); **Evaluator** liczy metryki z predykcji; **Pipeline** to szeregowe połączenie etapów i sam jest estymatorem.
9. `df.randomSplit([0.7, 0.3], 42)` – podział 70/30, **42 = seed**.
10. `StringIndexer(inputCol="lettr", outputCol="label")` – **estymator**; zamienia napisy na liczby (A → 0.0), bo operacje modelu są **macierzowe**.
11. `VectorAssembler(inputCols=df.columns[1:], outputCol="feat")` – **transformer** (bez `fit`, nie uczy się z danych); składa cechy w wektor.
12. `StandardScaler(inputCol="feat", outputCol="features")` – **estymator** (`fit`, potem `transform`), skaluje średnią i odchyleniem standardowym.
13. `RandomForestClassifier(maxDepth=8, minInstancesPerNode=5, seed=42)` → `forest.fit(df_train_)` → `forest_t.transform(...)` dodaje kolumny `rawPrediction`, `probability`, **`prediction`**.
14. Domyślne parametry RF: `numTrees=20`, `maxDepth=5` (zakres 0–30), `maxBins=32`, `impurity='gini'`, `maxMemoryInMB=256`, `featuresCol='features'`, `labelCol='label'`.
15. `GBTClassifier` – tylko etykiety **binarne**; `RandomForestClassifier` i `DecisionTreeClassifier` – binarne i wieloklasowe; `LinearSVC` – binarny, Hinge Loss, optymalizator OWLQN.
16. Ewaluacja: `evaluation.MulticlassClassificationEvaluator(metricName="accuracy").evaluate(pred)`; inne `metricName`: `"weightedPrecision"`, `"weightedRecall"`, `"weightedFMeasure"`.
17. Wyniki: accuracy ≈ **0.79 na treningu** i ≈ **0.76 na teście** (kilka procent mniej); testowo: precision 0.7886, recall 0.7595, F1 0.7614.
18. Wzory: Accuracy = poprawne / wszystkie; **Precision = TP/(TP+FP)**; **Recall = TP/(TP+FN)**; **F1 = 2·P·R/(P+R)** – średnia harmoniczna.
19. Przykład spamu: TP = 40, TN = 45, FP = 5, FN = 10; sama accuracy może mylić (95% nie-spamu → model „zawsze nie spam” ma 95% accuracy).
20. Macierz pomyłek w Sparku: `predictions_and_labels.crosstab("label", "prediction")` → `toPandas()` → `sns.heatmap`; kolumna z etykietami prawdziwymi to `label_prediction`.
21. Najtrudniejsza litera: **H** (69 trafień, m.in. 44 razy jako X); najlepsza: **W** (246 trafień, FP = 36, FN = 15).
22. Ważność cech: `forest_t.featureImportances` + `assembler.getInputCols()`; top 3: **`x_ege`** (0.145), **`x2ybr`** (0.121), **`y_ege`** (0.111); najmniej ważna `high`.
23. Pipeline: `Pipeline(stages=[idx, vect, scaler, forest])` – **kolejność etapów ma znaczenie**; `pipe.fit(df_train)`, a zapis `pipe_t.save("model")` tworzy katalogi `metadata` i `stages`.
24. Strojenie: hiperparametry ustala się **przed treningiem**; **Grid Search** = wszystkie kombinacje (3×3 = 9), **Random Search** = losowe próbki, szybsze przy dużych przestrzeniach.
25. Składnia strojenia: `ParamGridBuilder().addGrid(rf.numTrees, [10, 50, 100]).addGrid(rf.maxDepth, [5, 10, 20]).build()`; `CrossValidator(estimator=rf, estimatorParamMaps=paramGrid, evaluator=evaluator, numFolds=5)`; `cvModel = cv.fit(...)`; `cvModel.bestModel`. Wybór modelu w MLlib: **`CrossValidator`** (k-fold; przy k = 3: 2/3 trening, 1/3 test, każdy fold testowy dokładnie raz) lub **`TrainValidationSplit`**.

---

<a id="wykład-3"></a>

# Wykład 3 – Systemy rekomendacyjne, ALS


Źródła cytowane na slajdach: https://developers.google.com/machine-learning/recommendation, https://grouplens.org/datasets/movielens/, https://www.kaggle.com/ibtesama/getting-started-with-a-movie-recommendation-system, https://spark.apache.org/docs/latest/ml-collaborative-filtering.html.

### 1. Wprowadzenie i statystyki (s. 1)

- **40%** instalacji aplikacji w Google Play pochodzi z rekomendacji.
- **60%** czasu oglądania na YouTube pochodzi z rekomendacji.

### 2. Zadania laboratoryjne / plan wykładu (s. 2)

1. Na podstawie dokumentacji przeczytać, czym jest system rekomendacyjny i jakie są metody jego tworzenia.
2. Pobrać przykładowy zbiór danych z internetu, np. bazę filmów i ich ocen (MovieLens: https://grouplens.org/datasets/movielens/).
3. Przeczytać opis pobranego zbioru danych.
4. Utworzyć sesję Spark i wczytać zbiór danych z plików `*.csv`.
5. Zainicjalizować estymator, czyli przygotować gotowy, **niewytrenowany** model.
6. Wytrenować model na zbiorze treningowym, aby generował rekomendacje.
7. Ocenić model i predykcje.
8. Za pomocą modelu odpowiedzieć na pytania:
   - które filmy warto pokazać konkretnym użytkownikom?
   - którzy użytkownicy polubią dane filmy?

### 3. Czym jest system rekomendacyjny? (s. 3–4)

- Gwałtowny wzrost ilości zbieranych danych sprawił, że użytkownicy (lub systemy) nie są w stanie na bieżąco reagować na zmieniającą się ofertę.
- **Dlaczego?** Bo nadmiar informacji prowadzi do **przeciążenia informacyjnego** (information overload) i daje wiele alternatyw wyboru, które nie zawsze pasują do preferencji użytkownika.
- **Definicja:** systemy rekomendacyjne to rodzaj **systemów filtrowania informacji**. Poprawiają jakość wyników wyszukiwania i zwracają wyniki trafniejsze względem kryteriów wyszukiwania lub powiązane z historią wyszukiwań użytkownika.
- Służą do **przewidywania oceny lub preferencji**, jaką użytkownik nadałby danemu elementowi (item).

Przykłady:
- **Spotify, Netflix** – ich biznes i sukces zależą od skuteczności silników rekomendacji.
- **YouTube** – decyduje, który film spośród ok. miliarda filmów odtworzyć w trybie **autoplay**.
- **Facebook** – rekomenduje strony do polubienia i obserwowania.
- **Amazon** – podpowiada klientom produkty.
- **Google Play** oferuje miliony aplikacji. Pytanie: jak użytkownik ma znaleźć nowe, atrakcyjne treści? Odpowiedź: można używać wyszukiwarki, ale **silnik rekomendacji może pokazać elementy, o których użytkownik sam by nie pomyślał**.
- „… inne …” – podaj przykłady samodzielnie.

### 4. Cele systemów rekomendacyjnych (s. 5–6)

Ogólnie:
- przewidywanie preferencji użytkownika i proponowanie mu produktów, treści lub usług, które mogą go zainteresować;
- wspieranie decyzji w przepełnionym informacjami świecie, w którym liczba dostępnych opcji może przytłaczać.

| Cele dla użytkownika | Cele dla firmy |
|---|---|
| zwiększenie satysfakcji użytkownika | wzrost sprzedaży |
| poprawa doświadczenia zakupowego | utrzymanie lojalności klientów |
| dłuższa i bardziej zaangażowana interakcja z serwisem lub platformą | optymalizacja oferty |

### 5. Komponenty systemu rekomendacyjnego (s. 7–8)

1. **Zbieranie danych (Data collection)** – dane o użytkownikach, ich preferencjach, historii zakupów, ocenach, a nawet dane demograficzne.
2. **Wstępne przetwarzanie danych (Data preprocessing)** – przetwarzanie i czyszczenie danych: usuwanie błędów, braków i innych nieprawidłowości.
3. **Model generowania kandydatów (Candidate generation model)** – tworzy wstępną listę propozycji (kandydatów) na podstawie analizy preferencji. Może używać metod content-based (analiza treści) lub collaborative filtering (analiza podobieństwa między użytkownikami lub elementami).
4. **Ocena kandydatów (Candidate evaluation)** – system ocenia, jak dobrze każdy kandydat pasuje do preferencji użytkownika: na podstawie wcześniejszych interakcji, ocen innych użytkowników lub innych czynników.
5. **Aktualizacja modelu (Model update)** – w miarę korzystania z systemu preferencje się zmieniają, więc model trzeba regularnie aktualizować.
6. **Generowanie rekomendacji (Recommendation generation)** – na podstawie ocen kandydatów system tworzy końcowe rekomendacje.
7. **Pozycjonowanie w rankingu (Positioning in the ranking)** – gdy rekomendacji jest więcej niż jedna, trzeba ustalić, która będzie najatrakcyjniejsza. Ranking uwzględnia dodatkowe czynniki: **popularność, dostępność i świeżość** produktu.
8. **Informacja zwrotna od użytkownika (User feedback)** – cenna do dalszego ulepszania systemu. System musi być elastyczny i dostosowywać się do zmieniających się preferencji i oczekiwań.

### 6. Terminologia (s. 9–10)

- **Items (elementy, zwane też documents)** – to, co system rekomenduje. W Google Play items to aplikacje do zainstalowania, w YouTube – filmy.
- **Query (zapytanie, kontekst)** – informacje, których system używa do tworzenia rekomendacji. Zapytanie może być kombinacją kilku elementów (patrz s. 15).
- **Embedding (osadzenie; na slajdzie: „Placement”)** – odwzorowanie z określonego zbioru (tu: zbioru zapytań lub rekomendowanych elementów) w przestrzeń wektorową zwaną **przestrzenią osadzeń (embedding space)**. Wiele systemów rekomendacyjnych wymaga nauczenia się odpowiedniej reprezentacji zapytań i elementów.

### 7. Zbiory danych: MovieLens, Kaggle i trzy podejścia (s. 11)

- **MovieLens / GroupLens** (Social Computing Research, University of Minnesota): GroupLens Research zebrał i udostępnił zbiory ocen z serwisu MovieLens (https://movielens.org). Zbiory zbierano w różnych okresach, zależnie od rozmiaru. **Uwaga:** przed użyciem przejrzyj pliki i README pod kątem licencji i innych szczegółów.
- **Kaggle → Data sets** (https://www.kaggle.com/search?q=movie), przykłady notebooków: Movie Recommender Systems, Netflix – Movie recommendation, Getting Started with a Movie Recommendation System, Movie Industry, TMDB 5000 Movie Dataset.
- **Movie Recommendation through Correlations / CF** – zbiór prosto z Netflixa: 4 pliki tekstowe, ponad 20 mln wierszy, ponad 4 tys. filmów i 400 tys. klientów. Łącznie ponad 17 tys. filmów i ponad 500 tys. klientów.
- **System rekomendacji filmów na zbiorze TMDB 5000** – trzy podejścia:

| Podejście | Na czym polega |
|---|---|
| **Demographic Filtering** (filtrowanie demograficzne) | Rekomendacje na podstawie **popularności** filmu i/lub **gatunku**. Użytkownicy o podobnych cechach demograficznych dostają te same filmy. Filmy popularniejsze i lepiej oceniane przez grupę mają większą szansę się spodobać niż filmy wybrane przez przeciętnego widza. |
| **Content Based Filtering** (filtrowanie oparte na treści) | Podpowiada elementy podobne do konkretnego elementu. Używa metadanych filmu: gatunku, reżysera, opisu, aktorów itd. Założenie: jeśli ktoś lubi dany element, polubi też element do niego podobny. |
| **Collaborative Filtering** (filtrowanie kolaboratywne / grupowe) | Dopasowuje ludzi o podobnych zainteresowaniach i na tej podstawie rekomenduje. **Nie wymaga metadanych** o treści elementów. |

### 8. Demographic Filtering i ważona ocena WR (s. 12)

Wymagane kroki:
- **A.** Obliczyć metrykę (wynik) dla każdego filmu.
- **B.** Posortować filmy według metryki, np. średniej oceny.
- **C.** Zarekomendować (limit N) najlepiej ocenione filmy.

Sama średnia ocen **nie wystarcza**: film ze średnią **8,9 i tylko 3 głosami** nie jest lepszy od filmu ze średnią **7,8 i 40 głosami**. Dlatego stosuje się **ważoną średnią ocenę (Weighted Rating, WR)** – wzór IMDB:

$$
WR = \left(\frac{v}{v+m}\cdot R\right) + \left(\frac{m}{v+m}\cdot C\right)
$$

gdzie:
- $v$ – liczba głosów oddanych na film,
- $m$ – minimalna liczba głosów wymagana, aby film trafił do zestawienia,
- $R$ – średnia ocena filmu,
- $C$ – (na slajdzie: „średnia liczba głosów w całym raporcie”) – w rzeczywistości **średnia ocena** wszystkich filmów w całym zestawieniu.

> Wyjaśnienie: przy małym $v$ wynik ciągnie się w stronę średniej globalnej $C$, przy dużym $v$ – w stronę własnej średniej filmu $R$. Wagi $\frac{v}{v+m}$ i $\frac{m}{v+m}$ sumują się do 1.

### 9. Content Based Filtering i TF-IDF (s. 13)

- **A.** Szukamy podobieństwa filmów na podstawie informacji o ich treści (recenzja, obsada, ekipa, słowa kluczowe, tagline itd.).
  - Liczymy **parami** wyniki podobieństwa dla wszystkich filmów na podstawie opisów fabuły (pole `overview` w zbiorze) i rekomendujemy filmy według tego wyniku.
  - W tym celu tekst trzeba zamienić na **wektor słów** dla każdego opisu, a następnie przeanalizować, np. metodą **TF-IDF (Term Frequency – Inverse Document Frequency)**, która analizuje liczbę wystąpień słów i ich znaczenie.
  - **TF** – względna częstość słowa w dokumencie: (liczba wystąpień termu / łączna liczba wystąpień słów). **IDF** – odwrotna częstość w dokumentach: $\log(\text{liczba dokumentów} / \text{liczba dokumentów zawierających term})$.

$$
\mathrm{TF}(t,d)=\frac{n_{t,d}}{\sum_k n_{k,d}},\qquad
\mathrm{IDF}(t)=\log\frac{N}{N_t},\qquad
\text{TF-IDF}(t,d)=\mathrm{TF}(t,d)\cdot \mathrm{IDF}(t)
$$

  gdzie $n_{t,d}$ – liczba wystąpień termu $t$ w dokumencie $d$, $N$ – liczba dokumentów, $N_t$ – liczba dokumentów zawierających $t$. (Iloczyn TF·IDF to zapis standardowy; slajd podaje słownie TF i IDF.)
  - W zbiorze TMDB 5000 do opisania ok. **4800 filmów** użyto ponad **20 000 różnych słów**.
  - Po zbudowaniu macierzy można liczyć wynik podobieństwa. Algorytmy: **euklidesowy, Pearsona, cosinusowy**.
- **B.** Rekomendujemy filmy najbardziej podobne.
- Diagram: User A lubi Movie A (Love; Romantic), User B lubi Movie B (Horror; Thriller), User C lubi Movie C (Love; Romantic). Movie A i Movie C są podobne (ten sam typ), więc User A dostaje rekomendację Movie C.

### 10. Który model rekomendacji wybrać? Zapytanie i kontekst (s. 14–15)

- Odpowiedź: **nie ma jednoznacznej odpowiedzi – to zależy**.
- Od czego? Od **zapytań (queries)** wysyłanych do systemu, czyli od ich **kontekstu**.
- Informacje, na których system opiera rekomendacje, to zapytania będące kombinacją:
  - **informacji o użytkowniku:** ID użytkownika, elementy, z którymi użytkownik wcześniej wchodził w interakcję, inne;
  - **dodatkowego kontekstu:** pora dnia, urządzenie użytkownika, inne.
- Embedding – odwzorowanie zbioru zapytań lub elementów w przestrzeń wektorową (embedding space), patrz sekcja 13.

### 11. Typowa architektura: Candidate Generation → Scoring → Re-ranking (s. 16)

Diagram: trzy etapy, stosy monet malejące od lewej do prawej (coraz mniej elementów).

- **A. Candidate Generation (generowanie kandydatów)** – system startuje z potencjalnie ogromnego korpusu i tworzy znacznie mniejszy podzbiór kandydatów. Np. generator kandydatów w YouTube redukuje **miliardy filmów do setek lub tysięcy**. Model musi szybko oceniać zapytania wobec ogromnego korpusu. Jeden model może mieć **wiele generatorów kandydatów**, z których każdy nominuje inny podzbiór.
- **B. Scoring (ocenianie)** – inny model ocenia i szereguje kandydatów, aby wybrać zbiór elementów (rzędu **10**) do pokazania użytkownikowi. Ponieważ ocenia stosunkowo mały podzbiór, może być **dokładniejszy** i korzystać z dodatkowych zapytań.
- **C. Re-ranking (ponowne szeregowanie)** – system uwzględnia dodatkowe ograniczenia końcowego rankingu, np. usuwa elementy, których użytkownik wprost nie lubi, albo podbija wynik świeższych treści. Re-ranking pomaga też zapewnić **różnorodność (diversity), świeżość (freshness) i sprawiedliwość (fairness)**.

### 12. Generowanie kandydatów: content-based vs collaborative (s. 17, 21)

Generowanie kandydatów to pierwszy etap rekomendacji: dla danego zapytania system tworzy zbiór trafnych kandydatów.

| Typ | Definicja | Przykład |
|---|---|---|
| **content-based filtering** | Używa **podobieństwa między elementami**, aby polecać elementy podobne do tych, które użytkownik lubi. | Jeśli użytkownik A obejrzał dwa filmiki z uroczymi kotami, system może polecić mu filmiki z uroczymi zwierzętami. |
| **collaborative filtering** | Używa **jednocześnie podobieństw między zapytaniami (użytkownikami) i elementami**. | Jeśli użytkownik A jest podobny do użytkownika B, a B lubi film 1, system może polecić film 1 użytkownikowi A, **nawet jeśli A nie widział żadnych filmów podobnych do filmu 1**. |

Collaborative Filtering (na slajdzie także: „Filtrowanie grupowe”) – s. 21 powtarza tę definicję i przykład.

### 13. Przestrzeń osadzeń i miary podobieństwa (s. 18–19)

- Zarówno content-based, jak i collaborative filtering odwzorowują każdy element i każde zapytanie (kontekst) na wektor osadzenia we **wspólnej przestrzeni osadzeń** $E = \mathbb{R}^d$.
- Zwykle przestrzeń jest **niskowymiarowa** ($d$ jest dużo mniejsze od rozmiaru korpusu) i uchwytuje pewną ukrytą (latent) strukturę zbioru elementów lub zapytań. Podobne elementy, np. filmy YouTube oglądane zwykle przez tego samego użytkownika, lądują blisko siebie. „Bliskość” definiuje **miara podobieństwa**.
- **Miara podobieństwa** to funkcja $s: E \times E \to \mathbb{R}$, która bierze parę osadzeń i zwraca skalar mierzący ich podobieństwo.
- Generowanie kandydatów: dla osadzenia zapytania $q \in E$ system szuka osadzeń elementów $x \in E$ bliskich $q$, czyli o wysokim podobieństwie $s(q, x)$.
- Najczęściej używane miary: **cosinus, iloczyn skalarny (dot product), odległość euklidesowa**.

**Cosinus** – cosinus kąta między wektorami:

$$
s(q,x) = \cos(q,x)
$$

**Iloczyn skalarny (dot product):**

$$
s(q,x) = \langle q, x\rangle = \sum_{i=1}^{d} q_i x_i
$$

równoważnie:

$$
s(q,x) = \|x\|\,\|q\|\,\cos(q,x)
$$

czyli cosinus kąta pomnożony przez iloczyn norm. **Jeśli osadzenia są znormalizowane, iloczyn skalarny i cosinus są równe.**

**Odległość euklidesowa** – zwykła odległość w przestrzeni euklidesowej:

$$
s(q,x) = \|q - x\| = \left[\sum_{i=1}^{d} (q_i - x_i)^2\right]^{\frac{1}{2}}
$$

**Mniejsza odległość oznacza większe podobieństwo.** Dla znormalizowanych osadzeń kwadrat odległości euklidesowej pokrywa się z iloczynem skalarnym (i cosinusem) z dokładnością do stałej, bo wtedy:

$$
\frac{1}{2}\|q - x\|^2 = 1 - \langle q, x\rangle
$$

Symbole: $q$ – osadzenie zapytania, $x$ – osadzenie elementu, $d$ – wymiar przestrzeni, $q_i, x_i$ – $i$-te współrzędne, $\|\cdot\|$ – norma euklidesowa.

**Porównanie miar (diagram):** czarny wektor to osadzenie zapytania (Query), pozostałe (Item A – długi pomarańczowy, Item B – niebieski, Item C – krótki zielony, bliski kierunkiem zapytaniu) to kandydaci. **Ranking elementów zależy od użytej miary podobieństwa.**

> Wyjaśnienie (według źródła Google, z którego pochodzi diagram): cosinus faworyzuje Item C (najmniejszy kąt), iloczyn skalarny – Item A (długi wektor), odległość euklidesowa – Item B (najbliższy punkt).

### 14. Podobieństwo cosinusowe w content-based (s. 20)

Wynik podobieństwa **cosinusowego** wybrano, bo **nie zależy od długości (magnitude) wektorów** i jest stosunkowo łatwy i szybki do obliczenia:

$$
\text{similarity} = \cos(\theta) = \frac{\mathbf{A}\cdot\mathbf{B}}{\|\mathbf{A}\|\,\|\mathbf{B}\|} = \frac{\sum_{i=1}^{n} A_i B_i}{\sqrt{\sum_{i=1}^{n} A_i^2}\,\sqrt{\sum_{i=1}^{n} B_i^2}}
$$

gdzie $\mathbf{A}, \mathbf{B}$ – wektory (np. TF-IDF dwóch filmów), $A_i, B_i$ – ich składowe, $n$ – liczba składowych, $\theta$ – kąt między wektorami.

Procedura:
1. Pobierz indeks filmu na podstawie tytułu.
2. Pobierz listę wyników podobieństwa cosinusowego tego filmu ze wszystkimi filmami.
3. Zamień ją na listę krotek: (pozycja, wynik podobieństwa).
4. Posortuj krotki według wyniku podobieństwa (drugiego elementu).
5. Weź 10 pierwszych elementów.
6. **Pomiń pierwszy element**, bo dotyczy samego filmu (najbardziej podobny do filmu jest on sam).
7. Zwróć tytuły odpowiadające indeksom najlepszych elementów.

### 15. Przykład rekomendacji filmów: macierz feedbacku (s. 22)

Dane treningowe to **macierz feedbacku (feedback matrix)**:
- każdy **wiersz** to użytkownik,
- każda **kolumna** to element (film).

Dwa rodzaje feedbacku:

| Rodzaj | Opis |
|---|---|
| **Explicit (jawny)** | Użytkownik sam określa, jak bardzo podobał mu się film, wystawiając ocenę liczbową. |
| **Implicit (niejawny)** | Jeśli użytkownik obejrzał film, system wnioskuje, że jest nim zainteresowany. |

Upraszczamy: macierz feedbacku jest **binarna** – 1 oznacza zainteresowanie filmem.

Na stronie głównej system powinien polecać filmy na podstawie:
- podobieństwa do filmów, które użytkownik lubił wcześniej (content-based),
- filmów, które lubili podobni użytkownicy (collaborative).

### 16. Embedding 1D (s. 23–24)

Ręcznie zaprojektowane cechy dla filmów:

| Film | Kategoria | Opis |
|---|---|---|
| The Dark Knight Rises | PG-13 | Batman próbuje ocalić Gotham przed zagładą nuklearną; sequel The Dark Knight, uniwersum DC. |
| Harry Potter and the Sorcerer's Stone | PG | Osierocony chłopiec odkrywa, że jest czarodziejem, trafia do Hogwartu i walczy z Voldemortem. |
| Shrek | PG | Sympatyczny ogr i jego osioł ruszają na ratunek księżniczce Fionie uwięzionej przez smoka. |
| The Triplets of Belleville | PG-13 | Kolarz Champion zostaje porwany podczas Tour de France; babcia i pies ruszają mu na ratunek z pomocą trzech starszych śpiewaczek jazzowych. |
| Memento | R | Mężczyzna z amnezją próbuje rozwiązać zagadkę morderstwa żony, tatuując wskazówki na ciele. |

- Każdemu filmowi przypisujemy skalar z przedziału **[-1, 1]**: ujemny – film dla dzieci, dodatni – dla dorosłych.
- Każdemu użytkownikowi przypisujemy skalar z **[-1, 1]**: zainteresowanie filmami dla dzieci (bliżej -1) lub dla dorosłych (bliżej +1).
- **Iloczyn osadzenia filmu i osadzenia użytkownika powinien być wyższy (bliżej 1) dla filmów, które użytkownik prawdopodobnie polubi.**
- Oś: Shrek, Trojaczki z Belleville (strona dzieci) – Harry Potter (środek) – The Dark Knight Rises, Memento (strona dorosłych).

Macierz 1D (✔ = film obejrzany):

| Użytkownik (preferencja) | Harry Potter (-0,2) | Triplets (-0,8) | Shrek (-1) | Dark Knight Rises (0,9) | Memento (1) |
|---|---|---|---|---|---|
| U1 (0,1) | ✔ | | ✔ | ✔ | |
| U2 (0) | | ✔ | | | ✔ |
| U3 (-1) | ✔ | ✔ | ✔ | | |
| U4 (1) | | | | ✔ | ✔ |

- Preferencje użytkowników **3 i 4** są dobrze wyjaśnione tą cechą (3 woli filmy dla dzieci, 4 dla dorosłych).
- Preferencji użytkowników **1 i 2 jedna cecha nie wyjaśnia**.

### 17. Embedding 2D (s. 25–26)

- Jedna cecha nie wystarczyła, więc dodajemy drugą: w jakim stopniu film jest **blockbusterem (+1) czy kinem artystycznym – arthouse (-1)**. Każdy film ma teraz osadzenie dwuwymiarowe.
- Wykres 2D: oś pozioma Children (-1) ↔ Adult (+1), oś pionowa Arthouse (-1) ↔ Blockbuster (+1). Shrek i Harry Potter – lewa/środkowa góra (blockbustery), The Dark Knight Rises – prawa góra, Triplets of Belleville – lewy dół, Memento – prawy dół.
- Użytkowników umieszczamy w **tej samej przestrzeni osadzeń** tak, aby najlepiej wyjaśnić macierz feedbacku: dla każdej pary (użytkownik, element) **iloczyn skalarny osadzeń ma być bliski 1, gdy użytkownik obejrzał film, a 0 w przeciwnym razie**.

| Film | arthouse↔blockbuster | children↔adult |
|---|---|---|
| Harry Potter | 0,9 | -0,2 |
| Triplets of Belleville | -0,8 | -0,8 |
| Shrek | 1 | -1 |
| The Dark Knight Rises | 1 | 0,9 |
| Memento | -0,9 | 1 |

| Użytkownik | pref. arthouse↔blockbuster | pref. children↔adult |
|---|---|---|
| U1 | 1 | 0,1 |
| U2 | -1 | 0 |
| U3 | 0,2 | -1 |
| U4 | 0,1 | 1 |

Na slajdzie zaznaczono pytanie „?” dla U4 i Shreka.

> Wyjaśnienie: $\langle(0{,}1;\ 1),(1;\ -1)\rangle = 0{,}1 - 1 = -0{,}9$, czyli Shrek nie pasuje do U4.

### 18. Uwaga o wspólnej przestrzeni i „kolaboratywności” (s. 27)

- Elementy i użytkowników reprezentujemy w **tej samej przestrzeni osadzeń**. To może dziwić, bo to różne byty, ale przestrzeń osadzeń można traktować jako **abstrakcyjną reprezentację wspólną** dla obu, w której miarą podobieństwa mierzymy podobieństwo lub trafność.
- Kolaboratywny charakter podejścia widać przy uczeniu osadzeń:
  - jeśli osadzenia **filmów są ustalone**, model uczy się osadzeń **użytkowników**, które najlepiej wyjaśniają ich preferencje – osadzenia użytkowników o podobnych preferencjach będą blisko siebie;
  - jeśli ustalone są osadzenia **użytkowników**, model uczy się osadzeń **filmów** – osadzenia filmów lubianych przez podobnych użytkowników będą blisko siebie.

### 19. Matrix Factorization (s. 28)

**Faktoryzacja macierzy** to prosty model osadzeń. Dla macierzy feedbacku $A \in \mathbb{R}^{m\times n}$, gdzie $m$ – liczba użytkowników (lub zapytań), $n$ – liczba elementów, model uczy się:
- macierzy osadzeń użytkowników $U \in \mathbb{R}^{m\times d}$ – wiersz $i$ to osadzenie użytkownika $i$,
- macierzy osadzeń elementów $V \in \mathbb{R}^{n\times d}$ – wiersz $j$ to osadzenie elementu $j$.

Osadzenia uczy się tak, aby iloczyn $UV^T$ był dobrym przybliżeniem macierzy $A$:

$$
A \approx U V^T,\qquad (U V^T)_{i,j} = \langle U_i, V_j\rangle \approx A_{i,j}
$$

Element $(i,j)$ macierzy $U V^T$ to po prostu iloczyn skalarny osadzeń użytkownika $i$ i elementu $j$, który ma być bliski $A_{i,j}$.

Przykład ze slajdu – $UV^T$ dla 4 użytkowników i 5 filmów (Harry Potter, Triplets, Shrek, Dark Knight Rises, Memento):

| | HP | Triplets | Shrek | DKR | Memento |
|---|---|---|---|---|---|
| U1 (1; 0,1) | 0,88 | -1,08 | 0,9 | 1,09 | -0,8 |
| U2 (-1; 0) | -0,9 | 1,0 | -1,0 | -1,0 | 0,9 |
| U3 (0,2; -1) | 0,38 | 0,6 | 1,2 | -0,7 | -1,18 |
| U4 (0,1; 1) | -0,11 | -0,9 | -0,9 | 1,0 | 0,91 |

(Wektory filmów na tym slajdzie: górny wiersz 0,9; -1; 1; 1; -0,9, dolny -0,2; -0,8; -1; 0,9; 1.) Wysokie wartości odpowiadają obejrzanym filmom z macierzy ✔.

### 20. Wybór funkcji celu: Observed-only MF, SVD, Weighted MF (s. 29–30)

**Funkcja celu tylko na obserwowanych parach** – minimalizacja sumy kwadratów błędów po obserwowanych wpisach:

$$
\min_{U\in\mathbb{R}^{m\times d},\ V\in\mathbb{R}^{n\times d}} \sum_{(i,j)\in \text{obs}} \left(A_{ij} - \langle U_i, V_j\rangle\right)^2
$$

- Sumujemy tylko po obserwowanych parach $(i,j)$, czyli po niezerowych wartościach macierzy feedbacku.
- **Problem:** sumowanie tylko po jedynkach to zły pomysł – macierz złożona z samych jedynek ma minimalną stratę, a model nie da skutecznych rekomendacji i **słabo generalizuje**.

**SVD (Singular Value Decomposition, rozkład według wartości osobliwych)** – suma po wszystkich wpisach (nieobserwowane = 0):

$$
\|A - U V^T\|_F^2 = \sum_{(i,j)} \left(A_{ij} - U_i\cdot V_j\right)^2
$$

- Ten problem kwadratowy można rozwiązać przez SVD macierzy, ale **SVD też nie jest dobrym rozwiązaniem**, bo w praktyce macierz $A$ jest bardzo **rzadka** (np. wszystkie filmy na YouTube kontra filmy obejrzane przez jednego użytkownika).
- Rozwiązanie $UV^T$ (przybliżenie macierzy wejściowej) będzie wtedy prawdopodobnie bliskie zeru, co daje **słabą generalizację**.

**Weighted Matrix Factorization (WMF, ważona faktoryzacja macierzy)** rozbija funkcję celu na dwie sumy:
- sumę po wpisach **obserwowanych**,
- sumę po wpisach **nieobserwowanych** (traktowanych jako zera).

$$
\min_{U\in\mathbb{R}^{m\times d},\ V\in\mathbb{R}^{n\times d}} \sum_{(i,j)\in \text{obs}} \left(A_{ij} - \langle U_i, V_j\rangle\right)^2 + w_0 \sum_{(i,j)\notin \text{obs}} \left(\langle U_i, V_j\rangle\right)^2
$$

- $w_0$ – **hiperparametr** ważący oba składniki, aby żaden nie zdominował funkcji celu. **Strojenie $w_0$ jest bardzo ważne.**
- Symbole: $A_{ij}$ – wartość feedbacku użytkownika $i$ dla elementu $j$; $U_i$, $V_j$ – wiersze macierzy osadzeń; obs – zbiór obserwowanych par; $d$ – wymiar osadzeń.

Porównanie z diagramu (s. 29):

| Wariant | Co sumuje | Wzór |
|---|---|---|
| Observed Only MF | tylko obserwowane (puste pola pominięte) | $\sum_{(i,j)\in obs}(A_{ij}-U_i\cdot V_j)^2$ |
| Weighted MF | obserwowane + nieobserwowane (jako 0) z wagą $w_0$ | $\sum_{obs}(A_{ij}-U_i\cdot V_j)^2 + w_0\sum_{\notin obs}(0-U_i\cdot V_j)^2$ |
| SVD | wszystkie wpisy jednakowo (braki = 0) | $\|A-UV^T\|_F^2=\sum_{(i,j)}(A_{ij}-U_i\cdot V_j)^2$ |

### 21. Minimalizacja funkcji celu: SGD i WALS (s. 31)

Typowe algorytmy:
- **Stochastic Gradient Descent (SGD)** – ogólna metoda minimalizacji funkcji straty.
- **Weighted Alternating Least Squares (WALS)** – wyspecjalizowany pod tę konkretną funkcję celu.

Funkcja celu jest **kwadratowa względem każdej z macierzy U i V osobno** (ale problem **nie jest łącznie wypukły**). WALS inicjalizuje osadzenia losowo, a potem naprzemiennie:
- ustala $U$ i rozwiązuje dla $V$,
- ustala $V$ i rozwiązuje dla $U$.

| | Zalety | Wady |
|---|---|---|
| **SGD** | bardzo elastyczny – może używać innych funkcji straty; da się zrównoleglić | wolniejszy – nie zbiega tak szybko; trudniej obsłużyć wpisy nieobserwowane (trzeba użyć negative sampling lub gravity) |
| **WALS** | da się zrównoleglić; zbiega szybciej niż SGD; łatwiej obsługuje wpisy nieobserwowane | opiera się wyłącznie na stracie kwadratowej (na slajdzie: „Reliant on Loss Squares only” – chodzi o least squares) |

### 22. Zbiór MovieLens small (s. 32)

- GroupLens zebrał i udostępnił zbiory ocen z MovieLens; przed użyciem przeczytaj README (licencja).
- **Small MovieLens:** **100 000 ocen** i **3 600 tagów** dla **9 000 filmów** od **600 użytkowników**. Ostatnia aktualizacja **9/2018**. Plik `ml-latest-small.zip` (ok. 1 MB).
- Opis:
  - użytkownicy wybrani **losowo**,
  - każdy wybrany użytkownik ocenił **co najmniej 20 filmów**,
  - **brak danych demograficznych**,
  - każdy użytkownik to tylko ID, bez innych informacji.
- Pliki: `links.csv`, `movies.csv`, `ratings.csv`, `tags.csv`.

`ratings.csv` (kodowanie **UTF-8**):

| Kolumna | Znaczenie |
|---|---|
| `userId` | ID użytkownika |
| `movieId` | ID filmu |
| `rating` | ocena od 0 do 5 w krokach co 0,5 |
| `timestamp` | czas w sekundach od 1970-01-01 (epoch) |

`movies.csv`:

| Kolumna | Znaczenie |
|---|---|
| `movieId` | ID filmu |
| `title` | tytuł filmu |
| `genres` | gatunki rozdzielone pionową kreską `|` |

Gatunki: Action, Adventure, Animation, Children's, Comedy, Crime, Documentary, Drama, Fantasy, Film-Noir, Horror, Musical, Mystery, Romance, Sci-Fi, Thriller, War, Western, (no genres listed).

Fragment `movies.csv`:

```text
movieId,title,genres
1,Toy Story (1995),Adventure|Animation|Children|Comedy|Fantasy
2,Jumanji (1995),Adventure|Children|Fantasy
3,Grumpier Old Men (1995),Comedy|Romance
4,Waiting to Exhale (1995),Comedy|Drama|Romance
5,Father of the Bride Part II (1995),Comedy
```

### 23. PySpark: wczytanie danych – `mlr_1rec.py` (s. 33)

```python
from pyspark.sql import SparkSession
spark = SparkSession.builder.appName("ml").getOrCreate()
ratings = spark.read.csv("ml-latest-small/ratings.csv", sep=",", header=True, inferSchema=True)
ratings.show(10)
ratings.printSchema()
```

Co robi: tworzy sesję Spark o nazwie `ml`, wczytuje `ratings.csv` jako DataFrame (`header=True` – pierwszy wiersz to nagłówki; `inferSchema=True` – **Spark sam rozpoznaje typy danych**), wyświetla 10 wierszy i schemat.

Wynik `show`:

```text
+------+-------+------+---------+
|userId|movieId|rating|timestamp|
+------+-------+------+---------+
|     1|      1|   4.0|964982703|
|     1|      3|   4.0|964981247|
|     1|      6|   4.0|964982224|
|     1|     47|   5.0|964983815|
|     1|     50|   5.0|964982931|
|     1|     70|   3.0|964982400|
```

`timestamp` – czas w sekundach od 1 stycznia 1970 (epoch).

Wynik `printSchema`:

```text
root
 |-- userId: integer (nullable = true)
 |-- movieId: integer (nullable = true)
 |-- rating: double (nullable = true)
 |-- timestamp: integer (nullable = true)
```

### 24. Podział na zbiór treningowy i testowy – `mlr_2rec.py` (s. 34)

```python
from pyspark.sql import SparkSession
spark = SparkSession.builder.appName("ml").getOrCreate()
ratings = spark.read.csv("ml-latest-small/ratings.csv", sep=",", header=True, inferSchema=True)
train, test = ratings.randomSplit([0.8, 0.2],42)
```

Co robi: losowo dzieli zbiór na dwa podzbiory – **80% treningowy, 20% testowy**. Parametr **42 to ziarno losowania (seed)**, dzięki któremu podział jest powtarzalny.

### 25. Model ALS – `mlr_2rec.py` (s. 35)

**ALS (Alternating Least Squares)** – algorytm naprzemiennych najmniejszych kwadratów służący do uczenia ukrytych czynników (latent factors).

```python
from pyspark.sql import SparkSession
spark = SparkSession.builder.appName("ml").getOrCreate()
ratings = spark.read.csv("ml-latest-small/ratings.csv", sep=",", header=True, inferSchema=True)
train, test = ratings.randomSplit([0.8, 0.2],42)
from pyspark.ml.recommendation import ALS
als = ALS(maxIter=5, regParam=0.01, userCol="userId", itemCol="movieId", ratingCol="rating",
          seed=42, coldStartStrategy="drop")
model = als.fit(train)
pred = model.transform(test)
pred.show(10)
```

Co robi kolejno:
- `from pyspark.ml.recommendation import ALS` – import biblioteki do budowy modelu rekomendacyjnego.
- `ALS(...)` – **inicjalizacja estymatora**, czyli przygotowanie gotowego, **niewytrenowanego** modelu.
- `als.fit(train)` – estymator wymaga wywołania metody **`fit`**. Wynikiem `fit()` jest **transformer** (wytrenowany model).
- `model.transform(test)` – metoda **`transform`** generuje predykcje (dokłada kolumnę `prediction`).
- **Prediction** – model stara się, aby `prediction` była jak najbliżej `rating`.

Parametry ALS:

| Parametr | Znaczenie |
|---|---|
| `maxIter=5` | model wykona **5 iteracji** treningu |
| `regParam=0.01` | **parametr regularyzacji** |
| `userCol="userId"`, `itemCol="movieId"`, `ratingCol="rating"` | kolumny: ID użytkownika, ID filmu, ocena |
| `seed=42` | ziarno losowe treningu |
| `coldStartStrategy="drop"` | strategia **zimnego startu** – co zrobić, gdy brak rekomendacji (np. nowy użytkownik) |

**`coldStartStrategy="drop"`** – Spark usuwa z DataFrame wszystkie wiersze z wartościami **NaN** w predykcjach. Metryka ewaluacji liczy się wtedy na danych bez NaN i jest poprawna.

Wynik `pred.show`:

```text
+------+-------+------+----------+----------+
|userId|movieId|rating| timestamp|prediction|
+------+-------+------+----------+----------+
|   182|    471|   4.5|1054779644| 3.484336 |
|   462|    471|   2.5|1123890831| 3.9725325|
|   610|    471|   4.0|1479544381| 3.4282506|
|   176|    471|   5.0| 840109075| 4.5944266|
|   448|    471|   4.0|1178980875| 2.9242966|
```

### 26. Ewaluacja – RegressionEvaluator, `mlr_3rec.py` (s. 36–37)

Ewaluację zaczynamy od importu **`RegressionEvaluator`**:

```python
from pyspark.sql import SparkSession
spark = SparkSession.builder.appName("ml").getOrCreate()
ratings = spark.read.csv("ml-latest-small/ratings.csv", sep=",", header=True, inferSchema=True)
train, test = ratings.randomSplit([0.8, 0.2],42)
from pyspark.ml.recommendation import ALS
als = ALS(maxIter=5, regParam=0.01, userCol="userId", itemCol="movieId", ratingCol="rating",
          seed=42, coldStartStrategy="drop")
model = als.fit(train)
pred = model.transform(test)
from pyspark.ml.evaluation import RegressionEvaluator
evaluator = RegressionEvaluator(metricName="rmse", labelCol="rating", predictionCol="prediction")
evaluator.evaluate(pred)
```

Co robi: tworzy ewaluator regresji z metryką **RMSE**, porównuje kolumnę rzeczywistą `rating` (`labelCol`) z przewidywaną `prediction` (`predictionCol`) i zwraca wynik. **Wynik na slajdzie: `1.0823243058259922`.**

> Wyjaśnienie: RMSE (root mean squared error) – pierwiastek ze średniej kwadratów błędów, $\mathrm{RMSE}=\sqrt{\frac{1}{N}\sum (r - \hat r)^2}$; im mniejszy, tym lepiej. Wynik ok. 1,08 oznacza średni błąd rzędu jednej gwiazdki.

### 27. Filmy warte pokazania użytkownikom – `recommendForAllUsers` (s. 38–39)

```python
# ... (kod jak wyżej: SparkSession, read.csv, randomSplit, ALS, fit, transform, RegressionEvaluator)
model.recommendForAllUsers(3).show(10, truncate=False)
```

Co robi: dla **każdego użytkownika** zwraca **3 najlepiej przewidziane filmy** (lista par `{movieId, przewidywana ocena}`); `show(10, truncate=False)` wyświetla 10 wierszy bez obcinania tekstu.

Wynik:

```text
+------+---------------------------------------------------------------+
|userId|recommendations                                                |
+------+---------------------------------------------------------------+
|471   |[{69406, 8.0032625}, {96004, 7.845047}, {32598, 7.700263}]     |
|463   |[{171763, 6.701351}, {5319, 6.510456}, {92535, 6.441631}]      |
|496   |[{3265, 7.251126}, {85780, 6.840547}, {97225, 6.8291626}]      |
|148   |[{56941, 7.0331554}, {118900, 6.72642}, {3030, 6.7040443}]     |
|540   |[{7046, 6.869965}, {3435, 6.7172174}, {171763, 6.415837}]      |
|392   |[{1334, 10.1420765}, {1194, 9.919676}, {140711, 8.537537}]     |
|243   |[{103341, 11.4821825}, {1260, 11.4727125}, {2613, 10.853818}]  |
|31    |[{102903, 12.082401}, {93270, 11.635988}, {179819, 11.196424}] |
|516   |[{2290, 8.513212}, {166534, 7.9887304}, {1904, 7.8702803}]     |
|580   |[{82, 6.6438103}, {6818, 6.405214}, {71899, 5.6740885}]        |
+------+---------------------------------------------------------------+
```

> Wyjaśnienie: przewidywane wartości przekraczają skalę 0–5 (np. 12,08), bo ALS nie ogranicza predykcji do zakresu ocen; przy `regParam=0.01` model mocno dopasowuje się do danych.

Linki ze slajdu: https://spark.apache.org/docs/latest/ml-collaborative-filtering.html, https://stackoverflow.com/questions/31544691/how-to-recommend-top-10-products-in-spark-als-for-all-the-users.

### 28. Użytkownicy, którym najpewniej spodobają się filmy – `recommendForAllItems` (s. 40–41)

```python
# ... (kod jak wyżej)
model.recommendForAllItems(3).show(10, truncate=False)
```

Co robi: dla **każdego filmu** zwraca **3 użytkowników**, którzy najpewniej go polubią (najwyższa przewidywana ocena).

(na slajdzie: pokazano wynik identyczny jak dla `recommendForAllUsers`, z kolumną `userId` – to pomyłka; poprawny wynik `recommendForAllItems` ma kolumnę `movieId` i listę par `{userId, przewidywana ocena}`.)

Link: https://spark.apache.org/docs/2.2.0/ml-collaborative-filtering.html.

### 29. Top 5 filmów dla konkretnych użytkowników – praca domowa (s. 42–43)

- Slajd tytułowy: „Top 5 filmów dla konkretnych użytkowników” (na slajdzie: „moviess”).
- Zadanie (Users who are most likely to like these movies / top 5 dla wybranych użytkowników): **praca własna – poszukaj na stronie projektu Apache Spark**.

> Wyjaśnienie: w API Spark służą do tego metody `recommendForUserSubset(dataset, numItems)` i `recommendForItemSubset(dataset, numUsers)` – nie ma ich na slajdach.

#### Najważniejsze do zapamiętania

1. 40% instalacji w Google Play i 60% czasu oglądania na YouTube pochodzi z rekomendacji.
2. System rekomendacyjny to rodzaj systemu **filtrowania informacji**; przewiduje ocenę/preferencję użytkownika dla elementu; odpowiedź na **information overload**.
3. Terminologia: **item** (document) – rekomendowany element; **query** (context) – informacje do rekomendacji (ID użytkownika, historia, pora dnia, urządzenie); **embedding** – odwzorowanie w przestrzeń wektorową $E=\mathbb{R}^d$, zwykle niskowymiarową.
4. Trzy podejścia: **Demographic** (popularność/gatunek), **Content-Based** (podobieństwo elementów, metadane), **Collaborative** (podobieństwo użytkowników i elementów jednocześnie, **bez metadanych**).
5. Wzór IMDB: $WR = \frac{v}{v+m}R + \frac{m}{v+m}C$; $v$ – głosy filmu, $m$ – minimum głosów, $R$ – średnia filmu, $C$ – średnia globalna.
6. TF = wystąpienia termu / wszystkie wystąpienia; IDF = log(liczba dokumentów / dokumenty z termem). TMDB 5000: ok. 4800 filmów, ponad 20 000 słów.
7. Content-based na slajdach używa **podobieństwa cosinusowego**, bo nie zależy od długości wektora i jest szybkie; w wynikach pomija się pierwszy element (sam film).
8. Architektura: **Candidate Generation → Scoring → Re-ranking**; YouTube: miliardy → setki/tysiące → ok. 10; re-ranking zapewnia diversity, freshness, fairness.
9. Miary podobieństwa: cosinus $\cos(q,x)$; dot product $\sum q_i x_i = \|q\|\|x\|\cos$; euklidesowa $\|q-x\|$ (mniejsza = bardziej podobne).
10. Dla znormalizowanych wektorów dot product = cosinus, a $\frac12\|q-x\|^2 = 1-\langle q,x\rangle$.
11. Feedback **explicit** (ocena liczbowa) vs **implicit** (obejrzał → zainteresowany).
12. Matrix Factorization: $A\in\mathbb{R}^{m\times n}\approx UV^T$, $U\in\mathbb{R}^{m\times d}$ (użytkownicy), $V\in\mathbb{R}^{n\times d}$ (elementy); $A_{ij}\approx\langle U_i,V_j\rangle$.
13. Observed-only MF – macierz samych jedynek daje minimalną stratę i słabą generalizację; SVD – macierz rzadka, $UV^T$ bliskie zeru, słaba generalizacja.
14. **WMF** = suma po obserwowanych + $w_0$·suma po nieobserwowanych (jako 0); $w_0$ to kluczowy hiperparametr.
15. **SGD**: elastyczny, inne funkcje straty, zrównoleglalny, ale wolniejszy i gorzej radzi sobie z nieobserwowanymi wpisami (negative sampling). **WALS**: zrównoleglalny, szybciej zbiega, łatwiej obsługuje nieobserwowane, ale tylko strata kwadratowa; naprzemiennie ustala U → liczy V, ustala V → liczy U. Problem nie jest łącznie wypukły.
16. MovieLens small: 100 000 ocen, 3 600 tagów, 9 000 filmów, 600 użytkowników, każdy ocenił ≥ 20 filmów, brak demografii; `rating` 0–5 co 0,5; `timestamp` w sekundach od 1970-01-01.
17. Wczytanie: `spark.read.csv(path, sep=",", header=True, inferSchema=True)`; podział: `ratings.randomSplit([0.8, 0.2], 42)` (42 = seed).
18. `ALS(maxIter=5, regParam=0.01, userCol="userId", itemCol="movieId", ratingCol="rating", seed=42, coldStartStrategy="drop")` z `pyspark.ml.recommendation`; `fit` → model (transformer), `transform` → kolumna `prediction`.
19. `coldStartStrategy="drop"` usuwa wiersze z NaN w predykcjach, żeby metryka była poprawna.
20. `RegressionEvaluator(metricName="rmse", labelCol="rating", predictionCol="prediction")` z `pyspark.ml.evaluation`, wynik ≈ 1,08; `recommendForAllUsers(3)` – 3 filmy dla każdego użytkownika; `recommendForAllItems(3)` – 3 użytkownicy dla każdego filmu.

---

<a id="wykład-4"></a>

# Wykład 4 – Spark Streaming i Apache Kafka


Handout z 2024-11-02, 23 strony po dwa slajdy. Numery stron poniżej to strony PDF. Główne źródła na slajdach: https://softwareskill.pl/apache-kafka-wprowadzenie, https://spark.apache.org/docs/latest/streaming-programming-guide.html, https://spark.apache.org/docs/3.1.2/structured-streaming-programming-guide.html#window-operations-on-event-time.

### 1. Czym jest przetwarzanie strumieni danych (s. 1)

- Dotąd przetwarzaliśmy duże zbiory danych, które **już leżą w klastrze Hadoop**. Pytanie: **jak dane trafiają na HDFS?**
- **Przetwarzanie strumieni danych** to proces publikowania danych z jakiegoś źródła, np. **logów sieciowych** albo **danych z czujników IoT**.
- Często zależy nam na przetwarzaniu takich danych **w czasie rzeczywistym**, czyli na przetwarzaniu nowych danych w miarę ich napływania, bez ręcznego ładowania ich w dużych porcjach w określonych odstępach czasu.
- Pytanie: jak publikować dane ze źródeł w klastrze w czasie rzeczywistym, aby można je było potem przetworzyć? Odpowiedź: np. przez **broker – Kafka**, czyli **system przesyłania wiadomości typu publish/subscribe**.
- Zadaniem **klastra serwerów Kafka** jest przechwytywanie i przechowywanie wszystkich wiadomości przychodzących od wydawców (np. od wiązki serwerów WWW lub czujników) i publikowanie ich każdemu, kto chce je konsumować.
- Zastosowań jest wiele, np. monitorowanie zachowań klientów z logów serwerów WWW – dzienniki można przekształcić w struktury baz danych.
- **Wyzwania przetwarzania strumieni:**
  1. jak przenieść dane ze źródeł do klastra w sposób **skalowalny i niezawodny**?
  2. jak przetworzyć te dane, aby uzyskać wartościową informację?
- Logo: Apache Kafka – *A distributed streaming platform*.

### 2. Zbieranie metryk (s. 2)

Jak to działa w praktyce:
- Załóżmy, że system składa się z wielu aplikacji front-end oraz aplikacji do zbierania metryk z tych aplikacji.
- Usługi frontend udostępniają dane klientowi, ale **same też produkują dane**, np. czasy wykonania zapytań, co klient robił na stronie, sekwencje zdarzeń, ich czasy, liczbę operacji, naruszenia zasad bezpieczeństwa itd.
- Diagram: Aplikacja 1, 2, 3 wysyłają dane do **Aplikacji i serwera Backend** oraz do **Aplikacji monitorowania metryk**, która zapisuje je na **Serwerze składowania metryk**. Każda aplikacja łączy się bezpośrednio z każdym odbiorcą – sieć połączeń szybko się komplikuje.
- **Metryki** to bardzo istotny element zbierania informacji do dalszej analizy dla działów IT i marketingu, dlatego gromadzi się je w bazach o różnej topologii i relacjach.
- Wraz z rozwojem systemu aplikacji produkujących metryki i samych metryk jest tak dużo, że **trzeba zaplanować cały system ich przepływu i przetwarzania**, a bezpośrednia komunikacja między mikrousługami jest tak skomplikowana, że trzeba zaplanować system przesyłania i transmisji komunikatów.

### 3. Model Publish-Subscribe (s. 3)

- Zamiast bezpośrednich integracji mikrousług (osobne wyzwanie) wprowadza się **pośrednika – brokera**.
- Komunikaty dotyczące monitorowania mikrousług przechodzą przez pośrednika, więc jest **jeden punkt integracji**.
- Wszyscy, którzy chcą czytać komunikaty, **subskrybują** je u pośrednika.
- **Twórca publikuje treści → zainteresowani odbiorcy (subskrybenci) odbierają je** po publikacji (lub w dogodnym dla siebie czasie).
- Analogia: serwis społecznościowy jest pośrednikiem, który zwalnia twórcę z „ręcznego” powiadamiania tysięcy zainteresowanych.

Diagram:
- **Producenci wiadomości** (Aplikacja 1, Aplikacja 2, Serwer baz danych) – publikują wiadomości do wcześniej zdefiniowanego **Topica**.
- **Broker Publish/Subscribe (np. Kafka)** w środku.
- **Topic** – szyna danych do wymiany komunikatów, która odbywa się przez **nazwany kanał komunikacji segregujący wiadomości**.
- **Konsumenci wiadomości** (Usł. odbiorcy 1 – np. serwis analizy zdarzeń UI, Usł. odbiorcy 2 – np. monitor dostępu do danych, Usł. odbiorcy 3 – np. monitor aktywności) – nasłuchują (subskrybują) konkretny Topic.
- Jeśli konsument zasubskrybuje topic, dostaje informację, gdy pojawi się na nim jakaś wiadomość.
- Skutek: **separacja – producent nie musi wiedzieć o istnieniu konsumenta ani kim on jest**.
- To tzw. **system kolejkowy komunikatów**.

### 4. Przykłady i wyzwania systemów kolejkowych (s. 4)

Przykłady:
- **Zmiany notowań w aplikacji giełdowej** – subskrypcja topicu informującego o zmianach wartości akcji, walut, obligacji, bez odpytywania serwera co kilka ms o aktualny kurs.
- **Internet of Things (IoT)** (na slajdzie: „Inernet Of Things”):
  - monitoring GPS pojazdów – urządzenie co jakiś czas wysyła na kolejkę informację o aktualnej pozycji;
  - czujniki temperatury, opadów wrzucają co jakiś czas na kolejkę stan pomiarów, a system subskrybujący (konsument) może rysować wykresy temperatury.

Wyzwania dla systemów kolejkowych:
- szybkość,
- bezpieczeństwo,
- bezawaryjność,
- zapewnienie prostego API,
- możliwie prosta konfiguracja.

### 5. Czym jest partycja? (s. 4)

- Konsument odczytuje najnowsze dane, których jeszcze nie przeczytał, więc wyzwaniem jest **dokładanie danych na końcu, bez ich aktualizowania**.
- Filozofia zapisu opiera się na **logach aplikacji (plikach logów)**, które aplikacja produkuje i odkłada w plikach. Dzięki temu można „zasubskrybować” konkretny log i patrzeć, co nowego się w nim pojawiło.
- **Zalety plików logów:**
  - zapis i odczyt na ostatniej pozycji pliku jest szybki,
  - łatwo dołożyć kolejnego konsumenta lub producenta.
- **Partycja to sekwencja danych w systemach kolejkowych.**
- Diagram: Producent 1 zapisał rekord 14, Producent 2 zapisał rekord 15 (na końcu sekwencji 1, 2, 3, 4 … 10–15). Konsument 1 odczytuje wiadomość 2, Konsument 2 odczytuje wiadomość 14 – każdy czyta z własnej pozycji.
- Pytanie: skąd konsumenci mają wiedzieć, jakie ostatnie dane odczytali, gdy nastąpi awaria? → odpowiedź: **offset** (sekcja 8).

### 6. Czym jest Topic? (s. 5)

- Producent 1 produkuje dane innego typu niż Producent 2, np.:
  - Producent 1 – dane marketingowe (jaki przycisk, na jakiej stronie został wybrany, jaką stronę otwarto, z jakiego urządzenia…),
  - Producent 2 – wiadomości do powiadamiania użytkowników o zdarzeniach w systemie (blokada środków na koncie, niedostępność systemów…).
- Dlatego wiadomości te **mogą** znajdować się w różnych plikach dla wartości „określonego typu”.
- **Topic to inaczej szyna danych, która grupuje komunikaty.**
- **Topic może być rozbity na wiele partycji.**
- **Broker to instancja systemu kolejkowego.**
- Sekwencja danych w systemach kolejkowych nazywana jest **partycją**. W przykładzie jeden topic ma jedną partycję.
- Diagram: Producent 1 → Topic 1 (0, 1, 2, 3), Producent 2 → Topic 2 (0–5). Producent 1 produkuje dane feedbacku do Topicu 1, Producent 2 – wiadomości klienta do Topicu 2. **Konsument 1 subskrybuje dane z obu topiców, Konsument 2 – tylko wiadomości klienta z Topicu 2.**

### 7. Zookeeper – zarządca wielu instancji brokera (s. 5)

- Zookeeper zarządza tym, **gdzie trafiają konkretne dane** (od strony producenta) i **z którego brokera czytać** (od strony konsumenta), aby zachować **prawidłową kolejność komunikatów, także w przypadku awarii**.
- **Konsumenta nie interesuje**, czy czyta z oryginału, czy z kopii bezpieczeństwa.
- **Konsument subskrybuje konkretną kolejkę.**
- **Brokerzy nie wiedzą**, że istnieje inny broker, który przechowuje kopię bezpieczeństwa lub część danych. Całym ruchem zarządza **Zookeeper**.
- Diagram: stawiamy kopię brokera, która zawiera kopie topiców. **Producent wysyła 50% danych do jednego brokera i 50% do drugiego.**
  - **Broker 1:** Topic 1 = rekordy 0, 2, 4, 6 oraz kopia Topic 1 = 1, 3, 5, 7.
  - **Broker 2:** Topic 1 = rekordy 1, 3, 5, 7 oraz kopia Topic 1 = 0, 2, 4, 6.
  - Broker 1 zapisuje 50% danych od producenta, drugie 50% trafia na instancję Broker 2; każdy trzyma kopię części drugiego. Konsument 2 czyta z obu.

### 8. Offset (s. 6)

- **Offset przechowuje informację o ostatnio odczytanym rekordzie.**
- Przykład: dwóch konsumentów tego samego topicu – Konsument 1.1 i Konsument 1.2 – ma ten sam kod, a ruch jest dzielony po równo między instancje. Przy bezawaryjnej pracy Konsument 1.1 czyta 50% danych, a Konsument 1.2 pozostałe 50%. **Gdy Konsument 1.1 ulegnie awarii, drugi przejmuje obsługę wszystkich wiadomości.**
- Pytanie: skąd drugi konsument ma wiedzieć, gdzie skończył pierwszy i od której wiadomości zacząć? **Odpowiedź: ta informacja jest w offsecie.**
- Diagram: jak w sekcji 7 (Producent, Zookeeper, Broker 1 i 2 z Topic 1 i kopiami), przy każdym brokerze pole **offset**; Konsument 1.1 czyta z Brokera 1, Konsument 1.2 z Brokera 2.

### 9. Czym jest Apache Kafka? (s. 6–7)

- Konsumenci zasadniczo subskrybują jeden lub więcej tematów (topiców) i dzięki serwerom Kafka dostają dane **w miarę ich publikacji**.
- **Zaleta Kafki:** **przechowuje (buforuje) dane**, więc konsumenci mogą nadrobić zaległości od miejsca, w którym ostatnio przerwali. Kafka utrzymuje punkt, w którym każdy konsument przerwał pobieranie, i pozwala odebrać dane, kiedy będzie to możliwe.
- Apache Kafka:
  - to **broker wiadomości dostępny jako otwarte oprogramowanie (open source)**;
  - jest napisany w **Scali**, rozwija go **Apache Software Foundation**;
  - umożliwia obsługę danych czasu rzeczywistego z wielu węzłów; zapewnia ujednoliconą obsługę strumieni wejściowych przy **dużej przepustowości i niskich opóźnieniach**; powstał pod silnym wpływem **dzienników transakcji**;
  - początkowo zaprojektowany w **LinkedIn**, udostępniony jako open source **na początku 2011 roku**.
- **Apache Kafka to rozproszona platforma do przesyłania milionów wiadomości.**
- W Kafce najczęściej mówi się o **logu**, choć zamiennie używa się słów **wiadomość** lub **event**.
- **Każdy nowy log (wiadomość/event) jest dopisywany na końcu pliku.**
- Pozwoliła **LinkedIn przetwarzać ok. 7 milionów komunikatów na sekundę**.

### 10. Replikacja partycji i lider (s. 7)

- **Partycje są replikowane** – ich kopie mogą leżeć na wielu serwerach.
- Dla każdej partycji jest **jeden serwer pełniący funkcję lidera** – obsługuje wszystkie operacje zapisu i odczytu tej partycji.
- Przy **poziomie replikacji 3** mamy jednego lidera i 2 brokerów, którzy tylko kopiują dane, co zwiększa bezpieczeństwo klastra.
- Diagram – **Klaster Kafka** złożony z:
  - trzech brokerów: B1, B2, B3,
  - dwóch topiców (T1 i T2),
  - dwóch partycji (po jednej na topic),
  - trzech producentów (Producent 1 – Topic T1, Producent 2 – Topic T2, Producent 3 – Topic T1),
  - trzech konsumentów (Konsument 1 – T1, Konsument 2 – T1, Konsument 3 – T2).
  - B1: Partycja T2; B2: Partycja T1 i Partycja T2; B3: Partycja T1.
- **Broker B2 jest liderem dla topicu T1, Broker B1 – dla topicu T2.** Partycja T2 na B2 to kopia partycji z B1, partycja na B3 to kopia partycji T1 z B2. **Gdy B2 ulegnie awarii, rolę lidera T1 przejmuje B3**, a na działających brokerach powstaną nowe kopie partycji T1 i T2.

### 11. Ekosystem Apache Kafka (s. 8)

- Niezbędnym elementem każdego klastra Kafka jest **Zookeeper** – minimum jeden, zazwyczaj **trzy nody**, aby zapewnić wysoką dostępność i tolerancję na awarie.
- Kafka trzyma w Zookeeperze **metadane** dotyczące: **topiców** (grup wiadomości), **brokerów** (na slajdzie: „borker”), **konsumentów**.
- **UWAGA: Zookeeper nie ma wysyłanych danych, tylko metadane klastra.**
- **Topic to grupa wiadomości.**
- Relacja producer – broker – consumer (diagram: 3 × Producer, Kafka cluster z 3 × Broker, 3 × Consumer, każdy połączony z każdym):
  - **każdy producer może pisać do każdego brokera, a każdy consumer czytać z każdego brokera;**
  - jeden producer może pisać do wielu grup wiadomości, a consumer czytać z wielu grup;
  - grupa wiadomości (topic) jest podzielona na **partycje**, a każda partycja zawiera część wysłanych wiadomości.
- **Po co są partycje? Aby zwiększyć przepustowość transmisji.** Jeśli producer wysyła dane do topicu z 3 partycjami, a każda leży na innym brokerze, dane idą do trzech serwerów, przez trzy karty sieciowe, procesory i dyski. **W teorii przepustowość rośnie trzykrotnie.**

### 12. Spark – przetwarzanie danych: stream i batch (s. 8–9, 12)

- **Spark łączy dwa podejścia: przetwarzanie strumieni i przetwarzanie batch.** To pierwsze narzędzie, które łączy je w podobny sposób.
- Oś czasu: od **stream** (ms, s) do **batch** (m, h, … tygodnie – w).
- Przetwarzanie strumieni jest w filozofii **bardzo podobne do batch**. Różnice w ogólnym zarysie dotyczą **tego, jak szybko** można pozyskać i przetworzyć dane, aby dostać wynik.
- Źródła danych: **Kafka, Flume, HDFS/S3, Kinesis, Twitter** → **Spark Streaming** → ujścia: **HDFS, Databases, Dashboards**.
- **Spark obecnie nie pozwala na przetwarzanie danych w czasie poniżej milisekund.** Istnieje eksperymentalne ciągłe przetwarzanie, ale na razie nie jest zalecane.
- Klasyczny DataFrame i jego transformacje:

```python
(
  df.select("X", "Y")
    .where("Y is not null")
    .groupBy("X").count()
)
```

Co robi: `select` wybiera podzbiór kolumn, `where` służy do selekcji i filtrowania, `groupBy(...).count()` grupuje i zlicza.

- Klasyczne przetwarzanie batch daje bardzo podobny interfejs jak przetwarzanie strumieni. Te same (lub bardzo podobne) komendy biblioteki SQL działają na strumieniach i na danych statycznych.
- **Wniosek:** znając batch, można bardzo szybko zbudować logikę przetwarzania strumieni; wystarczy zamienić początek i koniec definicji aplikacji (odczyt i zapis), a reszta zadziała na strumieniach.

### 13. Structured Streaming – model programowania i tryby wyjścia (s. 9)

(na slajdzie: nagłówek „Streaming → Spark 3.1.2”)

- Zapytanie o dane wejściowe generuje **„Tabelę Wyników”** (Result Table). Z każdym interwałem wyzwalacza (trigger, np. co 1 sekundę) nowe wiersze są dołączane do **„Tabeli Wejściowej”** (Input Table), co aktualizuje Tabelę Wyników. Za każdym razem, gdy Tabela Wyników się zmieni, chcemy zapisać zmienione wiersze do zewnętrznego wyjścia **serią małych zadań wsadowych**.
- Diagram *Programming Model for Structured Streaming*: Trigger every 1 sec; czas 1, 2, 3; Input: data up to t=1, t=2, t=3 (rosnąca tabela); Query; Result: result up to t=1/2/3; Output (complete mode).

Tryby wyjścia:

| Tryb | `outputMode` | Co zapisuje |
|---|---|---|
| **Tryb kompletny** | `complete` | Cała zaktualizowana Tabela Wyników trafia do pamięci zewnętrznej. Od systemu zapisu zależy, jak obsłuży zapis całej tabeli. |
| **Tryb dołączania** | `append` | Tylko nowe wiersze dołączone do Tabeli Wyników od ostatniego wyzwalacza. Tylko dla zapytań, w których istniejące wiersze Tabeli Wyników się nie zmieniają. |
| **Tryb aktualizacji** | `update` | Tylko wiersze zaktualizowane od ostatniego wyzwalacza (dostępne od Spark 2.1.1). Różni się od trybu kompletnego tym, że wypisuje tylko zmienione wiersze. **Gdy zapytanie nie ma agregacji, działa jak tryb dołączania.** |

### 14. Inicjalizacja: SparkSession i strumień z gniazda – word count (s. 10)

(na slajdzie: nagłówek „Inicjalizacja → StreamingContext (do Spark 3.1.2)”, ale kod tworzy `SparkSession` i używa `readStream`, czyli Structured Streaming.)

Najpierw importujemy klasy i tworzymy lokalną **SparkSession** – punkt wejścia do wszystkich funkcjonalności.

Scala:

```scala
import org.apache.spark.sql.functions._
import org.apache.spark.sql.SparkSession
val spark = SparkSession
  .builder
  .appName("StructuredNetworkWordCount")
  .getOrCreate()
import spark.implicits._
```

Python:

```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import explode
from pyspark.sql.functions import split
spark = SparkSession \
    .builder \
    .appName("StructuredNetworkWordCount") \
    .getOrCreate()
```

Następnie tworzymy strumieniowy DataFrame z danymi tekstowymi z serwera nasłuchującego na `localhost:9999` i przekształcamy go, aby policzyć słowa.

Scala:

```scala
// Create DataFrame representing the stream of input lines from connection to localhost:9999
val lines = spark.readStream
  .format("socket")
  .option("host", "localhost")
  .option("port", 9999)
  .load()
// Split the lines into words
val words = lines.as[String]
  .flatMap(_.split(" "))
// Generate running word count
val wordCounts = words
  .groupBy("value")
  .count()
```

Python (dokładnie jak na slajdzie):

```python
# Create DataFrame representing the stream of input lines from connection to localhost:9999
lines = spark \
    .readStream \ .
("socket") \
    .option("host", "localhost") \
    .option("port", 9999) \
    .load()
# Split the lines into words
words = lines.select( explode( split(lines.value, " ") ).alias("word") )
# Generate running word count
wordCounts = words.groupBy("word").count()
```

(na slajdzie: w Pythonie brakuje `.format` – poprawnie `.readStream \` i w kolejnej linii `.format("socket") \`.)

Co robi: `readStream.format("socket")` czyta linie tekstu z gniazda TCP; `split` dzieli linię po spacjach, `explode` zamienia tablicę słów na osobne wiersze (kolumna `word`); `groupBy("word").count()` liczy bieżące wystąpienia słów.

### 15. Spark Streaming – jak działa? (s. 10–11)

(na slajdzie: „Spark Streaming (od Spark 3.2) – jak działa?”)

- Spark Streaming odbiera strumienie danych wejściowych w czasie rzeczywistym i **dzieli je na partie (batche)**, które aparat Spark przetwarza, generując końcowy strumień wyników, także w partiach.
- Diagram: input data stream → **Spark Streaming** → batches of input data → **Spark Engine** → batches of processed data.
- Spark Streaming daje abstrakcję wysokiego poziomu **discretized stream (DStream)**, reprezentującą ciągły strumień danych. DStreamy można tworzyć ze strumieni wejściowych ze źródeł takich jak **Kafka i Kinesis** albo operacjami wysokiego poziomu na innych DStreamach. **Wewnętrznie DStream to sekwencja RDD.**

> Wyjaśnienie: w dokumentacji Spark to DStreams są starszym API, a Structured Streaming nowszym. Oznaczenia wersji „do 3.1.2” i „od 3.2” na slajdach pochodzą prawdopodobnie z wersji dokumentacji, z których wzięto przykłady.

### 16. Dyskretne strumienie (DStreams) (s. 11)

- **DStream to podstawowa abstrakcja Spark Streaming.** Reprezentuje:
  - ciągły strumień danych wejściowych odebrany ze źródła,
  - przetworzony strumień danych powstały z transformacji strumienia wejściowego.
- Wewnętrznie DStream to **ciągła seria RDD**, czyli abstrakcji Sparka dla niezmiennego, rozproszonego zbioru danych.
- Diagram: DStream → RDD @ time 1 (data from time 0 to 1), RDD @ time 2 (1 to 2), RDD @ time 3 (2 to 3), RDD @ time 4 (3 to 4).
- **Każde RDD w DStreamie zawiera dane z określonego interwału.**
- **Każda operacja na DStreamie przekłada się na operacje na podległych RDD.** Np. zamiana strumienia wierszy na słowa przez **flatMap**: lines DStream (lines from time 0 to 1, …) → operacja flatMap → words DStream (words from time 0 to 1, …).
- Operacje DStream ukrywają większość tych szczegółów i dają programiście wygodny interfejs wyższego poziomu.

### 17. Inicjalizacja StreamingContext (DStreams) (s. 12)

- Obiekt **StreamingContext** można utworzyć z obiektu **SparkConf**.
- **StreamingContext jest głównym punktem wejścia wszystkich funkcji Spark Streaming.**

Scala:

```scala
import org.apache.spark._
import org.apache.spark.streaming._

val conf = new SparkConf().setAppName(appName).setMaster(master)
val ssc = new StreamingContext(conf, Seconds(1))
```

Python:

```python
from pyspark import SparkContext
from pyspark.streaming import StreamingContext
sc = SparkContext(master, appName)
ssc = StreamingContext(sc, 1)
```

Co robi: tworzy kontekst strumieniowy z interwałem batcha **1 sekunda** (`Seconds(1)` w Scali, `1` w Pythonie).

**Uwaga:**
- Po uruchomieniu kontekstu **nie można go konfigurować ani dodawać nowych obliczeń strumieniowych**.
- Po zatrzymaniu kontekstu **nie można go ponownie uruchomić**.
- **Tylko jeden StreamingContext może być aktywny w JVM w danym czasie.**
- `stop()` na StreamingContext **zatrzymuje też SparkContext**. Aby zatrzymać tylko StreamingContext, ustaw opcjonalny parametr `stop()` (dla SparkContext) na `false`.

> Wyjaśnienie: w Pythonie to `ssc.stop(stopSparkContext=False)`.

### 18. Spark SQL vs Structured Streaming (s. 13)

- **Spark** to zunifikowany silnik analityczny do obliczeń rozproszonych.
- **Spark Structured Streaming opiera się na silniku Spark SQL.**

| Aspekt | Spark SQL | Structured Streaming |
|---|---|---|
| Abstrakcja danych | DataFrame/Dataset | DataFrame/Dataset **strumieniowy** |
| Tryb | batch | **micro-batch** |
| Odczyt ze źródła (po utworzeniu sesji) | `spark.read.format` | `spark.readStream.format` |
| Zapis danych | `df.write.format` | `df.writeStream.format` |
| Transformacje | `select/where/groupBy` | `select/where/groupBy` |

- Z punktu widzenia API Spark wprowadza abstrakcję **zbioru, czyli tabeli, do której dane napływają**. Na takiej wirtualnej tabeli pracuje się jak w batchu: nazwane kolumny, odwołania do nich, filtrowanie, agregacje.
- Structured Streaming opiera się na **micro-batch** (na slajdzie: „mico-batch”): zbiera dane w interwałach czasowych, np. kilku sekund, i dopiero potem zwraca wynik. **Opóźnienie jest więc wyższe niż milisekundy.**

### 19. Źródła wejściowe (s. 13)

| Źródło | Opis |
|---|---|
| **Źródło pliku** | Czyta pliki zapisane w katalogu jako strumień danych. Pliki są przetwarzane w kolejności czasu modyfikacji; gdy ustawione jest `latestFirst`, kolejność się odwraca. Formaty: tekst, CSV, JSON, ORC, Parquet (na slajdzie: „Parkiet”). **Pliki muszą być umieszczane w katalogu niepodzielnie (atomowo)**, co w większości systemów plików osiąga się operacją przenoszenia. |
| **Źródło Kafki** | Czyta dane z Kafki. Kompatybilne z brokerem Kafka **w wersji 0.10.0 lub wyższej**. |
| **Źródło gniazda (socket)** – do testowania | Czyta tekst UTF-8 z połączenia gniazda; gniazdo serwera nasłuchującego jest w sterowniku (driver). **Tylko do testów**, bo nie daje pełnej gwarancji odporności na awarie. |
| **Źródło Rate** – do testowania | Generuje dane z określoną liczbą wierszy na sekundę; każdy wiersz zawiera `timestamp` i `value`. |

### 20. Typy przetwarzania strumieniowego i aspekt czasu (s. 14)

**Stateless vs Stateful:**

| Typ | Opis |
|---|---|
| **stateless** | Każda krotka przetwarzana osobno – nie trzeba utrzymywać stanu (między operacjami mikrobatch) i **nie ma agregacji danych**. |
| **stateful** | Możliwa **agregacja danych w określonych interwałach czasowych**, np. agregacja interakcji użytkownika na stronie. Stany są odkładane w postaci **CheckPoint**, także na wypadek awarii. Grupowanie może być np. po czasie lub po kolumnie. |

**Aspekt czasu przetwarzania:**

| Czas | Opis |
|---|---|
| **Event time** (czas zdarzenia) | Czas, w którym zdarzenie się odbyło, czyli kiedy pojawił się event. |
| **Processing time** (czas procesowania) | Zdarzenie trafia do przetworzenia w innym czasie, niż się pojawiło (np. z powodu opóźnień w sieci). |

### 21. Obsługa czasu zdarzenia i późnych danych (s. 14–16)

**Sytuacja idealna (nie występuje w rzeczywistości) – s. 15:**
- Wykres: oś pozioma – czas procesowania, oś pionowa – czas zdarzenia (0:00–1:50 s). Wszystkie zdarzenia leżą na przekątnej: **czas zdarzenia = czas procesowania**. Nad przekątną („tu zdarzenie nie może się pojawić”) nic nie ma.
- **Czas zdarzenia to czas osadzony w samych danych.**
- **Event-time** jest bardzo naturalnie wyrażony w modelu: każde zdarzenie z urządzeń to wiersz w tabeli, a event-time to wartość kolumny w tym wierszu.
- Dzięki temu agregacje okienkowe (np. liczba zdarzeń na minutę) to po prostu specjalny rodzaj grupowania i agregacji po kolumnie czasu zdarzenia: **każde okno czasowe jest grupą, a każdy wiersz może należeć do wielu okien/grup.**
- Model naturalnie obsługuje dane, które przyszły później, niż oczekiwano według czasu zdarzenia. Ponieważ Spark aktualizuje Tabelę Wyników, ma pełną kontrolę nad **aktualizacją starych agregatów** przy opóźnionych danych i nad **czyszczeniem starych agregatów**, aby ograniczyć rozmiar stanu pośredniego.

**Sytuacja rzeczywista – s. 15:**
- **Czas zdarzenia ≠ czas procesowania.** Istotny jest czas pojawienia się zdarzenia do przetworzenia i kolejność pojawiania się zdarzeń.
- Zdarzenia pojawiają się z różnym opóźnieniem:
  1. Zdarzenie 1 – pojawiło się niemal idealnie (blisko przekątnej).
  2. Zdarzenie 2 – pojawiło się z małym opóźnieniem.
  3. Zdarzenie 3 – pojawiło się z tak dużym opóźnieniem, że jego czas procesowania jest późniejszy niż czas zdarzeń następnych.
- **UWAGA:** gdybyśmy przetwarzali zgodnie z czasem procesowania, a nie z czasem zdarzeń, kolejność sekwencji byłaby zupełnie inna.

**s. 16:**
- Często zależy nam na przetwarzaniu **zgodnie z kolejnością zdarzeń**, a nie czasem procesowania – wtedy zdarzenia są ułożone w kolejności, w jakiej faktycznie się wydarzyły. (Spark pozwala też przetwarzać według czasu procesowania.)
- Pytanie: jak posuwa się czas procesowania (przy przetwarzaniu wg kolejności zdarzeń)? Odpowiedź: **czas posuwa się razem ze zdarzeniem o najwyższym `timestamp`**, czyli z najświeższym zdarzeniem; zdarzenia spóźnione **nie cofają czasu**. (Na wykresie fioletowa „schodkowa” linia rośnie tylko przy nowych maksymach.)
- Pytanie: co zrobić ze zdarzeniami, które się spóźniły? → **watermark**.

### 22. Watermark (s. 16)

- **Spark jako metodę radzenia sobie z opóźnionymi zdarzeniami oferuje watermark.**
- Watermark to metoda określająca, **jak bardzo może być opóźnione zdarzenie, aby nadal traktować je jako poprawne** – czyli ile czasu może się spóźnić, aby zostało włączone do przetwarzania (np. agregacji).
- Watermark musi uwzględniać też, **ile pamięci będzie potrzebne** przy agregacji opóźnionych zdarzeń (stan musi być utrzymywany przy agregowaniu, np. w oknie 10-sekundowym).
- Diagram: trzy zdarzenia nieco spóźnione **wejdą** do okna czasowego przetwarzania; dwa zdarzenia (zaznaczone na niebiesko, mocno spóźnione) **nie wejdą** do okna.

> Wyjaśnienie (składnia spoza slajdów): w Structured Streaming watermark ustawia się metodą `df.withWatermark("event_time", "10 seconds")` przed agregacją okienkową.

### 23. Operacje na oknach w czasie zdarzenia (s. 17–18)

Link: https://spark.apache.org/docs/latest/streaming-programming-guide.html

Trzy rodzaje okien: **okno przesuwne (sliding window)**, **okno spadające (tumbling window)**, **okna sesyjne (session window)**.

Dwa parametry:
1. **Window duration (czas trwania okna)** – jak długie ma być okno; np. okno 30 s.
2. **Slide duration (czas przesunięcia)** – o ile okno się przesuwa.

**A. Okno przesuwne (sliding window) – Window duration > Slide duration**
- Przykład: okno trwa **30 s**, przesuwa się o **20 s**; każdy mikrobatch zawiera dane z ok. **10 s**.
- Każde okno przesuwne to agregacja **3 mikrobatchy (30 s)**.
- Okna W1–W5 **zazębiają się** (czas zazębiania kolejnych okien).
- Zastosowanie: np. monitorowanie aktywności użytkowników w danych interwałach czasowych.

**B. Okno spadające (tumbling window) – Window duration = Slide duration**
- Przykład: okno trwa **30 s** i przesuwa się o **30 s**; mikrobatch ok. 10 s; każde okno to agregacja 3 mikrobatchy (na slajdzie: „mikrobat-chy”).
- **Okna się nie zazębiają** (W1: 0:00–0:30, W2: 0:30–1:00, W3: 1:00–1:30, W4: 1:30–2:00).
- Zastosowanie: np. monitorowanie aktualizacji punktualnie co N sekund.

**C. Okna sesyjne (session window)**
- **Okno trwa przez sesję użytkownika.**
- Parametr określa, **jak długo czekamy między zdarzeniami, aby uznać, że sesja wygasła**.
- Okna mają różną długość i mogą być rozdzielone przerwami (W1, W2 – krótkie, W3 – długie, W4).
- Zastosowanie: np. wyświetlenie dodatkowej oferty lub podpowiedzi po pewnym czasie.

| Okno | Relacja parametrów | Zazębianie | Przykład użycia |
|---|---|---|---|
| sliding | window > slide | tak | aktywność użytkowników w interwałach |
| tumbling | window = slide | nie | aktualizacje co N sekund |
| session | zależne od sesji (przerwa między zdarzeniami) | nie, długość zmienna | dodatkowa oferta/podpowiedź |

### 24. Agregacja okienkowa – przykład z liczeniem słów (s. 19)

- Agregacje w przesuwanym oknie czasu zdarzenia są w Structured Streaming proste i bardzo podobne do zwykłych agregacji grupowanych.
- W agregacji grupowanej wartości zagregowane (np. liczności) są utrzymywane dla każdej unikatowej wartości kolumny grupowania. W agregacji okienkowej – **dla każdego okna, do którego trafia czas zdarzenia wiersza**.
- Zadanie: liczyć słowa w **10-minutowych oknach, aktualizując je co 5 minut**. Okna: 12:00–12:10, 12:05–12:15, 12:10–12:20 itd.
- 12:00–12:10 oznacza dane, które przyszły po 12:00, ale przed 12:10. Słowo otrzymane o **12:07** powinno zwiększyć liczniki **dwóch okien**: 12:00–12:10 i 12:05–12:15. Liczniki są indeksowane **kluczem grupującym (słowem) i oknem** (obliczanym z czasu zdarzenia).

Diagram *Windowed Grouped Aggregation with 10 min windows, sliding every 5 mins* – Input Stream: 12:02 „cat dog”, 12:03 „dog dog”, 12:07 „owl cat”, 12:11 „dog”, 12:13 „owl”. Tabele wyników po wyzwalaczach co 5 minut:

| Okno | Słowo | po 12:05 | po 12:10 | po 12:15 |
|---|---|---|---|---|
| 12:00–12:10 | cat | 1 | 2 | 2 |
| 12:00–12:10 | dog | 3 | 3 | 3 |
| 12:00–12:10 | owl | – | 1 | 1 |
| 12:05–12:15 | cat | – | 1 | 1 |
| 12:05–12:15 | owl | – | 1 | 2 |
| 12:05–12:15 | dog | – | – | 1 |
| 12:10–12:20 | dog | – | – | 1 |
| 12:10–12:20 | owl | – | – | 1 |

Po 12:10 zwiększono liczniki okien 12:00–12:10 i 12:05–12:15, po 12:15 – okien 12:05–12:15 i 12:10–12:20.

> Wyjaśnienie (składnia spoza slajdów): `words.groupBy(window(words.timestamp, "10 minutes", "5 minutes"), words.word).count()`, gdzie `window` pochodzi z `pyspark.sql.functions`; okno spadające to `window(col, "10 minutes")` bez trzeciego argumentu; okno sesyjne – `session_window(col, "5 minutes")` (Spark 3.2+).

### 25. Wysyłanie wiadomości do brokera Kafka – zadania (s. 20)

Zadanie: korzystając z PySpark, opracować:
1. skrypt Python, który **co sekundę** prześle do brokera Kafka na topic **`topicBD`** informacje o ocenach pięciu studentów – oceny całkowite z zakresu **2–5**;
2. skrypt, który odbierze z brokera Kafka z topicu `topicBD` informacje o zdarzeniach danych użytkowników;
3. skrypt, który odbierze z `topicBD` i zaprezentuje działanie **sliding window**;
4. skrypt, który odbierze z `topicBD` i zaprezentuje działanie **tumbling window**;
5. skrypt, który odbierze z `topicBD` i zaprezentuje działanie **watermark**;
6. skrypt, który odbierze z `topicBD`, wyliczy **średnią ocenę** każdego studenta i zapisze tę średnią na topic **`topicSR`** w brokerze Kafka.

Diagram: producenci wiadomości Jan1, Ania2, Adam3 → Broker Publish/Subscribe (np. Kafka) → konsumenci (Usł. odbiorcy 1–3). Opisy Producenta, Topicu i Konsumenta jak w sekcji 3.

### 26. Kod producenta – wysyłanie wiadomości do Kafki (s. 21)

Przykłady oparte na prezentacji grupy Meetup **Big Data Community**, spotkanie „Spark Structured Streaming”, prezentujący: **Patryk Pilarski**.

W PyCharm strumień jest generowany przez Kafkę, do której wiadomości wysyła kod w Pythonie:

```python
import json
import random
import sys
from datetime import datetime, timedelta
from time import sleep

from kafka import KafkaProducer

if __name__ == "__main__":
    server = sys.argv[1] if len(sys.argv) == 2 else "localhost:9092"

    producer = KafkaProducer(
        bootstrap_servers=[server],
        value_serializer=lambda x: json.dumps(x).encode("utf-8"),
        api_version=(2, 7, 0),
    )

    try:
        while True:
            message = {
                "time": str(
                    datetime.now() + timedelta(seconds=random.randint(-15, 0))
                ),
                "id": random.choice(["Jan1", "Ania2", "Adam3", "Alan4", "Zofia5"]),
                "value": random.randint(2, 5),
            }
            producer.send("topicBD", value=message)
            sleep(1)
    except KeyboardInterrupt:
        producer.close()
```

Co robi:
- **Importy:** `import sys` pozwala uruchomić aplikację z argumentami z linii poleceń (adres klastra Kafka); bez argumentu używany jest `localhost:9092`.
- **`KafkaProducer`** (biblioteka `kafka`) – producent generuje **JSON kodowany UTF-8** w nieskończonej pętli `while`.
- **`json.dumps(x)`** konwertuje obiekt Pythona `x` na łańcuch znaków (na slajdzie: „Sting”); istnieje też **`json.dump()`**, która zapisuje obiekt Pythona jako JSON (do pliku).
- Wiadomość składa się z:
  - `"time"` – znacznik czasu potrzebny do zasymulowania czasu zdarzenia z losowym opóźnieniem **1–15 sekund** (`randint(-15, 0)`);
  - `"id"` – losowy identyfikator symulujący rekord (Jan1, Ania2, Adam3, Alan4, Zofia5);
  - `"value"` – losowa ocena 2–5.
- **`producer.send("topicBD", value=message)`** wysyła wiadomość na zdefiniowany topic.
- **`sleep(1)`** – wysyłka co jedną sekundę. `Ctrl+C` (`KeyboardInterrupt`) zamyka producenta (`producer.close()`).

### 27. Łączenie Apache Spark z brokerem Kafka – konsument (s. 22)

(na slajdzie: nagłówek „Kod w języku python – do przesyłania wiadomości przez broker Kafka”, choć to kod odbierający dane w Sparku.)

```python
# spark-submit --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.1.1 1_app.py host:9092
import sys

from pyspark.sql import SparkSession


if __name__ == "__main__":
    server = sys.argv[1] if len(sys.argv) == 2 else "localhost:9092"

    spark = SparkSession.builder.appName("streamKafka").getOrCreate()
    spark.sparkContext.setLogLevel("ERROR")

    # topic subscription
    raw = (
        spark.readStream.format("kafka")
        .option("kafka.bootstrap.servers", server)
        .option("subscribe", "topicBD")
        .load()
    )

    # defining output
    query = raw.writeStream.outputMode("append").format("console").start()
    query.awaitTermination(60)
    query.stop()
```

Co robi:
- Komentarz – przykład komendy uruchomienia aplikacji: `spark-submit` z pakietem **`spark-sql-kafka-0-10_2.12:3.1.1`** i adresem brokera jako argumentem.
- `from pyspark.sql import SparkSession` – import sesji Spark.
- `SparkSession.builder.appName("streamKafka").getOrCreate()` – przygotowanie sesji Spark (jak w batchach).
- `setLogLevel("ERROR")` – ogranicza komunikaty tylko do błędów.
- **Subskrypcja Kafki:** z sesji Spark wywołujemy `readStream` i ustawiamy format na **`"kafka"`**. Kafka wymaga kilku opcji:
  - **`kafka.bootstrap.servers`** – namiary na jeden węzeł (node) klastra Kafka lub zestaw węzłów;
  - **`subscribe`** – który topic subskrybujemy (może to być lista topiców); można też użyć **regexp**.
- **`load()`** pobiera napływające z Kafki wiadomości i tworzy strumieniowy DataFrame `raw`.
- **`writeStream.outputMode("append").format("console").start()`** – wynik wypisujemy na konsolę (można też do bazy lub innego topicu w Kafce).
- **`outputMode` ma trzy typy:**
  - **Append** – zwraca tylko nowe wiersze (np. bez agregacji),
  - **Update** – zwraca agregaty zmienione od ostatniego outputu,
  - **Complete** – zwraca cały stan strumienia w danym momencie.
- **`awaitTermination(60)`** – po **60 sekundach** pobieranie strumienia jest przerywane; `query.stop()` zatrzymuje zapytanie.

> Wyjaśnienie: DataFrame z Kafki ma kolumny m.in. `key`, `value` (binarnie), `topic`, `partition`, `offset`, `timestamp`; aby dostać pola JSON, trzeba zdekodować `value`, np. `from_json(col("value").cast("string"), schema)`. Na slajdach tego kroku nie pokazano.

### 28. Przykładowy wynik – wiadomości z Kafki (s. 23)

Wartości zdekodowane; kolumny: czas procesowania, czas zdarzenia, id, value.

```text
Batch: 1
+-----------------------+--------------------------+-----+-----+
|proc_time              |event_time                |id   |value|
+-----------------------+--------------------------+-----+-----+
|2021-11-16 12:56:44.731|2021-11-16 12:56:32.731964|Ania2|4    |
|2021-11-16 12:56:45.74 |2021-11-16 12:56:43.74092 |Ania2|2    |
|2021-11-16 12:56:46.746|2021-11-16 12:56:39.746937|Adam3|5    |
|2021-11-16 12:56:47.756|2021-11-16 12:56:43.756922|Ania2|3    |
|2021-11-16 12:56:48.763|2021-11-16 12:56:47.763501|Adam3|2    |
+-----------------------+--------------------------+-----+-----+

Batch: 2
+-----------------------+--------------------------+-----+-----+
|proc_time              |event_time                |id   |value|
+-----------------------+--------------------------+-----+-----+
|2021-11-16 12:56:49.778|2021-11-16 12:56:46.778043|Ania2|2    |
|2021-11-16 12:56:50.783|2021-11-16 12:56:36.783442|Adam3|5    |
+-----------------------+--------------------------+-----+-----+
```

Widać, że `event_time` jest wcześniejszy od `proc_time` o losowe opóźnienie (do 15 s), a kolejność czasów zdarzeń nie pokrywa się z kolejnością przetwarzania (np. w Batch 2 zdarzenie z 12:56:36 przychodzi po zdarzeniu z 12:56:46).

(Kod z s. 22 wypisuje surowy DataFrame z Kafki; kolumny `proc_time` i `event_time` wymagają dodatkowego dekodowania JSON, którego slajdy nie pokazują.)

#### Najważniejsze do zapamiętania

1. Przetwarzanie strumieni = publikowanie danych ze źródeł (logi sieciowe, czujniki IoT) i ich przetwarzanie w czasie rzeczywistym, bez ręcznego ładowania porcji. Dwa wyzwania: skalowalny i niezawodny transport do klastra oraz wydobycie wartościowej informacji.
2. **Publish-subscribe**: producent publikuje do **topicu** przez **brokera**, konsument subskrybuje topic; producent nie musi wiedzieć o konsumencie (separacja). To system kolejkowy komunikatów.
3. Wyzwania systemów kolejkowych: szybkość, bezpieczeństwo, bezawaryjność, proste API, prosta konfiguracja.
4. **Topic** = szyna danych grupująca komunikaty (grupa wiadomości); może mieć wiele **partycji**. **Partycja** = sekwencja danych (log dopisywany na końcu). **Broker** = instancja systemu kolejkowego.
5. **Offset** przechowuje informację o ostatnio odczytanym rekordzie – dzięki niemu po awarii konsument wie, skąd czytać.
6. **Zookeeper** zarządza brokerami i kolejnością komunikatów; trzyma **tylko metadane** (topiki, brokery, konsumenci), nie dane; minimum 1, zwykle **3 nody**.
7. Replikacja: każda partycja ma jednego **lidera** (wszystkie zapisy i odczyty); przy replikacji 3 – lider + 2 kopie; po awarii lidera rolę przejmuje broker z kopią.
8. Partycje służą **zwiększeniu przepustowości** – 3 partycje na 3 brokerach to teoretycznie 3× większa przepustowość.
9. Kafka: open source, napisana w **Scali**, rozwijana przez **Apache Software Foundation**, powstała w **LinkedIn**, open source od początku **2011**; LinkedIn ok. **7 mln komunikatów/s**; buforuje dane, więc konsumenci nadrabiają zaległości.
10. Spark łączy przetwarzanie **stream i batch** podobnym API; nie schodzi poniżej milisekund (continuous processing jest eksperymentalne). Źródła: Kafka, Flume, HDFS/S3, Kinesis, Twitter; ujścia: HDFS, bazy danych, dashboardy.
11. **DStream** = sekwencja **RDD**, każde RDD to dane z jednego interwału; `StreamingContext(sc, 1)` – batch co 1 s; tylko jeden aktywny StreamingContext w JVM; po zatrzymaniu nie da się go wznowić; `stop()` zatrzymuje też SparkContext.
12. Structured Streaming opiera się na **Spark SQL** i **micro-batch**: `spark.read.format` → `spark.readStream.format`, `df.write.format` → `df.writeStream.format`.
13. Tryby wyjścia: **append** (tylko nowe wiersze, bez zmian istniejących), **update** (tylko zmienione wiersze; bez agregacji = append), **complete** (cała tabela wyników).
14. Źródła: plik (txt, CSV, JSON, ORC, Parquet; `latestFirst`; pliki atomowo), **Kafka ≥ 0.10.0**, **socket** i **rate** – tylko do testów.
15. **Stateless** – każda krotka osobno, bez agregacji; **stateful** – agregacje w oknach, stan w **checkpointach**.
16. **Event time** – czas zdarzenia zapisany w danych; **processing time** – czas przetworzenia (opóźnienia sieci). Czas posuwa się wraz z najwyższym timestampem; spóźnione zdarzenia go nie cofają.
17. **Watermark** określa, jak bardzo zdarzenie może się spóźnić, aby jeszcze trafić do agregacji; ogranicza też pamięć potrzebną na stan.
18. Okna: **sliding** (window > slide, okna się zazębiają, np. 30 s / 20 s), **tumbling** (window = slide, bez zazębiania, np. 30 s / 30 s), **session** (trwa przez sesję, zamyka się po przerwie bez zdarzeń). Wiersz może należeć do wielu okien.
19. Producent: `KafkaProducer(bootstrap_servers=[server], value_serializer=lambda x: json.dumps(x).encode("utf-8"), api_version=(2, 7, 0))`, `producer.send("topicBD", value=message)`, domyślny serwer `localhost:9092`.
20. Konsument w Sparku: `spark.readStream.format("kafka").option("kafka.bootstrap.servers", server).option("subscribe", "topicBD").load()`, potem `writeStream.outputMode("append").format("console").start()` i `awaitTermination(60)`; uruchomienie przez `spark-submit --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.1.1`.

