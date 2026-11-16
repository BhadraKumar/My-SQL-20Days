
-- ==========================================
-- SQL JOINS EXERCISES
-- ==========================================

-- 1. CREATE TABLES

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100)
);

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT
);


-- 2. INSERT RECORDS INTO STUDENTS

INSERT INTO Students VALUES
(1, 'Arjun', 20),
(2, 'Bhavana', 21),
(3, 'Charan', 22),
(4, 'Divya', 20),
(5, 'Eswar', 23),
(6, 'Farhan', 21),
(7, 'Gowri', 22);


-- 3. INSERT RECORDS INTO COURSES

INSERT INTO Courses VALUES
(101, 'Mathematics'),
(102, 'Physics'),
(103, 'Biology'),
(104, 'Chemistry'),
(105, 'Computer Science');


-- 4. INSERT RECORDS INTO ENROLLMENTS

INSERT INTO Enrollments VALUES
(1, 1, 101),
(2, 2, 101),
(3, 2, 102),
(4, 3, 103),
(5, 4, 101),
(6, 5, 104),
(7, 1, 102),
(8, 6, 105);


-- ==========================================
-- SQL JOINS EXERCISES
-- ==========================================

-- Q1. List all students with the courses
-- they are enrolled in.

SELECT s.name, c.course_name
FROM Students s
INNER JOIN Enrollments e
ON s.student_id = e.student_id
INNER JOIN Courses c
ON e.course_id = c.course_id;


-- Q2. Show course names along with student names.

SELECT c.course_name, s.name
FROM Courses c
INNER JOIN Enrollments e
ON c.course_id = e.course_id
INNER JOIN Students s
ON e.student_id = s.student_id;


-- Q3. Get names of students enrolled in Physics.

SELECT s.name
FROM Students s
INNER JOIN Enrollments e
ON s.student_id = e.student_id
INNER JOIN Courses c
ON e.course_id = c.course_id
WHERE c.course_name = 'Physics';


-- Q4. List all students with their courses,
-- if enrolled.

SELECT s.name, c.course_name
FROM Students s
LEFT JOIN Enrollments e
ON s.student_id = e.student_id
LEFT JOIN Courses c
ON e.course_id = c.course_id;


-- Q5. Show all courses and the students who
-- enrolled, even if none.

SELECT c.course_name, s.name
FROM Courses c
LEFT JOIN Enrollments e
ON c.course_id = e.course_id
LEFT JOIN Students s
ON e.student_id = s.student_id;


-- Q6. Display all students with course details,
-- even if some courses have no enrollments.

SELECT s.name, c.course_name
FROM Students s
CROSS JOIN Courses c
LEFT JOIN Enrollments e
ON s.student_id = e.student_id
AND c.course_id = e.course_id;


-- Q7. List all students and all courses,
-- even if there is no match (simulate FULL JOIN).

SELECT s.name, c.course_name
FROM Students s
LEFT JOIN Enrollments e
ON s.student_id = e.student_id
LEFT JOIN Courses c
ON e.course_id = c.course_id

UNION

SELECT s.name, c.course_name
FROM Courses c
LEFT JOIN Enrollments e
ON c.course_id = e.course_id
LEFT JOIN Students s
ON e.student_id = s.student_id;


-- Q8. Show pairs of students who have the same age.

SELECT s1.name AS Student1,
       s2.name AS Student2,
       s1.age
FROM Students s1
INNER JOIN Students s2
ON s1.age = s2.age
AND s1.student_id < s2.student_id;


-- Q9. Count how many students are enrolled
-- in each course.

SELECT c.course_name,
       COUNT(e.student_id) AS total_students
FROM Courses c
LEFT JOIN Enrollments e
ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;


-- Q10. Show the number of courses each student
-- is enrolled in.

SELECT s.name,
       COUNT(e.course_id) AS total_courses
FROM Students s
LEFT JOIN Enrollments e
ON s.student_id = e.student_id
GROUP BY s.student_id, s.name;


-- Q11. List all students and their courses
-- ordered by student name.

SELECT s.name, c.course_name
FROM Students s
LEFT JOIN Enrollments e
ON s.student_id = e.student_id
LEFT JOIN Courses c
ON e.course_id = c.course_id
ORDER BY s.name ASC;


-- Q12. Show student names and course names
-- ordered by course name.

SELECT s.name, c.course_name
FROM Students s
INNER JOIN Enrollments e
ON s.student_id = e.student_id
INNER JOIN Courses c
ON e.course_id = c.course_id
ORDER BY c.course_name ASC;


-- Q13. Show only courses with more than
-- one student enrolled.

SELECT c.course_name,
       COUNT(e.student_id) AS total_students
FROM Courses c
INNER JOIN Enrollments e
ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
HAVING COUNT(e.student_id) > 1;


-- Q14. List students enrolled in more than one course.

SELECT s.name,
       COUNT(e.course_id) AS total_courses
FROM Students s
INNER JOIN Enrollments e
ON s.student_id = e.student_id
GROUP BY s.student_id, s.name
HAVING COUNT(e.course_id) > 1;


-- Q15. Display student names and count of
-- enrollments, ordered by enrollment count.

SELECT s.name,
       COUNT(e.enrollment_id) AS total_enrollments
FROM Students s
LEFT JOIN Enrollments e
ON s.student_id = e.student_id
GROUP BY s.student_id, s.name
ORDER BY total_enrollments DESC;

