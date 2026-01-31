-- ============================================================================
-- PLIK: 05_dane.sql
-- PROJEKT: Szkoła Muzyczna v5 - Obiektowa Baza Danych Oracle
-- AUTORZY: Igor Typiński (251237), Mateusz Mróz (251190)
-- DATA: Styczeń 2026
-- ============================================================================
--
-- CO TEN PLIK ROBI?
-- -----------------
-- Wstawia przykładowe dane testowe do wszystkich tabel.
-- Dane są zaprojektowane z "dziurami" - wolnymi slotami czasowymi,
-- które pozwalają na demonstrację zarówno pozytywnych jak i negatywnych
-- scenariuszy testowych.
--
-- STRATEGIA "DZIUR":
-- ==================
-- 
-- Dane NIE wypełniają całkowicie planu. Zostawiamy:
--   - Wolne sloty czasowe w salach
--   - Wolne godziny nauczycieli
--   - Możliwość dodania nowych lekcji (test pozytywny)
--   - Możliwość wykrycia konfliktów (test negatywny)
--
-- STRUKTURA DANYCH:
-- =================
-- 
--   SEMESTR:    1 semestr (zimowy 2025/26)
--   INSTRUMENTY: 6 instrumentów (fortepian, skrzypce, gitara, ...)
--   SALE:        5 sal (3 indywidualne, 1 grupowa, 1 wielofunkcyjna)
--   NAUCZYCIELE: 4 nauczycieli (różne instrumenty, różne obciążenie)
--   GRUPY:       2 grupy (rytmika, teoria muzyki)
--   UCZNIOWIE:   6 uczniów (różne typy, różne klasy)
--   PRZEDMIOTY:  5 przedmiotów (instr. główny, teoria, rytmika, ...)
--   LEKCJE:      ~10 lekcji (z wolnymi slotami)
--   EGZAMINY:    2 egzaminy
--   OCENY:       ~10 ocen
--
-- JAK URUCHOMIĆ?
-- --------------
-- WYMAGANIE: Najpierw 01_typy.sql, 02_tabele.sql, 03_triggery.sql, 04_pakiety.sql
-- @05_dane.sql
--
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200

PROMPT ╔═══════════════════════════════════════════════════════════════╗
PROMPT ║  05_dane.sql - Wstawianie danych testowych                    ║
PROMPT ╚═══════════════════════════════════════════════════════════════╝
PROMPT

-- ============================================================================
-- CZYSZCZENIE STARYCH DANYCH (jeśli istnieją)
-- ============================================================================
-- Kolejność: od tabel z REF-ami do tabel bazowych (odwrotnie niż tworzenie)
-- ============================================================================

PROMPT [0/10] Czyszczenie starych danych...

