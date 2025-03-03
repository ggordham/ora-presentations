/* gatherh-t1.sql */

--
-- Gather statistics with histograms
--

PROMPT ============================================================================
@@connect.sql

SET ECHO ON

exec dbms_stats.gather_table_stats(user,'t1',method_opt=>'for all columns size 254',no_invalidate=>false)
exec dbms_stats.gather_table_stats(user,'t2',method_opt=>'for all columns size 254',no_invalidate=>false)

SET ECHO OFF

