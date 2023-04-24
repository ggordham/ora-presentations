
-- VARIABLE sqlid := &1;
-- VARIABLE phv := &2;

set echo on

VARIABLE v_plan_cnt NUMBER

BEGIN
   :v_plan_cnt := DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE( 
          sql_id => '&1',
          plan_hash_value => '&2');
END;
/

SELECT :v_plan_cnt || ' Plans loaded' from dual;

set echo off
