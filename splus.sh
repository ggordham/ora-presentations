#!/bin/bash

# Simple script to use for labs to get to a PDB when needed
#  can be run inside a docker container

# Set the following items to overide the discovered items
# if you leave these blank, everything will be discovered
MY_SID=
MY_PDB=
MY_HOME=
MY_TNS=

#######################################################

working_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check for static SID set, otherwise we try to discover SID
if [ "$MY_SID" == "" ]; then
  if [ "$ORACLE_SID" == "" ]; then
      ORACLE_SID=$( pgrep -fl ora_pmon |grep -v ASM | cut -d _ -f 3 )
      # issue with pgrep changing sid name to lower case
      #  if we can't match the process name force the SID to uppercase
      if [ $( pgrep -fc ora_pmon_${ORACLE_SID} ) -eq 0 ]; then
        ORACLE_SID=${ORACLE_SID^^}
      fi
      export ORACLE_SID
      unset ORACLE_HOME
  fi
else 
  export ORACLE_SID="$MY_SID"
fi

# Check for static HOME, otherwise we use oratab for home setup
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

# Check for static PDB, otherwise we try to discover the first PDB in the database
if [ "$MY_PDB" == "" ]; then
  if [ "$ORACLE_PDB"  == "" ]; then
    # we need to get rid of the login.sql or it will mess up this bit
    rm "$working_dir"/login.sql
    set -o pipefail; ORACLE_PDB_SID=$("${ORACLE_HOME}/bin/sqlplus" -s /nolog  <<!EOF 
          WHENEVER sqlerror EXIT sql.sqlcode;
          CONNECT / AS SYSDBA
          set pagesize 0
          select pdb_name from cdb_pdbs where con_id = 3;
          exit
!EOF
)
    if [ $? -gt 0 ]; then 
      ORACLE_PDB_SID=""
    fi
    export ORACLE_PDB_SID 
  else
    export ORACLE_PDB_SID="$ORACLE_PDB"
  fi
else
  export ORACLE_PDB_SID="$MY_PDB"
fi

# Check for static TNS location
if [ "$MY_TNS" == "" ]; then
    if [ "$TNS_ADMIN" == "" ]; then
        export TNS_ADMIN="$ORACLE_HOME"/network/admin
    fi
else
    export TNS_ADMIN="$MY_TNS"
fi

# Set Load Libraries
export LD_LIBRARY_PATH="$ORACLE_HOME"/lib:/usr/lib

# Create a SQL login profile, this will define 
#  a PDB connect string for us to use in lab scripts
echo "" > "$working_dir"/login.sql 
echo "set pagesize 999" >> "$working_dir"/login.sql
echo "set linesize 200" >> "$working_dir"/login.sql
echo "ALTER SESSION SET nls_date_format = 'HH:MI:SS';" >> "$working_dir"/login.sql
echo 'SET SQLPROMPT "_USER\\'@\\'_CONNECT_IDENTIFIER _DATE> "' >> "$working_dir"/login.sql
if [ "$ORACLE_PDB_SID" == "" ]; then
  echo "define con_pdb =''"  >> "$working_dir"/login.sql
else
  echo "define con_pdb ='@$ORACLE_PDB_SID'"  >> "$working_dir"/login.sql
fi

sqlplus /nolog

