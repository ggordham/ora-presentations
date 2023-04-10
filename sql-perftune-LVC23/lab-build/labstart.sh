#!/bin/bash
# labstart.sh 

LAB_NAME=sql-perftune-LVC23

ORACLE_SID=$( pgrep -fa ora_pmon |grep -v ASM | cut -d _ -f 3 )
if [ ! -z "$ORACLE_SID" ]; then
  export ORACLE_SID

  export ORAENV_ASK=NO
  source /usr/local/bin/oraenv -s

  pdb=pdb${USER:0-2}
  connect_file="$HOME/$LAB_NAME/sqlplus/connect.sql"
  echo "connect perflab/perf\$lab@${pdb}" > "${connect_file}"
  echo "" >> "${connect_file}"

  export ORACLE_PDB_SID=${pdb}

  curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1 "ggordham-ora-presentations-???????/${LAB_NAME}"

  cd "$HOME/${LAB_NAME}/sqlplus/" || echo "Could not find lab directory, please check with instructor." || exit
  "$ORACLE_HOME"/bin/sqlplus /nolog

else
  echo "ERROR database not running for lab, please check with instructor."
fi

exit
