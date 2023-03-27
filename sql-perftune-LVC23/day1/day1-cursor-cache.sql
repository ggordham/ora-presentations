/* day1-cursor-cache.sql */

SELECT inst_id, sql_id, sql_text, parsing_schema_name, plan_hash_value, 
       optimizer_cost, executions, last_active_time,
       buffer_gets, disk_reads, elapsed_time, cpu_time
    FROM gv$sql;


