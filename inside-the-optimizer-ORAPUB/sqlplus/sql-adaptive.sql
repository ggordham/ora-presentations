

select sql_id, child_number, plan_hash_value, is_reoptimizable, 
       is_resolved_adaptive_plan, is_bind_aware, is_bind_sensitive
  from v$sql where sql_id = '&1';
