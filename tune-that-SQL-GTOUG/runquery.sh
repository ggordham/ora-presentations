#!/bin/bash

# runquery.sh

query_file="$1"
num_times="$2"
extra_options="$3"

loop_count=$((1 + RANDOM % num_times))

# check the setpdb.sql file for a PDB connect string
pdb_name=$( grep DEFINE setpdb.sql |cut -d \" -f 2 )

echo $loop_count

for ((i=1; i<=loop_count; i++)); do
  "$ORACLE_HOME"/bin/sqlplus perflab/perf\$lab"${pdb_name}" @"${query_file}"  "${extra_options}"> /dev/null
  sleep 1
done

