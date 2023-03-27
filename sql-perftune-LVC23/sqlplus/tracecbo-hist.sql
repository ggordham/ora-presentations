/* tracecbo-hist.sql */

/*
  Generate a CBO trace on SQL with object level histogram statistics.
*/

SET ECHO OFF

PROMPT ===================== tracecbo-hist.sql ====================================
@@connect.sql

-- Gather statistics with histograms
@@gatherh-t1.sql

-- Purge the cursor 
@@purge_cursor.sql c2acf73tqcbuz

-- Trace with no statistics
@@tracecbo-q1.sql histogram

