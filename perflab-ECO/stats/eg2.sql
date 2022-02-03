set echo off
prompt ========================== eg2 ==========================================
prompt Change scheduled window for auto stats job
prompt  set for Monday at 5am
prompt Press Enter to continue:
accept next1

@@sched_auto_stat


set echo off
prompt Set percent stale for PERFLAB.EMPLOYEES table to 12%
prompt Press Enter to continue:
accept next1

@@perf_stat_level

set echo off
prompt Show tables with stale stats
prompt Press Enter to continue:
accept next1

@@chk_stale_stats
