/* q3.sql */

VAR socid VARCHAR2(10);

EXEC :socid := &1;

SET ECHO ON

SELECT /*+ gather_plan_statistics */ 
       COUNT('x')
  FROM sh.sales s, sh.customers c
  WHERE s.cust_id = c.cust_id
    AND c.social_id = :socid;


SET ECHO OFF
