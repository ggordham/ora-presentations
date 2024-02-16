/* stats.sql */

-- generate statistics with histograms on the customer table.

SET ECHO ON

exec dbms_stats.gather_table_stats('SH','CUSTOMERS',method_opt=>'for all columns size 254',no_invalidate=>false);

