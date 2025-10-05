-- ============================================================
-- File: queries.sql
-- Description: Contains only the queries for
-- the Workforce Analytics SQL Project
-- ============================================================


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