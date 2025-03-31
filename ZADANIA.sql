BAZY DANYCH - 4i05 - 2025
AUTOR: MATEUSZ MRÓZ 251190

NAZWA LOKALNEGO SERVERA SQL
---------------------------
MATEUSZ\SQLEXPRESS01
---------------------------

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

ALTER TABLE dzialy ADD wzrost int NULL;
ALTER TABLE pracownicy ADD wzrost int NULL;
ALTER TABLE zarobki ADD wzrost int NULL;

-- działy nie mają pola pracID

UPDATE pracownicy
SET wzrost = 175
WHERE pracID < 6;

UPDATE zarobki
SET wzrost = 180
WHERE pracID < 3;

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


ZADANIE 2
---------
1. Na bazie utworzonej z pliku baza.txt proszę o wykonanie zapytania zwracającego wszystkich
   pracowników pracujących w danych działach

SELECT p.imie, p.nazwisko, d.nazwa AS NazwaDzialu
FROM pracownicy p
INNER JOIN dzialy d ON p.dzialID = d.dzialID;


2. Proszę o wykonanie zapytania zwracającego wszystkich pracowników pracujących w danych działach
   oraz wyświetlenie ich zarobków używając polecenia JOIN


SELECT p.imie, p.nazwisko, d.nazwa AS NazwaDzialu, z.brutto AS Zarobki, z.od AS DataZarobkow
FROM pracownicy p
INNER JOIN dzialy d ON p.dzialID = d.dzialID
INNER JOIN zarobki z ON p.pracID = z.pracID;








ZADANIE 3
---------
Constraints
(Teoria do zadania ograniczeń znajduje się w pliku o nazwie constraintsi_unique)

1. Do tabeli pracownicy dodaj kolumnę mix, która ma zawierać 6 znaków i nałóż na nią
   ograniczenie pozwalające wpisywać jedynie wyrazy które zawierają na przemian 3 litery i 3 cyfry. 
   Nazwij to ograniczenie CK_MIX.
   Przykład wartości: a4f5d9

ALTER TABLE pracownicy
ADD mix VARCHAR(6) NULL;


2. Do tabeli pracownicy dodaj kolumnę NIP która będzie zawierała ograniczenie pozwalające na
   wpisanie następującej wartości 727-002-18-95 dla wartości znaków i liczb określonej dla
   dowolnego znaku i liczb z przedziału 0-9. Nazwij to ograniczenie NIP.

ALTER TABLE pracownicy
ADD CONSTRAINT CK_MIX CHECK (mix LIKE '[A-Za-z][0-9][A-Za-z][0-9][A-Za-z][0-9]');


Group by i zapytania
-------------------
Zadania do wykonania:

1. Zapytanie zwracające 2 kolumny: kraj oraz ilość zamówień z niego realizowanych,
   jedynie kraje o największej liczbie zamówień

2. Zapytanie zwracające 3 kolumny: imię, nazwisko, id zamówienia.
   Jedynie zamówienia z 3 kwartału 1996 zrealizowane po terminie.

















ZADANIE 4
---------
Zapytania do wykonania na bazie Northwind (angielski). 
Wartość w nawiasach oznacza ilość rekordów do zwrócenia bądź konkretny rekord:

1. Zapytanie zwracające nazwy kategorii i ilość produktów do nich przypisanych; posortować rosnąco (9)

2. Zapytanie zwracające nazwę firmy, która złożyła najdroższe zamówienie (QUICK-Stop)

3. Podać nazwę towaru i sumaryczną wartość sprzedaży towaru w przedziale czasowym 12 do 5 lat 
   wstecz od aktualnej daty systemowej

4. Zapytanie zwracające OrderID oraz łączną wartość każdego z zamówień; posortować malejąco (830)

5. Wyświetlić ID pracownika, imię, nazwisko, nazwę działu, wiek, datę wypłaty oraz kwotę pracowników, 
   a następnie stworzyć tabelę [into_tabela] oraz wstawić dane - bez użycia polecenia CREATE TABLE

6. Zapytanie zwracające 2 kolumny: imię oraz nazwisko pracownika. 
   Jedynie pracownicy na stanowisku przedstawiciel handlowy

