
connect perflab/perf$lab&con_pdb

set echo on

select /* PATCHTEST*/ 
sum(num)
from   tab1
where  id in (select id
              from   tab2
              where  ty = 'T10');

set echo off

@plan
