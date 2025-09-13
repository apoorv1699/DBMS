# Transaction Control Language (TCL)

-- COMMIT

Permanently saves changes made in the current transaction.

COMMIT;

-- ROLLBACK

Undoes all changes in the current transaction (back to the last START TRANSACTION).

ROLLBACK;

-- SAVEPOINT

Sets a "checkpoint" in the transaction.

SAVEPOINT sp1;

-- ROLLBACK TO SAVEPOINT

Reverts back to a specific savepoint.

RELEASE SAVEPOINT sp1;



-- DCL Commands (GRANT/REVOKE/GRANT OPTION)

# The GRANT command is used to give specific privileges to a user or role on a particular dat
abase object (e.g., a table, view, or stored procedure).

  --  GRANT → Gives privileges to a user.

  --  REVOKE → Removes privileges from a user.

GRANT privilege_name [, privilege_name ...]
ON object_name
TO user_name [, user_name ...]
[WITH GRANT OPTION];

privilege_name: The specific action you want to allow. Common privileges include:

    SELECT: Allows a user to read data from an object.

    INSERT: Allows a user to add new data.

    UPDATE: Allows a user to modify existing data.

    DELETE: Allows a user to delete data.

    ALL: Grants all available privileges.

    EXECUTE: Allows a user to execute a stored procedure or function.

object_name: The name of the database object to which you are granting the privileges.

user_name: The user or role to whom you are granting the privileges.

WITH GRANT OPTION: This is a crucial clause. If you include WITH GRANT OPTION, the user you are granting privileges to can, in turn, grant those same privileges to other users.

-- created a user 

CREATE USER 'test_user'@'localhost' IDENTIFIED BY 'testpassword';

CREATE DATABASE test_database;

USE test_database;

CREATE TABLE MyTable(data VARCHAR(255));

GRANT SELECT ON test_database.MyTable TO 'test_user'@'localhost';

SHOW GRANTS FOR 'test_user'@'localhost';

GRANT SELECT, UPDATE ON 
TABLE sample TO test_user;


-- multiple user 

GRANT SELECT, INSERT, UPDATE ON 
TABLE sample TO test_user1, test_user2, test_user3;


-- Database Level Privileges

GRANT SELECT, INSERT, UPDATE 
ON test.* TO 'test_user'@'localhost';

-- Column Level Privileges

CREATE TABLE Employee (
ID INT, Name VARCHAR(15), Phone INT, SAL INT);

/*Following query grants SELECT privilege to the user named 'test_user'@'localhost' on the ID column and INSERT and UPDATE privileges on the columns Name and Phone of the Employee table*/


GRANT SELECT (ID), INSERT (Name, Phone) 
ON Employee TO 'test_user'@'localhost';


GRANT SELECT, INSERT ON mydb.* TO 'user1'@'localhost';

GRANT SELECT, INSERT, UPDATE ON mydb.* TO 'alice'@'localhost';



-- REVOKE

Takes back privileges from a user.

REVOKE INSERT ON mydb.* FROM 'user1'@'localhost';

REVOKE INSERT, UPDATE ON mydb.* FROM 'alice'@'localhost';

# with GRANT OPTION

Allows a user to pass on privileges to others.

GRANT SELECT ON mydb.* TO 'bob'@'localhost' WITH GRANT OPTION;

-- Bob can now grant SELECT to another user.

--  Global level → Applies to all databases.
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost';

-- Database level → Applies to all tables in a database.
GRANT ALL PRIVILEGES ON sales.* TO 'manager'@'localhost';


--Table level → Specific table.
GRANT SELECT, INSERT ON sales.orders TO 'staff'@'localhost';


-- Column level → Specific columns in a table.
GRANT SELECT(order_id, customer_id) ON sales.orders TO 'auditor'@'localhost';


/*
WITH GRANT OPTION is a clause used with the GRANT 
command in SQL that gives a user or role the authority 
to pass on the privileges they've received to other users. 
It's a key part of Data Control Language (DCL) 
and is used to delegate a user's permission management.
*/

