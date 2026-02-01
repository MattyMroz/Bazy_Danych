-- ============================================================================
-- Projekt: Szkola Muzyczna - Obiektowa Baza Danych
-- Plik: 05_dane.sql
-- Opis: Wstawienie danych poczatkowych (slowniki + przykladowe dane)
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- ============================================================================
-- 1. CZYSZCZENIE DANYCH (w kolejnosci zaleznosci)
-- ============================================================================

DELETE FROM OCENY;
DELETE FROM LEKCJE;
DELETE FROM UCZNIOWIE;
DELETE FROM GRUPY;
DELETE FROM SALE;
DELETE FROM NAUCZYCIELE;
DELETE FROM PRZEDMIOTY;
DELETE FROM INSTRUMENTY;
COMMIT;

-- Reset sekwencji (Oracle 12c+ skladnia)
-- Jesli uzywasz starszej wersji, uzyj: DROP SEQUENCE + CREATE SEQUENCE
DECLARE
    PROCEDURE reset_seq(p_seq_name VARCHAR2) IS
        v_val NUMBER;
    BEGIN
        EXECUTE IMMEDIATE 'SELECT ' || p_seq_name || '.NEXTVAL FROM DUAL' INTO v_val;
        EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || p_seq_name || ' INCREMENT BY -' || v_val || ' MINVALUE 0';
        EXECUTE IMMEDIATE 'SELECT ' || p_seq_name || '.NEXTVAL FROM DUAL' INTO v_val;
        EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || p_seq_name || ' INCREMENT BY 1 MINVALUE 0';
    EXCEPTION
        WHEN OTHERS THEN NULL;  -- ignoruj bledy
    END;
BEGIN
    reset_seq('seq_instrumenty');
    reset_seq('seq_przedmioty');
    reset_seq('seq_nauczyciele');
    reset_seq('seq_grupy');
    reset_seq('seq_sale');
    reset_seq('seq_uczniowie');
    reset_seq('seq_lekcje');
    reset_seq('seq_oceny');
END;
/

-- ============================================================================
-- 2. INSTRUMENTY (5 rekordow - zgodnie z zalozeniami)
-- ============================================================================

-- Fortepian i gitara -> chor (N), reszta -> orkiestra (T)
EXEC PKG_SLOWNIKI.dodaj_instrument('Fortepian', 'N');
EXEC PKG_SLOWNIKI.dodaj_instrument('Skrzypce', 'T');
EXEC PKG_SLOWNIKI.dodaj_instrument('Gitara', 'N');
EXEC PKG_SLOWNIKI.dodaj_instrument('Flet', 'T');
EXEC PKG_SLOWNIKI.dodaj_instrument('Perkusja', 'T');

-- ============================================================================
-- 3. PRZEDMIOTY (10 rekordow - zgodnie z zalozeniami)
-- ============================================================================

-- Indywidualne - instrumenty
EXEC PKG_SLOWNIKI.dodaj_przedmiot('Fortepian', 'indywidualny', 45, T_WYPOSAZENIE('fortepian'));
EXEC PKG_SLOWNIKI.dodaj_przedmiot('Skrzypce', 'indywidualny', 45, T_WYPOSAZENIE('pianino', 'pulpit'));
EXEC PKG_SLOWNIKI.dodaj_przedmiot('Gitara', 'indywidualny', 45, NULL);
EXEC PKG_SLOWNIKI.dodaj_przedmiot('Flet', 'indywidualny', 45, T_WYPOSAZENIE('pianino', 'pulpit'));
EXEC PKG_SLOWNIKI.dodaj_przedmiot('Perkusja', 'indywidualny', 45, T_WYPOSAZENIE('perkusja'));

-- Grupowe
EXEC PKG_SLOWNIKI.dodaj_przedmiot('Ksztalcenie sluchu', 'grupowy', 45, T_WYPOSAZENIE('tablica', 'pianino'));
EXEC PKG_SLOWNIKI.dodaj_przedmiot('Rytmika', 'grupowy', 45, T_WYPOSAZENIE('lustra'));
EXEC PKG_SLOWNIKI.dodaj_przedmiot('Audycje muzyczne', 'grupowy', 45, T_WYPOSAZENIE('tablica'));
EXEC PKG_SLOWNIKI.dodaj_przedmiot('Chor', 'grupowy', 90, T_WYPOSAZENIE('naglosnienie'));
EXEC PKG_SLOWNIKI.dodaj_przedmiot('Orkiestra', 'grupowy', 90, T_WYPOSAZENIE('pulpity'));

-- ============================================================================
-- 4. SALE (8 rekordow - zgodnie z zalozeniami)
-- ============================================================================

-- Sale indywidualne (6)
EXEC PKG_SLOWNIKI.dodaj_sale('101', 'indywidualna', 3, T_WYPOSAZENIE('fortepian'));
EXEC PKG_SLOWNIKI.dodaj_sale('102', 'indywidualna', 3, T_WYPOSAZENIE('fortepian'));
EXEC PKG_SLOWNIKI.dodaj_sale('103', 'indywidualna', 3, T_WYPOSAZENIE('pianino', 'pulpit'));
EXEC PKG_SLOWNIKI.dodaj_sale('104', 'indywidualna', 3, T_WYPOSAZENIE('pianino', 'pulpit'));
EXEC PKG_SLOWNIKI.dodaj_sale('105', 'indywidualna', 3, T_WYPOSAZENIE('gitara', 'wzmacniacz'));
EXEC PKG_SLOWNIKI.dodaj_sale('106', 'indywidualna', 3, T_WYPOSAZENIE('perkusja'));

