column ename format a20
column rname format a20

prompt Running a SQL statement, and then showing the plan for that statement
prompt Press Enter to continue:
accept next1

set echo on
-- explain plan for
select e.ename, r.rname 
  from employees  e
    join roles r on (r.id = e.role_id)
    join departments d on (d.id = e.dept_id)
  where  e.staffno <= 10
    and  d.dname in ('Department Name 1','Department Name 2');

set echo off
prompt Now the plan for the SQL
prompt Press Enter to continue:
accept next1

@plan
