/* day1-sql-adaptive.sql */

select sql_id, sql_text, optimizer_cost, plan_hash_value,
       child_number, is_bind_sensitive, is_bind_aware, 
       is_reoptimizable, is_resolved_adaptive_plan
   from v$sql
   where sql_id = '4jmfd7w096z1w';
   -- '19nmwtxrh5rf1';
