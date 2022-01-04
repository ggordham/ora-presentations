

var idnum number

exec :idnum := &1;

set timing on
set echo on

select count(t1.a) from t1 where c = 1 and c in (select t2.a from t2 where t2.c = 1);

set echo off
set timing off
