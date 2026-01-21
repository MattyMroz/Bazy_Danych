-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 05_dane.sql
-- Opis: Dane testowe - instrumenty, sale, nauczyciele, uczniowie, kursy
-- Wersja: 3.0 (uproszczona)
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- ============================================================================
-- 1. INSTRUMENTY (slownik)
-- ============================================================================
INSERT INTO t_instrument VALUES (t_instrument_obj(seq_instrument.NEXTVAL, 'Fortepian', 'klawiszowe'));
INSERT INTO t_instrument VALUES (t_instrument_obj(seq_instrument.NEXTVAL, 'Gitara klasyczna', 'strunowe'));
INSERT INTO t_instrument VALUES (t_instrument_obj(seq_instrument.NEXTVAL, 'Gitara elektryczna', 'strunowe'));
INSERT INTO t_instrument VALUES (t_instrument_obj(seq_instrument.NEXTVAL, 'Skrzypce', 'strunowe'));
INSERT INTO t_instrument VALUES (t_instrument_obj(seq_instrument.NEXTVAL, 'Wiolonczela', 'strunowe'));
INSERT INTO t_instrument VALUES (t_instrument_obj(seq_instrument.NEXTVAL, 'Flet', 'dete'));
INSERT INTO t_instrument VALUES (t_instrument_obj(seq_instrument.NEXTVAL, 'Klarnet', 'dete'));
INSERT INTO t_instrument VALUES (t_instrument_obj(seq_instrument.NEXTVAL, 'Trabka', 'dete'));
INSERT INTO t_instrument VALUES (t_instrument_obj(seq_instrument.NEXTVAL, 'Saksofon', 'dete'));
INSERT INTO t_instrument VALUES (t_instrument_obj(seq_instrument.NEXTVAL, 'Perkusja', 'perkusyjne'));

COMMIT;

-- ============================================================================
-- 2. SALE (5 sal)
-- ============================================================================
INSERT INTO t_sala VALUES (t_sala_obj(seq_sala.NEXTVAL, 'Sala A1', 1, 'T', 'N'));   -- fortepian
INSERT INTO t_sala VALUES (t_sala_obj(seq_sala.NEXTVAL, 'Sala A2', 1, 'T', 'N'));   -- fortepian
INSERT INTO t_sala VALUES (t_sala_obj(seq_sala.NEXTVAL, 'Sala B1', 2, 'N', 'N'));   -- ogolna
INSERT INTO t_sala VALUES (t_sala_obj(seq_sala.NEXTVAL, 'Sala B2', 3, 'N', 'N'));   -- ogolna wieksza
INSERT INTO t_sala VALUES (t_sala_obj(seq_sala.NEXTVAL, 'Sala C1', 1, 'N', 'T'));   -- perkusja

COMMIT;

-- ============================================================================
-- 3. NAUCZYCIELE (5 nauczycieli z roznymi instrumentami)
-- ============================================================================

-- Nauczyciel 1: pianista + skrzypce
INSERT INTO t_nauczyciel VALUES (
    t_nauczyciel_obj(
        seq_nauczyciel.NEXTVAL,
        'Jan',
        'Kowalski',
        'j.kowalski@szkolamuzyczna.pl',
        DATE '2018-09-01',
        t_lista_instrumentow('Fortepian', 'Skrzypce')
    )
);

-- Nauczyciel 2: gitarzysta (klasyczna + elektryczna)
INSERT INTO t_nauczyciel VALUES (
    t_nauczyciel_obj(
        seq_nauczyciel.NEXTVAL,
        'Anna',
        'Nowak',
        'a.nowak@szkolamuzyczna.pl',
        DATE '2019-03-15',
        t_lista_instrumentow('Gitara klasyczna', 'Gitara elektryczna')
    )
);

-- Nauczyciel 3: dety (flet, klarnet, saksofon)
INSERT INTO t_nauczyciel VALUES (
    t_nauczyciel_obj(
        seq_nauczyciel.NEXTVAL,
        'Piotr',
        'Wisniewski',
        'p.wisniewski@szkolamuzyczna.pl',
        DATE '2020-01-10',
        t_lista_instrumentow('Flet', 'Klarnet', 'Saksofon')
    )
);

-- Nauczyciel 4: perkusja + trabka
INSERT INTO t_nauczyciel VALUES (
    t_nauczyciel_obj(
        seq_nauczyciel.NEXTVAL,
        'Maria',
        'Dabrowska',
        'm.dabrowska@szkolamuzyczna.pl',
        DATE '2021-09-01',
        t_lista_instrumentow('Perkusja', 'Trabka')
    )
);

