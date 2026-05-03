---
name: ui-ux-design
description: "37 zasad UI/UX design z naukowymi źródłami. USE FOR: sprawdzanie projektu UI pod kątem fundamentalnych zasad designu, ocena kolorystyki/typografii/spacingu/cieni/interakcji, projektowanie interfejsu zgodnie z WCAG i best practices, diagnostyka 'dlaczego coś wygląda źle'. Grupy: Kolor (7), Typografia (8), Spacing (6), Cienie (3), Prawa UX (5), Interakcja (4), Ikony (2), Percepcja wizualna (2). Komendy: `ui review`, `ux audit`, `design check`."
---

## Kiedy używać

Gdy potrzebujesz:
- sprawdzić projekt UI pod kątem fundamentalnych zasad designu,
- ocenić kolorystykę, typografię, spacing, cienie i interakcje,
- zaprojektować lub zrefaktoryzować interfejs zgodnie ze standardami WCAG i best practices,
- szybko sprawdzić „dlaczego coś wygląda źle" — tu jest odpowiedź.

> **Uwaga:** Ten plik jest wersją operacyjną. Jeśli chcesz dopracować konkretną metodę albo wejść głębiej w uzasadnienia, szukaj szczegółów w `BIGSKILL.md`.

---

## Spis zasad

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

> **Pełna treść zasad:** Ten plik zawiera operacyjny skrót 37 zasad. Szczegółowe rozwinięcia, szersze opisy metod i pogłębienie znajdziesz w `BIGSKILL.md`.

---

### 🎨 KOLOR (7)

#### 1. Zasada 60-30-10
60% kolor dominujący, 30% wspierający, 10% akcent. Strukturyzuje hierarchię kolorów bez chaosu wizualnego.

#### 2. Kontrola nasycenia
0-25% na tła, 25-60% na elementy UI, 60-100% na CTA. Chodzi o hierarchię uwagi: jeśli wszystko jest nasycone, nic się nie wyróżnia.

#### 3. Najpierw szarość
Struktura musi działać w szarości. Kolor to ulepszenie, nie łatka. Skala 9-stopniowa (100-900), aktywny zestaw 4-6 stopni na ekran.

#### 4. Skala kolorów
Skala 100-900, zacznij od 500, zdefiniuj skrajności, wypełnij luki. Odcień musi rotować na skrajnych stopniach.

#### 5. Nazewnictwo kolorów
Prymitywy (100-900) przechowują wartości. Semantyka (`Text/Primary`, `Background/Page`) definiuje znaczenie. Format: `[Element]/[Cel]/[Stan]`.

#### 6. Luminancja vs. jasność
HSL-L nie jest miarą kontrastu. WCAG używa luminancji (Y = 0.2126R + 0.7152G + 0.0722B). Min. kontrast: 4.5:1 tekst, 3:1 duży tekst/UI. Jeśli coś "wygląda jasno", to jeszcze nie znaczy, że jest czytelne.

#### 7. Psychologia kolorów
🔴 energia/pilność, 🔵 zaufanie/spokój, 🟢 wzrost/sukces, 🟡 optymizm/ostrzeżenie, ⚫⚪ premium/minimalizm. Kształtowane kulturowo, nie uniwersalnie, więc kolor wzmacnia komunikat, ale nie może być jedynym nośnikiem znaczenia.

---

### 🔤 TYPOGRAFIA (8)

#### 1. Interlinia
Tekst: 1.5-1.6. Nagłówki: 1.1-1.3. WCAG min. 1.5. Zależność odwrotna: większy tekst = ciaśniejsza interlinia.

#### 2. Długość wiersza
50-75 CPL, sweet spot 66. WCAG max 80 CPL. CSS: `max-width: 65ch`.

#### 3. Wysokość x
Determinuje postrzeganą wielkość. >90% tekstu to małe litery. Poniżej 14px: wybieraj fonty z wysokim x-height (Inter, Verdana).

#### 4. Zmęczenie capslockiem
CAPS czyta się 9.5-19% wolniej (Tinker 1955). Wymaga ~35% więcej przestrzeni. Użyj CSS `text-transform: uppercase`.

#### 5. Parowanie fontów
Dopasowane proporcje (x-height, grubość kreski) + wyraźny kontrast funkcjonalny. Superrodziny — najbezpieczniejsze. Dobre parowanie ma porządkować hierarchię, a nie wyglądać jak przypadkowy miks.

#### 6. Hierarchia typograficzna
Min. 1.25x stosunek między poziomami. Tekst 16px, H1 ~49px. Major Third (1.25x) web, Minor Third (1.20x) mobile.

#### 7. Wyrównanie tekstu
Tekst główny: do lewej. Justowanie: może naruszać WCAG F88. Wyśrodkowany: max 1-3 linie. Liczby: do prawej.

#### 8. Krój pisma vs. Font
Krój = system projektowy. Font = jedno sparametryzowane wystąpienie. Fonty zmienne: 5 zarejestrowanych osi, >94% wsparcie przeglądarek.

---

### 📐 SPACING (6)

#### 1. System 8pt
Spacing w wielokrotnościach 8: 8, 16, 24, 32, 40, 48. Pixel-perfect na wszystkich gęstościach. 4pt jako półkrok.

#### 2. System 4pt
Półkrok systemu 8pt. Na typografię i ikony. Interlinie w krokach 4pt: 20, 24, 28px.

#### 3. Bliskość
Powiązane elementy: 4-8px. W sekcji: 16-24px. Między sekcjami: 32-48px. Test mrużenia oka.

