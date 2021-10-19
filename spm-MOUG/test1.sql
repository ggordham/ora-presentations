

connect perflab/perf$lab

PROMPT
PROMPT Enable the capture of baselines at the session level
set echo on
alter session set optimizer_capture_sql_plan_baselines = TRUE;
set echo off

prompt
prompt This first query searches for value 1000
prompt  There is only one record in the table with this value.
prompt  We are going to run it twice to create a baseline.
prompt

@q1 1000

@q1 1000

prompt  Disable baseline capture before we look at the plan.
prompt
alter session set optimizer_capture_sql_plan_baselines = FALSE;

@plan
prompt Note: that the explain plan uses Nested Loops (NL)
prompt  as there is only one row that matches in each table
prompt  Oracle only has to be read each table in full once.
prompt -> Press return to continue
accept next1

PROMPT
PROMPT We will now show that the baseline has been captured
@list
