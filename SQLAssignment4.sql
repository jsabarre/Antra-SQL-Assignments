--1) Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.
CREATE VIEW view_product_order_Sabarre
AS
SELECT p.ProductName, SUM(od.Quantity) as TotalOrderedQuantity
FROM Products p INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY ProductName

SELECT *
FROM view_product_order_Sabarre

--2)Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter.
CREATE PROC sp_product_order_quantity_Sabarre
@productID Int, @totalOrderedQuantity int out
AS
BEGIN
SELECT @totalOrderedQuantity = SUM(od.Quantity)
FROM Products p INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
WHERE p.ProductID = @productID
END

BEGIN
DECLARE @totalOrderedQuantity int
EXEC sp_product_order_quantity_Sabarre 10, @totalOrderedQuantity RETURN
PRINT @totalOrderedQuantity
END

--3)Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input and top 5 cities that ordered most that product combined with the total quantity of that product ordered from that city as output.
CREATE PROC sp_product_order_city_Sabarre
@productName varchar(20)
AS
BEGIN
SELECT TOP 5 o.ShipCity, SUM(od.Quantity) AS OrderQuantity
FROM Products p INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
INNER JOIN Orders o ON o.OrderID = od.OrderID
WHERE p.ProductName = @productName
GROUP BY ProductName, ShipCity
ORDER BY SUM(od.Quantity) DESC
END

BEGIN
EXEC sp_product_order_city_Sabarre 'Tofu'
END

--4)Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay. If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.
CREATE TABLE people_Sabarre
(
Id int, name varchar(20), city int
)

CREATE TABLE city_Sabarre
(
Id int, city varchar(20)
)

INSERT INTO city_Sabarre VALUES (1, 'Seattle')
INSERT INTO city_Sabarre VALUES (2, 'Green Bay')
SELECT * FROM city_Sabarre

INSERT INTO people_Sabarre VALUES (1, 'Aaron Rodgers', 1)
INSERT INTO people_Sabarre VALUES (2, 'Russell Wilson', 2)
INSERT INTO people_Sabarre VALUES (3, 'Jody Nelson', 2)
SELECT * FROM people_Sabarre

DELETE FROM city_Sabarre WHERE city = 'Seattle'

INSERT INTO city_Sabarre values (3,'Madison')
UPDATE people_Sabarre
SET city = 3 WHERE city = 1

CREATE VIEW packers_Sabarre
AS
SELECT name FROM people_Sabarre WHERE city = 'Green Bay'
SELECT * FROM packers_Sabarre

DROP TABLE people_Sabarre
DROP TABLE city_Sabarre
DROP VIEW packers_Sabarre

--5)Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.
CREATE PROC sp_birthday_employees_Sabarre
AS
BEGIN
CREATE TABLE birthday_employees_Sabarre(Id int primary key,
[first name] varchar(20),
[last name] varchar(20),
birthDate datetime)
INSERT INTO birthday_employees_Sabarre(Id, [first name], [last name], birthDate)
SELECT e.EmployeeID, e.FirstName, e.LastName, e.BirthDate FROM Employees e
WHERE month(e.birthDate) = 2
END

EXEC sp_birthday_employees_Sabarre

SELECT * FROM birthday_employees_Sabarre

DROP TABLE birthday_employees_Sabarre

SELECT * FROM Employees


--6)