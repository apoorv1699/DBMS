# Introduction to DBMS

-- A Database Management System (DBMS) is software that helps users store, organize, manage, and retrieve data efficiently. 
-- Instead of keeping data in flat files or spreadsheets, a DBMS allows structured storage, ensuring consistency, security, and easy access. 
-- Some popular DBMS examples include MySQL, Oracle, SQL Server, PostgreSQL, and MongoDB.

Functions of a DBMS

-- Data Storage & Retrieval → Efficiently stores large volumes of data and retrieves it quickly.
-- Data Integrity → Ensures accuracy and consistency of data.
-- Security → Provides controlled access with authentication and authorization.
-- Concurrency Control → Allows multiple users to access data simultaneously without conflicts.
-- Backup & Recovery → Ensures data safety against crashes or failures.

# Basic Database Terminology

Here are some key terms you should know:
-- Database → A structured collection of related data.
-- Example: A university database may contain student, faculty, and course information.

DBMS → The software that manages the database.

Data → Raw facts and figures that can be processed into meaningful information.

Information → Processed data that is meaningful and useful for decision-making.

Table (Relation) → A structure within a database that organizes data into rows (tuples) and columns (attributes).

Record (Tuple/Row) → A single entry in a table, representing one entity instance.
-- Example: A single student's details.

Field (Attribute/Column) → A specific property or characteristic of an entity.
Example: "Name," "Roll Number," or "Date of Birth."

Primary Key → A unique identifier for each record in a table (e.g., Student_ID).

Foreign Key → A field in one table that refers to the primary key in another table, establishing relationships.

Schema → The overall logical design or blueprint of the database (tables, relationships, constraints).

Query → A request to retrieve or manipulate data from the database (usually written in SQL).

Normalization → The process of organizing data to reduce redundancy and improve efficiency.

Transaction → A sequence of operations performed as a single logical unit of work (follows the ACID properties – Atomicity, Consistency, Isolation, Durability).

--------------------------------------
# Relational DBMS (RDBMS)

Definition: Stores data in structured tables with rows and columns. Relationships among tables are maintained using keys (primary and foreign).
-- Stores data in the form of tables (relations) consisting of rows (tuples) and columns (attributes).
    
    Examples: MySQL, PostgreSQL, Microsoft SQL Server, Oracle Database.

Features:

    Data is structured into relations (tables).
    Uses SQL (Structured Query Language) for querying and manipulation.
    Supports ACID properties for reliable transactions.
    Strong consistency and integrity constraints.

-- Use Case: Banking systems, ERP, CRM — where data is structured and relationships are important.

--------------------------------

2. Object-Relational DBMS (ORDBMS)

Definition: Extends the traditional relational model by adding object-oriented features such as support for complex data types, inheritance, and user-defined types.

Key Features:

    Supports tables like RDBMS but allows objects, classes, and inheritance.
    Can handle multimedia, spatial, and complex data.
    Provides extensibility with user-defined functions and data types.

Examples: PostgreSQL (supports object-relational features), Oracle (with object extensions), Informix.

Use Case: Applications that need to handle both structured data and complex objects, e.g., scientific databases, multimedia systems, GIS.

-----------------------------------------------

3. NoSQL Databases (Not Only SQL)

Definition: Designed for unstructured, semi-structured, or large-scale distributed data. Provides flexibility beyond the rigid schema of relational models.

Key Features:

    Schema-less or flexible schema.
    High scalability (horizontal scaling with clusters).
    Often sacrifice strict ACID properties for BASE (Basically Available, Soft state, Eventual consistency).

Types of NoSQL databases:

        Document Stores → Store data in JSON/XML documents (e.g., MongoDB, CouchDB).
        Key-Value Stores → Simple key-value pairs (e.g., Redis, DynamoDB).
        Column Stores → Store data in columns instead of rows (e.g., Cassandra, HBase).
        Graph Databases → Store data as nodes and edges for relationships (e.g., Neo4j).

Examples: MongoDB, Cassandra, Redis, Neo4j.

Use Case: Big Data, social networks, IoT, real-time analytics, content management.

--------------------------
SQL : Introduction
--------------------------

Structured Query Language -- High level language that helps talk to the database

Categories of commands in SQL
---------------------
a) DDL (Data Definition Language) [changes made would be permanent]
CREATE, DROP, ALTER, RENAME,TRUNCATE

b) DML (Data Manipulation Language)[changes made would be Temporary]
INSERT,UPDATE,DELETE

c) TCL ( Transaction Control Language) [Always works on DML's]
COMMIT ROLLBACK SAVEPOINT

d) DCL ( Data Control Language) [useful across users when you need to give/takeback permissions	]
GRANT REVOKE 

