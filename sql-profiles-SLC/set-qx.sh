#!/bin/bash
# set-qx.sh

sed "s/xxxxxxxx/'$( date +%d-%b-%y )'/" qx.sql > q2.sql

sed "s/xxxxxxxx/'$( date -d "+1 day" +%d-%b-%y )'/" qx.sql > q3.sql

sed "s/xxxxxxxx/to_date('$( date +%d-%b-%y )')/" qx.sql > q4.sql
