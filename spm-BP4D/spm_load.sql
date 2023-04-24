

connect / as sysdba

VARIABLE v_plan_cnt NUMBER
EXECUTE :v_plan_cnt := DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE( sql_id => 'adjwa8r407rzc', plan_hash_value => 3534348942);

SELECT :v_plan_cnt || ' Plans loaded' from dual;

SELECT PLAN_NAME, SQL_HANDLE, ENABLED,
       FIXED, OPTIMIZER_COST,
       EXECUTIONS, ELAPSED_TIME,
       CPU_TIME, BUFFER_GETS,
       DISK_READS
  FROM DBA_SQL_PLAN_BASELINES;
