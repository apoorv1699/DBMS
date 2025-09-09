-- Q1: Create a Student Table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Age INT CHECK (Age BETWEEN 18 AND 30),
    City VARCHAR(50) DEFAULT 'Delhi'
);

-- Q2: Insert Data with Default
INSERT INTO Students (StudentID, Name, Age)
VALUES (1, 'Rahul Sharma', 22);

-- Q3: Create Employee Table with Salary Validation
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100) NOT NULL,
    Salary DECIMAL(10,2) CHECK (Salary > 5000),
    Department VARCHAR(50) DEFAULT 'HR'
);

-- Q4: Insert Invalid Salary (This will fail)
INSERT INTO Employees (EmpID, EmpName, Salary)
VALUES (101, 'Amit Verma', 4000);

-- Q5: Product Table with Stock Constraint
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) DEFAULT 100,
    Stock INT CHECK (Stock >= 0)
);

-- Q6: Insert with Constraint Violation (This will fail)
INSERT INTO Products (ProductID, ProductName, Stock)
VALUES (1, 'Laptop', -5);

-- Q7: Update with a Default Value
UPDATE Products
SET Price = 100
WHERE Price IS NULL;

-- Q8: Deleting with a Constraint
DELETE FROM Students
WHERE Age = 25;

-- Q9: Update Violating CHECK Constraint (This will fail)
UPDATE Employees
SET Salary = 3000
WHERE EmpID = 101;

-- Q10: Insert Into NOT NULL Column (This will fail)
INSERT INTO Students (StudentID, Age, City)
VALUES (2, 20, 'Mumbai');

-- Q11: Set Default with UPDATE
UPDATE Employees
SET Department = 'HR';

-- Q12: Delete All Products with Default Price
DELETE FROM Products
WHERE Price = 100;

-- Q13: Multi-Column CHECK Constraint
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    Amount DECIMAL(10,2) CHECK (Amount > 0),
    Discount DECIMAL(10,2),
    CustomerName VARCHAR(100) NOT NULL,
    CHECK (Discount < Amount)
);
