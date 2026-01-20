-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 05_dane.sql
-- Opis: Dane testowe
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

SET SERVEROUTPUT ON;

-- ============================================================================
-- 1. INSTRUMENTY (6 rekordow)
-- ============================================================================
PROMPT Wstawianie instrumentow...

INSERT INTO t_instrument VALUES (
    t_instrument_obj(seq_instrument.NEXTVAL, 'Fortepian', 'klawiszowe'));
INSERT INTO t_instrument VALUES (
    t_instrument_obj(seq_instrument.NEXTVAL, 'Gitara klasyczna', 'strunowe'));
INSERT INTO t_instrument VALUES (
    t_instrument_obj(seq_instrument.NEXTVAL, 'Skrzypce', 'strunowe'));
INSERT INTO t_instrument VALUES (
    t_instrument_obj(seq_instrument.NEXTVAL, 'Flet poprzeczny', 'dety'));
INSERT INTO t_instrument VALUES (
    t_instrument_obj(seq_instrument.NEXTVAL, 'Perkusja', 'perkusyjne'));
INSERT INTO t_instrument VALUES (
    t_instrument_obj(seq_instrument.NEXTVAL, 'Saksofon', 'dety'));

COMMIT;
PROMPT Dodano 6 instrumentow.

-- ============================================================================
-- 2. NAUCZYCIELE (4 rekordy)
-- ============================================================================
PROMPT Wstawianie nauczycieli...

-- Nauczyciel 1: Adam Kowalski - uczy fortepianu i gitary
INSERT INTO t_nauczyciel VALUES (
    t_nauczyciel_obj(
        seq_nauczyciel.NEXTVAL,
        'Adam',
        'Kowalski',
        'a.kowalski@szkolamuzyczna.pl',
        '500100200',
        DATE '2015-09-01',
        t_lista_instrumentow('Fortepian', 'Gitara klasyczna')
    )
);

-- Nauczyciel 2: Maria Nowak - uczy skrzypiec
INSERT INTO t_nauczyciel VALUES (
    t_nauczyciel_obj(
        seq_nauczyciel.NEXTVAL,
        'Maria',
        'Nowak',
        'm.nowak@szkolamuzyczna.pl',
        '500200300',
        DATE '2010-03-15',
        t_lista_instrumentow('Skrzypce')
    )
);

-- Nauczyciel 3: Jan Wisniewski - uczy detow
INSERT INTO t_nauczyciel VALUES (
    t_nauczyciel_obj(
        seq_nauczyciel.NEXTVAL,
        'Jan',
        'Wisniewski',
        'j.wisniewski@szkolamuzyczna.pl',
        '500300400',
        DATE '2020-01-10',
        t_lista_instrumentow('Flet poprzeczny', 'Saksofon')
    )
);

-- Nauczyciel 4: Anna Lewandowska - uczy perkusji i fortepianu
INSERT INTO t_nauczyciel VALUES (
    t_nauczyciel_obj(
        seq_nauczyciel.NEXTVAL,
        'Anna',
        'Lewandowska',
        'a.lewandowska@szkolamuzyczna.pl',
        '500400500',
        DATE '2018-06-01',
        t_lista_instrumentow('Perkusja', 'Fortepian')
    )
);

COMMIT;
PROMPT Dodano 4 nauczycieli.

-- ============================================================================
-- 3. UCZNIOWIE (6 rekordow)
-- ============================================================================
PROMPT Wstawianie uczniow...

INSERT INTO t_uczen VALUES (
    t_uczen_obj(
        seq_uczen.NEXTVAL,
        'Piotr',
        'Zielinski',
        DATE '2010-05-15',
        'p.zielinski@gmail.com',
        '600111222',
        DATE '2023-09-01'
    )
);

INSERT INTO t_uczen VALUES (
    t_uczen_obj(
        seq_uczen.NEXTVAL,
        'Katarzyna',
        'Wojcik',
        DATE '2008-08-22',
        'k.wojcik@gmail.com',
        '600222333',
        DATE '2022-09-01'
    )
);

INSERT INTO t_uczen VALUES (
    t_uczen_obj(
        seq_uczen.NEXTVAL,
        'Michal',
        'Kaminski',
        DATE '2012-02-10',
        'm.kaminski@gmail.com',
        '600333444',
        DATE '2024-01-15'
    )
);

