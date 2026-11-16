

CREATE DATABASE IF NOT EXISTS SQL_STRING_DATE_FUNCTIONS;
USE SQL_STRING_DATE_FUNCTIONS;


-- =====================================================
-- PART 1: STRING FUNCTIONS
-- =====================================================

-- Step 1: Create employees table

DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    email VARCHAR(60),
    phone_number VARCHAR(20),
    department VARCHAR(30),
    city VARCHAR(30),
    salary DECIMAL(10,2)
);


-- Step 2: Insert records

INSERT INTO employees VALUES
(101,'Rahul','Kumar','rahul.kumar@gmail.com','987-654-3210','IT','Hyderabad',45000),
(102,'Anita','Sharma','anita.sharma@yahoo.com','912-345-6789','HR','Bangalore',38000),
(103,'Suresh','Verma','suresh.verma@gmail.com','998-123-4567','Sales','Chennai',52000),
(104,'Priya','Singh','priya.singh@outlook.com','900-456-7890','Finance','Pune',47000),
(105,'Rahul','Joshi','rahul.joshi@gmail.com','955-888-1111','Testing','Delhi',41000),
(106,'Kiran','Reddy','kiran.reddy@gmail.com','901-222-3333','IT','Hyderabad',56000),
(107,'Deepika','Naidu','deepika.naidu@yahoo.com','944-111-2222','HR','Vizag',39000),
(108,'Mahesh','Patel','mahesh.patel@gmail.com','933-444-5555','Sales','Mumbai',62000),
(109,'Divya','Gupta','divya.gupta@gmail.com','955-777-8888','Finance','Delhi',49000),
(110,'Arjun','Rao','arjun.rao@gmail.com','988-999-7777','Developer','Hyderabad',68000);


-- Step 3: Display all records

SELECT * FROM employees;


-- =====================================================
-- STRING FUNCTIONS: 20 PRACTICE QUESTIONS
-- =====================================================

-- Q1. Find employees whose first_name starts with 'R'.

SELECT * FROM employees
WHERE first_name LIKE 'R%';


-- Q2. Find employees whose email contains 'yahoo'.

SELECT * FROM employees
WHERE email LIKE '%yahoo%';


-- Q3. Display full name along with department as a single string.

SELECT CONCAT(first_name, ' ', last_name, ' - ', department) AS employee_details
FROM employees;


-- Q4. Find the length of every email address.

SELECT email, CHAR_LENGTH(email) AS email_length
FROM employees;


-- Q5. Find employees whose first_name has more than 5 characters.

SELECT * FROM employees
WHERE CHAR_LENGTH(first_name) > 5;


-- Q6. Replace 'gmail.com' with 'company.com' in email.

SELECT email,
       REPLACE(email, 'gmail.com', 'company.com') AS updated_email
FROM employees;


-- Q7. Find the position of the '@' symbol in email.

SELECT email,
       LOCATE('@', email) AS at_position
FROM employees;


-- Q8. Extract the username part of email (before '@').

SELECT email,
       SUBSTRING_INDEX(email, '@', 1) AS username
FROM employees;


-- Q9. Extract the domain part of email (after '@').

SELECT email,
       SUBSTRING_INDEX(email, '@', -1) AS domain_name
FROM employees;


-- Q10. Find employees whose last_name ends with 'a'.

SELECT * FROM employees
WHERE last_name LIKE '%a';


-- Q11. Display full name in uppercase for employees in the IT department.

SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS full_name
FROM employees
WHERE department = 'IT';


-- Q12. Find first names that are duplicated among employees.

SELECT first_name, COUNT(*) AS duplicate_count
FROM employees
GROUP BY first_name
HAVING COUNT(*) > 1;


-- Q13. Format phone numbers by removing all dashes.

SELECT phone_number,
       REPLACE(phone_number, '-', '') AS formatted_phone
FROM employees;


-- Q14. Find employees whose first_name contains the letter 'i'.

SELECT * FROM employees
WHERE first_name LIKE '%i%';


-- Q15. Sort employees by the length of their first_name.

SELECT first_name,
       CHAR_LENGTH(first_name) AS name_length
FROM employees
ORDER BY name_length ASC;


-- Q16. Find employees whose city name has more than 6 characters.

SELECT * FROM employees
WHERE CHAR_LENGTH(city) > 6;


-- Q17. Build a formatted string "Name - Department" for every employee.

SELECT CONCAT(first_name, ' ', last_name, ' - ', department) AS employee_info
FROM employees;


-- Q18. Display the initials of each employee.

