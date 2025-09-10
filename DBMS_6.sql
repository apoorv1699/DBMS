# INSERT statement

INSERT INTO table_name(column1, column2,...) 
VALUES (value1, value2,...);

-- To insert multiple rows into a table using a single INSERT statement, you use the following syntax:

INSERT INTO table(column1, column2,...) 
VALUES 
  (value1, value2,...), 
  (value1, value2,...), 
  ...
  (value1, value2,...);

-- Let’s create a new table called tasks for practicing the INSERT statement:

DROP TABLE IF EXISTS tasks;

CREATE TABLE tasks (
  task_id INT AUTO_INCREMENT PRIMARY KEY, 
  title VARCHAR(255) NOT NULL, 
  start_date DATE, 
  due_date DATE, 
  priority TINYINT NOT NULL DEFAULT 3, 
  description TEXT
);

INSERT INTO tasks(title, priority) 
VALUES('INSERT Statement', 1);

INSERT INTO tasks(title, priority) 
VALUES('Understanding DEFAULT keyword', DEFAULT);

# Inserting dates into the table example

-- To insert a literal date value into a column, you use the following format:

'YYYY-MM-DD'

-- YYYY represents a four-digit year e.g., 2018.
-- MM represents a two-digit month e.g., 01, 02, and 12.
-- DD represents a two-digit day e.g., 01, 02, 30.

INSERT INTO tasks(title, start_date, due_date) 
VALUES ('Insert date into table', '2018-01-09', '2018-09-15');

------------------------------------------------

INSERT INTO tasks(title, start_date, due_date) 
VALUES 
  (
    'Use current date for the task', 
    CURRENT_DATE(), 
    CURRENT_DATE()
  );
-- Inserting multiple rows example
INSERT INTO tasks(title, priority)
VALUES
	('My first task', 1),
	('It is the second task',2),
	('This is the third task of the week',3);

SELECT * FROM tasks;

SELECT LAST_INSERT_ID();

# INSERT INTO SELECT
-- you can use the result of a SELECT statement as the data source for the INSERT statement.
INSERT INTO table_name(column_list)
SELECT 
   select_list 
FROM 
   another_table
WHERE
   condition;

# First, create a new table called suppliers:

CREATE TABLE suppliers (
    supplierNumber INT AUTO_INCREMENT,
    supplierName VARCHAR(50) NOT NULL,
    phone VARCHAR(50),
    addressLine1 VARCHAR(50),
    addressLine2 VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postalCode VARCHAR(50),
    country VARCHAR(50),
    customerNumber INT,
    PRIMARY KEY (supplierNumber)
);

/*Suppose all customers in California, 
USA become the company’s suppliers. 
The following query finds all customers 
who are located in California, USA:*/

SELECT 
    customerNumber,
    customerName,
    phone,
    addressLine1,
    addressLine2,
    city,
    state,
    postalCode,
    country
FROM
    customers
WHERE
    country = 'USA' AND 
    state = 'CA';

------------------------------------------------------

INSERT INTO suppliers (
    supplierName, 
    phone, 
    addressLine1,
    addressLine2,
    city,
    state,
    postalCode,
    country,
    customerNumber
)
SELECT 
    customerName,
    phone,
    addressLine1,
    addressLine2,
    city,
    state ,
    postalCode,
    country,
    customerNumber
FROM 
    customers
WHERE 
    country = 'USA' AND 
    state = 'CA';

SELECT * FROM suppliers;

-----------------------------------

CREATE TABLE stats (
    totalProduct INT,
    totalCustomer INT,
    totalOrder INT
);

INSERT INTO stats(totalProduct, totalCustomer, totalOrder)
VALUES(
	(SELECT COUNT(*) FROM products),
	(SELECT COUNT(*) FROM customers),
	(SELECT COUNT(*) FROM orders)
);

SELECT * FROM stats;

-- DATETIME column

CREATE TABLE events(
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_name VARCHAR(255) NOT NULL,
    event_time DATETIME NOT NULL
);

INSERT INTO events(event_name, event_time)
VALUES('livestream', '2025-09-209 19:30:35');

SELECT * FROM events;

