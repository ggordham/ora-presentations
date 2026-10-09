/* cr_hr.sql */

create user hr identified by Oracle_4U default tablespace users temporary tablespace TEMP;
grant connect, resource, create session to hr;
alter user hr quota unlimited on users;

connect hr/Oracle_4U@"//crs01-scan.gg.wi.rr.com/hr_tac"

drop table EMP4AC;

create table EMP4AC(
 empno number(4) not null,
 ename varchar2(10),
 job char(9),
 mgr number(4),
 hiredate date,
 sal number(7,2),
 comm number(7,2),
 deptno number(2),
 constraint EMP4AC_PRIMARY_KEY primary key (empno));

insert into EMP4AC values(7839,'KING','PRESIDENT',NULL,'17-NOV-81',50000,NULL,10);
insert into emp4AC values(7698,'BLAKE','MANAGER',NULL,'17-NOV-81',8000,NULL,10);
insert into emp4AC values(7782,'CLARK','MANAGER',NULL,'17-NOV-81',8000,NULL,10);
insert into emp4AC values(7566,'JONES','MANAGER',NULL,'17-NOV-81',8000,NULL,10);
insert into emp4AC values(7654,'MARTIN','SALESMAN',NULL,'17-NOV-81',7000,NULL,10);
insert into emp4AC values(7499,'ALLEN','MANAGER',NULL,'17-NOV-81',9000,NULL,10);
insert into emp4AC values(7844,'TURNER','CLERK',NULL,'17-NOV-81',5000,NULL,10);
insert into emp4AC values(7900,'JAMES','MANAGER',NULL,'17-NOV-81',9000,NULL,10);
insert into emp4AC values(7521,'WARD','PRGRMMER',NULL,'17-NOV-81',9000,NULL,10);
insert into emp4AC values(7902,'FORD','SALESMAN',NULL,'17-NOV-81',7000,NULL,10);
insert into emp4AC values(7369,'SMITH','PRGRMMER',NULL,'17-NOV-81',8000,NULL,10);
insert into emp4AC values(7788,'SCOTT','CLERK',NULL,'17-NOV-81',6000,NULL,10);
insert into emp4AC values(7876,'ADAMS','PRGRMMER',NULL,'17-NOV-81',7000,NULL,10);
insert into emp4AC values(7934,'MILLER','SALESMAN',NULL,'17-NOV-81',9000,NULL,10);

commit;

