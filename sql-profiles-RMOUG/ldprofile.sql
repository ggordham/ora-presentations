COLUMN v_profile_name new_value v_profile_name 

SELECT DISTINCT obj_name AS v_profile_name 
  FROM perflab.sql_prof_stage;

EXEC DBMS_SQLTUNE.UNPACK_STGTAB_SQLPROF ( profile_name => '&v_profile_name', replace => TRUE, staging_table_name  => 'sql_prof_stage', staging_schema_owner => 'perflab' );