-- Nauczyciel 5: wiolonczela + fortepian
INSERT INTO t_nauczyciel VALUES (
    t_nauczyciel_obj(
        seq_nauczyciel.NEXTVAL,
        'Tomasz',
        'Lewandowski',
        't.lewandowski@szkolamuzyczna.pl',
        DATE '2022-02-01',
        t_lista_instrumentow('Wiolonczela', 'Fortepian')
    )
);

COMMIT;

-- ============================================================================
-- 4. UCZNIOWIE (10 uczniow - mix dzieci i doroslych)
-- ============================================================================

-- Dzieci (ponizej 15 lat) - lekcje tylko 14:00-19:00
INSERT INTO t_uczen VALUES (
    t_uczen_obj(seq_uczen.NEXTVAL, 'Kacper', 'Malinowski', DATE '2015-05-12', 'kacper.m@email.pl', SYSDATE)
);  -- 9 lat (dziecko)

INSERT INTO t_uczen VALUES (
    t_uczen_obj(seq_uczen.NEXTVAL, 'Zofia', 'Wojcik', DATE '2013-08-23', 'zofia.w@email.pl', SYSDATE)
);  -- 11 lat (dziecko)

INSERT INTO t_uczen VALUES (
    t_uczen_obj(seq_uczen.NEXTVAL, 'Jakub', 'Kaminski', DATE '2012-01-15', NULL, SYSDATE)
);  -- 13 lat (dziecko)

INSERT INTO t_uczen VALUES (
    t_uczen_obj(seq_uczen.NEXTVAL, 'Maja', 'Zielinska', DATE '2011-11-30', 'maja.z@email.pl', SYSDATE)
);  -- 13 lat (dziecko)

-- Mlodziez (15-17 lat) - brak ograniczen godzinowych
INSERT INTO t_uczen VALUES (
    t_uczen_obj(seq_uczen.NEXTVAL, 'Adam', 'Szymanski', DATE '2008-04-05', 'adam.sz@email.pl', SYSDATE)
);  -- 17 lat

INSERT INTO t_uczen VALUES (
    t_uczen_obj(seq_uczen.NEXTVAL, 'Natalia', 'Wozniak', DATE '2009-07-18', 'natalia.w@email.pl', SYSDATE)
);  -- 16 lat

-- Dorosli (18+ lat)
INSERT INTO t_uczen VALUES (
    t_uczen_obj(seq_uczen.NEXTVAL, 'Michal', 'Kozlowski', DATE '2000-02-28', 'michal.k@email.pl', SYSDATE)
);  -- 25 lat

INSERT INTO t_uczen VALUES (
    t_uczen_obj(seq_uczen.NEXTVAL, 'Karolina', 'Jankowska', DATE '1995-12-10', 'karolina.j@email.pl', SYSDATE)
);  -- 29 lat

INSERT INTO t_uczen VALUES (
    t_uczen_obj(seq_uczen.NEXTVAL, 'Rafal', 'Wrobel', DATE '1988-06-20', 'rafal.w@email.pl', SYSDATE)
);  -- 36 lat

INSERT INTO t_uczen VALUES (
    t_uczen_obj(seq_uczen.NEXTVAL, 'Ewa', 'Olszewska', DATE '1975-03-08', 'ewa.o@email.pl', SYSDATE)
);  -- 50 lat

COMMIT;

-- ============================================================================
-- 5. KURSY (10 kursow - rozne poziomy i instrumenty)
-- ============================================================================
DECLARE
    v_ref_fortepian REF t_instrument_obj;
    v_ref_gitara_kl REF t_instrument_obj;
    v_ref_gitara_el REF t_instrument_obj;
    v_ref_skrzypce  REF t_instrument_obj;
    v_ref_flet      REF t_instrument_obj;
    v_ref_perkusja  REF t_instrument_obj;
    v_ref_saksofon  REF t_instrument_obj;
