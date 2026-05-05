# Zaawansowana Inżynieria Promptów LLM: Metodologie Konstruowania Promptów dla Specjalistycznych Zastosowań

Niniejszy raport techniczny przedstawia dogłębną analizę zaawansowanych metodologii inżynierii promptów (Prompt Engineering) dla Dużych Modeli Językowych (LLM). Opracowanie to koncentruje się na strategiach projektowania interakcji dla krytycznych zastosowań, takich jak generowanie kodu, symulacja ról eksperckich, profesjonalne tłumaczenie oraz wymuszanie ściśle ustrukturyzowanych formatów wyjściowych. Przyjęta perspektywa badawcza traktuje prompt jako parametryczny interfejs, którego optymalizacja jest kluczowa dla zwiększenia rzetelności, trafności i spójności generowanych wyników.

## I. Wprowadzenie do Architektury Promptowania

Inżynieria promptów jest zdefiniowana jako dyscyplina w sztucznej inteligencji, która zajmuje się udoskonalaniem danych wejściowych (promptów) w celu osiągnięcia najbardziej dokładnych i pożądanych wyników modelu. Nie jest to jednorazowa czynność pisarska, lecz iteracyjny proces systematycznego doskonalenia.

### Podstawowe Elementy Konstytuujące Efektywny Prompt

Konstrukcja każdego efektywnego promptu opiera się na zestawie kluczowych składowych, które zbiorowo kierują modelem do właściwej przestrzeni odpowiedzi. Elementy te obejmują:

1. **Instrukcja:** Musi być klarowna, precyzyjna i specyficzna, definiując dokładnie, co model ma wykonać (np. podsumowanie, klasyfikacja, tłumaczenie).

2. **Kontekst:** Informacja tła, która dostarcza niezbędnej wiedzy do wykonania zadania (np. schemat bazy danych, fragment tekstu do analizy, specyficzne definicje terminów).

3. **Ograniczenia:** Definicje zakresu odpowiedzi, w tym wymagany format (np. JSON, lista, kod), pożądana długość lub styl.


### Iteracyjny Cykl Życia Promptu

Skuteczna inżynieria promptów wymaga podejścia cyklicznego, analogicznego do procesu debugowania oprogramowania. Początkowa instrukcja rzadko jest idealna; dlatego stosowane są **strategie iteracyjnego projektowania promptów**. Metody te polegają na modyfikacji promptu poprzez testowanie różnych sformułowań, dostosowywanie poziomu szczegółowości i specyficzności oraz eksperymentowanie z długością promptu w celu znalezienia optymalnej równowagi między zwięzłością a kompletnością kontekstu.

Proces ten transformuje inżynierię promptów z prostego wydawania poleceń w optimizację parametru tekstowego. Jeśli model generuje niepożądaną odpowiedź, inżynier powinien redefiniować prompt, używając synonimów lub alternatywnych struktur, aby zmniejszyć entropię odpowiedzi modelu i skierować jego przestrzeń poszukiwania tokenów do bardziej precyzyjnego podzbioru wiedzy.

## II. Fundamenty Zwiększające Wydajność i Rzetelność (Core Methodologies)

Klucz do osiągnięcia wysokiej jakości wyników w specjalistycznych zastosowaniach LLM leży w zaawansowanych technikach, które modulują sposób, w jaki model przetwarza informacje i formułuje wnioski.

### Systemowe Przypisywanie Ról (Role-Playing and System Prompts)

Przypisanie roli jest krytyczną strategią projektowania promptów, która zwiększa trafność i specyfikę generowanych treści. LLM mają tendencję do generowania lepszych odpowiedzi, gdy są instruowane, by uosabiały określoną rolę, co definiuje ich perspektywę, ton i wykorzystywany rejestr językowy.

**Mechanizm Aktywacji Wiedzy:** Zastosowanie roli eksperta nie jest tylko zabiegiem stylistycznym, lecz metodą na wymuszenie na modelu wykorzystania specyficznych, wewnętrznych podzbiorów jego danych treningowych. Definicja roli, np. `Jesteś profesjonalnym doradcą klienta w branży e-commerce` lub `You are an expert technical writer...`, ogranicza szeroką przestrzeń wiedzy modelu do terminologii, konwencji i stylu właściwego dla danej dziedziny (np. compliance, rekrutacja, analiza finansowa). W ten sposób model o wysokiej entropii odpowiedzi (potencjalnie generujący ogólne lub nieprecyzyjne wyniki) zostaje zmuszony do zawężenia kontekstu, co prowadzi do zwiększenia trafności i specjalistycznej jakości outputu.

