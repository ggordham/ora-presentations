
var report clob

exec :report := dbms_spm.add_verified_sql_plan_baseline('&&1');

SET linesize 180
SET longchunksize 180
SET pagesize 900
SET long 1000000

select :report report from dual;

