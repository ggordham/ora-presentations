/* unpack-spm.sql */

-- pack up all current baselines
VARIABLE v_num NUMBER 

BEGIN
 :v_num := DBMS_SPM.UNPACK_STGTAB_BASELINE(table_name => 'SPM_STGTAB', 
                                           table_owner => 'PERFLAB', 
                                           creator => 'PERFLAB' );
END;
/

SELECT 'BASELINES Unpacked: ' || :v_num FROM DUAL;


