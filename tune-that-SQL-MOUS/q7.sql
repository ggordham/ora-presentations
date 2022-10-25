

set timing on
set echo on

select count(*) from t2 where d < DBMS_RANDOM.VALUE(1,250000);

set echo off
set timing off
