--1)      List all cities that have both Employees and Customers.
SELECT DISTINCT City 
FROM Customers 
WHERE City IN 
(
SELECT City
FROM Employees
)

--2)      List all cities that have Customers but no Employee.
--a.      Use sub-query
SELECT DISTINCT City 
FROM Customers 
WHERE City NOT IN 
(
SELECT City
FROM Employees
)

--b.      Do not use sub-query
SELECT DISTINCT c.City
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE c.City NOT IN
(
SELECT City
FROM Employees
)


--3)  List all products and their total order quantities throughout all orders.
SELECT DISTINCT p.ProductID, p.ProductName, SUM(od.Quantity) As TotalOrderQuantities
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName


--4) List all Customer Cities and total products ordered by that city.
SELECT c.City, SUM(od.Quantity) As TotalOrderQuantities
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.City
ORDER BY c.City

--5)    List all Customer Cities that have at least two customers.
--a.      Use union
SELECT DISTINCT c.City
FROM Customers c
GROUP BY c.City
HAVING COUNT(c.City) >=2
UNION 
SELECT o.ShipCity
FROM Orders o
GROUP BY o.ShipCity
HAVING COUNT(o.ShipCity) >=2


--b.      Use sub-query and no union
SELECT DISTINCT c.City
FROM Customers c
WHERE c.City IN 
(
SELECT o.ShipCity
FROM Orders o
GROUP BY o.ShipCity
HAVING COUNT(*) >=2
)


--6) List all Customer Cities that have ordered at least two different kinds of products.
SELECT DISTINCT c.City
FROM Customers c LEFT JOIN Orders o on c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od ON o.OrderID=od.OrderID
GROUP BY c.City
HAVING COUNT(*) >=2
ORDER By c.City


--7)List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
SELECT DISTINCT c.CustomerID, c.ContactName, c.City, o.ShipCity
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID AND c.City != o.ShipCity
WHERE o.ShipCity IS NOT NULL


--8)List 5 most popular products, their average price, and the customer city that ordered most quantity of it.


--9) List all cities that have never ordered something but have employees there.
--a.      Use sub-query
SELECT e.City
FROM Employees e 
WHERE e.City NOT IN
(
SELECT DISTINCT o.ShipCity FROM Orders o
)

--b.      Do not use sub-query
SELECT DISTINCT e.City
FROM Employees e LEFT JOIN Orders o ON e.City = o.ShipCity
WHERE o.ShipCity IS NULL

--10)List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)
SELECT o.ShipCity 
FROM Orders o
WHERE o.ShipCity IN 
(
SELECT TOP 1 o.ShipCity 
FROM [Order Details] od INNER JOIN Orders o ON od.OrderID = o.OrderID
GROUP BY o.ShipCity 
ORDER BY SUM(od.Quantity) DESC) 
GROUP BY o.ShipCity 
ORDER BY COUNT(*) 


--11)How do you remove the duplicates record of a table?

--Remove duplicate records of a table using Common Table Expressions CTE, ROW_NUMBER Function and the RANK Function