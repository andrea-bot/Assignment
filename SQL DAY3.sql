--1. List all cities that have both Employees and Customers.

SELECT distinct e.City
FROM Employees e
inner join Customers c on e.city = c.city 


--2. List all cities that have Customers but no Employee.
--a. Use sub-query
--b. Do not use sub-query
SELECT c.City
FROM Customers c
Where city  not in ( select distinct city from Employees )


SELECT C.CITY
FROM Customers c  
left join Employees e on c.city =e.city
where e.City is null 



--3.  List all products and their total order quantities throughout all orders.
SELECT productname, sum(quantity) sum_q
From Products p inner join  [Order Details] od on p.ProductID = od.ProductID 
GROUP BY ProductName
order by sum_q


--4. List all Customer Cities and total products ordered by that city.
SELECT c.city ,sum(od.quantity) as sum_q
From customers  c inner join  orders o on c.CustomerID = o.CustomerID inner join [Order Details]  od on o.OrderID =od.OrderID
GROUP BY C.CITY
ORDER BY SUM_q


--5. List all Customer Cities that have at least two customers.

--a. Use union

select distinct city
from
(
select 
city
,count(distinct CustomerID) as c_cnt
from 
Customers c
group by city 
) as temp1
where c_cnt=2
union all
select distinct city
from
(
select 
city
,count(distinct CustomerID) as c_cnt
from 
Customers c
group by city 
) as dt
where c_cnt>2


--b. Use sub-query and no union
select distinct city
from
(
select 
city
,count(distinct CustomerID) as c_cnt
from 
Customers c
group by city 
) as dt
where c_cnt>=2



--6. List all Customer Cities that have ordered at least two different kinds of products.

select 
city
from 
(
SELECT 
c.City
,count(distinct od.productid) as p_cnt
From orders ord inner join [Order Details] od on od.OrderID = ord.orderid inner join Customers c on c.CustomerID = ord.CustomerID
group by c.city 
) dt
where p_cnt >=2


--7.List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.

select 
distinct c.ContactName
from orders ord inner join customers c on ord.CustomerID = c.CustomerID
where ord.ShipCity <> c.city 


--8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.


with product_top5_q as (
select 
ProductName
,avg_p
,order_q
from 
(
SELECT 
p.ProductName
,AVG(od.UnitPrice) AS avg_p
,sum(od.quantity) as order_q
,rank() over (order by sum(od.quantity) desc) as rnk_q
FROM Products p inner join  [Order Details] od on p.productid =od.ProductID inner join orders ord on ord.OrderID = od.OrderID
inner join Customers cust on cust.CustomerID = ord.CustomerID
group by p.ProductName
) dt
where rnk_q<=5
) 

, product_top_city as (

select 
productname
,city
from 
(
SELECT 
p.ProductName
,cust.city
,sum(od.quantity) as order_q_city
,rank() over (partition by p.productname order by sum(od.quantity) desc) as rk_city_q 
FROM Products p inner join  [Order Details] od on p.productid =od.ProductID inner join orders ord on ord.OrderID = od.OrderID
inner join Customers cust on cust.CustomerID = ord.CustomerID
group by p.ProductName,cust.city
) dt
where rk_city_q =1
)

SELECT
ptq.ProductName
,ptq.avg_p
,ptc.city
from product_top5_q ptq
inner join product_top_city ptc on ptq.productname = ptc.productname



--9.List all cities that have never ordered something but we have employees there.

--a.Use sub-query
SELECT distinct e.City
FROM employees e
where e.city not in (
select distinct c.city 
From customers c inner join orders o on c.customerid = o.customerid)


--b.Do not use sub-query

select 
distinct e.city
from orders o
 inner join Customers c on o.CustomerID = o.CustomerID right join Employees e on e.city = c.city 
 where c.city is null 

--10. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is
--and also the city of most total quantity of products ordered from. (tip: join  sub-query)

with most_order_emp_city as (
select city from 
(
select e.city, count(o.orderID) as cnt_o,rank() over (order by count(o.orderID) desc) as rnk_o
from  Employees e inner join Orders o on e.EmployeeID = o.EmployeeID
Group by City
) dt
where rnk_o =1 
)

,shipcity_order_q as (
select 
shipcity
from 
(
select o.shipcity,sum(ord.Quantity) as sum_q ,rank () over (order by sum(ord.Quantity) desc) as rnk_q
From orders o inner join [Order Details] ord on o.OrderID=ord.OrderID
Group by o.shipcity 
) dt
where rnk_q = 1 
)

select * from 
most_order_emp_city moec inner join shipcity_order_q soq  on  moec.City = soq.ShipCity


--11. How do you remove the duplicates record of a table?

GROUP BY AND WINDOW FUNCTION