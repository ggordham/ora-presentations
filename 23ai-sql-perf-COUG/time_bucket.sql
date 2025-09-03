/* time_bucket.sql */

/*
  show example of new time_bucket function
  splitting time data over 5 minute intervals
*/

set echo on

DESC time_data

WITH rws AS (
  SELECT date'2025-02-01' origin, datetime, 1440 units_in_day, 5 stride_interval
    FROM time_data), 
  buckets AS (
    SELECT FLOOR(ROUND((datetime - origin) * units_in_day, 9) / stride_interval) bucket#, r.*
    FROM rws r), 
  intervals AS (
    SELECT origin + ( bucket# * stride_interval / units_in_day ) start_datetime,
           origin + ( ( bucket# + 1 ) * stride_interval / units_in_day ) end_datetime
      FROM buckets)
SELECT /*+ MONITOR */ COUNT(*), start_datetime, end_datetime
  FROM intervals
  GROUP BY start_datetime, end_datetime
  ORDER BY start_datetime
  fetch first 5 rows only;


/* new method with time_bucket function */

SELECT /*+ MONITOR */ COUNT(*),
       TIME_BUCKET (datetime, interval '5' minute, date'2025-02-01') start_date,
       TIME_BUCKET (datetime, interval '5' minute, date'2025-02-01', end) end_date
  FROM time_data
  GROUP BY start_date, end_date
  ORDER BY start_date
  fetch first 5 rows only;
