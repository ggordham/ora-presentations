# SQL Performance Tuning LVC build guilde

The SQL Performance Tuning LVC has a live lab setup that students can use to walk through examples and try out SQL tuning.  There is also a final section where load is generated on the database and students can live monitor the workload and identify SQL statements that need to be tuned.

## Tools used for the lab

SQL Developer Web which is part of Oracle Rest Data Services (ORDS)
RWP\*Load Simulator https://oracle.github.io/rwloadsim/
Bastillion SSH server https://github.com/bastillion-io/Bastillion/

## Setup process / tools

### Create server

1. Create VM in Oracle OVIRT
   for 26 students used 24 CPU and 24GB memory
   Setup /u01 - /u16 (u01 50GB, u02-u16 100GB)
   two network interfaces (one pass through for NFS network)
2. Set login password in cloud-init under "run once" in ovirt
   start server in run once mode
4. Update network to allow access to yum repo
   Update /etc/sysconfig/network-scripts/ifcfg-eth0
   Update /etc/resolve.conf
   Update /etc/hosts
   Update /etc/hostname
   systemctl restart network
5. Update and install additional packages.

```bash
   dnf -y update
   dnf -y install NetworkManager-tui bind-utils java-latest-openjdk
```

6. Update network configuration
   nmtui (eth0 on DMZ / eth1 vlan 200)
7. Add SSH key to /root/.ssh/authorized_keys
8. reboot server out of run once mode


On MAC desktop setup route to DMZ network
  sudo route -n add -net 10.x.x.x/24 10.x.0.1

### Setup Oracle database and tools

1. Install ora-lab scripts

```bash
/usr/bin/curl https://raw.githubusercontent.com/ggordham/ora-lab/main/scripts/get-ora-lab.sh > /tmp/get-ora-lab.sh
cd /tmp
bash /tmp/get-ora-lab.sh --refresh
```

2. Setup configuration files

copy server.conf to /opt/ora-lab/scripts
copy secure.conf to /opt/ora-lab/scripts

3. edit config files
   make sure server.conf has all storage listed
   update db memory settings
   make sure secure.conf has passwords listed

4. run oracle build

```bash
/opt/ora-lab/scripts/tstOraInst.sh
```

Note: bugs *********************
- Update XFS mount options:
  defaults,noatime,nodiratime,logbufs=8,logbsize=256k,largeio,inode64,swalloc,allocsize=512m,_netdev 0 0
- does not setup data directory before DBCA kicks off
- /u01/app/oracle/admin is owned by root instead of oracle (if DBCA fails)
- ORDS script still having issues (need to check out new version)

### Download lab scripts

```bash
mkdir -p /opt/labsrc
cd /opt/labsrc
curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1 "ggordham-ora-presentations-???????/sql-perftune-LVC23"
```

### ORDS Configuration

1. Update OS firewall

```bash
firewall-cmd --permanent --zone=public --add-port=8080/tcp
````

2. Make static directories for ORDS

```bash
mkdir -p /u01/app/oracle/admin/ords/config/global/doc_root/static
chown -R oracle /u01/app/oracle/admin/ords/config/global/doc_root
chgrp -R oinstall /u01/app/oracle/admin/ords/config/global/doc_root
```

3.  Add robots.txt file

4. configure ORDS (as oracle user)

```bash
ords config set jdbc.MaxLimit 100
ords config set jdbc.MinLimit 2
ords config set jdbc.InitialLimit 2
ords config set standalone.http.port 8080
ords config set standalone.static.context.path /static
ords config set standalone.static.path /u01/app/oracle/admin/ords/config/global/doc_root/static
ords config set security.httpsHeaderCheck "X-Forwarded-Proto: https"
ords config set security.httpsHeaderCheck "https://sqltune.visctech.com"
```

5. restart ords as root user

```bash
systemctl restart ords
```

### Bastillion setup

1. add firewall port for Bastillion

```bash
firewall-cmd --permanent --zone=public --add-port=8443/tcp
```

2. Install bastillion file

```bash
cd /opt
wget https://github.com/bastillion-io/Bastillion/releases/download/v3.15.00/bastillion-jetty-v3.15_00.tar.gz
tar -xvzf bastillion-jetty-v3.15_00.tar.gz
```

3. Configure Bastillion URL

```
/opt/Bastillion-jetty/jetty/webapps/bastillion.xml
<Configure class="org.eclipse.jetty.webapp.WebAppContext">
  <Set name="contextPath">/shell</Set>
```

4. Configure Bastiillion options

```
/opt/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/BastillionConfig.properties
set
oneTimePassword=disabled
maxActive=50
sessionTimeout=30
```

5. Configure addtional memory for Jetty

```
/opt/bastillion/Bastillion-jetty/jetty/bin/jetty.sh
JAVA_OPTIONS="-Xms1024m -Xmx20489m -server"
```

6.  enable auto start

```bash
cp /opt/bastillion/Bastillion-jetty/jetty/bin/jetty.sh /etc/init.d/bastillion
echo JETTY_HOME=/opt/bastillion/Bastillion-jetty/jetty > /etc/default/bastillion
service bastillion start
chkconfig --add bastillion
chkconfig --list
```

default URL: https://10.x.x.x:8443/shell
default user: admin / changeme

7. Login and change admin password

8. Create ssh key assign to students, copy ssh key to: /opt/labsrc/student-key.key
9. Create authorized_keys file at: /opt/labsrc/authorized_keys


### NGNIX setup

1. Login to NGNIX server
*Note: Have to have SSH key in root user as root password login is disabled.*

1. Copy config file to config directory, and reload NGINX

```bash
cp sqltune.visctech.com.conf /etc/nginx/http.d/sqltune.visctech.com.conf
service reload nginx
```

*NOTE: normal to see a bunch of duplicat network messages!*

### DNS setup

The DNS entery should be added before the class starts, and removeda after the class is over.

To add/remove from Dreamhost DNS use these commands:

```bash
# Add:
curl "https://api.dreamhost.com/?key=${api_key}&cmd=dns-add_record&record=${dns_alias}&type=A&value=${public_ip}"

