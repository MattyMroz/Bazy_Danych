-- ============================================================================
-- SZKOŁA MUZYCZNA I STOPNIA - DANE TESTOWE
-- Autorzy: Igor Typiński (251237), Mateusz Mróz (251190)
-- ============================================================================
-- WYMIAR LEKCJI NA UCZNIA: 5 tygodniowo
--   - 2 lekcje instrumentu (indywidualne) - Pon + Śr (klasy 1A-4A), Wt + Czw (klasy 5A-6A)
--   - 2 lekcje kształcenia słuchu (grupowe) - Wt + Czw
--   - 1 lekcja rytmiki (grupowa) - Pt
-- ============================================================================

SET SERVEROUTPUT ON;

-- ============================================================================
-- 1. PRZEDMIOTY (ID: 1-5)
-- ============================================================================
EXEC pkg_slowniki.dodaj_przedmiot('Fortepian', 'indywidualny');
EXEC pkg_slowniki.dodaj_przedmiot('Skrzypce', 'indywidualny');
EXEC pkg_slowniki.dodaj_przedmiot('Gitara', 'indywidualny');
EXEC pkg_slowniki.dodaj_przedmiot('Kształcenie słuchu', 'grupowy');
EXEC pkg_slowniki.dodaj_przedmiot('Rytmika', 'grupowy');

EXEC pkg_slowniki.lista_przedmiotow;

-- ============================================================================
-- 2. GRUPY / KLASY (ID: 1-6)
-- ============================================================================
EXEC pkg_slowniki.dodaj_grupe('1A', 1);
EXEC pkg_slowniki.dodaj_grupe('2A', 2);
EXEC pkg_slowniki.dodaj_grupe('3A', 3);
EXEC pkg_slowniki.dodaj_grupe('4A', 4);
EXEC pkg_slowniki.dodaj_grupe('5A', 5);
EXEC pkg_slowniki.dodaj_grupe('6A', 6);

EXEC pkg_slowniki.lista_grup;

-- ============================================================================
-- 3. SALE (ID: 1-5)
-- ============================================================================
-- Sale indywidualne (instrumenty)
EXEC pkg_slowniki.dodaj_sale('101', 'indywidualna', 3, t_wyposazenie('Fortepian Yamaha', 'Metronom', 'Lustro'));
EXEC pkg_slowniki.dodaj_sale('102', 'indywidualna', 5, t_wyposazenie('Pulpity x5', 'Lustro', 'Nagłośnienie'));
EXEC pkg_slowniki.dodaj_sale('103', 'indywidualna', 4, t_wyposazenie('Wzmacniacze', 'Pulpity', 'Stojaki na gitary'));

-- Sale grupowe
EXEC pkg_slowniki.dodaj_sale('104', 'grupowa', 25, t_wyposazenie('Pianino', 'Tablica', 'Projektor', 'Nagłośnienie'));
EXEC pkg_slowniki.dodaj_sale('105', 'grupowa', 25, t_wyposazenie('Lustro', 'Drążki baletowe', 'Nagłośnienie', 'Podłoga parkietowa'));

EXEC pkg_slowniki.lista_sal;

-- ============================================================================
-- 4. NAUCZYCIELE (ID: 1-6)
-- ============================================================================
-- Przedmioty: 1=Fortepian, 2=Skrzypce, 3=Gitara, 4=Kształcenie słuchu, 5=Rytmika
EXEC pkg_osoby.dodaj_nauczyciela('Anna', 'Kowalska', 'Fortepian');
EXEC pkg_osoby.dodaj_nauczyciela('Jan', 'Nowak', 'Skrzypce');
EXEC pkg_osoby.dodaj_nauczyciela('Maria', 'Wiśniewska', 'Gitara');
EXEC pkg_osoby.dodaj_nauczyciela('Piotr', 'Lewandowski', 'Kształcenie słuchu');
EXEC pkg_osoby.dodaj_nauczyciela('Katarzyna', 'Wójcik', 'Rytmika');
EXEC pkg_osoby.dodaj_nauczyciela('Tomasz', 'Kamiński', 'Fortepian, Kształcenie słuchu');

EXEC pkg_osoby.lista_nauczycieli;

-- ============================================================================
-- 5. UCZNIOWIE (ID: 1-24, 4 na grupę)
-- ============================================================================
-- Grupy: 1=1A, 2=2A, 3=3A, 4=4A, 5=5A, 6=6A

