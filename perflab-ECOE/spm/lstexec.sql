
connect / as sysdba

SELECT 
       sql_id,
       plan_hash_value,
       ROUND((elapsed_time / case when executions = 0 then 1 else executions end) / 1000000, 4) ela_sec,
       executions,
       disk_reads,
       direct_writes,
       direct_reads,
       buffer_gets,
       round(buffer_gets/ case when executions = 0 then 1 else executions end, 0) buff_per_exec,
       sql_profile,
       sql_plan_baseline,
       sql_patch  -- , sql_text
    FROM v$sql
    WHERE sql_id = '0ptw8zskuh9r4';



