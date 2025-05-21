/* plan_sql_obj.sql */

/* 
  displays the objects used by the SQL statement.
*/

set linesize 300
set tab off
set trim off
set pagesize 1000

COLUMN access_method FORMAT A30
COLUMN index_name FORMAT A36
COLUMN table_name FORMAT A36

COLUMN num_rows FORMAT 999,999,999,999,999
COLUMN blocks FORMAT 999,999,999,999,999
COLUMN avg_row_len FORMAT 999,999,999

SELECT sp.sql_id, sp.plan_hash_value, sp.child_number, sp.id,
      sp.operation || ' ' || sp.options AS access_method,
      t.owner ||'.'||t.table_name AS table_name, 
      NULL AS index_name, NULL AS index_type,
      t.partitioned, 
      sp.cardinality, sp.filter_predicates,
      t.last_analyzed, t.num_rows, t.blocks, t.avg_row_len
  FROM gv$sql_plan sp, dba_tables t
  WHERE sp.object_type = 'TABLE' AND sp.object_owner = t.owner AND sp.object_name = t.table_name
    AND sql_id = '&1'
UNION ALL
SELECT sp.sql_id, sp.plan_hash_value, sp.child_number, sp.id,
      sp.operation || ' ' || sp.options AS access_method,
      i.table_owner ||'.'||i.table_name AS table_name, 
      i.owner ||'.'||i.index_name AS index_name, i.index_type AS index_type,
      t.partitioned, 
      sp.cardinality, sp.filter_predicates,
      i.last_analyzed, i.blevel, i.leaf_blocks, NULL
  FROM gv$sql_plan sp, dba_indexes i
  WHERE sp.object_type LIKE 'INDEX%' AND sp.object_owner = i.owner AND sp.object_name = i.index_name
    AND sql_id = '&1'
UNION ALL
SELECT sp.sql_id, sp.plan_hash_value, sp.child_number, sp.id,
      sp.operation || ' ' || sp.options AS access_method,
      v.owner ||'.'||v.view_name AS view_name, 
      NULL AS index_name, NULL AS index_type,
      NULL AS partitioned, 
      sp.cardinality, sp.filter_predicates,
      NULL AS last_analyzed, NULL AS blevel, NULL AS leaf_blocks, NULL
  FROM gv$sql_plan sp, dba_views v
  WHERE sp.object_type = 'VIEW' AND sp.object_owner = v.owner AND sp.object_name = v.view_name
    AND sql_id = '&1'
ORDER BY 1,2,3,4;

-- END
