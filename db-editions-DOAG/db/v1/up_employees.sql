/* up_employees.sql */
-- Update the employees table for new department table link and manager_id 

-- Alway set the expected edtion just in case
ALTER SESSION SET EDITION=v1;

alter session set DDL_LOCK_TIMEOUT=30;

ALTER TABLE hr.employees$0 ADD 
    (department_id NUMBER(4,0),
	 manager_id    NUMBER(6,0));

ALTER TABLE hr.employees$0 ADD CONSTRAINT emp_dept_fk FOREIGN KEY (department_id)
	  REFERENCES hr.departments$0 (department_id) ENABLE;
ALTER TABLE hr.employees$0 ADD CONSTRAINT emp_manager_fk FOREIGN KEY (manager_id)
	  REFERENCES hr.employees$0 (employee_id) ENABLE;

CREATE OR REPLACE EDITIONING VIEW employees AS
    SELECT employee_id, manager_id, department_id, first_name, last_name, email, 
           phone_number, hire_date, job_name, salary, commission_pct
       FROM employees$0;

/*
UPDATE hr.employees$0 e
    SET department_id = 
        (SELECT department_id FROM hr.departments$0 d 
          WHERE SUBSTR(e.employee_code,1,INSTR(e.employee_code,'-')-1) = 
                SUBSTR(UPPER(d.deptarment_name),1,LENGTH(SUBSTR(e.employee_code,1,INSTR(e.employee_code,'-')-1)))),
        manager_id = TO_NUMBER(SUBSTR(e.employee_code,INSTR(e.employee_code,'-')+1,INSTR(e.employee_code,'-',1,2)-1)
  WHERE e.department_id IS NULL;

*/


