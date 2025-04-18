/* top_sql_ash_30_min.sql */

SELECT sql_id, 
       SUM(DECODE(session_state,'ON CPU',1,0)) oncpu_samples,
       SUM(DECODE(session_state,'WAITING',1,0)) waiting_samples
  FROM v$active_session_history
  WHERE  sample_time >= current_timestamp - interval '30' minute
  GROUP BY sql_id
  HAVING SUM(DECODE(session_state,'ON CPU',1,0)) > 10
  ORDER BY 2 DESC;

