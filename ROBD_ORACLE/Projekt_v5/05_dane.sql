-- ============================================================================
-- PLIK: 05_dane.sql
-- PROJEKT: Szkola Muzyczna v5 - Obiektowa Baza Danych Oracle
-- AUTORZY: Igor Typinski (251237), Mateusz Mroz (251190)
-- DATA: Styczen 2026
-- ============================================================================
-- Wstawia DANE TESTOWE do wszystkich tabel
-- Zawiera "luki" w danych do testowania triggerow
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200
SET PAGESIZE 50

PROMPT ========================================================================
PROMPT   05_dane.sql - Wstawianie danych testowych
PROMPT ========================================================================
PROMPT

-- ============================================================================
-- 1. SEMESTRY
-- ============================================================================

PROMPT [1/9] Wstawianie semestrów...

INSERT INTO semestry VALUES (t_semestr_obj(
    seq_semestry.NEXTVAL, 'Semestr zimowy', DATE '2025-10-01', DATE '2026-01-31', '2025/2026'
));

INSERT INTO semestry VALUES (t_semestr_obj(
    seq_semestry.NEXTVAL, 'Semestr letni', DATE '2026-02-01', DATE '2026-06-30', '2025/2026'
));

-- ============================================================================
-- 2. INSTRUMENTY
-- ============================================================================

PROMPT [2/9] Wstawianie instrumentów...

INSERT INTO instrumenty VALUES (t_instrument_obj(seq_instrumenty.NEXTVAL, 'Fortepian', 'klawiszowe', 'N'));
INSERT INTO instrumenty VALUES (t_instrument_obj(seq_instrumenty.NEXTVAL, 'Skrzypce', 'strunowe', 'T'));
INSERT INTO instrumenty VALUES (t_instrument_obj(seq_instrumenty.NEXTVAL, 'Gitara klasyczna', 'strunowe', 'N'));
INSERT INTO instrumenty VALUES (t_instrument_obj(seq_instrumenty.NEXTVAL, 'Flet poprzeczny', 'dete', 'T'));
INSERT INTO instrumenty VALUES (t_instrument_obj(seq_instrumenty.NEXTVAL, 'Klarnet', 'dete', 'T'));
INSERT INTO instrumenty VALUES (t_instrument_obj(seq_instrumenty.NEXTVAL, 'Trabka', 'dete', 'T'));
INSERT INTO instrumenty VALUES (t_instrument_obj(seq_instrumenty.NEXTVAL, 'Perkusja', 'perkusyjne', 'N'));
INSERT INTO instrumenty VALUES (t_instrument_obj(seq_instrumenty.NEXTVAL, 'Wiolonczela', 'strunowe', 'T'));

-- ============================================================================
-- 3. SALE
-- ============================================================================

PROMPT [3/9] Wstawianie sal...

INSERT INTO sale VALUES (t_sala_obj(
    seq_sale.NEXTVAL, '101', 'indywidualna', 3,
    t_lista_sprzetu('Fortepian Yamaha', 'Lustro', 'Pulpit'), 'aktywna'
));

INSERT INTO sale VALUES (t_sala_obj(
    seq_sale.NEXTVAL, '102', 'indywidualna', 3,
    t_lista_sprzetu('Pianino', 'Pulpit', 'Metronom'), 'aktywna'
));

INSERT INTO sale VALUES (t_sala_obj(
    seq_sale.NEXTVAL, '201', 'grupowa', 20,
    t_lista_sprzetu('Tablica', 'Projektor', 'Glosniki', 'Krzesla'), 'aktywna'
));

INSERT INTO sale VALUES (t_sala_obj(
    seq_sale.NEXTVAL, '202', 'grupowa', 15,
    t_lista_sprzetu('Tablica', 'Pianino', 'Krzesla'), 'aktywna'
));

INSERT INTO sale VALUES (t_sala_obj(
    seq_sale.NEXTVAL, '301', 'wielofunkcyjna', 10,
    t_lista_sprzetu('Fortepian', 'Naglosnienie', 'Pulpity'), 'aktywna'
));

-- ============================================================================
-- 4. NAUCZYCIELE
-- ============================================================================

PROMPT [4/9] Wstawianie nauczycieli...

INSERT INTO nauczyciele VALUES (t_nauczyciel_obj(
    seq_nauczyciele.NEXTVAL, 'Anna', 'Kowalska', 'a.kowalska@szkola.pl', '501111111',
    DATE '2015-09-01', t_lista_instrumentow('Fortepian'), 'T', 'T', 'aktywny'
));

