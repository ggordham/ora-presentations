#!/bin/bash

# runquery.sh

query_file="$1"
num_times="$2"
extra_options="$3"

loop_count=$((1 + RANDOM % num_times))

echo $loop_count

for ((i=1; i<=loop_count; i++)); do
  "$ORACLE_HOME"/bin/sqlplus perflab/perf\$lab @"${query_file}"  "${extra_options}"> /dev/null
  sleep 1
done

