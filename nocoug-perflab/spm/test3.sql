
prompt We will now run the SQL Plan Management job
prompt   and accept the suggested plan baseline.
prompt Press Enter to continue:
accept next1

@@spm


prompt
prompt Lets run the query again and see the plan
prompt Press Enter to continue:
accept next1

@@q1

prompt
prompt Note: that the explain plan now uses HASH JOIN
prompt  as we have put a baseline in place.
prompt  to retrive 25,000
prompt


prompt
prompt Lets list the baseline information, and show
prompt   the explain plan for the given baseline
prompt Press Enter to continue:
accept next1
@@list

@@baseplan