-- A database administrator (DBA) wants to give a team lead (lead_dev) the power to manage access to the projects table for their team.

GRANT SELECT, INSERT ON projects TO lead_dev WITH GRANT OPTION;

-- lead_dev can now SELECT and INSERT data into the projects table.

-- Crucially, they can also grant these same SELECT and INSERT privileges to other users.

# lead_dev then wants to give a junior developer (junior_dev) the ability to view and add project data.

-- This command is run by lead_dev, not the DBA
GRANT SELECT, INSERT ON projects TO junior_dev;

--junior_dev can now SELECT and INSERT data.

-- However, because lead_dev did not include WITH GRANT OPTION in their command, junior_dev cannot pass these privileges on to anyone else.

REVOKE SELECT, INSERT ON projects FROM lead_dev;

## ACID Properties

CREATE TABLE accounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    balance DECIMAL(10,2) CHECK (balance >= 0)   -- ensures Consistency
) ENGINE=InnoDB;   -- InnoDB is required for ACID

INSERT INTO accounts (name, balance) VALUES
('Alice', 1000.00),
('Bob',   500.00);


/*
ACID ensures reliable processing of database transactions.

A – Atomicity

Definition: A transaction must be all or nothing. 
Either every step completes successfully, 
or the whole transaction is rolled back.

Example:
Imagine transferring $500 from Alice’s bank account to Bob’s.

Step 1: Deduct $500 from Alice.
Step 2: Add $500 to Bob.
        If Step 1 succeeds but Step 2 fails (say, system crash), the 
        transaction should roll back, so Alice doesn’t lose money 
        without Bob receiving it.
*/

START TRANSACTION;

-- Step 1: Deduct $200 from Alice
UPDATE accounts SET balance = balance - 200 WHERE name = 'Alice';

-- Step 2: Add $200 to Bob
UPDATE accounts SET balance = balance + 200 WHERE name = 'Bob';

-- Step 3: Commit transaction
COMMIT;

-- 👉 If both succeed → COMMIT
-- 👉 If any fails (e.g., negative balance, error) → ROLLBACK

[-- If Step 2 fails (e.g., system crash), Step 1 is rolled back automatically → Atomicity.
-- Step 3: Try to add $300 to Bob (but introduce an error)
UPDATE accounts SET balance = balance + 300 WHERE name = 'Bobby';  
-- ❌ This will fail because 'Bobby' doesn’t exist
-- Transaction is now in an error state

-- Step 4: Rollback everything
ROLLBACK;

-- Step 5: Check balances (Alice’s money should be restored)
SELECT * FROM accounts;]

/*
C – Consistency

Definition: A transaction must take the database from one valid state to 
another valid state, preserving rules, constraints, and data integrity.

Example:
Suppose Alice has $1000. If the bank rule is that account balance can’t go negative, 
then transferring $1500 must fail.
This ensures the database remains in a consistent state 
(no negative balance).
*/

SELECT SUM(balance) AS total_balance FROM accounts;
/*
    Before transfer → 1500
    After transfer → 1500
    → Total money in system remains same → Consistency.
    Also, the CHECK (balance >= 0) prevents overdrafts.
*/

/*
I – Isolation

Definition: Multiple transactions running at 
the same time must not interfere with each other. 
Each should behave as if it’s the only one executing.

Example:

Alice transfers $500 to Bob.

    At the same time, Bob checks his balance.
    Bob should either see the balance before the 
    transfer or after the transfer, 
    but not a halfway state where Alice’s money 
    is deducted but not yet credited to Bob.

*/
--Session A:
START TRANSACTION;
UPDATE accounts SET balance = balance - 100 WHERE name = 'Alice';
-- (not committed yet)

--Session B (while A is open):
SELECT * FROM accounts WHERE name = 'Alice';
    /*
    At REPEATABLE READ (default): Session B still sees Alice’s old balance until Session A commits.

    This prevents dirty reads → Isolation.
    */

