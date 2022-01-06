#!/bin/bash

# runquery.sh

query_file="$1"
num_times="$2"
extra_options="$3"

loop_count=$((1 + RANDOM % num_times))

# check the setpdb.sql file for a PDB connect string
if [ "$ORACLE_PDB_SID" == "" ]; then
  pdb_connect=""
else
  pdb_connect="@${ORACLE_PDB_SID}"
fi

echo $loop_count

for ((i=1; i<=loop_count; i++)); do
  "$ORACLE_HOME"/bin/sqlplus perflab/perf\$lab"${pdb_connect}" @"${query_file}"  "${extra_options}"> /dev/null
  sleep 1
done

