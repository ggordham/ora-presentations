/* spm-auto-capture.sql */

/*
  auto capture a baseline by running a SQL statement
*/

set echo off

PROMPT ===================== spm-auto-capture.sql =================================

@@connect.sql

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

@@spm-q1.sql 1000

@@spm-q1.sql 1000

prompt  Disable baseline capture before we look at the plan.
prompt
set echo on
alter session set optimizer_capture_sql_plan_baselines = FALSE;
set echo off

@@plans.sql
prompt Note: that the explain plan uses Nested Loops (NL)
prompt  as there is only one row that matches in each table
prompt  Oracle only has to be read the table in full once.
prompt  While using an index to lookup the second single row.
prompt -> Press return to continue
accept next1

PROMPT
PROMPT We will now show that the baseline has been captured
@@list-baseline.sql

PROMPT Note that the baseline is based on SQL_HANDLE not on SQL_ID
