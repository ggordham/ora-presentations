# 23ai-sql-perf-scoug

Scripts for Oracle 23ai New SQL Performance Features presentation.

These scripts are mostly based on examples from the Oracle example github repository:
https://github.com/oracle/oracle-db-examples
As well as optimizer-examples by Nigel Bayliss
https://github.com/nigelbayliss/optimizer-examples

I have updated / changed code for the purpose of this presentation.
Scripts have been updated to run everything as perflab user and not switch to the SYS user.

All code here is use at your own risk, they are intended to be run in a lab system or test system.
These are for training purposes and should not be run in a production or production like environment.

The scripts have been modified for the purpose of the lab and to make them easy to step through for instructional purposes.

# How to run

These scripts require the usage of Oracle database 23ai.  As of the time of this writing, this version is only availabe in Oracle cloud, and in the FREE edition that can be run on a container, Linux, or Windows.

The Realtime SPM example can only be run on the Enterprise Edition which is only in OCI cloud.


## Run the lab on Container

These test will be run with 23ai FREE edition https://www.oracle.com/database/free/

### Prerequisets
You need a working podman image with Oracle database FREE pre installed.
These scripts only work on 23ai FREE version.
Your database / PDB should have a USERS tablespace.

Once you have the container up and running with a working database you can install the lab scripts with the following command:

```bash
podman exec sql23nr sh -c "curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1"
```

*Note sql23nr in the command is the container name, use your container name.  You can find your container name with the ```podman ps``` command.*

Through out the lab you will need a SQL*Plus prompt on the databases.  This is done by running the following podman command.  (Note this command will put you in the directory with the lab scripts and set your SQL Prompt)

**SQL Prompt**
```bash
podman exec -it sql23nr sh -c "chmod +x splus.sh; /home/oracle/splus.sh sql23nr"

```
### Lab setup

The following steps will create a perflab user and create required tables for the lab.

*Note: for all steps to work the Oracle example schemas need to be installed as well.  That is not covered here.*

```sql

connect / as sysdba

@lab-setup.sql

@ctables.sql

```

### PL/SQL to SQL Transpiler

Run the script and look at the example output / differences between the two predicate filters when the option is turned on.

```sql

@@sql-transpiler.sql

```

### SQL Analysis Report

There are two examples, one that generates a html file and one the displays the report in text format.

Text format report

```sql

@@sql-analysis-txt.sql

```

The following will generate an HTML report, you will need to download to your workstation to view.

```sql

@@sql-analysis-mon.sql

```

To download the report run the following podman command:

```sh

podman cp sql23nr:/home/orcle/23ai-sql-perf-scoug/monitor_output.html .

open ./monitor_output.html
start ./monitor_output.html

```

Note: a sample copy of the monitor report is saved to this GITHub repository.


### SQL Report HTML


```sql

@@q.sql

@@sql_report.sql fk70ks7ztdspf

```

### Subsumption of views


```sql

@@subsumption-view.sql

```

## Run on Oracle Cloud

You will need a Base Database System with Oracle database 23ai.


### Download the scripts

Run the following from the command prompt

```sh
curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1 "ggordham-ora-presentations-???????/23ai-sql-perf-scoug"

```

Be sure to edit the connect.sql script to change the PDB name to your PDB.

### Lab setup
The following steps will create a perflab user and create required tables for the lab.

*Note: for all steps to work the Oracle example schemas need to be installed as well.  That is not covered here.*

First you will need to set your environment for Oracle as well as the following variable for the PDB you have created:

```sh
export ORACLE_PDB_SID=<your_pdb>

sqlplus /nolog

```

Next, run the required SQL scripts.

```sql

connect / as sysdba

@lab-setup.sql

@ctables.sal

```

### Other Demos

You can run the other demonstartions by running the scripts as outlined for the container / PODMAN steps after the lab setup.

- [PL/SQL to SQL Transpiler](#PL/SQL-to-SQL-Transpiler)
- [SQL Analysis Report](#SQL-Analysis-Report)
- [SQL Analysis Report HTML](#SQL-Analysis-Report-HTML)
- [Subsumption of views](#Subsumption-of-views)


### Real-Time SPM 1

The following steps will show real-time SPM in action.  Be sure you are using 23ai Enterprise Edition.
First lets clear out any previous tests, and enable real-time SPM.

```sql
connect / as sysdba

@@rt-spm-reset.sql

@@rt-spm-enable.sql

```

Lets create a poor running SQL by making index usage expensive.  We run the same query twice to make sure it's in the cache.

```sql
@@connect.sql

@@cost_bad.sql

@@q

@@q

```

Now lets make sure the automatic SQL tuning set has captured the SQL we just ran.

```sql
@@asts_wait.sql

@@asts_list.sql

```

Now lets set the index usage costs back to normal and run the query adn see that real-time SPM kicks in and creates a baseline so that future regression does not happen.

```sql
@@cost_default.sql

@@q

```

You can now flush the shared pool to verify that the query will not regress again.

```sql
connect / as sysdba

alter system flush shared_pool;

```

Now re-run the query and view the SPM captured information

```sql
@@connect.sql

@@q.sql

@@spm_notes.sql

```

### Real-Time SPM 2

The following steps will show real-time SPM in action, this time moving from a good plan to a bad plan.  Be sure you are using 23ai Enterprise Edition.
First lets clear out any previous tests, and enable real-time SPM.

```sql
connect / as sysdba

@@rt-spm-reset.sql

@@rt-spm-enable.sql

```

Lets create a good running SQL by making index usage cheep.  We run the same query twice to make sure it's in the cache.

```sql
@@connect.sql

@@cost_good.sql

@@q

@@q

```

Now lets make sure the automatic SQL tuning set has captured the SQL we just ran.

```sql
@@asts_wait.sql

@@asts_list.sql

```

Now lets set the index usage costs be expensive and run the query adn see that real-time SPM kicks in and creates a baseline for the good plan so that future regressions don't happen

```sql
@@cost_bad.sql

@@q

@@q

```

You can now flush the shared pool to verify that the query will not regress again.

```sql
connect / as sysdba

alter system flush shared_pool;

```

Now re-run the query and view the SPM captured information

```sql
@@connect.sql

@@q.sql

@@spm_notes.sql

```
# END
