
-- first bad SQL - uses full table scan when index would be better
--  optimizer estimaes 67% of table needs reading when less than 10%
SELECT /*+ NO_ADAPTIVE_PLAN */ /* Order forecast */
       order_date, order_status, COUNT(order_id) num_orders
  FROM rwloe.orders
  WHERE order_date > SYSDATE
  GROUP BY order_date, order_status;


SELECT /*+ NO_ADAPTIVE_PLAN */ /* Product forecast */
        TRUNC(order_date, 'WW') AS order_week, product_name, product_status, 
        SUM(quantity) AS total_ordered
  FROM (
        SELECT o.order_date, p.product_name, i.quantity, p.product_status
          FROM rwloe.orders o, rwloe.order_items i, rwloe.products p
          WHERE o.order_id = i.order_id
            AND i.product_id = p.product_id
            AND o.order_date > SYSDATE)
  GROUP BY TRUNC(order_date, 'WW'), product_name, product_status
  ORDER BY order_week DESC, product_status ASC, total_ordered DESC;


SELECT /*+ NO_ADAPTIVE_PLAN */ /* Inventory on Hand */
        p.product_status, count(1) qty, sum(p.list_price) tot_gross_price 
  FROM rwloe.inventories i, rwloe.products p
  WHERE p.product_id = i.product_id
    AND p.product_status in ('orderable', 'obsolete')
  GROUP BY p.product_status;


SELECT /*+ NO_ADAPTIVE_PLAN */ /* Top sales by country last month */
       c.address_line_3 AS country, SUM(o.order_total) AS total_orders
  FROM rwloe.customers c, rwloe.orders o
  WHERE o.customer_id = c.customer_id
    AND o.order_date BETWEEN 
        ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1) AND LAST_DAY(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1))
  GROUP BY c.address_line_3
  ORDER BY total_orders DESC;


Feb 1
Mar 3.5
Apr 4
May 4.5
Jun 3.5

5.5 weeks old

10 weeks new
