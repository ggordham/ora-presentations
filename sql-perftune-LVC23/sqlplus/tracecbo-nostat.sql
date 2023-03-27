/* tracecbo-nostat.sql */

/*

  Generate a CBO trace on SQL with no object level statistics.

*/

SET ECHO OFF

PROMPT ===================== tracecbo-nostat.sql ==================================
@@connect.sql

-- Drop statistics
@@drop-t1-stat.sql

-- Purge the cursor 
@@purge_cursor.sql c2acf73tqcbuz

-- Trace with no statistics
@@tracecbo-q1.sql nostats

