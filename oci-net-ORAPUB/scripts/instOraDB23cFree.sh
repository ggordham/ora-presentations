#!/bin/bash
#
# instOraDB23cFree.sh

DB_RPM_URL="https://download.oracle.com/otn-pub/otn_software/db-free/oracle-database-free-23c-1.0-1.el8.x86_64.rpm"
RPM_LOC=/home/opc

# install the pre-install RPM
/bin/sudo /bin/dnf install -y oraclelinux-developer-release-el8
/bin/sudo /bin/dnf config-manager --set-enabled ol8_developer 
/bin/sudo /bin/dnf -y install oracle-database-preinstall-23c

# wait for proxy server to startup
/bin/sleep 300

# download the rpm file
cd "${RPM_LOC}" || exit 1
/bin/curl -O "${DB_RPM_URL}"

/bin/sudo /bin/dnf -y localinstall "${RPM_LOC}/$( /bin/basename "${DB_RPM_URL}" )"

# END
