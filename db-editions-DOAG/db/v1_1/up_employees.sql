/* up_employees.sql */

ALTER SESSION SET EDITION=v1_1;

alter session set DDL_LOCK_TIMEOUT=30;

ALTER TABLE hr.employees$0 ADD 
    (is_manager    CHAR(1));

-- Setup the records that are managers
UPDATE hr.employees$0
  SET is_manager = 'T'
  WHERE employee_id IN (SELECT manager_id FROM hr.employees$0);

-- rest of the records are not managers
UPDATE hr.employees$0
  SET is_manager = 'F'
  WHERE is_manager IS NULL;

COMMIT;

-- Update the editioning view
CREATE OR REPLACE EDITIONING VIEW employees AS
    SELECT employee_id, manager_id, department_id, first_name, last_name, email, 
           phone_number, hire_date, job_name, salary, commission_pct, is_manager
       FROM employees$0;

