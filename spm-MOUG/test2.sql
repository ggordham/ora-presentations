


-- connect perflab/perf$lab

prompt
prompt This second query looks for the value 10.
prompt  1/2 the rows rows in the table have value = 10.
prompt  We are running this three times and there should
prompt   be a new baseline captured but not accepted.
prompt Press ENTER to continue
accept next1

@q1 10
@q1 10
@q1 10

@plan

PROMPT
PROMPT There is a better plan for this execution, but it
PROMPT  is not used as the profile is picked up.  The
PROMPT  explain plan shows that the profile is being
PROMPT  used in the Note section.
prompt Press ENTER to continue

accept next1

PROMPT See that we have another baseline plan captured,
PROMPT  but it is not accepted (ACC) and will not be used.
PROMPT  NOTE: this was captured even though auto capture
PROMPT  is now disabled.  Since a basline exists and is not fixed,
PROMPT  new baseline plans will be captured.
PROMPT
@list

prompt Press ENTER to continue
accept next1
PROMPT
PROMPT Lets look at the difference between the plans using
PROMPT  using the new 19c plan comparison package.
@spm-compare

prompt
prompt Note: that the new explain plan uses a Hash Join with
prompt  Full Table scans.  As just over 1/2 of the table is
prompt  being accessed, a Full scan will be faster.
prompt
