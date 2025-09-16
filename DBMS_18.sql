Error Handling 

/*
In MySQL, error handling in stored procedures and functions 
is managed using HANDLERs. A handler is a block of code 
that executes when a specific condition, such as a 
SQL warning or exception, occurs. 
This allows you to define how your stored program 
should respond to different errors instead of just failing.
*/

Types of Handler Actions

A handler defines what action to take when a condition is met. There are three main types of handler actions:
CONTINUE: The handler's code executes, but the stored program continues its normal execution. This is useful for handling warnings or non-critical errors.
EXIT: The handler's code executes, and then the stored program immediately terminates. This is the most common action for critical errors that prevent the procedure from completing successfully.
UNDO: This action is specific to XA (eg.  distributed) transactions and is rarely used. It is not supported in most common contexts.

How to Write a Handler

DECLARE handler_action HANDLER FOR condition_value_or_name statement;

handler_action: This is the action to take, either CONTINUE or EXIT.
condition_value_or_name: This specifies the condition that triggers the handler. You can use:
    SQLSTATE value: A 5-character string that identifies a specific error (e.g., '23000' for integrity constraint violation).
    MySQL error code: A numeric code for a specific error (e.g., 1062 for Duplicate entry).
    Predefined condition name: Names like SQLEXCEPTION, SQLWARNING, or NOT FOUND.
        SQLEXCEPTION: Catches all errors (SQLSTATE values not starting with '00', '01', or '02').
        SQLWARNING: Catches all warnings (SQLSTATE values starting with '01').
        NOT FOUND: Catches a condition where a SELECT statement returns no rows.
statement: The SQL statement or block of code (BEGIN...END) that the handler will execute.

-- Handling a Duplicate Entry Error

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100)
);

-- Create the Stored Procedure

DELIMITER $$

CREATE PROCEDURE AddProduct(IN p_id INT, IN p_name VARCHAR(100))
BEGIN
    -- This handler will run if a 'Duplicate entry' error occurs.
    -- It prints a message and then exits the procedure.
    DECLARE EXIT HANDLER FOR 1062
    -- -- The SQLSTATE for this is '23000'.
    --  DECLARE EXIT HANDLER FOR SQLSTATE '23000'
    BEGIN
        SELECT 'Error: Product with that ID already exists.' AS message;
    END;

    -- The main task: try to insert the new product.
    INSERT INTO products (product_id, product_name)
    VALUES (p_id, p_name);

    -- This message will only be shown if the insert was successful.
    SELECT 'Product added successfully.' AS message;

END$$

DELIMITER ;

CALL AddProduct(1, 'Laptop'); -- Successful 
CALL AddProduct(1, 'Keyboard'); -- Error product_id 1 already exists.


CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) UNIQUE,
    salary DECIMAL(10, 2)
);

-- Create a Stored Procedure with Handlers

DELIMITER $$

CREATE PROCEDURE AddEmployee(
    IN p_employee_id INT,
    IN p_employee_name VARCHAR(100),
    IN p_salary DECIMAL(10, 2)
)
BEGIN
    -- Handler for 'Duplicate entry' error (error code 1062)
    -- If this error occurs, it prints a message and exits the procedure.
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
        SELECT CONCAT('Error: The employee name "', p_employee_name, '" already exists.') AS message;
    END;

    -- Handler for 'NOT FOUND' condition (often for SELECT INTO)
    -- This handler won't be triggered by the INSERT, but it's a good example
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        -- This code is just for demonstration
        SELECT 'A record was not found.' AS warning_message;
    END;

    -- Main logic: Attempt to insert the new employee
    INSERT INTO employees (employee_id, employee_name, salary)
    VALUES (p_employee_id, p_employee_name, p_salary);

    -- If the procedure reaches this point, the insert was successful.
    SELECT 'Employee added successfully.' AS message;

END$$

DELIMITER ;

CALL AddEmployee(101, 'John Doe', 60000.00);

-- This will try to insert a duplicate name
CALL AddEmployee(102, 'John Doe', 70000.00);

/*
 The database will throw a "duplicate entry" error (code 1062). Our EXIT handler catches this. It prints the custom error message and stops the procedure, so the final "Employee added successfully" message is never shown.
*/

-- both 23000 and 1062 are predefined codes. 23000 is the standard SQLSTATE value, and 1062 is the specific MySQL error code for the same condition: a Duplicate entry for a PRIMARY KEY or UNIQUE constraint.