#### 4. Grid kolumnowy
12 kolumn (podzielne przez 2, 3, 4, 6). Rynny: 16px mobile, 20-32px desktop. Max-width: ~1200px.

#### 5. Grid modularny
Kolumny + wiersze = matryca modułów. Na dashboardy, edytoriale, gridy produktowe.

#### 6. Grid bazowy
Baza 4px na rytm typograficzny. Interlinie wielokrotnościami 4: 16, 20, 24, 28, 32px.

---

### 🌑 CIENIE I GŁĘBIA (3)

#### 1. Podstawy cieni
Jedno źródło światła z góry. Cienie w dół. Nigdy czysta czerń — `rgba(0,0,0, 0.1-0.3)`.

#### 2. System elewacji
5-7 poziomów. Wyższa elewacja = większy blur i offset. Tokeny: `shadow/low`, `shadow/medium`, `shadow/high`.

#### 3. Wypukłość vs. wklęsłość
Wypukły: cień pod + jasna górna krawędź. Wklęsły: cień nad + ciemna górna krawędź. Hover: zwiększ cień. Active: `translateY(1px)`.

---

### 🧠 PRAWA UX (5)

#### 1. Prawo Millera
7±2 porcje w pamięci roboczej (Miller 1956). Nowszy szacunek: ~4 (Cowan 2001). Struktura bije liczbę.

#### 2. Prawo Hicka
RT = a + b × log₂(n). Podwojenie opcji dodaje stałą ilość czasu. Progresywne ujawnianie. Jeśli ekran daje za dużo równorzędnych wyborów naraz, decyzja zwalnia.

#### 3. Prawo Jakoba
Użytkownicy oczekują konwencji z innych stron. Innowuj tylko gdy poprawa jest znacząca.

#### 4. Efekt centrum
Centrum optyczne ~10% powyżej geometrycznego. F-pattern tekst, Z-pattern wizualne, centrum landing page.

#### 5. Ślepota banerowa
Użytkownicy ignorują elementy wyglądające jak reklamy. Krytyczne info: płynne elementy UI, nie klasyczny baner.

---

### 🖱️ INTERAKCJA (4)

#### 1. Rozmiar celu dotykowego
WCAG AA: 24×24px. AAA/Apple: 44×44px. Material: 48×48dp. Min. 8px między celami.

#### 2. Projektowanie przycisków
5 stanów: normal, hover (10-15% ciemniej), focus (2px ring 3:1), active (20-30% ciemniej), disabled (40% opacity). Max 1 primary na sekcję. Jeśli wszystkie przyciski krzyczą tak samo mocno, użytkownik nie wie, co jest akcją główną.

#### 3. Padding przycisków
Tekst: 8-12px / 16-24px. Ikona + tekst: kompensacja gap (MD3: 16/24dp). Tylko ikona: (cel − ikona) ÷ 2. Buttony z ikoną nie powinny mieć tego samego spacingu co czysty tekst, bo glyph i label mają inną wagę optyczną.

#### 4. Projektowanie linków
Inline: zawsze podkreślone. Odwiedzony: odrębny kolor. Zewnętrzne: ikona + `target=_blank`.

---

### 🔲 IKONY (2)

#### 1. Bounding box ikon
Spójny bounding box: 16/20/24/32/48px. Padding proporcjonalny. Test rozmycia na równowagę optyczną.

#### 2. Wyrównanie ikon
Wyrównanie optyczne ≠ matematyczne. Okrągłe ikony: +1-2px w górę. `display:flex` + `align-items:center` + korekta.

---

### 👁️ PERCEPCJA WIZUALNA (2)

#### 1. Waga wizualna
6 czynników: rozmiar, nasycenie, kontrast luminancji, pozycja, izolacja, kształt. Kumulatywne. Pre-uwagowe: <200ms. To one decydują, co użytkownik zauważy najpierw, zanim zacznie świadomie czytać ekran.

#### 2. Zasada trójpodziału
Linie w 33.33% / 66.67%. 4 punkty siły (przecięcia). Heurystyka, nie prawo. Pojedynczy obiekt: centrowanie lepsze.

---

## Kluczowe liczby do zapamiętania

| Temat | Wartość | Dlaczego |
|-------|---------|----------|
| Proporcje kolorów | 60-30-10 | Dominujący / wspierający / akcent |
| Kontrast WCAG AA | 4.5:1 tekst, 3:1 duży | Minimum dostępności |
| Interlinia tekstu | 1.5-1.6 | WCAG minimum 1.5 |
| Długość wiersza | 65ch / 50-75 CPL | Optymalny do czytania |
| Skala typograficzna | 1.25x web, 1.20x mobile | Modular scale |
| Grid bazowy | 8pt UI + 4pt typografia | Pixel-perfect |
| Cel dotykowy AA/AAA | 24×24px / 44×44px | WCAG 2.2 |
| Stany przycisków | 5 stanów | Normal, hover, focus, active, disabled |
| Pamięć robocza | 4-7 elementów | Miller/Cowan |

---

## Najważniejsze zasady ogólne

1. **Struktura > Kolor** — Jeśli UI nie działa w szarości, jest zepsute
2. **Spójność > Realizm** — Stosuj te same tokeny, skale i systemy wszędzie
3. **Dostępność to minimum** — WCAG to baseline, nie cel aspiracyjny
4. **Mniej = więcej** — 4-6 stopni szarości, 5-6 poziomów elewacji, 5-7 pozycji nawigacji
5. **Optyczne > matematyczne** — Wyrównanie percepcyjne zawsze przewyższa geometryczne
6. **Testuj wizualnie** — Squint test, blur test, WCAG contrast check
