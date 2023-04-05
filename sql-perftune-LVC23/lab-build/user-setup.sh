

useradd -u 60001 -G oinstall,dba student1
cp -r /home/oracle/sqlt/run/* /home/student1/sqlplus/sqlt/
chown student1 /home/student1/sqlplus/sqlt/*
chgrp student1 /home/student1/sqlplus/sqlt/*


LAB_NAME=sql-perftune-LVC23

ORACLE_SID=$( pgrep -fa ora_pmon |grep -v ASM | cut -d _ -f 3 )
if [ ! -z "$ORACLE_SID" ]; then
  export ORACLE_SID

  export ORAENV_ASK=NO
  source /usr/local/bin/oraenv -s

  pdb=pdb${USER:0-1}
  echo "connect perflab/perf\$lab@${pdb}" > ~/sqltune/connect.sql
  echo "" >> ~/"${LAB_NAME}"/sqlplus/connect.sql

  export ORACLE_PDB_SID=${pdb}

  curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1 "ggordham-ora-presentations-???????/${LAB_NAME}"

  cd ~/"${LAB_NAME}"/sqlplus/
  "$ORACLE_HOME"/bin/sqlplus /nolog

else
  echo "ERROR database not running for lab, please check with instructor."
fi

exit
