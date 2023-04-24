# tune-tips-BP4D
Scripts from BLUEPRINT4D conference May 10, 2023

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
2. [Run the lab on Container](#run-the-lab-on-container)
3. [Run the lab on a Linux OS](#run-the-lab-on-a-linux-os)

---

## Ways to run the lab
The scripts can be run in multiple ways depending on your configuration and test system.  The scripts have been udpated to work with a container version of Oracle database as well as a regular Linux OS install.  Also the scripts should work if you are using a stand alone non-container database or if you are using a PDB in a multi-tenant database (container / CDB).  Be sure to look at the specific instructions.

## Run the lab on Container

### Prerequisets
You need a working podman image with Oracle database pre installed.
These scripts have been tested on Oracle 19c and 21c, but should also work on Oracle 12c and 18c.
Your database / PDB should have a USERS tablespace.

Once you have the container up and running with a working database you can install the lab scripts with the following command:

```bash
podman exec DB193 sh -c "curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1"
```

*Note DB193 in the command is the container name, use your container name.  You can find your container name with the ```podman ps``` command.*

Through out the lab you will need a SQL*Plus prompt on the databases.  This is done by running the following podman command.  (Note this command will put you in the directory with the lab scripts and set your SQL Prompt)

**SQL Prompt**
```bash
podman exec -it DB193 sh -c "chmod +x splus.sh; /home/oracle/splus.sh ttipb"
```

You should get a prompt that looks something like this:
```
$ podman exec -it DB193 sh -c "chmod +x splus.sh; /home/oracle/splus.sh ttipb"

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


### See explain plans, with statistics

Lets look at some explain plans and also see a query run and the explain plan with statistics.

```sql
connect perflab/perf$lab&con_pdb

@q1.sql 1
@plan.sql
```

This is a simple plan with very litle information.
For the next example lets gather statistics on the execution and show that in the plan:

```sql
@q1.sql 1
@plan_stats.sql
```

### Look at histogram information

Histograms are very useful set of statistics for performance. Let see the histograms that exist for the tables in the first example:

```sql
connect perflab/perf$lab&con_pdb

@show-hist.sql
```

This shows the top few buckets, notice that one bucket has many more rows than most the other entries.

### AWR settings

AWR SQL history can be very useful, this query shows you the current settings for your AWR snapshots.

```sql
connect perflab/perf$lab&con_pdb

@awr_settings.sql
```

### Create a SQL Profile

In this example we will use the SQL tuning advisor to create a SQL Profile

Run the query and look at the plan

```sql
connect perflab/perf$lab&con_pdb

@q2.sql
@plan.sql
```

Now lets run the tuning advisor and look at the report.

```sql
@tune.sql
@report.sql
```

You should see that a SQL profile is recomended.  So lets go ahead and accept the profile.  Then lets run the query again, and look at the explain plan.  In the notes section it shoudl say that a profile was used.

```sql
@accept.sql
@q2.sql
@plan.sql
```

Finally lets view the information about the SQL profile.

```sql
@lsprofile.sql
@viewhint.sql
```

### Load a baseline from cursor cache

Lets run our sample query for a different value and see what the explain plan shows.  We are going to run it twice to allow the optimizer to get two chances to optimize it.

```sql
connect perflab/perf$lab&con_pdb

@q1.sql 10
@q1.sql 10
@plan_stats.sql
```

Now lets create a baseline using the sql id and plan hash value of the above.

```sql
@cr_baseline fua0hb5hfst77 906334482
@lsbaseline.sql
```

We can now also prove that the baseline is being used.  Lets run query 1 with a value of 1 and see that the baseline forces a hash join plan when it prevously used a nested loop join.

```sql
@q1.sql 1
@plan_stats.sql
```

### Creating a SQL Patch

Here we will create a simple patch that will force the query to use a full table scan.


```sql
connect perflab/perf$lab&con_pdb

@q3.sql
@plan.sql
```

Note that the query does not use a full table scan.  Now lets create a patch with some code from the outline to force the statement to do a full table scan.

```sql
@patchq3.sql
```

Now we will re-run the same query and look at the explain plan and see that the patch is forcing a full table scan and that the patch is used.


```sql
connect perflab/perf$lab&con_pdb

@q3.sql
@plan.sql
```

Note a full table scan is now used.

### Index clustering

In this example we will look at index clustiner and how that impacts the optimziers access patterns.

```sql
connect perflab/perf$lab&con_pdb

@q4.sql
@plan.sql
@show-idx-clus.sql CUSTOMERS CUST_LNAME_IX
```

Note that the query does not use an index when looking up the last name.
Note the clustering factor in relation to the number of blocks and rows in the table.

Lets create a new table that is organized by cuswtomer last name, and then a new index.

```sql
@crcustomer3.sql
```

Now lets query the new table and see if the index gets used.

```sql
@q5.sql
@plan.sql
@show-idx-clus.sql CUSTOMERS3 CUST3_LNAME_IX
```

Note the clustering factor in relation to the number of blocks and rows in the table.


### Clean up
To clean up the lab run if you want to re-run it.  Open a SQL window and run the following commands:

```sql
connect / as sysdba
@drop_baseline
@drop_profile
@drop_patch
DROP USER PERFLAB CASCADE;
```

---

## Run the lab on a Linux OS
### Download the Scripts
You can run the following command from Linux or MAC OSX or Cygwin to download all the items in the repository.

```bash
curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1 "ggordham-ora-presentations-???????/tune-tips-BP4D"
```

### Basic Setup Steps
Run script lab-setup.sql as a user in the database with DBA rights (E.G. SYS or SYSTEM).
This script creates a user called perflab that will be used throughout the demo.


```bash
# Set your Oracle Environment
. oraenv
cd tune-tips-BP4D
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


### See explain plans, with statistics

Lets look at some explain plans and also see a query run and the explain plan with statistics.

```sql
connect perflab/perf$lab

-- If you are using a PDB:
connect perflab/perf$lab&con_pdb

@q1.sql 1
@plan.sql
```

This is a simple plan with very litle information.
For the next example lets gather statistics on the execution and show that in the plan:

```sql
@q1.sql 1
@plan_stats.sql
```

### Look at histogram information

Histograms are very useful set of statistics for performance. Let see the histograms that exist for the tables in the first example:

```sql
connect perflab/perf$lab

-- If you are using a PDB:
connect perflab/perf$lab&con_pdb

@show-hist.sql
```

This shows the top few buckets, notice that one bucket has many more rows than most the other entries.

### AWR settings

AWR SQL history can be very useful, this query shows you the current settings for your AWR snapshots.

```sql
connect perflab/perf$lab

-- If you are using a PDB:
connect perflab/perf$lab&con_pdb

@awr_settings.sql
```

### Create a SQL Profile

In this example we will use the SQL tuning advisor to create a SQL Profile

Run the query and look at the plan

```sql
connect perflab/perf$lab

-- If you are using a PDB:
connect perflab/perf$lab&con_pdb

@q2.sql
@plan.sql
```

Now lets run the tuning advisor and look at the report.

```sql
@tune.sql
@report.sql
```

You should see that a SQL profile is recomended.  So lets go ahead and accept the profile.  Then lets run the query again, and look at the explain plan.  In the notes section it shoudl say that a profile was used.

```sql
@accept.sql
@q2.sql
@plan.sql
```

Finally lets view the information about the SQL profile.

```sql
@lsprofile.sql
@viewhint.sql
```

### Load a baseline from cursor cache

Lets run our sample query for a different value and see what the explain plan shows.  We are going to run it twice to allow the optimizer to get two chances to optimize it.

```sql
connect perflab/perf$lab

-- If you are using a PDB:
connect perflab/perf$lab&con_pdb

@q1.sql 10
@q1.sql 10
@plan_stats.sql
```

Now lets create a baseline using the sql id and plan hash value of the above.

```sql
@cr_baseline fua0hb5hfst77 906334482
@lsbaseline.sql
```

We can now also prove that the baseline is being used.  Lets run query 1 with a value of 1 and see that the baseline forces a hash join plan when it prevously used a nested loop join.

```sql
@q1.sql 1
@plan_stats.sql
```

### Creating a SQL Patch

Here we will create a simple patch that will force the query to use a full table scan.


```sql
connect perflab/perf$lab

-- If you are using a PDB:
connect perflab/perf$lab&con_pdb

@q3.sql
@plan.sql
```

Note that the query does not use a full table scan.  Now lets create a patch with some code from the outline to force the statement to do a full table scan.

```sql
@patchq3.sql
```

Now we will re-run the same query and look at the explain plan and see that the patch is forcing a full table scan and that the patch is used.


```sql
connect perflab/perf$lab

-- If you are using a PDB:
connect perflab/perf$lab&con_pdb

@q3.sql
@plan.sql
```

Note a full table scan is now used.  Lets view the patch information.

```sql
@show-patch.sql
```

### Index clustering

In this example we will look at index clustiner and how that impacts the optimziers access patterns.

```sql
connect perflab/perf$lab

-- If you are using a PDB:
connect perflab/perf$lab&con_pdb

@q4.sql
@plan.sql
@show-idx-clus.sql CUSTOMERS CUST_LNAME_IX
```

Note that the query does not use an index when looking up the last name.
Note the clustering factor in relation to the number of blocks and rows in the table.

Lets create a new table that is organized by cuswtomer last name, and then a new index.

```sql
@crcustomer3.sql
```

Now lets query the new table and see if the index gets used.

```sql
@q5.sql
@plan.sql
@show-idx-clus.sql CUSTOMERS3 CUST3_LNAME_IX
```

Note the clustering factor in relation to the number of blocks and rows in the table.

### Clean up
To clean up the lab run the following two items as a DBA user:

```sql
@drop_baseline
@drop_profile
@drop_patch
DROP USER PERFLAB CASCADE;
```

## The END
