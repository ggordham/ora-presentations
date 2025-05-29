set linesize 200
set tab off
set trims on
set pagesize 1000
column plan_table_output format a180

SELECT *
  FROM table(DBMS_XPLAN.DISPLAY_CURSOR(format=>'typical +alias +sql_analysis_report'));