INSERT INTO nauczyciele VALUES (t_nauczyciel_obj(
    seq_nauczyciele.NEXTVAL, 'Jan', 'Nowak', 'j.nowak@szkola.pl', '502222222',
    DATE '2018-09-01', t_lista_instrumentow('Skrzypce', 'Altówka'), 'N', 'N', 'aktywny'
));

INSERT INTO nauczyciele VALUES (t_nauczyciel_obj(
    seq_nauczyciele.NEXTVAL, 'Maria', 'Wisniewska', 'm.wisniewska@szkola.pl', '503333333',
    DATE '2010-09-01', t_lista_instrumentow('Flet poprzeczny', 'Klarnet'), 'T', 'N', 'aktywny'
));

INSERT INTO nauczyciele VALUES (t_nauczyciel_obj(
    seq_nauczyciele.NEXTVAL, 'Piotr', 'Lewandowski', 'p.lewandowski@szkola.pl', '504444444',
    DATE '2020-09-01', t_lista_instrumentow('Gitara klasyczna'), 'N', 'N', 'aktywny'
));

INSERT INTO nauczyciele VALUES (t_nauczyciel_obj(
    seq_nauczyciele.NEXTVAL, 'Ewa', 'Kaminska', 'e.kaminska@szkola.pl', '505555555',
    DATE '2012-09-01', t_lista_instrumentow('Fortepian'), 'T', 'T', 'aktywny'
));

-- ============================================================================
-- 5. GRUPY
-- ============================================================================

PROMPT [5/9] Wstawianie grup...

INSERT INTO grupy VALUES (t_grupa_obj(seq_grupy.NEXTVAL, '1A', 1, '2025/2026', 15, 'aktywna'));
INSERT INTO grupy VALUES (t_grupa_obj(seq_grupy.NEXTVAL, '1B', 1, '2025/2026', 15, 'aktywna'));
INSERT INTO grupy VALUES (t_grupa_obj(seq_grupy.NEXTVAL, '2A', 2, '2025/2026', 15, 'aktywna'));
INSERT INTO grupy VALUES (t_grupa_obj(seq_grupy.NEXTVAL, '3A', 3, '2025/2026', 15, 'aktywna'));

-- ============================================================================
-- 6. UCZNIOWIE
-- Rozne typy - do testow godzin lekcji:
--   'uczacy_sie_w_innej_szkole' -> lekcje od 15:00
--   'ukonczyl_edukacje'/'tylko_muzyczna' -> lekcje od 14:00
-- ============================================================================

PROMPT [6/9] Wstawianie uczniów...

DECLARE
    v_ref_fort REF t_instrument_obj;
    v_ref_skrz REF t_instrument_obj;
    v_ref_git  REF t_instrument_obj;
    v_ref_flet REF t_instrument_obj;
    v_ref_g1a  REF t_grupa_obj;
    v_ref_g1b  REF t_grupa_obj;
    v_ref_g2a  REF t_grupa_obj;
