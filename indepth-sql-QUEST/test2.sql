-- test2.sql

/*

  Generate a CBO trace on SQL with no object level statistics.

*/

-- Gather statistics
prompt
prompt First we will collect basic statistics.
prompt
@gathers.sql

prompt
prompt Next we will purge the query from the cursor cache to force a hard parce.
prompt
@purge_cursor.sql c2acf73tqcbuz

prompt
prompt Finally do a Cost Based Optimizer (CBO) trace.
prompt
@trace.sql stats

prompt
prompt Look at the trace file listed above
prompt
