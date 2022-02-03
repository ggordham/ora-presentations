-- For gathering stats with no workload
exec dbms_stats.gather_system_stats( gathering_mode=>'NOWORKLOAD', statown=>'perflab', stattab=>'SYS_STATS_LAB', statid=>'PERFLAB_STATS_NW');


