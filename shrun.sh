#!/bin/bash

# simple wrapper to run a script in docker

preso=$1
script=$2

#######################################################
if [ $# -ne 2 ]; then
    echo "ERROR script requires two paramters preso from preso-list and script name"
    exit 2
fi

working_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# figure out presentation specific settings
if [ "$preso" == "" ]; then
  echo "ERROR please provide a presentation id from the preso-list"
  exit 2
else
  preso_dir=$( grep "$preso" preso-list | cut -d , -f 2 )
  if [ "$preso_dir" == "" ]; then
    echo "ERROR preso ID $preso is not in the preso-list"
    exit 2
  fi
fi

# Verify script exists
if [ ! -f "$working_dir/$preso_dir/$script" ]; then
  echo "ERROR script $script not found in directory $preso_dir"
  exit 2
fi
#######################################################

cd "$working_dir/$preso_dir" || exit 2
chmod +x "$script"
./"$script"

