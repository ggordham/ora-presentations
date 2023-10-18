/* unpack-spm.sql */

-- pack up all current baselines
VARIABLE v_num NUMBER 

BEGIN
 :v_num := DBMS_SPM.UNPACK_STGTAB_BASELINE(table_name => 'SPM_STGTAB', 
                                           table_owner => 'PERFLAB', 
                                           sql_handle => 'SQL_37d2d1608ca0c6f5');
END;
/

SELECT 'BASELINES Unpacked: ' || :v_num FROM DUAL;

/*
                                           plan_name => 'SQL_PLAN_3gnqjc26a1jrpceb2ac1e',
                                           origin => 'AUTO-CAPTURE',
                                           creator => 'PERFLAB',
                                           accepted => 'YES',
                                           enabled => 'YES',
                                           fixed => 'NO',
                                           module => 'SQL*Plus',

*/
