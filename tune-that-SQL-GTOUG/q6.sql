

set timing on
set echo on

select sum(t1.a + t2.c) from t1, t2 where t1.a = t2.a and t2.a < DBMS_RANDOM.VALUE(1,250000);

set echo off
set timing off
