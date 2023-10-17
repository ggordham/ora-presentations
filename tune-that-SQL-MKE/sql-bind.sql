/* sql_bind.sql */

set linesize 120
set pagesize 100
set trims on
set tab off

SELECT sql_id, child_number, name, position, datatype_string, value_string
  FROM GV$SQL_BIND_CAPTURE 
  WHERE SQL_ID = '&1'
    AND ROWNUM <= 10000;