BEGIN
    SELECT REF(i) INTO v_ref_fort FROM instrumenty i WHERE nazwa = 'Fortepian';
    SELECT REF(i) INTO v_ref_skrz FROM instrumenty i WHERE nazwa = 'Skrzypce';
    SELECT REF(i) INTO v_ref_git FROM instrumenty i WHERE nazwa = 'Gitara klasyczna';
    SELECT REF(i) INTO v_ref_flet FROM instrumenty i WHERE nazwa = 'Flet poprzeczny';
    SELECT REF(g) INTO v_ref_g1a FROM grupy g WHERE nazwa = '1A';
    SELECT REF(g) INTO v_ref_g1b FROM grupy g WHERE nazwa = '1B';
    SELECT REF(g) INTO v_ref_g2a FROM grupy g WHERE nazwa = '2A';

    -- Uczniowie uczacy sie w innej szkole (lekcje od 15:00)
    INSERT INTO uczniowie VALUES (t_uczen_obj(
        seq_uczniowie.NEXTVAL, 'Adam', 'Malinowski', DATE '2012-03-15',
        'a.malinowski@email.pl', '601111111', DATE '2024-09-01',
        1, 6, 'uczacy_sie_w_innej_szkole', 'aktywny', v_ref_fort, v_ref_g1a
    ));

    INSERT INTO uczniowie VALUES (t_uczen_obj(
        seq_uczniowie.NEXTVAL, 'Zofia', 'Kaminska', DATE '2013-07-22',
        'z.kaminska@email.pl', '602222222', DATE '2024-09-01',
        1, 6, 'uczacy_sie_w_innej_szkole', 'aktywny', v_ref_skrz, v_ref_g1a
    ));

    INSERT INTO uczniowie VALUES (t_uczen_obj(
        seq_uczniowie.NEXTVAL, 'Jakub', 'Wisniewski', DATE '2011-11-08',
        'j.wisniewski@email.pl', '603333333', DATE '2023-09-01',
        2, 6, 'uczacy_sie_w_innej_szkole', 'aktywny', v_ref_git, v_ref_g2a
    ));

    -- Uczniowie tylko muzyczna (lekcje od 14:00)
    INSERT INTO uczniowie VALUES (t_uczen_obj(
        seq_uczniowie.NEXTVAL, 'Maja', 'Kowalczyk', DATE '2010-05-30',
        'm.kowalczyk@email.pl', '604444444', DATE '2022-09-01',
        3, 6, 'tylko_muzyczna', 'aktywny', v_ref_fort, NULL
    ));

    -- Uczniowie po edukacji (lekcje od 14:00)
    INSERT INTO uczniowie VALUES (t_uczen_obj(
        seq_uczniowie.NEXTVAL, 'Tomasz', 'Zielinski', DATE '2005-01-12',
        't.zielinski@email.pl', '605555555', DATE '2020-09-01',
        4, 6, 'ukonczyl_edukacje', 'aktywny', v_ref_flet, NULL
    ));

    INSERT INTO uczniowie VALUES (t_uczen_obj(
        seq_uczniowie.NEXTVAL, 'Julia', 'Dabrowska', DATE '2012-09-18',
        'j.dabrowska@email.pl', '606666666', DATE '2024-09-01',
        1, 6, 'uczacy_sie_w_innej_szkole', 'aktywny', v_ref_skrz, v_ref_g1b
    ));

    DBMS_OUTPUT.PUT_LINE('Dodano 6 uczniow');
END;
/

-- ============================================================================
-- 7. PRZEDMIOTY
-- ============================================================================

PROMPT [7/9] Wstawianie przedmiotów...

DECLARE
    v_ref_fort REF t_instrument_obj;
    v_ref_skrz REF t_instrument_obj;
    v_ref_git  REF t_instrument_obj;
    v_ref_flet REF t_instrument_obj;
BEGIN
    SELECT REF(i) INTO v_ref_fort FROM instrumenty i WHERE nazwa = 'Fortepian';
    SELECT REF(i) INTO v_ref_skrz FROM instrumenty i WHERE nazwa = 'Skrzypce';
    SELECT REF(i) INTO v_ref_git FROM instrumenty i WHERE nazwa = 'Gitara klasyczna';
    SELECT REF(i) INTO v_ref_flet FROM instrumenty i WHERE nazwa = 'Flet poprzeczny';

    -- Przedmioty indywidualne (instrument glowny)
    INSERT INTO przedmioty VALUES (t_przedmiot_obj(
        seq_przedmioty.NEXTVAL, 'Fortepian - instrument glowny', 'indywidualny',
        45, 1, 6, 'T', 'Fortepian', v_ref_fort
    ));

    INSERT INTO przedmioty VALUES (t_przedmiot_obj(
        seq_przedmioty.NEXTVAL, 'Skrzypce - instrument glowny', 'indywidualny',
        45, 1, 6, 'T', 'Skrzypce', v_ref_skrz
    ));

    INSERT INTO przedmioty VALUES (t_przedmiot_obj(
        seq_przedmioty.NEXTVAL, 'Gitara - instrument glowny', 'indywidualny',
        45, 1, 6, 'T', 'Gitara', v_ref_git
    ));

    INSERT INTO przedmioty VALUES (t_przedmiot_obj(
        seq_przedmioty.NEXTVAL, 'Flet - instrument glowny', 'indywidualny',
        45, 1, 6, 'T', 'Flet', v_ref_flet
    ));

    -- Przedmioty grupowe
    INSERT INTO przedmioty VALUES (t_przedmiot_obj(
        seq_przedmioty.NEXTVAL, 'Ksztalcenie sluchu', 'grupowy',
        45, 1, 6, 'T', 'Tablica', NULL
    ));

    INSERT INTO przedmioty VALUES (t_przedmiot_obj(
        seq_przedmioty.NEXTVAL, 'Rytmika', 'grupowy',
        45, 1, 3, 'T', NULL, NULL
    ));

    INSERT INTO przedmioty VALUES (t_przedmiot_obj(
        seq_przedmioty.NEXTVAL, 'Zespol kameralny', 'grupowy',
        60, 3, 6, 'N', 'Pulpity', NULL
    ));

    INSERT INTO przedmioty VALUES (t_przedmiot_obj(
        seq_przedmioty.NEXTVAL, 'Fortepian dodatkowy', 'indywidualny',
        30, 1, 6, 'T', 'Fortepian', v_ref_fort
    ));

    DBMS_OUTPUT.PUT_LINE('Dodano 8 przedmiotow');
