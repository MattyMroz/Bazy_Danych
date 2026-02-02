-- ============================================================================
-- SZKOŁA MUZYCZNA I STOPNIA - SCENARIUSZE TESTOWE
-- Autorzy: Igor Typiński (251237), Mateusz Mróz (251190)
-- ============================================================================
-- UWAGA: Ten plik należy uruchomić PO wykonaniu plików 01-05 (typy, tabele, 
--        pakiety, triggery, dane testowe). Scenariusze zakładają, że baza
--        zawiera już dane testowe (przedmioty 1-5, grupy 1-3, nauczyciele 1-5,
--        sale 1-4, uczniowie 1-9, lekcje i oceny).
-- ============================================================================

SET SERVEROUTPUT ON;

-- ############################################################################
-- CZĘŚĆ A: DOKUMENTACJA API - OPIS WSZYSTKICH METOD W PAKIETACH
-- ############################################################################

-- ============================================================================
-- PKG_SLOWNIKI - Zarządzanie słownikami (przedmioty, grupy, sale)
-- ============================================================================
/*
┌─────────────────────────────────────────────────────────────────────────────┐
│ PROCEDURA: pkg_slowniki.dodaj_przedmiot(p_nazwa, p_typ)                     │
├─────────────────────────────────────────────────────────────────────────────┤
│ OPIS:     Dodaje nowy przedmiot do słownika przedmiotów                     │
│ PARAMETRY:                                                                  │
│   p_nazwa VARCHAR2  - nazwa przedmiotu (np. 'Flet', 'Perkusja')            │
│   p_typ   VARCHAR2  - typ zajęć: 'indywidualny' lub 'grupowy'              │
│ PRZYKŁAD: EXEC pkg_slowniki.dodaj_przedmiot('Flet', 'indywidualny');       │
│ UWAGA:    Czas trwania lekcji (45 min) ustawiany automatycznie             │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ PROCEDURA: pkg_slowniki.dodaj_grupe(p_symbol, p_poziom)                     │
├─────────────────────────────────────────────────────────────────────────────┤
│ OPIS:     Dodaje nową grupę (klasę) uczniów                                 │
│ PARAMETRY:                                                                  │
│   p_symbol VARCHAR2 - symbol grupy (np. '4A', '5B')                         │
│   p_poziom NUMBER   - poziom klasy 1-6 (klasa I-VI szkoły muzycznej)       │
│ PRZYKŁAD: EXEC pkg_slowniki.dodaj_grupe('4A', 4);                          │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ PROCEDURA: pkg_slowniki.dodaj_sale(p_numer, p_typ, p_pojemnosc, p_wyposaż) │
├─────────────────────────────────────────────────────────────────────────────┤
│ OPIS:     Dodaje nową salę lekcyjną z wyposażeniem (VARRAY)                │
│ PARAMETRY:                                                                  │
│   p_numer      VARCHAR2      - numer sali (np. '105', 'A12')               │
│   p_typ        VARCHAR2      - 'indywidualna' lub 'grupowa'                │
│   p_pojemnosc  NUMBER        - max liczba osób w sali                       │
│   p_wyposazenie t_wyposazenie - VARRAY wyposażenia (max 10 elementów)      │
│ PRZYKŁAD:                                                                   │
│   EXEC pkg_slowniki.dodaj_sale('105', 'indywidualna', 4,                   │
│        t_wyposazenie('Flet poprzeczny', 'Pulpit', 'Metronom'));            │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ FUNKCJA: pkg_slowniki.get_ref_przedmiot(p_id) RETURN REF t_przedmiot       │
│ FUNKCJA: pkg_slowniki.get_ref_grupa(p_id)     RETURN REF t_grupa           │
│ FUNKCJA: pkg_slowniki.get_ref_sala(p_id)      RETURN REF t_sala            │
├─────────────────────────────────────────────────────────────────────────────┤
│ OPIS:     Zwraca referencję REF do obiektu o podanym ID                     │
│ PARAMETRY: p_id NUMBER - identyfikator obiektu                              │
│ WYJĄTEK:  -20010/-20011/-20012 gdy obiekt nie istnieje                     │
│ UŻYCIE:   Wewnętrzne - używane przez inne pakiety do tworzenia powiązań   │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ PROCEDURA: pkg_slowniki.lista_przedmiotow                                   │
│ PROCEDURA: pkg_slowniki.lista_grup                                          │
│ PROCEDURA: pkg_slowniki.lista_sal                                           │
├─────────────────────────────────────────────────────────────────────────────┤
│ OPIS:     Wyświetla listę wszystkich obiektów danego typu                   │
│ PRZYKŁAD: EXEC pkg_slowniki.lista_sal;                                     │
│ WYJŚCIE:  Tekst na DBMS_OUTPUT (SET SERVEROUTPUT ON)                       │
└─────────────────────────────────────────────────────────────────────────────┘
*/

