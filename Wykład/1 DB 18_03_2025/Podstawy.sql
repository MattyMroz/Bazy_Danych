/*SELECT Nazwisko, Imie, RokUrodz
FROM Osoby;

SELECT * FROM Osoby*/


SELECT Nazwisko, Imie, RokUrodz
FROM Osoby
WHERE Nazwisko LIKE'[%_]%'
--Nazwisko LIKE'[-kn^]%'
--Nazwisko LIKE'[-kn]%'
--Nazwisko LIKE'[0123456789]%'
--Nazwisko LIKE'[0-9]%'
--Nazwisko LIKE '[k,b z;n]%'
--Nazwisko LIKE '[kbzn]%'
--Nazwisko LIKE '[^k-n]%'
--Nazwisko LIKE '[k-n]%'



--Nazwisko LIKE '__w%'
--Nazwisko LIKE 'k%i'
--Nazwisko LIKE '%kow%'
--Nazwisko LIKE '%kow'
--Nazwisko LIKE 'kow%'


--Nazwisko IN ('KOWALSKI', 'nowak')
--RokUrodz IN (NULL)
--RokUrodz IN (1970, 1980, 1977, 1972, 1980)

--RokUrodz >= 1970 AND RokUrodz<=1980
--RokUrodz BETWEEN 1970 AND 1980
--RokUrodz IS NULL
--WHERE RokUrodz>1970 AND RokUrodz<1980
--ORDER BY 2
--Nazwisko DESC, Imie
--ASC