SELECT CONCAT(LEFT(first_name, 1), LEFT(last_name, 1)) AS initials
FROM employees;


-- Q19. Remove leading and trailing spaces from employee names.

SELECT CONCAT(TRIM(first_name), ' ', TRIM(last_name)) AS cleaned_name
FROM employees;


-- Q20. Display the first three characters of every employee's first_name.

SELECT first_name,
       LEFT(first_name, 3) AS first_three_characters
FROM employees;



-- =====================================================
-- PART 2: DATE AND TIME FUNCTIONS
-- =====================================================

-- Step 1: Create employee_attendance table

DROP TABLE IF EXISTS employee_attendance;

CREATE TABLE employee_attendance (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(100),
    department VARCHAR(50),
    joining_date DATE,
    birth_date DATE,
    login_time DATETIME,
    logout_time DATETIME,
    salary DECIMAL(10,2)
);


-- Step 2: Insert records

INSERT INTO employee_attendance
(emp_name, department, joining_date, birth_date, login_time, logout_time, salary)
VALUES
('Rahul','IT','2021-06-15','1998-05-10','2024-11-20 09:05:10','2024-11-20 18:15:30',55000),
('Sneha','HR','2020-03-21','1996-11-18','2024-11-21 08:55:20','2024-11-21 17:45:50',48000),
('Arjun','Finance','2019-08-10','1994-07-30','2024-11-22 09:15:45','2024-11-22 18:35:20',62000),
('Priya','IT','2022-01-05','2000-01-25','2024-11-23 09:00:00','2024-11-23 17:55:40',51000),
('Kiran','Admin','2018-12-11','1992-09-15','2024-11-24 08:40:30','2024-11-24 17:30:00',45000),
('Anjali','Testing','2023-04-17','1999-12-20','2024-11-25 09:12:10','2024-11-25 18:05:00',47000),
('Vijay','IT','2021-09-14','1997-04-08','2024-11-26 09:08:15','2024-11-26 18:20:40',59000),
('Divya','HR','2019-10-19','1995-06-11','2024-11-27 08:50:30','2024-11-27 17:42:15',50000),
('Ramesh','Finance','2017-07-01','1991-08-14','2024-11-28 09:03:00','2024-11-28 18:12:00',70000),
('Pooja','Testing','2022-05-09','2001-03-19','2024-11-29 09:18:50','2024-11-29 18:25:10',53000);


-- Step 3: Display all records

SELECT * FROM employee_attendance;


-- =====================================================
-- BASIC LEVEL: 15 DATE AND TIME QUESTIONS
-- =====================================================

-- Q1. Display only the date part from every employee's login time.

SELECT emp_name, DATE(login_time) AS login_date
FROM employee_attendance;


-- Q2. Display only the time part from every employee's login time.

SELECT emp_name, TIME(login_time) AS login_time_only
FROM employee_attendance;


-- Q3. Display employee names along with their joining year.

SELECT emp_name, YEAR(joining_date) AS joining_year
FROM employee_attendance;


-- Q4. Display employee names along with their birth month number.

SELECT emp_name, MONTH(birth_date) AS birth_month
FROM employee_attendance;


-- Q5. Display employee names and day of birth.

SELECT emp_name, DAY(birth_date) AS birth_day
FROM employee_attendance;


-- Q6. Display the week number of every employee's joining date.

SELECT emp_name, WEEK(joining_date) AS week_number
FROM employee_attendance;


-- Q7. Display the weekday number of each employee's joining date.

SELECT emp_name, DAYOFWEEK(joining_date) AS weekday_number
FROM employee_attendance;


-- Q8. Add 30 days to every employee's joining date.

SELECT emp_name,
       joining_date,
       DATE_ADD(joining_date, INTERVAL 30 DAY) AS date_after_30_days
FROM employee_attendance;


-- Q9. Subtract 15 days from every employee's joining date.

SELECT emp_name,
       joining_date,
       DATE_SUB(joining_date, INTERVAL 15 DAY) AS date_before_15_days
FROM employee_attendance;


-- Q10. Find how many days each employee has worked from joining date until today.

SELECT emp_name,
       DATEDIFF(CURDATE(), joining_date) AS days_worked
FROM employee_attendance;


-- Q11. Find the number of days between login time and logout time.

SELECT emp_name,
       TIMESTAMPDIFF(SECOND, login_time, logout_time) / 86400 AS working_days
FROM employee_attendance;


-- Q12. Display the Unix timestamp of login_time.

