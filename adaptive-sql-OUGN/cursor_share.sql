/* sql_cs.sql */

/* 
 Used to show cursor sharing information for a given SQL_ID.
 Note selectivity is shown as number of executions for that
 child cursor that have retrivied < 1K, > 1K < 1M, and > 1M rows
*/

SELECT * FROM (
SELECT s.sql_id, s.plan_hash_value, s.is_bind_aware AS ba, s.is_bind_sensitive AS bs,
       s.executions,
       sl.predicate, sl.range_id, sl.low, sl.high,
       h.bucket_id, h."COUNT"
  FROM V$SQL_CS_histogram h, v$sql_cs_selectivity sl, v$sql s
  where s.sql_id = '&1'
    AND s.child_number = h.child_number
    AND s.sql_id = h.sql_id
    AND s.is_bind_sensitive = 'Y'
    AND s.sql_id = sl.sql_id (+)
    AND s.child_number = sl.child_number (+)
  )
  pivot( sum("COUNT") for bucket_id in ('0' AS "<1K", '1' AS "<1M", '2' AS ">1M") );


