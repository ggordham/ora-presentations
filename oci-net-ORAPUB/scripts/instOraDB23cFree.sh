#!/bin/bash
#
# instOraDB23cFree.sh

DB_RPM_URL="https://download.oracle.com/otn-pub/otn_software/db-free/oracle-database-free-23c-1.0-1.el8.x86_64.rpm"
RPM_LOC=/home/opc
LSNR_PORT=1521
PASSWORD=Oracle_4U

# install the pre-install RPM
/usr/bin/sudo /usr/bin/dnf install -y oraclelinux-developer-release-el8
/usr/bin/sudo /usr/bin/dnf config-manager --set-enabled ol8_developer 
/usr/bin/sudo /usr/bin/dnf -y install oracle-database-preinstall-23c

# configure firewall for Oracle listener
/usr/bin/sudo sh -c "/usr/bin/firewall-cmd --permanent --zone=public --add-port=${LSNR_PORT}/tcp"
/usr/bin/sudo sh -c "/usr/bin/firewall-cmd --reload"

# wait for proxy server to startup
# /usr/bin/sleep 300

# download the rpm file
cd "${RPM_LOC}" || exit 1
# Note need the -L option for curl to follow 302 redirects
/usr/bin/curl -L -O "${DB_RPM_URL}"

/usr/bin/sudo /bin/dnf -y localinstall "${RPM_LOC}/$( /bin/basename "${DB_RPM_URL}" )"

/usr/bin/sudo /bin/bash -c "(echo $PASSWORD ; echo $PASSWORD;) | /etc/init.d/oracle-free-23c configure > ${HOME}/instOraDB23cFree-configure.log 2>&1 "
# also see log: /opt/oracle/cfgtoollogs/dbca/FREE/FREE.log

# setup environment
setup_script=/usr/local/bin/setoradbfree.sh
/usr/bin/sudo /usr/bin/touch "${setup_script}"
/usr/bin/sudo /usr/bin/chmod 755 "${setup_script}"
/usr/bin/sudo /usr/bin/chown oracle:oinstall "${setup_script}"

{
echo "export ORACLE_SID=FREE" 
echo "export ORAENV_ASK=NO" 
echo "alias dbhome=/opt/oracle/product/23c/dbhomeFree/bin/dbhome" 
echo "source /opt/oracle/product/23c/dbhomeFree/bin/oraenv -s" 
echo "unalias dbhome"  
} | /usr/bin/sudo /usr/bin/tee -a "${setup_script}"

# add setup script to oracle users profile
echo "source ${setup_script}" | /usr/bin/sudo /usr/bin/tee -a /home/oracle/.bashrc

# END