### Few-Shot Prompting (Nauczanie Kontekstowe Przez Przykłady)

Few-Shot Prompting polega na dostarczeniu modelowi kilku przykładów par wejście-wyjście w ramach promptu. Ta technika demonstruje pożądany wzorzec, styl, format lub logikę, którą model ma zastosować do nowego zadania wejściowego.

Jest to szczególnie przydatne, gdy zadanie wymaga specyficznego formatowania, klasyfikacji lub użycia kontekstowo zdefiniowanego słownictwa. Na przykład, aby model poprawnie używał nowo zdefiniowanego terminu, można mu dostarczyć jeden lub dwa przykłady użycia tego słowa w zdaniu. Few-Shot Prompting jest potężnym narzędziem do szybkiego dostosowania zachowania modelu bez konieczności kosztownego dostrajania (fine-tuning).

### Zaawansowane Techniki Rozumowania (Reasoning Techniques)

W przypadku złożonych zadań wymagających wieloetapowego przetwarzania lub planowania, konieczne jest zastosowanie technik, które symulują procesy poznawcze i deliberatywne.

#### Chain-of-Thought (CoT) Prompting

Chain-of-Thought (CoT) to technika, która instruuje model, aby przed podaniem ostatecznej odpowiedzi wyartykułował sekwencję kroków pośrednich lub "myśli".

**Mechanizm i Zalety:** CoT poprawia wydajność LLM w złożonych zadaniach wymagających rozumowania (np. matematyka, logika, programowanie) poprzez rozbicie elaborowanego problemu na łatwiejsze do zarządzania, sekwencyjne kroki. Zapewnia to również transparentność, ponieważ użytkownik może prześledzić proces decyzyjny modelu, zwiększając w ten sposób zaufanie do wyników. W kontekście kodowania, CoT jest wykorzystywany do dekompozycji zadania na analizę zakresu, a następnie na implementację testów.

#### Tree-of-Thought (ToT) Prompting

Tree-of-Thought (ToT) stanowi ewolucję CoT, wprowadzając mechanizmy deliberatywne i grafowe poszukiwanie rozwiązań.

**Mechanizm i Zastosowanie:** O ile CoT jest liniowy i sekwencyjny, ToT pozwala, aby każdy krok rozumowania rozgałęział się na wiele ścieżek, umożliwiając modelowi eksplorację alternatywnych strategii i mechanizmy backtrackingu (cofnięcia się, gdy ścieżka prowadzi do sprzeczności). To symuluje złożone ludzkie planowanie i proces samooceny. ToT jest idealny dla problemów, które są z natury niedeterministyczne lub wymagają heurystyki, takie jak rozwiązywanie łamigłówek Sudoku, gra 24, czy kreatywne pisanie fabuły, gdzie potencjalne rozwiązania muszą być rozważane i odrzucane w miarę potrzeby. Wprowadza to element weryfikacji w architekturze promptu, co zwiększa

_robustness_ modelu.

Tabela 2.1. Porównanie Zaawansowanych Technik Rozumowania

| **Technika**           | **Mechanizm Działania**                                                   | **Idealne Zastosowanie**                                                                                   | **Wymagana Złożoność Modelu**                |
| ---------------------- | ------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| Chain-of-Thought (CoT) | Liniowe, sekwencyjne generowanie kroków rozumowania.                      | Złożone problemy logiczne i matematyczne; przejrzystość.                                                   | Średnia do Wysokiej (zwłaszcza Few-Shot CoT) |
| Tree-of-Thought (ToT)  | Grafowe poszukiwanie rozwiązań; rozgałęzianie i mechanizmy backtrackingu. | Zadania wymagające planowania, heurystyki, eliminacji sprzeczności (np. łamigłówki, kreatywne planowanie). | Wysoka (wymaga głębokiej samooceny)          |
| Few-Shot Prompting     | Demonstracja pożądanego wzorca wyjścia na bazie przykładów.               | Klasyfikacja, ekstrakcja, dostosowanie stylu/tonu.                                                         | Średnia                                      |

## III. Aplikacje Specjalistyczne I: Generowanie Kodu i Inżynieria Oprogramowania

W kontekście inżynierii oprogramowania, LLM są wykorzystywane do generowania kodu, zapytań bazodanowych i tworzenia testów jednostkowych. Te zastosowania wymagają ekstremalnej precyzji syntaktycznej i funkcjonalnej.

