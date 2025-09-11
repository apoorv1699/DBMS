use task;

SELECT customer_id, COUNT(order_id) AS total_orders
FROM Orders
GROUP BY customer_id;

SELECT department_id, AVG(salary) AS avg_salary
FROM Employees
GROUP BY department_id;

SELECT employee_id, SUM(amount) AS total_sales
FROM Sales
WHERE YEAR(sale_date) = 2024
GROUP BY employee_id;

SELECT order_status, COUNT(*) AS status_count
FROM Orders
GROUP BY order_status
ORDER BY status_count DESC
LIMIT 3;

SELECT department_id, AVG(salary) AS avg_salary
FROM Employees
GROUP BY department_id
HAVING AVG(salary) > 50000;

SELECT category, MAX(price) AS max_price
FROM Products
GROUP BY category;

SELECT class, SUM(marks) AS total_marks
FROM Students
GROUP BY class;

SELECT department, COUNT(*) AS employee_count
FROM Employees
WHERE salary > 60000
GROUP BY department;

SELECT customer_id, COUNT(order_id) AS total_orders
FROM Orders
WHERE YEAR(order_date) = 2024
GROUP BY customer_id
HAVING COUNT(order_id) > 5;


SELECT candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(DISTINCT skill) = 3
ORDER BY candidate_id;

SELECT u.city, COUNT(t.order_id) AS total_orders
FROM trades t
JOIN users u ON t.user_id = u.user_id
WHERE t.status = 'Completed'
GROUP BY u.city
ORDER BY total_orders DESC
LIMIT 3;
