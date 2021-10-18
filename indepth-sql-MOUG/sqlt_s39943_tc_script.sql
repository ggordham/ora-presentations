REM $Header: 215187.1 sqlt_s39943_tc_script.sql 19.1.200226 2021/03/09 abel.macias $

WHENEVER SQLERROR CONTINUE;


WHENEVER SQLERROR EXIT SQL.SQLCODE;

VAR   IDNUM                           NUMBER;
EXEC :IDNUM                           := 1000;


SELECT /*+ gather_plan_statistics NO_ADAPTIVE_PLAN */ /* ^^unique_id */  sum(t1.c), sum(t2.c) FROM t1, t2 WHERE t1.a = t2.a AND t1.d = :idnum;
