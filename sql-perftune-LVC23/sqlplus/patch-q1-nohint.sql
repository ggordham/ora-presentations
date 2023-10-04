/* patch-q1-nohint.sql */

/* 
  patch a SQL to ignore embeded hints
  
*/

set echo off

PROMPT ===================== patch-q1-nohint.sql ==================================

@@connect.sql

PROMPT
PROMPT First we will run the test query and show the hash join is in use
PROMPT
@@patch-q1.sql
@@plan-basic.sql

PROMPT
PROMPT Lets create a patch that ignores the embeded hint
PROMPT Press Enter to continue:
ACCEPT next1
@@patch-get-sql-id.sql patch-q1.sql
@@patch-create-q1.sql &prev_sql_id


PROMPT
PROMPT Run the same SQL and show that the patch uses nested loop join
PROMPT Press Enter to continue:
ACCEPT next1
@@connect.sql
@@patch-q1.sql
@@plan-basic.sql

PROMPT
PROMPT Lets look at what patches exist
PROMPT
@@list-patch.sql

