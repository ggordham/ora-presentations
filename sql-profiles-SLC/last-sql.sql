/* last-sql.sql */

column exact_matching_signature format 99999999999999999999999
column force_matching_signature format 99999999999999999999999

SELECT ses.prev_sql_id, exact_matching_signature, force_matching_signature,
       plan_hash_value, sql.sql_text 
   FROM  v$session ses, v$sql sql
   WHERE ses.sid = USERENV('sid') 
     AND ses.username IS NOT NULL 
     AND ses.prev_hash_value <> 0
     AND ses.prev_sql_id = sql.sql_id;

-- END
