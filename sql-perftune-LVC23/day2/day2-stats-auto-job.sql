/* day2-stats-auto-job.sql */

/*
-- SQLPlus settings
set pagesize 100
COLUMN client_name FORMAT a35
COLUMN window_group FORMAT a25
COLUMN mean_job_duration FORMAT a40
COLUMN mean_job_cpu FORMAT a40
COLUMN window_name FORMAT a25
COLUMN start_date FORMAT a20
COLUMN repeat_interval FORMAT a55
COLUMN duration FORMAT a20
COLUMN next_start_date FORMAT a40
COLUMN last_start_date FORMAT a40
COL OWNER FORMAT a10
COL TABLE_NAME FORMAT a20
COL PREFERENCE_NAME FORMAT a24
COL PREFERENCE_VALUE FORMAT a40
*/

-- Check if the auto job is enabled and some history
SELECT client_name, status, window_group, 
        mean_job_duration, mean_job_cpu
  FROM dba_autotask_client
  WHERE client_name = 'auto optimizer stats collection';

-- to check the status of specifc days that the job occurs
SELECT window_name, window_next_time, optimizer_stats 
  FROM dba_autotask_window_clients;

-- Show the scheduled windows for the auto job
SELECT c.window_name, c.autotask_status, c.optimizer_stats,
       w.enabled,
       w.start_date, w.repeat_interval,
       w.duration, w.next_start_date, w.last_start_date
  FROM dba_autotask_window_clients c, dba_scheduler_windows w
  WHERE c.window_name = w.window_name;

-- Show the current system wide prefernces 
SELECT DBMS_STATS.GET_PREFS( pname => 'CASCADE') AS cascade,
       DBMS_STATS.GET_PREFS( pname => 'ESTIMATE_PERCENT') AS est_pct,
       DBMS_STATS.GET_PREFS( pname => 'DEGREE') AS degree,
       DBMS_STATS.GET_PREFS( pname => 'CONCURRENT') AS concurrent,
       DBMS_STATS.GET_PREFS( pname => 'AUTO_TASK_MAX_RUN_TIME') AS auto_max_run,
       DBMS_STATS.GET_PREFS( pname => 'METHOD_OPT') AS stats_method_opt,
       DBMS_STATS.GET_PREFS( pname => 'STALE_PERCENT') AS stale_pct
  FROM DUAL;

/* 
-- To disable the auto stats job
BEGIN 
    DBMS_AUTO_TASK_ADMIN.DISABLE (
            client_name => 'auto optimizer stats collection' , 
            operation => NULL, 
            window_name => NULL);
END;
/

-- to enable run DBMS_AUTO_TASK_ADMIN.ENABLE with the same parameters
*/

/* 
-- change the timeing of a maitinance window for Monday to 5am
BEGIN 
    DBMS_SCHEDULER.SET_ATTRIBUTE (
            name => 'MONDAY_WINDOW',
            attribute => 'repeat_interval',
            value => 'freq=daily;byday=MON;byhour=05;byminute=0;bysecond=0' );
END; 
/
*/

-- set preferences on a specific object
EXEC DBMS_STATS.SET_TABLE_PREFS('PERFLAB', 'EMPLOYEES', 'STALE_PERCENT', '12');

-- See that the preferences are now set
SELECT * FROM DBA_TAB_STAT_PREFS WHERE OWNER = 'PERFLAB';

-- set the preferences on a specific object back to default
EXEC DBMS_STATS.SET_TABLE_PREFS('PERFLAB', 'EMPLOYEES', 'STALE_PERCENT', NULL);
