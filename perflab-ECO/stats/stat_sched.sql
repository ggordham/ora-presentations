/* stat_sched.sql */

-- Lists the current schedule for maint window jobs

PROMPT
PROMPT Auto Stats Job status and some RUN metrics
PROMPT


COLUMN client_name FORMAT a35
COLUMN window_group FORMAT a25
COLUMN mean_job_duration FORMAT a40
COLUMN mean_job_cpu FORMAT a40

SELECT client_name, status, window_group, 
        mean_job_duration, mean_job_cpu
  FROM dba_autotask_client
  WHERE client_name = 'auto optimizer stats collection';

PROMPT
PROMPT Current Maint job schedule execution windows
PROMPT

set linesize 240
set pagesize 100
COLUMN window_name FORMAT a25
COLUMN start_date FORMAT a20
COLUMN repeat_interval FORMAT a55
COLUMN duration FORMAT a20
COLUMN next_start_date FORMAT a40
COLUMN last_start_date FORMAT a40

SELECT c.window_name, c.autotask_status, c.optimizer_stats,
       w.enabled,
       w.start_date, w.repeat_interval,
       w.duration, w.next_start_date, w.last_start_date
  FROM dba_autotask_window_clients c, dba_scheduler_windows w
  WHERE c.window_name = w.window_name;

      
/* end */
