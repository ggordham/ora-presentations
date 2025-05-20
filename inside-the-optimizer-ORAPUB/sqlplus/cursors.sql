/* cursors.sql */

-- List cursors in v$sql 

set echo on
select child_number, plan_hash_value, executions, buffer_gets, 
     is_bind_sensitive, is_bind_aware, is_reoptimizable
     from v$sql 
     where sql_id = '&1';


