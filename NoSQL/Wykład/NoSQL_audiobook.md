# Bazy New/NoSQL — audiobook

To jest mówiona wersja całego wykładu „Bazy New/NoSQL”, ułożona w kolejności slajdów, w ośmiu działach. Pierwszy dział mówi o Big Data i o rodzajach baz NoSQL. Działy od drugiego do piątego omawiają MongoDB: instalację i modelowanie danych, operacje CRUD i operatory zapytań, walidację schematu, agregacje i indeksy, a na końcu replikację, sharding i kolekcje szeregów czasowych. Szósty dział jest o Redisie, siódmy o bazach grafowych, czyli Neo4j i grafach w SQL Server, a ósmy o Apache Cassandrze i języku CQL. Każdy podrozdział kończy się krótkim powtórzeniem tego, co warto zapamiętać na test.



# 1. Big Data i bazy NoSQL — wprowadzenie

Witaj w pierwszym rozdziale. Zanim dotkniemy MongoDB i konkretnej składni, musimy zrozumieć, skąd w ogóle wzięły się bazy NoSQL i jaki problem rozwiązują. W tym dziale przejdziemy przez pojęcie Big Data i jego cztery cechy, nazywane czterema V. Przypomnimy sobie, czym są bazy relacyjne i co potrafią. Zobaczymy, jak zmieniły się dane w ostatnich latach i dlaczego to otworzyło drogę dla NoSQL. Omówimy chmurę, czyli modele SaaS, PaaS i IaaS, oraz trzy sposoby przetwarzania danych: OLTP, OLAP i RTAP. Poznamy historię samego terminu NoSQL, z datą jedenastego czerwca dwa tysiące dziewiątego roku i nazwiskami, które warto znać. Potem przejdziemy przez główne rodziny baz nierelacyjnych: klucz–wartość z Redisem, dokumentowe z MongoDB, kolumnowe z Cassandrą, grafowe z Neo4j, a także bazy XML i bazy RDF. Spojrzymy na ranking DB-Engines. Na koniec zostawiamy trzy rzeczy, które bardzo często pojawiają się na testach: model BASE w zestawieniu z ACID, twierdzenie CAP z trójkątem CAP oraz model Map-Reduce. Rozdział zamyka odpowiedź na pytanie, czy to koniec baz relacyjnych.

Słuchaj uważnie nazw, dat i przyporządkowań typu „która baza jest którego rodzaju” oraz „która baza jest CP, a która AP”, bo właśnie z takich rzeczy układa się pytania ABCD.

## Właściwości Big Data, czyli cztery V

Zacznijmy od pojęcia Big Data. Na wykładzie Big Data opisuje się przez cztery cechy, które po angielsku zaczynają się na literę V. Wzór ze slajdu brzmi: Big Data równa się Volume plus Variety plus Velocity plus Veracity. Przejdźmy przez nie po kolei.

Pierwsze V to Volume, czyli objętość. Kluczowe zdanie ze slajdu: ilość danych wzrasta potęgowo, a nie liniowo. To ważne rozróżnienie. Wzrost liniowy oznacza, że co rok przybywa mniej więcej tyle samo danych. Wzrost potęgowy, nazywany też wykładniczym, oznacza, że przyrost sam rośnie, więc krzywa coraz gwałtowniej idzie w górę. Druga, mniej oczywista myśl: duża ilość małych zbiorów danych też może być klasyfikowana jako Big Data. Nie trzeba więc mieć jednego gigantycznego pliku. Miliony małych rekordów z czujników, logów czy kliknięć razem tworzą Big Data. To dobra pułapka testowa: Big Data to nie tylko „jeden wielki zbiór”.

Drugie V to Variety, czyli różnorodność. Dane mają różną strukturę i różny format. Slajd wymienia XML i JSON oraz nieustrukturalizowane multimedia, a na grafice widać ikony: XML, JSON, obrazy, wideo, tekst i audio. Relacyjna tabela zakłada, że każdy wiersz ma te same kolumny. Świat Big Data tego nie gwarantuje.

Trzecie V to Velocity, czyli szybkość przetwarzania. Dane napływają bardzo szybko i z taką samą szybkością muszą być przetwarzane, na przykład strumieniowo. Grafika pokazuje przepływ: strumień danych, potem szybkie przetwarzanie, a na końcu reakcja w czasie rzeczywistym. Zapamiętaj, że Velocity dotyczy zarówno tempa napływu, jak i tempa obróbki. Nie wystarczy dane szybko zapisać, trzeba też szybko na nie zareagować.

Czwarte V to Veracity. Na slajdzie przetłumaczono je jako niepewność. Dosłownie veracity znaczy prawdziwość albo wiarygodność, a chodzi o to, na ile możemy ufać danym. Niepewność powstaje ze względu na braki, niespójność albo wprowadzenie aproksymacji, czyli przybliżeń. Wniosek ze slajdu: trzeba znaleźć podejścia, które sobie z tym radzą. Grafika pokazuje cztery ikony: braki danych, niespójność, niepewność i metody radzenia sobie.

Uważaj na test. W literaturze spotkasz też trzy V, czyli Volume, Variety, Velocity, a czasem pięć V z dodatkowym Value, czyli wartością. Ten wykład mówi o czterech V, a czwartym jest Veracity. Jeżeli pytanie zapyta, której cechy nie ma wśród czterech V z wykładu, to dobrym kandydatem będzie na przykład Value, Validity albo Visualization.

Hasło pod wzorem brzmi: większe możliwości, lepsze decyzje, nowe wyzwania.

Do zapamiętania na test: Big Data to Volume, Variety, Velocity i Veracity. Volume, czyli objętość, rośnie potęgowo, a nie liniowo, i obejmuje też dużą liczbę małych zbiorów. Variety to różne formaty, takie jak XML, JSON i multimedia. Velocity to szybki napływ i przetwarzanie, na przykład strumieniowe. Veracity to niepewność wynikająca z braków, niespójności i aproksymacji.

## Big Data: na co zwracać uwagę przy projektowaniu dużych systemów

Kolejny slajd mówi o najważniejszych aspektach projektowania i wykorzystania dużych systemów baz danych. Są cztery.

Pierwszy to skalowalność. System powinien umożliwiać łatwe zwiększanie zasobów: więcej danych, więcej użytkowników, więcej węzłów. Podpis na grafice: rosnące potrzeby oznaczają możliwość skalowania.

Drugi to koszt. Wielkie systemy muszą być projektowane i utrzymywane efektywnie kosztowo. Slajd podaje trzy sposoby: rozwiązania open source, chmura i architektura rozproszona. Podpis: większa efektywność, niższe koszty.

Trzeci to elastyczność. System powinien szybko dostosowywać się do zmieniających się wymagań biznesowych, typów danych i obciążeń.

Czwarty to dostępność. Dane mają być dostępne niezawodnie, z wysoką dostępnością i odpornością na awarie. Przykładowe mechanizmy to replikacja, klastry i rozproszone systemy plików.

Teraz zobacz, jak ładnie to się łączy z NoSQL. Slajd mówi, że bazy NoSQL mogą bardzo pomóc w racjonalizacji tych czterech elementów, bo oferują: lepszą skalowalność dzięki architekturom rozproszonym, niższe koszty dzięki brakowi sztywnych schematów, większą elastyczność dzięki różnorodnym modelom danych i wysoką dostępność dzięki replikacji i partycjonowaniu. Każdemu z czterech aspektów odpowiada więc jeden argument za NoSQL. Zapamiętaj te pary, bo pytanie może brzmieć „dzięki czemu NoSQL zapewnia wysoką dostępność” i wtedy odpowiedzią jest replikacja i partycjonowanie, a nie brak schematu.

Slajd od razu studzi entuzjazm. Grafika pokazuje przekreśloną bazę i strzałkę do bazy z napisem NoSQL, ale tekst mówi: nie należy bezrefleksyjnie odchodzić od baz relacyjnych, zastępując je całkowicie bazami nierelacyjnymi. Wybór technologii ma zależeć od charakteru danych, wymagań aplikacji i konkretnego zadania. Dlatego projektanci i programiści baz danych muszą znać zarówno bazy relacyjne, jak i NoSQL, żeby umieć ocenić, który model lepiej pasuje do zadania. Hasło: Big Data to odpowiednie technologie plus świadome decyzje plus dopasowanie do potrzeb.

Do zapamiętania na test: cztery aspekty dużych systemów to skalowalność, koszt, elastyczność i dostępność. NoSQL pomaga w nich przez architektury rozproszone, brak sztywnych schematów, różnorodne modele danych oraz replikację i partycjonowanie. Wykład wyraźnie mówi, że NoSQL nie ma całkowicie zastąpić baz relacyjnych, a wybór zależy od danych i zadania.

## Bazy relacyjne

Zanim pójdziemy dalej, wracamy do punktu wyjścia. Bazy relacyjne to systemy zarządzania bazami danych, które przechowują dane w postaci tabel i wykorzystują model relacyjny oraz język SQL.

Model danych jest zorganizowany hierarchicznie: instancja, w niej baza, w bazie tabela, w tabeli wiersz. Zapamiętaj tę kolejność, bo za chwilę zobaczysz analogiczne łańcuchy w MongoDB, gdzie mamy dokument, kolekcję i bazę, oraz w Cassandrze, gdzie mamy wiersz, tabelę, keyspace i klaster.

Język zapytań ma dwie postacie. Rzeczywisty to SQL, czyli Structured Query Language. Formalny to algebra relacyjna. Algebra relacyjna to matematyczny model operacji na relacjach, a SQL to praktyczny język, którego używamy na co dzień. Pytanie testowe może zapytać, co jest formalnym językiem zapytań modelu relacyjnego, i wtedy odpowiedzią jest algebra relacyjna, a nie SQL.

Przykład zapytania ze slajdu: SELECT imie, nazwisko FROM klienci WHERE miasto równa się, w apostrofach, Warszawa, i średnik. Tabela klienci ma cztery wiersze: Jan Kowalski z Warszawy, Anna Nowak z Krakowa, Piotr Wiśniewski z Warszawy i Ewa Wójcik z Gdańska. Wynik zawiera dwa wiersze: Jan Kowalski i Piotr Wiśniewski, bo tylko oni mieszkają w Warszawie. Zwróć uwagę, że wynik ma tylko dwie kolumny, imię i nazwisko, bo tylko je wymieniliśmy po słowie SELECT.

Możliwości zapytań w bazach relacyjnych są bogate. Selekcja to wybór danych według kryteriów. Złączenia, czyli JOIN, łączą dane z wielu tabel. Agregacja to obliczenia zbiorcze, na przykład SUM, COUNT i AVG. Podzapytania to zapytania zagnieżdżone. Do tego dochodzą sortowanie, grupowanie, filtrowanie i modyfikacja danych poleceniami INSERT, UPDATE i DELETE. Zapamiętaj zwłaszcza złączenia, bo to właśnie ich zwykle brakuje w prostych bazach NoSQL.

Przykłady systemów dzielą się na dwie grupy. Komercyjne, klasy enterprise: Oracle Database, Microsoft SQL Server i IBM DB2. Otwarte i popularne: MySQL, PostgreSQL i MariaDB. Ciekawostka z logotypów: PostgreSQL ma słonia, a MariaDB fokę.

Zalety baz relacyjnych według slajdu to spójność i integralność danych, dojrzałe i stabilne technologie, bogate możliwości zapytań oraz szerokie wsparcie i społeczność. Bazy relacyjne pozostają fundamentem wielu systemów informacyjnych, zarówno w biznesie, jak i w administracji.

Do zapamiętania na test: model relacyjny to instancja, baza, tabela, wiersz. Rzeczywisty język zapytań to SQL, formalny to algebra relacyjna. Oracle, SQL Server i DB2 są komercyjne, a MySQL, PostgreSQL i MariaDB otwarte. Główne zalety to spójność, integralność, dojrzałość, bogate zapytania i duża społeczność.

## Jak zmieniły się dane

Następny slajd nosi tytuł „Obecnie”. Duże dane mają ogromną objętość, różnorodność i wysoką szybkość powstawania, co stawia nowe wymagania przed systemami przechowywania i przetwarzania.

Objętość przesuwa się od terabajtów do zetabajtów. Na grafice oś idzie przez TB, PB, EB i ZB, czyli terabajty, petabajty, eksabajty i zetabajty. Każdy kolejny stopień jest tysiąc razy większy od poprzedniego. Wzrost jest dynamiczny i ciągły, a tradycyjne metody przechowywania stają się niewystarczające.

Różnorodność dzieli dane na trzy grupy i to jest bardzo częsty temat pytań. Dane strukturalne to bazy danych i tabele, czyli wszystko, co ma stały schemat. Dane niestrukturalne to teksty, obrazy, wideo i audio. Dane półstrukturalne to na przykład XML i JSON: mają strukturę, bo są w nich pola i zagnieżdżenia, ale nie mają sztywnego schematu narzuconego z góry. Do tego dochodzi łączenie danych z wielu źródeł i formatów. Na teście uważaj: JSON i XML to dane półstrukturalne, a nie niestrukturalne.

Szybkość powstawania i przetwarzania oznacza przejście od przetwarzania wsadowego do przetwarzania strumieniowego, w czasie rzeczywistym. Przetwarzanie wsadowe, po angielsku batch, zbiera dane i obrabia je paczką, na przykład raz na noc. Strumieniowe obrabia każde zdarzenie, gdy tylko przyjdzie. Dane są generowane nieustannie przez czujniki, media społecznościowe, transakcje i logi, a firmy chcą je szybko analizować i szybko podejmować decyzje.

Grafika zawiera cytat: dane to nowa ropa naftowa, ale ich wartość zależy od możliwości ich przetwarzania. Wniosek slajdu: duże dane wymagają nowoczesnych technologii i podejść, takich jak systemy Big Data i systemy rozproszone.

Kolejny slajd, również zatytułowany „Obecnie”, opisuje, jak zmieniają się same dane, i jest bardzo testowy. Po pierwsze, format danych może być nieznany albo pozbawiony sztywnej struktury, na przykład tekst, zdjęcia, wideo i dane z czujników. Po drugie, zamiast przyrostu liniowego mamy przyrost potęgowy, liczba danych rośnie lawinowo. Po trzecie, operacje odczytu stają się ważniejsze i częstsze niż operacje zapisu, bo wielu użytkowników korzysta z danych równocześnie. Pomyśl o portalu społecznościowym: jeden post jest zapisany raz, a czytany tysiące razy. Po czwarte, aktualizacje danych nie są już tak częste i nie przychodzą w przewidywalnych przedziałach czasowych jak dawniej. Dane mogą być zmieniane nieregularnie i w sposób rozproszony. Po piąte, dane mogą zostać szybko zastąpione, na przykład nowa wersja profilu, aktualne położenie czy strumień odczytów z czujnika. Po szóste, i to jest najważniejsze, ścisła spójność danych coraz częściej ustępuje potrzebie dużej szybkości działania. Akceptuje się spójność ostateczną, po angielsku eventual consistency, w zamian za wydajność i skalowalność.

Ten ostatni punkt to zapowiedź modelu BASE i twierdzenia CAP, które omówimy pod koniec rozdziału. Slajd wymienia też przykładowe źródła danych: media społecznościowe, czyli posty, komentarze i reakcje z Facebooka, Twittera i Instagrama, urządzenia mobilne z lokalizacją i aplikacjami, czujniki Internetu rzeczy, dane tekstowe jak e-maile i dokumenty, a także zdjęcia i wideo. Dane trafiają do chmury, a efektem są wydajność, skalowalność i nowe możliwości, takie jak personalizacja i analiza w czasie rzeczywistym. Hasło: dane zmieniają się szybciej niż kiedykolwiek, a nowe wyzwania wymagają podejść elastycznych i skalowalnych.

Do zapamiętania na test: dane strukturalne to tabele, niestrukturalne to tekst, obrazy, wideo i audio, a półstrukturalne to XML i JSON. Przetwarzanie przesuwa się z wsadowego na strumieniowe. Odczyty stają się ważniejsze i częstsze niż zapisy. Aktualizacje są nieregularne, dane szybko się dezaktualizują, a ścisłą spójność coraz częściej zastępuje spójność ostateczna.

## Nowe podejście do Big Data i dlaczego NoSQL jest interesujący

Slajd o nowym podejściu do Big Data zaczyna od tego, czemu tradycyjne bazy relacyjne nie wystarczają. Są cztery powody: problemy ze skalowaniem dla ogromnych zbiorów danych, ograniczona obsługa danych nieustrukturalizowanych, wysokie koszty przy dużych wolumenach i nieefektywność w przetwarzaniu w czasie rzeczywistym. Współczesne wyzwania wymagają więc nowego podejścia, a slajd pokazuje sześć rozwiązań dla Big Data.

Pierwsze to rozproszone systemy plików. Przechowują ogromne ilości danych na wielu węzłach i zapewniają wysoką niezawodność oraz odporność na awarie. Przykładem jest HDFS, czyli Hadoop Distributed File System.

Drugie to MapReduce. To równoległe przetwarzanie danych w klastrach. Problem dzieli się na mniejsze zadania, to jest faza map, a potem łączy wyniki, to jest faza reduce. Daje to skalowalność dla dużych zbiorów. Szczegółowo wrócimy do tego na końcu rozdziału.

Trzecie to przetwarzanie w chmurze: elastyczne zasoby w modelach IaaS, PaaS i SaaS, skalowalność, niższe koszty i dostęp do potężnej infrastruktury. Przykłady to AWS, Microsoft Azure i Google Cloud.

Czwarte to bazy NoSQL: elastyczne modele danych, czyli dokumentowe, klucz–wartość, kolumnowe i grafowe, wysoka wydajność i skalowalność oraz dobre dopasowanie do danych nieustrukturalizowanych. Slajd podaje przykłady MongoDB, Cassandra, Hadoop i Redis. Tu mała uwaga: Hadoop nie jest bazą danych, tylko platformą do rozproszonego składowania i przetwarzania, złożoną głównie z HDFS i MapReduce. Bazą NoSQL z ekosystemu Hadoopa jest HBase. Jeżeli test zapyta o przykład bazy NoSQL, bezpieczniej wybrać MongoDB, Cassandrę, Redisa albo HBase.

Piąte to hurtownie danych. Służą do integracji i analizy dużych zbiorów danych, wspierają analitykę biznesową, czyli OLAP, i pomagają podejmować lepsze decyzje. Przykłady to Amazon Redshift, Google BigQuery i Snowflake.

Szóste to uczenie maszynowe na dużą skalę: analiza danych strumieniowych i historycznych, wykrywanie wzorców i predykcje, a zastosowania to rekomendacje, detekcja anomalii i analiza sentymentu. Przykłady to TensorFlow i Spark MLlib.

Teraz pytanie, dlaczego bazy NoSQL są interesujące. Wykład podaje dwa główne powody i warto je znać dokładnie w tym brzmieniu.

Pierwszy powód to produktywność tworzenia aplikacji. Bazy NoSQL mają modele danych lepiej dopasowane do potrzeb aplikacji, co upraszcza interakcję z danymi i zmniejsza ilość potrzebnego kodu. Ułatwia to mapowanie danych między strukturami w pamięci programu a bazą. Slajd rozbija to na cztery punkty: elastyczny model danych, czyli łatwiejsze mapowanie do struktury aplikacji, prostsza integracja, czyli mniej złożonych schematów i szybsze zmiany, mniejsza ilość kodu, czyli prostsza interakcja z danymi, oraz obsługa różnych typów danych: strukturalnych, półstrukturalnych i niestrukturalnych. Przykład z grafiki to aplikacja internetowa, która korzysta jednocześnie z danych użytkowników w postaci dokumentów, z obrazów i z logów w JSON. Ramka mówi, że NoSQL pozwala skupić się na logice biznesowej, a nie na złożonym modelowaniu danych.

Drugi powód to duże wolumeny danych. Organizacje przechowują coraz więcej danych, które trzeba szybko przetwarzać. Tradycyjne bazy relacyjne są w takiej skali kosztowne i nieefektywne. Bazy NoSQL są projektowane do pracy w klastrach, czyli na wielu mniejszych i tańszych maszynach. Slajd wymienia: skalowalność, czyli łatwe uruchamianie wielu mniejszych maszyn, lepszą wydajność, czyli krótszy czas przetwarzania, niższe koszty, bo rozproszone rozwiązania są tańsze niż duże pojedyncze maszyny, oraz rozproszone architektury. Wykres pokazuje płaską linię wzrostu liniowego tradycyjnych systemów i gwałtowną krzywą wzrostu wykładniczego Big Data. Ramka: bazy NoSQL są naturalnym wyborem w środowiskach, gdzie ilość danych rośnie wykładniczo.

Tu warto wyjaśnić dwa pojęcia, które przewijają się przez cały wykład. Skalowanie pionowe, po angielsku vertical albo scale up, polega na kupieniu mocniejszej maszyny: więcej procesorów, pamięci, szybszy dysk. Ma ono sufit i bywa bardzo drogie. Skalowanie poziome, po angielsku horizontal albo scale out, polega na dokładaniu kolejnych zwykłych maszyn do klastra. Bazy relacyjne skalują się głównie pionowo, a bazy NoSQL głównie poziomo. To jedna z najczęściej sprawdzanych różnic.

Slajd „Dlaczego NoSQL?” dodaje jeszcze kilka faktów. Coraz łatwiej jest uzyskać dostęp do danych witryn internetowych, na przykład Facebooka czy Twittera, i je przechowywać. Dostępne dane to użytkownicy, lokalizacja, sieci społeczne, logi maszynowe i treści tworzone przez użytkowników. Tradycyjne bazy SQL nie były projektowane do takiej skali. NoSQL obsługuje dane strukturalne i niestrukturalne i szybko je przetwarza. Firmy takie jak Google, Facebook, LinkedIn i Twitter używają NoSQL do przetwarzania terabajtów danych dziennie. Analiza i koordynacja danych dają wiedzę biznesową i decyzje strategiczne. Efekty i zastosowania to analiza danych w czasie rzeczywistym, lepsze decyzje biznesowe, personalizacja usług oraz rozwój produktów i innowacje. Hasło: dane napędzają biznes, a NoSQL pozwala wykorzystać ich pełny potencjał.

Do zapamiętania na test: tradycyjne bazy mają problemy ze skalowaniem, z danymi nieustrukturalizowanymi, z kosztami i z czasem rzeczywistym. Rozwiązania dla Big Data to rozproszone systemy plików z HDFS, MapReduce, chmura, NoSQL, hurtownie danych z Redshiftem, BigQuery i Snowflake oraz uczenie maszynowe z TensorFlow i Spark MLlib. Dwa główne powody zainteresowania NoSQL to produktywność tworzenia aplikacji i obsługa dużych wolumenów danych w klastrach. NoSQL skaluje się poziomo, relacyjne bazy głównie pionowo.

## Chmura i sposoby przetwarzania danych

Slajd „Obecnie – wszystko jest w chmurze” wprowadza trzy modele usług chmurowych. Warto zapamiętać je od góry do dołu, bo różnią się tym, ile dostajesz gotowe, a ile robisz sam.

SaaS, czyli Software as a Service, oprogramowanie jako usługa. Dostajesz gotową aplikację przez Internet i po prostu jej używasz. Przykłady ze slajdu to Google Workspace i Salesforce.

PaaS, czyli Platform as a Service, platforma jako usługa. Dostajesz platformę do tworzenia i uruchamiania własnych aplikacji, bez zajmowania się serwerami i systemem operacyjnym. Przykłady to Microsoft Azure i Heroku.

IaaS, czyli Infrastructure as a Service, infrastruktura jako usługa. Dostajesz serwery, sieci i przestrzeń dyskową, a całą resztę konfigurujesz sam. Przykłady to AWS, Google Cloud i Microsoft Azure. Azure występuje w obu miejscach, bo ten dostawca oferuje zarówno platformę, jak i infrastrukturę.

Dobra analogia to pizza. IaaS to wynajęta kuchnia z piecem, a ciasto robisz sam. PaaS to gotowe ciasto i piec, dokładasz tylko składniki, czyli swój kod. SaaS to pizza dowieziona do domu.

Drugą częścią slajdu są trzy sposoby przetwarzania danych. Trzymaj się rozwinięć skrótów, bo z nich łatwo odczytać sens.

OLTP, czyli Online Transaction Processing, przetwarzanie transakcyjne. Obsługuje bieżące transakcje, czyli szybkie operacje zapisu i odczytu. Przykłady to systemy bankowe i sklepy internetowe. Typowa operacja OLTP to przelew albo złożenie zamówienia: mała porcja danych, ale bardzo dużo takich operacji.

OLAP, czyli Online Analytical Processing, przetwarzanie analityczne. Służy do analizy danych historycznych, wykonuje złożone zapytania i agregacje i wspiera podejmowanie decyzji. To świat hurtowni danych i kostek OLAP, które zobaczysz na jednym ze slajdów.

RTAP, czyli Real-Time Analytical Processing, analityka w czasie rzeczywistym. Analizuje dane na bieżąco i daje natychmiastowe wyniki. Przykłady to monitoring, rekomendacje i Internet rzeczy.

Najczęstsza pomyłka na teście to zamiana OLTP z OLAP. Zapamiętaj: T jak transakcja, czyli bieżące operacje, A jak analiza, czyli historia i agregacje. RTAP to analiza, ale natychmiastowa.

Ten sam slajd zestawia SQL i NoSQL. Bazy relacyjne, czyli RDBMS, dominują od wielu lat, zapewniają spójność i kontrolę współbieżności, wykorzystują sztywny schemat danych, dobrze sprawdzają się w transakcjach, czyli w OLTP, a integracja systemów odbywa się często przez bazę danych. Grafika pokazuje trzy powiązane tabele: Klienci, Zamówienia i Produkty, połączone kluczami.

Bazy NoSQL to elastyczne przechowywanie danych. Nie mają sztywnego schematu, dobrze działają w klastrach, powstały głównie na potrzeby aplikacji webowych dwudziestego pierwszego wieku, obsługują dane strukturalne i niestrukturalne, zapewniają dużą skalowalność, mają otwarty kod i szerokie zastosowanie. Grafika pokazuje cztery modele: klucz–wartość, gdzie klucz user dwukropek jeden wskazuje na wartość, model dokumentowy z dokumentem zawierającym imię Anna, wiek dwadzieścia pięć i miasto Kraków, magazyn kolumnowy oraz graf z węzłami i krawędziami.

Slajd wymienia sześć popularnych baz NoSQL wraz z typami i to jest lista do nauki na pamięć. MongoDB to baza dokumentowa, operująca na JSON i BSON. Cassandra to baza kolumnowa o wysokiej skalowalności. Redis to baza klucz–wartość, używana jako cache i w zastosowaniach czasu rzeczywistego. CouchDB to baza dokumentowa, znana z replikacji i pracy offline. HBase to baza kolumnowa z ekosystemu Hadoop. Neo4j to baza grafowa, skupiona na relacjach między danymi. Logotypy też bywają pomocne: MongoDB ma liść, Cassandra oko, Redis czerwony stos, a CouchDB czerwoną kanapę.

Na sąsiednim slajdzie bez tytułu widać to samo w formie schematu. Po stronie SQL są systemy RDBMS z powiązanymi tabelami, gdzie relacje oznaczono końcówkami nazywanymi kurzą stopką, czyli oznaczeniem „wiele” w notacji diagramów encji, oraz kostka OLAP, czyli wielowymiarowy sześcian danych. Po stronie NoSQL są cztery modele: Key-Value, Graph, Document i Column store. Zwróć uwagę, że kostka OLAP stoi tu po stronie SQL. Klasyczna analityka wielowymiarowa wyrosła ze świata relacyjnego.

Do zapamiętania na test: SaaS to gotowa aplikacja, na przykład Google Workspace i Salesforce. PaaS to platforma, na przykład Heroku i Azure. IaaS to infrastruktura, na przykład AWS, Google Cloud i Azure. OLTP to bieżące transakcje, OLAP to analiza danych historycznych z agregacjami, RTAP to analiza w czasie rzeczywistym. MongoDB i CouchDB są dokumentowe, Cassandra i HBase kolumnowe, Redis jest klucz–wartość, a Neo4j grafowy.

## Czym jest NoSQL i skąd wziął się ten termin

Przejdźmy do samego terminu. Co oznacza NoSQL? Slajd mówi wyraźnie: NoSQL to nie „no to SQL”, czyli nie „nie dla SQL”. Termin nie jest negacją SQL. Najczęściej rozwija się go jako Not only SQL, czyli „nie tylko SQL”, i ramka na slajdzie właśnie to podsuwa: NoSQL to nie tylko alternatywa, ale uzupełnienie klasycznych baz relacyjnych. Drugi ważny fakt: NoSQL nie ma precyzyjnej definicji. Określenie obejmuje różne typy baz innych niż relacyjne, zaprojektowane z myślą o skalowalności, elastyczności i dużych wolumenach danych. Na teście zdanie „NoSQL ma ścisłą, formalną definicję” jest fałszywe.

Krótka historia według slajdów wygląda tak. W tysiąc dziewięćset dziewięćdziesiątym ósmym roku pokazano relacyjną bazę danych, która nie wykorzystywała języka SQL. To była baza Carla Strozziego, nazwana właśnie Strozzi NoSQL. Uwaga, ona była relacyjna, tylko bez języka SQL, a współczesne bazy NoSQL są nierelacyjne. Slajd o historii mówi, że termin pojawił się w latach dziewięćdziesiątych przy bazie Strozzi i nie miał wpływu na późniejszy ruch NoSQL. Na osi czasu ten sam slajd przypisuje rokowi tysiąc dziewięćset dziewięćdziesiątemu ósmemu ogólnie rozwój baz nierelacyjnych i rosnące zainteresowanie alternatywami dla SQL. W rzeczywistości rok tysiąc dziewięćset dziewięćdziesiąty ósmy to właśnie rok bazy Strozziego, więc oba zapisy mówią o tym samym okresie. Na test zapamiętaj: tysiąc dziewięćset dziewięćdziesiąty ósmy, baza Strozzi, relacyjna bez SQL, bez wpływu na późniejsze NoSQL.

Druga data to dwa tysiące dziewiąty rok. Krótka wersja ze slajdu mówi: na konferencji pokazano bazę NoSQL mającą wspierać bazy relacyjne. Pełna wersja jest dokładniejsza. Jedenastego czerwca dwa tysiące dziewiątego roku w San Francisco odbyło się spotkanie, na którym po raz pierwszy użyto terminu NoSQL w dzisiejszym znaczeniu. Inicjatorem był Johan Oskarsson. Celem spotkania była prezentacja i dyskusja o nowych nierelacyjnych bazach danych, zaprojektowanych z myślą o skalowalności, elastyczności i dużych wolumenach danych. Pokazywane systemy to Voldemort, Cassandra, Dynomite, HBase, Hypertable, CouchDB i MongoDB. Nazwę NoSQL wybrano, bo była dobrym hashtagiem na Twitterze. Zaproponowano ją na kanale IRC hasz cassandra, a zatwierdził ją Eric Evans. Po dwa tysiące dziewiątym roku termin stał się popularny, choć nie opisuje dokładnie wszystkich nierelacyjnych baz danych.

Pułapki na teście: datą narodzin współczesnego NoSQL jest jedenasty czerwca dwa tysiące dziewiątego roku, a nie tysiąc dziewięćset dziewięćdziesiąty ósmy. Miejscem jest San Francisco. Johan Oskarsson zorganizował spotkanie, a Eric Evans zatwierdził nazwę. Nie myl ich ról. Na liście baz ze spotkania nie było Redisa ani Neo4j, choć pojawiają się na innych slajdach jako przykłady.

Na slajdach z przykładami pojawiają się logotypy: MongoDB jako baza dokumentowa, Redis jako klucz–wartość, Cassandra jako kolumnowa i Elasticsearch jako baza wyszukiwawcza. Na slajdzie historycznym dochodzą HBase jako kolumnowa, CouchDB jako dokumentowa, DynamoDB jako klucz–wartość, Hypertable jako kolumnowa i Voldemort jako klucz–wartość. Zapamiętaj zwłaszcza, że Voldemort i DynamoDB są klucz–wartość, a Hypertable i HBase kolumnowe. Na jednym slajdzie przy logotypach dopisano krótkie charakterystyki: MongoDB to elastyczny model danych w JSON, Redis to wysoka wydajność i niski czas odpowiedzi, Cassandra jest skalowalna i odporna na awarie, a Elasticsearch daje potężne możliwości wyszukiwania i analizy.

Slajd „NoSQL – czym jest i dlaczego używać” dodaje trzy zdania. Bazy NoSQL tworzono głównie na potrzeby aplikacji webowych dwudziestego pierwszego wieku. Termin nie odnosi się do negacji SQL, a do zbioru nowoczesnych, najczęściej open source baz danych. NoSQL to raczej ruch niż konkretna technologia. To ostatnie zdanie jest bardzo dobre na pytanie: NoSQL nie jest produktem ani jednym standardem, tylko ruchem, który obejmuje wiele różnych systemów.

Główne zalety według tego slajdu są dwie: obsługa danych wymagających klastrów oraz większa produktywność i elastyczność w tworzeniu aplikacji dzięki prostszemu modelowi danych. Bazy NoSQL sprawdzają się w aplikacjach webowych i mobilnych, przy dużych wolumenach danych i w systemach rozproszonych.

Do zapamiętania na test: NoSQL to nie „no to SQL”, lecz raczej „Not only SQL”, i nie ma precyzyjnej definicji. Rok tysiąc dziewięćset dziewięćdziesiąty ósmy to relacyjna baza Strozzi bez SQL. Jedenasty czerwca dwa tysiące dziewiątego roku to spotkanie w San Francisco zorganizowane przez Johana Oskarssona. Nazwę jako hashtag na Twittera zaproponowano na IRC hasz cassandra, a zatwierdził ją Eric Evans. NoSQL to raczej ruch niż konkretna technologia.

## Bazy NoSQL — najważniejsze kwestie

Ten slajd porównuje bazy relacyjne z NoSQL i wyjaśnia, co zmieniło się w podejściu. To jedno z ważniejszych miejsc w rozdziale.

O bazach relacyjnych: dominują od wielu lat, zapewniają spójność i kontrolę współbieżności, a integracja systemów odbywa się często przez bazę danych. Mają jednak trudność z dopasowaniem do struktur danych w pamięci programu. To zjawisko nazywa się impedancją obiektowo-relacyjną, po angielsku object-relational impedance mismatch. Chodzi o różnicę między strukturą obiektów w aplikacji a tabelami w bazie relacyjnej. W programie masz obiekt zamówienia, który zawiera listę pozycji, adres i klienta, wszystko zagnieżdżone. W bazie relacyjnej musisz to rozbić na kilka tabel, a przy odczycie skleić złączeniami. Narzędzia ORM, takie jak Hibernate, łagodzą ten problem, ale go nie usuwają. Bazy dokumentowe zapisują obiekt w całości jako dokument, więc tej niezgodności jest dużo mniej. Ramka mówi, że relacyjne bazy świetnie sprawdzają się tam, gdzie kluczowa jest spójność danych i złożone relacje.

Teraz zmiany w podejściu. Nastąpiło przejście od integracji przez bazy danych do enkapsulacji bazy w aplikacjach. Dawniej kilka aplikacji dzieliło jedną wspólną bazę i to ona była punktem integracji. Dziś każda aplikacja, a nawet każda usługa, ma własną bazę i ukrywa ją przed innymi. Integracja odbywa się przez usługi sieciowe, na przykład API. Kiedy baza należy do jednej aplikacji, ta aplikacja może wybrać model danych, który najlepiej jej pasuje, i to otworzyło drogę dla NoSQL. Do tego doszła konieczność obsługi dużych wolumenów danych w klastrach, a bazy relacyjne nie są optymalne w klastrach. Rosnące wymagania aplikacji, czyli wydajność, skalowalność i elastyczność, spopularyzowały NoSQL.

Cechy baz NoSQL z tego slajdu: brak modelu relacyjnego, dobre działanie w klastrach, otwarty kod, projektowanie dla aplikacji webowych dwudziestego pierwszego wieku, brak sztywnego schematu, czyli schema-less, oraz możliwość doboru sposobu przechowywania danych według ich specyfiki. Ramka: NoSQL to odpowiedź na potrzeby nowoczesnych, skalowalnych aplikacji. Hasło powtarzające się na kilku slajdach: różne dane, różne potrzeby, NoSQL.

Do zapamiętania na test: impedancja obiektowo-relacyjna to niedopasowanie obiektów aplikacji do tabel bazy relacyjnej. Zmiana podejścia polega na przejściu od integracji przez wspólną bazę do enkapsulacji bazy w aplikacji i integracji przez API. Bazy relacyjne nie są optymalne w klastrach, a NoSQL jest schema-less i dobrze działa w klastrach.

## Definicja NoSQL i jego cechy charakterystyczne

Slajd, którego źródłem jest serwis hostingdata.co.uk, porządkuje definicję. Ruch NoSQL to poszukiwanie alternatyw dla problemów, które bazy relacyjne trudno rozwiązują. Bazy NoSQL to nowa generacja baz danych, które są nierelacyjne, rozproszone, otwarte i horyzontalnie skalowalne. Po angielsku: non-relational, distributed, open-source i horizontally scalable. Horyzontalnie znaczy poziomo, czyli przez dodawanie maszyn.

Cechy charakterystyczne to: brak sztywnego schematu, czyli schema-free, łatwe replikowanie danych, proste API, spójność ewentualna, czyli eventually consistent, oraz obsługa dużych zbiorów danych. Słowo „ewentualna” jest tu kalką z angielskiego eventually. Po polsku znaczy to „ostatecznie”, a nie „być może”. Spójność ewentualna to więc spójność ostateczna: dane w końcu staną się spójne, choć nie natychmiast. Pułapka na teście: horyzontalna skalowalność to cecha NoSQL, a pionowa to typowa droga baz relacyjnych.

Kolejny slajd mówi uczciwie o zaletach i wadach. Po pierwsze, bazy NoSQL pozwalają przechowywać dane bez schematu. To może być zarówno zaleta, jak i wada. Zaletą jest elastyczność. Wadą jest ryzyko zabałaganienia danych, co wpływa również na aplikacje. Jeśli baza nie pilnuje struktury, każdy dokument może wyglądać inaczej, a kod aplikacji musi obsłużyć wszystkie warianty. Odpowiedzialność za porządek przechodzi z bazy na programistę.

Po drugie, bazy NoSQL są łatwiejsze w skalowaniu. Wielu uważa je też za prostsze w programowaniu, ale slajd zaznacza, że to ocena subiektywna.

Po trzecie, brakuje w nich wsparcia dla znanej z baz relacyjnych bardzo rygorystycznej spójności danych. Spójność, po angielsku consistency, jest często poświęcana na rzecz wysokiej dostępności i szybkości działania. Utrzymanie spójności w systemach rozproszonych jest zazwyczaj trudne. Czasem nie można z niej zrezygnować, na przykład przy kontach bankowych, danych finansowych i danych ubezpieczeniowych. W wielu innych systemach rozproszonych spójność nie jest konieczna, a na pewno nie jest priorytetem. Pomyśl o liczniku polubień: nikomu nie zaszkodzi, że przez sekundę jeden użytkownik widzi sto polubień, a drugi sto jeden.

Do zapamiętania na test: bazy NoSQL są nierelacyjne, rozproszone, otwarte i horyzontalnie skalowalne. Cechy to schema-free, łatwa replikacja, proste API, eventual consistency i duże zbiory danych. Brak schematu to zaleta i wada jednocześnie. Spójność bywa poświęcana dla dostępności i szybkości, ale nie wolno tego robić przy danych bankowych, finansowych i ubezpieczeniowych.

## Lista rodzajów systemów NoSQL

Według serwisu hostingdata.co.uk systemy NoSQL dzielą się na wiele kategorii. Wymienię je po kolei, bo test może zapytać, która z podanych kategorii jest na tej liście. Są to: Wide Column Store, czyli bazy szerokich kolumn albo rodzin kolumn, Document Store, czyli bazy dokumentowe, Key Value albo Tuple Store, czyli bazy klucz–wartość i krotkowe, Graph Database Management Systems, czyli bazy grafowe, Multimodel Database Management Systems, czyli bazy wielomodelowe, Object Database Management Systems, czyli bazy obiektowe, Grid and Cloud Database Management Solutions, czyli rozwiązania gridowe i chmurowe, XML Database Management Systems, czyli bazy XML, Multidimensional Database Management Systems, czyli bazy wielowymiarowe, Multivalue Database Management Systems, czyli bazy wielowartościowe, Event Sourcing, czyli zapisywanie stanu jako ciągu zdarzeń, Time Series i Streaming Database Management Systems, czyli bazy szeregów czasowych i strumieniowe, a na końcu dwie kategorie zbiorcze: inne systemy związane z NoSQL oraz systemy nierozstrzygnięte i niesklasyfikowane, po angielsku Unresolved and Uncategorized.

Wykład szczegółowo omawia z tej listy cztery główne rodziny, czyli klucz–wartość, dokumentowe, kolumnowe i grafowe, a dodatkowo bazy XML i RDF. Bazy relacyjnej nie ma oczywiście na tej liście.

Do zapamiętania na test: główne rodziny NoSQL to klucz–wartość, dokumentowe, rodziny kolumn i grafowe. Lista obejmuje też bazy wielomodelowe, obiektowe, XML, wielowymiarowe, wielowartościowe, Event Sourcing oraz szeregi czasowe.

## Bazy klucz–wartość

Bazy klucz–wartość to najprostszy model bazy NoSQL. Najlepsza analogia to tablica asocjacyjna, czyli słownik. W Pythonie to dict, w Javie HashMap. Dane przechowuje się jako pary klucz–wartość. Klucz to unikalny identyfikator, na przykład ciąg znaków albo liczba. Wartość to dowolne dane: tekst, obiekt, lista, liczba. Ważne jest to, że dla bazy wartość jest zwykle nieprzezroczysta. Baza nie zagląda do środka, tylko przechowuje ją pod kluczem.

Podstawowe operacje tworzą dwie grupy: dodaj, zmień albo usuń wartość dla podanego klucza oraz pobierz wartość dla podanego klucza. Wszystko kręci się wokół klucza.

Zalety to bardzo prosta architektura, szybki dostęp do danych, czyli niska latencja, oraz łatwe skalowanie, na przykład poziome. Prostota modelu sprzyja skalowaniu, bo klucze łatwo rozdzielić między serwery.

Ograniczenia to słaba przydatność dla danych o złożonej strukturze i zazwyczaj brak zaawansowanych zapytań, na przykład wyszukiwania po wartościach. Jeżeli chcesz znaleźć wszystkich użytkowników z Krakowa, a miasto siedzi wewnątrz wartości, baza klucz–wartość ci w tym nie pomoże.

Kiedy używać? Slajd wymienia: dane sesyjne, cache aplikacyjny, ustawienia użytkownika, koszyki zakupowe, rankingi i liczniki, na przykład polubienia i wyświetlenia, oraz przechowywanie tokenów i danych uwierzytelniających, na przykład sesji i kluczy API. Wspólny mianownik jest prosty: wszystkie te dane odczytujemy po znanym identyfikatorze, na przykład po identyfikatorze sesji albo użytkownika.

Kiedy nie używać? Gdy występują złożone relacje między encjami, gdy potrzebne są złączenia JOIN, gdy zapytania dotyczą fragmentów wartości zamiast klucza i gdy trzeba przeszukiwać wiele rekordów według różnych kryteriów, na przykład filtrować po wielu polach.

Przedstawiciele z logotypów to Redis, Valkey, Amazon DynamoDB, Aerospike, Riak KV, Hazelcast, Oracle NoSQL Database i Dragonfly. Valkey to otwartoźródłowy fork Redisa.

Slajd z rankingiem DB-Engines dla baz klucz–wartość, ze stanem na październik dwa tysiące dwudziestego piątego roku i skalą logarytmiczną, pokazuje Redisa na samej górze z wynikiem ponad sto punktów. Pod nim jest Amazon DynamoDB, potem Microsoft Azure Cosmos DB i Memcached. Dalej na liście są między innymi etcd, Hazelcast, Aerospike, Oracle NoSQL, Riak KV, Apache Ignite, Ehcache, ArangoDB, RocksDB, Google Cloud Bigtable, LevelDB, Valkey i Oracle Berkeley DB. Zapamiętaj kolejność w czołówce: Redis, DynamoDB, Cosmos DB, Memcached.

Do zapamiętania na test: baza klucz–wartość to najprostszy model NoSQL, analogiczny do słownika. Operacje dotyczą wartości dla podanego klucza. Jest szybka i łatwo się skaluje, ale nie wspiera złożonych zapytań, złączeń ani wyszukiwania po wartościach. Służy do sesji, cache, koszyków, ustawień, liczników i tokenów. Liderem rankingu jest Redis.

## Redis

Redis to najważniejszy przedstawiciel baz klucz–wartość. Nazwa jest akronimem od REmote DIctionary Server, czyli zdalny serwer słownika. Redis to szybka, otwartoźródłowa baza klucz–wartość, która przechowuje dane głównie w pamięci operacyjnej RAM. Ramka podkreśla, że Redis to nie tylko prosta baza klucz–wartość, bo obsługuje wiele struktur danych i zaawansowane mechanizmy, na przykład publikację i subskrypcję, czyli pub/sub.

Jak działa Redis? Klient, czyli aplikacja, wysyła polecenie do Redisa, który trzyma dane w RAM, i dostaje odpowiedź z wartością. Na slajdzie strzałkę opisano „Zapis (GET/SET)”. Ściśle biorąc, SET to zapis, a GET to odczyt, więc lepiej rozumieć to jako polecenia GET i SET. Trzy dodatkowe cechy z diagramu to: pamięć RAM, czyli błyskawiczny dostęp, opcjonalny zapis na dysk mechanizmami RDB i AOF oraz replikacja i wysoka dostępność. RDB to okresowe migawki, czyli snapshoty całego zbioru danych. AOF, od Append Only File, to dziennik, do którego dopisuje się każdą operację zapisu. RDB szybciej odtwarza dane, ale można stracić zmiany od ostatniej migawki. AOF traci mniej danych, ale plik jest większy.

Teraz przykłady poleceń, bo test może pytać o składnię. Podstawowe operacje: SET uzytkownik dwukropek jeden, a potem w cudzysłowie Jan. To zapisuje wartość Jan pod kluczem uzytkownik:1. Następnie GET uzytkownik dwukropek jeden zwraca napis Jan. Dwukropek w kluczu to tylko konwencja nazewnicza, która tworzy coś w rodzaju przestrzeni nazw. Dla Redisa to zwykły znak. Na slajdzie widać też zapis sto dwadzieścia siedem kropka zero kropka zero kropka jeden dwukropek sześć tysięcy trzysta siedemdziesiąt dziewięć, czyli adres lokalny i domyślny port Redisa. W prawdziwym terminalu jest to znak zachęty klienta, a odpowiedź Jan pojawia się w osobnej linii.

Struktura typu hash: HSET osoba dwukropek jeden, potem pary pole i wartość: imie Anna, nazwisko Nowak, wiek dwadzieścia osiem. Hash to mały słownik pod jednym kluczem, dobry do przechowywania obiektów. Polecenie HGETALL osoba dwukropek jeden zwraca wszystkie pola i wartości tego hasha.

Lista: na slajdzie zapisano LPUSH kolejka zero, zadanie1, zadanie2. Tu jest błąd. Polecenie LPUSH przyjmuje nazwę klucza, a po niej same elementy do wstawienia na początek listy. Zero zostałoby więc wstawione jako zwykły element. Poprawnie piszemy LPUSH kolejka, a potem w cudzysłowach zadanie1 i zadanie2. Litera L oznacza lewą stronę, czyli początek listy, a jest też RPUSH, który wstawia na koniec. Odczyt to LRANGE kolejka zero minus jeden. Zero to indeks pierwszego elementu, a minus jeden oznacza ostatni, więc to zapytanie zwraca całą listę. Ponieważ LPUSH wstawia każdy element na początek, po wstawieniu zadanie1 i zadanie2 lista zaczyna się od zadanie2.

Zbiór: SADD tagi, a potem tech, backend i redis. Zbiór przechowuje unikalne wartości bez kolejności. SMEMBERS tagi zwraca wszystkie elementy zbioru. Prefiksy łatwo zapamiętać: H to hash, L to lista, S to set, czyli zbiór, a Z to zbiór sortowany, na przykład ZADD.

Redis obsługuje osiem typów struktur wymienionych na slajdzie. String służy na przykład do tekstu. Hash do obiektów. List do kolejek. Set do unikalnych danych. Sorted Set do rankingów, bo każdy element ma liczbowy wynik i zbiór jest według niego posortowany. Bitmap do flag. HyperLogLog do liczenia unikalnych gości. To struktura probabilistyczna, która przybliża liczbę różnych elementów przy bardzo małym zużyciu pamięci. Stream służy do strumieni zdarzeń. Typowe pytanie: która struktura nadaje się do rankingu? Sorted Set. Która do przybliżonego liczenia unikalnych odwiedzających? HyperLogLog.

Najważniejsze cechy Redisa to bardzo wysoka wydajność dzięki danym w RAM, wszechstronne struktury danych, trwałość dzięki RDB i AOF, replikacja i klastrowanie, wysoka dostępność, prosty interfejs przez CLI i biblioteki oraz rozszerzalność przez moduły, takie jak RediSearch, RedisJSON i RedisTimeSeries.

Zastosowania to cache, który przyspiesza aplikacje, sesje użytkowników w aplikacjach webowych, e-commerce z koszykami i stanami produktów, czat w czasie rzeczywistym, rankingi i liczniki oraz Internet rzeczy ze strumieniami danych.

Zalety: błyskawiczny dostęp do danych, liczony w mikrosekundach, prosta obsługa i bogaty ekosystem, wiele typów struktur danych, skalowalność przez klastry i replikację oraz szerokie zastosowania.

Ograniczenia: dane są głównie w RAM, więc duże zbiory są kosztowne. Redis nie jest idealny do trwałego przechowywania dużych, złożonych danych biznesowych. Ma ograniczone możliwości zapytań i nie ma języka zapytań podobnego do SQL. Niewłaściwa konfiguracja grozi utratą danych, na przykład gdy wyłączymy trwałość, a serwer padnie. I wreszcie Redis nie zastępuje typowej bazy relacyjnej.

Slajd porównuje Redisa z MongoDB i z bazą relacyjną, na przykład PostgreSQL. Model danych: Redis to klucz–wartość, MongoDB dokumenty w JSON, baza relacyjna tabele z wierszami i kolumnami. Szybkość: Redis bardzo wysoka, MongoDB wysoka, relacyjna średnia. Złożoność zapytań: Redis prosta, MongoDB średnia, relacyjna zaawansowana dzięki SQL. Przechowywanie: Redis głównie RAM, MongoDB i baza relacyjna dysk. Typowe zastosowania, na slajdzie z literówką „ryzowe” zamiast „typowe”: Redis to cache, sesje i kolejki, MongoDB aplikacje webowe i systemy CMS, baza relacyjna systemy biznesowe. Hasło: Redis to szybkość, elastyczność i więcej niż tylko klucz–wartość.

Do zapamiętania na test: Redis to REmote DIctionary Server, baza klucz–wartość trzymająca dane głównie w RAM. Trwałość zapewniają RDB, czyli migawki, i AOF, czyli dziennik operacji. Polecenia to SET i GET dla stringów, HSET i HGETALL dla hashy, LPUSH i LRANGE dla list oraz SADD i SMEMBERS dla zbiorów. LRANGE klucz zero minus jeden zwraca całą listę. Sorted Set służy do rankingów, a HyperLogLog do liczenia unikalnych elementów. Domyślny port to sześć tysięcy trzysta siedemdziesiąt dziewięć.

## Bazy dokumentów

Druga rodzina to bazy dokumentowe. Model danych opiera się na dokumentach, najczęściej w formacie JSON, rzadziej XML. Dokumenty pozwalają reprezentować dane hierarchiczne i zagnieżdżone, na przykład klienta z listą adresów, a w każdym adresie z ulicą i kodem pocztowym. Dokumenty są organizowane w kolekcje. Najważniejsza różnica wobec tabeli: poszczególne dokumenty w jednej kolekcji mogą mieć różną strukturę. Jeden klient ma pole telefon, drugi nie ma, a trzeci ma dwa telefony w tablicy.

Czym baza dokumentowa różni się od bazy klucz–wartość? W obu dokumenty albo wartości są dostępne po kluczu. Baza dokumentowa rozumie jednak strukturę dokumentu i pozwala pytać o jego pola. Podstawowe operacje to dodaj, zmień albo usuń dokument, wyszukaj dokument według dowolnych kryteriów oraz filtrowanie, sortowanie i agregacja danych. To ostatnie odróżnia ją od prostej bazy klucz–wartość, która szuka tylko po kluczu.

Kiedy używać? Slajd podaje logowanie zdarzeń, blogi i systemy CMS. Kiedy nie używać? Tekst na slajdzie jest ucięty na krawędzi. Czytelny fragment mówi o sytuacji, gdy struktura dokumentów często się zmienia albo gdy dokumenty są dzielone na wiele pomniejszych. Sens jest taki: baza dokumentowa najlepiej działa, gdy dokument jest naturalną, samodzielną całością, którą czytamy i zapisujemy w jednym kawałku. Jeżeli dane trzeba rozbić na wiele małych dokumentów i ciągle je ze sobą łączyć, tracimy główną zaletę tego modelu. Zwróć uwagę, że samo istnienie różnych struktur dokumentów baza dokumentowa obsługuje dobrze. Problemem są złożone zapytania na zmiennej strukturze i operacje obejmujące wiele dokumentów naraz.

Przedstawiciele z logotypów to MongoDB, Couchbase, CouchDB z hasłem relax oraz RethinkDB. Jedno logo z pomarańczowym sześcianem jest częściowo ucięte i nieczytelne, prawdopodobnie to któraś z usług Amazona.

Slajd z rankingiem DB-Engines dla baz dokumentowych, z października dwa tysiące dwudziestego piątego roku, pokazuje MongoDB na samej górze z wynikiem ponad sto. Pod nim są Databricks i Amazon DynamoDB. Dalej Microsoft Azure Cosmos DB, Firebase Realtime Database, Couchbase, Google Cloud Firestore, Realm, CouchDB, Aerospike, MarkLogic i wiele innych, w tym Amazon DocumentDB, RavenDB, RethinkDB i PouchDB. Zwróć uwagę, że DynamoDB i Cosmos DB pojawiają się w kilku rankingach naraz, bo są bazami wielomodelowymi.

Do zapamiętania na test: bazy dokumentowe przechowują dokumenty, najczęściej JSON, rzadziej XML, zgrupowane w kolekcje. Dokumenty mogą mieć różną strukturę i zagnieżdżenia. Można wyszukiwać po dowolnych polach, filtrować, sortować i agregować. Zastosowania to logi zdarzeń, blogi i CMS. Liderem rankingu jest MongoDB.

## MongoDB

MongoDB nazwano na slajdzie bazą klucz–dokument. Taka baza przechowuje dane w postaci dokumentów, najczęściej w formacie JSON albo BSON, a każdy dokument ma unikalny klucz, czyli pole podkreślnik id. BSON to Binary JSON, binarna postać JSON, której MongoDB używa wewnętrznie. BSON ma więcej typów niż JSON, na przykład datę, ObjectId czy liczby różnej precyzji. Ramka podkreśla, że dokumenty mogą mieć różną strukturę, co daje dużą elastyczność.

Jak działa MongoDB? Łańcuch jest trzystopniowy: dokument w JSON lub BSON trafia do kolekcji, czyli zbioru dokumentów, a kolekcje tworzą bazę danych. Porównaj to z modelem relacyjnym: dokument odpowiada wierszowi, kolekcja tabeli, a baza bazie.

Przykładowy dokument ze slajdu wygląda tak. W klamrach mamy pole podkreślnik id z wartością ObjectId, a w nawiasie, w cudzysłowie, ciąg szesnastkowy. Dalej imie Jan, nazwisko Kowalski, wiek dwadzieścia pięć jako liczba, miasto Warszawa oraz pole zainteresowania, które jest tablicą w nawiasach kwadratowych z dwoma napisami: programowanie i sport. Ten przykład pokazuje dwie rzeczy: pole podkreślnik id typu ObjectId oraz to, że pole może przechowywać tablicę. W relacyjnej bazie zainteresowania wymagałyby osobnej tabeli.

Najważniejsze cechy MongoDB to elastyczny schemat, bo dokumenty mogą mieć różną strukturę, skalowalność, czyli łatwe skalowanie w poziomie przez sharding, wysoka wydajność dzięki szybkiemu dostępowi i indeksom, bogate możliwości zapytań, czyli wyszukiwanie, filtrowanie i agregacje, oraz popularność i duże wsparcie społeczności. Sharding to podział danych kolekcji między wiele serwerów, nazywanych shardami. Zapamiętaj: w MongoDB skalowanie poziome to sharding, a replikacja to kopie tych samych danych na kilku serwerach.

Przykładowe operacje są bardzo ważne, bo dalsza część kursu i laby dotyczą właśnie MongoDB.

Dodawanie dokumentu: db, kropka, klienci, kropka, insertOne, a w nawiasie dokument w klamrach: imie dwukropek Anna, nazwisko dwukropek Nowak, wiek dwukropek dwadzieścia osiem. Metoda insertOne wstawia jeden dokument. Do wstawiania wielu dokumentów naraz służy insertMany, która przyjmuje tablicę dokumentów. Jeżeli nie podamy pola podkreślnik id, MongoDB samo wygeneruje ObjectId.

Wyszukiwanie dokumentów: db, kropka, klienci, kropka, find, a w nawiasie filtr w klamrach: miasto dwukropek Warszawa. To odpowiednik SQL-owego SELECT gwiazdka FROM klienci WHERE miasto równa się Warszawa. Zwróć uwagę na ciekawostkę: dokument wstawiony chwilę wcześniej nie ma pola miasto, więc ten find go nie znajdzie. W MongoDB brak pola nie jest błędem, dokument po prostu nie spełnia warunku.

Aktualizacja dokumentu: db, kropka, klienci, kropka, updateOne, a w nawiasie dwa argumenty. Pierwszy to filtr: w klamrach podkreślnik id dwukropek ObjectId z identyfikatorem. Drugi to opis zmiany: w klamrach dolar set, dwukropek, i znowu klamry z wiek dwukropek dwadzieścia sześć. Operator dolar set ustawia wartość pola i zostawia pozostałe pola bez zmian. Tu jest klasyczna pułapka testowa. Metoda updateOne z operatorem dolar set zmienia wybrane pola. Metoda replaceOne zastępuje cały dokument nowym, więc pola, których nie podasz, znikną. Wszystkie te metody działają na kolekcji, czyli zawsze piszemy db, kropka, nazwa kolekcji, kropka, metoda.

Zastosowania MongoDB to aplikacje webowe i mobilne, e-commerce, systemy CMS i zarządzanie treścią, analityka i big data, gry online oraz Internet rzeczy.

Porównanie z bazami relacyjnymi. Model danych: MongoDB ma dokumenty JSON lub BSON, relacyjne mają tabele z wierszami i kolumnami. Schemat: w MongoDB elastyczny, w relacyjnych sztywny. Skalowanie: w MongoDB łatwe, w poziomie, w relacyjnych trudniejsze, zwykle w pionie. Relacje między danymi: w MongoDB wbudowane, czyli zagnieżdżone dokumenty, w relacyjnych przez klucze obce. Najlepsze zastosowania: MongoDB dla nowoczesnych, szybko zmieniających się danych, relacyjne dla danych o stałej strukturze.

Wady i ograniczenia. Pierwsza: brak transakcji ACID w starszych wersjach. Wsparcie pojawiło się od wersji cztery zero, ale z ograniczeniami. Uściślę: pojedynczy dokument zawsze był modyfikowany atomowo, a od wersji cztery zero doszły transakcje obejmujące wiele dokumentów, najpierw w zbiorach replik, a od wersji cztery dwa także w klastrach shardowanych. Druga wada: MongoDB nie jest idealna do złożonych relacji między danymi. Trzecia: większe zużycie miejsca na dysku przez elastyczny schemat. Bierze się to stąd, że każdy dokument przechowuje nazwy swoich pól, a w tabeli nazwy kolumn zapisuje się raz, w schemacie.

Podsumowanie slajdu: MongoDB to popularna baza klucz–dokument, która zapewnia elastyczność, skalowalność i wysoką wydajność. Świetnie sprawdza się w nowoczesnych aplikacjach i projektach o dynamicznie zmieniających się danych. To jedna z najczęściej wybieranych baz NoSQL na świecie. Hasło: MongoDB, elastyczne dane, większe możliwości. Przechowuj, skaluj, rozwijaj.

Do zapamiętania na test: MongoDB przechowuje dokumenty JSON i BSON z unikalnym polem podkreślnik id, zwykle typu ObjectId. Hierarchia to dokument, kolekcja, baza. Skalowanie poziome zapewnia sharding. Polecenia to db.kolekcja.insertOne, db.kolekcja.find z filtrem i db.kolekcja.updateOne z filtrem i operatorem dolar set. Transakcje wielodokumentowe ACID są od wersji cztery zero. Relacje wyraża się przez zagnieżdżanie, a nie przez klucze obce.

## Bazy rodziny kolumn

Trzecia rodzina to bazy rodziny kolumn, po angielsku column family albo wide column store, czyli bazy szerokich kolumn. Model danych ma trzy poziomy.

Rodzina kolumn odpowiada tabeli. Tabela to kolekcja podobnych wierszy, ale niekoniecznie identycznych. To ważne: wiersze mogą mieć różne kolumny.

Wiersz to kolekcja kolumn. Agreguje dane, które pobiera się wspólnie. Dostęp do wiersza zapewnia jego identyfikator, na przykład klucz partycji albo row key.

Kolumna składa się z nazwy i wartości. Dozwolone są zarówno wartości skalarne, czyli pojedyncze, jak i listy czy mapy.

Zapytania są proste: dodaj, zmień albo usuń wiersz zawierający rodzinę kolumn oraz wybierz wiersz na podstawie identyfikatora albo prostego przeszukiwania kolumn.

Slajd zawiera ważną uwagę: to nie są po prostu bazy relacyjne ze zmienną specyfikacją wiersza. Choć wyglądają podobnie, bo mają tabele, wiersze i kolumny, działają inaczej. Nie ma złączeń, dane są projektowane pod konkretne zapytania i rozkładane po wielu węzłach według klucza. Uważaj też na pomyłkę nazewniczą. Bazy szerokich kolumn, takie jak Cassandra, to co innego niż kolumnowe hurtownie analityczne, które zapisują dane kolumna po kolumnie dla szybkich agregacji. Slajdy nazywają Cassandrę bazą kolumnową, ale ściśle biorąc jest to baza szerokich kolumn.

Kiedy używać? Slajd podaje blogi i systemy CMS. Kiedy nie używać? Gdy wymagane są transakcje ze ścisłą spójnością, gdy występują złożone zapytania, takie jak agregacje typu SUM i AVG albo złączenia, oraz gdy schemat bazy może być często zmieniany. Ostatni punkt wynika z tego, że w tych bazach tabele projektuje się pod zapytania, więc zmiana sposobu odpytywania często oznacza przebudowę tabel.

Przedstawiciele to Apache Cassandra, ScyllaDB, Apache HBase, Google Bigtable oraz Azure Cosmos DB z API Cassandra.

Ranking DB-Engines dla baz szerokich kolumn z października dwa tysiące dwudziestego piątego roku pokazuje Cassandrę na górze z wynikiem około stu. Pod nią jest Apache HBase, następnie Microsoft Azure Cosmos DB. Pozostałe mają poniżej dziesięciu punktów, w tym ScyllaDB, Datastax Enterprise, Microsoft Azure Table Storage, Google Cloud Bigtable, Apache Accumulo, Amazon Keyspaces, Hypertable i inne.

Do zapamiętania na test: model rodziny kolumn to rodzina kolumn jako tabela, wiersz jako kolekcja kolumn dostępna po kluczu wiersza i kolumna jako nazwa z wartością, także listą albo mapą. Wiersze nie muszą być identyczne. Nie są to po prostu relacyjne bazy ze zmiennym wierszem. Nie nadają się do transakcji ze ścisłą spójnością, agregacji, złączeń i częstych zmian schematu. Liderem jest Cassandra, a za nią HBase.

## Apache Cassandra

Apache Cassandra to rozproszona baza danych dla systemów o wysokiej dostępności. Przechowuje dane w modelu szerokich kolumn. Dane są organizowane w tabelach, ale struktura jest bardziej elastyczna niż w bazach relacyjnych. Ramka: Cassandra jest zaprojektowana do pracy na wielu serwerach bez pojedynczego punktu awarii. Po angielsku to no single point of failure i warto znać ten zwrot.

Jak działa Cassandra? Hierarchia ma cztery poziomy: rekord, czyli wiersz, należy do tabeli, którą dawniej nazywano column family, tabela należy do keyspace, czyli przestrzeni nazw, a keyspace istnieje w klastrze Cassandry złożonym z wielu węzłów. Keyspace jest odpowiednikiem bazy danych z modelu relacyjnego i to w nim ustawia się na przykład współczynnik replikacji. Klaster składa się z wielu równorzędnych węzłów, z których każdy przechowuje część danych. Równorzędnych, czyli nie ma węzła głównego, a wszystkie mają tę samą rolę. To architektura peer-to-peer.

Przykład na slajdzie jest w języku CQL, czyli Cassandra Query Language. Składnia celowo przypomina SQL. Tworzenie tabeli: CREATE TABLE klienci, a w nawiasie kolumny: id INT PRIMARY KEY, imie TEXT, nazwisko TEXT, miasto TEXT i wiek INT. Wstawienie rekordu: INSERT INTO klienci, w nawiasie lista kolumn id, imie, nazwisko, miasto, wiek, a potem VALUES z wartościami tysiąc jeden, Jan, Kowalski, Warszawa i dwadzieścia pięć. Napisy w CQL zapisujemy w apostrofach.

Kolejne operacje ze slajdu: dodanie Anny Nowak z Krakowa, lat dwadzieścia osiem, z identyfikatorem tysiąc dwa, tym samym poleceniem INSERT INTO z VALUES. Wyszukiwanie: SELECT gwiazdka FROM klienci WHERE id równa się tysiąc dwa. Aktualizacja: UPDATE klienci SET wiek równa się dwadzieścia dziewięć WHERE id równa się tysiąc dwa. Choć wygląda to jak SQL, w Cassandrze klauzula WHERE powinna opierać się na kluczu głównym, a dokładniej na kluczu partycji. Zapytanie po zwykłej kolumnie, na przykład po mieście, bez indeksu zostanie odrzucone, chyba że dopiszemy ALLOW FILTERING, co jest kosztowne. To właśnie wynika z zasady „projektuj tabele pod zapytania”.

Najważniejsze cechy Cassandry to wysoka dostępność, czyli brak pojedynczego punktu awarii, skalowalność pozioma, czyli łatwe dodawanie serwerów do klastra, replikacja danych, czyli automatyczne kopiowanie danych między węzłami, bardzo wysoka wydajność zapisu, dostosowana do ogromnych wolumenów, oraz architektura rozproszona, w której wszystkie węzły są równorzędne, peer-to-peer. Zapamiętaj, że Cassandra słynie szczególnie z wydajności zapisu.

Zastosowania to aplikacje internetowe o dużym ruchu, systemy mobilne, Big Data i analityka, platformy społecznościowe, Internet rzeczy, gry online oraz monitoring i telemetria.

Porównanie z bazami relacyjnymi. Model danych: szerokie kolumny kontra tabele. Skalowanie: poziome kontra głównie pionowe. Dostępność: bardzo wysoka kontra zależna od konfiguracji. Spójność danych: w Cassandrze konfigurowalna, nazywana eventual, czyli ostateczna, a w relacyjnych silna, ACID. Konfigurowalna oznacza, że dla każdego zapytania można wybrać poziom spójności, na przykład ONE, QUORUM albo ALL, czyli ile replik musi potwierdzić operację. Najlepsze zastosowania: duże rozproszone systemy kontra dane transakcyjne.

Wady i ograniczenia: bardziej złożone modelowanie danych, ograniczone możliwości operacji JOIN, a w praktyce ich brak, słaba przydatność do skomplikowanych transakcji oraz konieczność zaplanowania zapytań przed utworzeniem tabel, co prowadzi do denormalizacji danych. Denormalizacja oznacza, że te same dane przechowuje się w kilku tabelach, każda pod inne zapytanie, bo nie można ich złączyć w locie.

Podsumowanie: Cassandra zapewnia wysoką dostępność i odporność na awarie, doskonale skaluje się na setki i tysiące serwerów, jest jednym z najpopularniejszych rozwiązań NoSQL dla Big Data i sprawdza się tam, gdzie priorytetem są wydajność i niezawodność. Hasło: Apache Cassandra, dane bez przestojów. Skaluj globalnie, przechowuj niezawodnie.

Do zapamiętania na test: Cassandra to baza szerokich kolumn, peer-to-peer, bez pojedynczego punktu awarii. Hierarchia to wiersz, tabela, keyspace, klaster. Językiem jest CQL podobny do SQL, z poleceniami CREATE TABLE, INSERT INTO z VALUES, SELECT z WHERE po kluczu i UPDATE z SET. Ma bardzo wysoką wydajność zapisu, spójność konfigurowalną, czyli eventual, ograniczone JOIN-y i wymaga denormalizacji. W CAP jest systemem AP.

## Bazy grafowe

Czwarta rodzina to bazy grafowe. Model danych to graf, czyli skierowana albo nieskierowana kolekcja węzłów, które reprezentują encje, oraz krawędzi, które reprezentują relacje między encjami. Zarówno węzły, jak i krawędzie mogą mieć dowolne właściwości, czyli atrybuty. To ważne: relacja nie jest tylko linią, może nieść dane, na przykład datę rozpoczęcia znajomości.

Slajd wyróżnia dwa typy baz grafowych. Transakcyjne, czyli OLTP, obsługują dużą liczbę małych lub średnich grafów. Analityczne, czyli OLAP, obsługują małą liczbę bardzo dużych grafów. Zapamiętaj to zestawienie odwrotnie proporcjonalne: OLTP to wiele małych, OLAP to mało, ale ogromnych.

Kiedy używać? Sieci społecznościowe, silniki rekomendacyjne, grafy wiedzy, czyli Knowledge Graphs, wykrywanie oszustw, systemy nawigacyjne i analiza zależności. We wszystkich tych zastosowaniach najważniejsze są powiązania między obiektami, a nie same obiekty.

Zapytania w bazach grafowych to dodaj, zmień albo usuń węzeł lub krawędź, wyszukiwanie najkrótszej ścieżki, analiza relacji i zależności, zapytania do podgrafów i nadgrafów oraz wyszukiwanie podobnych obiektów.

Kiedy nie używać? Gdy operacje dotyczą wielu węzłów albo krawędzi naraz, na przykład trzeba zaktualizować jedną właściwość we wszystkich węzłach, oraz przy bardzo dużych, złożonych grafach w dużej liczbie. Baza grafowa jest świetna w przechodzeniu od węzła do sąsiadów, ale słabsza w masowych operacjach na całym zbiorze.

Przedstawiciele to Neo4j, ArangoDB, OrientDB i JanusGraph.

Ranking DB-Engines dla baz grafowych z października dwa tysiące dwudziestego piątego roku pokazuje Neo4j na górze z wynikiem około pięćdziesięciu. Pod nim jest Microsoft Azure Cosmos DB. Pozostałe mają od około jednego do dziesięciu punktów, w tym Aerospike, ArangoDB, Virtuoso, OrientDB, NebulaGraph, GraphDB, Amazon Neptune, Memgraph, JanusGraph i TigerGraph.

Do zapamiętania na test: graf to węzły jako encje i krawędzie jako relacje, a oba elementy mogą mieć właściwości. Bazy grafowe OLTP obsługują wiele małych i średnich grafów, a OLAP mało bardzo dużych. Typowe zastosowania to sieci społecznościowe, rekomendacje, grafy wiedzy, wykrywanie oszustw i nawigacja. Typowe zapytanie to najkrótsza ścieżka. Liderem jest Neo4j.

## Neo4j

Neo4j to baza dla danych połączonych i złożonych relacji. To natywna baza grafowa, która przechowuje dane w postaci węzłów, relacji i etykiet. Natywna oznacza, że graf jest jej wewnętrznym sposobem zapisu, a nie warstwą nałożoną na tabele. Neo4j zaprojektowano do efektywnego zarządzania danymi o złożonych powiązaniach. Ramka: jest idealna do analizowania relacji i znajdowania ukrytych zależności w danych. Hasło z logo to Graph Database for Tomorrow.

Jak działa Neo4j? Węzeł, na przykład Osoba, jest połączony relacją ZNA z innym węzłem Osoba. Węzły mają etykiety i właściwości, na przykład dwukropek Osoba z właściwością name Jan w klamrach. Dane są przechowywane jako graf: węzły połączone relacjami, które mogą mieć kierunek i właściwości.

Językiem zapytań Neo4j jest Cypher. Jego składnia rysuje graf znakami ASCII: węzeł zapisujemy w nawiasach okrągłych, relację w nawiasach kwadratowych, a kierunek strzałką z myślnika i znaku większości.

Przykład ze slajdu. CREATE, w nawiasie okrągłym a dwukropek Osoba, a w klamrach imie Jan i nazwisko Kowalski. Tu a to zmienna, Osoba to etykieta, a w klamrach są właściwości. Drugie polecenie tworzy węzeł b z etykietą Osoba, z imieniem Anna i nazwiskiem Nowak. Trzecie tworzy relację: CREATE, nawias a, myślnik, nawias kwadratowy z dwukropkiem ZNA i właściwością od_kiedy dwa tysiące dwadzieścia, myślnik, znak większości, nawias b. Czyli Jan zna Annę od dwa tysiące dwudziestego roku. Te trzy polecenia trzeba uruchomić jako jedno zapytanie, bo zmienne a i b żyją tylko w obrębie zapytania.

Wyszukiwanie znajomych Jana: MATCH, nawias a dwukropek Osoba z imieniem Jan, myślnik, nawias kwadratowy dwukropek ZNA, myślnik, strzałka, nawias b, a potem RETURN b kropka imie, b kropka nazwisko, b kropka od_kiedy. Tu slajd ma błąd. Właściwość od_kiedy należy do relacji ZNA, a nie do węzła b, więc b kropka od_kiedy zwróci null. Poprawnie trzeba nazwać relację zmienną, na przykład r: nawias kwadratowy r dwukropek ZNA, i zwrócić r kropka od_kiedy. MATCH w Cypherze to odpowiednik wyszukiwania wzorca, a RETURN odpowiada SELECT z SQL.

Najważniejsze cechy Neo4j: model grafowy z węzłami, relacjami i właściwościami, wysoka wydajność zapytań dzięki szybkiemu przechodzeniu po relacjach, po angielsku traversal, skalowalność z obsługą dużych grafów, zaawansowana analiza relacji z łatwym wykrywaniem wzorców oraz bogate zastosowania, od rekomendacji po wykrywanie oszustw. Szybkie przechodzenie wynika z tego, że każdy węzeł przechowuje bezpośrednie wskaźniki do swoich relacji. Nie trzeba więc za każdym razem przeszukiwać indeksu, jak przy złączeniu w bazie relacyjnej.

Przykładowe operacje. Dodawanie: CREATE węzeł p z etykietą Produkt, nazwa Laptop, cena trzy tysiące pięćset. CREATE węzeł k z etykietą Klient, imie Anna. CREATE relacja: k, myślnik, nawias kwadratowy dwukropek KUPIL z właściwością data równą wywołaniu funkcji date z pustym nawiasem, myślnik, strzałka, p. Funkcja date zwraca bieżącą datę.

Wyszukiwanie: MATCH, nawias k dwukropek Klient, myślnik, dwukropek KUPIL w nawiasie kwadratowym, strzałka, nawias p dwukropek Produkt, potem WHERE k kropka imie równa się Anna, w apostrofach, i RETURN p kropka nazwa, p kropka cena. Zwraca produkty kupione przez Annę.

Aktualizacja: MATCH, nawias p dwukropek Produkt z nazwą Laptop w klamrach, potem SET p kropka cena równa się trzy tysiące dwieście, i RETURN p. W Cypherze, podobnie jak w SQL, właściwości zmienia się słowem SET.

Zastosowania Neo4j: systemy rekomendacji, analiza sieci społecznościowych, wykrywanie oszustw, zarządzanie danymi powiązanymi, wyszukiwanie i eksploracja relacji, zarządzanie wiedzą i dokumentacją, analityka i business intelligence oraz Internet rzeczy.

Porównanie z bazami relacyjnymi. Model danych: graf kontra tabele. Połączenia między danymi: w Neo4j naturalne i szybkie, w relacyjnych złożone, przez JOIN. Wydajność zapytań o relacje: w Neo4j bardzo wysoka, w relacyjnych zależna od złożoności, bo każdy kolejny poziom powiązań to kolejne złączenie. Skalowanie: slajd podaje poziome dla Neo4j i głównie pionowe dla relacyjnych. W praktyce Neo4j poziomo skaluje głównie odczyty, przez klastry i repliki, a dzielenie samego grafu między serwery jest trudne, bo graf trudno pociąć bez przecinania relacji. Na test trzymaj się jednak slajdu. Najlepsze zastosowania: złożone relacje i analityka kontra dane transakcyjne.

Wady i ograniczenia: Neo4j nie jest optymalna dla prostych danych tabelarycznych, ma wyższe wymagania sprzętowe przy bardzo dużych grafach, jest mniej odpowiednia do masowych transakcji niż tradycyjne bazy relacyjne i wymaga nauki języka Cypher oraz innego podejścia do modelowania.

Podsumowanie: Neo4j umożliwia efektywne zarządzanie danymi połączonymi i złożonymi relacjami, zapewnia wysoką wydajność zapytań i łatwą analizę grafu, świetnie sprawdza się w aplikacjach wykorzystujących dane powiązane i jest jednym z najpopularniejszych rozwiązań grafowych na świecie. Hasła: Neo4j, odkryj siłę połączeń. Dane zyskują wartość, gdy widać ich relacje. Connect, Discover, Build.

Do zapamiętania na test: Neo4j to natywna baza grafowa z węzłami, relacjami, etykietami i właściwościami. Językiem jest Cypher. Węzeł zapisuje się w nawiasach okrągłych, relację w kwadratowych, kierunek strzałką. CREATE tworzy, MATCH wyszukuje wzorzec, WHERE filtruje, RETURN zwraca, a SET zmienia właściwość. Właściwość relacji odczytuje się przez zmienną relacji, a nie przez węzeł.

## Bazy XML

Teraz dwie mniejsze rodziny. Pierwsza to bazy XML. Model danych opiera się na dokumentach XML. Dokument XML ma strukturę drzewa z zagnieżdżonymi elementami, atrybutami i wartościami tekstowymi. Dokumenty organizuje się w kolekcje, czyli zestawy dokumentów XML. Widać tu pokrewieństwo z bazami dokumentowymi: tam dokumentem jest zwykle JSON, tu XML.

Bazy XML mają trzy języki i to są typowe pytania testowe, bo łatwo pomylić ich role. XPath, czyli XML Path Language, służy do nawigacji, czyli do wskazywania węzłów w drzewie, na przykład ścieżką ukośnik ksiazka ukośnik tytul. XQuery, czyli XML Query Language, służy do odpytywania, czyli do pisania zapytań, które wybierają, filtrują i budują wyniki. XQuery korzysta z wyrażeń XPath. XSLT, czyli XSL Transformations, służy do transformacji, czyli do przekształcania dokumentu XML w inny dokument, na przykład w HTML. Zapamiętaj trzy słowa: XPath nawiguje, XQuery odpytuje, XSLT przekształca.

Przykładowy dokument ze slajdu: element ksiazka z atrybutem id równym jeden. W środku elementy: tytul z tekstem „Wiedza o danych”, autor Jan Kowalski, rok dwa tysiące dwadzieścia cztery i cena z atrybutem waluta równym PLN i wartością siedemdziesiąt dziewięć złotych dziewięćdziesiąt groszy. Dalej element kategorie z dwoma elementami kategoria: Database i NoSQL. Na diagramie drzewa korzeniem jest ksiazka, a jej gałęzie to tytul, autor, rok, cena i kategorie, przy czym kategorie mają dwoje dzieci. Zwróć uwagę na różnicę między atrybutem a elementem: id i waluta są atrybutami, zapisanymi wewnątrz znacznika otwierającego, a tytul i autor są elementami potomnymi.

Przedstawiciele baz XML to Sedna, czyli natywny system baz XML, MarkLogic, czyli korporacyjna baza XML, Tamino, czyli serwer XML, eXist-db, czyli otwartoźródłowa baza XML, oraz Virtuoso firmy OpenLink, czyli serwer uniwersalny z funkcjami XML.

Do zapamiętania na test: bazy XML przechowują dokumenty o strukturze drzewa z elementami, atrybutami i tekstem, zgrupowane w kolekcje. XPath służy do nawigacji, XQuery do odpytywania, a XSLT do transformacji. Przedstawiciele to Sedna, MarkLogic, Tamino, eXist-db i Virtuoso.

## Bazy RDF

Druga mniejsza rodzina to bazy RDF. RDF to Resource Description Framework, standard opisu zasobów używany w sieci semantycznej. Model danych to trójki RDF. Każda trójka składa się z trzech części, które slajd nazywa temat, predykat i obiekt. Po angielsku to subject, predicate, object, a po polsku częściej mówi się podmiot, predykat i obiekt. Słowo temat na slajdzie oznacza właśnie podmiot. Każda trójka reprezentuje zdanie twierdzące, czyli stwierdzenie dotyczące bytu ze świata rzeczywistego. Przykład: podmiot Jan, predykat zna, obiekt Anna. Albo: podmiot książka, predykat ma autora, obiekt Jan Kowalski.

Trójki można porównać do grafów. Wierzchołkami są tematy, czyli podmioty, oraz obiekty. Krawędziami są poszczególne stwierdzenia, a dokładniej predykaty łączące podmiot z obiektem. Bazy RDF są więc bliskimi krewnymi baz grafowych. Bazy RDF nazywa się też triple store, czyli magazynami trójek.

Językiem zapytań jest SPARQL. Nazwa jest akronimem rekurencyjnym: SPARQL Protocol and RDF Query Language. Rekurencyjnym, bo pierwsza litera skrótu oznacza sam skrót. Wymawia się go jak angielskie słowo sparkle.

Przedstawiciele to Apache Jena i rdf4j.

Do zapamiętania na test: RDF opiera się na trójkach podmiot, predykat, obiekt, które slajd nazywa temat, predykat, obiekt. Trójki tworzą graf, w którym wierzchołki to podmioty i obiekty, a krawędzie to stwierdzenia. Językiem zapytań jest SPARQL. Przedstawiciele to Apache Jena i rdf4j. Uważaj, by nie pomylić SPARQL z Cypherem, który służy do Neo4j, ani z XQuery, który służy do XML.

## Ranking DB-Engines

DB-Engines to serwis pod adresem db-engines kropka com, który publikuje ranking systemów zarządzania bazami danych według ich popularności. Ranking jest aktualizowany co miesiąc. Popularność, a nie wydajność czy jakość, jest tu kluczowym słowem. Wynik liczy się z sygnałów takich jak liczba wzmianek w wyszukiwarkach, oferty pracy, pytania na forach technicznych i profile zawodowe. Na slajdzie, w październiku dwa tysiące dwudziestego piątego roku, ranking obejmował czterysta dwadzieścia pięć systemów.

Pierwsza szesnastka z października dwa tysiące dwudziestego piątego roku wygląda tak. Pierwszy jest Oracle, model relacyjny i wielomodelowy, z wynikiem tysiąc dwieście dwanaście przecinek siedemdziesiąt siedem. Drugi MySQL, osiemset siedemdziesiąt dziewięć przecinek sześćdziesiąt sześć. Trzeci Microsoft SQL Server, siedemset piętnaście. Czwarty PostgreSQL, sześćset czterdzieści trzy. Piąty MongoDB, model dokumentowy i wielomodelowy, trzysta sześćdziesiąt osiem przecinek zero jeden. To najwyżej sklasyfikowana baza NoSQL. Szósty Snowflake, relacyjny, sto dziewięćdziesiąt osiem i pół, który awansował z siódmego miejsca rok wcześniej. Siódmy Redis, model klucz–wartość i wielomodelowy, sto czterdzieści dwa, który spadł z szóstego miejsca. Ósmy Databricks, wielomodelowy, który awansował aż z czternastego miejsca. Dziewiąty IBM Db2. Dziesiąty Elasticsearch, wielomodelowy. Jedenasty Apache Cassandra, szerokie kolumny i wielomodelowy, z wynikiem około stu pięciu. Dwunasty SQLite. Trzynasty MariaDB. Czternasty Microsoft Access. Piętnasty Amazon DynamoDB, wielomodelowy. Szesnasty Microsoft Azure SQL Database.

Na slajdzie niebieskimi ramkami wyróżniono trzy bazy NoSQL: MongoDB na piątym miejscu, Redisa na siódmym i Cassandrę na jedenastym. Wniosek: pierwsza czwórka to bazy relacyjne, a najpopularniejsza baza NoSQL, MongoDB, jest piąta. Warto też zauważyć, że prawie wszystkie wielkie bazy relacyjne mają dopisek multi-model, bo obsługują dziś także JSON, dane przestrzenne czy grafy.

Drugi slajd pokazuje ranking samych baz grafowych, czterdzieści trzy systemy w październiku dwa tysiące dwudziestego piątego roku. Ten ranking ma opcję, by uwzględniać drugorzędne modele baz, i dlatego pojawiają się na nim bazy wielomodelowe. Pierwszy jest Neo4j, czysto grafowy, z wynikiem pięćdziesiąt dwa przecinek pięćdziesiąt jeden. Drugi Microsoft Azure Cosmos DB, wielomodelowy, dwadzieścia dwa przecinek siedemdziesiąt jeden. Trzeci Aerospike, cztery i pół. Dalej ArangoDB, Virtuoso, OrientDB, NebulaGraph, GraphDB, Amazon Neptune i Memgraph. Przewaga Neo4j jest ogromna, ponad dwukrotna względem drugiego miejsca.

Przypomnijmy przy okazji liderów rankingów z wcześniejszych slajdów, bo ich wykresy mają skalę logarytmiczną i stan na październik dwa tysiące dwudziestego piątego roku. W bazach klucz–wartość prowadzi Redis, przed DynamoDB. W dokumentowych MongoDB, przed Databricks i DynamoDB. W szerokich kolumnach Cassandra, przed HBase. W grafowych Neo4j, przed Cosmos DB.

Do zapamiętania na test: DB-Engines klasyfikuje bazy według popularności i aktualizuje ranking co miesiąc. W październiku dwa tysiące dwudziestego piątego roku prowadzą Oracle, MySQL, SQL Server i PostgreSQL. MongoDB jest piąta i jest najpopularniejszą bazą NoSQL. Redis jest siódmy, Cassandra jedenasta. Wśród baz grafowych prowadzi Neo4j przed Azure Cosmos DB.

## BASE i ACID

Przechodzimy do teorii, którą bardzo lubią testy. Pierwsze pojęcie to BASE. Slajd zaczyna od ważnego zastrzeżenia: w dostępnych źródłach nie ma jednej uznanej definicji BASE, a wielu autorów definiuje ten termin dość swobodnie. BASE to akronim złożony z trzech określeń.

Basically Available, po polsku zasadnicza dostępność. System nie gwarantuje zawsze pełnej dostępności, ale zazwyczaj pozostaje dostępny i zdolny do obsługi żądań. Nawet gdy część węzłów nie działa, reszta odpowiada.

Soft state, po polsku miękki stan. Stan systemu może się zmieniać w czasie, nawet bez wprowadzania zmian w danych. Jak to możliwe? Bo w tle trwa synchronizacja replik. Nikt nic nie zapisuje, a mimo to odpowiedź jednego z węzłów zmienia się, gdy dotrze do niego wcześniejsza zmiana.

Eventually consistent, po polsku ostateczna spójność. System po pewnym czasie stanie się spójny, na przykład dwa węzły po pewnym czasie się zsynchronizują, i nastąpi to nawet wtedy, gdy żadne dane nie są wprowadzane, zmieniane ani kasowane. Dane mogą stać się niespójne na przykład przy czasowej niedostępności jednego z węzłów. Kiedy węzeł wróci, zostanie dogoniony.

Co zastępuje BASE w bazie relacyjnej? W klasycznych systemach SQL zamiast BASE stosuje się model ACID, który zapewnia silniejsze gwarancje spójności i transakcyjności. Rozwińmy ACID, bo pytanie o to jest prawie pewne. A to Atomicity, atomowość: transakcja wykonuje się w całości albo wcale. C to Consistency, spójność: transakcja przeprowadza bazę z jednego poprawnego stanu w inny poprawny stan, zgodny z regułami integralności. I to Isolation, izolacja: równoległe transakcje nie widzą swoich niezatwierdzonych zmian i nie przeszkadzają sobie. D to Durability, trwałość: zatwierdzona transakcja przetrwa awarię.

Nazwy są dobrane celowo, jak w chemii: ACID to kwas, a BASE to zasada, czyli przeciwieństwo kwasu. ACID jest pesymistyczny i rygorystyczny, a BASE optymistyczny i elastyczny. Uwaga na pułapkę: litera C w ACID i litera C w CAP to dwie różne spójności. W ACID chodzi o zachowanie reguł integralności, a w CAP o to, że wszystkie węzły widzą te same, najnowsze dane.

Do zapamiętania na test: BASE to Basically Available, Soft state i Eventually consistent. Nie ma jednej uznanej definicji BASE. Miękki stan oznacza, że stan może się zmieniać bez nowych zapisów. Ostateczna spójność oznacza, że węzły w końcu się zsynchronizują. W bazach relacyjnych zamiast BASE stosuje się ACID: Atomicity, Consistency, Isolation, Durability.

## Twierdzenie CAP

Twierdzenie CAP mówi, że w rozproszonym systemie danych nie można jednocześnie zapewnić wszystkich trzech właściwości: spójności, dostępności i tolerancji na podział sieci. Twierdzenie sformułował Eric Brewer około dwutysięcznego roku, dlatego nazywa się je też twierdzeniem Brewera. Tego nazwiska nie ma na slajdach, ale bywa w pytaniach.

Omówmy trzy litery. C to Consistency, spójność. Po zapisaniu danych każdy odczyt zwraca najnowsze, spójne dane. Diagram mówi: wszyscy klienci widzą te same, aktualne dane.

A to Availability, dostępność. Każde żądanie otrzymuje odpowiedź w rozsądnym czasie, niezależnie od awarii części węzłów.

P to Partition tolerance, tolerancja na podział sieci. System nadal działa, nawet jeśli sieć jest podzielona i węzły nie mogą się ze sobą komunikować.

Diagram Venna pokazuje trzy koła i ich przecięcia. Przecięcie C i A to CA, bez P. Przecięcie C i P to CP, bez A. Przecięcie A i P to AP, bez C. Środka, czyli wszystkich trzech naraz, osiągnąć się nie da.

Możliwe kombinacje i przykłady ze slajdu. CA, czyli spójność i dostępność bez tolerancji na podział sieci: tradycyjna, pojedyncza baza relacyjna. CP, czyli spójność i tolerancja na podział, bez pełnej dostępności: niektóre systemy rozproszone, na przykład HBase i MongoDB w trybie CP. AP, czyli dostępność i tolerancja na podział, bez pełnej spójności: systemy typu Dynamo, Cassandra i niektóre konfiguracje NoSQL.

Wniosek slajdu: w rozproszonym systemie można jednocześnie zapewnić tylko dwie z trzech właściwości CAP, więc w praktyce trzeba wybrać kompromis dopasowany do wymagań.

Dodam ważne wyjaśnienie, które pomaga zrozumieć, a nie tylko zapamiętać. W prawdziwym systemie rozproszonym podziały sieci po prostu się zdarzają, więc z P zrezygnować nie można. Realny wybór pojawia się w chwili awarii sieci: albo system odmówi części odpowiedzi, żeby nie zwrócić nieaktualnych danych, i wtedy jest CP, albo będzie odpowiadał zawsze, nawet ryzykując nieaktualne dane, i wtedy jest AP. Kombinacja CA ma sens tylko wtedy, gdy system nie jest rozproszony, na przykład pojedynczy serwer bazy relacyjnej. Dlatego przykładem CA jest właśnie pojedyncza, tradycyjna baza relacyjna.

Trójkąt CAP to ta sama idea narysowana jako trójkąt. Wierzchołkami są A, C i P, a w środku napis: możesz wybrać tylko dwa z trzech. Systemy leżą na bokach trójkąta, czyli między dwoma wierzchołkami.

Tradycyjne bazy relacyjne, takie jak MySQL i PostgreSQL, leżą na boku CA. Kładą nacisk na spójność i dostępność, ale skalują się przede wszystkim pionowo. Na boku CA są też systemy działające w jednej lokalizacji, bez rozproszenia.

Pozostałe boki obsadzają głównie bazy NoSQL. Cassandra to przykład bazy AP. Jest nastawiona na skalowanie poziome z równoczesną odpornością na awarie i wysoką dostępnością, ale nie mamy gwarancji, że odczytujemy najbardziej aktualne dane. Inne przykłady AP z trójkąta to DynamoDB, Riak i CouchDB.

MongoDB można zaklasyfikować jako CP. Pozwala na rozproszenie z zachowaniem integralności danych, ale w razie awarii węzła trzeba liczyć się z brakiem dostępu do części danych. Wyjaśnienie mechanizmu: w MongoDB zapisy przyjmuje tylko węzeł główny, czyli primary, zbioru replik. Gdy padnie, przez chwilę trwa wybór nowego węzła głównego i w tym czasie zapisy nie są możliwe. Inne przykłady CP z trójkąta to HBase, BigTable i ZooKeeper.

To jest miejsce na typowe pytania. Cassandra: AP. MongoDB: CP. HBase: CP. DynamoDB, Riak, CouchDB: AP. ZooKeeper i BigTable: CP. MySQL i PostgreSQL w pojedynczej instancji: CA. Zapamiętaj też, że te przypisania są uproszczeniem, bo wiele baz da się skonfigurować inaczej. Cassandra z poziomem spójności ALL zachowuje się bardziej jak CP, a slajd sam mówi o MongoDB „w trybie CP”.

Do zapamiętania na test: CAP to Consistency, Availability i Partition tolerance. W systemie rozproszonym można mieć jednocześnie tylko dwie z trzech. CA to pojedyncza baza relacyjna, na przykład MySQL i PostgreSQL, skalowana pionowo. CP to HBase, MongoDB, BigTable i ZooKeeper, gdzie przy awarii część danych bywa niedostępna. AP to Cassandra, DynamoDB, Riak i CouchDB, gdzie można odczytać nieaktualne dane.

## Map-Reduce

Map-Reduce to model programowania i przetwarzania dużych zbiorów danych w sposób rozproszony i równoległy, stosowany na przykład w systemach takich jak Hadoop. Spopularyzował go Google, który opisał go w publikacji z dwa tysiące czwartego roku, a Apache Hadoop dostarczył otwartą implementację.

Przetwarzanie ma cztery etapy.

Pierwszy to podział danych. Duży zbiór dzieli się na mniejsze części, na przykład bloki plików. Każdą część przetwarza się niezależnie na innym węźle klastra. Ponieważ części są niezależne, można je liczyć równolegle.

Drugi to map, czyli przekształcenie. Funkcja map dla każdego rekordu wejściowego generuje pary klucz, wartość. W przykładzie z każdego słowa tworzymy parę: słowo i jedynka.

Trzeci to shuffle i sort, czyli grupowanie. System automatycznie grupuje wszystkie wartości o tym samym kluczu, czyli o tym samym słowie. Dane są przesyłane między węzłami, to jest właśnie shuffle, czyli tasowanie, i sortowane. Zwróć uwagę, że tego etapu nie programujemy sami, wykonuje go framework.

Czwarty to reduce, czyli agregacja. Funkcja reduce dla każdego klucza agreguje listę wartości. W przykładzie sumujemy liczbę wystąpień słowa.

Przykład ze slajdu to klasyczne liczenie słów, po angielsku word count. Mamy trzy pliki. Plik pierwszy zawiera słowa kot, pies, kot. Plik drugi pies, ptak, kot. Plik trzeci pies, kot, ptak. Faza map daje z pierwszego pliku pary kot jeden, pies jeden, kot jeden. Z drugiego pies jeden, ptak jeden, kot jeden. Z trzeciego pies jeden, kot jeden, ptak jeden.

Teraz uwaga, bo slajd zawiera błąd rachunkowy. Na slajdzie faza reduce daje kot z listą trzech jedynek, czyli kot trzy, pies trzy i ptak dwa. Policzmy jednak sami. Słowo kot występuje dwa razy w pierwszym pliku, raz w drugim i raz w trzecim, czyli cztery razy. Po shuffle kot powinien mieć listę czterech jedynek i wynik cztery. Pies występuje raz w każdym pliku, czyli trzy razy, i to się zgadza. Ptak występuje w drugim i trzecim pliku, czyli dwa razy, i to też się zgadza. Poprawny wynik to więc kot cztery, pies trzy i ptak dwa. Na slajdzie było kot trzy. Jeżeli na teście pojawi się pytanie o ten przykład, policz słowa z danych wejściowych. Jeżeli jednak pytanie wyraźnie odwołuje się do wyniku pokazanego na slajdzie, pamiętaj, że slajd podaje trzy.

Zastosowania Map-Reduce to przetwarzanie logów, analiza danych, indeksowanie wyszukiwarek i przetwarzanie danych w systemach big data. Przykładem implementacji jest Apache Hadoop, a dokładniej jego moduł MapReduce. Przypomnij sobie, że Hadoop ma też rozproszony system plików HDFS, o którym była mowa na początku rozdziału.

Pułapka testowa: kolejność faz to map, potem shuffle i sort, potem reduce. Map tworzy pary klucz i wartość, reduce agreguje wartości dla klucza. Nie odwrotnie. Warto też wiedzieć, że MongoDB miało kiedyś polecenie mapReduce, ale dziś jest ono przestarzałe, a zamiast niego używa się potoku agregacji, czyli metody aggregate.

Do zapamiętania na test: Map-Reduce to model rozproszonego i równoległego przetwarzania. Etapy to podział danych, map, shuffle i sort oraz reduce. Map generuje pary klucz, wartość, shuffle grupuje wartości po kluczu i przesyła je między węzłami, a reduce agreguje listę wartości dla klucza. W przykładzie z liczeniem słów poprawny wynik to kot cztery, pies trzy, ptak dwa, choć slajd podaje kot trzy. Implementacją jest Apache Hadoop.

## Podsumowanie: czy to koniec baz relacyjnych?

Ostatni slajd tego działu zadaje pytanie: czy to koniec baz relacyjnych? Odpowiedź jest podkreślona: zdecydowanie nie.

Bazy relacyjne w dalszym ciągu są bardzo dobrym wyborem do wielu projektów i zastosowań. Mają bardzo dobre dokumentacje, wsparcie, społeczność ekspertów i są ogólnie świetnie znane. Mają też dużo dodatkowych funkcji i mechanizmów, na przykład do analizy danych. Ranking DB-Engines to potwierdza, bo pierwsze cztery miejsca zajmują bazy relacyjne.

Trzeba jednak brać pod uwagę obecność innych systemów bazodanowych. Najsensowniejsze podejście to wykorzystanie różnych systemów i silników bazodanowych w zależności od wymogów i zastosowania. To podejście ma nazwę polyglot persistence, czyli trwałość wielojęzyczna. W jednym systemie sklepu internetowego koszyk i sesje mogą siedzieć w Redisie, katalog produktów w MongoDB, rekomendacje w Neo4j, a zamówienia i płatności w bazie relacyjnej z transakcjami ACID.

To spina cały rozdział. Big Data, czyli cztery V, postawiło przed bazami nowe wymagania. Bazy relacyjne mają mocne strony, ale słabo skalują się poziomo i źle pasują do danych bez stałej struktury. NoSQL to ruch, a nie jedna technologia, i dzieli się na rodziny: klucz–wartość, dokumentowe, szerokich kolumn i grafowe, a obok nich są bazy XML i RDF. Bazy NoSQL zwykle wybierają model BASE zamiast ACID, a twierdzenie CAP wyjaśnia, dlaczego w systemie rozproszonym trzeba wybierać między spójnością a dostępnością. Map-Reduce pokazuje, jak przetwarzać takie dane równolegle.

Do zapamiętania na test: to nie jest koniec baz relacyjnych. Nadal są bardzo dobrym wyborem, mają świetną dokumentację, wsparcie i społeczność. Najsensowniejsze jest łączenie różnych systemów bazodanowych zależnie od wymagań i zastosowania.


# 2. MongoDB — instalacja, cechy i modelowanie danych

Witaj w drugim dziale. W pierwszej części wykładu poznałeś ogólne pojęcia świata NoSQL. Teraz przechodzimy do konkretnego produktu, na którym oparte są wszystkie laboratoria, czyli do MongoDB. Ten dział ma trzy wyraźne części. Najpierw instalacja i uruchomienie: skąd pobrać serwer, czym jest plik msi, czym różni się serwer mongod od klienta mongosh, jak wygląda graficzne narzędzie Compass, jak podłączyć się z Visual Studio Code i jak postawić MongoDB jednym poleceniem w Dockerze. Potem cechy MongoDB: zalety i ograniczenia baz NoSQL, właściwości samego produktu, kiedy warto go używać, skalowanie poziome i pionowe, struktura danych, podstawowe operacje, indeksy i agregacje w zarysie. Na końcu najważniejsza z punktu widzenia testu część, czyli modelowanie danych: osadzanie dokumentów kontra referencje, BSON kontra JSON, typy danych, BinData kontra GridFS, klucze główne i ObjectId, model zdenormalizowany i znormalizowany, relacje jeden do jednego, jeden do wielu i wiele do wielu, antywzorce projektowe, sterowniki, język zapytań oraz porównanie pojęć i poleceń SQL z ich odpowiednikami w MongoDB. Słuchaj uważnie składni, bo test pyta również o nią.

## Instalacja MongoDB Community Server

Pierwsze slajdy tego działu to zrzuty ekranu pokazujące krok po kroku, jak zainstalować MongoDB na Windowsie. Zaczynamy od wyszukiwarki. Prowadzący wpisuje w Google frazę „mongodb community download” i pierwszym wynikiem jest strona mongodb.com, sekcja try, z tytułem „MongoDB Community Server Download”. Słowo Community jest tu ważne. MongoDB występuje w kilku odmianach. Community Edition, czyli edycja społecznościowa, to darmowa wersja serwera, którą instalujesz samodzielnie na własnym komputerze. Obok niej istnieje MongoDB Enterprise Advanced, czyli płatna wersja komercyjna z dodatkowymi funkcjami bezpieczeństwa i wsparciem, oraz MongoDB Atlas, czyli baza w chmurze jako usługa, zarządzana przez firmę MongoDB. Te trzy nazwy widać w bocznym menu strony pobierania i warto je umieć rozróżnić.

Kolejny slajd pokazuje dokumentację MongoDB, sekcję Database Manual w wersji osiem przecinek dwa, oznaczonej jako bieżąca. W menu bocznym dokumentacji widać główne obszary tematyczne, które przewiną się przez cały kurs: dokumenty, bazy danych i kolekcje, biblioteki klienckie, czyli sterowniki, łączenie z klastrami, użytkownicy bazy, operacje CRUD, indeksy, modelowanie danych, operacje agregacji, wyszukiwanie, wyszukiwanie wektorowe, integracje z AI i szeregi czasowe, po angielsku Time Series. Na stronie „Install MongoDB Community Edition” wybiera się system operacyjny i metodę instalacji. Na zrzucie wybrano Windows i metodę Zip File, czyli instalację przez pobranie i rozpakowanie archiwum zip. Dokumentacja informuje, że ten samouczek instaluje MongoDB w wersji osiem przecinek dwa Community Edition, a inną wersję można wybrać z listy rozwijanej.

Następnie widzimy stronę pobierania MongoDB Community Server. Formularz ma trzy pola: Version, czyli wersja, tu osiem przecinek dwa przecinek jeden, oznaczona jako current; Platform, czyli platforma, tu Windows x64; oraz Package, czyli rodzaj paczki, tu msi. Pod spodem są przyciski Download, Copy link i More Options. Plik msi to standardowy instalator Windows, Microsoft Installer, który prowadzi cię przez kreator z przyciskami Next i Back. Alternatywą jest paczka zip, którą po prostu rozpakowujesz w wybranym katalogu. Na późniejszym slajdzie, czterdziestym ósmym, prowadzący pokazuje ten sam formularz, ale z wybraną paczką zip. Obie drogi prowadzą do tych samych programów, różnią się tylko wygodą i tym, czy MongoDB zostanie zarejestrowane w systemie jako usługa.

Slajd czterdziesty piąty pokazuje sam instalator msi. Pierwsze okno to „Welcome to the MongoDB 8.2.1 2008R2Plus SSL (64 bit) Setup Wizard”, czyli powitanie kreatora. Oznaczenie 2008R2Plus mówi, że paczka jest przeznaczona dla Windowsa od wersji Server 2008 R2 w górę, a SSL, że serwer obsługuje szyfrowane połączenia. Ciekawsze jest drugie okno, Service Configuration, czyli konfiguracja usługi. Jest tam pole wyboru „Install MongoD as a Service”, czyli zainstaluj mongod jako usługę Windows. Jeśli je zaznaczysz, serwer będzie startował automatycznie razem z systemem i działał w tle. Możesz wtedy wybrać, czy usługa ma działać jako użytkownik Network Service, czy jako konto lokalne lub domenowe, a domyślna nazwa usługi to MongoDB. Instalator proponuje też katalog danych, Data Directory, czyli C, dwukropek, backslash Program Files, backslash MongoDB, backslash Server, backslash osiem przecinek dwa, backslash data, oraz katalog logów, Log Directory, czyli analogiczna ścieżka zakończona na log. Na zrzucie prowadzącego pole „Install MongoD as a Service” jest odznaczone, więc pozostałe opcje są wyszarzone. To znaczy, że prowadzący woli uruchamiać serwer ręcznie, z konsoli. Taka konfiguracja jest wygodna na zajęciach, bo serwer nie zajmuje zasobów, kiedy go nie potrzebujesz, ale wymaga pamiętania o uruchomieniu go przed pracą.

Do zapamiętania na test: MongoDB Community Server to darmowa edycja do samodzielnej instalacji, Enterprise Advanced to wersja komercyjna, a Atlas to usługa w chmurze. Serwer pobiera się ze strony mongodb.com, wybierając wersję, platformę i paczkę, czyli msi albo zip. Instalator msi pozwala zainstalować mongod jako usługę Windows z domyślną nazwą MongoDB i z osobnym katalogiem danych oraz logów.

## MongoDB Shell, czyli mongosh

Sam serwer to za mało, bo potrzebujesz programu, który się z nim połączy i wyśle polecenia. Slajd czterdziesty szósty pokazuje stronę pobierania MongoDB Shell. Opis z tej strony mówi, że MongoDB Shell to najszybszy sposób, żeby połączyć się z MongoDB i z nim pracować: łatwo odpytywać dane, konfigurować ustawienia i wykonywać inne działania w nowoczesnym, rozszerzalnym interfejsie wiersza poleceń, z kolorowaniem składni, inteligentnym podpowiadaniem, czyli autocomplete, pomocą kontekstową i komunikatami błędów. Ważna uwaga z tego slajdu: MongoDB Shell jest produktem open source na licencji Apache dwa zero i jest samodzielnym produktem, rozwijanym osobno od serwera MongoDB. Dlatego ma własną numerację wersji. Na slajdzie jest to wersja dwa przecinek pięć przecinek osiem, platforma Windows x64 w wersji dziesięć lub nowszej, paczka zip. Jest też notka o zgodności: wsparcie dla Red Hat Enterprise Linux siedem, Amazon Linux dwa, SUSE Linux Enterprise Server dwanaście i Ubuntu osiemnaście zero cztery jest przestarzałe, po angielsku deprecated, i może zostać usunięte w kolejnych wydaniach mongosh.

Uwaga na pułapkę nazewniczą. Dawniej powłoka MongoDB nazywała się po prostu mongo i była dołączana do serwera. Nowa powłoka nazywa się mongosh, od MongoDB Shell, i to ona jest dziś standardem. Jeśli w pytaniu testowym widzisz polecenie mongo, chodzi o starą powłokę, a mongosh to nowa. Sama nazwa mongod, z literą d na końcu, oznacza natomiast demona, czyli proces serwera.

W bocznym menu strony z narzędziami widać też inne programy z rodziny MongoDB, które warto znać przynajmniej z nazwy: MongoDB Compass, czyli graficzny klient GUI, Atlas CLI, Atlas Kubernetes Operator, MongoDB CLI for Cloud Manager and Ops Manager, MongoDB Cluster-to-Cluster Sync do synchronizacji klastrów, MongoDB Relational Migrator do migracji z baz relacyjnych, MongoDB Database Tools, czyli narzędzia takie jak mongodump, mongorestore, mongoimport i mongoexport, MongoDB Connector for BI do podłączenia narzędzi analitycznych, App Services CLI oraz MongoDB for VS Code.

Do zapamiętania na test: mongosh to nowoczesna powłoka wiersza poleceń MongoDB, open source na licencji Apache dwa zero, rozwijana osobno od serwera, z kolorowaniem składni i autouzupełnianiem. Stara powłoka nazywała się mongo. Proces serwera nazywa się mongod.

## MongoDB Compass

Slajd czterdziesty siódmy pokazuje MongoDB Compass, czyli oficjalne graficzne narzędzie do pracy z MongoDB. Na zrzucie widać ekran powitalny „Welcome to MongoDB Compass” i komunikat „Connected to localhost:27017”, czyli połączono z lokalnym serwerem na porcie dwadzieścia siedem tysięcy siedemnaście. To jest domyślny port MongoDB i warto go zapamiętać na pamięć: dwa, siedem, zero, jeden, siedem. Po lewej stronie widać listę połączeń, a po rozwinięciu połączenia z localhost trzy bazy systemowe: admin, config i local. Te trzy bazy istnieją w każdej instalacji. Baza admin przechowuje między innymi użytkowników i role, baza config jest używana przy shardingu, a baza local przechowuje dane lokalne dla danego węzła, na przykład dziennik operacji przy replikacji. Domyślnie po starcie mongosh pracujesz w bazie test, co zobaczysz za chwilę po znaku zachęty.

W rogu slajdu widać eksplorator plików z katalogiem C, dwukropek, backslash data. Prowadzący trzyma tam wszystkie pobrane składniki: folder db, rozpakowane MongoDB Database Tools, rozpakowany serwer w wersji osiem przecinek dwa przecinek jeden, rozpakowany mongosh w wersji dwa przecinek pięć przecinek osiem oraz instalator Compassa w wersji jeden przecinek czterdzieści siedem przecinek zero, a także oryginalne archiwa zip. To praktyczny wzorzec: trzymać wszystko w jednym katalogu i uruchamiać programy z ich podkatalogów bin.

Do zapamiętania na test: Compass to oficjalny graficzny klient MongoDB. Domyślny port serwera to dwadzieścia siedem tysięcy siedemnaście. Każda instalacja ma bazy systemowe admin, config i local, a mongosh po starcie wybiera bazę test.

## Konfiguracja i uruchamianie: mongod i mongosh

Slajd czterdziesty dziewiąty to kolaż, który zbiera najważniejszą wiedzę praktyczną. Pierwszy element to mała tabelka: Database Server to mongod, Database Client to mongosh. To jest absolutna podstawa. Mongod to serwer, który przechowuje dane i nasłuchuje połączeń. Mongosh to klient, który się z nim łączy. Aby pracować, musisz najpierw uruchomić serwer, a dopiero potem klienta. Często na teście pojawia się pytanie, który program jest serwerem, i odpowiedzią jest zawsze mongod. Istnieje też trzeci program, mongos, z literą s na końcu, który widać w katalogu bin na tym samym slajdzie. Mongos to router zapytań używany w klastrze shardowanym, czyli pośrednik, który kieruje zapytania do odpowiednich shardów. Nie myl mongos z mongosh: mongos to router, mongosh to powłoka.

Drugi element kolażu to katalog C, dwukropek, backslash data, backslash db, wyróżniony strzałką. To domyślny katalog danych serwera mongod na Windowsie. Jeśli uruchamiasz mongod bez parametru dbpath, serwer szuka właśnie katalogu backslash data, backslash db na bieżącym dysku i jeśli go nie ma, nie wystartuje. Dlatego przed pierwszym uruchomieniem z paczki zip trzeba ten folder utworzyć ręcznie, albo podać inny katalog przełącznikiem minus minus dbpath.

Trzeci element to katalog bin starszej wersji serwera, sześć przecinek zero przecinek siedem, z plikami mongod.exe, opisanym jako MongoDB Database Server, firma MongoDB Inc, rozmiar około pięćdziesięciu czterech megabajtów, a także mongos.exe i skryptem Install-Compass.ps1. Czwarty element to konsola uruchomionego mongod. Serwer wypisuje logi w formacie JSON, a wśród nich kluczowy komunikat „Waiting for connections” na porcie dwadzieścia siedem tysięcy siedemnaście. To znak, że serwer działa i czeka na klientów. Piąty element to konsola mongosh, która łączy się pod adres mongodb, dwukropek, ukośnik, ukośnik, sto dwadzieścia siedem kropka zero kropka zero kropka jeden, dwukropek, dwadzieścia siedem zero siedemnaście, z parametrami directConnection równe true i serverSelectionTimeoutMS równe dwa tysiące. Powłoka wypisuje, jakiej wersji serwera używa, tu sześć przecinek zero przecinek siedem, i jakiej wersji mongosh, tu jeden przecinek dziesięć przecinek jeden, po czym pokazuje znak zachęty test, czyli nazwę bieżącej bazy i znak większości.

Do zapamiętania na test: mongod to serwer, mongosh to klient, a mongos to router w klastrze shardowanym. Domyślny katalog danych na Windowsie to backslash data, backslash db, który przy instalacji z zip trzeba utworzyć samemu. Komunikat „Waiting for connections” oznacza, że serwer nasłuchuje, domyślnie na porcie dwadzieścia siedem tysięcy siedemnaście.

## MongoDB w Visual Studio Code

Slajd pięćdziesiąty pokazuje dwa rozszerzenia do Visual Studio Code. Pierwsze to oficjalne rozszerzenie „MongoDB for VS Code” wydawcy MongoDB, z ponad dwoma i pół milionem pobrań i oceną cztery i pół gwiazdki. Jego opis brzmi: łącz się z MongoDB i Atlasem bezpośrednio ze środowiska VS Code i nawiguj po danych. Drugie to rozszerzenie json autorstwa ZainChen, z ponad trzema i pół milionem pobrań, które poprawia pracę z plikami JSON. Rozszerzenie MongoDB pozwala pisać tak zwane playgroundy, czyli pliki z kodem mongosh, które wykonujesz w edytorze. Zwróć uwagę, że w przykładach z dalszych slajdów pojawia się polecenie use, a w nawiasie i apostrofach nazwa bazy, na przykład use, nawias, apostrof DB1 apostrof, nawias, średnik. To właśnie składnia z playgroundu VS Code, gdzie use wywołuje się jak funkcję. W samym mongosh pisze się zwykle use DB1 bez nawiasów.

Slajd pięćdziesiąty pierwszy pokazuje okno New Connection, czyli nowe połączenie. Najważniejsze pole to URI, czyli connection string: mongodb, dwukropek, ukośnik, ukośnik, localhost, dwukropek, dwadzieścia siedem zero siedemnaście, ukośnik. Okno pozwala wybrać schemat connection stringa: zwykły mongodb albo mongodb plus srv. Schemat mongodb to standardowy format, którym łączysz się z dowolnym wdrożeniem: pojedynczym serwerem, czyli standalone, zestawem replik, czyli replica set, albo klastrem shardowanym. Schemat mongodb plus srv używa rekordu DNS SRV, żeby automatycznie odczytać listę serwerów klastra, i jest typowy dla Atlasa. Jest też opcja Direct Connection, która wymusza wysyłanie wszystkich operacji wyłącznie do wskazanego hosta, zamiast odkrywania reszty zestawu replik. Pod spodem widzimy przykładowy pełny connection string: mongodb, dwukropek, ukośnik, ukośnik, localhost, dwukropek, dwadzieścia siedem zero siedemnaście, ukośnik, znak zapytania, readPreference równe primary, ampersand, ssl równe false. Parametr readPreference równe primary oznacza, że odczyty idą do węzła głównego, a ssl równe false, że połączenie nie jest szyfrowane.

Slajd pięćdziesiąty drugi pokazuje efekt. W panelu MONGODB w VS Code widać połączenie localhost dwadzieścia siedem zero siedemnaście ze statusem connected i bazami admin, config, customers i local. Customers to baza utworzona przez prowadzącego. W terminalu VS Code uruchomiono mongosh.exe i widać dwa ostrzeżenia startowe serwera, które warto rozumieć. Pierwsze: „Access control is not enabled for the database”, czyli kontrola dostępu nie jest włączona, więc odczyt i zapis danych oraz konfiguracji są nieograniczone. Domyślnie MongoDB nie wymaga logowania, co jest wygodne na zajęciach, ale niebezpieczne na produkcji. Drugie: „This server is bound to localhost”, czyli serwer jest przywiązany do localhosta i zdalne systemy nie mogą się z nim połączyć. Aby wskazać, z jakich adresów serwer ma przyjmować połączenia, uruchamia się go z opcją minus minus bind underscore ip i adresem, a żeby nasłuchiwał na wszystkich interfejsach, z opcją minus minus bind underscore ip underscore all. Jest też trzecie ostrzeżenie, już od samej powłoki: znaleziono plik kropka mongorc kropka js, ale nie kropka mongoshrc kropka js, więc stary plik nie zostanie wczytany. To kolejny ślad zmiany powłoki: stara powłoka mongo czytała plik startowy mongorc, nowa mongosh czyta mongoshrc.

Do zapamiętania na test: rozszerzenie MongoDB for VS Code pozwala łączyć się z MongoDB i Atlasem z edytora. Connection string zaczyna się od mongodb, dwukropek, dwa ukośniki, albo mongodb plus srv dla rekordów DNS, typowo w Atlasie. Domyślnie serwer nie ma włączonej kontroli dostępu i nasłuchuje tylko na localhost, a zmienia się to opcjami bind ip albo bind ip all. Nowa powłoka czyta plik mongoshrc, a stara mongorc.

## MongoDB w Dockerze

Slajd pięćdziesiąty trzeci pokazuje najszybszą drogę do działającego serwera, czyli kontener Docker. Polecenie brzmi: docker run, minus minus name mongodb, minus d, minus p dwadzieścia siedem zero siedemnaście, dwukropek, dwadzieścia siedem zero siedemnaście, i na końcu nazwa obrazu: mongodb, ukośnik, mongodb minus community minus server, dwukropek, latest. Rozbierzmy to na części. Docker run tworzy i uruchamia nowy kontener. Opcja minus minus name nadaje mu nazwę mongodb, żeby można było się do niego potem odwoływać po nazwie. Opcja minus d to tryb detached, czyli uruchomienie w tle, tak że terminal nie zostaje zablokowany logami serwera. Opcja minus p mapuje porty w formacie port hosta, dwukropek, port kontenera, więc port dwadzieścia siedem zero siedemnaście twojego komputera prowadzi do portu dwadzieścia siedem zero siedemnaście w kontenerze. Ostatni argument to obraz, czyli oficjalny obraz MongoDB Community Server w najnowszej wersji, oznaczonej tagiem latest. Na slajdzie polecenie jest rozbite na trzy linie bez znaków kontynuacji. W prawdziwej konsoli wpisz je w jednej linii albo zakończ każdą linię odpowiednim znakiem kontynuacji, w bashu jest to backslash, inaczej powłoka potraktuje każdą linię jako osobne polecenie. W Docker Desktop widać potem kontener mongodb ze statusem Running i mapowaniem portów dwadzieścia siedem zero siedemnaście na dwadzieścia siedem zero siedemnaście.

Drugie polecenie to docker exec, minus it, mongodb, mongosh. Docker exec uruchamia polecenie wewnątrz działającego kontenera. Flagi minus i oraz minus t, sklejone w minus it, oznaczają tryb interaktywny z przydzielonym terminalem, czyli możesz pisać polecenia i widzieć odpowiedzi. Mongodb to nazwa kontenera, a mongosh to program, który ma się w nim uruchomić. W efekcie dostajesz powłokę MongoDB działającą wewnątrz kontenera. Na zrzucie widać wersję serwera siedem przecinek zero przecinek jeden i mongosh dwa przecinek zero przecinek jeden. Ponieważ port jest zmapowany, z bazą w kontenerze możesz się też połączyć z zewnątrz, na przykład Compassem albo z VS Code, pod adresem localhost dwadzieścia siedem zero siedemnaście.

Typowa pułapka: kolejność w opcji minus p to zawsze najpierw port hosta, potem port kontenera. Druga pułapka: minus d nie oznacza debug ani delete, tylko detached.

Do zapamiętania na test: docker run minus minus name mongodb minus d minus p dwadzieścia siedem zero siedemnaście dwukropek dwadzieścia siedem zero siedemnaście mongodb ukośnik mongodb minus community minus server dwukropek latest uruchamia MongoDB w tle w kontenerze o nazwie mongodb z portem udostępnionym na hoście. Docker exec minus it mongodb mongosh otwiera interaktywną powłokę w tym kontenerze. Minus d to detached, minus p to mapowanie port hosta dwukropek port kontenera, minus it to tryb interaktywny z terminalem.

## Zalety i ograniczenia baz NoSQL w kontekście MongoDB

Po części instalacyjnej przechodzimy do teorii. Slajd pięćdziesiąty czwarty zestawia zalety i ograniczenia baz NoSQL, pokazane na przykładzie MongoDB. Zalet jest pięć.

Pierwsza to elastyczny schemat. Baza łatwo dostosowuje się do zmian bez zakłócania pracy aplikacji. W bazie relacyjnej dodanie kolumny wymaga polecenia ALTER TABLE, które na dużej tabeli może trwać długo i blokować pracę. W MongoDB po prostu zaczynasz zapisywać dokumenty z nowym polem, a stare dokumenty zostają takie, jakie były.

Druga to skalowalność pozioma, czyli skalowanie w poziomie przez partycjonowanie danych na wielu serwerach. Slajd nazywa to fragmentowaniem, a w terminologii MongoDB mówi się na to sharding. Zamiast kupować coraz mocniejszy serwer, dokładasz kolejne zwykłe maszyny i dzielisz dane między nie.

Trzecia to szybki odczyt i zapis. MongoDB zaprojektowano z myślą o szybszym odczycie i zapisie, często przy użyciu prostszego języka zapytań niż SQL. Szybkość bierze się w dużej mierze stąd, że powiązane dane leżą razem w jednym dokumencie, więc nie trzeba wykonywać kosztownych złączeń.

Czwarta to obsługa dużych ilości danych. Bazy NoSQL lepiej nadają się do zarządzania danymi typu big data i do aplikacji czasu rzeczywistego.

Piąta to obsługa różnych struktur danych. Slajd mówi tu o bazie klucz dokument, co należy rozumieć tak: każdy dokument ma unikalny klucz, a wartością jest cały dokument o dowolnej, zagnieżdżonej strukturze.

Ograniczenia są dwa. Pierwsze to ograniczone możliwości zapytań: niektóre bazy NoSQL nie obsługują złożonych zapytań i agregacji albo używają własnych, specyficznych języków zapytań. MongoDB akurat ma bogaty język zapytań i potok agregacji, ale nie jest to SQL, więc trzeba się go nauczyć osobno. Drugie ograniczenie to słabsza spójność. Wiele baz NoSQL jest zgodnych z właściwościami BASE. Rozwińmy ten skrót, bo test lubi o niego pytać: B i A to Basically Available, czyli zasadniczo dostępna, S to Soft state, czyli stan miękki, a E to Eventual consistency, czyli spójność ostateczna. Spójność ostateczna oznacza, że po zapisie różne repliki przez chwilę mogą zwracać różne wartości, ale jeśli nie będzie nowych zapisów, z czasem wszystkie się wyrównają. BASE daje słabsze gwarancje niż ACID, czyli atomowość, spójność, izolacja i trwałość, znane z baz relacyjnych. Warto przy tym wiedzieć, że współczesne MongoDB jest bliżej ACID, niż sugeruje ten slajd: operacje na pojedynczym dokumencie są zawsze atomowe, a od wersji cztery zero istnieją transakcje obejmujące wiele dokumentów.

Do zapamiętania na test: zalety NoSQL według wykładu to elastyczny schemat, skalowalność pozioma przez partycjonowanie, czyli sharding, szybki odczyt i zapis, obsługa big data i aplikacji czasu rzeczywistego oraz obsługa różnych struktur danych. Ograniczenia to słabsze możliwości zapytań i słabsza spójność. BASE to Basically Available, Soft state, Eventual consistency, w przeciwieństwie do ACID.

## Bazy dokumentów

Slajd pięćdziesiąty piąty przypomina, czym jest baza dokumentów, w kontekście MongoDB. Model danych opiera się na dokumentach. Dokument jest samoopisowy, czyli nazwy pól są zapisane w nim samym, a nie w osobnym schemacie tabeli. Dokument może reprezentować hierarchię, podobnie jak JSON czy XML. Wartościami pól mogą być wartości skalarne, czyli pojedyncze liczby, napisy i wartości logiczne, a także mapy, listy, zbiory i zagnieżdżone dokumenty. Każdy dokument posiada unikalny identyfikator, czyli klucz. Dokumenty są zorganizowane w kolekcje.

Jeśli chodzi o zapytania, baza dokumentów pozwala stworzyć, zmienić i usunąć dokument, ale przede wszystkim pobrać dokumenty na podstawie złożonych kryteriów, czyli filtrować po wartościach pól wewnątrz dokumentów, także zagnieżdżonych.

Ważna uwaga z tego slajdu: bazy dokumentów to rozszerzone bazy klucz-wartość, w których część wartości można przeszukiwać. W czystej bazie klucz-wartość wartość jest dla bazy nieprzezroczystą bryłą, którą pobierasz tylko po kluczu. W bazie dokumentów baza rozumie strukturę wartości, więc możesz zapytać o wszystkie dokumenty, w których pole miasto ma wartość Kraków, i możesz założyć na tym polu indeks.

Do zapamiętania na test: dokument jest samoopisowy, może być hierarchiczny i ma unikalny klucz, a dokumenty grupuje się w kolekcje. Baza dokumentów to rozszerzona baza klucz-wartość, w której wartość, czyli dokument, można przeszukiwać.

## MongoDB jako produkt

Slajd pięćdziesiąty szósty przedstawia MongoDB jako bazę dokumentów wykorzystującą JSON. Strona domowa to mongodb kropka com. Lista właściwości ze slajdu brzmi tak: open source, wysoka dostępność, ostateczna spójność, automatyczny podział, replikacja master-slave, automatyczna naprawa oraz możliwość tworzenia dodatkowych indeksów. Dodatkowe indeksy to po prostu indeksy pomocnicze na polach innych niż klucz główny, czyli secondary indexes. Automatyczny podział to sharding, a automatyczna naprawa to zdolność zestawu replik do samodzielnego wybrania nowego węzła głównego po awarii.

Dwie rzeczy z tej listy wymagają komentarza. Po pierwsze, replikacja master-slave to stare określenie. Współczesne MongoDB używa zestawów replik, czyli replica sets, z jednym węzłem głównym nazywanym primary i węzłami pomocniczymi nazywanymi secondary. Dawny tryb master-slave został usunięty w nowszych wersjach. Na teście, jeśli pytanie dotyczy tego slajdu, odpowiedź „master-slave” będzie zgodna z wykładem, ale warto rozumieć, że chodzi o model z jednym węzłem przyjmującym zapisy. Po drugie, ostateczna spójność dotyczy głównie odczytów z węzłów pomocniczych. Domyślnie odczyty i zapisy idą do primary, co daje silną spójność dla pojedynczego klienta.

Dalej slajd podaje fakty, które dobrze nadają się na pytania testowe. MongoDB stworzyła firma o tej samej nazwie, MongoDB, wcześniej znana jako 10gen. Baza jest zaimplementowana w językach C++, C i JavaScript. Działa między innymi na Windowsie, Linuksie i Mac OS X. Pierwsze wydanie ukazało się w roku dwa tysiące dziewiątym. Nazwa MongoDB pochodzi od angielskiego słowa humongous, które oznacza ogromny, gigantyczny. Twórcy chcieli podkreślić, że baza jest przeznaczona do obsługi bardzo dużych ilości danych w sposób skalowalny i elastyczny.

Do zapamiętania na test: MongoDB to baza dokumentów, open source, pierwsze wydanie w roku dwa tysiące dziewiątym, napisana w C++, C i JavaScript, wieloplatformowa. Nazwa pochodzi od słowa humongous, czyli ogromny. Właściwości ze slajdu to wysoka dostępność, ostateczna spójność, automatyczny podział, replikacja, automatyczna naprawa i indeksy dodatkowe.

## Kluczowe cechy MongoDB

Slajd pięćdziesiąty siódmy zbiera definicję i kluczowe cechy. Definicja brzmi: MongoDB to baza NoSQL, open source i cross-platform, czyli wieloplatformowa, oparta na dokumentach w formacie BSON. Zapewnia wysoką wydajność, dostępność i łatwą skalowalność. Ma elastyczny, pozbawiony sztywnego schematu model, idealny dla danych nieustrukturyzowanych.

Kluczowych cech jest sześć i każdą warto umieć nazwać.

Pierwsza: zorientowanie na dokumenty. MongoDB przechowuje dane w dokumentach podobnych do JSON, zapisanych w formacie BSON. Model danych jest bardzo elastyczny i łatwo odwzorowuje rzeczywiste obiekty z kodu aplikacji. Obiekt klienta z listą adresów w Javie czy Pythonie zapisujesz jako jeden dokument z tablicą adresów, a nie jako dwie tabele połączone kluczem obcym.

Druga: skalowalność. Według slajdu MongoDB oferuje automatyczne skalowanie, bo można go skalować w poziomie przez sharding, czyli partycjonowanie danych na wielu serwerach, oraz w pionie przez dodawanie pojemności pamięci masowej, procesora i pamięci RAM.

Trzecia: indeksowanie. Aby zwiększyć wydajność zapytań, MongoDB pozwala indeksować dowolny atrybut dokumentu, także pola zagnieżdżone i elementy tablic.

Czwarta: replikacja. MongoDB zapewnia wysoką dostępność dzięki zestawom replik, czyli replica sets. Zestaw replik składa się z węzła podstawowego, primary, i węzłów pomocniczych, secondary, które utrzymują kopie danych. Gdy primary ulegnie awarii, pozostałe węzły wybierają nowego primary.

Piąta: agregacja. MongoDB ma zaawansowany mechanizm agregacji, czyli aggregation framework, do złożonych operacji na danych, takich jak transformacje, filtrowanie i sortowanie.

Szósta: obsługa zapytań ad hoc. Zapytanie ad hoc to zapytanie tworzone na bieżąco, bez wcześniejszego przygotowania widoku czy funkcji. MongoDB pozwala wyszukiwać według pól, zakresów i wyrażeń regularnych. To odróżnia ją od prostych baz klucz-wartość, gdzie pobierasz dane wyłącznie po kluczu.

Do zapamiętania na test: kluczowe cechy MongoDB to orientacja na dokumenty w formacie BSON, skalowalność pozioma przez sharding i pionowa przez mocniejszy sprzęt, indeksowanie dowolnego pola, replikacja przez zestawy replik z węzłem primary i węzłami secondary, agregacja oraz zapytania ad hoc według pól, zakresów i wyrażeń regularnych.

## Kiedy używać MongoDB

Slajd pięćdziesiąty ósmy wymienia sześć scenariuszy, w których MongoDB jest dobrym wyborem, szczególnie gdy potrzebna jest elastyczność i skalowalność.

Pierwszy to Big Data. Elastyczny model dokumentowy JSON i BSON oraz skalowalność pozioma przez sharding sprawiają, że MongoDB dobrze nadaje się do przechowywania i przetwarzania dużych ilości danych nieustrukturyzowanych lub częściowo ustrukturyzowanych.

Drugi to analityka w czasie rzeczywistym. Silnik agregacji, indeksy, w tym geolokalizacyjne i tekstowe, oraz praca w klastrach pozwalają szybko przetwarzać i analizować dane na bieżąco. Indeks geolokalizacyjny pozwala na przykład znaleźć sklepy w promieniu kilometra od użytkownika, a indeks tekstowy przeszukiwać treść po słowach.

Trzeci to zarządzanie treścią. Dzięki dynamicznemu schematowi MongoDB obsługuje różne typy treści bez migracji schematu, co jest idealne dla systemów CMS i platform e-commerce. W sklepie internetowym laptop ma inne atrybuty niż koszulka, a w MongoDB oba produkty mogą leżeć w jednej kolekcji z różnymi polami.

Czwarty to Internet rzeczy, po angielsku IoT. MongoDB może zbierać dane z milionów urządzeń i czujników, zapewniając skalowalność i szybki zapis dużych wolumenów danych.

Piąty to aplikacje mobilne. Elastyczny model danych i wsparcie dla trybu offline-first, na przykład przez MongoDB Realm, sprawiają, że MongoDB dobrze pasuje do aplikacji mobilnych o zmiennych strukturach danych. Offline-first oznacza, że aplikacja działa na lokalnej kopii danych i synchronizuje je z serwerem, gdy pojawi się połączenie.

Szósty to aplikacje chmurowe i mikroserwisy. MongoDB jest naturalnym wyborem dla architektur mikroserwisowych, w których każdy serwis może mieć własny model danych.

Do zapamiętania na test: MongoDB pasuje do big data, analityki w czasie rzeczywistym, zarządzania treścią, czyli CMS i e-commerce, Internetu rzeczy, aplikacji mobilnych z trybem offline-first przez Realm oraz mikroserwisów i aplikacji chmurowych. Wspólny mianownik to elastyczny schemat i skalowalność pozioma.

## Skalowalność pozioma i pionowa

Slajd pięćdziesiąty dziewiąty porównuje dwa rodzaje skalowania. To klasyczny temat testowy, więc omówię każdą cechę z osobna.

Definicja. Skalowanie poziome, po angielsku horizontal, to dodawanie kolejnych serwerów, w MongoDB nazywanych shardami, do klastra. Skalowanie pionowe, po angielsku vertical, to zwiększanie zasobów jednego serwera. Prosta analogia: skalowanie poziome to zatrudnienie kolejnych kucharzy, a pionowe to kupienie jednemu kucharzowi szybszej kuchenki.

Mechanizm w MongoDB. Poziomo działa sharding: dane dzieli się na fragmenty, po angielsku chunki, rozproszone na wielu shardach. Pionowo zwiększa się procesor, pamięć RAM i przestrzeń dyskową.

Złożoność wdrożenia. Skalowanie poziome ma złożoność wysoką, bo wymaga konfiguracji klucza shardowania, czyli shard key, serwerów konfiguracyjnych, czyli config servers, oraz routerów mongos. Skalowanie pionowe ma złożoność niską, bo wystarczy zmienić parametry maszyny lub instancji w chmurze.

Limit skalowania. Poziomo limit jest bardzo wysoki, bo zawsze można dołożyć kolejne serwery. Pionowo jest ograniczony maksymalną specyfikacją dostępnego sprzętu.

Koszt. Skalowanie poziome jest droższe na początku, bo potrzeba więcej serwerów i sieci, ale w długim okresie skaluje się lepiej. Skalowanie pionowe jest tańsze na początku, ale według slajdu koszt rośnie wykładniczo przy dużych wymaganiach, bo najmocniejsze maszyny są nieproporcjonalnie drogie.

Wpływ na wydajność. Poziomo obciążenie zapisu i odczytu rozkłada się na wiele węzłów. Pionowo poprawia się wydajność tylko jednego węzła.

Przykład zastosowania. Poziomo: aplikacje z ogromną ilością danych i dużą liczbą zapytań. Pionowo: małe i średnie aplikacje, którym wystarczy mocniejszy serwer.

Do zapamiętania na test: skalowanie poziome to więcej serwerów, w MongoDB sharding z chunkami, shard key, config servers i routerami mongos; ma wysoką złożoność, bardzo wysoki limit i wyższy koszt początkowy. Skalowanie pionowe to mocniejszy jeden serwer, czyli więcej CPU, RAM i dysku; jest proste i tanie na start, ale ograniczone sprzętem, a jego koszt rośnie wykładniczo.

## Struktura danych w MongoDB

Slajd sześćdziesiąty definiuje MongoDB jeszcze raz jako popularny system baz NoSQL, który przechowuje dane w elastycznych dokumentach JSON i dzięki temu nadaje się do pracy z danymi na dużą skalę i nieustrukturyzowanymi. Zaprojektowano go z myślą o elastyczności, wydajności i skalowalności. Uwaga na literówkę: na slajdzie w nawiasie jest napisane BJSON, a poprawna nazwa formatu to BSON, od Binary JSON.

Slajd definiuje pięć pojęć, w kolejności od największego do najmniejszego. Baza danych przechowuje wszystkie kolekcje w danej instancji MongoDB. Kolekcja to grupa powiązanych dokumentów, podobna do tabeli w bazie relacyjnej. Dokument to pojedynczy rekord w kolekcji, przechowywany w formacie BSON, czyli binarnym JSON. Pole to para klucz-wartość w dokumencie, odpowiednik kolumny. Wreszcie pole podkreślnik id, zapisywane jako _id, to unikatowy identyfikator generowany automatycznie dla każdego dokumentu w kolekcji, o ile nie podasz go sam.

Do zapamiętania na test: hierarchia to baza danych, kolekcja, dokument, pole. Kolekcja odpowiada tabeli, dokument wierszowi, pole kolumnie. Pole _id jest unikatowe i generowane automatycznie, gdy go nie podasz.

## Podstawowe operacje

Slajd sześćdziesiąty pierwszy wymienia podstawowe operacje i metody, które musisz znać na pamięć, bo to rdzeń pytań o składnię. Wszystkie wywołuje się według wzoru db, kropka, nazwa kolekcji, kropka, nazwa metody, nawiasy.

Wyszukiwanie, czyli find. Dokumenty z kolekcji pobierasz metodą db kropka collection kropka find, a wyniki filtrujesz kryteriami zapytania przekazanymi w nawiasie. Puste find, bez argumentów albo z pustym dokumentem w klamrach, zwraca wszystkie dokumenty. Aby pobrać tylko jeden dokument, używasz db kropka collection kropka findOne. Różnica jest istotna: find zwraca kursor, po którym się iteruje, a findOne zwraca od razu pojedynczy dokument albo null, jeśli nic nie pasuje.

Wstawianie, czyli insert. Pojedynczy dokument wstawiasz przez insertOne, a w nawiasie podajesz dokument w klamrach. Wiele dokumentów naraz wstawiasz przez insertMany, a w nawiasie podajesz tablicę dokumentów w nawiasach kwadratowych. Częsty błąd to podanie do insertMany pojedynczego dokumentu bez nawiasów kwadratowych.

Aktualizacja, czyli update. Pola lub całe dokumenty aktualizujesz metodami updateOne i updateMany, przy użyciu operatorów aktualizacji, takich jak dolar set, który ustawia wartość pola, i dolar unset, który usuwa pole z dokumentu. UpdateOne zmienia pierwszy pasujący dokument, a updateMany wszystkie pasujące. Pamiętaj, że metody update przyjmują dwa argumenty: najpierw filtr, potem dokument z operatorami aktualizacji. Jeśli chcesz zastąpić cały dokument nowym, służy do tego replaceOne, który jako drugi argument przyjmuje zwykły dokument bez operatorów z dolarem. To typowa pułapka: updateOne zmienia wskazane pola, replaceOne podmienia całą treść dokumentu, zachowując tylko _id.

Usuwanie dokumentów, czyli delete. Dokumenty usuwasz według kryteriów zapytania metodami deleteOne, która usuwa pierwszy pasujący dokument, i deleteMany, która usuwa wszystkie pasujące. Uwaga: deleteMany z pustym filtrem usuwa wszystkie dokumenty, ale kolekcja dalej istnieje, razem z indeksami.

Usuwanie obiektów, czyli drop. Kolekcję trwale usuwasz metodą db kropka collection kropka drop, a całą bieżącą bazę danych metodą db kropka dropDatabase. Drop usuwa kolekcję razem z indeksami. To jest różnica, o którą lubią pytać: deleteMany z pustym filtrem opróżnia kolekcję, drop ją likwiduje.

Do zapamiętania na test: find zwraca kursor, findOne jeden dokument; insertOne przyjmuje dokument, insertMany tablicę dokumentów; updateOne i updateMany przyjmują filtr i operatory takie jak dolar set i dolar unset; deleteOne i deleteMany usuwają dokumenty według filtra; db kropka kolekcja kropka drop usuwa kolekcję, a db kropka dropDatabase usuwa bazę.

## Indeksy i agregacje w zarysie

Slajd sześćdziesiąty drugi wprowadza dwa tematy, które wrócą szczegółowo w dalszych działach. Indeksy zwiększają wydajność wyszukiwania. Tworzysz je metodą db kropka collection kropka createIndex, podając w nawiasie dokument z nazwą pola i kierunkiem: jedynka oznacza indeks rosnący, minus jedynka malejący. Bez indeksu baza musi przejrzeć każdy dokument w kolekcji, co nazywa się skanowaniem kolekcji, po angielsku COLLSCAN. Z indeksem idzie prosto do pasujących dokumentów, co w planie zapytania widać jako IXSCAN. Ceną indeksu jest dodatkowe miejsce na dysku i wolniejszy zapis, bo każdy insert i update musi zaktualizować także indeks.

Agregacje służą do złożonego przetwarzania danych, takiego jak filtrowanie, grupowanie, przekształcanie i sortowanie. Wykonuje się je metodą aggregate, przekazując tablicę etapów, czyli potok, po angielsku pipeline. Slajd wymienia cztery podstawowe etapy. Dolar match filtruje dokumenty, podobnie jak WHERE w SQL. Dolar group grupuje dokumenty i liczy wartości zbiorcze, jak GROUP BY. Dolar project wybiera, ukrywa lub przekształca pola, jak lista kolumn po SELECT. Dolar sort sortuje, jak ORDER BY. Dokumenty przepływają przez etapy po kolei, a wynik jednego etapu jest wejściem następnego, dlatego kolejność etapów ma znaczenie.

Do zapamiętania na test: indeks tworzy się przez createIndex z polem i kierunkiem jeden albo minus jeden. Agregacje wykonuje się przez aggregate z tablicą etapów; dolar match filtruje, dolar group grupuje, dolar project kształtuje pola, dolar sort sortuje.

## Modelowanie danych: trzy podejścia

Teraz zaczyna się najważniejsza część działu. Slajd sześćdziesiąty trzeci mówi, że elastyczny model dokumentowy MongoDB pozwala organizować dane na różne sposoby, i wymienia trzy podejścia.

Pierwsze to dokumenty osadzone, po angielsku embedded documents. Powiązane dane przechowuje się w jednym dokumencie. Najlepiej sprawdzają się w relacjach jeden do jednego oraz jeden do wielu, gdy liczba elementów po stronie wielu jest ograniczona. Zapewniają szybki odczyt, bo jednym zapytaniem dostajesz cały obiekt z jego częściami.

Drugie to referencje, po angielsku references. Dane przechowuje się w oddzielnych kolekcjach i łączy za pomocą identyfikatorów, czyli jeden dokument zawiera wartość _id innego dokumentu. Referencje są odpowiednie dla relacji jeden do wielu oraz wiele do wielu i ułatwiają zarządzanie dużymi oraz współdzielonymi zbiorami danych. Współdzielony znaczy tu taki, z którego korzysta wiele innych dokumentów, na przykład jeden wydawca wielu książek.

Trzecie to podejście hybrydowe, które łączy dokumenty osadzone i referencje. Pozwala znaleźć równowagę między wydajnością, elastycznością i wykorzystaniem pamięci. Typowy przykład: w dokumencie zamówienia trzymasz referencję do klienta, czyli jego identyfikator, ale osadzasz też kopię jego nazwiska, żeby lista zamówień wyświetlała się bez dodatkowego zapytania.

Podsumowanie slajdu: MongoDB oferuje elastyczne modelowanie danych, dzięki czemu dobrze sprawdza się w aplikacjach przetwarzających duże wolumeny danych, dane półstrukturalne i szybko zmieniające się modele biznesowe.

Ogólna zasada, którą powtarza dokumentacja MongoDB, brzmi: dane, które są odczytywane razem, przechowuj razem. Projektujesz schemat pod sposób, w jaki aplikacja czyta dane, a nie pod czystą teorię normalizacji.

Do zapamiętania na test: osadzanie służy relacjom jeden do jednego i jeden do wielu z ograniczoną liczbą elementów i daje szybki odczyt. Referencje to identyfikatory wskazujące dokumenty w innych kolekcjach, dobre dla jeden do wielu i wiele do wielu oraz dla dużych, współdzielonych danych. Podejście hybrydowe łączy oba sposoby.

## Tablice dokumentów osadzonych

Slajd sześćdziesiąty czwarty rozwija temat dokumentów osadzonych i mówi, kiedy używać tablic dokumentów osadzonych. Są cztery warunki. Pierwszy: mamy relację jeden do wielu. Drugi: osadzone dane nie rosną w sposób nieograniczony. Trzeci: osadzone dane są ściśle powiązane z dokumentem nadrzędnym, czyli nie mają sensu bez niego. Czwarty: możemy skorzystać z lepszej wydajności odczytu i zapisu.

Kluczowa liczba z tego slajdu: MongoDB ogranicza rozmiar pojedynczego dokumentu do szesnastu megabajtów. Jeśli tablica może rosnąć bez końca, kiedyś przekroczy ten limit. Alternatywą jest wtedy osobna kolekcja i odwoływanie się do niej przez referencje.

Slajd wymienia trzy zalety tablic dokumentów osadzonych. Wydajność odczytu i zapisu: powiązane dane leżą razem w tym samym dokumencie, więc operacje są szybsze, bo nie wymagają wielu zapytań ani wielu aktualizacji. Spójność danych: przechowując powiązane dane razem, łatwo zapewnić, że są zawsze zsynchronizowane, bez polegania na złączeniach czy odsyłaczach. Pamiętaj też, że zapis jednego dokumentu jest w MongoDB atomowy, więc zmiana dokumentu nadrzędnego razem z jego tablicą odbywa się w całości albo wcale. Skalowalność: wbudowane tablice można zagnieżdżać, co pozwala reprezentować złożone struktury danych z zachowaniem elastycznego schematu i wysokiej wydajności.

Przykład ze slajdu to dokument z _id równym jeden, polem name równym John Doe i polem addresses, które jest tablicą dwóch obiektów. Pierwszy adres to ulica 123 Main St w Nowym Jorku z kodem 10001, drugi to 456 Broadway w Los Angeles z kodem 90001. Każdy adres ma pola street, city i zipcode. Taki dokument odczytujesz jednym find i od razu masz osobę z wszystkimi adresami.

Do zapamiętania na test: tablice osadzone stosuj, gdy relacja jest jeden do wielu, dane nie rosną bez ograniczeń, są ściśle związane z rodzicem i zależy ci na szybkim odczycie i zapisie. Limit rozmiaru dokumentu to szesnaście megabajtów, a gdy grozi przekroczenie, stosuje się osobną kolekcję z referencjami. Zalety to wydajność, spójność i możliwość zagnieżdżania.

## BSON kontra JSON

Slajdy od sześćdziesiątego piątego do sześćdziesiątego ósmego porównują dwa formaty: BSON i JSON. W MongoDB dane są przechowywane w formacie binarnym o nazwie BSON, czyli Binary JSON, który slajd nazywa nadzbiorem JSON, czyli JavaScript Object Notation. Nadzbiór oznacza, że BSON umie wyrazić wszystko, co JSON, i jeszcze więcej, głównie dzięki dodatkowym typom.

BSON to zakodowana binarnie serializacja dokumentów podobnych do JSON. Zaprojektowano go tak, żeby był wydajny w trzech rzeczach: w przechowywaniu, w przechodzeniu, czyli przeglądaniu struktury, oraz w kodowaniu i dekodowaniu. Kluczowe cechy BSON są trzy. Kodowanie binarne zapewnia lepszą wydajność i pozwala przechowywać typy danych, których JSON nie obsługuje. Obsługa dodatkowych typów danych: BSON ma między innymi typy Date, czyli data, Binary, czyli dane binarne, ObjectId, czyli identyfikator obiektu, i Decimal128, czyli dokładna liczba dziesiętna o stu dwudziestu ośmiu bitach, przydatna do kwot pieniężnych. Wydajne przeszukiwanie: w BSON zakodowany jest rozmiar każdego elementu, więc parser może przeskoczyć element, którego nie potrzebuje, zamiast czytać go znak po znaku. To przyspiesza przechodzenie po dokumencie.

JSON to lekki, czytelny dla człowieka format danych, który łatwo analizować i generować w wielu językach programowania. Jest szeroko stosowany do przesyłania danych przez sieć. Jego cechy według slajdu: jest czytelny dla człowieka, bo to tekst o prostej strukturze; zapewnia interoperacyjność, bo prawie każdy język ma do niego bibliotekę, więc dobrze służy do wymiany danych między aplikacjami; ma ograniczone typy danych, czyli ciągi znaków, liczby, wartości logiczne i null, a do tego tablice i obiekty. Daty i dane binarne trzeba w JSON zapisywać jako napisy albo obiekty niestandardowe. Właśnie dlatego, kiedy eksportujesz dane z MongoDB do JSON, zobaczysz zapis typu dolar oid albo dolar date. To tak zwany Extended JSON, który przenosi typy BSON w tekście.

Podsumowanie ze slajdu sześćdziesiątego siódmego: BSON i JSON są powiązane, ale służą różnym celom. BSON to format binarny używany przez MongoDB do wydajnego przechowywania i pobierania danych z obsługą dodatkowych typów natywnych. JSON jest czytelniejszy i powszechniejszy, więc zwykle służy do wymiany danych między MongoDB a aplikacjami. Korzystając wewnętrznie z BSON, MongoDB zyskuje jego zalety w przechowywaniu, przechodzeniu i bogatszych typach, a jednocześnie przez interfejsy zapytań i sterowniki zapewnia interoperacyjność i czytelność JSON.

Slajd sześćdziesiąty ósmy zbiera to w tabeli, którą opowiem cecha po cesze. Pełna nazwa: JSON to JavaScript Object Notation, BSON to Binary JSON. Format: JSON jest tekstowy i czytelny dla człowieka, BSON binarny i optymalizowany dla maszyn. Typy danych: JSON ma podstawowe, czyli string, number, boolean, array i object, a BSON rozszerzone, dodatkowo Date, Binary, Decimal128 i ObjectId. Rozmiar: według slajdu JSON jest większy, bo to zapis tekstowy bez kompresji, a BSON mniejszy, bo binarny i bardziej kompaktowy. Wydajność: JSON jest wolniejszy przy serializacji i deserializacji, BSON szybszy i zoptymalizowany pod MongoDB. Obsługa hierarchii: oba ją mają, ale JSON tylko z podstawowymi typami, a BSON z dodatkowymi typami i metadanymi. Zastosowanie: JSON do wymiany danych w API i do plików konfiguracyjnych, BSON do przechowywania danych w MongoDB.

Jedno zastrzeżenie dla dociekliwych. Twierdzenie, że BSON jest zawsze mniejszy od JSON, nie jest ścisłe. Ponieważ BSON zapisuje długości elementów i znaczniki typów, dla małych dokumentów bywa nawet większy niż odpowiadający mu tekst JSON. Jego główną przewagą jest szybkość przechodzenia i bogatsze typy, nie rozmiar. Na teście odpowiadaj jednak zgodnie ze slajdem, czyli że BSON jest bardziej kompaktowy.

Do zapamiętania na test: BSON to Binary JSON, binarny format przechowywania w MongoDB, z dodatkowymi typami Date, Binary, ObjectId i Decimal128 oraz z zakodowanym rozmiarem elementów, co ułatwia ich pomijanie. JSON to tekstowy, czytelny format wymiany danych z typami string, number, boolean, null, array i object. Według slajdu BSON jest mniejszy i szybszy, a JSON czytelniejszy i bardziej interoperacyjny.

## Typy danych

Slajd sześćdziesiąty dziewiąty mówi, że zrozumienie typów danych jest niezbędne, bo odgrywają one kluczową rolę w projektowaniu schematów i w wydajności zapytań. Na przykład liczba zapisana jako napis nie porówna się poprawnie z liczbą, a zapytanie z operatorem dolar g t po polu tekstowym da wyniki według porządku alfabetycznego, a nie liczbowego.

Najważniejszy typ na tym slajdzie to identyfikator obiektu, czyli ObjectId. To dwunastobajtowy identyfikator używany jako unikatowy identyfikator dokumentów w kolekcji. Jest wartością domyślną generowaną dla pola _id i zapewnia unikatowość w obrębie kolekcji. W zapisie szesnastkowym, czyli hex, ma dwadzieścia cztery znaki, bo jeden bajt to dwa znaki szesnastkowe, a dwanaście razy dwa to dwadzieścia cztery. Zapamiętaj obie liczby: dwanaście bajtów, dwadzieścia cztery znaki hex.

Diagram na slajdzie pokazuje typy BSON z przykładami. Int32, czyli liczba całkowita trzydziestodwubitowa, na przykład pole age z wartością dwadzieścia osiem. Double, czyli liczba zmiennoprzecinkowa podwójnej precyzji, na przykład price równe dwanaście przecinek dziewięćdziesiąt dziewięć. Warto wiedzieć, że w mongosh zwykła liczba wpisana z klawiatury, nawet całkowita, jest domyślnie zapisywana jako Double, a żeby wymusić liczbę całkowitą, używa się konstruktora NumberInt. String, czyli napis, na przykład name równe John Doe. Array, czyli tablica, na przykład tags z wartościami mongodb, database i noSQL. Object, czyli zagnieżdżony dokument, na przykład address z polami street i city. Binary data, czyli dane binarne, zapisywane jako BinData z dwoma argumentami: numerem podtypu, tu zero, i treścią zakodowaną w Base64. Undefined, czyli wartość niezdefiniowana, która na diagramie jest przekreślona, bo to typ przestarzały i nie należy go używać. Zamiast niego stosuje się null. ObjectId, na przykład _id równe ObjectId z dwudziestoczteroznakowym napisem szesnastkowym. Boolean, czyli wartość logiczna, na przykład isActive równe true. Date, czyli data, zapisywana w mongosh przez ISODate z napisem w formacie ISO, na przykład dwa tysiące dziewiętnasty rok, osiemnasty lutego, z godziną i literą Z na końcu oznaczającą czas UTC. Null, na przykład middleName równe null, czyli pole istnieje, ale nie ma wartości. Wreszcie Regular Expression, czyli wyrażenie regularne, na przykład pattern równe ukośnik, daszek, mongodb, ukośnik, i, co oznacza napis zaczynający się od mongodb bez rozróżniania wielkości liter, bo flaga i to case insensitive.

Do zapamiętania na test: ObjectId ma dwanaście bajtów i dwadzieścia cztery znaki szesnastkowe i jest domyślną wartością pola _id. Typy BSON to między innymi Int32, Double, String, Array, Object, Binary data zapisywane jako BinData, ObjectId, Boolean, Date zapisywane jako ISODate, Null i Regular Expression. Undefined jest przestarzały.

## Przykład zapytań na kolekcji filmów

Slajd siedemdziesiąty to pierwszy pełny przykład. Najpierw wstawienie danych. Piszemy use, nawias, apostrof DB1 apostrof, nawias, średnik, co przełącza na bazę DB1. Potem db, kropka, movies, kropka, insertMany, a w nawiasie tablica w nawiasach kwadratowych z trzema dokumentami: title Niezniszczalni i year dwa tysiące dwadzieścia, title Tomb Raider i year dwa tysiące dwadzieścia jeden, title Hobbit i year dwa tysiące dwadzieścia dwa. Zwróć uwagę, że nie podajemy pola _id. MongoDB generuje je sama i w podglądzie kolekcji widać je w zapisie Extended JSON jako obiekt z kluczem dolar oid i wartością szesnastkową, na przykład sześćdziesiąt osiem ee siedem c i tak dalej. Kolejne identyfikatory różnią się tylko końcówką, c zero, c jeden, c dwa, bo zostały wygenerowane w tej samej sekundzie przez ten sam proces, a ostatnie bajty ObjectId to rosnący licznik.

Teraz zapytanie: tytuły filmów z dwa tysiące dwudziestego pierwszego roku i późniejszych, posortowane malejąco. Piszemy db, kropka, movies, kropka, find, i w nawiasie dwa argumenty. Pierwszy to filtr: w klamrach year, dwukropek, i znowu klamry z operatorem dolar g t, czyli greater than, większy niż, i wartością dwa tysiące dwadzieścia. Drugi argument to projekcja: w klamrach _id dwukropek zero oraz title dwukropek jeden. Zero oznacza ukryj pole, jeden pokaż pole. Pole _id jest zwracane domyślnie, więc jeśli go nie chcesz, musisz je jawnie wyłączyć zerem. Na końcu dopisujemy kropka sort, a w nawiasie klamry z title dwukropek minus jeden, czyli sortowanie malejące po tytule.

Wynik to tablica dwóch dokumentów: najpierw title Tomb Raider, potem title Hobbit. Dlaczego tak? Filtr dolar g t dwa tysiące dwadzieścia odrzuca Niezniszczalnych z roku dwa tysiące dwadzieścia, bo dolar g t to ostro większe. Gdyby użyć dolar g t e, czyli greater than or equal, większe lub równe, Niezniszczalni też by się załapali. Następnie sortowanie malejące po tytule ustawia litery od końca alfabetu, więc T przed H. Zauważ, że opis zadania mówi „posortowane malejąco”, ale sortujemy po tytule, a nie po roku. Tu kolejność wychodzi taka sama, ale na teście sprawdzaj zawsze, po którym polu jest sort.

Typowe pułapki z tego przykładu: pomylenie dolar g t z dolar g t e, zapomnienie, że _id pojawia się domyślnie, oraz pomieszanie projekcji jeden i zero. W jednej projekcji nie można mieszać włączania i wyłączania pól, z jednym wyjątkiem: pole _id wolno wyłączyć zerem, nawet gdy inne pola włączasz jedynką.

Do zapamiętania na test: find przyjmuje filtr i projekcję; dolar g t to ostro większe, dolar g t e większe lub równe; w projekcji jeden pokazuje, zero ukrywa, a _id jest zwracane domyślnie; sort z minus jeden sortuje malejąco, z jeden rosnąco. Zapytanie ze slajdu zwraca Tomb Raider i Hobbit.

## Model danych: instancja, bazy, kolekcje, dokumenty

Slajd siedemdziesiąty pierwszy porządkuje strukturę: instancja zawiera bazy danych, baza danych zawiera kolekcje, kolekcja zawiera dokumenty. Kolekcja to zbiór dokumentów z reguły o podobnej strukturze. Z reguły, bo MongoDB tego nie wymusza, ale w praktyce dokumenty jednej kolekcji opisują ten sam rodzaj obiektów. Dokument to jeden obiekt JSON, czyli złożony obiekt JSON, który może zawierać inne zagnieżdżone obiekty, tablice i wartości. Każdy dokument ma unikalny identyfikator, czyli klucz główny, realizowany jako pole _id. Na slajdzie widnieje zapis „poleId” z zniekształconym znakiem, co jest błędem przepisywania; chodzi o pole podkreślnik id.

Slajd siedemdziesiąty drugi opisuje dokument MongoDB dokładniej. Wewnętrznie jest zapisany w formacie BSON. Maksymalny rozmiar dokumentu to szesnaście megabajtów. Do większych plików można użyć GridFS, który dzieli plik na części.

Dalej są restrykcje dotyczące pól. Pole _id najwyższego poziomu jest zarezerwowane dla klucza głównego. Nazwy pól nie mogą zaczynać się od znaku dolara, bo dolar jest zarezerwowany dla operatorów zapytań, takich jak dolar set czy dolar g t. Kropka jest używana do odwoływania się do pól zagnieżdżonych, w tak zwanej notacji kropkowej. Na przykład zapytanie o pole city w dokumencie address zapisujesz jako napis w cudzysłowie: address kropka city. Dlatego kropka w nazwie pola prowadziłaby do niejednoznaczności. Slajd mówi, że nazwy pól nie mogą dolara zawierać; to zasada historyczna i bezpieczna. Nowsze wersje MongoDB, od pięć zero, dopuszczają dolar i kropkę w nazwach pól w ograniczonym zakresie, ale nie wolno ich używać na początku nazwy pola najwyższego poziomu i w praktyce należy ich unikać. Na teście trzymaj się slajdu.

Kolejność pól w dokumencie jest zachowana, z jednym wyjątkiem: pole _id jest przenoszone na początek dokumentu. Nazwy pól w obrębie jednego dokumentu muszą być unikalne, czyli nie możesz mieć dwóch pól o tej samej nazwie na tym samym poziomie.

Przykład na slajdzie to fragment dokumentu z zestawu danych Airbnb: _id jest tu napisem z cyframi, a nie ObjectId, są też pola listing_url, name i summary. To dobra ilustracja, że _id nie musi być ObjectId.

Do zapamiętania na test: struktura to instancja, bazy, kolekcje, dokumenty. Dokument to jeden obiekt w formacie BSON o maksymalnym rozmiarze szesnastu megabajtów, a większe pliki obsługuje GridFS. Pole _id jest zarezerwowane dla klucza głównego i ląduje na początku dokumentu, nazwy pól nie mogą zaczynać się od dolara, kropka służy do pól zagnieżdżonych, a nazwy pól muszą być unikalne. Kolejność pól jest zachowana.

## BinData kontra GridFS

Slajd siedemdziesiąty trzeci porównuje dwa sposoby przechowywania danych binarnych. BinData to pole typu binarnego wewnątrz zwykłego dokumentu. GridFS to specyfikacja dzielenia dużego pliku na kawałki zapisywane jako wiele dokumentów.

Omówmy cechę po cesze. Limit rozmiaru: BinData podlega limitowi dokumentu, czyli do szesnastu megabajtów; GridFS praktycznie nie ma limitu, bo plik dzieli się na chunki. Domyślny rozmiar chunka to dwieście pięćdziesiąt pięć kilobajtów. Strumieniowanie: BinData go nie obsługuje, GridFS tak, łącznie z wysyłaniem, pobieraniem i wznawianiem. Częściowe odczyty: w BinData są ograniczone, bo zawsze czytasz cały dokument; w GridFS możliwe, bo możesz pobrać tylko wybrane chunki, na przykład fragment filmu od określonej sekundy. Struktura: BinData to pole w dokumencie, a GridFS używa dwóch kolekcji, fs kropka files z metadanymi pliku, takimi jak nazwa, rozmiar i data wgrania, oraz fs kropka chunks z kolejnymi kawałkami danych. Przedrostek fs to domyślna nazwa tak zwanego kubełka, po angielsku bucket. Indeksowanie: BinData indeksuje się jak każdy dokument, a GridFS ma wbudowany wzorzec indeksu złożonego: files underscore id jeden oraz n jeden. Pole files_id wskazuje plik, do którego należy chunk, a n to numer kolejny chunka, więc ten indeks pozwala szybko złożyć plik w dobrej kolejności. Złożoność: BinData niska, GridFS średnia, bo jest więcej elementów i osobne API GridFS w sterownikach. Typowe użycie: BinData do miniatur, certyfikatów, kluczy i małych załączników; GridFS do dużych plików, czyli zdjęć, PDF, wideo, archiwów i kopii zapasowych. Transakcje: BinData zachowuje się jak dokument, czyli zapis jest atomowy; w GridFS wsparcie dotyczy pojedynczych operacji lub chunków i zależy od wersji oraz sterownika, więc zapis dużego pliku nie jest jedną atomową operacją. Dostarczanie przez CDN: BinData teoretycznie tak, ale zwykle lepiej trzymać takie pliki poza bazą; GridFS często łączy się z warstwą serwującą albo streamingiem.

Do zapamiętania na test: BinData to pole binarne w dokumencie, ograniczone do szesnastu megabajtów, proste, bez strumieniowania, do małych danych. GridFS dzieli plik na chunki w dwóch kolekcjach, fs kropka files i fs kropka chunks, z indeksem files_id jeden, n jeden, obsługuje strumieniowanie i częściowe odczyty i służy do dużych plików.

## Klucze główne i ObjectId

Slajd siedemdziesiąty czwarty opisuje klucze główne, czyli pole _id. Identyfikatory mają trzy właściwości. Są unikalne w ramach kolekcji, bo na polu _id zawsze istnieje unikalny indeks, którego nie da się usunąć. Są niemutowalne, czyli nie można ich zmienić po przypisaniu; jeśli chcesz zmienić _id, musisz usunąć dokument i wstawić go ponownie z nowym identyfikatorem. Mogą być dowolnego typu poza tablicą. Napis, liczba, data, a nawet zagnieżdżony dokument są dopuszczalne, ale tablica nie.

Slajd wymienia cztery sposoby zarządzania kluczami. Naturalny identyfikator, czyli wartość, która z natury jest unikalna, na przykład numer ISBN książki albo login użytkownika. Auto-inkrement, czyli kolejne liczby jeden, dwa, trzy, jak w SQL; slajd mówi wprost, że nie jest zalecany. MongoDB nie ma wbudowanego autoinkrementu, a jego emulacja wymaga osobnego licznika, który przy wielu serwerach staje się wąskim gardłem i źródłem konfliktów. UUID, czyli Universally Unique Identifier, uniwersalnie unikalny identyfikator o stu dwudziestu ośmiu bitach. I wreszcie ObjectId, specjalny typ BSON, używany domyślnie. ObjectId jest niewielki, unikalny i szybki do wygenerowania, a według slajdu bazuje na czasie, odcisku maszyny i procesu.

Uzupełnijmy to dokładniejszą wiedzą. ObjectId ma dwanaście bajtów. Pierwsze cztery bajty to znacznik czasu w sekundach od epoki Uniksa, dlatego z ObjectId można odczytać moment utworzenia dokumentu metodą getTimestamp, a sortowanie po _id daje w przybliżeniu kolejność wstawiania. Następne pięć bajtów to w nowszych wersjach losowa wartość unikalna dla maszyny i procesu; w starszych wersjach był to identyfikator maszyny i numer procesu, i stąd sformułowanie ze slajdu o odcisku maszyny i procesu. Ostatnie trzy bajty to licznik, który rośnie z każdym wygenerowanym identyfikatorem. Dzięki temu ObjectId można generować bez porozumiewania się z serwerem, nawet po stronie sterownika w aplikacji, i kolizje są praktycznie niemożliwe.

Przykład na slajdzie to dokument z _id w zapisie Extended JSON, czyli obiekt z kluczem dolar oid i wartością sześćset dwadzieścia osiem ea zero b sześć i tak dalej, oraz polami firstName Patryk, lastName Bez i created_date z datą zapisaną jako napis. Ta ostatnia rzecz to zresztą drobny przykład złej praktyki: datę lepiej przechowywać jako typ Date, a nie napis.

Do zapamiętania na test: _id jest unikalne w kolekcji, niemutowalne i może mieć dowolny typ poza tablicą. Sposoby wyboru klucza to naturalny identyfikator, auto-inkrement, który nie jest zalecany, UUID oraz domyślny ObjectId. ObjectId ma dwanaście bajtów, zawiera znacznik czasu, wartość związaną z maszyną i procesem oraz licznik.

## Pytania projektowe

Slajd siedemdziesiąty piąty stawia pytania, które trzeba sobie zadać przy modelowaniu danych w kolekcjach i dokumentach. MongoDB nie ma jawnego schematu. Jednakże dokumenty w kolekcji są najczęściej do siebie podobne, a niejawny schemat i tak jest wymagany. Co to znaczy? Aplikacja, która czyta dokumenty, oczekuje określonych pól, na przykład że każdy produkt ma pole cena. Schemat nie znika, tylko przenosi się z bazy do kodu aplikacji. Dlatego mówi się czasem, że MongoDB ma schemat elastyczny, a nie brak schematu. Jeśli chcesz, możesz zresztą wymusić strukturę w bazie przez walidację schematu, czyli JSON Schema przypięty do kolekcji.

Wyzwanie projektowe brzmi: zbalansowanie wydajności i stopnia skomplikowania struktury. Mocno zagnieżdżone dokumenty są szybkie w odczycie, ale trudne w aktualizacji i grożą redundancją. Rozbicie danych na wiele kolekcji jest proste i bez powtórzeń, ale wymaga wielu zapytań albo złączeń przez dolar lookup.

Najważniejsze koncepcje, między którymi wybierasz, to dwie: referencje i zagnieżdżone dokumenty.

Do zapamiętania na test: MongoDB nie ma jawnego schematu, ale niejawny schemat i tak jest wymagany, bo dokumenty są zwykle podobne. Główne wyzwanie to równowaga między wydajnością a złożonością struktury, a dwie podstawowe techniki to referencje i zagnieżdżanie.

## Model zdenormalizowany: zagnieżdżone dokumenty

Slajd siedemdziesiąty szósty opisuje model zdenormalizowany, czyli zagnieżdżone dokumenty. Powiązane ze sobą dane umieszcza się w ramach jednego dokumentu. Zagnieżdżone obiekty JSON nazywa się poddokumentami, po angielsku embedded sub-documents. Zaleta: potrzeba mniej zapytań, bo jednym odczytem dostajesz wszystko. Wada: możliwa duża redundancja, czyli powtarzanie tych samych danych w wielu dokumentach. Model ten dobrze nadaje się do związków jeden do jednego i jeden do wielu.

Pierwszy przykład to film: _id równe ObjectId dwa, title Tomb Raider, year dwa tysiące jeden oraz pole actors, czyli tablica trzech obiektów z polami firstname i lastname: Angelina Jolie, Jon Voight i Noah Taylor. Wszyscy aktorzy siedzą w dokumencie filmu. Redundancja pojawi się, gdy Angelina Jolie zagra w kolejnym filmie, bo jej dane trzeba będzie zapisać ponownie. Mała uwaga techniczna: zapis ObjectId z argumentem dwa to uproszczenie z wykładu. Prawdziwy ObjectId wymaga dwudziestu czterech znaków szesnastkowych, więc w mongosh takie wywołanie zgłosiłoby błąd.

Drugi przykład, z dokumentacji MongoDB, to użytkownik: _id, username równe sto dwadzieścia trzy x y z, oraz dwa osadzone poddokumenty: contact z polami phone i email oraz access z polami level równe pięć i group równe dev. Każdy użytkownik ma dokładnie jeden zestaw danych kontaktowych i jeden poziom dostępu, więc to relacje jeden do jednego, idealne do osadzenia.

Do zapamiętania na test: model zdenormalizowany to zagnieżdżone poddokumenty w jednym dokumencie; zaleta to mniej zapytań, wada to możliwa redundancja; pasuje do relacji jeden do jednego i jeden do wielu.

## Model znormalizowany: referencje

Slajd siedemdziesiąty siódmy opisuje model znormalizowany, czyli referencje. Powiązane dane znajdują się w różnych dokumentach, a powiązania realizuje się przez odsyłacze, czyli referencje. W praktyce są to po prostu wartości stanowiące identyfikatory innych dokumentów. Nie ma specjalnego typu referencji, który baza by pilnowała. To ważne: MongoDB nie ma kluczy obcych w sensie SQL, więc nie sprawdza, czy dokument wskazywany przez referencję istnieje, i nie usuwa kaskadowo powiązanych dokumentów. O spójność dba aplikacja. Istnieje co prawda konwencja DBRef, ale to tylko umowny kształt dokumentu, a nie mechanizm wymuszany przez bazę. Właściwości modelu: większa elastyczność, ale może być potrzebnych więcej zapytań. Dobrze nadaje się do związków wiele do wielu.

Przykład: film Tomb Raider, rok dwa tysiące jeden, ale pole actors zawiera teraz tablicę samych identyfikatorów: ObjectId sześć, ObjectId cztery i ObjectId pięć. Strzałka prowadzi do osobnego dokumentu aktora z _id równym ObjectId sześć, imieniem Ian i nazwiskiem Glen. Dane aktora są zapisane raz, a każdy film tylko na nie wskazuje. Żeby wyświetlić film z nazwiskami aktorów, trzeba wykonać drugie zapytanie do kolekcji aktorów albo użyć etapu dolar lookup w agregacji.

Drugi przykład z dokumentacji pokazuje tego samego użytkownika co wcześniej, ale znormalizowanego. Dokument user ma tylko _id i username. Dokument contact ma własne _id, pole user_id wskazujące na _id użytkownika oraz phone i email. Dokument access ma własne _id, pole user_id i pola level oraz group. Strzałki prowadzą od user_id w contact i access do _id w dokumencie user. To dokładnie ten sam wzorzec, co klucz obcy w bazie relacyjnej, tylko bez gwarancji spójności po stronie bazy.

Do zapamiętania na test: model znormalizowany przechowuje powiązane dane w osobnych dokumentach, łączonych wartościami identyfikatorów; nie ma specjalnego typu referencji ani automatycznej kontroli spójności. Daje większą elastyczność kosztem większej liczby zapytań i pasuje do relacji wiele do wielu.

## Redundancja przy osadzaniu: książki i wydawca

Slajd siedemdziesiąty ósmy ilustruje główną wadę osadzania. Tytuł slajdu brzmi: osadzenie dokumentu wydawcy wewnątrz dokumentu książki powtarza dane wydawcy. Mamy dwie książki. Pierwsza to MongoDB: The Definitive Guide, autorzy Kristina Chodorow i Mike Dirolf, data wydania dwudziesty czwarty września dwa tysiące dziesięć, dwieście szesnaście stron, język angielski. Druga to 50 Tips and Tricks for MongoDB Developer, autorka Kristina Chodorow, data szósty maja dwa tysiące jedenaście, sześćdziesiąt osiem stron, angielski. W obu dokumentach osadzony jest identyczny poddokument publisher z nazwą O'Reilly Media, rokiem założenia tysiąc dziewięćset osiemdziesiąt i lokalizacją CA. Ten sam wydawca zapisany dwa razy to redundancja. Gdyby wydawca zmienił siedzibę, trzeba by poprawić każdą jego książkę, a pominięcie jednej powoduje niespójność danych. Zwróć też uwagę na drobny szczegół w przykładzie: w pierwszej książce pole author jest tablicą, a w drugiej zwykłym napisem. MongoDB na to pozwala, ale dla aplikacji to utrudnienie.

Do zapamiętania na test: osadzenie współdzielonego obiektu, takiego jak wydawca, w każdym dokumencie podrzędnym, takim jak książka, powoduje powtarzanie danych i ryzyko niespójności przy aktualizacji.

## Gdzie przechowywać referencję

Slajd siedemdziesiąty dziewiąty odpowiada na pytanie, co zrobić z wydawcą, jeśli używamy referencji. Zasada brzmi: rozwój relacji decyduje o tym, gdzie przechowywać referencję.

Wariant pierwszy: jeśli liczba książek na wydawcę jest niewielka i jej wzrost jest ograniczony, przechowaj referencje do książek w dokumencie wydawcy. Lewa część slajdu pokazuje dokument wydawcy O'Reilly Media z polem books, czyli tablicą identyfikatorów książek: sto dwadzieścia trzy miliony czterysta pięćdziesiąt sześć tysięcy siedemset osiemdziesiąt dziewięć, dwieście trzydzieści cztery miliony pięćset sześćdziesiąt siedem tysięcy osiemset dziewięćdziesiąt i dalej wielokropek. Same książki są osobnymi dokumentami z tymi identyfikatorami jako _id.

Wariant drugi: jeśli liczba książek na wydawcę jest nieograniczona, pierwszy model tworzy zmienne, rosnące tablice. Aby ich uniknąć, przechowuj referencję do wydawcy w dokumencie książki. Prawa część slajdu pokazuje dokument wydawcy z _id równym napisowi oreilly i polami name, founded i location, a każda książka ma pole publisher_id równe oreilly. Teraz każda książka ma jedną, stałą wartość, a dokument wydawcy w ogóle nie rośnie. Zwróć uwagę, że _id wydawcy jest tu napisem, czyli naturalnym identyfikatorem, a nie ObjectId.

Logika jest taka: referencję umieszczasz po tej stronie relacji, która jest „jedna” w sensie liczby wskazań, czyli tam, gdzie nie powstanie rosnąca bez końca tablica. Wydawca może mieć tysiące książek, ale książka ma jednego wydawcę, więc pole publisher_id w książce jest bezpieczne. To dokładnie odpowiada kluczowi obcemu w SQL, który też leży po stronie wielu.

Do zapamiętania na test: przy niewielkiej, ograniczonej liczbie książek można trzymać tablicę ich identyfikatorów w dokumencie wydawcy. Przy nieograniczonej liczbie książek referencję do wydawcy, czyli publisher_id, trzyma się w każdym dokumencie książki, żeby uniknąć rosnących tablic.

## Relacje jeden do jednego i jeden do wielu z osadzaniem

Slajd osiemdziesiąty pokazuje dwa wzorce z dokumentacji MongoDB. Relacja jeden do jednego z osadzonym dokumentem: patron o _id równym joe i imieniu Joe Bookreader ma jedno pole address, które jest poddokumentem z polami street równe 123 Fake Street, city równe Faketon, state równe MA i zip równe dwanaście tysięcy trzysta czterdzieści pięć. Jeden człowiek, jeden adres, jeden poddokument.

Relacja jeden do wielu z osadzonymi dokumentami: ten sam Joe, ale pole nazywa się teraz addresses, w liczbie mnogiej, i jest tablicą dwóch poddokumentów. Pierwszy adres to 123 Fake Street w Faketon, drugi to 1 Some Other Street w Bostonie, oba w stanie MA. Rozpoznasz to po tym, że wartością pola jest tablica obiektów, a nie pojedynczy obiekt.

Do zapamiętania na test: relację jeden do jednego modeluje się osadzonym poddokumentem jako wartością pola, a relację jeden do wielu tablicą osadzonych poddokumentów.

## Relacja wiele do wielu z osadzaniem

Slajd osiemdziesiąty pierwszy pokazuje, że relację wiele do wielu też można modelować przez osadzanie. Mamy dwie książki. Book001, Cell Biology, ma tablicę authors z dwoma autorami: author_id równe author124 i name równe Ellie Smith oraz author_id równe author381 i name równe John Palmer. Book002, Organic Chemistry, ma autorów author290, Jane James, oraz znowu author381, John Palmer. Na slajdzie John Palmer jest zaznaczony czerwoną ramką w obu książkach. Ten sam autor jest osadzony w dwóch dokumentach, bo książka ma wielu autorów, a autor wiele książek.

To podejście w praktyce jest hybrydowe: w każdym wpisie jest identyfikator autora, czyli referencja, oraz kopia jego nazwiska, czyli osadzenie. Dzięki temu listę książek z autorami wyświetlasz jednym zapytaniem, a pełne dane autora możesz w razie potrzeby pobrać po author_id. Ceną jest redundancja: jeśli John Palmer zmieni nazwisko, trzeba poprawić wszystkie jego książki. Ten wzorzec opłaca się, gdy kopiowane dane, jak nazwisko, rzadko się zmieniają.

Do zapamiętania na test: relację wiele do wielu można osadzić, powtarzając dane wspólnego obiektu, na przykład autora, w wielu dokumentach; często łączy się to z identyfikatorem, czyli podejściem hybrydowym. Wadą jest redundancja, a klasycznym rozwiązaniem dla wiele do wielu pozostają referencje.

## Antywzorce projektowania schematów

Slajd osiemdziesiąty drugi wymienia pięć antywzorców, czyli typowych błędów w projektowaniu schematu MongoDB. Nazwy na slajdzie są maszynowo tłumaczone z dokumentacji, więc podam też ich sens.

Pierwszy: unikaj tablic nieograniczonych, po angielsku unbounded arrays. Dokument przechowuje tablicę, która może rosnąć bez końca. Duża tablica może przekroczyć limit rozmiaru dokumentu, czyli szesnaście megabajtów, i spowodować spadek wydajności indeksu, bo indeks na polu tablicowym ma osobny wpis dla każdego elementu. Na slajdzie jest niezręczne sformułowanie „może urosnąć do zbyt dużej odległości”; chodzi po prostu o to, że może urosnąć zbyt duża.

Drugi: zmniejszenie liczby kolekcji. Na slajdzie jest napisane „zbiorów”, ale chodzi o kolekcje. Antywzorzec polega na tworzeniu bardzo dużej liczby kolekcji w bazie. Zbyt wiele kolekcji obniża wydajność silnika pamięci masowej, bo każda kolekcja i każdy indeks to osobne pliki i struktury w silniku WiredTiger. Typowy błąd to osobna kolekcja na każdy dzień albo każdego klienta.

Trzeci: usuń niepotrzebne indeksy. Kolekcja zawiera zbędne indeksy, na przykład nieużywane albo zdublowane przez indeks złożony. Niepotrzebne indeksy zajmują miejsce na dysku i w pamięci oraz pogarszają wydajność zapisu, bo każdy zapis musi aktualizować wszystkie indeksy.

Czwarty: ogranicz nadmiar dokumentów, czyli unikaj zbyt obszernych dokumentów, po angielsku bloated documents. Kolekcja zawiera bardzo duże dokumenty, w których wiele pól jest rzadko używanych. Duże dokumenty pogarszają wydajność najczęściej wykonywanych zapytań, bo do pamięci trzeba wczytać cały dokument, nawet gdy potrzebujesz dwóch pól. Rozwiązaniem jest wydzielenie rzadko używanych danych do osobnej kolekcji.

Piąty: ograniczenie operacji dolar lookup. Wykonujesz zbyt wiele operacji dolar lookup, czyli złączeń między kolekcjami. Zwiększa to złożoność zapytań i obniża ich wydajność. Jeśli ciągle łączysz dwie kolekcje, to znak, że dane odczytywane razem powinny być przechowywane razem, czyli osadzone.

Zauważ, że antywzorce ciągną w przeciwne strony. Zbyt duże dokumenty i nieograniczone tablice karzą za przesadne osadzanie, a nadmiar dolar lookup karze za przesadną normalizację. Dobry schemat leży pośrodku i wynika z tego, jak aplikacja używa danych.

Do zapamiętania na test: pięć antywzorców to nieograniczone tablice, zbyt wiele kolekcji, niepotrzebne indeksy, zbyt duże dokumenty i nadmiar operacji dolar lookup. Skutki to odpowiednio przekroczenie limitu i wolniejszy indeks, obciążenie silnika pamięci, zajęte miejsce i wolniejsze zapisy, wolniejsze częste zapytania oraz złożone i wolne zapytania.

## Interfejs aplikacyjny: powłoka i sterowniki

Slajd osiemdziesiąty trzeci opisuje, jak aplikacje i ludzie rozmawiają z MongoDB. Pierwszy sposób to powłoka, na slajdzie nazwana mongoshell, czyli interaktywna linia komend MongoDB. Przykład wywołania: kropka, ukośnik, bin, ukośnik, mongo, minus minus username, nazwa użytkownika, minus minus password, hasło, minus minus host, adres hosta, minus minus port, dwadzieścia osiem zero piętnaście. Dwie uwagi. Polecenie mongo to stara powłoka; dziś używa się mongosh, z tymi samymi przełącznikami, na przykład mongosh minus minus username, minus minus password, minus minus host, minus minus port, albo po prostu z connection stringiem. Port dwadzieścia osiem zero piętnaście na slajdzie to przykład niestandardowego portu; domyślnym portem MongoDB jest dwadzieścia siedem zero siedemnaście.

Drugi sposób to sterowniki, czyli biblioteki dla języków programowania. Slajd wymienia Javę, C, C++, C#, Perla, PHP, Pythona, Rubiego, Scalę i inne. Lista rozwijana w dokumentacji pokazuje: MongoDB Shell, Compass, C#, Go, Java w wersji asynchronicznej i synchronicznej, Motor, czyli asynchroniczny sterownik dla Pythona, Node.js, Perl, PHP, Python, Ruby i Scala. Sterownik do Pythona nazywa się PyMongo.

Slajd pokazuje to samo zapytanie w trzech językach. W MongoDB Shell: db kropka inventory kropka find, a w nawiasie pusty dokument w klamrach, co zwraca wszystkie dokumenty kolekcji inventory. W Node.js: const cursor równa się db kropka collection, w nawiasie napis inventory, kropka find, a w nawiasie klamry z item dwukropek canvas. W Pythonie: cursor równa się db kropka inventory kropka find, a w nawiasie słownik, czyli klamry z kluczem item w cudzysłowie, dwukropek, canvas w cudzysłowie. Zwróć uwagę na różnice. W Node.js kolekcję wybiera się metodą collection z nazwą w nawiasie, a w Pythonie i w powłoce przez kropkę. W Pythonie klucze słownika muszą być w cudzysłowie, a w JavaScripcie nie muszą. Wszędzie wynikiem find jest kursor.

Do zapamiętania na test: z MongoDB pracuje się przez interaktywną powłokę, dawniej mongo, dziś mongosh, albo przez sterowniki dla wielu języków, takich jak Java, C#, Python, Node.js, PHP, Ruby czy Scala. Find w każdym z nich zwraca kursor.

## Język zapytań MongoDB

Slajd osiemdziesiąty czwarty to infografika „Język zapytań”. Jej główna teza: zapytania w MongoDB, w powłoce mongosh, bazują na JavaScripcie. Mongosh jest w pełni funkcjonalnym środowiskiem JavaScriptu, więc możesz w nim używać zmiennych, pętli i funkcji.

W ramce w rogu są cztery ważne zdania. Możesz wykonać pojedynczą komendę lub cały zestaw komend, na przykład skrypt. Zapytania odczytu zwracają kursor, po angielsku cursor, który umożliwia iterowanie po wybranych dokumentach. I wreszcie każda komenda dotyczy pojedynczej kolekcji. To ostatnie jest ważne: zwykłe find nie łączy kolekcji; łączenie robi się etapem dolar lookup w agregacji.

Infografika pokazuje strukturę: serwer MongoDB, w nim baza danych sklep, a w niej kolekcja produkty z dokumentami, na przykład nazwa Laptop, kategoria Elektronika, cena cztery tysiące dziewięćset dziewięćdziesiąt dziewięć, ocena cztery i pół, oraz nazwa Mysz, kategoria Elektronika, cena dziewięćdziesiąt dziewięć, ocena cztery przecinek osiem.

Sekcja „Jak działa zapytanie” pokazuje przepływ: aplikacja albo mongosh wysyła zapytanie w JavaScripcie do bazy, na przykład db kropka produkty kropka find, w nawiasie klamry z kategoria dwukropek Elektronika, a baza odsyła wynik w postaci kursora. Następnie piszemy const cursor równa się to samo zapytanie, a potem cursor kropka forEach, a w nawiasie funkcja strzałkowa doc, strzałka, print doc. Pętla forEach przechodzi po kolejnych dokumentach i wypisuje każdy z nich. Kursor jest leniwy: dokumenty są pobierane z serwera partiami w miarę iterowania, a nie wszystkie naraz. W mongosh, jeśli nie przypiszesz kursora do zmiennej, powłoka sama wyświetla pierwszych dwadzieścia dokumentów, a kolejne pokazuje po wpisaniu it.

Sekcja „Podstawowe operacje CRUD na pojedynczej kolekcji” ma cztery kafelki. Create, czyli dodawanie: db kropka produkty kropka insertOne, a w nawiasie dokument z nazwą Klawiatura, kategorią Elektronika, ceną sto dziewięćdziesiąt dziewięć i oceną cztery przecinek siedem. Read, czyli odczyt: db kropka produkty kropka find, w nawiasie klamry z cena dwukropek, i znowu klamry z dolar g t dwukropek sto, czyli produkty droższe niż sto. Update, czyli aktualizacja: db kropka produkty kropka updateOne z dwoma argumentami; pierwszy to filtr, klamry z _id dwukropek ObjectId, drugi to klamry z dolar set dwukropek, i w klamrach cena dwukropek sto siedemdziesiąt dziewięć. Delete, czyli usuwanie: db kropka produkty kropka deleteOne, w nawiasie filtr z _id. Pamiętaj, że w update bez operatora dolar set, czyli z samym dokumentem cena sto siedemdziesiąt dziewięć, nowsze wersje MongoDB zgłoszą błąd, bo updateOne wymaga operatorów aktualizacji; zwykły dokument przyjmuje replaceOne.

Sekcja „Agregacje” pokazuje potok grupujący. Piszemy db kropka produkty kropka aggregate, a w nawiasie tablica z jednym etapem: klamry, dolar group, dwukropek, i w klamrach trzy pola. Pierwsze to _id dwukropek napis dolar kategoria, w cudzysłowie, co oznacza grupuj według wartości pola kategoria. Dolar przed nazwą pola w napisie oznacza odwołanie do wartości tego pola. Drugie to liczba dwukropek, w klamrach dolar sum dwukropek jeden, czyli dodaj jeden za każdy dokument, co daje liczbę dokumentów w grupie. Trzecie to sredniaCena dwukropek, w klamrach dolar avg dwukropek napis dolar cena, czyli średnia z pola cena. Wynik to tablica dokumentów, po jednym na kategorię, na przykład _id Elektronika, liczba dwanaście, sredniaCena tysiąc dwieście pięćdziesiąt oraz _id Akcesoria, liczba osiem, sredniaCena osiemdziesiąt pięć. Klucz grupowania zawsze trafia do pola _id wyniku. To odpowiednik SQL: SELECT kategoria, COUNT gwiazdka, AVG cena FROM produkty GROUP BY kategoria.

Infografika wspomina też MapReduce jako zaawansowane przetwarzanie danych w MongoDB. Uwaga: MapReduce jest w MongoDB przestarzały od wersji pięć zero, a dokumentacja zaleca zamiast niego potok agregacji, który jest szybszy i prostszy. Na teście może się pojawić hasło MapReduce jako sposób agregacji, i zgodnie ze slajdem jest to prawda, ale współcześnie podstawowym narzędziem jest aggregate.

Do zapamiętania na test: zapytania w mongosh opierają się na JavaScripcie, każda komenda dotyczy jednej kolekcji, a zapytania odczytu zwracają kursor, po którym można iterować, na przykład przez forEach. W dolar group pole _id określa klucz grupowania, dolar sum jeden liczy dokumenty, dolar avg liczy średnią, a odwołanie do pola zapisuje się jako napis z dolarem przed nazwą. MapReduce to starszy, dziś przestarzały mechanizm agregacji.

## SQL kontra MongoDB: pojęcia

Slajd osiemdziesiąty piąty, wzięty z dokumentacji MongoDB, zestawia pojęcia SQL z pojęciami MongoDB. Database w SQL to database w MongoDB. Table, czyli tabela, to collection, czyli kolekcja. Row, czyli wiersz, to document, albo BSON document. Column, czyli kolumna, to field, czyli pole. Index to index, bez zmian. Table joins, czyli złączenia tabel, mają dwa odpowiedniki: etap agregacji dolar lookup oraz dokumenty osadzone, bo osadzenie usuwa potrzebę złączenia. Primary key to primary key, ale z różnicą: w SQL kluczem głównym może być dowolna unikalna kolumna albo kombinacja kolumn, a w MongoDB klucz główny jest automatycznie ustawiany na pole _id.

Do zapamiętania na test: tabela to kolekcja, wiersz to dokument, kolumna to pole, złączenie to dolar lookup albo osadzanie, a klucz główny w MongoDB to zawsze pole _id.

## SQL kontra MongoDB: przykłady poleceń schematu

Slajd osiemdziesiąty szósty zapowiada porównanie poleceń SQL i MongoDB ze strony dokumentacji o adresie mongodb kropka com, ukośnik docs, ukośnik manual, ukośnik reference, ukośnik sql minus comparison. Przykłady SQL zakładają tabelę people, a przykłady MongoDB kolekcję people z dokumentami o prototypie: _id równe ObjectId, user_id równe napisowi abc123, age równe pięćdziesiąt pięć i status równe A.

Slajd osiemdziesiąty siódmy porównuje tworzenie i zmianę struktury. Na slajdzie nagłówek prawej kolumny brzmi „Oświadczenia schematu MongoDB”, co jest maszynowym tłumaczeniem angielskiego statements; chodzi o polecenia schematu.

Tworzenie tabeli w SQL wygląda tak: CREATE TABLE people, a w nawiasie kolumny: id typu MEDIUMINT NOT NULL AUTO_INCREMENT, user_id typu Varchar trzydzieści, age typu Number, status typu char jeden, oraz PRIMARY KEY id. W MongoDB odpowiednika nie trzeba wykonywać. Kolekcja jest tworzona niejawnie podczas pierwszej operacji insertOne albo insertMany. Klucz podstawowy _id jest dodawany automatycznie, jeśli nie podasz pola _id. Przykład: db kropka people kropka insertOne, a w nawiasie klamry z user_id abc123, age pięćdziesiąt pięć i status A. Jeśli kolekcja people nie istniała, zostanie utworzona w tym momencie. Kolekcję można też utworzyć jawnie: db kropka createCollection, a w nawiasie napis people. Jawne tworzenie przydaje się, gdy chcesz podać opcje, na przykład walidację schematu albo kolekcję ograniczoną, czyli capped.

Dodanie kolumny w SQL: ALTER TABLE people ADD join_date DATETIME. W MongoDB kolekcje nie opisują ani nie wymuszają struktury swoich dokumentów, więc nie ma zmian strukturalnych na poziomie kolekcji. Na poziomie dokumentów możesz jednak dodać pole do istniejących dokumentów operacją updateMany z operatorem dolar set: db kropka people kropka updateMany, pierwszy argument to pusty filtr w klamrach, czyli wszystkie dokumenty, drugi to klamry z dolar set dwukropek, i w klamrach join_date dwukropek new Date z pustymi nawiasami, czyli bieżąca data. Zauważ, że nie jest to konieczne: nowe dokumenty mogą mieć pole join_date, a stare nie, i baza to zaakceptuje.

Do zapamiętania na test: odpowiednikiem CREATE TABLE jest niejawne utworzenie kolekcji przy pierwszym insertOne albo insertMany, albo jawne db kropka createCollection. Odpowiednikiem ALTER TABLE ADD jest updateMany z pustym filtrem i operatorem dolar set. Pole _id dodaje się automatycznie.

## SQL kontra MongoDB: usuwanie kolumn, indeksy i usuwanie tabeli

Slajd osiemdziesiąty ósmy dokańcza porównanie. Usunięcie kolumny w SQL: ALTER TABLE people DROP COLUMN join_date. W MongoDB znów nie ma zmiany strukturalnej na poziomie kolekcji, ale updateMany może usunąć pole z dokumentów operatorem dolar unset: db kropka people kropka updateMany, pierwszy argument pusty filtr, drugi klamry z dolar unset dwukropek, i w klamrach join_date w cudzysłowie dwukropek pusty napis. Wartość podana przy dolar unset nie ma znaczenia; zwyczajowo pisze się pusty napis albo jedynkę. Liczy się nazwa pola.

Utworzenie indeksu w SQL: CREATE INDEX idx_user_id_asc ON people, w nawiasie user_id. W MongoDB: db kropka people kropka createIndex, a w nawiasie klamry z user_id dwukropek jeden, czyli indeks rosnący na polu user_id.

Indeks złożony w SQL: CREATE INDEX idx_user_id_asc_age_desc ON people, w nawiasie user_id, przecinek, age DESC. W MongoDB: db kropka people kropka createIndex, a w nawiasie klamry z user_id dwukropek jeden, przecinek, age dwukropek minus jeden. Jedynka to rosnąco, odpowiednik ASC, minus jedynka to malejąco, odpowiednik DESC. Kolejność pól w indeksie złożonym ma znaczenie, tak samo jak w SQL: taki indeks pomoże zapytaniom po samym user_id albo po user_id i age, ale nie zapytaniom po samym age.

Usunięcie tabeli w SQL: DROP TABLE people. W MongoDB: db kropka people kropka drop, z pustymi nawiasami. Usuwa kolekcję wraz z dokumentami i indeksami.

Do zapamiętania na test: ALTER TABLE DROP COLUMN to updateMany z pustym filtrem i dolar unset; CREATE INDEX to createIndex z polem i jedynką; indeks z DESC to minus jedynka, na przykład createIndex z user_id jeden i age minus jeden; DROP TABLE to db kropka people kropka drop.

To już koniec drugiego działu. Podsumujmy w kilku zdaniach. Serwerem jest mongod, klientem mongosh, a domyślny port to dwadzieścia siedem tysięcy siedemnaście. MongoDB przechowuje dokumenty w formacie BSON, w kolekcjach, w bazach danych, a pojedynczy dokument może mieć najwyżej szesnaście megabajtów. Każdy dokument ma niezmienne i unikalne pole _id, domyślnie dwunastobajtowy ObjectId. Dane czytane razem osadzaj, dane współdzielone, duże lub rosnące bez ograniczeń trzymaj w osobnych kolekcjach i łącz referencjami. Unikaj pięciu antywzorców i pamiętaj, jak polecenia SQL przekładają się na metody MongoDB. W następnym dziale przejdziemy do szczegółowej pracy z bazami, kolekcjami i operacjami CRUD.



# 3. MongoDB — CRUD, operatory zapytań, projekcja i modyfikatory kursora

Witaj w trzecim dziale. To jest dział, w którym kończy się teoria o tym, czym MongoDB jest, a zaczyna praca w konsoli. Na teście właśnie stąd pochodzi większość pytań o składnię, więc słuchaj uważnie, a najlepiej po każdym podrozdziale powtórz sobie na głos kilka poleceń.

Przejdziemy przez wszystko po kolei, w takiej kolejności, jak na wykładzie. Najpierw powłoka mongosh: jak wyświetlić listę baz, jak przełączyć się na bazę, jak ją usunąć, jak założyć i skasować kolekcję, także kolekcję o ograniczonym rozmiarze, czyli capped. Potem wstawianie dokumentów metodami insertOne i insertMany, liczenie dokumentów i pole podkreślnik id. Dalej aktualizacja: updateOne, updateMany, replaceOne, tryb zmień i tryb zamień, operatory pól, takie jak dolar set, dolar unset, dolar rename, dolar inc, dolar mul i dolar currentDate, oraz operatory tablicowe, takie jak dolar push, dolar addToSet, dolar pop i dolar pull. Omówimy tryb upsert. Potem usuwanie: deleteOne, deleteMany, findOneAndDelete, findAndModify i operacje zbiorcze bulkWrite. Druga połowa działu to odczyt: metoda find, selekcja, równość wartości, notacja kropkowa, operatory porównania, logiczne, tablicowe, dolar exists, dolar regex, dolar text, dolar expr, dolar not, zasady przeszukiwania tablic, projekcja z operatorami dolar elemMatch i dolar slice, a na końcu modyfikatory kursora sort, limit i skip oraz duże porównanie zapytań SQL z ich odpowiednikami w MongoDB.

Jedna uwaga techniczna na start. Kiedy mówię „dolar”, mam na myśli znak dolara, którym w MongoDB zaczyna się nazwa każdego operatora. Kiedy mówię „klamry”, chodzi o nawiasy klamrowe, które otaczają dokument. Kiedy mówię „nawias kwadratowy”, chodzi o tablicę.

## 3.1. Powłoka mongosh, bazy danych i kolekcje

### Polecenie help i lista baz

Zaczynamy od konsoli. Współczesna powłoka MongoDB nazywa się mongosh, czyli MongoDB Shell. Na slajdzie widzisz okno, w którym połączenie idzie pod adres mongodb, dwukropek, dwa ukośniki, sto dwadzieścia siedem, kropka, zero, kropka, zero, kropka, jeden, dwukropek, dwadzieścia siedem tysięcy siedemnaście. To jest domyślny port MongoDB: 27017. Warto go zapamiętać, bo bywa pytaniem.

Po uruchomieniu powłoki znak zachęty pokazuje nazwę bieżącej bazy. Na slajdzie jest to „test”, bo właśnie do bazy test mongosh podłącza się domyślnie, gdy nie wskażesz innej.

Pierwsze polecenie to help. Wypisuje pomoc powłoki. Z tej pomocy wykład pokazuje kilka pozycji. Polecenie use ustawia bieżącą bazę danych. Polecenie show ma kilka wariantów. Show dbs albo show databases, oba zapisy są równoważne, wypisuje listę wszystkich dostępnych baz. Show collections albo show tables wypisuje listę kolekcji w bieżącej bazie. Tu znowu dwa zapisy robią to samo, a słowo tables zostało dla wygody osób przychodzących z SQL. Show profile wypisuje informacje z kolekcji system kropka profile, czyli z profilera zapytań. Show users wypisuje użytkowników bieżącej bazy, show roles wypisuje role bieżącej bazy. Show log, a po nim typ, pokazuje log dla bieżącego połączenia, a gdy typu nie podasz, używany jest typ global. Show logs wypisuje wszystkie logi. Wreszcie exit kończy pracę powłoki, i można to napisać na trzy sposoby: exit, exit z nawiasami okrągłymi albo kropka exit.

Drugi zrzut ekranu pokazuje wynik show dbs i show databases. Oba dają identyczną listę: admin, czterdzieści kibibajtów, config, sto osiem kibibajtów, customers, sto dwadzieścia kibibajtów, i local, siedemdziesiąt dwa kibibajty. Slajd podkreśla, że trzy z nich to bazy systemowe: admin, config i local. Customers to baza użytkownika.

Krótko, do czego służą bazy systemowe, bo to dobra wiedza w tle. Baza admin przechowuje między innymi dane uwierzytelniania i uprawnień, a niektóre polecenia administracyjne wykonuje się właśnie w jej kontekście. Baza config jest używana przy shardingu do przechowywania metadanych klastra, a na pojedynczym serwerze trzyma też informacje wewnętrzne, na przykład o sesjach. Baza local nie jest replikowana; trzyma dane lokalne konkretnej instancji, w tym oplog, czyli dziennik operacji używany w replikacji.

Ważna pułapka: show dbs pokazuje tylko te bazy, które fizycznie zawierają dane. Jeżeli wpiszesz use nowa_baza i nic do niej nie zapiszesz, nie zobaczysz jej na liście.

### Tworzenie, przełączanie i usuwanie bazy

Kolejny slajd zbiera polecenia dotyczące baz. Samo słowo db, wpisane w konsoli, wyświetla bazę, w której aktualnie jesteś. Polecenie use customers przełącza bieżącą bazę na customers. Polecenie db, kropka, dropDatabase, z pustymi nawiasami okrągłymi, kasuje aktualną bazę danych, czyli tę, w której właśnie się znajdujesz.

Slajd podaje też ściągawkę. Tworzenie albo użycie bazy danych: use, spacja, nazwa bazy. Usuwanie bazy: db kropka dropDatabase, nawiasy. Wyświetlenie bazy, w której jesteś: db. Wyświetlenie dostępnych baz: show dbs albo show databases.

Zwróć uwagę na słowa „tworzenie albo użycie”. W MongoDB nie ma osobnego polecenia w stylu CREATE DATABASE. Polecenie use przełącza kontekst na podaną nazwę, a baza powstaje naprawdę dopiero w chwili, gdy zapiszesz do niej pierwszą kolekcję albo pierwszy dokument. To jest typowe dla MongoDB leniwe tworzenie: struktury pojawiają się wtedy, gdy są potrzebne.

Zrzut ekranu pokazuje przykład. Wpisujemy use northwind, konsola odpowiada switched to db northwind, czyli przełączono na bazę northwind. Następnie db kropka dropDatabase, a konsola odpowiada dokumentem: w klamrach ok, dwukropek, jeden, przecinek, dropped, dwukropek, northwind w apostrofach. Ok równe jeden oznacza sukces, a dropped mówi, która baza została skasowana. Zauważ, że dropDatabase nie przyjmuje nazwy bazy jako argumentu. Kasuje bazę bieżącą, dlatego najpierw trzeba się do niej przełączyć przez use.

### Kolekcje i kolekcje capped

Kolekcja, jak mówi slajd, to segregator do przechowywania dokumentów. W języku baz relacyjnych odpowiada tabeli, ale bez narzuconego schematu.

Kolekcję tworzymy jawnie poleceniem db, kropka, createCollection, a w nawiasie, w cudzysłowie, nazwa kolekcji, na przykład products. Kasujemy ją poleceniem db, kropka, nazwa kolekcji, kropka, drop, nawiasy. Czyli db kropka products kropka drop. Zwróć uwagę na asymetrię: createCollection wywołujemy na obiekcie db i nazwę podajemy jako tekst, a drop wywołujemy na samej kolekcji i nie podajemy żadnego argumentu. Podobna asymetria jest przy bazie: use z nazwą, ale dropDatabase bez nazwy.

Pełna postać createCollection ma drugi, opcjonalny argument: dokument opcji. Slajd wymienia trzy opcje. Pierwsza to capped, przyjmuje true albo false. Kolekcja capped, po polsku kolekcja o ograniczonym rozmiarze, działa jak bufor cykliczny: jeżeli nowy dokument spowodowałby przekroczenie limitu size, MongoDB usuwa najstarsze dokumenty, żeby zwolnić miejsce. Capped wymaga podania parametru size. Druga opcja to max, czyli maksymalna liczba dokumentów, jakie mogą być w kolekcji. Trzecia to size, czyli maksymalny rozmiar kolekcji w bajtach.

Dwa przykłady w niebieskich ramkach. Pierwszy: db kropka createCollection, w nawiasie nazwa logi w cudzysłowie, przecinek, a potem w klamrach capped dwukropek true, przecinek, size dwukropek dziesięć milionów czterysta osiemdziesiąt pięć tysięcy siedemset sześćdziesiąt. Ta liczba to dokładnie dziesięć mebibajtów, czyli dziesięć razy tysiąc dwadzieścia cztery razy tysiąc dwadzieścia cztery bajty. Drugi przykład jest taki sam, ale dodaje max dwukropek dziesięć tysięcy. Wtedy kolekcja ma dwa limity naraz: rozmiar w bajtach i liczbę dokumentów. Najstarsze dokumenty wypadają, gdy zostanie osiągnięty którykolwiek z nich.

Dlaczego kolekcja capped nazywa się logi? Bo to klasyczne zastosowanie. Logi przyrastają bez końca, a zwykle interesują nas tylko najnowsze wpisy. Kolekcja capped zachowuje kolejność wstawiania i sama pozbywa się najstarszych dokumentów, więc nie trzeba pisać żadnego mechanizmu sprzątania. Pułapka na test: opcja max bez size nie wystarczy, bo size jest obowiązkowy dla kolekcji capped. I druga pułapka: size jest w bajtach, nie w megabajtach ani w liczbie dokumentów.

Do zapamiętania na test: domyślny port to 27017, a domyślna baza w mongosh to test. Show dbs i show databases są równoważne, tak samo show collections i show tables. Bazy systemowe to admin, config i local. Use nazwa przełącza bazę i jednocześnie jest sposobem jej utworzenia, bo baza powstaje przy pierwszym zapisie. Db kropka dropDatabase kasuje bieżącą bazę. Kolekcję tworzy db kropka createCollection z nazwą w cudzysłowie, a kasuje db kropka nazwa kropka drop. Kolekcja capped wymaga size w bajtach, max ogranicza liczbę dokumentów, a po przekroczeniu limitu usuwane są najstarsze dokumenty.

## 3.2. Wstawianie i liczenie dokumentów

### insertOne i insertMany

Do wstawiania dokumentów służą dwie metody. Metoda insertOne dodaje dokładnie jeden dokument. Składnia: db, kropka, nazwa kolekcji, kropka, insertOne, a w nawiasie jeden dokument w klamrach. Metoda insertMany pozwala dodać kilka dokumentów naraz, a dokumenty umieszczamy w liście, czyli w tablicy. Składnia: db, kropka, nazwa kolekcji, kropka, insertMany, w nawiasie okrągłym nawias kwadratowy, w nim dokumenty w klamrach rozdzielone przecinkami, i zamknięcie nawiasu kwadratowego.

To jest bardzo częste pytanie: insertMany przyjmuje tablicę. Jeżeli napiszesz insertMany i podasz kilka dokumentów bez nawiasu kwadratowego, dostaniesz błąd. Jeżeli insertOne podasz tablicę, też dostaniesz błąd, bo insertOne oczekuje jednego dokumentu.

Slajd zawiera tabelkę, którą opowiem: insertOne służy do dodania jednego dokumentu, a insertMany do dodania wielu dokumentów w jednej operacji.

Należy pamiętać, że insertOne i insertMany utworzą kolekcję, jeżeli takowa nie istnieje. Nie musisz więc wcześniej wołać createCollection. Jawne createCollection przydaje się wtedy, gdy chcesz nadać kolekcji opcje, na przykład capped, albo regułę walidacji.

Wskazówka ze slajdu: insertMany jest zwykle bardziej wydajne niż wielokrotne wywoływanie insertOne, gdy dodajemy większą liczbę dokumentów. Powód jest prosty. Każde wywołanie insertOne to osobna podróż do serwera i z powrotem. InsertMany wysyła paczkę dokumentów w jednym żądaniu, więc oszczędza czas sieci i narzut serwera.

### Liczenie dokumentów

Są dwie metody liczenia. Metoda countDocuments służy do zliczania dokumentów w kolekcji na podstawie określonego filtra. Daje dokładny wynik, ale może wymagać odczytania wszystkich dokumentów kolekcji. Przykład: db kropka inventory kropka countDocuments, puste nawiasy. Bez filtra liczy wszystkie dokumenty. Z filtrem, na przykład countDocuments, w klamrach status dwukropek A, liczy tylko pasujące.

Metoda estimatedDocumentCount daje przybliżoną liczbę dokumentów w kolekcji, bez żadnego filtra. Korzysta z metadanych kolekcji, a nie z przeglądania dokumentów, więc jest zwykle szybsza niż countDocuments. Przykład: db kropka inventory kropka estimatedDocumentCount, puste nawiasy.

Na test zapamiętaj różnicę w trzech słowach: countDocuments to filtr i dokładność, estimatedDocumentCount to brak filtra, metadane i szybkość. Jeżeli pytanie brzmi „która metoda pozwala policzyć dokumenty spełniające warunek”, odpowiedzią jest countDocuments. Jeżeli „która korzysta z metadanych”, odpowiedzią jest estimatedDocumentCount. Dawna metoda count, którą zobaczysz pod koniec działu w tabelach porównawczych, jest przestarzała i zastąpiły ją właśnie te dwie.

### Operacje Create i pole _id

Następne slajdy pochodzą z oficjalnej dokumentacji MongoDB o operacjach CRUD. Skrót CRUD to Create, Read, Update, Delete, czyli tworzenie, odczyt, aktualizacja i usuwanie.

Operacje tworzenia, czyli wstawiania, dodają nowe dokumenty do kolekcji. Jeżeli kolekcja nie istnieje, operacja wstawiania ją utworzy. MongoDB udostępnia do tego db kropka collection kropka insertOne i db kropka collection kropka insertMany. W MongoDB operacje wstawiania są skierowane do pojedynczej kolekcji, czyli jednym poleceniem nie wstawisz dokumentów do dwóch kolekcji naraz. Wszystkie operacje zapisu w MongoDB są atomowe na poziomie pojedynczego dokumentu. To zdanie jest bardzo ważne i powtórzy się przy aktualizacji i usuwaniu. Oznacza, że zmiana jednego dokumentu, nawet z zagnieżdżonymi poddokumentami i tablicami, zachodzi w całości albo wcale. Natomiast operacja na wielu dokumentach, na przykład insertMany albo updateMany, nie jest jako całość atomowa: część dokumentów może się zapisać, a część nie. Do atomowości wielu dokumentów służą transakcje, ale to inny temat.

Przykład: db kropka users kropka insertOne, a w nawiasie dokument z polami name: sue, age: dwadzieścia sześć i status: pending. Diagram z dokumentacji nazywa części polecenia. Users to kolekcja, collection. Każda linia, na przykład name dwukropek sue, to para pole i wartość, field: value. Całość w klamrach to dokument, document.

Porównanie z SQL. Instrukcja INSERT INTO people, w nawiasie user_id, age, status, VALUES, w nawiasie bcd001, czterdzieści pięć i A, odpowiada w MongoDB poleceniu db kropka people kropka insertOne, a w nawiasie, w klamrach, user_id dwukropek bcd001, age dwukropek czterdzieści pięć, status dwukropek A. W SQL nazwy kolumn i wartości są w dwóch osobnych listach, a w MongoDB każda wartość stoi od razu przy nazwie pola.

Kolejny slajd pokazuje bogatsze dokumenty z kolekcji inventory, czyli magazynu. InsertOne wstawia przedmiot canvas, czyli płótno, z polem qty równym sto, z polem tags, które jest tablicą z jednym elementem cotton, i z polem size, które jest zagnieżdżonym dokumentem z polami h dwadzieścia osiem, w trzydzieści pięć i pół oraz uom cm. Skrót uom oznacza unit of measure, jednostkę miary. Potem insertMany wstawia tablicę trzech dokumentów: journal z qty dwadzieścia pięć i tagami blank i red, mat z qty osiemdziesiąt pięć i tagiem gray, oraz mousepad z qty dwadzieścia pięć i tagami gel i blue. Każdy ma też zagnieżdżony dokument size. Na slajdzie linie są ucięte po prawej stronie, ale schemat jest ten sam. Te przykłady pokazują, że dokument może zawierać tablice i poddokumenty, i że dokumenty w jednej kolekcji mogą mieć różne wartości tych struktur.

Teraz pole podkreślnik id. W MongoDB każdy dokument przechowywany w kolekcji wymaga unikalnego pola podkreślnik id, które działa jak klucz podstawowy. Jeżeli we wstawianym dokumencie pominięto pole podkreślnik id, sterownik MongoDB automatycznie wygeneruje dla niego identyfikator typu ObjectId. Na slajdzie słowa zlały się w „_idpole”, chodzi oczywiście o „pole _id”. ObjectId to dwunastobajtowa wartość, zapisywana jako dwadzieścia cztery znaki szesnastkowe, która zawiera między innymi znacznik czasu utworzenia. Dzięki temu identyfikatory generowane po stronie klienta są praktycznie unikalne bez pytania serwera. Możesz też podać własne podkreślnik id, na przykład liczbę albo tekst, ale wtedy sam odpowiadasz za unikalność. Próba wstawienia drugiego dokumentu z tym samym podkreślnik id kończy się błędem duplikatu klucza.

Do zapamiętania na test: insertOne przyjmuje jeden dokument, insertMany tablicę dokumentów w nawiasie kwadratowym. Obie metody tworzą kolekcję, gdy jej nie ma. InsertMany jest wydajniejsze od wielu wywołań insertOne. CountDocuments liczy dokładnie i przyjmuje filtr, estimatedDocumentCount liczy z metadanych, bez filtra i szybciej. Zapis w MongoDB jest atomowy na poziomie pojedynczego dokumentu. Każdy dokument ma unikalne podkreślnik id, a gdy go pominiesz, powstaje automatyczny ObjectId.

## 3.3. Aktualizacja dokumentów

### updateOne, updateMany, replaceOne

Operacje aktualizacji modyfikują istniejące dokumenty w kolekcji. MongoDB udostępnia trzy metody: db kropka collection kropka updateOne, updateMany oraz replaceOne. Podobnie jak przy wstawianiu, operacje aktualizacji dotyczą jednej kolekcji, a każdy zapis jest atomowy na poziomie pojedynczego dokumentu.

Dokumenty do aktualizacji wskazujesz filtrem, a filtry używają tej samej składni co operacje odczytu. To dobra wiadomość: wszystko, czego nauczysz się o metodzie find, przenosi się wprost na update i delete.

Przykład z dokumentacji: db kropka users kropka updateMany, w nawiasie dwa dokumenty. Pierwszy to filtr: w klamrach age, dwukropek, w klamrach dolar l t, czyli less than, mniejsze niż, dwukropek osiemnaście. Drugi to akcja: w klamrach dolar set, dwukropek, w klamrach status dwukropek reject. Diagram nazywa te części: kolekcja, update filter, czyli filtr aktualizacji, i update action, czyli akcja aktualizacji. Polecenie ustawia status reject wszystkim użytkownikom młodszym niż osiemnaście lat.

Różnica między metodami. UpdateOne zmienia pierwszy dokument, który pasuje do filtra, nawet jeśli pasuje ich wiele. UpdateMany zmienia wszystkie pasujące dokumenty. ReplaceOne zastępuje cały pierwszy pasujący dokument nowym dokumentem, zachowując tylko podkreślnik id.

### Porównanie z SQL UPDATE

Dwa przykłady. Instrukcja UPDATE people SET status równa się C WHERE age większe niż dwadzieścia pięć odpowiada poleceniu db kropka people kropka updateMany, filtr: age, dolar g t, dwadzieścia pięć, akcja: dolar set, status C. Warunek WHERE przechodzi do pierwszego argumentu, a klauzula SET do drugiego.

Druga instrukcja: UPDATE people SET age równa się age plus trzy WHERE status równa się A. W MongoDB: db kropka people kropka updateMany, filtr: status dwukropek A, akcja: w klamrach dolar inc, dwukropek, w klamrach age dwukropek trzy. Operator dolar inc, od increment, zwiększa wartość o podaną liczbę. Dlaczego updateMany, a nie updateOne? Bo UPDATE w SQL bez dodatkowych ograniczeń zmienia wszystkie wiersze spełniające WHERE. Odpowiednikiem jest więc updateMany.

### Przykłady z kolekcji inventory

Kolejny slajd pokazuje trzy przykłady z dokumentacji. Pierwszy: db kropka inventory kropka updateOne. Filtr: item dwukropek paper. Akcja zawiera dwa operatory naraz. Dolar set ustawia pole size kropka uom, zapisane w cudzysłowie, na cm, oraz pole status na P. Dolar currentDate ustawia pole lastModified na true, czyli na bieżącą datę. Zwróć uwagę na dwie rzeczy. Po pierwsze, w jednym dokumencie aktualizacji może być kilka różnych operatorów. Po drugie, zagnieżdżone pole size kropka uom piszemy w cudzysłowie, bo zawiera kropkę. To jest notacja kropkowa, do której wrócimy przy wyszukiwaniu. Dzięki niej zmieniamy tylko jedno pole poddokumentu size, a pola h i w zostają nietknięte. Gdybyś napisał dolar set, size dwukropek, w klamrach uom cm, nadpisałbyś cały poddokument size i zgubił h oraz w. To częsta pułapka.

Drugi przykład: updateMany z filtrem qty, dolar l t, pięćdziesiąt, ustawia size kropka uom na in, status na P i datę modyfikacji. Działa na wszystkich przedmiotach, których jest mniej niż pięćdziesiąt sztuk.

Trzeci przykład: replaceOne z filtrem item paper i nowym dokumentem: item paper, instock, czyli tablica dwóch poddokumentów, magazyn A z qty sześćdziesiąt i magazyn B z qty czterdzieści. Na slajdzie linia jest ucięta, ale w dokumentacji dalej jest liczba czterdzieści. Nowy dokument zastępuje stary w całości. Wszystkie pola, których nie ma w dokumencie zastępczym, znikają. Zostaje jedynie podkreślnik id.

### Składnia ogólna

Slajd podsumowuje składnię: db kropka collection kropka updateOne, w nawiasie trzy parametry: filter, update i options. Filter określa kryteria wyboru dokumentu do aktualizacji. Update określa modyfikacje, które mają zostać zastosowane do wybranego dokumentu. Options to opcjonalne dodatkowe ustawienia, które konfigurują zachowanie operacji. Najważniejszą opcją jest upsert, o którym za chwilę.

MongoDB udostępnia operatory aktualizacji, które określają modyfikacje: dolar set, dolar unset, dolar inc, dolar push, dolar pull i inne. Trzy przykłady ze slajdu. Pierwszy: updateOne z filtrem name John Doe i akcją dolar set age trzydzieści. Drugi: updateMany z filtrem status new i akcją dolar inc views jeden, czyli każdemu nowemu dokumentowi zwiększamy licznik wyświetleń o jeden. Trzeci: updateOne z filtrem name Jane Doe i akcją dolar push tags mongodb, czyli dopisujemy tag mongodb na koniec tablicy tags.

### Tryb zmień i tryb zamień

Slajd o trybach zmień i zamień pokazuje diagram składni. Parametr update to albo zwykły dokument, albo dokument z operatorami aktualizacji, przy czym operatorów może być kilka, rozdzielonych przecinkami.

Tryb zamień zachodzi wtedy, gdy parametr update nie zawiera operatorów. Wtedy cały dokument jest zamieniany, a identyfikator jest zachowany. Na slajdzie jest literówka „cały dokument jest zmieniamy”; chodzi o „zmieniany”, a dokładniej „zastępowany”.

Tryb zmień zachodzi wtedy, gdy parametr update zawiera wyłącznie operatory. Wtedy aktualny dokument jest modyfikowany na podstawie tych operatorów, na przykład dolar set, dolar unset, dolar inc, dolar mul. Każdy operator może wystąpić tylko raz. To wynika z budowy dokumentu: dolar set jest kluczem, a klucz w jednym dokumencie powinien wystąpić raz. Jeśli chcesz ustawić kilka pól, wpisujesz je wszystkie w jednym dolar set, a nie piszesz dolar set dwa razy.

Nie wolno mieszać trybów, czyli w jednym dokumencie update podać części pól zwykłych i części operatorów.

Slajd pokazuje dwa przykłady. Pierwszy: db kropka users kropka updateOne, filtr podkreślnik id jeden, a jako update sam dokument email nowy@example.com, bez operatora. Według slajdu to tryb zamień: dokument zostałby zastąpiony dokumentem zawierającym tylko email. Drugi: ten sam filtr i dolar set email nowy@example.com. To tryb zmień: zmienia się tylko pole email, a reszta dokumentu zostaje.

Tutaj ważne sprostowanie. Opis trybów pochodzi z dawnej metody update. We współczesnym MongoDB i w mongosh metody updateOne i updateMany wymagają operatorów aktualizacji. Jeżeli przekażesz im zwykły dokument bez operatorów, jak w pierwszym przykładzie, serwer zwróci błąd, że dokument aktualizacji musi zawierać operatory atomowe. Do zastąpienia całego dokumentu służy replaceOne, a replaceOne z kolei nie przyjmuje operatorów. Na teście trzymaj się logiki slajdu: brak operatorów oznacza zamianę całego dokumentu z zachowaniem podkreślnik id, obecność operatorów oznacza modyfikację pól. Ale pamiętaj, że w praktyce zamianę robi się metodą replaceOne.

### Operatory dotyczące pól: dolar set, dolar unset, dolar rename

Dolar set ustawia wartość pola albo kilku pól. Diagram: dolar set, dwukropek, klamry, a w nich pole, dwukropek i wartość, którą może być zwykła wartość, tablica albo dokument, z możliwością powtarzania par po przecinku. Przykład: db kropka users kropka updateOne, filtr podkreślnik id jeden, akcja dolar set, w klamrach email nowy@example.com. Jeżeli pole nie istnieje, dolar set je utworzy. Jeżeli istnieje, nadpisze jego wartość.

Dolar unset usuwa zadane pole albo pola. Diagram: dolar unset, dwukropek, klamry, pole, dwukropek i pusty łańcuch, czyli dwa cudzysłowy. Przykład: updateOne z filtrem podkreślnik id jeden i akcją dolar unset, w klamrach phone dwukropek pusty tekst. Wartość podana przy dolar unset nie ma znaczenia; konwencją jest pusty łańcuch, ale można też napisać jeden albo true. Pułapka: dolar unset usuwa pole całkowicie z dokumentu, a nie ustawia go na null. Gdy chcesz mieć pole z wartością null, użyj dolar set z null.

Dolar rename zmienia nazwę pola albo pól. Diagram: dolar rename, dwukropek, klamry, stara nazwa pola, dwukropek, nowa nazwa pola jako tekst. Przykład: updateOne z filtrem podkreślnik id jeden i akcją dolar rename, w klamrach username dwukropek login w cudzysłowie. Po tej operacji pole username znika, a jego wartość jest dostępna pod nazwą login. Zwróć uwagę na kierunek: po lewej stara nazwa, po prawej nowa.

### Operatory dotyczące pól: dolar inc, dolar mul, dolar currentDate

Dolar inc zwiększa wartość zadanego pola albo pól o podaną liczbę. Diagram: dolar inc, dwukropek, klamry, pole, dwukropek, przyrost. Przykład: db kropka products kropka updateOne, filtr podkreślnik id jeden, akcja dolar inc, w klamrach stock dwukropek pięć. Stan magazynu wzrasta o pięć. Ważne: dolar inc przyjmuje także liczby ujemne, więc dolar inc z minus pięć zmniejszy wartość o pięć. W MongoDB nie ma osobnego operatora dolar dec. Jeżeli pole nie istnieje, dolar inc je utworzy z wartością równą przyrostowi.

Dolar mul mnoży wartość zadanego pola albo pól. Diagram: dolar mul, dwukropek, klamry, pole, dwukropek, mnożnik. Przykład: db kropka products kropka updateOne, filtr podkreślnik id jeden, akcja dolar mul, w klamrach price dwukropek jeden przecinek dwa, w zapisie kodu jeden kropka dwa. Cena rośnie o dwadzieścia procent. Gdy pole nie istnieje, dolar mul tworzy je z wartością zero.

Dolar currentDate zapisuje w zadanym polu bieżącą datę i czas albo znacznik czasu typu timestamp. Diagram: dolar currentDate, dwukropek, klamry, pole, dwukropek, a potem jedna z dwóch możliwości: w klamrach dolar type dwukropek date w cudzysłowie, albo w klamrach dolar type dwukropek timestamp w cudzysłowie. Przykład pierwszy: db kropka users kropka updateOne, filtr podkreślnik id jeden, akcja dolar currentDate, w klamrach lastLogin dwukropek true. Komentarz w kodzie mówi, że ustawi typ Date. Notatka obok wyjaśnia: true ustawia Date, z datą i godziną, a dolar type date robi to samo, tylko jawnie. Przykład drugi: db kropka orders kropka updateOne, filtr podkreślnik id jeden, akcja dolar currentDate, lastUpdated dwukropek, w klamrach dolar type dwukropek timestamp. Tu w polu znajdzie się wartość typu Timestamp, a nie Date.

Na dole slajdu, drobnym drukiem, jest przykład z dokumentacji: do kolekcji customers wstawiamy dokument z podkreślnik id jeden, status a i polem lastModified ustawionym na ISODate z datą z października dwa tysiące trzynastego roku. To dokument startowy, na którym w dokumentacji pokazano działanie dolar currentDate.

Do zapamiętania na test: updateOne zmienia pierwszy pasujący dokument, updateMany wszystkie pasujące, replaceOne zastępuje cały dokument z zachowaniem podkreślnik id. Składnia to filter, update i opcjonalne options. Filtry aktualizacji mają tę samą składnię co filtry find. UPDATE z SQL odpowiada updateMany, SET odpowiada dolar set, a SET kolumna równa się kolumna plus trzy odpowiada dolar inc z trzema. Tryb zamień to brak operatorów, tryb zmień to same operatory, każdy operator może wystąpić raz. Dolar set ustawia, dolar unset usuwa pole, dolar rename zmienia nazwę, dolar inc dodaje i przyjmuje liczby ujemne, dolar mul mnoży, dolar currentDate wpisuje bieżącą datę, domyślnie typu Date, a z dolar type timestamp jako Timestamp. Zagnieżdżone pole zmieniasz przez notację kropkową w cudzysłowie, inaczej nadpiszesz cały poddokument.

## 3.4. Operatory tablicowe w aktualizacji i tryb upsert

### dolar push i dolar addToSet

Slajd o operatorach tablicowych pokazuje dokument przykładowy: podkreślnik id jeden, name Jan, tags, czyli tablica z elementami mongodb i database, oraz skills, czyli tablica z jednym elementem JavaScript.

Dolar push dodaje jeden element albo wszystkie elementy na koniec tablicy. Diagram: dolar push, dwukropek, klamry, pole tablicowe, dwukropek, a potem wartość, tablica albo dokument, albo konstrukcja z modyfikatorem dolar each. Przykład: db kropka users kropka updateOne, filtr podkreślnik id jeden, akcja dolar push, w klamrach tags dwukropek newTag. Po tej operacji tablica tags ma trzy elementy: mongodb, database i newTag.

Dolar addToSet dodaje jeden element albo wszystkie elementy na koniec tablicy, ale duplikaty są ignorowane. Przykład: updateOne z filtrem podkreślnik id jeden i akcją dolar addToSet, tags dwukropek uniqueTag. Jeżeli uniqueTag już jest w tablicy, nic się nie zmieni. Dolar addToSet traktuje tablicę jak zbiór. Dolar push dopisze element zawsze, nawet jeśli taki już jest.

Teraz bardzo ważny szczegół, czyli dolar each. Przykład ze slajdu: updateOne z filtrem podkreślnik id jeden i akcją dolar push, tags dwukropek, w klamrach dolar each dwukropek, w nawiasie kwadratowym tag1 i tag2. Efekt: do tablicy tags dopisane zostaną dwa osobne elementy, tag1 i tag2. Gdybyś napisał dolar push, tags dwukropek, w nawiasie kwadratowym tag1 i tag2, bez dolar each, do tablicy trafiłby jeden element, który sam jest tablicą dwuelementową. Powstałaby tablica zagnieżdżona. To klasyczne pytanie testowe. Dolar each działa tak samo z dolar addToSet: dolar addToSet z dolar each dodaje kilka elementów, pomijając te, które już są.

### dolar pop i dolar pull

Drugi slajd o tablicach ma dokument: podkreślnik id jeden, name Jan, roles, czyli user, editor i admin, oraz tags, czyli mongodb, database i nosql.

Dolar pop usuwa pierwszy albo ostatni element tablicy. Diagram: dolar pop, dwukropek, klamry, pole tablicowe, dwukropek, jeden albo minus jeden. Jeden usuwa ostatni element, minus jeden usuwa pierwszy. Przykład: db kropka users kropka updateOne, filtr podkreślnik id jeden, akcja dolar pop, w klamrach roles dwukropek jeden. Komentarz w kodzie: jeden oznacza usuń ostatni. Z tablicy roles znika admin. Gdyby było minus jeden, zniknąłby user. Łatwo pomylić kierunek, więc skojarz to tak: jeden to „od końca”, jak zdejmowanie ze stosu, a minus jeden to „od początku”.

Dolar pull usuwa wszystkie elementy tablicy, które spełniają wzorzec. Diagram: dolar pull, dwukropek, klamry, pole tablicowe, dwukropek, a potem wartość, tablica albo dokument, albo warunek zapytania. Przykład pierwszy: updateOne z filtrem podkreślnik id jeden i akcją dolar pull, tags dwukropek mongodb. Z tablicy tags znikają wszystkie elementy równe mongodb. Przykład drugi: updateOne z filtrem podkreślnik id dwa i akcją dolar pull, roles dwukropek, ukośnik, daszek, m, ukośnik. To wyrażenie regularne, oznaczone komentarzem regex. Daszek oznacza początek tekstu, więc usunięte zostaną wszystkie role zaczynające się od litery m.

Różnicę między dolar pop i dolar pull ujmij tak: dolar pop patrzy na pozycję, czyli pierwszy albo ostatni, a dolar pull patrzy na wartość albo warunek i usuwa wszystkie pasujące elementy, gdziekolwiek są. Jako ciekawostkę dodam, że istnieje jeszcze dolar pullAll, który usuwa wszystkie wystąpienia wartości z podanej listy, ale slajdy go nie omawiają.

### Tryb upsert

Upsert to zlepek słów update i insert. Zachowanie jest takie: gdy podano opcję upsert dwukropek true, a żaden dokument nie pasuje do filtra, więc nic nie zostało zmodyfikowane, to wstawiany jest nowy dokument. Gdy dokument pasuje, upsert niczego nie zmienia w zachowaniu i jest zwykła aktualizacja.

Co zawiera wstawiony dokument? Slajd rozróżnia dwa tryby. W trybie replace, czyli zamiany, nowy dokument zawiera wszystkie pola i wartości z parametru update, czyli z dokumentu zastępczego. W trybie update, czyli modyfikacji operatorami, nowy dokument zawiera wszystkie wartości pól z parametru query, czyli z filtra, oraz rezultat zastosowania operatorów modyfikujących z parametru update. Pole podkreślnik id jest zachowane, jeśli wynika z filtra albo dokumentu, albo jest tworzone nowe, jeśli trzeba.

Przykłady. Pierwszy: db kropka users kropka updateOne, filtr name Alice, operacja dolar set age trzydzieści, a trzeci argument to opcje: w klamrach upsert dwukropek true. Jeżeli Alice nie istnieje, powstanie dokument z polami podkreślnik id, name Alice i age trzydzieści. Name przyszło z filtra, age z operatora dolar set.

Drugi: updateMany z filtrem status active, akcją dolar set verified true i opcją upsert true. Jeżeli żaden dokument nie ma statusu active, powstanie jeden nowy dokument ze statusem active i verified true. Zauważ: jeden, nie wiele. Upsert przy updateMany wstawia najwyżej jeden dokument.

Trzeci: replaceOne z filtrem podkreślnik id dziesięć, dokumentem zastępczym name Nowy, age dwadzieścia pięć i opcją upsert true. Jeśli dokumentu z identyfikatorem dziesięć nie ma, powstanie dokument z podkreślnik id dziesięć, name Nowy i age dwadzieścia pięć. Identyfikator pochodzi z filtra, a reszta z dokumentu zastępczego.

Czwarty: updateOne z filtrem email jan@example.com, akcją dolar set name Jan i age trzydzieści, oraz upsert true. Typowy wzorzec „utwórz, jeśli nie ma, albo zaktualizuj, jeśli jest”, oparty na polu, które jednoznacznie identyfikuje osobę. Nowy dokument dostanie email z filtra oraz name i age z dolar set.

Pułapka: pola z filtra trafiają do nowego dokumentu tylko wtedy, gdy są warunkami równości. Jeżeli filtr brzmi age, dolar g t, dwadzieścia, MongoDB nie wie, jaką konkretną wartość wstawić, więc tego pola nie skopiuje.

Do zapamiętania na test: dolar push dopisuje na koniec zawsze, także duplikaty, a dolar addToSet pomija duplikaty. Kilka elementów naraz dodaje się przez dolar each, bo bez niego dodasz jedną zagnieżdżoną tablicę. Dolar pop z jedynką usuwa ostatni element, z minus jedynką pierwszy. Dolar pull usuwa wszystkie elementy pasujące do wartości, warunku albo wyrażenia regularnego. Upsert włączasz trzecim argumentem, w klamrach upsert true. Gdy nic nie pasuje, powstaje nowy dokument: w trybie zamiany z pól dokumentu zastępczego, w trybie modyfikacji z pól równości z filtra plus efekt operatorów. UpdateMany z upsert wstawia najwyżej jeden dokument.

## 3.5. Usuwanie dokumentów, findOneAndDelete, findAndModify i bulkWrite

### deleteOne i deleteMany

Operacje usuwania usuwają dokumenty z kolekcji. MongoDB udostępnia db kropka collection kropka deleteOne i db kropka collection kropka deleteMany. Tak jak przy innych zapisach, usuwanie dotyczy jednej kolekcji, a każda operacja jest atomowa na poziomie pojedynczego dokumentu. Dokumenty do usunięcia wskazujesz filtrem o tej samej składni co przy odczycie.

Przykład z dokumentacji: db kropka users kropka deleteMany, w nawiasie filtr status dwukropek reject. Diagram nazywa części: users to kolekcja, a status reject to delete filter, czyli filtr usuwania.

Slajd z trzema blokami kodu pokazuje trzy przypadki. Usunięcie wszystkich dokumentów: db kropka inventory kropka deleteMany, a w nawiasie puste klamry. Usunięcie wszystkich dokumentów spełniających warunek: deleteMany, w klamrach status dwukropek A. Usunięcie tylko jednego dokumentu spełniającego warunek: deleteOne, w klamrach status dwukropek D. DeleteOne usuwa pierwszy znaleziony pasujący dokument, nawet jeśli pasuje ich więcej.

Pułapka: deleteMany z pustymi klamrami usuwa wszystkie dokumenty, ale kolekcja zostaje, razem z indeksami. Natomiast drop usuwa całą kolekcję, łącznie z indeksami. To różnica podobna do tej między DELETE FROM bez WHERE a DROP TABLE w SQL.

Porównanie z SQL. DELETE FROM people WHERE status równa się D odpowiada db kropka people kropka deleteMany z filtrem status D. DELETE FROM people, bez warunku, odpowiada db kropka people kropka deleteMany z pustymi klamrami.

### findOneAndDelete i findAndModify

Są też dodatkowe metody, które mogą usuwać dokumenty.

Metoda findOneAndDelete usuwa jeden dokument z kolekcji i zwraca go. Ma opcję sortowania, dzięki której określasz, który dokument zostanie usunięty jako pierwszy. Przykład: db kropka collection kropka findOneAndDelete, pierwszy argument to filtr status inactive, drugi to opcje: w klamrach sort dwukropek, w klamrach lastLogin dwukropek jeden. Sortowanie rosnące po dacie ostatniego logowania stawia na początku najdawniej logowanego użytkownika, więc spośród nieaktywnych zostanie usunięty ten, który logował się najdawniej. Różnica wobec deleteOne jest dwojaka: findOneAndDelete zwraca usunięty dokument, a deleteOne tylko informację, ile dokumentów usunięto, i findOneAndDelete pozwala sortować. To przydaje się na przykład do kolejki zadań: zdejmujesz najstarsze zadanie i od razu dostajesz jego treść.

Metoda findAndModify jest bardziej ogólna: pozwala modyfikować albo usuwać pojedynczy dokument. Też ma opcję sortowania. Żeby usunąć dokument, ustawiasz remove dwukropek true. Ważna różnica w składni: findAndModify przyjmuje jeden dokument z polami, a nie kilka osobnych argumentów. Przykład: db kropka collection kropka findAndModify, w nawiasie klamry, a w nich query dwukropek status inactive, sort dwukropek lastLogin jeden, i remove dwukropek true. Zamiast remove można podać pole update z operatorami, a opcja new dwukropek true sprawi, że metoda zwróci dokument po zmianie, a nie przed nią. Istnieją też nowocześniejsze, wyspecjalizowane odpowiedniki: findOneAndUpdate i findOneAndReplace.

### bulkWrite

MongoDB pozwala wykonać zbiorczą, czyli masową, operację zapisu, po angielsku Bulk Write Operations. Operacje zbiorcze dotyczą pojedynczej kolekcji. Metoda db kropka collection kropka bulkWrite pozwala w jednym wywołaniu wykonać masowe wstawianie, aktualizację i usuwanie.

Kluczowe pojęcie to operacje uporządkowane i nieuporządkowane, ordered kontra unordered. Przy uporządkowanej liście MongoDB wykonuje operacje szeregowo, jedna po drugiej. Jeżeli przy jednej z nich wystąpi błąd, MongoDB zakończy i nie przetworzy pozostałych operacji z listy. Przy nieuporządkowanej liście MongoDB może wykonywać operacje równolegle, choć nie jest to gwarantowane. Jeśli wystąpi błąd w jednej z operacji, MongoDB będzie kontynuować przetwarzanie pozostałych. Domyślnie bulkWrite jest uporządkowany, czyli ordered ma wartość true. Żeby przełączyć na tryb nieuporządkowany, podajesz drugi argument: w klamrach ordered dwukropek false.

Składnia ogólna ze slajdu: db kropka collection kropka bulkWrite, w nawiasie tablica, a w niej dokumenty, każdy z jednym kluczem: insertOne, updateOne, updateMany, replaceOne, deleteOne i deleteMany. Po tablicy, po przecinku, opcje ordered false. Ramka z dokumentacji potwierdza, że bulkWrite obsługuje dokładnie te sześć operacji zapisu: insertOne, updateOne, updateMany, replaceOne, deleteOne i deleteMany. Zauważ, że nie ma wśród nich insertMany. Wiele wstawień robisz, podając wiele operacji insertOne.

Drugi slajd pokazuje pełny przykład na kolekcji pizzas, otoczony blokiem try i catch. W bloku try wywołujemy db kropka pizzas kropka bulkWrite z tablicą operacji. Dwie operacje insertOne, każda z polem document: pizza z podkreślnik id trzy, typu beef, rozmiaru medium, i pizza z podkreślnik id cztery, typu sausage, rozmiaru large; ceny są ucięte na slajdzie. Potem updateOne z polem filter, type cheese, i polem update, dolar set price osiem. Potem deleteOne z polem filter, type pepperoni. Na końcu replaceOne z polem filter, type vegan, i polem replacement, w którym jest nowy dokument: type tofu, size small, price cztery. W bloku catch przechwytujemy błąd i wypisujemy go funkcją print.

Zapamiętaj nazwy pól wewnątrz operacji bulkWrite, bo to dobre pytanie testowe. InsertOne ma pole document. UpdateOne i updateMany mają pola filter i update. ReplaceOne ma pola filter i replacement. DeleteOne i deleteMany mają pole filter.

Do zapamiętania na test: deleteMany z pustymi klamrami usuwa wszystkie dokumenty, ale zostawia kolekcję; deleteOne usuwa jeden pasujący. DELETE FROM odpowiada deleteMany. FindOneAndDelete usuwa jeden dokument, zwraca go i pozwala wybrać go przez sort. FindAndModify przyjmuje jeden dokument z polami query, sort, remove albo update, a remove true usuwa. BulkWrite działa na jednej kolekcji i obsługuje sześć operacji: insertOne, updateOne, updateMany, replaceOne, deleteOne i deleteMany. Domyślnie jest ordered: wykonuje szeregowo i zatrzymuje się na pierwszym błędzie. Z ordered false kontynuuje po błędzie i może działać równolegle.

## 3.6. Wyszukiwanie: metoda find, selekcja i notacja kropkowa

### Budowa polecenia find

Operacja wyszukiwania wybiera dokumenty z kolekcji. Diagram składni wygląda tak: db, kropka, nazwa kolekcji, kropka, find, nawias okrągły, query, a potem opcjonalnie przecinek i projection, i zamknięcie nawiasu.

Find ma więc dwa parametry. Query to specyfikacja dokumentów, które mają zostać wybrane, czyli filtr. Projection mówi, które pola mają zostać dołączone do rezultatu albo z niego wyłączone. Oba parametry są opcjonalne, ale kolejność jest stała: najpierw filtr, potem projekcja. Jeśli chcesz podać samą projekcję bez filtra, i tak musisz wstawić pusty filtr, czyli puste klamry, na pierwszym miejscu.

Dopasowane dokumenty zwracane są za pomocą kursora. Kursor to obiekt, który wskazuje na wyniki i pozwala pobierać je partiami, zamiast od razu wszystkich. Umożliwia też dalsze operacje, takie jak sortowanie, ograniczanie liczby wyników czy pomijanie. W mongosh kursor wypisuje domyślnie pierwsze dwadzieścia dokumentów, a następną porcję pokazuje polecenie it.

### Przykłady wyszukiwania

Wybierz wszystkie filmy z kolekcji: db kropka movies kropka find, z pustymi nawiasami. Albo równoważnie: db kropka movies kropka find, a w nawiasie puste klamry. Oba zapisy zwracają wszystkie dokumenty. Pusty filtr oznacza brak warunków.

Wybierz określony film na podstawie identyfikatora: db kropka movies kropka find, w klamrach podkreślnik id dwukropek ObjectId, w nawiasie dwa w cudzysłowie. Uwaga: ObjectId z dwójką to skrót dydaktyczny. Prawdziwy ObjectId ma dwadzieścia cztery znaki szesnastkowe, a ObjectId z jednym znakiem zgłosi błąd. Na slajdzie chodzi o pokazanie idei.

Wybierz filmy z dwutysięcznego roku z oceną większą niż jeden: db kropka movies kropka find, w klamrach year dwukropek dwa tysiące, przecinek, rating dwukropek, w klamrach dolar g t dwukropek jeden. Dwa warunki w jednym dokumencie filtra, rozdzielone przecinkiem, łączy domyślnie logiczne „i”. Nie potrzeba jawnego dolar and.

Wybierz filmy nakręcone między dwa tysiące pięć a dwa tysiące piętnaście: db kropka movies kropka find, w klamrach year dwukropek, w klamrach dolar g t e dwukropek dwa tysiące pięć, przecinek, dolar l t e dwukropek dwa tysiące piętnaście. Dwa operatory w jednym dokumencie przy tym samym polu tworzą przedział domknięty. To jest odpowiednik BETWEEN z SQL.

### Diagram z dokumentacji

Kolejny slajd przypomina, że operacje odczytu pobierają dokumenty z kolekcji, czyli przeszukują kolekcję. MongoDB udostępnia do tego metodę db kropka collection kropka find. Filtry zapytania identyfikują dokumenty do zwrócenia.

Przykład z czterema nazwanymi częściami: db kropka users kropka find, pierwszy argument age, dolar g t, osiemnaście, drugi argument w klamrach name dwukropek jeden, przecinek, address dwukropek jeden, a po zamknięciu nawiasu kropka limit, w nawiasie pięć. Diagram mówi: users to collection, czyli kolekcja; age dolar g t osiemnaście to query criteria, czyli kryteria zapytania; name jeden i address jeden to projection, czyli projekcja; a kropka limit pięć to cursor modifier, czyli modyfikator kursora. Ten sam slajd pojawia się później jeszcze raz, przy podsumowaniu, więc tę czwórkę nazw musisz znać na pamięć: collection, query criteria, projection, cursor modifier. W SQL odpowiadałoby temu: SELECT podkreślnik id, name, address FROM users WHERE age większe niż osiemnaście LIMIT pięć.

### Selekcja

Parametr query opisuje dokumenty, którymi jesteśmy zainteresowani. Diagram pokazuje dwie możliwe formy. Pierwsza to wyrażenie boolowskie z jednym operatorem logicznym najwyższego poziomu, dolar and albo dolar or. Druga to warunki na określonych polach: pole, dwukropek, a potem albo wartość, tablica czy dokument, albo dokument z operatorami zapytania. Warunków na różnych polach może być wiele, rozdzielonych przecinkami.

Warunki na polach są dwojakie. Pierwszy rodzaj to równość wartości: aktualna wartość pola musi być identyczna z podaną. Drugi rodzaj to pozostałe operatory: aktualna wartość pola musi spełniać wszystkie warunki wyrażone przez zastosowane operatory.

### Równość wartości dla obiektów i tablic

Slajd rozwija, co znaczy „identyczna”. Dla pól obiektowych, czyli poddokumentów, wartość musi się zgadzać co do liczby pól, ich kolejności i nazw. Dla pól tablicowych musi się zgadzać liczba elementów i ich kolejność. Dla pozostałych operatorów wartość musi spełniać wszystkie warunki narzucone przez operatory, a każdy operator może wystąpić tylko raz przy danym polu. Na slajdzie jest literówka „wszystkie warunku”, chodzi o „warunki”.

Przykład z konsoli: db kropka movies1 kropka find, w klamrach tablica dwukropek, w nawiasie kwadratowym dziesięć, dwa, trzy. Wynik to dwa dokumenty, oba z tablicą dokładnie dziesięć, dwa, trzy. Jeden z nich ma dodatkowo pole out1 z poddokumentem a dwukropek a1, b dwukropek b1, ale to nie przeszkadza, bo warunek dotyczy tylko pola tablica. Gdyby w bazie był dokument z tablicą trzy, dwa, dziesięć, nie zostałby zwrócony, bo kolejność się nie zgadza. Gdyby była tablica dziesięć, dwa, trzy, cztery, też nie, bo nie zgadza się liczba elementów.

### Przykład z reżyserem: kolejność pól ma znaczenie

To jeden z najważniejszych slajdów pod pułapki. W kolekcji movies1 jest dokument z polem director, które jest poddokumentem: lastName Stallone, a potem firstName Sylwester. Zwróć uwagę na kolejność w danych: najpierw nazwisko, potem imię.

Na zrzucie konsoli pierwsze zapytanie to find z director równym dokumentowi firstName Sylwester, lastName Stallone. Wynik jest pusty, bo kolejność pól jest odwrotna niż w bazie. Drugie zapytanie to director równy dokumentowi lastName Stallone, firstName Sylwester. Ono zwraca dokument, bo kolejność i nazwy zgadzają się dokładnie.

Kod w górnej części slajdu pokazuje dwa analogiczne zapytania, ale z nazwami pól pisanymi małymi literami: firstname i lastname. Trzeba tu uważać, bo w danych pola nazywają się firstName i lastName, z wielkimi literami N. Nazwy pól w MongoDB rozróżniają wielkość liter, więc zapytanie z firstname małą literą nie dopasuje pola firstName. Co więcej, drugi przykład kodu na slajdzie ma zamienione wartości: lastname Sylwester i firstname Stallone. Prawdopodobnie miało to pokazać, że zmiana kolejności psuje dopasowanie, ale przy okazji pomieszano wartości. Wniosek, który masz wynieść, pokazuje zrzut konsoli: przy porównaniu całego poddokumentu liczą się nazwy, wartości, liczba pól i ich kolejność.

### Notacja kropkowa

Notacja kropkowa, czyli dot notation, pozwala sięgać w głąb dokumentu. Diagram: nazwa pola, potem opcjonalnie kropka i kolejna nazwa pola albo pozycja w tablicy, z możliwością powtarzania dla kolejnych poziomów.

Dostęp do pól zagnieżdżonych dokumentów: pole kropka podpole, na przykład director kropka firstname. Dostęp do elementów tablic: pole kropka indeks, na przykład actors kropka dwa. Indeksowanie zaczyna się od zera, więc actors kropka dwa to trzeci aktor. Na slajdzie jedna linijka jest po angielsku, „accessing items of arrays”, czyli dostęp do elementów tablic.

Najważniejsza zasada składniowa: wyrażenie z kropką musi być w cudzysłowie. Piszesz w klamrach, w cudzysłowie director kropka firstname, dwukropek, Sylwester. Bez cudzysłowu JavaScript potraktowałby kropkę jako odwołanie do właściwości i zgłosił błąd składni.

Dwa przykłady z konsoli. Pierwszy: db kropka movies1 kropka find, w klamrach, w cudzysłowie tablica kropka zero, dwukropek dziesięć. Zwraca dokumenty, w których pierwszy element tablicy to dziesięć. Drugi: find, w cudzysłowie out1 kropka a, dwukropek a1 w apostrofach. Zwraca dokument, w którym poddokument out1 ma pole a równe a1.

### Ten sam przykład jeszcze raz, z notacją kropkową

Slajd zatytułowany „Równość wartości, przykład raz jeszcze” zestawia dwa podejścia. Pierwsze: director równy całemu poddokumentowi. Drugie: dwa osobne warunki z notacją kropkową, director kropka firstname równe Sylwester i director kropka lastname równe Stallone.

Zrzut konsoli pokazuje, że oba zapytania zwracają ten sam dokument, jeśli w pierwszym zachowano kolejność z bazy. Ale różnica jest zasadnicza. Notacja kropkowa nie zależy od kolejności pól ani od tego, czy poddokument ma jeszcze inne pola. Gdyby director miał dodatkowo pole birthYear, porównanie całego poddokumentu przestałoby działać, a zapytanie z kropkami dalej by działało. Dlatego w praktyce prawie zawsze używa się notacji kropkowej.

Do zapamiętania na test: find przyjmuje najpierw query, potem projection, oba opcjonalne, a wynik zwraca kursor. Find z pustymi nawiasami i find z pustymi klamrami dają to samo. Przecinek między warunkami to domyślne „i”. Dwa operatory przy jednym polu, na przykład dolar g t e i dolar l t e, tworzą przedział. Części polecenia to collection, query criteria, projection i cursor modifier. Równość z całym poddokumentem wymaga zgodności nazw, wartości, liczby i kolejności pól, a równość z całą tablicą wymaga zgodności elementów, ich liczby i kolejności. Notacja kropkowa w cudzysłowie, na przykład director kropka firstname albo actors kropka dwa, nie zależy od kolejności pól, a indeksy tablic liczy się od zera. Nazwy pól rozróżniają wielkość liter.

## 3.7. Przegląd operatorów zapytań i operatory porównania

### Mapa wszystkich grup operatorów

Wykład pokazuje planszę ze wszystkimi grupami operatorów zapytań. Operatory zapytań służą do określania warunków wyszukiwania i dopasowywania dokumentów w kolekcjach. Zielona ramka przypomina, że operatory można łączyć w jednym zapytaniu, żeby budować złożone warunki.

Operatory porównania, comparison operators, porównują wartość pola z podaną wartością. Jest ich osiem: dolar e q, równe; dolar n e, różne; dolar g t, większe niż; dolar g t e, większe lub równe; dolar l t, mniejsze niż; dolar l t e, mniejsze lub równe; dolar in, należy do tablicy; i dolar n in, nie należy do tablicy. Rozwinięcia skrótów pomagają zapamiętać: eq to equal, ne to not equal, gt to greater than, gte to greater than or equal, lt to less than, lte to less than or equal, nin to not in.

Operatory tablicowe, array operators, działają na tablicach. Dolar all: tablica zawiera wszystkie wskazane elementy. Dolar elemMatch: tablica zawiera element, który spełnia wszystkie podane warunki. Dolar size: tablica ma określoną liczbę elementów.

Operatory elementów, element operators, pozwalają szukać po istnieniu i typie pola. Dolar exists: pole istnieje albo nie istnieje. Dolar type: pole ma określony typ BSON, na przykład string, int albo date.

Operatory logiczne, logical operators, łączą wyrażenia zapytań. Dolar and: wszystkie warunki muszą być prawdziwe. Dolar or: co najmniej jeden warunek musi być prawdziwy. Dolar nor: żaden z warunków nie może być prawdziwy. Dolar not: neguje wyrażenie. Plansza umieszcza w tej grupie także dolar expr, który pozwala używać w zapytaniach wyrażeń agregujących. W oficjalnej dokumentacji dolar expr należy do grupy operatorów ewaluacji, ale na teście licz się z tym, jak przedstawił to wykład.

Operatory geograficzne, geospatial operators, szukają dokumentów na podstawie danych przestrzennych, czyli lokalizacji. Dolar box: w obszarze prostokąta. Dolar center: w okręgu, w starszej składni. Dolar centerSphere: w okręgu na kuli. Dolar geoIntersects: geometrie, które się przecinają. Dolar geometry: geometria w formacie GeoJSON. Dolar geoWithin: w obszarze. Dolar maxDistance i dolar minDistance: maksymalna i minimalna odległość. Dolar near: najbliżej punktu, w starszej składni. Dolar nearSphere: najbliżej punktu na kuli. Dolar polygon: w obszarze wielokąta, w starszej składni. Pary do zapamiętania: dolar near i dolar nearSphere szukają najbliższych, a dolar geoWithin szuka obiektów leżących w środku obszaru.

Operatory bitowe, bitwise operators, działają na liczbach na poziomie bitów. Dolar bitsAllClear: wszystkie wskazane bity są wyzerowane. Dolar bitsAllSet: wszystkie wskazane bity są ustawione. Dolar bitsAnyClear: co najmniej jeden wskazany bit jest wyzerowany. Dolar bitsAnySet: co najmniej jeden wskazany bit jest ustawiony.

Operatory różne, miscellaneous operators. Dolar jsonSchema: walidacja względem schematu JSON. Dolar mod: reszta z dzielenia, na przykład wszystkie parzyste. Dolar regex: dopasowanie do wyrażenia regularnego. Dolar text: wyszukiwanie pełnotekstowe. Dolar where: dopasowanie dokumentów kodem JavaScript. Dolar comment: dodanie komentarza do zapytania, przydatne przy analizie logów. W oficjalnej dokumentacji dolar jsonSchema, dolar mod, dolar regex, dolar text i dolar where należą do operatorów ewaluacji, a dolar comment do operatorów różnych.

Ostatnia grupa na planszy nosi nazwę operatorów oceniania, evaluation operators, czyli działających w kontekście ewaluacji wyrażeń. Plansza wymienia: dolar cond, warunek logiczny jak operator trójargumentowy; dolar ifNull, zwraca pierwszą niepustą wartość; dolar switch, wiele warunków; dolar isArray, sprawdza, czy wartość jest tablicą; dolar isNumber, sprawdza, czy wartość jest liczbą; dolar isObject, sprawdza, czy wartość jest dokumentem; i dolar type, zwraca typ wartości. Tu muszę cię uprzedzić, że plansza miesza dwie różne rzeczy. Dolar cond, dolar ifNull, dolar switch, dolar isArray, dolar isNumber i wyrażenie dolar type to operatory wyrażeń agregacji. Używa się ich w potoku agregacji albo wewnątrz dolar expr, a nie bezpośrednio jako operatorów zapytania przy polu. Operatora dolar isObject w MongoDB nie ma. Na teście, jeśli padnie pytanie o tę planszę, odpowiadaj zgodnie z nią, ale wiedz, że w dokumentacji operatory ewaluacji zapytań to dolar expr, dolar jsonSchema, dolar mod, dolar regex, dolar text i dolar where.

Plansza odsyła na koniec do oficjalnej dokumentacji, do strony Query Predicates w MongoDB Manual.

### Operatory porównania w szczegółach

Kolejny slajd omawia operatory porównania z przykładami. Służą do filtrowania dokumentów na podstawie wartości pól.

Dolar e q, równe. Dopasowuje dokumenty, w których wartość pola jest równa podanej. Przykład: db kropka products kropka find, w klamrach price dwukropek, w klamrach dolar e q dwukropek sto.

Dolar n e, różne. Dopasowuje dokumenty, w których wartość pola nie jest równa podanej. Przykład: db kropka products kropka find, status dwukropek, w klamrach dolar n e dwukropek inactive. Ważna pułapka: dolar n e zwraca także dokumenty, które tego pola w ogóle nie mają. Brak pola to też „nie równe inactive”.

Dolar g t, większe niż. Przykład: db kropka students kropka find, age, dolar g t, dwadzieścia jeden.

Dolar g t e, większe lub równe. Przykład: students, age, dolar g t e, dwadzieścia jeden. Różnica z poprzednim przykładem: osoba w wieku dokładnie dwudziestu jeden lat zostanie zwrócona przez dolar g t e, ale nie przez dolar g t.

Dolar l t, mniejsze niż. Przykład: products, price, dolar l t, pięćdziesiąt.

Dolar l t e, mniejsze lub równe. Przykład: products, price, dolar l t e, pięćdziesiąt.

Dolar in, należy do zbioru. Dopasowuje dokumenty, w których wartość pola jest równa co najmniej jednej z wartości w podanej tablicy. Przykład: db kropka articles kropka find, tags dwukropek, w klamrach dolar in dwukropek, w nawiasie kwadratowym NoSQL i javascript. Ponieważ tags jest tablicą, zwrócone zostaną artykuły, które mają choć jeden z tych tagów.

Dolar n in, nie należy do zbioru. Dopasowuje dokumenty, w których wartość pola nie jest równa żadnej z wartości w tablicy. Przykład: db kropka books kropka find, genre, dolar n in, w nawiasie kwadratowym Mystery i Sci-Fi. Tak jak dolar n e, dolar n in zwraca też dokumenty bez tego pola.

Sekcja „Warto wiedzieć” zawiera cztery zdania. Porównania w MongoDB uwzględniają kolejność typów BSON, czyli istnieje ustalony porządek typów, na przykład liczby są przed tekstami. Zapis pole dwukropek wartość jest skrótem zapisu pole dwukropek, w klamrach dolar e q dwukropek wartość. Operatory można łączyć w jednym zapytaniu. MongoDB automatycznie wykonuje konwersję numeryczną, gdy to możliwe. Chodzi o to, że różne typy liczbowe, na przykład int, long, double i decimal, porównuje się po wartości, więc liczba całkowita pięć równa się liczbie zmiennoprzecinkowej pięć kropka zero. Nie oznacza to jednak zamiany tekstu na liczbę.

Przykład z wieloma warunkami: użytkownicy w wieku od osiemnastu do sześćdziesięciu czterech lat. db kropka users kropka find, w klamrach age dwukropek, w klamrach dolar g t e dwukropek osiemnaście, przecinek, dolar l t dwukropek sześćdziesiąt pięć. Zwróć uwagę na granice: osiemnaście włącznie, sześćdziesiąt pięć wyłącznie, czyli do sześćdziesięciu czterech.

Sekcja „Uwaga” dodaje cztery kolejne fakty. Operatory dolar in i dolar n in przyjmują tablicę wartości. Przy porównaniach typy danych mają znaczenie: liczba pięć różni się od tekstu pięć w cudzysłowie, więc zapytanie o liczbę nie znajdzie dokumentu z tekstem. Do sprawdzania istnienia pola służy dolar exists, który nie jest operatorem porównania. I odesłanie do dokumentacji: Comparison Query Predicate Operators.

Diagram w rogu slajdu przypomina, że dolar e q, dolar n e, dolar g t, dolar g t e, dolar l t i dolar l t e przyjmują pojedynczą wartość, tablicę albo dokument, a dolar in i dolar n in przyjmują tablicę.

Na koniec różnica, która wraca w wielu pytaniach. Dolar in sprawdza, czy pole równa się jednej z kilku wartości, więc działa jak wielokrotne „lub”. Jest odpowiednikiem IN z SQL. Zapis status, dolar in, A i D znaczy to samo co dolar or z warunkami status A i status D, tylko krócej.

Do zapamiętania na test: osiem operatorów porównania to dolar e q, n e, g t, g t e, l t, l t e, in i n in. Pole dwukropek wartość to skrót dolar e q. Dolar in i dolar n in przyjmują tablicę. Dolar n e i dolar n in zwracają też dokumenty bez pola. Typy mają znaczenie: pięć to nie pięć w cudzysłowie. Porównania idą według kolejności typów BSON, a liczby różnych typów porównuje się po wartości. Dolar exists i dolar type to operatory elementów, nie porównania. Dolar nor znaczy, że żaden warunek nie jest prawdziwy. Plansza wykładu wrzuca dolar expr do operatorów logicznych, a dolar cond, dolar ifNull i dolar switch do operatorów oceniania, choć to wyrażenia agregacji.

## 3.8. Operatory dolar exists, dolar regex, dolar text i dolar expr

Ten slajd zbiera wybrane operatory dotyczące istnienia pól, wyszukiwania tekstowego i ewaluacji wyrażeń.

### dolar exists

Dolar exists sprawdza, czy pole istnieje w dokumencie, czy nie. Pierwszy przykład: dokumenty, w których pole istnieje. db kropka books kropka find, w klamrach author dwukropek, w klamrach dolar exists dwukropek true. Drugi: dokumenty, w których pola nie ma. Ten sam zapis z false.

Pułapka: dolar exists true zwraca także dokumenty, w których pole istnieje i ma wartość null. Pole z wartością null istnieje. Z kolei zapytanie author dwukropek null zwróci zarówno dokumenty z author równym null, jak i dokumenty bez pola author. To dwa różne pytania i warto je odróżniać.

### dolar regex

Dolar regex dopasowuje wartość pola do wyrażenia regularnego. Przykład: dokumenty, w których pole name zaczyna się od Jan, bez względu na wielkość liter. db kropka users kropka find, w klamrach name dwukropek, w klamrach dolar regex dwukropek, w cudzysłowie daszek Jan, przecinek, dolar options dwukropek i w cudzysłowie. Daszek oznacza początek tekstu, a opcja i oznacza ignorowanie wielkości liter, od angielskiego case insensitive. Dopasują się więc Jan, Janina, jan i JANUSZ.

Dolar regex można zastąpić skróconym zapisem literału wyrażenia regularnego w ukośnikach: name dwukropek, ukośnik, daszek Jan, ukośnik, i. Zobaczysz to pod koniec działu przy porównaniu z LIKE z SQL.

### dolar text

Dolar text wyszukuje dokumenty zawierające określone słowa, czyli wykonuje wyszukiwanie pełnotekstowe. Wymaga indeksu tekstowego, text index. Bez indeksu tekstowego na kolekcji zapytanie z dolar text zwróci błąd. Przykład: db kropka articles kropka find, w klamrach dolar text dwukropek, w klamrach dolar search dwukropek, w cudzysłowie mongodb spacja baza.

Zwróć uwagę na budowę: dolar text nie stoi przy żadnym polu. Jest na najwyższym poziomie filtra, bo przeszukuje wszystkie pola objęte indeksem tekstowym. Wewnątrz jest dolar search z szukanym tekstem.

Tu sprostowanie do slajdu. Komentarz w przykładzie mówi, że szukamy dokumentów zawierających słowa mongodb i baza. W rzeczywistości słowa rozdzielone spacją w dolar search są łączone logicznym „lub”: zwrócone zostaną dokumenty, które zawierają mongodb albo baza, albo oba. Jeśli chcesz wymusić konkretną frazę, zamykasz ją w dodatkowym cudzysłowie, a słowo poprzedzone minusem wyklucza dokumenty, które je zawierają.

Indeks tekstowy zakłada się poleceniem createIndex z wartością text przy polu, na przykład db kropka articles kropka createIndex, w klamrach content dwukropek text w cudzysłowie. Indeksy omawia osobny dział.

### dolar expr

Dolar expr pozwala używać wyrażeń i porównywać ze sobą pola tego samego dokumentu albo budować bardziej złożone warunki. Przykład: dokumenty, w których cena jest większa od kosztu. db kropka products kropka find, w klamrach dolar expr dwukropek, w klamrach dolar g t dwukropek, w nawiasie kwadratowym, w cudzysłowie dolar price, przecinek, w cudzysłowie dolar koszt.

Tu dwie rzeczy są nowe. Po pierwsze, wewnątrz dolar expr operator porównania ma inną składnię niż zwykle: dolar g t przyjmuje tablicę dwóch argumentów, a nie stoi przy polu. Po drugie, odwołanie do wartości pola zapisuje się jako tekst ze znakiem dolara na początku, na przykład dolar price w cudzysłowie. To jest składnia wyrażeń agregacji. Bez dolar expr nie da się porównać dwóch pól tego samego dokumentu, bo zwykły filtr porównuje pole tylko ze stałą wartością. Zapis price, dolar g t, w cudzysłowie dolar koszt, bez dolar expr porównałby cenę z tekstem dolar koszt, a nie z polem koszt.

### Warto wiedzieć i dobra praktyka

Slajd zbiera uwagi. Operator dolar text wymaga indeksu tekstowego na odpowiednich polach. Operator dolar regex może być wolniejszy, a dla wydajności warto stosować indeksy. Slajd pisze dalej, żeby unikać wyrażeń niekotwiczonych, i w nawiasie podaje daszek na początku wzorca. Sformułowanie jest niezręczne, więc wyjaśnię. Wyrażenie kotwiczone na początku, czyli zaczynające się od daszka, jest dobre: jeśli nie ignoruje wielkości liter, MongoDB może skorzystać z indeksu, bo szuka po prefiksie, jak w słowniku. Wyrażenia niekotwiczone, na przykład szukanie fragmentu w środku tekstu, wymagają przejrzenia wszystkich wartości. Daszek to więc przykład kotwicy, którą warto stosować, a nie coś, czego trzeba unikać.

Dalej: operator dolar expr pozwala porównywać pola dokumentu, używając funkcji agregacji i wyrażeń, takich jak dolar g t, dolar l t, dolar and. MongoDB porównuje wartości według kolejności typów BSON, BSON Type Comparison Order.

Dobra praktyka: stosuj indeksy, w tym indeks tekstowy, i testuj wydajność zapytań metodą explain.

Do zapamiętania na test: dolar exists true albo false sprawdza obecność pola, a pole z null istnieje. Dolar regex przyjmuje wzorzec, a dolar options z i wyłącza rozróżnianie wielkości liter. Daszek to początek tekstu. Dolar text wymaga indeksu tekstowego, stoi na najwyższym poziomie filtra, a szukany tekst podaje się w dolar search; słowa oddzielone spacją łączy „lub”. Dolar expr pozwala porównać dwa pola tego samego dokumentu, z operatorem w postaci tablicy argumentów i polami zapisanymi jako dolar nazwa w cudzysłowie. Wydajność sprawdza się metodą explain.

## 3.9. Operatory tablicowe w zapytaniach: dolar size, dolar elemMatch i dolar all

Plansza o operatorach tablicowych, array operators, przypomina, że operatory tablicowe pozwalają wyszukiwać i dopasowywać elementy w tablicach, a tablica w MongoDB może zawierać wartości skalarne, dokumenty albo tablice zagnieżdżone.

### dolar size

Dolar size sprawdza, czy rozmiar tablicy jest równy podanej liczbie elementów. Składnia: w klamrach pole dwukropek, w klamrach dolar size dwukropek liczba. Przykład: db kropka products kropka find, w klamrach colors dwukropek, w klamrach dolar size dwukropek trzy. Zwraca produkty, które mają dokładnie trzy kolory.

Ważna pułapka: dolar size przyjmuje wyłącznie dokładną liczbę. Nie da się napisać dolar size, a w nim dolar g t dwa. Gdy potrzebujesz warunku „więcej niż dwa elementy”, używasz notacji kropkowej z dolar exists, na przykład w cudzysłowie colors kropka dwa, dolar exists true, co oznacza, że istnieje trzeci element. Inna droga to dolar expr z wyrażeniem dolar size z agregacji.

### dolar elemMatch

Dolar elemMatch sprawdza, czy tablica zawiera co najmniej jeden element, który spełnia wszystkie podane warunki. Składnia: pole dwukropek, w klamrach dolar elemMatch dwukropek, w klamrach warunek pierwszy, warunek drugi i kolejne. Przykład: db kropka courses kropka find, w klamrach grades dwukropek, w klamrach dolar elemMatch dwukropek, w klamrach subject dwukropek Math, przecinek, score dwukropek, w klamrach dolar g t e dwukropek osiemdziesiąt. Zwraca kursy, w których jest ocena z matematyki wynosząca co najmniej osiemdziesiąt punktów. Kluczowe słowa: ten sam element. Przedmiot Math i wynik co najmniej osiemdziesiąt muszą należeć do jednego poddokumentu w tablicy grades.

Gdybyś napisał bez dolar elemMatch, w cudzysłowie grades kropka subject równe Math i w cudzysłowie grades kropka score dolar g t e osiemdziesiąt, MongoDB zwróciłby dokument także wtedy, gdy Math ma pięćdziesiąt punktów, a osiemdziesiąt punktów ma na przykład historia. Każdy warunek mógłby trafić w inny element. Do tego wrócimy przy zasadach przeszukiwania tablic.

Sekcja „Warto wiedzieć”: operatory tablicowe działają na tablicach dowolnego typu elementów, czyli na wartościach, dokumentach i tablicach. Dolar size wymaga dokładnej liczby elementów. Dolar elemMatch umożliwia łączenie wielu warunków. Gdy chcesz tylko sprawdzić, czy tablica zawiera określone elementy, bez dodatkowych warunków, użyj dolar all albo dolar in.

Dobra praktyka: używaj dolar elemMatch do filtrowania tablic dokumentów, stosuj indeksy, żeby przyspieszyć zapytania na tablicach, a przy prostych wartościach rozważ dolar in, dolar all albo dolar size.

Powiązane operatory, opowiedziane zdaniami. Dolar all sprawdza, czy tablica zawiera wszystkie wskazane elementy. Dolar in sprawdza, czy tablica zawiera co najmniej jeden z podanych elementów. Dolar n in sprawdza, czy tablica nie zawiera żadnego z podanych elementów. Dolar exists sprawdza, czy pole istnieje, a pole to może być tablicą.

### dolar all

Następna plansza poświęcona jest operatorowi dolar all, z kategorii tablic. Dolar all dopasowuje dokumenty, których tablica zawiera wszystkie wskazane elementy, niezależnie od kolejności. Składnia: pole dwukropek, w klamrach dolar all dwukropek, w nawiasie kwadratowym wartość pierwsza, wartość druga i kolejne.

Przykład: db kropka movies kropka find, w klamrach actors dwukropek, w klamrach dolar all dwukropek, w nawiasie kwadratowym Tom Hanks i Robin Wright. Zwraca filmy, w których tablica actors zawiera zarówno Toma Hanksa, jak i Robin Wright.

Przykładowe dane to trzy filmy. Forrest Gump, z podkreślnik id jeden, z aktorami Tom Hanks, Robin Wright i Gary Sinise. Cast Away, z podkreślnik id dwa, z samym Tomem Hanksem. The Green Mile, z podkreślnik id trzy, z aktorami Tom Hanks i Michael Clarke Duncan. Wynik zapytania to tylko Forrest Gump, bo tylko tam występują oboje aktorzy. Zauważ, że Forrest Gump ma też trzeciego aktora, Gary'ego Sinise'a, i mimo to pasuje.

Ważne informacje ze slajdu. Kolejność elementów w tablicy nie ma znaczenia. Dalej slajd ma zdanie, które się rozjechało przy redakcji: mówi, że operator sprawdza, czy tablica zawiera dokładnie określone elementy i tylko je, a zaraz potem, żeby dodać warunki, na przykład dolar size, jeśli potrzebna jest dokładna liczba elementów. Poprawna treść jest taka: dolar all nie sprawdza, czy tablica zawiera tylko te elementy. Sprawdza, czy zawiera co najmniej te elementy, a inne mogą być obok, co widać po Forrest Gump. Jeśli chcesz mieć pewność, że elementów jest dokładnie tyle, łączysz dolar all z dolar size. Dalej slajd mówi, że dolar all działa z tablicami wartości prostych, na przykład tekstów i liczb, oraz z dokumentami, i że często używa się go do wyszukiwania dokumentów z określonymi tagami, identyfikatorami albo kategoriami.

Powiązane operatory na tej planszy: dolar in dopasowuje, jeśli tablica zawiera przynajmniej jeden z elementów; dolar elemMatch dopasowuje elementy tablicy na podstawie warunków; dolar size dopasowuje tablicę o określonej liczbie elementów; dolar all dopasowuje, jeśli tablica zawiera wszystkie podane elementy.

Teraz porównanie, które musisz mieć w małym palcu. Dolar in to „którykolwiek z”, czyli logiczne „lub”. Dolar all to „wszystkie z”, czyli logiczne „i”. Dla danych z filmami dolar in z Tomem Hanksem i Robin Wright zwróciłby wszystkie trzy filmy, bo w każdym jest Tom Hanks. Dolar all z tymi samymi aktorami zwraca tylko Forrest Gump. A dopasowanie przez równość z całą tablicą, czyli actors równe tablicy Tom Hanks, Robin Wright, nie zwróciłoby nic, bo żaden film nie ma dokładnie takiej tablicy, w tej kolejności i bez innych elementów.

Do zapamiętania na test: dolar size przyjmuje tylko dokładną liczbę, bez zakresów. Dolar elemMatch wymaga, żeby wszystkie warunki spełnił ten sam element tablicy. Dolar all wymaga obecności wszystkich wymienionych elementów, w dowolnej kolejności, i dopuszcza inne elementy. Dolar in wymaga obecności co najmniej jednego. Dokładną liczbę elementów sprawdzisz, dokładając dolar size.

## 3.10. Operatory logiczne i operator dolar not

### dolar and

Plansza o operatorach logicznych, logical query operators, mówi, że operatory logiczne łączą wyrażenia zapytań, pozwalają budować bardziej złożone warunki i mogą łączyć inne operatory zapytań.

Dolar and to logiczny operator koniunkcji. Zwraca dokumenty, dla których wszystkie podane wyrażenia są prawdziwe. Diagram: dolar and, dwukropek, nawias kwadratowy, a w nim wyrażenia, każde jako dokument, rozdzielone przecinkami. Slajd podaje trzy najważniejsze informacje: łączy warunki koniunkcją, czyli AND; musi zawierać co najmniej dwa wyrażenia; jest dopuszczalny tylko na najwyższym poziomie zapytania.

Przykład: db kropka products kropka find, w klamrach dolar and dwukropek, w nawiasie kwadratowym trzy dokumenty: category Fruits, price dolar l t dwadzieścia oraz stock dolar g t zero. Zwraca owoce tańsze niż dwadzieścia, które są na stanie.

Dwa sprostowania, żeby nie dać się zaskoczyć. Po pierwsze, dokumentacja MongoDB wymaga dla dolar and niepustej tablicy, a tablica z jednym wyrażeniem jest technicznie poprawna. Wykład mówi „co najmniej dwa”, bo dolar and z jednym wyrażeniem nie ma sensu, i tę odpowiedź podaj na teście. Po drugie, „tylko na najwyższym poziomie” znaczy w praktyce, że dolar and nie może stać przy polu, tak jak operator porównania. Nie napiszesz price dwukropek, dolar and. Natomiast dolar and można zagnieżdżać w innych operatorach logicznych, na przykład wewnątrz dolar or.

Ten sam przykład można napisać bez dolar and: w jednym dokumencie category Fruits, price dolar l t dwadzieścia, stock dolar g t zero. Przecinek oznacza „i”. Kiedy więc jawny dolar and jest naprawdę potrzebny? Gdy ten sam klucz musiałby pojawić się w dokumencie dwa razy. Przykład: chcesz połączyć dwa warunki dolar or. W jednym dokumencie nie możesz mieć dwóch kluczy dolar or, bo drugi nadpisałby pierwszy, więc obejmujesz oba dolar or jednym dolar and.

### dolar or

Dolar or to logiczny operator alternatywy. Zwraca dokumenty, dla których co najmniej jedno z wyrażeń jest prawdziwe. Diagram i zasady ze slajdu są takie same jak dla dolar and: tablica wyrażeń, co najmniej dwa wyrażenia, najwyższy poziom zapytania.

Przykład: db kropka orders kropka find, w klamrach dolar or dwukropek, w nawiasie kwadratowym dwa dokumenty: price dolar l t dziesięć oraz quantity dolar g t sto. Zwraca zamówienia tanie albo duże. Zwróć uwagę, że warunki dotyczą dwóch różnych pól. Gdyby oba dotyczyły jednego pola i równości, prościej byłoby użyć dolar in.

Warto wiedzieć: dolar and i dolar or można łączyć z innymi operatorami, na przykład dolar e q, dolar g t, dolar in. Jeśli masz tylko jedno wyrażenie, użyj go samego, bez dolar and i dolar or. MongoDB optymalizuje zapytania z operatorami logicznymi; na przykład przy dolar or każdy warunek może korzystać z osobnego indeksu.

Dobra praktyka: dolar and, gdy wszystkie warunki muszą być spełnione; dolar or, gdy wystarczy jeden; indeksy na polach używanych w warunkach; testowanie wydajności złożonych zapytań metodą explain.

Powiązane operatory: dolar not neguje wynik wyrażenia; dolar nor zwraca dokumenty, które nie spełniają żadnego z podanych wyrażeń; dolar in sprawdza, czy pole ma jedną z wartości; dolar exists sprawdza, czy pole istnieje. Dolar nor ma tę samą składnię co dolar or, czyli tablicę wyrażeń, ale odwrotny sens: „ani to, ani to”.

### dolar not

Dolar not to logiczny operator negacji warunku. Neguje wynik innego operatora zapytania i zwraca dokumenty, które nie spełniają podanego warunku. Zielona ramka mówi dwie ważne rzeczy: dolar not dotyczy dokładnie jednego operatora zapytania i nie można go użyć na najwyższym poziomie zapytania.

To odwrotnie niż dolar and, dolar or i dolar nor. Tamte stoją na najwyższym poziomie i przyjmują tablicę wyrażeń. Dolar not stoi przy polu i przyjmuje dokument z operatorem. Składnia: w klamrach pole dwukropek, w klamrach dolar not dwukropek, w klamrach operator dwukropek wartość. Diagram: dolar not, dwukropek, klamry, a w nich operator zapytania, na przykład dolar g t, dolar regex, dolar in.

Przykład pierwszy, negacja porównania: db kropka products kropka find, price dwukropek, w klamrach dolar not dwukropek, w klamrach dolar g t dwukropek sto. Zwraca dokumenty, w których cena nie jest większa niż sto, czyli mniejsza lub równa stu. I tu najważniejsza pułapka całego operatora: dolar not zwraca także dokumenty, które nie mają pola price. Brak ceny też „nie jest większy niż sto”. Dlatego price dolar not dolar g t sto to nie to samo co price dolar l t e sto. To drugie zwraca tylko dokumenty, które cenę mają.

Przykład drugi, negacja kilku warunków razem z dolar and: products, dolar and, a w tablicy category Electronics oraz price z dolar not. Slajd opisuje wynik jako produkty z elektroniki, których cena nie mieści się w zakresie od pięćdziesięciu do dwustu. Ale kod na slajdzie ma błąd składni: wewnątrz dolar not są podwójne klamry i zapis lt bez znaku dolara, z wartością pięćdziesiąt, a obok dolar g t dwieście. To się nie wykona. Poza tym nawet poprawiony zapis „mniejsze niż pięćdziesiąt i większe niż dwieście” nie miałby sensu, bo żadna liczba nie spełnia obu warunków naraz, więc jego negacja zwróciłaby wszystko. Poprawna wersja dla opisanego wyniku to: price dwukropek, w klamrach dolar not dwukropek, w klamrach dolar g t e pięćdziesiąt, przecinek, dolar l t e dwieście. Wtedy zaprzeczamy przynależności do przedziału i dostajemy ceny poniżej pięćdziesięciu albo powyżej dwustu, plus dokumenty bez ceny. Przy okazji widać, że w praktyce dolar not może objąć więcej niż jeden operator, jeśli razem opisują jeden warunek na polu, choć slajd mówi o jednym operatorze.

Przykład trzeci, negacja dopasowania wzorca: products, name dwukropek, w klamrach dolar not dwukropek, ukośnik apple ukośnik i. Zwraca dokumenty, w których nazwa nie pasuje do wzorca apple bez względu na wielkość liter. To jedyny przypadek, w którym dolar not przyjmuje coś innego niż dokument z operatorem: może przyjąć bezpośrednio literał wyrażenia regularnego.

Warto wiedzieć: dolar not dotyczy jednego operatora zapytania, nie może stać na najwyższym poziomie, można go łączyć z dolar g t, dolar l t, dolar g t e, dolar l t e, dolar regex, dolar in, dolar n in, dolar exists, dolar type i innymi, zwraca dokumenty niespełniające warunku, a przy tablicach może zachowywać się nieoczywiście, więc warto testować zapytanie na przykładach.

Dobra praktyka: używaj dolar not, gdy chcesz wykluczyć wartości albo wzorce, stosuj indeksy, testuj na przykładowych danych, a przy złożonych warunkach rozważ dolar and albo dolar or zamiast zagnieżdżania wielu negacji. Dodam, że negacje słabo korzystają z indeksów, bo trudno szybko znaleźć wszystko, co czymś nie jest.

Powiązane operatory: dolar and łączy wiele warunków, dolar or łączy warunki alternatywne, dolar regex dopasowuje wzorzec w tekście, dolar in sprawdza, czy wartość należy do zbioru, a dolar n in, czy do niego nie należy.

Do zapamiętania na test: dolar and, dolar or i dolar nor stoją na najwyższym poziomie i przyjmują tablicę wyrażeń, według wykładu co najmniej dwóch. Dolar not stoi przy polu, przyjmuje dokument z operatorem albo wyrażenie regularne i nie może stać na najwyższym poziomie. Przecinek to niejawne „i”, a jawny dolar and potrzebny jest, gdy ten sam klucz, na przykład dwa dolar or, wystąpiłby dwa razy. Dolar not zwraca też dokumenty bez danego pola, więc dolar not z dolar g t to nie to samo co dolar l t e. Dolar nor znaczy „żaden”.

## 3.11. Zasady przeszukiwania tablic

Teraz dwa slajdy, które tłumaczą, jak MongoDB dopasowuje warunki, gdy pole jest tablicą. To bardzo częste źródło zaskoczeń.

### Równość wartości przy tablicach

Warunek oparty na równości wartości jest spełniony, gdy dane pole w całości jest identyczne z podaną wartością albo gdy co najmniej jeden element tablicy jest identyczny z podaną wartością.

Przykład: db kropka movies kropka find, w klamrach actors dwukropek ObjectId pięć. To zapytanie dopasuje oba pokazane dokumenty. Pierwszy ma pole actors równe po prostu ObjectId pięć, czyli pojedynczą wartość, więc pole jako całość jest równe. Drugi ma actors jako tablicę ObjectId pięć i ObjectId siedem, a jeden z elementów jest równy szukanej wartości.

To jest powód, dla którego w MongoDB zapytanie tags dwukropek mongodb znajduje dokumenty, w których mongodb jest jednym z wielu tagów. Nie potrzeba żadnego specjalnego operatora „zawiera”. Ale uwaga: jeżeli podasz jako wartość całą tablicę, na przykład tags równe tablicy mongodb, nosql, działa pierwsza część reguły, czyli równość całego pola, z dokładną kolejnością i liczbą elementów.

### Pozostałe operatory przy tablicach

Warunki oparte na pozostałych operatorach są spełnione, gdy pole jako całość spełnia wszystkie operatory albo gdy każdy z operatorów został dopasowany do co najmniej jednego elementu tablicy. Jednakże, i to jest sedno, ten element nie musi być tym samym elementem dla poszczególnych operatorów.

Przykład: db kropka movies kropka find, w klamrach ratings dwukropek, w klamrach dolar g t e dwa, przecinek, dolar l t e trzy. Intencja: oceny między dwa a trzy. Przeanalizujmy trzy dokumenty.

Pierwszy ma ratings równe trzy, pojedynczą liczbę. Trzy jest większe lub równe dwa i mniejsze lub równe trzy. Pasuje.

Drugi ma ratings jako tablicę trzy, siedem, pięć. Dolar g t e dwa spełnia na przykład siedem, a dolar l t e trzy spełnia trzy. Każdy operator znalazł swój element. Pasuje. Tu akurat trójka spełnia oba warunki, więc wynik jest intuicyjny.

Trzeci ma ratings jako tablicę jeden, cztery. Dolar g t e dwa spełnia cztery, a dolar l t e trzy spełnia jeden. Każdy operator znalazł element, ale różne elementy. Dokument pasuje, choć żadna ocena nie leży w przedziale od dwóch do trzech. To jest ten nieintuicyjny przypadek, o którym mówi slajd.

Rozwiązanie podaje slajd: użyj dolar elemMatch, gdy pojedynczy element tablicy ma spełnić wszystkie operatory. Zapis ratings dwukropek, w klamrach dolar elemMatch dwukropek, w klamrach dolar g t e dwa, przecinek, dolar l t e trzy. Dokument z tablicą jeden, cztery wtedy odpada, dokument z tablicą trzy, siedem, pięć zostaje dzięki trójce. A pierwszy dokument, z ratings jako pojedynczą liczbą, z dolar elemMatch odpadnie, bo dolar elemMatch dopasowuje tylko tablice.

Do zapamiętania na test: równość z pojedynczą wartością pasuje, gdy całe pole jest jej równe albo gdy dowolny element tablicy jest jej równy. Przy operatorach każdy operator może trafić w inny element tablicy, więc zakres dolar g t e dwa i dolar l t e trzy dopasuje tablicę jeden, cztery. Żeby wszystkie warunki dotyczyły jednego elementu, użyj dolar elemMatch.

## 3.12. Projekcja

### Zasady projekcji

Projekcja pozwala określić, które pola mają się znaleźć w wyniku. To drugi argument metody find. Diagram: klamry, w nich pole, dwukropek, a potem jedna z wartości jeden, true, zero albo false, albo dla pola tablicowego dokument z operatorem projekcji. Par może być wiele, po przecinku.

True albo jeden oznacza pola, które mają zostać dołączone. False albo zero oznacza pola, które nie mają zostać uwzględnione. Wartości dodatnich i ujemnych, czyli włączeń i wyłączeń, nie można używać razem w jednej projekcji. Jedynym wyjątkiem jest pole podkreślnik id, które jest domyślnie dodawane. Na slajdzie są dwie literówki: „wartości dodanie” zamiast „dodatnie” i „_poleId” zamiast „_id”. Chodzi o to, że w projekcji włączającej, na przykład title jeden, actors jeden, możesz dopisać podkreślnik id zero, żeby wyłączyć identyfikator, i to nie jest błąd. Natomiast title jeden razem z year zero to błąd.

Logika jest prosta. Projekcja włączająca mówi: daj mi tylko te pola. Projekcja wyłączająca mówi: daj mi wszystko oprócz tych pól. Mieszanie obu nie ma sensu, bo nie wiadomo, co zrobić z polami niewymienionymi. Wyjątek dla podkreślnik id wynika z tego, że identyfikator jest dołączany zawsze, chyba że jawnie go wyłączysz.

Operatory projekcji pozwalają dodatkowo wybierać poszczególne elementy tablicy.

### Operatory projekcji: dolar elemMatch i dolar slice

Dolar elemMatch w projekcji wybiera pierwszy pasujący element tablicy. Ten element musi spełniać wszystkie podane warunki. Gdy takiego elementu nie ma, pole tablicowe nie jest zwracane. Na slajdzie jest napisane, że żadne pole nie jest zwracane, ale chodzi o to konkretne pole tablicowe: pozostałe pola z projekcji, na przykład podkreślnik id, są w wyniku. Diagram: dolar elemMatch, dwukropek, zapytanie.

Zwróć uwagę, że dolar elemMatch występuje w dwóch rolach. W filtrze, czyli w pierwszym argumencie find, decyduje, które dokumenty zostaną zwrócone. W projekcji, czyli w drugim argumencie, decyduje, który element tablicy zostanie pokazany w już wybranym dokumencie, i pokazuje tylko pierwszy pasujący.

Dolar slice wybiera fragment tablicy. Z dodatnią liczbą count wybiera pierwsze count elementów, z ujemną ostatnie count elementów. Można też pominąć pewną liczbę elementów. Diagram: dolar slice, dwukropek, albo samo count, albo nawias kwadratowy z dwiema liczbami: skip i count. Na przykład dolar slice z tablicą dwa, trzy pomija dwa pierwsze elementy i zwraca trzy następne. Dolar slice pięć zwraca pięć pierwszych, a dolar slice minus pięć pięć ostatnich.

### Przykłady projekcji

Pierwszy przykład: znajdź dany film i wybierz jego identyfikator, tytuł i aktorów. db kropka movies kropka find, pierwszy argument podkreślnik id ObjectId dwa, drugi argument w klamrach title dwukropek true, przecinek, actors dwukropek true. Wynik zawiera podkreślnik id ObjectId dwa, title TombRaider i actors, czyli tablicę ObjectId sześć, cztery i pięć. Zauważ, że identyfikatora nie trzeba było wymieniać, bo jest dodawany domyślnie. Na slajdzie tytuł raz jest napisany TombRaider łącznie, a raz Tomb Raider ze spacją; to zwykła niekonsekwencja.

Drugi przykład: znajdź filmy z dwa tysiące pierwszego roku, wybierz ich tytuły i ostatnich dwóch aktorów. db kropka movies kropka find, pierwszy argument year dwa tysiące jeden, drugi argument w klamrach title jeden, podkreślnik id zero, actors dwukropek, w klamrach dolar slice dwukropek minus dwa. Wynik: title Tomb Raider i actors z dwoma ostatnimi elementami, czyli ObjectId cztery i ObjectId pięć. Identyfikatora nie ma, bo wyłączyliśmy go podkreślnik id zero. Ten przykład pokazuje jednocześnie wyjątek dla podkreślnik id: title jeden razem z podkreślnik id zero jest dozwolone.

Do zapamiętania na test: projekcja to drugi argument find. Jeden albo true włącza pole, zero albo false wyłącza. Nie wolno mieszać włączeń i wyłączeń, z wyjątkiem podkreślnik id zero w projekcji włączającej. Podkreślnik id jest zwracany domyślnie. Dolar elemMatch w projekcji zwraca pierwszy pasujący element tablicy, a gdy żaden nie pasuje, pomija to pole. Dolar slice z liczbą dodatnią daje pierwsze elementy, z ujemną ostatnie, a z tablicą skip i count pomija i bierze.

## 3.13. Modyfikatory kursora: sort, limit i skip

### Trzy modyfikatory

Modyfikatory zmieniają kolejność albo liczbę zwróconych dokumentów. Sort porządkuje dokumenty w wyniku. Limit zwraca co najwyżej określoną liczbę dokumentów; diagram: limit, nawias, count, nawias. Skip pomija pewną liczbę dokumentów, licząc od początku; diagram: skip, nawias, offset, nawias.

Wszystkie modyfikatory są opcjonalne i można je łączyć w łańcuch w dowolnej kolejności, bez żadnych skutków ubocznych. Muszą jednak zostać podane, zanim dokumenty zostaną zwrócone przez kursor. Czyli zanim zaczniesz pobierać wyniki. Gdy kursor zacznie oddawać dokumenty, na zmianę sortowania jest za późno.

„W dowolnej kolejności bez skutków ubocznych” oznacza coś ważnego: bez względu na to, jak zapiszesz łańcuch, serwer wykonuje zawsze najpierw sort, potem skip, a na końcu limit. Dlatego find, sort, limit sześć, skip trzy daje dokładnie ten sam wynik co find, sort, skip trzy, limit sześć. To inaczej niż w potoku agregacji, gdzie kolejność etapów dolar skip i dolar limit ma znaczenie.

### Sortowanie

Modyfikator sort porządkuje dokumenty. Diagram: sort, nawias okrągły, klamry, pole, dwukropek, jeden albo minus jeden, opcjonalnie kolejne pola po przecinku, zamknięcie klamer i nawiasu.

Jeden oznacza porządek rosnący, minus jeden malejący. Kolejność dokumentów jest domyślnie niezdefiniowana, chyba że użyjesz sortowania. Nie zakładaj, że bez sort dostaniesz dokumenty w kolejności wstawiania. Sortowanie dużych zbiorów danych powinno korzystać z odpowiednich indeksów; bez indeksu serwer musi posortować wszystko w pamięci, a ta ma limit. Sortowanie następuje przed projekcją, więc do sortowania można użyć pól, których nie ma w wyniku. Możesz posortować po dacie i jej nie wyświetlać.

### Przykłady

Pierwszy: db kropka users kropka find, puste klamry, kropka sort, w klamrach age dwukropek minus jeden, przecinek, posts dwukropek jeden. Użytkownicy posortowani malejąco według wieku, a przy równym wieku rosnąco według liczby postów. Kolejność pól w dokumencie sortowania ma znaczenie: pierwsze pole jest kluczem głównym, drugie rozstrzyga remisy.

Drugi: db kropka myColl kropka find, kropka sort podkreślnik id jeden, kropka limit sześć, kropka skip trzy. Trzeci: to samo, ale skip trzy przed limit sześć. Oba zwracają ten sam wynik: dokumenty posortowane rosnąco po identyfikatorze, z pominiętymi trzema pierwszymi, a potem sześć kolejnych, czyli dokumenty od czwartego do dziewiątego. Tak działa stronicowanie: skip równe numer strony minus jeden razy rozmiar strony, a limit równy rozmiarowi strony.

Do zapamiętania na test: modyfikatory kursora to sort, limit i skip. Sort przyjmuje dokument z polami i wartościami jeden dla rosnącego albo minus jeden dla malejącego. Limit podaje maksymalną liczbę dokumentów, skip liczbę pominiętych. Kolejność w łańcuchu nie zmienia wyniku, bo zawsze wykonuje się sort, potem skip, potem limit. Bez sort kolejność jest niezdefiniowana. Sortowanie następuje przed projekcją, więc można sortować po polu, którego nie wyświetlasz. Modyfikatory podaje się przed pobraniem wyników z kursora.

## 3.14. Porównanie zapytań SQL i MongoDB

### Diagram find jeszcze raz

Wykład wraca do slajdu z dokumentacji o operacjach odczytu: metoda db kropka collection kropka find, filtr age dolar g t osiemnaście, projekcja name jeden, address jeden i modyfikator limit pięć. Przypominam nazwy części: collection, query criteria, projection i cursor modifier. Potem następuje seria tabel z dokumentacji, które zestawiają instrukcje SELECT z SQL z poleceniami find. Opowiem je wiersz po wierszu.

### SELECT i projekcja

SELECT gwiazdka FROM people odpowiada db kropka people kropka find, z pustymi nawiasami.

SELECT id, user_id, status FROM people odpowiada db kropka people kropka find, pierwszy argument puste klamry, drugi user_id jeden, status jeden. Kolumna id z SQL to tu podkreślnik id, które pojawia się samo, bo jest dodawane domyślnie. Dlatego nie wymieniamy go w projekcji.

SELECT user_id, status FROM people, czyli bez id, odpowiada find z pustym filtrem i projekcją user_id jeden, status jeden, podkreślnik id zero. Żeby identyfikatora nie było, trzeba go jawnie wyłączyć.

SELECT gwiazdka FROM people WHERE status równa się A odpowiada find z filtrem status A.

SELECT user_id, status FROM people WHERE status równa się A odpowiada find z filtrem status A i projekcją user_id jeden, status jeden, podkreślnik id zero.

Wzór jest taki: WHERE trafia do pierwszego argumentu find, a lista kolumn po SELECT do drugiego. Pusty filtr to brak WHERE.

### WHERE z warunkami

SELECT gwiazdka FROM people WHERE status różne od A odpowiada find, status dwukropek, w klamrach dolar n e dwukropek A.

WHERE status równa się A AND age równa się pięćdziesiąt odpowiada find z jednym dokumentem filtra: status A, przecinek, age pięćdziesiąt. AND z SQL to po prostu przecinek.

WHERE status równa się A OR age równa się pięćdziesiąt odpowiada find, w klamrach dolar or dwukropek, w nawiasie kwadratowym dwa dokumenty: status A i age pięćdziesiąt. OR wymaga jawnego dolar or z tablicą.

WHERE age większe niż dwadzieścia pięć odpowiada find, age, dolar g t, dwadzieścia pięć. WHERE age mniejsze niż dwadzieścia pięć odpowiada find, age, dolar l t, dwadzieścia pięć.

WHERE age większe niż dwadzieścia pięć AND age mniejsze lub równe pięćdziesiąt odpowiada find, age dwukropek, w klamrach dolar g t dwadzieścia pięć, przecinek, dolar l t e pięćdziesiąt. Oba operatory w jednym dokumencie przy jednym polu.

### LIKE i ORDER BY

WHERE user_id LIKE procent bc procent, czyli zawiera bc w dowolnym miejscu, odpowiada find, user_id dwukropek, ukośnik bc ukośnik, albo równoważnie user_id dwukropek, w klamrach dolar regex dwukropek, ukośnik bc ukośnik. Wyrażenie regularne bez kotwic dopasowuje fragment w dowolnym miejscu, więc procenty z obu stron są niepotrzebne.

WHERE user_id LIKE bc procent, czyli zaczyna się od bc, odpowiada find, user_id dwukropek, ukośnik, daszek bc, ukośnik, albo z dolar regex i tym samym wzorcem. Daszek to odpowiednik braku procentu na początku wzorca LIKE.

Dla porządku dodam, że LIKE procent bc, czyli kończy się na bc, odpowiada wzorcowi bc dolar, gdzie znak dolara oznacza koniec tekstu. Tego na slajdzie nie ma, ale wynika z tej samej zasady.

WHERE status równa się A ORDER BY user_id ASC odpowiada find z filtrem status A, a po nim kropka sort, user_id dwukropek jeden. Z DESC zamiast ASC piszesz sort user_id minus jeden. Na slajdzie początki tych poleceń są ucięte paskiem przewijania, ale wiadomo, że chodzi o db kropka people kropka find.

### COUNT i DISTINCT

SELECT COUNT gwiazdka FROM people odpowiada db kropka people kropka count, puste nawiasy, albo db kropka people kropka find, kropka count. Zaznaczam, że metoda count i kursorowe count są w nowych wersjach przestarzałe. Ich następcami są countDocuments i estimatedDocumentCount, o których mówiliśmy na początku działu. Tabela pochodzi ze starszej wersji dokumentacji.

SELECT COUNT user_id FROM people liczy w SQL tylko wiersze, w których user_id nie jest NULL. W MongoDB odpowiednikiem jest count z filtrem user_id, dolar exists true, albo find z tym filtrem i kropka count. Ściśle biorąc, dolar exists true policzy też dokumenty z user_id równym null, więc odpowiednik nie jest idealny, ale tak go podaje dokumentacja.

SELECT COUNT gwiazdka FROM people WHERE age większe niż trzydzieści odpowiada db kropka people kropka count z filtrem age dolar g t trzydzieści, albo find z tym filtrem i kropka count.

SELECT DISTINCT status FROM people ma dwa odpowiedniki. Pierwszy to agregacja: db kropka people kropka aggregate, w nawiasie tablica z jednym etapem, w klamrach dolar group dwukropek, w klamrach podkreślnik id dwukropek, w cudzysłowie dolar status. Grupowanie po statusie daje po jednym dokumencie na każdą różną wartość. Drugi, prostszy, to db kropka people kropka distinct, w nawiasie status w cudzysłowie. Tabela dodaje zastrzeżenie: distinct nadaje się dla zbiorów wartości, które nie przekraczają limitu rozmiaru BSON. Wynik distinct wraca jako jeden dokument, a pojedynczy dokument BSON może mieć najwyżej szesnaście megabajtów. Agregacja tego ograniczenia nie ma, bo zwraca wyniki kursorem.

### LIMIT, SKIP i EXPLAIN

SELECT gwiazdka FROM people LIMIT jeden odpowiada db kropka people kropka findOne, albo db kropka people kropka find, kropka limit jeden. Różnica techniczna: findOne zwraca sam dokument albo null, a find z limit jeden zwraca kursor z co najwyżej jednym dokumentem.

Na slajdzie kolejny wiersz brzmi SELECT gwiazdka FROM people LIMIT pięć SKIP dziesięć i odpowiada mu db kropka people kropka find, kropka limit pięć, kropka skip dziesięć. Uwaga: w SQL nie ma słowa kluczowego SKIP. W MySQL i PostgreSQL pisze się LIMIT pięć OFFSET dziesięć. Ta nieścisłość pochodzi z dokumentacji MongoDB, z której wzięto tabelę. Polecenie MongoDB jest poprawne i, zgodnie z tym, co mówiliśmy o modyfikatorach, pomija dziesięć dokumentów i zwraca pięć następnych, mimo że limit jest napisany przed skip.

EXPLAIN SELECT gwiazdka FROM people WHERE status równa się A odpowiada db kropka people kropka find z filtrem status A, a po nim kropka explain, z pustymi nawiasami. Explain pokazuje plan wykonania zapytania, na przykład czy użyto indeksu, czy przejrzano całą kolekcję.

Do zapamiętania na test: WHERE to pierwszy argument find, lista kolumn to drugi, czyli projekcja. Podkreślnik id pojawia się sam, więc SELECT bez id wymaga podkreślnik id zero. AND to przecinek, OR to dolar or z tablicą, różne to dolar n e, przedział to dwa operatory przy jednym polu. LIKE z procentami po obu stronach to wyrażenie regularne bez kotwic, a LIKE bc procent to wzorzec z daszkiem. ORDER BY ASC to sort z jedynką, DESC z minus jedynką. COUNT to count, a dziś countDocuments; COUNT kolumny to filtr dolar exists true. DISTINCT to metoda distinct albo agregacja z dolar group po polu. LIMIT jeden to findOne albo limit jeden, LIMIT z OFFSET to limit i skip, a EXPLAIN to metoda explain na kursorze.

To wszystko w trzecim dziale. Jeżeli masz zapamiętać z niego tylko kilka rzeczy, niech to będą te: insertMany przyjmuje tablicę; updateOne i updateMany potrzebują operatorów, a replaceOne zastępuje cały dokument; dolar push z dolar each dodaje kilka elementów, a dolar addToSet pomija duplikaty; upsert true wstawia dokument, gdy nic nie pasuje; dolar in to „którykolwiek”, dolar all to „wszystkie”, dolar elemMatch to „wszystkie warunki w jednym elemencie”; dolar not stoi przy polu, a dolar and, dolar or i dolar nor na najwyższym poziomie; projekcja nie miesza zer i jedynek poza podkreślnik id; a sort, skip i limit wykonują się zawsze w tej kolejności, niezależnie od zapisu.


# 4. MongoDB — walidacja schematu, Aggregation Framework, import i indeksy

Witaj w czwartym dziale. Ten fragment wykładu jest bardzo praktyczny i na teście wraca w pytaniach o składnię, więc słuchaj uważnie nawiasów, dolarów i nazw parametrów. Najpierw zajmiemy się walidacją schematu, czyli tym, jak w bazie o elastycznym schemacie wymusić, żeby dokumenty miały określoną strukturę. Poznasz operator dolar jsonSchema, parametry validationLevel i validationAction, polecenie collMod oraz walidację obiektów zagnieżdżonych. Potem przejdziemy do Aggregation Framework: czym jest potok agregacji, czym różni się od zwykłego zapytania MQL, jak czytać plan wykonania przez explain i jak uruchamiać potoki w Visual Studio Code. Omówimy po kolei najważniejsze etapy potoku: dolar match, dolar group, dolar sort, dolar limit, dolar project, dolar addFields, dolar count, dolar lookup i dolar out, a także tabelę, która tłumaczy pojęcia SQL na operatory agregacji. Następnie krótko o narzędziu mongoimport i o przestarzałym mechanizmie Map-Reduce. Na końcu indeksy: po co są, jakie są ich rodzaje, czym jest indeks TTL, indeks jednopolowy, złożony, multikey, i wreszcie nowoczesny indeks wektorowy, który służy do wyszukiwania semantycznego.

## Walidacja schematu w MongoDB

### Elastyczny schemat i reguły walidacji

Zacznijmy od punktu wyjścia. MongoDB domyślnie ma elastyczny schemat. Oznacza to, że kolekcja na starcie nie ma żadnej skonfigurowanej walidacji: do tej samej kolekcji możesz wstawić dokument z polem tytuł, a zaraz potem dokument z zupełnie innymi polami, i baza nie zaprotestuje. To jest zaleta, gdy model danych dopiero się kształtuje, ale w dojrzałej aplikacji często chcemy mieć pewność, że wszystkie dokumenty w kolekcji mają podobną strukturę. Do tego służą reguły walidacji schematu. Zwróć uwagę na słowo „domyślnie”: elastyczny schemat to ustawienie początkowe, a nie brak możliwości kontroli. Częsta pułapka testowa brzmi: „MongoDB nie pozwala wymusić struktury dokumentów”. To zdanie jest fałszywe.

Reguły walidacji podajemy najczęściej w chwili tworzenia kolekcji, poleceniem createCollection. Przykład ze slajdu wygląda tak. Piszemy db, kropka, createCollection, w nawiasie najpierw nazwa kolekcji w cudzysłowie, czyli posts, przecinek, a potem obiekt opcji w klamrach. W tym obiekcie pierwsza opcja to validator, dwukropek, i kolejne klamry. Wewnątrz walidatora stoi operator dolar jsonSchema, dwukropek, i obiekt schematu. W schemacie mamy najpierw bsonType, dwukropek, w cudzysłowie object, co znaczy, że cały dokument ma być obiektem. Dalej required, dwukropek, i tablica w nawiasach kwadratowych z nazwami pól wymaganych: title i body. Dalej properties, czyli opis poszczególnych pól. Pole title ma bsonType string i opis description o treści „Title of post - Required”. Pole body też ma bsonType string i opis, że jest wymagane. Pole category ma bsonType string i opis, że jest opcjonalne. Zauważ, że category jest opisane w properties, ale nie ma go w tablicy required. To znaczy: pole category nie musi wystąpić, ale jeśli wystąpi, musi być napisem. To bardzo ważne rozróżnienie. Tablica required mówi, które pola muszą istnieć. Obiekt properties mówi, jak mają wyglądać pola, jeśli istnieją.

Po walidatorze, ale nadal w obiekcie opcji createCollection, stoją dwa dodatkowe parametry: validationLevel z wartością strict i validationAction z wartością error. Komentarze na slajdzie mówią: na start pełna walidacja i na start odrzucaj błędne. Te dwa parametry omówimy za chwilę dokładniej.

Słowo bsonType warto zapamiętać. MongoDB przechowuje dokumenty w formacie BSON, czyli binarnym JSON, który ma więcej typów niż zwykły JSON, na przykład date, objectId, decimal, int czy long. Dlatego w walidacji MongoDB używamy słowa kluczowego bsonType, a nie tylko type ze standardu JSON Schema. Słowo type też jest obsługiwane, ale zna tylko typy JSON. Na teście zapamiętaj, że w przykładach z wykładu typ pola podajemy przez bsonType.

Po zdefiniowaniu kolekcji slajd pokazuje dwie próby wstawienia. Pierwsza: db, kropka, posts, kropka, insertOne, a w nawiasie dokument z polami title, body i category. Ten dokument jest poprawny, bo ma oba pola wymagane i wszystkie są napisami, więc zostanie wstawiony. Druga próba wygląda podobnie, ale zamiast pola body jest pole newbody. Teraz brakuje wymaganego pola body, więc walidacja nie przechodzi, a skoro validationAction to error, operacja zostanie odrzucona z błędem walidacji dokumentu, po angielsku Document failed validation. To typowe pytanie testowe: który insert się powiedzie, a który nie. Pamiętaj, że w tym pierwszym schemacie nie ma ustawienia additionalProperties równego false, więc samo dodatkowe pole newbody nie jest problemem. Problemem jest brak body.

### Dolar jsonSchema razem z dolar expr

Drugi przykład na tym samym slajdzie pokazuje, że walidator nie musi składać się wyłącznie z dolar jsonSchema. Tworzymy kolekcję sales. W walidatorze stoi operator dolar and z tablicą dwóch warunków. Pierwszy warunek to walidacja operatorami zapytań: dolar expr, a w nim dolar lt, czyli less than, z tablicą dwóch wyrażeń: dolar lineItems kropka discountedPrice oraz dolar lineItems kropka price. Sens jest taki, że cena po rabacie ma być mniejsza od ceny zwykłej. Drugi warunek to dolar jsonSchema, w którym w properties pole items ma bsonType array, czyli musi być tablicą.

Mała uwaga techniczna: na slajdzie w tym drugim przykładzie brakuje jednej zamykającej klamry. Po zamknięciu obiektu validator powinna jeszcze zamknąć się klamra całego obiektu opcji, a dopiero potem okrągły nawias createCollection. To drobny błąd przepisywania, nie zmienia sensu.

Slajd podsumowuje różnicę tak. Dolar jsonSchema służy do walidacji strukturalnej: sprawdza typy pól, obecność wymaganych pól i inne aspekty typowe dla schematu JSON. Dolar expr jest bardziej elastyczny: pozwala walidować z użyciem logiki, operacji arytmetycznych i porównań między polami tego samego dokumentu, co daje więcej możliwości w przypadkach dynamicznych. Oba mechanizmy można łączyć, na przykład przez dolar and, i wtedy dostajemy zaawansowany system walidacji, który obejmuje zarówno statyczną strukturę, jak i dynamiczne warunki. Prosta analogia: dolar jsonSchema to formularz z rubrykami, który sprawdza, czy każda rubryka jest wypełniona i czy w polu na liczbę jest liczba. Dolar expr to księgowy, który sprawdza, czy liczby w rubrykach mają ze sobą sens, na przykład czy rabat nie jest większy od ceny.

### Parametry walidacji: tabela opcji

Kolejny slajd powtarza definicję kolekcji posts i opisuje w tabeli wszystkie parametry. Opowiem je po kolei.

Validator to obiekt definiujący reguły walidacji, najczęściej z użyciem dolar jsonSchema. Przykładowa wartość to klamry z dolar jsonSchema w środku.

Dolar jsonSchema to specyfikacja schematu w stylu JSON Schema. Określa typy, wymagane pola i dodatkowe właściwości. Przykład wartości: bsonType object.

Required to tablica nazw pól, które muszą wystąpić w dokumencie, na przykład tablica z title i body.

Properties to definicja poszczególnych pól: ich typ, opis i dodatkowe reguły. Przykład: title, a w nim bsonType string.

AdditionalProperties określa, czy dozwolone są pola spoza schematu. Przyjmuje wartość true albo false. Gdy ustawimy false, dokument nie może zawierać żadnych dodatkowych pól poza tymi, które są jawnie wymienione w properties. Na slajdzie jest mała ramka z kodem, w której przy additionalProperties false w properties pojawia się pozycja underscore id z pustym obiektem. To nie jest przypadek, i to jest klasyczna pułapka. MongoDB automatycznie dodaje do każdego dokumentu pole underscore id. Jeśli ustawisz additionalProperties na false i nie wymienisz underscore id w properties, to każdy insert zostanie odrzucony, bo underscore id zostanie potraktowane jako pole spoza schematu. Dlatego wpisujemy underscore id, dwukropek, puste klamry, co znaczy: to pole jest dozwolone i nie narzucamy mu typu.

ValidationLevel to poziom walidacji. Ma trzy wartości. Strict, czyli ścisły, to pełna walidacja: sprawdzane są wszystkie wstawienia i wszystkie aktualizacje. Moderate, czyli umiarkowany, według slajdu oznacza walidację tylko nowych dokumentów i modyfikowanych pól, a istniejące dokumenty mogą nie spełniać schematu. Off oznacza wyłączenie walidacji. Doprecyzuję poziom moderate, bo slajd mówi to w uproszczeniu. Według dokumentacji MongoDB przy poziomie moderate walidowane są wszystkie wstawienia oraz aktualizacje tych dokumentów, które już wcześniej spełniały schemat. Aktualizacje dokumentów, które już wcześniej były niezgodne ze schematem, nie są sprawdzane. Po co to? Wyobraź sobie, że dodajesz walidator do starej kolekcji, w której są tysiące historycznych, niechlujnych dokumentów. Strict zablokowałby każdą ich aktualizację, dopóki nie naprawisz ich w całości. Moderate pozwala żyć ze starymi danymi, a pilnuje nowych i tych, które już są czyste. Na teście, jeśli pytanie powtarza sformułowanie ze slajdu, czyli „nowe dokumenty i modyfikowane pola, istniejące dokumenty mogą nie spełniać schematu”, to chodzi o moderate.

ValidationAction to reakcja na niezgodność. Ma dwie wartości. Error odrzuca operację. Warn zapisuje dokument mimo niezgodności, ale generuje ostrzeżenie w logach serwera. Nie pomyl tych dwóch parametrów. ValidationLevel mówi, które operacje sprawdzamy, czyli jak szeroko patrzymy. ValidationAction mówi, co robimy, gdy sprawdzenie wypadnie źle. Wartości error i warn należą do validationAction, a wartości strict, moderate i off należą do validationLevel. Ulubiony dystraktor testowy to validationLevel warn albo validationAction strict, a oba są niepoprawne. Domyślnie, gdy podasz walidator bez tych parametrów, MongoDB przyjmuje validationLevel strict i validationAction error.

### Sprawdzanie, usuwanie i wyłączanie walidatora

Następny slajd pokazuje, jak zarządzać walidatorem już istniejącej kolekcji. Żeby sprawdzić walidator przypisany do kolekcji, mamy dwie drogi. Pierwsza: db, kropka, runCommand, a w nawiasie dokument z poleceniem listCollections, dwukropek, jeden, oraz filter, dwukropek, i klamry z name posts. Druga, wygodniejsza w powłoce: db, kropka, getCollectionInfos, a w nawiasie filtr z name posts. Obie zwracają informacje o kolekcji, w tym w polu options jej validator, validationLevel i validationAction.

Żeby usunąć walidator, używamy polecenia collMod, czyli collection modify, modyfikacja kolekcji. Piszemy db, kropka, runCommand, a w nawiasie dokument: collMod, dwukropek, nazwa kolekcji posts, następnie validator, dwukropek, puste klamry, co ustawia pusty walidator, i opcjonalnie validationLevel off, żeby dodatkowo wyłączyć walidację. Żeby tylko wyłączyć walidację, bez kasowania reguł, wystarczy db, kropka, runCommand z dokumentem collMod posts i validationLevel off. Różnica jest praktyczna. Pusty walidator kasuje reguły na zawsze. Poziom off wyłącza ich egzekwowanie, ale reguły zostają zapisane, więc później możesz przywrócić strict jednym poleceniem collMod. Tym samym poleceniem collMod możesz też dodać lub zmienić walidator w istniejącej kolekcji, podając nowy obiekt validator.

Slajd przypomina też, czym jest runCommand. To uniwersalna funkcja MongoDB służąca do wykonywania poleceń administracyjnych i specjalnych komend bazy. Wiele metod powłoki, takich jak getCollectionInfos, to w gruncie rzeczy wygodne opakowania na runCommand.

Na tym samym slajdzie jest akapit o walidacji przy aktualizacji danych, który powtarza znaczenie parametrów: strict wymusza pełną walidację zarówno nowych dokumentów, jak i aktualizacji, moderate waliduje tylko nowe dokumenty i aktualizowane pola, więc istniejące dokumenty mogą nie spełniać schematu, error odrzuca operacje niezgodne ze schematem, a warn zapisuje je, ale wyświetla ostrzeżenie.

### Walidacja obiektów zagnieżdżonych

Ostatni slajd o walidacji pokazuje obiekt zagnieżdżony. Znowu tworzymy kolekcję posts, ale tym razem required zawiera trzy pola: title, body i author. Na poziomie głównym ustawiamy additionalProperties false, czyli blokujemy pola spoza schematu, a w properties zostawiamy systemowe pole underscore id z pustym obiektem, dokładnie z tego powodu, o którym mówiłem przed chwilą. Pole title ma bsonType string, body też string, category jest opcjonalne i ma typ string.

Najważniejsze jest pole author. Ma ono bsonType object, czyli jest dokumentem zagnieżdżonym. I teraz uwaga: wewnątrz author znowu piszemy required, tym razem z polami name i email, znowu additionalProperties false, z komentarzem „nie pozwalaj na śmieci wewnątrz”, i znowu properties. Pole name ma typ string. Pole email ma typ string, a do tego słowo kluczowe pattern z wyrażeniem regularnym, które sprawdza prosty format adresu e-mail: na początku jeden lub więcej znaków, które nie są białym znakiem ani małpą, potem małpa, potem znowu takie znaki, potem kropka i znowu takie znaki. Description mówi: prosta walidacja formatu e-mail. Dalsza część kodu na slajdzie jest obcięta, ale zasada jest jasna.

Wniosek jest taki: schemat jest rekurencyjny. Obiekt zagnieżdżony opisujemy dokładnie tymi samymi słowami kluczowymi co cały dokument: bsonType object, required, additionalProperties i properties. Wymagania pól wewnętrznych deklarujemy wewnątrz tego obiektu, a nie na poziomie głównym. Gdybyś na poziomie głównym napisał required z napisem author kropka name, to nie zadziała tak, jak myślisz, bo w JSON Schema required odnosi się do bezpośrednich pól danego obiektu.

Do zapamiętania na test: MongoDB domyślnie ma elastyczny schemat, a reguły walidacji dodajemy opcją validator, najczęściej z operatorem dolar jsonSchema, w createCollection albo później przez collMod. W schemacie typ pola podajemy przez bsonType, pola obowiązkowe w tablicy required, opis pól w properties, a additionalProperties false zabrania pól spoza listy i wymaga dopisania underscore id. Dolar jsonSchema sprawdza strukturę, dolar expr pozwala na logikę i porównania między polami, i można je łączyć przez dolar and. ValidationLevel ma wartości strict, moderate i off, a validationAction ma wartości error i warn. Walidator sprawdzamy przez getCollectionInfos albo runCommand z listCollections, usuwamy przez collMod z pustym validatorem, a wyłączamy przez collMod z validationLevel off. Obiekty zagnieżdżone walidujemy, zagnieżdżając w nich własne required, properties i additionalProperties.

## Aggregation Framework

### Do czego służy Aggregation Framework

Aggregation Framework to wszechstronne narzędzie MongoDB do przetwarzania, transformacji i analizy danych. Slajd wymienia typowe zastosowania i każde z nich warto znać, bo pytanie „do czego służy” jest bardzo prawdopodobne. Pierwsze zastosowanie to analityka danych w czasie rzeczywistym. Drugie to generowanie raportów zawierających zestawienia, sumy, średnie i inne statystyki. Trzecie to zasilanie paneli analitycznych, czyli dashboardów. Czwarte to łączenie danych z wielu kolekcji po stronie serwera, do czego służy etap dolar lookup. Piąte to przekształcanie i przygotowywanie danych do celów analitycznych i Data Science. Szóste to analiza dużych wolumenów danych. Siódme to złożone zapytania, które wymagają grupowania, filtrowania, sortowania i transformacji danych. Ósme to przygotowywanie danych na potrzeby uczenia maszynowego oraz integracja z narzędziami takimi jak MongoDB Spark Connector, czyli łącznik do Apache Spark. I wreszcie wiele innych zadań związanych z przetwarzaniem danych.

Kluczowa myśl tego slajdu: dzięki potokowi agregacji, po angielsku Aggregation Pipeline, większość operacji wykonuje się bezpośrednio po stronie serwera. To ogranicza transfer danych przez sieć i poprawia wydajność aplikacji. Pomyśl o tym tak: zamiast ściągać milion zamówień do aplikacji i tam liczyć sumę, prosisz bazę, żeby sama policzyła i odesłała ci jeden dokument z wynikiem.

### Potok agregacji: przykład z trzema najmłodszymi inżynierami

Potok agregacji to tablica etapów, po angielsku stages. Każdy etap to dokument z jednym operatorem etapu, na przykład dolar match. Dokumenty przepływają przez etapy jak woda przez kolejne filtry w rurze: wyjście jednego etapu jest wejściem następnego.

Slajd definiuje potok w zmiennej. Piszemy var pipeline, znak równości, i nawias kwadratowy otwierający tablicę. Pierwszy etap, z komentarzem „Match engineers only”, to klamry z dolar match, a w nim pole vocation równe ENGINEER. Drugi etap, „Sort by youngest person first”, to dolar sort z polem dateofbirth i wartością minus jeden. Minus jeden to sortowanie malejące. Dlaczego malejąco po dacie urodzenia daje najmłodszych? Bo najmłodsza osoba urodziła się najpóźniej, a późniejsza data jest większa. Trzeci etap, „Only include the first 3 youngest people”, to dolar limit trzy. Czwarty etap, „Exclude unrequired fields”, to dolar unset z tablicą nazw pól do usunięcia: underscore id, vocation i address. Czerwona ramka na slajdzie tłumaczy całość jednym zdaniem: pokaż trzech najmłodszych inżynierów, ale bez pól underscore id, vocation i address.

Etap dolar unset warto zapamiętać jako krótszy zapis wykluczenia pól. Jest to odpowiednik dolar project z zerami przy wykluczanych polach. Przyjmuje nazwę jednego pola w cudzysłowie albo tablicę nazw.

Potok wykonujemy poleceniem db, kropka, persons, kropka, aggregate, a w nawiasie zmienna pipeline. Zwróć uwagę, że metoda aggregate przyjmuje tablicę etapów.

Diagram po prawej stronie slajdu pokazuje ideę etapów. Kolekcja źródłowa, Source Collection, trafia do etapu Match, narysowanego jako niebieski lejek. Z niego wychodzi zbiór pośredni, Intermediate Data-Set. Ten zbiór trafia do etapu Group, narysowanego jako pomarańczowy lejek, i dopiero z niego wychodzi wynik końcowy, Final Result. Każdy etap zawęża albo przekształca dane, a kolejny pracuje tylko na tym, co dostał od poprzedniego.

### Potok agregacji a MQL

Następny slajd porównuje ten potok z klasycznym zapytaniem MQL, czyli MongoDB Query Language. Ten sam wynik daje zapytanie: db, kropka, persons, kropka, find, a w nawiasie dwa dokumenty. Pierwszy to filtr: vocation równe ENGINEER. Drugi to projekcja: underscore id zero, vocation zero, address zero, czyli wykluczenie tych trzech pól. Po find dołączamy kropka sort z dateofbirth minus jeden i kropka limit trzy. Slajd dopowiada, że to zapytanie osiąga ten sam wynik, ale nie ma tu grupowania. I to jest sedno różnicy. Proste filtrowanie, sortowanie, limit i projekcję zrobisz zarówno find, jak i aggregate. Ale grupowania, liczenia statystyk po grupach, łączenia kolekcji czy zapisu wyniku do nowej kolekcji samym find nie zrobisz. Do tego potrzebny jest potok agregacji.

Slajd mówi dalej, że potok agregacji jest obsługiwany przez specjalny mechanizm w MongoDB, Aggregation Runtime, który jest zoptymalizowany do przetwarzania dużych ilości danych i wykonywania operacji takich jak dolar match, czyli filtrowanie, dolar group, czyli grupowanie, dolar sort, czyli sortowanie, dolar project, czyli transformacja pól, oraz dolar lookup, czyli łączenie kolekcji. Dzięki temu złożone analizy wykonujemy bez opuszczania bazy.

Diagram architektury na tym slajdzie pokazuje u góry aplikację z wbudowanym sterownikiem, MongoDB Driver. Sterownik ma dwa interfejsy: MQL API i Agg API. Gruba strzałka prowadzi w dół do serwera, MongoDB Database Runtime, w którym są dwa silniki: Query Runtime dla zwykłych zapytań i mniejszy blok Aggregation Runtime dla potoków. Zapamiętaj nazwy: zapytania find obsługuje Query Runtime, a potoki aggregate obsługuje Aggregation Runtime.

### Plan wykonania: explain

Kolejny slajd dotyczy planu wykonania. Gdy piszemy zapytania w MQL albo potoki agregacji, warto sprawdzić plan wykonania z trzech powodów. Po pierwsze, żeby upewnić się, że używany jest odpowiedni indeks. Po drugie, żeby ocenić wydajność zapytania. Po trzecie, żeby zdecydować, czy trzeba zoptymalizować model danych albo samo zapytanie. Plan pokazuje, jak MongoDB przetwarza zapytanie, i pozwala analizować koszt operacji, na przykład porównać skan całej kolekcji z użyciem indeksu. W planie zobaczysz wtedy etap COLLSCAN, czyli skan kolekcji, albo IXSCAN, czyli skan indeksu.

Metoda explain ma trzy tryby szczegółowości, po angielsku verbosity. Pierwszy to queryPlanner: podstawowy plan, czyli jakie indeksy i jaka strategia. To tryb domyślny, używany, gdy nie podasz parametru. Drugi to executionStats: dodatkowo statystyki wykonania, czyli liczba przejrzanych dokumentów i czas. Trzeci to allPlansExecution: pełne dane o wszystkich rozważanych planach i ich statystykach, także o planach, które optymalizator odrzucił.

Teraz składnia, bo tu łatwo o pomyłkę. Dla agregacji explain stoi przed aggregate: db, kropka, persons, kropka, explain, w nawiasie w cudzysłowie executionStats, potem kropka, aggregate i w nawiasie pipeline. Analogicznie z queryPlanner i allPlansExecution. Dla find explain stoi na końcu, po kursorze: db, kropka, coll, kropka, find, w nawiasie query, potem kropka, explain, w nawiasie tryb, na przykład queryPlanner, executionStats albo allPlansExecution. Zapamiętaj ten szyk: przy aggregate najpierw explain, potem aggregate, a przy find najpierw find, potem explain. Dlaczego? Bo find zwraca kursor, na którym można wywołać explain, a aggregate od razu wykonuje potok, więc obiekt explain trzeba przygotować przed nim. Jako ciekawostkę dodam, że dla agregacji istnieje też starszy zapis z opcją explain true przekazaną jako drugi argument aggregate, ale na wykładzie używamy formy z explain przed aggregate.

### MongoDB w Visual Studio Code

Slajd o VS Code pokazuje rozszerzenie MongoDB dla Visual Studio Code. W lewym panelu MONGODB jest sekcja CONNECTIONS z połączeniami, na przykład localhost dwukropek 27017, które jest połączone, oraz 27018, 27019 i 27020. Liczba 27017 to domyślny port MongoDB. Jest sekcja PLAYGROUNDS z przyciskiem Create New Playground oraz sekcja HELP AND FEEDBACK z odnośnikami do dokumentacji, zgłaszania błędów i tworzenia darmowego klastra Atlas.

Playground to plik z rozszerzeniem kropka mongodb kropka js, na slajdzie playground-1.mongodb.js, w którym piszesz kod JavaScript dla powłoki MongoDB i uruchamiasz go na aktywnym połączeniu. W edytorze widać ten sam potok z trzema najmłodszymi inżynierami i wywołanie db.persons.aggregate z pipeline. Wynik pojawia się w panelu Playground Result. Są to trzy dokumenty: Carl Simmons urodzony w 1998 roku, Olive Ranieri urodzona w 1985 roku i Elise Smith urodzona w 1972 roku. Kolejność potwierdza sortowanie malejące po dacie urodzenia: najpierw najmłodszy. W wynikach nie ma pól underscore id, vocation ani address, bo usunął je dolar unset. Zauważ też drobiazg, który dobrze ilustruje elastyczny schemat: Olive ma pole gender, a pozostali go nie mają. W tej samej kolekcji dokumenty mogą mieć różne zestawy pól. Daty widać w zapisie z kluczem dolar date, bo tak rozszerzony JSON przedstawia typ daty BSON.

### Tabela: SQL a operatory agregacji

Slajd z poleceniem aggregate zawiera tabelę, która tłumaczy pojęcia SQL na operatory agregacji MongoDB. To jedna z najbardziej „testowych” tabel w całym dziale, więc opowiem ją dokładnie.

WHERE w SQL odpowiada etap dolar match. GROUP BY odpowiada dolar group. HAVING, czyli filtrowanie już po zgrupowaniu, także odpowiada dolar match, tylko ustawiony za etapem dolar group. To ważna pułapka: w MongoDB nie ma osobnego operatora having. O tym, czy dolar match działa jak WHERE, czy jak HAVING, decyduje jego pozycja w potoku. SELECT odpowiada dolar project. ORDER BY odpowiada dolar sort. LIMIT odpowiada dolar limit. Funkcji SUM odpowiada akumulator dolar sum. Funkcji COUNT odpowiada dolar sum, czyli w praktyce dolar sum jeden, oraz dolar sortByCount. Dolar sortByCount grupuje dokumenty po podanym wyrażeniu, liczy, ile jest w każdej grupie, i sortuje grupy malejąco według tej liczby. JOIN odpowiada dolar lookup. SELECT INTO NEW_TABLE, czyli zapis wyniku do nowej tabeli, odpowiada dolar out. MERGE INTO TABLE odpowiada dolar merge, dostępny od MongoDB w wersji 4.2. UNION ALL odpowiada dolar unionWith, dostępny od MongoDB 4.4. Na dole slajdu jest odnośnik do darmowej książki Practical MongoDB Aggregations, z której pochodzi przykład z inżynierami.

Różnica między dolar out a dolar merge jest warta zapamiętania. Dolar out zastępuje całą docelową kolekcję. Dolar merge potrafi scalać wynik z istniejącą kolekcją: dopisywać nowe dokumenty, aktualizować lub zastępować pasujące, czyli działa jak MERGE w SQL.

### Grupowanie danych: ogólna postać i akumulatory

Następny slajd opisuje grupowanie ogólnie. Metoda aggregate pozwala grupować dane na podstawie danego klucza. Na slajdzie jest zapis ogólny: db, kropka, nazwa kolekcji, kropka, aggregate, a w nawiasie klamry z dolar group, w nim underscore id równe kluczowi, a dalej pole wynik z akumulatorem. Tu muszę cię ostrzec, bo zapis na slajdzie ma błąd w nawiasach. Na slajdzie klamra dolar group zamyka się zaraz po underscore id, a pole wynik stoi już poza nią. Tak nie zadziała. Poprawnie pole wynikowe musi być wewnątrz dolar group, obok underscore id: klamry, dolar group, dwukropek, klamry, underscore id, dwukropek, w cudzysłowie dolar klucz, przecinek, wynik, dwukropek, klamry z akumulatorem, na przykład dolar sum i w cudzysłowie dolar pole, i dopiero tu zamykamy dolar group. Druga drobna rzecz: żeby grupować według wartości pola, nazwę pola poprzedzamy dolarem, na przykład w cudzysłowie dolar cust_id. Napis bez dolara byłby stałą, więc wszystkie dokumenty trafiłyby do jednej grupy.

Podstawowe operatory agregujące, czyli akumulatory, to dolar sum, czyli suma, dolar avg, czyli średnia, dolar min, czyli wartość minimalna, i dolar max, czyli wartość maksymalna. W ramce obok jest szersza lista: dolar count, czyli liczba dokumentów w grupie, dolar first, czyli pierwsza wartość w grupie, dolar last, czyli ostatnia wartość w grupie, dolar push, który zbiera wartości do tablicy, dolar addToSet, który zbiera do tablicy tylko unikalne wartości, dolar stdDevPop, czyli odchylenie standardowe populacji, dolar stdDevSamp, czyli odchylenie standardowe próby, dolar top, który zwraca element o najwyższym miejscu w podanym sortowaniu, i dolar bottom, który zwraca element o najniższym miejscu w sortowaniu. Kilka uwag praktycznych. Dolar first i dolar last mają sens dopiero wtedy, gdy przed grupowaniem posortujesz dokumenty, bo inaczej „pierwszy” znaczy po prostu „ten, który akurat przyszedł pierwszy”. Dolar top i dolar bottom same przyjmują parametr sortBy. Dolar push kontra dolar addToSet to klasyczna para do pomylenia: push zachowuje duplikaty, addToSet je usuwa.

Slajd pokazuje też rozbudowany format, czyli tablicę etapów podawaną jako pierwszy argument aggregate. Przykład ma cztery etapy. Pierwszy: dolar match ze status równym A. Drugi: dolar group z underscore id równym dolar cust_id i polem total, które jest dolar sum z dolar amount. Trzeci: dolar sort z total minus jeden, czyli malejąco. Czwarty: dolar limit dwa. Po polsku: weź tylko zamówienia o statusie A, zsumuj kwoty dla każdego klienta, posortuj klientów od największej sumy i pokaż dwóch pierwszych. Slajd objaśnia operatory: dolar match sprawia, że grupowane są tylko dokumenty spełniające warunek, dolar sort sortuje wyniki rosnąco albo malejąco, a dolar limit określa liczbę wyświetlanych wyników. Ramka na kodzie wymienia etapy potoku: dolar match, dolar group, dolar sort, dolar project, dolar limit, dolar count.

Bardzo ważna wskazówka ze slajdu: jeśli chcemy zliczyć dokumenty w danej grupie, używamy dolar sum jeden. Za każdy dokument w grupie dodajemy jedynkę, więc suma to liczba dokumentów. To jest odpowiednik COUNT z gwiazdką w SQL.

### Potok z etapami: przykład z postami

Slajd o potokach z serwisu w3schools przypomina zasady. Operacje agregacji umożliwiają grupowanie, sortowanie, wykonywanie obliczeń, analizowanie danych i wiele więcej. Potok może mieć jeden lub więcej etapów. Kolejność etapów jest istotna, bo każdy etap działa na wynikach poprzedniego.

Przykład: db, kropka, posts, kropka, aggregate, a w tablicy dwa etapy. Etap pierwszy: dolar match z likes, a w nim dolar gt jeden, czyli tylko posty, które mają więcej niż jedno polubienie. Etap drugi: dolar group z underscore id równym dolar category i polem totalLikes równym dolar sum z dolar likes, czyli suma polubień dla każdej kategorii. Wynik to dwa dokumenty: underscore id News z totalLikes trzy oraz underscore id Event z totalLikes osiem. Zwróć uwagę, że wynik grupowania zawsze ma pole underscore id, w którym siedzi klucz grupy, tu nazwa kategorii.

Dlaczego kolejność ma znaczenie? Gdybyś zamienił etapy i najpierw grupował, a potem filtrował po likes, to po grupowaniu pola likes już by nie było, bo dokumenty wynikowe mają tylko underscore id i totalLikes. Dolar match po grupowaniu musiałby filtrować po totalLikes i dałby zupełnie inny wynik, działałby jak HAVING.

Do zapamiętania na test: Aggregation Framework przetwarza dane po stronie serwera, co zmniejsza transfer i poprawia wydajność, a jego zastosowania to analityka, raporty, dashboardy, łączenie kolekcji przez dolar lookup i przygotowanie danych do uczenia maszynowego. Potok to tablica etapów przekazywana do metody aggregate, a każdy etap pracuje na wyniku poprzedniego, więc kolejność ma znaczenie. Find potrafi filtrować, sortować, limitować i rzutować, ale nie grupuje. Potoki obsługuje Aggregation Runtime, a zapytania find obsługuje Query Runtime. Explain ma tryby queryPlanner, który jest domyślny, executionStats i allPlansExecution; przy agregacji piszemy explain przed aggregate, a przy find explain po find. WHERE i HAVING to dolar match, GROUP BY to dolar group, SELECT to dolar project, ORDER BY to dolar sort, JOIN to dolar lookup, SELECT INTO to dolar out, MERGE INTO to dolar merge od wersji 4.2, a UNION ALL to dolar unionWith od wersji 4.4. Zliczanie w grupie to dolar sum jeden, a dolar push zbiera wszystkie wartości, dolar addToSet tylko unikalne.

## Etapy potoku agregacji

### Dolar group

Etap dolar group grupuje dokumenty według unikalnej wartości underscore id, czyli wyrażenia, które podajemy jako klucz grupy. Pierwszy przykład na slajdzie korzysta z przykładowej kolekcji listingsAndReviews, czyli ogłoszeń w stylu Airbnb. Piszemy db, kropka, listingsAndReviews, kropka, aggregate, a w nawiasie tablica z jednym etapem: klamry, dolar group, dwukropek, klamry, underscore id, dwukropek, w cudzysłowie dolar property_type. To polecenie zwróci wszystkie różne wartości zapisane w polu property_type. Slajd pokazuje przykładowy dokument z podświetloną linią property_type równe Apartment oraz wynik: lista dokumentów, z których każdy ma tylko underscore id z nazwą typu, na przykład Earth house, Train, Guest suite, Hotel, Campsite, Resort, Houseboat, Boat, Condominium, Chalet, Castle, Boutique hotel, Villa, Hut, Apartment, Camper/RV czy Hostel.

Wniosek: dolar group z samym underscore id, bez żadnych akumulatorów, działa jak SELECT DISTINCT w SQL. Daje każdą wartość dokładnie raz. Dla porównania ten sam efekt da metoda db, kropka, kolekcja, kropka, distinct, w nawiasie nazwa pola, tylko że distinct zwraca zwykłą tablicę wartości, a nie dokumenty. Zauważ też, że kolejność grup w wyniku nie jest gwarantowana. Jeśli chcesz mieć ją posortowaną, dodaj po grupowaniu dolar sort.

Drugi slajd o dolar group podaje definicję. Operator dolar group służy do grupowania dokumentów według określonych kryteriów i wykonywania operacji agregacyjnych na każdej grupie. Używa się go w ramach potoku agregacji. Pozwala sumować wartości, wyliczać średnie, wyciągać wartości minimalne lub maksymalne i łączyć wyniki. Przydaje się w analizie danych, na przykład do liczenia zamówień na użytkownika, sumowania wartości zakupów albo wyliczania statystyk dla wybranych kategorii.

Podstawowa struktura wygląda tak: klamry, dolar group, dwukropek, klamry, w nich underscore id z polem lub wyrażeniem określającym kryterium grupowania, a dalej dowolna liczba pól agregacji, z których każde ma postać nazwa pola, dwukropek, klamry z operatorem agregacyjnym i polem. Slajd wyjaśnia dwa elementy. Underscore id służy jako klucz grupy. Można tu podać pojedyncze pole, wyrażenie albo null. Null oznacza, że wszystkie dokumenty trafiają do jednej grupy. To odpowiednik zapytania SQL z funkcją agregującą bez GROUP BY, na przykład gdy chcesz policzyć sumę wszystkich cen w kolekcji. Operator agregacyjny to między innymi dolar sum, dolar avg, dolar min, dolar max, dolar push i dolar addToSet. Underscore id w dolar group jest obowiązkowe; nie da się go pominąć.

Przykłady ze slajdu. Pierwszy: db, kropka, produkty, kropka, aggregate, a w nim dolar group z underscore id równym dolar kategoria i polem totalnaWartosc równym dolar sum z dolar cena. To suma cen produktów w każdej kategorii. Drugi: db, kropka, zamowienia, kropka, aggregate z dolar group, underscore id dolar klientId, i polem liczbaZamowien równym dolar sum jeden. To liczba zamówień każdego klienta. Trzeci: db, kropka, produkty, kropka, aggregate z dolar group, underscore id dolar kategoria, i polem sredniaCena równym dolar avg z dolar cena. To średnia cena w kategorii. Czwarty: db, kropka, artykuly, kropka, aggregate z dolar group, underscore id dolar kategoria, i polem unikalneZnaczniki równym dolar addToSet z dolar znacznik. Wynik w żółtej ramce to dwa dokumenty: underscore id technologia z tablicą unikalnych znaczników AI i ML oraz underscore id nauka z tablicą fizyka i chemia.

Zapamiętaj różnicę między dolar sum jeden a dolar sum z dolar pole. Jedynka liczy dokumenty. Dolar i nazwa pola sumuje wartości tego pola. Typowy dystraktor na teście to dolar count jeden albo dolar sum z napisem „jeden” w cudzysłowie, a poprawna jest liczba jeden bez cudzysłowu.

### Dolar limit

Etap dolar limit ogranicza liczbę dokumentów przekazywanych do następnego etapu. Przykład: db, kropka, movies, kropka, aggregate, a w tablicy jeden etap: klamry, dolar limit, dwukropek, jeden. To polecenie zwróci pierwszy znaleziony dokument z kolekcji filmów. Na slajdzie widać wynik: film z polami underscore id typu ObjectId, plot, czyli opis fabuły, genres z gatunkami Short, Drama i Fantasy, runtime czternaście minut, rated UNRATED, cast z listą aktorów i num_mflix_comments. Ważne: „pierwszy znaleziony” bez sortowania oznacza pierwszy w naturalnej kolejności przechowywania, a nie żaden logiczny pierwszy. Jeśli zależy ci na konkretnym dokumencie, najpierw sortuj.

Drugi slajd definiuje: dolar limit służy do ograniczenia liczby dokumentów zwracanych po przetworzeniu wcześniejszych etapów. Przydaje się, gdy chcemy pobrać tylko pierwsze n dokumentów z wyniku. Składnia jest najprostsza ze wszystkich etapów: klamry, dolar limit, dwukropek, i dodatnia liczba całkowita. Na przykład db, kropka, produkty, kropka, aggregate, a w tablicy dolar limit pięć.

Slajd daje ważną radę: dolar limit powinien być używany po etapach takich jak dolar sort czy dolar match, żeby najpierw przefiltrować lub posortować dokumenty, a dopiero potem ograniczyć liczbę wyników. Przykłady: dolar sort z cena minus jeden, a potem dolar limit trzy, co daje trzy najdroższe produkty. Dolar match z klientId równym napisowi 12345, a potem dolar limit dziesięć, co daje najwyżej dziesięć zamówień tego klienta. Dolar sort z data_dodania minus jeden i dolar limit pięć, co daje pięć najnowszych artykułów. To klasyczny wzorzec „top N”. Gdybyś odwrócił kolejność i najpierw dał limit, a potem sort, posortowałbyś tylko trzy przypadkowe dokumenty, a nie znalazł trzech najdroższych.

### Dolar project

Etap dolar project przekazuje do następnego etapu tylko określone pola. Przykład z kolekcją restaurants: db, kropka, restaurants, kropka, aggregate, a w tablicy dwa etapy. Pierwszy to dolar project z name jeden, cuisine jeden i address jeden. Drugi to dolar limit pięć. Wynik, na który wskazuje niebieska strzałka, to dokumenty z polami underscore id, name, na przykład Riviera Caterer, cuisine, na przykład American, i address, który sam jest obiektem z polami building, street, zipcode i coord. Zwróć uwagę na underscore id. Nie prosiliśmy o nie, a jednak jest w wyniku. To reguła: underscore id jest dołączane domyślnie, chyba że jawnie je wykluczysz, pisząc underscore id zero.

Drugi slajd o dolar project mówi, że operator ten określa, które pola mają być w dokumencie wynikowym na danym etapie potoku. Pozwala nie tylko wybierać i wykluczać pola, ale też tworzyć nowe pola, wykonywać operacje na istniejących danych i zmieniać strukturę dokumentu. Składnia: klamry, dolar project, dwukropek, klamry, a w nich pary nazwa pola, dwukropek, wartość. Przykład: db, kropka, uzytkownicy, kropka, aggregate z dolar project, imie jeden, wiek jeden. Slajd tłumaczy wartości: jeden oznacza, że pole zostanie uwzględnione, zero, że zostanie wykluczone, a zamiast liczby można podać wyrażenie, które tworzy nowe pole na podstawie istniejących albo przekształca wartości.

Przykłady wyrażeń. Pełne nazwisko: pole pelne_nazwisko równe dolar concat z tablicą trzech elementów: dolar imie, spacja w cudzysłowie i dolar nazwisko. Dolar concat skleja napisy. Rok urodzenia: pole rok_urodzenia równe dolar year z dolar data_urodzenia. Dolar year wyciąga rok z daty. Wartość całkowita: w projekcji nazwa jeden, cena jeden, ilosc jeden, a do tego nowe pole wartosc_calkowita równe dolar multiply z tablicą dolar cena i dolar ilosc. Dolar multiply mnoży.

Dwie pułapki. Pierwsza: w jednym dolar project nie można mieszać włączania i wykluczania pól, czyli jedynek i zer, z jednym wyjątkiem: underscore id zero wolno dopisać do projekcji włączającej. Druga: jeśli w dolar project podasz tylko nowe, wyliczane pole, na przykład samo pelne_nazwisko, to w wyniku będzie tylko to pole i underscore id. Reszta pól zniknie. Dolar project buduje dokument od nowa z tego, co wymienisz. Zapamiętaj też, że w wyrażeniach odwołanie do wartości pola zawsze piszemy z dolarem, w cudzysłowie: dolar cena. Bez dolara „cena” byłoby zwykłym napisem.

### Dolar sort

Etap dolar sort sortuje wszystkie dokumenty w określonej kolejności. Przykład: db, kropka, listingsAndReviews, kropka, aggregate z trzema etapami: dolar sort z accommodates minus jeden, dolar project z name jeden i accommodates jeden, oraz dolar limit pięć. Dokumenty zostaną zwrócone malejąco według pola accommodates, czyli liczby osób, które mieści lokal. Wynik to pięć ogłoszeń, każde z accommodates szesnaście, na przykład dom blisko stacji z dojazdem do opery, Kaena O Kekai, Great Complex of the Cellars, Barra da Tijuca beach house i apartament w centrum Montrealu. Szesnaście to maksymalna wartość w tym zbiorze danych, więc wszystkie pięć pierwszych ma remis. Kolejność dokumentów z tą samą wartością nie jest gwarantowana, chyba że dodasz drugie pole sortowania, na przykład underscore id.

Drugi slajd definiuje: dolar sort sortuje dokumenty w potoku według wskazanych pól i kolejności, rosnąco lub malejąco. Używa się go głównie do uporządkowania wyników po wcześniejszych etapach. Przydaje się razem z dolar limit, gdy chcemy pobrać na przykład najnowsze albo najdroższe dokumenty. Składnia: klamry, dolar sort, dwukropek, klamry, a w nich pole jeden, dwukropek, kolejność, przecinek, pole dwa, dwukropek, kolejność. Jedynka oznacza sortowanie rosnące, minus jedynka malejące. Przykłady: dolar sort z cena jeden, czyli od najtańszego. Dolar sort z wiek jeden i nazwisko minus jeden, czyli najpierw rosnąco po wieku, a w obrębie tego samego wieku malejąco po nazwisku. Dolar sort z wiek minus jeden i dolar limit pięć, czyli pięciu najstarszych użytkowników. Dolar sort z data_dodania minus jeden, czyli od najnowszych artykułów.

Przy sortowaniu po kilku polach kolejność pól w dokumencie ma znaczenie: pierwsze pole decyduje najpierw, drugie rozstrzyga remisy. Typowy dystraktor na teście to wartości w stylu „asc” i „desc” albo true i false. W MongoDB piszemy jeden i minus jeden. Warto wiedzieć, że dolar sort umieszczony na początku potoku może skorzystać z indeksu, a w późniejszych etapach sortuje w pamięci.

### Dolar match

Etap dolar match zachowuje się jak find: filtruje dokumenty, które pasują do podanego zapytania. Przykład: db, kropka, listingsAndReviews, kropka, aggregate z etapami: dolar match z property_type równym House, dolar limit dwa i dolar project z name, bedrooms i price ustawionymi na jeden. Zapytanie zwróci tylko dokumenty, których pole property_type ma wartość House. Wynik to dwa dokumenty: Ribeira Charming Duplex z trzema sypialniami i ceną osiemdziesiąt oraz Charming Flat in Downtown Moda z dwiema sypialniami i ceną pięćset dwadzieścia siedem. Ceny są zapisane jako Decimal128, czyli typ dziesiętny o wysokiej precyzji, dobry do pieniędzy.

Drugi slajd mówi: dolar match służy do filtrowania dokumentów w potoku według określonych kryteriów. Działa podobnie jak filtr w find, ale jest częścią potoku, co pozwala filtrować na wczesnym etapie przetwarzania. Dzięki temu można ograniczyć zbiór dokumentów do tych spełniających warunki, co często zwiększa efektywność całej operacji. Składnia: klamry, dolar match, dwukropek, klamry, a w nich kryteria, czyli pole, dwukropek, wartość lub wyrażenie.

Przykłady. Zakres dat: dolar match z data_zamowienia, a w niej dolar gte, czyli greater than or equal, new Date z datą pierwszego września 2024, oraz dolar lte, czyli less than or equal, new Date z datą trzydziestego września 2024. To zamówienia z września. Cena większa od stu: dolar match z cena, dolar gt sto. Dwa warunki naraz: dolar match z kategoria równą elektronika i cena dolar lt pięćset. Przecinek między warunkami w jednym dokumencie oznacza niejawne AND, czyli oba muszą być spełnione. Alternatywa: dolar match z dolar or i tablicą dwóch warunków: kategoria elektronika albo kategoria meble. Wyrażenie regularne: dolar match z nazwa, a w niej dolar regex z wzorcem ukośnik, daszek, Sam, ukośnik, oraz dolar options z literą i. Daszek oznacza początek napisu, a opcja i oznacza ignorowanie wielkości liter, więc dopasują się nazwy zaczynające się od Sam, sam albo SAM. Ostatni przykład to zwykła równość: kategoria elektronika.

Dlaczego dolar match warto dawać jak najwcześniej? Bo każdy kolejny etap ma wtedy mniej dokumentów do przetworzenia, a dolar match na samym początku potoku może skorzystać z indeksu, tak jak find. Dolar match po dolar group nie użyje już indeksu, bo filtruje dokumenty wyliczone w pamięci. Jedna pułapka: wewnątrz dolar match używamy składni zapytań, takiej jak w find. Jeśli chcesz porównać dwa pola tego samego dokumentu, potrzebujesz dolar expr, tak jak w walidacji z kolekcji sales.

### Dolar addFields

Etap dolar addFields dodaje do dokumentów nowe pola. Przykład: db, kropka, restaurants, kropka, aggregate z trzema etapami. Pierwszy to dolar addFields z polem avgGrade równym dolar avg z dolar grades kropka score. Drugi to dolar project z name jeden i avgGrade jeden. Trzeci to dolar limit pięć. Zapytanie zwraca dokumenty i dodaje do nich pole avgGrade ze średnią ocen restauracji. Warto zrozumieć, co tu się dzieje: grades to tablica ocen, a grades kropka score to tablica samych wyników punktowych. Dolar avg użyty jako wyrażenie na tablicy liczy jej średnią. Wynik: Riviera Caterer ze średnią dziewięć, Wilken's Fine Food ze średnią dziesięć i Kosher Island ze średnią dziesięć i pół.

Drugi slajd definiuje: dolar addFields służy do dodawania nowych pól albo modyfikowania istniejących pól w dokumentach na etapie potoku. Używamy go, gdy chcemy wzbogacić dokument o dodatkowe dane, na przykład wyliczenia, istniejące wartości czy przekształcenia. Nowe pola mogą być wyrażeniami korzystającymi z innych pól dokumentu. Składnia: klamry, dolar addFields, dwukropek, klamry, a w nich nazwa pola, dwukropek, wartość lub wyrażenie.

Przykłady. Stała wartość: dolar addFields ze status równym napisowi aktywny, czyli każdy dokument dostaje pole status o tej wartości. Rok urodzenia: rok_urodzenia równe dolar year z dolar data_urodzenia. Wartość całkowita: wartosc_calkowita równa dolar multiply z tablicą dolar cena i dolar ilosc. Warunek: pole kategoria równe dolar cond, a w nim if, dwukropek, dolar gte z tablicą dolar wiek i osiemnaście, then, dwukropek, dorosły, else, dwukropek, nieletni. Dolar cond to odpowiednik instrukcji if, a w SQL wyrażenia CASE WHEN. I pełne nazwisko: dolar concat z dolar imie, spacją i dolar nazwisko.

Najważniejsza różnica, o którą pytają testy: dolar addFields kontra dolar project. Dolar addFields zachowuje wszystkie istniejące pola i tylko dokłada nowe albo nadpisuje te o tej samej nazwie. Dolar project buduje dokument od nowa i zostawia wyłącznie to, co wymienisz, plus underscore id. Jeśli więc chcesz „wszystko plus jedno wyliczone pole”, wybierasz dolar addFields. Od wersji 4.2 istnieje też alias dolar set, który działa dokładnie jak dolar addFields. Uwaga na nazwę: dolar set jako etap agregacji to co innego niż dolar set jako operator aktualizacji w updateOne, choć idea jest podobna.

### Dolar count

Etap dolar count zlicza wszystkie dokumenty, które dotarły do niego z poprzedniego etapu. Przykład: db, kropka, restaurants, kropka, aggregate z dwoma etapami: dolar match z cuisine równym Chinese, a potem dolar count, dwukropek, w cudzysłowie totalChinese. Polecenie zwraca liczbę dokumentów w polu o nazwie totalChinese. Wynik to jeden dokument: totalChinese dwa tysiące czterysta osiemnaście.

Drugi slajd mówi, że dolar count służy do zliczania dokumentów w potoku, które spełniają określone warunki. Doprecyzuję: sam dolar count nie przyjmuje warunku. Liczy wszystko, co do niego dotrze, a warunki nakładasz wcześniejszym etapem dolar match. Wynikiem jest jeden dokument z jednym nazwanym polem i liczbą. Dolar count przydaje się do szybkiego uzyskania liczby elementów bez osobnego zapytania. Składnia: klamry, dolar count, dwukropek, i w cudzysłowie nazwa pola wynikowego. Argumentem jest napis, a nie liczba ani obiekt. Nazwa nie może być pusta, nie może zaczynać się od dolara i nie może zawierać kropki.

Przykłady. Dolar count z nazwą liczba_produktow, czyli liczba wszystkich produktów. Dolar match z kategorią elektronika i dolar count z nazwą liczba_elektroniki. Dolar match z kwota dolar gt pięćset i dolar count z nazwą zamowienia_powyzej_500. I przykład najciekawszy, z trzema etapami: dolar group z underscore id równym dolar kategoria i liczba_produktow równą dolar sum jeden, potem dolar match z liczba_produktow dolar gte dziesięć, i na końcu dolar count z nazwą kategorie_z_min_10_produktow. To liczy, ile jest kategorii, w których jest co najmniej dziesięć produktów. Ten dolar match po dolar group to dokładnie HAVING z SQL.

Zapamiętaj: dolar count jako etap to jedno, a akumulator dolar sum jeden w dolar group to drugie. Etap dolar count daje jedną liczbę dla całego strumienia. Dolar sum jeden w grupie daje liczbę dla każdej grupy osobno. Etap dolar count jest w praktyce skrótem dla dolar group z underscore id null i dolar sum jeden, po którym następuje projekcja bez underscore id. Jeszcze jedna drobna pułapka: gdy do dolar count nie dotrze żaden dokument, wynik jest pusty, a nie dokument z zerem.

### Dolar lookup

Etap dolar lookup wykonuje złączenie lewostronne zewnętrzne, czyli left outer join, z inną kolekcją w tej samej bazie danych. W podstawowej postaci wymagane są cztery pola. From to kolekcja, z którą łączymy, w tej samej bazie. LocalField to pole w kolekcji podstawowej, czyli tej, na której wywołujemy aggregate. ForeignField to pole w kolekcji wskazanej w from. As to nazwa nowego pola, które będzie zawierać pasujące dokumenty z kolekcji from.

Muszę doprecyzować sformułowanie ze slajdu. Slajd mówi, że localField i foreignField to pola, które „mogą być używane jako unikatowy identyfikator”. W rzeczywistości żadne z nich nie musi być unikalne. Dolar lookup po prostu dopasowuje dokumenty, w których wartość localField jest równa wartości foreignField. Często foreignField to underscore id drugiej kolekcji, więc w praktyce bywa unikalne, ale nie jest to wymóg.

Przykład: db, kropka, comments, kropka, aggregate z etapem dolar lookup, w którym from to movies, localField to movie_id, foreignField to underscore id, a as to movie_details, a potem dolar limit jeden. Zapytanie dołącza dane filmu do każdego komentarza. W wyniku widać komentarz z polami underscore id, name Mercedes Tyler, email, movie_id, text i date, a do tego nowe pole movie_details, które jest tablicą z jednym dokumentem filmu: z jego underscore id, opisem fabuły, gatunkami Short, Drama, Fantasy, czasem trwania czternaście minut i obsadą.

Kluczowa rzecz: pole wskazane w as jest zawsze tablicą, nawet gdy pasuje dokładnie jeden dokument. Jeśli nie pasuje żaden, tablica jest pusta, a dokument z kolekcji podstawowej i tak zostaje w wyniku. Na tym polega „lewostronność” złączenia: zachowujemy wszystkie dokumenty z lewej strony. Jeśli chcesz zamiast tablicy mieć pojedynczy obiekt, po dolar lookup dodaje się zwykle etap dolar unwind, który rozkłada tablicę na osobne dokumenty.

Drugi slajd definiuje: dolar lookup służy do dołączania, czyli join, między dwiema kolekcjami. Łączy dokumenty z jednej kolekcji z dokumentami innej na podstawie wspólnego pola. Przydaje się, gdy chcemy pobrać informacje z różnych kolekcji w jednym zapytaniu, co przypomina JOIN w bazach relacyjnych. Składnia: klamry, dolar lookup, dwukropek, klamry, a w nich from z nazwą kolekcji docelowej, localField z polem lokalnym, foreignField z polem zdalnym i as z nazwą wyniku. Przykłady: db, kropka, uzytkownicy, kropka, aggregate z dolar lookup, from zamowienia, localField underscore id, foreignField uzytkownik_id, as zamowienia, co dokleja do każdego użytkownika tablicę jego zamówień. I db, kropka, produkty, kropka, aggregate z dolar lookup, from kategorie, localField kategoria_id, foreignField underscore id, as kategoria_info, co dokleja do produktu dane jego kategorii. Slajd powtarza objaśnienia: from to nazwa kolekcji, z której dołączamy dokumenty, localField to pole w lokalnej kolekcji używane do dopasowania, foreignField to pole w dołączanej kolekcji używane do dopasowania, a as to nazwa pola, w którym zostaną zapisane dołączone dokumenty.

Typowa pomyłka na teście to zamiana localField z foreignField. Zapamiętaj: local to „u mnie”, czyli w kolekcji, na której wołam aggregate, a foreign to „u nich”, czyli w kolekcji z from. Inna pomyłka to nazwy w stylu to, on albo join zamiast from i as.

### Dolar out

Etap dolar out zapisuje dokumenty zwrócone przez potok do kolekcji. Przykład: db, kropka, listingsAndReviews, kropka, aggregate z dwoma etapami. Pierwszy to dolar group z underscore id równym dolar property_type i polem properties, które jest dolar push z obiektem: name równe dolar name, accommodates równe dolar accommodates, price równe dolar price. Drugi to dolar out, dwukropek, w cudzysłowie properties_by_type. Pierwszy etap grupuje ogłoszenia według typu nieruchomości i dla każdego typu zbiera tablicę obiektów z nazwą, liczbą miejsc i ceną. Dolar push nie musi więc zbierać pojedynczych wartości; może budować całe obiekty. Etap dolar out tworzy nową kolekcję properties_by_type w bieżącej bazie i zapisuje do niej wynik. Na zrzucie widać, że kolekcja properties_by_type ma trzydzieści sześć dokumentów, czyli tyle, ile jest różnych typów nieruchomości, na przykład Boat, Loft, Castle i Barn. Przykładowy dokument ma underscore id Boat i tablicę properties z dwoma obiektami: Myboat and Yacht rentals dla dwóch osób za dwieście i Private cabin dla dwóch osób za trzydzieści pięć.

Drugi slajd definiuje: dolar out zapisuje wyniki potoku bezpośrednio do nowej kolekcji. Przydaje się, gdy chcemy zmaterializować wyniki zapytania, czyli zrobić trwałe dane z dynamicznie wyliczonego wyniku. To trochę jak widok zmaterializowany w bazach relacyjnych, tylko odświeżany ręcznie, przez ponowne uruchomienie potoku. Dolar out tworzy kolekcję, jeśli nie istnieje, albo zastępuje istniejącą kolekcję, co oznacza, że wszystkie dotychczasowe dane w tej kolekcji zostaną usunięte. Składnia: klamry, dolar out, dwukropek, w cudzysłowie nazwa nowej kolekcji. Przykład: db, kropka, produkty, kropka, aggregate z dolar match, dostepnosc równe tak, i dolar out do kolekcji wszystkie_produkty.

Slajd wymienia uwagi. Po pierwsze, zastępowanie kolekcji: dolar out zastępuje istniejącą kolekcję o tej samej nazwie i wszystkie jej dane przepadają. Po drugie, ograniczenia: dolar out nie może być używany razem z niektórymi operatorami, takimi jak dolar merge, i nie działa w ramach transakcji. Sens zakazu łączenia z dolar merge jest prosty: oba etapy zapisują wynik i oba muszą być ostatnie, więc w jednym potoku może być tylko jeden z nich. Po trzecie, dolar out musi być ostatnim etapem potoku. Kolejne przykłady: dolar group po kategorii z liczba_produktow dolar sum jeden i dolar out do kolekcji liczba_produkty, czyli zapis statystyk do nowej kolekcji. Oraz dolar lookup produktów z kategoriami, as kategoria_info, i dolar out do kolekcji produkty_z_kategoriami, czyli zapis złączonych danych.

Do zapamiętania na test: dolar group z samym underscore id daje unikalne wartości, underscore id null tworzy jedną grupę ze wszystkich dokumentów, dolar sum jeden liczy dokumenty, a dolar sum z dolar pole sumuje wartości. Dolar limit przyjmuje liczbę i należy go stawiać po dolar sort albo dolar match. Dolar project wybiera pola jedynką, wyklucza zerem, tworzy nowe pola wyrażeniami i domyślnie zostawia underscore id; nie miesza się jedynek z zerami poza underscore id. Dolar sort używa jeden dla rosnącego i minus jeden dla malejącego. Dolar match filtruje jak find, warto go dawać jak najwcześniej, a po dolar group działa jak HAVING. Dolar addFields dokłada pola i zachowuje resztę, w przeciwieństwie do dolar project; jego aliasem jest dolar set. Dolar count przyjmuje napis z nazwą pola i zwraca jeden dokument z liczbą. Dolar lookup to left outer join w tej samej bazie z polami from, localField, foreignField i as, a wynik w as jest zawsze tablicą. Dolar out zapisuje wynik do kolekcji, zastępuje istniejącą, musi być ostatni, nie łączy się z dolar merge i nie działa w transakcjach.

## Import danych i Map-Reduce

### Narzędzie mongoimport

Żeby ćwiczyć agregacje, potrzebujemy danych. Slajd pokazuje import przykładowych danych z pliku JSON za pomocą narzędzia mongoimport. Polecenie wygląda tak: mongoimport, spacja, minus minus db, znak równości, customers, spacja, minus minus collection, znak równości, clients, spacja, minus minus file, znak równości, Customer05.json. Trzy opcje do zapamiętania: podwójny myślnik db wskazuje bazę docelową, podwójny myślnik collection wskazuje kolekcję docelową, a podwójny myślnik file wskazuje plik z danymi. Jeśli baza albo kolekcja nie istnieje, zostanie utworzona.

Bardzo ważne: mongoimport to osobny program wiersza poleceń, który uruchamiamy w zwykłej konsoli systemu, na przykład w cmd.exe, a nie wewnątrz powłoki mongosh. Wpisanie mongoimport w mongosh nie zadziała. Slajd pokazuje stronę pobierania MongoDB Command Line Database Tools. Opis mówi, że MongoDB Database Tools to zbiór narzędzi wiersza poleceń do pracy z wdrożeniem MongoDB. Narzędzia te są wydawane niezależnie od harmonogramu wydań serwera MongoDB, dzięki czemu dostajemy częstsze aktualizacje i szybciej korzystamy z nowych funkcji. Na zrzucie wybrana jest wersja 100.8.0 dla platformy Windows x86_64. Do tego pakietu należą też inne narzędzia, takie jak mongoexport, mongodump i mongorestore.

Zrzut okna cmd.exe pokazuje trzy importy do bazy henryk. Polecenie ma postać mongoimport.exe z opcjami db, collection i file, uruchomione w katalogu bin rozpakowanych narzędzi. Po każdym uruchomieniu narzędzie wypisuje „connected to: mongodb://localhost/”, czyli domyślnie łączy się z lokalnym serwerem na porcie 27017, potem pasek postępu, a na końcu podsumowanie. Kolekcja listingsAndReviews: dziewięćdziesiąt pięć megabajtów i pięć tysięcy pięćset pięćdziesiąt pięć zaimportowanych dokumentów, zero błędów. Kolekcja movies: czterdzieści jeden i cztery dziesiąte megabajta i dwadzieścia trzy tysiące pięćset trzydzieści dziewięć dokumentów. Kolekcja comments: pięćdziesiąt tysięcy trzysta cztery dokumenty. To właśnie te kolekcje widziałeś w przykładach dolar group, dolar limit i dolar lookup.

Praktyczna uwaga spoza slajdu: domyślnie mongoimport oczekuje pliku, w którym każdy dokument JSON stoi w osobnej linii. Jeśli plik zawiera jedną dużą tablicę JSON, w nawiasach kwadratowych, trzeba dodać opcję minus minus jsonArray. Przydaje się też opcja minus minus drop, która przed importem usuwa istniejącą kolekcję.

### Map-Reduce jako mechanizm przestarzały

Slajd o Map-Reduce ma w tytule słowo „przestarzały”, i to jest najważniejsza informacja. Map-Reduce w MongoDB jest oznaczony jako przestarzały, czyli deprecated, od wersji 5.0, a jego miejsce zajął potok agregacji. Slajd mówi wprost: proces agregacji zapewnia lepszą wydajność i użyteczność niż operacja map-reduce.

Mimo to warto znać budowę polecenia, bo bywa na testach. Piszemy db, kropka, orders, kropka, mapReduce, a w nawiasie trzy argumenty. Pierwszy to funkcja map: function, nawiasy, a w klamrach emit, w nawiasie this kropka cust_id, przecinek, this kropka amount. Funkcja map jest wywoływana dla każdego dokumentu i emituje parę klucz–wartość: kluczem jest identyfikator klienta, wartością kwota zamówienia. Drugi argument to funkcja reduce: function z parametrami key i values, a w klamrach return Array kropka sum z values. Reduce dostaje klucz i tablicę wszystkich wartości wyemitowanych dla tego klucza i zwraca jedną wartość, tu sumę. Trzeci argument to obiekt opcji: query ze status równym A, czyli filtr wstępny, oraz out równe order_totals, czyli nazwa kolekcji wynikowej. Etykiety na slajdzie nazywają te części: Collection, map, reduce, query i output. Funkcje map i reduce pisze się w JavaScripcie, który wykonuje się na serwerze, i to jest jeden z powodów, dla których Map-Reduce jest wolniejszy od natywnych etapów agregacji.

Diagram przepływu pokazuje przykład liczbowy. Kolekcja orders ma cztery dokumenty: klient A123 z kwotą pięćset i statusem A, klient A123 z kwotą dwieście pięćdziesiąt i statusem A, klient B212 z kwotą dwieście i statusem A oraz klient A123 z kwotą trzysta i statusem D. Krok query odrzuca czwarty dokument, bo ma status D. Zostają trzy. Krok map grupuje wartości według klucza: A123 dostaje tablicę pięćset i dwieście pięćdziesiąt, a B212 dostaje dwieście. Krok reduce sumuje i zapisuje do kolekcji order_totals dwa dokumenty: underscore id A123 z value siedemset pięćdziesiąt oraz underscore id B212 z value dwieście. Zwróć uwagę, że wynik Map-Reduce ma pola underscore id i value. Klient A123 ma siedemset pięćdziesiąt, a nie tysiąc pięćdziesiąt, bo zamówienie za trzysta odpadło na etapie query.

Ten sam wynik w potoku agregacji to trzy etapy: dolar match ze status A, dolar group z underscore id dolar cust_id i polem value równym dolar sum z dolar amount, i dolar out do order_totals. Map odpowiada mniej więcej grupowaniu po kluczu, a reduce akumulatorowi.

Do zapamiętania na test: mongoimport to narzędzie wiersza poleceń z pakietu MongoDB Database Tools, wydawanego niezależnie od serwera, i uruchamia się je w konsoli systemu, nie w mongosh. Najważniejsze opcje to minus minus db, minus minus collection i minus minus file, a dla pliku z tablicą JSON minus minus jsonArray. Map-Reduce jest przestarzały, a agregacja daje lepszą wydajność i użyteczność. Polecenie mapReduce przyjmuje funkcję map z emit, funkcję reduce z parametrami key i values oraz opcje query i out. W przykładzie z diagramu klient A123 ma sumę siedemset pięćdziesiąt, a B212 dwieście.

## Indeksy

### Po co są indeksy

Indeksy w MongoDB to struktury danych, które przyspieszają wyszukiwanie i sortowanie w kolekcjach. Działają podobnie do indeksów w bazach relacyjnych: pozwalają szybko odnaleźć dokumenty na podstawie określonych pól. Są kluczowe dla wydajności, szczególnie przy dużych zbiorach danych. MongoDB przechowuje indeksy w strukturze B-drzewa, czyli uporządkowanego drzewa, w którym wyszukiwanie zajmuje czas logarytmiczny, a nie liniowy. Analogia, która zawsze działa: indeks to skorowidz na końcu książki. Zamiast czytać wszystkie strony, sprawdzasz hasło w skorowidzu i od razu wiesz, na której stronie szukać.

Slajd wymienia trzy cele indeksów. Pierwszy to przyspieszanie zapytań: indeksy znacząco skracają czas wyszukiwania, bo MongoDB przeszukuje zindeksowane pola zamiast skanować całą kolekcję. Drugi to optymalizacja sortowania: indeks przechowuje wartości już uporządkowane, więc sortowanie po zindeksowanym polu jest dużo szybsze. Trzeci to zwiększenie efektywności agregacji: indeksy mogą przyspieszyć potoki, szczególnie te, które korzystają z dolar match, dolar sort czy dolar group. Doprecyzuję: najbardziej korzystają etapy umieszczone na początku potoku, bo tylko one pracują jeszcze bezpośrednio na kolekcji.

Kolejny slajd podsumowuje koszty i korzyści. Wydajność zapytań: indeksy wspierają wydajne wykonywanie zapytań. Bez nich baza musi przeskanować każdy dokument w kolekcji, a odpowiedni indeks ogranicza liczbę skanowanych dokumentów. Tworzenie indeksu: w powłoce używamy metody createIndex, a w sterownikach jej odpowiednika. Koszt zapisu: indeksy przyspieszają odczyt, ale spowalniają zapis. W kolekcjach z przewagą zapisów są kosztowne, bo każde wstawienie i każda aktualizacja wymaga odświeżenia wszystkich indeksów. Indeksy zajmują też miejsce na dysku i w pamięci. Dlatego nie zakłada się indeksu na każde pole „na wszelki wypadek”, tylko na pola, po których naprawdę wyszukujesz i sortujesz.

### Rodzaje indeksów

Slajdy o rodzajach indeksów wymieniają ich osiem. Opowiem je po kolei, ze składnią.

Indeks domyślny, po angielsku Primary Index, tworzy się automatycznie na polu underscore id w każdej kolekcji. Zapewnia unikalność każdego dokumentu i szybkie odnajdywanie go po underscore id. Tego indeksu nie można usunąć.

Indeks unikalny, Unique Index, zapewnia, że wszystkie wartości w indeksowanym polu są unikalne. Składnia: db, kropka, uzytkownicy, kropka, createIndex, a w nawiasie dwa dokumenty: pierwszy to klucz indeksu, email jeden, drugi to opcje, unique, dwukropek, true. Taki indeks pilnuje, żeby każdy adres e-mail w kolekcji uzytkownicy był unikalny. Próba wstawienia drugiego dokumentu z tym samym adresem skończy się błędem duplikatu klucza, po angielsku duplicate key error. Zwróć uwagę, że unique to opcja w drugim argumencie, a nie wartość w kluczu indeksu.

Indeks złożony, Compound Index, indeksuje więcej niż jedno pole. Składnia: db, kropka, zamowienia, kropka, createIndex, a w nawiasie klamry z uzytkownik_id jeden i data minus jeden.

Indeks tekstowy, Text Index, umożliwia wyszukiwanie pełnotekstowe w polach typu string. Składnia: db, kropka, artykuly, kropka, createIndex, a w nawiasie tytul, dwukropek, w cudzysłowie text, przecinek, zawartosc, dwukropek, text. Taki indeks umożliwia wyszukiwanie w polach tytul i zawartosc. Zamiast jedynki podajemy tu napis text. Z indeksu tekstowego korzystamy operatorem dolar text z polem dolar search w zapytaniu find. Kolekcja może mieć tylko jeden indeks tekstowy, ale może on obejmować wiele pól, tak jak w przykładzie.

Indeks geoprzestrzenny, Geospatial Index, umożliwia zapytania związane z lokalizacją geograficzną. Składnia: db, kropka, lokacje, kropka, createIndex, a w nawiasie lokalizacja, dwukropek, w cudzysłowie 2dsphere. Indeksuje pole lokalizacja dla zapytań przestrzennych. 2dsphere oznacza geometrię na kuli ziemskiej, z danymi w formacie GeoJSON. Korzystają z niego operatory takie jak dolar near czy dolar geoWithin.

Indeks wielowartościowy, Multikey Index, tworzy się na polach, które mogą zawierać tablice wartości. Przykład: db, kropka, produkty, kropka, createIndex z tagi jeden. Pozwala indeksować dokumenty, w których pole tagi ma wiele wartości. Szczegóły za chwilę, przy osobnym slajdzie.

Indeks częściowy, Partial Index, indeksuje tylko dokumenty, które spełniają określony warunek. Składnia: db, kropka, uzytkownicy, kropka, createIndex, a w nawiasie najpierw status jeden, a potem opcje z partialFilterExpression, dwukropek, klamry, status równe aktywny. Taki indeks obejmuje tylko aktywnych użytkowników, więc jest mniejszy i tańszy w utrzymaniu. Haczyk: zapytanie skorzysta z indeksu częściowego tylko wtedy, gdy jego filtr gwarantuje, że szukane dokumenty mieszczą się w warunku indeksu.

Indeks TTL, czyli Time-To-Live, automatycznie usuwa dokumenty po określonym czasie. Składnia: db, kropka, sesje, kropka, createIndex, a w nawiasie utworzone jeden, a w opcjach expireAfterSeconds, dwukropek, trzy tysiące sześćset. Trzy tysiące sześćset sekund to godzina, więc dokumenty znikają po godzinie od czasu zapisanego w polu utworzone. Typowe zastosowania to sesje użytkowników, tokeny, kody jednorazowe i logi tymczasowe.

Ramka na slajdzie wymienia ograniczenia TTL i ważne uwagi. Po pierwsze, tylko jedno pole typu data; tradycyjnie indeks TTL nie może być indeksem złożonym. Słowo „tradycyjnie” jest na slajdzie nie bez powodu, bo nowsze wersje MongoDB częściowo luzują to ograniczenie w szczególnych przypadkach, ale na test zapamiętaj zasadę: TTL to indeks jednopolowy na polu z datą. Po drugie, brak wsparcia dla kolekcji typu capped, czyli kolekcji o stałym rozmiarze, które same nadpisują najstarsze dokumenty. Po trzecie, obciążenie bazy przy masowym usuwaniu dokumentów w tle z bardzo dużych kolekcji. Dodam dwie rzeczy z dokumentacji. Usuwanie nie jest natychmiastowe: proces w tle sprawdza wygasłe dokumenty mniej więcej co sześćdziesiąt sekund, więc dokument może przeżyć chwilę dłużej niż ustawiony czas. I pole musi zawierać wartość typu data albo tablicę dat. Jeśli w polu jest na przykład napis albo liczba, dokument nigdy nie wygaśnie.

### Indeksy pojedynczego pola

Slajd o indeksach pojedynczego pola pochodzi z dokumentacji MongoDB. Polecenie db, kropka, collection, kropka, createIndex, a w nawiasie name minus jeden, tworzy malejący indeks na polu name. Następnie db, kropka, collection, kropka, getIndexes, z pustym nawiasem, wyświetla wszystkie indeksy kolekcji. Wynik to tablica dwóch dokumentów. Pierwszy: v dwa, key underscore id jeden, name underscore id underscore, czyli domyślny indeks na underscore id o nazwie „_id_”. Drugi: v dwa, key name minus jeden, name „name_-1”. Widzisz tu konwencję nazewnictwa: domyślna nazwa indeksu to nazwa pola, podkreślnik i kierunek. Dla indeksu złożonego kolejne pary są sklejane podkreślnikami, na przykład uzytkownik_id_1_data_-1. Pole v to wersja formatu indeksu.

Diagram pokazuje indeks score jeden jako niebieski pasek od min do max z uporządkowanymi wartościami osiemnaście, trzydzieści, czterdzieści pięć i siedemdziesiąt pięć, z których każda wskazuje dokument w kolekcji, na przykład dokument ze score trzydzieści.

Slajd mówi: indeksy pojedynczego pola przechowują informacje z pojedynczego pola w kolekcji. Domyślnie każda kolekcja ma indeks na polu underscore id. Możemy dodać kolejne indeksy, żeby przyspieszyć ważne zapytania i operacje. Indeks jednopolowy można utworzyć na dowolnym polu dokumentu, w tym na polach najwyższego poziomu i na polach w osadzonych dokumentach. Przykład tego drugiego: db, kropka, students, kropka, createIndex, a w nawiasie, w cudzysłowie, location kropka state, dwukropek, jeden. To notacja kropkowa, która sięga do pola state wewnątrz obiektu location. Pamiętaj o cudzysłowie, bo klucz z kropką musi być napisem.

Podczas tworzenia indeksu określamy dwie rzeczy: pole, na którym ma powstać indeks, oraz kolejność sortowania wartości, rosnącą jeden albo malejącą minus jeden. Slajd dodaje w nawiasie, że sortowanie malejące jest mniej wydajne. Tu muszę cię uczciwie poprawić. Według dokumentacji MongoDB przy indeksie jednopolowym kierunek nie ma znaczenia dla wydajności sortowania, bo MongoDB potrafi przechodzić indeks w obu kierunkach. Indeks name jeden obsłuży równie dobrze sortowanie po name rosnąco, jak i malejąco. Kierunek zaczyna mieć znaczenie dopiero przy indeksach złożonych, gdy sortujemy po kilku polach w różnych kierunkach. Jeśli test zapyta wprost o zdanie ze slajdu, pamiętaj, co mówił prowadzący, ale wiedz, jak jest naprawdę.

### Indeksy złożone

Indeks złożony tworzymy, podając kilka pól w jednym dokumencie klucza: db, kropka, students, kropka, createIndex, a w nawiasie name jeden, przecinek, gpa minus jeden. Slajd mówi: indeksy złożone zbierają i sortują dane z dwóch lub więcej pól każdego dokumentu. Dane są grupowane najpierw według pierwszego pola indeksu, a potem według każdego kolejnego.

Diagram pokazuje indeks userid jeden, score minus jeden. Na pasku od min do max stoją pary: aa1 z czterdzieści pięć, potem ca2 z siedemdziesiąt pięć, ca2 z pięćdziesiąt pięć, ca2 z trzydzieści, potem nb1 z trzydzieści i xyz z dziewięćdziesiąt. Zauważ: userid jest posortowane rosnąco, a w obrębie tego samego userid, czyli ca2, wyniki idą malejąco: siedemdziesiąt pięć, pięćdziesiąt pięć, trzydzieści. Tak działa kolejność pól i kierunków w indeksie złożonym. Analogia to książka telefoniczna: posortowana po nazwisku, a w obrębie nazwiska po imieniu.

Z tego wynika najważniejsza reguła: kolejność pól w indeksie złożonym ma znaczenie. Indeks userid, score obsłuży zapytania po samym userid oraz po userid razem ze score, bo userid jest jego prefiksem. Nie obsłuży wydajnie zapytania wyłącznie po score, tak jak w książce telefonicznej nie znajdziesz szybko wszystkich osób o imieniu Anna. Ta reguła nazywa się regułą prefiksu. W indeksie złożonym kierunki też mają znaczenie: indeks userid jeden, score minus jeden obsłuży sortowanie userid rosnąco i score malejąco oraz sortowanie dokładnie odwrotne, ale nie obsłuży sortowania obu pól rosnąco.

### Indeksy multikey

Indeks multikey tworzymy tą samą składnią co zwykły: db, kropka, nazwa kolekcji, kropka, createIndex, a w nawiasie pole tablicowe, dwukropek, kolejność sortowania. Slajd mówi: indeksy multikey zbierają i sortują dane z pól zawierających tablice. Poprawiają wydajność zapytań na polach tablicowych. Nie trzeba jawnie określać typu multikey. Kiedy tworzysz indeks na polu, które zawiera tablicę, MongoDB automatycznie ustawia go jako indeks multikey. To częste pytanie: nie ma żadnej opcji multikey true ani specjalnego słowa w kluczu.

Diagram pokazuje indeks na polu addr kropka zip. Dokument ma userid xyz i pole addr, które jest tablicą dwóch obiektów, z kodami pocztowymi 10036 i 94301. Indeks zawiera osobny wpis dla każdego elementu tablicy, więc na pasku stoją wartości 10036, 78610 i 94301, przy czym dwie z nich wskazują ten sam dokument. To sedno multikey: jeden dokument może mieć w indeksie wiele wpisów, po jednym na każdy element tablicy. Dzięki temu zapytanie o kod 94301 szybko znajdzie dokument, choć kod ten jest tylko jednym z elementów tablicy. Ograniczenie warte zapamiętania: w indeksie złożonym co najwyżej jedno pole może być tablicą w danym dokumencie.

### Indeks wektorowy

Ostatnie trzy slajdy dotyczą indeksu wektorowego. Indeks wektorowy w MongoDB, w ramach usług wyszukiwania Atlas, umożliwia wyszukiwanie podobieństwa semantycznego między dokumentami na podstawie ich reprezentacji wektorowej, czyli embeddingów, a nie tylko dopasowania słów kluczowych. Embedding to tablica liczb, którą model językowy wylicza z tekstu tak, że teksty o podobnym znaczeniu dostają wektory leżące blisko siebie w przestrzeni. Dokładna nazwa usługi to MongoDB Atlas Vector Search; slajd nazywa ją ogólnie Atlas Search.

Dlaczego indeks wektorowy jest potrzebny? Slajd podaje trzy powody. Po pierwsze, MongoDB domyślnie nie potrafi szybko porównywać dużych wektorów, na przykład o dwóch tysiącach czterdziestu ośmiu wymiarach, w milionach dokumentów. Po drugie, indeks wektorowy używa algorytmów ANN, czyli Approximate Nearest Neighbor, przybliżonego najbliższego sąsiada, na przykład HNSW, czyli Hierarchical Navigable Small World, żeby znaleźć wektory najbliższe zapytaniu w ułamku sekundy. Słowo „approximate” jest ważne: wynik jest przybliżony, czyli bardzo dobry, ale nie zawsze idealnie najbliższy, w zamian za ogromny zysk szybkości. Po trzecie, bez indeksu trzeba by robić pełne skanowanie kolekcji i liczyć podobieństwo dla każdego dokumentu, co byłoby ekstremalnie wolne.

Kod tworzenia indeksu wygląda tak. Najpierw use, w nawiasie i cudzysłowie sample_mflix, co przełącza na przykładową bazę filmową. Potem db, kropka, embedded_movies, kropka, dropSearchIndex, w nawiasie vector_index, co usuwa ewentualny stary indeks o tej nazwie. Następnie db, kropka, embedded_movies, kropka, createSearchIndex z trzema argumentami: nazwą indeksu vector_index, typem w cudzysłowie vectorSearch i definicją. Definicja to obiekt z tablicą fields, a w niej jeden obiekt: type równe vector, path równe plot_embedding_voyage_3_large, czyli pole z embeddingiem, numDimensions dwa tysiące czterdzieści osiem, similarity cosine, a w komentarzu możliwe wartości cosine, euclidean i dotProduct, oraz quantization równe scalar. Na koniec db, kropka, embedded_movies, kropka, getSearchIndexes, z pustym nawiasem, co wyświetla indeksy wyszukiwania. Wynik pokazuje indeks o nazwie vector_index, typie vectorSearch, ze statusem READY i polem queryable równym true, czyli gotowy do zapytań, oraz z definicją, którą przed chwilą podaliśmy.

Zwróć uwagę, że indeksów wektorowych nie tworzy się metodą createIndex, tylko createSearchIndex, nie wyświetla getIndexes, tylko getSearchIndexes, i nie usuwa dropIndex, tylko dropSearchIndex. To osobna rodzina indeksów wyszukiwania. Indeks budowany jest asynchronicznie, dlatego ma status, który dopiero po chwili zmienia się na READY.

Kilka słów o parametrach. NumDimensions to rozmiar wektora i musi się zgadzać z modelem, który wygenerował embeddingi. Similarity to metryka podobieństwa. Cosine, czyli podobieństwo kosinusowe, mierzy kąt między wektorami i jest najczęstszym wyborem dla tekstu. Euclidean to odległość euklidesowa, czyli zwykła odległość w przestrzeni. DotProduct to iloczyn skalarny, wydajny dla wektorów znormalizowanych. Quantization scalar oznacza kwantyzację skalarną: liczby zmiennoprzecinkowe są zapisywane w indeksie w mniejszej precyzji, co zmniejsza zużycie pamięci kosztem niewielkiej utraty dokładności.

Drugi slajd mówi, do czego służy indeks wektorowy. Pierwsze zastosowanie to Semantic Search, czyli wyszukiwanie semantyczne, na przykład filmów o podobnej fabule, nawet jeśli ich opisy nie używają tych samych słów. Drugie to rekomendacje: znajdź dokumenty podobne do danego, czyli „podobne produkty”. Trzecie to chatboty i systemy pytań i odpowiedzi: wyszukiwanie kontekstu w bazie wiedzy na podstawie embeddingów. To trzecie zastosowanie znasz pod nazwą RAG, czyli generowanie wspomagane wyszukiwaniem.

Jak to działa? Tworzymy indeks typu vectorSearch na polu z embeddingiem, na przykład plot_embedding_voyage_3_large. Voyage AI to model, którego używamy do wyliczania semantycznej reprezentacji tekstu. Na zrzucie jest lista rozwijana EMBEDDING MODEL z wybraną opcją Voyage AI i innymi opcjami OpenAI oraz Open-source. Podajemy numDimensions, czyli rozmiar wektora, na przykład dwa tysiące czterdzieści osiem, i similarity, czyli metrykę: cosine, euclidean albo dotProduct. MongoDB buduje strukturę danych zoptymalizowaną do szybkiego wyszukiwania najbliższych sąsiadów. Efekt końcowy: po utworzeniu indeksu można używać etapu dolar vectorSearch w agregacji, żeby w milisekundach znaleźć dokumenty najbardziej podobne do wektora zapytania.

Trzeci slajd pokazuje takie zapytanie. Use sample_mflix, a potem db, kropka, embedded_movies, kropka, aggregate z dwoma etapami. Pierwszy to dolar vectorSearch z polami: index równe vector_index, path równe plot_embedding_voyage_3_large, queryVector równe Array, w nawiasie dwa tysiące czterdzieści osiem, kropka, fill, w nawiasie zero przecinek pięć, czyli sztuczny wektor testowy wypełniony samymi wartościami jedna druga, numCandidates sto pięćdziesiąt, limit dziesięć i quantization scalar. Drugi etap to dolar project z underscore id zero, plot jeden, title jeden i polem score równym klamrom z dolar meta, dwukropek, w cudzysłowie vectorSearchScore. Dolar meta z vectorSearchScore dokleja do wyniku liczbę, która mówi, jak bardzo dokument jest podobny do zapytania.

Parametry dolar vectorSearch warto rozumieć. Index to nazwa indeksu wektorowego. Path to pole z embeddingiem. QueryVector to wektor zapytania, który musi mieć tyle samo wymiarów co indeks. NumCandidates to liczba kandydatów, których algorytm ANN rozważa w trakcie przeszukiwania, a limit to liczba dokumentów zwracanych na końcu. NumCandidates musi być co najmniej równe limit, a dokumentacja zaleca, żeby było kilkanaście razy większe, bo im więcej kandydatów, tym dokładniejszy wynik, ale wolniejsze zapytanie. Tu sto pięćdziesiąt kandydatów na dziesięć wyników. Dodatkowo dolar vectorSearch musi być pierwszym etapem potoku. Slajd umieszcza też w zapytaniu parametr quantization; w dokumentacji MongoDB kwantyzację ustawia się w definicji indeksu, a nie w zapytaniu, więc zapamiętaj ją przede wszystkim jako opcję indeksu.

Wynik to lista filmów z tytułem, fabułą i wynikiem podobieństwa: Iron Sky z wynikiem około zero przecinek pięćset trzydzieści, Rollerball z około zero przecinek pięćset dwadzieścia osiem, Tarif Novogodniy z około zero przecinek pięćset dwadzieścia osiem i After Life z około zero przecinek pięćset dwadzieścia osiem. Wyniki są posortowane malejąco według podobieństwa. Ponieważ wektor zapytania był sztuczny, same tytuły nie mają tu sensu, liczy się mechanizm.

Na dole slajdu widać fragment dokumentu z polem plot_embedding_voyage_3_large zapisanym jako dolar binary, z danymi w base64 i subType 09. Slajd wyjaśnia: plot_embedding_voyage_3_large to zakodowany wektor liczb, czyli embedding, który opisuje znaczenie fabuły filmu w przestrzeni semantycznej. Nie jest to obraz ani wideo, tylko dane numeryczne. Subtyp 09 to w BSON specjalny binarny typ wektora, który zapisuje liczby zwięźle, zamiast jako zwykłej tablicy liczb zmiennoprzecinkowych.

Do zapamiętania na test: indeksy przyspieszają wyszukiwanie, sortowanie i agregacje, ale spowalniają zapisy, bo każdy insert i update musi zaktualizować wszystkie indeksy; tworzy się je metodą createIndex, a wyświetla getIndexes. Indeks na underscore id powstaje automatycznie. Unikalność daje opcja unique true, wyszukiwanie pełnotekstowe wartość text, zapytania geograficzne wartość 2dsphere, indeks częściowy opcja partialFilterExpression, a TTL opcja expireAfterSeconds, na przykład trzy tysiące sześćset, czyli godzina. TTL działa na jednym polu z datą i nie działa na kolekcjach capped. Indeks jednopolowy można założyć także na polu osadzonym przez notację kropkową w cudzysłowie, a domyślna nazwa indeksu to pole, podkreślnik i kierunek, na przykład name_-1. W indeksie złożonym dane są grupowane po pierwszym polu, potem po kolejnych, więc kolejność pól ma znaczenie. Indeks na polu tablicowym automatycznie staje się multikey i ma wpis dla każdego elementu tablicy. Indeks wektorowy tworzy się metodą createSearchIndex z typem vectorSearch, polami path, numDimensions i similarity o wartościach cosine, euclidean albo dotProduct, a wyszukuje się etapem dolar vectorSearch z index, path, queryVector, numCandidates i limit, wynik podobieństwa pobierając przez dolar meta vectorSearchScore. Algorytmy ANN, takie jak HNSW, dają wynik przybliżony, ale bardzo szybki.


# 5. MongoDB — replikacja, sharding i kolekcje Time Series

W tym dziale zostawiamy na chwilę pojedyncze zapytania i patrzymy na MongoDB z lotu ptaka, jak na system, który działa na wielu serwerach naraz. Najpierw omówimy replikację, czyli trzymanie kilku kopii tych samych danych. Poznasz zestaw replik, po angielsku replica set, role primary i secondary, arbitra, mechanizm heartbeat i automatyczne przełączanie awaryjne, czyli failover. Potem przejdziemy do shardingu, po polsku fragmentowania, czyli dzielenia danych na kawałki leżące na różnych maszynach. Omówimy skalowanie pionowe i poziome, klucz shardujący, routery mongos, serwery konfiguracyjne oraz to, jak wygląda klaster produkcyjny, a jak testowy. Na koniec zajmiemy się kolekcjami szeregów czasowych, czyli Time Series Collections: jak je tworzyć, co znaczą parametry timeField, metaField i granularity, jak je odpytywać agregacjami, jak je wylistować, jak zbudować na nich widok zmaterializowany i jak włączyć automatyczne usuwanie starych danych. Zakończymy przykładem z internetu rzeczy, w którym liczymy zużycie energii przez klimatyzator.

Jedna rzecz na start, bo na teście bardzo łatwo ją pomylić. Replikacja i sharding to dwie różne odpowiedzi na dwa różne problemy. Replikacja kopiuje te same dane na kilka serwerów, żeby system przeżył awarię. To jest wysoka dostępność i bezpieczeństwo danych. Sharding dzieli dane na części i rozkłada różne części na różne serwery, żeby system udźwignął więcej danych i więcej ruchu. To jest skalowalność. W replikacji każdy węzeł ma wszystko. W shardingu każdy shard ma tylko kawałek. W prawdziwych wdrożeniach łączy się jedno z drugim: każdy shard jest osobnym zestawem replik.

## 5.1. Replikacja w MongoDB — cechy ogólne

Zacznijmy od definicji ze slajdu sto osiemdziesiąt cztery. Replikacja w MongoDB to mechanizm, który pozwala duplikować dane między różnymi serwerami. Daje to odporność na awarie i dostępność danych w sytuacjach kryzysowych, na przykład gdy padnie dysk, zasilanie albo cała serwerownia.

Prowadzący wymienia siedem głównych cech replikacji. Przejdźmy przez nie po kolei.

Pierwsza cecha to sam replica set. MongoDB realizuje replikację przez tak zwany zestaw replik, czyli grupę instancji MongoDB, w której jeden serwer działa jako primary, a pozostałe jako secondary. Primary odpowiada za operacje zapisu. Secondary replikują, czyli kopiują dane z primary. Zapamiętaj to rozróżnienie: zapisy zawsze trafiają do primary. Nie da się zapisać czegoś bezpośrednio na secondary.

Druga cecha to automatyczne przełączanie, po angielsku failover. Gdy primary ulegnie awarii, jeden z secondary zostaje automatycznie wybrany na nowego primary. Słowo „wybrany” jest tu ważne, bo odbywają się prawdziwe wybory, czyli głosowanie węzłów. Dzięki temu baza pozostaje dostępna bez ręcznej interwencji administratora.

Trzecia cecha to odczyty z secondary. Domyślnie wszystkie odczyty idą do primary, ale MongoDB pozwala tak skonfigurować klienta, żeby czytał także z secondary. Może to zwiększyć wydajność odczytów, bo rozkładamy ruch na więcej maszyn, ale ma swoją cenę, którą slajd nazywa opóźnieniem, po angielsku read lag, a w dokumentacji częściej replication lag. Secondary kopiuje zmiany z pewnym poślizgiem, więc może zwrócić dane odrobinę nieaktualne. Ustawienie, skąd czytamy, nazywa się read preference. Dla porządku podam tryby, bo warto je znać: primary, czyli tylko z węzła głównego, to wartość domyślna; primaryPreferred, czyli z primary, a gdy go nie ma, z secondary; secondary, czyli tylko z węzłów wtórnych; secondaryPreferred, czyli najchętniej z secondary, a awaryjnie z primary; oraz nearest, czyli z węzła o najmniejszym opóźnieniu sieciowym, bez względu na rolę.

Czwarta cecha to wysoka dostępność. Dzięki replikacji dane są dostępne cały czas, także podczas aktualizacji oprogramowania albo awarii jednego z serwerów. W praktyce administrator aktualizuje węzły po kolei, tak zwanym rolling upgrade, i baza przez cały czas obsługuje ruch.

Piąta cecha to minimalizacja utraty danych. Slajd mówi, że replikacja pozwala zapisywać dane na wielu serwerach jednocześnie. Tu dopowiem, jak to wygląda technicznie, bo słowo „jednocześnie” jest uproszczeniem. Zapis trafia najpierw tylko do primary. Primary zapisuje każdą zmianę w specjalnym dzienniku operacji, który nazywa się oplog, od operation log. To jest kolekcja o stałym rozmiarze, czyli capped collection, w bazie local, o nazwie oplog kropka rs. Węzły secondary pobierają wpisy z oplogu i odtwarzają je u siebie. Ta replikacja jest asynchroniczna. Żeby mieć pewność, że zapis jest już na kilku serwerach, klient ustawia tak zwany write concern. Write concern w jeden oznacza, że wystarczy potwierdzenie samego primary. Write concern w majority oznacza, że zapis zostanie potwierdzony dopiero wtedy, gdy trafi na większość węzłów głosujących. Od wersji piątej MongoDB domyślnym write concernem jest majority. Dopiero przy takim ustawieniu replikacja naprawdę chroni przed utratą danych po awarii primary.

Szósta cecha to ochrona przed awariami. Gdy jeden serwer padnie, pozostałe nadal mają kopie danych i działają jak kopie zapasowe. Uwaga na pułapkę: replikacja nie zastępuje kopii zapasowych w sensie backupu. Jeśli ktoś przez pomyłkę usunie kolekcję, to ta operacja też się zreplikuje i zniknie ze wszystkich węzłów. Replikacja chroni przed awarią sprzętu, a nie przed błędem człowieka.

Siódma cecha to konfiguracja i elastyczność. Można ustawić liczbę węzłów secondary, strategię synchronizacji oraz polityki odczytu i zapisu, czyli właśnie read preference i write concern. Można też nadawać węzłom priorytety, ukrywać je przed klientami, czyli tworzyć węzły hidden, albo celowo je opóźniać, czyli tworzyć węzły delayed, które trzymają stan sprzed na przykład godziny i pozwalają wrócić do danych sprzed pomyłki.

Slajd kończy się zdaniem, że replikacja jest kluczowym elementem przy budowaniu skalowalnych i odpornych na awarie aplikacji.

Do zapamiętania na test: replica set to grupa instancji MongoDB, w której jest dokładnie jeden primary i jeden lub więcej secondary. Zapisy przyjmuje wyłącznie primary, secondary kopiują dane z primary przez oplog. Przy awarii primary secondary wybierają nowego primary, to jest failover. Odczyty mogą iść z secondary po zmianie read preference, ale wtedy dane mogą być lekko nieaktualne, co slajd nazywa read lag. Domyślny read preference to primary. Replikacja daje wysoką dostępność i redundancję, a nie skalowanie zapisów.

## 5.2. Zestaw replik: redundancja, primary i secondary

Slajdy sto osiemdziesiąt pięć i sto osiemdziesiąt sześć definiują zestaw replik bardziej formalnie. Zestaw replik w MongoDB to grupa procesów mongod, które przechowują ten sam zestaw danych. Zwróć uwagę na nazwę procesu: mongod, przez „d” na końcu, od daemon. To jest właściwy serwer bazy danych. Mongo bez „d”, a dziś mongosh, to klient, czyli powłoka. A mongos z „s” na końcu to router w klastrze shardowanym, o którym powiemy za chwilę. Te trzy nazwy są typową pułapką testową.

Replikacja zapewnia redundancję danych, czyli nadmiarowość, oraz wysoką dostępność usług bazodanowych. Tworzy wiele kopii danych na różnych serwerach, dzięki czemu system pozostaje dostępny mimo awarii pojedynczego węzła. Gdy serwer główny, czyli primary, staje się niedostępny, jeden z serwerów zapasowych, czyli secondary, może zostać automatycznie wybrany na nowy serwer główny. Przerwa w działaniu aplikacji jest wtedy minimalna.

Slajd sto osiemdziesiąt sześć dodaje ważny szczegół o składzie zestawu. Zestaw replik składa się z kilku węzłów przechowujących dane oraz opcjonalnie jednego węzła arbitra. Spośród węzłów przechowujących dane dokładnie jeden pełni rolę węzła głównego, primary, który przyjmuje operacje zapisu. Pozostałe są węzłami wtórnymi, secondary, i utrzymują kopie danych, replikując zmiany z węzła głównego.

Na diagramie u góry jest aplikacja kliencka ze sterownikiem, po angielsku Client Application, Driver. Od niej idą w dół dwie strzałki, zapisy i odczyty, i obie trafiają do primary. Od primary wychodzą dwie strzałki opisane Replication do dwóch węzłów secondary. Ten obrazek pokazuje konfigurację domyślną: klient i pisze, i czyta z primary, a secondary tylko się synchronizują.

Dopowiem kilka faktów, które pomagają zrozumieć tę architekturę. Zestaw replik może mieć do pięćdziesięciu członków, ale głosujących może być najwyżej siedmiu. Typowy produkcyjny zestaw ma trzy węzły z danymi: jeden primary i dwa secondary. Liczbę głosujących dobiera się nieparzystą, bo do wybrania primary potrzebna jest większość, a przy parzystej liczbie łatwiej o remis. Zestaw tworzy się w powłoce poleceniem rs kropka initiate, stan sprawdza się poleceniem rs kropka status, a węzeł dodaje poleceniem rs kropka add. Aplikacja łączy się z zestawem, podając w adresie połączenia nazwę zestawu, na przykład parametr replicaSet równa się rs zero. Sterownik sam ustala, który węzeł jest w danej chwili primary, i po failoverze sam przełącza zapisy na nowego.

Do zapamiętania na test: replica set to grupa procesów mongod przechowujących ten sam zestaw danych. Składa się z węzłów z danymi oraz opcjonalnie jednego arbitra. Wśród węzłów z danymi dokładnie jeden jest primary i tylko on przyjmuje zapisy. Secondary replikują zmiany z primary. Mongod to serwer, mongos to router shardingu, mongosh to powłoka kliencka.

## 5.3. Arbiter i heartbeat

Slajd sto osiemdziesiąt siedem pokazuje dwa diagramy. Na górnym jest primary i dwa secondary. Od primary idą strzałki replikacji do obu secondary. Dodatkowo między wszystkimi węzłami są dwukierunkowe strzałki podpisane heartbeat, czyli bicie serca. Na dolnym diagramie jest primary, jeden secondary i pomarańczowy arbiter z dopiskiem vote only, czyli tylko głosuje. Replikacja biegnie tylko od primary do secondary, a do arbitra nie biegnie wcale. Heartbeat łączy wszystkie trzy węzły.

Najpierw heartbeat. Członkowie zestawu replik co dwie sekundy wysyłają sobie nawzajem krótkie sygnały, że żyją. Jeżeli przez określony czas któryś węzeł nie dostanie odpowiedzi od primary, uznaje, że primary jest niedostępny, i może rozpocząć wybory. Domyślny czas, po którym węzeł ogłasza wybory, to dziesięć sekund, ustawienie nazywa się electionTimeoutMillis. Heartbeat to więc mechanizm wykrywania awarii, a replikacja to przesyłanie danych. Na diagramie to są dwa różne rodzaje strzałek i warto je odróżniać.

Teraz arbiter. Slajd mówi, że w pewnych okolicznościach, na przykład gdy masz węzeł podstawowy i dodatkowy, ale ograniczenia kosztowe nie pozwalają dodać kolejnego, możesz dodać do zestawu arbitra. Arbiter uczestniczy w wyborach, ale nie posiada kopii zbioru danych i nie może zostać wybrany. Doprecyzujmy: arbiter nie może zostać wybrany na primary. Nigdy nie będzie przyjmował zapisów ani serwował odczytów, bo nie ma danych. Na slajdzie zdanie kończy się zbędnym nawiasem zamykającym, to zwykła literówka.

Po co komuś węzeł, który nic nie przechowuje? Wyobraź sobie zestaw tylko z dwoma węzłami z danymi. Jeśli padnie primary, zostaje jeden secondary, który ma jeden głos z dwóch. To nie jest większość, więc nie może sam siebie wybrać. Cały zestaw przestaje przyjmować zapisy. Dodanie trzeciego pełnego węzła kosztuje, bo potrzebuje dysku na całą kopię danych. Arbiter jest tani: wymaga mało zasobów, bo nie trzyma danych, a daje trzeci głos. Teraz po awarii primary zostają dwa głosy z trzech, czyli większość, i secondary może zostać nowym primary. Arbiter jest więc rozjemcą, który przełamuje remisy. Dokumentacja zaleca najwyżej jednego arbitra w zestawie, co zgadza się ze słowami „opcjonalnie jednego” ze slajdu sto osiemdziesiąt sześć. W powłoce dodaje się go poleceniem rs kropka addArb. Wadą arbitra jest to, że nie zwiększa liczby kopii danych. Gdy w konfiguracji primary, secondary i arbiter padnie jeden węzeł z danymi, zostaje tylko jedna kopia, dlatego dokumentacja zaleca, gdy to możliwe, trzy pełne węzły zamiast arbitra.

Do zapamiętania na test: arbiter głosuje w wyborach, nie przechowuje danych i nigdy nie zostaje primary. Dodaje się go, gdy z powodów kosztowych mamy tylko dwa węzły z danymi i potrzebujemy nieparzystej liczby głosów. Do arbitra nie biegnie replikacja, biegnie tylko heartbeat. Heartbeat to wzajemne sygnały życia między członkami zestawu, służące do wykrywania awarii.

## 5.4. Automatyczne przełączanie awaryjne

Slajd sto osiemdziesiąt osiem pokazuje failover w trzech krokach. U góry jest primary przekreślony czerwonym krzyżykiem, czyli uległ awarii. Poniżej, w czerwonej przerywanej ramce, napis Election for New Primary, czyli wybory nowego primary. W ramce dwa secondary połączone strzałką heartbeat. Jeszcze niżej napis New Primary Elected, czyli nowy primary wybrany. Jeden z dawnych secondary jest teraz primary i replikuje dane do pozostałego secondary, a heartbeat działa dalej.

Slajd podaje też liczbę wartą zapamiętania: mediana czasu, zanim klaster wybierze nowego primary, zwykle nie powinna przekraczać dwunastu sekund, przy domyślnych ustawieniach konfiguracji zestawu replik. Mediana, a nie maksimum: połowa przełączeń trwa krócej, a pojedyncze mogą trwać dłużej. Na te dwanaście sekund składa się czas wykrycia awarii, czyli domyślne dziesięć sekund bez odpowiedzi, oraz czas samego głosowania.

Kilka rzeczy dzieje się w tle. Wybory wygrywa węzeł, który zbierze głosy większości członków głosujących. Kandydat musi mieć dane możliwie aktualne. Przy wyborze liczy się też priorytet węzła: węzeł z priorytetem zero nigdy nie zostanie primary. W trakcie wyborów zestaw nie przyjmuje zapisów, ale odczyty mogą dalej iść z secondary, jeśli tak ustawiono read preference. Sterowniki MongoDB mają domyślnie włączone ponawianie zapisów, czyli retryable writes, więc pojedynczy zapis przerwany przez failover sterownik może automatycznie powtórzyć już do nowego primary.

Co się stanie, gdy stary primary wróci do życia? Dołączy do zestawu jako secondary. Jeśli zdążył przyjąć zapisy, które nie trafiły na żaden inny węzeł, MongoDB je wycofa. Ta operacja nazywa się rollback. Właśnie dlatego write concern majority jest tak ważny: zapis potwierdzony przez większość nie zostanie wycofany.

Do zapamiętania na test: gdy primary pada, pozostałe węzły wykrywają to przez brak heartbeatu i przeprowadzają wybory. Nowym primary zostaje secondary, który zbierze większość głosów. Mediana czasu wyboru nowego primary przy domyślnych ustawieniach nie powinna przekraczać dwunastu sekund. Cały proces jest automatyczny i nie wymaga administratora.

## 5.5. Sharding, czyli fragmentowanie, i dwa rodzaje skalowania

Slajd sto osiemdziesiąt dziewięć definiuje sharding. Sharding to metoda dystrybucji danych na wielu komputerach. MongoDB używa shardingu do obsługi wdrożeń z bardzo dużymi zbiorami danych i operacjami o dużej przepustowości. Polska nazwa używana na wykładzie to fragmentowanie, a pojedynczy kawałek danych z serwerem, który go trzyma, to shard, po polsku fragment.

Skąd w ogóle potrzeba? Systemy z dużymi zbiorami danych albo aplikacje o dużej przepustowości mogą przerosnąć możliwości pojedynczego serwera. Slajd daje dwa przykłady. Pierwszy: duża liczba zapytań może wyczerpać moc procesora serwera. Drugi: gdy zestaw roboczy, czyli po angielsku working set, jest większy niż pamięć RAM, obciążenie przenosi się na dysk, a dysk jest dużo wolniejszy. Working set to te dane i indeksy, których aplikacja używa najczęściej. Dopóki mieszczą się w pamięci, baza działa szybko. Gdy przestają, każde zapytanie zaczyna czytać z dysku i wydajność spada.

Slajd sto dziewięćdziesiąt mówi, że są dwie metody rozwiązania problemu rozbudowy systemu.

Skalowanie pionowe, po angielsku vertical scaling albo scale up, polega na zwiększaniu mocy pojedynczego serwera: mocniejszy procesor, więcej pamięci RAM, więcej miejsca na dysku. Slajd zauważa, że istnieje praktyczne maksimum skalowania w pionie. Nie da się kupić dowolnie mocnej maszyny, a najmocniejsze są nieproporcjonalnie drogie. Na slajdzie zdanie zaczyna się od „w rezultacie”, choć brakuje przesłanki. W oryginale dokumentacji MongoDB chodzi o to, że ograniczenia dostępnej technologii mogą nie pozwolić dalej rozbudowywać jednej maszyny, a dostawcy chmury mają sztywne górne limity konfiguracji sprzętu. Stąd praktyczne maksimum.

Skalowanie poziome, po angielsku horizontal scaling albo scale out, polega na podziale danych i obciążenia na wiele serwerów oraz na dokładaniu kolejnych serwerów, gdy rośnie zapotrzebowanie. Pojedyncza maszyna może nie być szczególnie szybka ani pojemna, ale każda obsługuje tylko część całego obciążenia, więc razem mogą dać lepszą wydajność niż jeden szybki serwer o dużej pojemności. Zwiększenie wydajności wymaga tylko dodania serwerów, co może wyjść taniej niż wysokiej klasy sprzęt dla jednej maszyny. Kompromisem, czyli ceną, jest większa złożoność infrastruktury i jej utrzymania.

Analogia: skalowanie pionowe to kupowanie coraz większej ciężarówki. Skalowanie poziome to kupowanie kolejnych zwykłych ciężarówek i dzielenie ładunku. W pewnym momencie większej ciężarówki po prostu nie ma, a kolejną zwykłą zawsze można dokupić, tylko trzeba nimi zarządzać.

Do zapamiętania na test: sharding to dystrybucja danych na wiele maszyn, czyli skalowanie poziome. Powody: procesor wyczerpany przez liczbę zapytań oraz working set większy niż RAM, co obciąża wejście i wyjście dysku. Skalowanie pionowe to mocniejsza jedna maszyna i ma praktyczne maksimum. Skalowanie poziome to więcej maszyn, potencjalnie taniej, kosztem większej złożoności infrastruktury i utrzymania.

## 5.6. Cechy shardingu w MongoDB i klucz shardujący

Slajd sto dziewięćdziesiąt jeden mówi, że sharding w MongoDB to metoda skalowania horyzontalnego, czyli poziomego, która dzieli dane na mniejsze fragmenty, shardy, przechowywane na różnych serwerach. Dzięki temu baza obsługuje większe zbiory danych i większe obciążenia. Prowadzący wymienia osiem kluczowych cech.

Pierwsza: podział danych na fragmenty. Dane dzieli się na podstawie klucza shardującego, co pozwala równomiernie rozłożyć obciążenie i dane na wiele serwerów.

Druga: klucz shardujący, po angielsku shard key. To pole albo zestaw pól dokumentu, na podstawie których MongoDB decyduje, na którym shardzie wyląduje dokument. Wybór klucza jest kluczowy dla wydajności i równomiernego rozłożenia danych. Dopowiem, czym kierować się przy wyborze. Dobry klucz ma dużą kardynalność, czyli wiele różnych wartości. Kluczem o małej kardynalności byłaby na przykład płeć albo kraj, bo wtedy wszystkie dokumenty z jedną wartością muszą trafić w jedno miejsce. Dobry klucz ma też niską częstość powtarzania się pojedynczej wartości i nie rośnie monotonicznie. Klucz monotoniczny, na przykład data utworzenia albo rosnący licznik, powoduje, że wszystkie nowe dokumenty trafiają na ten sam ostatni shard, który staje się gorącym punktem, po angielsku hot spot. Na to pomaga sharding haszowany: MongoDB liczy skrót, czyli hash, z wartości klucza i dzieli dane według hasha, więc kolejne wartości rozsypują się po różnych shardach. Druga strategia, ranged sharding, dzieli dane według zakresów wartości klucza i dobrze obsługuje zapytania o zakres, ale grozi gorącymi punktami przy kluczach rosnących. Kolekcję shardujemy poleceniem sh kropka shardCollection, podając w cudzysłowie nazwę bazy kropka nazwa kolekcji, a jako drugi argument dokument z kluczem, na przykład w klamrach pole userId, dwukropek, jeden, albo w klamrach pole userId, dwukropek, i napis hashed w cudzysłowie. Klucz shardujący musi być objęty indeksem. W starszych wersjach klucza nie dało się zmienić. Od wersji 5.0 można zmienić klucz kolekcji operacją resharding, ale to kosztowna operacja, więc klucz nadal wybiera się starannie od początku.

Trzecia: routery, czyli mongos. Aplikacja nie łączy się bezpośrednio z shardami. Łączy się z routerem mongos, który przyjmuje zapytania i kieruje je do odpowiednich shardów. Routery zarządzają routingiem i dostarczają dane w sposób przezroczysty: dla aplikacji klaster wygląda jak jedna baza. Jeśli zapytanie zawiera klucz shardujący, mongos wie, który shard odpytać, i wysyła je tylko tam. To zapytanie celowane, po angielsku targeted. Jeśli zapytanie klucza nie zawiera, mongos musi zapytać wszystkie shardy i połączyć wyniki. To tak zwany broadcast albo scatter-gather, czyli rozesłanie i zebranie, i jest wolniejsze.

Czwarta: balansowanie obciążenia. MongoDB automatycznie monitoruje rozkład danych i równoważy shardy, przenosząc dane, żeby żaden serwer nie był przeciążony. Robi to proces zwany balancerem. Dane w kolekcji shardowanej dzielą się na zakresy klucza nazywane chunkami. Balancer przenosi chunki z shardów przepełnionych na mniej zajęte. Od wersji 7.0 balancer patrzy na faktyczną ilość danych na shardach, a nie na liczbę chunków.

Piąta: wysoka skalowalność. Sharding pozwala skalować MongoDB poziomo, czyli dokładać serwery w miarę wzrostu danych i ruchu.

Szósta: operacje równoległe. Ponieważ dane są podzielone, zapytanie dotyczące wielu shardów może być wykonywane równolegle na każdym z nich, co poprawia ogólną wydajność.

Siódma: ochrona przed dużymi obciążeniami. Sharding izoluje operacje na różnych shardach, więc intensywne zapytania do jednej części danych nie muszą przeciążać całego systemu.

Ósma: zarządzanie fragmentacją danych. MongoDB monitoruje wielkość fragmentów, czyli chunków, i w razie potrzeby je dzieli i przenosi, żeby utrzymać równomierny rozkład. Domyślny rozmiar chunka to sto dwadzieścia osiem megabajtów od wersji 6.0, wcześniej było to sześćdziesiąt cztery megabajty.

Slajd kończy się wnioskiem, że sharding jest idealnym rozwiązaniem dla aplikacji, które przechowują i przetwarzają bardzo duże ilości danych i potrzebują wysokiej wydajności odczytu i zapisu. Zauważ różnicę wobec replikacji: replikacja przy domyślnych ustawieniach nie zwiększa przepustowości zapisu, bo zapisy i tak idą do jednego primary. Sharding zwiększa ją, bo każdy shard ma własnego primary.

Do zapamiętania na test: klucz shardujący to pole lub zestaw pól, według którego dane trafiają na shardy. Powinien mieć dużą kardynalność i nie rosnąć monotonicznie, inaczej powstaje gorący punkt. Mongos to router: przyjmuje zapytania i kieruje je do shardów. Zapytanie z kluczem shardującym jest celowane, bez klucza trafia do wszystkich shardów. Balancer automatycznie przenosi chunki, żeby wyrównać rozkład danych. Kolekcję shardujemy poleceniem sh kropka shardCollection.

## 5.7. Budowa klastra shardowanego

Slajd sto dziewięćdziesiąt dwa wymienia trzy komponenty klastra podzielonego na fragmenty, po angielsku sharded cluster. To jest jedno z najczęściej zadawanych pytań testowych, więc słuchaj uważnie.

Pierwszy komponent to shard. Każdy shard zawiera podzbiór danych kolekcji podzielonych na fragmenty. Każdy shard można wdrożyć jako zestaw replik. Doprecyzuję: od wersji 3.6 shard w produkcji musi być zestawem replik. Tak łączą się replikacja i sharding.

Drugi komponent to mongos. Działa jako router zapytań i jest interfejsem między aplikacjami klienckimi a klastrem. Mongos nie przechowuje danych na stałe. Trzyma w pamięci podręcznej metadane z serwerów konfiguracyjnych, żeby wiedzieć, który chunk leży na którym shardzie.

Trzeci komponent to serwery konfiguracyjne, po angielsku config servers. Przechowują metadane i ustawienia konfiguracyjne klastra, przede wszystkim mapę, który zakres klucza leży na którym shardzie. Od wersji 3.4 serwery konfiguracyjne muszą być wdrożone jako zestaw replik, w skrócie CSRS, od config server replica set.

Diagram na slajdzie pokazuje dwa serwery aplikacji w przerywanych ramkach. W każdym jest niebieski router mongos, z dopiskiem, że routerów może być jeden lub więcej, po angielsku 1 or more Routers. W praktyce mongos często uruchamia się na tej samej maszynie co aplikacja. Pod routerami są zielone bloki, każdy podpisany Shard, replica set, z dopiskiem 2 or more Shards, czyli dwa lub więcej shardów. Pomarańczowy blok Config Servers, replica set, jest połączony przerywanymi strzałkami i z routerami, i z shardami. Te przerywane strzałki to przepływ metadanych, a nie danych użytkownika.

Slajd sto dziewięćdziesiąt trzy, Connecting to a Sharded Cluster, czyli łączenie z klastrem, pokazuje coś bardzo ważnego. Po lewej są aplikacje i sterowniki. Wysyłają odczyty i zapisy do routera mongos. Linia przerywana oddziela aplikację od klastra, bo aplikacja widzi tylko router. Od routera idą strzałki do dwóch shardów, A i B. Na shardzie A leży część kolekcji pierwszej, czyli Collection1, oraz cała kolekcja druga, Collection2. Na shardzie B leży druga część kolekcji pierwszej. Podpis slajdu brzmi Sharded and Non-Sharded Collections, czyli kolekcje shardowane i nieshardowane.

Wniosek: w jednym klastrze mogą współistnieć kolekcje podzielone i niepodzielone. Sharding włączamy dla konkretnej kolekcji, a nie dla całej bazy hurtem. Kolekcja pierwsza jest shardowana, więc jej dokumenty są rozłożone na oba shardy. Kolekcja druga nie jest shardowana, więc w całości leży na jednym shardzie, w klasycznym ujęciu na tak zwanym shardzie głównym bazy, po angielsku primary shard. Niezależnie od tego aplikacja zawsze łączy się z mongos, a nie bezpośrednio z shardem. Połączenie bezpośrednio z shardem pominęłoby router i zobaczyłoby tylko część danych.

Do zapamiętania na test: klaster shardowany ma trzy komponenty: shardy, które trzymają dane i są zestawami replik; routery mongos, które przyjmują zapytania aplikacji i kierują je do shardów; oraz serwery konfiguracyjne, które trzymają metadane klastra i też są zestawem replik. Diagram mówi: jeden lub więcej routerów i dwa lub więcej shardów. W jednym klastrze mogą być kolekcje shardowane i nieshardowane, a nieshardowana leży w całości na jednym shardzie. Aplikacja łączy się zawsze z mongos.

## 5.8. Architektura produkcyjna i testowa

Slajd sto dziewięćdziesiąt cztery pokazuje typową architekturę klastra shardowanego w środowisku produkcyjnym. U góry jest aplikacja ze sterownikiem, po angielsku Application i Driver. Pod nią co najmniej dwa routery mongos, a po bokach trzy kropki, czyli może ich być więcej. Od routerów biegną linie do shardów: Shard 1, Shard 2, kropki i Shard N. Każdy shard to zestaw replik złożony z trzech węzłów: jednego primary i dwóch secondary. Po prawej stoi Config Server, też jako trzy węzły: primary i dwa secondary, połączony z routerami.

Dlaczego tak? Każdy element jest zdublowany, żeby nie było pojedynczego punktu awarii, po angielsku single point of failure. Kilka routerów, bo gdy padnie jeden, aplikacja korzysta z drugiego. Każdy shard ma trzy węzły, bo zestaw replik z trzech węzłów przeżyje awarię jednego i wciąż ma większość do wyboru primary. Serwery konfiguracyjne też mają trzy węzły, bo bez metadanych klaster nie wie, gdzie są dane.

Slajd sto dziewięćdziesiąt pięć pokazuje architekturę używaną wyłącznie do celów programistycznych i testowych. Aplikacja ze sterownikiem, pod nią jeden router mongos, który łączy się z jednym shardem, Shard 1, oraz z serwerem konfiguracyjnym. Na diagramie ze slajdu zarówno shard, jak i serwer konfiguracyjny nadal są narysowane jako trzy węzły, primary i dwa secondary. Różnica wobec produkcji polega więc głównie na tym, że jest jeden router zamiast kilku i jeden shard zamiast wielu. Dopowiem, że dokumentacja MongoDB dopuszcza w środowisku testowym nawet zestawy replik z jednym węzłem, bo tam nie zależy nam na odporności na awarie, tylko na tym, żeby programista mógł sprawdzić działanie aplikacji z klastrem. Taki układ ma pojedyncze punkty awarii i nie nadaje się do produkcji.

Do zapamiętania na test: w produkcji klaster ma kilka routerów mongos, wiele shardów, każdy jako zestaw replik z trzech węzłów, i serwery konfiguracyjne jako zestaw replik z trzech węzłów, żeby nie było pojedynczego punktu awarii. W środowisku programistycznym wystarcza jeden mongos, jeden shard i serwer konfiguracyjny.

## 5.9. Kolekcje szeregów czasowych — czym są i jakie mają cechy

Przechodzimy do trzeciej części działu. Slajd sto dziewięćdziesiąt sześć definiuje Time Series Collection. To specjalny typ kolekcji zaprojektowany do przechowywania i analizy danych szeregów czasowych, czyli danych zapisywanych w odniesieniu do czasu. Przykłady ze slajdu: dane z sensorów, logi systemowe, ceny akcji. Kolekcje szeregów czasowych pojawiły się w MongoDB w wersji 5.0.

Szereg czasowy to ciąg pomiarów tej samej rzeczy w kolejnych chwilach. Czujnik temperatury co sekundę wysyła odczyt. Każdy odczyt ma trzy składniki: kiedy, czyli znacznik czasu; skąd, czyli który czujnik i jakiego typu; oraz co, czyli zmierzona wartość. Te trzy składniki odpowiadają temu, co opisujemy przy tworzeniu kolekcji.

Slajd wymienia sześć głównych cech.

Kompresja danych. MongoDB optymalizuje przechowywanie szeregów czasowych przez kompresję, grupując podobne dokumenty w jeden blok danych. Dzięki temu zużycie miejsca może być znacznie mniejsze niż przy tradycyjnym przechowywaniu każdego pomiaru jako osobnego dokumentu.

Automatyczne zarządzanie czasem i danymi. MongoDB używa specjalnych indeksów na danych czasowych, dzięki czemu łatwiej wykonuje się operacje na dużych zbiorach, na przykład agregacje albo wyszukiwanie danych z określonego przedziału czasu.

Szybkie zapisy i odczyty. Optymalizacje dla szeregów czasowych zapewniają wydajność przy dużej liczbie zapisów, na przykład gdy czujniki wysyłają dane w krótkich odstępach.

Automatyczne porządkowanie danych. MongoDB tworzy „wiaderka”, po angielsku buckets, które grupują dane według okresów czasu. To jest właśnie mechanizm stojący za kompresją z pierwszego punktu. Dopowiem, jak to działa. Ty wstawiasz pojedyncze dokumenty, ale MongoDB fizycznie zapisuje je zgrupowane: pomiary z tą samą wartością metaField i z bliskiego okresu czasu trafiają do jednego wiaderka. Wewnętrznie wiaderka leżą w ukrytej kolekcji systemowej o nazwie system kropka buckets kropka nazwa twojej kolekcji. Kolekcja, którą widzisz pod swoją nazwą, działa jak widok nad tymi wiaderkami i przy odczycie rozpakowuje je z powrotem do pojedynczych dokumentów.

Tworzenie kolekcji typu Time Series. Przy tworzeniu podaje się specjalne parametry: pole z czasem, czyli timeField, oraz pole metadanych, czyli metaField. Ułatwia to filtrowanie i grupowanie danych. Ważna uwaga: zwykłej istniejącej kolekcji nie da się przerobić na kolekcję szeregów czasowych. Taką kolekcję trzeba jawnie utworzyć poleceniem createCollection z opcją timeseries, zanim wstawimy pierwszy dokument.

Indeksy. MongoDB automatycznie tworzy indeks złożony na metaField i timeField. To zachowanie obowiązuje dla kolekcji tworzonych w wersji 6.3 i nowszych, jeśli zdefiniowano metaField.

Do zapamiętania na test: Time Series Collection to specjalny typ kolekcji dla danych zapisywanych w czasie, takich jak odczyty sensorów, logi i ceny akcji. Dane są grupowane w buckets, co daje kompresję i mniejsze zużycie miejsca. Przy tworzeniu podajemy timeField i opcjonalnie metaField. MongoDB automatycznie tworzy indeks złożony na metaField i timeField. Kolekcję szeregów czasowych trzeba utworzyć jawnie, nie da się zamienić na nią zwykłej kolekcji.

## 5.10. Tworzenie kolekcji: timeField, metaField, granularity

Slajd sto dziewięćdziesiąt siedem pokazuje składnię. Przeczytam ją powoli. Piszemy db, kropka, createCollection, a w nawiasie najpierw nazwę kolekcji w cudzysłowie, sensor podkreślnik data, potem przecinek i dokument opcji. W dokumencie opcji jest pole timeseries, dwukropek, i w klamrach trzy pola. Pierwsze: timeField, dwukropek, w cudzysłowie timestamp. Drugie: metaField, dwukropek, w cudzysłowie metadata. Trzecie: granularity, dwukropek, w cudzysłowie seconds.

Uwaga na pisownię, bo test może pytać o szczegóły. Opcja nazywa się timeseries, małymi literami i razem, bez podkreślnika i bez wielkiego S. Parametry timeField i metaField piszemy w stylu camelCase, z wielkim F. Wartości parametrów timeField i metaField to nazwy pól w dokumentach, podane jako napisy.

Co znaczy każdy parametr? TimeField to nazwa pola, które przechowuje czas pomiaru. Jest obowiązkowy i wartość tego pola w każdym dokumencie musi być typu Date, czyli na przykład ISODate. Dokument bez poprawnej daty w tym polu nie zostanie wstawiony. MetaField to nazwa pola z metadanymi, czyli informacjami opisującymi źródło pomiaru, które rzadko się zmieniają, na przykład identyfikator i typ sensora. Jest opcjonalny, ale bardzo zalecany, bo to po nim MongoDB grupuje pomiary w wiaderka. Pomiary z tego samego czujnika lądują razem. W metaField można trzymać zagnieżdżony dokument, tak jak w przykładach z wykładu.

Granularity to ziarnistość. Komentarz na slajdzie mówi, że to ustawienie, jak często dane są zbierane. Precyzyjniej: granularity opisuje typowy odstęp między kolejnymi pomiarami z tego samego źródła, czyli z tą samą wartością metaField. MongoDB na tej podstawie dobiera, jak szeroki w czasie jest jeden bucket. Dopuszczalne wartości to seconds, minutes oraz hours. Wartość domyślna to seconds. Przy seconds jeden bucket obejmuje najwyżej godzinę, przy minutes najwyżej dobę, a przy hours najwyżej trzydzieści dni. Ziarnistość można później zwiększyć, na przykład z seconds na minutes, ale nie można jej zmniejszyć. Od wersji 6.3 zamiast granularity można podać własne parametry bucketMaxSpanSeconds i bucketRoundingSeconds.

W prawym górnym rogu slajdu jest mniejszy zrzut z drugim przykładem. Tworzy kolekcję weather, czyli pogoda, z tymi samymi trzema parametrami: timeField timestamp, metaField metadata i granularity seconds. Po zamknięciu klamry timeseries, ale wciąż w dokumencie opcji, stoi dodatkowo expireAfterSeconds, dwukropek, osiemdziesiąt sześć tysięcy czterysta. To jest liczba sekund w jednej dobie. Oznacza, że dokumenty starsze niż doba będą automatycznie usuwane. Zwróć uwagę na położenie tej opcji: expireAfterSeconds nie siedzi wewnątrz timeseries, tylko obok niego, na tym samym poziomie.

Dalej slajd mówi o agregacjach na szeregach czasowych. MongoDB pozwala analizować te dane potokiem agregacji. Dzięki etapom takim jak dolar group, dolar bucket czy dolar sort można łatwo badać trendy albo tworzyć raporty. Nie myl etapu agregacji dolar bucket, który dzieli dokumenty na przedziały według wartości wyrażenia, z wewnętrznymi wiaderkami, czyli buckets, w których kolekcja przechowuje dane. To ta sama angielska nazwa, ale dwie różne rzeczy.

Slajd wymienia zastosowania: monitorowanie środowiska, na przykład temperatury i wilgotności; analiza danych finansowych, na przykład cen akcji; logi systemowe; oraz monitorowanie zużycia energii, czyli efektywności energetycznej. Podsumowanie slajdu: Time Series to wszechstronne narzędzie do danych czasowych, które pozwala wydajniej zarządzać dużymi ich ilościami i szybciej je analizować.

Do zapamiętania na test: kolekcję szeregów czasowych tworzy się poleceniem db kropka createCollection z opcją timeseries. Wewnątrz timeseries są timeField, obowiązkowe pole z datą; metaField, opcjonalne pole z metadanymi źródła; oraz granularity, czyli seconds, minutes albo hours, domyślnie seconds. Opcja expireAfterSeconds stoi obok timeseries, nie w środku, a osiemdziesiąt sześć tysięcy czterysta sekund to jedna doba.

## 5.11. Przypadki użycia i właściwości danych szeregów czasowych

Slajd sto dziewięćdziesiąt osiem mówi, że kolekcje szeregów czasowych są optymalne do analizowania danych w czasie, i podaje tabelę zastosowań według branż. Opowiem ją zdaniami.

W internecie rzeczy, czyli IoT, są to dane z czujników, na przykład z urządzeń inteligentnego domu albo z logistyki flotowej, czyli śledzenia pojazdów, a także uczenie maszynowe i zbieranie danych z pomocą sztucznej inteligencji. W usługach finansowych: handel o wysokiej częstotliwości, ilościowa analiza finansowa, dane bankowe, na przykład rozliczenia transakcji w czasie, oraz dane giełdowe. W handlu detalicznym i elektronicznym: analiza transakcji, sprzedaży i cen oraz zarządzanie zapasami. W DevOps: rejestrowanie zdarzeń aplikacji, czyli logowanie, oraz monitorowanie infrastruktury i sieci.

Slajd sto dziewięćdziesiąt dziewięć opisuje, czym dane szeregów czasowych różnią się od innych danych. Jest pięć właściwości.

Pierwsza: dokumenty przychodzą w kolejności, czyli chronologicznie, więc potrzeba częstych operacji wstawiania, które dopisują nowe dokumenty na koniec. Druga: aktualizacje są rzadkie, bo każdy dokument reprezentuje pojedynczy punkt w czasie. Pomiaru z wczoraj nikt nie poprawia. Trzecia: usunięcia są rzadkie. Jeśli już, to usuwa się całe stare okresy, najlepiej automatycznie. Czwarta: dane są indeksowane według czasu i identyfikatora, czyli według tego, kiedy i z jakiego źródła pochodzi pomiar. Piąta: danych jest dużo, a każdy pojedynczy szereg czasowy to duża i stale rosnąca liczba dokumentów.

Te cechy tłumaczą projekt kolekcji. Skoro dane prawie wyłącznie się dopisuje, a rzadko zmienia, można je pakować do zwartych wiaderek bez obawy, że trzeba będzie co chwilę je rozpakowywać. Dopowiem, że zgodnie z tym kolekcje szeregów czasowych mają ograniczenia przy aktualizacji i usuwaniu. W starszych wersjach można było zmieniać i usuwać dokumenty tylko według pola metaField. Od wersji 7.0 te ograniczenia są znacznie łagodniejsze, ale nadal są to operacje mniej wydajne niż na zwykłej kolekcji.

Dalej slajd mówi, że MongoDB używa specjalistycznego formatu kolumnowego, który grupuje dokumenty z każdej serii czasowej. Kolumnowy znaczy, że wewnątrz wiaderka wartości tego samego pola z wielu pomiarów leżą obok siebie. Na przykład wszystkie temperatury razem, wszystkie znaczniki czasu razem. Podobne wartości obok siebie dobrze się kompresują. Zalety wymienione na slajdzie to: mniejsze rozmiary pamięci masowej i indeksów, lepsza wydajność zapytań, mniej operacji wejścia i wyjścia przy odczycie, lepsze wykorzystanie pamięci podręcznej oraz mniejsza złożoność pracy z danymi szeregów czasowych. Ta ostatnia zaleta oznacza, że programista nie musi sam projektować schematu z wiaderkami, tak zwanego bucket pattern, bo baza robi to za niego.

Do zapamiętania na test: dane szeregów czasowych przychodzą chronologicznie, wymagają częstych wstawień, rzadkich aktualizacji i rzadkich usunięć, są indeksowane po czasie i identyfikatorze źródła, a ich ilość jest duża i stale rośnie. MongoDB przechowuje je w formacie kolumnowym zgrupowanym w buckets, co zmniejsza rozmiar danych i indeksów, poprawia wydajność zapytań, zmniejsza wejście i wyjście i lepiej wykorzystuje cache. Przykładowe branże to IoT, finanse, handel i DevOps.

## 5.12. Wstawianie i proste zapytania

Slajd dwusetny, zatytułowany Create and Query a Time Series Collection, czyli tworzenie i odpytywanie kolekcji szeregów czasowych, pokazuje pełny przykład z dokumentacji MongoDB.

Najpierw tworzymy kolekcję weather tak jak przed chwilą: timeseries z timeField timestamp, metaField metadata, granularity seconds, a obok expireAfterSeconds równe osiemdziesiąt sześć tysięcy czterysta, czyli doba.

Potem wstawiamy dokumenty. Piszemy db, kropka, weather, kropka, insertMany, a w nawiasie tablicę w nawiasach kwadratowych z dokumentami. Pierwszy dokument ma pole metadata, którego wartością jest zagnieżdżony dokument: sensorId, dwukropek, pięć tysięcy pięćset siedemdziesiąt osiem, oraz type, dwukropek, w cudzysłowie temperature. Dalej pole timestamp z wartością ISODate, a w nawiasie napis z datą osiemnasty maja dwa tysiące dwadzieścia jeden roku, godzina zero, z literą Z na końcu, która oznacza czas UTC. Na końcu pole temp z wartością dwanaście. Drugi dokument ma te same metadane, czas czwarta rano tego samego dnia i temperaturę jedenaście. Fragment na slajdzie jest ucięty i tablica nie jest domknięta, bo w dokumentacji wstawianych jest więcej pomiarów z dwóch dni.

Zwróć uwagę na trzy rodzaje pól w każdym dokumencie. Metadata to metaField, czyli skąd pochodzi pomiar. Timestamp to timeField, czyli kiedy. Temp to zwykłe pole pomiaru, czyli co zmierzono. Pól pomiarowych nie deklaruje się przy tworzeniu kolekcji, mogą być dowolne.

Na koniec zapytanie. Piszemy db, kropka, weather, kropka, findOne, a w nawiasie filtr: w klamrach pole timestamp, dwukropek, ISODate z datą osiemnasty maja dwa tysiące dwadzieścia jeden, godzina zero. To zwróci jeden dokument z tym znacznikiem czasu. Wniosek jest ważny: kolekcję szeregów czasowych odpytuje się dokładnie tymi samymi metodami co zwykłą kolekcję, czyli find, findOne i aggregate. Wiaderka są ukryte, a wynik wygląda jak zwykłe dokumenty.

Do zapamiętania na test: do kolekcji szeregów czasowych wstawiamy dokumenty zwykłym insertOne albo insertMany. Każdy dokument musi mieć pole czasu typu Date, w przykładzie timestamp z ISODate, a zwykle też pole metadanych, w przykładzie metadata z sensorId i type. Odpytujemy zwykłym find, findOne i aggregate.

## 5.13. Agregacja: średnia dzienna temperatura

Slajd dwieście jeden pokazuje agregację, która liczy średnią temperaturę dla każdego dnia. Przeczytam potok.

Piszemy db, kropka, weather, kropka, aggregate, a w nawiasie tablicę z dwoma etapami.

Pierwszy etap to dolar project. W nim tworzymy pole date, którego wartością jest operator dolar dateToParts, a w nim w klamrach date, dwukropek, w cudzysłowie dolar timestamp. Dalej temp, dwukropek, jeden, czyli zachowujemy pole temp. Operator dolar dateToParts rozkłada datę na części składowe i zwraca dokument z polami year, month, day, hour, minute, second oraz millisecond. Po tym etapie każdy dokument ma pole date z rozłożoną datą i pole temp.

Drugi etap to dolar group. Jako podstawę grupowania, czyli dolar podkreślnik id, podajemy dokument z polem date, w którym są trzy pola: year z wartością w cudzysłowie dolar date kropka year, month z wartością dolar date kropka month oraz day z wartością dolar date kropka day. Zwróć uwagę na notację z kropką: odwołujemy się do pól zagnieżdżonych wewnątrz date, które stworzył poprzedni etap. Godziny i minuty pomijamy, więc wszystkie pomiary z jednego dnia trafiają do tej samej grupy. W grupie liczymy pole avgTmp, dwukropek, w klamrach dolar avg, dwukropek, w cudzysłowie dolar temp, czyli średnią temperaturę.

Wynik to dwa dokumenty. Pierwszy ma identyfikator z rokiem dwa tysiące dwadzieścia jeden, miesiącem pięć i dniem osiemnaście, a średnią temperaturę około dwanaście i siedemdziesiąt jeden setnych. Drugi ma dzień dziewiętnasty i średnią równo trzynaście. Na slajdzie widać też ponownie fragment insertMany z pierwszym dokumentem, żeby przypomnieć, skąd pochodzą dane.

Dla porządku: ten sam efekt można osiągnąć krócej operatorem dolar dateTrunc z jednostką day, który poznamy na następnym slajdzie. Obie drogi są poprawne.

Do zapamiętania na test: dolar dateToParts rozkłada datę na rok, miesiąc, dzień, godzinę i dalsze części. Grupując po roku, miesiącu i dniu, zbieramy wszystkie pomiary z jednej doby. Dolar avg liczy średnią w grupie. Do pól zagnieżdżonych w wyrażeniach odwołujemy się przez dolar i notację z kropką, na przykład dolar date kropka year.

## 5.14. Średnia miesięczna i operatory dat

Slajd dwieście dwa liczy średnią miesięczną cenę zamknięcia akcji. Dane leżą w kolekcji dowJonesTickerData, czyli notowania spółek z indeksu Dow Jones. Każdy dokument ma pole date z ISODate, na przykład trzeci stycznia dwa tysiące dwudziestego, pole symbol z symbolem spółki, na przykład AAPL, czyli Apple, pole volume z wolumenem obrotu oraz ceny: open, czyli otwarcia; adjClose, czyli skorygowana cena zamknięcia; high, czyli najwyższa; low, czyli najniższa; i close, czyli cena zamknięcia.

Zapytanie: db, kropka, dowJonesTickerData, kropka, aggregate, a w nim jeden etap dolar group. Jako dolar podkreślnik id podajemy dokument z dwoma polami. Pierwsze to firstDayOfMonth, którego wartością jest dolar dateTrunc z dwoma parametrami: date, dwukropek, w cudzysłowie dolar date, oraz unit, dwukropek, w cudzysłowie month. Drugie to symbol, dwukropek, w cudzysłowie dolar symbol. W grupie liczymy avgMonthClose jako dolar avg z pola dolar close.

Dolar dateTrunc obcina datę do wskazanej jednostki. Z daty piętnastego czerwca o czternastej trzydzieści przy jednostce month zostaje pierwszy czerwca o północy. Stąd nazwa pola firstDayOfMonth, czyli pierwszy dzień miesiąca. Grupujemy więc po parze: miesiąc i spółka. Każda spółka w każdym miesiącu daje jedną grupę ze średnią ceną zamknięcia.

Wyniki pokazane na slajdzie: dla pierwszego czerwca dwa tysiące dwudziestego i symbolu GOOG, czyli Google, średnia miesięczna cena zamknięcia to około tysiąc czterysta trzydzieści jeden. Dla pierwszego lipca dwa tysiące dwudziestego pierwszego i symbolu MDB, czyli samego MongoDB, średnia to około trzysta pięćdziesiąt dwa i siedemdziesiąt trzy setne.

Slajd wymienia też operatory i etapy często używane przy szeregach czasowych. Dolar dateAdd dodaje określoną ilość czasu do daty. Dolar dateDiff zwraca różnicę czasu między dwiema datami, w wybranej jednostce. Dolar dateTrunc zwraca datę obciętą do wskazanej jednostki. Dolar setWindowFields uruchamia obliczenia na dokumentach w danym oknie. Trzy pierwsze to operatory wyrażeń, używane wewnątrz etapów. Czwarty, dolar setWindowFields, to osobny etap potoku. Na teście łatwo pomylić dateTrunc z dateToParts: dateTrunc zwraca jedną datę, obciętą; dateToParts zwraca dokument z osobnymi częściami daty.

Do zapamiętania na test: dolar dateTrunc z unit month zamienia datę na pierwszy dzień jej miesiąca, więc grupując po nim, liczymy statystyki miesięczne. Dolar dateAdd dodaje czas do daty, dolar dateDiff liczy różnicę dat, dolar dateTrunc obcina datę do jednostki, a dolar setWindowFields to etap obliczeń w oknie.

## 5.15. Średnia ruchoma i etap setWindowFields

Slajd dwieście trzy liczy średnią cenę z ostatnich trzydziestu dni, czyli średnią ruchomą, na tej samej kolekcji dowJonesTickerData.

Zapytanie ma jeden etap dolar setWindowFields z trzema parametrami. PartitionBy, dwukropek, w klamrach symbol, dwukropek, w cudzysłowie dolar symbol. To dzieli dane na partycje według spółki, więc średnia dla Apple nie miesza się z cenami Google. SortBy, dwukropek, w klamrach date, dwukropek, jeden, czyli w każdej partycji sortujemy rosnąco po dacie. Okno musi wiedzieć, co jest wcześniej, a co później. Output, czyli pola wyjściowe: averageMonthClosingPrice, a w nim dolar avg z pola dolar close oraz window, dwukropek, w klamrach range, dwukropek, w nawiasach kwadratowych minus jeden i w cudzysłowie current, a dalej unit, dwukropek, w cudzysłowie month.

Jak czytać okno? Range znaczy, że okno jest określone zakresem wartości pola sortowania, czyli daty, a nie liczbą dokumentów. Minus jeden z jednostką month oznacza jeden miesiąc wstecz od daty bieżącego dokumentu, a current oznacza bieżący dokument. Dla każdego dokumentu bierzemy więc wszystkie dokumenty tej samej spółki z ostatniego miesiąca i liczymy średnią ich cen zamknięcia. Gdybyśmy chcieli okno liczone w dokumentach, na przykład bieżący i dwa poprzednie notowania, użylibyśmy documents zamiast range.

Ważna różnica wobec dolar group: setWindowFields nie zwija dokumentów w grupy. Każdy dokument zostaje w wyniku i dostaje dodatkowe pole. Wynik na slajdzie to pełny dokument notowania Apple z dwudziestego dziewiątego stycznia dwa tysiące dwudziestego, ze wszystkimi cenami, a na końcu z nowym polem averageMonthClosingPrice równym około siedemdziesiąt siedem i sześćdziesiąt trzy setne.

Slajd podsumowuje, że potok używa dolar setWindowFields do określenia okna trzydziestodniowego i oblicza średnią ruchomą ceny zamknięcia z ostatnich trzydziestu dni dla każdej akcji. Na slajdzie pierwsze zdanie brzmi „Służy $setWindowFields do określenia okna”, to niezręczne tłumaczenie angielskiego „uses”, czyli „używa”. Druga uwaga merytoryczna: okno zapisane jako minus jeden miesiąc to w praktyce jeden miesiąc kalendarzowy wstecz, a nie dokładnie trzydzieści dni. Slajd i dokumentacja mówią w uproszczeniu o trzydziestu dniach. Gdyby zależało nam dokładnie na trzydziestu dniach, napisalibyśmy range minus trzydzieści, current, z unit day.

Do zapamiętania na test: dolar setWindowFields to etap obliczeń okienkowych. PartitionBy dzieli dane na niezależne grupy, sortBy ustala kolejność w grupie, a output definiuje nowe pola z operatorem i oknem. Window z range i unit określa okno zakresem czasu, a z documents liczbą dokumentów. W przeciwieństwie do dolar group etap setWindowFields zachowuje wszystkie dokumenty i tylko dopisuje im wyliczone pole.

## 5.16. Listowanie kolekcji szeregów czasowych

Slajd dwieście cztery pokazuje, jak sprawdzić, które kolekcje w bazie są kolekcjami szeregów czasowych. Są dwa sposoby.

Pierwszy to polecenie bazy danych uruchamiane przez runCommand. Piszemy db, kropka, runCommand, a w nawiasie dokument: listCollections, dwukropek, jeden, przecinek, filter, dwukropek, w klamrach type, dwukropek, w cudzysłowie timeseries. Drugi to pomocnik powłoki. Piszemy db, kropka, getCollectionInfos, a w nawiasie filtr: w klamrach type, dwukropek, w cudzysłowie timeseries. W obu przypadkach filtrujemy po polu type, a jego wartość dla kolekcji szeregów czasowych to napis timeseries, małymi literami i razem. Dla zwykłej kolekcji type ma wartość collection, a dla widoku view.

Slajd pokazuje wynik polecenia runCommand. To dokument z polem cursor, a w nim id równe Long zero, co znaczy, że wszystkie wyniki zmieściły się w pierwszej porcji i kursor jest już zamknięty. Pole ns ma wartość test kropka dolar cmd kropka listCollections, czyli polecenie wykonano w bazie test. W tablicy firstBatch jest jedna kolekcja: name weather, type timeseries, a w options obiekt timeseries z timeField timestamp, metaField metadata, granularity hours oraz bucketMaxSpanSeconds równe dwa miliony pięćset dziewięćdziesiąt dwa tysiące. Dalej info z readOnly false, a na końcu ok, dwukropek, jeden, czyli polecenie się powiodło.

Zwróć uwagę na dwie rzeczy. Po pierwsze, ta kolekcja weather ma granularity hours, a nie seconds jak w poprzednich przykładach, więc to inny przykład z dokumentacji albo ziarnistość została później zwiększona. Po drugie, bucketMaxSpanSeconds równe dwa miliony pięćset dziewięćdziesiąt dwa tysiące to dokładnie trzydzieści dni w sekundach. To zgadza się z tym, co mówiłem wcześniej: przy granularity hours jeden bucket obejmuje najwyżej trzydzieści dni. MongoDB sam wylicza to pole z wybranej ziarnistości. Różnica między dwoma sposobami: runCommand zwraca surową odpowiedź serwera z kursorem, a getCollectionInfos zwraca od razu tablicę opisów kolekcji.

Do zapamiętania na test: kolekcje szeregów czasowych wylistujesz poleceniem db kropka runCommand z listCollections jeden i filtrem type timeseries albo pomocnikiem db kropka getCollectionInfos z filtrem type timeseries. W wyniku opcje kolekcji zawierają timeField, metaField, granularity i bucketMaxSpanSeconds. Przy granularity hours bucketMaxSpanSeconds wynosi dwa miliony pięćset dziewięćdziesiąt dwa tysiące, czyli trzydzieści dni.

## 5.17. Widoki zmaterializowane na danych szeregów czasowych

Slajd dwieście pięć, Build Materialized Views on Top of Time Series Data, pokazuje, jak zbudować widok zmaterializowany na danych szeregów czasowych.

Potok jest taki sam jak przy średniej dziennej temperaturze: najpierw dolar project z dolar dateToParts i polem temp, potem dolar group po roku, miesiącu i dniu ze średnią avgTmp. Dochodzi trzeci etap, wyróżniony na slajdzie ramką: dolar merge. W nim into, dwukropek, w cudzysłowie dailytemperatureaverages, czyli nazwa kolekcji docelowej ze średnimi dziennymi temperaturami, oraz whenMatched, dwukropek, w cudzysłowie replace.

Co to jest widok zmaterializowany? Zwykły widok w MongoDB to zapisany potok agregacji, który wykonuje się przy każdym odczycie, więc zawsze jest aktualny, ale każdy odczyt kosztuje tyle, co całe obliczenie. Widok zmaterializowany to wynik obliczenia zapisany na dysku jako zwykła kolekcja. Odczyt jest wtedy bardzo szybki, ale dane są aktualne tylko na moment ostatniego przeliczenia. W MongoDB widoki zmaterializowane są na żądanie, po angielsku on-demand: odświeżasz je, uruchamiając potok ponownie, na przykład raz na dobę.

Etap dolar merge zapisuje wyniki potoku do wskazanej kolekcji. Musi być ostatnim etapem potoku. Parametr into podaje kolekcję docelową. Jeśli jej nie ma, zostanie utworzona. Parametr whenMatched mówi, co zrobić, gdy dokument wyniku pasuje do dokumentu już istniejącego w kolekcji docelowej. Domyślnie dopasowanie odbywa się po polu dolar podkreślnik id, a u nas identyfikatorem jest data dnia. Wartość replace oznacza, że istniejący dokument zostanie zastąpiony nowym. Inne możliwe wartości to merge, czyli połączenie pól, i to jest wartość domyślna; keepExisting, czyli zostaw stary; fail, czyli przerwij z błędem; oraz własny potok aktualizacji. Jest też parametr whenNotMatched, domyślnie insert, czyli wstaw nowy dokument.

Dlaczego dolar merge, a nie dolar out? Dolar out za każdym razem zastępuje całą kolekcję docelową. Dolar merge pozwala aktualizować przyrostowo: przeliczyć tylko ostatnie dni i podmienić tylko ich średnie, zostawiając historię nietkniętą. To idealne przy szeregach czasowych, gdzie stare dane się nie zmieniają, a nowe ciągle dochodzą. Dodatkowo, jeśli surowe dane mają ustawione expireAfterSeconds, widok zmaterializowany zachowa średnie nawet po usunięciu surowych pomiarów.

Do zapamiętania na test: widok zmaterializowany buduje się potokiem agregacji zakończonym etapem dolar merge, który zapisuje wynik do kolekcji. Into wskazuje kolekcję docelową, whenMatched replace podmienia pasujące dokumenty. Dolar merge musi być ostatnim etapem. W odróżnieniu od dolar out nie zastępuje całej kolekcji, tylko scala wyniki, więc pozwala odświeżać przyrostowo.

## 5.18. Automatyczne usuwanie danych: expireAfterSeconds

Slajd dwieście sześć ma tytuł „Włącz automatyczne usuwanie kolekcji”. Tu ważna poprawka: chodzi o automatyczne usuwanie dokumentów z kolekcji, a nie całej kolekcji. Kolekcja zostaje, znikają z niej stare pomiary.

Jak to działa? Dokument kwalifikuje się do usunięcia, gdy wartość jego pola czasu, czyli timeField, jest starsza niż bieżący czas pomniejszony o expireAfterSeconds. Ponieważ dane leżą w wiaderkach, MongoDB usuwa cały bucket dopiero wtedy, gdy wszystkie dokumenty w nim są przeterminowane. Usuwanie wykonuje proces działający w tle, ten sam, który obsługuje indeksy TTL, więc dokumenty znikają z pewnym opóźnieniem, a nie co do sekundy.

Włączenie na istniejącej kolekcji. Pierwszy sposób: db, kropka, runCommand, a w nawiasie dokument z polem collMod, dwukropek, w cudzysłowie weather24h, przecinek, expireAfterSeconds, dwukropek, sześćset cztery tysiące osiemset jeden. CollMod to polecenie modyfikacji kolekcji, skrót od collection modify. Liczba sześćset cztery tysiące osiemset to dokładnie siedem dni w sekundach, a na slajdzie, za dokumentacją, jest o jedną sekundę więcej, więc dane będą trzymane tydzień i sekundę. Drugi zapis ze slajdu to db, kropka, weather24h, kropka, collMod, a w nawiasie w klamrach expireAfterSeconds, dwukropek, sześćset cztery tysiące osiemset jeden. Uwaga: oficjalna dokumentacja MongoDB pokazuje tu formę z runCommand i collMod. Zapis skrócony jako metodę kolekcji traktuj jako wariant z wykładu; jeśli twoja wersja mongosh go nie przyjmie, używaj zawsze runCommand.

Wyłączenie automatycznego usuwania. Piszemy db, kropka, runCommand, a w nawiasie collMod, dwukropek, w cudzysłowie weather24h, przecinek, expireAfterSeconds, dwukropek, i napis off w cudzysłowie. Analogicznie w formie skróconej: db, kropka, weather24h, kropka, collMod, z expireAfterSeconds równym napisowi off. Zapamiętaj, że to jest napis off w cudzysłowie, a nie zero, nie false i nie null.

Przypomnę też, że expireAfterSeconds można podać od razu przy tworzeniu kolekcji w createCollection, obok opcji timeseries, tak jak w przykładzie z kolekcją weather i wartością osiemdziesiąt sześć tysięcy czterysta, czyli doba. CollMod służy do włączenia, zmiany albo wyłączenia tej opcji już po utworzeniu.

Do zapamiętania na test: automatyczne usuwanie starych dokumentów z kolekcji szeregów czasowych ustawia opcja expireAfterSeconds. Na istniejącej kolekcji zmienia się ją poleceniem db kropka runCommand z collMod, nazwą kolekcji i nową wartością. Wyłącza się ją wartością napisu off. Usuwanie opiera się na polu timeField, a fizycznie znika cały bucket, gdy wszystkie jego dokumenty wygasną. Sześćset cztery tysiące osiemset sekund to tydzień, osiemdziesiąt sześć tysięcy czterysta to doba.

## 5.19. Przykład IoT: zużycie energii przez klimatyzator

Ostatni merytoryczny slajd, dwieście siedem, nosi tytuł IoT Power Consumption, czyli zużycie energii w internecie rzeczy. Zadanie: wykonać agregację, która dla każdego odczytu policzy energię zużytą przez jednostkę klimatyzacyjną w ciągu ostatniej godziny.

Dane leżą w kolekcji device_readings, czyli odczyty urządzeń. Na małym zrzucie widać przykładowe dokumenty z polami podkreślnik id z ObjectId, buildingID, na przykład Building myślnik ABC, deviceID, na przykład UltraAirCon myślnik sto jedenaście, timestamp z ISODate z trzeciego lipca dwa tysiące dwadzieścia jeden oraz powerKilowatts, na przykład osiem. To ostatnie to chwilowa moc pobierana przez urządzenie, w kilowatach. Wynik dopisze pole consumedKilowattHours.

Potok jest zapisany w zmiennej JavaScript o nazwie pipelineRawReadings. Zawiera jeden etap dolar setWindowFields. PartitionBy ma wartość w cudzysłowie dolar deviceID, czyli każde urządzenie liczymy osobno. Zauważ, że tu partitionBy dostaje po prostu wyrażenie z nazwą pola, a w przykładzie z akcjami dostawało dokument z polem symbol. Obie formy są poprawne. SortBy ma timestamp, dwukropek, jeden, czyli kolejność chronologiczna. W output definiujemy pole consumedKilowattHours. Jego wartością jest operator dolar integral, czyli całka, z parametrami input, dwukropek, w cudzysłowie dolar powerKilowatts, oraz unit, dwukropek, w cudzysłowie hour. Okno, czyli window, ma range od minus jeden do current i unit hour, czyli ostatnią godzinę przed bieżącym odczytem. Potem uruchamiamy potok: db, kropka, device_readings, kropka, aggregate, a w nawiasie zmienna pipelineRawReadings. Przecinki na końcu list w kodzie ze slajdu są dopuszczalne w JavaScripcie i niczego nie psują.

Dlaczego całka? Wykres na slajdzie to wyjaśnia. Na osi pionowej jest Energy Rate, czyli moc w kilowatach, na osi poziomej czas w godzinach: pierwsza, druga i trzecia godzina. Czerwona krzywa przechodzi przez czarne punkty pomiarowe. W drugiej godzinie pod krzywą zaznaczono dwa pola, niebieskie i zielone, w kształcie trapezów. Podpis mówi: zużyta energia równa się moc razy czas, czyli kilowatogodziny, i równa się polu tych dwóch trapezów. Moc się zmienia, więc nie wystarczy pomnożyć jednej wartości przez godzinę. Trzeba zsumować pole pod wykresem mocy w czasie, a to jest właśnie całka. Operator dolar integral liczy ją w przybliżeniu metodą trapezów: każde dwa sąsiednie pomiary łączy odcinkiem i sumuje pola trapezów pod nimi. Parametr unit hour w dolar integral mówi, że czas ma być liczony w godzinach, dzięki czemu kilowaty razy godziny dają wynik w kilowatogodzinach. Bez tego czas byłby liczony w milisekundach, bo w takiej jednostce MongoDB mierzy różnice dat, a wynik byłby w zupełnie innej skali.

Zwróć uwagę, że w tym przykładzie unit występuje dwa razy i w dwóch różnych rolach. Unit wewnątrz dolar integral ustala jednostkę czasu dla całki. Unit wewnątrz window ustala jednostkę szerokości okna. Oba mają wartość hour, ale to dwa niezależne ustawienia.

Slajd dwieście osiem jest pusty i kończy część o MongoDB.

Do zapamiętania na test: dolar integral to operator okienkowy, który liczy całkę metodą trapezów, czyli pole pod wykresem wartości w czasie. Używa się go wewnątrz dolar setWindowFields, a parametr unit w nim określa jednostkę czasu, na przykład hour, żeby z kilowatów otrzymać kilowatogodziny. Przykład dzieli dane po deviceID, sortuje po timestamp i liczy energię zużytą w ostatniej godzinie dla każdego odczytu.

## Podsumowanie działu

Zbierzmy całość. Replikacja to kopie tych samych danych w zestawie replik. Jeden primary przyjmuje zapisy, secondary kopiują je przez oplog, arbiter tylko głosuje i nie ma danych, a heartbeat wykrywa awarie. Gdy primary pada, zestaw sam wybiera nowego, a mediana czasu wyboru nie powinna przekraczać dwunastu sekund. Sharding to podział danych na shardy według klucza shardującego. Klaster shardowany składa się z shardów będących zestawami replik, routerów mongos i serwerów konfiguracyjnych. Kolekcje szeregów czasowych tworzy się przez createCollection z opcją timeseries, w której są timeField, metaField i granularity. Dane trafiają do wiaderek w formacie kolumnowym, co daje kompresję. Analizuje się je agregacjami z operatorami dateToParts, dateTrunc, dateAdd, dateDiff oraz etapem setWindowFields z operatorami takimi jak avg i integral. Widok zmaterializowany zapisuje się etapem dolar merge, a automatyczne usuwanie starych pomiarów ustawia expireAfterSeconds, zmieniane poleceniem collMod i wyłączane napisem off.


# 6. Bazy klucz–wartość i Redis

W tym dziale zajmiemy się najprostszym ze wszystkich modeli NoSQL, czyli bazami klucz–wartość, a potem jego najsłynniejszym przedstawicielem, Redisem. Najpierw powiemy sobie, czym jest model klucz–wartość, jakie ma zalety i ograniczenia, kiedy go używać, a kiedy nie, i jakie produkty go reprezentują. Potem omówimy, jak projektować klucze, jak wyglądają zapytania w takich bazach i jakie dodatkowe funkcje, na przykład wygasanie kluczy, oferują. Następnie przejdziemy do Redisa: czym jest, skąd się wziął, jak wygląda jego architektura, do czego się go używa i jakie ma funkcje. Zobaczymy, jak uruchomić Redis Stack w Dockerze, jak połączyć się z nim z wiersza poleceń, z Visual Studio Code i z przeglądarki pod adresem localhost dwukropek osiem tysięcy jeden. Potem bardzo dokładnie przejdziemy przez polecenia: zarządzanie kluczami, typy danych, Stringi z poleceniami SET, GET, GETDEL, MGET i SETEX, listy, zbiory, a następnie dokumenty JSON i język ścieżek JSONPath. Na koniec omówimy indeksowanie i zapytania, czyli FT.CREATE, FT.SEARCH i FT.AGGREGATE, transakcje z MULTI i EXEC oraz nowe funkcje Redis Stack. Test pyta tu dużo o składnię, więc przy poleceniach będę zwalniał i wymawiał je dokładnie, argument po argumencie.

## 6.1. Model klucz–wartość

Zacznijmy od samego modelu danych. Baza klucz–wartość to najprostszy model bazy NoSQL. Najlepszą analogią jest tablica asocjacyjna, którą znasz z programowania jako słownik, mapę albo hash mapę. W Pythonie to dict, w Javie HashMap. Dane przechowujemy jako pary klucz–wartość. Klucz to unikalny identyfikator, na przykład ciąg znaków albo liczba. Wartość to dowolne dane: tekst, obiekt, lista, liczba. Ważne jest słowo „unikalny”: pod jednym kluczem w danej przestrzeni może być tylko jedna wartość. Jeśli zapiszesz coś drugi raz pod tym samym kluczem, nadpiszesz poprzednią wartość.

Podstawowe operacje są bardzo skromne i to jest celowe. Możemy dodać, zmienić albo usunąć wartość dla podanego klucza, i możemy pobrać wartość dla podanego klucza. Czyli w praktyce trzy, cztery operacje: put, get, delete. Zwróć uwagę, że każda z nich wymaga znajomości klucza. Baza w czystej postaci nie rozumie, co jest w środku wartości. Dla niej wartość to po prostu kawałek danych, często nazywany blobem.

Z tej prostoty wynikają zalety. Po pierwsze bardzo prosta architektura. Po drugie szybki dostęp do danych, czyli niska latencja, bo dostęp po kluczu to w praktyce operacja na tablicy haszującej, o koszcie stałym, niezależnym od liczby rekordów. Po trzecie łatwe skalowanie, zwłaszcza poziome: skoro każda operacja dotyczy jednego klucza, możemy rozrzucić klucze po wielu serwerach, na przykład licząc skrót klucza, i każdy serwer obsługuje swój kawałek bez koordynacji z innymi.

Ograniczenia są lustrzanym odbiciem zalet. Model nie sprawdza się dobrze dla danych o złożonej strukturze, bo nie ma w nim pojęcia relacji, kolumn ani zagnieżdżonych pól, które baza by rozumiała. Zazwyczaj brakuje też zaawansowanych zapytań, a szczególnie wyszukiwania po wartościach. Jeśli chcesz znaleźć wszystkich użytkowników z Krakowa, a miasto siedzi wewnątrz wartości, czysta baza klucz–wartość ci w tym nie pomoże: musiałbyś pobrać wszystko i przefiltrować u siebie. Później zobaczysz, że Redis Stack obchodzi to ograniczenie modułem wyszukiwania, ale to już rozszerzenie, a nie istota modelu.

Do zapamiętania na test: baza klucz–wartość to najprostszy model NoSQL, analogia do tablicy asocjacyjnej, czyli słownika. Klucz jest unikalnym identyfikatorem, wartość może być czymkolwiek. Operacje to dodaj, zmień, usuń i pobierz wartość po kluczu. Zalety to prosta architektura, niska latencja i łatwe skalowanie poziome. Ograniczenia to słaba obsługa złożonych struktur i zwykle brak zapytań po wartościach.

## 6.2. Kiedy używać baz klucz–wartość i kto je reprezentuje

Kolejny slajd mówi, kiedy warto sięgnąć po bazę klucz–wartość. Lista przypadków jest bardzo charakterystyczna, warto ją znać prawie na pamięć. Pierwszy przypadek to dane sesyjne, czyli informacje o zalogowanym użytkowniku przechowywane między żądaniami HTTP. Kluczem jest identyfikator sesji, wartością dane sesji. Drugi to cache aplikacyjny, czyli bufor wyników drogich obliczeń albo zapytań do bazy relacyjnej. Trzeci to ustawienia użytkownika, na przykład motyw, język, preferencje: kluczem jest identyfikator użytkownika. Czwarty to koszyki zakupowe. Piąty to rankingi i liczniki, na przykład liczba polubień czy wyświetleń. Szósty to przechowywanie tokenów i danych uwierzytelniających, na przykład sesji i kluczy API. Wspólny mianownik wszystkich tych przypadków jest taki: zawsze znamy klucz, zawsze pobieramy całą wartość, a liczy się szybkość.

Druga część slajdu mówi, kiedy nie używać takiej bazy. Po pierwsze, gdy między encjami występują złożone relacje. Po drugie, gdy potrzebne są złączenia, czyli JOIN. Po trzecie, gdy zapytania dotyczą fragmentów wartości zamiast klucza. Po czwarte, gdy trzeba przeszukiwać wiele rekordów według różnych kryteriów, na przykład filtrować po wielu polach. W tych sytuacjach lepsza będzie baza relacyjna albo dokumentowa, na przykład MongoDB, która rozumie strukturę dokumentu i pozwala indeksować jego pola.

Na slajdzie pokazano też przedstawicieli tego modelu. W górnym rzędzie: Redis, Valkey, Amazon DynamoDB i Aerospike. W dolnym rzędzie: Riak KV, Hazelcast, Oracle NoSQL Database i Dragonfly. Kilka słów o nich. Valkey to otwartoźródłowy fork Redisa, który powstał w dwa tysiące dwudziestym czwartym roku pod opieką Linux Foundation, kiedy Redis zmienił licencję. Dragonfly to nowsza baza zgodna z protokołem Redisa, nastawiona na wielowątkowość. Amazon DynamoDB to zarządzana usługa chmurowa Amazona, klucz–wartość i zarazem dokumentowa. Aerospike i Hazelcast to rozwiązania nastawione na wydajność i pamięć operacyjną, Riak KV to rozproszona baza w stylu Dynamo.

Następny slajd to wykres z serwisu DB-Engines, ranking baz klucz–wartość, w skali logarytmicznej, dla lat od dwa tysiące czternastego do dwa tysiące dwudziestego czwartego, ze stanem na październik dwa tysiące dwudziestego piątego roku. Na samym szczycie jest Redis, z wynikiem około stu i więcej. Tuż pod nim Amazon DynamoDB, około osiemdziesięciu–dziewięćdziesięciu. Dalej Microsoft Azure Cosmos DB i Memcached, w okolicach dwudziestu–trzydziestu, a reszta stawki, w tym etcd, Hazelcast, Aerospike, Oracle NoSQL, Riak KV, Apache Ignite, Ehcache, RocksDB, LevelDB czy Valkey, jest wyraźnie niżej. Skala logarytmiczna oznacza, że różnica jednej działki to różnica rzędu wielkości, więc przewaga Redisa nad większością konkurencji jest ogromna.

Do zapamiętania na test: bazy klucz–wartość stosujemy do sesji, cache, ustawień użytkownika, koszyków, rankingów i liczników oraz tokenów i kluczy API. Nie stosujemy ich przy złożonych relacjach, potrzebie JOIN, zapytaniach po fragmentach wartości i filtrowaniu po wielu polach. Przedstawiciele to Redis, Valkey, DynamoDB, Aerospike, Riak KV, Hazelcast, Oracle NoSQL i Dragonfly. W rankingu DB-Engines liderem jest Redis, a drugi jest Amazon DynamoDB.

## 6.3. Redis w pigułce

Teraz duża infografika „Redis – baza klucz–wartość. Szybka, elastyczna, wszechstronna”, z hasłami szybkość, prostota, wszechstronność. Ma dziewięć kafelków i omówię je po kolei.

Kafelek pierwszy: czym jest Redis. Nazwa to skrót od REmote DIctionary Server, czyli zdalny serwer słownika. Zapamiętaj, że duże litery w nazwie to R i E z Remote, D i I z Dictionary oraz S z Server. Redis to szybka, otwartoźródłowa baza klucz–wartość, która przechowuje dane głównie w pamięci operacyjnej, czyli w RAM. Ale Redis to nie tylko prosta baza klucz–wartość: obsługuje wiele struktur danych i zaawansowane mechanizmy, na przykład publikację i subskrypcję. Mała uwaga o licencji, bo czasem pada w rozmowach: Redis był przez lata na licencji BSD, w dwa tysiące dwudziestym czwartym przeszedł na licencje źródłowo dostępne, a od wersji ósmej dodał znów licencję otwartoźródłową AGPL. Na teście trzymaj się sformułowania ze slajdu: otwartoźródłowa baza in-memory.

Kafelek drugi: jak działa Redis. Klient, czyli aplikacja, wysyła do Redisa polecenie zapisu albo odczytu, na przykład GET albo SET, a Redis odsyła odpowiedź z wartością. Dane siedzą w RAM, co daje błyskawiczny dostęp. Opcjonalnie Redis zapisuje dane na dysk w dwóch mechanizmach: RDB i AOF. RDB to okresowe migawki, czyli snapshoty całego zbioru danych. AOF, czyli Append Only File, to dziennik, do którego dopisuje się każdą operację zapisu, tak że po restarcie można odtworzyć stan, odtwarzając te operacje. Do tego dochodzi replikacja i wysoka dostępność.

Kafelek trzeci: przykłady danych w Redis, czyli komendy w Redis CLI. Pierwsza para: SET uzytkownik dwukropek jeden, a potem w cudzysłowie Jan. To zapisuje string Jan pod kluczem uzytkownik:1. Potem GET uzytkownik dwukropek jeden zwraca Jan. Na slajdzie wynik wygląda jak znak zachęty 127.0.0.1:6379 i cudzysłów Jan; to tylko sposób zapisu, w rzeczywistości redis-cli po prostu wypisuje "Jan" pod poleceniem. Druga para to hash: HSET osoba dwukropek jeden, imie, Anna, nazwisko, Nowak, wiek, dwadzieścia osiem. HSET ustawia pola w hashu, czyli w małym słowniku zapisanym pod jednym kluczem. HGETALL osoba dwukropek jeden zwraca wszystkie pola i wartości. Trzecia para to lista: LPUSH kolejka, zadanie1, zadanie2. LPUSH wkłada elementy na lewy koniec, czyli na początek listy, po kolei, więc po tej komendzie zadanie2 będzie pierwsze, a zadanie1 drugie. To częsta pułapka: LPUSH z kilkoma wartościami odwraca ich kolejność. LRANGE kolejka zero minus jeden zwraca całą listę, bo zero to pierwszy element, a minus jeden to ostatni. Czwarta para to zbiór: SADD tagi tech backend redis dodaje trzy elementy do zbioru, a SMEMBERS tagi zwraca wszystkich członków zbioru, bez gwarantowanej kolejności.

Kafelek czwarty: obsługiwane struktury danych. Redis wspiera różne typy wartości, nie tylko proste stringi. String, na przykład tekst. Hash, na przykład obiekty. List, na przykład kolejki. Set, na przykład unikalne dane. Sorted Set, czyli zbiór posortowany, na przykład rankingi, bo każdy element ma liczbę zwaną score i zbiór jest według niej uporządkowany. Bitmap, na przykład flagi, czyli ciąg bitów, gdzie każdy bit odpowiada na pytanie tak–nie, na przykład czy użytkownik numer tysiąc był dziś aktywny. HyperLogLog, na przykład liczba unikalnych gości: to struktura probabilistyczna, która szacuje liczbę różnych elementów w stałej, małej ilości pamięci, z niewielkim błędem. I Stream, na przykład strumienie zdarzeń, czyli dziennik wpisów, do którego się dopisuje i z którego czytają konsumenci.

Kafelek piąty: najważniejsze cechy Redisa. Bardzo wysoka wydajność, bo dane są w RAM. Wszechstronne struktury danych. Trwałość danych, dzięki RDB i AOF. Replikacja i klastrowanie. Wysoka dostępność. Prosty interfejs, czyli CLI i biblioteki dla języków programowania. I rozszerzalność przez moduły, na przykład RediSearch, RedisJSON, RedisTimeSeries.

Kafelek szósty: zastosowania. Cache, czyli przyspieszanie aplikacji. Sesje użytkowników w aplikacjach webowych. E-commerce, czyli koszyki i stany produktów. Czat w czasie rzeczywistym. Rankingi i liczniki. Internet rzeczy, czyli IoT i strumienie danych.

Kafelek siódmy: zalety. Błyskawiczny dostęp do danych, liczony w mikrosekundach. Prosta obsługa i bogaty ekosystem. Obsługa wielu typów struktur danych. Skalowalność przez klastry i replikację. Szerokie zastosowania.

Kafelek ósmy: ograniczenia. Dane są przechowywane głównie w RAM, więc przy dużych zbiorach koszty są wyższe, bo gigabajt pamięci jest dużo droższy niż gigabajt dysku. Redis nie jest idealny do trwałego przechowywania dużych, złożonych danych biznesowych. Ma ograniczone możliwości zapytań, bo nie ma języka zapytań w stylu SQL. Istnieje ryzyko utraty danych przy niewłaściwej konfiguracji, na przykład gdy trwałość jest wyłączona albo snapshot robiony jest rzadko, a serwer padnie między snapshotami. I wreszcie Redis nie zastępuje typowej bazy relacyjnej.

Kafelek dziewiąty to porównanie Redisa z innymi bazami. Opowiem je zdaniami. Model danych: Redis to klucz–wartość, MongoDB to dokumenty w formacie JSON, a baza relacyjna, na przykład PostgreSQL, to tabele z wierszami i kolumnami. Szybkość: Redis bardzo wysoka, MongoDB wysoka, relacyjna średnia. Złożoność zapytań: Redis prosta, MongoDB średnia, relacyjna zaawansowana, czyli SQL. Przechowywanie danych: Redis głównie RAM, MongoDB dysk, relacyjna dysk. Typowe zastosowania: Redis to cache, sesje i kolejki, MongoDB to aplikacje webowe i systemy CMS, a baza relacyjna to systemy biznesowe. Hasło podsumowujące infografikę brzmi: Redis to szybkość, elastyczność i więcej niż tylko klucz–wartość, idealne rozwiązanie dla aplikacji wymagających wysokiej wydajności i pracy w czasie rzeczywistym.

Do zapamiętania na test: Redis to REmote DIctionary Server, baza klucz–wartość trzymająca dane głównie w RAM. Trwałość zapewniają RDB, czyli snapshoty, i AOF, czyli dziennik operacji. Struktury danych to String, Hash, List, Set, Sorted Set, Bitmap, HyperLogLog i Stream. Sorted Set służy do rankingów, HyperLogLog do liczenia unikalnych gości, Bitmap do flag. Moduły to między innymi RediSearch, RedisJSON i RedisTimeSeries. Słabości to koszt RAM, brak języka zapytań typu SQL i ryzyko utraty danych przy złej konfiguracji. W porównaniu Redis jest najszybszy, ma najprostsze zapytania i trzyma dane w RAM, a MongoDB i baza relacyjna trzymają je na dysku.

## 6.4. Zarządzanie kluczami

Wracamy do ogólnej teorii baz klucz–wartość. Skoro wszystko opiera się na kluczu, kluczowe pytanie, i to dosłownie, brzmi: jak klucze powinny być zdefiniowane? Slajd podaje trzy podejścia.

Pierwsze to rzeczywiste identyfikatory, czyli takie, które istnieją w świecie, na przykład adres e-mail, PESEL albo login. Zaleta: klucz coś znaczy i często znamy go z góry, więc nie musimy go nigdzie wyszukiwać. Wada: rzeczywiste identyfikatory bywają zmienne, na przykład ktoś zmienia e-mail, i bywają danymi wrażliwymi, jak PESEL.

Drugie podejście to wartości generowane automatycznie. Tu slajd wymienia auto-inkrementację, czyli kolejne liczby jeden, dwa, trzy, i zaznacza jej problemy: z podziałem na klastry serwerów oraz ze znaczeniem. Problem z klastrem polega na tym, że licznik musi być wspólny dla wszystkich serwerów, a więc jest wąskim gardłem i punktem koordynacji, co kłóci się z ideą skalowania poziomego. Problem ze znaczeniem polega na tym, że sama liczba nic nie mówi: klucz czterdzieści dwa nie mówi, czy to użytkownik, zamówienie czy produkt. Dlatego w praktyce często stosuje się klucze złożone, czyli połączenia bytów rzeczywistych z datami, identyfikatorami, logami. Slajd podkreśla, że są one często wykorzystywane w praktyce. Przykład: klucz złożony z identyfikatora czujnika i daty pomiaru.

Trzecie podejście to prefiksy, również bardzo często wykorzystywane. Na slajdzie przykłady film podkreślnik terminator oraz film podkreślnik dwudziesty drugi październik dwa tysiące dwudziestego roku. Prefiks mówi, jakiego rodzaju obiekt kryje się pod kluczem. W świecie Redisa standardem jest separator dwukropek, na przykład user dwukropek jeden, bikes dwukropek jeden albo, jak na jednym z rysunków w tym dziale, Company dwukropek Employee dwukropek dwanaście tysięcy trzysta czterdzieści pięć. Narzędzia graficzne, które zobaczymy dalej, grupują klucze z tym samym prefiksem w foldery, a indeksy wyszukiwania filtrują dokumenty właśnie po prefiksie.

Do zapamiętania na test: klucze mogą być rzeczywistymi identyfikatorami, jak e-mail, PESEL, login, albo generowane automatycznie. Auto-inkrementacja ma problemy z podziałem na klastry i z brakiem znaczenia. W praktyce często używa się kluczy złożonych, łączących byty rzeczywiste z datami, identyfikatorami i logami, oraz prefiksów, na przykład film_terminator.

## 6.5. Zapytania w bazach klucz–wartość

Slajd o zapytaniach. Podstawowe operacje CRUD, czyli Create, Read, Update, Delete, działają najczęściej dla określonych kluczy. Z tego wynika wniosek, który slajd oznacza strzałką: znajomość konwencji nazewniczej kluczy jest istotna. Jeśli nie wiesz, jak nazywają się klucze, nie dobierzesz się do danych. Co więcej, w zależności od systemu NoSQL może być bardzo trudne uzyskanie informacji o wszystkich dostępnych kluczach. W Redisie istnieje co prawda polecenie KEYS z wzorcem, ale przegląda ono całą przestrzeń kluczy i na dużej produkcyjnej bazie blokuje serwer, dlatego w praktyce zaleca się iteracyjne SCAN.

Druga ważna myśl: dostęp do części wartości w parze najczęściej nie jest możliwy. Nie zapytasz o jedno pole wewnątrz wartości, bo baza traktuje ją jako całość. Są jednak systemy, które dostarczają mechanizmów do przetwarzania i przeszukiwania części związanej z wartością. Przetwarzanie wartości wykorzystuje wtedy jej częściowe indeksowanie. Dokładnie to robi Redis Stack z modułami JSON i Search: rozumie strukturę dokumentu JSON i pozwala zindeksować wybrane pola.

Trzecia myśl: przetwarzanie wsadowe lub sekwencyjne, gdzie slajd wymienia MapReduce. To model, w którym najpierw funkcja map przetwarza każdą parę osobno i emituje wyniki pośrednie, a potem funkcja reduce agreguje wyniki pogrupowane po kluczu. Pozwala to przejść przez wszystkie dane równolegle na wielu maszynach, choć nie nadaje się do szybkich, interaktywnych zapytań.

Do zapamiętania na test: CRUD w bazach klucz–wartość działa dla określonych kluczy, więc konwencja nazewnicza kluczy jest istotna, a uzyskanie listy wszystkich kluczy bywa trudne. Dostęp do części wartości zwykle nie jest możliwy, chyba że system oferuje częściowe indeksowanie wartości. Do przetwarzania wsadowego używa się MapReduce.

## 6.6. Inne funkcje baz klucz–wartość

Kolejny slajd wymienia dodatkowe funkcje. Pierwsza to wygasanie par klucz–wartość. Obiekty są automatycznie usuwane z bazy po pewnym interwale czasu. To przydatne w przypadku sesji użytkownika czy koszyków zakupowych: sesja, której nikt nie używa od pół godziny, sama znika i nie trzeba pisać procesu sprzątającego. W Redisie odpowiadają za to polecenia EXPIRE, TTL czy opcja EX w poleceniu SET, które za chwilę omówimy. Czas życia klucza nazywamy TTL, od Time To Live.

Druga funkcja to połączenia między parami klucz–wartość. Wartości mogą być wzajemnie połączone przez odsyłacze, po angielsku links, a odsyłacze mogą być odwiedzane podczas zapytań. Tak działał na przykład Riak z mechanizmem link walking.

Trzecia funkcja to kolekcje wartości. Przechowywane mogą być nie tylko proste wartości, ale też ich kolekcje, na przykład uporządkowane listy i nieuporządkowane zbiory, a także dane binarne czy hierarchiczne. W Redisie listą uporządkowaną jest typ List, a zbiorem nieuporządkowanym typ Set.

Slajd kończy się ważnym zastrzeżeniem kursywą: konkretna funkcjonalność zależy od stosowanej bazy danych. Model klucz–wartość jest tylko ramą, a każdy produkt dokłada swoje.

Do zapamiętania na test: dodatkowe funkcje to wygasanie, czyli automatyczne usuwanie po czasie, przydatne dla sesji i koszyków, połączenia przez odsyłacze, czyli links, które można odwiedzać w zapytaniach, oraz kolekcje wartości, czyli listy uporządkowane, zbiory nieuporządkowane, dane binarne i hierarchiczne. Funkcjonalność zależy od konkretnej bazy.

## 6.7. Redis: in-memory, open source, rok 2009

Następny slajd to dwa odręczne rysunki. Na lewym widzimy logo Redisa i podpisy: Non-Relational, czyli NoSQL, Key-Value oraz JSON. To trzy hasła opisujące, czym Redis jest: bazą nierelacyjną, bazą klucz–wartość, która w wersji Stack obsługuje także dokumenty JSON. Na prawym, większym rysunku jest napis REmote DIctionary Service, rok dwa tysiące dziewiąty, kontur Włoch z Sycylią i Sardynią, zdjęcie twórcy, piła, puchar i bolid Formuły jeden z modułem RAM i dyskiem. Rozszyfrujmy to. Redis powstał w dwa tysiące dziewiątym roku, a jego twórcą jest Włoch, Salvatore Sanfilippo, znany jako antirez, z Sycylii. Stąd mapa Włoch. Bolid Formuły jeden symbolizuje szybkość, moduł RAM to przechowywanie w pamięci, a dysk to opcjonalna trwałość. Uwaga na pułapkę: na tym rysunku rozwinięcie skrótu brzmi REmote DIctionary Service, a na wcześniejszej infografice REmote DIctionary Server. Poprawna, oficjalna wersja to REmote DIctionary Server, czyli serwer, nie serwis.

Na rysunku są też przykłady kluczy z dwukropkami: Company dwukropek Employee dwukropek dwanaście tysięcy trzysta czterdzieści pięć oraz World dwukropek Map dwukropek Europe. To dokładnie konwencja prefiksów, o której mówiliśmy. Są również hasła: Key–Value database, No locks, czyli brak blokad, Different data types, Fast access time, Open Source, i logo Redis Stack. Hasło „brak blokad” bierze się stąd, że Redis wykonuje polecenia w jednym głównym wątku, jedno po drugim. Skoro dwa polecenia nigdy nie działają jednocześnie na tych samych danych, nie trzeba zakładać blokad, a każde pojedyncze polecenie jest automatycznie atomowe.

Tekst slajdu podsumowuje: Redis to open-source'owa, in-memory baza danych typu NoSQL, która działa jako magazyn struktur danych. Kluczowe cechy: przechowywanie danych w pamięci, czyli in-memory. Wysoka wydajność, czyli szybkość odczytu i zapisu. Obsługa różnych struktur danych, takich jak listy, zbiory, hashe. I zastosowanie w systemach wymagających szybkiego dostępu. Określenie „magazyn struktur danych”, po angielsku data structure store, jest ważne: Redis nie przechowuje tylko napisów, ale gotowe struktury, na których wykonuje operacje po stronie serwera, na przykład dodaje element do listy albo liczy część wspólną zbiorów.

Do zapamiętania na test: Redis powstał w dwa tysiące dziewiątym roku, autorem jest Włoch Salvatore Sanfilippo. To open-source'owa baza in-memory, magazyn struktur danych. Poprawne rozwinięcie skrótu to REmote DIctionary Server. Polecenia wykonuje jeden wątek, więc nie potrzebuje blokad, a pojedyncze polecenia są atomowe.

## 6.8. Architektura Redisa jako cache przed bazą relacyjną

Slajd o architekturze pokazuje typowe wdrożenie, wzięte z serwisu javatpoint. Po lewej są klienci, czyli komputer i telefon, połączeni z aplikacją. Aplikacja komunikuje się z dwoma światami: z Redisem i z bazą MySQL.

Omówmy elementy po kolei. Clients to użytkownicy, na przykład przeglądarka albo aplikacja mobilna, którzy wysyłają żądania do aplikacji. App, czyli aplikacja, obsługuje logikę biznesową i wykonuje trzy rodzaje operacji. App Reads to odczyty z Redisa, który pełni rolę cache. Cache Updates to zapisy danych do Redisa. Database Reads i Writes to komunikacja z bazą MySQL.

Redis Master to główny serwer Redisa. Przechowuje dane w pamięci i obsługuje zarówno odczyty, jak i zapisy z aplikacji. Redis Read Replica to kopia Redisa tylko do odczytu. Master replikuje do niej dane, a aplikacja może z niej czytać. Po co? Replika zmniejsza obciążenie głównego serwera przy dużej liczbie zapytań, bo odczyty rozkładają się na więcej maszyn. Pamiętaj, że zapisy idą zawsze do mastera, a replika jest tylko do odczytu.

MySQL DB Instance, na dole po prawej, to tradycyjna baza danych, czyli trwały magazyn, po angielsku persistent storage. Redis działa tu jako warstwa cache przed MySQL, żeby przyspieszyć dostęp do danych. Typowy przebieg wygląda tak: aplikacja najpierw pyta Redisa. Jeśli dane są w cache, mamy trafienie, cache hit, i odpowiedź przychodzi w ułamku milisekundy. Jeśli ich nie ma, cache miss, aplikacja czyta z MySQL, a następnie wkłada wynik do Redisa, zwykle z czasem wygaśnięcia, żeby następne żądanie było już szybkie. Ten wzorzec nazywa się cache-aside albo lazy loading. Źródłem prawdy pozostaje MySQL, a Redis to szybka kopia najczęściej używanych danych.

Do zapamiętania na test: w tej architekturze Redis Master przechowuje dane w pamięci i obsługuje odczyty i zapisy, Redis Read Replica jest kopią tylko do odczytu, która odciąża mastera, a MySQL jest trwałym magazynem danych. Redis działa jako warstwa cache przed MySQL. Operacje aplikacji to App Reads, Cache Updates oraz Database Reads i Writes.

## 6.9. Mapa tematów Redisa: programowanie i administracja

Kolejny slajd to rysunek mężczyzny i chłopaka przy laptopach, otoczonych hasłami. Hasła dzielą się na dwie grupy.

Pierwsza grupa to funkcjonalności i programowanie. redis-py module to biblioteka Pythona do obsługi Redisa; importujemy ją jako redis i łączymy się z serwerem z kodu. Data types to typy danych w Redisie: string, list, set, sorted set, hash, stream. Optimization to techniki optymalizacji, na przykład pipeline, clustering i sharding. Pipeline polega na wysłaniu wielu poleceń naraz, bez czekania na odpowiedź po każdym z nich, co oszczędza czas na podróżach w sieci. Clustering i sharding to rozkładanie danych na wiele serwerów. Transactions to obsługa transakcji poleceniami MULTI, EXEC i WATCH. Full text search to wyszukiwanie pełnotekstowe z modułem RediSearch; slajd pisze RedisSearch, oficjalna nazwa modułu to RediSearch, z jednym s pośrodku. Publication and subscription to mechanizm Pub/Sub do komunikacji w czasie rzeczywistym: nadawca publikuje wiadomość na kanale, a wszyscy subskrybenci kanału ją dostają.

Druga grupa to aspekty administracyjne i konfiguracja. Installation to proces instalacji Redisa na różnych platformach. Command line to korzystanie z CLI, czyli redis-cli, do zarządzania i wykonywania poleceń. Configuration to ustawienia serwera, na przykład plik redis.conf, parametry wydajności i bezpieczeństwa. Security to mechanizmy zabezpieczeń: uwierzytelnianie, ACL, czyli listy kontroli dostępu, oraz szyfrowanie. Extensions to dodatkowe moduły i rozszerzenia, na przykład RedisGraph i RedisJSON. Dodam, że RedisGraph został przez firmę Redis wycofany z rozwoju, ale na slajdzie występuje jako przykład modułu. Cloud to wdrożenia Redisa w chmurze, na przykład Redis Enterprise Cloud albo AWS ElastiCache.

Do zapamiętania na test: redis-py to biblioteka Pythona dla Redisa, redis-cli to klient wiersza poleceń, redis.conf to plik konfiguracyjny. Transakcje to MULTI, EXEC i WATCH. Wyszukiwanie pełnotekstowe daje moduł RediSearch. Pub/Sub służy do komunikacji w czasie rzeczywistym. Optymalizacja to pipeline, clustering i sharding. Bezpieczeństwo to uwierzytelnianie, ACL i szyfrowanie. W chmurze Redis występuje jako Redis Enterprise Cloud albo AWS ElastiCache.

## 6.10. Zastosowania Redisa

Slajd z odręcznym rysunkiem, na którym logo Redisa stoi między modułem RAM a dyskiem twardym, a pod nim jest logo Pythona. Wymienia sześć zastosowań.

Pierwsze to cache, czyli szybkie buforowanie danych w pamięci, które przyspiesza odczyt często używanych informacji. Drugie to machine learning, czyli przechowywanie modeli i danych do szybkiego dostępu w aplikacjach ML, na przykład cech, tak zwanych features, potrzebnych modelowi w chwili predykcji. Trzecie to Streams, czyli obsługa strumieni danych przez Redis Streams, do analizy i przetwarzania w czasie rzeczywistym. Czwarte to Target Database: Redis może działać jako główna baza danych dla aplikacji wymagających niskich opóźnień, a nie tylko jako cache. Piąte to Pub/Sub, mechanizm publikacji i subskrypcji do komunikacji w czasie rzeczywistym. Szóste to Statistics, czyli przechowywanie i obliczanie statystyk, na przykład w systemach monitorowania i analityce. Tu przydają się liczniki INCR, zbiory posortowane i HyperLogLog.

Do zapamiętania na test: sześć zastosowań ze slajdu to cache, machine learning, Streams, Target Database, czyli Redis jako główna baza, Pub/Sub oraz Statistics.

## 6.11. Funkcje Redisa

Slajd „Funkcje Redis” wymienia osiem cech. Pierwsza: szybkość. Dane są w RAM, operacje SET i GET są bardzo szybkie. Slajd podaje konkretne liczby, które warto zapamiętać, bo nadają się na pytanie: do stu dziesięciu tysięcy operacji SET na sekundę i osiemdziesięciu jeden tysięcy operacji GET na sekundę. Te liczby pochodzą z popularnego tutoriala i dotyczą konkretnego starszego testu; w praktyce wynik zależy od sprzętu, ale na teście podaj sto dziesięć tysięcy SET i osiemdziesiąt jeden tysięcy GET.

Druga: trwałość. Zmiany są zapisywane na dysku asynchronicznie, według ustalonych zasad. Asynchronicznie znaczy, że klient dostaje potwierdzenie, zanim dane trafią na dysk. Stąd właśnie ryzyko utraty ostatnich zmian przy awarii. Trzecia: struktury danych, czyli string, listy, zbiory, hashe i zbiory posortowane. Czwarta: operacje atomowe. Slajd mówi, że wszystkie operacje są niepodzielne i bezpieczne. Precyzyjnie: każde pojedyncze polecenie Redisa jest atomowe, bo wykonuje się w całości, zanim zacznie się następne. Piąta: obsługa wielu języków, czyli klienty dla większości popularnych języków programowania. Szósta: replikacja Master/Slave, prosta i szybka. Dziś Redis zamiast słowa slave używa nazwy replica, ale znaczenie jest to samo: serwer główny i jego kopie. Siódma: fragmentowanie, czyli sharding, łatwe rozdzielanie danych na wiele instancji. Ósma: przenośność. Redis działa na większości systemów POSIX: Linux, BSD, macOS, Solaris. Zwróć uwagę, że Windows nie jest systemem POSIX i Redis nie jest na nim oficjalnie wspierany natywnie, dlatego na Windowsie uruchamia się go najczęściej w Dockerze albo w WSL, co zresztą robimy na zajęciach.

Do zapamiętania na test: Redis ładuje do stu dziesięciu tysięcy SET na sekundę i osiemdziesięciu jeden tysięcy GET na sekundę. Trwałość to zapis na dysk asynchroniczny. Operacje są atomowe. Replikacja to Master/Slave. Sharding to fragmentowanie na wiele instancji. Przenośność oznacza działanie na systemach POSIX: Linux, BSD, macOS, Solaris.

## 6.12. Klient i serwer Redisa

Slajd „Architektura Redis'a” mówi, że w architekturze Redisa istnieją dwa główne procesy: klient Redisa i serwer Redisa. Klient i serwer mogą być na tym samym komputerze albo na dwóch różnych. Serwer Redisa służy do przechowywania danych w pamięci, kontroluje wszystkie rodzaje zarządzania i stanowi główną część architektury. Na diagramie po lewej jest Redis Console Client, po prawej Redis Server, opisany jako odpowiedzialny za przechowywanie danych i serwowanie ich klientowi, z walcem Data Store w środku. Między nimi jest dwukierunkowa strzałka Send And Receive Data. Klientem konsolowym jest program redis-cli, a serwerem program redis-server. Domyślny port serwera to sześć tysięcy trzysta siedemdziesiąt dziewięć. Ta liczba wróci za chwilę przy Dockerze i jest bardzo prawdopodobna na teście.

Do zapamiętania na test: dwa procesy to klient, na przykład redis-cli, i serwer, czyli redis-server. Mogą działać na jednej albo na dwóch maszynach. Dane w pamięci przechowuje serwer. Domyślny port Redisa to 6379.

## 6.13. Redis w Dockerze

Przechodzimy do praktyki. Slajd pokazuje, jak uruchomić Redis Stack w Dockerze. Najpierw pobieramy obraz: docker pull redis ukośnik redis-stack. Na slajdzie przed tym poleceniem stoją dwa myślniki, co wygląda jak komentarz w stylu SQL; to tylko ozdobnik, właściwe polecenie zaczyna się od słowa docker.

Potem uruchamiamy kontener: docker run, spacja, minus d, spacja, minus minus name, redis-stack, spacja, minus p, sześć tysięcy trzysta siedemdziesiąt dziewięć dwukropek sześć tysięcy trzysta siedemdziesiąt dziewięć, spacja, minus p, osiem tysięcy jeden dwukropek osiem tysięcy jeden, spacja, redis ukośnik redis-stack dwukropek latest. Na slajdzie to polecenie jest złamane na dwie linie bez znaku kontynuacji; w prawdziwej powłoce trzeba je wpisać w jednej linii albo zakończyć pierwszą linię odwrotnym ukośnikiem w Bashu lub odwróconym apostrofem w PowerShellu.

Rozbierzmy opcje. Minus d oznacza tryb detached, czyli kontener działa w tle, a terminal zostaje wolny. Minus minus name nadaje kontenerowi nazwę redis-stack, dzięki której później możemy się do niego odwoływać. Minus p mapuje port w formacie port hosta dwukropek port kontenera. Port 6379 to port samego serwera Redis, przez który łączą się klienci, redis-cli i biblioteki. Port 8001 to port Redis Insight, czyli przeglądarkowego interfejsu graficznego wbudowanego w obraz redis-stack. Na końcu jest nazwa obrazu, redis/redis-stack, z tagiem latest, czyli najnowszą wersją. Slajd podsumowuje: polecenie uruchamia kontener Redis w tle, w trybie detached, o nazwie redis-stack, dostępny na hoście na portach 6379 i 8001, oparty na obrazie redis/redis-stack:latest. Na zrzucie z Docker Desktop widać ten kontener ze statusem Running i dwoma mapowaniami portów.

Kolejne polecenie: docker exec, spacja, minus it, spacja, redis-stack, spacja, redis-cli. Uruchamia ono interaktywną konsolę redis-cli wewnątrz kontenera o nazwie redis-stack. Opcja minus it to połączenie dwóch flag: minus i, czyli interactive, utrzymuje otwarte wejście standardowe, a minus t, czyli tty, przydziela pseudoterminal. Razem dają normalną, interaktywną sesję. Po wykonaniu widzimy znak zachęty: 127.0.0.1 dwukropek 6379, znak większości. To znaczy, że jesteśmy połączeni z serwerem na lokalnym adresie i domyślnym porcie i możemy wpisywać polecenia. Nie myl docker run, które tworzy i uruchamia nowy kontener z obrazu, z docker exec, które wykonuje polecenie w kontenerze już działającym.

Do zapamiętania na test: obraz to redis/redis-stack. Minus d to tryb w tle, minus minus name nadaje nazwę, minus p mapuje porty host:kontener. Port 6379 to serwer Redis, port 8001 to interfejs przeglądarkowy Redis Insight. Konsolę otwieramy przez docker exec minus it redis-stack redis-cli, a jej znak zachęty to 127.0.0.1:6379>.

## 6.14. Redis w VS Code i w przeglądarce

Trzy slajdy pokazują narzędzia graficzne. Pierwsze to rozszerzenie VS Code o nazwie „Redis”, wersja 6.7.7, autor Weijan Chen, z serwisu database-client.com. Opisane jest jako menedżer baz MySQL, MariaDB, PostgreSQL, SQLite, Redis i ElasticSearch i ma ponad sto dziewiętnaście tysięcy pobrań. Na zrzucie widać komunikat, że rozszerzenie wyłączono, bo bieżący obszar roboczy nie jest zaufany; to mechanizm Workspace Trust w VS Code. W panelu NoSQL widać połączenie 127.0.0.1 małpa 6379, wersję serwera 6.2.13, bazę numer zero i folder bikes z kluczami od bikes:0 do bikes:6, każdy typu ReJSON-RL. ReJSON-RL to wewnętrzna nazwa typu danych modułu RedisJSON, czyli te klucze przechowują dokumenty JSON. Formularz Connect to server ma pola Name, Host z wartością 127.0.0.1, Port 6379, Username, Password, Database z wartością zero, opcje Cluster, SSH Tunnel, Socks Proxy, SSL, oraz listę typów serwerów, wśród nich Redis i MongoDB. Jest też uwaga, że pełna funkcjonalność jest płatna, a darmowa wersja ma limit trzech połączeń.

Drugie narzędzie to oficjalne rozszerzenie „Redis for VS Code” od wydawcy Redis, czyli redis.io, z opisem: wizualna praca z danymi i budowanie zapytań w Redisie. W panelu widać połączenie 127.0.0.1:6379, bazę zero ze stu siedemdziesięcioma sześcioma kluczami i foldery z przykładowymi danymi: sample_bicycle, sample_jobQueue, sample_leaderboard, sample_restaurant, sample_session. Na drugim zrzucie otwarty jest klucz sample_bicycle:1002 typu JSON, z informacją Key Size 922 bajty, Length 9 i TTL No limit, czyli klucz nie ma ustawionego wygaśnięcia. Fragment dokumentu zawiera pola model o wartości Explorer i brand o wartości Trailblazer.

Trzecie narzędzie to Redis Stack Browser, czyli interfejs dostępny w przeglądarce pod adresem localhost dwukropek osiem tysięcy jeden, ścieżka redis-stack ukośnik browser. To właśnie ten port 8001, który zmapowaliśmy w Dockerze. Widać tam bazę „My Redis Stack Database”, db0, i filtr typów kluczy z listą: All Key Types, Hash, List, Set, Sorted Set, String, JSON, Stream, Graph i TS, czyli Time Series. Jest pole Filter by Key Name or Pattern, czyli filtr po nazwie lub wzorcu. Na pierwszym zrzucie są trzy klucze typu STRING, a wybrany klucz imie ma wartość Henryk, długość sześć znaków i TTL No limit. Na drugim zrzucie jest sto kluczy typu JSON, na przykład bikes:12, bikes:76, bikes:4, a podgląd klucza bikes:1 pokazuje dokument z polami model, Hyperion1, brand, Velorim, price, osiemset czterdzieści cztery, type, Enduro bikes. To ten sam rower, którego model za chwilę zmienimy poleceniem JSON.SET z Hyperion na Hyperion1.

Do zapamiętania na test: Redis Stack ma interfejs przeglądarkowy pod adresem localhost:8001. Do VS Code istnieje rozszerzenie „Redis” Weijana Chena, menedżer wielu baz, oraz oficjalne „Redis for VS Code” od Redis. Typ ReJSON-RL oznacza klucz z dokumentem JSON. TTL No limit oznacza brak wygaśnięcia. Domyślna baza ma numer zero, a połączenie lokalne to 127.0.0.1 na porcie 6379.

## 6.15. Polecenia do zarządzania kluczami

Teraz szesnaście poleceń operujących na kluczach, niezależnie od typu wartości. Slajd pochodzi z tutoriala javatpoint. To idealny materiał na pytania typu „które polecenie”, więc przy każdym powiem, co zwraca i z czym łatwo je pomylić.

Pierwsze: DEL key, czyli usunięcie klucza, jeśli istnieje. Można podać kilka kluczy naraz, a polecenie zwraca liczbę faktycznie usuniętych kluczy. Drugie: DUMP key zwraca serializowaną wersję wartości zapisanej pod kluczem, czyli binarny zapis, który można potem odtworzyć poleceniem RESTORE. Trzecie: EXISTS key sprawdza, czy klucz istnieje; zwraca jeden, jeśli istnieje, i zero, jeśli nie.

Teraz czwórka poleceń do wygasania, którą trzeba dobrze rozróżniać. EXPIRE key, a pełna składnia to EXPIRE, klucz, liczba sekund, ustawia wygaśnięcie klucza po upływie podanego czasu w sekundach. Slajd w kolumnie polecenia pomija argument z liczbą sekund, ale on jest wymagany. EXPIREAT ustawia wygaśnięcie w konkretnym momencie, podanym jako znacznik czasu UNIX w sekundach, czyli liczba sekund od pierwszego stycznia tysiąc dziewięćset siedemdziesiątego roku. PEXPIRE to samo co EXPIRE, ale w milisekundach. PEXPIREAT to samo co EXPIREAT, ale znacznik czasu UNIX jest w milisekundach. Reguła pamięciowa: litera P na początku oznacza milisekundy, a końcówka AT oznacza konkretny moment w czasie, a nie odstęp.

KEYS pattern znajduje wszystkie klucze pasujące do wzorca. Wzorzec używa symboli wieloznacznych w stylu powłoki: gwiazdka oznacza dowolny ciąg znaków, znak zapytania jeden dowolny znak, a nawiasy kwadratowe zbiór znaków. Na przykład KEYS bikes dwukropek gwiazdka zwróci wszystkie rowery. KEYS gwiazdka zwraca wszystkie klucze. Pamiętaj, że na produkcji to polecenie jest niebezpieczne, bo przegląda całą bazę i blokuje serwer; bezpieczniejszą alternatywą jest SCAN.

MOVE key przenosi klucz do innej bazy danych; pełna składnia to MOVE, klucz, numer bazy. Redis ma kilka logicznych baz numerowanych od zera, domyślnie szesnaście, od zera do piętnastu. PERSIST key usuwa datę ważności z klucza, czyli sprawia, że klucz przestaje wygasać. PTTL key zwraca pozostały czas życia w milisekundach, a TTL key w sekundach. Bardzo ważne wartości specjalne, często pytane: TTL zwraca minus jeden, gdy klucz istnieje, ale nie ma ustawionego wygaśnięcia, i minus dwa, gdy klucz nie istnieje. RANDOMKEY, na slajdzie zapisane małymi literami, zwraca losowy klucz z bazy. RENAME key newkey zmienia nazwę klucza; jeśli klucz o nowej nazwie już istnieje, zostanie nadpisany. RENAMENX key newkey zmienia nazwę tylko wtedy, gdy nowy klucz nie istnieje. Końcówka NX, od Not eXists, w Redisie zawsze znaczy „tylko jeśli nie istnieje”. Wreszcie TYPE key zwraca typ danych wartości zapisanej pod kluczem, na przykład string, list, set, zset, czyli zbiór posortowany, hash albo stream. Dla dokumentu JSON zwróci ReJSON-RL, a dla nieistniejącego klucza słowo none.

Do zapamiętania na test: DEL usuwa, EXISTS sprawdza istnienie, DUMP serializuje. EXPIRE ustawia wygaśnięcie w sekundach, PEXPIRE w milisekundach, EXPIREAT i PEXPIREAT w konkretnym momencie jako znacznik UNIX. TTL pokazuje pozostały czas w sekundach, PTTL w milisekundach; minus jeden to brak wygaśnięcia, minus dwa to brak klucza. PERSIST usuwa wygaśnięcie. KEYS szuka po wzorcu, MOVE przenosi do innej bazy, RANDOMKEY losuje klucz, RENAME zmienia nazwę, RENAMENX tylko gdy nowa nazwa jest wolna, TYPE zwraca typ.

## 6.16. Typy danych Redisa i limity rozmiarów

Slajd o typach danych pokazuje fragment strony redis.io, gdzie w menu są: Strings, JSON, Lists, Sets, Hashes, Sorted sets, Streams, Geospatial, Bitmaps, Bitfields, Probabilistic i Time series. Dane w Redisie są zapisywane w strukturze klucz–wartość. Klucz jest zawsze unikalny, a wartość może być różnego typu.

Slajd wymienia pięć podstawowych typów. String, czyli tekst lub liczby. List, czyli lista elementów. Set, czyli zbiór unikalnych wartości. Hash, czyli zbiór par pole–wartość, jak słownik. I sorted set, zbiór z rankingiem, na przykład top dziesięć.

Rozmiar klucza: maksymalnie pięćset dwanaście megabajtów, choć w praktyce stosuje się dużo mniejsze, od kilku bajtów do kilobajtów, bo długie klucze zabierają pamięć i spowalniają porównania. Dobra praktyka nazewnicza to format typ obiektu, dwukropek, identyfikator, na przykład auto dwukropek zero zero zero jeden.

Limity opowiem zdaniami. Klucz: do pięciuset dwunastu megabajtów, ale zalecane są małe klucze. Pojedyncza wartość typu string: również do pięciuset dwunastu megabajtów. Lista: do dwóch do potęgi trzydziestej drugiej minus jeden elementów, czyli około czterech miliardów. Zbiór: tak samo, do dwóch do trzydziestej drugiej minus jeden elementów. Hash: do dwóch do trzydziestej drugiej minus jeden pól, a każdy element do pięciuset dwunastu megabajtów. Sorted set: do dwóch do trzydziestej drugiej minus jeden elementów. Łatwo zapamiętać: wszystko, co jest pojedynczym napisem, ma limit pięćset dwanaście megabajtów, a wszystko, co jest kolekcją, ma limit liczby elementów dwa do trzydziestej drugiej minus jeden, czyli około czterech miliardów.

Do zapamiętania na test: maksymalny rozmiar klucza i wartości typu string to 512 MB. Listy, zbiory, hashe i zbiory posortowane mieszczą do dwa do potęgi trzydziestej drugiej minus jeden elementów, czyli około czterech miliardów. Dobra praktyka nazewnicza to typ_obiektu:id, na przykład auto:0001. Podstawowe typy to string, list, set, hash i sorted set.

## 6.17. Redis Strings: charakterystyka

String to najprostszy typ wartości powiązany z kluczem. Strings w Redisie przechowują sekwencje bajtów. Mogą zawierać tekst, zserializowane obiekty i tablice binarne. To znaczy, że string w Redisie jest „binarnie bezpieczny”, po angielsku binary safe: możesz w nim zapisać obrazek JPEG albo obiekt zserializowany przez Pythona, a nie tylko tekst.

Zastosowania ze slajdu: buforowanie danych, implementacja liczników, wykonywanie operacji bitowych oraz przechowywanie fragmentów HTML albo całych stron. Liczniki działają dlatego, że jeśli string zawiera liczbę całkowitą, polecenia INCR i DECR traktują go jak liczbę. Operacje bitowe działają dlatego, że string to ciąg bajtów, a więc i bitów, którymi można sterować poleceniami SETBIT i GETBIT.

Działanie: klucze w Redisie są łańcuchami znaków, a użycie typu String oznacza mapowanie jednego łańcucha znaków na inny. To uniwersalny typ wykorzystywany w wielu scenariuszach. Kolejny slajd, z redis.io, mówi po angielsku to samo: Redis strings are the most basic Redis data type, representing a sequence of bytes, czyli stringi są najbardziej podstawowym typem danych Redisa i reprezentują sekwencję bajtów.

Do zapamiętania na test: String to najprostszy typ, sekwencja bajtów, może zawierać tekst, obiekty zserializowane i dane binarne, ma limit 512 MB. Zastosowania to cache, liczniki, operacje bitowe i fragmenty HTML. Użycie Stringa to mapowanie jednego łańcucha na inny.

## 6.18. Przegląd poleceń dla Stringów

Dwa slajdy wymieniają polecenia stringowe: jeden w wersji angielskiej z redis.io, drugi w tabeli z javatpoint. Omówię je razem, w grupach, bo tak łatwiej je zapamiętać.

Grupa zapisu i odczytu. SET key value ustawia wartość klucza. GET key pobiera wartość. MSET, czyli multi set, ustawia wiele par naraz: MSET klucz wartość klucz wartość i tak dalej; robi to atomowo. MGET klucz jeden, klucz dwa, i tak dalej, atomowo pobiera wiele wartości. MSETNX ustawia wiele par, ale tylko wtedy, gdy żaden z kluczy jeszcze nie istnieje; jeśli choć jeden istnieje, nie ustawia niczego. SETNX key value ustawia wartość tylko wtedy, gdy klucz nie istnieje; zwraca jeden przy sukcesie i zero, gdy klucz już był. To klasyczny sposób na prostą blokadę.

Grupa łączenia zapisu z odczytem. GETSET key value ustawia nową wartość i zwraca starą. GETDEL zwraca wartość i usuwa klucz. GETEX zwraca wartość i jednocześnie ustawia czas wygaśnięcia.

Grupa wygasania. SETEX key seconds value ustawia wartość razem z czasem wygaśnięcia w sekundach. Na slajdzie z javatpoint opis brzmi „ustawienie wartości po wygaśnięciu klucza”, co jest złym tłumaczeniem; poprawnie: ustawia wartość i jednocześnie czas, po którym klucz wygaśnie. PSETEX key milliseconds value robi to samo w milisekundach. Uwaga na kolejność argumentów: w SETEX czas stoi przed wartością, czyli SETEX klucz, sekundy, wartość.

Grupa fragmentów napisu. GETRANGE key start end zwraca podciąg, przy czym oba końce są włączne, a indeksy ujemne liczą od końca. SUBSTR to starsza nazwa tego samego, zwraca podciąg. SETRANGE key offset value nadpisuje część napisu od podanego przesunięcia. STRLEN zwraca długość wartości. APPEND key value dopisuje tekst na końcu wartości, a jeśli klucz nie istnieje, tworzy go. LCS znajduje najdłuższy wspólny podciąg dwóch napisów, od longest common substring; ściśle mówiąc algorytm liczy najdłuższy wspólny podciąg w sensie podsekwencji, ale redis.io opisuje go słowami ze slajdu.

Grupa bitów. GETBIT key offset zwraca wartość bitu na danym przesunięciu. SETBIT key offset value ustawia albo kasuje bit na danym przesunięciu.

Grupa liczników. INCR key zwiększa wartość całkowitą o jeden. INCRBY key increment zwiększa o podaną liczbę całkowitą. INCRBYFLOAT key increment zwiększa wartość zmiennoprzecinkową o podaną liczbę. DECR key zmniejsza o jeden. DECRBY key decrement zmniejsza o podaną liczbę. Bardzo ważny szczegół z redis.io: jeśli klucz nie istnieje, te polecenia przyjmują zero jako wartość początkową. Czyli INCR na nieistniejącym kluczu da jeden, a DECR da minus jeden. Jeśli natomiast wartość nie jest liczbą, na przykład zawiera słowo Jan, dostaniemy błąd. Nie ma osobnego polecenia DECRBYFLOAT: żeby zmniejszyć liczbę zmiennoprzecinkową, podajemy INCRBYFLOAT z liczbą ujemną.

Do zapamiętania na test: MSET i MGET działają na wielu kluczach atomowo, MSETNX ustawia wszystko albo nic. SETNX ustawia tylko nieistniejący klucz. GETSET zwraca starą wartość i ustawia nową. SETEX ustawia wartość z wygaśnięciem w sekundach, PSETEX w milisekundach. GETRANGE zwraca podciąg, SETRANGE nadpisuje fragment, STRLEN zwraca długość, APPEND dopisuje. INCR, INCRBY, INCRBYFLOAT, DECR i DECRBY zmieniają liczby i dla nieistniejącego klucza startują od zera.

## 6.19. SET szczegółowo

Teraz pięć poleceń, którym prowadzący poświęcił osobne slajdy. Zaczynamy od SET. Pełna składnia brzmi tak: SET, klucz, wartość, a potem opcjonalnie jedno z dwóch: NX albo XX, potem opcjonalnie GET, a potem opcjonalnie jedno z: EX sekundy, PX milisekundy, EXAT czas UNIX w sekundach, PXAT czas UNIX w milisekundach albo KEEPTTL.

Co oznaczają te opcje? NX: ustaw tylko wtedy, gdy klucz nie istnieje. XX: ustaw tylko wtedy, gdy klucz już istnieje. Te dwie się wykluczają. GET: zwróć starą wartość zapisaną pod kluczem, zanim ją nadpiszesz; to nowoczesny zamiennik polecenia GETSET. EX: wygaśnięcie po tylu sekundach. PX: wygaśnięcie po tylu milisekundach. EXAT: wygaśnięcie w konkretnym momencie podanym w sekundach UNIX. PXAT: to samo w milisekundach. KEEPTTL: zachowaj dotychczasowy czas życia klucza.

Opis ze slajdu: SET ustawia klucz tak, aby przechowywał wartość typu string. Jeśli klucz ma już wartość, zostanie ona nadpisana, niezależnie od typu. Czyli jeśli pod kluczem była lista, po SET będzie tam string, a lista przepadnie. I trzecie zdanie, bardzo ważne na test: poprzedni czas życia, TTL, powiązany z kluczem jest usuwany po pomyślnym wykonaniu SET. Innymi słowy, jeśli klucz miał wygasnąć za minutę, a ty wykonasz zwykłe SET, klucz przestanie wygasać. Żeby tego uniknąć, dodajesz KEEPTTL.

Przykład ze slajdu. SET mykey, w cudzysłowie Hello, odpowiedź OK. GET mykey, odpowiedź Hello. Potem SET anotherkey, w cudzysłowie „will expire in a minute”, spacja, EX, spacja, sześćdziesiąt. Odpowiedź OK. Ten klucz wygaśnie po sześćdziesięciu sekundach, czyli po minucie. Zwróć uwagę, że wartość ze spacjami musi być w cudzysłowie, inaczej redis-cli potraktuje każde słowo jako osobny argument i zgłosi błąd składni.

Do zapamiętania na test: SET nadpisuje wartość niezależnie od typu i kasuje poprzedni TTL. NX znaczy tylko gdy nie istnieje, XX tylko gdy istnieje, GET zwraca starą wartość, EX ustawia sekundy, PX milisekundy, EXAT i PXAT moment UNIX, KEEPTTL zachowuje czas życia. Przykład: SET anotherkey "will expire in a minute" EX 60.

## 6.20. GET i GETDEL

GET ma najprostszą składnię: GET, klucz. Pobiera wartość klucza. Jeśli klucz nie istnieje, zwracana jest specjalna wartość nil, w redis-cli wypisywana jako nil w nawiasach okrągłych. Jeśli natomiast pod kluczem jest wartość innego typu niż string, na przykład lista albo hash, GET zwraca błąd, bo obsługuje tylko stringi. Ten błąd ma prefiks WRONGTYPE. Przykład ze slajdu: GET nonexisting zwraca nil. SET mykey Hello zwraca OK. GET mykey zwraca Hello. Wniosek: do odczytu innych typów służą inne polecenia, dla hasha HGET albo HGETALL, dla listy LRANGE, dla zbioru SMEMBERS, a dla JSON polecenie JSON.GET.

GETDEL, składnia GETDEL, klucz. Pobiera wartość klucza i usuwa ten klucz. Działa jak GET, z tą różnicą, że po pomyślnym pobraniu usuwa klucz, ale tylko wtedy, gdy wartość jest typu string. Przykład: SET mykey Hello, odpowiedź OK. GETDEL mykey, odpowiedź Hello. Następnie GET mykey, odpowiedź nil, bo klucza już nie ma. GETDEL przydaje się na przykład przy jednorazowych tokenach: odczytujesz token i od razu go unieważniasz, jednym atomowym poleceniem, tak że nikt inny nie zdąży go użyć między odczytem a usunięciem.

Do zapamiętania na test: GET zwraca nil dla nieistniejącego klucza i błąd dla wartości, która nie jest stringiem. GETDEL zwraca wartość i usuwa klucz, więc kolejne GET zwraca nil.

## 6.21. MGET

MGET, składnia: MGET, klucz, a potem dowolnie wiele kolejnych kluczy. Zwraca wartości wszystkich podanych kluczy, w tej samej kolejności, w jakiej je podaliśmy. Dla każdego klucza, który nie przechowuje stringa albo nie istnieje, zwracana jest wartość nil. Dzięki temu operacja nigdy nie kończy się błędem. To ważna różnica w stosunku do GET: GET na liście daje błąd WRONGTYPE, a MGET na liście daje po prostu nil na tej pozycji.

Przykład ze slajdu. SET key1 Hello, OK. SET key2 World, OK. MGET key1 key2 nonexisting. Odpowiedź to lista trzech pozycji: jeden, Hello; dwa, World; trzy, nil. MGET jest atomowe, a do tego jest szybsze niż trzy osobne GET, bo wymaga jednej podróży do serwera zamiast trzech.

Do zapamiętania na test: MGET zwraca listę wartości w kolejności kluczy, dla brakujących kluczy i kluczy innego typu zwraca nil i nigdy nie kończy się błędem. MGET key1 key2 nonexisting daje Hello, World, nil.

## 6.22. SETEX, polecenie przestarzałe

SETEX, składnia: SETEX, klucz, liczba sekund, wartość. Ustawia klucz na wartość typu string i ustawia wygaśnięcie po podanej liczbie sekund. Jest równoważne poleceniu SET, klucz, wartość, EX, sekundy. Slajd podkreśla, że od wersji Redisa 2.6.12 to polecenie jest uznawane za przestarzałe, deprecated. W nowym kodzie i przy migracji należy zastąpić je poleceniem SET z argumentem EX. Wersja 2.6.12 to właśnie ta, w której SET dostał opcje EX, PX, NX i XX, dlatego osobne polecenia SETEX, PSETEX i SETNX straciły rację bytu.

Przykład ze slajdu. SETEX mykey dziesięć, w cudzysłowie Hello. Odpowiedź OK. TTL mykey, odpowiedź integer dziesięć, czyli zostało dziesięć sekund. GET mykey, odpowiedź Hello. Po dziesięciu sekundach GET zwróciłoby nil. Pułapka testowa: w SETEX kolejność to klucz, sekundy, wartość, a w SET z opcją EX to klucz, wartość, EX, sekundy.

Do zapamiętania na test: SETEX key seconds value jest równoważne SET key value EX seconds. SETEX jest przestarzałe od Redisa 2.6.12. Po SETEX mykey 10 "Hello" polecenie TTL mykey zwraca 10.

## 6.23. Redis Lists: idea i podstawowe polecenia

Przechodzimy do list. Slajd definiuje je tak: listy to połączone listy wartości typu string. Połączone, czyli w sensie struktury danych linked list. Ma to konsekwencje: dodanie albo zdjęcie elementu z początku lub z końca jest bardzo szybkie, o koszcie stałym, nawet przy milionach elementów, ale dostęp do elementu w środku po indeksie wymaga przejścia po liście, więc jest wolniejszy. Listy są często używane do implementacji stosów i kolejek oraz do zarządzania kolejkami dla systemów zadań w tle, czyli workerów, które pobierają kolejne zadania do wykonania.

Polecenia podstawowe. LPUSH dodaje nowy element na początek listy, a RPUSH na koniec. L to left, czyli lewa strona, początek, a R to right, prawa strona, koniec. LPOP usuwa i zwraca element z początku listy, a RPOP robi to samo od końca. LLEN zwraca długość listy. LMOVE atomowo przenosi element z jednej listy na drugą; w pełnej składni podajemy listę źródłową, docelową oraz dwa kierunki, LEFT albo RIGHT, z której strony zdjąć i z której strony włożyć. LTRIM przycina listę do określonego zakresu elementów, co jest świetnym sposobem na trzymanie na przykład tylko stu ostatnich wpisów: po każdym LPUSH robimy LTRIM od zera do dziewięćdziesięciu dziewięciu.

Jak z tego zrobić stos i kolejkę? Stos, czyli LIFO, ostatni wszedł, pierwszy wychodzi: wkładamy LPUSH i zdejmujemy LPOP, czyli z tej samej strony. Kolejka, czyli FIFO, pierwszy wszedł, pierwszy wychodzi: wkładamy LPUSH i zdejmujemy RPOP, czyli z przeciwnych stron. Albo RPUSH i LPOP. Zapamiętaj: ta sama strona to stos, przeciwne strony to kolejka.

Listy obsługują też polecenia blokujące. BLPOP usuwa i zwraca element z początku listy, a jeśli lista jest pusta, polecenie blokuje się, czyli czeka, dopóki element nie stanie się dostępny albo nie minie określony limit czasu. BLMOVE atomowo przenosi element z listy źródłowej do docelowej, a jeśli źródłowa jest pusta, blokuje się, dopóki element się nie pojawi. Litera B na początku oznacza blocking. Dzięki temu worker nie musi co chwilę pytać, czy jest nowe zadanie; po prostu wisi na BLPOP i budzi się, gdy zadanie przyjdzie. Limit czasu podajemy w sekundach, a zero oznacza czekanie bez końca.

Przykład z kolejnego slajdu. LPUSH mylist, w cudzysłowie first. Potem RPUSH mylist, w cudzysłowie last. Następnie LRANGE mylist zero minus jeden. Odpowiedź: first, last. Pierwsze polecenie włożyło first na początek pustej listy, drugie dołożyło last na koniec, więc kolejność to first, potem last. LRANGE zero minus jeden to idiom „cała lista”: indeks zero to pierwszy element, minus jeden to ostatni, a oba końce zakresu są włączone. Analogicznie minus dwa to przedostatni.

Do zapamiętania na test: listy w Redisie to połączone listy stringów, używane do stosów i kolejek. LPUSH dodaje na początek, RPUSH na koniec, LPOP i RPOP zdejmują z początku i końca, LLEN podaje długość, LMOVE przenosi między listami, LTRIM przycina. Polecenia z literą B, jak BLPOP i BLMOVE, blokują się na pustej liście. LRANGE klucz 0 -1 zwraca całą listę; po LPUSH mylist "first" i RPUSH mylist "last" wynik to first, last.

## 6.24. Pełna lista poleceń dla list

Dwa slajdy wymieniają wszystkie polecenia list: jeden po angielsku z redis.io, drugi jako tabela z javatpoint z pełną składnią. Omówię je razem.

Polecenia blokujące. BLPOP klucz jeden, opcjonalnie kolejne klucze, i na końcu timeout: usuwa i zwraca pierwszy element z pierwszej niepustej listy albo blokuje, dopóki jakiś nie będzie dostępny. BRPOP ma tę samą składnię, ale zwraca ostatni element. BRPOPLPUSH źródło, cel, timeout: zdejmuje element z końca źródła, wkłada go na początek celu i zwraca go, a jeśli źródło jest puste, blokuje. BLMOVE to nowsza, ogólniejsza wersja tego samego, z wyborem stron. BLMPOP zdejmuje pierwszy element z jednej z wielu list, a gdy wszystkie są puste, blokuje. Redis.io dopisuje przy wielu z tych poleceń ważną uwagę: jeśli zdjęto ostatni element, lista jest usuwana. W Redisie nie istnieją puste listy; klucz z pustą listą po prostu znika.

Polecenia indeksowe i wyszukujące. LINDEX klucz indeks zwraca element listy według indeksu. LINSERT klucz, BEFORE albo AFTER, pivot, wartość: wstawia element przed albo po innym elemencie, który nazywamy pivotem, czyli punktem odniesienia. LPOS zwraca indeks elementów pasujących do wartości. LSET klucz indeks wartość ustawia wartość elementu o danym indeksie.

Polecenia dodające. LPUSH klucz, wartość jeden, wartość dwa i tak dalej: dodaje jedną lub wiele wartości na początek i tworzy klucz, jeśli nie istnieje. LPUSHX klucz wartość dodaje na początek tylko wtedy, gdy lista już istnieje. RPUSH i RPUSHX działają analogicznie na końcu listy. Końcówka X znaczy tu „tylko jeśli istnieje”.

Polecenia usuwające. LPOP klucz zdejmuje i zwraca pierwszy element, RPOP ostatni. LMPOP zdejmuje wiele elementów naraz. LREM klucz, count, wartość usuwa elementy równe wartości; count określa, ile i od której strony: liczba dodatnia oznacza usuwanie od początku, ujemna od końca, a zero wszystkie wystąpienia. LTRIM klucz start stop przycina listę do zakresu, usuwając elementy z obu końców. RPOPLPUSH źródło cel zdejmuje ostatni element ze źródła, dokłada go na początek celu i zwraca. RPOPLPUSH i BRPOPLPUSH są dziś uznawane za przestarzałe na rzecz LMOVE i BLMOVE.

Zakresy i długość. LRANGE klucz start stop zwraca zakres elementów. LLEN klucz zwraca długość listy.

Do zapamiętania na test: LINDEX czyta po indeksie, LSET zapisuje po indeksie, LINSERT wstawia BEFORE albo AFTER pivota, LPOS szuka indeksu wartości, LREM usuwa wartości z licznikiem, LTRIM przycina. Końcówka X w LPUSHX i RPUSHX oznacza „tylko gdy lista istnieje”. BRPOPLPUSH i RPOPLPUSH przenoszą element z końca jednej listy na początek drugiej. Usunięcie ostatniego elementu kasuje cały klucz listy.

## 6.25. Redis Sets: idea i podstawowe polecenia

Zbiór w Redisie to nieuporządkowana kolekcja unikalnych wartości typu string, które nazywamy członkami, po angielsku members. Dwie cechy są kluczowe: brak kolejności i brak duplikatów. Dodanie tego samego elementu drugi raz niczego nie zmienia.

Slajd mówi, do czego zbiory się nadają. Po pierwsze do śledzenia unikalnych elementów, na przykład wszystkich unikalnych adresów IP, które odwiedziły dany wpis na blogu. Każdy adres dodajemy do zbioru, a duplikaty odpadają same. Po drugie do reprezentowania relacji, na przykład zbiór wszystkich użytkowników z określoną rolą. Po trzecie do typowych operacji na zbiorach, takich jak iloczyny, czyli części wspólne, sumy i różnice.

Podstawowe polecenia. SADD dodaje nowego członka do zbioru. SREM usuwa określonego członka. SISMEMBER sprawdza, czy dany string należy do zbioru, i zwraca jeden albo zero. SINTER zwraca członków wspólnych dla dwóch lub więcej zbiorów, czyli ich część wspólną. SCARD zwraca rozmiar, czyli liczebność zbioru. CARD pochodzi od słowa cardinality, czyli moc zbioru. Nie myl SCARD z LLEN: dla listy długość to LLEN, dla zbioru liczebność to SCARD.

Przykład. SADD myset, a potem w cudzysłowach apple, banana i cherry. SMEMBERS myset zwraca wszystkich członków; na slajdzie odpowiedź to apple, banana, cherry. Pamiętaj jednak, że zbiór nie ma kolejności, więc w prawdziwym redis-cli te trzy elementy mogą wyjść w innej kolejności. SADD zwraca liczbę faktycznie dodanych nowych członków, więc gdybyśmy wykonali to samo SADD drugi raz, dostalibyśmy zero.

Do zapamiętania na test: Set to nieuporządkowana kolekcja unikalnych stringów. Zastosowania to unikalne elementy, na przykład adresy IP, relacje, na przykład użytkownicy z rolą, i operacje na zbiorach. SADD dodaje, SREM usuwa, SISMEMBER sprawdza przynależność, SINTER zwraca część wspólną, SCARD liczebność, SMEMBERS wszystkich członków.

## 6.26. Pełna lista poleceń dla zbiorów

Znowu dwa slajdy: redis.io po angielsku i tabela z javatpoint. Polecenia układają się w czytelne grupy.

Dodawanie, usuwanie i liczenie. SADD klucz, member jeden, member dwa i tak dalej, dodaje jednego lub więcej członków i tworzy klucz, jeśli nie istnieje. SREM klucz, member jeden i kolejne, usuwa członków; jeśli usunięto ostatniego, zbiór znika. SCARD klucz zwraca liczbę członków.

Sprawdzanie i odczyt. SISMEMBER klucz member sprawdza, czy wartość należy do zbioru. SMISMEMBER sprawdza naraz wielu członków i zwraca listę zer i jedynek. SMEMBERS zwraca wszystkich członków. SSCAN klucz, kursor, opcjonalnie MATCH wzorzec i COUNT liczba, służy do przyrostowej iteracji po elementach, czyli kawałek po kawałku, co jest bezpieczne dla dużych zbiorów, w przeciwieństwie do SMEMBERS, które zwraca wszystko naraz.

Elementy losowe. SPOP klucz usuwa i zwraca losowego członka, a w nowszych wersjach może zwrócić kilku. SRANDMEMBER klucz, opcjonalnie count, zwraca jednego lub kilku losowych członków, ale ich nie usuwa. To częsta pułapka: SPOP usuwa, SRANDMEMBER nie usuwa. Na przykład losowanie zwycięzcy loterii, który nie może wygrać drugi raz, to SPOP.

Przenoszenie. SMOVE źródło, cel, member przenosi członka z jednego zbioru do drugiego.

Operacje teoriomnogościowe. SDIFF klucz jeden, klucz dwa i tak dalej zwraca różnicę, czyli elementy pierwszego zbioru, których nie ma w pozostałych. Kolejność kluczy ma tu znaczenie, w przeciwieństwie do sumy i iloczynu. SINTER zwraca część wspólną, czyli iloczyn. SUNION zwraca sumę. Każde z nich ma wersję z końcówką STORE: SDIFFSTORE, SINTERSTORE i SUNIONSTORE, gdzie pierwszym argumentem jest klucz docelowy, destination, a wynik nie jest zwracany, tylko zapisywany pod tym kluczem. Na przykład SINTERSTORE wspolni, zbior a, zbior b. Jest też SINTERCARD, które zwraca tylko liczbę elementów części wspólnej, bez samych elementów. Tabela z javatpoint opisuje SUNION jako „dodawanie wielu zestawów”, a SDIFF jako „odejmowanie”, a SINTER jako „przecinanie”: to po prostu suma, różnica i część wspólna.

Do zapamiętania na test: SDIFF to różnica, SINTER część wspólna, SUNION suma, a wersje STORE zapisują wynik pod kluczem docelowym podanym jako pierwszy argument. SINTERCARD zwraca liczbę elementów części wspólnej. SPOP usuwa losowego członka, SRANDMEMBER tylko go zwraca. SMOVE przenosi członka między zbiorami, SSCAN iteruje przyrostowo, SMISMEMBER sprawdza wielu członków naraz.

## 6.27. Typ JSON i jego polecenia

Teraz typ JSON, dostępny w Redis Stack dzięki modułowi RedisJSON, a w nowych wersjach Redisa wbudowany. Wszystkie polecenia tego typu mają prefiks JSON kropka, na przykład JSON.SET, i niemal wszystkie przyjmują ścieżkę, path, która wskazuje miejsce w dokumencie. Ścieżka zaczyna się od znaku dolara, który oznacza korzeń dokumentu. Slajd wymienia dwadzieścia pięć poleceń. Pogrupuję je.

Podstawowe. JSON.SET ustawia albo aktualizuje wartość JSON pod ścieżką. JSON.GET pobiera wartość pod jedną lub wieloma ścieżkami w postaci zserializowanego JSON. JSON.DEL usuwa wartość. JSON.FORGET również usuwa wartość; to dokładny alias JSON.DEL. JSON.MGET zwraca wartości pod jedną ścieżką z wielu kluczy. JSON.MSET ustawia lub aktualizuje wartości wielu kluczy. JSON.MERGE scala podaną wartość JSON z dopasowanymi ścieżkami; w rezultacie wartości są aktualizowane, usuwane albo rozszerzane o nowe dzieci. JSON.TYPE zwraca typ wartości pod ścieżką, na przykład object, array, string, integer, number albo boolean. JSON.RESP zwraca wartość w formacie protokołu RESP, czyli Redis Serialization Protocol, tym samym, którym klient rozmawia z serwerem.

Operacje na tablicach, wszystkie z przedrostkiem ARR. JSON.ARRAPPEND dokleja jedną lub więcej wartości na koniec tablicy. JSON.ARRINDEX zwraca indeks pierwszego wystąpienia wartości skalarnej w tablicy. JSON.ARRINSERT wstawia wartości pod wskazany indeks. JSON.ARRLEN zwraca długość tablicy. JSON.ARRPOP usuwa i zwraca element o wskazanym indeksie, domyślnie ostatni. JSON.ARRTRIM przycina tablicę do podanego zakresu indeksów, włącznie z oboma końcami.

Operacje na obiektach, z przedrostkiem OBJ. JSON.OBJKEYS zwraca klucze obiektu, a JSON.OBJLEN liczbę kluczy obiektu.

Operacje na liczbach, napisach i wartościach logicznych. JSON.NUMINCRBY zwiększa wartość liczbową o podaną liczbę, a JSON.NUMMULTBY mnoży ją przez podaną liczbę. JSON.STRAPPEND dokleja napis do napisu JSON, a JSON.STRLEN zwraca długość napisu. JSON.TOGGLE przełącza wartość logiczną, czyli zamienia true na false i odwrotnie. JSON.CLEAR czyści wszystkie wartości z tablicy albo obiektu, a wartości liczbowe ustawia na zero.

Diagnostyka. JSON.DEBUG to polecenie kontenerowe do debugowania, a JSON.DEBUG MEMORY zwraca rozmiar klucza w bajtach.

Na teście łatwo pomylić analogiczne polecenia z różnych typów. Długość napisu w zwykłym stringu to STRLEN, a w dokumencie JSON to JSON.STRLEN. Długość listy to LLEN, a tablicy w JSON to JSON.ARRLEN. Zwiększenie liczby w stringu to INCRBY, a w JSON to JSON.NUMINCRBY. Usunięcie klucza to DEL, a usunięcie w JSON to JSON.DEL albo JSON.FORGET.

Do zapamiętania na test: polecenia JSON mają prefiks JSON kropka i przyjmują ścieżkę zaczynającą się od dolara, który oznacza korzeń. JSON.FORGET to alias JSON.DEL. ARR dotyczy tablic, OBJ obiektów, NUM liczb, STR napisów. JSON.TOGGLE przełącza boolean, JSON.CLEAR zeruje liczby i opróżnia tablice i obiekty, JSON.MERGE scala dokumenty, JSON.NUMMULTBY mnoży, JSON.RESP zwraca wartość w protokole RESP.

## 6.28. Praca z JSON: rowery i szkoły

Slajd „Working with JSON” pokazuje tworzenie dokumentu roweru. Składnia: JSON.SET, spacja, bikes dwukropek jeden, spacja, dolar, spacja, a potem w pojedynczych apostrofach cały dokument JSON. Dokument ma pola: model o wartości Hyperion, brand o wartości Velorim, price osiemset czterdzieści cztery, type Enduro bikes, obiekt specs z polami material full-carbon i weight osiem i siedem dziesiątych, oraz długie pole description, opis roweru po angielsku, wspominający między innymi osprzęt Shimano 105 i obręcze DT Swiss. Dolar jako ścieżka oznacza, że ustawiamy cały dokument od korzenia. Pojedyncze apostrofy otaczają JSON po to, żeby redis-cli potraktował go jako jeden argument mimo spacji i podwójnych cudzysłowów w środku.

Odczyt wybranych pól. JSON.GET bikes dwukropek jeden, dolar kropka model, zwraca model. JSON.GET bikes dwukropek jeden, dolar kropka specs kropka material, zwraca materiał z zagnieżdżonego obiektu specs. Ważny szczegół: przy ścieżce zaczynającej się od dolara wynik jest zawsze tablicą JSON, czyli dostaniesz w nawiasach kwadratowych Hyperion w cudzysłowie, a nie gołe Hyperion. Tak jest dlatego, że ścieżka JSONPath może pasować do wielu miejsc naraz.

Aktualizacja wybranego pola. JSON.SET bikes dwukropek jeden, dolar kropka model, a potem w apostrofach, w cudzysłowie, Hyperion1. Zwróć uwagę na podwójne opakowanie: apostrofy są dla powłoki redis-cli, a cudzysłowy w środku są częścią wartości JSON, bo napis w JSON musi być w cudzysłowie. Gdybyś napisał samo Hyperion1 bez cudzysłowów, Redis zgłosiłby błąd, bo to nie jest poprawny JSON. Liczby natomiast, jak za chwilę zobaczymy, podajemy bez cudzysłowów.

Usunięcie roweru: JSON.DEL bikes dwukropek jeden. Bez ścieżki usuwany jest cały dokument, czyli cały klucz.

Slajd dodaje uwagę: aby w CLI zmienić bazę logiczną, wykonujemy polecenie SELECT, na przykład SELECT jeden. Redis ma kilka logicznych baz numerowanych od zera; domyślnie pracujemy w bazie zero, a znak zachęty redis-cli po zmianie pokazuje numer bazy w nawiasie kwadratowym. Na zrzucie z VS Code w bazie zero jest folder bikes ze stu jeden kluczami, a w bazie jeden folder school_json z pięcioma kluczami.

Kolejny slajd pokazuje odczyt na dokumencie szkoły, kluczu school_json dwukropek jeden. Pięć wariantów, które trzeba znać. Pierwszy: JSON.GET school_json:1 dolar, czyli cały dokument. Drugi: JSON.GET school_json:1 dolar kropka description, czyli jedno pole. Trzeci: JSON.GET school_json:1 dolar kropka address kropka city, czyli zagnieżdżone pole city w obiekcie address. Czwarty: JSON.GET school_json:1 dolar kropka status_log, w nawiasach kwadratowych zero, czyli pierwszy element tablicy status_log. Piąty: dolar kropka status_log, w nawiasach kwadratowych minus jeden, czyli ostatni element tablicy. Indeksy tablic liczymy od zera, a minus jeden oznacza ostatni element.

Następny slajd pokazuje aktualizację i usuwanie. Najpierw JSON.GET school_json:1 dolar kropka students, czyli odczyt liczby uczniów przed zmianą. Potem JSON.SET school_json:1 dolar kropka students trzysta czterdzieści trzy, czyli ustawienie nowej liczby; to liczba, więc bez cudzysłowów. Potem ponowny odczyt, żeby potwierdzić zmianę. Przy usuwaniu: JSON.DEL school_json:1 dolar kropka students usuwa tylko pole students z dokumentu, a reszta dokumentu zostaje. JSON.GET school_json:1 bez ścieżki odczytuje cały dokument, żeby sprawdzić, że pola już nie ma. Na slajdzie komentarz mówi w tym miejscu o polu construction_value, ale to pozostałość z innego przykładu; usuwaliśmy pole students i to jego brak sprawdzamy. Wreszcie JSON.DEL school_json:1 bez ścieżki usuwa cały dokument, a kolejne JSON.GET potwierdza, że go nie ma, zwracając nil. Komentarze po dwóch ukośnikach na slajdach są tylko objaśnieniem; redis-cli nie obsługuje takich komentarzy i nie należy ich wpisywać.

Do zapamiętania na test: JSON.SET klucz $ '{...}' tworzy dokument. JSON.GET klucz $.pole czyta pole, $.a.b czyta pole zagnieżdżone, $.tablica[0] pierwszy element, $.tablica[-1] ostatni. Napis w JSON.SET podajemy w cudzysłowach wewnątrz apostrofów, na przykład '"Hyperion1"', a liczbę bez cudzysłowów. JSON.DEL ze ścieżką usuwa pole, bez ścieżki cały dokument. SELECT 1 zmienia bazę logiczną.

## 6.29. JSONPath, czyli XPath dla JSON

Slajd porównuje JSONPath z XPath, językiem ścieżek dla XML. Przykład dotyczy klasycznego dokumentu sklepu, w którym jest kilka książek i czerwony rower. Opowiem każdą parę.

Pierwsza para. W XPath ukośnik store ukośnik book ukośnik author, w JSONPath dolar kropka store kropka book, nawias kwadratowy z gwiazdką, kropka author. Wynik: autorzy wszystkich książek w sklepie. Gwiazdka w nawiasie oznacza wszystkie elementy tablicy.

Druga para. W XPath dwa ukośniki author, w JSONPath dolar, dwie kropki, author. Wynik: wszyscy autorzy, gdziekolwiek są w dokumencie. Dwie kropki to zejście rekurencyjne, odpowiednik podwójnego ukośnika w XPath: szukaj na każdej głębokości.

Trzecia para. XPath: ukośnik store ukośnik gwiazdka. JSONPath: dolar kropka store kropka gwiazdka. Wynik: wszystkie rzeczy w sklepie, czyli kilka książek i czerwony rower. Gwiazdka po kropce to wszystkie dzieci obiektu.

Czwarta para. XPath: ukośnik store, dwa ukośniki, price. JSONPath: dolar kropka store, dwie kropki, price. Wynik: cena wszystkiego w sklepie, książek i roweru.

Piąta para, ważna pułapka. XPath: dwa ukośniki book, w nawiasie kwadratowym trzy. JSONPath: dolar, dwie kropki, book, w nawiasie kwadratowym dwa. Wynik: trzecia książka. Różnica wynika z tego, że XPath numeruje od jedynki, a JSONPath od zera. Trzecia książka to więc indeks trzy w XPath, ale dwa w JSONPath.

Szósta para. XPath: book, nawias, last, nawiasy okrągłe. JSONPath ma dwa zapisy: book, w nawiasie kwadratowym w nawiasie okrągłym małpa kropka length minus jeden, albo book, w nawiasie kwadratowym minus jeden dwukropek. Wynik: ostatnia książka. Małpa oznacza bieżący element, a minus jeden dwukropek to wycinek od ostatniego do końca.

Siódma para. XPath: book, w nawiasie position mniejsze od trzech. JSONPath: book w nawiasie zero przecinek jeden, albo book w nawiasie dwukropek dwa. Wynik: pierwsze dwie książki. Zapis dwukropek dwa to wycinek od początku do indeksu dwa, bez niego, czyli indeksy zero i jeden.

Ósma para. XPath: book w nawiasie isbn. JSONPath: dolar, dwie kropki, book, nawias kwadratowy, znak zapytania, w nawiasie okrągłym małpa kropka isbn. Wynik: wszystkie książki, które mają numer ISBN. Znak zapytania z nawiasem okrągłym to filtr, a małpa to aktualnie sprawdzany element.

Dziewiąta para. XPath: book w nawiasie price mniejsze od dziesięciu. JSONPath: dolar, dwie kropki, book, nawias kwadratowy, znak zapytania, nawias okrągły, małpa kropka price mniejsze od dziesięciu. Wynik: wszystkie książki tańsze niż dziesięć.

Dziesiąta para. XPath: dwa ukośniki gwiazdka. JSONPath: dolar, dwie kropki, gwiazdka. Wynik: wszystkie elementy w dokumencie XML, a w JSON wszyscy członkowie struktury.

Słowniczek symboli JSONPath: dolar to korzeń, kropka to dziecko, dwie kropki to zejście rekurencyjne, gwiazdka to wszystko, nawias kwadratowy z liczbą to indeks od zera, dwukropek w nawiasie to wycinek, znak zapytania z nawiasem okrągłym to filtr, a małpa to bieżący element.

Do zapamiętania na test: dolar to korzeń, dwie kropki to wyszukiwanie rekurencyjne, odpowiednik podwójnego ukośnika w XPath. JSONPath indeksuje od zera, XPath od jedynki, więc trzecia książka to $..book[2]. Ostatnia książka to $..book[-1:] albo $..book[(@.length-1)]. Pierwsze dwie to $..book[0,1] albo $..book[:2]. Filtr to [?(...)] z małpą jako bieżącym elementem, na przykład $..book[?(@.price<10)].

## 6.30. Indeksowanie danych: FT.CREATE

Teraz bardzo ważny temat: indeksowanie i zapytania, które zapewnia moduł wyszukiwania w Redis Stack, czyli RediSearch, nazywany dziś Redis Query Engine. Wszystkie jego polecenia mają prefiks FT, od full text.

Najpierw problem. Przestrzeń kluczy Redisa jest nieustrukturyzowana i płaska. Domyślnie do danych można dostać się tylko przez klucz podstawowy, czyli nazwę klucza, co bardzo utrudnia znalezienie dokumentu po cesze drugorzędnej, na przykład po cenie czy marce. Redis Stack wychodzi tej potrzebie naprzeciw, dając możliwość indeksowania danych i zadawania zapytań. Po określeniu, co chcemy indeksować, indeksowanie odbywa się automatycznie i synchronicznie przy zapisie nowych danych. Nie trzeba ręcznie odświeżać indeksu: każdy nowy klucz z pasującym prefiksem trafia do indeksu od razu. Gdy dane są zindeksowane, łatwo wykonać wyszukiwanie pełnotekstowe i filtrować według liczby, znacznika, czyli tagu, a nawet położenia geograficznego.

Pierwszy przykład to indeks na rowerach. Składnia, powoli. FT.CREATE, spacja, idx dwukropek bikes, czyli nazwa indeksu. Następnie ON JSON, czyli indeks na dokumentach JSON; domyślnie, bez tej klauzuli, indeks byłby na hashach, ON HASH. Następnie PREFIX jeden, w cudzysłowie bikes dwukropek. Jedynka to liczba prefiksów, które za chwilę wymienimy; indeksowane będą tylko klucze zaczynające się od bikes dwukropek. Następnie słowo SCHEMA, a po nim lista pól. Każde pole ma postać: ścieżka JSON, słowo AS, alias, typ i opcjonalne modyfikatory. Mamy tu: dolar kropka model AS model TEXT NOSTEM SORTABLE. Dolar kropka brand AS brand TEXT NOSTEM SORTABLE. Dolar kropka price AS price NUMERIC SORTABLE. Dolar kropka type AS type TAG. Dolar kropka specs kropka material AS material TAG. Dolar kropka specs kropka weight AS weight NUMERIC SORTABLE. I dolar kropka description as description TEXT.

Teraz typy pól, bo o nie test pyta najchętniej. TEXT to pole pełnotekstowe: tekst jest dzielony na słowa, a domyślnie słowa są sprowadzane do rdzenia, czyli stemowane, tak że zapytanie o bikes znajdzie także bike. NUMERIC to pole liczbowe, które pozwala na zapytania zakresowe, na przykład cena od dwustu do tysiąca dwustu. TAG to pole znacznika do dokładnego dopasowania całej wartości, bez dzielenia na słowa i bez stemowania, idealne dla kategorii, typów, miast. GEO to pole geograficzne z długością i szerokością, pozwalające pytać o punkty w promieniu. Modyfikatory: SORTABLE oznacza, że po tym polu można szybko sortować wyniki. NOSTEM wyłącza stemowanie, co ma sens dla nazw własnych, takich jak model i marka, które nie powinny być zmieniane. Alias po AS to nazwa, pod którą pole występuje w zapytaniach, z małpą, na przykład małpa price.

Kolejne polecenia administracyjne. FT podkreślnik LIST, zapisywane FT._LIST, zwraca listę wszystkich indeksów; w przykładzie odpowiedź to idx:bikes. FT.DROPINDEX idx:bikes usuwa indeks i zwraca OK. Ważne: domyślnie FT.DROPINDEX usuwa tylko indeks, a dokumenty zostają w bazie; żeby usunąć także dokumenty, dodaje się opcję DD. FT.INFO, a w cudzysłowie nazwa indeksu, na przykład idx:schools_json, wyświetla informacje o konkretnym indeksie: schemat, liczbę dokumentów i statystyki.

Do zapamiętania na test: FT.CREATE nazwa ON JSON PREFIX 1 "prefiks:" SCHEMA ścieżka AS alias TYP. Liczba po PREFIX to liczba prefiksów. Typy pól to TEXT do pełnego tekstu, NUMERIC do zakresów liczbowych, TAG do dokładnego dopasowania i GEO do położenia. SORTABLE pozwala sortować, NOSTEM wyłącza stemowanie. Indeksowanie jest automatyczne i synchroniczne. FT._LIST wypisuje indeksy, FT.INFO pokazuje szczegóły indeksu, FT.DROPINDEX usuwa indeks, ale bez DD nie usuwa dokumentów.

## 6.31. Indeks na szkołach: tablice, GEO i komentarze

Drugi przykład FT.CREATE jest opatrzony komentarzami, które dobrze tłumaczą każdy element. Tworzymy indeks idx dwukropek schools_json, ON JSON, czyli na danych JSON, z PREFIX jeden, w cudzysłowie school_json dwukropek, czyli prefiksem, który filtruje klucze. Potem SCHEMA, czyli definicja schematu indeksu.

Pola. Dolar kropka name AS name TEXT NOSORTABLE: indeksuje nazwę jako tekst, bez sortowania. Dolar kropka description AS description TEXT: opis jako tekst. Dolar kropka class AS class TAG: klasa szkoły jako tag, co pozwala na dokładne dopasowanie. Dolar kropka type, w nawiasie kwadratowym gwiazdka, AS type TAG: pole type jest tablicą, a zapis z gwiazdką sprawia, że każdy element tablicy jest traktowany jako osobny tag. Dzięki temu szkoła o typach, powiedzmy, publiczna i sportowa, zostanie znaleziona i przy zapytaniu o publiczne, i przy zapytaniu o sportowe. Dolar kropka address kropka city AS city TAG: miasto z zagnieżdżonego obiektu adresu jako tag. Dolar kropka address kropka street AS address TEXT NOSORTABLE: ulica jako tekst, bez sortowania, przydatna do wyszukiwania pełnotekstowego. Dolar kropka students AS students NUMERIC SORTABLE: liczba uczniów jako liczba, z możliwością sortowania. Dolar kropka location AS location GEO: położenie jako dane geograficzne, co pozwala na zapytania o zakres geograficzny, na przykład szkoły w promieniu pięciu kilometrów. I na koniec dolar kropka status_log kropka, w nawiasie minus jeden, AS status TAG: indeksuje ostatni element tablicy status_log jako tag, czyli aktualny status szkoły.

Dwie uwagi krytyczne. Po pierwsze, słowo NOSORTABLE nie występuje w dokumentacji FT.CREATE jako opcja; dokumentacja zna SORTABLE, NOSTEM i NOINDEX. Pole bez SORTABLE i tak nie jest sortowalne, więc intencja autora jest jasna: to pole nie ma być sortowalne. Na teście traktuj to zgodnie ze slajdem: TEXT NOSORTABLE oznacza tekst bez sortowania. Po drugie, w ścieżce ostatniego elementu na slajdzie jest kropka przed nawiasem, status_log kropka nawias minus jeden; w zwykłym zapisie JSONPath, który widzieliśmy przy JSON.GET, pisze się bez tej kropki, status_log, nawias, minus jeden. Znaczenie jest to samo: ostatni element tablicy. I jak poprzednio, komentarze po dwóch ukośnikach są tylko objaśnieniem dla czytelnika.

Do zapamiętania na test: $.type[*] AS type TAG indeksuje każdy element tablicy jako osobny tag. GEO pozwala na zapytania o zakres geograficzny. NUMERIC SORTABLE pozwala na zakresy i sortowanie. Ostatni element tablicy wskazuje indeks minus jeden. TAG służy do dokładnego dopasowania, TEXT do wyszukiwania pełnotekstowego.

## 6.32. Zapytania FT.SEARCH

Slajd z trzema przykładami zapytań, nazwanymi Query by type, Search by category and price i Even more search parameters.

Pierwsze: FT.SEARCH idx:bikes, a potem w cudzysłowie: małpa type dwukropek, nawias klamrowy, eBikes, nawias klamrowy zamykający. Składnia zapytania jest taka: małpa i alias pola, dwukropek, a potem warunek. Dla pola TAG wartość zawsze stoi w nawiasach klamrowych. Zapytanie zwraca wszystkie rowery typu eBikes, a w wyniku dostajemy nazwę klucza i cały dokument JSON pod ścieżką dolar. Na zrzucie widać trzy rowery, na przykład model Mercury marki BikeStreet z typem eBikes.

Drugie: FT.SEARCH idx:bikes, w cudzysłowie: małpa type dwukropek, w klamrach eBikes, spacja, małpa price dwukropek, w nawiasie kwadratowym dwieście spacja tysiąc dwieście. Dla pola NUMERIC zakres zapisujemy w nawiasach kwadratowych: minimum, spacja, maksimum, przy czym oba końce są domyślnie włączone. Spacja między warunkami oznacza logiczne AND, czyli oba warunki muszą być spełnione naraz. Dalej jest klauzula RETURN dziewięć, a po niej: dolar kropka model AS model, dolar kropka type AS type, dolar kropka price AS price. RETURN ogranicza zwracane pola do wymienionych, zamiast całego dokumentu. Liczba dziewięć to nie liczba pól, tylko liczba argumentów, które po niej następują. Policzmy: dolar kropka model, AS, model to trzy; dolar kropka type, AS, type to kolejne trzy; dolar kropka price, AS, price to kolejne trzy. Razem dziewięć. To typowa pułapka testowa: trzy pola z aliasami to dziewięć argumentów, a trzy pola bez aliasów to byłoby RETURN trzy. Wynik ma kolumny model, type i price, a na zrzucie są dwa rowery typu eBikes.

Trzecie: FT.SEARCH idx:bikes, w cudzysłowie: mudguards, spacja, małpa type dwukropek, w klamrach Mountain bikes, spacja, małpa price dwukropek, w nawiasie kwadratowym tysiąc spacja trzy tysiące. Potem RETURN dwanaście i cztery pola z aliasami: model, type, price i description. Cztery razy trzy daje dwanaście. Słowo mudguards bez małpy i bez nazwy pola to wyszukiwanie pełnotekstowe we wszystkich polach typu TEXT, czyli tu w modelu, marce i opisie. Mudguards to po angielsku błotniki, więc szukamy rowerów górskich w cenie od tysiąca do trzech tysięcy, w których opisie występują błotniki. Zauważ, że tag Mountain bikes zawiera spację, a w klamrach mimo to traktowany jest jako jedna wartość, bo tagi dopasowujemy w całości.

Do zapamiętania na test: FT.SEARCH indeks "zapytanie". Pole TAG odpytujemy w klamrach, @type:{eBikes}. Pole NUMERIC odpytujemy zakresem w nawiasach kwadratowych, @price:[200 1200]. Słowo bez nazwy pola przeszukuje wszystkie pola TEXT. Spacja między warunkami to AND. RETURN podaje liczbę argumentów, a nie pól, więc trzy pola z AS to RETURN 9, a cztery to RETURN 12.

## 6.33. Agregacje FT.AGGREGATE

Slajd „Aggregate search” z trzema przykładami: liczba rowerów w kategorii, średnia waga roweru w kategorii i rowery w przedziałach wagi. FT.AGGREGATE to odpowiednik GROUP BY z SQL albo potoku agregacji z MongoDB: wyniki zapytania przechodzą przez kolejne kroki przetwarzania.

Przykład pierwszy. FT.AGGREGATE idx:bikes, w cudzysłowie małpa price dwukropek, w nawiasie kwadratowym tysiąc spacja trzy tysiące. Następnie GROUPBY jeden małpa type. Następnie REDUCE COUNT zero AS count. Następnie SORTBY dwa małpa count, w cudzysłowie DESC. Czytamy to tak: weź rowery w cenie od tysiąca do trzech tysięcy, pogrupuj je po typie, w każdej grupie policz liczbę dokumentów i nazwij ją count, a potem posortuj malejąco po count. Liczby w składni to znowu liczby argumentów. GROUPBY jeden, bo grupujemy po jednej właściwości. COUNT zero, bo funkcja COUNT nie przyjmuje argumentów, liczy po prostu wiersze. SORTBY dwa, bo po nim są dwa argumenty: małpa count i DESC.

Przykład drugi. FT.AGGREGATE idx:bikes, w cudzysłowie gwiazdka. Gwiazdka oznacza wszystkie dokumenty, bez filtra. GROUPBY jeden małpa type. REDUCE AVG jeden małpa weight AS average_bike_weight. SORTBY dwa małpa average_bike_weight DESC. Czyli średnia waga roweru w każdej kategorii, od najcięższej. AVG jeden, bo funkcja średniej przyjmuje jeden argument: pole, z którego liczy średnią. Inne funkcje REDUCE to między innymi SUM, MIN, MAX i COUNT_DISTINCT.

Przykład trzeci. FT.AGGREGATE idx:bikes, gwiazdka. APPLY, w cudzysłowie floor, w nawiasie małpa weight, AS weight. GROUPBY jeden małpa weight. REDUCE count zero AS count. SORTBY jeden małpa weight. APPLY oblicza nowe wyrażenie dla każdego dokumentu; floor zaokrągla wagę w dół do liczby całkowitej, więc rowery o wadze osiem i siedem dziesiątych oraz osiem i jedna dziesiąta trafią do przedziału osiem. Potem grupujemy po zaokrąglonej wadze i liczymy rowery w każdym przedziale. SORTBY jeden małpa weight, czyli sortowanie po jednym argumencie, bez podania kierunku, więc domyślnie rosnąco. Zwróć uwagę, że nazwa funkcji redukującej jest tu napisana małymi literami, count; wielkość liter nie ma znaczenia w słowach kluczowych.

Do zapamiętania na test: FT.AGGREGATE indeks "zapytanie", gwiazdka oznacza wszystkie dokumenty. GROUPBY nargs @pole grupuje. REDUCE funkcja nargs argumenty AS nazwa liczy agregat: COUNT 0, AVG 1 @weight. SORTBY nargs @pole DESC sortuje, a bez kierunku sortuje rosnąco. APPLY "wyrażenie" AS nazwa liczy nowe pole, na przykład floor(@weight). Liczby po GROUPBY, REDUCE i SORTBY oznaczają liczbę argumentów.

## 6.34. Transakcje w Redisie

Slajd o transakcjach. Transakcja pozwala wykonać grupę poleceń w jednym kroku. Właściwości według slajdu: wszystkie polecenia są wykonywane sekwencyjnie i są izolowane, czyli w trakcie wykonywania transakcji żaden inny klient nie wciśnie się ze swoim poleceniem pomiędzy. Transakcja jest atomowa: albo wszystkie polecenia zostaną wykonane, albo żadne.

Jak to działa? Rozpoczęcie: MULTI. Następnie dodajemy polecenia do transakcji. Wykonanie: EXEC. Przykład ze slajdu: MULTI, potem SET user dwukropek jeden Jan, potem SET user dwukropek dwa Anna, a na końcu EXEC. Po MULTI serwer odpowiada OK, a po każdym kolejnym poleceniu odpowiada słowem QUEUED, czyli zakolejkowano. Polecenia nie są jeszcze wykonywane, tylko odkładane. Dopiero EXEC wykonuje je wszystkie naraz i zwraca listę wyników, po jednym na polecenie.

Tabela poleceń transakcyjnych. DISCARD odrzuca wszystkie polecenia wydane po MULTI, czyli anuluje transakcję przed wykonaniem. EXEC wykonuje wszystkie polecenia wydane po MULTI. MULTI oznacza początek bloku transakcji. WATCH klucz, opcjonalnie kolejne klucze, obserwuje podane klucze w celu warunkowego wykonania bloku MULTI EXEC. UNWATCH zapomina o wszystkich obserwowanych kluczach.

WATCH wymaga wyjaśnienia, bo to mechanizm optymistycznego blokowania. Robimy WATCH na kluczu, odczytujemy jego wartość, potem MULTI, polecenia i EXEC. Jeśli między WATCH a EXEC ktoś inny zmienił obserwowany klucz, EXEC nie wykona niczego i zwróci nil, czyli transakcja zostanie przerwana. Klient może wtedy spróbować od nowa. To podejście optymistyczne, bo nie blokujemy klucza z góry, tylko sprawdzamy na końcu, czy nikt nam w nim nie namieszał. Po EXEC albo DISCARD obserwacja kluczy jest zdejmowana automatycznie.

Teraz ważne uzupełnienie, które może pojawić się jako pytanie podchwytliwe. Hasło „albo wszystkie, albo żadne” jest prawdziwe w tym sensie, że polecenia wykonują się razem, bez przeplatania z innymi klientami, a błąd przed EXEC, na przykład błąd składni w zakolejkowanym poleceniu, sprawia, że EXEC odrzuca całą transakcję. Ale Redis nie ma wycofywania, czyli rollbacku, znanego z baz relacyjnych. Jeśli polecenie zakolejkowało się poprawnie, a wywaliło się dopiero w czasie wykonania, na przykład INCR na kluczu z tekstem, to pozostałe polecenia transakcji i tak się wykonają, a te już wykonane nie zostaną cofnięte. Na teście, przy pytaniu wprost o slajd, odpowiadaj zgodnie ze slajdem: transakcja jest atomowa, wszystko albo nic. Ale jeśli pytanie dotyczy rollbacku, pamiętaj, że Redis go nie oferuje.

Do zapamiętania na test: MULTI rozpoczyna transakcję, polecenia są kolejkowane z odpowiedzią QUEUED, EXEC je wykonuje, DISCARD je odrzuca. WATCH obserwuje klucze i przerywa EXEC, jeśli ktoś je zmienił, co jest optymistycznym blokowaniem; UNWATCH zdejmuje obserwację. Polecenia transakcji wykonują się sekwencyjnie i w izolacji. Redis nie robi rollbacku błędów powstałych w czasie wykonania.

## 6.35. Nowe funkcje Redis Stack

Ostatni merytoryczny slajd działu opisuje dwie nowe funkcje Redis Stack. Opowiem tabelę zdaniami.

Pierwsza funkcja to Vector Similarity Search, czyli wyszukiwanie podobieństwa wektorów. Służy do wyszukiwania w danych nieustrukturyzowanych, takich jak tekst i obrazy. Jak to działa? Model uczenia maszynowego zamienia tekst albo obraz na wektor liczb, tak zwany embedding, w taki sposób, że rzeczy podobne znaczeniowo mają wektory leżące blisko siebie. Redis przechowuje te wektory i potrafi szybko znaleźć wektory najbliższe zadanemu. Slajd mówi, że obsługiwane są hashe i JSON, czyli wektor może być polem hasha albo dokumentu JSON, oraz dwa algorytmy: HNSW i brute-force. HNSW to Hierarchical Navigable Small World, algorytm przybliżony, bardzo szybki na dużych zbiorach, oparty na wielopoziomowym grafie sąsiedztwa. Brute-force, w Redisie oznaczany jako FLAT, porównuje zapytanie z każdym wektorem, więc jest dokładny, ale wolniejszy przy dużej liczbie danych. Zastosowania: wyszukiwanie semantyczne, czyli po znaczeniu, a nie po dokładnych słowach, rekomendacje oraz sztuczna inteligencja: RAG, NLP i CV. RAG to Retrieval-Augmented Generation, czyli wzbogacanie odpowiedzi modelu językowego o fragmenty dokumentów znalezione wyszukiwaniem wektorowym. NLP to przetwarzanie języka naturalnego, a CV to computer vision, czyli widzenie komputerowe.

Druga funkcja to Redis for Time Series, czyli natywna struktura danych dla szeregów czasowych. Szereg czasowy to ciąg pomiarów z sygnaturami czasu, na przykład temperatura co sekundę. Slajd wymienia obsługę agregacji, na przykład średniej z każdej minuty, etykiet, czyli labels, po których można filtrować szeregi, kompaktowania danych, czyli automatycznego zastępowania starych, gęstych danych rzadszymi agregatami, żeby oszczędzać pamięć, oraz integrację z Prometheusem i Grafaną, popularnymi narzędziami do monitoringu i wizualizacji. Zastosowania: monitoring IoT, analiza metryk systemowych oraz dane finansowe w czasie rzeczywistym. W przeglądarce Redis Stack typ ten widzieliśmy na liście filtrów jako TS.

Ostatni slajd działu jest pusty.

Do zapamiętania na test: Vector Similarity Search wyszukuje podobne wektory w danych nieustrukturyzowanych, działa na hashach i JSON, używa algorytmów HNSW i brute-force, a zastosowania to wyszukiwanie semantyczne, rekomendacje i AI, czyli RAG, NLP i CV. Redis for Time Series to natywna struktura szeregów czasowych z agregacją, etykietami, kompaktowaniem i integracją z Prometheusem i Grafaną, używana do monitoringu IoT, metryk systemowych i danych finansowych.


# 7. Bazy grafowe — Neo4j i SQL Server Graph

W tym dziale zajmiemy się czwartą wielką rodziną baz NoSQL, czyli bazami grafowymi. Najpierw poznasz sam model danych: graf złożony z węzłów i krawędzi, które mogą mieć właściwości. Potem omówimy dwa typy baz grafowych, czyli transakcyjne i analityczne, typowe zastosowania, rodzaje zapytań i sytuacje, w których bazy grafowej lepiej nie używać. Następnie przejdziemy do najpopularniejszego przedstawiciela tej rodziny, czyli Neo4j, i jego języka zapytań Cypher. Nauczysz się, jak w Cypherze tworzy się węzły i relacje, jak się je wyszukuje, aktualizuje i usuwa. Druga połowa działu dotyczy czegoś, co często zaskakuje na teście: grafów w klasycznej, relacyjnej bazie Microsoft SQL Server. Poznasz tabele węzłów i krawędzi, tworzone klauzulami AS NODE i AS EDGE, pseudokolumny dolar node underscore id, dolar edge underscore id, dolar from underscore id i dolar to underscore id, predykat MATCH, pełny przykład z osobami, restauracjami i miastami, listę ograniczeń, porównanie MATCH z klasycznymi złączeniami JOIN, a na koniec przykład systemu rekomendacji utworów muzycznych. Zaczynajmy.

## 7.1. Model danych grafowych

Wyobraź sobie kartkę papieru, na której rysujesz kółka i łączysz je strzałkami. Kółka to ludzie, firmy, produkty, miasta. Strzałki mówią, kto kogo zna, kto co kupił, kto gdzie mieszka. To jest dokładnie model danych bazy grafowej. Wykład definiuje go tak: graf to skierowana albo nieskierowana kolekcja węzłów, które reprezentują encje, oraz krawędzi, które reprezentują relacje między tymi encjami.

Zatrzymajmy się przy słowach. Węzeł, po angielsku node, a w polskiej literaturze często też wierzchołek, to obiekt, czyli encja. Może to być osoba, produkt, konto bankowe albo miasto. Krawędź, po angielsku edge, a w świecie Neo4j zwykle nazywana relacją, czyli relationship, to połączenie między dwoma węzłami. W grafie skierowanym krawędź ma kierunek: biegnie od jednego węzła do drugiego, tak jak relacja „Jan zna Annę” nie musi oznaczać, że Anna zna Jana. W grafie nieskierowanym krawędź jest symetryczna, na przykład „Jan i Anna są sąsiadami”.

Najważniejsza cecha tego modelu, którą slajd podkreśla osobno: zarówno węzły, jak i krawędzie mogą posiadać dowolne właściwości, czyli atrybuty. To się nazywa model grafu z właściwościami, po angielsku property graph. Węzeł osoby może mieć imię i wiek, a krawędź „zna” może mieć datę, od kiedy dwie osoby się znają. To odróżnia bazę grafową od prostego rysunku grafu w matematyce, gdzie krawędź jest tylko połączeniem bez żadnych danych. Tutaj relacja jest pełnoprawnym obiektem z własnymi danymi.

Dlaczego to jest takie ważne? W bazie relacyjnej relacja między dwiema tabelami nie jest zapisana fizycznie jako obiekt. Jest wyliczana w momencie zapytania przez złączenie, czyli JOIN, które porównuje klucz obcy z kluczem głównym. Im więcej poziomów powiązań, tym więcej złączeń i tym wolniejsze zapytanie. W bazie grafowej relacja jest przechowywana bezpośrednio, a przejście z węzła do sąsiada polega na podążeniu za wskaźnikiem. To przechodzenie po grafie nazywamy trawersowaniem, po angielsku traversal. Analogia: w bazie relacyjnej, żeby znaleźć znajomych znajomych, przeglądasz za każdym razem cały spis telefonów. W bazie grafowej każda osoba ma w kieszeni listę swoich znajomych i po prostu podaje ci ją dalej.

### Dwa typy baz grafowych

Wykład dzieli bazy grafowe na dwa typy. Pierwszy to bazy transakcyjne, oznaczane skrótem OLTP, od Online Transaction Processing. Charakteryzuje je duża liczba małych lub średnich grafów. Typowe operacje są krótkie: dodaj węzeł, dodaj relację, pobierz sąsiadów konkretnego użytkownika. Drugi typ to bazy analityczne, oznaczane skrótem OLAP, od Online Analytical Processing. Tu sytuacja jest odwrotna: mała liczba bardzo dużych grafów, na których wykonuje się ciężkie obliczenia, na przykład analizę całej sieci, wyszukiwanie społeczności czy algorytm PageRank.

Uważaj, bo na teście łatwo to odwrócić. Zapamiętaj prosty schemat: OLTP to dużo małych, OLAP to mało dużych. Transakcje są małe i liczne, analizy są nieliczne, ale ogromne.

### Kiedy używać bazy grafowej

Slajd wymienia sześć typowych zastosowań. Pierwsze to sieci społecznościowe, bo tam z natury chodzi o to, kto jest powiązany z kim. Drugie to silniki rekomendacyjne: ludzie, którzy kupili to samo co ty, kupili też coś innego, więc to coś warto ci polecić. Trzecie to grafy wiedzy, po angielsku Knowledge Graphs, czyli sieci pojęć i faktów połączonych relacjami, takie jak te, którymi wyszukiwarki wzbogacają wyniki. Czwarte to wykrywanie oszustw: oszust często ukrywa się za siecią kont, adresów i telefonów, i dopiero patrząc na powiązania widać, że pięć niby niezależnych kont korzysta z tego samego urządzenia. Piąte to systemy nawigacyjne, bo mapa drogowa jest grafem: skrzyżowania to węzły, a odcinki dróg to krawędzie z właściwością długości lub czasu przejazdu. Szóste to analiza zależności, na przykład zależności między pakietami oprogramowania, modułami systemu albo elementami infrastruktury.

### Jakie zapytania wykonuje się w bazie grafowej

Wykład wymienia pięć rodzajów zapytań. Po pierwsze podstawowe operacje modyfikujące: dodaj, zmień albo usuń węzeł lub krawędź. Po drugie wyszukiwanie najkrótszej ścieżki, na przykład najkrótszej trasy z miasta A do miasta B albo najkrótszego łańcucha znajomości między dwiema osobami. Po trzecie analiza relacji i zależności, czyli pytanie, jak coś jest z czymś powiązane. Po czwarte zapytania do podgrafów i nadgrafów, czyli wycinanie fragmentu grafu spełniającego jakiś wzorzec albo patrzenie na graf szerzej. Po piąte wyszukiwanie podobnych obiektów, na przykład użytkowników o podobnych upodobaniach, co jest podstawą rekomendacji.

### Kiedy nie używać bazy grafowej

Tu slajd jest krótki i warto go zrozumieć, a nie tylko zapamiętać. Pierwszy punkt mówi: nie używaj bazy grafowej, gdy operacje dotyczą wielu węzłów bądź krawędzi naraz. Chodzi o operacje masowe, takie jak „zaktualizuj cenę wszystkich produktów” albo „policz sumę sprzedaży we wszystkich zamówieniach”. Baza grafowa jest szybka, gdy startuje z kilku punktów i podąża po relacjach. Gdy trzeba przejrzeć wszystko jak leci, nie ma przewagi, a często jest wolniejsza od bazy relacyjnej czy kolumnowej. Drugi punkt mówi: nie używaj jej przy bardzo dużych, złożonych grafach w dużej liczbie. Grafy trudno dzielić między serwery, bo każde cięcie grafu przecina krawędzie, a przejście przez taką przeciętą krawędź oznacza komunikację sieciową. Dlatego skalowanie poziome, czyli sharding, jest w bazach grafowych znacznie trudniejsze niż w bazach klucz–wartość czy dokumentowych.

### Przedstawiciele

Na slajdzie widnieją logotypy czterech systemów. Neo4j, najpopularniejsza baza grafowa i główny bohater tego działu. ArangoDB, baza wielomodelowa, która łączy model dokumentowy, klucz–wartość i grafowy. OrientDB, również baza wielomodelowa, łącząca dokumenty i grafy. JanusGraph, rozproszona baza grafowa typu open source, która przechowuje dane w zewnętrznych systemach, takich jak Cassandra czy HBase, i używa języka Gremlin.

### Ranking DB-Engines

Kolejny slajd pokazuje wykres z serwisu DB-Engines, ranking systemów grafowych w latach od dwa tysiące czternastego do dwa tysiące dwudziestego czwartego, ze stanem na październik dwa tysiące dwudziestego piątego. Oś pionowa ma skalę logarytmiczną, czyli każdy kolejny poziom to wartość dziesięć razy większa. Na samej górze, przez cały okres, jest Neo4j. Tuż pod nim znajduje się Microsoft Azure Cosmos DB, wielomodelowa usługa chmurowa Microsoftu, która udostępnia między innymi interfejs grafowy oparty na Gremlinie. Pozostałe systemy są znacznie niżej. W legendzie pojawiają się między innymi Aerospike, ArangoDB, Virtuoso, OrientDB, NebulaGraph, GraphDB, Amazon Neptune, czyli grafowa usługa chmurowa Amazona, Memgraph, JanusGraph, TigerGraph, Stardog, Fauna, Dgraph, SurrealDB, Giraph, Blazegraph, AllegroGraph, TypeDB, Graph Engine, Fluree, RDFox, InfiniteGraph, FalkorDB i AnzoGraph DB. Nie musisz pamiętać całej listy. Zapamiętaj, że liderem jest Neo4j, a drugie miejsce zajmuje Azure Cosmos DB. Ponieważ skala jest logarytmiczna, przewaga Neo4j nad resztą jest w rzeczywistości dużo większa, niż wygląda na pierwszy rzut oka.

Do zapamiętania na test: graf to skierowana lub nieskierowana kolekcja węzłów, które reprezentują encje, i krawędzi, które reprezentują relacje, a właściwości mogą mieć zarówno węzły, jak i krawędzie. Bazy transakcyjne OLTP to duża liczba małych lub średnich grafów, a analityczne OLAP to mała liczba bardzo dużych grafów. Zastosowania to sieci społecznościowe, rekomendacje, grafy wiedzy, wykrywanie oszustw, nawigacja i analiza zależności. Typowe zapytania to modyfikacje węzłów i krawędzi, najkrótsza ścieżka, analiza relacji, podgrafy i nadgrafy oraz wyszukiwanie podobnych obiektów. Nie używamy bazy grafowej do operacji na wielu węzłach naraz ani do bardzo wielu ogromnych, złożonych grafów. Przedstawiciele to Neo4j, ArangoDB, OrientDB i JanusGraph, a w rankingu DB-Engines prowadzi Neo4j, przed Azure Cosmos DB.

## 7.2. Neo4j — natywna baza grafowa

Przejdźmy do Neo4j. Wykład poświęca mu dużą infografikę z dziewięcioma panelami i dwa slajdy tekstowe. Omówimy je po kolei.

### Czym jest Neo4j i jak działa

Neo4j to natywna baza grafowa. Słowo „natywna” jest tu kluczowe. Oznacza, że graf nie jest symulowany na tabelach ani dokumentach, tylko silnik od samego dołu, łącznie ze sposobem zapisu na dysku, jest zaprojektowany do przechowywania węzłów i relacji. Każdy węzeł przechowuje bezpośrednie odwołania do swoich relacji, więc przejście do sąsiada nie wymaga przeszukiwania indeksu. Ta cecha bywa nazywana bezindeksową sąsiedzkością, po angielsku index-free adjacency. Dla porównania SQL Server, który omówimy w drugiej części działu, buduje graf na zwykłych tabelach relacyjnych, więc nie jest natywną bazą grafową.

Infografika mówi, że Neo4j przechowuje dane w postaci węzłów, relacji i etykiet, i że został zaprojektowany do efektywnego zarządzania danymi o złożonych powiązaniach między obiektami. Jest idealny do analizowania relacji i znajdowania ukrytych zależności w danych. Podtytuł infografiki nazywa go bazą danych dla danych połączonych i złożonych relacji, a logo ma hasło „Graph Database for Tomorrow”.

W Neo4j poznajesz cztery podstawowe pojęcia. Węzeł, czyli obiekt. Relacja, czyli skierowane połączenie dwóch węzłów, które zawsze ma typ, na przykład ZNA, KUPIŁ albo LIVES_IN. Etykieta, po angielsku label, która mówi, do jakiej kategorii należy węzeł, na przykład Osoba, Produkt albo Klient; węzeł może mieć kilka etykiet naraz. I wreszcie właściwości, czyli pary klucz–wartość przypięte do węzłów i relacji. Diagram na infografice pokazuje dwa węzły typu Osoba połączone strzałką z napisem ZNA oraz zapis etykiety z właściwością: dwukropek Osoba, a w nawiasie name, dwukropek, Jan w cudzysłowie. Podpis mówi, że dane są przechowywane jako graf, czyli węzły połączone relacjami, które mogą mieć kierunek i właściwości.

Mała, ale ważna uwaga: w Neo4j każda relacja jest zapisana z kierunkiem. W zapytaniu możesz jednak ten kierunek zignorować, pisząc relację bez grotu strzałki, i wtedy Neo4j dopasuje ją w obie strony.

### Język Cypher

Neo4j używa języka zapytań Cypher. Slajd tekstowy opisuje go jako język podobny do SQL, ale dostosowany do pracy z grafami. Podobieństwo widać w słowach kluczowych: jest WHERE, jest RETURN pełniący rolę SELECT, jest ORDER BY, LIMIT, są funkcje agregujące. Różnica polega na tym, że zamiast wymieniać tabele i łączyć je JOIN-ami, rysujesz wzorzec grafu za pomocą znaków ASCII. Cypher bywa dlatego nazywany językiem ASCII-artu.

Zasady rysowania są proste i warto je mieć w uchu. Węzeł zapisujemy w nawiasach okrągłych. W środku może stać zmienna, czyli alias, potem dwukropek i etykieta, a potem w nawiasach klamrowych właściwości. Na przykład: nawias okrągły, litera n, dwukropek, Person, klamra, name, dwukropek, John w cudzysłowie, zamknięcie klamry i nawiasu. Relację zapisujemy w nawiasach kwadratowych, wstawionych między myślniki, a kierunek pokazuje grot strzałki, czyli znak większości na końcu albo znak mniejszości na początku. Na przykład: myślnik, nawias kwadratowy, dwukropek, FRIEND, zamknięcie nawiasu kwadratowego, myślnik i znak większości. To jest strzałka w prawo z relacją typu FRIEND. Relacja też może mieć zmienną, na przykład r dwukropek ZNA, i wtedy można się do niej odwołać w WHERE albo RETURN. Zapamiętaj: nawiasy okrągłe to węzły, nawiasy kwadratowe to relacje, dwukropek wprowadza etykietę węzła albo typ relacji, a klamry to właściwości.

### Przykład danych w Neo4j z infografiki

Trzeci panel infografiki pokazuje pierwszy przykład w Cypherze. Najpierw komentarz, zaczynający się od dwóch ukośników, jak w C czy Javie: tworzenie węzłów i relacji. Potem trzy polecenia. Pierwsze: CREATE, w nawiasie a dwukropek Osoba, a w klamrach imie Jan i nazwisko Kowalski. Drugie: CREATE, w nawiasie b dwukropek Osoba, w klamrach imie Anna i nazwisko Nowak. Trzecie: CREATE, nawias a, myślnik, nawias kwadratowy z dwukropkiem ZNA i właściwością od underscore kiedy równą dwa tysiące dwadzieścia, myślnik, znak większości, nawias b. Czyli tworzymy dwie osoby i skierowaną relację ZNA od Jana do Anny, a ta relacja ma właściwość od_kiedy z wartością dwa tysiące dwadzieścia. Ważne: zmienne a i b są widoczne tylko w obrębie jednego zapytania. Te trzy linie działają, bo są wykonywane razem jako jedno zapytanie.

Dalej komentarz: wyszukiwanie znajomych Jana. MATCH, nawias a dwukropek Osoba, w klamrach imie Jan, myślnik, kwadratowy nawias z dwukropkiem ZNA, myślnik, strzałka, nawias b. Potem RETURN b kropka imie, b kropka nazwisko, b kropka od_kiedy. I tu jest błąd na slajdzie, na który warto zwrócić uwagę. Właściwość od_kiedy należy do relacji ZNA, a nie do węzła b. Zapis b kropka od_kiedy zwróci więc wartość null, bo osoba Anna takiej właściwości nie ma. Poprawnie trzeba nadać relacji zmienną, na przykład r, czyli napisać w nawiasie kwadratowym r dwukropek ZNA, i zwrócić r kropka od_kiedy. Ten błąd dobrze ilustruje zasadę: właściwość czytasz z tego elementu, na którym ją zapisano.

### Najważniejsze cechy Neo4j

Czwarty panel wymienia pięć cech. Model grafowy: dane jako węzły, relacje i właściwości. Wysoka wydajność zapytań: szybkie trawersowanie relacji, bo przejście do sąsiada to podążenie za wskaźnikiem, a nie złączenie tabel. Skalowalność: obsługa dużych grafów i rosnących danych. Zaawansowana analiza relacji: łatwe wykrywanie wzorców i zestawień. Bogate możliwości zastosowań: od rekomendacji po wykrywanie oszustw.

### Przykładowe operacje z infografiki

Piąty panel pokazuje trzy grupy operacji na przykładzie sklepu internetowego.

Dodawanie danych. CREATE, nawias p dwukropek Produkt, w klamrach nazwa Laptop i cena trzy tysiące pięćset. Następnie CREATE, nawias k dwukropek Klient, w klamrach imie Anna. I trzecie: CREATE, nawias k, myślnik, kwadratowy nawias z dwukropkiem KUPIŁ i właściwością data równą wywołaniu funkcji date z pustymi nawiasami, myślnik, strzałka, nawias p. Funkcja date bez argumentów zwraca dzisiejszą datę. Czyli mamy produkt, klientkę Annę i relację KUPIŁ z datą zakupu. Znowu widzisz, że relacja niesie własne dane.

Wyszukiwanie danych. MATCH, nawias k dwukropek Klient, myślnik, kwadratowy nawias dwukropek KUPIŁ, myślnik, strzałka, nawias p dwukropek Produkt. Potem WHERE k kropka imie równa się Anna. I RETURN p kropka nazwa, p kropka cena. To zapytanie znaczy: znajdź wszystkie produkty kupione przez klienta o imieniu Anna i zwróć ich nazwy i ceny. Warunek na imię można zapisać na dwa sposoby: albo w klamrach wewnątrz wzorca, albo w osobnej klauzuli WHERE. Efekt jest ten sam.

Aktualizacja danych. MATCH, nawias p dwukropek Produkt, w klamrach nazwa Laptop. Potem SET p kropka cena równa się trzy tysiące dwieście. I RETURN p. Czyli najpierw znajdujemy węzeł, potem zmieniamy jego właściwość klauzulą SET, a na końcu zwracamy zmieniony węzeł. To typowy schemat w Cypherze: najpierw MATCH, potem operacja.

### Zastosowania Neo4j

Szósty panel wymienia osiem zastosowań: systemy rekomendacji, analiza sieci społecznościowych, wykrywanie oszustw, zarządzanie danymi powiązanymi, wyszukiwanie i eksploracja relacji, zarządzanie wiedzą i dokumentacją, analityka i business intelligence oraz Internet rzeczy, czyli IoT. Slajd tekstowy opisuje trzy zastosowania baz grafowych dokładniej. Sieci społeczne: reprezentowanie użytkowników i ich połączeń. Rekomendacje: systemy rekomendacyjne, na przykład takie, jakie mają Netflix czy Amazon. Analiza oszustw: wykrywanie oszustw finansowych poprzez analizę nieoczywistych połączeń. Ten ostatni opis jest celny: oszustwo widać nie w pojedynczym rekordzie, ale w nieoczekiwanym powiązaniu.

### Neo4j a bazy relacyjne

Siódmy panel porównuje Neo4j z bazami relacyjnymi w pięciu cechach. Opowiem je kolejno.

Model danych: w Neo4j to graf, czyli węzły i relacje, a w bazach relacyjnych tabele. Połączenia między danymi: w Neo4j są naturalne i szybkie, a w bazach relacyjnych złożone, bo wymagają JOIN-ów. Wydajność zapytań o relacje: w Neo4j bardzo wysoka, a w bazach relacyjnych zależna od złożoności, czyli od liczby złączeń i rozmiaru tabel. Skalowanie: według slajdu Neo4j skaluje się poziomo, a bazy relacyjne głównie pionowo. Najlepsze zastosowania: Neo4j to złożone relacje i analityka, bazy relacyjne to dane transakcyjne.

Przy skalowaniu dodam uczciwą uwagę. Na teście odpowiadaj zgodnie ze slajdem: Neo4j poziomo, relacyjne głównie pionowo. W praktyce sprawa jest bardziej złożona. Neo4j w klastrze łatwo skaluje odczyty poziomo, dokładając kopie, ale zapisy i dzielenie jednego grafu na wiele serwerów są trudne, z powodu, o którym mówiliśmy przy slajdzie ogólnym: cięcie grafu przecina krawędzie. Dlatego pierwszy slajd działu ostrzegał przed bardzo dużymi grafami w dużej liczbie.

### Wady i ograniczenia Neo4j

Ósmy panel wymienia cztery wady. Neo4j nie jest optymalny do prostych danych tabelarycznych; jeśli twoje dane to po prostu lista faktur bez złożonych powiązań, baza relacyjna zrobi to lepiej i taniej. Ma wyższe wymagania sprzętowe przy bardzo dużych grafach, bo dla szybkiego trawersowania graf powinien mieścić się w pamięci operacyjnej. Jest mniej odpowiedni do transakcji masowych niż tradycyjne bazy relacyjne, co zgadza się z ogólną zasadą, że baza grafowa nie lubi operacji na wszystkich węzłach naraz. I wreszcie wymaga nauki języka Cypher i innego podejścia do modelowania danych, czyli myślenia w kategoriach węzłów i relacji zamiast tabel i kluczy obcych.

### Podsumowanie infografiki

Dziewiąty panel podsumowuje: Neo4j umożliwia efektywne zarządzanie danymi połączonymi i złożonymi relacjami, zapewnia wysoką wydajność zapytań i łatwą analizę grafu, świetnie sprawdza się w nowoczesnych aplikacjach wykorzystujących dane powiązane i jest jednym z najpopularniejszych rozwiązań baz grafowych na świecie. Stopka głosi: Neo4j, odkryj siłę połączeń, dane zyskują wartość, gdy widać ich relacje, oraz hasło Connect, Discover, Build.

Slajd tekstowy powtarza te myśli: Neo4j to jedna z najpopularniejszych baz grafowych, umożliwia przechowywanie danych w formie grafów i jest zoptymalizowana pod kątem przechowywania dużych zbiorów danych z wieloma relacjami.

Do zapamiętania na test: Neo4j to natywna baza grafowa, która przechowuje węzły, relacje, etykiety i właściwości, i używa języka Cypher, podobnego do SQL, ale dostosowanego do grafów. W Cypherze węzły piszemy w nawiasach okrągłych, relacje w kwadratowych między myślnikami, kierunek grotem strzałki, etykietę i typ po dwukropku, właściwości w klamrach. CREATE tworzy, MATCH wyszukuje wzorzec, WHERE filtruje, RETURN zwraca, SET aktualizuje. Właściwość relacji odczytujesz przez zmienną relacji, a nie węzła, co pokazuje błąd b kropka od_kiedy na slajdzie. W porównaniu z bazami relacyjnymi slajd przypisuje Neo4j skalowanie poziome, a bazom relacyjnym głównie pionowe. Wady to słabość przy prostych danych tabelarycznych i transakcjach masowych, wyższe wymagania sprzętowe przy dużych grafach i konieczność nauki Cyphera.

## 7.3. Neo4j — podstawowe operacje w Cypherze

Ten slajd jest zwięzłą ściągą z Cyphera, więc omówię każdą linijkę, a potem dodam to, czego slajd nie mówi, a co łatwo pomylić.

### Tworzenie węzłów i relacji

Pierwszy przykład: CREATE, nawias n dwukropek Person, w klamrach name dwukropek John w cudzysłowie. Tworzy jeden węzeł z etykietą Person i właściwością name równą John.

Drugi przykład: CREATE, nawias a dwukropek Person, myślnik, nawias kwadratowy z dwukropkiem FRIEND, myślnik, strzałka, nawias b dwukropek Person. To polecenie jednym ruchem tworzy aż trzy rzeczy: dwa nowe węzły Person i relację FRIEND skierowaną od a do b. Pułapka: CREATE zawsze tworzy nowe elementy, nawet jeśli identyczne już istnieją. Jeśli chcesz połączyć dwie osoby, które już są w bazie, najpierw je znajdujesz przez MATCH, a dopiero potem tworzysz samą relację przez CREATE. Gdy chcesz utworzyć coś tylko wtedy, gdy jeszcze nie istnieje, Cypher ma klauzulę MERGE, która najpierw szuka, a tworzy dopiero, gdy nie znajdzie. Tego nie ma na slajdzie, ale to klasyczna różnica: CREATE zawsze tworzy, MERGE szuka albo tworzy.

### Wyszukiwanie danych

MATCH, nawias n dwukropek Person, potem WHERE n kropka name równa się John w cudzysłowie, potem RETURN n. Czyli znajdź wszystkie węzły z etykietą Person, których name to John, i zwróć je. Zauważ, że w Cypherze porównanie zapisujemy pojedynczym znakiem równości, tak jak w SQL, a nie podwójnym jak w językach programowania.

### Aktualizacja danych

SET n kropka age równa się trzydzieści. Slajd pokazuje samą klauzulę SET, ale w praktyce zawsze poprzedza ją MATCH, który wskazuje, który węzeł n zmieniamy. Pełna wersja brzmiałaby: MATCH, nawias n dwukropek Person, WHERE n kropka name równa się John, SET n kropka age równa się trzydzieści. SET ustawia albo dodaje właściwość, bo węzeł nie ma sztywnego schematu i można mu dopisać nową właściwość w każdej chwili. Do usuwania pojedynczej właściwości służy klauzula REMOVE.

### Usuwanie danych

MATCH, nawias n dwukropek Person, DELETE n. To polecenie próbuje usunąć wszystkie węzły z etykietą Person. I tu jest ważna pułapka, której slajd nie mówi. W Neo4j nie można usunąć węzła, który ma jeszcze jakiekolwiek relacje. Zwykłe DELETE zakończy się błędem, jeśli węzeł jest połączony z czymkolwiek, bo baza nie pozwala zostawić relacji bez jednego z końców. Żeby usunąć węzeł razem z jego relacjami, piszemy DETACH DELETE n. Zapamiętaj: DELETE usuwa węzeł bez relacji albo samą relację, a DETACH DELETE najpierw odłącza wszystkie relacje, a potem usuwa węzeł. Zwróć też uwagę, że przykład ze slajdu nie ma żadnego warunku, więc usunąłby wszystkie osoby. To jak DELETE bez WHERE w SQL.

### Większy przykład: osoba mieszka w mieście

Na dole slajdu jest dłuższy blok. Komentarz: tworzenie węzłów. CREATE, nawias p dwukropek Person, w klamrach name Anna i age trzydzieści. CREATE, nawias c dwukropek City, w klamrach name Warszawa. Komentarz: tworzenie relacji. CREATE, nawias p, myślnik, nawias kwadratowy z dwukropkiem LIVES underscore IN, myślnik, strzałka, nawias c. I komentarz: wyszukiwanie danych. MATCH, nawias p dwukropek Person, myślnik, kwadratowy nawias dwukropek LIVES_IN, myślnik, strzałka, nawias c dwukropek City, a potem RETURN p kropka name, c kropka name. Wynikiem będzie wiersz Anna, Warszawa.

Uwaga praktyczna: trzy pierwsze polecenia muszą być wykonane razem, jako jedno zapytanie, bo zmienne p i c żyją tylko w obrębie zapytania. Gdybyś wykonał CREATE relacji osobno, w nowym zapytaniu, to p i c byłyby nowymi, pustymi węzłami bez etykiet, a nie Anną i Warszawą. W osobnym zapytaniu trzeba by najpierw odnaleźć oba węzły przez MATCH.

Konwencja nazewnicza, którą widzisz na slajdach, jest oficjalnym stylem Cyphera: etykiety piszemy wielką literą w stylu CamelCase, jak Person czy City, typy relacji wielkimi literami z podkreśleniami, jak FRIEND czy LIVES_IN, a właściwości małą literą, jak name czy age. Na infografice były polskie etykiety, takie jak Osoba czy Klient, i polska relacja KUPIŁ z literą Ł. Cypher na to pozwala, ale w praktyce unika się znaków diakrytycznych w nazwach.

Do zapamiętania na test: CREATE tworzy węzły i relacje i zawsze tworzy nowe elementy; MATCH wyszukuje wzorzec; WHERE filtruje; RETURN zwraca wynik; SET ustawia właściwość; DELETE usuwa. Relację tworzymy zapisem nawias a, myślnik, nawias kwadratowy z typem, myślnik, strzałka, nawias b. Węzła z relacjami nie usuniesz zwykłym DELETE, potrzebne jest DETACH DELETE. MERGE tworzy tylko wtedy, gdy elementu jeszcze nie ma. Zmienne w Cypherze obowiązują w obrębie jednego zapytania.

## 7.4. Grafy w SQL Server — architektura i GraphTable

Teraz zmiana perspektywy. Do tej pory mówiliśmy o osobnej, natywnej bazie grafowej. Ale grafy można przechowywać także w klasycznej bazie relacyjnej. Microsoft dodał taką możliwość do SQL Server i ten fragment wykładu jest bardzo konkretny składniowo, więc słuchaj uważnie.

### Architektura SQL Graph

Pierwszy slajd tej części pokazuje diagram z dokumentacji Microsoftu, z artykułu o architekturze SQL Graph. Opowiem go strzałka po strzałce. Baza danych, czyli Database, zawiera graf, co na diagramie opisuje strzałka Contains. Graf jest kolekcją tabel węzłów albo krawędzi, co opisuje strzałka isCollectionOf. Z tabel wychodzą trzy dopiski. Tabela węzłów ma właściwości, po angielsku Node table has Properties. Krawędzie łączą węzły, czyli Edges connect Nodes. Tabela krawędzi może mieć właściwości, ale nie musi, czyli Edge table may or may not have Properties.

Ten ostatni punkt jest wart podkreślenia, bo to typowe pytanie testowe. Tabela węzłów zawsze opisuje jakiś obiekt, więc w praktyce ma kolumny z danymi. Tabela krawędzi może nie mieć żadnej własnej kolumny, bo sama informacja, że A jest połączone z B, wystarcza. Zobaczysz to za chwilę w przykładzie, gdzie tabela friendOf jest tworzona bez żadnych kolumn. Dodam jeszcze fakt z dokumentacji: jedna baza danych może zawierać jeden graf, złożony z dowolnej liczby tabel węzłów i krawędzi.

### Czym jest GraphTable

Wykład definiuje GraphTable jako model danych w SQL Server oparty na grafach, który ułatwia modelowanie relacji pomiędzy danymi. Elementy składowe są dwa. Wierzchołki, po angielsku Nodes, reprezentują obiekty. Krawędzie, po angielsku Edges, reprezentują relacje pomiędzy obiektami. Najważniejsza data: funkcje grafowe wprowadzono w SQL Server dwa tysiące siedemnaście. To liczba, o którą test może zapytać, więc zapamiętaj: SQL Server dwa tysiące siedemnaście. Z mojej wiedzy dodam, że w wersji dwa tysiące dziewiętnaście doszły kolejne rozszerzenia, między innymi funkcja SHORTEST_PATH do szukania najkrótszej ścieżki oraz ograniczenia krawędzi, czyli edge constraints, ale podstawy, czyli tabele węzłów i krawędzi oraz MATCH, to rok dwa tysiące siedemnasty. Te same możliwości są też w chmurowej Azure SQL Database.

### Dlaczego GraphTable

Kolejny slajd odpowiada na pytanie, po co to wszystko. Tradycyjne relacyjne modele danych mogą być trudne w modelowaniu skomplikowanych relacji. Wyobraź sobie relację wiele do wielu między osobami, które się znają, a do tego firmy, stanowiska, umiejętności i szkoły, wszystko ze sobą przeplecione. W modelu relacyjnym kończy się to dziesiątkami tabel pośrednich i zapytaniami z wieloma złączeniami.

Slajd wymienia trzy zalety modelu grafowego. Pierwsza: naturalne odwzorowanie sieci społecznościowych, hierarchii i map połączeń. Druga: wydajne zapytania do relacji o głębokości wielu poziomów, czyli na przykład znajomi znajomych znajomych. Trzecia: elastyczność w reprezentacji danych powiązanych, bo nowy typ relacji to po prostu nowa tabela krawędzi, a jedna tabela krawędzi może łączyć węzły różnych typów.

### Kluczowe cechy GraphTable

Następny slajd zbiera kluczowe cechy. Po pierwsze dwa typy tabel: tabele wierzchołków, czyli node tables, i tabele krawędzi, czyli edge tables. Po drugie rozszerzenie języka T-SQL, czyli Transact-SQL, dialektu SQL używanego przez SQL Server, o specjalne zapytania grafowe, przede wszystkim o predykat MATCH. Po trzecie brak ograniczeń na liczbę powiązań między wierzchołkami: jeden węzeł może mieć dowolnie wiele krawędzi wychodzących i przychodzących, a dwa węzły mogą być połączone wieloma krawędziami.

Przykład ze slajdu brzmi tak: SELECT gwiazdka, FROM People P, przecinek, Friends F, WHERE MATCH, a w nawiasie P, myślnik, nawias okrągły z F, myślnik, znak większości, P2. Zauważ podobieństwo do Cyphera: węzeł, myślnik, krawędź w nawiasie, myślnik i strzałka, kolejny węzeł. Różnice są dwie. W SQL Server krawędź stoi w nawiasie okrągłym, a nie kwadratowym, a węzły piszemy bez nawiasów, samą nazwą albo aliasem.

Ten przykład ma jednak błąd. Alias P2 pojawia się w MATCH, ale nie ma go w klauzuli FROM. W SQL Server każdy węzeł i każda krawędź użyte w MATCH muszą być wymienione w FROM. Poprawnie byłoby: FROM People P, Friends F, People P2. I to jest kolejna ważna zasada: jeśli ta sama tabela węzłów występuje we wzorcu dwa razy, jak tu osoba i jej przyjaciel, musisz ją wymienić w FROM dwa razy, z dwoma różnymi aliasami.

### Tworzenie tabel grafowych

Tworzenie tabeli wierzchołków wygląda jak zwykłe CREATE TABLE, z jedną klauzulą na końcu. CREATE TABLE Persons, w nawiasie ID INT PRIMARY KEY, przecinek, Name NVARCHAR sto, zamknięcie nawiasu, i na końcu AS NODE, średnik. Te dwa słowa, AS NODE, zamieniają zwykłą tabelę w tabelę węzłów.

Tworzenie tabeli krawędzi analogicznie: CREATE TABLE Friendships, w nawiasie StartDate DATE, i na końcu AS EDGE, średnik. Zwróć uwagę, że w tabeli krawędzi nie deklarujesz kolumn, które mówią, skąd i dokąd prowadzi krawędź. Nie piszesz żadnych kluczy obcych do tabeli Persons. SQL Server dodaje te kolumny sam. Jedyne, co deklarujesz, to właściwości krawędzi, tutaj data początku znajomości.

Na slajdzie jest też rysunek skierowanego grafu z czterema osobami: Alex, John, Alice i Jacob. Alex i John są połączeni strzałkami w obie strony, John i Alice także w obie strony, a Jacob ma strzałki wychodzące do Johna i do Alice. Ten rysunek przypomina ważną rzecz: krawędź w SQL Server jest zawsze skierowana. Jeśli znajomość ma być wzajemna, zapisujesz dwie krawędzie, po jednej w każdą stronę. Relacja Jacob do Johna bez strzałki powrotnej oznacza, że Jacob uważa Johna za znajomego, ale nie odwrotnie.

### Jak przechowywane są tabele węzłów i krawędzi

To jeden z najważniejszych slajdów działu, bo pokazuje ukryte kolumny. Slajd pokazuje dwie tabele.

Pierwsza to tabela węzłów Person. Ma kolumnę dolar node underscore id, a potem zwykłe kolumny Name i Age, podpisane jako właściwości węzła, czyli Node Properties. Wiersze to John, lat trzydzieści, Mary, lat dwadzieścia osiem, i Alice, lat dwadzieścia pięć. W kolumnie dolar node_id stoją wartości zapisane w formacie JSON: klamra, type dwukropek node, przecinek, id dwukropek zero, i dalej id jeden i id dwa. Na slajdzie w dwóch wierszach brakuje otwierającej klamry, to zwykła literówka. Dodam też, że prawdziwy identyfikator węzła w SQL Server zawiera jeszcze nazwę schematu i tabeli, czyli wygląda mniej więcej tak: type node, schema dbo, table Person, id zero. Slajd go skraca.

Druga to tabela krawędzi Friends. Ma kolumnę dolar edge underscore id, czyli identyfikator samej krawędzi, potem dwie kolumny podpisane jako węzły, które ta krawędź łączy, czyli Nodes that this edge connects: dolar from underscore id i dolar to underscore id, a na końcu zwykłą kolumnę StartDate, podpisaną jako właściwość krawędzi, czyli Edge Property. Trzy wiersze to: krawędź zero od węzła zero do węzła jeden, z datą pierwszy stycznia dwa tysiące trzynaście; krawędź jeden od węzła jeden do węzła dwa, z datą piąty maja dwa tysiące dziesięć; krawędź dwa od węzła dwa do węzła zero, z datą dziewiąty września dwa tysiące szesnaście. Czyli John zna Mary, Mary zna Alice, a Alice zna Johna. Te trzy krawędzie tworzą cykl.

Zapamiętaj nazwy czterech pseudokolumn, bo test lubi je mieszać. Tabela węzłów ma dolar node_id, który jednoznacznie identyfikuje węzeł. Tabela krawędzi ma dolar edge_id, który identyfikuje krawędź, oraz dolar from_id i dolar to_id, które przechowują node_id węzła początkowego i końcowego. Tabela węzłów nie ma kolumn from i to, a tabela krawędzi nie ma kolumny node_id. Nazywamy je pseudokolumnami, bo pod spodem SQL Server trzyma kilka ukrytych kolumn wewnętrznych, a dolar node_id i pozostałe to wygodne nakładki, przez które się do nich odwołujemy. Wartości tych kolumn generuje system, sam ich nie wpisujesz do tabeli węzłów.

Do zapamiętania na test: w SQL Server baza zawiera graf, a graf jest kolekcją tabel węzłów i krawędzi; tabela węzłów ma właściwości, a tabela krawędzi może je mieć albo nie. Grafy wprowadzono w SQL Server dwa tysiące siedemnaście. Tabelę węzłów tworzymy przez CREATE TABLE z klauzulą AS NODE na końcu, a tabelę krawędzi przez CREATE TABLE z klauzulą AS EDGE. Tabela węzłów dostaje automatycznie pseudokolumnę dolar node_id, a tabela krawędzi pseudokolumny dolar edge_id, dolar from_id i dolar to_id. Identyfikatory mają postać JSON. Krawędzie są skierowane, a predykat MATCH zapisuje się jako węzeł, myślnik, krawędź w nawiasie okrągłym, myślnik, strzałka, węzeł, przy czym każdy użyty alias musi być w FROM, a powtórzona tabela węzłów dostaje drugi alias.

## 7.5. GraphTable w praktyce — przykład z restauracjami

### Analiza sieci znajomych

Pierwszy przykład zastosowania to analiza sieci znajomych w mediach społecznościowych. Węzły to użytkownicy, czyli tabela Persons, a krawędzie to relacje znajomości, czyli tabela Friendships. Zapytanie: SELECT Friend1 kropka Name, przecinek, Friend2 kropka Name, FROM Persons Friend1, przecinek, Friendships Rel, przecinek, Persons Friend2, WHERE MATCH, w nawiasie Friend1, myślnik, nawias z Rel, myślnik, strzałka, Friend2. Tu wszystko jest poprawne: tabela Persons występuje dwa razy z dwoma aliasami, Friend1 i Friend2, a krawędź ma alias Rel. Wynik to lista par: kto, i kogo uznaje za znajomego.

### Przykład z dokumentacji: osoby, restauracje, miasta

Kolejne slajdy pochodzą z oficjalnego przykładu Microsoftu, z artykułu SQL Graph sample. Diagram pokazuje trzy rodzaje węzłów: Person u góry, City w lewym dolnym rogu i Restaurant w prawym dolnym rogu. Krawędzie to: pętla Friends z Person do Person, LivesIn z Person do City, Likes z Person do Restaurant, Likes z Person do City oraz LocatedIn z Restaurant do City. Krawędzie mają przykładowe właściwości, takie jak rating i review przy Likes czy address przy LivesIn i LocatedIn. Zwróć uwagę, że ta sama krawędź Likes łączy osobę z restauracją i osobę z miastem. W SQL Server jedna tabela krawędzi może łączyć węzły z różnych tabel, bo kolumny from i to przechowują identyfikator węzła razem z informacją, z jakiej tabeli on pochodzi.

Najpierw tworzymy tabele węzłów. CREATE TABLE Person, w nawiasie ID INTEGER PRIMARY KEY i name VARCHAR sto, AS NODE. CREATE TABLE Restaurant, w nawiasie ID INTEGER NOT NULL, name VARCHAR sto i city VARCHAR sto, AS NODE. CREATE TABLE City, w nawiasie ID INTEGER PRIMARY KEY, name VARCHAR sto i stateName VARCHAR sto, AS NODE. Tabele węzłów mogą mieć zwykłe klucze główne i ograniczenia, tak jak każda tabela.

Potem tabele krawędzi. CREATE TABLE likes, w nawiasie rating INTEGER, AS EDGE. CREATE TABLE friendOf AS EDGE. CREATE TABLE livesIn AS EDGE. CREATE TABLE locatedIn AS EDGE. Trzy ostatnie nie mają żadnych kolumn użytkownika, nawet pustego nawiasu. To dokładnie ilustruje regułę z diagramu architektury: tabela krawędzi może nie mieć właściwości. Tylko likes ma właściwość rating, czyli ocenę.

### Wstawianie danych do tabel węzłów

Komentarz na slajdzie mówi wprost: wstawianie do tabeli węzłów jest takie samo jak wstawianie do zwykłej tabeli. INSERT INTO Person, w nawiasie ID i name, VALUES, a potem pięć krotek: jeden John, dwa Mary, trzy Alice, cztery Jacob, pięć Julie. INSERT INTO Restaurant, w nawiasie ID, name i city, VALUES: jeden Taco Dell w Bellevue, dwa Ginger and Spice w Seattle, trzy Noodle Land w Redmond. INSERT INTO City, w nawiasie ID, name i stateName, VALUES: jeden Bellevue, dwa Seattle, trzy Redmond, wszystkie w stanie WA, czyli Waszyngton. Nie podajemy wartości dolar node_id, bo system generuje ją sam.

### Wstawianie danych do tabel krawędzi

Tu jest różnica, którą koniecznie zapamiętaj. Komentarz na slajdzie mówi: przy wstawianiu do tabeli krawędzi trzeba podać dolar node_id dla kolumn dolar from_id i dolar to_id. Innymi słowy, krawędź nie odwołuje się do zwykłego klucza ID, tylko do systemowego identyfikatora węzła. Skąd go wziąć? Z podzapytania.

Pierwszy przykład, kto lubi jaką restaurację: INSERT INTO likes VALUES, a w nawiasie trzy wartości. Pierwsza to podzapytanie: SELECT dolar node_id FROM Person WHERE ID równa się jeden. Druga to podzapytanie: SELECT dolar node_id FROM Restaurant WHERE ID równa się jeden. Trzecia to ocena dziewięć. Czyli John lubi Taco Dell z oceną dziewięć. Kolejność wartości odpowiada kolejności kolumn: najpierw from, potem to, potem właściwości.

Drugi przykład, w jakim mieście mieszka osoba: INSERT INTO livesIn VALUES, podzapytanie o dolar node_id osoby o ID jeden i podzapytanie o dolar node_id miasta o ID jeden. John mieszka w Bellevue.

Trzeci, gdzie leży restauracja: INSERT INTO locatedIn VALUES, dolar node_id restauracji o ID jeden i dolar node_id miasta o ID jeden. Taco Dell leży w Bellevue.

Czwarty, przyjaźń: INSERT INTO friendOf VALUES, dolar NODE_ID osoby o ID jeden i dolar NODE_ID osoby o ID dwa. Tu nazwa pseudokolumny jest napisana wielkimi literami, co pokazuje, że w T-SQL wielkość liter w nazwach nie ma znaczenia przy domyślnych ustawieniach. John przyjaźni się z Mary, w jedną stronę.

W praktyce częściej pisze się wersję z jawną listą kolumn: INSERT INTO likes, w nawiasie dolar from_id, dolar to_id, rating, a potem VALUES. Jest czytelniejsza i odporna na zmianę kolejności kolumn. Pamiętaj też o ograniczeniu, które pojawi się za chwilę: dolar from_id i dolar to_id ustawiasz przy wstawianiu, ale nie możesz ich potem zmienić instrukcją UPDATE. Żeby przepiąć krawędź, usuwasz ją i wstawiasz nową.

### Zapytania z MATCH

Slajd pokazuje trzy zapytania, coraz bardziej złożone.

Pierwsze: znajdź restauracje, które lubi John. SELECT Restaurant kropka name, FROM Person, likes, Restaurant, WHERE MATCH, w nawiasie Person, myślnik, nawias z likes, myślnik, strzałka, Restaurant, AND Person kropka name równa się John. Czyli MATCH opisuje wzorzec, a zwykły warunek AND zawęża go do Johna. MATCH łączy się z innymi warunkami przez AND.

Drugie: znajdź restauracje, które lubią przyjaciele Johna. SELECT Restaurant kropka name, FROM Person person1, Person person2, likes, friendOf, Restaurant, WHERE MATCH, w nawiasie person1, myślnik, nawias z friendOf, myślnik, strzałka, person2, myślnik, nawias z likes, myślnik, strzałka, Restaurant, AND person1 kropka name równa się John. Tu widzisz dwie rzeczy. Tabela Person występuje dwa razy, z aliasami person1 i person2. I wzorzec jest łańcuchem: od Johna przez krawędź friendOf do przyjaciela, a od przyjaciela przez krawędź likes do restauracji. To jest zapytanie dwupoziomowe, zapisane w jednej czytelnej linii.

Trzecie: znajdź osoby, które lubią restaurację w tym samym mieście, w którym mieszkają. SELECT Person kropka name, FROM Person, likes, Restaurant, livesIn, City, locatedIn, WHERE MATCH, a w nawiasie dwa wzorce połączone słowem AND. Pierwszy: Person, przez likes, do Restaurant, a dalej przez locatedIn do City. Drugi: Person, przez livesIn, do City. Ponieważ w obu wzorcach występują te same aliasy Person i City, SQL Server wymaga, żeby to była ta sama osoba i to samo miasto. W ten sposób graf zamyka się w trójkąt: osoba, restauracja, miasto. Wewnątrz MATCH wzorce łączy się wyłącznie przez AND; operatory OR i NOT nie są w MATCH obsługiwane.

### Wizualizacje wyników

Kolejny slajd pokazuje trzy obrazki wyników zapytań grafowych, w zielonych ramkach. Pierwszy to gwiazda: w środku węzeł John, a dookoła połączone z nim węzły o nazwach takich jak Third Day, Jeremy Camp, Passion, Chris Tomlin, Delirious i Casting Crowns, czyli wykonawców muzycznych. To zapowiedź przykładu z rekomendacją utworów. Dwa pozostałe obrazki pokazują węzeł klienta Wolski Zajazd, do którego prowadzą czerwone strzałki od kategorii produktów: Confections, Produce, Meat and Poultry, Dairy Products, Seafood, Condiments i Beverages. Na trzecim obrazku dochodzi drugi klient, Wilman Kala, połączony z tymi samymi kategoriami, oraz kategoria Grains and Cereals. To dane z klasycznej przykładowej bazy Northwind, a obrazek pokazuje, że dwóch klientów kupuje z tych samych kategorii, więc można je porównywać i sobie nawzajem coś polecać. Nazwy na slajdzie są ucięte, na przykład Wolski Za zamiast Wolski Zajazd, ale to tylko ograniczenie rysunku.

Do zapamiętania na test: do tabeli węzłów wstawiamy dane tak jak do zwykłej tabeli, bez podawania dolar node_id. Do tabeli krawędzi wstawiamy wartości dolar from_id i dolar to_id, zwykle podzapytaniem SELECT dolar node_id FROM tabela WHERE warunek, a dopiero po nich właściwości krawędzi. Tabela krawędzi może nie mieć kolumn, jak friendOf, livesIn i locatedIn. MATCH łączymy z innymi warunkami przez AND, wzorce można łączyć w łańcuch, jak person1, friendOf, person2, likes, Restaurant, a wewnątrz MATCH kilka wzorców łączy się tylko przez AND. Powtórzony alias w dwóch wzorcach oznacza ten sam węzeł.

## 7.6. Zastosowania i ograniczenia GraphTable

### Zastosowania

Slajd wymienia cztery główne obszary zastosowania tabel grafowych w SQL Server. Analiza sieci społecznościowych, czyli kto kogo zna i jakie grupy tworzą użytkownicy. Mapowanie tras i połączeń, na przykład sieci drogowe, połączenia lotnicze czy sieci komputerowe. Analiza powiązań biznesowych, czyli kto jest czyim dostawcą, klientem, udziałowcem albo pracodawcą. I wykrywanie oszustw, na przykład w finansach, gdzie podejrzane są nietypowe powiązania między kontami.

Zauważ, że ta lista pokrywa się z zastosowaniami Neo4j i baz grafowych w ogóle. Przewaga SQL Server nie polega na innych zastosowaniach, tylko na tym, że grafy żyją w tej samej bazie co reszta danych firmy. Można w jednym zapytaniu połączyć wzorzec grafowy ze zwykłą tabelą zamówień, korzystać z tych samych transakcji, kopii zapasowych, uprawnień i narzędzi. Nie trzeba utrzymywać osobnego systemu.

### Ograniczenia

Slajd o ograniczeniach jest listą siedmiu punktów, przetłumaczonych z dokumentacji Microsoftu, z kilkoma literówkami. Omówię każdy i powiem, dlaczego tak jest.

Pierwszy: tabele tymczasowe lokalne i globalne nie mogą być tabelami węzłów ani krawędzi. Chodzi o tabele z krzyżykiem na początku nazwy, czyli lokalne, i z dwoma krzyżykami, czyli globalne. Nie da się utworzyć tabeli tymczasowej z klauzulą AS NODE ani AS EDGE.

Drugi: typy tabel i zmienne tabelowe nie mogą być deklarowane jako tabele węzłów lub krawędzi. Zmienna tabelowa to obiekt deklarowany przez DECLARE z małpą na początku nazwy i typem TABLE. Ona także nie może być węzłem ani krawędzią.

Trzeci: tabel węzłów i krawędzi nie można tworzyć jako tabel czasowych z wersjonowaniem systemowym, czyli system-versioned temporal tables. To tabele, w których SQL Server automatycznie przechowuje historię wszystkich zmian wierszy. Grafy tej funkcji nie obsługują.

Czwarty: tabele węzłów i krawędzi nie mogą być tabelami zoptymalizowanymi pod kątem pamięci, czyli tabelami In-Memory OLTP, przechowywanymi w całości w pamięci operacyjnej.

Piąty: użytkownicy nie mogą aktualizować kolumn dolar from_id i dolar to_id krawędzi za pomocą instrukcji UPDATE. Na slajdzie te słowa są sklejone, czyli „to_idkrawędzi”, to literówka. Sens jest taki: końce krawędzi są stałe. Chcesz zmienić, dokąd prowadzi krawędź, to usuwasz ją przez DELETE i wstawiasz nową przez INSERT. Właściwości krawędzi, na przykład rating, możesz natomiast aktualizować normalnie.

Szósty: zapytania rozproszone dotyczące obiektów grafowych nie są obsługiwane. Na slajdzie jest słowo „graficznych”, co jest niezręcznym tłumaczeniem, chodzi o obiekty grafowe. W angielskiej dokumentacji ten punkt mówi o zapytaniach między bazami danych, czyli cross-database queries. Sens jest ten sam: zapytanie grafowe działa w obrębie jednej bazy.

Siódmy: pseudokolumny grafu, czyli dolar node_id, dolar from_id, dolar to_id i dolar edge_id, nie mogą być używane jako kolumny sortowania dla uporządkowanego klastrowanego indeksu magazynu kolumn, czyli ordered clustered columnstore index. Na slajdzie przy node_id i edge_id zgubił się znak dolara, a „to_idi” to sklejone słowa „to_id i”. Prawidłowe nazwy zawsze zaczynają się od dolara.

### Sieć zawodowa jako graf

Slajd z oficjalnej prezentacji Microsoftu, zatytułowany Database engine enhancements, Support for graph data, czyli ulepszenia silnika bazy danych i obsługa danych grafowych, pokazuje graf aplikacji do sieci zawodowej, takiej jak LinkedIn. Są tam osoby, Mary Jones i Andy Smith, firmy, Contoso i Adventure Works, umiejętność Statistics, wykształcenie Bachelor of Science z finansów oraz stanowiska Business analyst i Program manager. Krawędzie mają różne typy. Mary Jones jest współpracowniczką Andy'ego Smitha, czyli Coworker. Oboje mają umiejętność Statistics, czyli krawędź Skill. Andy ma dyplom, czyli Degree earned, i stanowisko Business analyst, czyli Position. Mary ma stanowisko Program manager, a jej byłym pracodawcą jest Contoso, czyli Former employer. Adventure Works jest pracodawcą obojga, czyli Employer, a stanowiska Business analyst i Program manager są rolami w tej firmie, czyli Role in company. Program manager jest też rolą w Contoso.

Ten przykład pokazuje, dlaczego grafy są wygodne: w modelu relacyjnym każdy z tych typów powiązań oznaczałby osobną tabelę łączącą i osobne złączenia. W modelu grafowym każdy typ to krawędź, a pytanie w rodzaju „którzy współpracownicy Mary znają statystykę i pracowali kiedyś w Contoso” zapisuje się jednym wzorcem.

Do zapamiętania na test: zastosowania GraphTable to analiza sieci społecznościowych, mapowanie tras i połączeń, analiza powiązań biznesowych i wykrywanie oszustw. Tabelami węzłów ani krawędzi nie mogą być tabele tymczasowe lokalne i globalne, typy tabel i zmienne tabelowe, tabele czasowe z wersjonowaniem systemowym ani tabele zoptymalizowane pod kątem pamięci. Kolumn dolar from_id i dolar to_id nie zmienisz przez UPDATE. Zapytania rozproszone na obiektach grafowych nie są obsługiwane. Pseudokolumny grafu nie mogą być kolumnami sortowania uporządkowanego klastrowanego indeksu columnstore.

## 7.7. MATCH kontra JOIN i rekomendacja utworów

### MATCH jest zwięźlejszy niż złączenia

Slajd zatytułowany Match is more concise than joins, czyli MATCH jest zwięźlejszy niż złączenia, pokazuje to samo zapytanie w dwóch wersjach. Treść zadania: znajdź pracowników, którzy raportują do Johna i pracują w lokalizacji Seattle.

Wersja z MATCH. SELECT person2 kropka name, FROM Employee person1, Manages manages, Employee person2, works_at, location. WHERE MATCH, w nawiasie person1, myślnik, nawias z manages, myślnik, strzałka, person2, myślnik, nawias z works_at, myślnik, strzałka, location. Do tego AND person1 kropka name równa się John i AND location kropka name równa się Seattle. Wzorzec czytasz jak zdanie: John zarządza osobą, a ta osoba pracuje w lokalizacji.

Wersja ze złączeniami. Ta sama lista tabel w FROM, a w WHERE cztery warunki łączące zamiast MATCH. person1 kropka dolar node_id równa się manages kropka dolar from_id. manages kropka dolar to_id równa się person2 kropka dolar node_id. person2 kropka dolar node_id równa się works_at kropka dolar from_id. works_at kropka dolar to_id równa się location kropka dolar node_id. I dalej te same dwa warunki na Seattle i Johna.

Co z tego wynika? Każda krawędź we wzorcu MATCH zastępuje dwa warunki równości: jeden łączący dolar from_id krawędzi z dolar node_id węzła początkowego i drugi łączący dolar to_id z dolar node_id węzła końcowego. Dwie krawędzie we wzorcu to cztery warunki złączenia. Przy pięciu poziomach robi się z tego dziesięć warunków i łatwo o pomyłkę, na przykład zamianę from z to, która po cichu odwraca kierunek relacji. Ten przykład pokazuje też, że pseudokolumny dolar node_id, dolar from_id i dolar to_id są dostępne w zwykłym SQL i można ich używać w klasycznych złączeniach.

Ważna uwaga, która chroni przed fałszywą odpowiedzią na teście. Slajd mówi, że MATCH jest zwięźlejszy, a nie, że jest z natury szybszy. SQL Server tłumaczy wzorzec MATCH na złączenia, więc obie wersje dają ten sam wynik i zwykle podobny plan wykonania. Zaletą MATCH jest czytelność i mniejsza szansa na błąd. Zauważ też, że w tym przykładzie Employee występuje dwa razy, jako person1 i person2, zgodnie z regułą o powtórzonych tabelach węzłów.

### Rekomendacja utworów: podejście

Ostatni merytoryczny przykład to system rekomendacji utworów muzycznych, oparty na prezentacji Microsoftu. Slajd Recommending Songs: Approach pokazuje dwie kolumny. Po lewej są użytkownicy, od User1 do User5, a po prawej utwory, od Song1 do Song5. Strzałki pokazują, kto czego słucha albo co lubi.

Rozumowanie jest takie. Chcemy coś polecić użytkownikowi User1. User1 lubi Song2, co pokazuje czerwona strzałka. Szukamy innych użytkowników, którzy też lubią Song2: to User3 i User4, oznaczeni zielonymi strzałkami. Sprawdzamy, co jeszcze lubią ci podobni użytkownicy: obaj lubią Song3, co pokazują niebieskie przerywane strzałki. Skoro ludzie o podobnym guście lubią Song3, polecamy Song3 użytkownikowi User1, co na slajdzie pokazuje gruba fioletowa przerywana strzałka. Pozostałe cienkie szare linie, czyli User1 do Song5, User2 do Song4 i User5 do Song1, to inne powiązania, które nie biorą udziału w tej rekomendacji.

To podejście nazywa się filtrowaniem kolaboratywnym, po angielsku collaborative filtering: użytkownicy, którzy lubili to samo co ty, lubią też coś innego, więc to coś prawdopodobnie spodoba się i tobie. W grafie jest to po prostu ścieżka o długości trzech krawędzi: od ciebie do utworu, od utworu do innego słuchacza, od tego słuchacza do nowego utworu. Im więcej takich ścieżek prowadzi do danego utworu, tym wyżej stoi on w rekomendacji.

### Implementacja w SQL Graph

Slajd Implementation using SQL Graph pokazuje model: dwa koła, UniqueUser jako tabela węzłów po lewej i UniqueSong jako tabela węzłów po prawej, połączone strzałką Likes, czyli tabelą krawędzi, od użytkownika do utworu.

Kod jest następujący. CREATE TABLE UniqueUser, w nawiasie UserId VARCHAR osiemdziesiąt, AS NODE. CREATE TABLE Likes, w nawiasie ListenCount BIGINT, AS EDGE. CREATE TABLE UniqueSong, w nawiasie SongId VARCHAR pięćdziesiąt, SongTitle VARCHAR pięćset i ArtistName VARCHAR pięćset, AS NODE. Krawędź Likes ma więc właściwość ListenCount typu BIGINT, czyli liczbę odsłuchań. Dzięki temu rekomendację można ważyć: utwór, który podobni użytkownicy słuchali sto razy, jest silniejszym sygnałem niż taki, który odtworzyli raz.

Slajd nie pokazuje samego zapytania rekomendującego, więc opowiem, jak wygląda w duchu przykładu Microsoftu. W FROM wymieniamy UniqueUser dwa razy, jako ciebie i jako innego słuchacza, UniqueSong dwa razy, jako utwór, który lubisz, i jako utwór polecany, oraz Likes trzy razy, bo ścieżka ma trzy krawędzie. W MATCH zapisujemy łańcuch: polecany utwór, strzałka wstecz z Likes, inny słuchacz, krawędź Likes do twojego utworu, strzałka wstecz z Likes, ty. SQL Server pozwala pisać strzałki w obie strony, czyli także znak mniejszości i myślnik na początku krawędzi. Dodajemy warunek, że polecany utwór jest inny niż ten, który już lubisz, grupujemy po polecanym utworze i sortujemy malejąco po liczbie znalezionych ścieżek albo po sumie ListenCount. Pierwsze wiersze wyniku to rekomendacje.

Ostatni slajd tego zakresu jest pusty, więc na tym kończymy część o bazach grafowych.

Do zapamiętania na test: slajd Match is more concise than joins pokazuje, że jedno wyrażenie MATCH zastępuje serię warunków złączenia na dolar node_id, dolar from_id i dolar to_id, po dwa na każdą krawędź; MATCH jest zwięźlejszy i czytelniejszy, a wynik jest taki sam jak ze złączeń. Rekomendacja utworów działa przez filtrowanie kolaboratywne: użytkownikowi User1, który lubi Song2, polecamy Song3, bo lubią go User3 i User4, którzy też lubią Song2. Model w SQL Graph to tabele węzłów UniqueUser z kolumną UserId i UniqueSong z kolumnami SongId, SongTitle i ArtistName oraz tabela krawędzi Likes z właściwością ListenCount typu BIGINT.

## Podsumowanie działu

Zbierzmy cały dział w kilku zdaniach. Baza grafowa przechowuje węzły i krawędzie, a jedne i drugie mogą mieć właściwości. Typy to OLTP, czyli wiele małych grafów, i OLAP, czyli mało bardzo dużych. Grafy świetnie nadają się do sieci społecznościowych, rekomendacji, grafów wiedzy, wykrywania oszustw, nawigacji i analizy zależności, a słabo do operacji masowych na wszystkich węzłach. Najpopularniejszą bazą grafową jest Neo4j, natywna baza z językiem Cypher, w którym węzły piszemy w nawiasach okrągłych, relacje w kwadratowych, a podstawowe klauzule to CREATE, MATCH, WHERE, RETURN, SET i DELETE, z DETACH DELETE dla węzłów z relacjami. SQL Server od wersji dwa tysiące siedemnaście ma tabele grafowe: tabele węzłów tworzone z AS NODE, z pseudokolumną dolar node_id, i tabele krawędzi tworzone z AS EDGE, z pseudokolumnami dolar edge_id, dolar from_id i dolar to_id. Zapytania grafowe pisze się predykatem MATCH w klauzuli WHERE, który jest zwięźlejszą formą serii złączeń. Tabele grafowe nie mogą być tymczasowe, zmiennymi tabelowymi, tabelami czasowymi ani tabelami In-Memory, a końców krawędzi nie zmienia się przez UPDATE.


# 8. Bazy rodziny kolumn — Apache Cassandra i CQL

Witaj w ósmym dziale. Tym razem zajmiemy się czwartą wielką rodziną baz NoSQL, czyli bazami rodziny kolumn, nazywanymi też bazami szerokich kolumn, po angielsku wide-column stores. Najważniejszym przedstawicielem tej rodziny jest Apache Cassandra i to właśnie wokół niej zbudowana jest prawie cała ta część wykładu.

Plan jest taki. Najpierw powiemy sobie, jak wygląda model danych w bazach rodziny kolumn, kiedy ich używać, a kiedy nie, i kto jest liderem rynku. Potem poznamy Cassandrę od strony architektury: klaster równorzędnych węzłów, partycjonowanie danych, klucz partycji, funkcję haszującą Murmur3, token, pierścień tokenów i węzły wirtualne. Następnie przejdziemy do bardzo ważnego tematu, czyli modelowania danych pod zapytania: dlaczego w Cassandrze najpierw projektuje się zapytania, a dopiero potem tabele, czym jest denormalizacja i czym grozi tak zwana gorąca partycja. Druga połowa działu to język CQL, czyli Cassandra Query Language: przestrzenie kluczy, tabele, klucze główne, typy danych, krotki, kolekcje i typy definiowane przez użytkownika, a na końcu polecenia SELECT, INSERT, UPDATE i DELETE ze wszystkimi ich ograniczeniami. Test pyta zarówno o teorię, jak i o składnię, więc przy kodzie będę mówił powoli i dokładnie, znak po znaku tam, gdzie to ważne.

## 8.1. Bazy rodziny kolumn: model danych i zastosowania

Zacznijmy od modelu danych, który wykład pokazuje dwukrotnie, raz na początku działu i raz tuż przed właściwą częścią o Cassandrze. Omówię go raz, łącząc obie wersje.

Model ma trzy poziomy. Pierwszym jest rodzina kolumn, którą w praktyce nazywamy tabelą. Tabela to kolekcja podobnych wierszy, przy czym wykład wyraźnie podkreśla: podobnych, a niekoniecznie identycznych. To jest pierwsza różnica wobec bazy relacyjnej. W relacyjnej tabeli każdy wiersz ma dokładnie te same kolumny, a brak wartości oznacza NULL zapisany w komórce. W bazie rodziny kolumn wiersz może mieć tylko te kolumny, które faktycznie mają wartość; inne wiersze mogą mieć inny zestaw kolumn.

Drugim poziomem jest wiersz. Wiersz to kolekcja kolumn. Wykład dodaje ważną wskazówkę projektową: wiersz powinien agregować porcję danych, która jest odczytywana razem, czyli dane pozyskiwane wspólnie. Innymi słowy, do jednego wiersza wkładamy to, co aplikacja zwykle czyta jednym zapytaniem. Każdy wiersz ma przyporządkowany unikalny identyfikator, czyli klucz wiersza. W starszej terminologii, na przykład w HBase, mówi się row key, a w Cassandrze ten identyfikator to klucz partycji, a ogólniej klucz główny. To właśnie po identyfikatorze wiersza uzyskujemy do niego szybki dostęp.

Trzecim poziomem jest kolumna. Kolumna składa się z nazwy kolumny i wartości w kolumnie, a potencjalnie także z innych metadanych. Tymi metadanymi są na przykład czas zapisu, czyli timestamp, oraz czas życia, czyli TTL; wrócimy do nich później. Wartości mogą być skalarne, czyli pojedyncze liczby czy teksty, ale dopuszczalne są też płaskie zbiory, listy czy mapy. Słowo płaskie jest tu istotne: kolekcja to prosta struktura, a nie dowolnie zagnieżdżony dokument jak w MongoDB.

Jakie zapytania typowo wykonujemy na takiej bazie? Wykład wymienia dwie grupy. Po pierwsze dodaj, zmień lub usuń wiersz zawierający rodzinę kolumn. Po drugie wybierz wiersz na podstawie identyfikatora albo prostego przeszukiwania kolumn. Zwróć uwagę na słowo prostego. Nie ma tu bogatych złączeń ani rozbudowanych agregacji.

Na slajdzie jest też ważna uwaga: bazy rodziny kolumn to nie są po prostu bazy relacyjne ze zmienną specyfikacją wiersza. Łatwo dać się zwieść, bo Cassandra ma tabele, wiersze i kolumny, a jej język CQL wygląda prawie jak SQL. Ale pod spodem wszystko działa inaczej: dane są rozproszone po węzłach według klucza partycji, nie ma złączeń, zapytania muszą korzystać z klucza, a model projektuje się od zapytań. Pułapka egzaminacyjna polega na tym, że ktoś myśli: to taki SQL bez sztywnego schematu. Nie, to zupełnie inna filozofia.

Kiedy używać baz rodziny kolumn? Slajd jako przykład podaje blogi i systemy CMS, czyli systemy zarządzania treścią. Z dalszej części wykładu dodamy do tego aplikacje o dużym ruchu, IoT, telemetrię, platformy społecznościowe i gry online.

Kiedy nie używać? Slajd wymienia trzy sytuacje. Pierwsza: gdy wymagane są transakcje ze ścisłą spójnością. Druga: gdy występują złożone zapytania, czyli agregacje typu SUM czy AVG, złączenia i tym podobne. Trzecia, trochę zaskakująca: gdy schemat bazy może zostać często zmieniony. Dlaczego zaskakująca? Bo przecież mówiliśmy, że wiersze są elastyczne. Chodzi jednak o to, że model danych w bazie rodziny kolumn jest ściśle dopasowany do zapytań. Jeśli zmieniają się wymagania i zapytania, trzeba przeprojektować tabele, często przepisać dane do nowych tabel. Elastyczny jest wiersz, ale nie sposób odpytywania.

Przedstawiciele tej rodziny pokazani na slajdzie to Apache Cassandra, ScyllaDB, Apache HBase, Google Bigtable oraz Azure Cosmos DB w wariancie z API Cassandry. Dla porządku: ScyllaDB to baza zgodna z Cassandrą, przepisana w C++, a HBase to baza z ekosystemu Hadoop, wzorowana na Google Bigtable.

Następny slajd pokazuje ranking DB-Engines dla kategorii Wide Column Stores, w skali logarytmicznej, dla lat od dwa tysiące czternastego do dwa tysiące dwudziestego czwartego, ze stopką z października dwa tysiące dwudziestego piątego. Wnioski są proste. Apache Cassandra jest na samym szczycie, z wynikiem w okolicach stu punktów. Apache HBase ma wynik rzędu dwudziestu do sześćdziesięciu z wyraźną tendencją malejącą. Microsoft Azure Cosmos DB rośnie do około trzydziestu, czterdziestu, a potem spada do około dwudziestu. Na wykresie są też między innymi ScyllaDB, Datastax Enterprise, Azure Table Storage, Google Cloud Bigtable, Apache Accumulo, Amazon Keyspaces, HPE Ezmeral Data Fabric, Elassandra, Alibaba Cloud Table Store, SWC-DB, Hypertable i Sqrrl, wszystkie z wynikami między jedną setną a dziesięcioma punktami. Gdyby test pytał, która baza kolumnowa jest najpopularniejsza według DB-Engines, odpowiedź brzmi: Cassandra.

Do zapamiętania na test: model bazy rodziny kolumn to rodzina kolumn, czyli tabela, złożona z podobnych, ale niekoniecznie identycznych wierszy; wiersz to kolekcja kolumn z unikalnym kluczem i powinien grupować dane czytane razem; kolumna to nazwa, wartość i metadane, a wartością może być skalar albo płaska lista, zbiór czy mapa. Używamy ich do blogów i CMS, nie używamy, gdy potrzebne są ścisłe transakcje, złożone agregacje i złączenia albo gdy schemat często się zmienia. To nie jest baza relacyjna ze zmiennym wierszem. Lider rankingu to Cassandra, a HBase traci popularność.

## 8.2. Apache Cassandra: czym jest i jak działa

Kolejny slajd to samo logo Cassandry: niebieskie oko z rzęsami i napis cassandra. Nazwa nawiązuje do mitologicznej Kasandry, wieszczki, która widziała przyszłość. Przejdźmy do treści.

Wykład opisuje Cassandrę jako rozproszoną bazę danych dla systemów o wysokiej dostępności. Przechowuje dane w modelu szerokich kolumn, czyli wide-column store. Dane są zorganizowane w tabelach, ale struktura jest bardziej elastyczna niż w tradycyjnych bazach relacyjnych. Kluczowe zdanie: Cassandra została zaprojektowana do pracy na wielu serwerach bez pojedynczego punktu awarii, po angielsku single point of failure.

Jak wygląda hierarchia? Od najmniejszego elementu: rekord, czyli wiersz, należy do tabeli, którą dawniej nazywano column family, czyli rodziną kolumn. Tabela należy do keyspace, czyli przestrzeni nazw, a w polskiej wersji wykładu przestrzeni kluczy. Keyspace należy do klastra Cassandra, który składa się z wielu węzłów. Na innym slajdzie ta sama struktura jest opisana od góry: instancja, przestrzeń kluczy, tabele, wiersze, kolumny. Klaster składa się z wielu równorzędnych węzłów, z których każdy przechowuje część danych. Równorzędnych, czyli nie ma węzła głównego, mastera, i węzłów podrzędnych. To się nazywa architektura peer-to-peer.

Slajd pokazuje przykład w języku CQL. Najpierw tworzymy tabelę: CREATE TABLE klienci, a w nawiasie okrągłym kolumny: id typu INT z dopiskiem PRIMARY KEY, imie typu TEXT, nazwisko TEXT, miasto TEXT i wiek INT. Potem wstawiamy rekord: INSERT INTO klienci, w nawiasie lista kolumn id, imie, nazwisko, miasto, wiek, potem słowo VALUES i w nawiasie wartości: tysiąc jeden, w apostrofach Jan, w apostrofach Kowalski, w apostrofach Warszawa i dwadzieścia pięć. Wygląda to dokładnie jak SQL i to jest zamierzone: CQL był projektowany tak, żeby programiście SQL było łatwo zacząć.

Najważniejsze cechy Cassandry według slajdu są takie. Wysoka dostępność, bo nie ma pojedynczego punktu awarii. Skalowalność pozioma, czyli łatwe dodawanie nowych serwerów do klastra. Replikacja danych, czyli automatyczne kopiowanie danych między węzłami. Bardzo wysoka wydajność zapisu, bo Cassandra jest przystosowana do ogromnych wolumenów danych; zapis trafia najpierw do dziennika i pamięci, a dopiero później jest zrzucany na dysk sekwencyjnie, dlatego zapisy są bardzo tanie. I wreszcie architektura rozproszona, w której wszystkie węzły są równorzędne, czyli peer-to-peer.

Przykładowe operacje na slajdzie: dodawanie danych to INSERT INTO klienci z kolumnami id, imie, nazwisko, miasto, wiek i wartościami tysiąc dwa, Anna, Nowak, Kraków, dwadzieścia osiem. Wyszukiwanie to SELECT gwiazdka FROM klienci WHERE id równa się tysiąc dwa. Zwróć uwagę, że warunek jest na kluczu głównym, i to nie przypadek; w Cassandrze zapytania co do zasady muszą wskazywać klucz partycji. Aktualizacja to UPDATE klienci SET wiek równa się dwadzieścia dziewięć WHERE id równa się tysiąc dwa.

Zastosowania Cassandry wymienione na slajdzie: aplikacje internetowe o dużym ruchu, systemy mobilne, Big Data i analityka, platformy społecznościowe, Internet rzeczy, czyli IoT, gry online oraz monitoring i telemetria. Wspólny mianownik: dużo zapisów, dużo danych, potrzeba ciągłej dostępności i proste, przewidywalne wzorce odczytu.

Slajd zawiera porównanie Cassandry z bazami relacyjnymi, które opowiem zdaniami. Model danych: w Cassandrze szerokie kolumny, w bazach relacyjnych tabele. Skalowanie: Cassandra skaluje się poziomo, czyli przez dokładanie maszyn, bazy relacyjne głównie pionowo, czyli przez mocniejszy serwer. Dostępność: w Cassandrze bardzo wysoka, w bazach relacyjnych zależna od konfiguracji. Spójność danych: w Cassandrze konfigurowalna, tak zwana eventual consistency, czyli spójność ostateczna, a w bazach relacyjnych silna, zgodna z ACID. Najlepsze zastosowania: Cassandra do dużych rozproszonych systemów, bazy relacyjne do danych transakcyjnych. W kontekście twierdzenia CAP Cassandra jest klasycznym przykładem systemu AP, czyli stawiającego na dostępność i odporność na podział sieci kosztem natychmiastowej spójności, choć dzięki regulowanej spójności można ją dla wybranych zapytań przesunąć w stronę silniejszej spójności.

Wady i ograniczenia według slajdu: bardziej złożone modelowanie danych; ograniczone możliwości operacji JOIN, a ściślej mówiąc, w CQL złączeń po prostu nie ma; Cassandra nie jest optymalna do skomplikowanych transakcji; projekt zapytań należy planować przed tworzeniem tabel, co prowadzi do denormalizacji danych.

Podsumowanie tego slajdu mówi, że Cassandra zapewnia wysoką dostępność i odporność na awarie, doskonale skaluje się na setki i tysiące serwerów, jest jednym z najpopularniejszych rozwiązań NoSQL dla systemów Big Data i sprawdza się tam, gdzie priorytetem są wydajność i niezawodność. Hasło na dole: Apache Cassandra, dane bez przestojów, skaluj globalnie, przechowuj niezawodnie.

Dalej w wykładzie, już w części o CQL, jest slajd z suchymi faktami, które dobrze nadają się na pytania testowe. Cassandra to baza rodziny kolumn, strona projektu to cassandra kropka apache kropka org. Właściwości: open-source, wysoka dostępność, skalowalność liniowa, partycjonowanie poziome, po angielsku sharding, replikacja typu peer-to-peer, regulowana spójność, czyli tunable consistency, oraz wsparcie dla MapReduce, czyli integracja z Hadoopem. Projektem zarządza Apache Software Foundation, ale pierwotnie Cassandrę stworzył Facebook, do wyszukiwania w skrzynce odbiorczej. Jest zaimplementowana w języku Java, dostępna dla wielu systemów operacyjnych, a pierwsze wydanie ukazało się w dwa tysiące ósmym roku. Skalowalność liniowa oznacza, że dwa razy więcej węzłów daje mniej więcej dwa razy większą przepustowość.

Kolejny slajd dodaje dwa zdania. Pierwsze: Cassandra przechowuje dane w tabelach, każda tabela składa się z wierszy i kolumn, a do zapytań używa się języka CQL, czyli Cassandra Query Language. Drugie: model danych Cassandry jest oparty na zapytaniach i zoptymalizowany pod kątem zapytań, a Cassandra nie obsługuje relacyjnego modelowania danych przeznaczonego dla relacyjnych baz danych.

Do zapamiętania na test: Cassandra to rozproszona baza wide-column bez pojedynczego punktu awarii, z równorzędnymi węzłami peer-to-peer. Hierarchia to klaster, keyspace, tabela, wiersz, kolumna. Cechy: wysoka dostępność, skalowalność pozioma i liniowa, automatyczna replikacja, bardzo szybki zapis, regulowana spójność, sharding, wsparcie dla MapReduce. Stworzył ją Facebook, zarządza nią Apache Software Foundation, napisana jest w Javie, pierwsze wydanie w dwa tysiące ósmym. Wady: trudniejsze modelowanie, brak JOIN, słabe wsparcie dla złożonych transakcji, konieczność projektowania od zapytań i denormalizacja. Wobec baz relacyjnych: skalowanie poziome zamiast pionowego i spójność ostateczna zamiast ACID.

## 8.3. Partycjonowanie danych: klucz partycji, token, Murmur3 i pierścień

Teraz serce architektury Cassandry, czyli partycjonowanie. Pierwszy slajd tej części pokazuje cały przepływ w jednym schemacie, od lewej do prawej. Mamy tabelę Dane z kolumnami user_id, która jest kluczem partycji, event_time i activity. Wiersze to na przykład użytkownik sto jeden z wydarzeniami login dziesiątego stycznia dwa tysiące dwudziestego czwartego, view jedenastego i purchase dwunastego, oraz użytkownik dwieście dwa z login i view. Dane przechodzą przez funkcję haszującą, która z wartości klucza partycji tworzy token, czyli hash partition key. Następnie token jest mapowany do partycji, przy czym partycja to wszystkie wiersze o tym samym kluczu partycji. Na końcu partycja jest umieszczana na węźle w pierścieniu, a pierścień Cassandry składa się z węzłów klastra, na slajdzie z czterech. Podpis w środku pierścienia: partycje danych rozłożone po węzłach na podstawie tokenów. Zauważ, że wszystkie trzy wiersze użytkownika sto jeden trafią do tej samej partycji i na ten sam węzeł, bo mają ten sam klucz partycji.

Dlaczego Cassandra w ogóle stosuje partycjonowanie? Bo w dużych systemach niemożliwe jest przechowywanie wszystkich danych na jednym serwerze. Slajd wymienia trzy problemy jednego serwera: ograniczona pamięć i przestrzeń dyskowa, przeciążenie pojedynczego serwera i niska dostępność, bo awaria tej jednej maszyny wyłącza cały system. Rozwiązaniem jest podział danych na wiele węzłów klastra. Grafika porównuje jeden serwer, gdzie wszystkie dane są na jednej maszynie, z klastrem Cassandry, w którym dane są podzielone na wiele węzłów ułożonych w pierścień.

Następny slajd, zatytułowany po angielsku Data Partitioning, podaje cele partycjonowania: równomierne rozłożenie danych w klastrze, skalowanie poziome, eliminacja wąskich gardeł i wysoka dostępność danych. Podaje też pięć kluczowych pojęć, które za chwilę omówimy po kolei: Partition Key, czyli klucz partycji, Token, Hashing, czyli haszowanie, Token Ring, czyli pierścień tokenów, oraz Virtual Nodes, w skrócie vnodes, czyli węzły wirtualne. Schemat pionowy pokazuje: klucz partycji, na przykład user_id równe sto jeden, przechodzi przez haszowanie, na przykład Murmur3, daje token, na przykład czterdzieści pięć tysięcy sześćset siedemdziesiąt osiem, ten trafia na pierścień tokenów z węzłami od Node 1 do Node 4, a efektem są dane rozproszone, umieszczone na wybranym węźle na podstawie tokenu.

Klucz partycji. Każdy rekord w Cassandrze posiada klucz partycji. Przykład ze slajdu: CREATE TABLE users, w nawiasie user_id typu UUID, login typu TEXT, email typu TEXT, a na końcu PRIMARY KEY i w nawiasie user_id. W tym przypadku user_id jest kluczem partycji. Dlaczego? Bo klucz główny ma tylko jedną kolumnę, a pierwsza część klucza głównego zawsze jest kluczem partycji. Grafika pokazuje rekord z user_id zaczynającym się od pięćset pięćdziesiąt e osiemset cztery zero zero, loginem johndoe i emailem john małpa example kropka com; z rekordu wyciągamy klucz partycji user_id i na jego podstawie dane są umieszczane na węźle klastra.

Rola klucza partycji jest potrójna. Po pierwsze identyfikuje partycję. Po drugie określa położenie danych w klastrze, czyli decyduje, który węzeł je przechowuje. Po trzecie wpływa na wydajność całego systemu, bo zły klucz oznacza nierówne obciążenie węzłów.

Od klucza do tokenu. Ważne zdanie ze slajdu: Cassandra nie przechowuje danych bezpośrednio według klucza. Proces wygląda tak: klucz partycji, następnie funkcja hash, na przykład Murmur3, następnie token będący wynikiem haszowania, a na końcu węzeł klastra, który przechowuje dane. Przykład: wartość klucza user123 trafia do funkcji Hash z argumentem user123, wynikiem jest token osiemset czterdzieści pięć milionów dwieście siedemdziesiąt osiem tysięcy sto dziewięćdziesiąt dziewięć, i na podstawie tego tokenu wybierany jest węzeł, na grafice węzeł drugi. Zdanie podsumowujące: na podstawie tokenu wybierany jest serwer przechowujący dane. Po co ten pośredni krok? Gdybyśmy rozdzielali dane według samej wartości klucza, na przykład alfabetycznie, to klucze nierównomiernie rozłożone, na przykład dużo nazwisk na literę K, przeciążyłyby jeden węzeł. Funkcja haszująca rozprasza nawet podobne klucze po całym zakresie tokenów.

Partycjoner Murmur3Partitioner. To jest domyślny partycjoner Cassandry, a nazwę warto umieć zapisać: Murmur, cyfra trzy, Partitioner, pisane łącznie. Ma trzy zadania: oblicza hash klucza partycji, generuje sześćdziesięcioczterobitowy token i zapewnia równomierny rozkład danych. Zakres tokenów to od minus dwa do potęgi sześćdziesiątej trzeciej do plus dwa do potęgi sześćdziesiątej trzeciej minus jeden, czyli mniej więcej od minus dziewięciu trylionów dwustu dwudziestu trzech biliardów do plus dziewięciu trylionów dwustu dwudziestu trzech biliardów. Dokładnie jest to zakres liczby ze znakiem zapisanej na sześćdziesięciu czterech bitach, czyli typu long. Zapamiętaj asymetrię: dolna granica to dokładnie minus dwa do sześćdziesiątej trzeciej, a górna to dwa do sześćdziesiątej trzeciej minus jeden.

Czym jest sam Murmur3? To szybka, niekryptograficzna funkcja haszująca, zaprojektowana do równomiernego rozkładu danych. Dla danego klucza partycji generuje sześćdziesięcioczterobitową wartość, czyli token, która określa położenie danych w pierścieniu klastra. Słowo niekryptograficzna jest istotne na teście: Murmur3 nie służy do bezpieczeństwa, nie jest jak SHA-256; jest za to bardzo szybka i dobrze rozprasza wartości. Korzyść z jej stosowania to minimalizacja ryzyka nierównomiernego rozkładu danych, po angielsku data skew. Dla ciekawości: starsze wersje Cassandry używały RandomPartitioner opartego na MD5 oraz ByteOrderedPartitioner, który zachowywał kolejność kluczy, ale groził właśnie nierównym rozkładem.

Pierścień tokenów, czyli Token Ring. Wszystkie tokeny są rozmieszczone na logicznym pierścieniu. Na grafice punkt zero jest u góry, minus dwa do sześćdziesiątej trzeciej po lewej, plus dwa do sześćdziesiątej trzeciej po prawej, a wokół okręgu stoją węzły Node A, Node B i Node C, każdy z łukiem w swoim kolorze. Pierścień, bo zakres się zawija: po największym tokenie wracamy do najmniejszego. Każdy węzeł odpowiada za określony zakres tokenów.

Właściwości pierścienia według slajdu: brak centralnego koordynatora, łatwe dodawanie nowych węzłów i równomierne obciążenie klastra. Uwaga na pułapkę: brak centralnego koordynatora nie znaczy, że w Cassandrze w ogóle nie ma pojęcia koordynatora. Dla każdego pojedynczego zapytania węzeł, do którego klient się połączył, pełni rolę koordynatora tego zapytania i przekazuje je do właściwych replik. Ale to może być dowolny węzeł, nie ma jednego stałego mastera. Każdy węzeł wie, kto za jaki zakres tokenów odpowiada, bo węzły wymieniają się tą informacją protokołem plotkowania, czyli gossip.

Jak Cassandra wybiera węzeł? Slajd pokazuje uproszczony przykład. Załóżmy klaster z trzema węzłami: Node A odpowiada za tokeny od zera do stu, Node B od stu jeden do dwustu, a Node C od dwustu jeden do trzystu. Dla rekordu z user_id równym dwanaście tysięcy trzysta czterdzieści pięć otrzymano token sto czterdzieści pięć. Sto czterdzieści pięć należy do zakresu Node B, więc dane zostają zapisane na Node B. Oczywiście prawdziwe tokeny są gigantyczne, a liczby od zera do trzystu to tylko ilustracja. Pamiętaj też, że przy replikacji kolejne kopie trafiają zwykle na następne węzły na pierścieniu, idąc zgodnie z ruchem wskazówek zegara.

Do zapamiętania na test: Cassandra partycjonuje dane, bo jeden serwer ma ograniczoną pamięć i dysk, łatwo go przeciążyć i daje niską dostępność. Cele to równomierny rozkład, skalowanie poziome, brak wąskich gardeł i wysoka dostępność. Ścieżka danych to klucz partycji, funkcja haszująca, token, węzeł. Domyślny partycjoner to Murmur3Partitioner, który z klucza liczy sześćdziesięcioczterobitowy token w zakresie od minus dwa do sześćdziesiątej trzeciej do dwa do sześćdziesiątej trzeciej minus jeden. Murmur3 jest szybki i niekryptograficzny, a jego celem jest uniknięcie data skew. Tokeny tworzą logiczny pierścień, każdy węzeł odpowiada za zakres tokenów, nie ma centralnego koordynatora, a węzeł wybiera się, sprawdzając, do czyjego zakresu należy token.

## 8.4. Partycja, kolumny grupujące, złożony klucz partycji i problem dużych partycji

Partycja danych. W Cassandrze partycja jest zbiorem rekordów o tym samym kluczu partycji. Slajd pokazuje tabelę sensor_data: CREATE TABLE sensor_data, w nawiasie sensor_id typu TEXT, timestamp typu TIMESTAMP, value typu DOUBLE i na końcu PRIMARY KEY, a w nawiasie sensor_id, przecinek, timestamp. Kluczem partycji jest tu sensor_id, czyli pierwszy element klucza głównego. Efekt: wszystkie dane jednego czujnika znajdują się razem. Przykładowa partycja to czujnik sensor01 z czterema wierszami: dziesiąta zero zero z wartością dwadzieścia trzy i jedna dziesiąta, dziesiąta zero jeden z wartością dwadzieścia trzy i cztery dziesiąte, dziesiąta zero dwa z wartością dwadzieścia trzy i dziesiąta zero trzy z wartością dwadzieścia dwa i osiem dziesiątych.

Tu pojawia się bardzo ważne rozróżnienie między kluczem partycji a kolumną grupującą, po angielsku Partition Key i Clustering Column. W zapisie PRIMARY KEY w nawiasie sensor_id przecinek timestamp klucz główny składa się z dwóch części. Partition Key, czyli sensor_id, określa lokalizację danych, czyli na którym węźle i w której partycji leżą. Clustering Column, czyli timestamp, określa kolejność danych wewnątrz partycji. Grafika pokazuje tabelę z czterema wierszami sensor01 i dwie klamry: przy wierszach napis ten sam Partition Key, wszystkie wiersze w tej samej partycji, a przy kolumnie timestamp napis dane posortowane według Clustering Column.

Dlaczego to takie ważne? Bo wewnątrz partycji wiersze są fizycznie przechowywane na dysku posortowane po kolumnach grupujących. Dzięki temu zapytanie o zakres czasu dla jednego czujnika, na przykład od dziesiątej do dziesiątej zero dwa, jest bardzo tanie: Cassandra idzie na jeden węzeł, do jednej partycji i czyta kolejne wiersze po kolei. Łatwa pomyłka na teście: klucz partycji decyduje o tym, gdzie, a kolumna grupująca o tym, w jakiej kolejności. Nie odwrotnie. I jeszcze jedno: cały klucz główny, czyli sensor_id razem z timestamp, jednoznacznie identyfikuje wiersz. Gdyby kluczem głównym był sam sensor_id, każdy nowy pomiar nadpisywałby poprzedni, bo czujnik miałby tylko jeden wiersz.

Złożony klucz partycji, czyli Composite Partition Key. Stosujemy go, gdy jeden atrybut powoduje zbyt dużą partycję. Przykład ze slajdu: PRIMARY KEY, a w nawiasie najpierw drugi, wewnętrzny nawias z customer_id przecinek month, a potem przecinek i order_date. Te podwójne nawiasy to kluczowy szczegół składni. Wewnętrzny nawias mówi: kluczem partycji jest para customer_id i month razem. To, co stoi po nim, czyli order_date, jest kolumną grupującą. Przykład: klient tysiąc jeden i miesiąc styczeń dwa tysiące dwudziestego piątego tworzą jedną partycję, a w niej leżą zamówienia z piątego, dwunastego, dwudziestego i dwudziestego ósmego stycznia, posortowane po dacie. Zamówienia tego samego klienta z lutego trafią już do innej partycji, być może na inny węzeł.

Korzyści złożonego klucza partycji: mniejsze partycje, lepsze rozłożenie danych i szybsze zapytania. Jest też koszt, o którym warto wiedzieć: żeby odczytać dane, trzeba w zapytaniu podać wszystkie kolumny klucza partycji, czyli i klienta, i miesiąc. Zapytanie o wszystkie zamówienia klienta z całego roku to dwanaście zapytań do dwunastu partycji. Ta technika dzielenia partycji przez dodanie do klucza okresu czasu nazywa się bucketing, czyli kubełkowanie.

Teraz przeciwieństwo dobrego projektu, czyli problem dużych partycji. Slajd nazywa to wprost: Bad Design. Przykład: PRIMARY KEY w nawiasie sensor_type przecinek timestamp, gdzie sensor_type ma wartość na przykład temperature. Typów czujników jest kilka, a pomiarów miliony, więc miliony rekordów trafiają do jednej partycji; grafika pokazuje partycję temperature zawierającą wszystkie znaczniki czasu od pierwszego stycznia dwa tysiące dwudziestego piątego, północ, aż do trzydziestego czerwca, dwudziesta trzecia pięćdziesiąt dziewięć. Na slajdzie jest literówka „milony”, oczywiście chodzi o miliony.

Konsekwencje dużej partycji: przeciążony węzeł, długie odczyty i większe zużycie pamięci. Przeciążony węzeł, bo cała partycja leży na jednym węźle i jego replikach, niezależnie od tego, ile węzłów ma klaster. Długie odczyty, bo trzeba przeszukiwać ogromną strukturę. Większe zużycie pamięci, bo przy kompaktowaniu i odczycie Cassandra musi obsługiwać duże indeksy partycji. W praktyce przyjmuje się, że partycja powinna mieć raczej poniżej stu megabajtów i rozsądną liczbę wierszy, choć tej liczby wykład nie podaje.

Do zapamiętania na test: partycja to wszystkie wiersze o tym samym kluczu partycji. W PRIMARY KEY w nawiasie a, b kolumna a jest kluczem partycji i decyduje o położeniu danych, a kolumna b jest kolumną grupującą i decyduje o kolejności wierszy wewnątrz partycji. Złożony klucz partycji zapisujemy w podwójnych nawiasach, na przykład PRIMARY KEY, nawias, nawias, customer_id, przecinek, month, zamknięcie nawiasu, przecinek, order_date, zamknięcie nawiasu; daje mniejsze partycje, lepszy rozkład i szybsze zapytania. Klucz o małej liczbie wartości, jak sensor_type, tworzy gigantyczne partycje, co oznacza przeciążony węzeł, długie odczyty i większe zużycie pamięci.

## 8.5. Węzły wirtualne, rebalancing i dobre praktyki projektowania klucza partycji

Węzły wirtualne, czyli Virtual Nodes, w skrócie vnodes. Slajd mówi, że stosuje się je od Cassandry w wersji dwa x. Na slajdzie jest literówka, napisano Virtuail Nodes, a poprawnie Virtual Nodes. Drobne doprecyzowanie z historii: vnodes pojawiły się w Cassandrze jeden kropka dwa, a od wersji dwa kropka zero są domyślnie włączone; na teście trzymaj się wersji ze slajdu.

Na czym polega idea? Zamiast tego, żeby węzeł odpowiadał za jeden duży, ciągły zakres tokenów, węzeł przechowuje wiele małych zakresów rozsianych po całym pierścieniu. Grafika pokazuje po lewej pierścień, w którym Node A ma jeden duży łuk, czyli jeden duży zakres tokenów, a po prawej pierścień z wieloma małymi punktami należącymi do Node A i ramkę z listą: Token Range 1, Token Range 2, Token Range 3 aż do Token Range N. Liczbą vnodes na fizyczny węzeł steruje w konfiguracji parametr num_tokens; dawniej domyślnie dwieście pięćdziesiąt sześć, w Cassandrze cztery zero domyślnie szesnaście.

Korzyści z vnodes według slajdu: prostsze skalowanie, szybsze rebalansowanie klastra i bardziej równomierne obciążenie. Dlaczego? Wyobraź sobie tort pokrojony na cztery wielkie kawałki dla czterech osób. Gdy przychodzi piąta, trzeba coś odkroić od jednego lub dwóch sąsiadów, a reszta nic nie oddaje. Jeśli zaś tort jest pokrojony na setki małych kawałeczków, nowa osoba dostaje po trochu od wszystkich, więc obciążenie rozkłada się równo, a dane do nowego węzła płyną z wielu źródeł naraz, czyli szybciej.

Dodanie nowego węzła. Grafika pokazuje klaster przed, z trzema węzłami Node A, Node B, Node C, i po dodaniu, z czterema, gdzie Node D jest nowy. Cassandra automatycznie przenosi część tokenów, redystrybuuje dane i zachowuje dostępność systemu, czyli klaster działa w trakcie tej operacji. Na slajdzie jest literówka „redistribuuje”, poprawnie redystrybuuje. Proces ten nazywa się po angielsku Rebalancing, czyli równoważenie.

Dobre praktyki projektowania klucza partycji. Zalecenia są cztery: wysoka kardynalność klucza, czyli dużo różnych wartości; równomierny rozkład wartości; ograniczona wielkość partycji; modelowanie pod konkretne zapytania. Czego unikać? Też czterech rzeczy: bardzo dużych partycji, niewielkiej liczby kluczy, częstych hotspotów, czyli miejsc, do których trafia nieproporcjonalnie dużo ruchu, oraz projektowania jak w relacyjnych bazach danych. Kardynalność to po prostu liczba różnych wartości kolumny. user_id ma wysoką kardynalność, bo użytkowników są miliony. Płeć czy kraj mają niską kardynalność, więc są złym kluczem partycji.

Podsumowanie tej części na slajdzie wylicza sześć najważniejszych faktów. Jeden: Cassandra rozkłada dane przy użyciu klucza partycji. Dwa: klucz jest przekształcany do tokenu przez Murmur3Partitioner. Trzy: token wskazuje węzeł w pierścieniu tokenów. Cztery: dobrze dobrany klucz partycji jest kluczowy dla wydajności. Pięć: węzły wirtualne ułatwiają skalowanie i równoważenie obciążenia. Sześć: najczęstszy problem projektowy to Hot Partition, czyli gorąca partycja. Hasło na dole slajdu, które wraca w wykładzie kilka razy: w Cassandrze wydajność systemu zależy przede wszystkim od poprawnego zaprojektowania klucza partycji.

Do zapamiętania na test: vnodes to wiele małych zakresów tokenów na jednym fizycznym węźle zamiast jednego dużego; dają prostsze skalowanie, szybsze rebalansowanie i równomierne obciążenie; według slajdu stosowane od Cassandry dwa x. Po dodaniu węzła Cassandra sama przenosi część tokenów i danych, bez przerwy w dostępności, a proces nazywa się rebalancing. Dobry klucz partycji ma wysoką kardynalność, równy rozkład, ograniczony rozmiar partycji i wynika z zapytań; unikamy dużych partycji, małej liczby kluczy, hotspotów i myślenia relacyjnego. Najczęstszy problem to hot partition.

## 8.6. Modelowanie danych w Cassandrze: najpierw zapytania

Ta część wykładu zaczyna się od trzech slajdów-infografik z ponumerowanymi hasłami od jednego do dziesięciu, a potem te same idee są rozwinięte na kolejnych slajdach. Omówię je razem.

Hasło pierwsze, Data Modeling w Cassandrze: przepływ wygląda tak, że zapytania, czyli Queries, prowadzą do modelu danych, czyli Data Model, a ten dopiero do bazy Cassandra. Obok trzy pojęcia: Query-Driven Design, czyli projektowanie sterowane zapytaniami, denormalizacja i wydajność odczytu.

Hasło drugie, SQL kontra Cassandra. Po lewej relacyjna baza z tabelą Customers połączoną relacjami z tabelami Orders i Products. Po prawej Cassandra z trzema osobnymi, niepołączonymi tabelami: orders_by_customer, orders_by_product i orders_by_day. Ta konwencja nazewnicza, dane, podkreślnik by, podkreślnik kryterium, jest w świecie Cassandry bardzo typowa: nazwa tabeli mówi, po czym ją odpytujemy.

Hasło trzecie, najpierw zapytania: zapytanie SELECT gwiazdka FROM orders WHERE customer_id równa się znak zapytania prowadzi do modelu danych. Znak zapytania to parametr zapytania przygotowanego, czyli prepared statement. Hasło czwarte, Partition Key: klucz customer_id ze strzałkami do trzech węzłów w pierścieniu, czyli to klucz partycji rozprowadza dane po węzłach.

Hasło piąte, partycja danych: klient o customer_id tysiąc jeden ma swoją partycję, a w niej Order 1, Order 2, Order 3, Order 4 i dalsze. Hasło szóste, Clustering Columns: klucz partycji customer_id plus kolumna grupująca order_date, a na osi czasu zamówienia z pierwszego, trzeciego, piątego i siódmego stycznia dwa tysiące dwudziestego piątego, ułożone chronologicznie. Hasło siódme, denormalizacja: jeden dokument Order ze strzałkami do dwóch tabel, orders_by_customer i orders_by_product, czyli to samo zamówienie zapisujemy w dwóch miejscach.

Hasło ósme, dobry model dla e-commerce: tabela orders_by_customer z kolumnami customer_id, order_date i amount, z trzema wierszami klienta tysiąc jeden: pierwszego stycznia kwota dwieście pięćdziesiąt, trzeciego stycznia trzysta dwadzieścia, piątego stycznia sto osiemdziesiąt. Obok trzy zielone znaczniki: szybki odczyt, dobra skalowalność, małe partycje.

Hasło dziewiąte, zły model, czyli Hot Partition. Kluczem partycji jest country, a wartością POLAND. Wszystkie zamówienia z Polski lądują w jednej czerwonej partycji na jednym serwerze z ostrzegawczym znakiem. Skutki z czerwonymi krzyżykami: przeciążenie, wolniejsze zapytania i hotspot. Gorąca partycja to taka, do której trafia nieproporcjonalnie dużo zapisów albo odczytów. Klaster może mieć sto węzłów, ale jeśli połowa ruchu idzie do jednej partycji, pracują głównie te kilka węzłów, które ją przechowują, czyli jej repliki.

Hasło dziesiąte, podsumowanie, pięć zasad modelowania danych: projektuj pod zapytania, dobierz właściwy Partition Key, używaj Clustering Columns, denormalizuj dane i unikaj dużych partycji.

Teraz rozwinięcie. Najważniejsze zdanie tej części, w cudzysłowie na slajdzie: w Cassandrze najpierw projektuje się zapytania, a dopiero później tabelę. Różnice wobec baz relacyjnych slajd podaje w czterech parach. W SQL idziemy od modelu danych do zapytań, w Cassandrze od zapytań do modelu danych. W SQL stosujemy normalizację, w Cassandrze denormalizację. W SQL mamy JOIN, w Cassandrze brak JOIN. W SQL zapytania są elastyczne, w Cassandrze zapytania są zaprojektowane wcześniej; na slajdzie jest tu zniekształcone słowo „elastyzanie”, a sens jest taki, że zapytania są ustalone z góry. Hasło z żarówką: Cassandra to baza zaprojektowana pod dużą skalę i przewidywalną wydajność, dlatego model danych musi wynikać z potrzeb zapytań.

Query-Driven Design, czyli projektowanie pod zapytania. Przed utworzeniem tabel należy określić cztery rzeczy: jakie dane będą odczytywane, jak często, po jakich polach będą wyszukiwane i jakie są wymagania wydajnościowe. Proces projektowania to pionowy przepływ: Business Question, czyli pytanie biznesowe, potem Query, czyli zapytanie, potem Data Model, czyli model danych, i na końcu Table, czyli tabela.

Dlaczego Cassandra różni się od SQL? Bo została zaprojektowana dla dużej skali, wysokiej dostępności, rozproszenia geograficznego i przewidywalnej wydajności. Dlatego ogranicza JOIN, GROUP BY na dużą skalę, złożone relacje między tabelami i zapytania ad-hoc na wszystkich danych. Zapytanie ad-hoc to takie wymyślone na bieżąco, na przykład znajdź wszystkich klientów, którzy w marcu kupili coś czerwonego. W bazie relacyjnej optymalizator coś wymyśli. W Cassandrze takie zapytanie wymagałoby przejrzenia wszystkich partycji na wszystkich węzłach, co przy skali Cassandry jest nieakceptowalne. Ramka informacyjna: Cassandra to rozproszona baza NoSQL zaprojektowana do obsługi bardzo dużych ilości danych w wielu centrach danych.

Przykład projektowania od zapytań. Wymaganie biznesowe: pokaż wszystkie pomiary dla czujnika z ostatnich dwudziestu czterech godzin. Zapytanie: SELECT gwiazdka FROM sensor_data WHERE sensor_id równa się znak zapytania AND timestamp większe lub równe znak zapytania AND timestamp mniejsze lub równe znak zapytania, średnik. Model tabeli: CREATE TABLE sensor_data z kolumnami sensor_id TEXT, timestamp TIMESTAMP, value DOUBLE i PRIMARY KEY w nawiasie sensor_id, timestamp. Zielony znacznik mówi: Partition Key wynika bezpośrednio z potrzeb zapytania. Zauważ, jak to pasuje: warunek równości jest na kluczu partycji, więc Cassandra wie, do której partycji iść, a warunek zakresu jest na kolumnie grupującej, po której dane są posortowane, więc czyta ciągły fragment. To wzorzec idealnego zapytania w Cassandrze: równość na kluczu partycji, zakres na kolumnie grupującej.

Denormalizacja danych. W bazach relacyjnych mamy Customers, Orders i Products połączone relacjami za pomocą JOIN. W Cassandrze zamiast tego mamy osobne tabele: customer_orders, czyli zamówienia klienta jako dane zdenormalizowane, customer_products, czyli produkty klienta, co oznacza duplikację danych, i customer_statistics, czyli statystyki klienta jako oddzielny widok danych. Ta sama informacja może występować w wielu tabelach. Definicja ze slajdu, warta zapamiętania dosłownie: denormalizacja to celowe powielenie danych dla szybszych odczytów. Ceną jest więcej miejsca na dysku i konieczność zapisania tej samej informacji do kilku tabel przy każdej zmianie. W Cassandrze to się opłaca, bo dysk jest tani, a zapisy bardzo szybkie, natomiast złączeń po prostu nie ma.

Jedna tabela dla jednego wzorca odczytu. Każda tabela powinna obsługiwać konkretne zapytanie. Przykłady: zamówienia według klienta to SELECT gwiazdka FROM orders_by_customer WHERE customer_id równa się znak zapytania. Zamówienia według statusu to SELECT gwiazdka FROM orders_by_status WHERE status równa się znak zapytania. Zamówienia według produktu to SELECT gwiazdka FROM orders_by_product WHERE product_id równa się znak zapytania. Zielony znacznik: różne zapytania to różne tabele, nie ma jednej uniwersalnej tabeli. Mała uwaga ode mnie: tabela orders_by_status z samym statusem jako kluczem partycji miałaby niską kardynalność, bo statusów jest kilka, więc w praktyce trzeba by dodać do klucza na przykład dzień. Slajd tego nie omawia, ale pokazuje, że zasady z poprzednich slajdów trzeba stosować razem.

Kiedy tworzyć nową tabelę? Jeżeli pojawia się nowe zapytanie, na przykład SELECT gwiazdka FROM orders WHERE product_id równa się znak zapytania, a tabela orders nie ma product_id w kluczu partycji, to często tworzy się nową tabelę orders_by_product zoptymalizowaną pod to nowe zapytanie. Reguła: nowe ważne zapytanie często oznacza nową tabelę.

Najczęstsze błędy modelowania, sześć pozycji: projektowanie jak w Oracle, czyli myślenie relacyjne; próba używania JOIN; używanie ALLOW FILTERING; zbyt duże partycje; niska kardynalność klucza partycji; jedna tabela do wszystkiego. Ostrzeżenie na slajdzie: te błędy prowadzą do niskiej wydajności, nierównomiernego rozkładu danych i problemów ze skalowaniem. O ALLOW FILTERING powiemy dokładniej przy SELECT; na razie zapamiętaj, że jego nadużywanie to sygnał złego modelu.

Cykl projektowania danych na ostatnim slajdzie tej części to sześć kroków: Business Requirement, czyli wymaganie biznesowe, na slajdzie z literówką Requieement; dalej Query, czyli zapytanie do danych; Partition Key, czyli wybór klucza partycji; Clustering Column, czyli określenie kolejności danych; Table, czyli utworzenie tabeli; i Validation, czyli weryfikacja i testy. Kolejność ma znaczenie: tabela pojawia się dopiero na piątym miejscu.

Podsumowanie, sześć najważniejszych zasad: projektuj pod zapytania; Partition Key jest najważniejszą decyzją; Cassandra preferuje denormalizację; jedno zapytanie to często jedna tabela; unikaj myślenia relacyjnego; wydajność zależy od modelu danych bardziej niż od sprzętu. I raz jeszcze hasło: w Cassandrze wydajność systemu zależy przede wszystkim od poprawnego zaprojektowania klucza partycji.

Do zapamiętania na test: w Cassandrze idziemy od zapytań do modelu danych, w SQL odwrotnie; Cassandra to denormalizacja, brak JOIN i zapytania zaplanowane z góry. Przed tworzeniem tabel ustalamy, jakie dane czytamy, jak często, po jakich polach i z jakimi wymaganiami wydajności. Denormalizacja to celowe powielanie danych dla szybszych odczytów. Jedna tabela obsługuje jeden wzorzec odczytu, a nowe ważne zapytanie to często nowa tabela, nazywana według wzorca dane, podkreślnik by, podkreślnik kryterium. Hot partition to partycja przeciążona ruchem, na przykład wszystko z kluczem country równym POLAND. Typowe błędy to myślenie jak w Oracle, JOIN, ALLOW FILTERING, duże partycje, niska kardynalność klucza i jedna tabela do wszystkiego. Cykl: wymaganie, zapytanie, klucz partycji, kolumna grupująca, tabela, walidacja.

## 8.7. Model danych Cassandry: przestrzeń kluczy, tabele, wartości, kolekcje, TTL i timestamp

Teraz zaczyna się druga, bardziej formalna część wykładu, prowadząca do języka CQL. Struktura bazy danych: instancja, potem przestrzeń kluczy, potem tabele, potem wiersze, potem kolumny.

Przestrzeń kluczy, po angielsku keyspace, to odpowiednik bazy danych albo schematu w świecie relacyjnym; na jednym ze slajdów jest wprost ramka: przestrzeń kluczy równa się baza danych. Tabela, czyli dawna rodzina kolumn, to kolekcja podobnych wierszy, przy czym wiersze nie muszą mieć dokładnie tych samych kolumn. Ważne: schemat tabeli musi być podany, ale może być modyfikowany później. To odróżnia Cassandrę od MongoDB, gdzie kolekcja nie ma schematu. W Cassandrze kolumny tabeli są zadeklarowane z typami, a elastyczność polega na tym, że wiersz nie musi mieć wartości we wszystkich kolumnach i że nieobecna wartość nie zajmuje miejsca. Wiersz to kolekcja kolumn i każdy wiersz jest jednoznacznie identyfikowalny przez wymagany klucz główny. Kolumna to para klucz-wartość plus inne metadane, przy czym kluczem jest tu nazwa kolumny.

Slajd z przykładem pokazuje cały mały skrypt. Pierwsze polecenie: CREATE KEYSPACE IF NOT EXISTS store WITH REPLICATION równa się, i w klamrach mapa: w apostrofach class, dwukropek, w apostrofach SimpleStrategy, przecinek, w apostrofach replication_factor, dwukropek, w apostrofach jeden; zamknięcie klamry i średnik. Drugie: CREATE TABLE IF NOT EXISTS store kropka shopping_cart, czyli tabela shopping_cart w przestrzeni kluczy store, z kolumnami userid typu text z dopiskiem PRIMARY KEY, item_count typu int i last_update_timestamp typu timestamp. Trzecie i czwarte: dwa polecenia INSERT INTO store kropka shopping_cart, w nawiasie userid, item_count, last_update_timestamp, VALUES, a w nawiasie w apostrofach dziewięć osiem siedem sześć, dwa i toTimeStamp, nawias, now, nawias otwierający i zamykający, nawias zamykający; w drugim wierszu userid jeden dwa trzy cztery i item_count pięć. Funkcja now zwraca bieżący identyfikator czasowy typu timeuuid, a toTimeStamp zamienia go na wartość typu timestamp. Zwróć uwagę na dwa szczegóły. Po pierwsze userid jest tekstem, więc dziewięć osiem siedem sześć jest w apostrofach. Po drugie nazwę tabeli można kwalifikować nazwą przestrzeni kluczy przez kropkę, tak jak schemat w SQL.

Wartości kolumn. Kolumna może być pusta, czyli mieć wartość null. Może zawierać wartości atomowe, a do nich slajd zalicza trzy rodzaje: natywne typy danych, czyli ciągi znaków, liczby, daty i tak dalej; krotki, po angielsku tuples, które wykład opisuje jako analogię do kolekcji deskryptorów, czyli ustalony ciąg kilku wartości; oraz typy definiowane przez użytkownika, w skrócie UDT od User Defined Types, czyli zbiór nazwanych pól dowolnego typu, coś jak struktura w języku C. Trzecia kategoria to kolekcje: listy, zbiory i mapy. Ważne zdanie o zagnieżdżaniu: zagnieżdżone krotki, typy definiowane przez użytkownika czy kolekcje są dozwolone, jednak tylko w trybie frozen, czyli zamrożonym. Co to znaczy? Wartość frozen jest serializowana jako jeden blok, jak jedna wartość atomowa. Nie można jej zmieniać kawałkami, na przykład dodać jednego elementu; można ją tylko zastąpić w całości. Składniowo pisze się na przykład LIST, ostry nawias, FROZEN, ostry nawias, SET, ostry nawias, TEXT, i trzy zamknięcia ostrych nawiasów. Krotki są w Cassandrze zawsze traktowane jak zamrożone.

Kolekcje dokładniej. Lista to uporządkowana kolekcja wartości: porządek zależy od pozycji danej, a wartości nie muszą być unikalne, czyli duplikaty są dozwolone. Zbiór to kolekcja unikalnych wartości, a wartości są wewnętrznie uporządkowane, czyli posortowane, niezależnie od kolejności, w jakiej je wstawiono. Mapa to kolekcja par klucz-wartość, klucze muszą być unikalne, a pary są wewnętrznie uporządkowane na podstawie kluczy. To jest typowa pułapka testowa. W wielu językach programowania zbiór i mapa nie mają porządku. W Cassandrze mają: zbiór jest sortowany według wartości, a mapa według kluczy. Lista natomiast zachowuje kolejność pozycji, a nie sortuje.

Przykładowe dane: tabela aktorzy. Każdy wiersz ma kolumnę id oraz kolumny dane, rok i filmy. Aktor o id stallone ma dane w postaci krotki w nawiasach okrągłych, S i Stallone, rok tysiąc dziewięćset sześćdziesiąt cztery i filmy jako zbiór w klamrach: Rambo i Niezniszczalni. Aktor schwarzenegger ma krotkę A, Schwarzenegger, rok tysiąc dziewięćset sześćdziesiąt sześć i zbiór trzech filmów: Niezniszczalni, Pamięć absolutna i Conan. Snipes ma krotkę W, Snipes, rok tysiąc dziewięćset siedemdziesiąt trzy i zbiór z jednym filmem Pasażer pięćdziesiąt siedem. Norris ma krotkę C, Norris, rok tysiąc dziewięćset trzydzieści sześć i zbiór Strażnik Teksasu. Wartości roku są tu przykładowe i nie pokrywają się z rzeczywistymi latami urodzenia aktorów, więc nie ucz się ich jako faktów biograficznych. Na slajdzie w id schwarzenegger jest zbędna spacja przed apostrofem zamykającym. Najważniejsza lekcja: krotka zapisuje się w nawiasach okrągłych, a zbiór w klamrach.

Druga tabela przykładowa: filmy, z kolumnami id, tytul, rezyser, rok, wlasciwosci, aktorzy i gatunki. Wiersze mają różne zestawy wypełnionych kolumn i to jest ilustracja tego, że wiersze nie muszą być identyczne. Film nietykalni ma tytuł Nietykalni, rok dwa tysiące jedenaście, aktorzy null i gatunki jako listę w nawiasach kwadratowych: komedia, dramat. Film niezniszczalni ma tytuł Niezniszczalni, reżysera jako krotkę Sylvester, Stallone, rok dwa tysiące dziesięć, wlasciwosci jako wartość typu definiowanego przez użytkownika w klamrach, dlugosc dwukropek sto, oraz aktorów jako mapę w klamrach: klucz stallone z wartością Sylvester i klucz jet z wartością Li. Na slajdzie w tej mapie jest literówka, przed Li stoi przecinek zamiast apostrofu, poprawnie wartość to Li w apostrofach. Film tombraider ma tylko tytuł Tomb Raider i rok dwa tysiące jeden. Film hobbit ma tytuł Hobbit, rok dwa tysiące dwanaście, aktorów jako pustą mapę, czyli same klamry, i gatunki fantasy i przygoda. Ciekawostka techniczna: w Cassandrze pusta kolekcja i null są w praktyce tym samym; zapisanie pustej kolekcji oznacza brak wartości.

Porównaj literały, bo to najważniejsze z tej tabeli. Lista w nawiasach kwadratowych. Zbiór w klamrach z samymi wartościami. Mapa w klamrach z parami, gdzie klucz i wartość oddziela dwukropek, a oba są literałami, na przykład w apostrofach. Wartość UDT też w klamrach z dwukropkami, ale po lewej stronie dwukropka stoi nazwa pola bez apostrofów, jak dlugosc. Krotka w nawiasach okrągłych.

Dodatkowe dane, czyli metadane. Mogą być związane z całą kolumną w przypadku danych atomowych albo z poszczególnym, indywidualnym elementem kolekcji. Każdy element listy, zbioru czy mapy może mieć własne metadane. Są dwa rodzaje metadanych. Pierwszy to czas życia, po angielsku Time-to-live, w skrócie TTL: po określonej liczbie sekund dana kolumna lub element jest automatycznie niszczony. Jednostką są sekundy. Drugi to czas modyfikacji, po angielsku timestamp: czas dokonania ostatniej modyfikacji, przyporządkowywany automatycznie albo ręcznie. Ten znacznik czasu służy Cassandrze do rozstrzygania konfliktów zgodnie z zasadą last write wins, czyli wygrywa zapis z późniejszym znacznikiem czasu. Zarówno zwykłe dane, jak i te dodatkowe mogą być przedmiotem zapytań, ale nie dotyczy to kolekcji i ich elementów. Czyli możesz zapytać o TTL i czas zapisu zwykłej kolumny, ale według wykładu nie kolekcji.

Do zapamiętania na test: hierarchia to instancja, przestrzeń kluczy, tabela, wiersz, kolumna; przestrzeń kluczy to odpowiednik bazy danych. Schemat tabeli trzeba podać, ale można go później zmieniać, a wiersze nie muszą mieć tych samych kolumn. Wiersz identyfikuje wymagany klucz główny, a kolumna to para nazwa-wartość z metadanymi. Wartość może być null, atomowa, czyli typ natywny, krotka lub UDT, albo kolekcją: listą, zbiorem lub mapą; zagnieżdżenia tylko jako frozen. Lista jest uporządkowana pozycyjnie i dopuszcza duplikaty, zbiór ma unikalne wartości posortowane, a mapa unikalne klucze i jest sortowana po kluczach. Literały: krotka w nawiasach okrągłych, lista w kwadratowych, zbiór, mapa i UDT w klamrach. Metadane to TTL w sekundach, po którym dane znikają, oraz timestamp ostatniej modyfikacji; nie można o nie pytać dla kolekcji.

## 8.8. Narzędzia: cqlsh, sterowniki i język CQL

Jak rozmawiamy z Cassandrą? Podstawowym narzędziem jest CQLSH, czyli CQL shell, interaktywna konsola do wydawania komend. Uruchamia się ją z katalogu instalacji poleceniem bin, ukośnik, cqlsh. Wykorzystuje ona język CQL, czyli Cassandra Query Language. Odpowiednikiem w MongoDB był mongosh.

Drugą drogą są sterowniki klienckie, czyli drivers. Są dostarczone przez społeczność i dostępne dla wielu różnych języków programowania, na przykład Java, Python, Ruby, PHP, C plus plus, Scala, Erlang i innych.

Sam język CQL. To deklaratywny język zapytań zainspirowany przez SQL. Deklaratywny, czyli mówimy, co chcemy dostać, a nie jak to obliczyć. Wykład dzieli polecenia na dwie grupy, tak jak w SQL. Wyrażenia DDL, czyli Data Definition Language, definiujące strukturę: CREATE KEYSPACE, które tworzy nową przestrzeń kluczy, i CREATE TABLE, które tworzy nową tabelę. Do tej grupy należą też omawiane dalej USE, DROP, ALTER, TRUNCATE i CREATE TYPE. Wyrażenia DML, czyli Data Manipulation Language, operujące na danych: SELECT wybiera wiersze z pojedynczej tabeli, INSERT dodaje wiersze do tabeli, UPDATE aktualizuje kolumny w wierszach, a DELETE usuwa wiersze z tabeli. Zwróć uwagę na precyzję sformułowania przy SELECT: z pojedynczej tabeli. To od razu sygnalizuje brak złączeń.

Do zapamiętania na test: cqlsh to interaktywna konsola, uruchamiana jako bin, ukośnik, cqlsh, mówiąca językiem CQL. Sterowniki są tworzone przez społeczność dla wielu języków, w tym Javy, Pythona, Ruby, PHP, C plus plus, Scali i Erlanga. CQL to deklaratywny język inspirowany SQL; do DDL należą CREATE KEYSPACE i CREATE TABLE, a do DML SELECT, INSERT, UPDATE i DELETE. SELECT działa zawsze na jednej tabeli.

## 8.9. DDL: przestrzeń kluczy i replikacja

CREATE KEYSPACE tworzy nową przestrzeń kluczy. Diagram składni na slajdzie wygląda tak: słowo CREATE, słowo KEYSPACE, opcjonalnie trzy słowa IF NOT EXISTS, potem nazwa przestrzeni kluczy, słowo WITH, a następnie nazwa opcji, znak równości i wartość opcji; par opcja równa się wartość może być kilka, łączy się je słowem AND. Klauzula IF NOT EXISTS sprawia, że jeśli taka przestrzeń już istnieje, polecenie nie zgłosi błędu, tylko nic nie zrobi.

Najważniejsza informacja: opcja replication jest obowiązkowa. Nie da się utworzyć przestrzeni kluczy bez określenia, jak dane mają być replikowane, bo replikacja jest właściwością przestrzeni kluczy, a nie tabeli. Opcja replication jest mapą i ma dwie strategie. Pierwsza to SimpleStrategy, czyli prosta strategia, w której jest tylko jeden poziom replikacji, jeden współczynnik dla całego klastra; nadaje się do jednego centrum danych, typowo do testów i nauki. Druga to NetworkTopologyStrategy, czyli strategia świadoma topologii sieci, w której ustawia się indywidualny poziom replikacji dla każdego centrum danych osobno. To ona jest zalecana w produkcji.

Przykład ze slajdu: CREATE KEYSPACE filmydb WITH replication równa się, klamra, w apostrofach class, dwukropek, w apostrofach SimpleStrategy, przecinek, w apostrofach replication_factor, dwukropek, trzy, zamknięcie klamry. Replication factor trzy oznacza, że każda partycja będzie przechowywana na trzech węzłach. Dla NetworkTopologyStrategy zamiast replication_factor podaje się nazwy centrów danych z liczbami, na przykład w apostrofach DC1 dwukropek trzy, w apostrofach DC2 dwukropek dwa. Zwróć uwagę na typowe szczegóły: słowo WITH, znak równości po replication, wartość w klamrach jak mapa, nazwy kluczy w apostrofach. Ramka na slajdzie przypomina: przestrzeń kluczy to odpowiednik bazy danych.

Pozostałe polecenia dla przestrzeni kluczy. USE zmienia aktualnie używaną przestrzeń kluczy; składnia to po prostu USE i nazwa, na przykład USE filmydb. Po tym tabele można podawać bez prefiksu przestrzeni. To odpowiednik use w mongosh albo USE w MySQL. DROP KEYSPACE usuwa przestrzeń kluczy, wszystkie jej tabele i dane; składnia to DROP KEYSPACE, nazwa i opcjonalnie IF EXISTS. Uwaga na kolejność w diagramie ze slajdu: pokazuje IF EXISTS po nazwie, natomiast w faktycznej składni CQL zapisuje się DROP KEYSPACE IF EXISTS nazwa, czyli IF EXISTS przed nazwą, analogicznie do CREATE KEYSPACE IF NOT EXISTS nazwa. To samo dotyczy DROP TABLE. ALTER KEYSPACE modyfikuje opcje związane z daną przestrzenią kluczy, na przykład zmienia współczynnik replikacji albo strategię.

Do zapamiętania na test: CREATE KEYSPACE nazwa WITH replication równa się mapa w klamrach; opcja replication jest obowiązkowa. SimpleStrategy ma jeden współczynnik replikacji, ustawiany przez replication_factor, a NetworkTopologyStrategy osobny współczynnik dla każdego centrum danych. USE wybiera przestrzeń kluczy, DROP KEYSPACE usuwa ją razem ze wszystkimi tabelami i danymi, ALTER KEYSPACE zmienia jej opcje. IF NOT EXISTS przy tworzeniu i IF EXISTS przy usuwaniu chronią przed błędem.

## 8.10. DDL: tabele i klucze główne

CREATE TABLE tworzy nową tabelę w aktualnej przestrzeni kluczy, chyba że nazwę poprzedzimy nazwą przestrzeni i kropką. Każda tabela musi mieć dokładnie jeden podany klucz główny. Diagram składni: CREATE TABLE, opcjonalnie IF NOT EXISTS, nazwa tabeli, nawias otwierający, potem lista definicji kolumn oddzielonych przecinkami, gdzie każda to nazwa kolumny, typ i opcjonalnie słowa PRIMARY KEY, a na końcu opcjonalnie przecinek i definicja klucza głównego na poziomie tabeli, i nawias zamykający. Kolejna ważna reguła: żadna z kolumn nie jest wymagana poza kluczem głównym. Czyli wstawiając wiersz, możesz pominąć wszystkie kolumny poza tymi, które tworzą klucz główny.

Przykłady tabel aktorzy i filmy. Tabela aktorzy: CREATE TABLE aktorzy, nawias, id TEXT PRIMARY KEY, przecinek, dane TUPLE, ostry nawias, TEXT, przecinek, TEXT, zamknięcie ostrego nawiasu, przecinek, rok SMALLINT, przecinek, filmy SET, ostry nawias, TEXT, zamknięcie, i nawias zamykający. Czyli dane to krotka dwóch tekstów, rok to mała liczba całkowita, a filmy to zbiór tekstów. Tabela filmy: id TEXT, tytul TEXT, rezyser TUPLE z dwoma tekstami, rok SMALLINT, aktorzy MAP, ostry nawias, TEXT, przecinek, TEXT, zamknięcie, gatunki LIST z TEXT, kraje SET z TEXT, wlasciwosci typu szczegoly, który jest typem definiowanym przez użytkownika, i na końcu PRIMARY KEY w nawiasie id. Zwróć uwagę, że w pierwszej tabeli klucz zdefiniowano przy kolumnie, a w drugiej na poziomie tabeli; dla jednej kolumny efekt jest identyczny.

Klucze główne. Przykład w ramce na slajdzie: CREATE TABLE IF NOT EXISTS store kropka shopping_cart, nawias, userid TEXT, item_count INT, last_update_timestamp TIMESTAMP, PRIMARY KEY, nawias, nawias, userid, zamknięcie, przecinek, last_update_timestamp, zamknięcie, zamknięcie nawiasu tabeli, a potem WITH CLUSTERING ORDER BY, nawias, last_update_timestamp DESC, zamknięcie, średnik. Ta klauzula WITH CLUSTERING ORDER BY ustala domyślny porządek przechowywania wierszy w partycji, tutaj malejąco, czyli najnowsze na początku. Nawias wokół samego userid jest tu zbędny, ale dopuszczalny i czytelnie pokazuje, co jest kluczem partycji.

Klucz główny ma dwie części. Pierwsza to obowiązkowy klucz partycjonujący: przynajmniej jedna kolumna, która definiuje, jak poszczególne wiersze są rozdzielane na partycje. Na slajdzie jest słowo „dystrybułowane”, poprawnie dystrybuowane, czyli rozdzielane. Druga część to opcjonalne kolumny grupujące, czyli clustering columns, które definiują kolejność, w jakiej poszczególne wiersze są lokalnie przechowywane wewnątrz partycji.

Są dwa sposoby zdefiniowania klucza głównego. Definicja na poziomie kolumny, czyli dopisanie PRIMARY KEY bezpośrednio po typie kolumny: wtedy ta pojedyncza kolumna staje się kluczem partycjonującym i nie ma kolumn grupujących. Definicja na poziomie tabeli, czyli osobna pozycja PRIMARY KEY, nawias, lista kolumn: wtedy pierwsza kolumna albo wszystkie kolumny ujęte w wewnętrzny nawias stają się kluczem partycjonującym, a wszystkie pozostałe kolumny, jeśli są, przyjmują rolę kolumn grupujących. Tu ważna poprawka: na slajdzie napisano „w nawiasach klamrowych”, ale chodzi o nawiasy okrągłe. Złożony klucz partycji zapisuje się w wewnętrznych nawiasach okrągłych, jak PRIMARY KEY, nawias, nawias, a, przecinek, b, zamknięcie, przecinek, c, zamknięcie. Klamry w CQL oznaczają zbiory, mapy i wartości UDT, nie części klucza.

Przećwiczmy trzy warianty, bo to pewne pytanie testowe. PRIMARY KEY w nawiasie a: kluczem partycji jest a, kolumn grupujących brak. PRIMARY KEY w nawiasie a, b, c: kluczem partycji jest samo a, a b i c są kolumnami grupującymi, w tej kolejności. PRIMARY KEY, nawias, nawias a, b, zamknięcie, przecinek c: kluczem partycji jest para a i b, a c jest kolumną grupującą. Częsty błąd to uznanie, że w drugim wariancie kluczem partycji jest cała trójka; nie, bez wewnętrznego nawiasu kluczem partycji jest tylko pierwsza kolumna.

Pozostałe polecenia dla tabel. DROP TABLE usuwa tabelę wraz z danymi, które zawiera; składnia to DROP TABLE, nazwa, opcjonalnie IF EXISTS, a w rzeczywistym CQL IF EXISTS stoi przed nazwą. TRUNCATE zachowuje tabelę, ale usuwa zawarte w niej dane; składnia to TRUNCATE, opcjonalnie słowo TABLE, i nazwa tabeli. Na slajdzie jest literówka „zachowuję”, chodzi o zachowuje. Różnica jest klasyczna: po DROP tabeli nie ma, po TRUNCATE tabela jest, ale pusta. ALTER TABLE umożliwia zmianę, dodanie bądź usunięcie kolumn tabeli. W praktyce Cassandra pozwala dodać kolumnę przez ALTER TABLE nazwa ADD kolumna typ i usunąć przez DROP kolumna, natomiast kolumn klucza głównego nie da się ani usunąć, ani zmienić; klucz główny jest ustalony na zawsze.

Do zapamiętania na test: każda tabela ma dokładnie jeden klucz główny, a poza nim żadna kolumna nie jest wymagana. Klucz główny to obowiązkowy klucz partycjonujący, minimum jedna kolumna, decydujący o rozdziale na partycje, plus opcjonalne kolumny grupujące, decydujące o kolejności wierszy w partycji. PRIMARY KEY przy kolumnie daje klucz partycji z jednej kolumny bez kolumn grupujących. PRIMARY KEY na poziomie tabeli: pierwsza kolumna albo grupa w wewnętrznych nawiasach okrągłych to klucz partycji, reszta to kolumny grupujące. WITH CLUSTERING ORDER BY ustala kierunek sortowania. DROP TABLE usuwa tabelę z danymi, TRUNCATE usuwa tylko dane, ALTER TABLE zmienia, dodaje lub usuwa kolumny.

## 8.11. Typy danych: natywne, krotki, kolekcje i typy użytkownika

Typy kolumn w Cassandrze należą do czterech grup: typy natywne, krotki, kolekcje, czyli listy, zbiory i mapy, oraz typy definiowane przez użytkownika. Diagram składni typu na slajdzie wymienia: typ natywny albo TUPLE z listą typów w ostrych nawiasach, albo LIST z jednym typem, SET z jednym typem, MAP z dwoma typami, klucza i wartości, albo nazwę typu użytkownika.

Natywne typy liczbowe. Liczby całkowite ze znakiem w czterech rozmiarach: tinyint na jednym bajcie, smallint na dwóch bajtach, int na czterech bajtach i bigint na ośmiu bajtach. Zapamiętaj kolejność: tiny, small, int, big, czyli jeden, dwa, cztery, osiem bajtów. Dalej varint, który slajd opisuje jako liczbę całkowitą o ustalonej precyzji. Precyzyjniej, według dokumentacji Cassandry varint to liczba całkowita o dowolnej, zmiennej precyzji, czyli bez limitu rozmiaru, jak BigInteger w Javie. Podobnie decimal, który slajd opisuje jako liczbę rzeczywistą o ustalonej precyzji, w dokumentacji jest opisany jako liczba dziesiętna o zmiennej precyzji, jak BigDecimal; ważne, że jest dokładna, bez błędów zaokrągleń typowych dla liczb zmiennoprzecinkowych, więc nadaje się do pieniędzy. Na teście najważniejsze rozróżnienie: varint to liczba całkowita, decimal to liczba rzeczywista. Następnie float i double, czyli liczby rzeczywiste zmiennoprzecinkowe na czterech i ośmiu bajtach. I boolean z wartościami true i false.

Natywne typy tekstowe i czasowe. text oraz varchar, które są synonimami, to ciąg znaków w kodowaniu UTF-8. Bardzo ważna reguła składniowa: literał tekstowy zapisuje się w pojedynczych apostrofach, a nie w cudzysłowie. W CQL cudzysłów podwójny służy do nazw, czyli identyfikatorów, na przykład gdy nazwa kolumny ma wielkie litery. Typ ascii to ciąg znaków w kodowaniu ASCII. Dalej date, time i timestamp, czyli data, czas i znacznik czasu. Przykłady literałów ze slajdu: w apostrofach dwa tysiące dwadzieścia dwa, myślnik, dwanaście, myślnik, zero jeden dla daty; w apostrofach ta sama data ze spacją i godziną dziewiąta piętnaście zero zero dla znacznika czasu; oraz liczba tysiąc czterysta dziewięćdziesiąt milionów dziewięćset dwadzieścia trzy tysiące sto dziesięć. Drobna uwaga: liczbowy timestamp w CQL jest interpretowany jako liczba milisekund od początku epoki uniksowej, a liczba ze slajdu wygląda raczej na liczbę sekund, więc potraktuj ją jako ilustrację formatu.

Typ counter, czyli licznik. To ośmiobajtowa liczba całkowita ze znakiem, która wspiera tylko dwie operacje: inkrementację i dekrementację. Nie można ustawić konkretnej wartości licznika. Zapisujemy to na przykład jako UPDATE tabela SET wyswietlenia równa się wyswietlenia plus jeden WHERE klucz i tak dalej. Restrykcje są trzy i często pojawiają się na testach. Liczniki nie mogą być częścią klucza głównego. Albo wszystkie kolumny poza kluczem głównym są licznikami, albo żadna, czyli liczników nie mieszamy w jednej tabeli ze zwykłymi kolumnami. I czas życia, TTL, nie jest dla liczników wspierany. Na slajdzie jest literówka „wpiera”, chodzi o wspiera. Liczników nie wstawia się też poleceniem INSERT, tylko modyfikuje przez UPDATE.

Pozostałe typy natywne: blob, czyli dowolny zestaw danych binarnych; inet, czyli adres IP, zarówno w wersji cztery, jak i sześć; oraz uuid, czyli uniwersalny unikalny identyfikator. Istnieje też timeuuid, czyli UUID zawierający znacznik czasu, którego używa wspomniana funkcja now. Slajd odsyła do dokumentacji typów na stronie cassandra kropka apache kropka org.

Krotki, po angielsku tuples. Na slajdzie w tytule jest literówka „Kropki”, chodzi oczywiście o krotki. Deklaracja to słowo TUPLE, ostry nawias, lista typów oddzielonych przecinkami, zamknięcie ostrego nawiasu, na przykład TUPLE, ostry nawias, TEXT, przecinek, TEXT. Literał to nawias okrągły z wartościami po przecinku, na przykład w nawiasie: w apostrofach Numer, przecinek, w apostrofach sto dwadzieścia trzy, myślnik, czterysta pięćdziesiąt sześć, myślnik, siedemset osiemdziesiąt dziewięć. Krotka ma stałą liczbę pozycji o ustalonych typach, a pola nie mają nazw, tylko pozycje.

Kolekcje. Zbiór: deklaracja SET, ostry nawias, typ, zamknięcie; literał w klamrach, na przykład klamra, w apostrofach Niezniszczalni, przecinek, w apostrofach Rambo, zamknięcie klamry. Lista: deklaracja LIST, ostry nawias, typ, zamknięcie; literał w nawiasach kwadratowych, na przykład w kwadratowych nawiasach komedia i dramat. Mapa: deklaracja MAP, ostry nawias, typ klucza, przecinek, typ wartości, zamknięcie; literał w klamrach z parami klucz dwukropek wartość, na przykład klamra, w apostrofach rezyser, dwukropek, w apostrofach Sylwester Stallone, zamknięcie klamry. Pułapka: zbiór i mapa oba używają klamer. Rozróżnia je dwukropek: jeśli w klamrach są pary z dwukropkiem, to mapa, jeśli same wartości, to zbiór.

Typy definiowane przez użytkownika, czyli UDT. Definicja to CREATE TYPE, nazwa typu, nawias okrągły i lista pól, każde jako nazwa pola i typ, oddzielone przecinkami. Przykład: CREATE TYPE szczegoly, nawias, dlugosc SMALLINT, przecinek, adnotacja TEXT, zamknięcie. Literał to klamry z parami nazwa pola, dwukropek, wartość, na przykład klamra, dlugosc dwukropek sto, zamknięcie klamry. Nie trzeba podawać wszystkich pól; brakujące mają wartość null. Ramka na slajdzie przypomina, że UDT mogą być frozen. Typ zamrożony zapisuje się jako FROZEN, ostry nawias, szczegoly, zamknięcie, i wtedy nie można zmienić pojedynczego pola, tylko całą wartość. Różnica między krotką a UDT: krotka ma pozycje bez nazw, UDT ma pola z nazwami.

Do zapamiętania na test: tinyint, smallint, int, bigint to liczby całkowite ze znakiem na jednym, dwóch, czterech i ośmiu bajtach; varint to liczba całkowita, a decimal rzeczywista, obie według slajdu o ustalonej, a według dokumentacji o zmiennej precyzji; float i double mają cztery i osiem bajtów. text i varchar to UTF-8, ascii to ASCII, a literały tekstowe piszemy w apostrofach. counter to ośmiobajtowy licznik obsługujący tylko inkrementację i dekrementację, nie może być w kluczu głównym, nie łączy się ze zwykłymi kolumnami i nie ma TTL. blob to dane binarne, inet adres IPv4 lub IPv6, uuid identyfikator. Krotka: TUPLE w ostrych nawiasach, literał w okrągłych. Zbiór: SET, literał w klamrach. Lista: LIST, literał w kwadratowych. Mapa: MAP z dwoma typami, literał w klamrach z dwukropkami. UDT: CREATE TYPE, literał w klamrach z nazwami pól; może być frozen.

## 8.12. SELECT: selekcja danych

Wyrażenie SELECT wybiera pasujące wiersze z pojedynczej tabeli. Słowo pojedynczej jest na slajdzie podkreślone. Diagram składni ustala kolejność klauzul: klauzula SELECT, klauzula FROM, opcjonalnie WHERE, opcjonalnie GROUP BY, opcjonalnie ORDER BY, opcjonalnie LIMIT i na samym końcu opcjonalnie ALLOW FILTERING. Tę kolejność warto znać na pamięć, bo test może pokazać zapytanie z klauzulami w złej kolejności. Na przykład ALLOW FILTERING zawsze stoi na końcu, po LIMIT.

Znaczenie klauzul. SELECT to kolumny lub wartości, które powinny się pojawić w rezultacie. FROM określa pojedynczą tabelę, do której odnosi się zapytanie. WHERE to warunki filtrowania nałożone na wiersze tabeli. GROUP BY to kolumny użyte do grupowania wierszy. ORDER BY to kryteria definiujące kolejność wierszy w rezultacie. LIMIT to liczba wierszy, jaka powinna być podana w rezultacie.

Przykład ze slajdu: SELECT id, przecinek, tytul, przecinek, aktorzy FROM filmy WHERE rok równa się dwa tysiące jedenaście AND gatunki CONTAINS, w apostrofach, komedia. To zapytanie wybiera identyfikator, tytuł i aktorów filmów z roku dwa tysiące jedenaście, których lista gatunków zawiera komedię. Uwaga praktyczna: w tabeli filmy kluczem jest id, a ani rok, ani gatunki nie należą do klucza, więc w prawdziwej Cassandrze takie zapytanie zadziała tylko wtedy, gdy na tych kolumnach są indeksy pomocnicze albo gdy dopiszemy ALLOW FILTERING. Slajd pokazuje je jako ilustrację składni.

Klauzula FROM definiuje pojedynczą tabelę, do której będą wysyłane zapytania, z aktualnej, wybranej przestrzeni kluczy. Złączenie wielu tabel nie jest możliwe. Składnia: FROM, opcjonalnie nazwa przestrzeni kluczy i kropka, a potem nazwa tabeli, na przykład FROM filmydb kropka filmy.

Klauzula WHERE to jedno lub więcej kryteriów, które wiersz musi spełniać, by zostać dołączony do rezultatu. Relacje łączy się wyłącznie słowem AND. W CQL nie ma OR w klauzuli WHERE, a to częsta pułapka. Tylko proste warunki mogą zostać zapisane i nie wszystkie relacje są dozwolone. Po pierwsze, tylko kolumny wchodzące w skład klucza głównego mogą zostać uwzględnione. Po drugie, wyjątkiem są sytuacje, gdy istnieją pomocnicze struktury indeksujące, czyli indeksy wtórne tworzone poleceniem CREATE INDEX. Po trzecie, problem pojawia się w przypadku niektórych relacji: na przykład na kluczu partycji Cassandra pozwala na równość i IN, ale nie na zakres typu większe niż, bo tokeny są haszami i nie zachowują kolejności wartości. Zakresy są naturalne na kolumnach grupujących, i to z zachowaniem kolejności: nie można ograniczyć drugiej kolumny grupującej, pomijając pierwszą.

Relacje w klauzuli WHERE. Diagram pokazuje, że po lewej stronie stoi nazwa kolumny albo krotka nazw kolumn w nawiasie, a potem jedna z form. Pierwsza forma to porównanie: równa się, różne od zapisywane wykrzyknik równa się, mniejsze, mniejsze lub równe, większe lub równe i większe. Na slajdzie większe lub równe zapisano jako równa się i ostry nawias, czyli „=>”, a poprawny operator w CQL to „>=”, czyli najpierw znak większości, potem równa się. Dodatkowo uwaga: choć slajd wymienia operator różne od, w standardowych wersjach Cassandry operator wykrzyknik równa się nie jest obsługiwany w WHERE zapytania SELECT; używa się go w warunkach IF przy transakcjach lekkich. Na teście, jeśli pytanie dotyczy listy ze slajdu, przyjmij listę ze slajdu.

Druga forma to IN, po którym w nawiasie okrągłym stoi lista wartości. IN zwraca prawdę, jeśli wartość zawiera się w wyliczonej strukturze, na przykład WHERE id IN, nawias, w apostrofach hobbit, przecinek, w apostrofach tombraider. Trzecia forma to CONTAINS i wartość. CONTAINS może być używany w kolekcjach, czyli listach, zbiorach i mapach, i zwraca prawdę, gdy kolekcja zawiera dany element. W przypadku mapy CONTAINS sprawdza wartości. Czwarta forma to CONTAINS KEY i wartość. Może być używany tylko dla map i zwraca prawdę, jeśli mapa zawiera dany klucz. To ważna para do rozróżnienia: CONTAINS szuka wśród elementów lub wartości, CONTAINS KEY szuka wśród kluczy mapy. Przykład: WHERE aktorzy CONTAINS KEY, w apostrofach, stallone, znajdzie filmy, w których mapa aktorów ma klucz stallone, a WHERE aktorzy CONTAINS, w apostrofach, Sylvester, znajdzie filmy, w których któraś wartość tej mapy to Sylvester.

Klauzula SELECT, czyli lista wyników. Definiuje kolumny lub wartości, jakie mają być uwzględnione w rezultacie. Gwiazdka oznacza wszystkie kolumny. Aliasy definiuje się słowem AS, na przykład SELECT tytul AS nazwa. Diagram: SELECT, opcjonalnie DISTINCT, a potem gwiazdka albo lista selektorów po przecinku, każdy z opcjonalnym AS i identyfikatorem. DISTINCT oznacza, że powielone wiersze są usuwane. W praktyce Cassandra pozwala na DISTINCT tylko dla kolumn klucza partycji, na przykład SELECT DISTINCT sensor_id FROM sensor_data, co zwraca listę partycji.

Selektor może być nazwą kolumny, stałą wartością, czyli termem, wywołaniem COUNT, nawias, gwiazdka, zamknięcie, wywołaniem WRITETIME, nawias, nazwa kolumny, zamknięcie, albo TTL, nawias, nazwa kolumny, zamknięcie. COUNT gwiazdka zwraca liczbę wierszy w grupie, jeśli użyto GROUP BY, a bez grupowania liczbę wszystkich pasujących wierszy. WRITETIME i TTL wybierają odpowiednio czas modyfikacji i pozostały czas życia danej kolumny. WRITETIME zwraca znacznik czasu zapisu w mikrosekundach, a TTL liczbę sekund, która pozostała do wygaśnięcia, albo null, gdy TTL nie ustawiono. Według slajdu mają dwa ograniczenia: nie mogą zostać użyte na kolekcji i jej elementach, oraz nie mogą zostać użyte w innych klauzulach, na przykład w WHERE. Czyli nie napiszesz WHERE TTL, nawias, tytul, mniejsze niż sto. Przykład poprawny: SELECT tytul, WRITETIME, nawias, tytul, zamknięcie, TTL, nawias, tytul, zamknięcie FROM filmy WHERE id równa się, w apostrofach, hobbit.

Klauzula ORDER BY definiuje kolejność wierszy zwróconych w rezultacie. Podkreślona na slajdzie zasada: dozwolone są tylko uporządkowania wyznaczane przez kolumny grupujące. Nie można sortować po dowolnej kolumnie, bo Cassandra nie sortuje wyników w pamięci; ona tylko czyta partycję w porządku, w jakim dane leżą na dysku, albo w porządku odwrotnym. Składnia: ORDER BY, nazwa kolumny i opcjonalnie ASC albo DESC, powtarzane po przecinku. W praktyce ORDER BY działa w ramach partycji wskazanej w WHERE, a kierunek można jedynie zachować albo całkowicie odwrócić względem CLUSTERING ORDER zdefiniowanego w tabeli. Na przykład dla tabeli sensor_data możesz napisać SELECT gwiazdka FROM sensor_data WHERE sensor_id równa się, w apostrofach, sensor01, ORDER BY timestamp DESC, ale nie ORDER BY value.

Klauzula LIMIT ogranicza liczbę wierszy w zwróconym rezultacie. Składnia: LIMIT i liczba całkowita, na przykład LIMIT dziesięć. W połączeniu z ORDER BY timestamp DESC daje to klasyczne zapytanie o dziesięć najnowszych pomiarów.

Klauzula GROUP BY grupuje wiersze tabeli na podstawie określonych kolumn. Podkreślona zasada: dozwolone są tylko grupowania na kolumnach klucza głównego. Dokładniej, grupować można po kolumnach klucza partycji i kolumnach grupujących, w kolejności ich deklaracji, czyli po prefiksie klucza głównego. Składnia: GROUP BY i lista nazw kolumn po przecinku. Ciekawa zasada ze slajdu: jeżeli w klauzuli SELECT zostanie wymieniona bezpośrednio kolumna, która nie bierze udziału w grupowaniu, czyli nie jest objęta funkcją agregującą, zawsze zostanie zwrócona tylko pierwsza wartość z grupy. To różni CQL od standardowego SQL, gdzie takie zapytanie zwykle jest po prostu błędem.

Agregacje. Natywne funkcje agregujące to COUNT z nazwą kolumny, które zwraca liczbę wszystkich wartości w danej kolumnie, przy czym wartości null są ignorowane. To kontrast z COUNT gwiazdka, które liczy wiersze. Dalej MIN i MAX, czyli minimalna i maksymalna wartość w kolumnie, SUM, czyli suma wszystkich wartości, i AVG, czyli średnia arytmetyczna. Oprócz natywnych istnieją funkcje agregujące definiowane przez użytkownika, czyli User Defined Aggregates. Przykład: SELECT sensor_id, AVG, nawias, value, zamknięcie FROM sensor_data GROUP BY sensor_id. Pamiętaj, że choć agregacje istnieją, slajdy wcześniej mówiły, że Cassandra ogranicza GROUP BY na dużą skalę i że złożone agregacje to sygnał, by wybrać inną bazę. Agregacja w obrębie jednej partycji jest tania, a po całej tabeli bardzo kosztowna.

Modyfikator ALLOW FILTERING. Domyślnie dozwolone są tylko zapytania niefiltrujące, czyli takie, dla których liczba wierszy przeczytanych jest w przybliżeniu równa liczbie wierszy zwróconych. Takie zapytania mają przewidywalną złożoność. Slajd pisze, że ich czas wykonania jest wprost proporcjonalny do rozmiaru danych; precyzyjniej chodzi o rozmiar danych zwracanych, a nie o rozmiar całej tabeli, i to jest właśnie sens przewidywalności. ALLOW FILTERING umożliwia częściowe filtrowanie, czyli zgadzamy się, że Cassandra przeczyta więcej wierszy, niż zwróci, i odrzuci te, które nie pasują. Jeśli zapytanie wymaga filtrowania, a nie dopiszemy ALLOW FILTERING, Cassandra odmówi jego wykonania z komunikatem, że zapytanie może mieć nieprzewidywalną wydajność. Na przykład SELECT gwiazdka FROM filmy WHERE rok równa się dwa tysiące dziesięć ALLOW FILTERING przejrzy całą tabelę na wszystkich węzłach. Na małej tabeli to nic, na miliardzie wierszy katastrofa. Dlatego wcześniej używanie ALLOW FILTERING było na liście najczęstszych błędów modelowania. Prawidłowa reakcja na potrzebę ALLOW FILTERING to zwykle nowa tabela pod to zapytanie.

Do zapamiętania na test: SELECT działa na jednej tabeli, bez złączeń; kolejność klauzul to SELECT, FROM, WHERE, GROUP BY, ORDER BY, LIMIT, ALLOW FILTERING. W WHERE relacje łączy się tylko przez AND i zasadniczo wolno używać tylko kolumn klucza głównego, chyba że istnieje indeks pomocniczy. Relacje to porównania, IN z listą w nawiasie, CONTAINS dla list, zbiorów i map oraz CONTAINS KEY tylko dla kluczy map. Gwiazdka to wszystkie kolumny, AS daje alias, DISTINCT usuwa duplikaty. COUNT gwiazdka liczy wiersze, a COUNT kolumny liczy wartości bez nulli. WRITETIME i TTL zwracają czas zapisu i pozostały czas życia, nie działają na kolekcjach i nie mogą stać w WHERE. ORDER BY tylko po kolumnach grupujących, GROUP BY tylko po kolumnach klucza głównego, a kolumna spoza grupowania zwraca pierwszą wartość. Agregacje to COUNT, MIN, MAX, SUM, AVG i agregaty użytkownika. Bez ALLOW FILTERING dozwolone są tylko zapytania, w których liczba przeczytanych wierszy odpowiada liczbie zwróconych.

## 8.13. INSERT, UPDATE i DELETE

Wyrażenie INSERT wstawia wiersz do danej tabeli. Pierwsza ważna cecha: gdy wiersz o podanym kluczu głównym już istnieje, jest on aktualizowany. To jest tak zwany upsert, czyli połączenie update i insert. W SQL wstawienie duplikatu klucza głównego kończy się błędem, a w Cassandrze nie ma błędu, nowy zapis po prostu nadpisuje podane kolumny. Dlaczego tak? Bo Cassandra, dla szybkości zapisu, nie czyta przed zapisem, czy wiersz istnieje; każdy zapis to dopisanie nowej wersji kolumn ze znacznikiem czasu, a przy odczycie wygrywa najnowsza. Druga cecha: przynajmniej wartości dla kolumn klucza głównego muszą być określone. Trzecia: nazwy kolumn muszą być zawsze podane jawnie. W SQL można napisać INSERT INTO tabela VALUES i od razu wartości; w CQL lista kolumn w nawiasie jest obowiązkowa.

Diagram składni INSERT: INSERT INTO, opcjonalnie nazwa przestrzeni kluczy i kropka, nazwa tabeli, w nawiasie lista nazw kolumn, słowo VALUES, w nawiasie lista wartości, opcjonalnie IF NOT EXISTS i opcjonalnie USING z parametrami aktualizacji. IF NOT EXISTS zmienia zachowanie upsert: wiersz zostanie wstawiony tylko wtedy, gdy jeszcze nie istnieje. To tak zwana transakcja lekka, lightweight transaction, oparta na protokole Paxos, wyraźnie wolniejsza od zwykłego zapisu.

Przykład ze slajdu: INSERT INTO filmy, nawias, id, tytul, rezyser, rok, aktorzy, gatunki, zamknięcie, VALUES, nawias, a w nim kolejno: w apostrofach zielonamila; w apostrofach Zielona Mila; krotka w nawiasie okrągłym z wartościami frank i Darabont; liczba tysiąc dziewięćset dziewięćdziesiąt dziewięć; mapa w klamrach z parami hanks dwukropek Tom oraz morse dwukropek David; i lista w kwadratowych nawiasach z wartościami komedia i dramat; zamknięcie nawiasu. Na końcu USING TTL osiemdziesiąt sześć tysięcy czterysta. Osiemdziesiąt sześć tysięcy czterysta sekund to dokładnie jedna doba, czyli dwadzieścia cztery razy sześćdziesiąt razy sześćdziesiąt. Ten wiersz zniknie automatycznie po dobie. W jednym przykładzie masz więc wszystkie literały: tekst w apostrofach, krotkę w nawiasach okrągłych, liczbę bez apostrofów, mapę w klamrach z dwukropkami i listę w kwadratowych. Zwróć uwagę, że w INSERT klauzula USING stoi na końcu, po VALUES.

Wyrażenie UPDATE aktualizuje wiersze w danej tabeli. Jeżeli wiersz o podanym kluczu jeszcze nie istnieje, zostanie dodany. To znowu upsert, tylko z drugiej strony: INSERT może zaktualizować, a UPDATE może wstawić. To jedna z najważniejszych różnic względem SQL, gdzie UPDATE nieistniejącego wiersza po prostu nic nie robi. Druga reguła: co najmniej wszystkie kolumny wchodzące w skład klucza głównego muszą być podane w klauzuli WHERE. Czyli UPDATE w Cassandrze zawsze wskazuje konkretny wiersz albo konkretne wiersze, nie można zaktualizować wszystkich filmów z roku dwa tysiące dziesięć jednym poleceniem z warunkiem na roku.

Diagram składni UPDATE: UPDATE, opcjonalnie nazwa przestrzeni kluczy i kropka, nazwa tabeli, opcjonalnie USING z parametrami aktualizacji, SET, lista przypisań po przecinku i klauzula WHERE. Zapamiętaj różnicę położenia USING: w UPDATE stoi przed SET, a w INSERT na końcu, po VALUES. Przykład: UPDATE filmy USING TTL trzysta SET tytul równa się i tak dalej.

Przypisania w UPDATE określają dozwolone modyfikacje. Wykład wymienia trzy rodzaje. Wartość całej kolumny jest zmieniana: nazwa kolumny, równa się, wartość. Wartość elementu mapy lub listy jest zmieniana: nazwa kolumny, nawias kwadratowy z kluczem mapy albo indeksem listy, równa się, wartość; elementy listy są numerowane od zera. Wartość pola typu definiowanego przez użytkownika jest zmieniana: nazwa kolumny, kropka, nazwa pola, równa się, wartość.

Pierwszy przykład UPDATE: UPDATE filmy SET rok równa się dwa tysiące dziesięć, rezyser równa się krotka Sylwester, Stallone w nawiasie okrągłym, aktorzy równa się mapa w klamrach ze stallone dwukropek Barney Ross oraz schwarzenegger dwukropek Trench, gatunki równa się lista w kwadratowych z jednym elementem akcja, kraje równa się zbiór w klamrach z jednym elementem USA, WHERE id równa się, w apostrofach, niezniszczalni. To zastępuje całe kolekcje nowymi wartościami.

Drugi przykład: UPDATE filmy SET aktorzy, nawias kwadratowy, w apostrofach norris, zamknięcie, równa się, w apostrofach Chuck; przecinek; gatunki, nawias kwadratowy, jeden, zamknięcie, równa się, w apostrofach komedia; przecinek; wlasciwosci kropka dlugosc równa się dziewięćdziesiąt dziewięć; WHERE id równa się, w apostrofach, niezniszczalni. Pierwsze przypisanie dodaje lub zmienia w mapie aktorów wpis o kluczu norris. Drugie zmienia drugi element listy gatunków, bo indeks jeden to drugi element przy numeracji od zera. Trzecie zmienia pole dlugosc w wartości typu szczegoly. Ważna pułapka, której slajd nie mówi wprost: przypisanie po indeksie listy działa tylko dla istniejącej pozycji. Gdyby wykonać ten drugi przykład zaraz po pierwszym, kiedy lista gatunków ma tylko jeden element, akcja, to gatunki w nawiasie jeden byłoby poza zakresem i Cassandra zgłosiłaby błąd. Traktuj więc oba przykłady jako niezależne ilustracje składni. Druga pułapka: zmiana pojedynczego pola UDT albo elementu kolekcji jest możliwa tylko wtedy, gdy kolumna nie jest frozen.

Modyfikacja elementów kolekcji przez dodawanie i odejmowanie. Pierwszy przykład: UPDATE filmy SET aktorzy równa się aktorzy plus klamra, itie dwukropek Giselle, zamknięcie; gatunki równa się, kwadratowy nawias z elementem dramat, plus gatunki; kraje równa się kraje plus klamra, BR, zamknięcie; WHERE id równa się niezniszczalni. Dodanie mapy do mapy wstawia lub nadpisuje podane klucze. Przy liście kolejność ma znaczenie: lista plus nowa lista dopisuje elementy na końcu, a nowa lista plus lista, jak tutaj z dramatem, dopisuje je na początku, czyli to jest prepend. Dodanie zbioru do zbioru to suma zbiorów, a ponieważ zbiór ma unikalne elementy, dodanie istniejącej wartości nic nie zmieni.

Drugi przykład: UPDATE filmy SET aktorzy równa się aktorzy minus klamra, w apostrofach vicander, przecinek, w apostrofach west, zamknięcie; gatunki równa się gatunki minus kwadratowy nawias z elementami dramat i sci-fi; kraje równa się kraje minus klamra z DE; WHERE id równa się tombraider. Kluczowy szczegół: przy mapie odejmujemy zbiór kluczy, a nie mapę par. Zapis aktorzy minus klamra vicander, west usuwa z mapy wpisy o kluczach vicander i west. Odjęcie listy od listy usuwa z niej wszystkie wystąpienia podanych wartości. Odjęcie zbioru od zbioru to różnica zbiorów. I uwaga na kolejność przy odejmowaniu: zawsze kolumna minus wartości, nigdy odwrotnie.

Parametry aktualizacji, używane po słowie USING zarówno w INSERT, jak i w UPDATE, są dwa. TTL, czyli czas życia w sekundach; wartość zero, null albo brak oznacza wartości trwałe, które nigdy nie wygasną. TIMESTAMP, czyli czas zapisu podany ręcznie, liczba całkowita, w Cassandrze standardowo w mikrosekundach od epoki uniksowej. Parametry można łączyć słowem AND, na przykład USING TTL osiemdziesiąt sześć tysięcy czterysta AND TIMESTAMP i liczba. Ważne: ma to wpływ tylko na nowo dodane albo aktualizowane wartości. Jeżeli UPDATE z USING TTL zmienia jedną kolumnę, to tylko ta kolumna dostaje czas życia, a pozostałe kolumny wiersza zachowują swoje dotychczasowe TTL. Nie ma sposobu, by jednym poleceniem ustawić TTL całemu istniejącemu wierszowi bez ponownego zapisania jego wartości.

Wyrażenie DELETE ma trzy tryby działania. Po pierwsze usuwa pasujące wiersze. Po drugie może zachować wiersze, ale usunąć wybrane kolumny. Po trzecie może zachować kolumny, ale usunąć elementy kolekcji lub pola z wartościami typu definiowanego przez użytkownika. Diagram składni: DELETE, opcjonalnie lista elementów do usunięcia po przecinku, gdzie każdy element to nazwa kolumny, nazwa kolumny z indeksem lub kluczem w nawiasie kwadratowym albo nazwa kolumny, kropka, nazwa pola; potem klauzula FROM i klauzula WHERE. Przykłady w pełnej postaci. DELETE FROM filmy WHERE id równa się hobbit usuwa cały wiersz. DELETE gatunki FROM filmy WHERE id równa się hobbit usuwa tylko kolumnę gatunki, a wiersz zostaje. DELETE aktorzy, nawias kwadratowy, w apostrofach jet, zamknięcie, FROM filmy WHERE id równa się niezniszczalni usuwa z mapy jeden wpis o kluczu jet. DELETE wlasciwosci kropka dlugosc FROM filmy i tak dalej usuwa pole z wartości UDT. Zwróć uwagę na różnicę wobec SQL: w SQL po DELETE nie wymienia się kolumn, bo DELETE zawsze usuwa całe wiersze; w CQL można. Jeszcze jedna rzecz techniczna: w Cassandrze usunięcie nie kasuje danych natychmiast, tylko zapisuje znacznik usunięcia, czyli tombstone, który znika fizycznie dopiero później, podczas kompaktowania.

Do zapamiętania na test: INSERT i UPDATE w Cassandrze to upsert. INSERT istniejącego klucza aktualizuje wiersz, a UPDATE nieistniejącego klucza go tworzy. INSERT wymaga jawnej listy kolumn i wartości przynajmniej dla kolumn klucza głównego; IF NOT EXISTS wstawia tylko nowy wiersz. UPDATE wymaga w WHERE wszystkich kolumn klucza głównego. USING w INSERT stoi na końcu, a w UPDATE przed SET. Parametry USING to TTL w sekundach, gdzie zero lub null oznacza wartość trwałą, oraz TIMESTAMP, łączone przez AND i działające tylko na zapisywane wartości. USING TTL osiemdziesiąt sześć tysięcy czterysta to jedna doba. Przypisania: cała kolumna, element mapy lub listy w nawiasie kwadratowym, z indeksami listy od zera, oraz pole UDT po kropce. Kolekcje modyfikujemy plusem i minusem; dla listy pozycja plusa decyduje o dopisaniu na początku lub na końcu, a z mapy odejmujemy zbiór kluczy. DELETE usuwa cały wiersz, wybrane kolumny albo elementy kolekcji i pola UDT.

## Podsumowanie działu

Zbierzmy cały dział w kilku zdaniach. Bazy rodziny kolumn przechowują tabele złożone z podobnych, ale niekoniecznie identycznych wierszy, a wiersz grupuje dane czytane razem. Apache Cassandra, stworzona przez Facebook, napisana w Javie, wydana w dwa tysiące ósmym i rozwijana przez Apache Software Foundation, to lider tej rodziny: równorzędne węzły peer-to-peer, brak pojedynczego punktu awarii, skalowanie poziome, regulowana spójność i bardzo szybki zapis. Dane trafiają na węzły tak: klucz partycji przechodzi przez Murmur3Partitioner, który daje sześćdziesięcioczterobitowy token, a token wskazuje węzeł na pierścieniu; węzły wirtualne ułatwiają skalowanie i rebalancing. Klucz partycji decyduje, gdzie leżą dane, a kolumny grupujące decydują o ich kolejności w partycji. Model danych projektuje się od zapytań, z denormalizacją i jedną tabelą na wzorzec odczytu, unikając dużych i gorących partycji. W CQL przestrzeń kluczy tworzymy z obowiązkową opcją replikacji, tabela ma dokładnie jeden klucz główny, typy obejmują liczby, teksty, daty, liczniki, krotki, kolekcje i typy użytkownika, SELECT działa na jednej tabeli z ograniczeniami WHERE, ORDER BY i GROUP BY wynikającymi z klucza głównego, ALLOW FILTERING jest sygnałem ostrzegawczym, a INSERT i UPDATE działają jak upsert. Jeśli to wszystko masz w głowie, ten dział na teście nie powinien cię zaskoczyć.


