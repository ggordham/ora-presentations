# spm-UTOUG
Updated Scripts from the UTOUG SPM presentation presentation 3/8/2023 at 8:45 AM - 9:45 AM MST (Originally March 17, 2021)

These scripts are mostly based on examples from the Oracle example github repository:
https://github.com/oracle/oracle-db-examples

2/20/2023 - updated from 2021 original presentation.
I have updated / changed code for the purpose of this presentation.
Scripts have been updated to run everything as perflab user and not switch to the SYS user.

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
2. [Run the lab on Container](#run-the-lab-on-container)
3. [Run the lab on a Linux OS](#run-the-lab-on-a-linux-os)

## Ways to run the lab
The scripts can be run in multiple ways depending on your configuration and test system.  The scripts have been udpated to work with a docker container version of Oracle database as well as a regular Linux OS install.  Also the scripts should work if you are using a stand alone non-container database or if you are using a PDB in a multi-tenant database (container / CDB).  Be sure to look at the specific instructions.

---

## Run the lab on Container

### Prerequisets
You need a working docker or podman image with Oracle database pre installed.
These scripts have been tested on Oracle 19c and 21c, but should also work on Oracle 12c and 18c.
Your database / PDB should have a USERS tablespace.

Once you have the container up and running with a working database you can install the lab scripts with the following command:

*Note: The commands are using podman, you can replace podman with docker if you are using docker.*

```bash
podman exec DB193 sh -c "curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1"
```

*Note DB193 in the command is the container name, use your container name.  You can find your container name with the ```podman ps``` command.*

Through out the lab you will need a SQL*Plus prompt on the databases.  This is done by running the following docker command.  (Note this command will put you in the directory with the lab scripts and set your SQL Prompt)

**SQL Prompt**

```bash
podman exec -it DB193 sh -c "chmod +x splus.sh; /home/oracle/splus.sh spmu"
```

You should get a prompt that looks something like this:

```bash
$ docker exec -it DB193 sh -c "chmod +x splus.sh; /home/oracle/splus.sh spmu"

SQL*Plus: Release 21.0.0.0.0 - Production on Thu Jan 6 19:24:17 2022
Version 21.3.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.

SP2-0640: Not connected
@ 06-JAN-22>
```

### Basic Setup Steps
Run script lab-setup.sql as a user in the database with DBA rights (E.G. SYS or SYSTEM).
This script creates a user called perflab that will be used throughout the demo.

```sql
connect / as sysdba
@lab-setup.sql

@ctables.sql

```

### Look at table information

```sql
@connect.sql
@show-hist.sql

```

In the first query results we can see that the two tables (T1, T2) have 500,000 rows each.  In the second set of results, we see that for column D the 2nd bucket (ENDPOINT_VALUE = 10) has more than one row, while the other four values have only one row.

### Current Baselines

Drop current baselines and show that there are no current baselines loaded:

```sql
@drop.sql
@list.sql

```

### First test - Auto capture a baseline

In this test we will auto capture a baseline from a session.  The session has to run the SQL twice before it will be captured.

```sql
@test1.sql

```

### Second test - auto capture another baseline plan

Now we will capture another baseline plan for the same SQL, even though auto capture baselines is now set to false.

```sql
@test2.sql

```

### Third test - evolve the baseline

Now we will evolve the baseline, basically test the new captured plan and let Oracle decide if it is worth accepting.  Then we will show our SQL statement as it uses the new baseline plans.

```sql
@test3.sql

```

### Look at the Baselines

You can view more information about baselines and how they are used by joining the DBA_SQL_PLAN_BASELINES and GV$SQL views.  Note the example script to see how to properly join the two views.

```sql
@show_baseline.sql

```

### Clean up
To clean up the lab run the following two items:

```sql
@drop.sql

-- CONNECT as DBA user
connect / as sysdba

DROP USER PERFLAB CASCADE;

```

---

## Run the lab on a Linux OS


### Download the Scripts
You can run the following command from Linux or MAC OSX or Cygwin to download all the items in the repository.

```bash
curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1 "ggordham-ora-presentations-???????/spm-UTOUG"
```

### Basic Setup Steps
Run script lab-setup.sql as a user in the database with DBA rights (E.G. SYS or SYSTEM).
This script creates a user called perflab that will be used throughout the demo.

```bash
# Set your Oracle Environment
. oraenv
cd spm-UTOUG
# if you are using a PDB set the PDB name
export ORACLE_PDB_SID=mypdb
sqlplus /nolog

```

```sql
connect / as sysdba
@lab-setup.sql

-- if you are NOT using a PDB
DEFINE con_pdb=""

-- if you are using a PDB define the PDB name be sure to include the @ sign
DEFINE con_pdb="@mypdb"

@ctables.sql

```

This will create two tables, T1 and T2.  The tables have skewed data distribution in the column D.  24,999 rows are unique, and 25,001 rows contain the value 10.
By default Oracle assumes a normal distribution, as we have run enhanced statistics, a histogram is created on this column.

### Look at table information

```sql
-- if you are NOT using a PDB
DEFINE con_pdb=""

-- if you are using a PDB define the PDB name be sure to include the @ sign
DEFINE con_pdb="@mypdb"

@connect.sql
@show-hist.sql

```

In the first query results we can see that the two tables (T1, T2) have 500,000 rows each.  In the second set of results, we see that for column D the 2nd bucket (ENDPOINT_VALUE = 10) has more than one row, while the other four values have only one row.

### Current Baselines

Drop current baselines and show that there are no current baselines loaded:

```sql
@drop.sql
@list.sql

```

### First test - Auto capture a baseline

In this test we will auto capture a baseline from a session.  The session has to run the SQL twice before it will be captured.

```sql
@test1.sql

```

### Second test - auto capture another baseline plan

Now we will capture another baseline plan for the same SQL, even though auto capture baselines is now set to false.

```sql
@test2.sql

```

### Third test - evolve the baseline

Now we will evolve the baseline, basically test the new captured plan and let Oracle decide if it is worth accepting.  Then we will show our SQL statement as it uses the new baseline plans.

```sql
@test3.sql

```

### Look at the Baselines

You can view more information about baselines and how they are used by joining the DBA_SQL_PLAN_BASELINES and GV$SQL views.  Note the example script to see how to properly join the two views.

```sql
@show_baseline.sql

```

### Clean up
To clean up the lab run the following two items:

```sql
-- if you are NOT using a PDB
DEFINE con_pdb=""

-- if you are using a PDB define the PDB name be sure to include the @ sign
DEFINE con_pdb="@mypdb"

@drop.sql

-- CONNECT as DBA user
connect / as sysdba

DROP USER PERFLAB CASCADE;

```

## The END
