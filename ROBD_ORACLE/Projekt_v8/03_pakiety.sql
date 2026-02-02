-- ============================================================================
-- SZKOŁA MUZYCZNA I STOPNIA - PAKIETY PL/SQL (UPROSZCZONE)
-- Autorzy: Igor Typiński (251237), Mateusz Mróz (251190)
-- ============================================================================

-- ============================================================================
-- PKG_SLOWNIKI - zarządzanie słownikami (przedmioty, grupy, sale)
-- ============================================================================
CREATE OR REPLACE PACKAGE pkg_slowniki AS
    -- Dodawanie
    PROCEDURE dodaj_przedmiot(p_nazwa VARCHAR2, p_typ VARCHAR2);
    PROCEDURE dodaj_grupe(p_symbol VARCHAR2, p_poziom NUMBER);
    PROCEDURE dodaj_sale(p_numer VARCHAR2, p_typ VARCHAR2, p_pojemnosc NUMBER, p_wyposazenie t_wyposazenie);
    
    -- Pobieranie referencji
    FUNCTION get_ref_przedmiot(p_id NUMBER) RETURN REF t_przedmiot;
    FUNCTION get_ref_grupa(p_id NUMBER) RETURN REF t_grupa;
    FUNCTION get_ref_sala(p_id NUMBER) RETURN REF t_sala;
    
    -- Listy
    PROCEDURE lista_przedmiotow;
    PROCEDURE lista_sal;
    PROCEDURE lista_grup;
END pkg_slowniki;
/

CREATE OR REPLACE PACKAGE BODY pkg_slowniki AS

    PROCEDURE dodaj_przedmiot(p_nazwa VARCHAR2, p_typ VARCHAR2) IS
    BEGIN
        INSERT INTO przedmioty VALUES (
            t_przedmiot(seq_przedmioty.NEXTVAL, p_nazwa, p_typ, 45)
        );
        DBMS_OUTPUT.PUT_LINE('Dodano przedmiot: ' || p_nazwa || ' (' || p_typ || ')');
    END;

    PROCEDURE dodaj_grupe(p_symbol VARCHAR2, p_poziom NUMBER) IS
    BEGIN
        INSERT INTO grupy VALUES (
            t_grupa(seq_grupy.NEXTVAL, p_symbol, p_poziom)
        );
        DBMS_OUTPUT.PUT_LINE('Dodano grupę: ' || p_symbol || ' (klasa ' || p_poziom || ')');
    END;

    PROCEDURE dodaj_sale(p_numer VARCHAR2, p_typ VARCHAR2, p_pojemnosc NUMBER, p_wyposazenie t_wyposazenie) IS
    BEGIN
        INSERT INTO sale VALUES (
            t_sala(seq_sale.NEXTVAL, p_numer, p_typ, p_pojemnosc, p_wyposazenie)
        );
        DBMS_OUTPUT.PUT_LINE('Dodano salę: ' || p_numer || ' (' || p_typ || ')');
    END;

    FUNCTION get_ref_przedmiot(p_id NUMBER) RETURN REF t_przedmiot IS
        v_ref REF t_przedmiot;
    BEGIN
        SELECT REF(p) INTO v_ref FROM przedmioty p WHERE p.id = p_id;
        RETURN v_ref;
    END;

    FUNCTION get_ref_grupa(p_id NUMBER) RETURN REF t_grupa IS
        v_ref REF t_grupa;
    BEGIN
        SELECT REF(g) INTO v_ref FROM grupy g WHERE g.id = p_id;
        RETURN v_ref;
    END;

    FUNCTION get_ref_sala(p_id NUMBER) RETURN REF t_sala IS
        v_ref REF t_sala;
    BEGIN
        SELECT REF(s) INTO v_ref FROM sale s WHERE s.id = p_id;
        RETURN v_ref;
    END;

    PROCEDURE lista_przedmiotow IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== PRZEDMIOTY ===');
        FOR r IN (SELECT p.id, p.nazwa, p.typ FROM przedmioty p ORDER BY p.id) LOOP
            DBMS_OUTPUT.PUT_LINE(r.id || '. ' || r.nazwa || ' (' || r.typ || ')');
        END LOOP;
    END;

    PROCEDURE lista_sal IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== SALE ===');
        FOR r IN (SELECT s.id, s.numer, s.typ, s.pojemnosc, s.lista_wyposazenia() AS wyp FROM sale s ORDER BY s.id) LOOP
            DBMS_OUTPUT.PUT_LINE(r.id || '. Sala ' || r.numer || ' (' || r.typ || ', max ' || r.pojemnosc || ' os.)');
            DBMS_OUTPUT.PUT_LINE('   Wyposażenie: ' || NVL(r.wyp, 'brak'));
        END LOOP;
    END;

    PROCEDURE lista_grup IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== GRUPY ===');
        FOR r IN (SELECT g.id, g.symbol, g.poziom FROM grupy g ORDER BY g.poziom) LOOP
            DBMS_OUTPUT.PUT_LINE(r.id || '. Klasa ' || r.poziom || ' (grupa ' || r.symbol || ')');
        END LOOP;
    END;

