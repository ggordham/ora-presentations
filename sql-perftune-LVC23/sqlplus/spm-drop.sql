/* spm-drop.sql */

SET ECHO ON

-- Note this drops all baselines
connect / as sysdba

DECLARE
  l_plans_dropped  PLS_INTEGER;
BEGIN

  FOR REC IN (SELECT DISTINCT SQL_HANDLE FROM DBA_SQL_PLAN_BASELINES )
--              WHERE CREATOR = 'PERFLAB')
  LOOP
      L_PLANS_DROPPED := DBMS_SPM.DROP_SQL_PLAN_BASELINE (
        sql_handle => rec.sql_handle,
        PLAN_NAME  => NULL);
  END LOOP;

END;
/
commit;

