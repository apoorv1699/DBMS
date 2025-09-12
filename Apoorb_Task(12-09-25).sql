create database  task2;

use task2;

CREATE TABLE employee (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    salary INT NOT NULL,
    department_id INT,
    manager_id INT,
    job_title VARCHAR(100),
    hire_date DATE
);

CREATE TABLE department (
    department_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE emails (
    email_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    signup_date DATETIME NOT NULL
);

CREATE TABLE texts (
    text_id INT PRIMARY KEY,
    email_id INT,
    signup_action VARCHAR(50),
    FOREIGN KEY (email_id) REFERENCES emails(email_id)
);

INSERT INTO department (department_id, name) VALUES
(1, 'IT'),
(2, 'Sales'),
(3, 'Marketing'),
(4, 'HR');

INSERT INTO employee (employee_id, name, salary, department_id, manager_id, job_title, hire_date) VALUES
(1, 'Emma Thompson', 3800, 1, 6, 'Developer', '2020-05-01'),
(2, 'Daniel Rodriguez', 2230, 1, 7, 'Developer', '2021-06-15'),
(3, 'Olivia Smith', 2000, 1, 8, 'Tester', '2021-09-20'),
(4, 'John Smith', 7000, 2, NULL, 'Manager', '2015-02-10'),
(5, 'Jane Doe', 6500, 2, 4, 'Sales Executive', '2017-07-25'),
(6, 'Michael Brown', 9000, 1, NULL, 'Manager', '2010-01-10'),
(7, 'Sophia Lee', 61000, 3, NULL, 'Marketing Head', '2012-04-14'),
(8, 'David Johnson', 59000, 3, 7, 'Marketing Executive', '2018-11-30');

INSERT INTO emails (email_id, user_id, signup_date) VALUES
(125, 7771, '2022-06-14 00:00:00'),
(236, 6950, '2022-07-01 00:00:00'),
(433, 1052, '2022-07-09 00:00:00');

INSERT INTO texts (text_id, email_id, signup_action) VALUES
(6878, 125, 'Confirmed'),
(6920, 236, 'Not Confirmed'),
(6994, 236, 'Confirmed');

-- Find the names of all employees who have a higher salary than the average salary of their department.
SELECT e.name
FROM employee e
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employee
    WHERE department_id = e.department_id
);

-- List the departments that have at least one employee whose salary is greater than $60,000.
SELECT DISTINCT department_id
FROM employee
WHERE salary > 60000;

-- Find the names of all employees who are managed by 'John Smith'.
SELECT e.name
FROM employee e
JOIN employee m ON e.manager_id = m.employee_id
WHERE m.name = 'John Smith';

-- Retrieve the employee names and their salaries for the top 3 highest-paid employees.
SELECT name, salary
FROM employee
ORDER BY salary DESC
LIMIT 3;

-- Show the names of employees who have the same job title as 'Jane Doe'.
SELECT name
FROM employee
WHERE job_title = (
    SELECT job_title
    FROM employee
    WHERE name = 'Jane Doe'
);

-- Find the names of all employees whose hire date is earlier than the average hire date of the entire company.
SELECT name
FROM employee
WHERE hire_date < (
    SELECT AVG(DATE_FORMAT(hire_date, '%Y%m%d'))
    FROM employee
);

-- Create a view to show all employees with a salary greater than the company's average salary. Then,
CREATE VIEW HighSalaryEmployees AS
SELECT *
FROM employee
WHERE salary > (SELECT AVG(salary) FROM employee);

-- Create a view that lists each department's highest-paid employee. Then, find the names of employees from this view who are in the 'IT' department.
CREATE VIEW DeptHighestPaid AS
SELECT e.*
FROM employee e
WHERE salary = (
    SELECT MAX(salary)
    FROM employee
    WHERE department_id = e.department_id
);

SELECT name
FROM DeptHighestPaid
WHERE department_id = (SELECT department_id FROM department WHERE name = 'IT');

-- Create a view for all employees who work in the 'Sales' or 'Marketing' departments. Then, using this view, find the average salary of those employees.
CREATE VIEW SalesMarketingEmployees AS
SELECT *
FROM employee
WHERE department_id IN (
    SELECT department_id FROM department WHERE name IN ('Sales', 'Marketing')
);

SELECT AVG(salary) AS avg_salary
FROM SalesMarketingEmployees;


-- Second Highest Salary
SELECT DISTINCT salary AS second_highest_salary
FROM employee
ORDER BY salary DESC
LIMIT 1 OFFSET 1;

-- Activation Rate
SELECT 
    ROUND(
        COUNT(DISTINCT CASE WHEN t.signup_action = 'Confirmed' THEN e.email_id END) 
        * 1.0 / COUNT(DISTINCT e.email_id), 2
    ) AS confirm_rate
FROM emails e
LEFT JOIN texts t ON e.email_id = t.email_id;