### Generowanie Syntaktycznie Poprawnego Kodu

Aby wygenerować kod, który jest zarówno poprawny, jak i funkcjonalny, prompt musi dostarczyć kluczowy kontekst strukturalny. Przykładem jest generowanie zapytań SQL, gdzie dostarczenie schematu tabel (np. `Table departments, columns =`) jest niezbędne, aby model mógł wygenerować poprawną kwerendę (np. MySQL query for all students in the Computer Science Department). Bez tego kontekstu, model może halucynować nazwy kolumn lub relacje.

### Tworzenie Testów Jednostkowych i Wsparcia Inżynieryjnego

Generowanie testów jednostkowych wymaga od modelu metodycznego podejścia, które symuluje pracę doświadczonego inżyniera.

**Rola Eksperta:** Kluczowe jest przypisanie zaawansowanej roli, na przykład: `I want you to act as a Senior full stack Typescript developer`. To wymusza stosowanie najlepszych praktyk inżynierskich, takich jak zasady czystego kodu, izolacja zależności i adekwatne nazewnictwo.

**Metodyka Promptowania Testów (Fazy CoT):** Proces tworzenia testów powinien być dekomponowany na etapy, co wykorzystuje zasadę Chain-of-Thought.

1. **Faza Analizy (CoT Step 1):** Model jest instruowany, aby najpierw dokładnie przeanalizował dostarczony kod TypeScript. Ma zidentyfikować możliwe niejasności, brakujące definicje (constants, type definitions, external APIs) i poszukać wyjaśnień, zanim przejdzie do pisania testów. Ta faza gwarantuje zrozumienie kodu bazowego.

2. **Faza Implementacji (CoT Step 2):** Następnie model otrzymuje szczegółowe wytyczne testowe: projektowanie małych, skupionych testów, symulowanie zachowania zewnętrznych zależności przy użyciu obiektów _mock_ oraz użycie opisowej struktury testu (`describe('#<METHOD_NAME>')`). Zastosowanie tej strategii dekompozycji (CoT) zapewnia metodyczne i kompleksowe podejście do analizy cech kodu przed ich testowaniem.


### Wyzwania Spójności i Dryfu Modelu (Model Drift)

Profesjonalna inżynieria promptów musi uwzględniać niestabilność środowiska LLM. Modele bazowe, takie jak GPT-4 czy Llama, są stale aktualizowane, co może prowadzić do zjawiska **Model Drift** – wcześniej działający prompt przestaje generować oczekiwane wyniki lub zmienia się jakość odpowiedzi.

Sukces profesjonalnego systemu LLM zależy od systematycznego testowania promptów, podobnie jak w przypadku tradycyjnego DevOps. Wymagane jest wprowadzenie **testów jednostkowych dla promptów** (Prompt Testing Strategies), które monitorują jakość, spójność wyjścia i dryf modelu w czasie, a także oceniają bezpieczeństwo i etykę odpowiedzi. Takie podejście jest konieczne, ponieważ bez ciągłej walidacji, prompt zoptymalizowany dla jednej wersji modelu może zawieść w kolejnej.

## IV. Aplikacje Specjalistyczne II: Ekspertyza, Tłumaczenie i Generowanie Treści Dedykowanych

W wielu przypadkach zadaniem LLM jest przetworzenie informacji i przekazanie jej w specyficznym stylu, tonie lub kontekście, który jest adekwatny do dziedziny lub odbiorcy.

### Symulacja Eksperta Tłumacza

W zadaniach tłumaczeniowych, oprócz zapewnienia dokładności leksykalnej, kluczowe jest dostosowanie rejestru i terminologii do kontekstu branżowego.

**Instrukcja Roli i Kontekstu:** Prompt musi nie tylko żądać tłumaczenia, ale także definiować specjalizację i język docelowy. Przykładem jest: `You are a professional translator with expertise in IT. Translate this technical report from English to German`. Przypisanie specjalizacji (ekspertyza w IT) wymusza użycie technicznego żargonu i konwencji językowych właściwych dla danej branży w języku docelowym, co jest krytyczne dla profesjonalnej jakości tłumaczenia.

### Tworzenie Dokumentacji Technicznej i Materiałów Edukacyjnych

Generowanie treści dla różnych grup odbiorców wymaga modulacji stylu i poziomu skomplikowania języka.

