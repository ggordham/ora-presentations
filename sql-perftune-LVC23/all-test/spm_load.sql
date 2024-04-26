

connect / as sysdba

VARIABLE v_plan_cnt NUMBER
EXECUTE :v_plan_cnt := DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE( sql_id => 'bmsrqwujh3t64', plan_hash_value => 348740170);

SELECT :v_plan_cnt || ' Plans loaded' from dual;

SELECT PLAN_NAME, SQL_HANDLE, ENABLED,
       FIXED, OPTIMIZER_COST,
       EXECUTIONS, ELAPSED_TIME,
       CPU_TIME, BUFFER_GETS,
       DISK_READS
  FROM DBA_SQL_PLAN_BASELINES;
