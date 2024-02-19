
SET ECHO OFF
set linesize 250
set trims on
set tab off
set tab off
set pagesize 1000
set wrap off
column plan_table_output format a180

SET ECHO ON
SELECT *
FROM table(DBMS_XPLAN.DISPLAY_CURSOR(FORMAT=>'ALL ALLSTATS LAST +cost +bytes +OUTLINE'));


set wrap on
SET ECHO OFF
