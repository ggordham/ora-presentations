
INSERT INTO "EMPLOYEESv1" (
    employee_id,
    employee_code,
    first_name,
    last_name,
    email,
    phone_number,
    hire_date,
    job_name,
    salary,
    commission_pct)
SELECT e.employee_id, 
      UPPER(REPLACE(SUBSTR((SELECT d.department_name FROM departments$0 d where d.department_id = e.department_id),1,5),' ','_'))
        || '-'||TO_CHAR(manager_id,'FM000')||'-'||TO_CHAR(employee_id,'FM0000'),
      e.first_name,
      e.last_name,
      e.email,
      e.phone_number,
      e.hire_date,
      (SELECT job_title FROM jobs$0 j where j.job_id = e.job_id),
      e.salary,
      e.commission_pct
  FROM employees$0 e;
 
