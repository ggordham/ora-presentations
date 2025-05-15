/* customers_q1.sql */

/* 
  Used to show dynamic sampling as there is a correlation
  between state and city
*/

EXPLAIN PLAN FOR
  SELECT *
  FROM   sh.customers
  WHERE  cust_city='Los Angeles'
  AND    cust_state_province='CA';

SET LINESIZE 130
SET PAGESIZE 0
SELECT * 
FROM   TABLE(DBMS_XPLAN.DISPLAY);