**Dostosowanie do Odbiorcy:** Efektywny prompt musi przypisać rolę, która naturalnie dostosowuje złożoność komunikatu. Przykłady ról obejmują:

- `You are a computer science professor writing slides for your first-year students...` (Wymaga uproszczenia i klarowności).

- `You are a patient senior software engineer talking to a junior software engineer...` (Wymaga mentorskiego tonu i szczegółowych wyjaśnień).


Poprzez definiowanie tożsamości i relacji z odbiorcą, model jest w stanie ograniczyć przestrzeń językową do tej, która najlepiej pasuje do celu komunikacji. Podobne podejście jest stosowane w złożonej analizie dokumentów lub ocenie ryzyka inwestycyjnego, gdzie model musi działać jako Analityk Finansowy lub Konsultant HR.

## V. Wymuszanie Ustrukturyzowanego Outputu dla Automatyzacji Procesów (Structured Output Engineering)

Automatyzacja procesów biznesowych i potoków danych wymaga, aby wyjście LLM było niezawodnie ustrukturyzowane i parse'owalne przez kolejne systemy (downstream applications). Dwie najbardziej zaawansowane metody służące temu celowi to JSON Schema i Grammar-Based Decoding.

### JSON Schema dla Gwarantowanej Ważności Formatu

JSON Schema to deklaratywny język, który definiuje strukturę i ograniczenia danych JSON. Działa on jako kontrakt lub plan, określający, jakie pola muszą istnieć, ich typy danych (np. string, number, boolean) oraz zasady (np. pola wymagane vs. opcjonalne).

**Mechanizm i Implementacja:** Poprzez narzucenie schematu, LLM jest zmuszony do generowania obiektu JSON, który spełnia te wymogi. Najbardziej niezawodne metody wykorzystują natywne wsparcie API, które stosuje **constrained decoding** (często powiązane z gramatyką), aby zapobiec generowaniu tokenów łamiących format JSON lub naruszających zdefiniowane typy.

**Zalety:** Użycie JSON Schema gwarantuje format, co ułatwia automatyczną walidację i parsing, zwiększając niezawodność w złożonych potokach danych, gdzie wyjście LLM musi być skonsumowane przez inny program. Choć schemat gwarantuje _strukturę_, nie gwarantuje, że _zawartość_ jest faktycznie poprawna.

### Grammar-Based Decoding (Dekodowanie Oparte na Gramatyce)

Grammar-Based Decoding jest najbardziej rygorystyczną formą wymuszania struktury. Jest to forma **constrained decoding**, która wykorzystuje formalne reguły gramatyczne do ścisłego ograniczenia sekwencji generowanych tokenów.

**Mechanizm:** Zamiast ograniczać tylko strukturę danych (jak JSON Schema), dekodowanie oparte na gramatyce działa na poziomie token-po-tokenie. Używa formalnej gramatyki (często w wariancie BNF), aby w każdym kroku sprawdzić, które tokeny są dozwolone. Każdy token, który złamałby regułę gramatyczną (np. niezbalansowany nawias w wyrażeniu matematycznym lub błąd składniowy w SQL), jest maskowany i nie może zostać wygenerowany.

**Zastosowanie:** Metoda ta jest niezastąpiona, gdy wymagana jest 100% poprawność syntaktyczna. Jest to kluczowe przy generowaniu kodu, zapytań SQL, XML, a także złożonych, niestandardowych struktur, których nie można łatwo zdefiniować za pomocą samego JSON Schema. Gwarantuje to, że wygenerowany SQL lub kod będzie składniowo poprawny, co minimalizuje błędy w systemach _downstream_.

**Hierarchia Rygoru Strukturalnego:** Istnieją trzy poziomy wymuszania struktury, a wybór metody jest podyktowany wymaganiami automatyzacji. Instrukcja tekstowa ma najniższy rygor (zależny od kaprysu modelu). JSON Schema zapewnia gwarancję struktury danych i typów pól. Grammar-Based Decoding zapewnia najwyższy rygor, gwarantując poprawność składniową token po tokenie, co jest niezbędne dla generowania języków programowania i zapytań.

Tabela 5.1. Porównanie Metod Wymuszania Ustrukturyzowanego Outputu

