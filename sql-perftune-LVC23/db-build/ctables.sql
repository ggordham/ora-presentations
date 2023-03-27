@@connect.sql
set echo on


-- T1 / T2 test tables
drop table t1 purge;
drop table t2 purge;

create table t1 (a number(10), b varchar2(1000), c number(10), d number(10));


var str VARCHAR2(10)
exec :str := dbms_random.string('u',10);
insert /*+ APPEND */ into t1
select DECODE(parity, 0,rn, 1,rn+1000000), :str, 1, DECODE(parity, 0,rn, 1,10)
from (
    select trunc((rownum+1)/2) as rn, mod(rownum+1,2) as parity
    from (select null from dual connect by level <= 1000)
       , (select null from dual connect by level <= 500)
     );

commit;

create table t2 as select * from t1;

create index t1i on t1 (a);
create index t2i on t2 (a);

-- CREATE table with stale statistics
create table t3 as select * from t1;
exec dbms_stats.gather_table_stats(user, 't3', method_opt=>'for all columns size 1')

-- create some new rows in the table to statistics are now stale.
insert /*+ APPEND */ into t3
select DECODE(parity, 0,rn+500001, 1,rn+2000000), :str, 1, DECODE(parity, 0,rn+500001, 1,500010)
from (
    select trunc((rownum+1)/2) as rn, mod(rownum+1,2) as parity
    from (select null from dual connect by level <= 1000)
       , (select null from dual connect by level <= 500)
     );

commit;

-- lock the stats so they stay stale
exec dbms_stats.lock_table_stats(user, 't3');


-- SALES / SALES_LINES test tables
drop table sales purge;

alter session set NLS_DATE_FORMAT='DD-Mon-YY';

create table sales (
  id number(10)
, sale_date date);

create table sales_lines (
    id number(10),
    line number(10),
    item_desc varchar2(500),
    qty number(10)
  );

insert into sales
select level, sysdate-rownum/1000
from   dual
connect by level <= 500000
/

create index salesi ON sales (sale_date);

insert into sales values (100000, to_date(sysdate+1000));
commit;

declare
   v_num  NUMBER;
   v_qty  NUMBER;
begin
   for r_sales in
     (select id from sales)
     loop
       v_num := DBMS_RANDOM.VALUE(1,20);
       for i in 1..v_num loop
           v_qty := DBMS_RANDOM.VALUE(1,100);
           insert into sales_lines values (r_sales.id, i, 'Item Description ' || i , v_qty);
       end loop;
   end loop;
   commit;

end;
/

create index sales_linesi on sales_lines (id, line);


--
-- Make sure that we don't let histograms help us out here
--
exec dbms_stats.gather_table_stats(user, 'sales', method_opt=>'for all columns size 1')

-- Load system statistics staging table
@@sys-stats-stg.sql

-- load the staged profile
EXEC DBMS_SQLTUNE.CREATE_STGTAB_SQLPROF ( table_name  => 'sql_prof_stage', schema_name => 'perflab' );
-- @@stg_SYS_SQLPROF_0184f234f41e0002.sql

-- EMP / DEPT / BONUS / SALGRADE test tables
SET TERMOUT ONPROMPT Building demonstration tables. Please wait.
SET TERMOUT OFF
DROP TABLE EMP;
DROP TABLE DEPT;
DROP TABLE BONUS;
DROP TABLE SALGRADE;
DROP TABLE DUMMY;

CREATE TABLE EMP(EMPNO NUMBER(4) NOT NULL,
ENAME VARCHAR2(10),JOB VARCHAR2(9),
MGR NUMBER(4),HIREDATE DATE,
SAL NUMBER(7, 2),COMM NUMBER(7, 2),
DEPTNO NUMBER(2),
constraint pk_emp primary key (empno));

create index emp_idx1 on emp(deptno);

INSERT INTO EMP VALUES(7369, 'SMITH', 'CLERK', 7902,
   TO_DATE('17-DEC-1980', 'DD-MON-YYYY'), 800, NULL, 20);

INSERT INTO EMP VALUES(7499, 'ALLEN', 'SALESMAN', 7698,
  TO_DATE('20-FEB-1981', 'DD-MON-YYYY'), 1600, 300, 30);

INSERT INTO EMP VALUES(7521, 'WARD', 'SALESMAN', 7698,
   TO_DATE('22-FEB-1981', 'DD-MON-YYYY'), 1250, 500, 30);

