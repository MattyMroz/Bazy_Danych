BAZY DANYCH - 4i05 - 2025
AUTOR: MATEUSZ MRÓZ 251190

ZADANIE 2
---------
1. Na bazie utworzonej z pliku baza.txt proszę o wykonanie zapytania zwracającego wszystkich pracowników pracujących w danych działach
(zadanie nie precyzuje)

SELECT p.imie, p.nazwisko, d.nazwa AS NazwaDzialu
FROM pracownicy p, dzialy d
WHERE p.dzialID = d.dzialID;

SELECT p.imie, p.nazwisko, d.nazwa AS NazwaDzialu
FROM pracownicy p
INNER JOIN dzialy d ON p.dzialID = d.dzialID;

2. Proszę o wykonanie zapytania zwracającego wszystkich pracowników pracujących w danych działach oraz wyświetlenie ich zarobków używając polecenia JOIN

SELECT
   p.imie,
   p.nazwisko,
   d.nazwa AS NazwaDzialu,
   z.brutto AS Zarobki,
   z.od AS DataZarobkow
FROM pracownicy p
INNER JOIN dzialy d ON p.dzialID = d.dzialID
INNER JOIN zarobki z ON p.pracID = z.pracID;
