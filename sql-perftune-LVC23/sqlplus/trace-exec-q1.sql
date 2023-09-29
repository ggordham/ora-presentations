/* trace-exec-q1.sql */
-- used to generate a CBO trace

SET ECHO OFF

@@connect.sql

PROMPT ================= trace-exec-q1.sql ========================================
prompt Do a basic SQL execution trace
PROMPT setting trace at session level
PROMPT

SET ECHO ON

ALTER SESSION SET tracefile_identifier = '&1';

-- ALTER SESSION SET EVENTS '10046 trace name context forever, level 12';
EXEC DBMS_SESSION.SET_SQL_TRACE(sql_trace=>TRUE);

@trace-q1.sql 10

EXEC DBMS_SESSION.SET_SQL_TRACE(sql_trace=>FALSE);
-- ALTER SESSION SET EVENTS '10046 trace name context off';

SET ECHO OFF
PROMPT ============================================================================
PROMPT running TKPROF

COLUMN trace_file NEW_VALUE trace_file
SELECT value AS trace_file
      FROM v$diag_info
      WHERE name = 'Default Trace File';

HOST ${ORACLE_HOME}/bin/tkprof &trace_file ${USER}_t1_trace.out
HOST echo "Trace File: ${USER}_t1_trace.out"
PROMPT Look at the trace file listed above
PROMPT run: "host more <filename>"
PROMPT

