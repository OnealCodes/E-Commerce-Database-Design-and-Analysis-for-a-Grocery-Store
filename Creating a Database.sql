CREATE DATABASE WEEKEND_CLASS;
USE weekend_class;

CREATE TABLE Customer(
	customer_id int auto_increment primary key,
    first_name varchar(225) NOT NULL,
    last_name varchar(225) NOT NULL,
    gender enum ("male", "female"),
    address text default null,
    email varchar(150) NOT NULL unique
);

CREATE TABLE Orders(
	order_id int auto_increment primary key,
    order_date date not null,
    customer_id int not null,
    
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE order_details(
	orderdetails_id int auto_increment primary key,
    order_id int not null,
    product_id int not null,
    quantity int not null,orderdetails
    
    CONSTRAINT order_id FOREIGN KEY (order_id) REFERENCES orders(order_id), 
    CONSTRAINT product_id FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE product(
	product_id int auto_increment primary key,
    name varchar(150) not null,
    description text default null,
    price float not null,
    stock_quantity int
);

-- MODIFICATION OF TABLES, WE USE KEYWORD "ALTER"
ALTER TABLE customer
ADD CONSTRAINT email UNIQUE(email);

ALTER TABLE customer
ADD column phone_no int(50) not null;

ALTER TABLE order_details
ADD CONSTRAINT ORDER_ID FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE order_details
ADD CONSTRAINT PRODUCT_ID FOREIGN KEY (product_id) REFERENCES product(product_id);


ALTER TABLE order_details
DROP FOREIGN KEY order_details_ibfk_1;

ALTER TABLE order_details
DROP FOREIGN KEY order_details_ibfk_2;

DROP TABLE orders;
DROP TABLE customer;

-- ---------------------------------------------------------------------------------------
-- INSERT VALUES INTO OUR TABLES
-- DATA FOR THE PRODUCT TABLE WAS IMPORTED
-- 	INSERTING VALUES FOR CUSTOMER TABLE
INSERT INTO customer (first_name, last_name, gender, address, email)
VALUES ("John", "Gideon", "male", "Ikeja", "JohnG@gmail.com"), 
("Mary", "SImpson", "female", "Ogudu,Lagos", "mary@wat.com"),
("Sade", "Olu", "female", "Ibadan,Oyo", "Sade.wat.com");

SELECT sum(price)
FROM product;

-- Generate values for all the tables and insert the values
-- 	INSERTING VALUES FOR ORDERS TABLE
INSERT INTO Orders (order_date, customer_id)
VALUES ('2024-04-15', 1),
    ('2024-04-16', 2),
    ('2024-04-17', 3);


-- 	INSERTING VALUES FOR ORDER_DETAILS TABLE
INSERT INTO order_details (order_id, product_id, quantity)
VALUES (1, 1, 2),
    (2, 1, 1),
    (3, 2, 2);
    
    SELECT * 
    FROM order_details;
    
    

