/* tracebase-stat.sql */

/*
  Generate execution plan trace on SQL 
*/
SET ECHO OFF

PROMPT ===================== tracebase-stat.sql ===================================
@@connect.sql

-- Gather basic statistics
@@gathers-t1.sql

-- Trace with statistics
@@trace-exec-q1.sql basic

