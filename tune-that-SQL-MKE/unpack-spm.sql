/* unpack_spm.sql */

-- pack up all current baselines
VARIABLE v_num NUMBER 

BEGIN
 :v_num := DBMS_SPM.UNPACK_STGTAB_BASELINE('SPM_STGTAB', 'PERFLAB');
END;
/

SELECT 'BASELINES Unpacked: ' || :v_num FROM DUAL;


