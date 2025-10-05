-- ============================================================
-- File: indexes.sql
-- Description: Contains only the indexes for
-- the Workforce Analytics SQL Project
-- ============================================================

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