-- Sale grupowe (2)
EXEC PKG_SLOWNIKI.dodaj_sale('201', 'grupowa', 20, T_WYPOSAZENIE('tablica', 'pianino'));
EXEC PKG_SLOWNIKI.dodaj_sale('202', 'grupowa', 25, T_WYPOSAZENIE('lustra', 'naglosnienie', 'pulpity'));

-- ============================================================================
-- 5. GRUPY (8 rekordow - piramida edukacyjna)
-- ============================================================================

-- Klasy I-III (5 grup)
EXEC PKG_SLOWNIKI.dodaj_grupe('1A', 1, '2025/2026');
EXEC PKG_SLOWNIKI.dodaj_grupe('1B', 1, '2025/2026');
EXEC PKG_SLOWNIKI.dodaj_grupe('2A', 2, '2025/2026');
EXEC PKG_SLOWNIKI.dodaj_grupe('2B', 2, '2025/2026');
EXEC PKG_SLOWNIKI.dodaj_grupe('3A', 3, '2025/2026');

-- Klasy IV-VI (3 grupy)
EXEC PKG_SLOWNIKI.dodaj_grupe('4A', 4, '2025/2026');
EXEC PKG_SLOWNIKI.dodaj_grupe('5A', 5, '2025/2026');
EXEC PKG_SLOWNIKI.dodaj_grupe('6A', 6, '2025/2026');

-- ============================================================================
-- 6. NAUCZYCIELE (12 rekordow)
-- ============================================================================

-- Nauczyciele instrumentow (9)
EXEC PKG_OSOBY.dodaj_nauczyciela('Anna', 'Kowalska', T_INSTRUMENTY_TAB('Fortepian'), 'kowalska@szkola.pl', '601111111');
EXEC PKG_OSOBY.dodaj_nauczyciela('Jan', 'Nowak', T_INSTRUMENTY_TAB('Fortepian'), 'nowak@szkola.pl', '602222222');
EXEC PKG_OSOBY.dodaj_nauczyciela('Piotr', 'Szymanski', T_INSTRUMENTY_TAB('Fortepian'), 'szymanski@szkola.pl', '603333333');
EXEC PKG_OSOBY.dodaj_nauczyciela('Marek', 'Wisniewski', T_INSTRUMENTY_TAB('Skrzypce'), 'wisniewski@szkola.pl', '604444444');
EXEC PKG_OSOBY.dodaj_nauczyciela('Tomasz', 'Kaminski', T_INSTRUMENTY_TAB('Skrzypce'), 'kaminski@szkola.pl', '605555555');
EXEC PKG_OSOBY.dodaj_nauczyciela('Ewa', 'Zielinska', T_INSTRUMENTY_TAB('Flet'), 'zielinska@szkola.pl', '606666666');
EXEC PKG_OSOBY.dodaj_nauczyciela('Adam', 'Lewandowski', T_INSTRUMENTY_TAB('Gitara'), 'lewandowski@szkola.pl', '607777777');
EXEC PKG_OSOBY.dodaj_nauczyciela('Pawel', 'Wojcik', T_INSTRUMENTY_TAB('Gitara'), 'wojcik@szkola.pl', '608888888');
EXEC PKG_OSOBY.dodaj_nauczyciela('Krzysztof', 'Dabrowski', T_INSTRUMENTY_TAB('Perkusja'), 'dabrowski@szkola.pl', '609999999');

-- Nauczyciele przedmiotow grupowych (3)
EXEC PKG_OSOBY.dodaj_nauczyciela('Maria', 'Jankowska', NULL, 'jankowska@szkola.pl', '610000000');
EXEC PKG_OSOBY.dodaj_nauczyciela('Katarzyna', 'Mazur', NULL, 'mazur@szkola.pl', '611111111');
EXEC PKG_OSOBY.dodaj_nauczyciela('Robert', 'Krawczyk', NULL, 'krawczyk@szkola.pl', '612222222');

-- ============================================================================
-- 7. UCZNIOWIE (przykladowi - po kilku z kazdej grupy)
-- ============================================================================

