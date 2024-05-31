USE sql_project;

-- SECTION A
--  (1) Select customer name together with each order the customer made.
SELECT customer.CustomerName, products.ProductName, orders.OrderID, order_details.ProductID, order_details.Quantity, orders.OrderDate
FROM customer
JOIN orders ON customer.CustomerID = orders.CustomerID
JOIN order_details ON orders.OrderID = order_details.OrderID
JOIN products ON order_details.ProductID = products.ProductID;


-- (2) Select order id together with name of employee who handled the order.
SELECT orders.OrderID, CONCAT(LastName, " ", FirstName) as EmployeeName
FROM orders
JOIN employees on orders.EmployeeID = employees.EmployeeID;


-- (3) Select customers who did not placed any order yet.
SELECT customer.CustomerID, customer.CustomerName, orders.OrderID
FROM customer
LEFT JOIN orders ON customer.CustomerID = orders.CustomerID
WHERE orders.OrderID IS NULL;

-- (4) Select order id together with the name of products.
SELECT orders.OrderID, products.ProductName
FROM orders
JOIN order_details ON orders.OrderID = order_details.OrderID
JOIN products ON order_details.ProductID = products.ProductID;


-- (5) Select products that no one bought
SELECT DISTINCT ProductID 
FROM order_details;

SELECT ProductID, ProductName
FROM products
WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM order_details);

SELECT products.ProductID, products.ProductName
FROM products
JOIN order_details ON products.ProductID = order_details.ProductID
JOIN orders ON order_details.OrderID = orders.OrderID
WHERE orders.OrderID IS NULL;


-- (6) Select customer together with the products that he bought.
SELECT customer.CustomerID, customer.CustomerName, products.ProductName
FROM customer
JOIN orders ON customer.CustomerID = orders.CustomerID
JOIN order_details ON orders.OrderID = order_details.OrderID
JOIN products ON order_details.ProductID = products.ProductID;

-- (7) Select product names together with the name of corresponding category.
SELECT products.ProductName, categories.CategoryName
FROM products
JOIN categories ON products.CategoryID = Categories.CategoryID;


-- (8) Select orders together with the name of the shipping company.
SELECT orders.OrderID, ShipperName
FROM orders
JOIN shippers ON orders.ShipperID = shippers.ShipperID;


-- (9) Select customers with id greater than 50 together with each order they made.
SELECT customer.CustomerID, orders.OrderID, order_details.Quantity, orders.OrderDate
FROM customer
JOIN orders ON customer.CustomerID = orders.CustomerID
JOIN order_details ON orders.OrderID = order_details.OrderID
WHERE customer.CustomerID > 50;


-- (10) Select employees together with orders with order id greater than 10400
SELECT employees.EmployeeID, CONCAT(LastName, " ", FirstName) as EmployeeName, orders.OrderID, orders.OrderDate
FROM employees
JOIN orders ON employees.EmployeeID = orders.EmployeeID
WHERE orders.OrderID > 10400;


-- (11) Select the most expensive product
SELECT ProductName, Price
FROM products
ORDER BY Price DESC
LIMIT 1;

SELECT ProductName, Price AS MaxPrice
FROM products
WHERE Price = (SELECT MAX(Price) FROM products);

-- (12) Select the second most expensive product.
SELECT ProductName, Price
FROM products
ORDER BY Price DESC
LIMIT 1 OFFSET 1;


-- (13) Select name and price of each product, sort the result by price in decreasing order.
SELECT ProductName, Price
FROM products
ORDER BY Price DESC;


-- (14) Select 5 most expensive products
Select ProductName, Price
From products
ORDER BY Price DESC
LIMIT 5;


-- (15) Select 5 most expensive products without the most expensive (in final 4 products).
SELECT ProductName, Price
FROM products
WHERE Price < (
    SELECT MAX(Price)
    FROM products
)
ORDER BY Price DESC
LIMIT 5;


-- (16) Select name of the cheapest product (only name) without using LIMIT and OFFSET.
SELECT p1.ProductName
FROM products p1
LEFT JOIN products p2 ON p2.Price < p1.Price
WHERE p2.ProductID IS NULL;


-- (17) Select name of the cheapest product (only name) using subquery.
SELECT ProductName
FROM products
WHERE Price = (SELECT MIN(Price) FROM products);


-- (18) Select number of employees with LastName that starts with 'D'.
SELECT COUNT(*)
FROM employees
WHERE LastName LIKE "%D%";
-- the "%D" keeps returning 0 rows, so I used "%D%" instead


-- (19) Select customer name together with the number of orders made by the corresponding  customer, sort the result by number of orders in decreasing order.
SELECT customer.CustomerName, COUNT(orders.OrderID) AS NumberOfOrders
FROM customer
JOIN orders ON customer.CustomerID = orders.CustomerID
GROUP BY customer.CustomerID
ORDER BY NumberOfOrders DESC;


-- (20) Add up the price of all products.
SELECT SUM(Price) AS TotalPrice
FROM products;


-- (21) Select orderID together with the total price of that Order, order the result by total price of order in increasing order.
SELECT OrderID, SUM(order_details.Quantity * products.Price) AS TotalPrice
FROM order_details
JOIN products ON order_details.ProductID = products.ProductID
GROUP BY OrderID
ORDER BY TotalPrice ASC;

SELECT *
FROM products;


-- (22) Select customer who spend the most money.
SELECT CustomerName, SUM(Quantity * Price) AS TotalSpent
FROM customer
JOIN orders USING(CustomerID)
JOIN order_details USING(OrderID)
JOIN products USING(ProductID)
GROUP BY CustomerID
ORDER BY TotalSpent DESC
LIMIT 1;