END pkg_slowniki;
/

-- ============================================================================
-- PKG_OSOBY - zarządzanie nauczycielami i uczniami
-- ============================================================================
CREATE OR REPLACE PACKAGE pkg_osoby AS
    -- Dodawanie
    PROCEDURE dodaj_nauczyciela(p_imie VARCHAR2, p_nazwisko VARCHAR2, p_id_przedmiotu NUMBER);
    PROCEDURE dodaj_ucznia(p_imie VARCHAR2, p_nazwisko VARCHAR2, p_data_ur DATE, p_instrument VARCHAR2, p_id_grupy NUMBER);
    
    -- Pobieranie referencji
    FUNCTION get_ref_nauczyciel(p_id NUMBER) RETURN REF t_nauczyciel;
    FUNCTION get_ref_uczen(p_id NUMBER) RETURN REF t_uczen;
    
    -- Listy
    PROCEDURE lista_nauczycieli;
    PROCEDURE lista_uczniow;
    PROCEDURE lista_uczniow_grupy(p_id_grupy NUMBER);
END pkg_osoby;
/

CREATE OR REPLACE PACKAGE BODY pkg_osoby AS

    PROCEDURE dodaj_nauczyciela(p_imie VARCHAR2, p_nazwisko VARCHAR2, p_id_przedmiotu NUMBER) IS
        v_ref_przedmiot REF t_przedmiot;
    BEGIN
        v_ref_przedmiot := pkg_slowniki.get_ref_przedmiot(p_id_przedmiotu);
        INSERT INTO nauczyciele VALUES (
            t_nauczyciel(seq_nauczyciele.NEXTVAL, p_imie, p_nazwisko, SYSDATE, v_ref_przedmiot)
        );
        DBMS_OUTPUT.PUT_LINE('Dodano nauczyciela: ' || p_imie || ' ' || p_nazwisko);
    END;

    PROCEDURE dodaj_ucznia(p_imie VARCHAR2, p_nazwisko VARCHAR2, p_data_ur DATE, p_instrument VARCHAR2, p_id_grupy NUMBER) IS
        v_ref_grupa REF t_grupa;
    BEGIN
        v_ref_grupa := pkg_slowniki.get_ref_grupa(p_id_grupy);
        INSERT INTO uczniowie VALUES (
            t_uczen(seq_uczniowie.NEXTVAL, p_imie, p_nazwisko, p_data_ur, p_instrument, v_ref_grupa)
        );
        DBMS_OUTPUT.PUT_LINE('Dodano ucznia: ' || p_imie || ' ' || p_nazwisko || ' (' || p_instrument || ')');
    END;

    FUNCTION get_ref_nauczyciel(p_id NUMBER) RETURN REF t_nauczyciel IS
        v_ref REF t_nauczyciel;
    BEGIN
        SELECT REF(n) INTO v_ref FROM nauczyciele n WHERE n.id = p_id;
        RETURN v_ref;
    END;

    FUNCTION get_ref_uczen(p_id NUMBER) RETURN REF t_uczen IS
        v_ref REF t_uczen;
    BEGIN
        SELECT REF(u) INTO v_ref FROM uczniowie u WHERE u.id = p_id;
        RETURN v_ref;
    END;

    PROCEDURE lista_nauczycieli IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== NAUCZYCIELE ===');
        FOR r IN (
            SELECT n.id, n.pelne_nazwisko() AS nazwa, 
                   DEREF(n.ref_przedmiot).nazwa AS przedmiot
            FROM nauczyciele n ORDER BY n.id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(r.id || '. ' || r.nazwa || ' - uczy: ' || r.przedmiot);
        END LOOP;
    END;

    PROCEDURE lista_uczniow IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== UCZNIOWIE ===');
        FOR r IN (
            SELECT u.id, u.pelne_nazwisko() AS nazwa, u.wiek() AS wiek, 
                   u.instrument, DEREF(u.ref_grupa).symbol AS grupa
            FROM uczniowie u ORDER BY grupa, u.nazwisko
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(r.id || '. ' || r.nazwa || ' (lat ' || r.wiek || ') - ' || 
                                 r.instrument || ', grupa ' || r.grupa);
        END LOOP;
    END;

    -- Kursor jawny dla listy uczniów w grupie
    PROCEDURE lista_uczniow_grupy(p_id_grupy NUMBER) IS
        CURSOR c_uczniowie IS
            SELECT u.id, u.pelne_nazwisko() AS nazwa, u.instrument
            FROM uczniowie u
            WHERE DEREF(u.ref_grupa).id = p_id_grupy
            ORDER BY u.nazwisko;
        v_rec c_uczniowie%ROWTYPE;
        v_symbol VARCHAR2(10);
    BEGIN
        SELECT g.symbol INTO v_symbol FROM grupy g WHERE g.id = p_id_grupy;
        DBMS_OUTPUT.PUT_LINE('=== UCZNIOWIE GRUPY ' || v_symbol || ' ===');
        
        OPEN c_uczniowie;
        LOOP
            FETCH c_uczniowie INTO v_rec;
            EXIT WHEN c_uczniowie%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(v_rec.id || '. ' || v_rec.nazwa || ' - ' || v_rec.instrument);
        END LOOP;
        CLOSE c_uczniowie;
    END;

END pkg_osoby;
/

-- ============================================================================
-- PKG_LEKCJE - zarządzanie lekcjami
-- ============================================================================
CREATE OR REPLACE PACKAGE pkg_lekcje AS
    -- Dodawanie lekcji
    PROCEDURE dodaj_lekcje_indywidualna(
        p_id_przedmiotu NUMBER, p_id_nauczyciela NUMBER, p_id_sali NUMBER,
        p_id_ucznia NUMBER, p_data DATE, p_godz NUMBER
    );
    PROCEDURE dodaj_lekcje_grupowa(
        p_id_przedmiotu NUMBER, p_id_nauczyciela NUMBER, p_id_sali NUMBER,
        p_id_grupy NUMBER, p_data DATE, p_godz NUMBER
    );
    
    -- Plany
    PROCEDURE plan_ucznia(p_id_ucznia NUMBER);
    PROCEDURE plan_nauczyciela(p_id_nauczyciela NUMBER);
    PROCEDURE plan_dnia(p_data DATE);
END pkg_lekcje;
/

CREATE OR REPLACE PACKAGE BODY pkg_lekcje AS

    PROCEDURE dodaj_lekcje_indywidualna(
        p_id_przedmiotu NUMBER, p_id_nauczyciela NUMBER, p_id_sali NUMBER,
        p_id_ucznia NUMBER, p_data DATE, p_godz NUMBER
    ) IS
    BEGIN
        INSERT INTO lekcje VALUES (
            t_lekcja(
                seq_lekcje.NEXTVAL,
                pkg_slowniki.get_ref_przedmiot(p_id_przedmiotu),
                pkg_osoby.get_ref_nauczyciel(p_id_nauczyciela),
                pkg_slowniki.get_ref_sala(p_id_sali),
                pkg_osoby.get_ref_uczen(p_id_ucznia),
                NULL,  -- brak grupy (lekcja indywidualna)
                p_data, p_godz, 45
            )
        );
        DBMS_OUTPUT.PUT_LINE('Dodano lekcję indywidualną: ' || TO_CHAR(p_data, 'YYYY-MM-DD') || ' ' || p_godz || ':00');
    END;

    PROCEDURE dodaj_lekcje_grupowa(
        p_id_przedmiotu NUMBER, p_id_nauczyciela NUMBER, p_id_sali NUMBER,
        p_id_grupy NUMBER, p_data DATE, p_godz NUMBER
    ) IS
    BEGIN
        INSERT INTO lekcje VALUES (
            t_lekcja(
                seq_lekcje.NEXTVAL,
                pkg_slowniki.get_ref_przedmiot(p_id_przedmiotu),
                pkg_osoby.get_ref_nauczyciel(p_id_nauczyciela),
                pkg_slowniki.get_ref_sala(p_id_sali),
                NULL,  -- brak ucznia (lekcja grupowa)
                pkg_slowniki.get_ref_grupa(p_id_grupy),
                p_data, p_godz, 45
            )
        );
        DBMS_OUTPUT.PUT_LINE('Dodano lekcję grupową: ' || TO_CHAR(p_data, 'YYYY-MM-DD') || ' ' || p_godz || ':00');
    END;

    PROCEDURE plan_ucznia(p_id_ucznia NUMBER) IS
        v_uczen VARCHAR2(100);
        v_id_grupy NUMBER;
    BEGIN
        SELECT u.pelne_nazwisko(), DEREF(u.ref_grupa).id 
        INTO v_uczen, v_id_grupy 
        FROM uczniowie u WHERE u.id = p_id_ucznia;
        
        DBMS_OUTPUT.PUT_LINE('=== PLAN UCZNIA: ' || v_uczen || ' ===');
        
        -- Lekcje indywidualne + grupowe (UNION)
        FOR r IN (
            SELECT l.data_lekcji, l.godz_rozp,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_nauczyciel).pelne_nazwisko() AS nauczyciel,
                   DEREF(l.ref_sala).numer AS sala,
                   l.czy_indywidualna() AS typ
            FROM lekcje l
            WHERE DEREF(l.ref_uczen).id = p_id_ucznia
               OR DEREF(l.ref_grupa).id = v_id_grupy
            ORDER BY l.data_lekcji, l.godz_rozp
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(r.data_lekcji, 'DY DD.MM') || ' ' || r.godz_rozp || ':00 - ' || 
                                 r.przedmiot || ' (sala ' || r.sala || ')' ||
                                 CASE WHEN r.typ = 'N' THEN ' [GRUPOWA]' ELSE '' END);
        END LOOP;
    END;

    PROCEDURE plan_nauczyciela(p_id_nauczyciela NUMBER) IS
        v_nauczyciel VARCHAR2(100);
    BEGIN
        SELECT n.pelne_nazwisko() INTO v_nauczyciel FROM nauczyciele n WHERE n.id = p_id_nauczyciela;
        
        DBMS_OUTPUT.PUT_LINE('=== PLAN NAUCZYCIELA: ' || v_nauczyciel || ' ===');
        FOR r IN (
            SELECT l.data_lekcji, l.godz_rozp,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_sala).numer AS sala,
                   CASE WHEN l.ref_uczen IS NOT NULL 
                        THEN DEREF(l.ref_uczen).pelne_nazwisko()
                        ELSE 'grupa ' || DEREF(l.ref_grupa).symbol
                   END AS kto
            FROM lekcje l
            WHERE DEREF(l.ref_nauczyciel).id = p_id_nauczyciela
            ORDER BY l.data_lekcji, l.godz_rozp
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(r.data_lekcji, 'DY DD.MM') || ' ' || r.godz_rozp || ':00 - ' || 
                                 r.przedmiot || ' (sala ' || r.sala || ') - ' || r.kto);
        END LOOP;
    END;

    PROCEDURE plan_dnia(p_data DATE) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== PLAN DNIA: ' || TO_CHAR(p_data, 'YYYY-MM-DD (DY)') || ' ===');
        FOR r IN (
            SELECT l.godz_rozp,
                   DEREF(l.ref_przedmiot).nazwa AS przedmiot,
                   DEREF(l.ref_nauczyciel).pelne_nazwisko() AS nauczyciel,
                   DEREF(l.ref_sala).numer AS sala,
                   CASE WHEN l.ref_uczen IS NOT NULL 
                        THEN DEREF(l.ref_uczen).pelne_nazwisko()
                        ELSE 'grupa ' || DEREF(l.ref_grupa).symbol
                   END AS kto
            FROM lekcje l
            WHERE l.data_lekcji = p_data
            ORDER BY l.godz_rozp
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(r.godz_rozp || ':00 | sala ' || r.sala || ' | ' || 
                                 r.przedmiot || ' | ' || r.nauczyciel || ' | ' || r.kto);
        END LOOP;
    END;

END pkg_lekcje;
/

-- ============================================================================
-- PKG_OCENY - zarządzanie ocenami
-- ============================================================================
CREATE OR REPLACE PACKAGE pkg_oceny AS
    PROCEDURE wystaw_ocene(p_id_ucznia NUMBER, p_id_nauczyciela NUMBER, 
                           p_id_przedmiotu NUMBER, p_wartosc NUMBER);
    PROCEDURE wystaw_ocene_semestralna(p_id_ucznia NUMBER, p_id_nauczyciela NUMBER,
                                       p_id_przedmiotu NUMBER, p_wartosc NUMBER);
    PROCEDURE oceny_ucznia(p_id_ucznia NUMBER);
    FUNCTION srednia_ucznia(p_id_ucznia NUMBER, p_id_przedmiotu NUMBER) RETURN NUMBER;
END pkg_oceny;
/

CREATE OR REPLACE PACKAGE BODY pkg_oceny AS

    PROCEDURE wystaw_ocene(p_id_ucznia NUMBER, p_id_nauczyciela NUMBER,
                           p_id_przedmiotu NUMBER, p_wartosc NUMBER) IS
    BEGIN
        INSERT INTO oceny VALUES (
            t_ocena(
                seq_oceny.NEXTVAL,
                pkg_osoby.get_ref_uczen(p_id_ucznia),
                pkg_osoby.get_ref_nauczyciel(p_id_nauczyciela),
                pkg_slowniki.get_ref_przedmiot(p_id_przedmiotu),
                p_wartosc, SYSDATE, 'N'
            )
        );
        DBMS_OUTPUT.PUT_LINE('Wystawiono ocenę: ' || p_wartosc);
    END;

    PROCEDURE wystaw_ocene_semestralna(p_id_ucznia NUMBER, p_id_nauczyciela NUMBER,
                                       p_id_przedmiotu NUMBER, p_wartosc NUMBER) IS
    BEGIN
        INSERT INTO oceny VALUES (
            t_ocena(
                seq_oceny.NEXTVAL,
                pkg_osoby.get_ref_uczen(p_id_ucznia),
                pkg_osoby.get_ref_nauczyciel(p_id_nauczyciela),
                pkg_slowniki.get_ref_przedmiot(p_id_przedmiotu),
                p_wartosc, SYSDATE, 'T'
            )
        );
        DBMS_OUTPUT.PUT_LINE('Wystawiono ocenę SEMESTRALNĄ: ' || p_wartosc);
    END;

    PROCEDURE oceny_ucznia(p_id_ucznia NUMBER) IS
        v_uczen VARCHAR2(100);
    BEGIN
        SELECT u.pelne_nazwisko() INTO v_uczen FROM uczniowie u WHERE u.id = p_id_ucznia;
        
        DBMS_OUTPUT.PUT_LINE('=== OCENY UCZNIA: ' || v_uczen || ' ===');
        FOR r IN (
            SELECT DEREF(o.ref_przedmiot).nazwa AS przedmiot,
                   o.wartosc, o.opis_oceny() AS opis,
                   o.semestralna, TO_CHAR(o.data_oceny, 'YYYY-MM-DD') AS data
            FROM oceny o
            WHERE DEREF(o.ref_uczen).id = p_id_ucznia
            ORDER BY o.data_oceny
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(r.przedmiot || ': ' || r.wartosc || ' (' || r.opis || ')' ||
                                 CASE WHEN r.semestralna = 'T' THEN ' [SEM]' ELSE '' END ||
                                 ' - ' || r.data);
        END LOOP;
    END;

    FUNCTION srednia_ucznia(p_id_ucznia NUMBER, p_id_przedmiotu NUMBER) RETURN NUMBER IS
        v_srednia NUMBER;
    BEGIN
        SELECT AVG(o.wartosc) INTO v_srednia
        FROM oceny o
        WHERE DEREF(o.ref_uczen).id = p_id_ucznia
          AND DEREF(o.ref_przedmiot).id = p_id_przedmiotu
          AND o.semestralna = 'N';
        RETURN ROUND(v_srednia, 2);
    END;

END pkg_oceny;
/

-- ============================================================================
-- PKG_RAPORTY - raporty i statystyki
-- ============================================================================
CREATE OR REPLACE PACKAGE pkg_raporty AS
    PROCEDURE raport_grup;
    PROCEDURE statystyki;
END pkg_raporty;
/

CREATE OR REPLACE PACKAGE BODY pkg_raporty AS

    PROCEDURE raport_grup IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== RAPORT GRUP ===');
        FOR r IN (
            SELECT g.symbol, g.poziom,
                   (SELECT COUNT(*) FROM uczniowie u WHERE DEREF(u.ref_grupa).id = g.id) AS liczba
            FROM grupy g ORDER BY g.poziom
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Klasa ' || r.poziom || ' (' || r.symbol || '): ' || r.liczba || ' uczniów');
        END LOOP;
    END;

    PROCEDURE statystyki IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== STATYSTYKI SZKOŁY ===');
        FOR r IN (
            SELECT 
                (SELECT COUNT(*) FROM uczniowie) AS uczniowie,
                (SELECT COUNT(*) FROM nauczyciele) AS nauczyciele,
                (SELECT COUNT(*) FROM grupy) AS grupy,
                (SELECT COUNT(*) FROM sale) AS sale,
                (SELECT COUNT(*) FROM lekcje) AS lekcje,
                (SELECT COUNT(*) FROM oceny) AS oceny
            FROM DUAL
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Uczniów: ' || r.uczniowie);
            DBMS_OUTPUT.PUT_LINE('Nauczycieli: ' || r.nauczyciele);
            DBMS_OUTPUT.PUT_LINE('Grup: ' || r.grupy);
            DBMS_OUTPUT.PUT_LINE('Sal: ' || r.sale);
            DBMS_OUTPUT.PUT_LINE('Lekcji: ' || r.lekcje);
            DBMS_OUTPUT.PUT_LINE('Ocen: ' || r.oceny);
        END LOOP;
    END;

END pkg_raporty;
/

-- ============================================================================
-- Weryfikacja
-- ============================================================================
SELECT object_name, object_type, status 
FROM user_objects 
WHERE object_type IN ('PACKAGE', 'PACKAGE BODY')
ORDER BY object_name, object_type;
