/* col-stats.sql */

-- Note: low and high values are stored as RAW data type

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
