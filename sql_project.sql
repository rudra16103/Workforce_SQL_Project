-- ============================================================
-- Project Name: Workforce Analytics SQL Project
-- Author: Rudra Arora
-- Description: End-to-end SQL project analyzing employee and 
-- department data with joins, aggregates, stored procedures, 
-- and indexing for optimization.
-- Database: MySQL
-- ============================================================


-- Creating the database
DROP DATABASE IF EXISTS sql_project;
CREATE DATABASE sql_project;


-- Adding tables according to our dataset
USE sql_project;

DROP TABLE IF EXISTS departments;
CREATE TABLE departments(
	dept_no VARCHAR(10) PRIMARY KEY,
	dept_name VARCHAR(20) NOT NULL UNIQUE
);

DROP TABLE IF EXISTS employees;
CREATE TABLE employees(
	emp_no INT PRIMARY KEY AUTO_INCREMENT,
	birth_date DATE NOT NULL,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	gender ENUM('M', 'F') NOT NULL,
    hire_date DATE NOT NULL
);

DROP TABLE IF EXISTS salaries;
CREATE TABLE salaries(
	emp_no INT,
    salary INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    FOREIGN KEY fk_salaries_employees (emp_no) 
		REFERENCES  employees (emp_no)
		ON UPDATE CASCADE
        ON DELETE NO ACTION,
	PRIMARY KEY (emp_no, from_date)
);

DROP TABLE IF EXISTS department_employees;
CREATE TABLE department_employees(
	emp_no INT,
	dept_no VARCHAR(10) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
    FOREIGN KEY fk_departmentemployees_employees (emp_no)
		REFERENCES employees (emp_no)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    FOREIGN KEY fk_departmentemployees_departments (dept_no)
		REFERENCES departments (dept_no)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    PRIMARY KEY (emp_no, dept_no)
);

DROP TABLE IF EXISTS department_managers;
CREATE TABLE department_managers(
	emp_no INT,
	dept_no VARCHAR(10) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY fk_departmentmanager_employees (emp_no) 
		REFERENCES employees (emp_no)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    FOREIGN KEY fk_departmentmanager_departments (dept_no) 
		REFERENCES departments (dept_no)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    PRIMARY KEY (emp_no, dept_no)
);


-- Data imported from Excel files into corresponding tables using DBeaver's data import tool

-- Queries-

-- Q1) List all employees along with their department names.
USE sql_project;

SELECT
	CONCAT(e.first_name,' ', e.last_name) AS full_name,
    d.dept_name
FROM employees e
JOIN department_employees de
	USING (emp_no)
JOIN departments d
	USING (dept_no);

-- Q2) Find all departments that have more than 50 employees.
USE sql_project;

SELECT
	d.dept_name,
    COUNT(de.emp_no) AS no_of_employees
FROM departments d
JOIN department_employees de
	USING (dept_no)
GROUP BY d.dept_name
HAVING COUNT(de.emp_no) > 50;

-- Q3) Show all managers and their departments with their full names.
USE sql_project;

SELECT
	CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    d.dept_name
FROM employees e
JOIN department_managers de
	USING (emp_no)
JOIN departments d
	USING (dept_no);
    
-- Q4) List employees who have worked in more than 1 department
USE sql_project;

SELECT
	e.emp_no,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    COUNT(de.dept_no) AS no_of_departments_worked_in
FROM employees e
JOIN department_employees de
	USING (emp_no)
GROUP BY e.emp_no
HAVING COUNT(de.dept_no) > 1;

-- Q5) Find employees whose current salary is more than $100,000.
USE sql_project;

SELECT
	e.emp_no,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    s.salary
FROM employees e
JOIN salaries s
	USING (emp_no)
WHERE s.salary > 100000 AND 
	  to_date = '9999-01-01';
      
-- Q6) Show the highest salary per department.
	USE sql_project;

SELECT
	d.dept_name,
    MAX(s.salary) AS max_salary
FROM department_employees de
JOIN departments d
	USING (dept_no)
JOIN salaries s
	USING (emp_no)
GROUP BY d.dept_name;

-- Q7) Find employees who have never been promoted to manager.
USE sql_project;

SELECT
	CONCAT(e.first_name, ' ', e.last_name) AS full_name
FROM employees e
LEFT JOIN department_managers dm
    USING (emp_no)
WHERE dm.emp_no IS NULL;

-- Q8) List all departments along with the average salary of their employees.
USE sql_project;

SELECT
	d.dept_name,
    AVG(s.salary) AS average_salary
FROM departments d
JOIN department_employees de
	USING (dept_no)
JOIN salaries s
	USING (emp_no)
WHERE s.to_date = '9999-01-01'
GROUP BY d.dept_name;

