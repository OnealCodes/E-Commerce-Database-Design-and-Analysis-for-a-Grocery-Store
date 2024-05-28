CREATE DATABASE SQL_PROJECT;

USE SQL_PROJECT;

CREATE TABLE customer(
	CustomerID int auto_increment primary key,
    CustomerName varchar(255) NOT NULL unique,
    ContactName varchar(255) NOT NULL,
    Address varchar(255) default 'Not Provided',
    PostalCode varchar(255),
    Country varchar(225)
);


CREATE TABLE categories(
	CategoryID int auto_increment primary key,
    CategoryName varchar(255) NOT NULL,
    Description varchar(255)
);


CREATE TABLE employees(
EmployeeID int auto_increment primary key,
LastName varchar(255),
FirstName varchar(255),
BirthDate date,
Photo varchar(255) default null,
Notes text
);


CREATE TABLE suppliers(
SupplierID int auto_increment primary key,
SupplierName varchar(255),
ContactName varchar(255),
Address varchar(255),
City varchar(255),
PostalCode varchar(255),
Phone varchar(255)
);


CREATE TABLE shippers(
ShipperID int auto_increment primary key,
ShipperName varchar(255),
Phone varchar(255)
);


CREATE TABLE products(
	ProductID int auto_increment primary key,
    ProductName varchar(255) NOT NULL,
    SupplierID int NOT NULL,
    CategoryID int NOT NULL,
    Unit varchar(255),
    Price Double NOT NULL CHECK (Price >= 0),
    
    CONSTRAINT FK_SupplierID FOREIGN KEY (SupplierID) REFERENCES suppliers(SupplierID),
    CONSTRAINT FK_CategoryID FOREIGN KEY (CategoryID) REFERENCES categories(CategoryID)
);

CREATE TABLE orders(
	OrderID int auto_increment primary key,
    CustomerID int NOT NULL,
    EmployeeID int NOT NULL,
    OrderDate date NOT NULL,
    ShipperID int NOT NULL,
    
    CONSTRAINT FK_EmployeeID FOREIGN KEY (EmployeeID) REFERENCES employees(EmployeeID),
    CONSTRAINT FK_ShipperID FOREIGN KEY (ShipperID) REFERENCES shippers(ShipperID)
);

CREATE TABLE order_details(
	OrderDetailID int auto_increment primary key,
    OrderID int NOT NULL,
    ProductID int NOT NULL,
    Quantity int NOT NULL,
    
    CONSTRAINT FK_OrderID FOREIGN KEY (OrderID) REFERENCES orders(OrderID), 
	CONSTRAINT FK_ProductID FOREIGN KEY (ProductID) REFERENCES products(ProductID)
);

-- Altering the customer table to add city column
ALTER TABLE customer
ADD column City varchar(255);

-- Altering the suppliers table to add country column
ALTER TABLE suppliers
ADD column Country varchar(255);



-- INSERTING/IMPORTING VALUES INTO THE TABLES
-- categories values was imported from existing data
-- customer values was imported from existing data
-- employees values was imported from existing data
-- shippers values was imported from existing data
-- orders values was imported from existing data
-- suppliers values was imported from existing data
-- products values was imported from existing data
-- order_details values was imported from existing data


SELECT *
FROM order_details;




