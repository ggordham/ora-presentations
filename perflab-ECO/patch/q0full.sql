
set echo on

-- select /* PATCHTEST*/ /*+ FULL(tab1) */ num
select /*+ FULL(tab1) */ num
from   tab1
where  id = 10;

set echo off

@plan
