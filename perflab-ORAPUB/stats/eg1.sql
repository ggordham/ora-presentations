set echo off
prompt ========================== eg1 ==========================================
prompt Showing table and column stats for perflab objects
prompt Press Enter to continue:
accept next1

@@ls_tab_stats.sql


set echo off
prompt Check status of automated statistics job
prompt Press Enter to continue:
accept next1
@@auto_stat

set echo off
prompt Enable or Disable the auto statistics job based on previous output
prompt run either "@en_auto_stat" or "@dis_auto_stat"


