-- ============================================================================
-- Projekt: Obiektowa Baza Danych - Szkola Muzyczna
-- Plik: 01_typy.sql
-- Opis: Definicje typow obiektowych i kolekcji
-- Wersja: 2.0
-- Autorzy: Igor Typinski (251237), Mateusz Mroz (251190)
-- ============================================================================

-- ============================================================================
-- CZYSZCZENIE (usuwanie istniejacych typow w odpowiedniej kolejnosci)
-- ============================================================================

-- Najpierw usuwamy tabele (jesli istnieja)
BEGIN EXECUTE IMMEDIATE 'DROP TABLE t_audit_log CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE t_ocena_postepu CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE t_lekcja CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE t_kurs CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE t_uczen CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE t_nauczyciel CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE t_instrument CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE t_sala CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE t_semestr CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- Usuwamy typy (od najbardziej zaleznych)
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_ocena_obj FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_lekcja_obj FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_kurs_obj FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_uczen_obj FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_nauczyciel_obj FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_lista_instrumentow FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_instrument_obj FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_sala_obj FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE t_semestr_obj FORCE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ============================================================================
-- 1. TYP: T_INSTRUMENT_OBJ
-- Opis: Reprezentuje instrument muzyczny w szkole
-- Atrybuty: id, nazwa, kategoria (dety/strunowe/perkusyjne/klawiszowe)
-- ============================================================================
CREATE OR REPLACE TYPE t_instrument_obj AS OBJECT (
    id_instrumentu  NUMBER,
    nazwa           VARCHAR2(100),
    kategoria       VARCHAR2(50),
    
    MEMBER FUNCTION opis RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_instrument_obj AS
    MEMBER FUNCTION opis RETURN VARCHAR2 IS
    BEGIN
        RETURN nazwa || ' (kategoria: ' || kategoria || ')';
    END opis;
END;
/

-- ============================================================================
-- 2. TYP: T_LISTA_INSTRUMENTOW (VARRAY)
-- Opis: Kolekcja nazw instrumentow - nauczyciel moze uczyc max 5 instrumentow
-- Uzycie: Pole w t_nauczyciel_obj - relacja 1:N bez osobnej tabeli
-- ============================================================================
CREATE OR REPLACE TYPE t_lista_instrumentow AS VARRAY(5) OF VARCHAR2(100);
/

-- ============================================================================
-- 3. TYP: T_SALA_OBJ (NOWY w v2.0)
-- Opis: Reprezentuje sale lekcyjna w szkole muzycznej
-- Atrybuty: id, nazwa, pojemnosc, wyposazenie (flagi), opis
-- Cel: Kontrola konfliktow sal i dopasowanie do kursu
-- ============================================================================
CREATE OR REPLACE TYPE t_sala_obj AS OBJECT (
    id_sali         NUMBER,
    nazwa           VARCHAR2(50),
    pojemnosc       NUMBER,
    ma_fortepian    CHAR(1),
    ma_perkusje     CHAR(1),
    opis            VARCHAR2(200),
    
    MEMBER FUNCTION opis_pelny RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_sala_obj AS
    MEMBER FUNCTION opis_pelny RETURN VARCHAR2 IS
        v_wyposazenie VARCHAR2(100) := '';
    BEGIN
        IF ma_fortepian = 'T' THEN
            v_wyposazenie := v_wyposazenie || 'fortepian ';
        END IF;
        IF ma_perkusje = 'T' THEN
            v_wyposazenie := v_wyposazenie || 'perkusja ';
        END IF;
        IF v_wyposazenie IS NULL THEN
            v_wyposazenie := 'brak specjalnego';
        END IF;
        RETURN nazwa || ' (poj: ' || pojemnosc || ', wyp: ' || TRIM(v_wyposazenie) || ')';
    END opis_pelny;
END;
/

-- ============================================================================
-- 4. TYP: T_SEMESTR_OBJ (NOWY w v2.0)
-- Opis: Reprezentuje semestr akademicki/szkolny
-- Atrybuty: id, nazwa, daty graniczne, flaga aktywnosci
-- Cel: Ramy czasowe dla planowania - lekcje tylko w aktywnym semestrze
-- Ograniczenie: Tylko 1 semestr moze byc aktywny w danym momencie
-- ============================================================================
CREATE OR REPLACE TYPE t_semestr_obj AS OBJECT (
    id_semestru     NUMBER,
    nazwa           VARCHAR2(50),
    data_od         DATE,
    data_do         DATE,
    czy_aktywny     CHAR(1),
    
    MEMBER FUNCTION czy_w_trakcie RETURN VARCHAR2,
    MEMBER FUNCTION dni_do_konca RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY t_semestr_obj AS
    MEMBER FUNCTION czy_w_trakcie RETURN VARCHAR2 IS
    BEGIN
        IF SYSDATE BETWEEN data_od AND data_do THEN
            RETURN 'TAK';
        ELSE
            RETURN 'NIE';
        END IF;
    END czy_w_trakcie;
    
    MEMBER FUNCTION dni_do_konca RETURN NUMBER IS
    BEGIN
        IF SYSDATE > data_do THEN
            RETURN 0;
        ELSIF SYSDATE < data_od THEN
            RETURN data_do - data_od;
        ELSE
            RETURN TRUNC(data_do - SYSDATE);
        END IF;
    END dni_do_konca;
END;
/

-- ============================================================================
-- 5. TYP: T_NAUCZYCIEL_OBJ
-- Opis: Reprezentuje nauczyciela w szkole muzycznej
-- Atrybuty: dane osobowe, kontakt, data zatrudnienia, lista instrumentow (VARRAY)
-- Metody: pelne_dane, czy_senior (>10 lat stazu), lata_stazu
-- Ograniczenie: Max 6h lekcji dziennie (sprawdzane przez trigger)
-- ============================================================================
CREATE OR REPLACE TYPE t_nauczyciel_obj AS OBJECT (
    id_nauczyciela  NUMBER,
    imie            VARCHAR2(50),
    nazwisko        VARCHAR2(50),
    email           VARCHAR2(100),
    telefon         VARCHAR2(20),
    data_zatrudnienia DATE,
    instrumenty     t_lista_instrumentow,
    
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2,
    MEMBER FUNCTION czy_senior RETURN VARCHAR2,
    MEMBER FUNCTION lata_stazu RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY t_nauczyciel_obj AS
    
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2 IS
    BEGIN
        RETURN imie || ' ' || nazwisko || ' (tel: ' || telefon || ')';
    END pelne_dane;
    
    MEMBER FUNCTION czy_senior RETURN VARCHAR2 IS
    BEGIN
        IF MONTHS_BETWEEN(SYSDATE, data_zatrudnienia) / 12 > 10 THEN
            RETURN 'TAK';
        ELSE
            RETURN 'NIE';
        END IF;
    END czy_senior;
    
    MEMBER FUNCTION lata_stazu RETURN NUMBER IS
    BEGIN
        RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, data_zatrudnienia) / 12);
    END lata_stazu;
    
END;
/

-- ============================================================================
-- 6. TYP: T_UCZEN_OBJ
-- Opis: Reprezentuje ucznia szkoly muzycznej
-- Atrybuty: dane osobowe, data urodzenia (do obliczenia wieku), kontakt, data zapisu
-- Metody: wiek, pelne_dane, czy_pelnoletni
-- Ograniczenia (sprawdzane przez triggery):
--   - Minimalny wiek: 5 lat
--   - Dzieci <15 lat: lekcje tylko 14:00-19:00 (szkola normalna do 14:00)
--   - Max 2 lekcje dziennie
-- ============================================================================
CREATE OR REPLACE TYPE t_uczen_obj AS OBJECT (
    id_ucznia       NUMBER,
    imie            VARCHAR2(50),
    nazwisko        VARCHAR2(50),
    data_urodzenia  DATE,
    email           VARCHAR2(100),
    telefon         VARCHAR2(20),
    data_zapisu     DATE,
    
    MEMBER FUNCTION wiek RETURN NUMBER,
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2,
    MEMBER FUNCTION czy_pelnoletni RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_uczen_obj AS
    
    MEMBER FUNCTION wiek RETURN NUMBER IS
    BEGIN
        RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, data_urodzenia) / 12);
    END wiek;
    
    MEMBER FUNCTION pelne_dane RETURN VARCHAR2 IS
    BEGIN
        RETURN imie || ' ' || nazwisko || ' (wiek: ' || SELF.wiek() || ' lat)';
    END pelne_dane;
    
    MEMBER FUNCTION czy_pelnoletni RETURN VARCHAR2 IS
    BEGIN
        IF SELF.wiek() >= 18 THEN
            RETURN 'TAK';
        ELSE
            RETURN 'NIE';
        END IF;
    END czy_pelnoletni;
    
END;
/

-- ============================================================================
-- 7. TYP: T_KURS_OBJ
-- Opis: Reprezentuje kurs nauki gry na instrumencie
-- Atrybuty: id, nazwa, poziom, cena, referencja do instrumentu
-- Poziomy: poczatkujacy, sredni, zaawansowany
-- REF: Wskazuje na instrument ktorego dotyczy kurs
-- ============================================================================
CREATE OR REPLACE TYPE t_kurs_obj AS OBJECT (
    id_kursu        NUMBER,
    nazwa           VARCHAR2(100),
    poziom          VARCHAR2(20),
    cena_za_lekcje  NUMBER(10,2),
    ref_instrument  REF t_instrument_obj,
    
    MEMBER FUNCTION info_kursu RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_kurs_obj AS
    
    MEMBER FUNCTION info_kursu RETURN VARCHAR2 IS
    BEGIN
        RETURN nazwa || ' [' || poziom || '] - ' || cena_za_lekcje || ' PLN/lekcja';
    END info_kursu;
    
END;
/

-- ============================================================================
-- 8. TYP: T_LEKCJA_OBJ (ZMODYFIKOWANY w v2.0)
-- Opis: Reprezentuje pojedyncza lekcje muzyki
-- Atrybuty: id, data, godzina, czas, temat, uwagi, status
-- REF: uczen, nauczyciel, kurs, sala (NOWE w v2.0!)
-- Status: zaplanowana, odbyta, odwolana
-- Ograniczenia sprawdzane przez triggery:
--   - Godziny dla dzieci <15 lat: 14:00-19:00
--   - Max 6h lekcji dziennie per nauczyciel
--   - Max 2 lekcje dziennie per uczen
--   - Brak konfliktow sal (2 lekcje w tej samej sali)
--   - Lekcja w ramach aktywnego semestru
--   - Brak konfliktow czasowych ucznia/nauczyciela
-- ============================================================================
CREATE OR REPLACE TYPE t_lekcja_obj AS OBJECT (
    id_lekcji       NUMBER,
    data_lekcji     DATE,
    godzina_start   VARCHAR2(5),
    czas_trwania    NUMBER,
    temat           VARCHAR2(200),
    uwagi           VARCHAR2(500),
    status          VARCHAR2(20),
    ref_uczen       REF t_uczen_obj,
    ref_nauczyciel  REF t_nauczyciel_obj,
    ref_kurs        REF t_kurs_obj,
    ref_sala        REF t_sala_obj,
    
    MEMBER FUNCTION czas_trwania_txt RETURN VARCHAR2,
    MEMBER FUNCTION czy_odbyta RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_lekcja_obj AS
    
    MEMBER FUNCTION czas_trwania_txt RETURN VARCHAR2 IS
    BEGIN
        RETURN czas_trwania || ' minut';
    END czas_trwania_txt;
    
    MEMBER FUNCTION czy_odbyta RETURN VARCHAR2 IS
    BEGIN
        IF status = 'odbyta' THEN
            RETURN 'TAK';
        ELSE
            RETURN 'NIE';
        END IF;
    END czy_odbyta;
    
END;
/

-- ============================================================================
-- 9. TYP: T_OCENA_OBJ
-- Opis: Reprezentuje ocene postepu ucznia
-- Atrybuty: id, data, ocena (1-6), komentarz, obszar, referencje
-- Obszary: technika, teoria, sluch, rytm, interpretacja
-- REF: uczen (kto otrzymal), nauczyciel (kto wystawil)
-- ============================================================================
CREATE OR REPLACE TYPE t_ocena_obj AS OBJECT (
    id_oceny        NUMBER,
    data_oceny      DATE,
    ocena           NUMBER(1),
    komentarz       VARCHAR2(500),
    obszar          VARCHAR2(100),
    ref_uczen       REF t_uczen_obj,
    ref_nauczyciel  REF t_nauczyciel_obj,
    
    MEMBER FUNCTION czy_pozytywna RETURN VARCHAR2,
    MEMBER FUNCTION ocena_slownie RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY t_ocena_obj AS
    
    MEMBER FUNCTION czy_pozytywna RETURN VARCHAR2 IS
    BEGIN
        IF ocena >= 2 THEN
            RETURN 'TAK';
        ELSE
            RETURN 'NIE';
        END IF;
    END czy_pozytywna;
    
    MEMBER FUNCTION ocena_slownie RETURN VARCHAR2 IS
    BEGIN
        CASE ocena
            WHEN 6 THEN RETURN 'celujacy';
            WHEN 5 THEN RETURN 'bardzo dobry';
            WHEN 4 THEN RETURN 'dobry';
            WHEN 3 THEN RETURN 'dostateczny';
            WHEN 2 THEN RETURN 'dopuszczajacy';
            WHEN 1 THEN RETURN 'niedostateczny';
            ELSE RETURN 'nieznana';
        END CASE;
    END ocena_slownie;
    
END;
/

-- ============================================================================
-- PODSUMOWANIE UTWORZONYCH TYPOW - WERSJA 2.0
-- ============================================================================
/*
Utworzono 9 typow obiektowych:

TYPY PODSTAWOWE:
1. t_instrument_obj     - instrument muzyczny (1 metoda: opis)
2. t_lista_instrumentow - VARRAY(5) nazw instrumentow dla nauczyciela

TYPY NOWE (v2.0):
3. t_sala_obj           - sala lekcyjna (1 metoda: opis_pelny) [NEW]
4. t_semestr_obj        - semestr akademicki (2 metody) [NEW]

TYPY GLOWNE:
5. t_nauczyciel_obj     - nauczyciel (3 metody) + VARRAY
6. t_uczen_obj          - uczen (3 metody)
7. t_kurs_obj           - kurs z REF do instrumentu (1 metoda)
8. t_lekcja_obj         - lekcja z 4x REF (2 metody) [MODIFIED: +ref_sala]
9. t_ocena_obj          - ocena z 2x REF (2 metody)

STATYSTYKI:
- Typy obiektowe: 9 (bylo 7, +2 nowe)
- Metody lacznie: 15 (bylo 12, +3 nowe)
- VARRAY: 1
- REF w typach: 7 (bylo 6, +1 nowy: ref_sala w t_lekcja)

NOWE OGRANICZENIA BIZNESOWE (implementowane w triggerach):
- Dzieci <15 lat: lekcje tylko 14:00-19:00
- Max 6h lekcji dziennie per nauczyciel  
- Max 2 lekcje dziennie per uczen
- Brak konfliktow sal
- Lekcje tylko w aktywnym semestrze
*/

PROMPT ========================================
PROMPT Typy obiektowe utworzone pomyslnie!
PROMPT Wersja 2.0 - z salami i semestrami
PROMPT ========================================
