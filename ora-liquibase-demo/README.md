# Liquibase Oracle demo

This is a demonstration of the Liquibase tool built into Oracle SQLci tool.  We will start with an existing schema and then walk through some capture and implimentation of change.  The demonstration is based on using three schemas to represent the different lifecycles of the application (Production PRD, Test TST, Development DEV).


# Warnings

As with any scripts I have for demos, these are use at your own risk and should not be run on any system that is used by your company for any reason.

I run these on a VM that I can throw away. So a Podman / Docker container with an Oracle database is a good place to try these out on your own.

# Schemas:
    #
- hr_prd - Production
- hr_tst - Test
- hr_dev - Development

We will start by loading all three schemas with the same set of objects and data by using Oracle data pump.

Next we will use Liquibase to generate a baseline of the schema in XML format.  This will be used to set the main version in the other environments.
We are using the test environment, but this could be done from any environment as we started with a synced set.


# Setup

Script will create the three schemas and load the base HR demo schema to all of them.

```bash
cd setup

./setup.sh

```

# Capture schema

```sql
connect hr_prd/hr_prd_pa55wd@//srvr08/pdb1

cd workarea

lb generate-schema -split -sql

cd ..

```

## Set baseline

Now that we have a Liquidbase version of the schema, we will set the test environment to be at that base level.  This will be tagged as version v1.0.


```sql
@baseline_all.sql

```


## Show status

Lets check the stats of the changes.


```sql
connect hr_prd/hr_prd_pa55wd@//srvr08/pdb1

cd base
lb status -changelog-file controller.xml
cd ..

```

# Make a change in development

Here we will switch to development and make a change.  Again we will start by baselineing development, this is a one-time change.


## Create our new table

```sql
connect hr_dev/hr_dev_pa55wd@//srvr08/pdb1

CREATE TABLE "EMP_CONTACT"
  ("CONTACT_ID" NUMBER,
   "EMPLOYEE_ID" NUMBER,
   "CONTACT_TYPE" VARCHAR2(20 BYTE),
   "CONTACT" VARCHAR2(256 BYTE),
  CONSTRAINT "EMP_CONTACT_PK" PRIMARY KEY ("CONTACT_ID"),
  CONSTRAINT "EMP_CONTACT_FK1" FOREIGN KEY ("EMPLOYEE_ID") REFERENCES "HR_DEV"."EMPLOYEES" ("EMPLOYEE_ID")
  )
 TABLESPACE "USERS" ;

CREATE INDEX "HR_DEV"."EMP_CONTACT_INDEX1" ON "HR_DEV"."EMP_CONTACT" ("EMPLOYEE_ID");

```

## capture our new table in Liquibase

We will generate a XML file for the table and a controller file for the change overall.

```sql
cd workarea

lb generate-db-object -object-type table -object-name emp_contact

lb generate-controlfile -output-file controller-blank.xml

cd ..

```


# Setup our v1.1 change

Look at the contorll file and the related SQL and XML files


## apply v1.1 to Test

We will now connect to our test system and apply the v1.1 update.

```sql

connect hr_tst/hr_tst_pa55wd@//srvr08/pdb1

cd v1.1

lb update -changelog-file controller.xml

lb tag -tag v1.1

cd ..

```

## Verify v1.1 is applied

Lets verify that we have our new table and it has data in it.

```sql
tables2

select count(1) from emp_contact;

```

## Lets test our new procedure.

```sql


exec upd_emp_contact_proc(100,'I','employee1');

select * from emp_contact where employee_id = 100;

exec upd_emp_contact_proc(100,'P','555-3333');

select * from emp_contact where employee_id = 100;

rollback;

```

## apply v1.2 to test

We will now test an already developed v1.2 code.

```sql
connect hr_tst/hr_tst_pa55wd@//srvr08/pdb1

cd v1.2

lb update -changelog-file controller.xml
lb tag -tag v1.2
cd ..

```


## Test or v1.2 code make sure it works

Lets try the new code and verify it works.

```sql
employees_view

exec upd_emp_contact_proc(100,'I','employee1');

select * from emp_contact where employee_id = 100;

rollback;

```

## lets rollback the change

Rollback the change as it's not needed

```sql

cd v1.2

lb rollback -changelog-file controller.xml -tag v1.1

cd ..

```

## Verify that the rollback

Lets verify the rollback is completed

```sql

exec upd_emp_contact_proc(100,'I','employee1');

desc employees_view;

```

# apply v1.1 to production

While we are still developing v1.2 and v1.3, business has approved v1.1 to move to production.

```sql

connect hr_prd/hr_prd_pa55wd@//srvr08/pdb1

cd v1.1
lb update -changelog-file controller.xml
lb tag -tag v1.1
cd ..

```

# Genreate a table change

Lets make a change to the employee table and then generate a change for that.

```sql
connect hr_dev/hr_dev_pa55wd@//srvr08/pdb1

ALTER TABLE employees ADD pref_contact CHAR(1);

cd workarea
lb generate-db-object -object-type table -object-name employees
cd ..

```

## Apply change to test

lets apply the draft v1.3 change to test, note we have not applied v1.2.

```sql
connect hr_tst/hr_tst_pa55wd@//srvr08/pdb1

cd v1.3

lb update -changelog-file employees_table.xml
cd ..

```

## Rollback v1.3

```sql
connect hr_tst/hr_tst_pa55wd@//srvr08/pdb1

cd v1.3
lb rollback -changelog-file employees_table.xml -tag v1.1
cd ..

```

## Preview a change

Lets preview the SQL for a change

```sql
connect hr_tst/hr_tst_pa55wd@//srvr08/pdb1

cd v1.3

lb update-sql -changelog-file employees_table.xml
cd ..

DISCONNECT;

```



# Refresh test and apply all changes

Now lets refresh test and apply all the changes we have done so far.
From the command line of the database server:

```bash
cd setup

./refresh_tst.sh

```

Then from SQLcl run:

```sql
connect hr_tst/hr_tst_pa55wd@//srvr08/pdb1

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

# END
