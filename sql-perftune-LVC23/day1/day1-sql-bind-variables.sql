/*

COLUMN name FORMAT a20
COLUMN value_string FORMAT a30
COLUMN datatype FORMAT a10
*/

SELECT sql_id, child_number ch_num, name, position, datatype_string datatype, value_string
  FROM v$sql_bind_capture
  WHERE sql_id = 'fua0hb5hfst77';
