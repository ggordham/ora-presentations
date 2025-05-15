
var v_name VARCHAR2(255)

exec :v_name := '&1';

SELECT /*+ gather_plan_statistics  */ 
       c.full_name, o.order_id, p.product_name, oi.quantity
  FROM co.customers c, co.orders o, co.order_items oi,
       co.products p
  WHERE c.customer_id = o.customer_id
    AND o.order_id = oi.order_id
    AND oi.product_id = p.product_id
    AND c.full_name = :v_name;

