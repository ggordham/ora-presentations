/* patch-see-hint.sql */
/*
Query from blog:
https://dbamarco.wordpress.com/2015/11/09/sql-patches-what-do-they-do/
by Marco Pachaly-Mischke
*/
SET ECHO OFF

PROMPT
PROMPT connect as the SYS user to see the patch hint
PROMPT

CONNECT / AS SYSDBA

COLUMN outline_hints FORMAT A60
SET ECHO ON

select cast(extractvalue(value(x), '/hint') as varchar2(500)) as outline_hints
from   xmltable('/outline_data/hint'
       passing (select xmltype(d.comp_data) xml
               from   sys.sqlobj$data d, v$sql s
               where  d.signature = s.exact_matching_signature
                 and s.sql_id = '&1')) x;
SET ECHO OFF

