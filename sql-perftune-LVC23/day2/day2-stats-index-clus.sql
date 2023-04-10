/* day2-stats-index-clus.sql */

-- Step 1 - run explain plan on this query
--   Note it does not use an index even though the cust_last_name
--    column is indexed.
-- You can verify the indexes / table structure using the object viewer 
--   in SQL Developer Web
SELECT cust_first_name, cust_last_name
  FROM customers
  WHERE cust_last_name BETWEEN 'Puleo' AND 'Quinn';


/*
-- SQLPlus formatting
COLUMN table_name FORMAT A20
COLUMN index_name FORMAT A26
SET FEEDBACK OFF
*/

-- Step 2 look at the cluster factor for the given index.
--   Note that the cluster factor is close to the number of rows in the table
--    this means that index will not be used for a range based scan
SELECT t.table_name, i.index_name, t.num_rows, t.blocks, i.clustering_factor
  FROM user_tables t, user_indexes i
  WHERE t.table_name = i.table_name
    AND t.table_name = 'CUSTOMERS'
    AND i.index_name = 'CUST_LNAME_IX';


-- Step 3 lets create a new table that is orderd by customer last name.
--   be sure to create the table, add the index, and gather statistics.
CREATE TABLE customers3 AS
SELECT *
FROM customers
ORDER BY cust_last_name;

CREATE INDEX CUST3_LNAME_IX ON customers3(cust_last_name);

exec dbms_stats.gather_table_stats(user,'CUSTOMERS3');


-- Step 4 Look at the explain plan for the same query now against our
--  new table that is organized by custoemr last name.
--  Note that the index should be used now
SELECT cust_first_name, cust_last_name
  FROM customers3
  WHERE cust_last_name BETWEEN 'Puleo' AND 'Quinn';

-- Step 5 look at the cluster factor for the given index.
--   Note that the cluster factor is close to the number of blocks in the table
--    this means that index will be used for a range based scan
SELECT t.table_name, i.index_name, t.num_rows, t.blocks, i.clustering_factor
  FROM user_tables t, user_indexes i
  WHERE t.table_name = i.table_name
    AND t.table_name = 'CUSTOMERS3'
    AND i.index_name = 'CUST3_LNAME_IX';