-- Q9) Retrieve employees who joined between 1990 and 2000.
USE sql_project;

SELECT
	e.emp_no,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    e.hire_date
FROM employees e
WHERE hire_date BETWEEN '1990-01-01' AND '2000-12-31';

-- Q10) Show department-wise employee count and average tenure.
USE sql_project;

SELECT
	d.dept_name,
    COUNT(e.emp_no) AS employee_count,
    AVG(DATEDIFF(CURDATE(), de.from_date)/365.25) AS average_tenure
FROM departments d
JOIN department_employees de
	USING (dept_no)
JOIN employees e
	USING (emp_no)
GROUP BY d.dept_name;

-- Q11) Find top 5 highest paid employees in the entire company.
USE sql_project;

SELECT
	CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    s.salary
FROM employees e
JOIN salaries s
	USING (emp_no)
ORDER BY salary DESC
LIMIT 5;

-- Q12) Show the department with the lowest average salary.
USE sql_project;

SELECT
	d.dept_name,
    AVG(salary) AS min_avg_salary
FROM departments d
JOIN department_employees de
	USING (dept_no)
JOIN salaries s
	USING (emp_no)
GROUP BY d.dept_name
ORDER BY min_avg_salary
LIMIT 1;

-- Q13) List employees who have changed departments more than once.
USE sql_project;

SELECT
	e.emp_no,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    COUNT(de.dept_no) AS no_of_times_dept_changed
FROM employees e
JOIN department_employees de
	USING (emp_no)
GROUP BY e.emp_no
HAVING COUNT(de.dept_no) > 1;

-- Q14) Get all salaries of employees who have ever worked in the "Sales" department.
USE sql_project;

SELECT 
	CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    d.dept_name,
    s.salary
FROM employees e
JOIN salaries s
	USING (emp_no)
JOIN department_employees de
	USING (emp_no)
JOIN departments d
	USING (dept_no)
WHERE d.dept_name = 'Sales';

-- Q15) Identify managers who have served more than 5 years.
USE sql_project;

SELECT 
	e.emp_no,
    CONCAT(e.first_name, ' ', e.last_name) AS manager,
    SUM(DATEDIFF(CURDATE(), dm.from_date)/365.25) AS total_tenure
FROM employees e
JOIN department_managers dm
	USING (emp_no)
GROUP BY emp_no
HAVING SUM(DATEDIFF(CURDATE(), dm.from_date)/365.25) > 5;

-- Q16) Count how many employees are currently assigned to each department.
USE sql_project;

SELECT 
    d.dept_name,
    COUNT(de.dept_no) AS no_of_employees
FROM employees e
JOIN department_employees de
	USING (emp_no)
JOIN departments d
	USING (dept_no)
WHERE de.to_date = '9999-01-01'
GROUP BY d.dept_name;

-- Q17) Show the total current payroll (sum of salaries) per department.
USE sql_project;

SELECT 
    d.dept_name,
    SUM(s.salary) AS total_salary
FROM employees e
JOIN salaries s
	USING (emp_no)
JOIN department_employees de
	USING (emp_no)
JOIN departments d
	USING (dept_no)
WHERE s.to_date = '9999-01-01' AND
	  de.to_date = '9999-01-01'
GROUP BY dept_name;

-- Q18) Show the number of employees hired per year.
USE sql_project;

SELECT 
    YEAR(hire_date) AS hire_year,
    COUNT(emp_no) AS employees_hired
FROM employees
GROUP BY YEAR(hire_date)
ORDER BY hire_year;

-- Q19) Get the minimum and maximum salary of all employees that they have ever earned.
USE sql_project;

SELECT 
	e.emp_no,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    MIN(s.salary) AS min_salary,
    MAX(s.salary) AS max_salary
FROM employees e
JOIN salaries s
	USING (emp_no)
GROUP BY e.emp_no;

-- Q20) Calculate the average tenure of current employees per department.
USE sql_project;

SELECT 
	d.dept_name,
    AVG(DATEDIFF(CURDATE(), de.from_date)/365.25) AS avg_tenure
FROM departments d
JOIN department_employees de
	USING (dept_no)
WHERE de.to_date = '9999-01-01'
GROUP BY d.dept_name;

-- Q21) Show employee name, current department, and current manager name.
USE sql_project;

SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    d.dept_name,
    (
        SELECT CONCAT(m.first_name, ' ', m.last_name)
        FROM employees m
        JOIN department_managers dm 
			USING (emp_no)
        WHERE dm.dept_no = d.dept_no AND
		      dm.to_date = '9999-01-01'
    ) AS manager
FROM employees e
JOIN department_employees de
	USING (emp_no)
JOIN departments d 
	USING (dept_no)
WHERE de.to_date = '9999-01-01';

