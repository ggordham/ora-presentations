
SELECT index_name, blevel, leaf_blocks, clustering_factor FROM user_indexes
  WHERE table_name='CUSTOMERS'
  AND index_name= 'CUSTOMERS_LAST_NAME_IDX';

