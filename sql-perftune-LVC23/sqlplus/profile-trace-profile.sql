/* profile-trace-profile.sql */

/* 
  do a CBO trace on a query to show that the profile modifies the SQL with hints
*/

set echo off

PROMPT ===================== profile-trace-profile.sql ============================

@@connect.sql

PROMPT
PROMPT First we will run the test query and show the explain plan
PROMPT

@@profile-q1.sql
@@plans.sql

PROMPT
PROMPT  Now we will purge the query from cache and perform a 
PROMPT   CBO trace to show that the query is not modified.
PROMPT -> Press return to continue
ACCEPT next1

@@profile-get-sql-id.sql
@@purge_cursor &prev_sql_id
@@tracecbo-profile.sql profile