INSERT INTO t_uczen VALUES (
    t_uczen_obj(
        seq_uczen.NEXTVAL,
        'Aleksandra',
        'Dabrowska',
        DATE '2006-11-30',
        'a.dabrowska@gmail.com',
        '600444555',
        DATE '2021-09-01'
    )
);

INSERT INTO t_uczen VALUES (
    t_uczen_obj(
        seq_uczen.NEXTVAL,
        'Tomasz',
        'Szymanski',
        DATE '2015-07-08',
        't.szymanski@gmail.com',
        '600555666',
        DATE '2024-03-01'
    )
);

INSERT INTO t_uczen VALUES (
    t_uczen_obj(
        seq_uczen.NEXTVAL,
        'Emilia',
        'Kozlowska',
        DATE '2009-04-25',
        'e.kozlowska@gmail.com',
        '600666777',
        DATE '2023-01-15'
    )
);

COMMIT;
PROMPT Dodano 6 uczniow.

-- ============================================================================
-- 4. KURSY (6 rekordow)
-- ============================================================================
PROMPT Wstawianie kursow...

-- Pobieramy referencje do instrumentow
DECLARE
    v_ref_fortepian REF t_instrument_obj;
    v_ref_gitara    REF t_instrument_obj;
    v_ref_skrzypce  REF t_instrument_obj;
    v_ref_flet      REF t_instrument_obj;
    v_ref_perkusja  REF t_instrument_obj;
BEGIN
    SELECT REF(i) INTO v_ref_fortepian FROM t_instrument i WHERE i.nazwa = 'Fortepian';
    SELECT REF(i) INTO v_ref_gitara FROM t_instrument i WHERE i.nazwa = 'Gitara klasyczna';
    SELECT REF(i) INTO v_ref_skrzypce FROM t_instrument i WHERE i.nazwa = 'Skrzypce';
    SELECT REF(i) INTO v_ref_flet FROM t_instrument i WHERE i.nazwa = 'Flet poprzeczny';
    SELECT REF(i) INTO v_ref_perkusja FROM t_instrument i WHERE i.nazwa = 'Perkusja';
    
    -- Kursy fortepianu
    INSERT INTO t_kurs VALUES (
        t_kurs_obj(seq_kurs.NEXTVAL, 'Fortepian - Poczatki', 'poczatkujacy', 80.00, v_ref_fortepian));
    INSERT INTO t_kurs VALUES (
        t_kurs_obj(seq_kurs.NEXTVAL, 'Fortepian - Sredni', 'sredni', 100.00, v_ref_fortepian));
    
    -- Kurs gitary
    INSERT INTO t_kurs VALUES (
        t_kurs_obj(seq_kurs.NEXTVAL, 'Gitara klasyczna - Poczatki', 'poczatkujacy', 70.00, v_ref_gitara));
    
    -- Kurs skrzypiec
    INSERT INTO t_kurs VALUES (
        t_kurs_obj(seq_kurs.NEXTVAL, 'Skrzypce - Zaawansowany', 'zaawansowany', 120.00, v_ref_skrzypce));
    
    -- Kurs fletu
    INSERT INTO t_kurs VALUES (
        t_kurs_obj(seq_kurs.NEXTVAL, 'Flet - Sredni', 'sredni', 90.00, v_ref_flet));
    
    -- Kurs perkusji
    INSERT INTO t_kurs VALUES (
        t_kurs_obj(seq_kurs.NEXTVAL, 'Perkusja - Poczatki', 'poczatkujacy', 85.00, v_ref_perkusja));
    
    COMMIT;
END;
/

PROMPT Dodano 6 kursow.

-- ============================================================================
-- 5. LEKCJE (8 rekordow)
-- ============================================================================
PROMPT Wstawianie lekcji...

DECLARE
    v_ref_uczen1 REF t_uczen_obj;
    v_ref_uczen2 REF t_uczen_obj;
    v_ref_uczen3 REF t_uczen_obj;
    v_ref_uczen4 REF t_uczen_obj;
    v_ref_naucz1 REF t_nauczyciel_obj;
    v_ref_naucz2 REF t_nauczyciel_obj;
    v_ref_naucz3 REF t_nauczyciel_obj;
    v_ref_kurs1  REF t_kurs_obj;
    v_ref_kurs2  REF t_kurs_obj;
    v_ref_kurs3  REF t_kurs_obj;
    v_ref_kurs4  REF t_kurs_obj;
    v_data_start DATE := TRUNC(SYSDATE) + 7; -- za tydzien
