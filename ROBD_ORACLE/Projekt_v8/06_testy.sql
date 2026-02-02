-- ============================================================================
-- SZKOŁA MUZYCZNA I STOPNIA - SCENARIUSZE TESTOWE (UPROSZCZONE)
-- Autorzy: Igor Typiński (251237), Mateusz Mróz (251190)
-- ============================================================================

SET SERVEROUTPUT ON;

-- ============================================================================
-- 1. LISTY SŁOWNIKÓW
-- ============================================================================
EXEC pkg_slowniki.lista_przedmiotow;
EXEC pkg_slowniki.lista_sal;
EXEC pkg_slowniki.lista_grup;

-- ============================================================================
-- 2. LISTY OSÓB
-- ============================================================================
EXEC pkg_osoby.lista_nauczycieli;
EXEC pkg_osoby.lista_uczniow;
EXEC pkg_osoby.lista_uczniow_grupy(1);  -- Uczniowie z grupy 1A

-- ============================================================================
-- 3. PLANY LEKCJI
-- ============================================================================
EXEC pkg_lekcje.plan_ucznia(1);           -- Plan Adama
EXEC pkg_lekcje.plan_nauczyciela(1);      -- Plan Anny Kowalskiej
EXEC pkg_lekcje.plan_dnia(DATE '2025-06-03');  -- Plan wtorku

-- ============================================================================
-- 4. OCENY
-- ============================================================================
EXEC pkg_oceny.oceny_ucznia(1);           -- Oceny Adama

-- Średnia Adama z fortepianu
SELECT pkg_oceny.srednia_ucznia(1, 1) AS srednia_adam_fortepian FROM DUAL;

-- ============================================================================
-- 5. RAPORTY
-- ============================================================================
EXEC pkg_raporty.raport_grup;
EXEC pkg_raporty.statystyki;

-- ============================================================================
-- 6. DEMONSTRACJA METOD OBIEKTOWYCH
-- ============================================================================

-- Metody ucznia
SELECT u.pelne_nazwisko() AS nazwisko, u.wiek() AS wiek, u.instrument
FROM uczniowie u WHERE ROWNUM <= 3;

-- Metody nauczyciela
SELECT n.pelne_nazwisko() AS nazwisko, n.staz_lat() AS staz,
       DEREF(n.ref_przedmiot).nazwa AS przedmiot
FROM nauczyciele n;

-- Metody przedmiotu
SELECT p.nazwa, p.czy_grupowy() AS grupowy FROM przedmioty p;

-- Metody sali (VARRAY!)
SELECT s.numer, s.czy_grupowa() AS grupowa, s.lista_wyposazenia() AS wyposazenie 
FROM sale s;

-- Metody lekcji
SELECT l.id, l.czy_indywidualna() AS indyw, l.godzina_koniec() AS koniec
FROM lekcje l WHERE ROWNUM <= 5;

-- Metody oceny
SELECT o.wartosc, o.opis_oceny() AS opis FROM oceny o WHERE ROWNUM <= 5;

-- ============================================================================
-- 7. DEMONSTRACJA REF/DEREF
-- ============================================================================

-- Nauczyciel z przedmiotem (REF)
SELECT n.pelne_nazwisko() AS nauczyciel,
       DEREF(n.ref_przedmiot).nazwa AS przedmiot,
       DEREF(n.ref_przedmiot).typ AS typ_przedmiotu
FROM nauczyciele n;

-- Uczeń z grupą (REF)
SELECT u.pelne_nazwisko() AS uczen,
       DEREF(u.ref_grupa).symbol AS grupa,
       DEREF(u.ref_grupa).poziom AS klasa
FROM uczniowie u;

-- Lekcja z wieloma REF
SELECT 
    DEREF(l.ref_przedmiot).nazwa AS przedmiot,
    DEREF(l.ref_nauczyciel).pelne_nazwisko() AS nauczyciel,
    DEREF(l.ref_sala).numer AS sala,
    CASE WHEN l.ref_uczen IS NOT NULL 
         THEN DEREF(l.ref_uczen).pelne_nazwisko()
         ELSE 'grupa ' || DEREF(l.ref_grupa).symbol
    END AS dla_kogo