-- ============================================================================
-- PKG_OSOBY - Zarządzanie nauczycielami i uczniami
-- ============================================================================
/*
┌─────────────────────────────────────────────────────────────────────────────┐
│ PROCEDURA: pkg_osoby.dodaj_nauczyciela(p_imie, p_nazwisko, p_id_przedmiotu)│
├─────────────────────────────────────────────────────────────────────────────┤
│ OPIS:     Dodaje nowego nauczyciela przypisanego do JEDNEGO przedmiotu     │
│ PARAMETRY:                                                                  │
│   p_imie          VARCHAR2 - imię nauczyciela                               │
│   p_nazwisko      VARCHAR2 - nazwisko nauczyciela                           │
│   p_id_przedmiotu NUMBER   - ID przedmiotu który nauczyciel będzie uczył   │
│ PRZYKŁAD: EXEC pkg_osoby.dodaj_nauczyciela('Tomasz', 'Flecista', 6);       │
│ UWAGA:    Data zatrudnienia ustawiana automatycznie na SYSDATE             │
│           Nauczyciel może uczyć tylko JEDNEGO przedmiotu (REF)             │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ PROCEDURA: pkg_osoby.dodaj_ucznia(p_imie, p_nazwisko, p_data_ur,           │
│                                   p_instrument, p_id_grupy)                 │
├─────────────────────────────────────────────────────────────────────────────┤
│ OPIS:     Dodaje nowego ucznia przypisanego do grupy                        │
│ PARAMETRY:                                                                  │
│   p_imie       VARCHAR2 - imię ucznia                                       │
│   p_nazwisko   VARCHAR2 - nazwisko ucznia                                   │
│   p_data_ur    DATE     - data urodzenia (format: DATE 'RRRR-MM-DD')       │
│   p_instrument VARCHAR2 - instrument główny (np. 'Fortepian', 'Flet')      │
│   p_id_grupy   NUMBER   - ID grupy do której przypisany jest uczeń         │
│ PRZYKŁAD:                                                                   │
│   EXEC pkg_osoby.dodaj_ucznia('Jan', 'Kowalski', DATE '2014-05-10',        │
│                               'Flet', 4);                                   │
│ UWAGA:    Instrument musi odpowiadać nazwie przedmiotu indywidualnego      │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ FUNKCJA: pkg_osoby.get_ref_nauczyciel(p_id) RETURN REF t_nauczyciel        │
│ FUNKCJA: pkg_osoby.get_ref_uczen(p_id)      RETURN REF t_uczen             │
├─────────────────────────────────────────────────────────────────────────────┤
│ OPIS:     Zwraca referencję REF do osoby o podanym ID                       │
│ WYJĄTEK:  -20013/-20014 gdy osoba nie istnieje                             │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ PROCEDURA: pkg_osoby.lista_nauczycieli                                      │
│ PROCEDURA: pkg_osoby.lista_uczniow                                          │
├─────────────────────────────────────────────────────────────────────────────┤
│ OPIS:     Wyświetla listę wszystkich nauczycieli/uczniów                    │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ PROCEDURA: pkg_osoby.lista_uczniow_grupy(p_id_grupy)                        │
├─────────────────────────────────────────────────────────────────────────────┤
│ OPIS:     Wyświetla uczniów z konkretnej grupy (używa KURSORA JAWNEGO)     │
│ PARAMETRY: p_id_grupy NUMBER - ID grupy                                     │
│ PRZYKŁAD: EXEC pkg_osoby.lista_uczniow_grupy(4);                           │
└─────────────────────────────────────────────────────────────────────────────┘
*/

-- ============================================================================
-- PKG_LEKCJE - Zarządzanie lekcjami (z walidacją konfliktów)
-- ============================================================================
/*
┌─────────────────────────────────────────────────────────────────────────────┐
│ PROCEDURA: pkg_lekcje.dodaj_lekcje_indywidualna(                            │
│              p_id_przedmiotu, p_id_nauczyciela, p_id_sali,                  │
│              p_id_ucznia, p_data, p_godz)                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│ OPIS:     Dodaje lekcję indywidualną (1 nauczyciel + 1 uczeń)              │
│ PARAMETRY:                                                                  │
│   p_id_przedmiotu  NUMBER - ID przedmiotu (musi pasować do nauczyciela!)   │
│   p_id_nauczyciela NUMBER - ID nauczyciela (musi uczyć tego przedmiotu!)   │
│   p_id_sali        NUMBER - ID sali                                         │
│   p_id_ucznia      NUMBER - ID ucznia (musi grać na tym instrumencie!)     │
│   p_data           DATE   - data lekcji (format: DATE 'RRRR-MM-DD')        │
│   p_godz           NUMBER - godzina rozpoczęcia (14-19, pełna godzina)     │
│ WALIDACJE:                                                                  │
│   • Nauczyciel musi uczyć podanego przedmiotu                              │
│   • Instrument ucznia musi odpowiadać przedmiotowi                          │
│   • Sala/nauczyciel/uczeń nie mogą być zajęci w tym terminie               │
│ PRZYKŁAD:                                                                   │
│   EXEC pkg_lekcje.dodaj_lekcje_indywidualna(6, 6, 5, 10,                   │
│        DATE '2025-06-09', 14);                                              │
│ BŁĘDY:                                                                      │
│   -20020: Konflikt terminu (+ sugestia alternatywnego terminu!)            │
│   -20030: Nauczyciel nie uczy tego przedmiotu                               │
│   -20032: Instrument ucznia nie pasuje do przedmiotu                        │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ PROCEDURA: pkg_lekcje.dodaj_lekcje_grupowa(                                 │
│              p_id_przedmiotu, p_id_nauczyciela, p_id_sali,                  │
│              p_id_grupy, p_data, p_godz)                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│ OPIS:     Dodaje lekcję grupową (1 nauczyciel + cała grupa)                │
│ PARAMETRY:                                                                  │
│   p_id_przedmiotu  NUMBER - ID przedmiotu grupowego (KS, Rytmika)          │
│   p_id_nauczyciela NUMBER - ID nauczyciela                                  │
│   p_id_sali        NUMBER - ID sali (musi być typu 'grupowa'!)             │
│   p_id_grupy       NUMBER - ID grupy uczniów                                │
│   p_data           DATE   - data lekcji                                     │
│   p_godz           NUMBER - godzina rozpoczęcia (14-19)                     │
│ WALIDACJE:                                                                  │
│   • Sala musi być typu 'grupowa'                                            │
│   • Pojemność sali >= liczba uczniów w grupie                               │
│   • Sala/nauczyciel/grupa nie mogą być zajęci w tym terminie               │
│ PRZYKŁAD:                                                                   │
│   EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 3, 4,                         │
│        DATE '2025-06-10', 14);                                              │
│ BŁĘDY:                                                                      │
│   -20021: Konflikt terminu (+ sugestia!)                                    │
│   -20031: Lekcja grupowa w sali indywidualnej                               │
│   -20035: Przepełnienie sali                                                │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ PROCEDURA: pkg_lekcje.plan_ucznia(p_id_ucznia)                              │
├─────────────────────────────────────────────────────────────────────────────┤
│ OPIS:     Wyświetla plan lekcji ucznia (indywidualne + grupowe)            │
│ PARAMETRY: p_id_ucznia NUMBER - ID ucznia                                   │
│ PRZYKŁAD: EXEC pkg_lekcje.plan_ucznia(10);                                 │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ PROCEDURA: pkg_lekcje.plan_nauczyciela(p_id_nauczyciela)                    │
├─────────────────────────────────────────────────────────────────────────────┤
│ OPIS:     Wyświetla plan lekcji nauczyciela                                 │
│ PARAMETRY: p_id_nauczyciela NUMBER - ID nauczyciela                         │
│ PRZYKŁAD: EXEC pkg_lekcje.plan_nauczyciela(6);                             │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ PROCEDURA: pkg_lekcje.plan_dnia(p_data)                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│ OPIS:     Wyświetla wszystkie lekcje w danym dniu                           │
│ PARAMETRY: p_data DATE - data do wyświetlenia                               │
│ PRZYKŁAD: EXEC pkg_lekcje.plan_dnia(DATE '2025-06-09');                    │
└─────────────────────────────────────────────────────────────────────────────┘
*/