e) DQL ( Data Query Language)
SELECT

----------------------------------------
what is schema and schema objects ?
schema -- logical container where all the schema objects will reside 
   ex: gaurav[username]/gaurav[password]  
       cdac[username]/pass[password] 
	   
  schema objects -- objects in the schema 
   ex: table , view , procedure, function 


-----------------------------------------





#Introduction to the MySQL ORDER BY clause
--When you use the SELECT statement to query data from a table, the order of rows in the result set is unspecified.
--To sort the rows in the result set, you add the ORDER BY clause to the SELECT statement.
SELECT 
   select_list
FROM 
   table_name
ORDER BY 
   column1 [ASC|DESC], 
   column2 [ASC|DESC],
   ...;

--The ASC stands for ascending and the DESC stands for descending.
# 1 Using ORDER BY clause to sort the result set by one column example
SELECT 
  contactLastname, 
  contactFirstname 
FROM 
  customers 
ORDER BY 
  contactLastname;

--sort customers by the last name in descending order

SELECT 
  contactLastname, 
  contactFirstname 
FROM 
  customers 
ORDER BY 
  contactLastname DESC;

# Using the ORDER BY clause to sort the result set by multiple columns example

SELECT 
  contactLastname, 
  contactFirstname 
FROM 
  customers 
ORDER BY 
  contactLastname DESC, 
  contactFirstname ASC;

--in this example, the ORDER BY  clause sorts the result set by the last name in descending order first and then sorts the sorted result set by the first name in ascending order to make the final result set.

# Using the ORDER BY clause to sort a result set by an expression example
--the following orderdetails table 

SELECT 
  orderNumber, 
  orderlinenumber, 
  quantityOrdered * priceEach 
  -- quantityOrdered * priceEach AS subtotal 
FROM 
  orderdetails 
ORDER BY 
  quantityOrdered * priceEach DESC;
  -- subtotal DESC;

# MySQL WHERE clause
-- Using the WHERE clause with equality operator example
SELECT 
    lastname, 
    firstname, 
    jobtitle
FROM
    employees
WHERE
    jobtitle = 'Sales Rep';
    -- officecode > 5;
    -- officecode <= 4;
    -- jobtitle <> 'Sales Rep';
--The following query uses the not equal to (<>) operator to find all employees who are not the Sales Rep:

-- Using the WHERE clause with the AND operator

SELECT 
    lastname, 
    firstname, 
    jobtitle,
    officeCode
FROM
    employees
WHERE
    jobtitle = 'Sales Rep' AND 
    officeCode = 1;

-- Using MySQL WHERE clause with OR operator

SELECT 
    lastName, 
    firstName, 
    jobTitle, 
    officeCode
FROM
    employees
WHERE
    jobtitle = 'Sales Rep' OR 
    officeCode = 1
ORDER BY 
    officeCode , 
    jobTitle;

-- Using the WHERE clause with the BETWEEN operator example
-- The BETWEEN operator returns TRUE if a value is in a range of values:

SELECT 
    firstName, 
    lastName, 
    officeCode
FROM
    employees
WHERE
    officeCode BETWEEN 1 AND 3
ORDER BY officeCode;

-- Using the WHERE clause with the IN operator example

SELECT 
    firstName, 
    lastName, 
    officeCode
FROM
    employees
WHERE
    officeCode IN (1 , 2, 3)
ORDER BY 
    officeCode;

# MySQL DISTINCT clause
-- When querying data from a table, you may get duplicate rows. To remove these duplicate rows, 
-- you use the DISTINCT clause in the SELECT statement.
SELECT 
    --lastname
    DISTINCT lastname
FROM
    employees
ORDER BY 
    lastname;

# distinct with Null values
-- When you specify a column that has NULL values in the DISTINCT clause, the DISTINCT clause will keep only one NULL value because it considers all NULL values are the same.

SELECT 
    DISTINCT state
FROM 
    customers;

# DISTINCT with multiple columns

--SELECT DISTINCT
SELECT DISTINCT
    state, city
FROM
    customers
WHERE
    state IS NOT NULL
ORDER BY 
    state, 
    city;


# MySQL AND & OR operator

A AND B
-- A and B are called operands. They can be literal values or expressions.

-- The logical AND operator returns 1 if both A and B are non-zero and not NULL. It returns 0 if either operand is zero; otherwise, it returns NULL.

-- The logical AND operator returns 1 if both A and B are non-zero and NOT NULL. For example:

SELECT 1 AND 1;

-- The logical AND operator returns 0 if A or B is zero or both A and B are zero:

SELECT 1 AND 0, 0 AND 1, 0 AND 0, 0 AND NULL;

