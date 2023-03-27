/* day2-stats-index.sql */

-- Show index statistics 
SELECT owner, index_name, blevel, leaf_blocks, distinct_keys,
       avg_leaf_blocks_per_key, avg_data_blocks_per_key, clustering_factor,
       num_rows, last_analyzed
  FROM dba_indexes
  WHERE owner = 'PERFLAB' AND index_name = 'T2I';

-- remove index statistics
exec dbms_stats.delete_index_stats(user,'t2i',no_invalidate=>false);

-- look at the index statistics again using first query

-- re-add the index statistics
exec dbms_stats.gather_table_stats(user,'t2',method_opt=>'for all columns size 1',no_invalidate=>false)
