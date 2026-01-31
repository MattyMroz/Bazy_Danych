-- ============================================================================
-- PLIK: 02_tabele.sql
-- PROJEKT: Szkola Muzyczna v5 - Obiektowa Baza Danych Oracle
-- AUTORZY: Igor Typinski (251237), Mateusz Mroz (251190)
-- DATA: Styczen 2026
-- ============================================================================
-- Tworzy 10 TABEL OBIEKTOWYCH, SEKWENCJE, CONSTRAINTY i INDEKSY
-- Kolejnosc: semestry -> instrumenty -> sale -> nauczyciele -> grupy
--            -> uczniowie -> przedmioty -> lekcje -> egzaminy -> oceny
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200
SET PAGESIZE 50

PROMPT ========================================================================
PROMPT   02_tabele.sql - Tworzenie tabel obiektowych
PROMPT ========================================================================
PROMPT

-- ============================================================================
-- 1. TABELA: SEMESTRY
-- ============================================================================

PROMPT [1/10] Tworzenie tabeli semestry...

CREATE SEQUENCE seq_semestry START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE semestry OF t_semestr_obj (
    id_semestru PRIMARY KEY,
    nazwa NOT NULL,
    data_start NOT NULL,
    data_koniec NOT NULL,
    rok_szkolny NOT NULL,
    CONSTRAINT chk_sem_daty CHECK (data_koniec > data_start),
    CONSTRAINT chk_sem_rok CHECK (REGEXP_LIKE(rok_szkolny, '^\d{4}/\d{4}$'))
);

CREATE INDEX idx_sem_rok ON semestry(rok_szkolny);
CREATE INDEX idx_sem_daty ON semestry(data_start, data_koniec);

-- ============================================================================
-- 2. TABELA: INSTRUMENTY
-- ============================================================================

PROMPT [2/10] Tworzenie tabeli instrumenty...

CREATE SEQUENCE seq_instrumenty START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE instrumenty OF t_instrument_obj (
    id_instrumentu PRIMARY KEY,
    nazwa NOT NULL,
    kategoria NOT NULL,
    czy_wymaga_akompaniatora DEFAULT 'N' NOT NULL,
    CONSTRAINT chk_instr_kat CHECK (
        kategoria IN ('klawiszowe', 'strunowe', 'dete', 'perkusyjne')
    ),
    CONSTRAINT chk_instr_akomp CHECK (czy_wymaga_akompaniatora IN ('T', 'N')),
    CONSTRAINT uq_instr_nazwa UNIQUE (nazwa)
);

CREATE INDEX idx_instr_kat ON instrumenty(kategoria);

-- ============================================================================
-- 3. TABELA: SALE
-- ============================================================================

PROMPT [3/10] Tworzenie tabeli sale...

CREATE SEQUENCE seq_sale START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE sale OF t_sala_obj (
    id_sali PRIMARY KEY,
    numer NOT NULL,
    typ_sali NOT NULL,
    pojemnosc NOT NULL,
    status DEFAULT 'aktywna' NOT NULL,
    CONSTRAINT chk_sala_typ CHECK (
        typ_sali IN ('indywidualna', 'grupowa', 'wielofunkcyjna')
    ),
    CONSTRAINT chk_sala_poj CHECK (pojemnosc BETWEEN 1 AND 50),
    CONSTRAINT chk_sala_status CHECK (status IN ('aktywna', 'remont', 'nieczynna')),
    CONSTRAINT uq_sala_numer UNIQUE (numer)
);

CREATE INDEX idx_sala_typ ON sale(typ_sali);
CREATE INDEX idx_sala_status ON sale(status);

-- ============================================================================
-- 4. TABELA: NAUCZYCIELE
-- ============================================================================

PROMPT [4/10] Tworzenie tabeli nauczyciele...

CREATE SEQUENCE seq_nauczyciele START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE nauczyciele OF t_nauczyciel_obj (
    id_nauczyciela PRIMARY KEY,
    imie NOT NULL,
    nazwisko NOT NULL,
    email NOT NULL,
    data_zatrudnienia NOT NULL,
    czy_prowadzi_grupowe DEFAULT 'N' NOT NULL,
    czy_akompaniator DEFAULT 'N' NOT NULL,
    status DEFAULT 'aktywny' NOT NULL,
    CONSTRAINT chk_naucz_email CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')),
    CONSTRAINT chk_naucz_grupowe CHECK (czy_prowadzi_grupowe IN ('T', 'N')),
    CONSTRAINT chk_naucz_akomp CHECK (czy_akompaniator IN ('T', 'N')),
    CONSTRAINT chk_naucz_status CHECK (status IN ('aktywny', 'nieaktywny', 'urlop')),
    CONSTRAINT uq_naucz_email UNIQUE (email)
);

CREATE INDEX idx_naucz_nazwisko ON nauczyciele(nazwisko);
CREATE INDEX idx_naucz_status ON nauczyciele(status);

