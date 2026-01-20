-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 05_dane.sql
-- Opis: Dane testowe dla wszystkich tabel
-- Wersja: 2.0
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

SET SERVEROUTPUT ON;

-- ============================================================================
-- CZYSZCZENIE DANYCH (w odpowiedniej kolejnosci - ze wzgledu na REF)
-- ============================================================================

DELETE FROM t_ocena_postepu;
DELETE FROM t_lekcja;
DELETE FROM t_zapis;
DELETE FROM t_kurs;
DELETE FROM t_nauczyciel;
DELETE FROM t_uczen;
DELETE FROM t_sala;
DELETE FROM t_semestr;

COMMIT;

-- ============================================================================
-- SEMESTRY [NOWE v2.0]
-- ============================================================================

INSERT INTO t_semestr VALUES (
    t_semestr_obj(1, 'Semestr zimowy 2024/2025', 
                  TO_DATE('2024-10-01', 'YYYY-MM-DD'), 
                  TO_DATE('2025-02-15', 'YYYY-MM-DD'), 'N')
);

INSERT INTO t_semestr VALUES (
    t_semestr_obj(2, 'Semestr letni 2024/2025', 
                  TO_DATE('2025-02-17', 'YYYY-MM-DD'), 
                  TO_DATE('2025-06-30', 'YYYY-MM-DD'), 'T')
);

INSERT INTO t_semestr VALUES (
    t_semestr_obj(3, 'Semestr zimowy 2025/2026', 
                  TO_DATE('2025-10-01', 'YYYY-MM-DD'), 
                  TO_DATE('2026-02-15', 'YYYY-MM-DD'), 'N')
);

PROMPT Dodano 3 semestry (semestr letni 2024/2025 aktywny)

-- ============================================================================
-- SALE LEKCYJNE [NOWE v2.0]
-- ============================================================================

INSERT INTO t_sala VALUES (
    t_sala_obj(1, 'Sala fortepianowa A', 2, 'T', 'N', 'Fortepian koncertowy Yamaha')
);

INSERT INTO t_sala VALUES (
    t_sala_obj(2, 'Sala fortepianowa B', 2, 'T', 'N', 'Pianino cyfrowe Roland')
);

INSERT INTO t_sala VALUES (
    t_sala_obj(3, 'Sala gitarowa', 4, 'N', 'N', 'Gitary klasyczne i akustyczne')
);

INSERT INTO t_sala VALUES (
    t_sala_obj(4, 'Sala perkusyjna', 3, 'N', 'T', 'Perkusja akustyczna i elektroniczna')
);

INSERT INTO t_sala VALUES (
    t_sala_obj(5, 'Sala skrzypcowa', 3, 'N', 'N', 'Pulpity nutowe, metronom')
);

INSERT INTO t_sala VALUES (
    t_sala_obj(6, 'Sala wokalna', 5, 'T', 'N', 'System nagrywania, mikrofony')
);

INSERT INTO t_sala VALUES (
    t_sala_obj(7, 'Sala kameralna', 8, 'T', 'N', 'Sala do zespolow, male koncerty')
);

INSERT INTO t_sala VALUES (
    t_sala_obj(8, 'Sala teoria muzyki', 10, 'N', 'N', 'Rzutnik, tablica')
);

PROMPT Dodano 8 sal lekcyjnych

-- ============================================================================
-- UCZNIOWIE
-- Mieszanka: dorośli (18+) i dzieci (<15 - lekcje tylko 14:00-19:00)
-- ============================================================================

-- Uczniowie pelnoletni (bez ograniczen godzinowych)
INSERT INTO t_uczen VALUES (
    t_uczen_obj(1, 'Anna', 'Kowalska', 
                TO_DATE('1998-05-15', 'YYYY-MM-DD'),
                'anna.kowalska@email.com', '600111222', SYSDATE)
);

INSERT INTO t_uczen VALUES (
    t_uczen_obj(2, 'Piotr', 'Nowak', 
                TO_DATE('2000-09-20', 'YYYY-MM-DD'),
                'piotr.nowak@email.com', '600333444', SYSDATE)
);

INSERT INTO t_uczen VALUES (
    t_uczen_obj(3, 'Magdalena', 'Wisniewski', 
                TO_DATE('1995-03-10', 'YYYY-MM-DD'),
                'magda.w@email.com', '600555666', SYSDATE)
);

INSERT INTO t_uczen VALUES (
    t_uczen_obj(4, 'Krzysztof', 'Wojcik', 
                TO_DATE('1992-12-01', 'YYYY-MM-DD'),
                'krzysztof.w@email.com', '600777888', SYSDATE)
);

