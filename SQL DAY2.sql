--1.How many products can you find in the Production.Product table?
SELECT COUNT(name)
FROM Production.Product

--2. Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT COUNT(name)
FROM Production.Product
WHERE ProductSubcategoryID is not Null

--3.How many Products reside in each SubCategory? Write a query to display the results with the following titles.
SELECT ProductSubcategoryID,Count (name) as CountedProducts
--OM production.productsubCategory
FROM production.Product
GROUP by ProductSubcategoryID



--4. How many products that do not have a product subcategory.
SELECT Count(Name)
FROM Production.Product
WHERE  productsubCategoryID IS NULL

--5.Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT SUM(Quantity) as TheSum
FROM Production.ProductInventory

--6. Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
SELECT
ProductID 
,SUM(Quantity) as TheSum
FROM Production.ProductInventory
WHERE LocationID =40 
group by ProductID 
 having SUM(Quantity) <100


--7.Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100

SELECT
ProductID 
,Shelf
,SUM(Quantity) as TheAvg
FROM Production.ProductInventory
WHERE LocationID =40 
group by ProductID, Shelf
having SUM(Quantity) <100

--8.Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
select 
avg(Quantity)
FROM Production.ProductInventory
WHERE LocationID =10



--9. Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
select
Productid
,shelf
,avg(Quantity) as TheAvg
FROM Production.ProductInventory
group by shelf, productid 


--10.Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory

select
Productid
,shelf
,avg(Quantity) as TheAvg
FROM Production.ProductInventory
where shelf <> 'N/A' 
group by shelf, Productid


--select top 10 * from Production.ProductInventory 


--11. List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
select 
color
,class
,count(*) as TheCount
,avg(listprice) as AvgPrice
from  Production.Product
where color is not null and class is not null 
group by color,class


--JOINS
--12.Write a query that lists the country and province names from person.CountryRegion and person.StateProvince tables. Join them and produce a result set similar to the following.

SELECT pc.name Country , ps.name Province
From  person.CountryRegion pc inner join person.StateProvince ps on pc.CountryRegionCode =ps.CountryRegionCode
ORDER BY pc.name,ps.name


--13.Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the followin
SELECT pc.name Country , ps.name Province
From  person.CountryRegion pc inner join person.StateProvince ps on pc.CountryRegionCode =ps.CountryRegionCode
WHERE pc.name in ('Germany','Canada')
ORDER BY pc.name,ps.name


USE Northwind
GO
--14. List all Products that has been sold at least once in last 25 years.

select distinct pd.ProductName from [dbo].[Order Details] od inner join [dbo].[Products] pd on od.ProductID = pd.ProductID inner join [dbo].[Orders] ord on ord.orderid = od.OrderID
where ord.OrderDate > '1997-01-01'

--15.List top 5 locations (Zip Code) where the products sold most.
select 
top 5
ord.ShipPostalCode
,sum(od.quantity) as sum_q
from [dbo].[Order Details] od inner join [dbo].[Orders] ord on ord.orderid = od.OrderID
where ord.ShipPostalCode is not null 
group by ord.ShipPostalCode
order by sum_q desc 

--16.List top 5 locations (Zip Code) where the products sold most in last 25 years.
select 
top 5
ord.ShipPostalCode
,sum(od.quantity) as sum_q
from [dbo].[Order Details] od inner join [dbo].[Orders] ord on ord.orderid = od.OrderID
where ord.ShipPostalCode is not null  
and ord.OrderDate > '1997-01-01'
group by ord.ShipPostalCode
order by sum_q desc 

--17.List all city names and number of customers in that city.     
select 
city,
count(customerid) as cnt
from 
[dbo].[Customers]
group by city

--.18. List city names which have more than 2 customers, and number of customers in that city
select 
city,
count(customerid) as cnt
from 
[dbo].[Customers]
group by city
having count(customerid)>2

--19.  List the names of customers who placed orders after 1/1/98 with order date.

select 
cust.[ContactName]
,ord.OrderDate
from 
[dbo].[Orders] ord inner join [dbo].[Customers] cust on ord.customerid = cust.customerid 
where ord.OrderDate > '1998-01-01'


--20.  List the names of all customers with most recent order dates
select 
cust.[ContactName]
,max(ord.OrderDate) as most_recent_order_date
from 
[dbo].[Orders] ord inner join [dbo].[Customers] cust on ord.customerid = cust.customerid 
group by cust.[ContactName]

--22.  Display the customer ids who bought more than 100 Products with count of products.

select 
ord.CustomerID
,sum(od.quantity)
from 
[dbo].[Order Details] od inner join [dbo].[Orders] ord on od.orderid = ord.orderid 
group by ord.CustomerID
having sum(od.quantity)>100


--23.  List all of the possible ways that suppliers can ship their products. Display the results as below

select 
distinct sp.CompanyName as suppliercompanyname 
,shp.CompanyName as shippingcompanyname 
from [dbo].[Orders] ord inner join [dbo].[Shippers] shp on ord.ShipVia = shp.ShipperID
inner join [dbo].[Order Details] od on od.orderid = ord.orderid 
inner join [dbo].[Products] prd on prd.ProductID = od.ProductID
inner join [dbo].[Suppliers] sp on prd.SupplierID = sp.SupplierID



--24. Display the products order each day. Show Order date and Product Name.
select 
ord.OrderDate
,prd.ProductName
from [dbo].[Orders] ord 
inner join [dbo].[Order Details] od on od.orderid = ord.orderid 
inner join [dbo].[Products] prd on prd.ProductID = od.ProductID


--25.Displays pairs of employees who have the same job title.
select 
e1.lastname
,e1.FIRSTname
,e2.lastname
,e2.FIRSTname
,e1.Title
from 
[dbo].[Employees] e1 inner join [dbo].[Employees] e2 on (e1.title = e2.title  and e1.employeeid > e2.employeeid)



--26.Display all the Managers who have more than 2 employees reporting to them.


select 
e2.FirstName+e2.lastname as manager_name
,count(e1.employeeid) 
from 
[dbo].[Employees] e1 inner join [dbo].[Employees] e2 on (e1.reportsto = e2.EmployeeID )
group by e2.FirstName+e2.lastname
having count(e1.employeeid) >2



--27.Display the customers and suppliers by city. The results should have the following columns

select 
sp.city
,sp.CompanyName
,sp.ContactName
,cust.[CompanyName] 
,cust.[ContactName]
from 
[dbo].[Suppliers] sp 
inner join [dbo].[Customers] cust on cust.city =  sp.city