#!/bin/bash
# lab_fix_pdb.sh

first_db=1
last_db=14
fix_script=$1

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export ORACLE_SID=lvcdb1
export ORAENV_ASK=NO
source /usr/local/bin/oraenv -s

cd "${SCRIPTDIR}" || exit 1

for i in $( seq ${first_db} 1 ${last_db} ); do
  if (( i > 9 )); then
      pdb_name=pdb${i}
  else
      pdb_name=pdb0${i}
  fi

  echo "Running fix script ${fix_script} in PDB $pdb_name"
  export ORACLE_PDB_SID=$pdb_name
  "${ORACLE_HOME}"/bin/sqlplus /nolog << !EOF

connect / as sysdba
START ${fix_script}

!EOF

done;

