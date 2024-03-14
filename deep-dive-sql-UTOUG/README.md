# deep-dive-sql-UTOUG
Files from the UTOUG Training Days Deep Dive into SQL Tuning presentation March 21, 2024

These files are from the examples that are used during the presentation.
You may want to look at the files / read through them to get better knowledge or compare to what we discuss during the presentation.

You can read the trace files directly in your browser through GIT links below.  The lab steps will include downlaoding the files as well.

# Table of Contents
1. [File list and descriptions](#file-list-and-descriptions)
2. [Ways to run the lab](#ways-to-run-the-lab)
3. [Run the lab on Docker](#run-the-lab-on-docker)
4. [Run the lab on a Linux server](#run-the-lab-on-a-linux-server)

---

ora-presentations/deep-dive-sql-UTOUG/sqlhc_20210304_1556_fua0hb5hfst77_4_sql_detail.html
                  deep-dive-sql-UTOUG/sqlhc_20210304_1556_fua0hb5hfst77_4_sql_detail.html

https://htmlpreview.github.io/?https://github.com/ggordham/ora-presentations/blob/main/deep-dive-sql-UTOUG/sqlhc_20210304_1556_fua0hb5hfst77_4_sql_detail.html
https://htmlpreview.github.io/?https://github.com/ggordham/ora-presentations/blob/main/deep-dive-sql-UTOUG/sqlhc_20210304_1556_fua0hb5hfst77_4_sql_detail.html
https://htmlpreview.github.io/?https://github.com/ggordham/ora-presentations/blob/main/deep-dive-sql-UTOUG/sqlhc_20210304_1556_fua0hb5hfst77_1_health_check.html
sqlhc_20210304_1556_fua0hb5hfst77_4_sql_detail.html
sqlhc_20210304_1556_fua0hb5hfst77_4_sql_detail.html


## File list and descriptions
| link | File Name | Description |
| ---- |  -------- | ----------- |
| | `README.md` | This readme file |
| | `sql_monitor_output.html` | Example of SQL Monitor |
| [HTML link](https://htmlpreview.github.io/?https://github.com/ggordham/ora-presentations/blob/main/deep-dive-sql-UTOUG/sqlhc_20210304_1556_fua0hb5hfst77_1_health_check.html) | `sqlhc_20210304_1556_fua0hb5hfst77_1_health_check.html` | SQL Health Check main report |
| [HTML link](https://htmlpreview.github.io/?https://github.com/ggordham/ora-presentations/blob/main/deep-dive-sql-UTOUG/sqlhc_20210304_1556_fua0hb5hfst77_2_diagnostics.html) | `sqlhc_20210304_1556_fua0hb5hfst77_2_diagnostics.html` | SQL Health Check diagnostics details |
| [HTML link](https://htmlpreview.github.io/?https://github.com/ggordham/ora-presentations/blob/main/deep-dive-sql-UTOUG/sqlhc_20210304_1556_fua0hb5hfst77_3_execution_plans.html) | `sqlhc_20210304_1556_fua0hb5hfst77_3_execution_plans.html` | SQL Health Check execution plans |
| [HTML link](https://htmlpreview.github.io/?https://github.com/ggordham/ora-presentations/blob/main/deep-dive-sql-UTOUG/sqlhc_20210304_1556_fua0hb5hfst77_4_sql_detail.html) | `sqlhc_20210304_1556_fua0hb5hfst77_4_sql_detail.html` | SQL Health Check diagnostic and DB info |
| [HTML link](https://htmlpreview.github.io/?https://github.com/ggordham/ora-presentations/blob/main/deep-dive-sql-UTOUG/sqlt_s39943_main.html) | `sqlt_s39943_main.html` | SQLTXPlain main file |
| | `sqlt_s39943_tc_script.sql` | SQLTXPlain script to re-run same SQL |
| | `t1db_ora_32527_s39943_10053.trc` | SQLTXPlain CBO trace |
| | `t1db_ora_32309_trace.out` | Simple SQL Trace run through TKPROF |
| | `t1db_ora_32309_trace.trc` | Simple SQL Trace file |
| | `t1db_ora_32683_trace_10046_lvl12.out` | 10046 Trace level 12 run through TKPROF |
| | `t1db_ora_32683_trace_10046_lvl12.trc` | 10046 Trace level 12|
| | `t1db_ora_4813_trace_10053.out` | Manual 10053 Trace run through TKPROF |
| | `t1db_ora_4813_trace_10053.trc` | Manual 10053 Trace |
| | `t1db_ora_6494_nostats.trc` | CBO Trace of sample SQL from presentation with no object statistics |
| | `t1db_ora_30672_stats.trc` | CBO Trace of sample SQL from presentation with basic object statistics |
| | `t1db_ora_31265_histogram.trc` | CBO Trace of sample SQL from presentation with object statistics and column histograms |
| | `t1db_ora_4062_nostats-dynamic.trc` | CBO Trace of sample SQL from presentation with no statistics, but dynamic sampling |

## Ways to run the lab
The scripts can be run in multiple ways depending on your configuration and test system.

### Warnings -  Make your own trace files
As with any scripts I have for demos, these are use at your own risk and should not be run on any system that is used by your company for any reason.

I run these on a VM that I can throw away.  So a Podman / Docker container with an Oracle database is a good place to try these out on your own.

## Run the lab on Podman

### Prerequisets

You need a working docker image with Oracle database pre installed.
These scripts have been tested on Oracle 19c and 21c, but should also work on Oracle 12c and 18c.
Your database / PDB should have a USERS tablespace.

Once you have the container up and running with a working database you can install the lab scripts with the following command:

```bash
podman exec db1922 sh -c "curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1"

```

*Note db1922 in the command is the container name, use your container name.  You can find your container name with the ```podman ps``` command.*

Through out the lab you will need a SQL*Plus prompt on the databases.  This is done by running the following podman command.  (Note this command will put you in the directory with the lab scripts and set your SQL Prompt)

**SQL Prompt**

```bash
podman exec -it db1922 sh -c "chmod +x splus.sh; /home/oracle/splus.sh ddsu"

```

You should get a prompt that looks something like this:

```
$ podman exec -it DB213 sh -c "chmod +x splus.sh; /home/oracle/splus.sh isqlu"

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

### Look at SQLT report

Open the HTML file
sqlt_s39943_main.html
[HTML link](https://htmlpreview.github.io/?https://github.com/ggordham/ora-presentations/blob/main/deep-dive-sql-UTOUG/sqlt_s39943_main.html)

### Demo of TKPROF outoupt

We will trace a SQL statement and then look at the TKPROF output

```sql
@trace-exec-q1.sql

```

Make sure to look at the TKPROF report.

### First test - run a trace with no object stats

We will drop the stats from the tables, and run a query CBO trace.  You should open the test1.sql and look at what scripts it calls.  Each script can be inspected to review specific steps for running a trace, and clearing a cursor from the cursor cache.

```sql
@trace-nostat.sql

```

View the trace file using the more command.

```/[text]``` to search for text

```space bar``` to move foward a page,

```b``` to move back a page

```q``` to exit the file

In the trace file you will want to look at the "Table Stats", notice that it shows T1 has 164,259 rows, even though we know it has more.  Also notice that the AvgRowLen is 100.  This data is drived from the table size (number of blocks) and a default row length.

Now look at the SCAN IO cost for "SINGLE TABLE ACCESS PATH", note how this cost is dervied form the above infomrmation on number of rows.
Look at "Column (#4) has a NDV (Number of Distinct Values) and the estimated selectivity.

### Second test - trace again with basic object stats

We gather basic object statistics, then run a the same query with CBO trace again.  Again you should review the scripts, here we include steps for gathering basic statistics.

```sql
@trace-stats.sql

```

View the new trace file with the more command.
Look for "Table Stats" again, this time notice that the correct number of rows, average row length, and blocks.

Now look at the SCAN IO cost for "SINGLE TABLE ACCESS PATH", see how it has changed.
Look at "Column (#4) has a NDV (Number of Distinct Values) and that the estimated selectivity has changed.

### Third test - trace again with histograms added

Now we will add histograms to the columns of the tables and then run the CBO trace for a final time.  This third test includes gathering histogram statistics so be sure to look at how that is done in the script.

```sql
@trace-hist.sql

```

View the new trace file with the more command.
Look for the "SINGLE TABLE ACCESS PATH", notice that this time "Column (#4) has a NDV (Number of Distinct Values) of 253,072 and the estimated selectivity has changed.

### Look at table information

Shows that the histograms are in place

```sql
@show-hist

```

Note that for column "D" the buck for ENDPOINT_VALUE 10 has a repeat count of 2790 while the other buckets listed only have a count of one.  This lets Oracle know that the distribution of data in the table is not "normal".

### Run a plan with statistics

Show an execution plan with execution statistics

```sql
@q1.sql 10
@plans.sql

```

### Clean up
To clean up the lab run if you want to re-run it.  Open a SQL window and run the following commands:

```sql
CONNECT / AS SYSDBA
DROP USER PERFLAB CASCADE;

```

---

## Run the lab on a Linux server

### Download the Scripts

You can run the following command from Linux or MAC OSX or Cygwin to download all the items in the repository.

```bash
curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1

```

### Basic Setup Steps

Run script lab-setup.sql as a user in the database with DBA rights (E.G. SYS or SYSTEM).
This script creates a user called perflab that will be used throughout the demo.
*Note replace mypdb with the name of the pdb you are using*

```bash
# Set your Oracle Environment
. oraenv
cd deep-dive-sql-UTOUG
# if you are using a PDB set the following variable to the name of your PDB
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

### Look at SQLT report

Open the HTML file
sqlt_s39943_main.html
[HTML link](https://htmlpreview.github.io/?https://github.com/ggordham/ora-presentations/blob/main/deep-dive-sql-UTOUG/sqlt_s39943_main.html)

### Demo of TKPROF outoupt

We will trace a SQL statement and then look at the TKPROF output

```sql
@trace-exec-q1.sql

```

Make sure to look at the TKPROF report.

### First test - run a trace with no object stats

We will drop the stats from the tables, and run a query CBO trace.  You should open the test1.sql and look at what scripts it calls.  Each script can be inspected to review specific steps for running a trace, and clearing a cursor from the cursor cache.

```sql
-- if you are NOT using a PDB
DEFINE con_pdb=""

-- if you are using a PDB define the PDB name be sure to include the @ sign
DEFINE con_pdb="@mypdb"

@trace-nostat.sql

```

In the trace file you will want to look at the "Table Stats", notice that it shows T1 has 164,259 rows, even though we know it has more.  Also notice that the AvgRowLen is 100.  This data is drived from the table size (number of blocks) and a default row length.

Now look at the SCAN IO cost for "SINGLE TABLE ACCESS PATH", note how this cost is dervied form the above infomrmation on number of rows.
Look at "Column (#4) has a NDV (Number of Distinct Values) and the estimated selectivity.

### Second test - trace again with basic object stats

We gather basic object statistics, then run a the same query with CBO trace again.  Again you should review the scripts, here we include steps for gathering basic statistics.

```sql
-- if you are NOT using a PDB
DEFINE con_pdb=""

-- if you are using a PDB define the PDB name be sure to include the @ sign
DEFINE con_pdb="@mypdb"

@trace-stats.sql

```

View the new trace file with the more command.
Look for "Table Stats" again, this time notice that the correct number of rows, average row length, and blocks.

Now look at the SCAN IO cost for "SINGLE TABLE ACCESS PATH", see how it has changed.
Look at "Column (#4) has a NDV (Number of Distinct Values) and that the estimated selectivity has changed.

### Third test - trace again with histograms added

Now we will add histograms to the columns of the tables and then run the CBO trace for a final time.  This third test includes gathering histogram statistics so be sure to look at how that is done in the script.

```sql
-- if you are NOT using a PDB
DEFINE con_pdb=""

-- if you are using a PDB define the PDB name be sure to include the @ sign
DEFINE con_pdb="@mypdb"

@trace-hist.sql

```

View the new trace file with the more command.
Look for the "SINGLE TABLE ACCESS PATH", notice that this time "Column (#4) has a NDV (Number of Distinct Values) of 253,072 and the estimated selectivity has changed.

### Look at table information

Shows that the histograms are in place

```sql
CONNECT perflab/perf$lab

-- If you are using a PDB:
CONNECT perflab/perf$lab@mypdb

-- Once connected run:
@show-hist

```

Note that for column "D" the buck for ENDPOINT_VALUE 10 has a repeat count of 2790 while the other buckets listed only have a count of one.  This lets Oracle know that the distribution of data in the table is not "normal".

### Run a plan with statistics

Show an execution plan with execution statistics

```sql
@q1.sql 10
@plans.sql

```

### Clean up

To clean up the lab run the following two items as a DBA user:

```sql
DROP USER PERFLAB CASCADE;

```

## The END
