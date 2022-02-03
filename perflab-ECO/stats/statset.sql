
column cascade format a30
column degree format a5
column est_pct format a30
column concurrent format a10
column auto_max_run format a10
column stats_method_opt format a30

SELECT DBMS_STATS.GET_PREFS( pname => 'CASCADE') AS cascade,
       DBMS_STATS.GET_PREFS( pname => 'ESTIMATE_PERCENT') AS est_pct,
       DBMS_STATS.GET_PREFS( pname => 'DEGREE') AS degree,
       DBMS_STATS.GET_PREFS( pname => 'CONCURRENT') AS concurrent,
       DBMS_STATS.GET_PREFS( pname => 'AUTO_TASK_MAX_RUN_TIME') AS auto_max_run,
       DBMS_STATS.GET_PREFS( pname => 'METHOD_OPT') AS stats_method_opt
  FROM DUAL;