BEGIN
    -- Pobranie referencji do instrumentow
    SELECT REF(i) INTO v_ref_fortepian FROM t_instrument i WHERE i.nazwa = 'Fortepian';
    SELECT REF(i) INTO v_ref_gitara_kl FROM t_instrument i WHERE i.nazwa = 'Gitara klasyczna';
    SELECT REF(i) INTO v_ref_gitara_el FROM t_instrument i WHERE i.nazwa = 'Gitara elektryczna';
    SELECT REF(i) INTO v_ref_skrzypce FROM t_instrument i WHERE i.nazwa = 'Skrzypce';
    SELECT REF(i) INTO v_ref_flet FROM t_instrument i WHERE i.nazwa = 'Flet';
    SELECT REF(i) INTO v_ref_perkusja FROM t_instrument i WHERE i.nazwa = 'Perkusja';
    SELECT REF(i) INTO v_ref_saksofon FROM t_instrument i WHERE i.nazwa = 'Saksofon';
    
    -- Kursy fortepianowe
    INSERT INTO t_kurs VALUES (
        t_kurs_obj(seq_kurs.NEXTVAL, 'Fortepian - podstawy', 'poczatkujacy', 80, v_ref_fortepian)
    );
    INSERT INTO t_kurs VALUES (
        t_kurs_obj(seq_kurs.NEXTVAL, 'Fortepian - sredni', 'sredni', 100, v_ref_fortepian)
    );
    INSERT INTO t_kurs VALUES (
        t_kurs_obj(seq_kurs.NEXTVAL, 'Fortepian - zaawansowany', 'zaawansowany', 120, v_ref_fortepian)
    );
    
    -- Kursy gitarowe
    INSERT INTO t_kurs VALUES (
        t_kurs_obj(seq_kurs.NEXTVAL, 'Gitara klasyczna - podstawy', 'poczatkujacy', 70, v_ref_gitara_kl)
    );
    INSERT INTO t_kurs VALUES (
        t_kurs_obj(seq_kurs.NEXTVAL, 'Gitara elektryczna - rock', 'sredni', 90, v_ref_gitara_el)
    );
    
    -- Kursy smyczkowe
    INSERT INTO t_kurs VALUES (
        t_kurs_obj(seq_kurs.NEXTVAL, 'Skrzypce - podstawy', 'poczatkujacy', 85, v_ref_skrzypce)
    );
    INSERT INTO t_kurs VALUES (
        t_kurs_obj(seq_kurs.NEXTVAL, 'Skrzypce - sredni', 'sredni', 105, v_ref_skrzypce)
    );
    
    -- Kursy dete
    INSERT INTO t_kurs VALUES (
        t_kurs_obj(seq_kurs.NEXTVAL, 'Flet - podstawy', 'poczatkujacy', 75, v_ref_flet)
    );
    INSERT INTO t_kurs VALUES (
        t_kurs_obj(seq_kurs.NEXTVAL, 'Saksofon - jazz', 'zaawansowany', 110, v_ref_saksofon)
    );
    
    -- Kurs perkusyjny
    INSERT INTO t_kurs VALUES (
        t_kurs_obj(seq_kurs.NEXTVAL, 'Perkusja - podstawy', 'poczatkujacy', 80, v_ref_perkusja)
    );
    
    COMMIT;
END;
/

-- ============================================================================
-- 6. PRZYKLADOWE LEKCJE (na przyszly poniedzialek)
-- ============================================================================
DECLARE
    v_data DATE;
    v_ref_uczen1 REF t_uczen_obj;
    v_ref_uczen5 REF t_uczen_obj;
    v_ref_uczen7 REF t_uczen_obj;
    v_ref_naucz1 REF t_nauczyciel_obj;
    v_ref_naucz2 REF t_nauczyciel_obj;
    v_ref_kurs1 REF t_kurs_obj;
    v_ref_kurs4 REF t_kurs_obj;
    v_ref_sala1 REF t_sala_obj;
    v_ref_sala3 REF t_sala_obj;
BEGIN
    -- Oblicz najblizszy poniedzialek
    v_data := NEXT_DAY(SYSDATE, 'MONDAY');
    
    -- Pobranie referencji
    SELECT REF(u) INTO v_ref_uczen1 FROM t_uczen u WHERE u.id_ucznia = 1;    -- Kacper (dziecko)
    SELECT REF(u) INTO v_ref_uczen5 FROM t_uczen u WHERE u.id_ucznia = 5;    -- Adam (17 lat)
    SELECT REF(u) INTO v_ref_uczen7 FROM t_uczen u WHERE u.id_ucznia = 7;    -- Michal (25 lat)
    
    SELECT REF(n) INTO v_ref_naucz1 FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;  -- Jan
    SELECT REF(n) INTO v_ref_naucz2 FROM t_nauczyciel n WHERE n.id_nauczyciela = 2;  -- Anna
    
    SELECT REF(k) INTO v_ref_kurs1 FROM t_kurs k WHERE k.id_kursu = 1;   -- Fortepian podstawy
    SELECT REF(k) INTO v_ref_kurs4 FROM t_kurs k WHERE k.id_kursu = 4;   -- Gitara klasyczna
    
    SELECT REF(s) INTO v_ref_sala1 FROM t_sala s WHERE s.id_sali = 1;    -- Sala A1
    SELECT REF(s) INTO v_ref_sala3 FROM t_sala s WHERE s.id_sali = 3;    -- Sala B1
    
    -- Lekcja 1: dziecko - godzina 14:00 (dozwolona)
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '14:00', 45, 'zaplanowana',
                     v_ref_uczen1, v_ref_naucz1, v_ref_kurs1, v_ref_sala1)
    );
    
    -- Lekcja 2: mlodziez - godzina 10:00 (dozwolona)
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '10:00', 45, 'zaplanowana',
                     v_ref_uczen5, v_ref_naucz2, v_ref_kurs4, v_ref_sala3)
    );
    
    -- Lekcja 3: dorosly - godzina 08:00 (dozwolona)
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(seq_lekcja.NEXTVAL, v_data, '08:00', 60, 'zaplanowana',
                     v_ref_uczen7, v_ref_naucz1, v_ref_kurs1, v_ref_sala1)
    );
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Dodano 3 przykladowe lekcje na: ' || TO_CHAR(v_data, 'YYYY-MM-DD'));
END;
/

