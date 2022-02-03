
SET ECHO OFF

prompt ========================== test2 ==========================================
prompt We will run the same query many times to fill
prompt   the SQL executions.  We will also take AWR
prompt   snapshots before and after so that the SQL
prompt   plan manager will notice the SQL.
prompt Press Enter to continue:
accept next1

@@q1many

prompt
prompt Now we will drop our enhanced statistics (histograms)
prompt Press Enter to continue:
accept next1

@@droph


prompt
prompt Lets run the query again and see the plan
prompt Press Enter to continue:
accept next1

@@q1

prompt
prompt Note: that the explain plan uses NESTED LOOPS
prompt  the plan thinks it will only retrieve one row
prompt  from each table even though we know it will need
prompt  to retrive 250,000
prompt

