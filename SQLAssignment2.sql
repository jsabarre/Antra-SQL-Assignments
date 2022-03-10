--1) How many products can you find in the Production.Product table?
SELECT COUNT(*) AS NumOfProducts
FROM Production.Product

--2)Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory.
	--The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT COUNT(ProductID) AS NumOfProducts
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL

--3)How many Products reside in each SubCategory? Write a query to display the results with the following titles. 
	--ProductSubcategoryID CountedProducts
SELECT ProductSubcategoryID, COUNT(ProductID) as CountedProducts
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID


--4)How many products that do not have a product subcategory.
SELECT COUNT(*) AS NumOfProducts
FROM Production.Product
WHERE ProductSubcategoryID IS NULL


--5)Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT ProductID, SUM(Quantity) AS ProductSum
FROM Production.ProductInventory
GROUP BY ProductID


--6) Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
SELECT ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100

--7)Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
SELECT Shelf, ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf, ProductID
HAVING SUM(Quantity) < 100

--8)Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT ProductID, AVG(Quantity) AS Average
FROM Production.ProductInventory
WHERE LocationID = 10
GROUP BY ProductID

--9)Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
GROUP BY Shelf,ProductID

--10) Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE Shelf != 'N/A'
GROUP BY Shelf,ProductID

--11)List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
SELECT Color, Class, COUNT(ProductID) AS TheCount, AVG(ListPrice) AS TheAvg
FROM Production.Product
WHERE COLOR IS NOT NULL AND CLASS IS NOT NULL
GROUP BY Color, Class

--12) Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following.
SELECT c.Name AS Country, s.Name AS Province
FROM Person.CountryRegion c  INNER JOIN Person.StateProvince s ON c.CountryRegionCode = s.CountryRegionCode

--13)Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
SELECT c.Name AS Country, s.Name AS Province
FROM Person.CountryRegion c  INNER JOIN Person.StateProvince s ON c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name IN ('Germany', 'Canada')
ORDER BY Country, Province

--NORTHWIND
--14)List all Products that has been sold at least once in last 25 years.
DECLARE @now DATETIME = GETDATE();
SELECT p.ProductName
FROM [Order Details] AS od INNER JOIN Orders o ON o.OrderID = od.OrderID INNER JOIN Products as p ON p.ProductID = od.ProductID
WHERE DATEDIFF(YEAR,@now, o.OrderDate) < 25
GROUP BY p.ProductName 
HAVING COUNT(p.ProductID) >= 1

--15)List top 5 locations (Zip Code) where the products sold most.
SELECT TOP 5 o.ShipPostalCode, COUNT(o.ShipPostalCode) AS TotalSold
FROM [Order Details] AS od INNER JOIN Orders o ON o.OrderID = od.OrderID INNER JOIN Products as p ON p.ProductID = od.ProductID
GROUP BY o.ShipPostalCode
ORDER BY TotalSold DESC

--16)List top 5 locations (Zip Code) where the products sold most in last 25 years.
DECLARE @now DATETIME = GETDATE();
SELECT TOP 5 o.ShipPostalCode, COUNT(o.ShipPostalCode) AS TotalSold
FROM [Order Details] AS od INNER JOIN Orders o ON o.OrderID = od.OrderID
WHERE DATEDIFF(YEAR, @now, o.OrderDate) < 25
GROUP BY o.ShipPostalCode
ORDER BY TotalSold DESC


--17.   List all city names and number of customers in that city.    
SELECT c.City, COUNT(c.CustomerID) AS NumCustomers
FROM Customers c
GROUP BY c.City


--18.  List city names which have more than 2 customers, and number of customers in that city
SELECT c.City, COUNT(c.CustomerID) AS NumCustomers
FROM Customers c
GROUP BY c.City
HAVING COUNT(c.CustomerID) > 2

--19.  List the names of customers who placed orders after 1/1/98 with order date.
SELECT c.CompanyName, o.OrderDate
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE orderDate > '1998-01-01'

--20.  List the names of all customers with most recent order dates
SELECT c.CompanyName, MAX(o.OrderDate) AS RecentOrders
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CompanyName


--21.  Display the names of all customers  along with the  count of products they bought
SELECT c.CompanyName, SUM(od.Quantity) AS ProductCount
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CompanyName
ORDER BY c.CompanyName

--22.  Display the customer ids who bought more than 100 Products with count of products.
SELECT c.CustomerID, SUM(od.Quantity) AS ProductCount
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID
HAVING SUM(od.Quantity) > 100
ORDER BY c.CustomerID

--23.  List all of the possible ways that suppliers can ship their products. Display the results as below
SELECT DISTINCT sup.CompanyName AS 'Supplier Company Name', ship.CompanyName AS 'Shipping Company Name'
FROM Suppliers sup JOIN Products p ON sup.SupplierID = p.SupplierID 
JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
JOIN  Shippers ship ON ship.ShipperID = o.ShipVia
ORDER BY sup.CompanyName


--24.  Display the products order each day. Show Order date and Product Name.
SELECT p.ProductName, o.OrderDate 
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON o.OrderID = od.OrderID
ORDER BY o.OrderDate


--25.  Displays pairs of employees who have the same job title.
SELECT e1.FirstName + ' ' + e1.LastName as 'FirstEmp', e2.FirstName + ' ' + e2.LastName as 'SecondEmp'
FROM Employees as e1 JOIN Employees as e2 ON e1.Title = e2.Title

--26.  Display all the Managers who have more than 2 employees reporting to them.
SELECT e.FirstName + ' ' + e.LastName as Managers
FROM Employees e
WHERE EmployeeID IN
(
SELECT ReportsTo 
FROM Employees
GROUP BY ReportsTo
HAVING COUNT(*) > 2)

--27.  Display the customers and suppliers by city. The results should have the following columns
SELECT City, CompanyName AS Name, ContactName,  'Customer' AS Type
FROM Customers
UNION
SELECT City, CompanyName AS Name, ContactName, 'Supplier' AS Type
FROM Suppliers