INSERT INTO EMP VALUES(7566, 'JONES', 'MANAGER', 7839,
   TO_DATE('2-APR-1981', 'DD-MON-YYYY'), 2975, NULL, 20);

INSERT INTO EMP VALUES(7654, 'MARTIN', 'SALESMAN', 7698,
   TO_DATE('28-SEP-1981', 'DD-MON-YYYY'), 1250, 1400, 30);

INSERT INTO EMP VALUES(7698, 'BLAKE', 'MANAGER', 7839,
   TO_DATE('1-MAY-1981', 'DD-MON-YYYY'), 2850, NULL, 30);

INSERT INTO EMP VALUES(7782, 'CLARK', 'MANAGER', 7839,
   TO_DATE('9-JUN-1981', 'DD-MON-YYYY'), 2450, NULL, 10);

INSERT INTO EMP VALUES(7788, 'SCOTT', 'ANALYST', 7566,
   TO_DATE('09-DEC-1982', 'DD-MON-YYYY'), 3000, NULL, 20);

INSERT INTO EMP VALUES(7839, 'KING', 'PRESIDENT', NULL,
   TO_DATE('17-NOV-1981', 'DD-MON-YYYY'), 5000, NULL, 10);

INSERT INTO EMP VALUES(7844, 'TURNER', 'SALESMAN', 7698,
   TO_DATE('8-SEP-1981', 'DD-MON-YYYY'), 1500, 0, 30);

INSERT INTO EMP VALUES(7876, 'ADAMS', 'CLERK', 7788,
   TO_DATE('12-JAN-1983', 'DD-MON-YYYY'), 1100, NULL, 20);

INSERT INTO EMP VALUES(7900, 'JAMES', 'CLERK', 7698,
   TO_DATE('3-DEC-1981', 'DD-MON-YYYY'), 950, NULL, 30);

INSERT INTO EMP VALUES(7902, 'FORD', 'ANALYST', 7566,
   TO_DATE('3-DEC-1981', 'DD-MON-YYYY'), 3000, NULL, 20);

INSERT INTO EMP VALUES(7934, 'MILLER', 'CLERK', 7782,
   TO_DATE('23-JAN-1982', 'DD-MON-YYYY'), 1300, NULL, 10);

CREATE TABLE DEPT(DEPTNO NUMBER(2),DNAME VARCHAR2(14),LOC VARCHAR2(13),
  constraint pk_dept primary key (deptno));

INSERT INTO DEPT VALUES (10, 'ACCOUNTING', 'NEW YORK');

INSERT INTO DEPT VALUES (20, 'RESEARCH', 'DALLAS');

INSERT INTO DEPT VALUES (30, 'SALES', 'CHICAGO');

INSERT INTO DEPT VALUES (40, 'OPERATIONS', 'BOSTON');

CREATE TABLE BONUS(ENAME VARCHAR2(10),JOB VARCHAR2(9),
SAL NUMBER,COMM NUMBER);

CREATE TABLE SALGRADE(GRADE NUMBER,LOSAL NUMBER,HISAL NUMBER);

INSERT INTO SALGRADE VALUES (1, 700, 1200);

INSERT INTO SALGRADE VALUES (2, 1201, 1400);

INSERT INTO SALGRADE VALUES (3, 1401, 2000);

INSERT INTO SALGRADE VALUES (4, 2001, 3000);

INSERT INTO SALGRADE VALUES (5, 3001, 9999);

CREATE TABLE DUMMY(DUMMY NUMBER);

INSERT INTO DUMMY VALUES (0);

COMMIT;

SET TERMOUT ON
PROMPT Demonstration table build is complete.
COMMIT;

-- Tables for patch demo
drop table tab1 purge;
drop table tab2 purge;

create table tab1 (
  id        number(10)
 ,cust      number(10)
 ,num       number(10)
 ,txt       varchar2(100))
/

create table tab2 (
  id        number(10)
 ,ty        varchar2(10)
 ,num       number(10)
 ,txt       varchar2(100))
/

insert into tab1
select rownum,mod(rownum,10),rownum,'Desc'
from   dual connect by rownum < 10000;

insert into tab2
select mod(rownum,100),'T'||rownum,rownum,'Desc'
from   dual connect by rownum < 100;

create unique index tab1pk on tab1 (id);
create unique index tab2pk on tab2 (id);
create index tab2tyi on tab2(ty);

exec dbms_stats.gather_table_stats(user,'tab1');
exec dbms_stats.gather_table_stats(user,'tab2');

-- END