INSERT INTO t_uczen VALUES (
    t_uczen_obj(5, 'Aleksandra', 'Kaminska', 
                TO_DATE('2001-07-25', 'YYYY-MM-DD'),
                'ola.kaminska@email.com', '600999000', SYSDATE)
);

-- Uczniowie mlodzi (15-17 lat) - bez ograniczen
INSERT INTO t_uczen VALUES (
    t_uczen_obj(6, 'Jakub', 'Lewandowski', 
                TO_DATE('2008-02-14', 'YYYY-MM-DD'),
                'jakub.l.rodzic@email.com', '601111222', SYSDATE)
);

INSERT INTO t_uczen VALUES (
    t_uczen_obj(7, 'Natalia', 'Dabrowska', 
                TO_DATE('2009-08-30', 'YYYY-MM-DD'),
                'natalia.d.rodzic@email.com', '601333444', SYSDATE)
);

-- Dzieci (<15 lat) - lekcje TYLKO 14:00-19:00!
INSERT INTO t_uczen VALUES (
    t_uczen_obj(8, 'Michal', 'Zielinski', 
                TO_DATE('2012-04-18', 'YYYY-MM-DD'),
                'michal.z.rodzic@email.com', '602111222', SYSDATE)
);

INSERT INTO t_uczen VALUES (
    t_uczen_obj(9, 'Zofia', 'Szymanska', 
                TO_DATE('2013-11-05', 'YYYY-MM-DD'),
                'zofia.sz.rodzic@email.com', '602333444', SYSDATE)
);

INSERT INTO t_uczen VALUES (
    t_uczen_obj(10, 'Filip', 'Wozniak', 
                TO_DATE('2014-06-22', 'YYYY-MM-DD'),
                'filip.w.rodzic@email.com', '602555666', SYSDATE)
);

INSERT INTO t_uczen VALUES (
    t_uczen_obj(11, 'Maja', 'Kozlowska', 
                TO_DATE('2015-01-10', 'YYYY-MM-DD'),
                'maja.k.rodzic@email.com', '602777888', SYSDATE)
);

INSERT INTO t_uczen VALUES (
    t_uczen_obj(12, 'Adam', 'Jankowski', 
                TO_DATE('2016-09-28', 'YYYY-MM-DD'),
                'adam.j.rodzic@email.com', '602999000', SYSDATE)
);

PROMPT Dodano 12 uczniow (5 doroslych, 2 mlodych, 5 dzieci)

-- ============================================================================
-- NAUCZYCIELE
-- Max 6h pracy dziennie (360 minut)
-- ============================================================================

INSERT INTO t_nauczyciel VALUES (
    t_nauczyciel_obj(1, 'Maria', 'Polanska', 
                     TO_DATE('1980-03-25', 'YYYY-MM-DD'),
                     'maria.polanska@szkola.pl', '700111222',
                     t_lista_instrumentow('fortepian', 'keyboard'),
                     'magister', 15)
);

INSERT INTO t_nauczyciel VALUES (
    t_nauczyciel_obj(2, 'Jan', 'Kowalczyk', 
                     TO_DATE('1975-07-12', 'YYYY-MM-DD'),
                     'jan.kowalczyk@szkola.pl', '700333444',
                     t_lista_instrumentow('gitara klasyczna', 'gitara akustyczna', 'ukulele'),
                     'doktor', 20)
);

INSERT INTO t_nauczyciel VALUES (
    t_nauczyciel_obj(3, 'Ewa', 'Nowicka', 
                     TO_DATE('1985-11-30', 'YYYY-MM-DD'),
                     'ewa.nowicka@szkola.pl', '700555666',
                     t_lista_instrumentow('skrzypce', 'altowka'),
                     'magister', 10)
);

INSERT INTO t_nauczyciel VALUES (
    t_nauczyciel_obj(4, 'Tomasz', 'Adamski', 
                     TO_DATE('1978-09-05', 'YYYY-MM-DD'),
                     'tomasz.adamski@szkola.pl', '700777888',
                     t_lista_instrumentow('perkusja', 'instrumenty perkusyjne'),
                     'licencjat', 12)
);

INSERT INTO t_nauczyciel VALUES (
    t_nauczyciel_obj(5, 'Katarzyna', 'Mazur', 
                     TO_DATE('1982-06-18', 'YYYY-MM-DD'),
                     'katarzyna.mazur@szkola.pl', '700999000',
                     t_lista_instrumentow('spiew', 'emisja glosu'),
                     'magister', 8)
);

