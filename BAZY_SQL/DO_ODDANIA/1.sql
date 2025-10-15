BAZY DANYCH - 4i05 - 2025
AUTOR: MATEUSZ MRÓZ 251190

ZADANIE 1
---------
Po utworzeniu bazy danych z pliku baza.txt należy wykonać następujące polecenia:

1. Wyświetlić diagram bazy wraz z relacjami

Wyświetlenie diagramu bazy danych:
-> Database Diagrams
   -> New Database Diagram
      -> Patrz plik 1.1.png

2. Dodać pola do tabel (wszystkich) zgodnie z poniższym schematem:
   - ALTER TABLE nazwa_tabeli ADD nazwa_kolumny tak aby można było wykonać operacje UPDATE dla pola wzrost zgodnie z przykładem uwzględniającym warunek na polu prac_id:
     UPDATE nazwa_tabeli SET wzrost=wartość WHERE pracid < wartość (z pola prac_id w danej tabeli)
    (zadanie nie precyzuje, moja interpretacja poniżej)

ALTER TABLE dzialy ADD liczbaBiur INT NULL;
ALTER TABLE pracownicy ADD wzrost INT NULL;
ALTER TABLE zarobki ADD podwyzka INT NULL;

UPDATE dzialy
SET liczbaBiur = 5
WHERE dzialID < 3;

UPDATE pracownicy
SET wzrost = 175
WHERE pracID < 6;

UPDATE zarobki
SET podwyzka = 300
WHERE pracID < 9;

3. Dodać pola do tabel (wszystkich) przy użyciu wartości DEFAULT

ALTER TABLE dzialy ADD DataUtworzenia DATETIME DEFAULT GETDATE();
ALTER TABLE pracownicy ADD DataZatrudnienia DATETIME DEFAULT GETDATE();
ALTER TABLE zarobki ADD DataDodania DATETIME DEFAULT GETDATE();

4. Wyświetlić wszystkich pracowników na literę T

SELECT *
FROM pracownicy
WHERE imie LIKE 'T%';

5. Wyświetlić imiona, nazwiska i zarobki pracowników

SELECT p.imie, p.nazwisko, z.brutto AS Zarobki
FROM pracownicy p
JOIN zarobki z ON p.pracID = z.pracID;