-- ============================================================================
-- 5. TABELA: GRUPY
-- ============================================================================

PROMPT [5/10] Tworzenie tabeli grupy...

CREATE SEQUENCE seq_grupy START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE grupy OF t_grupa_obj (
    id_grupy PRIMARY KEY,
    nazwa NOT NULL,
    klasa NOT NULL,
    rok_szkolny NOT NULL,
    max_uczniow DEFAULT 15 NOT NULL,
    status DEFAULT 'aktywna' NOT NULL,
    CONSTRAINT chk_grupa_klasa CHECK (klasa BETWEEN 1 AND 6),
    CONSTRAINT chk_grupa_max CHECK (max_uczniow BETWEEN 5 AND 30),
    CONSTRAINT chk_grupa_rok CHECK (REGEXP_LIKE(rok_szkolny, '^\d{4}/\d{4}$')),
    CONSTRAINT chk_grupa_status CHECK (status IN ('aktywna', 'archiwalna')),
    CONSTRAINT uq_grupa_nazwa_rok UNIQUE (nazwa, rok_szkolny)
);

CREATE INDEX idx_grupa_klasa ON grupy(klasa);
CREATE INDEX idx_grupa_rok ON grupy(rok_szkolny);

-- ============================================================================
-- 6. TABELA: UCZNIOWIE
-- ============================================================================

PROMPT [6/10] Tworzenie tabeli uczniowie...

CREATE SEQUENCE seq_uczniowie START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE uczniowie OF t_uczen_obj (
    id_ucznia PRIMARY KEY,
    imie NOT NULL,
    nazwisko NOT NULL,
    data_urodzenia NOT NULL,
    data_zapisu NOT NULL,
    klasa NOT NULL,
    cykl_nauczania DEFAULT 6 NOT NULL,
    typ_ucznia DEFAULT 'uczacy_sie_w_innej_szkole' NOT NULL,
    status DEFAULT 'aktywny' NOT NULL,
    ref_instrument SCOPE IS instrumenty,
    ref_grupa SCOPE IS grupy,
    CONSTRAINT chk_uczen_klasa CHECK (klasa BETWEEN 1 AND 6),
    CONSTRAINT chk_uczen_cykl CHECK (cykl_nauczania IN (4, 6)),
    CONSTRAINT chk_uczen_typ CHECK (
        typ_ucznia IN ('uczacy_sie_w_innej_szkole', 'ukonczyl_edukacje', 'tylko_muzyczna')
    ),
    CONSTRAINT chk_uczen_status CHECK (status IN ('aktywny', 'zawieszony', 'absolwent', 'skreslony'))
);

CREATE INDEX idx_uczen_nazwisko ON uczniowie(nazwisko);
CREATE INDEX idx_uczen_klasa ON uczniowie(klasa);
CREATE INDEX idx_uczen_typ ON uczniowie(typ_ucznia);
CREATE INDEX idx_uczen_status ON uczniowie(status);

-- ============================================================================
-- 7. TABELA: PRZEDMIOTY
-- ============================================================================

PROMPT [7/10] Tworzenie tabeli przedmioty...

CREATE SEQUENCE seq_przedmioty START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE przedmioty OF t_przedmiot_obj (
    id_przedmiotu PRIMARY KEY,
    nazwa NOT NULL,
    typ_zajec NOT NULL,
    wymiar_minut NOT NULL,
    klasy_od NOT NULL,
    klasy_do NOT NULL,
    czy_obowiazkowy DEFAULT 'T' NOT NULL,
    ref_instrument SCOPE IS instrumenty,
    CONSTRAINT chk_przedm_typ CHECK (typ_zajec IN ('indywidualny', 'grupowy')),
    CONSTRAINT chk_przedm_minuty CHECK (wymiar_minut IN (30, 45, 60, 90)),
    CONSTRAINT chk_przedm_klasy CHECK (klasy_od <= klasy_do AND klasy_od BETWEEN 1 AND 6),
    CONSTRAINT chk_przedm_obow CHECK (czy_obowiazkowy IN ('T', 'N'))
);

CREATE INDEX idx_przedm_typ ON przedmioty(typ_zajec);
CREATE INDEX idx_przedm_klasy ON przedmioty(klasy_od, klasy_do);

-- ============================================================================
-- 8. TABELA: LEKCJE
-- Centralna tabela transakcyjna - 6 referencji REF
-- Regula XOR: uczen XOR grupa (nie oba)
-- ============================================================================

PROMPT [8/10] Tworzenie tabeli lekcje...

