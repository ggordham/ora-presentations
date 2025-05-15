/* stale_obj_stats.sql */

column owner format a15
column table_name format a30
set echo on


SELECT ts.owner, ts.table_name, ts.stale_stats, ts.last_analyzed
  FROM dba_tab_statistics ts, dba_users u
  WHERE ts.stale_stats='YES'
    AND ts.owner = u.username
    AND u.oracle_maintained = 'N';

