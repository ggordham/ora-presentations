/* trace-exec-q1.sql */
-- used to generate a CBO trace

SET ECHO OFF

connect perflab/perf$lab&con_pdb

PROMPT ================= trace-exec-q1.sql ========================================
prompt Do a basic SQL execution trace
PROMPT setting trace at session level
PROMPT

SET ECHO ON

ALTER SESSION SET tracefile_identifier = '&1';

-- ALTER SESSION SET EVENTS '10046 trace name context forever, level 12';
EXEC DBMS_SESSION.SET_SQL_TRACE(sql_trace=>TRUE);

@q1.sql 10

EXEC DBMS_SESSION.SET_SQL_TRACE(sql_trace=>FALSE);
-- ALTER SESSION SET EVENTS '10046 trace name context off';

SET ECHO OFF
PROMPT ============================================================================
PROMPT running TKPROF

COLUMN trace_file NEW_VALUE trace_file
SELECT value AS trace_file
      FROM v$diag_info
      WHERE name = 'Default Trace File';

HOST ${ORACLE_HOME}/bin/tkprof &trace_file tkprof_t1_trace.out
HOST echo "TKProf output File: tkprof_t1_trace.out"
PROMPT Look at the trace file listed above
PROMPT run: "host more <filename>"
PROMPT

