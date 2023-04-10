/* sql-dummy.sql */

var dummyid number

exec :dummyid := 100

SELECT /*+ gather_plan_statistics NO_ADAPTIVE_PLAN */ sum(t2.c) FROM t1, t2 WHERE t1.a = t2.a AND t1.d = :idnum;

exec :dummyid := 200

SELECT /*+ gather_plan_statistics NO_ADAPTIVE_PLAN */ sum(t2.c) FROM t1, t2 WHERE t1.a = t2.a AND t1.d = :idnum;


exec :dummyid := 10

SELECT /*+ gather_plan_statistics NO_ADAPTIVE_PLAN */ sum(t2.c) FROM t1, t2 WHERE t1.a = t2.a AND t1.d = :idnum;


select sum(t1.a + t2.c) from t1, t2 where t1.a = t2.a and t2.a < DBMS_RANDOM.VALUE(1,250000);
select count(*) from t2 where d < DBMS_RANDOM.VALUE(1,250000);
select sum(t1.a + t2.c) from t1, t2 where t1.a = t2.a and t2.a < DBMS_RANDOM.VALUE(1,250000);
select count(*) from t2 where d < DBMS_RANDOM.VALUE(1,250000);

select sum(t1.a + t2.c) from t1, t2 where t1.a = t2.a and t2.a < DBMS_RANDOM.VALUE(1,250000);
select count(*) from t2 where d < DBMS_RANDOM.VALUE(1,250000);

