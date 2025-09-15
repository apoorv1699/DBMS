# MySQL Stored Procedures

/*
1. What is a Stored Procedure?
    A Stored Procedure is a set of SQL statements stored in the database.
    It can be executed (called) whenever needed, like a function in programming.
    A stored procedure is a named collection of SQL statements that runs on 
    the MySQL server and can be invoked with the CALL command.
    
    Helps with:
        Reusability (no need to rewrite SQL each time)
        Security (can restrict access to only calling the procedure)
        Performance (precompiled execution)
*/

DELIMITER //
CREATE PROCEDURE procedure_name (parameter_1, parameter_2, ...)
BEGIN
    -- SQL statements
END //
DELIMITER ;

------------------------------
SELECT 
    customerName, 
    city, 
    state, 
    postalCode, 
    country
FROM
    customers
ORDER BY customerName;

-- When you use MySQL Workbench or the mysql shell to execute a query on the MySQL Server, 
-- the server processes the query and returns the result set.

-- If you intend to save this query on the database server for later execution, one way to achieve this is by using a stored procedure.

DELIMITER $$

CREATE PROCEDURE GetCustomers()
BEGIN
	SELECT 
		customerName, 
		city, 
		state, 
		postalCode, 
		country
	FROM
		customers
	ORDER BY customerName;    
END$$
DELIMITER ;

-- a stored procedure is a set of declarative SQL statements stored within the MySQL Server. 

-- n this example, we have just created a stored procedure named GetCustomers().

CALL GetCustomers();

--The statement returns the same result as the query.

    First, find the stored procedure by its name in the database catalog.
    Second, compile the code of the stored procedure.
    Third, store the compiled stored procedure in a cache memory area.
    Finally, execute the stored procedure.

Key Advantages
    Better Performance: Procedures are compiled once and stored in executable form, making calls quick and efficient. 
    Code Reusability and Modularity: Developers can encapsulate business logic within procedures and reuse them across applications, minimizing duplication and simplifying maintenance.
    Security and Access Control: Stored procedures enable precise privilege management, allowing access to procedures while restricting direct table manipulation.
    Centralized Logic: Business logic can be centrally maintained in the database, making updates easier and ensuring consistent behavior across applications
    Reduced Network Traffic: Bundling multiple statements into a procedure reduces network overhead and communication between client and server.
    Maintainability: Changes to procedures reflect immediately for all users without updating client-side application logic

stored procedures disadvantages
    Resource usage – If you use many stored procedures, the memory usage of every connection will significantly increase. 
    Troubleshooting – Debugging stored procedures is quite challenging. Unfortunately, MySQL lacks facilities for debugging stored procedures,
    Maintenances – Developing and maintaining stored procedures often demands a specialized skill set not universally possessed by all application developers,

DELIMITER //

CREATE PROCEDURE GetAllProducts()
BEGIN
	SELECT *  FROM products;
END //

DELIMITER ;


DROP PROCEDURE IF EXISTS GetCustomers;

-- Declaring variables
-- A variable is a named data object whose value can change during the execution of a stored procedure.
-- Typically, you use variables to hold immediate results. These variables are local to the stored procedure.

DECLARE variable_name datatype(size) [DEFAULT default_value];

DECLARE totalSale DEC(10,2) DEFAULT 0.0;
DECLARE totalQty, stockCount INT DEFAULT 0;

DECLARE amount DECMIAL(10,2), 
        currency CHAR(3) DEFAULT 'USD';  --error

DECLARE amount DECMIAL(10,2);
DECLARE currency CHAR(3) DEFAULT 'USD';      

# Assigning variables
SET variable_name = value;

DECLARE total INT DEFAULT 0;
SET total = 10;

-- In addition to the SET statement, you can use the SELECT INTO statement to assign the result of a query to a variable as shown in the following example:

DECLARE productCount INT DEFAULT 0;

SELECT COUNT(*) 
INTO productCount
FROM products;

# Stored Procedure Variable 

DELIMITER $$

CREATE PROCEDURE GetTotalOrder()
BEGIN
	DECLARE totalOrder INT DEFAULT 0;
    
	SELECT 
		COUNT(*)
	INTO totalOrder FROM     -- use the SELECT INTO  statement to assign the variable totalOrder the number of orders selected from the orders table:
		orders;
    
	SELECT totalOrder;
END$$

DELIMITER ;

------

CALL GetTotalOrder();

------
# user-defined variables (also callled session Variable)

-- sometime you want to pass a value from an SQL statement to other SQL statements within the same session.
-- you store the value in a user-defined variable in the first statement and use it in the subsequent statements.

@variable_name

SET @variable_name = value;
-- Besides using the assign operator =, you can use the := operator:
SET @variable_name := value;
SELECT value INTO @variable_name;

--Note that user-defined variables are the MySQL-specific extension to SQL standard. They may not be available in other database systems.

SELECT 
  MAX(msrp) INTO @msrp
FROM 
  products;

SELECT @msrp;

SELECT 
  productCode, 
  productName, 
  productLine, 
  msrp 
FROM 
  products 
WHERE 
  msrp = @msrp;


# Procedure with Parameters

A parameter in a stored procedure has one of three modes: IN, OUT, or INOUT.

-- IN Parameter (Input only)

-- IN is the default mode. When defining an IN parameter in a stored procedure, 
-- the calling program must pass an argument to the stored procedure.

/*
Use IN when you need to pass values into a procedure for filtering, 
searching, or performing actions, 
but don’t need to return anything back (other than result sets).

DELIMITER //
CREATE PROCEDURE GetEmployeesByDept(IN deptName VARCHAR(50))
BEGIN
    SELECT emp_id, emp_name, salary
    FROM employees
    WHERE department = deptName;
END //
DELIMITER ;

CALL GetEmployeesByDept('Sales');

--IN is best when you just filter or look up data.
*/



CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    grade VARCHAR(10)
);

INSERT INTO students (name, age, grade)
VALUES ('Alice', 14, 'A');


DELIMITER $$

CREATE PROCEDURE getStudentById(IN student_id INT)
BEGIN
    SELECT * FROM students WHERE id = student_id;
END $$

DELIMITER ;


CALL getStudentById(3);

---------------------------------
DELIMITER //

CREATE PROCEDURE GetOfficeByCountry(
	IN countryName VARCHAR(255)
)
BEGIN
	SELECT * 
 	FROM offices
	WHERE country = countryName;
END //

DELIMITER ;


CALL GetOfficeByCountry('USA');
CALL GetOfficeByCountry('France')
CALL GetOfficeByCountry(); -- error
--Because the countryName is the IN parameter, you must pass an argument. If you don’t do so, you’ll get an error:

---------------------------------

# OUT Parameter (Output only)
-- The value of an OUT parameter can be modified within the stored procedure, and its updated value is then passed back to the calling program.

-- stored procedures cannot access the initial value of the OUT parameter when they begin.

/*
Use OUT when you want to send back values to the caller, 
especially when you don’t want a full result set but just a specific value.

DELIMITER //
CREATE PROCEDURE GetDeptExpense(IN deptName VARCHAR(50), OUT totalExpense DECIMAL(12,2))
BEGIN
    SELECT SUM(salary)
    INTO totalExpense
    FROM employees
    WHERE department = deptName;
END //
DELIMITER ;

CALL GetDeptExpense('Sales', @expense);
SELECT @expense;  -- returns total salary for Sales department

 ➡ OUT is best when you need computed values back, not raw tables.

 -- Real case: A payroll system calling this before generating payslips to know how much a department costs.
*/

DELIMITER $$

CREATE PROCEDURE getStudentCount(OUT total INT)
BEGIN
    SELECT COUNT(*) INTO total FROM students;
END $$

DELIMITER ;


CALL getStudentCount(@count);
SELECT @count;

-----
DELIMITER $$

CREATE PROCEDURE GetOrderCountByStatus (
	IN  orderStatus VARCHAR(25),
	OUT total INT
)
BEGIN
	SELECT COUNT(orderNumber)
	INTO total
	FROM orders
	WHERE status = orderStatus;
END$$

DELIMITER ;


CALL GetOrderCountByStatus('Shipped',@total);
SELECT @total;


CALL GetOrderCountByStatus('In Process',@total);
SELECT @total AS total_in_process;

-----


# INOUT Parameter (Both input and output)

-- An INOUT  parameter is a combination of IN and OUT parameters. This means that the calling program may pass the argument, and the stored procedure can modify the INOUT parameter and pass the new value back to the calling program.


/*
Use INOUT when you pass a value in, modify it in the procedure, and return it back out.
DELIMITER //
CREATE PROCEDURE ApplyTax(INOUT salary DECIMAL(10,2))
BEGIN
    SET salary = salary - (salary * 0.10); -- deduct 10% tax
END //
DELIMITER ;

SET @sal = 5000;
CALL ApplyTax(@sal);
SELECT @sal;  -- returns 4500

INOUT is best when you need to transform or adjust values.
Payroll system sends employee salary into the procedure, procedure deducts tax, and sends back the updated value.
*/
DELIMITER $$

CREATE PROCEDURE doubleValue(INOUT num INT)
BEGIN
    SET num = num * 2;
END $$

DELIMITER ;


SET @x = 5;
CALL doubleValue(@x);
SELECT @x;  -- returns 10


----
DELIMITER $$

CREATE PROCEDURE SetCounter(
	INOUT counter INT,
    IN inc INT
)
BEGIN
	SET counter = counter + inc;
END$$

DELIMITER ;

--the stored procedure SetCounter() accepts one INOUT parameter ( counter ) and one IN parameter ( inc ). It increases the counter ( counter ) by the value specified by the inc parameter.

SET @counter = 1;
CALL SetCounter(@counter,1); -- 2
CALL SetCounter(@counter,1); -- 3
CALL SetCounter(@counter,5); -- 8
SELECT @counter; -- 8


    IN → input only (default).
    OUT → output only.
    INOUT → input & output.

    IN → Search/filter/lookups (Get user by ID, List employees in dept).
    OUT → Return computed values (Total expense, Average salary).
    INOUT → Modify inputs (Apply discounts, Calculate tax, Adjust stock).

SHOW PROCEDURE STATUS;
SHOW PROCEDURE STATUS WHERE db = 'classicmodels';

/*

DELIMITER $$

CREATE PROCEDURE CreatePersonTable()
BEGIN
    -- drop persons table 
    DROP TABLE IF EXISTS persons;
    
    -- create persons table
    CREATE TABLE persons(
        id INT AUTO_INCREMENT PRIMARY KEY,
        first_name VARCHAR(255) NOT NULL,
        last_name VARCHAR(255) NOT NULL
    );
    
    -- insert data into the persons table
    INSERT INTO persons(first_name, last_name)
    VALUES('John','Doe'),
		  ('Jane','Doe');
	
    -- retrieve data from the persons table
    SELECT id, first_name, last_name 
    FROM persons;
END $$

DELIMITER ;

*/

DELIMITER //
CREATE PROCEDURE add_employee(first CHAR(100), last CHAR(100), dob DATE)
BEGIN
  INSERT INTO employees (first_name, last_name) VALUES (first, last);
  SET @id = (SELECT LAST_INSERT_ID());
  INSERT INTO employee_details (emp_id, birth_date) VALUES (@id, dob);
END //
DELIMITER ;

CALL add_employee('John', 'Doe', '1990-05-12');