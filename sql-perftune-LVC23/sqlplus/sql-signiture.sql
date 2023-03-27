/* sql-signiture.sql */

select e.ename, r.rname
  from employees  e
    join roles r on (r.id = e.role_id)
    join departments d on (d.id = e.dept_id)
  where  e.staffno <= 10
    and  d.dname in ('Department Name 1','Department Name 2');

@@last-sql.sql

select e.ename, r.rname
  from employees  e
    join roles r on (r.id = e.role_id)
    join departments d on (d.id = e.dept_id)
  where  e.staffno <= 10
    and  d.dname in ('Department Name 2','Department Name 1');

@@last-sql.sql

var v_satffno number
var v_dname1 varchar2(40)
var v_dname2 varchar2(40)

exec :v_staffno := 10;
exec :v_dname1 := 'Department Name 1';
exec :v_dname2 := 'Department Name 2';

select e.ename, r.rname
  from employees  e
    join roles r on (r.id = e.role_id)
    join departments d on (d.id = e.dept_id)
  where  e.staffno <= :v_staffno
    and  d.dname in (:v_dname1,:v_dname2);

