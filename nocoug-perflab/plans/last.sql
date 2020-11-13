
prompt 
prompt Lookup the sql_id of the last statement run in this session
prompt Press Enter to continue:
accept next1

set echo on
select prev_sql_id, prev_child_number 
from   v$session 
where  sid=userenv('sid') 
and    username is not null 
and    prev_hash_value <> 0;

set echo off
