SET ECHO ON

SELECT cust_first_name, cust_last_name
  FROM customers3
  WHERE cust_last_name BETWEEN 'Puleo' AND 'Quinn';

SET ECHO OFF
