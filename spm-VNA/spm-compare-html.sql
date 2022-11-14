 

VARIABLE v_rep CLOB

DECLARE
    v_sql_handle VARCHAR2(30);
    v_plan_name1 VARCHAR2(128);
    v_plan_name2 VARCHAR2(128);

BEGIN

  -- Note these are very poorly formed SQL's just for this demonstration
  SELECT DISTINCT sql_handle INTO v_sql_handle
    FROM dba_sql_plan_baselines;
  SELECT plan_name INTO v_plan_name1 
    FROM dba_sql_plan_baselines
   WHERE accepted = 'YES';
  SELECT plan_name INTO v_plan_name2
    FROM dba_sql_plan_baselines
   WHERE accepted = 'NO';

  :v_rep := DBMS_XPLAN.COMPARE_PLANS( 
    reference_plan =>  spm_object(v_sql_handle, v_plan_name1), 
    compare_plan_list => plan_object_list(spm_object(v_sql_handle, v_plan_name2)),
    type => 'HTML', 
    level => 'ALL', 
    section => 'ALL');
END;
/


SET PAGESIZE 50000
SET LONG 100000
SET LINESIZE 210
COLUMN report FORMAT a200

set termout off feedback off
spool sql_plan_compare.html

SELECT :v_rep REPORT FROM DUAL;

spool off