INSERT INTO t_nauczyciel VALUES (
    t_nauczyciel_obj(6, 'Robert', 'Kaczmarek', 
                     TO_DATE('1990-01-22', 'YYYY-MM-DD'),
                     'robert.k@szkola.pl', '701111222',
                     t_lista_instrumentow('teoria muzyki', 'ksztalcenie sluchowe'),
                     'doktor', 5)
);

PROMPT Dodano 6 nauczycieli

-- ============================================================================
-- KURSY
-- ============================================================================

INSERT INTO t_kurs VALUES (
    t_kurs_obj(1, 'Fortepian - poczatkujacy', 'indywidualny', 
               'Podstawy gry na fortepianie', 150.00, 45)
);

INSERT INTO t_kurs VALUES (
    t_kurs_obj(2, 'Fortepian - sredniozaawansowany', 'indywidualny', 
               'Rozszerzony program fortepianowy', 180.00, 60)
);

INSERT INTO t_kurs VALUES (
    t_kurs_obj(3, 'Gitara klasyczna', 'indywidualny', 
               'Gra na gitarze klasycznej', 140.00, 45)
);

INSERT INTO t_kurs VALUES (
    t_kurs_obj(4, 'Gitara akustyczna', 'indywidualny', 
               'Gra na gitarze akustycznej', 130.00, 45)
);

INSERT INTO t_kurs VALUES (
    t_kurs_obj(5, 'Skrzypce', 'indywidualny', 
               'Nauka gry na skrzypcach', 160.00, 45)
);

INSERT INTO t_kurs VALUES (
    t_kurs_obj(6, 'Perkusja', 'indywidualny', 
               'Nauka gry na perkusji', 145.00, 45)
);

INSERT INTO t_kurs VALUES (
    t_kurs_obj(7, 'Spiew - emisja glosu', 'indywidualny', 
               'Nauka spiewu i emisji glosu', 155.00, 45)
);

INSERT INTO t_kurs VALUES (
    t_kurs_obj(8, 'Teoria muzyki', 'grupowy', 
               'Podstawy teorii muzyki', 80.00, 60)
);

INSERT INTO t_kurs VALUES (
    t_kurs_obj(9, 'Ksztalcenie sluchowe', 'grupowy', 
               'Cwiczenia sluchowe i dyktanda', 85.00, 45)
);

INSERT INTO t_kurs VALUES (
    t_kurs_obj(10, 'Zespol kameralny', 'grupowy', 
                'Gra zespolowa, male koncerty', 100.00, 90)
);

PROMPT Dodano 10 kursow

-- ============================================================================
-- ZAPISY NA KURSY
-- ============================================================================

DECLARE
    v_ref_uczen REF t_uczen_obj;
    v_ref_kurs REF t_kurs_obj;
    v_ref_nauczyciel REF t_nauczyciel_obj;
