/* day2-stats-auto-hist.sql */

-- look at previous auto stats job run information
/* formatting for sqlplus command line
COLUMN operation FORMAT A30
COLUMN target FORMAT A40
*/
SELECT operation, target, TO_CHAR(start_time, 'YYYY-MM-DD HH24:MI') start_time
  FROM sys.wri$_optstat_opr
  WHERE start_time > SYSDATE - 10
  ORDER BY start_time desc;

