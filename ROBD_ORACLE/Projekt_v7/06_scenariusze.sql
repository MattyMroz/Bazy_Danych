-- ============================================================================
-- Projekt: Szkola Muzyczna - Obiektowa Baza Danych
-- Plik: 06_scenariusze.sql
-- Opis: Scenariusze testowe demonstrujace funkcjonalnosci systemu
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- Wersja: 7.0
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- ============================================================================
-- SCENARIUSZ 1: NOWY UCZEN ZAPISUJE SIE DO SZKOLY
-- Historia: Karol Nowy, 8 lat, fortepian, dopisany do klasy 2A
-- ============================================================================

-- 1.1 Sprawdzamy stan przed dodaniem
EXEC PKG_OSOBY.lista_uczniow_w_grupie('2A');

-- 1.2 Dodajemy nowego ucznia
EXEC PKG_OSOBY.dodaj_ucznia('Karol', 'Nowy', DATE '2018-05-20', '2A', 'Fortepian');

-- 1.3 Sprawdzamy czy uczen zostal dodany
EXEC PKG_OSOBY.lista_uczniow_w_grupie('2A');

-- 1.4 Generujemy plan na tydzien (od poniedzialku 3 lutego 2026)
EXEC PKG_LEKCJE.generuj_plan_tygodnia(DATE '2026-02-02');

-- 1.5 Sprawdzamy plan nowego ucznia
EXEC PKG_LEKCJE.plan_ucznia('Nowy', 'Karol');

-- 1.6 Sprawdzamy statystyki
EXEC PKG_RAPORTY.statystyki_lekcji();


-- ============================================================================
-- SCENARIUSZ 2: NOWY NAUCZYCIEL DOLACZA DO SZKOLY
-- Historia: Adam Gitarowy, nowy nauczyciel gitary
-- ============================================================================

-- 2.1 Sprawdzamy obecnych nauczycieli
EXEC PKG_RAPORTY.raport_nauczycieli();

-- 2.2 Dodajemy nowego nauczyciela
EXEC PKG_OSOBY.dodaj_nauczyciela('Adam', 'Gitarowy', 'Gitara', 'adam.gitarowy@szkola.pl');

-- 2.3 Usuwamy stare lekcje i generujemy nowy plan
DELETE FROM LEKCJE;
COMMIT;

-- 2.4 Generujemy plan od nowa
EXEC PKG_LEKCJE.generuj_plan_tygodnia(DATE '2026-02-02');

-- 2.5 Sprawdzamy plan nowego nauczyciela
EXEC PKG_LEKCJE.plan_nauczyciela('Gitarowy');

-- 2.6 Sprawdzamy rozklad obciazenia nauczycieli
EXEC PKG_RAPORTY.raport_nauczycieli();


-- ============================================================================
-- SCENARIUSZ 3: NAUCZYCIEL WYSTAWIA OCENY
-- Historia: Pani Kowalska wystawia oceny uczniowi Janowi Kotkowi
-- ============================================================================

-- 3.1 Sprawdzamy uczniow pani Kowalskiej
EXEC PKG_OSOBY.lista_uczniow_nauczyciela('Kowalska');

-- 3.2 Wystawiamy oceny biezace
EXEC PKG_OCENY.wystaw_ocene('Kotek', 'Jan', 'Kowalska', 'Fortepian', 4);
EXEC PKG_OCENY.wystaw_ocene('Kotek', 'Jan', 'Kowalska', 'Fortepian', 5);
EXEC PKG_OCENY.wystaw_ocene('Kotek', 'Jan', 'Kowalska', 'Fortepian', 4);
EXEC PKG_OCENY.wystaw_ocene('Kotek', 'Jan', 'Kowalska', 'Fortepian', 5);

-- 3.3 Sprawdzamy oceny ucznia
EXEC PKG_OCENY.oceny_ucznia('Kotek', 'Jan');

-- 3.4 Obliczamy srednia
SELECT PKG_OCENY.srednia_ucznia('Kotek', 'Jan', 'Fortepian') AS srednia FROM DUAL;

-- 3.5 Wystawiamy ocene semestralna
EXEC PKG_OCENY.wystaw_ocene_semestralna('Kotek', 'Jan', 'Kowalska', 'Fortepian', 5);

-- 3.6 Sprawdzamy wszystkie oceny
EXEC PKG_OCENY.oceny_ucznia('Kotek', 'Jan');


-- ============================================================================
-- SCENARIUSZ 4: KONFLIKT - PROBA DODANIA KOLIDUJACEJ LEKCJI
-- Historia: Proba dodania lekcji gdy sala/nauczyciel zajety
-- ============================================================================

