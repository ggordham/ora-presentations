-- used to generate a CBO trace
SET DEFINE ON
@@connect.sql

ALTER SESSION SET tracefile_identifier = '&1';

ALTER SESSION SET timed_statistics = TRUE;
ALTER SESSION SET statistics_level = all;
ALTER SESSION SET max_dump_file_size = unlimited;
ALTER SESSION SET EVENTS '10053 trace name context forever, level 1';
ALTER SESSION SET EVENTS '10046 trace name context forever, level 12';

@q1 

ALTER SESSION SET EVENTS '10053 trace name context off';
ALTER SESSION SET EVENTS '10046 trace name context off';

PROMPT Look at the trace file that is listed
SELECT value, 'host more ' || value AS command_to_run
      FROM v$diag_info
      WHERE name = 'Default Trace File';