-- ============================================================================
-- PKG_OCENY - Zarządzanie ocenami
-- ============================================================================
/*
┌─────────────────────────────────────────────────────────────────────────────┐
│ PROCEDURA: pkg_oceny.wystaw_ocene(p_id_ucznia, p_id_nauczyciela,           │
│                                   p_id_przedmiotu, p_wartosc)               │
├─────────────────────────────────────────────────────────────────────────────┤
│ OPIS:     Wystawia ocenę cząstkową uczniowi                                 │
│ PARAMETRY:                                                                  │
│   p_id_ucznia      NUMBER - ID ucznia                                       │
│   p_id_nauczyciela NUMBER - ID nauczyciela (musi uczyć tego przedmiotu!)   │
│   p_id_przedmiotu  NUMBER - ID przedmiotu                                   │
│   p_wartosc        NUMBER - ocena 1-6                                       │
│ PRZYKŁAD: EXEC pkg_oceny.wystaw_ocene(10, 6, 6, 5);                        │
│ BŁĄD: -20033 gdy nauczyciel nie uczy tego przedmiotu                       │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ PROCEDURA: pkg_oceny.wystaw_ocene_semestralna(p_id_ucznia, p_id_naucz,     │
│                                               p_id_przedmiotu, p_wartosc)   │
├─────────────────────────────────────────────────────────────────────────────┤
│ OPIS:     Wystawia ocenę semestralną (końcową) uczniowi                     │
│ PARAMETRY: Identyczne jak wystaw_ocene                                      │
│ RÓŻNICA:  Ocena oznaczona jako semestralna (semestralna='T')               │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ PROCEDURA: pkg_oceny.oceny_ucznia(p_id_ucznia)                              │
├─────────────────────────────────────────────────────────────────────────────┤
│ OPIS:     Wyświetla wszystkie oceny ucznia                                  │
│ PARAMETRY: p_id_ucznia NUMBER - ID ucznia                                   │
│ PRZYKŁAD: EXEC pkg_oceny.oceny_ucznia(10);                                 │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ FUNKCJA: pkg_oceny.srednia_ucznia(p_id_ucznia, p_id_przedmiotu)            │
│          RETURN NUMBER                                                      │
├─────────────────────────────────────────────────────────────────────────────┤
│ OPIS:     Oblicza średnią ocen cząstkowych ucznia z przedmiotu             │
│ ZWRACA:   Średnia zaokrąglona do 2 miejsc, 0 gdy brak ocen                 │
│ PRZYKŁAD:                                                                   │
│   SELECT pkg_oceny.srednia_ucznia(10, 6) AS srednia FROM DUAL;             │
└─────────────────────────────────────────────────────────────────────────────┘
*/

-- ============================================================================
-- PKG_RAPORTY - Raporty i statystyki
-- ============================================================================
/*
┌─────────────────────────────────────────────────────────────────────────────┐
│ PROCEDURA: pkg_raporty.raport_grup                                          │
├─────────────────────────────────────────────────────────────────────────────┤
│ OPIS:     Wyświetla liczbę uczniów w każdej grupie                          │
│ PRZYKŁAD: EXEC pkg_raporty.raport_grup;                                    │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│ PROCEDURA: pkg_raporty.statystyki                                           │
├─────────────────────────────────────────────────────────────────────────────┤
│ OPIS:     Wyświetla ogólne statystyki szkoły (liczba uczniów, nauczycieli, │
│           grup, sal, lekcji, ocen)                                          │
│ PRZYKŁAD: EXEC pkg_raporty.statystyki;                                     │
└─────────────────────────────────────────────────────────────────────────────┘
*/

-- ############################################################################
-- CZĘŚĆ B: SCENARIUSZE TESTOWE
-- ############################################################################

-- ============================================================================
-- SCENARIUSZ 1: ADMINISTRATOR ROZSZERZA OFERTĘ SZKOŁY
-- ============================================================================
-- Kontekst: Szkoła muzyczna postanowiła rozszerzyć ofertę o nowy instrument
--           (Flet). Administrator musi dodać przedmiot, salę i nauczyciela.
-- ============================================================================

PROMPT ============================================================
PROMPT SCENARIUSZ 1: ADMINISTRATOR ROZSZERZA OFERTE SZKOLY
PROMPT ============================================================

-- 1.1 Sprawdzenie stanu początkowego
PROMPT
PROMPT [1.1] Stan poczatkowy - lista przedmiotow:
EXEC pkg_slowniki.lista_przedmiotow;

