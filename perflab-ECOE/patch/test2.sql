-- Test 2
-- ======
SET ECHO OFF

prompt Lets drop the patch and do another test
prompt Press Enter to continue:
accept next1
connect / as sysdba
@drop
--
-- Execute our test query "q1"
-- It has a "stupid" USE_HASH hint
--
prompt Test 2 lets force a hash join with a hint
prompt Press Enter to continue:
accept next1
@q1
--
-- Let's stop it using the hint!
--
prompt Now lets patch the SQL to not use the hash join
prompt   and instead use nested loop
prompt Press Enter to continue:
accept next1
@patchq1_nohint
--
-- It now uses nested loop join...
--
prompt Lets run the query and see the nested loop
prompt Press Enter to continue:
accept next1
@q1