-- Klasa 1A (ID: 1-4) - 2 fortepian, 2 skrzypce
EXEC pkg_osoby.dodaj_ucznia('Adam', 'Adamski', DATE '2017-03-15', 'Fortepian', '1A');
EXEC pkg_osoby.dodaj_ucznia('Barbara', 'Barańska', DATE '2017-05-20', 'Fortepian', '1A');
EXEC pkg_osoby.dodaj_ucznia('Celina', 'Cieślak', DATE '2017-01-10', 'Skrzypce', '1A');
EXEC pkg_osoby.dodaj_ucznia('Daniel', 'Dąbrowski', DATE '2016-11-25', 'Skrzypce', '1A');

-- Klasa 2A (ID: 5-8) - 2 gitara, 2 fortepian
EXEC pkg_osoby.dodaj_ucznia('Ewa', 'Ewa', DATE '2016-02-14', 'Gitara', '2A');
EXEC pkg_osoby.dodaj_ucznia('Filip', 'Filipiak', DATE '2016-06-30', 'Gitara', '2A');
EXEC pkg_osoby.dodaj_ucznia('Grażyna', 'Górska', DATE '2016-04-05', 'Fortepian', '2A');
EXEC pkg_osoby.dodaj_ucznia('Henryk', 'Hajduk', DATE '2015-12-20', 'Fortepian', '2A');

-- Klasa 3A (ID: 9-12) - 2 skrzypce, 2 gitara
EXEC pkg_osoby.dodaj_ucznia('Irena', 'Iwańska', DATE '2015-08-10', 'Skrzypce', '3A');
EXEC pkg_osoby.dodaj_ucznia('Jakub', 'Jankowski', DATE '2015-03-25', 'Skrzypce', '3A');
EXEC pkg_osoby.dodaj_ucznia('Karolina', 'Kaczmarek', DATE '2014-11-15', 'Gitara', '3A');
EXEC pkg_osoby.dodaj_ucznia('Leon', 'Lewicki', DATE '2014-07-08', 'Gitara', '3A');

-- Klasa 4A (ID: 13-16) - 2 fortepian, 2 skrzypce
EXEC pkg_osoby.dodaj_ucznia('Marta', 'Mazur', DATE '2014-01-20', 'Fortepian', '4A');
EXEC pkg_osoby.dodaj_ucznia('Norbert', 'Nowakowski', DATE '2013-09-12', 'Fortepian', '4A');
EXEC pkg_osoby.dodaj_ucznia('Oliwia', 'Olszewska', DATE '2013-05-05', 'Skrzypce', '4A');
EXEC pkg_osoby.dodaj_ucznia('Paweł', 'Pawlak', DATE '2013-02-28', 'Skrzypce', '4A');

-- Klasa 5A (ID: 17-20) - 2 gitara, 2 fortepian
EXEC pkg_osoby.dodaj_ucznia('Renata', 'Rutkowska', DATE '2012-10-15', 'Gitara', '5A');
EXEC pkg_osoby.dodaj_ucznia('Stanisław', 'Szymański', DATE '2012-06-08', 'Gitara', '5A');
EXEC pkg_osoby.dodaj_ucznia('Teresa', 'Tomaszewska', DATE '2012-03-22', 'Fortepian', '5A');
EXEC pkg_osoby.dodaj_ucznia('Urszula', 'Urban', DATE '2011-12-01', 'Fortepian', '5A');

-- Klasa 6A (ID: 21-24) - 2 skrzypce, 2 gitara
EXEC pkg_osoby.dodaj_ucznia('Wiktor', 'Wróbel', DATE '2011-08-20', 'Skrzypce', '6A');
EXEC pkg_osoby.dodaj_ucznia('Zofia', 'Zielińska', DATE '2011-04-14', 'Skrzypce', '6A');
EXEC pkg_osoby.dodaj_ucznia('Aleksy', 'Andrzejewski', DATE '2010-11-30', 'Gitara', '6A');
EXEC pkg_osoby.dodaj_ucznia('Blanka', 'Bielska', DATE '2010-07-25', 'Gitara', '6A');

EXEC pkg_osoby.lista_uczniow;

