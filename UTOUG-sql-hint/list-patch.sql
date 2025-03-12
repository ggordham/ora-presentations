/* list-patch.sql */

column signature format 9999999999999999999999
column exact_matching_signature format 9999999999999999999999
column sql_text format a60
column sql_patch format a25
column status format a15
set linesize 300
set trims on

PROMPT Patches that exist in the database

set echo on
select name as sql_patch, signature, sql_text,status from dba_sql_patches;
set echo off

PROMPT SQL statements in cursor cache using patches

set echo on
select sql_text,sql_patch,exact_matching_signature
from   v$sqlarea
where  sql_patch is not null
order  by 1;

SET ECHO OFF


