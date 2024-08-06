--liquibase formatted sql
--changeset ggordham:create_employees_view_v1.0 endDelimiter:/ rollbackEndDelimiter:/
--comment first version of view v1.0
-CREATE OR REPLACE VIEW employees_view AS
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.first_name||' '||e.last_name AS full_name,
    e.email,
    ec.contact AS phone,
    e.hire_date,
    j.job_title,
    d.department_name,
    e.salary,
    e.commission_pct,
    m.first_name||' '||m.last_name AS manager_full_name
  FROM
    employees e, emp_contact ec,
    departments d, jobs j,
    employees m
  WHERE
    e.department_id = d.department_id
    AND e.job_id = j.job_id
    AND e.manager_id = m.employee_id
    AND e.employee_id = ec.employee_id
    AND ec.contact_type = 'PHONE';
--rollback DROP VIEW employees_view;

