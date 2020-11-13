
set pagesize 100
set linesize 140

column owner format a10
column table_name format a15
column column_name format a15
column low_value format a10
column high_value format a10

set echo on
select owner , table_name , num_rows , blocks , empty_blocks , avg_space ,
       chain_cnt , avg_row_len , -- avg_space_freelist_blocks , num_freelist_blocks ,
       sample_size , last_analyzed , global_stats , user_stats 
  FROM dba_tables 
  WHERE owner = 'PERFLAB' 
    AND table_name in ('DEPARTMENTS', 'ROLES', 'EMPLOYEES');

select owner , table_name , column_name , num_distinct , -- low_value , high_value ,
       density , num_nulls , num_buckets , last_analyzed , avg_col_len 
 FROM dba_tab_col_statistics 
 WHERE owner ='PERFLAB' 
  AND table_name in ('DEPARTMENTS', 'ROLES', 'EMPLOYEES');

