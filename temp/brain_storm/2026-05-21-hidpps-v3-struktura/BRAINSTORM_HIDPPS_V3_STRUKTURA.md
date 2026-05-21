# Brainstorm: Struktura raportu HiDPPS v3

Data: 2026-05-21. Tryb: mały. Cel: zaproponować spis rozdziałów raportu z projektu rozproszonej bazy danych "Hurtownia i Dystrybucja Przetworzonych Produktow Spożywczych". Bez treści, tylko struktura. Zatwierdzenie zanim powstanie v3.

## Zasady tej iteracji

1. Język polski. Terminy techniczne tylko gdy nie ma polskiego odpowiednika i wtedy wyjaśnione przy pierwszym użyciu.
2. Bez słów "uproszczony", "MVP", "scope", "constraints", "soft delete" w treści raportu.
3. Bez długiej kreski (em-dash). Używamy zwykłego myślnika lub średnika.
4. Pełna nazwa "Hurtownia i Dystrybucja Przetworzonych Produktów Spożywczych" pojawia się w tytule i wprowadzeniu, dalej można używać HiDPPS po jawnym wprowadzeniu w słowniku.
5. Każdy rozdział ma jeden cel i nie powtarza treści innego.

## Tablica prawdy

| Numer | Zasada | Status |
|-------|--------|--------|
| 1 | Wszystkie 13 wymagań technicznych z [Projekt.md](../../../RBZ/PROJEKT/Projekt.md) musi być pokryte w jednym z rozdziałów technicznych | Obowiązkowa |
| 2 | Dział "Wymagania biznesowe" jest osobnym rozdziałem i jest zanim pojawi się architektura | Obowiązkowa |
| 3 | Słownik pojęć jest na początku raportu, nie na końcu | Obowiązkowa |
| 4 | Diagram architektury jest jedną figurą, bez nakładania się elementów | Obowiązkowa |
| 5 | Każda procedura składowana opisana jest najpierw słownie, dopiero potem kodem | Obowiązkowa |

## Pomysły na układ rozdziałów

### Pomysł 1: układ klasyczny inżynierski (10 rozdziałów)

1. Wprowadzenie
2. Słownik pojęć i skrótów
3. Opis dziedziny problemu
4. Wymagania biznesowe
5. Wymagania funkcjonalne i niefunkcjonalne
6. Architektura rozproszonej bazy danych
7. Model danych
8. Mechanizmy rozproszone (pokrycie 13 punktów)
9. Procedury składowane i logika serwera
10. Podsumowanie i podział pracy

Ocena: 8 na 10. Zaleta: znajomy układ z innych raportów PI. Wada: 10 rozdziałów to dużo, część można połączyć.

### Pomysł 2: układ skrócony 7 rozdziałów

1. Wprowadzenie
2. Słownik pojęć
3. Opis dziedziny i wymagania biznesowe (jeden rozdział z dwoma podrozdziałami)
4. Architektura i model danych
5. Mechanizmy rozproszone (13 wymagań w podrozdziałach)
6. Procedury składowane
7. Wnioski i podział pracy

Ocena: 7 na 10. Zaleta: krótko. Wada: zbyt mocno łączy dziedzinę z wymaganiami.

### Pomysł 3: układ rekomendowany 9 rozdziałów

1. Wprowadzenie
2. Słownik pojęć i skrótów
3. Opis dziedziny i procesu biznesowego
4. Wymagania biznesowe
5. Wymagania funkcjonalne i niefunkcjonalne
6. Architektura rozproszonej bazy danych (jeden czytelny diagram)
7. Model danych (osobno per baza, z diagramem dla każdej)
8. Realizacja mechanizmów rozproszonych (13 podrozdziałów numerowanych zgodnie z [Projekt.md](../../../RBZ/PROJEKT/Projekt.md))
9. Procedury i logika po stronie serwera bazy
10. Wnioski, ograniczenia i podział pracy

Ocena: 9 na 10. Zaleta: czytelne rozdzielenie biznesu od mechanizmów. Wada: rozdział 8 może być długi.

## Rekomendacja

Pomysł 3. Spełnia tablicę prawdy i jest najbliżej raportu akademickiego, jaki użytkownik wskazał (układ jak w LaTeX).

## Szczegółowy układ rekomendowany

### Rozdział 1. Wprowadzenie

Cel: powiedzieć co to za dokument, czego dotyczy projekt, dla kogo jest raport. Zawartość: pełna nazwa projektu, autorzy, kontekst przedmiotu, krótki cel projektu w 2-3 zdaniach, struktura raportu.

### Rozdział 2. Słownik pojęć i skrótów

