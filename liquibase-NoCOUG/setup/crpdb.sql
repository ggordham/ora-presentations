/* crpdb.sql */
-- quick script to create a pluggable DB from seed

PROMPT Enter pdb name (required)
DEFINE v_pdb_name = '&1';

PROMPT Enter pdb admin password (required)
DEFINE v_admin_pass = '&2';

column sysfile noprint new_value v_file_path
select substr(name,1, instr(name,'system01.dbf')-1) as sysfile from v$datafile where file#=1;
column sysfile clear

create pluggable database &&v_pdb_name
  admin user hradm identified by &&v_admin_pass ROLES = (dba)
  default tablespace users
    datafile '&&v_file_path.&&v_pdb_name./users01.dbf' size 250m autoextend on
  file_name_convert = ('&&v_file_path.pdbseed/', '&&v_file_path.&&v_pdb_name./');

alter pluggable database &&v_pdb_name open;
alter pluggable database &&v_pdb_name save state;


