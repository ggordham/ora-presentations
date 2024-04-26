#!/bin/bash
#
# instSquid.sh

SITE_LIST=".oracle.com .oraclecloud.com .github.com"
ALLOW_FILE=/etc/squid/allowed_sites
SQUID_CONF=/etc/squid/squid.conf

#Install the Oracle EPEL repository
/bin/sudo /bin/dnf -y install oracle-epel-release-el8
/bin/sudo /bin/dnf config-manager --set-enable ol8_developer_EPEL
/bin/sudo /bin/dnf config-manager --set-enable ol8_developer_EPEL_modular

# install squid proxy and some network utils
/bin/sudo /bin/dnf -y install nmap-ncat traceroute squid

# add proxy server to local firewall
/bin/sudo /bin/firewall-cmd --permanent --zone=public --add-service=squid
/bin/sudo /bin/firewall-cmd --reload

# enable squid service
/bin/sudo /bin/systemctl enable squid

# basic proxy configuration
for site in ${SITE_LIST}; do
  echo "${site}"  | /bin/sudo /bin/tee -a "${ALLOW_FILE}"
done

echo "acl allowed_sites dstdomain \"${ALLOW_FILE}\"" | /bin/sudo /bin/tee -a "${SQUID_CONF}"
echo "http_access allow allowed_sites" | /bin/sudo /bin/tee -a "${SQUID_CONF}"
echo "http_access deny all" | /bin/sudo /bin/tee -a "${SQUID_CONF}"

# restart squid
/bin/sudo /bin/systemctl restart squid

# END