Cel: wyjaśnić każde pojęcie techniczne i biznesowe zanim padnie w tekście. Tabela: skrót, pełna nazwa, krótki opis po polsku. Przykładowe pozycje: HiDPPS, FEFO, HACCP, WMS, MS DTC, OraMTS, MERGE, OPENROWSET, OPENQUERY, łącze bazy danych (Database Link), serwer powiązany (Linked Server), partia, strefa magazynowa.

### Rozdział 3. Opis dziedziny i procesu biznesowego

Cel: pokazać czym zajmuje się firma i jak płynie informacja. Zawartość:
- Krótki opis firmy (hurtownia spożywcza, klienci hurtowi i punkty detaliczne).
- Główne procesy: przyjmowanie towaru od dostawcy, składowanie z podziałem na strefy temperaturowe, kompletacja zamówienia metodą rozchodu według daty ważności (FEFO), sprzedaż, archiwizacja.
- Role w firmie: pracownik zakupów, magazynier, sprzedawca, pracownik finansów.

### Rozdział 4. Wymagania biznesowe

Cel: lista numerowana wymagań biznesowych napisanych językiem firmowym, nie technicznym. Po polsku, normalnym tonem, bez angielskich wstawek. Przykład formy (treść do napisania w v3):

1. Firma prowadzi centralny katalog produktów wraz z kategorią i wymaganą strefą temperaturową.
2. Każdy produkt może być oferowany przez wielu dostawców, a ceny zakupu są obowiązujące w określonych przedziałach czasowych.
3. Towar magazynowany jest w partiach posiadających numer, datę produkcji oraz datę przydatności do spożycia.
4. Rozchód towaru z magazynu odbywa się według zasady FEFO (najpierw schodzi towar o najwcześniejszej dacie przydatności).
5. Zamówienia klientów obsługiwane są przez dział sprzedaży i mogą być anulowane do momentu wydania towaru.
6. Ceny sprzedaży zależą od segmentu klienta.
7. Każda pozycja zamówienia powinna zachować cenę z chwili złożenia zamówienia.
8. Stary materiał handlowy (zakończone zamówienia starsze niż dwa lata) przenoszony jest do archiwum.
9. Dział finansów ma dostęp do własnej ewidencji opłat i kosztów, niewidocznej dla innych działów.
10. Przedstawiciel handlowy może rejestrować wstępne oferty w pliku poza siecią firmową, a następnie zaimportować je do systemu centralnego.
11. Cennik dostawców trafia do firmy w postaci pliku biurowego (Excel) i musi być możliwy do odczytu wprost z bazy danych centrali.
12. System ma być odporny na niezgodność produktu ze strefą magazynową (kontrola HACCP).

### Rozdział 5. Wymagania funkcjonalne i niefunkcjonalne

Cel: pokazać co system robi i jakie ma cechy jakościowe.

Podrozdział 5.1 Wymagania funkcjonalne. Lista numerowana, krótkie zdania w stylu "system pozwala na ...".

Podrozdział 5.2 Wymagania niefunkcjonalne. Kategorie:
- Wydajność: czas odpowiedzi na zapytanie raportowe, dopuszczalne opóźnienie replikacji.
- Bezpieczeństwo: role i prawa w bazie Oracle, kontrola dostępu do działu finansów.
- Spójność danych: atomowość operacji rezerwacji i zmiany statusu zamówienia.
- Dostępność: brak wymogu wysokiej dostępności, ale operacje sprzedaży nie powinny zatrzymywać się z powodu chwilowej niedostępności magazynu.
- Łatwość rozbudowy: model danych ma być rozszerzalny o nowe kategorie i strefy.

### Rozdział 6. Architektura rozproszonej bazy danych

Cel: pokazać jakie serwery, jakie bazy, jakie połączenia. Jeden diagram (Mermaid), zaprojektowany tak żeby elementy nie nakładały się: trzy poziomy w pionie (źródła zewnętrzne, serwery SQL Server, serwer Oracle z trzema schematami).

Podrozdział 6.1 Wybór technologii i uzasadnienie podziału na trzy serwery.
Podrozdział 6.2 Diagram architektury (jeden, czytelny).
Podrozdział 6.3 Tabela serwerów i baz: nazwa, rola, użytkownik administracyjny.

### Rozdział 7. Model danych

Cel: pokazać tabele i relacje per baza.

Podrozdział 7.1 Baza centrali (SQL Server numer jeden): wykaz tabel, diagram związków encji, opis kluczy.
Podrozdział 7.2 Baza magazynu (SQL Server numer dwa).
Podrozdział 7.3 Schemat sprzedaży (Oracle).
Podrozdział 7.4 Schemat archiwum (Oracle).
Podrozdział 7.5 Schemat finansów (Oracle).

### Rozdział 8. Realizacja mechanizmów rozproszonych

