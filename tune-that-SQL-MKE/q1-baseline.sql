/* q1-baseline.sql */

@connect.sql

set echo off
alter session set optimizer_capture_sql_plan_baselines = TRUE;

@q1 1
@q1 1

alter session set optimizer_capture_sql_plan_baselines = FALSE;

