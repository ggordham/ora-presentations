/* pack_spm.sql */

-- Create the staging table
exec DBMS_SPM.CREATE_STGTAB_BASELINE('SPM_STGTAB', 'PERFLAB');

-- pack up all current baselines
VARIABLE v_num NUMBER 

BEGIN
 :v_num := DBMS_SPM.PACK_STGTAB_BASELINE('SPM_STGTAB', 'PERFLAB');
END;
/

SELECT 'BASELINES Packed: ' || :v_num FROM DUAL;


