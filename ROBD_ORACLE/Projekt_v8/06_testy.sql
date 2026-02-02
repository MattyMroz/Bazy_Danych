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
-- 8. TESTY WALIDACJI (TRIGGERY)
-- ============================================================================

-- Test XOR (powinien zgłosić błąd - ani uczeń ani grupa)
-- EXEC pkg_lekcje.dodaj_lekcje_indywidualna(1, 1, 1, NULL, DATE '2025-06-10', 14);

-- Test zakresu ocen (powinien zgłosić błąd - ocena 7)
-- EXEC pkg_oceny.wystaw_ocene(1, 1, 1, 7);

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
- pkg_lekcje (dodawanie lekcji, plany)
- pkg_oceny (wystawianie, listy, średnia)
- pkg_raporty (statystyki)

TRIGGERY:
- trg_lekcja_xor (XOR: uczeń/grupa)
- trg_ocena_zakres (1-6)

KURSORY:
- Jawny w lista_uczniow_grupy
- Niejawny (FOR) we wszystkich procedurach list
*/
