
SET ECHO ON

PROMPT Creating a new table organized by last_name

CREATE TABLE customers3 AS
SELECT *
FROM customers
ORDER BY cust_last_name;

CREATE INDEX CUST3_LNAME_IX ON customers3(cust_last_name);

exec dbms_stats.gather_table_stats(user,'CUSTOMERS3');


