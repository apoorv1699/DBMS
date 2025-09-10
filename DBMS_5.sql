# MySQL NOT NULL constraints

-- A NOT NULL constraint ensures that values stored in a column are not NULL. The syntax for defining a NOT NULL constraint is as follows:

# column_name data_type NOT NULL;

-- if you attempt to update or insert a NULL value into a NOT NULL column, MySQL will issue an error.

CREATE TABLE tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE
);

-- In the tasks table, we explicitly define the title and start_date columns with NOT NULL constraints.

-- The id column has the PRIMARY KEY constraint, therefore, it implicitly includes a NOT NULL constraint.

DESC tasks;

INSERT INTO tasks(title ,start_date, end_date)
VALUES('Learn MySQL NOT NULL constraint', '2017-02-01','2017-02-02'),
      ('Check and update NOT NULL constraint to your database', '2017-02-01',NULL);

SELECT * FROM tasks 
WHERE end_date IS NULL;

-- Third, update the NULL values to non-null values. In this case, you can create a rule that sets to one week after the start date when the end_date is NULL.

UPDATE tasks 
SET 
    end_date = start_date + 7
WHERE
    end_date IS NULL;

SELECT * FROM tasks;

# add a NOT NULL constraint to the end_date column using the following ALTER TABLE statement:

ALTER TABLE table_name
CHANGE 
   old_column_name 
   new_column_name column_definition;

ALTER TABLE tasks 
CHANGE 
    end_date 
    end_date DATE NOT NULL;

# Removing a NOT NULL constraint
-- To drop a NOT NULL constraint for a column, you use the ALTER TABLE..MODIFY statement:

ALTER TABLE tasks 
MODIFY end_date DATE;


----------------------------------------

# DEFAULT
-- MySQL DEFAULT constraint allows you to specify a default value for a column. Here’s the syntax of the DEFAULT constraint:
column_name data_type DEFAULT default_value;

-- The default_value must be a literal constant, e.g., a number or a string. It cannot be a function or an expression. However, MySQL allows you to set the current date and time (CURRENT_TIMESTAMP) to the TIMESTAMP and DATETIME columns.

-- When you define a column without the NOT NULL constraint, the column will implicitly take NULL as the default value.

CREATE TABLE cart_items 
(
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    price DEC(5,2) NOT NULL,
    sales_tax DEC(5,2) NOT NULL DEFAULT 0.1, 
);
-- he sales_tax column has a default value 0.1 (10%). The following statement shows the cart_items table:

DESC cart_items;

INSERT INTO cart_items(name, quantity, price)
VALUES('Keyboard', 1, 50);

SELECT * FROM cart_items;

INSERT INTO cart_items(name, quantity, price, sales_tax)
VALUES('Battery',4, 0.25 , DEFAULT);

SELECT * FROM cart_items;

# DEFAULT constraint to a column
--- o add a default constraint to a column of an existing table, you use the ALTER TABLE statement:

ALTER TABLE table_name
ALTER COLUMN column_name SET DEFAULT default_value;

ALTER TABLE cart_items
ALTER COLUMN quantity SET DEFAULT 1;

DESC cart_items;

INSERT INTO cart_items(name, price, sales_tax)
VALUES('Maintenance services',25.99, 0)

SELECT * FROM cart_items;
-- CHECK constraint to ensure that values stored in a column or group of columns satisfy a Boolean expression.

# CHECK Constraint

CHECK(expression)

CONSTRAINT constraint_name 
CHECK (expression) 
[ENFORCED | NOT ENFORCED]

-- CHECK constraints as column constraints

CREATE TABLE parts (
    part_no VARCHAR(18) PRIMARY KEY,
    description VARCHAR(40),
    cost DECIMAL(10,2 ) NOT NULL CHECK (cost >= 0),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0)
);

-- Because we did not explicitly specify the names of the CHECK constraints, MySQL automatically generated names for them.

SHOW CREATE TABLE parts;

INSERT INTO parts(part_no, description,cost,price) 
VALUES('A-001','Cooler',0,-100);

-- error

-- Because the value of the price column is negative which causes the expression price > 0 evaluates to FALSE that results in a constraint violation.

# CHECK constraints as a table constraints

DROP TABLE IF EXISTS parts;

CREATE TABLE parts (
    part_no VARCHAR(18) PRIMARY KEY,
    description VARCHAR(40),
    cost DECIMAL(10,2 ) NOT NULL CHECK (cost >= 0),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    CONSTRAINT parts_chk_price_gt_cost 
        CHECK(price >= cost)
);

INSERT INTO parts(part_no, description,cost,price) 
VALUES('A-001','Cooler',200,100);

-- error
-- Adding a check constraint to a table
ALTER TABLE table_name
ADD CHECK (expression);

ALTER TABLE table_name
ADD CONSTRAINT contraint_name
CHECK (expression);

ALTER TABLE parts
ADD CHECK (part_no <> description);
-- This CHECK constraint prevents you from having the part_no identical to the description.

INSERT INTO parts 
VALUES('A','A',100,120);

-- To remove a CHECK constraint from a table, you use the ALTER TABLE ... DROP CHECK statement:

ALTER TABLE table_name
DROP CHECK constraint_name;

ALTER TABLE parts
DROP CHECK parts_chk_3;


