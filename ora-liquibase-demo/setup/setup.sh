#!/bin/bash
# setup.sh

log_file=lb-setup.log
connect_string=pdb1
system_password=Oracle_4U

db_directory=data_pump_dir
db_file=hr-gold.dmp

export ORACLE_SID=t1db
export ORACLE_PDB_SID=pdb1

export ORAENV_ASK=NO
source /usr/local/bin/oraenv -s

"${ORACLE_HOME}"/bin/sqlplus /nolog << !EOF > "${log_file}" 2>&1

SET ECHO ON
WHENEVER sqlerror EXIT sql.sqlcode;

connect system/${system_password}@${connect_string}

WHENEVER sqlerror CONTINUE;

drop user hr_prd cascade;
drop user hr_tst cascade;
drop user hr_dev cascade;

@cruser_parm hr_prd
@cruser_parm hr_tst
@cruser_parm hr_dev

!EOF

"${ORACLE_HOME}"/bin/impdp "system/${system_password}@pdb1" directory="${db_directory}" dumpfile="${db_file}" logfile=hr-gold-imp-dev.log remap_schema=hr:hr_dev TRANSFORM=OID:N EXCLUDE=USER

"${ORACLE_HOME}"/bin/impdp "system/${system_password}@pdb1" directory="${db_directory}" dumpfile="${db_file}" logfile=hr-gold-imp-tst.log remap_schema=hr:hr_tst TRANSFORM=OID:N EXCLUDE=USER

"${ORACLE_HOME}"/bin/impdp "system/${system_password}@pdb1" directory="${db_directory}" dumpfile="${db_file}" logfile=hr-gold-imp-prd.log remap_schema=hr:hr_prd TRANSFORM=OID:N EXCLUDE=USER

