/* mv_hr.sql */
-- Move HR schema to editions for EBR demo

-- HR user
ALTER TABLE employees RENAME TO employees$0;

CREATE OR REPLACE EDITIONING VIEW employees AS
    SELECT employee_id, employee_code, first_name, last_name, email, 
           phone_number, hire_date, job_name, salary, commission_pct
       FROM employees$0;

