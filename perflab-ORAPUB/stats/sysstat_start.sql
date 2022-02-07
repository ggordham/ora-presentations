exec dbms_stats.gather_system_stats( gathering_mode=>'INTERVAL', interval=>10, statown=>'PERFLAB', stattab=>'SYS_STATS_LAB', statid=>'PERFLAB_STATS');

