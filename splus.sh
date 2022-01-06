#!/bin/bash

# Set the following items to overide the discovered items
# if you leave these blank, everything will be discovered
MY_SID=
MY_PDB=
MY_HOME=
MY_TNS=

#######################################################

working_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$MY_SID" == "" ]; then
  if [ "$ORACLE_SID" == "" ]; then
      ORACLE_SID=$( pgrep -fl ora_pmon |grep -v ASM | cut -d _ -f 3 )
      export ORACLE_SID
  fi
else 
  export ORACLE_SID="$MY_SID"
fi

if [ "$MY_HOME" == "" ]; then
    if [ "$ORACLE_HOME" == "" ]; then
        export ORAENV_ASK=NO
        . /usr/local/bin/oraenv
    fi
else
  export ORACLE_HOME="$MY_HOME"
  ORACLE_BASE=$( $ORACLE_HOME/bin/orabase )
  export ORACLE_BASE
fi


if [ "$MY_PDB" == "" ]; then
  if [ "$ORACLE_PDB"  == "" ]; then
    set -o pipefail; ORACLE_PDB_SID=$("${ORACLE_HOME}/bin/sqlplus" -s /nolog  <<!EOF 
          WHENEVER sqlerror EXIT sql.sqlcode;
          CONNECT / AS SYSDBA
          set pagesize 0
          select pdb_name from cdb_pdbs where con_id = 3;
          exit
!EOF
)
    export ORACLE_PDB_SID 
  else
    export ORACLE_PDB_SID="$ORACLE_PDB"
  fi
else
  export ORACLE_PDB_SID="$MY_PDB"
fi

if [ "$MY_TNS" == "" ]; then
    if [ "$TNS_ADMIN" == "" ]; then
        export TNS_ADMIN="$ORACLE_HOME"/network/admin
    fi
else
    export TNS_ADMIN="$MY_TNS"
fi

export LD_LIBRARY_PATH="$ORACLE_HOME"/lib:/usr/lib

echo "set pagesize 999" > "$working_dir"/login.sql
echo "set linesize 200" > "$working_dir"/login.sql
if [ "$ORACLE_PDB_SID" == "" ]; then
  echo "define con_pdb =''"  > "$working_dir"/login.sql
else
  echo "define con_pdb ='@$ORACLE_PDB_SID'"  > "$working_dir"/login.sql
fi

sqlplus /nolog

