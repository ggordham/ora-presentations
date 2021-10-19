
connect perflab/perf$lab

VARIABLE v_rep CLOB

DECLARE
    v_sql_handle VARCHAR2(30);

BEGIN

  -- Note these are very poorly formed SQL's just for this demonstration
  SELECT DISTINCT sql_handle INTO v_sql_handle
    FROM dba_sql_plan_baselines;

  :v_rep := DBMS_SPM.EVOLVE_SQL_PLAN_BASELINE(
    sql_handle => v_sql_handle,
    time_limit => DBMS_SPM.AUTO_LIMIT,
    verify => 'YES',
    commit => 'YES');

END;
/


SET PAGESIZE 50000
SET LONG 100000
SET LINESIZE 210
COLUMN report FORMAT a200
SELECT :v_rep REPORT FROM DUAL;