/*
D – Durability

Definition: Once a transaction is committed, 
the data should be permanently saved, 
even if the system crashes right after.

Example:
If Alice transfers $500 to Bob and the bank confirms 
the transfer, the change must remain in the database—even 
if there’s a sudden power failure or system restart.

START TRANSACTION;
UPDATE accounts SET balance = balance + 200 WHERE id = 2;
COMMIT;

    Run a transaction and COMMIT;.
    Simulate crash (e.g., kill MySQL process). (Even if MySQL crashes right now, Bob’s balance increase is permanently saved because of redo logs in InnoDB.)
    Restart MySQL.
    Data is still there because InnoDB Redo Logs replay committed changes.

*/

Real-Time Scenario (Banking Transaction)

    Alice sends $500 to Bob.
    Atomicity: Either both debit and credit happen, or neither.
    Consistency: Total money in the system remains the same.
    Isolation: Other people checking balances don’t see partial updates.
    Durability: Once transfer is done, it remains forever in the database.



# Schema

The schema defines the logical design of the database. its the unchanging framework that defines how data is organized.
It is the static, unchanging structure that dictates how data is organized. 
Think of it as the rules and framework for the database.

    Tables: The names of the tables in the database.
    Columns: The names of the columns within each table.
    Data types: The type of data each column can hold (e.g., INTEGER, VARCHAR, DATE).
    Relationships: The relationships between different tables, often defined by primary and foreign keys.
    Constraints: Rules that govern the data, such as NOT NULL, UNIQUE, and CHECK constraints.

# Instance

The instance is the actual content of the database at a specific point in time.
It is the dynamic data that lives within the structure defined by the schema. 
Think of it as the current state or snapshot of the database.

    The instance includes all the rows and values in the databases tables.
    Example: Using the students schema from above, an instance would be the actual data in the table:

    | student_id | name | major |
    | 1 | Alice | Computer Science |
    | 2 | Bob | Physics |
    | 3 | Charlie | Biology |

This instance is what changes every time a student is added, 
deleted, or has their information updated. 
These changes are made using Data Manipulation Language (DML) commands 
like INSERT, UPDATE, and DELETE. The database can have many different instances over time, 
but it only has one schema.    



# MySQL Storage Engines (InnoDB, MyISAM and others),

InnoDB
InnoDB is the default and most widely used storage engine for MySQL since version 5.5. 
Its a transactional engine, making it suitable for high-concurrency, high-traffic applications 
that require data integrity.

Key Features:

/*
Transactions (ACID Compliance): Guarantees that database operations are reliable and processed as a single, atomic unit. This is crucial for applications like financial systems.
Row-Level Locking: Locks individual rows instead of entire tables during writes. This significantly increases concurrency and performance, as multiple users can write to different rows in the same table simultaneously.
Foreign Key Support: Enforces referential integrity between tables, ensuring that relationships between data remain consistent.
Crash Recovery: Uses a transaction log to automatically recover the database to a consistent state after a crash or power failure.
*/

MyISAM
MyISAM was the default storage engine before MySQL 5.5. 
It is non-transactional and designed for read-heavy applications 
where speed is more important than transactional integrity.

Key Features:

/*
Table-Level Locking: Locks the entire table during write operations. This is a major drawback for high-concurrency environments, as it can cause a "bottleneck" where users have to wait for the whole table to be unlocked.
No Transactions: Lacks ACID compliance, meaning that data integrity is not guaranteed in the event of a crash.
Fast Read Operations: MyISAM is often faster for read-only operations because of its simpler structure and lack of transactional overhead.
Full-Text Search: Provides built-in support for full-text indexing, making it a good choice for search-heavy applications.
*/

Memory: Stores all data in RAM. Its extremely fast for read operations but loses all data when the MySQL server is restarted. Best for temporary, session-specific, or read-only caches.
CSV: Stores tables as plain text CSV files. Data can be manipulated from outside the MySQL server using spreadsheet software. Its useful for importing or exporting data but lacks indexing and is not suitable for complex queries.
Archive: Optimized for high-speed insertion of data and compression. Its used for storing historical data that is rarely accessed, as it does not support UPDATE or DELETE operations.