BEGIN
    -- Pobieramy referencje
    SELECT REF(u) INTO v_ref_uczen1 FROM t_uczen u WHERE u.id_ucznia = 1;
    SELECT REF(u) INTO v_ref_uczen2 FROM t_uczen u WHERE u.id_ucznia = 2;
    SELECT REF(u) INTO v_ref_uczen3 FROM t_uczen u WHERE u.id_ucznia = 3;
    SELECT REF(u) INTO v_ref_uczen4 FROM t_uczen u WHERE u.id_ucznia = 4;
    
    SELECT REF(n) INTO v_ref_naucz1 FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    SELECT REF(n) INTO v_ref_naucz2 FROM t_nauczyciel n WHERE n.id_nauczyciela = 2;
    SELECT REF(n) INTO v_ref_naucz3 FROM t_nauczyciel n WHERE n.id_nauczyciela = 3;
    
    SELECT REF(k) INTO v_ref_kurs1 FROM t_kurs k WHERE k.id_kursu = 1;
    SELECT REF(k) INTO v_ref_kurs2 FROM t_kurs k WHERE k.id_kursu = 2;
    SELECT REF(k) INTO v_ref_kurs3 FROM t_kurs k WHERE k.id_kursu = 3;
    SELECT REF(k) INTO v_ref_kurs4 FROM t_kurs k WHERE k.id_kursu = 4;
    
    -- Lekcje zaplanowane (na przyszly tydzien)
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(seq_lekcja.NEXTVAL, v_data_start, '10:00', 45, NULL, NULL, 
                     'zaplanowana', v_ref_uczen1, v_ref_naucz1, v_ref_kurs1));
    
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(seq_lekcja.NEXTVAL, v_data_start, '11:00', 45, NULL, NULL, 
                     'zaplanowana', v_ref_uczen2, v_ref_naucz1, v_ref_kurs2));
    
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(seq_lekcja.NEXTVAL, v_data_start + 1, '14:00', 60, NULL, NULL, 
                     'zaplanowana', v_ref_uczen3, v_ref_naucz2, v_ref_kurs4));
    
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(seq_lekcja.NEXTVAL, v_data_start + 1, '15:00', 45, NULL, NULL, 
                     'zaplanowana', v_ref_uczen4, v_ref_naucz3, v_ref_kurs3));
    
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(seq_lekcja.NEXTVAL, v_data_start + 2, '09:00', 45, NULL, NULL, 
                     'zaplanowana', v_ref_uczen1, v_ref_naucz1, v_ref_kurs1));
    
    -- Lekcja odwolana
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(seq_lekcja.NEXTVAL, v_data_start + 2, '16:00', 45, NULL, 
                     'Choroba ucznia', 'odwolana', v_ref_uczen2, v_ref_naucz2, v_ref_kurs4));
    
    COMMIT;
END;
/

-- Lekcje historyczne (odbyte) - wstawiamy bez triggera walidujacego date
DECLARE
    v_ref_uczen1 REF t_uczen_obj;
    v_ref_uczen2 REF t_uczen_obj;
    v_ref_naucz1 REF t_nauczyciel_obj;
    v_ref_kurs1  REF t_kurs_obj;
BEGIN
    SELECT REF(u) INTO v_ref_uczen1 FROM t_uczen u WHERE u.id_ucznia = 1;
    SELECT REF(u) INTO v_ref_uczen2 FROM t_uczen u WHERE u.id_ucznia = 2;
    SELECT REF(n) INTO v_ref_naucz1 FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    SELECT REF(k) INTO v_ref_kurs1 FROM t_kurs k WHERE k.id_kursu = 1;
    
    -- Wylaczamy trigger tymczasowo
    EXECUTE IMMEDIATE 'ALTER TRIGGER trg_lekcja_walidacja DISABLE';
    
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(seq_lekcja.NEXTVAL, DATE '2025-12-10', '10:00', 45, 
                     'Podstawy gamy C-dur', 'Uczen robi postepy', 
                     'odbyta', v_ref_uczen1, v_ref_naucz1, v_ref_kurs1));
    
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(seq_lekcja.NEXTVAL, DATE '2025-12-17', '10:00', 45, 
                     'Cwiczenia reki prawej', 'Wymaga poprawy techniki', 
                     'odbyta', v_ref_uczen1, v_ref_naucz1, v_ref_kurs1));
    
    EXECUTE IMMEDIATE 'ALTER TRIGGER trg_lekcja_walidacja ENABLE';
    
    COMMIT;
