# CREATE INDEX

/*
An index in MySQL is a 
data structure (usually a B-tree) that speeds up retrieval of rows from a table.

    -- MySQL supports indexes on InnoDB and MyISAM storage engines.
    -- By default, PRIMARY KEY and UNIQUE constraints create indexes automatically.*/

-- you have a phone book that contains all the names and phone numbers of people in a city.

/*Let’s say you want to find Bob Cat’s phone number. 
Knowing that the names are alphabetically ordered, 
you first look for the page where the last name is Cat, 
then you look for Bob and his phone number.

If the names in the phone book were not sorted alphabetically, 
you would need to go through all the pages, 
reading every name on it until you find Bob Cat.
*/

-- This is called sequential searching. 
-- You go over all the entries until 
-- you find the person with the phone number that you are looking for.

CREATE INDEX index_name 
ON table_name (column_list)

-------------------------------

CREATE TABLE t(
   c1 INT PRIMARY KEY,
   c2 INT NOT NULL,
   c3 INT NOT NULL,
   c4 VARCHAR(10),
   INDEX (c2,c3) 
);

CREATE INDEX idx_c4 ON t(c4);

--------------------------------
-- By default, MySQL creates the B-Tree index if you don’t specify the index type.

# MySQL CREATE INDEX example

-- EXPLAIN SELECT 
SELECT 
    employeeNumber, 
    lastName, 
    firstName
FROM
    employees
WHERE
    jobTitle = 'Sales Rep';


-- We have 17 rows indicating that 17 employees whose job title is the Sales Rep.

-- To see how MySQL internally performed this query, you add the EXPLAIN clause at the beginning of the SELECT statement as follows:

-- As you can see, MySQL had to scan the whole table which consists of 23 rows to find the employees with the Sales Rep job title.

CREATE INDEX jobTitle 
ON employees(jobTitle);

-- Execute the EXPLAIN statement again:

EXPLAIN SELECT 
    employeeNumber, 
    lastName, 
    firstName
FROM
    employees
WHERE
    jobTitle = 'Sales Rep';

-- The output shows that MySQL just had to locate 17 rows from the  jobTitle index as indicated in the key column without scanning the whole table.

--To list all indexes of a table, 

SHOW INDEXES FROM employees;

# DROP INDEX statement

CREATE TABLE leads(
    lead_id INT AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    information_source VARCHAR(255),
    INDEX name(first_name,last_name),
    UNIQUE email(email),
    PRIMARY KEY(lead_id)
);

DROP INDEX name ON leads;


# DROP PRIMARY KEY index

CREATE TABLE t(
    pk INT PRIMARY KEY,
    c VARCHAR(10)
);

DROP INDEX `PRIMARY` ON t;

/*
Benefits of Indexes

Faster Query Performance
    Improves the speed of SELECT queries with WHERE, JOIN, ORDER BY, GROUP BY.
Efficient Searching
    Allows quick lookups instead of scanning the whole table.
Sorting Optimization
    Helps avoid costly sorting operations since data can be retrieved in index order.
Uniqueness Enforcement
    Unique indexes ensure no duplicate values (e.g., primary key, unique constraints).
Better JOIN Performance
    Speeds up table joins by indexing foreign keys.

Downside: More storage space is needed, and INSERT, UPDATE, DELETE operations become slightly slower because indexes must also be updated.
*/

/*
Types of Indexes

Primary Index
    Created automatically with the primary key. Ensures uniqueness.

CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);


Unique Index
    Ensures that all values in the indexed column are different.

CREATE UNIQUE INDEX idx_email ON table_name(email);

Composite Index 
    Index on multiple columns. Useful for queries filtering by multiple conditions.

CREATE INDEX idx_name_age ON table_name(name, age);

Full-Text Index
    Special index type for searching text (words/phrases) in large text fields.

CREATE FULLTEXT INDEX idx_content ON articles(content);

CREATE TABLE articles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200),
    body TEXT,
    FULLTEXT (title, body)   -- create FULLTEXT index
) ENGINE=InnoDB;


INSERT INTO articles (title, body) VALUES
('MySQL FullText Search', 'MySQL supports full-text search to find relevant words.'),
('Indexing in Databases', 'Indexes help speed up SELECT queries in SQL.'),
('Learning Python', 'Python is a great programming language for data science and AI.'),
('Database Optimization', 'Using indexes wisely can optimize database performance.');


*/

#  composite index example

CREATE INDEX name 
ON employees(lastName, firstName);

SELECT 
    firstName, 
    lastName, 
    email
FROM
    employees
WHERE
    lastName = 'Patterson';


EXPLAIN SELECT 
    firstName, 
    lastName, 
    email
FROM
    employees
WHERE
    lastName = 'Patterson';


-- clustered index

    -- Data is physically stored in the order of the index.
    -- Only one clustered index per table (usually on the primary key).

-- descending index

    -- A descending index is an index that stores key values in the descending order. 

CREATE TABLE t(
    a INT NOT NULL,
    b INT NOT NULL,
    INDEX a_asc_b_desc (a ASC, b DESC)
);


------------------------------------

## Temporary Tables in MySQL

-- A temporary table in MySQL is session-specific and automatically dropped when the session ends or connection closes.

CREATE TEMPORARY TABLE temp_sales (
    id INT,
    product_name VARCHAR(100),
    total_sales DECIMAL(10,2)
);


INSERT INTO temp_sales VALUES (1, 'Laptop', 1200.50);

SELECT * FROM temp_sales;

DROP TEMPORARY TABLE temp_sales;


/*
Scope: Only visible to the current session.

Name Reuse: You can have a temporary table with the same name as a permanent one (MySQL uses the temp version inside that session).

Performance: Useful for breaking down complex queries or caching intermediate results.

*/

----------------------------------


## ACID Properties in MySQL

ACID stands for:

    Atomicity
    Consistency
    Isolation
    Durability

These properties guarantee that database transactions are processed reliably, even in cases of crashes, errors, or multiple users accessing data at the same time.
MySQL’s InnoDB storage engine fully supports ACID.

