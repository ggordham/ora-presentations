column ename format a20
column rname format a20

--
-- Use this to capture a SQL_ID
--
var sqlid varchar2(100)

--
prompt ========================== eg3 ==========================================
prompt -- Long running queries will be monitored automatically
prompt -- so the hint won't always be required. In this case,
prompt -- it's over very quickly so I've added the hint.
--

prompt Press Enter to continue:
accept next1

set echo on
select /*+ MONITOR */
       e.ename,r.rname
from   employees  e
join   roles       r on (r.id = e.role_id)
join   departments d on (d.id = e.dept_id)
where  e.staffno <= 10
and    d.dname in ('Department Name 1','Department Name 2');

set echo off
--
prompt -- Get the SQL_ID of the last SQL statement we ran
--
prompt Press Enter to continue:
accept next1
set echo on
begin
   select prev_sql_id
   into   :sqlid
   from   v$session 
   where  sid=userenv('sid') 
   and    username is not null 
   and    prev_hash_value <> 0
   and    rownum<2;
end;
/

set echo off
--
-- Text first, then HTML
--
prompt Now generate a SQL monitor report in text format
prompt Press Enter to continue:
accept next1

set long 100000 pagesize 0 linesize 250 tab off trims on
column report format a230

set echo on
select DBMS_SQL_MONITOR.REPORT_SQL_MONITOR (sql_id=>:sqlid, report_level=>'all', type=>'text') report
from dual;
set echo off

prompt Next we generate a HTML version of the SQL monitor report
prompt Press Enter to continue:
accept next1

prompt select DBMS_SQL_MONITOR.REPORT_SQL_MONITOR (sql_id=>:sqlid, report_level=>'all', type=>'active') report from dual;
prompt spooled to file monitor_output.html

set termout off feedback off
spool monitor_output.html
select DBMS_SQL_MONITOR.REPORT_SQL_MONITOR (sql_id=>:sqlid, report_level=>'all', type=>'active') report
from dual;
spool off

set termout on feedback off
set echo off
