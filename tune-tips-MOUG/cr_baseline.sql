
VARIABLE sqlid := &1;
VARIABLE phv := &2;


VARIABLE v_plan_cnt NUMBER

BEGIN
   :v_plan_cnt := DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE( 
          sql_id => :sqlid,
          plan_hash_value => :phv);
END;
/

SELECT :v_plan_cnt || ' Plans loaded' from dual;