PROMPT
PROMPT [1.2] Stan poczatkowy - lista sal:
EXEC pkg_slowniki.lista_sal;

PROMPT
PROMPT [1.3] Stan poczatkowy - lista nauczycieli:
EXEC pkg_osoby.lista_nauczycieli;

-- 1.2 Administrator dodaje nowy przedmiot: Flet (indywidualny)
PROMPT
PROMPT [1.4] Administrator dodaje nowy przedmiot: Flet
EXEC pkg_slowniki.dodaj_przedmiot('Flet', 'indywidualny');

-- 1.3 Administrator dodaje nową salę z wyposażeniem (VARRAY)
PROMPT
PROMPT [1.5] Administrator dodaje nowa sale 105 z wyposazeniem (VARRAY):
EXEC pkg_slowniki.dodaj_sale('105', 'indywidualna', 4, t_wyposazenie('Flet poprzeczny', 'Flet prosty', 'Pulpit x2', 'Metronom', 'Lustro'));

-- 1.4 Administrator dodaje nauczyciela Fletu (REF do przedmiotu ID=6)
PROMPT
PROMPT [1.6] Administrator dodaje nauczyciela Fletu (Tomasz Flecista):
-- Przedmiot Flet ma ID=6 (bo poprzednie 1-5 były w danych testowych)
EXEC pkg_osoby.dodaj_nauczyciela('Tomasz', 'Flecista', 6);

-- 1.5 Weryfikacja zmian
PROMPT
PROMPT [1.7] Weryfikacja - zaktualizowana lista przedmiotow:
EXEC pkg_slowniki.lista_przedmiotow;

PROMPT
PROMPT [1.8] Weryfikacja - zaktualizowana lista sal:
EXEC pkg_slowniki.lista_sal;

PROMPT
PROMPT [1.9] Weryfikacja - zaktualizowana lista nauczycieli:
EXEC pkg_osoby.lista_nauczycieli;


-- ============================================================================
-- SCENARIUSZ 2: SEKRETARIAT TWORZY NOWĄ GRUPĘ I ZAPISUJE UCZNIÓW
-- ============================================================================
-- Kontekst: Nowy rok szkolny - sekretariat tworzy klasę 4A i zapisuje do niej
--           uczniów. Jeden uczeń gra na Flecie (nowy przedmiot), drugi na 
--           Fortepianie (istniejący przedmiot).
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT SCENARIUSZ 2: SEKRETARIAT TWORZY NOWA GRUPE I ZAPISUJE UCZNIOW
PROMPT ============================================================

-- 2.1 Sprawdzenie istniejących grup
PROMPT
PROMPT [2.1] Istniejace grupy przed dodaniem:
EXEC pkg_slowniki.lista_grup;

-- 2.2 Sekretariat dodaje nową grupę 4A (poziom 4 = klasa IV)
PROMPT
PROMPT [2.2] Sekretariat dodaje nowa grupe 4A (klasa IV):
EXEC pkg_slowniki.dodaj_grupe('4A', 4);

-- 2.3 Weryfikacja - grupa dodana
PROMPT
PROMPT [2.3] Grupy po dodaniu:
EXEC pkg_slowniki.lista_grup;

-- 2.4 Sekretariat zapisuje ucznia grającego na FLECIE do grupy 4A (ID=4)
PROMPT
PROMPT [2.4] Zapis ucznia Jakub Melodyjny (Flet) do grupy 4A:
EXEC pkg_osoby.dodaj_ucznia('Jakub', 'Melodyjny', DATE '2014-07-20', 'Flet', 4);

-- 2.5 Sekretariat zapisuje ucznia grającego na FORTEPIANIE do grupy 4A
PROMPT
PROMPT [2.5] Zapis ucznia Karolina Klawiszowa (Fortepian) do grupy 4A:
EXEC pkg_osoby.dodaj_ucznia('Karolina', 'Klawiszowa', DATE '2014-03-15', 'Fortepian', 4);

-- 2.6 Weryfikacja - lista uczniów w nowej grupie (KURSOR JAWNY)
PROMPT
PROMPT [2.6] Uczniowie w grupie 4A (uzycie KURSORA JAWNEGO):
EXEC pkg_osoby.lista_uczniow_grupy(4);

-- 2.7 Pełna lista wszystkich uczniów
PROMPT
PROMPT [2.7] Pelna lista wszystkich uczniow:
EXEC pkg_osoby.lista_uczniow;

-- 2.8 Raport grup po zmianach
PROMPT
PROMPT [2.8] Raport grup - liczba uczniow:
EXEC pkg_raporty.raport_grup;


-- ============================================================================
-- SCENARIUSZ 3: PLANOWANIE LEKCJI GRUPOWYCH
-- ============================================================================
-- Kontekst: Sekretariat planuje zajęcia grupowe z Kształcenia słuchu dla 
--           nowej grupy 4A. Zajęcia prowadzi nauczyciel ID=4 (Piotr Lewandowski)
--           w sali grupowej ID=3 (sala 103).
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT SCENARIUSZ 3: PLANOWANIE LEKCJI GRUPOWYCH
PROMPT ============================================================

-- 3.1 Sprawdzenie planu dnia przed dodaniem lekcji
PROMPT
PROMPT [3.1] Plan dnia 2025-06-09 (poniedzialek) PRZED dodaniem lekcji:
EXEC pkg_lekcje.plan_dnia(DATE '2025-06-09');

-- 3.2 Dodanie lekcji grupowej - Kształcenie słuchu dla grupy 4A
-- Przedmiot: 4 (Kształcenie słuchu), Nauczyciel: 4, Sala: 3 (grupowa), Grupa: 4
PROMPT
PROMPT [3.2] Dodanie lekcji grupowej - Ksztalcenie sluchu dla 4A:
PROMPT       (Przedmiot=4, Nauczyciel=4, Sala=3, Grupa=4, Data=2025-06-09, Godz=17)
EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 3, 4, DATE '2025-06-09', 17);

