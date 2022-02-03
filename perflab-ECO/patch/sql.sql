set pagesize 100

connect / as sysdba

set echo on

select sql_id,sql_text 
from v$sqlarea 
where sql_text like '%PATCHTEST%'
/

set echo off