INSERT INTO events(event_name, event_time)
VALUES('livestream Workshop', NOW());

--If you want to insert a datetime 
-- string into a DATETIME column, 
-- you need to use the STR_TO_DATE() 
-- function to convert it to an expected format. 
-- For example:

INSERT INTO events (event_name, event_time)
VALUES (' Party', STR_TO_DATE('10/28/2023 20:00:00', '%m/%d/%Y %H:%i:%s'));


STR_TO_DATE(str,fmt);

-- str: This is the input string that you want to convert.
-- fmt: This is the format string that includes format specifiers. For example, %d for day, %m for month and %y for year.

SELECT STR_TO_DATE('21,5,2025','%d,%m,%Y');

SELECT STR_TO_DATE('21,5,2013 extra characters','%d,%m,%Y');

# UPDATE

SELECT 
    firstname, 
    lastname, 
    email
FROM
    employees
WHERE
    employeeNumber = 1056;
-----------------------------------------------------
UPDATE employees 
SET 
    email = 'mary.patterson@classicmodelcars.com'
WHERE
    employeeNumber = 1056;

------------------------------------------------------
UPDATE employees 
SET 
    lastname = 'Hill',
    email = 'mary.hill@classicmodelcars.com'
WHERE
    employeeNumber = 1056;

-----
# UPDATE to replace string example

UPDATE employees
SET email = REPLACE(email,'@classicmodelcars.com','@CDAC.com')
WHERE
   jobTitle = 'Sales Rep' AND
   officeCode = 6;

-- MySQL UPDATE to update rows returned by a SELECT statement example

SELECT 
    customername, 
    salesRepEmployeeNumber
FROM
    customers
WHERE
    salesRepEmployeeNumber IS NULL;

-- We can take a sale representative and update for those customers.
-- To do this, we can select a random employee whose job title is Sales Rep from the  employees table and update it for the  employees table.

SELECT 
    employeeNumber
FROM
    employees
WHERE
    jobtitle = 'Sales Rep'
ORDER BY RAND()
LIMIT 1;

--To update the sales representative employee number  column in the customers table,

UPDATE customers 
SET 
    salesRepEmployeeNumber = (SELECT 
            employeeNumber
        FROM
            employees
        WHERE
            jobtitle = 'Sales Rep'
        ORDER BY RAND()
        LIMIT 1)
WHERE
    salesRepEmployeeNumber IS NULL;

--------- 
SELECT 
     salesRepEmployeeNumber
FROM
    customers
WHERE
    salesRepEmployeeNumber IS NULL;

-- DELETE command

DELETE FROM table_name;

DELETE FROM student; -- all records

DELETE FROM student WHERE s_id=103;

-- ON DELETE CASCADE

/* Let’s take a look at an example of using MySQL ON DELETE CASCADE .

Suppose that we have two tables:buildings and rooms . In this database model, each building has one or many rooms. However, each room belongs to one only one building. A room would not exist without a building.

The relationship between the buildings and rooms tables is one-to-many (1:N) as illustrated in the following database diagram: 
*/
CREATE TABLE buildings (
    building_no INT PRIMARY KEY AUTO_INCREMENT,
    building_name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL
);

CREATE TABLE rooms (
    room_no INT PRIMARY KEY AUTO_INCREMENT,
    room_name VARCHAR(255) NOT NULL,
    building_no INT NOT NULL,
    FOREIGN KEY (building_no)
        REFERENCES buildings (building_no)
        ON DELETE CASCADE
);

INSERT INTO buildings(building_name,address)
VALUES('ACME Headquaters','3950 North 1st Street CA 95134'),
      ('ACME Sales','5000 North 1st Street CA 95134');

INSERT INTO rooms(room_name,building_no)
VALUES('Amazon',1),
      ('War Room',1),
      ('Office of CEO',1),
      ('Marketing',2),
      ('Showroom',2);

SELECT * FROM buildings;

SELECT * FROM rooms;

------
/* When you delete a row from the buildings table, you also want to delete all rows in the rooms  table that references to the row in the buildings table. For example, when you delete a row with building no. 2 in the buildings */

DELETE FROM buildings 
WHERE building_no = 2;

-----------------

SELECT * FROM rooms;