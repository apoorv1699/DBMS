 CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2)
);

INSERT INTO employees (emp_name, department, salary) VALUES
('Alice', 'Sales', 12000),
('Bob', 'Sales', 8000),
('Charlie', 'HR', 4500),
('Diana', 'IT', 9500),
('Ethan', 'IT', 3000);

 
 ## IF Statement

 IF(condition, value_if_true, value_if_false)

IF condition THEN 
   statements;
END IF;


SELECT emp_id,
       emp_name,
       salary,
       IF(salary > 5000, 'High', 'Low') AS salary_status
FROM employees;
---------------------
DELIMITER $$

CREATE PROCEDURE GetCustomerLevel(
    IN  pCustomerNumber INT, 
    OUT pCustomerLevel  VARCHAR(20))
BEGIN
    DECLARE credit DECIMAL(10,2) DEFAULT 0;

    SELECT creditLimit 
    INTO credit
    FROM customers
    WHERE customerNumber = pCustomerNumber;

    IF credit > 50000 THEN
        SET pCustomerLevel = 'PLATINUM';
    END IF;
END$$

DELIMITER ;

--This statement finds all customers that have a credit limit greater than 50,000:


SELECT 
    customerNumber, 
    creditLimit
FROM 
    customers
WHERE 
    creditLimit > 50000
ORDER BY 
    creditLimit DESC;


CALL GetCustomerLevel(141, @level);
SELECT @level;
-----------------------

IF condition THEN
    statements;
ELSEIF condition THEN
    statements;
ELSE
    statements;
END IF;

-----------------------------------
DELIMITER //
CREATE PROCEDURE ProcessStudent(IN studentMarks INT)
BEGIN
    IF studentMarks >= 50 THEN
        INSERT INTO passed_students (marks) VALUES (studentMarks);
    ELSE
        INSERT INTO failed_students (marks) VALUES (studentMarks);
    END IF;
END //
DELIMITER ;

    Insert into passed_students if marks ≥ 50
    Insert into failed_students if marks < 50

You cannot do this with just a query IF() function.

-------------------

DELIMITER //
CREATE PROCEDURE CheckSalary(IN empSalary DECIMAL(10,2), OUT category VARCHAR(20))
BEGIN
    IF empSalary > 10000 THEN
        SET category = 'Executive';
    ELSEIF empSalary BETWEEN 5000 AND 10000 THEN
        SET category = 'Mid-Level';
    ELSE
        SET category = 'Entry-Level';
    END IF;
END //
DELIMITER ;

CALL CheckSalary(7500, @result);
SELECT @result;  -- Returns "Mid-Level"


----
DELIMITER $$

CREATE PROCEDURE GetCustomerLevel(
    IN  pCustomerNumber INT, 
    OUT pCustomerLevel  VARCHAR(20))
BEGIN
    DECLARE credit DECIMAL DEFAULT 0;

    SELECT creditLimit 
    INTO credit
    FROM customers
    WHERE customerNumber = pCustomerNumber;

    IF credit > 50000 THEN
        SET pCustomerLevel = 'PLATINUM';
    ELSE
        SET pCustomerLevel = 'NOT PLATINUM';
    END IF;
END$$

DELIMITER ;


CALL GetCustomerLevel(447, @level);
SELECT @level;
----


---------------------------

DELIMITER $$

CREATE PROCEDURE GetCustomerLevel(
    IN  pCustomerNumber INT, 
    OUT pCustomerLevel  VARCHAR(20))
BEGIN
    DECLARE credit DECIMAL DEFAULT 0;

    SELECT creditLimit 
    INTO credit
    FROM customers
    WHERE customerNumber = pCustomerNumber;

    IF credit > 50000 THEN
        SET pCustomerLevel = 'PLATINUM';
    ELSEIF credit <= 50000 AND credit > 10000 THEN
        SET pCustomerLevel = 'GOLD';
    ELSE
        SET pCustomerLevel = 'SILVER';
    END IF;
END $$

DELIMITER ;


CALL GetCustomerLevel(447, @level); 
SELECT @level;

-----------------------
# CASE statement

    IF works well for simple conditions.
    CASE is better when you have multiple choices in queries.

