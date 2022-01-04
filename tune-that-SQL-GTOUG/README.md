# tune-that-sql-NYOUG
Scripts from the Gutemala Tune that SQL presentation presentation January 2022

These scripts are mostly based on examples from the Oracle example github repository:
https://github.com/oracle/oracle-db-examples
Also the top_sql script is based on work from Jeff Smith
https://www.thatjeffsmith.com/archive/2016/10/top-sql-seeing-what-hurts-in-the-v4-2-instance-viewer/

I have updated / changed code for the purpose of this presentation.
Scripts have been updated to run everything as perflab user and not switch to the SYS user.

All code here is use at your own risk, they are intended to be run in a lab system or test system.
These are for training purposes and should not be run in a production or production like environment.

The scripts have been modified for the purpose of the lab and to make them easy to step through for instructional purposes.

## Download the Scripts
You can run the following command from Linux or MAC OSX or Cygwin to download all the items in the repository.

```bash
curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1
```

## Basic Setup Steps
Run script lab-setup.sql as a user in the database with DBA rights (E.G. SYS or SYSTEM).
This script creates a user called perflab that will be used throughout the demo.

NOTE: if you are using a PDB edit the script "setpdb.sql" and update the PDB name in the form of a connect string.  Be sure to include the @ sign.  If you are not using a PDB, leave this blank with quotes intact.
Before Edit:
```DEFINE mypdb=""```
After Edit:
```DEFINE mypdb="@mypdb"```


```bash
cd tune-that-SQL-GTOUG
sqlplus /nolog
```
```sql
SQL> connect / as sysdba
SQL> alter session set container=mypdb;
SQL> @lab-setup
```

## Setup the test tables used during the demo

```bash
sqlplus /nolog
SQL> @ctables
```

This will create two tables, T1 and T2.  The tables have skewed data distribution in the column D.  24,999 rows are unique, and 25,001 rows contain the value 10.
By default Oracle assumes a normal distribution, as we have run enhanced statistics, a histogram is created on this column.

## Generate some load

Open a second window to your test system.  In one window you will generate a bunch of SQL sessions.  In the second window you will look at top SQL statements for the PERFLAB user.

```bash
cd tune-that-SQL-NYOUG
  # be sure to put your DB SID as the first paramter to the script
./make-load.sh <db_name>
```
In a second window connect to SQL\*PLus and check the top SQL statements:
```bash
cd tune-that-SQL-NYOUG
sqlplus /nolog
```
```sql
SQL> connect perflab/perf$lab

  -- If you are using a PDB:
SQL> connect perflab/perf$lab@mypdb

  -- Once connected run:
SQL> @top_sql

```

Here we can see a number of SQL statements in the cursor cache.  You can see a good deal of information about each statement.  Be sure to look at the top_sql script and understand what other data you might want to know about a SQL statement.

## Look at a plan for a SQL statement

Copy the SQL_ID from one of the top statments, and look at the execution plan saved in the cursor cache. Note you may find a SQL statement with more than one plan has value.  You may want to look at the muliptle plans for that statement as well.

```sql
SQL> connect / as sysdba

  -- If you are using a PDB:
SQL> alter session set container=mypdb;

  -- Once connected run:
  -- Be sure to put the SQL_ID as the first option for the script
SQL> @plan_sql_id <SQL_ID>
```

## Current Baselines

Drop current baselines and show that there are no current baselines loaded:

```sql
SQL> connect perflab/perf$lab
SQL> @drop
SQL> @list
```

## Capturing a SQL Baseline

In this test we will auto capture a baseline from a session.  The session has to run the SQL twice before it will be captured.

First we will enable baseline capture and run the SQL twice in order for a baseline to be captured.
```sql
SQL> connect perflab/perf$lab

  -- If you are using a PDB:
SQL> connect perflab/perf$lab@mypdb

SQL> alter session set optimizer_capture_sql_plan_baselines = TRUE;
SQL> @q1 1000
SQL> @q1 1000
SQL> alter session set optimizer_capture_sql_plan_baselines = FALSE;
```

Be sure you disable capturing baselines before continuing.

Now lets verify that the baseline exists.

```sql
SQL> @plan
SQL> @list
```

## Real plan vs cached plan

In this example we will look at the difference between a real plan and a cached plan.
First we will need to purge the sql from the cursor cach.

```sql
SQL> @purge_cursor fua0hb5hfst77
```

Now we will run the query with two different lookup values.  Note the difference actual vs estimated rows and byts vs buffers.

```sql
SQL> connect perflab/perf$lab

  -- If you are using a PDB:
SQL> connect perflab/perf$lab@mypdb

SQL> @q1 1000
SQL> @plan
  -- Note the plan information
SQL> @q1 10
SQL> @plan
  -- Note the plan information
```

You should see a dramtic difference in estimated rows vs actual rows retrieved / scanned for the lookup value of 10.  This is due to the execution plan from the lookup value of 1000 is cached.

To get the real explain plan for the lookup value of ten we will purge the cursor again, and then run just that query and capture that plan first.

```sql
SQL> @purge_cursor fua0hb5hfst77
SQL> connect perflab/perf$lab

  -- If you are using a PDB:
SQL> connect perflab/perf$lab@mypdb

SQL> @q1 10
SQL> @plan
  -- Note the plan information
```

You should see a dramatic difference in the plan cost now that the real number of estimated rows is being used.

## Clean up
To clean up the lab run the following two items as a DBA user:

```sql
SQL> @drop
SQL> DROP USER PERFLAB CASCADE;
```

## The END
