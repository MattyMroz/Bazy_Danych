-- ============================================================================
-- Skrypt diagnostyczny: Sprawdzenie bledow kompilacji pakietow
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;
SET LINESIZE 200;

PROMPT
PROMPT === SPRAWDZENIE STATUSU OBIEKTOW ===
PROMPT

SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('PACKAGE', 'PACKAGE BODY')
ORDER BY object_name, object_type;

PROMPT
PROMPT === BLEDY KOMPILACJI (jezeli sa) ===
PROMPT

SELECT name, type, line, position, text
FROM user_errors
WHERE type IN ('PACKAGE', 'PACKAGE BODY')
ORDER BY name, type, sequence;

PROMPT
PROMPT === PROBA REKOMPILACJI PKG_LEKCJE ===
PROMPT

ALTER PACKAGE PKG_LEKCJE COMPILE BODY;

PROMPT
PROMPT === PONOWNE SPRAWDZENIE BLEDOW ===
PROMPT

SELECT name, type, line, position, text
FROM user_errors
WHERE name = 'PKG_LEKCJE'
ORDER BY type, sequence;

PROMPT
PROMPT === TEST PKG_LEKCJE ===
PROMPT

BEGIN
    PKG_LEKCJE.waliduj_godziny_pracy('14:00', 45);
    DBMS_OUTPUT.PUT_LINE('PKG_LEKCJE dziala poprawnie!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('BLAD: ' || SQLERRM);
END;
/
