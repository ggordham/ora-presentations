
--
-- Use this to capture a SQL_ID
--
var sqlid varchar2(100)

--
-- The bind variable is the wrong type for the query
-- since s_area is CHAR(4)
--
var bind1 number
exec :bind1 := 1

SELECT /*+ MONITOR */ t1.p_category, t2.tpmethod 
  FROM products t1, products t2
  WHERE t1.prod_category || '_1' = 'SFD_1'
    AND t2.method_typ != 'SEA'
UNION
SELECT t3.p_category, t4.tpmethod
  FROM products t3, sources t4
  WHERE t3.scid = t4.scid 
    AND t4.carrier   = 'AAC'
    AND t4.s_area    = :bind1;


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


set long 100000 pagesize 0 linesize 250 tab off trims on
column report format a230


set termout off feedback off
spool monitor_output.html
select DBMS_SQL_MONITOR.REPORT_SQL_MONITOR (sql_id=>:sqlid, report_level=>'all', type=>'active') report
from dual;
spool off

set termout on feedback off
set echo off
prompt spooled to file monitor_output.html

