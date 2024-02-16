
-- shows histogram details for
--   
set echo off
PROMPT
PROMPT Basic table details
PROMPT
column table_name format a12

SELECT table_name, num_rows
  FROM all_tables
  WHERE owner = 'SH' 
    AND table_name IN ('SALES', 'CUSTOMERS');


PROMPT
PROMPT Histogram information for a few buckets
PROMPT
column column_name FORMAT A12
column endpoint_actual_value FORMAT A10

SELECT column_name, endpoint_number, endpoint_actual_value, endpoint_repeat_count
  FROM all_tab_histograms
  WHERE owner = 'SH' 
    AND table_name = 'CUSTOMERS'
    AND column_name = 'SOCIAL_ID' 
    AND endpoint_repeat_count > 1
UNION
SELECT column_name, endpoint_number, endpoint_actual_value, endpoint_repeat_count
  FROM all_tab_histograms
  WHERE owner = 'SH' 
    AND table_name = 'CUSTOMERS'
    AND column_name = 'SOCIAL_ID' 
    AND ROWNUM < 6
  ORDER BY endpoint_number ASC;

 set echo on 