CREATE SEQUENCE seq_lekcje START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE lekcje OF t_lekcja_obj (
    id_lekcji PRIMARY KEY,
    data_lekcji NOT NULL,
    godzina_start NOT NULL,
    czas_trwania NOT NULL,
    typ_lekcji NOT NULL,
    status DEFAULT 'zaplanowana' NOT NULL,
    ref_przedmiot SCOPE IS przedmioty NOT NULL,
    ref_nauczyciel SCOPE IS nauczyciele NOT NULL,
    ref_akompaniator SCOPE IS nauczyciele,
    ref_sala SCOPE IS sale NOT NULL,
    ref_uczen SCOPE IS uczniowie,
    ref_grupa SCOPE IS grupy,
    CONSTRAINT chk_lek_godzina CHECK (REGEXP_LIKE(godzina_start, '^([01][0-9]|2[0-3]):[0-5][0-9]$')),
    CONSTRAINT chk_lek_czas CHECK (czas_trwania IN (30, 45, 60, 90)),
    CONSTRAINT chk_lek_typ CHECK (typ_lekcji IN ('indywidualna', 'grupowa')),
    CONSTRAINT chk_lek_status CHECK (status IN ('zaplanowana', 'odbyta', 'odwolana', 'przerwana')),
    CONSTRAINT chk_lek_xor CHECK (
        (ref_uczen IS NOT NULL AND ref_grupa IS NULL) OR
        (ref_uczen IS NULL AND ref_grupa IS NOT NULL)
    )
);

CREATE INDEX idx_lek_data ON lekcje(data_lekcji);
CREATE INDEX idx_lek_status ON lekcje(status);
CREATE INDEX idx_lek_data_godz ON lekcje(data_lekcji, godzina_start);

-- ============================================================================
-- 9. TABELA: EGZAMINY
-- Komisja musi byc 2 roznych nauczycieli (trigger)
-- ============================================================================

PROMPT [9/10] Tworzenie tabeli egzaminy...

CREATE SEQUENCE seq_egzaminy START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE egzaminy OF t_egzamin_obj (
    id_egzaminu PRIMARY KEY,
    data_egzaminu NOT NULL,
    godzina NOT NULL,
    typ_egzaminu NOT NULL,
    ref_uczen SCOPE IS uczniowie NOT NULL,
    ref_przedmiot SCOPE IS przedmioty NOT NULL,
    ref_komisja1 SCOPE IS nauczyciele NOT NULL,
    ref_komisja2 SCOPE IS nauczyciele NOT NULL,
    ref_sala SCOPE IS sale NOT NULL,
    CONSTRAINT chk_egz_godzina CHECK (REGEXP_LIKE(godzina, '^([01][0-9]|2[0-3]):[0-5][0-9]$')),
    CONSTRAINT chk_egz_typ CHECK (
        typ_egzaminu IN ('wstepny', 'promocyjny', 'semestralny', 'koncowy', 'poprawkowy', 'klasyfikacyjny')
    ),
    CONSTRAINT chk_egz_ocena CHECK (ocena_koncowa IS NULL OR ocena_koncowa BETWEEN 1 AND 6)
);

CREATE INDEX idx_egz_data ON egzaminy(data_egzaminu);
CREATE INDEX idx_egz_typ ON egzaminy(typ_egzaminu);

-- ============================================================================
-- 10. TABELA: OCENY
-- Oceny biezace (czastkowe) - nie egzaminacyjne
-- ============================================================================

PROMPT [10/10] Tworzenie tabeli oceny...

CREATE SEQUENCE seq_oceny START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE oceny OF t_ocena_obj (
    id_oceny PRIMARY KEY,
    data_oceny NOT NULL,
    wartosc NOT NULL,
    obszar NOT NULL,
    ref_uczen SCOPE IS uczniowie NOT NULL,
    ref_nauczyciel SCOPE IS nauczyciele NOT NULL,
    ref_przedmiot SCOPE IS przedmioty NOT NULL,
    ref_lekcja SCOPE IS lekcje,
    CONSTRAINT chk_ocena_wartosc CHECK (wartosc BETWEEN 1 AND 6),
    CONSTRAINT chk_ocena_obszar CHECK (
        obszar IN ('technika', 'interpretacja', 'sluch', 'teoria', 'rytm', 'ogolna')
    )
);

CREATE INDEX idx_ocena_data ON oceny(data_oceny);
CREATE INDEX idx_ocena_wartosc ON oceny(wartosc);
CREATE INDEX idx_ocena_obszar ON oceny(obszar);

-- ============================================================================
-- PODSUMOWANIE
-- ============================================================================

PROMPT
PROMPT ========================================================================
PROMPT   UTWORZONE OBIEKTY
PROMPT ========================================================================
PROMPT   SEKWENCJE: 10 (seq_semestry, seq_instrumenty, ...)
PROMPT   TABELE: 10 (semestry, instrumenty, sale, nauczyciele, grupy,
PROMPT               uczniowie, przedmioty, lekcje, egzaminy, oceny)
PROMPT   INDEKSY: 17
PROMPT   CONSTRAINTY: walidacja danych, CHECK, UNIQUE
PROMPT ========================================================================
PROMPT   Nastepny krok: Uruchom 03_triggery.sql
PROMPT ========================================================================

SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('TABLE', 'SEQUENCE', 'INDEX')
ORDER BY object_type, object_name;
