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