FROM lekcje l WHERE ROWNUM <= 5;

-- ============================================================================
-- 8. TESTY WALIDACJI (TRIGGERY I PAKIETY)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 8.1 TESTY TRIGGERÓW
-- ----------------------------------------------------------------------------

-- Test XOR (powinien zgłosić błąd - ani uczeń ani grupa)
-- EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, NULL, DATE '2025-06-10', 14);

-- Test zakresu ocen (powinien zgłosić błąd - ocena 7)
-- EXEC pkg_oceny.wystaw_ocene(1, 1, 1, 7);

-- ----------------------------------------------------------------------------
-- 8.2 TESTY WALIDACJI KONFLIKTÓW TERMINÓW Z SUGESTIĄ (HEURYSTYKA)
-- ----------------------------------------------------------------------------

-- Test kolizji sali (sala 1 zajęta 2025-06-02 o 14:00)
-- System powinien zasugerować alternatywny termin z salą posiadającą fortepian
-- EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, 4, DATE '2025-06-02', 14);
-- Oczekiwany błąd z sugestią:
-- ORA-20020: Blad planowania: Sala jest juz zajeta w tym terminie!
-- SUGEROWANY TERMIN: 2025-06-02 o godzinie 15:00 w sali 101

-- Test kolizji nauczyciela (nauczyciel 1 ma lekcję 2025-06-02 o 14:00)
-- EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 2, 4, DATE '2025-06-02', 14);
-- Oczekiwany błąd z sugestią terminu

-- Test kolizji dla lekcji grupowej - sugestia znajdzie salę grupową
-- EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 3, 1, DATE '2025-06-03', 14);
-- Oczekiwany błąd z sugestią sali grupowej o odpowiedniej pojemności

-- ----------------------------------------------------------------------------
-- 8.3 TESTY WALIDACJI KOMPETENCJI NAUCZYCIELA (-20030)
-- ----------------------------------------------------------------------------

-- Nauczyciel 1 (Anna Kowalska) uczy Fortepianu (przedmiot 1)
-- Próba przypisania jej do lekcji Skrzypiec (przedmiot 2) - powinien być błąd
-- EXEC pkg_lekcje.dodaj_lekcje_indywidualna(2, 1, 2, 2, DATE '2025-06-10', 14);
-- Oczekiwany błąd: ORA-20030: Ten nauczyciel nie uczy tego przedmiotu!

-- Test dla lekcji grupowej - nauczyciel 1 nie uczy Kształcenia słuchu (przedmiot 4)
-- EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 1, 3, 1, DATE '2025-06-10', 14);
-- Oczekiwany błąd: ORA-20030: Ten nauczyciel nie uczy tego przedmiotu!

-- ----------------------------------------------------------------------------
-- 8.4 TESTY WALIDACJI TYPU SALI (-20031)
-- ----------------------------------------------------------------------------

-- Sala 1 (101) jest typu 'indywidualna'
-- Próba dodania lekcji grupowej w tej sali - powinien być błąd
-- EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 1, 1, DATE '2025-06-10', 14);
-- Oczekiwany błąd: ORA-20031: Nie można prowadzić lekcji grupowej w sali indywidualnej!

-- ----------------------------------------------------------------------------
-- 8.5 TESTY WALIDACJI PRZEPEŁNIENIA SALI (-20035)
-- ----------------------------------------------------------------------------

-- Sala 103 ma pojemność 20 osób, grupa 1A ma 3 uczniów - powinno przejść
-- Aby przetestować błąd, trzeba by stworzyć grupę z >20 uczniami lub salę z mniejszą pojemnością

-- Przykład testu (gdyby sala miała pojemność 2, a grupa 3 uczniów):
-- EXEC pkg_lekcje.dodaj_lekcje_grupowa(4, 4, 3, 1, DATE '2025-06-10', 17);
-- Oczekiwany błąd: ORA-20035: Sala jest za mała! Grupa liczy 3 osób, a sala mieści tylko 2.

-- ----------------------------------------------------------------------------
-- 8.6 TESTY WALIDACJI INSTRUMENTU UCZNIA (-20032)
-- ----------------------------------------------------------------------------

