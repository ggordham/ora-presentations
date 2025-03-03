
column name format a30
column signature format 99999999999999999999
column exact_matching_signature format 99999999999999999999
column force_matching_signature format 99999999999999999999
column sql_id format a13
column sql_text format a30
column sql_profile format a30

PROMPT Showing profiles in the system 
PROMPT  - if there are not profiles, it will show "no rows selected"
PROMPT

SELECT p.name, p.signature,
        dbms_sql_translator.sql_id( p.sql_text ) AS sql_id,
        dbms_sql_translator.sql_hash( p.sql_text ) AS sql_hash,
        type, status, force_matching,
        p.sql_text
  FROM  dba_sql_profiles p;


PROMPT Showing the SQL ID from cursor cache and if the profile was used
PROMPT  - if a profile was used for an execution in memory the name will still show
PROMPT    even if the profile has been removed.
PROMPT

SELECT sql_id, hash_value, plan_hash_value, exact_matching_signature, force_matching_signature,
       sql_profile, executions, buffer_gets, rows_processed, sql_text 
       -- sql_patch, sql_plan_baseline
  FROM v$sql
 WHERE sql_id = '&1';
