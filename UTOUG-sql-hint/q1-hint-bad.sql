/* q1-patch-bad.sql */

SELECT /*+ monitor no_adaptive_plan full( s ) gather_plan_stats index( sales SALES_CHANNEL_BIX ) index( c customers_pk ) full( c ) */
       c.cust_state_province, sum(s.amount_sold)
  FROM sh.sales s, sh.customers c,
    (SELECT ch.channel_id
       FROM sh.channels ch
       WHERE ch.channel_class_id = 13) chan13
  WHERE c.cust_id = s.cust_id
    AND s.channel_id = chan13.channel_id
    AND c.cust_city_id IN ( 52114,52292,51738,51508)
  GROUP BY c.cust_state_province;