-- ============================================================================
-- 6. LEKCJE - TYDZIEŃ (Pon 2025-06-02 do Pt 2025-06-06)
-- ============================================================================
-- STRUKTURA: 5 lekcji/ucznia w różne dni
-- Przedmioty: 1=Fortepian, 2=Skrzypce, 3=Gitara, 4=Kształcenie słuchu, 5=Rytmika
-- Nauczyciele: 1=Kowalska(Fort), 2=Nowak(Skrz), 3=Wiśniewska(Git), 4=Lewandowski(KS), 5=Wójcik(Ryt), 6=Kamiński(Fort,KS)
-- Sale: 1=101(fort), 2=102(skrz), 3=103(git), 4=104(KS), 5=105(rytm)
-- Grupy: 1=1A, 2=2A, 3=3A, 4=4A, 5=5A, 6=6A
-- ============================================================================

-- ===========================================================================
-- PONIEDZIAŁEK (2025-06-02) - 1. lekcja instrumentu (klasy 1A-4A)
-- ===========================================================================
-- Sala 101 (fortepian) - uczniowie: 1,2 (1A), 7,8 (2A), 13,14 (4A)
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 1, DATE '2025-06-02', 14);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 2, DATE '2025-06-02', 15);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 6, 1, 7, DATE '2025-06-02', 16);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 6, 1, 8, DATE '2025-06-02', 17);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 13, DATE '2025-06-02', 18);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 14, DATE '2025-06-02', 19);

-- Sala 102 (skrzypce) - uczniowie: 3,4 (1A), 9,10 (3A), 15,16 (4A)
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(2, 2, 2, 3, DATE '2025-06-02', 14);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(2, 2, 2, 4, DATE '2025-06-02', 15);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(2, 2, 2, 9, DATE '2025-06-02', 16);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(2, 2, 2, 10, DATE '2025-06-02', 17);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(2, 2, 2, 15, DATE '2025-06-02', 18);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(2, 2, 2, 16, DATE '2025-06-02', 19);

-- Sala 103 (gitara) - uczniowie: 5,6 (2A), 11,12 (3A), 17,18 (5A)
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(3, 3, 3, 5, DATE '2025-06-02', 14);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(3, 3, 3, 6, DATE '2025-06-02', 15);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(3, 3, 3, 11, DATE '2025-06-02', 16);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(3, 3, 3, 12, DATE '2025-06-02', 17);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(3, 3, 3, 17, DATE '2025-06-02', 18);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(3, 3, 3, 18, DATE '2025-06-02', 19);

-- ===========================================================================
-- WTOREK (2025-06-03) - 1. kształcenie słuchu + 1. lekcja instrumentu (5A, 6A)
-- ===========================================================================
-- Sala 104 (KS grupowe) - wszystkie klasy
EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 4, 1, DATE '2025-06-03', 14);
EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 4, 2, DATE '2025-06-03', 15);
EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 4, 3, DATE '2025-06-03', 16);
EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 4, 4, DATE '2025-06-03', 17);
EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 4, 5, DATE '2025-06-03', 18);
EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 4, 6, DATE '2025-06-03', 19);

-- Sala 101 (fortepian) - uczniowie 19,20 (5A) - wolni do 17:59, KS o 18:00
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 6, 1, 19, DATE '2025-06-03', 14);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 6, 1, 20, DATE '2025-06-03', 15);

-- Sala 102 (skrzypce) - uczniowie 21,22 (6A) - wolni do 18:59, KS o 19:00
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(2, 2, 2, 21, DATE '2025-06-03', 14);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(2, 2, 2, 22, DATE '2025-06-03', 15);

-- Sala 103 (gitara) - uczniowie 23,24 (6A) - wolni do 18:59, KS o 19:00
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(3, 3, 3, 23, DATE '2025-06-03', 14);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(3, 3, 3, 24, DATE '2025-06-03', 15);

-- ===========================================================================
-- ŚRODA (2025-06-04) - 2. lekcja instrumentu (klasy 1A-4A)
-- ===========================================================================
-- Sala 101 (fortepian) - uczniowie: 1,2 (1A), 7,8 (2A), 13,14 (4A)
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 1, DATE '2025-06-04', 14);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 2, DATE '2025-06-04', 15);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 6, 1, 7, DATE '2025-06-04', 16);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 6, 1, 8, DATE '2025-06-04', 17);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 13, DATE '2025-06-04', 18);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 14, DATE '2025-06-04', 19);

-- Sala 102 (skrzypce) - uczniowie: 3,4 (1A), 9,10 (3A), 15,16 (4A)
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(2, 2, 2, 3, DATE '2025-06-04', 14);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(2, 2, 2, 4, DATE '2025-06-04', 15);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(2, 2, 2, 9, DATE '2025-06-04', 16);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(2, 2, 2, 10, DATE '2025-06-04', 17);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(2, 2, 2, 15, DATE '2025-06-04', 18);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(2, 2, 2, 16, DATE '2025-06-04', 19);

