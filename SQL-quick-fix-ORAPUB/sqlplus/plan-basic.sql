/* plan-basic.sql */

-- NOTE this script will not work in SQL Developer WEB
column ename format a20
column rname format a20

prompt ========================== plan-basic-sql ==========================================
prompt Running a SQL statement, and then showing the plan for that statement
prompt

explain plan for
select e.first_name, e.last_name, j.job_title
  from hr.employees  e
    join hr.jobs j on (j.job_id = e.job_id)
    join hr.departments d on (d.department_id = e.department_id)
  where  d.department_name in ('Finance','Administration');

prompt Now the plan for the SQL
prompt 

set linesize 220 tab off pagesize 1000 trims on
column plan_table_output format a120

SELECT *
  FROM table(DBMS_XPLAN.DISPLAY(FORMAT=>'ALL +OUTLINE'));