-- 4.1 Sprawdzamy obciazenie sali 101 w poniedzialek
EXEC PKG_LEKCJE.plan_sali('101', DATE '2026-02-02');

-- 4.2 Proba dodania lekcji gdy sala zajeta (powinien byc blad -20010)
-- Najpierw dodajemy lekcje poprawnie
EXEC PKG_LEKCJE.dodaj_lekcje_indywidualna('Fortepian', 'Kowalska', '101', 'Kotek', 'Jan', DATE '2026-02-09', '14:00', 45);

-- Teraz probujemy dodac druga lekcje w tym samym czasie i sali
-- EXEC PKG_LEKCJE.dodaj_lekcje_indywidualna('Fortepian', 'Zielinski', '101', 'Kwiatek', 'Ola', DATE '2026-02-09', '14:00', 45);
-- Oczekiwany blad: ORA-20010: Sala 101 zajeta w tym terminie

-- 4.3 Proba dodania lekcji gdy nauczyciel zajety (powinien byc blad -20011)
-- EXEC PKG_LEKCJE.dodaj_lekcje_indywidualna('Fortepian', 'Kowalska', '102', 'Kwiatek', 'Ola', DATE '2026-02-09', '14:00', 45);
-- Oczekiwany blad: ORA-20011: Nauczyciel Kowalska zajety w tym terminie

-- 4.4 Proba dodania lekcji przed 14:00 (powinien byc blad -20101)
-- EXEC PKG_LEKCJE.dodaj_lekcje_indywidualna('Fortepian', 'Kowalska', '101', 'Kotek', 'Jan', DATE '2026-02-10', '13:00', 45);
-- Oczekiwany blad: ORA-20101: Lekcje nie moga zaczynac sie przed 14:00


-- ============================================================================
-- SCENARIUSZ 5: PELNE GENEROWANIE PLANU NA TYDZIEN
-- Historia: Poczatek semestru, generujemy plan dla wszystkich
-- ============================================================================

-- 5.1 Czyscimy stare lekcje
DELETE FROM LEKCJE;
COMMIT;

-- 5.2 Sprawdzamy dane przed generowaniem
SELECT 'Przedmioty' AS Kategoria, COUNT(*) AS Liczba FROM PRZEDMIOTY
UNION ALL SELECT 'Sale', COUNT(*) FROM SALE
UNION ALL SELECT 'Grupy', COUNT(*) FROM GRUPY
UNION ALL SELECT 'Nauczyciele', COUNT(*) FROM NAUCZYCIELE
UNION ALL SELECT 'Uczniowie', COUNT(*) FROM UCZNIOWIE;

-- 5.3 Generujemy plan
EXEC PKG_LEKCJE.generuj_plan_tygodnia(DATE '2026-02-02');

-- 5.4 Sprawdzamy statystyki
EXEC PKG_RAPORTY.statystyki_lekcji();

-- 5.5 Sprawdzamy przykladowe plany
EXEC PKG_LEKCJE.plan_grupy('1A');
EXEC PKG_LEKCJE.plan_grupy('3A');
EXEC PKG_LEKCJE.plan_ucznia('Kotek', 'Jan');
EXEC PKG_LEKCJE.plan_ucznia('Lasek', 'Adam');
EXEC PKG_LEKCJE.plan_nauczyciela('Kowalska');
EXEC PKG_LEKCJE.plan_nauczyciela('Nowak');

-- 5.6 Sprawdzamy obciazenie sal
EXEC PKG_LEKCJE.plan_sali('101', DATE '2026-02-02');
EXEC PKG_LEKCJE.plan_sali('201', DATE '2026-02-02');


-- ============================================================================
-- SCENARIUSZ 6: RAPORTY SZKOLNE
-- Historia: Dyrektor chce zobaczyc statystyki szkoly
-- ============================================================================

-- 6.1 Raport grup
EXEC PKG_RAPORTY.raport_grup();

-- 6.2 Raport nauczycieli
EXEC PKG_RAPORTY.raport_nauczycieli();

-- 6.3 Statystyki lekcji
EXEC PKG_RAPORTY.statystyki_lekcji();


-- ============================================================================
-- SCENARIUSZ 7: PRZYKLADOWE ZAPYTANIA SQL Z METODAMI OBIEKTOWYMI
-- Historia: Demonstracja metod typow obiektowych
-- ============================================================================

