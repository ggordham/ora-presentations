/* statsd.sql */

-- Remove statistics from the sh.customers table

SET ECHO ON

exec dbms_stats.delete_table_stats(ownname => 'SH', tabname => 'CUSTOMERS');

