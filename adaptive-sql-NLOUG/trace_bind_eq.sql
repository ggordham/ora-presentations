/* trace_bind_eq.sql */

ALTER SESSION SET tracefile_identifier = 'bineq_full';

ALTER SESSION SET timed_statistics = TRUE;
ALTER SESSION SET statistics_level = all;
ALTER SESSION SET max_dump_file_size = unlimited;
ALTER SESSION SET EVENTS '10046 trace name context forever, level 12';
--ALTER SESSION SET EVENTS '10507 trace name context forever, level 512';
-- note need to use 4294967295 to see the bind eq info spelled out
ALTER SESSION SET EVENTS '10507 trace name context forever, level 4294967295';

select /*+ gather_plan_statistics */ grp_name, max(id), sum(price) from acs_test a where grp_name = :grp GROUP BY grp_name;
select /*+ gather_plan_statistics */ grp_name, max(id), sum(price) from acs_test a where grp_name = :grp GROUP BY grp_name;
select /*+ gather_plan_statistics */ grp_name, max(id), sum(price) from acs_test a where grp_name = :grp GROUP BY grp_name;
select /*+ gather_plan_statistics */ grp_name, max(id), sum(price) from acs_test a where grp_name = :grp GROUP BY grp_name;

ALTER SESSION SET EVENTS '10507 trace name context off';
ALTER SESSION SET EVENTS '10046 trace name context off';

PROMPT Look at the trace file that is listed
SELECT value, 'host more ' || value AS command_to_run
      FROM v$diag_info
      WHERE name = 'Default Trace File';

