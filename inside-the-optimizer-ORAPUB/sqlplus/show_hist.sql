
-- shows histogram details for
--   table t1 column d first 5 buckets
set echo off
PROMPT
PROMPT Basic table details
PROMPT
column table_name format a12

SELECT table_name, num_rows 
  FROM all_tables
  WHERE table_name IN ('CUSTOMERS')
    AND owner = 'SH';

PROMPT
PROMPT Histogram information for largest 9 buckets
PROMPT
column column_name format a12
/* note this specific way to show num_endpoints only works for frequency histogram */

SELECT * FROM (
SELECT column_name, endpoint_number, 
       endpoint_actual_value, 
       endpoint_number - lag(endpoint_number) over( order by endpoint_number) AS num_endpoints
  FROM all_tab_histograms
  WHERE table_name = 'CUSTOMERS' 
    AND column_name = 'CUST_STATE_PROVINCE' 
    AND owner = 'SH'
    ORDER BY num_endpoints desc)
WHERE rownum < 10
  AND num_endpoints is not null;

PROMPT "Actual row counts for first values with more than 1,000 values"

select cust_state_province, count(1) 
  from sh.customers 
  group by cust_state_province 
  having count(1) > 1000
  order by 2 desc;

 set echo on 
