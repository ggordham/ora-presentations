# spm-RMOUG
Scripts from the RMOUG SPM presentation presentation February 10, 2021

These scripts are mostly based on examples from the Oracle example github repository:
https://github.com/oracle/oracle-db-examples

I have updated / changed code for the purpose of this presentation.

All code here is use at your own risk, they are intended to be run in a lab system or test system.
These are for training purposes and should not be run in a production or production like environment.

The scripts have been modified for the purpose of the lab and to make them easy to step through for instructional purposes.

## Download the Scripts
You can run the following command from Linux or MAC OSX or Cygwin to download all the items in the repository.

`curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1`

## Basic Setup Steps
Run script lab-setup.sql as a user in the database with DBA rights (E.G. SYS or SYSTEM).
This script creates a user called perflab that will be used throughout the demo.

`cd spm-RMOUG`  
`sqlplus /nolog`  
`SQL> connect / as sysdba`  
`SQL> @lab-setup`  

## Setup the test tables used during the demo

`sqlplus /nolog`  
`SQL> @ctables`

This will create two tables, T1 and T2.  The tables have skewed data distribution in the column D.  24,999 rows are unique, and 25,001 rows contain the value 10.
By default Oracle assumes a normal distribution, as we have run enhanced statistics, a histogram is created on this column.

## Look at table information

`SQL> CONNECT perflab/perf$lab`
`SQL> @show-hist`

Here we can see that the two tables have 50,000 rows each and that the 2nd bucket (ENDPOINT_VALUE = 10) has more than one row, while the other four values have only one row.

## Current Baselines

Drop current baselines and show that there are no current baselines loaded:

`SQL> @drop`
`SQL> @list`

## First test - Auto capture a baseline

In this test we will auto capture a baseline from a session.  The session has to run the SQL twice before it will be captured.

`SQ> @test1`

## Second test - auto capture another baseline plan

Now we will capture another baseline plan for the same SQL.
Even though auto capture baselines is now set to false.

`SQL> @test2`

## Third test - evolve the baseline

Now we will evolve the baseline, basically test the new captured plan and let Oracle decide if it is worth accepting.  Then we will show our SQL statement as it uses the new baseline plans.

`SQL> @test3`

## Clean up
To clean up the lab run the following two items as a DBA user:

`SQL> @drop`
`SQL> DROP USER PERFLAB CASCADE;`

## The END
