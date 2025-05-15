
SET ECHO OFF
set linesize 250
set trims on
set tab off
set tab off
set pagesize 1000
column plan_table_output format a180

SET ECHO ON
SELECT *
FROM table(DBMS_XPLAN.DISPLAY_CURSOR(FORMAT=>'ALLSTATS LAST +COST +BYTES -OUTLINE -PREDICATE -PROJECTION +PARALLEL'));


SET ECHO OFF