-- 3.3 Dodanie kolejnej lekcji grupowej - Rytmika dla grupy 4A
-- Przedmiot: 5 (Rytmika), Nauczyciel: 5 (Wójcik), Sala: 4 (rytmika), Grupa: 4
PROMPT
PROMPT [3.3] Dodanie lekcji grupowej - Rytmika dla 4A:
PROMPT       (Przedmiot=5, Nauczyciel=5, Sala=4, Grupa=4, Data=2025-06-13, Godz=14)
EXEC pkg_lekcje.dodaj_lekcje_grupowa(5, 5, 4, 4, DATE '2025-06-13', 14);

-- 3.4 Weryfikacja planu dnia
PROMPT
PROMPT [3.4] Plan dnia 2025-06-09 PO dodaniu lekcji:
EXEC pkg_lekcje.plan_dnia(DATE '2025-06-09');


-- ============================================================================
-- SCENARIUSZ 4: PLANOWANIE LEKCJI INDYWIDUALNYCH
-- ============================================================================
-- Kontekst: Sekretariat planuje lekcje instrumentu dla nowych uczniów.
--           Przypadek A: Wolny termin - lekcja dodana pomyślnie
--           Przypadek B: Konflikt terminu - system sugeruje alternatywę
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT SCENARIUSZ 4: PLANOWANIE LEKCJI INDYWIDUALNYCH
PROMPT ============================================================

-- ============================================================================
-- PRZYPADEK A: WOLNY TERMIN - SUKCES
-- ============================================================================

-- 4.1 Lekcja Fletu dla Jakuba Melodyjnego (uczeń ID=10)
-- Nauczyciel: 6 (Tomasz Flecista), Przedmiot: 6 (Flet), Sala: 5 (sala 105)
PROMPT
PROMPT [4.1] PRZYPADEK A: Wolny termin
PROMPT       Dodanie lekcji Fletu dla Jakuba Melodyjnego:
PROMPT       (Przedmiot=6, Nauczyciel=6, Sala=5, Uczen=10, Data=2025-06-09, Godz=14)
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(6, 6, 5, 10, DATE '2025-06-09', 14);

-- 4.2 Lekcja Fortepianu dla Karoliny Klawiszowej (uczeń ID=11)
-- Nauczyciel: 1 (Anna Kowalska), Przedmiot: 1 (Fortepian), Sala: 1 (sala 101)
PROMPT
PROMPT [4.2] Dodanie lekcji Fortepianu dla Karoliny Klawiszowej:
PROMPT       (Przedmiot=1, Nauczyciel=1, Sala=1, Uczen=11, Data=2025-06-09, Godz=16)
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 11, DATE '2025-06-09', 16);

-- 4.3 Weryfikacja planu ucznia
PROMPT
PROMPT [4.3] Plan ucznia Jakub Melodyjny (ID=10):
EXEC pkg_lekcje.plan_ucznia(10);

PROMPT
PROMPT [4.4] Plan ucznia Karolina Klawiszowa (ID=11):
EXEC pkg_lekcje.plan_ucznia(11);

-- ============================================================================
-- PRZYPADEK B: KONFLIKT TERMINU - SYSTEM SUGERUJE ALTERNATYWĘ
-- ============================================================================

-- 4.5 Próba dodania lekcji w zajętym terminie
-- Sala 101 jest już zajęta 2025-06-02 o 14:00 (lekcja Adama z danych testowych)
PROMPT
PROMPT [4.5] PRZYPADEK B: Konflikt terminu
PROMPT       Proba dodania lekcji w ZAJETYM terminie:
PROMPT       (Sala 101 jest juz zajeta 2025-06-02 o 14:00)
PROMPT
PROMPT       Oczekiwany BLAD -20020 z SUGESTIA alternatywnego terminu:

-- Ta linia CELOWO spowoduje błąd - system zasugeruje wolny termin
BEGIN
    pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 11, DATE '2025-06-02', 14);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 4.6 Użycie sugerowanego terminu (ręczne wpisanie)
PROMPT
PROMPT [4.6] Wpisanie alternatywnego terminu (po przeczytaniu sugestii):
PROMPT       Dodajemy lekcje o 17:00 (zakladamy ze to byl sugerowany termin):
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 11, DATE '2025-06-02', 17);

-- 4.7 Weryfikacja - plan dnia pokazuje nową lekcję
PROMPT
PROMPT [4.7] Plan dnia 2025-06-02 - weryfikacja dodanej lekcji:
EXEC pkg_lekcje.plan_dnia(DATE '2025-06-02');


-- ============================================================================
-- SCENARIUSZ 5: NAUCZYCIEL WYSTAWIA OCENY
-- ============================================================================
-- Kontekst: Po lekcjach nauczyciele wystawiają oceny. Tomasz Flecista (ID=6)
--           ocenia Jakuba z Fletu. Piotr Lewandowski (ID=4) ocenia uczniów
--           z Kształcenia słuchu. Na koniec semestru wystawiane są oceny
--           semestralne.
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT SCENARIUSZ 5: NAUCZYCIEL WYSTAWIA OCENY
PROMPT ============================================================

-- 5.1 Nauczyciel Fletu wystawia oceny cząstkowe
PROMPT
PROMPT [5.1] Tomasz Flecista (ID=6) wystawia oceny Jakubowi (ID=10) z Fletu (ID=6):
EXEC pkg_oceny.wystaw_ocene(10, 6, 6, 5);
EXEC pkg_oceny.wystaw_ocene(10, 6, 6, 4);
EXEC pkg_oceny.wystaw_ocene(10, 6, 6, 5);

