/* day2-stats-table.sql */

/* 
-- For SQLPlus command line
set pagesize 100
set linesize 140

column owner format a10
column table_name format a15
column column_name format a15
column low_value format a10
column high_value format a10

set echo on
*/

-- Simplet table level statistics query
select owner , table_name , num_rows , blocks , empty_blocks , avg_space ,
       chain_cnt , avg_row_len , -- avg_space_freelist_blocks , num_freelist_blocks ,
       sample_size , last_analyzed , global_stats , user_stats 
  FROM dba_tables 
  WHERE owner = 'HR' 
    AND table_name in ('DEPARTMENTS', 'JOBS', 'EMPLOYEES');

-- Simple column statistics query
select owner , table_name , column_name , data_type, num_distinct , 
       low_value , high_value ,
       density , num_nulls , num_buckets , last_analyzed , avg_col_len 
 FROM dba_tab_columns 
 WHERE owner ='HR' 
  AND table_name in ('DEPARTMENTS', 'JOBS', 'EMPLOYEES');

-- Detailed column statistics with low / high values
SELECT column_name, data_type, data_length, data_precision,
    data_scale, num_distinct,
    decode(data_type,
           'NUMBER', to_char(utl_raw.cast_to_number(low_value)),
           'VARCHAR2', utl_raw.cast_to_varchar2(low_value),
           'DATE', (TO_NUMBER(substr(low_value, 1, 2),
              'xx') - 100) * 100 +(TO_NUMBER(substr(low_value, 3, 2),
              'xx') - 100) || '/' || TO_NUMBER(substr(low_value, 5, 2),
              'xx') || '/' || TO_NUMBER(substr(low_value, 7, 2),
              'xx'),
           'NoCode') low_value,
    decode(data_type,
           'NUMBER', to_char(utl_raw.cast_to_number(high_value)),
           'VARCHAR2', utl_raw.cast_to_varchar2(high_value),
           'DATE', (TO_NUMBER(substr(high_value, 1, 2),
              'xx') - 100) * 100 +(TO_NUMBER(substr(high_value, 3, 2),
              'xx') - 100) || '/' || TO_NUMBER(substr(high_value, 5, 2),
              'xx') || '/' || TO_NUMBER(substr(high_value, 7, 2),
              'xx'), 'NoCode') high_value,
    density, num_nulls, sample_size, avg_col_len,
    histogram, num_buckets, last_analyzed
FROM dba_tab_columns
WHERE owner = 'HR' 
  AND table_name = 'EMPLOYEES';

