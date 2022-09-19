
SET ECHO ON

PROMPT Creating a new table organized by last_name

CREATE TABLE customers3 AS
SELECT *
FROM customers
ORDER BY cust_last_name;

CREATE INDEX CUSTOMERS3_LAST_NAME_IDX ON customers3(cust_last_name);

