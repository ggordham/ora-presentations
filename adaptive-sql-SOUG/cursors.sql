/* cursors.sql */

-- List cursors in v$sql 

COLUMN reop FORMAT A4
COLUMN adap FORMAT A4
COLUMN bina FORMAT A4
COLUMN bins FORMAT A4

set echo on
select child_number, plan_hash_value, executions, buffer_gets, 
     is_bind_sensitive AS bins, is_bind_aware AS bina, is_reoptimizable AS reop
     from v$sql 
     where sql_id = '&1';

set echo off