-- (23)  Select customer who spend the most money and lives in Canada







-- (24) Select customer who spend the second most money.
SELECT CustomerName, SUM(Quantity * Price) AS TotalSpent
FROM customer
JOIN orders USING(CustomerID)
JOIN order_details USING(OrderID)
JOIN products USING(ProductID)
GROUP BY CustomerID
ORDER BY TotalSpent DESC
LIMIT 1
OFFSET 1;


-- (25) Select shipper together with the total price of proceed orders.
SELECT ShipperID, ShipperName, SUM(Quantity * Price) AS TotalPrice
FROM shippers
JOIN orders USING (ShipperID)
JOIN order_details USING (OrderID)
JOIN products USING (ProductID)
GROUP BY ShipperID, ShipperName
ORDER BY TotalPrice DESC;



-- SECTION B 

-- (1) Total number of products sold so far
SELECT SUM(Quantity) AS "Total Products Sold"
FROM order_details;


-- (2) Total Revenue So far.
SELECT SUM(order_details.Quantity * products.Price) AS "Total Revenue"
FROM order_details
JOIN products USING (ProductID);


-- (3) Total Unique Products sold based on category
SELECT COUNT(DISTINCT products.ProductID) AS "Total Unique Products", categories.CategoryName
FROM products
JOIN categories ON products.CategoryID = categories.CategoryID
JOIN order_details ON products.ProductID = order_details.ProductID
GROUP BY categories.CategoryName;


-- (4) Total Number of Purchase Transactions from customers
SELECT COUNT(DISTINCT OrderID) AS "Total Transactions"
FROM orders;


-- (5) Compare Orders made between 2021 – 2022
SELECT YEAR(OrderDate) AS OrderYear, COUNT(DISTINCT OrderID) AS 'Total Orders'
FROM orders
WHERE YEAR(OrderDate) = 2022 OR YEAR(OrderDate) = 2023
GROUP BY YEAR(OrderDate);


-- (6) What is total number of customers? Compare those that have made transaction and those that haven’t at all.    
SELECT CASE
			WHEN orders.CustomerID IS NOT NULL THEN 'Made Transaction'
			ELSE 'No Transaction'
		END AS TransactionStatus,
    COUNT(DISTINCT customer.CustomerID) AS CustomerCount
FROM customer
LEFT JOIN orders ON customer.CustomerID = orders.CustomerID
GROUP BY TransactionStatus;

    
    -- (7) Who are the Top 5 customers with the highest purchase value?
SELECT customer.CustomerID, customer.CustomerName, SUM(order_details.Quantity * products.Price) AS 'Total Purchase Value'
FROM customer
JOIN orders ON customer.CustomerID = orders.CustomerID
JOIN order_details ON orders.OrderID = order_details.OrderID
JOIN products ON order_details.ProductID = products.ProductID
GROUP BY customer.CustomerID, customer.CustomerName
ORDER BY 'Total Purchase Value' DESC
LIMIT 5;


-- (8) Top 5 best-selling products.
SELECT products.ProductID, products.ProductName, SUM(order_details.Quantity) AS 'Total Quantity Sold'
FROM products
JOIN order_details ON products.ProductID = order_details.ProductID
GROUP BY products.ProductID, products.ProductName
ORDER BY 'Total Quantity Sold' DESC
LIMIT 5;


-- (9) What is the Transaction value per month?
SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS Month, SUM(Quantity * Price) AS 'Total Transaction Value'
FROM orders
JOIN order_details USING (OrderID)
JOIN products USING (ProductID)
GROUP BY Month
ORDER BY Month;


-- (10) Best Selling Product Category
SELECT categories.CategoryName, SUM(order_details.Quantity) AS TotalQuantitySold
FROM order_details
JOIN products ON order_details.ProductID = products.ProductID
JOIN categories ON products.CategoryID = categories.CategoryID
GROUP BY categories.CategoryName
ORDER BY TotalQuantitySold DESC
LIMIT 1;


-- (11) Buyers who have Transacted more than two times.
SELECT customer.CustomerID, customer.CustomerName, COUNT(orders.OrderID) AS "Total Transactions"
FROM customer
JOIN orders ON customer.CustomerID = orders.CustomerID
GROUP BY customer.CustomerID, customer.CustomerName
HAVING COUNT(orders.OrderID) > 2;


-- (12) Most Successful Employee
SELECT employees.EmployeeID,
    CONCAT(employees.LastName, ', ', employees.FirstName) AS EmployeeName,
    SUM(order_details.Quantity * products.Price) AS TotalSalesAmount
FROM employees
JOIN orders ON employees.EmployeeID = orders.EmployeeID
JOIN order_details ON orders.OrderID = order_details.OrderID
JOIN products ON order_details.ProductID = products.ProductID
GROUP BY employees.EmployeeID, employees.FirstName, employees.LastName
ORDER BY TotalSalesAmount DESC
LIMIT 1;


-- (13) Most use Shipper
SELECT shippers.ShipperID, shippers.ShipperName, COUNT(orders.OrderID) AS TotalOrdersHandled
FROM shippers
JOIN orders ON shippers.ShipperID = orders.ShipperID
GROUP BY shippers.ShipperID, shippers.ShipperName
ORDER BY TotalOrdersHandled DESC
LIMIT 1;


-- (14) Most use Supplier
SELECT suppliers.SupplierID, suppliers.SupplierName, COUNT(products.ProductID) AS TotalProductsSupplied
FROM suppliers
JOIN products ON suppliers.SupplierID = products.SupplierID
GROUP BY suppliers.SupplierID, suppliers.SupplierName
ORDER BY TotalProductsSupplied DESC
LIMIT 1;



