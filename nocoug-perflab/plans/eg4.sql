column ename format a20
column rname format a20

var sqlid varchar2(100)
prompt Here we add a hint with a name we can search for
prompt Press Enter to continue:
accept next1

set echo on

select /* MY_TEST_QUERY */
       e.ename,r.rname
from   employees  e
join   roles       r on (r.id = e.role_id)
join   departments d on (d.id = e.dept_id)
where  e.staffno <= 10
and    d.dname in ('Department Name 1','Department Name 2');

set echo off
--
prompt -- In this example, let's search for the query
prompt -- in V$SQL. We could do this in another session
prompt -- while the query is executing.
--
prompt Press Enter to continue:
accept next1
set echo on

begin
   select sql_id
   into   :sqlid
   from   v$sql 
   where  sql_text like '%MY_TEST_QUERY%'
   and    sql_text not like '%v$sql%'
   and    rownum<2;
end;
/

set echo off
set long 100000 pagesize 0 linesize 250 tab off trims on
column plan_table_output format a230

prompt Now get the explain plan based on the SQL_ID
prompt Press Enter to continue:
accept next1
set echo on

SELECT *
FROM table(DBMS_XPLAN.DISPLAY_CURSOR(SQL_ID=>:sqlid,FORMAT=>'ALL +OUTLINE'));

set echo off
