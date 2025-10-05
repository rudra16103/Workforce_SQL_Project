-- ============================================================
-- File: schema.sql
-- Description: Contains only the table creation scripts for
-- the Workforce Analytics SQL Project
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