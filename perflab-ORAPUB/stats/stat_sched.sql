/* stat_sched.sql */

-- Lists the current schedule for maint window jobs

PROMPT
PROMPT Auto Stats Job status and some RUN metrics
PROMPT

SELECT client_name, status, window_group, 
        mean_job_duration, mean_job_cpu
  FROM dba_autotask_client
  WHERE client_name = 'auto optimizer stats collection';

PROMPT
PROMPT Current Maint job schedule execution windows
PROMPT

SELECT c.window_name, c.autotask_status, c.optimizer_stats,
       w.enabled,
       w.start_date, w.repeat_interval,
       w.duration, w.next_start_date, w.last_start_date
  FROM dba_autotask_window_clients c, dba_scheduler_windows w
  WHERE c.window_name = w.window_name;

      
/* end */
