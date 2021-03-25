
column parameter_name format a38
column parameter_value format a38

SELECT PARAMETER_NAME, PARAMETER_VALUE 
   FROM DBA_SQL_MANAGEMENT_CONFIG 
   WHERE PARAMETER_NAME LIKE '%AUTO%';

