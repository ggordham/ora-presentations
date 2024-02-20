# SQL Tuning How does cardinality work?

ORAPUB session 2/22/2024

Writing and optimizing SQL statements in Oracle requires a good understanding of data cardinality.  This is calculation the Optimizer uses to determine the best method to retrieve data.  In this session we will dig deep into how cardinality is calculated, how it affects the performance of SQL statements, and what you can do to influence it.  This includes discussing object statistics, extended statistics, and histograms.  We will use the example of Nested Loop (NL) joins compared to Hash Joins (HJ) to see the difference in performance.

Outline
1. What is SQL good for
2. How the Optimizer works
3. Access paths
4. Nested Loop vs Hash Join
5. Object statistics
6. Cardinality computations
7. Optimizer vs reality
8. Influencing the Optimizer with Hints
9. Histograms
10. Wrapping up


## Live Demo items

This demonstartion uses the Oracle database sample schema, specifically the SH (Sales History) schema.  This can be installed by following the directions at:
https://github.com/oracle-samples/db-sample-schemas

Once installed the rest of the demonstration can be run through the scripts in this repository.

*Note: you should not run this demonstration in a datbase that is used by any other team, development or production.  These demonstration scripts may do things to the database that are detremental to other code.  The scripts are good examples to base real world code on, but use of any code here is at your own risk.*

## Demonstration Steps

Detailed steps for the demonstration.

### Setup system

You will need:
- Oracle database to run the scripts in (12c and above should work)
- Oracle Sample schemas (noted above)
- Download the scripts from this github repository
- Adjust the connect.sql script for your environment

### Download the scripts from github

These commands work for Linux and will download the scripts from github.  You can also do this manually using a browser or GIT commands.

```bash
curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1 "ggordham-ora-presentations-???????/cardinality-sql-tune-ORAPUB"
cd cardinality-sql-tune-ORAPUB

```

### Build test user

Connect to the database as a DBA user.  In this example I'm running the script locally on the servber and connecting to the PDB called pdb1 in the container database t1db.

```bash
export ORACLE_SID=t1db; export ORAENV_ASK=NO; source /usr/local/bin/oraenv -s
export ORACLE_PDB_SID=pdb1
$ORACLE_HOME/bin/sqlplus /nolog

```

```SQL
CONNECT / AS SYSDBA
@user_setup.sql

```


### Prep the table for demonstration

We are making sure the extra column we are using is removed and setting the SH.CUSTOMERS table to have basic statistics.

```SQL
@@connect.sql
@@drop_social.sql

```

### Customer lookup

We do a basic lookup of customers for the state of California and look at the execution plan.

```SQL
@@connect.sql

@@q1.sql
@@plan.sql

```

*Note: the execution plan estimates 555 customers.*

### Review the table stats

Review the curernt table and column statistics for SH.CUSTOMERS and SH.SALES.

```SQL
@@connect.sql
@@table_stats.sql

```

### Add new SOCIAL_ID column

Add the new SOCIAL_ID column to the SH.CUSTOMERS table to hide opt out customers.  Then do a new query to count customers that are opted out and see the plan.

```SQL
@@connect.sql
@@add_social.sql

```

Now run our new query and see how it works out.

```SQL
@@q2.sql
@@plan.sql

```

*Note: the number of customers Oracle estimates.*

### Missing statistics on the new column

We are missing statisitcs on the new column, lets add those and then review how the execution plan changes.

```SQL
@@connect.sql
@@table_stats.sql
@@stats.sql
@@table_stats.sql

```

```SQL
@@connect.sql
@@q2.sql
@@plan.sql

```

*Note: Oracle now thinks we only have one customer for some reason.*

### SQL with runtime information

Lets compare the runtime real data of running the execution plan as compared to the estimates from the Optimizer.

```SQL
@@connect.sql
@@q2.sql
@@plans.sql

```

### Compare NL and HJ with hints

Using hints lets compare the hash join and nested loop execution plans for the same query.

```SQL
@@connect.sql
@@q2hj.sql
@@plans.sql

```

```SQL
@@connect.sql
@@q2nl.sql
@@plans.sql

```

### Histograms

Lets provide Oracle with the proper statistics using histograms.

```SQL
@@connect.sql
@@statsh.sql
@@show_hist.sql

```

## Show adaptive plan

Now that the Optimizer has histogram statistics it can make better decisions about how to retrive rows and join tables automatically.

```SQL
@@q3.sql 2
@@plans.sql

@@q3.sql XXXXXX
@@q3.sql XXXXXX
@@plans.sql

```

## Cleanup Lab

To cleanup this lab you will need to remove the added SOCIAL_ID column and drop the PERFLAB user from the database.

```SQL
@@connect.sql
@@drop_social.sql

```

```SQL
CONNECT / AS SYSDBA
DROP USER perflab CASCADE;

```

# END
