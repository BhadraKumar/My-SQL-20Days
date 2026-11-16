CREATE TABLE Orders (
    id INT,
    customer_name VARCHAR(100),
    order_date DATE,
    total_amount DECIMAL(10,2)
);


INSERT INTO Orders VALUES
(1, 'Alice', '2024-03-01', 1500.00),
(2, 'Bob', '2024-03-05', 450.00),
(3, 'Charlie', '2024-03-10', 2500.00),
(4, 'Diana', '2024-03-15', 800.00),
(5, 'Eve', '2024-03-20', 1200.00),
(6, 'Frank', '2024-03-25', 3000.00),
(7, 'Grace', '2024-04-02', 1800.00),
(8, 'Henry', '2024-04-08', 950.00),
(9, 'Ivy', '2024-04-12', 2750.00),
(10, 'Jack', '2024-04-18', 650.00),
(11, 'Kevin', '2024-04-22', 4200.00),
(12, 'Lily', '2024-05-01', 1350.00),
(13, 'Michael', '2024-05-08', 5000.00),
(14, 'Nancy', '2024-05-15', 2250.00),
(15, 'Oliver', '2024-05-25', 900.00);

SELECT * FROM Orders;

-- Q6. Customer names whose order amount is between 2000 and 5000
SELECT customer_name
FROM Orders
WHERE total_amount BETWEEN 2000 AND 5000;

-- Q7. Orders placed between 2024-03-15 and 2024-04-15
SELECT *
FROM Orders
WHERE order_date BETWEEN '2024-03-15' AND '2024-04-15';

-- Q8. Orders whose amount is between 800 and 1800
SELECT *
FROM Orders
WHERE total_amount BETWEEN 800 AND 1800;

-- Q9. Orders placed between 2024-04-10 and 2024-05-10
SELECT *
FROM Orders
WHERE order_date BETWEEN '2024-04-10' AND '2024-05-10';

-- Q10. Orders whose amount is between 2500 and 5000
SELECT *
FROM Orders
WHERE total_amount BETWEEN 2500 AND 5000;


-- Q6. Reduce amount by 100 for orders placed between March 15 and March 31
UPDATE Orders
SET total_amount = total_amount - 100
WHERE order_date BETWEEN '2024-03-15' AND '2024-03-31';

-- Q7. Increase amount by 750 for orders between 800 and 1500
UPDATE Orders
SET total_amount = total_amount + 750
WHERE total_amount BETWEEN 800 AND 1500;

-- Q8. Reduce amount by 500 for orders between 3000 and 5000
UPDATE Orders
SET total_amount = total_amount - 500
WHERE total_amount BETWEEN 3000 AND 5000;

-- Q9. Increase amount by 250 for orders placed between April 20 and May 10
UPDATE Orders
SET total_amount = total_amount + 250
WHERE order_date BETWEEN '2024-04-20' AND '2024-05-10';

-- Q10. Add 100 to orders placed between March 1 and May 31
UPDATE Orders
SET total_amount = total_amount + 100
WHERE order_date BETWEEN '2024-03-01' AND '2024-05-31';



-- Q6. Delete orders whose amount is between 1000 and 2000
DELETE FROM Orders
WHERE total_amount BETWEEN 1000 AND 2000;

-- Q7. Delete orders placed between March 1 and March 5
DELETE FROM Orders
WHERE order_date BETWEEN '2024-03-01' AND '2024-03-05';

-- Q8. Delete orders placed between April 18 and May 8
DELETE FROM Orders
WHERE order_date BETWEEN '2024-04-18' AND '2024-05-08';

-- Q9. Delete orders whose amount is between 1800 and 3000
DELETE FROM Orders
WHERE total_amount BETWEEN 1800 AND 3000;

-- Q10. Delete orders placed between March 25 and April 8
DELETE FROM Orders
WHERE order_date BETWEEN '2024-03-25' AND '2024-04-08';




CREATE TABLE Emp (
    id INT,
    name VARCHAR(100),
    dept VARCHAR(20),
    salary INT
);

