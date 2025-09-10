# Join clauses

-- A JOIN in SQL is used to combine rows from two or more tables based on a related column 
-- (usually a primary key in one table and a foreign key in another).

/* A relational database consists of multiple related tables linking together using common columns, 
which are known as foreign key columns. Because of this, 
the data in each table is incomplete from the business perspective.*/

-- we have the orders and orderdetails tables that are linked using the orderNumber column:

-- To get complete order information, you need to query data from both orders and  orderdetails tables.

-- That’s why joins come into the play.

MySQL supports the following types of joins:

    Inner join
    Left join
    Right join
    Cross join

-- MySQL hasn’t supported the FULL OUTER JOIN yet.

CREATE TABLE members (
    member_id INT AUTO_INCREMENT,
    name VARCHAR(100),
    PRIMARY KEY (member_id)
);

CREATE TABLE committees (
    committee_id INT AUTO_INCREMENT,
    name VARCHAR(100),
    PRIMARY KEY (committee_id)
);

INSERT INTO members(name)
VALUES('John'),('Jane'),('Mary'),('David'),('Amelia');

INSERT INTO committees(name)
VALUES('John'),('Mary'),('Amelia'),('Joe');

SELECT * FROM members;

SELECT * FROM committees;
 
-------------------------
# INNER JOIN clause

SELECT column_list
FROM table_1
INNER JOIN table_2 ON join_condition;

-- Inner Join returns records with matching values in both tables.
-- The inner join clause compares each row from the first table with every row from the second table.

/*
Returns only the rows where the join condition matches.

Equi Join = a join condition based on equality (=).

In MySQL, INNER JOIN by default is an equi join.
*/

SELECT 
    m.member_id, 
    m.name AS member, 
    c.committee_id, 
    c.name AS committee
FROM
    members m
INNER JOIN committees c ON c.name = m.name;

-- Because both tables use the same column to match, you can use the USING clause as shown in the following query:

SELECT 
    m.member_id, 
    m.name AS member, 
    c.committee_id, 
    c.name AS committee
FROM
    members m
INNER JOIN committees c USING(name);


# LEFT OUTER JOIN (or just LEFT JOIN)

-- Returns all rows from the left table.
-- If no match → right table columns show NULL.

SELECT 
    m.member_id, 
    m.name AS member, 
    c.committee_id, 
    c.name AS committee
FROM
    members m
-- LEFT JOIN committees c ON c.name = m.name;
LEFT JOIN committees c USING(name);
-- WHERE c.committee_id IS NULL;

-- To find members who are not the committee members

# RIGHT OUTER JOIN (or just RIGHT JOIN)

-- Returns all rows from the right table.
--If no match → left table columns show NULL.

SELECT 
    m.member_id, 
    m.name AS member, 
    c.committee_id, 
    c.name AS committee
FROM
    members m
RIGHT JOIN committees c on c.name = m.name;
-- RIGHT JOIN committees c USING(name);
-- WHERE m.member_id IS NULL;

-- To find the committee members who are not in the members table

# CROSS JOIN clause

/*The cross join makes a Cartesian product of rows from 
the joined tables. The cross join combines each row from 
the first table with every row from the right table to make 
the result set.*/

SELECT 
    m.member_id, 
    m.name AS member, 
    c.committee_id, 
    c.name AS committee
FROM
    members m
CROSS JOIN committees c;

NATURAL JOIN (MySQL-specific)

/* Automatically joins tables based on columns with the same name and datatype.
You don’t need to write the ON condition.
Example:
If both employees and departments have a column dept_id, then:*/

SELECT *
FROM members
NATURAL JOIN committees;


-------------------------------
## Self Join

/*A SELF JOIN is when a table is joined with itself.
It is useful for hierarchical or relational data inside the same table (e.g., employees & their managers, products & related products).
We use table aliases to treat the same table as two separate tables.*/

CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    manager_id INT
);

INSERT INTO employees (name, manager_id) VALUES
('Alice', NULL),     -- Alice is the CEO (no manager)
('Bob', 1),          -- Bob reports to Alice
('Charlie', 1),      -- Charlie reports to Alice
('David', 2),        -- David reports to Bob
('Eve', 2);          -- Eve reports to Bob


-- We want to show employees along with their manager’s name.

SELECT e.name AS Employee,
       m.name AS Manager
FROM employees e
inner JOIN employees m
  ON e.manager_id = m.emp_id;

----------------------------------------------------