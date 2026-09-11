/* show_services.sql */

set pagesize 100
column name format a20
column network_name format a20
column pdb format a20
select name, network_name, edition, enabled from dba_services;

select a.name, a.network_name, p.name AS PDB, a.blocked 
  from v$active_services a, v$pdbs p
  WHERE a.con_id = p.con_id;