BEGIN
    -- Tabele z REF-ami (najpierw!)
    EXECUTE IMMEDIATE 'DELETE FROM t_ocena';
    EXECUTE IMMEDIATE 'DELETE FROM t_egzamin';
    EXECUTE IMMEDIATE 'DELETE FROM t_lekcja';
    EXECUTE IMMEDIATE 'DELETE FROM t_przedmiot';
    EXECUTE IMMEDIATE 'DELETE FROM t_uczen';
    EXECUTE IMMEDIATE 'DELETE FROM t_grupa';
    EXECUTE IMMEDIATE 'DELETE FROM t_nauczyciel';
    EXECUTE IMMEDIATE 'DELETE FROM t_sala';
    EXECUTE IMMEDIATE 'DELETE FROM t_instrument';
    EXECUTE IMMEDIATE 'DELETE FROM t_semestr';
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('   Stare dane usunięte.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('   Brak starych danych do usunięcia.');
END;
/

-- ============================================================================
-- 1. SEMESTR
-- ============================================================================
-- Definiuje ramy czasowe dla wszystkich danych.
-- Używamy semestru zimowego 2025/26 (aktualny).
-- ============================================================================

PROMPT [1/10] Wstawianie semestru...

INSERT INTO t_semestr VALUES (
    t_semestr_obj(
        seq_semestr.NEXTVAL,        -- id_semestru (1)
        'zimowy',                   -- nazwa_semestru
        '2025/26',                  -- rok_akademicki
        DATE '2025-10-01',          -- data_rozpoczecia
        DATE '2026-01-31'           -- data_zakonczenia
    )
);

COMMIT;

-- Zapamiętaj ID semestru (pomocnicze)
-- W Oracle możemy użyć zmiennej bind lub pobrać z tabeli
DECLARE
    v_ref_semestr REF t_semestr_obj;
BEGIN
    SELECT REF(s) INTO v_ref_semestr 
    FROM t_semestr s 
    WHERE s.rok_akademicki = '2025/26' AND s.nazwa_semestru = 'zimowy';
    
    DBMS_OUTPUT.PUT_LINE('   Semestr: zimowy 2025/26 (01.10.2025 - 31.01.2026)');
END;
/

-- ============================================================================
-- 2. INSTRUMENTY
-- ============================================================================
-- Lista instrumentów oferowanych przez szkołę.
-- Różne rodzaje i poziomy trudności.
-- ============================================================================

PROMPT [2/10] Wstawianie instrumentów...

INSERT ALL
    INTO t_instrument VALUES (t_instrument_obj(seq_instrument.NEXTVAL, 'fortepian', 'klawiszowy'))
    INTO t_instrument VALUES (t_instrument_obj(seq_instrument.NEXTVAL, 'skrzypce', 'smyczkowy'))
    INTO t_instrument VALUES (t_instrument_obj(seq_instrument.NEXTVAL, 'gitara', 'szarpany'))
    INTO t_instrument VALUES (t_instrument_obj(seq_instrument.NEXTVAL, 'flet', 'dęty'))
    INTO t_instrument VALUES (t_instrument_obj(seq_instrument.NEXTVAL, 'klarnet', 'dęty'))
    INTO t_instrument VALUES (t_instrument_obj(seq_instrument.NEXTVAL, 'perkusja', 'perkusyjny'))
SELECT 1 FROM DUAL;

COMMIT;

DBMS_OUTPUT.PUT_LINE('   6 instrumentów: fortepian, skrzypce, gitara, flet, klarnet, perkusja');

-- ============================================================================
-- 3. SALE
-- ============================================================================
-- Różne typy sal z różnym wyposażeniem.
-- 
-- STRATEGIA DZIUR:
--   - Sala 101: główna sala fortepianowa (dużo lekcji)
--   - Sala 102: wolna sala skrzypcowa (miejsce na testy)
--   - Sala 103: gitara/flet
--   - Sala A1: grupowa (teoria, rytmika)
--   - Sala B1: wielofunkcyjna (egzaminy, koncerty)
-- ============================================================================

PROMPT [3/10] Wstawianie sal...

INSERT ALL
    -- Sale indywidualne
    INTO t_sala VALUES (t_sala_obj(
        seq_sala.NEXTVAL, '101', 'indywidualna', 3, 'dostepna',
        t_lista_sprzetu('fortepian Yamaha C3', 'metronom', 'lustro')
    ))
    INTO t_sala VALUES (t_sala_obj(
        seq_sala.NEXTVAL, '102', 'indywidualna', 2, 'dostepna',
        t_lista_sprzetu('pulpit', 'krzesło', 'metronom')
    ))
    INTO t_sala VALUES (t_sala_obj(
        seq_sala.NEXTVAL, '103', 'indywidualna', 3, 'dostepna',
        t_lista_sprzetu('gitara klasyczna', 'podnóżek', 'pulpit')
    ))
    -- Sala grupowa
    INTO t_sala VALUES (t_sala_obj(
        seq_sala.NEXTVAL, 'A1', 'grupowa', 20, 'dostepna',
        t_lista_sprzetu('tablica', 'projektor', 'pianino cyfrowe', 'krzesła 20szt')
    ))
    -- Sala wielofunkcyjna
    INTO t_sala VALUES (t_sala_obj(
        seq_sala.NEXTVAL, 'B1', 'wielofunkcyjna', 10, 'dostepna',
        t_lista_sprzetu('fortepian', 'nagłośnienie', 'mikrofony', 'krzesła składane')
    ))
SELECT 1 FROM DUAL;

COMMIT;

DBMS_OUTPUT.PUT_LINE('   5 sal: 101, 102, 103 (indywidualne), A1 (grupowa), B1 (wielofunkcyjna)');

-- ============================================================================
-- 4. NAUCZYCIELE
-- ============================================================================
-- Różni nauczyciele z różnymi instrumentami.
-- 
-- STRATEGIA:
--   - Kowalski: fortepian, dużo godzin (testowanie limitu)
--   - Nowak: skrzypce, mało godzin (możliwość dodawania)
--   - Wiśniewska: flet, klarnet (wieloinstrumentalista)
--   - Lewandowski: gitara, perkusja, teoria
-- ============================================================================

PROMPT [4/10] Wstawianie nauczycieli...

INSERT INTO t_nauczyciel VALUES (t_nauczyciel_obj(
    seq_nauczyciel.NEXTVAL,          -- id_nauczyciela (1)
    'Jan',                           -- imie
    'Kowalski',                      -- nazwisko
    'jan.kowalski@szkola.pl',        -- email
    DATE '2020-09-01',               -- data_zatrudnienia
    'aktywny',                       -- status
    t_lista_instrumentow('fortepian')  -- instrumenty (VARRAY)
));

INSERT INTO t_nauczyciel VALUES (t_nauczyciel_obj(
    seq_nauczyciel.NEXTVAL,          -- id_nauczyciela (2)
    'Anna',
    'Nowak',
    'anna.nowak@szkola.pl',
    DATE '2021-09-01',
    'aktywny',
    t_lista_instrumentow('skrzypce')
));

INSERT INTO t_nauczyciel VALUES (t_nauczyciel_obj(
    seq_nauczyciel.NEXTVAL,          -- id_nauczyciela (3)
    'Maria',
    'Wiśniewska',
    'maria.wisniewska@szkola.pl',
    DATE '2019-02-15',
    'aktywny',
    t_lista_instrumentow('flet', 'klarnet')  -- 2 instrumenty!
));

INSERT INTO t_nauczyciel VALUES (t_nauczyciel_obj(
    seq_nauczyciel.NEXTVAL,          -- id_nauczyciela (4)
    'Piotr',
    'Lewandowski',
    'piotr.lewandowski@szkola.pl',
    DATE '2022-09-01',
    'aktywny',
    t_lista_instrumentow('gitara', 'perkusja', 'teoria')  -- 3 instrumenty!
));

COMMIT;

DBMS_OUTPUT.PUT_LINE('   4 nauczycieli: Kowalski (fortepian), Nowak (skrzypce), ' ||
                     'Wiśniewska (flet/klarnet), Lewandowski (gitara/perkusja)');

-- ============================================================================
-- 5. GRUPY
-- ============================================================================
-- Grupy do zajęć zbiorowych.
-- ============================================================================

PROMPT [5/10] Wstawianie grup...

INSERT ALL
    INTO t_grupa VALUES (t_grupa_obj(
        seq_grupa.NEXTVAL, 'Rytmika I-II', 1, 2, 12
    ))
    INTO t_grupa VALUES (t_grupa_obj(
        seq_grupa.NEXTVAL, 'Teoria muzyki III-IV', 3, 4, 15
    ))
SELECT 1 FROM DUAL;

COMMIT;

DBMS_OUTPUT.PUT_LINE('   2 grupy: Rytmika I-II (12 osób), Teoria III-IV (15 osób)');

-- ============================================================================
-- 6. UCZNIOWIE
-- ============================================================================
-- Różni uczniowie z różnymi typami i klasami.
-- 
-- STRATEGIA TYPÓW:
--   'uczacy_sie_w_innej_szkole' - lekcje tylko od 15:00!
--   'ukonczyl_edukacje'         - lekcje od 14:00
--   'tylko_muzyczna'            - lekcje od 14:00
--
-- DZIURY: 
--   - Uczeń ID=3 ma mało lekcji (miejsce na testy konfliktów)
--   - Uczeń ID=6 jest nowy (brak historii)
-- ============================================================================

PROMPT [6/10] Wstawianie uczniów...

DECLARE
    -- REF-y do instrumentów
    v_ref_fortepian  REF t_instrument_obj;
    v_ref_skrzypce   REF t_instrument_obj;
    v_ref_gitara     REF t_instrument_obj;
    v_ref_flet       REF t_instrument_obj;
    v_ref_klarnet    REF t_instrument_obj;
    
    -- REF-y do nauczycieli
    v_ref_kowalski     REF t_nauczyciel_obj;  -- fortepian
    v_ref_nowak        REF t_nauczyciel_obj;  -- skrzypce
    v_ref_wisniewska   REF t_nauczyciel_obj;  -- flet, klarnet
    v_ref_lewandowski  REF t_nauczyciel_obj;  -- gitara
BEGIN
    -- Pobierz REF-y do instrumentów
    SELECT REF(i) INTO v_ref_fortepian FROM t_instrument i WHERE i.nazwa = 'fortepian';
    SELECT REF(i) INTO v_ref_skrzypce  FROM t_instrument i WHERE i.nazwa = 'skrzypce';
    SELECT REF(i) INTO v_ref_gitara    FROM t_instrument i WHERE i.nazwa = 'gitara';
    SELECT REF(i) INTO v_ref_flet      FROM t_instrument i WHERE i.nazwa = 'flet';
    SELECT REF(i) INTO v_ref_klarnet   FROM t_instrument i WHERE i.nazwa = 'klarnet';
    
    -- Pobierz REF-y do nauczycieli
    SELECT REF(n) INTO v_ref_kowalski    FROM t_nauczyciel n WHERE n.nazwisko = 'Kowalski';
    SELECT REF(n) INTO v_ref_nowak       FROM t_nauczyciel n WHERE n.nazwisko = 'Nowak';
    SELECT REF(n) INTO v_ref_wisniewska  FROM t_nauczyciel n WHERE n.nazwisko = 'Wiśniewska';
    SELECT REF(n) INTO v_ref_lewandowski FROM t_nauczyciel n WHERE n.nazwisko = 'Lewandowski';
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- UCZNIOWIE
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- Uczeń 1: Ala Malinowska, fortepian, klasa 3
    --          'uczacy_sie_w_innej_szkole' → lekcje od 15:00!
    INSERT INTO t_uczen VALUES (t_uczen_obj(
        seq_uczen.NEXTVAL,               -- id_ucznia (1)
        'Ala',
        'Malinowska',
        DATE '2014-03-15',               -- 11 lat
        'uczacy_sie_w_innej_szkole',     -- 🔴 lekcje od 15:00!
        DATE '2022-09-01',               -- data_zapisu
        3,                               -- klasa
        6,                               -- cykl
        'aktywny',
        v_ref_fortepian,
        v_ref_kowalski
    ));
    
    -- Uczeń 2: Bartek Nowakowski, skrzypce, klasa 2
    --          'uczacy_sie_w_innej_szkole' → lekcje od 15:00!
    INSERT INTO t_uczen VALUES (t_uczen_obj(
        seq_uczen.NEXTVAL,               -- id_ucznia (2)
        'Bartek',
        'Nowakowski',
        DATE '2015-07-22',               -- 10 lat
        'uczacy_sie_w_innej_szkole',
        DATE '2023-09-01',
        2,
        6,
        'aktywny',
        v_ref_skrzypce,
        v_ref_nowak
    ));
    
    -- Uczeń 3: Celina Kowalczyk, flet, klasa 1 (nowa)
    --          'uczacy_sie_w_innej_szkole' → lekcje od 15:00!
    --          DZIURA: mało lekcji, miejsce na testy!
    INSERT INTO t_uczen VALUES (t_uczen_obj(
        seq_uczen.NEXTVAL,               -- id_ucznia (3)
        'Celina',
        'Kowalczyk',
        DATE '2016-11-08',               -- 9 lat
        'uczacy_sie_w_innej_szkole',
        DATE '2025-09-01',               -- nowa!
        1,
        6,
        'aktywny',
        v_ref_flet,
        v_ref_wisniewska
    ));
    
    -- Uczeń 4: Damian Zieliński, gitara, klasa 4
    --          'ukonczyl_edukacje' (student) → lekcje od 14:00
    INSERT INTO t_uczen VALUES (t_uczen_obj(
        seq_uczen.NEXTVAL,               -- id_ucznia (4)
        'Damian',
        'Zieliński',
        DATE '2003-05-30',               -- 22 lata (student)
        'ukonczyl_edukacje',             -- 🟢 lekcje od 14:00
        DATE '2021-09-01',
        4,
        6,
        'aktywny',
        v_ref_gitara,
        v_ref_lewandowski
    ));
    
    -- Uczeń 5: Ewa Wiśniewska, klarnet, klasa 2
    --          'tylko_muzyczna' (homeschooling) → lekcje od 14:00
    INSERT INTO t_uczen VALUES (t_uczen_obj(
        seq_uczen.NEXTVAL,               -- id_ucznia (5)
        'Ewa',
        'Wiśniewska',
        DATE '2013-09-12',               -- 12 lat
        'tylko_muzyczna',                -- 🟢 lekcje od 14:00
        DATE '2023-09-01',
        2,
        6,
        'aktywny',
        v_ref_klarnet,
        v_ref_wisniewska
    ));
    
    -- Uczeń 6: Filip Adamski, fortepian, klasa 1 (nowy)
    --          'uczacy_sie_w_innej_szkole' → lekcje od 15:00!
    --          DZIURA: zupełnie nowy, brak historii
    INSERT INTO t_uczen VALUES (t_uczen_obj(
        seq_uczen.NEXTVAL,               -- id_ucznia (6)
        'Filip',
        'Adamski',
        DATE '2017-01-20',               -- 8 lat
        'uczacy_sie_w_innej_szkole',
        DATE '2025-10-01',               -- bardzo nowy!
        1,
        6,
        'aktywny',
        v_ref_fortepian,
        v_ref_kowalski
    ));
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('   6 uczniów:');
    DBMS_OUTPUT.PUT_LINE('     1. Ala Malinowska (fortepian, kl.3, uczacy_sie_w_innej_szkole)');
    DBMS_OUTPUT.PUT_LINE('     2. Bartek Nowakowski (skrzypce, kl.2, uczacy_sie_w_innej_szkole)');
    DBMS_OUTPUT.PUT_LINE('     3. Celina Kowalczyk (flet, kl.1, uczacy_sie_w_innej_szkole) ← DZIURA');
    DBMS_OUTPUT.PUT_LINE('     4. Damian Zieliński (gitara, kl.4, ukonczyl_edukacje)');
    DBMS_OUTPUT.PUT_LINE('     5. Ewa Wiśniewska (klarnet, kl.2, tylko_muzyczna)');
    DBMS_OUTPUT.PUT_LINE('     6. Filip Adamski (fortepian, kl.1, uczacy_sie_w_innej_szkole) ← DZIURA');
END;
/

-- ============================================================================
-- 7. PRZEDMIOTY
-- ============================================================================
-- Przedmioty nauczane w szkole.
-- ============================================================================

PROMPT [7/10] Wstawianie przedmiotów...

DECLARE
    v_ref_sem REF t_semestr_obj;
BEGIN
    SELECT REF(s) INTO v_ref_sem FROM t_semestr s 
    WHERE s.rok_akademicki = '2025/26' AND s.nazwa_semestru = 'zimowy';
    
    INSERT INTO t_przedmiot VALUES (t_przedmiot_obj(
        seq_przedmiot.NEXTVAL, 'Instrument główny', 'indywidualny', v_ref_sem
    ));
    
    INSERT INTO t_przedmiot VALUES (t_przedmiot_obj(
        seq_przedmiot.NEXTVAL, 'Teoria muzyki', 'grupowy', v_ref_sem
    ));
    
    INSERT INTO t_przedmiot VALUES (t_przedmiot_obj(
        seq_przedmiot.NEXTVAL, 'Rytmika', 'grupowy', v_ref_sem
    ));
    
    INSERT INTO t_przedmiot VALUES (t_przedmiot_obj(
        seq_przedmiot.NEXTVAL, 'Kształcenie słuchu', 'grupowy', v_ref_sem
    ));
    
    INSERT INTO t_przedmiot VALUES (t_przedmiot_obj(
        seq_przedmiot.NEXTVAL, 'Fortepian dodatkowy', 'indywidualny', v_ref_sem
    ));
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('   5 przedmiotów: Instrument główny, Teoria, Rytmika, ' ||
                         'Kształcenie słuchu, Fortepian dodatkowy');
END;
/

-- ============================================================================
-- 8. LEKCJE
-- ============================================================================
-- Przykładowe lekcje z celowymi "dziurami".
-- 
-- PLAN TYGODNIOWY (tydzień 13-17.01.2026):
-- =========================================
--
-- PONIEDZIAŁEK (13.01):
--   15:00-15:45 | Sala 101 | Kowalski | Ala (fortepian)
--   15:00-15:45 | Sala 102 | Nowak    | Bartek (skrzypce)
--   16:00-16:45 | Sala 101 | Kowalski | Filip (fortepian)
--   --- DZIURA: Sala 103 cały dzień wolna! ---
--
-- WTOREK (14.01):
--   14:00-14:45 | Sala 103 | Lewandowski | Damian (gitara)
--   15:00-15:45 | Sala 103 | Wiśniewska  | Celina (flet)
--   16:00-16:45 | Sala A1  | Lewandowski | Grupa Rytmika (grupowa)
--   --- DZIURA: Sala 101, 102 wolne! ---
--
-- ŚRODA (15.01):
--   14:00-14:45 | Sala 101 | Wiśniewska | Ewa (klarnet)
--   15:00-16:30 | Sala A1  | Lewandowski | Grupa Teoria (grupowa, 90min)
--   --- DZIURA: Sala 102, 103 wolne! ---
--
-- CZWARTEK (16.01):
--   15:00-15:45 | Sala 101 | Kowalski | Ala (fortepian) - druga lekcja
--   --- DZIURA: Reszta wolna! ---
--
-- PIĄTEK (17.01):
--   --- DZIURA: Cały dzień wolny! Dobry na testy! ---
--
-- ============================================================================

PROMPT [8/10] Wstawianie lekcji...

DECLARE
    -- REF-y
    v_ref_sem        REF t_semestr_obj;
    v_ref_sala101    REF t_sala_obj;
    v_ref_sala102    REF t_sala_obj;
    v_ref_sala103    REF t_sala_obj;
    v_ref_salaA1     REF t_sala_obj;
    v_ref_kowalski   REF t_nauczyciel_obj;
    v_ref_nowak      REF t_nauczyciel_obj;
    v_ref_wisniewska REF t_nauczyciel_obj;
    v_ref_lewandowski REF t_nauczyciel_obj;
    v_ref_ala        REF t_uczen_obj;
    v_ref_bartek     REF t_uczen_obj;
    v_ref_celina     REF t_uczen_obj;
    v_ref_damian     REF t_uczen_obj;
    v_ref_ewa        REF t_uczen_obj;
    v_ref_filip      REF t_uczen_obj;
    v_ref_grupa_rytm REF t_grupa_obj;
    v_ref_grupa_teor REF t_grupa_obj;
    v_ref_przedm_gl  REF t_przedmiot_obj;  -- Instrument główny
    v_ref_przedm_ryt REF t_przedmiot_obj;  -- Rytmika
    v_ref_przedm_teo REF t_przedmiot_obj;  -- Teoria
BEGIN
    -- Pobierz REF-y
    SELECT REF(s) INTO v_ref_sem FROM t_semestr s WHERE s.rok_akademicki = '2025/26';
    SELECT REF(s) INTO v_ref_sala101 FROM t_sala s WHERE s.numer_sali = '101';
    SELECT REF(s) INTO v_ref_sala102 FROM t_sala s WHERE s.numer_sali = '102';
    SELECT REF(s) INTO v_ref_sala103 FROM t_sala s WHERE s.numer_sali = '103';
    SELECT REF(s) INTO v_ref_salaA1  FROM t_sala s WHERE s.numer_sali = 'A1';
    SELECT REF(n) INTO v_ref_kowalski    FROM t_nauczyciel n WHERE n.nazwisko = 'Kowalski';
    SELECT REF(n) INTO v_ref_nowak       FROM t_nauczyciel n WHERE n.nazwisko = 'Nowak';
    SELECT REF(n) INTO v_ref_wisniewska  FROM t_nauczyciel n WHERE n.nazwisko = 'Wiśniewska';
    SELECT REF(n) INTO v_ref_lewandowski FROM t_nauczyciel n WHERE n.nazwisko = 'Lewandowski';
    SELECT REF(u) INTO v_ref_ala     FROM t_uczen u WHERE u.imie = 'Ala';
    SELECT REF(u) INTO v_ref_bartek  FROM t_uczen u WHERE u.imie = 'Bartek';
    SELECT REF(u) INTO v_ref_celina  FROM t_uczen u WHERE u.imie = 'Celina';
    SELECT REF(u) INTO v_ref_damian  FROM t_uczen u WHERE u.imie = 'Damian';
    SELECT REF(u) INTO v_ref_ewa     FROM t_uczen u WHERE u.imie = 'Ewa';
    SELECT REF(u) INTO v_ref_filip   FROM t_uczen u WHERE u.imie = 'Filip';
    SELECT REF(g) INTO v_ref_grupa_rytm FROM t_grupa g WHERE g.nazwa_grupy LIKE 'Rytmika%';
    SELECT REF(g) INTO v_ref_grupa_teor FROM t_grupa g WHERE g.nazwa_grupy LIKE 'Teoria%';
    SELECT REF(p) INTO v_ref_przedm_gl  FROM t_przedmiot p WHERE p.nazwa = 'Instrument główny';
    SELECT REF(p) INTO v_ref_przedm_ryt FROM t_przedmiot p WHERE p.nazwa = 'Rytmika';
    SELECT REF(p) INTO v_ref_przedm_teo FROM t_przedmiot p WHERE p.nazwa = 'Teoria muzyki';
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- PONIEDZIAŁEK 13.01.2026
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- 15:00 Sala 101 | Kowalski | Ala (fortepian)
    INSERT INTO t_lekcja VALUES (t_lekcja_obj(
        seq_lekcja.NEXTVAL,
        'indywidualna',
        DATE '2026-01-13',
        '15:00',
        45,
        'zaplanowana',
        v_ref_sala101,
        v_ref_kowalski,
        v_ref_przedm_gl,
        v_ref_sem,
        v_ref_ala,
        NULL  -- brak grupy (indywidualna)
    ));
    
    -- 15:00 Sala 102 | Nowak | Bartek (skrzypce)
    INSERT INTO t_lekcja VALUES (t_lekcja_obj(
        seq_lekcja.NEXTVAL,
        'indywidualna',
        DATE '2026-01-13',
        '15:00',
        45,
        'zaplanowana',
        v_ref_sala102,
        v_ref_nowak,
        v_ref_przedm_gl,
        v_ref_sem,
        v_ref_bartek,
        NULL
    ));
    
    -- 16:00 Sala 101 | Kowalski | Filip (fortepian)
    INSERT INTO t_lekcja VALUES (t_lekcja_obj(
        seq_lekcja.NEXTVAL,
        'indywidualna',
        DATE '2026-01-13',
        '16:00',
        45,
        'zaplanowana',
        v_ref_sala101,
        v_ref_kowalski,
        v_ref_przedm_gl,
        v_ref_sem,
        v_ref_filip,
        NULL
    ));
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- WTOREK 14.01.2026
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- 14:00 Sala 103 | Lewandowski | Damian (gitara)
    -- UWAGA: Damian ma typ 'ukonczyl_edukacje' → może o 14:00!
    INSERT INTO t_lekcja VALUES (t_lekcja_obj(
        seq_lekcja.NEXTVAL,
        'indywidualna',
        DATE '2026-01-14',
        '14:00',
        45,
        'zaplanowana',
        v_ref_sala103,
        v_ref_lewandowski,
        v_ref_przedm_gl,
        v_ref_sem,
        v_ref_damian,
        NULL
    ));
    
    -- 15:00 Sala 103 | Wiśniewska | Celina (flet)
    INSERT INTO t_lekcja VALUES (t_lekcja_obj(
        seq_lekcja.NEXTVAL,
        'indywidualna',
        DATE '2026-01-14',
        '15:00',
        45,
        'zaplanowana',
        v_ref_sala103,
        v_ref_wisniewska,
        v_ref_przedm_gl,
        v_ref_sem,
        v_ref_celina,
        NULL
    ));
    
    -- 16:00 Sala A1 | Lewandowski | Grupa Rytmika (grupowa)
    INSERT INTO t_lekcja VALUES (t_lekcja_obj(
        seq_lekcja.NEXTVAL,
        'grupowa',
        DATE '2026-01-14',
        '16:00',
        45,
        'zaplanowana',
        v_ref_salaA1,
        v_ref_lewandowski,
        v_ref_przedm_ryt,
        v_ref_sem,
        NULL,  -- brak ucznia (grupowa)
        v_ref_grupa_rytm
    ));
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- ŚRODA 15.01.2026
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- 14:00 Sala 101 | Wiśniewska | Ewa (klarnet)
    -- UWAGA: Ewa ma typ 'tylko_muzyczna' → może o 14:00!
    INSERT INTO t_lekcja VALUES (t_lekcja_obj(
        seq_lekcja.NEXTVAL,
        'indywidualna',
        DATE '2026-01-15',
        '14:00',
        45,
        'zaplanowana',
        v_ref_sala101,
        v_ref_wisniewska,
        v_ref_przedm_gl,
        v_ref_sem,
        v_ref_ewa,
        NULL
    ));
    
    -- 15:00 Sala A1 | Lewandowski | Grupa Teoria (90 minut!)
    INSERT INTO t_lekcja VALUES (t_lekcja_obj(
        seq_lekcja.NEXTVAL,
        'grupowa',
        DATE '2026-01-15',
        '15:00',
        90,  -- dłuższa lekcja!
        'zaplanowana',
        v_ref_salaA1,
        v_ref_lewandowski,
        v_ref_przedm_teo,
        v_ref_sem,
        NULL,
        v_ref_grupa_teor
    ));
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- CZWARTEK 16.01.2026
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- 15:00 Sala 101 | Kowalski | Ala (fortepian) - druga lekcja w tygodniu
    INSERT INTO t_lekcja VALUES (t_lekcja_obj(
        seq_lekcja.NEXTVAL,
        'indywidualna',
        DATE '2026-01-16',
        '15:00',
        45,
        'zaplanowana',
        v_ref_sala101,
        v_ref_kowalski,
        v_ref_przedm_gl,
        v_ref_sem,
        v_ref_ala,
        NULL
    ));
    
    -- PIĄTEK 17.01.2026 - CELOWO PUSTY (dziura na testy!)
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('   10 lekcji w tygodniu 13-17.01.2026');
    DBMS_OUTPUT.PUT_LINE('   DZIURY do testów:');
    DBMS_OUTPUT.PUT_LINE('     - Poniedziałek: Sala 103 wolna');
    DBMS_OUTPUT.PUT_LINE('     - Wtorek: Sala 101, 102 wolne');
    DBMS_OUTPUT.PUT_LINE('     - Środa: Sala 102, 103 wolne');
    DBMS_OUTPUT.PUT_LINE('     - Piątek: CAŁY DZIEŃ WOLNY!');
END;
/

-- ============================================================================
-- 9. EGZAMINY
-- ============================================================================
-- Przykładowe egzaminy końcoworoczne.
-- ============================================================================

PROMPT [9/10] Wstawianie egzaminów...

DECLARE
    v_ref_sem        REF t_semestr_obj;
    v_ref_ala        REF t_uczen_obj;
    v_ref_bartek     REF t_uczen_obj;
    v_ref_przedm_gl  REF t_przedmiot_obj;
    v_ref_salaB1     REF t_sala_obj;
    v_ref_kowalski   REF t_nauczyciel_obj;
    v_ref_nowak      REF t_nauczyciel_obj;
    v_ref_wisniewska REF t_nauczyciel_obj;
BEGIN
    SELECT REF(s) INTO v_ref_sem FROM t_semestr s WHERE s.rok_akademicki = '2025/26';
    SELECT REF(u) INTO v_ref_ala     FROM t_uczen u WHERE u.imie = 'Ala';
    SELECT REF(u) INTO v_ref_bartek  FROM t_uczen u WHERE u.imie = 'Bartek';
    SELECT REF(p) INTO v_ref_przedm_gl FROM t_przedmiot p WHERE p.nazwa = 'Instrument główny';
    SELECT REF(s) INTO v_ref_salaB1  FROM t_sala s WHERE s.numer_sali = 'B1';
    SELECT REF(n) INTO v_ref_kowalski   FROM t_nauczyciel n WHERE n.nazwisko = 'Kowalski';
    SELECT REF(n) INTO v_ref_nowak      FROM t_nauczyciel n WHERE n.nazwisko = 'Nowak';
    SELECT REF(n) INTO v_ref_wisniewska FROM t_nauczyciel n WHERE n.nazwisko = 'Wiśniewska';
    
    -- Egzamin Ali (fortepian)
    -- Komisja: Kowalski (prowadzący), Nowak
    INSERT INTO t_egzamin VALUES (t_egzamin_obj(
        seq_egzamin.NEXTVAL,
        DATE '2026-01-25',
        'koncert',
        NULL,  -- ocena_koncowa = NULL (egzamin w przyszłości)
        v_ref_ala,
        v_ref_przedm_gl,
        v_ref_kowalski,   -- komisja1 (prowadzący)
        v_ref_nowak,      -- komisja2 (inna osoba!)
        v_ref_salaB1
    ));
    
    -- Egzamin Bartka (skrzypce)
    -- Komisja: Nowak (prowadzący), Wiśniewska
    INSERT INTO t_egzamin VALUES (t_egzamin_obj(
        seq_egzamin.NEXTVAL,
        DATE '2026-01-26',
        'techniczny',
        NULL,
        v_ref_bartek,
        v_ref_przedm_gl,
        v_ref_nowak,
        v_ref_wisniewska,
        v_ref_salaB1
    ));
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('   2 egzaminy: Ala (25.01, koncert), Bartek (26.01, techniczny)');
END;
/

-- ============================================================================
-- 10. OCENY
-- ============================================================================
-- Przykładowe oceny.
-- ============================================================================

PROMPT [10/10] Wstawianie ocen...

DECLARE
    v_ref_sem        REF t_semestr_obj;
    v_ref_ala        REF t_uczen_obj;
    v_ref_bartek     REF t_uczen_obj;
    v_ref_damian     REF t_uczen_obj;
    v_ref_przedm_gl  REF t_przedmiot_obj;
    v_ref_przedm_teo REF t_przedmiot_obj;
    v_ref_kowalski   REF t_nauczyciel_obj;
    v_ref_nowak      REF t_nauczyciel_obj;
    v_ref_lewandowski REF t_nauczyciel_obj;
BEGIN
    SELECT REF(s) INTO v_ref_sem FROM t_semestr s WHERE s.rok_akademicki = '2025/26';
    SELECT REF(u) INTO v_ref_ala     FROM t_uczen u WHERE u.imie = 'Ala';
    SELECT REF(u) INTO v_ref_bartek  FROM t_uczen u WHERE u.imie = 'Bartek';
    SELECT REF(u) INTO v_ref_damian  FROM t_uczen u WHERE u.imie = 'Damian';
    SELECT REF(p) INTO v_ref_przedm_gl  FROM t_przedmiot p WHERE p.nazwa = 'Instrument główny';
    SELECT REF(p) INTO v_ref_przedm_teo FROM t_przedmiot p WHERE p.nazwa = 'Teoria muzyki';
    SELECT REF(n) INTO v_ref_kowalski    FROM t_nauczyciel n WHERE n.nazwisko = 'Kowalski';
    SELECT REF(n) INTO v_ref_nowak       FROM t_nauczyciel n WHERE n.nazwisko = 'Nowak';
    SELECT REF(n) INTO v_ref_lewandowski FROM t_nauczyciel n WHERE n.nazwisko = 'Lewandowski';
    
    -- Oceny Ali (fortepian)
    INSERT INTO t_ocena VALUES (t_ocena_obj(
        seq_ocena.NEXTVAL, 5, DATE '2025-10-15', 'Etiuda Czernego - bardzo dobrze',
        v_ref_ala, v_ref_przedm_gl, v_ref_kowalski, v_ref_sem
    ));
    INSERT INTO t_ocena VALUES (t_ocena_obj(
        seq_ocena.NEXTVAL, 4, DATE '2025-11-10', 'Sonatina - dobra interpretacja',
        v_ref_ala, v_ref_przedm_gl, v_ref_kowalski, v_ref_sem
    ));
    INSERT INTO t_ocena VALUES (t_ocena_obj(
        seq_ocena.NEXTVAL, 5, DATE '2025-12-05', 'Gamy - bezbłędnie',
        v_ref_ala, v_ref_przedm_gl, v_ref_kowalski, v_ref_sem
    ));
    
    -- Oceny Bartka (skrzypce)
    INSERT INTO t_ocena VALUES (t_ocena_obj(
        seq_ocena.NEXTVAL, 4, DATE '2025-10-20', 'Etiuda - poprawnie',
        v_ref_bartek, v_ref_przedm_gl, v_ref_nowak, v_ref_sem
    ));
    INSERT INTO t_ocena VALUES (t_ocena_obj(
        seq_ocena.NEXTVAL, 3, DATE '2025-11-15', 'Koncert - wymaga pracy',
        v_ref_bartek, v_ref_przedm_gl, v_ref_nowak, v_ref_sem
    ));
    
    -- Oceny Damiana (gitara + teoria)
    INSERT INTO t_ocena VALUES (t_ocena_obj(
        seq_ocena.NEXTVAL, 5, DATE '2025-10-25', 'Utwór klasyczny - świetnie',
        v_ref_damian, v_ref_przedm_gl, v_ref_lewandowski, v_ref_sem
    ));
    INSERT INTO t_ocena VALUES (t_ocena_obj(
        seq_ocena.NEXTVAL, 4, DATE '2025-11-20', 'Teoria - dyktando muzyczne',
        v_ref_damian, v_ref_przedm_teo, v_ref_lewandowski, v_ref_sem
    ));
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('   7 ocen: Ala (3 oceny), Bartek (2 oceny), Damian (2 oceny)');
END;
/

-- ============================================================================
-- PODSUMOWANIE DANYCH
-- ============================================================================

PROMPT
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT   PODSUMOWANIE - Wstawione dane
PROMPT ════════════════════════════════════════════════════════════════════════

SELECT 'Semestry:     ' || COUNT(*) FROM t_semestr
UNION ALL
SELECT 'Instrumenty:  ' || COUNT(*) FROM t_instrument
UNION ALL
SELECT 'Sale:         ' || COUNT(*) FROM t_sala
UNION ALL
SELECT 'Nauczyciele:  ' || COUNT(*) FROM t_nauczyciel
UNION ALL
SELECT 'Grupy:        ' || COUNT(*) FROM t_grupa
UNION ALL
SELECT 'Uczniowie:    ' || COUNT(*) FROM t_uczen
UNION ALL
SELECT 'Przedmioty:   ' || COUNT(*) FROM t_przedmiot
UNION ALL
SELECT 'Lekcje:       ' || COUNT(*) FROM t_lekcja
UNION ALL
SELECT 'Egzaminy:     ' || COUNT(*) FROM t_egzamin
UNION ALL
SELECT 'Oceny:        ' || COUNT(*) FROM t_ocena;

PROMPT
PROMPT   STRATEGIA DZIUR (do testów):
PROMPT     ● Sala 103 - wolna w poniedziałek
PROMPT     ● Sala 101, 102 - wolne we wtorek
PROMPT     ● Piątek 17.01 - całkowicie pusty!
PROMPT     ● Uczniowie Celina i Filip - mało lekcji
PROMPT
PROMPT   TESTOWE SCENARIUSZE:
PROMPT     ✓ Pozytywny: Dodaj lekcję w piątek (cały dzień wolny)
PROMPT     ✗ Negatywny: Dodaj lekcję Ali 13.01 o 15:00 (konflikt!)
PROMPT     ✗ Negatywny: Dodaj lekcję Ali o 14:00 (za wcześnie - typ ucznia!)
PROMPT
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT   Następny krok: Uruchom 06_role.sql
PROMPT ════════════════════════════════════════════════════════════════════════
PROMPT