-- The logical AND operator returns NULL if either operand is non-zero or both operands are NULL.

SELECT 1 AND NULL, NULL AND NULL;

SELECT 1 = 0 AND 1 / 0 ;

-- The following statement uses the AND operator to find customers who are located in California (CA), USA:

SELECT 
    customername, 
    country, 
    state
FROM
    customers
WHERE
    country = 'USA' AND 
    state = 'CA';

-- By using the AND operator, you can combine more than two Boolean expressions. For example, the following query returns the customers who are located in California, USA, and have a credit limit greater than 100K.

WHERE
    country = 'USA' AND 
    state = 'CA' AND 
    creditlimit > 100000;

# OR operator

-- The MySQL OR operator is a logical operator that combines two Boolean expressions.

A OR B

-- If both A and B are not NULL, the OR operator returns 1 (true) if either A or B is non-zero. For example:

SELECT 1 OR 1, 1 OR 0, 0 OR 1;  

SELECT 0 OR 0;

-- When A and / or B is NULL, the OR operator returns 1 (true) if either A or B is non-zero. Otherwise, it returns NULL. For example:

SELECT 1 OR NULL, 0 OR NULL, NULL or NULL;

-- the OR operator is also short-circuited. In other words, MySQL stops evaluating the remaining parts of the expression as soon as it can determine the result. For example:

SELECT 1 = 1 OR 1 / 0;

-- Because the expression 1 = 1 always returns 1, MySQL won’t evaluate the 1 / 0 expression. And MySQL would issue an error if it did.

# Operator precedence

SELECT 1 OR 0 AND 0;

-- output 1
-- Since the AND operator has higher precedence than the OR operator, MySQL evaluates the AND operator before the OR operator.

SELECT (1 OR 0) AND 0;

--output 0

--Select the customers who locate in the USA or France and have a credit limit greater than 100,000.
SELECT   
	customername, 
	country, 
	creditLimit
FROM   
	customers
WHERE(country = 'USA'
		OR country = 'France')
	  AND creditlimit > 100000;

-- the query will return the customers who locate in the USA or the customers located in France with a credit limit greater than 100,000.

SELECT    
    customername, 
    country, 
    creditLimit
FROM    
    customers
WHERE 
    country = 'USA'
    OR country = 'France'
    AND creditlimit > 100000;

# IN operator

SELECT 1 IN (1,2,3);
SELECT 4 IN (1,2,3);
SELECT NULL IN (1,2,3);
-- The following example also returns NULL because the 0 is not equal to any value in the list and the list has one NULL:
SELECT 0 IN (1 , 2, 3, NULL);  -- output NULL
SELECT NULL IN (1 , 2, 3, NULL);   -- output NULL

SELECT 
    officeCode, 
    city, 
    phone, 
    country
FROM
    offices
WHERE
    country IN ('USA' , 'France');
    -- country = 'USA' OR country = 'France';

-- same result witout in

# NOT IN operator

SELECT 1 NOT IN (1,2,3);
SELECT 0 NOT IN (1,2,3);

--to find the offices that are not located in France and the USA:

SELECT 
    officeCode, 
    city, 
    phone
FROM
    offices
WHERE
    country NOT IN ('USA' , 'France')
ORDER BY 
    city;


# LIKE operator

--The percentage ( % ) wildcard matches any string of zero or more characters.
--The underscore ( _ ) wildcard matches any single character.

SELECT 
    employeeNumber, 
    lastName, 
    firstName
FROM
    employees
WHERE
    firstName LIKE 'a%';
    -- lastName LIKE '%on';
    -- lastname LIKE '%on%';
--To find employees whose first names start with the letter T , end with the letter m

    -- firstname LIKE 'T_m';
    -- lastName NOT LIKE 'B%';

# MySQL LIMIT clause

--  The LIMIT clause is used in the SELECT statement to constrain the number of rows to return. The LIMIT clause accepts one or two arguments.

-- 1) Using MySQL LIMIT to get the highest or lowest rows

SELECT 
    customerNumber, 
    customerName, 
    creditLimit
FROM
    customers
ORDER BY creditLimit DESC
LIMIT 5;


# CONCAT_WS() Function & aliases

-- CONCAT_WS stands for Concatenate With Separator. The CONCAT_WS function concatenates multiple strings into a single string separated by a specified separator.

SELECT CONCAT_WS(',', 'John', 'Doe') full_name;

--------

SELECT CONCAT_WS(' ', firstName, lastName) full_name
FROM employees
ORDER BY lastName;

----------

SELECT 
  customerName, 
  CONCAT_WS(',', city, state) address 
FROM 
  customers 
ORDER BY 
  customerName;


