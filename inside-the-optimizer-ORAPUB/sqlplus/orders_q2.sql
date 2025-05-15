
SELECT /*+ gather_plan_statistics NO_ADAPTIVE_PLAN */
       o.order_id, v.product_name
  FROM oe.orders o,
       (  SELECT order_id, product_name
          FROM   oe.order_items o, oe.product_information p
          WHERE  p.product_id = o.product_id
          AND    list_price < 50
          AND    min_price < 40  ) v
  WHERE o.order_id = v.order_id;

