#!/bin/bash
# setup.sh

pdb_list="hrprd hrtst hrdev"

# check minimum paramters
#if [ $# -ne 2 ] && [ $# -ne 3 ]; then
if [ $# -ne 2 ]; then
    echo "ERROR! must pass database SID and SYSTEM password on command line." >&2
    echo "   setup.sh t4db pa55word " >&2
    exit 1
else
    export ORACLE_SID=$1
    system_password=$2
    connect_string=${ORACLE_SID}
    echo "Using SID: ${ORACLE_SID}"
fi

# default settings
dp_directory=data_pump_dir
dp_file=hr-gold.dmp
dp_source=hr-gold-exp.zip

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# function to do a quick lookup in sql plus
#  queries should return a single value
#  enclose queries in double quotes, and escape $ "my query from v\$table where value='value';"
#  if the data contains KEEP, the query returns the second value only
#  Spaces are removed from results
#  returns "-1" when fail occurs
function call_sqlplus () {

    local my_sql_query="$1"
    local my_sql_output
    local my_return_text="-1"

    set -o pipefail; my_sql_output=$("${ORACLE_HOME}/bin/sqlplus" -s /nolog  <<!EOF 
          WHENEVER sqlerror EXIT sql.sqlcode;
          CONNECT / AS SYSDBA
          set pagesize 0
          ${my_sql_query}
          exit
!EOF
)
    # shellcheck disable=SC2181
    if (( $? == 0 )); then
        # If using the KEEP syntax, strip the extra data out of the return
        if [[ "${my_sql_output}" =~ "KEEP" ]]; then my_sql_output=$( echo "${my_sql_output}" | /bin/grep KEEP | /bin/sed 's/KEEP//;s/[ ]//g' ); fi
        my_return_text="${my_sql_output}"
    fi
    echo "$my_return_text"
}

############################################################################################
# start here

# setup Oracle environment
export ORAENV_ASK=NO
source /usr/local/bin/oraenv -s

for pdb in ${pdb_list}; do

    
    echo "Building out PDB ${pdb}"
    echo "=============================================================="
    # Create the required schemas
    "${ORACLE_HOME}"/bin/sqlplus /nolog << !EOF 

SET ECHO ON
WHENEVER sqlerror EXIT sql.sqlcode;

connect / as sysdba

@@crpdb.sql ${pdb} ${system_password}
!EOF

    # get database dump director loaction
    export ORACLE_PDB_SID=${pdb}
    dump_dir=$( call_sqlplus "SELECT directory_path AS KEEP FROM dba_directories WHERE directory_name = '${dp_directory^^}';")
    echo "database dump directory: ${dump_dir}"
    unset ORACLE_PDB_SID

    # copy the dump file to the proper location
    [ -f "${SCRIPTDIR}/${dp_source}" ] && /bin/unzip -o "${SCRIPTDIR}/${dp_source}" "${dp_file}" -d "${dump_dir}"

    # load the three schemas
    "${ORACLE_HOME}"/bin/impdp "system/${system_password}@${pdb}" directory="${dp_directory}" dumpfile="${dp_file}" logfile="hr-gold-imp-${pdb}.log" SCHEMAS=hr TRANSFORM=OID:N

done


#END
