# liquibase-UTOUG

Scripts from the Utah Oracle User Group (UTOUG) Training Days 2025, 3/25/2025 at 2:30 PM - 3:30 PM MST

This is a demonstration of the Liquibase tool built into Oracle SQLcl (SQL Command Line).  We will start with an existing schema and then walk through some capture and implimentation of changes.  The demonstration is based on using three PDBs to represent the different lifecycles of the application (Production PRD, Test TST, Development DEV).


# Warnings

As with any scripts I have for demos, these are use at your own risk and should not be run on any system that is used by your company for any reason.

I run these on a VM that I can throw away. So a Podman / Docker container with an Oracle database is a good place to try these out on your own.

# Table of Contents

1. [Setup](#Setup)
2. [Demo 1 - CI/CD](#demo1-ci/cd)
3. [DEMO 2 - Waterfall](#demo2-waterfall)


# Setup

### Download scripts

To download the scripts direclty from the internet to a Linux machine run the following:

```bash
curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1 "ggordham-ora-presentations-???????/liquibase-UTOUG"

```

## PDBs:

- hrprd - Production
- hrtst - Test
- hrdev - Development

Each database will have a copy of the HR schema.

We will load the schema from a gold data pump export.

The hr-gold.dmp file is located inside the setup/hr-gold-exp.zip file.  Be sure to copy it to the DATA\_PUMP\_DIR location on your system prior to running the import.  Also udpate the command with your system password.

```bash
"${ORACLE_HOME}"/bin/impdp "system/Oracle_4U@hrprd" directory="DATA_PUMP_DIR" dumpfile="hr-gold.dmp" logfile=hr-gold-imp-hrprd.log TRANSFORM=OID:N

```

*Note: you will receieve 36 errors related to grants to another schema that does not normally exist unless you have install Oracle's demonstration schemas.*

# Demo 1 - CI/CD

Steps:

1. Baseline and tag PRD
2. Baseline adn tag DEV
3. Build change from DEV
4. Apply change to TST
5. Rollback change from TST

## 1. Baseline and tag PRD

### Capture schema

Next we will use Liquibase to generate a baseline of the schema in XML format.  This will be used to set the main version in the other environments.

```sql
connect hr/Oracle_4U@"//localhost/hrprd"

cd hr

lb generate-schema -split -sql -ovf


```

### Set baseline and tag

Now that we have a Liquidbase version of the schema, we will set the test environment to be at that base level.  This will be tagged as version v1.0.


```sql
lb changelog-sync -changelog-file controller.xml

lb tag -tag v1.0

```


### Show status

Lets check the stats of the changes.


```sql
lb status -changelog-file controller.xml

```

## 2. Baseline and tag DEV

Here we will switch to development and make a change.  Again we will start by baselineing development, this is a one-time change.

```sql
connect hr/Oracle_4U@"//localhost/hrdev"

lb changelog-sync -changelog-file controller.xml

lb tag -tag v1.0

```

## 3. Build change from DEV

### Create our new table

```sql
CREATE TABLE "EMP_CONTACT"
  ("CONTACT_ID" NUMBER,
   "EMPLOYEE_ID" NUMBER,
   "CONTACT_TYPE" VARCHAR2(20 BYTE),
   "CONTACT" VARCHAR2(256 BYTE),
  CONSTRAINT "EMP_CONTACT_PK" PRIMARY KEY ("CONTACT_ID"),
  CONSTRAINT "EMP_CONTACT_FK1" FOREIGN KEY ("EMPLOYEE_ID") REFERENCES "HR"."EMPLOYEES" ("EMPLOYEE_ID")
  )
 TABLESPACE "USERS" ;

CREATE INDEX "HR"."EMP_CONTACT_INDEX1" ON "HR"."EMP_CONTACT" ("EMPLOYEE_ID");

```

### Capture the change

```sql
lb generate-schema -split -sql -ovf

exit

```

### GIT tracks changes

Show what files have changed

```bash
git diff --name-only | grep liquibase-UTOUG

git ls-files --exclude-standard --others

```

## 4. Apply change to TST

### Refresh test

Refresh the schema using automated script, utilizing datapump and a database link.

First change to the proper directory and start sqlplus.

```bash
cd liquibase-orapu/setup
sqlplus /nolog

```

Run the script, providing the password on the command line.

```sql
@refresh_tst.sql <system_password>

```

### Apply changes to TST

Start SQLcl and connect to hrtst.

```bash

sql /nolog

```

Apply the changes to TST.


```SQL
connect hr/Oracle_4U@"//localhost/hrtst"

lb update -changelog-file controller.xml


```

*Note that only 3 changes were run.*

## 5. Rollback change from TST

Now lets show that we can rollback the chnages.  We will use the tag created in production to rollback to that point in time.

```sql
lb rollback -changelog-file controller.xml -tag v1.0

```

# Demo 2 - Waterfall

In this demo we are going to treat each change as independt set of scripts.

We are going to jump right in with our existing baseline schema we created in the first demonstration.

Steps

1. Refresh test
2. v1.1 - add new table / procedure
3. v1.2 - upate the procedure add a view
4. v1.3 - add a column to existing table

### Refresh test

Refresh the schema using automated script, utilizing datapump and a database link.

First change to the proper directory and start sqlplus.

```bash
cd liquibase-orapu/setup
sqlplus /nolog

```

Run the script, providing the password on the command line.

```sql
@refresh_tst.sql <system_password>

```

### v1.1 change

Look at the files in the v1.1 folder.  These were creted with a simple capture command in liquibase, but this time we captured specific objects:

```sql
lb generate-db-object -object-type table -object-name emp_contact

lb generate-db-object -object-type sequence -object-name contact_id_seq

```

We have also created two SQL files by hand that will update the contact data based on existing records and create a update procedure.

- upd_emp_contact_proc.sql
- cr_contact_data.sql

Finally we have crafted the controller.xml to have the needed information to tell Liquibase how to apply this change.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog
  xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
                      http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-latest.xsd">
  <include file="emp_contact_table.xml"/>
  <include file="contact_id_seq_sequence.xml"/>
  <include file="cr_contact_data.sql"/>
  <include file="upd_emp_contact_proc.sql"/>
</databaseChangeLog>
```

### apply v1.1 to Test

We will now connect to our test system and apply the v1.1 update.

```bash
sql /nolog

```


```sql
cd waterfall/v1.1

connect hr/Oracle_4U@"//localhost/hrtst"

lb update -changelog-file controller.xml

lb tag -tag v1.1


```

### Verify v1.1 is applied

Lets verify that we have our new table and it has data in it.

```sql
tables2

select count(1) from emp_contact;

```

### Lets test our new procedure.

```sql


exec upd_emp_contact_proc(100,'I','employee1');

select * from emp_contact where employee_id = 100;

exec upd_emp_contact_proc(100,'P','555-3333');

select * from emp_contact where employee_id = 100;

rollback;

```

### apply v1.2 to test

We will now test an already developed v1.2 code.

```sql
connect hr/Oracle_4U@"//localhost/hrtst"

cd ../v1.2

lb update -changelog-file controller.xml
lb tag -tag v1.2

```

*Note look into the upd_emp_contact_proc.sql script and see how we have coded the rollback procedurd for the PL/SQL code.*

### Test or v1.2 code make sure it works

Lets try the new code and verify it works.

```sql
select * from employees_view
  where employee_id = 101;

exec upd_emp_contact_proc(101,'I','employee1');

select * from emp_contact where employee_id = 101;

rollback;

```

### lets rollback the change

Rollback the change as it's not needed

```sql
lb rollback -changelog-file controller.xml -tag v1.1

```

### Verify that the rollback

Lets verify the rollback is completed

```sql
exec upd_emp_contact_proc(100,'I','employee1');

desc employees_view;

```

## Genreate a table change for v1.3

Lets make a change to the employee table and then generate a change for that.

```sql
connect hr/Oracle_4U@"//localhost/hrdev"

ALTER TABLE employees ADD pref_contact CHAR(1);

cd ../workarea
lb generate-db-object -object-type table -object-name employees


```

### Apply change to test

lets apply the draft v1.3 change to test, note we have not applied v1.2.

```sql
connect hr/Oracle_4U@"//localhost/hrtst"

cd ../v1.3

lb update -changelog-file employees_table.xml


```

## Rollback v1.3

```sql
connect hr/Oracle_4U@//localhost/hrtst

lb rollback -changelog-file employees_table.xml -tag v1.1


```

## Preview a change

Lets preview the SQL for a change

```sql
lb update-sql -changelog-file employees_table.xml


```

# Refresh test and apply all changes

Now lets refresh test and apply all the changes we have done so far.

First disconnect from the database in SQLcl and also from SQLDeveloper.

```sql
DISCONNECT;
@login.sql

```

From the command line of the database server:

```sql
connect / as sysdba

@refresh_tst.sql <system_password>

```

Then from SQLcl run:

```sql
connect hr/Oracle_4U@//localhost/hrtst

cd v1.1
lb update -changelog-file controller.xml
lb tag -tag v1.1
cd ..

cd v1.2
lb update -changelog-file controller.xml
lb tag -tag v1.2
cd ..

cd v1.3
lb update -changelog-file employees_table.xml
cd ..

```

# Schema DIFF examples

```sql
lb diff -REFERENCE-USERNAME hr -REFERENCE-PASSWORD Oracle_4U -REFERENCE-URL jdbc:oracle:thin:@//localhost/hrprd

lb diff-changelog -REFERENCE-USERNAME hr -REFERENCE-PASSWORD Oracle_4U -REFERENCE-URL jdbc:oracle:thin:@//localhost/hrprd -output-file controller-struct.xml

lb diff-changelog -REFERENCE-USERNAME hr -REFERENCE-PASSWORD Oracle_4U -REFERENCE-URL jdbc:oracle:thin:@//localhost/hrdev 

```

# Other Notes

Formatting on PL/SQL in .sql files.
be sure to set the delimiter correctlly on both the SQL and any rollback sections.

Using rollback without a seperate file, expecially for PL/SQL objects.

Queries for database change log

select dateexecuted,tag from hr_tst.databasechangelog where tag is not null;

ideas on tagging

information on SQLcl

# END
