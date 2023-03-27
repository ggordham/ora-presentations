/* day2-stats-histogram.sql */

/* 
-- SQLPlus settings
column column_name format a12
*/

-- Lets check the number of rows in each table
SELECT table_name, num_rows
  FROM user_tables
  WHERE table_name IN ('T1','T2', 'T3');

-- Gather statistics with histograms for all three tables
exec dbms_stats.gather_table_stats(user,'t1',method_opt=>'for all columns size 254',no_invalidate=>false)
exec dbms_stats.gather_table_stats(user,'t2',method_opt=>'for all columns size 254',no_invalidate=>false)
exec dbms_stats.gather_table_stats(user,'t3',method_opt=>'for all columns size 254',no_invalidate=>false)

-- Note table 3 will fail since it's statistics are locked.  Lets unlock and try again
exec dbms_stats.unlock_table_stats(user, 't3');
exec dbms_stats.gather_table_stats(user,'t3',method_opt=>'for all columns size 254',no_invalidate=>false)

-- Lets look at the histogram buckets
SELECT column_name, endpoint_number, endpoint_value, endpoint_repeat_count
  FROM user_tab_histograms
  WHERE table_name IN ('T1','T3') AND column_name = 'D' AND rownum < 6
  ORDER BY endpoint_number ASC;


