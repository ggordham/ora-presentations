set echo off
column ename format a20
column rname format a20

var sqlid varchar2(100)
prompt ========================== eg5 ==========================================
prompt Combining monitor and searching for SQL text
prompt Press Enter to continue:
accept next1

set echo on

select /* MY_TEST_QUERY */ /*+ MONITOR */
       e.ename,r.rname
from   employees  e
join   roles       r on (r.id = e.role_id)
join   departments d on (d.id = e.dept_id)
where  e.staffno <= 10
and    d.dname in ('Department Name 1','Department Name 2');

set echo off
--
-- In this example, let's search for the query
-- in V$SQL. We could do this in another session
-- while the query is executing.
--
prompt Search for the SQL
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
--
-- Generate the SQL Monitor Report
--
-- If the test query was long-running, we could run this
-- in a seperate SQL Plus session and watch the query's
-- progress.
--
set long 100000 pagesize 0 linesize 250 tab off trims on
column report format a230

prompt Generate the SQL Monitor report
prompt Press Enter to continue:
accept next1

set echo on
select DBMS_SQL_MONITOR.REPORT_SQL_MONITOR (sql_id=>:sqlid, report_level=>'all', type=>'text') report
from dual;

set echo off