-- Klasa 1A (12 uczniow) - Fortepian dominuje
EXEC PKG_OSOBY.dodaj_ucznia('Jan', 'Kowalski', DATE '2019-03-15', '1A', 'Fortepian', 'kowalski.rodzic@email.pl', '500100101');
EXEC PKG_OSOBY.dodaj_ucznia('Anna', 'Nowak', DATE '2019-05-20', '1A', 'Fortepian', 'nowak.rodzic@email.pl', '500100102');
EXEC PKG_OSOBY.dodaj_ucznia('Piotr', 'Wisniewski', DATE '2019-01-10', '1A', 'Skrzypce', 'wisniewski.rodzic@email.pl', '500100103');
EXEC PKG_OSOBY.dodaj_ucznia('Maria', 'Wojcik', DATE '2019-07-25', '1A', 'Gitara', 'wojcik.rodzic@email.pl', '500100104');
EXEC PKG_OSOBY.dodaj_ucznia('Tomasz', 'Kaminski', DATE '2019-02-28', '1A', 'Flet', 'kaminski.rodzic@email.pl', '500100105');
EXEC PKG_OSOBY.dodaj_ucznia('Ewa', 'Lewandowska', DATE '2019-09-12', '1A', 'Fortepian', 'lewandowska.rodzic@email.pl', '500100106');
EXEC PKG_OSOBY.dodaj_ucznia('Adam', 'Zielinski', DATE '2019-04-08', '1A', 'Skrzypce', 'zielinski.rodzic@email.pl', '500100107');
EXEC PKG_OSOBY.dodaj_ucznia('Katarzyna', 'Szymanska', DATE '2019-11-30', '1A', 'Fortepian', 'szymanska.rodzic@email.pl', '500100108');
EXEC PKG_OSOBY.dodaj_ucznia('Michal', 'Dabrowski', DATE '2019-06-18', '1A', 'Gitara', 'dabrowski.rodzic@email.pl', '500100109');
EXEC PKG_OSOBY.dodaj_ucznia('Zofia', 'Kozlowska', DATE '2019-08-22', '1A', 'Fortepian', 'kozlowska.rodzic@email.pl', '500100110');
EXEC PKG_OSOBY.dodaj_ucznia('Jakub', 'Jankowski', DATE '2019-10-05', '1A', 'Perkusja', 'jankowski.rodzic@email.pl', '500100111');
EXEC PKG_OSOBY.dodaj_ucznia('Aleksandra', 'Mazurek', DATE '2019-12-14', '1A', 'Skrzypce', 'mazurek.rodzic@email.pl', '500100112');

-- Klasa 1B (12 uczniow)
EXEC PKG_OSOBY.dodaj_ucznia('Bartosz', 'Krawczyk', DATE '2019-02-11', '1B', 'Fortepian', 'krawczyk.rodzic@email.pl', '500100201');
EXEC PKG_OSOBY.dodaj_ucznia('Natalia', 'Piotrowska', DATE '2019-04-23', '1B', 'Skrzypce', 'piotrowska.rodzic@email.pl', '500100202');
EXEC PKG_OSOBY.dodaj_ucznia('Mateusz', 'Grabowski', DATE '2019-06-30', '1B', 'Gitara', 'grabowski.rodzic@email.pl', '500100203');
EXEC PKG_OSOBY.dodaj_ucznia('Wiktoria', 'Pawlak', DATE '2019-08-17', '1B', 'Fortepian', 'pawlak.rodzic@email.pl', '500100204');
EXEC PKG_OSOBY.dodaj_ucznia('Filip', 'Michalski', DATE '2019-01-29', '1B', 'Flet', 'michalski.rodzic@email.pl', '500100205');
EXEC PKG_OSOBY.dodaj_ucznia('Oliwia', 'Zajac', DATE '2019-03-08', '1B', 'Fortepian', 'zajac.rodzic@email.pl', '500100206');
EXEC PKG_OSOBY.dodaj_ucznia('Szymon', 'Krol', DATE '2019-05-14', '1B', 'Skrzypce', 'krol.rodzic@email.pl', '500100207');
EXEC PKG_OSOBY.dodaj_ucznia('Maja', 'Wozniak', DATE '2019-07-21', '1B', 'Gitara', 'wozniak.rodzic@email.pl', '500100208');
EXEC PKG_OSOBY.dodaj_ucznia('Kacper', 'Stepien', DATE '2019-09-03', '1B', 'Fortepian', 'stepien.rodzic@email.pl', '500100209');
EXEC PKG_OSOBY.dodaj_ucznia('Julia', 'Adamczyk', DATE '2019-11-16', '1B', 'Skrzypce', 'adamczyk.rodzic@email.pl', '500100210');
EXEC PKG_OSOBY.dodaj_ucznia('Nikodem', 'Dudek', DATE '2019-10-27', '1B', 'Perkusja', 'dudek.rodzic@email.pl', '500100211');
EXEC PKG_OSOBY.dodaj_ucznia('Lena', 'Pawlowska', DATE '2019-12-09', '1B', 'Flet', 'pawlowska.rodzic@email.pl', '500100212');

-- Klasa 2A (10 uczniow)
EXEC PKG_OSOBY.dodaj_ucznia('Oskar', 'Walczak', DATE '2018-02-14', '2A', 'Fortepian', 'walczak.rodzic@email.pl', '500100301');
EXEC PKG_OSOBY.dodaj_ucznia('Hanna', 'Gorska', DATE '2018-04-19', '2A', 'Skrzypce', 'gorska.rodzic@email.pl', '500100302');
EXEC PKG_OSOBY.dodaj_ucznia('Antoni', 'Sikora', DATE '2018-06-25', '2A', 'Gitara', 'sikora.rodzic@email.pl', '500100303');
EXEC PKG_OSOBY.dodaj_ucznia('Emilia', 'Baran', DATE '2018-08-11', '2A', 'Fortepian', 'baran.rodzic@email.pl', '500100304');
EXEC PKG_OSOBY.dodaj_ucznia('Leon', 'Laskowski', DATE '2018-01-07', '2A', 'Flet', 'laskowski.rodzic@email.pl', '500100305');
EXEC PKG_OSOBY.dodaj_ucznia('Amelia', 'Kucharska', DATE '2018-03-22', '2A', 'Fortepian', 'kucharska.rodzic@email.pl', '500100306');
EXEC PKG_OSOBY.dodaj_ucznia('Franciszek', 'Kalinowski', DATE '2018-05-30', '2A', 'Skrzypce', 'kalinowski.rodzic@email.pl', '500100307');
EXEC PKG_OSOBY.dodaj_ucznia('Antonina', 'Mazurkiewicz', DATE '2018-07-15', '2A', 'Gitara', 'mazurkiewicz.rodzic@email.pl', '500100308');
EXEC PKG_OSOBY.dodaj_ucznia('Ignacy', 'Kubiak', DATE '2018-09-28', '2A', 'Fortepian', 'kubiak.rodzic@email.pl', '500100309');
EXEC PKG_OSOBY.dodaj_ucznia('Nadia', 'Kwiatkowska', DATE '2018-11-04', '2A', 'Perkusja', 'kwiatkowska.rodzic@email.pl', '500100310');

