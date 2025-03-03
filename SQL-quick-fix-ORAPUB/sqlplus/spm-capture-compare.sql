/* spm-capture-compare.sql */

/*
  Compare the explain plans of a SQL statement in cursor cache
    and the captured baseline that was not used
*/

SET ECHO OFF

PROMPT ===================== spm-capture-compare.sql ==============================

@@connect.sql

prompt
prompt This second query looks for the value 10.
prompt  1/2 the rows rows in the table have value = 10.
prompt  We are running this three times and there should
prompt   be a new baseline captured but not accepted.
prompt Press ENTER to continue
accept next1

@@spm-q1.sql 10
@@spm-q1.sql 10
@@spm-q1.sql 10

@@plans.sql

PROMPT
PROMPT There is a better plan for this execution, but it
PROMPT  is not used as the baseline is picked up.  The
PROMPT  explain plan shows that the baseline is being
PROMPT  used in the Note section.
prompt Press ENTER to continue

accept next1

PROMPT See that we have another baseline plan captured,
PROMPT  but it is not accepted (ACC) and will not be used.
PROMPT  NOTE: this was captured even though auto capture
PROMPT  is now disabled.  Since a basline exists and is not fixed,
PROMPT  new baseline plans will be captured.
PROMPT
@@list-baseline.sql

prompt Press ENTER to continue
accept next1
PROMPT
PROMPT Lets look at the difference between the plans using
PROMPT  using the new 19c plan comparison package.
@@spm-plan-compare.sql

prompt
prompt Note: that the new explain plan uses a Hash Join with
prompt  Full Table scans.  As just over 1/2 of the table is
prompt  being accessed, a Full scan will be faster.
prompt

prompt
prompt You can also look at the script
prompt    spm-plan-compare-html.sql
prompt to see how to generate a HTML based plan comparison 
prompt report
prompt