|**Metoda**|**Poziom Rygoru**|**Gwarantowana Właściwość**|**Idealne Zastosowanie**|**Wymagania Implementacyjne**|
|---|---|---|---|---|
|Instrukcja Tekstowa|Niski (zależny od modelu)|Żądany format (np. "jako YAML")|Szybkie testy, proste struktury.|Niskie (tylko tekst w promptcie)|
|JSON Schema|Średni do Wysokiego|Poprawność formatu i typów danych pól.|Interoperacyjność API, potoki JSON/YAML.|Wymaga definicji schematu i wsparcia API.|
|Grammar-Based Decoding|Wysoki (100% syntaktyczna)|Poprawność składniowa token po tokenie (np. zbalansowane nawiasy).|Generowanie kodu SQL/XML, niestandardowe formaty, krytyczne pipeline'y.|Wymaga definicji formalnej gramatyki (np. BNF) i wsparcia dekodera.|

## VI. Metody Ewaluacji, Robustness i Zarządzanie Ryzykiem Naukowym

W profesjonalnych zastosowaniach LLM, optymalizacja promptu musi być ściśle powiązana z systematyczną ewaluacją, mającą na celu zarządzanie wrodzonymi wadami modelu.

### Zarządzanie Ryzykiem Halucynacji i Fikcji (Confabulation)

Halucynacje to skłonność LLM do generowania zmyślonych, lecz brzmiących wiarygodnie informacji, gdy brakuje im danych. Przykłady obejmują opisywanie nieistniejących książek lub podawanie wyników przyszłych wydarzeń, takich jak wybory.

**Strategie Minimalizacji Ryzyka:** Aby minimalizować halucynacje, należy instruować model, aby wyjaśniał swoje rozumowanie (poprzez techniki CoT). W zaawansowanych systemach opartych na Retrieval Augmented Generation (RAG), model powinien być instruowany do odwoływania się do konkretnego, dostarczonego kontekstu, co można zweryfikować za pomocą metryki rzetelności (Hallucination metric).

### Wyzwania Stronniczości i Toksyczności (Bias and Toxicity)

Modele LLM uczą się z tekstów treningowych, które często zawierają stronnicze, szkodliwe lub uprzedzone treści pochodzące z Internetu. W rezultacie, modele mogą odzwierciedlać te same uprzedzenia w swoich odpowiedziach (np. generowanie treści seksistowskich lub rasistowskich).

Dlatego w procesie MLOps kluczowe jest uwzględnienie **Odpowiedzialnych Metryk (Responsible Metrics)**, które określają, czy wyjście LLM zawiera niepożądane treści. Ocena modelu pod kątem stronniczości i toksyczności jest standardowym wymogiem etycznym i regulacyjnym.

### Metryki Ewaluacji Promptów i Wyjścia LLM

Dla profesjonalnych wdrożeń, ocena jakości promptów musi wykraczać poza testowanie ad-hoc i wymagać statystycznej rygorystyki. Kluczowe metryki ewaluacji w zastosowaniach specjalistycznych to:

- **Hallucination:** Określenie, czy wyjście zawiera zmyślone fakty.

- **Contextual Relevancy:** Ocena, czy kontekst dostarczony modelowi (np. przez retrievera w RAG) był faktycznie najbardziej relewantny dla zadania.

- **Tool Correctness:** W przypadku agentów autonomicznych, określenie, czy model był zdolny do wywołania poprawnego narzędzia lub funkcji dla danego zadania.


W fazie eksploracyjnej wystarczające może być badanie niewielkiej liczby przykładów w celu identyfikacji nowych typów błędów. Jednak przy podejmowaniu decyzji o wdrożeniu nowego modelu lub promptu (benchmarking), kluczowe jest zastosowanie rygoru statystycznego, aby zapobiec podejmowaniu decyzji opartych na zawodnych lub niepełnych danych.

Tabela 6.1. Wymiary Oceny Jakości Wyjścia LLM

|**Wymiar Oceny**|**Definicja Metryki**|**Wpływ na System**|**Przykłady Błędów**|
|---|---|---|---|
|Rzetelność (Faithfulness)|Stopień, w jakim wyjście jest zakorzenione w dostarczonym kontekście.|Kluczowy dla aplikacji RAG i generowania faktów.|Konfabulowanie dat, źródeł, cytatów.|
|Poprawność Narzędzi (Tool Correctness)|Zdolność agenta do wywołania właściwych funkcji dla zadania.|Istotny dla agentów autonomicznych i funkcjonalności `function calling`.|Wywołanie nieprawidłowego API lub brak wywołania narzędzia.|
|Zgodność Formatowania|Przestrzeganie wymogów JSON Schema/Grammar-Based Decoding.|Krytyczny dla automatyzacji potoków danych.|Brakujące nawiasy klamrowe, złe typy danych.|
|Odpowiedzialność (Bias/Toxicity)|Obecność szkodliwych, stronniczych lub obraźliwych treści.|Wymóg etyczny i regulacyjny.|Generowanie stereotypowych opisów.|

