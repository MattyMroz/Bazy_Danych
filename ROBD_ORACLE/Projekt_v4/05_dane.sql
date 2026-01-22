-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 05_dane.sql
-- Opis: Dane testowe
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
-- 2. SALE (5 sal z roznym wyposazeniem)
-- ============================================================================
INSERT INTO t_sala VALUES (t_sala_obj(seq_sala.NEXTVAL, 'Sala A1', 1, 'T', 'N'));
INSERT INTO t_sala VALUES (t_sala_obj(seq_sala.NEXTVAL, 'Sala A2', 1, 'T', 'N'));
INSERT INTO t_sala VALUES (t_sala_obj(seq_sala.NEXTVAL, 'Sala B1', 2, 'N', 'N'));
INSERT INTO t_sala VALUES (t_sala_obj(seq_sala.NEXTVAL, 'Sala B2', 3, 'N', 'N'));
INSERT INTO t_sala VALUES (t_sala_obj(seq_sala.NEXTVAL, 'Sala C1', 1, 'N', 'T'));

COMMIT;

-- ============================================================================
-- 3. NAUCZYCIELE (5 nauczycieli z VARRAY instrumentow)
-- ============================================================================

-- Jan Kowalski - Fortepian, Skrzypce
INSERT INTO t_nauczyciel VALUES (
    t_nauczyciel_obj(
        seq_nauczyciel.NEXTVAL,
        'Jan',
        'Kowalski',
        'j.kowalski@szkolamuzyczna.pl',
        '601-111-111',
        DATE '2018-09-01',
        t_lista_instrumentow('Fortepian', 'Skrzypce')
    )
);

-- Anna Nowak - Gitara klasyczna, Gitara elektryczna
INSERT INTO t_nauczyciel VALUES (
    t_nauczyciel_obj(
        seq_nauczyciel.NEXTVAL,
        'Anna',
        'Nowak',
        'a.nowak@szkolamuzyczna.pl',
        '602-222-222',
        DATE '2019-03-15',
        t_lista_instrumentow('Gitara klasyczna', 'Gitara elektryczna')
    )
);

-- Piotr Wisniewski - Flet, Klarnet, Saksofon
INSERT INTO t_nauczyciel VALUES (
    t_nauczyciel_obj(
        seq_nauczyciel.NEXTVAL,
        'Piotr',
        'Wisniewski',
        'p.wisniewski@szkolamuzyczna.pl',
        '603-333-333',
        DATE '2020-01-10',
        t_lista_instrumentow('Flet', 'Klarnet', 'Saksofon')
    )
);

-- Maria Dabrowska - Perkusja, Trabka
INSERT INTO t_nauczyciel VALUES (
    t_nauczyciel_obj(
        seq_nauczyciel.NEXTVAL,
        'Maria',
        'Dabrowska',
        'm.dabrowska@szkolamuzyczna.pl',
        '604-444-444',
        DATE '2021-09-01',
        t_lista_instrumentow('Perkusja', 'Trabka')
    )
);

-- Tomasz Lewandowski - Wiolonczela, Fortepian
INSERT INTO t_nauczyciel VALUES (
    t_nauczyciel_obj(
        seq_nauczyciel.NEXTVAL,
        'Tomasz',
        'Lewandowski',
        't.lewandowski@szkolamuzyczna.pl',
        '605-555-555',
        DATE '2022-02-01',
        t_lista_instrumentow('Wiolonczela', 'Fortepian')
    )
);

COMMIT;

-- ============================================================================
-- 4. UCZNIOWIE (10 uczniow - dzieci i dorosli)
-- ============================================================================

-- Dzieci (ponizej 15 lat) - lekcje tylko 14:00-19:00
INSERT INTO t_uczen VALUES (
    t_uczen_obj(seq_uczen.NEXTVAL, 'Kacper', 'Malinowski', DATE '2015-05-12', 'kacper.m@email.pl', SYSDATE)
);

INSERT INTO t_uczen VALUES (
    t_uczen_obj(seq_uczen.NEXTVAL, 'Zofia', 'Wojcik', DATE '2013-08-23', 'zofia.w@email.pl', SYSDATE)
);

INSERT INTO t_uczen VALUES (
    t_uczen_obj(seq_uczen.NEXTVAL, 'Jakub', 'Kaminski', DATE '2012-01-15', NULL, SYSDATE)
);