7. Zapytanie zwracające 2 kolumny: nazwę produktu oraz nazwę firmy dostarczającej dany produkt

8. Zapytanie zwracające 3 kolumny: imię, nazwisko oraz ilość zrealizowanych zamówień.
   Jedynie pracownicy o największej ilości zamówień

9. Zapytanie zwracające 3 kolumny: imię, nazwisko, id zamówienia.
   Jedynie zamówienia z 3 kwartału 1996 zrealizowane po terminie (5)

ZADANIE 5
---------
1. Zapytanie zwracające 3 kolumny: nazwę firmy, nazwę kategorii oraz ilość produktów
   dostarczanych w danej kategorii przez dostawcę. Jedynie dostawcy z Niemiec (7)

2. Zapytanie zwracające 2 kolumny: nazwę kategorii oraz nazwę firmy.
   Jedynie firmy, które dostarczają najwięcej produktów w danej kategorii

3. Zapytanie zwracające 2 kolumny: imię oraz nazwisko pracownika.
   Jedynie pracownicy na stanowisku przedstawiciel handlowy

4. Zapytanie zwracające 2 kolumny: nazwę produktu oraz nazwę firmy dostarczającej dany produkt

5. Zapytanie zwracające 3 kolumny: imię, nazwisko oraz ilość zrealizowanych zamówień.
   Jedynie pracownicy o największej ilości zamówień

6. Zapytanie zwracające 3 kolumny: imię, nazwisko, id zamówienia.
   Jedynie zamówienia z 3 kwartału 1996 zrealizowane po terminie (5)

7. Zapytanie zwracające nazwy kategorii i ilość produktów do nich przypisanych;
   posortować rosnąco (9)

8. Znaleźć liczbę zamówień z 1 dnia wystawienia zamówień i przez kolejne dni do końca
   następnego miesiąca

Baza Northwind (angielski):

9. Podać nie powtarzające się pary produktów w tej samej cenie jednostkowej

10. Zapytanie zwracające ilość zamówień złożonych przez firmę Around the Horn (13)

11. Zapytanie zwracające nazwy produktów oraz nazwy ich dostawców (78)

12. Zapytanie zwracające tytuł, imię i nazwisko najmłodszej osoby w każdym z działów,
    przez dział rozumiemy tytuł pracownika (4)

ZADANIE 6
---------
Zadania do wykonania:

1. Napisz procedurę która określi jaki dzień tygodnia stanowi data podana w parametrze wejściowym.
   W przypadku braku parametru, zwróci dzień tygodnia aktualnej daty.

2. Zwróć adres w postaci:
   Piotrkowska
   123/23
   m.30
   90-123 Łódź

3. Stwórz trigger który przenosi dane dotyczące zarobków do tabeli historycznej będącej
   dokładną kopią tabeli zarobki bez kolumny aktualny. Uwzględnij w tej tabeli datę
   przenosin oraz użytkownika który kasował dane

ZADANIE 7
---------
Zadania do wykonania:

1. Stwórz funkcję która będzie przyjmować 2 argumenty będące ciągami znaków
   (maksymalnie do 100 znaków) i zwróci ciąg znaków powstały z wymieszania na przemian znaków
   z ciągu pierwszego z ciągiem drugim. Dodatkowo funkcja ta ma zamienić kolejność znaków.

   PRZYKŁAD: funkcja('ABCDE','12345') zwróci: 5E4D3C2B1A

   W przypadku niezgodności długości ciągów wejściowych wyświetl komunikat typu:
   'Błąd długości znaków: X <> Y' gdzie X i Y to długości ciągów wejściowych

2. Stwórz procedurę, która wyświetli w formie tekstowej (w oknie messages) co drugiego pracownika,
   którego nazwisko zaczyna się na literę podaną w parametrze. W przypadku nie podania
   parametru uwzględniaj tylko osoby o nazwisku na literę 'Z'. W przypadku podania w parametrze wartości
   null nie uwzględniaj kryterium.

   UWAGA: W zadaniu można użyć kursora.

   Przykład wyniku:
   'Pracownik nr #1 Jan Kowalski 25 lat'
   'Pracownik nr #3 Tomasz Kowalski 26 lat'
   'Pracownik nr #5 Piotr Kowalski 29 lat'