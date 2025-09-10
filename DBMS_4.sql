## MySQL Constraints

# primary key

-- A primary key is a column or a set of columns that uniquely identifies each row in the table. 
-- A primary key column must contain unique values.

-- If the primary key consists of multiple columns, 
-- the combination of values in these columns must be unique. Additionally, 
-- a primary key column cannot contain NULL.

-- A table can have either zero or one primary key, but not more than one.


# single-column primary key

CREATE TABLE table_name(
   column1 datatype PRIMARY KEY,
   column2 datatype, 
   ...
);

-- you define the PRIMARY KEY constraint as a column constraint.

# multi-column primary key

-- If the primary key consists of two or more columns, you need to use a table constraint to define the primary key:

CREATE TABLE table_name(
   column1 datatype,
   column2 datatype,
   column3 datatype,
   ...,
   PRIMARY KEY(column1, column2)
);

----------------------------------

CREATE TABLE products(
   id INT PRIMARY KEY,
   name VARCHAR(255) NOT NULL
);

--  insert data into the products table

INSERT INTO products (id, name) 
VALUES (1, 'Laptop'), (2, 'Smartphone'),(3, 'Wireless Headphones');

-- If you attempt to insert a duplicate value into the primary key column, you’ll get an error. For example:

INSERT INTO products (id, name) 
VALUES (1, 'Bluetooth Speaker');

-- Output through error

CREATE TABLE products(
   id INT ,
   name VARCHAR(255) NOT NULL
   PRIMARY KEY (id)
);

# single-column primary key with AUTO_INCREMENT attribute example

DROP TABLE products; 

CREATE TABLE products(
   id INT AUTO_INCREMENT PRIMARY KEY,
   name VARCHAR(255) NOT NULL
);

-- you can insert new rows into the products table without having to provide the values for the primary key column

INSERT INTO products (name) 
VALUES  ('Laptop'), ('Smartphone'), ('Wireless Headphones');

-- automatically generates sequential integer values for the id column when a new row is inserted.

# multi-column primary key example

