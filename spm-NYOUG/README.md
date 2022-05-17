# spm-NYOUG
Scripts from the NYOUG SPM presentation presentation May 19, 2022

These scripts are mostly based on examples from the Oracle example github repository:
https://github.com/oracle/oracle-db-examples

I have updated / changed code for the purpose of this presentation.
Scripts have been updated to run everything as perflab user and not switch to the SYS user.

All code here is use at your own risk, they are intended to be run in a lab system or test system.
These are for training purposes and should not be run in a production or production like environment.

The scripts have been modified for the purpose of the lab and to make them easy to step through for instructional purposes.

## Download the Scripts
You can run the following command from Linux or MAC OSX or Cygwin to download all the items in the repository.

```bash
curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1 "ggordham-ora-presentations-???????/spm-NYOUG"
```

## Basic Setup Steps
Run script lab-setup.sql as a user in the database with DBA rights (E.G. SYS or SYSTEM).
This script creates a user called perflab that will be used throughout the demo.

```bash
cd spm-NYOUG
sqlplus /nolog
```
```sql
SQL> connect / as sysdba
SQL> @lab-setup
```

## Setup the test tables used during the demo

```bash
sqlplus /nolog
SQL> @ctables
```

This will create two tables, T1 and T2.  The tables have skewed data distribution in the column D.  24,999 rows are unique, and 25,001 rows contain the value 10.
By default Oracle assumes a normal distribution, as we have run enhanced statistics, a histogram is created on this column.

## Look at table information

```sql
SQL> CONNECT perflab/perf$lab
SQL> @show-hist
```

In the first query results we can see that the two tables (T1, T2) have 500,000 rows each.  In the second set of results, we see that for column D the 2nd bucket (ENDPOINT_VALUE = 10) has more than one row, while the other four values have only one row.

## Current Baselines

Drop current baselines and show that there are no current baselines loaded:

```sql
SQL> @drop
SQL> @list
```

## First test - Auto capture a baseline

In this test we will auto capture a baseline from a session.  The session has to run the SQL twice before it will be captured.

```sql
SQL> @test1
```

## Second test - auto capture another baseline plan

Now we will capture another baseline plan for the same SQL, even though auto capture baselines is now set to false.

```sql
SQL> @test2
```

## Third test - evolve the baseline

Now we will evolve the baseline, basically test the new captured plan and let Oracle decide if it is worth accepting.  Then we will show our SQL statement as it uses the new baseline plans.

```sql
SQL> @test3
```

## Look at the Baselines

You can view more information about baselines and how they are used by joining the DBA_SQL_PLAN_BASELINES and GV$SQL views.  Note the example script to see how to properly join the two views.

```sql
SQL> @show_baseline.sql
```

## Clean up
To clean up the lab run the following two items:

```sql
SQL> @drop

SQL> -- CONNECT as DBA user

SQL> DROP USER PERFLAB CASCADE;
```

## The END
