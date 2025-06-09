-- union


SELECT 'Pierwszy' as Opis, getdate() as Dt, 132 as liczba
join
SELECT 'Drugi' as ZupelnieInnyOpis, '2013-01-01' as DataZlecenia, 0.2
join
SELECT 'Trzeci' as Opisik, '2012-11-21' as dt, 0


SELECT 'Pierwszy' as Opis, getdate() as Dt, 132 as liczba
union
SELECT 'Drugi' as ZupelnieInnyOpis, '2013-01-01' as DataZlecenia, 0.2
union
SELECT 'Trzeci' as Opisik, '2012-11-21' as dt, 0

select 'Pierwszy' as Opis, getdate() as Data, 132 as liczba
UNION
select 'Drugi', '2013-01-01', 'sto dwa'

select Country from [dbo].[Employees]
where Country like 'U%'
union
select Country from [dbo].[Customers]
where Country like 'U%'

select Country from [dbo].[Employees]
where Country like 'U%'
union all
select Country from [dbo].[Customers]
where Country like 'U%'

--EXCEPT

select city from [dbo].[Employees]
where Country = 'USA'
EXCEPT
select city from [dbo].[Customers]
where Country = 'USA'

-- nie dziala
select city from [dbo].[Employees]
where Country = 'USA'
EXCEPT all
select city from [dbo].[Customers]
where Country = 'USA'

--funkacja over

select OrderID , SUM(UnitPrice*Quantity) as TotWartosc
from dbo.[Order Details]
Group by OrderID;

select OrderID, ProductID , 
	SUM(UnitPrice*Quantity) OVER(Partition by OrderID ) as TotWartosc
from dbo.[Order Details];

select city, ROW_NUMBER() OVER(partition by city order by city) as DuplikatNo
from [dbo].[Employees]
where Country = 'USA'
EXCEPT
select city, ROW_NUMBER() OVER(partition by city order by city) as DuplikatNo
from [dbo].[Customers]

--INTERSECT
select city
from [dbo].[Employees]
where Country = 'USA'
INTERSECT
select city
from [dbo].[Customers]
where Country = 'USA'

select country, ROW_NUMBER() OVER(partition by country order by country) as rn
from [dbo].[Employees]
where Country like 'U%'
INTERSECT 
select country, ROW_NUMBER() OVER(partition by country order by country) as rn
from [dbo].[Customers]
where Country like 'U%'

--kolejnosc

Select kol1, kol2, kol3 from tabela1
UNION
Select kol1, kol2, kol3 from tabela2
EXCEPT
Select kol1, kol2, kol3 from tabela3
INTERSECT
(
Select kol1, kol2, kol3 from tabela4
UNION
Select kol1, kol2, kol3 from tabela5
)

--substring

SELECT RIGHT ('hello world' , 3) ;
SELECT LEFT ('hello world' , 3) ;
SELECT CHARINDEX (' ','hello world') ;  --- szuka znaku 
SELECT SUBSTRING ('hello world', 4,5) ;

SELECT LEFT ('hello world' ,  CHARINDEX (' ','hello world') -1 )

SELECT SUBSTRING(`nazwa_kolumny`, pozycja[,liczba_znak w])
FROM `nazwa_tabeli`
WHERE `nazwa_tabeli` operator 'warto  '

 --Znale   najta szy i najdro szy z produkt w kto go dostarczy  do jakiej kategorii 
--nale y 
--(najta szy produkt nie mo e mie  warto ci nieokre lonej lub zero) a w osobnej 
--kolumnie zamie   informacje czy produkt jest najta szy czy najdro szy 



-- znajdz najtanszy i najdrozszy produkt dostarczony przez dostawce ktorego nazwa
 -- zaczyna sie na litere od a-g podaj z jakiej kategorii on pochodzi oraz w dodatkowej
 -- kolumnie czy jest on najdrozszy czy najtanszy produkt nazwa kategorii. 


 