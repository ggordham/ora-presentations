/* products_q1.sql */

/* 
  sample ones:
  @products_q1.sql 15
*/

var v_price NUMBER

exec :v_price := &1

SELECT /*+ gather_plan_statistics  */
       product_name  
  FROM   oe.order_items o, oe.product_information p  
  WHERE  o.unit_price = :v_price
    AND    o.quantity > 1  
    AND    p.product_id = o.product_id;