Cel: pokazać jak każde z trzynastu wymagań technicznych z [Projekt.md](../../../RBZ/PROJEKT/Projekt.md) zostało zrealizowane. Trzynaście podrozdziałów numerowanych dokładnie tak jak punkty w specyfikacji projektu. Każdy podrozdział: krótki opis słowny, kod, weryfikacja.

8.1 Struktura rozproszonej bazy i jej uzasadnienie.
8.2 Polecenie OPENROWSET dla czterech rodzajów źródeł oraz widok wielodostępny.
8.3 Serwery powiązane (Linked Server) dla czterech rodzajów źródeł oraz mapowanie loginów.
8.4 Polecenie OPENQUERY (przekazanie zapytania w trybie pass-through).
8.5 Operacje wstawiania i modyfikacji danych na zdalnym serwerze.
8.6 Konfiguracja koordynatora transakcji rozproszonych Microsoftu (MS DTC) i scenariusz transakcji rozproszonej.
8.7 Replikacja (transakcyjna oraz migawkowa).
8.8 Użytkownicy i role w bazie Oracle.
8.9 Łącza bazy danych publiczne i prywatne (Database Link).
8.10 Symulacja zdalnego źródła przez łącze bazy danych.
8.11 Widok rozproszony Oracle z rzutowaniem typów.
8.12 Wyzwalacze typu INSTEAD OF na widoku rozproszonym.
8.13 Procedury w języku PL/SQL.

### Rozdział 9. Procedury i logika po stronie serwera bazy

Cel: pokazać procedury, które realizują logikę biznesową, w jednym miejscu (a nie rozproszone po rozdziale 8). Każda procedura: cel, parametry, opis działania słowny, kod. Procedury rozpisane w tym rozdziale:
- Procedura rezerwacji towaru metodą FEFO (SQL Server, magazyn).
- Procedura przekazania katalogu produktów z centrali do bazy Oracle.
- Procedura potwierdzenia zamówienia z transakcją rozproszoną.
- Pakiet PL/SQL po stronie Oracle: rejestracja zamówienia, dodanie pozycji, anulowanie, raport najlepszych klientów, scalenie tabeli pomocniczej katalogu.

### Rozdział 10. Wnioski, ograniczenia i podział pracy

Cel: krótkie zamknięcie.

Podrozdział 10.1 Wnioski merytoryczne (co projekt pokazuje).
Podrozdział 10.2 Ograniczenia obecnej wersji projektu (zapisane normalnym językiem, bez nazwy "ograniczenia MVP").
Podrozdział 10.3 Podział pracy między autorów.

## Co zmieniam w stosunku do wersji drugiej

| Co | Wersja druga | Wersja trzecia |
|----|--------------|----------------|
| Tytuł rozdziału pierwszego | "Streszczenie" | "Wprowadzenie" |
| Słownik pojęć | Brak | Rozdział drugi |
| Rozdział o wymaganiach biznesowych | Brak | Rozdział czwarty (lista numerowana po polsku) |
| Wymagania funkcjonalne i niefunkcjonalne | Brak | Rozdział piąty |
| Diagram architektury | Jeden, ale nakładający się | Jeden, trzy poziomy w pionie, bez nakładania |
| Pokrycie 13 wymagań | Tabela w pierwszym rozdziale | Tabela w drugim rozdziale plus pełne podrozdziały 8.1 do 8.13 |
| Język | Mieszany polsko-angielski | Polski, terminy techniczne tylko gdy konieczne i wyjaśnione w słowniku |
| Procedury | Rozsiane | Skupione w rozdziale dziewiątym |

## Otwarte pytania do zatwierdzenia

| Numer | Pytanie |
|-------|---------|
| 1 | Czy układ rozdziałów (1 do 10) jest akceptowalny? |
| 2 | Czy lista wymagań biznesowych w rozdziale czwartym ma być dokładnie taka jak w punkcie 4.X powyżej, czy zmieniamy zakres? |
| 3 | Czy diagram architektury ma być jeden (rekomendacja) czy trzy oddzielne (centrala, magazyn, Oracle)? |
| 4 | Czy diagramy związków encji robimy dla każdej bazy oddzielnie (rekomendacja), czy jeden zbiorczy? |

## Plan działania po zatwierdzeniu

1. Backup obecnej wersji drugiej do pliku HiDPPS_v2.md.
2. Przepisanie HiDPPS.md zgodnie z układem z tego brainstormu.
3. Przepisanie diagramu architektury tak, aby elementy nie nakładały się.
4. Weryfikacja słownika pod kątem każdego skrótu użytego w treści.
5. Weryfikacja, że wszystkie 13 wymagań technicznych ma swój podrozdział w rozdziale ósmym.
