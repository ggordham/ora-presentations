set timing on
connect perflab/perf$lab&con_pdb

prompt
prompt This second query searches for value 1000
prompt  There is only one record in the table with this value.
prompt

set echo on

select /*+ NO_ADAPTIVE_PLAN */ sum(t1.c), sum(t2.c)
from   t1, t2
where  t1.a = t2.a
and    t1.d = 1000;

set echo off
set timing off

@plan

prompt Note: that the explain plan uses Nested Loops (NL)
prompt  as there is only one row that matches in each table
prompt  Oracle only has to be read each table in full once.
prompt
