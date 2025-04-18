/* patch-see-hint.sql */
/*
Query from blog:
https://dbamarco.wordpress.com/2015/11/09/sql-patches-what-do-they-do/
by Marco Pachaly-Mischke
*/
SET ECHO OFF
set linesize 120
set pagesize 100

PROMPT
PROMPT connect as the SYS user to create the patch
PROMPT

CONNECT / AS SYSDBA

COLUMN outline_hints FORMAT A60
SET ECHO ON

select cast(extractvalue(value(x), '/hint') as varchar2(500)) as outline_hints
from   xmltable('/outline_data/hint'
       passing (SELECT xmltype(d.comp_data) xml
                  FROM sys.sqlobj$data d, v$sql s
                  WHERE d.signature = s.exact_matching_signature
                    AND s.sql_patch IS NOT NULL
                    AND s.sql_id = '&1')) x;
SET ECHO OFF