END;
/

-- ============================================================================
-- 8. LEKCJE
-- ============================================================================

PROMPT [8/9] Wstawianie lekcji...

DECLARE
    v_ref_p1   REF t_przedmiot_obj;   -- Fortepian
    v_ref_p2   REF t_przedmiot_obj;   -- Skrzypce
    v_ref_p5   REF t_przedmiot_obj;   -- Ksztalcenie sluchu
    v_ref_n1   REF t_nauczyciel_obj;  -- Kowalska
    v_ref_n2   REF t_nauczyciel_obj;  -- Nowak
    v_ref_n3   REF t_nauczyciel_obj;  -- Wisniewska
    v_ref_s1   REF t_sala_obj;        -- 101
    v_ref_s3   REF t_sala_obj;        -- 201
    v_ref_u1   REF t_uczen_obj;       -- Malinowski (innej szkoly)
    v_ref_u4   REF t_uczen_obj;       -- Kowalczyk (tylko muzyczna)
    v_ref_g1   REF t_grupa_obj;       -- 1A
BEGIN
    SELECT REF(p) INTO v_ref_p1 FROM przedmioty p WHERE nazwa LIKE 'Fortepian - instrument%';
    SELECT REF(p) INTO v_ref_p2 FROM przedmioty p WHERE nazwa LIKE 'Skrzypce - instrument%';
    SELECT REF(p) INTO v_ref_p5 FROM przedmioty p WHERE nazwa = 'Ksztalcenie sluchu';
    SELECT REF(n) INTO v_ref_n1 FROM nauczyciele n WHERE nazwisko = 'Kowalska';
    SELECT REF(n) INTO v_ref_n2 FROM nauczyciele n WHERE nazwisko = 'Nowak';
    SELECT REF(n) INTO v_ref_n3 FROM nauczyciele n WHERE nazwisko = 'Wisniewska';
    SELECT REF(s) INTO v_ref_s1 FROM sale s WHERE numer = '101';
    SELECT REF(s) INTO v_ref_s3 FROM sale s WHERE numer = '201';
    SELECT REF(u) INTO v_ref_u1 FROM uczniowie u WHERE nazwisko = 'Malinowski';
    SELECT REF(u) INTO v_ref_u4 FROM uczniowie u WHERE nazwisko = 'Kowalczyk';
    SELECT REF(g) INTO v_ref_g1 FROM grupy g WHERE nazwa = '1A';

    -- Lekcje indywidualne
    -- Malinowski (innej szkoly) - od 15:00
    INSERT INTO lekcje VALUES (t_lekcja_obj(
        seq_lekcje.NEXTVAL, DATE '2026-01-10', '15:00', 45, 'indywidualna', 'zaplanowana',
        v_ref_p1, v_ref_n1, NULL, v_ref_s1, v_ref_u1, NULL
    ));

    INSERT INTO lekcje VALUES (t_lekcja_obj(
        seq_lekcje.NEXTVAL, DATE '2026-01-17', '15:00', 45, 'indywidualna', 'zaplanowana',
        v_ref_p1, v_ref_n1, NULL, v_ref_s1, v_ref_u1, NULL
    ));

    -- Kowalczyk (tylko muzyczna) - od 14:00
    INSERT INTO lekcje VALUES (t_lekcja_obj(
        seq_lekcje.NEXTVAL, DATE '2026-01-10', '14:00', 45, 'indywidualna', 'zaplanowana',
        v_ref_p1, v_ref_n1, NULL, v_ref_s1, v_ref_u4, NULL
    ));

    -- Lekcje grupowe
    INSERT INTO lekcje VALUES (t_lekcja_obj(
        seq_lekcje.NEXTVAL, DATE '2026-01-11', '16:00', 45, 'grupowa', 'zaplanowana',
        v_ref_p5, v_ref_n3, NULL, v_ref_s3, NULL, v_ref_g1
    ));

    INSERT INTO lekcje VALUES (t_lekcja_obj(
        seq_lekcje.NEXTVAL, DATE '2026-01-18', '16:00', 45, 'grupowa', 'zaplanowana',
        v_ref_p5, v_ref_n3, NULL, v_ref_s3, NULL, v_ref_g1
    ));

    DBMS_OUTPUT.PUT_LINE('Dodano 5 lekcji');
