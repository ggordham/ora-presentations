/* profile-get-sql-id.sql */

set echo off

@@profile-q1.sql

COLUMN prev_sql_id NEW_VALUE prev_sql_id

SELECT ses.prev_sql_id
   FROM  v$session ses
   WHERE ses.sid = USERENV('sid') 
     AND ses.username IS NOT NULL 
     AND ses.prev_hash_value <> 0
     AND rownum < 2;


