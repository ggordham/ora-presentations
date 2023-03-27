/* day2-stats-system.sql */
-- NOTE THESE STEPS NEED TO BE RUN AS a DBA USER!!!!

/*
-- SQLPlus settings
column sname format a14
column pname format a10
column pval2 format a18
*/

-- Look at current system statistics settings
SELECT SNAME, PNAME, PVAL1, PVAL2 FROM sys.AUX_STATS$;


-- Lets load some workload captured statistics
exec DBMS_STATS.IMPORT_SYSTEM_STATS ( statown=>'PERFLAB', stattab=>'SYS_STATS_LAB', statid=>'PERFLAB_STATS');

-- In a terminal window run sqlplus and execute the CBO trace with statistics
-- SQL> @tracebase-stat.sql
-- look at the trace file and compare the cost estimates from the previous day
-- identify how the change is system stats affects the compuatations

-- Now delete the system stats which will default back to system generated noworkload stats
exec dbms_stats.delete_system_stats();


/*
-- example of gathering system statistics

-- First create a table to hold system statistics
exec dbms_stats.create_stat_table( ownname => 'PERFLAB', stattab => 'SYS_STATS_LAB');

-- Collect no workload statistics, this could be done at any time
exec dbms_stats.gather_system_stats( gathering_mode=>'NOWORKLOAD', statown=>'perflab', stattab=>'SYS_STATS_LAB', statid=>'PERFLAB_STATS_NW');

-- Collecting workload statistics
--  Make sure the system is running a good workload, then start the capture
-- This example will capture for 10 minutes (interval)
exec dbms_stats.gather_system_stats( gathering_mode=>'INTERVAL', interval=>10, statown=>'PERFLAB', stattab=>'SYS_STATS_LAB', statid=>'PERFLAB_STATS');

-- load the system statistics from the staging table

*/

