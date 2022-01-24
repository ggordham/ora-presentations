

set timing on
set echo on

select t1.a, t1.b, t1.c, t1.d, t2.a, t2.b, t2.c, t2.d  from t1, t2 where t1.a = t2.a and t1.a = TRUNC(DBMS_RANDOM.VALUE(1,250000));


set echo off
set timing off
