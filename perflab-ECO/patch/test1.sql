-- Test 1
-- ======
connect / as sysdba
@drop
connect perflab/perf$lab
--
-- Execute our test query
-- It uses an index
--
prompt TEST 1 For this query the plan uses an index
prompt Press Enter to continue:
accept next1

@q0
-- Exeute the same query, but this time
-- with a hint to make is FULL scan.
-- We'll take a look at the outline to
-- see what hint we can use to force the
-- first test query to use a FULL scan 
-- rather than the index.
prompt Lets add a hint to force a full table scan
prompt  this gives us the information needed to create the patch
prompt Press Enter to continue:
accept next1
@q0full
--
-- Let's patch the "q0.sql" query with
-- FULL(@"SEL$1" "TAB1"@"SEL$1") to make it
-- scan the table
--
prompt Lets create a patch that forces full table scan
prompt Press Enter to continue:
accept next1
@patchq0
--
-- Check to see if this query now uses the patch
-- and no longer uses the index...
--
@q0
@look

