CREATE VIEW

CREATE [OR REPLACE] VIEW [db_name.]view_name [(column_list)]
AS
  select-statement;

----------------------------------------------
SELECT 
    customerName, 
    checkNumber, 
    paymentDate, 
    amount
FROM
    customers
INNER JOIN
    payments USING (customerNumber);

-- Next time, if you want to get the same information including customer name, check number, payment date, and amount, you need to issue the same query again.
-- One way to do this is to save the query in a file, either .txt or .sql file so that later you can open and execute it from MySQL Workbench or any other MySQL client tools.
-- A better way to do this is to save the query in the database server and assign a name to it. This named query is called a database view, or simply, view.

CREATE VIEW customerPayments
AS 
SELECT 
    customerName, 
    checkNumber, 
    paymentDate, 
    amount
FROM
    customers
INNER JOIN
    payments USING (customerNumber);


SELECT * FROM customerPayments;


CREATE VIEW daysofweek (day) AS
    SELECT 'Mon' 
    UNION 
    SELECT 'Tue'
    UNION 
    SELECT 'Web'
    UNION 
    SELECT 'Thu'
    UNION 
    SELECT 'Fri'
    UNION 
    SELECT 'Sat'
    UNION 
    SELECT 'Sun';

SELECT * FROM daysofweek;

# Advantages of MySQL Views

-- 1) Simplify complex query
-- 2) Make the business logic consistent
-- 3) Add extra security layers
-- 4) Enable backward compatibility
        /*Suppose, you want to normalize a big table into many smaller ones. And you don’t want to impact the current applications that reference the table.
        In this case, you can create a view whose name is the same as the table based on the new tables so that all applications can reference the view as if it were a table.*/


# simple view example

CREATE VIEW salePerOrder AS
    SELECT 
        orderNumber, 
        SUM(quantityOrdered * priceEach) total
    FROM
        orderDetails
    GROUP by orderNumber
    ORDER BY total DESC;

-- If you use the SHOW TABLE command to view all tables in the classicmodels database, you will see the viewsalesPerOrder is showing up in the list.


SHOW TABLES;
SHOW FULL TABLES;

SELECT * FROM salePerOrder;

# view based on another view example

CREATE VIEW bigSalesOrder AS
    SELECT 
        orderNumber, 
        ROUND(total,2) as total
    FROM
        salePerOrder
    WHERE
        total > 60000;

SELECT 
    orderNumber, 
    total
FROM
    bigSalesOrder;

## Creating a view with join example

CREATE OR REPLACE VIEW customerOrders AS
SELECT 
    orderNumber,
    customerName,
    SUM(quantityOrdered * priceEach) total
FROM
    orderDetails
INNER JOIN orders o USING (orderNumber)
INNER JOIN customers USING (customerNumber)
GROUP BY orderNumber;


SELECT * FROM customerOrders 
ORDER BY total DESC;

## Creating a view with a subquery example

CREATE VIEW aboveAvgProducts AS
    SELECT 
        productCode, 
        productName, 
        buyPrice
    FROM
        products
    WHERE
        buyPrice > (
            SELECT 
                AVG(buyPrice)
            FROM
                products)
    ORDER BY buyPrice DESC;

SELECT * FROM aboveAvgProducts;

# updatable view example

-- First, create a view named officeInfo  based on the offices  table

CREATE VIEW officeInfo
 AS 
   SELECT officeCode, phone, city
   FROM offices;

SELECT * FROM officeInfo;

-- Update 

UPDATE officeInfo 
SET 
    phone = '+33 14 723 5555'
WHERE
    officeCode = 4;

------------------------------------------

SELECT 
    *
FROM
    officeInfo
WHERE
    officeCode = 4;

-- Removing rows through the view

-- create a new table named items
CREATE TABLE items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(11 , 2 ) NOT NULL
);

-- insert data into the items table
INSERT INTO items(name,price) 
VALUES('Laptop',700.56),('Desktop',699.99),('iPad',700.50) ;

-- create a view based on items table
CREATE VIEW LuxuryItems AS
    SELECT 
        *
    FROM
        items
    WHERE
        price > 700;