BEGIN
    -- Anna na fortepian (Maria)
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 1;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 1;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    INSERT INTO t_zapis VALUES (
        t_zapis_obj(1, SYSDATE - 60, 'aktywny', v_ref_uczen, v_ref_kurs, v_ref_nauczyciel)
    );
    
    -- Piotr na gitare (Jan)
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 2;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 3;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 2;
    INSERT INTO t_zapis VALUES (
        t_zapis_obj(2, SYSDATE - 45, 'aktywny', v_ref_uczen, v_ref_kurs, v_ref_nauczyciel)
    );
    
    -- Magdalena na skrzypce (Ewa)
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 3;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 5;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 3;
    INSERT INTO t_zapis VALUES (
        t_zapis_obj(3, SYSDATE - 90, 'aktywny', v_ref_uczen, v_ref_kurs, v_ref_nauczyciel)
    );
    
    -- Krzysztof na perkusje (Tomasz)
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 4;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 6;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 4;
    INSERT INTO t_zapis VALUES (
        t_zapis_obj(4, SYSDATE - 30, 'aktywny', v_ref_uczen, v_ref_kurs, v_ref_nauczyciel)
    );
    
    -- Aleksandra na spiew (Katarzyna)
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 5;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 7;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 5;
    INSERT INTO t_zapis VALUES (
        t_zapis_obj(5, SYSDATE - 15, 'aktywny', v_ref_uczen, v_ref_kurs, v_ref_nauczyciel)
    );
    
    -- Jakub (mlody) na fortepian (Maria)
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 6;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 1;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    INSERT INTO t_zapis VALUES (
        t_zapis_obj(6, SYSDATE - 120, 'aktywny', v_ref_uczen, v_ref_kurs, v_ref_nauczyciel)
    );
    
    -- Natalia (mloda) na gitare (Jan)
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 7;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 4;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 2;
    INSERT INTO t_zapis VALUES (
        t_zapis_obj(7, SYSDATE - 75, 'aktywny', v_ref_uczen, v_ref_kurs, v_ref_nauczyciel)
    );
    
    -- Dzieci (<15 lat) - zapisy na kursy
    -- Michal na fortepian
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 8;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 1;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    INSERT INTO t_zapis VALUES (
        t_zapis_obj(8, SYSDATE - 100, 'aktywny', v_ref_uczen, v_ref_kurs, v_ref_nauczyciel)
    );
    
    -- Zofia na skrzypce
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 9;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 5;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 3;
    INSERT INTO t_zapis VALUES (
        t_zapis_obj(9, SYSDATE - 50, 'aktywny', v_ref_uczen, v_ref_kurs, v_ref_nauczyciel)
    );
    
    -- Filip na gitare
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 10;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 3;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 2;
    INSERT INTO t_zapis VALUES (
        t_zapis_obj(10, SYSDATE - 40, 'aktywny', v_ref_uczen, v_ref_kurs, v_ref_nauczyciel)
    );
    
    -- Maja na spiew
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 11;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 7;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 5;
    INSERT INTO t_zapis VALUES (
        t_zapis_obj(11, SYSDATE - 25, 'aktywny', v_ref_uczen, v_ref_kurs, v_ref_nauczyciel)
    );
    
    -- Adam na perkusje
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 12;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 6;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 4;
    INSERT INTO t_zapis VALUES (
        t_zapis_obj(12, SYSDATE - 35, 'aktywny', v_ref_uczen, v_ref_kurs, v_ref_nauczyciel)
    );
    
    -- Dodatkowe zapisy na teorie muzyki (kursy grupowe)
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 8;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 6;
    
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 1;
    INSERT INTO t_zapis VALUES (
        t_zapis_obj(13, SYSDATE - 60, 'aktywny', v_ref_uczen, v_ref_kurs, v_ref_nauczyciel)
    );
    
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 3;
    INSERT INTO t_zapis VALUES (
        t_zapis_obj(14, SYSDATE - 60, 'aktywny', v_ref_uczen, v_ref_kurs, v_ref_nauczyciel)
    );
    
    COMMIT;
END;
/

PROMPT Dodano 14 zapisow na kursy

-- ============================================================================
-- LEKCJE
-- Uwaga: Dzieci (<15 lat) tylko 14:00-19:00!
-- Semestr aktywny: letni 2024/2025 (17.02.2025 - 30.06.2025)
-- ============================================================================

DECLARE
    v_ref_uczen REF t_uczen_obj;
    v_ref_nauczyciel REF t_nauczyciel_obj;
    v_ref_kurs REF t_kurs_obj;
    v_ref_sala REF t_sala_obj;
    v_data DATE := TO_DATE('2025-05-20', 'YYYY-MM-DD');
