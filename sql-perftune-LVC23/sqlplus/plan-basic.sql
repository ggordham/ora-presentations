/* plan-basic.sql */

-- NOTE this script will not work in SQL Developer WEB
column ename format a20
column rname format a20

prompt ========================== plan-basic-sql ==========================================
prompt Running a SQL statement, and then showing the plan for that statement
prompt

explain plan for
select e.ename, r.rname
  from employees  e
    join roles r on (r.id = e.role_id)
    join departments d on (d.id = e.dept_id)
  where  e.staffno <= 10
    and  d.dname in ('Department Name 1','Department Name 2');


prompt Now the plan for the SQL
prompt 

set linesize 220 tab off pagesize 1000 trims on
column plan_table_output format a120

SELECT *
  FROM table(DBMS_XPLAN.DISPLAY(FORMAT=>'ALL +OUTLINE'));

