
SET ECHO ON

SELECT /*+ gather_plan_statistics */ count(*)
     FROM   sh.customers
     WHERE  cust_city='Los Angeles'
     AND    cust_state_province='CA';
