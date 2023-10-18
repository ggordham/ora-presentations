/* sql_bind.sql */

set linesize 120
set pagesize 100
set trims on
set tab off

COLUMN name format A10
COLUMN datatype_string format a16
COLUMN value_string format a32

SELECT sql_id, child_number, name, position, datatype_string, value_string
  FROM GV$SQL_BIND_CAPTURE 
  WHERE SQL_ID = '&1'
    AND ROWNUM <= 10000;
