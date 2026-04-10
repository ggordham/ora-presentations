/* sql-signiture.sql */

SET pagesize 100
SET linesize 140
SET ECHO ON

select e.first_name, e.last_name, j.job_title
  from hr.employees  e
    join hr.jobs j on (j.job_id = e.job_id)
    join hr.departments d on (d.department_id = e.department_id)
  where  d.department_name in ('Finance','Administration');

@@last-sql.sql

SET ECHO ON

select e.first_name, e.last_name, j.job_title
  from hr.employees  e
    join hr.jobs j on (j.job_id = e.job_id)
    join hr.departments d on (d.department_id = e.department_id)
  where  d.department_name in ('Administration','Finance');

@@last-sql.sql

var v_staffno number
var v_dname1 varchar2(40)
var v_dname2 varchar2(40)

exec :v_staffno := 10;
exec :v_dname1 := 'Administration';
exec :v_dname2 := 'Finance';

SET ECHO ON

select e.first_name, e.last_name, j.job_title
  from hr.employees  e
    join hr.jobs j on (j.job_id = e.job_id)
    join hr.departments d on (d.department_id = e.department_id)
  where  d.department_name in (:v_dname1,:v_dname2);

@@last-sql.sql

