# ⚡ Skill: UI/UX Design

> **Kategoria:** analysis | **Trudność:** medium
> **Tokens:** ~4500 | **Model:** any (zalecany: Claude / GPT-4+)
> **Wersja:** 1.0.0 | **Utworzono:** 2026-02-24
> **Komendy aktywacyjne:** `ui review` | `ux audit` | `design check`

---

## Kiedy używać

Gdy potrzebujesz:
- sprawdzić projekt UI pod kątem fundamentalnych zasad designu,
- ocenić kolorystykę, typografię, spacing, cienie i interakcje,
- zaprojektować lub zrefaktoryzować interfejs zgodnie ze standardami WCAG i best practices,
- szybko sprawdzić „dlaczego coś wygląda źle" — tu jest odpowiedź.

---

## Spis zasad https://designparser.de/

| Grupa | Liczba zasad | Zasady |
|-------|:------------:|--------|
| 🎨 Kolor | 7 | 60-30-10, Kontrola nasycenia, Najpierw szarość, Skala kolorów, Nazewnictwo kolorów, Luminancja vs. jasność, Psychologia kolorów |
| 🔤 Typografia | 8 | Interlinia, Długość wiersza, Wysokość x, Zmęczenie capslockiem, Parowanie fontów, Hierarchia typograficzna, Wyrównanie tekstu, Krój pisma vs. Font |
| 📐 Spacing | 6 | System 8pt, System 4pt, Bliskość, Grid kolumnowy, Grid modularny, Grid bazowy |
| 🌑 Cienie i głębia | 3 | Podstawy cieni, System elewacji, Wypukłość vs. wklęsłość |
| 🧠 Prawa UX | 5 | Prawo Millera, Prawo Hicka, Prawo Jakoba, Efekt centrum, Ślepota banerowa |
| 🖱️ Interakcja | 4 | Rozmiar celu dotykowego, Projektowanie przycisków, Padding przycisków, Projektowanie linków |
| 🔲 Ikony | 2 | Bounding box ikon, Wyrównanie ikon |
| 👁️ Percepcja wizualna | 2 | Waga wizualna, Zasada trójpodziału |
| **RAZEM** | **37** | |

---

## Zasady

---

### 🎨 KOLOR (7)

---

#### 1. Zasada 60-30-10

> **TL;DR:** 60% kolor dominujący, 30% kolor wspierający, 10% akcent. Strukturyzuje hierarchię kolorów bez chaosu wizualnego.

**Zasada:**
- 60% — kolor dominujący: główne powierzchnie, tła, obszary tekstu
- 30% — kolor wspierający: karty, sidebary, elementy wspomagające UI
- 10% — kolor akcentowy: CTA, podkreślenia, ostrzeżenia, ikony

**Dlaczego działa:**
- Zapobiega zmęczeniu wizualnemu — zbyt wiele równoważnych kolorów rywalizuje o uwagę
- Kolor akcentowy działa tylko dlatego, że jest rzadki; przy 50% powierzchni traci sygnałową wartość
- Dopasowuje się do naturalnej percepcji hierarchii: większa powierzchnia = niższy priorytet

**Kiedy się łamie:**
- Systemy monochromatyczne → użyj wariantów jasności, nie odcienia
- Konteksty ilustracyjne i redakcyjne → inne proporcje są dopuszczalne

**W praktyce:**
- Aplikacja z białym tłem: 60% biel, 30% szarość neutralna na karty, 10% niebieski marki na przyciski i linki

---

#### 2. Kontrola nasycenia

> **TL;DR:** 0-25% na tła, 25-60% na elementy UI, 60-100% na CTA.

**Zasada:**
- Niskie (0-25%): tła, tekst, layouty — tworzy spokojną, profesjonalną bazę
- Średnie (25-60%): przyciski, linki, karty — zbalansowana uwaga bez przytłoczenia
- Wysokie (60-100%): CTA, błędy, ostrzeżenia — wymusza natychmiastową uwagę

**Dlaczego działa:**
- Nasycenie kontroluje uwagę — silnie nasycone kolory uruchamiają intensywniejsze przetwarzanie wizualne
- Wysokie nasycenie wszędzie = wszystko jest równie ważne = brak hierarchii
- Przy długotrwałym użyciu (dashboardy) niskie nasycenie zmniejsza zmęczenie poznawcze

**Kiedy się łamie:**
- Nasycone tła na krótko-sesyjnych stronach marketingowych mogą działać, gdy użyte świadomie
- Samo nasycenie nigdy nie wystarcza do dostępności — kontrast luminancji WCAG też musi przejść

**W praktyce:**
- Nasycony akcent 80% pomarańczowy + desaturowane tło 10% szarości = wyraźny fokus bez szumu

**Kluczowe liczby:**
| Wartość | Opis |
|---------|------|
| 0-25% | Tła i neutralne |
| 25-60% | Elementy UI |
| 60-100% | CTA i sygnały |

---

#### 3. Najpierw szarość

> **TL;DR:** Struktura musi działać w szarości. Kolor to ulepszenie, nie łatka.

**Zasada:**
- Projektuj najpierw w szarości — hierarchia, kontrast i spacing muszą działać bez koloru
- Użyj skali 9-stopniowej (100-900): wystarczający zakres, nie przytłaczający
- Unikaj czystej szarości — dodaj 2-10% nasycenia dla ciepłego lub chłodnego neutralu
- Aktywny zestaw: używaj tylko 4-6 stopni na ekran, nie wszystkich 9

**Dlaczego działa:**
- Jeśli UI się psuje w szarości → struktura jest zepsuta; kolor nie naprawia problemów strukturalnych
- Ponad 90% tekstu to małe litery — kontrast w szarości determinuje czytelność
- Ciemniejsze stopnie (700-900) potrzebują więcej nasycenia, by wyglądać wizualnie neutralnie

**Kiedy się łamie:**
- Czysto dekoracyjne elementy jak ilustracje i hero'sy działają wg innych reguł
- Czysta szarość przy 0% nasycenia wygląda zimno i martwo — zawsze dodaj lekki odcień

**W praktyce:**
- Krok 1: dokończ layout w szarości. Krok 2: nałóż kolor marki tylko na CTA i akcenty

---

#### 4. Skala kolorów

> **TL;DR:** Skala 100-900, zacznij od 500, zdefiniuj skrajności, wypełnij luki.

**Zasada:**
- Zacznij od 500 (kolor bazowy): ani za jasny, ani za ciemny
- Zdefiniuj skrajności: 900 na tekst (najciemniejszy), 100 na tła (najjaśniejszy)
- Wypełnij luki równymi krokami od 100 do 900 (9 łącznie)
- Używaj HSL: zachowaj ten sam odcień, dopasuj jasność i nasycenie na krok

**Dlaczego działa:**
- Losowe wartości hex mogą wyglądać podobnie, ale nie mają systemu — nie są przewidywalne
- Systematyczna skala tworzy spójny rytm wizualny w całym produkcie
- Odcień musi lekko rotować na skrajnych stopniach — czysty HSL produkuje zielonkawe jasne i żółtawe ciemne

**Kiedy się łamie:**
- Rotacja odcienia na skrajnych stopniach jest wymagana — inaczej jasny niebieski przesuwa się ku zieleni
- Zawsze weryfikuj wizualnie z kontrolą kontrastu WCAG, nie tylko licząc kroki numeryczne

**W praktyce:**
- 100-300: tła. 400-600: przyciski i odznaki. 700-900: tekst i silne podkreślenia

**Kluczowe liczby:**
| Wartość | Opis |
|---------|------|
| 500 | Punkt startowy koloru bazowego |
| 900 | Najciemniejszy stopień (tekst) |
| 100 | Najjaśniejszy stopień (tło) |

---

#### 5. Nazewnictwo kolorów

> **TL;DR:** Prymitywy przechowują wartości. Semantyka definiuje znaczenie. Nigdy nie używaj surowego hexa w projektach.

**Zasada:**
- Prymitywy (100-900): przechowują tylko wartości. Przykład: `Primary/600`, `Neutral/900`
- Semantyka: definiuje znaczenie. Przykład: `Text/Primary`, `Background/Page`
- Semantyka odwołuje się do prymitywów, nigdy bezpośrednio do wartości hex
- Format: `[Element]/[Cel]/[Stan]`. Przykład: `Text/Primary/Hover`

**Dlaczego działa:**
- Rebranding: zmień prymityw raz, a cała semantyka zaktualizuje się automatycznie
- Dark mode: semantyka pozostaje taka sama, po prostu odwołuje się do innych prymitywów
- Używanie prymitywów bezpośrednio w projektach łamie dark mode — brak automatycznego odwracania kontrastu

**Kiedy się łamie:**
- Zbyt wiele tokenów semantycznych tworzy niezarządzalną hierarchię i paraliż decyzyjny
- Nazewnictwo po kolorze (np. `DarkBlue`) zamiast po funkcji (np. `Text/Primary`) psuje się przy rebrandingu