-- 5.2 Nauczyciel Fortepianu wystawia oceny
PROMPT
PROMPT [5.2] Anna Kowalska (ID=1) wystawia oceny Karolinie (ID=11) z Fortepianu (ID=1):
EXEC pkg_oceny.wystaw_ocene(11, 1, 1, 6);
EXEC pkg_oceny.wystaw_ocene(11, 1, 1, 5);

-- 5.3 Nauczyciel Kształcenia słuchu wystawia oceny uczniom z grupy 4A
PROMPT
PROMPT [5.3] Piotr Lewandowski (ID=4) wystawia oceny z Ksztalcenia sluchu (ID=4):
EXEC pkg_oceny.wystaw_ocene(10, 4, 4, 4);
EXEC pkg_oceny.wystaw_ocene(11, 4, 4, 5);

-- 5.4 Wystawienie ocen semestralnych
PROMPT
PROMPT [5.4] Wystawienie ocen SEMESTRALNYCH:
-- Ocena semestralna z Fletu dla Jakuba
EXEC pkg_oceny.wystaw_ocene_semestralna(10, 6, 6, 5);
-- Ocena semestralna z Fortepianu dla Karoliny
EXEC pkg_oceny.wystaw_ocene_semestralna(11, 1, 1, 6);
-- Ocena semestralna z Kształcenia słuchu
EXEC pkg_oceny.wystaw_ocene_semestralna(10, 4, 4, 4);
EXEC pkg_oceny.wystaw_ocene_semestralna(11, 4, 4, 5);

-- 5.5 WALIDACJA: Próba wystawienia oceny przez nieuprawnionego nauczyciela
PROMPT
PROMPT [5.5] WALIDACJA: Proba wystawienia oceny przez NIEUPRAWNIONEGO nauczyciela:
PROMPT       (Nauczyciel Fletu probuje wystawic ocene z Fortepianu)
PROMPT       Oczekiwany BLAD -20033:

BEGIN
    pkg_oceny.wystaw_ocene(10, 6, 1, 5);  -- Flecista (6) próbuje ocenić z Fortepianu (1)
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/


-- ============================================================================
-- SCENARIUSZ 6: UCZEŃ I RODZIC SPRAWDZAJĄ OCENY
-- ============================================================================
-- Kontekst: Uczeń (lub rodzic) loguje się do systemu i sprawdza swoje oceny,
--           średnie z przedmiotów oraz plan lekcji.
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT SCENARIUSZ 6: UCZEN I RODZIC SPRAWDZAJA OCENY
PROMPT ============================================================

-- 6.1 Jakub sprawdza swoje oceny
PROMPT
PROMPT [6.1] Jakub Melodyjny (ID=10) sprawdza swoje oceny:
EXEC pkg_oceny.oceny_ucznia(10);

-- 6.2 Karolina sprawdza swoje oceny
PROMPT
PROMPT [6.2] Karolina Klawiszowa (ID=11) sprawdza swoje oceny:
EXEC pkg_oceny.oceny_ucznia(11);

-- 6.3 Sprawdzenie średniej z przedmiotu
PROMPT
PROMPT [6.3] Srednia Jakuba z Fletu (bez oceny semestralnej):
SELECT pkg_oceny.srednia_ucznia(10, 6) AS srednia_z_fletu FROM DUAL;

PROMPT
PROMPT [6.4] Srednia Karoliny z Fortepianu:
SELECT pkg_oceny.srednia_ucznia(11, 1) AS srednia_z_fortepianu FROM DUAL;

-- 6.5 Uczeń sprawdza swój plan lekcji
PROMPT
PROMPT [6.5] Plan lekcji Jakuba Melodyjnego:
EXEC pkg_lekcje.plan_ucznia(10);

PROMPT
PROMPT [6.6] Plan lekcji Karoliny Klawiszowej:
EXEC pkg_lekcje.plan_ucznia(11);


-- ============================================================================
-- SCENARIUSZ 7: RAPORTY DLA DYREKCJI
-- ============================================================================
-- Kontekst: Dyrekcja szkoły generuje raporty podsumowujące stan szkoły.
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT SCENARIUSZ 7: RAPORTY DLA DYREKCJI
PROMPT ============================================================

-- 7.1 Raport grup - ile uczniów w każdej klasie
PROMPT
PROMPT [7.1] Raport grup - liczba uczniow w kazdej klasie:
EXEC pkg_raporty.raport_grup;

-- 7.2 Statystyki ogólne szkoły
PROMPT
PROMPT [7.2] Statystyki ogolne szkoly:
EXEC pkg_raporty.statystyki;

-- 7.3 Plan nauczyciela (np. dla kontroli obciążenia)
PROMPT
PROMPT [7.3] Plan nauczyciela Tomasz Flecista (ID=6):
EXEC pkg_lekcje.plan_nauczyciela(6);

PROMPT
PROMPT [7.4] Plan nauczyciela Piotr Lewandowski (ID=4) - Ksztalcenie sluchu:
EXEC pkg_lekcje.plan_nauczyciela(4);


-- ============================================================================
-- SCENARIUSZ 8: WALIDACJE SYSTEMU - PRZYPADKI BRZEGOWE
-- ============================================================================
-- Kontekst: Demonstracja walidacji i obsługi błędów w systemie.
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT SCENARIUSZ 8: WALIDACJE SYSTEMU - PRZYPADKI BRZEGOWE
PROMPT ============================================================

-- 8.1 TRIGGER: Próba dodania lekcji bez ucznia i bez grupy (naruszenie XOR)
PROMPT
PROMPT [8.1] TRIGGER trg_lekcja_xor - naruszenie reguly XOR:
PROMPT       (Lekcja musi miec ALBO ucznia ALBO grupe)
PROMPT       Oczekiwany BLAD -20001:

