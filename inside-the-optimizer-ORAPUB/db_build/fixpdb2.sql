/* fixpdb2.sql */

CREATE OR REPLACE VIEW sh.cust_prod_totals_v AS
SELECT SUM(s.quantity_sold) total, s.cust_id, s.prod_id
FROM   sh.sales s
GROUP BY s.cust_id, s.prod_id;

GRANT READ ON sh.cust_prod_totals_v TO PERFLAB;
GRANT SELECT ON sh.customers TO perflab;
GRANT SELECT ON sh.products TO perflab;
GRANT SELECT ON sh.sales TO perflab;

GRANT SELECT ON sys.aux_stats$ TO perflab;

exec dbms_stats.gather_table_stats('SH','CUSTOMERS',method_opt=>'for all columns size 254',no_invalidate=>false)

