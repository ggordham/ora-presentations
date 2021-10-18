# indepth-sql-MOUG
Files from the MOUG Deep Dive into SQL Tuning pesentation October 26, 2021

These files are from the examples that are used during the presentation.
You may want to look at the files / read through them to get better knowledge or compare to what we discuss during the presentation.

## Download the Scripts
You can run the following command from Linux or MAC OSX or Cygwin to download all the items in the repository.

```bash
curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1
```

You can also read them directly in your browser through GIT

## File list / descriptions
| link | File Name | Description |
| ---- |  -------- | ----------- |
| | `README.md` | This readme file |
| | `sql_monitor_output.html` | Example of SQL Monitor |
| [HTML link](https://htmlpreview.github.io/?https://github.com/ggordham/ora-presentations/blob/main/indepth-sql-MOUG/sqlhc_20210304_1556_fua0hb5hfst77_1_health_check.html) | `sqlhc_20210304_1556_fua0hb5hfst77_1_health_check.html` | SQL Health Check main report |
| [HTML link](https://htmlpreview.github.io/?https://github.com/ggordham/ora-presentations/blob/main/indepth-sql-MOUG/sqlhc_20210304_1556_fua0hb5hfst77_2_diagnostics.html) | `sqlhc_20210304_1556_fua0hb5hfst77_2_diagnostics.html` | SQL Health Check diagnostics details |
| [HTML link](https://htmlpreview.github.io/?https://github.com/ggordham/ora-presentations/blob/main/indepth-sql-MOUG/sqlhc_20210304_1556_fua0hb5hfst77_3_execution_plans.html) | `sqlhc_20210304_1556_fua0hb5hfst77_3_execution_plans.html` | SQL Health Check execution plans |
| [HTML link](https://htmlpreview.github.io/?https://github.com/ggordham/ora-presentations/blob/main/indepth-sql-MOUG/sqlhc_20210304_1556_fua0hb5hfst77_4_sql_detail.html ) | `sqlhc_20210304_1556_fua0hb5hfst77_4_sql_detail.html` | SQL Health Check diagnostic and DB info |
| [HTML link](https://htmlpreview.github.io/?https://github.com/ggordham/ora-presentations/blob/main/indepth-sql-MOUG/sqlt_s39943_main.html ) | `sqlt_s39943_main.html` | SQLTXPlain main file |
| | `sqlt_s39943_tc_script.sql` | SQLTXPlain script to re-run same SQL |
| | `t1db_ora_32527_s39943_10053.trc` | SQLTXPlain CBO trace |
| | `t1db_ora_32309_trace.out` | Simple SQL Trace run through TKPROF |
| | `t1db_ora_32309_trace.trc` | Simple SQL Trace file |
| | `t1db_ora_32683_trace_10046_lvl12.out` | 10046 Trace level 12 run through TKPROF |
| | `t1db_ora_32683_trace_10046_lvl12.trc` | 10046 Trace level 12|
| | `t1db_ora_4813_trace_10053.out` | Manual 10053 Trace run through TKPROF |
| | `t1db_ora_4813_trace_10053.trc` | Manual 10053 Trace |
| | `t1db_ora_6494_nostats.trc` | CBO Trace of sample SQL from presentation with no object statictis |
| | `t1db_ora_30672_stats.trc` | CBO Trace of sample SQL from presentation with basic object statictis |
| | `t1db_ora_31265_histogram.trc` | CBO Trace of sample SQL from presentation with object statictis and column histograms |
| | `t1db_ora_4062_nostats-dynamic.trc` | CBO Trace of sample SQL from presentation with no statictis, but dynamic sampling |

## Make your onw trace files
As with any scirpts I have for demos, these are use at your own risk and should not be run on any system that is used by your company for any reason.

I run these on a VM that I can throw away.  So a docker container with an Oracle database is a good place to try these out on your own.

## Basic Setup Steps
Run script lab-setup.sql as a user in the database with DBA rights (E.G. SYS or SYSTEM).
This script creates a user called perflab that will be used throughout the demo.

```bash
cd indepth-sql-MOUG
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

## First test - run a trace with no object stats

We will drop the stats from the tables, and run a query CBO trace.  You should open the test1.sql and look at what scripts it calls.  Each script can be inspected to review specific steps for running a trace, and clearing a cursor from the cursor cache.

```sql
SQL> @test1
```

## Second test - trace again with basic object stats

We gather basic object statistics, then run a the same query with CBO trace again.  Again you should review the scripts, here we include steps for gathering basic statistics.

```sql
SQL> @test2
```

## Third test - trace again with histograms added

Now we will add histograms to the columns of the tables and then run the CBO trace for a final time.  This third test includes gathering histagram statistics so be sure to look at how that is done in the script.

```sql
SQL> @test3
```

## Look at table information

Shows that the histograms are in place

```sql
SQL> CONNECT perflab/perf$lab
SQL> @show-hist
```

## Clean up
To clean up the lab run the following two items as a DBA user:

```sql
SQL> DROP USER PERFLAB CASCADE;
```

## The END
