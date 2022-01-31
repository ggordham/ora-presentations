-- Test 3
-- ======
prompt Test 3 we will no copy a patch from on SQL to another
prompt Press Enter to continue:
accept next1
connect / as sysdba
@drop
-- 
-- Run q2 - and notice it uses index on TAB2 (TAB2TYI)
--
prompt Query 2 will use an index TAB2TYI on table TAB2
prompt Press Enter to continue:
accept next1
@q2
--
-- Take a look at "q3". It is the same as q2 but
-- it has a hint to give us a FULL scan on TAB2
--
prompt Query 3 same as q2 but we have hinted it for a full table scan
prompt Press Enter to continue:
accept next1
@q3
--
-- It looks like we can use FULL(@"SEL$5DA710D3" "TAB2"@"SEL$2")
-- if we want to make q2 use the same plan.
-- Instead, let's just copy the whole outline from q3 and
-- apply to q2.
-- We can see the SQL_ID's we must use...
--
prompt Lets get the SQL_ID of the SQL statements so we can copy
prompt  the outline from one SQL to another
prompt Press Enter to continue:
accept next1
@sql
-- 
-- Now copy...
--
@copy
--
-- q2 now uses a FULL scan on TAB2
--
@q2