-- query data from the LuxuryItems view
SELECT 
    *
FROM
    LuxuryItems;

-----------------------------

DELETE FROM LuxuryItems 
WHERE id = 3;

-----------------------------------------
SELECT 
    *
FROM
    LuxuryItems;

----------------------------------

SELECT 
    *
FROM
    items;

-- info about view

SHOW CREATE VIEW LuxuryItems;
-- DROP VIEW IF EXISTS LuxuryItems;
DROP VIEW LuxuryItems;

-- Rename View

RENAME TABLE original_view_name 
TO new_view_name;

RENAME TABLE LuxuryItems 
TO LuxuryItems2;
--  check if the view has been renamed successfully:
SHOW FULL TABLES WHERE table_type = 'VIEW';


# Show View 

-- MySQL treats the views as tables with the type 'VIEW'. Therefore, you can use the SHOW FULL TABLES statement to display all views in the current database

SHOW FULL TABLES 
WHERE table_type = 'VIEW';

-- If you want to show all views in a specific database,

SHOW FULL TABLES
[{FROM | IN } database_name]
WHERE table_type = 'VIEW';


SHOW FULL TABLES IN classicmodels 
WHERE table_type='VIEW';

-- Show View –  Using INFORMATION_SCHEMA database
/*The information_schema database provides access to MySQL database metadata such as databases, tables, data types of columns, or privileges. 
The information schema is also known as a database dictionary or system catalog*/

SELECT * 
FROM information_schema.tables;



# WITH CHECK OPTION clause

/*Sometimes, you create a view to reveal the partial data of a table. However, a simple view is updatable, 
and therefore, it is possible to update data that is not visible through the view.
This update makes the view inconsistent.*/

-- To ensure the consistency of the view, you use the WITH CHECK OPTION clause

/*The WITH CHECK OPTION is an optional clause of the CREATE VIEW statement. 
This WITH CHECK OPTION prevents you from updating or 
inserting rows that are not visible through the view.*/

CREATE OR REPLACE VIEW view_name 
AS
  select_statement
WITH CHECK OPTION;

CREATE DATABASE mydb;

USE mydb;

CREATE TABLE employees(
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    name VARCHAR(255) NOT NULL
);

INSERT INTO employees (type, name) 
VALUES
('Full-time', 'John Doe'),
('Contractor', 'Jane Smith'),
('Temp', 'Alice Johnson'),
('Full-time', 'Bob Anderson'),
('Contractor', 'Charlie Brown'),
('Temp', 'David Lee'),
('Full-time', 'Eva Martinez'),
('Contractor', 'Frank White'),
('Temp', 'Grace Taylor'),
('Full-time', 'Henry Walker'),
('Contractor', 'Ivy Davis'),
('Temp', 'Jack Turner'),
('Full-time', 'Kelly Harris'),
('Contractor', 'Leo Wilson'),
('Temp', 'Mia Rodriguez'),
('Full-time', 'Nick Carter'),
('Contractor', 'Olivia Clark'),
('Temp', 'Pauline Hall'),
('Full-time', 'Quincy Adams');

SELECT * FROM employees;

------------------------------------
CREATE OR REPLACE VIEW contractors 
AS 
SELECT id, type, name 
FROM 
  employees 
WHERE 
  type = 'Contractor';

-------------------------------------

SELECT * FROM contractors;

INSERT INTO contractors(name, type)
VALUES('Andy Black', 'Contractor');
-- Andy Black has been added successfully.
-- The problem is that you can add an employee 
-- with other types such as Full-time into the employees table via the contractors view. 
-- For example:

INSERT INTO contractors(name, type)
VALUES('Deric Seetoh', 'Full-time');
--

-- To prevent this, you need to add the WITH CHECK OPTION clause to the CREATE OR REPLACE VIEW statement like this:

CREATE OR REPLACE VIEW contractors 
AS 
SELECT id, type, name 
FROM 
  employees 
WHERE 
  type = 'Contractor'
WITH CHECK OPTION;


INSERT INTO contractors(name, type)
VALUES('Brad Knox', 'Full-time');

--------------------------------------