
-- shows histogram details for
--   table t1 column d first 5 buckets
set echo off
PROMPT
PROMPT Basic table details
PROMPT
column table_name format a12

SELECT table_name, num_rows
  FROM user_tables
  WHERE table_name IN ('T1','T2');

PROMPT
PROMPT Histogram information for first 5 buckets
PROMPT
column column_name format a12

SELECT column_name, endpoint_number, endpoint_value, endpoint_repeat_count
  FROM user_tab_histograms
  WHERE table_name = 'T1' AND column_name = 'D' AND rownum < 6
  ORDER BY endpoint_number ASC;

 set echo on 
