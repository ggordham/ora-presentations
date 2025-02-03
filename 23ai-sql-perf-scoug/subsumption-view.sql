/* subsumption-view.sql */

/*
All views/subqueries appear in the same outer query block.
Each view/subquery has aggregation with no group-by
  clause, i.e., it produces exactly one row.
All views/subqueries have identical tables and join predicates.
*/

SET ECHO ON

ALTER SESSION SET OPTIMIZER_FEATURES_ENABLE = '19.1.0';

SELECT /*+ gather_plan_statistics */ * FROM
  (SELECT avg(p.unit_price) AS avg_canc
     FROM co.orders o, co.products p, co.order_items oi
     WHERE o.order_id = oi.order_id
       AND oi.product_id = p.product_id
       AND ORDER_STATUS = 'CANCELLED') v1,
   (SELECT avg(p.unit_price) AS avg_ref
      FROM co.orders o, co.products p, co.order_items oi
      WHERE o.order_id = oi.order_id
        AND oi.product_id = p.product_id
        AND ORDER_STATUS = 'REFUNDED') v2;

select * 
from  dbms_xplan.display_cursor ( format => 'BASIC +PREDICATE +COST' );

ALTER SESSION SET OPTIMIZER_FEATURES_ENABLE = '23.1.0.1';

SELECT /*+ gather_plan_statistics */ * FROM
  (SELECT avg(p.unit_price) AS avg_canc
     FROM co.orders o, co.products p, co.order_items oi
     WHERE o.order_id = oi.order_id
       AND oi.product_id = p.product_id
       AND ORDER_STATUS = 'CANCELLED') v1,
   (SELECT avg(p.unit_price) AS avg_ref
      FROM co.orders o, co.products p, co.order_items oi
      WHERE o.order_id = oi.order_id
        AND oi.product_id = p.product_id
        AND ORDER_STATUS = 'REFUNDED') v2;

select * 
from  dbms_xplan.display_cursor ( format => 'BASIC +PREDICATE +COST' );

/*
-- example of query transformation that Optimizer performs

SELECT avg(CASE WHEN  ORDER_STATUS = 'CANCELLED' 
           THEN p.unit_price ELSE NULL END) AS avg_canc,
       avg(CASE WHEN  ORDER_STATUS = 'REFUNDED' 
           THEN p.unit_price ELSE NULL END) AS avg_ref
  FROM co.orders o, co.products p, co.order_items oi
  WHERE o.order_id = oi.order_id
    AND oi.product_id = p.product_id
    AND ORDER_STATUS IN ('CANCELLED', 'REFUNDED');
*/

