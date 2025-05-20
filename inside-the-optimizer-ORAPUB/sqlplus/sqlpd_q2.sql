SELECT /*+ gather_plan_statistics */ count(cust_city)
  FROM   sh.customers
  WHERE  cust_city='Los Angeles'
  AND    cust_state_province='CA';
