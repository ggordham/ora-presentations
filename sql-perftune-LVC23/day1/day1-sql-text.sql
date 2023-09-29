/* day1-sql-text.sql */

-- Note use the SQL ID information captured from sql-signiture.sql script

SELECT sql_id, sql_text, sql_fulltext
  FROM v$sql
  WHERE sql_id = 'bydvrdc2hrp1x';

SELECT sql_id, position, name, datatype_string, last_captured, value_string
  FROM v$sql_bind_capture
  WHERE sql_id = 'bydvrdc2hrp1x';

