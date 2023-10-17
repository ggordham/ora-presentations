/* sql_executions.sql */

set linesize 120
set pagesize 100
set trims on
set tab off

select sql_id, child_number, executions, invalidations, 
       optimizer_cost, buffer_gets, rows_processed, 
       cpu_time, elapsed_time, is_bind_sensitive, is_bind_aware,
       is_reoptimizable, is_resolved_adaptive_plan, sql_plan_baseline 
  from v$sql where sql_id = '&1';
 --  'fua0hb5hfst77';
