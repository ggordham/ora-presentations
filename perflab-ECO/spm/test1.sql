
set echo off
prompt We will run two queries that are the same, 
prompt   the difference is the value we search for.
prompt   as the data in the table is skewed the access 
prompt   paths will change between the two queries.
prompt
prompt   Oracle knows the data is skewed as we collected
prompt    enhanced statistics (histograms).
prompt Press Enter to continue:
accept next1

@@q1

prompt Note: that the explain plan uses HASH JOIN
prompt  as there are lots of rows to join between
prompt  the two tables
prompt

prompt
prompt We will now run the second query.
prompt   note the difference in the plan based on the data.
prompt Press Enter to continue:
accept next1

@@q2
