
column owner format a15
column table_name format a30
set echo on


select owner, table_name, stale_stats, last_analyzed
  from dba_tab_statistics
  where stale_stats='YES'
    and owner not in ('SYS','SYSTEM');