INSERT INTO t_uczen VALUES (
    t_uczen_obj(seq_uczen.NEXTVAL, 'Maja', 'Zielinska', DATE '2011-11-30', 'maja.z@email.pl', SYSDATE)
);

-- Mlodziez (15-17 lat) - bez ograniczen godzinowych
INSERT INTO t_uczen VALUES (
    t_uczen_obj(seq_uczen.NEXTVAL, 'Adam', 'Szymanski', DATE '2008-04-05', 'adam.sz@email.pl', SYSDATE)
);

INSERT INTO t_uczen VALUES (
    t_uczen_obj(seq_uczen.NEXTVAL, 'Natalia', 'Wozniak', DATE '2009-07-18', 'natalia.w@email.pl', SYSDATE)
);

-- Dorosli (18+ lat)
INSERT INTO t_uczen VALUES (
    t_uczen_obj(seq_uczen.NEXTVAL, 'Michal', 'Kozlowski', DATE '2000-02-28', 'michal.k@email.pl', SYSDATE)
);

INSERT INTO t_uczen VALUES (
    t_uczen_obj(seq_uczen.NEXTVAL, 'Karolina', 'Jankowska', DATE '1995-12-10', 'karolina.j@email.pl', SYSDATE)
);

INSERT INTO t_uczen VALUES (
    t_uczen_obj(seq_uczen.NEXTVAL, 'Rafal', 'Wrobel', DATE '1988-06-20', 'rafal.w@email.pl', SYSDATE)
);

INSERT INTO t_uczen VALUES (
    t_uczen_obj(seq_uczen.NEXTVAL, 'Ewa', 'Olszewska', DATE '1975-03-08', 'ewa.o@email.pl', SYSDATE)
);

COMMIT;

-- ============================================================================
-- 5. KURSY (10 kursow z REF do instrumentow)
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
    
    -- Kursy fortepianowe (3 poziomy)
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
-- 6. PRZYKLADOWE LEKCJE (uzywamy pkg_lekcja.zaplanuj)
-- ============================================================================
DECLARE
    v_data DATE;
    v_id_kacper     t_uczen.id_ucznia%TYPE;
    v_id_adam       t_uczen.id_ucznia%TYPE;
    v_id_michal     t_uczen.id_ucznia%TYPE;
    v_id_jan        t_nauczyciel.id_nauczyciela%TYPE;
    v_id_anna       t_nauczyciel.id_nauczyciela%TYPE;
    v_id_kurs_fort  t_kurs.id_kursu%TYPE;
    v_id_kurs_git   t_kurs.id_kursu%TYPE;
    v_id_sala1      t_sala.id_sali%TYPE;
    v_id_sala2      t_sala.id_sali%TYPE;
    v_id_sala3      t_sala.id_sali%TYPE;
