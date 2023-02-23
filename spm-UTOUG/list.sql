REM
REM List SQL plan baselines
REM

set linesize 200
set trims on
set tab off
column sql_handle format a22
column plan_name format a32
column origin format a15
column last_executed format a30
column sql_text format a65
column signature format 99999999999999999999999

set echo on

SELECT signature, sql_handle, plan_name, origin, enabled, accepted,
       fixed, optimizer_cost, executions, elapsed_time,
       cpu_time, buffer_gets, disk_reads
  FROM dba_sql_plan_baselines;

set echo off
