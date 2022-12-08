# Example of how to create a SQL profile
Scripts from the Midwest Rocky Mountain Oracle User Group (RMOUG) metting February 17, 2023

### DISCLAIMER

*  These scripts are provided for educational purposes only.
*  They are NOT supported by Oracle World Wide Technical Support.
*  The scripts have been tested and they appear to work as intended.
*  You should always run scripts on a test instance.

### WARNING

*  These scripts drop and create tables. For use on test databases.

All code here is use at your own risk, they are intended to be run in a lab system or test system.
These are for training purposes and should not be run in a production or production like environment.

The scripts have been modified for the purpose of the lab and to make them easy to step through for instructional purposes.

# Table of Contents
1. [Ways to run the lab](#ways-to-run-the-lab)
2. [Run the lab on Docker](#run-the-lab-on-docker)
3. [Run the lab on a Linux OS](#run-the-lab-on-a-linux-os)

---

## Ways to run the lab
The scripts can be run in multiple ways depending on your configuration and test system.  The scripts have been udpated to work with a docker container version of Oracle database as well as a regular Linux OS install.  Also the scripts should work if you are using a stand alone non-container database or if you are using a PDB in a multi-tenant database (container / CDB).  Be sure to look at the specific instructions.

## Run the lab on Docker

### Prerequisets
You need a working docker image with Oracle database pre installed.
These scripts have been tested on Oracle 19c and 21c, but should also work on Oracle 12c and 18c.
Your database / PDB should have a USERS tablespace.

Once you have the container up and running with a working database you can install the lab scripts with the following command:

```bash
docker exec DB213 sh -c "curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1"
```

*Note DB213 in the command is the container name, use your container name.  You can find your container name with the ```docker ps``` command.*

Through out the lab you will need a SQL*Plus prompt on the databases.  This is done by running the following docker command.  (Note this command will put you in the directory with the lab scripts and set your SQL Prompt)

**SQL Prompt**
```bash
docker exec -it DB213 sh -c "chmod +x splus.sh; /home/oracle/splus.sh profr"
```

You should get a prompt that looks something like this:
```
$ docker exec -it DB213 sh -c "chmod +x splus.sh; /home/oracle/splus.sh profr"

SQL*Plus: Release 21.0.0.0.0 - Production on Thu Jan 6 19:24:17 2022
Version 21.3.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.

SP2-0640: Not connected
@ 06-JAN-22>
```


## Run the lab on a Linux OS
### Download the Scripts
You can run the following command from Linux or MAC OSX or Cygwin to download all the items in the repository.

```bash
curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1
```

### Basic Setup Steps
Run script lab-setup.sql as a user in the database with DBA rights (E.G. SYS or SYSTEM).
This script creates a user called perflab that will be used throughout the demo.


```bash
# Set your Oracle Environment
. oraenv
cd sql-profiles-RMOUG
# if you are using a PDB set the PDB name
export ORACLE_PDB_SID=mypdb
sqlplus /nolog
```

In SQL*Plus run:
```sql
connect / as sysdba
@lab-setup

-- if you are NOT using a PDB
DEFINE con_pdb=""
@ctables

-- if you are using a PDB define the PDB name be sure to include the @ sign
DEFINE con_pdb="@mypdb"
@ctables
```

If you see any errors do not proceed with the lab.


### Sample query with execution plan

Run the query and View the execution plan

```
@q1
@plan
```

### Sample query with execution plan

Trace the query

```
@purge gtrznmtvm13vu
@trace no_profile
```

Run the SQL tuning advisor
@tune gtrznmtvm13vu
@report
@accept

Show that we have a profile now
@lsprofile gtrznmtvm13vu

Re-run the query to show the profile is in use
@q1
@plan

Show that the profile usage is in cursor cache
@lsprofile gtrznmtvm13vu

See the hints in the profile
@viewhint

Trace the profile
@purge 70nv63r37j039
@trace profile


