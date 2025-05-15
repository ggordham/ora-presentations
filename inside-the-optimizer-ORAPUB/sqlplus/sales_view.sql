/* sales_view.sql */

/*
  to show complex veiw merging
*/

prompt "==========================================================================="
set echo on

-- view needed for demo
CREATE OR REPLACE VIEW sh.cust_prod_totals_v AS
SELECT SUM(s.quantity_sold) total, s.cust_id, s.prod_id
FROM   sh.sales s
GROUP BY s.cust_id, s.prod_id;

-- the query without view merging
SELECT /*+ NO_MERGE(cust_prod_totals_v) */
       c.cust_id, c.cust_first_name, c.cust_last_name, c.cust_email
FROM   sh.customers c, sh.products p, sh.cust_prod_totals_v
WHERE  c.country_id = 52790
AND    c.cust_id = cust_prod_totals_v.cust_id
AND    cust_prod_totals_v.total > 100
AND    cust_prod_totals_v.prod_id = p.prod_id
AND    p.prod_name = 'T3 Faux Fur-Trimmed Sweater';

@@planb.sql

prompt "note that the plan has the view listed and multi8ple loops required"

set echo on
-- the query with view merging 
SELECT  /*+ MERGE(cust_prod_totals_v) */
       c.cust_id, c.cust_first_name, c.cust_last_name, c.cust_email
FROM   sh.customers c, sh.products p, sh.cust_prod_totals_v
WHERE  c.country_id = 52790
AND    c.cust_id = cust_prod_totals_v.cust_id
AND    cust_prod_totals_v.total > 100
AND    cust_prod_totals_v.prod_id = p.prod_id
AND    p.prod_name = 'T3 Faux Fur-Trimmed Sweater';

@@planb.sql

prompt "note that the view is removed and the number of nested loops is reduced"

set echo on
-- what the rewritten query is like after view merging
SELECT c.cust_id, cust_first_name, cust_last_name, cust_email
FROM   sh.customers c, sh.products p, sh.sales s
WHERE  c.country_id = 52790
AND    c.cust_id = s.cust_id
AND    s.prod_id = p.prod_id
AND    p.prod_name = 'T3 Faux Fur-Trimmed Sweater'
GROUP BY s.cust_id, s.prod_id, p.rowid, c.rowid, c.cust_email, c.cust_last_name, 
         c.cust_first_name, c.cust_id
HAVING SUM(s.quantity_sold) > 100;

@@planb.sql

prompt "note that this rewritten query without the view matches the previous merge query"

prompt "==========================================================================="





