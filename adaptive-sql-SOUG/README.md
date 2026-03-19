# Oracle Adaptive SQL Optimization - Why do things go so bad?

Scripts for Oracle Adaptive SQL Optimization - Why do things go so bad? SOUG presentation

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

## Run the lab on podman

### Prerequisets
You need a working podman image with Oracle database FREE pre installed. These scripts only work on 23ai FREE version. Your database / PDB should have a USERS tablespace.

Once you have the container up and running with a working database you can install the lab scripts with the following command:

```bash
podman exec emea sh -c "curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1"
```

Note emea in the command is the container name, use your container name. You can find your container name with the podman ps command.

Through out the lab you will need a SQL*Plus prompt on the databases. This is done by running the following podman command. (Note this command will put you in the directory with the lab scripts and set your SQL Prompt)

### SQL Prompt

```bash
podman exec -it emea sh -c "chmod +x splus.sh; /home/oracle/splus.sh adss"
```

## Run the lab on a Linux OS

### Download the Scripts
You can run the following command from Linux or MAC OSX or Cygwin to download all the items in the repository.

```bash
curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1 "ggordham-ora-presentations-???????/adaptive-sql-SOUG"

```

### Basic Setup Steps
Run script lab-setup.sql as a user in the database with DBA rights (E.G. SYS or SYSTEM).
This script creates a user called perflab that will be used throughout the demo.


```bash
# Set your Oracle Environment
. oraenv
cd adaptive-sql-SOUG
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

cd  adaptive-sql-SOUG
mkdir samp
cd samp
unzip -q ../db-sample-schemas-legacy-20220307.zip

$ORACLE_HOME/perl/bin/perl -p -i.bak -e 's#__SUB__CWD__#'$(pwd)'#g' *.sql */*.sql */*.dat

sqlplus /nolog <<'EOF'
@mksample.sql Oradb$_Lab42 Oradb$_Lab42 Oradb$_Lab42 Oradb$_Lab42 Oradb$_Lab42 Oradb$_Lab42 Oradb$_Lab42 Oradb$_Lab42 users temp /home/oracle/adaptive-sql-SOUG/samp/ pdb1

@customer_orders/co_main.sql Oradb$_Lab42 freepdb1 users temp
EOF

```


# END
