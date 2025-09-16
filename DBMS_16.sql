Stored Function

/*
A MySQL stored function is a set of SQL statements that 
can be saved in the database and executed by name. 
It's similar to a stored procedure but with one key 
difference: a function must return a single value, 
while a procedure can return multiple values 
(or none at all) through OUT parameters. 
Functions are often used for calculations and 
data manipulations that produce a single result.
*/

DELIMITER $$

CREATE FUNCTION function_name (parameter1 datatype, parameter2 datatype, ...)
RETURNS return_datatype
[DETERMINISTIC | NOT DETERMINISTIC]
[NO SQL | READS SQL DATA | MODIFIES SQL DATA]
BEGIN
  -- SQL statements
  -- DECLARE variables;
  -- business logic;
  RETURN value;
END$$

DELIMITER ;

DELIMITER $$: Changes the default statement delimiter from ; to $$ so that the semicolons within the function body don't terminate the CREATE FUNCTION statement.
CREATE FUNCTION function_name: Defines the function's name.
parameter1 datatype: Specifies the input parameters and their data types. Parameters are optional.
RETURNS return_datatype: Crucially, this clause specifies the data type of the single value that the function will return.
DETERMINISTIC | NOT DETERMINISTIC: An optional characteristic that tells MySQL whether the function will produce the same result for the same input parameters.
NO SQL | READS SQL DATA | MODIFIES SQL DATA: These optional characteristics describe the nature of the SQL statements within the function.
    NO SQL: Contains no SQL statements.
    READS SQL DATA: Reads data but doesn't modify it (e.g., SELECT statements).
    MODIFIES SQL DATA: Contains statements that write or modify data (e.g., INSERT, UPDATE, DELETE).
BEGIN ... END: The block containing the function's body.
RETURN value: The final statement that returns the functions calculated single value.

-----------------------------------------
# Getting Todays Date

DELIMITER $$

CREATE FUNCTION GetTodayDate()
RETURNS DATE
NOT DETERMINISTIC
BEGIN
  RETURN CURDATE();
END$$

DELIMITER ;

SELECT GetTodayDate() AS today;

# Counting Total Customers

DELIMITER $$

CREATE FUNCTION GetTotalCustomers()
RETURNS INT
READS SQL DATA
BEGIN
  DECLARE customerCount INT;
  
  SELECT COUNT(*) INTO customerCount
  FROM customers;
  
  RETURN customerCount;
END$$

DELIMITER ;

SELECT GetTotalCustomers();

/*
Imagine you have a table with people's first and last names, and you want a single column that shows their full name. Instead of writing the CONCAT function every time, you can create a stored function to do it for you.
*/
DELIMITER $$

CREATE FUNCTION GetFullName (firstName VARCHAR(50), lastName VARCHAR(50))
RETURNS VARCHAR(101)
DETERMINISTIC
BEGIN
  DECLARE fullName VARCHAR(101);
  SET fullName = CONCAT(firstName, ' ', lastName);
  RETURN fullName;
END$$

DELIMITER ;

SELECT employee_id, GetFullName(first_name, last_name) AS full_name
FROM employees;

/*
The Problem:
Imagine you have a table called products with 
two columns: price and discount_percentage. 
You want a simple way to calculate the final price 
of a product after the discount is applied, and 
you will need to do this calculation often.
*/

Instead of writing the calculation repeatedly 
in every query, you can create a stored 
function that handles the logic for you.

DELIMITER $$

CREATE FUNCTION CalculateFinalPrice(product_price DECIMAL(10, 2), discount_percent DECIMAL(5, 2))
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
  DECLARE final_price DECIMAL(10, 2);
  SET final_price = product_price - (product_price * (discount_percent / 100));
  RETURN final_price;
END$$

DELIMITER ;

now call in the query 

SELECT
    product_name,
    price,
    discount_percentage,
    CalculateFinalPrice(price, discount_percentage) AS final_price
FROM
    products;


/*
DETERMINISTIC: MySQL can cache the result for a given set of inputs. If the function is called again with the same inputs within the same query, 
MySQL can reuse the previous result instead of re-executing the function. This can significantly improve performance.

NOT DETERMINISTIC: The function's result is not guaranteed to be consistent. MySQL cannot cache the results and must
 execute the function every time it's called. This is necessary for functions that rely on factors outside of their parameters, 
 such as the current date or random values.    
*/
# DETERMINISTIC

A function that performs a mathematical calculation is a 
perfect example of a deterministic function. 
For a given input, the output will never change.

DELIMITER $$

CREATE FUNCTION ConvertCelsiusToFahrenheit(celsius DECIMAL(5, 2))
RETURNS DECIMAL(5, 2)
DETERMINISTIC
BEGIN
  DECLARE fahrenheit DECIMAL(5, 2);
  SET fahrenheit = (celsius * 9/5) + 32;
  RETURN fahrenheit;
END$$

DELIMITER ;
In this example, ConvertCelsiusToFahrenheit(20) will always return 68. There is no possibility of a different result, making it deterministic.

# NOT DETERMINISTIC

A function that uses a random number or the current date is not deterministic because its output is not solely dependent on its input parameters.

DELIMITER $$

CREATE FUNCTION GetRandomNumber(min_val INT, max_val INT)
RETURNS INT
NOT DETERMINISTIC
BEGIN
  RETURN FLOOR(min_val + RAND() * (max_val - min_val + 1));
END$$

DELIMITER ;