BEGIN
    INSERT INTO lekcje VALUES (
        t_lekcja(
            seq_lekcje.NEXTVAL,
            pkg_slowniki.get_ref_przedmiot(1),
            pkg_osoby.get_ref_nauczyciel(1),
            pkg_slowniki.get_ref_sala(1),
            NULL,  -- brak ucznia
            NULL,  -- brak grupy - NARUSZENIE XOR!
            DATE '2025-06-20', 14, 45
        )
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 8.2 TRIGGER: Próba wystawienia oceny poza zakresem 1-6
PROMPT
PROMPT [8.2] TRIGGER trg_ocena_zakres - ocena poza zakresem:
PROMPT       Oczekiwany BLAD -20002:

BEGIN
    INSERT INTO oceny VALUES (
        t_ocena(
            seq_oceny.NEXTVAL,
            pkg_osoby.get_ref_uczen(10),
            pkg_osoby.get_ref_nauczyciel(6),
            pkg_slowniki.get_ref_przedmiot(6),
            7,  -- BŁĄD: ocena poza zakresem 1-6!
            SYSDATE, 'N'
        )
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 8.3 WALIDACJA: Lekcja grupowa w sali indywidualnej
PROMPT
PROMPT [8.3] WALIDACJA pkg_lekcje - lekcja grupowa w sali indywidualnej:
PROMPT       Oczekiwany BLAD -20031:

BEGIN
    -- Sala 1 (101) jest indywidualna, a próbujemy dodać lekcję grupową
    pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 1, 4, DATE '2025-06-20', 14);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 8.4 WALIDACJA: Niezgodność instrumentu ucznia z przedmiotem
PROMPT
PROMPT [8.4] WALIDACJA pkg_lekcje - niezgodnosc instrumentu:
PROMPT       (Jakub gra na Flecie, a probujemy dodac lekcje Fortepianu)
PROMPT       Oczekiwany BLAD -20032:

BEGIN
    -- Jakub (ID=10) gra na Flecie, a próbujemy go zapisać na Fortepian
    pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 10, DATE '2025-06-20', 18);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 8.5 WALIDACJA: Nauczyciel nie uczy danego przedmiotu
PROMPT
PROMPT [8.5] WALIDACJA pkg_lekcje - nauczyciel nie uczy przedmiotu:
PROMPT       (Tomasz Flecista probuje prowadzic lekcje Fortepianu)
PROMPT       Oczekiwany BLAD -20030:

BEGIN
    -- Tomasz Flecista (ID=6) uczy Fletu, a próbujemy przypisać mu Fortepian
    pkg_lekcje.dodaj_lekcje_indywidualna(1, 6, 1, 11, DATE '2025-06-20', 18);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/


-- ============================================================================
-- SCENARIUSZ 9: DEMONSTRACJA VARRAY - WYPOSAŻENIE SAL
-- ============================================================================
-- Kontekst: Pokazanie jak działa VARRAY wyposażenia sal.
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT SCENARIUSZ 9: DEMONSTRACJA VARRAY - WYPOSAZENIE SAL
PROMPT ============================================================

-- 9.1 Lista sal z wyposażeniem (metoda lista_wyposazenia() operuje na VARRAY)
PROMPT
PROMPT [9.1] Lista sal z wyposazeniem (VARRAY):
EXEC pkg_slowniki.lista_sal;

-- 9.2 Bezpośrednie zapytanie pokazujące VARRAY
PROMPT
PROMPT [9.2] Bezposrednie zapytanie - wyposazenie sal:
SELECT s.id, s.numer, s.typ, s.lista_wyposazenia() AS wyposazenie
FROM sale s
ORDER BY s.id;


-- ============================================================================
-- SCENARIUSZ 10: DEMONSTRACJA REF/DEREF
-- ============================================================================
-- Kontekst: Pokazanie jak działają referencje REF i dereferencja DEREF.
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT SCENARIUSZ 10: DEMONSTRACJA REF/DEREF
PROMPT ============================================================

-- 10.1 Nauczyciele z przedmiotami (DEREF na REF do przedmiotu)
PROMPT
PROMPT [10.1] Nauczyciele z przedmiotami (DEREF):
SELECT n.id, 
       n.pelne_nazwisko() AS nauczyciel,
       DEREF(n.ref_przedmiot).nazwa AS przedmiot,
       DEREF(n.ref_przedmiot).typ AS typ_przedmiotu
FROM nauczyciele n
ORDER BY n.id;

-- 10.2 Uczniowie z grupami (DEREF na REF do grupy)
PROMPT
PROMPT [10.2] Uczniowie z grupami (DEREF):
SELECT u.id,
       u.pelne_nazwisko() AS uczen,
       u.instrument,
       DEREF(u.ref_grupa).symbol AS grupa,
       DEREF(u.ref_grupa).poziom AS klasa
FROM uczniowie u
ORDER BY DEREF(u.ref_grupa).poziom, u.nazwisko;

-- 10.3 Lekcje z pełnymi danymi (wielokrotny DEREF)
PROMPT
PROMPT [10.3] Lekcje z pelnymi danymi (wielokrotny DEREF):
SELECT l.id,
       TO_CHAR(l.data_lekcji, 'YYYY-MM-DD') AS data,
       l.godz_rozp || ':00' AS godzina,
       DEREF(l.ref_przedmiot).nazwa AS przedmiot,
       DEREF(l.ref_nauczyciel).pelne_nazwisko() AS nauczyciel,
       DEREF(l.ref_sala).numer AS sala,
       CASE 
           WHEN l.ref_uczen IS NOT NULL THEN DEREF(l.ref_uczen).pelne_nazwisko()
           ELSE 'grupa ' || DEREF(l.ref_grupa).symbol
       END AS kto
FROM lekcje l
WHERE l.data_lekcji >= DATE '2025-06-09'
ORDER BY l.data_lekcji, l.godz_rozp
FETCH FIRST 10 ROWS ONLY;


-- ============================================================================
-- SCENARIUSZ 11: DEMONSTRACJA METOD OBIEKTOWYCH
-- ============================================================================
-- Kontekst: Pokazanie jak działają metody zdefiniowane w typach obiektowych.
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT SCENARIUSZ 11: DEMONSTRACJA METOD OBIEKTOWYCH
PROMPT ============================================================