BEGIN
    -- ========== LEKCJE DOROSLYCH (bez ograniczen godzinowych) ==========
    
    -- Anna (ID 1) - fortepian - moze byc rano
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 1;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 1;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 1;
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(1, v_data, '09:00', 45, 'Sonaty Mozarta', 'Bardzo dobra technika', 'odbyta',
                     v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
    );
    
    -- Piotr (ID 2) - gitara - rano
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 2;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 2;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 3;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 3;
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(2, v_data, '10:00', 45, 'Akordy barowe', NULL, 'odbyta',
                     v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
    );
    
    -- Magdalena (ID 3) - skrzypce - rano
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 3;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 3;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 5;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 5;
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(3, v_data, '11:00', 45, 'Vibrato', 'Popracowac nad intonacja', 'odbyta',
                     v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
    );
    
    -- Krzysztof (ID 4) - perkusja - poludnie
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 4;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 4;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 6;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 4;
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(4, v_data, '12:00', 45, 'Rytmy rockowe', NULL, 'odbyta',
                     v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
    );
    
    -- Aleksandra (ID 5) - spiew - poludnie
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 5;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 5;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 7;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 6;
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(5, v_data, '13:00', 45, 'Oddychanie przeponowe', 'Swietny postep', 'odbyta',
                     v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
    );
    
    -- ========== LEKCJE DZIECI - TYLKO 14:00-19:00! ==========
    
    -- Michal (ID 8, dziecko) - fortepian - 14:00
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 8;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 1;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 1;
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(6, v_data, '14:00', 45, 'Gamy', 'Dobra lekcja', 'odbyta',
                     v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
    );
    
    -- Zofia (ID 9, dziecko) - skrzypce - 15:00
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 9;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 3;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 5;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 5;
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(7, v_data, '15:00', 45, 'Pozycje smyczka', NULL, 'odbyta',
                     v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
    );
    
    -- Filip (ID 10, dziecko) - gitara - 16:00
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 10;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 2;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 3;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 3;
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(8, v_data, '16:00', 45, 'Pierwsze akordy', 'Zdolny uczen', 'odbyta',
                     v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
    );
    
    -- Maja (ID 11, dziecko) - spiew - 17:00
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 11;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 5;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 7;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 6;
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(9, v_data, '17:00', 45, 'Piosenki dzieciece', NULL, 'odbyta',
                     v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
    );
    
    -- Adam (ID 12, dziecko) - perkusja - 18:00
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 12;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 4;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 6;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 4;
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(10, v_data, '18:00', 45, 'Podstawy rytmu', 'Bardzo zdolny', 'odbyta',
                     v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
    );
    
    -- ========== LEKCJE ZAPLANOWANE NA PRZYSZLOSC ==========
    
    v_data := TO_DATE('2025-05-27', 'YYYY-MM-DD');
    
    -- Anna - zaplanowana
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 1;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 1;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 1;
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(11, v_data, '09:00', 45, NULL, NULL, 'zaplanowana',
                     v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
    );
    
    -- Piotr - zaplanowana
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 2;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 2;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 3;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 3;
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(12, v_data, '10:00', 45, NULL, NULL, 'zaplanowana',
                     v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
    );
    
    -- Michal (dziecko) - zaplanowana 14:30
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 8;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 1;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 2;
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(13, v_data, '14:30', 45, NULL, NULL, 'zaplanowana',
                     v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
    );
    
    -- Zofia (dziecko) - zaplanowana 16:00
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 9;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 3;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 5;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 5;
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(14, v_data, '16:00', 45, NULL, NULL, 'zaplanowana',
                     v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
    );
    
    -- Lekcja odwolana
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 5;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 5;
    SELECT REF(k) INTO v_ref_kurs FROM t_kurs k WHERE k.id_kursu = 7;
    SELECT REF(s) INTO v_ref_sala FROM t_sala s WHERE s.id_sali = 6;
    INSERT INTO t_lekcja VALUES (
        t_lekcja_obj(15, v_data, '13:00', 45, NULL, 'Choroba', 'odwolana',
                     v_ref_uczen, v_ref_nauczyciel, v_ref_kurs, v_ref_sala)
    );
    
    COMMIT;
END;
/

PROMPT Dodano 15 lekcji (10 odbytych, 4 zaplanowane, 1 odwolana)

-- ============================================================================
-- OCENY POSTEPU
-- ============================================================================

DECLARE
    v_ref_uczen REF t_uczen_obj;
    v_ref_nauczyciel REF t_nauczyciel_obj;
