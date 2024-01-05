

var idnum number

exec :idnum := &1;

set timing on
set echo on

/*
  This SQL is for readability.
  To keep the SQL ID the same the formating has been removed

SELECT sum(t1.c), sum(t2.c)
  FROM t1, t2
  WHERE t1.a = t2.a
   AND t1.d = :idnum;
*/

SELECT /*+ gather_plan_statistics NO_ADAPTIVE_PLAN USE_HASH(t2) */ sum(t1.c), sum(t2.c) FROM t1, t2 WHERE t1.a = t2.a AND t1.d = :idnum;

set echo off
set timing off
