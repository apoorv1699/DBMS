CREATE DATABASE companyDB1;
USE companyDB1;

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    salary DECIMAL(10,2),
    department_id INT
);

CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(50)
);

INSERT INTO departments (department_name, location) VALUES
('HR', 'Chicago'),
('Sales', 'New York'),
('IT', 'San Francisco'),
('Finance', 'New York'),
('Marketing', 'Los Angeles');

INSERT INTO employees (name, salary, department_id) VALUES
('Alice', 6000, 1),
('Bob', 7500, 2),
('Charlie', 5000, 2),
('David', 9000, 3),
('Eve', 6500, 3),
('Frank', 5500, 4),
('Grace', 7000, 4),
('Hannah', 8000, 5),
('Ivy', 7200, 2),
('Jack', 5800, 1);

# Subquery

-- A subquery (or inner query/nested query) is a query written inside another query.

    --The outer query (also called the main query) uses the result of the subquery.

    --Subqueries are always enclosed in parentheses ().

# Think of it as: “A query inside another query.”

# Why Use Subqueries?

    -- To break down complex problems into smaller parts.
    -- To use the result of one query as input to another.
    -- To compare values against aggregated results (AVG, MAX, etc.).

SELECT column1, column2
FROM table_name
WHERE column_name operator (SELECT column_name FROM another_table WHERE condition);

# Single-row Subquery

  --  Returns only one value (one row, one column).
  --  Used with operators like =, >, <.

# Example: Find employees who earn more than the average salary:

SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);


SELECT name, salary
FROM employees					-- 8000									-- 9000
WHERE salary < (SELECT max(salary)FROM employees where salary < (SELECT max(salary) FROM employees))
order by salary desc
limit 1;


-- (SELECT AVG(salary) FROM employees) returns a single value.
-- The outer query compares each employee’s salary with that value.

# Employee(s) from the Department with the Highest Average Salary

SELECT name, salary, department_id
FROM employees
WHERE department_id = (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    ORDER BY AVG(salary) DESC
    LIMIT 1
);

# Find employees earning more than the average salary of Sales department:

SELECT name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    WHERE d.department_name = 'Sales'
);


# Multi-row Subquery

    -- Returns multiple values (one column, many rows).
    -- Used with operators like IN, ANY, ALL.

 Example: Find employees who work in departments located in New York:

SELECT name
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM departments
    WHERE location = 'New York'
);
---------------------------------------
SELECT 
    lastName, firstName
FROM
    employees
WHERE
    officeCode IN (SELECT 
            officeCode
        FROM
            offices
        WHERE
            country = 'USA');

    -- Inner query returns multiple department_ids.
    -- Outer query checks if the employee’s department is in that list.

-- You can use comparison operators e.g., =, >, < to compare a single value returned by the subquery with the expression in the WHERE clause.
-- For example, the following query returns the customer who has the highest payment.

SELECT 
    customerNumber, 
    checkNumber, 
    amount
FROM
    payments
WHERE
    amount = (SELECT MAX(amount) FROM payments);
-------------------------------

-- For example, you can find customers 
-- whose payments are greater than the average payment using a subquery:

SELECT 
    customerNumber, 
    checkNumber, 
    amount
FROM
    payments
WHERE
    amount > (SELECT 
            AVG(amount)
        FROM
            payments);

In this example:
    -- First, get the average payment by using a subquery.
    -- Then, select the payments that are greater than the average payment returned by the subquery in the outer query.          

# See the following customers and orders tables:

-- For example, you can use a subquery with NOT IN operator to find the customers who have not placed any orders as follows:

SELECT 
    customerName
FROM
    customers
WHERE
    customerNumber NOT IN (SELECT DISTINCT
            customerNumber
        FROM
            orders);


# Correlated Subquery

-- in the previous examples, 
-- you notice that a subquery is independent. 
-- It means that you can execute the subquery as a standalone query, for example:

-- a correlated subquery is a subquery that uses the data from the outer query. 
-- In other words, a correlated subquery depends on the outer query. 
-- A correlated subquery is evaluated once for each row in the outer query.

    --Subquery depends on the outer query for its value.
    --Runs again for each row in the outer query.

-- example uses a correlated subquery to select 
-- products whose buy prices are greater than the average 
-- buy price of all products in each product line.

SELECT 
    productname, 
    buyprice
FROM
    products p1
WHERE
    buyprice > (SELECT 
            AVG(buyprice)
        FROM
            products
        WHERE
            productline = p1.productline);

-- In this example, both the outer query and correlated subquery reference the same products table. 
-- Therefore, we need to use a table alias p1 for the products table in the outer query.

-- Unlike a regular subquery, you cannot execute a correlated subquery independently like this. 
-- If you do so, MySQL doesn’t know the p1 table and will issue an error.
SELECT 
    AVG(buyprice)
FROM
    products
WHERE
    productline = p1.productline;

-- show error

-- For each row in the products (or p1) table, the correlated subquery needs to execute once to get the average buy price of all products in the productline of that row.

# Example: Find employees who earn more than the average salary of their department:

SELECT e.name, e.salary, e.department_id
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);

-- For each employee e, the subquery calculates the average salary of that employee’s department.


# subquery with EXISTS and NOT EXISTS

-- When a subquery is used with the EXISTS or NOT EXISTS operator, 
-- a subquery returns a Boolean value of TRUE or FALSE.  
-- The following query illustrates a subquery used with the EXISTS operator:



# Subquery in FROM (Derived Table)

    -- Subquery acts like a temporary table.
    -- Useful when you need aggregated data first.

# Example: Find the maximum salary per department:

SELECT department_id, MAX(salary) AS max_salary
FROM (
    SELECT department_id, salary
    FROM employees
) AS dept_salaries
GROUP BY department_id;

SELECT department_id, AVG(salary)
FROM (
  SELECT department_id, salary
  FROM employees
  where department_id = 3
) AS usa_customers;