CREATE TABLE customers(
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

# composite primary key

CREATE TABLE student_courses (
    student_id INT,
    course_id INT,
    grade CHAR(2),
    PRIMARY KEY (student_id, course_id)
);

## trying to define two primary keys

CREATE TABLE test_table (
    id INT,
    email VARCHAR(100),
    PRIMARY KEY (id),
    PRIMARY KEY (email)  -- ❌ Error: multiple primary keys defined
);

## Adding a primary key to a table example

CREATE TABLE tags(
    id INT,
    name VARCHAR(25) NOT NULL
);

ALTER TABLE tags
ADD PRIMARY KEY(id);

# Removing the primary key from a table

ALTER TABLE tags
DROP PRIMARY KEY;

## FOREIGN KEY Constraint

-- A foreign key in MySQL is a column (or group of columns) 
-- in one table that refers to the PRIMARY KEY (or a UNIQUE key) in another table.
-- It creates a relationship between the two tables.
-- Purpose: enforce referential integrity (ensures data in the foreign key column must exist in the referenced table).

-- A table can have more than one foreign key where each foreign key references a primary key of the different parent tables.

CREATE TABLE child_table (
    column_name datatype,
    ...,
    FOREIGN KEY (column_name) REFERENCES parent_table(parent_column)
        ON DELETE action
        ON UPDATE action
);

-- ON DELETE and ON UPDATE define what happens if the parent row is deleted or updated.

Common actions:

-- CASCADE → automatically update/delete child rows.
-- SET NULL → sets child column to NULL.
-- RESTRICT or NO ACTION → prevent deletion/update if child rows exist.

CREATE DATABASE fk;

USE fk;

-- create two tables categories and products:

CREATE TABLE categories(
  categoryId INT AUTO_INCREMENT PRIMARY KEY, 
  categoryName VARCHAR(100) NOT NULL
) ;

-----

CREATE TABLE products(
  productId INT AUTO_INCREMENT PRIMARY KEY, 
  productName VARCHAR(100) NOT NULL, 
  categoryId INT, 
  CONSTRAINT fk_category FOREIGN KEY (categoryId) 
                         REFERENCES categories(categoryId)
);


-- The categoryId in the products table is the foreign key 
-- column that refers to the categoryId column in the  categories table.

-- Because we don’t specify any ON UPDATE and ON DELETE clauses, 
-- the default action is RESTRICT for both update and delete operations.

-- The following steps illustrate the RESTRICT action.

-- Insert two rows into the categories table:

INSERT INTO categories(categoryName)
VALUES ('Smartphone'), ('Smartwatch');


SELECT * FROM categories;

-- Insert a new row into the products table:

INSERT INTO products(productName, categoryId)
VALUES('iPhone',1);

-- Attempt to insert a new row into the products table with a 
-- categoryId  value does not exist in the categories table:

INSERT INTO products(productName, categoryId)
VALUES('iPad',3);

-- through error Cannot add or update a child row:

-- Update the value in the categoryId column in the categories table to 100:

UPDATE categories
SET categoryId = 100
WHERE categoryId = 1;

-- through error cannot delete or update a parent row:

-- Because of the RESTRICT option, you cannot delete or update categoryId 1 since it is referenced by the productId 1 in the products table.

## CASCADE action

-- These steps illustrate how ON UPDATE CASCADE and ON DELETE CASCADE actions work.

DROP TABLE products;

CREATE TABLE products(
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productName varchar(100) not null,
    categoryId INT NOT NULL,
    CONSTRAINT fk_category
    FOREIGN KEY (categoryId) 
    REFERENCES categories(categoryId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ;

--Insert four rows into the products table:

INSERT INTO products(productName, categoryId)
VALUES
    ('iPhone', 1), 
    ('Galaxy Note',1),
    ('Apple Watch',2),
    ('Samsung Galary Watch',2);

SELECT * FROM products;

-- Update categoryId 1 to 100 in the categories table:

UPDATE categories
SET categoryId = 100
WHERE categoryId = 1;

SELECT * FROM categories;

SELECT * FROM products;

-- As you can see, two rows with value 1 in the categoryId column of the 
-- products table was automatically updated to 100 because of the 
-- ON UPDATE CASCADE action.

-- Delete categoryId 2 from the categories table:

DELETE FROM categories
WHERE categoryId = 2;

SELECT * FROM categories;

SELECT * FROM products;

-- All products with categoryId 2 from the products table was automatically deleted because of the ON DELETE CASCADE action.


## SET NULL action

-- These steps illustrate how the ON UPDATE SET NULL and ON DELETE SET NULL actions work.

DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS products;

CREATE TABLE categories(
    categoryId INT AUTO_INCREMENT PRIMARY KEY,
    categoryName VARCHAR(100) NOT NULL
);

CREATE TABLE products(
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productName varchar(100) not null,
    categoryId INT,
    CONSTRAINT fk_category
    FOREIGN KEY (categoryId) 
        REFERENCES categories(categoryId)
        ON UPDATE SET NULL
        ON DELETE SET NULL 
);

-- The foreign key in the products table changed to ON UPDATE SET NULL and ON DELETE SET NULL options.

INSERT INTO categories(categoryName)
VALUES
    ('Smartphone'),
    ('Smartwatch');


INSERT INTO products(productName, categoryId)
VALUES
    ('iPhone', 1), 
    ('Galaxy Note',1),
    ('Apple Watch',2),
    ('Samsung Galary Watch',2);

-- Update categoryId from 1 to 100 in the categories table:

UPDATE categories
SET categoryId = 100
WHERE categoryId = 1;

SELECT * FROM categories;

SELECT * FROM products;

-- The rows with the categoryId 1 in the products table was automatically set to NULL due to the ON UPDATE SET NULL action.

-- Delete the categoryId 2 from the categories table:

DELETE FROM categories 
WHERE categoryId = 2;

SELECT * FROM products;

-- The values in the categoryId column of the rows with categoryId 2 in the products table was automatically set to NULL due to the ON DELETE SET NULL action.


## When to use CASCADE

You use ON DELETE CASCADE or ON UPDATE CASCADE when:
-- The child rows have no meaning without the parent row.
-- You want deletions/updates to automatically propagate to related tables.

Examples:

Order Management System
    -- orders (parent) and order_items (child).
    -- If an order is deleted → all order items should also be deleted.
Student → Enrollments
    --If a student is deleted from the system, their enrollments should also disappear.
Blog → Comments
    -- If a blog post is deleted, all its comments should also be deleted.

## When NOT to use CASCADE

You avoid CASCADE when:
    -- Child rows may need to exist independently of the parent row.
    -- You want to prevent accidental data loss if a parent row is deleted.
Departments → Employees
    -- If a department is deleted, you probably don’t want all employees to be deleted too (you might just want to reassign them).
    -- Better: ON DELETE SET NULL (employees keep their record, but dept_id becomes NULL).
Customers → Orders
    -- If a customer is deleted, you don’t want to lose all their order history.
    -- Better: ON DELETE RESTRICT or NO ACTION.


# Rules of Thumb
    -- Use CASCADE when child rows are strictly dependent on parent rows.
    -- Avoid CASCADE when child rows carry independent business meaning or when deletion could cause unintended data loss.
    -- SET NULL is useful if child records should survive but no longer reference a deleted parent.
    -- RESTRICT / NO ACTION is good when you want to protect parent rows from deletion until child rows are manually resolved.

# CASCADE = If I delete the parent, also delete all the children automatically.
# RESTRICT = You can’t delete the parent if children still exist.
# SET NULL = Delete the parent, but leave children alive (without a parent).


# Drop MySQL foreign key constraints

ALTER TABLE table_name 
DROP FOREIGN KEY constraint_name;

SHOW CREATE TABLE products;

ALTER TABLE products 
DROP FOREIGN KEY fk_category;

SHOW CREATE TABLE products;


## Disable Foreign Key Checks

-- Sometimes, it is very useful to disable foreign key checks. For example, you can load data to the parent and child tables in any order with the foreign key constraint check disabled.

-- If you don’t disable foreign key checks, you have to load data into the parent tables first and then the child tables in sequence, which can be tedious.

--To disable foreign key checks, you set the foreign_key_checks variable to zero as follows:

SET foreign_key_checks = 0;

-- To enable the foreign key constraint check, you set the value of the foreign_key_checks to 1:

SET foreign_key_checks = 1;

CREATE TABLE countries(
    country_id INT AUTO_INCREMENT,
    country_name VARCHAR(255) NOT NULL,
    PRIMARY KEY(country_id)
);

CREATE TABLE cities(
    city_id INT AUTO_INCREMENT,
    city_name VARCHAR(255) NOT NULL,
    country_id INT NOT NULL,
    PRIMARY KEY(city_id),
    FOREIGN KEY(country_id) 
		REFERENCES countries(country_id)
);

INSERT INTO cities(city_name, country_id)
VALUES('New York',1);

-- error

SET foreign_key_checks = 0;

INSERT INTO cities(city_name, country_id)
VALUES('New York',1);

SELECT * FROM cities;

SET foreign_key_checks = 1;

-- When the foreign key checks were re-enabled, MySQL did not re-validate data in the table. However, it won’t allow you to insert or update data that violates the foreign key constraint.

-- Finally, insert a row into the countries table whose value in the column country_id is 1 to make the data consistent in both tables:

INSERT INTO countries(country_id, country_name)
VALUES(1,'USA');


## UNIQUE Constraint

-- you want to ensure values in a column or a group of columns are unique. For example, 
-- email addresses of users in the users table, or phone numbers of
-- customers in the customers table should be unique. To enforce this rule, you use a UNIQUE constraint.

-- A UNIQUE constraint is an integrity constraint that ensures 
-- the uniqueness of values in a column or group of columns. A UNIQUE constraint can be either a 
-- column constraint or a table constraint.

CREATE TABLE table_name(
    ...,
    column1 datatype UNIQUE,
    ...
);

CREATE TABLE table_name(
   ...
   column1 datatype,
   column2 datatype,
   ...,
   UNIQUE(column1, column2)
);

--creates a new table named suppliers with the two UNIQUE constraints:

CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(15) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL,
    PRIMARY KEY (supplier_id),
    CONSTRAINT uc_name_address UNIQUE (name,address)
);

INSERT INTO suppliers(name, phone, address) 
VALUES( 'ABC Inc', 
       '(408)-908-2476',
       '4000 North 1st Street');

INSERT INTO suppliers(name, phone, address) 
VALUES( 'XYZ Corporation','(408)-908-2476','3000 North 1st Street');

-- error
-- change the phone number to a different one and execute the insert statement again.

INSERT INTO suppliers(name, phone, address) 
VALUES( 'XYZ Corporation','(408)-908-3333','3000 North 1st Street');

INSERT INTO suppliers(name, phone, address) 
VALUES( 'ABC Inc','(408)-908-1111', '4000 North 1st Street');


# UNIQUE constraint & NULL
-- NULL values are treated as distinct when it comes to unique constraints. Therefore, if you have a column that accepts NULL values, you can insert multiple values into the column.

CREATE TABLE contacts(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) UNIQUE
);

INSERT INTO contacts(name, phone)
VALUES
   ('Alice','(408)-102-2456'),
   ('John', NULL),
   ('Jane', NULL);   

SELECT * FROM contacts;

ALTER TABLE table_name
DROP INDEX index_name;

ALTER TABLE table_name
ADD CONSTRAINT constraint_name 
UNIQUE (column_list);