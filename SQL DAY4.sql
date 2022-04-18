

--1. Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.
CREATE VIEW view_product_order_siu AS
SELECT p.ProductName
, sum(quantity) as total_cnt
from 
[Order Details] od inner join Products p on p.ProductID = od.ProductID
Group by p.ProductName

--2. Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter.
CREATE PROC sp_product_order_quantity_siu
@productid int
@quantity varchar(30) out
AS
BEGIN
SELECT 
FROM @quantity = sum(quantity)
FROM [Order Details} ord innner join products p on p.productid = ord.productID
WHERE @PRODUCTID = P.PRODUCTID
END

---3. Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input and top 5 cities 
--that ordered most that product combined with the total quantity of that product ordered from that city as output.
CREATE PROC sp_Product_Order_City_SIU
@ProductName varchar(50)
AS
BEGIN
SELECT TOP 5 ShipCity,SUM(Quantity) FROM [Order Details] ord JOIN Products p ON P.ProductID = ord.ProductID JOIN Orders o ON O.OrderID = ord.OrderID
WHERE ProductName=@ProductName
GROUP BY ProductName,ShipCity
ORDER BY SUM(Quantity) DESC
END


--4. Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}.
--People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. 
--Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay. 
--If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.
CREATE TABLE People_SIU
(
id int ,
Name nvarchar(100),
city int
)
CREATE TABLE City_SIU
(
ID int,
CITY nvarchar(100)
)
BEGIN TRAN 
insert into City_SIU values(1,'Seattle')
insert into City_SIU values(2,'Green Bay')

insert into People_siu values(1,'Aaron Rodgers',1)
insert into People_siu values(2,'Russell Wilson',2)
insert into People_siu values(3,'Jody Nelson',2)

BEGIN
insert into City_siu values(3,'Madison')
update People_siu
set city = 'Madison'
where id in (select id from People_siu where city = (select id from City_siu where city = 'Seatle'))
end
delete from City_siu where city = 'Seattle'

CREATE VIEW Packers_SIU
AS
SELECT NAME FROM People_SIU WHERE city = 'Green Bay'

select * from Packers_SIU
commit
drop table People_SIU
drop table City_SIU
drop view Packers_SIU

--5.Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.
CREATE PROC sp_birthday_employee_siu
AS
BEGIN
SELECT * INTO #Employee
FROM Employees WHERE DATEPART(m,BirthDate) = 2
SELECT * FROM #Employee
END



--6. How do you make sure two tables have the same data?

USE EXCEPT?