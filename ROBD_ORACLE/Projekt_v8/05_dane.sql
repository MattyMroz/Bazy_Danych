-- ============================================================================
-- SZKOŁA MUZYCZNA I STOPNIA - DANE TESTOWE (UPROSZCZONE)
-- Autorzy: Igor Typiński (251237), Mateusz Mróz (251190)
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

-- ============================================================================
-- 2. GRUPY (ID: 1-3)
-- ============================================================================
EXEC pkg_slowniki.dodaj_grupe('1A', 1);
EXEC pkg_slowniki.dodaj_grupe('2A', 2);
EXEC pkg_slowniki.dodaj_grupe('3A', 3);

-- ============================================================================
-- 3. SALE (ID: 1-4) z VARRAY wyposażenia
-- ============================================================================
EXEC pkg_slowniki.dodaj_sale('101', 'indywidualna', 3, t_wyposazenie('Fortepian Yamaha', 'Metronom', 'Lustro'));
EXEC pkg_slowniki.dodaj_sale('102', 'indywidualna', 4, t_wyposazenie('Pulpity x4', 'Stojaki na instrumenty'));
EXEC pkg_slowniki.dodaj_sale('103', 'grupowa', 20, t_wyposazenie('Pianino', 'Tablica', 'Projektor', 'Krzesła x20'));
EXEC pkg_slowniki.dodaj_sale('104', 'grupowa', 25, t_wyposazenie('Lustro', 'Drążki baletowe', 'Nagłośnienie'));

-- ============================================================================
-- 4. NAUCZYCIELE (ID: 1-5) - każdy uczy JEDNEGO przedmiotu (REF!)
-- Przedmioty: 1=Fortepian, 2=Skrzypce, 3=Gitara, 4=Kształcenie słuchu, 5=Rytmika
-- ============================================================================
EXEC pkg_osoby.dodaj_nauczyciela('Anna', 'Kowalska', 1);
EXEC pkg_osoby.dodaj_nauczyciela('Jan', 'Nowak', 2);
EXEC pkg_osoby.dodaj_nauczyciela('Maria', 'Wiśniewska', 3);
EXEC pkg_osoby.dodaj_nauczyciela('Piotr', 'Lewandowski', 4);
EXEC pkg_osoby.dodaj_nauczyciela('Katarzyna', 'Wójcik', 5);

-- ============================================================================
-- 5. UCZNIOWIE (ID: 1-9) - z REF do grupy
-- Grupy: 1=1A, 2=2A, 3=3A
-- ============================================================================
-- Klasa 1A (3 uczniów)
EXEC pkg_osoby.dodaj_ucznia('Adam', 'Adamski', DATE '2017-03-15', 'Fortepian', 1);
EXEC pkg_osoby.dodaj_ucznia('Barbara', 'Barańska', DATE '2017-05-20', 'Skrzypce', 1);
EXEC pkg_osoby.dodaj_ucznia('Celina', 'Cieślak', DATE '2017-01-10', 'Gitara', 1);

-- Klasa 2A (3 uczniów)
EXEC pkg_osoby.dodaj_ucznia('Daniel', 'Dąbrowski', DATE '2016-02-14', 'Fortepian', 2);
EXEC pkg_osoby.dodaj_ucznia('Ewa', 'Ewa', DATE '2016-06-30', 'Skrzypce', 2);
EXEC pkg_osoby.dodaj_ucznia('Filip', 'Filipiak', DATE '2016-04-05', 'Gitara', 2);

-- Klasa 3A (3 uczniów)
EXEC pkg_osoby.dodaj_ucznia('Grażyna', 'Górska', DATE '2015-08-10', 'Fortepian', 3);
EXEC pkg_osoby.dodaj_ucznia('Henryk', 'Hajduk', DATE '2015-03-25', 'Skrzypce', 3);
EXEC pkg_osoby.dodaj_ucznia('Irena', 'Iwańska', DATE '2015-11-15', 'Gitara', 3);

-- ============================================================================
-- 6. LEKCJE - przykładowy tydzień (poniedziałek-piątek)
-- ============================================================================
-- Nauczyciele: 1=Kowalska(Fort), 2=Nowak(Skrz), 3=Wiśniewska(Git), 4=Lewandowski(KS), 5=Wójcik(Ryt)
-- Sale: 1=101(fort), 2=102(skrz/git), 3=103(KS), 4=104(rytm)

-- PONIEDZIAŁEK - lekcje indywidualne
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 1, DATE '2025-06-02', 14);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(2, 2, 2, 2, DATE '2025-06-02', 14);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(3, 3, 2, 3, DATE '2025-06-02', 15);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 4, DATE '2025-06-02', 15);

-- WTOREK - kształcenie słuchu (grupowe)
EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 3, 1, DATE '2025-06-03', 14);
EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 3, 2, DATE '2025-06-03', 15);
EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 3, 3, DATE '2025-06-03', 16);

-- ŚRODA - lekcje indywidualne
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(2, 2, 2, 5, DATE '2025-06-04', 14);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(3, 3, 2, 6, DATE '2025-06-04', 15);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 7, DATE '2025-06-04', 14);
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(2, 2, 2, 8, DATE '2025-06-04', 16);

-- CZWARTEK - kształcenie słuchu (grupowe)
EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 3, 1, DATE '2025-06-05', 14);
EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 3, 2, DATE '2025-06-05', 15);
EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 3, 3, DATE '2025-06-05', 16);

-- PIĄTEK - rytmika (grupowa)
EXEC pkg_lekcje.dodaj_lekcje_grupowa(5, 5, 4, 1, DATE '2025-06-06', 14);
EXEC pkg_lekcje.dodaj_lekcje_grupowa(5, 5, 4, 2, DATE '2025-06-06', 15);
EXEC pkg_lekcje.dodaj_lekcje_grupowa(5, 5, 4, 3, DATE '2025-06-06', 16);

-- ============================================================================
-- 7. OCENY - przykładowe
-- ============================================================================
-- Oceny dla Adama z fortepianu
EXEC pkg_oceny.wystaw_ocene(1, 1, 1, 5);
EXEC pkg_oceny.wystaw_ocene(1, 1, 1, 4);
EXEC pkg_oceny.wystaw_ocene_semestralna(1, 1, 1, 5);

-- Oceny dla Barbary ze skrzypiec
EXEC pkg_oceny.wystaw_ocene(2, 2, 2, 6);
EXEC pkg_oceny.wystaw_ocene(2, 2, 2, 5);

-- Oceny z kształcenia słuchu
EXEC pkg_oceny.wystaw_ocene(1, 4, 4, 4);
EXEC pkg_oceny.wystaw_ocene(2, 4, 4, 5);
EXEC pkg_oceny.wystaw_ocene(3, 4, 4, 4);

-- ============================================================================
-- 8. WERYFIKACJA
-- ============================================================================
EXEC pkg_slowniki.lista_przedmiotow;
EXEC pkg_slowniki.lista_grup;
EXEC pkg_slowniki.lista_sal;
EXEC pkg_osoby.lista_nauczycieli;
EXEC pkg_osoby.lista_uczniow;
EXEC pkg_raporty.statystyki;
