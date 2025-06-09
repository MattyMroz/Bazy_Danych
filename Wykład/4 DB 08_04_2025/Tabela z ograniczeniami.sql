DROP TABLE Zlecenia
CREATE TABLE Zlecenia
(IdZlecenia int IDENTITY PRIMARY KEY,
IdOsoby int, --NOT NULL,
CONSTRAINT fk FOREIGN KEY(IdOsoby) REFERENCES Osoby(IdOsoby)
ON DELETE SET NULL ON UPDATE SET NULL
--ON DELETE CASCADE ON UPDATE CASCADE
--ON DELETE NO ACTION ON UPDATE NO ACTION
,
Opis varchar(33) NOT NULL DEFAULT 'Brak',
min_v int CHECK(min_v>10),
max_v int CHECK(max_v<100),
--CONSTRAINT chk 
CHECK(min_v<max_v)
)

INSERT INTO Zlecenia VALUES (3144, 'zlec1', 20, 80)
INSERT INTO Zlecenia VALUES (3146, 'zlec2', 30, 70)
INSERT INTO Zlecenia VALUES (3144, 'zlec3', 40, 60)
INSERT INTO Zlecenia VALUES (99, 'zlec4', 20, 90)
INSERT INTO Zlecenia(min_v, max_v) VALUES (30, 90)
INSERT INTO Zlecenia(min_v, max_v) VALUES (5, 70)
INSERT INTO Zlecenia(min_v, max_v) VALUES (33, 200)
INSERT INTO Zlecenia(min_v, max_v) VALUES (80, 20)
--INSERT INTO Zlecenia VALUES (1, null, 20, 80)

SELECT * FROM Zlecenia

SELECT * FROM  Osoby

DELETE FROM Osoby WHERE IdOsoby=3144