/* patch-q2-copy.sql */

/* 
  patch a SQL to ignore embeded hints
  
*/

set echo off

PROMPT ===================== patch-q2-copy.sql ====================================

@@connect.sql

PROMPT
PROMPT First we will run the test query and show that index lookup is used
PROMPT  for the tab2
PROMPT
@@patch-q2.sql
@@plan.sql

PROMPT
PROMPT Now we will run the same query with a hint added to force a full table
PROMPT  scan for tab2
PROMPT
@@patch-q3.sql
@@plan.sql


PROMPT
PROMPT We will re-run each SQL to get their SQL IDs and then 
PROMPT   create a patch that copies the execution plan for the full table scan
PROMPT   on tab2 to the q2 query which does not have the hint added.
PROMPT Press Enter to continue:
ACCEPT next1
@@patch-get-sql-id.sql patch-q2.sql
DEFINE q2_sql_id = '&prev_sql_id'
@@patch-get-sql-id.sql patch-q3.sql
DEFINE q3_sql_id = '&prev_sql_id'
@@patch-create-q2.sql &q2_sql_id &q3_sql_id


PROMPT
PROMPT Run the same SQL and show that the patch uses nested loop join
PROMPT Press Enter to continue:
ACCEPT next1
@@connect.sql
@@patch-q2.sql
@@plan.sql

PROMPT
PROMPT Lets look at what patches exist
PROMPT
@@list-patch.sql

