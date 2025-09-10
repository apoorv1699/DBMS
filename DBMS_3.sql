# CREATE DATABASE

-- To create a new database in MySQL, you use the CREATE DATABASE statement. The following illustrates the basic syntax of the CREATE DATABASE statement:

CREATE DATABASE [IF NOT EXISTS] database_name ;

SHOW DATABASES;

-- execute the CREATE DATABASE statement to create the testdb database and press Enter:

CREATE DATABASE test;

SHOW CREATE DATABASE test;

USE test;

-- To quit the mysql program, type exit command:

exit


# DROP DATABASE

-- The DROP DATABASE statement drops all tables in the database and deletes the database permanently. 

DROP DATABASE [IF EXISTS] database_name;

-- The DROP DATABASE statement returns the number of tables it deleted.

SHOW DATABASES;

DROP DATABASE test;

-----------------------------------------

# Introduction to CREATE TABLE statement
# CREATE TABLE  -- The CREATE TABLE statement allows you to create a new table in a database.

CREATE TABLE [IF NOT EXISTS] table_name(
   column1 datatype constraints,
   column2 datatype constraints,
   ...
);


-- table_name: This is the name of the table that you want to create.
-- column1, column2, etc.: The names of the columns in the table.
-- datatype: the data of each column such as INT, VARCHAR, DATE, etc.
-- constraints: These are optional constraints such as NOT NULL, UNIQUE, PRIMARY KEY, and FOREIGN KEY.

# If you create a table with a name that already exists in the database, you’ll get an error. To avoid the error, you can use the IF NOT EXISTS option.

# Creates a table called "Persons" that contains five columns: PersonID, LastName, FirstName, Address, and City:

CREATE TABLE Persons (
    PersonID int,
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    City varchar(255)
);

# Create Table Using Another Table

CREATE TABLE TestTable AS
SELECT customername, contactname
FROM customers;

--------------------

# DROP TABLE Statement

--Be careful before dropping a table. Deleting a table will result in loss of complete information stored in the table!

DROP TABLE table_name;


## TRUNCATE TABLE

-- The TRUNCATE TABLE statement is used to delete the data inside a table, but not the table itself.

TRUNCATE TABLE table_name;

-- The MySQL TRUNCATE TABLE statement allows you to delete all data in a table.
-- Logically, the TRUNCATE TABLE statement is like a DELETE statement without a WHERE clause that deletes all rows from a table, or a sequence of DROP TABLE and CREATE TABLE statements.
-- However, the TRUNCATE TABLE statement is more efficient than the DELETE statement because it drops and recreates the table instead of deleting rows one by one.


# ALTER TABLE Statement

-- The ALTER TABLE statement is used to add, delete, or modify columns in an existing table.The ALTER TABLE statement is also used to add and drop various constraints on an existing table.

ALTER TABLE Persons 
ADD Email varchar(255);

---

ALTER TABLE Persons
DROP COLUMN Email;

---

ALTER TABLE Persons
MODIFY COLUMN FirstName Name;

---

ALTER TABLE Persons
DROP COLUMN FirstName;



CREATE TABLE tasks (
    id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    start_date DATE,
    due_date DATE
);

# The tasks table has four columns:

-- The id is an INT column and serves as the primary key column.
-- The title is a VARCHAR column and cannot be NULL.
-- The start_date and end_date are the DATE column and can be NULL.

SHOW TABLES;

