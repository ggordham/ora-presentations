/* list-baseline.sql */
SET ECHO OFF
-- List SQL plan baselines

set linesize 200
set trims on
set tab off
column sql_handle format a22
column plan_name format a32
column origin format a15
column last_executed format a30
column sql_text format a65

set echo on

SELECT sql_handle, plan_name, origin, enabled, accepted,
       fixed, optimizer_cost, executions, elapsed_time,
       cpu_time, buffer_gets, disk_reads
  FROM dba_sql_plan_baselines;

set echo off
