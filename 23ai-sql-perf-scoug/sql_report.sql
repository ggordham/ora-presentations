/* sql_report.sql */

-- generates a SQL diagnostic report, 23ai or above only

-- Note levels are: BASIC, TYPICAL, ALL
-- Note: a directory => can be supplied, then the name will be SQLR_<SQL_ID>_<YYYYMMDDHH24MI>.html

define v_sqlid=&&1
define v_level = 'TYPICAL'


column today noprint new_value v_date
SELECT TO_CHAR(SYSDATE, 'YYYYMMDDHH24MI') today FROM dual;
column today clear
define v_logfile = sqlr_&&v_sqlid._&&v_date..html

set feedback on
var v_report CLOB;
exec :v_report := dbms_sqldiag.report_sql(sql_id => '&&v_sqlid', level => '&&v_level'); 

-- set trimspool on 
-- set linesize 32767
-- Note long limit 2,000,000,000
set longchunksize 999999999
set long 999999999 pagesize 0 linesize 250 tab off trims on
column report format a230

set termout off feedback off
spool &&v_logfile
select :v_report from dual;
spool off

set termout on feedback off
prompt spooled to file &&v_logfile

/* END */
