#!/bin/bash
#
# instPIHole.sh

# pass in argument PRE or POST to run the specific set of actions

return_code=0

case "$1" in
    "PRE")
        echo "Running instPIHole.sh PRE mode $( /usr/bin/date )" 
        # disable SELinux
        echo "Disable SELinux"
        /bin/sudo /bin/sed -i "s/^SELINUX=.*/SELINUX=disabled/g" /etc/selinux/config
        # add /usr/local/bin to the path
        echo "adding /usr/local/bin to PATH in user profile"
        /bin/sudo /bin/sed -i "s#^PATH=.*#PATH=\$PATH:/usr/local/bin:\$HOME/bin#g" "$HOME/.bash_profile"
        echo "Adding execute mode to all scripts in home directory"
        /bin/chmod +x "${HOME}"/*.sh
        echo "Installing runonce script for run of POST step"
        /bin/chmod +x "${HOME}"/*.sh
        "${HOME}"/runonce.sh "${HOME}/instPIHole.sh POST > ${HOME}/instPIHole2.log 2>&1"  > "${HOME}/runonceInst.log" 2>&1
        echo "Crontab list"
        /usr/bin/crontab -l
        echo "setting up reboot command"
        echo "/usr/bin/sudo /usr/sbin/reboot" | /usr/bin/at now +1 minute
        /usr/bin/at -l
        
        echo "returning with no error"
        return_code=0
        ;;

    "POST")
        #Install the Oracle EPEL repository
        /bin/sudo /bin/dnf -y install oracle-epel-release-el8
        /bin/sudo /bin/dnf config-manager --set-enable ol8_developer_EPEL
        /bin/sudo /bin/dnf config-manager --set-enable ol8_developer_EPEL_modular
        
        # enable DNS in firewalld
        /bin/sudo /bin/firewall-cmd --permanent --add-service=dns
        /bin/sudo /bin/firewall-cmd --permanent --add-port=9999/tcp
        /bin/sudo /bin/firewall-cmd --reload
        
        /bin/curl -sSL https://install.pi-hole.net > "${HOME}/basic-install.sh"

        /bin/sudo /bin/mkdir -p /etc/pihole
       
        # configure pihole 
        PIH_FILE=/etc/pihole/setupVars.conf

        /bin/sudo /bin/touch "${PIH_FILE}"
        echo "PIHOLE_INTERFACE=$( /usr/sbin/ip -br link | /bin/awk '$1 !~ "lo|vir|wl" {print $1}' )" | /bin/sudo tee -a "${PIH_FILE}"
        echo "PIHOLE_DNS_1=8.8.8.8" | /bin/sudo tee -a "${PIH_FILE}"
        echo "PIHOLE_DNS_2=8.8.4.4" | /bin/sudo tee -a "${PIH_FILE}"
        echo "QUERY_LOGGING=true" | /bin/sudo tee -a "${PIH_FILE}"
        echo "INSTALL_WEB_SERVER=true" | /bin/sudo tee -a "${PIH_FILE}"
        echo "INSTALL_WEB_INTERFACE=true" | /bin/sudo tee -a "${PIH_FILE}"
        echo "LIGHTTPD_ENABLED=true" | /bin/sudo tee -a "${PIH_FILE}"
        echo "CACHE_SIZE=10000" | /bin/sudo tee -a "${PIH_FILE}"
        echo "DNS_FQDN_REQUIRED=true" | /bin/sudo tee -a "${PIH_FILE}"
        echo "DNS_BOGUS_PRIV=true" | /bin/sudo tee -a "${PIH_FILE}"
        echo "DNSMASQ_LISTENING=local" | /bin/sudo tee -a "${PIH_FILE}"

        /bin/chmod +x "${HOME}/basic-install.sh"
        set -o pipefail; /bin/sudo /bin/su -c "export PIHOLE_SKIP_OS_CHECK=true; ${HOME}/basic-install.sh --unattended"
        return_code=$?

        # install custom IP list
        /bin/sudo /bin/cp "${HOME}/custom.list" "/etc/pihole/"
        /bin/sudo /bin/cp "/etc/pihole/custom.list" "/etc/pihole/custom.list.bak"

        if (( return_code < 1 )); then

            # configure PI Hole to respond to all requets on local interface, not just local subnet
            /usr/local/bin/pihole -a -i single

            # restart DNS to adjust settings
            /usr/local/bin/pihole restartdns
            
            # update http server port
            /bin/sudo sed -i "s/server.port =.*/server.port = 9999/g" /etc/lighttpd/lighttpd.conf
            /bin/sudo /bin/systemctl restart lighttpd

            # now that DNS is installed we can configure the server to look like everyone else
            [ -f /home/opc/srvrSetup.sh ] && /bin/bash /home/opc/srvrSetup.sh > /home/opc/srvrSetup.log

        fi
        ;;
    *)
        echo "ERROR! not a valid script run mode!" >&2
        return_code=1
        ;;
esac

exit $return_code
#END
