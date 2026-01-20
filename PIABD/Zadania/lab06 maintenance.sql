----------------------------------
-- SQL Server Maintenance Plans --
----------------------------------


-- Na podstawie pozycji literaturowej Brad’s Sure Guide to SQL Server Maintenance Plans 
-- wykonujemy poniższe zadania (nie zapisujemy w tym pliku skryptów dla zadań (jobs) tylko wykonujemy i sprawdzamy w SSMS) 
-- Wypisujemy tylko przykładowe zapytania tworzące dane zadanie np. backup bazy danych, reorganizacja indeksów (wybrane 2-3 indeksy), wykonane zapytanie, itd.

-- 1. Przed utworzeniem planu konserwacji 
  -- a. ustawić Database Mail (środowisko testowe Parpercut_SMTP)
  -- b. utwórzyć jednego lub więcej operatorów agentów SQL Server, którzy będą otrzymywać powiadomienia e-mail (np. operator1)

-- INFO ! Operacje konserwacji realizujemy dla dowolonej wybranej bazie danych np. AdventureWorks, Northwind

-- 2. Check Database Integrity - definiujemy plan i sprawdzamy działanie
-- 3. Shrink Database - definiujemy plan i sprawdzamy działanie
-- 4. Rebuild Index - definiujemy plan i sprawdzamy działanie
-- 5. Reorganize Index - definiujemy plan i sprawdzamy działanie
-- 6. Update Statistics - definiujemy plan i sprawdzamy działanie
-- 7. Execute SQL Server Agent Job - definiujemy plan i sprawdzamy działanie
-- 8. History Cleanup - definiujemy plan i sprawdzamy działanie
-- 9. Back Up Database (Full) - definiujemy plan i sprawdzamy działanie
--10. Back Up Database (Diff) - definiujemy plan i sprawdzamy działanie
--11. Back Up Database (Log) - definiujemy plan i sprawdzamy działanie
--12. Maintenance Plan Designer - definiujemy wybrany plan lub plany za pomocą projektanta i sprawdzamy jego działanie.
--13. Zadanie uruchamiamy na życzenie i planujemy wykonywanie zadań cyklicznie - Task Scheduling


  