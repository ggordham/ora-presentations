column ename format a20
column rname format a20

prompt ========================== eg6 ==========================================
prompt Running a SQL statement in parallel and showing the plan
prompt Press Enter to continue:
accept next1

set echo on

select /*+ PARALLEL (e 2) */ 
       e.ename,r.rname
from   employees  e
join   roles       r on (r.id = e.role_id)
join   departments d on (d.id = e.dept_id)
where  e.staffno <= 10
and    d.dname in ('Department Name 1','Department Name 2');

set echo off
prompt Note the pralel steps in the plan
prompt Press Enter to continue:
accept next1

@planp
