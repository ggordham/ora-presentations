/* spm-evolve-steps.sql */

/*
  Walk through the evolution process for a SQL baseline
*/

SET ECHO OFF

PROMPT ===================== spm-evolve-steps.sql =================================

@@connect.sql

prompt
prompt We will now run an EVOLVE task manually and ask
prompt  the system to verify if the new baseline plan is
prompt  worth accepthing.
prompt Note: we have set the commit option so that if
prompt Performance criteria is meet, it is accepted (ACC).
PROMPT  Also, this script has to run as a DBA user.
prompt Press ENTER to continue
accept next1

@@spm-evolve.sql

PROMPT Note in the report that the performance improvement.
PROMPT  and note in the baseline list that the second plan is
PROMPT  now accepted.
@@list-baseline.sql

prompt Lets connect back as the perflab user and re-test our
prompt  Queries, first the value of 1,000 which should return 1 row
PROMPT  and use the NESTED LOOPS plan which is fastests for this case.
accept next1
@@connect.sql
@@spm-q1.sql 1000
@@plans.sql

PROMPT Note the plan uses, and the baseline used in the notes.
PROMPT Next we run the same query with value of 10, we need
PROMPT  to run it more than once BTW for the optimizer to
PROMPT  figure things out normally.
prompt Press ENTER to continue
accept next1

@@spm-q1.sql 10
@@spm-q1.sql 10
@@spm-q1.sql 10
@@plans.sql

PROMPT Note the different plan and the baseline used.
PROMPT  Oracle should be using HASH JOIN for this scenario
PROMPT  since most of the rows of the table are needed.
prompt

