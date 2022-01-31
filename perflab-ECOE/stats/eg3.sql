set echo off
prompt Show the current system statistics values
prompt Press Enter to continue:
accept next1

@@sysstat_val.sql

set echo off
prompt Import no workload system stats
prompt Press Enter to continue:
accept next1

@@sysstat_imp_nw.sql

@@sysstat_val.sql

set echo off
prompt Import system stats collected with workload
prompt Press Enter to continue:
accept next1

@@sysstat_imp.sql

@@sysstat_val.sql