**W praktyce:**
- `Text/Primary` = `Neutral/900` w light mode i `Neutral/100` w dark mode. Jeden token semantyczny, dwa stany

---

#### 6. Luminancja vs. jasność

> **TL;DR:** HSL-L nie jest miarą kontrastu. WCAG używa luminancji (Y). Żółty i niebieski przy HSL-L 50% dają kontrast 1.07:1 — FAIL.

**Zasada:**
- Luminancja (Y): fizyczna, liniowa. Wzór: `Y = 0.2126R + 0.7152G + 0.0722B`
- Jasność (L*): percepcyjna, nieliniowa. Zdefiniowana przez CIELAB 1976
- HSL-L: geometryczny model RGB bez podstaw fizycznych — nie jest miarą kontrastu
- Kontrast WCAG używa Y (luminancji), nie L* ani HSL-L

**Dlaczego działa:**
- Prawo Webera: oko reaguje na kontrast względny, nie absolutne wartości jasności
- Żółty i niebieski przy HSL-L 50% różnią się rzeczywistą luminancją 12.8x
- Zielony dominuje ludzką percepcję jasności ze współczynnikiem 0.7152

**Kiedy się łamie:**
- Efekt Helmholtza-Kohlrauscha: nasycone kolory (niebieski, magenta) wydają się jaśniejsze niż sugeruje ich wartość Y — CIELAB tego nie modeluje
- WCAG to minimum — percepcyjna jednorodność wymaga OKLCH lub CIECAM

