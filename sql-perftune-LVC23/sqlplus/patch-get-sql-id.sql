/* profile-get-sql-id.sql */

set echo off

-- pass in the file with the SQL statement
@@&1

COLUMN prev_sql_id NEW_VALUE prev_sql_id

SELECT ses.prev_sql_id
   FROM  v$session ses
   WHERE ses.sid = USERENV('sid') 
     AND ses.username IS NOT NULL 
     AND ses.prev_hash_value <> 0
     AND rownum < 2;