-- ============================================================================
-- 7. PRZYKLADOWE OCENY
-- ============================================================================
DECLARE
    v_ref_uczen1 REF t_uczen_obj;
    v_ref_uczen5 REF t_uczen_obj;
    v_ref_naucz1 REF t_nauczyciel_obj;
    v_ref_naucz2 REF t_nauczyciel_obj;
BEGIN
    SELECT REF(u) INTO v_ref_uczen1 FROM t_uczen u WHERE u.id_ucznia = 1;
    SELECT REF(u) INTO v_ref_uczen5 FROM t_uczen u WHERE u.id_ucznia = 5;
    SELECT REF(n) INTO v_ref_naucz1 FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    SELECT REF(n) INTO v_ref_naucz2 FROM t_nauczyciel n WHERE n.id_nauczyciela = 2;
    
    -- Oceny dla ucznia 1 (Kacper)
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, SYSDATE - 30, 4, 'technika', 'Dobra postawa', v_ref_uczen1, v_ref_naucz1)
    );
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, SYSDATE - 15, 5, 'rytm', 'Swietne wyczucie', v_ref_uczen1, v_ref_naucz1)
    );
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, SYSDATE - 7, 4, 'teoria', NULL, v_ref_uczen1, v_ref_naucz1)
    );
    
    -- Oceny dla ucznia 5 (Adam)
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, SYSDATE - 20, 3, 'technika', 'Do poprawy chwyty', v_ref_uczen5, v_ref_naucz2)
    );
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, SYSDATE - 10, 4, 'technika', 'Widac postep', v_ref_uczen5, v_ref_naucz2)
    );
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, SYSDATE - 5, 5, 'interpretacja', 'Bardzo dobra ekspresja', v_ref_uczen5, v_ref_naucz2)
    );
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Dodano 6 przykladowych ocen');
END;
/

-- ============================================================================
-- PODSUMOWANIE DANYCH TESTOWYCH
-- ============================================================================
/*
Dane testowe obejmuja:

1. INSTRUMENTY (10):
   - klawiszowe: Fortepian
   - strunowe: Gitara klasyczna, Gitara elektryczna, Skrzypce, Wiolonczela
   - dete: Flet, Klarnet, Trabka, Saksofon
   - perkusyjne: Perkusja

2. SALE (5):
   - 2 sale z fortepianem (A1, A2)
   - 2 sale ogolne (B1, B2)
   - 1 sala z perkusja (C1)

3. NAUCZYCIELE (5):
   - Jan Kowalski: Fortepian, Skrzypce
   - Anna Nowak: Gitara klasyczna, Gitara elektryczna
   - Piotr Wisniewski: Flet, Klarnet, Saksofon
   - Maria Dabrowska: Perkusja, Trabka
   - Tomasz Lewandowski: Wiolonczela, Fortepian

4. UCZNIOWIE (10):
   - 4 dzieci (9-13 lat) - ograniczenie 14:00-19:00
   - 2 mlodziez (16-17 lat)
   - 4 dorosli (25-50 lat)

5. KURSY (10):
   - 3 fortepianowe (poczatkujacy, sredni, zaawansowany)
   - 2 gitarowe
   - 2 skrzypcowe
   - 2 dete
   - 1 perkusyjny

6. LEKCJE (3):
   - Przykladowe lekcje na najblizszy poniedzialek

7. OCENY (6):
   - Po 3 oceny dla 2 uczniow
*/