BEGIN
    -- Oceny Anny (fortepian)
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 1;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(1, SYSDATE - 30, 5, 'Bardzo dobra technika', 'technika', v_ref_uczen, v_ref_nauczyciel)
    );
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(2, SYSDATE - 20, 4, 'Popracowac nad dynamika', 'interpretacja', v_ref_uczen, v_ref_nauczyciel)
    );
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(3, SYSDATE - 10, 5, 'Swietny postep', 'ogolna', v_ref_uczen, v_ref_nauczyciel)
    );
    
    -- Oceny Piotra (gitara)
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 2;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 2;
    
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(4, SYSDATE - 25, 4, 'Dobra koordynacja', 'technika', v_ref_uczen, v_ref_nauczyciel)
    );
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(5, SYSDATE - 15, 4, NULL, 'sluch', v_ref_uczen, v_ref_nauczyciel)
    );
    
    -- Oceny Magdaleny (skrzypce)
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 3;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 3;
    
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(6, SYSDATE - 45, 5, 'Talent', 'ogolna', v_ref_uczen, v_ref_nauczyciel)
    );
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(7, SYSDATE - 30, 5, 'Dobry postep', 'technika', v_ref_uczen, v_ref_nauczyciel)
    );
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(8, SYSDATE - 15, 6, 'Wybitna interpretacja', 'interpretacja', v_ref_uczen, v_ref_nauczyciel)
    );
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(9, SYSDATE - 5, 5, NULL, 'ogolna', v_ref_uczen, v_ref_nauczyciel)
    );
    
    -- Oceny Krzysztofa (perkusja)
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 4;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 4;
    
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(10, SYSDATE - 20, 4, 'Dobry rytm', 'technika', v_ref_uczen, v_ref_nauczyciel)
    );
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(11, SYSDATE - 10, 4, NULL, 'ogolna', v_ref_uczen, v_ref_nauczyciel)
    );
    
    -- Oceny Aleksandry (spiew)
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 5;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 5;
    
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(12, SYSDATE - 10, 5, 'Piekny glos', 'technika', v_ref_uczen, v_ref_nauczyciel)
    );
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(13, SYSDATE - 3, 5, 'Swietna emisja', 'ogolna', v_ref_uczen, v_ref_nauczyciel)
    );
    
    -- Oceny dzieci
    -- Michal
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 8;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 1;
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(14, SYSDATE - 15, 4, 'Dobry poczatek', 'ogolna', v_ref_uczen, v_ref_nauczyciel)
    );
    
    -- Zofia
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 9;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 3;
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(15, SYSDATE - 12, 5, 'Zdolna', 'technika', v_ref_uczen, v_ref_nauczyciel)
    );
    
    -- Filip
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 10;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 2;
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(16, SYSDATE - 8, 4, 'Postep', 'ogolna', v_ref_uczen, v_ref_nauczyciel)
    );
    
    -- Maja
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 11;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 5;
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(17, SYSDATE - 5, 5, 'Ladny glosik', 'technika', v_ref_uczen, v_ref_nauczyciel)
    );
    
    -- Adam
    SELECT REF(u) INTO v_ref_uczen FROM t_uczen u WHERE u.id_ucznia = 12;
    SELECT REF(n) INTO v_ref_nauczyciel FROM t_nauczyciel n WHERE n.id_nauczyciela = 4;
    INSERT INTO t_ocena_postepu VALUES (
        t_ocena_obj(18, SYSDATE - 3, 5, 'Bardzo zdolny', 'rytm', v_ref_uczen, v_ref_nauczyciel)
    );
    
    COMMIT;
END;
/

PROMPT Dodano 18 ocen postepu

-- ============================================================================
-- RESET SEKWENCJI
-- ============================================================================

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_semestr';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_semestr START WITH 4';
    
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_sala';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_sala START WITH 9';
    
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_uczen';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_uczen START WITH 13';
    
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_nauczyciel';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_nauczyciel START WITH 7';
    
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_kurs';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_kurs START WITH 11';
    
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_zapis';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_zapis START WITH 15';
    
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_lekcja';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_lekcja START WITH 16';
    
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_ocena';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_ocena START WITH 19';
END;
/

PROMPT Zresetowano sekwencje

-- ============================================================================
-- PODSUMOWANIE DANYCH - WERSJA 2.0
-- ============================================================================
/*
PODSUMOWANIE DANYCH TESTOWYCH:

1. Semestry: 3
   - zimowy 2024/2025 (nieaktywny)
   - letni 2024/2025 (AKTYWNY)
   - zimowy 2025/2026 (nieaktywny)

2. Sale: 8
   - 2 sale fortepianowe
   - 1 sala gitarowa
   - 1 sala perkusyjna
   - 1 sala skrzypcowa
   - 1 sala wokalna
   - 1 sala kameralna
   - 1 sala teorii

3. Uczniowie: 12
   - 5 doroslych (18+): ID 1-5
   - 2 mlodych (15-17): ID 6-7
   - 5 dzieci (<15): ID 8-12 (lekcje 14:00-19:00!)

4. Nauczyciele: 6 (limit 6h/dzien)

5. Kursy: 10
   - 7 indywidualnych
   - 3 grupowe

6. Zapisy: 14

7. Lekcje: 15
   - 10 odbytych
   - 4 zaplanowane
   - 1 odwolana
   - Dzieci maja lekcje 14:00-19:00

8. Oceny: 18

UWAGI DO TESTOW:
- Dzieci (ID 8-12) - testowac blokade lekcji przed 14:00
- Nauczyciele - testowac limit 6h dziennie
- Sale - testowac konflikty
- Semestr - testowac jeden aktywny
*/

PROMPT ========================================
PROMPT Dane testowe zaladowane pomyslnie!
PROMPT Wersja 2.0 - z salami i semestrami
PROMPT ========================================
