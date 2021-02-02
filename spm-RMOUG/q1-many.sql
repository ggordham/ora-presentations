connect perflab/perf$lab

set timing on
set echo off
set feedback off

DECLARE
  s_stmt VARCHAR2(1000 CHAR);
  n1 NUMBER(10);
  n2 NUMBER(10);
  p1 NUMBER(10);
BEGIN

  s_stmt := 'SELECT /*+ gather_plan_statistics NO_ADAPTIVE_PLAN */ sum(t1.c), sum(t2.c) FROM t1, t2 WHERE t1.a = t2.a AND t1.d = :idnum' ;

  p1 := &1;

  FOR i IN 1..100
  LOOP
     EXECUTE IMMEDIATE s_stmt INTO n1, n2 USING IN p1 ;
  END LOOP;
END;
/

set timing off
set echo on
set feedback on