CASE case_value
   WHEN when_value1 THEN statements
   WHEN when_value2 THEN statements
   ...
   [ELSE else-statements]
END CASE;

-----------------

SELECT emp_name,
       CASE
         WHEN salary > 10000 THEN 'Executive'
         WHEN salary BETWEEN 5000 AND 10000 THEN 'Mid-Level'
         ELSE 'Entry-Level'
       END AS category
FROM employees;

-----------------------------------

DELIMITER $$ 

CREATE PROCEDURE GetCustomerShipping(
  IN pCustomerNumber INT, 
  OUT pShipping VARCHAR(50)
) 
BEGIN 
	DECLARE customerCountry VARCHAR(100);
	SELECT 
	  country INTO customerCountry 
	FROM 
	  customers 
	WHERE 
	  customerNumber = pCustomerNumber;

	CASE customerCountry 
		WHEN 'USA' THEN 
			SET pShipping = '2-day Shipping';
		WHEN 'Canada' THEN 
			SET pShipping = '3-day Shipping';
		ELSE 
			SET pShipping = '5-day Shipping';
	END CASE;
END$$ 

DELIMITER ;

CALL GetCustomerShipping(112,@shipping);
SELECT @shipping;


# LOOP statement
    LOOP (generic infinite loop, must EXIT manually)
    WHILE (runs while a condition is true)
    REPEAT (runs until a condition is true — at least once)

-- LOOP

[begin_label:] LOOP
    statements;
END LOOP [end_label]

----------------

Print numbers from 1 to 5. while loop

DELIMITER //
CREATE PROCEDURE SimpleWhile()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 5 DO
        SELECT i AS number;
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

CALL SimpleWhile();

Example 2: LOOP (with LEAVE)

DELIMITER //
CREATE PROCEDURE SimpleLoop()
BEGIN
    DECLARE i INT DEFAULT 1;

    loop_label: LOOP
        IF i > 5 THEN
            LEAVE loop_label;
        END IF;

        SELECT i AS number;
        SET i = i + 1;
    END LOOP loop_label;
END //
DELIMITER ;

CALL SimpleLoop();


Example 3: REPEAT Loop

DELIMITER //
CREATE PROCEDURE SimpleRepeat()
BEGIN
    DECLARE i INT DEFAULT 1;

    REPEAT
        SELECT i AS number;
        SET i = i + 1;
    UNTIL i > 5
    END REPEAT;
END //
DELIMITER ;

CALL SimpleRepeat();
-----------------

----------------





CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    marks INT,
    result VARCHAR(10)
);

INSERT INTO students (name, marks) VALUES
('Amit', 85),
('Sara', 40),
('John', 65),
('Neha', 30),
('Vikram', 55);


DELIMITER //
CREATE PROCEDURE LoopExample()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE total INT;

    SELECT COUNT(*) INTO total FROM students;

    loop_label: LOOP
        IF i > total THEN
            LEAVE loop_label;
        END IF;

        UPDATE students
        SET result = IF(marks >= 50, 'Pass', 'Fail')
        WHERE id = i;

        SET i = i + 1;
    END LOOP loop_label;
END //
DELIMITER ;


CALL LoopExample();
SELECT * FROM students;


-- while

DELIMITER //
CREATE PROCEDURE WhileLoopExample()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE total INT;

    -- Get total number of students
    SELECT COUNT(*) INTO total FROM students;

    -- Loop until last row
    WHILE i <= total DO
        UPDATE students
        SET result = IF(marks >= 50, 'Pass', 'Fail')
        WHERE id = i;

        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;


CALL WhileLoopExample();
SELECT * FROM students;


-- REPEAT loop

-- Condition checked after execution (runs at least once).

DELIMITER //
CREATE PROCEDURE RepeatLoopExample()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE total INT;

    SELECT COUNT(*) INTO total FROM students;

    REPEAT
        UPDATE students
        SET result = IF(marks >= 50, 'Pass', 'Fail')
        WHERE id = i;

        SET i = i + 1;
    UNTIL i > total
    END REPEAT;
END //
DELIMITER ;

CALL RepeatLoopExample();
SELECT * FROM students;
