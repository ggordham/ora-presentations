/* tracecbo-profile.sql */

SET ECHO OFF

@@connect.sql

PROMPT ============================================================================
prompt Do a Cost Based Optimizer (CBO) trace.
PROMPT setting trace at session level
PROMPT

SET ECHO ON

ALTER SESSION SET tracefile_identifier = '&1';

ALTER SESSION SET timed_statistics = TRUE;
ALTER SESSION SET statistics_level = all;
ALTER SESSION SET max_dump_file_size = unlimited;
ALTER SESSION SET EVENTS '10053 trace name context forever, level 1';
ALTER SESSION SET EVENTS '10046 trace name context forever, level 12';

@@profile-q1.sql

ALTER SESSION SET EVENTS '10053 trace name context off';
ALTER SESSION SET EVENTS '10046 trace name context off';

SET ECHO OFF
PROMPT ============================================================================
PROMPT Look at the trace file that is listed
SELECT value, 'host more ' || value AS command_to_run
      FROM v$diag_info
      WHERE name = 'Default Trace File';

PROMPT Look at the trace file listed above
PROMPT run: "host more <filename>"
PROMPT

