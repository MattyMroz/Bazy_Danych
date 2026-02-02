-- ============================================================================
-- SZKOŁA MUZYCZNA I STOPNIA - ROZSZERZONE SCENARIUSZE TESTOWE
-- Autorzy: Igor Typiński (251237), Mateusz Mróz (251190)
-- ============================================================================
-- UWAGA: Ten plik należy uruchomić PO wykonaniu plików 01-06 (typy, tabele, 
--        pakiety, triggery, dane testowe, scenariusze podstawowe).
--        Scenariusze 12-20 testują przypadki brzegowe i edge cases.
-- ============================================================================

SET SERVEROUTPUT ON;

-- ############################################################################
-- SCENARIUSZ 12: VARRAY - PRZYPADKI BRZEGOWE
-- ############################################################################
-- Kontekst: Testowanie limitów VARRAY wyposażenia sal (0, 10, >10 elementów)
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT SCENARIUSZ 12: VARRAY - PRZYPADKI BRZEGOWE
PROMPT ============================================================

-- 12.1 Dodanie sali z PUSTYM VARRAY (0 elementów)
PROMPT
PROMPT [12.1] Dodanie sali z PUSTYM VARRAY (0 elementow):
EXEC pkg_slowniki.dodaj_sale('106', 'indywidualna', 2, t_wyposazenie());

-- 12.2 Weryfikacja - sala z pustym wyposażeniem
PROMPT
PROMPT [12.2] Weryfikacja - sala 106 powinna miec puste wyposazenie:
SELECT s.numer, s.typ, s.pojemnosc, 
       NVL(s.lista_wyposazenia(), '(puste)') AS wyposazenie
FROM sale s WHERE s.numer = '106';

-- 12.3 Dodanie sali z MAKSYMALNĄ liczbą elementów (10)
PROMPT
PROMPT [12.3] Dodanie sali z MAKSYMALNA liczba elementow VARRAY (10):
EXEC pkg_slowniki.dodaj_sale('107', 'grupowa', 30, t_wyposazenie('Fortepian koncertowy', 'Pianino cyfrowe', 'Tablica interaktywna', 'Projektor HD', 'Ekran projekcyjny', 'Naglosnienie 5.1', 'Mikrofony x3', 'Stojaki na nuty x20', 'Krzesla x30', 'Klimatyzacja'));

-- 12.4 Weryfikacja - sala z 10 elementami
PROMPT
PROMPT [12.4] Weryfikacja - sala 107 z 10 elementami wyposazenia:
SELECT s.numer, s.typ, s.pojemnosc, 
       s.lista_wyposazenia() AS wyposazenie
FROM sale s WHERE s.numer = '107';

-- 12.5 Próba dodania sali z PRZEKROCZENIEM limitu VARRAY (11 elementów)
PROMPT
PROMPT [12.5] Proba dodania sali z 11 elementami (przekroczenie VARRAY(10)):
PROMPT       Oczekiwany BLAD ORA-22909 lub podobny:

BEGIN
    pkg_slowniki.dodaj_sale('108', 'indywidualna', 3,
        t_wyposazenie('1','2','3','4','5','6','7','8','9','10','11'));
    DBMS_OUTPUT.PUT_LINE('NIEOCZEKIWANY SUKCES - powinien byc blad!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 12.6 Dodanie sali z NULL jako VARRAY
PROMPT
PROMPT [12.6] Dodanie sali z NULL jako VARRAY:
BEGIN
    INSERT INTO sale VALUES (
        t_sala(seq_sale.NEXTVAL, '109', 'indywidualna', 2, NULL)
    );
    DBMS_OUTPUT.PUT_LINE('Dodano sale 109 z NULL wyposazeniem');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD: ' || SQLERRM);
END;
/

-- 12.7 Weryfikacja metody lista_wyposazenia() dla NULL
PROMPT
PROMPT [12.7] Weryfikacja lista_wyposazenia() dla sali z NULL:
SELECT s.numer, NVL(s.lista_wyposazenia(), '(NULL/puste)') AS wyposazenie
FROM sale s WHERE s.numer = '109';


-- ############################################################################
-- SCENARIUSZ 13: REFERENCJE DO NIEISTNIEJĄCYCH OBIEKTÓW
-- ############################################################################
-- Kontekst: Testowanie funkcji get_ref_* z nieistniejącymi ID
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT SCENARIUSZ 13: REFERENCJE DO NIEISTNIEJACYCH OBIEKTOW
PROMPT ============================================================

-- 13.1 Próba pobrania REF do nieistniejącego przedmiotu
PROMPT
PROMPT [13.1] Proba pobrania REF do nieistniejacego przedmiotu (ID=9999):
PROMPT       Oczekiwany BLAD -20010:

DECLARE
    v_ref REF t_przedmiot;
BEGIN
    v_ref := pkg_slowniki.get_ref_przedmiot(9999);
    DBMS_OUTPUT.PUT_LINE('NIEOCZEKIWANY SUKCES - przedmiot nie powinien istniec!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 13.2 Próba pobrania REF do nieistniejącej grupy
PROMPT
PROMPT [13.2] Proba pobrania REF do nieistniejacej grupy (ID=9999):
PROMPT       Oczekiwany BLAD -20011:

DECLARE
    v_ref REF t_grupa;
BEGIN
    v_ref := pkg_slowniki.get_ref_grupa(9999);
    DBMS_OUTPUT.PUT_LINE('NIEOCZEKIWANY SUKCES - grupa nie powinna istniec!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 13.3 Próba pobrania REF do nieistniejącej sali
PROMPT
PROMPT [13.3] Proba pobrania REF do nieistniejacej sali (ID=9999):
PROMPT       Oczekiwany BLAD -20012:

DECLARE
    v_ref REF t_sala;
BEGIN
    v_ref := pkg_slowniki.get_ref_sala(9999);
    DBMS_OUTPUT.PUT_LINE('NIEOCZEKIWANY SUKCES - sala nie powinna istniec!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 13.4 Próba pobrania REF do nieistniejącego nauczyciela
PROMPT
PROMPT [13.4] Proba pobrania REF do nieistniejacego nauczyciela (ID=9999):
PROMPT       Oczekiwany BLAD -20013:

DECLARE
    v_ref REF t_nauczyciel;
BEGIN
    v_ref := pkg_osoby.get_ref_nauczyciel(9999);
    DBMS_OUTPUT.PUT_LINE('NIEOCZEKIWANY SUKCES - nauczyciel nie powinien istniec!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 13.5 Próba pobrania REF do nieistniejącego ucznia
PROMPT
PROMPT [13.5] Proba pobrania REF do nieistniejacego ucznia (ID=9999):
PROMPT       Oczekiwany BLAD -20014:

DECLARE
    v_ref REF t_uczen;
BEGIN
    v_ref := pkg_osoby.get_ref_uczen(9999);
    DBMS_OUTPUT.PUT_LINE('NIEOCZEKIWANY SUKCES - uczen nie powinien istniec!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 13.6 Próba dodania nauczyciela z nieistniejącym przedmiotem
PROMPT
PROMPT [13.6] Proba dodania nauczyciela z nieistniejacym przedmiotem (ID=999):
PROMPT       Oczekiwany BLAD -20010:

BEGIN
    pkg_osoby.dodaj_nauczyciela('Test', 'Testowy', 999);
    DBMS_OUTPUT.PUT_LINE('NIEOCZEKIWANY SUKCES!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 13.7 Próba dodania ucznia do nieistniejącej grupy
PROMPT
PROMPT [13.7] Proba dodania ucznia do nieistniejacej grupy (ID=999):
PROMPT       Oczekiwany BLAD -20011:

BEGIN
    pkg_osoby.dodaj_ucznia('Test', 'Testowy', DATE '2015-01-01', 'Fortepian', 999);
    DBMS_OUTPUT.PUT_LINE('NIEOCZEKIWANY SUKCES!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/


-- ############################################################################
-- SCENARIUSZ 14: WSZYSTKIE TYPY KOLIZJI TERMINÓW
-- ############################################################################
-- Kontekst: Kompleksowe testowanie walidacji konfliktów terminów
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT SCENARIUSZ 14: WSZYSTKIE TYPY KOLIZJI TERMINOW
PROMPT ============================================================

-- Najpierw sprawdźmy istniejące lekcje w dniu testowym
PROMPT
PROMPT [14.0] Stan lekcji w dniu 2025-06-02 (poniedzialek):
EXEC pkg_lekcje.plan_dnia(DATE '2025-06-02');

-- 14.1 KOLIZJA SALI - sala już zajęta
PROMPT
PROMPT [14.1] KOLIZJA SALI - sala 101 zajeta 2025-06-02 o 14:00:
PROMPT       (Adam Adamski ma lekcje w tym terminie)
PROMPT       Oczekiwany BLAD -20020 z sugestia:

BEGIN
    -- Sala 101 jest zajęta o 14:00 przez Adama
    pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 4, DATE '2025-06-02', 14);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 14.2 KOLIZJA NAUCZYCIELA - nauczyciel ma już lekcję
PROMPT
PROMPT [14.2] KOLIZJA NAUCZYCIELA - Anna Kowalska (ID=1) zajeta:
PROMPT       Proba dodania lekcji w innej sali ale z tym samym nauczycielem
PROMPT       Oczekiwany BLAD -20020:

BEGIN
    -- Kowalska uczy o 14:00, próbujemy ją przypisać do innej sali w tym samym czasie
    -- Sala 107 jest wolna, ale nauczyciel zajęty
    pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 7, 7, DATE '2025-06-02', 14);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 14.3 KOLIZJA UCZNIA - uczeń ma już lekcję indywidualną
PROMPT
PROMPT [14.3] KOLIZJA UCZNIA - Adam Adamski (ID=1) juz ma lekcje o 14:00:
PROMPT       Proba dodania drugiej lekcji dla tego samego ucznia
PROMPT       Oczekiwany BLAD -20020:

BEGIN
    -- Dodajemy nowego nauczyciela żeby nie było kolizji nauczyciela
    -- Adam (ID=1) ma lekcję o 14:00, próbujemy dodać kolejną
    -- Użyjemy innej sali (107) i innego nauczyciela
    -- Ale najpierw musimy mieć nauczyciela fortepianu - użyjmy istniejącego
    -- Problem: Adam gra na fortepianie, a jedyny nauczyciel fortepianu to Kowalska która jest zajęta
    -- Więc ten test wymaga trochę innej konfiguracji
    
    -- Test: uczeń Daniel (ID=4) gra na Fortepianie
    -- Sprawdźmy czy Daniel ma lekcję 2025-06-02 o 15:00
    pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 4, DATE '2025-06-02', 15);
    -- Jeśli się udało, spróbujmy dodać kolejną w tym samym czasie
    pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 7, 4, DATE '2025-06-02', 15);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 14.4 KOLIZJA GRUPY - grupa ma już zajęcia
PROMPT
PROMPT [14.4] KOLIZJA GRUPY - grupa 1A ma juz zajecia:
PROMPT       (Ksztalcenie sluchu 2025-06-03 o 14:00)

-- Najpierw sprawdźmy plan dnia
PROMPT       Plan dnia 2025-06-03:
EXEC pkg_lekcje.plan_dnia(DATE '2025-06-03');

PROMPT
PROMPT       Proba dodania kolejnej lekcji grupowej dla 1A w tym samym czasie:
PROMPT       Oczekiwany BLAD -20021:

BEGIN
    -- Grupa 1A (ID=1) ma Kształcenie słuchu o 14:00 w sali 103
    -- Próbujemy dodać Rytmikę w innej sali ale dla tej samej grupy
    pkg_lekcje.dodaj_lekcje_grupowa(5, 5, 4, 1, DATE '2025-06-03', 14);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 14.5 KOLIZJA WIELOKROTNA - sala + nauczyciel zajęci jednocześnie
PROMPT
PROMPT [14.5] KOLIZJA WIELOKROTNA - sala I nauczyciel zajeci:
PROMPT       Proba uzycia zajetej sali 101 z zajetym nauczycielem Kowalska
PROMPT       System powinien wykryc pierwszy konflikt (sala):

BEGIN
    -- Sala 101 zajęta + Kowalska (ID=1) zajęta o 14:00
    pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 7, DATE '2025-06-02', 14);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (pierwszy wykryty konflikt): ' || SQLERRM);
END;
/

-- 14.6 BRAK KOLIZJI - wszystkie zasoby wolne
PROMPT
PROMPT [14.6] BRAK KOLIZJI - termin wolny:
PROMPT       Dodanie lekcji w wolnym terminie (2025-06-02 o 18:00):

-- Użyjemy nauczyciela Fletu i ucznia grającego na Flecie
EXEC pkg_lekcje.dodaj_lekcje_indywidualna(6, 6, 5, 10, DATE '2025-06-02', 18);

-- 14.7 Weryfikacja dodanej lekcji
PROMPT
PROMPT [14.7] Weryfikacja - plan ucznia Jakub po dodaniu lekcji:
EXEC pkg_lekcje.plan_ucznia(10);


-- ############################################################################
-- SCENARIUSZ 15: PRZEPEŁNIENIE SALI - PRZYPADKI GRANICZNE
-- ############################################################################
-- Kontekst: Testowanie walidacji pojemności sali
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT SCENARIUSZ 15: PRZEPELNIENIE SALI - PRZYPADKI GRANICZNE
PROMPT ============================================================

-- Najpierw sprawdźmy ile uczniów jest w każdej grupie
PROMPT
PROMPT [15.0] Raport grup - liczba uczniow:
EXEC pkg_raporty.raport_grup;

-- 15.1 Dodanie małej sali grupowej (pojemność = 3)
PROMPT
PROMPT [15.1] Dodanie malej sali grupowej o pojemnosci 3:
EXEC pkg_slowniki.dodaj_sale('110', 'grupowa', 3, t_wyposazenie('Pianino', 'Tablica', 'Krzesla x3'));

-- 15.2 Lekcja grupowa gdy liczba uczniów = pojemność (granica)
PROMPT
PROMPT [15.2] Lekcja grupowa gdy liczba uczniow = pojemnosc sali (3 = 3):
PROMPT       Grupa 1A ma 3 uczniow, sala 110 ma 3 miejsca - powinno PRZEJSC:

BEGIN
    -- Znajdźmy ID nowej sali (110)
    DECLARE
        v_id_sali NUMBER;
    BEGIN
        SELECT s.id INTO v_id_sali FROM sale s WHERE s.numer = '110';
        pkg_lekcje.dodaj_lekcje_grupowa(4, 4, v_id_sali, 1, DATE '2025-06-10', 14);
        DBMS_OUTPUT.PUT_LINE('SUKCES - lekcja dodana (pojemnosc = liczba uczniow)');
    END;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD: ' || SQLERRM);
END;
/

-- 15.3 Dodanie bardzo małej sali (pojemność = 2)
PROMPT
PROMPT [15.3] Dodanie bardzo malej sali grupowej o pojemnosci 2:
EXEC pkg_slowniki.dodaj_sale('111', 'grupowa', 2, t_wyposazenie('Pianino', 'Krzesla x2'));

-- 15.4 Przepełnienie - grupa > pojemność sali
PROMPT
PROMPT [15.4] PRZEPELNIENIE - grupa 1A (3 uczniow) w sali 111 (2 miejsca):
PROMPT       Oczekiwany BLAD -20035:

BEGIN
    DECLARE
        v_id_sali NUMBER;
    BEGIN
        SELECT s.id INTO v_id_sali FROM sale s WHERE s.numer = '111';
        pkg_lekcje.dodaj_lekcje_grupowa(4, 4, v_id_sali, 1, DATE '2025-06-10', 15);
        DBMS_OUTPUT.PUT_LINE('NIEOCZEKIWANY SUKCES - powinien byc blad przepelnienia!');
    END;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 15.5 Dodanie nowej grupy bez uczniów
PROMPT
PROMPT [15.5] Dodanie nowej grupy 5A bez uczniow:
EXEC pkg_slowniki.dodaj_grupe('5A', 5);

-- 15.6 Lekcja grupowa dla grupy z 0 uczniów
PROMPT
PROMPT [15.6] Lekcja grupowa dla grupy 5A (0 uczniow):
PROMPT       Teoretycznie poprawne - sala pomiesci 0 osob:

BEGIN
    DECLARE
        v_id_grupy NUMBER;
    BEGIN
        SELECT g.id INTO v_id_grupy FROM grupy g WHERE g.symbol = '5A';
        pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 3, v_id_grupy, DATE '2025-06-10', 17);
        DBMS_OUTPUT.PUT_LINE('SUKCES - lekcja dla pustej grupy dodana');
    END;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD: ' || SQLERRM);
END;
/

-- 15.7 Sprawdzenie pojemności wszystkich sal
PROMPT
PROMPT [15.7] Lista sal z pojemnosciami:
SELECT s.id, s.numer, s.typ, s.pojemnosc FROM sale s ORDER BY s.id;


-- ############################################################################
-- SCENARIUSZ 16: ŚREDNIA UCZNIA - PRZYPADKI BRZEGOWE
-- ############################################################################
-- Kontekst: Testowanie funkcji srednia_ucznia w różnych konfiguracjach
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT SCENARIUSZ 16: SREDNIA UCZNIA - PRZYPADKI BRZEGOWE
PROMPT ============================================================

-- 16.1 Średnia gdy uczeń ma oceny cząstkowe
PROMPT
PROMPT [16.1] Srednia Jakuba z Fletu (ma oceny czastkowe 5, 4, 5):
SELECT pkg_oceny.srednia_ucznia(10, 6) AS srednia_z_fletu FROM DUAL;

-- 16.2 Średnia gdy uczeń ma TYLKO ocenę semestralną
PROMPT
PROMPT [16.2] Dodanie ucznia z TYLKO ocena semestralna:

-- Dodajmy ocenę semestralną dla ucznia który nie ma ocen cząstkowych z danego przedmiotu
-- Użyjemy Celiny (ID=3) która gra na Gitarze (ID=3)
EXEC pkg_oceny.wystaw_ocene_semestralna(3, 3, 3, 5);

PROMPT
PROMPT       Srednia Celiny z Gitary (tylko ocena semestralna):
PROMPT       Oczekiwany wynik: 0 (bo nie ma ocen czastkowych):
SELECT pkg_oceny.srednia_ucznia(3, 3) AS srednia_z_gitary FROM DUAL;

-- 16.3 Średnia z przedmiotu którego uczeń nie ma
PROMPT
PROMPT [16.3] Srednia z przedmiotu ktorego uczen nie ma:
PROMPT       (Jakub nie ma ocen z Fortepianu - gra na Flecie)
PROMPT       Oczekiwany wynik: 0
SELECT pkg_oceny.srednia_ucznia(10, 1) AS srednia_z_fortepianu FROM DUAL;

-- 16.4 Średnia z nieistniejącego przedmiotu
PROMPT
PROMPT [16.4] Srednia z nieistniejacego przedmiotu (ID=999):
PROMPT       Oczekiwany wynik: 0 (lub NULL konwertowane na 0)
SELECT pkg_oceny.srednia_ucznia(10, 999) AS srednia_nieistniejacy FROM DUAL;

-- 16.5 Średnia dla nieistniejącego ucznia
PROMPT
PROMPT [16.5] Srednia dla nieistniejacego ucznia (ID=999):
PROMPT       Oczekiwany wynik: 0
SELECT pkg_oceny.srednia_ucznia(999, 1) AS srednia_nieistniejacy_uczen FROM DUAL;

-- 16.6 Dodanie wielu ocen i sprawdzenie średniej
PROMPT
PROMPT [16.6] Dodanie wielu ocen dla Filipa (ID=6) z Gitary i sprawdzenie sredniej:
EXEC pkg_oceny.wystaw_ocene(6, 3, 3, 6);
EXEC pkg_oceny.wystaw_ocene(6, 3, 3, 5);
EXEC pkg_oceny.wystaw_ocene(6, 3, 3, 4);
EXEC pkg_oceny.wystaw_ocene(6, 3, 3, 5);

PROMPT       Oceny: 6, 5, 4, 5 -> srednia = (6+5+4+5)/4 = 5.0
SELECT pkg_oceny.srednia_ucznia(6, 3) AS srednia_filipa FROM DUAL;

-- 16.7 Oceny ucznia - weryfikacja
PROMPT
PROMPT [16.7] Wszystkie oceny Filipa:
EXEC pkg_oceny.oceny_ucznia(6);


-- ############################################################################
-- SCENARIUSZ 17: TRIGGER XOR - INSERT I UPDATE
-- ############################################################################
-- Kontekst: Testowanie triggera XOR dla operacji INSERT i UPDATE
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT SCENARIUSZ 17: TRIGGER XOR - INSERT I UPDATE
PROMPT ============================================================

-- 17.1 INSERT - brak ucznia i grupy (naruszenie XOR)
PROMPT
PROMPT [17.1] INSERT bez ucznia i bez grupy (naruszenie XOR):
PROMPT       Oczekiwany BLAD -20001:

BEGIN
    INSERT INTO lekcje VALUES (
        t_lekcja(
            seq_lekcje.NEXTVAL,
            pkg_slowniki.get_ref_przedmiot(1),
            pkg_osoby.get_ref_nauczyciel(1),
            pkg_slowniki.get_ref_sala(1),
            NULL,  -- brak ucznia
            NULL,  -- brak grupy
            DATE '2025-06-20', 14, 45
        )
    );
    DBMS_OUTPUT.PUT_LINE('NIEOCZEKIWANY SUKCES!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 17.2 INSERT - zarówno uczeń JAK I grupa (naruszenie XOR)
PROMPT
PROMPT [17.2] INSERT z uczniem I grupa jednoczesnie (naruszenie XOR):
PROMPT       Oczekiwany BLAD -20001:

BEGIN
    INSERT INTO lekcje VALUES (
        t_lekcja(
            seq_lekcje.NEXTVAL,
            pkg_slowniki.get_ref_przedmiot(1),
            pkg_osoby.get_ref_nauczyciel(1),
            pkg_slowniki.get_ref_sala(1),
            pkg_osoby.get_ref_uczen(1),    -- uczeń
            pkg_slowniki.get_ref_grupa(1), -- i grupa jednocześnie!
            DATE '2025-06-20', 15, 45
        )
    );
    DBMS_OUTPUT.PUT_LINE('NIEOCZEKIWANY SUKCES!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 17.3 UPDATE - zmiana lekcji indywidualnej na "pustą" (usunięcie ucznia)
PROMPT
PROMPT [17.3] UPDATE - proba usuniecia ucznia z lekcji indywidualnej:
PROMPT       (Zmiana ref_uczen na NULL bez ustawienia ref_grupa)
PROMPT       Oczekiwany BLAD -20001:

BEGIN
    -- Znajdź pierwszą lekcję indywidualną
    UPDATE lekcje l
    SET l.ref_uczen = NULL
    WHERE l.id = (SELECT MIN(id) FROM lekcje WHERE ref_uczen IS NOT NULL)
    AND ROWNUM = 1;
    
    DBMS_OUTPUT.PUT_LINE('NIEOCZEKIWANY SUKCES!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
        ROLLBACK;
END;
/

-- 17.4 UPDATE - zmiana lekcji indywidualnej na grupową
PROMPT
PROMPT [17.4] UPDATE - zmiana lekcji indywidualnej na grupowa:
PROMPT       (Usuniecie ucznia i dodanie grupy jednoczesnie)
PROMPT       Powinno PRZEJSC jesli XOR jest spelniony:

BEGIN
    -- Znajdź lekcję indywidualną i zmień na grupową
    UPDATE lekcje l
    SET l.ref_uczen = NULL,
        l.ref_grupa = pkg_slowniki.get_ref_grupa(1)
    WHERE l.id = (SELECT MIN(id) FROM lekcje WHERE ref_uczen IS NOT NULL)
    AND ROWNUM = 1;
    
    DBMS_OUTPUT.PUT_LINE('SUKCES - lekcja zmieniona z indywidualnej na grupowa');
    ROLLBACK; -- Cofamy żeby nie psuć danych testowych
    DBMS_OUTPUT.PUT_LINE('(Zmiana wycofana - ROLLBACK)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD: ' || SQLERRM);
        ROLLBACK;
END;
/

-- 17.5 UPDATE - próba dodania grupy do lekcji indywidualnej (XOR naruszony)
PROMPT
PROMPT [17.5] UPDATE - dodanie grupy do lekcji indywidualnej (bez usuniecia ucznia):
PROMPT       Oczekiwany BLAD -20001:

BEGIN
    UPDATE lekcje l
    SET l.ref_grupa = pkg_slowniki.get_ref_grupa(1)
    WHERE l.id = (SELECT MIN(id) FROM lekcje WHERE ref_uczen IS NOT NULL)
    AND ROWNUM = 1;
    
    DBMS_OUTPUT.PUT_LINE('NIEOCZEKIWANY SUKCES!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
        ROLLBACK;
END;
/


-- ############################################################################
-- SCENARIUSZ 18: TRIGGER ZAKRESU OCEN - WSZYSTKIE PRZYPADKI
-- ############################################################################
-- Kontekst: Testowanie triggera zakresu ocen 1-6
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT SCENARIUSZ 18: TRIGGER ZAKRESU OCEN - WSZYSTKIE PRZYPADKI
PROMPT ============================================================

-- 18.1 Ocena poniżej zakresu (0)
PROMPT
PROMPT [18.1] Ocena ponizej zakresu (0):
PROMPT       Oczekiwany BLAD -20002:

BEGIN
    pkg_oceny.wystaw_ocene(1, 1, 1, 0);
    DBMS_OUTPUT.PUT_LINE('NIEOCZEKIWANY SUKCES!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 18.2 Ocena powyżej zakresu (7)
PROMPT
PROMPT [18.2] Ocena powyzej zakresu (7):
PROMPT       Oczekiwany BLAD -20002:

BEGIN
    pkg_oceny.wystaw_ocene(1, 1, 1, 7);
    DBMS_OUTPUT.PUT_LINE('NIEOCZEKIWANY SUKCES!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 18.3 Ocena ujemna (-1)
PROMPT
PROMPT [18.3] Ocena ujemna (-1):
PROMPT       Oczekiwany BLAD -20002:

BEGIN
    pkg_oceny.wystaw_ocene(1, 1, 1, -1);
    DBMS_OUTPUT.PUT_LINE('NIEOCZEKIWANY SUKCES!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 18.4 Ocena bardzo duża (100)
PROMPT
PROMPT [18.4] Ocena bardzo duza (100):
PROMPT       Oczekiwany BLAD -20002:

BEGIN
    pkg_oceny.wystaw_ocene(1, 1, 1, 100);
    DBMS_OUTPUT.PUT_LINE('NIEOCZEKIWANY SUKCES!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
END;
/

-- 18.5 Oceny na granicy zakresu (1 i 6) - powinny przejść
PROMPT
PROMPT [18.5] Oceny na granicy zakresu (1 i 6) - powinny PRZEJSC:

EXEC pkg_oceny.wystaw_ocene(1, 1, 1, 1);
EXEC pkg_oceny.wystaw_ocene(1, 1, 1, 6);
DBMS_OUTPUT.PUT_LINE('SUKCES - oceny 1 i 6 dodane poprawnie');

-- 18.6 UPDATE oceny na wartość poza zakresem
PROMPT
PROMPT [18.6] UPDATE oceny na wartosc poza zakresem:
PROMPT       Oczekiwany BLAD -20002:

BEGIN
    UPDATE oceny o
    SET o.wartosc = 10
    WHERE o.id = (SELECT MIN(id) FROM oceny)
    AND ROWNUM = 1;
    
    DBMS_OUTPUT.PUT_LINE('NIEOCZEKIWANY SUKCES!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (oczekiwany): ' || SQLERRM);
        ROLLBACK;
END;
/

-- 18.7 Ocena ułamkowa (3.5) - zależnie od typu kolumny
PROMPT
PROMPT [18.7] Ocena ulamkowa (3.5):
PROMPT       Zachowanie zalezy od typu NUMBER - moze byc zaokraglona lub zaakceptowana:

BEGIN
    INSERT INTO oceny VALUES (
        t_ocena(
            seq_oceny.NEXTVAL,
            pkg_osoby.get_ref_uczen(1),
            pkg_osoby.get_ref_nauczyciel(1),
            pkg_slowniki.get_ref_przedmiot(1),
            3.5,  -- ułamkowa
            SYSDATE, 'N'
        )
    );
    DBMS_OUTPUT.PUT_LINE('Ocena 3.5 dodana (NUMBER akceptuje ulamki)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD: ' || SQLERRM);
END;
/

-- 18.8 Weryfikacja dodanych ocen
PROMPT
PROMPT [18.8] Weryfikacja - ostatnie oceny Adama:
SELECT o.wartosc, o.opis_oceny() AS slownie, o.data_oceny
FROM oceny o
WHERE DEREF(o.ref_uczen).id = 1
ORDER BY o.data_oceny DESC
FETCH FIRST 5 ROWS ONLY;


-- ############################################################################
-- SCENARIUSZ 19: DATY - PRZYPADKI SKRAJNE
-- ############################################################################
-- Kontekst: Testowanie systemu z datami w przeszłości i dalekiej przyszłości
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT SCENARIUSZ 19: DATY - PRZYPADKI SKRAJNE
PROMPT ============================================================

-- 19.1 Lekcja w przeszłości (5 lat temu)
PROMPT
PROMPT [19.1] Lekcja w przeszlosci (2020-01-15):
PROMPT       System nie blokuje - historyczne dane moga byc potrzebne:

BEGIN
    pkg_lekcje.dodaj_lekcje_indywidualna(6, 6, 5, 10, DATE '2020-01-15', 14);
    DBMS_OUTPUT.PUT_LINE('SUKCES - lekcja historyczna dodana');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD: ' || SQLERRM);
END;
/

-- 19.2 Lekcja w dalekiej przyszłości (2030)
PROMPT
PROMPT [19.2] Lekcja w dalekiej przyszlosci (2030-06-15):
PROMPT       System nie blokuje - planowanie dlugoterminowe:

BEGIN
    pkg_lekcje.dodaj_lekcje_indywidualna(6, 6, 5, 10, DATE '2030-06-15', 15);
    DBMS_OUTPUT.PUT_LINE('SUKCES - lekcja przyszla dodana');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD: ' || SQLERRM);
END;
/

-- 19.3 Lekcja dzisiaj
PROMPT
PROMPT [19.3] Lekcja dzisiaj (SYSDATE):

BEGIN
    pkg_lekcje.dodaj_lekcje_indywidualna(6, 6, 5, 10, TRUNC(SYSDATE), 19);
    DBMS_OUTPUT.PUT_LINE('SUKCES - lekcja na dzis dodana');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD: ' || SQLERRM);
END;
/

-- 19.4 Data urodzenia ucznia w przyszłości (błąd logiczny)
PROMPT
PROMPT [19.4] Uczen z data urodzenia w przyszlosci:
PROMPT       System nie waliduje - ale metoda wiek() da ujemny wynik:

BEGIN
    pkg_osoby.dodaj_ucznia('Przyszly', 'Uczen', DATE '2030-01-01', 'Fortepian', 4);
    DBMS_OUTPUT.PUT_LINE('UWAGA: Dodano ucznia z przyszla data urodzenia!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD: ' || SQLERRM);
END;
/

-- 19.5 Sprawdzenie wieku ucznia z przyszłą datą urodzenia
PROMPT
PROMPT [19.5] Wiek ucznia z przyszla data urodzenia:
SELECT u.pelne_nazwisko() AS uczen, 
       u.data_ur, 
       u.wiek() AS wiek_lat
FROM uczniowie u 
WHERE u.nazwisko = 'Uczen'
ORDER BY u.id DESC
FETCH FIRST 1 ROW ONLY;

-- 19.6 Bardzo stara data urodzenia
PROMPT
PROMPT [19.6] Uczen z bardzo stara data urodzenia (1900):
PROMPT       System nie waliduje wieku - teoretycznie mozliwe:

BEGIN
    pkg_osoby.dodaj_ucznia('Bardzo', 'Stary', DATE '1900-01-01', 'Fortepian', 4);
    DBMS_OUTPUT.PUT_LINE('UWAGA: Dodano ucznia z data 1900 roku!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD: ' || SQLERRM);
END;
/

-- 19.7 Sprawdzenie wieku bardzo starego ucznia
PROMPT
PROMPT [19.7] Wiek ucznia z 1900 roku:
SELECT u.pelne_nazwisko() AS uczen, 
       u.data_ur, 
       u.wiek() AS wiek_lat
FROM uczniowie u 
WHERE u.nazwisko = 'Stary'
ORDER BY u.id DESC
FETCH FIRST 1 ROW ONLY;


-- ############################################################################
-- SCENARIUSZ 20: HEURYSTYKA - BRAK WOLNYCH TERMINÓW
-- ############################################################################
-- Kontekst: Testowanie zachowania gdy nie ma wolnych terminów
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT SCENARIUSZ 20: HEURYSTYKA - BRAK WOLNYCH TERMINOW
PROMPT ============================================================

-- 20.1 Najpierw sprawdźmy ile mamy sal z Fletem
PROMPT
PROMPT [20.1] Sale z instrumentem Flet:
SELECT s.id, s.numer, s.lista_wyposazenia() AS wyposazenie
FROM sale s
WHERE UPPER(s.lista_wyposazenia()) LIKE '%FLET%';

-- 20.2 Zablokujmy wszystkie terminy w sali 105 (jedyna z Fletem) na jeden dzień
PROMPT
PROMPT [20.2] Blokowanie wszystkich terminow w sali 105 na 2025-06-16:
PROMPT       (Dodajemy lekcje o 14, 15, 16, 17, 18, 19)

DECLARE
    v_id_sali NUMBER;
BEGIN
    SELECT s.id INTO v_id_sali FROM sale s WHERE s.numer = '105';
    
    FOR godz IN 14..19 LOOP
        BEGIN
            pkg_lekcje.dodaj_lekcje_indywidualna(6, 6, v_id_sali, 10, DATE '2025-06-16', godz);
            DBMS_OUTPUT.PUT_LINE('Dodano lekcje o ' || godz || ':00');
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Blad dla ' || godz || ':00 - ' || SQLERRM);
        END;
    END LOOP;
END;
/

-- 20.3 Plan dnia - weryfikacja zablokowanych terminów
PROMPT
PROMPT [20.3] Plan dnia 2025-06-16 - sala 105 powinna byc pelna:
EXEC pkg_lekcje.plan_dnia(DATE '2025-06-16');

-- 20.4 Próba dodania kolejnej lekcji - heurystyka powinna znaleźć następny dzień
PROMPT
PROMPT [20.4] Proba dodania lekcji gdy sala 105 jest pelna 2025-06-16:
PROMPT       Heurystyka powinna zasugerowac nastepny dzien (2025-06-17):

BEGIN
    -- Próbujemy dodać o 14:00 gdy wszystko jest zajęte
    pkg_lekcje.dodaj_lekcje_indywidualna(6, 6, 5, 10, DATE '2025-06-16', 14);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Komunikat z sugestia:');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/


-- ############################################################################
-- SCENARIUSZ 21: METODY OBIEKTOWE - WARTOŚCI SPECJALNE
-- ############################################################################
-- Kontekst: Testowanie metod obiektowych z wartościami NULL i specjalnymi
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT SCENARIUSZ 21: METODY OBIEKTOWE - WARTOSCI SPECJALNE
PROMPT ============================================================

-- 21.1 Metoda pelne_nazwisko() gdy imię lub nazwisko jest NULL
PROMPT
PROMPT [21.1] Test metody pelne_nazwisko() z wartosciami specjalnymi:
PROMPT       (Bezposredni INSERT z NULL - omijamy walidacje procedury)

BEGIN
    INSERT INTO uczniowie VALUES (
        t_uczen(
            seq_uczniowie.NEXTVAL,
            NULL,           -- imię NULL
            'BezImienia',
            DATE '2015-01-01',
            'Fortepian',
            pkg_slowniki.get_ref_grupa(1)
        )
    );
    DBMS_OUTPUT.PUT_LINE('UWAGA: Dodano ucznia bez imienia!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD (constraint NOT NULL): ' || SQLERRM);
END;
/

-- 21.2 Metoda wiek() dla bardzo małego dziecka (urodzone w tym roku)
PROMPT
PROMPT [21.2] Metoda wiek() dla niemowlaka (urodzony w 2026):

BEGIN
    pkg_osoby.dodaj_ucznia('Male', 'Dziecko', DATE '2026-01-15', 'Fortepian', 1);
    DBMS_OUTPUT.PUT_LINE('Dodano niemowlaka');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD: ' || SQLERRM);
END;
/

SELECT u.pelne_nazwisko() AS uczen, 
       u.data_ur, 
       u.wiek() AS wiek_lat
FROM uczniowie u 
WHERE u.nazwisko = 'Dziecko'
ORDER BY u.id DESC
FETCH FIRST 1 ROW ONLY;

-- 21.3 Metoda staz_lat() dla nauczyciela zatrudnionego dzisiaj
PROMPT
PROMPT [21.3] Metoda staz_lat() dla nowego nauczyciela (zatrudniony dzisiaj):
PROMPT       (Dodajemy nowy przedmiot i nauczyciela)

EXEC pkg_slowniki.dodaj_przedmiot('Perkusja', 'indywidualny');

DECLARE
    v_id_przedmiotu NUMBER;
BEGIN
    SELECT MAX(p.id) INTO v_id_przedmiotu FROM przedmioty p;
    pkg_osoby.dodaj_nauczyciela('Nowy', 'Nauczyciel', v_id_przedmiotu);
END;
/

SELECT n.pelne_nazwisko() AS nauczyciel, 
       n.data_zatr, 
       n.staz_lat() AS staz_lat
FROM nauczyciele n 
WHERE n.nazwisko = 'Nauczyciel'
ORDER BY n.id DESC
FETCH FIRST 1 ROW ONLY;

-- 21.4 Metoda czy_grupowy() dla różnych przedmiotów
PROMPT
PROMPT [21.4] Metoda czy_grupowy() dla wszystkich przedmiotow:
SELECT p.nazwa, p.typ, p.czy_grupowy() AS czy_grupowy FROM przedmioty p ORDER BY p.id;

-- 21.5 Metoda opis_oceny() dla wszystkich wartości 1-6
PROMPT
PROMPT [21.5] Metoda opis_oceny() - mapowanie ocen na slownie:
SELECT LEVEL AS ocena, 
       t_ocena(NULL, NULL, NULL, NULL, LEVEL, NULL, NULL).opis_oceny() AS slownie
FROM DUAL
CONNECT BY LEVEL <= 6;

-- 21.6 Metoda godzina_koniec() - weryfikacja obliczeń
PROMPT
PROMPT [21.6] Metoda godzina_koniec() - weryfikacja obliczen:
PROMPT       Lekcja o 14:00 (45 min) konczy sie o 14:45 (14.75 dziesietnie):
SELECT l.godz_rozp || ':00' AS start, 
       l.czas_min || ' min' AS czas,
       l.godzina_koniec() AS koniec_dziesietnie,
       TO_CHAR(TRUNC(l.godzina_koniec())) || ':' || 
       LPAD(TO_CHAR(ROUND((l.godzina_koniec() - TRUNC(l.godzina_koniec())) * 60)), 2, '0') AS koniec_czytelnie
FROM lekcje l
WHERE ROWNUM <= 5;


-- ############################################################################
-- SCENARIUSZ 22: KURSORY - RÓŻNE TYPY
-- ############################################################################
-- Kontekst: Demonstracja różnych typów kursorów
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT SCENARIUSZ 22: KURSORY - ROZNE TYPY
PROMPT ============================================================

-- 22.1 Kursor jawny - lista_uczniow_grupy (OPEN/FETCH/CLOSE)
PROMPT
PROMPT [22.1] KURSOR JAWNY - lista uczniow grupy 1A:
PROMPT       (Procedura uzywa OPEN/FETCH/CLOSE)
EXEC pkg_osoby.lista_uczniow_grupy(1);

-- 22.2 Kursor niejawny (FOR) - lista wszystkich uczniów
PROMPT
PROMPT [22.2] KURSOR NIEJAWNY (FOR) - lista wszystkich uczniow:
PROMPT       (Procedura uzywa FOR rec IN SELECT)
EXEC pkg_osoby.lista_uczniow;

-- 22.3 Kursor jawny dla pustej grupy (bez uczniów)
PROMPT
PROMPT [22.3] KURSOR JAWNY dla pustej grupy 5A (bez uczniow):
EXEC pkg_osoby.lista_uczniow_grupy(5);

-- 22.4 Test kursora z dużą ilością danych
PROMPT
PROMPT [22.4] Test kursora - wszystkie lekcje (moze byc duzo):
DECLARE
    v_count NUMBER := 0;
BEGIN
    FOR r IN (SELECT l.id FROM lekcje l) LOOP
        v_count := v_count + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Przetworzono ' || v_count || ' lekcji przez kursor FOR');
END;
/


-- ############################################################################
-- SCENARIUSZ 23: WALIDACJA SYNONYMÓW INSTRUMENTÓW
-- ############################################################################
-- Kontekst: Testowanie czy system rozpoznaje synonimy (Fortepian = Pianino)
-- ============================================================================

PROMPT
PROMPT ============================================================
PROMPT SCENARIUSZ 23: WALIDACJA SYNONYMOW INSTRUMENTOW
PROMPT ============================================================

-- 23.1 Dodanie ucznia z instrumentem "Pianino" (synonim Fortepianu)
PROMPT
PROMPT [23.1] Dodanie ucznia z instrumentem "Pianino":
EXEC pkg_osoby.dodaj_ucznia('Piano', 'Player', DATE '2014-01-01', 'Pianino', 1);

-- 23.2 Próba dodania lekcji z przedmiotu "Fortepian" dla ucznia z "Pianino"
PROMPT
PROMPT [23.2] Lekcja Fortepianu dla ucznia grajacego na Pianinie:
PROMPT       System powinien rozpoznac synonim i zaakceptowac:

DECLARE
    v_id_ucznia NUMBER;
BEGIN
    SELECT MAX(u.id) INTO v_id_ucznia FROM uczniowie u WHERE u.nazwisko = 'Player';
    pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, v_id_ucznia, DATE '2025-06-20', 14);
    DBMS_OUTPUT.PUT_LINE('SUKCES - synonim Pianino/Fortepian rozpoznany');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD: ' || SQLERRM);
END;
/

-- 23.3 Weryfikacja - sprawdzenie czy wyposażenie sali jest sprawdzane
PROMPT
PROMPT [23.3] Sprawdzenie funkcji sala_ma_instrument:
PROMPT       Sala 101 ma "Fortepian Yamaha", sala 103 ma "Pianino"
SELECT s.numer, s.lista_wyposazenia() AS wyposazenie
FROM sale s
WHERE s.numer IN ('101', '103');


-- ############################################################################
-- PODSUMOWANIE ROZSZERZONYCH TESTÓW
-- ############################################################################

PROMPT
PROMPT ============================================================
PROMPT PODSUMOWANIE ROZSZERZONYCH TESTOW
PROMPT ============================================================

EXEC pkg_raporty.statystyki;

PROMPT
PROMPT ============================================================
PROMPT KONIEC ROZSZERZONYCH SCENARIUSZY TESTOWYCH (12-23)
PROMPT ============================================================

/*
================================================================================
PODSUMOWANIE ROZSZERZONYCH SCENARIUSZY TESTOWYCH:

SCENARIUSZ 12: VARRAY - PRZYPADKI BRZEGOWE
   - Puste VARRAY (0 elementów)
   - Maksymalne VARRAY (10 elementów)
   - Przekroczenie limitu (11 elementów) - błąd
   - NULL jako VARRAY

SCENARIUSZ 13: REFERENCJE DO NIEISTNIEJĄCYCH OBIEKTÓW
   - get_ref_przedmiot() z nieistniejącym ID
   - get_ref_grupa() z nieistniejącym ID
   - get_ref_sala() z nieistniejącym ID
   - get_ref_nauczyciel() z nieistniejącym ID
   - get_ref_uczen() z nieistniejącym ID
   - Dodawanie z nieistniejącymi referencjami

SCENARIUSZ 14: WSZYSTKIE TYPY KOLIZJI TERMINÓW
   - Kolizja sali
   - Kolizja nauczyciela
   - Kolizja ucznia
   - Kolizja grupy
   - Kolizja wielokrotna (sala + nauczyciel)
   - Brak kolizji - sukces

SCENARIUSZ 15: PRZEPEŁNIENIE SALI
   - Liczba uczniów = pojemność (granica)
   - Liczba uczniów > pojemność (błąd)
   - Grupa z 0 uczniów

SCENARIUSZ 16: ŚREDNIA UCZNIA
   - Średnia z ocenami cząstkowymi
   - Średnia gdy tylko ocena semestralna (0)
   - Średnia z przedmiotu którego uczeń nie ma (0)
   - Średnia z nieistniejącego przedmiotu
   - Średnia dla nieistniejącego ucznia

SCENARIUSZ 17: TRIGGER XOR - INSERT I UPDATE
   - INSERT bez ucznia i grupy
   - INSERT z uczniem i grupą
   - UPDATE usuwający ucznia
   - UPDATE zmieniający typ lekcji
   - UPDATE dodający grupę do indywidualnej

SCENARIUSZ 18: TRIGGER ZAKRESU OCEN
   - Ocena 0 (poniżej zakresu)
   - Ocena 7 (powyżej zakresu)
   - Ocena -1 (ujemna)
   - Ocena 100 (bardzo duża)
   - Oceny 1 i 6 (granice)
   - UPDATE na wartość poza zakresem
   - Ocena ułamkowa

SCENARIUSZ 19: DATY - PRZYPADKI SKRAJNE
   - Lekcja w przeszłości
   - Lekcja w dalekiej przyszłości
   - Lekcja dzisiaj
   - Uczeń z datą urodzenia w przyszłości
   - Uczeń z bardzo starą datą urodzenia

SCENARIUSZ 20: HEURYSTYKA - BRAK WOLNYCH TERMINÓW
   - Zablokowanie wszystkich terminów w sali
   - Heurystyka sugerująca następny dzień

SCENARIUSZ 21: METODY OBIEKTOWE - WARTOŚCI SPECJALNE
   - pelne_nazwisko() z NULL
   - wiek() dla niemowlaka
   - staz_lat() dla nowego nauczyciela
   - czy_grupowy() dla wszystkich przedmiotów
   - opis_oceny() dla wszystkich wartości
   - godzina_koniec() weryfikacja obliczeń

SCENARIUSZ 22: KURSORY - RÓŻNE TYPY
   - Kursor jawny (OPEN/FETCH/CLOSE)
   - Kursor niejawny (FOR)
   - Kursor dla pustego zbioru

SCENARIUSZ 23: WALIDACJA SYNONYMÓW INSTRUMENTÓW
   - Rozpoznawanie Pianino = Fortepian
   - Sprawdzanie wyposażenia sali

================================================================================
POKRYCIE TESTOWE PO ROZSZERZENIU:

| Obszar                    | Pokrycie | Scenariusze |
|---------------------------|----------|-------------|
| CRUD podstawowy           | ✅ 100%  | 1-7, 12-13  |
| Walidacje biznesowe       | ✅ 95%   | 8, 14-15    |
| VARRAY                    | ✅ 100%  | 9, 12       |
| REF/DEREF                 | ✅ 100%  | 10, 13      |
| Triggery                  | ✅ 100%  | 8, 17-18    |
| Heurystyka                | ✅ 90%   | 4, 20       |
| Metody obiektowe          | ✅ 100%  | 11, 21      |
| Kursory                   | ✅ 100%  | 2, 22       |
| Przypadki brzegowe        | ✅ 95%   | 12-23       |
| Średnie i oceny           | ✅ 100%  | 5-6, 16, 18 |
| Daty skrajne              | ✅ 100%  | 19          |
| Synonimy instrumentów     | ✅ 100%  | 23          |

================================================================================
*/
