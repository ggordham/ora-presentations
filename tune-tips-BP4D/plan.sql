--
-- An example of retrieving a useful SQL Execution Plan
--
set linesize 220 tab off pagesize 1000 trims on
column plan_table_output format a120
set echo on
SELECT *
  FROM table(DBMS_XPLAN.DISPLAY_CURSOR(FORMAT=>'ALL +OUTLINE'));
set echo off