**W praktyce:**
- Zawsze obliczaj kontrast WCAG używając Y. Żółty (#FFFF00) na białym = kontrast 1.07:1, fail pomimo HSL-L 50%

**Kluczowe liczby:**
| Wartość | Opis |
|---------|------|
| 4.5:1 | Minimum WCAG AA (normalny tekst) |
| 3:1 | WCAG AA (duży tekst i komponenty UI) |

**Źródła:** WCAG 2.2 SC 1.4.3 (2023), CIE 1976 CIELAB Standard, IEC 61966-2-1 sRGB (1999)

---

#### 7. Psychologia kolorów

> **TL;DR:** Kolory wyzwalają automatyczne reakcje emocjonalne. Są kształtowane kulturowo, nie uniwersalnie.

**Zasada:**
- 🔴 Czerwony: energia, pilność, niebezpieczeństwo — mierzalnie przyspiesza tętno (Elliot i in. 2007)
- 🔵 Niebieski: zaufanie, spokój, kompetencja — dominuje w finansach i IT (60%+ logo Fortune 500)
- 🟢 Zielony: wzrost, sukces, potwierdzenie — uniwersalnie sygnalizuje pozytywne akcje
- 🟡 Żółty: optymizm, ostrzeżenie — najwyższa widoczność, ale najniższy kontrast luminancji
- ⚫⚪ Czarny i biały: premium, minimalizm — brak przeciążenia emocjonalnego

**Dlaczego działa:**
- Układ limbiczny przetwarza kolor przed świadomą analizą — w ok. 200ms
- Uwarunkowanie ewolucyjne: czerwień sygnalizuje krew/niebezpieczeństwo, zieleń — bezpieczną roślinność
- Nakładka kulturowa: biel = czystość na Zachodzie, ale żałoba w częściach Azji

**Kiedy się łamie:**
- Różnice kulturowe mają znaczenie: zieleń jest święta w kontekstach islamskich, fiolet sygnalizuje żałobę w Ameryce Łacińskiej
- Kolor sam nie komunikuje — ślepota barw dotyka 8% mężczyzn, czysto kolorowe sygnały są niedostępne
- Zbyt wiele kolorów sygnałowych naraz = żaden się nie wyróżnia

**W praktyce:**
- Mapowanie CTA: czerwony/pomarańczowy na pilność, niebieski na zaufanie, zielony na potwierdzenie, żółty na ostrzeżenia. Nigdy wszystkie cztery na jednej stronie

**Źródła:** Elliot i in. Color and Psychological Functioning (2007), Labrecque i Milne. Exciting Red and Competent Blue (2012)

---

### 🔤 TYPOGRAFIA (8)

---

#### 1. Interlinia

> **TL;DR:** Tekst: 1.5-1.6. Nagłówki: 1.1-1.3. Zależność odwrotna: większy tekst wymaga ciaśniejszej interlinii.

**Zasada:**
- Nagłówki (H1-H3): 1.1-1.3 — mniej przestrzeni, bo waga wizualna niesie hierarchię
- Tekst główny (16-18px): 1.5-1.6 — minimum WCAG to 1.5
- Mały tekst (12-14px): 1.5-1.7 — więcej przestrzeni kompensuje zmniejszony rozmiar
- Zależność odwrotna: większy tekst = ciaśniejsza interlinia

**Dlaczego działa:**
- Domyślna przeglądarkowa 1.2 jest zbyt ciasna na tekst główny — linie zlewają się wizualnie
- Return sweep: oczy potrzebują wyraźnej separacji pionowej, by trafić w następną linię
- WCAG SC 1.4.12 wymaga skalowalności interlinii do min. 1.5

**Kiedy się łamie:**
- Wąskie kolumny poniżej 40 CPL: 1.3-1.45 wystarcza, bo mniej return sweeps
- Na mobile desktopowe interlinie są często za duże — 1.4-1.5 zwykle lepsze

**W praktyce:**
- Ustawiaj `line-height` jako liczbę bez jednostki (np. `1.5`, nie `1.5em`) — skaluje się prawidłowo z elementami potomnymi

**Kluczowe liczby:**
| Wartość | Opis |
|---------|------|
| 1.1-1.3 | Nagłówki |
| 1.5-1.6 | Tekst główny |
| 1.5 | Minimum WCAG |

---

#### 2. Długość wiersza

> **TL;DR:** 50-75 CPL na tekst główny. Maks. 80 CPL wg WCAG. Użyj `max-width: 65ch` w CSS.

**Zasada:**
- Optymalna: 50-75 znaków na linię (CPL) dla tekstu głównego
- Sweet spot: ok. 66 CPL, wg Bringhurst (1992) i Baymard (2024)
- WCAG 2.2 SC 1.4.8: maks. 80 CPL dla non-CJK, maks. 40 CPL dla CJK
- Mobile: 30-50 CPL typowe z powodu węższego viewportu

**Dlaczego działa:**
- Return sweep: długie linie powodują, że oko trafia w złą linię
- Za krótkie (poniżej 45 CPL): fragmentaryczne znaczenie, więcej ruchów oka, wolniejsze czytanie
- Końcówki zdań wpadają w krótkotrwałe zapomnienie semantyczne powyżej 80 CPL

**Kiedy się łamie:**
- Mikrokopia UI (przyciski, nawigacja): reguły CPL nie mają zastosowania
- Tekst editorialny displayowy często celowo używa 30-45 CPL dla rytmu wizualnego

**W praktyce:**
- Zastosuj `max-width: 65ch` do kontenera artykułu — adaptuje się automatycznie do dowolnego rozmiaru fontu

**Kluczowe liczby:**
| Wartość | Opis |
|---------|------|
| 50-75 | CPL optymalny (tekst) |
| 66 | CPL sweet spot |
| 80 | CPL maks. WCAG AAA |
| 65ch | Rekomendacja CSS max-width |

**Źródła:** WCAG 2.2 SC 1.4.8 (2023), Baymard Institute (2024), Bringhurst. The Elements of Typographic Style (2004)

---

#### 3. Wysokość x

> **TL;DR:** Wysokość x determinuje postrzeganą wielkość. Ponad 90% tekstu to małe litery.

**Zasada:**
- Wysokość x: odległość od linii bazowej do góry małych liter (x, v, w, z)
- Optymalny stosunek: ok. 50% cap height dla tekstu głównego
- Mały tekst poniżej 14px: wybieraj fonty z wysokim x-height (Verdana, Arial) dla lepszej czytelności
- Fonty z niskim x-height (Garamond) wyglądają elegancko, ale wymagają większego rozmiaru

**Dlaczego działa:**
- Ponad 90% tekstu to małe litery — x-height determinuje postrzeganą wielkość
- Dwa fonty przy tym samym rozmiarze punktowym wyglądają różnie z powodu różnic x-height
- Badania pokazują: większy x-height = szybsze czytanie przy małych rozmiarach

**Kiedy się łamie:**
- Bardzo wysoki x-height (powyżej 67%): zmniejsza różnicę między ascenderami i descenderami — litery h i n stają się trudniejsze do rozróżnienia
- Parowanie fontów z bardzo różnym x-height tworzy wizualny dysonans

**W praktyce:**
- W UI poniżej 14px: użyj Inter lub Verdana (wysoki x-height) zamiast Garamond (niski). Czytelność może wzrosnąć nawet 2x

---

#### 4. Zmęczenie capslockiem

> **TL;DR:** CAPS LOCK czyta się 9.5-19% wolniej (Tinker 1955). Usuwa rozpoznawanie kształtu słów.

**Zasada:**
- Wielkie litery czyta się 9.5-19% wolniej (Tinker 1955, 20-minutowe badanie czytania)
- Wymaga ok. 35% więcej przestrzeni poziomej niż mieszana wielkość
- Brak ascenderów i descenderów = brak rozpoznawania kształtu słów → czytanie litera po literze
- Dopuszczalne użycia: krótkie etykiety, tagi, loga i jednolinijkowe nagłówki

**Dlaczego działa:**
- Mieszana wielkość tworzy unikalne sylwetki słów dzięki ascenderom (h, d) i descenderom (g, y)
- CAPS daje każdemu słowu ten sam jednolity kształt — mózg nie może używać heurystyk kształtu
- Efekt: przetwarzanie szeregowe liter zamiast równoległego rozpoznawania słów

**Kiedy się łamie:**
- Nigdy nie używaj CAPS na akapity, tekst główny lub długie fragmenty — zapamiętywanie gorsze o 13%
- Czytniki ekranowe mogą literować ALL CAPS litera po literze jakby to był akronim — użyj CSS `text-transform: uppercase`

**W praktyce:**
- Użyj CSS `text-transform: uppercase` zamiast wpisywania wielkich liter ręcznie — czytniki ekranowe przeczytają to jako słowo

**Kluczowe liczby:**
| Wartość | Opis |
|---------|------|
| 9.5-19% | Wolniejsza prędkość czytania (Tinker 1955) |
| 35% | Dodatkowa wymagana przestrzeń pozioma |

---

#### 5. Parowanie fontów

> **TL;DR:** Dopasowane proporcje (x-height, grubość kreski) + wyraźny kontrast funkcjonalny (nagłówek vs. tekst).

**Zasada:**
- Serif + sans: klasyczne parowanie — proporcje muszą się zgadzać
- Sans + sans: jeden neutralny, jeden ekspresyjny — bez kontrastu nie ma hierarchii
- Display + neutralny: display tylko na krótkie akcenty, nigdy na tekst główny
- Superrodziny (IBM Plex, Source): wspólne metryki z założenia — najbezpieczniejsze podejście

**Dlaczego działa:**
- Dopasowane x-height tworzą harmonijny tekst bieżący nawet gdy style się różnią
- Fonty zbyt podobne = brak kontrastu hierarchii, wygląd niezdecydowany
- Fonty zbyt różne = wizualne zerwanie, zniszczenie spójności systemu

**Kiedy się łamie:**
- Bardzo różne x-height tworzą chaos wizualny przy zestawieniu obok siebie
- Fonty display w tekście głównym niszczą czytelność po ok. 3 liniach

**W praktyce:**
- Playfair Display na H1 i H2 + Source Sans na tekst. Zbliżony x-height, wyraźny kontrast stylistyczny

---

#### 6. Hierarchia typograficzna

> **TL;DR:** Minimum 1.25x stosunek między sąsiednimi poziomami nagłówków. Tekst 16px. H1 ok. 49px.

**Zasada:**
- Użyj skali modularnej ze stałym stosunkiem — Major Third (1.25x) to standard webowy
- 16px tekst skaluje w górę: 20, 25, 31, 39, 49px na H1
- WCAG SC 2.4.6: nagłówki muszą być sekwencyjne — nie pomijaj poziomów
- Użyj `rem` lub `clamp()`, nigdy `px` na nagłówki — umożliwia skalowanie użytkownika

**Dlaczego działa:**
- Prawo Webera: percepcja rozmiaru jest logarytmiczna — dodanie 2px nie tworzy przełomu kategorii
- Stosunek min. 1.20 wymagany, by stworzyć wyraźną kategorię hierarchii
- Dwie zmienne CSS zarządzają całą skalą: `--base: 1rem` i `--ratio: 1.25`

**Kiedy się łamie:**
- Na mobile Major Third (1.25x) jest zbyt agresywny — użyj Minor Third (1.20x) i ogranicz do 3 poziomów nagłówków
- Dla H5 i H6 różnicuj przez wagę i kolor, nie dalszą redukcję rozmiaru

**W praktyce:**
- Ustaw `--base: 1rem` i `--ratio: 1.25` jako zmienne CSS. Zmiana marki = edycja jednej zmiennej

**Kluczowe liczby:**
| Wartość | Opis |
|---------|------|
| 1.25x | Major Third (standard webowy) |
| 1.20x | Minor Third (mobile) |
| 16px | Bazowy rozmiar tekstu |

**Źródła:** WCAG 2.2 SC 2.4.6 i 1.4.4 (2023), Material Design 3 (2024)

---

#### 7. Wyrównanie tekstu

> **TL;DR:** Wyrównuj tekst główny do lewej. Justowanie może stanowić naruszenie WCAG SC 1.4.8 (AAA) w sieci. Tekst wyśrodkowany: maks. 1–3 linie. Liczby w tabelach: wyrównane do prawej.

**Zasada:**
- Wyrównuj tekst główny do lewej w interfejsach LTR. Stała lewa krawędź dla nawrotów sakkadycznych.
- Justowanie (`text-align: justify`) może naruszać WCAG 2.2 F88 / SC 1.4.8 (AAA) w sieci.
- Elastyczne kontenery sprawiają, że odstępy między słowami przy justowaniu stają się nieprzewidywalne w różnych breakpointach.
- Tekst wyśrodkowany: maks. 1–3 linie. Wyłącznie nagłówki, podpisy, krótkie CTA. Nigdy wieloliniowy tekst główny.
- Kolumny liczbowe w tabelach: wyrównane do prawej. Umożliwia porównywanie wartości pozycyjnych.
- RTL (arabski, hebrajski): wyrównaj do prawej przez `dir='rtl'` w HTML, nie ręcznie w CSS.

**Dlaczego działa:**
- Nawroty sakkadyczne potrzebują przewidywalnej lewej kotwicy. Wyrównanie do lewej zapewnia ją na każdej linii.
- Justowanie: zmienna szerokość odstępów między słowami zaburza rytm czytania i nie tworzy prawej kotwicy.
- Ling i van Schaik (2007, n=65): wyrównanie do lewej dawało lepszą dokładność i czas reakcji niż justowanie.
- To samo badanie: uczestnicy subiektywnie preferowali justowanie. Preferencja rozchodzi się z wydajnością.
- Rzeki bieli: nieregularne pionowe luki od rozciągniętych odstępów między słowami. Nasilają się powyżej 200% zoomu.

**Kiedy się łamie:**
- Druk z dzieleniem wyrazów: justowanie akceptowalne przy profesjonalnych algorytmach i stałych szerokościach kolumn. Sieć nie ma tej kontroli.
- Wyśrodkowane nagłówki: uzasadnione przy krótkim tekście wyświetlanym, do ok. 3 linii.
- Dane liczbowe: wyrównaj liczby całkowite i dziesiętne w komórkach tabeli do prawej. Wyrównanie liczbowe do lewej niszczy porównywanie wartości pozycyjnych.

**W praktyce:**
- Tekst główny: `text-align: left`. `max-width: 80ch`.
- WCAG SC 1.4.8: dodaj `line-height: 1.5` i `margin-bottom: 1.5em` obok wyrównania.
- Justowanie w druku: umieść w `@media print`, dodaj `hyphens: auto`. Nigdy nie stosuj justowania poza tym zakresem.
- Kolumny liczbowe: `.numeric { text-align: right }` dla wszystkich komórek wartości i nagłówków.

**Kluczowe liczby:**
| Wartość | Opis |
|---------|------|
| 80ch | Maksymalna długość wiersza (WCAG SC 1.4.8) |
| 1.5 | Minimalna interlinia dla tekstu głównego (WCAG AAA) |
| 1–3 linie | Maksymalna długość tekstu wyśrodkowanego (WCAG Low Vision) |

**Źródła:** WCAG 2.2 SC 1.4.8, Failure F88 (2023), Ling i van Schaik. Displays Journal (2007), W3C Low Vision Accessibility Task Force — Text Justification (2023)

---

#### 8. Krój pisma vs. Font

> **TL;DR:** Krój pisma to system projektowy (np. Helvetica). Font to jedno w pełni sparametryzowane wystąpienie w jego obrębie (np. Helvetica Neue Bold 700). CSS `font-family` dopasowuje nazwę rodziny zarejestrowaną w `@font-face`, która typowo mapuje się na jeden krój. Dwie właściwości, dwa poziomy hierarchii.

**Zasada:**
- Krój pisma: wizualny system projektowy — charakter kreski, proporcje, oś, traktowanie szeryfów. Font: jedno sparametryzowane wystąpienie — wartości osi, metryki, zestaw glifów, tablice feature.
- Hierarchia: jeden krój pisma zawiera jeden lub więcej fontów. Jeden font implementuje dokładnie jeden system projektowy. Wyjątek: superrodziny (szeryfowe + bezszeryfowe, wspólna marka) mogą tworzyć jeden rozszerzony system krojów.
- CSS `font-family`: dopasowanie ciągów względem nazwy rodziny `@font-face`. Typowo 1:1 z krojem. `font-weight`, `font-style`, `font-stretch` wybierają wystąpienie przez algorytm dopasowywania fontów.
- Stos fallback: rozdzielony przecinkami, rozwiązywany od lewej do prawej. Słowa kluczowe generyczne (`sans-serif`, `serif`, `monospace`) to kategorie klasyfikacyjne, nie kroje. Brak systemu projektowego, zdefiniowanych metryk, żadnych gwarancji glifów.
- Fonty zmienne (OpenType 1.8, 2016): jeden plik, pełne continuum projektowe wzdłuż 5 zarejestrowanych osi (wght, wdth, ital, slnt, opsz) plus nieograniczone niestandardowe. Jeden plik zawiera wiele wystąpień. Wystąpienie nie jest tożsame z plikiem.

**Dlaczego działa:**
- Konflacja pochodzi z API DTP Apple i Microsoft z lat 80. `font-family` nazwany dla użytkowników końcowych, nie typografów. W3C zachowało nazewnictwo w CSS Fonts Level 4 i Level 5.
- Interfejsy konsumenckie (Word, Photoshop, Canva) etykietują selektory krojów jako „Font". Brief specyfikujący tylko nazwę kroju pozostawia wystąpienie fonta niezdefiniowane w dziesiątkach potencjalnych krojów.
- Dopasowanie optyczne poprzedza Fonty Zmienne. Klasyczne rodziny miały odrębne kroje dla różnych zakresów rozmiarów (caption, text, display). Fonty Zmienne formalizują to jako oś opsz.
- Spójne parametry fontu w obrębie jednego kroju argumentuje się jako redukcję obcego obciążenia poznawczego (Sweller, 1988). Przeniesienie teoretyczne, nie bezpośredni wynik badań typograficznych.

**Kiedy się łamie:**
- Fonty zmienne: brak odrębnych krojów, tylko ciągłe zakresy osi. Jeden plik, wiele wystąpień plus pełna przestrzeń interpolacji. Hierarchia konceptualna zachowana, granice pliku nie mapują się już na nią.
- Brak jawnego pliku Bold lub Italic: dopasowywanie fontów powraca do najbliższej wagi, następnie syntetyzuje przez pogrubienie kreski lub pochylenie. Synteza jest gorsza, różni się od rysowanych kursyw na poziomie glifu. Każda kombinacja `font-family` + `font-weight` + `font-style` potrzebuje odpowiedniej deklaracji `@font-face`.
- Superrodziny (groteskowa + szeryfowa slab jako jeden system): odrębne systemy projektowe pod jedną marką. To czy to jeden krój czy dwa — decyduje odlewnia, nie fakt techniczny.

**W praktyce:**
- Font zmienny: jeden blok `@font-face`, `font-weight: 100 900`. Tekst główny: 400. Nagłówki: 700. `font-optical-sizing: auto`. Fallback: `'Inter Variable', system-ui, sans-serif`. Dane tabelaryczne: `font-variant-numeric: tabular-nums`. Dziedziczne: `@supports not (font-variation-settings: normal)`. Sprawdź dostępność osi przed `font-variation-settings` — brakująca oś zawodzi po cichu.

**Kluczowe liczby:**
| Wartość | Opis |
|---------|------|
| 5 | Zarejestrowane osie OpenType: wght, wdth, ital, slnt, opsz |
| nieograniczone | Niestandardowe osie wg specyfikacji OpenType 1.8 |
| 88% | Redukcja rozmiaru pliku: 48 plików statycznych vs. 1 Font Zmienny (Monotype, web.dev) |
| > 94% | Globalne wsparcie przeglądarek dla Fontów Zmiennych (Can I Use, 2026) |
| 3 | Minimalna liczba wariantów wagi, by Font Zmienny był wydajniejszy od plików statycznych |
| 100–900 | `font-weight` w CSS; 1–1000 wg specyfikacji OpenType |
| 50%–200% | `font-stretch` wg CSS Fonts Level 4; oś wdth 100 = normalny |

**Źródła:** Specyfikacja OpenType 1.8. Microsoft, Adobe, Google, Apple (2016), W3C. CSS Fonts Module Level 4 (2021), W3C. CSS Fonts Module Level 5 (Working Draft) (2026), ISO/IEC 14496-22. Open Font Format (2019), McNeil, P. The Visual History of Type. Laurence King Publishing (2017), TypeType Type Foundry. Typeface vs Font (2025), Sweller, J. Cognitive Load During Problem Solving (1988)

---

### 📐 SPACING (6)

---

#### 1. System 8pt

> **TL;DR:** Spacing w wielokrotnościach 8: 8, 16, 24, 32, 40, 48. Pixel-perfect na wszystkich gęstościach wyświetlania.

**Zasada:**
- Stosuj spacing w wielokrotnościach 8: 8, 16, 24, 32, 40, 48, 56, 64
- Używaj na marginesach, paddingu, wysokościach i szerokościach komponentów
- Użyj 4pt jako półkroku na ikony, małe przerwy i drobne korekty
- Rozmiary fontów nie muszą być wielokrotnościami 8

**Dlaczego działa:**
- Skalowanie Retina: 8px przy @2x = 16px, przy @3x = 24px — zawsze liczba całkowita
- Tworzy wizualnie wyraziste odstępy bez zbyt wielu zmiennych (vs. baza 4pt lub 6pt)
- Większość rozdzielczości ekranów dzieli się przez 4 lub 8

**Kiedy się łamie:**
- Interlinie powinny być wielokrotnościami 4, nie 8 — kroki co 8 tworzą zbyt szerokie odstępy
- To nie sztywna regula — 6px border-radius jest OK. System to skala, nie więzienie

**W praktyce:**
- 15px rozmiar fontu z 24px interlinią (wielokrotność 4) to poprawna kombinacja

**Kluczowe liczby:**
| Wartość | Opis |
|---------|------|
| 8px | Jednostka bazowa |
| 4px | Półkrok na ikony i drobne korekty |

---

#### 2. System 4pt

> **TL;DR:** Półkrok systemu 8pt. Na typografię i ikony. Nie zastępuje 8pt.

**Zasada:**
- Półkroki 4pt: 4, 8, 12, 16, 20, 24 — uzupełnia 8pt, nie zastępuje
- Na interlinie typografii, padding ikon i gęste interfejsy
- 8pt obsługuje wymiarowanie komponentów i marginesy między głównymi elementami
- 4pt obsługuje interlinie, przerwy ikon i spacing tekstu drugorzędnego

**Dlaczego działa:**
- Interlinia w krokach 8pt jest często za szeroka — 4pt daje więcej opcji: 20, 24, 28px
- Material Design używa 8pt na elementy i 4pt baseline na typografię
- Dokładniejsza kontrola bez wprowadzania zbyt wielu zmiennych

**Kiedy się łamie:**
- Użycie 4pt wszędzie wprowadza zbyt wiele zmiennych i niweluje cel systemu
- Nieparzyste liczby (5, 7, 9) produkują sub-pixelowe rozmycie przy skalowaniu 1.5x

**W praktyce:**
- 15px font, 24px interlinia (wielokrotność 4pt), 8px przerwa ikon (4pt), 16px padding (8pt)

---

#### 3. Bliskość

> **TL;DR:** Bliskość sygnalizuje związek. Równy spacing wszędzie = brak hierarchii.

**Zasada:**
- Powiązane elementy: 4-8px — między etykietami a inputami, ikonami a tekstem
- Elementy w sekcji: 16-24px
- Oddzielne sekcje: 32-48px lub więcej
- Bliskość przewyższa podobieństwo — jest silniejsza niż kolor, kształt czy rozmiar

**Dlaczego działa:**
- Mózg grupuje elementy automatycznie, zanim rozpocznie się świadoma analiza
- Równy spacing wszędzie spłaszcza hierarchię i likwiduje ścieżki skanowania
- Whitespace to nie pusta przestrzeń — to narzędzie grupowania

**Kiedy się łamie:**
- Etykiety oddalone o więcej niż 16px od inputu wyglądają na niepowiązane
- Sekcje bliżej niż 24px wyglądają jak jeden niepodzielony blok

**W praktyce:**
- Test mrużenia: zmruż oczy patrząc na projekt — grupy powinny być natychmiast oczywiste

**Kluczowe liczby:**
| Wartość | Opis |
|---------|------|
| 4-8px | Powiązane elementy |
| 16-24px | W obrębie sekcji |
| 32-48px | Między sekcjami |

---

#### 4. Grid kolumnowy

> **TL;DR:** 12 kolumn (podzielne przez 2, 3, 4, 6). 24px rynny na desktop, 16px na mobile.

**Zasada:**
- Standard 12-kolumnowy: podzielny przez 2, 3, 4 i 6 — maksymalna elastyczność layoutu
- Rynny: 16px mobile, 20-32px desktop
- Maks. szerokość kontenera: ok. 1200px (Bootstrap) lub 1600px dla większych projektów
- Responsywne breakpointy: 12 kol → 8 kol → 4 kol → 1 kol

**Dlaczego działa:**
- 12 kolumn wspiera layouty 4-4-4, 3-3-3-3, 6-6, 3-6-3, 2-8-2 bez ułamków
- To standard frameworków (Bootstrap, Material Design) — zmniejsza tarcie z developerami
- Kolumny kontrolują tylko szerokość — treść płynie pionowo

**Kiedy się łamie:**
- Wszystkie 12 kolumn na jeden blok tekstu = ponad 80 CPL — nieczytelne
- Ignorowanie max-width powoduje rozlewanie tekstu na ultra-szerokich ekranach

**W praktyce:**
- Blok tekstu na 8 z 12 kolumn (66%) daje ok. 65 CPL na desktopie — optymalne do czytania

---

#### 5. Grid modularny

> **TL;DR:** Kolumny + wiersze tworzą matrycę. Najlepszy na dashboardy, edytoriale i gridy produktowe.

**Zasada:**
- Kolumny + wiersze formują matrycę modułów — każdy moduł może trzymać treść lub łączyć się z sąsiednimi
- Rynny między modułami: typowo 16-24px
- Najlepiej sprawdza się w dashboardach, layoutach edytorialnych i gridach e-commerce

**Dlaczego działa:**
- Zapewnia jednoczesną kontrolę pionową i poziomą
- Równo wymiarowe moduły ułatwiają celowe łamanie reguł

**Kiedy się łamie:**
- W kontekstach web/mobile sztywne wysokości wierszy są rzadko potrzebne — grid kolumnowy często wystarcza
- Zbyt małe moduły produkują paraliż decyzyjny od zbyt wielu opcji rozmieszczenia

**W praktyce:**
- Dashboard z gridem 4x4: 1 moduł na mały KPI card, 2x2 na wykres, 4x2 na tabelę danych

---

#### 6. Grid bazowy

> **TL;DR:** Baza 4px na rytm typograficzny. Interlinie muszą być wielokrotnościami 4.

**Zasada:**
- Linie poziome w gridzie 4px — wszystkie bazowe linie tekstu leżą na linii gridu
- Interlinie muszą być wielokrotnościami 4: 16, 20, 24, 28, 32px
- Połącz grid 8pt UI z gridiem bazowym 4pt — to standard Material Design

**Dlaczego działa:**
- Grid bazowy 8px jest zbyt szeroki na typografię — 4pt daje lepsze opcje
- Material Design używa gridu bazowego 4pt specjalnie na typografię
- Najwygodniejsze interlinie (20, 24, 28px) to wielokrotności 4

**Kiedy się łamie:**
- Rozmiary fontów nie muszą być wielokrotnościami 4 — tylko interlinie
- Pixel-perfect wyrównanie bazowe między przeglądarkami jest trudne w responsywnym webie

**W praktyce:**
- 16px rozmiar fontu + 24px interlinia (wielokrotność 4) = poprawna i wygodna kombinacja

---

### 🌑 CIENIE I GŁĘBIA (3)

---

#### 1. Podstawy cieni

> **TL;DR:** Jedno źródło światła z góry. Cienie zawsze w dół. Głębia zaczyna się od krawędzi, nie od cieni.

**Zasada:**
- UI symuluje jedno źródło światła z góry (jak światło dzienne lub oświetlenie sufitowe)
- Cienie zawsze skierowane w dół — nigdy w górę
- Górne krawędzie jaśniejsze (zwrócone ku światłu), dolne ciemniejsze (odwrócone)
- Głębia przez kontrast krawędzi jest pierwsza — cienie wzmacniają głębię, nie kompensują jej braku

**Dlaczego działa:**
- Dopasowuje się do ewolucyjnie wbudowanej percepcji głębi od światła słonecznego z góry
- Niespójny kierunek światła powoduje natychmiastowe złamanie postrzeganego realizmu
- Sam kontrast krawędzi pozwala mózgowi wywnioskować pozycję przestrzenną bez cieni

**Kiedy się łamie:**
- Wiele źródeł światła produkuje niespójne sygnały głębi i chaos wizualny
- Używanie cieni do ukrywania złej geometrii nie działa — najpierw napraw kształt

**W praktyce:**
- Nigdy nie używaj czystej czerni. Użyj `rgba(0,0,0, 0.1-0.3)`, by cienie wtapiały się w kolor tła

---

#### 2. System elewacji

> **TL;DR:** 5-7 poziomów elewacji. Wyższa elewacja = większy blur i offset. Używaj tokenów.

**Zasada:**
- Zdefiniuj maks. 5-6 poziomów. Material Design: 0, 1, 2, 4, 6, 8, 16, 24dp
- Poziom 0-1: przyciski i karty — mały blur, subtelny offset
- Poziom 2-3: dropdowny i menu — umiarkowany blur i offset
- Poziom 4-5: modale i dialogi — duży blur i offset

**Dlaczego działa:**
- Wyższa elewacja = cień dalej od obiektu → większy, bardziej miękki, jaśniejszy
- Zbyt wiele poziomów = paraliż decyzyjny i niespójne stosowanie w produkcie
- Spójność ważniejsza niż realizm — stosuj te same poziomy wszędzie

**Kiedy się łamie:**
- Cienie z czystej czerni są zbyt ostre — zawsze `rgba(0,0,0, 0.1-0.3)`
- Cienie na kolorowych tłach muszą być podbarwione, by pasowały do odcienia tła

**W praktyce:**
- Używaj tokenów: `shadow/low`, `shadow/medium`, `shadow/high`. Nigdy nie hardkoduj wartości CSS cienia w komponentach

---

#### 3. Wypukłość vs. wklęsłość

> **TL;DR:** Wypukły: cień pod + jasna górna krawędź. Wklęsły: cień nad + ciemna górna krawędź.

**Zasada:**
- Wypukły (przyciski): cień pod + jasna górna krawędź (`inset 0 1px rgba(255,255,255,0.2)`)
- Wklęsły (inputy, studzienki): cień nad (`inset 0 1px 2px rgba(0,0,0,0.3)`) + jasna dolna krawędź
- Stan wciśnięty: usuń drop shadow, dodaj ciemniejszy cień wklęsły
- Stan hover: zwiększ rozmiar cienia i blur, by symulować unoszenie elementu

**Dlaczego działa:**
- Wypukłość: element siedzi nad powierzchnią — światło trafia w górną krawędź, cień spada pod
- Wklęsłość: element jest wgłębiony — górna krawędź blokuje światło, cień pojawia się na górze
- Interakcja to ruch w osi Z, nie dekoracja

**Kiedy się łamie:**
- Niespójny kierunek światła między elementami wypukłymi i wklęsłymi łamie postrzegany realizm
- Nadmierny realizm tworzy szum wizualny — klarowność zawsze przewyższa fizyczną dokładność

**W praktyce:**
- Stan aktywny przycisku: `transform: translateY(1px)` + zmniejszony cień symuluje fizyczne wciśnięcie

---

### 🧠 PRAWA UX (5)

---

#### 1. Prawo Millera

> **TL;DR:** 7 ± 2 porcje w pamięci roboczej. Nowoczesny szacunek to ok. 4 (Cowan 2001). Struktura bije liczbę.

**Zasada:**
- Przeciętna osoba trzyma ok. 7 ± 2 porcje (chunks) w pamięci roboczej (Miller 1956)
- Nowoczesne badania sugerują bliżej 4 odrębnych elementów (Cowan 2001)
- Chunking: grupuj powiązane elementy w znaczące jednostki, by zmniejszyć obciążenie
- Dotyczy tylko pamięci krótkotrwałej — zanika w 20-30 sekund bez powtarzania

**Dlaczego działa:**
- Co liczy się jako chunk zależy od ekspertyzy — FBI to 1 chunk dla agenta, 3 litery dla reszty
- 10 dobrze ustrukturyzowanych elementów bije 5 chaotycznych — struktura wygrywa z liczbą
- (555) 123-4567 to 3 chunki. 5551234567 to 10 cyfr

**Kiedy się łamie:**
- Nie ma twardego limitu — „musi być dokładnie 7" to błędna interpretacja; sam Miller powiedział, że liczba była przypadkowa
- Znajome bodźce: eksperci przetwarzają więcej niż 7 elementów wygodnie

**W praktyce:**
- Nawigacja: 5-7 elementów top-level, dropdowny na resztę. Formularze: grupuj w sekcje (Osobowe, Adres, Płatność)

**Kluczowe liczby:**
| Wartość | Opis |
|---------|------|
| 7 ± 2 | Miller 1956 — porcje pamięci roboczej |
| ~4 | Cowan 2001 — zaktualizowany szacunek |

---

#### 2. Prawo Hicka

> **TL;DR:** Czas decyzji rośnie logarytmicznie z liczbą opcji: RT = a + b × log₂(n).

**Zasada:**
- RT = a + b × log₂(n) — podwojenie opcji dodaje stałą ilość czasu, nie podwaja go
- Przejście z 2 na 4 opcje dodaje tyle samo czasu co z 4 na 8
- Działa tylko gdy wszystkie opcje są równie prawdopodobne i użytkownik jeszcze nie zna celu

**Dlaczego działa:**
- Więcej opcji wymaga większej pojemności przetwarzania poznawczego → spowalnia decyzję
- Krytyczne dla krótkich list (nawigacja, przyciski akcji); mniej istotne dla długich list z wyszukiwaniem (kontakty)

**Kiedy się łamie:**
- Listy alfabetyczne: użytkownik zna cel, więc Prawo Hicka nie ma zastosowania
- Znajome bodźce: dobrze znane opcje nie zwiększają czasu decyzji

**W praktyce:**
- Checkout: jeden CTA zamiast 5 przycisków opcji płatności na stronie głównej. Progresywne ujawnianie na resztę

---

#### 3. Prawo Jakoba

> **TL;DR:** Użytkownicy spędzają większość czasu na innych stronach. Oczekują, że Twoja działa tak samo.

**Zasada:**
- Użytkownicy przenoszą oczekiwania ze znanych stron na nowe
- Standardowe wzorce: logo lewy-górny, nawigacja górna lub boczna, koszyk prawy-górny
- Odchodzenie od konwencji tworzy krzywą uczenia i zwiększa obciążenie poznawcze

**Dlaczego działa:**
- Konwencjonalny design daje ok. 20-30% wyższą retencję użytkowników
- Projekt 10% lepszy może zawalić, jeśli powoduje 20% więcej frustracji w fazie nauki
- Użytkownicy porzucają strony, które działają inaczej niż oczekują

**Kiedy się łamie:**
- Innowuj tylko gdy poprawa jest znacząca (nie 10%) i dopiero gdy nowy wzorzec staje się uznanym standardem
- Zawsze sprawdzaj konwencje platformy — wytyczne iOS i Android nadpisują ogólne wzorce webowe

**W praktyce:**
- E-commerce: koszyk zawsze prawy-górny, przycisk checkout zawsze po prawej. Nie bądź kreatywny z umiejscowieniem

**Źródła:** Nielsen Norman Group (2000)

---

#### 4. Efekt centrum

> **TL;DR:** Uwaga grawituje ku centrum. Centrum optyczne jest ok. 10% powyżej centrum geometrycznego.

**Zasada:**
- Użytkownicy fiksują się na środku ekranu jako pierwsze, szczególnie przy pierwszym skanie
- Centrum optyczne: ok. 10% powyżej dokładnego środka geometrycznego
- F-pattern na strony z dużą ilością tekstu. Z-pattern na proste strony wizualne. Centrum na landing page'e

**Dlaczego działa:**
- Eye-tracking pokazuje: pierwsza fiksacja ląduje na ok. 50-60% szerokości i 40% wysokości strony
- Tendencja ewolucyjna: centrum pola widzenia ma najwyższą gęstość czopków (fovea)
- Centrum geometryczne wygląda wizualnie nisko — potrzebne lekkie przesunięcie w górę

**Kiedy się łamie:**
- Gęste tekstowo interfejsy: F-pattern dominuje, efekt centrum słabnie
- Na mobile: efekt centrum silniejszy z powodu węższego pola widzenia

**W praktyce:**
- Główne CTA: umieść wertykalnie na 45-48% zamiast 50% — odczytuje się jako lepiej zbalansowane

**Kluczowe liczby:**
| Wartość | Opis |
|---------|------|
| ~10% | Centrum optyczne powyżej geometrycznego |

---

#### 5. Ślepota banerowa

> **TL;DR:** Użytkownicy ignorują wszystko, co wygląda jak reklama, niezależnie od faktycznej treści.

**Zasada:**
- Użytkownicy ignorują elementy wyglądające jak reklamy: prostokąty na górze lub po prawej, migające lub kolorowe boxy
- Dotyczy to również prawdziwych elementów UI o estetyce reklamowej
- Bannery notyfikacji, rotatory hero i wstążki są silnie dotknięte ślepotą banerową

**Dlaczego działa:**
- Filtrowanie poznawcze: doświadczenie webowe trenuje mózg do ignorowania wzorców reklam
- Eye-tracking konsekwentnie pokazuje: prawa kolumna i górne paski są systematycznie pomijane
- Uwarunkowana supresja jest mimowolna i nie może być nadpisana przez użytkownika

**Kiedy się łamie:**
- Puste strony bez kontekstu: elementy banerowe otrzymują więcej uwagi
- Pierwsza sesja: nowi użytkownicy wykazują znacząco mniej ślepoty banerowej

**W praktyce:**
- Krytyczne powiadomienia (np. zgoda na cookies): umieszczaj w płynących elementach UI, nie w klasycznym stylu banerowym. Unikaj prostokątów w lewym-górnym lub prawym-górnym rogu na ważne informacje

**Źródła:** Benway i Lane. Banner Blindness (1998), Nielsen Norman Group Eye-Tracking Studies (2010)

---

### 🖱️ INTERAKCJA (4)

---

#### 1. Rozmiar celu dotykowego

> **TL;DR:** WCAG 2.2 AA minimum: 24×24px. Zalecane: 44×44px (Apple/WCAG AAA) lub 48×48dp (Material). 8px między celami.

**Zasada:**
- WCAG 2.2 AA (SC 2.5.8): 24×24px minimum — lub 24px spacingu wokół, jeśli cel jest mniejszy
- WCAG 2.2 AAA (SC 2.5.5): 44×44px — rozszerzony standard, taki sam jak Apple HIG
- Material Design (Android): 48×48dp minimum — nie 44. iOS: 44×44pt minimum
- Minimum 8px odstępu między sąsiednimi celami wg WCAG. Spacing może zastąpić rozmiar
- Padding liczy się jako obszar celu. Ikona 24px z paddingiem 10px z każdej strony = strefa trafienia 44px

**Dlaczego działa:**
- Średnia opuszka palca: 10-14mm, ok. 28-40px przy standardowym DPI
- Cele poniżej 44px mają 3x wyższy wskaźnik błędów
- Precyzja dotyku spada ok. 15% na dekadę po 40. roku życia

**Kiedy się łamie:**
- Konteksty prowadzenia pojazdu i ruchu: 76×76dp minimum wg Google Design for Driving
- Przycisk serduszka na Instagramie działa przy małym rozmiarze dzięki dużemu buforowi spacingu, nie wymiarom pikseli

**W praktyce:**
- Przycisk z ikoną: ikona 24px z paddingiem 10px z każdej strony = strefa trafienia 44px. Prawidłowe podejście

**Kluczowe liczby:**
| Wartość | Opis |
|---------|------|
| 24×24px | Minimum WCAG 2.2 AA (SC 2.5.8) |
| 44×44px | Minimum WCAG 2.2 AAA + Apple HIG |
| 48×48dp | Minimum Material Design (Android) |
| 8px | Minimalny odstęp między sąsiednimi celami |

---

#### 2. Projektowanie przycisków

> **TL;DR:** 5 stanów: normalny, hover, focus, active, disabled. Każdy ma specyficzne traktowanie kolorystyczne. Maks. 1 primary na ekran. Nigdy nie polegaj tylko na kolorze.

**Zasada:**
- Hierarchia: maks. 1 primary + 1 secondary na sekcję. Nigdy dwa równoważne CTA
- Normalny: wypełnienie z kontrastem 4.5:1 na etykiecie — baza dla wszystkich stanów
- Hover: przyciemnij tło 10-15% (ciemne powierzchnie: rozjaśnij). `cursor:pointer`. Subtelna tranzycja 150ms
- Focus: obrys 2px solid, offset 2px od krawędzi elementu. Kolor musi kontrastować 3:1 z tłem (WCAG 2.4.11). Nigdy nie usuwaj outline — tylko go styluj
- Active/Wciśnięty: przyciemnij 20-30% od normalnego. Opcjonalnie: 1px inset shadow, 1px translate w dół
- Disabled: 40% opacity na całym przycisku. `cursor:not-allowed`. `aria-disabled='true'`. Nigdy nie zmieniaj tylko koloru — opacity to uniwersalny sygnał

**Dlaczego działa:**
- Pierścienie focusu istnieją dla użytkowników klawiatury i przełączników — usunięcie `outline:none` bez zamiennika blokuje ~7% użytkowników
- Przyciemnienie hover 10-15% jest percepcyjnie wystarczające, by sygnalizować interaktywność
- Disabled przy 40% opacity odczytuje się jako „niedostępny" uniwersalnie — wliczając osoby ze ślepotą barw
- Stan active przy 20-30% ciemniejszy zamyka pętlę zwrotną: użytkownik wie, że jego input został zarejestrowany
- Stan ładowania (spinner + disabled) zapobiega double-submit race conditions

**Kiedy się łamie:**
- Dark mode: hover darkening → lightening. Zdefiniuj oba jawnie
- Destrukcyjne akcje (Usuń): zawsze dwuetapowo — czerwony kolor + dialog potwierdzenia. Nigdy jeden nieodwracalny przycisk
- Przyciski icon-only: tooltip wymagany (`aria-label`). Cel dotykowy min. 44×44px nawet jeśli ikona ma 24px
- Ghost buttons na obrazkach: obrys może zniknąć. Zawsze sprawdź kontrast border z tłem za nim

**W praktyce:**
- Primary: pełne wypełnienie, wysoki kontrast etykiety, pełna opacity. Jeden na sekcję ekranu
- Secondary: outlined lub ghost. Ten sam rozmiar co primary, mniejsza waga wizualna
- Tertiary: sam tekst, bez tła i border. Na najmniej ważne akcje
- Kolor pierścienia focus: użyj koloru marki lub systemowego niebieskiego (#0066CC). Offset 2px
- Formuła disabled: weź stan normalny → ustaw opacity 0.4. Nie zmieniaj koloru ani kształtu

**Kluczowe liczby:**
| Wartość | Opis |
|---------|------|
| 4.5:1 | Min. kontrast na etykiecie przycisku (stan normalny) |
| 3:1 | Min. kontrast pierścienia focus (WCAG 2.4.11) |
| 10-15% | Hover: przyciemnienie tła |
| 20-30% | Active/wciśnięty: przyciemnienie tła |
| 40% | Disabled: opacity na całym przycisku |
| 2px / 2px | Pierścień focus: grubość / offset od elementu |

---

#### 3. Padding przycisków

> **TL;DR:** Przycisk tekstowy: symetryczny padding. Ikona + etykieta: wiele systemów projektowych redukuje padding po stronie ikony o wartość odstępu (gap). Tylko ikona: padding = (cel − ikona) ÷ 2. Wszystkie wartości to przybliżenia — dostrajaj wizualnie.

**Zasada:**
- Przycisk tylko tekstowy: symetryczny padding. Standard webowy: 8–12px pionowo, 16–24px poziomo.
- Przycisk z prowadzącą ikoną: wiele systemów projektowych stosuje kompensację opartą na gap — redukując padding po stronie ikony o wartość odstępu. Przykład MD3: 24dp po stronie tekstu, 8dp gap, 16dp po stronie ikony.
- Przycisk z końcową ikoną: ta sama logika w odwrotnej kolejności. Prawy padding jest zmniejszony o wartość gap zamiast lewego.
- Przycisk tylko z ikoną: padding = (rozmiar celu − rozmiar ikony) ÷ 2. Dla celu 48px z ikoną 24px = 12px ze wszystkich stron.
- Wszystkie wartości to przybliżenia. Przy większych ikonach lub ciasnych layoutach koryguj o ±2–4px według oceny wizualnej.

**Dlaczego działa:**
- Symetryczny padding centruje geometrię, nie wagę wizualną. Ikona dodaje masę po jednej stronie i postrzegane centrum przesuwa się, nawet gdy liczby są równe.
- Odstęp ikona–etykieta dalej powiększa stronę ikony. Zmniejszenie paddingu po tej stronie kompensuje to.
- To efekt Gestalt, nie reguła normatywna. MD3 stosuje kompensację opartą na gap spójnie, ale ani Apple HIG, ani WCAG nie definiują jej jako wymagania.

**Kiedy się łamie:**
- Duże ikony (20–24px) z pełną kompensacją gap często nadmiernie korygują. Zmniejsz o 2–4px.
- Ikony wypełnione mają większą wagę optyczną niż ikony obrysowe — mogą wymagać nieco większej korekty.
- Layouty RTL: odwróć asymetrię. Użyj `padding-inline-start` i `padding-inline-end` do automatycznej obsługi.
- Rozmiar celu dotykowego to odrębna kwestia — patrz zasada celu dotykowego.

**W praktyce:**
- Przycisk tekstowy: `padding: 8px 16px` (desktop), `10px 24px` (dotyk).
- Prowadząca ikona (konwencja MD3): `padding: 10px 24px 10px 16px`. Ikona 18dp, gap 8dp.
- Tylko ikona (cel 48px): `padding: 12px`. Sprawdzić w DevTools, że obszar trafienia sięga co najmniej 44px.

**Kluczowe liczby:**
| Wartość | Opis |
|---------|------|
| 16 / 24dp | MD3 strona ikony / strona tekstu (prowadząca ikona) |
| 8dp | Odstęp ikona–etykieta (standard MD3) |
| ±2–4px | Zakres wizualnego dostrajania |

**Źródła:** Material Design 3 — Button specs (2024), Apple Human Interface Guidelines (2024)

---

#### 4. Projektowanie linków

> **TL;DR:** Podkreślenie to uniwersalna affordancja. Stan odwiedzony jest wymagany. Linki inline to nie to samo co linki samodzielne.

**Zasada:**
- Linki inline: zawsze podkreślone — sam kolor nie wystarcza do dostępności
- Linki samodzielne i nawigacyjne: kolor + podkreślenie na hover jest akceptowalne
- Stan odwiedzony: użyj odrębnego koloru na linki, które użytkownik już odwiedził
- Linki zewnętrzne: dodaj marker ikonowy + `target=_blank` z tooltipem ostrzegawczym

**Dlaczego działa:**
- WCAG SC 1.4.1: sam kolor nie wystarcza do rozróżniania linków — wymagane podkreślenie lub inny niekolorowy wyróżnik
- Stan odwiedzony zapewnia orientację przestrzenną — użytkownicy wiedzą, gdzie już byli
- Linki muszą być rozróżnialne od otaczającego tekstu w stosunku 3:1 bez polegania na kolorze

**Kiedy się łamie:**
- Przycisk vs. link: akcje używają przycisków, nawigacja używa linków — semantycznie odrębne, niewymienne
- Zbyt wiele linków inline tworzy szum wizualny i likwiduje ścieżki skanowania

**W praktyce:**
- Ustaw `text-decoration: underline` w tekście głównym. Usuwanie na hover jest błędem — podkreślenie to główna affordancja i musi być zachowane

**Źródła:** WCAG 2.2 SC 1.4.1 Use of Color (2023)

---

### 🔲 IKONY (2)

---

#### 1. Bounding box ikon

> **TL;DR:** Spójny bounding box na wszystkie ikony. Padding różni się wg wagi optycznej (koło potrzebuje więcej niż kwadrat).

**Zasada:**
- Stały bounding box (ramka) dla wszystkich ikon w zestawie: 16, 20, 24, 32 lub 48px
- Standardowy padding: 16px ramka = 1px, 24px ramka = 2px, 48px ramka = 4px
- Żywy obszar = ramka - padding z każdej strony

**Dlaczego działa:**
- Bez stałej ramki spacing między ikonami staje się niespójny w różnych kontekstach
- Waga optyczna: koła wymagają więcej powierzchni niż kwadraty, bo mają więcej przestrzeni negatywnej
- Test rozmycia: zweryfikuj równowagę optyczną sprawdzając, czy wszystkie ikony wyglądają równie ciężko po rozmyciu

**Kiedy się łamie:**
- Matematycznie równe ≠ optycznie równe — wizualna korekta jest zawsze wymagana
- Ścisłe ograniczenia keyline ignorują niezbędne korekty optyczne

**W praktyce:**
- Test rozmycia: nałóż 2px blur na wszystkie ikony. Równa masa wizualna potwierdza prawidłową równowagę optyczną

---

#### 2. Wyrównanie ikon

> **TL;DR:** Wyrównanie optyczne ≠ wyrównanie matematyczne. Okrągłe ikony potrzebują lekkiego przesunięcia w górę.

**Zasada:**
- Wyrównuj ikony do bazowej linii sąsiedniego tekstu, nie do cap height
- Okrągłe ikony potrzebują lekkiego przesunięcia w górę (ok. 1-2px) dla równowagi optycznej
- Przy inline z tekstem `vertical-align: middle` często nie wystarcza — wymagana ręczna korekta optyczna
- Rozmiar ikony względem tekstu: dopasuj do x-height lub cap height kroju

**Dlaczego działa:**
- Centrum optyczne ≠ centrum geometryczne w asymetrycznych kształtach
- Koło w tym samym bounding box co kwadrat wydaje się wizualnie niższe
- Bazowa linia tekstu i dolna krawędź ikony mają różne wizualne środki ciężkości

**Kiedy się łamie:**
- Bardzo złożone kształty ikon: testowanie jest jedyną metodą — żadna formuła nie ma zastosowania
- Różne rozmiary ikon obok tego samego rozmiaru tekstu: każda kombinacja musi być testowana osobno

**W praktyce:**
- Przycisk z ikoną: użyj `display:flex` + `align-items:center` + ręczny offset 1px w górę dla okrągłych ikon

---

### 👁️ PERCEPCJA WIZUALNA (2)

---

#### 1. Waga wizualna

> **TL;DR:** Sześć czynników determinuje wagę wizualną: rozmiar, nasycenie, kontrast luminancji, pozycja, izolacja i kształt.

**Zasada:**
- Sześć czynników: rozmiar, nasycenie, kontrast luminancji, pozycja (pionowa bije poziomą), izolacja (whitespace), kształt (zwarty bije nieregularny)
- Czynniki są kumulatywne — nasuń wszystkie sześć w jednym kierunku, by stworzyć jednoznaczny punkt fokusowy
- Przetwarzanie pre-uwagowe (poniżej 200ms): kolor, rozmiar i luminancja przetwarzane są równolegle

**Dlaczego działa:**
- Eye-tracking (MDPI 2026, n=30, 120Hz): sam kolor tła przesuwa pierwszą fiksację 2.7x
- Post-uwagowe: waga semantyczna (np. twarz) przyciąga oko niezależnie od rozmiaru pikseli
- Twierdzenie Arnheima, że prawa strona jest cięższa, zostało empirycznie obalone (Winner i in. 1987)

**Kiedy się łamie:**
- Efekt Helmholtza-Kohlrauscha: nasycone kolory (niebieski, magenta) wydają się jaśniejsze niż ich wartość luminancji — czysta kalkulacja luminancji nie wystarcza
- Zmienność kulturowa: rozkład wagi lewo-prawo zmienia się z kierunkiem czytania

**W praktyce:**
- CTA: duży, nasycony, wysoki kontrast, górny-środek, izolowany, zwarty kształt. Wszystkie sześć czynników wskazuje ten sam kierunek — jednoznaczny punkt fokusowy

**Kluczowe liczby:**
| Wartość | Opis |
|---------|------|
| < 200ms | Okno przetwarzania pre-uwagowego |

**Źródła:** Arnheim. Art and Visual Perception (1954), MDPI Symmetry (n=30, 120Hz eye-tracking) (2026), Winner i in. (1987)

---

#### 2. Zasada trójpodziału

> **TL;DR:** Podziel kadr na trzecie poziomo i pionowo. Umieszczaj kluczowe elementy na czterech przecięciach. Zasada zapobiega słabym kompozycjom wyśrodkowanym. Nie gwarantuje jednak mocnych.

**Zasada:**
- Dwie poziome i dwie pionowe linie dzielą kadr na 33,33% i 66,67%. Cztery przecięcia to punkty siły.
- Umieszczaj elementy fokusowe (CTA, obiekty, nagłówki) na punkcie siły lub w jego pobliżu, nie w martwym centrum.
- Zasada to heurystyka, nie prawo. Nie ma normatywnego oparcia w WCAG, ISO ani żadnym standardzie dostępności.
- Zasada trójpodziału to przybliżenie złotego podziału (33,3% vs. 38,2%). Oba pojęcia są pokrewne duchem, lecz matematycznie odrębne.

**Dlaczego działa:**
- Wyśrodkowanie tworzy wizualną stagnację. Kompozycja off-center wprowadza napięcie i sugerowany ruch, co zwiększa zaangażowanie.
- W interfejsach LTR nasyconych tekstem lewy-górny obszar często przyciąga uwagę jako pierwszy. Nie jest to universalne i nie dotyczy w równym stopniu wszystkich typów treści i formatów.
- Amirshahi i in. (2014) stwierdzili jedynie słabą korelację między wynikiem ZT a jakością estetyczną. Niski wynik ZT niezawodnie daje słaby obraz, lecz wysoki nie gwarantuje jakości.

**Kiedy się łamie:**
- Pojedyncze izolowane obiekty: Hoh i in. (SIGGRAPH Asia 2023) pokazali, że użytkownicy zdecydowanie preferowali wyśrodkowanie ponad kompozycję opartą na ZT w prostych, jednoobjektowych ujęciach.
- Wideo pionowe (9:16): dane eye-tracking sugerują, że centralne pionowe ułożenie przewyższa kompozycję off-center opartą na ZT przy mobilnych formatach portrait.
- Interfejsy danych (dashboardy, tabele, formularze): zasada nie ma zastosowania. Czytelność i wyrównanie mają pierwszeństwo przed asymetrią kompozycyjną.
- Obiekty symetryczne i formalne (logotypy, portrety frontalne, ujęcia produktów): wyśrodkowanie jest często mocniejszym wyborem.

**W praktyce:**
- Sekcja hero: wyrównaj główny nagłówek do górno-lewego punktu siły. CTA umieść w pobliżu dolno-lewego punktu. Zostaw prawą dwie trzecie jako przestrzeń negatywną lub obraz.
- CSS: `left: 33.33%` i `top: 33.33%` dla absolutnie pozycjonowanych elementów fokusowych. Dla layoutów gridowych użyj `grid-template-columns: 1fr 1fr 1fr` i wskaż kolumnę 1 lub 2 dla głównego elementu.

**Kluczowe liczby:**
| Wartość | Opis |
|---------|------|
| 33,33% / 66,67% | Pozycje linii siatki (poziome i pionowe) |
| 4 | Punkty siły (przecięcia) |
| ~38,2% | Odpowiednik złotego podziału dla porównania |

**Źródła:** Smith. Remarks on Rural Scenery (1797), Amirshahi i in. Art and Perception (2014), Hoh, Zhang, Dodgson. SIGGRAPH Asia 2023 (2023), Tatler. Journal of Vision — Central Fixation Bias (2007)

---

## Podsumowanie kluczowych rzeczy

### Liczba zasad w grupach

| # | Grupa | Liczba zasad | Status |
|---|-------|:------------:|--------|
| 1 | 🎨 Kolor | 7 | ✅ Aktywna |
| 2 | 🔤 Typografia | 8 | ✅ Aktywna |
| 3 | 📐 Spacing | 6 | ✅ Aktywna |
| 4 | 🌑 Cienie i głębia | 3 | ✅ Aktywna |
| 5 | 🧠 Prawa UX | 5 | ✅ Aktywna |
| 6 | 🖱️ Interakcja | 4 | ✅ Aktywna |
| 7 | 🔲 Ikony | 2 | ✅ Aktywna |
| 8 | 👁️ Percepcja wizualna | 2 | ✅ Aktywna |
| | **RAZEM** | **37** | |

> 📌 **Uwaga:** Grupy są numerowane — w przyszłości zasady będą dodawane do istniejących grup. Śledź liczbę zasad w każdej grupie, by wiedzieć, co jest nowe.

---

### Kluczowe liczby do zapamiętania

| Temat | Wartość | Dlaczego |
|-------|---------|----------|
| Proporcje kolorów | 60-30-10 | Dominujący / wspierający / akcent |
| Nasycenie tła | 0-25% | Spokój i profesjonalizm |
| Nasycenie CTA | 60-100% | Wymusza uwagę |
| Kontrast WCAG AA | 4.5:1 (tekst), 3:1 (duży tekst) | Minimum dostępności |
| Interlinia tekstu | 1.5-1.6 | WCAG minimum 1.5 |
| Długość wiersza | 50-75 CPL, sweet spot 66 | Optymalny do czytania |
| CSS max-width | 65ch | Automatyczna adaptacja |
| Max długość wiersza (WCAG) | 80ch | WCAG SC 1.4.8 |
| Maks. linie wyśrodkowane | 1–3 linie | WCAG Low Vision |
| Skala typograficzna | 1.25x (web), 1.20x (mobile) | Modular scale |
| Bazowy rozmiar tekstu | 16px | Standard webowy |
| Font zmienny — wsparcie | > 94% | Przeglądarki globalne (Can I Use, 2026) |
| Font zmienny — osie | 5 zarejestrowanych | wght, wdth, ital, slnt, opsz |
| Grid bazowy | 8pt (UI) + 4pt (typografia) | Pixel-perfect scaling |
| Bliskość powiązanych | 4-8px | Sygnalizuje związek |
| Bliskość sekcji | 32-48px | Sygnalizuje separację |
| Grid kolumnowy | 12 kolumn | Podzielny przez 2, 3, 4, 6 |
| Cel dotykowy AA | 24×24px | WCAG 2.2 minimum |
| Cel dotykowy AAA | 44×44px | Apple HIG / WCAG 2.2 |
| Cel dotykowy Material | 48×48dp | Android minimum |
| Stany przycisków | 5 | Normal, hover, focus, active, disabled |
| Hover przyciemnienie | 10-15% | Sygnalizuje interaktywność |
| Disabled opacity | 40% | Uniwersalny sygnał niedostępności |
| Pamięć robocza | 4-7 elementów | Miller/Cowan |
| Przetwarzanie pre-uwagowe | < 200ms | Kolor, rozmiar, luminancja |
| Zasada trójpodziału — linie | 33,33% / 66,67% | Pozycje siatki (H i V) |
| Zasada trójpodziału — punkty | 4 | Punkty siły (przecięcia) |

---

### Najważniejsze zasady ogólne

1. **Struktura > Kolor** — Jeśli UI nie działa w szarości, jest zepsute. Kolor to ulepszenie, nie naprawa
2. **Spójność > Realizm** — Stosuj te same tokeny, skale i systemy wszędzie
3. **Dostępność to minimum** — WCAG to baseline, nie cel aspiracyjny
4. **Mniej = więcej** — 4-6 stopni szarości, 5-6 poziomów elewacji, 5-7 pozycji nawigacji
5. **Optyczne > matematyczne** — Wyrównanie percepcyjne zawsze przewyższa geometryczne
6. **Testuj wizualnie** — Squint test, blur test, WCAG contrast check — nigdy nie ufaj liczbom ślepo