INSERT INTO Emp VALUES
(1, 'Rahul', 'IT', 50000),
(2, 'Ramesh', 'HR', 35000),
(3, 'Karan', 'Finance', 45000),
(4, 'Mahesh', 'Marketing', 40000),
(5, 'Suresh', 'IT', 55000),
(6, 'Arjun', 'Sales', 38000),
(7, 'Manish', 'Admin', 42000),
(8, 'Ganesh', 'Finance', 47000),
(9, 'Naresh', 'HR', 39000),
(10, 'Rohan', 'IT', 52000),
(11, 'Mohan', 'Sales', 41000),
(12, 'Kishan', 'Marketing', 43000),
(13, 'Dinesh', 'Admin', 46000),
(14, 'Rajesh', 'Finance', 51000),
(15, 'Kiran', 'IT', 48000);


SELECT * FROM Emp;

-- Q6. Display employees from Sales, Marketing, and Finance departments
SELECT *
FROM Emp
WHERE dept IN ('Sales', 'Marketing', 'Finance');

-- Q7. Display employees from Admin department
SELECT *
FROM Emp
WHERE dept IN ('Admin');

-- Q8. Display employees whose salary is 39000, 43000, or 52000
SELECT *
FROM Emp
WHERE salary IN (39000, 43000, 52000);

-- Q9. Display employees from IT, Admin, and Sales departments
SELECT *
FROM Emp
WHERE dept IN ('IT', 'Admin', 'Sales');

-- Q10. Display employees whose salary is 40000, 45000, or 50000
SELECT *
FROM Emp
WHERE salary IN (40000, 45000, 50000);


-- Q6. Increase salary by 2500 for employees earning 45000, 48000, or 52000
UPDATE Emp
SET salary = salary + 2500
WHERE salary IN (45000, 48000, 52000);

-- Q7. Increase salary by 4000 for employees in Admin department
UPDATE Emp
SET salary = salary + 4000
WHERE dept IN ('Admin');

-- Q8. Increase salary by 3500 for employees in Marketing and Finance departments
UPDATE Emp
SET salary = salary + 3500
WHERE dept IN ('Marketing', 'Finance');

-- Q9. Increase salary by 500 for employees earning 40000, 41000, or 42000
UPDATE Emp
SET salary = salary + 500
WHERE salary IN (40000, 41000, 42000);

-- Q10. Increase salary by 2000 for employees in IT, Sales, and Admin departments
UPDATE Emp
SET salary = salary + 2000
WHERE dept IN ('IT', 'Sales', 'Admin');


-- Q6. Delete employees whose salary is 45000, 50000, or 55000
DELETE FROM Emp
WHERE salary IN (45000, 50000, 55000);

-- Q7. Delete employees from Marketing and HR departments
DELETE FROM Emp
WHERE dept IN ('Marketing', 'HR');

-- Q8. Delete employees from Admin department
DELETE FROM Emp
WHERE dept IN ('Admin');

-- Q9. Delete employees whose salary is 37000, 38000, or 41000
DELETE FROM Emp
WHERE salary IN (37000, 38000, 41000);

-- Q10. Delete employees from IT, Finance, and Sales departments
DELETE FROM Emp
WHERE dept IN ('IT', 'Finance', 'Sales');



SELECT *
FROM Emp
WHERE dept IN ('IT', 'HR');

SELECT *
FROM Emp
WHERE dept = 'IT'
   OR dept = 'HR';
   
   
   
   
   CREATE TABLE Emp (
    id INT,
    name VARCHAR(100),
    dept VARCHAR(20),
    salary INT
);

INSERT INTO Emp VALUES
(1, 'Rahul', 'IT', 50000),
(2, 'Ramesh', 'HR', 35000),
(3, 'Karan', 'Finance', 45000),
(4, 'Mahesh', 'Marketing', 40000),
(5, 'Suresh', 'IT', 55000),
(6, 'Arjun', 'Sales', 38000),
(7, 'Manish', 'Admin', 42000),
(8, 'Ganesh', 'Finance', 47000),
(9, 'Naresh', 'HR', 39000),
(10, 'Rohan', 'IT', 52000),
(11, 'Mohan', 'Sales', 41000),
(12, 'Kishan', 'Marketing', 43000),
(13, 'Dinesh', 'Admin', 46000),
(14, 'Rajesh', 'Finance', 51000),
(15, 'Kiran', 'IT', 48000);

SELECT * FROM Emp;


-- Q6. Display employees whose names have 'a' as the second character
SELECT *
FROM Emp
WHERE name LIKE '_a%';

-- Q7. Display employees whose names contain 'es'
SELECT *
FROM Emp
WHERE name LIKE '%es%';

-- Q8. Display employees whose names end with 'n'
SELECT *
FROM Emp
WHERE name LIKE '%n';

