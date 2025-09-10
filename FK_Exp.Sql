CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    PRIMARY KEY (customer_id)
);

-- Create Orders Table with Foreign Key

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT,
    order_date DATE NOT NULL,
    customer_id INT,
    amount DECIMAL(10,2),
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- customer_id in orders is a foreign key.
-- ON DELETE CASCADE → if a customer is deleted, their orders are also deleted automatically.
-- ON UPDATE CASCADE → if customer_id changes in customers, it updates in orders too.

# Step 3: Insert Data

-- Insert customers
INSERT INTO customers (name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com');

-- Insert orders (customer_id must exist in customers)
INSERT INTO orders (order_date, customer_id, amount) VALUES
('2025-09-01', 1, 250.00),
('2025-09-02', 1, 120.00),
('2025-09-03', 2, 300.00);

Select * from customers;
Select * from orders;

--------------------------------

INSERT INTO orders (order_date, customer_id, amount)
VALUES ('2025-09-04', 99, 150.00);

-- ❌ It will fail because customer_id = 99 does not exist in customers.
-- CASCADE does nothing for INSERT. MySQL just enforces foreign key rules.

-- ✔️ ON DELETE CASCADE and ON UPDATE CASCADE only apply to DELETE and UPDATE operations on the parent table.
-- ✔️ They do not apply to INSERT — insertions are always checked by foreign key rules (existence in parent table).

----------------------------------------------------------------

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

Step 2: Insert Data

INSERT INTO customers VALUES (1, 'Alice'), (2, 'Bob');

INSERT INTO orders VALUES
(101, '2025-09-01', 1),
(102, '2025-09-02', 1),
(103, '2025-09-03', 2);

# Test ON DELETE CASCADE

DELETE FROM customers WHERE customer_id = 1;

# Test ON UPDATE CASCADE
UPDATE customers SET customer_id = 22 WHERE customer_id = 2;


-- Ensures referential integrity automatically.
-- Saves you from writing extra queries to update or delete child rows manually.
-- Very useful in parent-child relationships like:
   --  Customers → Orders
   --  Departments → Employees
   --  Categories → Products



------------------------------------------------

# Not using  CASCADE

-- Parent Table 1: Customers
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- Parent Table 2: Restaurants
CREATE TABLE restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

-- Child Table: Orders (depends on customers & restaurants)
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id INT,
    restaurant_id INT,
    amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

# Step 2: Insert Data

-- Customers
INSERT INTO customers (name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com');

-- Restaurants
INSERT INTO restaurants (name, location) VALUES
('Pizza Place', 'Downtown'),
('Burger House', 'Uptown');

-- Orders
INSERT INTO orders (order_date, customer_id, restaurant_id, amount) VALUES
('2025-09-01', 1, 1, 25.50),
('2025-09-02', 1, 2, 18.00),
('2025-09-03', 2, 1, 30.00);

# What Happens Without CASCADE?
-- Try deleting Alice (customer_id = 1):

DELETE FROM customers WHERE customer_id = 1;

-- Error → Cannot delete Alice because she has orders in the orders table.

-- Try updating customer_id (say 1 → 10):

UPDATE customers SET customer_id = 10 WHERE customer_id = 1;

-- Error → Foreign key constraint fails, because orders.customer_id = 1 still exists.

## Without cascade, you must manually delete or update child rows first.

-- ************************** --

## With CASCADE

-- Parent Table 1: Customers
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- Parent Table 2: Restaurants
CREATE TABLE restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

-- Child Table: Orders (depends on customers & restaurants)
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id INT,
    restaurant_id INT,
    amount DECIMAL(10,2),

    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

--- Step 2: Insert Sample Data

-- Customers
INSERT INTO customers (name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com');

-- Restaurants
INSERT INTO restaurants (name, location) VALUES
('Pizza Place', 'Downtown'),
('Burger House', 'Uptown');

-- Orders (must reference existing customers & restaurants)
INSERT INTO orders (order_date, customer_id, restaurant_id, amount) VALUES
('2025-09-01', 1, 1, 25.50),   -- Alice at Pizza Place
('2025-09-02', 1, 2, 18.00),   -- Alice at Burger House
('2025-09-03', 2, 1, 30.00);   -- Bob at Pizza Place

-- Delete Alice (customer_id = 1):

DELETE FROM customers WHERE customer_id = 1;

-- Automatically deletes all Alice’s orders from orders.

-- Update Bob’s ID (2 → 22):

UPDATE customers SET customer_id = 22 WHERE customer_id = 2;

--  Automatically updates orders.customer_id = 22.

-- Delete a restaurant (restaurant_id = 1, Pizza Place):

DELETE FROM restaurants WHERE restaurant_id = 1;

-- Automatically deletes all orders linked to Pizza Place.



## Example 

-- Real-World Example: Food Delivery

/*We have three main tables:

    Customers (parent table) → users who place orders
    Example: Alice, Bob

    Restaurants (parent table) → where food comes from
    Example: Pizza Place, Burger House

    Orders (child table) → records of orders placed by customers at restaurants
    Example: Alice ordered Pizza from Pizza Place on Sep 1 */
# must delete/update manually 
/* 
Without CASCADE

If you try to delete Alice (customer) while she still has orders in the system →  Error: Database won’t allow it, because orders would be left “hanging” without a customer.
If you try to delete Pizza Place (restaurant) →  Error: Orders linked to Pizza Place still exist.
If you want to delete them, you must manually delete orders first, then delete Alice or the restaurant.

ou cannot delete your account until you cancel all your pending orders. */

/* With CASCADE

If you delete Alice (customer) → All her orders are automatically deleted too.

If you delete Pizza Place (restaurant) → All orders from Pizza Place are deleted.

If you update a customer_id or restaurant_id →  Orders update automatically to keep consistency.

If you delete your account, we’ll also erase all your past orders for you.”*/