## VII. Konkluzje i Rekomendacje

Profesjonalna inżynieria promptów wykracza poza podstawowe instrukcje, stając się zaawansowaną dyscypliną opartą na metodykach inżynierskich i rygorystycznej ewaluacji.

Główne wnioski analityczne i rekomendacje dla projektowania specjalistycznych promptów są następujące:

1. **Dyferencjacja Mechanizmów Rozumowania:** Dla zadań sekwencyjnych i deterministycznych (np. proste generowanie kodu, rozwiązywanie równań), strategia Chain-of-Thought (CoT) jest wystarczająca i zapewnia transparentność. Jednakże, dla zadań wymagających heurystyki, planowania i możliwości odrzucania błędnych założeń (np. złożone testowanie jednostkowe, kreatywna deliberacja), systemy powinny być projektowane z wykorzystaniem Tree-of-Thought (ToT), który wprowadza mechanizmy samooceny i _backtracking_.

2. **Rygor Strukturalny a Interoperacyjność:** W kontekście automatyzacji (np. pipeline'y danych), wybór metody strukturyzacji outputu jest zależny od wymaganego poziomu rygoru. Podczas gdy JSON Schema gwarantuje poprawność struktury hierarchicznej i typów danych (niezbędne dla większości interfejsów API), generowanie krytycznego kodu lub złożonych, niestandardowych formatów wymaga bezwzględnie Grammar-Based Decoding, gwarantującego 100% poprawność składniową na poziomie tokenów.

3. **Prompt jako Aktywator Wiedzy i Kontekstu:** Najlepsza praktyka polega na systemowym przypisywaniu roli (System Prompt) i dostarczaniu specyficznego kontekstu (Few-Shot lub schematy danych). Definiowanie modelu jako Eksperta (np. _Senior Developer_ lub _IT Translator_) jest kluczową strategią redukcji entropii odpowiedzi, wymuszającą na modelu operowanie w precyzyjnie zdefiniowanym podzbiorze wiedzy i rejestrze językowym, co bezpośrednio zwiększa fachowość i trafność outputu.

4. **Wymóg MLOps i Testowania Promptów:** Z uwagi na zjawisko dryfu modelu (Model Drift) i nieodłączne ryzyko halucynacji, wdrożenie jakichkolwiek profesjonalnych promptów wymaga cyklu życia opartego na ciągłym monitorowaniu i testach (Prompt Testing Strategies). Konieczne jest użycie metryk statystycznych, w tym Hallucination, Tool Correctness oraz Responsible Metrics (Bias/Toxicity), aby zapewnić niezawodność, spójność i etyczność systemu LLM w długim horyzoncie czasowym.

# VIII. Agenty

Agenty to autonomiczne systemy oparte na LLM, które mogą wykonywać zadania w sposób samodzielny, korzystając z dostępnych narzędzi i danych. W kontekście profesjonalnej inżynierii promptów, agenty są projektowane z myślą o maksymalizacji efektywności, dokładności i niezawodności systemu.

Sub agenty to wyspecjalizowane komponenty, które wykonują określone funkcje w ramach większego systemu agenta. Na przykład, w systemie zarządzania projektami, sub agent może być odpowiedzialny za generowanie raportów statusu.

Skille to konkretne umiejętności lub funkcje, które agent może wykonywać. W skład skilli wchodzi plik md z instrukcją, który definiuje, jak agent powinien wykonywać daną umiejętność, oraz czasem plik z kodem - mini biblioteka, którą agent może zrealizować dany skill, np. api generowania obrazu.

W głównym agencie, należy zdefiniować, jak i kiedy najchętniej wywoływać sub agentów i skille, aby osiągnąć pożądany rezultat. Oraz zachęcać do ich używania.


# IX. Inne i Notatki

Ważne dla Polaka: Język Polski wykazuje większą precyzję i klarowność w wyrażaniu myśli i idei technicznych w porównaniu do angielskiego, jednak taki prompt zawiera więcej tokenów. My wykorzystujemy język Polski, ale warto mieć na uwadze, że w angielskim prompt może być krótszy o około 5-15%.

