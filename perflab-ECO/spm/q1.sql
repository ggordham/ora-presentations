set timing on
connect perflab/perf$lab
--
-- The adaptive plan feature can potentially avoid performance regressions
-- associate with the wrong join type being chosen, so we are going to disable it because
-- we WANT to induce a performance regression for SPM to fix.
--
--
-- Literals are used rather than bind variables to 
-- avoid adaptive cursor sharing from changing the plan
--

prompt
prompt This first query looks for the value 10.
prompt  1/2 the rows rows in the table have value = 10.
prompt

set echo on
select /*+ NO_ADAPTIVE_PLAN */ sum(t1.c), sum(t2.c)
from   t1, t2
where  t1.a = t2.a
and    t1.d = 10;

set echo off
set timing off
@plan

