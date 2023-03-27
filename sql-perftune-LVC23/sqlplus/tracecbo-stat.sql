/* tracecbo-stat.sql */

/*
  Generate a CBO trace on SQL with basic object level statistics.
*/
SET ECHO OFF

PROMPT ===================== tracecbo-stat.sql ====================================
@@connect.sql

-- Gather basic statistics
@@gathers-t1.sql

-- Purge the cursor 
@@purge_cursor.sql c2acf73tqcbuz

-- Trace with statistics
@@tracecbo-q1.sql stats

