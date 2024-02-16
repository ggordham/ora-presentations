/* q1.sql */

SELECT /*+ gather_plan_statistics no_adaptive_plan  */ 
       COUNT('x')
  FROM sh.sales s, sh.customers c
  WHERE s.cust_id = c.cust_id
    AND SUBSTR(CUST_STATE_PROVINCE,1,2) = 'CA';