-- Klasa 2B (10 uczniow)
EXEC PKG_OSOBY.dodaj_ucznia('Tymon', 'Wrobel', DATE '2018-01-19', '2B', 'Fortepian', 'wrobel.rodzic@email.pl', '500100401');
EXEC PKG_OSOBY.dodaj_ucznia('Kornelia', 'Kaczmarek', DATE '2018-03-26', '2B', 'Skrzypce', 'kaczmarek.rodzic@email.pl', '500100402');
EXEC PKG_OSOBY.dodaj_ucznia('Marcel', 'Piotrowski', DATE '2018-05-12', '2B', 'Gitara', 'piotrowski.rodzic@email.pl', '500100403');
EXEC PKG_OSOBY.dodaj_ucznia('Lilianna', 'Wieczorek', DATE '2018-07-08', '2B', 'Fortepian', 'wieczorek.rodzic@email.pl', '500100404');
EXEC PKG_OSOBY.dodaj_ucznia('Borys', 'Jablonski', DATE '2018-09-21', '2B', 'Flet', 'jablonski.rodzic@email.pl', '500100405');
EXEC PKG_OSOBY.dodaj_ucznia('Nela', 'Chmielewski', DATE '2018-11-30', '2B', 'Fortepian', 'chmielewski.rodzic@email.pl', '500100406');
EXEC PKG_OSOBY.dodaj_ucznia('Olaf', 'Olszewski', DATE '2018-02-08', '2B', 'Skrzypce', 'olszewski.rodzic@email.pl', '500100407');
EXEC PKG_OSOBY.dodaj_ucznia('Gabriela', 'Urbaniak', DATE '2018-04-15', '2B', 'Gitara', 'urbaniak.rodzic@email.pl', '500100408');
EXEC PKG_OSOBY.dodaj_ucznia('Bruno', 'Witkowski', DATE '2018-06-29', '2B', 'Fortepian', 'witkowski.rodzic@email.pl', '500100409');
EXEC PKG_OSOBY.dodaj_ucznia('Helena', 'Sadowska', DATE '2018-08-04', '2B', 'Skrzypce', 'sadowska.rodzic@email.pl', '500100410');

-- Klasa 3A (16 uczniow)
EXEC PKG_OSOBY.dodaj_ucznia('Tymoteusz', 'Bak', DATE '2017-01-11', '3A', 'Fortepian', 'bak.rodzic@email.pl', '500100501');
EXEC PKG_OSOBY.dodaj_ucznia('Laura', 'Pietrzak', DATE '2017-03-18', '3A', 'Skrzypce', 'pietrzak.rodzic@email.pl', '500100502');
EXEC PKG_OSOBY.dodaj_ucznia('Ksawery', 'Tomczak', DATE '2017-05-25', '3A', 'Gitara', 'tomczak.rodzic@email.pl', '500100503');
EXEC PKG_OSOBY.dodaj_ucznia('Marcelina', 'Jaworski', DATE '2017-07-02', '3A', 'Fortepian', 'jaworski.rodzic@email.pl', '500100504');
EXEC PKG_OSOBY.dodaj_ucznia('Kajetan', 'Malinowski', DATE '2017-09-14', '3A', 'Flet', 'malinowski.rodzic@email.pl', '500100505');
EXEC PKG_OSOBY.dodaj_ucznia('Blanka', 'Pawlik', DATE '2017-11-21', '3A', 'Fortepian', 'pawlik.rodzic@email.pl', '500100506');
EXEC PKG_OSOBY.dodaj_ucznia('Ryszard', 'Gorski', DATE '2017-02-07', '3A', 'Skrzypce', 'gorski.rodzic@email.pl', '500100507');
EXEC PKG_OSOBY.dodaj_ucznia('Iga', 'Szewczyk', DATE '2017-04-13', '3A', 'Gitara', 'szewczyk.rodzic@email.pl', '500100508');
EXEC PKG_OSOBY.dodaj_ucznia('Fabian', 'Ostrowski', DATE '2017-06-20', '3A', 'Fortepian', 'ostrowski.rodzic@email.pl', '500100509');
EXEC PKG_OSOBY.dodaj_ucznia('Jagoda', 'Ciesielski', DATE '2017-08-27', '3A', 'Perkusja', 'ciesielski.rodzic@email.pl', '500100510');
EXEC PKG_OSOBY.dodaj_ucznia('Krystian', 'Kolodziej', DATE '2017-10-04', '3A', 'Skrzypce', 'kolodziej.rodzic@email.pl', '500100511');
EXEC PKG_OSOBY.dodaj_ucznia('Rozalia', 'Blaszczyk', DATE '2017-12-11', '3A', 'Flet', 'blaszczyk.rodzic@email.pl', '500100512');
EXEC PKG_OSOBY.dodaj_ucznia('Damian', 'Kubicki', DATE '2017-01-28', '3A', 'Gitara', 'kubicki.rodzic@email.pl', '500100513');
EXEC PKG_OSOBY.dodaj_ucznia('Patrycja', 'Baranowska', DATE '2017-03-05', '3A', 'Fortepian', 'baranowska.rodzic@email.pl', '500100514');
EXEC PKG_OSOBY.dodaj_ucznia('Norbert', 'Szulc', DATE '2017-05-12', '3A', 'Skrzypce', 'szulc.rodzic@email.pl', '500100515');
EXEC PKG_OSOBY.dodaj_ucznia('Martyna', 'Wlodarczyk', DATE '2017-07-19', '3A', 'Fortepian', 'wlodarczyk.rodzic@email.pl', '500100516');

