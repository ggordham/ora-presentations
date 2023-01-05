/* awr_settings.sql */

/*
  Used to display the current AWR snapshot settings.
  Update these settings using the 
     dbms_workload_repository.modify_snapshot_settings function
*/

set echo off

column src_dbname format a12

PROMPT
PROMPT Each PDB will have unique settings
PROMPT Intervals are in minutes, 11,520 = 8 days
PROMPT

SELECT
  src_dbname,
  extract( day from snap_interval) *24*60+
    extract( hour from snap_interval) *60+
    extract( minute from snap_interval ) "Snapshot Interval",
  extract( day from retention) *24*60+
    extract( hour from retention) *60+
    extract( minute from retention ) "Retention Interval",
  topnsql
FROM
   dba_hist_wr_control;

PROMPT
PROMPT TOPNSQL DEFAULT based on statistics level typical=30, all=100
PROMPT      Can also be set to MAXIMUM to capture all SQL in cursor cache
PROMPT      If set to a number, then capture that number of statements
PROMPT

set echo on

/* END */
