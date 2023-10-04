/* patch-q0-full */

/* 
  patch a SQL to force a full table scan
  
*/

set echo off

PROMPT ===================== patch-q0-full.sql ====================================

@@connect.sql

PROMPT
PROMPT First we will run the test query and show the explain plan
PROMPT  note that the execution plan uses and index
PROMPT
@@patch-q0.sql
@@plan.sql

PROMPT
PROMPT Lets add a hint to force a full table scan
PROMPT  this gives us the information needed to create the patch
PROMPT Press Enter to continue:
ACCEPT next1
@@patch-q0full.sql
@@plan-basic.sql

PROMPT
PROMPT Lets create a patch that forces full table scan
PROMPT Press Enter to continue:
ACCEPT next1
@@patch-get-sql-id.sql patch-q0.sql
@@patch-create-q0.sql &prev_sql_id


PROMPT
PROMPT Run the same SQL and show that the patch forces
PROMPT  a full table scan
PROMPT Press Enter to continue:
ACCEPT next1
@@connect.sql
@@patch-q0.sql
@@plan-basic.sql

PROMPT
PROMPT Lets look at what patches exist
PROMPT
@@list-patch.sql

PROMPT
PROMPT Lets see the patch embeded hint
PROMPT
@@patch-see-hint.sql &prev_sql_id