-- Q22) List employees who are managers and also currently in the department they manage.
USE sql_project;

SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS manager,
    d.dept_name
FROM employees e
JOIN department_managers dm
	USING (emp_no)
JOIN department_employees de
	USING (dept_no)
JOIN departments d
	USING (dept_no)
WHERE dm.emp_no = de.emp_no AND
	  dm.to_date = '9999-01-01';
      
-- Q23) Find all departments that never had a manager change.
USE sql_project;

SELECT
	d.dept_no,
    d.dept_name
FROM departments d
JOIN department_managers dm
	USING (dept_no)
GROUP BY d.dept_no
HAVING COUNT(dm.emp_no) = 1;

-- Q24) List employees who have had a salary decrease at any point.
USE sql_project;

SELECT
	e.emp_no,
	CONCAT(first_name, ' ', last_name) AS employee
FROM employees e
JOIN salaries s1
	USING (emp_no)
JOIN salaries s2
	USING (emp_no)
WHERE s2.from_date > s1.from_date AND
      s2.salary < s1.salary
GROUP BY e.emp_no;

-- Q25) Identify departments with overlapping manager tenures.
USE sql_project;

SELECT DISTINCT
    d.dept_name,
    dm1.emp_no AS manager_emp_no,
    CONCAT(e.first_name, ' ', e.last_name) AS manager
FROM departments d
JOIN department_managers dm1 
    USING (dept_no)
JOIN department_managers dm2 
    USING (dept_no)
JOIN employees e
    ON e.emp_no = dm1.emp_no
WHERE dm1.emp_no <> dm2.emp_no AND 
	  dm1.from_date <= dm2.to_date AND 
	  dm2.from_date <= dm1.from_date;
      
-- Q26) Show employees who were hired before their current manager.
USE sql_project;

SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    e.hire_date AS employee_hire_date,
    CONCAT(m.first_name, ' ', m.last_name) AS manager,
    m.hire_date AS manager_hire_date,
    d.dept_name
FROM employees e
JOIN department_employees de
    USING (emp_no)
JOIN departments d
    USING (dept_no)
JOIN department_managers dm
    ON dm.dept_no = de.dept_no
JOIN employees m
    ON m.emp_no = dm.emp_no
WHERE de.to_date = '9999-01-01' AND 
	  dm.to_date = '9999-01-01' AND 
      e.hire_date < m.hire_date;  
      
-- Q27) Create a stored procedure named 'GetDepartmentPayroll' that takes a department ID and returns the total payroll (sum of current salaries) for that department.
USE sql_project;

DELIMITER $$

CREATE PROCEDURE GetDepartmentPayroll (IN dept_no VARCHAR(10))
BEGIN
	SELECT 
		d.dept_no,
        d.dept_name,
		SUM(salary)
    FROM salaries s
    JOIN department_employees de
		USING (emp_no)
	JOIN departments d
		USING (dept_no)
    WHERE s.to_date = '9999-01-01' AND
		  d.dept_no = dept_no
    GROUP BY d.dept_no;
END $$

DELIMITER ;

-- Q28) Create a stored procedure named 'GetEmployeeSalaryHistory' that takes an employee ID and returns the complete salary history for that employee.
USE sql_project;

DELIMITER $$

CREATE PROCEDURE GetEmployeeSalaryHistory (IN emp_id INT)
BEGIN
    SELECT 
        emp_no,
        salary,
        from_date,
        to_date
    FROM salaries
    WHERE emp_no = emp_id
    ORDER BY from_date;
END $$

DELIMITER ;

-- Q29) Create a stored procedure named 'GetDepartmentEmployees' that takes a department ID and returns a list of all current employees in that department.
USE sql_project;

DELIMITER $$

CREATE PROCEDURE GetDepartmentEmployees (IN dept_id VARCHAR(10))
BEGIN
    SELECT 
        e.emp_no,
        CONCAT(e.first_name, ' ', e.last_name) AS full_name,
        e.hire_date
    FROM employees e
    JOIN department_employees de
        USING (emp_no)
    WHERE de.dept_no = dept_id AND de.to_date = '9999-01-01';
END $$

DELIMITER ;

-- Q30) Create an index on the `dept_no` column in the `department_employees` table to optimize department-level queries.
USE sql_project;

CREATE INDEX idx_dept_no
ON department_employees(dept_no);

-- Q31 Create an index on emp_no in the salaries table to optimize salary lookups for employees.
USE sql_project;

CREATE INDEX idx_salaries_emp_no
ON salaries(emp_no);

-- Q32 Create a composite index on from_date and to_date in the department_managers table to optimize queries involving manager tenure periods.
USE sql_project;

CREATE INDEX idx_manager_tenure
ON department_managers(from_date, to_date);