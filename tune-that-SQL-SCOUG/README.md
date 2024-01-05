# tune-that-sql-UTOUG
Scripts from the Suncoast Oracle User Group (SOUG) Florida tech tour 2024

These scripts are mostly based on examples from the Oracle example github repository:
https://github.com/oracle/oracle-db-examples

I have updated / changed code for the purpose of this presentation.
Scripts have been updated to run everything as perflab user and not switch to the SYS user.

All code here is use at your own risk, they are intended to be run in a lab system or test system.
These are for training purposes and should not be run in a production or production like environment.

The scripts have been modified for the purpose of the lab and to make them easy to step through for instructional purposes.

## Run the lab on Podman (Docker)

### Prerequisets
You need a working docker image with Oracle database pre installed.
These scripts have been tested on Oracle 19c and 21c, but should also work on Oracle 12c and 18c.
Your database / PDB should have a USERS tablespace.

Once you have the container up and running with a working database you can install the lab scripts with the following command:

```bash
podman exec ora199 sh -c "curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1"
```

*Note ora199 in the command is the container name, use your container name.  You can find your container name with the ```docker ps``` command.*

Through out the lab you will need a SQL*Plus prompt on the databases.  This is done by running the following docker command.  (Note this command will put you in the directory with the lab scripts and set your SQL Prompt)

**SQL Prompt**
```bash
podman exec -it ora199 sh -c "chmod +x splus.sh; /home/oracle/splus.sh tsql3s"
```

You should get a prompt that looks something like this:
```
$ podman exec -it ora199 sh -c "chmod +x splus.sh; /home/oracle/splus.sh tsql3s"

SQL*Plus: Release 21.0.0.0.0 - Production on Thu Jan 6 19:24:17 2022
Version 21.3.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.

SP2-0640: Not connected
@ 06-JAN-22>
```

### Setup test tables and user for lab

Open a SQL*Plus prompt and run the following script

```sql
@lab-setup
@ctables

```

### Basic plan

Run a simple SQL and look at the plan
Note the execution time of this SQL that returns one row

```sql
@connect.sql

@q1.sql 1000

@plan.sql

```

### Table statistics

Lets look at some table and column statistics

```sql
@tab_stats.sql

```

### Plan with execution statistics

Lets get a plan with execution statistics and look at a SQL Monitor report

```sql
@q1.sql 1000
@plans

@sql-monitor.sql

```

### Optimizer cardinality miss

Lets run the same query with a different bind variable value and see that the Optimizer misses the cardinality estimate.
Also note the run time of the SQL statement.

```sql
@q1.sql 10
@plans.sql

```

### Lets tune the statement by hinting it

We will adjust the statement with a hint and re-run it to see if it gets faster.
Note the new SQL ID

```sql
@q1_hint.sql 10
@plans.sql

```

### Create histogram on the columns

Now lets help the Optimizer understand the cardinality by creating a histogram (statistics) on the columns.

```sql
@gatherh.sql
@show-hist.sql

```

### Re-run the query and see how it helps

NOTE THIS NEEDS TO BE FIXED / WALKED THROUGH

```sql
@q1.sql 1000
@plans.sql
@q1.sql 10

@q1.sql 1000
@plans.sql
@q1.sql 10
```

### Purge the query from cursor cache

```sql
@purge_cursor.sql fua0hb5hfst77
@connect
@q1.sql 10
@plans.sql
-- note the plan cost
```

## Clean up the lab

To clean up and drop everything run the following.
*Note: this will remove the perflab user and all it's objects*


```sql
DROP USER PERFLAB CASCADE;

```

# END

