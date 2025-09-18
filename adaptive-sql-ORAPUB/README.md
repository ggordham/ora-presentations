# Oracle Adaptive SQL Optimization - Why do things go so bad?

Scripts for Oracle Adaptive SQL Optimization - Why do things go so bad? ORAPUB presentation

September 18, 2025

These scripts are mostly based on examples from the Oracle example github repository:
https://github.com/oracle/oracle-db-examples

I have updated / changed code for the purpose of this presentation.
Scripts have been updated to run everything as perflab user and not switch to the SYS user.

All code here is use at your own risk, they are intended to be run in a lab system or test system.
These are for training purposes and should not be run in a production or production like environment.

The scripts have been modified for the purpose of the lab and to make them easy to step through for instructional purposes.

# How to run

These scripts have been tested on 19c Oracle database.

## Run the lab on a Linux OS

### Download the Scripts
You can run the following command from Linux or MAC OSX or Cygwin to download all the items in the repository.

```bash
curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1 "ggordham-ora-presentations-???????/adaptive-sql-ORAPUB"

```

### Basic Setup Steps
Run script lab-setup.sql as a user in the database with DBA rights (E.G. SYS or SYSTEM).
This script creates a user called perflab that will be used throughout the demo.


```bash
# Set your Oracle Environment
. oraenv
cd adaptive-sql-ORAPUB
# if you are using a PDB set the PDB name
export ORACLE_PDB_SID=pdb1
sqlplus /nolog
```

In SQL*Plus run:

```sql
connect / as sysdba
@lab-setup

```

### Show histograms

```sql
@connect.sql
@show_hist.sql 

```

### Adaptive Cursor Sharing

```sql
@@connect.sql
@@customers_bind_aware.sql 

```

```sql
@@shared_cursor.sql 6tdjh6rt27mt2

```

### Adaptive Plan

```sql
@@products_q1.sql 15

@@plansa.sql

@@sql_adaptive.sql fv7grjb0zbz1j

```

### Statistics Feedback

```sql

@@orders_q2.sql

@@flush_spd.sql

@@show_spd.sql OE PRODUCT_INFORMATION

```

### SQL Plan Directive 

```sql

@@spd_ex1.sql

```


## Legacy sample schemas install

Run through the following steps inside the container to install the legacy sample schemas.

*Note: the first two paramters for the mksample.sql script are the passwords for the SYSTEM and SYS user of your PDB / NON-CDB.  Be sure to update the command line accordingly.  The last paramter on the command line is the dataqbase connection string.*

```bash

cd  adaptive-sql-ORAPUB
mkdir samp
cd samp
unzip -q ../db-sample-schemas-legacy-20220307.zip

$ORACLE_HOME/perl/bin/perl -p -i.bak -e 's#__SUB__CWD__#'$(pwd)'#g' *.sql */*.sql */*.dat

sqlplus /nolog <<'EOF'
@mksample.sql Oradb$_Lab42 Oradb$_Lab42 Oradb$_Lab42 Oradb$_Lab42 Oradb$_Lab42 Oradb$_Lab42 Oradb$_Lab42 Oradb$_Lab42 users temp /home/oracle/adaptive-sql-ORAPUB/samp/ pdb1

@customer_orders/co_main.sql Oradb$_Lab42 freepdb1 users temp
EOF

```


# END