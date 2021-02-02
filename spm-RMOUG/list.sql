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

SELECT plan_name, sql_handle, origin, enabled, accepted,
       fixed, optimizer_cost, executions, elapsed_time,
       cpu_time, buffer_gets, disk_reads
  FROM dba_sql_plan_baselines;

set echo off
