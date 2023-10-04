Create VM
Update /etc/hosts
Update /etc/hostname
Update /etc/resolve.conf
Update /etc/sysconfig/network-scripts/ifcfg-eth0

Set login password in cloud-init under "run once" in ovirt

Update OS
dnf update

install network Mangaer TUI
dnf install NetworkManager-tui bind-utils

sudo route -n add -net 10.128.0.0/24 10.8.0.1

reboot system

Attach storage for /u01 and /u02

```bash
/usr/bin/curl https://raw.githubusercontent.com/ggordham/ora-lab/main/scripts/get-ora-lab.sh > /tmp/get-ora-lab.sh
cd /tmp
bash /tmp/get-ora-lab.sh --refresh

```

copy server.conf to /opt/ora-lab/
copy secure.conf to /opt/ora-lab/

Note: bugs *********************
- does not setup data directory before DBCA kicks off
- /u01/app/oracle/admin is owned by root instead of oracle
- ORDS script still having issues (need to check out new version)


firewall-cmd --permanent --zone=public --add-port=8080/tcp
firewall-cmd --permanent --zone=public --add-port=8443/tcp

Bastillion

dnf install java-latest-openjdk

wget https://github.com/bastillion-io/Bastillion/releases/download/v3.15.00/bastillion-jetty-v3.15_00.tar.gz


edit
/opt/bastillion/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/BastillionConfig.properties
set
oneTimePassword=disabled

enable auto start
cp /opt/bastillion/Bastillion-jetty/jetty/bin/jetty.sh /etc/init.d/bastillion
echo JETTY_HOME=/opt/bastillion/Bastillion-jetty/jetty > /etc/default/bastillion
service bastillion start
chkconfig --add bastillion
chkconfig --list

URL: https://10.128.0.81:8443/
default user:
admin / changeme


Add each user / each system
create one profile for students
map systems to profile

Create ssh key assign to students
copy ssh key to each user home directory id_rsa file

WETTY

https://github.com/butlerx/wetty

dnf install gcc-c++
sudo yum install https://rpm.nodesource.com/pub_16.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y
sudo yum install nodejs -y --setopt=nodesource-nodejs.module_hotfixes=1 --allowerasing

chmod o+w /usr/local/lib

adduser wetty

su - wetty

npm -g -i wetty


shellinabox
https://github.com/shellinabox/shellinabox

mkdir /opt/src
cd /opt/src
yum install git openssl-devel pam-devel zlib-devel autoconf automake libtool make

 git clone https://github.com/shellinabox/shellinabox.git && cd shellinabox

 autoreconf -i

dnf install openssl-devel-1.0

 ./configure --disable-dependency-tracking && make
./configure --disable-ssl --disable-runtime-loading

[root@lvcgg01 shellinabox]# make install
make  install-am
make[1]: Entering directory `/opt/src/shellinabox'
make[2]: Entering directory `/opt/src/shellinabox'
 /usr/bin/mkdir -p '/usr/local/bin'
  /bin/sh ./libtool   --mode=install /usr/bin/install -c shellinaboxd '/usr/local/bin'
libtool: install: /usr/bin/install -c shellinaboxd /usr/local/bin/shellinaboxd
 /usr/bin/mkdir -p '/usr/local/share/doc/shellinabox'
 /usr/bin/install -c -m 644 AUTHORS COPYING GPL-2 NEWS '/usr/local/share/doc/shellinabox'
 /usr/bin/mkdir -p '/usr/local/share/man/man1'
 /usr/bin/install -c -m 644 shellinaboxd.1 '/usr/local/share/man/man1'
make[2]: Leaving directory `/opt/src/shellinabox'
make[1]: Leaving directory `/opt/src/shellinabox'
[root@lvcgg01 shellinabox]#


firewall-cmd --permanent --zone=public --add-port=8080/tcp
firewall-cmd --permanent --zone=public --add-port=8443/tcp


mkdir /var/lib/shellinabox

cp /opt/src/shellinabox/debian/shellinabox.init /etc/init.d/shellinabox
cp /opt/src/shellinabox/debian/shellinabox.default /etc/default/shellinabox

edit /etc/init.d/shellinabox
Update deamon location to /usr/local/bin

edit /etc/default/shellinabox add command line option -t

adduser shellinabox
