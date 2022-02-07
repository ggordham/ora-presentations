
connect perflab/perf$lab&con_pdb
set echo on

-- select /* PATCHTEST*/ num
select num
from   tab1
where  id = 10;

set echo off

@plan
