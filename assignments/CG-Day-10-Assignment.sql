CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product VARCHAR(50),
    category VARCHAR(50),
    units_sold INT,
    unit_price INT,
    region VARCHAR(50)
);


INSERT INTO sales
(sale_id, product, category, units_sold, unit_price, region)
VALUES
(1, 'Keyboard', 'Electronics', 10, 1200, 'North'),
(2, 'Monitor', 'Electronics', 5, 7000, 'South'),
(3, 'Chair', 'Furniture', 15, 2500, 'North'),
(4, 'Desk', 'Furniture', 7, 4500, 'West'),
(5, 'Mouse', 'Electronics', 20, 800, 'East'),
(6, 'Sofa', 'Furniture', 3, 15000, 'South'),
(7, 'Headphones', 'Electronics', 8, 1800, 'North'),
(8, 'Laptop', 'Electronics', 6, 55000, 'West'),
(9, 'Table', 'Furniture', 12, 6000, 'East'),
(10, 'Fan', 'HomeAppliance', 18, 3000, 'South'),
(11, 'AC', 'HomeAppliance', 4, 35000, 'North'),
(12, 'Cupboard', 'Furniture', 5, 12000, 'West'),
(13, 'Printer', 'Electronics', 9, 9000, 'East'),
(14, 'Bed', 'Furniture', 2, 25000, 'South'),
(15, 'Mobile', 'Electronics', 14, 20000, 'North');




SELECT * FROM sales;





-- ==========================================
-- TOPIC 1: WHERE CLAUSE
-- ==========================================

-- Q1. Electronics products
SELECT *
FROM sales
WHERE category = 'Electronics';

-- Q2. Unit price greater than 10000
SELECT *
FROM sales
WHERE unit_price > 10000;

-- Q3. Products sold in North region
SELECT *
FROM sales
WHERE region = 'North';

-- Q4. Units sold between 5 and 15
SELECT *
FROM sales
WHERE units_sold BETWEEN 5 AND 15;

-- Q5. Furniture products with price greater than 5000
SELECT *
FROM sales
WHERE category = 'Furniture'
AND unit_price > 5000;


-- ==========================================
-- TOPIC 2: GROUP BY + HAVING
-- ==========================================

-- Q6. Total units per category greater than 20
SELECT category, SUM(units_sold) AS total_units
FROM sales
GROUP BY category
HAVING SUM(units_sold) > 20;

-- Q7. Total revenue per region greater than 50000
SELECT region,
SUM(units_sold * unit_price) AS total_revenue
FROM sales
GROUP BY region
HAVING SUM(units_sold * unit_price) > 50000;

-- Q8. Categories having more than 2 products
SELECT category, COUNT(*) AS product_count
FROM sales
GROUP BY category
HAVING COUNT(*) > 2;

-- Q9. Average price per category less than 5000
SELECT category, AVG(unit_price) AS average_price
FROM sales
GROUP BY category
HAVING AVG(unit_price) < 5000;

-- Q10. Regions having more than 1 Electronics product
SELECT region, COUNT(*) AS electronics_count
FROM sales
WHERE category = 'Electronics'
GROUP BY region
HAVING COUNT(*) > 1;


-- ==========================================
-- TOPIC 3: GROUP BY + ORDER BY
-- ==========================================

-- Q11. Total units per category in descending order
SELECT category, SUM(units_sold) AS total_units
FROM sales
GROUP BY category
ORDER BY total_units DESC;

-- Q12. Average price per region alphabetically
SELECT region, AVG(unit_price) AS average_price
FROM sales
GROUP BY region
ORDER BY region ASC;

-- Q13. Total revenue per category, highest first
SELECT category,
SUM(units_sold * unit_price) AS total_revenue
FROM sales
GROUP BY category
ORDER BY total_revenue DESC;

-- Q14. Product count per region in descending order
SELECT region, COUNT(*) AS product_count
FROM sales
GROUP BY region
ORDER BY product_count DESC;

-- Q15. Total units per region, sorted by region
SELECT region, SUM(units_sold) AS total_units
FROM sales
GROUP BY region
ORDER BY region ASC;


-- ==========================================
-- TOPIC 4: GROUP BY + HAVING + ORDER BY
-- ==========================================

-- Q16. Revenue per region greater than 20000
SELECT region,
SUM(units_sold * unit_price) AS total_revenue
FROM sales
GROUP BY region
HAVING SUM(units_sold * unit_price) > 20000
ORDER BY total_revenue DESC;

-- Q17. Categories with total units greater than 10
SELECT category, SUM(units_sold) AS total_units
FROM sales
GROUP BY category
HAVING SUM(units_sold) > 10
ORDER BY category ASC;

-- Q18. Regions having more than 1 product
SELECT region, COUNT(*) AS product_count
FROM sales
GROUP BY region
HAVING COUNT(*) > 1
ORDER BY region ASC;

-- Q19. Average price per category less than 6000
SELECT category, AVG(unit_price) AS average_price
FROM sales
GROUP BY category
HAVING AVG(unit_price) < 6000
ORDER BY average_price ASC;

-- Q20. Average units sold per category greater than 5
SELECT category, AVG(units_sold) AS average_units
FROM sales
GROUP BY category
HAVING AVG(units_sold) > 5
ORDER BY average_units DESC;


-- ==========================================
-- TOPIC 5: WHERE + GROUP BY + HAVING + ORDER BY
-- ==========================================

-- Q21. Electronics units per region greater than 15
SELECT region, SUM(units_sold) AS total_units
FROM sales
WHERE category = 'Electronics'
GROUP BY region
HAVING SUM(units_sold) > 15
ORDER BY total_units DESC;

-- Q22. Revenue per category for products above 2000
SELECT category,
SUM(units_sold * unit_price) AS total_revenue
FROM sales
WHERE unit_price > 2000
GROUP BY category
HAVING SUM(units_sold * unit_price) > 100000
ORDER BY total_revenue DESC;

-- Q23. Average price per region for units sold >= 5
SELECT region, AVG(unit_price) AS average_price
FROM sales
WHERE units_sold >= 5
GROUP BY region
HAVING AVG(unit_price) > 5000
ORDER BY region ASC;

-- Q24. Product count per category in North and South
SELECT category, COUNT(*) AS product_count
FROM sales
WHERE region IN ('North', 'South')
GROUP BY category
HAVING COUNT(*) > 2
ORDER BY product_count DESC;

-- Q25. Revenue per region for products below 10000
SELECT region,
SUM(units_sold * unit_price) AS total_revenue
FROM sales
WHERE unit_price < 10000
GROUP BY region
HAVING SUM(units_sold * unit_price) > 50000
ORDER BY total_revenue DESC;


