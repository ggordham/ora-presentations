-- Purge Cursor

connect / as sysdba

COLUMN cur_address NEW_VALUE cur_address
COLUMN has_value NEW_VALUE hash_value

select address||','||hash_value as cur_address
--     executions,loads,version_count,invalidations,parse_calls 
   from gv$sqlarea 
   where sql_id='&1';

exec dbms_shared_pool.purge('&cur_address','C');

