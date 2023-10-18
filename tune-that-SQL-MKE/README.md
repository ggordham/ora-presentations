# tune-that-sql-MKE

Scripts from Milwaukee Tech Day October 18, 2023

These scripts are mostly based on examples from the Oracle example github repository:
https://github.com/oracle/oracle-db-examples

I have updated / changed code for the purpose of this presentation.
Scripts have been updated to run everything as perflab user and not switch to the SYS user.

All code here is use at your own risk, they are intended to be run in a lab system or test system.
These are for training purposes and should not be run in a production or production like environment.

The scripts have been modified for the purpose of the lab and to make them easy to step through for instructional purposes.

## Run the lab on Docker

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
podman exec -it ora199 sh -c "chmod +x splus.sh; /home/oracle/splus.sh tsql2mk"
```

You should get a prompt that looks something like this:
```
$ podman exec -it ora199 sh -c "chmod +x splus.sh; /home/oracle/splus.sh tsql2mk"

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
```

This step will create a user called PERFLAB that will be used througout the lab.

Now create the tables for the lab, along with inital baseline:

```sql
@ctables
@spm_stgtab.sql
@q1-baseline.sql
```

### create some background statements

This will put some statements in the cursor cache with some load

```sql
@q1.sql 1
@q1.sql 1

@q1.sql 10
@q1-many.sql 10
```

### Identify bad SQL

Lets look at some executions of a specific sql statements

```sql
@sql-executions.sql fua0hb5hfst77
```

Lets the get the plan and bind variable values for that statement

```sql
@plan-sqlid.sql fua0hb5hfst77
@sql-bind.sql fua0hb5hfst77
```

Lets find out how many rows were returned

```sql
@q1.sql 1
@q1.sql 10
```

### SQL Plan with execution statistics

```sql
@connect.sql
@q1 10
@plans.sql
```

### Look at baseline and addtional plan

Look at the additional execution plan that the optimizer has come up with and captured in the baseline.

```sql
@list-baseline.sql
@plan-baseline.sql fua0hb5hfst77
```

### Look at the table statistics including the histogram

Lets look at the table statistics and the histogram column statistics.

```sql
@show-hist.sql
```

### Evovle the baseline to accept the new plan

The Baseline evolve task will check and then accept the new plan if it is better.

```sql
@spm-evolve.sql fua0hb5hfst77
@list-baseline.sql
```

Lets see the results of the new plan

```sql
@q1.sql 1
@q1.sql 10
@q1-many.sql 10
@sql-executions.sql fua0hb5hfst77
```

## Clean up the lab

To clean up and drop everything run the following.
*Note: this will remove the perflab user and all it's objects*


```sql
@clean-up.sql
```

# END
