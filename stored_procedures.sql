-- ============================================================
-- File: stored_procedures.sql
-- Description: Contains only the stored procedures for
-- the Workforce Analytics SQL Project
-- ============================================================

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