END;
/

-- ============================================================================
-- 9. EGZAMINY I OCENY
-- ============================================================================

PROMPT [9/9] Wstawianie egzaminow i ocen...

DECLARE
    v_ref_u1   REF t_uczen_obj;
    v_ref_u4   REF t_uczen_obj;
    v_ref_p1   REF t_przedmiot_obj;
    v_ref_n1   REF t_nauczyciel_obj;
    v_ref_n5   REF t_nauczyciel_obj;
    v_ref_s5   REF t_sala_obj;
BEGIN
    SELECT REF(u) INTO v_ref_u1 FROM uczniowie u WHERE nazwisko = 'Malinowski';
    SELECT REF(u) INTO v_ref_u4 FROM uczniowie u WHERE nazwisko = 'Kowalczyk';
    SELECT REF(p) INTO v_ref_p1 FROM przedmioty p WHERE nazwa LIKE 'Fortepian - instrument%';
    SELECT REF(n) INTO v_ref_n1 FROM nauczyciele n WHERE nazwisko = 'Kowalska';
    SELECT REF(n) INTO v_ref_n5 FROM nauczyciele n WHERE nazwisko = 'Kaminska';
    SELECT REF(s) INTO v_ref_s5 FROM sale s WHERE numer = '301';

    -- Egzamin dla Malinowski (od 15:00)
    INSERT INTO egzaminy VALUES (t_egzamin_obj(
        seq_egzaminy.NEXTVAL, DATE '2026-01-25', '15:30', 'semestralny',
        v_ref_u1, v_ref_p1, v_ref_n1, v_ref_n5, v_ref_s5, NULL, NULL
    ));

    -- Egzamin dla Kowalczyk (od 14:00)
    INSERT INTO egzaminy VALUES (t_egzamin_obj(
        seq_egzaminy.NEXTVAL, DATE '2026-01-26', '14:00', 'semestralny',
        v_ref_u4, v_ref_p1, v_ref_n1, v_ref_n5, v_ref_s5, NULL, NULL
    ));

    -- Oceny biezace
    INSERT INTO oceny VALUES (t_ocena_obj(
        seq_oceny.NEXTVAL, SYSDATE, 5, 'technika', 'Dobra postawa',
        v_ref_u1, v_ref_n1, v_ref_p1, NULL
    ));

    INSERT INTO oceny VALUES (t_ocena_obj(
        seq_oceny.NEXTVAL, SYSDATE, 4, 'interpretacja', 'Wiecej dynamiki',
        v_ref_u1, v_ref_n1, v_ref_p1, NULL
    ));

    INSERT INTO oceny VALUES (t_ocena_obj(
        seq_oceny.NEXTVAL, SYSDATE, 5, 'ogolna', 'Doskonale przygotowanie',
        v_ref_u4, v_ref_n1, v_ref_p1, NULL
    ));

    DBMS_OUTPUT.PUT_LINE('Dodano 2 egzaminy i 3 oceny');
END;
/

COMMIT;

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================

PROMPT
PROMPT ========================================================================
PROMPT   WSTAWIONE DANE
PROMPT ========================================================================

SELECT 'semestry' AS tabela, COUNT(*) AS ilosc FROM semestry UNION ALL
SELECT 'instrumenty', COUNT(*) FROM instrumenty UNION ALL
SELECT 'sale', COUNT(*) FROM sale UNION ALL
SELECT 'nauczyciele', COUNT(*) FROM nauczyciele UNION ALL
SELECT 'grupy', COUNT(*) FROM grupy UNION ALL
SELECT 'uczniowie', COUNT(*) FROM uczniowie UNION ALL
SELECT 'przedmioty', COUNT(*) FROM przedmioty UNION ALL
SELECT 'lekcje', COUNT(*) FROM lekcje UNION ALL
SELECT 'egzaminy', COUNT(*) FROM egzaminy UNION ALL
SELECT 'oceny', COUNT(*) FROM oceny;

PROMPT
PROMPT ========================================================================
PROMPT   Nastepny krok: Uruchom 06_role.sql
PROMPT ========================================================================
