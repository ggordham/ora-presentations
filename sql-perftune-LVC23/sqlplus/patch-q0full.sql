SET ECHO ON

select /* PATCHTEST */ /*+ FULL(tab1) */ num
from   tab1
where  id = 10;

SET ECHO OFF

