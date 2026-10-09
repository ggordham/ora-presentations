#!/bin/bash
# mk_rac_services.sh
#

DB_NAME=orcl
ORACLE_SID=orcl1
# ORACLE_PDB=

SERVICE_NAME=hr_tac
SERVICE_NAME_NOTAC=hr_notac

export ORACLE_SID
export ORAENV_ASK=NO
source /usr/local/bin/oraenv -s


# notes:
#   failovertype - AUTO = enable TAC
#   failover_restore - AUTO = enable TAC
#   failovermethod - deprecated for TAC, for TAF usage only
#   commit_outcome - TRUE for use with Oracel replay driver to allow commit durability
#
"${ORACLE_HOME}"/bin/srvctl add service -d "${DB_NAME}" -s "${SERVICE_NAME}" -failovertype AUTO -failover_restore AUTO -commit_outcome TRUE -preferred orcl1 -available orcl2

"${ORACLE_HOME}"/bin/srvctl start  service -d "${DB_NAME}" -s "${SERVICE_NAME}"

"${ORACLE_HOME}"/bin/srvctl add service -d "${DB_NAME}" -s "${SERVICE_NAME_NOTAC}" -failovertype NONE -failover_restore NONE -commit_outcome FALSE -preferred orcl1 -available orcl2

"${ORACLE_HOME}"/bin/srvctl start  service -d "${DB_NAME}" -s "${SERVICE_NAME_NOTAC}"

# additional settings from demo, though they were all commented out in source script
#
#-- declare
#-- params dbms_service.svc_parameter_array;
#-- begin
#-- params('FAILOVER_TYPE'):='TRANSACTION';
#-- params('FAILOVER_RESTORE'):='AUTO';
#-- params('REPLAY_INITIATION_TIMEOUT'):=1800;
#-- params('RETENTION_TIMEOUT'):=86400;
#-- params('FAILOVER_DELAY'):=10;
#-- params('FAILOVER_RETRIES'):=30;
#-- params('commit_outcome'):='true';
#-- params('aq_ha_notifications'):='true';
#-- dbms_service.modify_service('hr_tac',params);
#-- end;
#-- /
#-- commit;

