-- used to generate a CBO trace

connect perflab/perf$lab

ALTER SESSION SET tracefile_identifier = '&1';

ALTER SESSION SET timed_statistics = TRUE;
ALTER SESSION SET statistics_level = all;
ALTER SESSION SET max_dump_file_size = unlimited;
ALTER SESSION SET EVENTS '10053 trace name context forever, level 1';
ALTER SESSION SET EVENTS '10046 trace name context forever, level 12';

@q1 10

ALTER SESSION SET EVENTS '10053 trace name context off';
ALTER SESSION SET EVENTS '10046 trace name context off';

SELECT value
      FROM v$diag_info
      WHERE name = 'Default Trace File';

