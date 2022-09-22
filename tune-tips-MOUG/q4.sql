SET ECHO ON

SELECT cust_first_name, cust_last_name
  FROM customers
  WHERE cust_last_name BETWEEN 'Puleo' AND 'Quinn';

SET ECHO OFF