-- Klasa 4A (14 uczniow)
EXEC PKG_OSOBY.dodaj_ucznia('Hubert', 'Lis', DATE '2016-02-08', '4A', 'Fortepian', 'lis.rodzic@email.pl', '500100601');
EXEC PKG_OSOBY.dodaj_ucznia('Weronika', 'Mazurek', DATE '2016-04-15', '4A', 'Skrzypce', 'mazurek2.rodzic@email.pl', '500100602');
EXEC PKG_OSOBY.dodaj_ucznia('Radoslaw', 'Szymczak', DATE '2016-06-22', '4A', 'Gitara', 'szymczak.rodzic@email.pl', '500100603');
EXEC PKG_OSOBY.dodaj_ucznia('Milena', 'Zawadzki', DATE '2016-08-29', '4A', 'Fortepian', 'zawadzki.rodzic@email.pl', '500100604');
EXEC PKG_OSOBY.dodaj_ucznia('Arkadiusz', 'Sobczak', DATE '2016-10-06', '4A', 'Flet', 'sobczak.rodzic@email.pl', '500100605');
EXEC PKG_OSOBY.dodaj_ucznia('Aurelia', 'Przybylski', DATE '2016-12-13', '4A', 'Fortepian', 'przybylski.rodzic@email.pl', '500100606');
EXEC PKG_OSOBY.dodaj_ucznia('Dawid', 'Borkowski', DATE '2016-01-20', '4A', 'Skrzypce', 'borkowski.rodzic@email.pl', '500100607');
EXEC PKG_OSOBY.dodaj_ucznia('Malwina', 'Sadowski', DATE '2016-03-27', '4A', 'Gitara', 'sadowski.rodzic@email.pl', '500100608');
EXEC PKG_OSOBY.dodaj_ucznia('Eryk', 'Glowacki', DATE '2016-05-04', '4A', 'Fortepian', 'glowacki.rodzic@email.pl', '500100609');
EXEC PKG_OSOBY.dodaj_ucznia('Jowita', 'Wasilewski', DATE '2016-07-11', '4A', 'Perkusja', 'wasilewski.rodzic@email.pl', '500100610');
EXEC PKG_OSOBY.dodaj_ucznia('Przemyslaw', 'Chmiel', DATE '2016-09-18', '4A', 'Skrzypce', 'chmiel.rodzic@email.pl', '500100611');
EXEC PKG_OSOBY.dodaj_ucznia('Sara', 'Rutkowski', DATE '2016-11-25', '4A', 'Flet', 'rutkowski.rodzic@email.pl', '500100612');
EXEC PKG_OSOBY.dodaj_ucznia('Sebastian', 'Michalak', DATE '2016-02-02', '4A', 'Gitara', 'michalak.rodzic@email.pl', '500100613');
EXEC PKG_OSOBY.dodaj_ucznia('Adrianna', 'Bielecki', DATE '2016-04-09', '4A', 'Fortepian', 'bielecki.rodzic@email.pl', '500100614');

-- Klasa 5A (13 uczniow)
EXEC PKG_OSOBY.dodaj_ucznia('Dominik', 'Zakrzewski', DATE '2015-01-16', '5A', 'Fortepian', 'zakrzewski.rodzic@email.pl', '500100701');
EXEC PKG_OSOBY.dodaj_ucznia('Klaudia', 'Krajewski', DATE '2015-03-23', '5A', 'Skrzypce', 'krajewski.rodzic@email.pl', '500100702');
EXEC PKG_OSOBY.dodaj_ucznia('Grzegorz', 'Nowicki', DATE '2015-05-30', '5A', 'Gitara', 'nowicki.rodzic@email.pl', '500100703');
EXEC PKG_OSOBY.dodaj_ucznia('Karolina', 'Adamski', DATE '2015-07-07', '5A', 'Fortepian', 'adamski.rodzic@email.pl', '500100704');
EXEC PKG_OSOBY.dodaj_ucznia('Artur', 'Sikorski', DATE '2015-09-14', '5A', 'Flet', 'sikorski.rodzic@email.pl', '500100705');
EXEC PKG_OSOBY.dodaj_ucznia('Monika', 'Krawczuk', DATE '2015-11-21', '5A', 'Fortepian', 'krawczuk.rodzic@email.pl', '500100706');
EXEC PKG_OSOBY.dodaj_ucznia('Rafal', 'Mroz', DATE '2015-02-28', '5A', 'Skrzypce', 'mroz.rodzic@email.pl', '500100707');
EXEC PKG_OSOBY.dodaj_ucznia('Agata', 'Zimowski', DATE '2015-04-05', '5A', 'Gitara', 'zimowski.rodzic@email.pl', '500100708');
EXEC PKG_OSOBY.dodaj_ucznia('Robert', 'Kwiecien', DATE '2015-06-12', '5A', 'Fortepian', 'kwiecien.rodzic@email.pl', '500100709');
EXEC PKG_OSOBY.dodaj_ucznia('Ewelina', 'Maj', DATE '2015-08-19', '5A', 'Perkusja', 'maj.rodzic@email.pl', '500100710');
EXEC PKG_OSOBY.dodaj_ucznia('Lukasz', 'Czerwinski', DATE '2015-10-26', '5A', 'Skrzypce', 'czerwinski.rodzic@email.pl', '500100711');
EXEC PKG_OSOBY.dodaj_ucznia('Beata', 'Lipinski', DATE '2015-12-03', '5A', 'Flet', 'lipinski.rodzic@email.pl', '500100712');
EXEC PKG_OSOBY.dodaj_ucznia('Konrad', 'Wilk', DATE '2015-01-10', '5A', 'Gitara', 'wilk.rodzic@email.pl', '500100713');

