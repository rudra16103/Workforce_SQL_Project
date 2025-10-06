![MySQL Logo](https://www.mysql.com/common/logos/logo-mysql-170x115.png)
# Workforce Analytics SQL Project

**Author:** Rudra Arora  
**Database:** MySQL  
**Description:** End-to-end SQL project analyzing employee and department data with joins, aggregates, stored procedures, and indexing for optimization.

---

## Overview
A SQL project analyzing employee and department data to extract insights such as:

- Employee-department assignments  
- Salary statistics & history  
- Managerial hierarchies & tenure  
- Employee promotions and department changes

Includes queries, indexes, and stored procedures for efficient analysis.

---

## Files in the Repository
- **CSV Data:** `employees.csv`, `departments.csv`, `salaries.7z`, `department_employees.csv`, `department_managers.csv`  
- **SQL Scripts:** `schema.sql`, `indexes.sql`, `queries.sql`, `stored_procedures.sql`, `sql_project.sql`

---

## Getting Started
1. Extract `salaries.7z` to get the salaries CSV.  
2. Create database & tables by running `schema.sql`.  
3. Import CSV files using **DBeaver** (recommended due to large data size).  
4. Add indexes: run `indexes.sql`.  
5. Add stored procedures: run `stored_procedures.sql`.  
6. Run queries: run `queries.sql` or the full project with `sql_project.sql`.

---

## 1. Create Database and Tables
```sql
DROP DATABASE IF EXISTS sql_project;
CREATE DATABASE sql_project;
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
```

---

## 2. Queries Q1-Q26
```sql
-- Q1) List all employees along with their department names.
SELECT CONCAT(e.first_name,' ', e.last_name) AS full_name, d.dept_name
FROM employees e
JOIN department_employees de USING (emp_no)
JOIN departments d USING (dept_no);

-- Q2) Departments with more than 50 employees
SELECT d.dept_name, COUNT(de.emp_no) AS no_of_employees
FROM departments d
JOIN department_employees de USING (dept_no)
GROUP BY d.dept_name
HAVING COUNT(de.emp_no) > 50;

-- Q3) Show all managers and their departments
SELECT CONCAT(e.first_name, ' ', e.last_name) AS full_name, d.dept_name
FROM employees e
JOIN department_managers de USING (emp_no)
JOIN departments d USING (dept_no);

-- Q4) Employees who worked in more than 1 department
SELECT e.emp_no, CONCAT(e.first_name, ' ', e.last_name) AS full_name, COUNT(de.dept_no) AS no_of_departments_worked_in
FROM employees e
JOIN department_employees de USING (emp_no)
GROUP BY e.emp_no
HAVING COUNT(de.dept_no) > 1;

-- Q5) Employees with current salary > 100000
SELECT e.emp_no, CONCAT(e.first_name, ' ', e.last_name) AS full_name, s.salary
FROM employees e
JOIN salaries s USING (emp_no)
WHERE s.salary > 100000 AND to_date = '9999-01-01';

-- Q6) Highest salary per department
SELECT d.dept_name, MAX(s.salary) AS max_salary
FROM department_employees de
JOIN departments d USING (dept_no)
JOIN salaries s USING (emp_no)
GROUP BY d.dept_name;

-- Q7) Employees never promoted to manager
SELECT CONCAT(e.first_name, ' ', e.last_name) AS full_name
FROM employees e
LEFT JOIN department_managers dm USING (emp_no)
WHERE dm.emp_no IS NULL;

-- Q8) Average salary per department
SELECT d.dept_name, AVG(s.salary) AS average_salary
FROM departments d
JOIN department_employees de USING (dept_no)
JOIN salaries s USING (emp_no)
WHERE s.to_date = '9999-01-01'
GROUP BY d.dept_name;

-- Q9) Employees hired between 1990 and 2000
SELECT e.emp_no, CONCAT(e.first_name, ' ', e.last_name) AS full_name, e.hire_date
FROM employees e
WHERE hire_date BETWEEN '1990-01-01' AND '2000-12-31';

-- Q10) Department-wise employee count & average tenure
SELECT d.dept_name, COUNT(e.emp_no) AS employee_count, AVG(DATEDIFF(CURDATE(), de.from_date)/365.25) AS average_tenure
FROM departments d
JOIN department_employees de USING (dept_no)
JOIN employees e USING (emp_no)
GROUP BY d.dept_name;

-- Q11) Top 5 highest paid employees
SELECT CONCAT(e.first_name, ' ', e.last_name) AS full_name, s.salary
FROM employees e
JOIN salaries s USING (emp_no)
ORDER BY s.salary DESC
LIMIT 5;

-- Q12) Department with lowest average salary
SELECT d.dept_name, AVG(s.salary) AS min_avg_salary
FROM departments d
JOIN department_employees de USING (dept_no)
JOIN salaries s USING (emp_no)
GROUP BY d.dept_name
ORDER BY min_avg_salary
LIMIT 1;

-- Q13) Employees changed departments more than once
SELECT e.emp_no, CONCAT(e.first_name, ' ', e.last_name) AS full_name, COUNT(de.dept_no) AS no_of_times_dept_changed
FROM employees e
JOIN department_employees de USING (emp_no)
GROUP BY e.emp_no
HAVING COUNT(de.dept_no) > 1;

-- Q14) Salaries of employees who worked in Sales
SELECT CONCAT(e.first_name, ' ', e.last_name) AS full_name, d.dept_name, s.salary
FROM employees e
JOIN salaries s USING (emp_no)
JOIN department_employees de USING (emp_no)
JOIN departments d USING (dept_no)
WHERE d.dept_name = 'Sales';

-- Q15) Managers with total tenure > 5 years
SELECT e.emp_no, CONCAT(e.first_name, ' ', e.last_name) AS manager, SUM(DATEDIFF(CURDATE(), dm.from_date)/365.25) AS total_tenure
FROM employees e
JOIN department_managers dm USING (emp_no)
GROUP BY e.emp_no
HAVING SUM(DATEDIFF(CURDATE(), dm.from_date)/365.25) > 5;

-- Q16) Employees currently assigned to each department
SELECT d.dept_name, COUNT(de.dept_no) AS no_of_employees
FROM employees e
JOIN department_employees de USING (emp_no)
JOIN departments d USING (dept_no)
WHERE de.to_date = '9999-01-01'
GROUP BY d.dept_name;

-- Q17) Total current payroll per department
SELECT d.dept_name, SUM(s.salary) AS total_salary
FROM employees e
JOIN salaries s USING (emp_no)
JOIN department_employees de USING (emp_no)
JOIN departments d USING (dept_no)
WHERE s.to_date = '9999-01-01' AND de.to_date = '9999-01-01'
GROUP BY d.dept_name;

-- Q18) Employees hired per year
SELECT YEAR(hire_date) AS hire_year, COUNT(emp_no) AS employees_hired
FROM employees
GROUP BY YEAR(hire_date)
ORDER BY hire_year;

-- Q19) Min and max salary of all employees
SELECT e.emp_no, CONCAT(e.first_name, ' ', e.last_name) AS full_name, MIN(s.salary) AS min_salary, MAX(s.salary) AS max_salary
FROM employees e
JOIN salaries s USING (emp_no)
GROUP BY e.emp_no;

-- Q20) Average tenure of current employees per department
SELECT d.dept_name, AVG(DATEDIFF(CURDATE(), de.from_date)/365.25) AS avg_tenure
FROM departments d
JOIN department_employees de USING (dept_no)
WHERE de.to_date = '9999-01-01'
GROUP BY d.dept_name;

-- Q21) Employee name, current department, current manager
SELECT CONCAT(e.first_name, ' ', e.last_name) AS employee, d.dept_name,
(SELECT CONCAT(m.first_name, ' ', m.last_name) 
 FROM employees m 
 JOIN department_managers dm USING(emp_no) 
 WHERE dm.dept_no = d.dept_no AND dm.to_date='9999-01-01') AS manager
FROM employees e
JOIN department_employees de USING(emp_no)
JOIN departments d USING(dept_no)
WHERE de.to_date='9999-01-01';

-- Q22) Employees who are managers and currently in their department
SELECT CONCAT(e.first_name, ' ', e.last_name) AS manager, d.dept_name
FROM employees e
JOIN department_managers dm USING(emp_no)
JOIN department_employees de USING(emp_no, dept_no)
JOIN departments d USING(dept_no)
WHERE dm.to_date='9999-01-01';

-- Q23) Departments never had a manager change
SELECT d.dept_no, d.dept_name
FROM departments d
JOIN department_managers dm USING(dept_no)
GROUP BY d.dept_no
HAVING COUNT(dm.emp_no)=1;

-- Q24) Employees with salary decrease at any point
SELECT e.emp_no, CONCAT(e.first_name, ' ', e.last_name) AS employee
FROM employees e
JOIN salaries s1 USING(emp_no)
JOIN salaries s2 USING(emp_no)
WHERE s2.from_date > s1.from_date AND s2.salary < s1.salary
GROUP BY e.emp_no;

-- Q25) Departments with overlapping manager tenures
SELECT DISTINCT d.dept_name, dm1.emp_no AS manager_emp_no, CONCAT(e.first_name, ' ', e.last_name) AS manager
FROM departments d
JOIN department_managers dm1 USING(dept_no)
JOIN department_managers dm2 USING(dept_no)
JOIN employees e ON e.emp_no=dm1.emp_no
WHERE dm1.emp_no<>dm2.emp_no AND dm1.from_date<=dm2.to_date AND dm2.from_date<=dm1.to_date;

-- Q26) Employees hired before current manager
SELECT CONCAT(e.first_name, ' ', e.last_name) AS employee, e.hire_date AS employee_hire_date,
CONCAT(m.first_name, ' ', m.last_name) AS manager, m.hire_date AS manager_hire_date, d.dept_name
FROM employees e
JOIN department_employees de USING(emp_no)
JOIN departments d USING(dept_no)
JOIN department_managers dm ON dm.dept_no = de.dept_no
JOIN employees m ON m.emp_no = dm.emp_no
WHERE de.to_date='9999-01-01' AND dm.to_date='9999-01-01' AND e.hire_date < m.hire_date;
```

---

## 3. Stored Procedures Q27-Q29
```sql
DELIMITER $$

CREATE PROCEDURE GetDepartmentPayroll(IN dept_no VARCHAR(10))
BEGIN
	SELECT d.dept_no, d.dept_name, SUM(s.salary)
	FROM salaries s
	JOIN department_employees de USING(emp_no)
	JOIN departments d USING(dept_no)
	WHERE s.to_date='9999-01-01' AND d.dept_no=dept_no
	GROUP BY d.dept_no;
END $$

CREATE PROCEDURE GetEmployeeSalaryHistory(IN emp_id INT)
BEGIN
	SELECT emp_no, salary, from_date, to_date
	FROM salaries
	WHERE emp_no=emp_id
	ORDER BY from_date;
END $$

CREATE PROCEDURE GetDepartmentEmployees(IN dept_id VARCHAR(10))
BEGIN
	SELECT e.emp_no, CONCAT(e.first_name,' ',e.last_name) AS full_name, e.hire_date
	FROM employees e
	JOIN department_employees de USING(emp_no)
	WHERE de.dept_no=dept_id AND de.to_date='9999-01-01';
END $$

DELIMITER ;
```

---

## 4. Indexes Q30-Q32
```sql
CREATE INDEX idx_dept_no ON department_employees(dept_no);
CREATE INDEX idx_salaries_emp_no ON salaries(emp_no);
CREATE INDEX idx_manager_tenure ON department_managers(from_date,to_date);
```

---

## Notes
- Current employees/managers are marked with `to_date = '9999-01-01'`.  
- Indexes improve performance for department & salary queries.  
- Use **DBeaver** for CSV import as the data is large.

---

## Repository Structure
```
workforce-analytics-sql/
├── employees.csv
├── departments.csv
├── department_employees.csv
├── department_managers.csv
├── salaries.7z
├── schema.sql
├── indexes.sql
├── queries.sql
├── stored_procedures.sql
├── sql_project.sql
└── README.md
```
