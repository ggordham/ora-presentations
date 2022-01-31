column signature format 9999999999999999999999
column exact_matching_signature format 9999999999999999999999
column name format a10
column sql_text format a60
column sql_patch format a15
column status format a15
set linesize 300
set trims on

prompt Lets show the patch is in place
prompt Press Enter to continue:
accept next1

set echo on
select name, signature, sql_text,status from dba_sql_patches;
set echo off

prompt Lets see if the patch is being used by looking at V$SQL
prompt Press Enter to continue:
accept next1

set echo on
select sql_text,sql_patch,exact_matching_signature
from   v$sqlarea
where  sql_patch is not null
order  by 1;
set echo off

