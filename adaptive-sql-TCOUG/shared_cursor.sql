/* shared_cursor.sql */


set echo off
set pagesize 20
set linesize 120
column reasons format a30
column bind_e_fail format a11
column load_opt_stat format a13

set echo on
select ssc.sql_id, ssc.child_number, ssc.BIND_EQUIV_FAILURE as BIND_E_FAIL, ssc.LOAD_OPTIMIZER_STATS load_opt_stat,
       LISTAGG(xmltab.reason_text, ', ') WITHIN GROUP (ORDER BY xmltab.reason_text) AS reasons
  from v$sql_shared_cursor ssc,
       XMLTABLE('/ChildNode/reason' PASSING XMLPARSE(CONTENT ssc.REASON)
              COLUMNS reason_text VARCHAR2(4000) PATH '.') xmltab
  where ssc.sql_id = '&1'
  group by ssc.sql_id, ssc.child_number, ssc.BIND_EQUIV_FAILURE, ssc.LOAD_OPTIMIZER_STATS;

set echo off
