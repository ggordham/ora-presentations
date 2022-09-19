
COLUMN table_name FORMAT A20
COLUMN index_name FORMAT A20

SELECT t.table_name, i.index_name, t.num_rows, t.blocks, i.clustering_factor
  FROM user_tables t, user_indexes i
  WHERE t.table_name = i.table_name
    AND t.table_name = '&1'
    AND i.index_name = '&2';

