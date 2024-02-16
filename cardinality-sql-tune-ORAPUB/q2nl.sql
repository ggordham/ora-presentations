/* q2.sql */

SELECT /*+ gather_plan_statistics no_adaptive_plan USE_NL(c s) */ 
       COUNT('x')
  FROM sh.sales s, sh.customers c
  WHERE s.cust_id = c.cust_id
    AND c.social_id = 'XXXXXX';


