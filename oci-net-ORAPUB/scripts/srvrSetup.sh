#!/bin/bash
#
# srvrSetup.sh

# setup standard server settings
DNS_SERVER=10.202.202.2
DNS_DOMAIN=cloud.oraontap.com
PROXY_SERVER=prox01.cloud.oraontap.com
PROXY_PORT=3128


# setup DNS 
echo "nameserver ${DNS_SERVER}" | /bin/sudo /bin/tee -a /etc/resolve.conf
echo "search ${DNS_DOMAIN}" | /bin/sudo /bin/tee -a /etc/resolve.conf

# setup PROXY server
# start with DNF configuration
echo "proxy=http://${PROXY_SERVER}:${PROXY_PORT}" | /bin/sudo /bin/tee -a /etc/dnf/dnf.conf

# setup proxy server for command line tools like curl
echo "" | /bin/sudo /bin/tee -a /etc/bashrc
echo "# added by srvrSetup.sh script" | /bin/sudo /bin/tee -a /etc/bashrc
echo "export http_proxy=\"http://${PROXY_SERVER}:${PROXY_PORT}\"" | /bin/sudo /bin/tee -a /etc/bashrc
echo "export https_proxy=\"http://${PROXY_SERVER}:${PROXY_PORT}\"" | /bin/sudo /bin/tee -a /etc/bashrc

# END