END;
/

PROMPT Dodano 8 lekcji.

-- ============================================================================
-- 6. OCENY POSTEPU (12 rekordow)
-- ============================================================================
PROMPT Wstawianie ocen...

DECLARE
    v_ref_uczen1 REF t_uczen_obj;
    v_ref_uczen2 REF t_uczen_obj;
    v_ref_uczen3 REF t_uczen_obj;
    v_ref_uczen4 REF t_uczen_obj;
    v_ref_naucz1 REF t_nauczyciel_obj;
    v_ref_naucz2 REF t_nauczyciel_obj;
BEGIN
    SELECT REF(u) INTO v_ref_uczen1 FROM t_uczen u WHERE u.id_ucznia = 1;
    SELECT REF(u) INTO v_ref_uczen2 FROM t_uczen u WHERE u.id_ucznia = 2;
    SELECT REF(u) INTO v_ref_uczen3 FROM t_uczen u WHERE u.id_ucznia = 3;
    SELECT REF(u) INTO v_ref_uczen4 FROM t_uczen u WHERE u.id_ucznia = 4;
    SELECT REF(n) INTO v_ref_naucz1 FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    SELECT REF(n) INTO v_ref_naucz2 FROM t_nauczyciel n WHERE n.id_nauczyciela = 2;
    
    -- Oceny ucznia 1 (Piotr)
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, DATE '2025-10-15', 4, 
                    'Dobra postawa przy instrumencie', 'technika', v_ref_uczen1, v_ref_naucz1));
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, DATE '2025-11-10', 5, 
                    'Bardzo dobra znajomosc gam', 'teoria', v_ref_uczen1, v_ref_naucz1));
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, DATE '2025-12-05', 4, 
                    'Poprawny sluch muzyczny', 'sluch', v_ref_uczen1, v_ref_naucz1));
    
    -- Oceny ucznia 2 (Katarzyna)
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, DATE '2025-09-20', 5, 
                    'Swietna interpretacja Chopina', 'interpretacja', v_ref_uczen2, v_ref_naucz1));
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, DATE '2025-10-25', 6, 
                    'Wybitna technika', 'technika', v_ref_uczen2, v_ref_naucz1));
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, DATE '2025-11-30', 5, 
                    'Bardzo dobre poczucie rytmu', 'rytm', v_ref_uczen2, v_ref_naucz1));
    
    -- Oceny ucznia 3 (Michal)
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, DATE '2025-11-05', 3, 
                    'Wymaga poprawy', 'technika', v_ref_uczen3, v_ref_naucz2));
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, DATE '2025-12-01', 4, 
                    'Postep widoczny', 'teoria', v_ref_uczen3, v_ref_naucz2));
    
    -- Oceny ucznia 4 (Aleksandra)
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, DATE '2025-09-15', 5, 
                    'Bardzo dobra', 'sluch', v_ref_uczen4, v_ref_naucz2));
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, DATE '2025-10-20', 5, 
                    'Postepy w interpretacji', 'interpretacja', v_ref_uczen4, v_ref_naucz2));
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, DATE '2025-11-25', 6, 
                    'Wzorowa technika', 'technika', v_ref_uczen4, v_ref_naucz2));
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(seq_ocena.NEXTVAL, DATE '2025-12-10', 5, 
                    'Bardzo dobre poczucie rytmu', 'rytm', v_ref_uczen4, v_ref_naucz2));
    
    COMMIT;
END;
/

PROMPT Dodano 12 ocen.

-- ============================================================================
-- PODSUMOWANIE DANYCH TESTOWYCH
-- ============================================================================
PROMPT ;
PROMPT ========================================;
PROMPT PODSUMOWANIE DANYCH TESTOWYCH;
PROMPT ========================================;

SELECT 'Instrumenty' AS tabela, COUNT(*) AS ilosc FROM t_instrument
UNION ALL
SELECT 'Nauczyciele', COUNT(*) FROM t_nauczyciel
UNION ALL
SELECT 'Uczniowie', COUNT(*) FROM t_uczen
UNION ALL
SELECT 'Kursy', COUNT(*) FROM t_kurs
UNION ALL
SELECT 'Lekcje', COUNT(*) FROM t_lekcja
UNION ALL
SELECT 'Oceny', COUNT(*) FROM t_ocena_postepu;

PROMPT ========================================;
PROMPT Dane testowe wstawione pomyslnie!;
PROMPT ========================================;
