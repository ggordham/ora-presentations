

set timing on
set echo on

select * from t1 where a = TRUNC(DBMS_RANDOM.VALUE(1,250000));

set echo off
set timing off