-- Uczeń 1 (Adam Adamski) gra na Fortepianie
-- Próba zapisania go na lekcję Skrzypiec - powinien być błąd
-- EXEC pkg_lekcje.dodaj_lekcje_indywidualna(2, 2, 2, 1, DATE '2025-06-10', 14);
-- Oczekiwany błąd: ORA-20032: Uczeń gra na instrumencie Fortepian, a lekcja dotyczy przedmiotu Skrzypce!

-- Uczeń 2 (Barbara Barańska) gra na Skrzypcach
-- Próba zapisania jej na lekcję Gitary - powinien być błąd
-- EXEC pkg_lekcje.dodaj_lekcje_indywidualna(3, 3, 2, 2, DATE '2025-06-10', 15);
-- Oczekiwany błąd: ORA-20032: Uczeń gra na instrumencie Skrzypce, a lekcja dotyczy przedmiotu Gitara!

-- ----------------------------------------------------------------------------
-- 8.7 TESTY WALIDACJI UPRAWNIEŃ DO OCENIANIA (-20033)
-- ----------------------------------------------------------------------------

-- Nauczyciel 1 (Anna Kowalska) uczy Fortepianu (przedmiot 1)
-- Próba wystawienia przez nią oceny z Rytmiki (przedmiot 5) - powinien być błąd
-- EXEC pkg_oceny.wystaw_ocene(1, 1, 5, 5);
-- Oczekiwany błąd: ORA-20033: Ten nauczyciel nie może wystawiać ocen z tego przedmiotu!

-- Nauczyciel 2 (Jan Nowak) uczy Skrzypiec (przedmiot 2)
-- Próba wystawienia przez niego oceny semestralnej z Fortepianu - powinien być błąd
-- EXEC pkg_oceny.wystaw_ocene_semestralna(1, 2, 1, 5);
-- Oczekiwany błąd: ORA-20033: Ten nauczyciel nie może wystawiać ocen z tego przedmiotu!

-- ============================================================================
-- 9. PODSUMOWANIE - co zostało zademonstrowane
-- ============================================================================
/*
TYPY OBIEKTOWE:
- t_wyposazenie (VARRAY)
- t_przedmiot, t_grupa, t_nauczyciel, t_sala, t_uczen, t_lekcja, t_ocena

METODY:
- pelne_nazwisko(), wiek(), staz_lat()
- czy_grupowy(), czy_grupowa(), czy_indywidualna()
- lista_wyposazenia(), godzina_koniec(), opis_oceny()

REF/DEREF:
- nauczyciel → przedmiot
- uczen → grupa
- lekcja → przedmiot, nauczyciel, sala, uczen/grupa
- ocena → uczen, nauczyciel, przedmiot

VARRAY:
- wyposażenie sal

PAKIETY:
- pkg_slowniki (dodawanie, listy, get_ref)
- pkg_osoby (dodawanie, listy, get_ref)
- pkg_lekcje (dodawanie lekcji, plany, walidacja konfliktów i spójności)
- pkg_oceny (wystawianie, listy, średnia, walidacja uprawnień)
- pkg_raporty (statystyki)

TRIGGERY:
- trg_lekcja_xor (XOR: uczeń/grupa)
- trg_ocena_zakres (1-6)

WALIDACJE W PAKIETACH:
- Konflikty terminów (sala/nauczyciel/uczeń/grupa zajęty)
- Kompetencje nauczyciela (czy uczy danego przedmiotu)
- Typ sali (lekcja grupowa wymaga sali grupowej)
- Przepełnienie sali (czy grupa zmieści się w sali)
- Instrument ucznia (zgodność z przedmiotem lekcji)
- Uprawnienia do oceniania (nauczyciel ocenia tylko swój przedmiot)

HEURYSTYKA FIRST FIT:
- znajdz_alternatywe() - sugestia wolnego terminu
- sala_ma_instrument() - przeszukiwanie VARRAY wyposażenia
- Dopasowanie sali do instrumentu (lekcje indywidualne)
- Dopasowanie sali grupowej z pojemnością (lekcje grupowe)

KURSORY:
- Jawny w lista_uczniow_grupy
- Niejawny (FOR) we wszystkich procedurach list
*/