-- Sala 103 (gitara) - uczniowie: 5,6 (2A), 11,12 (3A), 17,18 (5A)
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(3, 3, 3, 5, DATE '2025-06-04', 14);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(3, 3, 3, 6, DATE '2025-06-04', 15);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(3, 3, 3, 11, DATE '2025-06-04', 16);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(3, 3, 3, 12, DATE '2025-06-04', 17);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(3, 3, 3, 17, DATE '2025-06-04', 18);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(3, 3, 3, 18, DATE '2025-06-04', 19);

-- ===========================================================================
-- CZWARTEK (2025-06-05) - 2. kształcenie słuchu + 2. lekcja instrumentu (5A, 6A)
-- ===========================================================================
-- Sala 104 (KS grupowe) - wszystkie klasy
EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 4, 1, DATE '2025-06-05', 14);
EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 4, 2, DATE '2025-06-05', 15);
EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 4, 3, DATE '2025-06-05', 16);
EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 4, 4, DATE '2025-06-05', 17);
EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 4, 5, DATE '2025-06-05', 18);
EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 4, 6, DATE '2025-06-05', 19);

-- Sala 101 (fortepian) - uczniowie 19,20 (5A) - wolni do 17:59, KS o 18:00
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 6, 1, 19, DATE '2025-06-05', 14);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 6, 1, 20, DATE '2025-06-05', 15);

-- Sala 102 (skrzypce) - uczniowie 21,22 (6A) - wolni do 18:59, KS o 19:00
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(2, 2, 2, 21, DATE '2025-06-05', 14);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(2, 2, 2, 22, DATE '2025-06-05', 15);

-- Sala 103 (gitara) - uczniowie 23,24 (6A) - wolni do 18:59, KS o 19:00
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(3, 3, 3, 23, DATE '2025-06-05', 14);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(3, 3, 3, 24, DATE '2025-06-05', 15);

-- ===========================================================================
-- PIĄTEK (2025-06-06) - Rytmika (grupowa dla wszystkich)
-- ===========================================================================
EXEC pkg_lekcje.dodaj_lekcje_grupowa(5, 5, 5, 1, DATE '2025-06-06', 14);
EXEC pkg_lekcje.dodaj_lekcje_grupowa(5, 5, 5, 2, DATE '2025-06-06', 15);
EXEC pkg_lekcje.dodaj_lekcje_grupowa(5, 5, 5, 3, DATE '2025-06-06', 16);
EXEC pkg_lekcje.dodaj_lekcje_grupowa(5, 5, 5, 4, DATE '2025-06-06', 17);
EXEC pkg_lekcje.dodaj_lekcje_grupowa(5, 5, 5, 5, DATE '2025-06-06', 18);
EXEC pkg_lekcje.dodaj_lekcje_grupowa(5, 5, 5, 6, DATE '2025-06-06', 19);

-- ============================================================================
-- 7. OCENY - przykładowe
-- ============================================================================
EXEC pkg_oceny.wystaw_ocene_verbose(1, 1, 1, 5);
EXEC pkg_oceny.wystaw_ocene_verbose(1, 4, 4, 4);

EXEC pkg_oceny.wystaw_ocene(3, 2, 2, 6);
EXEC pkg_oceny.wystaw_ocene(5, 3, 3, 4);
EXEC pkg_oceny.wystaw_ocene(5, 3, 3, 5);

EXEC pkg_oceny.wystaw_ocene_semestralna(1, 1, 1, 5);

-- ============================================================================
-- 8. WERYFIKACJA DANYCH
-- ============================================================================
EXEC pkg_raporty.statystyki_ogolne;
EXEC pkg_raporty.statystyki_lekcji;

-- Plan przykładowego ucznia (Adam - ID=1) - powinien mieć 5 lekcji
EXEC pkg_lekcje.plan_ucznia(1);

-- Raport kompletności - sprawdza kto ma <5 lekcji
EXEC pkg_lekcje.raport_kompletnosci(DATE '2025-06-02');

-- Oceny przykładowego ucznia
EXEC pkg_oceny.oceny_ucznia(1);

-- Plan dnia (środa - dużo lekcji instrumentu)
EXEC pkg_lekcje.plan_dnia(DATE '2025-06-04');
