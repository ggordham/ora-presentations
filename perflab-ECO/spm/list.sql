REM
REM List SQL plan baselines
REM

set linesize 200
set trims on
set tab off
column plan_name format a35
column last_executed format a30
column sql_text format a65

set echo on

select plan_name,sql_handle,sql_text, accepted, autopurge, last_executed, executions,ROWS_PROCESSED
from dba_sql_plan_baselines 
order by last_executed;

set echo off