-- 7.1 Uzycie metody pelne_nazwisko() i wiek() dla uczniow
SELECT u.id_ucznia, u.pelne_nazwisko() AS uczen, u.wiek() AS wiek, u.instrument
FROM UCZNIOWIE u ORDER BY u.wiek() DESC;

-- 7.2 Uzycie metody czy_grupowy() dla przedmiotow
SELECT p.nazwa, p.typ_zajec, p.czy_grupowy() AS grupowy FROM PRZEDMIOTY p;

-- 7.3 Uzycie metody czy_grupowa() dla sal
SELECT s.numer, s.typ, s.pojemnosc, s.czy_grupowa() AS grupowa FROM SALE s;

-- 7.4 Uzycie metody godzina_koniec() dla lekcji
SELECT l.id_lekcji, l.data_lekcji, l.godzina_start, l.godzina_koniec() AS koniec,
       DEREF(l.ref_przedmiot).nazwa AS przedmiot
FROM LEKCJE l WHERE ROWNUM <= 10;

-- 7.5 Uzycie metody opis_oceny() dla ocen
SELECT DEREF(o.ref_uczen).pelne_nazwisko() AS uczen,
       DEREF(o.ref_przedmiot).nazwa AS przedmiot,
       o.wartosc, o.opis_oceny() AS slownie
FROM OCENY o;


-- ============================================================================
-- SCENARIUSZ 8: WYSWIETLANIE WYPOSAZENIA SAL (VARRAY)
-- Historia: Sprawdzenie wyposazenia sal
-- ============================================================================

-- 8.1 Wyswietlenie wyposazenia jako lista
SELECT s.numer, s.typ, s.pojemnosc,
       (SELECT LISTAGG(COLUMN_VALUE, ', ') WITHIN GROUP (ORDER BY ROWNUM) 
        FROM TABLE(s.wyposazenie)) AS wyposazenie
FROM SALE s ORDER BY s.numer;


-- ============================================================================
-- SCENARIUSZ 9: DEREFERENCJE I NAWIGACJA PO OBIEKTACH
-- Historia: Demonstracja uzycia REF i DEREF
-- ============================================================================

-- 9.1 Wyswietlenie uczniow z nazwami grup (DEREF)
SELECT u.id_ucznia, u.pelne_nazwisko() AS uczen, 
       DEREF(u.ref_grupa).kod AS grupa,
       DEREF(u.ref_grupa).klasa AS klasa
FROM UCZNIOWIE u ORDER BY DEREF(u.ref_grupa).klasa, u.nazwisko;

-- 9.2 Wyswietlenie lekcji z pelnymi danymi (wielokrotny DEREF)
SELECT l.id_lekcji, l.data_lekcji, l.godzina_start,
       DEREF(l.ref_przedmiot).nazwa AS przedmiot,
       DEREF(l.ref_nauczyciel).pelne_nazwisko() AS nauczyciel,
       DEREF(l.ref_sala).numer AS sala,
       CASE WHEN l.ref_uczen IS NOT NULL 
            THEN DEREF(l.ref_uczen).pelne_nazwisko()
            ELSE 'Grupa ' || DEREF(l.ref_grupa).kod END AS kto
FROM LEKCJE l WHERE ROWNUM <= 10 ORDER BY l.data_lekcji, l.godzina_start;

-- 9.3 Wyswietlenie ocen z pelnymi danymi
SELECT o.data_wystawienia,
       DEREF(o.ref_uczen).pelne_nazwisko() AS uczen,
       DEREF(o.ref_przedmiot).nazwa AS przedmiot,
       o.wartosc, o.opis_oceny() AS slownie,
       DEREF(o.ref_nauczyciel).pelne_nazwisko() AS nauczyciel,
       CASE o.czy_semestralna WHEN 'T' THEN 'semestr' ELSE 'biezaca' END AS typ
FROM OCENY o ORDER BY o.data_wystawienia DESC;


-- ============================================================================
-- SCENARIUSZ 10: CZYSZCZENIE DANYCH TESTOWYCH (OPCJONALNE)
-- ============================================================================

-- Odkomentuj jesli chcesz wyczyscic dane po testach
-- DELETE FROM OCENY;
-- DELETE FROM LEKCJE;
-- DELETE FROM UCZNIOWIE WHERE imie = 'Karol' AND nazwisko = 'Nowy';
-- DELETE FROM NAUCZYCIELE WHERE nazwisko = 'Gitarowy';
-- COMMIT;


-- ============================================================================
-- KONIEC SCENARIUSZY TESTOWYCH
-- ============================================================================
