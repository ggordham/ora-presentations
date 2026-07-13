/* cs_histogram.sql */

select sql_id, child_number, bucket_id, count
From v$sql_cs_histogram
where sql_id = '&1';