-- 11.1 Metody typu T_UCZEN
PROMPT
PROMPT [11.1] Metody typu T_UCZEN (pelne_nazwisko, wiek):
SELECT u.pelne_nazwisko() AS pelne_nazwisko, 
       u.wiek() AS wiek_lat, 
       u.instrument
FROM uczniowie u 
WHERE ROWNUM <= 5;

-- 11.2 Metody typu T_NAUCZYCIEL
PROMPT
PROMPT [11.2] Metody typu T_NAUCZYCIEL (pelne_nazwisko, staz_lat):
SELECT n.pelne_nazwisko() AS nauczyciel, 
       n.staz_lat() AS staz_pracy
FROM nauczyciele n;

-- 11.3 Metody typu T_PRZEDMIOT
PROMPT
PROMPT [11.3] Metody typu T_PRZEDMIOT (czy_grupowy):
SELECT p.nazwa, 
       p.typ,
       p.czy_grupowy() AS jest_grupowy
FROM przedmioty p;

-- 11.4 Metody typu T_SALA
PROMPT
PROMPT [11.4] Metody typu T_SALA (czy_grupowa, lista_wyposazenia):
SELECT s.numer,
       s.czy_grupowa() AS jest_grupowa,
       s.lista_wyposazenia() AS wyposazenie
FROM sale s;

-- 11.5 Metody typu T_LEKCJA
PROMPT
PROMPT [11.5] Metody typu T_LEKCJA (czy_indywidualna, godzina_koniec):
SELECT l.id,
       l.godz_rozp || ':00' AS start,
       l.godzina_koniec() AS koniec_dec,
       l.czy_indywidualna() AS indywidualna
FROM lekcje l
WHERE ROWNUM <= 5;

-- 11.6 Metody typu T_OCENA
PROMPT
PROMPT [11.6] Metody typu T_OCENA (opis_oceny):
SELECT o.wartosc,
       o.opis_oceny() AS slownie,
       o.semestralna
FROM oceny o
WHERE ROWNUM <= 8;


-- ============================================================================
-- PODSUMOWANIE - STATYSTYKI KOŃCOWE
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT PODSUMOWANIE - STATYSTYKI KONCOWE PO SCENARIUSZACH
PROMPT ============================================================

EXEC pkg_raporty.statystyki;

PROMPT
PROMPT ============================================================
PROMPT KONIEC SCENARIUSZY TESTOWYCH
PROMPT ============================================================

/*
================================================================================
PODSUMOWANIE WYKONANYCH SCENARIUSZY:

1. ROZSZERZENIE OFERTY SZKOŁY
   - Dodano przedmiot: Flet (indywidualny)
   - Dodano salę: 105 z VARRAY wyposażenia
   - Dodano nauczyciela: Tomasz Flecista

2. TWORZENIE GRUPY I ZAPIS UCZNIÓW
   - Utworzono grupę 4A (klasa IV)
   - Zapisano 2 uczniów: Jakub (Flet), Karolina (Fortepian)
   - Demonstracja KURSORA JAWNEGO w lista_uczniow_grupy()

3. PLANOWANIE LEKCJI GRUPOWYCH
   - Dodano lekcje Kształcenia słuchu i Rytmiki dla grupy 4A
   - Walidacja typu sali (musi być 'grupowa')

4. PLANOWANIE LEKCJI INDYWIDUALNYCH
   - Przypadek A: Wolny termin - sukces
   - Przypadek B: Konflikt terminu - błąd z SUGESTIĄ alternatywy
   - Demonstracja heurystyki First Fit

5. WYSTAWIANIE OCEN
   - Oceny cząstkowe z różnych przedmiotów
   - Oceny semestralne
   - Walidacja uprawnień nauczyciela

6. SPRAWDZANIE OCEN PRZEZ UCZNIA
   - Wyświetlanie ocen
   - Obliczanie średniej
   - Wyświetlanie planu lekcji

7. RAPORTY DLA DYREKCJI
   - Raport grup
   - Statystyki szkoły
   - Plany nauczycieli

8. WALIDACJE I PRZYPADKI BRZEGOWE
   - Trigger XOR (lekcja musi mieć ucznia LUB grupę)
   - Trigger zakresu ocen (1-6)
   - Walidacja typu sali dla lekcji grupowej
   - Walidacja instrumentu ucznia
   - Walidacja kompetencji nauczyciela

9. DEMONSTRACJA VARRAY
   - Wyświetlanie wyposażenia sal
   - Metoda lista_wyposazenia()

10. DEMONSTRACJA REF/DEREF
    - Nawigacja przez referencje obiektowe
    - Wielokrotne DEREF w zapytaniach

11. DEMONSTRACJA METOD OBIEKTOWYCH
    - Metody wszystkich typów obiektowych
    - pelne_nazwisko(), wiek(), staz_lat(), czy_grupowy(), opis_oceny() itd.

================================================================================
WYMAGANIA PROJEKTU SPEŁNIONE W SCENARIUSZACH:

✓ Typy obiektowe z metodami     - Scenariusz 11
✓ Tabele obiektowe              - Wszystkie scenariusze
✓ REF i DEREF                   - Scenariusz 10
✓ VARRAY                        - Scenariusz 9
✓ Pakiety PL/SQL                - Scenariusze 1-7
✓ Kursory (jawny)               - Scenariusz 2 (lista_uczniow_grupy)
✓ Obsługa błędów                - Scenariusz 8
✓ Wyzwalacze (triggery)         - Scenariusz 8 (8.1, 8.2)
✓ Walidacja konfliktów          - Scenariusz 4 (4.5)
✓ Heurystyka First Fit          - Scenariusz 4 (sugestia terminu)

================================================================================
*/
