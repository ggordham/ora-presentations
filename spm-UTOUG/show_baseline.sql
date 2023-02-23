COLUMN creator FORMAT A10

SET ECHO ON

SELECT b.plan_name, s.sql_id, s.executions,
       TO_CHAR(s.last_active_time, 'YYYYMMDD HH24:MI:SS') last_active_time,
       b.sql_handle, b.creator, b.origin,
       TO_CHAR(b.created, 'YYYYMMDD HH24:MI:SS') created,
       TO_CHAR(b.last_executed, 'YYYYMMDD HH24:MI:SS') baseline_executed,
       TO_CHAR(b.last_verified, 'YYYYMMDD HH24:MI:SS') baseline_verified,
       b.enabled, b.accepted, b.fixed, b.optimizer_cost, s.optimizer_cost
  FROM dba_sql_plan_baselines b, v$sql s
  WHERE s.sql_plan_baseline = b.plan_name (+)
    AND s.exact_matching_signature = b.signature 
      -- assume we are using exact matching for cursor sharing
      -- s.force_matching_signature  = b.signature
  ORDER BY 5 DESC, 6 DESC;

  SET ECHO OFF
