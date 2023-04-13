/* spm-load-cursor.sql */


-- Note this needs to be run by a user that has access to cursor cache
connect / as sysdba

-- Note update the SQL_ID and PLAN_HASH_VALUE as appropriate 
VARIABLE v_plan_cnt NUMBER
EXECUTE :v_plan_cnt := DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE( sql_id => '19nmwtxrh5rf1', plan_hash_value => 3321871023);

SELECT :v_plan_cnt || ' Plans loaded' from dual;

SELECT PLAN_NAME, SQL_HANDLE, ENABLED,
       FIXED, OPTIMIZER_COST,
       EXECUTIONS, ELAPSED_TIME,
       CPU_TIME, BUFFER_GETS,
       DISK_READS
  FROM DBA_SQL_PLAN_BASELINES;


