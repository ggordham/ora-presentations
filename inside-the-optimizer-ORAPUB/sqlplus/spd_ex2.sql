/* spd_ex2.sql */

/* 
  This example walks through how a SQL Plan directive gets created.
  Here we will just use statistics feedback to have a query "change".

*/

prompt "==========================================================================="
prompt " sql plan directive no adaptive statistics"

-- make sure our query is not cached.
@@purge-cursor.sql g7vpv8bauskqf

-- purge previous SPD
@@drop_spd.sql SH CUSTOMERS

-- connect as our lab user
@@connect.sql

-- make sure adaptive statistics is off
@@set_adstat_on.sql 

PROMPT "We will run our query and then get the execution plan."
@@sqlpd_q1.sql

@@plansr.sql

PROMPT "Note that the E-ROWS and A-ROWS are out of sync, the report section of the plan"
PROMPT "  shows that a new plan will be tried on the next run based on statisicts feedback"

@@cursors.sql g7vpv8bauskqf

PROMPT "Note that the cursor is marked for re-optimization."

-- run the query again
@@sqlpd_q1.sql

@@plansr.sql

PROMPT "Note that the plan has been updated, and the E-ROWS matches the A-ROWS, this is due"
PROMPT "  dynamic smapling."

@@flush_spd.sql
@@sql_pd.sql

PROMPT "This shows the SQL Plan directive that was captured."
PROMPT " you can run @@sql_pd2.sql to see even more detail."
PROMPT " Also note that it shows that statistics are missing."

@@sqlpd_q2.sql
@@plansr.sql
PROMPT " Note that this new query now uses the same statistics feedback even though"
PROMPT "  it is a new query text since it shares the same objects."
prompt "==========================================================================="
