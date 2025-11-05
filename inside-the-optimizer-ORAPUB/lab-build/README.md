# Inside the Optimizer LVC build guilde

*Updated 10/6/2025*

The inside the optimizer LVC has a live lab setup that students can use to walk through examples and try out SQL tuning.  There is also a final section where load is generated on the database and students can live monitor the workload and identify SQL statements that need to be tuned.

## Tools used for the lab

SQL Developer Web which is part of Oracle Rest Data Services (ORDS)
RWP\*Load Simulator https://oracle.github.io/rwloadsim/
Bastillion SSH server https://github.com/bastillion-io/Bastillion/

## Setup process / tools

### Create server

1. Create VM in Oracle OVIRT
   for 26 students used 16 CPU and 16GB memory
   Setup /u01 - /u08 (u01 50GB, u02-u08 100GB)
   two network interfaces (one primary network, one DMZ)
2. Setup network interfaces, SSH key, and DNS through cloud-init.
4. Update and install additional packages.

```bash
   dnf update -y
   dnf install -y NetworkManager-tui bind-utils java-17-openjdk
   dnf install -y nfs-utils
```

5. reboot server


On MAC desktop setup route to DMZ network
  `sudo route -n add -net 10.x.x.x/24 10.x.0.1`

### Setup Oracle database and tools

1. Install ora-lab scripts

```bash
/usr/bin/curl https://raw.githubusercontent.com/ggordham/ora-lab/main/scripts/get-ora-lab.sh > /tmp/get-ora-lab.sh
cd /tmp
bash /tmp/get-ora-lab.sh --refresh
```

2. Setup configuration files

copy server.conf to /opt/ora-lab/scripts

`scp server.conf root@10.x.x.x:/opt/ora-lab/scrtips/`

Creeate secure.conf 

```
cp /opt/ora-lab/scripts/secure_template.conf /opt/ora-lab-scripts/secure.conf
vi /opt/ora-lab-scripts/secure.conf

```

3. edit config files
   make sure server.conf has all storage listed
   update db memory settings
   make sure secure.conf has passwords listed

```
[SECURE]
MOSUSER=xxx
MOSPASS=xxx
EXTRA_SSH=xxx

[DB_SECURE]
db_all_lvcdb1=my_password
db_rwl_lvcdb1=my_rwl_password
db_rwl_pdb0=my_rwl_password
```

4. run oracle build

```bash
/opt/ora-lab/scripts/tstOraInst.sh
```

Note: bugs *********************
- Update XFS mount options:
  defaults,noatime,nodiratime,logbufs=8,logbsize=256k,largeio,inode64,swalloc,allocsize=512m,_netdev 0 0

### Download lab scripts

```bash
mkdir -p /opt/labsrc
chown oracle:oinstall /opt/labsrc
cd /opt/labsrc
curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1 "ggordham-ora-presentations-???????/inside-the-optimizer-ORAPUB"
```

### ORDS Configuration

1. Update OS firewall

```bash
firewall-cmd --permanent --zone=public --add-port=8080/tcp
```

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
ords config delete standalone.https.port
ords config delete standalone.https.host
```

5. Update the /etc/ords.conf file

```
SERVE_EXTRA_ARGS=--port 8080
```

6. restart ords as root user

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
/opt/Bastillion-jetty/jetty/bin/jetty.sh
JAVA_OPTIONS="-Xms1024m -Xmx20489m -server"
```
6. Set inital DB password

```bash
cd /opt/Bastillion-jetty
./startBastillion.sh
```

Note: you will be prompted to enter a new database password twice.  This is for the Bastillion internal database.  After it starts you can verify the URL that it is running.  Once verified, press CTL+C to kill the application and proceed to next step.

7.  enable auto start

```bash
cp /opt/Bastillion-jetty/jetty/bin/jetty.sh /etc/init.d/bastillion
echo JETTY_HOME=/opt/Bastillion-jetty/jetty > /etc/default/bastillion
service bastillion start
chkconfig --add bastillion
chkconfig --list
```

default URL: https://10.x.x.x:8443/shell
default user: admin / changeme

8. Login and change admin password

9. Create ssh key assign to students, copy ssh key to: /opt/labsrc/student-key.key

10. Create authorized_keys file at: /opt/labsrc/authorized\_keys - this should contain the global authorized key. You can get this from the root user authorized_keys file after creating a root user terminal and testing in Bastillion.


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

*NOTE: if you are seeing HTTPS erorrs, be sure NGINX configuration file has been setup and reloaded.*

## Get ready for the lab

### load data into pdb0

1. Resize the data, system, and sysaux tablespace

```SQL
alter database datafile '/u02/oradata/LVCDB1/pdb0/data01.dbf' resize 28G;
alter database datafile '/u02/oradata/LVCDB1/pdb0/system01.dbf' resize 768M;
alter database datafile '/u02/oradata/LVCDB1/pdb0/sysaux01.dbf' resize 768M;

```

2. run load simulator

```bash
/opt/ora-lab/scripts/oraRWLRun.sh
```

3. Connect to pdb as sys user, load extra rwl data

```SQL
@/opt/labsrc/sql-perftune-LVC23/db-build/rwl_extra_data.sql
```

4. create lab users and load lab users tables

```SQL
@/opt/labsrc/sql-perftune-LVC23/db-build/lab-setup.sql
@/opt/labsrc/sql-perftune-LVC23/db-build/ctables.sql
```

5. Install sqlt + Grant to perflab user

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
for i in $( seq 1 1 14 ); do
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
cp /opt/labsrc/inside-the-optimizer-ORAPUB/lab-build/index.html /u01/app/oracle/admin/ords/config/global/doc_root/static
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
chmod +x /opt/labsrc/sql-perftune-LVC23/lab-build/copy_student_files.sh
nohup /opt/labsrc/sql-perftune-LVC23/lab-build/copy_student_files.sh > /root/copy_student_files.log 2>&1 &
```

Run workload for tuning lab

```bash
/opt/ora-lab/scripts/oraRWLRun.sh --sec 900 --proc 2
```

# END
