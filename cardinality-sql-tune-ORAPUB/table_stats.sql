/* tab_stats.sql */

SET PAGESIZE 100
set LINESIZE 180
COLUMN table_name FORMAT A10
ALTER SESSION SET nls_date_format = 'YYYY-MM-DD HH24:MI:SS';

SELECT table_name, num_rows, blocks, avg_row_len, last_analyzed
  FROM all_tables
  WHERE owner = 'SH' 
    AND table_name IN ('SALES', 'CUSTOMERS');

COLUMN table_name FORMAT A10
COLUMN column_name FORMAT A25
COLUMN data_type FORMAT A10
COLUMN low_value FORMAT A10
COLUMN high_value FORMAT A10

SELECT table_name, column_name, data_type, data_length,
       num_distinct,
       decode(data_type,
              'NUMBER', to_char(utl_raw.cast_to_number(low_value)),
              'VARCHAR2', utl_raw.cast_to_varchar2(low_value),
              'CHAR', utl_raw.cast_to_varchar2(low_value),
              'DATE', (TO_NUMBER(substr(low_value, 1, 2),
                 'xx') - 100) * 100 +(TO_NUMBER(substr(low_value, 3, 2),
                 'xx') - 100) || '/' || TO_NUMBER(substr(low_value, 5, 2),
                 'xx') || '/' || TO_NUMBER(substr(low_value, 7, 2),
                 'xx'),
              'NoCode') low_value,
       decode(data_type,
              'NUMBER', to_char(utl_raw.cast_to_number(high_value)),
              'VARCHAR2', utl_raw.cast_to_varchar2(high_value),
              'CHAR', utl_raw.cast_to_varchar2(high_value),
              'DATE', (TO_NUMBER(substr(low_value, 1, 2),
                 'xx') - 100) * 100 +(TO_NUMBER(substr(high_value, 3, 2),
                 'xx') - 100) || '/' || TO_NUMBER(substr(high_value, 5, 2),
                 'xx') || '/' || TO_NUMBER(substr(high_value, 7, 2),
                 'xx'), 'NoCode') high_value,
       density, num_nulls,
       histogram, last_analyzed
  FROM all_tab_columns
  WHERE owner = 'SH' 
    AND table_name IN ('SALES', 'CUSTOMERS');



