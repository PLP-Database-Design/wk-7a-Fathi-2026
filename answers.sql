Question 1: Achieving 1NF (First Normal Form) 🛠️
To achieve First Normal Form (1NF), we need to split the Products column into individual rows, making sure each row represents a single product for an order.

sql
Copy
Edit
-- Achieving 1NF: Create a new table that splits the Products column into individual rows
CREATE TABLE ProductDetail_1NF (
  OrderID INT,
  CustomerName VARCHAR(255),
  Product VARCHAR(255)
);

-- Insert data from the original table into the new table by splitting the Products column
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT OrderID, CustomerName, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.n), ',', -1)) AS Product
FROM ProductDetail
JOIN (SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) n
  ON CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= n.n - 1;

Question 2: Achieving 2NF (Second Normal Form) 🧩
To achieve Second Normal Form (2NF), we need to remove partial dependencies by creating two tables:

A Customers table to store the customer information.

An OrderDetails table to store the product and quantity information for each order.

sql
Copy
Edit
-- Create a new table for customers to remove partial dependency
CREATE TABLE Customers (
  OrderID INT PRIMARY KEY,
  CustomerName VARCHAR(255)
);

-- Create a new table for order details to store products and quantities
CREATE TABLE OrderDetails (
  OrderID INT,
  Product VARCHAR(255),
  Quantity INT,
  PRIMARY KEY (OrderID, Product),
  FOREIGN KEY (OrderID) REFERENCES Customers(OrderID)
);

-- Insert data into the Customers table
INSERT INTO Customers (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Insert data into the OrderDetails table
INSERT INTO OrderDetails (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