# Remove:
curl "https://api.dreamhost.com/?key=${api_key}&cmd=dns-remove_record&record=${dns_alias}&type=A&value=${public_ip}"
```

More information at:
https://help.dreamhost.com/hc/en-us/articles/4407354972692-Connecting-to-the-DreamHost-API
*Note: I run these commands from Linux so Browser will not cache this key*

## Get ready for the lab

### load data into pdb0

1. run load simulator

```bash
/opt/ora-lab/scripts/oraRWLRun.sh
```

2. load old RWL data

```SQL
@/opt/labsrc/sql-perftune-LVC23/db-build/rwl_extra_data.sql
```

3. create lab users and load lab users tables

```SQL
@/opt/labsrc/sql-perftune-LVC23/db-build/lab-setup.sql
@/opt/labsrc/sql-perftune-LVC23/db-build/ctables.sql
@/opt/labsrc/sql-perftune-LVC23/db-build/sys-stats-stg.sql
```

4. Install sqlt + Grant to perflab user

```bash
cd /opt/labsrc
unzip /mnt/software/Oracle/database/SQLT/sqlt_10g_11g_12c_18c_19c_13th_August_2023.zip
cd /opt/labsrc/sqlt/install
sqlplus /nolog
```

```SQL
connect / as sysdba
START sqcsilent2.sql '@pdb0' Oracle_4U USERS TEMP '' T
```

```SQL
connect / as sysdba
GRANT SQLT_USER_ROLE TO PERFLAB;
```

### Setup teacher profiles in Bastillion

1. setup Teacher user and setup SSH keys
2. Copy SSH key to labsrc area

### student users setup

1. Setup student OS users

Edit the user-setup.sh script for the correct number of students.
Builds out OS users for students and stage all their scripts.

```bash
/opt/labsrc/sql-perftune-LVC23/lab-build/user-setup.sh
```

2. clone pdbs

*Note: you have to provide the target PDB name and mount for target
```bash
/opt/ora-lab/scripts/oraPDBClone.sh pdb01 /u02/oradata
```

3.  make TNS entry for each database

```bash
for i in $( seq 1 1 29 ); do
  if (( i > 9 )); then
      db_name=pdb${i}
  else
      db_name=pdb0${i}
  fi
  /opt/ora-lab/scripts/oraTNS.sh --dbservice "${db_name}"
done
```

4. Verify that each pdb is open

```bash
sqlplus / as sysdba
```

```SQL
show pdbs
```

5. setup static pages in ords

```bash
cp /opt/labsrc/sql-perftune-LVC23/lab-build/index.html /u01/app/oracle/admin/ords/config/global/doc_root/static
```

### Configure RWL for pdb01

1. Update RWL project to point to pdb01

```bash
cp -r /u01/app/oracle/admin/rwlout/workdir/pdb0 /u01/app/oracle/admin/rwlout/workdir/pdb01
cd /u01/app/oracle/admin/rwlout/workdir/pdb01
mv pdb0.env pdb01.env
mv pdb0.rwl pdb01.rwl
sed -i 's/pdb0/pdb01/g' pdb01.env
sed -i 's/pdb0/pdb01/g' pdb01.rwl
sed -i 's/rwl_proj=pdb0/rwl_proj=pdb01/g' /opt/ora-lab/scripts/server.conf
```

2. Update RWL script for bad queries

```bash
cp /u01/app/oracle/rwloadsim/oltp/oe_handle_orders.rwl /u01/app/oracle/rwloadsim/oltp/oe_handle_orders.rwl.orig
cp /opt/labsrc/sql-perftune-LVC23/lab-build/oe_handle_orders.rwl /u01/app/oracle/rwloadsim/oltp
```

3. run test RWL on pdb01

```bash
/opt/ora-lab/scripts/oraRWLRun.sh
```

### Setup student profiles in Bastillion

1. Setup each student user
2. Setup systems for each user
3. Setup profiles for each user
4. Assign users and systems to profiles for each student

## Setup ORAPub materials

1. Setup orapub landing page
2. Create PDF's for students
3. Setup zip file of scripts for students (github release)
4. setup Zoom
5. Get roster for students and update index.html file

## Pre lab checklist

- setup ORAPUB landing page
- Verify static page is available
- Verify database is running
- Verify listenr is running
- Verify TNS names is setup for all PDBs
- Verify all PDBs are open
- Verify SQL Developer web access
- Verify Bastillion access
- Update ZOOM meeting password / ID
- Make sure file copy script is running

Run the copy file script in the background.

```bash
nohup /opt/labsrc/sql-perftune-LVC23/lab-build/copy_student_files.sh > /root/copy_student_files.log 2>&1 &
```

Run workload for tuning lab

```bash
/opt/ora-lab/scripts/oraRWLRun.sh --sec 900 --proc 2
```

# END