BEGIN
    -- Znajdz najblizszy poniedzialek
    v_data := TRUNC(SYSDATE, 'IW') + 7;

    -- Pobranie ID na podstawie nazw/nazwisk
    SELECT id_ucznia INTO v_id_kacper FROM t_uczen WHERE nazwisko = 'Malinowski' AND ROWNUM = 1;
    SELECT id_ucznia INTO v_id_adam FROM t_uczen WHERE nazwisko = 'Szymanski' AND ROWNUM = 1;
    SELECT id_ucznia INTO v_id_michal FROM t_uczen WHERE nazwisko = 'Kozlowski' AND ROWNUM = 1;
    SELECT id_nauczyciela INTO v_id_jan FROM t_nauczyciel WHERE nazwisko = 'Kowalski' AND ROWNUM = 1;
    SELECT id_nauczyciela INTO v_id_anna FROM t_nauczyciel WHERE nazwisko = 'Nowak' AND ROWNUM = 1;
    SELECT id_kursu INTO v_id_kurs_fort FROM t_kurs WHERE nazwa = 'Fortepian - podstawy' AND ROWNUM = 1;
    SELECT id_kursu INTO v_id_kurs_git FROM t_kurs WHERE nazwa = 'Gitara klasyczna - podstawy' AND ROWNUM = 1;
    SELECT id_sali INTO v_id_sala1 FROM t_sala WHERE nazwa = 'Sala A1' AND ROWNUM = 1;
    SELECT id_sali INTO v_id_sala2 FROM t_sala WHERE nazwa = 'Sala A2' AND ROWNUM = 1;
    SELECT id_sali INTO v_id_sala3 FROM t_sala WHERE nazwa = 'Sala B1' AND ROWNUM = 1;
    
    -- Lekcja 1: dziecko (Kacper) o 14:00 - dozwolona godzina dla dzieci
    pkg_lekcja.zaplanuj(
        p_id_ucznia     => v_id_kacper,
        p_id_nauczyciela => v_id_jan,
        p_id_kursu      => v_id_kurs_fort,
        p_id_sali       => v_id_sala1,
        p_data          => v_data,
        p_godzina       => '14:00',
        p_czas_trwania  => 45
    );
    
    -- Lekcja 2: mlodziez (Adam) o 10:00
    pkg_lekcja.zaplanuj(
        p_id_ucznia     => v_id_adam,
        p_id_nauczyciela => v_id_anna,
        p_id_kursu      => v_id_kurs_git,
        p_id_sali       => v_id_sala3,
        p_data          => v_data,
        p_godzina       => '10:00',
        p_czas_trwania  => 45
    );
    
    -- Lekcja 3: dorosly (Michal) o 08:00
    pkg_lekcja.zaplanuj(
        p_id_ucznia     => v_id_michal,
        p_id_nauczyciela => v_id_jan,
        p_id_kursu      => v_id_kurs_fort,
        p_id_sali       => v_id_sala2,
        p_data          => v_data,
        p_godzina       => '08:00',
        p_czas_trwania  => 60
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Dodano 3 przykladowe lekcje na: ' || TO_CHAR(v_data, 'YYYY-MM-DD'));
END;
/

-- ============================================================================
-- 7. PRZYKLADOWE OCENY
-- ============================================================================
DECLARE
    v_ref_uczen_kacper REF t_uczen_obj;
    v_ref_uczen_adam   REF t_uczen_obj;
    v_ref_naucz_jan    REF t_nauczyciel_obj;
    v_ref_naucz_anna   REF t_nauczyciel_obj;
BEGIN
    SELECT REF(u) INTO v_ref_uczen_kacper FROM t_uczen u WHERE u.nazwisko = 'Malinowski' AND ROWNUM = 1;
    SELECT REF(u) INTO v_ref_uczen_adam FROM t_uczen u WHERE u.nazwisko = 'Szymanski' AND ROWNUM = 1;
    SELECT REF(n) INTO v_ref_naucz_jan FROM t_nauczyciel n WHERE n.nazwisko = 'Kowalski' AND ROWNUM = 1;
    SELECT REF(n) INTO v_ref_naucz_anna FROM t_nauczyciel n WHERE n.nazwisko = 'Nowak' AND ROWNUM = 1;
    
    -- Oceny dla ucznia Kacper Malinowski
    INSERT INTO t_ocena VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, SYSDATE - 30, 4, 'technika', 'Dobra postawa', v_ref_uczen_kacper, v_ref_naucz_jan)
    );
    INSERT INTO t_ocena VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, SYSDATE - 15, 5, 'rytm', 'Swietne wyczucie', v_ref_uczen_kacper, v_ref_naucz_jan)
    );
    INSERT INTO t_ocena VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, SYSDATE - 7, 4, 'teoria', NULL, v_ref_uczen_kacper, v_ref_naucz_jan)
    );
    
    -- Oceny dla ucznia Adam Szymanski
    INSERT INTO t_ocena VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, SYSDATE - 20, 3, 'technika', 'Do poprawy chwyty', v_ref_uczen_adam, v_ref_naucz_anna)
    );
    INSERT INTO t_ocena VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, SYSDATE - 10, 4, 'technika', 'Widac postep', v_ref_uczen_adam, v_ref_naucz_anna)
    );
    INSERT INTO t_ocena VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, SYSDATE - 5, 5, 'interpretacja', 'Bardzo dobra ekspresja', v_ref_uczen_adam, v_ref_naucz_anna)
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Dodano 6 przykladowych ocen');
END;
/

-- ============================================================================
-- PODSUMOWANIE DANYCH TESTOWYCH
-- ============================================================================
-- 1. Instrumenty: 10 (rozne kategorie)
-- 2. Sale: 5 (z fortepianem, perkusja, ogolne)
-- 3. Nauczyciele: 5 (z VARRAY instrumentow)
-- 4. Uczniowie: 10 (4 dzieci, 2 mlodziez, 4 dorosli)
-- 5. Kursy: 10 (z REF do instrumentow)
-- 6. Lekcje: 3 (przez pkg_lekcja.zaplanuj)
-- 7. Oceny: 6
-- ============================================================================
