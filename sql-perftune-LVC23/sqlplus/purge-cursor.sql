/* purge_cursor.sql */

SET ECHO OFF
PROMPT ============================================================================
PROMPT Puging cursor SQL_ID &1
PROMPT   Note: this will force a hard parse which is requird for CBO tracing
PROMPT   Note: connecting as SYSDBA user to do this
PROMPT
connect / as sysdba

COLUMN cur_address NEW_VALUE cur_address
COLUMN has_value NEW_VALUE hash_value

SET ECHO ON

select address||','||hash_value as cur_address
   from gv$sqlarea 
   where sql_id='&1';

exec dbms_shared_pool.purge('&cur_address','C');

SET ECHO OFF