-- Klasa 6A (12 uczniow - dyplomanci)
EXEC PKG_OSOBY.dodaj_ucznia('Maciej', 'Bednarski', DATE '2014-02-17', '6A', 'Fortepian', 'bednarski.rodzic@email.pl', '500100801');
EXEC PKG_OSOBY.dodaj_ucznia('Renata', 'Kacprzak', DATE '2014-04-24', '6A', 'Skrzypce', 'kacprzak.rodzic@email.pl', '500100802');
EXEC PKG_OSOBY.dodaj_ucznia('Marcin', 'Duda', DATE '2014-06-01', '6A', 'Gitara', 'duda.rodzic@email.pl', '500100803');
EXEC PKG_OSOBY.dodaj_ucznia('Izabela', 'Kurek', DATE '2014-08-08', '6A', 'Fortepian', 'kurek.rodzic@email.pl', '500100804');
EXEC PKG_OSOBY.dodaj_ucznia('Stanislaw', 'Wojciechowski', DATE '2014-10-15', '6A', 'Flet', 'wojciechowski.rodzic@email.pl', '500100805');
EXEC PKG_OSOBY.dodaj_ucznia('Justyna', 'Kowalczyk', DATE '2014-12-22', '6A', 'Fortepian', 'kowalczyk.rodzic@email.pl', '500100806');
EXEC PKG_OSOBY.dodaj_ucznia('Andrzej', 'Sobieski', DATE '2014-01-29', '6A', 'Skrzypce', 'sobieski.rodzic@email.pl', '500100807');
EXEC PKG_OSOBY.dodaj_ucznia('Teresa', 'Grabowska', DATE '2014-03-08', '6A', 'Gitara', 'grabowska.rodzic@email.pl', '500100808');
EXEC PKG_OSOBY.dodaj_ucznia('Marek', 'Jasinski', DATE '2014-05-15', '6A', 'Fortepian', 'jasinski.rodzic@email.pl', '500100809');
EXEC PKG_OSOBY.dodaj_ucznia('Anna', 'Borkowska', DATE '2014-07-22', '6A', 'Perkusja', 'borkowska.rodzic@email.pl', '500100810');
EXEC PKG_OSOBY.dodaj_ucznia('Piotr', 'Nawrocki', DATE '2014-09-29', '6A', 'Skrzypce', 'nawrocki.rodzic@email.pl', '500100811');
EXEC PKG_OSOBY.dodaj_ucznia('Dorota', 'Kowalewski', DATE '2014-11-06', '6A', 'Flet', 'kowalewski.rodzic@email.pl', '500100812');

-- ============================================================================
-- 8. GENEROWANIE PLANU LEKCJI NA TYDZIEN
-- ============================================================================

-- Wygeneruj plan na pierwszy tydzien semestru (2026-02-02 to poniedzialek)
-- Kazdy uczen dostanie:
--   - 2 lekcje instrumentu (indywidualne) w tygodniu
--   - Lekcje grupowe: Ksztalcenie sluchu, Rytmika, Audycje muzyczne
--   - Klasy IV-VI dodatkowo: Chor lub Orkiestra

SET SERVEROUTPUT ON SIZE UNLIMITED;

BEGIN
    PKG_LEKCJE.generuj_plan_tygodnia(DATE '2026-02-02');
END;
/

-- ============================================================================
-- 9. PRZYKLADOWE OCENY (uczniowie z roznych klas)
-- ============================================================================

-- === KLASA 1A - Jan Kowalski (Fortepian) ===
EXEC PKG_OCENY.wystaw_ocene('Kowalski', 'Jan', 'Kowalska', 'Fortepian', 4, 'technika', 'Dobra postawa przy instrumencie');
EXEC PKG_OCENY.wystaw_ocene('Kowalski', 'Jan', 'Kowalska', 'Fortepian', 5, 'interpretacja', 'Ladna dynamika');
EXEC PKG_OCENY.wystaw_ocene('Kowalski', 'Jan', 'Kowalska', 'Fortepian', 4, 'postepy', NULL);
EXEC PKG_OCENY.wystaw_ocene('Kowalski', 'Jan', 'Jankowska', 'Ksztalcenie sluchu', 4, 'sluch', NULL);
EXEC PKG_OCENY.wystaw_ocene('Kowalski', 'Jan', 'Jankowska', 'Ksztalcenie sluchu', 5, 'teoria', NULL);
EXEC PKG_OCENY.wystaw_ocene('Kowalski', 'Jan', 'Jankowska', 'Rytmika', 5, 'ogolna', 'Swietne poczucie rytmu');

