DROP TABLE perflab.sql_prof_stage;

EXEC DBMS_SQLTUNE.CREATE_STGTAB_SQLPROF ( table_name  => 'sql_prof_stage', schema_name => 'perflab' );

COLUMN v_profile_name new_value v_profile_name 

SELECT distinct p.name as v_profile_name
  FROM dba_sql_profiles p, v$sql s
  WHERE s.exact_matching_signature = p.signature
    AND s.sql_id = '&1';

EXEC DBMS_SQLTUNE.PACK_STGTAB_SQLPROF ( profile_name => '&v_profile_name', staging_table_name  => 'sql_prof_stage', staging_schema_owner => 'perflab' );


