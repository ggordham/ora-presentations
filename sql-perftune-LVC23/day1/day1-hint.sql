/* day1-no-hint.sql */

select ename
from emp e, (select /*+ QB_NAME(strange) */ * 
             from dept where deptno=30) d
where e.deptno = d.deptno and d.loc = 'CHICAGO';


select /*+ FULL(@strange dept) */ ename
from emp e, (select /*+ QB_NAME(strange) */ * 
             from dept where deptno=30) d
where e.deptno = d.deptno and d.loc = 'CHICAGO';

