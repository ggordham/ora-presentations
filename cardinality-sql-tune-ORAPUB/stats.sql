/* stats.sql */

-- generate basic statistics on the customer table.

SET ECHO ON

exec dbms_stats.gather_table_stats('SH','CUSTOMERS',method_opt=>'for all columns size 1',no_invalidate=>false);