SELECT emp_name,
       login_time,
       UNIX_TIMESTAMP(login_time) AS unix_timestamp
FROM employee_attendance;


-- Q13. Convert Unix timestamp 1700000000 into DateTime.

SELECT FROM_UNIXTIME(1700000000) AS converted_datetime;


-- Q14. Display the last day of each employee's joining month.

SELECT emp_name,
       LAST_DAY(joining_date) AS last_day_of_joining_month
FROM employee_attendance;


-- Q15. Display the month name and day name of every employee's birth date.

SELECT emp_name,
       MONTHNAME(birth_date) AS birth_month_name,
       DAYNAME(birth_date) AS birth_day_name
FROM employee_attendance;



-- =====================================================
-- ADVANCED LEVEL: 20 QUESTIONS
-- Filtering, Calculations and Formatting
-- =====================================================

-- Q1. Display employees who joined in the current year.

SELECT * FROM employee_attendance
WHERE YEAR(joining_date) = YEAR(CURDATE());


-- Q2. Display employees born in November.

SELECT * FROM employee_attendance
WHERE MONTH(birth_date) = 11;


-- Q3. Display employees whose joining month is June.

SELECT * FROM employee_attendance
WHERE MONTH(joining_date) = 6;


-- Q4. Display employees whose birthday falls on the 10th day.

SELECT * FROM employee_attendance
WHERE DAY(birth_date) = 10;


-- Q5. Display employees who joined in Quarter 2.

SELECT * FROM employee_attendance
WHERE QUARTER(joining_date) = 2;


-- Q6. Display employee names and their age in years using TIMESTAMPDIFF().

SELECT emp_name,
       TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS age
FROM employee_attendance;


-- Q7. Display employees who have completed more than 3 years in the company.

SELECT emp_name,
       joining_date,
       TIMESTAMPDIFF(YEAR, joining_date, CURDATE()) AS completed_years
FROM employee_attendance
WHERE TIMESTAMPDIFF(YEAR, joining_date, CURDATE()) > 3;


-- Q8. Display employee names and their total working hours.

SELECT emp_name,
       TIMESTAMPDIFF(MINUTE, login_time, logout_time) / 60 AS working_hours
FROM employee_attendance;


-- Q9. Display employee names and working minutes.

SELECT emp_name,
       TIMESTAMPDIFF(MINUTE, login_time, logout_time) AS working_minutes
FROM employee_attendance;


-- Q10. Display employees whose login time is before 9 AM.

SELECT * FROM employee_attendance
WHERE TIME(login_time) < '09:00:00';


-- Q11. Display employees who logged in after 9:10 AM.

SELECT * FROM employee_attendance
WHERE TIME(login_time) > '09:10:00';


-- Q12. Display employees whose joining date falls on Monday.

SELECT * FROM employee_attendance
WHERE DAYNAME(joining_date) = 'Monday';


-- Q13. Display employees whose birth month name starts with 'J'.

SELECT * FROM employee_attendance
WHERE LEFT(MONTHNAME(birth_date), 1) = 'J';


-- Q14. Display employees who joined in Week Number 25.

SELECT * FROM employee_attendance
WHERE WEEK(joining_date, 1) = 25;


-- Q15. Display employee names and the last day of their birth month.

SELECT emp_name,
       LAST_DAY(birth_date) AS last_day_of_birth_month
FROM employee_attendance;


-- Q16. Display employee names with joining date after adding one year.

SELECT emp_name,
       joining_date,
       DATE_ADD(joining_date, INTERVAL 1 YEAR) AS joining_date_after_one_year
FROM employee_attendance;


-- Q17. Display employee names with joining date after subtracting two months.

SELECT emp_name,
       joining_date,
       DATE_SUB(joining_date, INTERVAL 2 MONTH) AS joining_date_before_two_months
FROM employee_attendance;


-- Q18. Display employees who were born in the current year.

SELECT * FROM employee_attendance
WHERE YEAR(birth_date) = YEAR(CURDATE());


-- Q19. Display employee names along with their joining date in DD-MM-YYYY format.

SELECT emp_name,
       DATE_FORMAT(joining_date, '%d-%m-%Y') AS formatted_joining_date
FROM employee_attendance;


-- Q20. Display employee names along with their login date in DD-MONTH-YYYY format.

SELECT emp_name,
       DATE_FORMAT(login_time, '%d-%M-%Y') AS formatted_login_date
FROM employee_attendance;


-- =====================================================
-- END OF STRING AND DATE/TIME FUNCTIONS ASSIGNMENT
-- =====================================================
