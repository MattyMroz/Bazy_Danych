/*SELECT Nazwisko, Imie, RokUrodz
FROM Osoby
WHERE Nazwisko IN (SELECT Nazwisko FROM ttt)*/

/*SELECT Nazwisko, Imie, RokUrodz
FROM Osoby
WHERE Nazwisko + Imie + CAST(RokUrodz AS varchar(4)) IN 
(SELECT Nazwisko + Imie + CAST(RokUrodz AS varchar(4)) FROM ttt)*/

/*SELECT Osoby.Nazwisko, Osoby.Imie, Osoby.RokUrodz,
ttt.Nazwisko, ttt.Imie, ttt.RokUrodz
FROM Osoby JOIN ttt
ON Osoby.Nazwisko=ttt.Nazwisko
AND Osoby.Imie=ttt.Imie
AND Osoby.RokUrodz=ttt.RokUrodz*/


/*SELECT Osoby.Nazwisko, Osoby.Imie, Osoby.RokUrodz,
ttt.Nazwisko, ttt.Imie, ttt.RokUrodz
FROM Osoby LEFT JOIN ttt
ON Osoby.Nazwisko=ttt.Nazwisko
AND Osoby.Imie=ttt.Imie
AND Osoby.RokUrodz=ttt.RokUrodz
WHERE ttt.Nazwisko IS NULL*/

SELECT Osoby.Nazwisko, Osoby.Imie, Osoby.RokUrodz,
ttt.Nazwisko, ttt.Imie, ttt.RokUrodz
FROM Osoby RIGHT JOIN ttt
ON Osoby.Nazwisko=ttt.Nazwisko
AND Osoby.Imie=ttt.Imie
AND Osoby.RokUrodz=ttt.RokUrodz
WHERE Osoby.Nazwisko IS NULL