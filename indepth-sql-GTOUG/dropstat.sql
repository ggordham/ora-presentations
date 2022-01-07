connect perflab/perf$lab

set echo on

exec dbms_stats.delete_table_stats(user,'t1',no_invalidate=>false);
exec dbms_stats.delete_table_stats(user,'t2',no_invalidate=>false);

exec dbms_stats.delete_index_stats(user,'t1i',no_invalidate=>false);
exec dbms_stats.delete_index_stats(user,'t2i',no_invalidate=>false);
set echo off

