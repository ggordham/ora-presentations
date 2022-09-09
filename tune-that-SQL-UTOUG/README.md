# tune-that-sql-UTOUG
Scripts from the Utah Oracle User Group (UTOUG) Training Days August 2022

These scripts are mostly based on examples from the Oracle example github repository:
https://github.com/oracle/oracle-db-examples
Also the top_sql script is based on work from Jeff Smith
https://www.thatjeffsmith.com/archive/2016/10/top-sql-seeing-what-hurts-in-the-v4-2-instance-viewer/

I have updated / changed code for the purpose of this presentation.
Scripts have been updated to run everything as perflab user and not switch to the SYS user.

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
docker exec -it DB213 sh -c "chmod +x splus.sh; /home/oracle/splus.sh tsqlu"
```

You should get a prompt that looks something like this:
```
$ docker exec -it DB213 sh -c "chmod +x splus.sh; /home/oracle/splus.sh tsqlu"

SQL*Plus: Release 21.0.0.0.0 - Production on Thu Jan 6 19:24:17 2022
Version 21.3.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.

SP2-0640: Not connected
@ 06-JAN-22>
```

You will need multiple windows with SQL*Plus prompts throughout the lab.

### Setup test tables and user for lab
Open a SQL*Plus prompt and run the following script

```sql
@lab-setup
```

This step will create a user called PERFLAB that will be used througout the lab.

Now create the tables for the lab:

```sql
@ctables
```

If you see any errors do not proceed with the lab.

### Generate some load to find top SQL
Open a second window to your test system.  In one window you will generate a bunch of SQL sessions.  In the second window you will look at top SQL statements for the PERFLAB user.

In a shell window run the following docker command
```bash
docker exec -it DB213 sh -c "chmod +x shrun.sh; /home/oracle/shrun.sh tsqlu make-load.sh"
```

In a second window where you have a SQL prompt run the following command after the load is running:
```sql
connect perflab/perf$lab&con_pdb
@top_sql
```
Here we can see a number of SQL statements in the cursor cache.  You can see a good deal of information about each statement.  Be sure to look at the top_sql script and understand what other data you might want to know about a SQL statement.  Find the SQL_ID for a statement you want to see more details on:

```
INST_ID SQL                                        PARSING_SCHEMA_ SQL_ID        PLAN_HASH_VALUE OPTIMIZER_COST EXECS
------- ------------------------------------------ --------------- ------------- --------------- -------------- --------
     1   select count(*) from t2 w                 PERFLAB         19nmwtxrh5rf1 3321871023                 637       50
     1   SELECT /*+ gather_plan_st                 PERFLAB         fua0hb5hfst77 3534348942                 560      119
```

Notice the SQL_ID column.

### Look at a plan for a SQL statement

Copy the SQL_ID from one of the top statments, and look at the execution plan saved in the cursor cache. Note you may find a SQL statement with more than one plan has value.  You may want to look at the muliptle plans for that statement as well.

Run the following command in the same SQL window you used to get the TOP_SQL information:

```sql
  -- Be sure to put the SQL_ID as the first option for the script
@plan_sql_id <SQL_ID>
```

You should then get a detailed explain plan for the SQL statement.  Note depending on the statement you may get more than one plan, as Oracle allows for multiple execution plans for the same statement.

### Current Baselines

Drop current baselines and show that there are no current baselines loaded:

```sql
connect perflab/perf$lab&con_pdb
@drop
@list
```

This should show that there are no baselines currently loded.  You should see the final query state "no rows selected"

### Capturing a SQL Baseline

In this test we will auto capture a baseline from a session.  The session has to run the SQL twice before it will be captured.

First we will enable baseline capture and run the SQL twice in order for a baseline to be captured.

```sql
connect perflab/perf$lab&con_pdb

alter session set optimizer_capture_sql_plan_baselines = TRUE;
@q1 1000
@q1 1000
alter session set optimizer_capture_sql_plan_baselines = FALSE;
```

Be sure you disable capturing baselines before continuing.

Now lets verify that the baseline exists.

```sql
@plan
@list
```

You should see one baseline has been created.

### Real plan vs cached plan

In this example we will look at the difference between a real plan and a cached plan.
First we will need to purge the sql from the cursor cach.

```sql
@purge_cursor fua0hb5hfst77
```

If you see this error "shared pool object does not exist, cannot be pinned/purged" that is ok.  It just means the cursor has not been loaded into the cache yet.

Now we will run the query with two different lookup values.  Note the difference actual vs estimated rows and byts vs buffers.

```sql
connect perflab/perf$lab&con_pdb

@q1 1000
@plan
  -- Note the plan information, it should contain NESTED LOOPS and have a cost of about 560
@q1 10
@plan
  -- Note the plan information, the cost should match
```

In the second plan, you should see a dramtic difference in estimated rows vs actual rows retrieved / scanned for the lookup value of 10.  This is due to the execution plan from the lookup value of 1000 is cached.
E-Rows of 1 vs A-Rows of 250K.

To get the real explain plan for the lookup value of ten we will purge the cursor again, and then run just that query and capture that plan first.

First we need a baseline to fix the plan.  Make sure the baseline still exits from previous lab steps.  If not go back and create the baseline.

```sql
connect perflab/perf$lab&con_pdb

@list
```

Now we want to purge the cursor from cache to force new plans to be costed.

```sql
@purge_cursor fua0hb5hfst77
```

Finally we will generate huristics on the column used in the query to help Oracle understand the data better, then we will run the query again and get the real plan cost with the NESTED LOOPS execution plan.

```sql
connect perflab/perf$lab&con_pdb

@gatherh
@q1 10
@plan
-- Note the plan information
```

You should see a dramatic difference in the plan cost now that the real number of estimated rows is being used, E.G. new cost of 741K vs 560 of the old plan.

### Clean up
To clean up the lab run if you want to re-run it.  Open a SQL window and run the following commands:

```sql
connect / as sysdba
@drop
DROP USER PERFLAB CASCADE;
```

---

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
cd tune-that-SQL-UTOUG
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

This will create two tables, T1 and T2.  The tables have skewed data distribution in the column D.  24,999 rows are unique, and 25,001 rows contain the value 10.
By default Oracle assumes a normal distribution, as we have run enhanced statistics, a histogram is created on this column.

### Generate some load

Open a second window to your test system.  In one window you will generate a bunch of SQL sessions.  In the second window you will look at top SQL statements for the PERFLAB user.

```bash
# Set your Oracle Environment
. oraenv
cd tune-that-SQL-UTOUG
./make-load.sh
```

While the make load is running, in a second window connect to SQL\*PLus and check the top SQL statements:
```bash
cd tune-that-SQL-UTOUG
sqlplus /nolog
```
```sql
connect perflab/perf$lab

-- If you are using a PDB:
connect perflab/perf$lab@mypdb

-- Once connected run:
@top_sql
```

Here we can see a number of SQL statements in the cursor cache.  You can see a good deal of information about each statement.  Be sure to look at the top_sql script and understand what other data you might want to know about a SQL statement.

```
INST_ID SQL                                        PARSING_SCHEMA_ SQL_ID        PLAN_HASH_VALUE OPTIMIZER_COST EXECS
------- ------------------------------------------ --------------- ------------- --------------- -------------- --------
     1   select count(*) from t2 w                 PERFLAB         19nmwtxrh5rf1 3321871023                 637       50
     1   SELECT /*+ gather_plan_st                 PERFLAB         fua0hb5hfst77 3534348942                 560      119
```

Notice the SQL_ID column.

*NOTE: if you are having issues with the make-load.sh script not find your database, or PDB then you can manually set some variables.  These variables will be used to set the location of your database HOME, SID, and PDB.*

Edit the make-load.sh file and update the following lines based on your configuration (they will be blank by default).

After Edit:

```
MY_SID=cdb1
MY_PDB=pdb1
MY_HOME=/u01/app/oracle/product/21c/dbhome_1
MY_TNS=$ORACLE_HOME/network/admin
```

### Look at a plan for a SQL statement

Copy the SQL_ID from one of the top statments, and look at the execution plan saved in the cursor cache. Note you may find a SQL statement with more than one plan has value.  You may want to look at the muliptle plans for that statement as well.

Run the following command in the same SQL window you used to get the TOP_SQL information:

```sql
@plan_sql_id <SQL_ID>
```

You should then get a detailed explain plan for the SQL statement.  Note depending on the statement you may get more than one plan, as Oracle allows for multiple execution plans for the same statement.

### Current Baselines

Drop current baselines and show that there are no current baselines loaded:

```sql
connect perflab/perf$lab

-- If you are using a PDB:
connect perflab/perf$lab@mypdb

@drop
@list
```

### Capturing a SQL Baseline

In this test we will auto capture a baseline from a session.  The session has to run the SQL twice before it will be captured.

First we will enable baseline capture and run the SQL twice in order for a baseline to be captured.
```sql
connect perflab/perf$lab

-- If you are using a PDB:
connect perflab/perf$lab@mypdb

alter session set optimizer_capture_sql_plan_baselines = TRUE;
@q1 1000
@q1 1000
alter session set optimizer_capture_sql_plan_baselines = FALSE;
```

Be sure you disable capturing baselines before continuing.

Now lets verify that the baseline exists.

```sql
@plan
@list
```

### Real plan vs cached plan

In this example we will look at the difference between a real plan and a cached plan.
First we will need to purge the sql from the cursor cach.

Now we will run the query with two different lookup values.  Note the difference actual vs estimated rows and byts vs buffers.

```sql
connect perflab/perf$lab

-- If you are using a PDB:
connect perflab/perf$lab@mypdb

@q1 1000
@plan
 -- Note the plan information
@q1 10
@plan
 -- Note the plan information
```

In the second plan, you should see a dramtic difference in estimated rows vs actual rows retrieved / scanned for the lookup value of 10.  This is due to the execution plan from the lookup value of 1000 is cached.
E-Rows of 1 vs A-Rows of 250K.

To get the real explain plan for the lookup value of ten we will purge the cursor again, and then run just that query and capture that plan first.

First we need a baseline to fix the plan.  Make sure the baseline still exits from previous lab steps.  If not go back and create the baseline.

```sql
connect perflab/perf$lab

-- If you are using a PDB:
connect perflab/perf$lab@mypdb

@list
```

Now we want to purge the cursor from cache to force new plans to be costed.

```sql
@purge_cursor fua0hb5hfst77
```

Finally we will generate huristics on the column used in the query to help Oracle understand the data better, then we will run the query again and get the real plan cost with the NESTED LOOPS execution plan.

```sql
connect perflab/perf$lab

-- If you are using a PDB:
connect perflab/perf$lab@mypdb

@gatherh
@q1 10
@plan
-- Note the plan information
```

You should see a dramatic difference in the plan cost now that the real number of estimated rows is being used, E.G. new cost of 741K vs 560 of the old plan.

### Clean up
To clean up the lab run the following two items as a DBA user:

```sql
@drop
DROP USER PERFLAB CASCADE;
```

## The END