-- Q9. Display employees whose names start with 'M' and contain 'e'
SELECT *
FROM Emp
WHERE name LIKE 'M%e%';

-- Q10. Display employees whose names have exactly 6 characters and end with 'h'
SELECT *
FROM Emp
WHERE name LIKE '_____h';

-- Q11. Display employees whose names start with 'A'
SELECT *
FROM Emp
WHERE name LIKE 'A%';

-- Q12. Display employees whose names end with 'an'
SELECT *
FROM Emp
WHERE name LIKE '%an';

-- Q13. Display employees whose names contain 'oh'
SELECT *
FROM Emp
WHERE name LIKE '%oh%';

-- Q14. Display employees whose names have exactly 7 characters
SELECT *
FROM Emp
WHERE name LIKE '_______';

-- Q15. Display employees whose names start with 'S'
SELECT *
FROM Emp
WHERE name LIKE 'S%';


-- Q6. Increase salary by 1500 for employees whose names have 'a' as the second character
UPDATE Emp
SET salary = salary + 1500
WHERE name LIKE '_a%';

-- Q7. Increase salary by 4000 for employees whose names contain 'es'
UPDATE Emp
SET salary = salary + 4000
WHERE name LIKE '%es%';

-- Q8. Increase salary by 1000 for employees whose names end with 'n'
UPDATE Emp
SET salary = salary + 1000
WHERE name LIKE '%n';

-- Q9. Increase salary by 5000 for employees whose names start with 'M' and contain 'e'
UPDATE Emp
SET salary = salary + 5000
WHERE name LIKE 'M%e%';

-- Q10. Increase salary by 2000 for employees whose names have exactly 6 characters and end with 'h'
UPDATE Emp
SET salary = salary + 2000
WHERE name LIKE '_____h';



-- Q6. Delete employees whose names have 'a' as the second character
DELETE FROM Emp
WHERE name LIKE '_a%';

-- Q7. Delete employees whose names contain 'es'
DELETE FROM Emp
WHERE name LIKE '%es%';

-- Q8. Delete employees whose names end with 'n'
DELETE FROM Emp
WHERE name LIKE '%n';

-- Q9. Delete employees whose names start with 'M' and contain 'e'
DELETE FROM Emp
WHERE name LIKE 'M%e%';

-- Q10. Delete employees whose names have exactly 6 characters and end with 'h'
DELETE FROM Emp
WHERE name LIKE '_____h';



CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(30),
    salary DECIMAL(10,2),
    experience INT,
    age INT
);


INSERT INTO employees VALUES
(101, 'Ravi', 'IT', 65000, 5, 28),
(102, 'Priya', 'HR', 45000, 2, 24),
(103, 'Amit', 'Finance', 75000, 8, 35),
(104, 'Sneha', 'IT', 55000, 3, 27),
(105, 'Rahul', 'Sales', 40000, 1, 22),
(106, 'Kiran', 'Finance', 90000, 12, 40),
(107, 'Anjali', 'HR', 52000, 4, 29),
(108, 'Suresh', 'Sales', 68000, 7, 33);


SELECT * FROM employees;

SELECT
    emp_name,
    department,
    salary,
    CASE
        WHEN department = 'IT' THEN salary * 0.20
        WHEN department = 'Finance' THEN salary * 0.15
        WHEN department = 'HR' THEN salary * 0.10
        ELSE salary * 0.05
    END AS bonus
FROM employees;


SELECT
    emp_name,
    age,
    CASE
        WHEN age >= 18 THEN 'Eligible'
        ELSE 'Not Eligible'
    END AS voting_status
FROM employees;



SELECT
    emp_name,
    salary,
    CASE
        WHEN salary >= 80000 THEN 'Grade A'
        WHEN salary >= 60000 THEN 'Grade B'
        WHEN salary >= 50000 THEN 'Grade C'
        ELSE 'Grade D'
    END AS grade
FROM employees;


SELECT *
FROM employees
ORDER BY
    CASE
        WHEN department = 'IT' THEN 0
        ELSE 1
    END;
    
    
    
    UPDATE employees
SET salary =
    CASE
        WHEN experience >= 10 THEN salary + 10000
        WHEN experience >= 5 THEN salary + 5000
        ELSE salary + 2000
    END;
    
    
    
    SELECT
    SUM(
        CASE
            WHEN department = 'IT' THEN salary
            ELSE 0
        END
    ) AS total_IT_salary
FROM employees;









