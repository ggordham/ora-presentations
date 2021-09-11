

var idnum number

exec :idnum := &1;

set timing on
set echo on

select sum(c) from t1 where a = (select count(t2.a) from t2 where t2.a < DBMS_RANDOM.VALUE(1,250000));

set echo off
set timing off