-- === KLASA 1A - Piotr Wisniewski (Skrzypce) ===
EXEC PKG_OCENY.wystaw_ocene('Wisniewski', 'Piotr', 'Wisniewski', 'Skrzypce', 3, 'technika', 'Wymaga pracy nad intonacja');
EXEC PKG_OCENY.wystaw_ocene('Wisniewski', 'Piotr', 'Wisniewski', 'Skrzypce', 4, 'postepy', NULL);
EXEC PKG_OCENY.wystaw_ocene('Wisniewski', 'Piotr', 'Jankowska', 'Ksztalcenie sluchu', 4, 'sluch', NULL);

-- === KLASA 1B - Bartosz Krawczyk (Fortepian) ===
EXEC PKG_OCENY.wystaw_ocene('Krawczyk', 'Bartosz', 'Nowak', 'Fortepian', 5, 'technika', 'Bardzo dobra technika');
EXEC PKG_OCENY.wystaw_ocene('Krawczyk', 'Bartosz', 'Nowak', 'Fortepian', 5, 'interpretacja', NULL);
EXEC PKG_OCENY.wystaw_ocene('Krawczyk', 'Bartosz', 'Jankowska', 'Ksztalcenie sluchu', 5, 'sluch', NULL);

-- === KLASA 2A - Oskar Walczak (Fortepian) ===
EXEC PKG_OCENY.wystaw_ocene('Walczak', 'Oskar', 'Kowalska', 'Fortepian', 4, 'technika', NULL);
EXEC PKG_OCENY.wystaw_ocene('Walczak', 'Oskar', 'Kowalska', 'Fortepian', 4, 'interpretacja', NULL);
EXEC PKG_OCENY.wystaw_ocene('Walczak', 'Oskar', 'Kowalska', 'Fortepian', 5, 'postepy', 'Duzy postep');
EXEC PKG_OCENY.wystaw_ocene('Walczak', 'Oskar', 'Jankowska', 'Ksztalcenie sluchu', 4, 'teoria', NULL);

-- === KLASA 2B - Tymon Wrobel (Fortepian) ===
EXEC PKG_OCENY.wystaw_ocene('Wrobel', 'Tymon', 'Szymanski', 'Fortepian', 3, 'technika', 'Wymaga wiecej cwiczen');
EXEC PKG_OCENY.wystaw_ocene('Wrobel', 'Tymon', 'Szymanski', 'Fortepian', 4, 'interpretacja', NULL);
EXEC PKG_OCENY.wystaw_ocene('Wrobel', 'Tymon', 'Jankowska', 'Ksztalcenie sluchu', 3, 'sluch', NULL);

-- === KLASA 3A - Tymoteusz Bak (Fortepian) ===
EXEC PKG_OCENY.wystaw_ocene('Bak', 'Tymoteusz', 'Kowalska', 'Fortepian', 5, 'technika', 'Swietna technika');
EXEC PKG_OCENY.wystaw_ocene('Bak', 'Tymoteusz', 'Kowalska', 'Fortepian', 5, 'interpretacja', 'Bardzo muzykalny');
EXEC PKG_OCENY.wystaw_ocene('Bak', 'Tymoteusz', 'Kowalska', 'Fortepian', 6, 'postepy', 'Kandydat do wyroznienia');
EXEC PKG_OCENY.wystaw_ocene('Bak', 'Tymoteusz', 'Jankowska', 'Ksztalcenie sluchu', 5, 'sluch', NULL);
EXEC PKG_OCENY.wystaw_ocene('Bak', 'Tymoteusz', 'Jankowska', 'Rytmika', 5, 'ogolna', NULL);

-- === KLASA 3A - Laura Pietrzak (Skrzypce) ===
EXEC PKG_OCENY.wystaw_ocene('Pietrzak', 'Laura', 'Kaminski', 'Skrzypce', 4, 'technika', NULL);
EXEC PKG_OCENY.wystaw_ocene('Pietrzak', 'Laura', 'Kaminski', 'Skrzypce', 5, 'interpretacja', 'Piekne frazowanie');
EXEC PKG_OCENY.wystaw_ocene('Pietrzak', 'Laura', 'Jankowska', 'Ksztalcenie sluchu', 4, 'teoria', NULL);

-- === KLASA 4A - Hubert Lis (Fortepian) ===
EXEC PKG_OCENY.wystaw_ocene('Lis', 'Hubert', 'Nowak', 'Fortepian', 4, 'technika', NULL);
EXEC PKG_OCENY.wystaw_ocene('Lis', 'Hubert', 'Nowak', 'Fortepian', 4, 'interpretacja', NULL);
EXEC PKG_OCENY.wystaw_ocene('Lis', 'Hubert', 'Nowak', 'Fortepian', 4, 'postepy', 'Stabilny postep');
EXEC PKG_OCENY.wystaw_ocene('Lis', 'Hubert', 'Jankowska', 'Ksztalcenie sluchu', 5, 'sluch', NULL);
EXEC PKG_OCENY.wystaw_ocene('Lis', 'Hubert', 'Mazur', 'Audycje muzyczne', 5, 'ogolna', 'Aktywny na zajeciach');
EXEC PKG_OCENY.wystaw_ocene('Lis', 'Hubert', 'Mazur', 'Chor', 4, 'ogolna', NULL);

