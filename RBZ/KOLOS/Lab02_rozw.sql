--Zad. 1:
-- Dokończyć konfigurację Firewall --> przez  ustawienie numeru portu



--Zad. 2:
--- z jakiej kategorii (serwer lokalny) mamy jakie produkty (serwer zdalny --> WA-02) dostarczone przez 
-- jakiego dostawcę (serwer zdalny --> WA-07)?

select c.CategoryName, p.ProductName, p.UnitPrice, s.CompanyName
from Categories c 
inner join 
OPENROWSET(
    'MSOLEDBSQL',
    'WA-02';'sa';'praktyka',
    'SELECT p.CategoryID, p.SupplierID, p.ProductName, p.UnitPrice FROM Northwind.dbo.products p'
) AS p 
on c.CategoryID=p.CategoryID 
inner join 
OPENROWSET(
    'MSOLEDBSQL',
    'WA-02';'sa';'praktyka',
    'SELECT s.CompanyName, s.SupplierID FROM Northwind.dbo.Suppliers s'
) AS s
on s.SupplierID = p.SupplierID
go

SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'WA-07';'sa';'praktyka',
    'SELECT  FROM Northwind.dbo. p'
) AS a;
go

SELECT a.*
FROM OPENROWSET(
    'MSOLEDBSQL',
    'WA-02';'sa';'praktyka',
    'SELECT s.CompanyName, s.SupplierID FROM Northwind.dbo.Suppliers s'
) AS a;
go


-- Zad. 3:
-- wykorzystując instrukcję OPENROWSET zrealizować zapytanie:
-- jakie produkty których nazwa zaczyna się na literę od c do p 
-- serwera lokalnego znajdują się również na serwerze zdalnym 'WA-11'?
--- UWAGA z serwera zdalnego mają być pobrane jedynie te krotki, które spełniają kryterium
-- klauzuli WHERE tego zapytania


select p.ProductName NazwaProd, p.UnitPrice, p1.ProductName NazwaOdp
from Products p 
inner join 
OPENROWSET(
    'MSOLEDBSQL',
    'WA-11';'sa';'praktyka',
    'SELECT p.ProductName FROM Northwind.dbo.products p
	where p.Productname like ''[c-p]%'''
) AS p1
on p.ProductName = p1.ProductName
go


select p.Productname from OPENROWSET(
    'MSOLEDBSQL',
    'WA-11';'sa';'praktyka',
    'SELECT p.ProductName FROM Northwind.dbo.products p
	where p.Productname like ''[c-p]%'''
) AS p
go

---Zad. 4:
-- Podać jaka jest wartość sprzedaży w poszczególnych miesiącach (serwer WA-20) 
--- dwóch lat o największej realizacji sprzedaży (serwer WA-18)
