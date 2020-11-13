set linesize 200
set tab off
set pagesize 1000
column plan_table_output format a180

prompt Showing the explain plan
prompt Press Enter to continue:
accept next1

set echo on
SELECT *
FROM table(DBMS_XPLAN.DISPLAY_CURSOR(FORMAT=>'LAST OUTLINE'));

set echo off
