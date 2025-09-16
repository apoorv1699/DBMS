Triggers

A trigger is a stored program that automatically executes or "fires" in response to a specific event on a table. 

For example, you can define a trigger that is invoked automatically before a new row is inserted into a table.

The three events that can fire a trigger are INSERT, UPDATE, and DELETE. Triggers are used for tasks like data validation, maintaining data integrity, and auditing.

/*
The SQL standard defines two types of triggers: 
    row-level triggers 
    statement-level triggers.

    A row-level trigger is activated for each row that is inserted, 
    updated, or deleted. For example, if a table has 100 rows inserted,
    updated, or deleted, the trigger is automatically invoked 
    100 times for the 100 rows affected.
    
    A statement-level trigger is executed once for each transaction
     regardless of how many rows are inserted, updated, or 
     deleted.
*/

MySQL supports only row-level triggers. 
It doesnt support statement-level triggers.

# Advantages of triggers 
    Triggers provide another way to check the integrity of data.
    Triggers handle errors from the database layer.
    Triggers give an alternative way to run scheduled tasks. By using triggers, you don’t have to wait for the scheduled events to run because the triggers are invoked automatically before or after a change is made to the data in a table.
    Triggers can be useful for auditing the data changes in tables.
# Disadvantages of triggers
    Triggers can only provide extended validations, not all validations. For simple validations, you can use the NOT NULL, UNIQUE, CHECK and FOREIGN KEY constraints.
    Triggers can be difficult to troubleshoot because they execute automatically in the database, which may not be visible to the client applications.
    Triggers may increase the overhead of the MySQL server.

CREATE TRIGGER trigger_name
{BEFORE | AFTER} {INSERT | UPDATE | DELETE}
ON table_name
FOR EACH ROW
BEGIN
    -- Trigger body (SQL statements)
END;

trigger_name: Name of the trigger.
BEFORE or AFTER: Specifies when the trigger should be executed.
INSERT, UPDATE, or DELETE: Specifies the type of operation that activates the trigger.
table_name: Name of the table on which the trigger is defined.
FOR EACH ROW: Indicates that the trigger should be executed once for each row affected by the triggering event.
BEGIN and END: Delimit the trigger body, where you define the SQL statements to be executed.

-- Example 

A BEFORE INSERT Trigger

--create a trigger to ensure that the price of a product is never a negative value before it is inserted into the products table. 
--If a user tries to insert a negative price, 
--we will change it to 0.

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

--Create the Trigger
DELIMITER $$
CREATE TRIGGER before_insert_price
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    IF NEW.price < 0 THEN
        SET NEW.price = 0;
    END IF;
END$$
DELIMITER ;

CREATE TRIGGER before_insert_price: Names the trigger.
BEFORE INSERT ON products: Specifies that this trigger fires BEFORE an INSERT event on the products table.
FOR EACH ROW: This is a standard part of a row-level trigger, meaning the triggers body executes for every row affected by the operation.
IF NEW.price < 0: This condition checks the value of the price column in the new row being inserted.
SET NEW.price = 0;: If the condition is true, it sets the price in the NEW row to 0. This change happens before the data is actually written to the table.

-- Test the Trigger

-- This will insert a price of 25.00
INSERT INTO products (product_name, price) VALUES ('Laptop', 25.00);

-- This will try to insert a negative price, but the trigger will change it to 0
INSERT INTO products (product_name, price) VALUES ('Keyboard', -15.50);

-- Check the results
SELECT * FROM products;

-- Example 

An AFTER UPDATE Trigger for Auditing

create a trigger that logs changes to an employees salary into an audit_log table.

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    salary DECIMAL(10, 2)
);

CREATE TABLE audit_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    old_salary DECIMAL(10, 2),
    new_salary DECIMAL(10, 2),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--  Create the Trigger
We'll create a trigger that fires after an employee's 
salary is updated. It will check if the old salary is 
different from the new one. 
If it is, it inserts a new row into the audit_log table.

DELIMITER $$
CREATE TRIGGER after_update_salary
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    -- Check if the salary has actually changed
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO audit_log (employee_id, old_salary, new_salary)
        VALUES (NEW.employee_id, OLD.salary, NEW.salary);
    END IF;
END$$
DELIMITER ;

AFTER UPDATE ON employees: The trigger is set to fire after an UPDATE operation on the employees table.
IF OLD.salary <> NEW.salary: This is a crucial check. We use the OLD and NEW variables to compare the salary before the update and the salary after the update. The trigger body only executes if there is a real change.
INSERT INTO audit_log (...): If the salaries are different, this statement inserts a record into the audit_log table. We use NEW.employee_id because the employee's ID hasn't changed, and we use OLD.salary and NEW.salary to log the change.

-- Test the Trigger

INSERT INTO employees (employee_id, employee_name, salary)
VALUES (101, 'John Doe', 50000.00);

-- update their salary.
UPDATE employees SET salary = 55000.00 WHERE employee_id = 101;

SELECT * FROM audit_log;
