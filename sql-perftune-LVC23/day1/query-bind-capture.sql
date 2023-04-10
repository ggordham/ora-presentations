
SELECT sql_id, sql_fulltext
  FROM gv$sql
  WHERE sql_id = 'fua0hb5hfst77';

SELECT * 
  FROM GV$SQL_BIND_CAPTURE 
  WHERE SQL_ID = 'fua0hb5hfst77' AND ROWNUM <= 10000;
