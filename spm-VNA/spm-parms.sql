
column parameter_name format a38
column parameter_value format a38

SELECT parameter_name, parameter_value 
  FROM dba_sql_management_config
  ORDER BY 1;