-- === KLASA 4A - Weronika Mazurek (Skrzypce) ===
EXEC PKG_OCENY.wystaw_ocene('Mazurek', 'Weronika', 'Wisniewski', 'Skrzypce', 5, 'technika', 'Bardzo czysta intonacja');
EXEC PKG_OCENY.wystaw_ocene('Mazurek', 'Weronika', 'Wisniewski', 'Skrzypce', 5, 'interpretacja', NULL);
EXEC PKG_OCENY.wystaw_ocene('Mazurek', 'Weronika', 'Krawczyk', 'Orkiestra', 5, 'ogolna', 'Liderka sekcji');

-- === KLASA 5A - Dominik Zakrzewski (Fortepian) ===
EXEC PKG_OCENY.wystaw_ocene('Zakrzewski', 'Dominik', 'Szymanski', 'Fortepian', 5, 'technika', NULL);
EXEC PKG_OCENY.wystaw_ocene('Zakrzewski', 'Dominik', 'Szymanski', 'Fortepian', 6, 'interpretacja', 'Dojrzala interpretacja');
EXEC PKG_OCENY.wystaw_ocene('Zakrzewski', 'Dominik', 'Szymanski', 'Fortepian', 5, 'postepy', NULL);
EXEC PKG_OCENY.wystaw_ocene('Zakrzewski', 'Dominik', 'Jankowska', 'Ksztalcenie sluchu', 5, 'teoria', NULL);
EXEC PKG_OCENY.wystaw_ocene('Zakrzewski', 'Dominik', 'Mazur', 'Audycje muzyczne', 5, 'ogolna', NULL);

-- === KLASA 5A - Klaudia Krajewski (Skrzypce) ===
EXEC PKG_OCENY.wystaw_ocene('Krajewski', 'Klaudia', 'Kaminski', 'Skrzypce', 4, 'technika', NULL);
EXEC PKG_OCENY.wystaw_ocene('Krajewski', 'Klaudia', 'Kaminski', 'Skrzypce', 5, 'interpretacja', NULL);
EXEC PKG_OCENY.wystaw_ocene('Krajewski', 'Klaudia', 'Krawczyk', 'Orkiestra', 4, 'ogolna', NULL);

-- === KLASA 6A - Maciej Bednarski (Fortepian) - DYPLOMANT ===
EXEC PKG_OCENY.wystaw_ocene('Bednarski', 'Maciej', 'Kowalska', 'Fortepian', 5, 'technika', 'Przygotowany do egzaminu');
EXEC PKG_OCENY.wystaw_ocene('Bednarski', 'Maciej', 'Kowalska', 'Fortepian', 6, 'interpretacja', 'Wybitna muzykalnosc');
EXEC PKG_OCENY.wystaw_ocene('Bednarski', 'Maciej', 'Kowalska', 'Fortepian', 5, 'postepy', NULL);
EXEC PKG_OCENY.wystaw_ocene('Bednarski', 'Maciej', 'Jankowska', 'Ksztalcenie sluchu', 6, 'sluch', 'Absolutny sluch');
EXEC PKG_OCENY.wystaw_ocene('Bednarski', 'Maciej', 'Mazur', 'Audycje muzyczne', 5, 'ogolna', NULL);
EXEC PKG_OCENY.wystaw_ocene('Bednarski', 'Maciej', 'Mazur', 'Chor', 5, 'ogolna', NULL);

-- === KLASA 6A - Renata Kacprzak (Skrzypce) - DYPLOMANTKA ===
EXEC PKG_OCENY.wystaw_ocene('Kacprzak', 'Renata', 'Wisniewski', 'Skrzypce', 5, 'technika', NULL);
EXEC PKG_OCENY.wystaw_ocene('Kacprzak', 'Renata', 'Wisniewski', 'Skrzypce', 5, 'interpretacja', NULL);
EXEC PKG_OCENY.wystaw_ocene('Kacprzak', 'Renata', 'Krawczyk', 'Orkiestra', 5, 'ogolna', 'Koncertmistrzyni');

-- ============================================================================
-- 10. POTWIERDZENIE I STATYSTYKI
-- ============================================================================

SELECT 'Dane wstawione pomyslnie!' AS status FROM DUAL;

-- Podsumowanie danych
SELECT 'INSTRUMENTY' AS tabela, COUNT(*) AS rekordow FROM INSTRUMENTY UNION ALL
SELECT 'PRZEDMIOTY', COUNT(*) FROM PRZEDMIOTY UNION ALL
SELECT 'NAUCZYCIELE', COUNT(*) FROM NAUCZYCIELE UNION ALL
SELECT 'GRUPY', COUNT(*) FROM GRUPY UNION ALL
SELECT 'SALE', COUNT(*) FROM SALE UNION ALL
SELECT 'UCZNIOWIE', COUNT(*) FROM UCZNIOWIE UNION ALL
SELECT 'LEKCJE', COUNT(*) FROM LEKCJE UNION ALL
SELECT 'OCENY', COUNT(*) FROM OCENY;

-- Statystyka lekcji
SELECT 'Lekcje indywidualne' AS typ, COUNT(*) AS ilosc
FROM LEKCJE WHERE ref_uczen IS NOT NULL
UNION ALL
SELECT 'Lekcje grupowe', COUNT(*)
FROM LEKCJE WHERE ref_grupa IS NOT NULL;

-- Rozklad uczniow w grupach
SELECT DEREF(ref_grupa).kod AS grupa, COUNT(*) AS uczniow
FROM UCZNIOWIE
GROUP BY DEREF(ref_grupa).kod
ORDER BY DEREF(ref_grupa).kod;
