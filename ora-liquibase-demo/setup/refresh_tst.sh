#!/bin/bash
# refresh_tst.sh

log_file=lb-refresh-tst.log
connect_string=pdb1
system_password=Oracle_4U

db_directory=data_pump_dir
db_file=hr-refresh.dmp

export ORACLE_SID=t1db
export ORACLE_PDB_SID=pdb1

export ORAENV_ASK=NO
source /usr/local/bin/oraenv -s

"${ORACLE_HOME}"/bin/sqlplus /nolog << !EOF > "${log_file}" 2>&1

SET ECHO ON
WHENEVER sqlerror EXIT sql.sqlcode;

connect system/${system_password}@${connect_string}

WHENEVER sqlerror CONTINUE;

drop user hr_tst cascade;

@cruser_parm hr_tst

!EOF


"${ORACLE_HOME}"/bin/expdp "system/${system_password}@pdb1" directory="${db_directory}" dumpfile="${db_file}" logfile=hr-refresh-exp.log schemas=hr_prd REUSE_DUMPFILES=YES

"${ORACLE_HOME}"/bin/impdp "system/${system_password}@pdb1" directory="${db_directory}" dumpfile="${db_file}" logfile=hr-refresh-imp-tst.log remap_schema=hr_prd:hr_tst TRANSFORM=OID:N EXCLUDE=USER

# temporary fix for liquibase code that doesn't import correctly
# 
"${ORACLE_HOME}"/bin/sqlplus /nolog << !EOF > "${log_file}" 2>&1

SET ECHO ON
WHENEVER sqlerror EXIT sql.sqlcode;

connect system/${system_password}@${connect_string}

WHENEVER sqlerror CONTINUE;

@@fix-hr_tst.sql

!EOF


