#!/bin/bash

# make-load.sh

# Setup Oracle variables and paths
if grep "$1" /etc/oratab ; then
  export ORACLE_SID="$1"
  export PATH="${PATH}":/usr/local/bin
  export ORAENV_ASK=NO
  # shellcheck disable=1091
  . /usr/local/bin/oraenv -s
else
  echo "ERROR database ${1} not found in /etc/oratab"
  exit 1
fi


./runquery.sh q1.sql 200 10 &
./runquery.sh q1.sql 200 $((1 + RANDOM % 250000)) &
./runquery.sh q2.sql 200 &
./runquery.sh q3.sql 200 &
./runquery.sh q4.sql 200 &
./runquery.sh q5.sql 200 &
./runquery.sh q6.sql 200 &
./runquery.sh q7.sql 200 &
./runquery.sh q8.sql 200 &


tput clear
jobs
while sleep 1; do
  tput clear
  jobs
  echo "When all jobs have completed press CTL+C to exit the script"
done

# or use tput rc to not clear the screen
